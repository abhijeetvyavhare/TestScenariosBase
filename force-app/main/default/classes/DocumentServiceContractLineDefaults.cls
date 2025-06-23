@isTest
public class DocumentServiceContractLineDefaults implements TestFactory.FieldDefaults{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__IsInScope__c' => true,
            'dmpl__Quantity__c' => 20
        };
    }
}