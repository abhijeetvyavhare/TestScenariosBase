@isTest
public with sharing class VisitDefaults  implements TestFactory.FieldDefaults{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__GeofencingTolerance__c'=>1,
            'dmpl__Remarks__c'=>'Remarks1',
            'dmpl__SequenceNumber__c'=>1,
            'dmpl__ShowAcceptRejectOption__c'=>true,
            'dmpl__ShowGetDirectionOption__c'=>true,
            'dmpl__ShowProgressPanel__c'=>true,
            'dmpl__ShowRescheduleOption__c'=>true,
            'dmpl__ShowVisitStartEndOption__c'=>true,
            'dmpl__VisitCancellationReason__c'=>'Insufficient Information',
            'dmpl__VisitCity__c'=>'Pune',
            'dmpl__VisitCountry__c'=>'India',
            'dmpl__VisitPostalCode__c'=>'Postal Code',
            'dmpl__VisitPurpose__c'=>'Order Capture',
            'dmpl__VisitRegion__c'=>'Region1',
            'dmpl__VisitState__c'=>'Punjab',
            'dmpl__VisitStatus__c'=>'Planned',
            'dmpl__VisitStreet__c'=>'Street1'
        };
    }
}