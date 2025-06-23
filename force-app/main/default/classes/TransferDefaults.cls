@isTest
public with sharing class TransferDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{
            'dmpl__PerformInwardPosting__c' => false,
            'dmpl__PerformInwardReceive__c' => false,
            'dmpl__TransferTime__c' => Date.today()
        };
    }
}