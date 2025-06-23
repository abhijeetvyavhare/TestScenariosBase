@namespaceAccessible
public with sharing class InterfaceLogHelper {
    
    private static final Integer TEXTSIZE = 255;
    private static final Integer LONGTEXTSIZE = 32768;
    private static final Integer VERYLONGTEXTSIZE = 131072;
    private static final String LOGLEVEL_NONE = 'None';
    private static final String LOGLEVEL_CALLOUT = 'Callout';
    private static final String LOGLEVEL_CALLOUTWITHPAYLOAD = 'Callout With Payload';

    @namespaceAccessible
    public static void logRequest(
        Id providerId,
        Id requestId,
        Id queueId,
        HttpRequest request, 
        HttpResponse response,
        String logLevel,
        Map<String, String> requestHeaders){
            if(logLevel == LOGLEVEL_NONE 
            || String.isBlank(logLevel)){
                return;
            }
        try {
            dmpl__InterfaceLogEvent__e log = new dmpl__InterfaceLogEvent__e(
                dmpl__Method__c = request.getMethod(),
                dmpl__EndPoint__c = request.getEndpoint()?.abbreviate(TEXTSIZE),
                dmpl__HttpRequestHeaders__c = getRequestHeaders(request, requestHeaders)?.abbreviate(LONGTEXTSIZE),
                dmpl__HttpResponseCode__c = (response.getStatusCode() + ' - '+ response.getStatus())?.abbreviate(TEXTSIZE),
                dmpl__HttpResponseHeaders__c = getResponseHeaders(response)?.abbreviate(LONGTEXTSIZE),
                dmpl__InterfaceServiceProviderId__c = providerId,	
                dmpl__InterfaceServiceProviderRequestId__c = requestId,
                dmpl__InterfaceQueueId__c = queueId,
                dmpl__Payload__c = logLevel == LOGLEVEL_CALLOUTWITHPAYLOAD?request.getBody()?.abbreviate(VERYLONGTEXTSIZE) : '',
                dmpl__Response__c = logLevel == LOGLEVEL_CALLOUTWITHPAYLOAD?response.getBody()?.abbreviate(VERYLONGTEXTSIZE) : ''
            );
            publishEvent(log);
        } catch (Exception e) {
        }
    }

    @namespaceAccessible
    public static void saveInterfaceLogs(List<dmpl__InterfaceLogEvent__e> newLogs){
        List<dmpl__InterfaceLog__c> interfaceLogs = new List<dmpl__InterfaceLog__c>();
        for(dmpl__InterfaceLogEvent__e log : newLogs){
            dmpl__InterfaceLog__c interfaceLog = new dmpl__InterfaceLog__c(
                dmpl__EndPoint__c = log.dmpl__EndPoint__c,
                dmpl__Method__c = log.dmpl__Method__c,
                dmpl__HttpRequestHeaders__c =log.dmpl__HttpRequestHeaders__c,
                dmpl__HttpResponseCode__c =log.dmpl__HttpResponseCode__c,
                dmpl__HttpResponseHeaders__c =log.dmpl__HttpResponseHeaders__c,
                dmpl__InterfaceServiceProviderId__c = log.dmpl__InterfaceServiceProviderId__c,	
                dmpl__InterfaceQueueId__c = log.dmpl__InterfaceQueueId__c,
                dmpl__InterfaceServiceProviderRequestId__c = log.dmpl__InterfaceServiceProviderRequestId__c,
                dmpl__Payload__c = log.dmpl__Payload__c,
                dmpl__Response__c =  log.dmpl__Response__c
            );
            interfaceLogs.add(interfaceLog);
        }
        //No Permission Check required since the interface log needs to be written irrespective of user permissions
        insert(interfaceLogs);
    }

    @testVisible
    private static void publishEvent(dmpl__InterfaceLogEvent__e log){
        Database.SaveResult result = EventBus.publish(log);
    }

    @testVisible
    private static String getResponseHeaders(HttpResponse response){
        String headers = '';
        try {
            if(response!=null){
                for(String key : response.getHeaderKeys()){
                    headers += key + ':' + response.getHeader(key) + '\n';
                }                    
            }
        } catch (Exception e) {
        }
        return headers;
    }
    
    private static String getRequestHeaders(HttpRequest request, Map<String, String> requestHeaders){
        String headers = '';
        try {
            if(requestHeaders!=null){
                for(String key : requestHeaders.keySet()){
                    headers += key + ':' + request.getHeader(key) + '\n';
                }    
            }                
        } catch (Exception e) {
        }
        return headers;
    }
}