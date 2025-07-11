@isTest
public class RequisitionTestDataHelpers {

    public static dmpl__PurchaseRequisition__c createRequisition(
        Account partnerAccount,
        dmpl__Branch__c branch
    ) {
        return (dmpl__PurchaseRequisition__c)TestFactory.createSObject(
            new dmpl__PurchaseRequisition__c(
                dmpl__PartnerAccountId__c = partnerAccount.Id,
                dmpl__BranchId__c = branch.Id,
                dmpl__DocumentDate__c = date.today(),
                dmpl__Status__c = 'Draft',
                dmpl__Remarks__c = 'Test-Remarks'
            ),
             'PurchaseRequisitionDefaults',
            true
        );

    }
	
    public static dmpl__PurchaseRequisition__c createRequisition(
        Id partnerAccountId,
        Id branchId,
		Id supplierAccountId
    ) {
        return (dmpl__PurchaseRequisition__c)TestFactory.createSObject(
            new dmpl__PurchaseRequisition__c(
                dmpl__PartnerAccountId__c = partnerAccountId,
                dmpl__BranchId__c = branchId,
				dmpl__SupplierAccountId__c = supplierAccountId,
                dmpl__DocumentDate__c = date.today(),
                dmpl__Status__c = 'Draft',
                dmpl__Remarks__c = 'Test-Remarks'
            ),
            true
        );

    }

    public static dmpl__PurchaseRequisition__c getRequisition(){
        return [SELECT 
        Id, 
        Name,
        dmpl__Status__c,
        dmpl__PerformReleaseOrder__c,
        dmpl__IsOrderReleased__c,
        (SELECT 
        Id,
        Name,
        dmpl__Quantity__c 
        FROM dmpl__PurchaseRequisitionLines__r)
        FROM dmpl__PurchaseRequisition__c LIMIT 1];
    }

    public static dmpl__PurchaseRequisition__c getRequisition(Id id){
        return [SELECT 
					Id, 
					Name,
					dmpl__Status__c,
					dmpl__PerformReleaseOrder__c,
					dmpl__IsOrderReleased__c,
					dmpl__PartnerAccountId__c,
					dmpl__BranchId__c,
					dmpl__SupplierAccountId__c,
					dmpl__DocumentDate__c,
					dmpl__Remarks__c,
					dmpl__TotalAmount__c
        		FROM dmpl__PurchaseRequisition__c
				WHERE Id = :Id
				LIMIT 1];
    }

    public static dmpl__PurchaseRequisitionLine__c createRequisitionLine(
        dmpl__PurchaseRequisition__c purchaseRequisition,
        dmpl__Item__c item,
        dmpl__SKU__c sku
    ) {
        return (dmpl__PurchaseRequisitionLine__c)TestFactory.createSObject(
            new dmpl__PurchaseRequisitionLine__c(
                dmpl__PurchaseRequisitionId__c = purchaseRequisition.Id,
                dmpl__ItemId__c = item.Id,
                dmpl__SKUId__c = sku.Id,
                dmpl__Quantity__c = 1
            ),
            'PurchaseRequisitionLineDefaults',
            true
        );
    }
    public static dmpl__PurchaseRequisitionLine__c createRequisitionLine(
        dmpl__PurchaseRequisition__c purchaseRequisition,
        dmpl__Item__c item,
        Decimal quantity,
        Decimal unitCost
    ) {
        return (dmpl__PurchaseRequisitionLine__c)TestFactory.createSObject(
            new dmpl__PurchaseRequisitionLine__c(
                dmpl__PurchaseRequisitionId__c = purchaseRequisition.Id,
                dmpl__ItemId__c = item.Id,
                dmpl__Quantity__c = quantity,
                dmpl__UnitCost__c = unitCost
            ),
            true
        );
    }

    public static dmpl__PurchaseRequisitionLine__c getRequisitionLine(){
        return [SELECT 
        id, 
        name,
        dmpl__Quantity__c
        FROM dmpl__PurchaseRequisitionLine__c LIMIT 1];
    }

    public static dmpl__PurchaseRequisitionLine__c getRequisitionLine(Id id){
        return [SELECT 
					id, 
					name,
					dmpl__Quantity__c,
					dmpl__Amount__c,
					dmpl__ExcludeInAutoOrder__c,
					dmpl__ExternalId__c,
					dmpl__ItemId__c,
					dmpl__PendingQuantity__c,
					dmpl__PurchaseOrderQuantity__c,
					dmpl__PurchaseRequisitionId__c,
					dmpl__StockTransferQuantity__c,
					dmpl__TaxGroupId__c,
					dmpl__UnitCost__c,
					dmpl__SKUId__c
        		FROM dmpl__PurchaseRequisitionLine__c
				WHERE Id = :id LIMIT 1];
	}
}