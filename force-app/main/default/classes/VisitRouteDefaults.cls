@isTest
public with sharing class VisitRouteDefaults  implements TestFactory.FieldDefaults
{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__CoverageMidpointDistance__c'=>10,
            'dmpl__FridayAvailable__c'=>true,
            'dmpl__IsActive__c'=>true,
            'dmpl__MondayAvailable__c'=>true,
            'dmpl__Remarks__c'=>'Remark1',
            'Name'=>'RouteName1',
            'dmpl__RoutingPriority__c'=>'Shortest Distance',
            'dmpl__SaturdayAvailable__c'=>true,
            'dmpl__SundayAvailable__c'=>true,
            'dmpl__ThursdayAvailable__c'=>true,
            'dmpl__TuesdayAvailable__c'=>true,
            'dmpl__VisitPurpose__c'=>'Order Capture',
            'dmpl__WednesdayAvailable__c'=>true
        };
    }
}