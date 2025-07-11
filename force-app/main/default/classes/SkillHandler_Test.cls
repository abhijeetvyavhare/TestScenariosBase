@isTest
public with sharing class SkillHandler_Test {
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

   @isTest
    static void testSkillLineCreationWithSkillNamePositive() {
    Test.startTest();

    dmpl__Skill__c skill = SkillTestDataHelper.getSkill();
    dmpl__Item__c item = TestDataHelpers.createItem();
    dmpl__SkillLine__c skillLine = SkillTestDataHelper.createSkillLine(skill, item);

    Test.stopTest();

    System.assertNotEquals(null, skillLine.Id, 'Skill Line should be created');
    System.assertEquals(skill.Id, skillLine.dmpl__SkillId__c, 'Skill Line should be linked to correct Skill');
    System.assertEquals(item.Id, skillLine.dmpl__WorkItemId__c, 'Skill Line should be linked to correct Work Item');
}

    @isTest
    static void testSkillLineCreationWithoutSkillNameNegative() {
        Test.startTest();
        try {
            dmpl__Item__c item = TestDataHelpers.createItem();
            SkillTestDataHelper.createSkillLine(null, item);
        } catch (Exception e) {
            System.debug('Expected exception: ' + e.getMessage());

            System.assert(
                e.getMessage().toLowerCase().contains('skill') ||
                e.getMessage().toLowerCase().contains('required') ||
                e.getMessage().toLowerCase().contains('review fields'),
                'Exception should mention missing or blank Skill Name'
            );
        }
        Test.stopTest();
    }

    @isTest
    static void testSkillLineCreationWithWorkItemPositive() {
        Test.startTest();
        dmpl__Skill__c skill = SkillTestDataHelper.getSkill();
        dmpl__Item__c item = TestDataHelpers.getItem();
        dmpl__SkillLine__c skillLine = SkillTestDataHelper.createSkillLine(skill, item);

        Test.stopTest();

        System.assertNotEquals(null, skillLine.Id, 'Skill Line should be created');
        System.assertEquals(skill.Id, skillLine.dmpl__SkillId__c, 'Skill Line should reference correct Skill');
        System.assertEquals(item.Id, skillLine.dmpl__WorkItemId__c, 'Skill Line should reference correct Work Item');
    }




}