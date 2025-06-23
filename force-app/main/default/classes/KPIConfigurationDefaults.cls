public class KPIConfigurationDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'Name' => 'Test KPI Config',
            'dmpl__MemberType__c' => 'Customer', 
            'dmpl__DateFieldName__c' => '2024-05-25'
        };
    }
}