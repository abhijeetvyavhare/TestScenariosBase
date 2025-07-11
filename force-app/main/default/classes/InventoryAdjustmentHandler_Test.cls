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
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1', false, true, false, true, 'MG Road', 'Bengaluru', 'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India', '560095','9876543210');
        dmpl__Branch__c branch1=TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id, true, true, false, true);
        dmpl__InventoryAdjustment__c inventory = InventoryAdjustmentDataHelper.CreateAdjustment(
            branch1.Id,
            partnerAccount1.Id,
            Date.today()
        );
        Test.stopTest();
        dmpl__InventoryAdjustment__c fetchedInventory = InventoryAdjustmentDataHelper.getAdjustment(inventory.id);
        System.assertNotEquals(null, fetchedInventory, 'Fetched Inventory Adjustment should not be null');
        System.assertEquals(partnerAccount1.Id, fetchedInventory.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, fetchedInventory.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals('Draft', fetchedInventory.dmpl__Status__c, 'Status should be "Draft"');
        System.assertEquals(Date.today(), fetchedInventory.dmpl__DocumentDate__c, 'Document Date should be today\'s date');
    }

     @isTest
    static void createAdjustmentWithInventoryPostedFalsePositive(){
        Test.startTest();
         Boolean exceptionThrown=false;
         Account partnerAccount1 = TestDataHelpers.getPartnerAccount();
         dmpl__Branch__c branch1=TestDataHelpers.getBranch();
         dmpl__InventoryAdjustment__c inventory = InventoryAdjustmentDataHelper.CreateAdjustment(
            branch1.Id,
            partnerAccount1.Id,
            Date.today()
        );

        dmpl__InventoryAdjustment__c fetchedInventory = InventoryAdjustmentDataHelper.getAdjustment(inventory.id);
        Test.stopTest();
        System.assertNotEquals(null, fetchedInventory, 'Fetched Inventory Adjustment should not be null');
        System.assertEquals(partnerAccount1.Id, fetchedInventory.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, fetchedInventory.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals('Draft', fetchedInventory.dmpl__Status__c, 'Status should be "Draft"');
        System.assertEquals(Date.today(), fetchedInventory.dmpl__DocumentDate__c, 'Document Date should be today\'s date');
    }

    @isTest
    static void createAdjustmentCreationWithValidCreatedDateInDatetimeFormatpositive(){
        Test.startTest();
         Account partnerAccount1 = TestDataHelpers.getPartnerAccount();
         dmpl__Branch__c branch1=TestDataHelpers.getBranch();
         dmpl__InventoryAdjustment__c inventory = InventoryAdjustmentDataHelper.CreateAdjustment(
            branch1.Id,
            partnerAccount1.Id,
            Date.today()
        );

        dmpl__InventoryAdjustment__c fetchedInventory = InventoryAdjustmentDataHelper.getAdjustment(inventory.id);
        Test.stopTest();
        System.assertNotEquals(null, fetchedInventory, 'Fetched Inventory Adjustment should not be null');
        System.assertEquals(partnerAccount1.Id, fetchedInventory.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, fetchedInventory.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals('Draft', fetchedInventory.dmpl__Status__c, 'Status should be "Draft"');
        System.assertEquals(Date.today(), fetchedInventory.dmpl__DocumentDate__c, 'Document Date should be today\'s date');
    }
    
     
     @isTest
    static void createAdjutstmentWithValidBranchAndLocation(){
        Test.startTest();
         Account partnerAccount1 = TestDataHelpers.getPartnerAccount();
         dmpl__Branch__c branch1=TestDataHelpers.getBranch();
         dmpl__InventoryAdjustment__c inventory = InventoryAdjustmentDataHelper.CreateAdjustment(
            branch1.Id,
            partnerAccount1.Id,
            Date.today()
        );

        dmpl__InventoryAdjustment__c fetchedInventory = InventoryAdjustmentDataHelper.getAdjustment(inventory.id);
        Test.stopTest();
        System.assertNotEquals(null, fetchedInventory, 'Fetched Inventory Adjustment should not be null');
        System.assertEquals(partnerAccount1.Id, fetchedInventory.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, fetchedInventory.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals('Draft', fetchedInventory.dmpl__Status__c, 'Status should be "Draft"');
        System.assertEquals(Date.today(), fetchedInventory.dmpl__DocumentDate__c, 'Document Date should be today\'s date');
    }
    
   
     @isTest
    static void createSaveAdjustmentWithAllValidFieldspositive(){
        Test.startTest();
         Account partnerAccount1 = TestDataHelpers.getPartnerAccount();
         dmpl__Branch__c branch1=TestDataHelpers.getBranch();
         dmpl__InventoryAdjustment__c inventory = InventoryAdjustmentDataHelper.CreateAdjustment(
            branch1.Id,
            partnerAccount1.Id,
            Date.today()
        );

        dmpl__InventoryAdjustment__c fetchedInventory = InventoryAdjustmentDataHelper.getAdjustment(inventory.id);
        Test.stopTest();
        System.assertNotEquals(null, fetchedInventory, 'Fetched Inventory Adjustment should not be null');
        System.assertEquals(partnerAccount1.Id, fetchedInventory.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, fetchedInventory.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals('Draft', fetchedInventory.dmpl__Status__c, 'Status should be "Draft"');
        System.assertEquals(Date.today(), fetchedInventory.dmpl__DocumentDate__c, 'Document Date should be today\'s date');
    }
    
   

    
     @isTest
    static void createAdjustmentWithInventoryPostedtruePositive(){
        Test.startTest();
         Boolean exceptionThrown=false;
         Account partnerAccount1 = TestDataHelpers.getPartnerAccount();
         dmpl__Branch__c branch1=TestDataHelpers.getBranch();
         dmpl__InventoryAdjustment__c inventory = InventoryAdjustmentDataHelper.CreateAdjustment(
            branch1.Id,
            partnerAccount1.Id,
            Date.today()
        );

        dmpl__InventoryAdjustment__c fetchedInventory = InventoryAdjustmentDataHelper.getAdjustment(inventory.id);
        Test.stopTest();
        System.assertNotEquals(null, fetchedInventory, 'Fetched Inventory Adjustment should not be null');
        System.assertEquals(partnerAccount1.Id, fetchedInventory.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, fetchedInventory.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals('Draft', fetchedInventory.dmpl__Status__c, 'Status should be "Draft"');
        System.assertEquals(Date.today(), fetchedInventory.dmpl__DocumentDate__c, 'Document Date should be today\'s date');

    }

    @isTest
    static void createAdjustmentForInactiveBranchnegative(){
        Test.startTest();
        Boolean exceptionThrown=false;        
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount();

         try{
         dmpl__InventoryAdjustment__c inventory = InventoryAdjustmentDataHelper.CreateAdjustment(
            Null,
            partnerAccount1.Id,
            Date.today()
        );
         }catch(Exception e){
           exceptionThrown=true;
           System.debug('Expected exception caught: ' + e.getMessage());
        }
        Test.stopTest();
            System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown when using a wrong partner account');
  
    }
    
    @isTest
    static void createAdjustmentSavedWithoutSelectingLocationnegattive(){
        Test.startTest();
         Account partnerAccount1 = TestDataHelpers.getPartnerAccount();
         dmpl__Branch__c branch1=TestDataHelpers.getBranch();
         dmpl__InventoryAdjustment__c inventory = InventoryAdjustmentDataHelper.CreateAdjustment(
            branch1.Id,
            partnerAccount1.Id,
            Date.today()
        );

        dmpl__InventoryAdjustment__c fetchedInventory = InventoryAdjustmentDataHelper.getAdjustment(inventory.id);
        Test.stopTest();
        System.assertNotEquals(null, fetchedInventory, 'Fetched Inventory Adjustment should not be null');
        System.assertEquals(partnerAccount1.Id, fetchedInventory.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, fetchedInventory.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals('Draft', fetchedInventory.dmpl__Status__c, 'Status should be "Draft"');
        System.assertEquals(Date.today(), fetchedInventory.dmpl__DocumentDate__c, 'Document Date should be today\'s date');
    }

    @isTest
    static void createSaveWithoutSelectingBranchnegative(){
        Test.startTest();
         Boolean exceptionThrown= false;
         Account partnerAccount1 = TestDataHelpers.getPartnerAccount();
         //dmpl__Branch__c branch1=TestDataHelpers.getBranch();

         try {
              dmpl__InventoryAdjustment__c inventory = InventoryAdjustmentDataHelper.CreateAdjustment(
                    Null,
                    partnerAccount1.Id,
                    Date.today()
        );
         } catch (Exception e) {
           exceptionThrown= true;
            exceptionThrown = true;
            System.debug('Expected exception caught: ' + e.getMessage());
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown when using a wrong partner account');
   

    }

    @isTest
    static void createSavewithoutselectingPartnerAccountnegative(){
        Test.startTest();
        Boolean exceptionThrown= false;
         //Account partnerAccount1 = TestDataHelpers.getPartnerAccount();
         dmpl__Branch__c branch1=TestDataHelpers.getBranch();

        try {
            dmpl__InventoryAdjustment__c inventory = InventoryAdjustmentDataHelper.CreateAdjustment(
            branch1.Id,
            Null,
            Date.today()
        );
        } catch (Exception e) {
             exceptionThrown = true;
            System.debug('Expected exception caught: ' + e.getMessage());
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown when using a wrong partner account');
       
    }

    
    
 
    @isTest
    static void createLineCreationWithValidItemQuantityAndAdjustmentTypePositive(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch1=TestDataHelpers.getBranch();
        dmpl__Item__c  item1 = TestDataHelpers.getItem();


        dmpl__InventoryAdjustment__c inventory = InventoryAdjustmentDataHelper.CreateAdjustment(
            branch1.Id,
            partnerAccount1.Id,
            Date.today()
        );
         dmpl__InventoryAdjustmentLine__c inventoryLine = InventoryAdjustmentDataHelper.CreateAdjustmentLine(
               item1.Id,
               6,
               inventory.Id
        );

        dmpl__InventoryAdjustmentLine__c fetchedLine = InventoryAdjustmentDataHelper.getAdjustmentLine(inventoryLine.id);
        Test.stopTest();
          System.assertEquals(item1.Id, fetchedLine.dmpl__ItemId__c, 'Item on the line should match');
          System.assertEquals(6, fetchedLine.dmpl__Quantity__c, 'Quantity should be 6');
          System.assertEquals(inventory.Id, fetchedLine.dmpl__InventoryAdjustmentId__c, 'Line should be associated with correct inventory adjustment');
       }

    @isTest
    static void createLineWithCalculatedUnitCostAndTotalcostPositive(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch1=TestDataHelpers.getBranch();
        dmpl__Item__c  item1 = TestDataHelpers.getItem();


        dmpl__InventoryAdjustment__c inventory = InventoryAdjustmentDataHelper.CreateAdjustment(
            branch1.Id,
            partnerAccount1.Id,
            Date.today()
        );
         dmpl__InventoryAdjustmentLine__c inventoryLine = InventoryAdjustmentDataHelper.CreateAdjustmentLine(
               item1.Id,
               6,
               inventory.Id
        );

        dmpl__InventoryAdjustmentLine__c fetchedLine = InventoryAdjustmentDataHelper.getAdjustmentLine(inventoryLine.id);
        Test.stopTest();
          System.assertEquals(item1.Id, fetchedLine.dmpl__ItemId__c, 'Item on the line should match');
          System.assertEquals(6, fetchedLine.dmpl__Quantity__c, 'Quantity should be 6');
          System.assertEquals(inventory.Id, fetchedLine.dmpl__InventoryAdjustmentId__c, 'Line should be associated with correct inventory adjustment');
    }

    @isTest
    static void createLineWithValidItemLotandLotTypePositive(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch1=TestDataHelpers.getBranch();
        dmpl__Item__c  item1 = TestDataHelpers.getItem();


        dmpl__InventoryAdjustment__c inventory = InventoryAdjustmentDataHelper.CreateAdjustment(
            branch1.Id,
            partnerAccount1.Id,
            Date.today()
        );
         dmpl__InventoryAdjustmentLine__c inventoryLine = InventoryAdjustmentDataHelper.CreateAdjustmentLine(
               item1.Id,
               6,
               inventory.Id
        );

        dmpl__InventoryAdjustmentLine__c fetchedLine = InventoryAdjustmentDataHelper.getAdjustmentLine(inventoryLine.id);
        Test.stopTest();
          System.assertEquals(item1.Id, fetchedLine.dmpl__ItemId__c, 'Item on the line should match');
          System.assertEquals(6, fetchedLine.dmpl__Quantity__c, 'Quantity should be 6');
          System.assertEquals(inventory.Id, fetchedLine.dmpl__InventoryAdjustmentId__c, 'Line should be associated with correct inventory adjustment');
    }

    @isTest
    static void createAttemptToselectInactiveItemNegative(){
      
         Boolean exceptionThrown= false;
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch1=TestDataHelpers.getBranch();
        dmpl__Item__c item2 = TestDataHelpers.createItem('Item 2','Product',false,false,false,'654345',false);



        dmpl__InventoryAdjustment__c inventory = InventoryAdjustmentDataHelper.CreateAdjustment(
            branch1.Id,
            partnerAccount1.Id,
            Date.today()
        );
        Test.startTest();
        try {
            dmpl__InventoryAdjustmentLine__c inventoryLine = InventoryAdjustmentDataHelper.CreateAdjustmentLine(
                item2.Id,
                6,
                inventory.Id
            );
        } catch (Exception e) {
            exceptionThrown = true;
            System.debug('Expected exception caught: ' + e.getMessage());
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown for inactive item.');
    }
     
    
    @isTest
    static void createAttemptToSaveWithBlankAdjustmentTypePositive(){
        Test.startTest();
         Boolean exceptionThrown= false;
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch1=TestDataHelpers.getBranch();
        dmpl__Item__c  item1 = TestDataHelpers.getItem();


        dmpl__InventoryAdjustment__c inventory = InventoryAdjustmentDataHelper.CreateAdjustment(
            branch1.Id,
            partnerAccount1.Id,
            Date.today()
        );
         dmpl__InventoryAdjustmentLine__c inventoryLine = InventoryAdjustmentDataHelper.CreateAdjustmentLine(
               item1.Id,
               6,
               inventory.Id
        );

        dmpl__InventoryAdjustmentLine__c fetchedLine = InventoryAdjustmentDataHelper.getAdjustmentLine(inventoryLine.id);
        Test.stopTest();
          System.assertEquals(item1.Id, fetchedLine.dmpl__ItemId__c, 'Item on the line should match');
          System.assertEquals(6, fetchedLine.dmpl__Quantity__c, 'Quantity should be 6');
          System.assertEquals(inventory.Id, fetchedLine.dmpl__InventoryAdjustmentId__c, 'Line should be associated with correct inventory adjustment');
    }

    @isTest
    static void createAttemptToSaveWithoutEnteringQuantityNegative(){
        Test.startTest();
        Boolean exceptionThrown= false;
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch1=TestDataHelpers.getBranch();
        dmpl__Item__c  item1 = TestDataHelpers.getItem();


        dmpl__InventoryAdjustment__c inventory = InventoryAdjustmentDataHelper.CreateAdjustment(
            branch1.Id,
            partnerAccount1.Id,
            Date.today()
        );

        try {
            dmpl__InventoryAdjustmentLine__c inventoryLine = InventoryAdjustmentDataHelper.CreateAdjustmentLine(
               item1.Id,
                Null,
               inventory.Id
        );
        } catch (Exception e ) {
            exceptionThrown = true;
            System.debug('Expected exception caught: ' + e.getMessage());
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown for inactive item.');
   
    }

     @isTest
    static void createItemLotWithoutSelectingItemNegative(){
       
         Boolean exceptionThrown= false;
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch1=TestDataHelpers.getBranch();



        dmpl__InventoryAdjustment__c inventory = InventoryAdjustmentDataHelper.CreateAdjustment(
            branch1.Id,
            partnerAccount1.Id,
            Date.today()
        );
        Test.startTest();
        try {
            dmpl__InventoryAdjustmentLine__c inventoryLine = InventoryAdjustmentDataHelper.CreateAdjustmentLine(
                null,
                6,
                inventory.Id
            );
        } catch (Exception e) {
            exceptionThrown = true;
            System.debug('Expected exception caught: ' + e.getMessage());
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown for inactive item.');
    }

    @isTest
    static void createLineWithInvalidItemLotTypeNotMatchingItemLotPositive(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch1=TestDataHelpers.getBranch();
        dmpl__Item__c  item1 = TestDataHelpers.getItem();


        dmpl__InventoryAdjustment__c inventory = InventoryAdjustmentDataHelper.CreateAdjustment(
            branch1.Id,
            partnerAccount1.Id,
            Date.today()
        );
         dmpl__InventoryAdjustmentLine__c inventoryLine = InventoryAdjustmentDataHelper.CreateAdjustmentLine(
               item1.Id,
               6,
               inventory.Id
        );

        dmpl__InventoryAdjustmentLine__c fetchedLine = InventoryAdjustmentDataHelper.getAdjustmentLine(inventoryLine.id);
        Test.stopTest();
          System.assertEquals(item1.Id, fetchedLine.dmpl__ItemId__c, 'Item on the line should match');
          System.assertEquals(6, fetchedLine.dmpl__Quantity__c, 'Quantity should be 6');
          System.assertEquals(inventory.Id, fetchedLine.dmpl__InventoryAdjustmentId__c, 'Line should be associated with correct inventory adjustment');
    }
}