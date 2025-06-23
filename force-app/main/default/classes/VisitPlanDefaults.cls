@isTest
public with sharing class VisitPlanDefaults implements TestFactory.FieldDefaults { 
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__AcceptanceStatus__c'=>'Accept',
            'dmpl__City__c'=>'Pune',
            'dmpl__PendingDeliveryCheckouts__c'=>true,
            'dmpl__PendingDeliveryOrders__c'=>true,
            'Name'=>'VisitPlan1',
            'dmpl__PinCode__c'=>'160006',
            'dmpl__Remarks__c'=>'Remarks1',
            'dmpl__RouteMethod__c'=>'By Map Selection',
            'dmpl__State__c'=>'Punjab',
            'dmpl__Status__c'=>'Draft',
            'dmpl__VisitPurpose__c'=>'Order Capture'
        };
    }
}