import { LightningElement, api } from 'lwc';

export default class ProductDemoPanel extends LightningElement {
    @api titleTimeSlot;
    @api availableLabel;
    @api objectApiName;
    @api recordFieldsetNameTimeSlot;
    @api defaultFieldValuesTimeSlot;
    @api transactionType;
    @api siteTransactionType;
    @api noDataMessageDateSlot;
    @api noDataMessageTimeSlot;
    @api daysCount;
    @api branchId;

    @api titlePartnerPanel;
    @api recordFieldsetNamePartnerPanel;
    @api showFilterPanelPartnerPanel;
    @api noDataMessagePartnerPanel;

    @api titleRecordPanel;
    @api objectApiNameRecordPanel;
    @api recordFieldsetNameRecordPanel;
    @api defaultFieldValuesRecordPanel;

    get getTimeSlotPanel(){
        return this.template.querySelectorAll(
            'c-time-slot-panel'
        );
    }

    get getPartnerPanel(){
        return this.template.querySelectorAll(
            'c-partner-search-panel'
        );
    }
    
    get getRecordPanel(){
        return this.template.querySelectorAll(
            'c-record-panel'
        );
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

}