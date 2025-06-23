@isTest
public with sharing class SubscriptionInvoiceDefaults  implements TestFactory.FieldDefaults
{
    
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__BilledQuantity__c'=>'10',
            // 'CreatedById'=>'',
            // 'LastModifiedById'=>'',
            //'dmpl__NextBillingDate__c'=>'nul',
            'dmpl__OverrideAmount__c'=>'1000',
            'dmpl__OverrideQuantity__c'=>'10',
            //'dmpl__OverrideSummaryEndDate__c'=>'null',
            // 'dmpl__SaleInvoiceId__c'=>'',
            // 'dmpl__SaleInvoiceLineId__c'=>'',
            // 'dmpl__SubscriptionId__c'=>'',
            // 'dmpl__SummaryEndDate__c'=>'null',
            //'Name'=>'',
            //'dmpl__SummaryStartDate__c'=>'null',
            'dmpl__UnbilledQuantity__c'=>'10',
            'dmpl__UnitPrice__c'=>'100'
        };
    }
}