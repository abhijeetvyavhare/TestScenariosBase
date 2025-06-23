@isTest
public with sharing class SaleReturnLineDefault implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{ 
            'dmpl__ApplyPostTaxDiscount__c' => true,
            'dmpl__Discount2__c' => 10,
            'dmpl__DiscountAmount2__c' => 100.0,
            'dmpl__ChassisNumber__c' => '12',
            'dmpl__ContractDiscount__c' => 10,
            'dmpl__ContractDiscountAmount__c' => 100.0,
            'dmpl__Cost__c' => 1000.0,
            'dmpl__Discount__c' => 10,
            'dmpl__DiscountAmount__c' => 1000.0,
            'dmpl__EngineNumber__c' => 'EngineNumber1',
            'dmpl__IsApproved__c' => true,
            'dmpl__IsGLPosted__c' => false,
            'dmpl__IsGLPostingApproved__c' => false,
            'dmpl__IsILPosted__c' => false,
            'dmpl__IsILPostingApproved__c' => false,
            'dmpl__LineNumber__c' => 'LineNumber1',
            'dmpl__Quantity__c' => 10,
            'dmpl__SchemeDiscount__c' => 10,
            'dmpl__SchemeDiscountAmount__c' => 100.0,
            'dmpl__SchemeRewardPoints__c' => 1,
            'dmpl__UnitPrice2__c' => 100.0,
            'dmpl__UnitPrice__c' => 100.0
        };
    }
}