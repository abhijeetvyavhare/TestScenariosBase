import { LightningElement, api, wire, track  } from 'lwc';
import getIncentiveLines from "@salesforce/apex/IncentiveController.getIncentiveLines";
import {subscribe, unsubscribe, MessageContext} from 'lightning/messageService';
import FORCEREFRESHMC from '@salesforce/messageChannel/ForceReset__c';

export default class IncentiveBuilderPanelcmp extends LightningElement {
    @api recordId;
    @api conditionTitle = 'Conditions';
    @api resultTitle = 'Rewards';
    @api incentiveLineObjectApiName = 'dmpl__IncentiveLine__c';
    @api incentiveLines = [];
    @api incentiveLine;
 
    incentiveStatus = '';

    @wire(MessageContext) 
    messageContext;

    get allowEditing(){
        return this.incentiveStatus == 'Draft';
    }
    
    get showExpanded(){
        return this.incentiveStatus != 'Draft';
    }

    connectedCallback() {
        this.subscription = subscribe(
            this.messageContext,
            FORCEREFRESHMC,
            (message) => {
                this.handleForceRefresh(message);
            }
        );
        this.loadData();
    }

    disconnectedCallback() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }

    handleDataUpdated(event){
        this.loadData();
    }

    loadData(){
        this.incentiveLine =  { 
            'dmpl__IncentivePlanId__c' : this.recordId,
            'dmpl__IncentiveTargets__r' : [],  
            'dmpl__CompensationSlabs__r' : []
        };
        getIncentiveLines({ incentiveId: this.recordId }).then((incentiveLinesInfo) => {
            this.incentiveLines = JSON.parse(JSON.stringify(incentiveLinesInfo));
            if(this.incentiveLines && this.incentiveLines.length > 0){
                this.incentiveStatus = this.incentiveLines[0]?.dmpl__IncentivePlanId__r?.dmpl__Status__c;
            }else{
                this.incentiveStatus = 'Draft';
            }
        });
    }
    
    handleForceRefresh(message) {
        this.loadData();
    }
}