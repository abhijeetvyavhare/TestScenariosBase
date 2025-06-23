@isTest
public with sharing class InsuranceSchemeHandler_Test {
    @TestSetup
    static void makeRequiredData() {
        InsuranceSchemeDataHelper.createInsuranceScheme();
    }

    @isTest
    static void testInsertInsuranceScheme() {
        dmpl__InsuranceScheme__c ins = InsuranceSchemeDataHelper.getInsuranceScheme();
        System.assert(ins != null, 'Insurance Scheme should be retrieved');
        System.assert(ins.Id != null, 'Insurance Scheme should be inserted');
    }

    @isTest
    static void testUpdateInsuranceScheme() {
        dmpl__InsuranceScheme__c ins = InsuranceSchemeDataHelper.getInsuranceScheme();
        ins.Name = 'Updated Insurance Scheme Name';
        update ins;

        dmpl__InsuranceScheme__c updated = InsuranceSchemeDataHelper.getInsuranceSchemeById(ins.Id);
        System.assertEquals('Updated Insurance Scheme Name', updated.Name);
    }

    @isTest
    static void testDeleteInsuranceScheme() {
        dmpl__InsuranceScheme__c ins = InsuranceSchemeDataHelper.getInsuranceScheme();
        delete ins;

        List<dmpl__InsuranceScheme__c> result = InsuranceSchemeDataHelper.getInsuranceSchemesByIdList(new List<Id>{ins.Id});
        System.assertEquals(0, result.size(), 'Insurance Scheme should be deleted');
    }
}