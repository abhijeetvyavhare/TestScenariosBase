@isTest
public with sharing class RepairOrderTimeSheetLineDefaults implements TestFactory.FieldDefaults {
    
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__ActualDurationHours__c' => 1.00
        };
    }
}