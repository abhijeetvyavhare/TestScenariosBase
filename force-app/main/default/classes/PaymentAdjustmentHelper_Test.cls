@isTest
public class PaymentAdjustmentHelper_Test {
    
    @testSetup
    public static void setup()
    {   
        System.runAs(PostInstallHelper.AssignAdministratorAllPermissions(UserInfo.getUserId())){
            CreateAccountGroup();
            CreateAccount();
            CreateContactAddress();
            CreateBranch();
            CreateItems();
            CreateResource();
            CreateSaleOrder();
            CreateDiscountGroup();
            CreateSaleInvoice();
            CreateCreditNoteAndDebitNote();
            test.startTest();
            //CreateNewPayment();
            test.stopTest();
        }
    }
    
    //@isTest
    public static void VerifyPayment()
    {
        dmpl__Payment__c payment = [Select Id,Name,dmpl__Status__c From dmpl__Payment__c LIMIT 1];
        System.assert(payment != null, 'Test payment have 1 updated record');
    }
    
    @isTest
    private static void VerifyPaymentAdjustmentCreation()
    {
        Test.startTest();
        CreateNewPayment();
        PaymentAdjustmentHelper.extractColumns();
        PaymentAdjustmentHelper.getFieldsetInfo();
        Test.stopTest();
    }
    
    @isTest
    private static void updatePaymentAdjustment()
    {
        try{
            Test.startTest();
            CreateNewPayment();
            dmpl__PaymentAdjustment__c paymentAdjsutment =[Select Id,Name From dmpl__PaymentAdjustment__c Limit 1];
            update paymentAdjsutment;
            Test.stopTest();
        }
        catch(exception e){}
    }
    
    @isTest
    private static void VerifyPaymentAdjustmentCreation1()
    {
        Test.startTest();
        CreateNewPayment1();
        Test.stopTest();
    }
    
    @isTest
    private static void updatePaymentAdjustment1()
    {
        try{
            Test.startTest();
            CreateNewPayment1();
            dmpl__PaymentAdjustment__c paymentAdjsutment =[Select Id,Name From dmpl__PaymentAdjustment__c Limit 1];
            update paymentAdjsutment;
            Test.stopTest();
        }
        catch(exception e){}
    }
    
    @isTest
    private static void deletePaymentAdjustment()
    {
        try{
            Test.startTest();
            CreateNewPayment1();
            dmpl__PaymentAdjustment__c paymentAdjsutment =[Select Id,Name From dmpl__PaymentAdjustment__c Limit 1];
            delete paymentAdjsutment;
            Test.stopTest();
        }
        catch(exception e){}
    }
    
    @isTest
    private static void newPaymentAdjustment()
    {
        Test.startTest();
        CreateNewPayment1();
        dmpl__PaymentAdjustment__c paymentAdjsutment =[Select Id,Name,dmpl__ServiceRequestId__c From dmpl__PaymentAdjustment__c Limit 1];
        dmpl__SaleOrder__c order =[Select Id,Name from dmpl__SaleOrder__c Limit 1];
        dmpl__Payment__c payment =[Select Id,Name from dmpl__Payment__c Limit 1];
        PaymentAdjustmentHelper.setAdjustmentDocumentId(paymentAdjsutment,'dmpl__SaleOrder__c',order.Id);
        PaymentAdjustmentHelper.setAdjustmentDocumentId(paymentAdjsutment,'dmpl__Payment__c',payment.Id);
        PaymentAdjustmentHelper.setAdjustmentDocumentId(paymentAdjsutment,'dmpl__SaleInvoice__c',payment.Id);
        PaymentAdjustmentHelper.setAdjustmentDocumentId(paymentAdjsutment,'dmpl__PurchaseOrder__c',payment.Id);
        PaymentAdjustmentHelper.setAdjustmentDocumentId(paymentAdjsutment,'dmpl__DebitNote__c',order.Id);
        PaymentAdjustmentHelper.setAdjustmentDocumentId(paymentAdjsutment,'dmpl__CreditNote__c',payment.Id);
        PaymentAdjustmentHelper.setAdjustmentDocumentId(paymentAdjsutment,'dmpl__RepairOrder__c',payment.Id);
        PaymentAdjustmentHelper.setAdjustmentDocumentId(paymentAdjsutment,'dmpl__Bill__c',payment.Id);
        PaymentAdjustmentHelper.postBillAdjustments(new list<dmpl__PaymentAdjustment__c>{paymentAdjsutment},true);
        PaymentAdjustmentHelper.postSRAdjustments(new list<dmpl__PaymentAdjustment__c>{paymentAdjsutment},true);
        Test.stopTest();
    }
    
    @isTest
    private static void verifyPaymentAdjustment()
    {
        Test.startTest();
        CreateNewPayment1();
        dmpl__Payment__c payment =[Select Id,Name,dmpl__BranchId__c,dmpl__PartnerAccountId__c,dmpl__AccountId__c from dmpl__Payment__c Limit 1];
        try{
            PaymentAdjustmentHelper.getOpenDocuments('PaymentTaken',payment.dmpl__PartnerAccountId__c,payment.dmpl__BranchId__c,payment.dmpl__AccountId__c,false);
        
        }
        catch(exception e){
            
        }
       // PaymentAdjustmentHelper.getOpenDocuments('PaymentTaken',payment.dmpl__PartnerAccountId__c,payment.dmpl__BranchId__c,payment.dmpl__AccountId__c,false);
        Test.stopTest();
    }
    
    @isTest
    private static void verifyPaymentAdjustmentNew()
    {
        Test.startTest();
        CreateNewPayment1();
        dmpl__Payment__c payment =[Select Id,Name,dmpl__BranchId__c,dmpl__PartnerAccountId__c,dmpl__AccountId__c from dmpl__Payment__c Limit 1];
        try{
            PaymentAdjustmentController.getOpenDocuments('PaymentTaken',payment.dmpl__PartnerAccountId__c,payment.dmpl__BranchId__c,payment.dmpl__AccountId__c,'Test');
        }
        catch(exception e){
            
        }
        Test.stopTest();
    }
     @isTest
    private static void getOpenDocumentsNew1()
    {
        Test.startTest();
        CreateNewPayment1();
        dmpl__Payment__c payment =[Select Id,Name,dmpl__BranchId__c,dmpl__PartnerAccountId__c,dmpl__AccountId__c from dmpl__Payment__c Limit 1];
        try{
             PaymentAdjustmentController.getOpenDocuments('PaymentTaken',payment.dmpl__PartnerAccountId__c,payment.dmpl__BranchId__c,payment.dmpl__AccountId__c,'');
        }
        catch(exception e){
            
        }
          
       
        Test.stopTest();
    }
    
     @isTest
    private static void getOpenPayments()
    {
        Test.startTest();
        CreateNewPayment1();
        dmpl__Payment__c payment =[Select Id,Name,dmpl__BranchId__c,dmpl__PartnerAccountId__c,dmpl__AccountId__c from dmpl__Payment__c Limit 1];
        String partner=(String)payment.dmpl__PartnerAccountId__c;
        String branch=(String)payment.dmpl__BranchId__c;
        String account=(String)payment.dmpl__AccountId__c;
        try{
              PaymentAdjustmentController.getOpenPayments('PaymentTaken',partner,branch,account,'Test',false);
        }
        catch(exception e){
            
        }
            
      
        PaymentAdjustmentController.postAdjustments(new List<Object>{});
        Test.stopTest();
    }
    
     @isTest
    private static void getOpenPayments1()
    {
        Test.startTest();
        CreateNewPayment1();
        dmpl__Payment__c payment =[Select Id,Name,dmpl__BranchId__c,dmpl__PartnerAccountId__c,dmpl__AccountId__c from dmpl__Payment__c Limit 1];
         String partner=(String)payment.dmpl__PartnerAccountId__c;
        String branch=(String)payment.dmpl__BranchId__c;
        String account=(String)payment.dmpl__AccountId__c;
        try{
        PaymentAdjustmentController.getOpenPayments('PaymentTaken',partner,branch,account,'',false);
        }
        catch(exception e){
}
        Test.stopTest();
    }
    
     @isTest
    private static void getImage()
    {
        Test.startTest();
        CreateNewPayment1();
        dmpl__Payment__c payment =[Select Id,Name,dmpl__BranchId__c,dmpl__PartnerAccountId__c,dmpl__AccountId__c from dmpl__Payment__c Limit 1];
        ItemIamgeController.getImage(payment.Id);
        Test.stopTest();
    }
    
    @isTest
    private static void verifyPaymentAdjustment2()
    {
        Test.startTest();
        CreateNewPayment1();
        dmpl__Payment__c payment =[Select Id,Name,dmpl__BranchId__c,dmpl__PartnerAccountId__c,dmpl__AccountId__c from dmpl__Payment__c Limit 1];
        try{
             PaymentAdjustmentHelper.getOpenDocuments('PaymentTaken',payment.dmpl__PartnerAccountId__c,payment.dmpl__BranchId__c,payment.dmpl__AccountId__c,'Test1',false);
        }
        catch(exception e){
            
        }
           
       
        Test.stopTest();
    }
    
    @isTest
    private static void postAdjustments()
    {
        try{
            Test.startTest();
            CreateNewPayment1();
            CreateNewPayment4();
            
            List<dmpl__PaymentAdjustment__c> payments =[Select Id,Name from dmpl__PaymentAdjustment__c];
            List<dmpl__PaymentAdjustment__c> paymentsPo =[Select Id,Name from dmpl__PaymentAdjustment__c where dmpl__PurchaseOrderId__c !=null];
           

            system.debug(paymentsPo + 'PaymentsPo');
            String jsonString= '[{"adjustedAmount":"120","adjustedDocumentId":"120","adjustedDocumentApiName":"dmpl__Payment__c","documentId":"29292","documenApiName":"dmpl__SaleOrder__c"}]';
            List<Object> parsedData = (List<Object>)JSON.deserializeUntyped(jsonString);
            PaymentAdjustmentHelper.postAdjustments(parsedData);
            PaymentAdjustmentHelper.postPOAdjustments(paymentsPo,true);
          
            Test.stopTest();
        }
        catch(exception e){}
    }
    
      @isTest
    private static void createPaymentAdjustment()
    {
        Test.startTest();
        CreateNewPayment1();
        CreateNewPayment5();
        List<dmpl__PaymentAdjustment__c> paymentsNullRo =[Select Id,Name from dmpl__PaymentAdjustment__c WHERE dmpl__RepairOrderId__c = null];
         List<dmpl__PaymentAdjustment__c> paymentsRo =[Select Id,Name,dmpl__RepairOrderId__c,dmpl__AdjustmentAmount__c,dmpl__SaleInvoiceId__c from dmpl__PaymentAdjustment__c where dmpl__RepairOrderId__c !=null];
        String jsonString= '[{"adjustedAmount":"120","adjustedDocumentId":"120","adjustedDocumentApiName":"dmpl__Payment__c","documentId":"29292","documenApiName":"dmpl__SaleOrder__c"}]';
        List<Object> parsedData = (List<Object>)JSON.deserializeUntyped(jsonString);
        Map<Object,Object> documentMap = new Map<Object,Object>();
        documentMap.put(parsedData[0],parsedData[0]);
        PaymentAdjustmentHelper.createPaymentAdjustment(documentMap);
        try{
            PaymentAdjustmentHelper.postROAdjustments(paymentsRo,true);
            PaymentAdjustmentHelper.postROAdjustments(paymentsNullRo,true);
        }
        catch(exception e){
            
        }
       
        Test.stopTest();
	}
    
    @isTest
    private static void verifyPaymentAdjustment3()
    {
        Test.startTest();
        CreateNewPayment1();
        dmpl__Payment__c payment =[Select Id,Name,dmpl__BranchId__c,dmpl__PartnerAccountId__c,dmpl__AccountId__c from dmpl__Payment__c Limit 1];
        try{
            PaymentAdjustmentHelper.getOpenDocuments('PaymentGiven',payment.dmpl__PartnerAccountId__c,payment.dmpl__BranchId__c,payment.dmpl__AccountId__c,'Test1',false); 
        }
        catch(exception e){
            
        }
       // PaymentAdjustmentHelper.getOpenDocuments('PaymentGiven',payment.dmpl__PartnerAccountId__c,payment.dmpl__BranchId__c,payment.dmpl__AccountId__c,'Test1',false);
        Test.stopTest();
    }
    
    @isTest
    private static void verifyPaymentAdjustment1()
    {
        Test.startTest();
        CreateNewPayment1();
        dmpl__Payment__c payment =[Select Id,Name,dmpl__BranchId__c,dmpl__PartnerAccountId__c,dmpl__AccountId__c from dmpl__Payment__c Limit 1];
        try{
            PaymentAdjustmentHelper.getOpenDocuments('PaymentGiven',payment.dmpl__PartnerAccountId__c,payment.dmpl__BranchId__c,payment.dmpl__AccountId__c,false);
        }
        catch(exception e){
            
        }
        
        Test.stopTest();
    }
    
    @isTest
    private static void VerifyPaymentAdjustmentCreation2()
    {
        Test.startTest();
        CreateNewPayment2();
        test.stopTest();
    }
    
    @isTest
    private static void VerifyPaymentAdjustmentCreation3()
    {
        Test.startTest();
        CreateNewPayment3();
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
        //  List<Account> account = new List<Account>();
        dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c LIMIT 1];
        /* account.add(new Account(Name = 'Test - Account',
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
insert account; */
       
       
        Account partneraccount = new Account(Name = 'Partner-Test-Account',
                                             dmpl__LastName__c = 'Account',
                                             dmpl__IsPartnerAccount__c = True,
                                             dmpl__IsActive__c = true);
        insert partneraccount;
        
          Account supplierAccount = new Account(Name = 'Supplier-Test-Account',
                                             dmpl__LastName__c = 'Account1',
                                             dmpl__IsSupplierAccount__c = True,
                                             dmpl__IsActive__c = true);
        insert supplierAccount;
       
       
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__LastName__c = 'Account',
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
        Account account = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        contactAddress.add(new dmpl__ContactAddress__c(dmpl__AccountId__c = account.Id,
                                                       Name = 'Test - Contact - Address',
                                                       dmpl__AddressType__c = 'Both'                                                      
                                                      ));
        insert contactAddress;
        
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
    
    private static void CreateSaleInvoice()
    {
        List<dmpl__SaleInvoice__c> saleInvoice = new List<dmpl__SaleInvoice__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__DiscountGroup__c discountGroup = [Select Id,Name From dmpl__DiscountGroup__c LIMIT 1];
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        Account customerAccount = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
        //dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        saleInvoice.Add(new dmpl__SaleInvoice__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                 dmpl__BranchId__c = Branch.Id,
                                                 dmpl__DiscountGroupId__c =  discountGroup.Id,                                               
                                                 dmpl__DocumentDate__c = Date.today(),
                                                 dmpl__SaleOrderId__c = saleOrder.id,
                                                 dmpl__AccountId__c = customerAccount.Id,
                                                 //dmpl__SalesExecutiveId__c = resource.Id,
                                                 dmpl__FinanceAmount__c = 100,
                                                 dmpl__AmountPaid__c =10
                                                ));
        insert saleInvoice;
        
    }
    
    private static void CreateDiscountGroup()
    {
        List<dmpl__DiscountGroup__c> discountGroup = new List<dmpl__DiscountGroup__c>();
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        discountGroup.add(new dmpl__DiscountGroup__c( Name = 'Test - Discount - Group',
                                                     dmpl__DiscountType__c ='Sale Price',
                                                     dmpl__IsDefault__c = true,
                                                     dmpl__IsActive__c = false,
                                                     dmpl__PartnerAccountId__c = partnerAccount.Id,
                                                     dmpl__BranchId__c = branch.Id
                                                    ) );
        
        insert discountGroup;
        
    }
    private static void CreateCreditNoteAndDebitNote()
    {
        dmpl__CreditNote__c creditNote= new dmpl__CreditNote__c ( 
            dmpl__DocumentDate__c=date.today());
        insert creditNote;
        dmpl__DebitNote__c debitNote= new dmpl__DebitNote__c ( 
            dmpl__DocumentDate__c=date.today());
        insert debitNote;
    }
    
    private static void CreateNewPayment()
    {
        List<dmpl__Payment__c> payment = new List<dmpl__Payment__c>();
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        System.debug('saleOrder'+saleOrder);
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
        System.debug('payment'+payment);
        dmpl__CreditNote__c creditNote = [SELECT Id,Name FROM dmpl__CreditNote__c];
        System.debug('creditNote'+creditNote);
        dmpl__DebitNote__c debitNote = [SELECT Id,Name FROM dmpl__DebitNote__c];
        System.debug('debitNote'+debitNote);
        List<dmpl__PaymentAdjustment__c> paymentAdjustment = new List<dmpl__PaymentAdjustment__c>();
        paymentAdjustment.add(new dmpl__PaymentAdjustment__c(
            dmpl__PaymentId__c = payment[0].Id,
            dmpl__SaleOrderId__c = saleOrder.Id
            //dmpl__SaleInvoiceId__c = saleInvoice.Id,
            //dmpl__CreditNoteId__c = creditNote.Id
            //dmpl__DebitNoteId__c = debitNote.Id
        ));
        
        insert paymentAdjustment;
        
        
    }
    
    private static void CreateNewPayment1()
    {
        List<dmpl__Payment__c> payment = new List<dmpl__Payment__c>();
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        System.debug('saleOrder'+saleOrder);
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
        System.debug('payment'+payment);
        dmpl__CreditNote__c creditNote = [SELECT Id,Name FROM dmpl__CreditNote__c];
        System.debug('creditNote'+creditNote);
        dmpl__DebitNote__c debitNote = [SELECT Id,Name FROM dmpl__DebitNote__c];
        System.debug('debitNote'+debitNote);
        List<dmpl__PaymentAdjustment__c> paymentAdjustment = new List<dmpl__PaymentAdjustment__c>();
        paymentAdjustment.add(new dmpl__PaymentAdjustment__c(
            dmpl__PaymentId__c = payment[0].Id,
            //dmpl__SaleOrderId__c = saleOrder.Id,
            //dmpl__SaleInvoiceId__c = saleInvoice.Id
            dmpl__CreditNoteId__c = creditNote.Id
            //dmpl__DebitNoteId__c = debitNote.Id
        ));
        
        insert paymentAdjustment;
        
        
    }
    
    private static void CreateNewPayment2()
    {
        List<dmpl__Payment__c> payment = new List<dmpl__Payment__c>();
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        System.debug('saleOrder'+saleOrder);
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
        System.debug('payment'+payment);
        dmpl__CreditNote__c creditNote = [SELECT Id,Name FROM dmpl__CreditNote__c];
        System.debug('creditNote'+creditNote);
        dmpl__DebitNote__c debitNote = [SELECT Id,Name FROM dmpl__DebitNote__c];
        System.debug('debitNote'+debitNote);
        List<dmpl__PaymentAdjustment__c> paymentAdjustment = new List<dmpl__PaymentAdjustment__c>();
        paymentAdjustment.add(new dmpl__PaymentAdjustment__c(
            dmpl__PaymentId__c = payment[0].Id,
            //dmpl__SaleOrderId__c = saleOrder.Id,
            //dmpl__SaleInvoiceId__c = saleInvoice.Id
            //dmpl__CreditNoteId__c = creditNote.Id
            dmpl__DebitNoteId__c = debitNote.Id
        ));
        
        insert paymentAdjustment;
        
        
    }
    
    private static void CreateNewPayment3()
    {
        List<dmpl__Payment__c> payment = new List<dmpl__Payment__c>();
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        System.debug('saleOrder'+saleOrder);
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
        System.debug('payment'+payment);
        dmpl__CreditNote__c creditNote = [SELECT Id,Name FROM dmpl__CreditNote__c];
        System.debug('creditNote'+creditNote);
        dmpl__DebitNote__c debitNote = [SELECT Id,Name FROM dmpl__DebitNote__c];
        System.debug('debitNote'+debitNote);
        List<dmpl__PaymentAdjustment__c> paymentAdjustment = new List<dmpl__PaymentAdjustment__c>();
        paymentAdjustment.add(new dmpl__PaymentAdjustment__c(
            dmpl__PaymentId__c = payment[0].Id,
            //dmpl__SaleOrderId__c = saleOrder.Id,
            dmpl__SaleInvoiceId__c = saleInvoice.Id
            //dmpl__CreditNoteId__c = creditNote.Id
            //dmpl__DebitNoteId__c = debitNote.Id
        ));
        
        insert paymentAdjustment;
        
        
    }
     private static void CreateNewPayment4()
    {
        List<dmpl__Payment__c> payment = new List<dmpl__Payment__c>();
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        System.debug('saleOrder'+saleOrder);
        dmpl__SaleInvoice__c saleInvoice = [Select Id,Name From dmpl__SaleInvoice__c LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        Account customerAccount = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
         Account Supplier = [Select Id,Name From Account WHERE dmpl__IsSupplierAccount__c = True LIMIT 1];
        
         List<dmpl__PurchaseOrder__c> purchaseOrder = new List<dmpl__PurchaseOrder__c>();
        purchaseOrder.add(new dmpl__PurchaseOrder__c(dmpl__BranchId__c = branch.Id,
                                                     dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                     dmpl__SupplierAccountId__c = Supplier.Id,
                                                     dmpl__PurchaseOrderType__c ='VOR PO',
                                                     dmpl__DocumentDate__c = Date.today(),
                                                     dmpl__TCSEligibleAmount__c = 100,
                                                     dmpl__Remarks__c = 'Remark'));
        insert purchaseOrder;
        
        
        payment.Add(new dmpl__Payment__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                         dmpl__BranchId__c = branch.Id,
                                         dmpl__AccountId__c = customerAccount.Id,
                                         dmpl__PaymentDate__c = Date.today(),
                                         dmpl__Amount__c = 1000,
                                         dmpl__PaymentMode__c = 'Cash',
                                         dmpl__SaleInvoiceId__c = saleInvoice.Id,
                                         dmpl__SaleOrderId__c = saleOrder.Id));
        insert payment;
        System.debug('payment'+payment);
        dmpl__CreditNote__c creditNote = [SELECT Id,Name FROM dmpl__CreditNote__c];
        System.debug('creditNote'+creditNote);
        dmpl__DebitNote__c debitNote = [SELECT Id,Name FROM dmpl__DebitNote__c];
        System.debug('debitNote'+debitNote);
        List<dmpl__PaymentAdjustment__c> paymentAdjustment = new List<dmpl__PaymentAdjustment__c>();
        paymentAdjustment.add(new dmpl__PaymentAdjustment__c(
            dmpl__PaymentId__c = payment[0].Id,
            //dmpl__SaleOrderId__c = saleOrder.Id,
            dmpl__PurchaseOrderId__c = purchaseOrder[0].Id
            //dmpl__CreditNoteId__c = creditNote.Id
            //dmpl__DebitNoteId__c = debitNote.Id
        ));
        
        insert paymentAdjustment;
        
        
    }
      private static void CreateNewPayment5()
    {
        List<dmpl__Payment__c> payment = new List<dmpl__Payment__c>();
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        System.debug('saleOrder'+saleOrder);
        dmpl__SaleInvoice__c saleInvoice = [Select Id,Name From dmpl__SaleInvoice__c LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        Account customerAccount = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
         Account Supplier = [Select Id,Name From Account WHERE dmpl__IsSupplierAccount__c = True LIMIT 1];
         List<dmpl__RepairOrder__c> repairOrder = new List<dmpl__RepairOrder__c> ();
           repairOrder.Add(new dmpl__RepairOrder__c (
            dmpl__BranchId__c = branch.Id,
            dmpl__AccountId__c = customerAccount.Id,
            dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
            dmpl__UsageReading__c = 8
                 ));
        
        insert repairOrder;
        payment.Add(new dmpl__Payment__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                         dmpl__BranchId__c = branch.Id,
                                         dmpl__AccountId__c = customerAccount.Id,
                                         dmpl__PaymentDate__c = Date.today(),
                                         dmpl__Amount__c = 1000,
                                         dmpl__PaymentMode__c = 'Cash',
                                         dmpl__SaleInvoiceId__c = saleInvoice.Id,
                                         dmpl__SaleOrderId__c = saleOrder.Id));
        insert payment;
        System.debug('payment'+payment);
        dmpl__CreditNote__c creditNote = [SELECT Id,Name FROM dmpl__CreditNote__c];
        System.debug('creditNote'+creditNote);
        dmpl__DebitNote__c debitNote = [SELECT Id,Name FROM dmpl__DebitNote__c];
        System.debug('debitNote'+debitNote);
        List<dmpl__PaymentAdjustment__c> paymentAdjustment = new List<dmpl__PaymentAdjustment__c>();
        paymentAdjustment.add(new dmpl__PaymentAdjustment__c(
            dmpl__PaymentId__c = payment[0].Id,
            //dmpl__SaleOrderId__c = saleOrder.Id,
            dmpl__RepairOrderId__c = repairOrder[0].Id
            //dmpl__CreditNoteId__c = creditNote.Id
            //dmpl__DebitNoteId__c = debitNote.Id
        ));
        
        insert paymentAdjustment;
        
        
    }
    
}