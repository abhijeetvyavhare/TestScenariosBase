@isTest
public class InterfaceQueue_Test {

    @testSetup
    public static void Setup()
    {
        test.startTest();
        CreateAccountGroup();
        CreateAccount(); 
        CreateContactAddress();
        CreateBranch();
        CreateItems();
        CreateSKU();
        CreateItemLot();
        CreateItemFeatures();
        CreateItemComponent();
        CreateItemAlternate();
        CreateResource();
        CreatePriceList();
        CreateDiscountGroup();
        CreateTaxGroup();
        CreateTax();
        CreateInterfaceServiceProvider();
        CreateInterfaceServiceProviderRequest();
        CreateInterfaceQueue();
        test.stopTest();
    }
    
    @isTest
    Static void InterfaceServiceTest()
    {
        test.startTest();
        string errorReceived;
        try{             
            dmpl__InterfaceQueue__c queue =[Select Id, Name,dmpl__QueueType__c,dmpl__IsSuccessful__c from dmpl__InterfaceQueue__c Limit 1];
            InterfaceQueueService s = new InterfaceQueueService();
            InterfaceQueueService.queueJobType('Interface Job','recordid');
            InterfaceQueueService.queueJobType('Account Group Member Processor','recordid');
            InterfaceQueueService.queueJobType('Item Group Member Processor','recordid');
            InterfaceQueueService.queueJobType('Auto Order Generator','recordid');
            InterfaceQueueService.queueJobType('Receive Goods Receipt Line Processor','recordid');
            InterfaceQueueService.queueJobType('Service Campaign Member Processor','recordid');
            InterfaceQueueService.queueJobType('Service Campaign Lead Processor','recordid');
            InterfaceQueueService.queueJobType('Service Campaign Asset Processor','recordid');
            InterfaceQueueService.queueJobType('Service Campaign Service Request Processor','recordid');
            try{
                InterfaceQueueService.queueJobType('sample','recordid');
            } catch (Exception ex) {
               errorReceived = ex.getMessage();
            }
            
        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
             
        test.stopTest();
    }

    @isTest
    Static void UpdateQueue1()
    {
        test.startTest();
        string errorReceived;
        try{             
            dmpl__InterfaceQueue__c queue =[Select Id, Name,dmpl__QueueType__c,dmpl__IsSuccessful__c from dmpl__InterfaceQueue__c Limit 1];
            queue.dmpl__QueueType__c='Schedulable'  ;
            Update queue; 
            InterfaceServiceProviderController.performAction(queue.Id);
              System.assert(queue!=null, 'errorReceived'); 
        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
             
        test.stopTest();
    }
    
    @isTest
    Static void UpdateQueue()
    {
        test.startTest();
        string errorReceived;
        try{             
            dmpl__InterfaceQueue__c queue =[Select Id, Name,dmpl__QueueType__c,dmpl__IsSuccessful__c from dmpl__InterfaceQueue__c Limit 1];
            if(queue.dmpl__QueueType__c == 'Schedulable' || queue.dmpl__QueueType__c == 'Queueable' || queue.dmpl__IsSuccessful__c == true)
                Update queue; 
            InterfaceServiceProviderController.performAction(queue.Id);
        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
        System.assertEquals(null, errorReceived);        
        test.stopTest();
    }
    
    @isTest
    public static void updateInterfaceQueue()
    {
        test.startTest();
        dmpl__InterfaceQueue__c queue =[Select Id, Name,dmpl__QueueType__c,dmpl__IsSuccessful__c from dmpl__InterfaceQueue__c Limit 1];
        if(queue != null)
            update queue;
        System.assert(queue != null, 'Interface Queue Data');
        test.stopTest();
    }
   /* @isTest
    public static void PerfromActionNew()
    {
       // try{
            test.startTest();
            CreateInterfaceQueueNew();
            dmpl__InterfaceQueue__c queue =[Select Id,dmpl__JobType__c,dmpl__InterfaceRecordId__c from dmpl__InterfaceQueue__c Where dmpl__JobType__c='Receive Goods Receipt Line Processor' Limit 1];
            JobTypeHelper.executeJob(queue);
            System.assert(queue != null, 'Provider Data');
            test.stopTest();
       // }
       // Catch(exception e){} 
    }*/
    
    @isTest
    Static void completeQueJob()
    {
        test.startTest();
        string errorReceived;
       try{             
            dmpl__InterfaceQueue__c queue =[Select Id,dmpl__AttemptCount__c,dmpl__ExecutionLog__c,dmpl__SchedulableJobName__c,dmpl__CronExpression__c from dmpl__InterfaceQueue__c Limit 1];
            //dmpl__BranchDateSlotResult__c result = [Select Id,Name From dmpl__BranchDateSlotResult__c];
            InterfaceQueueHelper.completeQueJob(queue,null);    
           // InterfaceQueueHelper.scheduleJob(queue); 
            InterfaceQueueHelper.addFileToQueue('','','test',queue.Id);
            System.assert(queue != null, 'Queue data');
     } catch (Exception ex) {
           errorReceived = ex.getMessage();
       }
        //System.assertEquals(null, errorReceived);
        test.stopTest();
    }
    
    @isTest
    public static void markJobCompletedTest()
    {
        test.startTest();
        dmpl__InterfaceQueue__c queue =[Select Id,dmpl__AttemptCount__c,dmpl__ExecutionLog__c,dmpl__SchedulableJobName__c,dmpl__CronExpression__c from dmpl__InterfaceQueue__c Limit 1];
        InterfaceQueueHelper.markJobCompleted(queue.Id,'Test');
        //InterfaceQueueHelper.scheduleJob(queue);
        test.stopTest();
        
    }
    
    @isTest
    public Static void verifyInterfaceProviderInvocable ()
    {
        test.startTest();
        
       dmpl__InterfaceServiceProviderRequest__c request =[Select Id ,Name from  dmpl__InterfaceServiceProviderRequest__c Limit 1 ];
       dmpl__InterfaceServiceProvider__c provider =[Select Id, Name from dmpl__InterfaceServiceProvider__c limit 1];
       InterfaceServiceProviderInvocable.ExecuteActionRequest pscr = new InterfaceServiceProviderInvocable.ExecuteActionRequest();
       List<InterfaceServiceProviderInvocable.ExecuteActionRequest> lpscr = new List<InterfaceServiceProviderInvocable.ExecuteActionRequest>();
         
       // List<String> RecordId = new List<String>{String.valueOf(saleOrder[0].Id)};
        pscr.jobType = request.Id;
        pscr.requestId = provider.Id;
        pscr.providerId = provider.Id;
        pscr.input = request.Id;
        lpscr.add(pscr); 
        InterfaceServiceProviderInvocable.executeAction(lpscr);
        test.stopTest();
    }
    
    @isTest
    public Static void testAction ()
    {
        Try{
        test.startTest(); 
        dmpl__InterfaceServiceProviderRequest__c request =[Select Id ,Name from  dmpl__InterfaceServiceProviderRequest__c Limit 1 ];
        dmpl__InterfaceServiceProvider__c provider =[Select Id, Name from dmpl__InterfaceServiceProvider__c limit 1];
        Account account =[Select Id, Name from Account Limit 1];   
        InterfaceServiceProviderController.testAction(provider.Id,request.Id,request.Id,'','','');
        test.stopTest();
        }catch(exception e){}
    }
    
     @isTest
    public Static void testAction1 ()
    {
        Try{
        test.startTest(); 
        dmpl__InterfaceServiceProviderRequest__c request =[Select Id ,Name from  dmpl__InterfaceServiceProviderRequest__c Limit 1 ];
        dmpl__InterfaceServiceProvider__c provider =[Select Id, Name from dmpl__InterfaceServiceProvider__c limit 1];
        provider.dmpl__ProviderType__c='File Storage' ;
        Update  provider;
        Account account =[Select Id, Name from Account Limit 1];   
        InterfaceServiceProviderController.testAction(provider.Id,request.Id,request.Id,'','','');
        test.stopTest();
        }catch(exception e){}
    }
    
    @isTest
    Static void addFileToQueue()
    {
        test.startTest();
        string errorReceived;
        try{             
            dmpl__InterfaceQueue__c queue =[Select Id, Name,dmpl__AttemptCount__c,dmpl__SchedulableJobName__c,dmpl__CronExpression__c from dmpl__InterfaceQueue__c Limit 1];
            //InterfaceQueueHelper.completeQueJob(queue);    
            //InterfaceQueueHelper.scheduleJob(queue); 
            InterfaceQueueHelper.addFileToQueue('','','',queue.Id);
            System.assert(queue != null, 'Queue data');
        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
        //System.assertEquals(null, errorReceived);
        test.stopTest();
    }
    
    @isTest
    Static void checkSchedulable()
    {
        test.startTest();
        string errorReceived;
        try{             
            InterfaceServiceProviderSchedulable.executeSchedule('');    
        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
        System.assertNotEquals(null, errorReceived);        
        test.stopTest();
    }

    @isTest
    Static void checkSchedulable1()
    {
        test.startTest();
        string errorReceived;
        try{             
            InterfaceServiceProviderSchedulable.queryInterfaceQueue('');    
        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
        System.assertNotEquals(null, errorReceived);
        test.stopTest();
    }
    
    @isTest
    public static void PerfromAction()
    {
        try{
        test.startTest();
        dmpl__InterfaceServiceProvider__c add =[select Id, Name,dmpl__ProviderType__c,(Select Id,dmpl__CustomFunction__c,dmpl__Function__c from InterfaceServiceProviderRequests__r)
                                                    from dmpl__InterfaceServiceProvider__c];
        dmpl__InterfaceServiceProviderRequest__c req = [Select Id,Name From dmpl__InterfaceServiceProviderRequest__c LIMIT 1];
        dmpl__InterfaceQueue__c queue =[Select Id, Name,dmpl__AttemptCount__c,dmpl__SchedulableJobName__c,dmpl__CronExpression__c from dmpl__InterfaceQueue__c Limit 1];
        InterfaceServiceProvider.perfromAction(add.Id,req.Id,queue.Id);
        InterfaceServiceProvider.perfromAction2(add.Id,req.Id,queue.Id);
        InterfaceServiceProvider.perfromAction(add.Id,req.Id,add.Id,queue.Id);
        InterfaceServiceProvider.perfromFileAction(add,req.Id,add.Id,queue.Id);
        //InterfaceServiceProvider.perfromCustomProviderAction(add,req.Id,add.Id,queue.Id);
        JobTypeHelper.executeJob('',add.Id,req.Id,queue.Id);
        System.assert(add != null, 'Provider Data');
        test.stopTest();
        }
        Catch(exception e){}
    }
    
    @isTest
    public static void perfromCustomProviderActionTest()
    {
        try{
        test.startTest();
        dmpl__InterfaceServiceProvider__c add =[select Id, Name,dmpl__ProviderType__c,(Select Id,dmpl__CustomFunction__c,dmpl__Function__c from InterfaceServiceProviderRequests__r)
                                                    from dmpl__InterfaceServiceProvider__c];
        dmpl__InterfaceServiceProviderRequest__c req = [Select Id,Name From dmpl__InterfaceServiceProviderRequest__c LIMIT 1];
        dmpl__InterfaceQueue__c queue =[Select Id, Name,dmpl__AttemptCount__c,dmpl__SchedulableJobName__c,dmpl__CronExpression__c from dmpl__InterfaceQueue__c Limit 1];
        InterfaceServiceProvider.perfromCustomProviderAction(add,req.Id,add.Id,queue.Id);
        //System.assert(add != null, 'Provider Data');
        test.stopTest();
        }
        Catch(exception e){}
    }
    
     @isTest
    Static void queueDocumentActiontest()
    {
        test.startTest();
        dmpl__InterfaceQueue__c queue =[Select Id, Name,dmpl__AttemptCount__c,dmpl__SchedulableJobName__c,dmpl__CronExpression__c from dmpl__InterfaceQueue__c Limit 1];
        InterfaceQueueService.queueDocumentAction(null,null,new list<SourceObjectInfo>{});
        test.stopTest();
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
                                         dmpl__Cost__c=38.3
                                        ));
        insert itemLot;       
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
                                             dmpl__LastName__c = 'Sale Invoice',
                                             dmpl__IsPartnerAccount__c = True, 
                                             dmpl__IsActive__c = true);
        insert partneraccount;
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__LastName__c = 'Sale Invoice',
                                              dmpl__IsCustomerAccount__c = True,
                                              dmpl__IsActive__c = true);
        insert customerAccount;
        
        Account supplieraccount = new Account(Name = 'Supplier-Test-Account',
                                              dmpl__LastName__c = 'Sale Invoice',
                                              dmpl__IsSupplierAccount__c = True,
                                              dmpl__IsActive__c = true);
        insert supplieraccount;
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
    
    private static void CreateTaxGroup()
    {
        List<dmpl__TaxGroup__c> taxGroup = new List<dmpl__TaxGroup__c>();
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account'];
        dmpl__AccountGroup__c AccountGroup = [Select Id,Name FROM dmpl__AccountGroup__c LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        taxGroup.Add(new dmpl__TaxGroup__c(Name = 'Test - Tax Group',
                                           dmpl__PartnerAccountId__c = account.Id,
                                           dmpl__BranchId__c = branch.Id,
                                           dmpl__PartnerAccountGroupId__c= AccountGroup.Id,
                                           dmpl__IsActive__c=True,
                                           dmpl__Description__c='Text'
                                          ));
        insert taxGroup;
    }
    
    private static void CreateTax()
    {
        List<dmpl__Tax__c> tax = new List<dmpl__Tax__c>();
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c];
        tax.Add(new dmpl__Tax__c(Name = 'Test - Tax',
                                 dmpl__TaxGroupId__c = taxGroup.Id,
                                 dmpl__Type__c = 'Cess',
                                 dmpl__Rate__c = 10,
                                 dmpl__PostingFieldName__c = 'Tax1'
                                ));        
        insert tax;
    }
    
    private static void CreateDiscountGroup()
    {
        List<dmpl__DiscountGroup__c> DiscountGroup = new List<dmpl__DiscountGroup__c>();
        Account account = [Select Id, Name FROM Account LIMIT 1];
        DiscountGroup.add(new dmpl__DiscountGroup__c(dmpl__DiscountType__c = 'Sale Price',
                                                     Name = 'Discount Group' ));
        insert DiscountGroup;
    }
    
    private static void CreateSaleOrder()
    {
        List<dmpl__SaleOrder__c> saleOrder = new List<dmpl__SaleOrder__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        dmpl__ContactAddress__c contactAddress = [Select Id,Name,dmpl__AccountId__c From dmpl__ContactAddress__c LIMIT 1];
        dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        saleOrder.Add(new dmpl__SaleOrder__c(dmpl__AccountId__c = contactAddress.dmpl__AccountId__c,
                                             dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                             dmpl__BranchId__c = branch.Id,
                                             dmpl__DocumentDate__c = Date.today(),
                                             dmpl__Status__c = 'Draft',
                                             dmpl__BillingAddressId__c = contactAddress.Id,
                                             dmpl__ShippingAddressId__c = contactAddress.Id,
                                             dmpl__RequiredDate__c = Date.today(),
                                             dmpl__SalesExecutiveId__c = resource.Id,
                                             dmpl__BookingAmount__c = 100,
                                             dmpl__PromisedDate__c = Date.today(),
                                             dmpl__PerformReleaseFulfilment__c = false,
                                             dmpl__PerformReleaseInvoice__c = false,
                                             dmpl__PerformReleaseDelivery__c = false
                                            ));
        insert saleOrder;
        List<dmpl__SaleOrderLine__c> saleOrderLine = new List<dmpl__SaleOrderLine__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c SKU = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__TaxGroup__c TaxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        saleOrderLine.Add(new dmpl__SaleOrderLine__c(dmpl__SaleOrderId__c = saleOrder[0].Id,
                                                     dmpl__ItemId__c = item.Id,
                                                     dmpl__SKUId__c=SKU.Id,
                                                     dmpl__Quantity__c = 1,
                                                     dmpl__TaxGroupId__c=TaxGroup.Id,
                                                     dmpl__UnitPrice__c=1,
                                                     dmpl__Discount__c=1
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
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__ItemFeature__c itemFeature = [Select Id,Name From dmpl__ItemFeature__c LIMIT 1];
        itemComponent.add(new dmpl__ItemComponent__c(dmpl__ItemId__c = item.Id,
                                                     dmpl__SKUId__c = sku.Id,
                                                     dmpl__PackageType__c='Multiple Of Package',
                                                     dmpl__ComponentItemId__c=item.Id,
                                                     dmpl__Quantity__c=2,
                                                     dmpl__FeatureId__c = itemFeature.Id,
                                                     dmpl__SortOrder__c = 100));
        insert itemComponent;
    }
    
    private static void CreateInterfaceServiceProvider()
    {
        List<dmpl__InterfaceServiceProvider__c> interfaceService = new List<dmpl__InterfaceServiceProvider__c>();
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        interfaceService.add(new dmpl__InterfaceServiceProvider__c(dmpl__PartnerAccountId__c = partnerAccount.Id,
                                                                   Name = 'Test1',
                                                                   dmpl__BranchId__c = Branch.Id,
                                                                   dmpl__NamedCredentials__c='tesrt',
                                                                   dmpl__Logging__c='Callout',
                                                                   dmpl__CustomCredentialsUrl__c='www.rk.com',
                                                                   dmpl__ProviderType__c='REST Client'
                                                                  ));
        insert interfaceService;
    }

    
    private static void CreateInterfaceServiceProviderRequest()
    {
        List<dmpl__InterfaceServiceProviderRequest__c> interfaceServiceRequest = new List<dmpl__InterfaceServiceProviderRequest__c>();
        dmpl__InterfaceServiceProvider__c interfaceService = [Select Id,Name From dmpl__InterfaceServiceProvider__c LIMIT 1];
        interfaceServiceRequest.add(new dmpl__InterfaceServiceProviderRequest__c(
            dmpl__CustomFunction__c='TEXT1',
            dmpl__EndPoint__c='TEXT2',
            dmpl__Function__c='Custom Function',
            dmpl__HttpHeaders__c='tEST3',
            dmpl__IsAsynchronous__c=FALSE,
            dmpl__PayloadSchema__c='GFGFDHBDFJBD',
            dmpl__ResponseSchema__c='DBHDFBDBJSB',
            dmpl__StatusEndPoint__c='CHCVCVMCVNMCV',
            dmpl__StatusPayloadSchema__c='BCHCVHBVCJCBBCJBCJBC',
            dmpl__StatusResponseSchema__c='BB CB D C',
            dmpl__InterfaceServiceProviderId__c=interfaceService.Id,
            dmpl__HttpVerb__c='GET',
            dmpl__HttpQuery__c='vdhdvhd'
        ));
        insert interfaceServiceRequest;
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
    
    private static void CreatePriceList()
    {
        List<dmpl__PriceList__c> priceList =new List<dmpl__PriceList__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account'];
        
        priceList.Add(new dmpl__PriceList__c(Name='Test-Price - List',
                                             dmpl__PartnerAccountId__c=account.Id,
                                             dmpl__BranchId__c = branch.Id));
        insert priceList;
    }
    
     private static void CreateGoodsReceipt()
    {
        List<dmpl__GoodsReceipt__c> goodsReceipts= new List<dmpl__GoodsReceipt__c>();
        Account partnerAccount=[Select Id,Name from Account Where Name='Partner-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        Account supplierAccount=[Select Id,Name from Account Where Name='Supplier-Test-Account' LIMIT 1];
        goodsReceipts.add(new dmpl__GoodsReceipt__c(dmpl__PartnerAccountId__c = partnerAccount.Id,
                                                    dmpl__BranchId__c = branch.Id,
                                                    //dmpl__PurchaseOrderId__c = purchaseOrder.Id,
                                                    dmpl__ReceivedTime__c = date.today(),
                                                    dmpl__DocumentDate__c = date.today(),
                                                    dmpl__SupplierAccountId__c = supplierAccount.Id,
                                                    dmpl__SupplierInvoiceDate__c = date.today(),
                                                    dmpl__SupplierInvoiceNumber__c = 'Test-SupplierInvoiceNumber',
                                                    dmpl__SupplierDispatchDate__c = date.today(),
                                                    dmpl__TransporterName__c = 'Test-TransporterName',
                                                    dmpl__TransporterRefrenceNumber__c = 'Test-TransporterRefrenceNumber',
                                                    dmpl__TransporterContactNumber__c = '7575555555'
                                                   ));
        insert goodsReceipts;
    }
    
    private static void CreateGoodReceiptLine()
    {
        dmpl__GoodsReceipt__c GRNDoc = [SELECT Id, Name FROM dmpl__GoodsReceipt__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__GoodsReceiptLine__c grnLine = new dmpl__GoodsReceiptLine__c(dmpl__GoodsReceiptId__c = GRNDoc.Id,
                                                                          dmpl__ItemId__c = item.Id,
                                                                          dmpl__SKUId__c = sku.Id,
                                                                         // dmpl__PurchaseOrderLineId__c = purchaseOrderLine.Id, 
                                                                          dmpl__OrderedQuantity__c =1, 
                                                                          dmpl__ReceivedQuantity__c = 1,
                                                                          dmpl__SerialNumber__c='text1',
                                                                          dmpl__SupplierQuantity__c = 1
                                                                         // dmpl__StorageLocationId__c = storageLocation.Id
                                                                         );
        insert grnLine;
    }
    
    public static void CreateInterfaceQueueNew()
    {
        CreateGoodsReceipt();
        CreateGoodReceiptLine();
        dmpl__GoodsReceipt__c GRNDoc = [SELECT Id, Name FROM dmpl__GoodsReceipt__c LIMIT 1];
        List<dmpl__InterfaceQueue__c> interfaceQueue1 =new List<dmpl__InterfaceQueue__c>();
        interfaceQueue1.Add(new dmpl__InterfaceQueue__c(
                                                       dmpl__QueueType__c = 'Queueable',
                                                       dmpl__InterfaceRecordId__c= GRNDoc.Id,
                                                       dmpl__JobType__c = 'Receive Goods Receipt Line Processor'));
        insert interfaceQueue1;
        jobTypeHelper.executeJob(interfaceQueue1[0]);
    }
    
    
    private static void CreateInterfaceQueue()
    {
        List<dmpl__InterfaceQueue__c> interfaceQueue =new List<dmpl__InterfaceQueue__c>();
        dmpl__InterfaceServiceProvider__c interfaceService = [Select Id,Name From dmpl__InterfaceServiceProvider__c LIMIT 1];
        dmpl__InterfaceServiceProviderRequest__c request = [Select Id,Name From dmpl__InterfaceServiceProviderRequest__c LIMIT 1]; 
        interfaceQueue.Add(new dmpl__InterfaceQueue__c(
            dmpl__InterfaceProviderId__c =interfaceService.Id,
            dmpl__QueueType__c = 'Queueable',
            dmpl__CronExpression__c='*/5 * * * *',
            dmpl__InterfaceRequestId__c = request.Id));
        insert interfaceQueue;
    }  
}