public with sharing class InventoryConsoleController {
    @AuraEnabled(cacheable = false)
    public static List<dmpl__InventoryLedger__c> getLedgerData(
        Id itemId,
        Id branchId,
        Id partnerAccountId,
        Date fromDate,
        Date toDate){
            return [
                SELECT
                    Name,
                    dmpl__InventoryLedgerType__c,
                    dmpl__SourceDocument__c,
                    dmpl__BranchId__c,
                    dmpl__RelatedBranchId__c,
                    dmpl__ItemId__c,
                    dmpl__BranchId__r.Name,
                    dmpl__ItemId__r.Name,
                    dmpl__PartnerAccountId__c,
                    dmpl__RelatedPartnerAccountId__c,
                    dmpl__PartnerAccountId__r.Name,
                    dmpl__DocumentDate__c,
                    dmpl__ItemId__r.dmpl__Description__c,
                    dmpl__UnitCost__c,
                    dmpl__Quantity__c,
                    dmpl__AllocatedQuantity__c,
                    dmpl__InwardQuantity__c,
                    dmpl__DeliveredQuantity__c,
                    dmpl__PendingDeliveriesQuantity__c,
                    dmpl__PickedQuantity__c,
                    dmpl__DamagedQuantity__c
                FROM
                    dmpl__InventoryLedger__c
                WHERE
                    (dmpl__BranchId__c = :branchId OR dmpl__RelatedBranchId__c = :branchId)
                    AND dmpl__ItemId__c = :itemId
                    AND (dmpl__PartnerAccountId__c = :partnerAccountId OR dmpl__RelatedPartnerAccountId__c = :partnerAccountId)
                    AND dmpl__DocumentDate__c >= :fromDate
                    AND dmpl__DocumentDate__c <= :toDate
                    ORDER BY CreatedDate
            ];
        }

        @AuraEnabled(cacheable = false)
        public static List<AggregateResult> getOpeningStock(
            Id itemId,
            Id branchId,
            Id partnerAccountId,
            Date asOnDate)
        {
            return [SELECT
                SUM(dmpl__Quantity__c) TotalQty,
                SUM(dmpl__AllocatedQuantity__c) TotalAllocatedQty,
                SUM(dmpl__DeliveredQuantity__c) TotalDeliveredQuantity,
                SUM(dmpl__InwardQuantity__c) TotalInwardQty,
                SUM(dmpl__PendingDeliveriesQuantity__c) TotalPendingDOQty,
                SUM(dmpl__PickedQuantity__c) TotalPickedQty,
                SUM(dmpl__DamagedQuantity__c) TotalDamagedQty,
                dmpl__InventoryLedgerType__c LedgerType
            FROM
                dmpl__InventoryLedger__c
            WHERE
                dmpl__BranchId__c = :branchId
                AND dmpl__ItemId__c = :itemId
                AND dmpl__PartnerAccountId__c = :partnerAccountId
                AND dmpl__DocumentDate__c < :asOnDate
            Group By
                dmpl__InventoryLedgerType__c];
        }
    
        @AuraEnabled(cacheable = false)
        public static List<AggregateResult> getStock(
            Id branchId,
            Id partnerAccountId,
            Date asOnDate)
        {
            return [SELECT
                SUM(dmpl__Quantity__c) TotalQty,
                SUM(dmpl__AllocatedQuantity__c) TotalAllocatedQty,
                SUM(dmpl__DeliveredQuantity__c) TotalDeliveredQuantity,
                SUM(dmpl__InwardQuantity__c) TotalInwardQty,
                SUM(dmpl__PendingDeliveriesQuantity__c) TotalPendingDOQty,
                SUM(dmpl__PickedQuantity__c) TotalPickedQty,
                SUM(dmpl__DamagedQuantity__c) TotalDamagedQty,
                dmpl__InventoryLedgerType__c LedgerType,
                dmpl__ItemId__r.Name ItemName,
                dmpl__ItemId__c ItemId
            FROM
                dmpl__InventoryLedger__c
            WHERE
                dmpl__BranchId__c = :branchId
                AND dmpl__PartnerAccountId__c = :partnerAccountId
                AND dmpl__DocumentDate__c <= :asOnDate
            Group By
                dmpl__InventoryLedgerType__c,
                dmpl__ItemId__r.Name,
                dmpl__ItemId__c];
        }
}