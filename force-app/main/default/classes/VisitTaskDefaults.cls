@isTest
public with sharing class VisitTaskDefaults  implements TestFactory.FieldDefaults
{
        public Map<String, Object> getFieldDefaults(){
            return new Map<String, Object>{ 
                'dmpl__IsHidden__c'=>true,
                'dmpl__SequenceNumber__c'=>1,
                'dmpl__Status__c'=>'Planned',
                'dmpl__TaskName__c'=>'VisitTask1',
                'dmpl__TaskType__c'=>'Perform Visit Activities'
        };
    }
   
}