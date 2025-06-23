@isTest
public with sharing class ChecklistHandler_Test {
    @TestSetup
    static void createRequiredData() {
        String checklistTemplateName = 'Test Checklist Template';
        dmpl__ChecklistTemplate__c checklistTemplate = ChecklistDataHelper.createChecklistTemplate(checklistTemplateName);
        String checklistTemplateLineName = 'Test Checklist Template Line';
        dmpl__ChecklistTemplateLine__c checklistTemplateLine = ChecklistDataHelper.createChecklistTemplateLine(checklistTemplateLineName, checklistTemplate.Id);
        String setupChecklistLineName = 'Test Setup Checklist Line';
        dmpl__CheckListLines__c setupChecklistLine = ChecklistDataHelper.createChecklistLine(setupChecklistLineName);
    }

    @isTest
    static void createChecklistTemplatePositive() {
        dmpl__ChecklistTemplate__c checklistTemplate = ChecklistDataHelper.getChecklistTemplateByName('Test Checklist Template');
        System.assertNotEquals(checklistTemplate, null, 'Expected checklist template to be created.');
    }

    @isTest
    static void updateChecklistTemplatePositive() {
        dmpl__ChecklistTemplate__c checklistTemplate = ChecklistDataHelper.getChecklistTemplateByName('Test Checklist Template');
        checklistTemplate.Name = 'Updated Checklist Template Name';
        Test.startTest();
        update checklistTemplate;
        Test.stopTest();
        dmpl__ChecklistTemplate__c updated = ChecklistDataHelper.getChecklistTemplateById(checklistTemplate.Id);
        System.assertEquals(updated.Name, 'Updated Checklist Template Name', 'Checklist template name should be updated.');
    }

    @isTest
    static void deleteChecklistTemplatePositive() {
        dmpl__ChecklistTemplate__c checklistTemplate = ChecklistDataHelper.getChecklistTemplateByName('Test Checklist Template');
        Test.startTest();
        delete checklistTemplate;
        Test.stopTest();
        dmpl__ChecklistTemplate__c deletedTemplate = ChecklistDataHelper.getChecklistTemplateById(checklistTemplate.Id);
        System.assertEquals(deletedTemplate, null, 'Checklist template should be deleted.');
    }

    @isTest
    static void createChecklistTemplateLinePositive() {
        dmpl__ChecklistTemplateLine__c checklistTemplateLine = ChecklistDataHelper.getChecklistTemplateLineByName('Test Checklist Template Line');
        System.assertNotEquals(checklistTemplateLine, null, 'Expected checklist template line to be created.');
    }

    @isTest
    static void updateChecklistTemplateLinePositive() {
        dmpl__ChecklistTemplateLine__c checklistTemplateLine = ChecklistDataHelper.getChecklistTemplateLineByName('Test Checklist Template Line');
        checklistTemplateLine.Name = 'Updated Checklist Template Line Name';
        Test.startTest();
        update checklistTemplateLine;
        Test.stopTest();
        dmpl__ChecklistTemplateLine__c updated = ChecklistDataHelper.getChecklistTemplateLineById(checklistTemplateLine.Id);
        System.assertEquals(updated.Name, 'Updated Checklist Template Line Name', 'Checklist template line name should be updated.');
    }

    @isTest
    static void deleteChecklistTemplateLinePositive() {
        dmpl__ChecklistTemplateLine__c checklistTemplateLine = ChecklistDataHelper.getChecklistTemplateLineByName('Test Checklist Template Line');
        Test.startTest();
        delete checklistTemplateLine;
        Test.stopTest();
        dmpl__ChecklistTemplateLine__c deletedLine = ChecklistDataHelper.getChecklistTemplateLineById(checklistTemplateLine.Id);
        System.assertEquals(deletedLine, null, 'Checklist template line should be deleted.');
    }

    @isTest 
    static void createChecklistLinePositive() {
        dmpl__CheckListLines__c setUpChecklistLine = ChecklistDataHelper.getChecklistLineByName('Test Setup Checklist Line');
        System.assertNotEquals(setupChecklistLine, null, 'Expected checklistLine to be created.');
    }

    @isTest 
    static void updateChecklistLinePositive() {
        dmpl__CheckListLines__c setupChecklistLine = ChecklistDataHelper.getChecklistLineByName('Test Setup Checklist Line');
        setupChecklistLine.Name = 'Updated Name';
        Test.startTest();
        update setupChecklistLine;
        Test.stopTest();
        dmpl__CheckListLines__c updated = ChecklistDataHelper.getChecklistLineById(setupChecklistLine.Id);
        System.assertEquals(updated.Name, 'Updated Name', 'Checklist line name should be updated.');
    }
    
    @isTest 
    static void deleteChecklistLinePositive() {
        dmpl__CheckListLines__c setupChecklistLine = ChecklistDataHelper.getChecklistLineByName('Test Setup Checklist Line');
        Test.startTest();
        delete setupChecklistLine;
        Test.stopTest();
        dmpl__CheckListLines__c deletedLines = ChecklistDataHelper.getChecklistLineById(setupChecklistLine.Id);
        System.assertEquals(deletedLines, null, 'Checklist line should be deleted.');
    }
}