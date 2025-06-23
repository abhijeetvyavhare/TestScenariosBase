@isTest
public class RepairOrderDataFactory_Test {

    public static void data()
    {
        dmpl__AccountGroup__c accountGroup= new dmpl__AccountGroup__c (Name= 'Test-AccountGroup', 
                                                                       dmpl__AccountGroupType__c='Discount');
        insert accountGroup;
    
        List<Account> account = new List<Account>();
        account.add(new Account(Name = 'Test - Account',
                                dmpl__LastName__c = 'Cycle Count',
                                Fax = '09876',
                                Phone = '1234567891',
                                Website = 'www.Dealermatix.com',
                                Type = 'Prospect',
                                NumberOfEmployees = 2,
                                Industry = 'Education',
                                AnnualRevenue = 1000,
                                Description = 'Accounts added',
                                dmpl__IsPartnerAccount__c = false,
                                dmpl__IsActive__c = True,
                                dmpl__IsTaxExempted__c = True,
                                dmpl__IsSupplierAccount__c = false,
                                dmpl__IsCustomerAccount__c = False,
                                dmpl__PartnerTaxAccountGroupId__c = accountGroup.Id,
                                dmpl__CustomerPriceAccountGroupId__c = accountGroup.Id,
                                dmpl__CustomerDiscountAccountGroupId__c = accountGroup.Id,
                                dmpl__PartnerSchemeAccountGroupId__c = accountGroup.Id,                                
                                dmpl__PartnerPriceAccountGroupId__c = accountGroup.Id,
                                dmpl__PartnerDiscountAccountGroupId__c = accountGroup.Id,
                                dmpl__CustomerSchemeAccountGroupId__c = accountGroup.Id
                               ));
        insert account;
        
        
        Account partnerAccount = new Account(Name = 'Partner-Test-Account',
                                             dmpl__LastName__c = 'Cycle Count',
                                             dmpl__IsPartnerAccount__c = True, 
                                             dmpl__IsActive__c = true);
        insert partneraccount;
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__LastName__c = 'Cycle Count',
                                              dmpl__IsCustomerAccount__c = True,
                                              dmpl__IsActive__c = true);
        insert customerAccount;
        
        Account supplierAccount = new Account(Name = 'Supplier-Test-Account',
                                              dmpl__LastName__c = 'Cycle Count',
                                              dmpl__IsSupplierAccount__c = True,
                                              dmpl__IsActive__c = true);
        insert supplierAccount;
        
        dmpl__AccountGroupMember__c partnerAccountGroupMember = new dmpl__AccountGroupMember__c
            (dmpl__AccountGroupId__c=accountGroup.Id,
             dmpl__AccountId__c=partneraccount.Id
            );
        Insert partnerAccountGroupMember;
        
        dmpl__AccountGroupMember__c customerAccountGroupMember = new dmpl__AccountGroupMember__c
            (dmpl__AccountGroupId__c=accountGroup.Id,
             dmpl__AccountId__c=customerAccount.Id
            );
        Insert customerAccountGroupMember;
        
        List<dmpl__Branch__c> branch = new List<dmpl__Branch__c>();
        branch.Add(new dmpl__Branch__c(dmpl__PartnerAccountId__c = partnerAccount.Id,
                                       Name = 'Test-Branch',
                                       dmpl__IsActive__c = true,
                                       dmpl__MarketingName__c = 'Hero Electric',
                                       dmpl__Website__c = 'www.dealermatix.com',
                                       dmpl__Email__c = 'Dealer@Outlook.com',
                                       dmpl__MobileNumber__c = 99,
                                       dmpl__Phone__c = '8888888888',
                                       dmpl__AllowSales__c = true,
                                       dmpl__AllowService__c = true,
                                       dmpl__AllowPurchase__c = true,
                                       dmpl__AllowInventory__c = true,
                                       dmpl__IsHomeDeliveryAvailable__c = true,
                                       dmpl__IsPickupDropAvailable__c = true,
                                       dmpl__SalesPhone__c = '7777777777',
                                       dmpl__ServiceEmail__c = 'Customer@Outlook.com'));
        insert branch;
        
        List<dmpl__StorageLocation__c> storageLocation =  new List<dmpl__StorageLocation__c>();
        storageLocation.Add(new dmpl__StorageLocation__c(dmpl__BranchId__c = branch[0].Id,
                                                         dmpl__ParentLocationId__c = branch[0].dmpl__ParentLocationId__c,
                                                         dmpl__AllowInventory__c=true,
                                                         dmpl__IsMobile__c=true,
                                                         dmpl__IsActive__c=true,
                                                         dmpl__LocationType__c='Washing Bay'));
        insert storageLocation;
        
        List<dmpl__Item__c> item = new List<dmpl__Item__c>();
        item.Add(new dmpl__Item__c(Name = 'Test-Item',
                                   dmpl__ItemCode__c = 'DMPL',
                                   dmpl__ItemType__c = 'Service Contract',
                                   dmpl__ItemSubType__c = 'None',
                                   dmpl__Description__c = 'Description',
                                   dmpl__ItemFamily__c = 'Sample',
                                   dmpl__ItemSegment__c = 'Sample',
                                   dmpl__Make__c = 'Sample',
                                   dmpl__Model__c = 'Sample',
                                   dmpl__TrackInventory__c = true,
                                   dmpl__TrackLots__c = true,
                                   //dmpl__IsSKURequired__c = true,
                                   dmpl__RequireInspectionOnReceipt__c = true,
                                   dmpl__RequireInspectionOnDelivery__c = true,
                                   dmpl__AllowService__c = true,
                                   dmpl__TrackAsset__c = true,                               
                                   dmpl__IsActive__c = true,
                                   dmpl__IsRegistrationRequired__c = true,
                                   dmpl__GTIN__c = 'BR123',
                                   dmpl__RFID__c = 'O1234fgh',
                                   dmpl__IsPackage__c = true,
                                   dmpl__QuantityUnitOfMeasure__c = 'Each',
                                   dmpl__InventoryValuationMethod__c = 'FIFO'
                                   
                                  ));
        insert item;
        
        List<dmpl__SKU__c> skus = new List<dmpl__SKU__c>();
        skus.add(new dmpl__SKU__c(Name = 'Harrier XMA - Automatic - Orcus White',
                                  dmpl__SKUCode__c = 'Test - SKU - Code',
                                  dmpl__UnitOfMeasureOfConversion__c = 10,
                                  dmpl__ProductColor__c = 'Sample',
                                  dmpl__IsDefault__c = false,
                                  dmpl__QuantityUnitOfMeasure__c ='Sample',
                                  dmpl__ItemId__c = item[0].Id
                                 ));
        insert skus;
    
        List<dmpl__ItemLot__c> itemLot = new List<dmpl__ItemLot__c>();
        itemLot.Add(new dmpl__ItemLot__c(dmpl__BranchId__c = branch[0].Id,
                                         dmpl__PartnerAccountId__c = branch[0].dmpl__PartnerAccountId__c,
                                         dmpl__ItemId__c = item[0].Id,
                                         dmpl__SKUId__c = skus[0].Id,
                                         dmpl__BatchNo__c = '12345',
                                         dmpl__SerialNumber__c = '4675',
                                         dmpl__SupplierInvoiceNumber__c = '74985',
                                         dmpl__DateOfReceipt__c = date.today(),
                                         dmpl__DateOfMfg__c = date.today(),
                                         dmpl__TotalCost__c = 100,
                                         dmpl__DateOfSupplierInvoice__c = date.today(),
                                         dmpl__Cost__c = 100
                                       //dmpl__QuantityExpired__c = 1,
                                       //dmpl__QuantityOnHold__c = 1,
                                      // dmpl__QuantityOnLoan__c = 1
                                        ));
        insert itemLot;
        
        List<dmpl__ItemLot__c> relatedItemLot = new List<dmpl__ItemLot__c>();
        relatedItemLot.Add(new dmpl__ItemLot__c(dmpl__LandedCost__c = 1000));
        insert relatedItemLot;
        
         List<dmpl__Resource__c> resource = new List<dmpl__Resource__c>();
        resource.add(new dmpl__Resource__c(Name = 'Test - Resource',
                                           dmpl__ResourceType__c = 'Service Advisor',
                                           dmpl__IsActive__c = true,
                                           dmpl__Phone__c = '9999999999',
                                           dmpl__DefaultPartnerAccountId__c = branch[0].dmpl__PartnerAccountId__c,
                                           dmpl__DefaultBranchId__c = branch[0].Id
                                          ));
        insert resource;
        
        List<dmpl__Resource__c> technicianResource = new List<dmpl__Resource__c>();
        technicianResource.add(new dmpl__Resource__c(Name = 'Test - Resource',
                                                     dmpl__ResourceType__c = 'Technician',
                                                     dmpl__IsActive__c = true,
                                                     dmpl__Phone__c = '9999999999',
                                                     dmpl__DefaultPartnerAccountId__c = branch[0].dmpl__PartnerAccountId__c,
                                                     dmpl__DefaultBranchId__c = branch[0].Id
                                                    ));
        insert technicianResource;
        
        List<dmpl__PriceList__c> priceList =new List<dmpl__PriceList__c>();
        priceList.Add(new dmpl__PriceList__c(dmpl__PartnerAccountId__c = partnerAccount.Id,
                                             dmpl__BranchId__c = branch[0].Id,
                                             dmpl__PartnerAccountGroupId__c = accountGroup.Id,
                                             dmpl__PartnerGroupId__c = accountGroup.Id,
                                             dmpl__CustomerAccountGroupId__c= accountGroup.Id,
                                             dmpl__CustomerGroupId__c = accountGroup.Id,
                                             Name='Test-1',
                                             dmpl__PriceListType__c = 'Sale Price',
                                             dmpl__IsActive__c = true,
                                             dmpl__IsDefault__c = true
                                            ));
        
        
        priceList.Add(new dmpl__PriceList__c(
            Name='Test-2'
        ));
        insert priceList;
        
        List<Asset> asset = new List<Asset>();
        asset.add(new Asset(Name = 'Test-Asset',
                            AccountId = customerAccount.Id,
                            dmpl__LastServiceBranchId__c = branch[0].Id,
                            dmpl__ItemId__c = item[0].Id,
                            dmpl__SKUId__c = skus[0].Id,
                            dmpl__IsPDIDone__c=true,
                            dmpl__RegistrationNumber__c = 'Axb371',
                            dmpl__SaleDate__c = date.today()
                           ));
        insert asset;
        
        dmpl__ItemServiceContract__c itemServiceContract = new dmpl__ItemServiceContract__c(dmpl__ItemId__c = item[0].Id,
                                                                   Name = 'Item Service Contract',
                                                                   dmpl__PopulateContractLines__c = true,
                                                                   dmpl__SKUId__c = skus[0].Id,
                                                                   dmpl__ServiceType__c = 'Paid Repairs'                         
                                                                  );
        insert itemServiceContract;
        
        List<dmpl__AssetServiceContract__c> assetServiceContracts = new List<dmpl__AssetServiceContract__c>();
        assetServiceContracts.add(new dmpl__AssetServiceContract__c(
            dmpl__AssetId__c = asset[0].Id,
            dmpl__ItemId__c = item[0].Id,
            dmpl__ServiceContractItemId__c = item[0].Id,
            dmpl__ItemServiceContractId__c = itemServiceContract.Id,
            dmpl__ActivatedDate__c = Datetime.now().Date(),
            dmpl__DueDate__c = Datetime.now().addDays(365).Date()
        ));
        insert assetServiceContracts;
        
        dmpl__Item__c workItem = new dmpl__Item__c(
            Name = 'Washing', 
            dmpl__ItemCode__c = 'Washing', 
            dmpl__ItemType__c = 'Work Item',
            dmpl__IsActive__c = true);
        
        insert workItem;
        
        dmpl__Item__c serviceItem = new dmpl__Item__c(
            Name = 'Washing', 
            dmpl__ItemCode__c = 'Washing', 
            dmpl__ItemType__c = 'Service Contract',
            dmpl__IsActive__c = true);
        
        insert serviceItem;
        
        dmpl__AssetServiceContractLine__c assetServiceContractLine = new dmpl__AssetServiceContractLine__c(
            dmpl__AssetServiceContractId__c = assetServiceContracts[0].Id,
            dmpl__ComponentItemId__c = workItem.Id,
            dmpl__Quantity__c = 1,
            dmpl__UtilizedQuantity__c = 0);
        
        insert assetServiceContractLine;
        
        List<dmpl__TaxGroup__c> taxGroup = new List<dmpl__TaxGroup__c>();
        taxGroup.Add(new dmpl__TaxGroup__c(Name = 'Test - Tax Group',
                                           dmpl__PartnerAccountId__c = partnerAccount.Id,
                                           dmpl__BranchId__c = branch[0].Id,
                                           dmpl__PartnerAccountGroupId__c = accountGroup.Id,
                                           dmpl__Description__c = 'Test-Description',
                                           dmpl__IsActive__c = true));
        insert taxGroup;
        
        List<dmpl__Tax__c> tax = new List<dmpl__Tax__c>();
        tax.Add(new dmpl__Tax__c(Name = 'Test - Tax',
                                 dmpl__Rate__c = 10,
                                 dmpl__TaxGroupId__c = taxGroup[0].Id,
                                 dmpl__Type__c = 'Cess'
                                ));        
        insert tax;
        
        List<dmpl__TaxGroupRule__c> rule = new List<dmpl__TaxGroupRule__c>();
        rule.add(new dmpl__TaxGroupRule__c(dmpl__DateEffectiveFrom__c = date.today(),
                                           dmpl__ItemId__c = item[0].Id,
                                           dmpl__ItemLotTypeId__c = null,
                                           dmpl__TaxGroupId__c = taxGroup[0].Id
                                          ));
        insert rule;
    }
}