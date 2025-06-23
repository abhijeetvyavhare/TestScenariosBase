@isTest
public with sharing class FulfillmentTestDataHelpers {
    public static dmpl__InventoryFulfillment__c createInventoryFulfillment(
        Account partnerAccount,
        Account account,
        dmpl__Branch__c branch,
        dmpl__RepairOrder__c repairOrder,
        dmpl__SaleOrder__c saleOrder
    ){
        return (dmpl__InventoryFulfillment__c) TestFactory.createSObject(
            new dmpl__InventoryFulfillment__c(
                dmpl__AccountId__c = account?.Id ?? null,
                dmpl__BranchId__c = branch?.Id ?? null,
                dmpl__PartnerAccountId__c = partnerAccount?.Id ?? null,
                dmpl__RepairOrderId__c = repairOrder?.Id ?? null,
                dmpl__Status__c = 'Draft' ?? null,
                
                dmpl__SaleOrderId__c = saleOrder?.Id ?? null
            ),
            //'FulfillmentDefaults',
            true
        );
    }

    public static dmpl__InventoryFulfillment__c getInventoryFulfillment() {
        return [SELECT
            Id, 
            Name, 
            dmpl__AccountId__c, 
            dmpl__BranchId__c , 
            dmpl__PartnerAccountId__c,
            dmpl__RepairOrderId__c,
            dmpl__SaleOrderId__c,
            dmpl__isAllocated__c,
            dmpl__PerformAllocation__c,
			dmpl__Status__c,
			dmpl__DocumentDate__c
        FROM dmpl__InventoryFulfillment__c LIMIT 1];
    }

    public static dmpl__InventoryFulfillment__c getInventoryFulfillment(Id InventoryFulfillmentId) {
        return [SELECT
            Id, 
            Name, 
            dmpl__AccountId__c, 
            dmpl__BranchId__c , 
            dmpl__PartnerAccountId__c,
            dmpl__RepairOrderId__c,
            dmpl__SaleOrderId__c,
            dmpl__isAllocated__c,
            dmpl__PerformAllocation__c,
			dmpl__Status__c,
			dmpl__DocumentDate__c
        FROM dmpl__InventoryFulfillment__c where Id= :InventoryFulfillmentId LIMIT 1];
    }

    public static dmpl__InventoryFulfillmentOrderLine__c createInventoryFulfillmentOrderLine(
        dmpl__InventoryFulfillment__c inventoryFulfillment,
        dmpl__Item__c item,
        dmpl__SKU__c sku,
        dmpl__SaleOrderLine__c saleOrderLine
    ){
        return (dmpl__InventoryFulfillmentOrderLine__c) TestFactory.createSObject(
            new dmpl__InventoryFulfillmentOrderLine__c(
                dmpl__FulfillmentId__c = inventoryFulfillment.Id,
                dmpl__ItemId__c = item.Id,
                dmpl__SKUId__c = sku.Id,
                dmpl__SaleOrderLineId__c = saleOrderLine.Id,
                dmpl__Quantity__c = 15
            ),
           // 'FulfillmentOrderLineDefaults',
            true
        );
    }

    public static dmpl__InventoryFulfillmentOrderLine__c getInventoryFulfillmentOrderLine() {
        return [SELECT 
            Id, 
            Name, 
            dmpl__FulfillmentId__c, 
            dmpl__ItemId__c, 
            dmpl__SKUId__c, 
            dmpl__SaleOrderLineId__c,
            dmpl__IsILPosted__c, 
            dmpl__Quantity__c
        FROM dmpl__InventoryFulfillmentOrderLine__c LIMIT 1];
    }

    public static dmpl__InventoryFulfillmentOrderLine__c getInventoryFulfillmentOrderLine(Id InventoryFulfillmentOrderLineId) {
        return [SELECT 
            Id, 
            Name, 
            dmpl__FulfillmentId__c, 
            dmpl__ItemId__c, 
            dmpl__SKUId__c,
            dmpl__PendingAllocationQuantity__c,
            dmpl__SaleOrderLineId__c,
            dmpl__StorageLocationId__c,
            dmpl__RepairOrderLineId__c,
            dmpl__IsILPosted__c,
            dmpl__UnitCost__c,
            dmpl__Quantity__c
        FROM dmpl__InventoryFulfillmentOrderLine__c where Id= :InventoryFulfillmentOrderLineId LIMIT 1];
    }

   public static dmpl__InventoryFulfillmentAllocationLine__c createInventoryFulfillmentAllocationLine(
        dmpl__Item__c item,
        dmpl__ItemLot__c itemLot,
        dmpl__SKU__c sku,
        dmpl__Resource__c resource,
        dmpl__InventoryFulfillment__c fulfillment,
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine
   ){
        return (dmpl__InventoryFulfillmentAllocationLine__c) TestFactory.createSObject(
            new dmpl__InventoryFulfillmentAllocationLine__c(
            dmpl__ItemId__c = item.Id,
            dmpl__SKUId__c = sku.Id,
            dmpl__Quantity__c = 1, 
            dmpl__FulfillmentOrderLineId__c=fulfillmentorderline.Id,
            dmpl__ItemLotId__c = itemLot.Id,
            dmpl__UnitCost__c = 10,
            dmpl__IsILPosted__c = true,
            dmpl__AllocatedById__c = resource.Id,
            dmpl__FulfillmentOrderId__c = fulfillment.Id,
            dmpl__DocumentDate__c = Date.today()
            ),
            true
        );
    }
    public static dmpl__InventoryFulfillmentAllocationLine__c createInventoryFulfillmentAllocationLine(
        dmpl__Item__c item,
        decimal quantity,
        dmpl__SKU__c sku,
        decimal unitCost,
        dmpl__InventoryFulfillment__c fulfillment,
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine,
        dmpl__SaleOrderLine__c saleOrderLine
    ) {
        return (dmpl__InventoryFulfillmentAllocationLine__c) TestFactory.createSObject(
            new dmpl__InventoryFulfillmentAllocationLine__c(
                dmpl__ItemId__c = item.Id,
                dmpl__SKUId__c = sku.Id,
                dmpl__Quantity__c = quantity,
                dmpl__UnitCost__c = unitCost,
                dmpl__FulfillmentOrderLineId__c = fulfillmentorderline.Id,
                dmpl__FulfillmentOrderId__c = fulfillment.Id,
                dmpl__SaleOrderLineId__c = saleOrderLine.Id
            ),
            true
        );
    }
    
    public static dmpl__InventoryFulfillmentAllocationLine__c createInventoryFulfillmentAllocationLine(
        dmpl__Item__c item,
        decimal quantity,
        dmpl__SKU__c sku,
        decimal unitCost,
        dmpl__InventoryFulfillment__c fulfillment,
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine,
        dmpl__RepairOrderLine__c repairOrderLine
    ) {
        return (dmpl__InventoryFulfillmentAllocationLine__c) TestFactory.createSObject(
            new dmpl__InventoryFulfillmentAllocationLine__c(
                dmpl__ItemId__c = item.Id,
                dmpl__SKUId__c = sku.Id,
                dmpl__Quantity__c = quantity,
                dmpl__UnitCost__c = unitCost,
                dmpl__FulfillmentOrderLineId__c = fulfillmentorderline.Id,
                dmpl__FulfillmentOrderId__c = fulfillment.Id,
                dmpl__RepairOrderLineId__c = repairOrderLine.Id
            ),
            true
        );
    }
    public static dmpl__InventoryFulfillmentAllocationLine__c createInventoryFulfillmentAllocationLine(
        dmpl__Item__c item,
        decimal quantity,
        Decimal unitCost,
        dmpl__ItemLot__c itemLot,
        dmpl__SKU__c sku,
        dmpl__Resource__c resource,
        dmpl__InventoryFulfillment__c fulfillment,
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine
   ){
        return (dmpl__InventoryFulfillmentAllocationLine__c) TestFactory.createSObject(
            new dmpl__InventoryFulfillmentAllocationLine__c(
            dmpl__ItemId__c = item?.Id??null,
            dmpl__SKUId__c = sku?.Id??null,
            dmpl__Quantity__c = quantity, 
            dmpl__FulfillmentOrderLineId__c=fulfillmentorderline?.Id??null,
            dmpl__ItemLotId__c = itemLot?.Id??null,
            dmpl__UnitCost__c = unitCost,
            dmpl__IsILPosted__c = true,
            dmpl__AllocatedById__c = resource?.Id??null,
            dmpl__FulfillmentOrderId__c = fulfillment?.Id??null,
            dmpl__DocumentDate__c = Date.today()
            ),
            true
        );
    }
    
    public static dmpl__InventoryFulfillmentAllocationLine__c createInventoryFulfillmentAllocationLine(
        dmpl__Item__c item,
        decimal quantity,
        Decimal unitCost,
        dmpl__ItemLot__c itemLot,
        dmpl__SKU__c sku,
        dmpl__Resource__c resource,
        dmpl__SaleOrderLine__c saleOrderLine,
        dmpl__InventoryFulfillment__c fulfillment,
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine
   ){
        return (dmpl__InventoryFulfillmentAllocationLine__c) TestFactory.createSObject(
            new dmpl__InventoryFulfillmentAllocationLine__c(
            dmpl__ItemId__c = item?.Id??null,
            dmpl__SKUId__c = sku?.Id??null,
            dmpl__Quantity__c = quantity, 
            dmpl__FulfillmentOrderLineId__c=fulfillmentorderline?.Id??null,
            dmpl__ItemLotId__c = itemLot?.Id??null,
            dmpl__UnitCost__c = unitCost,
            dmpl__IsILPosted__c = true,
            dmpl__AllocatedById__c = resource?.Id??null,
            dmpl__FulfillmentOrderId__c = fulfillment?.Id??null,
            dmpl__SaleOrderLineId__c=saleOrderLine.Id,
            dmpl__DocumentDate__c = Date.today()
            ),
            true
        );
    }
    
    public static dmpl__InventoryFulfillmentAllocationLine__c createInventoryFulfillmentAllocationLine(
        dmpl__Item__c item,
        decimal quantity,
        Decimal unitCost,
        dmpl__SKU__c sku,
        dmpl__Resource__c resource,
        dmpl__InventoryFulfillment__c fulfillment,
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine,
        dmpl__StorageLocation__c storageLocation
    ) {
        return (dmpl__InventoryFulfillmentAllocationLine__c) TestFactory.createSObject(
            new dmpl__InventoryFulfillmentAllocationLine__c(
                dmpl__ItemId__c = item.Id,
                dmpl__SKUId__c = sku?.Id,
                dmpl__Quantity__c = quantity,
                dmpl__StorageLocationId__c = storageLocation?.Id,
                dmpl__FulfillmentOrderLineId__c = fulfillmentorderline.Id,
                dmpl__UnitCost__c = unitCost,
                dmpl__IsILPosted__c = true,
                dmpl__AllocatedById__c = (resource != null
                    ? resource.Id
                    : null),
                dmpl__FulfillmentOrderId__c = fulfillment.Id,
                dmpl__DocumentDate__c = Date.today()
            ),
            true
        );
    }

    public static dmpl__InventoryFulfillmentAllocationLine__c createInventoryFulfillmentAllocationLine(
        dmpl__Item__c item,
        decimal quantity,
        //Decimal unitCost,
        //dmpl__ItemLot__c itemLot,
        dmpl__SKU__c sku,
        //dmpl__Resource__c resource,
        dmpl__InventoryFulfillment__c fulfillment,
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine
   ){
        return (dmpl__InventoryFulfillmentAllocationLine__c) TestFactory.createSObject(
            new dmpl__InventoryFulfillmentAllocationLine__c(
            dmpl__ItemId__c = item.Id,
            dmpl__SKUId__c = sku.Id,
            dmpl__Quantity__c = quantity, 
            dmpl__FulfillmentOrderLineId__c=fulfillmentorderline.Id,
            //dmpl__ItemLotId__c = itemLot.Id,
            //dmpl__UnitCost__c = unitCost,
            dmpl__IsILPosted__c = true,
            //dmpl__AllocatedById__c = resource.Id,
            dmpl__FulfillmentOrderId__c = fulfillment.Id,
            dmpl__DocumentDate__c = Date.today()
            ),
            true
        );
    }

    public static dmpl__InventoryFulfillmentAllocationLine__c createInventoryFulfillmentAllocationLine(
        dmpl__Item__c item,
        decimal quantity,
        //dmpl__SKU__c sku,
        dmpl__InventoryFulfillment__c fulfillment,
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine
           ){
        return (dmpl__InventoryFulfillmentAllocationLine__c) TestFactory.createSObject(
            new dmpl__InventoryFulfillmentAllocationLine__c(
            dmpl__ItemId__c = item.Id,
            //dmpl__SKUId__c = sku.Id,
            dmpl__Quantity__c = quantity, 
            dmpl__FulfillmentOrderLineId__c=fulfillmentorderline.Id,
            //dmpl__ItemLotId__c = itemLot.Id,
            //dmpl__UnitCost__c = unitCost,
            dmpl__IsILPosted__c = true,
            //dmpl__AllocatedById__c = resource.Id,
            dmpl__FulfillmentOrderId__c = fulfillment.Id,
            dmpl__DocumentDate__c = Date.today()
            ),
            true
        );
    }

    public static dmpl__InventoryFulfillmentAllocationLine__c getInventoryFulfillmentAllocationLine() {
        return [SELECT 
            Id, 
            Name, 
            dmpl__UnitCost__c,
            dmpl__FulfillmentOrderId__c,
            dmpl__ParentFulfillmentAllocationLineId__c,
            dmpl__IsILPosted__c
        FROM dmpl__InventoryFulfillmentAllocationLine__c LIMIT 1];
    }

    public static dmpl__InventoryFulfillmentAllocationLine__c getInventoryFulfillmentAllocationLine(Id InventoryFulfillmentAllocationLineId) {
        return [SELECT 
            Id, 
            Name, 
            dmpl__UnitCost__c,
            dmpl__FulfillmentOrderId__c,
            dmpl__RepairOrderLineId__c,
            dmpl__FulfillmentOrderLineId__c,
            dmpl__Quantity__c,
            dmpl__ItemId__c,
            dmpl__EligibleReturnQuantity__c, 
            dmpl__ParentFulfillmentAllocationLineId__c,
            dmpl__AllocatedQuantity__c,
            dmpl__SaleOrderLineId__c,
            dmpl__StorageLocationId__c,
            dmpl__PendingDeliveryQuantity__c,
            dmpl__PendingInvoiceQuantity__c,
            dmpl__PendingPickingQuantity__c,
            dmpl__IsILPosted__c
        FROM dmpl__InventoryFulfillmentAllocationLine__c where Id= :InventoryFulfillmentAllocationLineId LIMIT 1];
   }

    public static dmpl__InventoryFulfillmentPickingLine__c createFulfillmentPickingLine(
        dmpl__InventoryFulfillment__c fulfillment,
        dmpl__Item__c item,
        dmpl__InventoryFulfillmentAllocationLine__c fulfillmentAllocationLine
    ){
        return (dmpl__InventoryFulfillmentPickingLine__c) TestFactory.createSObject(
            new dmpl__InventoryFulfillmentPickingLine__c(
                dmpl__FulfillmentOrderId__c = fulfillment.Id,
                dmpl__ItemId__c = item.Id,
                dmpl__FulfillmentAllocationLineId__c = fulfillmentAllocationLine.Id
            ),
           'FulfillmentPickingLineDefaults',
            true
        );
    }

    public static dmpl__InventoryFulfillmentPickingLine__c createFulfillmentPickingLine(
        dmpl__InventoryFulfillment__c fulfillment,
        dmpl__Item__c item,
        dmpl__InventoryFulfillmentAllocationLine__c fulfillmentAllocationLine,
        Decimal quantity,
        Decimal unitCost,
        Decimal requestedQuantity
    ){
        return (dmpl__InventoryFulfillmentPickingLine__c) TestFactory.createSObject(
            new dmpl__InventoryFulfillmentPickingLine__c(
                dmpl__FulfillmentOrderId__c = fulfillment.Id,
                dmpl__ItemId__c = item.Id,
                dmpl__FulfillmentAllocationLineId__c = fulfillmentAllocationLine.Id,
                dmpl__Quantity__c = quantity,
                dmpl__UnitCost__c = unitCost,
                dmpl__RequestedQuantity__c =requestedQuantity,
                dmpl__DocumentDate__c = Date.today()
            ),
           'FulfillmentPickingLineDefaults',
            true
        );
    } public static dmpl__InventoryFulfillmentPickingLine__c createFulfillmentPickingLine(
        dmpl__InventoryFulfillment__c fulfillment,
        dmpl__Item__c item,
        dmpl__InventoryFulfillmentAllocationLine__c fulfillmentAllocationLine,
        dmpl__StorageLocation__c storageLocation,
        Decimal quantity,
        Decimal unitCost,
        Decimal requestedQuantity,
        dmpl__SKU__c sku
    ){
        return (dmpl__InventoryFulfillmentPickingLine__c) TestFactory.createSObject(
            new dmpl__InventoryFulfillmentPickingLine__c(
                dmpl__FulfillmentOrderId__c = fulfillment.Id,
                dmpl__ItemId__c = item.Id,
                dmpl__FulfillmentAllocationLineId__c = fulfillmentAllocationLine.Id,
                dmpl__Quantity__c = quantity,
                dmpl__UnitCost__c = unitCost,
                dmpl__RequestedQuantity__c =requestedQuantity,
                dmpl__SKUId__c = sku?.Id??null,
                dmpl__StorageLocationId__c = storageLocation?.Id??null,
                dmpl__DocumentDate__c = Date.today()
            ),
           'FulfillmentPickingLineDefaults',
            true
        );
    }
    
    public static dmpl__InventoryFulfillmentPickingLine__c createFulfillmentPickingLine(
        dmpl__InventoryFulfillment__c fulfillment,
        dmpl__InventoryFulfillmentAllocationLine__c fulfillmentAllocationLine,
        dmpl__Item__c item,
        Decimal unitCost,
        Decimal requestedQuantity,
        Decimal quantity,
        dmpl__SaleOrderLine__c saleOrderLine
    ){
        return (dmpl__InventoryFulfillmentPickingLine__c) TestFactory.createSObject(
            new dmpl__InventoryFulfillmentPickingLine__c(
                dmpl__FulfillmentOrderId__c = fulfillment.Id,
                dmpl__ItemId__c = item.Id,
                dmpl__UnitCost__c = unitCost,
                dmpl__FulfillmentAllocationLineId__c = fulfillmentAllocationLine.Id,
                dmpl__Quantity__c = quantity,
                dmpl__RequestedQuantity__c =requestedQuantity,
                dmpl__StorageLocationId__c = null,
                dmpl__ReturnedQuantity__c=0,
                dmpl__SKUId__c = null,
                dmpl__DocumentDate__c = Date.today()
            ),
           'FulfillmentPickingLineDefaults',
            true
        );
    }
    

    public static dmpl__InventoryFulfillmentPickingLine__c getFulfillmentPickingLine() {
        return [SELECT 
            Id, 
            Name, 
            dmpl__FulfillmentOrderId__c, 
            dmpl__IsILPosted__c,
            dmpl__UnitCost__c,
            dmpl__ItemId__c,
            dmpl__DocumentDate__c,
            dmpl__FulfillmentAllocationLineId__c,
            dmpl__Quantity__c
        FROM dmpl__InventoryFulfillmentPickingLine__c LIMIT 1];
    }
    public static dmpl__InventoryFulfillmentPickingLine__c getFulfillmentPickingLine(Id fulfillmentPickingLineId) {
        return [SELECT 
            Id, 
            Name, 
            dmpl__FulfillmentOrderId__c,  
            dmpl__IsILPosted__c,
            dmpl__UnitCost__c,
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__PickedQuantity__c,
            dmpl__StorageLocationId__c,
            dmpl__RequestedQuantity__c,
            dmpl__DocumentDate__c,
            dmpl__FulfillmentAllocationLineId__c,
            dmpl__Quantity__c
        FROM dmpl__InventoryFulfillmentPickingLine__c where Id=:fulfillmentPickingLineId LIMIT 1];
    }

   public static dmpl__SaleOrderLine__c createSaleOrderLine(
        dmpl__SaleOrder__c saleOrder,
        dmpl__Item__c item,
        dmpl__SKU__c sku,
        dmpl__TaxGroup__c taxGroup
    ) {
        return (dmpl__SaleOrderLine__c) TestFactory.createSObject(
            new dmpl__SaleOrderLine__c(dmpl__SaleOrderId__c = saleOrder.Id,
                                                     dmpl__ItemId__c = item.Id,
                                                     dmpl__SKUId__c = sku.Id,
                                                     dmpl__Quantity__c = 15,
                                                     dmpl__TaxGroupId__c = taxGroup.Id,
                                                     dmpl__Discount__c = 5,
                                                     dmpl__FulfilmentOrderQuantity__c = 1, 
                                                     dmpl__CancelledQuantity__c= 1,
                                                     dmpl__FulfilmentAllocatedQuantity__c = 1,
                                                     dmpl__OTCInvoicedQuantity__c=  1
                                                    ),
                                                    
            true
        );
    }

    public static dmpl__SaleOrderLine__c getSaleOrderLine(Id saleOrderLineId){
        return [SELECT 
            Id, 
            Name, 
            dmpl__ItemId__c, 
            dmpl__SKUId__c, 
            dmpl__SaleOrderId__c, 
            dmpl__Quantity__c, 
            dmpl__TaxGroupId__c, 
            dmpl__Discount__c,
            dmpl__FulfilmentOrderQuantity__c,
            dmpl__OTCInvoicedQuantity__c,
            dmpl__CancelledQuantity__c
        FROM dmpl__SaleOrderLine__c where Id= :saleOrderLineId LIMIT 1];
    }

    //Start from here

    

    //new start


    public static dmpl__InventoryFulfillmentOrderLine__c createInventoryFulfillmentOrderLine(
        dmpl__InventoryFulfillment__c inventoryFulfillment,
        dmpl__Item__c item,
        Decimal quantity,
        //Decimal pendingAllocationQuantity,
        Decimal unitCost,
        dmpl__StorageLocation__c storageLocation,
        dmpl__ItemLot__c itemLot,
        dmpl__SKU__c sku,
        dmpl__SaleOrderLine__c saleOrderLine,
        dmpl__RepairOrderLine__c repairOrderLine
    ) {
        return (dmpl__InventoryFulfillmentOrderLine__c) TestFactory.createSObject(
             new dmpl__InventoryFulfillmentOrderLine__c(
                    dmpl__FulfillmentId__c     = inventoryFulfillment != null ? inventoryFulfillment.Id : null,
                    dmpl__ItemId__c            = item != null ? item.Id : null,
                    dmpl__Quantity__c          = quantity ?? 0,
                    //dmpl__PendingAllocationQuantity__c = pendingAllocationQuantity ?? 0,
                    dmpl__UnitCost__c          = unitCost ?? null,
                    dmpl__StorageLocationId__c= storageLocation != null ? storageLocation.Id : null,
                    dmpl__ItemLotId__c         = itemLot != null ? itemLot.Id : null,
                    dmpl__SKUId__c             = sku != null ? sku.Id : null,
                    dmpl__SaleOrderLineId__c   = saleOrderLine != null ? saleOrderLine.Id : null,
                    dmpl__RepairOrderLineId__c   = repairOrderLine != null ? repairOrderLine.Id : null
            ),
           // 'FulfillmentOrderLineDefaults',
            true
        );
    }

    public static dmpl__InventoryFulfillment__c createInventoryFulfillmentWithAllValues(
        Account partnerAccount,
        Account customerAccount,
        dmpl__Branch__c branch,
        dmpl__RepairOrder__c repairOrder,
        dmpl__SaleOrder__c saleOrder,
        Date documentDate,
        String status
    ) {
        return (dmpl__InventoryFulfillment__c) TestFactory.createSObject(
            new dmpl__InventoryFulfillment__c(
                dmpl__PartnerAccountId__c = partnerAccount != null ? partnerAccount.Id : null,
                dmpl__AccountId__c  = customerAccount != null ? customerAccount.Id : null,
                dmpl__BranchId__c  = branch != null ? branch.Id : null,
                dmpl__RepairOrderId__c = repairOrder != null ? repairOrder.Id : null,
                dmpl__SaleOrderId__c = saleOrder != null ? saleOrder.Id : null,
                dmpl__DocumentDate__c = documentDate,
                dmpl__Status__c = status
            ),
            //'FulfillmentDefaults',
            true
        );
    }

public static dmpl__RepairOrder__c createRepairOrder(
        Account partnerAccount,
        dmpl__Branch__c branch,
        Account customerAccount,
        Asset asset,
        Decimal usageReading
    ){
        return (dmpl__RepairOrder__c)TestFactory.createSObject(
            new dmpl__RepairOrder__c(
                dmpl__BranchId__c = branch.Id,
                dmpl__AccountId__c = customerAccount.Id,
                dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                dmpl__AssetId__c = asset.Id,
                dmpl__UsageReading__c = usageReading
            ),
           //'RepairOrderDefaults',
            true
        );
    }

    public static dmpl__RepairOrder__c getRepairOrderById(Id repairOrderId) {
        return [
            SELECT Id,
            	dmpl__AccountName__c,
                dmpl__BranchId__c,
                dmpl__AccountId__c,
                dmpl__PartnerAccountId__c,
                dmpl__AssetId__c,
                dmpl__UsageReading__c,
                dmpl__BillingAddress__c,
                dmpl__BillingStreet__c,
                dmpl__BillingCity__c,
                dmpl__BillingState__c,
                dmpl__BillingCountry__c,
                dmpl__BillingPostalCode__c,
                dmpl__DocumentDate__c,
                dmpl__Status__c,
                dmpl__PriceListId__r.Name,
                dmpl__AccountId__r.Name,
                dmpl__TaxSupplyType__c
            FROM dmpl__RepairOrder__c
            WHERE Id = :repairOrderId
            LIMIT 1
        ];
    }



    public static dmpl__RepairOrderLine__c createRepairOrderLine(
        dmpl__RepairOrder__c repairOrder,
        dmpl__Item__c item,
        Decimal quantity
    ) {
        
        return (dmpl__RepairOrderLine__c) TestFactory.createSObject(
            new dmpl__RepairOrderLine__c(
                dmpl__ItemId__c = item.Id,   
                dmpl__RepairOrderId__c = repairOrder.Id,
                dmpl__Quantity__c = quantity
            ),
            true
        );
    }
    
    public static dmpl__RepairOrderLine__c createRepairOrderLine(
        dmpl__RepairOrder__c repairOrder,
        dmpl__Item__c item,
        Decimal quantity,
        Decimal unitPrice
    ) {
        
        return (dmpl__RepairOrderLine__c) TestFactory.createSObject(
            new dmpl__RepairOrderLine__c(
                dmpl__ItemId__c = item.Id,   
                dmpl__RepairOrderId__c = repairOrder.Id,
                dmpl__Quantity__c = quantity,
                dmpl__UnitPrice__c = unitPrice
            ),
            true
        );
    }
    public static dmpl__RepairOrder__c getRepairOrder(Id repairOrderId) {
        return [
            SELECT Id,
                dmpl__BranchId__c,
                dmpl__AccountId__c,
                dmpl__PartnerAccountId__c,
                dmpl__AssetId__c,
                dmpl__UsageReading__c,
                dmpl__BillingAddress__c,
                dmpl__BillingStreet__c,
                dmpl__BillingCity__c,
                dmpl__BillingState__c,
                dmpl__BillingCountry__c,
                dmpl__BillingPostalCode__c,
                dmpl__DocumentDate__c,
                dmpl__Status__c,
                dmpl__PriceListId__r.Name,
                dmpl__AccountId__r.Name,
                dmpl__TaxSupplyType__c
            FROM dmpl__RepairOrder__c
            WHERE Id = :repairOrderId
            LIMIT 1
        ];
    }



    public static dmpl__RepairOrderLine__c getRepairOrderLineById(Id repairOrderLineId) {
        return [
            SELECT Id,
                dmpl__ItemId__c,
                dmpl__RepairOrderId__c,
                dmpl__Quantity__c,
                dmpl__UnitPrice__c,
                dmpl__Tax1__c,
                dmpl__Tax1Name__c,
                dmpl__Tax1Rate__c,
                dmpl__Tax1Type__c,
                dmpl__Tax2__c,
                dmpl__Tax2Name__c,
                dmpl__Tax2Rate__c,
                dmpl__Tax2Type__c,
                dmpl__BaseAmount__c,
                dmpl__NetSchemeDiscount__c,
                dmpl__NetDiscount__c,
                dmpl__TaxAmount__c,
                dmpl__GrossAmount__c
            FROM dmpl__RepairOrderLine__c
            WHERE Id = :repairOrderLineId
            LIMIT 1
        ];
    }
    
    public static dmpl__RepairOrderLine__c getRepairOrderLine(Id repairOrderLineId) {
        return [
            SELECT Id,
                dmpl__Amount__c	,
                dmpl__ItemId__c,
                dmpl__RepairOrderId__c,
                dmpl__Quantity__c,
                dmpl__UnitPrice__c,
                dmpl__Tax1__c,
                dmpl__Tax1Name__c,
                dmpl__Tax1Rate__c,
                dmpl__Tax1Type__c,
                dmpl__Tax2__c,
                dmpl__Tax2Name__c,
                dmpl__Tax2Rate__c,
                dmpl__Tax2Type__c,
                dmpl__BaseAmount__c,
                dmpl__NetSchemeDiscount__c,
                dmpl__NetDiscount__c,
                dmpl__TaxAmount__c,
                dmpl__GrossAmount__c,
                dmpl__ClaimableQuantity__c,
                dmpl__dmpl_PendingInvoiceQuantity__c,
            	dmpl__PendingDeliveryOrder__c,
            	dmpl__PendingFulfilmentAllocationQuantity__c,
            	dmpl__PendingFulfilmentOrderQuantity__c,
            	dmpl__PostingType__c,
            	dmpl__ServiceContractWeightage__c,
                dmpl__PartnerAccountId__c,
                dmpl__BranchId__c
            FROM dmpl__RepairOrderLine__c
            WHERE dmpl__RepairOrderId__c = :repairOrderLineId
            LIMIT 1
        ];
    }

    public static dmpl__StorageLocation__c createStorageLocation(
        String name,
        dmpl__Branch__c branch,
        Boolean isActive,
        String locationType
    ) {
        return (dmpl__StorageLocation__c) TestFactory.createSObject(
            new dmpl__StorageLocation__c(
                Name = name,
                dmpl__BranchId__c = branch.Id,
                dmpl__IsActive__c = isActive,
                dmpl__LocationType__c = locationType
                
            ),
          //  'StorageLocationDefaults',
            true
        );
    }

    public static dmpl__StorageLocation__c getStorageLocation(String name) {
        return [
            SELECT Id, Name, dmpl__BranchId__c, dmpl__IsActive__c
            FROM dmpl__StorageLocation__c
            WHERE Name = :name
            LIMIT 1
        ];
    }

    public static dmpl__SaleOrder__c createSaleOrder( 
        Account partnerAccount,
        dmpl__Branch__c branch,
        Account customerAccount
        
    ) {
        return (dmpl__SaleOrder__c) TestFactory.createSObject(
            new dmpl__SaleOrder__c(
                dmpl__AccountId__c         = customerAccount.Id,
                dmpl__PartnerAccountId__c  = partnerAccount.Id,
                dmpl__BranchId__c = branch.Id,
                dmpl__AccountName__c = customerAccount.Name,
                dmpl__DocumentDate__c = Date.today()
            ),
            'SaleOrderDefaults',
            true
        );
    }
    
    public static dmpl__SaleOrder__c createSaleOrder(
        Id customerAccountId,
        Id partnerAccountId, 
        Id branchId,
        Id billingAddressId,
        Id shippingAddressId,
        Boolean skipScheme,
        Id resourceId
    ) {
        return (dmpl__SaleOrder__c) TestFactory.createSObject(
            new dmpl__SaleOrder__c(
                dmpl__PartnerAccountId__c = partnerAccountId,
                dmpl__BranchId__c = branchId,
                dmpl__AccountId__c = customerAccountId,
                dmpl__ShippingAddressId__c = shippingAddressId,
                dmpl__BillingAddressId__c =  billingAddressId,
                dmpl__SkipScheme__c = skipScheme,
                dmpl__SalesExecutiveId__c = resourceId
            ),
            //'SaleOrderDefaults',
            true
        );
    }

    public static dmpl__SaleOrderLine__c createSaleOrderLine(
        dmpl__SaleOrder__c saleOrder,
        dmpl__Item__c item,
        Decimal quantity
    ) {
        return (dmpl__SaleOrderLine__c) TestFactory.createSObject(
            new dmpl__SaleOrderLine__c(
                dmpl__SaleOrderId__c        = saleOrder.Id,
                dmpl__ItemId__c             = item.Id,            
                dmpl__Quantity__c           = quantity
            ),
            //'SaleOrderLineDefaults',
            true
        );
    }

    public static dmpl__InventoryFulfillmentOrderLine__c createFulfillmentOrderLine(
        dmpl__InventoryFulfillment__c inventoryFulfillment,
        dmpl__Item__c item,
        Decimal quantity,
        Decimal unitCost,
        dmpl__StorageLocation__c storageLocation,
        dmpl__ItemLot__c itemLot,
        dmpl__SKU__c sku,
        dmpl__SaleOrderLine__c saleOrderLine,
        dmpl__RepairOrderLine__c repairOrderLine
    ) {
        return (dmpl__InventoryFulfillmentOrderLine__c) TestFactory.createSObject(
            new dmpl__InventoryFulfillmentOrderLine__c(
                dmpl__FulfillmentId__c = inventoryFulfillment.Id,
                dmpl__ItemId__c = item.Id,
                dmpl__Quantity__c = quantity,
                dmpl__UnitCost__c = unitCost,
                dmpl__StorageLocationId__c = storageLocation != null ? storageLocation.Id : null,
                dmpl__ItemLotId__c = itemLot != null ? itemLot.Id : null,
                dmpl__SKUId__c = sku != null ? sku.Id : null,
                dmpl__SaleOrderLineId__c = saleOrderLine != null ? saleOrderLine.Id : null,
                dmpl__RepairOrderLineId__c = repairOrderLine != null ? repairOrderLine.Id : null
            ),
           // 'FulfillmentOrderLineDefaults',
            true
        );
    }

    public static dmpl__SaleOrder__c getSaleOrder(Account customer, dmpl__Branch__c branch) {
        return [
            SELECT Id, Name 
            FROM dmpl__SaleOrder__c 
            WHERE dmpl__AccountId__c = :customer.Id 
            AND dmpl__BranchId__c = :branch.Id 
            LIMIT 1
        ];
    }
    public static dmpl__SaleOrder__c getSaleOrder(Id saleOrderId) {
        return [
            SELECT Id, Name, dmpl__AccountId__c, dmpl__BranchId__c, dmpl__Status__c, 
                    dmpl__DocumentDate__c, dmpl__PriceListId__c, dmpl__TaxSupplyType__c,
                    dmpl__BillingStreet__c, dmpl__BillingCity__c, dmpl__BillingState__c,
                    dmpl__BillingCountry__c, dmpl__BillingPostalCode__c, dmpl__LineSubTotal__c,
                    dmpl__TotalLineBaseAmount__c, dmpl__TotalSchemeDiscountAmount__c,
                    dmpl__TotalDiscountAmount__c, dmpl__TotalLineTaxAmount__c,
                    dmpl__TotalTaxAmount__c, dmpl__TotalLineGrossAmount__c,
                    dmpl__OpenAmount__c, dmpl__OutstandingAmount__c, dmpl__AccountName__c
            FROM dmpl__SaleOrder__c
            WHERE Id = :saleOrderId
            LIMIT 1
        ];
    }

    public static dmpl__SaleOrderLine__c getSaleOrderLine(dmpl__SaleOrder__c saleOrder, dmpl__Item__c item, dmpl__SKU__c sku) {
        return [
            SELECT Id, Name 
            FROM dmpl__SaleOrderLine__c 
            WHERE dmpl__SaleOrderId__c = :saleOrder.Id 
            AND dmpl__ItemId__c = :item.Id 
            AND dmpl__SKUId__c = :sku.Id 
            LIMIT 1
        ];
    }

    public static dmpl__RepairOrder__c createRepairOrderWithValues(
        Account partner, 
        Account customer, 
        dmpl__Branch__c branch,
        Asset asset, 
        Id priceListId, 
        // Id taxGroupId, 
        Id billingAddressId,
        Decimal usageReading, 
        Date documentDate, 
        String status
    ) {
        return (dmpl__RepairOrder__c) TestFactory.createSObject(
            new dmpl__RepairOrder__c(
                dmpl__PartnerAccountId__c = partner.Id,
                dmpl__AccountId__c = customer.Id,
                dmpl__BranchId__c = branch.Id,
                dmpl__AssetId__c = asset.Id,
                dmpl__PriceListId__c = priceListId,
                // dmpl__TaxGroup__c = taxGroupId,
                dmpl__BillingAddress__c = billingAddressId,
                dmpl__UsageReading__c = usageReading,
                dmpl__TaxSupplyType__c = 'Within State',
                dmpl__BillingStreet__c = 'Ring Rd',
                dmpl__BillingCity__c = 'Pune',
                dmpl__BillingState__c = 'Maharashtra',
                dmpl__BillingCountry__c = 'India',
                dmpl__BillingPostalCode__c = '440001',
                dmpl__DocumentDate__c = documentDate,
                dmpl__Status__c = status
            ),
            //'RepairOrderDefaults.WithValues',
            true
        );
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

    public static Asset getAsset(String name){ 
        return [
            SELECT Id, name, AccountId, dmpl__ItemId__c, dmpl__SaleDate__c 
				FROM Asset 
				WHERE name = :name LIMIT 1
        ];
    }
}