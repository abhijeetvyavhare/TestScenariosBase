public with sharing class InsuranceOrderLineDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__ConfirmedBy__c' => null,
            'dmpl__DocumentDate__c' => Date.today(),
            'dmpl__ExpiryDate__c' => Date.today().addYears(1),
            'dmpl__ExternalId__c' => null,
            'dmpl__InsuranceAmount__c' => 10000.00,
            'dmpl__InsuranceDate__c' => Date.today(),
            'dmpl__InsurerId__c' => null,
            'dmpl__PolicyNumber__c' => '123456789123456',
            'dmpl__Remarks__c' => 'Default insurance order line',
            'dmpl__SaleOrderId__c' => null,
            'dmpl__SaleOrderLineId__c' => null,
            'dmpl__Status__c' => 'Requested'
        };
    }
}