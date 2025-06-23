@isTest
public class FailedPartController_Test {

    @testSetup
    public static void Setup() {
        test.startTest();
        createAccount();
        createBranch();
        createItem();
        createPriceList();
        createRepairOrder();
        createRepairOrderLine();
        test.StopTest();
    }

    @isTest
    public static void getJobCardTest(){
        test.startTest();
        dmpl__Branch__c branch=[SELECT Id FROM dmpl__Branch__c LIMIT 1];
        dmpl__RepairOrderLine__c repairOrderLine=[SELECT Id,dmpl__FailedItemTreatment__c FROM dmpl__RepairOrderLine__c LIMIT 1];
        FailedPartController.getJobCard('dmpl__RepairOrderLine__c',repairOrderLine.dmpl__FailedItemTreatment__c,branch.Id);
        test.stopTest();
    }

    @isTest
    public static void updateDestinationTest(){
        test.startTest();
        List<dmpl__RepairOrderLine__c> repairOrderLines=[SELECT Id,dmpl__FailedItemTreatment__c FROM dmpl__RepairOrderLine__c];
        repairOrderLines[0].dmpl__FailedItemTreatment__c='Scrap';
        FailedPartController.updateDestination(repairOrderLines);
        test.stopTest();
    }

    @isTest
    public static void createDeliveryOrderFromJobCardTest(){
        test.startTest();
        List<dmpl__RepairOrderLine__c> repairOrderLines=[
            SELECT Id,
            dmpl__Quantity__c,
            dmpl__RepairOrderId__c,
            dmpl__ItemId__c,
            dmpl__FailedItemTreatment__c,
            dmpl__FailedItemDeliveredQuantity__c,
            dmpl__ItemId__r.dmpl__FailedItemId__c,
            dmpl__RepairOrderId__r.dmpl__BranchId__c
            FROM dmpl__RepairOrderLine__c
            ];

            repairOrderLines[0].dmpl__FailedItemTreatment__c='Scrap';
            repairOrderLines[1].dmpl__FailedItemTreatment__c='Send to Supplier';
            update repairOrderLines;
        List<String> ls=new List<String>();
        for(dmpl__RepairOrderLine__c record: repairOrderLines){
            ls.add(String.valueOf(record.Id));
        }
        dmpl__Branch__c branch=[SELECT Id FROM dmpl__Branch__c LIMIT 1];
        FailedPartController.createDeliveryOrderFromJobCard(ls,branch.Id,'Scrap');
        test.stopTest();
    }

    private static void createAccount()
    {
        dmpl__AccountGroup__c accountGroup= new dmpl__AccountGroup__c (Name= 'Test-AccountGroup',
                                                                       dmpl__AccountGroupType__c='Scheme');
        insert accountGroup;
       
        List<Account> account = new List<Account>();
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
                                dmpl__IsPartnerAccount__c = true,
                                dmpl__IsSupplierAccount__c = true,
                                dmpl__IsActive__c = True,
                                dmpl__IsTaxExempted__c = True,
                                dmpl__IsCustomerAccount__c = true,
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
                                             dmpl__IsCustomerAccount__c = True,
                                             dmpl__IsActive__c = true);
        insert partneraccount;
       
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__LastName__c = 'Sale Order',
                                              dmpl__IsCustomerAccount__c = True,
                                              dmpl__IsActive__c = true);
        insert customerAccount;
    }
 
    private static void createItem(){
        Account supplierAccount=[SELECT Id, Name FROM Account WHERE dmpl__IsSupplierAccount__c=True];
 
        dmpl__Item__c failedItem=new dmpl__Item__c(Name = 'Test-Item',
                                   dmpl__ItemCode__c = 'DMPL',
                                   dmpl__ItemType__c = 'Service Contract',
                                   dmpl__ItemSubType__c = '',
                                   dmpl__Description__c = '',
                                   dmpl__ItemFamily__c = 'Sample',
                                   dmpl__ItemSegment__c = 'Sample',
                                   dmpl__Make__c = 'Sample',
                                   dmpl__Model__c = 'Sample',
                                   dmpl__TrackInventory__c = true,
                                   dmpl__TrackLots__c = true,
                                   dmpl__RequireInspectionOnReceipt__c = true,
                                   dmpl__RequireInspectionOnDelivery__c = true,
                                   dmpl__AllowService__c = true,
                                   dmpl__TrackAsset__c = true,                              
                                   dmpl__IsActive__c = true,
                                   dmpl__IsRegistrationRequired__c = true,
                                   dmpl__GTIN__c = 'BR123',
                                   dmpl__RFId__c = 'O1234fgh',
                                   dmpl__ClaimToAccountId__c=supplierAccount.Id
                                  );
        insert failedItem;
 
        List<dmpl__Item__c> item = new List<dmpl__Item__c>();
        item.Add(new dmpl__Item__c(Name = 'Test-Item11',
                                   dmpl__TrackInventory__c = true,
                                   dmpl__TrackLots__c = true,
                                   dmpl__RequireInspectionOnReceipt__c = true,
                                   dmpl__RequireInspectionOnDelivery__c = true,
                                   dmpl__AllowService__c = true,
                                   dmpl__TrackAsset__c = true,                              
                                   dmpl__IsActive__c = true,
                                   dmpl__ClaimToAccountId__c=supplierAccount.Id,
                                   dmpl__FailedItemId__c=failedItem.Id
                                  ));
        item.Add(new dmpl__Item__c(Name = 'Test-Item12',
                                  dmpl__TrackInventory__c = true,
                                  dmpl__TrackLots__c = true,
                                  dmpl__IsSKURequired__c = true,
                                  dmpl__RequireInspectionOnReceipt__c = true,
                                  dmpl__RequireInspectionOnDelivery__c = true,
                                  dmpl__AllowService__c = true,
                                  dmpl__TrackAsset__c = true,                              
                                  dmpl__IsActive__c = true,
                                  dmpl__ClaimToAccountId__c=supplierAccount.Id,
                                  dmpl__FailedItemId__c=failedItem.Id
                                 ));
        insert item;
    }

    private static voId createBranch()
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

 private static voId createRepairOrder()
    {
        List<dmpl__RepairOrder__c> repairOrder = new List<dmpl__RepairOrder__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        //dmpl__Resource__c resource = [select Id,Name FROM dmpl__Resource__c LIMIT 1];
        dmpl__PriceList__c priceList=[Select Id, Name from dmpl__PriceList__c Limit 1];
        Account customerAccount = [Select Id,Name From Account Where Name = 'Customer-Test-Account' LIMIT 1];
        repairOrder.Add(new dmpl__RepairOrder__c (
            dmpl__PriceListId__c=priceList.Id,
            dmpl__BranchId__c = branch.Id,
            dmpl__AccountId__c = customerAccount.Id,
            dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
            dmpl__UsageReading__c = 8
            //dmpl__ServiceAdvisorId__c = resource.Id
        ));
        insert repairOrder;
    }

    private static void createRepairOrderLine()
    {
        List<dmpl__RepairOrderLine__c> repairOrderLine = new List<dmpl__RepairOrderLine__c>();
        dmpl__RepairOrder__c repairOrder = [Select Id,Name FROM dmpl__RepairOrder__c LIMIT 1];
        dmpl__Item__c item1=[SELECT Id FROM dmpl__Item__c WHERE Name='Test-Item11' LIMIT 1];
        dmpl__Item__c item2=[SELECT Id FROM dmpl__Item__c WHERE Name='Test-Item12' LIMIT 1];
        repairOrderLine.add(new dmpl__RepairOrderLine__c(dmpl__ItemId__c = item1.Id,
                                                         dmpl__Quantity__c = 5,
                                                         dmpl__CancelledQuantity__c=3,
                                                         dmpl__UnitPrice__c = 10,
                                                         dmpl__PackageClassification__c = 'Optional Item',
                                                         dmpl__ActionTaken__c = 'Replace',
                                                         dmpl__WorkStartedBy__c = date.today(),
                                                         dmpl__WorkEndedAt__c = date.today(),
                                                         dmpl__WorkStatus__c = 'Started',
                                                         dmpl__StandardDurationHours__c = 10,
                                                         dmpl__ActualDurationHours__c = 10,
                                                         dmpl__FailedItemTreatment__c='Scrap',
                                                         dmpl__RepairOrderId__c = repairOrder.Id,
                                                         dmpl__FailedItemDeliveredQuantity__c=0
                                                        ));
        repairOrderLine.add(new dmpl__RepairOrderLine__c(dmpl__ItemId__c = item2.Id,
                                                        dmpl__Quantity__c = 5,
                                                        dmpl__CancelledQuantity__c=3,
                                                        dmpl__UnitPrice__c = 10,
                                                        dmpl__PackageClassification__c = 'Optional Item',
                                                        dmpl__ActionTaken__c = 'Replace',
                                                        dmpl__WorkStartedBy__c = date.today(),
                                                        dmpl__WorkEndedAt__c = date.today(),
                                                        dmpl__WorkStatus__c = 'Started',
                                                        dmpl__StandardDurationHours__c = 10,
                                                        dmpl__ActualDurationHours__c = 10,
                                                        dmpl__FailedItemTreatment__c='Send to Supplier',
                                                        dmpl__RepairOrderId__c = repairOrder.Id,
                                                        dmpl__FailedItemDeliveredQuantity__c=0
                                                       ));

        insert repairOrderLine;
    }

    private static voId createPriceList()
    {
        List<dmpl__PriceList__c> priceLists = new List<dmpl__PriceList__c>();
        Account account = [Select Id,Name From Account Where Name = 'Partner-Test-Account'  Limit 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        priceLists.add(new dmpl__PriceList__c (Name = 'Test-Price',
                                               dmpl__PartnerAccountId__c = account.Id,
                                               dmpl__BranchId__c = branch.Id,
                                               dmpl__PriceListType__c = 'Sale Price',
                                               dmpl__IsActive__c = true,
                                               dmpl__IsDefault__c = true
                                              ));
        insert priceLists;
    }
      
    private static voId createAsset()
    {
        List<Asset> asset = new List<Asset>();
        Account account = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        dmpl__Branch__c Branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        asset.Add(new Asset(Name = 'Test-Asset',
                                  AccountId = account.Id,
                                  dmpl__ItemId__c = item.Id,
                                  dmpl__RegistrationNumber__c = 'Test - Reg no.',
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
    
}