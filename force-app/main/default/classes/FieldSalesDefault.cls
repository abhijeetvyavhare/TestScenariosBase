public class FieldSalesDefault implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__DocumentDate__c' => System.today(),
            'dmpl__IsLoadReleased__c' => false,
            'dmpl__IsPlanReleased__c' => false, 
            'dmpl__IsUnloadReleased__c' => false,
            'dmpl__PerformLoad__c' => false,
            'dmpl__PerformReleaseLoad__c' => false,
            'dmpl__PerformReleaseUnload__c' => false,
            'dmpl__PerformReleaseVisitPlan__c' => false,
            'dmpl__PerformUnload__c' => false,
            'dmpl__Status__c' => 'Draft'
        };
    }
}