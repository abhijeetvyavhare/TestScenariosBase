@isTest
public with sharing class AutoPurchaseOrderDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__ExternalId__c' => null, 
            'dmpl__ApplyInventoryAttributeSettings__c'	=> null,
            'dmpl__AutoOrderType__c' => 'None', 
            'dmpl__BudgetAmount__c' => '2000',
            'dmpl__IsTemplateCreated__c' => true,
            'dmpl__DocumentDate__c' =>System.today(),
            'dmpl__ExcludeACategoryItems__c' => true,
            'dmpl__ExcludeBCategoryItems__c' => true,
            'dmpl__ExcludeCCategoryItems__c' => true,
            'dmpl__ExcludeFastMovingItems__c' => true,
            'dmpl__ExcludeNonMovingItems__c' => true,
            'dmpl__ExcludeSlowMovingItems__c' => true,
            'dmpl__ExternalId__c' => null,
            'dmpl__IncludeHighProbabilityQuote__c' => true,	
            'dmpl__IncludeInTransitShipments__c' => true,	
            'dmpl__IncludeOpenSaleOrders__c' => true,	
            'dmpl__IncludePendingPurchaseOrders__c'	=> true,
            'dmpl__IncludePurchaseRequisition__c' => true,	
            'dmpl__IsOrderGenerated__c' => true,	
            'dmpl__LastAutoOrderDate__c' => null,
            'dmpl__PerformOpenOrderCalculation__c' => true,
            'dmpl__PerformOrderGeneration__c' => true,	
            'dmpl__PriceAsOnDate__c' => null ,
            'dmpl__Remarks__c' => 'None'	
        };
    }
}