@isTest
public with sharing class CaseHandler_Test {
    @testSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();
        dmpl__Branch__c Branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__Resource__c resource = TestDataHelpers.createResource(partnerAccount,Branch);
        dmpl__Case__c Case1 = CaseTestDataHelper.createCase(TestDataHelpers.getPartnerAccount(),TestDataHelpers.getCustomerAccount(),
                                                            TestDataHelpers.getBranch(),TestDataHelpers.getResource());
    }

    @isTest
    static void createCasePositive() {
        dmpl__Case__c newCase = CaseTestDataHelper.getCase();
        System.assertEquals('9733387909', newCase.dmpl__Mobile__c, 'Mobile should be 9733387909');
        System.assertEquals('Test-Account', newCase.dmpl__AccountName__c, 'AccountName should be Test-Account');
        System.assertEquals('9733387909', newCase.dmpl__AccountPhone__c, 'AccountPhone should match');
        System.assertEquals('Medium', newCase.dmpl__Priority__c, 'Priority should be Medium');
        System.assertEquals('Phone', newCase.dmpl__CaseSource__c, 'CaseSource should be Phone');
        System.assertEquals('Performance', newCase.dmpl__CaseReason__c, 'CaseReason should be Performance');
        System.assertEquals('New', newCase.dmpl__Status__c, 'Status should be New');
        System.assertEquals('Test Remarks', newCase.dmpl__Remarks__c, 'Remarks should be Test Remarks');
    }


    @isTest
    static void updateCasePositive() {
        dmpl__Case__c newCase = CaseTestDataHelper.getCase();
        newCase.dmpl__AccountName__c = 'Test';
        newCase.dmpl__Priority__c = 'High';
        newCase.dmpl__Status__c = 'Working';
        newCase.dmpl__Remarks__c = 'Updated Remarks';
        newCase.dmpl__Mobile__c = '8888888888';
        newCase.dmpl__AccountPhone__c = '9999999999';
        newCase.dmpl__CaseReason__c = 'Installation';
        newCase.dmpl__CaseSource__c = 'Email';
        update newCase;
        
        dmpl__Case__c updatedCase = CaseTestDataHelper.getCase(newCase.Id);
        System.assertEquals('Test', updatedCase.dmpl__AccountName__c, 'AccountName should be Test');
        System.assertEquals('High', updatedCase.dmpl__Priority__c, 'Priority should be High');
        System.assertEquals('Working', updatedCase.dmpl__Status__c, 'Status should be Working');
        System.assertEquals('Updated Remarks', updatedCase.dmpl__Remarks__c, 'Remarks should be Updated Remarks');
        System.assertEquals('8888888888', updatedCase.dmpl__Mobile__c, 'Mobile should be updated');
        System.assertEquals('9999999999', updatedCase.dmpl__AccountPhone__c, 'AccountPhone should be updated');
        System.assertEquals('Installation', updatedCase.dmpl__CaseReason__c, 'CaseReason should be updated');
        System.assertEquals('Email', updatedCase.dmpl__CaseSource__c, 'CaseSource should be updated');
    }
    
    
    @isTest
    static void deleteCasePositive() {
        dmpl__Case__c newCase = CaseTestDataHelper.getCase();
        Id caseId = newCase.Id;
        delete newCase;

        dmpl__Case__c deletedCase;
        

        try {
            deletedCase = CaseTestDataHelper.getCase(caseId);
        } catch (Exception e) {
            deletedCase = null;
        }

        System.assertEquals(null, deletedCase, 'Case should be marked as deleted');
    }
  
}