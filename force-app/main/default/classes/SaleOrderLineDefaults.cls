@isTest
public with sharing class SaleOrderLineDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__ApplyPostTaxDiscount__c' => false,
            'dmpl__BenefitIndex__c' => 0,
            'dmpl__CancelledQuantity__c' => 0,
            'dmpl__ContractDiscount__c' => 0,
            'dmpl__ConversionRatio__c' => 1,
            'dmpl__ConversionRatio1__c' => 1,
            'dmpl__Discount__c' => 5,
            'dmpl__Discount2__c' => 0,
            'dmpl__DiscountAmount__c' => 0,
            'dmpl__DiscountAmount2__c' => 0,
            'dmpl__ExcludeInAutoOrder__c' => false,
            'dmpl__InvoiceQuantity__c' => 0,
            'dmpl__IsILPosted__c' => false,
            'dmpl__IsILPostingApproved__c' => false,
            'dmpl__IsPriceBundled__c' => false,
            'dmpl__IsSchemeGenerated__c' => false,
            'dmpl__LimitExpiryDays__c' => 0,
            'dmpl__SchemeDiscount__c' => 0,
            'dmpl__SchemeDiscountAmount__c' => 0,
            'dmpl__SchemeRewardPoints__c' => 0,
            'dmpl__SKUId__c' => null,
            'dmpl__Tax1__c' => 0,
            'dmpl__Tax1Rate__c' => 0,
            'dmpl__Tax2__c' => 0,
            'dmpl__Tax2Rate__c' => 0,
            'dmpl__TaxGroupId__c' => null,
            'dmpl__UnitPrice__c' => 500,
            'dmpl__UnitPrice2__c' => 500,
            'dmpl__UOMQuantity__c' => 0,
            'dmpl__UOMQuantity1__c' => 0
        };
    }
}