import { LightningElement, api, wire, track  } from 'lwc';
import getSchemeLines from "@salesforce/apex/SchemeController.getSchemeLines";
import {subscribe, unsubscribe, MessageContext} from 'lightning/messageService';
import FORCEREFRESHMC from '@salesforce/messageChannel/ForceReset__c';

export default class SchemeBuilderPanelcmp extends LightningElement {
    @api recordId;
    @api conditionTitle = 'Conditions';
    @api resultTitle = 'Rewards';
    @api schmeLineObjectApiName = 'dmpl__SchemeLine__c';
    @api schemeLines = [];
    @api schemeLine;
 
    schemeStatus = '';

    @wire(MessageContext) 
    messageContext;

    get allowEditing(){
        return this.schemeStatus == 'Draft';
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
        this.schemeLine =  { 
            'dmpl__SchemeId__c' : this.recordId,
            'dmpl__SchemeConditions__r' : [],  
            'dmpl__SchemeBenefits__r' : []
        };
        getSchemeLines({ schemeId: this.recordId }).then((schemeLinesInfo) => {
            this.schemeLines = JSON.parse(JSON.stringify(schemeLinesInfo));
            if(this.schemeLines && this.schemeLines.length > 0){
                this.schemeStatus = this.schemeLines[0]?.dmpl__SchemeId__r?.dmpl__Status__c;
            }else{
                this.schemeStatus = 'Draft';
            }
        });
    }
    
    handleForceRefresh(message) {
        this.loadData();
    }
}