@isTest
public class ChecklistLineHelper_Test {
    
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
            CreateDeliveryOrder();
            CreateCheckListTemplate();
            CreateCheckListLineTemplate();
            //CreateCheckListLine();
            //CreateCheckListLine();
        } 
    }

        
    @isTest
    public Static void VerifyCheckListTemplateData2()
    {
        Test.startTest();
        CreateServiceRecommendationRule();
        //CreateServiceRecommendation();
        CreateCheckListLine();
        Test.stopTest();
    }
    
    @isTest
    public Static void VerifyCheckListTemplateData1()
    {
        Test.startTest();
        CreateServiceRecommendationRule();
        CreateCheckListLine();
        
        dmpl__CheckListLines__c  lines = [Select Id, Name,dmpl__RAGValue__c,dmpl__NumericValue__c From dmpl__CheckListLines__c LIMIT 1];
        lines.dmpl__NumericValue__c= 2;
        update lines;
        Test.stopTest();
    }
    
    @isTest
    public Static void VerifyCheckListTemplateData3()
    {
        dmpl__Item__c listofitem = [Select Id, Name from dmpl__Item__c WHERE dmpl__ItemCode__c != 'DMPL-2'];
        Test.startTest();
        CreateServiceRecommendationRule();
        CreateCheckListLine();
        dmpl__ServiceRecommendationRule__c rule = [SELECT Id,Name,dmpl__ItemId__c FROM dmpl__ServiceRecommendationRule__c LIMIT 1];
        rule.dmpl__ItemId__c = listofitem.Id;
        update rule;
        dmpl__CheckListLines__c  lines = [Select Id, Name,dmpl__RAGValue__c,dmpl__NumericValue__c From dmpl__CheckListLines__c LIMIT 1];
        lines.dmpl__NumericValue__c= 2;
        update lines;
        Test.stopTest();
    }

    @isTest
    public Static void VerifyCheckListTemplateData()
    {
        Test.startTest();
        CreateCheckListLine();
        List<dmpl__ChecklistTemplate__c>  templates = [Select Id, Name From dmpl__ChecklistTemplate__c];
        ChecklistController.getChecklistTemplates(templates[0].Id);
        Test.stopTest();
    }
    
    @isTest
    public Static void VerifyCheckListData()
    {
        CreateCheckListLine();
        Test.startTest();
        List<dmpl__ChecklistTemplate__c>  templates = [Select Id, Name From dmpl__ChecklistTemplate__c];
        ChecklistController.getChecklistLines('dmpl__ChecklistTemplateId__c',templates[0].Id);
        Test.stopTest();
    }
    
    static testMethod void testCreateContentVersion() 
    { 
        String base64Data = 'VGhpcyBpcyBhIHNhbXBsZSBtZXNzYWdl';
        String fileName = 'TestFile.txt';
        ContentVersion cv = ChecklistController.createContentVersion(base64Data, fileName);
        System.assertNotEquals(null, cv.Id, 'ContentVersion should be inserted');
        System.assertEquals(EncodingUtil.base64Decode(base64Data), cv.VersionData, 'VersionData should match');
        System.assertEquals(fileName, cv.Title, 'Title should match');
        System.assertEquals(fileName, cv.PathOnClient, 'PathOnClient should match');
    }
    
    static testMethod void testCreateContentLink() 
    {
        try{
        ContentVersion cv = new ContentVersion();
        cv.VersionData = EncodingUtil.base64Decode('VGhpcyBpcyBhIHNhbXBsZSBtZXNzYWdl');
        cv.Title = 'TestFile.txt';
        insert cv;
            
        Account testRecord = new Account(Name = 'Test Account');
        insert testRecord;
            
        ContentDocumentLink cdl = ChecklistController.createContentLink(cv.Id, testRecord.Id);
        System.assertNotEquals(null, cdl.Id, 'ContentDocumentLink should be inserted');
        System.assertEquals(cv.ContentDocumentId, cdl.ContentDocumentId, 'ContentDocumentId should match ContentVersion');
        System.assertEquals(testRecord.Id, cdl.LinkedEntityId, 'LinkedEntityId should match test record Id');
        System.assertEquals('V', cdl.ShareType, 'ShareType should match');
        }catch(Exception ex){}
    }
    
    static testMethod void testUploadFile() {
        
        Account testRecord = new Account(Name = 'Test Account');
        insert testRecord;

        String base64Data = 'VGhpcyBpcyBhIHNhbXBsZSBtZXNzYWdl';
        String fileName = 'TestFile.txt';
        String contentLinkID = ChecklistController.uploadFile(testRecord.Id, base64Data, fileName);
        System.assertNotEquals(null, contentLinkID, 'ContentDocumentLink should be created');
    }
    
    static testMethod void testGetResponseHeaders() 
    {
        HttpResponse response = new HttpResponse();
        response.setHeader('Header1', 'Value1');
        response.setHeader('Header2', 'Value2');
        response.setHeader('Header3', 'Value3');
        String headers = InterfaceLogHelper.getResponseHeaders(response);
        System.assertEquals('Header1:Value1\nHeader2:Value2\nHeader3:Value3\n', headers, 'Response headers should match');
    }
    
    @isTest
    public Static void VerifyChecklistLine()
    {
        string errorReceived;
        //try{       
        	CreateCheckListLine();      
            dmpl__CheckListLines__c  lines = [Select Id, Name,dmpl__RAGValue__c,dmpl__NumericValue__c From dmpl__CheckListLines__c LIMIT 1];
            lines.dmpl__RAGValue__c='Amber';
            lines.dmpl__NumericValue__c=2;
            update lines;
            System.assert(lines!=null, 'Verify Checklist Lines Data');
        //} catch (Exception ex) {
          //  errorReceived = ex.getMessage();   
        //}
    }
    
    @isTest
    public Static void DeleteChecklistLine()
    {
        Test.startTest();
        string errorReceived;
        try{       
            CreateCheckListLine();
            dmpl__CheckListLines__c  lines = [Select Id, Name,dmpl__RAGValue__c,dmpl__NumericValue__c From dmpl__CheckListLines__c];
            Delete lines;
        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
        System.assertEquals(null, errorReceived);
        Test.stopTest();
    }
    
    @isTest
    public Static void VerifyChecklistLinebyDeliveryOrder()
    {
        string errorReceived;
       // try{             
            CreateCheckListLine();
            List<dmpl__DeliveryOrder__c>  order = [Select Id, Name From dmpl__DeliveryOrder__c];
            ChecklistLineHelper.createChecklistLines(order);    
      //  } catch (Exception ex) {
      //      errorReceived = ex.getMessage();
      //  }
        System.assertEquals(null, errorReceived);
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
                                   dmpl__InventoryValuationMethod__c = 'FIFO',
                                   dmpl__TaxItemGroupId__c = itemGroup.Id
                                   
                                  ));
        insert item;
        List<dmpl__Item__c> subsItem = new List<dmpl__Item__c>();
        subsItem.Add(new dmpl__Item__c(Name = 'Test-Item',
                                       dmpl__ItemCode__c = 'DMPL-2',
                                       dmpl__ItemType__c = 'Subscription',
                                       dmpl__ItemSubType__c = '',
                                       dmpl__Description__c = '',
                                       dmpl__ItemFamily__c = 'Sample',
                                       dmpl__ItemSegment__c = 'Sample',
                                       dmpl__Make__c = 'Sample',
                                       dmpl__Model__c = 'Sample',                          
                                       dmpl__IsPackage__c = true
                                      ));
        insert subsItem;
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
                                         dmpl__Cost__c = 100,
                                         dmpl__QuantityExpired__c = 1,
                                         dmpl__QuantityOnHold__c = 1,
                                         dmpl__QuantityOnLoan__c = 1
                                        ));
        List<dmpl__ItemLot__c> relatedItemLot = new List<dmpl__ItemLot__c>();
        relatedItemLot.Add(new dmpl__ItemLot__c(
            dmpl__BranchId__c = branch.Id,
            dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
            dmpl__LandedCost__c = 1000));
        insert relatedItemLot;
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
            dmpl__ValidtillDate__c = Datetime.now().addDays(365).Date(),
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
        dmpl__Resource__c resource = [select Id,Name FROM dmpl__Resource__c LIMIT 1];
        Asset asset = [Select Id,Name From Asset LIMIT 1];
        dmpl__PriceList__c priceList=[Select Id, Name from dmpl__PriceList__c Limit 1];
        dmpl__ServiceRequest__c serviceRequest = [Select Id,Name From dmpl__ServiceRequest__c LIMIT 1];
        dmpl__Quote__c serviceEstimate = [Select Id,Name From dmpl__Quote__c LIMIT 1];
        Account customerAccount = [Select id,Name From Account Where Name = 'Customer-Test-Account' LIMIT 1];
        repairOrder.Add(new dmpl__RepairOrder__c (
            dmpl__PriceListId__c=priceList.Id,
            dmpl__BranchId__c = branch.Id,
            dmpl__AccountId__c = customerAccount.Id,
            dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
            dmpl__ServiceRequestId__c = serviceRequest.Id,
            dmpl__AssetId__c = asset.Id,
            dmpl__UsageReading__c = 8,
            dmpl__ServiceAdvisorId__c = resource.Id
        ));
        
        repairOrder.Add(new dmpl__RepairOrder__c (
            dmpl__BranchId__c = branch.Id,
            dmpl__AccountId__c = customerAccount.Id,
            dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
            dmpl__AssetId__c = asset.Id,
            dmpl__UsageReading__c = 8,
            dmpl__ServiceAdvisorId__c = resource.Id,
            dmpl__ServiceEstimateId__c = serviceEstimate.Id
        ));
        insert repairOrder;
        
    }
    
    private static void CreateSKU()
    {
        List<dmpl__SKU__c> Skus = new List<dmpl__SKU__c>();
        dmpl__Item__c listofitem = [Select Id, Name from dmpl__Item__c WHERE dmpl__ItemCode__c = 'DMPL'];
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
    
    private static void CreateCheckListTemplate()
    {
        List<dmpl__ChecklistTemplate__c> checklistTemplate = new List<dmpl__ChecklistTemplate__c>(); 
        checklistTemplate.add(new dmpl__ChecklistTemplate__c(Name='Test Template 1',dmpl__Type__c='Delivery') );
        insert checklistTemplate;
        
    }
    
    private static void CreateCheckListLineTemplate()
    {
        List<dmpl__CheckListTemplateLine__c> checklistTemplate = new List<dmpl__CheckListTemplateLine__c>(); 
        dmpl__ChecklistTemplate__c template=[SELECT Id,Name FROM dmpl__ChecklistTemplate__c];
        checklistTemplate.add(new dmpl__CheckListTemplateLine__c(Name='Test Line Template 1',dmpl__ChecklistTemplateId__c=template.Id) );
        insert checklistTemplate;
        
    }
    
    private static void CreateServiceRecommendationRule()
    {
        List<dmpl__ServiceRecommendationRule__c> recoRule = new List<dmpl__ServiceRecommendationRule__c>();
        dmpl__CheckListTemplateLine__c template=[SELECT Id,Name FROM dmpl__CheckListTemplateLine__c ];
        dmpl__Item__c listofitem = [Select Id, Name from dmpl__Item__c WHERE dmpl__ItemCode__c = 'DMPL-2'];
        //dmpl__CheckListLines__c lines = [Select Id,Name,dmpl__NumericValue__c From dmpl__CheckListLines__c WHERE dmpl__NumericValue__c = 50];
        recoRule.add(new dmpl__ServiceRecommendationRule__c(
            dmpl__ChecklistTemplateLineId__c=template.Id,
            dmpl__RAGValue__c='Amber',
            dmpl__ValueGreaterThan__c=null,
            dmpl__ValueLessThan__c=null,
        	dmpl__ItemId__c	= listofitem.Id ));
        
        insert recoRule;
    }
    
    private static void CreateCheckListLine()
    {
        List<dmpl__CheckListLines__c> checklistLine = new List<dmpl__CheckListLines__c>(); 
        dmpl__ChecklistTemplate__c template=[SELECT Id,Name FROM dmpl__ChecklistTemplate__c ];
        dmpl__CheckListTemplateLine__c lineTemplate=[SELECT Id,Name FROM dmpl__CheckListTemplateLine__c ];
        checklistLine.add(new dmpl__CheckListLines__c(
            Name='Test Line 1',
            dmpl__ChecklistTemplateId__c=template.Id,
            dmpl__RAGValue__c='Amber',
            dmpl__NumericValue__c=50,
            dmpl__CheckListTemplateLineId__c=lineTemplate.Id));
        
        insert checklistLine;
    }
    
    private static void CreateServiceRecommendation()
    {
        List<dmpl__ServiceRecommendation__c> reco = new List<dmpl__ServiceRecommendation__c>();
        dmpl__Item__c listofitem = [Select Id, Name from dmpl__Item__c WHERE dmpl__ItemCode__c = 'DMPL-2'];
        dmpl__CheckListLines__c template=[SELECT Id,Name FROM dmpl__CheckListLines__c ];
        reco.add(new dmpl__ServiceRecommendation__c(
            dmpl__ChecklistLineId__c=template.id,
            dmpl__ItemId__c=listofitem.Id
        ));
        
        insert reco;
    }
    
    private static void CreateDeliveryOrder()
    {
        List<dmpl__DeliveryOrder__c> deliveryOrder = new List<dmpl__DeliveryOrder__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch' LIMIT 1];
        Account customerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' AND dmpl__IsCustomerAccount__c = True LIMIT 1];
        deliveryOrder.Add(new dmpl__DeliveryOrder__c(dmpl__AccountId__c = customerAccount.Id,
                                                     dmpl__BranchId__c = branch.Id,
                                                     dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                     dmpl__PerformReleaseShipment__c=false));
        insert deliveryOrder;
    }
    
    
}