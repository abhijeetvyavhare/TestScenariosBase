@isTest
public class FinancerDefaults implements TestFactory.FieldDefaults{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__AccountId__c'=>null,
            'dmpl__Address__c'=>'Salesforce Tower, 415 Mission Street, 3rd Floor',
            'dmpl__Branch__c'=>null,
            'dmpl__Description__c'=>'none',
            'dmpl__ExternalId__c'=>null,
            'Name'=>'Financer1'
        };
    }
}