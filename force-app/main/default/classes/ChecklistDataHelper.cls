@isTest
public with sharing class ChecklistDataHelper {
    public static dmpl__ChecklistTemplate__c createChecklistTemplate(
        String checklistTemplateName
    ){
        return (dmpl__ChecklistTemplate__c) TestFactory.createSObject(
            new dmpl__ChecklistTemplate__c(
                Name = checklistTemplateName
            ),
            'ChecklistTemplateDefaults',
            true
        );
    }

    public static dmpl__ChecklistTemplate__c createChecklistTemplateWithDefaults(){
        return createChecklistTemplate('DefaultChecklistTemplate');
    }

    public static List<dmpl__ChecklistTemplate__c> getChecklistTemplates() {
        List<dmpl__ChecklistTemplate__c> results = [
            SELECT Id, Name, dmpl__Code__c, dmpl__Type__c
            FROM dmpl__ChecklistTemplate__c
        ];
        return results.isEmpty() ? null : results;
    }

    public static dmpl__ChecklistTemplate__c getChecklistTemplateByName(String checklistTemplateName) {
        List<dmpl__ChecklistTemplate__c> results = [
            SELECT Id, Name, dmpl__Code__c, dmpl__Type__c
            FROM dmpl__ChecklistTemplate__c
            WHERE Name = : checklistTemplateName
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }

    public static dmpl__ChecklistTemplate__c getChecklistTemplateById(Id checklistTemplateId) {
        List<dmpl__ChecklistTemplate__c> results = [
            SELECT Id, Name, dmpl__Code__c, dmpl__Type__c
            FROM dmpl__ChecklistTemplate__c
            WHERE Id = :checklistTemplateId
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }

    public static dmpl__ChecklistTemplateLine__c createChecklistTemplateLine(
        String checklistTemplateLineName,
        Id checklistTemplateId
    ){
        return (dmpl__ChecklistTemplateLine__c) TestFactory.createSObject(
            new dmpl__ChecklistTemplateLine__c(
                Name = checklistTemplateLineName,
                dmpl__ChecklistTemplateId__c = checklistTemplateId
            ),
            'ChecklistTemplateLineDefaults',
            true
        );
    }

    public static dmpl__ChecklistTemplateLine__c createChecklistTemplateLineWithDefaults(
        Id checklistTemplateId
    ){
        return createChecklistTemplateLine('DefaultChecklistTemplateLine', checklistTemplateId);
    }

    public static List<dmpl__ChecklistTemplateLine__c> getChecklistTemplateLines() {
        List<dmpl__ChecklistTemplateLine__c> results = [
            SELECT Id, Name, dmpl__DataType__c, dmpl__DefaultValue__c, dmpl__GroupBy__c
            FROM dmpl__ChecklistTemplateLine__c
        ];
        return results.isEmpty() ? null : results;
    }

    public static dmpl__ChecklistTemplateLine__c getChecklistTemplateLineByName(String checklistTemplateLineName) {
        List<dmpl__ChecklistTemplateLine__c> results = [
            SELECT Id, Name, dmpl__DataType__c, dmpl__DefaultValue__c, dmpl__GroupBy__c
            FROM dmpl__ChecklistTemplateLine__c
            WHERE Name = : checklistTemplateLineName
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }

    public static dmpl__ChecklistTemplateLine__c getChecklistTemplateLineById(Id checklistTemplateLineId) {
        List<dmpl__ChecklistTemplateLine__c> results = [
            SELECT Id, Name, dmpl__DataType__c, dmpl__DefaultValue__c, dmpl__GroupBy__c
            FROM dmpl__ChecklistTemplateLine__c
            WHERE Id = :checklistTemplateLineId
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }

    public static dmpl__CheckListLines__c createChecklistLine(
        String checklistLineName
    ){
        return (dmpl__CheckListLines__c) TestFactory.createSObject(
            new dmpl__CheckListLines__c(
                Name = checklistLineName
            ),
            'CheckListLinesDefaults',
            true
        );
    }

    public static dmpl__CheckListLines__c createChecklistLineWithDefaults(){
        return createChecklistLine('DefaultChecklistLine');
    }

    public static List<dmpl__CheckListLines__c> getChecklistLines() {
        List<dmpl__CheckListLines__c> results = [
            SELECT Id, Name
            FROM dmpl__CheckListLines__c
        ];
        return results.isEmpty() ? null : results;
    }

    public static dmpl__CheckListLines__c getChecklistLineByName(String checklistLineName) {
        List<dmpl__CheckListLines__c> results = [
            SELECT Id, Name
            FROM dmpl__CheckListLines__c
            WHERE Name = : checklistLineName
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }

    public static dmpl__CheckListLines__c getChecklistLineById(Id CheckListLineId) {
        List<dmpl__CheckListLines__c> results = [
            SELECT Id, Name
            FROM dmpl__CheckListLines__c
            WHERE Id = :CheckListLineId
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }
}