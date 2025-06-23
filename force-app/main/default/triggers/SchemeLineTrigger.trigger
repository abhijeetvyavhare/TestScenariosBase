trigger SchemeLineTrigger on dmpl__SchemeLine__c (before update) {
    if(OrgSettingHelper.IsTriggerDisabled()){
        return;
    }
    SchemeHelper.schemeConditionPicklistFilter(Trigger.new, Trigger.oldMap);
    new MetadataTriggerHandler().run();
}