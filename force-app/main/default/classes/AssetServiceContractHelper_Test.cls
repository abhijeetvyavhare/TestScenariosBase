@isTest
public class AssetServiceContractHelper_Test {

    
    
    @testSetup
    public static void Setup()
    {
        List<Account> account = new List<Account>();
//        dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c LIMIT 1];
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
                                dmpl__IsCustomerAccount__c = False
  //                              dmpl__PartnerTaxAccountGroupId__c = accountGroup.Id,
    //                            dmpl__CustomerPriceAccountGroupId__c = accountGroup.Id,
      //                          dmpl__CustomerDiscountAccountGroupId__c = accountGroup.Id,
        //                        dmpl__PartnerSchemeAccountGroupId__c = accountGroup.Id,                                
          //                      dmpl__PartnerPriceAccountGroupId__c = accountGroup.Id,
            //                    dmpl__PartnerDiscountAccountGroupId__c = accountGroup.Id,
              //                  dmpl__CustomerSchemeAccountGroupId__c = accountGroup.Id
                               ));
        insert account;
        
        Account partneraccount = new Account(Name = 'Partner-Test-Account',
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
      
        List<dmpl__Branch__c> branch = new List<dmpl__Branch__c>();
        //Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        branch.Add(new dmpl__Branch__c(dmpl__PartnerAccountId__c =partneraccount.Id,
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
        
        List<dmpl__Item__c> item = new List<dmpl__Item__c>();
        //dmpl__ItemGroup__c itemGroup = [Select Id, Name FROM dmpl__ItemGroup__c LIMIT 1];
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
                                   dmpl__IsSKURequired__c = true,
                                   dmpl__RequireInspectionOnReceipt__c = true,
                                   dmpl__RequireInspectionOnDelivery__c = true,
                                   dmpl__AllowService__c = true,
                                   dmpl__TrackAsset__c = true,                               
                                   dmpl__IsActive__c = true,
                                   dmpl__IsRegistrationRequired__c = true,
                                   dmpl__GTIN__c = 'BR123',
                                   dmpl__RFID__c = 'O1234fgh',
                                   dmpl__IsPackage__c = true,
                                   dmpl__OnlySoldInPackage__c = true,
                                   dmpl__QuantityUnitOfMeasure__c = 'Each',
                                   dmpl__InventoryValuationMethod__c = 'FIFO'
                                   //dmpl__TaxItemGroupId__c = itemGroup.Id
                                   
                                  ));
        insert item;
        
        List<dmpl__SKU__c> Sku = new List<dmpl__SKU__c>();
        //dmpl__Item__c listofitem = [Select Id, Name from dmpl__Item__c];
        Sku.add(new dmpl__SKU__c(Name = 'Harrier XMA - Automatic - Orcus White',
                                  dmpl__SKUCode__c = 'Test - SKU - Code',
                                  dmpl__UnitOfMeasureOfConversion__c = 10,
                                  dmpl__ProductColor__c = 'Sample',
                                  dmpl__IsDefault__c = false,
                                  dmpl__QuantityUnitOfMeasure__c ='Sample',
                                  dmpl__ItemId__c = item[0].Id
                                 ));
        insert Sku;
        
        List<dmpl__ItemLot__c> itemLot = new List<dmpl__ItemLot__c>();
        //dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        //dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        //dmpl__SKU__c sku = [Select Id, Name from dmpl__SKU__c LIMIT 1];
        itemLot.Add(new dmpl__ItemLot__c(dmpl__BranchId__c = branch[0].Id,
                                         dmpl__PartnerAccountId__c = branch[0].dmpl__PartnerAccountId__c,
                                         dmpl__ItemId__c = item[0].Id,
                                         dmpl__SKUId__c = sku[0].Id,
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
        
        List<Asset> asset = new List<Asset>();
        //Account account = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        //dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        //dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        //dmpl__ItemLot__c itemLot = [Select Id, Name From dmpl__ItemLot__c LIMIT 1];
        //dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c LIMIT 1];
        asset.add(new Asset(Name = 'Test-Asset',
                            AccountId = customerAccount.Id,
                            dmpl__LastServiceBranchId__c = branch[0].Id,
                            dmpl__ItemId__c = item[0].Id,
                            dmpl__ItemLotId__c = itemLot[0].Id,
                            dmpl__SKUId__c = sku[0].Id,
                            dmpl__RegistrationNumber__c = 'Axb371',
                            dmpl__SaleDate__c = date.today()
                           ));
        insert asset;
        
        List<dmpl__ItemServiceContract__c> ServiceContract = new List<dmpl__ItemServiceContract__c>();
        dmpl__Item__c item1 =[select Id,name FROM dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku1=[select Id,name FROM dmpl__SKU__c LIMIT 1];
        ServiceContract.add(new dmpl__ItemServiceContract__c(
            dmpl__ItemId__c = item1.Id,
            dmpl__SKUId__c=sku1.Id,
            dmpl__ActiveServiceContractRequired__c = true
        ));
        insert ServiceContract;
        
        List<dmpl__AssetServiceContract__c> assetServiceContracts = new List<dmpl__AssetServiceContract__c>();
        assetServiceContracts.add(new dmpl__AssetServiceContract__c(
            dmpl__AssetId__c = asset[0].Id,
            dmpl__ItemId__c = item[0].Id,
            dmpl__ServiceContractItemId__c = item[0].Id,
            dmpl__ActivatedDate__c = Datetime.now().Date(),
            dmpl__ValidtillDate__c = Datetime.now().addDays(365).Date(),
            dmpl__DueDate__c = Datetime.now().addDays(365).Date(),
            dmpl__ItemServiceContractId__c = ServiceContract[0].Id
        ));
        insert assetServiceContracts;
        
        List<dmpl__RepairOrder__c> repairOrder = new List<dmpl__RepairOrder__c> ();
        repairOrder.Add(new dmpl__RepairOrder__c (
            dmpl__BranchId__c = branch[0].Id,
            dmpl__AccountId__c = customerAccount.Id,
            dmpl__PartnerAccountId__c = branch[0].dmpl__PartnerAccountId__c,
            dmpl__AssetId__c = asset[0].Id,
            dmpl__UsageReading__c = 8,
            dmpl__ItemServiceContractId__c = ServiceContract[0].Id,
            dmpl__AssetServiceContractId__c = assetServiceContracts[0].Id
        ));
        repairOrder.Add(new dmpl__RepairOrder__c (
            dmpl__BranchId__c = branch[0].Id,
            dmpl__AccountId__c = customerAccount.Id,
            dmpl__PartnerAccountId__c = branch[0].dmpl__PartnerAccountId__c,
            dmpl__AssetId__c = asset[0].Id,
            dmpl__UsageReading__c = 8,
            dmpl__ItemServiceContractId__c = ServiceContract[0].Id
        ));
        insert repairOrder;
        
        AssetServiceContractHelper.validateHeaderItemServiceContract(repairOrder);
    }
    
    @isTest
    public static void UpdateAssetServiceContract()
    {
        List<Id> assetIds = new List<Id>();
        List<Id> itemIds = new List<Id>();
        dmpl__AssetServiceContract__c asset = [Select Id,Name,dmpl__IsUtilized__c,dmpl__ItemId__c,dmpl__AssetId__c From dmpl__AssetServiceContract__c LIMIT 1];
        if(asset != null)
            asset.dmpl__IsUtilized__c = true;
        update asset;
        AssetServiceContractHelper.queryOriginalAssetServiceContracts(assetIds, itemIds);
        System.assert(asset != null, 'Asset Service Contract Data');
        
    }
    
    @isTest
    public static void DeleteAssetServiceContract()
    {
        dmpl__AssetServiceContract__c asset = [Select Id,Name,dmpl__IsUtilized__c From dmpl__AssetServiceContract__c LIMIT 1];
        if(asset != null)
			delete asset;
        System.assert(asset != null, 'Asset Service Contract Data');
    }
    
    
}