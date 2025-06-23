@isTest
public with sharing class SaleInvoiceLineDefaults implements TestFactory.FieldDefaults {

    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{ 
            //'dmpl__AllocatedQuantity__c' => 9,
            'dmpl__ApplyPostTaxDiscount__c' => true,
            'dmpl__BillingFrequency__c' => 'Monthly',
            'dmpl__BillingType__c' => 'Advance',
            'dmpl__Discount2__c' => 10,
            'dmpl__DiscountAmount2__c' => 100.0,
            'dmpl__ChargeType__c' => 'Usage',
            'dmpl__ContractDiscount__c' => 10,
            'dmpl__ContractDiscountAmount__c' => 100.0,
            'dmpl__DeliveredQuantity__c' => null,
            'dmpl__Discount__c' => 1,
            'dmpl__DiscountAmount__c' => 100.0,
            'dmpl__IsClaimed__c' => true,
            'dmpl__IsGLPosted__c' => true,
            'dmpl__IsGLPostingApproved__c' => true,
            'dmpl__IsILPosted__c' => true,
            'dmpl__IsILPostingApproved__c' => true,
            'dmpl__IsPriceBundled__c' => false,
            'dmpl__PickedQuantity__c' => 1,
            'dmpl__Quantity__c' => 10,
            'dmpl__ReturnedQuantity__c' => 1,
            'dmpl__SchemeDiscount__c' => 10,
            'dmpl__SchemeDiscountAmount__c' => 100.0,
            'dmpl__SchemeRewardPoints__c' => 3,
            'dmpl__TaxAmount__c' => 100.0,
            'dmpl__UnitCost__c' => 10000.0,
            'dmpl__UnitPrice2__c' => 10000.0,
            'dmpl__UnitPrice__c' => 10000.0
        };
    }
}