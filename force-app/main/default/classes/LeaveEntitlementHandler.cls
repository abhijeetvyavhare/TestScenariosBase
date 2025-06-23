public with sharing class LeaveEntitlementHandler extends TriggerHandler {
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{};
    private static final List<String> LIST_FIELDS_LOCKIFTRANSACTED = new List<String>{};

    private List<dmpl__LeaveEntitlement__c> triggerNew;
    private List<dmpl__LeaveEntitlement__c> triggerOld;
    private Map<Id, dmpl__LeaveEntitlement__c> triggerMapNew;
    private Map<Id, dmpl__LeaveEntitlement__c> triggerMapOld;
    public LeaveEntitlementHandler() {
        this.triggerOld = (List<dmpl__LeaveEntitlement__c>) Trigger.old;
        this.triggerNew = (List<dmpl__LeaveEntitlement__c>) Trigger.new;
        this.triggerMapNew = (Map<Id, dmpl__LeaveEntitlement__c>) Trigger.newMap;
        this.triggerMapOld = (Map<Id, dmpl__LeaveEntitlement__c>) Trigger.oldMap;
    }

    public override void afterInsert(){
        ResourceLeaveService.createResoureLeavesFromEntitlement(
            triggerNew);
    }
}