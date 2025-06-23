@isTest
public with sharing class PurchaseOrderDefaults  implements TestFactory.FieldDefaults{
        public Map<String, Object> getFieldDefaults(){
            return new Map<String, Object>{ 
            'dmpl__TCSEligibleAmount__c'=> Decimal.valueOf('1000')
               
        };
    }
}