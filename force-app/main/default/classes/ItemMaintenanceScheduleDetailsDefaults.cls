@isTest
public with sharing class ItemMaintenanceScheduleDetailsDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
           'dmpl__LastServiceDate__c' => Date.today()
        };
    }
}