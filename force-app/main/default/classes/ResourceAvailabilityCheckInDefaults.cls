@isTest
public with sharing class ResourceAvailabilityCheckInDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__ResourceAvailabilityId__c' => null,
			'dmpl__CheckInSource__c' => 'Desktop'
        };
    }
}