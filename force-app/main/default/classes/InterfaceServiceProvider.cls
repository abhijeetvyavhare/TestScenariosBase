global with sharing class InterfaceServiceProvider {
    
    public static final String REQUESTTYPE_INCREMENTAL = 'Incremental';    
    public static final String REQUESTTYPE_RECORD = 'Record Id';    
    public static final String PROVIDERTYPE_CUSTOM = 'Custom Provider';    
    
    //dumy for packaging
    global static HttpResponseResult perfromAction(
        Id providerId,
        Id requestId,
        Id recordId){
            JobResponseResult result = perfromAction2(
                providerId, 
                requestId, 
                recordId);
            return new HttpResponseResult(
                '',
                '',
                result.isSuccessful?200:500,
                '',
                result.parsedRequest
            );
        }
    
    global static JobResponseResult perfromAction2(
        Id providerId,
        Id requestId,
        Id recordId) {
        try {
            dmpl__InterfaceServiceProvider__c tsProvider = InterfaceServiceProviderHelper.getProvider(
                providerId
            );
            if(tsProvider == null){
                throw new DMPLException(
                    String.format(
                        String.valueOf(
                            System.Label.Generic_MissingObject), 
                            new String[]
                            {
                                dmpl__InterfaceServiceProvider__c.class.getName()
                            }));
            }

            if(tsProvider.dmpl__ProviderType__c == GenericRestClient.PROVIDERTYPE_REST){
                return perfromRESTAction(
                    tsProvider,
                    requestId,
                    recordId,
                    null
                );
            }else if(tsProvider.dmpl__ProviderType__c == FileClient.PROVIDERTYPE_FILE){
                return perfromFileAction(
                    tsProvider,
                    requestId,
                    recordId,
                    null
                );
            }else if(tsProvider.dmpl__ProviderType__c == PROVIDERTYPE_CUSTOM){
                return perfromCustomProviderAction(
                    tsProvider,
                    requestId,
                    recordId,
                    null
                );
            } else {
                throw new DMPLException(
                    String.format(
                        String.valueOf(
                            System.Label.Generic_BadArgument), 
                            new String[]
                            {
                                dmpl__InterfaceServiceProvider__c.class.getName()
                            }));
            } 
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    //dumy for packaging
    global static HttpResponseResult perfromAction(
        Id providerId,
        Id requestId,
        Id recordId,
        Id queueId){
            JobResponseResult result = perfromAction2(
                providerId, 
                requestId, 
                recordId,
                queueId);
            return new HttpResponseResult(
                '',
                '',
                result.isSuccessful?200:500,
                '',
                result.parsedRequest
            );
        }

    global static JobResponseResult perfromAction2(
        Id providerId,
        Id requestId,
        Id recordId,
        Id queueId) {
        try {
            dmpl__InterfaceServiceProvider__c tsProvider = InterfaceServiceProviderHelper.getProvider(
                providerId
            );
            if(tsProvider == null){
                throw new DMPLException(
                    String.format(
                        String.valueOf(
                            System.Label.Generic_MissingObject), 
                            new String[]
                            {
                                dmpl__InterfaceServiceProvider__c.class.getName()
                            }));
            }
            
            if(tsProvider.dmpl__ProviderType__c == GenericRestClient.PROVIDERTYPE_REST){
                return perfromRESTAction(
                    tsProvider,
                    requestId,
                    recordId,
                    queueId
                );
            }else if(tsProvider.dmpl__ProviderType__c == FileClient.PROVIDERTYPE_FILE){
                return perfromFileAction(
                    tsProvider,
                    requestId,
                    recordId,
                    queueId
                );
            }else if(tsProvider.dmpl__ProviderType__c == PROVIDERTYPE_CUSTOM){
                return perfromCustomProviderAction(
                    tsProvider,
                    requestId,
                    recordId,
                    queueId
                );
            } else {
                throw new DMPLException(
                    String.format(
                        String.valueOf(
                            System.Label.Generic_BadArgument), 
                            new String[]
                            {
                                dmpl__InterfaceServiceProvider__c.class.getName()
                            }));
            } 
        } catch (Exception error) {
            ExceptionLogHelper.logException(
                error, 
                queueId);
            throw error;
        }
    }

    global static RestResponseResult perfromRESTAction(
        dmpl__InterfaceServiceProvider__c tsProvider,
        Id requestId,
        Id recordId,
        Id queueId) {
        
        if(tsProvider.dmpl__ProviderType__c != GenericRestClient.PROVIDERTYPE_REST){
            throw new DMPLException(
                String.format(
                    String.valueOf(
                        System.Label.Generic_BadArgument), 
                        new String[]
                        {
                            dmpl__InterfaceServiceProvider__c.class.getName()
                        }));
        }    

        GenericRestClient client;
        if(queueId !=null){
            client = new GenericRestClient(tsProvider, queueId);
        } else {
            client = new GenericRestClient(tsProvider);
        }
        return client.startRequest(
            requestId,
            recordId);
    }

    global static FileResponseResult perfromFileAction(
        dmpl__InterfaceServiceProvider__c tsProvider,
        Id requestId,
        Id recordId,
        Id queueId) {
        
        try {
            if(tsProvider.dmpl__ProviderType__c != FileClient.PROVIDERTYPE_FILE){
                throw new DMPLException(
                    String.format(
                        String.valueOf(
                            System.Label.Generic_BadArgument), 
                            new String[]
                            {
                                dmpl__InterfaceServiceProvider__c.class.getName()
                            }));
            }    
            FileClient client;
            if(queueId!=null){
                client = new FileClient(tsProvider, queueId);
            }else{
                client = new FileClient(tsProvider);
            }
            return client.startRequest(
                requestId,
                recordId);
        } catch (Exception error) {
            ExceptionLogHelper.logException(
                error,
                queueId);
            throw error;
        }
    }

    @testVisible
    global static JobResponseResult perfromCustomProviderAction(
        dmpl__InterfaceServiceProvider__c tsProvider,
        Id requestId,
        Id recordId,
        Id queueId) {
        
        try {
            if(tsProvider.dmpl__ProviderType__c != PROVIDERTYPE_CUSTOM){
                throw new DMPLException(
                    String.format(
                        String.valueOf(
                            System.Label.Generic_BadArgument), 
                            new String[]
                            {
                                dmpl__InterfaceServiceProvider__c.class.getName()
                            }));
            }    
            
            return perfromCustomProviderAction(
                tsProvider.dmpl__CustomProviderName__c,
                'perfromAction',
                tsProvider,
                requestId,
                recordId,
                queueId);
        } catch (Exception error) {
            ExceptionLogHelper.logException(
                error,
                queueId);
            throw error;
        }
    }

    private static JobResponseResult perfromCustomProviderAction(
        String handlerName,
        String actionName,
        dmpl__InterfaceServiceProvider__c tsProvider,
        Id requestId,
        Id recordId,
        Id queueId){
    try
        {
            if(String.isBlank(actionName)){
                actionName = 'perfromAction';
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

            return (JobResponseResult)callable.call(
                actionName,
                new Map<String, Object> {
                    'tsProvider' => tsProvider,
                    'requestId' => requestId,
                    'recordId' => recordId,
                    'queueId' => queueId
                });
        }
        catch(Exception e)
        {
            throw new DMPLException(e.getMessage());
        }
    }
}