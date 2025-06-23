@isTest
public with sharing class DebitNoteDefaults implements TestFactory.FieldDefaults{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__AdjustedAmount__c' => 200
        };
    }
}