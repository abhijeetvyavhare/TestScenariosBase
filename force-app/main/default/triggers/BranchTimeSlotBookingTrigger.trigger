trigger BranchTimeSlotBookingTrigger on dmpl__BranchTimeSlotBooking__c (
    before insert, 
    before update, 
    before delete) {
        if(OrgSettingHelper.IsTriggerDisabled()){
            return;
        }
        BranchTimeSlotBookingHelper.validateData(
            trigger.isInsert, 
            trigger.isUpdate, 
            trigger.isDelete, 
            trigger.new, 
            trigger.old);
        new MetadataTriggerHandler().run();
}