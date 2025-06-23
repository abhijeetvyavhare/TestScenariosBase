@isTest
public class IncentiveLineDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__DefinitionCustomLogic__c'=>'none',
            'dmpl__IncentivePlanId__c'=>'none'
        };
    }
}