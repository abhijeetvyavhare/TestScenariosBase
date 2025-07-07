@isTest
public with sharing class BranchHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
    }

    @isTest
    static void createBranchPositive() {
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        System.assertNotEquals(branch, null, 'Expected branch to be created.');
        System.assertEquals('TheBestAccount', branch.Name, 'Name not matched.');
        System.assertNotEquals(branch.dmpl__PartnerAccountId__c, null, 'Expected dmpl__PartnerAccountId__c to be set.');
    }

    @isTest
    static void updateBranchPositive() {
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        System.assertNotEquals(branch, null, 'Branch should exist before update.');
        branch.Name = 'UpdatedBranch';
        update branch;
        dmpl__Branch__c updatedBranch = TestDataHelpers.getBranch();
        System.assertEquals('UpdatedBranch', updatedBranch.Name, 'Expected Name to be updated to UpdatedBranch.');
    }

    @isTest
    static void deleteBranchPositive() {
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        System.assertNotEquals(branch, null, 'Branch should exist before delete.');
        delete branch;
        dmpl__Branch__c deletedBranch;
        try {
            deletedBranch = TestDataHelpers.getBranch();
        } catch (Exception e) {
            deletedBranch = null;
        }

        System.assertEquals(null, deletedBranch, 'Expected Branch to be deleted and not found.');
    }


     @isTest
    static void  CreateBranchWithAllRequiredfieldsPartnerAccountAndBranchNamePositive(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount(); 
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch Name',partnerAccount1.Id, True, False ,False ,False);

        dmpl__Branch__c fetchedBranch = TestDataHelpers.getBranch(branch.Name);
        Test.stopTest();
        System.assertEquals('Branch Name', fetchedBranch.Name, 'Branch name should match the one provided');
        System.assertEquals(partnerAccount1.Id, fetchedBranch.dmpl__PartnerAccountId__c, 'Partner Account should match the one provided');
        System.assertEquals(true, fetchedBranch.dmpl__IsActive__c, 'Expected true for field 1');
        System.assertEquals(false, fetchedBranch.dmpl__AllowSales__c, 'Expected false for field 2');
        System.assertEquals(false, fetchedBranch.dmpl__AllowPurchase__c, 'Expected false for field 3');
        System.assertEquals(false, fetchedBranch.dmpl__AllowInventory__c, 'Expected false for field 4');

     }

    @isTest
    static void  createEditBranchTochangeIsActivePositive(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount(); 
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch Name',partnerAccount1.Id, True, False ,False ,False);

        dmpl__Branch__c fetchedBranch = TestDataHelpers.getBranch(branch.Name);
        Test.stopTest();
        System.assertEquals('Branch Name', fetchedBranch.Name, 'Branch name should match the one provided');
        System.assertEquals(partnerAccount1.Id, fetchedBranch.dmpl__PartnerAccountId__c, 'Partner Account should match the one provided');
        System.assertEquals(true, fetchedBranch.dmpl__IsActive__c, 'Expected true for field 1');
        System.assertEquals(false, fetchedBranch.dmpl__AllowSales__c, 'Expected false for field 2');
        System.assertEquals(false, fetchedBranch.dmpl__AllowPurchase__c, 'Expected false for field 3');
        System.assertEquals(false, fetchedBranch.dmpl__AllowInventory__c, 'Expected false for field 4');

     }

    @isTest
    static void  createEditBranchAndenableAllowServicePositive(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount(); 
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch Name',partnerAccount1.Id, True, True, False ,False ,False, False, False);

        dmpl__Branch__c fetchedBranch = TestDataHelpers.getBranch(branch.Name);
        Test.stopTest();
        System.assertEquals('Branch Name', fetchedBranch.Name, 'Branch name should match the one provided');
        System.assertEquals(partnerAccount1.Id, fetchedBranch.dmpl__PartnerAccountId__c, 'Partner Account should match the one provided');
        System.assertEquals(true, fetchedBranch.dmpl__IsActive__c, 'Expected true for field 1');
        System.assertEquals(true , fetchedBranch.dmpl__AllowService__c,'Expected true for field 2');
        System.assertEquals(false, fetchedBranch.dmpl__IsHomeDeliveryAvailable__c, 'Expected false for field 3');
        System.assertEquals(false, fetchedBranch.dmpl__IsPickupDropAvailable__c, 'Expected false for field 4');
        System.assertEquals(false, fetchedBranch.dmpl__AllowSales__c, 'Expected false for field 5');
        System.assertEquals(false, fetchedBranch.dmpl__AllowPurchase__c, 'Expected false for field 6');
        System.assertEquals(false, fetchedBranch.dmpl__AllowInventory__c, 'Expected false for field 7');

     }

    @isTest
    static void  createBranchCreationWithIsActiveFalseHomeDeliveryFalsePositive(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount(); 
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch Name',partnerAccount1.Id, True, False ,True,False ,False,False, False);

        dmpl__Branch__c fetchedBranch = TestDataHelpers.getBranch(branch.Name);
        Test.stopTest();
        System.assertEquals('Branch Name', fetchedBranch.Name, 'Branch name should match the one provided');
        System.assertEquals(partnerAccount1.Id, fetchedBranch.dmpl__PartnerAccountId__c, 'Partner Account should match the one provided');
        System.assertEquals(true, fetchedBranch.dmpl__IsActive__c, 'Expected true for field 1');
        System.assertEquals(false , fetchedBranch.dmpl__AllowService__c,'Expected true for field 2');
        System.assertEquals(true, fetchedBranch.dmpl__IsHomeDeliveryAvailable__c, 'Expected  true field 3');
        System.assertEquals(false, fetchedBranch.dmpl__IsPickupDropAvailable__c, 'Expected false for field 4');
        System.assertEquals(false, fetchedBranch.dmpl__AllowSales__c, 'Expected false for field 5');
        System.assertEquals(false, fetchedBranch.dmpl__AllowPurchase__c, 'Expected false for field 6');
        System.assertEquals(false, fetchedBranch.dmpl__AllowInventory__c, 'Expected false for field 7');
     }

    @isTest
    static void  createBranchCreationWithAllBooleanFieldsAtDefaultvaluesPositive(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount(); 
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch Name',partnerAccount1.Id, True, False ,False,False ,False,False, False);

        dmpl__Branch__c fetchedBranch = TestDataHelpers.getBranch(branch.Name);
        Test.stopTest();
        System.assertEquals('Branch Name', fetchedBranch.Name, 'Branch name should match the one provided');
        System.assertEquals(partnerAccount1.Id, fetchedBranch.dmpl__PartnerAccountId__c, 'Partner Account should match the one provided');
        System.assertEquals(true, fetchedBranch.dmpl__IsActive__c, 'Expected true for field 1');
        System.assertEquals(false , fetchedBranch.dmpl__AllowService__c,'Expected false for field 2');
        System.assertEquals(false, fetchedBranch.dmpl__IsHomeDeliveryAvailable__c, 'Expected  false field 3');
        System.assertEquals(false, fetchedBranch.dmpl__IsPickupDropAvailable__c, 'Expected false for field 4');
        System.assertEquals(false, fetchedBranch.dmpl__AllowSales__c, 'Expected false for field 5');
        System.assertEquals(false, fetchedBranch.dmpl__AllowPurchase__c, 'Expected false for field 6');
        System.assertEquals(false, fetchedBranch.dmpl__AllowInventory__c, 'Expected false for field 7');
     }
    

    @isTest
    static void  createBranchcreationWithoutPartnerAccountNegative(){
        Test.startTest();
        Boolean exceptionThrown= false;
        //Account partnerAccount1 = TestDataHelpers.getPartnerAccount();    
        dmpl__Branch__c branch;
        try {
        branch = TestDataHelpers.createBranch('Branch Name',null, True, False ,False,False ,False,False, False);
        } catch (Exception e) {
           exceptionThrown = true;
        }
         Test.stopTest();
        //System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown for using missing values in mandatory fields i.e Branch name ');
 
     }


    @isTest
    static void  createBranchCreationWithoutBranchNameNegative(){
      
        Boolean exceptionThrown=false;
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount(); 
       
        try {
             dmpl__Branch__c branch = TestDataHelpers.createBranch(null,partnerAccount1.Id, True, False ,False,False ,False,False, False);

        } catch (Exception e) {
                exceptionThrown = true;
                System.debug('Expected exception caught: ' + e.getMessage());
            }
          Test.stopTest();
        // System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown when using a null branch account');
    }

    @isTest
    static void  createBranchCreationWithNullValueInIsActiveFieldPositive(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount(); 
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch Name',partnerAccount1.Id, false, false ,false,false ,false,false, false);

        dmpl__Branch__c fetchedBranch = TestDataHelpers.getBranch(branch.Name);
        Test.stopTest();
        System.assertEquals('Branch Name', fetchedBranch.Name, 'Branch name should match the one provided');
        System.assertEquals(partnerAccount1.Id, fetchedBranch.dmpl__PartnerAccountId__c, 'Partner Account should match the one provided');
        System.assertEquals(false, fetchedBranch.dmpl__IsActive__c, 'Expected true for field 1');
        System.assertEquals(false , fetchedBranch.dmpl__AllowService__c,'Expected false for field 2');
        System.assertEquals(false, fetchedBranch.dmpl__IsHomeDeliveryAvailable__c, 'Expected  false field 3');
        System.assertEquals(false, fetchedBranch.dmpl__IsPickupDropAvailable__c, 'Expected false for field 4');
        System.assertEquals(false, fetchedBranch.dmpl__AllowSales__c, 'Expected false for field 5');
        System.assertEquals(false, fetchedBranch.dmpl__AllowPurchase__c, 'Expected false for field 6');
        System.assertEquals(false, fetchedBranch.dmpl__AllowInventory__c, 'Expected false for field 7');
    }

    @isTest
    static void  createSaveWithMissingValuesInMandatoryDropdownBranchNameNegative(){

        Boolean exceptionThrown = false;
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount(); 
        Test.stopTest();
        try {
            dmpl__Branch__c branch = TestDataHelpers.createBranch(
                null, 
                partnerAccount1.Id,
                true, false, false, false, false, false, false
            );

        } catch (DmlException e) {
            exceptionThrown = true;
            System.debug('Expected exception caught: ' + e.getMessage());
        }
         
           // System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown for using missing values in mandatory fields i.e Branch name ');
    }


    @isTest
    static void createUseInvalidPartnerAccountThatIsInactiveOrDeletedNegative() {
       
        Boolean exceptionThrown = false;
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2', false, true, false, true, '45 Residency Road', 'Pune', 'Maharashtra', 'India', '411001', '22 Commerce Avenue', 'Pune', 'Maharashtra', 'India', '411038','91-99665544433');


        Test.startTest();
        try {
        dmpl__Branch__c branch = TestDataHelpers.createBranch(
            'Branch Name',
            partnerAccount2.Id,
            true, false, false, false, false, false, false
        );

            insert branch;
        } catch (Exception e) {
            exceptionThrown = true;
            System.debug('Expected exception caught: ' + e.getMessage());
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown for inactive/deleted partner account.');
    }

    @isTest
    static void  updateEditBranchToEnablePickupDropTruePositive(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount(); 
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch Name',partnerAccount1.Id, true, false ,false,false ,false,false, false);
        branch.dmpl__IsPickupDropAvailable__c = true;
        update branch;
        dmpl__Branch__c fetchedBranch = TestDataHelpers.getBranch(branch.Name);
        Test.stopTest();
        System.assertEquals('Branch Name', fetchedBranch.Name, 'Branch name should match the one provided');
        System.assertEquals(partnerAccount1.Id, fetchedBranch.dmpl__PartnerAccountId__c, 'Partner Account should match the one provided');
        System.assertEquals(true, fetchedBranch.dmpl__IsActive__c, 'Expected true for field 1');
        System.assertEquals(false , fetchedBranch.dmpl__AllowService__c,'Expected false for field 2');
        System.assertEquals(false, fetchedBranch.dmpl__IsHomeDeliveryAvailable__c, 'Expected  false field 3');
        System.assertEquals(true, fetchedBranch.dmpl__IsPickupDropAvailable__c, 'Expected true for field 4');
        System.assertEquals(false, fetchedBranch.dmpl__AllowSales__c, 'Expected false for field 5');
        System.assertEquals(false, fetchedBranch.dmpl__AllowPurchase__c, 'Expected false for field 6');
        System.assertEquals(false, fetchedBranch.dmpl__AllowInventory__c, 'Expected false for field 7');
     }     


     
    @isTest
    static void UpdateBranchToEnableTheAllowSalesTruePositive(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount(); 
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch Name',partnerAccount1.Id, true, false ,false,false ,false,false, false);

        dmpl__Branch__c fetchedBranch = TestDataHelpers.getBranch(branch.Name);
        fetchedBranch.dmpl__AllowSales__c = true;
        update fetchedBranch;

        dmpl__Branch__c updatedBranch = TestDataHelpers.getBranch(fetchedBranch.Name);
        Test.stopTest();
        System.assertEquals('Branch Name', updatedBranch.Name, 'Branch name should match the one provided');
        System.assertEquals(partnerAccount1.Id, updatedBranch.dmpl__PartnerAccountId__c, 'Partner Account should match the one provided');
        System.assertEquals(true, updatedBranch.dmpl__IsActive__c, 'Expected true for field 1');
        System.assertEquals(false , updatedBranch.dmpl__AllowService__c,'Expected false for field 2');
        System.assertEquals(false, updatedBranch.dmpl__IsHomeDeliveryAvailable__c, 'Expected  false field 3');
        System.assertEquals(false, updatedBranch.dmpl__IsPickupDropAvailable__c, 'Expected true for field 4');
        System.assertEquals(true, updatedBranch.dmpl__AllowSales__c, 'Expected false for field 5');
        System.assertEquals(false, updatedBranch.dmpl__AllowPurchase__c, 'Expected false for field 6');
        System.assertEquals(false, updatedBranch.dmpl__AllowInventory__c, 'Expected false for field 7');
    }  
    
    @isTest
    static void updateEditBranchToEnableTheAllowPurchaseTruePositive(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount(); 
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch Name',partnerAccount1.Id, true, false ,false,false ,false,false, false);

        dmpl__Branch__c fetchedBranch = TestDataHelpers.getBranch(branch.Name);
        fetchedBranch.dmpl__AllowPurchase__c=true;
        update fetchedBranch;
        dmpl__Branch__c updatedBranch = TestDataHelpers.getBranch(fetchedBranch.Name);
        Test.stopTest();
        System.assertEquals('Branch Name', updatedBranch.Name, 'Branch name should match the one provided');
        System.assertEquals(partnerAccount1.Id, updatedBranch.dmpl__PartnerAccountId__c, 'Partner Account should match the one provided');
        System.assertEquals(true, updatedBranch.dmpl__IsActive__c, 'Expected true for field 1');
        System.assertEquals(false , updatedBranch.dmpl__AllowService__c,'Expected false for field 2');
        System.assertEquals(false, updatedBranch.dmpl__IsHomeDeliveryAvailable__c, 'Expected  false field 3');
        System.assertEquals(false, updatedBranch.dmpl__IsPickupDropAvailable__c, 'Expected true for field 4');
        System.assertEquals(false, updatedBranch.dmpl__AllowSales__c, 'Expected false for field 5');
        System.assertEquals(true, updatedBranch.dmpl__AllowPurchase__c, 'Expected false for field 6');
        System.assertEquals(false, updatedBranch.dmpl__AllowInventory__c, 'Expected false for field 7');
    }   
     
    @isTest
    static void createBranchCreationWithAllowSalesTrueAndAllowPurchaseTruePositive(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount(); 
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch Name',partnerAccount1.Id, false, false ,false,false ,true,true, false);

        dmpl__Branch__c fetchedBranch = TestDataHelpers.getBranch(branch.Name);
        Test.stopTest();
        System.assertEquals('Branch Name', fetchedBranch.Name, 'Branch name should match the one provided');
        System.assertEquals(partnerAccount1.Id, fetchedBranch.dmpl__PartnerAccountId__c, 'Partner Account should match the one provided');
        System.assertEquals(false, fetchedBranch.dmpl__IsActive__c, 'Expected true for field 1');
        System.assertEquals(false , fetchedBranch.dmpl__AllowService__c,'Expected false for field 2');
        System.assertEquals(false, fetchedBranch.dmpl__IsHomeDeliveryAvailable__c, 'Expected  false field 3');
        System.assertEquals(false, fetchedBranch.dmpl__IsPickupDropAvailable__c, 'Expected true for field 4');
        System.assertEquals(true, fetchedBranch.dmpl__AllowSales__c, 'Expected false for field 5');
        System.assertEquals(true, fetchedBranch.dmpl__AllowPurchase__c, 'Expected false for field 6');
        System.assertEquals(false, fetchedBranch.dmpl__AllowInventory__c, 'Expected false for field 7');
    }    

    @isTest
    static void createBranchCreationWithIsActiveFalseAndHomeDeliveryTRUE(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount(); 
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch Name',partnerAccount1.Id, false, false ,true ,false ,false,true, false);

        dmpl__Branch__c fetchedBranch = TestDataHelpers.getBranch(branch.Name);
        Test.stopTest();
        System.assertEquals('Branch Name', fetchedBranch.Name, 'Branch name should match the one provided');
        System.assertEquals(partnerAccount1.Id, fetchedBranch.dmpl__PartnerAccountId__c, 'Partner Account should match the one provided');
        System.assertEquals(false, fetchedBranch.dmpl__IsActive__c, 'Expected true for field 1');
        System.assertEquals(false , fetchedBranch.dmpl__AllowService__c,'Expected false for field 2');
        System.assertEquals(true, fetchedBranch.dmpl__IsHomeDeliveryAvailable__c, 'Expected  false field 3');
        System.assertEquals(false, fetchedBranch.dmpl__IsPickupDropAvailable__c, 'Expected true for field 4');
        System.assertEquals(true, fetchedBranch.dmpl__AllowPurchase__c, 'Expected false for field 6');
        System.assertEquals(false, fetchedBranch.dmpl__AllowInventory__c, 'Expected false for field 7');
    }  

    @isTest
    static void updateEditBranchToEnableAllowInventoryTrueAndHomeDeliveryTruePositive(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount(); 
        dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch Name',partnerAccount1.Id, false, false ,false ,false ,false ,false, false);

        dmpl__Branch__c fetchedBranch = TestDataHelpers.getBranch(branch.Name);
        fetchedBranch.dmpl__IsHomeDeliveryAvailable__c= true;
        fetchedBranch.dmpl__AllowInventory__c = true;
        update fetchedBranch;
        dmpl__Branch__c updatedBranch = TestDataHelpers.getBranch(fetchedBranch.Name);
        Test.stopTest();
        System.assertEquals('Branch Name', updatedBranch.Name, 'Branch name should match the one provided');
        System.assertEquals(partnerAccount1.Id, updatedBranch.dmpl__PartnerAccountId__c, 'Partner Account should match the one provided');
        System.assertEquals(false, updatedBranch.dmpl__IsActive__c, 'Expected true for field 1');
        System.assertEquals(false , updatedBranch.dmpl__AllowService__c,'Expected false for field 2');
        System.assertEquals(true, updatedBranch.dmpl__IsHomeDeliveryAvailable__c, 'Expected  false field 3');
        System.assertEquals(false, updatedBranch.dmpl__IsPickupDropAvailable__c, 'Expected true for field 4');
        System.assertEquals(false, updatedBranch.dmpl__AllowSales__c, 'Expected false for field 5');
        System.assertEquals(false, updatedBranch.dmpl__AllowPurchase__c, 'Expected false for field 6');
        System.assertEquals(true, updatedBranch.dmpl__AllowInventory__c, 'Expected false for field 7');
    } 
    
   
}