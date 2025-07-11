@isTest
public class RepairOrderTestDataHelpers {
    public static dmpl__RepairOrder__c createRepairOrder(
        dmpl__Item__c item,
    dmpl__Branch__c branch,
    Asset asset,
    dmpl__Quote__c serviceEstimate,
    Account customerAccount,
    dmpl__Resource__c resource
    ) {
        return (dmpl__RepairOrder__c)TestFactory.createSObject(
            new dmpl__RepairOrder__c(
            dmpl__BranchId__c = branch.Id,
        dmpl__AccountId__c = customerAccount.Id,
        dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
        dmpl__AssetId__c = asset.Id,
        dmpl__ServiceEstimateId__c = serviceEstimate.Id,
        dmpl__ServiceAdvisorId__c = resource.Id,
        dmpl__UsageReading__c = 50.00
            ),
        'RepairOrderDefaults',
        true
            );
    }
    
    
    public static dmpl__RepairOrder__c createRepairOrder(
        dmpl__Item__c item,
    dmpl__branch__c branch,
    Asset asset,
    dmpl__QuoteLine__c quoteLine,
    dmpl__Quote__c serviceEstimate,
    Account customerAccount
    ) {
        
        return (dmpl__RepairOrder__c) TestFactory.createSObject(
            new dmpl__RepairOrder__c (
            dmpl__BranchId__c = branch.Id,
        dmpl__AccountId__c = customerAccount.Id,
        dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
        dmpl__ServiceEstimateId__c = serviceEstimate.Id,
        dmpl__UsageReading__c = 65.00,
        dmpl__ServiceContractItemId__c=quoteLine.dmpl__ServiceContractId__c,
        dmpl__ResetUsageReading__c = false,
        dmpl__ResetUsageHours__c = false
            ),
        'RepairOrderDefaults',
        true
            );
    }
    
    public static dmpl__RepairOrderLine__c createRepairOrderLine(
        Id repairOrderId,
    Id itemId,
    Decimal quantity,
    Decimal unitPrice
    ){
        return (dmpl__RepairOrderLine__c) TestFactory.createSObject(
            new dmpl__RepairOrderLine__c(
            dmpl__RepairOrderId__c = repairOrderId,
        dmpl__ItemId__c = itemId,
        dmpl__Quantity__c = quantity,
        dmpl__UnitPrice__c = unitPrice,
        dmpl__PostingType__c = 'Generate Claims'
            ),
        // 'RepairOrderLineDefaults',
        true
            );
    }
    
    
    public static dmpl__RepairOrderTax__c createRepairOrderTax(dmpl__RepairOrder__c repairOrder) {
        return (dmpl__RepairOrderTax__c)TestFactory.createSObject(
            new dmpl__RepairOrderTax__c(
            dmpl__RepairOrderId__c = repairOrder.Id,
        dmpl__TaxRate__c = 10,
        dmpl__TaxAmount__c = 100,
        dmpl__TaxOnAmount__c = 100
            ),
        'RepairOrderTaxDefaults',
        true
            );
    }
    
    
    
    public static dmpl__RepairOrderLine__c createRepairOrderLine(dmpl__RepairOrder__c repairOrder,
    dmpl__Item__c item,
    dmpl__SKU__c sku,
    dmpl__StorageLocation__c storageLocation,
    dmpl__TaxGroup__c taxGroup,
    dmpl__ItemServiceContract__c itemServiceContract,
    String postingType) {
        
        return (dmpl__RepairOrderLine__c) TestFactory.createSObject(
            new dmpl__RepairOrderLine__c(
            dmpl__ItemId__c = item.Id,
        dmpl__SKUId__c = sku.Id,
        dmpl__ItemServiceContractId__c = itemServiceContract.Id,
        dmpl__StorageLocationId__c = storageLocation.Id,
        dmpl__TaxGroupId__c = taxGroup.Id,
        dmpl__RepairOrderId__c = repairOrder.Id,
        dmpl__PostingType__c = postingType
            ),
        'TestFactoryDefaults.RepairOrderLineDefaults',
        true
            );
    }
    
    
    public static dmpl__RepairOrderTimeSheetLine__c createTimeSheetLine(dmpl__RepairOrderTimeSheet__c timeSheet) {
        return (dmpl__RepairOrderTimeSheetLine__c)TestFactory.createSObject(
            new dmpl__RepairOrderTimeSheetLine__c(
            dmpl__RepairOrderTimeSheetId__c = timeSheet.Id,
        dmpl__ActualDurationHours__c = 1.00
            ),
        true
            );
    }
    
    public static dmpl__RepairOrderTimeSheet__c createTimeSheet(dmpl__RepairOrder__c repairOrder) {
        return (dmpl__RepairOrderTimeSheet__c)TestFactory.createSObject(
            new dmpl__RepairOrderTimeSheet__c(
            dmpl__RepairOrderId__c = repairOrder.Id,
        dmpl__WorkStarted__c = false,
        dmpl__WorkPaused__c = false,
        dmpl__WorkEnded__c = false
            ),
        true
            );
    }
    
    public static dmpl__RepairOrder__c getRepairOrder() {
        return [SELECT
            Id,
            Name,
            dmpl__BranchId__c,
            dmpl__AccountId__c,
            dmpl__PartnerAccountId__c,
            dmpl__AssetId__c,
            dmpl__ServiceEstimateId__c,
            dmpl__ServiceAdvisorId__c,
            dmpl__UsageReading__c
        FROM dmpl__RepairOrder__c LIMIT 1];
    }
    
    
    
    public static List<dmpl__RepairOrder__c> getRepairOrdersById(Id repairOrderId) {
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
        LIMIT 1];
    }
    
    
    
    public static dmpl__RepairOrderTax__c getRepairOrderTax() {
        return [SELECT
            Id,
            Name,
            dmpl__RepairOrderId__c,
            dmpl__TaxRate__c,
            dmpl__TaxAmount__c,
            dmpl__TaxOnAmount__c
        FROM dmpl__RepairOrderTax__c
        LIMIT 1];
    }
    
    public static List<dmpl__RepairOrderTax__c> getRepairOrderTaxesByRepairOrder(Id repairOrderId) {
        return [SELECT
            Id,
            Name,
            dmpl__RepairOrderId__c,
            dmpl__TaxRate__c,
            dmpl__TaxAmount__c,
            dmpl__TaxOnAmount__c
        FROM dmpl__RepairOrderTax__c
        WHERE dmpl__RepairOrderId__c = :repairOrderId];
    }
    
    public static void deleteRepairOrderTaxesByRepairOrder(Id repairOrderId) {
        delete [SELECT Id FROM dmpl__RepairOrderTax__c WHERE dmpl__RepairOrderId__c = :repairOrderId];
    }
    
    public static dmpl__RepairOrderTimeSheet__c getTimeSheet() {
        return [SELECT
            Id,
            Name,
            dmpl__RepairOrderId__c,
            dmpl__WorkStarted__c,
            dmpl__WorkPaused__c,
            dmpl__WorkEnded__c
        FROM dmpl__RepairOrderTimeSheet__c LIMIT 1];
    }
    
    public static List<dmpl__RepairOrderTimeSheet__c> getTimeSheetsByRepairOrder(Id repairOrderId) {
        return [SELECT
            Id,
            Name,
            dmpl__RepairOrderId__c,
            dmpl__WorkStarted__c,
            dmpl__WorkPaused__c,
            dmpl__WorkEnded__c
        FROM dmpl__RepairOrderTimeSheet__c
        WHERE dmpl__RepairOrderId__c = :repairOrderId];
    }
    
    public static List<dmpl__RepairOrderTimeSheet__c> getRepairOrderTimeSheetsById(Id timeSheetId) {
        return [SELECT
            Id,
            Name,
            dmpl__RepairOrderId__c,
            dmpl__WorkStarted__c,
            dmpl__WorkPaused__c,
            dmpl__WorkEnded__c
        FROM dmpl__RepairOrderTimeSheet__c
        WHERE Id = :timeSheetId];
    }
    
    public static dmpl__RepairOrderTimeSheetLine__c getTimeSheetLine() {
        return [SELECT
            Id,
            Name,
            dmpl__RepairOrderTimeSheetId__c,
            dmpl__ActualDurationHours__c
        FROM dmpl__RepairOrderTimeSheetLine__c LIMIT 1];
    }
    
    public static List<dmpl__RepairOrderTimeSheetLine__c> getTimeSheetLinesByTimeSheet(Id timeSheetId) {
        return [SELECT
            Id,
            Name,
            dmpl__RepairOrderTimeSheetId__c,
            dmpl__ActualDurationHours__c
        FROM dmpl__RepairOrderTimeSheetLine__c
        WHERE dmpl__RepairOrderTimeSheetId__c = :timeSheetId];
    }
    
    public static List<dmpl__RepairOrderTimeSheetLine__c> getTimeSheetLinesById(Id timeSheetLineId) {
        return [SELECT
            Id,
            Name,
            dmpl__RepairOrderTimeSheetId__c,
            dmpl__ActualDurationHours__c
        FROM dmpl__RepairOrderTimeSheetLine__c
        WHERE Id = :timeSheetLineId];
    }
    
    public static dmpl__RepairOrder__c createRepairOrder(
        Account partnerAccount,
    Account customerAccount,
    dmpl__Branch__c branch,
    Asset asset,
    Decimal usageReading
    ){
        return (dmpl__RepairOrder__c) TestFactory.createSObject(
            new dmpl__RepairOrder__c(
            dmpl__BranchId__c = branch.Id,
        dmpl__AccountId__c = customerAccount.Id,
        dmpl__PartnerAccountId__c = partnerAccount.Id,
        dmpl__AssetId__c = asset.Id,
        dmpl__UsageReading__c = usageReading,
        dmpl__DocumentDate__c = System.today(),
        dmpl__Status__c = 'Draft'
            ),
        // 'RepairOrderDefaults',
        true
            );
    }
    
    public static dmpl__RepairOrderLine__c createRepairOrderLine(
        dmpl__RepairOrder__c repairOrder,
    dmpl__Item__c item,
    decimal quantity,
    decimal unitPrice
    ){
        return (dmpl__RepairOrderLine__c) TestFactory.createSObject(
            new dmpl__RepairOrderLine__c(
            dmpl__RepairOrderId__c = repairOrder.Id,
        dmpl__ItemId__c = item.Id,
        dmpl__Quantity__c = quantity,
        dmpl__PostingType__c = 'Generate Claims',
        dmpl__UnitPrice__c = unitPrice
            ),
        // 'RepairOrderLineDefaults',
        true
            );
    }
    
    public static dmpl__RepairOrder__c createRepairOrderWithUsageReading(
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
    public static dmpl__RepairOrderLine__c createRepairOrderLineWithTaxGroup(
        dmpl__RepairOrder__c repairOrder,
    dmpl__Item__c item,
    dmpl__TaxGroup__c taxGroup,
    Decimal quantity,
    Decimal unitPrice
        
    ) {
        return (dmpl__RepairOrderLine__c) TestFactory.createSObject(
            new dmpl__RepairOrderLine__c(
        dmpl__RepairOrderId__c = repairOrder != null ? repairOrder.Id : null,
        dmpl__ItemId__c = item.Id,
        dmpl__TaxGroupId__c = taxGroup.Id,
        dmpl__Quantity__c = quantity,
        dmpl__UnitPrice__c = unitPrice
            ),
        //'RepairOrderLineDefaults',
        true
            );
    }
    
    public static dmpl__RepairOrderLine__c getRepairOrderLinesById(Id repairOrderLineId){
        return [SELECT
            Id,
            Name,
            dmpl__RepairOrderId__c ,
            dmpl__AssetServiceContractId__c,
            dmpl__ItemServiceContractId__c,
                dmpl__ItemId__c ,
                dmpl__TaxGroupId__c ,
                dmpl__Quantity__c ,dmpl__QuoteLineId__c,
                dmpl__UnitPrice__c,dmpl__Amount__c, dmpl__BaseAmount__c, dmpl__GrossAmount__c
        FROM dmpl__RepairOrderLine__c
        WHERE Id = :repairOrderLineId
        LIMIT 1];
    }
    
    public static dmpl__RepairOrderLine__c createRepairOrderLineWithQuoteLine(
        dmpl__RepairOrder__c repairOrder,
    dmpl__Item__c item,
    dmpl__QuoteLine__c quoteLine,
    dmpl__TaxGroup__c taxGroup,
    Decimal quantity,
    Decimal unitPrice
    ) {
        return (dmpl__RepairOrderLine__c) TestFactory.createSObject(
            new dmpl__RepairOrderLine__c(
            dmpl__RepairOrderId__c = repairOrder.Id,
        dmpl__ItemId__c = item.Id,
        dmpl__TaxGroupId__c = taxGroup.Id,
        dmpl__QuoteLineId__c = quoteLine.Id,
        dmpl__Quantity__c = quantity,
        dmpl__UnitPrice__c = unitPrice
            ),
        //'RepairOrderLineDefaults',
        true
            );
    }
    
    public static dmpl__RepairOrderLine__c createRepairOrderLineWithServiceContract(
        dmpl__RepairOrder__c repairOrder,
    dmpl__Item__c item,
    dmpl__AssetServiceContract__c serviceContract,
    dmpl__TaxGroup__c taxGroup,
    Decimal quantity,
    Decimal unitPrice
    ) {
        return (dmpl__RepairOrderLine__c) TestFactory.createSObject(
            new dmpl__RepairOrderLine__c(
            dmpl__RepairOrderId__c = repairOrder.Id,
        dmpl__ItemId__c = item.Id,
        dmpl__TaxGroupId__c = taxGroup.Id,
        dmpl__AssetServiceContractId__c = serviceContract.Id,
        dmpl__Quantity__c = quantity,
        dmpl__UnitPrice__c = unitPrice
            ),
        //'RepairOrderLineDefaults',
        true
            );
    }
    
    public static dmpl__AssetServiceContract__c getAssetServiceContract(){
        return [SELECT
        Id,
        name,
        dmpl__ActivatedDate__c,
        dmpl__ValidtillDate__c,
        dmpl__DueDate__c
        FROM
        dmpl__AssetServiceContract__c LIMIT 1];
    }
    
    public static dmpl__RepairOrderLine__c createRepairOrderLineWithItemServiceContract(
        dmpl__RepairOrder__c repairOrder,
    dmpl__Item__c item,
    dmpl__ItemServiceContract__c itemServiceContract,
    dmpl__TaxGroup__c taxGroup,
    Decimal quantity,
    Decimal unitPrice
    ) {
        return (dmpl__RepairOrderLine__c) TestFactory.createSObject(
            new dmpl__RepairOrderLine__c(
            dmpl__RepairOrderId__c = repairOrder.Id,
        dmpl__ItemId__c = item.Id,
        dmpl__ItemServiceContractId__c = itemServiceContract.Id,
        dmpl__TaxGroupId__c = taxGroup.Id,
        dmpl__Quantity__c = quantity,
        dmpl__UnitPrice__c = unitPrice
            ),
        //'RepairOrderLineDefaults',
        true
            );
    }
    
    public static dmpl__ItemServiceContract__c createItemServiceContract(
        dmpl__Item__c item,
    dmpl__SKU__c sku
    ){
        return (dmpl__ItemServiceContract__c) TestFactory.createSObject(
            new dmpl__ItemServiceContract__c(
            dmpl__DateEffectiveFrom__c = date.today(),
        dmpl__DateEffectiveTill__c = date.today() + 7,
        dmpl__ItemId__c = item.Id,
        dmpl__SKUId__c = sku.Id,
        dmpl__PopulateContractLines__c = true
            ),
        true
            );
    }

    public static dmpl__ItemServiceContract__c createLapsedItemServiceContract(
        dmpl__Item__c item,
        dmpl__SKU__c sku
    ) {
        return (dmpl__ItemServiceContract__c) TestFactory.createSObject(
            new dmpl__ItemServiceContract__c(
                dmpl__DateEffectiveFrom__c = Date.today().addYears(-2),
                dmpl__DateEffectiveTill__c = Date.today().addMonths(-6),
                dmpl__ItemId__c = item.Id,
                dmpl__SKUId__c = sku.Id,
                dmpl__PopulateContractLines__c = true
            ),
            true
        );
    }

    
    
    
    public static dmpl__RepairOrderTax__c createRepairOrderTax(
        dmpl__RepairOrder__c repairOrder,
    dmpl__RepairOrderLine__c repairOrderLine,
    dmpl__TaxGroup__c taxGroup,
    String taxName,
    Decimal taxRate
    ) {
        return (dmpl__RepairOrderTax__c) TestFactory.createSObject(
            new dmpl__RepairOrderTax__c(
            dmpl__RepairOrderId__c     = repairOrder.Id,
        dmpl__RepairOrderLineId__c = repairOrderLine.Id,
        dmpl__TaxGroupId__c        = taxGroup.Id,
        dmpl__TaxName__c           = taxName,
        dmpl__TaxRate__c           = taxRate
            ),
        true
            );
    }
    
    public static dmpl__RepairOrderTax__c createRepairOrderTaxWithoutRepairOrderLineReference(dmpl__RepairOrder__c repairOrder,
    dmpl__TaxGroup__c taxGroup,
    String taxName,
    Decimal taxRate){
        
        
        return (dmpl__RepairOrderTax__c) TestFactory.createSObject(
            new dmpl__RepairOrderTax__c(
            dmpl__RepairOrderId__c     = repairOrder.Id,
        dmpl__TaxGroupId__c        = taxGroup.Id,
        dmpl__TaxName__c           = taxName,
        dmpl__TaxRate__c           = taxRate
            ),
        true
            );
    }
    
    public static dmpl__RepairOrderTax__c createRepairOrderTaxWithoutTaxGroup( dmpl__RepairOrder__c repairOrder,
    dmpl__RepairOrderLine__c repairOrderLine){
        
        
        return (dmpl__RepairOrderTax__c) TestFactory.createSObject(
            new dmpl__RepairOrderTax__c(
            dmpl__RepairOrderId__c     = repairOrder.Id,
        dmpl__RepairOrderLineId__c = repairOrderLine.Id
            
        ),
        true
            );
    }
    
    public static dmpl__RepairOrderTax__c getRepairOrderTaxesById(Id TaxId) {
        return [
            SELECT
                Id,
                Name,
                dmpl__RepairOrderId__c,
                dmpl__RepairOrderLineId__c,
                dmpl__TaxGroupId__c,
                dmpl__TaxName__c,
                dmpl__TaxRate__c,
                dmpl__TaxId__c
            FROM dmpl__RepairOrderTax__c
            WHERE Id = :TaxId
            LIMIT 1
        ];
    }
    
    public static dmpl__RepairOrderTimeSheet__c createRepairOrderTimeSheet(
        dmpl__RepairOrder__c repairOrder
    ) {
        return (dmpl__RepairOrderTimeSheet__c) TestFactory.createSObject(
            new dmpl__RepairOrderTimeSheet__c(
            dmpl__RepairOrderId__c = repairOrder.Id,
        dmpl__WorkStarted__c = false,
        dmpl__WorkPaused__c = false,
        dmpl__WorkEnded__c = false
            ),
        true
            );
    }
    
    
    
    public static dmpl__RepairOrderTimeSheet__c createRepairOrderTimeSheet(
        dmpl__RepairOrder__c repairOrder,
    dmpl__RepairOrderLine__c repairOrderLine
    ) {
        return (dmpl__RepairOrderTimeSheet__c) TestFactory.createSObject(
            new dmpl__RepairOrderTimeSheet__c(
            dmpl__RepairOrderId__c = repairOrder.Id,
        dmpl__RepairOrderLine__c = repairOrderLine.Id,
        dmpl__WorkStarted__c = false,
        dmpl__WorkPaused__c = false,
        dmpl__WorkEnded__c = false
            ),
        true
            );
    }
    
    
    public static dmpl__RepairOrderTimeSheetLine__c createRepairOrderTimeSheetLine(
        dmpl__RepairOrderLine__c repairOrderLine,
    Id timeSheetId
    ) {
        return (dmpl__RepairOrderTimeSheetLine__c) TestFactory.createSObject(
            new dmpl__RepairOrderTimeSheetLine__c(
            dmpl__RepairOrderLineId__c = repairOrderLine != null ? repairOrderLine.Id : null ,
        dmpl__RepairOrderTimeSheetId__c = timeSheetId
            ),
        true
            );
    }
    
    
    public static dmpl__RepairOrderTimeSheet__c getRepairOrderTimeSheetById(Id timeSheetId) {
        return [SELECT
            Id,
            Name,
            dmpl__RepairOrderId__c,
            dmpl__RepairOrderLine__c,
            dmpl__WorkStarted__c,
            dmpl__WorkPaused__c,
            dmpl__WorkEnded__c
        FROM dmpl__RepairOrderTimeSheet__c
        WHERE Id = :timeSheetId
        LIMIT 1];
    }
    
    public static dmpl__RepairOrderTimeSheetLine__c getRepairOrderTimeSheetLineById(Id timeSheetLineId) {
        return [SELECT
            Id,
            Name,
            dmpl__RepairOrderLineId__c,
            dmpl__ActualDurationHours__c
        FROM dmpl__RepairOrderTimeSheetLine__c
        WHERE Id = :timeSheetLineId
        LIMIT 1];
    }
    public static dmpl__RepairOrder__c createRepairOrderwithUsageReading(
        Account partnerAccount,
    dmpl__Branch__c branch,
    Account account,
    Decimal usageReading,
    Asset asset,
    dmpl__TaxGroup__c taxGroup,
    dmpl__ContactAddress__c billingAddress,
    dmpl__ContactAddress__c shippingAddress
    ) {
        return (dmpl__RepairOrder__c) TestFactory.createSObject(
            new dmpl__RepairOrder__c(
            dmpl__PartnerAccountId__c = partnerAccount.Id,
        dmpl__BranchId__c = branch?.Id,
        dmpl__AccountId__c = account?.Id,
        dmpl__UsageReading__c = usageReading,
        dmpl__AssetId__c = asset?.Id,
        dmpl__TaxGroupId__c = taxGroup?.Id,
        dmpl__BillingAddressId__c = billingAddress?.Id,
        dmpl__ShippingAddressId__c = shippingAddress?.Id,
        dmpl__DocumentDate__c = Date.today(),
        dmpl__Status__c = 'Draft'
            ),
        'RepairOrderDefaults',
        true
            );
    }
    public static dmpl__RepairOrder__c getRepairOrderById(Id repairOrderId) {
        return [
        SELECT
            Id,
            dmpl__PartnerAccountId__c,
            dmpl__BranchId__c,
            dmpl__AccountId__c,
            dmpl__UsageReading__c,
            dmpl__BillingAddress__c,
            dmpl__BillingCity__c,
            dmpl__BillingState__c,
            dmpl__BillingStreet__c,
            dmpl__BillingPostalCode__c,
            dmpl__DocumentDate__c,
            dmpl__ShippingAddress__c,
            dmpl__ShippingCity__c,
            dmpl__ShippingCountry__c,
            dmpl__ShippingPostalCode__c,
            dmpl__ShippingState__c,
            dmpl__ShippingStreet__c,
            dmpl__PriceListId__c,
            dmpl__TaxGroupId__c,
            dmpl__Status__c
        FROM dmpl__RepairOrder__c
        WHERE Id = :repairOrderId
        LIMIT 1
    ];
    }

    public static dmpl__RepairOrder__c createRepairOrderwithUsageReading(
        Account partnerAccount,
        dmpl__Branch__c branch,
        Account account,
        Decimal usageReading,
        Asset asset,
        dmpl__TaxGroup__c taxGroup
    ) {
        return (dmpl__RepairOrder__c) TestFactory.createSObject(
            new dmpl__RepairOrder__c(
                dmpl__PartnerAccountId__c = partnerAccount.Id,
                dmpl__BranchId__c = branch?.Id,
                dmpl__AccountId__c = account?.Id,
                dmpl__UsageReading__c = usageReading,
                dmpl__AssetId__c = asset?.Id,
                dmpl__TaxGroupId__c = taxGroup?.Id,
                dmpl__DocumentDate__c = Date.today(),
                dmpl__Status__c = 'Draft'
            ),
            'RepairOrderDefaults',
            true
        );
    }
}