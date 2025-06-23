public with sharing class LeaveRequestHandler  extends TriggerHandler {
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{};
    private static final List<String> LIST_FIELDS_LOCKIFTRANSACTED = new List<String>{};

    private List<dmpl__LeaveRequest__c> triggerNew;
    private List<dmpl__LeaveRequest__c> triggerOld;
    private Map<Id, dmpl__LeaveRequest__c> triggerMapNew;
    private Map<Id, dmpl__LeaveRequest__c> triggerMapOld;
    public LeaveRequestHandler() {
        this.triggerOld = (List<dmpl__LeaveRequest__c>) Trigger.old;
        this.triggerNew = (List<dmpl__LeaveRequest__c>) Trigger.new;
        this.triggerMapNew = (Map<Id, dmpl__LeaveRequest__c>) Trigger.newMap;
        this.triggerMapOld = (Map<Id, dmpl__LeaveRequest__c>) Trigger.oldMap;
    }

    public override void beforeInsert(){
        LeaveRequestService.validateLeaveRequest(triggerNew);
        LeaveRequestService.updateDates(triggerNew);
        
    }

    public override void beforeupdate(){
        LeaveRequestService.updateDates(triggerNew);
    }

    public override void afterUpdate(){
        List<dmpl__LeaveRequest__c> modifiedRecords = DocumentHelper.getObjectsByFilter(
            triggerNew,
            'dmpl__Status__c',
            'Approved');
        if(modifiedRecords.size() > 0){
            LeaveRequestService.processApprovedLeaves(
                modifiedRecords);
        }
        modifiedRecords = DocumentHelper.getModifiedNewObjects(
            'dmpl__Status__c',
            triggerOld,
            triggerNew);
        if(modifiedRecords.size() > 0){
            LeaveRequestService.processCancelledLeaves(
                modifiedRecords, 
                triggerOld);
        }
    }
}