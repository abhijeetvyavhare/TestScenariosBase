@isTest
public with sharing class ResourceAvailabilityDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__AvailabilityType__c' => 'Present',
			'dmpl__Date__c' => null
        };
    }
}