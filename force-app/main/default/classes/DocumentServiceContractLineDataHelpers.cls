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
    public static dmpl__DocumentServiceContract__c createDocumentServiceContractLine(
        dmpl__ServiceRequestLine__c requestLine,
        dmpl__SaleOrderLine__c saleOrderLine,
        dmpl__Item__c componentitem
        ){
        return (dmpl__DocumentServiceContract__c)TestFactory.createSObject(
            new dmpl__DocumentServiceContract__c(
                dmpl__ServiceRequestLineId__c =requestLine?.Id,
                dmpl__SaleOrderLineId__c=saleOrderLine?.Id,
                dmpl__ComponentItemId__c=componentitem?.Id
            ),
            // 'DocumentServiceContractLineDefaults',
            true
        );
    }

    
}