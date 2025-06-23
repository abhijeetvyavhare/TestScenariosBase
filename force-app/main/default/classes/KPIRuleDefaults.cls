@isTest
public class KPIRuleDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'Name' => 'Test KPI Rule',
            'dmpl__FieldName__c' => 'Test_Field__c',
            'dmpl__FieldValue__c' => 'TestValue',
            'dmpl__Operation__c' => 'equals',
            'dmpl__Sequence_Number__c' => 1
        };
    }
}