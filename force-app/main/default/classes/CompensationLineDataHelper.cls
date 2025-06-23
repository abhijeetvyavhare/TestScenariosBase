public with sharing class CompensationLineDataHelper {
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