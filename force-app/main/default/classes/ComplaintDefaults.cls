public class ComplaintDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__ExternalId__c' => 'C-EXT-37592',
            'dmpl__Code__c' => '37592',
            'OwnerId' => UserInfo.getUserId()
        };
    }
}