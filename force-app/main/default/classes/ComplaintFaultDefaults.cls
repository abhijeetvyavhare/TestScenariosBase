public class ComplaintFaultDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__ExternalId__c' => 'CF-EXT-' + String.valueOf(Crypto.getRandomInteger()),
            'OwnerId' => UserInfo.getUserId()
        };
    }
}