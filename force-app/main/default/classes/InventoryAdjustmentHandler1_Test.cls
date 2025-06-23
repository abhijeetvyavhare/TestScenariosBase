@isTest
public with sharing class InventoryAdjustmentHandler1_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__InventoryAdjustment__c adjustment = AdjustmentTestDataHelpers.CreateAdjustment(branch);
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation(branch);
        dmpl__ItemLot__c itemLot = TestDataHelpers.createItemLot(branch, item, sku, storageLocation);
        dmpl__InventoryAdjustmentLine__c adjustmentLine = AdjustmentTestDataHelpers.CreateAdjustmentLine(item,sku, storageLocation, itemLot, adjustment);
    }

    @isTest
    static void createInventoryAdjustmentPositive() {
        dmpl__InventoryAdjustment__c adjustment = AdjustmentTestDataHelpers.getAdjustment();
        System.assertNotEquals(null, adjustment, 'Delivery Order Line should be created successfully.');
        System.assertEquals('Draft', adjustment.dmpl__Status__c, 'Inventory Adjustment status must be Draft');
    }

    @isTest
    static void updateInventoryAdjustmentPositive() {
        dmpl__InventoryAdjustment__c adjustment = AdjustmentTestDataHelpers.getAdjustment();
        System.assertNotEquals(null, adjustment, 'Inventory Adjustment should exist before update.');
        adjustment.dmpl__Status__c = 'Draft';
        update adjustment;
        dmpl__InventoryAdjustment__c adjustmentUpdated = AdjustmentTestDataHelpers.getAdjustment(adjustment.Id);
        System.assertEquals('Draft', adjustmentUpdated.dmpl__Status__c, 'Inventory Adjustment status must Updated to Draft');
    }

    @isTest
    static void createInventoryAdjustmentLinePositive() {
        dmpl__InventoryAdjustmentLine__c adjustmentLine = AdjustmentTestDataHelpers.getAdjustmentLine();
        System.assertNotEquals(null, adjustmentLine, 'Inventory Adjustment Line should be created successfully.');
        System.assertEquals(100, adjustmentLine.dmpl__TotalCost__c, 'Inventory Adjustment Line TotalCost must be 100');
    }

    @isTest
    static void updateInventoryAdjustmentLinePositive() {
        dmpl__InventoryAdjustmentLine__c adjustmentLine = AdjustmentTestDataHelpers.getAdjustmentLine();
        System.assertNotEquals(null, adjustmentLine, 'Inventory Adjustment Lineshould exist before update.');
        adjustmentLine.dmpl__TotalCost__c = 90;
        update adjustmentLine;
        dmpl__InventoryAdjustmentLine__c adjustmentLineUpdated = AdjustmentTestDataHelpers.getAdjustmentLine(adjustmentLine.Id);
        System.assertEquals(90, adjustmentLineUpdated.dmpl__TotalCost__c, 'Inventory Adjustment Line Totalcost must Updated to 90');
    }

    @isTest
    static void deleteInventoryAdjustmentLine() {
        dmpl__InventoryAdjustmentLine__c adjustmentLine = AdjustmentTestDataHelpers.getAdjustmentLine();
        System.assertNotEquals(null, adjustmentLine, 'InventoryAdjustmentLine should exist before delete.');

        delete adjustmentLine;

        dmpl__InventoryAdjustmentLine__c deletedLine;
        try {
            deletedLine = AdjustmentTestDataHelpers.getAdjustmentLine(adjustmentLine.Id);
        } catch (Exception e) {
            deletedLine = null;
        }
        System.assertEquals(null, deletedLine, 'InventoryAdjustmentLine should be deleted and not found in query.');
    }

    @isTest
    static void deleteInventoryAdjustment() {
        dmpl__InventoryAdjustment__c adjustment = AdjustmentTestDataHelpers.getAdjustment();
        System.assertNotEquals(null, adjustment, 'InventoryAdjustment should exist before delete.');

        delete adjustment;

        dmpl__InventoryAdjustment__c deletedAdjustment;
        try {
            deletedAdjustment = AdjustmentTestDataHelpers.getAdjustment(adjustment.Id);
        } catch (Exception e) {
            deletedAdjustment = null;
        }
        System.assertEquals(null, deletedAdjustment, 'InventoryAdjustment should be deleted and not found in query.');
    }
}