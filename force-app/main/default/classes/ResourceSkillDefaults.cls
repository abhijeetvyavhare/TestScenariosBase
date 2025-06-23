@isTest
public with sharing class ResourceSkillDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__SkillLevel__c' => 1,
            'dmpl__StartDate__c' => Date.today(),
            'dmpl__EndDate__c' => Date.today().addDays(30),
            'dmpl__IsActive__c' => true,
            'dmpl__ResourceId__c' => null
        };
    }
}