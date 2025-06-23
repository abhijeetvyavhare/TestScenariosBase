public with sharing class MessageHandler extends TriggerHandler {

    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{};
    private static final List<String> LIST_NON_EDITABLE_FIELDS = new List<String>{};
    
    private MessageService iccs;
    private List<dmpl__Message__c> triggerNew;
    private List<dmpl__Message__c> triggerOld;
    private Map<Id, dmpl__Message__c> triggerMapNew;
    private Map<Id, dmpl__Message__c> triggerMapOld;

    public MessageHandler() {
        this.iccs = new MessageService();
        this.triggerOld = (List<dmpl__Message__c>) Trigger.old;
        this.triggerNew = (List<dmpl__Message__c>) Trigger.new;
        this.triggerMapNew = (Map<Id, dmpl__Message__c>) Trigger.newMap;
        this.triggerMapOld = (Map<Id, dmpl__Message__c>) Trigger.oldMap;
    }

    public override void beforeInsert(){
        if(!IsValidationSkipped()){
            DocumentHelper.validateChangeInSystemFields(
                LIST_FIELDS_SYSTEM, triggerNew);
        }
    }

    public override void beforeUpdate(){
        if(!IsValidationSkipped()){
            DocumentStatusDFSHelper dfsHelper = new DocumentStatusDFSHelper();
            DocumentHelper.validateChangeInKeyFields(
                LIST_NON_EDITABLE_FIELDS, 
                triggerOld, 
                triggerNew);
            DocumentHelper.validateChangeInSystemFields(
                LIST_FIELDS_SYSTEM, 
                triggerOld, 
                triggerNew);
        }
    }

    public override void afterInsert(){
        List<dmpl__Message__c> modifiedObjects 
            = (List<dmpl__Message__c>)CollectionHelper.getObjectsByFilter(
                triggerNew,
                MessageService.FIELD_MESSAGE_STATUS,
                MessageService.FIELD_MESSAGE_STATUS_QUEUED);
        if(modifiedObjects.size() > 0){
            sendMessages(modifiedObjects);
        }   
    }

    @testVisible
    private void sendMessages(List<dmpl__Message__c> modifiedObjects){
        List<dmpl__MessageConfiguration__c> configs = iccs.getMessageConfigs();
        List<dmpl__Message__c> updatedMessages = new List<dmpl__Message__c>();
        for(dmpl__Message__c message : modifiedObjects){
            dmpl__MessageConfiguration__c config = (dmpl__MessageConfiguration__c)CollectionHelper.getObject(
                configs, 
                message.dmpl__MessageConfigurationId__c);
            if(config == null){
                continue;
            }
            SendMessageResult sendResult = null;
            if(config.dmpl__ProviderType__c == MessageService.FIELD_MESSAGE_PROVIDERTYPE_EMAIL){
                sendResult = MessageEmailHelper.sendEmailMessage(
                    config.dmpl__TemplateId__c,
                    message);
            } else if(config.dmpl__ProviderType__c == MessageService.FIELD_MESSAGE_PROVIDERTYPE_IP){
                InterfaceServiceProvider.perfromAction2(
                    config.dmpl__InterfaceProviderId__c, 
                    config.dmpl__InterfaceRequestId__c, 
                    message.Id);
            } else if(config.dmpl__ProviderType__c == MessageService.FIELD_MESSAGE_PROVIDERTYPE_NOTIFICATION){
                sendResult = MessageNotificationHelper.sendNotification(
                    config.dmpl__CustomNotificationName__c, 
                    message);
            } else if(config.dmpl__ProviderType__c == MessageService.FIELD_MESSAGE_PROVIDERTYPE_PUSHNOTIFICATION){
                sendResult = MessageNotificationHelper.sendPushNotification(
                    config.dmpl__PushNotificationApplicationName__c,
                    message);
            } else if(config.dmpl__ProviderType__c == MessageService.FIELD_MESSAGE_PROVIDERTYPE_CUSTOM){
                sendResult = perfromCustomHandlerAction(
                        config.dmpl__CustomHandlerName__c,
                        'sendMessage',
                        message);
            }
            if(sendResult != null){
                dmpl__Message__c updatedMsg = new dmpl__Message__c();
                updatedMsg.Id = message.Id;
                updatedMsg.dmpl__Status__c = (sendResult.result ? 
                    MessageService.FIELD_MESSAGE_STATUS_SENT : 
                    MessageService.FIELD_MESSAGE_STATUS_ERROR);
                updatedMsg.dmpl__ErrorMessage__c = (sendResult.error != null ) ? (sendResult.error.left(255)) : null;
                updatedMessages.add(updatedMsg);
            }
        }
        if(updatedMessages.size()>0){
            update updatedMessages;
        }
    }

    @testVisible
    private SendMessageResult perfromCustomHandlerAction(
        String handlerName,
        String actionName,
        dmpl__Message__c message){
    try
        {
            if(String.isBlank(actionName)){
                actionName = 'sendMessages';
            }
            System.Type typeName = Type.forName(handlerName);
            if(typeName == null){
                throw new CalloutException(
                    'Type not found!. Please ensure that the controller class named is valid');
            }
            
            Object dynamicObject =  typeName.newInstance();
            if(dynamicObject == null){
                throw new CalloutException(
                    'Failed to create Dynamic Controller!. Please ensure that the controller class named \"' 
                    + handlerName 
                    + '\" is creatable.');
            }

            Callable callable =  (Callable)dynamicObject;
            if(callable == null){
                throw new CalloutException(
                    'Callable Type Cast Failed!. Please ensure that the controller class named \"' 
                    + handlerName 
                    + '\" implements Callable Interface.');
            }

            SendMessageResult callResult = new SendMessageResult();
            callResult.result = (Boolean)callable.call(
                actionName,
                new Map<String, Object> {
                    'message' => message
                });
            return callResult;
        }
        catch(Exception e)
        {
            ExceptionLogHelper.logException(e);
            return new SendMessageResult(
                false,
                e.getMessage());
        }
    }
}