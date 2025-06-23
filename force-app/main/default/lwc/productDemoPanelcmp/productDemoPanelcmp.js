import { LightningElement, api, wire, track } from 'lwc';
import getSourceObject from '@salesforce/apex/ScreenActionController.getSourceObject';
import getActionSettings from '@salesforce/apex/ScreenActionController.getActionSettings';
import { CloseActionScreenEvent } from 'lightning/actions';

const SAS_NAME = 'Appointment Screen Action Setting';

export default class ProductDemoPanelcmp extends LightningElement {
    @api recordId;
    @api objectApiName;
    @api actionSettingName;
    @api sourceFieldName;

    @api title='New Appointment - Original';
    @api titleTimeSlot ='Date/Time Slots';
    @api availableLabel = 'Available';
    @api recordFieldsetNameTimeSlot = 'dmpl__DMSProductDemoTimeSlot';
    @api defaultFieldValuesTimeSlot;
    @api transactionType= 'Product Demo';
    @api siteTransactionType = 'Product Demo At Site';
    @api noDataMessageDateSlot = 'Select a partner/product to see the available slots.';
    @api noDataMessageTimeSlot = 'Select a Date Slot to see the available Time Slots.';
    @api daysCount = 5;
    @api branchId;

    @api titlePartnerPanel = 'Partner Locations';
    @api recordFieldsetNamePartnerPanel = 'dmpl__DMSBranchAddressFieldset';
    @api showFilterPanelPartnerPanel;
    @api noDataMessagePartnerPanel='No Partner Locations available!';
    @api defaultFieldValuesPartner;

    @api titleRecordPanel='Account Details';
    @api recordFieldsetNameRecordPanel='dmpl__DMSProductDemoNew';
    @api defaultFieldValuesRecordPanel;

    @wire(getSourceObject, { objectApiName: '$objectApiName', recordId: '$recordId' })
    wiredSourceObject(d){
        if(d.data){
            const partnerAccountId = d.data.dmpl__PartnerAccountId__c;
            const accountId = d.data.dmpl__AccountId__c;
            this.delayTimeout = setTimeout(() => {
                this.branchId = d.data.dmpl__BranchId__c;
                this.defaultFieldValuesPartner = `dmpl__BranchId__c|${this.branchId}`;
                this.defaultFieldValuesRecordPanel = `dmpl__PartnerAccountId__c|${partnerAccountId},dmpl__BranchId__c|${this.branchId},dmpl__AccountId__c|${accountId}`;
            }, 500);
        }
    };

    @wire(getActionSettings, { actionSettingName: SAS_NAME, objectApiName: '$objectApiName'})
    wiredgetActionSettings(d){
        if(d.data){
            this.delayTimeout = setTimeout(() => {
                d.data.forEach((v)=>{
                    this[v.dmpl__ParamName__c] = v.dmpl__ParamValue__c;
                });
                if(this.sourceFieldName){
                    this.defaultFieldValuesRecordPanel = `${this.sourceFieldName}|${this.recordId}`;
                }
            }, 1000);
        }
    };

    get getTimeSlotPanel(){
        return this.template.querySelector(
            'c-time-slot-panel'
        );
    }

    get getPartnerPanel(){
        return this.template.querySelector(
            'c-partner-search-panel'
        );
    }
    
    get getRecordPanel(){
        return this.template.querySelector(
            'c-record-panel'
        );
    }
    connectedCallback(){
        this.showFilterPanelPartnerPanel = true;
        this.showQuickAction = true;
    }

    handleDateSlotChanged(event){
        this.defaultFieldValuesRecordPanel = `dmpl__DemoDate__c|${event.detail.selectedDate}`;
    }

    handleTimeSlotChanged(event){
        this.defaultFieldValuesRecordPanel = `dmpl__DemoSlotId__c|${event.detail.recordId}`;
    }
    
    handleFilterChanged(event){
        this.defaultFieldValuesRecordPanel = `${event.detail.name}|${event.detail.value}`;
    }
    
    handleBranchSelected(event){
        this.branchId = event.detail.recordId;       
        this.defaultFieldValuesRecordPanel = `dmpl__PartnerAccountId__c|${event.detail.partnerAccountId},dmpl__BranchId__c|${event.detail.recordId}`;
    }

    handlePartnerFilterChanged(event){
        this.defaultFieldValuesRecordPanel = `${event.detail.name}|${event.detail.value}`;       
    }

    handleValueChanged(event){
        this.defaultFieldValuesTimeSlot=`${event.detail.name}|${!event.detail.value}`;
    }

    handleSave(){
        this.getRecordPanel.invokeSave();
    }

    handleCancel(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    handleRecordSaved(detail){
        this.dispatchEvent(new CustomEvent('recordsaved', { "detail": detail }));
        this.dispatchEvent(new CloseActionScreenEvent());
    }
   
}