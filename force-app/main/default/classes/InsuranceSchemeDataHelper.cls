public with sharing class InsuranceSchemeDataHelper {
    public static dmpl__InsuranceScheme__c createInsuranceScheme() {
        return (dmpl__InsuranceScheme__c) TestFactory.createSObject(
            new dmpl__InsuranceScheme__c(),
            'InsuranceSchemeDefault',
            true
        );
    }

    public static dmpl__InsuranceScheme__c getInsuranceScheme() {
        return [
            SELECT Id, Name
            FROM dmpl__InsuranceScheme__c
            LIMIT 1
        ];
    }

    public static dmpl__InsuranceScheme__c getInsuranceSchemeById(Id insId) {
        return [
            SELECT Id, Name
            FROM dmpl__InsuranceScheme__c
            WHERE Id = :insId
            LIMIT 1
        ];
    }

    public static List<dmpl__InsuranceScheme__c> getInsuranceSchemesByIdList(List<Id> ids) {
        return [
            SELECT Id
            FROM dmpl__InsuranceScheme__c
            WHERE Id IN :ids
        ];
    }
}