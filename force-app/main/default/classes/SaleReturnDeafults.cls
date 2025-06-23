@isTest
public with sharing class SaleReturnDeafults  implements TestFactory.FieldDefaults
{   
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__IsGLPosted__c'=>true,
            'dmpl__IsGLPostingApproved__c'=>true,
            'dmpl__IsInJobQueue__c'=>true,
            'dmpl__IsReturned__c'=>true,
            'dmpl__PerformGLPosting__c'=>true,
            'dmpl__PerformInventoryPosting__c'=>true,
            'dmpl__PerformReturn__c'=>true,
            'dmpl__Remarks__c'=>'Remark1',
            'dmpl__Status__c'=>'Draft',
            'dmpl__TransactionType__c'=>'Sample'
        };
    }
}