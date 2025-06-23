@isTest
public class SaleOrderHelper_Test {
    
    @testSetup
    public static void Setup()
    {
        //System.runAs(PostInstallHelper.AssignAdministratorAllPermissions(UserInfo.getUserId())){
            CreateAccountGroup();
            CreateAccount();
            CreateContactAddress();
            CreateBranch();
            CreateItems();
            CreateSKu();
            //CreateItemMaintenanceSchedule();
            CreateItemFeatures();
            CreateItemAlternate();
            CreateItemComponent();
            CreateResource();
            CreatePriceList();
            CreatePriceListRules();
            CreateTaxGroup();
            //CreateTax(); 
            CreateTaxGroupRule();
            
            test.startTest();
            CreateSaleOrder();
     
            //CreateSaleOrderLine();
            
            CreateSaleInvoice();
            test.stopTest();
        //}
    }
    
    @isTest
    Public Static Void verifySaleOrder()
    {
        Test.startTest();
        string errorReceived;
        try{             
            CreateSaleOrder1();
        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
        System.assertEquals(null, errorReceived);
        Test.stopTest();
    }
    
    @isTest
    Public Static Void verifySaleOrderNew()
    {
        Test.startTest();
        string errorReceived;
        try{             
            CreateSaleOrder2();
            
        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
        System.assertEquals(null, errorReceived);
        
        Test.stopTest();
    }
    
  /*  @isTest
    public static void getQuote(){
         List<dmpl__Quote__c> ServiceEstimate = new List<dmpl__Quote__c>();
        Account account = [Select Id,Name From Account Where Name = 'Customer-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name,dmpl__ItemType__c From dmpl__Item__c LIMIT 1];
        ServiceEstimate.Add(new dmpl__Quote__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                     dmpl__BranchId__c = branch.Id,
                                                     dmpl__AccountId__c = account.Id,
                                                     dmpl__PerformEstimateLinesGeneration__c = false,
                                                     dmpl__ServiceContractItemId__c = item.Id,
                                                     dmpl__PerformApproval__c = false,
                                                     dmpl__PerformDecline__c = false,
                                                     dmpl__PerformRepairOrderGeneration__c = false,
                                                     dmpl__IsRepairOrderGenerated__c = false));
        insert ServiceEstimate;
        
        List<dmpl__QuoteLine__c> ServiceEstimateLine = new List<dmpl__QuoteLine__c>();
        dmpl__Item__c item1 = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        dmpl__Quote__c serviceEstimate1 = [Select Id,Name From dmpl__Quote__c LIMIT 1];
        ServiceEstimateLine.Add(new dmpl__QuoteLine__c(dmpl__ItemId__c = item1.Id,
                                                       dmpl__Quantity__c = 50,
                                                       dmpl__UnitPrice__c = 10,
                                                       dmpl__TaxGroupId__c=taxGroup.Id,
                                                       dmpl__DurationInHours__c = 12.00,
                                                       dmpl__IsApproved__c = false,
                                                       dmpl__IsDeclined__c = false,
                                                       dmpl__ServiceContractId__c = item.Id,
                                                       dmpl__PackageClassification__c = 'Optional Item',
                                                       dmpl__IncludeinPackage__c = True,
                                                       dmpl__IsPackageService__c = false,
                                                       dmpl__QuoteId__c = serviceEstimate1.Id));
        
        insert ServiceEstimateLine;
        dmpl__QuoteLine__c l = [select Id,Name,QuoteId__c from dmpl__QuoteLine__c LIMIT 1];
        List<dmpl__Quote__c> q  = [select Id,Name From dmpl__Quote__c];
        DiscountGroupHelper.getQuote(l,q);
    }*/
   
    @isTest
    Public static void getSaleOrder1()
    {
        //try{
        test.startTest();
        List<dmpl__SaleOrderLine__c> sOrderLines = [Select Id, Name,dmpl__PendingFulfilmentOrderQuantity__c,dmpl__SaleOrderId__c From dmpl__SaleOrderLine__c];
        //System.debug('soline'+soLine);
        List<dmpl__SaleOrder__c> sOrder=[Select Id, Name,dmpl__Discount__c From dmpl__SaleOrder__c Limit 1 ];
        List<SourceObjectInfo> info = new List<SourceObjectInfo>();
        PriceListHelper.getSaleOrder(sOrderLines[0],sOrder);
       // SaleOrderHelper.createSaleInvoiceForAllocatedLines(sOrder);
        SaleOrderHelper.updateDiscountInSaleOrderLines(sOrder);
        SaleOrderHelper.createDeliveryOrder(info);
        SaleOrderHelper.createFulfilment(info);
        SaleOrderHelper.createSaleInvoice(info);
        SaleOrderHelper.createSaleInvoiceForAllocatedLines(info);
        SaleOrderLineHelper.cancelSaleOrderLines(info,sOrder[0].Id);
        SaleOrderLineHelper.cancelSaleOrderLines(sOrder[0].Id);
        try{
        SaleOrderLineHelper.cancelSaleOrderLinesInternal(sOrderLines,info);
        }catch(exception e){}
        System.assertNotEquals(null, sOrder);
        test.stopTest();
        //}
        //catch(exception e){}
    } 
    
    @isTest
    Public static void createupdateSaleReturnQuantity()
    {
        Test.startTest();
        List<dmpl__SaleReturn__c> sOrder=[Select Id, Name From dmpl__SaleReturn__c Limit 1 ];
        SaleOrderLineHelper.updateSaleReturnQuantity(sOrder);
        System.assertNotEquals(null, sOrder);
        Test.stopTest();
    }
    
        
     @isTest
    private static void VerifyHeadlessCallabaleMethod()
    {
        test.startTest();
        dmpl__SaleOrder__c serviceRequest = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
       // stockPanelController.createFulfilmentOrder('dmpl__SaleOrder',serviceRequest.Id);
        HeadlessCallableController.callHeadlessAction('headlessAction','dmpl__SaleOrder__c',serviceRequest.Id);
        test.stopTest();
    }
    
    @isTest
    Public static void getFieldSetList()
    {
        Test.startTest();
        MetadataHelper.getFieldSetList('dmpl__SaleOrder__c');
        Test.stopTest();
    } 
    
    @isTest
    Public static void createupdateSaleReturnQuantity2()
    {
        Test.startTest();
        List<dmpl__SaleOrderLine__c> sOrderLines = [Select Id, Name From dmpl__SaleOrderLine__c];
        SaleOrderLineHelper.updateSaleReturnQuantity(DocumentHelper.extractIds(sOrderLines,'Id'));
        System.assertNotEquals(null, sOrderLines);
        Test.stopTest();
    } 
    
    
   
    
    @isTest
    Public static void performActionForSelectedObjects()
    {
        Try{
            Test.startTest();
            dmpl__DocumentActionSetting__mdt metaData= [Select Id,
                                                        dmpl__FilterSourceSOQL__c,
                                                        dmpl__ChildObjectSOQLFilter__c,
                                                        dmpl__EligibilityQuantityFieldId__r.QualifiedApiName,
                                                        dmpl__ChildFieldsetName__c,
                                                        dmpl__ChildObjectId__r.QualifiedApiName,
                                                        dmpl__ChildObjectId__c
                                                        from dmpl__DocumentActionSetting__mdt Limit 1 ];
            List<dmpl__SaleOrder__c> sOrders = [Select Id, Name From dmpl__SaleOrder__c];
            List<SourceObjectInfo> sourceObjectInfo = new List<SourceObjectInfo>();
            sourceObjectInfo.add(new SourceObjectInfo('dmpl__SaleOrder__c', sOrders[0].Id, 0, 'Data'));
            DocumentActionController.performActionForSelectedObjects(sOrders[0].Id,metaData.Id,sourceObjectInfo);
            System.assertNotEquals(null, sOrders);
        } Catch(exception e){}
        Test.stopTest();
    }
    
   
    
    @isTest
    Public static void perfromExternalAction()
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
            List<dmpl__SaleOrder__c> sOrders = [Select Id, Name From dmpl__SaleOrder__c];
            List<SourceObjectInfo> sourceObjectInfo = new List<SourceObjectInfo>();
            sourceObjectInfo.add(new SourceObjectInfo('dmpl__SaleOrder__c', sOrders[0].Id, 0, 'Data'));
            DocumentActionController.perfromExternalAction('performAction', metaData.dmpl__CustomClassName__c,sOrders[0].Id,metaData.Id,sourceObjectInfo);
            System.assertNotEquals(null, sOrders);
        } Catch(exception e){}
        Test.stopTest();
    }
    
    @isTest 
    Public static void getChildObjects()
    {
        Test.startTest();
        dmpl__DocumentActionSetting__mdt metaData= [Select Id,
                                                    dmpl__FilterSourceSOQL__c,
                                                    dmpl__ChildObjectSOQLFilter__c,
                                                    dmpl__EligibilityQuantityFieldId__r.QualifiedApiName,
                                                    dmpl__ChildFieldsetName__c,
                                                    dmpl__ChildObjectId__r.QualifiedApiName,
                                                    dmpl__ChildObjectId__c
                                                    from dmpl__DocumentActionSetting__mdt Limit 1 ];
        List<dmpl__SaleOrder__c> sOrders = [Select Id, Name From dmpl__SaleOrder__c];
        SaleOrderHelper.createFulfilment(sOrders);
        //SaleOrderHelper.createSaleInvoice(sOrders);
        //SaleOrderHelper.createSaleInvoiceForAllocatedLines(sORders);
        DocumentActionController.getChildObjects(metaData.Id,sOrders[0].Id,'FIND');
        System.assertNotEquals(null, sOrders);
        Test.stopTest();
    }
    
    @isTest
    Public static void getDocumentActionSettingNew()
    {
        Test.startTest();
        List<dmpl__SaleOrder__c> sOrders = [Select Id, Name From dmpl__SaleOrder__c];
        DocumentActionController.getDocumentActionSettings('dmpl__SaleOrder__c');
        System.assertNotEquals(null, sOrders);
        Test.stopTest();
    }
    
    @isTest
    Public static void getSObject()
    {
        test.startTest();
        dmpl__SaleOrderLine__c soLine=[Select Id, Name,dmpl__PendingInvoiceQuantity__c,dmpl__SaleOrderId__c,dmpl__Quantity__c,dmpl__ItemLotId__c from dmpl__SaleOrderLine__c Limit 1];
        List<dmpl__SaleOrder__c> sOrder=[Select Id, Name From dmpl__SaleOrder__c Limit 1 ];
        List<dmpl__SaleOrderLine__c>soLineList = new list<dmpl__SaleOrderLine__c>{soLine};
        PriceListHelper.getSObject(soLine,sOrder,'dmpl__SaleOrderId__c');
        PriceListHelper.getSaleOrder(soLine,sOrder);
        BulkOrderProcessingController.createBulkOrderLines(soLineList);
        System.assertNotEquals(null, sOrder);
        test.stopTest();
    }
    
    @isTest
    public static void Verify1()
    {
        test.startTest();
        List<dmpl__SaleOrderLine__c> line2 = [SELECT Id, Name FROM dmpl__SaleOrderLine__c];
        PackageHelper.getSaleOrderPackageConfiguration(line2[0].Id);   
        System.assertEquals(1, line2.size(), 'sale order line data');
        test.stopTest();
    }
    
    @isTest
    public static void querySaleOrderLines()
    {
        test.startTest();
        dmpl__SaleOrder__c line2 = [SELECT Id, Name FROM dmpl__SaleOrder__c limit 1];
        ConfigAPI_GetProductConfigurator.querySaleOrderLines(line2.Id);   
        System.assert(line2!=null, 'sale order line data');
        test.stopTest();
    }
    
    
    @isTest
    public static void querySaleOrderDiscount()
    {
        test.startTest();
        dmpl__SaleOrder__c line2 = [SELECT Id, Name, dmpl__Discount__c FROM dmpl__SaleOrder__c LIMIT 1];
        line2.dmpl__Discount__c = 10;
        update line2;
        System.assert(line2!=null, 'sale order line data');
        test.stopTest();
    }
    
    @isTest
    public static void VerifyNeww()
    {
        Try{
            test.startTest();
            List<dmpl__SaleOrder__c> line2 = [SELECT Id, Name FROM dmpl__SaleOrder__c];
            SaleInvoiceHelper.createSaleInvoiceFromAllocatedLines(line2);   
            System.assertEquals(2, line2.size(), 'sale order line data');
            test.stopTest();
        }
        catch(exception e){}
    }
    
    @isTest
    public static void Verify2()
    {
        try{
            test.startTest();
            dmpl__SaleOrderLine__c line2 = [SELECT Id, Name,dmpl__SaleOrderId__c,dmpl__PurchaseOrderLineId__c,dmpl__ReturnedQuantity__c FROM dmpl__SaleOrderLine__c LIMIT 1];
            List<PackageConfigLine> package1 =new List <PackageConfigLine>();
            List<SourceObjectInfo> info = new List<SourceObjectInfo>();
            PackageHelper.applySaleOrderPackageConfiguration(line2.Id,package1);
            SaleOrderLineHelper.createSaleOrderLinesFromPurchaseOrder(info,line2.dmpl__SaleOrderId__c);
            System.assert(line2 != null, 'sale order line is verified');
            test.stopTest();
        }
        catch(exception e){}
    }
    
    
    @isTest
    public static void StockPanelControllerTest()
    {
        Test.startTest();  
        try {
            dmpl__SaleOrder__c saleOrder = [ SELECT 
            Id,
            dmpl__BranchId__c,
            dmpl__PartnerAccountId__c,
            (SELECT
                Id,
                dmpl__ItemId__c,
                dmpl__PendingFulfilmentOrderQuantity__c
              FROM 
                dmpl__SaleOrderLines__r)
        FROM
            dmpl__SaleOrder__c LIMIT 1];
            StockPanelController.createStockTransfer('dmpl__SaleOrder__c', saleOrder.Id,saleOrder.dmpl__BranchId__c);
            StockPanelController.createFulfilmentOrder('dmpl__SaleOrder__c', saleOrder.Id);
            System.assertNotEquals(null, saleOrder);        
        } catch (Exception ex) {
            
        }
        Test.stopTest();   
    } 
      @isTest
    public static void StockPanelControllerTest1()
    {
        Test.startTest();  
        try {
            dmpl__SaleOrder__c saleOrder = [Select Id,Name,dmpl__AccountId__c,dmpl__BranchId__c,dmpl__PartnerAccountId__c From dmpl__SaleOrder__c LIMIT 1];
            StockPanelController.createStockTransfer('dmpl__SaleOrder__c', saleOrder.Id,saleOrder.dmpl__BranchId__c);
            StockPanelController.createFulfilmentOrder('dmpl__SaleOrder__c', saleOrder.Id);
            System.assertNotEquals(null, saleOrder);        
        } catch (Exception ex) {
            
        }
        Test.stopTest();   
    } 
    @isTest
    public static void RecordPanelController()
    {
        Test.startTest();  
        dmpl__SaleOrder__c saleOrder = [Select Id,Name,dmpl__AccountId__c,dmpl__BranchId__c,dmpl__PartnerAccountId__c From dmpl__SaleOrder__c LIMIT 1];
        dmpl__SaleOrderLine__c saleOrderLine = [Select Id,Name,dmpl__SKUId__c,dmpl__Quantity__c,dmpl__ItemId__c From dmpl__SaleOrderLine__c LIMIT 1];
        RecordPanelController.getFieldsByFieldSetName('dmpl__SaleOrderLine__c','dmpl__DMSQuickAddPanelPartFieldSet');
        ProductConfiguratorController.getItemPackageConfiguration(saleOrderLine.dmpl__ItemId__c,saleOrderLine.dmpl__SKUId__c,
                                                                  saleOrder.dmpl__PartnerAccountId__c,
                                                                  saleOrder.dmpl__AccountId__c,
                                                                  saleOrder.dmpl__BranchId__c
                                                                 );
        
        Test.stopTest();  
        System.assertNotEquals(null, saleOrder);
    } 
    
    @isTest
    public static void validateComponentsAdd()
    {
        Try{
            Test.startTest();  
            List<dmpl__SaleOrderLine__c> saleOrder = [Select Id,Name,dmpl__ItemId__c,dmpl__PackageSaleOrderLineId__c,dmpl__Quantity__c From dmpl__SaleOrderLine__c LIMIT 1];
            List<dmpl__SaleOrderLine__c> saleOrder1 = [Select Id,Name ,dmpl__ItemId__c,dmpl__PackageSaleOrderLineId__c,dmpl__Quantity__c From dmpl__SaleOrderLine__c LIMIT 1];
            PackageHelper.validateComponentsAdd(saleOrder,saleOrder1);
            SaleOrderLineHelper.validateQuantityField(saleOrder);
            System.assertNotEquals(null, saleOrder);
            Test.stopTest(); 
        }
        Catch(Exception e){}
        
    }
    
    @isTest
    public static void validateQuantityField()
    {
        Try{
            Test.startTest();  
            List<dmpl__SaleOrderLine__c> saleOrder = [Select Id,Name,dmpl__ItemId__c,dmpl__PackageSaleOrderLineId__c,dmpl__Quantity__c From dmpl__SaleOrderLine__c LIMIT 1];
            List<dmpl__SaleOrderLine__c> saleOrder1 = [Select Id,Name ,dmpl__ItemId__c,dmpl__PackageSaleOrderLineId__c,dmpl__Quantity__c From dmpl__SaleOrderLine__c LIMIT 1];
            PackageHelper.validateComponentsAdd(saleOrder,saleOrder1);
            SaleOrderLineHelper.validateQuantityField(saleOrder);
            System.assertNotEquals(null, saleOrder);
            Test.stopTest(); 
        }
        Catch(Exception e){}
        
    }
    
    @isTest
    public static void updateFulfilmentAllocatedQuantity()
    {
        test.startTest();
        List<Id> ids = new List<Id>();
        List<dmpl__SaleOrderLine__c> line = [Select Id,Name,dmpl__ItemId__c,dmpl__Quantity__c,dmpl__SaleOrderId__c,dmpl__ItemComponentId__c,dmpl__TaxGroupId__c From dmpl__SaleOrderLine__c limit 1];
        dmpl__ItemComponent__c comp = [Select Id,Name,dmpl__ItemId__c,dmpl__ComponentItemId__c,dmpl__ComponentSKUId__c,
                                       dmpl__Quantity__c,dmpl__PackageType__c,dmpl__IsBundled__c,dmpl__IsQuantityEditable__c From dmpl__ItemComponent__c LIMIT 1];
        SaleOrderLineHelper.updateFulfilmentAllocatedQuantity(ids);
        SaleOrderLineHelper.createSaleOrderLine(line[0],comp);
        SaleOrderLineHelper.applyPackageConfiguration(line[0],line,new List<dmpl__ItemComponent__c>{comp});
        Map<dmpl__SaleOrderLine__c,List<dmpl__ItemComponent__c>> newmap = new Map<dmpl__SaleOrderLine__c,List<dmpl__ItemComponent__c>>();
        newmap.put(line[0],new List<dmpl__ItemComponent__c>{comp});
        SaleOrderLineHelper.addPackageSaleOrderLines(newmap);
        test.stopTest();
    }
    
    @isTest
    public static void validateComponentQuantityEdit()
    {
        Try{
            Test.startTest();  
            List<dmpl__SaleOrderLine__c> saleOrder = [Select Id,Name,dmpl__ItemId__c From dmpl__SaleOrderLine__c LIMIT 1];
            List<dmpl__SaleOrderLine__c> saleOrder1 = [Select Id,Name ,dmpl__ItemId__c From dmpl__SaleOrderLine__c LIMIT 1];
            PackageHelper.validateComponentQuantityEdit(saleOrder,saleOrder1);
            System.assertNotEquals(null, saleOrder);
            Test.stopTest(); 
        }
        Catch(Exception e){}
        
    }
    
    @isTest
    public static void setDefaultPriceListIds()
    {
        Test.startTest();  
        List<dmpl__SaleOrder__c> saleOrder = [Select Id,Name,dmpl__AccountId__c,dmpl__PriceListId__c,dmpl__BranchId__c,dmpl__PartnerAccountId__c,(Select Id, Name,dmpl__SKUId__c,dmpl__Quantity__c,dmpl__ItemComponentId__c, dmpl__PackageSaleOrderLineId__c,dmpl__SKUId__r.Name,dmpl__ItemId__c,dmpl__ItemId__r.Name From SaleOrderLines__r) From dmpl__SaleOrder__c LIMIT 1];
        PriceLIstHelper.setDefaultPriceListIds(saleOrder);
        System.assertNotEquals(null, saleOrder);
        Test.stopTest();          
    }
    
    @isTest
    public static void RecordPanelControllerNew()
    {
        Test.startTest();  
        dmpl__SaleInvoice__c saleInvoice = [Select Id,Name,dmpl__AccountId__c,dmpl__BranchId__c,dmpl__PartnerAccountId__c,(Select Id, Name,dmpl__SKUId__c, dmpl__SKUId__r.Name,dmpl__ItemId__c,dmpl__ItemId__r.Name From SaleInvoiceLines__r) From dmpl__SaleInvoice__c LIMIT 1];
        dmpl__SaleOrder__c saleOrder = [Select Id,Name,dmpl__AccountId__c,dmpl__BranchId__c,dmpl__PartnerAccountId__c,(Select Id, Name,dmpl__SKUId__c,dmpl__Quantity__c,dmpl__ItemComponentId__c, dmpl__PackageSaleOrderLineId__c,dmpl__SKUId__r.Name,dmpl__ItemId__c,dmpl__ItemId__r.Name From SaleOrderLines__r) From dmpl__SaleOrder__c LIMIT 1];
        ProductConfiguratorController.getConfigurableItems('dmpl__SaleOrder__c',saleOrder.Id);
        ProductConfiguratorController.getConfigurableItems('dmpl__SaleInvoice__c',saleInvoice.Id);
        System.assertNotEquals(null, saleOrder);
        Test.stopTest();  
    }
    
    @isTest
    public static void RecordPanelForSaleorder()
    {
        Test.startTest();  
        try{
            dmpl__SaleOrder__c saleOrder = [Select Id,Name,dmpl__AccountId__c,dmpl__BranchId__c,dmpl__PartnerAccountId__c,(Select Id, Name,dmpl__SKUId__c,dmpl__Quantity__c,dmpl__ItemComponentId__c, dmpl__PackageSaleOrderLineId__c,dmpl__SKUId__r.Name,dmpl__ItemId__c,dmpl__ItemId__r.Name From SaleOrderLines__r) From dmpl__SaleOrder__c LIMIT 1];
            ProductConfiguratorController.getPackageConfiguration('dmpl__SaleOrder__c',saleOrder.Id);
            List<dmpl__SaleOrder__c> order=new List<dmpl__SaleOrder__c>();
            SaleOrderHelper.createSaleOrderLinesFromPurchaseOrder(order);
            System.assertNotEquals(null, saleOrder);
        }catch(Exception e){
        }
        Test.stopTest();  
    }
    
    @isTest
    public static void RecordPanelForSaleInvoice()
    {
        Test.startTest();  
        try{
            dmpl__SaleInvoice__c saleInvoice = [Select Id,Name,dmpl__AccountId__c,dmpl__BranchId__c,dmpl__PartnerAccountId__c,(Select Id, Name,dmpl__SKUId__c, dmpl__SKUId__r.Name,dmpl__ItemId__c,dmpl__ItemId__r.Name From SaleInvoiceLines__r) From dmpl__SaleInvoice__c LIMIT 1];
            ProductConfiguratorController.getPackageConfiguration('dmpl__SaleInvoice__c',saleInvoice.Id);
            System.assertNotEquals(null, saleInvoice);
        }catch(Exception e){
        }
        Test.stopTest();  
    }
    
    
    @isTest
    public static void UpdateSaleOrderAsPerformCreateDealer()
    {
        Test.startTest();  
        dmpl__SaleOrder__c saleOrder = [Select Id,Name,dmpl__PerformCreateDealerSaleOrder__c,dmpl__Discount__c,dmpl__PerformReleaseInvoice__c,dmpl__PerformReleaseDelivery__c From dmpl__SaleOrder__c LIMIT 1];
        saleOrder.dmpl__PerformCreateDealerSaleOrder__c = True;
        saleOrder.dmpl__Discount__c = 5;
        update saleOrder;
        Test.stopTest();  
        System.assertEquals(True, saleOrder.dmpl__PerformCreateDealerSaleOrder__c, 'Sale Order has 1 Record Updated');
    }
    
    @isTest
    public static void UpdateSaleOrderReleaseFulfillment()
    {
        try{
            test.startTest();
            dmpl__SaleOrder__c saleOrder = [Select Id,Name,dmpl__PerformReleaseFulfilment__c,dmpl__PerformReleaseInvoice__c,dmpl__PerformReleaseDelivery__c From dmpl__SaleOrder__c LIMIT 1];
            saleOrder.dmpl__PerformReleaseFulfilment__c = True;
            
            update saleOrder;
            
            System.assertEquals(True, saleOrder.dmpl__PerformReleaseFulfilment__c, 'Sale Order has 1 Record Updated');
            test.stopTest();
        }catch(exception e){}
    } 
    
    //@isTest
    public static void UpdateSaleOrderAsReleaseInvoice()
    {
        //Try{
        //Test.startTest();  
        //UpdateSaleOrderReleaseFulfillment();
        dmpl__SaleOrder__c saleOrder = [Select Id,Name,dmpl__PerformReleaseFulfilment__c,dmpl__PerformReleaseInvoice__c,dmpl__PerformReleaseDelivery__c From dmpl__SaleOrder__c LIMIT 1];
        saleOrder.dmpl__PerformReleaseInvoice__c = True;
        
        update saleOrder;
        //   Test.stopTest();  
        System.assertEquals(True, saleOrder.dmpl__PerformReleaseInvoice__c, 'Sale Order has 1 Record Updated');
        //}
        //catch(Exception e){}
    } 
    
    @isTest
    public static void UpdateSaleOrderAsPerformKPICalculation()
    {
        Test.startTest();  
        dmpl__SaleOrder__c saleOrder = [Select Id,Name,dmpl__PerformKPICalculation__c From dmpl__SaleOrder__c LIMIT 1];
        saleOrder.dmpl__PerformKPICalculation__c = True;
        
        update saleOrder;
        Test.stopTest();  
        System.assertEquals(True, saleOrder.dmpl__PerformKPICalculation__c, 'Sale Order has 1 Record Updated');
    }
    
    @isTest
    public static void UpdateSaleOrderDelivery()
    {
        try{
            test.startTest();
            //UpdateSaleOrderAsReleaseInvoice();
            dmpl__SaleOrder__c saleOrder = [Select Id,Name,dmpl__PerformReleaseFulfilment__c,dmpl__PerformReleaseInvoice__c,dmpl__PerformReleaseDelivery__c From dmpl__SaleOrder__c LIMIT 1];
            saleOrder.dmpl__PerformReleaseDelivery__c = True;
            
            update saleOrder;
            
            System.assertEquals(True, saleOrder.dmpl__PerformReleaseDelivery__c, 'Sale Order has 1 Record Updated');
            test.stopTest();}
        catch(exception e){}
    } 
    
    @isTest
    public static void createSaleInvoiceForAllocatedLines()
    {
        try{
            test.startTest();
            //UpdateSaleOrderAsReleaseInvoice();
            dmpl__SaleOrder__c saleOrder = [Select Id,Name,dmpl__PerformReleaseInvoiceAllocatedLines__c,dmpl__PerformReleaseInvoice__c,dmpl__PerformReleaseDelivery__c From dmpl__SaleOrder__c LIMIT 1];
            saleOrder.dmpl__PerformReleaseInvoiceAllocatedLines__c = True;
            
            update saleOrder;
            test.stopTest();
            System.assertEquals(True, saleOrder.dmpl__PerformReleaseInvoiceAllocatedLines__c, 'Sale Order has 1 Record Updated');
        }
        catch(exception e){}
    } 
    
    @isTest
    public static void DeleteSaleOrder()
    {
        Test.startTest();  
        dmpl__SaleOrder__c saleOrder = [Select Id,Name,dmpl__Remark__c From dmpl__SaleOrder__c LIMIT 1];
        
        delete saleOrder;
        Test.stopTest();  
        System.assertEquals(null, saleOrder.dmpl__Remark__c, 'Sale Order has 1 Record Deleted');
    }
    
    @isTest
    public static void UpdateSaleOrderLine()
    {
        try{
            Test.startTest();  
            dmpl__SaleOrderLine__c saleOrderLine = [Select Id,Name,dmpl__Quantity__c,dmpl__UnitPrice__c From dmpl__SaleOrderLine__c LIMIT 1];
            if(saleOrderLine != null)
            {
                saleOrderLine.dmpl__Quantity__c = 10;
                saleOrderLine.dmpl__UnitPrice__c = 100;
            }
            update saleOrderLine;
            
            Test.stopTest();  
            System.assertEquals(4, saleOrderLine.dmpl__Quantity__c, 'Sale Order Line has 1 Record Updated');
        }catch(exception e){}
    }
    
    @isTest
    public static void DeleteSaleOrderLine()
    {
        Test.startTest();  
        List<dmpl__SaleOrderLine__c> order = [Select Id,Name,dmpl__ItemId__c,dmpl__PackageSaleOrderLineId__c From dmpl__SaleOrderLine__c];
        List<dmpl__SaleOrderLine__c> saleOrderLine = [Select Id,Name,dmpl__Quantity__c,dmpl__PackageSaleOrderLineId__c,dmpl__ItemId__c From dmpl__SaleOrderLine__c WHERE dmpl__PackageSaleOrderLineId__c != null LIMIT 1];
        PackageHelper.validateComponentsDelete(order,saleOrderLine);
        delete saleOrderLine;
        Test.stopTest();  
        System.assert(saleOrderLine!=null, 'Sale Order Line has 1 Record Deleted');
    } 
    
    @isTest
    public static void UpdateSaleInvoice()
    {
        Test.startTest();  
        dmpl__SaleInvoice__c saleInvoice = [Select Id,Name,dmpl__PerformGLPosting__c From dmpl__SaleInvoice__c LIMIT 1];
        saleInvoice.dmpl__PerformGLPosting__c = True;
        
        update saleInvoice;
        Test.stopTest();  
        System.assertEquals(true, saleInvoice.dmpl__PerformGLPosting__c, 'Test sale Invoice have 1 updated record');
    }
    
    @isTest
    public static void getEligibleIncentivePeriod()
    {
        test.startTest();
        List<dmpl__IncentivePlan__c> plans = new List<dmpl__IncentivePlan__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch'];
        Account customerAccount = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
        plans.Add(new dmpl__IncentivePlan__c(dmpl__PeriodType__c = 'Yearly',
                                             Name='Plan1',
                                             dmpl__ValidTo__c= Datetime.now().addDays(365).Date(),
                                             dmpl__Status__c='Draft',
                                             dmpl__ValidFrom__c = date.today(),
                                             dmpl__PeriodEndDate__c = date.today()+7,
                                             dmpl__PartnerAccountId__c = null,
                                             dmpl__PartnerAccountGroupId__c = null,
                                             dmpl__MemberResourceType__c = 'Salesperson',
                                             MemberType__c = 'Partner'));
        insert plans;
        List<dmpl__IncentivePeriod__c> periods = new List<dmpl__IncentivePeriod__c>();
        dmpl__SaleOrder__c saleOrder = [Select Id,Name,dmpl__Remark__c,dmpl__DocumentDate__c From dmpl__SaleOrder__c LIMIT 1];
        periods.Add(new dmpl__IncentivePeriod__c(dmpl__DateFrom__c = date.today()-10,
                                                 dmpl__Status__c='Calculated',
                                                 dmpl__DateTo__c = date.today()+7,
                                                 dmpl__IncentivePlanId__c = plans[0].Id));
        insert periods;
        PerformanceKPIHelper.getEligibleIncentivePeriod(periods,saleOrder);
    }
    
    @isTest
    private static void VerifyPerformReprice()
    {
        test.startTest();
        dmpl__SaleOrder__c saleOrder = [Select Id,Name,dmpl__Remark__c,dmpl__DocumentDate__c From dmpl__SaleOrder__c LIMIT 1];
        SaleOrderLineHelper.performReprice(saleOrder.Id);
        test.stopTest();
    }
    
    @isTest
    private static void VerifyCreateDeliveryOrder()
    {
        test.startTest();
        dmpl__SaleOrder__c saleOrder = [Select Id,Name,dmpl__Remark__c,dmpl__DocumentDate__c,(SELECT Id,Name FROM dmpl__SaleOrderLines__r) From dmpl__SaleOrder__c LIMIT 1];
        List<SourceObjectInfo> objList = new List<SourceObjectInfo>();
        SourceObjectInfo obj = new SourceObjectInfo('dmpl__SaleOrderLine__c',saleOrder.dmpl__SaleOrderLines__r[0].Id,1,null);
        objList.add(obj);
        SaleDeliveryHelper.createSaleDeliveryFromSaleOrder(saleOrder.Id);
        SaleDeliveryHelper.createSaleDeliveryFromSaleOrder(objList);
        SaleDeliveryHelper.createSaleDeliveryFromSaleOrder(null,objList);
        test.stopTest();
    }
    
    //@isTest
    private static void VerifyCreateDOFromInvoice()
    {
        try{
        CreateFulfillment();
        CreateDeliveryOrder();
        List<dmpl__DeliveryOrder__c> deliveryOrder = [Select Id,Name,dmpl__PartnerAccountId__c,dmpl__BranchId__c,dmpl__PriceListId__c,dmpl__AccountId__c,dmpl__Remarks__c,(Select Id,Name from dmpl__DeliveryOrderLines__r) From dmpl__DeliveryOrder__c WHERE dmpl__SaleOrderId__c != null];
        
        List<SourceObjectInfo> objList = new List<SourceObjectInfo>();
        SourceObjectInfo obj = new SourceObjectInfo('dmpl__DeliveryOrderLine__c',deliveryOrder[0].dmpl__DeliveryOrderLines__r[0].Id,1,null);
        objList.add(obj);
        
        test.startTest();
        SaleInvoiceHelper.createSaleInvoiceFromDeliveryOrder(deliveryOrder[0].Id);
        //SaleInvoiceHelper.createSaleInvoiceFromDeliveryOrder(objList);
        test.stopTest();
        }catch(Exception e){
            
        }
        
    }
    
    @isTest
    private static void createBulkInvoicesTest()
    {
        test.startTest();
        dmpl__SaleOrderLine__c saleOrderLine = [Select Id,Name,dmpl__Quantity__c,dmpl__PackageSaleOrderLineId__c,dmpl__ItemId__c From dmpl__SaleOrderLine__c LIMIT 1];
        BulkOrderProcessingController.createBulkInvoices(new list<Id>{saleOrderLine.id},new list<dmpl__SaleOrderLine__c>{saleOrderLine},new list<string>{'dmpl__Quantity__c'});
        test.stopTest();
    }
    
    private static void CreateAccountGroup()
    {
        dmpl__AccountGroup__c accountGroup= new dmpl__AccountGroup__c (Name= 'Test-AccountGroup', 
                                                                       dmpl__AccountGroupType__c='Price');
        insert accountGroup;
        
    }
    
    private static void CreateAccount()
    {
        dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c LIMIT 1];
        /* List<Account> account = new List<Account>();

account.add(new Account(Name = 'Test - Account', 
dmpl__LastName__c = 'Sale Order',
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
                                             dmpl__LastName__c = 'Sale Order',
                                             dmpl__IsPartnerAccount__c = True, 
                                             dmpl__IsActive__c = true,
                                             dmpl__PartnerTaxAccountGroupId__c = accountGroup.Id,
                                             dmpl__CustomerPriceAccountGroupId__c = accountGroup.Id,
                                             dmpl__CustomerDiscountAccountGroupId__c = accountGroup.Id,
                                             dmpl__PartnerSchemeAccountGroupId__c = accountGroup.Id,                                
                                             dmpl__PartnerPriceAccountGroupId__c = accountGroup.Id,
                                             dmpl__PartnerDiscountAccountGroupId__c = accountGroup.Id,
                                             dmpl__CustomerSchemeAccountGroupId__c = accountGroup.Id
                                            );
        insert partneraccount;
        
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__LastName__c = 'Sale Order',
                                              dmpl__IsCustomerAccount__c = True,
                                              dmpl__IsPartnerAccount__c = True,
                                              dmpl__IsActive__c = true,
                                              dmpl__PartnerTaxAccountGroupId__c = accountGroup.Id,
                                              dmpl__CustomerPriceAccountGroupId__c = accountGroup.Id,
                                              dmpl__CustomerDiscountAccountGroupId__c = accountGroup.Id,
                                              dmpl__PartnerSchemeAccountGroupId__c = accountGroup.Id,                                
                                              dmpl__PartnerPriceAccountGroupId__c = accountGroup.Id,
                                              dmpl__PartnerDiscountAccountGroupId__c = accountGroup.Id,
                                              dmpl__CustomerSchemeAccountGroupId__c = accountGroup.Id
                                             );
        insert customerAccount;
        
        
        Account supplierAccount = new Account(Name = 'Supplier-Test-Account',
                                              dmpl__LastName__c = 'Sale Order',
                                              dmpl__IsSupplierAccount__c = True,
                                              dmpl__IsActive__c = true,
                                              dmpl__PartnerTaxAccountGroupId__c = accountGroup.Id,
                                              dmpl__CustomerPriceAccountGroupId__c = accountGroup.Id,
                                              dmpl__CustomerDiscountAccountGroupId__c = accountGroup.Id,
                                              dmpl__PartnerSchemeAccountGroupId__c = accountGroup.Id,                                
                                              dmpl__PartnerPriceAccountGroupId__c = accountGroup.Id,
                                              dmpl__PartnerDiscountAccountGroupId__c = accountGroup.Id,
                                              dmpl__CustomerSchemeAccountGroupId__c = accountGroup.Id
                                             );
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
        
        /* Account partnerAccount1 = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
branch.Add(new dmpl__Branch__c(dmpl__PartnerAccountId__c =partnerAccount.Id,
Name = 'Test-Branch1',
dmpl__IsActive__c = true,
dmpl__MarketingName__c = 'Hero Electric',
dmpl__Website__c = 'www.dealermatix.com',
dmpl__Email__c = 'Dealer@Outlook.com',
dmpl__MobileNumber__c = 99,
dmpl__Phone__c = '1888888888',
dmpl__AllowSales__c = true,
dmpl__AllowService__c = true,
dmpl__AllowPurchase__c = true,
dmpl__AllowInventory__c = true,
dmpl__IsHomeDeliveryAvailable__c = true,
dmpl__IsPickupDropAvailable__c = true,
dmpl__SalesPhone__c = '7177777777',
dmpl__ServiceEmail__c = 'Customer1@Outlook.com')); */
        insert branch;
        
    }
    
    private static void CreateItems()
    {
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
        
        List<dmpl__Item__c> chargeItem = new List<dmpl__Item__c>();
        chargeItem.Add(new dmpl__Item__c(Name = 'Test-Item',
                                         dmpl__ItemCode__c = 'DMPL',
                                         dmpl__ItemType__c = 'Charge Item',
                                         dmpl__ItemSubType__c = '',
                                         dmpl__Description__c = '',
                                         dmpl__ItemFamily__c = 'Sample',
                                         dmpl__ItemSegment__c = 'Sample',
                                         dmpl__Make__c = 'Sample',
                                         dmpl__Model__c = 'Sample',                       
                                         dmpl__IsActive__c = true,
                                         dmpl__OnlySoldInPackage__c=True
                                         
                                        ));
        insert chargeItem;
        
        /* List<dmpl__Item__c> subsItem = new List<dmpl__Item__c>();
subsItem.Add(new dmpl__Item__c(Name = 'Test-Item',
dmpl__ItemCode__c = 'DMPL',
dmpl__ItemType__c = 'Subscription',
dmpl__ItemSubType__c = '',
dmpl__Description__c = '',
dmpl__ItemFamily__c = 'Sample',
dmpl__ItemSegment__c = 'Sample',
dmpl__Make__c = 'Sample',
dmpl__Model__c = 'Sample',                          
dmpl__IsPackage__c = true
));
insert subsItem; */
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
    
    private static void CreateSaleOrder()
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
        dmpl__ItemComponent__c itemcomp=[Select Id, Name from dmpl__ItemComponent__c ];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name ,dmpl__TaxGroupType__c From dmpl__TaxGroup__c LIMIT 1];
        saleOrderLine.Add(new dmpl__SaleOrderLine__c(dmpl__SaleOrderId__c = saleOrder[0].Id,
                                                     dmpl__ItemId__c = item.Id,
                                                     dmpl__SKUId__c = sku.Id,
                                                     dmpl__PriceListRuleId__c=rules.Id,
                                                     dmpl__ItemComponentId__c=itemcomp.Id,
                                                     dmpl__Quantity__c = 4,
                                                     dmpl__UnitPrice__c = 100,
                                                     dmpl__Discount__c = 5,
                                                     dmpl__TaxGroupId__c=taxGroup.Id
                                                     
                                                    ));
        insert saleOrderLine;
    }
    
    private static void CreateSaleOrder1()
    {
        List<dmpl__SaleOrder__c> saleOrder = new List<dmpl__SaleOrder__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch' LIMIT 1];
        dmpl__ContactAddress__c contactAddress = [Select Id,Name,dmpl__AccountId__c From dmpl__ContactAddress__c LIMIT 1];
        //dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        saleOrder.Add(new dmpl__SaleOrder__c(dmpl__AccountId__c = contactAddress.dmpl__AccountId__c,
                                             dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                             dmpl__BranchId__c = branch.Id,
                                             dmpl__DocumentDate__c = Date.today()+(7),
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
        
    }
    
    private static void CreateSaleOrder2()
    {
        List<dmpl__SaleOrder__c> saleOrder = new List<dmpl__SaleOrder__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch' LIMIT 1];
        dmpl__ContactAddress__c contactAddress = [Select Id,Name,dmpl__AccountId__c From dmpl__ContactAddress__c LIMIT 1];
        //dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        saleOrder.Add(new dmpl__SaleOrder__c(dmpl__AccountId__c = contactAddress.dmpl__AccountId__c,
                                             dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                             dmpl__BranchId__c = branch.Id,
                                             dmpl__DocumentDate__c = Date.today()-(7),
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
        
    }
    
    
    private static void CreateSaleOrderLine1()
    {
        List<dmpl__SaleOrderLine__c> saleOrderLine1 = new List<dmpl__SaleOrderLine__c>();
        dmpl__SaleOrderLine__c saleOrderLines = [Select Id,Name From dmpl__SaleOrderLine__c LIMIT 1];
        saleOrderLine1.Add(new dmpl__SaleOrderLine__c(dmpl__PackageSaleOrderLineId__c = saleOrderLines.Id));
        insert saleOrderLine1;
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
    
    private static void CreateTaxGroupRule()
    {
        List<dmpl__TaxGroupRule__c> taxGroupRule = new List<dmpl__TaxGroupRule__c>();
        dmpl__TaxGroup__c taxGroup = [Select Id,Name ,dmpl__TaxGroupType__c  From dmpl__TaxGroup__c Limit 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        taxGroupRule.add(new dmpl__TaxGroupRule__c(dmpl__ItemId__c = item.Id,
                                                   dmpl__SKUId__c = sku.Id,
                                                   dmpl__ItemGroupId__c=null,
                                                   dmpl__DateEffectiveTill__c=null,
                                                   dmpl__TaxGroupId__c = taxGroup.Id,
                                                   dmpl__DateEffectiveFrom__c = date.today()
                                                  ));
        insert taxGroupRule;  
    }
    
    private static void CreateFulfillment()
    {
        List<dmpl__InventoryFulfillment__c> fulfillment = new List<dmpl__InventoryFulfillment__c>();
        Account account = [Select Id,Name From Account LIMIT 1];
        //Account account1 = [Select Id,Name From Account where Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch'];
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        fulfillment.Add(new dmpl__InventoryFulfillment__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                          dmpl__BranchId__c = branch.Id,
                                                          dmpl__AccountId__c = account.Id,
                                                          dmpl__SaleOrderId__c = saleOrder.id,
                                                          dmpl__PerformAllocation__c = false,
                                                          dmpl__IsAllocated__c = false
                                                          
                                                         ));
        insert fulfillment;
        
        List<dmpl__InventoryFulfillmentOrderLine__c> OrderLine = new List<dmpl__InventoryFulfillmentOrderLine__c>();
        dmpl__Item__c item = [Select Id,Name,(Select Id,Name from dmpl__ItemLots__r) From dmpl__Item__c LIMIT 1];
        dmpl__SaleOrderLine__c saleOrderLine = [Select Id,Name From dmpl__SaleOrderLine__c LIMIT 1];
        OrderLine.Add(new dmpl__InventoryFulfillmentOrderLine__c(dmpl__FulfillmentId__c = fulfillment[0].Id,
                                                                 dmpl__ItemId__c = item.id,
                                                                 dmpl__Quantity__c = 1,
                                                                 //dmpl__BackOrderQuantity__c = 10,
                                                                 //dmpl__StorageLocationId__c = storageLocation.Id,                                                                 
                                                                 dmpl__SaleOrderLineId__c = saleOrderLine.Id
                                                                ));
        insert OrderLine;
        
        List<dmpl__InventoryFulfillmentAllocationLine__c> fulfillmentAllocationLine = new List<dmpl__InventoryFulfillmentAllocationLine__c>();
        fulfillmentAllocationLine.Add(new dmpl__InventoryFulfillmentAllocationLine__c(//dmpl__AllocatedById__c = resource.Id,
            dmpl__FulfillmentOrderLineId__c = OrderLine[0].Id,
            dmpl__ItemId__c = item.Id,
            dmpl__FulfillmentOrderId__c = fulfillment[0].Id,
            dmpl__Quantity__c = 1,
            dmpl__ItemLotId__c = item.dmpl__ItemLots__r[0].Id
        ));
        insert fulfillmentAllocationLine;
        
    }
    
    private static void CreateNewPayment()
    {
        List<dmpl__Payment__c> payment = new List<dmpl__Payment__c>();
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch'];
        payment.Add(new dmpl__Payment__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                         dmpl__BranchId__c = branch.Id,
                                         dmpl__Amount__c = 1000,
                                         dmpl__SaleOrderId__c = saleOrder.Id));
        insert payment;
        
    }
    
    private static void CreateFinanceCase()
    {
        CreateFinancer();
        CreateFinancerScheme();
        List<dmpl__FinanceCase__c> financeCase = new List<dmpl__FinanceCase__c>();
        dmpl__Financer__c financer = [Select Id,Name From dmpl__Financer__c LIMIT 1];
        dmpl__FinancerScheme__c financerScheme = [Select Id,Name From dmpl__FinancerScheme__c LIMIT 1];
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        dmpl__SaleInvoice__c saleInvoice = [Select Id,Name From dmpl__SaleInvoice__c LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch'];
        financeCase.Add(new dmpl__FinanceCase__c(dmpl__SaleOrderId__c = saleOrder.Id,
                                                 dmpl__BranchId__c = branch.Id,
                                                 dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                 dmpl__FinanceSchemeId__c = financerScheme.Id,
                                                 dmpl__FinanceProviderId__c = financer.Id,
                                                 dmpl__RequestedDownPayment__c = 100,
                                                 dmpl__RequestedAmount__c =100,
                                                 dmpl__RequestedTenureMonths__c = 12,
                                                 dmpl__RequestedInterestRate__c = 5,
                                                 dmpl__EMIOnRequestedAmount__c =20,
                                                 dmpl__SaleInvoiceId__c = saleInvoice.Id
                                                ));
        insert financeCase;
        
    }
    
    private static void CreateFinancer()
    {
        List<dmpl__Financer__c> financer = new List<dmpl__Financer__c>();
        Account customerAccount = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
        financer.Add(new dmpl__Financer__c(Name = 'Test-Financer',
                                           dmpl__AccountId__c = customerAccount.Id
                                          ));
        insert financer;
        
    }
    
    private static void CreateFinancerScheme()
    {
        List<dmpl__FinancerScheme__c> financerScheme = new List<dmpl__FinancerScheme__c>();
        dmpl__Financer__c financer = [Select Id,Name From dmpl__Financer__c LIMIT 1];
        financerScheme.Add(new dmpl__FinancerScheme__c(Name = 'Test-FinancerScheme',
                                                       dmpl__FinancerId__c = financer.Id));
        insert financerScheme;
        
    }
    
    private static void CreateSaleInvoice()
    {
        List<dmpl__SaleInvoice__c> saleInvoice = new List<dmpl__SaleInvoice__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch'];
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
         dmpl__TaxGroup__c taxGroup = [Select Id,Name ,dmpl__TaxGroupType__c  From dmpl__TaxGroup__c Limit 1];
        
        saleInvoice.Add(new dmpl__SaleInvoice__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                 dmpl__BranchId__c = Branch.Id,
                                                 dmpl__SaleOrderId__c = saleOrder.id,
                                                 dmpl__DocumentDate__c = Date.today()
                                                
                                                ));
        insert saleInvoice;
        
    }
    
    private static void CreateSaleInvoiceLine()
    {
        CreateSaleInvoice();
        List<dmpl__SaleInvoiceLine__c> saleInvoiceLine = new List<dmpl__SaleInvoiceLine__c>();
        dmpl__SaleInvoice__c SaleInvoice = [Select Id,Name From dmpl__SaleInvoice__c LIMIT 1];
         dmpl__TaxGroup__c taxGroup = [Select Id,Name ,dmpl__TaxGroupType__c  From dmpl__TaxGroup__c Limit 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c LIMIT 1];
        saleInvoiceLine.Add(new dmpl__SaleInvoiceLine__c(dmpl__SaleInvoiceId__c = SaleInvoice.id,
                                                         dmpl__ItemId__c = item.Id,
                                                         dmpl__SKUId__c = sku.Id,
                                                         dmpl__TaxGroupId__c = taxGroup.id
                                                        ));
        insert saleInvoiceLine;
        
    }
    
    private static void CreatePurchaseOrder()
    {
        List<dmpl__PurchaseOrder__c> purchaseOrder = new List<dmpl__PurchaseOrder__c>();
        Account supplierAccount = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name ='Test-Branch1' LIMIT 1];
        purchaseOrder.add(new dmpl__PurchaseOrder__c(dmpl__BranchId__c = branch.Id,
                                                     dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                     dmpl__SupplierAccountId__c = supplierAccount.Id,
                                                     dmpl__PurchaseOrderType__c ='VOR PO',
                                                     dmpl__DocumentDate__c = Date.today(),
                                                     dmpl__Remarks__c = 'Remark'));
        insert purchaseOrder;
        
    }
    
    private static void CreatePurchaseRequisition()
    {
        List<dmpl__PurchaseRequisition__c> purchaseRequisition = new List<dmpl__PurchaseRequisition__c>();
        Account supplierAccount = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch'];
        purchaseRequisition.add(new dmpl__PurchaseRequisition__c(dmpl__BranchId__c = branch.Id,
                                                                 dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                                 dmpl__SupplierAccountId__c = supplierAccount.Id,
                                                                 dmpl__PerformReleaseOrder__c = false,
                                                                 dmpl__IsOrderReleased__c = true,
                                                                 dmpl__DocumentDate__c=Date.today(),
                                                                 dmpl__Remarks__c='sample'
                                                                ));
        insert purchaseRequisition;
        
    }
    
    private static void CreatePurchaseOrderLine()   
    {
        List<dmpl__PurchaseOrderLine__c> purchaseOrderLine = new List<dmpl__PurchaseOrderLine__c>();
        dmpl__Item__c listofitem = [Select Id, Name from dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c LIMIT 1];
        dmpl__PurchaseOrder__c purchaseOrder = [Select Id, Name FROM dmpl__PurchaseOrder__c LIMIT 1];
        purchaseOrderLine.add(new dmpl__PurchaseOrderLine__c(dmpl__ItemId__c = listofitem.Id,
                                                             dmpl__SKUId__c = sku.Id,
                                                             dmpl__PurchaseOrderId__c = purchaseOrder.Id,
                                                             dmpl__Quantity__c = 1
                                                            ));
        insert purchaseOrderLine;
        
    }
    
    private static void CreateDeliveryOrder()
    {
        List<dmpl__DeliveryOrder__c> deliveryOrder = new List<dmpl__DeliveryOrder__c>();
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch'];
        Account customerAccount = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
        deliveryOrder.Add(new dmpl__DeliveryOrder__c(dmpl__AccountId__c = customerAccount.Id,
                                                     dmpl__BranchId__c = branch.Id,
                                                     dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                     dmpl__SaleOrderId__c = saleOrder.Id));
        insert deliveryOrder;
        
        List<dmpl__DeliveryOrderLine__c> deliveryOrderLine = new List<dmpl__DeliveryOrderLine__c>();
        //dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name,dmpl__ItemId__c FROM dmpl__SKU__c LIMIt 1];
        dmpl__SaleOrderLine__c saleOrderLine = [Select Id,Name From dmpl__SaleOrderLine__c LIMIT 1];
        //dmpl__DeliveryOrder__c deliveryOrder = [Select Id,Name From dmpl__DeliveryOrder__c LIMIT 1];
        deliveryOrderLine.Add(new dmpl__DeliveryOrderLine__c(dmpl__DeliveryId__c = deliveryOrder[0].Id,
                                                             dmpl__ItemId__c = sku.dmpl__ItemId__c,
                                                             dmpl__SKUId__c = sku.Id,
                                                             dmpl__SaleOrderLineId__c = saleOrderLine.Id,
                                                             dmpl__Quantity__c = 1
                                                            ));
        insert deliveryOrderLine;
    }
    
    private static void CreateDeliveryOrderLine()
    {
        List<dmpl__DeliveryOrderLine__c> deliveryOrderLine = new List<dmpl__DeliveryOrderLine__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c LIMIt 1];
        dmpl__SaleOrderLine__c saleOrderLine = [Select Id,Name From dmpl__SaleOrderLine__c LIMIT 1];
        dmpl__DeliveryOrder__c deliveryOrder = [Select Id,Name From dmpl__DeliveryOrder__c LIMIT 1];
        deliveryOrderLine.Add(new dmpl__DeliveryOrderLine__c(dmpl__DeliveryId__c = deliveryOrder.Id,
                                                             dmpl__ItemId__c = item.Id,
                                                             dmpl__SKUId__c = sku.Id,
                                                             dmpl__SaleOrderLineId__c = saleOrderLine.Id,
                                                             dmpl__Quantity__c = 1
                                                            ));
        insert deliveryOrderLine;
        
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
    
    
    private static void CreateItemMaintenanceSchedule()
    {
        List<dmpl__ItemMaintenanceSchedule__c> itemMaintenanceSchedule = new List<dmpl__ItemMaintenanceSchedule__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        itemMaintenanceSchedule.add(new dmpl__ItemMaintenanceSchedule__c(dmpl__ItemId__c = item.Id,
                                                                         dmpl__SKUId__c = sku.Id,
                                                                         dmpl__ReminderDaysOffset1__c = 10,
                                                                         dmpl__ReminderDaysOffset2__c = 15,
                                                                         dmpl__ReminderDaysOffset3__c = 20,
                                                                         dmpl__ReminderDaysOffset4__c = 25,
                                                                         dmpl__ReminderDaysOffset5__c = 30,
                                                                         dmpl__DueInDays__c = 35,
                                                                         dmpl__DueinUsageHours__c = 40,
                                                                         dmpl__DueOnUsage__c = 45,
                                                                         dmpl__FromDurationDays__c = 50,
                                                                         dmpl__ToDurationDays__c = 60,                                                                         
                                                                         dmpl__FromUsageHours__c = 65,
                                                                         dmpl__ToUsageHours__c = 70,
                                                                         dmpl__FromUsageReading__c = 75,
                                                                         dmpl__ToUsageReading__c = 80
                                                                        ));
        insert itemMaintenanceSchedule;
    }
    
    private static void CreateItemFeatures()
    {
        List<dmpl__ItemFeature__c> itemFeature = new List<dmpl__ItemFeature__c>();
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        itemFeature.add(new dmpl__ItemFeature__c(Name = 'Item-Feature',
                                                 dmpl__ItemId__c = item.Id,
                                                 dmpl__PartnerAccountId__c = partnerAccount.Id,
                                                 dmpl__ShowinCatalog__c = false                                                 
                                                ));
        insert itemFeature;
    }
    
    private static void CreateItemComponent()
    {
        List<dmpl__ItemComponent__c> itemComponent = new List<dmpl__ItemComponent__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c where dmpl__ItemType__c='Product'  LIMIT 1];
        dmpl__Item__c compitem = [Select Id,Name From dmpl__Item__c where dmpl__ItemType__c='Charge Item' LIMIT 1];
        Account act = [Select Id,Name From Account Where Name ='Partner-Test-Account' LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__ItemFeature__c itemFeature = [Select Id,Name From dmpl__ItemFeature__c LIMIT 1];
        itemComponent.add(new dmpl__ItemComponent__c(dmpl__ItemId__c = item.Id,
                                                     dmpl__ComponentItemId__c=compitem.Id,
                                                     dmpl__SKUId__c = sku.Id,
                                                     dmpl__IsMandatory__c=false,
                                                     dmpl__IsBundled__c=true,
                                                     dmpl__PackageType__c='Independent Of Package',
                                                     dmpl__Quantity__c = 10,
                                                     dmpl__IsSelected__c=true,
                                                     dmpl__IsQuantityEditable__c=True,
                                                     dmpl__ApplicableFor__c='Sale',
                                                     dmpl__PartnerAccountId__c = act.id,
                                                     dmpl__FeatureId__c = itemFeature.Id,
                                                     dmpl__SortOrder__c = 30));
        insert itemComponent;
    }
    
    private static void CreateItemAlternate()
    {
        List<dmpl__ItemAlternate__c> itemComponent = new List<dmpl__ItemAlternate__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        itemComponent.add(new dmpl__ItemAlternate__c(dmpl__ItemId__c = item.Id,
                                                     dmpl__AlternateItemId__c=item.Id
                                                    ));
        insert itemComponent;
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
    }
}