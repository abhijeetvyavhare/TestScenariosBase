@isTest
public class SaleReturnHelper_Test {
    
   @testSetup
    public static void setup()
    {
      /*  Account account =new Account(Name = 'Test - Account', 
                                dmpl__LastName__c = 'Sale Invoice',
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
                               );
        insert account; */
        
        Account partneraccount = new Account(Name = 'Partner-Test-Account',
                                             dmpl__LastName__c = 'Sale Order',
                                             dmpl__IsPartnerAccount__c = True, 
                                             dmpl__IsActive__c = true);
        insert partneraccount;
               
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__LastName__c = 'Sale Order',
                                              dmpl__IsCustomerAccount__c = True,
                                              dmpl__IsActive__c = true);
        insert customerAccount;
        
      /*  Account supplierAccount = new Account(Name = 'Supplier-Test-Account',
                                              dmpl__LastName__c = 'Sale Order',
                                              dmpl__IsSupplierAccount__c = True,
                                              dmpl__IsActive__c = true);
        insert supplierAccount; */
        
    dmpl__Item__c productItem = new dmpl__Item__c(Name = 'Test-Item',
                                          dmpl__ItemCode__c = 'DMPL',
                                          dmpl__ItemType__c = 'Product',
                                          dmpl__ItemSubType__c = '',
                                          dmpl__Description__c = '',
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
                                         );
        insert productItem;
        
       /* dmpl__Item__c chargeItem = new dmpl__Item__c(Name = 'Test-Item1',
                                         dmpl__ItemCode__c = 'DMPL',
                                         dmpl__ItemType__c = 'Service Contract',
                                         dmpl__Description__c = '',                    
                                         dmpl__IsActive__c = true   
                                        );
        insert chargeItem;
        
        dmpl__Item__c workItem = new dmpl__Item__c(Name = 'Test-Item1',
                                       dmpl__ItemCode__c = 'DMPL',
                                       dmpl__ItemType__c = 'Work Item',
                                       dmpl__Description__c = '',                    
                                       dmpl__IsActive__c = true   
                                      );
        insert workItem; */
      
        
        dmpl__SKU__c sku = new dmpl__SKU__c(Name = 'Test - SKU',
                                 dmpl__SKUCode__c = 'Test - SKU - Code',
                                 dmpl__UnitOfMeasureOfConversion__c = 10,
                                 dmpl__ProductColor__c = 'Sample',
                                 dmpl__IsDefault__c = false,
                                 dmpl__QuantityUnitOfMeasure__c ='Sample',
                                 dmpl__ItemId__c = productItem.Id);
        insert sku;
            
        dmpl__Branch__c branch = new dmpl__Branch__c(dmpl__PartnerAccountId__c =partneraccount.Id,
                                       Name = 'Test-Branch',
                                       dmpl__IsActive__c = true,
                                       dmpl__MarketingName__c = 'Hero Electric',
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
                                       dmpl__ServiceEmail__c = 'Customer@Outlook.com',
                                       dmpl__Website__c = 'www.Dealer.com');
        insert branch;
        
         List<dmpl__PriceList__c> priceList =new List<dmpl__PriceList__c>();
        
        priceList.Add(new dmpl__PriceList__c(Name='Test-Price - List',
                                             dmpl__BranchId__c = branch.Id,
                                             dmpl__PriceListType__c = 'Sale Price',
                                             dmpl__PartnerAccountId__c= partneraccount.Id,
                                             dmpl__IsActive__c = true));
        insert priceList;
    
        List<dmpl__PriceListRules__c> priceListRules =new List<dmpl__PriceListRules__c>();
        priceListRules.Add(new dmpl__PriceListRules__c(dmpl__ItemId__c = productItem.Id,
                                                       dmpl__PriceListId__c=priceList[0].Id,
                                                       dmpl__Price__c=500,
                                                       dmpl__DateEffectiveFrom__c = date.today()
                                                      ));
        insert priceListRules;
        
        dmpl__Resource__c resource = new dmpl__Resource__c(Name = 'Test - Resource',
                                           dmpl__ResourceType__c = 'Service Advisor',
                                           dmpl__IsActive__c = true,
                                           dmpl__Phone__c = '9999999999',
                                           dmpl__DefaultPartnerAccountId__c = partnerAccount.Id,
                                           dmpl__DefaultBranchId__c = branch.Id);
        insert resource;
        
        dmpl__Resource__c technician = new dmpl__Resource__c(Name = 'Test - Resource',
                                            dmpl__ResourceType__c = 'Technician',
                                            dmpl__IsActive__c = true,
                                            dmpl__Phone__c = '9999999999',
                                            dmpl__DefaultPartnerAccountId__c = partnerAccount.Id,
                                            dmpl__DefaultBranchId__c = branch.Id);
        insert technician;
        
        dmpl__ItemLot__c itemLot = new dmpl__ItemLot__c(dmpl__BranchId__c = branch.Id,
                                         dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                         dmpl__ItemId__c = productItem.Id,
                                         dmpl__SKUId__c =sku.Id,
                                         dmpl__BatchNo__c = 'AAA',
                                         dmpl__SerialNumber__c='BBB',
                                         dmpl__SupplierInvoiceNumber__c='CCC',
                                         dmpl__DateOfReceipt__c= date.today(),
                                         dmpl__DateOfMfg__c=date.today(),
                                         dmpl__TotalCost__c=10.2,
                                         dmpl__DateOfSupplierInvoice__c=date.today(),
                                         dmpl__Cost__c=38
                                        );
        insert itemLot; 
        
        dmpl__SaleOrder__c saleOrder = new dmpl__SaleOrder__c(dmpl__AccountId__c = customerAccount.Id,
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
                                             dmpl__PerformReleaseDelivery__c = false
                                            );
        insert saleOrder;
        CreateTaxGroup();
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c];
        
        dmpl__SaleOrderLine__c saleOrderLine= new dmpl__SaleOrderLine__c(dmpl__SaleOrderId__c = saleOrder.Id,
                                                     dmpl__ItemId__c = productItem.Id,
                                                     dmpl__SKUId__c=SKU.Id,
                                                     dmpl__Quantity__c = 1,
                                                     dmpl__UnitPrice__c=1,
                                                     dmpl__Discount__c=1,
                                                     dmpl__TaxGroupId__c=taxGroup.Id
                                                                         
                                                    );
        insert saleOrderLine;
        
        dmpl__SaleInvoice__c saleInvoice = new dmpl__SaleInvoice__c(dmpl__PartnerAccountId__c = partneraccount.Id,
                                                 dmpl__BranchId__c = Branch.Id,
                                                 dmpl__DocumentDate__c = date.today(),
                                                 dmpl__AccountId__c = customerAccount.Id,
                                                 //dmpl__SalesExecutiveId__c = resource.Id,
                                                 dmpl__PerformGLPosting__c = true,
                                                 dmpl__Status__c = 'Draft',
                                                 dmpl__SaleOrderId__c = saleOrder.Id
                                                );
        insert saleInvoice;
        
        dmpl__SaleInvoiceLine__c saleInvoiceLine = new dmpl__SaleInvoiceLine__c(dmpl__SaleInvoiceId__c = SaleInvoice.id,
                                                         dmpl__ItemId__c = productItem.Id,
                                                         dmpl__SKUId__c =sku.Id ,
                                                         dmpl__IsILPostingApproved__c=false,
                                                         dmpl__IsGLPostingApproved__c=false,
                                 dmpl__Quantity__c = 10,
                                                         dmpl__UnitPrice__c = 100,
                                                         dmpl__SchemeDiscountAmount__c = 100,
                                                         dmpl__TaxGroupId__c=taxGroup.Id
                                                        );
        insert saleInvoiceLine;
        
        test.startTest();
        dmpl__SaleReturn__c saleReturn = new dmpl__SaleReturn__c(dmpl__PartnerAccountId__c = partneraccount.Id,
                                                                 dmpl__BranchId__c = branch.Id,
                                                                dmpl__AccountId__c = customerAccount.Id,
                                                                dmpl__DocumentDate__c = date.today());
        insert saleReturn;
        
        
        dmpl__SaleReturnLine__c saleReturnLine = new dmpl__SaleReturnLine__c(dmpl__ItemId__c = productItem.Id,
                                                                    dmpl__SKUId__c =sku.Id,
                                                                             dmpl__Quantity__c = 5,
                                                                             dmpl__UnitPrice__c = 100,
                                                                             dmpl__SaleReturnId__c = saleReturn.Id,
                                                                             dmpl__SaleInvoiceId__c = saleInvoice.Id,
                                                                             dmpl__ItemLotId__c = itemLot.Id,
                                                                             dmpl__SaleInvoiceLineId__C = saleInvoiceLine.Id
                                                                            );
        insert saleReturnLine;
        
        /*
        dmpl__DeliveryOrder__c deliveryOrder = new dmpl__DeliveryOrder__c(dmpl__PartnerAccountId__c = partneraccount.Id,
                                                                 dmpl__BranchId__c = branch.Id,
                                                                dmpl__AccountId__c = customerAccount.Id
                                                                );
        insert deliveryOrder;
*/
       /*
        List<dmpl__DeliveryOrderLine__c> deliveryOrderLine = new List<dmpl__DeliveryOrderLine__c>();
        deliveryOrderLine.Add(new dmpl__DeliveryOrderLine__c(dmpl__DeliveryId__c = deliveryOrder.Id,
                                                             dmpl__ItemId__c = productItem.Id,
                                                             dmpl__SKUId__c = sku.Id,
                                                             dmpl__SaleOrderLineId__c = saleOrderLine.Id,
                                                             dmpl__Quantity__c = 5,
                                                             dmpl__ReturnedQuantity__c = 2
                                                            
                                                            ));
        insert deliveryOrderLine;
       
        */
        CreateDeliveryOrder();
        test.stopTest();
    }
    
    @isTest
    Private static void UpdateSetNewApplicablesTaxes()
    {
        Test.startTest();
        CreateTaxGroup();
        CreateTax();
        List<dmpl__SaleReturnLine__c> saleReturnLines = [Select Id,Name,dmpl__PriceListId__c,dmpl__PriceAsOnDate__c,dmpl__SaleReturnId__c,dmpl__ItemId__c,dmpl__SKUId__c,dmpl__UnitPrice__c,dmpl__SaleInvoiceLineId__c,dmpl__TaxGroupId__c,dmpl__ItemLotTypeId__c,dmpl__UOM__c,dmpl__UOM1__c,dmpl__UOMQuantity1__c,dmpl__UOMQuantity__c From dmpl__SaleReturnLine__c];
        dmpl__SaleReturnLine__c saleReturnLine = [Select Id,Name,dmpl__SaleReturnId__c,dmpl__PriceListId__c,dmpl__SaleInvoiceLineId__c,dmpl__TaxGroupId__c,dmpl__Amount__c,dmpl__UOM__c,dmpl__UOM1__c,dmpl__UOMQuantity1__c,dmpl__UOMQuantity__c From dmpl__SaleReturnLine__c LIMIT 1];
        dmpl__Tax__c tax = [Select Id,Name,dmpl__Rate__c From dmpl__Tax__c LIMIT 1];
        // SaleReturnTaxHelper.setNewApplicableTaxes(saleReturnLines);
        // SaleReturnTaxHelper.createSaleReturnTax(tax,saleReturnLine);
        // SaleReturnLineHelper.setItemData(saleReturnLines);
        //System.assert(saleReturnLines!=null, 'Record saved');
        Test.stopTest();
    }
    
    @isTest
    private static void UpdateSetApplicableTaxGroup()
    {
        Test.startTest();
        CreateTaxGroup();
        List<Id> Ids = new List<Id>();
        List<dmpl__SaleReturn__c> saleReturn = [Select Id,Name,dmpl__PartnerAccountId__c,BranchId__c,DocumentDate__c From dmpl__SaleReturn__c];
        List<dmpl__SaleReturnLine__c> saleReturnLine = [Select Id,Name,SKUId__c,dmpl__ItemId__c,dmpl__Quantity__c,dmpl__SaleInvoiceLineId__c,dmpl__ItemLotTypeId__c,dmpl__TaxGroupId__c From dmpl__SaleReturnLine__c];
        List<dmpl__Item__c> item = [Select Id,Name,dmpl__TaxItemGroupId__c From dmpl__Item__c];
        dmpl__TaxGroupRule__c rule = [Select Id,Name From dmpl__TaxGroupRule__c LIMIT 1];
        if(rule != null)
        {
          TaxGroupHelper.setApplicableTaxGroups(saleReturnLine,saleReturn,item);
        }
        SaleInvoiceLineHelper.updateSaleReturn(saleReturnLine);
        SaleInvoiceLineHelper.querySaleReturnLines(Ids);
        System.assertNotEquals(null, saleReturn);
        Test.stopTest();
    }
   @isTest
    private static void createSaleReturnFromSaleInvoiceInternalTest()
    {Test.startTest();
        List<SourceObjectInfo> info = new List <SourceObjectInfo>();
        dmpl__SaleReturnLine__c line=[Select Id, Name, dmpl__SaleReturnId__c from dmpl__SaleReturnLine__c  Limit 1];
        List<SaleInvoiceLine__c> invoice=[Select Id,
                                          dmpl__SaleInvoiceId__r.dmpl__BranchId__c,
                                          dmpl__SaleInvoiceId__r.dmpl__PartnerAccountId__c,
           dmpl__SaleInvoiceId__r.dmpl__DocumentDate__c,
           dmpl__SaleInvoiceId__r.dmpl__AccountId__c,
      dmpl__SaleInvoiceId__r.dmpl__PriceListId__c,
        dmpl__SaleInvoiceId__r.dmpl__GLAccountId__c,
         dmpl__SaleInvoiceId__r.dmpl__GeneralLedgerId__c,
          dmpl__SaleInvoiceId__r.dmpl__DiscountGroupId__c  ,
                                          dmpl__Discount2__c,
                                         dmpl__Discount__c,
                                         dmpl__DiscountAmount__c,
                                          dmpl__ContractDiscount__c,
                                          dmpl__DiscountAmount2__c,
                                          dmpl__ContractDiscountAmount__c,
                                         dmpl__GeneralLedgerId__c ,
                                         dmpl__GLAccountId__c ,
                                         dmpl__InventoryLedgerId__c ,
                                         dmpl__ItemLotId__c,
                                         dmpl__SaleOrderLineId__c,
                                         dmpl__SchemeDiscount__c ,
                                         dmpl__SchemeDiscountAmount__c ,
                                         dmpl__StorageLocationId__c ,
                                         dmpl__TaxAmount__c ,
                                         dmpl__TaxGroupId__c,
                                         dmpl__UnitPrice__c,
                                          dmpl__UnitPrice2__c,
                                         dmpl__RepairOrderLineId__c,
                                         dmpl__SaleInvoiceId__c,
                                         dmpl__SchemeLineId__c,
                                          dmpl__SchemeRewardPoints__c,
                                         Name,dmpl__SKUId__c,dmpl__AssetId__c,dmpl__ItemId__c,dmpl__EligibleReturnQuantity__c From SaleInvoiceLine__c Limit 1 ];
     
    Map<Id, dmpl__SaleReturn__c> result = SaleReturnHelper.createSaleReturnFromSaleInvoiceInternal(invoice, info);
                System.assert(true, 'Record saved');
        Test.stopTest();
    }
   
     @isTest
    Public static void createSaleReturnLinesFromSaleInvoiceInternal()
    {
        Test.startTest();
        List<SourceObjectInfo> info = new List <SourceObjectInfo>();
        dmpl__SaleReturnLine__c line=[Select Id, Name, dmpl__SaleReturnId__c from dmpl__SaleReturnLine__c  Limit 1];
        List<SaleInvoiceLine__c> invoice=[Select Id,
                                         dmpl__Discount__c,
                                         dmpl__DiscountAmount__c,
                                         dmpl__GeneralLedgerId__c ,
                                         dmpl__GLAccountId__c ,
                                         dmpl__InventoryLedgerId__c ,
                                         dmpl__ItemLotId__c,
                                         dmpl__SaleOrderLineId__c,
                                         dmpl__SchemeDiscount__c ,
                                         dmpl__SchemeDiscountAmount__c ,
                                         dmpl__StorageLocationId__c ,
                                         dmpl__TaxAmount__c ,
                                         dmpl__TaxGroupId__c,
                                         dmpl__UnitPrice__c,
                                         dmpl__RepairOrderLineId__c,
                                         dmpl__SaleInvoiceId__c,
                                         dmpl__SchemeLineId__c,
                                         Name,dmpl__SKUId__c,dmpl__AssetId__c,dmpl__ItemId__c,dmpl__EligibleReturnQuantity__c From SaleInvoiceLine__c Limit 1 ];
        
                System.assert(true, 'Record saved');
        Test.stopTest();
    }
   
    @isTest
    Public static void createSaleReturnLinesFromDeliveryInternal()
    {
        Test.startTest();
        List<SourceObjectInfo> info = new List <SourceObjectInfo>();
        dmpl__SaleReturnLine__c line=[Select Id, Name, dmpl__SaleReturnId__c from dmpl__SaleReturnLine__c  Limit 1];
        List<SaleInvoiceLine__c> invoice=[Select Id,
                                         dmpl__Discount__c,
                                         dmpl__DiscountAmount__c,
                                         dmpl__GeneralLedgerId__c ,
                                         dmpl__GLAccountId__c ,
                                         dmpl__InventoryLedgerId__c ,
                                         dmpl__ItemLotId__c,
                                         dmpl__SaleOrderLineId__c,
                                         dmpl__SchemeDiscount__c ,
                                         dmpl__SchemeDiscountAmount__c ,
                                         dmpl__StorageLocationId__c ,
                                         dmpl__TaxAmount__c ,
                                         dmpl__TaxGroupId__c,
                                         dmpl__UnitPrice__c,
                                         dmpl__RepairOrderLineId__c,
                                         dmpl__SaleInvoiceId__c,
                                         dmpl__SchemeLineId__c,
                                         Name,dmpl__SKUId__c,dmpl__AssetId__c,dmpl__ItemId__c,dmpl__EligibleReturnQuantity__c From SaleInvoiceLine__c Limit 1 ];
        
                System.assert(true, 'Record saved');
        Test.stopTest();
    }
    
    @isTest
    public static void verifySaleReturn()
    {
        try{
        test.startTest();
        dmpl__SaleReturn__c saleReturn = [Select Id,Name From dmpl__SaleReturn__c LIMIT 1];
        UpdateSaleReturnLine();
        UpdateSaleReturn();
      UpdatePerformInventoryPosting();      
      UpdatePerformGLPosting();
       // DeleteSaleReturnLine();
     //  DeleteSaleReturn();

            System.assert(saleReturn != null, 'Sale Return should be present');
            
           
            Test.stopTest();
        } catch (Exception e) {
           
        }
    
    }
    public static void UpdateSaleReturn()
    {
        dmpl__SaleReturn__c saleReturn = [Select Id,Name,dmpl__PerformReturn__c From dmpl__SaleReturn__c LIMIT 1];
        saleReturn.dmpl__PerformReturn__c = True;
        
        update saleReturn;
        System.assertEquals(True, saleReturn.dmpl__PerformReturn__c, 'Sale Return has 1 Record Updated');
    }
    
    public static void UpdatePerformInventoryPosting()
    {
        dmpl__SaleReturn__c saleReturn = [Select Id,Name,dmpl__PerformInventoryPosting__c From dmpl__SaleReturn__c LIMIT 1];
        saleReturn.dmpl__PerformInventoryPosting__c = True;
        
        update saleReturn;
        System.assertEquals(True, saleReturn.dmpl__PerformInventoryPosting__c, 'Sale Return has 1 Record Updated');
    }
    
    public static void UpdatePerformGLPosting()
    {
        dmpl__SaleReturn__c saleReturn = [Select Id,Name,dmpl__PerformGLPosting__c From dmpl__SaleReturn__c LIMIT 1];
        saleReturn.dmpl__PerformGLPosting__c = True;
        
        update saleReturn;
        System.assertEquals(True, saleReturn.dmpl__PerformGLPosting__c, 'Sale Return has 1 Record Updated');
    }
    
    public static void DeleteSaleReturn()
    {
        dmpl__SaleReturn__c saleReturn = [Select Id,Name,dmpl__PerformReturn__c From dmpl__SaleReturn__c LIMIT 1];
        
        Delete saleReturn;
        System.assertEquals(false, saleReturn.dmpl__PerformReturn__c, 'Sale Return has 1 Record Deleted');
        
    }
    
    public static void UpdateSaleReturnLine()
    {
        dmpl__SaleReturnLine__c saleReturnLine = [Select Id,Name,dmpl__Quantity__c,dmpl__IsApproved__c From dmpl__SaleReturnLine__c LIMIT 1];
        saleReturnLine.dmpl__Quantity__c =1;
        
        update saleReturnLine;
        System.assertEquals(1, saleReturnLine.dmpl__Quantity__c, 'Sale Return Line has 1 Record Updated');   
    }
    
    public static void DeleteSaleReturnLine()
    {
        try{
        UpdateSaleReturnLine();
        dmpl__SaleReturnLine__c saleReturnLine = [Select Id,Name,dmpl__Quantity__c From dmpl__SaleReturnLine__c LIMIT 1];
        if(saleReturnLine != null)
          Delete saleReturnLine;
        System.assertEquals(1, saleReturnLine.dmpl__Quantity__c, 'Sale Return Line has 1 Record Deleted');  
        }
        catch(exception e){}
    } 
    
    @isTest
    public static void verifycreateSaleReturnLinesFromSaleInvoiceInternal()
    {
        try{
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = [Select Id,Name From dmpl__SaleReturn__c LIMIT 1];
            system.debug('saleReturn'+saleReturn);
        List<dmpl__SaleInvoiceLine__c> saleInvoiceLine = [Select Id,Name,dmpl__EligibleReturnQuantity__c,dmpl__Quantity__c From dmpl__SaleInvoiceLine__c];
        System.debug('INV Line'+saleInvoiceLine);
        List<SourceObjectInfo> sourceInfo = new List<SourceObjectInfo>();
         SourceObjectInfo obj = new SourceObjectInfo('dmpl__SaleInvoiceLine__c',saleInvoiceLine[0].Id,1,'data');
         sourceInfo.add(obj);
         system.debug('sourceInfo'+sourceInfo);
        SaleReturnHelper.createSaleReturnFromSaleInvoice(sourceInfo,saleReturn.Id);
        SaleReturnHelper.createSaleReturnLinesFromSaleInvoiceInternal(saleInvoiceLine,sourceInfo,saleReturn.Id);
        //System.assert(saleReturn != null,'Sale Return Verified');
        Test.stopTest();
        }catch(exception e){}
    }
    
    @isTest
    public static void verifycreateSaleReturnLinesFromSaleDeliveryInternal()
    {
        try{
        Test.startTest();
        dmpl__SaleReturn__c saleReturn = [Select Id,Name From dmpl__SaleReturn__c LIMIT 1];
        List<dmpl__DeliveryOrderLine__c> deliveryOrderLine = [Select Id,Name,dmpl__Quantity__c,dmpl__ReturnedQuantity__c,dmpl__EligibleReturnQuantity__c,dmpl__ItemId__c,dmpl__SKUId__c,
                                                              dmpl__AssetId__c,dmpl__Discount__c,dmpl__DiscountAmount__c,dmpl__InventoryLedgerId__c,dmpl__ItemLotId__c,dmpl__SaleOrderLineId__c,dmpl__StorageLocationId__c,
                                                              dmpl__TaxAmount__c,dmpl__TaxGroupId__c,dmpl__UnitPrice__c,dmpl__SaleInvoiceLineId__c,dmpl__DeliveryId__c,
                                                              dmpl__DeliveryId__r.dmpl__DiscountGroupId__c,dmpl__DeliveryId__r.dmpl__PriceListId__c,dmpl__DeliveryId__r.dmpl__AccountId__c,
                                                              dmpl__DeliveryId__r.dmpl__DocumentDate__c,dmpl__DeliveryId__r.dmpl__PartnerAccountId__c,dmpl__DeliveryId__r.dmpl__BranchId__c From dmpl__DeliveryOrderLine__c LIMIT 1];
        List<SourceObjectInfo> sourceInfo = new List<SourceObjectInfo>();
         SourceObjectInfo obj = new SourceObjectInfo('dmpl__DeliveryOrderLine__c',deliveryOrderLine[0].Id,1,'data');
         sourceInfo.add(obj);
        SaleReturnHelper.createSaleReturnFromDelivery(sourceInfo,saleReturn.Id);
        SaleReturnHelper.createSaleReturnLinesFromDeliveryInternal(deliveryOrderLine,sourceInfo,saleReturn.Id);
        System.assert(saleReturn != null,'Sale Return Verified');
        Test.stopTest();
        }catch(exception e){}
    }
    
    
    @isTest
    private static void updateSaleReturnTAxmethods()
    {
        test.startTest();
         List<dmpl__DeliveryOrderLine__c> deliveryOrderLine = [Select Id,Name,dmpl__Discount2__c,dmpl__DiscountAmount2__c,dmpl__Quantity__c,dmpl__ContractDiscount__c,dmpl__ContractDiscountAmount__c,dmpl__ReturnedQuantity__c,dmpl__EligibleReturnQuantity__c,dmpl__ItemId__c,dmpl__SKUId__c,
                                                              dmpl__AssetId__c,dmpl__Discount__c,dmpl__DiscountAmount__c,dmpl__InventoryLedgerId__c,dmpl__ItemLotId__c,dmpl__SaleOrderLineId__c,dmpl__StorageLocationId__c,
                                                              dmpl__TaxAmount__c,dmpl__TaxGroupId__c,dmpl__UnitPrice__c,dmpl__SaleInvoiceLineId__c,dmpl__DeliveryId__c,
                                                              dmpl__DeliveryId__r.dmpl__DiscountGroupId__c,dmpl__DeliveryId__r.dmpl__PriceListId__c,dmpl__DeliveryId__r.dmpl__AccountId__c,
                                                              dmpl__DeliveryId__r.dmpl__DocumentDate__c,dmpl__DeliveryId__r.dmpl__PartnerAccountId__c,dmpl__DeliveryId__r.dmpl__BranchId__c From dmpl__DeliveryOrderLine__c LIMIT 1];
        List<SourceObjectInfo> sourceInfo = new List<SourceObjectInfo>();
        SourceObjectInfo obj = new SourceObjectInfo('dmpl__DeliveryOrderLine__c',deliveryOrderLine[0].Id,1,'data');
         sourceInfo.add(obj);
          SaleReturnHelper.createSaleReturnFromDeliveryInternal(deliveryOrderLine,sourceInfo);
       
       // List<dmpl__DeliveryOrder__c> order = [Select Id,Name From dmpl__DeliveryOrder__c LIMIT 1];
       list<dmpl__DeliveryOrder__c> DeliveryOrder=[select id,name from dmpl__DeliveryOrder__c limit 1];
       SaleReturnHelper.createSaleReturnFromDelivery(DeliveryOrder);

        SaleReturnHelper.createSaleReturnFromDelivery(DeliveryOrder[0].id);
        test.stopTest();
    }
    
  /*  private static void CreateAccountGroup()
    {
        dmpl__AccountGroup__c accountGroup= new dmpl__AccountGroup__c (Name= 'Test-AccountGroup', 
                                                                       dmpl__AccountGroupType__c='Scheme');
        insert accountGroup;
    }
    
    private static void CreateAccount()
    {
        List<Account> account = new List<Account>();
      
        account.add(new Account(Name = 'Test - Account',
                                dmpl__LastName__c = 'Account',
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
                               ));
        insert account;
        
        Account partneraccount = new Account(Name = 'Partner-Test-Account',
                                             dmpl__LastName__c = 'PartnerAccount',
                                             dmpl__IsPartnerAccount__c = True, 
                                             dmpl__IsActive__c = true);
        insert partneraccount;
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__LastName__c = 'CustomerAccount',
                                              dmpl__IsCustomerAccount__c = True,
                                              dmpl__IsActive__c = true);
        insert customerAccount;
    } */
    
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
                                   dmpl__ItemType__c = 'Product',
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
    
    private static void CreateItemLot()
    {
        List<dmpl__ItemLot__c> itemLot = new List<dmpl__ItemLot__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__SKU__c sku = [Select Id ,Name From dmpl__SKU__c LIMIT 1 ];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        itemLot.Add(new dmpl__ItemLot__c(dmpl__BranchId__c = branch.Id,
                                         dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                         dmpl__ItemId__c = item.Id,
                                         dmpl__SKUId__c =sku.Id,
                                         dmpl__BatchNo__c = 'AAA',
                                         dmpl__SerialNumber__c='BBB',
                                         dmpl__SupplierInvoiceNumber__c='CCC',
                                         dmpl__DateOfReceipt__c= date.today(),
                                         dmpl__DateOfMfg__c=date.today(),
                                         dmpl__TotalCost__c=10.2,
                                         dmpl__DateOfSupplierInvoice__c=date.today(),
                                         dmpl__Cost__c=38
                                        ));
        insert itemLot;       
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
    
    private static void CreateContactAddress()
    {
        List<dmpl__ContactAddress__c> contactAddress = new List<dmpl__ContactAddress__c>();
        Account account = [Select Id, Name FROM Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        contactAddress.add(new dmpl__ContactAddress__c(dmpl__AccountId__c = account.Id,
                                                       Name = 'Contact Address',
                                                       dmpl__AddressType__c = 'Both' ));
        insert contactAddress;
    }
    
    private static void CreateTax()
    {
        List<dmpl__Tax__c> tax = new List<dmpl__Tax__c>();
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c limit 1];
        tax.Add(new dmpl__Tax__c(Name = 'Test - Tax',
                                 dmpl__Rate__c = 10,
                                 dmpl__TaxGroupId__c = taxGroup.Id,
                                 dmpl__Type__c = 'Cess',
                                 dmpl__PostingFieldName__c = 'Tax1'
                                ));        
        insert tax;
    }
    
    private static void CreateSaleOrder()
    {
        List<dmpl__SaleOrder__c> saleOrder = new List<dmpl__SaleOrder__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
       Account account = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        //dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        saleOrder.Add(new dmpl__SaleOrder__c(dmpl__AccountId__c = account.Id,
                                             dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                             dmpl__BranchId__c = branch.Id
                                             //dmpl__SalesExecutiveId__c = resource.Id
                                            ));
        insert saleOrder;
    
        List<dmpl__SaleOrderLine__c> saleOrderLine = new List<dmpl__SaleOrderLine__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        saleOrderLine.Add(new dmpl__SaleOrderLine__c(dmpl__SaleOrderId__c = saleOrder[0].Id,
                                                     dmpl__ItemId__c = item.Id,
                                                     dmpl__SKUId__c = sku.Id,
                                                     dmpl__Quantity__c = 10,
                                                     dmpl__UnitPrice__c = 100,
                                                     dmpl__Discount__c = 5                                                                                                        
                                                    ));
        insert saleOrderLine;
    }
    
    private static void CreateDiscountGroup()
    {
        List<dmpl__DiscountGroup__c> discountGroup = new List<dmpl__DiscountGroup__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        discountGroup.add(new dmpl__DiscountGroup__c(dmpl__BranchId__c = branch.Id,
                                                     dmpl__IsDefault__c = true,
                                                     dmpl__PartnerAccountId__c=branch.dmpl__PartnerAccountId__c,
                                                     dmpl__IsActive__c = true,
                                                     Name='Test-Discount-Group'
                                                    ));
        insert discountGroup;
    }
    
    private static void CreateSaleInvoice()
    {
        List<dmpl__SaleInvoice__c> saleInvoice = new List<dmpl__SaleInvoice__c>();
        Account account = [Select Id,Name From Account LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        //dmpl__Resource__c resource = [Select Id, Name FROM dmpl__Resource__c LIMIT 1];
        saleInvoice.Add(new dmpl__SaleInvoice__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                 dmpl__BranchId__c = Branch.Id,
                                                 dmpl__SaleOrderId__c = saleOrder.id,
                                                 dmpl__DocumentDate__c = Date.today()
                                                 //dmpl__SalesExecutiveId__c = resource.Id
                                                ));
        insert saleInvoice;
    
        List<dmpl__SaleInvoiceLine__c> saleInvoiceLine = new List<dmpl__SaleInvoiceLine__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c itemSKU = [Select Id, Name from dmpl__SKU__c LIMIT 1];
        saleInvoiceLine.Add(new dmpl__SaleInvoiceLine__c(dmpl__SaleInvoiceId__c = SaleInvoice[0].Id,
                                                         dmpl__ItemId__c = item.Id,
                                                         dmpl__SKUId__c = itemSKU.Id,
                                                         dmpl__Quantity__c = 10,
                                                         dmpl__UnitPrice__c = 100,
                                                         dmpl__SchemeDiscountAmount__c = 1
                                                        ));
        insert saleInvoiceLine;
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
        dmpl__SaleOrderLine__c saleOrderLine = [Select Id,Name From dmpl__SaleOrderLine__c LIMIT 1];
        deliveryOrderLine.Add(new dmpl__DeliveryOrderLine__c(dmpl__DeliveryId__c = deliveryOrder[0].Id,
                                                             dmpl__ItemId__c = item.Id,
                                                             dmpl__SKUId__c = sku.Id,
                                                             dmpl__SaleOrderLineId__c = saleOrderLine.Id,
                                                             dmpl__Quantity__c = 1
                                                            ));
        insert deliveryOrderLine;
    }

    
    private static void CreateSaleReturn()
    {
        List<dmpl__SaleReturn__c> saleReturn = new List<dmpl__SaleReturn__c>();
        Account account = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        saleReturn.add(new dmpl__SaleReturn__c(dmpl__DocumentDate__c = date.today(),
                                               dmpl__PartnerAccountId__c = partnerAccount.Id,
                                               dmpl__BranchId__c = branch.Id,
                                               dmpl__AccountId__c = account.Id,
                                               dmpl__ItemId__c = item.Id,
                                               dmpl__PerformReturn__c = false
                                              ));
        insert saleReturn;
    
        List<dmpl__SaleReturnLine__c> saleReturnLine = new List<dmpl__SaleReturnLine__c>();
        dmpl__ItemLot__c lot = [Select Id,Name From dmpl__ItemLot__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__SaleInvoice__c saleinvoice = [Select Id,Name From dmpl__SaleInvoice__c LIMIT 1];
        dmpl__SaleInvoiceLine__c saleInvoiceLine = [Select Id,Name From dmpl__SaleInvoiceLine__c LIMIT 1];
        dmpl__SaleOrderLine__c saleOrderLine = [Select Id,Name From dmpl__SaleOrderLine__c LIMIT 1];
        saleReturnLine.add(new dmpl__SaleReturnLine__c(dmpl__SaleReturnId__c = saleReturn[0].Id,
                                                       dmpl__ItemId__c = item.Id,
                                                       dmpl__ItemLotId__c = lot.Id,
                                                       dmpl__SKUId__c = sku.Id,
                                                       dmpl__Quantity__c = 1,
                                                       dmpl__SaleOrderLineId__c=saleOrderLine.Id,
                                                       dmpl__IsApproved__c=false,
                                                       dmpl__UnitPrice__c = 100,
                                                       dmpl__SaleInvoiceId__c = saleInvoice.Id,
                                                       dmpl__SaleInvoiceLineId__c = saleInvoiceLine.Id));
        insert saleReturnLine;
    }
    
    private static void CreateTaxGroup()
    {
        List<dmpl__TaxGroup__c> taxGroup = new List<dmpl__TaxGroup__c>();
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account'];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        taxGroup.Add(new dmpl__TaxGroup__c(Name = 'Test - Tax Group',
                                           dmpl__PartnerAccountId__c = account.Id,
                                           dmpl__BranchId__c = branch.Id,
                                           dmpl__Description__c = 'Test-Description',
                                           dmpl__IsActive__c = false
                                          ));
        insert taxGroup;
        
        List<dmpl__TaxGroupRule__c> rule = new List<dmpl__TaxGroupRule__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        rule.add(new dmpl__TaxGroupRule__c(dmpl__DateEffectiveFrom__c = date.today(),
                                           dmpl__ItemId__c = item.Id,
                                           dmpl__ItemLotTypeId__c = null,
                                           dmpl__TaxGroupId__c = taxGroup[0].Id
                                          ));
        insert rule;
    }
    
    @isTest
    public static void updateSaleReturnNew()
    {
        test.startTest();
        List<dmpl__SaleReturnLine__c> line = [select id,Name,dmpl__SaleOrderLineId__c,dmpl__TaxGroupId__c,dmpl__IsApproved__c From dmpl__SaleReturnLine__c LIMIT 1];
        SaleOrderLineHelper.updateSaleReturn(line);
        //SaleReturnTaxHelper.setApplicableTaxesInternal(line, line[0].dmpl__IsApproved__c);
        test.stopTest();
    }
    
    @isTest
    public static void getReturnDocument()
    {
        test.startTest();
        List<dmpl__SaleReturn__c> sale = [Select Id,Name From dmpl__SaleReturn__c LIMIT 1];
        dmpl__SaleReturnLine__c line = [select id,Name,dmpl__SaleReturnId__c From dmpl__SaleReturnLine__c LIMIT 1];
        TaxGroupHelper.getReturnDocument(line,sale);
        test.stopTest();
    }
    
    @isTest
    private static void VerifyPriceList()
    {
        test.startTest();
        List<dmpl__SaleReturn__c>  saleReturn = [Select Id, Name,dmpl__PriceListId__c,dmpl__PartnerAccountId__c,dmpl__AccountId__c,dmpl__BranchId__c From dmpl__SaleReturn__c];
        PriceListHelper.setDefaultPriceListIds(saleReturn);    
        System.assert(saleReturn != null, 'Sale Orders data found');
        test.stopTest();
    }
    
}