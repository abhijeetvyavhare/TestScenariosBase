public with sharing class MessageEmailHelper {
    public static SendMessageResult sendEmailMessage(
        Id templateId,
        dmpl__Message__c message){
        try {
            Messaging.reserveSingleEmailCapacity(2);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = message.dmpl__Recipient__c.split(',');
            mail.setToAddresses(toAddresses);
            mail.setReplyTo(message.dmpl__Sender__c);
            mail.setSenderDisplayName(message.dmpl__SenderName__c);
            mail.setSubject(message.dmpl__Subject__c);
            mail.setBccSender(false);
            mail.setUseSignature(false);
            mail.setPlainTextBody(message.dmpl__MessageBody__c);
            if(message.dmpl__SourceObjectId__c!=null){
                mail.setTargetObjectId(message.dmpl__SourceObjectId__c);
            }
            if(templateId!=null){
                mail.setTemplateId(templateId);
            }
            if(String.isNotBlank(message.dmpl__WhatId__c)){
                mail.setWhatId(message.dmpl__WhatId__c);
            }
            List<Messaging.SendEmailResult> results = Messaging.sendEmail(
                new Messaging.SingleEmailMessage[] { mail });
            if(results.size()>0){
                return new SendMessageResult(
                    results[0].isSuccess(),
                    results[0].errors.size() > 0 ? results[0].errors[0].getMessage() : '');    
            } else {
                return new SendMessageResult(
                false,
                null);
            }
        } catch (Exception e) {
            ExceptionLogHelper.logException(e);
            return new SendMessageResult(
                false,
                e.getMessage());
        }
    }
}