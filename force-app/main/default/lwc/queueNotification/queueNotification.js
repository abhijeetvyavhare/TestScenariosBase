import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import getQueueStatus from '@salesforce/apex/InterfaceServiceProviderController.getQueueStatus';
import FORCEREFRESHMC from '@salesforce/messageChannel/ForceReset__c';
import { RefreshEvent } from 'lightning/refresh';
import {subscribe, unsubscribe, MessageContext} from 'lightning/messageService';
import LightningModal from 'lightning/modal';
import { notifyRecordUpdateAvailable } from 'lightning/uiRecordApi';

export default class DmplNotification extends LightningModal {
    @api recordId;
    @api objectApiName;
    @api message;

    showStatus = false;
    recordFields;
    isVisible;
    queueId;
    status;
    
    @wire(MessageContext)
    messageContext;

    @wire(getRecord, { recordId: '$recordId', fields: '$recordFields' })
    getRecordDetails({ error, data }) {
        if (data) {
            if (data.fields['dmpl__IsInJobQueue__c']){
                this.isVisible = data.fields['dmpl__IsInJobQueue__c']?.value;
                this.queueId = data.fields['dmpl__JobQueueId__c']?.value;
                if(this.isVisible){
                    this.updateStatus();
                }
            }
        }else if(error){
            this.isVisible = false;
            this.handleClose();
        }
    }

    async updateStatus(){
        const queueResult = await getQueueStatus(
            {
                queueId: this.queueId
            });
        if(queueResult){
            const status = queueResult.dmpl__ExecutionLog__c;
            this.status = status;
            const textarea = this.template.querySelector('lightning-textarea');
            if(textarea){
                textarea.focus();
                textarea.scrollTop = textarea.scrollHeight;
                textarea.setRangeText('...', status.length, status.length+3);
                textarea.scrollIntoView();
            }
            this.isVisible = !queueResult.dmpl__IsApexJobExecuted__c;
            if(!this.isVisible){
                this.handleClose();
            }
        }
        if(this.isVisible){
            setTimeout(() => {
                this.updateStatus();
            }, 2000);
        }
    }
    
    handleForceRefresh(){

    }

    connectedCallback(){
        this.isVisible = true;
        this.recordFields = [this.objectApiName + '.dmpl__IsInJobQueue__c', this.objectApiName + '.dmpl__JobQueueId__c'];
        this.subscription = subscribe(
            this.messageContext,
            FORCEREFRESHMC,
            (message) => {
                this.handleForceRefresh(message);
            }
        );
    }
    
    disconnectedCallback() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }

    handleViewDetails(){
        this.showStatus = !this.showStatus;
    }
    
    handleClose() {
        notifyRecordUpdateAvailable([{ "recordId": this.recordId }]);
        this.refreshStdComponents();
        this.close('okay');
    }

    refreshStdComponents(){
        try{
            eval("$A.get('e.force:refreshView').fire();");
        }catch(e){
            this.dispatchEvent(new RefreshEvent());
        }
    }
}