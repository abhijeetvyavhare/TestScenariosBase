public class FieldSalesLineDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__Quantity__c' => 1,
            'dmpl__DamagedQuantity__c' => 0,
            'dmpl__SoldQuantity__c' => 0,
            'dmpl__ReceivedQuantity__c' => 0
        };
    }
}