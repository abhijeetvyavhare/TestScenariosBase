@isTest
public class KPIDataDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'Name' => 'Test-KPI-Data',
            'dmpl__KPIValue__c' => 100,
            'dmpl__RewardValue__c' => 50
        };
    }
}