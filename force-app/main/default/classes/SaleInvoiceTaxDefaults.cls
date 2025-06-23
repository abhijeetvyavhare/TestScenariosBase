@isTest
    public with sharing class SaleInvoiceTaxDefaults implements TestFactory.FieldDefaults {
        public Map<String, Object> getFieldDefaults() {
            return new Map<String, Object>{
                'Name' => 'Test Sale Invoice Tax',
                'dmpl__TaxAmount__c' => 100,
                'dmpl__IsGLPosted__c' => false,
                'dmpl__IsGLPostingApproved__c' => false,
                'dmpl__Status__c' => 'Draft',
                'dmpl__TaxPercentage__c' => 10,
                'dmpl__TaxableAmount__c' => 1000,
                'dmpl__IsActive__c' => true,
                'dmpl__Description__c' => 'Test Tax Description',
                'dmpl__GLPostingDate__c' => System.today(),
                'dmpl__GLPostingReference__c' => 'TEST-REF-001',
                'dmpl__GLPostingStatus__c' => 'Pending',
                'dmpl__TaxType__c' => 'VAT',
                'dmpl__TaxCode__c' => 'VAT10',
                'dmpl__IsInJobQueue__c' => false,
                'dmpl__IsKPICalculated__c' => false,
                'dmpl__PerformGLPosting__c' => false,
                'dmpl__PerformKPICalculation__c' => false,
                'dmpl__Remark__c' => 'Test Remark',
                'dmpl__TaxSupplyType__c' => 'Within State'
            };
        }
    }