@isTest
private class LeaveEntitlement_Test {

    static testMethod void testValidateResource() {
        Account partnerAccount = new Account(Name = 'Partner-Test-Account',
                                             dmpl__LastName__c = 'Sale Order',
                                             dmpl__IsPartnerAccount__c = True, 
                                             dmpl__IsActive__c = true);
        insert partnerAccount;
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__LastName__c = 'Sale Order',
                                              dmpl__IsCustomerAccount__c = True,
                                              dmpl__IsActive__c = true);
        insert customerAccount;
        
        List<dmpl__Branch__c> branch = new List<dmpl__Branch__c>();
        branch.Add(new dmpl__Branch__c(dmpl__PartnerAccountId__c =partnerAccount.Id,
                                      Name = 'Test-Branch',
                                      dmpl__IsActive__c = true,
                                      dmpl__MarketingName__c = 'Hero Electric',
                                      dmpl__Website__c = 'www.dealermatix.com',
                                      dmpl__Email__c = 'Dealer@Outlook.com',
                                      dmpl__MobileNumber__c = 99,
                                      //dmpl__BusinessHoursId__c = business.Id,
                                      dmpl__Phone__c = '8888888888',
                                      dmpl__AllowSales__c = true,
                                      dmpl__AllowService__c = true,
                                      dmpl__AllowPurchase__c = true,
                                      dmpl__AllowInventory__c = true,
                                      dmpl__IsHomeDeliveryAvailable__c = true,
                                      dmpl__IsPickupDropAvailable__c = true,
                                      dmpl__SalesPhone__c = '7777777777',
                                      dmpl__ServiceEmail__c = 'Customer@Outlook.com'));
        insert branch;
        
        List<dmpl__Resource__c> resource = new List<dmpl__Resource__c>();
        //	Account partnerAccount = [Select Id,Name From Account LIMIT 1];
        //dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        resource.add(new dmpl__Resource__c(Name = 'Test - Resource2',
                                           dmpl__ResourceType__c = 'Service Advisor',
                                           dmpl__IsActive__c = true,
                                           dmpl__Phone__c = '9999999999',
                                           dmpl__DefaultPartnerAccountId__c = partnerAccount.Id,
                                           dmpl__DefaultBranchId__c = branch[0].Id
                                          ));
        insert resource;
        
        List<dmpl__PartnerResource__c> partnerResources = new List<dmpl__PartnerResource__c>();
        partnerResources.Add(new dmpl__PartnerResource__c(dmpl__PartnerAccountId__c =partnerAccount.Id,
                                    dmpl__BranchId__c= branch[0].Id,
                                    dmpl__ResourceId__c= resource[0].Id,               
                                    dmpl__RuleSuccessCriteria__c='All Rules Are Met',
                                    dmpl__AssignmentSequenceNumber__c=12));
        insert partnerResources;
        
        dmpl__ResourceGroup__c groupName = new dmpl__ResourceGroup__c(
            Name = 'Test'
        );
        insert groupName;
        dmpl__ResourceGroupMember__c member = new dmpl__ResourceGroupMember__c(
            dmpl__ResourceId__c = resource[0].id,
            dmpl__ResourceGroupId__c = groupName.Id
        );
        insert member;
        dmpl__LeaveType__c type = new dmpl__LeaveType__c(
            Name = 'Test'
        );
        insert type;
        dmpl__LeaveEntitlement__c entitlement = new dmpl__LeaveEntitlement__c(
            dmpl__LeaveTypeId__c = type.id,
            dmpl__ResourceId__c = resource[0].Id,
            dmpl__ResourceGroupId__c = groupName.Id,
            dmpl__FixedCount__c = 5
        );
        insert entitlement;
    }
}