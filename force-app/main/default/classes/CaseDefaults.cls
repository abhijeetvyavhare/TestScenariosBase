@isTest
public with sharing class CaseDefaults implements TestFactory.FieldDefaults{

    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
                'Name'=>'Case1',
                'dmpl__CaseReason__c'=>'Installation',
                'dmpl__CaseSource__c'=>'Phone',
                'dmpl__ClosedWhenCreated__c'=>false,
                'dmpl__ContactEmail__c'=>'ContactEmail@Test.com',
                'dmpl__ContactName__c'=>'ContactName1'       
        };
    }
}