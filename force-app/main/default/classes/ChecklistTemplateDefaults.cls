@isTest
public with sharing class ChecklistTemplateDefaults implements TestFactory.FieldDefaults{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
                'Name'=>'ChecklistTemplate1',
                'dmpl__Code__c'=>'Code1',
                'dmpl__Type__c'=>'Delivery'
        };
    }
}