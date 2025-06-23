@isTest
public class PurchaseOrderTestDataHelpers {

    public static dmpl__PurchaseOrder__c createPurchaseOrder(
        dmpl__Branch__c branch, 
        Account supplierAccount) {
        return  (dmpl__PurchaseOrder__c)TestFactory.createSObject(
            new dmpl__PurchaseOrder__c(
                dmpl__BranchId__c = branch.Id,
                dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                dmpl__SupplierAccountId__c = supplierAccount.Id,
                dmpl__PurchaseOrderType__c = 'Part PO',
                dmpl__DocumentDate__c = date.today(),
                dmpl__Remarks__c = 'Test-Remarks',
                dmpl__PerformReleaseInvoice__c =false,
                dmpl__IsInvoiceReleased__c = false
            ),
            'PurchaseOrderDefaults',
            true
        );
    }
    
    public static dmpl__PurchaseOrderTax__c CreatePurchaseOrderTax(
    	dmpl__PurchaseOrder__c purchaseOrder,
        dmpl__Tax__c tax,
        dmpl__PurchaseOrderLine__c purchaseOrderLine
    ) {
        return (dmpl__PurchaseOrderTax__c) TestFactory.createSObject(
        	new dmpl__PurchaseOrderTax__c(
            	dmpl__PurchaseOrderId__c = purchaseOrder.Id,
                dmpl__TaxId__c = tax.Id,
                dmpl__PurchaseOrderLineId__c = purchaseOrderLine.Id
            ),
            'PurchaseOrderTaxDefaults',
            true
        );
    }

    
    public static dmpl__PurchaseOrder__c getPurchaseOrder(){
        return [SELECT 
        Id, 
        Name,
        dmpl__DocumentDate__c,
        dmpl__DiscountGroupId__c,
        dmpl__BranchId__c,
        dmpl__PartnerAccountId__c,
        dmpl__TotalLineGrossAmount__c,
        dmpl__TaxGroupId__c,
        dmpl__TCSEligibleAmount__c,
        dmpl__RepairOrderId__c,
        dmpl__Status__c,
        dmpl__PerformReleaseInvoice__c,
        dmpl__PerformReleaseReceipt__c,
        dmpl__PerformKPICalculation__c,
        dmpl__SupplierAccountId__c,
        dmpl__TransactionType__c
        FROM dmpl__PurchaseOrder__c LIMIT 1];
      
    }
    public static dmpl__PurchaseOrder__c getPurchaseOrder( Id purchaseOrder){
        return [SELECT 
        Id, 
        Name,
        dmpl__DocumentDate__c,
        dmpl__DiscountGroupId__c,
        dmpl__BranchId__c,
        dmpl__PartnerAccountId__c,
        dmpl__TotalLineGrossAmount__c,
        dmpl__TaxGroupId__c,
        dmpl__TCSEligibleAmount__c,
        dmpl__RepairOrderId__c,
        dmpl__Status__c,
        dmpl__PerformReleaseInvoice__c,
        dmpl__PerformReleaseReceipt__c,
        dmpl__PerformKPICalculation__c,
        dmpl__SupplierAccountId__c,
        dmpl__TransactionType__c
        FROM dmpl__PurchaseOrder__c
        WHERE ID =: purchaseOrder
                LIMIT 1];
     
    }

    public static dmpl__PurchaseOrderLine__c createPurchaseOrderLine(
        dmpl__Item__c listofitem,
        dmpl__SKU__c sku,
        dmpl__PurchaseOrder__c  purchaseorder,
        dmpl__TaxGroup__c  taxgroup,
        dmpl__PurchaseRequisition__c purchaseRequisition){
        return (dmpl__PurchaseOrderLine__c)TestFactory.createSObject(
            new  dmpl__PurchaseOrderLine__c(
                dmpl__ItemId__c = listofitem.Id,
                dmpl__SKUId__c = sku.Id,
                dmpl__PurchaseOrderId__c = purchaseOrder.Id,
                dmpl__Quantity__c = 1,
                dmpl__UnitCost__c = 100,
                dmpl__TaxGroupId__c = taxGroup.Id,
                dmpl__SchemeDiscount__c = 2,
                dmpl__SchemeDiscountAmount__c = 4,
                dmpl__DiscountAmount__c = 100,
                dmpl__PurchaseRequisitionId__c = purchaseRequisition.Id
            ),
            'PurchaseOrderLineDefaults',
            true
        );
    }

    public static dmpl__PurchaseOrderLine__c createPurchaseOrderLine(
        dmpl__Item__c listofitem,
        dmpl__SKU__c sku,
        dmpl__PurchaseOrder__c  purchaseorder,
        dmpl__TaxGroup__c  taxgroup
        ){
        return (dmpl__PurchaseOrderLine__c)TestFactory.createSObject(
            new  dmpl__PurchaseOrderLine__c(
                dmpl__ItemId__c = listofitem.Id,
                dmpl__SKUId__c = sku.Id,
                dmpl__PurchaseOrderId__c = purchaseOrder.Id,
                dmpl__Quantity__c = 1,
                dmpl__UnitCost__c = 100,
                dmpl__TaxGroupId__c = taxGroup.Id,
                dmpl__SchemeDiscount__c = 2,
                dmpl__SchemeDiscountAmount__c = 4,
                dmpl__DiscountAmount__c = 100
            ),
            'PurchaseOrderLineDefaults',
            true
        );
    }

    public static dmpl__PurchaseOrderLine__c getPurchaseOrderLine(){
        return [SELECT 
        id, 
        Name,
        dmpl__PurchaseOrderId__c,
        dmpl__ItemId__c,
        dmpl__SKUId__c,
        dmpl__TaxGroupId__c,
        dmpl__ItemComponentId__c,
        dmpl__Quantity__c,
        dmpl__Amount__c,
        dmpl__UnitCost__c,
        dmpl__PurchaseOrderId__r.dmpl__SupplierAccountId__c,
        dmpl__PendingQuantity__c,
        dmpl__PurchaseOrderId__r.dmpl__BranchId__c,
        dmpl__PurchaseOrderId__r.dmpl__PartnerAccountId__c
        FROM dmpl__PurchaseOrderLine__c LIMIT 1];
    }
    
    public static dmpl__PurchaseOrderLine__c getPurchaseOrderLine(Id purchaseOrderLine){
        return [SELECT 
        id, 
        Name,
        dmpl__PurchaseOrderId__c,
        dmpl__ItemId__c,
        dmpl__SKUId__c,
        dmpl__TaxGroupId__c,
        dmpl__ItemComponentId__c,
        dmpl__Quantity__c,
        dmpl__Amount__c,
		dmpl__UnitCost__c,
        dmpl__PurchaseOrderId__r.dmpl__SupplierAccountId__c,
        dmpl__PendingQuantity__c,
        dmpl__PurchaseOrderId__r.dmpl__BranchId__c,
        dmpl__PurchaseOrderId__r.dmpl__PartnerAccountId__c
        FROM dmpl__PurchaseOrderLine__c 
        WHERE Id =: purchaseOrderLine
        LIMIT 1];
    }

    public static dmpl__PurchaseRequisition__c CreatePurchaseRequisition(
        dmpl__Branch__c branch,
        Account supplierAccount){
        return  (dmpl__PurchaseRequisition__c)TestFactory.createSObject(
            new dmpl__PurchaseRequisition__c(
                dmpl__BranchId__c = branch.Id,
                dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                dmpl__SupplierAccountId__c = supplierAccount.Id,
                dmpl__PerformReleaseOrder__c = false,
                dmpl__IsOrderReleased__c = true,
                dmpl__DocumentDate__c=Date.today(),
                dmpl__Remarks__c='sample'
           ),
           'PurchaseRequistionDefaults',
           true
        );
    }

    public static dmpl__PurchaseRequisition__c getPurchaseRequisition(){
        return [SELECT 
        id,
        Name,
        dmpl__Status__c,
        dmpl__PerformReleaseOrder__c,
        dmpl__BranchId__c,
        dmpl__PartnerAccountId__c,
        dmpl__SupplierAccountId__c 
        FROM dmpl__PurchaseRequisition__c LIMIT 1];
    }

    public static dmpl__PurchaseRequisitionLine__c CreatePurchaseRequisitionLine(
        dmpl__PurchaseRequisition__c purchaseRequisition,
        dmpl__Item__c item,
        dmpl__SKU__c sku){
        return (dmpl__PurchaseRequisitionLine__c)TestFactory.createSObject(
            new dmpl__PurchaseRequisitionLine__c(
                dmpl__PurchaseRequisitionId__c = purchaseRequisition.Id,
                dmpl__ItemId__c = item.Id,
                dmpl__SKUId__c = sku.Id,
                dmpl__Quantity__c = 1
           ),
        //    'PurchaseRequisitionLineDefaults',
           true
        );
    }

    public static dmpl__PurchaseRequisitionLine__c getPurchaseRequisitionLine(){
        return [SELECT id, Name FROM dmpl__PurchaseRequisitionLine__c LIMIT 1];
    }


    public static dmpl__PurchaseOrder__c CreatePurchaseOrderFromPurchaseRequisition(
        dmpl__PurchaseRequisition__c purchaseRequisition){
            return (dmpl__PurchaseOrder__c)TestFactory.createSObject(
                new dmpl__PurchaseOrder__c(
                    dmpl__BranchId__c = purchaseRequisition.dmpl__BranchId__c,
                    dmpl__PartnerAccountId__c = purchaseRequisition.dmpl__PartnerAccountId__c,
                    dmpl__SupplierAccountId__c = purchaseRequisition.dmpl__SupplierAccountId__c
                ),
               'PurchaseOrderDefaults',
               true
            );
    }

    public static dmpl__PurchaseOrder__c getPurchaseOrderFromPurchaseRequisition(){
        return [SELECT Id,Name FROM dmpl__PurchaseOrder__c LIMIT 1];
    }
    
    public static dmpl__PurchaseOrderTax__c getPurchaseOrderTax() {
        return [
          Select Id, dmpl__TaxOnAmount__c, dmpl__TaxRate__c
          FROM dmpl__PurchaseOrderTax__c 
          LIMIT 1
        ];
    }
    
    public static dmpl__PurchaseOrderTax__c getPurchaseOrderTax(Id purchaseOrderTax) {
        return [
          Select Id, dmpl__TaxOnAmount__c, dmpl__TaxRate__c
          FROM dmpl__PurchaseOrderTax__c 
          WHERE Id =: purchaseOrderTax
          LIMIT 1
        ];
    }
    public static dmpl__PurchaseOrderRequisition__c createPurchaseOrderRequisition(
    Account partnerAccount,
    dmpl__PurchaseOrder__c purchaseOrder,
    dmpl__PurchaseOrderLine__c purchaseOrderLine,
    dmpl__PurchaseRequisition__c requisition,
    dmpl__PurchaseRequisitionLine__c requisitionLine,
    dmpl__Branch__c branch
) {
    return (dmpl__PurchaseOrderRequisition__c)TestFactory.createSObject(
        new dmpl__PurchaseOrderRequisition__c(
            dmpl__PartnerAccountId__c = partnerAccount.Id,
            dmpl__PurchaseOrderId__c = purchaseOrder.Id,
            dmpl__PurchaseOrderLineId__c = purchaseOrderLine.Id,
            dmpl__PurchaseRequisitionId__c = requisition.Id,
            dmpl__PurchaseRequisitionLineId__c = requisitionLine.Id,
            dmpl__BranchId__c = branch.Id,
            dmpl__RequestedQuantity__c = 5,
            dmpl__OrderedQuantity__c = 4
        ),
        'PurchaseOrderRequisitionDefault',
        true
    );
}
public static dmpl__PurchaseOrderRequisition__c getPurchaseOrderRequisition(Id requisitionId) {
    return [
        SELECT 
            Id,
            Name,
            dmpl__RequestedQuantity__c,
            dmpl__OrderedQuantity__c,
            dmpl__PartnerAccountId__c,
            dmpl__PurchaseOrderId__c,
            dmpl__PurchaseOrderLineId__c,
            dmpl__PurchaseRequisitionId__c,
            dmpl__PurchaseRequisitionLineId__c,
            dmpl__BranchId__c
        FROM dmpl__PurchaseOrderRequisition__c
        WHERE Id = :requisitionId
        LIMIT 1
    ];
}
    public static dmpl__PurchaseOrderRequisition__c getPurchaseOrderRequisition() {
    return [
        SELECT 
            Id,
            Name,
            dmpl__RequestedQuantity__c,
            dmpl__OrderedQuantity__c,
            dmpl__PartnerAccountId__c,
            dmpl__PurchaseOrderId__c,
            dmpl__PurchaseOrderLineId__c,
            dmpl__PurchaseRequisitionId__c,
            dmpl__PurchaseRequisitionLineId__c,
            dmpl__BranchId__c
        FROM dmpl__PurchaseOrderRequisition__c
       
        LIMIT 1
    ];
}


}