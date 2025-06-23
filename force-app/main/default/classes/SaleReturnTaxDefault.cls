@isTest
public with sharing class SaleReturnTaxDefault implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__TaxAmount__c' => 150.0,
            'dmpl__TaxOnAmount__c' => 1500.0,
            'dmpl__TaxRate__c' => 10.0,
            'dmpl__IsGLPosted__c' => false,
            'dmpl__IsGLPostingApproved__c' => false
        };
    }
}