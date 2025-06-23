@isTest
public with sharing class ErrorLogHandler_Test {
    @TestSetup
    static void createRequiredData() {
        dmpl__ErrorLog__c errorLog = ErrorLogTestDataHelper.createErrorLog();
    }

    @isTest
    static void createErrorLogPositive() {
        dmpl__ErrorLog__c errorLog = ErrorLogTestDataHelper.getErrorLog();
        System.assertNotEquals(errorLog, null, 'Expected ErrorLog to be created.');
        System.assertEquals('Info', errorLog.dmpl__Type__c, 'Type should be Info');
        System.assertEquals('Error Message', errorLog.dmpl__Message__c, 'Message should be Error Message');
    }

    @isTest
    static void updateErrorLogPositive() {
        dmpl__ErrorLog__c errorLog = ErrorLogTestDataHelper.getErrorLog();
        System.assertNotEquals(errorLog, null, 'ErrorLog should exist before update.');
        errorLog.dmpl__Message__c = 'Updated Error Message';
        update errorLog;
        dmpl__ErrorLog__c updatedErrorLog = ErrorLogTestDataHelper.getErrorLog();
        System.assertEquals('Updated Error Message', updatedErrorLog.dmpl__Message__c, 'Expected updated message');
    }

    @isTest
    static void deleteErrorLogPositive() {
        dmpl__ErrorLog__c errorLog = ErrorLogTestDataHelper.getErrorLog();
        System.assertNotEquals(errorLog, null, 'ErrorLog should exist before delete.');
        delete errorLog;
        dmpl__ErrorLog__c deletedErrorLog = null;
        try {
            deletedErrorLog = ErrorLogTestDataHelper.getErrorLog();
        } catch (Exception e) {
            deletedErrorLog = null;
        }

        System.assertEquals(null, deletedErrorLog, 'ErrorLog should be deleted and not found in query.');
    }


}