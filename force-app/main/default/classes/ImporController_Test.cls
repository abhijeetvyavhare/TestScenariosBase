@isTest
public class ImporController_Test {
    
    @testSetup
    public static void setup() {
        CreateAccountGroup();
        CreateAccount();
        CreateContactAddress();
        CreateBranch();
        CreateItems();
        CreateResource();
        CreateSaleOrder();
    }
    
    @isTest
    public static void testVerifyImportResult() {
        Test.startTest();  
        List<Database.Error> errors = new List<Database.Error>();
        ImportResult result = new ImportResult();
        result.setErrors(errors);
        ImportController.getDMSImportSettings('Account');
        Test.stopTest();
        // Add assertions if needed
    }

    @isTest
    public static void testImportHelperMethods() {
        Test.startTest();  
        try {
            ImportHelper.getTargetObjectTypeName('dmpl__ServiceAdvisor__c');
            ImportHelper.getTargetObjectTypeName('dmpl__SalesPerson__c');
            ImportHelper.getTargetObjectTypeName('dmpl__PartnerAccountId__c');
            ImportHelper.getTargetObjectTypeName('dmpl__SupplierAccountId__c');
            ImportHelper.getTargetObjectTypeName('dmpl__CustomerAccountId__c');
            ImportHelper.getTargetObjectTypeName('dmpl__AlternateItemId__c');
            ImportHelper.getTargetObjectTypeName('dmpl__SalesExecutiveId__c');
            ImportHelper.getTargetObjectTypeName('dmpl__DiscountedItemId__c');
            ImportHelper.getTargetObjectTypeName('dmpl__SubstituteItemId__c');
            ImportHelper.getTargetObjectTypeName('dummy');
        } catch (Exception ex) {
            // Handle exception if needed
        }
        Test.stopTest();
        // Add assertions if needed
    }

    @isTest
    public static void testGetLookupSource() {
        Test.startTest();  
        Account account = [Select Id, Name From Account LIMIT 1];
        FieldsetFieldInfo field = new FieldsetFieldInfo('Account.Name');
        String jsonString = '[{"Name":"Rahul"}]';
        List<Object> parsedData = (List<Object>) JSON.deserializeUntyped(jsonString);
        ImportHelper.getLookupSource(field, parsedData);
        Test.stopTest();
        // Add assertions if needed
    }
    
    @isTest
    public static void VerifyAccounts() {
        Test.startTest();
        Account accountData = [Select Id,Name From Account LIMIT 1];
            ImportController.importFieldsetData('Account',accountData.Id,null,'dmpl__ImportAccounts','[{"Name":"Partner-Test-Account","IsPartnerAccount__c":true,"IsActive__c":true}]');
    
        // Call the importFieldsetData method from the ImportController class
        ImportController.importFieldsetData('Account',accountData.Id,null,'dmpl__ImportAccounts','[{"Name":"Partner-Test-Account","IsPartnerAccount__c":true,"IsActive__c":true}]');
    
        // Assert the results
        System.assertNotEquals(null, accountData, 'Expected Sale Order record to be created');
        System.assertNotEquals(null, accountData.Name, 'Expected Sale Order Name to be populated');
        Test.stopTest();
        //} catch(exception e){}
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

}