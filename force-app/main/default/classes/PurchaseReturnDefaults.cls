@isTest
public with sharing class PurchaseReturnDefaults  implements TestFactory.FieldDefaults
{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__Status__c' => '1',
            'dmpl__PerformReturn__c' => false,
            'dmpl__IsReturned__c' => true,
            'dmpl__PerformInventoryPosting__c' => false,
            'dmpl__DocumentDate__c' => date.today(),
            'dmpl__Description__c'=>'Description1',
            'dmpl__SupplierInvoiceAmount__c'=>1000,
             'dmpl__IsGLPosted__c'=>true,
            'dmpl__IsGLPostingApproved__c'=>true
          
                
        };
    }
}