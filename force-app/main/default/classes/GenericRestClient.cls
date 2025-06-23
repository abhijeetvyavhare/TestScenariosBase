@namespaceAccessible
public with sharing class GenericRestClient extends RestClient {

    @namespaceAccessible
    public static final String PROVIDERTYPE_REST = 'REST Client';
    private static final string FUNCTION_AUTHENTICATION = 'Authentication';
    
    private List<SObject> editedObjects = new List<SObject>();
    private Boolean isNestedCall = false;

    @testVisible
    private dmpl__InterfaceServiceProvider__c tsProvider;

    @namespaceAccessible
    public class DMPLApiException extends Exception {
    }

    @namespaceAccessible
    public GenericRestClient(
        dmpl__InterfaceServiceProvider__c provider) {
        super(provider.dmpl__NamedCredentials__c);
        this.tsProvider = provider;
        providerId = provider.Id;
        logLevel = provider.Logging__c;
    }

    @namespaceAccessible
    public GenericRestClient(
        dmpl__InterfaceServiceProvider__c provider,
        Id pQueueId) {
        super(provider.dmpl__NamedCredentials__c);
        this.tsProvider = provider;
        this.queueId = pQueueId;
        providerId = provider.Id;
        logLevel = provider.Logging__c;
    }
    
    @namespaceAccessible
    public RestResponseResult startRequest(
        String requestName,
        Id recordId) {
        dmpl__InterfaceServiceProviderRequest__c request = (dmpl__InterfaceServiceProviderRequest__c)CollectionHelper.getFirstIfExists(
            CollectionHelper.getObjectsByFilter(
                tsProvider.dmpl__InterfaceServiceProviderRequests__r,
                'Name',
                requestName
        ));
        if(request == null){
            throw new DMPLException(
                String.format(
                    String.valueOf(
                        System.Label.Generic_MissingObject), 
                        new String[]
                        {
                            dmpl__InterfaceServiceProviderRequest__c.class.getName()
                        }));
        }
        return startRequest(request, recordId);
    }

    @namespaceAccessible
    public RestResponseResult startRequest(
        String function,
        String customFunctionName,
        Id recordId) {
        dmpl__InterfaceServiceProviderRequest__c request = (dmpl__InterfaceServiceProviderRequest__c)CollectionHelper.getFirstIfExists(
            CollectionHelper.getObjectsByFilter(
                tsProvider.dmpl__InterfaceServiceProviderRequests__r,
                'dmpl__Function__c',
                function,
                'dmpl__CustomFunction__c',
                customFunctionName
        ));
        if(request == null){
            throw new DMPLException(
                String.format(
                    String.valueOf(
                        System.Label.Generic_MissingObject), 
                        new String[]
                        {
                            dmpl__InterfaceServiceProviderRequest__c.class.getName()
                        }));
        }
        return startRequest(request, recordId);
    }

    @namespaceAccessible
    //Deprecated - Only retained for India Extension
    //To Be Deleted
    public String startRequest(
        String objectApiName,
        Id recordId,
        String function,
        String customFunctionName
        ) {
        return JSON.serialize(startRequest(
            function, 
            customFunctionName,
            recordId));
    }

    @namespaceAccessible
    public RestResponseResult startRequest(
        Id requestId, 
        Id recordId) {
        dmpl__InterfaceServiceProviderRequest__c request = (dmpl__InterfaceServiceProviderRequest__c)
            CollectionHelper.getObject(
                tsProvider.dmpl__InterfaceServiceProviderRequests__r,
                requestId
        );
        if(request == null){
            throw new DMPLException(
                String.format(
                    String.valueOf(
                        System.Label.Generic_MissingObject), 
                        new String[]
                        {
                            dmpl__InterfaceServiceProviderRequest__c.class.getName()
                        }));
        }
        return startRequest(request, recordId);
    }

    @namespaceAccessible
    public RestResponseResult startRequest(
        Id requestId, 
        Id recordId, 
        String payload, 
        String headers, 
        String query) {
        dmpl__InterfaceServiceProviderRequest__c request = (dmpl__InterfaceServiceProviderRequest__c)
            CollectionHelper.getObject(
                tsProvider.dmpl__InterfaceServiceProviderRequests__r,
                requestId
        );
        if(request == null){
            throw new DMPLException(
                String.format(
                    String.valueOf(
                        System.Label.Generic_MissingObject), 
                        new String[]
                        {
                            dmpl__InterfaceServiceProviderRequest__c.class.getName()
                        }));
        }
        return startRequest(request, recordId, payload, headers, query);
    }

    @namespaceAccessible
    public RestResponseResult startRequest(
        dmpl__InterfaceServiceProviderRequest__c request,
        Id recordId) {
        requestId = request.Id;
        return this.startRequest(
            request,
            recordId,
            request.dmpl__PayloadSchema__c,
            null,
            null);
    }
    
    @namespaceAccessible
    //Deprecated - Only retained for India Extension
    //To Be Deleted
    public String startRequest(
        dmpl__InterfaceServiceProviderRequest__c request) {
        requestId = request.Id;
        return JSON.serialize(this.startRequest(
            request,
            request.dmpl__SObjectRecordId__c,
            request.dmpl__PayloadSchema__c,
            null,
            null));
    }

    @namespaceAccessible
    public RestResponseResult startRequest(
        dmpl__InterfaceServiceProviderRequest__c request, 
        Id recordId,
        String payload, 
        String headers, 
        String query) {
        
        if(request.dmpl__AuthenticationRequestId__c!=null){
            ensureRequestAutheticated(request);
        }

        Object payloadDataSource = getPayloadDataSource(request, recordId);
        if(!hasSourceData(
            request,
            payloadDataSource)){
            return new RestResponseResult(
                null,
                null,
                204,
                null,
                null);
        }

        String parsedRequest = parsePayload(payloadDataSource, payload);
        HttpResponse response = this.makeApiCall(
            HttpVerb.valueOf(request.dmpl__HttpVerb__c),
            getEndPoint(request, payloadDataSource),
            getQueryString(query, request, payloadDataSource),
            parsedRequest,
            getHttpHeaders(headers, request, payloadDataSource),
            Integer.valueOf(request.dmpl__TimeoutInMS__c == null ? 10000 : request.dmpl__TimeoutInMS__c)
        );

        try {
            RestResponseResult result = new RestResponseResult(
                getResponseHeaders(response),
                response.getBody(),
                response.getStatusCode(),
                response.getStatus(),
                parsedRequest);
            parseResult(
                this.tsProvider,
                request,
                result,
                recordId);
            updateLastExecutedTimeStamp(
                request, 
                result,
                payloadDataSource);
            return result;
        } catch (System.JSONException jse) {
            throw new GenericRestClient.DMPLApiException(jse.getMessage());
        }
    }

    private Boolean hasSourceData(
        dmpl__InterfaceServiceProviderRequest__c request,
        Object payloadDataSource){
        
        if(request.SourceDataType__c == InterfaceServiceProvider.REQUESTTYPE_INCREMENTAL){
            return (payloadDataSource instanceof List<SObject>) 
                && ((List<SObject>)payloadDataSource).size()>0;
        } else {
            return payloadDataSource instanceof SObject;
        }
    }

    private void ensureRequestAutheticated(
        dmpl__InterfaceServiceProviderRequest__c request){
            if(String.isBlank(this.tsProvider.dmpl__TokenBearer__c)
                || (this.tsProvider.dmpl__TokenExpiresAt__c!=null 
                    && this.tsProvider.dmpl__TokenExpiresAt__c < Datetime.now())
                || (this.tsProvider.dmpl__TokenRequestedAt__c !=null 
                    && this.tsProvider.dmpl__TokenValidityDuration__c!=null 
                    && ((Datetime)this.tsProvider.dmpl__TokenRequestedAt__c).addSeconds(
                        Integer.valueOf(this.tsProvider.dmpl__TokenValidityDuration__c)) < Datetime.now())
                || (this.tsProvider.dmpl__TokenExpiresAt__c == null
                    && this.tsProvider.dmpl__TokenValidityDuration__c ==null)){
                    try {
                        isNestedCall = true;
                        startRequest(
                            request.dmpl__AuthenticationRequestId__c,
                            null);        
                    } finally {
                        isNestedCall = false;
                    }
                }
    }

    private Object getPayloadDataSource(
        dmpl__InterfaceServiceProviderRequest__c request, 
        Id recordId
    ){
        if(request.SourceDataType__c == InterfaceServiceProvider.REQUESTTYPE_RECORD){
            if(String.IsEmpty(recordId)){
                recordId = request.dmpl__SObjectRecordId__c;
            }
            return executeRequestSOQL(request, recordId);
        }else{
            Datetime timeStamp = request.dmpl__LastExtractionTimestamp__c;
            if(timeStamp == null){
                timeStamp = Datetime.newInstance(1900,1,1,1,1,1);
            }
            return executeRequestSOQL(request, timeStamp);
        }
    }

    private String parsePayload(        
        Object payloadDataSource, 
        String payload){

        return DynamicTextParser.parse(
            payload,
            payloadDataSource);
    }

    private Boolean parseResult(
        dmpl__InterfaceServiceProvider__c tsProvider,
        dmpl__InterfaceServiceProviderRequest__c request,    
        RestResponseResult result,
        Id recordId){
        
        Boolean parseResult = DynamicTextParser.parseResult(
            result.body,
            request.dmpl__ResponseSuccessPath__c,
            request.dmpl__ResponseSuccessValue__c,
            request.dmpl__ResponseSchema__c,
            executeResponseSOQL(
                request, 
                recordId),
            this.editedObjects);
        if(request.dmpl__Function__c == FUNCTION_AUTHENTICATION){
            DynamicTextParser.parseResult(
                result.body,
                request.dmpl__ResponseSuccessPath__c,
                request.dmpl__ResponseSuccessValue__c,
                request.dmpl__ResponseSchema__c,
                tsProvider,
                this.editedObjects);
            updateAutheticationRequestDetails(
                tsProvider,
                request, 
                result,
                this.editedObjects);
        }

        if((!isNestedCall) && this.editedObjects.size()>0){
            Map<String,Object> modifiedFields = this.editedObjects[0].getPopulatedFieldsAsMap();
            upsert this.editedObjects;
        }

        return parseResult;
    }

    private Map<String, String> getHttpHeaders(
        String headersString,
        dmpl__InterfaceServiceProviderRequest__c request,
        Object payloadDataSource){

        if(String.isEmpty(headersString)){
            headersString = request.dmpl__HttpHeaders__c;
        }
        Map<String, String> headers= new Map<String, String>();
        if(String.isEmpty(headersString)){
            return null;
        }
        
        headersString = DynamicTextParser.parse(
            headersString,
            payloadDataSource);

        headersString = DynamicTextParser.parse(
            headersString, 
            this.tsProvider
            );

        headersString = DynamicTextParser.parse(
            headersString, 
            request
            );

        List<String> nvPair = headersString.split('\\n');
        for(String pair : nvPair){
            List<String> pairVlaue = pair.split(':');
            if(pairVlaue.size() == 2){
                headers.put(pairVlaue[0].trim(), pairVlaue[1].trim());
            }
        }
        return headers;
    }

    private String getEndPoint(
        dmpl__InterfaceServiceProviderRequest__c request,
        Object payloadDataSource){
            System.debug('Start EndPoint');
        String endPoint='';
        if(this.namedCredentialName!=null){
            endPoint = request.dmpl__EndPoint__c;
        }else if(String.isNotEmpty(tsProvider.dmpl__CustomCredentialsUrl__c)){
            endPoint = ensureStringEndsInSlash(tsProvider.dmpl__CustomCredentialsUrl__c) 
            + ensureStringNotStartsWithSlash(request.dmpl__EndPoint__c);
        }else{
            endPoint = request.dmpl__EndPoint__c;
        }
        
        endPoint = DynamicTextParser.parse(
            endPoint,
            payloadDataSource);

        endPoint = DynamicTextParser.parse(
            endPoint, 
            this.tsProvider
            );

        endPoint = DynamicTextParser.parse(
            endPoint, 
            request
        );

        return endPoint;
    }
    
    private string getQueryString(
        String queryString,
        dmpl__InterfaceServiceProviderRequest__c request,
        Object payloadDataSource){

            queryString = String.isEmpty(queryString)?request.dmpl__HttpQuery__c:queryString;

            queryString = DynamicTextParser.parse(
                queryString,
                payloadDataSource);

            queryString = DynamicTextParser.parse(
                queryString, 
                this.tsProvider
                );

            queryString = DynamicTextParser.parse(
                queryString, 
                request
                );

        return queryString;
    }

    private String ensureStringEndsInSlash(String resource) {
        if (resource.endsWith('/')) {
            return resource.trim();
        }
        return resource.trim() + '/';
    }

    private static String ensureStringNotStartsWithSlash(String resource) {
        if (!resource.startsWith('/')) {
            return resource.trim();
        }
        return resource.trim().removeStart('/');
    }
    
    private static String getResponseHeaders(HttpResponse response){
        String headers = '';
        if(response!=null){
            for(String key : response.getHeaderKeys()){
                headers += key + ':' + response.getHeader(key) + '\n';
            }    
        }
        return headers;
    }

    private SObject executeRequestSOQL(
        dmpl__InterfaceServiceProviderRequest__c request, 
        Id recordId){
        Id partnerAccountId = tsProvider.dmpl__PartnerAccountId__c;
        Id branchId = tsProvider.dmpl__BranchId__c;

        if(String.isNotEmpty(request.dmpl__RequestSOQL__c)){
            return Database.query(request.dmpl__RequestSOQL__c);
        }
        return null;
    }
    
    private List<SObject> executeRequestSOQL(
        dmpl__InterfaceServiceProviderRequest__c request, 
        Datetime timeStamp)
    {
        Id partnerAccountId = tsProvider.dmpl__PartnerAccountId__c;
        Id branchId = tsProvider.dmpl__BranchId__c;
        if(String.isNotEmpty(request.dmpl__RequestSOQL__c)){
            return Database.query(request.dmpl__RequestSOQL__c);
        }
        return null;
    }

    private static SObject executeResponseSOQL(
        dmpl__InterfaceServiceProviderRequest__c request, 
        Id recordId){
            if(String.isNotBlank(request.dmpl__ResponseSOQL__c)){
                return Database.query(request.dmpl__ResponseSOQL__c);
            }
            return null;
        }

    private static void updateAutheticationRequestDetails(
        dmpl__InterfaceServiceProvider__c tsProvider,
        dmpl__InterfaceServiceProviderRequest__c request,    
        RestResponseResult result,
        List<SObject> editedObjects){
            tsProvider.dmpl__HeaderToken__c = getHeaderToken(result.headers, tsProvider.dmpl__HeaderTokenKey__c);
            tsProvider.dmpl__TokenRequestedAt__c = Datetime.now();
            if(!editedObjects.contains(tsProvider)){
                editedObjects.add(tsProvider);
            }
    }
    
    private static String getHeaderToken(String headers, String key)
    {
        String finalValue = '';
        try{
            List<String> responseHeaders = headers.split('\n');
            if(responseHeaders.size() > 0)
            {
                for(String responseHeader : responseHeaders)
                {
                    List<String> keyValues = responseHeader.split(':');
                    if(keyValues.size() == 2 && keyValues[0] == key)
                        finalValue = keyValues[1];
                }
            }
        }
        catch(Exception error)
        {
            ExceptionLogHelper.logException(error);
        }
        return finalValue;
    }

    private void updateLastExecutedTimeStamp(
        dmpl__InterfaceServiceProviderRequest__c request, 
        RestResponseResult result,
        Object payloadDataSourceObject)
    {
        if(result.isSuccessful 
            && request.SourceDataType__c == InterfaceServiceProvider.REQUESTTYPE_INCREMENTAL){
        
            List<SObject> payloadDataSource = (List<SObject>)payloadDataSourceObject;
            result.hasIncrementalData = payloadDataSource.size()>0;
            if(payloadDataSource.size()==0){
                return;
            }
            Datetime maxDateTime = Datetime.newInstance(1900,1,1,1,1,1);
            for(SObject sourceObject : payloadDataSource){
                if((Datetime)sourceObject.get('CreatedDate') > maxDateTime){
                    maxDateTime = (Datetime)sourceObject.get('CreatedDate');
                }
                if((Datetime)sourceObject.get('LastModifiedDate') > maxDateTime){
                    maxDateTime = (Datetime)sourceObject.get('LastModifiedDate');
                }
            }

            request.dmpl__LastExtractionTimestamp__c = maxDateTime;
            update request;
        }
    }
}