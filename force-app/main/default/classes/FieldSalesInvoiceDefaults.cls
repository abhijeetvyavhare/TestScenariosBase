public class FieldSalesInvoiceDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__CollectedAmount__c' => 100.00,
            'dmpl__InvoiceAmount__c' => 100.00
        };
    }
}