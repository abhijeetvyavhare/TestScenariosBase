@isTest
public with sharing class InventoryAdjustmentHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__InventoryAdjustment__c adjustment = InventoryAdjustmentDataHelper.CreateAdjustment(branch);
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation(branch);
        dmpl__ItemLot__c itemLot = TestDataHelpers.createItemLot(branch, item, sku, storageLocation);
        dmpl__InventoryAdjustmentLine__c adjustmentLine = InventoryAdjustmentDataHelper.CreateAdjustmentLine(item,sku, storageLocation, itemLot, adjustment);
    }

    @isTest
    static void createInventoryAdjustmentPositive() {
        dmpl__InventoryAdjustment__c adjustment = InventoryAdjustmentDataHelper.getAdjustment();
        System.assertNotEquals(null, adjustment, 'Inventory Adjustment should be created successfully.');
        System.assertEquals('Draft', adjustment.dmpl__Status__c, 'Inventory Adjustment status must be Draft');
    }

    @isTest
    static void createInventoryAdjustmentLinePositive() {
        dmpl__InventoryAdjustmentLine__c adjustmentLine = InventoryAdjustmentDataHelper.getAdjustmentLine();
        System.assertNotEquals(null, adjustmentLine, 'Inventory Adjustment Line should be created successfully.');
        System.assertEquals(100, adjustmentLine.dmpl__TotalCost__c, 'Inventory Adjustment Line TotalCost must be 100');
    }

    @isTest
    static void updateInventoryAdjustmentPositive() {
        dmpl__InventoryAdjustment__c adjustment = InventoryAdjustmentDataHelper.getAdjustment();
        System.assertNotEquals(null, adjustment, 'Inventory Adjustment should exist before update.');
        adjustment.dmpl__Status__c = 'Approved';
        update adjustment;
        dmpl__InventoryAdjustment__c adjustmentUpdated = InventoryAdjustmentDataHelper.getAdjustment(adjustment.Id);
        System.assertEquals('Approved', adjustmentUpdated.dmpl__Status__c, 'Inventory Adjustment status must Updated to Approved');
    }

    @isTest
    static void updateInventoryAdjustmentLinePositive() {
        dmpl__InventoryAdjustmentLine__c adjustmentLine = InventoryAdjustmentDataHelper.getAdjustmentLine();
        System.assertNotEquals(null, adjustmentLine, 'Inventory Adjustment Lineshould exist before update.');
        adjustmentLine.dmpl__TotalCost__c = 90;
        update adjustmentLine;
        dmpl__InventoryAdjustmentLine__c adjustmentLineUpdated = InventoryAdjustmentDataHelper.getAdjustmentLine(adjustmentLine.Id);
        System.assertEquals(90, adjustmentLineUpdated.dmpl__TotalCost__c, 'Inventory Adjustment Line Totalcost must Updated to 90');
    }

    @isTest
    static void deleteInventoryAdjustmentLine() {
        dmpl__InventoryAdjustmentLine__c adjustmentLine = InventoryAdjustmentDataHelper.getAdjustmentLine();
        System.assertNotEquals(null, adjustmentLine, 'InventoryAdjustmentLine should exist before delete.');

        delete adjustmentLine;

        dmpl__InventoryAdjustmentLine__c deletedLine;
        try {
            deletedLine = InventoryAdjustmentDataHelper.getAdjustmentLine(adjustmentLine.Id);
        } catch (Exception e) {
            deletedLine = null;
        }
        System.assertEquals(null, deletedLine, 'InventoryAdjustmentLine should be deleted and not found in query.');
    }

    @isTest
    static void deleteInventoryAdjustment() {
        dmpl__InventoryAdjustment__c adjustment = InventoryAdjustmentDataHelper.getAdjustment();
        System.assertNotEquals(null, adjustment, 'InventoryAdjustment should exist before delete.');

        delete adjustment;

        dmpl__InventoryAdjustment__c deletedAdjustment;
        try {
            deletedAdjustment = InventoryAdjustmentDataHelper.getAdjustment(adjustment.Id);
        } catch (Exception e) {
            deletedAdjustment = null;
        }
        System.assertEquals(null, deletedAdjustment, 'InventoryAdjustment should be deleted and not found in query.');
    }

    
    //Adjustment with Valid Product and Quantity (new)
    @isTest
    static void createAdjustmentWithValidProductAndQuantityPositive(){
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1', false, true, false, true, 'MG Road', 'Bengaluru', 'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India', '560095','9876543210');
        dmpl__Branch__c branch1=TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id, true, true, false, true);
        dmpl__InventoryAdjustment__c inventory = InventoryAdjustmentDataHelper.CreateAdjustment(
            branch1.Id,
            partnerAccount1.Id,
            Date.today()
        );

        dmpl__InventoryAdjustment__c fetchedInventory = InventoryAdjustmentDataHelper.getAdjustment(inventory.id);
        System.assertNotEquals(null, fetchedInventory, 'Fetched Inventory Adjustment should not be null');
        System.assertEquals(partnerAccount1.Id, fetchedInventory.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, fetchedInventory.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals('Draft', fetchedInventory.dmpl__Status__c, 'Status should be "Draft"');
        System.assertEquals(Date.today(), fetchedInventory.dmpl__DocumentDate__c, 'Document Date should be today\'s date');
    }
}