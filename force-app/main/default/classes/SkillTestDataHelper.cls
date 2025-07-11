@isTest
public with sharing class SkillTestDataHelper {
   public static dmpl__Skill__c createSkill() {
        return (dmpl__Skill__c) TestFactory.createSObject(
            new dmpl__Skill__c(
                Name = 'Test Skill',
                dmpl__Description__c = 'Test Description',
                dmpl__ExternalId__c = 'SKILL-TEST-001'
            ),
            'SkillDefaults',
            true
        );
    }

    public static dmpl__Skill__c getSkill() {
        return [
            SELECT Id, Name, dmpl__Description__c, dmpl__ExternalId__c
            FROM dmpl__Skill__c LIMIT 1
        ];
    }

    public static dmpl__SkillLine__c getSkillLine() {
        return [
            SELECT Id, Name, dmpl__SkillId__c, dmpl__WorkItemId__c
            FROM dmpl__SkillLine__c LIMIT 1
        ];
    }

    public static dmpl__SkillLine__c createSkillLine(dmpl__Skill__c skill, dmpl__Item__c item) {
        if (skill == null || item == null) {
            throw new IllegalArgumentException('Skill and Work Item must not be null');
        }

        return (dmpl__SkillLine__c) TestFactory.createSObject(
            new dmpl__SkillLine__c(
                dmpl__SkillId__c = skill.Id,
                dmpl__WorkItemId__c = item.Id
            ),
            'SkillLineDefaults',
            true
        );
    }

}