@isTest
public with sharing class DeliveryOrderDataHelper {
    public static dmpl__DeliveryOrder__c createDeliveryOrder(Account customerAccount, dmpl__Branch__c branch) {
        return (dmpl__DeliveryOrder__c) TestFactory.createSObject(
            new dmpl__DeliveryOrder__c(
                dmpl__AccountId__c = customerAccount.Id,
                dmpl__BranchId__c = branch.Id,
                dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                dmpl__PerformReleaseShipment__c = false,
                dmpl__Discount__c = 100
            ),
            // 'DeliveryOrderDefaults',
            true
        );
    }
   
    public static dmpl__DeliveryOrder__c getDeliveryOrder() {
        return [
            SELECT
                Id,
                Name,
                dmpl__Discount__c,
                dmpl__Status__c,
                dmpl__TaxSupplyType__c,
                dmpl__TotalAmount__c,
                dmpl__TotalDiscountAmount__c,
                dmpl__TotalLineBaseAmount__c,
                dmpl__TotalLineGrossAmount__c,
                dmpl__TotalTaxAmount__c
            FROM dmpl__DeliveryOrder__c
            LIMIT 1
        ];
    }
 
    public static dmpl__DeliveryOrder__c getDeliveryOrder(Id id) {
        return [
            SELECT
                Id,
                Name,
                dmpl__AccountId__r.Name,
				dmpl__PartnerAccountId__r.Name,
				dmpl__BranchId__r.Name,
                dmpl__PartnerAccountId__c,
                dmpl__BranchId__c,
                dmpl__AccountId__c,
                dmpl__AccountName__c,
                dmpl__Discount__c,
                dmpl__Status__c,
                dmpl__TaxSupplyType__c,
                dmpl__TotalAmount__c,
                dmpl__TotalDiscountAmount__c,
                dmpl__TotalLineBaseAmount__c,
                dmpl__TotalLineGrossAmount__c,
                dmpl__TotalTaxAmount__c,
                dmpl__BillingAddress__c,
                dmpl__BillingStreet__c, 
				dmpl__BillingCountry__c,
                dmpl__TotalLineAmount__c,
                dmpl__BillingCity__c,
                dmpl__BillingPostalCode__c,
                dmpl__BillingState__c,
                dmpl__ShippingAddress__c,
                dmpl__ShippingStreet__c,
                dmpl__ShippingCity__c,
                dmpl__ShippingState__c,
                dmpl__ShippingCountry__c,
                dmpl__ShippingPostalCode__c,
                dmpl__DocumentDate__c,
                dmpl__SaleOrderId__c,
                dmpl__RepairOrderId__c,
                dmpl__DeliveryAddressId__c
            FROM dmpl__DeliveryOrder__c
            WHERE Id = :id
            LIMIT 1
        ];
    }
 
    public static dmpl__DeliveryOrderLine__c createDeliveryOrderLine(
        dmpl__Item__c item,
        dmpl__SKU__c sku,
        dmpl__DeliveryOrder__c deliveryOrder
    ) {
        return (dmpl__DeliveryOrderLine__c) TestFactory.createSObject(
            new dmpl__DeliveryOrderLine__c(
                dmpl__DeliveryId__c = deliveryOrder.Id,
                dmpl__ItemId__c = item.Id,
                dmpl__SKUId__c = sku.Id,
                dmpl__Quantity__c = 1
            ),
            'DeliveryOrderLineDefaults',
            true
        );
    }
 
    public static dmpl__DeliveryOrderLine__c getDeliveryOrderLine() {
        return [
            SELECT Id, dmpl__DeliveryId__c, dmpl__ItemId__c, dmpl__SKUId__c, dmpl__Quantity__c
            FROM dmpl__DeliveryOrderLine__c
            LIMIT 1
        ];
    }
 
    public static dmpl__DeliveryOrderLine__c getDeliveryOrderLine(Id id) {
        return [
            SELECT Id,
                 dmpl__DeliveryId__c,
                 dmpl__SKUId__c,
                 dmpl__ItemId__c,
                 dmpl__Quantity__c,
                 dmpl__TaxGroupId__c,
                 dmpl__UnitPrice__c,
				 dmpl__AllocatedQuantity__c,
                 dmpl__StorageLocationId__c,
				 dmpl__StorageLocationId__r.Name,
                 dmpl__Amount__c,
                 dmpl__BaseAmount__c,
                 dmpl__GrossAmount__c,
                 dmpl__NetDiscount__c,
                 dmpl__TaxAmount__c,
				 dmpl__ItemId__r.Name,
				dmpl__TaxGroupId__r.Name,
				dmpl__SKUId__r.Name,
                dmpl__ItemLotTypeId__c,
                dmpl__PendingShippedQuantity__c,
                dmpl__EligibleReturnQuantity__c,
                dmpl__PendingInvoiceQuantity__c,
                dmpl__RepairOrderLineId__c
            FROM dmpl__DeliveryOrderLine__c
            WHERE Id = :id
            LIMIT 1
        ];
    }
 
    public static dmpl__DeliveryOrderTax__c createDeliveryOrderTax(
        dmpl__DeliveryOrder__c deliveryOrder,
        dmpl__DeliveryOrderLine__c deliveryOrderLine,
        dmpl__Tax__c tax
    ) {
        return (dmpl__DeliveryOrderTax__c) TestFactory.createSObject(
            new dmpl__DeliveryOrderTax__c(
                dmpl__DeliveryOrderId__c = deliveryOrder.Id,
                dmpl__DeliveryOrderLineId__c = deliveryOrderLine.Id,
                dmpl__TaxId__c = tax.Id,
                dmpl__TaxRate__c = 3,
                dmpl__TaxAmount__c = 150,
                dmpl__TaxOnAmount__c = 100
            ),
            'DeliveryOrderTaxDefaults',
            true
        );
    }
 
    public static dmpl__DeliveryOrderTax__c getDeliveryOrderTax() {
        return [
            SELECT Id, Name, dmpl__TaxRate__c, dmpl__TaxAmount__c, dmpl__TaxOnAmount__c
            FROM dmpl__DeliveryOrderTax__c
            LIMIT 1
        ];
    }
 
    public static dmpl__DeliveryOrderTax__c getDeliveryOrderTax(Id id) {
        return [
            SELECT Id, Name, dmpl__TaxRate__c, dmpl__TaxAmount__c, dmpl__TaxOnAmount__c
            FROM dmpl__DeliveryOrderTax__c
            WHERE Id = :id
            LIMIT 1
        ];
    }
 
 
 
    //////
 
 
 	public static dmpl__DeliveryOrder__c createDeliveryOrder(
        Id partnerAccountId, 
        Id customerAccountId, 
        Id branchId, 
        Id repairOrderId, 
        Id saleOrderId, 
        Id deliveryAddressId
    ){
        return (dmpl__DeliveryOrder__c) TestFactory.createSObject(
            new dmpl__DeliveryOrder__c(
                dmpl__PartnerAccountId__c = partnerAccountId,
                dmpl__AccountId__c = customerAccountId,
                dmpl__BranchId__c = branchId,
                dmpl__RepairOrderId__c = repairOrderId,
                dmpl__SaleOrderId__c = saleOrderId,
                dmpl__DeliveryAddressId__c = deliveryAddressId
            ),
            //'DeliveryOrderDefaults',
            true
        );
    }

 
 
    public static dmpl__DeliveryOrderLine__c createDeliveryOrderLine (
        Id deliveryOrderId,
        Id itemId,
        Id taxGroupId,
        Decimal quantity,
        Decimal unitPrice,
        Id storageLocationId,
        Id saleOrderLineId,
        Id repairOrderLineId,
        Id skuId
    ){
        return (dmpl__DeliveryOrderLine__c) TestFactory.createSObject(
            new dmpl__DeliveryOrderLine__c(
                dmpl__DeliveryId__c = deliveryOrderId,
                dmpl__ItemId__c = itemId,
                dmpl__TaxGroupId__c = taxGroupId,
                dmpl__Quantity__c = quantity,
                dmpl__UnitPrice__c = unitPrice,
                dmpl__StorageLocationId__c = storageLocationId,
                dmpl__SaleOrderLineId__c = saleOrderLineId,
                dmpl__RepairOrderLineId__c = repairOrderLineId,
				dmpl__SKUId__c = skuId

            ),
           // 'DeliveryOrderLineDefaults',
            true
        );
    }
 
}