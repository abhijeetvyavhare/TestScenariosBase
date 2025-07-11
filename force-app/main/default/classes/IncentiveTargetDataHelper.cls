public with sharing class IncentiveTargetDataHelper {
    public static dmpl__IncentivePlan__c createIncentivePlan() {
        return (dmpl__IncentivePlan__c) TestFactory.createSObject(
            new dmpl__IncentivePlan__c(Name = 'Test Plan'),
            'IncentivePlanDefaults',
            true
        );
    }

    public static dmpl__IncentivePeriod__c createIncentivePeriod(Id incentivePlanId) {
        return (dmpl__IncentivePeriod__c) TestFactory.createSObject(
            new dmpl__IncentivePeriod__c(
                Name = 'Test Period',
                dmpl__IncentivePlanId__c = incentivePlanId
            ),
            'IncentivePeriodDefaults',
            true
        );
    }

    public static dmpl__IncentiveTarget__c createIncentiveTarget(
        Id incentivePlanId,
        Id incentivePeriodId,
        Id itemId,
        Id skuId,
        Decimal value,
        String targetType,
        String targetValueType
    ) {
        return (dmpl__IncentiveTarget__c) TestFactory.createSObject(
            new dmpl__IncentiveTarget__c(
                dmpl__IncentivePlanId__c = incentivePlanId,
                dmpl__IncentivePeriodId__c = incentivePeriodId,
                dmpl__ItemId__c = itemId,
                dmpl__SKUId__c = skuId,
                dmpl__Value__c = value,
                dmpl__TargetType__c = targetType,
                dmpl__TargetValueType__c = targetValueType
            ),
            'IncentiveTargetDefaults',
            true
        );
    }

    public static dmpl__IncentiveTarget__c createIncentiveTarget(
        dmpl__IncentivePlan__c incentivePlan,
        dmpl__KPIConfiguration__c kpiConfig,
        dmpl__item__c item,
        Decimal value,
        dmpl__SKU__c sku
    ) {
        return (dmpl__IncentiveTarget__c) TestFactory.createSObject(
            new dmpl__IncentiveTarget__c(
                dmpl__IncentivePlanId__c = incentivePlan != null ? incentivePlan.Id : null,
                dmpl__KPIConfigurationId__c = kpiConfig != null ? kpiConfig.Id : null,
                dmpl__ItemId__c = item != null ? item.Id : null,
                dmpl__Value__c = value != null ? value : null,
                dmpl__SKUId__c = sku != null ? sku.Id : null
                
            ),
            //'IncentiveTargetDefaults',
            true
        );
    }


    public static dmpl__IncentiveTarget__c getIncentiveTarget() {
        return [
            SELECT 
                Id, 
                dmpl__IncentivePlanId__c, 
                dmpl__IncentivePeriodId__c, 
                dmpl__ItemId__c, 
                dmpl__SKUId__c,
                dmpl__Value__c, 
                dmpl__TargetType__c, 
                dmpl__TargetValueType__c
            FROM dmpl__IncentiveTarget__c
            LIMIT 1
        ];
    }

    public static dmpl__IncentiveTarget__c getIncentiveTarget(Id targetId) {
        return [
            SELECT 
                Id, 
                dmpl__IncentivePlanId__c, 
                dmpl__IncentivePeriodId__c, 
                dmpl__ItemId__c, 
                dmpl__SKUId__c,
                dmpl__Value__c, 
                dmpl__TargetType__c, 
                dmpl__TargetValueType__c
            FROM dmpl__IncentiveTarget__c
            WHERE Id = :targetId
            LIMIT 1
        ];
    }

    public static dmpl__IncentiveResource__c createIncentiveResource(Id incentivePlanId) {
        return (dmpl__IncentiveResource__c) TestFactory.createSObject(
            new dmpl__IncentiveResource__c(Name = 'Test Resource',
                dmpl__IncentivePlanId__c = incentivePlanId
            ),
            'IncentiveResourceDefaults',
            true
        );
    }

    public static dmpl__IncentiveTarget__c updateIncentiveTarget(dmpl__IncentiveTarget__c target, Decimal newValue) {
        target.dmpl__Value__c = newValue;
        update target;
        return getIncentiveTarget(target.Id);
    }

    public static Integer deleteIncentiveTarget(dmpl__IncentiveTarget__c target) {
        Id targetId = target.Id;
        delete target;
        return [
            SELECT COUNT() FROM dmpl__IncentiveTarget__c WHERE Id = :targetId
        ];
    }

    public static dmpl__IncentiveResourceTarget__c createIncentiveResourceTarget(
        Id incentiveTargetId,
        Id incentivePeriodId,
        Id incentiveResourceId,
        Id kpiConfigId,
        Decimal value
    ) {
        return (dmpl__IncentiveResourceTarget__c) TestFactory.createSObject(
            new dmpl__IncentiveResourceTarget__c(
                dmpl__IncentiveTargetId__c = incentiveTargetId,
                dmpl__IncentivePeriodId__c = incentivePeriodId,
                dmpl__IncentiveResourceId__c = incentiveResourceId,
                dmpl__KPIConfigurationId__c = kpiConfigId,
                dmpl__Value__c = value
            ),
            'IncentiveResourceTargetDefaults',
            true
        );
    }

    public static dmpl__IncentiveResourceTarget__c createIncentiveResourceTarget(
        dmpl__IncentiveTarget__c incentiveTarget,
        dmpl__KPIConfiguration__c kpiConfig,
        Decimal value,
        dmpl__IncentiveResource__c incentiveResource
        
    ) {
        return (dmpl__IncentiveResourceTarget__c) TestFactory.createSObject(
            new dmpl__IncentiveResourceTarget__c(
                dmpl__IncentiveTargetId__c = incentiveTarget != null ? incentiveTarget.Id : null,
                dmpl__KPIConfigurationId__c = kpiConfig != null ? kpiConfig.Id : null,
                dmpl__Value__c = value != null ? value : null,
                dmpl__IncentiveResourceId__c = incentiveResource != null ? incentiveResource.Id : null
            ),
            //'IncentiveResourceTargetDefaults',
            true
        );
    }


    public static dmpl__IncentiveResourceTarget__c getIncentiveResourceTarget() {
        return [
            SELECT 
                Id, 
                dmpl__IncentiveTargetId__c, 
                dmpl__IncentivePeriodId__c, 
                dmpl__IncentiveResourceId__c, 
                dmpl__KPIConfigurationId__c, 
                dmpl__Value__c
            FROM dmpl__IncentiveResourceTarget__c
            LIMIT 1
        ];
    }

    public static dmpl__IncentiveResourceTarget__c getIncentiveResourceTarget(Id resourceTargetId) {
        return [
            SELECT 
                Id, 
                dmpl__IncentiveTargetId__c, 
                dmpl__IncentivePeriodId__c, 
                dmpl__IncentiveResourceId__c, 
                dmpl__KPIConfigurationId__c, 
                dmpl__Value__c
            FROM dmpl__IncentiveResourceTarget__c
            WHERE Id = :resourceTargetId
            LIMIT 1
        ];
    }

    public static dmpl__IncentiveResourceTarget__c updateIncentiveResourceTarget(dmpl__IncentiveResourceTarget__c resourceTarget, Decimal newValue) {
        resourceTarget.dmpl__Value__c = newValue;
        update resourceTarget;
        return getIncentiveResourceTarget(resourceTarget.Id);
    }

    public static Integer deleteIncentiveResourceTarget(dmpl__IncentiveResourceTarget__c resourceTarget) {
        Id resourceTargetId = resourceTarget.Id;
        delete resourceTarget;
        return [
            SELECT COUNT() FROM dmpl__IncentiveResourceTarget__c WHERE Id = :resourceTargetId
        ];
    }
}