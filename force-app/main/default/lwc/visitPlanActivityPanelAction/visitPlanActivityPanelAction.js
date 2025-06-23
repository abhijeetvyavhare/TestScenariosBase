import { LightningElement, api } from 'lwc';

export default class VisitPlanActivityPanelAction extends LightningElement {
    @api title;
    @api 
    get objectApiName() {
        return this._objectApiName;
    }
    set objectApiName(value) {
        this._objectApiName = value;
        if(this._objectApiName == 'dmpl__Visit__c'){
            this.visitId = this._recordId;
        }
    }
    
    @api
    get recordId() {
        return this._recordId;
    }
    set recordId(value) {
        this._recordId = value;
        if(this._objectApiName == 'dmpl__Visit__c'){
            this.visitId = this._recordId;
        }
    }
    _recordId;
    _objectApiName;
}