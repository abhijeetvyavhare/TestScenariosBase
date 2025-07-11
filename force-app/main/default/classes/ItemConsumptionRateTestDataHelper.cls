public class ItemConsumptionRateTestDataHelper {

    public static dmpl__ItemConsumptionRate__c createItemConsumptionRate(String name, dmpl__ItemConsumptionSchedule__c schedule) {
        return (dmpl__ItemConsumptionRate__c) TestFactory.createSObject(
            new dmpl__ItemConsumptionRate__c(
                Name = name,
                dmpl__ItemConsumptionSchedule__c = schedule.Id
            ),
            null,
            true
        );
    }

    public static dmpl__ItemConsumptionRate__c getItemConsumptionRate(String name) {
        return [
            SELECT Id, Name, dmpl__ItemConsumptionSchedule__c
            FROM dmpl__ItemConsumptionRate__c
            WHERE Name = :name
            LIMIT 1
        ];
    }
}