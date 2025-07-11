import { LightningElement, api, wire } from 'lwc';
import getRecommendations from '@salesforce/apex/SchemeController.getRecommendations';
import getSchemeLedgerEntries from '@salesforce/apex/SchemeController.getSchemeLedgerEntries';
import {subscribe, unsubscribe, MessageContext} from 'lightning/messageService';
import FORCEREFRESHMC from '@salesforce/messageChannel/ForceReset__c';
import { refreshApex } from '@salesforce/apex';
import { notifyRecordUpdateAvailable } from 'lightning/uiRecordApi';

export default class SchemeRecommendations extends LightningElement {
    @api title;
    @api recordId;
    @api objectApiName;

    @wire(MessageContext)
    messageContext;

    @wire(getRecommendations, { recordId: '$recordId' })
    recommendations;

    @wire(getSchemeLedgerEntries, { objectApiName: '$objectApiName', recordId: '$recordId' })
    wiredSchemeLedgerEntries;

    get getNoRecomendationAvailable(){
        return (!this.getLedgerData) && (!this.getRecomendationsData);
    }

    get getRecomendationsData() {
        return undefined;
        // if (this.recommendations && this.recommendations.data)
        //     return this.recommendations.data;
    }

    get getLedgerData() {
        if (
            this.wiredSchemeLedgerEntries 
            && this.wiredSchemeLedgerEntries.data 
            && this.wiredSchemeLedgerEntries.data.length >0)
            return this.wiredSchemeLedgerEntries.data;
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
        refreshApex(this.wiredSchemeLedgerEntries);
        //notifyRecordUpdateAvailable([{ "recordId": recordId }]);
    }
}