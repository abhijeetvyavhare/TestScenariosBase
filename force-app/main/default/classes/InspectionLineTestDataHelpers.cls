public with sharing class InspectionLineTestDataHelpers {
    public static dmpl__InspectionLine__c createInspectionLine(
    	dmpl__Item__c item,
        dmpl__GoodsReceipt__c goodsReceipt
    ) {
        return (dmpl__InspectionLine__c) TestFactory.createSObject(
        	new dmpl__InspectionLine__c (
            	dmpl__ItemId__c = item.Id,
                dmpl__ReceiptId__c = goodsReceipt.Id
            ),
            'InspectionLineDefaults',
            true
        );
    }
    
    public static dmpl__GoodsReceipt__c createGoodsReceipt(
    	Account partnerAccount,
        Account supplierAccount,
        dmpl__Branch__c Branch
    ) {
        return (dmpl__GoodsReceipt__c) TestFactory.createSObject(
        	new dmpl__GoodsReceipt__c(
            	dmpl__PartnerAccountId__c = partnerAccount.Id,
                dmpl__SupplierAccountId__c = supplierAccount.Id,
                dmpl__BranchId__c = Branch.Id
            ),
            'GoodsReceiptDefaults',
            true
        );
    }
    
    public static dmpl__InspectionLine__c getInspectionLine() {
        return [
            Select
                Id,
                dmpl__Quantity__c,
                dmpl__AdjustmentQuantity__c,
                dmpl__DamagedQuantity__c,
                dmpl__InspectionQuantity__c,
                dmpl__OrderQuantity__c,
                dmpl__ReceivedQuantity__c,
                dmpl__UnitCost__c
            FROM dmpl__InspectionLine__c
            LIMIT 1
        ];
    }
    
    public static List<dmpl__InspectionLine__c> getInspectionLine(Id id) {
        return [
            Select
                Id,
                dmpl__Quantity__c,
                dmpl__AdjustmentQuantity__c,
                dmpl__DamagedQuantity__c,
                dmpl__InspectionQuantity__c,
                dmpl__OrderQuantity__c,
                dmpl__ReceivedQuantity__c,
                dmpl__UnitCost__c
            FROM dmpl__InspectionLine__c
            WHERE Id = :id
        ];
    }
}