public with sharing class BranchTimeSlotDataHelper {
    
    public static dmpl__BranchTimeSlot__c createBranchTimeSlot(
        dmpl__Branch__c branch,
        dmpl__Item__c item
    ) {
        return (dmpl__BranchTimeSlot__c) TestFactory.createSObject(
            new dmpl__BranchTimeSlot__c(
                dmpl__BranchId__c = branch.Id,
                dmpl__TransactionType__c = 'Product Demo',
                Name = 'Test - Name',
                dmpl__IsActive__c = false,
                dmpl__ApplicableToItem__c = item.Id,
                dmpl__StartTime__c = Time.newInstance(10, 20, 5, 200),
                dmpl__ServiceType__c = 'Paid Repairs',
                dmpl__MaximumCapacity__c = 30,                                                    
                dmpl__MondayCapacity__c = 0,
                dmpl__TuesdayCapacity__c = 1,
                dmpl__WednesdayCapacity__c = 2,
                dmpl__ThursdayCapacity__c = 3,
                dmpl__FridayCapacity__c = 4,
                dmpl__SaturdayCapacity__c = 5,
                dmpl__SundayCapacity__c = 6
            ),
            'BranchTimeSlotDefaults',
            true
        );
    }

}