public with sharing class ShipmentTestDataHelper {
    public static dmpl__Shipment__c createShipment(Account supplierAccount, dmpl__Branch__c branch, dmpl__PurchaseOrder__c purchaseOrder) {
        return (dmpl__Shipment__c) TestFactory.createSObject(
            new dmpl__Shipment__c(
            dmpl__BranchId__c = branch.Id,
        dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
        dmpl__SupplierAccountId__c = supplierAccount.Id,
        dmpl__PurchaseOrderId__c = purchaseOrder.Id,
        dmpl__SupplierInvoiceNumber__c = 'Test - Shipment',
        dmpl__SupplierInvoiceDate__c = Date.today(),
        dmpl__DeliveryOrderNumber__c = '12',
        dmpl__DeliveryOrderDate__c = Date.today(),
        dmpl__TransporterName__c = 'ABC',
        dmpl__TransporterReferenceNo__c = '1234',
        dmpl__PerformReleaseReceipt__c = true,
        dmpl__IsReceiptReleased__c = true
            ),
        'ShipmentDefaults',
        true
            );
    }
    
    public static dmpl__Shipment__c createShipment(
        Date shipmentDate,
    Id PartnerAccountId,
    Id BranchId,
    Id SuppilerId,
    Id purchaseOrderId
    ) {
        return (dmpl__Shipment__c) TestFactory.createSObject(
            new dmpl__Shipment__c(
            dmpl__BranchId__c = BranchId,
        dmpl__PartnerAccountId__c = PartnerAccountId,
        dmpl__SupplierAccountId__c = SuppilerId,
        dmpl__PurchaseOrderId__c = purchaseOrderId,
        dmpl__SupplierInvoiceNumber__c = 'Test - Shipment',
        dmpl__SupplierInvoiceDate__c = Date.today(),
        // dmpl__DocumentDate__c = DocumentDate,
        dmpl__ShipmentDate__c = shipmentDate,
        dmpl__DeliveryOrderNumber__c = '12',
        dmpl__DeliveryOrderDate__c = Date.today(),
        dmpl__TransporterName__c = 'ABC',
        dmpl__TransporterReferenceNo__c = '1234',
        dmpl__PerformReleaseReceipt__c = true,
        dmpl__IsReceiptReleased__c = true
            ),
        'ShipmentDefaults',
        true
            );
    }
    
    public static dmpl__Shipment__c getShipment() {
        return [
            SELECT Id, Name,dmpl__PerformReleaseReceipt__c
            FROM dmpl__Shipment__c
            LIMIT 1
        ];
    }
    
    public static dmpl__Shipment__c getShipment(Id ShipmentId) {
        return [
            SELECT Id, Name,
            dmpl__PerformReleaseReceipt__c,
            dmpl__DocumentDate__c,
            dmpl__ShipmentDate__c,
            dmpl__PartnerAccountId__c,
            dmpl__BranchId__c,
            dmpl__PurchaseOrderId__c,
            dmpl__SupplierAccountId__c,
            dmpl__Status__c
            FROM dmpl__Shipment__c
            WHERE Id = :ShipmentId
            LIMIT 1
        ];
    }
    
    public static dmpl__ShipmentLine__c createShipmentLine(
        dmpl__Item__c item,
    dmpl__Shipment__c shipment,
    dmpl__SKU__c sku,
    dmpl__PurchaseOrderLine__c purchaseOrderLine
    ){
        return (dmpl__ShipmentLine__c)TestFactory.createSObject(
            new  dmpl__ShipmentLine__c(
            dmpl__ItemId__c = item?.Id,
        dmpl__ShipmentId__c = shipment?.Id,
        dmpl__Quantity__c = 1,
        dmpl__SKUId__c = sku?.Id,
        dmpl__UnitPrice__c=1,
        dmpl__PurchaseOrderLineId__c = purchaseOrderLine?.Id
            ),
        'ShipmentLineDefaults',
        true
            );
    }
    
    
    public static dmpl__ShipmentLine__c createShipmentLine(
        dmpl__Item__c item,
    dmpl__Shipment__c shipment,
    dmpl__SKU__c sku,
    dmpl__PurchaseOrderLine__c purchaseOrderLine,
    Integer unitprice,
    Integer quantity
    ){
        return (dmpl__ShipmentLine__c)TestFactory.createSObject(
            new  dmpl__ShipmentLine__c(
            dmpl__ItemId__c = item?.Id,
        dmpl__ShipmentId__c = shipment?.Id,
        dmpl__Quantity__c = quantity,
        dmpl__SKUId__c = sku?.Id,
        dmpl__UnitPrice__c= unitprice,
        dmpl__PurchaseOrderLineId__c = purchaseOrderLine?.Id
            ),
        'ShipmentLineDefaults',
        true
            );
    }
    
    public static dmpl__ShipmentLine__c getShipmentLine(){
        return [SELECT
        id,
        name,
        dmpl__Quantity__c
        FROM dmpl__ShipmentLine__c LIMIT 1];
    }
    
    public static dmpl__ShipmentLine__c getShipmentLine(Id LineId){
        return [SELECT
        id,
        name,
        dmpl__ShipmentId__c,
        dmpl__Quantity__c,
        dmpl__UnitPrice__c,
        dmpl__ItemId__c,
        dmpl__Amount__c,
        dmpl__SKUId__c,
        dmpl__PendingQuantity__c,
        dmpl__PurchaseOrderLineId__c
        FROM dmpl__ShipmentLine__c 
        WHERE Id = :LineId
        LIMIT 1];
    }
}