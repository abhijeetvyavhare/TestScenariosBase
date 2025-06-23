public with sharing class ResourceGroupMemberDefaults implements TestFactory.FieldDefaults {

    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__ResourceId__c' => null,
			'dmpl__ResourceGroupId__c' => null
        };
    }
}