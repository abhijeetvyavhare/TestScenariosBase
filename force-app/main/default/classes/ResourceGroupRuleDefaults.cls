public with sharing class ResourceGroupRuleDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__ResourceGroupId__c' => null,
			'dmpl__FieldName__c' => 'Test-ResourceGroup',
			'dmpl__FieldValue__c' => 'Sample',
			'dmpl__Operation__c' => 'in',
			'dmpl__SequenceNumber__c' => 1
        };
    }
}