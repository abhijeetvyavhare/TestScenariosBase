@isTest
public with sharing class InventoryLedgerDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        
        return new Map<String, Object>{
       
            //'Name'=> 'Test Ledger',
            'dmpl__InventoryLedgerType__c'   => 'Adjustment'
        };
    }
}