public class SchemeLedgerHelper {
    
    public static void validateData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__SchemeLedger__c> oldEntries, 
        List<dmpl__SchemeLedger__c> newEntries){
            if(isInsert){
                FieldMappingHelper.copyFieldMappingData(
                    newEntries);
            }        
        }

        public static void postData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__SchemeLedger__c> oldEntries, 
        List<dmpl__SchemeLedger__c> newEntries)
    {
        try{
            if(isInsert){
                List<dmpl__SchemeLedger__c> filteredLedgers = DocumentHelper.getObjectsWithNull(newEntries, 'dmpl__SaleOrderId__c');
                if(filteredLedgers.size() > 0)
                {
                    SchemeAccountBudgetHelper.createAccountBudgetFromSchemeLedger(filteredLedgers);
                    SchemeHelper.updateSchemeUtilizedAmount(filteredLedgers);
                }
            }

            if(isUpdate){
                List<dmpl__SchemeLedger__c> modifiedObjects = DocumentHelper.getModifiedNewObjects(
                    new string[]{
                        'dmpl__Discount__c',
                        'dmpl__DiscountAmount__c',
                        'dmpl__LineAmount__c'
                    }, 
                    oldEntries, 
                    newEntries);

                List<dmpl__SchemeLedger__c> filteredLedgers = DocumentHelper.getObjectsWithNull(modifiedObjects, 'dmpl__SaleOrderId__c');
                if(filteredLedgers.size() > 0)
                    SchemeAccountBudgetHelper.createAccountBudgetFromSchemeLedger(filteredLedgers, oldEntries);
            }

            if(isDelete){
                List<dmpl__SchemeLedger__c> filteredLedgers = DocumentHelper.getObjectsWithNull(oldEntries, 'dmpl__SaleOrderId__c');
                if(filteredLedgers.size() > 0)
                {
                    SchemeAccountBudgetHelper.removeAccountBudgetFromSchemeLedger(filteredLedgers);
                    SchemeHelper.removeSchemeUtilizedAmount(filteredLedgers);
                }
            }
        }
        catch (Exception error) {
            ExceptionLogHelper.logException(error);
            // throw error;
        }
    }

    public static void afterPostData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__SchemeLedger__c> oldEntries, 
        List<dmpl__SchemeLedger__c> newEntries)
    {
        // try{
        //     if(isInsert){
        //         SchemeAccountBudgetHelper.createAccountBudgetFromSchemeLedger(newEntries);
        //         SchemeHelper.updateSchemeUtilizedAmount(newEntries);
        //     }

        //     if(isUpdate){
        //         List<dmpl__SchemeLedger__c> modifiedObjects = DocumentHelper.getModifiedNewObjects(
        //             new string[]{
        //                 'dmpl__Discount__c',
        //                 'dmpl__DiscountAmount__c',
        //                 'dmpl__LineAmount__c'
        //             }, 
        //             oldEntries, 
        //             newEntries);
        //         SchemeAccountBudgetHelper.createAccountBudgetFromSchemeLedger(modifiedObjects, oldEntries);
        //     }

        //     if(isDelete){
        //         SchemeAccountBudgetHelper.removeAccountBudgetFromSchemeLedger(oldEntries);
        //         SchemeHelper.removeSchemeUtilizedAmount(oldEntries);
        //     }
        // }
        // catch (Exception error) {
        //     ExceptionLogHelper.logException(error);
        //     // throw error;
        // }
    }
}