public with sharing class InsurerDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{ 
            'dmpl__AccountId__c' => null,              
            'dmpl__Description__c' => 'Default description',
            'dmpl__ExternalId__c' => null,             
            'dmpl__Insurance_Scheme__c' => null,       
            'Name' => 'Default Insurer Name',          
            'dmpl__Sale_Order__c' => null ,
            'dmpl__Insurance_Scheme__c' => null            
        };
    }
}