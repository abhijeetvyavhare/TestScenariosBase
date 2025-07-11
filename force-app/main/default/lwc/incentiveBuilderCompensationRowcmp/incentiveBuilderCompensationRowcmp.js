import { LightningElement,api,track, wire } from 'lwc';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { deleteRecord } from 'lightning/uiRecordApi';
import { reduceErrors } from 'c/utils';
import { RefreshEvent } from 'lightning/refresh';
import { publish, MessageContext } from 'lightning/messageService';
import { NavigationMixin } from 'lightning/navigation';
import FORCEREFRESHMC from '@salesforce/messageChannel/ForceReset__c';
import LightningConfirm from 'lightning/confirm';
import INCENTIVEREWARD_OBJECT from '@salesforce/schema/IncentiveCompensationSlab__c';
import REWARDTYPE_FIELD from '@salesforce/schema/IncentiveCompensationSlab__c.CompensationType__c';

export default class IncentiveBuilderRewardRowcmp extends NavigationMixin(LightningElement) {
    @api resultObjectApiName = 'dmpl__IncentiveCompensationSlab__c';
    @api result = {};
    
    @api isEditing = false;
    @api rewardType ;
    @api rewardApplicability;
    @api disableActions = false;
    @api isFirstItem = false;
    @api useSlabAbsoluteValue = false;
    @track isFixedAmountVisible = false;
    @track isPercentageOnValueVisible = false;
    @track isAmountPerUnitVisible = false;
    @track isReferenceTargetVisible = false;
    @track isPercentageOnProfitVisible = false;
    @track isGiftVisible = false;
    @track isGiftPointsVisible = false;
    @track isSchemeVisible = false;
    @track isDiscountGroupVisible = false;
    @track isIncentiveRewardsVisible = false;
    @track isIncentiveSlabVisible = false;
    @track rewardTypeList;
    

    @api defultRecordTypeId;
    
    @wire(getObjectInfo, { objectApiName: INCENTIVEREWARD_OBJECT })
    incentiveRewardObjectInfo;

    @wire(MessageContext)
    messageContext;

    @wire(getPicklistValues, { recordTypeId: '$defultRecordTypeId', fieldApiName: REWARDTYPE_FIELD })
    wiredValues({ error, data }) {
        if (data) {
            this.rewardTypeList = data.values;
        }
    }

    get getApplicabilityLabel() {
        if(this.rewardApplicability == 'All Rewards'
        || this.rewardApplicability == 'Any One With Lowest Value'
        || this.rewardApplicability == 'Any One With Highest Value'){
            return this.isFirstItem?'':
            this.rewardApplicability == 'All Rewards' ? 'AND' : 'OR'
        }else {
            return this.result?.dmpl__SequenceNumber__c;
        }
    }

    connectedCallback(){
        this.result = JSON.parse(JSON.stringify(this.result));
        if(this.result){
            this.recordId = this.result.Id;
            this.rewardType = this.result.dmpl__CompensationType__c;
            this.incentiveId = this.result.dmpl__IncentivePlanId__c;
            this.incentiveLineId = this.result.dmpl__IncentiveLineId__c;
            this.newSequenceNumber = this.result.dmpl__SequenceNumber__c ? this.result.dmpl__SequenceNumber__c : 1;
            this.isEditing = this.result.Id == undefined;
        }
        if(this.incentiveRewardObjectInfo.data)
            this.defultRecordTypeId =  this.incentiveRewardObjectInfo.data.defaultRecordTypeId;
        this.setComponentVisibility();    
    }

    setComponentVisibility(){
        this.isFixedAmountVisible =  this.rewardType == 'Fixed Amount';
        this.isPercentageOnValueVisible = this.rewardType == 'Percentage On Value' 
            || this.rewardType == 'KPI Reward Value Percentage'
            || this.rewardType == 'Resource Reward Value Percentage'
            || this.rewardType == 'Slab Reward Percentage';
            
        this.isIncentiveSlabVisible = this.rewardType == 'Slab Reward Percentage';
        this.isAmountPerUnitVisible = this.rewardType == 'Amount Per Unit' || this.rewardType == 'Amount Per Unit Incremental';
        this.isReferenceTargetVisible = this.rewardType == 'Amount Per Unit Incremental';
        this.isPercentageOnProfitVisible = this.rewardType == 'Percentage On Profit';
        this.isGiftVisible = this.rewardType == 'Gifts';
        this.isGiftPointsVisible = this.rewardType == 'Gifts' || this.rewardType == 'Reward Points';
        this.isDiscountGroupVisible = this.rewardType == 'Discount Group';
        this.isSchemeVisible = this.rewardType == 'Scheme Rewards';
        this.isIncentiveRewardsVisible = this.rewardType == 'Incentive Rewards';
        this.isKPIConfigVisible = true;
        // if(this.isDiscountPercentVisible && !this.defaultDiscount){
        //     this.defaultDiscount = 1;
        // }
    }

    handleRewardChange(event){
        this.rewardType = event.detail.value;
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        if (inputFields) {
            inputFields.forEach(field => {
                if(field.fieldName == 'dmpl__CompensationType__c'){
                    field.value = this.rewardType;
                }
            });
        }

        this.setComponentVisibility();
    }

    handleEditCondition(event){
        this.isEditing = true;
        this.setComponentVisibility();
    }

    handleEditFormCondition(event){
        let editPageRef = {
            type: 'standard__objectPage',
            attributes: {
                objectApiName: this.resultObjectApiName,
                recordId : this.recordId,
                actionName: 'edit'
            }
        };
        this[NavigationMixin.Navigate](editPageRef);
    }

    handleSaveCondition(event){
        this.template.querySelector('lightning-record-edit-form').submit();
    }

    async handleDeleteCondition(event){
        const pResult = await LightningConfirm.open({
            message: `Are you sure you want to delete reward \'${this.result.Name}\'.`,
            label: 'Confirm Delete!',
            variant: 'header',
            theme : 'warning'
        });
        //
        if(!pResult){
            return;
        }
        //
        deleteRecord(this.result.Id)
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

    handleCancelCondition(event){
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        if (inputFields) {
            inputFields.forEach(field => {
                field.reset();
                if(field.fieldName == 'dmpl__CompensationType__c'){
                    this.conditionType  = field.value;
                }
            });
        }
        this.setComponentVisibility();
        this.isEditing = false;
        this.setComponentVisibility();
        this.beginRefresh();
    }

    async handleSuccess(event) {
        var recordId = event.detail ? event.detail.id : undefined;
        var lineName = event.detail ? event.detail.Name : undefined;
        var messsage = lineName ? `Incentive Reward \'${lineName}\' saved successfully.` : recordId ? `Incentive Reward \'${recordId}\' saved successfully.` : 'Record created successfully.';
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: messsage,
                variant: 'success',
            }),
        );
        this.recordId = recordId;
        this.beginRefresh();
        this.isEditing = false;
        this.setComponentVisibility();
    }

    handleError(event) {
        var error = event.detail;
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error',
                message: reduceErrors(JSON.parse(JSON.stringify(error))),
                variant: 'error'
            }),
        );
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