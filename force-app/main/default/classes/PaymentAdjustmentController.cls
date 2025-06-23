public with sharing class PaymentAdjustmentController {
    
    @AuraEnabled(cacheable = false)
    public static Map<String, List<SObject>> getOpenDocuments(
        string paymentType,
        string partnerAccountId, 
        string branchId, 
        string accountId,
        string searchKey){
        try
        {
            if(String.isNotBlank(searchKey)){
                return PaymentAdjustmentHelper.getOpenDocuments(
                    paymentType,
                    partnerAccountId,
                    branchId,
                    accountId,
                    searchKey,
                    false
                );
            }else{
                return PaymentAdjustmentHelper.getOpenDocuments(
                paymentType,
                partnerAccountId,
                branchId,
                accountId,
                false
                );
            }
        }
        catch(Exception e)
        {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable = false)
    public static Map<String, List<SObject>> getOpenPayments(
        string paymentType,
        string partnerAccountId, 
        string branchId, 
        string accountId,
        string searchKey,
        Boolean onlyPayments){
        try
        {
            if(String.isNotBlank(searchKey)){
                return PaymentAdjustmentHelper.getOpenDocuments(
                    paymentType,
                    partnerAccountId,
                    branchId,
                    accountId,
                    searchKey,
                    onlyPayments
                );
            }else{
                return PaymentAdjustmentHelper.getOpenDocuments(
                    paymentType,
                    partnerAccountId,
                    branchId,
                    accountId,
                    onlyPayments
                );
            }
        }
        catch(Exception e)
        {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable = false)
    public static List<dmpl__PaymentAdjustment__c> postAdjustments(
        List<Object> documents){
            return PaymentAdjustmentHelper.postAdjustments(
                documents
            );
        }

    @AuraEnabled(cacheable = true)
    public static List<List<String>> extractColumns(){
        try{
            return PaymentAdjustmentHelper.extractColumns();
        }catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable = true)
    public static List<FieldsetFieldInfo> getFieldsetInfo(){
        try {
            return PaymentAdjustmentHelper.getFieldsetInfo();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}