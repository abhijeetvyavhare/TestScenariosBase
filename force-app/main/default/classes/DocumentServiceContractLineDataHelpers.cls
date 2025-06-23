public class DocumentServiceContractLineDataHelpers {
    public static dmpl__DocumentServiceContract__c createDocumentServiceContractLine(){
        return (dmpl__DocumentServiceContract__c)TestFactory.createSObject(
            new dmpl__DocumentServiceContract__c(),
            'DocumentServiceContractLineDefaults',
            true
        );
    }
    
    public static dmpl__DocumentServiceContract__c getDocumentServiceContractLine() {
        return [
            Select Id, dmpl__Quantity__c, dmpl__IsInScope__c
            FROM dmpl__DocumentServiceContract__c
            LIMIT 1
        ];
    }
    
    public static dmpl__DocumentServiceContract__c getDocumentServiceContractLine(Id id) {
        return [
            Select Id, dmpl__Quantity__c, dmpl__IsInScope__c
            FROM dmpl__DocumentServiceContract__c
            WHERE Id = :id
            LIMIT 1
        ];
    }
}