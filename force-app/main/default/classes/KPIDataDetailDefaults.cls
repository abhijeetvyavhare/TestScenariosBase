@isTest
public class KPIDataDetailDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'Name' => 'Test-KPI-Data-Detail',
            'dmpl__BillNo__c' => 'BILL-001',
            'dmpl__KPIValue__c' => 100,
            'dmpl__KPIValue2__c' => 200,
            'dmpl__RewardValue__c' => 50,
            'dmpl__SaleDoc__c' => 'SALE-DOC-001',
            'dmpl__SourceRecordId__c' => 'SRC-001'
        };
    }
}