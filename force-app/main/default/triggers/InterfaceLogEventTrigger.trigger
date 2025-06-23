trigger InterfaceLogEventTrigger on dmpl__InterfaceLogEvent__e (after insert) {
    if(OrgSettingHelper.IsTriggerDisabled()){
        return;
    }
    InterfaceLogHelper.saveInterfaceLogs(Trigger.new);
    new MetadataTriggerHandler().run();
}