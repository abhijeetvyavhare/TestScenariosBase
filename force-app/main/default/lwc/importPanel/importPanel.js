import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { reduceErrors } from 'c/utils';
import { RefreshEvent } from 'lightning/refresh';
import { loadScript } from 'lightning/platformResourceLoader';
import { CurrentPageReference } from 'lightning/navigation';
import { publish, MessageContext } from 'lightning/messageService';
import sheetjs from '@salesforce/resourceUrl/sheetjs';
import getFieldSetList from '@salesforce/apex/MetadataController.getFieldSetList';
import getFieldsByFieldSetName from '@salesforce/apex/MetadataController.getFieldsByFieldSetName';
import importFieldsetData from '@salesforce/apex/ImportController.importFieldsetData';
import getDMSImportSettings from '@salesforce/apex/ImportController.getDMSImportSettings';
import FORCEREFRESHMC from '@salesforce/messageChannel/ForceReset__c';

const PAGESIZE = 25;
export default class ImportPanel extends LightningElement {
    @api recordId;
    @api objectApiName;

    relationListOptions = [];
    fieldsetListOptions = [];
    sheetNameOptions = [];
    acceptedFormats = ['.xls', '.xlsx'];
    objectsDataLoaded = [];
    objectsData = [];
    objectsDataColumns =[];
    isRelationDisabled = false;
    isFieldsetDisabled = false;
    batchSize = 50;
    loadingText='';
    fieldsetName;
    relationName;
    @track isLoading = false;
    @track isUploadDisabled = true;
    @track isSaveVisible = false;
    @track isSaveDisabled = true;
    @track isDownloadResultVisible = false;

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.urlStateParameters = currentPageReference.state;
            this.setParametersBasedOnUrl();
        }
    }

    @wire(MessageContext)
    messageContext;

    @wire(getDMSImportSettings, { objectApiName: '$objectApiName' })
    wiredDMSImportSettings({ error, data }) {
        if (data) {
            this.importSettings = data;
            if(this.importSettings){
                let relationSetting = this.importSettings.find(v=>v.dmpl__SettingType__c == 'Import Panel Relation Name');
                if(relationSetting && relationSetting.dmpl__TextValue__c){
                    //if(!this.relationName){
                        this.setRelationValues();
                        this.relationName = relationSetting.dmpl__TextValue__c;
                        this.setRelationValues();
                    //}
                }
                let fieldsetSetting = this.importSettings.find(v=>v.dmpl__SettingType__c == 'Import Panel Fieldset Name');
                if(fieldsetSetting && fieldsetSetting.dmpl__TextValue__c){
                    //if(!this.fieldsetName){
                        this.fieldsetName = fieldsetSetting.dmpl__TextValue__c;
                        this.setFieldsetValues();
                    //}
                }
            }
        }
    }

    @wire(getObjectInfo, { objectApiName: '$objectApiName' })
    sourceObjectInfo({ error, data }) {
        if (data) {
            this.recordTypeId = data.defaultRecordTypeId;
            this.objectName = data.label;
            this.childRelationships = data.childRelationships?.map(c=>{
                return {
                    childObjectApiName : c.childObjectApiName,
                    childFieldName : c.fieldName,
                    relationName : c.relationshipName
                }
            });
            this.relationListOptions = [{ 
                label: '<None>', 
                value: 'none' }].concat(this.childRelationships?.map(r=>{
                return { label: r.relationName, value: r.relationName }
            }));
            this.fieldOptions = Object.keys(data.fields).map(f=> {
                let field = data.fields[f];
                return { 
                    label : field.label, 
                    value : field.apiName,
                    dataType : field.dataType
                }});
                if(this.relationName){
                    this.setRelationValues();
                }
        }
        if (error) {
            console.log('Field Error', error);
        }
    }
    
    get noObjectsData() {
        return (this.objectsData && this.objectsData.length == 0);
    }

    async connectedCallback(){
        await loadScript(this, sheetjs);
        this.setRelationValues();
        if(this.relationName){
            this.isRelationDisabled = true;
        }
        if(this.fieldsetName){
            this.setFieldsetValues();
            //this.isFieldsetDisabled = true;
        }
    }
    
    async disconnectedCallback(){
        this.relationName = undefined;
        this.fieldsetName = undefined;
    }

    setParametersBasedOnUrl() {
        if(this.urlStateParameters.defaultFieldValues){
            let nvPair = this.urlStateParameters.defaultFieldValues.split('&');
            nvPair.forEach(v=>{
                let nvValue = v.split('=');
                if(nvValue.length ==2){
                    if(nvValue[0] == 'relationName'){
                        this.relationName = nvValue[1];
                    }else if(nvValue[0] == 'fsName'){
                        this.fieldsetName = nvValue[1];
                    }
                }
            });
        }
    }

    setRelationValues(){
        this.resetColumnsData();
        this.fieldsetListOptions = [];
        this.targetObjectApiName = this.objectApiName;
        this.parentFieldName = undefined;
        if(this.relationName){
            let relation = this.childRelationships?.find(v=> v.relationName == this.relationName);
            if(relation){
                this.targetObjectApiName = relation.childObjectApiName;
                this.parentFieldName = relation.childFieldName;    
            }
        }
        getFieldSetList({
            objectApiName: this.targetObjectApiName
        }).then(result => {
            this.fieldsetListOptions = result?.map(r=>{
                return { 
                    label: r.label, 
                    value: r.apiName }  
            });
        }).catch(error => {
            this.showError(error);
        });
    }

    setFieldsetValues(){
        this.resetColumnsData();
        if(this.targetObjectApiName 
            && this.fieldsetName){
                this.targetFieldsetName = this.fieldsetName;
                getFieldsByFieldSetName({
                    objectApiName: this.targetObjectApiName,
                    fieldSetName:  this.fieldsetName
                }).then(result => {
                    this.fieldsetColumns = result;
                    this.importColumns = (Array.from(result).map(v => {
                        let fieldName = `${v.label} (${v.apiName})`;
                        return { label: fieldName, fieldName: fieldName, hideDefaultActions: true, cellAttributes: { class: 'slds-text-color_success' } }
                    }));
                    this.importColumns.push({ label: 'Status', fieldName: 'status', initialWidth: 250, hideDefaultActions: true });
                    this.setColumnsDataStatus();
                }).catch(error => {
                    this.importColumns = undefined;
                    this.showError(error);
                    this.setColumnsDataStatus();
                });
            }
    }

    handleRelationNameChange(event) {
        if(event?.detail?.value == 'none'){
            this.relationName = undefined;
        }else{
            this.relationName = event?.detail?.value;
        }
        this.setRelationValues();
    }

    handleFieldsetChange(event) {
        this.fieldsetName = event?.detail?.value;
        this.setFieldsetValues();
    }
    
    handleUploadFinished(event) {
        this.selectedSheetName = undefined;
        this.uploadedFiles = event.target.files;
        if(this.uploadedFiles && this.uploadedFiles.length>0){
            this.moveWizard('next');
            this.populateExcelData(this.uploadedFiles[0]);
        }
    }
    
    handleSheetChange(event){
        this.selectedSheetName = event?.detail?.value;
        if(this.uploadedFiles && this.uploadedFiles.length>0){
            this.populateExcelData(this.uploadedFiles[0]);
        }
    }

    resetColumnsData(){
        this.importColumns = undefined;;
        this.setColumnsDataStatus();
    }

    setColumnsDataStatus(){
        this.isUploadDisabled = (!this.importColumns) 
            || (!this.importColumns.length >0);
    }

    handleClose() {
        this.dispatchEvent(new CustomEvent('closeclicked', { "detail": '{}' }));
        this.dispatchEvent(new CloseActionScreenEvent());
    }
    
    handleStepChange(event){
        if(event.detail.currentStep == 'step-1'){
            this.isSaveVisible = false;
            this.isDownloadResultVisible = false;
        }
    }
    
    handleBatchSizeChange(event){
        this.batchSize = event.detail.value;
    }

    async populateExcelData(file){
        this.isLoading = true;
        const fileReader = new FileReader();
        fileReader.onload = ((event) => {
            try {
                let wb = XLSX.read(event.target.result, {'cellDates' : 'true'});
                this.sheetNameOptions = wb.SheetNames?.map(v=>{
                    return { label: v, value: v }
                });

                if(wb.SheetNames.length>0){
                    if(this.selectedSheetName == undefined 
                        || wb.SheetNames.find(v=>v == this.selectedSheetName) == undefined){
                        this.selectedSheetName = wb.SheetNames[0];
                    }
                    this.setSheetData(XLSX.utils.sheet_to_json(wb.Sheets[wb.SheetNames.find(v=>v == this.selectedSheetName)]));
                }
                this.isSaveVisible = true;
                this.isDownloadResultVisible = false;
                this.isSaveDisabled = (!this.objectsData && this.objectsData.length>0);
            }catch (error) {
                console.log('upload error ' + JSON.parse(JSON.stringify(error.detail)));
            }finally{
                this.isLoading = false;
            }
        });    
        fileReader.readAsArrayBuffer(file);
    }

    setSheetData(sheetSource){
        let dataSource = JSON.parse(JSON.stringify(sheetSource));
        let columns = this.importColumns.slice();
        dataSource.forEach((jObject) => {
            for (var i in jObject) {
                if (jObject.hasOwnProperty(i)) {
                    if (columns.filter(x => x.label === i).length == 0)
                        columns.push({ label: i, fieldName: i, type: 'text', cellAttributes: { class: 'slds-text-color_destructive' } });
                }
            }
        })
        this.objectsDataColumns = columns;
        this.objectsDataLoaded = dataSource.slice(0,PAGESIZE);
        this.objectsData = dataSource;
    }
    
    loadMoreData(event) {
        event.target.isLoading = true;
        if (this.objectsDataLoaded.length >= this.objectsData.length) {
            event.target.enableInfiniteLoading = false;
        } else {
            const currentData = this.objectsDataLoaded;
            this.objectsDataLoaded = currentData.concat(this.objectsData.slice(this.objectsDataLoaded.length-1, this.objectsDataLoaded.length + PAGESIZE));
        }
        event.target.isLoading = false;
    }

    async handleSaveResult() {
        var headers = this.objectsDataColumns.map(v=> v.fieldName);
        let aoa = [headers].concat(this.objectsData.map(record => 
                headers.map(c=>record[c])
            ));
        var wb = XLSX.utils.book_new();
        var ws = XLSX.utils.aoa_to_sheet(aoa);
        XLSX.utils.book_append_sheet(wb, ws, "Data");
        XLSX.writeFile(wb, this.targetFieldsetName + ".xlsx");
    };

    async handleSaveFormat() {
        var headers = this.importColumns.map(v=> v.label);
        let aoa = [headers];
        var wb = XLSX.utils.book_new();
        var ws = XLSX.utils.aoa_to_sheet(aoa);
        XLSX.utils.book_append_sheet(wb, ws, "Data");
        XLSX.writeFile(wb, this.targetFieldsetName + ".xlsx");
    };
    
    moveWizard(direction) {
        var step = Array.from(this.template.querySelectorAll('c-wizard'));
        step.forEach(element => {
            element.moveStep(direction);
        });
    }
    
    async handleSave() {
        try {
            this.isLoading = true;
            this.isSaveDisabled = true;
            let totalRows = this.objectsData.length;
            if(totalRows == 0){
                return;
            }
            let pageNumber = 1;
            let pageSize = parseInt(this.batchSize) > 0 ? parseInt(this.batchSize) : 100;
            let totalPages = Math.ceil(totalRows/pageSize);
            let offset = 0;
            let resultData = JSON.parse(JSON.stringify(this.objectsData));
            while(pageNumber <= totalPages){
                this.loadingText = `Importing Page ${pageNumber} Of ${totalPages}...`;
                let dataToUpload = this.objectsData.slice(offset, offset + pageSize).map(v=>{
                    let record = {};
                    this.fieldsetColumns.forEach(c=>{
                        const fieldName = `${c.label} (${c.apiName})`;
                        if(c.type == 'STRING'){
                            record[c.apiName] = v[fieldName] ? v[fieldName].toString() : v[fieldName];
                        }else{
                            record[c.apiName] = v[fieldName];
                        }
                    })
                    return record;
                })
                let saveResults = await importFieldsetData({
                    objectApiName : this.targetObjectApiName,
                    recordId : this.recordId,
                    parentFieldName : this.parentFieldName,
                    fieldsetName : this.targetFieldsetName,
                    jsonString : JSON.stringify(dataToUpload)
                });
                this.loadingText = `Uploaded Page ${pageNumber} Of ${totalPages}...`;
                if(saveResults){
                    for(var i=0; i<saveResults.length; i++){
                        if(saveResults[i]?.isSuccess){
                            resultData[offset+i].status = 'Success : ' + saveResults[i].objectId;
                            resultData[offset+i].status += saveResults[i].error ? ' Warning (' + saveResults[i].error + ')' : '';
                        }else{
                            resultData[offset+i].status = 'Error : ' + saveResults[i].error;
                        }
                    }
                }
                this.loadingText = `Finished Page ${pageNumber} Of ${totalPages}...`;
                pageNumber +=1;
                offset = (pageNumber-1) * pageSize;
            }
            this.objectsData = resultData;  
            this.objectsDataLoaded = this.objectsData.slice(0,PAGESIZE);
            this.isSaveVisible = false;
            this.isDownloadResultVisible = true;
            this.refreshStdComponents();
            this.fireForceRefreshEvent();
        } catch (error) {
            this.showError(error);
        }finally{
            this.isLoading = false;
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
    
    fireForceRefreshEvent() {
        const details = {
            state: '',
        };
        publish(this.messageContext, FORCEREFRESHMC, details);
    }
}