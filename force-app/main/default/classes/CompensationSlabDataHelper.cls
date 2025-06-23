public with sharing class CompensationSlabDataHelper {
    public static dmpl__IncentiveCompensationSlab__c createCompensationSlab(
        Id incentivePlanId,
        Id incentivePeriodId,
        Decimal fromPercentage,
        Decimal toPercentage,
        String compensationType,
        Decimal incentiveFixedAmount,
        Integer sequenceNumber
    ) {
        return (dmpl__IncentiveCompensationSlab__c) TestFactory.createSObject(
            new dmpl__IncentiveCompensationSlab__c(
                dmpl__IncentivePlanId__c = incentivePlanId,
                dmpl__IncentivePeriodId__c = incentivePeriodId,
                dmpl__FromPercentage__c = fromPercentage,
                dmpl__ToPercentage__c = toPercentage,
                dmpl__CompensationType__c = compensationType,
                dmpl__IncentiveFixedAmount__c = incentiveFixedAmount,
                dmpl__SequenceNumber__c = sequenceNumber
            ),
            'CompensationSlabDefaults',
            true
        );
    }

    public static dmpl__IncentiveCompensationSlab__c getCompensationSlab() {
        return [
            SELECT Id, dmpl__IncentivePlanId__c, dmpl__IncentivePeriodId__c, dmpl__FromPercentage__c, dmpl__ToPercentage__c,
                   dmpl__CompensationType__c, dmpl__IncentiveFixedAmount__c, dmpl__SequenceNumber__c
            FROM dmpl__IncentiveCompensationSlab__c
            LIMIT 1
        ];
    }

    public static dmpl__IncentiveCompensationSlab__c getCompensationSlab(Id slabId) {
        return [
            SELECT Id, dmpl__IncentivePlanId__c, dmpl__IncentivePeriodId__c, dmpl__FromPercentage__c, dmpl__ToPercentage__c,
                   dmpl__CompensationType__c, dmpl__IncentiveFixedAmount__c, dmpl__SequenceNumber__c
            FROM dmpl__IncentiveCompensationSlab__c
            WHERE Id = :slabId
            LIMIT 1
        ];
    }

    public static dmpl__IncentiveCompensationSlab__c updateCompensationSlab(dmpl__IncentiveCompensationSlab__c slab, Decimal newFixedAmount) {
        slab.dmpl__IncentiveFixedAmount__c = newFixedAmount;
        update slab;
        return getCompensationSlab(slab.Id);
    }

    public static Integer deleteCompensationSlab(dmpl__IncentiveCompensationSlab__c slab) {
        Id slabId = slab.Id;
        delete slab;
        Integer count = 0;
        try {
            count = [SELECT COUNT() FROM dmpl__IncentiveCompensationSlab__c WHERE Id = :slabId];
        } catch (Exception e) {
            count = 0;
        }
        return count;
    }
}