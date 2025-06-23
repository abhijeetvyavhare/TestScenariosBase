public with sharing class MessageNotificationHelper {
    public static SendMessageResult sendNotification(
        String customNotificationName,
        dmpl__Message__c message) {
        try {
            CustomNotificationType notificationType = 
                [SELECT Id, DeveloperName 
                    FROM CustomNotificationType 
                    WHERE DeveloperName=: customNotificationName];
            
            Messaging.CustomNotification notification = new Messaging.CustomNotification();
            notification.setTitle(message.dmpl__Subject__c);
            notification.setBody(message.dmpl__MessageBody__c);
            notification.setNotificationTypeId(notificationType.Id);
            if(String.isBlank(message.dmpl__SourceObjectId__c)){
                notification.setTargetId('000000000000000AAA');
            }else{
                notification.setTargetId(message.dmpl__SourceObjectId__c);
            }
            notification.send(new Set<String>(message.dmpl__Recipient__c.split(',')));
            return new SendMessageResult(
                true,
                null);
        }
        catch (Exception e) {
            ExceptionLogHelper.logException(e);
            return new SendMessageResult(
                false,
                e.toString());
        }
    }

    public static SendMessageResult sendPushNotification(
        String applicationName,
        dmpl__Message__c message){
            try {
                Messaging.PushNotification msg = 
                    new Messaging.PushNotification();
                Map<String, Object> payload = 
                    Messaging.PushNotificationPayload.apple(
                        message.dmpl__MessageBody__c, 
                        '', 
                        null, 
                        null);    
                msg.setPayload(payload);
                Set<String> users = new Set<String>();
                users.add(message.dmpl__Recipient__c);
                msg.send(
                    applicationName, 
                    users);
                return new SendMessageResult(
                    true,
                    null);
            }
            catch (Exception e) {
                ExceptionLogHelper.logException(e);
                return new SendMessageResult(
                    false,
                    e.toString());
            }
    }
}