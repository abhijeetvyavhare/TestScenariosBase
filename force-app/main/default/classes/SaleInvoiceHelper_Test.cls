@isTest
public class SaleInvoiceHelper_Test {
    
    @testSetup
    public static void Setup()
    {
        //System.runAs(PostInstallHelper.AssignAdministratorAllPermissions(UserInfo.getUserId())){
            test.startTest();
            CreateAccount(); 
            CreateBranch();
            CreateItems();
            CreateSKU();
            CreateTaxGroup();
            CreateTax();
            CreateTaxGroupRule();
            CreatePriceList();
            CreateSaleOrder();  
           //CreateSaleOrderLine() ;       
            test.stopTest();
            CreateSaleInvoice(); 
            
        //}
    }  
    @istest
    public static void postGL()
    {
        try{
        List<dmpl__AccountBalance__c> accountbalance = new List<dmpl__AccountBalance__c>();
        List<dmpl__GeneralLedger__c> ledgers = new List<dmpl__GeneralLedger__c>(); 
        dmpl__SaleInvoice__c saleInvoice = [Select Id,Name,dmpl__DocumentDate__c,dmpl__PartnerAccountId__c, dmpl__IsGLPostingApproved__c, dmpl__IsGLPosted__c From dmpl__SaleInvoice__c LIMIT 1];
        List<dmpl__GLAccount__c> glAccounts = new List<dmpl__GLAccount__c>();
        glAccounts.add(new dmpl__GLAccount__c(Name = 'Test GL Account', AccountType__c = 'Account Receivable', dmpl__PartnerAccountId__c = saleInvoice.dmpl__PartnerAccountId__c, dmpl__IsActive__c = True));
        glAccounts.add(new dmpl__GLAccount__c(Name = 'Test GL Account', AccountType__c = 'Income', dmpl__PartnerAccountId__c = saleInvoice.dmpl__PartnerAccountId__c, dmpl__IsActive__c = True));
        insert glAccounts;
        accountbalance.add(new dmpl__AccountBalance__c(dmpl__GLAccountId__c = glAccounts[0].id, dmpl__Amount__c  = 500));
        insert accountbalance;
        //ledgers.add(new dmpl__GeneralLedger__c(dmpl__PartnerAccountId__c = saleInvoice.dmpl__PartnerAccountId__c ,dmpl__GLAccountId__c  =glAccounts[0].id, dmpl__DocumentDate__c = Date.Today(),dmpl__SourceDocumentName__c  = saleInvoice.Name , dmpl__TransactionType__c = 'Invoice'  ));
        //insert ledgers; 
        saleInvoice.dmpl__IsGLPostingApproved__c = True;
        update saleInvoice;
        dmpl__GeneralLedger__c ledger =[SELECT ID FROM dmpl__GeneralLedger__c LIMIT 1];
         ledgers.add(ledger);
        
        
        System.assertEquals(false, saleInvoice.dmpl__IsGLPosted__c, 'Sale Invoice has 1 Record Updated');

        saleInvoice = [Select Id,Name,dmpl__DocumentDate__c,dmpl__PartnerAccountId__c, dmpl__IsGLPostingApproved__c, dmpl__IsGLPosted__c From dmpl__SaleInvoice__c LIMIT 1];
        saleInvoice.dmpl__Remark__c = 'Upadated';
        update saleInvoice;

        delete saleInvoice;
        AccountBalanceHelper.areKeyFieldsModified(ledgers,ledger);
        AccountBalanceHelper.undoGeneralLedgerEntry(ledger,accountbalance[0]);
        }
        catch(Exception ex)
        {
            
        }
    }

    @isTest
    public static void createSaleInvoicesFromSelectedSaleOrderLines()
    {
        Test.startTest();
        try{
            List<Id> ids = new List<Id>();
            List<String> fields = new List<String>{
                'Name'
            };
            List<dmpl__SaleOrderLine__c> orderLines = [Select Id, Name,dmpl__Quantity__c,dmpl__PendingFulfilmentOrderQuantity__c,dmpl__PendingInvoiceQuantity__c  From dmpl__SaleOrderLine__c LIMIT 1];
            ids=DocumentHelper.extractIds(orderLines);
            List<SourceObjectInfo> info = new List<SourceObjectInfo>();
            //SaleInvoiceHelper.createSaleInvoiceFromDeliveryOrder(info);
            SaleInvoiceHelper.createSaleInvoicesFromSelectedSaleOrderLines(ids,orderLines,fields);
            SaleInvoiceHelper.createSaleInvoicesFromSelectedSaleOrderLines(CollectionHelper.extractIds(orderLines),orderLines,new List<String>());
            orderLines[0].dmpl__Quantity__c = 5;
        
            update orderLines[0];
            delete orderLines[0];        
        } catch (Exception ex) {
            
        }
        
        test.stopTest();
    }
    
    @isTest
    public static void createSaleInvoiceForAllFromSaleOrder()
    {
        Test.startTest();
        try {

            List<dmpl__SaleOrder__c> orders = [Select Id, Name From dmpl__SaleOrder__c LIMIT 1];
            SaleInvoiceHelper.createSaleInvoiceForAllFromSaleOrder(orders);
            //SaleInvoiceHelper.createSaleInvoicesFromSelectedSaleOrderLines(CollectionHelper.extractIds(orderLines));
                    
        } catch (Exception ex) {
            
        }
        
        test.stopTest();
    }
    
    @isTest
    public static void testForupdatePaidAmount()
    {
        Test.startTest();
        List<dmpl__SaleInvoice__c> SaleInvoiceIds = [Select Id,dmpl__SaleOrderId__c From dmpl__SaleInvoice__c];
        SaleInvoiceHelper.updatePaidAmount(DocumentHelper.extractIds(SaleInvoiceIds));
        PaymentHelper.updatePaymentsTaggingToInvoice(SaleInvoiceIds);
        test.stopTest();
    }

     @isTest
    public static void querySaleInvoiceLinesOfSaleInvoices()
    {
        Test.startTest();
        List<dmpl__SaleInvoice__c> invoices =[select Id, Name,dmpl__SaleOrderId__c from dmpl__SaleInvoice__c Limit 1];
        List<Id> ids = New List<Id>();
        ids.add(invoices[0].Id);
        SaleInvoiceLineHelper.querySaleInvoiceLinesOfSaleInvoices(ids);     
        test.stopTest();
    }
    
     @isTest
    Public static void createSaleReturnFromSaleInvoice()
    {
        Test.startTest();
        string errorReceived;
        //try{             
            List<SaleInvoice__c> sOrder=[Select Id, Name From SaleInvoice__c Limit 1 ];
            SaleReturnHelper.createSaleReturnFromSaleInvoice(sOrder);
            SaleReturnHelper.createSaleReturnFromSaleInvoice(sOrder[0].Id);
        //} catch (Exception ex) {
            //errorReceived = ex.getMessage();
        //}
        System.assertNotEquals(null, 'errorReceived');
        Test.stopTest();
    }
    
    
    @isTest
    private static void verifyBulkOrderProcessing()
    {
        try{
        test.startTest();
        List<Id> ids = new List<Id>();
        List<String> fields = new List<String>();
        Account act = [Select Id,Name From Account LIMIT 1];
        BulkOrderProcessingController.getRelatedRecords('','',fields);     
        BulkOrderProcessingController.createBulkInvoices(ids,new List<Sobject>(),new List<String>());     
        BulkOrderProcessingController.createBulkFulfilments('Account',ids);
        test.stopTest();
        }catch(Exception e){}
    }
    
    @isTest
    private static void getSaleInvoice1()
    {
        try{
        test.startTest();
            
            List<SaleInvoice__c> sOrder=[Select Id, Name From SaleInvoice__c];             
            SaleInvoiceLine__c soLine=[Select Id, Name,dmpl__SaleInvoiceId__c from SaleInvoiceLine__c Limit 1];
            DiscountGroupHelper.getSaleInvoice(soLine,sOrder);
        test.stopTest();
        }
        catch(exception e){}
    }
    
    
    
    
    @isTest
    private static void verifyBulkOrderProcessing1()
    {
        try{
        test.startTest();
        List<Id> ids = new List<Id>();
        List<String> fields = new List<String>();
        Account act = [Select Id,Name From Account LIMIT 1];
        List<dmpl__SaleInvoice__c> saleInvoices = [SELECT Id,Name From dmpl__SaleInvoice__c LIMIT 1];
            
        BulkOrderProcessingController.getRelatedRecordsCount('','',fields); 
        BulkOrderProcessingController.getRelatedRecords('','',fields);     
        BulkOrderProcessingController.createBulkInvoices(ids,saleInvoices,fields);     
        BulkOrderProcessingController.createBulkFulfilments('Account',ids);
        test.stopTest();
        }
        catch(exception e){}
    }
    
    @isTest
    private static void verifyBulkOrderProcessing2()
    {
        try{
        test.startTest();
        List<dmpl__SaleInvoice__c> saleInvoices = [SELECT Id,Name From dmpl__SaleInvoice__c LIMIT 1];
        List<Id> ids = new List<Id>();
        List<String> fields = new List<String>();
        Account act = [Select Id,Name From Account LIMIT 1];
        BulkOrderProcessingController.getRelatedRecords('','',fields);  
        BulkOrderProcessingController.getRelatedRecordsCount('','',fields); 
        BulkOrderProcessingController.createBulkInvoices(ids,saleInvoices,fields);     
        BulkOrderProcessingController.createBulkFulfilments('Account',ids);
        SchemeEngine.getSILines();
        test.stopTest();
        }
        catch(exception e){}
    }
    
     @isTest
    Public static void getSaleInvoice()
    {
        Test.startTest();
        string errorReceived;
        try{             
            SaleInvoiceLine__c soLine=[Select Id, Name,dmpl__SaleInvoiceId__c from SaleInvoiceLine__c Limit 1];
            List<SaleInvoice__c> sOrder=[Select Id, Name,dmpl__Discount__c From SaleInvoice__c Limit 1 ];
            PriceListHelper.getSaleInvoice(soLine,sOrder);
            schemeEngine.getSISummary();
            schemeEngine.getBillLines();
            SaleInvoiceHelper.updateDiscountInSaleInvoiceLines(sOrder);
            System.Assert(soLine != null);
        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
        //System.assertEquals(null, errorReceived);

        Test.stopTest();
    }
    
    @isTest
    public static void saleInvoiceFromClaim()
    {
        
        Try{        
            Test.startTest();  
            CreateClaim();
            //CreateClaimBatch();
            //CreateSaleInvoiceFromClaim1(); 
            List<dmpl__SaleInvoice__c> invoice = [Select Id,Name,dmpl__ClaimId__c From dmpl__SaleInvoice__c LIMIT 1];
            List<dmpl__Claim__c> claim =[Select Id, Name from dmpl__Claim__c];
            Map<Id,dmpl__Claim__c> map1 = new  Map<Id,dmpl__Claim__c>(claim);
            List<dmpl__InventoryFulfillmentAllocationLine__c> allocation=new List<dmpl__InventoryFulfillmentAllocationLine__c>();
            SaleInvoiceLineHelper.createSaleInvoiceLinesFromClaim(invoice,map1,allocation);
            System.assertNotEquals(null, invoice);
            Test.stopTest(); 
        }
        Catch(Exception e){}
        
    }
    
    @isTest
    public static void saleInvoiceFromclaimBatch()
    {
        Try{
            Test.startTest();  
            //CreateClaim();
            //CreateClaimBatch();
            //CreateSaleInvoiceFromClaim1(); 
            List<dmpl__SaleInvoice__c> invoice = [Select Id,Name,dmpl__ClaimId__c,dmpl__ClaimBatchId__c From dmpl__SaleInvoice__c LIMIT 1];
            Map<Id,dmpl__ClaimBatch__c> map1 = new  Map<Id,dmpl__ClaimBatch__c>();
            dmpl__ClaimBatch__c claim =[Select Id, Name from dmpl__ClaimBatch__c Limit 1];
            map1.put(invoice[0].Id,claim);
             List<dmpl__InventoryFulfillmentAllocationLine__c> allocation=new List<dmpl__InventoryFulfillmentAllocationLine__c>();
            SaleInvoiceLineHelper.createSaleInvoiceLinesFromClaimBatch(invoice,map1,allocation);
            System.assertNotEquals(null, invoice);
            Test.stopTest(); 
        }
        Catch(Exception e){}
        
    }

    @isTest
    public static void createSchemeLedger()
    {
        List<dmpl__SchemeLedger__c> ledger = new List<dmpl__SchemeLedger__c>();
        Account account = [Select Id,Name From Account WHERE dmpl__IsPartnerAccount__c = True LIMIT 1];
        Account act = [Select Id,Name from Account LIMIT 1];
        dmpl__SaleInvoiceLine__c invoiceLine = [Select Id,Name,dmpl__SaleInvoiceId__c From dmpl__SaleInvoiceLine__c LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        ledger.add(new dmpl__SchemeLedger__c(dmpl__PartnerAccountId__c = account.Id,
                                            dmpl__BranchId__c = branch.Id,
                                             dmpl__Description__c = '',
                                             dmpl__Discount__c = 5,
                                             dmpl__DiscountAmount__c = 100,
                                             dmpl__LineAmount__c = 2399,
                                             dmpl__RewardPoints__c = 10,
                                             dmpl__SaleInvoiceId__c = invoiceLine.dmpl__SaleInvoiceId__c,
                                             dmpl__SaleInvoiceLineId__c = invoiceLine.Id,
                                             dmpl__AccountId__c = act.Id
                                            ));
        insert ledger;
    }
    
     @isTest
    public static void newContract()
    {
        try{
        Test.startTest();  
        CreateAsset();
        CreateItemServiceContract();
        createSchemeLedger();
        dmpl__SaleInvoice__c invoice = [Select Id,Name,dmpl__ClaimId__c,dmpl__DocumentDate__c,dmpl__ClaimBatchId__c From dmpl__SaleInvoice__c LIMIT 1];
        dmpl__SaleInvoiceLine__c invoiceLine = [Select Id,Name From dmpl__SaleInvoiceLine__c LIMIT 1];
        dmpl__Item__c item= [Select Id, Name from dmpl__Item__c Limit 1];
        dmpl__ItemServiceContract__c itemService =[Select Id,dmpl__MaximumUsageReading__c,dmpl__MinimumUsageHours__c,dmpl__MinimumUsageReading__c,dmpl__MaximumUsageHours__c,dmpl__FromDays__c,dmpl__ToDays__c,dmpl__ItemId__c,dmpl__GraceUsageReading__c,dmpl__GraceUsageHours__c,dmpl__GraceUsageDays__c, Name From dmpl__ItemServiceContract__c limit 1];
        dmpl__AssetServiceContract__c asset=[Select Id, Name, dmpl__AssetId__c,dmpl__ItemId__c from dmpl__AssetServiceContract__c Limit 1];
        //List<Id> assetIds = new List<Id>();
        //List<Id> itemIds = new List<Id>();
        AssetServiceContractHelper.newAssetServiceContract(invoice,invoiceLine,item,asset.dmpl__ItemId__c,asset.dmpl__AssetId__c,itemService);
        SchemeEngine.postSISchemeLeders();
        SubscriptionHelper.newSubscription(invoice,invoiceLine,item,asset.dmpl__ItemId__c,asset.dmpl__AssetId__c);
        System.assertNotEquals(null, invoice);
        Test.stopTest(); 
        }catch(exception e){}
    }
    
    @isTest
    public static void newSubscription()
    {
       // try{
        Test.startTest();  
        CreateAsset();
        //CreateItemServiceContract();
        dmpl__SaleInvoice__c invoice = [Select Id,Name,dmpl__AccountId__c,dmpl__ClaimId__c,dmpl__BranchId__c,dmpl__SaleOrderId__c,dmpl__PartnerAccountId__c,dmpl__DocumentDate__c,dmpl__ClaimBatchId__c From dmpl__SaleInvoice__c LIMIT 1];
        dmpl__SaleInvoiceLine__c invoiceLine = [Select Id,Name,dmpl__UnitPrice__c,dmpl__SaleOrderLineId__c,dmpl__Quantity__c,dmpl__ItemId__c From dmpl__SaleInvoiceLine__c LIMIT 1];
        dmpl__Item__c item= [Select Id, Name,dmpl__PricingMethod__c,dmpl__SubscriptionDurationInMonths__c,dmpl__BillingFrequency__c,dmpl__MarkupRate__c,dmpl__ChargeType__c,dmpl__BillingType__c from dmpl__Item__c Limit 1];
       dmpl__AssetServiceContract__c asset=[Select Id, Name, dmpl__AssetId__c,dmpl__ItemId__c from dmpl__AssetServiceContract__c Limit 1];
        SubscriptionHelper.newSubscription(invoice,invoiceLine,item,asset.dmpl__ItemId__c,asset.dmpl__AssetId__c);
        System.assertNotEquals(null, invoice);
        Test.stopTest(); 
      //  }catch(exception e){}
    }
    
     @isTest
    public static void validateComponentsDelete()
    {
        Try{
        Test.startTest();  
            List<Id> ids;
        List<dmpl__SaleInvoiceLine__c> saleOrder = [Select Id,Name,dmpl__ItemId__c From dmpl__SaleInvoiceLine__c LIMIT 1];
        List<dmpl__SaleInvoiceLine__c> saleOrder1 = [Select Id,Name ,dmpl__ItemId__c From dmpl__SaleInvoiceLine__c LIMIT 1];
        PackageHelper.validateComponentsDelete(saleOrder,saleOrder1);
        //    SaleInvoiceLineHelper.updateDiscount(saleOrder);
            SaleInvoiceLineHelper.queryItemServiceContractLines(ids);
        
        System.assertNotEquals(null, saleOrder);
        Test.stopTest(); 
        }
        Catch(Exception e){}
        
    }
    
    @isTest
    public static void queryOriginalAssetServiceContracts()
    {
        Try{
            Test.startTest(); 
            List<Id> assetId = new List<Id>();
            List<Id> itemId = new List<Id>();
            List<Id> invoiceId = new List<Id>();
            dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
            Asset asset = [Select Id,Name  From Asset LIMIT 1];
            assetId.add(asset.Id);
            itemId.add(item.id);
            AssetServiceContractHelper.queryOriginalAssetServiceContracts(assetId,itemId);
            SaleInvoiceHelper.updatePaidAmount(invoiceId);
            System.assertNotEquals(null, item);
            Test.stopTest(); 
        }
        Catch(Exception e){}
        
    }
    
    @isTest
    public static void validateComponentsAdd()
    {
        Try{
            Test.startTest();  
            List<dmpl__SaleInvoiceLine__c> saleOrder = [Select Id,Name,dmpl__ItemId__c From dmpl__SaleInvoiceLine__c LIMIT 1];
            List<dmpl__SaleInvoiceLine__c> saleOrder1 = [Select Id,Name ,dmpl__ItemId__c From dmpl__SaleInvoiceLine__c LIMIT 1];
            PackageHelper.validateComponentsAdd(saleOrder,saleOrder1);
            System.assertNotEquals(null, saleOrder);
            Test.stopTest(); 
        }
        Catch(Exception e){}
        
    }
    
    @isTest
    public static void validateComponentQuantityEdit()
    {
        Try{
        Test.startTest();  
        List<dmpl__SaleInvoiceLine__c> saleOrder = [Select Id,Name,dmpl__ItemId__c From dmpl__SaleInvoiceLine__c LIMIT 1];
        List<dmpl__SaleInvoiceLine__c> saleOrder1 = [Select Id,Name ,dmpl__ItemId__c,dmpl__PackageSaleInvoiceLineId__c From dmpl__SaleInvoiceLine__c LIMIT 1];
        PackageHelper.validateComponentQuantityEdit(saleOrder,saleOrder1);
        System.assertNotEquals(null, saleOrder);
        Test.stopTest(); 
        }
        Catch(Exception e){}
        
    }
    
    @isTest
    public static void Verify2()
    {
        test.startTest();   
        List<dmpl__SaleInvoiceLine__c> line2 = [SELECT Id, Name,dmpl__SubscriptionId__c,dmpl__SubscriptionId__r.dmpl__BillingFrequency__c,dmpl__SubscriptionId__r.dmpl__LastBillingDate__c,dmpl__SubscriptionId__r.dmpl__NextBillingDate__c FROM dmpl__SaleInvoiceLine__c];
        SubscriptionHelper.updateSubscriptionDetailsFromSaleInvoice(line2);
        PackageHelper.getSaleInvoicePackageConfiguration(line2[0].Id);    
        System.assertEquals(line2.size(), line2.size(), 'fulfillment is verified');
        test.stopTest();
    }
    
    @isTest
    public static void Verify3()
    {
        try{
        test.startTest();
        
        List<dmpl__SaleInvoiceLine__c> line2 = [SELECT Id, Name FROM dmpl__SaleInvoiceLine__c];
        List<dmpl__SaleInvoice__c> saleInvoices = [Select Id,Name,dmpl__AccountId__c,dmpl__PartnerAccountId__c,dmpl__OutstandingAmount__c,dmpl__ClaimId__c,dmpl__ClaimBatchId__c,dmpl__DocumentDate__c,dmpl__BranchId__c From dmpl__SaleInvoice__c LIMIT 1];
       
        List<PackageConfigLine> config = new List<PackageConfigLine>();
        PackageHelper.applySaleInvoicePackageConfiguration(line2[0].Id,config);
        PaymentController.getDocument('saleInvoices[0].dmpl__AccountId__c','saleInvoices[0].dmpl__BranchId__c','saleInvoices[0].dmpl__PartnerAccountId__c');
        PaymentController.getEmail('saleInvoices[0].dmpl__PartnerAccountId__c');
        System.assertEquals(line2.size(), line2.size(), 'fulfillment is verified');
        test.stopTest();
        }catch(exception e){}
    }
    
    @isTest
    public static void setApplicableTaxGroups()
    {
        try{
        test.startTest();
        Map<Id,dmpl__Claim__c> claim = new Map<Id,dmpl__Claim__c>();
        List<dmpl__SaleInvoiceLine__c> saleInvoiceLines = [Select Id,Name,dmpl__ItemId__c,dmpl__SKUId__c,dmpl__TaxGroupId__c From dmpl__SaleInvoiceLine__c LIMIT 1];
        List<dmpl__SaleInvoice__c> saleInvoices = [Select Id,Name,dmpl__PartnerAccountId__c,dmpl__ClaimId__c,dmpl__ClaimBatchId__c,dmpl__DocumentDate__c,dmpl__BranchId__c From dmpl__SaleInvoice__c LIMIT 1];
        List<dmpl__Item__c> items = [Select Id,Name,dmpl__TaxItemGroupId__c From dmpl__Item__c LIMIT 1];
        TaxGroupHelper.setApplicableTaxGroups(saleInvoiceLines, saleInvoices, items);
        SaleInvoiceLineHelper.createSaleInvoiceLinesFromClaim(saleInvoices,claim,new List<dmpl__InventoryFulfillmentAllocationLine__c>());
        System.assert(claim != null, 'Clam Data');
        test.stopTest();
        }catch(exception e){}
    }
    
    @isTest
    private static void getDocument()
    {
        try{
        test.startTest();
        List<dmpl__SaleInvoice__c> saleInvoices = [Select Id,Name,dmpl__AccountId__c,dmpl__PartnerAccountId__c,dmpl__ClaimId__c,dmpl__ClaimBatchId__c,dmpl__DocumentDate__c,dmpl__BranchId__c From dmpl__SaleInvoice__c LIMIT 1];
        PaymentController.getDocument('saleInvoices[0].dmpl__AccountId__c','saleInvoices[0].dmpl__BranchId__c','saleInvoices[0].dmpl__PartnerAccountId__c');
        PaymentController.getEmail('saleInvoices[0].dmpl__PartnerAccountId__c');
        System.assert(saleInvoices != null, 'Clam Data');
        test.stopTest();
        }catch(exception e){}
    }
    
    @isTest
    public static void UpdateSaleOrderReleaseFulfillment()
    {
        test.startTest();
        dmpl__SaleOrder__c saleOrder = [Select Id,Name,dmpl__PerformReleaseFulfilment__c,dmpl__PerformReleaseInvoice__c,dmpl__PerformReleaseDelivery__c From dmpl__SaleOrder__c LIMIT 1];
        saleOrder.dmpl__PerformReleaseFulfilment__c = True;
        
        update saleOrder;
        System.assertEquals(True, saleOrder.dmpl__PerformReleaseFulfilment__c, 'Sale Order has 1 Record Updated');
        test.stopTest();
    }
    
      @isTest
    public static void setDefaultDiscountGroupIds()
    {
        test.startTest();
        CreateDiscountGroup();
        List<dmpl__SaleInvoice__c> shipment = [SELECT Id,  Name,
                                                 dmpl__AccountId__c,
                                                 dmpl__DocumentDate__c,
                                                 dmpl__DiscountGroupId__c,
                                                 dmpl__BranchId__c,
                                                 dmpl__PartnerAccountId__c
                                                 FROM dmpl__SaleInvoice__c];       
        
        DiscountGroupHelper.setDefaultDiscountGroupIds(shipment);
        System.assert(shipment != null, 'delivery order data');
        test.stopTest();
    }
    
    @isTest
    public static void UpdateSaleOrderAsReleaseInvoice()
    {
        test.startTest();
        dmpl__SaleOrder__c saleOrder = [Select Id,Name,dmpl__PerformReleaseFulfilment__c,dmpl__PerformReleaseInvoice__c,dmpl__PerformReleaseDelivery__c From dmpl__SaleOrder__c LIMIT 1];
        saleOrder.dmpl__PerformReleaseInvoice__c = True;
        
        update saleOrder;
        System.assertEquals(True, saleOrder.dmpl__PerformReleaseInvoice__c, 'Sale Order has 1 Record Updated');
        test.stopTest();
    } 
    
    @isTest
    public static void UpdateSaleOrderReleaseDelivery()
    {
        test.startTest();
        CreateItemAlternate();
        dmpl__SaleOrder__c saleOrder = [Select Id,Name,dmpl__PerformReleaseFulfilment__c,dmpl__PerformReleaseInvoice__c,dmpl__PerformReleaseDelivery__c,(select Id,Name,dmpl__ItemComponentId__c from SaleOrderLines__r) From dmpl__SaleOrder__c LIMIT 1];
        saleOrder.dmpl__PerformReleaseDelivery__c = True;   
        update saleOrder;
        System.assertEquals(True, saleOrder.dmpl__PerformReleaseDelivery__c, 'Sale Order has 1 Record Updated');
        test.stopTest();
    }
    
    @isTest
    public static void Verifynew1()
    {
        try{
        test.startTest();
        CreateItemAlternate();
        dmpl__SaleInvoiceLine__c line3=[Select Id,Name, dmpl__ItemComponentId__c,dmpl__Quantity__c,dmpl__SaleInvoiceId__c From dmpl__SaleInvoiceLine__c LIMIT 1 ];
        List<dmpl__SaleInvoiceLine__c> line2 = [SELECT Id, Name,dmpl__Quantity__c, dmpl__ItemComponentId__c,dmpl__SaleInvoiceId__c FROM dmpl__SaleInvoiceLine__c];
        List <dmpl__ItemComponent__c> line=[Select Id, Name,dmpl__PackageType__c,dmpl__IsQuantityEditable__c,dmpl__Quantity__c,dmpl__ComponentItemId__c,dmpl__ComponentSKUId__c,dmpl__IsBundled__c from dmpl__ItemComponent__c ];
        SaleInvoiceLineHelper.applyPackageConfiguration(line3,line2,line); 
        line3.dmpl__Quantity__c = 10;
        update line3;
            
        line2[0].dmpl__Quantity__c = 10;
        update line2;
        System.assert(line3 != null, 'sale invoice line data');
        test.stopTest();
        }catch(exception e){}
    }
    
    @isTest
    public static void UpdateSaleInvoice()
    {
        test.startTest();
        dmpl__SaleInvoice__c saleInvoice = [Select Id,Name,dmpl__PerformGLPosting__c,dmpl__Discount__c From dmpl__SaleInvoice__c LIMIT 1];
        saleInvoice.dmpl__PerformGLPosting__c = True;
        saleInvoice.dmpl__Discount__c = 10;
        update saleInvoice;
        System.assertEquals(true, saleInvoice.dmpl__PerformGLPosting__c, 'Test sale Invoice have 1 updated record');
        test.stopTest();
    }
    
    @isTest
    public static void UpdatePerformKPICalculation()
    {
        test.startTest();
        dmpl__SaleInvoice__c saleInvoice = [Select Id,Name,dmpl__PerformKPICalculation__c From dmpl__SaleInvoice__c LIMIT 1];
        saleInvoice.dmpl__PerformKPICalculation__c = True;
        
        update saleInvoice;
        System.assertEquals(true, saleInvoice.dmpl__PerformKPICalculation__c, 'Test sale Invoice have 1 updated record');
        test.stopTest();
    }
    
    @isTest
    public static void UpdateSaleInvoiceLine()
    {
        test.startTest();
        dmpl__SaleInvoiceLine__c saleInvoiceLine = [Select Id,Name,dmpl__Quantity__c,dmpl__UnitPrice__c From dmpl__SaleInvoiceLine__c LIMIT 1];
        if(saleInvoiceLine!=null)
            saleInvoiceLine.dmpl__Quantity__c = 100;
            saleInvoiceLine.dmpl__UnitPrice__c = 2000;
        update saleInvoiceLine;
        System.assertEquals(100, saleInvoiceLine.dmpl__Quantity__c, 'Sale Invoice line has 1 Record Updated');
        test.stopTest();
    }
    
    @isTest
    public static void DeleteSaleInvoiceLine()
    {
        try{
        test.startTest();
        dmpl__SaleInvoiceLine__c saleInvoiceLine = [Select Id,Name From dmpl__SaleInvoiceLine__c LIMIT 1];
        if(saleInvoiceLine!=null)
            delete saleInvoiceLine;
        System.assert(saleInvoiceLine != null, 'Sale Invoice line has 1 Record deleted');
        test.stopTest();
        }
        catch(exception e){}
    }
    
    @isTest
    public static void DeleteSaleInvoice()
    {
        test.startTest();
        dmpl__SaleInvoice__c saleInvoice = [Select Id,Name,dmpl__PerformGLPosting__c,dmpl__PartnerAccountId__c,dmpl__BranchId__c,dmpl__AccountId__c,dmpl__InvoiceGroup__c From dmpl__SaleInvoice__c LIMIT 1];
        
        delete saleInvoice;
        SaleInvoiceHelper.getNewSaleInvoiceKey(saleInvoice);
        System.assertEquals(false, saleInvoice.dmpl__PerformGLPosting__c, 'Test sale Invoice have 1 deleted record');        
        test.stopTest();
    }
    
    @isTest
    public static void UpdateMarkAsClaimed()
    {
        Test.startTest();
        dmpl__SaleInvoiceLine__c saleInvoiceLines = [Select Id,Name,dmpl__IsClaimed__c From dmpl__SaleInvoiceLine__c LIMIT 1];
        saleInvoiceLines.dmpl__IsClaimed__c = true;
        
        update saleInvoiceLines;
        System.assertEquals(true,saleInvoiceLines.dmpl__IsClaimed__c,'Sale Invoice Line Is Claimed Updated');
        Test.stopTest();
    }
    
    @isTest
    public static void UpdateMarkAsClaimed1()
    {
        Test.startTest();
        List<dmpl__SaleInvoiceLine__c> saleInvoiceLines = [Select Id,Name,dmpl__IsClaimed__c From dmpl__SaleInvoiceLine__c];
        SaleInvoiceLineHelper.markAsClaimed(saleInvoiceLines);
        System.assertNotEquals(null, saleInvoiceLines);
        Test.stopTest();
    }
    
    @isTest
    public static void createSaleInvoiceFromSaleOrder()
    {
        test.startTest();
        List<dmpl__SaleOrder__c> saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        SaleInvoiceHelper.createSaleInvoiceFromSaleOrder(saleOrder);
        System.assert(saleOrder != null,'Sale Order created From Sale Invoice');
        test.stopTest();
    }
    
    
    @isTest
    public static void createSaleInvoiceFromAllocatedLines()
    {
        try{
        test.startTest();
        List<dmpl__SaleOrder__c> saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        dmpl__SaleOrderLine__c line = [Select Id,Name From dmpl__SaleOrderLine__c LIMIT 1];
        List<SourceObjectInfo> info = new List <SourceObjectInfo>();
        SaleInvoiceHelper.createSaleInvoiceFromAllocatedLines(saleOrder);
        SaleInvoiceHelper.createSaleInvoiceFromAllocatedLines(info);
        System.assert(saleOrder != null,'Created sale Invoice From Allocated Lines');
        test.stopTest();
        }
        catch(exception e){}
    }
    
    @isTest
    public static void createSaleInvoiceFromSaleOrder1()
    {
        try{
        test.startTest();
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        List<SourceObjectInfo> info = new List <SourceObjectInfo>();
        SaleInvoiceHelper.createSaleInvoiceFromSaleOrder(saleOrder.Id);
        SaleInvoiceHelper.createSaleInvoiceFromAllocatedLines(saleOrder.Id);
        SaleInvoiceHelper.createSaleInvoiceFromAllocatedLines(info);
        System.assert(saleOrder != null,'Created Sale Invoice From Sale Order');
        test.stopTest();
        }
        catch(exception e){}
    }
    
    @isTest
    public static void createSaleInvoiceFromSaleOrder2()
    {
        try{
        test.startTest();
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        List<dmpl__SaleOrderLine__c> orderLine = [Select Id,Name,dmpl__FulfilmentAllocatedQuantity__c,dmpl__AllocatedInvoicedQuantity__c,dmpl__PendingAllocatedInvoicedQuantity__c From dmpl__SaleOrderLine__c WHERE dmpl__PendingAllocatedInvoicedQuantity__c != null LIMIT 1];
        dmpl__SaleInvoice__c saleInvoice = [Select Id,Name From dmpl__SaleInvoice__c LIMIT 1];
        List<SourceObjectInfo> info = new List <SourceObjectInfo>();
        SaleInvoiceHelper.createServiceInvoice(orderLine[0].Id);
        SaleInvoiceHelper.createServiceInvoice(info);
        SaleInvoiceHelper.createServiceInvoice(new List<dmpl__RepairOrder__c>());
        SaleInvoiceHelper.createSaleInvoiceFromSaleOrder(info);
        SaleInvoiceHelper.createSaleInvoiceFromSaleOrder(info,saleInvoice.Id);
        SaleInvoiceHelper.createSaleInvoiceLinesFromSaleOrderInternal(orderLine,info,saleInvoice.Id);
        if(orderLine.size()>0)
            SaleInvoiceHelper.createSaleInvoiceFromAllocatedLines(orderLine,info);
        System.assert(saleOrder != null,'Record Created');
        test.stopTest();
        }
        catch(exception e){}
    }
    
    @isTest
    public static void createSaleInvoiceFromClaim()
    {
        test.startTest();
        List<dmpl__Claim__c> claim = [Select Id,Name From dmpl__Claim__c];
        List<dmpl__ClaimBatch__c> claimBatch = [Select Id,Name From dmpl__ClaimBatch__c];
        SaleInvoiceHelper.createSaleInvoiceFromClaim(claim);
        SaleInvoiceHelper.createSaleInvoiceFromClaimBatch(claimBatch);
        System.assert(claim != null,'Claim Created');
        test.stopTest();
    }
    
    @isTest
    private static void verifycreateSaleInvoiceTax()
    {
        test.startTest();
        dmpl__Tax__c tax = [Select Id,Name,Rate__c From dmpl__Tax__c LIMIT 1];
        dmpl__SaleInvoice__c saleInvoice = [Select Id,Name,dmpl__TotalLineGrossAmount__c,dmpl__TaxGroupId__c,dmpl__TCSEligibleAmount__c From dmpl__saleInvoice__c LIMIT 1];
        //SaleInvoiceTaxHelper.createSaleInvoiceTax(tax,saleInvoice);
        test.stopTest();
    }
    
    @isTest
    public static void createServiceInvoice()
    {
        test.startTest();
        List<Id> saleInvoiceIds = new List<Id>();
        List<dmpl__RepairOrder__c> repairOrder = [Select Id,Name From dmpl__RepairOrder__c];
        SaleInvoiceHelper.createServiceInvoice(repairOrder);
        SaleInvoiceHelper.updateFinanceAmount(saleInvoiceIds);
        System.assert(repairOrder != null,'Repair Order Created');
        test.stopTest();
    }
    
    @isTest
    private static void createSaleInvoiceForAllFromSaleOrder1(){
        test.startTest();
        List<dmpl__SaleOrderLine__c> saleOrderLine = [Select Id,
                                                      dmpl__SaleOrderId__r.dmpl__Discount__c,
                                                      dmpl__SaleOrderId__r.dmpl__SalesExecutiveId__c,
                                                      dmpl__SaleOrderId__r.dmpl__DiscountGroupId__c,
                                                      dmpl__SaleOrderId__r.dmpl__PriceListId__c,
                                                      dmpl__SaleOrderId__r.dmpl__AccountId__c,
                                                      Name,dmpl__ItemId__c,dmpl__SKUId__c,
                                                      dmpl__TaxGroupId__c,dmpl__IsPriceBundled__c,
                                                      dmpl__ItemComponentId__c,dmpl__PackageSaleOrderLineId__c,
                                                      dmpl__Discount2__c,dmpl__DiscountGroupRuleId__c,
                                                      dmpl__UnitPrice__c,dmpl__UnitPrice2__c,
                                                      dmpl__DiscountAmount__c,dmpl__DiscountAmount2__c,
                                                      dmpl__ContractDiscount__c,dmpl__ContractDiscountAmount__c,
                                                      dmpl__SchemeDiscount__c,dmpl__SchemeDiscountAmount__c,
                                                      dmpl__SaleOrderId__r.dmpl__PartnerAccountId__c,dmpl__BillingType__c,
                                                      dmpl__SaleOrderId__c,dmpl__BillingFrequency__c,
                                                      dmpl__SaleOrderId__r.dmpl__BranchId__c,dmpl__ChargeType__c,
                                                      dmpl__PendingFulfilmentOrderQuantity__c,
                                                      dmpl__PendingAllocatedInvoicedQuantity__c,dmpl__ItemLotTypeId__c,
                                                      dmpl__InvoiceGroup__c ,dmpl__Discount__c
                                                      From dmpl__SaleOrderLine__c];
        SaleInvoiceHelper.createSaleInvoiceForAllFromSaleOrder(saleOrderLine);
        test.stopTest();
    }
    
    @isTest
    private static void VerifyHeadlessCallableMethod()
    {
        test.startTest();
        dmpl__SaleInvoice__c saleInvoice = [Select Id,Name From dmpl__SaleInvoice__c LIMIT 1];
        HeadlessCallableController.callHeadlessAction('headlessAction','dmpl__SaleInvoice__c',saleInvoice.Id);
        test.stopTest();
    }
    
    /*private static void CreateAccountGroup()
    {
        dmpl__AccountGroup__c accountGroup= new dmpl__AccountGroup__c (Name= 'Test-AccountGroup', 
                                                                       dmpl__AccountGroupType__c='Scheme');
        insert accountGroup;
    }*/
    
    private static void CreateAccount()
    {
        dmpl__AccountGroup__c accountGroup= new dmpl__AccountGroup__c (Name= 'Test-AccountGroup', 
                                                                       dmpl__AccountGroupType__c='Discount');
        insert accountGroup;
        
        List<Account> account = new List<Account>();
        account.add(new Account(Name = 'Test - Account', 
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
                               ));
        insert account;
        
        
        Account partneraccount = new Account(Name = 'Partner-Test-Account',
                                             dmpl__LastName__c = 'Sale Invoice',
                                             dmpl__IsPartnerAccount__c = True, 
                                             dmpl__IsGLPostingEnabled__c = true,
                                             dmpl__IsActive__c = true);
        insert partneraccount;
        
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__LastName__c = 'Sale Invoice',
                                              dmpl__IsCustomerAccount__c = True,
                                              dmpl__IsActive__c = true);
        insert customerAccount;
        
       Account supplieraccount = new Account(Name = 'Supplier-Test-Account',dmpl__IsSupplierAccount__c = True,dmpl__LastName__c = 'Account', dmpl__IsActive__c = true);
        insert supplieraccount;
        
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
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        branch.Add(new dmpl__Branch__c(dmpl__PartnerAccountId__c =partnerAccount.Id,
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
                                       dmpl__Website__c = 'www.Dealer.com'));
        insert branch;
    }
    /*
    private static void CreateItemGroup()
    {
            List<dmpl__ItemGroup__c> itemGroup = new List<dmpl__ItemGroup__c> ();
            itemGroup.Add(new dmpl__ItemGroup__c(Name = 'Item Group Test',
                                                 dmpl__ItemGroupType__c = 'Tax'
            ));
            insert itemGroup;
    }
    */
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
                                          dmpl__SubscriptionDurationInMonths__c=4,
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
                                         dmpl__SubscriptionDurationInMonths__c=4,
                                         dmpl__Model__c = 'Sample',                       
                                         dmpl__IsActive__c = true,
                                         dmpl__OnlySoldInPackage__c=True
                                         
                                        ));
        insert chargeItem;
        
        List<dmpl__Item__c> subsItem = new List<dmpl__Item__c>();
        subsItem.Add(new dmpl__Item__c(Name = 'Test-Item',
                                       dmpl__ItemCode__c = 'DMPL',
                                       dmpl__ItemType__c = 'Subscription',
                                       dmpl__ItemSubType__c = '',
                                       dmpl__Description__c = '',
                                       dmpl__ItemFamily__c = 'Sample',
                                       dmpl__ItemSegment__c = 'Sample',
                                       dmpl__Make__c = 'Sample',
                                       dmpl__SubscriptionDurationInMonths__c=4,
                                       dmpl__Model__c = 'Sample',                       
                                       dmpl__IsPackage__c = true
                                      ));
        insert subsItem;
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
    
        List<dmpl__ItemLot__c> itemLot = new List<dmpl__ItemLot__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];

        itemLot.Add(new dmpl__ItemLot__c(dmpl__BranchId__c = branch.Id,
                                         dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                         dmpl__ItemId__c = item.Id,
                                         dmpl__SKUId__c =sku[0].Id,
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
    /*
        List<dmpl__Resource__c> resource = new List<dmpl__Resource__c>();
        Account partnerAccount = [Select Id,Name From Account LIMIT 1];
   
        resource.add(new dmpl__Resource__c(Name = 'Test - Resource',
                                           dmpl__ResourceType__c = 'Sample',
                                           dmpl__IsActive__c = true,
                                           dmpl__Phone__c = '9999999999',
                                           dmpl__DefaultPartnerAccountId__c = partnerAccount.Id,
                                           dmpl__DefaultBranchId__c = branch.Id
                                          ));
        insert resource;
*/
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
    /*
    private static void CreateDiscountGroup()
    {
        List<dmpl__DiscountGroup__c> DiscountGroup = new List<dmpl__DiscountGroup__c>();
        Account account = [Select Id, Name FROM Account LIMIT 1];
        DiscountGroup.add(new dmpl__DiscountGroup__c(dmpl__DiscountType__c = 'Sale Price',
                                                     Name = 'Discount Group' ));
        insert DiscountGroup;
    }
*/    
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
    
    
    private static void CreateItemAlternate()
    {
        List<dmpl__ItemAlternate__c> itemAlternate = new List<dmpl__ItemAlternate__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        itemAlternate.add(new dmpl__ItemAlternate__c(
            dmpl__ItemId__c = item.Id,
            dmpl__AlternateType__c='Optional/ Interchangeable'
            
        ));
        insert itemAlternate;
    
        List<dmpl__ItemFeature__c> itemFeature = new List<dmpl__ItemFeature__c>();
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        itemFeature.add(new dmpl__ItemFeature__c(Name = 'Item-Feature',
                                                 dmpl__ItemId__c = item.Id,
                                                 dmpl__PartnerAccountId__c = partnerAccount.Id,
                                                 dmpl__ShowinCatalog__c = false                                                 
                                                ));
        insert itemFeature;
    
        List<dmpl__ItemComponent__c> itemComponent = new List<dmpl__ItemComponent__c>();
        dmpl__Item__c proitem = [Select Id,Name From dmpl__Item__c where dmpl__ItemType__c='Product'  LIMIT 1];
        dmpl__Item__c compitem = [Select Id,Name From dmpl__Item__c where dmpl__ItemType__c='Charge Item' LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        itemComponent.add(new dmpl__ItemComponent__c(dmpl__ItemId__c = proitem.Id,
                                                     dmpl__ComponentItemId__c=compitem.Id,
                                                     dmpl__SKUId__c = sku.Id,
                                                     dmpl__IsMandatory__c=false,
                                                     dmpl__IsBundled__c=true,
                                                     dmpl__PackageType__c='Independent Of Package',
                                                     dmpl__Quantity__c = 10,
                                                     dmpl__IsSelected__c=true,
                                                     dmpl__IsQuantityEditable__c=True,
                                                     dmpl__ApplicableFor__c='Sale',
                                                     dmpl__PartnerAccountId__c = partnerAccount.id,
                                                     dmpl__FeatureId__c = itemFeature[0].Id,
                                                     dmpl__SortOrder__c = 30));
        insert itemComponent;
    }
     /*
    private static void CreateContactAddress()
    {
        List<dmpl__ContactAddress__c> contactAddress = new List<dmpl__ContactAddress__c>();
        Account account = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        contactAddress.add(new dmpl__ContactAddress__c(dmpl__AccountId__c = account.Id,
                                                       Name = 'Test - Contact - Address'                                                      
                                                      ));
        insert contactAddress;
    }
    */
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
                                                 dmpl__TCSEligibleAmount__c = 100,
                                                 //dmpl__SalesExecutiveId__c = resource.Id,
                                                 dmpl__SaleOrderId__c = saleOrder.Id,
                                                 dmpl__FinanceAmount__c=100,
                                                 dmpl__AmountPaid__c =1 ,
                                                 dmpl__Status__c='Draft'
                                                ));
        insert saleInvoice;

        List<dmpl__SaleInvoiceLine__c> saleInvoiceLine = new List<dmpl__SaleInvoiceLine__c>();
        dmpl__SKU__c sku = [Select Id ,Name, dmpl__ItemId__c From dmpl__SKU__c LIMIT 1 ];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c where dmpl__ItemType__c = 'Subscription' LIMIT 1]; 
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
    
    private static void CreateSaleInvoiceFromClaim1()
    {
         CreateAsset();
        List<dmpl__SaleInvoice__c> saleInvoice1 = new List<dmpl__SaleInvoice__c>();
        Account account = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        dmpl__Claim__c claim =[Select id, Name from dmpl__Claim__c Limit 1];
        dmpl__ClaimBatch__c claimBatch =[Select Id, Name from dmpl__ClaimBatch__c Limit 1];
        dmpl__PriceList__c priceList=[select Id, Name from dmpl__PriceList__c WHERE dmpl__PriceListType__c = 'Sale Price' LIMIT 1];
        //dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        saleInvoice1.Add(new dmpl__SaleInvoice__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                 dmpl__BranchId__c = Branch.Id,
                                                 dmpl__ClaimId__c=claim.Id,
                                                 dmpl__ClaimBatchId__c=claimBatch.Id,
                                                 dmpl__PriceListId__c=priceList.Id,
                                                 dmpl__DocumentDate__c = date.today(),
                                                 dmpl__AccountId__c = account.Id,
                                                 //dmpl__SalesExecutiveId__c = resource.Id,
                                                 dmpl__SaleOrderId__c = saleOrder.Id,
                                                 dmpl__FinanceAmount__c=100,
                                                  dmpl__TCSEligibleAmount__c = 100,
                                                 dmpl__AmountPaid__c =1 ,
                                                 dmpl__Status__c='Draft' 
                                                ));
        insert saleInvoice1;
        
        List<dmpl__SaleInvoiceLine__c> saleInvoiceLine1 = new List<dmpl__SaleInvoiceLine__c>();
        dmpl__SKU__c sku = [Select Id ,Name, dmpl__ItemId__c From dmpl__SKU__c LIMIT 1 ];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1]; 
        Asset asset =[select Id ,Name from Asset Limit 1];
        dmpl__ClaimLine__c claimLine =[Select Id, Name from dmpl__ClaimLine__c Limit 1];
        dmpl__PriceListRules__c priceRule =[select Id, Name from dmpl__PriceListRules__c Limit 1];
        dmpl__ItemLot__c itemLot = [Select Id, Name From dmpl__ItemLot__c LIMIT 1];
        saleInvoiceLine1.Add(new dmpl__SaleInvoiceLine__c(dmpl__SaleInvoiceId__c = SaleInvoice1[0].id,
                                                         dmpl__ItemId__c = sku.dmpl__ItemId__c,
                                                         dmpl__PriceListRuleId__c=priceRule.Id,
                                                         dmpl__SKUId__c =sku.Id ,
                                                         dmpl__ClaimLineId__c=claimLine.Id,
                                                         dmpl__AssetId__c=asset.Id,
                                                         dmpl__IsILPostingApproved__c=false,
                                                         dmpl__IsGLPostingApproved__c=false,
                                                         dmpl__ItemLotId__c = itemLot.Id,
                                                         dmpl__Quantity__c = 100,
                                                         dmpl__UnitPrice__c = 10,
                                                         dmpl__SchemeDiscountAmount__c = 100
                                                        ));
     
        insert saleInvoiceLine1;
        
        
    }
    
    /*
    private static void CreateNewPayment()
    {
        List<dmpl__Payment__c> payment = new List<dmpl__Payment__c>();
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        dmpl__SaleInvoice__c saleInvoice = [Select Id,Name From dmpl__SaleInvoice__c LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
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
    }*/
      
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
        
        dmpl__AssetServiceContractLine__c assetServiceContractLine = new dmpl__AssetServiceContractLine__c(
            dmpl__AssetServiceContractId__c = assetServiceContracts[0].Id,
            dmpl__ComponentItemId__c = workItem.Id,
            dmpl__Quantity__c = 1,
            dmpl__UtilizedQuantity__c = 0);
        insert assetServiceContractLine;
    }
    
    
      private static void CreateClaim()
    {
        List<dmpl__Claim__c> claim = new List<dmpl__Claim__c>();
        Account account = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        claim.add(new dmpl__Claim__c(dmpl__BranchId__c = branch.Id,
                                     dmpl__ClaimType__c='Service',
                                     dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                     dmpl__DocumentDate__c = date.today(),
                                     dmpl__SupplierNameId__c = account.Id,
                                     dmpl__AsonDate__c = date.today()
                                    ));
        
        claim.add(new dmpl__Claim__c(dmpl__BranchId__c = branch.Id,
                                     dmpl__ClaimType__c='Purchase',
                                     dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                     dmpl__DocumentDate__c = date.today(),
                                     dmpl__SupplierNameId__c = account.Id,
                                     dmpl__AsonDate__c = date.today()
                                    ));
        insert claim;
        SaleInvoiceHelper.createSaleInvoiceDocument(claim[0]);
    
        List<dmpl__ClaimBatch__c> claimBatch = new List<dmpl__ClaimBatch__c>();
        //Account account = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        //dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        claimBatch.add(new dmpl__ClaimBatch__c(dmpl__BranchId__c = branch.Id,
                                               dmpl__PartnerAccountId__c = partnerAccount.Id,
                                               dmpl__DocumentDate__c = date.today(),
                                               dmpl__SupplierNameId__c = account.Id
                                              ));
        insert claimBatch;
        SaleInvoiceHelper.createSaleInvoiceDocument(claimBatch[0]);
        List<dmpl__ClaimLine__c> claimLine = new List<dmpl__ClaimLine__c>();
        //dmpl__Claim__c claim = [Select Id,Name FROM dmpl__Claim__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name FROM dmpl__Item__c LIMIT 1];
        claimLine.add(new dmpl__ClaimLine__c(dmpl__BranchId__c = branch.Id,
                                             dmpl__ClaimId__c = claim[0].Id,
                                             dmpl__ClaimType__c='Reimbursment',
                                             dmpl__ItemCode__c = 'bxfs543',
                                             dmpl__PartnerAccountId__c = partnerAccount.Id,
                                             dmpl__ItemId__c = item.Id,
                                             dmpl__ClaimQuantity__c = 2,
                                             dmpl__UnitPrice__c =100,
                                             dmpl__ApproveQuantity__c = 10,
                                             dmpl__RejectQuantity__c = 2,
                                             dmpl__ClaimBatchId__c = claimBatch[0].Id
                                            ));
        insert claimLine;
        
    }
     private static void CreateItemServiceContract()
    {
        List<dmpl__ItemServiceContract__c> serviceContract = new List<dmpl__ItemServiceContract__c>();
        dmpl__Item__c item = [Select Id,Name FROm dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c LIMIT 1];
        serviceContract.add(new dmpl__ItemServiceContract__c(dmpl__ItemId__c = item.Id,
                                                             dmpl__SKUId__c = sku.Id,
                                                             dmpl__MaximumUsageHours__c = 10,
                                                             dmpl__MaximumUsageReading__c = 10,
                                                             dmpl__MinimumUsageHours__c = 10,
                                                             dmpl__MinimumUsageReading__c = 10,
                                                             dmpl__GraceUsageDays__c = 2,
                                                             dmpl__FromDays__c = 2,
                                                             dmpl__GraceUsageHours__c = 5,
                                                             dmpl__GraceUsageReading__c = 5,
                                                             dmpl__ToDays__c = 5
                                                            ));
        insert serviceContract;
    }
    
    private static void CreateDiscountGroup()
    {
        List<dmpl__DiscountGroup__c> discountGroup = new List<dmpl__DiscountGroup__c>();
        dmpl__AccountGroup__c accountGroup=[Select Id,Name From dmpl__AccountGroup__c Where dmpl__AccountGroupType__c='Discount' LIMIT 1];
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
     
}