@isTest
public with sharing class SchemeConditionDefaults implements TestFactory.FieldDefaults {
    
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            //'dmpl__AccountId__c' =>customerAccount.Id,
            //'dmpl__SchemeId__c' => scheme.Id,
            //'dmpl__ItemId__c'=>item.Id,
            //'dmpl__ItemGroupId__c'=>itemGroup.Id,         
            //'dmpl__AccountGroupId__c' =>accountGroup.Id,
            //'dmpl__ItemSKUId__c'=>sku.Id,         
            // 'dmpl__ConditionType__c'=>'Quantity',
            // 'dmpl__ConditionQuantity__c' =>'5',
            // 'dmpl__ConditionValue__c' => '100',
            // 'dmpl__SequenceNumber__c' => '1',
            // //'dmpl__SchemeLineId__c'=>schemeLine.Id
            // 'dmpl__RewardGroup__c' => 'Reward',
            // //'dmpl__PartnerAccountId__c' => partneraccount.Id, 
            // 'dmpl__ConditionOperator__c' => 'Greater Than'
        };
    }
}