/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 04-18-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
@isTest
public class TestDataHelpers {
    /**
     * @description      Generates an Account object with an Partner Flag set
     * @return          `Account`
     */
    public static Account createPartnerAccount() {
        return (Account) TestFactory.createSObject(
            new Account(name = 'TheBestAccount'),
            'PartnerAccountDefaults',
            true
        );
    }
 
    /**
     * @description      Gets an Account object with an Partner Flag set
     * @return          `Account`
     */
    public static Account getPartnerAccount() {
        return [
            SELECT Id, Name,dmpl__PartnerPriceAccountGroupId__c
            FROM Account
            WHERE dmpl__IsPartnerAccount__c = TRUE
            LIMIT 1
        ];
    }
    public static Account createSupplierAccount() {
        return (Account) TestFactory.createSObject(
            new Account(name = 'SupplierAccount'),
            'SupplierAccountDefaults',
            true
        );
    }
    public static Account getSupplierAccount() {
        return [
            SELECT Id, Name
            FROM Account
            WHERE dmpl__IsSupplierAccount__c = TRUE
            LIMIT 1
        ];
    }
 
    /**
     * @description      Generates an Account object with an Customer Flag set
     * @return          `Account`
     */
    public static Account createCustomerAccount() {
        return (Account) TestFactory.createSObject(
            new Account(name = 'TheBestAccount'),
            'CustomerAccountDefaults',
            true
        );
    }
 
    /**
     * @description      Gets an Account object with an Customer Flag set
     * @return          `Account`
     */
    public static Account getCustomerAccount() {
        return [
            SELECT Id, Name,dmpl__CustomerPriceAccountGroupId__c
            FROM Account
            WHERE dmpl__IsCustomerAccount__c = TRUE
            LIMIT 1
        ];
    }
 
    /**
     * @description             Generates an Branch object For The Partner
     * @param partnerAccount    Account should Partner Account
     * @return                  `dmpl__Branch__c`
     */
    public static dmpl__Branch__c createBranch(Account partnerAccount) {
        return (dmpl__Branch__c) TestFactory.createSObject(
            new dmpl__Branch__c(
                name = 'TheBestAccount',
                dmpl__PartnerAccountId__c = partnerAccount.Id
            ),
            'BranchDefaults',
            true
        );
    }
 
    /**
     * @description      Gets an Branch object
     * @return          `dmpl__Branch__c`
     */
    public static dmpl__Branch__c getBranch() {
        return [
            SELECT Id, Name, dmpl__PartnerAccountId__c
            FROM dmpl__Branch__c
            LIMIT 1
        ];
    }
 
    public static dmpl__ContactAddress__c createContactAddress(
        Account customerAccount
    ) {
        return (dmpl__ContactAddress__c) TestFactory.createSObject(
            new dmpl__ContactAddress__c(
                dmpl__AccountId__c = customerAccount.Id,
                Name = 'Test - Contact - Address',
                dmpl__AddressType__c = 'Both'
            ),
            'ContactAddressDefaults',
            true
        );
    }
 
    public static dmpl__ContactAddress__c getContactAddress() {
        return [
            SELECT Id, Name, dmpl__AccountId__c
            FROM dmpl__ContactAddress__c
            LIMIT 1
        ];
    }
 
    public static dmpl__AccountGroup__c createAccountGroup() {
        return (dmpl__AccountGroup__c) TestFactory.createSObject(
            new dmpl__AccountGroup__c(
                Name = 'Test-AccountGroup',
                dmpl__AccountGroupType__c = 'Scheme',
                dmpl__DynamicMemberType__c = 'Report Data',
                dmpl__ReportId__c = 'flow_screen_prebuilt_report',
                dmpl__RuleSuccessCriteria__c = 'Custom Logic Is Met',
                dmpl__RuleSuccessCustomLogic__c = 'Test'
            ),
            'AccountGroupDefaults',
            true
        );
    }
 
    public static dmpl__AccountGroup__c getAccountGroup() {
        return [SELECT Id, Name FROM dmpl__AccountGroup__c LIMIT 1];
    }
 
    public static dmpl__Item__c createItem() {
        return (dmpl__Item__c) TestFactory.createSObject(
            new dmpl__Item__c(Name = 'Item1',dmpl__TrackInventory__c=true,dmpl__ItemType__c = 'Service Contract'),
            'ItemDefaults',
            true
        );
    }
 
    public static dmpl__Item__c getItem() {
        return [SELECT 
        Id, 
        Name,
        dmpl__TaxItemGroupId__c,
        dmpl__ServiceDurationInMinutes__c,
        dmpl__BillingFrequency__c,
        dmpl__MarkupRate__c,
        dmpl__ChargeType__c,
        dmpl__BillingType__c,
        dmpl__PricingMethod__c,
        dmpl__SubscriptionDurationInMonths__c     
        FROM dmpl__Item__c LIMIT 1];
    }
    
    public static dmpl__Item__c createItem1() {
        return (dmpl__Item__c) TestFactory.createSObject(
            new dmpl__Item__c(Name = 'Item1',dmpl__TrackInventory__c=true,dmpl__ItemType__c='Service Contract'),
            'ItemDefaults',
            true
        );
    }
 
    public static dmpl__Item__c getItem1() {
        return [SELECT 
                Id, 
                Name,
                dmpl__TaxItemGroupId__c,
                dmpl__ServiceDurationInMinutes__c,
                dmpl__ItemType__c
                FROM dmpl__Item__c 
                LIMIT 1
            ];
    }

    public static dmpl__Item__c createItemChargeItem() {
        return (dmpl__Item__c) TestFactory.createSObject(
            new dmpl__Item__c(Name = 'Item1',dmpl__TrackInventory__c=true,dmpl__ItemType__c = 'Charge Item'),
            'ItemDefaults',
            true
        );
    }
 
    public static dmpl__Item__c getItemChargeItem() {
        return [SELECT 
        Id, 
        Name,
        dmpl__TaxItemGroupId__c,
        dmpl__ServiceDurationInMinutes__c
        FROM dmpl__Item__c LIMIT 1];
    }
 
    public static dmpl__SKU__c createSKU(dmpl__Item__c item) {
        return (dmpl__SKU__c) TestFactory.createSObject(
            new dmpl__SKU__c(
                Name = 'Test - SKU',
                dmpl__SKUCode__c = 'Test - SKU - Code',
                dmpl__UnitOfMeasureOfConversion__c = 10,
                dmpl__ProductColor__c = 'Sample',
                dmpl__IsDefault__c = false,
                dmpl__QuantityUnitOfMeasure__c = 'Sample',
                dmpl__ItemId__c = item.Id
            ),
            'SKUDefaults',
            true
        );
    }
 
    public static dmpl__SKU__c getSKU() {
        return [SELECT Id, Name,dmpl__ItemId__c FROM dmpl__SKU__c LIMIT 1];
    }
 
    public static dmpl__ItemMaintenanceSchedule__c createItemMaintenanceSchedule(
        dmpl__Item__c item,
        dmpl__SKU__c sku
    ) {
        return (dmpl__ItemMaintenanceSchedule__c) TestFactory.createSObject(
            new dmpl__ItemMaintenanceSchedule__c(
                dmpl__ItemId__c = item.Id,
                dmpl__SKUId__c = sku.Id,
                dmpl__ReminderDaysOffset1__c = 10,
                dmpl__ReminderDaysOffset2__c = 15,
                dmpl__ReminderDaysOffset3__c = 20,
                dmpl__ReminderDaysOffset4__c = 25,
                dmpl__ReminderDaysOffset5__c = 30,
                dmpl__DueInDays__c = 3,
                dmpl__DueinUsageHours__c = 40,
                dmpl__DueOnUsage__c = 45,
                dmpl__FromDurationDays__c = 50,
                dmpl__ToDurationDays__c = 60,
                dmpl__FromUsageHours__c = 65,
                dmpl__ToUsageHours__c = 70,
                dmpl__FromUsageReading__c = 75,
                dmpl__ToUsageReading__c = 80
            ),
            'ItemMaintenanceScheduleDefaults',
            true
        );
    }
 
    public static dmpl__ItemMaintenanceSchedule__c getItemMaintenanceSchedule() {
        return [SELECT Id, Name FROM dmpl__ItemMaintenanceSchedule__c LIMIT 1];
    }
 
    public static Account createAccount(dmpl__AccountGroup__c accountGroup) {
        return (Account) TestFactory.createSObject(
            new Account(
                Name = 'Test - Account',
                Fax = '09876',
                dmpl__LastName__c = 'Account',
                Phone = '1234567891',
                Website = 'www.Dealermatix.com',
                Type = 'Prospect',
                NumberOfEmployees = 2,
                Industry = 'Education',
                AnnualRevenue = 1000,
                Description = 'Accounts added',
                dmpl__IsPartnerAccount__c = false,
                dmpl__IsActive__c = true,
                dmpl__IsTaxExempted__c = true,
                dmpl__IsSupplierAccount__c = false,
                dmpl__IsCustomerAccount__c = false,
                dmpl__PartnerTaxAccountGroupId__c = accountGroup.Id,
                dmpl__CustomerPriceAccountGroupId__c = accountGroup.Id,
                dmpl__CustomerDiscountAccountGroupId__c = accountGroup.Id,
                dmpl__PartnerSchemeAccountGroupId__c = accountGroup.Id,
                dmpl__PartnerPriceAccountGroupId__c = accountGroup.Id,
                dmpl__PartnerDiscountAccountGroupId__c = accountGroup.Id,
                dmpl__CustomerSchemeAccountGroupId__c = accountGroup.Id
            ),
            'AccountDefaults',
            true
        );
    }
 
    public static Account getAccount() {
        return [SELECT Id, Name FROM Account LIMIT 1];
    }
 
    public static dmpl__ItemFeature__c createItemFeatures(
        Account partnerAccount,
        dmpl__Item__c item
    ) {
        return (dmpl__ItemFeature__c) TestFactory.createSObject(
            new dmpl__ItemFeature__c(
                Name = 'Item-Feature',
                dmpl__ItemId__c = item.Id,
                dmpl__PartnerAccountId__c = partnerAccount.Id,
                dmpl__ShowinCatalog__c = false
            ),
            'ItemFeatureDefaults',
            true
        );
    }

    public static Contact createContact(){
        return (contact)TestFactory.createSObject(
            new Contact(
                Phone = '999999',
                HomePhone = '8888888',
                LastName='test'
            ),
            'ContactDefaults',
            true
        );
    }

    public static Contact getContact(){
        return  [SELECT Id,Lastname FROM Contact LIMIT 1];
    }
 
    public static dmpl__ItemFeature__c getItemFeatures() {
        return [SELECT Id, Name FROM dmpl__ItemFeature__c LIMIT 1];
    }
 
    public static dmpl__ItemAlternate__c CreateItemAlternate(
        dmpl__Item__c item
    ) {
        return (dmpl__ItemAlternate__c) TestFactory.createSObject(
            new dmpl__ItemAlternate__c(
                dmpl__ItemId__c = item.Id,
                dmpl__AlternateItemId__c = item.Id
            ),
            'ItemAlternateDefaults',
            true
        );
    }
    public static dmpl__ItemAlternate__c getItemAlternate() {
        return [SELECT Id, Name FROM dmpl__ItemAlternate__c LIMIT 1];
    }
 
    public static dmpl__ItemLot__c createItemLot(
        dmpl__Branch__c branch,
        dmpl__Item__c item,
        dmpl__SKU__c sku,
        dmpl__StorageLocation__c storageLocation
    ) {
        return (dmpl__ItemLot__c) TestFactory.createSObject(
            new dmpl__ItemLot__c(
                dmpl__BranchId__c = branch.Id,
                dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                dmpl__ItemId__c = item.Id,
                dmpl__SKUId__c = sku.Id,
                dmpl__StorageLocationId__c = StorageLocation.Id,
                dmpl__BatchNo__c = ' Test - Batch - Number ',
                dmpl__SerialNumber__c = 'Test - Serial - Number ',
                dmpl__SupplierInvoiceNumber__c = ' Test -Supplier -Invoice- Number ',
                dmpl__DateOfReceipt__c = Date.today(),
                dmpl__DateOfMfg__c = Date.today(),
                dmpl__TotalCost__c = 100,
                dmpl__DateOfSupplierInvoice__c = Date.today(),
                dmpl__Cost__c = 100
            ),
            'ItemLotDefaults',
            true
        );
    }
    public static dmpl__ItemLot__c getItemLot() {
        return [SELECT 
        Id, 
        Name,
        dmpl__ItemLotTypeId__c,
        dmpl__QuantityInHand__c,
        dmpl__SKUId__c,
        dmpl__ItemId__c,
        dmpl__BatchNo__c,
        dmpl__StorageLocationId__c,
        dmpl__UnitCost__c,
        dmpl__QuantityTransferOut__c,
        dmpl__ComponentNumber__c,
        dmpl__DateOfMfg__c,
        dmpl__RegistrationNumber__c,
        dmpl__SupplierInvoiceNumber__c,
        dmpl__DateOfRegistration__c,
        dmpl__QuantityInTransit__c,
        dmpl__QuantityInPendingDeliveries__c,
        dmpl__QuantityPicked__c,
        dmpl__QuantityTransferIn__c,
        dmpl__QuantityOnAllocation__c,
        dmpl__QuantityOnInward__c,
        dmpl__QuantityAdjustedIn__c,
        dmpl__QuantityAdjustedOut__c,
        dmpl__QuantityAssembledIn__c,
        dmpl__QuantityOnFulfillment__c,
        dmpl__QuantityOnOutward__c,
        dmpl__SerialNumber__c,
        dmpl__SaleDate__c
        FROM dmpl__ItemLot__c LIMIT 1];
    }
    public static dmpl__ItemLotType__c CreateItemLotType(dmpl__Item__c item )
    {
        return (dmpl__ItemLotType__c)TestFactory.createSObject(
            new dmpl__ItemLotType__c(
                dmpl__PriceCode__c = 'PC1001',
                dmpl__VariationCode__c = 'VC1001',
                dmpl__ItemId__c = item.Id,
                dmpl__IsPromo__c = false
            ),
            true
        );
       
    }

    public static dmpl__ItemLotType__c getItemLotType(){
        return [select id,name from dmpl__ItemLotType__c limit 1];
    }
    
    public static dmpl__Resource__c createResource(
        Account partnerAccount,
        dmpl__Branch__c branch
    ) {
        return (dmpl__Resource__c) TestFactory.createSObject(
            new dmpl__Resource__c(
                Name = 'Test - Resource',
                dmpl__ResourceType__c = 'Service Advisor',
                dmpl__IsActive__c = true,
                dmpl__Phone__c = '9999999999',
                dmpl__DefaultPartnerAccountId__c = partnerAccount.Id,
                dmpl__DefaultBranchId__c = branch.Id
            ),
            'ResourceDefaults',
            true
        );
    }
    public static dmpl__Resource__c getResource() {
        return [SELECT Id, Name FROM dmpl__Resource__c LIMIT 1];
    }
 
    public static dmpl__TaxGroup__c createTaxGroup(
        Account partnerAccount,
        dmpl__Branch__c branch
    ) {
        return (dmpl__TaxGroup__c) TestFactory.createSObject(
            new dmpl__TaxGroup__c(
                Name = 'Test - Tax Group',
                dmpl__PartnerAccountId__c = partnerAccount.Id,
                dmpl__BranchId__c = branch.Id,
                dmpl__Description__c = 'Test-Description',
                dmpl__IsActive__c = true
            ),
            true
        );
    }
   
    public static dmpl__TaxGroup__c getTaxGroup() {
        return [ SELECT
                 Id,
                 Name,
                 PartnerAccountId__c,
                 dmpl__BranchId__c
                  FROM dmpl__TaxGroup__c 
                  LIMIT 1
             ];
    }
 
    public static dmpl__PriceListRules__c createPriceListRules(
        dmpl__PriceList__c priceList,
        dmpl__Item__c item
    ) {
        return (dmpl__PriceListRules__c) TestFactory.createSObject(
            new dmpl__PriceListRules__c(
                dmpl__ItemId__c = item.Id,
                dmpl__PriceListId__c = priceList.Id,
                dmpl__DateEffectiveFrom__c = date.today()
            ),
            true
        );
    }
    public static dmpl__PriceListRules__c getPriceListRules() {
        return [
            SELECT 
                Id, 
                Name,
                dmpl__ItemId__c,
                dmpl__SKUId__c,
                dmpl__PriceListId__c,
                dmpl__DateEffectiveTill__c,
                dmpl__DateEffectiveFrom__c
            FROM 
                dmpl__PriceListRules__c 
            LIMIT 1];
    }
 
    public static dmpl__PriceList__c createPriceList(
        Account partnerAccount,
        dmpl__Branch__c branch
    ) {
        return (dmpl__PriceList__c) TestFactory.createSObject(
            new dmpl__PriceList__c(
                Name = 'Test-Price',
                dmpl__PartnerAccountId__c = partnerAccount.Id,
                dmpl__BranchId__c = branch.Id,
                dmpl__PriceListType__c = 'Sale Price',
                dmpl__IsActive__c = true,
                dmpl__IsDefault__c = false
            ),
            true
        );
    }
    public static dmpl__PriceList__c getPriceList() {
        return [SELECT Id, Name FROM dmpl__PriceList__c LIMIT 1];
    }
 
    public static dmpl__Tax__c createTax(dmpl__TaxGroup__c taxGroup) {
        return (dmpl__Tax__c) TestFactory.createSObject(
            new dmpl__Tax__c(
                Name = 'Test - Tax',
                dmpl__TaxGroupId__c = taxGroup.Id,
                dmpl__Type__c = 'Cess',
                dmpl__Rate__c = 10
            ),
            'TaxDefaults',
            true
        );
    }
    public static dmpl__Tax__c getTax() {
        return [SELECT 
        Id, 
        Name ,
        dmpl__Rate__c
        FROM dmpl__Tax__c LIMIT 1];
    }
 
    public static dmpl__TaxGroupRule__c createTaxGroupRule(
        dmpl__Item__c item,
        dmpl__SKU__c SKU,
        dmpl__TaxGroup__c taxGroup,
        dmpl__ItemGroup__c ItemGroup
    ) {
        return (dmpl__TaxGroupRule__c) TestFactory.createSObject(
            new dmpl__TaxGroupRule__c(
                dmpl__TaxGroupId__c = taxGroup.Id,
                dmpl__SKUId__c = SKU.Id,
                dmpl__ItemId__c = Item.Id,
                dmpl__DateEffectiveFrom__c = date.today(),
                dmpl__DateEffectiveTill__c = date.today() + 15,
                dmpl__PlaceOfSupplyType__c = 'Within State',
                dmpl__ItemGroupId__c = ItemGroup.Id
            ),
            true
        );
    }
    public static dmpl__TaxGroupRule__c getTaxGroupRule() {
        return [SELECT Id, Name FROM dmpl__TaxGroupRule__c LIMIT 1];
    }
 
    public static dmpl__ItemGroup__c createItemGroup() {
        return (dmpl__ItemGroup__c) TestFactory.createSObject(
            new dmpl__ItemGroup__c(
                Name = 'Item Group Test',
                dmpl__ItemGroupType__c = 'Tax'
            ),
            'ItemGroupDefaults',
            true
        );
    }
    public static dmpl__ItemGroup__c getItemGroup() {
        return [SELECT Id, Name FROM dmpl__ItemGroup__c LIMIT 1];
    }
 
    public static dmpl__StorageLocation__c createStorageLocation(
        dmpl__Branch__c branch
    ) {
        return (dmpl__StorageLocation__c) TestFactory.createSObject(
            new dmpl__StorageLocation__c(
                Name = 'Test - Storage - Location',
                dmpl__BranchId__c = branch.Id,
                dmpl__LocationType__c = 'Warehouse',
                dmpl__IsActive__c = false,
                dmpl__AllowInventory__c = false,
                dmpl__IsMobile__c = false
            ),
            'StorageLocationDefaults',
            true
        );
    }
    public static dmpl__StorageLocation__c getStorageLocation() {
        return [SELECT Id, Name FROM dmpl__StorageLocation__c LIMIT 1];
    }

    public static dmpl__PartnerResource__c createPartnerResources(Account partnerAccount,dmpl__Branch__c branch,dmpl__Resource__c resource) {
        return (dmpl__PartnerResource__c) TestFactory.createSObject(
            new dmpl__PartnerResource__c(dmpl__PartnerAccountId__c =partnerAccount.Id,
                                    dmpl__BranchId__c= branch.Id,
                                    dmpl__ResourceId__c= resource.Id,               
                                    dmpl__RuleSuccessCriteria__c='All Rules Are Met',
                                    dmpl__AssignmentSequenceNumber__c=12),
            'PartnerResourceDefaults',
            true
        );
    }

    public static dmpl__PartnerResource__c getPartnerResources() {
        return [
            SELECT Id, Name
            FROM dmpl__PartnerResource__c
            LIMIT 1
        ];
    }

    public static dmpl__ResourceAssignmentRule__c createAssignmentRule(dmpl__PartnerResource__c partnerResource) {
        return (dmpl__ResourceAssignmentRule__c) TestFactory.createSObject(
            new dmpl__ResourceAssignmentRule__c(dmpl__PartnerResourceId__c=partnerResource.Id,
                                        dmpl__FieldName__c='dmpl__Remarks__c',  
                                        dmpl__FieldValue__c='Test Remarks',
                                        dmpl__Operation__c='equals',
                                        dmpl__SequenceNumber__c=12,
                                        dmpl__AssignmentType__c='Lead'),
            'ResourceAssignmentRuleDefaults',
            true
        );
    }

    public static dmpl__ResourceAssignmentRule__c getAssignmentRule() {
        return [
            SELECT Id, Name
            FROM dmpl__ResourceAssignmentRule__c
            LIMIT 1
        ];
    }   

    public static dmpl__BranchTimeSlot__c createBranchTimeSlot(dmpl__Branch__c branch,dmpl__Item__c item) {
        return (dmpl__BranchTimeSlot__c) TestFactory.createSObject(
            new dmpl__BranchTimeSlot__c(dmpl__BranchId__c = branch.Id,
                                                           dmpl__TransactionType__c = 'Product Demo',
                                                           Name = 'Test - Name',
                                                           dmpl__IsActive__c = True,
                                                           dmpl__ApplicableToItem__c= item.Id,
                                                           dmpl__StartTime__c = time.newInstance(10, 20, 5, 200),
                                                           dmpl__MaximumCapacity__c = 30,                                                    
                                                           dmpl__MondayCapacity__c = 30,
                                                           dmpl__TuesdayCapacity__c = 30,
                                                           dmpl__WednesdayCapacity__c = 30,
                                                           dmpl__ThursdayCapacity__c = 30,
                                                           dmpl__FridayCapacity__c = 30,
                                                           dmpl__SaturdayCapacity__c = 30,
                                                           dmpl__SundayCapacity__c = 30
                                                          ),
            'BranchTimeSlotBookingDefaults',
            true
        );
    }
    public static dmpl__BranchTimeSlot__c getBranchTimeSlot() {
        return [
            SELECT Id, Name
            FROM dmpl__BranchTimeSlot__c
            LIMIT 1
        ];
    }

    public static dmpl__ItemServiceContract__c createItemServiceContract(dmpl__Item__c items,dmpl__SKU__c skus) {
        return (dmpl__ItemServiceContract__c) TestFactory.createSObject(
            new dmpl__ItemServiceContract__c(dmpl__DateEffectiveFrom__c = date.today(),
                                                                 dmpl__DateEffectiveTill__c = date.today() + 7,
                                                                 dmpl__ItemId__c = items.Id,
                                                                 dmpl__SKUId__c = skus.Id,
                                                                 dmpl__PopulateContractLines__c = true
                                                                ),
            'ItemServiceContractDefaults',
            true
        );
    }
    public static dmpl__ItemServiceContract__c getItemServiceContract() {
        return [
            SELECT Id, Name,dmpl__GraceUsageDays__c,dmpl__ItemId__c,dmpl__GraceUsageReading__c,dmpl__GraceUsageHours__c,dmpl__MaximumUsageHours__c,dmpl__FromDays__c,dmpl__ToDays__c,dmpl__MinimumUsageHours__c,dmpl__MinimumUsageReading__c,dmpl__MaximumUsageReading__c,dmpl__RestrictAssetContractLinesGeneration__c,
            (select Id,Name,dmpl__ComponentItemId__c,dmpl__Quantity__c from dmpl__ItemServiceContractLines__r)
            FROM dmpl__ItemServiceContract__c
            LIMIT 1
        ];
    }

    public static dmpl__ItemServiceContractLine__c createItemServiceContractLine(dmpl__ItemServiceContract__c itemServiceContract,dmpl__ItemComponent__c itemComponent){
        return (dmpl__ItemServiceContractLine__c) TestFactory.createSObject(
            new dmpl__ItemServiceContractLine__c(dmpl__ItemServiceContractId__c = itemServiceContract.Id,
            dmpl__ComponentItemId__c = itemComponent.Id,
            dmpl__Quantity__c = 5),
            'ItemServiceContractLineDefaults',
            true
        );
    }

    public static dmpl__ServiceBay__c createServiceBay(dmpl__Branch__c branch) {
        return (dmpl__ServiceBay__c) TestFactory.createSObject(
            new dmpl__ServiceBay__c(Name = 'Test - ServiceBay',
                                                       dmpl__BranchId__c = branch.Id),
            'ServiceBayDefaults',
            true
        );
    }
    public static dmpl__ServiceBay__c getServiceBay() {
        return [
            SELECT Id, Name
            FROM dmpl__ServiceBay__c
            LIMIT 1
        ];
    }

    public static dmpl__DiscountGroup__c createDiscountGroup(
        Account partnerAccount,
        dmpl__AccountGroup__c partnerAccountGroup,
        dmpl__Branch__c branch
    ){
        return (dmpl__DiscountGroup__c)TestFactory.createSObject(
            new dmpl__DiscountGroup__c(
                Name = 'Discount-Test',
                dmpl__DiscountType__c = 'Sale Price',
                dmpl__IsActive__c = true,
                dmpl__IsDefault__c = true,
                dmpl__PartnerAccountId__c = partnerAccount.Id,
                dmpl__PartnerAccountGroupId__c = partnerAccountGroup.Id,
                dmpl__BranchId__c = branch.Id
            ),
            true
        );
    }
    public static dmpl__DiscountGroup__c getDiscountGroup(){
        return [SELECT 
        id,
        name 
        FROM dmpl__DiscountGroup__c LIMIT 1];
    }


    public static dmpl__ItemComponent__c createItemComponent(dmpl__Item__c item,dmpl__Item__c compitem,Account partnerAccount,dmpl__SKU__c sku,dmpl__ItemFeature__c itemFeature) {
        return (dmpl__ItemComponent__c) TestFactory.createSObject(
            new dmpl__ItemComponent__c(
                dmpl__ItemId__c = item.Id,
                dmpl__ComponentItemId__c=compitem.Id,
                dmpl__SKUId__c = sku.Id,
                dmpl__IsMandatory__c=false,
                dmpl__IsBundled__c=true,
                dmpl__PackageType__c='Independent Of Package',
                dmpl__Quantity__c = 10,
                dmpl__IsSelected__c=true,
                dmpl__IsQuantityEditable__c=True,
                dmpl__ApplicableFor__c='Sale',
                dmpl__PartnerAccountId__c = partnerAccount.id,
                dmpl__FeatureId__c = itemFeature.Id,
                dmpl__SortOrder__c = 30),
            'ItemComponentDefaults',
            true
        );
    }
    public static dmpl__ItemComponent__c getItemComponent() {
        return [
            SELECT 
            Id, 
            Name,
            dmpl__ComponentItemId__c,
            dmpl__ComponentSKUId__c,
            dmpl__Quantity__c,
            dmpl__IsQuantityEditable__c,
            dmpl__PackageType__c,
            dmpl__IsBundled__c
            FROM dmpl__ItemComponent__c
            LIMIT 1
        ];
    }
    
    //new Partner Account 1
    /**
     * @description      Generates a Partner Account with specific field values passed as parameters
     * @return          `Account`
     */
    public static Account createPartnerAccount(
        String name,
        Boolean isCustomerAccount,
        Boolean isPartnerAccount, 
        Boolean isSupplierAccount,
        Boolean isActive,
        String billingStreet,
        String billingCity,
        String billingState,
        String billingCountry,
        String billingPostalCode,
        String shippingStreet,
        String shippingCity,
        String shippingState,
        String shippingCountry,
        String shippingPostalCode,
        String phone
    ) {
        return (Account) TestFactory.createSObject(
            new Account(
                Name = name,
                dmpl__IsCustomerAccount__c = isCustomerAccount,
                dmpl__IsPartnerAccount__c = isPartnerAccount,
                dmpl__IsSupplierAccount__c = isSupplierAccount,
                dmpl__IsActive__c = isActive,
                dmpl__BillingStreet__c = billingStreet,
                dmpl__BillingCity__c = billingCity,
                dmpl__BillingState__c = billingState,
                dmpl__BillingCountry__c = billingCountry,
                dmpl__BillingPostalCode__c = billingPostalCode,
                dmpl__ShippingStreet__c = shippingStreet,
                dmpl__ShippingCity__c = shippingCity,
                dmpl__ShippingState__c = shippingState,
                dmpl__ShippingCountry__c = shippingCountry,
                dmpl__ShippingPostalCode__c = shippingPostalCode,
                Phone = phone
            ),
           // 'PartnerAccountDefaults',
            true
        );
    }

    /**
     * @description      Gets a Partner Account with all fields
     * @return          `Account`
     */
    public static Account getPartnerAccount(String name) {
        return [
            SELECT 
                Id,
                Name,
                dmpl__IsCustomerAccount__c,
                dmpl__IsPartnerAccount__c,
                dmpl__IsSupplierAccount__c, 
                dmpl__IsActive__c,
                dmpl__BillingStreet__c,
                dmpl__BillingCity__c,
                dmpl__BillingState__c,
                dmpl__BillingCountry__c,
                dmpl__BillingPostalCode__c,
                dmpl__ShippingStreet__c,
                dmpl__ShippingCity__c,
                dmpl__ShippingState__c,
                dmpl__ShippingCountry__c,
                dmpl__ShippingPostalCode__c
            FROM Account
            WHERE dmpl__IsPartnerAccount__c = TRUE
            AND Name = :name
            LIMIT 1
        ];
    }
    
    public static Account createCustomerAccount(
        String name,
        Boolean isCustomerAccount,
        Boolean isPartnerAccount,
        Boolean isSupplierAccount,
        Boolean isActive,
        String billingStreet,
        String billingCity,
        String billingState,
        String billingCountry,
        String billingPostalCode,
        String shippingStreet,
        String shippingCity,
        String shippingState,
        String shippingCountry,
        String shippingPostalCode,
        String phone,
        String status
       ){
        return (Account) TestFactory.createSObject(
            new Account(
                Name = name,
                dmpl__IsCustomerAccount__c = isCustomerAccount,
                dmpl__IsPartnerAccount__c = isPartnerAccount,
                dmpl__IsSupplierAccount__c = isSupplierAccount,
                dmpl__IsActive__c = isActive,
                dmpl__BillingStreet__c = billingStreet,
                dmpl__BillingCity__c = billingCity,
                dmpl__BillingState__c = billingState,
                dmpl__BillingCountry__c = billingCountry,
                dmpl__BillingPostalCode__c = billingPostalCode,
                dmpl__ShippingStreet__c = shippingStreet,
                dmpl__ShippingCity__c = shippingCity,
                dmpl__ShippingState__c = shippingState,
                dmpl__ShippingCountry__c = shippingCountry,
                dmpl__ShippingPostalCode__c = shippingPostalCode,
                Phone = phone,
                dmpl__Status__c = status
            ),
            //'CustomerAccountDefaults',
            true
        );
    }
 

    public static Account getCustomerAccount(String name){
        return [
            Select Id,
            Name,
            dmpl__IsCustomerAccount__c,
            dmpl__IsPartnerAccount__c,
            dmpl__IsSupplierAccount__c,
            dmpl__IsActive__c,
            dmpl__BillingStreet__c,
            dmpl__BillingCity__c,
            dmpl__BillingState__c,
            dmpl__BillingCountry__c,
            dmpl__BillingPostalCode__c,
            dmpl__ShippingStreet__c,
            dmpl__ShippingCity__c,
            dmpl__ShippingState__c,
            dmpl__ShippingCountry__c,
            dmpl__ShippingPostalCode__c,
            Phone,
            dmpl__AccountLocation__c,
            AccountSource,
            dmpl__Status__c
            FROM Account
            WHERE Name = :name
            LIMIT 1
        ];
    }
 
 
      public static dmpl__ContactAddress__c createContactAddress(
        String Name,
        String street,
        String city,
        String state,
        Id customerAccountId,
        String addressType,
        String postalCode,
        Boolean isDefault
    ){
        return (dmpl__ContactAddress__c) TestFactory.createSObject(
            new dmpl__ContactAddress__c(
                Name = Name,
                dmpl__Street__c = street,
                dmpl__City__c = city,
                dmpl__State__c = state,
                dmpl__AccountId__c = customerAccountId,
                dmpl__AddressType__c = addressType,
                dmpl__PostalCode__c = postalCode, 
                dmpl__IsDefault__c = isDefault
            ),
            'ContactAddressDefaults',
            true    
        );
    }
    public static dmpl__ContactAddress__c getContactAddress(String name){
        return[
            SELECT Id, Name, dmpl__Street__c, dmpl__City__c, dmpl__State__c, dmpl__AccountId__c, dmpl__AddressType__c, dmpl__PostalCode__c, dmpl__IsDefault__c
            FROM dmpl__ContactAddress__c
            WHERE Name = :name
            LIMIT 1
        ];
    }
    public static dmpl__ContactAddress__c getContactAddress(Id customerAccountId){
        return[
            SELECT Id, Name, dmpl__Street__c, dmpl__City__c, dmpl__State__c, dmpl__AccountId__c, dmpl__AddressType__c, dmpl__PostalCode__c, dmpl__IsDefault__c
            FROM dmpl__ContactAddress__c
            WHERE dmpl__AccountId__c = :customerAccountId
            LIMIT 1
        ];
    }

    /**
     * @description             Generates another Branch object For The Partner with additional fields
     * @return                  `dmpl__Branch__c`
     */
    public static dmpl__Branch__c createBranch(
        String name,    
        Id partnerAccountId,
        Boolean isActive,
        Boolean allowSales,
        Boolean allowPurchase,
        Boolean allowInventory
    ) {
        return (dmpl__Branch__c) TestFactory.createSObject(
            new dmpl__Branch__c(
                Name = name,
                dmpl__PartnerAccountId__c = partnerAccountId,
                dmpl__IsActive__c = isActive,
                dmpl__AllowSales__c = allowSales,
                dmpl__AllowPurchase__c = allowPurchase,
                dmpl__AllowInventory__c = allowInventory
            ),
            'BranchDefaults',
            true
        );
    }

    /**
     * @description      Gets a Branch object with additional fields
     * @return          `dmpl__Branch__c`
     */
    public static dmpl__Branch__c getBranch(String name) {
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__PartnerAccountId__c,
                dmpl__IsActive__c,
                dmpl__AllowSales__c,
                dmpl__AllowPurchase__c,
                dmpl__AllowInventory__c
            FROM dmpl__Branch__c
            WHERE Name = :name
            LIMIT 1
        ];
    }

    // created supplier account with all fields
    public static Account createSupplierAccount(
        String name,
        String billingStreet,
        String billingCity,
        String billingState,
        String billingCountry,
        String billingPostalCode,
        String shippingStreet,
        String shippingCity,
        String shippingState,
        String shippingCountry,
        String shippingPostalCode,
        String phone
    ) {
        return (Account) TestFactory.createSObject(
            new Account(
                Name = name,
                dmpl__IsCustomerAccount__c = false,
                dmpl__IsPartnerAccount__c = false,
                dmpl__IsSupplierAccount__c = true,
                dmpl__IsActive__c = false,
                dmpl__BillingStreet__c = billingStreet,
                dmpl__BillingCity__c = billingCity,
                dmpl__BillingState__c = billingState,
                dmpl__BillingCountry__c = billingCountry,
                dmpl__BillingPostalCode__c = billingPostalCode,
                dmpl__ShippingStreet__c = shippingStreet,
                dmpl__ShippingCity__c = shippingCity,
                dmpl__ShippingState__c = shippingState,
                dmpl__ShippingCountry__c = shippingCountry,
                dmpl__ShippingPostalCode__c = shippingPostalCode,
                Phone = phone
            ),
            'SupplierAccountDefaults',
            true
        );
    }

    public static Account getSupplierAccount(String name) {
        return [
            SELECT 
                Id,
                Name,
                dmpl__IsCustomerAccount__c,
                dmpl__IsPartnerAccount__c, 
                dmpl__IsSupplierAccount__c,
                dmpl__IsActive__c,
                dmpl__BillingStreet__c,
                dmpl__BillingCity__c,
                dmpl__BillingState__c,
                dmpl__BillingCountry__c,
                dmpl__BillingPostalCode__c,
                dmpl__ShippingStreet__c,
                dmpl__ShippingCity__c,
                dmpl__ShippingState__c,
                dmpl__ShippingCountry__c,
                dmpl__ShippingPostalCode__c
            FROM Account
            WHERE dmpl__IsSupplierAccount__c = TRUE
            AND Name = :name
            LIMIT 1
        ];
    }
    
    /**
     * @description Creates an Account Group Member record with specified fields
     * @return dmpl__AccountGroupMember__c
     */
    public static dmpl__AccountGroupMember__c createAccountGroupMember(
        Id accountGroupId,
        Id accountId
    ) {
        return (dmpl__AccountGroupMember__c) TestFactory.createSObject(
            new dmpl__AccountGroupMember__c(
                dmpl__AccountGroupId__c = accountGroupId,
                dmpl__AccountId__c = accountId
            ),
            'AccountGroupMemberDefaults',
            true
        );
    }

    /**
     * @description Gets an Account Group Member record
     * @return dmpl__AccountGroupMember__c
     */
    public static dmpl__AccountGroupMember__c getAccountGroupMember() {
        return [
            SELECT 
                Id,
                Name,
                dmpl__AccountGroupId__c,
                dmpl__AccountId__c
            FROM dmpl__AccountGroupMember__c
            LIMIT 1
        ];
    }

    /**
     * @description Creates an Account Group with specified fields
     * @return dmpl__AccountGroup__c
     */
    public static dmpl__AccountGroup__c createAccountGroup(
        String accountGroupName,
        String accountGroupType
    ) {
        return (dmpl__AccountGroup__c) TestFactory.createSObject(
            new dmpl__AccountGroup__c(
                Name = accountGroupName,
                dmpl__AccountGroupType__c = accountGroupType
            ),
            'AccountGroupDefaults',
            true
        );
    }

    /**
     * @description Gets an Account Group record with all fields
     * @return dmpl__AccountGroup__c
     */
    public static dmpl__AccountGroup__c getAccountGroup(String name) {
        return [
            SELECT 
                Id,
                Name,
                dmpl__AccountGroupType__c,
                dmpl__Description__c,
                dmpl__DynamicMemberType__c,
                dmpl__ReportId__c,
                dmpl__RuleSuccessCriteria__c,
                dmpl__RuleSuccessCustomLogic__c
            FROM dmpl__AccountGroup__c
            WHERE Name = :name
            LIMIT 1
        ];
    }
    
    public static dmpl__Item__c createItem(
        String Name,
        String ItemType,
        Boolean IsActive,
        Boolean IsPackage,
        Boolean IsSKURequired,
        String ItemCode,
        Boolean IsDiscontinued
    ){
        return (dmpl__Item__c) TestFactory.createSObject(
            new dmpl__Item__c(
                Name=Name,
                dmpl__ItemType__c = ItemType,
                dmpl__IsActive__c = IsActive,
                dmpl__IsPackage__c = IsPackage,
                dmpl__IsSKURequired__c = IsSKURequired,
                dmpl__ItemCode__c = ItemCode,
                dmpl__IsDiscontinued__c =IsDiscontinued
               
            ),
            'ItemDefaults',
            true    
        );
    }
    
    public static dmpl__Item__c getItem(String Name){
        return[
            SELECT Id, Name, dmpl__ItemType__c, dmpl__IsActive__c, dmpl__IsPackage__c, dmpl__IsSKURequired__c, dmpl__ItemCode__c, dmpl__IsDiscontinued__c
            FROM dmpl__Item__c
            WHERE Name = :name
            LIMIT 1
        ];
    }
    
    public static dmpl__ItemUnitOfMeasure__c ItemUnitOfMeasure(
        String Name,
        String ItemUnitOfMeasure,
        Decimal ConversionRatio,
        Id itemId
    ){
        return (dmpl__ItemUnitOfMeasure__c) TestFactory.createSObject(
            new dmpl__ItemUnitOfMeasure__c(
                Name=Name,
                dmpl__QuantityUnitOfMeasure__c = ItemUnitOfMeasure,
                dmpl__ConversionRatio__c = ConversionRatio,
                dmpl__ItemId__c = itemId
            ),
            true    
        );
    }
 
    public static dmpl__ItemUnitOfMeasure__c getItemUnitOfMeasure(String Name){
        return[
            SELECT Id, Name, dmpl__QuantityUnitOfMeasure__c, dmpl__ConversionRatio__c
            FROM dmpl__ItemUnitOfMeasure__c
            WHERE Name = :name
            LIMIT 1
        ];
    }
    
    public static dmpl__ItemGroup__c createItemGroup(
        String name,
        String itemGroupType
    ){
        return (dmpl__ItemGroup__c) TestFactory.createSObject(
            new dmpl__ItemGroup__c(
                Name = name,
                dmpl__ItemGroupType__c = itemGroupType
            ),
            'ItemGroupDefaults',
            true    
        );
    }
 
    public static dmpl__ItemGroupMember__c createItemGroupMember(
        Id itemGroupId,
        Id itemId
    ){
        return (dmpl__ItemGroupMember__c) TestFactory.createSObject(
            new dmpl__ItemGroupMember__c(
                dmpl__ItemGroupId__c = itemGroupId,
                dmpl__ItemId__c = itemId
            ),
            'ItemGroupMemberDefaults',
            true
        );
    }
    
    public static dmpl__ItemGroup__c getItemGroup(String name){
        return [SELECT Id, Name, dmpl__ItemGroupType__c FROM dmpl__ItemGroup__c WHERE Name = :name LIMIT 1];
    }

    public static dmpl__PriceList__c createPriceList(
        String name,
        Id partnerAccountId,
        Id branchId,
        Id partnerAccountGroupId,
        Id customerAccountGroupId,
        Boolean isActive,
        Boolean isDefault,
        String priceListType
    ) {
        return (dmpl__PriceList__c) TestFactory.createSObject(
            new dmpl__PriceList__c(
                Name = name,
                dmpl__PartnerAccountId__c = partnerAccountId,
                dmpl__BranchId__c = branchId,
                dmpl__PartnerAccountGroupId__c = partnerAccountGroupId,
                dmpl__CustomerAccountGroupId__c = customerAccountGroupId,
                dmpl__IsActive__c = isActive,
                dmpl__IsDefault__c = isDefault,
                dmpl__PriceListType__c = priceListType
            ),
            true
        );
    }

    public static dmpl__PriceList__c getPriceList(String name) {
        return [
            SELECT 
                Id,
                Name,
                dmpl__PartnerAccountId__c,
                dmpl__BranchId__c,
                dmpl__PartnerAccountGroupId__c,
                dmpl__CustomerAccountGroupId__c,
                dmpl__IsActive__c,
                dmpl__IsDefault__c,
                dmpl__PriceListType__c
            FROM dmpl__PriceList__c
            WHERE Name = :name
            LIMIT 1
        ];
    }

    public static dmpl__PriceListRules__c createPriceListRules(
        Id priceListId,
        Id itemId,
        Id itemLotTypeId,
        Id skuId,
        Decimal price,
        Date dateEffectiveFrom,
        Date dateEffectiveTill
    ) {
        return (dmpl__PriceListRules__c) TestFactory.createSObject(
            new dmpl__PriceListRules__c(
                dmpl__PriceListId__c = priceListId,
                dmpl__ItemId__c = itemId,
                dmpl__ItemLotTypeId__c = itemLotTypeId,
                dmpl__SKUId__c = skuId,
                dmpl__Price__c = price,
                dmpl__DateEffectiveFrom__c = dateEffectiveFrom,
                dmpl__DateEffectiveTill__c = dateEffectiveTill
            ),
            true
        );
    }

    public static dmpl__PriceListRules__c getPriceListRules(Id priceListId) {
        return [
            SELECT 
                Id,
                Name,
                dmpl__PriceListId__c,
                dmpl__ItemId__c,
                dmpl__ItemLotTypeId__c,
                dmpl__SKUId__c,
                dmpl__Price__c,
                dmpl__DateEffectiveFrom__c,
                dmpl__DateEffectiveTill__c
            FROM dmpl__PriceListRules__c
            WHERE dmpl__PriceListId__c = :priceListId
            LIMIT 1
        ];
    }

    public static dmpl__TaxGroup__c createTaxGroup(
        String name,
        Boolean isActive,
        String taxGroupType,
        Id partnerAccountId,
        Id branchId,
        Id partnerAccountGroupId
    ) {
        return (dmpl__TaxGroup__c) TestFactory.createSObject(
            new dmpl__TaxGroup__c(
                Name = name,
                dmpl__IsActive__c = isActive,
                dmpl__TaxGroupType__c = taxGroupType, 
                dmpl__PartnerAccountId__c = partnerAccountId,
                dmpl__BranchId__c = branchId,
                dmpl__PartnerAccountGroupId__c = partnerAccountGroupId
            ),
            true
        );
    }

    public static dmpl__TaxGroup__c getTaxGroup(String name) {
        return [
            SELECT 
                Id,
                Name,
                dmpl__IsActive__c,
                dmpl__TaxGroupType__c,
                dmpl__PartnerAccountId__c,
                dmpl__BranchId__c,
                dmpl__PartnerAccountGroupId__c
            FROM dmpl__TaxGroup__c
            WHERE Name = :name
            LIMIT 1
        ];
    }

    public static dmpl__TaxGroup__c getTaxGroup(Id partenerAccountId) {
        return [
            SELECT 
                Id,
                Name,
                dmpl__IsActive__c,
                dmpl__TaxGroupType__c,
                dmpl__PartnerAccountId__c,
                dmpl__BranchId__c,
                dmpl__PartnerAccountGroupId__c
            FROM dmpl__TaxGroup__c
            WHERE dmpl__PartnerAccountId__c = :partenerAccountId
            LIMIT 1
        ];
    }

    public static dmpl__Tax__c createTax(
        String name,
        String type,
        Decimal rate,
        Id taxGroupId,
        String postingFieldName
    ) {
        return (dmpl__Tax__c) TestFactory.createSObject(
            new dmpl__Tax__c(
                Name = name,
                dmpl__Type__c = type,
                dmpl__Rate__c = rate,
                dmpl__TaxGroupId__c = taxGroupId,
                dmpl__PostingFieldName__c = postingFieldName
            ),
           true
        );
    }

    public static dmpl__Tax__c getTax(String name) {
        return [
            SELECT 
                Id,
                Name,
                dmpl__Type__c,
                dmpl__Rate__c,
                dmpl__TaxGroupId__c
            FROM dmpl__Tax__c
            WHERE Name = :name
            LIMIT 1
        ];
    }

    public static dmpl__TaxGroupRule__c createTaxGroupRule(
        String taxSupplyType,
        Id taxGroupId,
        Id itemId,
        Id itemGroupId,
        Id skuId,
        Id itemLotTypeId
    ) {
        return (dmpl__TaxGroupRule__c) TestFactory.createSObject(
            new dmpl__TaxGroupRule__c(
                dmpl__TaxSupplyType__c = taxSupplyType,
                dmpl__TaxGroupId__c = taxGroupId,
                dmpl__ItemId__c = itemId,
                dmpl__ItemGroupId__c = itemGroupId,
                dmpl__SKUId__c = skuId,
                dmpl__ItemLotTypeId__c = itemLotTypeId,
                dmpl__DateEffectiveFrom__c = Date.today().addDays(-1),
                dmpl__DateEffectiveTill__c = Date.today().addYears(1)
            ),
            true
        );
    }

    public static dmpl__TaxGroupRule__c getTaxGroupRule(Id taxGroupId) {
        return [
            SELECT 
                Id,
                Name,
                dmpl__TaxSupplyType__c,
                dmpl__TaxGroupId__c,
                dmpl__ItemId__c,
                dmpl__ItemGroupId__c,
                dmpl__SKUId__c,
                dmpl__ItemLotTypeId__c,
                dmpl__DateEffectiveFrom__c,
                dmpl__DateEffectiveTill__c
            FROM dmpl__TaxGroupRule__c
            WHERE dmpl__TaxGroupId__c = :taxGroupId
            LIMIT 1
        ];
    }
    
    public static dmpl__Resource__c createResource(
        String name,
        Id defaultPartnerAccountId,
        Id defaultBranchId,
        Boolean isActive
    ) {
        return (dmpl__Resource__c) TestFactory.createSObject(
            new dmpl__Resource__c(
                Name = name,
                dmpl__DefaultPartnerAccountId__c = defaultPartnerAccountId,
                dmpl__DefaultBranchId__c = defaultBranchId,
                dmpl__IsActive__c = isActive
            ),
            'ResourceDefaults',
            true
        );
    }
 
    public static dmpl__Resource__c getResource(String name) {
        return [
            SELECT
            Id,
            Name,
            dmpl__DefaultPartnerAccountId__c,
            dmpl__DefaultBranchId__c,
            dmpl__IsActive__c
            FROM dmpl__Resource__c
            WHERE Name = :name
            LIMIT 1
        ];
    }

    public static dmpl__SKU__c createSKU(String name,Id item , Boolean isDefault) {
        return (dmpl__SKU__c) TestFactory.createSObject(
            new dmpl__SKU__c(
                Name = name,
                dmpl__IsDefault__c = isDefault,
                dmpl__ItemId__c = item
            ),
            'SKUDefaults',
            true
        );
    }
 
    public static dmpl__SKU__c getSKU(String name) {
        return [
            SELECT Id, Name, dmpl__ItemId__c, dmpl__IsDefault__c
            FROM dmpl__SKU__c
            WHERE Name = :name
            LIMIT 1
        ];
    }

    public static Contact createContact(
        String lastName,
        String phone,
        String homePhone,
        Id accountId
    ) {
        return (Contact)TestFactory.createSObject(
            new Contact(
                LastName = lastName,
                Phone = phone,
                HomePhone = homePhone,
                AccountId = accountId
            ),
            'ContactDefaults',
            true
        );
    }

    public static Contact getContact(String lastName) {
        return [
            SELECT Id, LastName, Phone, HomePhone, AccountId
            FROM Contact
            WHERE LastName = :lastName
            LIMIT 1
        ];
    }

    public static Asset createAsset(String name, Id accountId, Id itemId) {
        return (Asset) TestFactory.createSObject(
            new Asset(
                Name = name,
                AccountId = accountId,
                dmpl__ItemId__c = itemId,
                dmpl__SaleDate__c = Date.newInstance(2025, 1, 6)
            ),
            'AssetDefaults',
            true
        );
    }

    public static Asset getAsset(String name) {
        return [
            SELECT Id, Name, AccountId, dmpl__ItemId__c, dmpl__SaleDate__c
            FROM Asset 
            WHERE Name = :name
            LIMIT 1
        ];
    }

    public static dmpl__StorageLocation__c createStorageLocation(
        String name,
        Id branchId,
        Boolean isActive,
        String locationType
    ) {
        return (dmpl__StorageLocation__c) TestFactory.createSObject(
            new dmpl__StorageLocation__c(
                Name = name,
                dmpl__BranchId__c = branchId,
                dmpl__IsActive__c = isActive,
                dmpl__LocationType__c = locationType
            ),
            'StorageLocationDefaults',
            true
        );
    }

    public static dmpl__StorageLocation__c getStorageLocation(String name) {
        return [
            SELECT Id, Name, dmpl__BranchId__c, dmpl__IsActive__c, dmpl__LocationType__c
            FROM dmpl__StorageLocation__c
            WHERE Name = :name
            LIMIT 1
        ];
    }
    
   
}