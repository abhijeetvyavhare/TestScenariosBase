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
            Test.startTest();
            dmpl__PostalCode__c postalCode = BranchTestDataHelper.createPostalCode('');
            Test.stopTest();
        }
        catch (DmlException e) {
            exceptionThrown = true;
        }
        
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown when Postal Code Name is empty.');
        
    }
}