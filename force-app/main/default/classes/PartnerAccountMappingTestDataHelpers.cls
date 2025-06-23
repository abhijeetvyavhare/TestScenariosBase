@isTest
public class PartnerAccountMappingTestDataHelpers {
    public static dmpl__PartnerAccountMapping__c createPartnerAccountMapping() {
        return (dmpl__PartnerAccountMapping__c) TestFactory.createSObject(
        	new dmpl__PartnerAccountMapping__c(),
            'PartnerAccountMappingDefaults',
            true
        );
    }
    
    public static dmpl__PartnerAccountMapping__c getPartnerAccountMapping() {
        return [
            SELECT Id, dmpl__FromDate__c, dmpl__ToDate__c
            FROM dmpl__PartnerAccountMapping__c
            LIMIT 1
        ];
    }
    
    public static dmpl__PartnerAccountMapping__c getPartnerAccountMapping(Id id) {
        return [
            SELECT Id, dmpl__FromDate__c, dmpl__ToDate__c
            FROM dmpl__PartnerAccountMapping__c
            WHERE Id = : id
            LIMIT 1
        ];
    }
}