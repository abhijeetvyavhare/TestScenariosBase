@isTest
public class IncentivePeriodDefaults implements TestFactory.FieldDefaults{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__IncentivePlanId__c'=>null,
            'Name'=>'IncentivePeriod1',
            'dmpl__Status__c'=>'Approved'
        };
    }
   
}