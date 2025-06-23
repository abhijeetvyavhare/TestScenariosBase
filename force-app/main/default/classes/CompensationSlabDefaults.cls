public class CompensationSlabDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__FromPercentage__c' => 10,
            'dmpl__ToPercentage__c' => 20,
            'dmpl__CompensationType__c' => 'Fixed Amount',
            'dmpl__IncentiveFixedAmount__c' => 1000,
            'dmpl__SequenceNumber__c' => 1
        };
    }
}