@isTest
public class ServiceLeadTestDataHelpers {
    public static dmpl__ServiceLead__c createServiceLead(dmpl__Branch__c branch,Account customerAccount,dmpl__Resource__c resource) {
        return  (dmpl__ServiceLead__c)TestFactory.createSObject(
            new dmpl__ServiceLead__c(
                dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                dmpl__AccountId__c=customerAccount.Id,
                dmpl__BranchId__c= branch.Id,
                dmpl__ResourceId__c=resource.Id
            ),
            'ServiceLeadDefaults',
            true
        );
    }

    public static dmpl__ServiceLead__c getServiceLead(){
        return [
            SELECT 
                dmpl__AccountName__c,
                dmpl__ContactName__c,
                dmpl__LeadRating__c,
                dmpl__LeadSource__c,
                dmpl__ReminderOffsetNumber__c,
                dmpl__Status__c,
                dmpl__LeadType__c,
                dmpl__PartnerAccountId__c,
                dmpl__AccountId__c,
                dmpl__BranchId__c,
                dmpl__ResourceId__c,
                dmpl__DocumentDate__c 
            FROM dmpl__ServiceLead__c 
            LIMIT 1
        ];
    }

    public static dmpl__ServiceLead__c getServiceLead(Id serviceLeadId){
        return [
            SELECT 
                dmpl__AccountName__c,
                dmpl__ContactName__c,
                dmpl__LeadRating__c,
                dmpl__LeadSource__c,
                dmpl__ReminderOffsetNumber__c,
                dmpl__Status__c,
                dmpl__LeadType__c,
                dmpl__PartnerAccountId__c,
                dmpl__AccountId__c,
                dmpl__BranchId__c,
                dmpl__ResourceId__c,
                dmpl__DocumentDate__c 
            FROM dmpl__ServiceLead__c
            WHERE Id = :serviceLeadId 
            LIMIT 1
        ];
    }
public static dmpl__ServiceLead__c createServiceLeadbyId(
    Account partnerAccount,
    dmpl__Branch__c branch,
    Account customerAccount,
    Asset asset,
    dmpl__Case__c caseRecord,
    dmpl__ServiceCampaign__c campaign,
    String status,
    Date documentDate
) {
    return (dmpl__ServiceLead__c) TestFactory.createSObject(
        new dmpl__ServiceLead__c(
            dmpl__PartnerAccountId__c = partnerAccount != null ? partnerAccount.Id : null,
            dmpl__BranchId__c = branch != null ? branch.Id : null,
            dmpl__AccountId__c = customerAccount != null ? customerAccount.Id : null,
            dmpl__AssetId__c = asset != null ? asset.Id : null,
            dmpl__CaseId__c = caseRecord != null ? caseRecord.Id : null,
            dmpl__ServiceCampaignId__c = campaign != null ? campaign.Id : null,
            dmpl__Status__c = status != null ? status : 'Draft',
            dmpl__DocumentDate__c = documentDate != null ? documentDate : Date.today()
        ),
        'ServiceLeadDefaults',
        true
    );
}

public static dmpl__ServiceLead__c getServiceLeadbyId(Id id) {
    return [
        SELECT Id,
               Name,
               dmpl__PartnerAccountId__c,
               dmpl__BranchId__c,
               dmpl__AccountId__c,
               dmpl__AssetId__c,
               dmpl__CaseId__c,
               dmpl__ServiceCampaignId__c,
               dmpl__Status__c,
               dmpl__DocumentDate__c
        FROM dmpl__ServiceLead__c
        WHERE Id = :id
        LIMIT 1
    ];
}

}