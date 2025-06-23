@isTest
public with sharing class VisitTaskTemplateDefaults  implements TestFactory.FieldDefaults
{   
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{
            'dmpl__Description__c'=>'Description',
            'dmpl__Duration__c'=>10,
            'dmpl__ShowAcceptRejectOption__c'=>true,
            'dmpl__ShowGetDirectionOption__c'=>true,
            'dmpl__ShowProgressPanel__c'=>true,
            'dmpl__ShowRescheduleOption__c'=>true,
            'dmpl__ShowVisitStartEndOption__c'=>true,
            'Name'=>'VisitTaskTemplate1'
        };
    }
}