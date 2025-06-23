@isTest
public class FieldSalesHelper_Test {
    @testSetup
    public static void Setup()
    {
        //System.runAs(PostInstallHelper.AssignAdministratorAllPermissions(UserInfo.getUserId())){
        CreateAccountGroup();
        CreateBranch();
        CreateStorageLocation();
        CreateItems();
        CreateSKu();
        CreateItemLot();        
        CreateResource();
        CreateSaleInvoice();
        CreateSaleInvoiceLine();
        CreateFieldSales();
        test.startTest();
        CreateFieldSalesInvoice();
        test.stopTest();
  }
    @isTest
    public static void  updateFieldSales(){
        List<dmpl__FieldSales__c> fieldSales=[Select Id,dmpl__BranchId__c,dmpl__PerformLoad__c,dmpl__PerformUnload__c,dmpl__PartnerAccountId__c,dmpl__ResourceId__c,dmpl__PerformReleaseLoad__c,dmpl__PerformReleaseUnLoad__c,dmpl__PerformReleaseVisitPlan__c From dmpl__FieldSales__c limit 1];
        //fieldSales[0].dmpl__PerformReleaseLoad__c=true;
        fieldSales[0].dmpl__PerformReleaseVisitPlan__c=true;
        //fieldSales[0].dmpl__PerformReleaseUnload__c=true;
        fieldSales[0].dmpl__PerformLoad__c=true;
       // fieldSales[0].dmpl__PerformUnload__c=true;
        update fieldSales;
    }
    @isTest
    public static void test1(){
        List<dmpl__FieldSales__c> fieldSales=[Select Id,dmpl__BranchId__c,dmpl__PartnerAccountId__c,dmpl__ResourceId__c,dmpl__VisitRouteGroupId__c,dmpl__VisitTaskTemplateId__c,dmpl__PerformReleaseLoad__c,dmpl__PerformReleaseUnLoad__c From dmpl__FieldSales__c limit 1];        
        FieldSalesHelper.createVisitPlan(fieldSales);
        //FieldSalesHelper.createTransferForUnload(fieldSales);
        FieldSalesHelper.createTransferForLoad(fieldSales);
        TransferHelper.createTransferForLoadFromFieldSales(fieldSales[0].Id);
        Test.startTest();
          FieldSalesHelper.createTransferForUnload(fieldSales);
          FieldSalesHelper.updateCollectedAmount(fieldSales);
          FieldSalesHelper.updateFieldSalesLine(fieldSales);
          FieldSalesHelper.createVisit(fieldSales);
        //  FieldSalesLineHelper.createItemLot(fieldSalesLines,itemLot,itemLot,fieldSaless);
        Test.StopTest();
    }
    @isTest
public static void test2(){
    Test.startTest();
    try {
        List<SourceObjectInfo> info = new List<SourceObjectInfo>();
        
        dmpl__ItemLot__c oldLot = [
            SELECT Id, Name,
                   dmpl__BatchNo__c, dmpl__SerialNumber__c, dmpl__ComponentNumber__c,
                   dmpl__RegistrationNumber__c, dmpl__SupplierInvoiceNumber__c,
                   dmpl__DateOfSupplierInvoice__c, dmpl__DateOfSupplierDispatch__c,
                   dmpl__PurchaseDate__c, dmpl__Cost__c, dmpl__DateOfExpiry__c,
                   dmpl__DateOfMfg__c, dmpl__DateOfReceipt__c, dmpl__ItemId__c,
                   dmpl__MRP__c, dmpl__SKUId__c, dmpl__ItemLotTypeId__c
            FROM dmpl__ItemLot__c
            LIMIT 1
        ];

        dmpl__ItemLot__c newLot = oldLot.clone(false, true, false, false);
        newLot.dmpl__BatchNo__c = oldLot.dmpl__BatchNo__c + '-T2';
        insert newLot;

        dmpl__FieldSalesLine__c fieldSalesLines = [
            SELECT Id, Name
            FROM dmpl__FieldSalesLine__c
            LIMIT 1
        ];
        List<dmpl__FieldSalesLine__c> ListfieldSalesLines = new List<dmpl__FieldSalesLine__c>{ fieldSalesLines };
        dmpl__FieldSales__c fieldSaless = [
            SELECT Id, Name,
                   dmpl__PartnerAccountId__c, dmpl__BranchId__c, dmpl__StorageLocationId__c
            FROM dmpl__FieldSales__c
            LIMIT 1
        ];

        FieldSalesHelper.createTransferForUnload(info);
        FieldSalesHelper.createTransferForLoad(info);
        FieldSalesHelper.createVisitPlan(info);

        FieldSalesLineHelper.getOldTransferLine(ListfieldSalesLines, fieldSalesLines);

        FieldSalesLineHelper.createItemLot(fieldSalesLines, oldLot, newLot, fieldSaless);

    } catch (Exception ex) {
        // for future use
    }
    Test.stopTest();
}

    private static void CreateAccountGroup()
    {
        dmpl__AccountGroup__c priceAccountGroup= new dmpl__AccountGroup__c (Name= 'Test-AccountGroup', 
                                                                            dmpl__AccountGroupType__c='Price');
        insert priceAccountGroup;
        
        dmpl__AccountGroup__c schemeAccountGroup= new dmpl__AccountGroup__c (Name= 'Test-AccountGroup1', 
                                                                             dmpl__AccountGroupType__c='Scheme');
        insert schemeAccountGroup;
        
        dmpl__AccountGroup__c discountAccountGroup= new dmpl__AccountGroup__c (Name= 'Test-AccountGroup2', 
                                                                               dmpl__AccountGroupType__c='Discount');
        insert discountAccountGroup;        
        
        dmpl__AccountGroup__c itemFeatureAccountGroup= new dmpl__AccountGroup__c (Name= 'Test-AccountGroup3', 
                                                                                  dmpl__AccountGroupType__c='Item Feature');
        insert itemFeatureAccountGroup;        
        
        List<Account> account = new List<Account>();
        account.add(new Account(Name = 'lastName1',
                                dmpl__LastName__c = 'Service Estimate',
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
                                dmpl__CustomerPriceAccountGroupId__c = priceAccountGroup.Id,
                                dmpl__CustomerDiscountAccountGroupId__c = discountAccountGroup.Id,
                                dmpl__PartnerSchemeAccountGroupId__c = schemeAccountGroup.Id,                                
                                dmpl__PartnerPriceAccountGroupId__c = priceAccountGroup.Id,
                                dmpl__PartnerDiscountAccountGroupId__c = discountAccountGroup.Id,
                                dmpl__CustomerSchemeAccountGroupId__c = schemeAccountGroup.Id));
        insert account; 
        Account supplieraccount = new Account(Name = 'Supplier-Test-Account',dmpl__IsSupplierAccount__c = True,dmpl__LastName__c = 'Account', dmpl__IsActive__c = true);
        insert supplieraccount;
        Account partnerAccount = new Account(Name = 'Partner-Test-Account',
                                             dmpl__LastName__c = 'Service Estimate',
                                             dmpl__IsPartnerAccount__c = True,
                                             dmpl__PartnerSchemeAccountGroupId__c = schemeAccountGroup.Id,                                
                                             dmpl__PartnerPriceAccountGroupId__c = priceAccountGroup.Id,
                                             dmpl__PartnerDiscountAccountGroupId__c = discountAccountGroup.Id,
                                             dmpl__IsActive__c = true);
        insert partneraccount;
        
        Account  customerAccount = new Account(Name = 'Customer-Test-Account',
                                               dmpl__LastName__c = 'Service Estimate',
                                               dmpl__IsCustomerAccount__c = True,
                                               dmpl__CustomerPriceAccountGroupId__c = priceAccountGroup.Id,
                                               dmpl__CustomerDiscountAccountGroupId__c = discountAccountGroup.Id,
                                               dmpl__CustomerSchemeAccountGroupId__c = schemeAccountGroup.Id,
                                               dmpl__IsActive__c = true);
        insert customerAccount;
        
        dmpl__AccountGroupMember__c partnerAccountGroupMember = new dmpl__AccountGroupMember__c
            (dmpl__AccountGroupId__c=discountAccountGroup.Id,
             dmpl__AccountId__c=partnerAccount.Id
            );
        Insert partnerAccountGroupMember;
        
        dmpl__AccountGroupMember__c customerAccountGroupMember = new dmpl__AccountGroupMember__c
            (dmpl__AccountGroupId__c=discountAccountGroup.Id,
             dmpl__AccountId__c=customerAccount.Id
            );
        Insert customerAccountGroupMember;
        
        
    }
    
    private static void CreateBranch()
    {
        List<dmpl__Branch__c> branches = new List<dmpl__Branch__c>();
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        branches.Add(new dmpl__Branch__c(dmpl__PartnerAccountId__c =partnerAccount.Id,
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
        insert branches;
        
  
    }
    private static void CreateItems()
    {
        List<dmpl__Item__c> items = new List<dmpl__Item__c>();
        items.Add(new dmpl__Item__c(Name = 'Test-Item',
                                    dmpl__ItemCode__c = 'DMPL',
                                    dmpl__ItemType__c = 'Product',
                                    dmpl__ItemSubType__c = '',
                                    dmpl__Description__c = '',
                                    //dmpl__ItemFamily__c = 'Sample',
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
                                    dmpl__RFID__c = 'O1234fgh' ));
        
        items.Add(new dmpl__Item__c(Name = 'Test-Item',
                                    dmpl__ItemCode__c = 'TEST003',
                                    dmpl__ItemType__c = 'Service Contract',
                                    dmpl__ItemSubType__c = '',
                                    dmpl__Description__c = '',
                                    //dmpl__ItemFamily__c = 'Sample',
                                    dmpl__ItemSegment__c = 'Sample',
                                    dmpl__Make__c = 'Sample',
                                    dmpl__Model__c = 'Sample',
                                    dmpl__TrackInventory__c = true,
                                    dmpl__TrackLots__c = true,
                                    dmpl__IsSKURequired__c = false,
                                    dmpl__RequireInspectionOnReceipt__c = true,
                                    dmpl__RequireInspectionOnDelivery__c = true,
                                    dmpl__AllowService__c = true,
                                    dmpl__TrackAsset__c = true,                               
                                    dmpl__IsActive__c = true,
                                    dmpl__IsRegistrationRequired__c = true
                                   ));
        
        items.Add(new dmpl__Item__c(Name = 'Part',
                                    dmpl__ItemCode__c = 'TEST002',
                                    dmpl__ItemType__c = 'Part',
                                    dmpl__ItemSubType__c = '',
                                    dmpl__Description__c = '',
                                    //dmpl__ItemFamily__c = 'Sample',
                                    dmpl__ItemSegment__c = 'Sample',
                                    dmpl__Make__c = 'Sample',
                                    dmpl__Model__c = 'Sample',
                                    dmpl__TrackInventory__c = true,
                                    dmpl__TrackLots__c = true,
                                    dmpl__IsSKURequired__c = false,
                                    dmpl__RequireInspectionOnReceipt__c = true,
                                    dmpl__RequireInspectionOnDelivery__c = true,
                                    dmpl__AllowService__c = true,
                                    dmpl__TrackAsset__c = true,                               
                                    dmpl__IsActive__c = true,
                                    dmpl__IsRegistrationRequired__c = true
                                   ));
        
        insert items;
    }
    private static void CreateSKu()
    {
        List<dmpl__SKU__c> skus = new List<dmpl__SKU__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c Where Name = 'Test-Item' LIMIT 1];
        skus.add(new dmpl__SKU__c(Name = 'Test - SKU',
                                  dmpl__SKUCode__c = 'Test - SKU - Code',
                                  dmpl__UnitOfMeasureOfConversion__c = 10,
                                  dmpl__ProductColor__c = 'Sample',
                                  dmpl__IsDefault__c = false,
                                  //dmpl__QuantityUnitOfMeasure__c ='Sample',
                                  dmpl__ItemId__c = item.Id));
        insert skus; 
    }

    private static void CreateResource()
    {
        List<dmpl__Resource__c> resource = new List<dmpl__Resource__c>();
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c WHERE Name = 'Test-Branch' LIMIT 1];
        resource.add(new dmpl__Resource__c(Name = 'Test - Resource',
                                           dmpl__Type__c = 'None',
                                           dmpl__IsActive__c = true,
                                           dmpl__Phone__c = '9999999999',
                                           dmpl__DefaultPartnerAccountId__c = partnerAccount.Id,
                                           dmpl__DefaultBranchId__c = branch.Id,
                                           dmpl__UserId__c = userInfo.getUserId()));
        insert resource;
        
    }
    
    private static void CreatePartnerResource()
    {
        List<dmpl__PartnerResource__c> partnerResource = new List<dmpl__PartnerResource__c>();
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c WHERE Name = 'Test-Branch' LIMIT 1];
        dmpl__Resource__c resource = [SELECT Id, Name FROM dmpl__Resource__c WHERE Name = 'Test - Resource' LIMIT 1];
        partnerResource.add(new dmpl__PartnerResource__c (dmpl__PartnerAccountId__c = partnerAccount.Id,
                                                          dmpl__BranchId__c = branch.Id,
                                                          dmpl__ResourceId__c = resource.Id
                                                         ));
        
        insert partnerResource;
    }
    
    private static void CreateStorageLocation()
    {
        List<dmpl__StorageLocation__c> storageLocations =  new List<dmpl__StorageLocation__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__ParentLocationId__c From dmpl__Branch__c];
        storageLocations.Add(new dmpl__StorageLocation__c(dmpl__BranchId__c = branch.Id,
                                                          dmpl__ParentLocationId__c = branch.dmpl__ParentLocationId__c,
                                                          dmpl__AllowInventory__c=true,
                                                          dmpl__IsMobile__c=true,
                                                          dmpl__IsActive__c=true,
                                                          dmpl__LocationType__c='Washing Bay'));
        insert storageLocations;
        
    }
    
    private static void CreateItemLot()
    {
        List<dmpl__ItemLot__c> itemLots = new List<dmpl__ItemLot__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c limit 1];
        dmpl__StorageLocation__c storageLocation = [Select Id, Name FROM dmpl__StorageLocation__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id ,Name,dmpl__ItemId__c From dmpl__SKU__c WHERE Name = 'Test - SKU' LIMIT 1 ];
        itemLots.Add(new dmpl__ItemLot__c(dmpl__BranchId__c = branch.Id,
                                          dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                          dmpl__ItemId__c = sku.dmpl__ItemId__c,
                                          dmpl__StorageLocationId__c = storageLocation.Id,
                                          dmpl__SKUId__c =sku.Id,
                                          dmpl__BatchNo__c = 'ZAY',
                                          dmpl__SerialNumber__c='BBBC',
                                          dmpl__SupplierInvoiceNumber__c='hfg',
                                          dmpl__DateOfReceipt__c= date.today(),
                                          dmpl__DateOfMfg__c=date.today(),
                                          dmpl__TotalCost__c=10.2,
                                          dmpl__DateOfSupplierInvoice__c=date.today(),
                                          dmpl__Cost__c=40.3
                                         ));
        insert itemLots;
    }
    private static void CreateFieldSales(){
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c limit 1];
        dmpl__StorageLocation__c storageLocation = [Select Id, Name FROM dmpl__StorageLocation__c LIMIT 1];
        dmpl__Resource__c resource=[Select Id from dmpl__Resource__c limit 1];
        List<dmpl__FieldSales__c> fieldSales=new List<dmpl__FieldSales__c>();
        fieldSales.add(new dmpl__FieldSales__c(dmpl__BranchId__c=branch.Id,
                                               dmpl__PartnerAccountId__c=branch.dmpl__PartnerAccountId__c,
                                               dmpl__ResourceId__c=resource.Id,
                                               dmpl__PerformReleaseUnload__c=false,
                                               dmpl__PerformReleaseLoad__c=false,
                                               dmpl__PerformReleaseVisitPlan__c=false,
                                               dmpl__IsLoadReleased__c=false,
                                               dmpl__DocumentDate__c=system.Today()));
        insert fieldSales;
        dmpl__Item__c item=[Select Id from dmpl__Item__c limit 1];
        List<dmpl__FieldSalesLine__c> salesLine=new List<dmpl__FieldSalesLine__c>();
        salesLine.add(new dmpl__FieldSalesLine__c(dmpl__ItemId__c=item.Id,
                                                  dmpl__FieldSalesId__c=fieldSales[0].Id,
                                                  dmpl__Quantity__c=3));
        insert salesLine;
    }
    
    @isTest
    private static void updateFieldSalesLine(){
        Test.startTest();
        try{
            List<dmpl__FieldSalesLine__c> fieldSalesLines = [SELECT Id,Name,dmpl__Quantity__c FROM dmpl__FieldSalesLine__c LIMIT 1];
            fieldSalesLines[0].dmpl__Quantity__c = 4;
            update fieldSalesLines;
        }catch(exception ex){}
        Test.stopTest();
    }
    
    private static void CreateFieldSalesInvoice(){
        List<dmpl__FieldSalesInvoice__c> fieldSalesInvoice=new List<dmpl__FieldSalesInvoice__c>();
        List<dmpl__SaleInvoice__c> invoice = [SELECT Id FROM dmpl__SaleInvoice__c LIMIT 1];
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__FieldSales__c fieldSales=[SELECT Id FROM dmpl__FieldSales__c LIMIT 1];
        fieldSalesInvoice.add(new dmpl__FieldSalesInvoice__c(dmpl__AccountId__c  = partnerAccount.Id,
                                                             dmpl__FieldSalesId__c  = fieldSales.Id,
                                                             dmpl__InvoiceId__c = invoice[0].Id
        ));
        insert fieldSalesInvoice;
    }
    
    private static void CreateSaleInvoice()
    {
        Account account = [SELECT Id FROM Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        Account partner = [SELECT Id FROM Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [SELECT Id FROM dmpl__Branch__c LIMIT 1];
        dmpl__Item__c item = [SELECT Id FROM dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [SELECT Id FROM dmpl__SKU__c LIMIT 1];
        dmpl__ItemLot__c itemLot = [SELECT Id FROM dmpl__ItemLot__c LIMIT 1];
        
        List<dmpl__SaleInvoice__c> saleInvoice = new List<dmpl__SaleInvoice__c>();
        saleInvoice.add(new dmpl__SaleInvoice__c(dmpl__AccountId__c = account.Id,
                                                 dmpl__PartnerAccountId__c = partner.Id,
                                                 dmpl__BranchId__c = branch.Id,
                                                 dmpl__DocumentDate__c = Date.today()));
        insert saleInvoice;
    }
    
    private static void CreateSaleInvoiceLine()
    {
        dmpl__SaleInvoice__c saleInvoice = [SELECT Id FROM dmpl__SaleInvoice__c];
        dmpl__Item__c item = [SELECT Id FROM dmpl__Item__c WHERE dmpl__ItemCode__c = 'DMPL' LIMIT 1];
        dmpl__SKU__c sku = [SELECT Id FROM dmpl__SKU__c WHERE dmpl__ItemId__r.dmpl__ItemCode__c = 'DMPL' LIMIT 1];
        dmpl__ItemLot__c itemLot = [SELECT Id FROM dmpl__ItemLot__c WHERE dmpl__SerialNumber__c = 'BBBC' LIMIT 1];
        List<dmpl__SaleInvoiceLine__c> saleInvoiceLine = new List<dmpl__SaleInvoiceLine__c>();
        saleInvoiceLine.add(new dmpl__SaleInvoiceLine__c(dmpl__SaleInvoiceId__c = saleInvoice.Id,
                                                         dmpl__Quantity__c = 1,
                                                         dmpl__ItemLotId__c = itemLot.Id,
                                                         dmpl__UnitPrice__c = 100,
                                                         dmpl__SkuId__c = sku.Id,
                                                         dmpl__ItemId__c = item.Id));
        insert saleInvoiceLine;       
    }
}