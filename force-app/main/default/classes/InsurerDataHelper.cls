@isTest
public with sharing class InsurerDataHelper {
    public static dmpl__Insurer__c createInsurer(Id accountId) {
        return (dmpl__Insurer__c) TestFactory.createSObject(
            new dmpl__Insurer__c(
                dmpl__AccountId__c = accountId
            ),
            'InsurerDefaults',
            true
        );
    }

    public static dmpl__Insurer__c getInsurer() {
        return [
            SELECT Id, dmpl__AccountId__c, Name, dmpl__Sale_Order__c, dmpl__Description__c, dmpl__ExternalId__c, dmpl__Insurance_Scheme__c
            FROM dmpl__Insurer__c
            LIMIT 1
        ];
    }

    public static dmpl__Insurer__c getInsurer(Id insurerId) {
        return [
            SELECT Id, dmpl__AccountId__c, Name, dmpl__Sale_Order__c, dmpl__Description__c, dmpl__ExternalId__c, dmpl__Insurance_Scheme__c
            FROM dmpl__Insurer__c
            WHERE Id = :insurerId
            LIMIT 1
        ];
    }

    public static dmpl__InsuranceOrderLine__c createInsuranceOrderLine(Id saleOrderId, Id saleOrderLineId, Id insurerId) {
        return (dmpl__InsuranceOrderLine__c) TestFactory.createSObject(
            new dmpl__InsuranceOrderLine__c(
                dmpl__SaleOrderId__c = saleOrderId,
                dmpl__SaleOrderLineId__c = saleOrderLineId,
                dmpl__InsurerId__c = insurerId
            ),
            'InsuranceOrderLineDefaults',
            true
        );
    }

    public static dmpl__InsuranceOrderLine__c getInsuranceOrderLine() {
        return [
            SELECT Id, Name, dmpl__ConfirmedBy__c, dmpl__DocumentDate__c, dmpl__ExpiryDate__c,
                   dmpl__ExternalId__c, dmpl__InsuranceAmount__c, dmpl__InsuranceDate__c,
                   dmpl__InsurerId__c, dmpl__PolicyNumber__c, dmpl__Remarks__c,
                   dmpl__SaleOrderId__c, dmpl__SaleOrderLineId__c, dmpl__Status__c
            FROM dmpl__InsuranceOrderLine__c
            LIMIT 1
        ];
    }

    public static dmpl__InsuranceOrderLine__c getInsuranceOrderLine(Id id) {
        return [
            SELECT Id, Name, dmpl__ConfirmedBy__c, dmpl__DocumentDate__c, dmpl__ExpiryDate__c,
                   dmpl__ExternalId__c, dmpl__InsuranceAmount__c, dmpl__InsuranceDate__c,
                   dmpl__InsurerId__c, dmpl__PolicyNumber__c, dmpl__Remarks__c,
                   dmpl__SaleOrderId__c, dmpl__SaleOrderLineId__c, dmpl__Status__c
            FROM dmpl__InsuranceOrderLine__c
            WHERE Id = :id
            LIMIT 1
        ];
    }
    
    public static List<dmpl__InsuranceOrderLine__c> getInsuranceOrderLines() {
        return [SELECT Id FROM dmpl__InsuranceOrderLine__c];
    }
}