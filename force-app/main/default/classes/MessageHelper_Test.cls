@IsTest
public class MessageHelper_Test {
	
    @testSetup
    public static void Setup(){
        Test.startTest();
        CreateAccount();
        CreateMessage();
        CreateInterfaceQueue();
        CreateMessageConfiguration();
        CreateMessageRule();
        Test.StopTest();
    }
    
    @isTest
    public static void Test1(){
        dmpl__MessageConfiguration__c messageConfig = [SELECT Id FROM dmpl__MessageConfiguration__c limit 1];
        dmpl__Message__c message = new dmpl__Message__c(
        	dmpl__ErrorMessage__c='Test Error 1',
            dmpl__MessageConfigurationId__c = messageConfig.Id
        );
        insert message;
        message.dmpl__ErrorMessage__c = 'Error 2';
        update message;
    }
    
    @isTest
    public static void Test2(){
        dmpl__Message__c message=[SELECT id,
                                  dmpl__ErrorMessage__c,
                                  dmpl__Recipient__c,
                                  dmpl__WhatId__c,
                                  dmpl__SourceObjectId__c,
                                  dmpl__Sender__c,
                                  dmpl__SenderName__c,
                                  dmpl__Subject__c,
                                  dmpl__MessageBody__c,
                                  dmpl__MessageConfigurationId__c
                                  FROM dmpl__Message__c WHERE dmpl__MessageConfigurationId__c != null];
        new MessageHandler().sendMessages(new List<dmpl__Message__c>{message});
    }
    
    @isTest
    public static void messageEmailHelperTest(){
        dmpl__Message__c message=[SELECT id,
                                  dmpl__ErrorMessage__c,
                                  dmpl__Recipient__c,
                                  dmpl__WhatId__c,
                                  dmpl__SourceObjectId__c,
                                  dmpl__Sender__c,
                                  dmpl__SenderName__c,
                                  dmpl__Subject__c,
                                  dmpl__MessageBody__c
                                  FROM dmpl__Message__c limit 1];
        MessageEmailHelper.sendEmailMessage('a2Zbn000000KP3tEAG',message);
    }
    
    @isTest
    public static void messageHelperTest(){
        MessageHelper.RuleEvaluator child=new MessageHelper.RuleEvaluator();
        dmpl__MessageRule__c MessageRule=[SELECT id,
                                          dmpl__FieldName__c,
                                          dmpl__FieldValue__c,
                                          dmpl__Operation__c
                                          FROM dmpl__MessageRule__c LIMIT 1];
        dmpl__MessageConfiguration__c config=[SELECT id,
                                              dmpl__TriggerEvent__c,
                                              dmpl__TriggerObjectName__c,
                                              dmpl__Subject__c,
                                              dmpl__Sender__c,
                                              dmpl__SenderName__c,
                                              dmpl__Recipient__c,
                                              dmpl__MessageBody__c,
                                              dmpl__RuleSuccessCriteria__c
                                              FROM dmpl__MessageConfiguration__c limit 1];
        dmpl__InterfaceQueue__c queue =[Select Id, Name,dmpl__QueueType__c,dmpl__IsSuccessful__c from dmpl__InterfaceQueue__c Limit 1];
        MessageHelper.evaluateMessageRules('Account',TriggerHandler.TriggerContext.BEFORE_INSERT,new List<Id>{});
        MessageHelper.evaluateTimerMessageRules(queue.Id);
        MessageHelper.evaluateMessageRulesInternal('Account',String.Valueof(TriggerHandler.TriggerContext.BEFORE_INSERT),new List<Id>{});
        //MessageHelper.getSourceObjects(config,new List<Id>{});
        child.evaluateRules(config);
        child.buildCondition(MessageRule);
        child.getOperator(MessageRule);
        MessageRule.dmpl__Operation__c='equals';
        child.getOperator(MessageRule);   
        MessageRule.dmpl__Operation__c='notEqual';
        child.getOperator(MessageRule);
        MessageRule.dmpl__Operation__c='lessThan';
        child.getOperator(MessageRule);
        MessageRule.dmpl__Operation__c='greaterThan';
        child.getOperator(MessageRule);
        MessageRule.dmpl__Operation__c='lessOrEqual';
        child.getOperator(MessageRule);
        MessageRule.dmpl__Operation__c='greaterOrEqual';
        child.getOperator(MessageRule);
        MessageRule.dmpl__Operation__c='like';
        child.getOperator(MessageRule);
        MessageRule.dmpl__Operation__c='in';
        child.getOperator(MessageRule);
        MessageRule.dmpl__Operation__c='notIn';
        child.getOperator(MessageRule);
        MessageRule.dmpl__Operation__c='includes';
        child.getOperator(MessageRule);
        MessageRule.dmpl__Operation__c='excludes';
        child.getOperator(MessageRule);
    }
    
    @isTest
    public static void messageServiceTest(){
		dmpl__Message__c message=[SELECT Id, dmpl__ErrorMessage__c FROM dmpl__Message__c];
        message.dmpl__ErrorMessage__c='new Error Message';
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];        
        dmpl__MessageConfiguration__c config=[SELECT id,dmpl__Subject__c,dmpl__Sender__c,dmpl__SenderName__c,dmpl__Recipient__c,dmpl__MessageBody__c FROM dmpl__MessageConfiguration__c limit 1];
        new MessageService().createMessages(config,new List<Account>{partnerAccount});
        new MessageService().createMessage(config,partnerAccount);
        dmpl__Message__c message1=new dmpl__Message__c(
        	dmpl__ErrorMessage__c='Test Error 1'
        );
        new MessageService().saveMessages(new List<dmpl__Message__c>{message1});
        new MessageService().getMessageConfigs();
        new MessageService().getMessageConfigs('Account');
    }
    
    @isTest
    public static void MessageHandlerTest(){
        dmpl__Message__c message=[SELECT id,
                                  dmpl__ErrorMessage__c,
                                  dmpl__Recipient__c,
                                  dmpl__WhatId__c,
                                  dmpl__SourceObjectId__c,
                                  dmpl__Sender__c,
                                  dmpl__SenderName__c,
                                  dmpl__Subject__c,
                                  dmpl__MessageBody__c,
                                  dmpl__MessageConfigurationId__c
                                  FROM dmpl__Message__c];
        new MessageHandler().sendMessages(new List<dmpl__Message__c>{message});
        new MessageHandler().perfromCustomHandlerAction('','',message);
    }
    
    @isTest
    public static void messageNotificationHelperTest(){
        CustomNotificationType cnt=new CustomNotificationType(
        	DeveloperName='Custom Error Message'
        );
        dmpl__Message__c message=[SELECT id,dmpl__ErrorMessage__c,dmpl__Subject__c,dmpl__MessageBody__c,dmpl__SourceObjectId__c,dmpl__Recipient__c FROM dmpl__Message__c];
        MessageNotificationHelper.sendNotification('Custom Error Message',message);
        MessageNotificationHelper.sendPushNotification('App Name', message);
    }
    
    private static Void CreateMessage(){
        dmpl__MessageConfiguration__c messageConfig= new dmpl__MessageConfiguration__c(
          Name='test1',
          dmpl__TriggerObjectName__c='triggerobjectnametest'
        );
        insert messageConfig;
        dmpl__Message__c message=new dmpl__Message__c(
        	dmpl__ErrorMessage__c='Test Error 1',
            dmpl__Recipient__c='Test Recipient',
            dmpl__WhatId__c='Test',
            dmpl__MessageConfigurationId__c = messageConfig.Id
        );
        insert message;
        message.dmpl__ErrorMessage__c='Test Error 2';
        update message;
    }
    
    private Static void CreateInterfaceQueue(){
        List<dmpl__InterfaceQueue__c> interfaceQueue =new List<dmpl__InterfaceQueue__c>();
        //dmpl__InterfaceServiceProvider__c interfaceService = [Select Id,Name From dmpl__InterfaceServiceProvider__c LIMIT 1];
        //dmpl__InterfaceServiceProviderRequest__c request = [Select Id,Name From dmpl__InterfaceServiceProviderRequest__c LIMIT 1]; 
        interfaceQueue.Add(new dmpl__InterfaceQueue__c(//dmpl__InterfaceProviderId__c =interfaceService.Id,
                                                       dmpl__QueueType__c = 'Queueable',
                                                       //dmpl__InterfaceRequestId__c = request.Id,
                                                       dmpl__JobType__c = 'Account Group Member Processor'));
        insert interfaceQueue;
    }
    
    private static void CreateMessageConfiguration(){
        dmpl__MessageConfiguration__c messageConfig=new dmpl__MessageConfiguration__c(
        	dmpl__CustomHandlerName__c='Test Handler 1',
            dmpl__Sender__c='sender',
            dmpl__Subject__c='subject',
            dmpl__TriggerObjectName__c='Account'
        );
        insert messageConfig;
    }
    
    private static void CreateAccount()
    {
        List<Account> account = new List<Account>();
        account.add(new Account(Name = 'Test - Account', 
            					Fax = '09876',
                               dmpl__LastName__c = 'Account',
                               Phone = '1234567891',
                               Website = 'www.Dealermatix.com',
                               Type = 'Prospect',
                               NumberOfEmployees = 2, 
                               Industry = 'Education',
                               AnnualRevenue = 1000,
                               Description = 'Accounts added',
                               dmpl__IsPartnerAccount__c = false,
                               dmpl__IsActive__c = True,
                               dmpl__IsTaxExempted__c = True,
                               dmpl__IsSupplierAccount__c = false,
                               dmpl__IsCustomerAccount__c = False
                               ));
        insert account;
        
        Account partneraccount = new Account(Name = 'Partner-Test-Account',
                                             dmpl__LastName__c = 'Account',
                                             dmpl__IsPartnerAccount__c = True, 
                                             dmpl__IsActive__c = true);
        insert partneraccount;
        
        Account supplieraccount = new Account(Name = 'Supplier-Test-Account',
                                              dmpl__LastName__c = 'Account',
                                              dmpl__IsSupplierAccount__c = True,
                                              dmpl__IsActive__c = true);
        insert supplieraccount;
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__IsCustomerAccount__c = True,
                                              dmpl__LastName__c = 'Account',
                                              dmpl__IsActive__c = true);
        insert customerAccount;
    }
    
    private static void CreateMessageRule(){
        dmpl__MessageConfiguration__c messageConfig= new dmpl__MessageConfiguration__c(
          Name='test1',
          dmpl__TriggerObjectName__c='dmpl__Bill__c'
        );
        insert messageConfig;
        dmpl__MessageRule__c MessageRule=new dmpl__MessageRule__c(
            dmpl__FieldName__c='feildName1',
            dmpl__MessageConfigurationId__c=messageConfig.id
        );
        insert MessageRule;
    }
}