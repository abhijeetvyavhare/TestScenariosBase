@isTest
public with sharing class ProductDemoDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__CancellationReason__c'=>'Postponed',
            'dmpl__CustomerVoice__c'=>'Voice1',
            'dmpl__DemoAddress__c'=>'Address1',
            'dmpl__DemoAssetNumber__c'=>'1',
            'dmpl__DemoRating__c'=>'1',
            'dmpl__Status__c'=>'Scheduled',
            'dmpl__ExternalId__c'=>'1234',
            'dmpl__IsCancelled__c'=>true,
            'dmpl__IsConfirmed__c'=>true,
            'dmpl__IsDemoOnsite__c'=>true,
            'dmpl__KYCDocumentNumber__c'=>'1',
            'dmpl__Remarks__c'=>'Remarks1',
            'dmpl__ServiceJobType__c'=>'None',
            'dmpl__ServiceType__c'=>'Paid Repairs',
            'dmpl__UsageReadingEnd__c'=> 2,
            'dmpl__UsageReadingStart__c'=> 1
        };
    }
    
}