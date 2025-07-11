@isTest
public with sharing class CheckInDataHelper {
    public static dmpl__CheckInInspection__c createCheckInInspection(
        DateTime checkInDateTime
    ) {
        return (dmpl__CheckInInspection__c) TestFactory.createSObject(
            new dmpl__CheckInInspection__c (
                dmpl__CheckInDateTime__c = checkInDateTime
            ),
            'CheckInInspectionDefaults',
            true
        );
    }

    public static dmpl__CheckInInspection__c createCheckInInspectionWithDefaults() {
        DateTime checkInDateTime = DateTime.newInstance(2026, 5, 25, 10, 30, 0);
        return createCheckInInspection(checkInDateTime);
    }

    public static List<dmpl__CheckInInspection__c> getCheckInInspections() {
        List<dmpl__CheckInInspection__c> results = [
            SELECT Id, dmpl__CheckInDateTime__c, dmpl__CheckInType__c
            FROM dmpl__CheckInInspection__c
        ];

        return results.isEmpty() ? null : results;
    }

    public static dmpl__CheckInInspection__c getCheckInInspectionById(Id checkInInspectionId) {
        List<dmpl__CheckInInspection__c> results = [
            SELECT Id, dmpl__CheckInDateTime__c, dmpl__CheckInType__c
            FROM dmpl__CheckInInspection__c
            WHERE Id = :checkInInspectionId
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }

    public static dmpl__CheckInInspection__c getCheckInInspectionByDateTime(DateTime checkInDateTime) {
        List<dmpl__CheckInInspection__c> results = [
            SELECT Id, dmpl__CheckInDateTime__c, dmpl__CheckInType__c
            FROM dmpl__CheckInInspection__c
            WHERE dmpl__CheckInDateTime__c = :checkInDateTime
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }

    public static dmpl__CheckInInspectionLine__c createCheckInInspectionLine(
        Id checkInInspectionId,
        String section
    ) {
        return (dmpl__CheckInInspectionLine__c) TestFactory.createSObject(
            new dmpl__CheckInInspectionLine__c (
                dmpl__CheckInInspectionId__c = checkInInspectionId,
                dmpl__Section__c = section
            ),
            'CheckInInspectionLineDefaults',
            true
        );
    }

    public static dmpl__CheckInInspectionLine__c createCheckInInspectionLineWithDefaults(
        Id checkInInspectionId
    ) {
        return createCheckInInspectionLine(checkInInspectionId, 'Section TESTING');
    }

    public static List<dmpl__CheckInInspectionLine__c> getCheckInInspectionLines() {
        List<dmpl__CheckInInspectionLine__c> results = [
            SELECT Id, dmpl__Condition__c, dmpl__Section__c, dmpl__CheckInInspectionId__c
            FROM dmpl__CheckInInspectionLine__c
        ];

        return results.isEmpty() ? null : results;
    }

    public static dmpl__CheckInInspectionLine__c getCheckInInspectionLineById(Id checkInInspectionLineId) {
        List<dmpl__CheckInInspectionLine__c> results = [
            SELECT Id, dmpl__Condition__c, dmpl__Section__c, dmpl__CheckInInspectionId__c,dmpl__SubSection__c
            FROM dmpl__CheckInInspectionLine__c
            WHERE Id = :checkInInspectionLineId
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }

    public static dmpl__CheckInInspectionLine__c getCheckInInspectionLineBySection(String section){
        List<dmpl__CheckInInspectionLine__c> results = [
            SELECT Id, dmpl__Condition__c, dmpl__Section__c, dmpl__CheckInInspectionId__c,dmpl__SubSection__c
            FROM dmpl__CheckInInspectionLine__c
            WHERE dmpl__Section__c = :section
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }

    public static dmpl__CheckInTemplate__c createCheckInTemplate(
        String externalId
    ) {
        return (dmpl__CheckInTemplate__c) TestFactory.createSObject(
            new dmpl__CheckInTemplate__c (
                dmpl__ExternalId__c = externalId
            ),
            'CheckInTemplateDefaults',
            true
        );
    }

    public static dmpl__CheckInTemplate__c createCheckInTemplateWithDefaults() {
        return createCheckInTemplate('Default Check-In External ID');
    }
    public static List<dmpl__CheckInTemplate__c> getCheckInTemplates() {
        List<dmpl__CheckInTemplate__c> results = [
            SELECT Id, dmpl__ExternalId__c, Name
            FROM dmpl__CheckInTemplate__c
        ];

        return results.isEmpty() ? null : results;
    }

    public static dmpl__CheckInTemplate__c getCheckInTemplateById(Id checkInTemplateId) {
        List<dmpl__CheckInTemplate__c> results = [
            SELECT Id, dmpl__ExternalId__c, Name
            FROM dmpl__CheckInTemplate__c
            WHERE Id = :checkInTemplateId
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }

    public static dmpl__CheckInTemplate__c getCheckInTemplateByExternalId(String externalId) {
        List<dmpl__CheckInTemplate__c> results = [
            SELECT Id, dmpl__ExternalId__c, Name
            FROM dmpl__CheckInTemplate__c
            WHERE dmpl__ExternalId__c = :externalId
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }

    public static dmpl__CheckInTemplateLine__c createCheckInTemplateLine(
        String sectionName,
        Id checkInTemplateId
    ) {
        return (dmpl__CheckInTemplateLine__c) TestFactory.createSObject(
            new dmpl__CheckInTemplateLine__c (
                dmpl__SectionName__c = sectionName,
                dmpl__CheckInTemplateId__c = checkInTemplateId
            ),
            'CheckInTemplateLineDefaults',
            true
        );
    }

    public static dmpl__CheckInTemplateLine__c createCheckInTemplateLineWithDefaults(
        Id checkInTemplateId
    ) {
        return createCheckInTemplateLine('Front', checkInTemplateId);
    }

    public static List<dmpl__CheckInTemplateLine__c> getCheckInTemplateLines() {
        List<dmpl__CheckInTemplateLine__c> results = [
            SELECT Id, dmpl__SectionName__c, dmpl__CheckInTemplateId__c
            FROM dmpl__CheckInTemplateLine__c
        ];

        return results.isEmpty() ? null : results;
    }

    public static dmpl__CheckInTemplateLine__c getCheckInTemplateLineById(Id checkInTemplateLineId) {
        List<dmpl__CheckInTemplateLine__c> results = [
            SELECT Id, dmpl__SectionName__c, dmpl__CheckInTemplateId__c,dmpl__SubSection__c, dmpl__Issues__c
            FROM dmpl__CheckInTemplateLine__c
            WHERE Id = :checkInTemplateLineId
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }
    
    public static dmpl__CheckInTemplateLine__c getCheckInTemplateLineBySectionName(String sectionName) {
        List<dmpl__CheckInTemplateLine__c> results = [
            SELECT Id, dmpl__SectionName__c, dmpl__CheckInTemplateId__c
            FROM dmpl__CheckInTemplateLine__c
            WHERE dmpl__SectionName__c = :sectionName
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }

public static dmpl__CheckInInspection__c CreateCheckIn(
    Account partnerAccount,
    Account customerAccount,
    dmpl__Branch__c branch,
    Asset asset 
) {
    return (dmpl__CheckInInspection__c) TestFactory.createSObject(
        new dmpl__CheckInInspection__c(
            dmpl__PartnerAccountId__c = partnerAccount != null ? partnerAccount.Id : null,
            dmpl__AccountId__c        = customerAccount != null ? customerAccount.Id : null,
            dmpl__BranchId__c         = branch != null ? branch.Id : null,
            dmpl__AssetId__c          = asset != null ? asset.Id : null
        ),
        'CheckInInspectionDefaults',
        true
    );
}

    public static dmpl__CheckInInspection__c GetCheckIn(Id id) {
        return [
            SELECT 
                Id,
                Name,
                dmpl__PartnerAccountId__c,
                dmpl__ServiceAdvisorId__c,
                // dmpl__Section__c,
                //dmpl__SubSection__c,
                dmpl__AccountId__c,
                dmpl__BranchId__c,
                dmpl__AssetId__c,
                dmpl__DocumentDate__c,
                dmpl__Status__c,
                dmpl__MobileNumber__c
            FROM dmpl__CheckInInspection__c
            WHERE Id = :id
            LIMIT 1];
    }

    
    public static dmpl__CheckInInspectionLine__c createCheckInInspectionLinWithSubsectionCondition(
        Id checkInInspectionId,
        String section,
        String subsection,
        String conditionValues
    ) {
        return (dmpl__CheckInInspectionLine__c) TestFactory.createSObject(
            new dmpl__CheckInInspectionLine__c (
                dmpl__CheckInInspectionId__c = checkInInspectionId,
                dmpl__Section__c = section,
                dmpl__SubSection__c=subsection,
                dmpl__Condition__c=conditionValues
            ),
            //'CheckInInspectionLineDefaults',
            true
        );
    }
    
    public static dmpl__CheckInTemplateLine__c createCheckInTemplateLine(
        Id checkInTemplateId,
        String sectionName,
        String subSection,
        String issues
    ) {
        return (dmpl__CheckInTemplateLine__c) TestFactory.createSObject(
            new dmpl__CheckInTemplateLine__c (
                dmpl__CheckInTemplateId__c = checkInTemplateId,
                dmpl__SectionName__c = sectionName,
                dmpl__SubSection__c = subSection,
                dmpl__Issues__c = issues
            ),
            // 'CheckInTemplateLineDefaults',
            true
        );
    }

    




}