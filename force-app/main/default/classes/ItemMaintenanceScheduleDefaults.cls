@isTest
public with sharing class ItemMaintenanceScheduleDefaults implements TestFactory.FieldDefaults{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{
            'dmpl__Sequence__c' => 1,
            'dmpl__ToDurationDays__c' => 30,
            'dmpl__ToUsageHours__c' => 100.00,
            'dmpl__ToUsageReading__c' => 1000.00
         };
    }
}