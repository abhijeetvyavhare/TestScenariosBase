@isTest
public class ClaimBatchLineDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{
            'dmpl__ClaimBatchId__c' => null,
            'dmpl__ClaimId__c' => null
        };
    }
}