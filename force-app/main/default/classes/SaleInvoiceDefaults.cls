@isTest
public with sharing class SaleInvoiceDefaults  implements TestFactory.FieldDefaults{
        
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__AccountName__c'=>'Account1',
            'dmpl__AdjustedAmount__c'=>2000,
            'dmpl__AmountPaid__c'=>1000,
            'dmpl__BillingAddress__c'=>'Address1',
            'dmpl__BillingCity__c'=>'Pune',
            'dmpl__BillingCountry__c'=>'India',
            'dmpl__BillingPostalCode__c'=>'411001',
            'dmpl__BillingRegion__c'=>'Region1',
            'dmpl__BillingState__c'=>'Maharashtra',
            'dmpl__BillingStreet__c'=>'Street1',
            'dmpl__Discount__c'=>10,
            'dmpl__FinanceAmount__c'=>2000,
            'dmpl__InvoiceGroup__c'=>'Parts',
            'dmpl__InvoiceNumber__c'=>'InvoiceNumber1',
            'dmpl__IsGLPosted__c'=>true,
            'dmpl__IsGLPostingApproved__c'=>true,
            'dmpl__IsInJobQueue__c'=>true,
            'dmpl__IsKPICalculated__c'=>true,
            'dmpl__PerformGLPosting__c'=>true,
            'dmpl__PerformKPICalculation__c'=>true,
            'dmpl__Remark__c'=>'Remark1',
            'dmpl__RoundOff__c'=>1,
            'dmpl__ShippingAddress__c'=>'Address1',
            'dmpl__ShippingCity__c'=>'Pune',
            'dmpl__ShippingCountry__c'=>'India',
            'dmpl__ShippingPostalCode__c'=>'411001',
            'dmpl__ShippingRegion__c'=>'Region1',
            'dmpl__ShippingStreet__c'=>'Street1',
            'dmpl__Status__c'=>'Draft',
            'dmpl__TaxSupplyType__c'=>'Within State',
            'dmpl__TCSEligibleAmount__c'=>1000,
            'dmpl__TransactionType__c'=>'Sample'
        };
    }
}