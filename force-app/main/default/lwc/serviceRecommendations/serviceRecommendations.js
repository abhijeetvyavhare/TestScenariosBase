import { LightningElement, api, wire } from 'lwc';
import getRecommendations from '@salesforce/apex/ServiceRecommendationController.getServiceRecommendations';
import performAction from '@salesforce/apex/ServiceRecommendationController.performAction';
import {subscribe, unsubscribe, MessageContext} from 'lightning/messageService';
import { RefreshEvent } from 'lightning/refresh';
import FORCEREFRESHMC from '@salesforce/messageChannel/ForceReset__c';
import { refreshApex } from '@salesforce/apex';
import { notifyRecordUpdateAvailable } from 'lightning/uiRecordApi';
import { reduceErrors } from 'c/utils';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ServiceRecommendations extends LightningElement {
    @api title;
    @api recordId;
    @api objectApiName;

    @wire(MessageContext)
    messageContext;

    @wire(getRecommendations, { fieldApiName: '$getFieldApiName', recordId: '$recordId' })
    recommendations;

    get getFieldApiName(){
        return this.objectApiName.replace('__c', 'Id__c');
    }

    get getNoRecomendationAvailable(){
        return (!this.getRecomendationsData) 
            || this.getRecomendationsData && this.getRecomendationsData.length == 0;
    }

    get getRecomendationsData() {
        if (this.recommendations && this.recommendations.data)
            return this.recommendations.data.filter(d=> !d.dmpl__IsAccepted__c && !d.dmpl__IsRejected__c);
    }

    connectedCallback(){
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
    
    handleForceRefresh(message) {
        refreshApex(this.recommendations);
        notifyRecordUpdateAvailable([{ "recordId": this.recordId }]);
        this.refreshStdComponents();
    }

    refreshStdComponents(){
        try{
            eval("$A.get('e.force:refreshView').fire();");
        }catch(e){
            this.dispatchEvent(new RefreshEvent());
        }
    }

    async handleActionClick(event){
        try{
            let recommendationId = event.target.dataset.recordId;
            let result = await performAction(
                {
                    recommendationId : recommendationId, 
                    actionName : event.target.name,
                    tag : ''
                });
            if(result){
                this.showMessage('Action Successful!');
                this.handleForceRefresh();
            }
        }catch(error){
            this.showError(error);
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
}