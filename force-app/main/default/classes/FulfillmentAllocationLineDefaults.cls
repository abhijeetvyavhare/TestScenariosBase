@isTest
public with sharing class FulfillmentAllocationLineDefaults implements TestFactory.FieldDefaults {
    
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__DeliveredInvoicedQuantity__c' => '1',
            'dmpl__DeliveryQuantity__c' => '1',
            'dmpl__DeliveryReturnQuantity__c' => '1',
            'dmpl__DocumentDate__c' => null,
            'dmpl__EligibleReturnQuantity__c' => '1',
            'dmpl__InvoiceQuantity__c' => '1',
            'dmpl__IsClosed__c' => true,
            'dmpl__IsILPosted__c' => true,
            'dmpl__IsILPostingApproved__c' => true,
            'dmpl__PendingDeliveryQuantity__c' => '1',
            'dmpl__PendingInvoiceQuantity__c' => '1',
            'dmpl__PendingPickingQuantity__c' => '1',
            'dmpl__PickedDeliveredQuantity__c' => '1',
            'dmpl__PickedInvoiceQuantity__c' => '1',
            //'dmpl__PickedQuantity__c' => '1',
            'dmpl__PickingCancelQuantity__c' => '1',
            'dmpl__PickingRequestedQuantity__c' => '1',
            'dmpl__PickingReturnQuantity__c' => '1',
            'dmpl__Quantity__c' => '1',
            'dmpl__ReturnedQuantity__c' => '1',
            'dmpl__UnitCost__c' => '100'
        };
    }
}