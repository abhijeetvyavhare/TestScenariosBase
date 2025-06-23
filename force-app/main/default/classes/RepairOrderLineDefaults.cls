@isTest
public class RepairOrderLineDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__Quantity__c' => 1000.00,
            'dmpl__UnitPrice__c' => 10.00,
            'dmpl__PackageClassification__c' => 'Optional Item',
            'dmpl__ActionTaken__c' => 'Replace',
            'dmpl__StandardDurationHours__c' => 10.00,
            'dmpl__ActualDurationHours__c' => 10.00,
            'dmpl__CancelledQuantity__c' => 10.00,
            'dmpl__ClaimedQuantity__c' => 30.00,
            'dmpl__FulfilmentOrderQuantity__c' => 5.00,
            'dmpl__PostingType__c' => 'Generate Claims',
            'dmpl__ApplyPostTaxDiscount__c' => false,
            'dmpl__IncludedInPackage__c' => false
        };
    }
}