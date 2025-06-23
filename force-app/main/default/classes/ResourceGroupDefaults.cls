public with sharing class ResourceGroupDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'Name' => 'Test-ResourceGroup', 
			'dmpl__ResourceGroupType__c' => 'Incentive', 
			'dmpl__DynamicMemberType__c' => 'Field Filter'
        };
    }
}