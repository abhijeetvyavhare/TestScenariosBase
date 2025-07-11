import { LightningElement, api, wire, track } from 'lwc';
import { getRecord } from "lightning/uiRecordApi";
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import { notifyRecordUpdateAvailable } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import { RefreshEvent } from 'lightning/refresh';
import { reduceErrors } from 'c/utils';
import getCreateRelatedSettings from '@salesforce/apex/DocumentSelectorController.getCreateRelatedSettings';
import getFieldsByFieldSetName from '@salesforce/apex/MetadataController.getFieldsByFieldSetName';
import getChildObjects from '@salesforce/apex/DocumentSelectorController.getChildObjects';
import releaseDocument from '@salesforce/apex/DocumentSelectorController.releaseDocument';
import releaseChildDocuments from '@salesforce/apex/DocumentSelectorController.releaseChildDocuments';
import noCreateReleatedSettings from '@salesforce/label/c.DocumentSelectorPanel_NoCreateReleatedSettings';
import queueNotification from 'c/queueNotification';

const FIELD_PARTNERACCOUNTID = 'dmpl__PartnerAccountId__c';
const FIELD_BRANCHID = 'dmpl__BranchId__c';
const FIELD_ACCOUNTID = 'dmpl__AccountId__c';
const FIELD_NAME = 'Name';
const DELAY = 500;

export default class DocumentSelectorPanel extends NavigationMixin(LightningElement) {
    @api title;
    @api recordSettingId;
    @api relatedId;
    @track recordFields;
    @track sortBy;
    @track sortDirection;

    customLabel = {
        noCreateReleatedSettings
    }
    documentScopeOptions = [
        { label: 'All Records', value: 'all' },
        { label: 'Selected Records', value: 'selected' }
    ]

    @track isLoaded = false;
    @track isLinesDataLoaded = false;
    @track isSaveDisabled = true;
    @track isWorking = false;
    draftValues;
    @track childObjectsData;
    allChildObjectColumns;
    rawFieldsetResult;
    selectedChildObjectColumns;
    documentScope = 'all';
    searchKey = '';
    relatedSettings;
    createRelatedResult;
    navigationUrl;
    childRecordApiName;
    recordFieldsetName;
    controllingField;
    tableErrors;
    isAllRecordsRestricted;

    @wire(getRecord, {
        recordId: '$recordId',
        fields: '$recordFields'
    })
    getRecordDetails({ error, data }) {
        if (data) {
            this.recordDetails = data;
            if (data.fields[FIELD_NAME]){
                this.title = data.fields[FIELD_NAME].value;
            }
            this.relatedSettings = this.relatedSettings?.map(v=> 
            {
                let newV = Object.assign({}, v);
                if(newV.hideActionFieldName && data.fields[newV.hideActionFieldName]){
                    newV.hideOption = data.fields[v.hideActionFieldName].value;
                }
                return newV;
            });
        }
    }

    _recordId;
    @api set recordId(value) {
        this._recordId = value;
        this.handleInit();
    }

    get recordId() {
        return this._recordId;
    }

    _objectApiName;
    @api set objectApiName(value) {
        this._objectApiName = value;
        this.handleInit();
    }

    get objectApiName() {
        return this._objectApiName;
    }

    get getDocumentTitle() {
        return this.recordSettingTitle? this.recordSettingTitle + ' - ' + this.title : this.title;
    }

    get hasRelatedSettings() {
        return this.relatedSettings && this.relatedSettings.length > 0;
    }

    get getIsAllLinesVisible() {
        return this.documentScope == 'all';
    }

    get isSaveVisible() {
        var wizard = Array.from(this.template.querySelectorAll('c-wizard'));
        if (wizard && wizard.length > 0) {
            return wizard[0].currentStep == 'step-2';
        }
        return false;
    }

    get getFieldsetFields() {
        if (this.getWiredFieldsetFields && this.getWiredFieldsetFields.data) {
            return this.getWiredFieldsetFields.data;
        }
    }

    get noChildObjectsData() {
        return (this.isLinesDataLoaded && this.childObjectsData && this.childObjectsData.length == 0);
    }

    connectedCallback() {
        this.handleInit();
    }

    moveWizard(direction) {
        var step = Array.from(this.template.querySelectorAll('c-wizard'));
        step.forEach(element => {
            element.moveStep(direction);
        });
    }

    async initChildObjectsData() {
        if (this.loadedRecordSettingId == this.recordSettingId
            && this.loadedsearchKey == this.searchKey) {
            return;
        }
        this.isLinesDataLoaded = false;
        this.isSaveDisabled = true;
        this.isWorking = true;
        if (this.loadedRecordSettingId != this.recordSettingId) {
            getFieldsByFieldSetName({
                objectApiName: this.childRecordApiName,
                fieldSetName: this.recordFieldsetName
            }).then(result => {
                console.log('result ', JSON.stringify(result));
                this.rawFieldsetResult = result;
                let columns = (Array.from(result).map(v => {
                    return { label: v.label,sortable: "true", fieldName: v.apiName.replace('.', '_'), hideDefaultActions: true, ...(screen.width <= 480 ? { initialWidth: 140 } : {}) }
                }));
                this.allChildObjectColumns = columns.slice();
                columns.push({ label: 'Release?', fieldName: 'isSelected', type: 'toggleButton', initialWidth: 75, hideLabel: true, hideDefaultActions: true, typeAttributes: { rowId: { fieldName: 'Id' } } });
                if(this.relatedSetting.showUOMQty1){
                    columns.push({ label: this.relatedSetting.uomLabel1, fieldName: 'uomqty', type: 'number', initialWidth: 90, hideDefaultActions: true, editable: true, cellAttributes: { class: 'slds-theme_shade' } });
                }
                if(this.relatedSetting.showUOMQty2){
                    columns.push({ label: this.relatedSetting.uomLabel2, fieldName: 'uomqty1', type: 'number', initialWidth: 90, hideDefaultActions: true, editable: true, cellAttributes: { class: 'slds-theme_shade' } });
                }
                columns.push({ label: 'Quantity', fieldName: 'quantity', type: 'number', initialWidth: 90, hideDefaultActions: true, editable: this.relatedSetting.showUOMQty1 || this.relatedSetting.showUOMQty2 ? false : true, cellAttributes: { class: 'slds-theme_shade' } });
                this.selectedChildObjectColumns = columns;
            })
                .catch(error => {
                    this.showError(error);
                });
        }

        getChildObjects({
            recordSettingId: this.recordSettingId,
            hostId: this.recordId,
            searchKey: this.searchKey
        }).then(result => {
            let selectedData = this.childObjectsData && this.childObjectsData.slice().filter(v => v.isSelected);
            console.log('result '+result);
            let newData = Array.from(result).map(v => {
                let v1 = JSON.parse(JSON.stringify(v));
                v1.objectId = v.Id;
                this.rawFieldsetResult?.forEach(a => {
                    if (a.apiName.indexOf('.') > 0) {
                        let parts = a.apiName.split('.');
                        v1[a.apiName.replace('.', '_')] = v[parts[0]] ? v[parts[0]][parts[1]] : undefined;
                    }
                });
                let selectedRow = selectedData && selectedData.find(s => s.Id == v.Id);
                v1.quantity = selectedRow ? selectedRow.quantity : undefined;
                v1.isSelected = selectedRow ? selectedRow.isSelected : false;
                return v1;
            });
            if (selectedData) {
                newData = newData.concat(selectedData.filter(v => newData.find(v1 => v1.Id == v.Id) == undefined));
            }
            this.childObjectsData = newData;
            this.isLinesDataLoaded = true;
            this.loadedRecordSettingId = this.recordSettingId;
            this.loadedsearchKey = this.searchKey
            this.isSaveDisabled = this.noChildObjectsData;
            this.isWorking = false;
        })
            .catch(error => {
                this.isLinesDataLoaded = true;
                this.isSaveDisabled = this.noChildObjectsData;
                this.isWorking = false;
                this.showError(error);
            });
    }

    handleInit() {
        let fields = this.objectApiName && this.recordId ? [this.objectApiName.concat('.', FIELD_PARTNERACCOUNTID),
        this.objectApiName.concat('.', FIELD_BRANCHID),
        this.objectApiName.concat('.', FIELD_ACCOUNTID),
        this.objectApiName.concat('.', FIELD_NAME)] : undefined;
        this.recordFields = fields;
        this.loadedsearchKey = this.searchKey;

        if (!this.isLoaded && this.objectApiName) {
            getCreateRelatedSettings({ objectApiName: this.objectApiName })
                .then(result => {
                    this.relatedSettings = result.filter(v =>
                        v.dmpl__IsActive__c).sort((a, b) => a - b).map(v => {
                            return {
                                value: v.Id,
                                title: v.dmpl__Title__c,
                                subTitle: v.dmpl__SubTitle__c,
                                heading: v.dmpl__Heading__c,
                                subHeading: v.dmpl__SubHeading__c,
                                fieldsetName: v.dmpl__ChildFieldsetName__c,
                                childObjectApiName: v.dmpl__ChildObjectId__r?.QualifiedApiName,
                                controllingField: v.dmpl__EligibilityQuantityFieldId__r?.QualifiedApiName,
                                restrictAllRecordsRelease: v.dmpl__RestrictAllRecordsRelease__c,
                                skipConfirmationPage : v.dmpl__SkipConfirmationPage__c,
                                hideActionFieldName : v.dmpl__HideActionFieldName__c,
                                hideOption : false,
                                showUOMQty1 : v.dmpl__ShowUOMQty__c,
                                showUOMQty2 : v.dmpl__ShowUOMQty1__c,
                                uomLabel1 : v.dmpl__UOMLabel__c,
                                uomLabel2 : v.dmpl__UOMLabel1__c
                            }
                        });

                        let actionFieldNames = this.relatedSettings.filter(v=>v.hideActionFieldName);
                        if(actionFieldNames && actionFieldNames.length>0){
                            this.recordFields = fields.concat(actionFieldNames.map(v=>{
                                return this.objectApiName.concat('.', v.hideActionFieldName) }));
                        }

                        setTimeout(() => {
                            if (this.relatedSettings.length == 1) {
                                this.handlePickerValueChanged({ detail: { value: this.relatedSettings[0].value } });
                            }
                        }, 50);
                    this.isLoaded = true;
                })
                .catch(error => {
                    this.isLoaded = true;
                    this.showError(error);
                });
        }
    }

    async handlePickerValueChanged(event) {
        this.recordSettingId = event.detail.value;
        let rs = this.relatedSettings.find(v => v.value == this.recordSettingId);
        if (rs) {
            this.recordSettingTitle = rs.title;
            this.recordFieldsetName = rs.fieldsetName;
            this.childRecordApiName = rs.childObjectApiName;
            this.controllingField = rs.controllingField;
            this.isAllRecordsRestricted = rs.restrictAllRecordsRelease;
            if (this.isAllRecordsRestricted) {
                this.documentScope = 'selected';
            }
            this.relatedSetting = rs;
        }
        this.moveWizard('next');
        await this.initChildObjectsData();
    }

    handleCellChange(event) {
        event.detail.draftValues.forEach((row) => {
            let sourceRow = this.childObjectsData.find(v => v.Id == row.Id);
            if (sourceRow) {
                if(row.hasOwnProperty('uomqty')){
                    if(row.uomqty > 0){
                        row.quantity = (row.uomqty ? parseFloat(row.uomqty) * parseFloat(sourceRow.dmpl__ConversionRatio__c)  : 0)
                            + (sourceRow.uomqty1 ? parseFloat(sourceRow.uomqty1) * parseFloat(sourceRow.dmpl__ConversionRatio1__c) : 0);
                    }else {
                        sourceRow.uomqty = null;
                        row.quantity = (sourceRow.uomqty1 ? parseFloat(sourceRow.uomqty1) * parseFloat(sourceRow.dmpl__ConversionRatio1__c) : 0);
                    }
                }else if(row.hasOwnProperty('uomqty1')){
                    if(row.uomqty1 > 0){
                        row.quantity = (sourceRow.uomqty ? parseFloat(sourceRow.uomqty) * parseFloat(sourceRow.dmpl__ConversionRatio__c)  : 0)
                            + (row.uomqty1 ? parseFloat(row.uomqty1) * parseFloat(sourceRow.dmpl__ConversionRatio1__c) : 0);
                    }else {
                        sourceRow.uomqty1 = null;
                        row.quantity = (sourceRow.uomqty ? parseFloat(sourceRow.uomqty) * parseFloat(sourceRow.dmpl__ConversionRatio__c)  : 0);
                    }
                }
                if (row.quantity > sourceRow[this.controllingField]) {
                    row.quantity = sourceRow[this.controllingField]
                    sourceRow.quantity = sourceRow[this.controllingField];
                    sourceRow.uomqty = null;
                    sourceRow.uomqty1 = null;
                    this.showWarning('Quantity to release can not be in excess of pending quantity!');
                }
                else {
                    sourceRow.uomqty = row.uomqty > 0 ? row.uomqty : sourceRow.uomqty;
                    sourceRow.uomqty1 = row.uomqty1 > 0 ? row.uomqty1 : sourceRow.uomqty1;
                    sourceRow.quantity = row.quantity;
                    sourceRow.isSelected = row.quantity > 0;
                }
            }
        });
        this.draftValues = [];
        event.detail.draftValues = [];
        this.childObjectsData = this.childObjectsData.slice();
    }

    handleSelectedRec(event) {
        let row = this.childObjectsData.find(v => v.Id == event?.detail?.value?.rowId);
        if (row && event?.detail?.value?.state == true) {
            row.isSelected = true;
            row.quantity = row[this.controllingField];
            if(row.dmpl__ConversionRatio__c > 0 && row.dmpl__ConversionRatio1__c > 0){
                if(row.dmpl__ConversionRatio__c > row.dmpl__ConversionRatio1__c){
                    row.uomqty = Math.floor(row.quantity / parseFloat(row.dmpl__ConversionRatio__c));
                    row.uomqty1 = (row.quantity - parseFloat(row.uomqty)*parseFloat(row.dmpl__ConversionRatio__c)) / parseFloat(row.dmpl__ConversionRatio1__c);
                }else {
                    row.uomqty1 = Math.floor(row.quantity / parseFloat(row.dmpl__ConversionRatio1__c));
                    row.uomqty = (row.quantity - parseFloat(row.uomqty1)*parseFloat(row.dmpl__ConversionRatio1__c)) / parseFloat(row.dmpl__ConversionRatio__c);
                }
            }else if(row.dmpl__ConversionRatio__c > 0){
                row.uomqty = Math.floor(row.quantity / parseFloat(row.dmpl__ConversionRatio__c));
            }else if(row.dmpl__ConversionRatio1__c > 0){
                row.uomqty1 = Math.floor(row.quantity / parseFloat(row.dmpl__ConversionRatio1__c));
            }
        } else {
            row.isSelected = false;
            row.quantity = undefined;
            row.uomqty = undefined;
            row.uomqty1 = undefined;
        }
        this.childObjectsData = this.childObjectsData.slice();
    }

    async handleSearch(event) {
        window.clearTimeout(this.delayTimeout);
        const searchKey = event.target.value;
        this.delayTimeout = setTimeout(async() => {
            this.searchKey = searchKey;
            await this.initChildObjectsData();
        }, DELAY);
    }

    handleClose() {
        this.dispatchEvent(new CustomEvent('closeclicked', { "detail": '{}' }));
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    async handleDocumentOptionChange(event) {
        this.documentScope = event.detail.value;
        setTimeout(async() => {
            await this.initChildObjectsData();
        }, DELAY);
    }

    handleSelectAllClick(event){
        this.childObjectsData.forEach(row => {
            row.isSelected = true;
            row.quantity = row[this.controllingField];
        });
        this.childObjectsData = this.childObjectsData.slice();
    }

    handleDeSelectAllClick(event){
        this.childObjectsData.forEach(row => {
            row.isSelected = false;
            row.quantity = null;
        });
        this.childObjectsData = this.childObjectsData.slice();
    }

    async handleSave() {
        this.isSaveDisabled = true;
        this.isWorking = true;
        try {
            let result = undefined;
            if (this.documentScope == 'all') {
                result = await releaseDocument(
                    {
                        recordSettingId: this.recordSettingId,
                        hostId: this.recordId,
                        recordCount : this.childObjectsData?.length
                    });
            } else {
                var selectedRecords = this.childObjectsData.filter(v => v.isSelected).map(v => {
                    return {
                        hostId: this.recordId,
                        objectId: v.objectId,
                        quantity: v.quantity
                    }
                });
                if (selectedRecords.length == 0) {
                    this.showWarning('No lines to release');
                    return;
                }
                result = await releaseChildDocuments(
                    {
                        recordSettingId: this.recordSettingId,
                        hostId: this.recordId,
                        childObjectsInfo: selectedRecords
                    });
            }

            if (result?.status == 'success') {
                var messsage = '';
                this.createRelatedResult = result;
                notifyRecordUpdateAvailable([{ "recordId": this.recordId }]);
                if(result?.documentId){
                    notifyRecordUpdateAvailable([{ "recordId": result.documentId }]);
                    this[NavigationMixin.GenerateUrl]({
                        type: 'standard__recordPage',
                        attributes: {
                            recordId: this.createRelatedResult.documentId,
                            actionName: 'view',
                        },
                    }).then((url) => {
                        this.navigationUrl = url;
                    });
                    this.createRelatedResult.heading = `${this.createRelatedResult.documentLabel} created!`;
                    this.createRelatedResult.subHeading = `${this.createRelatedResult.documentLabel} created successfully. Click here to navigate to the created document.`;
                    messsage = `${this.createRelatedResult.documentLabel} created successfully.`;
                } else {
                    this.createRelatedResult.heading = 'Action Performed Successfully!';
                    this.createRelatedResult.subHeading = 'The request action completed successfully!';
                    messsage = this.createRelatedResult.heading;
                }
                this.moveWizard('next');
                this.refreshStdComponents();
                this.dispatchEvent(new CustomEvent('recordsaved', { "detail": this.createRelatedResult }));
                this.showMessage(messsage);
                this.isSaveDisabled = this.noChildObjectsData;
                this.isWorking = false;
                if(this.relatedSetting && this.relatedSetting.skipConfirmationPage){
                    this.handleClose();
                }else{
                    this.moveWizard('next');
                }
            } else if (result?.status == 'queued'){
                this.showMessage('Your action was queued for execution. Please check back in sometime.');
                notifyRecordUpdateAvailable([{ "recordId": this.recordId }]);
                this.refreshStdComponents();
                this.isSaveDisabled = this.noChildObjectsData;
                this.isWorking = false;
                this.handleClose();
                const result = await queueNotification.open({
                    size: 'small',
                    recordId : this.recordId,
                    objectApiName : this.objectApiName 
                });
            } else {
                this.showError(result.error);
                this.isSaveDisabled = this.noChildObjectsData;
                this.isWorking = false;
            }
        } catch (error) {
            this.isSaveDisabled = this.noChildObjectsData;
            this.isWorking = false;
            this.showError(error);
        }
    }

    refreshStdComponents(){
        try{
            eval("$A.get('e.force:refreshView').fire();");
        }catch(e){
            this.dispatchEvent(new RefreshEvent());
        }
    }

    showError(error) {
        console.log('error ', error);
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error',
                message: reduceErrors(error),
                variant: 'error',
                mode: 'sticky'
            })
        );
    }

    showWarning(message) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Warning!',
                message: message,
                variant: 'warning'
            }),
        );
    }

    showMessage(message) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: message,
                variant: 'success',
            }),
        );
    }

    doSorting(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortBy, this.sortDirection);
    }

    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.childObjectsData));
        let keyValue = (a) => {
            return a[fieldname];
        };
        let isReverse = direction === 'asc' ? 1 : -1;
        
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : '';
            y = keyValue(y) ? keyValue(y) : '';
            
            return isReverse * ((x > y) - (y > x));
        });
        this.childObjectsData = parseData;
    }
}