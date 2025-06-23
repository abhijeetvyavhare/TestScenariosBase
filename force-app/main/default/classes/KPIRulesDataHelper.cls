public with sharing class KPIRulesDataHelper {
    public static dmpl__KPIRules__c createKPIRule(
        dmpl__KPIConfiguration__c kpiConfig,
        String fieldName,
        String fieldValue,
        String operation,
        Integer sequenceNumber
    ) {
        return (dmpl__KPIRules__c) TestFactory.createSObject(
            new dmpl__KPIRules__c(
                Name = 'Test KPI Rule',
                dmpl__KPIConfigurationId__c = kpiConfig.Id,
                dmpl__FieldName__c = fieldName,
                dmpl__FieldValue__c = fieldValue,
                dmpl__Operation__c = operation,
                dmpl__Sequence_Number__c = sequenceNumber
            ),
            'KPIRuleDefaults',
            true
        );
    }

    public static dmpl__KPIRules__c getKPIRule() {
        return [
            SELECT Id, Name, dmpl__KPIConfigurationId__c, dmpl__FieldName__c, dmpl__FieldValue__c, dmpl__Operation__c, dmpl__Sequence_Number__c
            FROM dmpl__KPIRules__c
            WHERE Name = 'Test KPI Rule'
            LIMIT 1
        ];
    }

    public static dmpl__KPIRules__c getKPIRule(Id ruleId) {
        return [
            SELECT Id, Name, dmpl__KPIConfigurationId__c, dmpl__FieldName__c, dmpl__FieldValue__c, dmpl__Operation__c, dmpl__Sequence_Number__c
            FROM dmpl__KPIRules__c
            WHERE Id = :ruleId
            LIMIT 1
        ];
    }

    public static dmpl__KPIRules__c updateKPIRule(dmpl__KPIRules__c rule, String newFieldValue) {
        rule.dmpl__FieldValue__c = newFieldValue;
        update rule;
        return getKPIRule(rule.Id);
    }

    public static Integer deleteKPIRule(dmpl__KPIRules__c rule) {
        Id ruleId = rule.Id;
        delete rule;
        return [
            SELECT COUNT() FROM dmpl__KPIRules__c WHERE Id = :ruleId
        ];
    }
}