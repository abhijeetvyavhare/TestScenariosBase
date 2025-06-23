@isTest
public with sharing class BillReturnTaxDefaults implements TestFactory.FieldDefaults{
        public Map<String, Object> getFieldDefaults(){
            return new Map<String, Object>{
                'dmpl__IsGLPosted__c'=>true,
                'dmpl__IsGLPostingApproved__c'=>true,
                'dmpl__TaxAmount__c'=>1000,
                'dmpl__TaxOnAmount__c'=>true,
                'dmpl__TaxOnLineAmount__c'=>1000,
                'dmpl__TaxRate__c'=>10
        };
    }
    
}