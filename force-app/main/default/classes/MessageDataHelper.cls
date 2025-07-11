public with sharing class MessageDataHelper {
    public static dmpl__MessageConfiguration__c createMessageConfiguration() {
        return (dmpl__MessageConfiguration__c) TestFactory.createSObject(
            new dmpl__MessageConfiguration__c(),
            'MessageConfigurationDefault',
            true
        );
    }

    public static dmpl__MessageConfiguration__c createMessageConfiguration(
        String name,
        String triggerObjectName,
        String triggerEvent,
        String providerType,
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider,
        dmpl__InterfaceServiceProviderRequest__c interfaceServiceProviderRequest
    ) {
        return (dmpl__MessageConfiguration__c) TestFactory.createSObject(
            new dmpl__MessageConfiguration__c(
                Name = name,
                dmpl__TriggerObjectName__c = triggerObjectName,
                dmpl__TriggerEvent__c = triggerEvent,
                dmpl__ProviderType__c = providerType,
                dmpl__InterfaceProviderId__c = interfaceServiceProvider?.Id,
                dmpl__InterfaceRequestId__c = interfaceServiceProviderRequest?.Id
            ),
            //'MessageConfigurationDefault',
            true
        );
    }

    public static dmpl__MessageConfiguration__c getMessageConfiguration() {
        return [
            SELECT Id, Name, dmpl__CustomHandlerName__c, dmpl__CustomNotificationName__c, dmpl__MessageBody__c,
                   dmpl__ProviderType__c, dmpl__PushNotificationApplicationName__c, dmpl__Recipient__c,
                   dmpl__RuleSuccessCriteria__c, dmpl__RuleSuccessCustomLogic__c, dmpl__Sender__c,
                   dmpl__SenderName__c, dmpl__Subject__c, dmpl__TemplateId__c, dmpl__TriggerEvent__c,
                   dmpl__TriggerObjectName__c
            FROM dmpl__MessageConfiguration__c
            LIMIT 1
        ];
    }

    public static dmpl__MessageConfiguration__c getMessageConfigurationById(Id mcId) {
        return [
            SELECT Id, Name, dmpl__CustomHandlerName__c, dmpl__CustomNotificationName__c, dmpl__MessageBody__c,
                   dmpl__ProviderType__c, dmpl__PushNotificationApplicationName__c, dmpl__Recipient__c,
                   dmpl__RuleSuccessCriteria__c, dmpl__RuleSuccessCustomLogic__c, dmpl__Sender__c,
                   dmpl__SenderName__c, dmpl__Subject__c, dmpl__TemplateId__c, dmpl__TriggerEvent__c,
                   dmpl__TriggerObjectName__c, dmpl__InterfaceProviderId__c, dmpl__InterfaceRequestId__c
            FROM dmpl__MessageConfiguration__c
            WHERE Id = :mcId
            LIMIT 1
        ];
    }

     public static List<dmpl__MessageConfiguration__c> getMessageConfigurationsByIds(Id mcId) {
         return [
             SELECT Id FROM dmpl__MessageConfiguration__c WHERE Id =:mcId
         ];
     }

    public static dmpl__MessageRule__c createMessageRule() {
        dmpl__MessageConfiguration__c config = createMessageConfiguration();
        return createMessageRule(config.Id);
    }

    public static dmpl__MessageRule__c createMessageRule(Id configId) {
        return (dmpl__MessageRule__c) TestFactory.createSObject(
            new dmpl__MessageRule__c(
                dmpl__MessageConfigurationId__c = configId
            ),
            'MessageRuleDefaults',
            true
        );
    }
    public static dmpl__MessageRule__c createMessageRule(
        String operation,
        String fieldName,
        String fieldValue,
        Double sequenceNumber,
        dmpl__MessageConfiguration__c messageConfiguration
    ) {
        return (dmpl__MessageRule__c) TestFactory.createSObject(
            new dmpl__MessageRule__c(
                dmpl__Operation__c = operation,
                dmpl__FieldName__c = fieldName,
                dmpl__FieldValue__c = fieldValue,
                dmpl__SequenceNumber__c = sequenceNumber,
                dmpl__MessageConfigurationId__c = messageConfiguration?.Id
            ),
          //  'MessageRuleDefaults',
            true
        );
    }

    public static dmpl__MessageRule__c getMessageRule() {
        return [
            SELECT Id, dmpl__FieldName__c, dmpl__FieldValue__c, dmpl__Operation__c, dmpl__SequenceNumber__c,
                   dmpl__MessageConfigurationId__c
            FROM dmpl__MessageRule__c
            LIMIT 1
        ];
    }

    public static dmpl__MessageRule__c getMessageRuleById(Id ruleId) {
        return [
            SELECT Id, dmpl__FieldName__c, dmpl__FieldValue__c, dmpl__Operation__c, dmpl__SequenceNumber__c
            FROM dmpl__MessageRule__c
            WHERE Id = :ruleId
            LIMIT 1
        ];
    }

     public static List<dmpl__MessageRule__c> getMessageRulesById(Id ruleId) {
         return [
             SELECT Id FROM dmpl__MessageRule__c WHERE Id = :ruleId
         ];
     }

    public static dmpl__Message__c createDefaultMessage() {
        return (dmpl__Message__c) TestFactory.createSObject(
            new dmpl__Message__c(),
            'MessageDefaults',
            true
        );
    }

    public static dmpl__Message__c createMessage(
        String name,
        String status,
        String sender,
        String senderName,
        String messageBody,
        String subject,
        String recipient,
        dmpl__MessageConfiguration__c messageConfiguration
    ) {
        return (dmpl__Message__c) TestFactory.createSObject(
            new dmpl__Message__c(
                Name = name,
                dmpl__Status__c = status,
                dmpl__Sender__c = sender,
                dmpl__SenderName__c = senderName,
                dmpl__MessageBody__c = messageBody,
                dmpl__Subject__c = subject,
                dmpl__Recipient__c = recipient,
                dmpl__MessageConfigurationId__c = messageConfiguration?.Id
            ),
           // 'MessageDefaults',
            true
        );
    }

    public static dmpl__Message__c getMessage() {
        return [
            SELECT 
                Id, Name, dmpl__ErrorMessage__c, dmpl__MessageBody__c, dmpl__ProviderType__c, 
                dmpl__Recipient__c, dmpl__Sender__c, dmpl__SenderName__c, dmpl__SourceObjectId__c,
                dmpl__Status__c, dmpl__Subject__c, dmpl__WhatId__c
            FROM dmpl__Message__c
            LIMIT 1
        ];
    }
    public static dmpl__Message__c getMessage(Id messageId) {
        return [
            SELECT 
                Id, Name, dmpl__ErrorMessage__c, dmpl__MessageBody__c, dmpl__ProviderType__c, 
                dmpl__Recipient__c, dmpl__Sender__c, dmpl__SenderName__c, dmpl__SourceObjectId__c,
                dmpl__Status__c, dmpl__Subject__c, dmpl__WhatId__c, dmpl__MessageConfigurationId__c
            FROM dmpl__Message__c where Id =: messageId
            LIMIT 1
        ];
    }

    public static dmpl__Message__c updateMessage(dmpl__Message__c msg) {
        update msg;
        return [
            SELECT 
                Name, dmpl__ErrorMessage__c, dmpl__MessageBody__c, dmpl__ProviderType__c, 
                dmpl__Recipient__c, dmpl__Sender__c, dmpl__SenderName__c, dmpl__SourceObjectId__c,
                dmpl__Status__c, dmpl__Subject__c, dmpl__WhatId__c
            FROM dmpl__Message__c
            WHERE Id = :msg.Id
            LIMIT 1
        ];
    }
}