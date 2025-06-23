@isTest
public class PurchaseRequistionDefaults implements TestFactory.FieldDefaults {
     public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{
            'dmpl__PerformReleaseOrder__c' => false,
            'dmpl__IsOrderReleased__c' => true,
            'dmpl__DocumentDate__c'=> null,
            'dmpl__Remarks__c'=>'sample'
        };
    }
}