@isTest
public class FulfillmentPickingLineHelper_Test {

    @testSetup
    public static void Setup()
    {
        System.runAs(PostInstallHelper.AssignAdministratorAllPermissions(UserInfo.getUserId())){
           
            CreateAccountGroup();
            CreateAccount();
            CreateBranch();
            CreateStorageLocation();
            CreateItems();
            CreateSKu();
            CreatePriceList();
            CreateItemLot();
            //Createstock();
            CreateResource();
            CreateContactAddress();
            CreateTaxGroup();
            CreateSaleOrder();
             test.startTest();
            CreateSaleOrderLine();
            CreateSaleInvoice();
            CreateFulfillment();
            test.stopTest();
            CreateFulfillmentOrderLine();
            CreateFulfillmentAllocationLine();
        }
    }
    
    @isTest
    private static void VerifyFulfillmentPickingLineInsert()
    {
        try{
        test.startTest();
        CreateFulfillmentPickingLine();
        TriggerHandler obj = new TriggerHandler();
        obj.setTriggerContext();
        obj.run();
        test.stopTest();
        }catch(Exception e){}
    }
    
     @isTest
    Public static void performActions()
    {
        //Try{
            Test.startTest();
            CreateFulfillmentPickingLine();
            dmpl__DocumentActionSetting__mdt metaData= [Select Id,
                                                        dmpl__FilterSourceSOQL__c,
                                                        dmpl__ChildObjectSOQLFilter__c,
                                                        dmpl__EligibilityQuantityFieldId__r.QualifiedApiName,
                                                        dmpl__ChildFieldsetName__c,
                                                        dmpl__ChildObjectId__r.QualifiedApiName,
                                                        dmpl__ChildObjectId__c
                                                        from dmpl__DocumentActionSetting__mdt Limit 1 ];
            List<dmpl__InventoryFulfillment__c> fulfillments = [SELECT Id,Name FROM dmpl__InventoryFulfillment__c];
            DocumentActionController.performAction(metaData.Id,fulfillments[0].Id);
            System.assertNotEquals(null, fulfillments);
       // } Catch(exception e){}
        Test.stopTest();
    }
    
     @isTest
    Public static void performActionForSelectedObjecNew()
    {
        Try{
            Test.startTest();
            dmpl__DocumentActionSetting__mdt metaData= [Select Id,
                                                        dmpl__FilterSourceSOQL__c,
                                                        dmpl__CustomClassName__c,
                                                        dmpl__ChildObjectSOQLFilter__c,
                                                        dmpl__EligibilityQuantityFieldId__r.QualifiedApiName,
                                                        dmpl__ChildFieldsetName__c,
                                                        dmpl__ChildObjectId__r.QualifiedApiName,
                                                        dmpl__ChildObjectId__c
                                                        from dmpl__DocumentActionSetting__mdt Limit 1 ];
            List<dmpl__InventoryFulfillment__c> fulfillments = [SELECT Id,Name FROM dmpl__InventoryFulfillment__c];
            List<SourceObjectInfo> sourceObjectInfo = new List<SourceObjectInfo>();
            sourceObjectInfo.add(new SourceObjectInfo('dmpl__InventoryFulfillment__c', fulfillments[0].Id, 0, 'Data'));
            DocumentActionController.performActionForSelectedObjects(fulfillments[0].Id,metaData.Id,sourceObjectInfo);
            System.assertNotEquals(null, fulfillments);
        } Catch(exception e){}
        Test.stopTest();
    }
    
    @isTest
    private static void VerifyFulfillmentPickingLineUpdate()
    {
        test.startTest();
        CreateFulfillmentPickingLine();
        List<dmpl__InventoryFulfillmentPickingLine__c> pickingLines = [SELECT Id,Name,dmpl__IsPickingConfirmed__c,dmpl__Quantity__c FROM dmpl__InventoryFulfillmentPickingLine__c];
        pickingLines[0].dmpl__IsPickingConfirmed__c = true;
        pickingLines[0].dmpl__Quantity__c = 2;
        update pickingLines;
        test.stopTest();
    }
    
    @isTest
    private static void VerifyFulfillmentPickingLineDelete()
    {
        try{
        test.startTest();
        CreateFulfillmentPickingLine();
        List<dmpl__InventoryFulfillmentPickingLine__c> pickingLines = [SELECT Id,Name,dmpl__IsPickingConfirmed__c,dmpl__Quantity__c FROM dmpl__InventoryFulfillmentPickingLine__c];
        delete pickingLines;
        test.stopTest();
        }catch(Exception e){}
    }
    
    @isTest
    private static void VerifyCreatePickingLineFromFulfillmentMethod()
    {
        test.startTest();
        List<dmpl__InventoryFulfillment__c> fulfillments = [SELECT Id,Name FROM dmpl__InventoryFulfillment__c];
        InventoryFulfillmentPickingLineHelper.createPickingFromFulfillment(fulfillments);
        test.stopTest();
    }
    
    @isTest
    private static void VerifyConfirmPickingLineMethod()
    {
        test.startTest();
        CreateFulfillmentPickingLine();
        List<dmpl__InventoryFulfillment__c> fulfillments = [SELECT Id,Name FROM dmpl__InventoryFulfillment__c LIMIT 1];
        InventoryFulfillmentPickingLineHelper.confirmPickingFromFulfillment(fulfillments);
        InventoryFulfillmentPickingLineHelper.cancelPickingFromFulfillment(fulfillments[0].Id);
        InventoryFulfillmentPickingLineHelper.cancelPickingFromFulfillment(fulfillments);
        test.stopTest();
    }
    
    @isTest
    private static void VerifyCreateRealtedResultPickingLineMethod()
    {
        List<dmpl__InventoryFulfillmentAllocationLine__c> allocationLine = [SELECT Id,Name FROM dmpl__InventoryFulfillmentAllocationLine__c];
        
        test.startTest();
      
        List<SourceObjectInfo> objList = new List<SourceObjectInfo>();
        SourceObjectInfo obj = new SourceObjectInfo('dmpl__SaleOrderLine__c',allocationLine[0].Id,1,null);
        objList.add(obj);
        
        List<dmpl__InventoryFulfillment__c> fulfillments = [SELECT Id,Name FROM dmpl__InventoryFulfillment__c];
        InventoryFulfillmentPickingLineHelper.createPickingFromFulfillment(objList);
        
        test.stopTest();
    }
    
    @isTest
    private static void VerifyCreateRealtedResultPickingLineMethod1()
    {        
        test.startTest();
    
        List<dmpl__InventoryFulfillment__c> fulfillments = [SELECT Id,Name FROM dmpl__InventoryFulfillment__c];
        InventoryFulfillmentPickingLineHelper.createPickingFromFulfillment(fulfillments[0].Id);
        FulfillmentHelper.pickLines(fulfillments);
        FulfillmentHelper.cancelAllocation(fulfillments[0].Id);
        test.stopTest();
    }
    
    @isTest
    private static void VerifyDocumentActionResultConfirmPickingLineMethod()
    {        
        test.startTest();
        
      CreateFulfillmentPickingLine();
        List<dmpl__InventoryFulfillmentPickingLine__c> pickingLines = [SELECT Id,Name,dmpl__IsPickingConfirmed__c,dmpl__Quantity__c FROM dmpl__InventoryFulfillmentPickingLine__c];
        List<SourceObjectInfo> objList = new List<SourceObjectInfo>();
        SourceObjectInfo obj = new SourceObjectInfo('dmpl__InventoryFulfillmentPickingLine__c',pickingLines[0].Id,1,null);
        objList.add(obj);
        
        List<dmpl__InventoryFulfillment__c> fulfillments = [SELECT Id,Name FROM dmpl__InventoryFulfillment__c];
        InventoryFulfillmentPickingLineHelper.confirmPickingFromFulfillment(objList,fulfillments[0].Id);
        InventoryFulfillmentPickingLineHelper.confirmPickingFromFulfillment(fulfillments[0].Id);
        
        test.stopTest();
    }
    
     @isTest
    private static void VerifyCancelPickingLineMethod()
    {
        test.startTest();
        CreateFulfillmentPickingLine();
        List<dmpl__InventoryFulfillmentPickingLine__c> pickingLines = [SELECT Id,Name,dmpl__IsPickingConfirmed__c,dmpl__Quantity__c FROM dmpl__InventoryFulfillmentPickingLine__c];
        List<SourceObjectInfo> objList = new List<SourceObjectInfo>();
        SourceObjectInfo obj = new SourceObjectInfo('dmpl__InventoryFulfillmentPickingLine__c',pickingLines[0].Id,1,null);
        objList.add(obj);
        
        List<dmpl__InventoryFulfillment__c> fulfillments = [SELECT Id,Name FROM dmpl__InventoryFulfillment__c];
        //InventoryFulfillmentPickingLineHelper.cancelPickingFromFulfillment(new List<dmpl__InventoryFulfillment__c>());
        //InventoryFulfillmentPickingLineHelper.cancelPickingFromFulfillment(new List<SourceObjectInfo>());
        test.stopTest();
    }
    
    @isTest
    private static void VerifyCreateSaleDeliveryFromPicklingLines()
    {
        List<dmpl__SaleOrderLine__c> saleOrderLines = [SELECT Id,Name,dmpl__ItemId__c,dmpl__UnitPrice2__c,dmpl__Discount2__c,dmpl__ContractDiscount__c,dmpl__DiscountAmount2__c,dmpl__SKUId__c,dmpl__UnitPrice__c,dmpl__TaxGroupId__c,dmpl__IsPriceBundled__c,dmpl__PackageSaleOrderLineId__c,dmpl__Discount__c,dmpl__DiscountGroupRuleId__c,dmpl__DiscountAmount__c,dmpl__SchemeDiscount__c,dmpl__SchemeDiscountAmount__c,dmpl__ContractDiscountAmount__c,dmpl__BillingType__c,dmpl__BillingFrequency__c,dmpl__ChargeType__c,dmpl__ItemLotTypeId__c FROM dmpl__SaleOrderLine__c];
        List<dmpl__InventoryFulfillmentAllocationLine__c> allocationLines = [SELECT Id,Name,dmpl__ItemLotId__c,dmpl__InventoryLedgerId__c,dmpl__StorageLocationId__c,dmpl__UnitCost__c,dmpl__ItemLotTypeId__c FROM dmpl__InventoryFulfillmentAllocationLine__c];
        test.startTest();
        CreateFulfillmentPickingLine();
        List<dmpl__InventoryFulfillmentPickingLine__c> pickingLines = [SELECT Id,Name,dmpl__IsPickingConfirmed__c,dmpl__Quantity__c FROM dmpl__InventoryFulfillmentPickingLine__c];
        List<SourceObjectInfo> objList = new List<SourceObjectInfo>();
        SourceObjectInfo obj = new SourceObjectInfo('dmpl__InventoryFulfillmentPickingLine__c',pickingLines[0].Id,1,null);
        objList.add(obj);
        
        List<dmpl__InventoryFulfillment__c> fulfillments = [SELECT Id,Name FROM dmpl__InventoryFulfillment__c];
        SaleDeliveryHelper.createSaleDeliveryFromPicking(fulfillments);
        SaleDeliveryHelper.createSaleDeliveryFromPicking(objList);
        SaleDeliveryHelper.createSaleDeliveryFromPicking(fulfillments[0].Id);
        InventoryFulfillmentPickingLineHelper.updateSaleDeliveryQuantity(DocumentHelper.extractIds(pickingLines));
        List<dmpl__DeliveryOrderLine__c> deliveryOrderLines = [SELECT Id,Name,dmpl__PickedQuantity__c,dmpl__AllocatedQuantity__c FROM dmpl__DeliveryOrderLine__c];
    SaleInvoiceHelper.createSaleInvoiceLine(deliveryOrderLines[0],saleOrderLines[0],allocationLines[0],1);
        test.stopTest();
    }
    
    @isTest
    private static void VerifyCreateSaleDeliveryFromFulfillment()
    {
        test.startTest();
        
        List<dmpl__InventoryFulfillmentAllocationLine__c> allocationLines = [SELECT Id,Name FROM dmpl__InventoryFulfillmentAllocationLine__c];
        List<SourceObjectInfo> objList = new List<SourceObjectInfo>();
        SourceObjectInfo obj = new SourceObjectInfo('dmpl__InventoryFulfillmentAllocationLine__c',allocationLines[0].Id,1,null);
        objList.add(obj);
        
        List<dmpl__InventoryFulfillment__c> fulfillments = [SELECT Id,Name FROM dmpl__InventoryFulfillment__c];
        SaleDeliveryHelper.createSaleDeliveryFromFulfillment(fulfillments);
        SaleDeliveryHelper.createSaleDeliveryFromFulfillment(objList);
        SaleDeliveryHelper.createSaleDeliveryFromFulfillment(fulfillments[0].Id);
        
        test.stopTest();
    }
    
    @isTest
    private static void VerifySaleInvoiceMethod()
    {
        test.startTest();
        
        List<dmpl__SaleOrderLine__c> saleOrderLines = [SELECT Id,Name FROM dmpl__SaleOrderLine__c];
        List<SourceObjectInfo> objList = new List<SourceObjectInfo>();
        SourceObjectInfo obj = new SourceObjectInfo('dmpl__SaleOrderLine__c',saleOrderLines[0].Id,1,null);
        objList.add(obj);
        
        SaleInvoiceHelper.createSaleInvoiceFromAllocatedLines(objList);
        test.stopTest();
    }
    
    @isTest
    private static void VerifySaleInvoiceMethod2()
    {
        test.startTest();
        List<dmpl__SaleOrderLine__c> saleOrderLines = [SELECT Id,Name FROM dmpl__SaleOrderLine__c];
        List<dmpl__SaleInvoice__c> invoices = [SELECT Id,Name FROM dmpl__SaleInvoice__c];
        List<SourceObjectInfo> objList = new List<SourceObjectInfo>();
        SourceObjectInfo obj = new SourceObjectInfo('dmpl__SaleOrderLine__c',saleOrderLines[0].Id,1,null);
        objList.add(obj);
        
        SaleInvoiceHelper.createSaleInvoiceFromSaleOrder(objList);
        SaleInvoiceHelper.createSaleInvoiceFromSaleOrder(objList,invoices[0].Id);
        test.stopTest();
    }
    
    @isTest
    private static void VerifyFulfillmentMethod()
    {
        try{
        test.startTest();
        List<dmpl__SaleOrderLine__c> saleOrderLines = [SELECT Id,Name,dmpl__SaleOrderId__c FROM dmpl__SaleOrderLine__c];
        List<dmpl__SaleOrder__c> saleOrders = [SELECT Id,Name FROM dmpl__SaleOrder__c];
        List<SourceObjectInfo> objList = new List<SourceObjectInfo>();
        SourceObjectInfo obj = new SourceObjectInfo('dmpl__SaleOrderLine__c',saleOrderLines[0].Id,1,null);
        objList.add(obj);
        FulfillmentHelper.createFulfillmentFromSaleOrderAndAllocate(saleOrders);
        FulfillmentHelper.createFulfillmentFromSaleOrderAndAllocate(objList);
        FulfillmentHelper.createFulfillmentFromSaleOrderAndAllocate(saleOrderLines[0].dmpl__SaleOrderId__c);
        test.stopTest();
        }catch(exception e){}
    }
    
    @isTest
    private static void VerifyCreatePurchaseOrder()
    {
        test.startTest();
        
        List<dmpl__InventoryFulfillment__c> fulfillments = [SELECT Id,Name FROM dmpl__InventoryFulfillment__c];
        List<dmpl__InventoryFulfillmentOrderLine__c> orderLines = [SELECT Id,Name FROM dmpl__InventoryFulfillmentOrderLine__c];
        List<SourceObjectInfo> objList = new List<SourceObjectInfo>();
        SourceObjectInfo obj = new SourceObjectInfo('dmpl__InventoryFulfillmentOrderLine__c',orderLines[0].Id,1,null);
        objList.add(obj);
        
        PurchaseOrderHelper.createPurchaseOrderFromFulfillment(DocumentHelper.extractIds(fulfillments));
        PurchaseOrderHelper.createPurchaseOrderFromFulfillment(fulfillments[0].Id);
        PurchaseOrderHelper.createPurchaseOrderFromFulfillment(objList);
        
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
       /* List<Account> account = new List<Account>();
        dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c LIMIT 1];
        account.add(new Account(Name = 'Test - Account', 
                                dmpl__LastName__c = 'Fulfillment',
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
        insert account; */
        
        Account partneraccount = new Account(Name = 'Partner-Test-Account',
                                             dmpl__LastName__c = 'Fulfillment',
                                             dmpl__IsPartnerAccount__c = True, 
                                             dmpl__IsActive__c = true);
        insert partneraccount;
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__LastName__c = 'Fulfillment',
                                              dmpl__IsCustomerAccount__c = True,
                                              dmpl__IsActive__c = true);
        insert customerAccount;
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
    
    /*private static void CreateItemGroup()
    {
        List<dmpl__ItemGroup__c> itemGroup = new List<dmpl__ItemGroup__c> ();
        itemGroup.Add(new dmpl__ItemGroup__c(Name = 'Item Group Test',
                                             dmpl__ItemGroupType__c = 'Tax'));
        insert itemGroup;
    }*/
    
    private static void CreateItems()
    {
        List<dmpl__Item__c> item = new List<dmpl__Item__c>();
        //dmpl__ItemGroup__c itemGroup = [Select Id,Name From dmpl__ItemGroup__c LIMIT 1];
        item.Add(new dmpl__Item__c(Name = 'Test-Item',
                                   dmpl__ItemCode__c = 'DMPL',
                                   dmpl__ItemType__c = 'Service Contract',
                                   dmpl__ItemSubType__c = '',
                                   dmpl__Description__c = '',
                                   dmpl__ItemFamily__c = 'Sample',
                                   dmpl__ItemSegment__c = 'Sample',
                                   dmpl__Make__c = 'Sample',
                                   dmpl__Model__c = 'Sample',
                                   dmpl__TrackInventory__c = True,
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
                                   dmpl__IsPackage__c=true,
                                   dmpl__QuantityUnitOfMeasure__c='Box',
                                   dmpl__InventoryValuationMethod__c='FIFO'  
                                  // dmpl__TaxItemGroupId__c=itemGroup.Id
                                  ));
        insert item;
        
       /* List<dmpl__Item__c> item1 = new List<dmpl__Item__c>();
        item1.Add(new dmpl__Item__c(Name = 'Oil',
                                    dmpl__ItemCode__c = 'DMPLNEW',
                                    dmpl__ItemType__c = 'Part',
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
                                    dmpl__GTIN__c = 'BR1233',
                                    dmpl__RFID__c = 'O1234fgdh',
                                    dmpl__IsPackage__c=true,
                                    dmpl__QuantityUnitOfMeasure__c='Box',
                                    dmpl__InventoryValuationMethod__c='FIFO'
                                    //dmpl__TaxItemGroupId__c=itemGroup.Id
                                   ));
        insert item1; */
    }
    
    private static void CreateSKu()
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
    
    private static void CreatePriceList()
    {
        List<dmpl__PriceList__c> priceList =new List<dmpl__PriceList__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Limit 1];
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account'];
        
        priceList.Add(new dmpl__PriceList__c(Name='Test-Price - List',
                                             dmpl__BranchId__c = branch.Id,
                                             dmpl__PriceListType__c = 'Sale Price',
                                             dmpl__PartnerAccountId__c= account.Id,
                                             dmpl__IsActive__c = true));
        insert priceList;
    
        List<dmpl__PriceListRules__c> priceListRules =new List<dmpl__PriceListRules__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        priceListRules.Add(new dmpl__PriceListRules__c(dmpl__ItemId__c = item.Id,
                                                       dmpl__PriceListId__c=priceList[0].Id,
                                                       dmpl__Price__c=500,
                                                       dmpl__DateEffectiveFrom__c = date.today()
                                                      ));
        insert priceListRules;
        
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
                                       //  dmpl__QuantityExpired__c = 1,
                                         //dmpl__QuantityOnHold__c = 1,
                                         dmpl__ItemLotTypeId__c = null
                                        // dmpl__QuantityOnLoan__c = 1
                                        ));
        insert itemLot;
        
        List<dmpl__ItemLot__c> relatedItemLot = new List<dmpl__ItemLot__c>();
        relatedItemLot.Add(new dmpl__ItemLot__c(
            dmpl__LandedCost__c = 1000,
                                                dmpl__BranchId__c = branch.Id,
            dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c));
        insert relatedItemLot;
    }
    
    private static void CreateResource()
    {
       /* List<dmpl__Resource__c> resource = new List<dmpl__Resource__c>();
        Account partnerAccount = [Select Id,Name From Account LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        resource.add(new dmpl__Resource__c(Name = 'Test - Resource',
                                           dmpl__ResourceType__c = 'Sample',
                                           dmpl__IsActive__c = true,
                                           dmpl__Phone__c = '9999999999',
                                           dmpl__DefaultPartnerAccountId__c = partnerAccount.Id,
                                           dmpl__DefaultBranchId__c = branch.Id
                                          ));
        insert resource; */
        
      /*  List<dmpl__Resource__c> resource1 = new List<dmpl__Resource__c>();
        Account partnerAccount1 = [Select Id,Name From Account LIMIT 1];
        dmpl__Branch__c branch1 = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        resource1.add(new dmpl__Resource__c(Name = 'Test - Resource',
                                            dmpl__ResourceType__c = 'Service Advisor',
                                            dmpl__IsActive__c = true,
                                            dmpl__Phone__c = '9999999999',
                                            dmpl__DefaultPartnerAccountId__c = partnerAccount1.Id,
                                            dmpl__DefaultBranchId__c = branch1.Id
                                           ));
        insert resource1; */
        List<dmpl__Resource__c> resource2 = new List<dmpl__Resource__c>();
        Account partnerAccount2 = [Select Id,Name From Account LIMIT 1];
        dmpl__Branch__c branch2 = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        resource2.add(new dmpl__Resource__c(Name = 'Test - Resource',
                                            dmpl__ResourceType__c = 'Technician',
                                            dmpl__IsActive__c = true,
                                            dmpl__Phone__c = '9999999999',
                                            dmpl__DefaultPartnerAccountId__c = partnerAccount2.Id,
                                            dmpl__DefaultBranchId__c = branch2.Id
                                           ));
        insert resource2;
    }
    
    
    private static void CreateContactAddress()
    {
        List<dmpl__ContactAddress__c> contactAddress = new List<dmpl__ContactAddress__c>();
        Account account = [Select Id,Name From Account where Name = 'Customer-Test-Account' LIMIT 1];
        contactAddress.add(new dmpl__ContactAddress__c(dmpl__AccountId__c = account.Id,
                                                       Name = 'Test - Contact - Address',
                                                       dmpl__Street__c = 'Street',
                                                       dmpl__City__c = 'None',
                                                       dmpl__PostalCode__c = '12345',
                                                       dmpl__Country__c = 'None' ,
                                                       dmpl__AddressType__c = 'Both'                                                     
                                                      ));
        insert contactAddress;
    }
    
    private static void CreateTaxGroup()
    {
        List<dmpl__TaxGroup__c> taxGroup = new List<dmpl__TaxGroup__c>();
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account'];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c]; 
        dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c ];
        taxGroup.Add(new dmpl__TaxGroup__c(Name = 'Test - Tax Group',
                                           dmpl__PartnerAccountId__c = account.Id,
                                           dmpl__BranchId__c = branch.Id,
                                           dmpl__PartnerAccountGroupId__c = accountGroup.Id,
                                           dmpl__Description__c = 'Description',
                                           dmpl__IsActive__c = false
                                          ));
        insert taxGroup;
    }
    
    private static void CreateSaleOrder()
    {
        List<dmpl__SaleOrder__c> saleOrder = new List<dmpl__SaleOrder__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
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
                                             dmpl__PerformReleaseDelivery__c = false
                                            ));
        insert saleOrder;
    }
    
    private static void CreateSaleOrderLine()
    {
        List<dmpl__SaleOrderLine__c> saleOrderLine = new List<dmpl__SaleOrderLine__c>();
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        saleOrderLine.Add(new dmpl__SaleOrderLine__c(dmpl__SaleOrderId__c = saleOrder.Id,
                                                     dmpl__ItemId__c = item.Id,
                                                     dmpl__SKUId__c = sku.Id,
                                                     dmpl__Quantity__c = 15,
                                                     dmpl__TaxGroupId__c = taxGroup.Id,
                                                     dmpl__UnitPrice__c = 100,
                                                     dmpl__Discount__c = 5
                                                     //dmpl__DeliveryQuantity__c = 5
                                                    ));
        insert saleOrderLine;
    }
    
    private static void CreateStorageLocation() 
    {
        List<dmpl__StorageLocation__c> StorageLocation = new List<dmpl__StorageLocation__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__ParentLocationId__c From dmpl__Branch__c];
        storageLocation.Add(new dmpl__StorageLocation__c(dmpl__BranchId__c = branch.Id,
                                                         dmpl__ParentLocationId__c = branch.dmpl__ParentLocationId__c,
                                                         dmpl__AllowInventory__c=true,
                                                         dmpl__IsMobile__c=true,
                                                         dmpl__IsActive__c=true,
                                                         dmpl__LocationType__c='Washing Bay'
                                                         
                                                        ));
        insert storageLocation;
    }
    
    private static void CreateFulfillment()
    {
        List<dmpl__InventoryFulfillment__c> fulfillment = new List<dmpl__InventoryFulfillment__c>();
        //Account account = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True  LIMIT 1];
        //Account partnerAccount = [Select Id,Name From Account where Name = 'Partner-Test-Account' LIMIT 1];
        //dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__SaleOrder__c saleOrder = [Select Id,Name,dmpl__PartnerAccountId__c,dmpl__BranchId__c,dmpl__AccountId__c From dmpl__SaleOrder__c LIMIT 1];
        fulfillment.Add(new dmpl__InventoryFulfillment__c(dmpl__PartnerAccountId__c = saleOrder.dmpl__PartnerAccountId__c,
                                                          dmpl__BranchId__c = saleOrder.dmpl__BranchId__c,
                                                          dmpl__AccountId__c = saleOrder.dmpl__AccountId__c,
                                                          dmpl__PerformAllocation__c = false,
                                                          dmpl__SaleOrderId__c = saleOrder.Id
                                                         ));
        insert fulfillment;
    }
    
    private static void CreateFulfillmentOrderLine()
    {
        List<dmpl__InventoryFulfillmentOrderLine__c> OrderLine = new List<dmpl__InventoryFulfillmentOrderLine__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__InventoryFulfillment__c fulfillment = [Select Id,Name From dmpl__InventoryFulfillment__c LIMIT 1];
        dmpl__SaleOrderLine__c saleOrderLine = [Select Id,Name From dmpl__SaleOrderLine__c LIMIT 1];
        OrderLine.Add(new dmpl__InventoryFulfillmentOrderLine__c(dmpl__FulfillmentId__c = fulfillment.Id,
                                                                 dmpl__ItemId__c = item.id,
                                                                 dmpl__SKUId__c = sku.Id,
                                                                 dmpl__SaleOrderLineId__c = saleOrderLine.Id
                                                                ));
        insert OrderLine;
    }
    
    
    private static void CreateFulfillmentAllocationLine()
    {
        List<dmpl__InventoryFulfillmentAllocationLine__c> allocationLine = new List<dmpl__InventoryFulfillmentAllocationLine__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__ItemLot__c itemLot = [SELECT Id, Name FROM dmpl__ItemLot__c LIMIT 1];
        dmpl__SKU__c itemSKU = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentorderline = [Select Id,Name From dmpl__InventoryFulfillmentOrderLine__c LIMIT 1];
        dmpl__InventoryFulfillment__c fulfillment = [Select Id,Name From dmpl__InventoryFulfillment__c LIMIT 1];
        allocationLine.Add(new dmpl__InventoryFulfillmentAllocationLine__c (
            dmpl__ItemId__c = item.Id,
            dmpl__SKUId__c = itemSKU.Id,
            dmpl__Quantity__c = 3, 
            dmpl__FulfillmentOrderLineId__c=fulfillmentorderline.Id,
            dmpl__ItemLotId__c = itemLot.Id,
            dmpl__UnitCost__c = 10,
            dmpl__AllocatedById__c = resource.Id,
            dmpl__FulfillmentOrderId__c = fulfillment.Id,
            dmpl__DocumentDate__c = Date.today()));
        insert allocationLine;
    }
    
    private static void CreateFulfillmentPickingLine()
    {
        List<dmpl__InventoryFulfillmentPickingLine__c> pickingLines = new List<dmpl__InventoryFulfillmentPickingLine__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__ItemLot__c itemLot = [SELECT Id, Name FROM dmpl__ItemLot__c LIMIT 1];
        dmpl__SKU__c itemSKU = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__InventoryFulfillment__c fulfillment = [Select Id,Name From dmpl__InventoryFulfillment__c LIMIT 1];
        dmpl__InventoryFulfillmentAllocationLine__c allocationLine = [SELECT Id,Name FROM dmpl__InventoryFulfillmentAllocationLine__c LIMIT 1];
        
        pickingLines.Add(new dmpl__InventoryFulfillmentPickingLine__c (
            dmpl__ItemId__c = item.Id,
            dmpl__SKUId__c = itemSKU.Id,
            dmpl__Quantity__c = 1,
            dmpl__RequestedQuantity__c = 1,
            dmpl__FulfillmentAllocationLineId__c = allocationLine.Id,
            dmpl__ItemLotId__c = itemLot.Id,
            dmpl__UnitCost__c = 10,
            dmpl__FulfillmentOrderId__c = fulfillment.Id,
            dmpl__DocumentDate__c = Date.today()));
        
        insert pickingLines;
    }
    
   /* private static void Createstock()
    {
        List<dmpl__InventoryStock__c> stock = new List<dmpl__InventoryStock__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        stock.Add(new dmpl__InventoryStock__c(
            dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
            dmpl__BranchId__c = branch.Id,
            dmpl__ItemId__c = item.Id
            
        ));
        insert stock; 
    }*/
    
    private static void CreateSaleInvoice()
    {
        List<dmpl__SaleInvoice__c> saleInvoice = new List<dmpl__SaleInvoice__c>();
        Account account = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        dmpl__PriceList__c priceList=[select Id, Name from dmpl__PriceList__c WHERE dmpl__PriceListType__c = 'Sale Price' LIMIT 1];
        //dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        saleInvoice.Add(new dmpl__SaleInvoice__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                 dmpl__BranchId__c = Branch.Id,
                                                 dmpl__PriceListId__c=priceList.Id,
                                                 dmpl__DocumentDate__c = date.today(),
                                                 dmpl__AccountId__c = account.Id,
                                                 //dmpl__SalesExecutiveId__c = resource.Id,
                                                 dmpl__SaleOrderId__c = saleOrder.Id,
                                                 dmpl__FinanceAmount__c=100,
                                                 dmpl__AmountPaid__c =1 ,
                                                 dmpl__Status__c='Draft'
                                                ));
        insert saleInvoice;
        
        List<dmpl__SaleInvoiceLine__c> saleInvoiceLine = new List<dmpl__SaleInvoiceLine__c>();
        dmpl__SKU__c sku = [Select Id ,Name, dmpl__ItemId__c From dmpl__SKU__c LIMIT 1 ];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1]; 
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c];
        dmpl__PriceListRules__c priceRule =[select Id, Name from dmpl__PriceListRules__c Limit 1];
        dmpl__ItemLot__c itemLot = [Select Id, Name From dmpl__ItemLot__c LIMIT 1];
        saleInvoiceLine.Add(new dmpl__SaleInvoiceLine__c(dmpl__SaleInvoiceId__c = SaleInvoice[0].id,
                                                         dmpl__ItemId__c = sku.dmpl__ItemId__c,
                                                         dmpl__PriceListRuleId__c=priceRule.Id,
                                                         dmpl__SKUId__c =sku.Id ,
                                                         dmpl__IsILPostingApproved__c=false,
                                                         dmpl__IsGLPostingApproved__c=false,
                                                         dmpl__ItemLotId__c = itemLot.Id,
                                                         dmpl__Quantity__c = 100,
                                                         dmpl__UnitPrice__c = 10,
                                                         dmpl__IsClaimed__c = false,
                                                         dmpl__SchemeDiscountAmount__c = 100,
                                                         dmpl__TaxGroupId__c = taxGroup.Id
                                                        ));  
     
        insert saleInvoiceLine;
    }
}