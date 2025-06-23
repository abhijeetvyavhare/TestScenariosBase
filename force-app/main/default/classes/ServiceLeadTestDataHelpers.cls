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
}