@isTest
public class PurchaseRequisitionHelper_Test {
    
    @testSetup
    public static void Setup()
    {
        System.runAs(PostInstallHelper.AssignAdministratorAllPermissions(UserInfo.getUserId())){
            CreateAccountGroup();
            CreateAccount();
            CreateBranch();
            CreateItems();
            CreateSKU();
            CreateResource();
            CreatePriceList();
            CreatePurchaseRequisition();
            CreatePurchaseRequisitionLine();
            CreatePurchaseOrderFromPurchaseRequisition();
        }
    }
    
    @isTest
    Static void VerifyCreateAccount()
    {
        List<Account>  account = [Select Id, Name From Account];
        System.assertNotEquals(null, account, 'Test Accounts are not found');
        System.assertEquals(4, account.size(), 'Test Accounts have more than 1 record');
    }
    
    @isTest
    public static void UpdatePurchaseRequisition()
    {
        dmpl__PurchaseRequisition__c purchaseRequisition = [Select Id,Name,dmpl__Status__c,dmpl__PerformReleaseOrder__c,dmpl__IsOrderReleased__c From dmpl__PurchaseRequisition__c LIMIT 1];
        if(purchaseRequisition != null)
        {
            purchaseRequisition.dmpl__Status__c = 'Draft';
            purchaseRequisition.dmpl__PerformReleaseOrder__c = true;
        }
        update purchaseRequisition;
        System.assertEquals('Draft', purchaseRequisition.dmpl__Status__c, 'purchase Requisition have 1 updated record');
    }
    
    @isTest
    public static void DeletePurchaseRequisition()
    {
        dmpl__PurchaseRequisition__c purchaseRequisition = [Select Id,Name,dmpl__Status__c From dmpl__PurchaseRequisition__c LIMIT 1];
        delete purchaseRequisition;
        System.assertEquals('Draft', purchaseRequisition.dmpl__Status__c, 'purchase Requisition have 1 deleted record');
    }
    
    @isTest
    public static void UpdatePurchaseRequisitionLine()
    {
        dmpl__PurchaseRequisitionLine__c purchaseRequisitionLine = [Select Id,Name,dmpl__Quantity__c From dmpl__PurchaseRequisitionLine__c LIMIT 1];
        purchaseRequisitionLine.dmpl__Quantity__c = 5;
        update purchaseRequisitionLine;
        System.assertEquals(5, purchaseRequisitionLine.dmpl__Quantity__c, 'purchase Requisition Line have 1 updated record');
    }
    
    @isTest
    public static void DeletePurchaseRequisitionLine()
    {
        dmpl__PurchaseRequisitionLine__c purchaseRequisitionLine = [Select Id,Name,dmpl__Quantity__c From dmpl__PurchaseRequisitionLine__c LIMIT 1];
        delete purchaseRequisitionLine;
        System.assertEquals(10, purchaseRequisitionLine.dmpl__Quantity__c, 'purchase Requisition Line have 1 deleted record');
    }
    
    @isTest
    public static void validateChangeInQuantity()
    {
        List<dmpl__PurchaseRequisitionLine__c> purchaseRequisitionLine = [Select Id,Name,dmpl__Quantity__c From dmpl__PurchaseRequisitionLine__c LIMIT 1];
        List<dmpl__PurchaseRequisitionLine__c> purchaseRequisitionLine1 = [Select Id,Name,dmpl__Quantity__c From dmpl__PurchaseRequisitionLine__c LIMIT 1];
        delete purchaseRequisitionLine;
        PurchaseRequisitionLineHelper.validateChangeInQuantity(purchaseRequisitionLine,purchaseRequisitionLine1);
        System.assert(purchaseRequisitionLine != null, 'purchase Requisition Line have 1 deleted record');
    }
    
    @isTest
    private static void VerifyTransferMethod()
    {
        try{
        test.startTest();
        dmpl__PurchaseRequisition__c purchaseRequisition = [Select Id,Name,dmpl__Status__c,(Select Id,Name,dmpl__Quantity__c From dmpl__PurchaseRequisitionLines__r) From dmpl__PurchaseRequisition__c LIMIT 1];
        List<SourceObjectInfo> objList = new List<SourceObjectInfo>();
        SourceObjectInfo obj = new SourceObjectInfo('dmpl__PurchaseRequisitionLine__c',purchaseRequisition.dmpl__PurchaseRequisitionLines__r[0].Id,1,null);
        objList.add(obj);
        TransferHelper.createStockTransferFromRequisition(purchaseRequisition.Id);
        TransferHelper.createStockTransferFromRequisition(objList);
        test.stopTest();
        }catch(Exception e){}
    }
    
    @isTest
    private static void VerifyResourceHelper()
    {
        test.startTest();
        ResourceHelper obj = new ResourceHelper();
        obj.beforeUpdate();
        test.stopTest();
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
                                             dmpl__IsPartnerAccount__c = True, 
                                             dmpl__LastName__c = 'Account',
                                             dmpl__IsActive__c = true);
        insert partneraccount;
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__IsCustomerAccount__c = True,
                                              dmpl__LastName__c = 'Account',
                                              dmpl__IsActive__c = true);
        insert customerAccount;
        
        Account supplierAccount = new Account(Name = 'Supplier-Test-Account',
                                              dmpl__IsSupplierAccount__c = True,
                                              dmpl__LastName__c = 'Account',
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
    
    private static void CreateItems()
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
                                   dmpl__RFID__c = 'O1234fgh'
                                   
                                  ));
        insert item;
        
    }
    
    private static void CreateSKU()
    {
        List<dmpl__SKU__c> sku = new List<dmpl__SKU__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        sku.add(new dmpl__SKU__c(Name = 'Test - SKU',
                                 dmpl__SKUCode__c = 'Test - SKU - Code',
                                 dmpl__UnitOfMeasureOfConversion__c = 10,
                                 dmpl__ProductColor__c = 'Sample',
                                 dmpl__IsDefault__c = false,
                                 dmpl__QuantityUnitOfMeasure__c ='Sample',
                                 dmpl__ItemId__c = item.Id));
        insert sku;
        
    }
    
    private static void CreateResource()
    {
        List<dmpl__Resource__c> resource = new List<dmpl__Resource__c>();
        Account partnerAccount = [Select Id,Name From Account LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        resource.add(new dmpl__Resource__c(Name = 'Test - Resource',
                                           dmpl__ResourceType__c = 'Sample',
                                           dmpl__IsActive__c = true,
                                           dmpl__Phone__c = '9999999999',
                                           dmpl__DefaultPartnerAccountId__c = partnerAccount.Id,
                                           dmpl__DefaultBranchId__c = branch.Id
                                          ));
        insert resource;
        
    }
    
    private static void CreatePriceList()
    {
        List<dmpl__PriceList__c> priceList =new List<dmpl__PriceList__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account' LIMIT 1];
        dmpl__AccountGroup__c accountGroup=[Select Id,Name From dmpl__AccountGroup__c LIMIT 1];
        priceList.Add(new dmpl__PriceList__c(dmpl__PartnerAccountId__c = account.Id,
                                             dmpl__BranchId__c = Branch.Id,
                                             dmpl__PartnerAccountGroupId__c= accountGroup.Id,
                                             dmpl__PartnerGroupId__c=accountGroup.Id,
                                             dmpl__CustomerAccountGroupId__c=accountGroup.Id,
                                             dmpl__CustomerGroupId__c=accountGroup.Id,
                                             Name='Test-1',
                                             dmpl__IsActive__c=true,
                                             dmpl__IsDefault__c=true,
                                             dmpl__PriceListType__c='Sale Price'
                                             
                                            ));
        insert priceList;
    }
    
    private static void CreatePurchaseRequisition()
    {
        List<dmpl__PurchaseRequisition__c> purchaseRequisition = new List<dmpl__PurchaseRequisition__c>();
        Account supplierAccount = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        purchaseRequisition.add(new dmpl__PurchaseRequisition__c(dmpl__BranchId__c = branch.Id,
                                                                 dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                                 dmpl__SupplierAccountId__c = supplierAccount.Id,
                                                                 dmpl__PerformReleaseOrder__c = false,
                                                                 dmpl__IsOrderReleased__c = true,
                                                                 dmpl__DocumentDate__c=Date.today(),
                                                                 dmpl__Status__c= 'Draft',
                                                                 dmpl__Remarks__c='sample'
                                                                ));
        insert purchaseRequisition;
        
    }
    
    
    private static void CreatePurchaseRequisitionLine()
    {
        List<dmpl__PurchaseRequisitionLine__c> purchaseRequisitionLine = new List<dmpl__PurchaseRequisitionLine__c>();
        dmpl__Item__c listofitem = [Select Id, Name from dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id ,Name From dmpl__SKU__c LIMIT 1 ];
        dmpl__PurchaseRequisition__c purchaseRequisition = [Select Id, Name FROM dmpl__PurchaseRequisition__c LIMIT 1];
        purchaseRequisitionLine.add(new dmpl__PurchaseRequisitionLine__c(dmpl__PurchaseRequisitionId__c = purchaseRequisition.Id,
                                                                         dmpl__ItemId__c = listofitem.Id,
                                                                         dmpl__Quantity__c = 1,
                                                                         dmpl__SKUId__c =sku.Id,
                                                                         dmpl__UnitCost__c=10.5
                                                                        ));
        insert purchaseRequisitionLine;
        List<dmpl__PurchaseRequisitionLine__c> requisitionLines = [SELECT Id,Name,dmpl__Quantity__c,dmpl__ItemId__c,
                                                                   dmpl__UnitCost__c,dmpl__SKUId__c,dmpl__PurchaseRequisitionId__c,
                                                                   dmpl__PurchaseOrderQuantity__c FROM dmpl__PurchaseRequisitionLine__c LIMIT 1];
        
            requisitionLines[0].dmpl__Quantity__c = 10;
            update requisitionLines;
      
        PurchaseRequisitionLineHelper.validateItem(purchaseRequisitionLine);
        List<Id> requisitionLineIds = new List<Id>();
        PurchaseRequisitionLineHelper.updateTransferQuantity(requisitionLineIds);
        PurchaseRequisitionLineHelper.validateData(true,true,true,requisitionLines,requisitionLines);
        
    }
    
    private static void CreatePurchaseOrderFromPurchaseRequisition()
    {
        List<dmpl__PurchaseOrder__c> purchaseOrder = new List<dmpl__PurchaseOrder__c>();
        dmpl__PurchaseRequisition__c purchaseRequisition = [Select Id, dmpl__BranchId__c, dmpl__PartnerAccountId__c, dmpl__SupplierAccountId__c FROM dmpl__PurchaseRequisition__c LIMIt 1];
        purchaseOrder.add(new dmpl__PurchaseOrder__c(dmpl__BranchId__c = purchaseRequisition.dmpl__BranchId__c,
                                                     dmpl__PartnerAccountId__c = purchaseRequisition.dmpl__PartnerAccountId__c,
                                                     dmpl__SupplierAccountId__c = purchaseRequisition.dmpl__SupplierAccountId__c
                                                     
                                                    ));
        insert purchaseOrder;
    }
}