@isTest
public with sharing class InventoryAdjustmentLineDefaults  implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__AdjustmentType__c' => 'Damaged',
            'dmpl__IsILPosted__c' => true,
            'dmpl__IsILPostingApproved__c' => true,
            'dmpl__PriceAsOnDate__c' => System.today(),       
            'dmpl__Quantity__c' => 1,
            'dmpl__Remarks__c' => '',           
            'dmpl__TotalCost__c' => 100,
            'dmpl__UnitCost2__c' => 100,
            'dmpl__UnitCost__c' => 100
        };
    }
}