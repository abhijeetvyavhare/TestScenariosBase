@isTest
public class GoodReceiptLineDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{
            'dmpl__InspectionQuantity__c'=>1,
            'dmpl__InvoiceQuantity__c'=>1,
            'dmpl__IsApproved__c'=>true,
            'dmpl__IsClaimed__c'=>true,
            'dmpl__IsILPosted__c'=>false,
            'dmpl__IsILPostingApproved__c'=>false,
            'dmpl__IsPosted__c'=>true,
            'dmpl__MRP__c'=>999,
            'dmpl__OrderedQuantity__c'=>1
        };
    }
}