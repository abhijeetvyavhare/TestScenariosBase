@isTest
public class KYCDocumentDefaults implements TestFactory.FieldDefaults{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
             'dmpl__DocumentNumber__c' => '3534534'
        };
    }
}