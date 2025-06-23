import { LightningElement, api, wire, track } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { getRecord } from 'lightning/uiRecordApi';
import testAction from '@salesforce/apex/InterfaceServiceProviderController.testAction';

const FIELDSLIST = [
    'dmpl__InterfaceServiceProviderRequest__c.dmpl__HttpHeaders__c', 
    'dmpl__InterfaceServiceProviderRequest__c.dmpl__HttpQuery__c', 
    'dmpl__InterfaceServiceProviderRequest__c.dmpl__PayloadSchema__c', 
    'dmpl__InterfaceServiceProviderRequest__c.dmpl__ResponseSchema__c', 
    'dmpl__InterfaceServiceProviderRequest__c.dmpl__Function__c', 
    'dmpl__InterfaceServiceProviderRequest__c.dmpl__CustomFunction__c',
    'dmpl__InterfaceServiceProviderRequest__c.dmpl__SObjectRecordId__c',
    'dmpl__InterfaceServiceProviderRequest__c.dmpl__InterfaceServiceProviderId__c' ];
export default class EInvoicePanel extends LightningElement {
    @api title;
    @api recordId;
    @api targetObjectRecordId
    @api objectApiName;

    @track status;
    @track request = 'No Data to show!';
    @track response = 'No Data to show!';
    @track parsedRequest;
    @track headers;
    @track responseHeaders;
    @track query;
    @track functionName;
    @track customFunctionName;
    @track providerId;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDSLIST})
    wiredRecord(d){
        if(d.data){
            this.headers = d.data.fields.dmpl__HttpHeaders__c?.value;
            this.query = d.data.fields.dmpl__HttpQuery__c?.value;
            this.request = d.data.fields.dmpl__PayloadSchema__c?.value; //JSON.stringify(JSON.parse(d.data.fields.dmpl__PayloadSchema__c?.value), null, "\t");
            this.functionName = d.data.fields.dmpl__Function__c?.value;
            this.customFunctionName = d.data.fields.dmpl__CustomFunction__c?.value;
            this.providerId = d.data.fields.dmpl__InterfaceServiceProviderId__c?.value;    
            this.targetObjectRecordId = d.data.fields.dmpl__SObjectRecordId__c?.value;
        }
    }

    performServerAction(functionName){
        this.status = 'Sending data to server...';
        testAction(
            {
                providerId : this.providerId,
                requestId : this.recordId,
                recordId : this.targetObjectRecordId,
                headers : this.headers,
                query : this.query,
                payload : this.request
            })
            .then(result=>
                {
                    this.parsedRequest = result.parsedRequest;
                    this.status = `${result.status} (${result.statusCode})`;
                    this.responseHeaders = result.headers;
                    try{
                        this.response = JSON.stringify(JSON.parse(result.body), null, "\t");
                    }catch(e){
                        this.response = result.body;
                    }
                })
            .catch(error=>{
                this.response = undefined;
                if(error?.body?.message){
                    this.status = 'Error : ' + error?.body?.message;
                }else if(error?.body?.fieldErrors){
                    this.status = 'Error : ' + Object.entries(error?.body?.fieldErrors).map(([k,v]) => `Field: ${k} Message ${v.map(a=>a.message).toString()}`).toString();
                }
                console.log(error);        
            });
    }
    
    handleDialogClose() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    handleRequestChange(event) {
        this.request = event.detail.value;
    }

    handleHeaderChange(event) {
        this.headers = event.detail.value;
    }

    handleQueryChange(event) {
        this.query = event.detail.value;
    }

    handleRecordIdChange(event) {
        this.targetObjectRecordId = event.detail.value;
    }
    
}