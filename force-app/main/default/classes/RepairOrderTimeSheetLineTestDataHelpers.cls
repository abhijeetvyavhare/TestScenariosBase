public with sharing class RepairOrderTimeSheetLineTestDataHelpers {
    
    public static dmpl__RepairOrderTimeSheetLine__c createTimeSheetLine(
        dmpl__RepairOrderTimeSheet__c timeSheet
    ) {
        return (dmpl__RepairOrderTimeSheetLine__c) TestFactory.createSObject(
            new dmpl__RepairOrderTimeSheetLine__c(
                dmpl__RepairOrderTimeSheetId__c = timeSheet.Id,
                dmpl__ActualDurationHours__c = 1.00
            ),
            'RepairOrderTimeSheetLineDefaults',
            true
        );
    }

    public static dmpl__RepairOrderTimeSheetLine__c getTimeSheetLine() {
        return [
            SELECT Id,
                Name,
                dmpl__RepairOrderTimeSheetId__c,
                dmpl__ActualDurationHours__c
            FROM dmpl__RepairOrderTimeSheetLine__c
            LIMIT 1
        ];
    }

    public static List<dmpl__RepairOrderTimeSheetLine__c> getTimeSheetLinesByTimeSheet(Id timeSheetId) {
        return [
            SELECT Id,
                Name,
                dmpl__RepairOrderTimeSheetId__c,
                dmpl__ActualDurationHours__c
            FROM dmpl__RepairOrderTimeSheetLine__c
            WHERE dmpl__RepairOrderTimeSheetId__c = :timeSheetId
        ];
    }

    public static List<dmpl__RepairOrderTimeSheetLine__c> getTimeSheetLinesById(Id lineId) {
        return [SELECT Id FROM dmpl__RepairOrderTimeSheetLine__c WHERE Id = :lineId];
    }
}