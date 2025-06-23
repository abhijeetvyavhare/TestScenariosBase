@isTest
public with sharing class CheckListLinesDefaults implements TestFactory.FieldDefaults{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
                'Name'=>'CheckListLines1',
                'dmpl__BooleanValue__c'=>false,
                'dmpl__CurrencyValue__c'=>1000,
                'dmpl__DataType__c'=>'Numeric',
                'dmpl__DateTimeValue__c'=>null,
                'dmpl__DateValue__c'=>null,
                'dmpl__DecimalValue__c'=>10.00,
                'dmpl__Email__c'=>'asd@test.com',
                'dmpl__NumericValue__c'=>1,
                'dmpl__Phone__c'=>'9876543210',
                'dmpl__RAGValue__c'=>'Red',
                'dmpl__Remarks__c'=>'Remark1',
                'dmpl__TextValue__c'=>'textValue1',
                'dmpl__TimeValue__c'=>null,
                'dmpl__URL__c'=>'TestURL.com'
        };
    }
}