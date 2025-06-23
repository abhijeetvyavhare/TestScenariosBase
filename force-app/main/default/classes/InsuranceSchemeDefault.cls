@isTest
public with sharing class InsuranceSchemeDefault implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'Name' => 'Insurance Scheme Insert Test'
        };
    }
}