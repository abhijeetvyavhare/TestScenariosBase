@isTest
public with sharing class AutoPurchaseOrderLineRelationDataHelper {
    public static dmpl__AutoPurchaseOrderLineRelation__c createAutoPurchaseOrderLineRelation(
        dmpl__AutoPurchaseOrder__c autoPurchaseOrder,
        dmpl__AutoPurchaseOrderLine__c autoPurchaseOrderLine,
        dmpl__Item__c item,
        dmpl__ItemLotType__c itemLot,
        dmpl__SKU__c sku
    ) {
        return (dmpl__AutoPurchaseOrderLineRelation__c) TestFactory.createSObject(
            new dmpl__AutoPurchaseOrderLineRelation__c(
                dmpl__AutoPurchaseOrderId__c = autoPurchaseOrder.Id,
                dmpl__AutoPurchaseOrderLineId__c = autoPurchaseOrderLine.Id,
                dmpl__ItemId__c = item.Id,
                dmpl__ItemLotTypeId__c = itemLot.Id,
                dmpl__SKUId__c = sku.Id
            ),
            'AutoPurchaseOrderLineRelationDefault', 
            true
        );
    }

    public static dmpl__AutoPurchaseOrderLineRelation__c getAutoPurchaseOrderLineRelation() {
        return [
            SELECT 
                Id,
                Name,
                dmpl__AutoPurchaseOrderId__c,
                dmpl__AutoPurchaseOrderLineId__c,
                dmpl__ItemId__c,
                dmpl__ItemLotTypeId__c,
                dmpl__SKUId__c,
                dmpl__OrderQuantity__c,
                dmpl__PurchaseOrderQuantity__c,
                dmpl__UnitCost__c
            FROM dmpl__AutoPurchaseOrderLineRelation__c
            LIMIT 1
        ];
    }

    public static dmpl__AutoPurchaseOrderLineRelation__c getAutoPurchaseOrderLineRelation(Id recordId) {
        return [
            SELECT 
                Id,
                Name,
                dmpl__AutoPurchaseOrderId__c,
                dmpl__AutoPurchaseOrderLineId__c,
                dmpl__ItemId__c,
                dmpl__ItemLotTypeId__c,
                dmpl__SKUId__c,
                dmpl__OrderQuantity__c,
                dmpl__PurchaseOrderQuantity__c,
                dmpl__UnitCost__c
            FROM dmpl__AutoPurchaseOrderLineRelation__c
            WHERE Id = :recordId
            LIMIT 1
        ];
    }
}