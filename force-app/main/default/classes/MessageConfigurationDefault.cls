public class MessageConfigurationDefault implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'Name' => 'Default Message Config',
            'dmpl__CustomHandlerName__c' => 'DefaultHandler',
            'dmpl__CustomNotificationName__c' => 'DefaultNotification',
            'dmpl__MessageBody__c' => 'Default message body.',
            'dmpl__ProviderType__c' => 'SFDC Email', 
            'dmpl__PushNotificationApplicationName__c' => 'DefaultApp',
            'dmpl__Recipient__c' => 'default@example.com',
            'dmpl__RuleSuccessCriteria__c' => 'All Rules Are Met',
            'dmpl__RuleSuccessCustomLogic__c' => 'IF true THEN success',
            'dmpl__Sender__c' => 'default@example.com',
            'dmpl__SenderName__c' => 'Default Sender',
            'dmpl__Subject__c' => 'Default Subject',
            'dmpl__TemplateId__c' => 'TPL123',
            'dmpl__TriggerEvent__c' => 'Scheduled',
            'dmpl__TriggerObjectName__c' => 'Account'
        };
    }

}