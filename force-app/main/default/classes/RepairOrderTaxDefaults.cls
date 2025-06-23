@isTest
public class RepairOrderTaxDefaults implements TestFactory.FieldDefaults {
    
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__TaxOnAmount__c' => '100',
            'dmpl__TaxAmount__c' => '100',
            'dmpl__TaxRate__c' => '15'
        };
    }
}