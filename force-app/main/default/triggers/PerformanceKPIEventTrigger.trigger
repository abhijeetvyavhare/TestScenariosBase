trigger PerformanceKPIEventTrigger on dmpl__PerformanceKPIEvent__e (after insert) 
{
    if(OrgSettingHelper.IsTriggerDisabled()){
        return;
    }
    if(Trigger.isAfter)
    {
        PerformanceKPIHelper.processPerformanceKPI(Trigger.new);
    }
    new MetadataTriggerHandler().run();
}