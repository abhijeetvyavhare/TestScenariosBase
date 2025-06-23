@namespaceAccessible
public with sharing class FileClient {

    @namespaceAccessible
    public static final String PROVIDERTYPE_FILE = 'File Storage';    
    private List<SObject> editedObjects = new List<SObject>();

    @testVisible
    private dmpl__InterfaceServiceProvider__c tsProvider;
    
    @testVisible
    @namespaceAccessible
    protected Id providerId { get; set; }
    
    @testVisible
    @namespaceAccessible
    protected Id requestId { get; set; }

    @testVisible
    @namespaceAccessible
    protected String logLevel { get; set; }

    @testVisible
    @namespaceAccessible
    protected Id queueId { get; set; }

    @namespaceAccessible
    public class DMPLFileException extends Exception {
    }

    @namespaceAccessible
    public FileClient(
        dmpl__InterfaceServiceProvider__c provider) {
        this.tsProvider = provider;
        providerId = provider.Id;
        logLevel = provider.Logging__c;
    }

    @namespaceAccessible
    public FileClient(
        dmpl__InterfaceServiceProvider__c provider,
        Id pQueueId) {
        this.tsProvider = provider;
        this.queueId = pQueueId;
        providerId = provider.Id;
        logLevel = provider.Logging__c;
    }
    
    @namespaceAccessible
    public FileResponseResult startRequest(
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
    public FileResponseResult startRequest(
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
    public FileResponseResult startRequest(
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
    public FileResponseResult startRequest(
        Id requestId, 
        Id recordId, 
        String payload) {
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
        return startRequest(request, recordId, payload);
    }

    @namespaceAccessible
    public FileResponseResult startRequest(
        dmpl__InterfaceServiceProviderRequest__c request,
        Id recordId) {
        requestId = request.Id;
        return this.startRequest(
            request,
            recordId,
            request.dmpl__PayloadSchema__c);
    }
    
    @namespaceAccessible
    public FileResponseResult startRequest(
        dmpl__InterfaceServiceProviderRequest__c request, 
        Id recordId,
        String payload) {
        
        Object payloadDataSource = getPayloadDataSource(request, recordId);
        String parsedRequest = DynamicTextParser.parse(
            payload,
            payloadDataSource);
        FileResponseResult result = new FileResponseResult(
            true, 
            parsedRequest, 
            parsedRequest);
        setFileDetails(
            result,
            request
        );
        updateLastExecutedTimeStamp(
            request, 
            result,
            payloadDataSource);
        return result;
    }

    private void setFileDetails(
        FileResponseResult result,
        dmpl__InterfaceServiceProviderRequest__c request
        ){
        result.fileName = request.dmpl__FileName__c;
        result.fileTitle = request.dmpl__FileTitle__c;
        String timeStampString = DateTime.now().format('yyyyMMddhhmm');
        result.fileName = result.fileName.replace('{!timeStamp}', timeStampString);
        result.fileTitle = result.fileTitle.replace('{!timeStamp}', timeStampString);
    }

    @testVisible
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

    @testVisible
    private SObject executeRequestSOQL(
        dmpl__InterfaceServiceProviderRequest__c request, 
        Id recordId)
    {
        Id partnerAccountId = tsProvider.dmpl__PartnerAccountId__c;
        Id branchId = tsProvider.dmpl__BranchId__c;
        if(String.isNotEmpty(request.dmpl__RequestSOQL__c)){
            return Database.query(request.dmpl__RequestSOQL__c);
        }
        return null;
    }

    @testVisible
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

    private void updateLastExecutedTimeStamp(
        dmpl__InterfaceServiceProviderRequest__c request, 
        FileResponseResult result,
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