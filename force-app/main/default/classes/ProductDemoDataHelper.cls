@isTest
public with sharing class ProductDemoDataHelper {
    public static dmpl__ProductDemo__c createProductDemo(Account partnerAccount,
    Account customerAccount, dmpl__Branch__c branch,
    dmpl__Resource__c resource){
        return (dmpl__ProductDemo__c) TestFactory.createSObject(
            new dmpl__ProductDemo__c(
                dmpl__PartnerAccountId__c = partnerAccount.Id,
                dmpl__AccountId__c = customerAccount.Id,
                dmpl__BranchId__c = branch.Id,
                dmpl__ResourceId__c = resource.Id,
                dmpl__DemoDate__c = Date.today()
            ),
            'ProductDemoDefaults',
            true
        );
    }
    
    public static dmpl__ProductDemo__c getProductDemo() {
        return [
            SELECT Id, Name,
                dmpl__CancellationReason__c,
                dmpl__CustomerVoice__c,
                dmpl__DemoAddress__c,
                dmpl__DemoAssetNumber__c,
                dmpl__DemoRating__c,
                dmpl__Status__c,
                dmpl__ExternalId__c,
                dmpl__IsCancelled__c,
                dmpl__IsConfirmed__c,
                dmpl__IsDemoOnsite__c,
                dmpl__KYCDocumentNumber__c,
                dmpl__Remarks__c,
                dmpl__ServiceJobType__c,
                dmpl__ServiceType__c,
                dmpl__UsageReadingEnd__c,
                dmpl__UsageReadingStart__c
            FROM dmpl__ProductDemo__c
            LIMIT 1
        ];
    }
}