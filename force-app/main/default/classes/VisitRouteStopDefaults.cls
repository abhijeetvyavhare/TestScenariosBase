@isTest
public with sharing class VisitRouteStopDefaults implements TestFactory.FieldDefaults
{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__AllowedGeofencingTolerance__c'=>2,
            'dmpl__Remarks__c'=>'Remarks',
            'dmpl__SequenceNumber__c'=>1,
            'Name'=>'VisitRoute1',
            'dmpl__VisitPurpose__c'=>'Order Capture'
        };
    }
}