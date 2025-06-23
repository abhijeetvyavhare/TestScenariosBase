public with sharing class RepairOrderTimeSheetTestDataHelpers {
    
    public static dmpl__RepairOrderTimeSheet__c createTimeSheet(
        dmpl__RepairOrder__c repairOrder
    ) {
        return (dmpl__RepairOrderTimeSheet__c) TestFactory.createSObject(
            new dmpl__RepairOrderTimeSheet__c(
                dmpl__RepairOrderId__c = repairOrder.Id,
                dmpl__WorkEnded__c = false,
                dmpl__WorkPaused__c = false,
                dmpl__WorkStarted__c = false
            ),
            'RepairOrderTimeSheetDefaults',
            true
        );
    }

    public static dmpl__RepairOrderTimeSheet__c getTimeSheet() {
        return [
            SELECT Id,
                Name,
                dmpl__RepairOrderId__c,
                dmpl__WorkEnded__c,
                dmpl__WorkPaused__c,
                dmpl__WorkStarted__c
            FROM dmpl__RepairOrderTimeSheet__c
            LIMIT 1
        ];
    }

    public static List<dmpl__RepairOrderTimeSheet__c> getTimeSheetsByRepairOrder(Id repairOrderId) {
        return [
            SELECT Id,
                Name,
                dmpl__RepairOrderId__c,
                dmpl__WorkEnded__c,
                dmpl__WorkPaused__c,
                dmpl__WorkStarted__c
            FROM dmpl__RepairOrderTimeSheet__c
            WHERE dmpl__RepairOrderId__c = :repairOrderId
        ];
    }

    public static List<dmpl__RepairOrderTimeSheet__c> getRepairOrderTimeSheetsById(Id timeSheetId) {
        return [SELECT Id FROM dmpl__RepairOrderTimeSheet__c WHERE Id = :timeSheetId];
    }
}