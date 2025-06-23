trigger ErrorLogEventTrigger on dmpl__ErrorLogEvent__e (after insert) {
    ExceptionLogHelper.saveErrorLogs(Trigger.new);
    new MetadataTriggerHandler().run();
}