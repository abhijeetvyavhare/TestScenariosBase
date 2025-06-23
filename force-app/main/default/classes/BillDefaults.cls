@isTest
public with sharing class BillDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__AccountName__c'=>'Account1',
            'dmpl__AdjustedAmount__c'=>2000,
            'dmpl__AmountPaid__c'=>5000,
            'dmpl__BillingAddress__c'=>'BillAddress1',
            'dmpl__BillingCity__c'=>'Pune',
            'dmpl__BillingCountry__c'=>'India',
            'dmpl__BillingPostalCode__c'=>'billingPostalCode1',
            'dmpl__BillingRegion__c'=>'billingRegion1',
            'dmpl__BillingState__c'=>'Maharashtra',
            'dmpl__BillingStreet__c'=>'billingStreet1',
            'dmpl__Description__c'=>'description1',
            'dmpl__DocumentDate__c'=>date.today(),
            'dmpl__DueDate__c'=>date.today(),
            'dmpl__IsBillGenerated__c'=>true,
            'dmpl__IsGLPosted__c'=>true,
            'dmpl__IsGLPostingApproved__c'=>true,
            'dmpl__IsKPICalculated__c'=>true,               
            'dmpl__PerformGLPosting__c'=>true,
            'dmpl__PerformKPICalculation__c'=>true,
            'dmpl__PriceAsOnDate__c'=>date.today(),
            'dmpl__Remarks__c'=>'Remark1',
            'dmpl__RoundOff__c'=>200,
            'dmpl__ShippingCity__c'=>'Pune',
            'dmpl__ShippingCountry__c'=>'India',
            'dmpl__ShippingPostalCode__c'=>'null',
            'dmpl__ShippingRegion__c'=>'Region1',
            'dmpl__ShippingState__c'=>'Maharashtra',
            'dmpl__ShippingStreet__c'=>'null',
            'dmpl__Status__c'=>'Draft',
            'dmpl__SupplierInvoiceAmount__c'=>2000,
            'dmpl__TaxSupplyType__c'=>'Within State',
            'dmpl__TCSEligibleAmount__c'=>1000,
            'dmpl__TransactionType__c'=>'Sample',
            'dmpl__TypeOfBill__c'=>'Expense Bill'
        };
    }
}