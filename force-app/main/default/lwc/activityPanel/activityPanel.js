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
import VisitTaskTemplateEntries from '@salesforce/apex/VisitTaskTemplateController.VisitTaskTemplateEntries';
import callDynamicAction from '@salesforce/apex/DynamicCallableController.callDynamicAction';
import uploadFile from '@salesforce/apex/VisitPlanController.uploadFile'
import templateDesktop from './activityPanel.html';
import templateMobile from './activityPanelMobile.html';

const ACCEPTED_IMAGE_FORMATS = ['.png','.jpg','.jpeg'];
const ACCEPTED_FILE_FORMATS = ['.pdf','.xml','.csv','xmlx'];

export default class ActivityPanel extends NavigationMixin(LightningElement) {
    @api title;
    @api taskTemplateId;
    @api controllerName;
    @api noDataMessage;
    @api errors;
    @api 
    get objectApiName() {
        return this._objectApiName;
    }
    set objectApiName(value) {
        this._objectApiName = value;
    }
    
    @api
    get recordId() {
        return this._recordId;
    }
    set recordId(value) {
        this._recordId = value;
    }
    _recordId;
    _objectApiName;
    isLoading = false;
    loadingCount =0;
    updatedRecords = [];
    locationService;
    showChecklist;
    isRecordReadonly;
    checklistRecordId;
    checklistObjectApiName;
    taskTemplate;
    recordData;
    visitTasks;

    @wire(getRecord, { recordId: '$recordId', fields: '$getRecordFields' })
    wiredHostRecord({ error, data }) {
        if(data){
            this.recordData = data;
        }
    }

    @wire(VisitTaskTemplateEntries, {
        recordId: '$taskTemplateId'
    }) wiredRecord(wiredVisitTaskTemplateEntries) {
        this.wiredVisitTaskTemplateEntries = wiredVisitTaskTemplateEntries;
        const { data, error } = wiredVisitTaskTemplateEntries;
        if (data && data.length > 0) {
            this.errors = undefined;
            let lineNumber = 0;
            //let expandedRows = Array.from(this.visitTasks?.filter(t=> t.isExpanded).map(t=>t.value));
            let visitTasks = data.map(task => {
                lineNumber += 1;
                let isExpanded = true;// || expandedRows?.includes(task.Id);
                return {
                    value: task.Id,
                    uid: task.dmpl__UniqueIdentifier__c,
                    lineSequence : lineNumber,
                    navigationLink: '/' + task.Id,
                    name: task.Name,
                    duration: task.dmpl__TaskDuration__c,
                    description : task.dmpl__Description__c,
                    isMandatory : task.dmpl__IsMandatory__c,
                    recordIds : task.dmpl__RecordIds__c,
                    canExecuteOutOfSequence : task.dmpl__CanExecuteOutOfSequence__c,
                    duration: task.dmpl__Duration__c ? task.dmpl__Duration__c + ' mins.' : undefined,
                    sequenceNumber: task.dmpl__SequenceNumber__c,
                    taskType: task.dmpl__TaskType__c,
                    isHidden: task.dmpl__IsHidden__c,
                    isExpanded: isExpanded,
                    contentClass : isExpanded ? 'slds-summary-detail slds-is-open' : 'slds-summary-detail',
                    activities: task.dmpl__VisitTaskTemplateActivities__r?.map(activity => {
                        let isPicklist = activity.dmpl__PicklistValues__c != undefined;
                        let picklistValues = activity.dmpl__PicklistValues__c;
                        let isComboBox = isPicklist && (picklistValues?.split(',').length > 3 || picklistValues?.length > 20);
                        return {
                            value: activity.Id,
                            name: activity.Name,
                            uid: activity.dmpl__UniqueIdentifier__c,
                            isMandatory : activity.dmpl__IsMandatory__c,
                            immediatePosting : activity.ImmediatePosting__c,
                            isHidden : activity.dmpl__IsHidden__c,
                            isDisabled :  activity.dmpl__IsDisabled__c,
                            sequenceNumber: activity.dmpl__SequenceNumber__c,
                            activityType : activity.dmpl__ActivityType__c,
                            duration : activity.dmpl__Duration__c ? activity.dmpl__Duration__c + ' mins.' : undefined,
                            fieldName : activity.dmpl__FieldName__c,
                            fieldValue : activity.dmpl__FieldValue__c,
                            recordId : task.dmpl__RecordId__c,
                            valueLabel: activity.Name,
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
                            isNavigate : activity.dmpl__ActivityType__c == 'Navigate',
                            isUpdateField : activity.dmpl__ActivityType__c == 'Update Field',
                            isViewReport : activity.dmpl__ActivityType__c == 'View Report',
                            isViewDashboard : activity.dmpl__ActivityType__c == 'View Dashboard',
                            isPerformAction : activity.dmpl__ActivityType__c == 'Perform Action',
                            isChecklist : activity.dmpl__ActivityType__c == 'Checklist',
                            isPicklistValue : isPicklist,
                            isComboBox : isComboBox,
                            objectName : activity.dmpl__ObjectApiName__c?activity.dmpl__ObjectApiName__c:activity.dmpl__ObjectName__c,
                            showDetails: activity.dmpl__ShowDetails__c,
                            settings: this.parseSettings(activity),
                            picklistValues : (isComboBox ? [{ label: 'choose one...', value: '' }] : []).concat(picklistValues?.split(',').map(v=>
                                {return  { label: v?.trim(), value: v?.trim() }}))
                        }
                    })
                }
            });
            this.visitTasks = visitTasks.slice();
        } else if (error) {
            this.errors = error;
            this.visitTasks = undefined;
        }
    }

    get getRecordFields(){
        return [this.objectApiName + '.' + 'Name'];
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
    
    render() {
        return this.isMobileView ? templateMobile : templateDesktop;
    }

    connectedCallback() {
        this.locationService = getLocationService();
    }

    parseSettings(activity){
        if(!activity.dmpl__ShowDetails__c && activity.dmpl__ActivityType__c != 'Navigate'){
            return undefined;
        }
        try {
            if(activity.dmpl__Settings__c){
                return JSON.parse(activity.dmpl__Settings__c);
            }
        } catch (error) {
            //ignore
        }
        return {fields:[]};
    }

    setActivityValue(activityId, fieldName, fieldValue){
        let activty = undefined;
        const task = this.visitTasks.find(task => {
            activty = task.activities?.find(a=>a.value == activityId);
            return activty !=null;
        });
        if(activty && activty[fieldName] != fieldValue){
            activty[fieldName] = fieldValue;
            this.visitTasks = this.visitTasks.slice();
        }
    }

    refreshActivityData(result){
        for(const key in result){
            let taskData = this.visitTasks.find(t=>t.value == key || t.name == key || t.uid == key);
            if(taskData){
                for(const fieldName in result[key]){
                    taskData[fieldName] = result[key][fieldName];
                }
            }else{
                let activty = undefined;
                this.visitTasks.find(task => {
                    activty = task.activities?.find(a=>a.value == key || a.name == key || a.uid == key);
                    return activty !=null;
                });
                if(activty){
                    for(const fieldName in result[key]){
                        activty[fieldName] = result[key][fieldName];
                    }
                }
            }
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
                    this.updateFieldValue(activityId, 'updateField', 'fieldValue', file.name);
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
                    this.updateFieldValue(activityId, 'updateField', 'fieldValue', file.name);
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
        if (this.visitLocationService != null && this.visitLocationService.isAvailable()){
            //await this.setLoadingCount(1);
            visitLocationService.getCurrentPosition({ enableHighAccuracy: true })
                .then((result) => {
                    const fields = {};
                    fields['dmpl__GeolocationValue__Latitude__s'] = result?.coords?.latitude;
                    fields['dmpl__GeolocationValue__Longitude__s'] = result?.coords?.longitude;
                    this.updateFieldValues(activityId, fields, true);
                    this.setActivityValue(activityId, 'geolocationValuePair', result?.coords?.latitude + ', ' + result?.coords?.longitude);
                    //this.setLoadingCount(-1);
                })
                .catch((error) => {
                    //this.setLoadingCount(-1);
                    console.error(error);
                    this.setDummyLocation(activityId);
                });
        } else if (navigator.geolocation && FORM_FACTOR != 'Small') {
            //await this.setLoadingCount(1);
            navigator.geolocation.getCurrentPosition(
                (position) => {
                    const fields = {};
                    fields['dmpl__GeolocationValue__Latitude__s'] = position?.coords?.latitude;
                    fields['dmpl__GeolocationValue__Longitude__s'] = position?.coords?.longitude;
                    this.updateFieldValues(activityId, fields, true);
                    this.setActivityValue(activityId, 'geolocationValuePair', position?.coords?.latitude + ', ' + position?.coords?.longitude);
                    //this.setLoadingCount(-1);
                },
                (error) => {
                    //this.setLoadingCount(-1);
                    console.error('Location Service Not Available! Please ensure that the device location settings are enabled. If the problem persists contact your System Administrator. ' + error.message);
                    this.setDummyLocation(activityId);
                },
                {
                    enableHighAccuracy: false,
                });
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
                    this.navigateTo(activity.objectName, activity.recordId, activity.settings);
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
            this.updateFieldValue(this.activeChecklistTarget, 'updateField', 'fieldValue', event?.detail?.isMandatoryFilled);
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
        if (!this.myScanner) {
            return;
        }
        const scanningOptions = {
            barcodeTypes: [this.barCodeType ? this.barCodeType : this.myScanner.barcodeTypes.QR]
        };
        this.myScanner
            .beginCapture(scanningOptions)
            .then((result) => {
                this.setActivityValue(taskId, 'fieldValue', result.value);
                this.updateFieldValue(
                    taskId,
                    'updateField',
                    'fieldValue',
                    result.value
                )
            })
            .catch((error) => {
                if (error && error.code && error.code == 'USER_DISMISSED') {
                    console.error(error);
                } else {
                    this.showError(error, 'Scan Failed');
                }
            })
            .finally(() => {
                this.myScanner.endCapture();
            });
        }
    
    handleTextChange(event){
        this.updateFieldValue(event.target.dataset.recordId, 'updateField', 'fieldValue', event.target.value);
    }

    handleNumericChange(event){
        this.updateFieldValue(event.target.dataset.recordId, 'updateField', 'fieldValue', event.target.value);
    }

    handleEmailChange(event){
        this.updateFieldValue(event.target.dataset.recordId, 'updateField', 'fieldValue', event.target.value);
    }

    handlePhoneChange(event){
        this.updateFieldValue(event.target.dataset.recordId, 'updateField', 'fieldValue', event.target.value);
    }

    handleLongTextChange(event){
        this.updateFieldValue(event.target.dataset.recordId, 'updateField', 'fieldValue', event.target.value);
    }

    handleBooleanChange(event){
        this.updateFieldValue(event.target.dataset.recordId, 'updateField', 'fieldValue', event.target.value);
    }

    handleDecimalChange(event){
        this.updateFieldValue(event.target.dataset.recordId, 'updateField', 'fieldValue', event.target.value);
    }

    handleDateChange(event){
        this.updateFieldValue(event.target.dataset.recordId, 'updateField', 'fieldValue', event.target.value);
    }

    handleDateTimeChange(event){
        this.updateFieldValue(event.target.dataset.recordId, 'updateField', 'fieldValue', event.target.value);
    }

    handleCurrencyChange(event){
        this.updateFieldValue(event.target.dataset.recordId, 'updateField', 'fieldValue', event.target.value);
    }

    handleUrlChange(event){
        this.updateFieldValue(event.target.dataset.recordId, 'updateField', 'fieldValue', event.target.value);
    }

    handleGeoLocationChange(event){
        this.updateFieldValue(event.target.dataset.recordId, 'updateField', 'fieldValue', event.target.value);
    }
    
    handleExpandClick(event){
        this.toggleTaskPanel(event.target?.name);
    }

    updateFieldValue(recordId, actionName, fieldName, fieldValue){
        try {
            let activty = undefined;
            this.visitTasks.find(task => {
                activty = task.activities?.find(a=>a.value == recordId);
                return activty !=null;
            });
            const fields = {};
            fields['Id'] = recordId;
            fields['uid'] = activty?.uid;
            fields[fieldName] = fieldValue;
            fields['data'] = this.visitTasks;

            this.setLoadingCount(1);
            callDynamicAction({ 
                actionName: actionName, 
                controllerName: this.controllerName, 
                param1: fields})
                .then(async(result) => {
                    this.setLoadingCount(-1);
                    if(result){
                        this.refreshActivityData(result);
                    }else{
                        this.showError('Error Saving Record');    
                    }
                })
                .catch(error => {
                    this.setLoadingCount(-1);
                    this.showError(error);
                });
        } catch (error) {
            this.setLoadingCount(-1);
        }    
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
                this.updateFieldValue(activity.value, 'updateField', this.getObjectFieldName(activity.objectName), documentId);
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

    navigateTo(objectApiName, recordId, settings){
        if(settings?.navigation){
            if(recordId && settings.navigation?.attributes?.hasOwnProperty('recordId')){
                settings.navigation.attributes.recordId = recordId;
            }
            this[NavigationMixin.Navigate](settings.navigation);
        }else{
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
    }
}