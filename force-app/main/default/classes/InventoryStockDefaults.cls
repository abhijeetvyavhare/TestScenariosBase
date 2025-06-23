@isTest
public class InventoryStockDefaults implements TestFactory.FieldDefaults{

    public Map<String, Object> getFieldDefaults(){
        return new Map<String,Object>{
            'dmpl__QuantityTransferIn__c' => 0,
            'dmpl__QuantityDamaged__c' => 0,
            'dmpl__QuantityExpired__c' => 0
        };
    }
}