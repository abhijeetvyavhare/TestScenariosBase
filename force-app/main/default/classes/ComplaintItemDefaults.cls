public class ComplaintItemDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__ExternalId__c' => 'CI-EXT-' + String.valueOf(Crypto.getRandomInteger()),
            'OwnerId' => UserInfo.getUserId(),
            'dmpl__IsMandatory__c' => false,
            'dmpl__Quantity__c' => 1
        };
    }
}