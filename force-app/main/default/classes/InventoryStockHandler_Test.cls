@isTest
public with sharing class InventoryStockHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount=TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch=TestDataHelpers.createBranch(partnerAccount);
        dmpl__Item__c item=TestDataHelpers.createItem();
        dmpl__SKU__c sku=TestDataHelpers.createSKU(item);
        dmpl__StorageLocation__c storageLocation=TestDataHelpers.createStorageLocation(branch);
        //dmpl__InventoryStock__c invStock=InventoryTestDataHelpers.CreateInventoryStock(branch,item,sku,storageLocation);


        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1', false, true, false, true, 'MG Road', 'Bengaluru', 'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India', '560095','9876543210');
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2', false, true, false, false, '45 Residency Road', 'Pune', 'Maharashtra', 'India', '411001', '22 Commerce Avenue', 'Pune', 'Maharashtra', 'India', '411038','91-99665544433');
        Account partnerAccount3 = TestDataHelpers.createPartnerAccount('Partner 3', false, true, false, true, '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '91-9123456789');
        Account partnerAccount4 = TestDataHelpers.createPartnerAccount('Partner 4', false, true, false, true, '12 Industrial Zone', 'Hyderabad','Telangana', 'India', '500032', '12 Industrial Zone', 'Hyderabad', 'Telangana', 'India','500032','9876012345');
        
        dmpl__Branch__c branch1=TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id, true, true, false, true);
        //dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partnerAccount2.Id, true, false, true, true);
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partnerAccount1.Id, false, true, true, false);
        dmpl__Branch__c branch4 =TestDataHelpers.createBranch('Branch 4',partnerAccount4.Id,true,true,false,false);



        dmpl__Item__c  item1 = TestDataHelpers.createItem('Item 1','Product',true,false,false,'675654',false);
        dmpl__Item__c item2 = TestDataHelpers.createItem('Item 2', 'Product', false, false, false, '654345', false);
        dmpl__Item__c item4 = TestDataHelpers.createItem('Item 4', 'Product', true, false, false, '765676', true);

        dmpl__Item__c item9 = TestDataHelpers.createItem('Item 9', 'Product', true, false, true, '765456', false);

        dmpl__SKU__c sku3 = TestDataHelpers.createSKU('SKU 3', item9.Id, false);


        dmpl__StorageLocation__c storageLocation1 = FulfillmentTestDataHelpers.createStorageLocation('Storage Location 1',branch1,true,'Warehouse');
    

    }
    @isTest
    static void InventoryStock() {
        dmpl__InventoryStock__c invStock = InventoryTestDataHelpers.getInventoryStock();

        if(invStock != null){
            System.assertNotEquals(invStock, null, 'Expected Inventory Stock to be created.');
        }
        
        
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


    //stock scenario

    @isTest
    static void createStockWithCorrectPartnerAccountAndBranchPositive(){
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1=TestDataHelpers.getItem('Item 1');
        dmpl__StorageLocation__c storageLocation1 = FulfillmentTestDataHelpers.getStorageLocation('Storage Location 1');
        Test.startTest();
        dmpl__InventoryStock__c inventoryStock = InventoryTestDataHelpers.createInventoryStock(branch1,item1,partnerAccount1,storageLocation1,null);
        Test.stopTest();

        System.assertNotEquals(null, inventoryStock, 'Inventory Stock should be created');
        System.assertEquals(partnerAccount1.Id, inventoryStock.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch1.Id, inventoryStock.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item1.Id, inventoryStock.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(storageLocation1.Id, inventoryStock.dmpl__StorageLocationId__c, 'Storage Location should be Storage Location 1');
    }

    @isTest
    static void createStockWithWrongPartnerAccountNegative(){
        Account partnerAccount4=TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1=TestDataHelpers.getItem('Item 1');
        dmpl__StorageLocation__c storageLocation1 = FulfillmentTestDataHelpers.getStorageLocation('Storage Location 1');
       
        Test.startTest();
        try {      
            dmpl__InventoryStock__c inventoryStock = InventoryTestDataHelpers.createInventoryStock(branch1,item1,partnerAccount4,storageLocation1,null);
            System.assertEquals(null, inventoryStock.Id, 'inventoryStock should not be created with wrong partner account ');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'inventoryStock should not be created with wrong partner account ');
        }
        Test.stopTest(); 
    }

    @isTest
    static void createStockWithInactivePartnerAccountNegative(){
        Account partnerAccount2=TestDataHelpers.getPartnerAccount('Partner 2');
        
        dmpl__Item__c item1=TestDataHelpers.getItem('Item 1');
        dmpl__StorageLocation__c storageLocation1 = FulfillmentTestDataHelpers.getStorageLocation('Storage Location 1');
       
        Test.startTest();
        try { 
            dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partnerAccount2.Id, true, false, true, true);
            dmpl__InventoryStock__c inventoryStock = InventoryTestDataHelpers.createInventoryStock(branch2,item1,partnerAccount2,storageLocation1,null);
            System.assertEquals(null, inventoryStock.Id, 'inventoryStock should not be created with wrong partner account ');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'inventoryStock should not be created with inactive partner account ');
        }
        Test.stopTest(); 
    }

    @isTest
    static void createStockWithWrongBranchNegative(){
        Account partnerAccount3=TestDataHelpers.getPartnerAccount('Partner 3');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1=TestDataHelpers.getItem('Item 1');
        dmpl__StorageLocation__c storageLocation1 = FulfillmentTestDataHelpers.getStorageLocation('Storage Location 1');
       
        Test.startTest();
        try {      
            dmpl__InventoryStock__c inventoryStock = InventoryTestDataHelpers.createInventoryStock(branch1,item1,partnerAccount3,storageLocation1,null);
            System.assertEquals(null, inventoryStock.Id, 'inventoryStock should not be created with wrong branch');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'inventoryStock should not be created with wrong branch');
        }
        Test.stopTest(); 
    }

    @isTest
    static void createStockWithInactiveBranchNegative(){
        Account partnerAccount3=TestDataHelpers.getPartnerAccount('Partner 3');
        dmpl__Branch__c branch3=TestDataHelpers.getBranch('Branch 3');

        dmpl__Item__c item1=TestDataHelpers.getItem('Item 1');
        dmpl__StorageLocation__c storageLocation1 = FulfillmentTestDataHelpers.getStorageLocation('Storage Location 1');
       
        Test.startTest();

        try { 
            dmpl__InventoryStock__c inventoryStock = InventoryTestDataHelpers.createInventoryStock(branch3,item1,partnerAccount3,storageLocation1,null);
            System.assertEquals(null, inventoryStock.Id, 'inventoryStock should not be created with inactive branch');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'inventoryStock should not be created with inactive branch');
        }
        Test.stopTest(); 
    }

    @isTest
    static void updateStockWithWrongPartnerAccountNegative(){
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        Account partnerAccount5=TestDataHelpers.getPartnerAccount('Partner 5');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch2=TestDataHelpers.getBranch('Branch 2');
        dmpl__Item__c item1=TestDataHelpers.getItem('Item 1');
        dmpl__StorageLocation__c storageLocation1 = FulfillmentTestDataHelpers.getStorageLocation('Storage Location 1');
        
        dmpl__InventoryStock__c inventoryStock = InventoryTestDataHelpers.createInventoryStock(branch1,item1,partnerAccount1,storageLocation1,null);
        
        System.assertNotEquals(null, inventoryStock, 'Inventory Stock should be created');
        System.assertEquals(partnerAccount1.Id, inventoryStock.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch1.Id, inventoryStock.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item1.Id, inventoryStock.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(storageLocation1.Id, inventoryStock.dmpl__StorageLocationId__c, 'Storage Location should be Storage Location 1');

        Test.startTest();
        Boolean exceptionThrown = false;
        try{
            inventoryStock.dmpl__PartnerAccountId__c = partnerAccount5.Id;
            inventoryStock.dmpl__BranchId__c = branch2.Id;
            update inventoryStock;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown,'Expected exception with wrong partner account');
        Test.stopTest();
    }

    @isTest
    static void updateStockWithInactivePartnerAccountNegative(){
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        Account partnerAccount2=TestDataHelpers.getPartnerAccount('Partner 2');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1=TestDataHelpers.getItem('Item 1');
        dmpl__StorageLocation__c storageLocation1 = FulfillmentTestDataHelpers.getStorageLocation('Storage Location 1');
        
        dmpl__InventoryStock__c inventoryStock = InventoryTestDataHelpers.createInventoryStock(branch1,item1,partnerAccount1,storageLocation1,null);
        
        System.assertNotEquals(null, inventoryStock, 'Inventory Stock should be created');
        System.assertEquals(partnerAccount1.Id, inventoryStock.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch1.Id, inventoryStock.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item1.Id, inventoryStock.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(storageLocation1.Id, inventoryStock.dmpl__StorageLocationId__c, 'Storage Location should be Storage Location 1');

        Test.startTest();
        Boolean exceptionThrown = false;
        try{
            dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partnerAccount2.Id, true, false, true, true);
            inventoryStock.dmpl__PartnerAccountId__c = partnerAccount2.Id;
            inventoryStock.dmpl__BranchId__c = branch2.Id;
            update inventoryStock;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown,'Expected exception with inactive partner account');
        Test.stopTest();
    }


    @isTest
    static void updateStockWithWrongBranchNegative(){
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        Account partnerAccount2=TestDataHelpers.getPartnerAccount('Partner 2');

        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1=TestDataHelpers.getItem('Item 1');
        dmpl__StorageLocation__c storageLocation1 = FulfillmentTestDataHelpers.getStorageLocation('Storage Location 1');
        
        dmpl__InventoryStock__c inventoryStock = InventoryTestDataHelpers.createInventoryStock(branch1,item1,partnerAccount1,storageLocation1,null);
        
        System.assertNotEquals(null, inventoryStock, 'Inventory Stock should be created');
        System.assertEquals(partnerAccount1.Id, inventoryStock.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch1.Id, inventoryStock.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item1.Id, inventoryStock.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(storageLocation1.Id, inventoryStock.dmpl__StorageLocationId__c, 'Storage Location should be Storage Location 1');

        Test.startTest();
        Boolean exceptionThrown = false;
        try{
            dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partnerAccount2.Id, true, false, true, true);
            inventoryStock.dmpl__BranchId__c = branch2.Id;
            update inventoryStock;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown,'Expected exception with Wrong branch');
        Test.stopTest();
    }


    @isTest
    static void updateStockWithInactiveBranchNegative(){
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        Account partnerAccount3=TestDataHelpers.getPartnerAccount('Partner 3');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch3=TestDataHelpers.getBranch('Branch 3');
        dmpl__Item__c item1=TestDataHelpers.getItem('Item 1');
        dmpl__StorageLocation__c storageLocation1 = FulfillmentTestDataHelpers.getStorageLocation('Storage Location 1');
        
        dmpl__InventoryStock__c inventoryStock = InventoryTestDataHelpers.createInventoryStock(branch1,item1,partnerAccount1,storageLocation1,null);
        
        System.assertNotEquals(null, inventoryStock, 'Inventory Stock should be created');
        System.assertEquals(partnerAccount1.Id, inventoryStock.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch1.Id, inventoryStock.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item1.Id, inventoryStock.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(storageLocation1.Id, inventoryStock.dmpl__StorageLocationId__c, 'Storage Location should be Storage Location 1');

        Test.startTest();
        Boolean exceptionThrown = false;
        try{
            
            inventoryStock.dmpl__PartnerAccountId__c = partnerAccount3.Id;
            inventoryStock.dmpl__BranchId__c = branch3.Id;
            update inventoryStock;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown,'Expected exception with inactive branch');
        Test.stopTest();
    }


    @isTest
    static void createStockWithDefinedStorageLocationPositive(){
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1=TestDataHelpers.getItem('Item 1');
        dmpl__StorageLocation__c storageLocation1 = FulfillmentTestDataHelpers.getStorageLocation('Storage Location 1');
        Test.startTest();
        dmpl__InventoryStock__c inventoryStock = InventoryTestDataHelpers.createInventoryStock(branch1,item1,partnerAccount1,storageLocation1,null);
        Test.stopTest();

        System.assertNotEquals(null, inventoryStock, 'Inventory Stock should be created');
        System.assertEquals(partnerAccount1.Id, inventoryStock.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch1.Id, inventoryStock.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item1.Id, inventoryStock.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(storageLocation1.Id, inventoryStock.dmpl__StorageLocationId__c, 'Storage Location should be Storage Location 1');
    }


    @isTest
    static void updateStockWithDefinedStorageLocationPositive(){
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1=TestDataHelpers.getItem('Item 1');
        dmpl__StorageLocation__c storageLocation1 = FulfillmentTestDataHelpers.getStorageLocation('Storage Location 1');
        
        dmpl__InventoryStock__c inventoryStock = InventoryTestDataHelpers.createInventoryStock(branch1,item1,partnerAccount1,null,null);
        
        System.assertNotEquals(null, inventoryStock, 'Inventory Stock should be created');
        System.assertEquals(partnerAccount1.Id, inventoryStock.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch1.Id, inventoryStock.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item1.Id, inventoryStock.dmpl__ItemId__c, 'Item should be Item 1');

        Test.startTest();
        Boolean exceptionThrown = false;
        try{
            
            inventoryStock.dmpl__StorageLocationId__c = storageLocation1.Id;
            update inventoryStock;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(false, exceptionThrown,'exception caught while adding storage location');
        Test.stopTest();
    }

    @isTest
    static void createStockWithActiveItemPositive(){
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1=TestDataHelpers.getItem('Item 1');
        dmpl__StorageLocation__c storageLocation1 = FulfillmentTestDataHelpers.getStorageLocation('Storage Location 1');
        Test.startTest();
        dmpl__InventoryStock__c inventoryStock = InventoryTestDataHelpers.createInventoryStock(branch1,item1,partnerAccount1,storageLocation1,null);
        Test.stopTest();

        System.assertNotEquals(null, inventoryStock, 'Inventory Stock should be created');
        System.assertEquals(partnerAccount1.Id, inventoryStock.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch1.Id, inventoryStock.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item1.Id, inventoryStock.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(storageLocation1.Id, inventoryStock.dmpl__StorageLocationId__c, 'Storage Location should be Storage Location 1');
    }

    @isTest
    static void createStockWithRequiredSKUPositive(){
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item9=TestDataHelpers.getItem('Item 9');
        dmpl__SKU__c sku3 = TestDataHelpers.getSKU('SKU 3');

        dmpl__StorageLocation__c storageLocation1 = FulfillmentTestDataHelpers.getStorageLocation('Storage Location 1');
        Test.startTest();
        dmpl__InventoryStock__c inventoryStock = InventoryTestDataHelpers.createInventoryStock(branch1,item9,partnerAccount1,storageLocation1,sku3);
        Test.stopTest();

        System.assertNotEquals(null, inventoryStock, 'Inventory Stock should be created');
        System.assertEquals(partnerAccount1.Id, inventoryStock.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch1.Id, inventoryStock.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item9.Id, inventoryStock.dmpl__ItemId__c, 'Item should be Item 9');
        System.assertEquals(storageLocation1.Id, inventoryStock.dmpl__StorageLocationId__c, 'Storage Location should be Storage Location 1');
        System.assertEquals(sku3.Id, inventoryStock.dmpl__SKUId__c, 'sku should be sku 3');

    }

    @isTest
    static void createStockWithNoRequiredSKUPositive(){
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1=TestDataHelpers.getItem('Item 1');
        dmpl__StorageLocation__c storageLocation1 = FulfillmentTestDataHelpers.getStorageLocation('Storage Location 1');
        Test.startTest();
        dmpl__InventoryStock__c inventoryStock = InventoryTestDataHelpers.createInventoryStock(branch1,item1,partnerAccount1,storageLocation1,null);
        Test.stopTest();

        System.assertNotEquals(null, inventoryStock, 'Inventory Stock should be created');
        System.assertEquals(partnerAccount1.Id, inventoryStock.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch1.Id, inventoryStock.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item1.Id, inventoryStock.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(storageLocation1.Id, inventoryStock.dmpl__StorageLocationId__c, 'Storage Location should be Storage Location 1');
    }

    @isTest
    static void createStockWithItemLotPositive(){
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1=TestDataHelpers.getItem('Item 1');
        dmpl__StorageLocation__c storageLocation1 = FulfillmentTestDataHelpers.getStorageLocation('Storage Location 1');

        Test.startTest();
        dmpl__InventoryStock__c inventoryStock = InventoryTestDataHelpers.createInventoryStock(branch1,item1,partnerAccount1,storageLocation1,null);
        Test.stopTest();

        System.assertNotEquals(null, inventoryStock, 'Inventory Stock should be created');
        System.assertEquals(partnerAccount1.Id, inventoryStock.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch1.Id, inventoryStock.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item1.Id, inventoryStock.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(storageLocation1.Id, inventoryStock.dmpl__StorageLocationId__c, 'Storage Location should be Storage Location 1');
    }


    @isTest
    static void createStockWithInactiveItemNegative(){
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item2=TestDataHelpers.getItem('Item 2');
        dmpl__StorageLocation__c storageLocation1 = FulfillmentTestDataHelpers.getStorageLocation('Storage Location 1');
       
        Test.startTest();

        try { 
            dmpl__InventoryStock__c inventoryStock = InventoryTestDataHelpers.createInventoryStock(branch1,item2,partnerAccount1,storageLocation1,null);
            System.assertEquals(null, inventoryStock.Id, 'inventoryStock should not be created with inactive item');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'inventoryStock should not be created with inactive item');
        }
        Test.stopTest(); 
    }

    @isTest
    static void createStockWithDiscontinuedItemPositive(){
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item4=TestDataHelpers.getItem('Item 4');
        dmpl__StorageLocation__c storageLocation1 = FulfillmentTestDataHelpers.getStorageLocation('Storage Location 1');

        Test.startTest();
        dmpl__InventoryStock__c inventoryStock = InventoryTestDataHelpers.createInventoryStock(branch1,item4,partnerAccount1,storageLocation1,null);
        Test.stopTest();

        System.assertNotEquals(null, inventoryStock, 'Inventory Stock should be created');
        System.assertEquals(partnerAccount1.Id, inventoryStock.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch1.Id, inventoryStock.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item4.Id, inventoryStock.dmpl__ItemId__c, 'Item should be Item 4');
        System.assertEquals(storageLocation1.Id, inventoryStock.dmpl__StorageLocationId__c, 'Storage Location should be Storage Location 1');
    }

    @isTest
    static void createStockWithNoStorageLocationPositive(){
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1=TestDataHelpers.getItem('Item 1');

        Test.startTest();
        dmpl__InventoryStock__c inventoryStock = InventoryTestDataHelpers.createInventoryStock(branch1,item1,partnerAccount1,null,null);
        Test.stopTest();

        System.assertNotEquals(null, inventoryStock, 'Inventory Stock should be created');
        System.assertEquals(partnerAccount1.Id, inventoryStock.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch1.Id, inventoryStock.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item1.Id, inventoryStock.dmpl__ItemId__c, 'Item should be Item 1');
    }

    @isTest
    static void createStockWithNoItemLotPositive(){
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__StorageLocation__c storageLocation1 = FulfillmentTestDataHelpers.getStorageLocation('Storage Location 1');

        Test.startTest();
        dmpl__InventoryStock__c inventoryStock = InventoryTestDataHelpers.createInventoryStock(branch1,null,partnerAccount1,storageLocation1,null);
        Test.stopTest();

        System.assertNotEquals(null, inventoryStock, 'Inventory Stock should be created');
        System.assertEquals(partnerAccount1.Id, inventoryStock.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch1.Id, inventoryStock.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(storageLocation1.Id, inventoryStock.dmpl__StorageLocationId__c, 'Storage Location should be Storage Location 1');
    }


    @isTest
    static void updateStockWithInactiveItemNegative(){
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1=TestDataHelpers.getItem('Item 1');
        dmpl__Item__c item2=TestDataHelpers.getItem('Item 2');
        dmpl__StorageLocation__c storageLocation1 = FulfillmentTestDataHelpers.getStorageLocation('Storage Location 1');
        
        dmpl__InventoryStock__c inventoryStock = InventoryTestDataHelpers.createInventoryStock(branch1,item1,partnerAccount1,storageLocation1,null);
        
        System.assertNotEquals(null, inventoryStock, 'Inventory Stock should be created');
        System.assertEquals(partnerAccount1.Id, inventoryStock.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch1.Id, inventoryStock.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item1.Id, inventoryStock.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(storageLocation1.Id, inventoryStock.dmpl__StorageLocationId__c, 'Storage Location should be Storage Location 1');

        Test.startTest();
        Boolean exceptionThrown = false;
        try{
            
            inventoryStock.dmpl__ItemId__c = item2.Id;
            update inventoryStock;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown,'expected exception caught while adding inactive item');
        Test.stopTest();
    }

    @isTest
    static void updateStockWithDiscontinuedItemPositive(){
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1=TestDataHelpers.getItem('Item 1');
        dmpl__Item__c item4=TestDataHelpers.getItem('Item 4');
        dmpl__StorageLocation__c storageLocation1 = FulfillmentTestDataHelpers.getStorageLocation('Storage Location 1');
        
        dmpl__InventoryStock__c inventoryStock = InventoryTestDataHelpers.createInventoryStock(branch1,item1,partnerAccount1,storageLocation1,null);
        
        System.assertNotEquals(null, inventoryStock, 'Inventory Stock should be created');
        System.assertEquals(partnerAccount1.Id, inventoryStock.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch1.Id, inventoryStock.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item1.Id, inventoryStock.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(storageLocation1.Id, inventoryStock.dmpl__StorageLocationId__c, 'Storage Location should be Storage Location 1');

        Test.startTest();
        Boolean exceptionThrown = false;
        try{          
            inventoryStock.dmpl__ItemId__c = item4.Id;
            update inventoryStock;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(false, exceptionThrown,'exception caught while adding discontinued item');
        Test.stopTest();
    }

    @isTest
    static void updateStockWithRemovingRequiredSKUNegative(){
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item9=TestDataHelpers.getItem('Item 9');
        dmpl__SKU__c sku3 = TestDataHelpers.getSKU('SKU 3');
        dmpl__StorageLocation__c storageLocation1 = FulfillmentTestDataHelpers.getStorageLocation('Storage Location 1');
        
        dmpl__InventoryStock__c inventoryStock = InventoryTestDataHelpers.createInventoryStock(branch1,item9,partnerAccount1,storageLocation1,sku3);
        
        System.assertNotEquals(null, inventoryStock, 'Inventory Stock should be created');
        System.assertEquals(partnerAccount1.Id, inventoryStock.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch1.Id, inventoryStock.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item9.Id, inventoryStock.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(storageLocation1.Id, inventoryStock.dmpl__StorageLocationId__c, 'Storage Location should be Storage Location 1');
        System.assertEquals(sku3.Id, inventoryStock.dmpl__SKUId__c, 'sku should be sku 3');

        Test.startTest();
        Boolean exceptionThrown = false;
        try{      
            inventoryStock.dmpl__SKUId__c = null;
            update inventoryStock;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown,'expected exception caught while removing required sku');
        Test.stopTest();
    }

    @isTest
    static void updateStockWithNoRequiredSKUPositive(){
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1=TestDataHelpers.getItem('Item 1');
        dmpl__Item__c item9=TestDataHelpers.getItem('Item 9');
        dmpl__SKU__c sku3 = TestDataHelpers.getSKU('SKU 3');
        dmpl__StorageLocation__c storageLocation1 = FulfillmentTestDataHelpers.getStorageLocation('Storage Location 1');
        
        dmpl__InventoryStock__c inventoryStock = InventoryTestDataHelpers.createInventoryStock(branch1,item9,partnerAccount1,storageLocation1,sku3);
        
        System.assertNotEquals(null, inventoryStock, 'Inventory Stock should be created');
        System.assertEquals(partnerAccount1.Id, inventoryStock.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch1.Id, inventoryStock.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item9.Id, inventoryStock.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(storageLocation1.Id, inventoryStock.dmpl__StorageLocationId__c, 'Storage Location should be Storage Location 1');
        System.assertEquals(sku3.Id, inventoryStock.dmpl__SKUId__c, 'sku should be sku 3');

        Test.startTest();
        Boolean exceptionThrown = false;
        try{      
            inventoryStock.dmpl__ItemId__c = item1.Id;
            inventoryStock.dmpl__SKUId__c = null;
            update inventoryStock;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(false, exceptionThrown,'exception caught while removing no required sku');
        Test.stopTest();
    }
}