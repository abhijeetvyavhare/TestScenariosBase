import { LightningElement,api,track, wire } from 'lwc';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { deleteRecord } from 'lightning/uiRecordApi';
import { reduceErrors } from 'c/utils';
import { publish, MessageContext } from 'lightning/messageService';
import { RefreshEvent } from 'lightning/refresh';
import { NavigationMixin } from 'lightning/navigation';
import FORCEREFRESHMC from '@salesforce/messageChannel/ForceReset__c';
import LightningConfirm from 'lightning/confirm';
import SCHEMEREWARD_OBJECT from '@salesforce/schema/SchemeBenefit__c';
import REWARDTYPE_FIELD from '@salesforce/schema/SchemeBenefit__c.RewardType__c';

export default class SchemeBuilderRewardRowcmp extends NavigationMixin(LightningElement) {
    @api resultObjectApiName = 'dmpl__SchemeBenefit__c';
    @api result = {};
    
    @api isEditing = false;
    @api rewardType ;
    @api rewardApplicability;
    @api disableActions = false;
    @api isFirstItem = false;
    @track isDiscountAmountVisible = false;
    @track isDiscountPercentVisible = false;
    @track isDiscountItemVisible = false;
    @track isDiscountItemGroupVisible = false;
    @track isItemDiscountItemQuantityVisible = false;
    @track isItemDiscountItemSKUVisible = false;
    @track isRewardPointsVisible = false;
    @track rewardTypeList;
    
    @api defultRecordTypeId;
    
    @wire(getObjectInfo, { objectApiName: SCHEMEREWARD_OBJECT })
    schemeRewardObjectInfo;

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
            this.rewardType = this.result.dmpl__RewardType__c;
            this.schemeId = this.result.dmpl__SchemeId__c;
            this.schemeLineId = this.result.dmpl__SchemeLineId__c;
            this.newSequenceNumber = this.result.dmpl__SequenceNumber__c ? this.result.dmpl__SequenceNumber__c : 1;
            this.isEditing = this.result.Id == undefined;
        }
        if(this.schemeRewardObjectInfo.data)
            this.defultRecordTypeId =  this.schemeRewardObjectInfo.data.defaultRecordTypeId;
        this.setComponentVisibility();    
    }

    setComponentVisibility(){
        this.isDiscountAmountVisible =  this.rewardType == 'Line Level Discount Amount';
        this.isDiscountPercentVisible= this.rewardType == 'Line Level Discount Percent'
            || this.rewardType == 'Discounted Item'
            || this.rewardType == 'Discounted Item Group';
        this.isDiscountItemVisible= this.rewardType == 'Discounted Item' 
            && (this.result.dmpl__DiscountedItemId__r != null|| this.isEditing);
        this.isDiscountItemGroupVisible= this.rewardType == 'Discounted Item Group' 
            && (this.result.dmpl__DiscountedItemGroupId__r != null|| this.isEditing);
        this.isItemDiscountItemQuantityVisible= this.rewardType == 'Discounted Item Group' || this.rewardType == 'Discounted Item';
        this.isItemDiscountItemSKUVisible= this.isDiscountItemVisible && (this.result.dmpl__DiscountedSKUId__r != null|| this.isEditing);
        this.isRewardPointsVisible = this.rewardType == 'Reward Points';

        if(this.isDiscountPercentVisible && !this.defaultDiscount){
            this.defaultDiscount = 1;
        }
    }

    handleRewardChange(event){
        this.rewardType = event.detail.value;
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        if (inputFields) {
            inputFields.forEach(field => {
                if(field.fieldName == 'dmpl__RewardType__c'){
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
                if(field.fieldName == 'dmpl__RewardType__c'){
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
        var messsage = lineName ? `Scheme Reward \'${lineName}\' saved successfully.` : recordId ? `Scheme Reward \'${recordId}\' saved successfully.` : 'Record created successfully.';
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