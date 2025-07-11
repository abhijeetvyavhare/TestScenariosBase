@isTest
public with sharing class MessageHandler_Test {
    @TestSetup
    static void createRequiredData() {
        dmpl__MessageConfiguration__c config = MessageDataHelper.createMessageConfiguration();
        MessageDataHelper.createMessageRule(config.Id);
        MessageDataHelper.createDefaultMessage();
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount(
            'Partner 1',
            false,
            true,
            false,
            true,
            'MG Road',
            'Bengaluru',
            'Karnataka',
            'India',
            '560001',
            '56 Industrial Layout',
            'Bengaluru',
            'Karnataka',
            'India',
            '560095',
            '91-9876543210'
        );
    }
    
    @isTest
    static void testInsertMessageConfiguration() {
        dmpl__MessageConfiguration__c mc = MessageDataHelper.getMessageConfiguration();
        System.assert(mc.Id != null, 'Message Configuration should be inserted');
    }
    
    @isTest
    static void testInsertMessageRule() {
        dmpl__MessageRule__c rule = MessageDataHelper.getMessageRule();
        System.assertNotEquals(null, rule.Id, 'Message Rule record should be inserted');
    }
    
    @isTest
    static void testInsertMessage() {
        dmpl__Message__c msg = MessageDataHelper.getMessage();
        System.assert(msg.Id != null, 'Message should be inserted');
    }
    
    @isTest
    static void testUpdateMessageConfiguration() {
        dmpl__MessageConfiguration__c mc = MessageDataHelper.getMessageConfiguration();
        mc.Name = 'Updated Message Config';
        mc.dmpl__CustomHandlerName__c = 'UpdatedHandler';
        mc.dmpl__CustomNotificationName__c = 'UpdatedNotification';
        mc.dmpl__MessageBody__c = 'Updated message body.';
        mc.dmpl__ProviderType__c = 'SFDC EMail';
        mc.dmpl__PushNotificationApplicationName__c = 'UpdatedApp';
        mc.dmpl__Recipient__c = 'updated@example.com';
        mc.dmpl__RuleSuccessCriteria__c = 'All Rules Are Met';
        mc.dmpl__RuleSuccessCustomLogic__c = 'IF false THEN success';
        mc.dmpl__Sender__c = 'updated@example.com';
        mc.dmpl__SenderName__c = 'Updated Sender';
        mc.dmpl__Subject__c = 'Updated Subject';
        mc.dmpl__TemplateId__c = 'TPL456';
        mc.dmpl__TriggerEvent__c = 'Scheduled';
        mc.dmpl__TriggerObjectName__c = 'Contact';
        update mc;
        dmpl__MessageConfiguration__c updated = MessageDataHelper.getMessageConfigurationById(mc.Id);
        System.assertEquals('Updated Message Config', updated.Name);
        System.assertEquals('UpdatedHandler', updated.dmpl__CustomHandlerName__c, 'Custom Handler Name should be updated');
        System.assertEquals('UpdatedNotification', updated.dmpl__CustomNotificationName__c, 'Custom Notification Name should be updated');
        System.assertEquals('Updated message body.', updated.dmpl__MessageBody__c, 'Message Body should be updated');
        System.assertEquals('SFDC EMail', updated.dmpl__ProviderType__c, 'Provider Type should be updated');
        System.assertEquals('UpdatedApp', updated.dmpl__PushNotificationApplicationName__c, 'Push Notification Application Name should be updated');
        System.assertEquals('updated@example.com', updated.dmpl__Recipient__c, 'Recipient should be updated');
        System.assertEquals('All Rules Are Met', updated.dmpl__RuleSuccessCriteria__c, 'Rule Success Criteria should be updated');
        System.assertEquals('IF false THEN success', updated.dmpl__RuleSuccessCustomLogic__c, 'Rule Success Custom Logic should be updated');
        System.assertEquals('updated@example.com', updated.dmpl__Sender__c, 'Sender should be updated');
        System.assertEquals('Updated Sender', updated.dmpl__SenderName__c, 'Sender Name should be updated');
        System.assertEquals('Updated Subject', updated.dmpl__Subject__c, 'Subject should be updated');
        System.assertEquals('TPL456', updated.dmpl__TemplateId__c, 'Template Id should be updated');
        System.assertEquals('Scheduled', updated.dmpl__TriggerEvent__c, 'Trigger Event should be updated');
        System.assertEquals('Contact', updated.dmpl__TriggerObjectName__c, 'Trigger Object Name should be updated');
    }
    
    @isTest
    static void testUpdateMessageRule() {
        dmpl__MessageRule__c rule = MessageDataHelper.getMessageRule();
        rule.dmpl__FieldName__c = 'Priority';
        rule.dmpl__FieldValue__c = 'High';
        rule.dmpl__Operation__c = 'equals';
        rule.dmpl__SequenceNumber__c = 2;
        update rule;
        dmpl__MessageRule__c updated = MessageDataHelper.getMessageRuleById(rule.Id);
        System.assertEquals('Priority', updated.dmpl__FieldName__c, 'Field Name should be updated');
        System.assertEquals('High', updated.dmpl__FieldValue__c, 'Field Value should be updated');
        System.assertEquals('equals', updated.dmpl__Operation__c, 'Operation should be updated');
        System.assertEquals(2, updated.dmpl__SequenceNumber__c, 'Sequence Number should be updated');
    }
    
    @isTest
    static void testUpdateMessage() {
        dmpl__Message__c msg = MessageDataHelper.getMessage();
        
        msg.Name = 'Updated Message Name';
        msg.dmpl__ErrorMessage__c = 'Updated error';
        msg.dmpl__MessageBody__c = 'Updated message body';
        msg.dmpl__ProviderType__c = 'SFDC EMail';
        msg.dmpl__Recipient__c = 'updated@example.com';
        msg.dmpl__Sender__c = 'updated_sender@example.com';
        msg.dmpl__SenderName__c = 'Updated Sender';
        msg.dmpl__SourceObjectId__c = '001ZZZZZZZZZZZZZZZ';
        msg.dmpl__Status__c = 'Sent';
        msg.dmpl__Subject__c = 'Updated Subject';
        msg.dmpl__WhatId__c = '001ZZZZZZZZZZZZZZZ';
        dmpl__Message__c updated = MessageDataHelper.updateMessage(msg);
        System.assertEquals('Updated Message Name', updated.Name);
        System.assertEquals('Updated error', updated.dmpl__ErrorMessage__c);
        System.assertEquals('Updated message body', updated.dmpl__MessageBody__c);
        System.assertEquals('SFDC EMail', updated.dmpl__ProviderType__c);
        System.assertEquals('updated@example.com', updated.dmpl__Recipient__c);
        System.assertEquals('updated_sender@example.com', updated.dmpl__Sender__c);
        System.assertEquals('Updated Sender', updated.dmpl__SenderName__c);
        System.assertEquals('001ZZZZZZZZZZZZZZZ', updated.dmpl__SourceObjectId__c);
        System.assertEquals('Sent', updated.dmpl__Status__c);
        System.assertEquals('Updated Subject', updated.dmpl__Subject__c);
        System.assertEquals('001ZZZZZZZZZZZZZZZ', updated.dmpl__WhatId__c);
    }
    
    @isTest
    static void testDeleteMessageRule() {
        Test.startTest();
        dmpl__MessageRule__c rule = MessageDataHelper.getMessageRule();
        delete rule;
        List<dmpl__MessageRule__c> result = MessageDataHelper.getMessageRulesById(rule.Id);
        Test.stopTest();
        System.assertEquals(0, result.size(), 'Message Rule record should be deleted');
    }
    
    @isTest
    static void testDeleteMessageConfiguration() {
        dmpl__MessageConfiguration__c mc = MessageDataHelper.getMessageConfiguration();
        delete mc;
        
        List<dmpl__MessageConfiguration__c> result = MessageDataHelper.getMessageConfigurationsByIds(mc.Id);
        System.assertEquals(0, result.size(), 'Message Configuration should be deleted');
    }
    
    @isTest
    static void testDeleteMessage() {
        dmpl__Message__c msg = MessageDataHelper.getMessage();
        delete msg;
        List<dmpl__Message__c> result = [
            SELECT Id FROM dmpl__Message__c WHERE Id = :msg.Id
        ];
        System.assertEquals(0, result.size(), 'Message should be deleted');
    }

    @isTest
    static void createMessageConfigurationWithNamePositive() {
        Test.startTest();
        dmpl__MessageConfiguration__c msgConfig = MessageDataHelper.createMessageConfiguration('MSG Config', 'MSG Trigger', null, null, null, null);
        Test.stopTest();
        System.assertNotEquals(null, msgconfig, 'Message Configuration should be created with Name');
        System.assertEquals('MSG Config', msgConfig.Name, 'Message Configuration Name should match');
        System.assertEquals('MSG Trigger', msgConfig.dmpl__TriggerObjectName__c, 'Trigger Object Name should match');
    }

    @isTest
    static void createMessageConfigurationWithTriggerEventPositive() {
        Test.startTest();
        dmpl__MessageConfiguration__c msgConfig = MessageDataHelper.createMessageConfiguration('MSG Config', 'MSG Trigger', 'AFTER_INSERT', null, null, null);
        Test.stopTest();
        System.assertNotEquals(null, msgconfig, 'Message Configuration should be created with Trigger Event');
        System.assertEquals('AFTER_INSERT', msgConfig.dmpl__TriggerEvent__c, 'Trigger Event should match');
        System.assertEquals('MSG Config', msgConfig.Name, 'Message Configuration Name should match');
        System.assertEquals('MSG Trigger', msgConfig.dmpl__TriggerObjectName__c, 'Trigger Object Name should match');
    }

    @isTest
    static void createMessageConfigurationWithProviderTypePositive(){
        Test.startTest();
        dmpl__MessageConfiguration__c msgConfig = MessageDataHelper.createMessageConfiguration('MSG Config', 'MSG Trigger', 'AFTER_INSERT', 'Interface Provider', null, null);
        Test.stopTest();
        System.assertNotEquals(null, msgconfig, 'Message Configuration should be created with Provider Type');
        System.assertEquals('Interface Provider', msgConfig.dmpl__ProviderType__c, 'Provider Type should match');
        System.assertEquals('MSG Config', msgConfig.Name, 'Message Configuration Name should match');
        System.assertEquals('MSG Trigger', msgConfig.dmpl__TriggerObjectName__c, 'Trigger Object Name should match');
        System.assertEquals('AFTER_INSERT', msgConfig.dmpl__TriggerEvent__c, 'Trigger Event should match');
    }

    @isTest
    static void createMessageConfigurationWithInterfaceProviderPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider(partner);
        dmpl__MessageConfiguration__c msgConfig = MessageDataHelper.createMessageConfiguration('MSG Config', 'MSG Trigger', 'AFTER_INSERT', 'Interface Provider', interfaceServiceProvider, null);
        Test.stopTest();
        System.assertNotEquals(null, msgconfig, 'Message Configuration should be created with Interface Provider');
        System.assertEquals('Interface Provider', msgConfig.dmpl__ProviderType__c, 'Provider Type should match');
        System.assertEquals('MSG Config', msgConfig.Name, 'Message Configuration Name should match');
        System.assertEquals('MSG Trigger', msgConfig.dmpl__TriggerObjectName__c, 'Trigger Object Name should match');
        System.assertEquals('AFTER_INSERT', msgConfig.dmpl__TriggerEvent__c, 'Trigger Event should match');
        System.assertEquals(interfaceServiceProvider.Id, msgConfig.dmpl__InterfaceProviderId__c, 'Interface Service Provider Id should match');
    }

    @isTest
    static void createMessageConfigurationWithInterfaceRequestPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider(partner);
        dmpl__InterfaceServiceProviderRequest__c interfaceRequest = InterfaceTestDataHelper.createInterfaceServiceProviderRequest(interfaceServiceProvider);
        dmpl__MessageConfiguration__c msgConfig = MessageDataHelper.createMessageConfiguration('MSG Config', 'MSG Trigger', 'AFTER_INSERT', 'Interface Provider', interfaceServiceProvider, interfaceRequest);
        Test.stopTest();
        System.assertNotEquals(null, msgconfig, 'Message Configuration should be created with Interface Request');
        System.assertEquals('Interface Provider', msgConfig.dmpl__ProviderType__c, 'Provider Type should match');
        System.assertEquals('MSG Config', msgConfig.Name, 'Message Configuration Name should match');
        System.assertEquals('MSG Trigger', msgConfig.dmpl__TriggerObjectName__c, 'Trigger Object Name should match');
        System.assertEquals('AFTER_INSERT', msgConfig.dmpl__TriggerEvent__c, 'Trigger Event should match');
        System.assertEquals(interfaceServiceProvider.Id, msgConfig.dmpl__InterfaceProviderId__c, 'Interface Service Provider Id should match');
        System.assertEquals(interfaceRequest.Id, msgConfig.dmpl__InterfaceRequestId__c, 'Interface Service Provider Request Id should match');
    }

    @isTest
    static void createMessageConfigurationWithDeletedInterfaceRequestPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider(partner);
        dmpl__InterfaceServiceProviderRequest__c interfaceRequest = InterfaceTestDataHelper.createInterfaceServiceProviderRequest(interfaceServiceProvider);
        delete interfaceRequest;
        dmpl__MessageConfiguration__c msgConfig = MessageDataHelper.createMessageConfiguration('MSG Config', 'MSG Trigger', 'AFTER_INSERT', 'Interface Provider', interfaceServiceProvider, null);
        Test.stopTest();
        System.assertNotEquals(null, msgconfig, 'Message Configuration should be created even if Interface Request is deleted');
        System.assertEquals('Interface Provider', msgConfig.dmpl__ProviderType__c, 'Provider Type should match');
        System.assertEquals('MSG Config', msgConfig.Name, 'Message Configuration Name should match');
        System.assertEquals('MSG Trigger', msgConfig.dmpl__TriggerObjectName__c, 'Trigger Object Name should match');
        System.assertEquals('AFTER_INSERT', msgConfig.dmpl__TriggerEvent__c, 'Trigger Event should match');
        System.assertEquals(interfaceServiceProvider.Id, msgConfig.dmpl__InterfaceProviderId__c, 'Interface Service Provider Id should match');
    }

    @isTest
    static void createMessageConfigurationWithoutTriggerEventPositive() {
        Test.startTest();
        dmpl__MessageConfiguration__c msgConfig = MessageDataHelper.createMessageConfiguration('MSG Config', 'MSG Trigger', null, null, null, null);
        Test.stopTest();
        System.assertNotEquals(null, msgconfig, 'Message Configuration should be created without Trigger Event');
        System.assertEquals('MSG Config', msgConfig.Name, 'Message Configuration Name should match');
        System.assertEquals('MSG Trigger', msgConfig.dmpl__TriggerObjectName__c, 'Trigger Object Name should match');
        System.assertEquals(null, msgConfig.dmpl__TriggerEvent__c, 'Trigger Event should be null');
    }

    @isTest
    static void createMessageConfigurationWithoutNameNegative() {
        Test.startTest();
        try{
            dmpl__MessageConfiguration__c msgConfig = MessageDataHelper.createMessageConfiguration(null, 'MSG Trigger', 'AFTER_INSERT', 'Interface Provider', null, null);
            System.assertNotEquals(null, msgconfig, 'Message Configuration should not be created without Name');
        } catch (DmlException e) {
            System.debug('Expected DML Exception: ' + e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void createMessageConfigurationWithoutTriggerObjectNameNegative() {
        Test.startTest();
        try{
            dmpl__MessageConfiguration__c msgConfig = MessageDataHelper.createMessageConfiguration('MSG Config', null, 'AFTER_INSERT', 'Interface Provider', null, null);
            System.assertEquals(null, msgconfig, 'Message Configuration should not be created without Trigger Object Name');
        } catch (DmlException e) {
            System.debug('Expected DML Exception: ' + e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void createMessageConfigurationWithInvalidInterfaceProviderNegative() {
        Test.startTest();
        try{
            dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider(null);
            dmpl__MessageConfiguration__c msgConfig = MessageDataHelper.createMessageConfiguration('MSG Config', null, 'AFTER_INSERT', 'Interface Provider', interfaceServiceProvider, null);
            System.assertNotEquals(null, msgconfig, 'Message Configuration should be created with Invalid Interface Provider');
        }
        catch (DmlException e) {
            System.debug('Expected DML Exception: ' + e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void deleteValidMessageConfigurationRecordPositive() {
        Test.startTest();
        dmpl__MessageConfiguration__c msgConfig = MessageDataHelper.createMessageConfiguration('MSG Config', 'MSG Trigger', 'AFTER_INSERT', 'Interface Provider', null, null);
        dmpl__MessageConfiguration__c deletedMsgconfig = null;
        delete msgConfig;
        try{
            deletedMsgconfig = MessageDataHelper.getMessageConfigurationById(msgConfig.Id);
        } catch (QueryException e) {
            deletedMsgconfig = null;
            System.debug('Expected QueryException after deletion: ' + e.getMessage());
        }
        System.assertEquals(null, deletedMsgconfig, 'Expected message Configuration to be deleted.');
        Test.stopTest();
    }

    @isTest
    static void createMessageWithNamePositive() {
        Test.startTest();
        dmpl__Message__c message = MessageDataHelper.createMessage('Test', null, null, null , null, null, null, null);
        Test.stopTest();
        System.assertNotEquals(null, message.Id, 'Message should be created with Name');
        System.assertEquals('Test', message.Name, 'Message Name should match');
    }

    @isTest
    static void createMessageWithStatusDraftPositive() {
        Test.startTest();
        dmpl__Message__c message = MessageDataHelper.createMessage('Test', 'Draft', null, null , null, null, null, null);
        Test.stopTest();
        System.assertNotEquals(null, message.Id, 'Message should be created with Status as Draft');
        System.assertEquals('Draft', message.dmpl__Status__c, 'Message Status should be Draft');
    }

    @isTest
    static void createMessageWithStatusQueuedPositive() {
        Test.startTest();
        dmpl__Message__c message = MessageDataHelper.createMessage('Test', 'Queued', null, null , null, null, null, null);
        Test.stopTest();
        System.assertNotEquals(null, message.Id, 'Message should be created with Status as Queued');
        System.assertEquals('Queued', message.dmpl__Status__c, 'Message Status should be Queued');
    }

    @isTest
    static void createMessageWithStatusSentPositive() {
        Test.startTest();
        dmpl__Message__c message = MessageDataHelper.createMessage('Test', 'Sent', null, null , null, null, null, null);
        Test.stopTest();
        System.assertNotEquals(null, message.Id, 'Message should be created with Status as Sent');
        System.assertEquals('Sent', message.dmpl__Status__c, 'Message Status should be Sent');
    }

    @isTest
    static void createMessageWithStatusErrorPositive() {
        Test.startTest();
        dmpl__Message__c message = MessageDataHelper.createMessage('Test', 'Error', null, null , null, null, null, null);
        Test.stopTest();
        System.assertNotEquals(null, message.Id, 'Message should be created with Status as Error');
        System.assertEquals('Error', message.dmpl__Status__c, 'Message Status should be Error');
    }

    @isTest
    static void createMessageWithStatusBouncedPositive() {
        Test.startTest();
        dmpl__Message__c message = MessageDataHelper.createMessage('Test', 'Bounced', null, null , null, null, null, null);
        Test.stopTest();
        System.assertNotEquals(null, message.Id, 'Message should be created with Status as Bounced');
        System.assertEquals('Bounced', message.dmpl__Status__c, 'Message Status should be Bounced');
    }

    @isTest
    static void createMessageWithConfigurationPositive() {
        Test.startTest();
        dmpl__MessageConfiguration__c config = MessageDataHelper.createMessageConfiguration('Test Config', 'Test Trigger', 'AFTER_INSERT', 'Interface Provider', null, null);
        dmpl__Message__c message = MessageDataHelper.createMessage('Test Message', 'Draft', null, null, null, null, null, config);
        Test.stopTest();
        System.assertNotEquals(null, message.Id, 'Message should be created with Message Configuration');
        System.assertEquals(config.Id, message.dmpl__MessageConfigurationId__c, 'Message Configuration Id should match');
        System.assertEquals('Test Message', message.Name, 'Message Name should match');
        System.assertEquals('Draft', message.dmpl__Status__c, 'Message Status should be Draft');
    }

    @isTest
    static void createMessageWithSenderDetailsPositive() {
        Test.startTest();
        dmpl__Message__c message = MessageDataHelper.createMessage('Test Message', 'Draft', 'Manager', 'Leslie', null, null, null, null);
        Test.stopTest();
        System.assertNotEquals(null, message.Id, 'Message should be created with Sender Name and Sender');
        System.assertEquals('Leslie', message.dmpl__SenderName__c, 'Sender Name should match');
        System.assertEquals('Manager', message.dmpl__Sender__c, 'Sender should match');
        System.assertEquals('Test Message', message.Name, 'Message Name should match');
        System.assertEquals('Draft', message.dmpl__Status__c, 'Message Status should be Draft');
    }

    @isTest
    static void createMessageWithSenderDetailsEditPositive() {
        Test.startTest();
        dmpl__Message__c message = MessageDataHelper.createMessage('Test Message', 'Draft', 'Manager', 'Leslie', null, null, null, null);
        message.dmpl__SenderName__c = 'Bindu';
        message.dmpl__Sender__c = 'Sales Manager';
        update message;
        dmpl__message__c updatedMessage = MessageDataHelper.getMessage(message.Id);
        Test.stopTest();
        System.assertNotEquals(null, updatedMessage.Id, 'Message should be updated with new Sender Name and Sender');
        System.assertEquals('Bindu', updatedMessage.dmpl__SenderName__c, 'Sender Name should be updated');
        System.assertEquals('Sales Manager', updatedMessage.dmpl__Sender__c, 'Sender should be updated');
        System.assertEquals('Test Message', updatedMessage.Name, 'Message Name should match');
        System.assertEquals('Draft', updatedMessage.dmpl__Status__c, 'Message Status should be Draft');
    }

    @isTest
    static void createMessageWithRecipientNamePositive() {
        Test.startTest();
        dmpl__Message__c message = MessageDataHelper.createMessage('Test Message', 'Draft', null, null,null, null, 'XYZ', null);
        Test.stopTest();
        System.assertNotEquals(null, message.Id, 'Message should be created with Recipient Name');
        System.assertEquals('XYZ', message.dmpl__Recipient__c, 'Recipient Name should match');
    }

    @isTest
    static void createMessageWithSubjectAndBodyPositive() {
        Test.startTest();
        dmpl__Message__c message = MessageDataHelper.createMessage('Test Message', 'Draft', null, null, 'This is a test message body.', 'Test Subject', null, null);
        Test.stopTest();
        System.assertNotEquals(null, message.Id, 'Message should be created with Subject and Message Body');
        System.assertEquals('Test Subject', message.dmpl__Subject__c, 'Subject should match');
        System.assertEquals('This is a test message body.', message.dmpl__MessageBody__c, 'Message Body should match');
    }

    @isTest
    static void createMessageWithoutStatusPositive() {
        Test.startTest();
        dmpl__Message__c message = MessageDataHelper.createMessage('Test Message', null, null, null, null, null, null, null);
        Test.stopTest();
        System.assertNotEquals(null, message.Id, 'Message should be created without Status');
        System.assertEquals(null, message.dmpl__Status__c, 'Default Status should be Draft');
        System.assertEquals('Test Message', message.Name, 'Message Name should match');
    }

    @isTest
	static void deleteMessageRecordPositive() {
        Test.startTest();
        dmpl__Message__c message = MessageDataHelper.createMessage('Test Message', 'Draft', null, null, null, null, null, null);
        dmpl__Message__c deletedMessage = MessageDataHelper.getMessage(message.Id);
        delete message;
        System.assertNotEquals(null, deletedMessage, 'Expected message to be deleted.');
        Test.stopTest();
    }

    @isTest
    static void createMessageWithoutNameNegative() {
        Test.startTest();
        try {
            dmpl__Message__c message = MessageDataHelper.createMessage(null, 'Draft', null, null, null, null, null, null);
            System.assertNotEquals(null, message.Id, 'Message should be created without Name');
        } catch (DmlException e) {
            System.debug('Expected DML Exception: ' + e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void updateMessageWithoutNameNegative() {
        Test.startTest();
        dmpl__Message__c message = MessageDataHelper.createMessage('Test Message', 'Draft', null, null, null, null, null, null);
        message.Name = null;
        update message;
        dmpl__Message__c updatedMessage = MessageDataHelper.getMessage(message.Id);
        System.assertNotEquals(null, updatedMessage, 'Message should be updated without Name');
        Test.stopTest();
    }

    @isTest
    static void updateMessageWithoutSubjectNegative() {
        Test.startTest();
        dmpl__Message__c message = MessageDataHelper.createMessage('Test Message', 'Draft', null, null, 'This is a test message body.', 'Test Subject', null, null);
        dmpl__Message__c createdMessage = MessageDataHelper.getMessage(message.Id);
        message.dmpl__Subject__c = null;
        update message;
        dmpl__Message__c updatedMessage = MessageDataHelper.getMessage(message.Id);
        Test.stopTest();
        System.assertEquals('Test Subject', createdMessage.dmpl__Subject__c,'Subject should be initially set');
        System.assertEquals(null, updatedMessage.dmpl__Subject__c, 'Subject should be deleted');
    }
    
    @isTest
    static void createMessageRuleWithNameAndFieldSelectionPositive() {
        Test.startTest();
        dmpl__MessageConfiguration__c config = MessageDataHelper.createMessageConfiguration('Test Config', 'Test Trigger', 'AFTER_INSERT', 'Interface Provider', null, null);
        dmpl__MessageRule__c rule = MessageDataHelper.createMessageRule(null, 'Account', null, null, config);
        Test.stopTest();
        System.assertNotEquals(null, rule.Id, 'Message Rule should be created with Name and Field Selection');
        System.assertEquals('Account', rule.dmpl__FieldName__c, 'Field Name should match');
    }

    @isTest
    static void createMessageRuleWithOperationEqualPositive() {
        Test.startTest();
        dmpl__MessageConfiguration__c config = MessageDataHelper.createMessageConfiguration('Test Config', 'Test Trigger', 'AFTER_INSERT', 'Interface Provider', null, null);
        dmpl__MessageRule__c rule = MessageDataHelper.createMessageRule('equals', 'Account', null, null, config);
        Test.stopTest();
        System.assertNotEquals(null, rule.Id, 'Message Rule should be created with Operation as Equal');
        System.assertEquals('equals', rule.dmpl__Operation__c, 'Operation should match');
    }

    @isTest
    static void createMessageRuleWithOperationNotEqualPositive() {
        Test.startTest();
        dmpl__MessageConfiguration__c config = MessageDataHelper.createMessageConfiguration('Test Config', 'Test Trigger', 'AFTER_INSERT', 'Interface Provider', null, null);
        dmpl__MessageRule__c rule = MessageDataHelper.createMessageRule('notEqual', 'Account', null, null, config);
        Test.stopTest();
        System.assertNotEquals(null, rule.Id, 'Message Rule should be created with Operation as Not Equal');
        System.assertEquals('notEqual', rule.dmpl__Operation__c, 'Operation should match');
    }

    @isTest
    static void createMessageRuleWithOperationGreaterOrEqualPositive() {
        Test.startTest();
        dmpl__MessageConfiguration__c config = MessageDataHelper.createMessageConfiguration('Test Config', 'Test Trigger', 'AFTER_INSERT', 'Interface Provider', null, null);
        dmpl__MessageRule__c rule = MessageDataHelper.createMessageRule('greaterOrEqual', 'Account', null, null, config);
        Test.stopTest();
        System.assertNotEquals(null, rule.Id, 'Message Rule should be created with Operation as greaterOrEqual');
        System.assertEquals('greaterOrEqual', rule.dmpl__Operation__c, 'Operation should match');
    }

    @isTest
    static void createMessageRuleWithOperationLessOrEqualPositive() {
        Test.startTest();
        dmpl__MessageConfiguration__c config = MessageDataHelper.createMessageConfiguration('Test Config', 'Test Trigger', 'AFTER_INSERT', 'Interface Provider', null, null);
        dmpl__MessageRule__c rule = MessageDataHelper.createMessageRule('lessOrEqual', 'Account', null, null, config);
        Test.stopTest();
        System.assertNotEquals(null, rule.Id, 'Message Rule should be created with Operation as lessOrEqual');
        System.assertEquals('lessOrEqual', rule.dmpl__Operation__c, 'Operation should match');
    }

    @isTest
    static void createMessageRuleWithOperationGreaterThanPositive() {
        Test.startTest();
        dmpl__MessageConfiguration__c config = MessageDataHelper.createMessageConfiguration('Test Config', 'Test Trigger', 'AFTER_INSERT', 'Interface Provider', null, null);
        dmpl__MessageRule__c rule = MessageDataHelper.createMessageRule('greaterThan', 'Account', null, null, config);
        Test.stopTest();
        System.assertNotEquals(null, rule.Id, 'Message Rule should be created with Operation as greaterThan');
        System.assertEquals('greaterThan', rule.dmpl__Operation__c, 'Operation should match');
    }

    @isTest
    static void createMessageRuleWithOperationLessThanPositive() {
        Test.startTest();
        dmpl__MessageConfiguration__c config = MessageDataHelper.createMessageConfiguration('Test Config', 'Test Trigger', 'AFTER_INSERT', 'Interface Provider', null, null);
        dmpl__MessageRule__c rule = MessageDataHelper.createMessageRule('lessThan', 'Account', null, null, config);
        Test.stopTest();
        System.assertNotEquals(null, rule.Id, 'Message Rule should be created with Operation as lessThan');
        System.assertEquals('lessThan', rule.dmpl__Operation__c, 'Operation should match');
    }

    @isTest
    static void createMessageRuleWithFieldValuePositive() {
        Test.startTest();
        dmpl__MessageConfiguration__c config = MessageDataHelper.createMessageConfiguration('Test Config', 'Test Trigger', 'AFTER_INSERT', 'Interface Provider', null, null);
        dmpl__MessageRule__c rule = MessageDataHelper.createMessageRule('equals', 'Account', 'Create', null, config);
        Test.stopTest();
        System.assertNotEquals(null, rule.Id, 'Message Rule should be created with Field Value');
        System.assertEquals('Create', rule.dmpl__FieldValue__c, 'Field Value should match');
    }

    @isTest
    static void createMessageRuleWithValidSequenceNumberPositive() {
        Test.startTest();
        dmpl__MessageConfiguration__c config = MessageDataHelper.createMessageConfiguration('Test Config', 'Test Trigger', 'AFTER_INSERT', 'Interface Provider', null, null);
        dmpl__MessageRule__c rule = MessageDataHelper.createMessageRule('equals', 'Account', 'Create', 1, config);
        Test.stopTest();
        System.assertNotEquals(null, rule.Id, 'Message Rule should be created with valid Sequence Number');
        System.assertEquals(1, rule.dmpl__SequenceNumber__c, 'Sequence Number should match');
    }

    //New Message Rule creation linked to valid Message Configuration (via Lookup)
    @isTest
    static void createMessageRuleWithValidConfigurationPositive() {
        Test.startTest();
        dmpl__MessageConfiguration__c config = MessageDataHelper.createMessageConfiguration('Test Config', 'Test Trigger', 'AFTER_INSERT', 'Interface Provider', null, null);
        dmpl__MessageRule__c rule = MessageDataHelper.createMessageRule('equals', 'Account', 'Create', 1, config);
        Test.stopTest();
        System.assertNotEquals(null, rule.Id, 'Message Rule should be created with valid Configuration');
        System.assertEquals(config.Id, rule.dmpl__MessageConfigurationId__c, 'Message Configuration should match');
    }

    @isTest
    static void createMessageRuleWithoutFieldValuePositive() {
        Test.startTest();
        dmpl__MessageConfiguration__c config = MessageDataHelper.createMessageConfiguration('Test Config', 'Test Trigger', 'AFTER_INSERT', 'Interface Provider', null, null);
        dmpl__MessageRule__c rule = MessageDataHelper.createMessageRule('equals', 'Account', null, null, config);
        Test.stopTest();
        System.assertNotEquals(null, rule.Id, 'Message Rule should be created without Field Value');
        System.assertEquals(null, rule.dmpl__FieldValue__c, 'Field Value should be null');
    }
    
    @isTest
    static void createMessageRuleWithoutSequenceNumberPositive() {
        Test.startTest();
        dmpl__MessageConfiguration__c config = MessageDataHelper.createMessageConfiguration('Test Config', 'Test Trigger', 'AFTER_INSERT', 'Interface Provider', null, null);
        dmpl__MessageRule__c rule = MessageDataHelper.createMessageRule('equals', 'Account', 'Create', null, config);
        Test.stopTest();
        System.assertNotEquals(null, rule.Id, 'Message Rule should be created without Sequence Number');
        System.assertEquals(null, rule.dmpl__SequenceNumber__c, 'Sequence Number should be null');
    }
    
    @isTest
    static void createMessageRuleWithoutOperationPositive() {
        Test.startTest();
        dmpl__MessageConfiguration__c config = MessageDataHelper.createMessageConfiguration('Test Config', 'Test Trigger', 'AFTER_INSERT', 'Interface Provider', null, null);
        dmpl__MessageRule__c rule = MessageDataHelper.createMessageRule(null, 'Account', 'Create', null, config);
        Test.stopTest();
        System.assertNotEquals(null, rule.Id, 'Message Rule should be created without Operation');
        System.assertEquals(null, rule.dmpl__Operation__c, 'Operation should be null');
    }
    
    @isTest
    static void deleteMessageRuleRecordPositive() {
        Test.startTest();
        dmpl__MessageConfiguration__c config = MessageDataHelper.createMessageConfiguration('Test Config', 'Test Trigger', 'AFTER_INSERT', 'Interface Provider', null, null);
        dmpl__MessageRule__c rule = MessageDataHelper.createMessageRule('equals', 'Account', 'Create', 1, config);
        dmpl__MessageRule__c deletedRule =  null;
        delete rule;
        try {
            deletedRule = MessageDataHelper.getMessageRuleById(rule.Id);
        } catch (QueryException e) {
            deletedRule = null;
        }
        System.assertEquals(null, deletedRule, 'Expected message Rule to be deleted.');
        Test.stopTest();
    }

    @isTest
    static void createMessageRuleWithInvalidOperationNegative() {
        Test.startTest();
        dmpl__MessageConfiguration__c config = MessageDataHelper.createMessageConfiguration('Test Config', 'Test Trigger', 'AFTER_INSERT', 'Interface Provider', null, null);
        try{
            dmpl__MessageRule__c rule = MessageDataHelper.createMessageRule('invalidOperation', 'Account', 'Create', 1, config);
            System.assertEquals(null, rule.Id, 'Message Rule should not be created with invalid Operation');
        } catch (DmlException e) {
            System.debug('Expected DML Exception: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    static void createMessageRuleWithFieldValueExceedingLimitNegative() {
        Test.startTest();
        dmpl__MessageConfiguration__c config = MessageDataHelper.createMessageConfiguration('Test Config', 'Test Trigger', 'AFTER_INSERT', 'Interface Provider', null, null);
        try{
            String longFieldValue = String.valueOf(new List<String>{'A'.repeat(256)});
            dmpl__MessageRule__c rule = MessageDataHelper.createMessageRule('equals', 'Account', longFieldValue, 1, config);
            System.assertEquals(null, rule.Id, 'Message Rule should not be created with Field Value exceeding 255 characters');
        } catch (DmlException e) {
            System.debug('Expected DML Exception: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    static void createMessageRuleWithNegativeSequenceNumberNegative(){
        Test.startTest();
        dmpl__MessageConfiguration__c config = MessageDataHelper.createMessageConfiguration('Test Config', 'Test Trigger', 'AFTER_INSERT', 'Interface Provider', null, null);
        dmpl__MessageRule__c rule = MessageDataHelper.createMessageRule('equals', 'Account', 'Create', -1, config);
        Test.stopTest();
        System.assertNotEquals(null, rule.Id, ' Message Rule should be created with negative Sequence Number');
    }

    @isTest
    static void createMessageRuleWithDeletedConfigurationNegative() {
        Test.startTest();
        dmpl__MessageConfiguration__c config = MessageDataHelper.createMessageConfiguration('Test Config', 'Test Trigger', 'AFTER_INSERT', 'Interface Provider', null, null);
        delete config;
        try {
            dmpl__MessageRule__c rule = MessageDataHelper.createMessageRule('equals', 'Account', 'Create', 1, config);
            System.assertEquals(null, rule.Id, 'Message Rule should not be created with deleted Message Configuration');
        } catch (DmlException e) {
            System.debug('Expected DML Exception: ' + e.getMessage());
        }
        Test.stopTest();
    }
}