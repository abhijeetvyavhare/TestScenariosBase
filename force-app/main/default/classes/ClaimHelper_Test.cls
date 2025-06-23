@isTest
public class ClaimHelper_Test {
    
    @testSetup
    public static void Setup()
    {
        //System.runAs(PostInstallHelper.AssignAdministratorAllPermissions(UserInfo.getUserId())){
            CreateAccountGroup();
            CreateAccount();
            CreateBranch();
            CreateStorageLocation();
            CreateItemGroup();
            CreateItem();
            CreateSKU();
            CreateResource(); 
            CreateItemLot();
            CreateAsset();
            CreateClaim();
            CreateClaimLine();
        //}
    }
   
    
    private static void createRepairOrderLine(String postingType)
    {
        //test.startTest();
        List<dmpl__RepairOrderLine__c> repairOrderLine = new List<dmpl__RepairOrderLine__c>();
        dmpl__RepairOrder__c repairOrder = [Select Id,Name FROM dmpl__RepairOrder__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name FROM dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c LIMIT 1];
        dmpl__Resource__c resource = [select Id,Name FROM dmpl__Resource__c WHERE dmpl__ResourceType__c = 'Technician' LIMIT 1];
        dmpl__StorageLocation__c storageLocation = [Select Id,Name FROM dmpl__StorageLocation__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        //dmpl__AssetServiceContract__c assetServiceContract = [Select Id,Name From dmpl__AssetServiceContract__c LIMIT 1];
        dmpl__ItemServiceContract__c itemServiceContract = [Select Id,Name From dmpl__ItemServiceContract__c LIMIT 1];
        repairOrderLine.add(new dmpl__RepairOrderLine__c(dmpl__ItemId__c = item.Id,
                                                         dmpl__Quantity__c = 5,
                                                         dmpl__CancelledQuantity__c=3,
                                                         dmpl__SKUId__c=sku.Id,
                                                         dmpl__UnitPrice__c = 10,
                                                         dmpl__PackageClassification__c = 'Optional Item',
                                                         dmpl__ActionTaken__c = 'Replace',
                                                         dmpl__TechnicianId__c = resource.Id,
                                                         dmpl__WorkStartedBy__c = date.today(),
                                                         dmpl__WorkEndedAt__c = date.today(),
                                                         dmpl__WorkStatus__c = 'Started',
                                                         dmpl__StandardDurationHours__c = 10,
                                                         dmpl__ActualDurationHours__c = 10,
                                                         //dmpl__IsClaimed__c = true,
                                                         dmpl__ItemServiceContractId__c = itemServiceContract.Id,
            											 //dmpl__AssetServiceContractLineId__c = assetServiceContract.Id,
                                                         dmpl__StorageLocationId__c = storageLocation.Id,
                                                         dmpl__TaxGroupId__c = taxGroup.Id,
                                                         dmpl__RepairOrderId__c = repairOrder.Id,
                                                         dmpl__PostingType__c = postingType,
                                                         dmpl__FulfilmentOrderQuantity__c = 1
                                                        ));
        insert repairOrderLine;
        //test.stopTest();
    }
    
    @isTest
    public static void createSaleInvoiceDocument1()
    {
        Test.startTest();
        string errorReceived;
        try{             
            CreateClaimBatch();
            CreateSaleInvoice();
            dmpl__ClaimBatch__c claims =[select Id, Name,dmpl__SupplierNameId__c,dmpl__DocumentDate__c,dmpl__PartnerAccountId__c,dmpl__BranchId__c from dmpl__ClaimBatch__c Limit 1];
            List<dmpl__SaleInvoice__c> invoice=[select Id,Name,dmpl__ClaimBatchId__c from dmpl__SaleInvoice__c];
            Map<Id,dmpl__ClaimBatch__c> batch=new Map<Id,dmpl__ClaimBatch__c>();
            batch.put(claims.Id,claims);
            SaleInvoiceLineHelper.createSaleInvoiceLinesFromClaimBatch(invoice,batch,null);
            SaleInvoiceHelper.createSaleInvoiceDocument(claims);
        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
       // System.assertEquals(null, errorReceived);
        test.stopTest();        
    }
    
    @isTest
    public static void createAdjustmentNeww()
    {
        Test.startTest();
        string errorReceived;
        try{             
            CreateClaimBatch();
            dmpl__ClaimBatch__c claims =[select Id, Name,dmpl__SupplierNameId__c,dmpl__DocumentDate__c,dmpl__PartnerAccountId__c,dmpl__BranchId__c from dmpl__ClaimBatch__c Limit 1];
            ClaimLineHelper.populateClaimLinesInClaimBatch(new List<dmpl__ClaimBatch__c>{claims});
            InventoryAdjustmentHelper.createAdjustment(claims);    
        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
        System.assertEquals(null, errorReceived);
        test.stopTest();        
    }
    
    @isTest
    public static void createAdjustmentNew()
    {
        Test.startTest();
        string errorReceived;
        try{             
            CreateClaimBatch();
            dmpl__Claim__c claims =[select Id, Name,dmpl__DocumentDate__c,dmpl__PartnerAccountId__c,dmpl__BranchId__c,dmpl__RejectAll__c from dmpl__Claim__c Limit 1];
            claims.dmpl__RejectAll__c = true;
            update claims;
            InventoryAdjustmentHelper.createAdjustment(claims);
            System.assert(claims != null, 'Claim Data');
            
            List<SourceObjectInfo> info = new List<SourceObjectInfo>();
            ClaimHelper.createClaims(info);
        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
        
        test.stopTest();        
    } 
    @isTest
    public static void createSaleInvoiceDocument()
    {
        Test.startTest();
        string errorReceived;
        try{            
            dmpl__Claim__c claims =[select Id, Name,dmpl__ApproveAll__c,dmpl__SupplierNameId__c,dmpl__DocumentDate__c,dmpl__RepairOrderId__c,dmpl__PartnerAccountId__c,dmpl__BranchId__c,dmpl__RejectAll__c from dmpl__Claim__c Limit 1];
            SaleInvoiceHelper.createSaleInvoiceDocument(claims);    
            claims.dmpl__ApproveAll__c = true;
            update claims;
            
        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
        System.assertEquals(null, errorReceived);
        test.stopTest();
    }
    
    @isTest
    public static void markAllClaimLines()
    {
        Test.startTest();
        string errorReceived;
        try{             
            dmpl__Claim__c claims =[select Id, Name,dmpl__ApproveAll__c,dmpl__RejectAll__c from dmpl__Claim__c Limit 1];
            Map<Id, dmpl__Claim__c> mapclaims = new Map<Id, dmpl__Claim__c>();
            mapclaims.put(claims.Id,claims);
            ClaimLineHelper.markAllClaimLines(mapclaims);  
            claimHelper.queryClaimDocument(claims.Id);
        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
        System.assertEquals(null, errorReceived);
        test.stopTest();   
    }
    
    @isTest
    public static void testCreateClaim(){
        Test.startTest();
        Account acc=[select id from account limit 1];
        dmpl__Branch__c br=[select id from dmpl__Branch__c limit 1];
		dmpl__RepairOrder__c re=new dmpl__RepairOrder__c(
                                           dmpl__AccountId__c = acc.id,
                                           dmpl__BranchId__c = br.id
                                          );     
        ClaimHelper.createClaims(re.id);
        Test.stopTest();
    }
    
    @isTest
    public static void UpdateClaim()
    {
        Test.startTest();
        string errorReceived;
        try{             
            CreatePurchaseOrder();
            CreateGoodsReceipt();
            dmpl__Claim__c claim = [Select Id,Name,dmpl__PerformPopulateLines__c From dmpl__Claim__c Where dmpl__ClaimType__c = 'Purchase' LIMIT 1];
            claim.dmpl__PerformPopulateLines__c = True;
            update claim;    
            System.assertEquals(true, claim.dmpl__PerformPopulateLines__c, 'Test claim have 1 updated record');
        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
        System.assertEquals(null, errorReceived);
        Test.stopTest();
    }
    
    @isTest
    public static void UpdateClaim1()
    {
        Test.startTest();
        string errorReceived;
        try{             
            CreatePurchaseOrder();
            CreateGoodsReceipt();
            dmpl__Claim__c claim = [Select Id,Name,dmpl__PerformPopulateLines__c From dmpl__Claim__c Where dmpl__ClaimType__c = 'Damaged' LIMIT 1];
            claim.dmpl__PerformPopulateLines__c = True;
            update claim;    
            System.assertEquals(true, claim.dmpl__PerformPopulateLines__c, 'Test claim have 1 updated record');
        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
        //System.assert(claim != null, 'Claim  Data');
        Test.stopTest();
    }
    
    @isTest
    public static void UpdateClaim2()
    {
        Test.startTest();
        string errorReceived;
        try{             
            CreatePurchaseOrder();
            CreateGoodsReceipt();
            dmpl__Claim__c claim = [Select Id,Name,dmpl__PerformPopulateLines__c From dmpl__Claim__c Where dmpl__ClaimType__c = 'Shortage' LIMIT 1];
            claim.dmpl__PerformPopulateLines__c = True;
            update claim;    
            System.assertEquals(true, claim.dmpl__PerformPopulateLines__c, 'Test claim have 1 updated record');
        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
        //System.assert(claim != null, 'Claim  Data');
        Test.stopTest();
    }
    
    @isTest
    public static void UpdateClaim3()
    {
        Test.startTest();
        string errorReceived;
        try{             
            CreatePurchaseOrder();
            CreateGoodsReceipt();
            dmpl__Claim__c claim = [Select Id,Name,dmpl__PerformPopulateLines__c From dmpl__Claim__c Where dmpl__ClaimType__c = 'Excess' LIMIT 1];
            claim.dmpl__PerformPopulateLines__c = True;
            update claim;    
            System.assertEquals(true, claim.dmpl__PerformPopulateLines__c, 'Test claim have 1 updated record');
        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
        //System.assert(claim != null, 'Claim  Data');
        Test.stopTest();
    }
    
    @isTest
    public static void UpdateClaimAsService()
    {
        Test.startTest();
        string errorReceived;
        try{             
            CreateRepairOrder();              
            CreateRepairOrderLine();
            dmpl__Claim__c claim = [Select Id,Name,dmpl__PerformPopulateLines__c From dmpl__Claim__c Where dmpl__ClaimType__c = 'Service' LIMIT 1];
            claim.dmpl__PerformPopulateLines__c = True;
            update claim;
            System.assertEquals(true, claim.dmpl__PerformPopulateLines__c, 'Test claim have 1 updated record');
        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
        System.assertEquals(null, errorReceived);
        Test.stopTest();
    }
    
    @isTest
    public static void UpdateClaimnew()
    {
        try{
            Test.startTest();
            List<dmpl__Claim__c> claims = [Select Id,Name,dmpl__PerformReconciliation__c From dmpl__Claim__c];
            for(dmpl__Claim__c claim : claims)
                claim.dmpl__PerformReconciliation__c = True;
            
            update claims;
            Test.stopTest();       
            System.assertEquals(claims.size(), claims.size(), 'Test claim have 1 updated record');
        }catch(exception e){}
    }
    
    @isTest
    public static void UpdateClaimBatch()
    {
        Test.startTest();
        dmpl__ClaimBatch__c claimsBatch = [Select Id,Name,dmpl__PerformPopulateClaimLines__c From dmpl__ClaimBatch__c];
        claimsBatch.dmpl__PerformPopulateClaimLines__c = True;
        update claimsBatch;
        Test.stopTest();
        System.assert(claimsBatch!=null, 'Test claim have 1 updated record');
    }
    
    @isTest
    public static void UpdateClaimBatchNew()
    {
        Test.startTest();
        dmpl__ClaimBatch__c claimsBatch = [Select Id,Name,dmpl__PerformReconciliation__c From dmpl__ClaimBatch__c];
        claimsBatch.dmpl__PerformReconciliation__c = True;
        update claimsBatch;
        Test.stopTest();
        System.assert(claimsBatch!=null, 'Test claim have 1 updated record');
    }
    
    @isTest
    public static void DeleteClaimBatch()
    {
        Test.startTest();
        dmpl__ClaimBatch__c claimsBatch = [Select Id,Name,dmpl__Status__c From dmpl__ClaimBatch__c];
        claimsBatch.dmpl__Status__c = 'Draft';
        delete claimsBatch;
        Test.stopTest();
        System.assert(claimsBatch!=null, 'Test claim have 1 updated record');
    }
    
    @isTest
    public static void UpdateClaimLine()
    {
        Test.startTest();
        string errorReceived;
        try{             
            List<dmpl__Claim__c> claim = [Select Id,Name From dmpl__Claim__c];
            ClaimLineHelper.markIsReconciliationCreated(claim);
        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
        System.assertEquals(null, errorReceived);
        Test.stopTest();
    }
    
    @isTest
    public static void updateClaimLineNew()
    {
        Test.startTest();
        List<dmpl__ClaimLine__c> claim = [Select Id,Name,dmpl__ClaimType__c From dmpl__ClaimLine__c];
        if(claim.size() != null)
            update claim;
        SaleInvoiceHelper.canCreateSaleInvoice(claim);
        System.assert(claim != null, 'claim line is updated');
        Test.stopTest();
    }
    
    @isTest
    public static void deleteClaimLine()
    {
        Test.startTest();
        dmpl__ClaimLine__c claim = [Select Id,Name From dmpl__ClaimLine__c];
        if(claim != null)
            delete claim;
        
        List<dmpl__ItemServiceContract__c> item = [Select Id,Name From dmpl__ItemServiceContract__c LIMIT 1];
        List<dmpl__AssetServiceContract__c> asset = [Select Id,Name,dmpl__AssetId__c,dmpl__BillingAccountId__c,dmpl__ItemServiceContractId__c From dmpl__AssetServiceContract__c LIMIT 1];
        ClaimHelper.getBillingAccountId(asset, item, asset[0].dmpl__AssetId__c, asset[0].dmpl__BillingAccountId__c, asset[0].dmpl__ItemServiceContractId__c);
        System.assert(claim != null, 'claim line is deleted');
        Test.stopTest();
    }
    
    @isTest
    private static void verifyRepairOrder()
    {
      //  List<dmpl__RepairOrder__c> repairOrders = [Select Id,Name From dmpl__RepairOrder__c];
      //  List<dmpl__RepairOrderLine__c> repairOrderLines = [Select Id,Name From dmpl__RepairOrderLine__c];
        List<Id> repairOrderIds = new List<Id>();
        ClaimLineHelper.queryRepairOrders(repairOrderIds,repairOrderIds);
    }
    
    
    // claimlinehelper test
    @isTest
    public static void createClaimLine2Test()
    {
        Test.startTest();
        CreateRepairOrder();
        CreateRepairOrderLine();        

        dmpl__Claim__c claim = [Select Id,Name From dmpl__Claim__c LIMIT 1];
        dmpl__RepairOrder__c repairOrders = [Select Id,Name,dmpl__BranchId__c From dmpl__RepairOrder__c LIMIT 1];
        dmpl__RepairOrderLine__c repairOrderLine = [Select Id,Name,dmpl__ItemId__c,dmpl__ItemServiceContractId__c,dmpl__RepairOrderId__c,dmpl__ClaimableQuantity__c,dmpl__UnitPrice__c,dmpl__ServiceContractWeightage2__c,dmpl__ServiceContractWeightage__c,dmpl__TechnicianId__c From dmpl__RepairOrderLine__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name FROM dmpl__Item__c LIMIT 1];
           
        ClaimLineHelper.createClaimLine(claim,repairOrders,repairOrderLine);
        ClaimLineHelper.createClaimLine2(claim,repairOrders,repairOrderLine,item.Id);
        ClaimLineHelper.createClaimLine3(claim,repairOrders,repairOrderLine,item.Id);

        Test.stopTest();
    }
    
    private static void CreateAccountGroup()
    {
        dmpl__AccountGroup__c accountGroup= new dmpl__AccountGroup__c (Name= 'Test-Account-Group', 
                                                                       dmpl__AccountGroupType__c = 'Scheme');
        insert accountGroup;
        
    }
    
    private static void CreateAccount()
    {
        List<Account> account = new List<Account>();
        dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c LIMIT 1];
        account.add(new Account(Name = 'Test - Account', 
                                Fax = '09876',
                                Phone = '1234567891',
                                Website = 'www.Dealermatix.com',
                                Type = 'Prospect',
                                dmpl__LastName__c = 'Account',
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
        
        
        Account partneraccount = new Account(Name = 'Partner-Test-Account',dmpl__IsPartnerAccount__c = true,dmpl__LastName__c = 'Account', dmpl__IsActive__c = true);
        insert partneraccount;
        
        
        Account supplieraccount = new Account(Name = 'Supplier-Test-Account',dmpl__IsSupplierAccount__c = true,dmpl__LastName__c = 'Account', dmpl__IsActive__c = true);
        insert supplieraccount;
        
        
        Account customeraccount = new Account(Name = 'Customer-Test-Account',dmpl__IsCustomerAccount__c = True,dmpl__LastName__c = 'Account', dmpl__IsActive__c = true);
        insert customeraccount;
        
    }
    
    private static void CreateBranch()
    {
        List<dmpl__Branch__c> branch = new List<dmpl__Branch__c>();
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        branch.Add(new dmpl__Branch__c(dmpl__PartnerAccountId__c =partnerAccount.Id,
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
        
    }
    
    private static void CreateItem()
    {
        List<dmpl__Item__c> item = new List<dmpl__Item__c>();
        item.Add(new dmpl__Item__c(Name = 'Test-Item',
                                   dmpl__ItemCode__c = 'DMPL',
                                   dmpl__ItemType__c = '',
                                   dmpl__ItemSubType__c = '',
                                   dmpl__Description__c = '',
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
                                   dmpl__IsPackage__c = true
                                  ));
        insert item;
        
        List<dmpl__Item__c> serviceItem = new List<dmpl__Item__c>();
        serviceItem.Add(new dmpl__Item__c(Name = 'Test-Item1',
                                          dmpl__ItemCode__c = 'DMPL1',
                                          dmpl__ItemType__c = 'Service Contract',
                                          dmpl__ItemSubType__c = '',
                                          dmpl__Description__c = '',
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
                                          dmpl__GTIN__c = 'BR1231',
                                          dmpl__RFID__c = 'O1234fgh1',
                                          dmpl__IsPackage__c = true
                                         ));
        insert serviceItem;
        
        
    }
    
    private static void CreateSKU()
    {
        List<dmpl__SKU__c> Skus = new List<dmpl__SKU__c>();
        dmpl__Item__c listofitem = [Select Id, Name from dmpl__Item__c Limit 1];
        Skus.add(new dmpl__SKU__c(Name = 'Harrier XMA - Automatic - Orcus White',
                                  dmpl__SKUCode__c = 'Test - SKU - Code',
                                  dmpl__UnitOfMeasureOfConversion__c = 10,
                                  dmpl__ProductColor__c = 'Sample',
                                  dmpl__IsDefault__c = false,
                                  dmpl__QuantityUnitOfMeasure__c ='Sample',
                                  dmpl__ItemId__c = listofitem.Id
                                 ));
        insert Skus;
        
    }
    
    
    private static void CreateResource()
    {
        List<dmpl__Resource__c> resource = new List<dmpl__Resource__c>();
        Account partnerAccount = [Select Id,Name From Account LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        resource.add(new dmpl__Resource__c(Name = 'Test - Resource',
                                           dmpl__ResourceType__c = 'Service Advisor',
                                           dmpl__IsActive__c = true,
                                           dmpl__Phone__c = '9999999999',
                                           dmpl__DefaultPartnerAccountId__c = partnerAccount.Id,
                                           dmpl__DefaultBranchId__c = branch.Id
                                          ));
        insert resource;
        
        List<dmpl__Resource__c> technicianResource = new List<dmpl__Resource__c>();
        technicianResource.add(new dmpl__Resource__c(Name = 'Test - Resource',
                                                     dmpl__ResourceType__c = 'Technician',
                                                     dmpl__IsActive__c = true,
                                                     dmpl__Phone__c = '9999999999',
                                                     dmpl__DefaultPartnerAccountId__c = partnerAccount.Id,
                                                     dmpl__DefaultBranchId__c = branch.Id
                                                    ));
        insert technicianResource;
    }
    private static void CreateAsset()
    {
        List<Asset> asset = new List<Asset>();
        Account account = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__ItemLot__c itemLot = [Select Id, Name From dmpl__ItemLot__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c LIMIT 1];
        asset.add(new Asset(Name = 'Test-Asset',
                            AccountId = account.Id,
                            dmpl__LastServiceBranchId__c = branch.Id,
                            dmpl__ItemId__c = item.Id,
                            dmpl__ItemLotId__c = itemLot.Id,
                            dmpl__SKUId__c = sku.Id,
                            dmpl__IsPDIDone__c=true,
                            dmpl__RegistrationNumber__c = 'Axb371',
                            dmpl__SaleDate__c = date.today()
                           ));
        insert asset;
        
        List<dmpl__AssetServiceContract__c> assetServiceContracts = new List<dmpl__AssetServiceContract__c>();
        assetServiceContracts.add(new dmpl__AssetServiceContract__c(
            dmpl__AssetId__c = asset[0].Id,
            dmpl__ItemId__c = item.Id,
            dmpl__ServiceContractItemId__c = item.Id,
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
        
        dmpl__AssetServiceContractLine__c assetServiceContractLine = new dmpl__AssetServiceContractLine__c(
            dmpl__AssetServiceContractId__c = assetServiceContracts[0].Id,
            dmpl__ComponentItemId__c = workItem.Id,
            dmpl__Quantity__c = 1,
            dmpl__UtilizedQuantity__c = 0);
        insert assetServiceContractLine;
    }
    
    private static void CreateServiceBay()
    {
        List<dmpl__ServiceBay__c> serviceBay = new List<dmpl__ServiceBay__c>();
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c];
        serviceBay.add(new dmpl__ServiceBay__c(dmpl__BranchId__c = branch.Id,
                                               Name = 'Test-Service-Bay',
                                               dmpl__ServiceBayType__c = 'Warehouse',
                                               dmpl__AllowInventory__c = true
                                              ));
        insert serviceBay;
    }
    
    private static void CreatePriceList()
    {
        List<dmpl__PriceList__c> priceList = new List<dmpl__PriceList__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account'];
        dmpl__AccountGroup__c accountGroup=[Select Id,Name From dmpl__AccountGroup__c];
        priceList.Add(new dmpl__PriceList__c(dmpl__PartnerAccountId__c = account.Id,
                                             dmpl__BranchId__c = Branch.Id,
                                             dmpl__PartnerAccountGroupId__c= accountGroup.Id,
                                             dmpl__PartnerGroupId__c=accountGroup.Id,
                                             dmpl__CustomerAccountGroupId__c=accountGroup.Id,
                                             dmpl__CustomerGroupId__c=accountGroup.Id,
                                             Name='Test-1',
                                             dmpl__PriceListType__c = 'Sale Price',
                                             dmpl__IsActive__c = true,
                                             dmpl__IsDefault__c = true
                                            ));
        
        
        priceList.Add(new dmpl__PriceList__c(
            Name='Test-2'
        ));
        insert priceList;
        
    }
    
    private static void CreateRepairOrder()
    {
        List<dmpl__RepairOrder__c> repairOrder = new List<dmpl__RepairOrder__c> ();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        //dmpl__Resource__c resource = [select Id,Name FROM dmpl__Resource__c LIMIT 1];
        Asset asset = [Select Id,Name From Asset LIMIT 1];
        Account customerAccount = [Select id,Name From Account Where Name = 'Customer-Test-Account' LIMIT 1];
        repairOrder.Add(new dmpl__RepairOrder__c (
            dmpl__BranchId__c = branch.Id,
            dmpl__IsClaimed__c=false,
            dmpl__IsDelivered__c=false,
            dmpl__DocumentDate__c=Date.today(),
            dmpl__AccountId__c = customerAccount.Id,
            dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
            dmpl__AssetId__c = asset.Id,
            dmpl__UsageReading__c = 8
            //dmpl__ServiceAdvisorId__c = resource.Id
        ));
        
        insert repairOrder;
    }
    
    
    
    private static void CreateTaxGroup()
    {
        List<dmpl__TaxGroup__c> taxGroup = new List<dmpl__TaxGroup__c>();
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account'];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__AccountGroup__c AccountGrp = [Select Id, Name FROM dmpl__AccountGroup__c LIMIT 1];
        taxGroup.Add(new dmpl__TaxGroup__c(Name = 'Test - Tax Group',
                                           dmpl__PartnerAccountId__c = account.Id,
                                           dmpl__BranchId__c = branch.Id,
                                           dmpl__PartnerAccountGroupId__c = AccountGrp.Id,
                                           dmpl__Description__c = 'Test-Description',
                                           dmpl__IsActive__c = true));
        insert taxGroup;
    } 
     private static void CreateSaleInvoice()
    {
        List<dmpl__SaleInvoice__c> saleInvoice = new List<dmpl__SaleInvoice__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        //dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        Account customerAccount = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
        //dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        saleInvoice.Add(new dmpl__SaleInvoice__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                 dmpl__BranchId__c = Branch.Id,
                                                 dmpl__DocumentDate__c = Date.today(),
                                                // dmpl__SaleOrderId__c = saleOrder.id,
                                                 dmpl__AccountId__c = customerAccount.Id,
                                                 //dmpl__SalesExecutiveId__c = resource.Id,
                                                 dmpl__FinanceAmount__c = 100,
                                                 dmpl__AmountPaid__c =10
                                                ));
        insert saleInvoice;
    }
    private static void CreateRepairOrderLine()
    {
        CreateTaxGroup();
        List<dmpl__RepairOrderLine__c> repairOrderLine = new List<dmpl__RepairOrderLine__c>();
        dmpl__RepairOrder__c repairOrder = [Select Id,Name FROM dmpl__RepairOrder__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name FROM dmpl__Item__c LIMIT 1];
        dmpl__Resource__c resource = [select Id,Name FROM dmpl__Resource__c WHERE dmpl__ResourceType__c = 'Technician' LIMIT 1];
        dmpl__StorageLocation__c storageLocation = [Select Id,Name FROM dmpl__StorageLocation__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        repairOrderLine.add(new dmpl__RepairOrderLine__c(dmpl__ItemId__c = item.Id,
                                                         dmpl__Quantity__c = 5,
                                                         dmpl__UnitPrice__c = 10,
                                                         dmpl__IsClaimed__c=False,
                                                         dmpl__PackageClassification__c = 'Optional Item',
                                                         dmpl__ActionTaken__c = 'Replace',
                                                         dmpl__TechnicianId__c = resource.Id,
                                                         dmpl__WorkStartedBy__c = date.today(),
                                                         dmpl__WorkEndedAt__c = date.today(),
                                                         dmpl__WorkStatus__c = 'Started',
                                                         dmpl__StandardDurationHours__c = 10,
                                                         dmpl__ActualDurationHours__c = 10,
                                                         dmpl__StorageLocationId__c = storageLocation.Id,
                                                         dmpl__TaxGroupId__c = taxGroup.Id,
                                                         dmpl__PostingType__c='Generate Claims',
                                                         dmpl__ServiceContractWeightage2__c = 0.10,
                                                         dmpl__RepairOrderId__c = repairOrder.Id
                                                        ));
        insert repairOrderLine;
    }
    
 /*   @isTest
    private static void verifyClaimLine()
    {
        test.startTest();
        CreateRepairOrderNew();
        CreateRepairOrderLinesNew();
        dmpl__Claim__c claim = [Select Id,Name From dmpl__Claim__c LIMIT 1];
        dmpl__RepairOrder__c repairOrder = [Select Id,Name From dmpl__RepairOrder__c LIMIT 1];
        dmpl__RepairOrderLine__c repairOrderLine = [Select Id,Name From dmpl__RepairOrderLine__c LIMIT 1];
        ClaimLineHelper.createClaimLine(claim,repairOrder,repairOrderLine);
        test.stopTest();
    } */
    
    private static void CreateStorageLocation()
    {
        List<dmpl__StorageLocation__c> storageLocation =  new List<dmpl__StorageLocation__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__ParentLocationId__c From dmpl__Branch__c];
        storageLocation.Add(new dmpl__StorageLocation__c(dmpl__BranchId__c = branch.Id,
                                                         dmpl__ParentLocationId__c = branch.dmpl__ParentLocationId__c,
                                                         dmpl__AllowInventory__c=true,
                                                         dmpl__IsMobile__c=true,
                                                         dmpl__IsActive__c=true,
                                                         dmpl__LocationType__c='Washing Bay'));
        insert storageLocation;
    }
    
    
    private static void CreateItemGroup()
    {
        List<dmpl__ItemGroup__c> itemGroup = new List<dmpl__ItemGroup__c> ();
        itemGroup.Add(new dmpl__ItemGroup__c(Name = 'Item Group Test',
                                             dmpl__ItemGroupType__c = 'Tax'
                                            ));
        insert itemGroup;
    }
    
    
    private static void CreateItemLot()
    {
        List<dmpl__ItemLot__c> itemLot = new List<dmpl__ItemLot__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id, Name from dmpl__SKU__c LIMIT 1];
        itemLot.Add(new dmpl__ItemLot__c(dmpl__BranchId__c = branch.Id,
                                         dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                         dmpl__ItemId__c = item.Id,
                                         dmpl__SKUId__c = sku.Id,
                                         dmpl__BatchNo__c = '12345',
                                         dmpl__SerialNumber__c = '4675',
                                         dmpl__SupplierInvoiceNumber__c = '74985',
                                         dmpl__DateOfReceipt__c = date.today(),
                                         dmpl__DateOfMfg__c = date.today(),
                                         dmpl__TotalCost__c = 100,
                                         dmpl__DateOfSupplierInvoice__c = date.today(),
                                         dmpl__Cost__c = 100
                                        // dmpl__QuantityExpired__c = 10,
                                        // dmpl__QuantityOnHold__c = 20,
                                       //  dmpl__QuantityOnLoan__c = 10
                                        ));
        insert itemLot;
        
        
        List<dmpl__ItemLot__c> relatedItemLot = new List<dmpl__ItemLot__c>();
        relatedItemLot.Add(new dmpl__ItemLot__c(
             dmpl__BranchId__c = branch.Id,
            dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
            dmpl__LandedCost__c = 1000));
        insert relatedItemLot;
    }
    
    private static void CreateClaim()
    {
        List<dmpl__Claim__c> claim = new List<dmpl__Claim__c>();
        Account account = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        claim.add(new dmpl__Claim__c(dmpl__BranchId__c = branch.Id,
                                     dmpl__ClaimType__c='Service',
                                     dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                     dmpl__DocumentDate__c = date.today(),
                                     dmpl__SupplierNameId__c = account.Id,
                                     dmpl__AsonDate__c = date.today(), 
                                     dmpl__ApproveAll__c = true
                                    ));
        
        claim.add(new dmpl__Claim__c(dmpl__BranchId__c = branch.Id,
                                     dmpl__ClaimType__c='Purchase',
                                     dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                     dmpl__DocumentDate__c = date.today(),
                                     dmpl__SupplierNameId__c = account.Id,
                                     dmpl__AsonDate__c = date.today(),
                                     dmpl__ApproveAll__c = true,
                                     dmpl__RejectAll__c = true
                                    ));
        insert claim;
    }
    
    private static void CreateClaimBatch()
    {
        List<dmpl__ClaimBatch__c> claimBatch = new List<dmpl__ClaimBatch__c>();
        Account account = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        claimBatch.add(new dmpl__ClaimBatch__c(dmpl__BranchId__c = branch.Id,
                                               dmpl__PartnerAccountId__c = partnerAccount.Id,
                                               dmpl__DocumentDate__c = date.today(),
                                               dmpl__SupplierNameId__c = account.Id
                                              ));
        insert claimBatch;
    }
    
    private static void CreateClaimLine()
    {
        CreateClaimBatch();
        List<dmpl__ClaimLine__c> claimLine = new List<dmpl__ClaimLine__c>();
        Account account = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c];
        dmpl__Claim__c claim = [Select Id,Name FROM dmpl__Claim__c LIMIT 1];
        dmpl__ClaimBatch__c claimBatch = [Select Id,Name FROM dmpl__ClaimBatch__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name FROM dmpl__Item__c LIMIT 1];
        claimLine.add(new dmpl__ClaimLine__c(dmpl__BranchId__c = branch.Id,
                                             dmpl__ClaimId__c = claim.Id,
                                             dmpl__ItemCode__c = 'bxfs543',
                                             dmpl__PartnerAccountId__c = partnerAccount.Id,
                                             dmpl__ItemId__c = item.Id,
                                             dmpl__ClaimQuantity__c = 2,
                                             dmpl__UnitPrice__c =100,
                                             dmpl__ApproveQuantity__c = 10,
                                             dmpl__RejectQuantity__c = 2,
                                             dmpl__ClaimBatchId__c = claimBatch.Id
                                            ));
        insert claimLine;
        
        dmpl__ClaimBatchLine__c cbl = new dmpl__ClaimBatchLine__c(
        	dmpl__ClaimBatchId__c = claimBatch.Id
        );
        insert cbl;
        
    }
    
    
    private static void CreateGoodsReceipt()
    {
        List<dmpl__GoodsReceipt__c> goodsReceipts= new List<dmpl__GoodsReceipt__c>();
        Account partnerAccount=[Select Id,Name from Account Where Name='Partner-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__PurchaseOrder__c purchaseOrder = [Select Id,Name From dmpl__PurchaseOrder__c LIMIT 1];
        Account supplierAccount=[Select Id,Name from Account Where Name='Supplier-Test-Account' LIMIT 1];
        goodsReceipts.add(new dmpl__GoodsReceipt__c(dmpl__PartnerAccountId__c = partnerAccount.Id,
                                                    dmpl__BranchId__c = branch.Id,
                                                    dmpl__PurchaseOrderId__c = purchaseOrder.Id,
                                                    dmpl__ReceivedTime__c = date.today(),
                                                    dmpl__IsClaimed__c=false,
                                                    dmpl__Status__c='Draft',
                                                    dmpl__DocumentDate__c = date.today(),
                                                    dmpl__SupplierAccountId__c = supplierAccount.Id,
                                                    dmpl__SupplierInvoiceDate__c = date.today(),
                                                    dmpl__SupplierInvoiceNumber__c = 'Test-SupplierInvoiceNumber',
                                                    dmpl__SupplierDispatchDate__c = date.today(),
                                                    dmpl__TransporterName__c = 'Test-TransporterName',
                                                    dmpl__TransporterRefrenceNumber__c = 'Test-TransporterRefrenceNumber',
                                                    dmpl__TransporterContactNumber__c = '7575555555'
                                                   ));
        insert goodsReceipts;
        
        dmpl__PurchaseOrderLine__c purchaseOrderLine = [Select Id,Name,dmpl__ItemId__c FROM dmpl__PurchaseOrderLine__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__ItemLot__c itemLot = [SELECT Id, Name, dmpl__ItemId__c, dmpl__QuantityInHand__c FROM dmpl__ItemLot__c LIMIT 1];
        dmpl__StorageLocation__c storageLocation = [Select Id, Name FROM dmpl__StorageLocation__c LIMIT 1];
        dmpl__GoodsReceiptLine__c grnLine = new dmpl__GoodsReceiptLine__c(dmpl__GoodsReceiptId__c = goodsReceipts[0].Id,
                                                                          dmpl__ItemId__c = purchaseOrderLine.dmpl__ItemId__c,
                                                                          dmpl__SKUId__c = sku.Id,
                                                                          dmpl__PurchaseOrderLineId__c = purchaseOrderLine.Id, 
                                                                          dmpl__OrderedQuantity__c =1, 
                                                                          dmpl__ReceivedQuantity__c = 1,
                                                                          dmpl__SupplierQuantity__c = 1,
                                                                          dmpl__StorageLocationId__c = storageLocation.Id
                                                                         );
        insert grnLine;
    }
    
    private static void CreatePurchaseOrder()
    {
        List<dmpl__PurchaseOrder__c> purchaseOrder = new List<dmpl__PurchaseOrder__c>();
        Account supplierAccount = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        purchaseOrder.add(new dmpl__PurchaseOrder__c(dmpl__BranchId__c = branch.Id,
                                                     dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                     dmpl__SupplierAccountId__c = supplierAccount.Id,
                                                     dmpl__PurchaseOrderType__c ='VOR PO',
                                                     dmpl__DocumentDate__c = Date.today(),
                                                     dmpl__Remarks__c = 'Remark',
                                                     dmpl__PerformReleaseInvoice__c=true,
                                                     dmpl__IsInvoiceReleased__c=true));
        insert purchaseOrder;
        
        List<dmpl__PurchaseOrderLine__c> purchaseOrderLine = new List<dmpl__PurchaseOrderLine__c>();
        dmpl__Item__c listofitem = [Select Id, Name from dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id, Name from dmpl__SKU__c LIMIT 1];
        purchaseOrderLine.add(new dmpl__PurchaseOrderLine__c(dmpl__ItemId__c = listofitem.Id,
                                                             dmpl__SKUId__c = sku.Id,
                                                             dmpl__PurchaseOrderId__c = purchaseOrder[0].Id,
                                                             dmpl__Quantity__c = 1
                                                            ));
        insert purchaseOrderLine;
    }    
    
    
    private static void CreateItemServiceContract()
    {
        List<dmpl__ItemServiceContract__c> ServiceContract = new List<dmpl__ItemServiceContract__c>();
        dmpl__Item__c item =[select Id,name FROM dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku=[select Id,name FROM dmpl__SKU__c LIMIT 1];
        ServiceContract.add(new dmpl__ItemServiceContract__c(
            dmpl__ItemId__c = item.Id,
            dmpl__SKUId__c=sku.Id              
        ));
        insert ServiceContract;
    }
    
    private static void CreatePriceListNew()
    {
        List<dmpl__PriceList__c> priceList = new List<dmpl__PriceList__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account'];
        dmpl__AccountGroup__c accountGroup=[Select Id,Name From dmpl__AccountGroup__c];
        priceList.Add(new dmpl__PriceList__c(dmpl__PartnerAccountId__c = account.Id,
                                             dmpl__BranchId__c = Branch.Id,
                                             dmpl__PartnerAccountGroupId__c= accountGroup.Id,
                                             dmpl__PartnerGroupId__c=accountGroup.Id,
                                             dmpl__CustomerAccountGroupId__c=accountGroup.Id,
                                             dmpl__CustomerGroupId__c=accountGroup.Id,
                                             Name='Test-1',
                                             dmpl__PriceListType__c = 'Sale Price',
                                             dmpl__IsActive__c = true,
                                             dmpl__IsDefault__c = true
                                            ));
        
        
        priceList.Add(new dmpl__PriceList__c(
            Name='Test-2'
        ));
        insert priceList;
        
    }
    
    private static void CreateItemLotNew()
    {
        List<dmpl__ItemLot__c> ilid = new List<dmpl__ItemLot__c	>();
        Account account = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__Item__c item =[select Id,name FROM dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku =[select Id,name FROM dmpl__SKU__c LIMIT 1];
        ilid.add(new dmpl__ItemLot__c(dmpl__BranchId__c = branch.Id,
                                      dmpl__PartnerAccountId__c = partnerAccount.Id,
                                      dmpl__ItemId__c = item.Id,
                                      dmpl__SKUId__c=sku.id ));
        
        
        insert ilid;
        
    }
    private static void CreateServiceRequestNew()
    {
        List<dmpl__ServiceRequest__c> serviceRequest = new List<dmpl__ServiceRequest__c>();
        Account account = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__Item__c item = [Select Id,Name,dmpl__ItemType__c From dmpl__Item__c WHERE dmpl__ItemType__c = 'Service Contract'LIMIT 1];
        Asset asset = [Select Id,Name From Asset LIMIT 1];
        dmpl__Resource__c resource = [select Id,Name FROM dmpl__Resource__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [SELECT Id, Name FROM dmpl__TaxGroup__c LIMIT 1];
        serviceRequest.Add(new dmpl__ServiceRequest__c(dmpl__AccountId__c = account.Id,
                                                       dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                       dmpl__AssetId__c = asset.Id,
                                                       dmpl__BranchId__c = branch.Id,
                                                       dmpl__ServiceContractItemId__c = item.Id,
                                                       dmpl__CustomerVoice__c = 'Service-Appointment',
                                                       dmpl__PackageServiceId__c = item.Id,
                                                       dmpl__ServiceAdvisorId__c = resource.Id,
                                                       dmpl__UsageReading__c = 10
                                                      ));
        insert serviceRequest;
        List<dmpl__ServiceRequestLine__c> newServiceRequestLines = new List<dmpl__ServiceRequestLine__c>();
        newServiceRequestLines.add(new dmpl__ServiceRequestLine__c(
            dmpl__ServiceRequestId__c = serviceRequest[0].Id,
            dmpl__ItemId__c = item.Id,
            dmpl__Quantity__c = 1,
            dmpl__TaxGroupId__c = taxGroup.Id
        ));
        insert newServiceRequestLines;
    }
    
    private static void CreateRepairOrderNew()
    {
        List<dmpl__RepairOrder__c> repairOrder = new List<dmpl__RepairOrder__c> ();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        //dmpl__Resource__c resource = [select Id,Name FROM dmpl__Resource__c LIMIT 1];
        Asset asset = [Select Id,Name From Asset LIMIT 1];
        dmpl__PriceList__c priceList=[Select Id, Name from dmpl__PriceList__c Limit 1];
        dmpl__ServiceRequest__c serviceRequest = [Select Id,Name From dmpl__ServiceRequest__c LIMIT 1];
        Account customerAccount = [Select id,Name From Account Where Name = 'Customer-Test-Account' LIMIT 1];
        repairOrder.Add(new dmpl__RepairOrder__c (
            dmpl__PriceListId__c=priceList.Id,
            dmpl__BranchId__c = branch.Id,
            dmpl__AccountId__c = customerAccount.Id,
            dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
            dmpl__ServiceRequestId__c = serviceRequest.Id,
            dmpl__AssetId__c = asset.Id,
            dmpl__IsClaimed__c = false,
            // dmpl__IsInvoiceGenerated__c = true,
            dmpl__IsDelivered__c = true,
            // dmpl__ServiceEstimateId__c = serviceEstimate.Id,
            dmpl__UsageReading__c = 8
            //dmpl__ServiceAdvisorId__c = resource.Id
        ));
        
        insert repairOrder;
    }
    
    private static void CreateRepairOrderLinesNew()
    {
        List<dmpl__RepairOrderLine__c> rol = new List<dmpl__RepairOrderLine__c>();
        dmpl__Item__c item =[select Id,name FROM dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku =[select Id,name FROM dmpl__SKU__c LIMIT 1];
        dmpl__TaxGroup__c tax=[select Id,name FROM dmpl__TaxGroup__c LIMIT 1];
        dmpl__RepairOrder__c repair =[select Id,name FROM dmpl__RepairOrder__c LIMIT 1];
        rol.add(new dmpl__RepairOrderLine__c(
            dmpl__ItemId__c=item.Id,
            dmpl__UnitPrice__c=100.00,
            dmpl__MaintenanceType__c='Breakdown',
            dmpl__PackageClassification__c='Optional Item',
            dmpl__PostingType__c = 'Generate Claims',
            dmpl__Discount__c=8,
            dmpl__DiscountAmount__c=100,
            dmpl__SKUId__c=sku.Id,
            dmpl__RepairOrderId__c=repair.Id,
            dmpl__Quantity__c=67,
            dmpl__ServiceContractWeightage2__c=10,
            dmpl__ServiceContractWeightage3__c = 12,
            dmpl__MaintenanceSubType__c='Sample',
            dmpl__TaxGroupId__c=tax.Id,
            dmpl__ActionTaken__c='Replace',
            dmpl__SchemeDiscount__c=3.00,
            dmpl__IsClaimed__c = false,
            dmpl__InvoiceGroup__c = 'Service',
            dmpl__SchemeDiscountAmount__c=100.00 ));
        insert rol;
    }
    
    
    private static void CreateClaimNew()
    {
        List<dmpl__Claim__c> claim = new List<dmpl__Claim__c>();
        Account account = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__RepairOrder__c repair =[select Id,name,dmpl__DocumentDate__c FROM dmpl__RepairOrder__c LIMIT 1];
        claim.add(new dmpl__Claim__c(dmpl__BranchId__c = branch.Id,
                                     dmpl__ClaimType__c='Service',
                                     dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                     dmpl__DocumentDate__c = date.today(),
                                     dmpl__SupplierNameId__c = account.Id,
                                     dmpl__AsonDate__c = date.today(),
                                     dmpl__RepairOrderId__c = repair.Id,
                                     dmpl__ApproveAll__c = true
                                    ));
        
        claim.add(new dmpl__Claim__c(dmpl__BranchId__c = branch.Id,
                                     dmpl__ClaimType__c='Purchase',
                                     dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                     dmpl__DocumentDate__c = date.today(),
                                     dmpl__SupplierNameId__c = account.Id,
                                     dmpl__AsonDate__c = date.today(),
                                     dmpl__RepairOrderId__c = repair.Id,
                                     dmpl__ApproveAll__c = true
                                     
                                    ));
        insert claim;
    }
    
    
    private static void createClaimLineForServices()
    {
        List<dmpl__ClaimLine__c> newClaimLines = new List<dmpl__ClaimLine__c>();
        Account account = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__Claim__c claim = [Select Id,Name FROM dmpl__Claim__c LIMIT 1];
        dmpl__Branch__c branch=[select Id,name FROM dmpl__Branch__c LIMIT 1];
        dmpl__Item__c item = [select Id,name FROM dmpl__Item__c LIMIT 1];
        dmpl__Resource__c res=[select Id,name FROM dmpl__Resource__c LIMIT 1];
        
        newClaimLines.add(new dmpl__ClaimLine__c(
            dmpl__ClaimId__c=claim.ID,
            dmpl__PartnerAccountId__c = partnerAccount.Id,
            dmpl__BranchId__c=branch.ID,
            dmpl__ItemId__c=item.ID,     
            dmpl__ClaimQuantity__c=11.00,
            dmpl__UnitPrice__c=100
        ));
        
        insert newClaimLines;
        
    }
    private static void CreateTaxGroupNew()
    {
        List<dmpl__TaxGroup__c> taxGroup = new List<dmpl__TaxGroup__c>();
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account'];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__AccountGroup__c AccountGrp = [Select Id, Name FROM dmpl__AccountGroup__c LIMIT 1];
        taxGroup.Add(new dmpl__TaxGroup__c(Name = 'Test-Tax Group',
                                           dmpl__PartnerAccountId__c = account.Id,
                                           dmpl__BranchId__c = branch.Id,
                                           dmpl__PartnerAccountGroupId__c = AccountGrp.Id,
                                           dmpl__Description__c = 'Test-Description',
                                           dmpl__IsActive__c = true));
        insert taxGroup;
    } 
    
    
    @isTest
    public static void VerifyClaimLineForServices()
    {
        try{
            CreatePriceListNew();
            CreateTaxGroupNew();
            CreateServiceRequestNew();
            Test.startTest();
            CreateRepairOrderNew();
            CreateRepairOrderLinesNew();
            CreateClaimNew();
            createClaimLineForServices();
            List<dmpl__Claim__c> claims =[select Id, Name,dmpl__RepairOrderId__c,dmpl__AsOnDate__c,dmpl__BranchId__c from dmpl__Claim__c where dmpl__RepairOrderId__c!=null];
            List<SourceObjectInfo> ls=SourceObjectInfo.createFrom(claims);
            ClaimLineHelper.createClaimLinesForService(claims,ls);
            System.assertNotEquals(null, claims);
            test.stopTest();  
        }
        catch(Exception e){}
    }
    
    private static void CreateBills()
    {
        List<dmpl__Bill__c> bills = new List<dmpl__Bill__c>();
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        bills.Add(new dmpl__Bill__c(
            
            dmpl__PartnerAccountId__c = partnerAccount.Id,
            dmpl__BranchId__c = branch.Id
        ));
        insert bills;
    }
    
    
    
    private static void CreateBillLine()
    {
        List<dmpl__BillLine__c> billlineid = new List<dmpl__BillLine__c>();
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__Bill__c bil = [Select Id,Name From dmpl__Bill__c Limit 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Limit 1];
        dmpl__Item__c Item = [Select Id,Name From dmpl__Item__c Limit 1];
        dmpl__SKU__c Sku = [Select Id,Name From dmpl__SKU__c Limit 1];
        billlineid.Add(new dmpl__BillLine__c(
            dmpl__SKUId__c = sku.Id,
            dmpl__ItemId__c = Item.Id,
            dmpl__Quantity__c = 16.00,
            dmpl__PurchaseInvoiceId__c = bil.Id
        ));
        insert billlineid;
    }
    
    
    
    private static void CreateClaimBatchNew()
    {
        List<dmpl__ClaimBatch__c> claimBatch = new List<dmpl__ClaimBatch__c>();
        Account account = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        claimBatch.add(new dmpl__ClaimBatch__c(dmpl__BranchId__c = branch.Id,
                                               dmpl__PartnerAccountId__c = partnerAccount.Id,
                                               dmpl__DocumentDate__c = date.today(),
                                               dmpl__SupplierNameId__c = account.Id
                                              ));
        insert claimBatch;
        
    }
    
    private static void CreatePurchaseOrderNew()
    {
        List<dmpl__PurchaseOrder__c> purchaseOrder = new List<dmpl__PurchaseOrder__c>();
        Account supplierAccount = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        purchaseOrder.add(new dmpl__PurchaseOrder__c(dmpl__BranchId__c = branch.Id,
                                                     dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                     dmpl__SupplierAccountId__c = supplierAccount.Id,
                                                     dmpl__PurchaseOrderType__c = 'Part PO',
                                                     dmpl__DocumentDate__c = Date.today(),
                                                     dmpl__Remarks__c = 'Test-Remark',
                                                     dmpl__PerformReleaseInvoice__c = true,
                                                     dmpl__IsInvoiceReleased__c = true
                                                    ));
        insert purchaseOrder;
    }
    
    private static void CreateGoodsReceiptNew()
    {
        List<dmpl__GoodsReceipt__c> goodsReceipts= new List<dmpl__GoodsReceipt__c>();
        Account partnerAccount=[Select Id,Name from Account Where Name='Partner-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__PurchaseOrder__c purchaseOrder = [Select Id,Name From dmpl__PurchaseOrder__c LIMIT 1];
        Account supplierAccount=[Select Id,Name from Account Where Name='Supplier-Test-Account' LIMIT 1];
        goodsReceipts.add(new dmpl__GoodsReceipt__c(dmpl__PartnerAccountId__c = partnerAccount.Id,
                                                    dmpl__BranchId__c = branch.Id,
                                                    dmpl__PurchaseOrderId__c = purchaseOrder.Id,
                                                    dmpl__ReceivedTime__c = date.today(),
                                                    dmpl__IsClaimed__c=false,
                                                    dmpl__Status__c='Draft',
                                                    dmpl__DocumentDate__c = date.today(),
                                                    dmpl__SupplierAccountId__c = supplierAccount.Id,
                                                    dmpl__SupplierInvoiceDate__c = date.today(),
                                                    dmpl__SupplierInvoiceNumber__c = 'Test-SupplierInvoiceNumber',
                                                    dmpl__SupplierDispatchDate__c = date.today(),
                                                    dmpl__TransporterName__c = 'Test-TransporterName',
                                                    dmpl__TransporterRefrenceNumber__c = 'Test-TransporterRefrenceNumber',
                                                    dmpl__TransporterContactNumber__c = '7575555555'
                                                   ));
        insert goodsReceipts;
    }
    private static void  CreatePurchaseReturn()
    {
        List<dmpl__PurchaseReturn__c> PurchaseReturn1= new List<dmpl__PurchaseReturn__c>();
        Account partnerAccount=[Select Id,Name from Account Where Name='Partner-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__PurchaseOrder__c purchaseOrder = [Select Id,Name From dmpl__PurchaseOrder__c LIMIT 1];
        Account supplierAccount=[Select Id,Name from Account Where Name='Supplier-Test-Account' LIMIT 1];
        PurchaseReturn1.add(new dmpl__PurchaseReturn__c(dmpl__PartnerAccountId__c = partnerAccount.Id,
                                                        dmpl__BranchId__c = branch.Id,
                                                        dmpl__PurchaseOrderId__c = purchaseOrder.Id,
                                                        dmpl__DocumentDate__c = date.today(),
                                                        dmpl__SupplierAccountId__c = supplierAccount.Id,
                                                        dmpl__SupplierInvoiceDate__c = date.today(),
                                                        dmpl__SupplierInvoiceNumber__c = 'abc'
                                                       ));
        insert PurchaseReturn1;
    }
    
    
    private static void CreatePurchaseReturnLine()
    {
        List<dmpl__PurchaseReturnLine__c> prl = new List<dmpl__PurchaseReturnLine__c>();
        dmpl__BillLine__c bill =[select Id,name FROM  dmpl__BillLine__c LIMIT 1];
        dmpl__Item__c item =[select Id,name FROM dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku =[select Id,name FROM dmpl__SKU__c LIMIT 1];
        dmpl__TaxGroup__c tax=[select Id,name FROM dmpl__TaxGroup__c LIMIT 1];
        dmpl__PurchaseReturn__c ret =[select Id,name FROM dmpl__PurchaseReturn__c LIMIT 1];
        dmpl__Bill__c inv =[select Id,name FROM dmpl__Bill__c LIMIT 1];
        prl.add(new dmpl__PurchaseReturnLine__c(
            dmpl__BillLineId__c = bill.Id,
            dmpl__ItemId__c = item.Id,
            dmpl__SKUId__c = sku.Id,
            dmpl__TaxGroupId__c = tax.Id,
            dmpl__PurchaseReturnId__c = ret.Id  ,
            dmpl__PurchaseInvoiceId__c = inv.Id,
            dmpl__IsClaimed__c = false,
            dmpl__ReturnType__c='Damaged',
            dmpl__Quantity__c=1
             ));
        insert prl;
    }
    private static void CreateClaimsNew()
    {
        List<dmpl__Claim__c> claim = new List<dmpl__Claim__c>();
        Account account = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        claim.add(new dmpl__Claim__c(dmpl__BranchId__c = branch.Id,
                                     dmpl__ClaimType__c='Service',
                                     dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                     dmpl__DocumentDate__c = date.today(),
                                     dmpl__SupplierNameId__c = account.Id,
                                     dmpl__AsonDate__c = date.today()
                                    ));
        
        claim.add(new dmpl__Claim__c(dmpl__BranchId__c = branch.Id,
                                     dmpl__ClaimType__c='Purchase',
                                     dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                     dmpl__DocumentDate__c = date.today(),
                                     dmpl__SupplierNameId__c = account.Id,
                                     dmpl__AsonDate__c = date.today()
                                    ));
        insert claim;
    }
    private static void CreateClaimLinesNew()
    {
        List<dmpl__ClaimLine__c> claimLine = new List<dmpl__ClaimLine__c>();
        Account account = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c];
        dmpl__Claim__c claim = [Select Id,Name FROM dmpl__Claim__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name FROM dmpl__Item__c LIMIT 1];
        dmpl__PurchaseReturnLine__c prreturnLine=[select Id,name FROM dmpl__PurchaseReturnLine__c LIMIT 1];
        claimLine.add(new dmpl__ClaimLine__c(dmpl__BranchId__c = branch.Id,
                                             dmpl__ClaimId__c = claim.Id,
                                             dmpl__ItemCode__c = 'bxfs543',
                                             dmpl__PartnerAccountId__c = partnerAccount.Id,
                                             dmpl__ItemId__c = item.Id,
                                             dmpl__ClaimQuantity__c = 2,
                                             dmpl__UnitPrice__c =100,
                                             dmpl__ApproveQuantity__c = 10,
                                             dmpl__RejectQuantity__c = 2,
                                             dmpl__BillReturnLineId__c = null,
                                             dmpl__PurchaseReturnLineId__c	=prreturnLine.Id
                                            ));
        insert claimLine;
    }
    
    private static void createClaimsLinesForReturn()
    {
        List<dmpl__ClaimLine__c> newClaimLines = new List<dmpl__ClaimLine__c>();
        dmpl__PurchaseReturnLine__c ReturnLine = [Select Id,Name,dmpl__BillLineId__c,dmpl__ItemId__c From dmpl__PurchaseReturnLine__c LIMIT 1];
        
        Account partneraccount=[select Id,Name FROM Account WHERE Name='Partner-Test-Account' LIMIT 1 ];    
        dmpl__Item__c item =[select Id,name FROM dmpl__Item__c LIMIT 1];    
        dmpl__Claim__c claim =[Select Id,Name FROM dmpl__Claim__c LIMIT 1];
        dmpl__GoodsReceipt__c goodsreceipt = [Select Id,Name FROM dmpl__GoodsReceipt__c LIMIT 1];
        newClaimLines.add(new dmpl__ClaimLine__c(
            dmpl__PartnerAccountId__c=partneraccount.Id,
            dmpl__ItemId__c=item.Id,          
            dmpl__ClaimId__c = claim.Id,
            dmpl__PurchaseReturnLineId__c=ReturnLine.Id,
            dmpl__GoodsReceiptId__c=goodsreceipt.Id,
        	dmpl__ClaimType__c = 'Part to Part'));
        
        insert newClaimLines;
        
    }
    
    @isTest
    public static void VerifyClaimLineForPurchasereturn()
    {
        Try{
        Test.startTest();
        CreateBills();
        CreateBillLine();
        CreateTaxGroupNew();
        CreatePurchaseOrderNew();
        CreateGoodsReceiptNew();
        CreatePurchaseReturn();
        CreatePurchaseReturnLine();
        CreateClaimsNew();
        CreateClaimLinesNew();
        test.stopTest();
        createClaimsLinesForReturn();
        List<dmpl__Claim__c> claims =[select Id, Name,dmpl__AsOnDate__c,dmpl__BranchId__c,dmpl__PurchaseReturnId__c from dmpl__Claim__c];
        ClaimLineHelper.createClaimLinesForPurchaseReturn(claims);
        System.assertNotEquals(null, claims);  
    }
    Catch(Exception e){}
    }
}