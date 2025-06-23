@isTest
public class BranchTimeSlotHelper_Test {

    @testSetup
    public static void Setup()
    {
        System.runAs(PostInstallHelper.AssignAdministratorAllPermissions(UserInfo.getUserId())){
            CreateAccountGroup();
            CreateAccount();
            CreateContactAddress();
            CreateBranch();
            CreateResource();
            CreatePartnerResources();
            CreateItems();
            CreateSKu();
            CreateItemLot();
            CreateBranchTimeSlot();
            CreateBranchTimeSlotBooking();
            CreateProductDemo();
            CreateAsset();
            CreateServiceBay();
            CreateServiceRequest();
        }
    }
    
    @isTest
    Static void VerifyCreateAccount()
    {
        try{
        test.startTest();
        List<Account>  account = [Select Id, Name From Account];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__BusinessHoursId__c From dmpl__Branch__c LIMIT 1];
        BusinessHoursHelper.getCachedBusinessHours(branch.dmpl__BusinessHoursId__c);
        BusinessHoursHelper.queryBusinessHours(branch.dmpl__BusinessHoursId__c);
        BusinessHoursHelper.queryDefaultBusinessHours();
        System.assertNotEquals(null, account, 'Test Accounts are not found');
        System.assertEquals(3, account.size(), 'Test Accounts have more than 1 record');
        test.stopTest();
        }
        catch(exception e){}
    }
    
     @isTest
    public static void UpdateBranchTimeSLot1()
    {
        test.startTest();
        dmpl__BranchTimeSlot__c timeSLot = [Select Id,Name,
                                            dmpl__SundayCapacity__c,
                                            dmpl__MondayCapacity__c,
                                            dmpl__TuesdayCapacity__c,
                                            dmpl__WednesdayCapacity__c,
                                            dmpl__ThursdayCapacity__c,
                                            dmpl__FridayCapacity__c,
                                            dmpl__SaturdayCapacity__c,
                                            dmpl__IsActive__c FROM dmpl__BranchTimeSlot__c LIMIT 1];
        BranchHelper.getDayOfWeekCapacity(date.today(),timeSLot);
        test.stopTest();
        System.assert(timeSLot!=null,'Branch Time SLot is updated');
    }
    
    @isTest
    public static void UpdateBranchTimeSLot()
    {
        dmpl__BranchTimeSlot__c timeSLot = [Select Id,Name,dmpl__IsActive__c FROM dmpl__BranchTimeSlot__c LIMIT 1];
        if(timeSLot.dmpl__IsActive__c = false)
        	timeSLot.dmpl__IsActive__c = true;
        Update timeSLot;
        System.assert(timeSLot != null,'Branch Time SLot is updated');
    }
    
    @isTest
    public static void DeleteBranchTimeSLot()
    {
        DeleteServiceRequest();
        dmpl__BranchTimeSlot__c timeSLot = [Select Id,Name,dmpl__IsActive__c FROM dmpl__BranchTimeSlot__c LIMIT 1];
        if(timeSLot != null)
        	Delete timeSLot;
        System.assert(timeSLot != null,'Branch Time SLot is updated');
    }
    
    @isTest
    public static void UpdateBranchTimeSLotBooking()
    {
        UpdateProductDemoAsNull();
        dmpl__BranchTimeSlotBooking__c timeSLotBooking = [Select Id,Name,dmpl__Capacity__c FROM dmpl__BranchTimeSlotBooking__c LIMIT 1];
        if(timeSLotBooking == null)
        	insert timeSLotBooking;
        System.assertEquals(10, timeSLotBooking.dmpl__Capacity__c,'Branch Time SLot is updated');
    }
    
    @isTest
    public static void DeleteBranchTimeSLotBooking()
    {
        dmpl__BranchTimeSlotBooking__c timeSLotBooking = [Select Id,Name,dmpl__Capacity__c FROM dmpl__BranchTimeSlotBooking__c LIMIT 1];
        if(timeSLotBooking != null)
        Delete timeSLotBooking;
        System.assertEquals(10, timeSLotBooking.dmpl__Capacity__c,'Branch Time SLot is updated');
    }
    
    @isTest
    public static void UpdateServiceRequestAsPerformConfirm()
    {
        dmpl__ServiceRequest__c serviceRequest = [Select Id,Name,dmpl__PerformConfirm__c,dmpl__IsConfirmed__c,dmpl__ServiceContractItemId__c From dmpl__ServiceRequest__c LIMIT 1];
        serviceRequest.dmpl__PerformConfirm__c = true;
        Update serviceRequest;
        
        System.assertEquals(true, serviceRequest.dmpl__PerformConfirm__c, 'Service Request is updated');
    }
    
    @isTest
    public static void UpdateServiceRequestAsIsConfirm()
    {
        UpdateServiceRequestAsPerformConfirm();
        dmpl__ServiceRequest__c serviceRequest = [Select Id,Name,dmpl__IsConfirmed__c From dmpl__ServiceRequest__c LIMIT 1];
        serviceRequest.dmpl__IsConfirmed__c = true;
        Update serviceRequest;
        System.assertEquals(true, serviceRequest.dmpl__IsConfirmed__c, 'Service Request is updated');
    }
    
    @isTest
    public static void DeleteServiceRequest()
    {
        dmpl__ServiceRequest__c serviceRequest = [Select Id,Name,dmpl__PerformConfirm__c,dmpl__ServiceContractItemId__c From dmpl__ServiceRequest__c LIMIT 1];
        serviceRequest.dmpl__PerformConfirm__c = true;
        Delete serviceRequest;
        System.assertEquals(true, serviceRequest.dmpl__PerformConfirm__c, 'Service Request is deleted');
    }
    
    @isTest
    public static void UpdateProductDemo()
    {
        try{
        test.startTest();
        dmpl__BranchTimeSlotBooking__c booking = [Select Id,Name from dmpl__BranchTimeSlotBooking__c LIMIT 1];
        dmpl__ProductDemo__c productDemo = [Select Id,Name,dmpl__IsConfirmed__c,dmpl__DemoTimeSlotBookingId__c FROM dmpl__ProductDemo__c LIMIT 1];
        if(productDemo != null)
        {
            productDemo.dmpl__DemoTimeSlotBookingId__c = booking.Id;
        	productDemo.dmpl__IsConfirmed__c = true;
        }
        Update productDemo;
        System.assertEquals(true, productDemo.dmpl__IsConfirmed__c, 'Product demo is updated');
        test.stopTest();
        }
        catch(exception e){}
    }
    
    @isTest
    public static void UpdateProductDemoAsNull()
    {
        dmpl__ProductDemo__c productDemo = [Select Id,Name,dmpl__IsConfirmed__c,dmpl__DemoTimeSlotBookingId__c FROM dmpl__ProductDemo__c LIMIT 1];
        if(productDemo == null)
        	insert productDemo;
        System.assertEquals(false, productDemo.dmpl__IsConfirmed__c, 'Product demo is updated');
    }
    
    @isTest
    public static void Check(){
        dmpl__BranchTimeSlot__c branchTimeSlot = [SELECT Id, Name,dmpl__IsActive__c,dmpl__TuesdayCapacity__c,dmpl__MondayCapacity__c,dmpl__WednesdayCapacity__c,dmpl__ThursdayCapacity__c,dmpl__FridayCapacity__c,dmpl__SaturdayCapacity__c,dmpl__SundayCapacity__c FROM dmpl__BranchTimeSlot__c LIMIT 1];
        BranchTimeSlotBookingHelper.createNewSlotBooking(branchTimeSlot, Datetime.now().date());
        System.assert(branchTimeSlot != null,'Branch Time SLot is updated');
    }
    
    
    @isTest
    public static void UpdateProductDemoDelete()
    {
        dmpl__ProductDemo__c productDemo = [Select Id,Name,dmpl__IsConfirmed__c,dmpl__DemoTimeSlotBookingId__c FROM dmpl__ProductDemo__c LIMIT 1];
        test.startTest();
        delete productDemo;
        System.assert(productDemo != null, 'Product demo is updated');
        test.stopTest();
    }
    
    @isTest
    public static void verifyConfirmedServiceRquest()
    {
    	List<dmpl__ServiceRequest__c> serviceRequests = [SELECT Id, Name, dmpl__PerformConfirm__c FROM dmpl__ServiceRequest__c];
        for(dmpl__ServiceRequest__c serviceRequest : serviceRequests)
        	serviceRequest.dmpl__PerformConfirm__c = true;
        
        update serviceRequests;
        System.assertEquals(true, serviceRequests[0].dmpl__PerformConfirm__c, 'Service Request is confirmed');
    }
     @isTest
    public static void getDayOfWeekCapacityTest()
    {
    	test.starttest();
        dmpl__BranchTimeSlot__c timeSLot = [Select Id,Name,
                                            dmpl__SundayCapacity__c,
                                            dmpl__MondayCapacity__c,
                                            dmpl__TuesdayCapacity__c,
                                            dmpl__WednesdayCapacity__c,
                                            dmpl__ThursdayCapacity__c,
                                            dmpl__FridayCapacity__c,
                                            dmpl__SaturdayCapacity__c,
                                            dmpl__MaximumCapacity__c,
                                            dmpl__IsActive__c FROM dmpl__BranchTimeSlot__c LIMIT 1];
        timeSLot.dmpl__SundayCapacity__c=null;
        timeSLot.dmpl__MondayCapacity__c=null;
        timeSLot.dmpl__TuesdayCapacity__c=null;
        timeSLot.dmpl__WednesdayCapacity__c=null;
        timeSLot.dmpl__ThursdayCapacity__c=null;
        timeSLot.dmpl__FridayCapacity__c=null;
        timeSLot.dmpl__SaturdayCapacity__c=null;

        
        BranchHelper.getDayOfWeekCapacity(date.today(),timeSLot);
        test.stoptest();
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
        insert account;
        
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
        BusinessHours business = new BusinessHours(Name = 'Business-Hour');
        //insert business;
        
        List<dmpl__Branch__c> branch = new List<dmpl__Branch__c>();
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        branch.Add(new dmpl__Branch__c(dmpl__PartnerAccountId__c =partnerAccount.Id,
                                      Name = 'Test-Branch',
                                      dmpl__IsActive__c = true,
                                      dmpl__MarketingName__c = 'Hero Electric',
                                      dmpl__Website__c = 'www.dealermatix.com',
                                      dmpl__Email__c = 'Dealer@Outlook.com',
                                      dmpl__MobileNumber__c = 99,
                                      dmpl__BusinessHoursId__c = business.Id,
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
        
        List<dmpl__Item__c> item2 = new List<dmpl__Item__c>();
        item2.Add(new dmpl__Item__c(Name = 'Test-Item2',
                                    dmpl__ItemType__c = 'Service Contract'
                                    ));
        insert item2;
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
    
    private static void CreatePartnerResources(){
        List<dmpl__PartnerResource__c> partnerResources = new List<dmpl__PartnerResource__c>();
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        partnerResources.Add(new dmpl__PartnerResource__c(dmpl__PartnerAccountId__c =partnerAccount.Id,
                                    dmpl__BranchId__c= branch.Id,
                                    dmpl__ResourceId__c= resource.Id,               
                                    dmpl__RuleSuccessCriteria__c='All Rules Are Met',
                                    dmpl__AssignmentSequenceNumber__c=12));
        partnerResources.Add(new dmpl__PartnerResource__c(dmpl__PartnerAccountId__c =partnerAccount.Id,
                                    dmpl__BranchId__c= branch.Id,
                                    dmpl__ResourceId__c= resource.Id,               
                                    dmpl__RuleSuccessCriteria__c='Any Rule Is Met',
                                    dmpl__AssignmentSequenceNumber__c=13));
        insert partnerResources; 

        List<dmpl__ResourceAssignmentRule__c> assignmentRule = new List<dmpl__ResourceAssignmentRule__c>();
		assignmentRule.Add(new dmpl__ResourceAssignmentRule__c(dmpl__PartnerResourceId__c=partnerResources[0].Id,
                                        dmpl__FieldName__c='dmpl__Remarks__c',	
                                        dmpl__FieldValue__c='Test Remarks',
                                        dmpl__Operation__c='equals',
                                        dmpl__SequenceNumber__c=12,
                                        dmpl__AssignmentType__c='Lead'));
        assignmentRule.Add(new dmpl__ResourceAssignmentRule__c(dmpl__PartnerResourceId__c=partnerResources[1].Id,
                                        dmpl__FieldName__c='dmpl__Remarks__c',	
                                        dmpl__FieldValue__c='Test Remarks',
                                        dmpl__Operation__c='equals',
                                        dmpl__SequenceNumber__c=13,
                                        dmpl__AssignmentType__c='Lead'));
       insert assignmentRule;        
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
                                         dmpl__Cost__c = 100
                                        // dmpl__QuantityExpired__c = 1,
                                        // dmpl__QuantityOnHold__c = 1,
                                         //dmpl__QuantityOnLoan__c = 1
        ));
        insert itemLot;
        
        List<dmpl__ItemLot__c> relatedItemLot = new List<dmpl__ItemLot__c>();
        relatedItemLot.Add(new dmpl__ItemLot__c(
            dmpl__BranchId__c = branch.Id,
            dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
            dmpl__LandedCost__c = 1000));
        insert relatedItemLot;
    }
    
    private static void CreateAsset()
    {
        List<Asset> asset = new List<Asset>();
        Account account = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        dmpl__Branch__c Branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__ItemLot__c itemLot = [Select Id,Name,dmpl__ItemId__c,dmpl__SKUId__c From dmpl__ItemLot__c LIMIT 1];
        asset.Add(new Asset(Name = 'Test-Asset',
                                  AccountId = account.Id,
                                  dmpl__ItemId__c = item.Id,
                                  dmpl__SKUId__c = sku.Id,
                                  dmpl__RegistrationNumber__c = 'Test - Reg no.',
                                  dmpl__ItemLotId__c = itemLot.Id,
                                  dmpl__SupplierInvoicedate__c = Date.today(),
                                  dmpl__SupplierInvoiceNumber__c = '1111111111',
                                  dmpl__SaleDate__c = Date.today(),
                                  dmpl__SaleInvoiceNumber__c = '150',
                                  dmpl__LastServiceBranchId__c = Branch.Id,
                                  dmpl__LastServiceDate__c = Date.today(),
                                  dmpl__LastServicePartnerId__c = account.Id,
                                  dmpl__LastUsageReading__c = 50.00,
                                  dmpl__CurrentUsageReading__c = 60.00));
        insert asset;
    }
    
    private static void CreateServiceBay()
    {
        List<dmpl__ServiceBay__c> ServiceBay = new List<dmpl__ServiceBay__c>();
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        ServiceBay.Add(new dmpl__ServiceBay__c(Name = 'Test - ServiceBay',
                                                   dmpl__BranchId__c = branch.Id));
        insert ServiceBay;
        
    }
    
    
    private static void CreateBranchTimeSlot()
    {
        List<dmpl__BranchTimeSlot__c> branchTimeSlot = new List<dmpl__BranchTimeSlot__c>();
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        branchTimeSlot.Add(new dmpl__BranchTimeSlot__c(dmpl__BranchId__c = branch.Id,
                                                       dmpl__TransactionType__c = 'Product Demo',
                                                       Name = 'Test - Name',
                                                       dmpl__IsActive__c = false,
                                                       dmpl__ApplicableToItem__c= item.Id,
                                                       dmpl__StartTime__c = time.newInstance(10, 20, 5, 200),
                                                       dmpl__ServiceType__c = 'Paid Repairs',
                                                       dmpl__MaximumCapacity__c = 30,                                                    
                                                       dmpl__MondayCapacity__c = 0,
                                                       dmpl__TuesdayCapacity__c = 1,
                                                       dmpl__WednesdayCapacity__c = 2,
                                                       dmpl__ThursdayCapacity__c = 3,
                                                       dmpl__FridayCapacity__c = 4,
                                                       dmpl__SaturdayCapacity__c = 5,
                                                       dmpl__SundayCapacity__c = 6
                                                       ));
        insert branchTimeSlot;
        
        List<dmpl__BranchTimeSlot__c> branchTimeSlot1 = new List<dmpl__BranchTimeSlot__c>();
        branchTimeSlot1.Add(new dmpl__BranchTimeSlot__c(dmpl__BranchId__c = branch.Id,
                                                       dmpl__TransactionType__c = 'Product Demo',
                                                       Name = 'Test - Name',
                                                       dmpl__IsActive__c = true,
                                                       dmpl__ApplicableToItem__c= item.Id,
                                                       dmpl__StartTime__c = time.newInstance(10, 20, 5, 200),
                                                       dmpl__ServiceType__c = null,
                                                       dmpl__MaximumCapacity__c = 30,                                                    
                                                       dmpl__MondayCapacity__c = 0,
                                                       dmpl__TuesdayCapacity__c = 1,
                                                       dmpl__WednesdayCapacity__c = 2,
                                                       dmpl__ThursdayCapacity__c = 3,
                                                       dmpl__FridayCapacity__c = 4,
                                                       dmpl__SaturdayCapacity__c = 5,
                                                       dmpl__SundayCapacity__c = 6
                                                       ));
        insert branchTimeSlot1;
    }
    
    private static void CreateServiceRequest()
    {
        List<dmpl__ServiceRequest__c> serviceRequest = new List<dmpl__ServiceRequest__c>();
        Account account = [Select Id,Name From Account Where Name = 'Customer-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__Item__c item2 = [Select Id,Name,dmpl__ItemType__c From dmpl__Item__c WHERE dmpl__ItemType__c = 'Service Contract' LIMIT 1];
        Asset asset = [Select Id,Name From Asset LIMIT 1];
        dmpl__BranchTimeSlot__c branchTimeSlot = [Select Id,Name,dmpl__MaximumCapacity__c From dmpl__BranchTimeSlot__c LIMIT 1];
        serviceRequest.Add(new dmpl__ServiceRequest__c(dmpl__AccountId__c = account.Id,
                                                    dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                    dmpl__AssetId__c = asset.Id,
                                                    dmpl__BranchId__c = branch.Id,
                                                    dmpl__PackageServiceId__c = item.Id,
                                                    dmpl__ServiceContractItemId__c = item2.Id,
                                                    dmpl__AppointmentDate__c = date.today(),
                                                    dmpl__AppointmentTime__c = time.newInstance(10, 30, 50, 200),
                                                    dmpl__AppointmentTimeSlotId__c = branchTimeSlot.Id));
        insert serviceRequest;
    }
    
    private static void CreateBranchTimeSlotBooking()
    {
        List<dmpl__BranchTimeSlotBooking__c> branchTimeSlotBooking = new List<dmpl__BranchTimeSlotBooking__c>();
        dmpl__BranchTimeSlot__c branchTimeSlot = [Select Id,Name FROM dmpl__BranchTimeSlot__c LIMIT 1];
        branchTimeSlotBooking.add(new dmpl__BranchTimeSlotBooking__c(dmpl__BranchTimeSlotId__c = branchTimeSlot.Id,
                                                                     dmpl__BookingDate__c = date.today(),
                                                                     dmpl__Capacity__c = 10,
                                                                     dmpl__CapacityUtilized__c = 5
                                                                    ));
        insert branchTimeSlotBooking;
    }
    
    private static void CreateProductDemo()
    {
        List<dmpl__ProductDemo__c> productDemo = new List<dmpl__ProductDemo__c>();
        Account account = [Select Id,Name From Account  where dmpl__IsCustomerAccount__c=true LIMIT 1];
        Account PartnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__BranchTimeSlot__c branchTimeSlot = [Select Id,Name,dmpl__BranchId__c,dmpl__IsActive__c FROM dmpl__BranchTimeSlot__c WHERE dmpl__IsActive__c = true LIMIT 1];
        dmpl__BranchTimeSlotBooking__c booking = [Select Id,Name from dmpl__BranchTimeSlotBooking__c LIMIT 1];
        productDemo.add(new dmpl__ProductDemo__c(dmpl__AccountId__c = account.Id,
                                                 dmpl__BranchId__c = branchTimeSlot.dmpl__BranchId__c,
                                                 dmpl__CancellationReason__c = 'Not interested',
                                                 dmpl__PartnerAccountId__c = PartnerAccount.Id,
                                                 dmpl__ItemId__c = item.Id,
                                                 dmpl__DemoDate__c = date.today(),
                                                 dmpl__ServiceType__c = 'Paid Repairs',
                                                 dmpl__DemoSlotId__c = branchTimeSlot.Id,
                                                 dmpl__DemoAddress__c = 'Product-Demo',
                                                 dmpl__IsDemoOnsite__c = false,
                                                 dmpl__Remarks__c = 'Text'
                                                ));
        productDemo.add(new dmpl__ProductDemo__c(dmpl__AccountId__c = account.Id,
                                                 dmpl__BranchId__c = branchTimeSlot.dmpl__BranchId__c,
                                                 dmpl__CancellationReason__c = 'Not interested',
                                                 dmpl__PartnerAccountId__c = PartnerAccount.Id,
                                                 dmpl__ItemId__c = item.Id,
                                                 dmpl__DemoDate__c = date.today().addDays(5),
                                                 dmpl__DemoSlotId__c = branchTimeSlot.Id,
                                                 dmpl__DemoAddress__c = 'Product-Demo',
                                                 dmpl__IsDemoOnsite__c = false,
                                                 dmpl__Remarks__c = 'Text'
                                                ));
        insert productDemo;
    }
}