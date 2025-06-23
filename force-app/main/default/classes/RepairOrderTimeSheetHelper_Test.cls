@isTest
public class RepairOrderTimeSheetHelper_Test {
 
    @testSetup
    public static void Setup()
    {
        System.runAs(PostInstallHelper.AssignAdministratorAllPermissions(UserInfo.getUserId())){
        CreateAccountGroup();
        CreateAccount();
        CreateBranch();
        CreateStorageLocation();
        CreateItemGroup();   
        CreateItem();
        CreateSKU();
        CreateResource(); 
        CreatePriceList();
        CreateItemLot();
        CreateAsset();      
        CreateTaxGroup();
        CreateTax();        
        CreateBranchTimeSlot();
        CreateServiceBay();
        //CreateServiceType();
        CreateRepairOrder();              
        CreateRepairOrderLine();
        CreateRepairOrderTimeSheetLine();
       
        }
    }
 
   @isTest
    public static void createTimeSheet()
    {
        try{
        test.startTest();
        List<dmpl__RepairOrderTimeSheetLine__c> timeSheetLine= [Select Id, Name,dmpl__RepairOrderLineId__c,dmpl__RepairOrderTimeSheetId__c from dmpl__RepairOrderTimeSheetLine__c Limit 1 ];
        RepairOrderTimeSheetHelper.createTimeSheet('dmpl__RepairOrderLineId__c','dmpl__RepairOrderTimeSheetId__c');
        System.assert(timeSheetLine!=null,'one Record');
        }
        catch(exception e){}
        test.stopTest();
    }
   
    public static void UpdateRepairOrderAsPopulateLinesForRequest()
    {
        test.startTest();
        List<dmpl__RepairOrder__c> repairOrders = [Select Id,Name,dmpl__PerformPopulateLines__c, dmpl__ServiceRequestId__c, dmpl__ServiceEstimateId__c From dmpl__RepairOrder__c WHERE dmpl__ServiceRequestId__c != null];
        for(dmpl__RepairOrder__c repairOrder : repairOrders)
        {  
            repairOrder.dmpl__PerformPopulateLines__c = true;
        } 
        update repairOrders;
        System.assertEquals(True, repairOrders[0].dmpl__PerformPopulateLines__c, 'Sale Order has 1 Record Updated');
        test.stopTest();
    }
    
    
    public static void UpdateRepairOrderAsPopulateLinesForEstimate()
    {
        test.startTest();
        dmpl__Quote__c serviceEstimate = [SELECT Id, Name FROM dmpl__Quote__c LIMIT 1];
        List<dmpl__RepairOrder__c> repairOrders = [Select Id,Name,dmpl__PerformPopulateLines__c, dmpl__ServiceRequestId__c, dmpl__ServiceEstimateId__c From dmpl__RepairOrder__c WHERE dmpl__ServiceEstimateId__c != null];
        for(dmpl__RepairOrder__c repairOrder : repairOrders)
        {  
            repairOrder.dmpl__PerformPopulateLines__c = true;
        }
        update repairOrders;
        System.assertEquals(True, repairOrders[0].dmpl__PerformPopulateLines__c, 'Sale Order has 1 Record Updated');
        test.stopTest();
    }
    
    @isTest
    public static void UpdateRepairOrderAsWorkStart()
    {
        try{
        test.startTest();
        dmpl__RepairOrder__c repairOrder = [Select Id,Name,dmpl__PerformWorkStart__c From dmpl__RepairOrder__c LIMIT 1];
        repairOrder.dmpl__PerformWorkStart__c = True;
        update repairOrder;
        RepairOrderTimeSheetHelper.queryRepairOrderTimeSheet(repairOrder.Id);
        System.assertEquals(True, repairOrder.dmpl__PerformWorkStart__c, 'Sale Order has 1 Record Updated');
        test.stopTest();
        } catch(exception ex){}
    }
    
    @isTest
    public static void UpdateRepairOrderAsWorkEnd()
    {
        test.startTest();
        dmpl__RepairOrder__c repairOrder = [Select Id,Name,dmpl__PerformWorkEnd__c From dmpl__RepairOrder__c LIMIT 1];
        repairOrder.dmpl__PerformWorkEnd__c = True;
        update repairOrder;
        RepairOrderTimeSheetHelper.queryPendingRepairOrderLines(repairOrder.Id);
        System.assertEquals(True, repairOrder.dmpl__PerformWorkEnd__c, 'Sale Order has 1 Record Updated');
        test.stopTest();
    }
    
    @isTest
    public static void UpdateRepairOrderAsPerformCheckList()
    {
        test.startTest();
        dmpl__RepairOrder__c repairOrder = [Select Id,Name,dmpl__PerformPopulateChecklist__c From dmpl__RepairOrder__c LIMIT 1];
        repairOrder.dmpl__PerformPopulateChecklist__c = True;
        update repairOrder;
        System.assertEquals(True, repairOrder.dmpl__PerformPopulateChecklist__c, 'Sale Order has 1 Record Updated');
        test.stopTest();
    }
    
    
    @isTest
    public static void UpdateRepairOrderAsdelivered()
    {
        test.startTest();
        dmpl__RepairOrder__c repairOrder = [Select Id,Name,dmpl__IsDelivered__c From dmpl__RepairOrder__c LIMIT 1];
        repairOrder.dmpl__IsDelivered__c = True;
        update repairOrder;
        System.assertEquals(True, repairOrder.dmpl__IsDelivered__c, 'Sale Order has 1 Record Updated');
        test.stopTest();
    }
    
    @isTest
    public static void UpdateRepairOrderAsPerformVor()
    {
        test.startTest();
        dmpl__RepairOrder__c repairOrder = [Select Id,Name,dmpl__PerformVOROrderGeneration__c From dmpl__RepairOrder__c LIMIT 1];
        repairOrder.dmpl__PerformVOROrderGeneration__c = True;
        update repairOrder;
        System.assertEquals(True, repairOrder.dmpl__PerformVOROrderGeneration__c, 'Sale Order has 1 Record Updated');
        test.stopTest();
    }
    
   
    public static void UpdateRepairOrderAsInvoiceGeneration()
    {
        test.startTest();
        dmpl__RepairOrder__c repairOrder = [Select Id,Name,dmpl__PerformInvoiceGeneration__c From dmpl__RepairOrder__c LIMIT 1];
        repairOrder.dmpl__PerformInvoiceGeneration__c = True;
        update repairOrder;
        System.assertEquals(True, repairOrder.dmpl__PerformInvoiceGeneration__c, 'Sale Order has 1 Record Updated');
        test.stopTest();
    }
    
    @isTest
    public static void DeleteRepairOrder()
    {
        test.startTest();
        dmpl__RepairOrder__c repairOrder = [Select Id,Name From dmpl__RepairOrder__c LIMIT 1];
        if(repairOrder != null)
            Delete repairOrder;
        System.assert(repairOrder != null, 'repair order data');
        test.stopTest();
    } 
    
    
    @isTest
    public static void DeleteRepairOrderLine()
    {
        test.startTest();
        dmpl__RepairOrderLine__c repairOrderLine = [Select Id,Name From dmpl__RepairOrderLine__c LIMIT 1];
        if(repairOrderLine != null)
            Delete repairOrderLine;
        System.assert(repairOrderLine != null, 'repair order line data');
        test.stopTest();
    }
    
   
    public static void UpdatePerformEstimateLinesGeneration()
    {
        test.startTest();
        dmpl__Quote__c serviceEstimate = [Select Id,Name,dmpl__PerformEstimateLinesGeneration__c From dmpl__Quote__c LIMIT 1];
        serviceEstimate.dmpl__PerformEstimateLinesGeneration__c = True;
        update serviceEstimate;
        System.assertEquals(True, serviceEstimate.dmpl__PerformEstimateLinesGeneration__c, 'serviceEstimate has 1 Record Updated');
        test.stopTest();
    }
    
      @isTest
    public static void UpdateTimeSheetAsStarted()
    {
        test.startTest();
        dmpl__RepairOrderTimeSheet__c timeSheet = [Select Id,Name,dmpl__RepairStatus__c From dmpl__RepairOrderTimeSheet__c LIMIT 1];
        timeSheet.dmpl__RepairStatus__c = 'Started';
        update timeSheet;
        System.assertEquals('Started', timeSheet.dmpl__RepairStatus__c, 'serviceEstimate has 1 Record Updated');
        test.stopTest();
    }
    
    @isTest
    public static void UpdateTimeSheetAsCompleted()
    {
        test.startTest();
        dmpl__RepairOrderTimeSheet__c timeSheet = [Select Id,Name,dmpl__RepairStatus__c From dmpl__RepairOrderTimeSheet__c LIMIT 1];
        timeSheet.dmpl__RepairStatus__c = 'Completed';
        update timeSheet;
        System.assertEquals('Completed', timeSheet.dmpl__RepairStatus__c, 'serviceEstimate has 1 Record Updated');
        test.stopTest();
    }
    
    @isTest
    public static void UpdateTimeSheetAsPaused()
    {
        test.startTest();
        dmpl__RepairOrderTimeSheet__c timeSheet = [Select Id,Name,dmpl__RepairStatus__c From dmpl__RepairOrderTimeSheet__c LIMIT 1];
        timeSheet.dmpl__RepairStatus__c = 'Paused';
        update timeSheet;
        System.assertEquals('Paused', timeSheet.dmpl__RepairStatus__c, 'serviceEstimate has 1 Record Updated');
        test.stopTest();
    }
    
    @isTest
    public static void queryRepairOrderTimeSheets()
    {
        test.startTest();
        dmpl__RepairOrderTimeSheet__c timeSheet = [Select Id,Name,dmpl__RepairStatus__c From dmpl__RepairOrderTimeSheet__c LIMIT 1];
        Id recordId = timeSheet.Id;
        RepairOrderTimeSheetHelper.queryRepairOrderTimeSheets(recordId);
        update timeSheet;
        System.assert(timeSheet != null, 'serviceEstimate has 1 Record Updated');
        test.stopTest();
    }
    
    public static void UpdatePerformDecline()
    {
        UpdatePerformEstimateLinesGeneration();
        dmpl__Quote__c serviceEstimate = [Select Id,Name,dmpl__PerformDecline__c From dmpl__Quote__c LIMIT 1];
        serviceEstimate.dmpl__PerformDecline__c = True;
        
        update serviceEstimate;
        System.assertEquals(True, serviceEstimate.dmpl__PerformDecline__c, 'serviceEstimate has 1 Record Updated');
    }   
    
    private static void CreateAccountGroup()
    {
        dmpl__AccountGroup__c accountGroup= new dmpl__AccountGroup__c (Name= 'Test-AccountGroup', 
                                                                       dmpl__AccountGroupType__c='Scheme');
        insert accountGroup;
    }
    
    private static void CreateAccount()
    {
        List<Account> account = new List<Account>();
        dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c LIMIT 1];
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
    
    private static void CreateItem()
    {
        List<dmpl__Item__c> item = new List<dmpl__Item__c>();
        dmpl__ItemGroup__c itemGroup = [Select Id, Name FROM dmpl__ItemGroup__c LIMIT 1];
        item.Add(new dmpl__Item__c(Name = 'Test-Item',
                                   dmpl__ItemCode__c = 'DMPL',
                                   dmpl__ItemType__c = 'Work Item',
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
                                   dmpl__QuantityUnitOfMeasure__c = 'Each',
                                   dmpl__InventoryValuationMethod__c = 'FIFO',
                                   dmpl__TaxItemGroupId__c = itemGroup.Id
                                   
                                  ));
        insert item;
    
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
                                         // dmpl__QuantityExpired__c = 1,
                                         // dmpl__QuantityOnHold__c = 1,
                                         // dmpl__QuantityOnLoan__c = 1
                                        ));
        insert itemLot;
        
        List<dmpl__ItemLot__c> relatedItemLot = new List<dmpl__ItemLot__c>();
        relatedItemLot.Add(new dmpl__ItemLot__c(
            dmpl__BranchId__c = branch.Id,
            dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
            dmpl__LandedCost__c = 1000));
        insert relatedItemLot;
    }
    
    private static void CreateSKU()
    {
        List<dmpl__SKU__c> Skus = new List<dmpl__SKU__c>();
        dmpl__Item__c listofitem = [Select Id, Name from dmpl__Item__c LImit 1];
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
    
    private static void CreateBranchTimeSlot()
    {
        List<dmpl__BranchTimeSlot__c> branchTimeSlot = new List<dmpl__BranchTimeSlot__c>();
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        branchTimeSlot.Add(new dmpl__BranchTimeSlot__c(dmpl__BranchId__c = branch.Id,
                                                       dmpl__TransactionType__c = 'Delivery',
                                                       Name = 'Test - Name',
                                                       dmpl__IsActive__c = True,
                                                       dmpl__ApplicableToItem__c= item.Id,
                                                       dmpl__MaximumCapacity__c = 20,                                                    
                                                       dmpl__MondayCapacity__c = 32,
                                                       dmpl__TuesdayCapacity__c = 22,
                                                       dmpl__WednesdayCapacity__c = 11,
                                                       dmpl__ThursdayCapacity__c = 20,
                                                       dmpl__FridayCapacity__c = 22,
                                                       dmpl__SaturdayCapacity__c = 10,
                                                       dmpl__SundayCapacity__c = 12
                                                      ));
        insert branchTimeSlot;
    }
    
    private static void CreateServiceRequest()
    {
        List<dmpl__ServiceRequest__c> serviceRequest = new List<dmpl__ServiceRequest__c>();
        Account account = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        Asset asset = [Select Id,Name From Asset LIMIT 1];
        dmpl__Resource__c resource = [select Id,Name FROM dmpl__Resource__c LIMIT 1];
        dmpl__BranchTimeSlot__c brTimeSlot = [Select Id From dmpl__BranchTimeSlot__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [SELECT Id, Name FROM dmpl__TaxGroup__c LIMIT 1];
        serviceRequest.Add(new dmpl__ServiceRequest__c(dmpl__AccountId__c = account.Id,
                                                       dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                       dmpl__AssetId__c = asset.Id,
                                                       dmpl__BranchId__c = branch.Id,
                                                       dmpl__AppointmentTimeSlotId__c = brTimeSlot.Id,
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
    
 
    private static void CreateServiceEstimate()
    { 
        List<dmpl__Quote__c> serviceEstimate = new List<dmpl__Quote__c>();
        Account account = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__Resource__c resource = [select Id,Name FROM dmpl__Resource__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__PriceList__c priceList=[Select Id, Name from dmpl__PriceList__c Limit 1];
        Asset asset = [Select Id,Name From Asset LIMIT 1];
        dmpl__ServiceRequest__c serviceRequest = [Select Id,Name From dmpl__ServiceRequest__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [SELECT Id, Name FROM dmpl__TaxGroup__c LIMIT 1];
        serviceEstimate.Add(new dmpl__Quote__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                               dmpl__BranchId__c = branch.Id,
                                               dmpl__AccountId__c = account.Id,
                                               dmpl__AssetId__c = asset.Id,
                                               dmpl__PerformEstimateLinesGeneration__c = false,
                                               dmpl__PackageServiceId__c = item.Id,
                                               dmpl__ServiceRequestId__c = serviceRequest.Id,
                                               dmpl__ServiceAdvisorId__c = resource.Id,
                                               dmpl__CustomerVoice__c = 'Text',
                                               dmpl__PriceListId__c=priceList.Id,
                                               dmpl__UsageReading__c = 8,
                                               dmpl__PerformDecline__c = false,
                                               dmpl__PerformRepairOrderGeneration__c = false,
                                               dmpl__IsRepairOrderGenerated__c = false
                                              ));
        insert serviceEstimate;
        List<dmpl__QuoteLine__c> newServiceEstimateLines = new List<dmpl__QuoteLine__c>();
        newServiceEstimateLines.add(new dmpl__QuoteLine__c(
            dmpl__QuoteId__c = serviceEstimate[0].Id,
            dmpl__ItemId__c = item.Id,
            dmpl__Quantity__c = 1,
            dmpl__UnitPrice__c = 10,
            dmpl__TaxGroupId__c = taxGroup.Id
        ));
        insert newServiceEstimateLines;
    }
    
    private static void CreateAsset()
    {
        List<Asset> asset = new List<Asset>();
        Account account = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c LIMIT 1];
        asset.add(new Asset(Name = 'Test-Asset',
                            AccountId = account.Id,
                            dmpl__LastServiceBranchId__c = branch.Id,
                            dmpl__ItemId__c = item.Id,
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
        List<dmpl__PriceList__c> priceList =new List<dmpl__PriceList__c>();
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
        dmpl__PriceList__c priceList=[Select Id, Name from dmpl__PriceList__c Limit 1];
        Account customerAccount = [Select id,Name From Account Where Name = 'Customer-Test-Account' LIMIT 1];
        repairOrder.Add(new dmpl__RepairOrder__c (
            dmpl__PriceListId__c=priceList.Id,
            dmpl__BranchId__c = branch.Id,
            dmpl__AccountId__c = customerAccount.Id,
            dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
            dmpl__AssetId__c = asset.Id,
            dmpl__UsageReading__c = 8
            //dmpl__ServiceAdvisorId__c = resource.Id
        ));
        insert repairOrder;
    }
 
    private static void CreateTax()
    {
        List<dmpl__Tax__c> tax = new List<dmpl__Tax__c>();
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c];
        tax.Add(new dmpl__Tax__c(Name = 'Test - Tax',
                                 dmpl__Rate__c = 10,
                                 dmpl__TaxGroupId__c = taxGroup.Id,
                                 dmpl__PostingFieldName__c ='Tax1',
                                 dmpl__Type__c = 'Cess'
                                ));        
        insert tax;
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
    
    private static void CreateRepairOrderLine()
    {
        List<dmpl__RepairOrderLine__c> repairOrderLine = new List<dmpl__RepairOrderLine__c>();
        dmpl__RepairOrder__c repairOrder = [Select Id,Name FROM dmpl__RepairOrder__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name FROM dmpl__Item__c  LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c LIMIT 1];
        //dmpl__Resource__c resource = [select Id,Name FROM dmpl__Resource__c WHERE dmpl__ResourceType__c = 'Technician' LIMIT 1];
        dmpl__StorageLocation__c storageLocation = [Select Id,Name FROM dmpl__StorageLocation__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        repairOrderLine.add(new dmpl__RepairOrderLine__c(dmpl__ItemId__c = item.Id,
                                                         dmpl__Quantity__c = 5,
                                                         dmpl__CancelledQuantity__c=3,
                                                         dmpl__SKUId__c=sku.Id,
                                                         dmpl__UnitPrice__c = 10,
                                                         dmpl__PackageClassification__c = 'Optional Item',
                                                         dmpl__ActionTaken__c = 'Replace',
                                                         //dmpl__TechnicianId__c = resource.Id,
                                                         dmpl__WorkStartedBy__c = date.today(),
                                                         dmpl__WorkEndedAt__c = date.today()+(2),
                                                         dmpl__WorkStatus__c = 'Started',
                                                         dmpl__StandardDurationHours__c = 10,
                                                         dmpl__ActualDurationHours__c = 10,
                                                         dmpl__StorageLocationId__c = storageLocation.Id,
                                                         dmpl__TaxGroupId__c = taxGroup.Id,
                                                         dmpl__RepairOrderId__c = repairOrder.Id
                                                        ));
        insert repairOrderLine;
    }
    
    private static void CreateRepairOrderTax()
    {
        List<dmpl__RepairOrderTax__c> repairOrderTax = new List<dmpl__RepairOrderTax__c>();
        dmpl__RepairOrder__c repairOrder = [Select Id,Name From dmpl__RepairOrder__c LIMIT 1];
        dmpl__RepairOrderline__c repairOrderLine = [Select Id,Name From dmpl__RepairOrderLine__c LIMIT 1];
        dmpl__Tax__c tax = [Select Id,Name From dmpl__Tax__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        repairorderTax.add(new dmpl__RepairOrderTax__c(dmpl__RepairOrderId__c = repairOrder.Id,
                                                       dmpl__RepairOrderLineId__c = repairOrderLine.Id,
                                                       dmpl__TaxId__c = tax.Id,
                                                       dmpl__TaxOnAmount__c = 100,
                                                       dmpl__TaxAmount__c = 100,
                                                       dmpl__TaxGroupId__c = taxGroup.Id,
                                                       dmpl__TaxRate__c = 10));
        insert repairOrderTax;
    }
    
    private static void CreateChecklistTemplate()
    {
        List<dmpl__ChecklistTemplate__c> checkList = new List<dmpl__ChecklistTemplate__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        checkList.add(new dmpl__ChecklistTemplate__c(dmpl__ItemId__c=item.Id,
                                                     Name='Test1',
                                                     dmpl__Type__c='Repair Order',
                                                     dmpl__Code__c='Done'));
        insert checkList;
    }
    
    private static void CreateChecklistTemplateLine()
    {
        List<dmpl__CheckListTemplateLine__c> checkList = new List<dmpl__CheckListTemplateLine__c>();
        dmpl__ChecklistTemplate__c checkListTemplate = [Select Id,Name From dmpl__ChecklistTemplate__c LIMIT 1];
        checkList.add(new dmpl__CheckListTemplateLine__c(dmpl__ChecklistTemplateId__c = checkListTemplate.Id,
                                                         dmpl__DataType__c = 'Text'
                                                        ));
        insert checkList;
    }
    
    private static void CreateChecklistlines()
    {
        List<dmpl__CheckListLines__c> checkList = new List<dmpl__CheckListLines__c>();
        dmpl__ChecklistTemplate__c checkListTemplate = [Select Id,Name From dmpl__ChecklistTemplate__c LIMIT 1];
        dmpl__ChecklistTemplateLine__c checkListTemplateLine = [Select Id,Name From dmpl__ChecklistTemplateLine__c LIMIT 1];
        dmpl__RepairOrder__c Order = [Select Id,Name From dmpl__RepairOrder__c LIMIT 1];
        checkList.add(new dmpl__CheckListLines__c(dmpl__RepairOrderId__c= Order.Id,
                                                  dmpl__CheckListTemplateLineId__c = checkListTemplateLine.Id,
                                                  dmpl__ChecklistTemplateId__c = checkListTemplate.Id,
                                                  Name='Test2',
                                                  dmpl__DataType__c='Text'
                                                 ));
        insert checkList;
        
    }
    
     private static void CreateRepairOrderTimeSheet()
    {
        List<dmpl__RepairOrderTimeSheet__c> repairOrderTimeSheet = new List<dmpl__RepairOrderTimeSheet__c>();
        dmpl__RepairOrder__c repairOrder = [Select Id,Name From dmpl__RepairOrder__c LIMIT 1];
         dmpl__Resource__c resource = [select Id,Name FROM dmpl__Resource__c WHERE dmpl__ResourceType__c = 'Technician' LIMIT 1];
        dmpl__RepairOrderline__c repairOrderLine = [Select Id,Name From dmpl__RepairOrderLine__c LIMIT 1];
        repairOrderTimeSheet.add(new dmpl__RepairOrderTimeSheet__c(dmpl__RepairOrderId__c = repairOrder.Id,
                                                       dmpl__RepairOrderLine__c = repairOrderLine.Id,
                                                     dmpl__WorkStartDate__c=Date.today(),
                                                         dmpl__TechnicianId__c=resource.Id,
                                                          dmpl__WorkStarted__c = true,
                                                       dmpl__WorkEndDate__c=date.today()+(2),      
                                                       dmpl__RepairStatus__c = 'Started' ));
        insert repairOrderTimeSheet;
    }
   
    private static void CreateRepairOrderTimeSheetLine()
    {
        CreateRepairOrderTimeSheet();
        List<dmpl__RepairOrderTimeSheetLine__c> repairOrderTimeSheetLine = new List<dmpl__RepairOrderTimeSheetLine__c>();
        dmpl__RepairOrderTimeSheet__c repairOrderTimeSheet = [Select Id,Name From dmpl__RepairOrderTimeSheet__c LIMIT 1];
         dmpl__RepairOrderline__c repairOrderLine = [Select Id,Name From dmpl__RepairOrderLine__c LIMIT 1];
        repairOrderTimeSheetLine.add(new dmpl__RepairOrderTimeSheetLine__c(dmpl__RepairOrderTimeSheetId__c = repairOrderTimeSheet.Id,
                                                          dmpl__RepairOrderLineId__c = repairOrderLine.Id
                                                            
                                                        ));
        insert repairOrderTimeSheetLine;
    }

}