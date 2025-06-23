@isTest
public class PerformanceKPIDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__NumberOfBills__c' => 5,
            'dmpl__NumberOfInvoices__c' => 10,
            'dmpl__TotalAmount__c' => 1000,
            'dmpl__TotalQuantity__c' => 20,
            'dmpl__PostingType__c' => 'KPI',
            'OwnerId' => UserInfo.getUserId()
        };
    }
}