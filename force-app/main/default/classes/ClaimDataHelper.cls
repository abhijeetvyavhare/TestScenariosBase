public with sharing class ClaimDataHelper {
    public static dmpl__Claim__c createClaim(Id partnerAccountId){
        return (dmpl__Claim__c) TestFactory.createSObject(
            new dmpl__Claim__c(
                dmpl__Status__c = 'Draft',
                dmpl__DocumentDate__c = Date.today(),
                dmpl__ClaimType__c = 'Damaged',
                dmpl__InvoiceGroup__c = 'Service',
                dmpl__Remarks__c = 'Test Claim',
                dmpl__ApproveAll__c = true,
                dmpl__RejectAll__c = false,
                dmpl__AsOnDate__c = Date.today(),
                dmpl__ServiceInvoiceAsOnDate__c = Date.today(),
                dmpl__WorkOrderAsonDate__c = Date.today().addDays(-5),
                dmpl__PartnerAccountId__c = partnerAccountId
            ),
            //'ClaimDefaults',
            true
        );
    }
    
    public static dmpl__Claim__c getClaims(){
        return [
            SELECT Id, Name, dmpl__ExternalId__c, dmpl__Status__c, dmpl__DocumentDate__c, 
                   dmpl__ClaimType__c, dmpl__InvoiceGroup__c, dmpl__Remarks__c, dmpl__ApproveAll__c,
                   dmpl__RejectAll__c, dmpl__AsOnDate__c, dmpl__ServiceInvoiceAsOnDate__c,
                   dmpl__WorkOrderAsonDate__c
            FROM dmpl__Claim__c
            LIMIT 1
        ];
    }

    public static dmpl__Claim__c getClaims(Id claimId) {
        return [
            SELECT Id, Name, dmpl__ExternalId__c, dmpl__Status__c, dmpl__DocumentDate__c, 
                   dmpl__ClaimType__c, dmpl__InvoiceGroup__c, dmpl__Remarks__c, dmpl__ApproveAll__c,
                   dmpl__RejectAll__c, dmpl__AsOnDate__c, dmpl__ServiceInvoiceAsOnDate__c,
                   dmpl__WorkOrderAsonDate__c
            FROM dmpl__Claim__c
            WHERE Id = :claimId
            LIMIT 1
        ];
    }

    public static dmpl__ClaimLine__c createClaimLine(
        Id claimId
    ){
        return (dmpl__ClaimLine__c) TestFactory.createSObject(
            new dmpl__ClaimLine__c(
                dmpl__ClaimId__c = claimId,
                dmpl__ClaimType__c = 'Part To Part',
                dmpl__Status__c = 'Approved',
                dmpl__UnitPrice2__c = 1000,
                dmpl__UnitPrice__c = 900
            ),
            //'ClaimLineDefaults',
            true
        );
    }

    public static dmpl__ClaimLine__c getClaimLines() {
        return [
            SELECT Id, Name, dmpl__ExternalId__c, dmpl__Status__c, dmpl__ClaimType__c,
                   dmpl__ItemCode__c, dmpl__UnitPrice2__c, dmpl__UnitPrice__c,
                   dmpl__ApproveAmount__c, dmpl__ApproveBaseAmount__c, dmpl__ApproveDiscount__c,
                   dmpl__ApproveDiscountAmount__c, dmpl__ApproveNetDiscount__c, dmpl__ApproveQuantity__c,
                   dmpl__BaseAmount__c, dmpl__ClaimAmount__c, dmpl__ClaimQuantity__c,dmpl__RepairOrderLineId__c,
                   dmpl__Discount__c, dmpl__DiscountAmount__c, dmpl__NetDiscount__c
            FROM dmpl__ClaimLine__c
            LIMIT 1
        ];
    }

    public static dmpl__ClaimLine__c getClaimLines(Id claimLineId) {
        return [
            SELECT Id, Name, dmpl__ExternalId__c, dmpl__Status__c, dmpl__ClaimType__c,
                dmpl__ItemCode__c, dmpl__UnitPrice2__c, dmpl__UnitPrice__c,
                dmpl__ApproveAmount__c, dmpl__ApproveBaseAmount__c, dmpl__ApproveDiscount__c,
                dmpl__ApproveDiscountAmount__c, dmpl__ApproveNetDiscount__c, dmpl__ApproveQuantity__c,
                dmpl__BaseAmount__c, dmpl__ClaimAmount__c, dmpl__ClaimQuantity__c,dmpl__ServiceContractId__c,
                dmpl__Discount__c, dmpl__DiscountAmount__c, dmpl__NetDiscount__c,dmpl__RepairOrderLineId__c,
                dmpl__ItemId__c, dmpl__ClaimId__c, dmpl__GoodsReceiptId__c,
                dmpl__GoodsReceiptLineId__c, dmpl__ClaimBatchId__c
            FROM dmpl__ClaimLine__c
            WHERE Id = :claimLineId
            LIMIT 1
        ];
    }


    //NewScenarios

     
   public static dmpl__Claim__c createClaim(
        Id partnerAccountId,
        Id branchId,
        Id supplierAccountId,
        String claimType,
        String status,
        Id saleInvoiceId,
        Id billReturnId,
        Id repairOrderId,
        Id goodsReceiptId,
        Id purchaseReturnId
    ) {
        return (dmpl__Claim__c) TestFactory.createSObject(
            new dmpl__Claim__c(
                dmpl__PartnerAccountId__c = partnerAccountId,
                dmpl__BranchId__c = branchId,
                dmpl__SupplierNameId__c = supplierAccountId,
                dmpl__ClaimType__c = claimType,
                dmpl__Status__c = status,
                dmpl__DocumentDate__c = Date.today(),
                dmpl__SaleInvoiceId__c = saleInvoiceId,
                dmpl__BillReturnId__c = billReturnId,
                dmpl__RepairOrderId__c = repairOrderId,
                dmpl__GoodsReceiptId__c = goodsReceiptId,
                dmpl__PurchaseReturnId__c = purchaseReturnId 
            ),
           // 'ClaimDefaults',
            true
        );
    }

    public static dmpl__Claim__c createClaimWithServiceContract(
        Id partnerAccountId,
        Id branchId,
        Id supplierAccountId,
        String claimType,
        String status,
        Id itemServiceContractId
    ) {
        return (dmpl__Claim__c) TestFactory.createSObject(
            new dmpl__Claim__c(
                dmpl__PartnerAccountId__c       = partnerAccountId,
                dmpl__BranchId__c               = branchId,
                dmpl__SupplierNameId__c         = supplierAccountId,
                dmpl__ClaimType__c              = claimType,
                dmpl__Status__c                 = status,
                dmpl__DocumentDate__c           = Date.today(),
                dmpl__ItemServiceContractId__c  = itemServiceContractId
            ),
            //'ClaimDefaults',
            true
        );
    }

    public static dmpl__Claim__c getClaim(Id claimId) {
        return [
            SELECT Id, Name, dmpl__Status__c, dmpl__DocumentDate__c,
                dmpl__ClaimType__c, dmpl__PartnerAccountId__c, dmpl__PartnerAccountId__r.Name,
                dmpl__BranchId__c, dmpl__BranchId__r.Name,
                dmpl__SupplierNameId__c, dmpl__SupplierNameId__r.Name,
                dmpl__SaleInvoiceId__c, dmpl__BillReturnId__c,
                dmpl__RepairOrderId__c, dmpl__GoodsReceiptId__c,dmpl__TotalApprovedQuantity__c,
                dmpl__PurchaseReturnId__c, dmpl__TotalAmount__c,dmpl__TotalApprovedAmount__c,
                dmpl__ItemServiceContractId__c
            FROM dmpl__Claim__c
            WHERE Id = :claimId
            LIMIT 1
        ];
    }

    public static dmpl__ClaimLine__c createClaimLine(
        Id claimId,
        Id itemId,
        Decimal claimQuantity,
        Decimal approveQuantity,
        Decimal unitPrice,
        String claimType,
        Id goodsReceiptId,
        Id goodsReceiptLineId,
        Id claimBatchId,
        Id repairOrderLineId
    ) {
        return (dmpl__ClaimLine__c) TestFactory.createSObject(
            new dmpl__ClaimLine__c(
                dmpl__ClaimId__c             = claimId,
                dmpl__ItemId__c              = itemId,
                dmpl__ClaimQuantity__c       = claimQuantity,
                dmpl__ApproveQuantity__c     = approveQuantity,
                dmpl__UnitPrice__c           = unitPrice,
                dmpl__ClaimType__c           = claimType,
                dmpl__GoodsReceiptId__c      = goodsReceiptId,
                dmpl__GoodsReceiptLineId__c  = goodsReceiptLineId,
                dmpl__ClaimBatchId__c        = claimBatchId,
                dmpl__RepairOrderLineId__c     = repairOrderLineId ?? null
            ),
           // 'ClaimLineDefaults',
            true
        );
    }

    public static dmpl__ClaimLine__c createClaimLineWithRepairOrder(
        Id claimId,
        Id itemId,
        Decimal claimQuantity,
        Decimal approveQuantity,
        Decimal unitPrice,
        String claimType,
        Id RrepairOrderId,
        Id repairOrderLineId
    ) {
        return (dmpl__ClaimLine__c) TestFactory.createSObject(
            new dmpl__ClaimLine__c(
                dmpl__ClaimId__c             = claimId,
                dmpl__ItemId__c              = itemId,
                dmpl__ClaimQuantity__c       = claimQuantity,
                dmpl__ApproveQuantity__c     = approveQuantity,
                dmpl__UnitPrice__c           = unitPrice,
                dmpl__ClaimType__c           = claimType,
                dmpl__RepairOrderId__c      = RrepairOrderId,
                dmpl__RepairOrderLineId__c     = repairOrderLineId ?? null
            ),
           // 'ClaimLineDefaults',
            true
        );
    }

  public static dmpl__ClaimLine__c createClaimLinewithGoodsRecieptLine(
    Id claimId,
    Id itemId,
    Decimal claimQuantity,
    Decimal approveQuantity,
    Id goodsReceiptId,
    Id goodsReceiptLineId
) {
    return (dmpl__ClaimLine__c) TestFactory.createSObject(
        new dmpl__ClaimLine__c(
            dmpl__ClaimId__c             = claimId,
            dmpl__ItemId__c              = itemId,
            dmpl__ClaimQuantity__c       = claimQuantity,
            dmpl__ApproveQuantity__c     = approveQuantity,
            dmpl__GoodsReceiptId__c      = goodsReceiptId,
            dmpl__GoodsReceiptLineId__c  = goodsReceiptLineId,
            dmpl__UnitPrice__c           = 1500 
        ),
       // 'ClaimLineDefaults',
        true
    );
}


    public static dmpl__ClaimLine__c getClaimLineById(Id claimLineId) {
    List<dmpl__ClaimLine__c> results = [
        SELECT Id, dmpl__UnitPrice__c, dmpl__ClaimQuantity__c, dmpl__BaseAmount__c,dmpl__ClaimId__c,dmpl__ClaimType__c,
               dmpl__ApproveQuantity__c, dmpl__ClaimAmount__c, dmpl__ApproveAmount__c,
               dmpl__ApproveBaseAmount__c
        FROM dmpl__ClaimLine__c
        WHERE Id = :claimLineId
    ];
    return results.isEmpty() ? null : results[0];
}



    public static dmpl__PurchaseReturn__c createPurchaseRetrun(
        Account supplierAccount,
        Account partnerAccount,
        dmpl__Branch__c branch
    ) {
        return (dmpl__PurchaseReturn__c) TestFactory.createSObject(
            new dmpl__PurchaseReturn__c(
                dmpl__SupplierAccountId__c = supplierAccount.Id,
                dmpl__BranchId__c = branch.Id,
                dmpl__Status__c = '1',
                dmpl__PartnerAccountId__c = partnerAccount.Id,
                dmpl__SupplierInvoiceDate__c = date.today(),
                dmpl__PerformReturn__c = false,
                dmpl__IsReturned__c = false,
                dmpl__PerformInventoryPosting__c=false,
                dmpl__DocumentDate__c = date.today()
            ),
            //'PurchaseReturnDefaults',
            true
        );
    }

    public static dmpl__RepairOrder__c createRepairOrder(
        Account partnerAccount,
        dmpl__Branch__c branch,
        Account customerAccount,
        Decimal usageReading
    ){
        return (dmpl__RepairOrder__c)TestFactory.createSObject(
            new dmpl__RepairOrder__c(
                dmpl__BranchId__c = branch.Id,
                dmpl__AccountId__c = customerAccount.Id,
                dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                dmpl__UsageReading__c = usageReading,
                dmpl__DocumentDate__c = Date.today(),
                dmpl__Status__c = 'Draft'
            ),
            //'RepairOrderDefaults',
            true
        );
    }

    public static dmpl__RepairOrderLine__c createRepairOrderLine(
        dmpl__RepairOrder__c repairOrder,
        dmpl__Item__c item,
        dmpl__TaxGroup__c taxGroup,
        Decimal quantity,
        Decimal unitPrice
     
    ) {
        return (dmpl__RepairOrderLine__c) TestFactory.createSObject(
            new dmpl__RepairOrderLine__c(
                dmpl__RepairOrderId__c = repairOrder.Id,
                dmpl__ItemId__c = item.Id,
                dmpl__TaxGroupId__c = taxGroup.Id,
                dmpl__Quantity__c = quantity,
                dmpl__UnitPrice__c = unitPrice
            ),
            //'RepairOrderLineDefaults',
            true
        );
    }
    public static dmpl__RepairOrder__c getRepairOrdersById(Id repairOrderId) {
        return [SELECT 
            Id,
            Name,
            dmpl__BranchId__c,
            dmpl__AccountId__c,
            dmpl__PartnerAccountId__c,
            dmpl__AssetId__c,
            dmpl__ServiceEstimateId__c,
            dmpl__ServiceAdvisorId__c,
            dmpl__UsageReading__c,
            dmpl__AccountName__c,
            dmpl__PriceListId__c,
            dmpl__PriceListId__r.Name,
            dmpl__TaxGroupId__c,
            dmpl__TaxGroupId__r.Name,
            dmpl__TaxSupplyType__c,
            dmpl__Status__c,
            dmpl__DocumentDate__c,
            dmpl__BillingAddress__c,
            dmpl__BillingStreet__c,
            dmpl__BillingCity__c,
            dmpl__BillingState__c,
            dmpl__BillingCountry__c,
            dmpl__BillingPostalCode__c,
            dmpl__ShippingAddress__c,
            dmpl__ShippingStreet__c,
            dmpl__ShippingCity__c,
            dmpl__ShippingState__c,
            dmpl__ShippingPostalCode__c,
            dmpl__ShippingCountry__c
        FROM dmpl__RepairOrder__c 
        WHERE Id = :repairOrderId
        LIMIT 1
        ];
    }

    public static dmpl__RepairOrderLine__c getRepairOrderLine(Id repairOrderLineId){
        return [SELECT 
            Id,
            Name,
            dmpl__RepairOrderId__c ,
                dmpl__ItemId__c ,
                dmpl__TaxGroupId__c ,
                dmpl__Quantity__c ,
                dmpl__UnitPrice__c 
        FROM dmpl__RepairOrderLine__c 
        WHERE Id = :repairOrderLineId
        LIMIT 1];
    }

    public static dmpl__GoodsReceipt__c createGoodsReceipt(
        Account partnerAccount,
        dmpl__Branch__c branch,
        dmpl__PurchaseOrder__c purchaseOrder,
        Account supplierAccount
        ) {
        return (dmpl__GoodsReceipt__c)TestFactory.createSObject(
            new dmpl__GoodsReceipt__c(
                dmpl__PartnerAccountId__c = partnerAccount.Id,
                dmpl__BranchId__c = branch.Id,
                dmpl__PurchaseOrderId__c = purchaseOrder.Id,
                dmpl__ReceivedTime__c = date.today(),
                dmpl__DocumentDate__c = date.today(),
                dmpl__PerformReceive__c = true,
                dmpl__PerformInspection__c = true,
                dmpl__PerformInspectionComplete__c = true,
                dmpl__IsInspectionCompleted__c = true,
                dmpl__SupplierAccountId__c = supplierAccount.Id,
                dmpl__SupplierInvoiceDate__c = date.today(),
                dmpl__SupplierInvoiceNumber__c = 'Test-SupplierInvoiceNumber',
                dmpl__SupplierDispatchDate__c = date.today(),
                dmpl__TransporterName__c = 'Test-TransporterName',
                dmpl__TransporterRefrenceNumber__c = 'Test-TransporterRefrenceNumber',
                dmpl__TransporterContactNumber__c = '7575555555'
            ),
            //'GoodsReceiptDefaults',
            true
        );
    }

    public static dmpl__GoodsReceipt__c getGoodsReceipt() {
        return [
            SELECT 
                Id, 
                name,
                dmpl__DocumentDate__c,
                dmpl__BranchId__c,
                dmpl__PartnerAccountId__c,
                dmpl__IsClaimed__c,
                dmpl__Status__c,
                dmpl__IsBillGenerated__c,
                dmpl__PerformReceive__c,
                dmpl__IsInspectionCompleted__c,
                dmpl__PerformReceiveAsync__c,
                dmpl__PerformInspection__c,
                dmpl__PerformInspectionComplete__c,
                dmpl__PerformPopulateChecklist__c,
                dmpl__PerformAllocation__c
            FROM dmpl__GoodsReceipt__c 
            LIMIT 1
        ];
    }

    public static dmpl__GoodsReceiptLine__c createGoodReceiptLine(
        dmpl__GoodsReceipt__c GRNDoc,
        dmpl__Item__c item,
        dmpl__SKU__c sku
    ) {
        return (dmpl__GoodsReceiptLine__c)TestFactory.createSObject(
            new dmpl__GoodsReceiptLine__c(
                dmpl__GoodsReceiptId__c = GRNDoc.Id,
                dmpl__ItemId__c = item.Id,
                dmpl__SKUId__c = sku.Id,
                dmpl__OrderedQuantity__c = 1, 
                dmpl__ReceivedQuantity__c = 1,
                dmpl__SupplierQuantity__c = 1
            ),
           // 'GoodReceiptLineDefaults',
            true
        );
    }

    public static dmpl__GoodsReceiptLine__c getGoodReceiptLine() {
        return [
            SELECT 
                Id, 
                name,
                dmpl__PurchaseOrderLineId__r.dmpl__FulfillmentOrderLineId__c,
                dmpl__ItemLotId__c,
                dmpl__ReceivedQuantity__c,
                dmpl__InventoryLedgerId__c,
                dmpl__StorageLocationId__c,
                dmpl__UnitCost__c,
                dmpl__ItemLotTypeId__c,
                dmpl__PurchaseOrderLineId__c,
            	dmpl__OrderedQuantity__c,
                dmpl__SupplierQuantity__c,
                dmpl__InvoiceQuantity__c
            FROM dmpl__GoodsReceiptLine__c 
            LIMIT 1
        ];
    }
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
            //'PurchaseOrderDefaults',
            true
        );
    }

    public static dmpl__ItemServiceContract__c createItemServiceContract(String name ,dmpl__Item__c items) {
        return (dmpl__ItemServiceContract__c) TestFactory.createSObject(
            new dmpl__ItemServiceContract__c(
                dmpl__DateEffectiveFrom__c = date.today(),
                dmpl__DateEffectiveTill__c = date.today() + 7,
                Name=name,
                dmpl__ItemId__c = items.Id,
                dmpl__PopulateContractLines__c = true
            ), 
            true 
        );
    }

    public static dmpl__ItemServiceContract__c getItemServiceContract() {
        return [
            SELECT
                Id,
                dmpl__DateEffectiveFrom__c,
                dmpl__DateEffectiveTill__c,
                dmpl__ItemId__c,
                dmpl__SKUId__c,
                dmpl__PopulateContractLines__c
            FROM dmpl__ItemServiceContract__c LIMIT 1
        ];
    }

   
    //New Method
    public static ServiceContract createServiceContract(
        Account account,
        String contractName
    ) {
        return (ServiceContract) TestFactory.createSObject(
            new ServiceContract(
                Name = contractName,
                AccountId = account != null ? account.Id : null
            ),
            true
        );
    }

    public static Product2 createProduct(
        String name,
        String productCode,
        String family,
        String sku,
        String uom,
        Boolean isActive
    ) {
        return (Product2) TestFactory.createSObject(
            new Product2(
                Name = name,
                ProductCode = productCode,
                Family = family,
                StockKeepingUnit = sku,
                QuantityUnitOfMeasure = uom,
                IsActive = isActive
            ),
            true
        );
    }

    public static dmpl__ClaimBatch__c createClaimBatch(
        Id partnerAccountId,
        Id branchId,
        Id customerAccountId,
        Id serviceContractId
    ) {
        return (dmpl__ClaimBatch__c) TestFactory.createSObject(
            new dmpl__ClaimBatch__c(
                dmpl__PartnerAccountId__c  = partnerAccountId,
                dmpl__BranchId__c          = branchId,
                dmpl__SupplierNameId__c    = customerAccountId,
                dmpl__ServiceContractId__c = serviceContractId != null ? serviceContractId : null
            ),
            //'ClaimBatchDefaults',
            true
        );
    }

    public static dmpl__Claim__c createClaim(
        Id partnerAccountId,
        Id branchId,
        Id supplierAccountId
    ) {
        return (dmpl__Claim__c) TestFactory.createSObject(
            new dmpl__Claim__c(
                dmpl__PartnerAccountId__c  = partnerAccountId,
                dmpl__BranchId__c          = branchId,
                dmpl__SupplierNameId__c    = supplierAccountId
            ),
            //'ClaimDefaults',
            true
        );
    }

    public static dmpl__ClaimLine__c createClaimLine(
        Id claimBatchId,
        Id claimId,
        Id repairOrderLineId,
        Id claimBatchLineId,
        Id goodsReceiptId,
        Id goodsReceiptLineId,
        Id serviceContractId
    ) {
        return (dmpl__ClaimLine__c) TestFactory.createSObject(
            new dmpl__ClaimLine__c(
                dmpl__ClaimBatchId__c       = claimBatchId,
                dmpl__ClaimId__c            = claimId,
                dmpl__RepairOrderLineId__c  = repairOrderLineId,
                dmpl__ClaimBatchLineId__c   = claimBatchLineId,
                dmpl__GoodsReceiptId__c     = goodsReceiptId,
                dmpl__GoodsReceiptLineId__c = goodsReceiptLineId,
                dmpl__ServiceContractId__c  = serviceContractId
            ),
            true
        );
    }

    public static dmpl__RepairOrder__c createRepairOrder(
        Id partnerAccountId,
        Id branchId,
        Id supplierAccountId
    ) {
        return (dmpl__RepairOrder__c) TestFactory.createSObject(
            new dmpl__RepairOrder__c(
                dmpl__PartnerAccountId__c = partnerAccountId,
                dmpl__BranchId__c = branchId,
                dmpl__SupplierAccountId__c = supplierAccountId
            ),
            //'RepairOrderDefaults',
            true
        );
    }

    public static dmpl__RepairOrderLine__c createRepairOrderLine(
        Id repairOrderId,
        Id itemId,
        Decimal unitPrice,
        Decimal quantity
    ) {
        return (dmpl__RepairOrderLine__c) TestFactory.createSObject(
            new dmpl__RepairOrderLine__c(
                dmpl__RepairOrderId__c = repairOrderId,
                dmpl__ItemId__c = itemId,
                dmpl__UnitPrice__c = unitPrice,
                dmpl__Quantity__c = quantity
            ),
            //'RepairOrderLineDefaults',
            true
        );
    }

    public static dmpl__GoodsReceipt__c createGoodsReceipt(
        Id partnerAccountId,
        Id branchId,
        Id supplierId
    ) {
        return (dmpl__GoodsReceipt__c) TestFactory.createSObject(
            new dmpl__GoodsReceipt__c(
                dmpl__PartnerAccountId__c = partnerAccountId,
                dmpl__BranchId__c = branchId,
                dmpl__SupplierAccountId__c = supplierId
            ),
            //'GoodsReceiptDefaults',
            true
        );
    }

    public static dmpl__GoodsReceiptLine__c createGoodsReceiptLine(
        dmpl__GoodsReceipt__c goodsReceipt,
        dmpl__Item__c item,
        Decimal quantity,
        Decimal unitCost
    ) {
        return (dmpl__GoodsReceiptLine__c) TestFactory.createSObject(
            new dmpl__GoodsReceiptLine__c(
                dmpl__GoodsReceiptId__c = goodsReceipt != null ? goodsReceipt.Id : null,
                dmpl__ItemId__c = item != null ? item.Id : null,
                dmpl__ReceivedQuantity__c = quantity != null ? quantity : 1,
                dmpl__UnitCost__c = unitCost != null ? unitCost : 100
            ),
            //'GoodsReceiptLineDefaults',
            true
        );
    }

    public static dmpl__SaleInvoice__c createInvoice(
        Account customer,
        Account partner,
        dmpl__ClaimBatch__c claimBatch,
        Date invoiceDate,
        String billingStreet,
        String billingCity,
        String billingState,
        String billingPostalCode,
        String shippingStreet,
        String shippingCity,
        String shippingState,
        String shippingPostalCode,
        String shippingCountry,
        dmpl__Branch__c branch
    ) {
        return (dmpl__SaleInvoice__c) TestFactory.createSObject(
            new dmpl__SaleInvoice__c(
                dmpl__AccountId__c = customer != null ? customer.Id : null,
                dmpl__AccountName__c = customer != null ? customer.Name : null,
                dmpl__ClaimBatchId__c = claimBatch != null ? claimBatch.Id : null,
                dmpl__DocumentDate__c = invoiceDate != null ? invoiceDate : Date.today(),
                dmpl__PartnerAccountId__c = partner != null ? partner.Id : null,
                dmpl__BranchId__c = branch != null ? branch.Id : null,
                dmpl__BillingStreet__c = billingStreet,
                dmpl__BillingCity__c = billingCity,
                dmpl__BillingState__c = billingState,
                dmpl__BillingPostalCode__c = billingPostalCode,
                dmpl__BillingAddress__c = billingStreet + '\n' + billingCity + ', ' + billingState + ', ' + billingPostalCode,
                dmpl__ShippingStreet__c = shippingStreet,
                dmpl__ShippingCity__c = shippingCity,
                dmpl__ShippingState__c = shippingState,
                dmpl__ShippingPostalCode__c = shippingPostalCode,
                dmpl__ShippingCountry__c = shippingCountry,
                dmpl__ShippingAddress__c = shippingStreet + '\n' + shippingCity + ', ' + shippingState + ', ' + shippingCountry + ', ' + shippingPostalCode
            ),
            // 'SaleInvoiceDefaults',
            true
        );
    }

    public static dmpl__ClaimBatchLine__c createClaimBatchLine(
        Id claimBatchId,
        Id claimId
        ) {
            return (dmpl__ClaimBatchLine__c) TestFactory.createSObject(
                new dmpl__ClaimBatchLine__c(
                    dmpl__ClaimBatchId__c = claimBatchId,
                    dmpl__ClaimId__c = claimId
                ),
                true
            );
        }

        public static dmpl__ClaimLine__c createClaimLineWithServiceContractAndClaimBatch(
            Id claimId,
            Id itemId,
            Decimal claimQuantity,
            Decimal unitPrice,
            Id itemServiceContractId,
            Decimal approveQuantity,
            Id claimBatchId
        ) {
            return (dmpl__ClaimLine__c) TestFactory.createSObject(
                new dmpl__ClaimLine__c(
                    dmpl__ClaimId__c               = claimId,
                    dmpl__ItemId__c                = itemId,
                    dmpl__ClaimQuantity__c         = claimQuantity,
                    dmpl__UnitPrice__c             = unitPrice,
                    dmpl__ServiceContractId__c = itemServiceContractId,
                    dmpl__ApproveQuantity__c = approveQuantity,
                    dmpl__ClaimBatchId__c   = claimBatchId
                ),
                true
            );
        }



}