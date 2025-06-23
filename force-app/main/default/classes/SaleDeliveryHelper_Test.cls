/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-30-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class SaleDeliveryHelper_Test {
    
    @testSetup
    public static void Setup()    
    {
        //System.runAs(PostInstallHelper.AssignAdministratorAllPermissions(UserInfo.getUserId())){
            CreateAccountGroup();      
            CreateBranch();
            CreateItems();
            //CreateResource();
            //CreateAsset();
            CreateTaxGroup();
        CreateTax();
        CreateTaxGroupRule();
            CreateSaleOrder();
            test.startTest();
            //CreateSaleInvoice();
            CreateDeliveryOrder();
            test.stopTest();
            
        //}
    }
    
    @isTest
    public static void VerifyShipment()
    {
        try{
            test.startTest();
            
            List<dmpl__DeliveryOrder__c> shipment = [SELECT Id,  Name,
                                                     dmpl__AccountId__c,
                                                     dmpl__DocumentDate__c,
                                                     dmpl__BranchId__c,
                                                     dmpl__PartnerAccountId__c
                                                     FROM dmpl__DeliveryOrder__c];       
            ShipmentHelper.createShipmentFromDelivery(shipment); 
            ChecklistLineHelper.createChecklistLines(shipment);
            PriceListHelper.setDefaultPriceListIds(shipment);
            System.assert(shipment != null, 'delivery order data');
            test.stopTest();}
        catch(Exception e){}
    }
    @isTest
    public static void VerifyChecklistLines()
    {
        test.startTest();
        CreateDiscountGroup();
        List<dmpl__DeliveryOrder__c> shipment = [SELECT Id,  Name,
                                                 dmpl__AccountId__c,
                                                 dmpl__DocumentDate__c,
                                                 dmpl__DiscountGroupId__c,
                                                 dmpl__BranchId__c,
                                                 dmpl__PartnerAccountId__c
                                                 FROM dmpl__DeliveryOrder__c];       
        
        DiscountGroupHelper.setDefaultDiscountGroupIds(shipment);
        System.assert(shipment != null, 'delivery order data');
        test.stopTest();
    }
    
    @isTest
    public static void UpdateDeliveryOrder()
    {
        Test.Starttest();
        dmpl__DeliveryOrder__c deliveryOrder = [Select Id,Name,dmpl__Remarks__c From dmpl__DeliveryOrder__c LIMIT 1];
        deliveryOrder.dmpl__Remarks__c = 'Successful';
        deliveryOrder.dmpl__Discount__c =298;
        
        update deliveryOrder;
        Test.Stoptest();
        System.assertEquals('Successful', deliveryOrder.dmpl__Remarks__c, 'Test delivery Order have 1 updated record');
    }
    
    @isTest
    public static void DeleteDeliveryOrder()
    {
        Test.Starttest();
        dmpl__DeliveryOrder__c deliveryOrder = [Select Id,Name,dmpl__Remarks__c From dmpl__DeliveryOrder__c LIMIT 1];
        delete deliveryOrder;
        Test.Stoptest();
        System.assertEquals(null, deliveryOrder.dmpl__Remarks__c, 'Test delivery Order have 1 deleted record');
    } 
    
    @isTest
    public static void updateDiscountInDeliveryOrderLinesTest()
    {
        test.startTest();
        List<dmpl__DeliveryOrder__c> deliveryOrder = [Select Id,Name,dmpl__Remarks__c,dmpl__Discount__c From dmpl__DeliveryOrder__c LIMIT 1];
        SaleDeliveryHelper.updateDiscountInDeliveryOrderLines(deliveryOrder);
        test.stopTest();
     }
    
    @isTest
    public static void UpdateDeliveryOrderLine()
    {
        Test.Starttest();
        dmpl__DeliveryOrderLine__c deliveryOrderLine = [Select Id,Name,dmpl__Quantity__c From dmpl__DeliveryOrderLine__c LIMIT 1];
        deliveryOrderLine.dmpl__Quantity__c = 1;
        deliveryOrderLine.dmpl__DiscountAmount__c=50;
        update deliveryOrderLine;
        Test.Stoptest();
        System.assertEquals(1, deliveryOrderLine.dmpl__Quantity__c, 'Test delivery Order Line have 1 updated record');
    }
    
    @isTest
    public static void UpdateSaleOrder()
    {
        Test.Starttest();
        dmpl__SaleOrder__c saleOrder = [Select Id,Name,dmpl__PerformReleaseDelivery__c From dmpl__SaleOrder__c LIMIT 1];
        saleOrder.dmpl__PerformReleaseDelivery__c = true;
        update saleOrder;
        System.assertEquals(true, saleOrder.dmpl__PerformReleaseDelivery__c, 'Test sale Order Line have 1 updated record');
        Test.Stoptest();
    }
    
    @isTest
    public static void DeleteDeliveryOrderLine()
    {
        try{
            test.startTest();
            dmpl__DeliveryOrderLine__c deliveryOrderLine = [Select Id,Name,dmpl__Quantity__c From dmpl__DeliveryOrderLine__c LIMIT 1];
            delete deliveryOrderLine;
            test.stopTest();
            System.assertEquals(1, deliveryOrderLine.dmpl__Quantity__c, 'Test delivery Order Line have 1 deleted record');
        }catch(exception e){}
    } 
    
    @isTest
    private static void VerifyPriceMethod()
    {
        test.startTest();
        CreatePriceList();
        List<dmpl__DeliveryOrder__c> deliveryOrder = [Select Id,Name,dmpl__PartnerAccountId__c,dmpl__BranchId__c,dmpl__PriceListId__c,dmpl__AccountId__c,dmpl__Remarks__c From dmpl__DeliveryOrder__c LIMIT 1];
        PriceListHelper.setDefaultPriceListIds(deliveryOrder);
        test.stopTest();
    }

    
    
    @isTest
    private static void VerifyCreateSaleInvoiceFromDO()
    {
        try{
        test.startTest();
        dmpl__SaleOrderLine__c saleOrderLine = [Select Id,Name,dmpl__Quantity__c,dmpl__PendingAllocatedInvoicedQuantity__c,dmpl__AllocatedInvoicedQuantity__c,dmpl__FulfilmentAllocatedQuantity__c From dmpl__SaleOrderLine__c LIMIT 1];
        System.debug('sol'+saleOrderLine);
        List<dmpl__DeliveryOrder__c> deliveryOrder = [Select Id,Name,dmpl__PartnerAccountId__c,dmpl__BranchId__c,dmpl__PriceListId__c,dmpl__AccountId__c,dmpl__Remarks__c From dmpl__DeliveryOrder__c WHERE dmpl__SaleOrderId__c != null];
        SaleInvoiceHelper.createSaleInvoiceFromDeliveryOrder(deliveryOrder);
        test.stopTest();
        }catch(Exception e){}
    }
    
    @isTest
    private static void VerifyCreateInvoiceFromDO()
    {
        try{
        test.startTest();
        List<dmpl__DeliveryOrder__c> deliveryOrder = [Select Id,Name,dmpl__PartnerAccountId__c,dmpl__BranchId__c,dmpl__PriceListId__c,dmpl__AccountId__c,dmpl__Remarks__c From dmpl__DeliveryOrder__c WHERE dmpl__SaleOrderId__c != null];
        List<dmpl__DeliveryOrderLine__c> deliveryOrderLines = [Select Id,Name From dmpl__DeliveryOrderLine__c];
        system.debug('do line'+deliveryOrderLines.size());
        
        List<SourceObjectInfo> objList = new List<SourceObjectInfo>();
        SourceObjectInfo obj = new SourceObjectInfo('dmpl__DeliveryOrderLine__c',deliveryOrderLines[0].Id,1,null);
        objList.add(obj);
        
        SaleInvoiceHelper.createSaleInvoiceFromDeliveryOrder(deliveryOrder[0].Id);
        SaleInvoiceHelper.createSaleInvoiceFromDeliveryOrder(objList);
        test.stopTest();
        }catch(exception e){}
    }
    
    //Test getDeliveryOrder
    @isTest
    private static void getDeliveryOrderTest()
    {
      
        test.startTest();
        List<dmpl__DeliveryOrder__c> deliveryOrder = [Select Id,Name,dmpl__PartnerAccountId__c,dmpl__BranchId__c,dmpl__PriceListId__c,dmpl__AccountId__c,dmpl__Remarks__c From dmpl__DeliveryOrder__c WHERE dmpl__SaleOrderId__c != null];
        DeliveryOrderLine__c deliveryOrderLine=[select dmpl__DeliveryId__c,id from DeliveryOrderLine__c limit 1];
        DiscountGroupHelper.getDeliveryOrder(deliveryOrderLine,deliveryOrder);
        test.stopTest();
       
    }
    private static void CreateAccountGroup()
    {
        dmpl__AccountGroup__c accountGroup= new dmpl__AccountGroup__c (Name= 'Test-AccountGroup', 
                                                                       dmpl__AccountGroupType__c='Discount');
        insert accountGroup;
    
       /* List<Account> account = new List<Account>();
        account.add(new Account(Name = 'Partner-Test-Account', 
                                dmpl__LastName__c = 'Sale Order',
                                Fax = '09876',
                                Phone = '1234567891',
                                Website = 'www.Dealermatix.com',
                                Type = 'Prospect',
                                NumberOfEmployees = 2,
                                Industry = 'Education',
                                AnnualRevenue = 1000,
                                Description = 'Accounts added',
                                dmpl__IsPartnerAccount__c = True,
                                dmpl__IsSupplierAccount__c = True,
                                dmpl__IsActive__c = True,
                                dmpl__IsTaxExempted__c = True,
                                dmpl__IsCustomerAccount__c = True,
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
    }
    
    private static void CreateBranch()
    {
        List<dmpl__Branch__c> branch = new List<dmpl__Branch__c>();
        Account partnerAccount = [Select Id,Name From Account WHERE  dmpl__IsPartnerAccount__c = True LIMIT 1];
        branch.Add(new dmpl__Branch__c(dmpl__PartnerAccountId__c =partnerAccount.Id,
                                       Name = 'Test-Branch',
                                       dmpl__IsActive__c = true,
                                       dmpl__MarketingName__c = 'Hero',
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
        
        Account partnerAccount1 = [Select Id,Name From Account WHERE  dmpl__IsPartnerAccount__c = True LIMIT 1];
        branch.Add(new dmpl__Branch__c(dmpl__PartnerAccountId__c =partnerAccount1.Id,
                                       Name = 'Test-Branch1',
                                       dmpl__IsActive__c = true,
                                       dmpl__MarketingName__c = 'Hero',
                                       dmpl__Website__c = 'www.dealermatix.com',
                                       dmpl__Email__c = 'Dealer@Outlook.com',
                                       dmpl__MobileNumber__c = 89,
                                       dmpl__Phone__c = '1888888888',
                                       dmpl__AllowSales__c = true,
                                       dmpl__AllowService__c = true,
                                       dmpl__AllowPurchase__c = true,
                                       dmpl__AllowInventory__c = true,
                                       dmpl__IsHomeDeliveryAvailable__c = true,
                                       dmpl__IsPickupDropAvailable__c = true,
                                       dmpl__SalesPhone__c = '1777777777',
                                       dmpl__ServiceEmail__c = 'Customer@Outlook1.com'));
        insert branch;
    }
    private static void CreateAsset()
    {
        List<Asset> asset = new List<Asset>();
        Account account = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
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
    
        List<dmpl__SKU__c> sku = new List<dmpl__SKU__c>();
        sku.add(new dmpl__SKU__c(Name = 'Test - SKU',
                                 dmpl__SKUCode__c = 'Test - SKU - Code',
                                 dmpl__UnitOfMeasureOfConversion__c = 10,
                                 dmpl__ProductColor__c = 'Sample',
                                 dmpl__IsDefault__c = false,
                                 dmpl__QuantityUnitOfMeasure__c ='Sample',
                                 dmpl__ItemId__c = item[0].Id));
        insert sku;
    }
    private static void CreatePriceList()
    {
        List<dmpl__PriceList__c> priceList =new List<dmpl__PriceList__c>();
        //dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        //Account account=[Select Id,Name from Account Where Name='Partner-Test-Account' LIMIT 1];
        //dmpl__AccountGroup__c accountGroup=[Select Id,Name From dmpl__AccountGroup__c LIMIT 1];
        priceList.Add(new dmpl__PriceList__c(//dmpl__PartnerAccountId__c = account.Id,
                                            //dmpl__BranchId__c = Branch.Id,
                                            //dmpl__PartnerAccountGroupId__c= accountGroup.Id,
                                            //dmpl__PartnerGroupId__c=accountGroup.Id,
                                            //dmpl__CustomerAccountGroupId__c=accountGroup.Id,
                                            //dmpl__CustomerGroupId__c=accountGroup.Id,
                                            Name='Test-1',
                                            dmpl__PriceListType__c = 'Sale Price',
                                            dmpl__IsActive__c = true
                                            ));
        insert priceList;
    }
    /*
    private static void CreateResource()
    {
        List<dmpl__Resource__c> resource = new List<dmpl__Resource__c>();
        Account partnerAccount = [Select Id,Name From Account LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        resource.add(new dmpl__Resource__c(Name = 'Test - Resource',
                                           dmpl__ResourceType__c = 'Sample',
                                           dmpl__IsActive__c = true,
                                           dmpl__Phone__c = '9999999999',
                                           dmpl__DefaultPartnerAccountId__c = partnerAccount.Id,
                                           dmpl__DefaultBranchId__c = branch.Id
                                          ));
        insert resource;
    
        List<dmpl__TaxGroup__c> taxGroup = new List<dmpl__TaxGroup__c>();
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account'];
        dmpl__AccountGroup__c AccountGroup = [Select Id,Name FROM dmpl__AccountGroup__c LIMIT 1];
        //dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch'];
        taxGroup.Add(new dmpl__TaxGroup__c(Name = 'Test - Tax Group',
                                           dmpl__PartnerAccountId__c = account.Id,
                                           dmpl__BranchId__c = branch.Id,
                                           dmpl__PartnerAccountGroupId__c= AccountGroup.Id,
                                           dmpl__IsActive__c=True,
                                           dmpl__Description__c='Text'
                                          ));
        insert taxGroup;
    }/*
    /*
    private static void CreateContactAddress()
    {
        List<dmpl__ContactAddress__c> contactAddress = new List<dmpl__ContactAddress__c>();
        Account account = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        contactAddress.add(new dmpl__ContactAddress__c(dmpl__AccountId__c = account.Id,
                                                       Name = 'Test - Contact - Address'                                                      
                                                      ));
        insert contactAddress;
    
        List<dmpl__DiscountGroup__c> discountGroups = new List<dmpl__DiscountGroup__c>();
        discountGroups.add(new dmpl__DiscountGroup__c (Name = 'Test-Discount'
                                                      ));
        insert discountGroups;
    }*/
    
    private static void CreateSaleOrder()
    {
        List<dmpl__SaleOrder__c> saleOrder = new List<dmpl__SaleOrder__c>();
        Account account = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [SELECT Id,dmpl__TaxGroupType__c FROM dmpl__TaxGroup__c WHERE dmpl__TaxGroupType__c='Line Level' LIMIT 1];
        //dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        saleOrder.Add(new dmpl__SaleOrder__c(dmpl__AccountId__c = account.Id,
                                             dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                             dmpl__BranchId__c = branch.Id,
                                             dmpl__DocumentDate__c = Date.today(),
                                             dmpl__Status__c = 'Draft',
                                             dmpl__RequiredDate__c = Date.today(),
                                             //dmpl__SalesExecutiveId__c = resource.Id,
                                             dmpl__BookingAmount__c = 100,
                                             dmpl__PromisedDate__c = Date.today(),
                                             dmpl__PerformReleaseFulfilment__c = false,
                                             dmpl__PerformReleaseInvoice__c = false,
                                             dmpl__PerformReleaseDelivery__c = false));
        insert saleOrder;
        
        List<dmpl__SaleOrderLine__c> saleOrderLine = new List<dmpl__SaleOrderLine__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        saleOrderLine.Add(new dmpl__SaleOrderLine__c(dmpl__SaleOrderId__c = saleOrder[0].Id,
                                                     dmpl__ItemId__c = item.Id,
                                                     dmpl__Quantity__c = 5,
                                                     dmpl__SKUId__c = sku.Id,
                                                     dmpl__TaxGroupId__c = taxGroup.Id
                                                     //dmpl__FulfilmentAllocatedQuantity__c = 1
                                                     //dmpl__AllocatedInvoicedQuantity__c = 1
                                                     
                                                    ));
        insert saleOrderLine;
    }
    
    private static void CreateTaxGroup()
    {
        List<dmpl__TaxGroup__c> taxGroup = new List<dmpl__TaxGroup__c>();
        Account account=[Select Id,Name from Account LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1]; 
        dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c LIMIT 1];
        taxGroup.Add(new dmpl__TaxGroup__c(Name = 'Test - Tax Group',
                                           dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                           dmpl__BranchId__c = branch.Id, 
                                           dmpl__PartnerAccountGroupId__c = accountGroup.Id,
                                           dmpl__Description__c = 'Description',
                                           dmpl__TaxGroupType__c = 'Line Level',
                                           dmpl__IsActive__c = true
                                          ));
        insert taxGroup;
    }
    
    private static void CreateTax()
    {
        List<dmpl__Tax__c> tax = new List<dmpl__Tax__c>();
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        tax.Add(new dmpl__Tax__c(Name = 'Test - Tax',
                                dmpl__TaxGroupId__c = taxGroup.Id,
                                dmpl__Type__c = 'Cess',
                                 dmpl__PostingFieldName__c ='Tax1',
                                dmpl__Rate__c = 10
                                ));        
        insert tax;
    }
    
    private static void CreateTaxGroupRule()
    {
        List<dmpl__TaxGroupRule__c> taxGroupRule = new List<dmpl__TaxGroupRule__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c SKU = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name,PartnerAccountId__c From dmpl__TaxGroup__c LIMIT 1];
       // dmpl__ItemGroup__c ItemGroup = [Select Id,Name From dmpl__ItemGroup__c LIMIT 1];
        taxGroupRule.Add(new dmpl__TaxGroupRule__c(dmpl__TaxGroupId__c = taxGroup.Id,
                                                   dmpl__SKUId__c=SKU.Id,
                                                  dmpl__ItemId__c = Item.Id,
                                                   dmpl__DateEffectiveFrom__c=date.today(),
                                                   dmpl__DateEffectiveTill__c=date.today()+15,
                                                   dmpl__PlaceOfSupplyType__c='Within State'
                                                   //dmpl__ItemGroupId__c=ItemGroup.Id
                                                  ));
        insert taxGroupRule;
    }
    
    private static void CreateFulfillment()
    {
        List<dmpl__InventoryFulfillment__c> fulfillment = new List<dmpl__InventoryFulfillment__c>();
        Account account = [Select Id,Name From Account LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        fulfillment.Add(new dmpl__InventoryFulfillment__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                          dmpl__BranchId__c = Branch.Id,
                                                          dmpl__AccountId__c = account.Id,
                                                          dmpl__SaleOrderId__c = saleOrder.id,
                                                          dmpl__PerformAllocation__c = true,
                                                          dmpl__IsAllocated__c = true));
        insert fulfillment;
        
        List<dmpl__InventoryFulfillmentOrderLine__c> OrderLine = new List<dmpl__InventoryFulfillmentOrderLine__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__SaleOrderLine__c saleOrderLine = [Select Id,Name From dmpl__SaleOrderLine__c LIMIT 1];
        OrderLine.Add(new dmpl__InventoryFulfillmentOrderLine__c(dmpl__FulfillmentId__c = fulfillment[0].Id,
                                                                 dmpl__ItemId__c = item.id,
                                                                 dmpl__SKUId__c = sku.Id,
                                                                 dmpl__SaleOrderLineId__c = saleOrderLine.Id
                                                                ));
        insert OrderLine;
    
        List<dmpl__InventoryFulfillmentAllocationLine__c> fulfillmentAllocationLine = new List<dmpl__InventoryFulfillmentAllocationLine__c>();
        //dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = [Select Id,Name From dmpl__InventoryFulfillmentOrderLine__c LIMIT 1];
        //dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        //dmpl__InventoryFulfillment__c fulfillment = [Select Id,Name From dmpl__InventoryFulfillment__c LIMIT 1];
        //dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        fulfillmentAllocationLine.Add(new dmpl__InventoryFulfillmentAllocationLine__c(//dmpl__AllocatedById__c = resource.Id,
                                                                                      dmpl__FulfillmentOrderLineId__c = OrderLine[0].Id,
                                                                                      dmpl__ItemId__c = item.Id,
                                                                                      dmpl__FulfillmentOrderId__c = fulfillment[0].Id,
                                                                                      dmpl__Quantity__c = 1
                                                                                     ));
        insert fulfillmentAllocationLine;
    }
    /*
    private static void CreateNewPayment()
    {
        List<dmpl__Payment__c> payment = new List<dmpl__Payment__c>();
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        dmpl__SaleInvoice__c saleInvoice = [Select Id,Name From dmpl__SaleInvoice__c LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        Account customerAccount = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
        payment.Add(new dmpl__Payment__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                         dmpl__BranchId__c = branch.Id,
                                         dmpl__AccountId__c = customerAccount.Id,
                                         dmpl__PaymentDate__c = Date.today(),
                                         dmpl__Amount__c = 1000,
                                         dmpl__PaymentMode__c = 'Cash',
                                         dmpl__SaleInvoiceId__c = saleInvoice.Id,
                                         dmpl__SaleOrderId__c = saleOrder.Id));
        insert payment;
    }
    */
    
    /*
    private static void CreateFinancer()
    {
        List<dmpl__Financer__c> financer = new List<dmpl__Financer__c>();
        Account account = [Select Id,Name From Account LIMIT 1];
        financer.Add(new dmpl__Financer__c(Name = 'Test-Financer',
                                           dmpl__AccountId__c = account.Id,
                                           dmpl__Address__c = 'Test-Address',
                                           dmpl__Description__c = 'Test-description'
                                          ));
        insert financer;
    
        List<dmpl__FinancerScheme__c> financerScheme = new List<dmpl__FinancerScheme__c>();
        //dmpl__Financer__c financer = [Select Id,Name From dmpl__Financer__c LIMIT 1];
        //Account account = [Select Id,Name From Account LIMIT 1];
        dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c LIMIT 1];
        financerScheme.Add(new dmpl__FinancerScheme__c(Name = 'Test-FinancerScheme',
                                                       dmpl__FinancerId__c = financer[0].Id,
                                                       dmpl__MinimumTenure__c = 3,
                                                       dmpl__MaximumTenure__c = 2,
                                                       dmpl__MinimumAmount__c = 100,
                                                       dmpl__MaximumAmount__c = 100,
                                                       dmpl__InterestRate__c = 2,
                                                       dmpl__Features__c = 'Test-Features',
                                                       dmpl__ApplicablePartnerAccountId__c = account.Id,
                                                       dmpl__ApplicableToPartnerAccountGroupId__c = accountGroup.Id
                                                      ));
        insert financerScheme;
        
        List<dmpl__FinanceCase__c> financeCase = new List<dmpl__FinanceCase__c>();
        //dmpl__Financer__c financer = [Select Id,Name From dmpl__Financer__c LIMIT 1];
        //dmpl__FinancerScheme__c financerScheme = [Select Id,Name From dmpl__FinancerScheme__c LIMIT 1];
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        dmpl__SaleInvoice__c saleInvoice = [Select Id,Name From dmpl__SaleInvoice__c];
        financeCase.Add(new dmpl__FinanceCase__c(dmpl__SaleOrderId__c = saleOrder.Id,
                                                 dmpl__BranchId__c = branch.Id,
                                                 dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                 dmpl__FinanceSchemeId__c = financerScheme[0].Id,
                                                 dmpl__FinanceProviderId__c = financer[0].Id,
                                                 dmpl__RequestedDownPayment__c = 100,
                                                 dmpl__RequestedAmount__c = 100,
                                                 dmpl__RequestedTenureMonths__c = 2,
                                                 dmpl__RequestedInterestRate__c = 2,
                                                 dmpl__EMIOnRequestedAmount__c = 100,
                                                 dmpl__SaleInvoiceId__c = saleInvoice.Id
                                                ));
        insert financeCase;
    }*/
    
    private static void CreateSaleInvoice()
    {
        List<dmpl__SaleInvoice__c> saleInvoice = new List<dmpl__SaleInvoice__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        //dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        saleInvoice.Add(new dmpl__SaleInvoice__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                 dmpl__BranchId__c = Branch.Id,
                                                 dmpl__SaleOrderId__c = saleOrder.id,
                                                 dmpl__DocumentDate__c = date.today(),
                                                 //dmpl__SalesExecutiveId__c = resource.Id,
                                                 dmpl__FinanceAmount__c = 100,
                                                 dmpl__AmountPaid__c = 100                                           
                                                ));
        insert saleInvoice;
    
        List<dmpl__SaleInvoiceLine__c> saleInvoiceLine = new List<dmpl__SaleInvoiceLine__c>();
        dmpl__SKU__c sku = [Select Id ,Name From dmpl__SKU__c LIMIT 1 ];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SaleOrderLine__c saleOrderLine = [Select Id,Name From dmpl__SaleOrderLine__c LIMIT 1];
        saleInvoiceLine.Add(new dmpl__SaleInvoiceLine__c(dmpl__SaleInvoiceId__c = SaleInvoice[0].id,
                                                         dmpl__ItemId__c = item.Id,
                                                         dmpl__SKUId__c = sku.Id,
                                                         dmpl__Quantity__c = 100.0,
                                                         dmpl__UnitPrice__c = 100,
                                                         dmpl__SchemeDiscountAmount__c = 100,
                                                         dmpl__SaleOrderLineId__c = saleOrderLine.Id
                                                        ));
        insert saleInvoiceLine;
    }
    
    private static void CreateDiscountGroup()
    {
        List<dmpl__DiscountGroup__c> discountGroup = new List<dmpl__DiscountGroup__c>();
        dmpl__AccountGroup__c accountGroup=[Select Id,Name From dmpl__AccountGroup__c LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c Limit 1];
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account' LIMIT 1];
        discountGroup.add(new dmpl__DiscountGroup__c(dmpl__BranchId__c = branch.Id,
                                                     dmpl__CustomerAccountGroupId__c = accountGroup.Id,
                                                     dmpl__PartnerAccountId__c = account.Id,
                                                     dmpl__PartnerAccountGroupId__c = accountGroup.Id,
                                                     dmpl__IsDefault__c = true,
                                                     dmpl__IsActive__c = true,
                                                     Name = 'Test - Discount - Group',
                                                     dmpl__DiscountType__c ='Sale Price'
                                                    ));
        insert discountGroup;
    }
    
    private static void CreateDeliveryOrder()
    {
        List<dmpl__DeliveryOrder__c> deliveryOrder = new List<dmpl__DeliveryOrder__c>();
        dmpl__SaleOrder__c saleOrder = [Select Id,Name,dmpl__AccountId__c,dmpl__PartnerAccountId__c,dmpl__BranchId__c From dmpl__SaleOrder__c LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch' LIMIT 1];
        Account customerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' AND dmpl__IsCustomerAccount__c = True LIMIT 1];
        deliveryOrder.Add(new dmpl__DeliveryOrder__c(dmpl__AccountId__c = customerAccount.Id,
                                                     dmpl__BranchId__c = branch.Id,
                                                     dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                     dmpl__SaleOrderId__c = saleOrder.Id));
        insert deliveryOrder;
    
        List<dmpl__DeliveryOrderLine__c> deliveryOrderLine = new List<dmpl__DeliveryOrderLine__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        //Asset asset =[select Id, Name from Asset];
        dmpl__SaleOrderLine__c saleOrderLine = [Select Id,Name From dmpl__SaleOrderLine__c LIMIT 1];
        deliveryOrderLine.Add(new dmpl__DeliveryOrderLine__c(dmpl__DeliveryId__c = deliveryOrder[0].Id,
                                                             dmpl__ItemId__c = item.Id,
                                                             dmpl__SKUId__c = sku.Id,
                                                             //dmpl__AssetId__c=asset.Id,
                                                             dmpl__SaleOrderLineId__c = saleOrderLine.Id,
                                                             dmpl__Quantity__c = 1,dmpl__Discount__c = 100
                                                            ));
        insert deliveryOrderLine;
   
        List<dmpl__DeliveryOrder__c> deliveryOrder1 = new List<dmpl__DeliveryOrder__c>();
        //dmpl__SaleOrder__c saleOrder = [Select Id,Name,dmpl__AccountId__c,dmpl__PartnerAccountId__c,dmpl__BranchId__c From dmpl__SaleOrder__c LIMIT 1];
        deliveryOrder1.add(new dmpl__DeliveryOrder__c(dmpl__PartnerAccountId__c = saleOrder.dmpl__PartnerAccountId__c,
                                                     dmpl__BranchId__c = saleOrder.dmpl__BranchId__c,
                                                     dmpl__AccountId__c = saleOrder.dmpl__AccountId__c));
        insert deliveryOrder1;        
    }
    /*
    private static void CreateChecklistTemplate()
    {
        List<dmpl__ChecklistTemplate__c> checkList = new List<dmpl__ChecklistTemplate__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        checkList.add(new dmpl__ChecklistTemplate__c(dmpl__ItemId__c=item.Id,
                                                     Name='Test1',
                                                     dmpl__Type__c='Delivery',
                                                     dmpl__Code__c='Done'));
        insert checkList;
        
    
        List<dmpl__CheckListTemplateLine__c> checkListLine = new List<dmpl__CheckListTemplateLine__c>();
        checkListLine.add(new dmpl__CheckListTemplateLine__c(dmpl__ChecklistTemplateId__c = checkList[0].Id,
                                                         dmpl__DataType__c = 'Text'
                                                        ));
        insert checkListLine;
    
        List<dmpl__CheckListLines__c> checkListLines1 = new List<dmpl__CheckListLines__c>();
        //dmpl__ChecklistTemplate__c checkListTemplate = [Select Id,Name From dmpl__ChecklistTemplate__c LIMIT 1];
        //dmpl__ChecklistTemplateLine__c checkListTemplateLine = [Select Id,Name From dmpl__ChecklistTemplateLine__c LIMIT 1];
        dmpl__DeliveryOrder__c Order = [Select Id,Name From dmpl__DeliveryOrder__c LIMIT 1];
        checkListLines1.add(new dmpl__CheckListLines__c(dmpl__DeliveryOrderId__c     = Order.Id,
                                                  dmpl__CheckListTemplateLineId__c = checkListLine[0].Id,
                                                  dmpl__ChecklistTemplateId__c = checkList[0].Id,
                                                  Name='Test2',
                                                  dmpl__DataType__c='Text'
                                                 ));
        insert checkListLines1;
    }
    
    private static void CreatePurchaseOrder()
    {
        List<dmpl__PurchaseOrder__c> purchaseOrder = new List<dmpl__PurchaseOrder__c>();
        Account supplierAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch1'];
        purchaseOrder.add(new dmpl__PurchaseOrder__c(dmpl__BranchId__c = branch.Id,
                                                     dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                     dmpl__SupplierAccountId__c = supplierAccount.Id,
                                                     dmpl__PurchaseOrderType__c = 'Part PO',
                                                     dmpl__DocumentDate__c = date.today(),
                                                     dmpl__Remarks__c = 'Test-Remarks'
                                                    ));
        insert purchaseOrder;
    
        List<dmpl__PurchaseOrderLine__c> purchaseOrderLine = new List<dmpl__PurchaseOrderLine__c>();
        dmpl__Item__c listofitem = [Select Id, Name from dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        purchaseOrderLine.add(new dmpl__PurchaseOrderLine__c(dmpl__ItemId__c = listofitem.Id,
                                                             dmpl__SKUId__c = sku.Id,
                                                             dmpl__PurchaseOrderId__c = purchaseOrder[0].Id,
                                                             dmpl__Quantity__c = 1,
                                                             dmpl__UnitCost__c = 100
                                                             
                                                            ));
        insert purchaseOrderLine;
    }*/
}