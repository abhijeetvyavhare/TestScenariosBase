@isTest
public with sharing class ServiceRecommendationDefaults  implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__AcceptLabel__c'=>'AceptanceLabel1',
            'dmpl__Recommendation__c'=>'Recommendation1',
            'dmpl__RecommendationRemarks__c'=>'ActionReference1',
            'dmpl__IsRejected__c'=>false,
            'dmpl__RejectLabel__c'=>'RejectionLabel1'
        };
    }
}