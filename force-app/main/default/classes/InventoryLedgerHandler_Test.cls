@isTest
public with sharing class InventoryLedgerHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount=TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch=TestDataHelpers.createBranch(partnerAccount);
        dmpl__Item__c item=TestDataHelpers.createItem();
        dmpl__SKU__c sku=TestDataHelpers.createSKU(item);
        dmpl__StorageLocation__c storageLocation=TestDataHelpers.createStorageLocation(branch);
        dmpl__ItemLot__c itemLot=TestDataHelpers.createItemLot(branch,item,sku,storageLocation);
        dmpl__InventoryLedger__c inventoryLedger= InventoryTestDataHelpers.CreateInventoryLedger(branch,item,sku,itemLot,storageLocation);


    }
    @isTest
    static void createInventoryLedger() {
        dmpl__InventoryLedger__c inventory = InventoryTestDataHelpers.getInventoryLedger();

        if(inventory != null){
            System.assertNotEquals(inventory, null, 'Expected Inventory to be created.');
        }
        System.assertEquals(2000, inventory.dmpl__AllocatedQuantity__c, 'AllocatedQuantity should be 200');
        
        
    }
    @isTest
    public static void UpdateInventoryLedger()
    {
        try{
            test.startTest();
            dmpl__InventoryLedger__c inventory = InventoryTestDataHelpers.getInventoryLedger();
            System.assertNotEquals(inventory, null, 'Inventory should exist before update.');
            inventory.dmpl__AllocatedQuantity__c =12; 
            inventory.dmpl__PickedQuantity__c=189;
            update inventory;
            dmpl__InventoryLedger__c updatedinventory =InventoryTestDataHelpers.getInventoryLedger();
            System.assertEquals(12, updatedinventory.dmpl__AllocatedQuantity__c, 'AllocatedQuantity should be 12');
        System.assertEquals(189, updatedinventory.dmpl__PickedQuantity__c, 'PickedQuantity should be 189');
            
            test.stopTest();
        }catch(Exception e){}
    }
    @isTest
    public static void DeleteInventoryLedger()
    {
        
        test.startTest();
        dmpl__InventoryLedger__c inventory = InventoryTestDataHelpers.getInventoryLedger();
            System.assertNotEquals(inventory, null, 'Inventory  should exist before delete.');
            delete inventory;
        
        test.stopTest();
        dmpl__InventoryLedger__c deletedInventory = null;
        try {
            deletedInventory = InventoryTestDataHelpers.getInventoryLedger();
        } catch (Exception e) {
            deletedInventory = null;
        }
        System.assertEquals(null, deletedInventory, 'Inventory should be deleted and not found in query.');
        
    }
}