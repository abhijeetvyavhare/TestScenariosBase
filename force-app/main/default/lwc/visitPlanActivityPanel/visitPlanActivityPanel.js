import { LightningElement, api, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { getRecord, updateRecord } from 'lightning/uiRecordApi';
import { createRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import { getBarcodeScanner } from "lightning/mobileCapabilities";
import { reduceErrors } from 'c/utils';
import { getLocationService } from 'lightning/mobileCapabilities';
import FORM_FACTOR from '@salesforce/client/formFactor'
import postQueuedValues from '@salesforce/apex/VisitPlanController.postQueuedValues';
import getVisitTasks from '@salesforce/apex/VisitPlanController.getVisitTasks';
import uploadFile from '@salesforce/apex/VisitPlanController.uploadFile'

const OBJECT_DELIVERYORDER = 'dmpl__DeliveryOrder__c';
const FIELD_PARTNERACCOUNTID = 'dmpl__PartnerAccountId__c';
const FIELD_ACCOUNTID = 'dmpl__AccountId__c';
const DELAY = 500;

export default class ServiceAppointmentPanel extends NavigationMixin(LightningElement) {
    @api title;
    @api noDataMessage;
    @api errors;
    @api 
    get objectApiName() {
        return this._objectApiName;
    }
    set objectApiName(value) {
        this._objectApiName = value;
        if(this._objectApiName == 'dmpl__Visit__c'){
            this.visitId = this._recordId;
        }
    }
    
    @api
    get recordId() {
        return this._recordId;
    }
    set recordId(value) {
        this._recordId = value;
        if(this._objectApiName == 'dmpl__Visit__c'){
            this.visitId = this._recordId;
        }
    }
    _recordId;
    _objectApiName;
    visitId;
    acceptedFormats = ['.png','.jpg','.jpeg'];
    acceptedFormatForFile = ['.pdf','.xml','.csv','xmlx'];
    picklistValue = [{label: 'test', value : 'test'}];
    
    isLoading = false;
    loadingCount =0;
    updatedRecords = [];
    canStartVisit;
    canEndVisit;
    visitLocationService;

    @track useRecordId;
    @track useTemplateId;
    @track useObjectApiName;
    @track showChecklist;
    @track isChecklistReadonly;

    @track visitTasks = [];


    @wire(getRecord, { recordId: '$recordId', fields: '$getRecordFields' })
    wiredHostRecord({ error, data }) {
        if(data && this._objectApiName != 'dmpl__Visit__c'){
            this.visitId = data.fields.VisitId__c?.value;
        }
    }

    @wire(getVisitTasks, {
        recordId: '$visitId'
    }) wiredRecord(wiredVisitTasks) {
        this.wiredVisitTasks = wiredVisitTasks;
        const { data, error } = wiredVisitTasks;
        if (data && data.length > 0) {
            this.errors = undefined;
            let lineNumber = 0;
            let expandedRows = Array.from(this.visitTasks?.filter(t=> t.isExpanded).map(t=>t.value));
            let lastTaskCompleted = true;
            let visitTasks = data.map(task => {
                let isExpanded = true || task?.dmpl__Status__c == 'Completed' 
                    || expandedRows?.includes(task.Id);
                lineNumber += 1;
                let canBeStarted = ((!task?.dmpl__Status__c)
                        || task?.dmpl__Status__c == 'Planned' 
                        || task?.dmpl__Status__c == 'Cancelled')
                    && task?.dmpl__VisitId__r?.dmpl__VisitStatus__c == 'Started'
                    && (task?.dmpl__VisitTaskTemplateEntryId__r?.dmpl__CanExecuteOutOfSequence__c || lastTaskCompleted);
                lastTaskCompleted = task?.dmpl__Status__c == 'Completed' || task?.dmpl__Status__c == 'Cancelled'; 
                let isTaskVisible = true;
                let t= {
                    value: task.Id,
                    lineSequence : lineNumber,
                    navigationLink: '/' + task.Id,
                    name: task.Name,
                    duration: task?.dmpl__Duration__c ? task?.dmpl__Duration__c : task.dmpl__VisitTaskTemplateEntryId__r?.dmpl__TaskDuration__c,
                    description : task.dmpl__VisitTaskTemplateEntryId__r?.dmpl__Description__c,
                    isMandatory : task.dmpl__VisitTaskTemplateEntryId__r?.dmpl__IsMandatory__c,
                    canExecuteOutOfSequence : task.dmpl__VisitTaskTemplateEntryId__r?.dmpl__CanExecuteOutOfSequence__c,
                    endTime: this.convertToTime(task?.dmpl__EndTime__c),
                    plannedDuration: task?.dmpl__PlannedDuration__c,
                    plannedEndTime: this.convertToTime(task?.dmpl__PlannedEndTime__c),
                    plannedStartTime: this.convertToTime(task?.dmpl__PlannedStartTime__c),
                    sequenceNumber: task?.dmpl__SequenceNumber__c,
                    startTime: this.convertToTime(task?.dmpl__StartTime__c),
                    status: task?.dmpl__Status__c,
                    taskType: task?.dmpl__TaskType__c,
                    visitId: task?.dmpl__VisitId__c,
                    deliveryOrderId: task?.dmpl__DeliveryOrderId__c,
                    deliveryOrderName: task?.dmpl__DeliveryOrderId__r?.Name,
                    deliveryOrderLink: '/' + task?.dmpl__DeliveryOrderId__c,
                    isCompleted: task?.dmpl__Status__c == 'Completed',
                    isPlanned: task?.dmpl__Status__c == 'Planned',
                    isStarted: task?.dmpl__Status__c == 'Started',
                    isTaskDisabled: task?.dmpl__Status__c != 'Started' 
                        || task?.dmpl__VisitId__r?.dmpl__VisitStatus__c != 'Started',
                    isTaskVisible: isTaskVisible,
                    isExpanded: isExpanded,
                    canBeStarted : canBeStarted,
                    canBeEnded : task?.dmpl__Status__c == 'Started' 
                        && task?.dmpl__VisitId__r?.dmpl__VisitStatus__c == 'Started',
                    contentClass : isExpanded ? 'slds-summary-detail slds-is-open' : 'slds-summary-detail',
                    taskName : task?.dmpl__TaskName__c ? task?.dmpl__TaskName__c : task.Name,
                    partnerAccountId : task?.dmpl__VisitId__r?.dmpl__PartnerAccountId__c,
                    accounntId : task?.dmpl__VisitId__r?.dmpl__AccountId__c,
                    branchId :  task?.dmpl__VisitId__r?.dmpl__BranchId__c,
                    visitStatus :  task?.dmpl__VisitId__r?.dmpl__VisitStatus__c,
                    activities: task.dmpl__VisitTaskActivities__r?.map(activity => {
                        let isPicklist = activity.dmpl__VisitTaskTemplateActivityId__r?.dmpl__PicklistValues__c != undefined
                            || activity.dmpl__VisitTaskTemplateActivityId__r?.PicklistValues__c != undefined;
                        let picklistValues = activity.dmpl__VisitTaskTemplateActivityId__r?.dmpl__PicklistValues__c != undefined ? 
                            activity.dmpl__VisitTaskTemplateActivityId__r?.dmpl__PicklistValues__c : activity.dmpl__VisitTaskTemplateActivityId__r?.PicklistValues__c;
                        let isComboBox = isPicklist && (picklistValues?.split(',').length > 3 || picklistValues?.length > 20);
                        let a = {
                            value: activity.Id,
                            name: activity.Name,
                            status: activity.dmpl__Status__c,
                            isMandatory : activity.dmpl__VisitTaskTemplateActivityId__r?.dmpl__IsMandatory__c,
                            immediatePosting : activity.dmpl__VisitTaskTemplateActivityId__r?.ImmediatePosting__c,
                            isHidden : activity.dmpl__IsHidden__c,
                            isDisabled :  activity.dmpl__IsDisabled__c,
                            sequenceNumber: activity.dmpl__SequenceNumber__c,
                            activityName: activity.dmpl__ActivityName__c,
                            activityType : activity.dmpl__ActivityType__c,
                            plannedDuration : activity.dmpl__PlannedDuration__c,
                            plannedStartTime : activity.dmpl__PlannedStartTime__c,
                            plannedEndTime: activity.dmpl__PlannedEndTime__c,
                            startTime : activity.dmpl__StartTime__c,
                            endTime : activity.dmpl__EndTime__c,
                            duration : activity.dmpl__Duration__c,
                            emailValue : activity.dmpl__Email__c,
                            phoneValue : activity.dmpl__Phone__c,
                            longTextValue : activity.dmpl__LongTextValue__c,
                            textValue : activity.dmpl__TextValue__c,
                            booleanValue : activity.dmpl__BooleanValue__c && activity.dmpl__BooleanValue__c != null,
                            decimalValue : activity.dmpl__DecimalValue__c,
                            numericValue : activity.dmpl__NumericValue__c,
                            dateValue : activity.dmpl__Date__c,
                            dateTimeValue : activity.dmpl__DateTimeValue__c,
                            currencyValue : activity.dmpl__CurrencyValue__c,
                            urlValue : activity.dmpl__URL__c,
                            geolocationValue : activity.dmpl__GeolocationValue__c,
                            fieldName : activity.dmpl__FieldName__c,
                            fieldValue : activity.dmpl__FieldValue__c,
                            isBoolean : (!isPicklist) && activity.dmpl__ActivityType__c == 'Record Boolean Value',
                            isText : (!isPicklist) && activity.dmpl__ActivityType__c == 'Record Text Value' || activity.dmpl__ActivityType__c == 'Record Long Text Value',
                            isNumeric : (!isPicklist) && activity.dmpl__ActivityType__c == 'Record Numeric Value',
                            isDate : activity.dmpl__ActivityType__c == 'Record Date Value',
                            isDecimal : (!isPicklist) && activity.dmpl__ActivityType__c == 'Record Decimal Value',
                            isCurrency : (!isPicklist) && activity.dmpl__ActivityType__c == 'Record Currency Value',
                            isDateTime : activity.dmpl__ActivityType__c == 'Record Date Time Value',
                            isPhone : activity.dmpl__ActivityType__c == 'Record Phone',
                            isURL : activity.dmpl__ActivityType__c == 'Record URL',
                            isEmail : activity.dmpl__ActivityType__c == 'Record Email',
                            isAttachment : activity.dmpl__ActivityType__c == 'Add Attachment',
                            isPhoto : activity.dmpl__ActivityType__c == 'Take Picture',
                            isVideo : activity.dmpl__ActivityType__c == 'Record Video',
                            isCaptureGeolocation : activity.dmpl__ActivityType__c == 'Capture Geolocation',
                            isCaptureDateTimeStamp : activity.dmpl__ActivityType__c == 'Capture Date Time Stamp',
                            isScanCode : activity.dmpl__ActivityType__c == 'Scan QR Code',
                            isCreateObject : activity.dmpl__ActivityType__c == 'Create Object',
                            isUpdateField : activity.dmpl__ActivityType__c == 'Update Field',
                            isViewReport : activity.dmpl__ActivityType__c == 'View Report',
                            isViewDashboard : activity.dmpl__ActivityType__c == 'View Dashboard',
                            isPerformAction : activity.dmpl__ActivityType__c == 'Perform Action',
                            isChecklist : activity.dmpl__ActivityType__c == 'Checklist',
                            isPicklistValue : isPicklist,
                            isComboBox : isComboBox,
                            isObjectCreated : this.isObjectCreated(activity),
                            objectName : activity.dmpl__ObjectName__c,
                            objectRecordId : this.getObjectRecordId(activity),
                            picklistValues : (isComboBox ? [{ label: 'choose one...', value: '' }] : []).concat(picklistValues?.split(',').map(v=>
                                {return  { label: v?.trim(), value: v?.trim() }}))
                        }
                        a.isActivityCompleted = this.isActivityCompleted(a); 
                        if(a.geolocationValue){
                            a.geolocationValuePair = a.geolocationValue.latitude + ', ' + a.geolocationValue.longitude;
                        }else {
                            a.geolocationValuePair = a.activityName;
                        }            
                        return a;
                    })
                }
                t.isEndDisabled = t.activities?.filter(activity=> 
                    !activity.isHidden && activity.isMandatory && !activity.isActivityCompleted).length > 0;
                return t;
            });
            this.visitTasks = visitTasks;
            this.setVisitStatus();
        } else if (error) {
            this.errors = error;
            this.visitTasks = undefined;
        }
    }

    get getRecordFields(){
        return [this.objectApiName + '.' + 'VisitId__c'];
    }

    get getFieldToScanFor() {
        if (this.getScanFieldsetFields && this.getScanFieldsetFields.length > 0) {
            return this.getScanFieldsetFields[this.getScanFieldsetFields.length - 1];
        }
    }

    get isCameraAvailable() {
        if(!this.myScanner){
            this.myScanner = getBarcodeScanner();
        }
        return this.myScanner && this.myScanner.isAvailable();
    }

    get isMobileView(){
        return FORM_FACTOR == 'Small';
    } 
    
    get isServiceAppointment(){
        return this._objectApiName == 'ServiceAppointment';
    }

    connectedCallback() {
        this.visitLocationService = getLocationService();
    }

    isActivityCompleted(a){
        return (a.dmpl__Status__c == 'Completed' || a.dmpl__Status__c == 'Cancelled'
            || a.status == 'Completed' || a.status == 'Cancelled') &&
            a.isBoolean ? a.booleanValue != undefined : 
            a.isCaptureDateTimeStamp || a.isDateTime ? (a.dateValue && a.dateTimeValue != undefined):
            a.isAttachment || a.isPhone || a.isVideo ? false :
            a.isChecklist ? a.booleanValue == true :
            a.isCaptureGeolocation ? a.geolocationValue != undefined || a.dateTimeValue != undefined:
            a.isCreateObject ? a.objectRecordId != undefined :
            a.isCurrency ? (a.currencyValue && a.currencyValue != undefined):
            a.isDate ? (a.dateValue && a.dateValue!= undefined) :
            a.isDecimal ? (a.decimalValue && a.decimalValue != undefined) :
            a.isEmail ? (a.emailValue && a.emailValue != undefined) :
            a.isNumeric ? (a.numericValue && a.numericValue != undefined) :
            a.isPerformAction ? true :
            a.isPhone ? (a.phoneValue && a.phoneValue != undefined) :
            a.isText || a.isScanCode ? (a.textValue && a.textValue!= undefined):
            a.isURL ? a.urlValue != undefined : true
    }

    isObjectCreated(activity){
        return activity.dmpl__ObjectName__c == 'dmpl__SaleOrder__c' ? activity.dmpl__SaleOrderId__c !=null : 
            activity.dmpl__ObjectName__c == 'dmpl__SaleInvoice__c' ? activity.dmpl__InvoiceId__c !=null  :
            activity.dmpl__ObjectName__c == 'dmpl__Payment__c' ? activity.dmpl__PaymentId__c !=null  :
            activity.dmpl__ObjectName__c == 'dmpl__ProductDemo__c' ? activity.dmpl__ProductDemoId__c !=null  :
            activity.dmpl__ObjectName__c == 'dmpl__RepairOrder__c' ? activity.dmpl__RepairOrderId__c !=null  :
            activity.dmpl__ObjectName__c == 'dmpl__DeliveryOrder__c' ? activity.dmpl__DeliveryOrderId__c!=null  : false;
    }

    getObjectRecordId(activity){
        return activity.dmpl__ObjectName__c == 'dmpl__SaleOrder__c' ? activity.dmpl__SaleOrderId__c : 
            activity.dmpl__ObjectName__c == 'dmpl__SaleInvoice__c' ? activity.dmpl__InvoiceId__c :
            activity.dmpl__ObjectName__c == 'dmpl__Payment__c' ? activity.dmpl__PaymentId__c :
            activity.dmpl__ObjectName__c == 'dmpl__ProductDemo__c' ? activity.dmpl__ProductDemoId__c :
            activity.dmpl__ObjectName__c == 'dmpl__RepairOrder__c' ? activity.dmpl__RepairOrderId__c :
            activity.dmpl__ObjectName__c == 'dmpl__DeliveryOrder__c' ? activity.dmpl__DeliveryOrderId__c : null;
    }

    setVisitStatus(status){
        if(!this.visitTasks || this.visitTasks.length == 0){
            return;
        }
        let visitStatus = status;
        if(!status){
            let task = this.visitTasks[0];
            visitStatus = task.visitStatus;
        }else{
            this.visitTasks.forEach(t=> {
                t.visitStatus = status;
                this.setTaskStatus(t.value);
            });
        }
        this.canStartVisit =  (!visitStatus) 
            || visitStatus == 'Planned' 
            || visitStatus == 'Assigned';
        this.canEndVisit = visitStatus == 'Started' && this.visitTasks.filter(t=>t.isMandatory 
                && t.status != 'Completed' 
                && t.status != 'Cancelled').length == 0;
    }
    
    setTaskStatus(taskId, status){
        if(!this.visitTasks || this.visitTasks.length == 0){
            return;
        }
        let tasks = this.visitTasks.slice();
        let task = tasks.find(v=>v.value == taskId);
        if(task){
            let lastTask = tasks[tasks.indexOf(task)-1];
            let lastTaskCompleted = lastTask == undefined || lastTask?.status == 'Completed' || lastTask?.status == 'Cancelled'; 
            if(status){
                task.status = status;
            }
            task.isCompleted = task?.status == 'Completed';
            task.isPlanned = task?.status == 'Planned';
            task.isStarted = task?.status == 'Started';
            task.canBeStarted = ((!task?.status)
                        || task?.status == 'Planned' 
                        || task?.status == 'Cancelled')
                    && task?.visitStatus == 'Started'
                    && (task?.canExecuteOutOfSequence || lastTaskCompleted);
            task.canBeEnded = task?.status == 'Started';
            task.isTaskDisabled = task?.status != 'Started' || task?.visitStatus != 'Started';
            task.isEndDisabled = task.activities?.filter(activity=> 
                !activity.isHidden && activity.isMandatory && !activity.isActivityCompleted).length > 0;
            if(task.isCompleted){
                let nextTask = tasks[tasks.indexOf(task)+1];
                if(nextTask){
                    nextTask.canBeStarted = ((!nextTask?.status)
                        || nextTask?.status == 'Planned' 
                        || nextTask?.status == 'Cancelled')
                    && nextTask?.visitStatus == 'Started';
                }
            }
        }
        this.visitTasks = tasks;
    }
    
    setActivityValue(activityId, fieldName, fieldValue){
        let activty = undefined;
        const task = this.visitTasks.find(task => {
            activty = task.activities?.find(a=>a.value == activityId);
            return activty !=null;
        });
        if(activty){
            activty[fieldName] = fieldValue;
        }
        this.visitTasks = this.visitTasks.slice();
    }
    
    setActivityStatus(activityId, fieldName, fieldValue){
        let activty = undefined;
        const task = this.visitTasks.find(task => {
            activty = task.activities?.find(a=>a.value == activityId);
            return activty !=null;
        });
        if(activty){
            activty.status = 'Completed';
            if(fieldName == 'dmpl__Email__c'){
                activty.emailValue = fieldValue;
            } else if(fieldName == 'dmpl__Phone__c'){
                activty.phoneValue = fieldValue;
            } else if(fieldName == 'dmpl__LongTextValue__c'){
                activty.longTextValue = fieldValue;
            } else if(fieldName == 'dmpl__TextValue__c'){
                activty.textValue = fieldValue;
            } else if(fieldName == 'dmpl__BooleanValue__c'){
                activty.booleanValue = fieldValue;
            } else if(fieldName == 'dmpl__DecimalValue__c'){
                activty.decimalValue = fieldValue;
            } else if(fieldName == 'dmpl__NumericValue__c'){
                activty.numericValue = fieldValue;
            } else if(fieldName == 'dmpl__Date__c'){
                activty.dateValue = fieldValue;
            } else if(fieldName == 'dmpl__DateTimeValue__c'){
                activty.dateTimeValue = fieldValue;
            } else if(fieldName == 'dmpl__CurrencyValue__c'){
                activty.currencyValue = fieldValue;
            } else if(fieldName == 'dmpl__URL__c'){
                activty.urlValue = fieldValue;
            } else if(fieldName == 'dmpl__GeolocationValue__c'){
                activty.geolocationValue = fieldValue;
            }
            activty.fieldName = fieldName;
            activty.fieldValue = fieldValue;
            activty.isActivityCompleted = this.isActivityCompleted(activty);
        }
        if(task){
            task.isEndDisabled = task.activities?.filter(activity=> 
            !activity.isHidden && activity.isMandatory && !activity.isActivityCompleted).length > 0;
        }
        this.visitTasks = this.visitTasks.slice();
    }

    handleCreateObjectClick(event){
        let activityId = event.target.dataset.recordId;
        if(activityId){
            this.visitTasks.forEach(task => {
                let activity = task.activities?.find(a=>a.value == activityId);
                if(activity){
                    this.createObject(task, activity);
                    return;
                }
            });
        }
    }

    async handleImageUploadFinished(event) {
        try {
            let activityId = event.target.dataset?.recordId;
            const file = event.target?.files?.length >0 ? event.target.files[0] : null;
            if(!file || !activityId){
                return;
            }
            await this.setLoadingCount(1);

            //Compress file
            let img = new Image();
            img.onload = () => {
                debugger;
                let canvas = document.createElement('canvas');
                let width = img.width;
                let height = img.height;
                canvas.width = width;
                canvas.height = height;
                let ctx = canvas.getContext("2d");
                ctx.drawImage(img, 0, 0, width, height);
                let compressedImage = canvas.toDataURL('image/jpeg', 0.4);
                const {base64, filename, recordId} = {
                    'filename': file.name,
                    'base64': compressedImage.split(',')[1],
                    'recordId': activityId
                }
                uploadFile({ base64, filename, recordId }).then(result=>{
                    this.showSuccess('Success', `${filename} uploaded successfully!!`);
                    this.updateFieldValue(activityId, 'dmpl__TextValue__c', file.name, true);
                    this.setLoadingCount(-1);
                }).catch(error =>{
                    this.setLoadingCount(-1);
                    this.showError(error);
                });

                console.log(this.fileData)
            }
            img.src = URL.createObjectURL(file); 
        } catch (error) {
            await this.setLoadingCount(-1);
        }
    }

    async handleUploadFinished(event) {
        try {
            let activityId = event.target.dataset?.recordId;
            const file = event.target?.files?.length >0 ? event.target.files[0] : null;
            if(!file || !activityId){
                return;
            }
            await this.setLoadingCount(1);            
            var reader = new FileReader()
            reader.onload = () => {
                const {base64, filename, recordId} = {
                    'filename': file.name,
                    'base64': reader.result.split(',')[1],
                    'recordId': activityId
                }
                uploadFile({ base64, filename, recordId }).then(result=>{
                    this.showSuccess('Success', `${filename} uploaded successfully!!`);
                    this.updateFieldValue(activityId, 'dmpl__TextValue__c', file.name, true);
                    this.setLoadingCount(-1);
                }).catch(error =>{
                    this.setLoadingCount(-1);
                    this.showError(error);
                });
            }
            reader.readAsDataURL(file)   
        } catch (error) {
            await this.setLoadingCount(-1);
        }
    }

    async handleGeoLocationCapture(event){
        let activityId = event.target.dataset.recordId;
        if (this.visitLocationService != null && this.visitLocationService.isAvailable()) {
            try {
                //await this.setLoadingCount(1);
                const result = await this.visitLocationService.getCurrentPosition({ enableHighAccuracy: true });
                const fields = {};
                fields['dmpl__GeolocationValue__Latitude__s'] = result?.coords?.latitude;
                fields['dmpl__GeolocationValue__Longitude__s'] = result?.coords?.longitude;
                this.updateFieldValues(activityId, fields, true);
                this.setActivityValue(activityId, 'geolocationValuePair', result?.coords?.latitude + ', ' + result?.coords?.longitude);
                //this.setLoadingCount(-1);
            } catch (error) {
                //this.setLoadingCount(-1);
                console.error(error);
                this.setDummyLocation(activityId);
            }
        } else if (navigator.geolocation && FORM_FACTOR != 'Small') {
            try {
                //await this.setLoadingCount(1);
                const position = await new Promise((resolve, reject) => {
                    navigator.geolocation.getCurrentPosition(resolve, reject, { enableHighAccuracy: false });
                });
                const fields = {};
                fields['dmpl__GeolocationValue__Latitude__s'] = position?.coords?.latitude;
                fields['dmpl__GeolocationValue__Longitude__s'] = position?.coords?.longitude;
                this.updateFieldValues(activityId, fields, true);
                this.setActivityValue(activityId, 'geolocationValuePair', position?.coords?.latitude + ', ' + position?.coords?.longitude);
                //this.setLoadingCount(-1);
            } catch (error) {
                //this.setLoadingCount(-1);
                console.error('Location Service Not Available! Please ensure that the device location settings are enabled. If the problem persists contact your System Administrator. ' + error.message);
                this.setDummyLocation(activityId);
            }
        } else {
            this.setDummyLocation(activityId);
        }
    }

    setDummyLocation(activityId){
        const fields = {};
        fields['dmpl__GeolocationValue__Latitude__s'] = 0;
        fields['dmpl__GeolocationValue__Longitude__s'] = 0;
        this.updateFieldValues(activityId, fields, true);
        this.setActivityValue(activityId, 'geolocationValuePair', '0, 0');
    }

    handleViewObjectClick(event){
        let activityId = event.target.dataset.recordId;
        if(activityId){
            this.visitTasks.forEach(task => {
                let activity = task.activities?.find(a=>a.value == activityId);
                if(activity){
                    this.navigateTo(activity.objectName, activity.objectRecordId);
                    return;
                }
            });
        }
    }

    handleChecklistClick(event){
        let activityId = event.target.dataset.recordId;
        this.activeChecklistTarget = activityId;
        if(activityId){
            this.visitTasks.forEach(task => {
                let activity = task.activities?.find(a=>a.value == activityId);
                if(activity){
                    this.useRecordId = activityId;
                    this.useObjectApiName = 'dmpl__VisitTaskActivity__c';
                    this.showChecklist = true;
                    this.isChecklistReadonly = task.isTaskDisabled;
                    return;
                }
            });
        }
    }
    
    handleCloseChecklistClick(event){
        if(!event?.detail?.isCancel){
            this.updateFieldValue(this.activeChecklistTarget, 'dmpl__BooleanValue__c', event?.detail?.isMandatoryFilled, true);
        }
        this.showChecklist = false;
        this.useRecordId = undefined;
        this.useObjectApiName = undefined;
        if(this.activeChecklistTarget){
            let div = this.template.querySelector(`[data-record-id="${this.activeChecklistTarget}"]`)
            if(div){
                div.scrollIntoView({behavior: "smooth", block: "center", inline: "nearest"});
            }
        }
    }

    handleBeginScanClick(event) {
        let taskId = event.target.dataset.recordId;
        const scanFieldToUse = this.getFieldToScanFor;
        if(!this.myScanner){
            this.myScanner = getBarcodeScanner();
        }
        if (!this.myScanner || !scanFieldToUse) {
            return;
        }
        const scanningOptions = {
            barcodeTypes: [this.barCodeType ? this.barCodeType : this.myScanner.barcodeTypes.QR]
        };
        this.myScanner
            .beginCapture(scanningOptions)
            .then((result) => {
                this.updateFieldValue(
                    taskId,
                    scanFieldToUse?.apiName,
                    result.value,
                    true
                )
            })
            .catch((error) => {
                if (error && error.code && error.code == 'USER_DISMISSED') {
                    console.error(error);
                } else {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Scan Failed',
                            message:
                                'Scan Failed : ' +
                                JSON.stringify(error),
                            variant: 'warning',
                            mode: 'sticky'
                        })
                    );
                }
            })
            .finally(() => {
                this.myScanner.endCapture();
            });
        }
    
    handleTextChange(event){
        let taskId = event.target.dataset.recordId;
        this.updateFieldValue(taskId, 'dmpl__TextValue__c', event.target.value, true);
    }

    handleNumericChange(event){
        let taskId = event.target.dataset.recordId;
        this.updateFieldValue(taskId, 'dmpl__NumericValue__c', event.target.value, true);
    }

    handleEmailChange(event){
        let taskId = event.target.dataset.recordId;
        this.updateFieldValue(taskId, 'dmpl__Email__c', event.target.value, true);
    }

    handlePhoneChange(event){
        let taskId = event.target.dataset.recordId;
        this.updateFieldValue(taskId, 'dmpl__Phone__c', event.target.value, true);
    }

    handleLongTextChange(event){
        let taskId = event.target.dataset.recordId;
        this.updateFieldValue(taskId, 'dmpl__LongTextValue__c', event.target.value, true);
    }

    handleBooleanChange(event){
        let taskId = event.target.dataset.recordId;
        this.updateFieldValue(taskId, 'dmpl__BooleanValue__c', event.target.checked, true);
    }

    handleDecimalChange(event){
        let taskId = event.target.dataset.recordId;
        this.updateFieldValue(taskId, 'dmpl__DecimalValue__c', event.target.value, true);
    }

    handleDateChange(event){
        let taskId = event.target.dataset.recordId;
        this.updateFieldValue(taskId, 'dmpl__Date__c', event.target.value, true);
    }

    handleDateTimeChange(event){
        let taskId = event.target.dataset.recordId;
        this.updateDateTimeValue(taskId, 'dmpl__DateTimeValue__c', event.target.value, true);
    }

    handleCurrencyChange(event){
        let taskId = event.target.dataset.recordId;
        this.updateFieldValue(taskId, 'dmpl__CurrencyValue__c', event.target.value, true);
    }

    handleUrlChange(event){
        let taskId = event.target.dataset.recordId;
        this.updateFieldValue(taskId, 'dmpl__URL__c', event.target.value, true);
    }

    handleGeoLocationChange(event){
        let taskId = event.target.dataset.recordId;
        this.updateFieldValue(taskId, 'dmpl__GeolocationValue__c', event.target.value, true);
    }
    
    handleTaskStart(event){
        let taskId = event.target.dataset.recordId;
        this.updateFieldValue(taskId, 'dmpl__Status__c', 'Started', false);
        this.setTaskStatus(taskId, 'Started');
    }
    
    handleTaskEnd(event){
        let taskId = event.target.dataset.recordId;
        this.updateFieldValue(taskId, 'dmpl__Status__c', 'Completed', false);
        this.setTaskStatus(taskId, 'Completed');
    }

    handleTaskCancel(event){
        let taskId = event.target.dataset.recordId;
        this.updateFieldValue(taskId, 'dmpl__Status__c', 'Cancelled', false);
        this.setTaskStatus(taskId, 'Cancelled');
    }

    handleStartVisitClick(){
        this.updateFieldValue(this.visitId, 'dmpl__VisitStatus__c', 'Started', false);
        this.setVisitStatus('Started');
    }

    handleEndVisitClick(){
        this.updateFieldValue(this.visitId, 'dmpl__VisitStatus__c', 'Completed', false);
        this.setVisitStatus('Completed');
    }

    handleExpandClick(event){
        this.toggleTaskPanel(event.target?.name);
    }

    updateDateTimeValue(recordId, fieldName, fieldValue, postDateTime){
        const fields = {};
        fields['Id'] = recordId;
        fields[fieldName] = fieldValue;
        this.updateDateTimeValues(recordId, fields, postDateTime);
    }

    updateDateTimeValues(recordId, fields, postDateTime){
        let record = this.updatedRecords.find(v=>v.Id == recordId);
        if(!record){
            fields['Id'] = recordId;
            record = fields;
        }else {
            this.updatedRecords = this.updatedRecords.filter(v=>v.Id != recordId);
            for(var field in fields){
                record[field] = fields[field];
            }
        }

        this.updateDateTimeIfNeeded(record, postDateTime);

       
        this.updatedRecords.push(record);
        this.postFieldValues(recordId);
        for(var field in fields){
            this.setActivityStatus(recordId, field, fields[field]);
        }
        const taskId = this.visitTasks.find(task => task.activities?.find(a=>a.value == recordId) != null)?.value;
        if(taskId){
            this.setTaskStatus(taskId);
        }
    }
    updateDateTimeIfNeeded(record, postDateTime) {
        if (postDateTime) {
            const currentDateTime = new Date();
            const formattedDateTime = currentDateTime.toISOString(); // Extract YYYY-MM-DD from ISO string
            record['dmpl__DateTimeValue__c'] = formattedDateTime;
        }
    }

    updateFieldValue(recordId, fieldName, fieldValue, postDate){
        const dateVals = {};
        dateVals['Id'] = recordId;
        dateVals[fieldName] = fieldValue;
        this.updateFieldValues(recordId, dateVals,postDate);
    }


    updateFieldValues(recordId, dateVals, postDate) {
        let record = this.updatedRecords.find(v => v.Id == recordId);
        if (!record) {
            dateVals['Id'] = recordId;
            record = dateVals;
        } else {
            this.updatedRecords = this.updatedRecords.filter(v => v.Id != recordId);
            for (var dateVal in dateVals) {
                record[dateVal] = dateVals[dateVal];
            }
        }

        this.updateDateIfNeeded(record, postDate);

        this.updatedRecords.push(record);
        this.postFieldValues(recordId);
        for(var dateVal in dateVals){
            this.setActivityStatus(recordId, dateVal, dateVals[dateVal]);
        }
        const taskId = this.visitTasks.find(task => task.activities?.find(a=>a.value == recordId) != null)?.value;
        if(taskId){
            this.setTaskStatus(taskId);
        }
    }

    // Function to update date field if needed
    updateDateIfNeeded(record, postDate) {
        if (postDate) {
            const currentDate = new Date();
            const formattedDate = currentDate.toISOString().split('T')[0]; // Extract YYYY-MM-DD from ISO string
            record['dmpl__Date__c'] = formattedDate;
        }
    }




    postFieldValues(recordId){
        try {
            this.setLoadingCount(1);
            let record = this.updatedRecords.find(v=>v.Id == recordId);
            if(!record){
                this.showError('Record Not Found!');
                return;
            }
            
            postQueuedValues({ data : [record] })
                .then(async(result) => {
                    this.setLoadingCount(-1);
                    if(result){
                        this.updatedRecords = this.updatedRecords.filter(v=>v.Id != recordId);
                        refreshApex(this.wiredVisitTasks);    
                    }else{
                        this.showError('Error Saving Record');    
                    }
                })
                .catch(error => {
                    if(this.isNetworkError(error) && FORM_FACTOR == 'Small'){
                        this.postFieldValuesQueued(record);
                    }else {
                        this.setLoadingCount(-1);
                        this.showError(error);
                        refreshApex(this.wiredVisitTasks);
                    }
                });
        } catch (error) {
            this.setLoadingCount(-1);
        }    
    }

    postFieldValuesQueued(record){
        try {
            this.showWarning('Error while saving your data. Queuing for offline processing!');
            updateRecord({ fields : record })
                .then(async(result) => {
                     this.setLoadingCount(-1);
                    this.updatedRecords = this.updatedRecords.filter(v=>v.Id != record.Id);
                })
                .catch(error => {
                     this.setLoadingCount(-1);
                    this.showError(error);
                });

        } catch (error) {
            this.setLoadingCount(-1);
        }    
    }

    isNetworkError(error){
        const msg = reduceErrors(error);
        return msg?.includes('Disconnected')
             || msg?.includes('Canceled')
             || msg?.includes('Network')
             || msg?.includes('SalesforceSDKCore.RestClientError');
    }

    isImmediatePost(recordId){
        return this.visitTasks.find(v=> {
            let activity = v.activities?.find(v=>v.value == recordId);
            if(activity){
                return activity.immediatePosting;
            }
        });
    }

    async setLoadingCount(value){
        this.loadingCount = this.loadingCount + value;
        if(this.loadingCount <0){
            this.loadingCount =0;
        }
        this.isLoading = this.loadingCount > 0;
    }

    showSuccess(message, title){
        this.dispatchEvent(
            new ShowToastEvent({
                title: title ? title : 'Success',
                message: message ? message : 'Data updated',
                variant: 'success'
            })
        );
    }

    showError(message, sticky){
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error updating record',
                message: reduceErrors(message),
                variant: 'error',
                mode : 'sticky'
            })
        );
    }

    showWarning(message, title){
        this.dispatchEvent(
            new ShowToastEvent({
                title: title ? title : 'Warning!',
                message: message,
                variant: 'warning'
            })
        );
    }

    toggleTaskPanel(taskName, forceExpand){
        this.visitTasks.forEach(v=>{
            if(v.value == taskName){
                v.isExpanded = forceExpand == undefined ? (!v.isExpanded) : forceExpand ? forceExpand : false;
            }else if(this.isMobileView){
                v.isExpanded = false;
            }
            v.contentClass = v.isExpanded ? 'slds-summary-detail slds-is-open' : 'slds-summary-detail';
        });
        this.visitTasks = this.visitTasks.slice();
    }

    createObject(task, activity){
        const fields = {};
        fields['dmpl__PartnerAccountId__c'] = task?.partnerAccountId;
        fields['dmpl__BranchId__c'] =  task.branchId;
        fields['dmpl__AccountId__c'] =  task.accounntId;
        const recordInput ={ apiName: activity.objectName, fields };

        createRecord(recordInput)
            .then(document => {
                let documentId = document.id;
                this.showSuccess('Document Created Successfully!');
                this.navigateTo(activity.objectName, documentId);
                this.updateFieldValue(activity.value, this.getObjectFieldName(activity.objectName), documentId, true);
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating Invoice',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
            });
    }
    
    getObjectFieldName(objectName){
        if(objectName == 'dmpl__SaleInvoice__c'){
            return 'dmpl__SaleInvoiceId__c';
        }else if(objectName == 'dmpl__SaleOrder__c'){
            return 'dmpl__SaleOrderId__c';
        } else if(objectName == 'dmpl__DeliveryOrder__c'){
            return 'dmpl__DeliveryOrderId__c';
        } else if(objectName == 'dmpl__ProductDemo__c'){
            return 'dmpl__ProductDemoId__c';
        } else if(objectName == 'dmpl__Payment__c'){
            return 'dmpl__PaymentId__c';
        } else if(objectName == 'dmpl__RepairOrder__c'){
            return 'dmpl__RepairOrderId__c';
        } else {
            return objectName.replace('__c', 'Id__c');
        }
    }

    navigateToNew(objectApiName){
        let viewPageRef = {
            type: 'standard__recordPage',
            attributes: {
                objectApiName: objectApiName,
                actionName: 'view'
            }
        };
        this[NavigationMixin.Navigate](viewPageRef);
    }

    navigateTo(objectApiName, recordId){
        let viewPageRef = {
            type: 'standard__recordPage',
            attributes: {
                objectApiName: objectApiName,
                recordId : recordId,
                actionName: 'view'
            }
        };
        this[NavigationMixin.Navigate](viewPageRef);
    }

    convertToTime(milliseconds) {
        if (!milliseconds)
            return '';
        let ms = milliseconds % 1000;
        milliseconds = (milliseconds - ms) / 1000;
        let secs = milliseconds % 60;
        milliseconds = (milliseconds - secs) / 60;
        let mins = milliseconds % 60;
        let hrs = (milliseconds - mins) / 60;
        hrs = hrs < 10 ? '0' + hrs : hrs;
        mins = mins < 10 ? '0' + mins : mins;
        return (hrs > 12 ? (hrs - 12) : hrs) + ':' + mins + ' ' + (hrs > 12 ? 'PM' : 'AM');
    }

}