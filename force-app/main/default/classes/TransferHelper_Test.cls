@isTest
public with sharing class TransferHelper_Test {
    @testSetup
    public static void Setup()
    {
        Test.startTest();
        CreateAccountGroup();
        CreateAccount();
        CreateBranch();
        CreateResource();
        CreateContactAddress();
        CreateItems();
        CreateSKu();
        CreatePriceList();
        CreatePriceListRules();
        CreateTaxGroup(); 
        CreateSaleOrderLine();
        // createSourceObjectInfo();
        CreatePurchaseRequisition();
        CreateStorageLocation();    
        CreateFieldSales();
        CreateTransfer();

        Test.stopTest();
    }

    @isTest
    public static void releaseOutwardDocumentTest(){
        List<dmpl__Transfer__c> transfers=[select Id,dmpl__Type__c,dmpl__ReceivedById__c,dmpl__PartnerAccountId__c,dmpl__BranchId__c,dmpl__ToBranchId__c,dmpl__TransferTime__c,dmpl__PerformInwardReceive__c,dmpl__PerformInwardPosting__c from dmpl__Transfer__c ];
        List<SourceObjectInfo>  sourceObjectInfoList= createSourceObjectInfo();
        Test.startTest();
        TransferHelper.releaseOutwardDocument(transfers);
        TransferHelper.releaseOutwardDocument(transfers[0].id);
        TransferHelper.releaseOutwardDocument(sourceObjectInfoList,transfers[0].id);
        TransferHelper.releaseOutwardDocumentInternal(transfers);
        TransferHelper.postInwardDocument(transfers);
        TransferHelper.postInwardDocument(transfers[0].id);
        TransferHelper.postInwardDocument(sourceObjectInfoList,transfers[0].Id);  
        Test.stopTest();
    }

    @isTest
    public static void receiveInwardDocumentTest(){
        List<dmpl__Transfer__c> transfers=[select Id,dmpl__Type__c,dmpl__PartnerAccountId__c,dmpl__BranchId__c,dmpl__ToBranchId__c,dmpl__TransferTime__c,dmpl__PerformInwardReceive__c,dmpl__PerformInwardPosting__c from dmpl__Transfer__c ];
        List<SourceObjectInfo>  sourceObjectInfoList= createSourceObjectInfo();
        Test.startTest();
        TransferHelper.receiveInwardDocument(transfers);
        TransferHelper.receiveInwardDocument(transfers[0].id);
        TransferHelper.receiveInwardDocument(sourceObjectInfoList,transfers[0].id);

        Test.stopTest();
    }

    @isTest
    public static void receiveInwardDocumentInternalTest(){
        List<dmpl__Transfer__c> transfers=[select Id,dmpl__Type__c,dmpl__PartnerAccountId__c,dmpl__BranchId__c,dmpl__ToBranchId__c,dmpl__TransferTime__c,dmpl__PerformInwardReceive__c,dmpl__PerformInwardPosting__c from dmpl__Transfer__c ];
        Test.startTest();
        TransferHelper.receiveInwardDocumentInternal(transfers);
        TransferHelper.postInwardDocumentInternal(transfers);  
        Test.stopTest();
    }

    @isTest
    public static void PostILTest(){
        List<dmpl__Transfer__c> transfers=[select Id,dmpl__Type__c,dmpl__PartnerAccountId__c,dmpl__BranchId__c,dmpl__ToBranchId__c,dmpl__TransferTime__c,dmpl__PerformInwardReceive__c,dmpl__PerformInwardPosting__c from dmpl__Transfer__c ];
        Test.startTest();
        TransferHelper.PostIL(transfers); 
        Test.stopTest();
    }

    @isTest
    public static void createTransferFromRequisitionInternalTest(){
        List<dmpl__PurchaseRequisitionLine__c>  requeisitionLine = [Select Id,dmpl__SKUId__c,dmpl__Quantity__c,dmpl__ItemId__c,dmpl__PurchaseRequisitionId__c,dmpl__PendingQuantity__c,dmpl__PurchaseRequisitionId__r.dmpl__PartnerAccountId__c,
                dmpl__PurchaseRequisitionId__r.dmpl__BranchId__c,
                dmpl__PurchaseRequisitionId__r.dmpl__FromBranchId__c,
                dmpl__PurchaseRequisitionId__r.dmpl__SupplierAccountId__c,
                dmpl__PurchaseRequisitionId__r.dmpl__DocumentDate__c,
                dmpl__PurchaseRequisitionId__r.dmpl__Remarks__c,dmpl__UnitCost__c
                from dmpl__PurchaseRequisitionLine__c];
        List<SourceObjectInfo>  sourceObjectInfoList= createSourceObjectInfo();
        Test.startTest();
        TransferHelper.queryRequisitionLines(null,DocumentHelper.extractIds(requeisitionLine)); 
        Test.stopTest();
    }

    @isTest
    public static void createTransferForLoadFromFieldSalesTest(){
        List<dmpl__FieldSales__c> fieldSales =   [Select Id,dmpl__DocumentDate__c,dmpl__IsLoadReleased__c,dmpl__PerformReleaseVisitPlan__c,dmpl__PerformReleaseLoad__c,dmpl__PerformReleaseUnload__c,dmpl__ResourceId__c,dmpl__PartnerAccountId__c,dmpl__BranchId__c from dmpl__FieldSales__c];
        Test.startTest();
        TransferHelper.createTransferForLoadFromFieldSales(fieldSales); 
        TransferHelper.createTransferForLoadFromFieldSales(fieldSales[0].Id); 
        Test.stopTest();
    }
    // @isTest
    // public static void createStockTransferFromRequisitionTest(){
    //     List<SourceObjectInfo>  sourceObjectInfoList= createSourceObjectInfo();
    //     dmpl__PurchaseRequisition__c requisition= [Select Id from dmpl__PurchaseRequisition__c];
    //     Test.startTest();
    //     TransferHelper.createStockTransferFromRequisition(requisition.Id);
    //     // TransferHelper.createStockTransferFromRequisition(sourceObjectInfoList);
    //     Test.stopTest();
    // }

    public static List<SourceObjectInfo> createSourceObjectInfo(){
        // dmpl__SaleOrderLine__c saleOrderLineRecord = [SELECT Id FROM dmpl__SaleOrderLine__c LIMIT 1];
        dmpl__PurchaseRequisitionLine__c purchaseRequisitionLine = [Select Id from dmpl__PurchaseRequisitionLine__c];
        List<SourceObjectInfo> sourceObjectInfoList = new List<SourceObjectInfo>();
        sourceObjectInfoList.add(new SourceObjectInfo(
                'dmpl__PurchaseRequisitionLine__c',
                purchaseRequisitionLine.Id,
                2,
                'Test data'
        ));
        return sourceObjectInfoList;
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

    private static void CreatePurchaseRequisition()
    {
        List<dmpl__PurchaseRequisition__c> purchaseRequisition = new List<dmpl__PurchaseRequisition__c>();
        Account supplierAccount = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        purchaseRequisition.add(new dmpl__PurchaseRequisition__c(dmpl__BranchId__c = branch.Id,
                                                                 dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                                 dmpl__SupplierAccountId__c = supplierAccount.Id,
                                                                 dmpl__PerformReleaseOrder__c = false,
                                                                 dmpl__IsOrderReleased__c = true,
                                                                 dmpl__DocumentDate__c=Date.today(),
                                                                 dmpl__Remarks__c='sample'
                                                                ));
        insert purchaseRequisition;
        
        List<dmpl__PurchaseRequisitionLine__c> purchaseRequisitionLine = new List<dmpl__PurchaseRequisitionLine__c>();
        dmpl__Item__c item = [Select Id, Name from dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c LIMIT 1];
        purchaseRequisitionLine.add(new dmpl__PurchaseRequisitionLine__c(dmpl__PurchaseRequisitionId__c = purchaseRequisition[0].Id,
                                                                         dmpl__ItemId__c = item.Id,
                                                                         dmpl__Quantity__c = 1,
                                                                         dmpl__SKUId__c = sku.Id
                                                                        ));
        insert purchaseRequisitionLine;
        
    }  

    private static void CreateContactAddress()
    {
        List<dmpl__ContactAddress__c> contactAddress = new List<dmpl__ContactAddress__c>();
        Account account = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        contactAddress.add(new dmpl__ContactAddress__c(dmpl__AccountId__c = account.Id,
                                                       Name = 'Test - Contact - Address',
                                                       dmpl__AddressType__c = 'Both'
                                                      ));
        insert contactAddress;
        
    }
    private static void CreateItems(){
        List<dmpl__Item__c> productItem = new List<dmpl__Item__c>();
        productItem.Add(new dmpl__Item__c(Name = 'Test-Item',
                                          dmpl__ItemCode__c = 'DMPL',
                                          dmpl__ItemType__c = 'Product',
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
                                          dmpl__GTIN__c = 'BR123',
                                          dmpl__RFID__c = 'O1234fgh',
                                          dmpl__IsPackage__c = true
                                         ));
        insert productItem;
    }
    private static void CreateSKu()
    {
        List<dmpl__SKU__c> sku = new List<dmpl__SKU__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch' LIMIT 1];
        sku.add(new dmpl__SKU__c(Name = 'Test - SKU',
                                 dmpl__SKUCode__c = 'Test - SKU - Code',
                                 dmpl__UnitOfMeasureOfConversion__c = 10,
                                 dmpl__ProductColor__c = 'Sample',
                                 dmpl__IsDefault__c = false,
                                 dmpl__QuantityUnitOfMeasure__c ='Sample',
                                 dmpl__ItemId__c = item.Id));
        insert sku;
        
        List<dmpl__ItemLot__c> itemLot = new List<dmpl__ItemLot__c>();
        itemLot.Add(new dmpl__ItemLot__c(dmpl__BranchId__c = branch.Id,
                                         dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                         dmpl__ItemId__c = item.Id,
                                         dmpl__SKUId__c = sku[0].Id,
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
        
    }
    private static void CreatePriceList()
    {
        List<dmpl__PriceList__c> priceList =new List<dmpl__PriceList__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Limit 1];
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
        
        insert priceList;
        
    }
    
    private static void CreatePriceListRules()
    {
        List<dmpl__PriceListRules__c> priceListRules =new List<dmpl__PriceListRules__c>();
        dmpl__PriceList__c priceList = [Select Id,Name From dmpl__PriceList__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        priceListRules.Add(new dmpl__PriceListRules__c(dmpl__ItemId__c = item.Id,
                                                       dmpl__PriceListId__c=priceList.Id,
                                                       dmpl__Price__c=500,
                                                       dmpl__DateEffectiveFrom__c = date.today()
                                                      ));
        insert priceListRules;
        
    }  

    private static void CreateTaxGroup()
    {
        List<dmpl__TaxGroup__c> taxGroup = new List<dmpl__TaxGroup__c>();
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account'];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch']; 
        dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c ];
        taxGroup.Add(new dmpl__TaxGroup__c(Name = 'Test - Tax Group',
                                           dmpl__PartnerAccountId__c = account.Id,
                                           dmpl__BranchId__c = branch.Id,
                                           dmpl__PartnerAccountGroupId__c = accountGroup.Id,
                                           dmpl__Description__c = 'Description',
                                           dmpl__IsActive__c = true,
                                           dmpl__TaxGroupType__c = 'Line Level'
                                          ));
        insert taxGroup;
        
        List<dmpl__Tax__c> tax = new List<dmpl__Tax__c>();
        //dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c];
        tax.Add(new dmpl__Tax__c(Name = 'Test - Tax',
                                 dmpl__TaxGroupId__c = taxGroup[0].Id,
                                 dmpl__Type__c = 'Cess',
                                 dmpl__Rate__c = 10,
                                 dmpl__PostingFieldName__c = 'Tax1'
                                ));        
        insert tax;
        
    }

    private static void CreateSaleOrderLine()
    {
        List<dmpl__SaleOrder__c> saleOrder = new List<dmpl__SaleOrder__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch' LIMIT 1];
        dmpl__ContactAddress__c contactAddress = [Select Id,Name,dmpl__AccountId__c From dmpl__ContactAddress__c LIMIT 1];
        //dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        saleOrder.Add(new dmpl__SaleOrder__c(dmpl__AccountId__c = contactAddress.dmpl__AccountId__c,
                                             dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                             dmpl__BranchId__c = branch.Id,
                                             dmpl__DocumentDate__c = Date.today(),
                                             dmpl__Status__c = 'Draft',
                                             dmpl__BillingAddressId__c = contactAddress.Id,
                                             dmpl__ShippingAddressId__c = contactAddress.Id,
                                             dmpl__RequiredDate__c = Date.today(),
                                             //dmpl__SalesExecutiveId__c = resource.Id,
                                             dmpl__BookingAmount__c = 100,
                                             dmpl__PromisedDate__c = Date.today(),
                                             dmpl__PerformReleaseFulfilment__c = false,
                                             dmpl__PerformReleaseInvoice__c = false,
                                             dmpl__PerformReleaseDelivery__c = false,
                                             dmpl__AmountPaid__c = 100
                                            ));
        insert saleOrder;
        
        List<dmpl__SaleOrderLine__c> saleOrderLine = new List<dmpl__SaleOrderLine__c>();
        //dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__PriceListRules__c rules =[select Id, Name from dmpl__PriceListRules__c Limit 1];
        // dmpl__ItemComponent__c itemcomp=[Select Id, Name from dmpl__ItemComponent__c ];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        saleOrderLine.Add(new dmpl__SaleOrderLine__c(dmpl__SaleOrderId__c = saleOrder[0].Id,
                                                     dmpl__ItemId__c = item.Id,
                                                     dmpl__SKUId__c = sku.Id,
                                                     dmpl__PriceListRuleId__c=rules.Id,
                                                     dmpl__Quantity__c = 4,
                                                     dmpl__UnitPrice__c = 100,
                                                     dmpl__Discount__c = 5
                                                    ));
        insert saleOrderLine;
    }


    

    private static void CreateAccountGroup()
    {
    	dmpl__AccountGroup__c accountGroup= new dmpl__AccountGroup__c (Name= 'Test-AccountGroup', 
                                                                       dmpl__AccountGroupType__c='Price');
        insert accountGroup;
    }
    
    private static void CreateAccount()
    {
        List<Account> account = new List<Account>();
        dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c LIMIT 1];
        account.add(new Account(Name = 'Test - Account', 
            					Fax = '09876',
                               Phone = '1234567891',
                               dmpl__LastName__c = 'Account',
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
        
        account.add(new Account(Name = 'Partner-Test-Account',
                                             dmpl__IsPartnerAccount__c = True,
                                             dmpl__LastName__c = 'Account',
                                             dmpl__IsActive__c = true));
        
        account.add(new Account(Name = 'Customer-Test-Account',
                                              dmpl__IsCustomerAccount__c = True,
                                              dmpl__LastName__c = 'Account',
                                              dmpl__IsActive__c = true));
        account.add(new Account(Name = 'Supplier-Test-Account',
                                              dmpl__IsSupplierAccount__c = True,
                                              dmpl__LastName__c = 'Account',
                                              dmpl__IsActive__c = true));
        
        insert account;
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

    private static void CreateTransfer()
    {
        List<dmpl__Transfer__c> transfer = new List<dmpl__Transfer__c>();
        dmpl__Branch__c branch1 = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c limit 1];
        dmpl__Resource__c Resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        dmpl__PurchaseRequisition__c requestion = [Select Id from dmpl__PurchaseRequisition__c limit 1];
        transfer.Add(new dmpl__Transfer__c(dmpl__PartnerAccountId__c = branch1.dmpl__PartnerAccountId__c,
                                          dmpl__BranchId__c = branch1.Id,
                                          dmpl__ToBranchId__c = branch1.id,
                                          dmpl__PerformInwardPosting__c = false,
                                          dmpl__PerformInwardReceive__c = false,
                                           dmpl__TransferTime__c = Date.today(),
                                           dmpl__ReceivedById__c = Resource.Id,
                                           dmpl__Type__c = 'Inward',
                                           dmpl__PurchaseRequisitionId__c = requestion.Id
                                          ));
        insert transfer;
        update transfer;

    }
}