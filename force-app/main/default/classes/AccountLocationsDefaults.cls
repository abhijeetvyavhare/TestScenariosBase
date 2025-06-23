public with sharing class AccountLocationsDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'Name' => 'Default Location Name',
            'dmpl__LocationType__c' => 'Sample',
            'dmpl__isActive__c' => true
        };
    }
}