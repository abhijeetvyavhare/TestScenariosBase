@isTest
private class ItemConsumptionHandler_Test {

    @isTest
        static void createItemConsumptionRateWithNamePositive() {
            Test.startTest();
            dmpl__ItemConsumptionSchedule__c schedule = ItemConsumptionTestDataHelper.getItemConsumptionSchedule('Schedule-1');
            dmpl__ItemConsumptionRate__c rate = ItemConsumptionTestDataHelper.getItemConsumptionRate('Rate-1', schedule);
            System.assertEquals('Rate-1', rate.Name, 'Rate name should be Rate-1');
            System.assertEquals(schedule.Id, rate.dmpl__ItemConsumptionSchedule__c, 'Schedule link should be correct');
            Test.stopTest();
        }

    @isTest
        static void createItemConsumptionRateWithConsumptionSchedulePositive() {
            Test.startTest();
            dmpl__ItemConsumptionSchedule__c schedule = ItemConsumptionTestDataHelper.getItemConsumptionSchedule('Schedule-1');
            dmpl__ItemConsumptionRate__c rate = ItemConsumptionTestDataHelper.getItemConsumptionRate('Rate-2', schedule);

            System.assertNotEquals(null, rate, 'Item Consumption Rate should be created');
            System.assertEquals('Rate-2', rate.Name, 'Rate Name should match');
            System.assertEquals(schedule.Id, rate.dmpl__ItemConsumptionSchedule__c, 'Schedule should be linked correctly');
            Test.stopTest();
        }

    @isTest
        static void createItemConsumptionRateWithPricingMethodPositive() {
            Test.startTest();

            dmpl__ItemConsumptionSchedule__c schedule = ItemConsumptionTestDataHelper.getItemConsumptionSchedule('Schedule-1');
            
            dmpl__ItemConsumptionRate__c rate = new dmpl__ItemConsumptionRate__c();
            rate.Name = 'Rate-3';
            rate.dmpl__ItemConsumptionSchedule__c = schedule.Id;
            rate.dmpl__PricingMethod__c = 'Per Unit';

            System.assertNotEquals(null, rate, 'Item Consumption Rate should be created');
            System.assertEquals('Rate-3', rate.Name, 'Rate Name should match');
            System.assertEquals(schedule.Id, rate.dmpl__ItemConsumptionSchedule__c, 'Schedule should be linked correctly');
            System.assertEquals('Per Unit', rate.dmpl__PricingMethod__c, 'Pricing Method should be set correctly');

            Test.stopTest();
        }
    @isTest
        static void createItemConsumptionRateWithoutPricingMethodPositive() {
            Test.startTest();

            dmpl__ItemConsumptionSchedule__c schedule = ItemConsumptionTestDataHelper.getItemConsumptionSchedule('Schedule-1');

            dmpl__ItemConsumptionRate__c rate = new dmpl__ItemConsumptionRate__c();
            rate.Name = 'Rate-4';
            rate.dmpl__ItemConsumptionSchedule__c = schedule.Id;

            System.assertNotEquals(null, rate, 'Item Consumption Rate should be created');
            System.assertEquals('Rate-4', rate.Name, 'Rate Name should match');
            System.assertEquals(schedule.Id, rate.dmpl__ItemConsumptionSchedule__c, 'Schedule should be linked correctly');
            System.assertEquals(null, rate.dmpl__PricingMethod__c, 'Pricing Method should be blank');

            Test.stopTest();
        }

}