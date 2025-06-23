public with sharing class ResourceService extends MetadataService {

    /************************************************************************************************
     * Public Scope Constants
     ************************************************************************************************/

    public static final String OBJECT_RESOURCE = 'dmpl__Resource__c';
    public static final String OBJECT_PARTNER_RESOURCE = 'dmpl__PartnerResource__c';
    
    public static final String FIELD_RESOURCE_DEFAULT_PARTNER_ACCOUNT_ID = 'dmpl__DefaultPartnerAccountId__c';
    public static final String FIELD_RESOURCE_DEFAULT_BRANCH_ID = 'dmpl__DefaultBranchId__c';
    public static final String FIELD_PARTNER_RESOURCE_RESOURCE_ID = 'dmpl__ResourceId__c';

    /************************************************************************************************
     * Public Scope Functions
     ************************************************************************************************/

    public ResourceService(){
        super(OBJECT_RESOURCE);
    }
    
    public void validateResource(
        String resourceFieldApiName, 
        List<SObject> newEntries){
            if(!OrgSettingHelper.authoriseResource()){
                return;
            }
            List<Id> resourceIds = DocumentHelper.extractIds(
                newEntries, 
                resourceFieldApiName);
            if(resourceIds.size() == 0){
                return;
            }
            List<dmpl__PartnerResource__c> authorisedResources = queryPartnerResources(
                resourceIds, 
                CollectionHelper.extractIds(
                    newEntries, 
                    MetadataService.FIELD_PARTNER_ACCOUNT_ID),
                CollectionHelper.extractIds(
                    newEntries, 
                    MetadataService.FIELD_BRANCH_ID));
            for(SObject lineEntry : newEntries){
                List<dmpl__PartnerResource__c> theResources = CollectionHelper.getObjects(
                    authorisedResources,
                    FIELD_PARTNER_RESOURCE_RESOURCE_ID,
                    (Id)lineEntry.get(resourceFieldApiName));
                if(!doesPartnerAccountExists(
                    theResources, 
                    (Id)lineEntry.get(MetadataService.FIELD_PARTNER_ACCOUNT_ID),
                    (Date)lineEntry.get(MetadataService.FIELD_DOCUMENT_DATE))){
                        lineEntry.addError(
                            String.format(
                                String.valueOf(System.Label.UnAuthorised_ResourceNotValidForPartnerAccount),
                                new List<String>{
                                    (Id)lineEntry.get(resourceFieldApiName),
                                    (Id)lineEntry.get(MetadataService.FIELD_PARTNER_ACCOUNT_ID)
                                }));
                }
                if(!doesBranchExists(
                    theResources, 
                    (Id)lineEntry.get(MetadataService.FIELD_BRANCH_ID),
                    (Date)lineEntry.get(MetadataService.FIELD_DOCUMENT_DATE))){
                        lineEntry.addError(
                            String.format(
                                String.valueOf(System.Label.UnAuthorised_ResourceNotValidForBranch),
                                new List<String>{
                                    (Id)lineEntry.get(resourceFieldApiName),
                                    (Id)lineEntry.get(MetadataService.FIELD_BRANCH_ID)
                                }));
                }               
            }
        }

    public void validateDefaultPartnerAndBranch(
        List<dmpl__Resource__c> newEntries){
        if(!OrgSettingHelper.authoriseResource()){
            return;
        }
        List<dmpl__PartnerResource__c> authorisedResources = queryPartnerResources(
            CollectionHelper.extractIds(newEntries),
            CollectionHelper.extractIds(
                newEntries, 
                FIELD_RESOURCE_DEFAULT_PARTNER_ACCOUNT_ID),
            CollectionHelper.extractIds(
                newEntries, 
                FIELD_RESOURCE_DEFAULT_BRANCH_ID));
            for(dmpl__Resource__c resource : newEntries){
                List<dmpl__PartnerResource__c> theResources = CollectionHelper.getObjects(
                    authorisedResources,
                    FIELD_PARTNER_RESOURCE_RESOURCE_ID,
                    resource.Id);
                    if(!doesPartnerAccountExists(
                        theResources, 
                        resource.dmpl__DefaultPartnerAccountId__c)){
                            resource.addError(
                                String.format(
                                    String.valueOf(System.Label.UnAuthorised_ResourceNotValidForPartnerAccount),
                                    new List<String>{
                                        resource.Name,
                                        resource.dmpl__DefaultPartnerAccountId__c
                                    }));
                    }
                    if(!doesBranchExists(
                        theResources, 
                        resource.dmpl__DefaultBranchId__c)){
                            resource.addError(
                                String.format(
                                    String.valueOf(System.Label.UnAuthorised_ResourceNotValidForBranch),
                                    new List<String>{
                                        resource.Name,
                                        resource.dmpl__DefaultBranchId__c
                                    }));
                    }               
            }
    }

    /************************************************************************************************
     * Private Scope Functions
     ************************************************************************************************/

    @testVisible
    private Boolean doesPartnerAccountExists(
        List<dmpl__PartnerResource__c> authorisedResources,
        Id partnerAccountId,
        Date asOnDate){
            if(authorisedResources == null){
                return false;
            }
            if(partnerAccountId == null){
                return true;
            }
            if(asOnDate == null){
                asOnDate = Date.today();
            }
            for(dmpl__PartnerResource__c partnerResource : authorisedResources){
                if(!partnerResource.dmpl__ResourceId__r.dmpl__IsActive__c){
                    return false;
                }
                if((partnerResource.dmpl__FromDate__c <= asOnDate 
                        || partnerResource.dmpl__FromDate__c == null)
                    && (partnerResource.dmpl__ToDate__c >= asOnDate 
                        || partnerResource.dmpl__ToDate__c == null)
                    && (partnerResource.dmpl__PartnerAccountId__c == partnerAccountId 
                        || partnerResource.dmpl__PartnerAccountId__c == null)){
                        return true;
                    }
            }
            return false;
        }

    @testVisible
    private Boolean doesBranchExists(
        List<dmpl__PartnerResource__c> authorisedResources,
        Id branchId,
        Date asOnDate){
            if(authorisedResources == null){
                return false;
            }
            if(branchId == null){
                return true;
            }
            if(asOnDate == null){
                asOnDate = Date.today();
            }
            for(dmpl__PartnerResource__c partnerResource : authorisedResources){
                if(!partnerResource.dmpl__ResourceId__r.dmpl__IsActive__c){
                    return false;
                }
                if((partnerResource.dmpl__FromDate__c <= asOnDate 
                        || partnerResource.dmpl__FromDate__c == null)
                    && (partnerResource.dmpl__ToDate__c >= asOnDate 
                        || partnerResource.dmpl__ToDate__c == null)
                    && (partnerResource.dmpl__BranchId__c == branchId 
                        || partnerResource.dmpl__BranchId__c == null)){
                        return true;
                    }
            }
            return false;
        }

    @testVisible
    private Boolean doesPartnerAccountExists(
        List<dmpl__PartnerResource__c> authorisedResources,
        Id partnerAccountId){
            if(authorisedResources == null){
                return false;
            }
            if(partnerAccountId == null){
                return true;
            }
            for(dmpl__PartnerResource__c partnerResource : authorisedResources){
                if(!partnerResource.dmpl__ResourceId__r.dmpl__IsActive__c){
                    return false;
                }
                if(partnerResource.dmpl__PartnerAccountId__c == partnerAccountId 
                    || partnerResource.dmpl__PartnerAccountId__c == null){
                        return true;
                    }
            }
            return false;
        }

    @TestVisible
    private Boolean doesBranchExists(
        List<dmpl__PartnerResource__c> authorisedResources,
        Id branchId){
            if(authorisedResources == null){
                return false;
            }
            if(branchId == null){
                return true;
            }
            for(dmpl__PartnerResource__c partnerResource : authorisedResources){
                if(!partnerResource.dmpl__ResourceId__r.dmpl__IsActive__c){
                    return false;
                }
                if(partnerResource.dmpl__BranchId__c == branchId 
                    || partnerResource.dmpl__BranchId__c == null){
                        return true;
                    }
            }
            return false;
        }

    

    /************************************************************************************************
     * Private Scope Queries
     ************************************************************************************************/
	@TestVisible
    private List<dmpl__PartnerResource__c> queryPartnerResources(
        List<Id> resourceIds, 
        List<Id> partnerAccountIds, 
        List<Id> branchIds){
        return [SELECT
            dmpl__ResourceId__c,
            dmpl__ResourceId__r.dmpl__IsActive__c,
            dmpl__PartnerAccountId__c,
            dmpl__BranchId__c,
            dmpl__FromDate__c,
            dmpl__ToDate__c,
            Id,
            Name
        FROM
            dmpl__PartnerResource__c
        WHERE
            dmpl__ResourceId__c IN : resourceIds
            AND (dmpl__PartnerAccountId__c IN : partnerAccountIds OR dmpl__PartnerAccountId__c = null)
            AND (dmpl__BranchId__c IN : branchIds OR dmpl__BranchId__c = null)];
    }
}