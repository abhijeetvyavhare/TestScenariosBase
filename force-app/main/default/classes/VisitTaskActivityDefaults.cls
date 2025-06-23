@isTest
public with sharing class VisitTaskActivityDefaults  implements TestFactory.FieldDefaults{
    
        public Map<String, Object> getFieldDefaults(){
            return new Map<String, Object>{ 
                'dmpl__ActivityName__c'=>'VisitTaskActivity1',
                'dmpl__ActivityType__c'=>'Record Text Value',
                'dmpl__BooleanValue__c'=>true,
                'dmpl__CurrencyValue__c'=>2000.00,
                'dmpl__DecimalValue__c'=>2.00,
                'dmpl__FieldName__c'=>'VisitTaskActivityField1',
                'dmpl__FieldValue__c'=>'VisitTaskActivityFieldValue',
                'dmpl__IsActivityCompleted__c'=>true,
                'dmpl__IsDisabled__c'=>true,
                'dmpl__IsHidden__c'=>true,
                'dmpl__LongTextValue__c'=>'LongTextValueVisitTaskActivity',
                'dmpl__NumericValue__c'=>123,
                'dmpl__ObjectName__c'=>'dmpl__SaleOrder__c',
                'dmpl__PerformAutomatically__c'=>true,
                'dmpl__Phone__c'=>'9999999999',
                'dmpl__SequenceNumber__c'=>1,
                'dmpl__Status__c'=>'Planned',
                'dmpl__TextValue__c'=>'TextValueVisitTaskActivity'
        };
    }
}