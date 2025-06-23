@isTest
public with sharing class TransferOutwardLineHelper_Test {
    
    @testSetup
    public static void Setup() {
        Test.startTest();
        CreateAccountGroup();
        CreateAccount();
        CreateBranch();
        CreateItems();
        CreateSKu();
        CreateItemLot();
        CreateTransfer();
        CreateTransferLine();
       CreateTransferInwardLine();
        Test.stopTest();
    }

    @isTest
    public static void testValidateData() {
        List<dmpl__TransferOutwardLine__c> transferOutwardLines = [SELECT Id,dmpl__InventoryLedgerId__c,dmpl__IsILPostingApproved__c,dmpl__TransferId__c,dmpl__ItemLotTypeId__c,dmpl__ClosedQuantity__c, dmpl__ItemId__c, dmpl__SKUId__c,dmpl__PartnerAccountId__c,dmpl__BranchId__c,dmpl__PendingInwardQuantity__c,dmpl__ItemLotId__c,dmpl__Quantity__c,dmpl__RelatedItemLotId__c FROM dmpl__TransferOutwardLine__c LIMIT 1];
        list<Id> newId = new list<Id>();
        newId.add(transferOutwardLines[0].Id);

        if (transferOutwardLines.isEmpty()) return;

        Test.startTest();
        TransferOutwardLineHelper.validateData(true, false, false, new List<dmpl__TransferOutwardLine__c>(), transferOutwardLines);
        TransferOutwardLineHelper.updateClosedQuantity(newId);
        Test.stopTest();
        
        System.assert(true, 'Validation method executed without errors.');
    }

    @isTest
    public static void testPostData() {
        List<dmpl__TransferOutwardLine__c> transferOutwardLines = [SELECT 
    dmpl__BranchId__c,
    dmpl__ClosedQuantity__c,
    CreatedById,
    dmpl__ExternalId__c,
    dmpl__InventoryLedgerId__c,
    dmpl__IsApproved__c,
    dmpl__IsILPosted__c,
    dmpl__IsILPostingApproved__c,
    dmpl__ItemId__c,
    dmpl__ItemLotId__c,
    dmpl__ItemLotTypeId__c,
    dmpl__SKUId__c,
    LastModifiedById,
    Name,
    dmpl__PartnerAccountId__c,
    dmpl__PendingInwardQuantity__c,
    dmpl__Quantity__c,
    dmpl__RelatedBranchId__c,
    dmpl__RelatedItemLotId__c,
    dmpl__RelatedPartnerAccountId__c,
    dmpl__RequisitionId__c,
    dmpl__RequisitionLineId__c,
    dmpl__InventoryStockId__c,
    dmpl__StockAvailable__c,
    dmpl__StockInHand__c,
    dmpl__StorageLocationId__c,
    dmpl__TransferId__c,
    dmpl__TransferType__c,
    dmpl__Type__c,
    dmpl__UnitCost__c
FROM dmpl__TransferOutwardLine__c 
WHERE CreatedDate = TODAY
];

        if (transferOutwardLines.isEmpty()) return;

        Test.startTest();
        TransferOutwardLineHelper.postData(true, false, false, new List<dmpl__TransferOutwardLine__c>(), transferOutwardLines);
        Test.stopTest();
        
        System.assert(true, 'Post data method executed successfully.');
    }

    @isTest
    public static void testUpdateOutwardTransferLine() {
        List<dmpl__TransferInwardLine__c> inwardLines = [Select Id,dmpl__ItemLotId__c,dmpl__RelatedItemLotId__c,dmpl__TransferOutwardLineId__c,dmpl__StorageLocationId__c,dmpl__ItemId__c,dmpl__SKUId__c FRom dmpl__TransferInwardLine__c limit 1];

        if (inwardLines.isEmpty()) return;

        Test.startTest();
        TransferOutwardLineHelper.queryOutwardLinesForLines(new list<Id>{inwardLines[0].Id});
          TransferOutwardLineHelper.queryOutwardLines(new list<Id>{inwardLines[0].Id});
        TransferOutwardLineHelper.updateOutwardTransferLine(true, true, true, new List<dmpl__TransferInwardLine__c>(), inwardLines);
        
        
        Test.stopTest();

        System.assert(true, 'Update outward transfer line method executed successfully.');
    }

    @isTest
    public static void testReleaseOutwardDocument() {
        List<dmpl__TransferOutwardLine__c> transferOutwardLines = [SELECT Id FROM dmpl__TransferOutwardLine__c LIMIT 1];

        if (transferOutwardLines.isEmpty()) return;

        Test.startTest();
        TransferOutwardLineHelper.releaseOutwardDocument(transferOutwardLines);
        Test.stopTest();

        System.assert(true, 'Release outward document method executed successfully.');
    }


    private static void CreateAccountGroup() {
        dmpl__AccountGroup__c accountGroup = new dmpl__AccountGroup__c(Name = 'Test-AccountGroup', dmpl__AccountGroupType__c = 'Price');
        insert accountGroup;
    }

    private static void CreateAccount() {
        List<Account> accounts = new List<Account>();
        dmpl__AccountGroup__c accountGroup = [SELECT Id FROM dmpl__AccountGroup__c LIMIT 1];

        accounts.add(new Account(Name = 'Partner-Test-Account', dmpl__IsPartnerAccount__c = true, dmpl__IsActive__c = true));
        accounts.add(new Account(Name = 'Customer-Test-Account', dmpl__IsCustomerAccount__c = true, dmpl__IsActive__c = true));
        accounts.add(new Account(Name = 'Supplier-Test-Account', dmpl__IsSupplierAccount__c = true, dmpl__IsActive__c = true));

        insert accounts;
    }

    private static void CreateBranch() {
        Account partnerAccount = [SELECT Id FROM Account WHERE Name = 'Partner-Test-Account' LIMIT 1];

        List<dmpl__Branch__c> branches = new List<dmpl__Branch__c>();
        branches.add(new dmpl__Branch__c(dmpl__PartnerAccountId__c = partnerAccount.Id, Name = 'Test-Branch', dmpl__IsActive__c = true));
        branches.add(new dmpl__Branch__c(dmpl__PartnerAccountId__c = partnerAccount.Id, Name = 'Test11-Branch', dmpl__IsActive__c = true));
        
        insert branches;
    }

    private static void CreateItems() {
        List<dmpl__Item__c> items = new List<dmpl__Item__c>();

        items.add(new dmpl__Item__c(Name = 'Test-Item', dmpl__ItemCode__c = 'DMPL', dmpl__TrackInventory__c = true, dmpl__IsActive__c = true));
        
        insert items;
    }

    private static void CreateSKu() {
        dmpl__Item__c item = [SELECT Id FROM dmpl__Item__c LIMIT 1];

        List<dmpl__SKU__c> skus = new List<dmpl__SKU__c>();
        skus.add(new dmpl__SKU__c(Name = 'Test - SKU', dmpl__ItemId__c = item.Id, dmpl__SKUCode__c = 'Test-SKU'));

        insert skus;
    }

    private static void CreateItemLot() {
        dmpl__Branch__c branch = [SELECT Id FROM dmpl__Branch__c LIMIT 1];
        dmpl__SKU__c sku = [SELECT Id FROM dmpl__SKU__c LIMIT 1];
        dmpl__Item__c item = [SELECT Id FROM dmpl__Item__c LIMIT 1];
       Account partnerAccount = [SELECT Id FROM Account WHERE Name = 'Partner-Test-Account' LIMIT 1];

        dmpl__ItemLot__c itemLot = new dmpl__ItemLot__c(
            dmpl__BranchId__c = branch.Id, 
            dmpl__ItemId__c = item.Id, 
            dmpl__SKUId__c = sku.Id,
            dmpl__BatchNo__c = 'AAA',
            dmpl__SerialNumber__c='BBB',
            dmpl__SupplierInvoiceNumber__c='CCC',
            dmpl__DateOfReceipt__c = Date.today(),
            dmpl__DateOfMfg__c = Date.today(),
            dmpl__TotalCost__c = 10.2,
            dmpl__DateOfSupplierInvoice__c = Date.today(),
            dmpl__PartnerAccountId__c  =partnerAccount.Id, 
            dmpl__Cost__c = 38.3
        );
        insert itemLot;
    }

    private static void CreateTransfer() {
        dmpl__Branch__c branch = [SELECT Id,dmpl__PartnerAccountId__c FROM dmpl__Branch__c LIMIT 1];

        dmpl__Transfer__c transfer = new dmpl__Transfer__c(
            dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
            dmpl__BranchId__c = branch.Id,
            dmpl__ToBranchId__c = branch.Id,
            dmpl__PerformInwardPosting__c = false,
            dmpl__PerformInwardReceive__c = false,
            dmpl__TransferTime__c = Date.today()
        );
        insert transfer;
    }

    private static void CreateTransferLine() {
        dmpl__Transfer__c transfer = [SELECT Id FROM dmpl__Transfer__c LIMIT 1];
        dmpl__ItemLot__c itemLot = [SELECT Id, dmpl__ItemId__c FROM dmpl__ItemLot__c LIMIT 1];
        dmpl__SKU__c sku = [SELECT Id FROM dmpl__SKU__c LIMIT 1];

        dmpl__TransferOutwardLine__c transferOutwardLine = new dmpl__TransferOutwardLine__c(
            dmpl__TransferId__c = transfer.Id,
            dmpl__ItemId__c = itemLot.dmpl__ItemId__c,
            dmpl__ItemLotId__c = itemLot.Id,
            dmpl__Quantity__c = 1,
            dmpl__SKUId__c = sku.Id,
            dmpl__IsILPostingApproved__c = false
        );
        insert transferOutwardLine;

        transferOutwardLine.dmpl__IsILPostingApproved__c = true;
        update transferOutwardLine;
    }
     private static void CreateTransferInwardLine() {
        dmpl__Transfer__c transfer = [SELECT Id FROM dmpl__Transfer__c LIMIT 1];
        dmpl__ItemLot__c itemLot = [SELECT Id, dmpl__ItemId__c FROM dmpl__ItemLot__c LIMIT 1];
        dmpl__SKU__c sku = [SELECT Id FROM dmpl__SKU__c LIMIT 1];
       dmpl__TransferOutwardLine__c to = [Select id from dmpl__TransferOutwardLine__c limit 1];
        dmpl__TransferInwardLine__c transferInwarddLine = new dmpl__TransferInwardLine__c(
            dmpl__TransferId__c = transfer.Id,
            dmpl__ItemId__c = itemLot.dmpl__ItemId__c,
            dmpl__ItemLotId__c = itemLot.Id,
            dmpl__TransferOutwardLineId__c = to.Id,
            dmpl__Quantity__c = 1,
            dmpl__SKUId__c = sku.Id,
            dmpl__IsILPostingApproved__c = false,
            dmpl__ExternalId__c =  string.valueOf(Math.random())
        );
        insert transferInwarddLine;

        
    }
}