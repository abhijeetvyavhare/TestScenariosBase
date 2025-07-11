import { LightningElement, api, wire } from 'lwc';
import { getRecord } from "lightning/uiRecordApi";
import { CloseActionScreenEvent } from 'lightning/actions';
import accountLabel from '@salesforce/label/c.LeadConvertPanel_AccountLabel'
import contactLabel from '@salesforce/label/c.LeadConvertPanel_ContactLabel'
import opportunityLabel from '@salesforce/label/c.LeadConvertPanel_OpportunityLabel'
import headerLabel from '@salesforce/label/c.LeadConvertPanel_HeaderLabel'
import getFieldsByFieldSetName from '@salesforce/apex/MetadataController.getFieldsByFieldSetName';
import convertLead from '@salesforce/apex/ServiceLeadController.convertLead';
import { notifyRecordUpdateAvailable } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { publish, MessageContext } from 'lightning/messageService';
import FORCEREFRESHMC from '@salesforce/messageChannel/ForceReset__c';
import { reduceErrors } from 'c/utils';
import { RefreshEvent } from 'lightning/refresh';
import getLeadConvertStatus from '@salesforce/apex/ServiceLeadController.getLeadConvertStatus';
import getAllFieldMappings from '@salesforce/apex/RecordFormController.getAllFieldMappings';
import getFieldMappingsData from '@salesforce/apex/RecordFormController.getFieldMappingsData';

export default class LeadConvertPanel extends LightningElement {
    @api recordId;
    @api objectApiName;
    @api targetObjectApiName;
    isWorking = false;
    isLoaded = false;
    customLabel = {
        headerLabel,
        accountLabel,
        contactLabel,
        opportunityLabel
    }
    accountOptionId = 'new';
    accountOptions = [
        { label: 'New Account', value: 'new' },
        { label: 'Existing Account', value: 'existing' }];
    contactOptionId = 'new';
    contactOptions = [
        { label: 'None', value: 'none' },
        { label: 'New Contact', value: 'new' },
        { label: 'Existing Contact', value: 'existing' }];
    optyOptionId = 'new';
    optyOptions = [
        { label: 'New Opportunity', value: 'new' },
        { label: 'Existing Opportunity', value: 'existing' }];
    
    @wire(MessageContext)
    messageContext;

    @wire(getRecord, { 
        recordId: '$recordId',  
        fields: '$getRecordFields'})
    wiredRecord({ error, data }) {
        if (data) {
            this.accountId = data.fields.dmpl__AccountId__c?.value;
            this.accountName = data.fields.dmpl__AccountName__c?.value;
            this.contactName = data.fields.dmpl__ContactName__c?.value;
            this.contactId = data.fields.dmpl__ContactId__c?.value;
            this.targetObjectId = data.fields.dmpl__ServiceRequestId__c?.value;
            if(this.accountId){
                this.accountOptionId = 'existing';
            }    
            if(this.contactId){
                this.contactOptionId = 'existing';
            }
            if(this.targetObjectId){
                this.optyOptionId = 'existing';
            }
            if(!this.contactId
                && !this.contactName){
                this.contactOptionId = 'none';
            }
            this.isLoaded = true;
        }
    }
    
    @wire(getFieldsByFieldSetName, { 
        objectApiName: '$objectApiName', 
        fieldSetName: 'DMSLeadConvertFieldset' })
    fieldsetFields;

    @wire(getLeadConvertStatus, {})
    leadConvertStatus;

    @wire(getFieldsByFieldSetName, { 
        objectApiName: 'Account', 
        fieldSetName: 'ConvertLeadFieldset1' })
    newAccountFieldset1;

    @wire(getFieldsByFieldSetName, { 
        objectApiName: 'Account', 
        fieldSetName: 'ConvertLeadFieldset2' })
    newAccountFieldset2;

    @wire(getFieldsByFieldSetName, { 
        objectApiName: 'Account', 
        fieldSetName: 'ConvertLeadFieldset3' })
    newAccountFieldset3;

    @wire(getFieldsByFieldSetName, { 
        objectApiName: 'Contact', 
        fieldSetName: 'ConvertLeadFieldset' })
    newContactFieldset;

    @wire(getFieldsByFieldSetName, { 
        objectApiName: '$targetObjectApiName', 
        fieldSetName: 'ConvertLeadFieldset' })
    newOptyFieldset;

    get getRecordFields(){
        let fields = [];
        fields.push(this.objectApiName.concat('.', 'dmpl__AccountId__c'));
        fields.push(this.objectApiName.concat('.', 'dmpl__AccountName__c'));
        fields.push(this.objectApiName.concat('.', 'dmpl__ContactName__c'));
        fields.push(this.objectApiName.concat('.', 'dmpl__ContactId__c'));
        fields.push(this.objectApiName.concat('.', 'dmpl__ServiceRequestId__c'));
        return fields;
    }
    
    get isNewAccount() {
        return this.accountOptionId == 'new';
    }
    
    get isExistingAccount() {
        return this.accountOptionId == 'existing';
    }

    get isNewContact() {
        return this.contactOptionId == 'new';
    }

    get isExistingContact() {
        return this.contactOptionId == 'existing';
    }

    get isNewOpty() {
        return this.optyOptionId == 'new';
    }

    get isExistingOpty() {
        return this.optyOptionId == 'existing';
    }

    get getFieldsetFields() {
        if (this.fieldsetFields && this.fieldsetFields.data) {
            return this.fieldsetFields.data;
        }
    }
    
    get hasFieldsetFields() {
        return this.getFieldsetFields && this.getFieldsetFields.length >0;
    }

    get getNewAccountFieldset1() {
        if (this.newAccountFieldset1 && this.newAccountFieldset1.data) {
            return this.newAccountFieldset1.data;
        }
    }

    get getNewAccountFieldset2() {
        if (this.newAccountFieldset1 && this.newAccountFieldset2.data) {
            return this.newAccountFieldset2.data;
        }
    }

    get getNewAccountFieldset3() {
        if (this.newAccountFieldset3 && this.newAccountFieldset3.data) {
            return this.newAccountFieldset3.data;
        }
    }
    
    get hasAccountFields() {
        return this.getNewAccountFieldset1 && this.getNewAccountFieldset1.length >0
         ||  this.getNewAccountFieldset2 && this.getNewAccountFieldset2.length >0
         ||  this.getNewAccountFieldset3 && this.getNewAccountFieldset3.length >0;
    }

    get getNewContactFieldset() {
        if (this.newContactFieldset && this.newContactFieldset.data) {
            return this.newContactFieldset.data;
        }
    }
    
    get hasContactFields() {
        return this.getNewContactFieldset && this.getNewContactFieldset.length >0;
    }

    get getNewOptyFieldset() {
        if (this.newOptyFieldset && this.newOptyFieldset.data) {
            return this.newOptyFieldset.data;
        }
    }

    get hasOptyFields() {
        return this.getNewOptyFieldset && this.getNewOptyFieldset.length >0;
    }

    connectedCallback(){
        this.objectApiName = 'dmpl__ServiceLead__c';
        this.targetObjectApiName = 'dmpl__ServiceRequest__c';
    }

    setFieldValue(name, value) {
        const inputFields = Array.from(this.template.querySelectorAll(
            'lightning-input-field'
        ));
        let field = inputFields && inputFields.find(v=>v.fieldName == name);
        if(field && field.value != value){
            field.value = value;
        }
    }

    getFieldValue(name) {
        const inputFields = Array.from(this.template.querySelectorAll(
            'lightning-input-field'
        ));
        let field = inputFields && inputFields.find(v=>v.fieldName == name);
        if(field && field.value){
            return field.value;
        }
        return null;
    }

    handleAccountOptionChange(event){
        this.accountOptionId = event.detail.value;
    }

    handleContactOptionChange(event){
        this.contactOptionId = event.detail.value;
    }

    handleOptyOptionChange(event){
        this.optyOptionId = event.detail.value;
    }

    handleAccountChange(event){

    }

    handleFieldChange(event){

    }
    
    handleClose(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    handleFormLoad(){

    }

    handleLeadFormLoaded(){
        if(!this.isLeadFormLoaded){
            if(this.leadConvertStatus && this.leadConvertStatus.data){
                this.setFieldValue('dmpl__Status__c', this.leadConvertStatus.data);
            }
            this.isLeadFormLoaded = true;
        }
    }
    
    handleAccountFormLoad(){
        if(!this.isAccountFormLoaded){
            if(this.accountName){
                this.setFieldValue('Name', this.accountName);
            }
            this.copyFieldMappingData(this.objectApiName, 'Account', this.recordId);
            if(!this.desinationMapping){
                return;
            }  
            this.isAccountFormLoaded = true;
        }
    }

    handleContactFormLoad(){
        if(!this.isContactFormLoaded){
            if(this.contactName){
                this.setFieldValue('LastName', this.contactName);
            }
            this.copyFieldMappingData(this.objectApiName, 'Contact', this.recordId);
            if(!this.desinationMapping){
                return;
            }  
            this.isContactFormLoaded = true;
        }
    }
    
    handleOptyFormLoad(){
        if(!this.isOptyFormLoaded){
            this.copyFieldMappingData(this.objectApiName, this.targetObjectApiName, this.recordId);
            if(!this.desinationMapping){
                return;
            }  
            this.isOptyFormLoaded = true;
        }
    }

    async handleSave(event){
        this.isWorking = true;
        let payload = {
            createNewAccount : this.isNewAccount,
            createNewContact : this.isNewContact,
            createNewServiceRequest : this.isNewOpty,
            leadId : this.recordId
        };
        payload.accountFields = Array.from(this.getNewAccountFieldset1).map(f=>{
            return {
                fieldName: f.apiName,
                fieldValue: this.getFieldValue(f.apiName)
            }
        });

        payload.accountFields = payload.accountFields.concat(Array.from(this.getNewAccountFieldset2).map(f=>{
            return {
                fieldName: f.apiName,
                fieldValue: this.getFieldValue(f.apiName)
            }
        }));
    
        payload.accountFields = payload.accountFields.concat(Array.from(this.getNewAccountFieldset3).map(f=>{
            return {
                fieldName: f.apiName,
                fieldValue: this.getFieldValue(f.apiName)
            }
        }));

        payload.contactFields = Array.from(this.getNewContactFieldset).map(f=>{
            return {
                fieldName: f.apiName,
                fieldValue: this.getFieldValue(f.apiName)
            }
        });

        payload.serviceRequestFields = Array.from(this.getNewOptyFieldset).map(f=>{
            return {
                fieldName: f.apiName,
                fieldValue: this.getFieldValue(f.apiName)
            }
        });

        payload.leadFields = Array.from(this.getFieldsetFields).map(f=>{
            return {
                fieldName: f.apiName,
                fieldValue: this.getFieldValue(f.apiName)
            }
        });

        await convertLead({ 
            data : payload
        }).then(response => {
            this.showMessage('Saved Successfully!');
            notifyRecordUpdateAvailable([{ "recordId": this.recordId }]);
            this.refreshStdComponents();
            publish(this.messageContext, FORCEREFRESHMC, {});
            this.handleClose();
        }).catch(error => {
            this.showError(error);
        });
        this.isWorking = false;
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

    showMessage(message) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: message,
                variant: 'success',
            }),
        );
    }

    async copyFieldMappingData(sourceApiName, destinationApiName, objectId){        
        const desinationMapping = await getAllFieldMappings({ 
            destinationObjectApiName : destinationApiName});

        if(!desinationMapping || desinationMapping.length == 0){
            return;
        }
        let mappings = desinationMapping.filter(v => 
            v.dmpl__SourceObjectNameId__r?.QualifiedApiName == sourceApiName).sort((a, b) => 
                a.dmpl__SequenceNumber__c && b.a.dmpl__SequenceNumber__c ? a.dmpl__SequenceNumber__c - b.dmpl__SequenceNumber__c : 0);
        if(mappings && mappings.length>0){
            if(objectId){
                const result = await getFieldMappingsData({ 
                    sourceObjectApiName: sourceApiName,
                    destinationObjectApiName: destinationApiName,
                    objectId: objectId});
                if (result && result.length>0) {
                    let source = result[0]; 
                    mappings.forEach(m=>{
                        if(m.dmpl__DestinationFieldName__r.QualifiedApiName
                            && m.dmpl__SourceFieldNameId__r.QualifiedApiName 
                            && source[m.dmpl__SourceFieldNameId__r.QualifiedApiName]){
                                if(!m.dmpl__CopyOnlyIfEmpty__c
                                    || (!this.getFieldValue(m.dmpl__DestinationFieldName__r?.QualifiedApiName))
                                    ){
                                        this.setFieldValue(
                                            m.dmpl__DestinationFieldName__r?.QualifiedApiName, 
                                            source[m.dmpl__SourceFieldNameId__r.QualifiedApiName]);
                                    }
                        }
                    });
                }   
            } else {
                mappings.forEach(m=>{
                    if(m.dmpl__DestinationFieldName__r.QualifiedApiName
                        && m.dmpl__SourceFieldNameId__r.QualifiedApiName){                            
                            this.setFieldValue(
                                m.dmpl__DestinationFieldName__r?.QualifiedApiName, 
                                undefined);
                    }
                });
            }        
        }
    }
}