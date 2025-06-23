@isTest
public with sharing class ShipmentDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{
            'dmpl__DeliveryOrderNumber__c' => '1',
            'dmpl__IsReceiptReleased__c' => true,
            'dmpl__TransporterName__c' => 'Transporter1'
        };
    }
}