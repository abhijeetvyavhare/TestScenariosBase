@isTest
public with sharing class BillReturnDefaults implements TestFactory.FieldDefaults{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__Description__c'=>'Description1',
            'dmpl__IsGLPosted__c'=>true,
            'dmpl__IsGLPostingApproved__c'=>true,
            'dmpl__IsReturned__c'=>true,
            'dmpl__PerformGLPosting__c'=>true,
            'dmpl__PerformInventoryPosting__c'=>true,
            'dmpl__PerformReturn__c'=>true,
            'dmpl__Remarks__c'=>'Remarks1',
            'dmpl__Status__c'=>'Draft',
            'dmpl__SupplierInvoiceAmount__c'=>2000,
            'dmpl__SupplierInvoiceNumber__c'=>'1',
            'dmpl__TaxSupplyType__c'=>'Within State'
        };
    }
}