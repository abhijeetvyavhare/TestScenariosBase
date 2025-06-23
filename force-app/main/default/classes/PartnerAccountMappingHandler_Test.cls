@isTest
public with sharing class PartnerAccountMappingHandler_Test {
	@TestSetup
    static void createRequiredDate() {
        dmpl__PartnerAccountMapping__c partnerAccountMapping = PartnerAccountMappingTestDataHelpers.createPartnerAccountMapping();
    }
    
    @isTest
    static void createPartnerAccountMapping() {
      	dmpl__PartnerAccountMapping__c partnerAccountMapping = PartnerAccountMappingTestDataHelpers.getPartnerAccountMapping();
      	System.assertEquals(Date.today(), partnerAccountMapping.dmpl__FromDate__c, 'From Date mismatch');
        System.assertEquals(Date.today().addDays(1), partnerAccountMapping.dmpl__ToDate__c, 'To Date mismatch');
    }
    
    @isTest
    static void updatePartnerAccountMapping() {
      	dmpl__PartnerAccountMapping__c partnerAccountMapping = PartnerAccountMappingTestDataHelpers.getPartnerAccountMapping();
        partnerAccountMapping.dmpl__ToDate__c = Date.today().addDays(2);
        update partnerAccountMapping;
        dmpl__PartnerAccountMapping__c updatedPartnerAccountMapping = PartnerAccountMappingTestDataHelpers.getPartnerAccountMapping();
      	System.assertEquals(Date.today(), updatedPartnerAccountMapping.dmpl__FromDate__c, 'From Date mismatch');
        System.assertEquals(Date.today().addDays(2), updatedPartnerAccountMapping.dmpl__ToDate__c, 'To Date mismatch');
    }
    
    @isTest
    static void deletePartnerAccountMapping() {
        dmpl__PartnerAccountMapping__c partnerAccountMapping = PartnerAccountMappingTestDataHelpers.getPartnerAccountMapping();
        System.assertNotEquals(null, partnerAccountMapping, 'Partner Account Mapping should exist before deletion.');
        Id mappingId = partnerAccountMapping.Id;
        delete partnerAccountMapping;
        dmpl__PartnerAccountMapping__c deletedMapping;
        try {
            deletedMapping = PartnerAccountMappingTestDataHelpers.getPartnerAccountMapping(mappingId);
        } catch (Exception e) {
            deletedMapping = null;
        }
        System.assertEquals(null, deletedMapping, 'Partner Account Mapping should be marked as deleted.');
    }
}