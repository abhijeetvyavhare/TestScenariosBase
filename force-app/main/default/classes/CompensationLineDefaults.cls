public class CompensationLineDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__IncentiveAmount__c' => 500,
            'dmpl__Status__c' => 'Draft'
        };
    }
}