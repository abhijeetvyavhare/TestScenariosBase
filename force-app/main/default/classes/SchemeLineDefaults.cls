@isTest
public with sharing class SchemeLineDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__DefinitionCustomLogic__c'     => 'Test custom logic',
            'dmpl__DefinitionFilterCriteria__c'  => 'Any Condition Is Met',
            'dmpl__RewardApplicability__c'       => 'All Rewards',
            'dmpl__RewardCustomLogic__c'         => 'Reward on full quantity',
            'dmpl__SequenceNumber__c'            => 1,
            'dmpl__Title__c'                     => 'Test Slab Title'
        };
    }
}