import { LightningElement, api, wire, track } from 'lwc';
import { getRecord } from "lightning/uiRecordApi";
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import { notifyRecordUpdateAvailable } from 'lightning/uiRecordApi';
import { RefreshEvent } from 'lightning/refresh';
import { reduceErrors } from 'c/utils';
import getDocumentActionSettings from '@salesforce/apex/DocumentActionController.getDocumentActionSettings';
import getFieldsByFieldSetName from '@salesforce/apex/MetadataController.getFieldsByFieldSetName';
import getChildObjects from '@salesforce/apex/DocumentActionController.getChildObjects';
import performAction from '@salesforce/apex/DocumentActionController.performAction';
import performActionForSelectedObjects from '@salesforce/apex/DocumentActionController.performActionForSelectedObjects';
import noDocumentActionSettings from '@salesforce/label/c.DocumentActionPanel_NoDocumentActionSettings';

const FIELD_PARTNERACCOUNTID = 'dmpl__PartnerAccountId__c';
const FIELD_BRANCHID = 'dmpl__BranchId__c';
const FIELD_ACCOUNTID = 'dmpl__AccountId__c';
const FIELD_NAME = 'Name';
const DELAY = 500;

export default class DocumentActionPanel extends NavigationMixin(LightningElement) {
    @api title;
    @api recordSettingId;
    @api relatedId;
    @track recordFields;
    @track sortBy;
    @track sortDirection;

    customLabel = {
        noDocumentActionSettings
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
    childObjectsData;
    allChildObjectColumns;
    rawFieldsetResult;
    selectedChildObjectColumns;
    documentScope = 'all';
    searchKey = '';
    actionSettings;
    performActionResult;
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
            if (data.fields[FIELD_NAME]){
                this.title = data.fields[FIELD_NAME].value;
            }
            this.actionSettings?.forEach(v=> {
                if(v.hideActionFieldName && data.fields[v.hideActionFieldName]){
                    v.hideOption = data.fields[v.hideActionFieldName].value;
                }
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

    get hasActionSettings() {
        return this.actionSettings && this.actionSettings.length > 0;
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
                console.log('result '+result);
                this.rawFieldsetResult = result;
                let columns = (Array.from(result).map(v => {
                    if(this.documentScope = 'selected' && this.actionSetting?.editabledFieldNames && this.actionSetting.editabledFieldNames.includes(v.apiName)){
                        return { label: v.label, fieldName: v.apiName.replace('.', '_'), type: 'text', hideDefaultActions: true, editable: true, sortable: "true", cellAttributes: { class: 'slds-theme_shade' } }
                    }
                    else {
                        return { label: v.label, fieldName: v.apiName.replace('.', '_'), hideDefaultActions: true, sortable: "true"}
                    }
                }));
                this.allChildObjectColumns = columns.slice();
                columns.push({ label: 'Release?', fieldName: 'isSelected', type: 'toggleButton', initialWidth: 75, hideLabel: true, hideDefaultActions: true, typeAttributes: { rowId: { fieldName: 'Id' } } });
                columns.push({ label: 'Quantity', fieldName: 'quantity', type: 'number', initialWidth: 90, hideDefaultActions: true, editable: true, cellAttributes: { class: 'slds-theme_shade' } });
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
                    this.rawFieldsetResult.forEach(a => {
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
            }).catch(error => {
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
            getDocumentActionSettings({ objectApiName: this.objectApiName })
                .then(result => {
                    this.actionSettings = result.filter(v =>
                        v.dmpl__IsActive__c).sort((a, b) => a - b).map(v => {
                            return {
                                value: v.Id,
                                title: v.dmpl__Title__c,
                                subTitle: v.dmpl__SubTitle__c,
                                fieldsetName: v.dmpl__ChildFieldsetName__c,
                                childObjectApiName: v.dmpl__ChildObjectId__r?.QualifiedApiName,
                                controllingField: v.dmpl__EligibilityQuantityFieldId__r?.QualifiedApiName,
                                restrictAllRecordsRelease: v.dmpl__RestrictAllRecordsRelease__c,
                                editabledFieldNames : v.dmpl__EditableFieldNames__c,
                                actionType : v.dmpl__ActionType__c,
                                skipConfirmationPage : v.dmpl__SkipConfirmationPage__c,
                                hideActionFieldName : v.dmpl__HideActionFieldName__c,
                                hideOption : false
                            }
                        });
                
                    let actionFieldNames = this.actionSettings?.filter(v=>v.hideActionFieldName);
                    if(actionFieldNames && actionFieldNames.length>0){
                        this.recordFields = fields.concat(actionFieldNames.map(v=>{
                            return this.objectApiName.concat('.', v.hideActionFieldName) }));
                    }

                    setTimeout(() => {
                        if (this.actionSettings?.length == 1) {
                            this.handlePickerValueChanged({ detail: { value: this.actionSettings[0].value } });
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
        let rs = this.actionSettings?.find(v => v.value == this.recordSettingId);
        if (rs) {
            this.recordSettingTitle = rs.title;
            this.recordFieldsetName = rs.fieldsetName;
            this.childRecordApiName = rs.childObjectApiName;
            this.controllingField = rs.controllingField;
            this.isAllRecordsRestricted = rs.restrictAllRecordsRelease;
            if (this.isAllRecordsRestricted) {
                this.documentScope = 'selected';
            }
            this.actionSetting = rs;
        }
        this.moveWizard('next');
        await this.initChildObjectsData();
    }

    handleCellChange(event) {
        event.detail.draftValues.forEach((row) => {
            let sourceRow = this.childObjectsData.find(v => v.Id == row.Id);
            if (sourceRow) {
                if(row.quantity){
                    if (row.quantity > sourceRow[this.controllingField]) {
                        row.quantity = sourceRow[this.controllingField]
                        sourceRow.quantity = sourceRow[this.controllingField];
                        this.showWarning('Quantity to release can not be in excess of pending quantity!');
                    }
                    else {
                        sourceRow.quantity = row.quantity;
                        sourceRow.isSelected = row.quantity > 0;
                    }
                }else{
                    let fields = [];
                    if(sourceRow['fields']){
                        fields = sourceRow['fields'];    
                    }
                    for(let fieldName in row){
                        if(fieldName != 'Id'){
                            sourceRow[fieldName] = row[fieldName];
                            let fieldDetail = fields.find(f=>f.fieldName == fieldName);
                            if(fieldDetail){
                                fieldDetail.fieldValue = row[fieldName];
                            }else {
                                fields.push({fieldName, fieldValue : row[fieldName]});
                            }
                        }
                    }
                    sourceRow['fields'] = fields;
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
        } else {
            row.isSelected = false;
            row.quantity = undefined;
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
                result = await performAction(
                    {
                        recordSettingId: this.recordSettingId,
                        hostId: this.recordId
                    });
            } else {
                var selectedRecords = this.childObjectsData.filter(v => v.isSelected).map(v => {
                    return {
                        hostId: this.recordId,
                        objectId: v.objectId,
                        quantity: v.quantity,
                        fields : v.fields
                    }
                });
                if (selectedRecords.length == 0) {
                    this.showWarning('No lines to release');
                    return;
                }
                result = await performActionForSelectedObjects(
                    {
                        hostId: this.recordId,
                        recordSettingId: this.recordSettingId,
                        childObjectsInfo: selectedRecords
                    });
            }

            if (result?.status == 'success') {
                this.performActionResult = result;
                this.performActionResult.title = 'Action Performed Successfully!';
                this.performActionResult.subTitle = 'The request action completed successfully!';
                this.moveWizard('next');
                notifyRecordUpdateAvailable([{ "recordId": this.recordId }, { "recordId": result.documentId }]);
                this.refreshStdComponents();
                this.dispatchEvent(new CustomEvent('recordsaved', { "detail": this.performActionResult }));
                this.isSaveDisabled = this.noChildObjectsData;
                this.isWorking = false;
                if(this.actionSetting && this.actionSetting.skipConfirmationPage){
                    this.handleClose();
                }
            } else {
                this.isSaveDisabled = this.noChildObjectsData;
                this.isWorking = false;
                this.showError(result.error);
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