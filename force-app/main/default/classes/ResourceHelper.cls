public with sharing  class ResourceHelper extends TriggerHandler {

    /************************************************************************************************
     * Private Scope Constants
     ************************************************************************************************/

    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{};
    private static final List<String> LIST_NON_EDITABLE_FIELDS = new List<String>{};
    
    private ResourceService resourceSrvs;
    private List<dmpl__Resource__c> triggerNew;
    private List<dmpl__Resource__c> triggerOld;
    private Map<Id, dmpl__Resource__c> triggerMapNew;
    private Map<Id, dmpl__Resource__c> triggerMapOld;

    /************************************************************************************************
     * Public Scope Functions
     ************************************************************************************************/

    public ResourceHelper() {
        this.resourceSrvs = new ResourceService();
        this.triggerOld = (List<dmpl__Resource__c>) Trigger.old;
        this.triggerNew = (List<dmpl__Resource__c>) Trigger.new;
        this.triggerMapNew = (Map<Id, dmpl__Resource__c>) Trigger.newMap;
        this.triggerMapOld = (Map<Id, dmpl__Resource__c>) Trigger.oldMap;
    }

    public override void beforeInsert(){
        if(!IsValidationSkipped()){
            DocumentHelper.validateChangeInSystemFields(
                LIST_FIELDS_SYSTEM, 
                triggerNew);
            resourceSrvs.validateDefaultPartnerAndBranch(triggerNew);
        }
    }

    public override void beforeUpdate(){
        if(!IsValidationSkipped()){
            DocumentHelper.validateChangeInKeyFields(
                LIST_NON_EDITABLE_FIELDS, 
                triggerOld, 
                triggerNew);
            DocumentHelper.validateChangeInSystemFields(
                LIST_FIELDS_SYSTEM, 
                triggerOld, 
                triggerNew);
            resourceSrvs.validateDefaultPartnerAndBranch(triggerNew);
        }
    }
}