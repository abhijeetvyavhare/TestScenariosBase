@isTest
public class InventoryConsoleController_Test {
    
    @testSetup
    private static void TestSetup(){
        Account partnerAccount = new Account(
            Name = 'Salesforce, Inc.',
            Type = 'Technology Partner',
            Website = 'http://www.salewsforce.com',
            Phone = '1-800-NO-SOFTWARE',
            dmpl__Status__c = 'Created',
            dmpl__ShippingStreet__c = 'Salesforce Tower, 415 Mission Street, 3rd Floor',
            dmpl__ShippingState__c = 'None',
            dmpl__ShippingRegion__c    = 'San Francisco',
            dmpl__ShippingPostalCode__c    = '94105',
            dmpl__ShippingCountry__c = 'None',
            dmpl__ShippingCity__c = 'None',
            dmpl__Salutation__c = 'Mr.',
            dmpl__LastName__c = ' Benioff',
            dmpl__FirstName__c = 'Marc Russell',
            dmpl__IsSupplierAccount__c = true,
            dmpl__IsPartnerAccount__c = true,
            dmpl__IsCustomerAccount__c = true,
            dmpl__IsActive__c = true,
            dmpl__Email__c = 'info@salesforce.com',
            dmpl__AccountSource__c = 'Direct'
        );
        insert partnerAccount;
        
        dmpl__Branch__c branch = new dmpl__Branch__c(
            Name = 'Test-Branch',
            dmpl__PartnerAccountId__c = partnerAccount.Id,
            dmpl__IsActive__c = true,
            dmpl__MarketingName__c = 'Hero Electric',
            dmpl__AllowInventory__c = true,
            dmpl__AllowPurchase__c = true,
            dmpl__AllowSales__c = true,
            dmpl__AllowService__c = true,
            dmpl__BranchType__c = 'SalesBranch',
            dmpl__IsHomeDeliveryAvailable__c = true,
            dmpl__IsPickupDropAvailable__c = true
        );
        insert branch;
        
        List<dmpl__Item__c> items = new List<dmpl__Item__c>();
        items.add(new dmpl__Item__c(
            Name = 'Test-Item',
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
            dmpl__RFID__c = 'O1234fgh'));
        insert items;
    }
    
    @isTest
    public static void testGetLedgerData() {
        List<Account> accounts = [SELECT Id FROM Account LIMIT 1];
        List<dmpl__Branch__c> branches = [SELECT Id FROM dmpl__Branch__c LIMIT 1];
        List<dmpl__Item__c> items = [SELECT Id FROM dmpl__Item__c LIMIT 1];
        
        if(!accounts.isEmpty() && !branches.isEmpty() && !items.isEmpty()) {
            Id partnerAccountId = accounts[0].Id;
            Id branchId = branches[0].Id;
            Id itemId = items[0].Id;
            
            List<dmpl__InventoryLedger__c> ledgerData = InventoryConsoleController.getLedgerData(itemId, branchId, partnerAccountId, Date.today(), Date.today());
            System.assertNotEquals(ledgerData, null, 'Ledger data should not be null');
        }else{
            System.assert(false, 'Test records are not available');
        }
    }
    
    @isTest
    public static void testGetOpeningStock() {
        List<Account> accounts = [SELECT Id FROM Account LIMIT 1];
        List<dmpl__Branch__c> branches = [SELECT Id FROM dmpl__Branch__c LIMIT 1];
        List<dmpl__Item__c> items = [SELECT Id FROM dmpl__Item__c LIMIT 1];
        
        if(!accounts.isEmpty() && !branches.isEmpty() && !items.isEmpty()) {
            Id partnerAccountId = accounts[0].Id;
            Id branchId = branches[0].Id;
            Id itemId = items[0].Id;
            List<AggregateResult> openingStock = InventoryConsoleController.getOpeningStock(itemId, branchId, partnerAccountId, Date.today());
            System.assertNotEquals(openingStock, null, 'Opening stock should not be null');
        }else{
            System.assert(false, 'Test records are not available');
        }
    }
    
    @isTest
    public static void testGetStock() {
        List<Account> accounts = [SELECT Id FROM Account LIMIT 1];
        List<dmpl__Branch__c> branches = [SELECT Id FROM dmpl__Branch__c LIMIT 1];
        if(!accounts.isEmpty() && !branches.isEmpty()) {
            Id partnerAccountId = accounts[0].Id;
            Id branchId = branches[0].Id;
            List<AggregateResult> stock = InventoryConsoleController.getStock(branchId, partnerAccountId, Date.today());
            System.assertNotEquals(stock, null, 'Stock should not be null');
        }else {
            System.assert(false, 'Test records are not available');
        }
    }
}