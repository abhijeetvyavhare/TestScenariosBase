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
            SELECT Id, Name, dmpl__Code__c, dmpl__Type__c,dmpl__ItemId__c ,dmpl__ParentChecklistId__c
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
            SELECT Id, Name,dmpl__ChecklistTemplateId__c, dmpl__DataType__c
            FROM dmpl__CheckListLines__c
            WHERE Id = :CheckListLineId
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }

    //New

    public static dmpl__ChecklistTemplate__c createChecklistTemplate(
        String checklistTemplateName,
        Id itemId,
        String type,
        Id parentChecklistId,
        String code
    ){
        return (dmpl__ChecklistTemplate__c) TestFactory.createSObject(
            new dmpl__ChecklistTemplate__c(
                Name = checklistTemplateName,
                dmpl__ItemId__c = itemId,
                dmpl__Type__c = type,
                dmpl__ParentChecklistId__c = parentChecklistId,
                dmpl__Code__c = code
            ),
            'ChecklistTemplateDefaults',
            true
        );
    }


    public static dmpl__ChecklistTemplate__c getChecklistTemplateByNameAndCode(String checklistTemplateName, String code) {
        List<dmpl__ChecklistTemplate__c> results = [
            SELECT Id, Name, dmpl__ItemId__c, dmpl__Type__c, dmpl__ParentChecklistId__c, dmpl__Code__c
            FROM dmpl__ChecklistTemplate__c
            WHERE Name = :checklistTemplateName AND dmpl__Code__c = :code
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }

    public static dmpl__ChecklistTemplateLine__c createChecklistTemplateLine(
        String checklistTemplateLineName,
        Id checklistTemplateId,
        String dataType,
        String groupBy,
        String defaultValue
    ) {
        return (dmpl__ChecklistTemplateLine__c) TestFactory.createSObject(
            new dmpl__ChecklistTemplateLine__c(
                Name = checklistTemplateLineName,
                dmpl__ChecklistTemplateId__c = checklistTemplateId,
                dmpl__DataType__c = dataType,
                dmpl__GroupBy__c = groupBy,
                dmpl__DefaultValue__c = defaultValue
            ),
            'ChecklistTemplateLineDefaults',
            true
        );
    }

    public static dmpl__ChecklistTemplate__c createChecklistTemplateWithoutInsert(
        String checklistTemplateName,
        Id itemId,
        String type,
        Id parentChecklistId,
        String code
    ) {
        return new dmpl__ChecklistTemplate__c(
            Name = checklistTemplateName,
            dmpl__ItemId__c = itemId,
            dmpl__Type__c = type,
            dmpl__ParentChecklistId__c = parentChecklistId,
            dmpl__Code__c = code
        );
    }

    public static dmpl__CheckListLines__c createChecklistLine(
        String name,
        Id checklistTemplateId,
        String dataType
    ) {
        return (dmpl__CheckListLines__c) TestFactory.createSObject(
            new dmpl__CheckListLines__c(
                Name = name,
                dmpl__ChecklistTemplateId__c = checklistTemplateId,
                dmpl__DataType__c = dataType
            ),
            'CheckListLinesDefaults',
            true
        );
    }

   




}