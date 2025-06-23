@isTest
public with sharing class VisitRouteGroupDefaults implements TestFactory.FieldDefaults
{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'Name'=>'Visit Route Group 1',
            'dmpl__VisitRouteCode__c'=>'143001',
            'dmpl__VisitPurpose__c'=>'Order Delivery'
        };
    }
}