@isTest
public with sharing class VisitTaskTemplateEntryDefaults  implements TestFactory.FieldDefaults
{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__CanExecuteOutOfSequence__c'=>true,
            'dmpl__Description__c'=>'Description1',
            'Name'=>'VisitTaskTemplate1',
            'dmpl__IsHidden__c'=>true,
            'dmpl__IsMandatory__c'=>true,
            'dmpl__SequenceNumber__c'=>1,
            'dmpl__TaskDuration__c'=>1,
            'dmpl__TaskType__c'=>'Perform Visit Activities',
            'dmpl__VisibilityFilter__c'=>'VisibilityFilter1'
        };
    }
}