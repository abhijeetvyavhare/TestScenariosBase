@isTest
public with sharing class BranchDateSlotResultDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{
            'dmpl__Capacity__c' => 12,
            'dmpl__CapacityUtilized__c' => 6
        };
    }
}