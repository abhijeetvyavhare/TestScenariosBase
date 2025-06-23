public with sharing class CreditLimitHelper {
    private static Boolean skipValidations = false;

    public static void validateData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__CreditLimit__c> oldEntries, 
        List<dmpl__CreditLimit__c> newEntries)
    { 
        try{     
            if(isInsert){
                FieldMappingHelper.copyFieldMappingData(
                    newEntries);
            }
            if(skipValidations){
                return;
            }
            if(isInsert){
                validateUniqueKeyCombination(newEntries);
            }else if(isUpdate){
                validateUniqueKeyCombination(newEntries);
            }else if(isDelete){
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    private static void validateUniqueKeyCombination(List<dmpl__CreditLimit__c> newEntries){
        List<Id> partnerAccountIds = DocumentHelper.extractIds(newEntries, 'dmpl__PartnerAccountId__c');
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__PartnerAccountId__c'
        }, 'dmpl__CreditLimit__c');
        Map<Id, dmpl__CreditLimit__c> existingCreditLimits = new Map<Id,dmpl__CreditLimit__c>([
            SELECT 
                ID, 
                dmpl__PartnerAccountId__c
            FROM dmpl__CreditLimit__c
            WHERE
                dmpl__PartnerAccountId__c IN :partnerAccountIds
        ]);

        for(dmpl__CreditLimit__c entry : newEntries){
            dmpl__CreditLimit__c existingEntry = existingCreditLimits.get(entry.dmpl__PartnerAccountId__c);
            if(existingEntry!=null && existingEntry.Id != entry.Id){
                entry.addError('Duplicate Key Combination');
            }
        }
    }

  //  private static void validateUniqueKeyCombination1(List<dmpl__CreditLimit__c> newEntries){
        // List<Id> partnerAccountIds = DocumentHelper.extractIds(newEntries, 'dmpl__PartnerAccountId__c');
        // List<Id> branchIds = DocumentHelper.extractIds(newEntries, 'dmpl__BranchId__c');
        // List<dmpl__CreditLimit__c> existingCreditLimits = [
        //     SELECT 
        //         ID, 
        //         dmpl__PartnerAccountId__c,
        //         dmpl__BranchId__c
        //     FROM dmpl__CreditLimit__c
        //     WHERE
        //         dmpl__PartnerAccountId IN :partnerAccountIds
        //         OR dmpl__BranchId IN :branchIds
        // ];

        // for(dmpl__CreditLimit__c entry : newEntries){
        //     for(dmpl__CreditLimit__c existingEntry : existingCreditLimits){
        //         if(entry.dmpl__PartnerAccountId__c == existingEntry.dmpl__PartnerAccountId__c 
        //             && entry.dmpl__BranchId__c == existingEntry.dmpl__BranchId__c
        //             && existingEntry.Id != entry.Id){
        //             entry.addError('Duplicate Key Combination');
        //         }    
        //     }
        // }
    //}
}