@isTest
public class InspectionLineDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__Quantity__c'=>1,
            'dmpl__AdjustmentQuantity__c'=>1,
            'dmpl__DamagedQuantity__c'=>0,
            'dmpl__InspectionQuantity__c'=>1,
            'dmpl__OrderQuantity__c'=>1,
            'dmpl__ReceivedQuantity__c'=>1,
            'dmpl__UnitCost__c'=>1199
        };
    }
}