public with sharing class CompensationDataHelper {
    public static dmpl__IncentiveCompensation__c createCompensation(
        Account account,
    dmpl__Branch__c branch,
    Account partnerAccount,
    Id incentivePeriodId,
    Id incentivePlanId,
    String status
    ) {
        return (dmpl__IncentiveCompensation__c) TestFactory.createSObject(
            new dmpl__IncentiveCompensation__c(
            dmpl__AccountId__c = account != null ? account.Id : null,
        dmpl__BranchId__c = branch != null ? branch.Id : null,
        dmpl__PartnerAccountId__c = partnerAccount != null ? partnerAccount.Id : null,
        dmpl__IncentivePeriodId__c = incentivePeriodId,
        dmpl__IncentivePlanId__c = incentivePlanId,
        dmpl__Status__c = status
            ),
        'CompensationDefaults',
        true
            );
    }
    
    public static dmpl__IncentiveCompensation__c getCompensation() {
        return [
            SELECT Id, Name, dmpl__AccountId__c, dmpl__BranchId__c, dmpl__PartnerAccountId__c, dmpl__IncentivePeriodId__c, dmpl__IncentivePlanId__c, dmpl__Status__c, dmpl__TotalIncentiveAmount__c
            FROM dmpl__IncentiveCompensation__c
            LIMIT 1
        ];
    }
    
    public static dmpl__IncentiveCompensation__c getCompensation(Id compensationId) {
        return [
            SELECT Id, Name, dmpl__AccountId__c, dmpl__BranchId__c, dmpl__PartnerAccountId__c, dmpl__IncentivePeriodId__c, dmpl__IncentivePlanId__c, dmpl__Status__c, dmpl__TotalIncentiveAmount__c
            FROM dmpl__IncentiveCompensation__c
            WHERE Id = :compensationId
            LIMIT 1
        ];
    }
    
    public static dmpl__IncentiveCompensation__c updateCompensation(dmpl__IncentiveCompensation__c compensation, String newStatus) {
        compensation.dmpl__Status__c = newStatus;
        update compensation;
        return getCompensation(compensation.Id);
    }
    
    public static Boolean deleteCompensation(dmpl__IncentiveCompensation__c compensation) {
        Id compensationId = compensation.Id;
        delete compensation;
        try {
            dmpl__IncentiveCompensation__c deletedComp = getCompensation(compensationId);
            return deletedComp == null;
        } catch (Exception e) {
            return true;
        }
    }
    
    public static dmpl__IncentiveCompensationLine__c createCompensationLine(
        Id compensationId,
        Id incentivePlanId,
        Id incentivePeriodId,
        Id itemId,
        Id skuId,
        Decimal incentiveAmount,
        String status
        ) {
        return (dmpl__IncentiveCompensationLine__c) TestFactory.createSObject(
            new dmpl__IncentiveCompensationLine__c(
            dmpl__CompensationId__c = compensationId,
        dmpl__IncentivePlanId__c = incentivePlanId,
        dmpl__IncentivePeriodId__c = incentivePeriodId,
        dmpl__ItemId__c = itemId,
        dmpl__SKUId__c = skuId,
        dmpl__IncentiveAmount__c = incentiveAmount,
        dmpl__Status__c = status
            ),
        'CompensationLineDefaults',
        true
            );
    }
    
    public static dmpl__IncentiveCompensationLine__c getCompensationLine() {
        return [
            SELECT Id, dmpl__CompensationId__c, dmpl__IncentivePlanId__c, dmpl__IncentivePeriodId__c, dmpl__ItemId__c, dmpl__SKUId__c,
                   dmpl__IncentiveAmount__c, dmpl__Status__c
            FROM dmpl__IncentiveCompensationLine__c
            LIMIT 1
        ];
    }
    
    public static dmpl__IncentiveCompensationLine__c getCompensationLine(Id lineId) {
        return [
            SELECT Id, dmpl__CompensationId__c, dmpl__IncentivePlanId__c, dmpl__IncentivePeriodId__c, dmpl__ItemId__c, dmpl__SKUId__c,
                   dmpl__IncentiveAmount__c, dmpl__Status__c
            FROM dmpl__IncentiveCompensationLine__c
            WHERE Id = :lineId
            LIMIT 1
        ];
    }
    
    public static dmpl__IncentiveCompensationLine__c updateCompensationLine(dmpl__IncentiveCompensationLine__c line, Decimal newAmount) {
        line.dmpl__IncentiveAmount__c = newAmount;
        update line;
        return getCompensationLine(line.Id);
    }
    
    public static Integer deleteCompensationLine(dmpl__IncentiveCompensationLine__c line) {
        Id lineId = line.Id;
        delete line;
        Integer count = 0;
        try {
            count = [SELECT COUNT() FROM dmpl__IncentiveCompensationLine__c WHERE Id = :lineId];
        } catch (Exception e) {
            count = 0;
        }
        return count;
    }
}