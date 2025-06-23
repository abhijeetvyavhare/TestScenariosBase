@namespaceAccessible
public with sharing class InterfaceServiceProviderHelper {

    @namespaceAccessible
    public static final String PROVIDERTYPE_CUSTOMFUNCTION = 'Custom Function';
    @namespaceAccessible
    public static final String PROVIDERTYPE_CUSTOMHTTP = 'Custom Http';

    @namespaceAccessible
    public static dmpl__InterfaceServiceProviderRequest__c getRequest(
        dmpl__InterfaceServiceProvider__c tsProvider, 
        String functionName){
        for(dmpl__InterfaceServiceProviderRequest__c request : tsProvider.dmpl__InterfaceServiceProviderRequests__r){
            if(request.dmpl__Function__c == functionName
            || (request.dmpl__Function__c == InterfaceServiceProviderHelper.PROVIDERTYPE_CUSTOMFUNCTION
                && request.dmpl__CustomFunction__c == functionName)){
                    return request;
                }
        }
        return null;
    }

    @namespaceAccessible
    public static dmpl__InterfaceServiceProvider__c getProvider(
        String providerType, 
        Id partnerAccountId, 
        Id branchId){
        SecurityHelper.ensureCanReadFields(new string[]
            {
                'dmpl__NamedCredentials__c',
                'dmpl__Logging__c',
                'dmpl__PartnerAccountId__c',
                'dmpl__BranchId__c',
                'dmpl__ProviderType__c',
                'dmpl__CustomCredentialsUrl__c',
                'dmpl__CustomCredentialsToken__c',
                'dmpl__TokenExpiresAt__c',
                'dmpl__TokenRequestedAt__c',
                'dmpl__TokenValidityDuration__c',
                'dmpl__TokenBearer__c',
                'dmpl__HeaderToken__c',
                'dmpl__HeaderTokenKey__c'
            }, 'dmpl__InterfaceServiceProvider__c');
        SecurityHelper.ensureCanReadFields(new string[]
            {
                'dmpl__CustomFunction__c',
                'dmpl__EndPoint__c',
                'dmpl__Function__c',
                'dmpl__HttpHeaders__c',
                'dmpl__IsAsynchronous__c',
                'dmpl__PayloadSchema__c',
                'dmpl__ResponseSchema__c',
                'dmpl__StatusEndPoint__c',
                'dmpl__StatusPayloadSchema__c',
                'dmpl__StatusResponseSchema__c',
                'dmpl__HttpVerb__c',
                'dmpl__HttpQuery__c',
                'dmpl__SObjectApiName__c',
                'dmpl__SObjectRecordId__c',
                'dmpl__AuthenticationRequestId__c',
                'dmpl__TimeoutInMS__c',
                'dmpl__SourceDataType__c',
                'dmpl__LastExtractionTimestamp__c',
                'dmpl__FileName__c',
                'dmpl__FileTitle__c'
            }, 'dmpl__InterfaceServiceProviderRequest__c');
            
            return [
                SELECT
                    ID,
                    dmpl__NamedCredentials__c,
                    dmpl__Logging__c,
                    dmpl__PartnerAccountId__c,
                    dmpl__BranchId__c,
                    dmpl__ProviderType__c,
                    dmpl__CustomCredentialsUrl__c,
                    dmpl__CustomCredentialsToken__c,
                    dmpl__TokenExpiresAt__c,
                    dmpl__TokenRequestedAt__c,
                    dmpl__TokenValidityDuration__c,
                    dmpl__TokenBearer__c,
	                dmpl__HeaderToken__c,
	                dmpl__HeaderTokenKey__c,
                    (SELECT
                        dmpl__CustomFunction__c,
                        dmpl__EndPoint__c,
                        dmpl__Function__c,
                        dmpl__HttpHeaders__c,
                        dmpl__IsAsynchronous__c,
                        dmpl__PayloadSchema__c,
                        dmpl__ResponseSchema__c,
                        dmpl__StatusEndPoint__c,
                        dmpl__StatusPayloadSchema__c,
                        dmpl__StatusResponseSchema__c,
                        dmpl__InterfaceServiceProviderId__c,
                        dmpl__HttpVerb__c,
                        dmpl__HttpQuery__c,
                        dmpl__SObjectApiName__c,
                        dmpl__SObjectRecordId__c,
                        dmpl__RequestSOQL__c,
                        dmpl__ResponseSuccessPath__c,
                        dmpl__ResponseSuccessValue__c,
                        dmpl__ResponseSOQL__c,
                        dmpl__AuthenticationRequestId__c,
                        dmpl__TimeoutInMS__c,
                        dmpl__SourceDataType__c,
                        dmpl__LastExtractionTimestamp__c,
                        dmpl__FileName__c,
                        dmpl__FileTitle__c
                    FROM
                        dmpl__InterfaceServiceProviderRequests__r
                    )
                FROM dmpl__InterfaceServiceProvider__c
                WHERE (dmpl__PartnerAccountId__c =:partnerAccountId OR dmpl__PartnerAccountId__c = null)
                    AND (dmpl__BranchId__c =:branchId OR dmpl__BranchId__c = null)
                    AND dmpl__ProviderType__c =:providerType 
                ORDER BY dmpl__PartnerAccountId__c, dmpl__BranchId__c NULLS LAST
                LIMIT 1
            ];
        }
    
    @namespaceAccessible
    public static dmpl__InterfaceServiceProvider__c getProvider(
        Id requestId){
        SecurityHelper.ensureCanReadFields(new string[]
            {
                'dmpl__NamedCredentials__c',
                'dmpl__Logging__c',
                'dmpl__PartnerAccountId__c',
                'dmpl__BranchId__c',
                'dmpl__ProviderType__c',
                'dmpl__CustomCredentialsUrl__c',
                'dmpl__CustomCredentialsToken__c',
                'dmpl__TokenExpiresAt__c',
                'dmpl__TokenRequestedAt__c',
                'dmpl__TokenValidityDuration__c',
                'dmpl__TokenBearer__c',
                'dmpl__HeaderToken__c',
                'dmpl__HeaderTokenKey__c'
            }, 'dmpl__InterfaceServiceProvider__c');
        SecurityHelper.ensureCanReadFields(new string[]
            {
                'dmpl__CustomFunction__c',
                'dmpl__EndPoint__c',
                'dmpl__Function__c',
                'dmpl__HttpHeaders__c',
                'dmpl__IsAsynchronous__c',
                'dmpl__PayloadSchema__c',
                'dmpl__ResponseSchema__c',
                'dmpl__StatusEndPoint__c',
                'dmpl__StatusPayloadSchema__c',
                'dmpl__StatusResponseSchema__c',
                'dmpl__HttpVerb__c',
                'dmpl__HttpQuery__c',
                'dmpl__SObjectApiName__c',
                'dmpl__SObjectRecordId__c',
                'dmpl__ResponseSuccessPath__c',
                'dmpl__ResponseSuccessValue__c',
                'dmpl__ResponseSOQL__c',
                'dmpl__AuthenticationRequestId__c',
                'dmpl__TimeoutInMS__c',
                'dmpl__SourceDataType__c',
                'dmpl__LastExtractionTimestamp__c',
                'dmpl__FileName__c',
                'dmpl__FileTitle__c'
            }, 'dmpl__InterfaceServiceProviderRequest__c');
            
            return [
                SELECT
                    ID,
                    dmpl__NamedCredentials__c,
                    dmpl__Logging__c,
                    dmpl__PartnerAccountId__c,
                    dmpl__BranchId__c,
                    dmpl__ProviderType__c,
                    dmpl__CustomCredentialsUrl__c,
                    dmpl__CustomCredentialsToken__c,
                    dmpl__TokenExpiresAt__c,
                    dmpl__TokenRequestedAt__c,
                    dmpl__TokenValidityDuration__c,
                    dmpl__TokenBearer__c,
                	dmpl__HeaderToken__c,
	                dmpl__HeaderTokenKey__c,
                    (SELECT
                        dmpl__CustomFunction__c,
                        dmpl__EndPoint__c,
                        dmpl__Function__c,
                        dmpl__HttpHeaders__c,
                        dmpl__IsAsynchronous__c,
                        dmpl__PayloadSchema__c,
                        dmpl__ResponseSchema__c,
                        dmpl__StatusEndPoint__c,
                        dmpl__StatusPayloadSchema__c,
                        dmpl__StatusResponseSchema__c,
                        dmpl__InterfaceServiceProviderId__c,
                        dmpl__HttpVerb__c,
                        dmpl__HttpQuery__c,
                        dmpl__SObjectApiName__c,
                        dmpl__SObjectRecordId__c,
                        dmpl__RequestSOQL__c,
                        dmpl__ResponseSuccessPath__c,
                        dmpl__ResponseSuccessValue__c,
                        dmpl__ResponseSOQL__c,
                        dmpl__AuthenticationRequestId__c,
                        dmpl__TimeoutInMS__c,
                        dmpl__SourceDataType__c,
                        dmpl__LastExtractionTimestamp__c,
                        dmpl__FileName__c,
                        dmpl__FileTitle__c
                    FROM
                        dmpl__InterfaceServiceProviderRequests__r
                    )
                FROM dmpl__InterfaceServiceProvider__c
                WHERE Id=:requestId
                LIMIT 1
            ];
        }
}