@IsTest
public class MessageHandler_Test {
    
    @testSetup
    public static void Setup(){
        Test.startTest();
        CreateAccount();
        CreateMessage();
        CreateInterfaceQueue();
        CreateMessageConfiguration();
        CreateMessageRule();
        Test.stopTest();
    }
    
    @isTest
    public static void Test1(){
        dmpl__MessageConfiguration__c messageConfig = [SELECT Id,dmpl__ProviderType__c FROM dmpl__MessageConfiguration__c LIMIT 1];
        dmpl__Message__c message = new dmpl__Message__c(
            dmpl__ErrorMessage__c = 'Test Error 1',
            dmpl__MessageConfigurationId__c = messageConfig.Id
        );
        insert message;
        MessageHandler MessageHandlerl=new MessageHandler();
        MessageHandlerl.beforeInsert();
        MessageHandlerl.beforeUpdate();
        MessageHandlerl.afterInsert();
        message.dmpl__ErrorMessage__c = 'Error 2';
        update message;
        
        messageConfig.dmpl__ProviderType__c='SFDC EMail';
        update messageConfig;
        new MessageHandler().sendMessages(new List<dmpl__Message__c>{message});
/*
        messageConfig.dmpl__ProviderType__c='Interface Provider';
        update messageConfig;
        new MessageHandler().sendMessages(new List<dmpl__Message__c>{message});
*/
        messageConfig.dmpl__ProviderType__c='SFDC Notification';
        update messageConfig;
        new MessageHandler().sendMessages(new List<dmpl__Message__c>{message});

        messageConfig.dmpl__ProviderType__c='Push Notification';
        update messageConfig;
        new MessageHandler().sendMessages(new List<dmpl__Message__c>{message});

         messageConfig.dmpl__ProviderType__c='Custom Handler';
        update messageConfig;
        new MessageHandler().sendMessages(new List<dmpl__Message__c>{message});


    }
    
    @isTest
    public static void Test2(){
        dmpl__Message__c message = [SELECT Id, dmpl__ErrorMessage__c, dmpl__Recipient__c, dmpl__WhatId__c, dmpl__SourceObjectId__c, dmpl__Sender__c, dmpl__SenderName__c, dmpl__Subject__c, dmpl__MessageBody__c, dmpl__MessageConfigurationId__c 
                                    FROM dmpl__Message__c WHERE dmpl__MessageConfigurationId__c != null LIMIT 1];
        new MessageHandler().sendMessages(new List<dmpl__Message__c>{message});
        
    }
    
    @isTest
    public static void messageEmailHelperTest(){
        dmpl__Message__c message = [SELECT Id, dmpl__ErrorMessage__c, dmpl__Recipient__c, dmpl__WhatId__c, dmpl__SourceObjectId__c, dmpl__Sender__c, dmpl__SenderName__c, dmpl__Subject__c, dmpl__MessageBody__c 
                                    FROM dmpl__Message__c LIMIT 1];
        MessageEmailHelper.sendEmailMessage('a2Zbn000000KP3tEAG', message);
    }
    
    @isTest
    public static void messageHelperTest(){
        MessageHelper.RuleEvaluator child = new MessageHelper.RuleEvaluator();
        dmpl__MessageRule__c messageRule = [SELECT Id, dmpl__FieldName__c, dmpl__FieldValue__c, dmpl__Operation__c 
                                            FROM dmpl__MessageRule__c LIMIT 1];
        dmpl__MessageConfiguration__c config = [SELECT Id, dmpl__TriggerEvent__c, dmpl__TriggerObjectName__c, dmpl__Subject__c, dmpl__Sender__c, dmpl__SenderName__c, dmpl__Recipient__c, dmpl__MessageBody__c, dmpl__RuleSuccessCriteria__c 
                                                FROM dmpl__MessageConfiguration__c LIMIT 1];
        dmpl__InterfaceQueue__c queue = [SELECT Id, Name, dmpl__QueueType__c, dmpl__IsSuccessful__c 
                                         FROM dmpl__InterfaceQueue__c LIMIT 1];
        MessageHelper.evaluateMessageRules('Account', TriggerHandler.TriggerContext.BEFORE_INSERT, new List<Id>{});
        MessageHelper.evaluateTimerMessageRules(queue.Id);
        MessageHelper.evaluateMessageRulesInternal('Account', String.ValueOf(TriggerHandler.TriggerContext.BEFORE_INSERT), new List<Id>{});
        child.evaluateRules(config);
        child.buildCondition(messageRule);
        testOperator(messageRule, child);
    }

    @isTest
    public static void messageServiceTest(){
        dmpl__Message__c message = [SELECT Id, dmpl__ErrorMessage__c FROM dmpl__Message__c LIMIT 1];
        Account partnerAccount = [SELECT Id, Name FROM Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__MessageConfiguration__c config = [SELECT Id, dmpl__Subject__c, dmpl__Sender__c, dmpl__SenderName__c, dmpl__Recipient__c, dmpl__MessageBody__c 
                                                FROM dmpl__MessageConfiguration__c LIMIT 1];
        new MessageService().createMessages(config, new List<Account>{partnerAccount});
        new MessageService().createMessage(config, partnerAccount);
        
        dmpl__Message__c message1 = new dmpl__Message__c(dmpl__ErrorMessage__c = 'Test Error 1');
        new MessageService().saveMessages(new List<dmpl__Message__c>{message1});
        new MessageService().getMessageConfigs();
        new MessageService().getMessageConfigs('Account');
    }

    @isTest
    public static void MessageHandlerTest(){
        dmpl__Message__c message = [SELECT Id, dmpl__ErrorMessage__c, dmpl__Recipient__c, dmpl__WhatId__c, dmpl__SourceObjectId__c, dmpl__Sender__c, dmpl__SenderName__c, dmpl__Subject__c, dmpl__MessageBody__c, dmpl__MessageConfigurationId__c 
                                    FROM dmpl__Message__c LIMIT 1];
        new MessageHandler().sendMessages(new List<dmpl__Message__c>{message});
        new MessageHandler().perfromCustomHandlerAction('TestHandler', 'sendMessage', message);
    }

    @isTest
    public static void messageNotificationHelperTest(){
        CustomNotificationType cnt = new CustomNotificationType(DeveloperName = 'Custom Error Message');
        //insert cnt;
        
        dmpl__Message__c message = [SELECT Id, dmpl__ErrorMessage__c, dmpl__Subject__c, dmpl__MessageBody__c, dmpl__SourceObjectId__c, dmpl__Recipient__c 
                                    FROM dmpl__Message__c LIMIT 1];
        MessageNotificationHelper.sendNotification('Custom Error Message', message);
        MessageNotificationHelper.sendPushNotification('App Name', message);
    }
    
    private static void testOperator(dmpl__MessageRule__c messageRule, MessageHelper.RuleEvaluator child){
        List<String> operations = new List<String>{'equals', 'notEqual', 'lessThan', 'greaterThan', 'lessOrEqual', 'greaterOrEqual', 'like', 'in', 'notIn', 'includes', 'excludes'};
        for(String operation : operations){
            messageRule.dmpl__Operation__c = operation;
            child.getOperator(messageRule);
        }
    }

    private static void CreateMessage(){
        dmpl__MessageConfiguration__c messageConfig = new dmpl__MessageConfiguration__c(
            Name = 'test1',
            dmpl__TriggerObjectName__c = 'triggerobjectnametest'
        );
        insert messageConfig;

        dmpl__Message__c message = new dmpl__Message__c(
            dmpl__ErrorMessage__c = 'Test Error 1',
            dmpl__Recipient__c = 'Test Recipient',
            dmpl__WhatId__c = 'Test',
            dmpl__MessageConfigurationId__c = messageConfig.Id
        );
        insert message;
        message.dmpl__ErrorMessage__c = 'Test Error 2';
        update message;
    }

    private static void CreateInterfaceQueue(){
        List<dmpl__InterfaceQueue__c> interfaceQueue = new List<dmpl__InterfaceQueue__c>();
        interfaceQueue.add(new dmpl__InterfaceQueue__c(
            dmpl__QueueType__c = 'Queueable',
            dmpl__JobType__c = 'Account Group Member Processor'
        ));
        insert interfaceQueue;
    }

    private static void CreateMessageConfiguration(){
        dmpl__MessageConfiguration__c messageConfig = new dmpl__MessageConfiguration__c(
            dmpl__CustomHandlerName__c = 'MessageHandler',
            dmpl__Sender__c = 'sender',
            dmpl__Subject__c = 'subject',
            dmpl__TriggerObjectName__c = 'Account',
            dmpl__ProviderType__c = 'SFDC EMail'
        );
        insert messageConfig;
    }

    private static void CreateAccount(){
        List<Account> account = new List<Account>{
            new Account(Name = 'Test - Account', Fax = '09876', dmpl__LastName__c = 'Account', Phone = '1234567891', Website = 'www.Dealermatix.com', Type = 'Prospect', NumberOfEmployees = 2, Industry = 'Education', AnnualRevenue = 1000, Description = 'Accounts added', dmpl__IsPartnerAccount__c = false, dmpl__IsActive__c = true, dmpl__IsTaxExempted__c = true, dmpl__IsSupplierAccount__c = false, dmpl__IsCustomerAccount__c = false),
            new Account(Name = 'Partner-Test-Account', dmpl__LastName__c = 'Account', dmpl__IsPartnerAccount__c = true, dmpl__IsActive__c = true),
            new Account(Name = 'Supplier-Test-Account', dmpl__LastName__c = 'Account', dmpl__IsSupplierAccount__c = true, dmpl__IsActive__c = true),
            new Account(Name = 'Customer-Test-Account', dmpl__IsCustomerAccount__c = true, dmpl__LastName__c = 'Account', dmpl__IsActive__c = true)
        };
        insert account;
    }

    private static void CreateMessageRule(){
        dmpl__MessageConfiguration__c messageConfig = new dmpl__MessageConfiguration__c(
            Name = 'test1',
            dmpl__TriggerObjectName__c = 'dmpl__AccountGroupMember__c'
        );
        insert messageConfig;

        dmpl__MessageRule__c messageRule = new dmpl__MessageRule__c(
            dmpl__FieldName__c = 'Test_FieldName',
            dmpl__FieldValue__c = 'Test_FieldValue',
            dmpl__MessageConfigurationId__c = messageConfig.Id
        );
        insert messageRule;
    }
}