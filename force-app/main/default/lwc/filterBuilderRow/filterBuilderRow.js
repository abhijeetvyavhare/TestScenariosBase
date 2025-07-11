import { LightningElement, api, track, wire } from 'lwc';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { notifyRecordUpdateAvailable } from 'lightning/uiRecordApi';
import { RefreshEvent } from 'lightning/refresh';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { deleteRecord } from 'lightning/uiRecordApi';
import { publish, MessageContext } from 'lightning/messageService';
import FORCEREFRESHMC from '@salesforce/messageChannel/ForceReset__c';
import LightningConfirm from 'lightning/confirm';

export default class FilterBuilderRow extends LightningElement {
    @api record;
    @api sourceObjectApiName;
    @api parentFieldName;
    @api allowDateTimeLitrals;
    @api childObjectApiName;
    
    @track selectedField;
    @track selectedFieldName;
    @track recordTypeId;
    @track isDateNumber;

    isEditing = false;
    recordId;
    fieldOptions;
    fieldDataType;
    options;
    childRecordTypeId;
    operatorOptions;
    selectedOperator;
    filteredOperatorOptions;
    selectedPicklistValue;
    selectedDateLitralValue;
    

    @wire(getPicklistValues, { 
            recordTypeId : '$recordTypeId', 
            fieldApiName : '$selectedFieldName' 
        })
    wiredValues({ error, data }) {
        if (data) {
            this.options = data.values;
        } else if (error) {
            console.log('Field Error', error);
        }
    }

    @wire(getPicklistValues, { 
        recordTypeId : '$childRecordTypeId', 
        fieldApiName : '$getOperatorFullFieldName' 
    })
    wiredOperatorValues({ error, data }) {
        if (data) {
            this.operatorOptions = data.values;
            this.filteredOperatorOptions = this.operatorOptions;
        } else if (error) {
            this.operatorOptions = [];
            console.log('Field Error', error);
        }
    }
    
    @wire(MessageContext)
    messageContext;

    @wire(getObjectInfo, { objectApiName: '$sourceObjectApiName' })
    sourceObjectInfo({ error, data }) {
        if (data) {
            this.recordTypeId = data.defaultRecordTypeId;
            this.fieldOptions = Object.keys(data.fields).map(f=> {
                let field = data.fields[f];
                return { 
                    label : field.label, 
                    value : field.apiName,
                    dataType : field.dataType
                }}).sort(function(a, b){
                    let x = a.label.toLowerCase();
                    let y = b.label.toLowerCase();
                    if (x < y) {return -1;}
                    if (x > y) {return 1;}
                    return 0;
                  });
        }
        if (error) {
            console.log('Field Error', error);
        }
    }

    @wire(getObjectInfo, { objectApiName: '$childObjectApiName' })
    childObjectInfo({ error, data }) {
        if (data) {
            this.childRecordTypeId = data.defaultRecordTypeId;
        }
        if (error) {
            console.log('Field Error', error);
        }
    }

    get dateOptions(){
        return [
            // {label :'CUSTOM' , value: 'CUSTOM'},
            {label :'YESTERDAY' , value: 'YESTERDAY'},
            {label :'TODAY', value: 'TODAY'},
            {label :'TOMORROW' , value: 'TOMORROW'},
            {label :'LAST_WEEK' , value: 'LAST_WEEK'},
            {label :'THIS_WEEK' , value: 'THIS_WEEK'},
            {label :'NEXT_WEEK' , value: 'NEXT_WEEK'},
            {label :'LAST_MONTH' , value: 'LAST_MONTH'},
            {label :'THIS_MONTH' , value: 'THIS_MONTH'},
            {label :'NEXT_MONTH' , value: 'NEXT_MONTH'},
            {label :'LAST_90_DAYS' , value: 'LAST_90_DAYS'},
            {label :'NEXT_90_DAYS' , value: 'NEXT_90_DAYS'},
            {label :'LAST_N_DAYS:n' , value: 'LAST_N_DAYS:n'},
            {label :'NEXT_N_DAYS:n' , value: 'NEXT_N_DAYS:n'},
            {label :'N_DAYS_AGO:n' , value: 'N_DAYS_AGO:n'},
            {label :'NEXT_N_WEEKS:n' , value: 'NEXT_N_WEEKS:n'},
            {label :'LAST_N_WEEKS:n' , value: 'LAST_N_WEEKS:n'},
            {label :'N_WEEKS_AGO:n' , value: 'N_WEEKS_AGO:n'},
            {label :'NEXT_N_MONTHS:n' , value: 'NEXT_N_MONTHS:n'},
            {label :'LAST_N_MONTHS:n' , value: 'LAST_N_MONTHS:n'},
            {label :'N_MONTHS_AGO:n' , value: 'N_MONTHS_AGO:n'},
            {label :'THIS_QUARTER' , value: 'THIS_QUARTER'},
            {label :'LAST_QUARTER' , value: 'LAST_QUARTER'},
            {label :'NEXT_QUARTER' , value: 'NEXT_QUARTER'},
            {label :'NEXT_N_QUARTERS:n' , value: 'NEXT_N_QUARTERS:n'},
            {label :'LAST_N_QUARTERS:n' , value: 'LAST_N_QUARTERS:n'},
            {label :'N_QUARTERS_AGO:n' , value: 'N_QUARTERS_AGO:n'},
            {label :'THIS_YEAR' , value: 'THIS_YEAR'},
            {label :'LAST_YEAR' , value: 'LAST_YEAR'},
            {label :'NEXT_YEAR' , value: 'NEXT_YEAR'},
            {label :'NEXT_N_YEARS:n' , value: 'NEXT_N_YEARS:n'},
            {label :'LAST_N_YEARS:n' , value: 'LAST_N_YEARS:n'},
            {label :'N_YEARS_AGO:n' , value: 'N_YEARS_AGO:n'},
            {label :'THIS_FISCAL_QUARTER' , value: 'THIS_FISCAL_QUARTER'},
            {label :'LAST_FISCAL_QUARTER' , value: 'LAST_FISCAL_QUARTER'},
            {label :'NEXT_FISCAL_QUARTER' , value: 'NEXT_FISCAL_QUARTER'},
            {label :'NEXT_N_FISCAL_QUARTERS:n' , value: 'NEXT_N_FISCAL_QUARTERS:n'},
            {label :'LAST_N_FISCAL_QUARTERS:n' , value: 'LAST_N_FISCAL_QUARTERS'},
            {label :'N_FISCAL_QUARTERS_AGO:n' , value: 'N_FISCAL_QUARTERS_AGO:n'},
            {label :'THIS_FISCAL_YEAR' , value: 'THIS_FISCAL_YEAR'},
            {label :'LAST_FISCAL_YEAR' , value: 'LAST_FISCAL_YEAR'},
            {label :'NEXT_FISCAL_YEAR' , value: 'NEXT_FISCAL_YEAR'},
            {label :'NEXT_N_FISCAL_YEARS:n' , value: 'NEXT_N_FISCAL_YEARS:n'},
            {label :'LAST_N_FISCAL_YEARS:n' , value: 'LAST_N_FISCAL_YEARS:n'},
            {label :'N_FISCAL_YEARS_AGO:n' , value: 'N_FISCAL_YEARS_AGO:n'}
        ]
    }

    get getRecordLabel(){
        return this.getRecordFieldValue(this.getSequenceNumber);
    }
    
    get getSequenceNumber(){
        return 'dmpl__SequenceNumber__c';
    }

    get getFieldValue(){
        return 'dmpl__FieldValue__c';
    }

    get getFieldName(){
        return 'dmpl__FieldName__c';
    }

    get getOperatorFullFieldName(){
        return this.childObjectApiName + '.' + this.getOperator;
    }

    get getOperator(){
        return 'dmpl__Operation__c';
    }

    connectedCallback(){
        this.recordId = this.record.id;
        if(!this.recordId){
            this.handleEditCondition();
        }
    }

    getRecordFieldValue(fieldName) {
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );

        if (inputFields) {
            return  Array.from(inputFields).find(field => field.fieldName == fieldName)?.value;
        }
    }

    setRecordFieldValue(fieldName, fieldValue) {
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        if (inputFields) {
            inputFields.forEach(field => {
                if(field.fieldName == fieldName){
                    field.value = fieldValue;
                    return;
                }
            });
        }
    }

    setFieldTypeValue(value){
        if(!value){
            return;
        }
        this.selectedField = value;
        this.selectedFieldName = this.sourceObjectApiName + '.' + this.selectedField;
        this.fieldDataType = this.fieldOptions.find(v=>v.value == this.selectedField)?.dataType;
        this.setRecordFieldValue(this.getFieldName, this.selectedField);
        this.setFieldProxyValue();
        this.setFieldVisibility();
        this.setOperatorTypeValues();
    }

    setFieldVisibility(){
        this.isNumbericField = this.fieldDataType == 'Int';
        this.isCurrencyField = this.fieldDataType == 'Currency';
        this.isDoubleField = this.fieldDataType == 'Double';
        this.isStringField = this.fieldDataType == 'String' || this.fieldDataType == 'TextArea' || this.fieldDataType == 'Reference';
        this.isDateField = this.fieldDataType == 'Date' 
            && (this.dateLitralValue == 'CUSTOM' || !this.allowDateTimeLitrals);
        this.isDateTimeField = this.fieldDataType == 'DateTime' 
            && (this.dateLitralValue == 'CUSTOM' || !this.allowDateTimeLitrals);
        this.isUrlTimeField = this.fieldDataType == 'Url';
        this.isEmailTimeField = this.fieldDataType == 'Email';
        this.isPhoneTimeField = this.fieldDataType == 'Phone';
        this.isBooleanField = this.fieldDataType == 'Boolean';
        this.isPickListField = this.fieldDataType == 'Picklist';
        this.isDateLitral = this.allowDateTimeLitrals 
            && (this.fieldDataType == 'Date' || this.fieldDataType == 'DateTime');
        this.isDateNumber = this.isDateLitral && this.dateLitralValue && this.dateLitralValue.substr(this.dateLitralValue.length -2,2) ==':n';
    }

    setOperatorTypeValues(){
        let options = this.operatorOptions.filter(v=> 
            v.value== 'equals' 
            || v.value== 'notEqual');
        if(this.isStringField 
            || this.isUrlTimeField 
            || this.isEmailTimeField 
            || this.isPhoneTimeField){
                options = options.concat(this.operatorOptions.filter(v=> 
                    v.value== 'like'
                    || v.value== 'in'
                    || v.value== 'notIn'));
        } else if(this.isPickListField){
            options = options.concat(this.operatorOptions.filter(v=> 
                v.value== 'in'
                || v.value== 'notIn'));
        }else if(!this.isBooleanField){
            options = options.concat(this.operatorOptions.filter(v=> 
                v.value== 'lessThan'
                || v.value== 'greaterThan'
                || v.value== 'lessOrEqual'
                || v.value== 'greaterOrEqual'));
        }
        this.filteredOperatorOptions = options;
        this.selectedOperator = 'equals';
        this.setRecordFieldValue(this.getOperator, this.selectedOperator);
    }

    setFieldProxyValue(){
        let value = this.getRecordFieldValue(this.getFieldValue);
        this.stringValue = value;
        this.booleanValue = value?.toLowerCase() === 'true';
        this.floatValue = isNaN(parseFloat(value))?null:parseFloat(value);
        this.intValue = isNaN(parseInt(value))?null:parseInt(value);
        this.dateLitralValue = value;
        this.dateTimeValue = isNaN(Date.parse(value))?null:Date.parse(value);
        this.dateValue = this.dateTimeValue;
    }

    handleLoad(){
        const plValue = this.getRecordFieldValue(this.getFieldValue);
        this.selectedPicklistValue = plValue ? plValue.replaceAll('\'', '') : plValue;
        this.selectedDateLitralValue = plValue;
        this.setFieldTypeValue(this.getRecordFieldValue(this.getFieldName));
        if(!this.recordId && this.record){
            this.setRecordFieldValue(this.parentFieldName, this.record.parentId);
            this.setRecordFieldValue(this.getSequenceNumber, this.record.sequenceNumber);
        }
    }

    handleFieldChange(event){
        this.setFieldTypeValue(event.detail.value);
    }

    handleOperatorChange(event){
        this.setRecordFieldValue(this.getOperator, event.detail.value);
    }
    
    handleDateLitralChange(event){
        this.setRecordFieldValue(this.getFieldValue, event.detail.value);
        this.setFieldProxyValue();
        this.setFieldVisibility();
    }
    
    handleDateLitralNChange(event){
        let dtValue = this.dateLitralValue;
        if(dtValue && event.detail.value){
            const litalValue =  ':' + event.detail.value;
            dtValue = dtValue.replace(':n', litalValue);
            this.setRecordFieldValue(this.getFieldValue, dtValue);
        }
    }

    handleChange(event){
        let fieldVlaue = event.detail.value;
        if(fieldVlaue 
            && (this.isStringField 
            || this.isUrlTimeField 
            || this.isEmailTimeField 
            || this.isPhoneTimeField)){
                fieldVlaue = fieldVlaue.trim().replaceAll('\'', '');
                fieldVlaue = '\'' + fieldVlaue + '\'';
            }
        this.setRecordFieldValue(this.getFieldValue, fieldVlaue);
    } 

    handleToggleChange(event){
        this.setRecordFieldValue(this.getFieldValue, event.detail.checked?'true':'false');
    }
    
    handlePickListChange(event){
        this.setRecordFieldValue(this.getFieldValue, '\'' + event.detail.value + '\'');
    }

    handleEditCondition(event){
        this.isEditing = true;
    }

    handleSaveCondition(event){
        this.template.querySelector('lightning-record-edit-form').submit();
    }

    async handleDeleteCondition(event){
        const result = await LightningConfirm.open({
            message: `Are you sure you want to delete record \'${this.getRecordFieldValue(this.getFieldName)}\'.`,
            label: 'Confirm Delete!',
            variant: 'header',
            theme : 'warning'
        });
        //
        if(!result){
            return;
        }
        //
        deleteRecord(this.recordId)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Record deleted',
                        variant: 'success'
                    })
                );
                notifyRecordUpdateAvailable([{ "recordId": this.recordId }]);
                publish(this.messageContext, FORCEREFRESHMC, {delete:true, uid:this.recordId});
                this.refreshStdComponents();
            }).catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error deleting record',
                        message: error?.body?.message,
                        variant: 'error'
                    })
                );
            });
    }
    
    refreshStdComponents(){
        try{
            eval("$A.get('e.force:refreshView').fire();");
        }catch(e){
            this.dispatchEvent(new RefreshEvent());
        }
    }

    handleCancelCondition(event){
        this.isEditing = false;
        if(!this.recordId){
            publish(this.messageContext, FORCEREFRESHMC, {cancel:true, uid:this.record.uid});
            this.refreshStdComponents();
        }
    }

    async handleSuccess(event) {
        var recordId = event.detail ? event.detail.id : undefined;
        var lineName = event.detail ? event.detail.Name : undefined;
        var messsage = lineName 
            ? `Record \'${lineName}\' saved successfully.` : recordId 
            ? `Record \'${recordId}\' saved successfully.` : 'Record created successfully.';
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: messsage,
                variant: 'success',
            }),
        );
        publish(this.messageContext, FORCEREFRESHMC, {});
        notifyRecordUpdateAvailable([{ "recordId": recordId }]);
        this.refreshStdComponents();
        this.recordId = recordId;
        this.isEditing = false;
    }
}