public with sharing class BranchController {
    private static final Integer MAX_DAYS_COUNT = 30;

    @AuraEnabled(cacheable = true)
    public static List<dmpl__Branch__c> getNearbyBranches(
        string postalCode, 
        string cityName, 
        Integer radius){
        try {
            return BranchHelper.getNearbyBranches(
                postalCode, 
                cityName, 
                radius);
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    @AuraEnabled(cacheable = true)
    public static List<BranchDateSlotResult> getBranchDateSlots(
        String transactionType, 
        Id branchId, 
        String itemId, 
        String serviceType, 
        String serviceJobType, 
        Integer daysCount){
        Integer safeDaysCount = daysCount > MAX_DAYS_COUNT ? MAX_DAYS_COUNT : daysCount;
        Id safeItemId = null;
        try {
            if(String.isNotBlank(itemId)){
                safeItemId = Id.valueOf(itemId);
            }
            return BranchHelper.getBranchDateSlots(
                transactionType, 
                branchId, 
                safeItemId, 
                serviceType, 
                serviceJobType, 
                safeDaysCount);
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    @AuraEnabled(cacheable = true)
    public static List<dmpl__BranchTimeSlot__c> getBranchTimeSlots(
        String transactionType, 
        Id branchId, 
        String itemId, 
        String serviceType, 
        String serviceJobType, 
        Date bookingDate){
        try {
            Id safeItemId = null;
            if(String.isNotBlank(itemId)){
                safeItemId = Id.valueOf(itemId);
            }
            return BranchHelper.getBranchTimeSlots(
                transactionType, 
                branchId, 
                safeItemId, 
                serviceType, 
                serviceJobType, 
                bookingDate);
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }
    
    @AuraEnabled(cacheable = true)
    public static List<dmpl__InventoryStock__c> getStock(
        List<Id> itemIds,
        List<Id> branchIds){
            return [
                SELECT 
                    dmpl__BranchId__c,
                    dmpl__ItemId__c,
                    dmpl__BranchId__r.Name,
                    dmpl__ItemId__r.Name,
                    dmpl__QuantityAvailable__c,
                    dmpl__QuantityInHand__c
                FROM
                    dmpl__InventoryStock__c
                WHERE
                    dmpl__BranchId__c IN :branchIds
                    AND dmpl__ItemId__c IN :itemIds
            ];
        }

    @AuraEnabled(cacheable = true)
    public static List<dmpl__Branch__c> getBranches(
        Id partnerAccountId){
        try {
            return [
                SELECT 
                    Id,
                    Name,
                    dmpl__PartnerAccountId__c,
                    dmpl__PartnerAccountId__r.Name
                FROM    
                    dmpl__Branch__c
                WHERE 
                    dmpl__PartnerAccountId__c = :partnerAccountId
            ];
        } catch (Exception error) {
            //ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    @AuraEnabled(cacheable = true)
    public static List<dmpl__Branch__c> getRelatedBranches(
        Id partnerAccountId){
        try {
            return [
                SELECT 
                    Id,
                    Name,
                    dmpl__PartnerAccountId__c,
                    dmpl__PartnerAccountId__r.Name
                FROM    
                    dmpl__Branch__c
                WHERE 
                    dmpl__PartnerAccountId__c IN (
                        SELECT 
                            dmpl__AccountGroupId__c 
                        FROM 
                            dmpl__PartnerAccountMapping__c 
                        WHERE
                            dmpl__AccountId__c =:partnerAccountId
                    )
            ];
        } catch (Exception error) {
            //ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    @AuraEnabled(cacheable = true)
    public static List<dmpl__Branch__c> getAllBranches(){
        try {
            return [
                SELECT 
                    Id,
                    Name,
                    dmpl__PartnerAccountId__c,
                    dmpl__PartnerAccountId__r.Name
                FROM    
                    dmpl__Branch__c
            ];
        } catch (Exception error) {
            //ExceptionLogHelper.logException(error);
            throw error;
        }
    }
}