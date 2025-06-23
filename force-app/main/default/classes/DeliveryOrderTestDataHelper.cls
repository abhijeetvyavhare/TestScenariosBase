public with sharing class DeliveryOrderTestDataHelper {
    public static dmpl__DeliveryOrder__c createDeliveryOrder(Account customerAccount, dmpl__Branch__c branch) {
        return (dmpl__DeliveryOrder__c) TestFactory.createSObject(
            new dmpl__DeliveryOrder__c(
                dmpl__AccountId__c = customerAccount.Id,
                dmpl__BranchId__c = branch.Id,
                dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                dmpl__PerformReleaseShipment__c = false,
                dmpl__Discount__c = 100
            ),
			'DeliveryOrderDefaults',
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
                dmpl__AccountName__c,
                dmpl__Discount__c,
                dmpl__Status__c,
                dmpl__TaxSupplyType__c,
                dmpl__TotalAmount__c,
                dmpl__TotalDiscountAmount__c,
                dmpl__TotalLineBaseAmount__c,
                dmpl__TotalLineGrossAmount__c,
                dmpl__TotalTaxAmount__c
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
            SELECT Id, dmpl__DeliveryId__c, dmpl__ItemId__c, dmpl__SKUId__c, dmpl__Quantity__c
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
     public static Asset createAsset(
        String name,
    Account account,
    dmpl__Item__c item
    ){
        return (Asset) TestFactory.createSObject(
            new Asset(
            Name = name,
        AccountId = account.Id,
        dmpl__ItemId__c = item.Id,
        dmpl__SaleDate__c =  Date.today()
            ),
        true
            );
    }
    
    public static Asset getAsset(Id id){
        return [
            SELECT Id, name, AccountId, dmpl__ItemId__c, dmpl__SaleDate__c 
				FROM Asset 
				WHERE id = :id LIMIT 1
        ];
    }
}