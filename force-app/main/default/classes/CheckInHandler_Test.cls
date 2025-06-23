@isTest
public with sharing class CheckInHandler_Test {
    @TestSetup
    static void createRequiredData(){
        DateTime checkInDateTime = DateTime.newInstance(2026, 10, 1, 10, 0, 0);
        dmpl__CheckInInspection__c checkInInspection = CheckInDataHelper.createCheckInInspection(checkInDateTime);
        dmpl__CheckInInspectionLine__c checkInInspectionLine = CheckInDataHelper.createCheckInInspectionLine(checkInInspection.Id, 'Exterior');
        String CheckInTemplateExternalId = 'ExternalIDTEST123';
        dmpl__CheckInTemplate__c CheckInTemplate = CheckInDataHelper.createCheckInTemplate(CheckInTemplateExternalId);
        dmpl__CheckInTemplateLine__c CheckInTemplateLine = CheckInDataHelper.createCheckInTemplateLine('Front',CheckInTemplate.Id);
    }

    @isTest
    static void createCheckInInspectionPositive() {
        DateTime checkInDateTime = DateTime.newInstance(2026, 10, 1, 10, 0, 0);
        dmpl__CheckInInspection__c checkInInspection = CheckInDataHelper.getCheckInInspectionByDateTime(checkInDateTime);
        System.assertNotEquals(checkInInspection, null, 'Expected check-in inspection to be created.');
    }

    @isTest
    static void updateCheckInInspectionPositive() {
        DateTime checkInDateTime = DateTime.newInstance(2026, 10, 1, 10, 0, 0);
        dmpl__CheckInInspection__c checkInInspection = CheckInDataHelper.getCheckInInspectionByDateTime(checkInDateTime);
        checkInInspection.dmpl__CheckInDateTime__c = DateTime.newInstance(2026, 10, 1, 12, 0, 0);
        Test.startTest();
        update checkInInspection;
        Test.stopTest();
        dmpl__CheckInInspection__c updated = CheckInDataHelper.getCheckInInspectionById(checkInInspection.Id);
        System.assertEquals(updated.dmpl__CheckInDateTime__c, DateTime.newInstance(2026, 10, 1, 12, 0, 0), 'Check-in inspection date time should be updated.');
    }

    @isTest
    static void deleteCheckInInspectionPositive() {
        DateTime checkInDateTime = DateTime.newInstance(2026, 10, 1, 10, 0, 0);
        dmpl__CheckInInspection__c checkInInspection = CheckInDataHelper.getCheckInInspectionByDateTime(checkInDateTime);
        Test.startTest();
        delete checkInInspection;
        Test.stopTest();
        dmpl__CheckInInspection__c deletedInspection = CheckInDataHelper.getCheckInInspectionById(checkInInspection.Id);
        System.assertEquals(deletedInspection, null, 'Check-in inspection should be deleted.');
    }

    @isTest
    static void createCheckInInspectionLinePositive(){
        dmpl__CheckInInspectionLine__c checkInInspectionLine = CheckInDataHelper.getCheckInInspectionLineBySection('Exterior');
        System.assertNotEquals(checkInInspectionLine, null, 'Expected check-in inspection line to be created.');
    }

    @isTest
    static void updateCheckInInspectionLinePositive() {
        dmpl__CheckInInspectionLine__c checkInInspectionLine = CheckInDataHelper.getCheckInInspectionLineBySection('Exterior');
        checkInInspectionLine.dmpl__Section__c = 'Interior';
        Test.startTest();
        update checkInInspectionLine;
        Test.stopTest();
        dmpl__CheckInInspectionLine__c updatedLine = CheckInDataHelper.getCheckInInspectionLineById(checkInInspectionLine.Id);
        System.assertEquals(updatedLine.dmpl__Section__c, 'Interior', 'Check-in inspection line section should be updated.');
    }

    @isTest
    static void deleteCheckInInspectionLinePositive() {
        dmpl__CheckInInspectionLine__c checkInInspectionLine = CheckInDataHelper.getCheckInInspectionLineBySection('Exterior');
        Test.startTest();
        delete checkInInspectionLine;
        Test.stopTest();
        dmpl__CheckInInspectionLine__c deletedLine = CheckInDataHelper.getCheckInInspectionLineById(checkInInspectionLine.Id);
        System.assertEquals(deletedLine, null, 'Check-in inspection line should be deleted.');
    }

    @isTest
    static void createCheckInTemplatePositive() {
        String CheckInTemplateExternalId = 'ExternalIDTEST123';
        dmpl__CheckInTemplate__c CheckInTemplate = CheckInDataHelper.getCheckInTemplateByExternalId(CheckInTemplateExternalId);
        System.assertNotEquals(CheckInTemplate, null, 'Expected CheckIn template to be created.');
    }

    @isTest
    static void updateCheckInTemplatePositive() {
        String CheckInTemplateExternalId = 'ExternalIDTEST123';
        dmpl__CheckInTemplate__c CheckInTemplate = CheckInDataHelper.getCheckInTemplateByExternalId(CheckInTemplateExternalId);
        CheckInTemplate.dmpl__ExternalId__c = 'Updated ExternalID';
        Test.startTest();
        update CheckInTemplate;
        Test.stopTest();
        dmpl__CheckInTemplate__c updated = CheckInDataHelper.getCheckInTemplateById(CheckInTemplate.Id);
        System.assertEquals(updated.dmpl__ExternalId__c, 'Updated ExternalID', 'CheckIn template name should be updated.');
    }

    @isTest
    static void deleteCheckInTemplatePositive() {
        String CheckInTemplateExternalId = 'ExternalIDTEST123';
        dmpl__CheckInTemplate__c CheckInTemplate = CheckInDataHelper.getCheckInTemplateByExternalId(CheckInTemplateExternalId);
        Test.startTest();
        delete CheckInTemplate;
        Test.stopTest();
        dmpl__CheckInTemplate__c deletedTemplate = CheckInDataHelper.getCheckInTemplateById(CheckInTemplate.Id);
        System.assertEquals(deletedTemplate, null, 'CheckIn template should be deleted.');
    }

    @isTest 
    static void createCheckInTemplateLinePositive() {
        dmpl__CheckInTemplateLine__c CheckInTemplateLine = CheckInDataHelper.getCheckInTemplateLineBySectionName('Front');
        System.assertNotEquals(CheckInTemplateLine, null, 'Expected CheckIn template line to be created.');
    }

    @isTest 
    static void updateCheckInTemplateLinePositive() {
        dmpl__CheckInTemplateLine__c CheckInTemplateLine = CheckInDataHelper.getCheckInTemplateLineBySectionName('Front');
        CheckInTemplateLine.dmpl__SectionName__c = 'Back';
        Test.startTest();
        update CheckInTemplateLine;
        Test.stopTest();
        dmpl__CheckInTemplateLine__c updatedLine = CheckInDataHelper.getCheckInTemplateLineById(CheckInTemplateLine.Id);
        System.assertEquals(updatedLine.dmpl__SectionName__c, 'Back', 'CheckIn template line section name should be updated.');
    }
    
    @isTest
    static void deleteCheckInTemplateLinePositive() {
        dmpl__CheckInTemplateLine__c CheckInTemplateLine = CheckInDataHelper.getCheckInTemplateLineBySectionName('Front');
        Test.startTest();
        delete CheckInTemplateLine;
        Test.stopTest();
        dmpl__CheckInTemplateLine__c deletedLine = CheckInDataHelper.getCheckInTemplateLineById(CheckInTemplateLine.Id);
        System.assertEquals(deletedLine, null, 'CheckIn template line should be deleted.');
    }
}