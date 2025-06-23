@isTest
public with sharing class ErrorLogTestDataHelper {
    public static dmpl__ErrorLog__c createErrorLog() {
        return (dmpl__ErrorLog__c) TestFactory.createSObject(
            new dmpl__ErrorLog__c(
                dmpl__Type__c ='Info',
                dmpl__Message__c = 'Error Message'
            ),
            'ErrorLogDefaults',
            true
        );
    }

    public static dmpl__ErrorLog__c getErrorLog() {
        return [
            SELECT 
             dmpl__Message__c,
             dmpl__Type__c
            FROM dmpl__ErrorLog__c LIMIT 1
        ];
        
    }
}