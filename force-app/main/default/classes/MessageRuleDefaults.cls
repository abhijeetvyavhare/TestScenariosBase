public class MessageRuleDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__FieldName__c' => 'Status',
            'dmpl__FieldValue__c' => 'Approved',
            'dmpl__Operation__c' => 'Equals',
            'dmpl__SequenceNumber__c' => 1
        }; 
     }
}