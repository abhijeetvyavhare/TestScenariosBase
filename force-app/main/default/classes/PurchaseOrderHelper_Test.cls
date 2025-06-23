@isTest
public class PurchaseOrderHelper_Test
{
    @testSetup
    public static void Setup()
    {
        //System.runAs(PostInstallHelper.AssignAdministratorAllPermissions(UserInfo.getUserId())){
        
            CreateAccountGroup();
            CreateBranch(); 
            CreateContactAddress();       
            CreateItem();
            //CreateSKU();
            
            CreatePriceList();
            CreatePriceListRules();
            CreateTaxGroup();
            CreateSaleOrder();
            //CreateTax();
            //CreateResource();
            test.startTest();
           
            CreatePurchaseOrderLineVOR();
            CreatePurchaseRequisition();
            CreatePurchaseOrderFromPurchaseRequisition();
          test.stopTest();
            
      //  }
    }
    
     @isTest
    private static void VerifyHeadlessCallabaleMethod()
    {
        test.startTest();
        dmpl__PurchaseOrder__c serviceRequest = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__PurchaseOrder__c LIMIT 1];
        HeadlessCallableController.callHeadlessAction('headlessAction','dmpl__PurchaseOrder__c',serviceRequest.Id);
        test.stopTest();
    }
    
     @isTest
    Public static void getCreateRelatedSettings()
    {
        try{  
            dmpl__CreateRelatedSetting__mdt  gg=  new dmpl__CreateRelatedSetting__mdt();
            PurchaseOrderLine__c poLine=[Select Id, Name,dmpl__PurchaseOrderId__c from PurchaseOrderLine__c Limit 1];
            PurchaseOrder__c pO=[Select Id, Name From PurchaseOrder__c Limit 1 ];
            
            Test.startTest();
            string errorReceived;      
            
            DocumentSelectorController.getCreateRelatedSettings('dmpl__PurchaseOrder__c');
            SchemeEngine.getPOSummary();
            //SchemeEngine.getPOLines();
            //SchemeEngine.postPOSchemeLeders();
            System.assertEquals(null, errorReceived);
            
            Test.stopTest();
        } 
        catch (Exception ex) {
            //errorReceived = ex.getMessage();
        }
    }
    
    @isTest
    public static void setDefaultDiscountGroupIds()
    {
        test.startTest();
        CreateDiscountGroup();
        List<dmpl__PurchaseOrder__c> shipment = [SELECT Id,  Name,
                                                 //dmpl__AccountId__c,
                                                 dmpl__DocumentDate__c,
                                                 dmpl__DiscountGroupId__c,
                                                 dmpl__BranchId__c,
                                                 dmpl__PartnerAccountId__c
                                                 FROM dmpl__PurchaseOrder__c];       
        
        DiscountGroupHelper.setDefaultDiscountGroupIds(shipment);
        System.assert(shipment != null, 'delivery order data');
        test.stopTest();
    }
    
    private static void CreateDiscountGroup()
    {
        List<dmpl__DiscountGroup__c> discountGroup = new List<dmpl__DiscountGroup__c>();
        dmpl__AccountGroup__c accountGroup=[Select Id,Name From dmpl__AccountGroup__c where dmpl__AccountGroupType__c='Discount' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c Limit 1];
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account' LIMIT 1];
        discountGroup.add(new dmpl__DiscountGroup__c(dmpl__BranchId__c = branch.Id,
                                                     dmpl__CustomerAccountGroupId__c = accountGroup.Id,
                                                     dmpl__PartnerAccountId__c = account.Id,
                                                     dmpl__PartnerAccountGroupId__c = accountGroup.Id,
                                                     dmpl__IsDefault__c = true,
                                                     dmpl__IsActive__c = true,
                                                     Name = 'Test - Discount - Group',
                                                     dmpl__DiscountType__c ='Purchase Price'
                              ));
        insert discountGroup;
    }
    
    @isTest
    private static void VerifyPOLineMethod()
    {
        List<dmpl__PurchaseOrderLine__c> poLine = [Select Id, Name,dmpl__PurchaseOrderId__c from dmpl__PurchaseOrderLine__c LIMIT 1];
        List<Id> ids = DocumentHelper.extractIds(poLine, 'Id');
        
        test.startTest();
        
        PurchaseOrderLineHelper.updatePurchaseInvoiceQuantity(ids);
        //PurchaseOrderLineHelper.updatePurchaseReceiptQuantity(ids);
        System.assert(poLine != null,'PO Line present');
        
        test.stopTest(); 
    }
    
    @isTest
    private static void VerifyPOLineMethod1()
    {
        List<dmpl__PurchaseOrderLine__c> poLine = [Select Id, Name,dmpl__PurchaseOrderId__c from dmpl__PurchaseOrderLine__c LIMIT 1];
        List<Id> ids = DocumentHelper.extractIds(poLine, 'Id');
        
        test.startTest();

        //PurchaseOrderLineHelper.updatePurchaseInvoiceQuantity(ids);
        PurchaseOrderLineHelper.updatePurchaseReceiptQuantity(ids);
        System.assert(poLine != null,'PO Line present');
        
        test.stopTest(); 
    }
    
    @isTest
    Public static void getCreateRelatedSettings1()
    {
        dmpl__CreateRelatedSetting__mdt  gg=  new dmpl__CreateRelatedSetting__mdt();
        PurchaseOrderLine__c poLine=[Select Id, Name,dmpl__PurchaseOrderId__c from PurchaseOrderLine__c Limit 1];
        PurchaseOrder__c pO=[Select Id, Name From PurchaseOrder__c Limit 1 ];
        List<SourceObjectInfo> info = new List<SourceObjectInfo>();
        
        Test.startTest();
        string errorReceived;
        try{             
            
            DocumentSelectorController.getChildObjects(poLine.Id,pO.Id,'Find');
            PurchaseOrderHelper.createPurchaseOrderFromRequisition(info);
            PurchaseRequisitionHelper.createPurchaseOrder(info);
            
        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
        System.assertNotEquals(null, errorReceived);
        
        Test.stopTest();
    }
    
    // @isTest
    // Public static void releaseDocument()
    // {
    //     dmpl__CreateRelatedSetting__mdt  gg=  new dmpl__CreateRelatedSetting__mdt();
    //     PurchaseOrderLine__c poLine=[Select Id, Name,dmpl__PurchaseOrderId__c from PurchaseOrderLine__c Limit 1];
    //     PurchaseOrder__c pO=[Select Id, Name From PurchaseOrder__c Limit 1 ];
    //     dmpl__ItemComponent__c comp = [Select Id,Name From dmpl__ItemComponent__c LIMIT 1];
        
    //     Test.startTest();

    //     string errorReceived;
    //     try{             
            
    //         PurchaseOrderLineHelper.createPurchaseOrderLine(poLine,comp);
    //         DocumentSelectorController.releaseDocument(poLine.Id,pO.Id);
            
    //     } catch (Exception ex) {
    //         errorReceived = ex.getMessage();
    //     }
    //     System.assertNotEquals(null, errorReceived);
        
    //     Test.stopTest();
    // }
    
     @isTest
    Public static void releaseChildDocuments()
    {
        List<SourceObjectInfo> childObjectsInfo= new List<SourceObjectInfo> ();
        dmpl__CreateRelatedSetting__mdt  gg=  new dmpl__CreateRelatedSetting__mdt();
        PurchaseOrderLine__c poLine=[Select Id, Name,dmpl__PurchaseOrderId__c from PurchaseOrderLine__c Limit 1];
        PurchaseOrder__c pO=[Select Id, Name From PurchaseOrder__c Limit 1 ];
        
        Test.startTest();
        string errorReceived;
        try{             
            
            DocumentSelectorController.releaseChildDocuments(poLine.Id,pO.Id,childObjectsInfo);
            
        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
        System.assertNotEquals(null, errorReceived);
        
        Test.stopTest();
    }
    
    @isTest
    public static void setApplicableTaxGroups()
    {
        try{
            
        List<dmpl__PurchaseOrderLine__c> lines = [Select Id,Name,dmpl__ItemId__c,dmpl__SKUId__c,dmpl__TaxGroupId__c From dmpl__PurchaseOrderLine__c WHERE dmpl__TaxGroupId__c != null LIMIT 1];
        List<dmpl__PurchaseOrder__c> purchaseOrders = [Select Id,Name,dmpl__PartnerAccountId__c,dmpl__DocumentDate__c,dmpl__BranchId__c From dmpl__PurchaseOrder__c LIMIT 1];
        List<dmpl__Item__c> items = [Select Id,Name,dmpl__TaxItemGroupId__c From dmpl__Item__c LIMIT 1];
        dmpl__TaxGroupRule__c rule = [Select Id,Name From dmpl__TaxGroupRule__c LIMIT 1];
                                      
        test.startTest();
        
        if(rule != null)
          TaxGroupHelper.setApplicableTaxGroups(lines, purchaseOrders, items);
        SchemeEngine.getPOLines();
        SchemeEngine.postPOSchemeLeders();
        System.assertNotEquals(null, purchaseOrders);
                                      
        test.stopTest();
        }catch(exception e){}
    }
    
    @isTest
    public static void getPurchaseOrder1()
    {
        try{
            test.startTest();
                dmpl__PurchaseOrderLine__c lines = [Select Id,Name,PurchaseOrderId__c From dmpl__PurchaseOrderLine__c  LIMIT 1];
                List<dmpl__PurchaseOrder__c> purchaseOrders = [Select Id,Name From dmpl__PurchaseOrder__c ];
                DiscountGroupHelper.getPurchaseOrder(lines,purchaseOrders);                                    
        test.stopTest();
        }catch(exception e){}
    }
    
    

          
    @isTest
    private static void applyPackageConfiguration()
    {
        try{
        List<dmpl__PurchaseOrderLine__c> lines = [Select Id,Name,dmpl__ItemId__c,dmpl__PurchaseOrderId__c,dmpl__SKUId__c,dmpl__TaxGroupId__c,dmpl__ItemComponentId__c From dmpl__PurchaseOrderLine__c LIMIT 1];
      List<dmpl__ItemComponent__c> comp = [Select Id,Name,dmpl__ComponentItemId__c,dmpl__ComponentSKUId__c,dmpl__Quantity__c,dmpl__IsQuantityEditable__c From dmpl__ItemComponent__c where dmpl__PackageType__c='Multiple Of Package' LIMIT 1];
        List<dmpl__ItemComponent__c> comp1 = [Select Id,Name,dmpl__ComponentItemId__c,dmpl__ComponentSKUId__c,dmpl__Quantity__c,dmpl__IsQuantityEditable__c From dmpl__ItemComponent__c where dmpl__PackageType__c !='Multiple Of Package' LIMIT 1];
            
        test.startTest();
            
        //dmpl__PurchaseOrderLine__c line = [Select Id, Name From dmpl__PurchaseOrderLine__c LIMIT 1];
        lines[0].dmpl__ItemComponentId__c = comp[0].Id;
        PurchaseOrderLineHelper.applyPackageConfiguration(lines[0],lines,comp1);
        System.assert(lines != null, 'purchaseOrders');
            
        test.stopTest();
        }
        catch(exception e){}
    }
    
     @isTest
    private static void applyPackageConfiguration1()
    {
        try{
        List<dmpl__PurchaseOrderLine__c> lines = [Select Id,Name,dmpl__PurchaseOrderId__c,dmpl__ItemId__c,dmpl__Quantity__c,dmpl__SKUId__c,dmpl__TaxGroupId__c,dmpl__ItemComponentId__c From dmpl__PurchaseOrderLine__c LIMIT 1];
        List<dmpl__ItemComponent__c> comp1 = [Select Id,Name,dmpl__IsQuantityEditable__c,dmpl__ComponentSKUId__c,dmpl__Quantity__c,dmpl__PackageType__c,dmpl__ComponentItemId__c From dmpl__ItemComponent__c where dmpl__PackageType__c ='Multiple Of Package' LIMIT 1];
            
        test.startTest();
        
        lines[0].dmpl__ItemComponentId__c = comp1[0].Id;
        PurchaseOrderLineHelper.applyPackageConfiguration(lines[0],lines,comp1);
        System.assert(lines != null, 'purchaseOrders');
            
        test.stopTest();
        }
        catch(exception e){}
    }

    
    @isTest
    Public static void getSOQLQuery()
    {
        try{
            dmpl__CreateRelatedSetting__mdt  gg=  new dmpl__CreateRelatedSetting__mdt();
            PurchaseOrderLine__c soLine=[Select Id, Name,dmpl__PurchaseOrderId__c from PurchaseOrderLine__c Limit 1];
            List<dmpl__PurchaseOrder__c> sOrder=[Select Id, Name From dmpl__PurchaseOrder__c Limit 1 ];
            
        Test.startTest();
                     
          SaleOrderHelper.queryDefaultBranches(sOrder);
            SaleOrderHelper.queryDefaultSalesExecutive(sOrder);
            PurchaseOrderHelper.queryTransactedObjectIds(sOrder);
            CreateRelatedSettingHelper.getSOQLQuery(gg,'FIND',soLine.Id);
            //SaleOrderHelper.queryDefaultBranches(sOrder);
            //SaleOrderHelper.queryDefaultSalesExecutive(sOrder);
            //PurchaseOrderHelper.queryTransactedObjectIds(sOrder);
            
            test.stopTest();
        } catch (Exception ex) {}
    }
    
    @isTest
    Public static void getPurchaseOrder()
    {
        PurchaseOrderLine__c soLine=[Select Id, Name,dmpl__PurchaseOrderId__c,dmpl__ItemId__c,dmpl__SKUId__c,dmpl__TaxGroupId__c from PurchaseOrderLine__c Limit 1];
        dmpl__SaleOrderLine__c line2 = [SELECT Id, Name,dmpl__SaleOrderId__c FROM dmpl__SaleOrderLine__c LIMIT 1];
        List<PurchaseOrder__c> sOrder=[Select Id, Name From PurchaseOrder__c Limit 1 ];
        
        Test.startTest();
        string errorReceived;
        try{             
            
            PriceListHelper.getPurchaseOrder(soLine,sOrder); 
            SaleOrderLineHelper.createSaleOderLinesFromPurchaseOrderLine(soLine, line2.dmpl__SaleOrderId__c, 10.00);
            
        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
        System.assertEquals(null, errorReceived);
        
        Test.stopTest();
    } 
    
    @isTest
    public static void VerifyBill()
    {
        string errorReceived;
        string expectedErrorCode = 'SOPOS001';
        try{
            List<dmpl__PurchaseOrder__c> line = [SELECT Id, Name,dmpl__BranchId__c, (SELECT Id, dmpl__Quantity__c,dmpl__ItemId__c,dmpl__PendingInvoiceQuantity__c,dmpl__PurchaseOrderId__c FROM PurchaseOrderLines__r) FROM dmpl__PurchaseOrder__c];

            test.startTest();
            
            List<SourceObjectInfo> sourceObjectInfo = new List<SourceObjectInfo>();
            for(dmpl__PurchaseOrder__c order : line)
            {
                
                for(dmpl__PurchaseOrderLine__c orderLine : order.PurchaseOrderLines__r)
                {
                    sourceObjectInfo.add(new SourceObjectInfo('dmpl__PurchaseOrderLine__c', orderLine.Id, 0, ''));
                }
            }
            
            BillHelper.createPurchaseInvoiceFromPurchaseOrder(sourceObjectInfo); 
            
            test.stopTest();
        }
        catch(Exception ex){
            errorReceived = ex.getMessage();
        }
        System.assertNotEquals(expectedErrorCode,errorReceived);
    }
    
    @isTest
    public static void VerifyPurcahse()
    {
        string errorReceived;
        string expectedErrorCode = 'SOPOS001';
        try{
            List<dmpl__PurchaseOrder__c> line = [SELECT Id, Name,dmpl__BranchId__c, (SELECT Id, dmpl__Quantity__c FROM PurchaseOrderLines__r) FROM dmpl__PurchaseOrder__c];

            test.startTest();
            
            List<SourceObjectInfo> sourceObjectInfo = new List<SourceObjectInfo>();
            for(dmpl__PurchaseOrder__c order : line)
            {
                for(dmpl__PurchaseOrderLine__c orderLine : order.PurchaseOrderLines__r)
                {
                    sourceObjectInfo.add(new SourceObjectInfo('dmpl__PurchaseOrderLine__c', orderLine.Id, 0, ''));
                }
            }
            
            PurchaseOrderHelper.createPurchaseInvoice(sourceObjectInfo);
            
            test.stopTest();
        }
        catch(Exception ex){
            errorReceived = ex.getMessage();
            
        }
        System.assertNotEquals(expectedErrorCode,errorReceived);
    }
    
    @isTest
    public static void VerifyPurcahseNew()
    {
        string errorReceived;
        string expectedErrorCode = 'SOPOS001';
        try{
            List<dmpl__PurchaseOrder__c> line = [SELECT Id, Name,dmpl__BranchId__c, (SELECT Id, dmpl__Quantity__c FROM PurchaseOrderLines__r) FROM dmpl__PurchaseOrder__c];

            test.startTest();
            
            List<SourceObjectInfo> sourceObjectInfo = new List<SourceObjectInfo>();
            for(dmpl__PurchaseOrder__c order : line)
            {
                for(dmpl__PurchaseOrderLine__c orderLine : order.PurchaseOrderLines__r)
                {
                    sourceObjectInfo.add(new SourceObjectInfo('dmpl__PurchaseOrderLine__c', orderLine.Id, 0, ''));
                }
            }
            
             PurchaseOrderHelper.createGoodsReceipt(sourceObjectInfo); 
            PurchaseOrderHelper.createPurchaseOrderFromRequisition(sourceObjectInfo); 
            
            test.stopTest();
        }
        catch(Exception ex){
            errorReceived = ex.getMessage();
            
        }
        System.assertNotEquals(expectedErrorCode,errorReceived);
    }
   
    @isTest
    public static void UpdatePurchaseRequisition()
    {
        List<Id> Ids = new List<Id>();
        test.startTest();
        CreatePurchaseRequisition();
        dmpl__PurchaseRequisition__c purchaseRequisition = [Select Id,Name,dmpl__Status__c,dmpl__PerformReleaseOrder__c From dmpl__PurchaseRequisition__c LIMIT 1];
        purchaseRequisition.dmpl__PerformReleaseOrder__c = true;
        update purchaseRequisition;
        PurchaseOrderLineHelper.queryPurchaseOrderLines(Ids);
        PurchaseOrderLineHelper.queryPurchaseReturnLines(Ids);
        PurchaseOrderHelper.queryAutoPurchaseOrderLines(Ids);
        System.assertEquals(true, purchaseRequisition.dmpl__PerformReleaseOrder__c, 'purchase Requisition have 1 updated record');
        
        test.stopTest();
    }
    
    @isTest
    public static void Verify1()
    {
        List<PackageConfigLine> config = new List<PackageConfigLine>();
        List<dmpl__PurchaseOrderLine__c> purchaseOrder = [SELECT Id, Name,dmpl__TaxGroupId__c,dmpl__SKUId__c,dmpl__PurchaseOrderId__r.dmpl__SupplierAccountId__c,dmpl__ItemId__c,dmpl__PendingQuantity__c FROM dmpl__PurchaseOrderLine__c];
        dmpl__SaleOrder__c saleOrder = [SELECT Id, Name,dmpl__PartnerAccountId__c FROM dmpl__SaleOrder__c];
        
        test.startTest();
        
        SaleOrderHelper.createSaleOrderFromPurchaseOrder(purchaseOrder,saleOrder);
        PackageHelper.getPurchaseOrderPackageConfiguration(purchaseOrder[0].Id);
        PackageHelper.applyPurchaseOrderPackageConfiguration(purchaseOrder[0].Id,config);
        System.assert(purchaseOrder != null, 'purchase order line data');
        
        test.stopTest();
    }
    
     @isTest
    public static void setApplicableTaxes()
    {
         List<dmpl__PurchaseOrderLine__c> purchaseOrder = [SELECT Id, dmpl__Amount__c,Name,dmpl__TaxGroupId__c,dmpl__SKUId__c,dmpl__PurchaseOrderId__r.dmpl__SupplierAccountId__c,dmpl__ItemId__c,dmpl__PendingQuantity__c FROM dmpl__PurchaseOrderLine__c];

        test.startTest();
        //PurchaseOrderTaxHelper.setApplicableTaxes(purchaseOrder);
        System.assert(purchaseOrder != null, 'purchase order line data');
        
        test.stopTest();
    }
    
    @isTest
    public static void VerifyOrder()
    {
        List<dmpl__PurchaseOrder__c> purchaseOrder = [SELECT Id, Name FROM dmpl__PurchaseOrder__c];

        test.startTest();
        
        GoodsReceiptHelper.createGoodsReceiptFromPurchaseOrder(purchaseOrder);
        System.assert(purchaseOrder != null, 'purchase order line data');
        
        test.stopTest();
    }
    
    @isTest
    public static void createGoodsReceipt()
    {
        List<dmpl__PurchaseOrder__c> purchaseOrder = [SELECT Id, Name FROM dmpl__PurchaseOrder__c];

        test.startTest();
        
        PurchaseOrderHelper.createGoodsReceipt(purchaseOrder);
        System.assert(purchaseOrder != null, 'purchase order line data');
        
        test.stopTest();
    }

     @isTest
    public static void createPurchaseInvoice()
    {
        List<dmpl__PurchaseOrder__c> purchaseOrder = [SELECT Id, Name FROM dmpl__PurchaseOrder__c];

        test.startTest();
        
        PurchaseOrderHelper.createPurchaseInvoice(purchaseOrder);
        System.assert(purchaseOrder != null, 'purchase order line data');
        
        test.stopTest();
    }
    
    @isTest
    public static void Verify2()
    {
        List<dmpl__PurchaseOrder__c> purchaseOrder = [SELECT Id, Name,dmpl__RepairOrderId__c FROM dmpl__PurchaseOrder__c];
        List<dmpl__InventoryFulfillment__c> saleOrder = [SELECT Id, Name,dmpl__RepairOrderId__c FROM dmpl__InventoryFulfillment__c];
        
        test.startTest();
        
        //PurchaseOrderLineHelper.createPurchaseOrderLineFromPurchaseOrder(purchaseOrder,saleOrder);
        System.assert(purchaseOrder != null, 'purchase order line data');
        
        test.stopTest();
    }
    
    @isTest
    public static void UpdatePurchaseOrder()
    {
        dmpl__PurchaseOrder__c purchaseOrder = [Select Id,Name,dmpl__Status__c From dmpl__PurchaseOrder__c LIMIT 1];

        test.startTest();
        
        purchaseOrder.dmpl__Status__c = 'Draft';
        update purchaseOrder;
        test.stopTest();
        
        System.assertEquals('Draft', purchaseOrder.dmpl__Status__c, 'purchase Order have 1 updated record');
    }
    
    @isTest
    public static void UpdatePurchaseOrderAsReleaseInvoice()
    {try{
        dmpl__PurchaseOrder__c purchaseOrder = [Select Id,Name,dmpl__PerformReleaseInvoice__c From dmpl__PurchaseOrder__c LIMIT 1];
        
        test.startTest();
        PurchaseOrderHelper.createPurchaseOrderFromRequisition(new List<SourceObjectInfo>());
        PurchaseOrderHelper.createPurchaseOrderFromRequisition(new List<SourceObjectInfo>(),purchaseOrder.Id);
        purchaseOrder.dmpl__PerformReleaseInvoice__c = true;
        update purchaseOrder;
       // System.assertEquals(true, purchaseOrder.dmpl__PerformReleaseInvoice__c, 'purchase Order have 1 updated record');
        }
        catch(exception e){
            
        }
        test.stopTest();
    }
    
    @isTest
    public static void UpdatePurchaseOrderAsPerformReleaseReceipt()
    {
        dmpl__PurchaseOrder__c purchaseOrder = [Select Id,Name,dmpl__PerformReleaseReceipt__c From dmpl__PurchaseOrder__c LIMIT 1];

        test.startTest();
        
        purchaseOrder.dmpl__PerformReleaseReceipt__c = true;
        update purchaseOrder;
        System.assertEquals(true, purchaseOrder.dmpl__PerformReleaseReceipt__c, 'purchase Order have 1 updated record');
        
        test.stopTest();
    }
    
    @isTest
    public static void UpdatePurchaseOrderAsPerformKPICalculation()
    {
        dmpl__PurchaseOrder__c purchaseOrder = [Select Id,Name,dmpl__PerformKPICalculation__c From dmpl__PurchaseOrder__c LIMIT 1];

        test.startTest();
        
        purchaseOrder.dmpl__PerformKPICalculation__c = true;
        update purchaseOrder;
        System.assertEquals(true, purchaseOrder.dmpl__PerformKPICalculation__c, 'purchase Order have 1 updated record');
        
        test.stopTest();
    }
    
    @isTest 
    public static void DeletePurchaseOrderLine()
    { 
        dmpl__PurchaseOrder__c purchaseOrder = [Select Id, Name FROM dmpl__PurchaseOrder__c Where dmpl__PurchaseOrderType__c = 'VOR PO' LIMIT 1];
        dmpl__PurchaseOrderLine__c purchaseOrderLine = [Select Id,Name,dmpl__Quantity__c From dmpl__PurchaseOrderLine__c Where dmpl__PurchaseOrderId__c =: purchaseOrder.Id LIMIT 1];
        
        test.startTest();
        string errorReceived;
        string expectedErrorCode = 'SOPOS001';
        try{
            
            delete purchaseOrderLine;
        }
        catch(Exception ex){
            errorReceived = ex.getMessage();
            
        }
        test.stoptest();
        
        System.assertNotEquals(expectedErrorCode,errorReceived);
        
    }
    
    @isTest
    public static void DeletePurchaseOrder()
    {
        dmpl__PurchaseOrder__c purchaseOrder = [Select Id,Name,dmpl__Status__c From dmpl__PurchaseOrder__c LIMIT 1];

        Test.startTest();
        
        delete purchaseOrder;
        System.assertEquals('Draft', purchaseOrder.dmpl__Status__c, 'Purchase Order have 1 deleted record');
        
        Test.stopTest();
    }
    
    @isTest
    public static void UpdatePurchaseOrderLine()
    {
        dmpl__PurchaseOrder__c purchaseOrder = [Select Id, Name FROM dmpl__PurchaseOrder__c Where dmpl__PurchaseOrderType__c = 'VOR PO' LIMIT 1];
        dmpl__PurchaseOrderLine__c purchaseOrderLine = [Select Id,Name,dmpl__Quantity__c From dmpl__PurchaseOrderLine__c Where dmpl__PurchaseOrderId__c =: purchaseOrder.Id LIMIT 1];
        
        Test.startTest();
        
        purchaseOrderLine.dmpl__Quantity__c = 10;
        update purchaseOrderLine;
        System.assert(purchaseOrderLine != null, 'Purchase Order have 1 updated record');
        
        Test.stopTest();
    }

    @isTest
    public static void StockPanelControllerTest()
    {
        Test.startTest();  
        try {
            dmpl__PurchaseOrder__c saleOrder = [Select Id,Name,dmpl__BranchId__c,dmpl__PartnerAccountId__c From dmpl__PurchaseOrder__c LIMIT 1];
            StockPanelController.createPurchaseOrder('dmpl__PurchaseOrder__c', saleOrder.Id,saleOrder.dmpl__BranchId__c,saleOrder.dmpl__PartnerAccountId__c);
            System.assertNotEquals(null, saleOrder);        
        } catch (Exception ex) {
            
        }
        Test.stopTest();   
    } 
    
    @isTest
    public static void createPurchaseOrderOfStockPanelController(){
        StockPanelController.createPurchaseOrder('',null,null,null);
    }
    //@isTest
    public static void createStockTransferOfStockPanelController(){
        
        //StockPanelController.createStockTransfer('',null,null);
    }
    private static void CreateAccountGroup()
    {
        dmpl__AccountGroup__c accountGroup= new dmpl__AccountGroup__c (Name= 'Test-AccountGroup', 
                                                                       dmpl__AccountGroupType__c='Scheme');
        insert accountGroup;
        
        dmpl__AccountGroup__c discountAccountGroup= new dmpl__AccountGroup__c (Name= 'Test-AccountGroup-1', 
                                                                       dmpl__AccountGroupType__c='Discount');
        insert discountAccountGroup;
    
        List<Account> account = new List<Account>();
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
                                dmpl__IsCustomerAccount__c = False
                               ));
        insert account;
        
        Account partneraccount = new Account(Name = 'Partner-Test-Account',
                                             dmpl__IsPartnerAccount__c = True, 
                                             dmpl__LastName__c = 'Account',
                                             dmpl__IsActive__c = true);
        insert partneraccount;
        
        Account supplieraccount = new Account(Name = 'Supplier-Test-Account',
                                              dmpl__IsSupplierAccount__c = True, 
                                              dmpl__LastName__c = 'Account',
                                              dmpl__IsActive__c = true);
        insert supplieraccount;
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__IsCustomerAccount__c = True,
                                              dmpl__LastName__c = 'Account',
                                              dmpl__IsActive__c = true);
        insert customerAccount;
        dmpl__AccountGroupMember__c partnerAccountGroupMember = new dmpl__AccountGroupMember__c
            (dmpl__AccountGroupId__c=discountAccountGroup.Id,
             dmpl__AccountId__c=partneraccount.Id
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
                                   dmpl__RFID__c = 'O1234fgh'
                                  ));
        insert item;
        
        dmpl__Item__c workItem = new dmpl__Item__c(
            Name = 'Washing', 
            dmpl__ItemCode__c = 'Washing', 
            dmpl__ItemType__c = 'Work Item',
            dmpl__IsActive__c = true);
        
        insert workItem;
        
        insert new dmpl__ItemAlternate__c(
            dmpl__ItemId__c = item[0].Id,
            dmpl__AlternateType__c='Superseded'
            
        );
      
        List<dmpl__SKU__c> Skus = new List<dmpl__SKU__c>();
        //dmpl__Item__c listofitem = [Select Id, Name from dmpl__Item__c];
        Skus.add(new dmpl__SKU__c(Name = 'Harrier XMA - Automatic - Orcus White',
                                  dmpl__SKUCode__c = 'Test - SKU - Code',
                                  dmpl__UnitOfMeasureOfConversion__c = 10,
                                  dmpl__ProductColor__c = 'Sample',
                                  dmpl__IsDefault__c = false,
                                  dmpl__QuantityUnitOfMeasure__c ='Sample',
                                  dmpl__ItemId__c = item[0].Id
                                 ));
        insert Skus;
/*
        List<dmpl__ItemFeature__c> itemFeature = new List<dmpl__ItemFeature__c>();
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        //dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        itemFeature.add(new dmpl__ItemFeature__c(Name = 'Item-Feature',
                                                 dmpl__ItemId__c = item[0].Id,
                                                 dmpl__PartnerAccountId__c = partnerAccount.Id,
                                                 dmpl__ShowinCatalog__c = false                                                 
                                                ));
        insert itemFeature;
        */
    List<dmpl__ItemComponent__c> itemComponent = new List<dmpl__ItemComponent__c>();
        //dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        //dmpl__Item__c workItem=[Select Id, Name From dmpl__Item__c where dmpl__ItemType__c='Work Item' Limit 1];
        //dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        //dmpl__ItemFeature__c itemFeature = [Select Id,Name From dmpl__ItemFeature__c LIMIT 1];
        itemComponent.add(new dmpl__ItemComponent__c(dmpl__ComponentItemId__c = workItem.Id,
                                                     dmpl__SKUId__c = skus[0].Id,
                                                     dmpl__ComponentSKUId__c = skus[0].Id,
                                                     dmpl__Quantity__c=2,
                                                     dmpl__ItemId__c=item[0].Id,
                                                     dmpl__PackageType__c='Independent Of Package',
                                                     //dmpl__FeatureId__c = itemFeature[0].Id,
                                                     dmpl__SortOrder__c = 100,
                                                    dmpl__IsQuantityEditable__c =true));
        
        itemComponent.add(new dmpl__ItemComponent__c(dmpl__ComponentItemId__c = workItem.Id,
                                                     dmpl__SKUId__c = skus[0].Id,
                                                     dmpl__ComponentSKUId__c = skus[0].Id,
                                                     dmpl__Quantity__c=2,
                                                     dmpl__ItemId__c=item[0].Id,
                                                     dmpl__PackageType__c='Multiple Of Package',
                                                     //dmpl__FeatureId__c = itemFeature[0].Id,
                                                     dmpl__SortOrder__c = 100,
                                                     dmpl__IsQuantityEditable__c =true
                                                    ));
        insert itemComponent;        
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
    private static void CreatePriceList()
    {
        List<dmpl__PriceList__c> priceList =new List<dmpl__PriceList__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account' LIMIT 1];
        priceList.Add(new dmpl__PriceList__c(dmpl__PartnerAccountId__c = account.Id,
                                             dmpl__BranchId__c = Branch.Id,
                                             Name='Test-1',
                                             dmpl__PriceListType__c = 'Sale Price',
                                             dmpl__IsActive__c = True
                                            ));
        insert priceList;
    }
    
    private static void CreatePurchaseRequisition()
    {
        List<dmpl__PurchaseRequisition__c> purchaseRequisition = new List<dmpl__PurchaseRequisition__c>();
        Account supplierAccount = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__PurchaseOrderLine__c purchaseorderline = [Select Id, Name FROM dmpl__PurchaseOrderLine__c LIMIT 1];
        purchaseRequisition.add(new dmpl__PurchaseRequisition__c(dmpl__BranchId__c = branch.Id,
                                                                 dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                                 dmpl__SupplierAccountId__c = supplierAccount.Id,
                                                                 dmpl__PerformReleaseOrder__c = false,
                                                                 dmpl__IsOrderReleased__c = true,
                                                                 dmpl__DocumentDate__c=Date.today(),
                                                                 dmpl__Remarks__c='sample',
                                                                 dmpl__PurchaseOrderLineId__c = purchaseorderline.Id 
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
    
    private static void CreatePurchaseOrder()
    {
        List<dmpl__PurchaseOrder__c> purchaseOrder = new List<dmpl__PurchaseOrder__c>();
        Account supplierAccount = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__PriceList__c priceList=[select Id, Name from dmpl__PriceList__c WHERE dmpl__PriceListType__c = 'Sale Price' LIMIT 1];
        purchaseOrder.add(new dmpl__PurchaseOrder__c(dmpl__BranchId__c = branch.Id,
                                                     dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                     dmpl__SupplierAccountId__c = supplierAccount.Id,
                                                     dmpl__PurchaseOrderType__c ='VOR PO',
                                                     dmpl__DocumentDate__c = Date.today(),
                                                     dmpl__PriceListId__c=priceList.Id,
                                                     dmpl__TCSEligibleAmount__c = 100,
                                                     //dmpl__AccountId__c = account.Id,
                                                     //dmpl__SalesExecutiveId__c = resource.Id,
                                                     //dmpl__SaleOrderId__c = saleOrder.Id,
                                                     //dmpl__FinanceAmount__c=100,
                                                     //dmpl__AmountPaid__c =1 ,
                                                     dmpl__Status__c='Draft',
                                                     dmpl__Remarks__c = 'Remark'));
        insert purchaseOrder;
        
    }
    
    private static void CreatePurchaseOrderFromPurchaseRequisition()
    {
        List<dmpl__PurchaseOrder__c> purchaseOrder = new List<dmpl__PurchaseOrder__c>();
        dmpl__PurchaseRequisition__c purchaseRequisition = [Select Id, dmpl__BranchId__c, dmpl__PartnerAccountId__c, dmpl__SupplierAccountId__c FROM dmpl__PurchaseRequisition__c LIMIT 1];
        dmpl__PriceList__c  priceList = [Select Id, Name FROM dmpl__PriceList__c LIMIT 1];
        purchaseOrder.add(new dmpl__PurchaseOrder__c(dmpl__BranchId__c = purchaseRequisition.dmpl__BranchId__c,
                                                     dmpl__PartnerAccountId__c = purchaseRequisition.dmpl__PartnerAccountId__c,
                                                     dmpl__SupplierAccountId__c = purchaseRequisition.dmpl__SupplierAccountId__c,
                                                     dmpl__TCSEligibleAmount__c = 100
                                                    ));
        insert purchaseOrder;
        
        List<dmpl__PurchaseOrderLine__c> purchaseOrderLine = new List<dmpl__PurchaseOrderLine__c>();
        dmpl__Item__c listofitem = [Select Id, Name from dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c LIMIT 1];
        dmpl__ItemAlternate__c alternateItem = [Select Id,Name from dmpl__ItemAlternate__c];
        //dmpl__PurchaseOrder__c purchaseOrder = [Select Id, Name FROM dmpl__PurchaseOrder__c LIMIT 1];
        //dmpl__PurchaseRequisition__c purchaseRequisition = [Select Id,Name FROM dmpl__PurchaseRequisition__c LIMIt 1];
        dmpl__PriceListRules__c priceRule =[select Id, Name from dmpl__PriceListRules__c Limit 1];
        dmpl__PurchaseRequisitionLine__c purchaseRequisitionLine = [Select Id,Name FROM dmpl__PurchaseRequisitionLine__c LIMIt 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c WHERE Name = 'Test - Tax Group - Line' LIMIT 1];
        purchaseOrderLine.add(new dmpl__PurchaseOrderLine__c(dmpl__ItemId__c = listofitem.Id,
                                                             dmpl__SKUId__c = sku.Id,
                                                             dmpl__PurchaseOrderId__c = purchaseOrder[0].Id,
                                                             dmpl__PurchaseRequisitionId__c = purchaseRequisition.Id,
                                                             dmpl__TaxGroupId__c = taxGroup.Id,
                                                             dmpl__PriceListRuleId__c=priceRule.Id,
                                                             //dmpl__IsILPostingApproved__c=false,
                                                             //dmpl__IsGLPostingApproved__c=false,
                                                             //dmpl__ItemLotId__c = itemLot.Id,
                                                             dmpl__Quantity__c = 100,
                                                             //dmpl__UnitPrice__c = 10,
                                                             //dmpl__IsClaimed__c = false,
                                                             dmpl__SchemeDiscountAmount__c = 100,
                                                             dmpl__AlternateItemId__c = alternateItem.Id
                                                            ));
        insert purchaseOrderLine;
        
    }
    
    private static void CreateGLAccount()
    {
        List<dmpl__GLAccount__c> glAccount = new List<dmpl__GLAccount__c>();
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        glAccount.Add(new dmpl__GLAccount__c(Name = 'Test-GLAccount',
                                             dmpl__IsActive__c = true,
                                             dmpl__SystemCode__c = 'Account Receivable',
                                             dmpl__AccountNumber__c = 'Hg37341',
                                             dmpl__AccountType__c = 'Fixed Assets',
                                             dmpl__Currency__c = 'INR',
                                             dmpl__Description__c = 'Text',
                                             dmpl__PartnerAccountId__c = partnerAccount.Id
                                            ));
        insert glAccount;
    
        List<dmpl__GeneralLedger__c> GenL = new List<dmpl__GeneralLedger__c>(); 
        Account Acc = [Select Id , Name From Account Limit 1];
        //dmpl__GLAccount__c GlAcc = [Select Id , Name From dmpl__GLAccount__c Limit 1];
        GenL.add(new dmpl__GeneralLedger__c(dmpl__PartnerAccountId__c = Acc.Id,
                                            dmpl__SourceDocumentName__c = 'Text',
                                            dmpl__TransactionType__c = 'Receipt',
                                            dmpl__GLAccountId__c = glAccount[0].Id,
                                            dmpl__AccountId__c = Acc.Id,
                                            dmpl__DocumentDate__c = Date.today()
                                           ));
        insert GenL;
        
    }
    
    private static void CreateBill()
    {
        List<dmpl__Bill__c> bill = new List<dmpl__Bill__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__PurchaseOrder__c purchaseOrder = [Select Id, Name FROM dmpl__PurchaseOrder__c LIMIT 1];
        dmpl__GoodsReceipt__c GoodR = [Select Id , Name From dmpl__GoodsReceipt__c LIMIT 1];
        dmpl__PriceList__c  priceList = [Select Id, Name FROM dmpl__PriceList__c LIMIT 1];
        dmpl__GeneralLedger__c GeneralLed = [Select Id, Name FROM dmpl__GeneralLedger__c LIMIT 1];
        Account SupplierAcc = [Select Id, Name From Account WHERE Name = 'Supplier-Test-Account' Limit 1];
        bill.add(new dmpl__Bill__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                   dmpl__BranchId__c = branch.Id,
                                   dmpl__PerformGLPosting__c = true,
                                   dmpl__PurchaseOrderId__c = purchaseOrder.Id,
                                   dmpl__GoodsReceiptId__c = GoodR.Id,
                                   dmpl__DocumentDate__c = Date.today(),
                                   dmpl__TypeOfBill__c = 'Expense Bill',
                                   dmpl__PriceListId__c = PriceList.Id,
                                   dmpl__SupplierAccountId__c = SupplierAcc.Id,
                                   dmpl__SupplierInvoiceNumber__c = 'Test',
                                   dmpl__SupplierInvoiceDate__c = Date.today(),
                                   dmpl__SupplierInvoiceAmount__c = 100,
                                   dmpl__GeneralLedgerId__c = GeneralLed.Id
                                  ));
        insert bill;
        
    }
    
    private static void CreatePurchaseOrderLineVOR()
    {
        List<dmpl__PurchaseOrder__c> purchaseOrder = new List<dmpl__PurchaseOrder__c>();
        Account supplierAccount = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        purchaseOrder.add(new dmpl__PurchaseOrder__c(dmpl__BranchId__c = branch.Id,
                                                     dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                     dmpl__SupplierAccountId__c = supplierAccount.Id,
                                                     dmpl__PurchaseOrderType__c ='VOR PO',
                                                     dmpl__DocumentDate__c = Date.today(),
                                                     dmpl__TCSEligibleAmount__c = 100,
                                                     dmpl__Remarks__c = 'Remark'));
        insert purchaseOrder;
        
        
        List<dmpl__PurchaseOrderLine__c> purchaseOrderLine = new List<dmpl__PurchaseOrderLine__c>();
        dmpl__Item__c listofitem = [Select Id, Name from dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c LIMIT 1];
        //dmpl__PurchaseRequisition__c purchaseRequisition = [Select Id,Name FROM dmpl__PurchaseRequisition__c LIMIt 1];
       // dmpl__PurchaseRequisitionLine__c purchaseRequisitionLine = [Select Id,Name FROM dmpl__PurchaseRequisitionLine__c LIMIt 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c Where Name = 'Test - Tax Group - Line' LIMIT 1];
        purchaseOrderLine.add(new dmpl__PurchaseOrderLine__c(dmpl__ItemId__c = listofitem.Id,
                                                             dmpl__SKUId__c = sku.Id,
                                                             dmpl__PurchaseOrderId__c = purchaseOrder[0].Id,
                                                             dmpl__Quantity__c = 1,
                                                             //dmpl__PurchaseRequisitionId__c = purchaseRequisition.Id,
                                                             dmpl__TaxGroupId__c = taxGroup.Id
                                                            ));
        insert purchaseOrderLine;
        
    }
    
    private static void CreateBillLine()
    {
        List<dmpl__BillLine__c> billLine = new List<dmpl__BillLine__c>();
        dmpl__Item__c item = [Select Id, Name FROM dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c LIMIT 1];
        dmpl__PurchaseOrderLine__c purchaseOrderLine = [Select Id, Name FROM dmpl__PurchaseOrderLine__c LIMIT 1];
        dmpl__Bill__c bill = [Select Id, Name FROM dmpl__Bill__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        billLine.add(new dmpl__BillLine__c(dmpl__ItemId__c = item.Id,
                                           dmpl__SKUId__c = sku.Id,
                                           dmpl__Quantity__c = 1,
                                           dmpl__PurchaseInvoiceId__c = bill.Id,
                                           dmpl__PurchaseOrderLineId__c = purchaseOrderLine.Id,
                                           dmpl__TaxGroupId__c = taxGroup.Id));
        insert billLine;
        
    }
    
    private static void CreateGoodReceipt()
    {
        List<dmpl__GoodsReceipt__c> goodReceipt = new List<dmpl__GoodsReceipt__c>();
        Account supplierAccount = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__PurchaseOrder__c Purchase = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__PurchaseOrder__c];
        goodReceipt.add(new dmpl__GoodsReceipt__c(dmpl__BranchId__c = branch.Id,
                                                  dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                  dmpl__SupplierAccountId__c = supplierAccount.Id,
                                                  dmpl__PurchaseOrderId__c = Purchase.Id,
                                                  dmpl__ReceivedTime__c = Date.today(),
                                                  dmpl__PerformReceive__c = True,
                                                  dmpl__PerformInspection__c = True,
                                                  dmpl__PerformInspectionComplete__c = True,
                                                  dmpl__IsInspectionCompleted__c = True,
                                                  dmpl__SupplierInvoiceDate__c = Date.today(),
                                                  dmpl__SupplierInvoiceNumber__c = 'Test-Supply',
                                                  dmpl__SupplierDispatchDate__c = Date.today(),
                                                  dmpl__TransporterName__c = 'Test-Transport',
                                                  dmpl__TransporterRefrenceNumber__c = '123'
                                                 ));
        insert goodReceipt;
     
        List<dmpl__GoodsReceiptLine__c> goodReceiptLine = new List<dmpl__GoodsReceiptLine__c>();
        dmpl__Item__c item = [Select Id, Name FROM dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c LIMIT 1];
        dmpl__PurchaseOrderLine__c purchaseOrderLine = [Select Id,Name FROM dmpl__PurchaseOrderLine__c LIMIT 1];
        //dmpl__GoodsReceipt__c goodReceipt = [Select Id, Name FROM dmpl__GoodsReceipt__c LIMIT 1];
        goodReceiptLine.add(new dmpl__GoodsReceiptLine__c(dmpl__ItemId__c = item.Id,
                                                          dmpl__SKUId__c = sku.Id,
                                                          dmpl__GoodsReceiptId__c = goodReceipt[0].Id,
                                                          dmpl__OrderedQuantity__c = 1,
                                                          dmpl__InvoiceQuantity__c = 1,
                                                          dmpl__SupplierQuantity__c = 5,
                                                          dmpl__PurchaseOrderLineId__c = purchaseOrderLine.Id));
        insert goodReceiptLine;
        
    }
    private static dmpl__TaxGroup__c lineLevelTaxGroup;
    
    private static void CreateTaxGroup()
    {
        List<dmpl__TaxGroup__c> taxGroup = new List<dmpl__TaxGroup__c>();
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account'];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
      taxGroup.Add(new dmpl__TaxGroup__c(Name = 'Test - Tax Group',
                                           dmpl__PartnerAccountId__c = account.Id,
                                           dmpl__BranchId__c = branch.Id,
                                           dmpl__Description__c = 'Test-Description',
                                           dmpl__TaxGroupType__c='Document Level',
                                           dmpl__IsActive__c = true));
        
                          dmpl__TaxGroup__c lineLevel = new dmpl__TaxGroup__c(
                        Name = 'Test - Tax Group - Line',
                        dmpl__PartnerAccountId__c = account.Id,
                        dmpl__BranchId__c = branch.Id,
                        dmpl__Description__c = 'Test-Line-Level',
                        dmpl__TaxGroupType__c = 'Line Level',
                        dmpl__IsActive__c = true
                    );
                
                    taxGroup.add(lineLevel);
        insert taxGroup;
     
        List<dmpl__Tax__c> tax = new List<dmpl__Tax__c>();
        //dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c];
        tax.Add(new dmpl__Tax__c(Name = 'Test - Tax',
                                 dmpl__TaxGroupId__c = lineLevel.Id,
                                 dmpl__Type__c = 'Cess',
                                 dmpl__PostingFieldName__c='Tax1',
                                 dmpl__Rate__c = 10
                                ));        
        insert tax;
        
        List<dmpl__TaxGroupRule__c> rule = new List<dmpl__TaxGroupRule__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        rule.add(new dmpl__TaxGroupRule__c(dmpl__DateEffectiveFrom__c = date.today(),
                                           dmpl__ItemId__c = item.Id,
                                           dmpl__ItemLotTypeId__c = null,
                                           dmpl__TaxGroupId__c = lineLevel.Id
                                          ));
        insert rule;
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
                                             dmpl__PerformReleaseDelivery__c = false,
                                             dmpl__AmountPaid__c = 100
                                            ));
        insert saleOrder;
        
        List<dmpl__SaleOrderLine__c> saleOrderLine = new List<dmpl__SaleOrderLine__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c Where Name = 'Test - Tax Group - Line' LIMIT 1];
        saleOrderLine.Add(new dmpl__SaleOrderLine__c(dmpl__SaleOrderId__c = saleOrder[0].Id,
                                                     dmpl__ItemId__c = item.Id,
                                                     dmpl__SKUId__c = sku.Id,
                                                     dmpl__OriginalItemId__c=item.Id,
                                                     dmpl__Quantity__c = 4,
                                                     dmpl__TaxGroupId__c = taxGroup.Id,
                                                     dmpl__UnitPrice__c = 100,
                                                     dmpl__Discount__c = 5
                                                    ));
        insert saleOrderLine;
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
    
        List<dmpl__Resource__c> resource = new List<dmpl__Resource__c>();
        //Account partnerAccount = [Select Id,Name From Account LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        resource.add(new dmpl__Resource__c(Name = 'Test - Resource',
                                           dmpl__ResourceType__c = 'Sample',
                                           dmpl__IsActive__c = true,
                                           dmpl__Phone__c = '9999999999',
                                           dmpl__DefaultPartnerAccountId__c = account.Id,
                                           dmpl__DefaultBranchId__c = branch.Id
                                          ));
        insert resource;
        
    }
    
    private static void CreateFulfillment()
    {
        List<dmpl__InventoryFulfillment__c> fulfillment = new List<dmpl__InventoryFulfillment__c>();
        Account account = [Select Id,Name From Account where Name ='Customer-Test-Account' LIMIT 1];
        Account partnerAccount = [Select Id,Name From Account where Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        fulfillment.Add(new dmpl__InventoryFulfillment__c(dmpl__PartnerAccountId__c = partnerAccount.Id,
                                                          dmpl__BranchId__c = branch.Id,
                                                          dmpl__AccountId__c = account.Id,
                                                          dmpl__PerformAllocation__c = false,
                                                          dmpl__IsAllocated__c = True,
                                                          dmpl__SaleOrderId__c = saleOrder.Id
                                                         ));
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
    }  
        @isTest
    private static void verifydeleteApplicableTaxes()
    {
        test.startTest();
        dmpl__Tax__c tax = [Select Id,Name,Rate__c From dmpl__Tax__c LIMIT 1];
        dmpl__PurchaseOrder__c purchaseOrder = [Select Id,Name,dmpl__TotalLineGrossAmount__c,dmpl__TaxGroupId__c,dmpl__TCSEligibleAmount__c From dmpl__PurchaseOrder__c LIMIT 1];
        List<dmpl__PurchaseOrder__c> purchaseOrders = [Select Id,Name From dmpl__PurchaseOrder__c];
        // PurchaseOrderTaxHelper.deleteApplicableTaxes(purchaseOrders);
        // PurchaseOrderTaxHelper.createPurchaseOrderTax(tax,purchaseOrder);
      //  PurchaseOrderTaxHelper.setApplicableTaxes(purchaseOrders);
       
        test.stopTest();
    }
    
    
}