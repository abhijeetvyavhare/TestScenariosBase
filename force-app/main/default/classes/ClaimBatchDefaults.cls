@isTest
public class ClaimBatchDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__ApproveAll__c' => true,
            'dmpl__BranchId__c' => null,
            'dmpl__DocumentDate__c' => Date.today(),
            'dmpl__IsClaimLinePopulated__c' => false,
            'dmpl__IsReconciled__c' => false,
            'dmpl__PartnerAccountId__c' => null,
            'dmpl__PerformPopulateClaimLines__c' => false,
            'dmpl__PerformReconciliation__c' => false,
            'dmpl__RejectAll__c' => false,
            'dmpl__Remarks__c' => 'Test Batch',
            'dmpl__ServiceContractId__c' => null,
            'dmpl__Status__c' => 'Draft',
            'dmpl__SupplierNameId__c' => null
        };
    }
}