public with sharing class IncentiveController {
   
    @AuraEnabled(cacheable = false)
    public static List<dmpl__IncentiveLine__c> getIncentiveLines(ID incentiveId)
    {
        try 
        {
            SecurityHelper.ensureCanReadFields(new string[]
            {
                'dmpl__DefinitionFilterCriteria__c',
                'dmpl__DefinitionCustomLogic__c',
                'dmpl__RewardApplicability__c'
            }, 'dmpl__IncentiveLine__c');
            SecurityHelper.ensureCanReadFields(new string[]
            {
                'dmpl__IncentiveTargetType__c',
                // 'dmpl__ConditionOperator__c',
                'dmpl__AccountId__c',
                'dmpl__AccountGroupId__c',
                'dmpl__ItemId__c',
                'dmpl__ItemGroupId__c',
                'dmpl__Value__c',
                'dmpl__SequenceNumber__c'
            }, 'dmpl__IncentiveTarget__c');
            SecurityHelper.ensureCanReadFields(new string[]
            {
                'dmpl__FromPercentage__c',
                'dmpl__ToPercentage__c',
                'dmpl__DiscountGroupId__c',
                'dmpl__IncentivePlanId__c',
                'dmpl__GiftPoints__c',
                'dmpl__Gifts__c',
                'dmpl__IncentiveAmountPerUnit__c',
                'dmpl__IncentiveFixedAmount__c',
                'dmpl__PercentageonProfit__c',
                'dmpl__TargetPercentage__c',
                'dmpl__AmountPercentage__c',
                'dmpl__CompensationType__c',
                'dmpl__SequenceNumber__c'
            }, 'dmpl__IncentiveCompensationSlab__c');


            return [Select 
            Id,
            Name,
            dmpl__Title__c,
            dmpl__DefinitionFilterCriteria__c,
            dmpl__DefinitionCustomLogic__c,
            dmpl__RewardApplicability__c,
            dmpl__RewardCustomLogic__c,
            dmpl__SequenceNumber__c,
            dmpl__UseSlabAbsoluteValue__c,
            dmpl__IncentivePlanId__c,
            dmpl__IncentivePlanId__r.Name,
            dmpl__IncentivePlanId__r.dmpl__Status__c,
            (Select 
                Id,
                Name,
                dmpl__IncentivePlanId__c,
                dmpl__IncentiveLineId__c,
                dmpl__IncentiveTargetType__c,
                // dmpl__ConditionOperator__c,
                dmpl__KPIConfigurationId__c,
                dmpl__TargetValueType__c,
                dmpl__AccountId__c,
                dmpl__AccountId__r.Name,
                dmpl__AccountGroupId__c,
                dmpl__AccountGroupId__r.Name,
                dmpl__ItemId__c,
                dmpl__ItemId__r.Name,
                dmpl__ItemGroupId__c,
                dmpl__ItemGroupId__r.Name,
                dmpl__Value__c,
                dmpl__SequenceNumber__c
            FROM
                dmpl__IncentiveTargets__r
                ORDER BY dmpl__SequenceNumber__c ASC),
            (Select 
                Id,
                Name,
                dmpl__IncentivePlanId__c,
                dmpl__IncentiveLineId__c,
                dmpl__FromPercentage__c,
                dmpl__ToPercentage__c,
                dmpl__DiscountGroupId__c,
                dmpl__GiftPoints__c,
                dmpl__Gifts__c,
                dmpl__IncentiveAmountPerUnit__c,
                dmpl__IncentiveFixedAmount__c,
                dmpl__PercentageonProfit__c,
                dmpl__TargetPercentage__c,
                dmpl__AmountPercentage__c,
                dmpl__CompensationType__c,
                dmpl__SequenceNumber__c
            FROM
                dmpl__CompensationSlabs__r
                ORDER BY dmpl__SequenceNumber__c ASC)
            FROM 
                dmpl__IncentiveLine__c 
            WHERE 
            dmpl__IncentivePlanId__c = : incentiveId
            ORDER BY dmpl__SequenceNumber__c ASC];
        } 
        catch (Exception e) 
        {
            throw new DMPLException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable = true)
    public static List<AggregateResult> getIncentiveKPI(ID incentiveId) {
        return
        [
            SELECT 
                dmpl__KPIConfigurationId__c value,
                dmpl__KPIConfigurationId__r.Name label
            FROM 
                dmpl__IncentiveTarget__c
            WHERE 
                dmpl__IncentivePlanId__c = :incentiveId
            GROUP BY 
                dmpl__KPIConfigurationId__c,
                dmpl__KPIConfigurationId__r.Name
        ];
    }

    @AuraEnabled(cacheable = true)
    public static List<dmpl__IncentivePeriod__c> getIncentivePeriods(ID incentiveId) {
        return
        [
            SELECT 
                Id,
                Name 
            FROM 
                dmpl__IncentivePeriod__c
            WHERE 
                dmpl__IncentivePlanId__c = :incentiveId
                AND dmpl__SimulationType__c = null
                Order By dmpl__DateFrom__c ASC
        ];
    }

    @AuraEnabled(cacheable = true)
    public static List<dmpl__IncentiveResource__c> getIncentiveResources(
        ID incentiveId,
        String searchKey) {
            if(searchKey == null){
                return 
                    [
                        SELECT
                            Id,
                            dmpl__ResourceId__c, 
                            Name 
                        FROM 
                            dmpl__IncentiveResource__c 
                        WHERE 
                            dmpl__IncentivePlanId__c = :incentiveId
                        LIMIT 100
                    ];
            }else {
                searchKey = '%' + searchKey + '%';
                return [
                    SELECT
                        Id,
                        dmpl__ResourceId__c, 
                        Name 
                    FROM 
                        dmpl__IncentiveResource__c 
                    WHERE 
                        dmpl__IncentivePlanId__c = :incentiveId
                        AND (Name LIKE :searchKey OR dmpl__ResourceId__r.Name LIKE :searchKey)
                    LIMIT 100
                ];
            }
    }

    @AuraEnabled(cacheable = true)
    public static List<dmpl__IncentiveResourceTarget__c> getIncentiveResourcesTargets(
        Id kpiId,
        Id incentiveId,
        String searchKey) {
            if(searchKey == null) {
                return 
                    [
                        SELECT
                            Id, 
                            dmpl__IncentiveResourceId__c,
                            dmpl__IncentivePeriodId__c,
                            dmpl__Value__c 
                        FROM 
                            dmpl__IncentiveResourceTarget__c 
                        WHERE 
                            dmpl__IncentiveTargetId__r.dmpl__IncentivePlanId__c =:incentiveId
                            AND dmpl__KPIConfigurationId__c =:kpiId
                        LIMIT 500
                    ];
            }else{
                searchKey = '%' + searchKey + '%';
                return 
                [
                    SELECT
                        Id, 
                        dmpl__IncentiveResourceId__c,
                        dmpl__IncentivePeriodId__c,
                        dmpl__Value__c 
                    FROM 
                        dmpl__IncentiveResourceTarget__c 
                    WHERE 
                        dmpl__IncentiveTargetId__r.dmpl__IncentivePlanId__c =:incentiveId
                        AND dmpl__KPIConfigurationId__c =:kpiId
                        AND (dmpl__IncentiveResourceId__r.Name LIKE :searchKey 
                            OR dmpl__IncentiveResourceId__r.dmpl__ResourceId__r.Name LIKE :searchKey)
                    LIMIT 500
                ];
            }
    }

    @AuraEnabled(cacheable = true)
    public static List<dmpl__IncentiveResourceTarget__c> getIncentiveKPITargets(
        Id resourceId,
        Id incentiveId) {
        return 
        [
            SELECT
                Id, 
                dmpl__KPIConfigurationId__c,
                dmpl__IncentivePeriodId__c,
                dmpl__Value__c 
            FROM 
                dmpl__IncentiveResourceTarget__c 
            WHERE 
                dmpl__IncentiveTargetId__r.dmpl__IncentivePlanId__c =:incentiveId
                AND dmpl__IncentiveResourceId__c =:resourceId
            LIMIT 500
        ];
    }

    @AuraEnabled(cacheable = false)
    public static String updateIncentiveResourcesTargets(
        List<Object> data) {
            List<SObject> recordsForUpdate = (List<SObject>) JSON.deserialize(
            JSON.serialize(data),
            System.Type.forName( 'List<dmpl__IncentiveResourceTarget__c>' )
        );
        
        try {
            update recordsForUpdate;
            return 'Success: records updated successfully';
        }
        catch (Exception ex) {
            ExceptionLogHelper.logException(ex);
            throw ex;
        }
    }

    @AuraEnabled(cacheable = false)
    public static Id createSimulation(
        Object recordData) {
        try {
            return IncentivePlanHelper.createSimulation((Map<Object,Object>) recordData);
        }
        catch (Exception ex) {
            ExceptionLogHelper.logException(ex);
            throw ex;
        }
    }

    @AuraEnabled(cacheable = false)
    public static Boolean processCompensation(
        Id periodId) {
        try {
            IncentiveProcessor.perfromAction(periodId);
            return true;
        }
        catch (Exception ex) {
            ExceptionLogHelper.logException(ex);
            throw ex;
        }
    }
    
    
}