@isTest
public with sharing class SkillHandlerTest {

    @TestSetup
    static void createRequiredData() {
        dmpl__Skill__c skill = SkillTestDataHelper.createSkill();
        dmpl__Item__c item = TestDataHelpers.createItem();
        
        dmpl__SkillLine__c skillLine = SkillTestDataHelper.createSkillLine(skill, item);
    }

    @isTest
    static void testCreateSkillAndSkillLine() {
        dmpl__Skill__c skill = SkillTestDataHelper.getSkill();
        System.assertNotEquals(null, skill, 'Skill should be created');
        System.assertEquals('Test Skill', skill.Name, 'Skill Name should match');
        System.assertEquals('Test Description', skill.dmpl__Description__c, 'Skill Description should match');
        System.assertEquals('SKILL-TEST-001', skill.dmpl__ExternalId__c, 'Skill External ID should match');

        dmpl__SkillLine__c skillLine = SkillTestDataHelper.getSkillLine();
        System.assertNotEquals(null, skillLine, 'SkillLine should be created');
        System.assertEquals(skill.Id, skillLine.dmpl__SkillId__c, 'SkillLine should reference correct Skill');
    }

    @isTest
    static void testUpdateSkill() {
        dmpl__Skill__c skill = SkillTestDataHelper.getSkill();
        skill.Name = 'Updated Skill Name';
        update skill;

        dmpl__Skill__c updatedSkill =SkillTestDataHelper.getSkill();
        System.assertEquals('Updated Skill Name', updatedSkill.Name, 'Skill name should be updated');
    }

   @isTest
static void testDeleteSkillLine() {
    dmpl__SkillLine__c skillLine = SkillTestDataHelper.getSkillLine();
    delete skillLine;

    dmpl__SkillLine__c deletedLine;
    try {
        deletedLine = SkillTestDataHelper.getSkillLine();
    } catch (QueryException e) {
        deletedLine = null; 
    }

    System.assertEquals(null, deletedLine, 'SkillLine should be deleted');
}

}