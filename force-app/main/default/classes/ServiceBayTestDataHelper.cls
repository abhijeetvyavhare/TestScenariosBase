public with sharing class ServiceBayTestDataHelper {

    public static dmpl__ServiceBay__c createServiceBay(String serviceBayName,dmpl__Branch__c branch,String Type) {
        return (dmpl__ServiceBay__c) TestFactory.createSObject(
            new dmpl__ServiceBay__c(
                Name = serviceBayName,
                dmpl__BranchId__c = branch.Id,
                dmpl__ServiceBayType__c=Type),
            'ServiceBayDefaults',
            true
        );
    }
    public static dmpl__ServiceBay__c getServiceBay(Id branchId) {
        return [
            SELECT Id, Name,dmpl__ServiceBayType__c,dmpl__BranchId__c
            FROM dmpl__ServiceBay__c
            WHERE dmpl__BranchId__c=: branchId
            LIMIT 1
        ];
    }

    



}