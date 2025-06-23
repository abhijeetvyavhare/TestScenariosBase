@isTest
public with sharing class BranchTimeSlotDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{
            'dmpl__IsActive__c' => true,
            'dmpl__MaximumCapacity__c' => 12,
            'dmpl__MondayCapacity__c' => 12
    };
}

}