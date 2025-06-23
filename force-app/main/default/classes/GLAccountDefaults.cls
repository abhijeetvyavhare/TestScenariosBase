@isTest
public class GLAccountDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__AccountNumber__c' => '123',
            'dmpl__AccountType__c' => 'Fixed Assets',
            'dmpl__Currency__c' => 'INR',
            'dmpl__Description__c' => 'Description Value',
            'dmpl__ExternalId__c' => '890',
            'Name' => 'Testing GL Account',
            'dmpl__IsActive__c' => false,
            'dmpl__IsSystem__c' => false,
            'dmpl__TaxType__c' => 'SGST'
        };
    }    
}