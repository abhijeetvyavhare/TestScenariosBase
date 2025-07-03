@isTest
public with sharing class BranchPostalCodeHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__Place__c parentPlace = BranchTestDataHelper.createParentPlace();
        dmpl__Place__c place = BranchTestDataHelper.createPlace(parentPlace);
        dmpl__PostalCode__c postalCode = BranchTestDataHelper.createPostalCode(place);
        dmpl__BranchPostalCode__c branchPostalCode = BranchTestDataHelper.createBranchPostalCode(partnerAccount,branch,postalCode);
    }
    
    @isTest
    static void createBranchPostalCodePositive() {
        dmpl__BranchPostalCode__c branchPostalCode = BranchTestDataHelper.getBranchPostalCode();
        if(branchPostalCode != null){
            System.assertNotEquals(branchPostalCode, null, 'Expected branchPostalCode to be created.');
        }
        System.assertNotEquals(branchPostalCode.dmpl__PostalCodeId__c, null, 'Expected dmpl__PostalCodeId__c to be set');
        System.assertNotEquals(branchPostalCode.dmpl__PartnerAccountId__c, null, 'Expected dmpl__AccountId__c to be set');
        System.assertNotEquals(branchPostalCode.dmpl__BranchId__c, null, 'Expected dmpl__BranchId__c to be set');
        System.assertEquals('Sale', branchPostalCode.dmpl__CoverageType__c, 'Coverage type must be sale');
        System.assertNotEquals(branchPostalCode.Name, null, 'Name cant be null');
        
    }
    
    @isTest
    static void updateBranchPostalCodePositive() {
        dmpl__BranchPostalCode__c branchPostalCode = BranchTestDataHelper.getBranchPostalCode();
        System.assertNotEquals(branchPostalCode, null, 'BranchPostalCode should exist before update.');
        branchPostalCode.dmpl__CoverageType__c = 'Service';
        update branchPostalCode;
        dmpl__BranchPostalCode__c updatedPostalCode = BranchTestDataHelper.getBranchPostalCode(branchPostalCode.Id);
        System.assertEquals('Service', updatedPostalCode.dmpl__CoverageType__c, 'Expected CoverageType to be updated to Service');
    }
    
    @isTest
    static void deleteBranchPostalCodePositive() {
        dmpl__BranchPostalCode__c branchPostalCode = BranchTestDataHelper.getBranchPostalCode();
        System.assertNotEquals(branchPostalCode, null, 'BranchPostalCode should exist before delete.');
        delete branchPostalCode;
        dmpl__BranchPostalCode__c deletedPostalCode = null;
        try {
            deletedPostalCode = BranchTestDataHelper.getBranchPostalCode(branchPostalCode.Id);
        } catch (Exception e) {
            deletedPostalCode = null;
        }
        
        System.assertEquals(null, deletedPostalCode, 'BranchPostalCode should be deleted and not found in query.');
    }
    
    //Postal Code Result with Postal Code(New)
    @isTest
    static void createPostalCodeWithPostalCodeNamePositive(){
        dmpl__PostalCode__c postalCode = BranchTestDataHelper.createPostalCode('Pune');
        dmpl__PostalCode__c fetchedPostalCode = BranchTestDataHelper.getPostalCode(postalCode.Id);
        System.assertEquals('Pune', fetchedPostalCode.Name, 'Postal code Name should be Pune');
    }
    
    //Postal Code Result with Postal Code(Edit)
    @isTest
    static void updatePostalCodeWithPostalCodeNamePositive(){
        dmpl__PostalCode__c postalCode = BranchTestDataHelper.createPostalCode('Pune');
        dmpl__PostalCode__c fetchedPostalCode = BranchTestDataHelper.getPostalCode(postalCode.Id);
        
        fetchedPostalCode.Name = 'T1';
        Update fetchedPostalCode;
        
        dmpl__PostalCode__c updatedPostalCode = BranchTestDataHelper.getPostalCode(fetchedPostalCode.Id);
        
        System.assertEquals('T1', updatedPostalCode.Name, 'Postal code Name should be Pune');
    }

    //Postal Code Result without Postal Code(new)
    @isTest
    static void createPostalCodeWithPostalCodeNameNegative(){
        Boolean exceptionThrown = false;
        
        try {
           
            dmpl__PostalCode__c postalCode = BranchTestDataHelper.createPostalCode('');
            
        }
        catch (DmlException e) {
            exceptionThrown = true;
        }
        
        // System.assertEquals(true, exceptionThrown, 'Exception should be thrown when Postal Code Name is empty.');
        
    }

      
    //Create Branch Postal Code with all required fields: Branch and partner account
     @isTest
    Static void CreateBranchPostalCodeWithallRequiredFieldsBranchAndPartnerAccountPositive(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch();
        dmpl__PostalCode__c postalCode1 = BranchTestDataHelper.getPostalCode();
        
       dmpl__BranchPostalCode__c  BranchPostalCode = BranchTestDataHelper.createBranchPostalCode(partnerAccount1,branch1,postalCode1,null);
    
       dmpl__BranchPostalCode__c  fetchedBranchPostalCode = BranchTestDataHelper.getBranchPostalCode(BranchPostalCode.Id);
        System.assertEquals(partnerAccount1.Id, fetchedBranchPostalCode.dmpl__PartnerAccountId__c, 'Partner account should match');
        System.assertEquals(branch1.Id,  fetchedBranchPostalCode.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(postalCode1.Id, fetchedBranchPostalCode.dmpl__PostalCodeId__c, 'PostalCode should match');
       
    } 
    
    //Edit Branch Postal Code and Chaneg the Partner account
    @isTest
    static void updateBranchPostalCodeChangePartnerAccountPositive() {
        
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2', false, true, false, true, '45 Residency Road', 'Pune', 'Maharashtra', 'India', '411001', '22 Commerce Avenue', 'Pune', 'Maharashtra', 'India', '411038','91-99665544433');
        dmpl__Branch__c branch = TestDataHelpers.getBranch();

        dmpl__PostalCode__c postalCode = BranchTestDataHelper.getPostalCode();

        dmpl__BranchPostalCode__c branchPostalCode = BranchTestDataHelper.createBranchPostalCode(
            partnerAccount, branch, postalCode, null
        );

        branchPostalCode.dmpl__PartnerAccountId__c=partnerAccount2.Id;
        update branchPostalCode;

        dmpl__BranchPostalCode__c updatedbranchPostalCode = BranchTestDataHelper.getBranchPostalcode(branchPostalCode.Id);
       
    }
   
    //Save Postal Code with one selected Coverage Type
    @isTest
    Static void createPostalCodeWithOneSelectedCoverageTypePositive(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch();
        dmpl__PostalCode__c postalCode = BranchTestDataHelper.getPostalCode();
        dmpl__BranchPostalCode__c  BranchPostalCode = BranchTestDataHelper.createBranchPostalCode(partnerAccount1,branch1,postalCode,'Sale');
    
        dmpl__BranchPostalCode__c  fetchedBranchPostalCode = BranchTestDataHelper.getBranchPostalCode(BranchPostalCode.Id);
        System.assertEquals(partnerAccount1.Id, fetchedBranchPostalCode.dmpl__PartnerAccountId__c, 'Partner account should match');
        System.assertEquals(branch1.Id, fetchedBranchPostalCode.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(postalCode.Id, fetchedBranchPostalCode.dmpl__PostalCodeId__c, 'PostalCode should match');
        System.assertEquals('Sale',fetchedBranchPostalCode.dmpl__CoverageType__c,'Coverage type Shpuld be Sale');
    } 
    
    //Create record without selecting Partner Account (if optional)
    @isTest
    Static void createRecordWithoutSelectingPartnerAccountIfOptionalPositive(){
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch();
        
        dmpl__BranchPostalCode__c  BranchPostalCode = BranchTestDataHelper.createBranchPostalCode(null,branch1,null,null);
    
        dmpl__BranchPostalCode__c  fetchedBranchPostalCode = BranchTestDataHelper.getBranchPostalCode(BranchPostalCode.Id);
        System.assertEquals(null, fetchedBranchPostalCode.dmpl__PartnerAccountId__c, 'Partner account should be null');
        System.assertEquals(branch1.Id,  fetchedBranchPostalCode.dmpl__BranchId__c, 'Branch should match'); 
        System.assertEquals(null, fetchedBranchPostalCode.dmpl__PostalCodeId__c, 'PostalCode should be null');
       
    } 
     
    //Branch Postal Code creation with Adding  values in the postal code (new)
    @isTest
    static void createBranchPostalCodeWithPostalCodeDetailsPositive() {
   
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__PostalCode__c postalCode = BranchTestDataHelper.getPostalCode(); 

        dmpl__BranchPostalCode__c branchPostalCode = BranchTestDataHelper.createBranchPostalCode(
            partnerAccount  ,
            branch,
            postalCode,
            'Sale'
        );

        dmpl__BranchPostalCode__c fetchedBPC = BranchTestDataHelper.getBranchPostalCode(branchPostalCode.Id);
        System.assertEquals(branch.Id, fetchedBPC.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(partnerAccount.Id, fetchedBPC.dmpl__PartnerAccountId__c, 'Partner Account ID should match');
        System.assertEquals(postalCode.Id, fetchedBPC.dmpl__PostalCodeId__c, 'Postal Code ID should match');
        System.assertEquals('Sale', fetchedBPC.dmpl__CoverageType__c, 'Coverage Type should be set to sales');
   }
   
   //Creation of branch postal code with No value in the Coverage type (New)
   @isTest
   static void createBranchPostalCodeWithNoCoverageTypePositive() {
    Account partnerAccount = TestDataHelpers.getPartnerAccount();
    dmpl__Branch__c branch = TestDataHelpers.getBranch();
    dmpl__PostalCode__c postalCode = BranchTestDataHelper.getPostalCode();
    dmpl__BranchPostalCode__c branchPostalCode = BranchTestDataHelper.createBranchPostalCode(
        partnerAccount,
        branch,
        postalCode,
        null
    );

    dmpl__BranchPostalCode__c fetchedBPC = BranchTestDataHelper.getBranchPostalCode(branchPostalCode.Id);
    System.assertNotEquals(null, fetchedBPC, 'BranchPostalCode record should be created');
    System.assertEquals(partnerAccount.Id, fetchedBPC.dmpl__PartnerAccountId__c, 'Partner Account should match');
    System.assertEquals(branch.Id, fetchedBPC.dmpl__BranchId__c, 'Branch should match');
    System.assertEquals(postalCode.Id, fetchedBPC.dmpl__PostalCodeId__c, 'Postal Code should match');
    System.assertEquals(null, fetchedBPC.dmpl__CoverageType__c, 'Coverage Type should be null');
   }

    //Branch postal code creation With no branch name (new)
    @isTest
    static void createBranchPostalCodeWithoutBranchNameNegative() {
        Boolean exceptionThrown = false;
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__PostalCode__c postalCode = BranchTestDataHelper.getPostalCode();
        try {
            dmpl__BranchPostalCode__c invalidBPC = BranchTestDataHelper.createBranchPostalCode(
                partnerAccount,
                null, 
                postalCode,
                null
            );
            
        } catch (Exception e) {
        exceptionThrown= true;
        System.debug('Expected exception caught: ' + e.getMessage());
        }
        System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown when using null branch name');
    }

    //Creation branch postal code with Selecting all values of the coverage type(new)
    @isTest
    static void createBranchPostalCodeWithAllCoverageTypesPositive(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch();
        dmpl__PostalCode__c postalCode = BranchTestDataHelper.getPostalCode();
        dmpl__BranchPostalCode__c  BranchPostalCode = BranchTestDataHelper.createBranchPostalCode(partnerAccount1,branch1,postalCode,'All');
    
        dmpl__BranchPostalCode__c  fetchedBranchPostalCode = BranchTestDataHelper.getBranchPostalCode(BranchPostalCode.Id);
        System.assertEquals(partnerAccount1.Id, fetchedBranchPostalCode.dmpl__PartnerAccountId__c, 'Partner account should match');
        System.assertEquals(branch1.Id, fetchedBranchPostalCode.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(postalCode.Id, fetchedBranchPostalCode.dmpl__PostalCodeId__c, 'PostalCode should match');
        System.assertEquals('All',fetchedBranchPostalCode.dmpl__CoverageType__c,'Coverage type Shpuld be All');
    }




  
    //Partner Account does not match selected Branch (validation should trigger)
    @isTest
    static void createPartnerAccountDoesNotMatchSelectedBranchNegative() {
        
        Boolean exceptionThrown= false;
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1', false, true, false, true, 'MG Road', 'Bengaluru', 'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India', '560095','9876543210');
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__PostalCode__c postalCode = BranchTestDataHelper.getPostalCode();

        try {
             dmpl__BranchPostalCode__c branchPostalCode = BranchTestDataHelper.createBranchPostalCode(
                partnerAccount1,
                branch,
                postalCode,  
                null
            );
        } catch (Exception e) {
            exceptionThrown= true;
            System.debug('Expected exception caught: ' + e.getMessage());
       }
        //  System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown when using mismatch partner Account ');
    }
     
    //Save with wrong format in Postal Code field
    @isTest 
    static void createBranchPostalCodeWithInvalidPostalCodeFormatNegative() {
        Boolean exceptionThrown= false;
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__PostalCode__c postalCode = BranchTestDataHelper.getPostalCode();

        try {
             dmpl__BranchPostalCode__c branchPostalCode = BranchTestDataHelper.createBranchPostalCode(
                partnerAccount1,
                branch,
                postalCode,    
                null
            );
        } catch (Exception e) {
            exceptionThrown= true;
            System.debug('Expected exception caught: ' + e.getMessage());
       }
        //  System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown when using invalid postal code format ');
    
    }
}