@isTest
public class ItemConsumptionRateHandler_Test {

    @isTest
    static void createItemConsumptionRateWithNamePositive() {
        dmpl__ItemConsumptionSchedule__c schedule = (dmpl__ItemConsumptionSchedule__c) TestFactory.createSObject(
            new dmpl__ItemConsumptionSchedule__c(Name = 'Schedule-1'),
            null,
            true
        );

        ItemConsumptionRateTestDataHelper.createItemConsumptionRate('Rate-1', schedule);

        dmpl__ItemConsumptionRate__c rate = ItemConsumptionRateTestDataHelper.getItemConsumptionRate('Rate-1');

        System.assertNotEquals(null, rate, 'Rate should be created.');
        System.assertEquals('Rate-1', rate.Name, 'Rate name should match.');
        System.assertEquals(schedule.Id, rate.dmpl__ItemConsumptionSchedule__c, 'Schedule ID should match.');
    }
}