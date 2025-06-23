@isTest
public with sharing class BillLineDefaults implements TestFactory.FieldDefaults{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__ApplyPostTaxDiscount__c'=>true,
            'dmpl__Discount2__c'=>5,
            'dmpl__DiscountAmount2__c'=>1000,
            'dmpl__ContractDiscount__c'=>10,
            'dmpl__ContractDiscountAmount__c'=>2000,
            'dmpl__Description__c'=>'Description',
            'dmpl__Discount__c'=>10,
            'dmpl__DiscountAmount__c'=>1000,
            'dmpl__IsCustomerBillable__c'=>true,
            'dmpl__IsGLPosted__c'=>true,
            'dmpl__IsGLPostingApproved__c'=>true,
            'dmpl__IsILPosted__c'=>true,
            'dmpl__IsILPostingApproved__c'=>true,
            'dmpl__Quantity__c'=>5,
            'dmpl__ReturnedQuantity__c'=>1,
            'dmpl__SchemeDiscount__c'=>5,
            'dmpl__SchemeDiscountAmount__c'=>1000,
            'dmpl__SchemeRewardPoints__c'=>5,
            'dmpl__TaxAmount__c'=>1000,
            'dmpl__UnitCost2__c'=>1000,
            'dmpl__UnitCost__c'=>1000
        };
    }
}