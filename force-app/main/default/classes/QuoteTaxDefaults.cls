@isTest
public class QuoteTaxDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__QuoteTax__c'=>'QuoteTax1',
             'dmpl__TaxAmount__c'=>'99',
             'dmpl__TaxOnAmount__c'=>'1999',
             'dmpl__TaxRate__c'=>'10'
        };
    }
}