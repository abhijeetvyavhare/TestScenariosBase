trigger AssetTrigger on Asset (
    before insert, 
    before update, 
    before delete) {
        if(OrgSettingHelper.IsTriggerDisabled()){
            return;
        }
        AssetHelper.validateData(
            trigger.isInsert, 
            trigger.isDelete, 
            trigger.isUpdate, 
            trigger.old, 
            trigger.new);
        new MetadataTriggerHandler().run();                 
}