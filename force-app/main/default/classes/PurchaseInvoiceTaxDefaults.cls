@isTest
public with sharing class PurchaseInvoiceTaxDefaults  implements TestFactory.FieldDefaults{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'Name'=>'PurchaseInvoiceTax1',
            'dmpl__GLAmount__c'=>1000,
            'dmpl__IsGLPosted__c'=>true,
            'dmpl__IsGLPostingApproved__c'=>true,
            'dmpl__TaxAmount__c'=>1000,
            'dmpl__TaxName__c'=>'TaxName1',
            'dmpl__TaxOnAmount__c'=>1000,
            'dmpl__TaxRate__c'=>10
        };
    }
}