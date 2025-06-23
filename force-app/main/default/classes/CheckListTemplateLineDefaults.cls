@isTest
public with sharing class CheckListTemplateLineDefaults implements TestFactory.FieldDefaults{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
                'Name'=>'CheckListTemplateLine1',
                'dmpl__DataType__c'=>'Text',
                'dmpl__DefaultValue__c'=>'DateValue1',
                'dmpl__GroupBy__c'=>'Sample1'
        };
    }
}