@isTest
public with sharing class Generic_Test {
    @isTest
    Static void VerifyDMPLNoAccess()
    {
        DMPLNoAccessException e = new DMPLNoAccessException(DMPLNoAccessException.AccessType.ReadAccess, 'ObjectName', 'FieldName');
        System.assert(e != null, 'ObjectCreationError');
    }

    @isTest
    static void VerifySourceObjectInfo()
    {
        SourceObjectInfo e = new SourceObjectInfo('ObjectName', null, 5,'FieldName');
        SourceObjectInfo.extractIds(new List<SourceObjectInfo>{new SourceObjectInfo('ObjectName', null, 5,'FieldName')});
        System.assert(e != null, 'ObjectCreationError');
    }


    @isTest
    Static void VerifyErrorLogger()
    {
        try {
            Integer i = 1/0;
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
        }

        try {
            throw new DMPLNoAccessException(DMPLNoAccessException.AccessType.ReadAccess, 'ObjectName', 'FieldName');
        } catch (DMPLNoAccessException error) {
            ExceptionLogHelper.logException(error);
        }
        
        List<dmpl__ErrorLogEvent__e>  logs= new List<dmpl__ErrorLogEvent__e>();
        logs.add(new dmpl__ErrorLogEvent__e(
            dmpl__FieldName__c ='log.dmpl__FieldName__c',
            dmpl__Message__c ='log.dmpl__Message__c',
            dmpl__ObjectName__c ='log.dmpl__ObjectName__c'
        ));

        ExceptionLogHelper.saveErrorLogs(logs);
        System.assertEquals(1, logs.size(), 'Logs have more than 1 record');
    }
}