@isTest
public class GoodsReceiptDefaults implements TestFactory.FieldDefaults {  
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__IsAllocated__c'=>true,
            'dmpl__IsBillGenerated__c'=>false,
            'dmpl__IsClaimed__c'=>true,
            'dmpl__TransporterName__c'=>'Transporter'
        };
    }
}