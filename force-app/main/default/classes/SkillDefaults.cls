@isTest
public with sharing class SkillDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'Name' => 'Test Skill',
            'dmpl__Description__c' => 'Test Description',
            'dmpl__ExternalId__c' => 'SKILL-TEST-001'
        };
    }
}