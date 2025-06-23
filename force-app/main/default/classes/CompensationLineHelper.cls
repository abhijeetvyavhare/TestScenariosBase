public with sharing class CompensationLineHelper {

    private static Boolean skipValidations = false;

    public static void validateData(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__IncentiveCompensationLine__c> oldEntries, List<dmpl__IncentiveCompensationLine__c> newEntries)
    {
        try{
            if(isInsert){
                FieldMappingHelper.copyFieldMappingData(
                    newEntries);
            }
            if(skipValidations){
                return;
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void postData(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__IncentiveCompensationLine__c> oldEntries, List<dmpl__IncentiveCompensationLine__c> newEntries)
    {
        try{
        if(isInsert || isUpdate){
            IncentiveEngine.processIncentives(newEntries);
        } 
    } catch (Exception error) {
        ExceptionLogHelper.logException(error);
        throw error;
    }
    }
}