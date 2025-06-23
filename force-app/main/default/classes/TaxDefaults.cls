public with sharing class TaxDefaults implements TestFactory.FieldDefaults{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{
            'Name' => 'Test - Tax',
            'dmpl__PostingFieldName__c' => 'Tax1'
        };
    }
}