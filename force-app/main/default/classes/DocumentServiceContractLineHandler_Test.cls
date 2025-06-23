@isTest
public with sharing class DocumentServiceContractLineHandler_Test {
    @TestSetup
    static void createRequiredData(){
        dmpl__DocumentServiceContract__c documentServiceContractLine = DocumentServiceContractLineDataHelpers.createDocumentServiceContractLine();
    }

    @isTest
    static void createDocumentServiceContractLinePositive() {
        dmpl__DocumentServiceContract__c documentServiceContractLine = DocumentServiceContractLineDataHelpers.getDocumentServiceContractLine();
        
        System.assertEquals(documentServiceContractLine.dmpl__Quantity__c, 20, 'Quantity mismatch');
        System.assertEquals(documentServiceContractLine.dmpl__IsInScope__c, true, 'Scope should true');
    }
    
    @isTest
    static void updateDocumentServiceContractLinePositive() {
        dmpl__DocumentServiceContract__c documentServiceContractLine = DocumentServiceContractLineDataHelpers.getDocumentServiceContractLine();
        
        documentServiceContractLine.dmpl__Quantity__c = 40;
        documentServiceContractLine.dmpl__IsInScope__c = true;
        
        update documentServiceContractLine;
        
        dmpl__DocumentServiceContract__c updatedDocumentServiceContractLine = DocumentServiceContractLineDataHelpers.getDocumentServiceContractLine();
        System.assertEquals(updatedDocumentServiceContractLine.dmpl__Quantity__c, 40, 'Quantity mismatch');
        System.assertEquals(updatedDocumentServiceContractLine.dmpl__IsInScope__c, true, 'Scope should true');
    }
    
    @isTest
    static void deleteDocumentServiceContractLine() {
        dmpl__DocumentServiceContract__c documentServiceContractLine = DocumentServiceContractLineDataHelpers.getDocumentServiceContractLine();
        System.assertNotEquals(null, documentServiceContractLine, 'Record should exist before deletion.');
    
        Id docId = documentServiceContractLine.Id;
    
        delete documentServiceContractLine;
        dmpl__DocumentServiceContract__c deletedDocLine;
    
        try {
            deletedDocLine = DocumentServiceContractLineDataHelpers.getDocumentServiceContractLine();
        } catch (Exception e) {
            deletedDocLine = null;
        }
    
        System.assertEquals(null, deletedDocLine, 'Document Service Contract Line should be deleted and not found in query.');
    }

}