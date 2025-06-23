@isTest
public with sharing class AutoPurchaseDataHelper {

    public static dmpl__AutoPurchaseOrder__c createAutoPurchaseOrder(
        Account partnerAccount,
        Account supplierAccount,
        dmpl__Branch__c branch
    ) {
        return (dmpl__AutoPurchaseOrder__c) TestFactory.createSObject(
            new dmpl__AutoPurchaseOrder__c(
                dmpl__PartnerAccountId__c = partnerAccount.Id,
                dmpl__SupplierAccountId__c = supplierAccount.Id,
                dmpl__BranchId__c = branch.Id,
                dmpl__AutoOrderType__c = 'Minimum Stock Level',
                dmpl__BudgetAmount__c = 5000,
                dmpl__IsTemplateCreated__c = false,
                dmpl__Status__c = 'Draft',
                dmpl__Remarks__c = 'Auto created from helper',
                dmpl__PerformOrderGeneration__c = true,
                dmpl__IsOrderGenerated__c = false,
                dmpl__DocumentDate__c = System.today()
            ),
            'AutoPurchaseOrderDefaults',
            true
        );
    }

    public static dmpl__AutoPurchaseOrder__c updateAutoPurchaseOrder(
        dmpl__AutoPurchaseOrder__c existingOrder,
        String newRemark
    ) {
        return (dmpl__AutoPurchaseOrder__c) TestFactory.createSObject(
            new dmpl__AutoPurchaseOrder__c(
                Id = existingOrder.Id,
                dmpl__Remarks__c = newRemark,
                dmpl__PerformOrderGeneration__c = false,
                dmpl__IsOrderGenerated__c = true
            ),
            'AutoPurchaseOrderDefaults',
            false
        );
    }

    public static dmpl__AutoPurchaseOrder__c getAutoPurchaseOrder() {
        return [
            SELECT 
                Id,
                Name,
                dmpl__Remarks__c,
                dmpl__AutoOrderType__c,
                dmpl__Status__c,
                dmpl__PerformOrderGeneration__c,
                dmpl__IsOrderGenerated__c
            FROM dmpl__AutoPurchaseOrder__c
            LIMIT 1
        ];
    }

    public static dmpl__AutoPurchaseOrder__c getAutoPurchaseOrder(Id autoOrderId) {
        return [
            SELECT 
                Id,
                Name,
                dmpl__Remarks__c,
                dmpl__AutoOrderType__c,
                dmpl__Status__c,
                dmpl__PerformOrderGeneration__c,
                dmpl__IsOrderGenerated__c
            FROM dmpl__AutoPurchaseOrder__c
            WHERE Id = :autoOrderId
            LIMIT 1
        ];
    }

    public static dmpl__AutoPurchaseOrderLine__c createAutoPurchaseOrderLine(
        dmpl__AutoPurchaseOrder__c autoPurchaseOrder,
        dmpl__Item__c item,
        dmpl__SKU__c sku
    ) {
        return (dmpl__AutoPurchaseOrderLine__c) TestFactory.createSObject(
            new dmpl__AutoPurchaseOrderLine__c(
                dmpl__AutoPurchaseOrderId__c = autoPurchaseOrder.Id,
                dmpl__ItemId__c = item.Id,
                dmpl__SKUId__c = sku.Id
            ),
            'AutoPurchaseOrderLineDefaults',
            true
        );
    }

    public static dmpl__AutoPurchaseOrderLine__c updateAutoPurchaseOrderLine(
        dmpl__AutoPurchaseOrderLine__c existingLine,
        Integer newOrderQuantity,
        Decimal newUnitCost
    ) {
        return (dmpl__AutoPurchaseOrderLine__c) TestFactory.createSObject(
            new dmpl__AutoPurchaseOrderLine__c(
                Id = existingLine.Id,
                dmpl__UnitCost__c = newUnitCost
            ),
            'AutoPurchaseOrderLineDefaults',
            false
        );
    }

    public static dmpl__AutoPurchaseOrderLine__c getAutoPurchaseOrderLine() {
        return [
            SELECT 
                Id,
                Name,
                dmpl__AutoPurchaseOrderId__c,
                dmpl__ItemId__c,
                dmpl__SKUId__c,
                dmpl__MaximumQuantity__c,
                dmpl__MinimumQuantity__c,
                dmpl__UnitCost__c
            FROM dmpl__AutoPurchaseOrderLine__c
            LIMIT 1
        ];
    }

    public static dmpl__AutoPurchaseOrderLine__c getAutoPurchaseOrderLine(Id lineId) {
        return [
            SELECT 
                Id,
                Name,
                dmpl__AutoPurchaseOrderId__c,
                dmpl__ItemId__c,
                dmpl__SKUId__c,
                dmpl__MaximumQuantity__c,
                dmpl__MinimumQuantity__c,
                dmpl__UnitCost__c
            FROM dmpl__AutoPurchaseOrderLine__c
            WHERE Id = :lineId
            LIMIT 1
        ];
    }
}