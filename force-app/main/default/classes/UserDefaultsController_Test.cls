@isTest
private class UserDefaultsController_Test {

    @isTest
    static void testGetUserOrgDefaultFiscalPeriod() {
        Test.startTest();
        Period result = UserDefaultsController.getUserOrgDefaultFiscalPeriod();
        Test.stopTest();
        System.assertNotEquals(null, result, 'Expected non-null result');
    }

    @isTest
    static void testGetUserOrgDefaultFiscalPeriodForDate() {
        Date testDate = Date.today();
        Test.startTest();
        Period result = UserDefaultsController.getUserOrgDefaultFiscalPeriodForDate(testDate);
        Test.stopTest();
        System.assertNotEquals(null, result, 'Expected non-null result');
    }
}