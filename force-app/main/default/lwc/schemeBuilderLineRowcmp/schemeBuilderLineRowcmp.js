import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { publish, MessageContext } from 'lightning/messageService';
import { deleteRecord } from 'lightning/uiRecordApi';
import { RefreshEvent } from 'lightning/refresh';
import LightningConfirm from 'lightning/confirm';
import FORCEREFRESHMC from '@salesforce/messageChannel/ForceReset__c';

export default class SchemeBuilderLineRowcmp extends LightningElement {
    @api title;
    @api conditionTitle;
    @api resultTitle;
    @api schmeLineObjectApiName;
    @api isNew;
    @api allowEditing;
    @api isPanelVisible;

    isEditing = false;
    isConditionCustomLogic = false;
    isRewardCustomLogic = false;
    filterCriteria;
    rewardApplicability;
    _schemeLine;
    @track schemeConditions;
    @track schemeBenefits;

    @wire(MessageContext)
    messageContext;

    @api
    get schemeLine(){
        return this._schemeLine;
    }
    set schemeLine(value){
        this._schemeLine = value;
        this.initSchemeLine();
    }

    get fullTitle(){
        if(this.lineTitle){
            return this.lineTitle;
        }else {
            return 'Scheme Slab : ' + this.title;
        }
    }

    get getIsPanelCollapsed() {
        return !this.isPanelVisible;
    }
    
    get getIsEditButtonVisible(){
        return this.allowEditing && this.isPanelVisible && !this.isEditing && (!this.isNew);
    }

    get getIsDeleteButtonVisible(){
        return this.allowEditing && this.isPanelVisible && !this.isEditing && (!this.isNew);
    }

    get getDisableActions(){
        return !this.allowEditing;
    }

    handlePanelVisibility(event) {
        event.preventDefault();
        event.stopPropagation();
        this.isPanelVisible = !this.isPanelVisible;
    }

    handleEditClicked(event) {
        this.isEditing = true;
    }

    async handleDeleteClicked(event) {
        const result = await LightningConfirm.open({
            message: `Are you sure you want to delete scheme slab \'${this._schemeLine.Name}\'.`,
            label: 'Confirm Delete!',
            variant: 'header',
            theme : 'warning'
        });
        //
        if(!result){
            return;
        }
        //
        deleteRecord(this._schemeLine.Id)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Record deleted',
                        variant: 'success'
                    })
                );
                this.beginRefresh();      
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error deleting record',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }

    handleCancelClicked(event) {
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        if (inputFields) {
            inputFields.forEach(field => {
                field.reset();
            });
        }

        if(!this.isNew){
            this.isEditing = false;
        }
    }

    handleSaveClicked(event) {
        this.template.querySelector('lightning-record-edit-form').submit();
    }
    
    handleFilterCriteriaChange(event){
        this.filterCriteria = event.detail.value;
        this.isConditionCustomLogic = this.filterCriteria == 'Custom Logic Is Met';
    }

    handleRewardApplicabilityChange(e){
        this.rewardApplicability = e.detail.value;
        this.isRewardCustomLogic = this.rewardApplicability == 'Custom Logic';
    }

    handleAddCondition(e){
        this.schemeConditions.push(this.createConditionLine());
    }

    handleAddReward(e){
        this.schemeBenefits.push(this.createRewardLine());
    }

    createConditionLine(){
        return {
            'dmpl__SchemeId__c' : this.schemeLine.dmpl__SchemeId__c,
            'dmpl__SchemeLineId__c' : this.schemeLine.Id,
            'Id' : undefined,
            "Name" : undefined,
            'dmpl__ConditionType__c' : undefined,
            'dmpl__ConditionOperator__c' : undefined,
            'dmpl__AccountId__c' : undefined,
            'dmpl__AccountId__r' : { 'Name' : undefined},
            'dmpl__AccountGroupId__c' : undefined,
            'dmpl__AccountGroupId__r' : { 'Name' : undefined},
            'dmpl__ItemId__c' : undefined,
            'dmpl__ItemId__r' : { 'Name' : undefined},
            'dmpl__ItemGroupId__c' : undefined,
            'dmpl__ItemGroupId__r' : { 'Name' : undefined},
            'dmpl__ConditionQuantity__c' : undefined,
            'dmpl__ConditionValue__c' : undefined,
            'dmpl__SequenceNumber__c' : this.schemeLine.dmpl__SchemeConditions__r?.length > 0 ? this.schemeLine.dmpl__SchemeConditions__r?.length + 1 : 1
        }
    }

    createRewardLine(){
        return {
            'Id' : undefined,
            'Name' : undefined,
            'dmpl__SchemeId__c' : this.schemeLine.dmpl__SchemeId__c,
            'dmpl__SchemeLineId__c' : this.schemeLine.Id,
            'dmpl__DiscountAmount__c' : undefined,
            'dmpl__DiscountPercent__c' : undefined,
            'dmpl__DiscountedItemId__c' : undefined,
            'dmpl__DiscountedItemId__r' : { 'Name' : undefined},
            'dmpl__DiscountedItemSKUId__c' : undefined,
            'dmpl__DiscountedItemSKUId__r' : { 'Name' : undefined},
            'dmpl__DiscountedItemGroupId__c' : undefined,
            'dmpl__DiscountedItemGroupId__r' : { 'Name' : undefined},
            'dmpl__DiscountedItemQuantity__c' : undefined,
            'dmpl__RewardType__c' : undefined,
            'dmpl__SequenceNumber__c' : this.schemeLine.dmpl__SchemeBenefits__r?.length > 0 ? this.schemeLine.dmpl__SchemeBenefits__r?.length + 1 : 1
        }
    }

    connectedCallback() {
        this.initSchemeLine();
    }

    initSchemeLine(){
        this._schemeLine = JSON.parse(JSON.stringify(this._schemeLine));
        this.filterCriteria = this.schemeLine?.dmpl__DefinitionFilterCriteria__c;
        this.rewardApplicability = this.schemeLine?.dmpl__RewardApplicability__c;
        this.isRewardCustomLogic = this.rewardApplicability == 'Custom Logic';
        this.isConditionCustomLogic = this.filterCriteria == 'Custom Logic Is Met';
        if(this.schemeLine?.dmpl__Title__c){
            this.lineTitle = `${this.schemeLine?.dmpl__Title__c} (${this.schemeLine?.Name})`;
        }
        
        if(!this.schemeLine?.dmpl__SchemeConditions__r){
            this.schemeLine.dmpl__SchemeConditions__r = [];
        }
        if(!this.schemeLine?.dmpl__SchemeBenefits__r){
            this.schemeLine.dmpl__SchemeBenefits__r = [];
        }
        this.schemeBenefits = this._schemeLine.dmpl__SchemeBenefits__r;
        this.schemeConditions = this._schemeLine.dmpl__SchemeConditions__r;
        this.isEditing = this.isNew;
    }

    async handleSuccess(event) {
        var recordId = event.detail ? event.detail.id : undefined;
        var lineName = event.detail ? event.detail.Name : undefined;
        var messsage = lineName ? `Scheme Line \'${lineName}\' saved successfully.` : recordId ? `Scheme Line \'${recordId}\' saved successfully.` : 'Record created successfully.';
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: messsage,
                variant: 'success',
            }),
        );
        this.beginRefresh();
        this.isEditing = false;   
    }

    beginRefresh() {
        this.refreshStdComponents();
        publish(this.messageContext, FORCEREFRESHMC);
     }

    refreshStdComponents(){
        try{
            eval("$A.get('e.force:refreshView').fire();");
        }catch(e){
            this.dispatchEvent(new RefreshEvent());
        }
    }
}