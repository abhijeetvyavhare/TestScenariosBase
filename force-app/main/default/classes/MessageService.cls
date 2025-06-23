public with sharing class MessageService extends MetadataService {

    public static final String OBJECT_MESSAGE = 'dmpl__Message__c';
    public static final string OBJECT_MESSAGECONFIG = 'dmpl__MessageConfiguration__c';

    public static final String FIELD_MESSAGE_STATUS = 'dmpl__Status__c';
    
    public static final String FIELD_MESSAGE_STATUS_DRAFT = 'Draft';
    public static final String FIELD_MESSAGE_STATUS_QUEUED = 'Queued';
    public static final String FIELD_MESSAGE_STATUS_ERROR = 'Error';
    public static final String FIELD_MESSAGE_STATUS_SENT = 'Sent';
    public static final String FIELD_MESSAGE_TRIGGEREVENT_SCHEDULED = 'Scheduled';
    public static final String FIELD_MESSAGE_PROVIDERTYPE_CUSTOM = 'Custom Handler';
    public static final String FIELD_MESSAGE_PROVIDERTYPE_IP = 'Interface Provider';
    public static final String FIELD_MESSAGE_PROVIDERTYPE_EMAIL = 'SFDC EMail';
    public static final String FIELD_MESSAGE_PROVIDERTYPE_NOTIFICATION = 'SFDC Notification';
    public static final String FIELD_MESSAGE_PROVIDERTYPE_PUSHNOTIFICATION = 'Push Notification';
    
    public MessageService(){
        super(OBJECT_MESSAGE);
    }
 
    public List<dmpl__Message__c> createMessages(
        dmpl__MessageConfiguration__c config, 
        List<SOBject> sObjects){
            List<dmpl__Message__c> messages = new List<dmpl__Message__c>();
            if(sObjects!=null && sObjects.size()>0){
                for(SObject aObject : sObjects){
                    messages.add(createMessage(config, aObject));
                }
            }
            return messages;
    }

    public dmpl__Message__c createMessage(
        dmpl__MessageConfiguration__c config, 
        SOBject aObject){
            return new dmpl__Message__c(
                dmpl__MessageConfigurationId__c = config.Id,
                dmpl__MessageBody__c = DynamicTextParser.parse(config.dmpl__MessageBody__c, aObject),
                dmpl__Recipient__c = DynamicTextParser.parse(config.dmpl__Recipient__c, aObject),
                dmpl__SenderName__c = DynamicTextParser.parse(config.dmpl__SenderName__c, aObject),
                dmpl__Sender__c = DynamicTextParser.parse(config.dmpl__Sender__c, aObject),
                dmpl__Subject__c = DynamicTextParser.parse(config.dmpl__Subject__c, aObject),
                dmpl__SourceObjectId__c = aObject.Id,
                dmpl__Status__c = MessageService.FIELD_MESSAGE_STATUS_QUEUED
            );
    }

    public void saveMessages(List<dmpl__Message__c> messages){
        insert messages;
    }

    public List<dmpl__MessageConfiguration__c> getMessageConfigs(){
        List<dmpl__MessageConfiguration__c> configs = null;
        // if (OrgCacheHelper.isPlatformCacheEnabled()){
        //     configs = (List<dmpl__MessageConfiguration__c>)OrgCacheHelper.getObject(
        //         OrgCacheHelper.generateKey(
        //             OBJECT_MESSAGECONFIG,
        //             'Mcfgs'));
        // }
        if(configs == null){
            configs = [SELECT 
                Id,
                dmpl__InterfaceProviderId__c,
                dmpl__InterfaceRequestId__c,
                dmpl__MessageBody__c,
                dmpl__ProviderType__c,
                dmpl__Recipient__c,
                dmpl__RuleSuccessCriteria__c,
                dmpl__RuleSuccessCustomLogic__c,
                dmpl__TemplateId__c,
                dmpl__Sender__c,
                dmpl__SenderName__c,
                dmpl__Subject__c,
                dmpl__TriggerEvent__c,
                dmpl__TriggerObjectName__c,
                dmpl__CustomHandlerName__c,
                dmpl__CustomNotificationName__c,
                dmpl__PushNotificationApplicationName__c,
                dmpl__JobQueueId__c,
                (
                    SELECT 
                        dmpl__FieldName__c,
                        dmpl__FieldValue__c,
                        dmpl__Operation__c,
                        dmpl__SequenceNumber__c
                    FROM dmpl__MessageRules__r
                    ORDER BY dmpl__SequenceNumber__c
                )
            FROM
                dmpl__MessageConfiguration__c];
            OrgCacheHelper.setObject(
                OrgCacheHelper.generateKey(
                    OBJECT_MESSAGECONFIG,
                        'Mcfgs'),
                    configs);
        }
        return configs;
    }

    public List<dmpl__MessageConfiguration__c> getMessageConfigs(string sObjectApiName){
        if (OrgCacheHelper.isPlatformCacheEnabled()){
            return queryMessageConfigs(sObjectApiName);
        }
        List<dmpl__MessageConfiguration__c> configs = (List<dmpl__MessageConfiguration__c>)OrgCacheHelper.getObject(
            OrgCacheHelper.generateKey(
                sObjectApiName,
                'Mcfg'));
        if(configs == null){
            configs = queryMessageConfigs(sObjectApiName);
            if(configs!=null){
                OrgCacheHelper.setObject(
                    OrgCacheHelper.generateKey(
                        sObjectApiName,
                        'Mcfg'),
                    configs);
            }
        }
        return configs;
    }

    private List<dmpl__MessageConfiguration__c> queryMessageConfigs(string sObjectApiName){
        return [SELECT
            Id,
            dmpl__InterfaceProviderId__c,
            dmpl__InterfaceRequestId__c,
            dmpl__MessageBody__c,
            dmpl__ProviderType__c,
            dmpl__Recipient__c,
            dmpl__RuleSuccessCriteria__c,
            dmpl__RuleSuccessCustomLogic__c,
            dmpl__TemplateId__c,
            dmpl__Sender__c,
            dmpl__SenderName__c,
            dmpl__Subject__c,
            dmpl__TriggerEvent__c,
            dmpl__TriggerObjectName__c,
            dmpl__CustomHandlerName__c,
            dmpl__CustomNotificationName__c,
            dmpl__PushNotificationApplicationName__c,
            dmpl__JobQueueId__c,
            (
                SELECT 
                    Id,
                    dmpl__FieldName__c,
                    dmpl__FieldValue__c,
                    dmpl__Operation__c,
                    dmpl__SequenceNumber__c
                FROM dmpl__MessageRules__r
                ORDER BY dmpl__SequenceNumber__c
            )
        FROM
            dmpl__MessageConfiguration__c
        WHERE
            dmpl__TriggerObjectName__c =: sObjectApiName
        ];
    }
}