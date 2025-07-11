import { LightningElement, api, track, wire } from 'lwc';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { NavigationMixin } from 'lightning/navigation';
import { publish, MessageContext } from 'lightning/messageService';
import { RefreshEvent } from 'lightning/refresh';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { deleteRecord } from 'lightning/uiRecordApi';
import { reduceErrors } from 'c/utils';
import LightningConfirm from 'lightning/confirm';
import INCENTIVETARGET_OBJECT from '@salesforce/schema/IncentiveTarget__c';
import CONDITIONTYPE_FIELD from '@salesforce/schema/IncentiveTarget__c.IncentiveTargetType__c';
import FORCEREFRESHMC from '@salesforce/messageChannel/ForceReset__c';

export default class IncentiveBuilderConditionRowcmp extends NavigationMixin(LightningElement) {
    @api conditionObjectApiName = 'dmpl__IncentiveTarget__c';
    @api condition;

    @api isEditing = false;
    @api conditionType;
    @api filterCriteria;
    @api disableActions = false;
    @api isFirstItem = false;
    @track isQuantityVisible = false;
    @track isValueVisible = false;
    @track isAccountGroupVisible = false;
    @track isAccountVisible = false;
    @track isItemGroupVisible = false;
    @track isItemVisible = false;
    @track isValuePercentageVisible = false;
    @track targetValueType = ''
    @track conditionTypeList;
    
    @api defultRecordTypeId;
    
    @wire(MessageContext)
    messageContext;
    
    @wire(getObjectInfo, { objectApiName: INCENTIVETARGET_OBJECT })
    incentiveConditionObjectInfo;
    
    @wire(getPicklistValues, { recordTypeId: '$defultRecordTypeId', fieldApiName: CONDITIONTYPE_FIELD })
    wiredValues({ error, data }) {
        if (data) {
            this.conditionTypeList = data.values;
        }
    }

    get getConditionLabel() {
        if(this.filterCriteria == 'All Conditions Are Met'
        || this.filterCriteria == 'Any Condition Is Met'){
            return this.isFirstItem?'':
            this.filterCriteria == 'All Conditions Are Met' ? 'AND' : 'OR'
        }else {
            return this.condition?.dmpl__SequenceNumber__c;
        }
    }

    connectedCallback(){
        this.condition = JSON.parse(JSON.stringify(this.condition));
        if(this.condition){
            this.conditionType = this.condition.dmpl__IncentiveTargetType__c;
            this.recordId = this.condition.Id;
            this.incentiveId = this.condition.dmpl__IncentivePlanId__c;
            this.incentiveLineId = this.condition.dmpl__IncentiveLineId__c;
            this.newSequenceNumber = this.condition.dmpl__SequenceNumber__c ? this.condition.dmpl__SequenceNumber__c : 1;
            this.targetValueType = this.condition.dmpl__TargetValueType__c ? this.condition.dmpl__TargetValueType__c : 'Fixed Value';
            this.isEditing = (this.condition.Id == undefined);
        }
        if(this.incentiveConditionObjectInfo.data){
           this.defultRecordTypeId = this.incentiveConditionObjectInfo.data.defaultRecordTypeId;
        }
        this.setComponentVisibility();    
    }

    setComponentVisibility(){
        // this.isQuantityVisible =  this.conditionType == 'Quantity' 
        //     || this.conditionType == 'Item Quantity'
        //     || this.conditionType == 'Item Group Quantity';

        this.isValueVisible = this.targetValueType != 'Resource Target' && this.targetValueType != 'Resource Target Percentage';
        this.isValuePercentageVisible = this.targetValueType == 'Resource Target Percentage';
        // this.isAccountGroupVisible=  this.conditionType == 'Account' && (this.condition.dmpl__AccountId__r!=null || this.isEditing);
        // this.isAccountVisible = this.conditionType == 'Account Group' && (this.condition.dmpl__AccountGroupId__r!=null|| this.isEditing);
        // this.isItemVisible = (this.condition.dmpl__ItemId__r !=null|| this.isEditing) && (this.conditionType == 'Item Value' || this.conditionType == 'Item Quantity' || this.conditionType == 'Item Value With Tax');
        // this.isItemSKUVisible = (this.condition.dmpl__SKUId__r !=null|| this.isEditing) && this.isItemVisible;
        // this.isItemGroupVisible = (this.condition.dmpl__ItemGroupId__r!=null|| this.isEditing) && (this.conditionType == 'Item Group Quantity' || this.conditionType == 'Item Group Value' || this.conditionType == 'Item Group Value With Tax');
    }

    handleConditionChange(event){
        this.conditionType = event.detail.value;
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        if (inputFields) {
            inputFields.forEach(field => {
                if(field.fieldName == 'dmpl__IncentiveTargetType__c'){
                    field.value = this.conditionType;
                }
            });
        }
        this.setComponentVisibility();
    }

    handleTargetValueTypeChange(event){
        this.targetValueType = event.detail.value;
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
                objectApiName: this.conditionObjectApiName,
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
        const result = await LightningConfirm.open({
            message: `Are you sure you want to delete condition \'${this.condition.Name}\'.`,
            label: 'Confirm Delete!',
            variant: 'header',
            theme : 'warning'
        });
        //
        if(!result){
            return;
        }
        //
        deleteRecord(this.condition.Id)
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
                if(field.fieldName == 'dmpl__IncentiveTargetType__c'){
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
        var messsage = lineName ? `Incentive Target Condition \'${lineName}\' saved successfully.` : recordId ? `Incentive Target Condition \'${recordId}\' saved successfully.` : 'Record created successfully.';
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