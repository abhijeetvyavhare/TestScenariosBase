import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { publish, MessageContext } from 'lightning/messageService';
import { RefreshEvent } from 'lightning/refresh';
import { deleteRecord } from 'lightning/uiRecordApi';
import LightningConfirm from 'lightning/confirm';
import FORCEREFRESHMC from '@salesforce/messageChannel/ForceReset__c';

export default class IncentiveBuilderLineRowcmp extends LightningElement {
    @api title;
    @api conditionTitle;
    @api resultTitle;
    @api incentiveLineObjectApiName;
    @api isNew;
    @api allowEditing;
    @api isPanelVisible;

    isEditing = false;
    isConditionCustomLogic = false;
    isRewardCustomLogic = false;
    filterCriteria;
    rewardApplicability;
    _incentiveLine;
    useSlabAbsoluteValue = false;
    @track incentiveConditions;
    @track incentiveBenefits;

    @wire(MessageContext)
    messageContext;

    @api
    get incentiveLine(){
        return this._incentiveLine;
    }
    set incentiveLine(value){
        this._incentiveLine = value;
        this.initIncentiveLine();
    }

    get fullTitle(){
        if(this.lineTitle){
            return this.lineTitle;
        }else {
            return 'Incentive Slab : ' + this.title;
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
            message: `Are you sure you want to delete Incentive Compensation slab \'${this._incentiveLine.Name}\'.`,
            label: 'Confirm Delete!',
            variant: 'header',
            theme : 'warning'
        });
        //
        if(!result){
            return;
        }
        //
        deleteRecord(this._incentiveLine.Id)
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
        this.incentiveConditions.push(this.createConditionLine());
    }

    handleAddReward(e){
        this.incentiveBenefits.push(this.createRewardLine());
    }

    createConditionLine(){
        return {
            'dmpl__IncentivePlanId__c' : this.incentiveLine.dmpl__IncentivePlanId__c,
            'dmpl__IncentiveLineId__c' : this.incentiveLine.Id,
            'Id' : undefined,
            // "Name" : undefined,
            'dmpl__IncentiveTargetType__c' : undefined,
            // 'dmpl__ConditionOperator__c' : undefined,
            'dmpl__AccountId__c' : undefined,
            'dmpl__AccountId__r' : { 'Name' : undefined},
            'dmpl__AccountGroupId__c' : undefined,
            'dmpl__AccountGroupId__r' : { 'Name' : undefined},
            'dmpl__ItemId__c' : undefined,
            'dmpl__ItemId__r' : { 'Name' : undefined},
            'dmpl__ItemGroupId__c' : undefined,
            'dmpl__ItemGroupId__r' : { 'Name' : undefined},
            'dmpl__Value__c' : undefined,
            'dmpl__SequenceNumber__c' : this.incentiveLine.dmpl__IncentiveTargets__r?.length > 0 ? this.incentiveLine.dmpl__IncentiveTargets__r?.length + 1 : 1
        }
    }

    createRewardLine(){
        return {
            'Id' : undefined,
            // 'Name' : undefined,
            'dmpl__IncentivePlanId__c' : this.incentiveLine.dmpl__IncentivePlanId__c,
            'dmpl__IncentiveLineId__c' : this.incentiveLine.Id,
            'dmpl__FromPercentage__c' : undefined,
            'dmpl__ToPercentage__c' : undefined,
            'dmpl__DiscountGroupId__c' : undefined,
            'dmpl__DiscountGroupId__r' : { 'Name' : undefined},
            // 'dmpl__IncentivePlanId__r' : { 'Name' : undefined},
            'dmpl__GiftPoints__c' : undefined,
            'dmpl__Gifts__c' : undefined,
            'dmpl__IncentiveAmountPerUnit__c' : undefined,
            'dmpl__IncentiveFixedAmount__c' : undefined,
            'dmpl__PercentageonProfit__c' : undefined,
            'dmpl__TargetPercentage__c' : undefined,
            'dmpl__AmountPercentage__c' : undefined,
            'dmpl__SequenceNumber__c' : this.incentiveLine.dmpl__CompensationSlabs__r?.length > 0 ? this.incentiveLine.dmpl__CompensationSlabs__r?.length + 1 : 1
        }
    }

    connectedCallback() {
        this.initIncentiveLine();
    }

    initIncentiveLine(){
        console.log('incentiveLine' ,this._incentiveLine);
        this._incentiveLine = JSON.parse(JSON.stringify(this._incentiveLine));
        this.filterCriteria = this.incentiveLine?.dmpl__DefinitionFilterCriteria__c;
        this.rewardApplicability = this.incentiveLine?.dmpl__RewardApplicability__c;
        this.isRewardCustomLogic = this.rewardApplicability == 'Custom Logic';
        this.isConditionCustomLogic = this.filterCriteria == 'Custom Logic Is Met';
        if(this.incentiveLine?.dmpl__Title__c){
            this.lineTitle = `${this.incentiveLine?.dmpl__Title__c} (${this.incentiveLine?.Name})`;
        }
        
        if(!this.incentiveLine?.dmpl__IncentiveTargets__r){
            this.incentiveLine.dmpl__IncentiveTargets__r = [];
        }
        if(!this.incentiveLine?.dmpl__CompensationSlabs__r){
            this.incentiveLine.dmpl__CompensationSlabs__r = [];
        }
        this.incentiveBenefits = this._incentiveLine.dmpl__CompensationSlabs__r;
        this.incentiveConditions = this._incentiveLine.dmpl__IncentiveTargets__r;
        this.useSlabAbsoluteValue = this._incentiveLine.dmpl__UseSlabAbsoluteValue__c;
        this.isEditing = this.isNew;
    }

    async handleSuccess(event) {
        var recordId = event.detail ? event.detail.id : undefined;
        var lineName = event.detail ? event.detail.Name : undefined;
        var messsage = lineName ? `Incentive Line \'${lineName}\' saved successfully.` : recordId ? `Incentive Line \'${recordId}\' saved successfully.` : 'Record created successfully.';
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