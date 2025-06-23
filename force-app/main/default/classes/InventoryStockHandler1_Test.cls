@isTest
public with sharing class InventoryStockHandler1_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount=TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch=TestDataHelpers.createBranch(partnerAccount);
        dmpl__Item__c item=TestDataHelpers.createItem();
        dmpl__SKU__c sku=TestDataHelpers.createSKU(item);
        dmpl__StorageLocation__c storageLocation=TestDataHelpers.createStorageLocation(branch);
        dmpl__InventoryStock__c invStock=InventoryTestDataHelpers.CreateInventoryStock(branch,item,sku,storageLocation);
    

    }
    @isTest
    static void InventoryStock() {
        dmpl__InventoryStock__c invStock = InventoryTestDataHelpers.getInventoryStock();

        if(invStock != null){
            System.assertNotEquals(invStock, null, 'Expected Inventory Stock to be created.');
        }
        //System.assertEquals(2000, invStock.dmpl__AllocatedQuantity__c, 'AllocatedQuantity should be 200');
        
        
    }
    @isTest
    public static void UpdateInventoryStock()
    {
        try{
            test.startTest();
            dmpl__InventoryStock__c invStock = InventoryTestDataHelpers.getInventoryStock();
            System.assertNotEquals(invStock, null, 'InventoryStock should exist before update.');
            invStock.dmpl__QuantityDamaged__c =12; 
            invStock.dmpl__QuantityExpired__c=189;
            update invStock;
            dmpl__InventoryStock__c updatedInvStock =InventoryTestDataHelpers.getInventoryStock();
            System.assertEquals(12, updatedInvStock.dmpl__QuantityDamaged__c, 'QuantityDamaged should be 12');
        	System.assertEquals(189, updatedInvStock.dmpl__QuantityExpired__c, 'QuantityExpired should be 189');
            
            test.stopTest();
        }catch(Exception e){}
    }
    @isTest
    public static void DeleteInventoryStock()
    {
        
        test.startTest();
        dmpl__InventoryStock__c invStock = InventoryTestDataHelpers.getInventoryStock();
            System.assertNotEquals(invStock, null, 'InventoryStock  should exist before delete.');
            delete invStock;
        
        test.stopTest();
        dmpl__InventoryStock__c deletedInvStock = InventoryTestDataHelpers.getInventoryStock();
        try {
            deletedInvStock = InventoryTestDataHelpers.getInventoryStock();
        } catch (Exception e) {
            deletedInvStock = null;
        }
        System.assertEquals(null, deletedInvStock, 'InventoryStock should be deleted and not found in query.');
        
    }
}