@isTest
public with sharing class GLAccountDataHelper {
    public static dmpl__GLAccount__c createGLAccount(Account partnerAccount, dmpl__Branch__c branch, dmpl__AccountGroup__c accGroup){
        return (dmpl__GLAccount__c) TestFactory.createSObject(
            new dmpl__GLAccount__c(
                dmpl__PartnerAccountId__c = partnerAccount.Id,
                dmpl__BranchId__c = branch.Id,
                dmpl__AccountGroupId__c = accGroup.Id
            ),
            'GLAccountDefaults',
            true
        );
    }

    public static dmpl__GLAccount__c getGLAccount() {
        return [
            SELECT Id, Name,
                dmpl__AccountNumber__c,
                dmpl__AccountType__c,
                dmpl__BranchId__c,
                dmpl__Currency__c,
                dmpl__Description__c,
                dmpl__ExternalId__c,
                dmpl__IsActive__c,
                dmpl__IsSystem__c,
                dmpl__ItemGroupId__c,
                dmpl__PartnerAccountId__c,
                dmpl__AccountGroupId__c,
                dmpl__TaxType__c
            FROM dmpl__GLAccount__c
            LIMIT 1
        ];
    }
}