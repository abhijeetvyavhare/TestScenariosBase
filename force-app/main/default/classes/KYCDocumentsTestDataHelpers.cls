public with sharing class KYCDocumentsTestDataHelpers {
    public static dmpl__KYCDocument__c createKYCDocuments(
    	dmpl__SaleOrder__c saleOrder
    ) {
        return (dmpl__KYCDocument__c) TestFactory.createSObject(
        	new dmpl__KYCDocument__c(
            	dmpl__SaleOrderId__c = saleOrder.Id
            ),
            'KYCDocumentDefaults',
            true
        );
    }
    
    public static dmpl__KYCDocument__c getKYCDocument() {
        return [
            SELECT Id, dmpl__DocumentNumber__c
            FROM dmpl__KYCDocument__c
            LIMIT 1
        ];
    }
    
    public static dmpl__KYCDocument__c getKYCDocument(Id id) {
        return [
            SELECT Id, dmpl__DocumentNumber__c
            FROM dmpl__KYCDocument__c
            WHERE Id = : id
            LIMIT 1
        ];
    }
}