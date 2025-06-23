@namespaceAccessible
public with sharing class ExceptionLogHelper {
    
    private static final string OBJECT_EXCEPTIONLOG = 'dmpl__ErrorLogEvent__e';
        
    @namespaceAccessible
    public static void logException(Exception error){
        try {
            dmpl__ErrorLogEvent__e log = new dmpl__ErrorLogEvent__e(
                dmpl__Message__c = error.getMessage(),
                dmpl__Type__c = Exception.class.getName(),
                dmpl__UserId__c = UserInfo.getUserId()
            );
            if(error instanceOf DMPLNoAccessException){
                setSecurityExceptionDetails(log, error);
            }
            setExceptionDetails(log, error);
            publishEvent(log);
        } catch (Exception e) {
        }
    }
    
    @namespaceAccessible
    public static void logException(Exception error, Id jobsQueueId){
        try {
            dmpl__ErrorLogEvent__e log = new dmpl__ErrorLogEvent__e(
                dmpl__Message__c = error.getMessage(),
                dmpl__Type__c = Exception.class.getName(),
                dmpl__UserId__c = UserInfo.getUserId(),
                dmpl__JobsQueueId__c = String.valueOf(jobsQueueId)
            );
            if(error instanceOf DMPLNoAccessException){
                setSecurityExceptionDetails(log, error);
            }
            setExceptionDetails(log, error);
            publishEvent(log);
        } catch (Exception e) {
        }
    }

    @namespaceAccessible
    public static void logMessage(String message){
        try {
            dmpl__ErrorLogEvent__e log = new dmpl__ErrorLogEvent__e(
                dmpl__Message__c = message,
                dmpl__Type__c = 'Info',
                dmpl__UserId__c = UserInfo.getUserId()
            );
            publishEvent(log);
        } catch (Exception e) {
        }
    }

    @namespaceAccessible
    public static void saveErrorLogs(List<dmpl__ErrorLogEvent__e> newLogs){
        List<dmpl__ErrorLog__c> errorLogs = new List<dmpl__ErrorLog__c>();
        for(dmpl__ErrorLogEvent__e log : newLogs){
            dmpl__ErrorLog__c errorLog = new dmpl__ErrorLog__c(
                dmpl__AccessType__c = log.dmpl__AccessType__c,
                dmpl__FieldName__c =log.dmpl__FieldName__c,
                dmpl__Message__c =log.dmpl__Message__c,
                dmpl__ObjectName__c =log.dmpl__ObjectName__c,
                dmpl__Type__c =log.dmpl__Type__c,
                dmpl__ClassName__c = log.dmpl__ClassName__c,	
                dmpl__MethodName__c = log.dmpl__MethodName__c,
                dmpl__QueryLimit__c = log.dmpl__QueryLimit__c,
                dmpl__DMLimit__c =  log.dmpl__DMLimit__c,
                dmpl__DMLStat__c =  log.dmpl__DMLStat__c,
                dmpl__CPUTime__c = log.dmpl__CPUTime__c,
                dmpl__StackTrace__c = log.dmpl__StackTrace__c,
                dmpl__JobsQueueId__c = log.dmpl__JobsQueueId__c,
                dmpl__UserId__c = log.dmpl__UserId__c == null?null: Id.valueOf(log.dmpl__UserId__c)
            );
            errorLogs.add(errorLog);
        }
        //No Permission Check required since the error log needs to be written irrespective of user permissions
        insert(errorLogs);
    }

    private static void setExceptionDetails(dmpl__ErrorLogEvent__e log, Exception e){
        String stackTrace = e.getStackTraceString().substringBefore('\n');
        log.dmpl__StackTrace__c = e.getStackTraceString();
		log.dmpl__ClassName__c = stackTrace.substringAfter('.').substringBefore('.');	
        log.dmpl__MethodName__c = stackTrace.substringBefore(':').substringAfter(log.dmpl__ClassName__c).substringAfter('.');
        log.dmpl__QueryLimit__c = Limits.getQueries() + '/' + Limits.getLimitQueries();
        log.dmpl__DMLimit__c =  Limits.getDmlRows() + '/' + Limits.getLimitDmlRows();
        log.dmpl__DMLStat__c =  Limits.getDmlStatements() + '/' + Limits.getLimitDmlStatements();   
        log.dmpl__CPUTime__c =  Limits.getCpuTime() + '/' + Limits.getLimitCpuTime();
    }

    private static void setSecurityExceptionDetails(dmpl__ErrorLogEvent__e log, Exception error){
        DMPLNoAccessException accessError = (DMPLNoAccessException)error;
        if(accessError!=null){
            log.dmpl__AccessType__c = String.valueOf(accessError.accessType);
            log.dmpl__FieldName__c =accessError.fieldName;
            log.dmpl__ObjectName__c =accessError.objectName;
            log.dmpl__Type__c = DMPLNoAccessException.class.getName();
        }
    }

    private static void publishEvent(dmpl__ErrorLogEvent__e log){
        Database.SaveResult result = EventBus.publish(log);
    }
}