@isTest
public with sharing class AccountGroupDefaults implements TestFactory.FieldDefaults{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
                'Name'=>'AccountGroup1',
                'dmpl__AccountGroupType__c'=>'Discount',
                'dmpl__Description__c'=>'This is default Account Group',
                'dmpl__DynamicMemberType__c'=>'Field Filter',
                'dmpl__RuleSuccessCriteria__c'=>'All Rules Are Met'
        };
    }
}