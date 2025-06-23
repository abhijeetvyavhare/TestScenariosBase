/**
 * @description An opinionated KPI Confifuration handler framework.
 */
public with sharing class KPIConfigurationHandler extends TriggerHandler {

    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{};
    private static final List<String> LIST_NON_EDITABLE_FIELDS = new List<String>{};
    
    private KPIConfigurationService kcs;
    private List<dmpl__KPIConfiguration__c> triggerNew;
    private List<dmpl__KPIConfiguration__c> triggerOld;
    private Map<Id, dmpl__KPIConfiguration__c> triggerMapNew;
    private Map<Id, dmpl__KPIConfiguration__c> triggerMapOld;

    public KPIConfigurationHandler() {
        this.kcs = new KPIConfigurationService();
        this.triggerOld = (List<dmpl__KPIConfiguration__c>) Trigger.old;
        this.triggerNew = (List<dmpl__KPIConfiguration__c>) Trigger.new;
        this.triggerMapNew = (Map<Id, dmpl__KPIConfiguration__c>) Trigger.newMap;
        this.triggerMapOld = (Map<Id, dmpl__KPIConfiguration__c>) Trigger.oldMap;
    }

    public override void beforeInsert(){
        if(!IsValidationSkipped()){
            DocumentHelper.validateChangeInSystemFields(
                LIST_FIELDS_SYSTEM, triggerNew);
        }
    }

    public override void afterInsert(){

    }
}