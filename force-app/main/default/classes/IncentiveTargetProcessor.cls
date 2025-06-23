public class IncentiveTargetProcessor implements Database.Batchable<SObject> {
    public static Integer BATCH_SIZE = 100;
    private Id invokedQueueId;
    private Id incentiveTargetId;
    private Id incentivePlanId;
    private String batchQuery;

    public IncentiveTargetProcessor(String query, Id queueId, Id targetId, Id incentivePlanId) {
        system.debug('query1=>'+query);
        this.batchQuery = query;
        system.debug('this.batchQuery=>'+this.batchQuery);
        this.invokedQueueId = queueId;
        this.incentiveTargetId = targetId;
        this.incentivePlanId = incentivePlanId;
    }

    public static JobResponseResult performAction(Id recordId, Id queueId) {
        try {
            return processIncentiveTarget(recordId, queueId);
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static JobResponseResult processIncentiveTarget(Id recordId, Id queueId) {
        List<dmpl__IncentiveTarget__c> incentiveTargets = queryForIncentiveTarget(recordId);
        if(incentiveTargets.size() > 0){
            dmpl__IncentiveTarget__c target =  incentiveTargets[0];
            String query = getIncentiveResourcesQuery(target.dmpl__IncentivePlanId__c);
            system.debug('query=>'+query);
            Integer batchSize = getMaxBatchSize(target.dmpl__IncentivePlanId__c);
            Id batchId = Database.executeBatch(new IncentiveTargetProcessor(query, queueId, recordId, target.dmpl__IncentivePlanId__c), batchSize);
            return new JobResponseResult(true, null, 'Apex Batch Job Enqueued With Job Id ' + batchId);
        }else {
            return new JobResponseResult(true, null, 'No Incentive Target Found');
        }
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        try {
            InterfaceQueueHelper.addStatusUpdate(invokedQueueId, 'Starting Incentive Target Batch');
            System.debug('Starting Batch Query: ' + this.batchQuery);
            return Database.getQueryLocator(this.batchQuery);
        } catch (Exception error) {
            ExceptionLogHelper.logException(error, invokedQueueId);
            throw error;
        }
    }

    public void execute(Database.BatchableContext bc, List<SObject> scope) {
        List<dmpl__IncentiveResource__c> incentiveResources = (List<dmpl__IncentiveResource__c>) scope;
        List<dmpl__IncentiveTarget__c> incentiveTargets = queryForIncentiveTarget(incentiveTargetId);
        List<dmpl__IncentivePeriod__c> incentivePeriods = queryIncentivePeriods(incentivePlanId);
        List<dmpl__IncentiveResourceTarget__c> newIncentiveResourceTargets = new List<dmpl__IncentiveResourceTarget__c>();

        for (dmpl__IncentiveTarget__c target : incentiveTargets) {
            if (target.dmpl__TargetValueType__c == 'Resource Target' || target.dmpl__TargetValueType__c == 'Resource Target Percentage') {
                continue;
            }

            List<dmpl__IncentiveResource__c> filteredIncentiveResources = incentiveTargets.size() == 1
                ? incentiveResources
                : CollectionHelper.getObjectsByFilter(incentiveResources, 'dmpl__IncentivePlanId__c', target.dmpl__IncentivePlanId__c);

            List<dmpl__IncentivePeriod__c> filteredIncentivePeriods = incentiveTargets.size() == 1
                ? incentivePeriods
                : CollectionHelper.getObjectsByFilter(incentivePeriods, 'dmpl__IncentivePlanId__c', target.dmpl__IncentivePlanId__c);

            if (target.dmpl__IncentivePeriodId__c != null) {
                filteredIncentivePeriods = CollectionHelper.getObjects(incentivePeriods, 'Id', target.dmpl__IncentivePeriodId__c);
            }

            Integer resourceCount = filteredIncentiveResources.size();
            Integer periodCount = filteredIncentivePeriods.size();
            Decimal targetValue = target.dmpl__Value__c == null ? 0 : target.dmpl__Value__c;
            Decimal periodValue = periodCount > 0 ? targetValue / periodCount : targetValue;
            Decimal resourceValue = resourceCount > 0 ? targetValue / resourceCount : targetValue;

            for (dmpl__IncentiveResource__c resource : filteredIncentiveResources) {
                for (dmpl__IncentivePeriod__c period : filteredIncentivePeriods) {
                    dmpl__IncentiveResourceTarget__c resourceTarget = new dmpl__IncentiveResourceTarget__c(
                        dmpl__IncentiveResourceId__c = resource.Id,
                        dmpl__IncentiveTargetId__c = target.Id,
                        dmpl__IncentivePeriodId__c = period.Id,
                        dmpl__KPIConfigurationId__c = target.dmpl__KPIConfigurationId__c
                    );

                    if (target.dmpl__TargetValueType__c == 'Fixed Value') {
                        resourceTarget.dmpl__Value__c = targetValue;
                    } else if (target.dmpl__TargetValueType__c == 'Value Across Periods') {
                        resourceTarget.dmpl__Value__c = periodValue;
                    } else if (target.dmpl__TargetValueType__c == 'Value Across Resources') {
                        resourceTarget.dmpl__Value__c = resourceValue;
                    }

                    newIncentiveResourceTargets.add(resourceTarget);
                }
            }
        }

        SecurityHelper.ensureCanCreateFields(new List<String> {
            'dmpl__Value__c',
            'dmpl__IncentiveResourceId__c',
            'dmpl__IncentiveTargetId__c'
        }, 'dmpl__IncentiveResourceTarget__c');

        if (!newIncentiveResourceTargets.isEmpty()) {
            insert newIncentiveResourceTargets;
        }
    }

    public void finish(Database.BatchableContext bc) {
        try {
            InterfaceQueueHelper.addStatusUpdate(invokedQueueId, 'Incentive Target Batch Completed');
        } catch (Exception error) {
            ExceptionLogHelper.logException(error, invokedQueueId);
        }
    }

    private static Integer getMaxBatchSize(Id incentivePlanId) {
        List<AggregateResult> results = [SELECT COUNT(Id) FROM dmpl__IncentivePeriod__c WHERE dmpl__IncentivePlanId__c = :incentivePlanId];
        if(results.size() > 0){
            Integer periodCount = (Integer) results[0].get('expr0');
            if(periodCount > 100){
                return 25;
            }else if(periodCount > 50){
                return 50;
            }else {
                return BATCH_SIZE;
            }
        }else {
            return BATCH_SIZE;
        }
    }

    private static List<dmpl__IncentiveTarget__c> queryForIncentiveTarget(Id incentiveTargetId) {
        return [SELECT 
                dmpl__AccountGroupId__c,
                dmpl__AccountId__c, 
                dmpl__CustomKPIFieldName__c, 
                dmpl__ExternalId__c, 
                dmpl__FinancerId__c, 
                dmpl__FinancerSchemeId__c, 
                dmpl__IgnoreSplitting__c, 
                dmpl__IncentiveLineId__c, 
                dmpl__IncentivePeriodId__c, 
                dmpl__IncentivePlanId__c, 
                dmpl__IncentiveResourceId__c, 
                dmpl__IncentiveTargetType__c, 
                dmpl__InsuranceSchemeId__c, 
                dmpl__InsurerId__c, 
                dmpl__ItemGroupId__c, 
                dmpl__ItemId__c, 
                dmpl__ItemLotTypeId__c, 
                dmpl__KPIConfigurationId__c, 
                dmpl__Operation__c, 
                dmpl__SequenceNumber__c, 
                dmpl__ServiceContractId__c, 
                dmpl__SKUId__c, 
                dmpl__TargetType__c, 
                dmpl__TargetValueType__c, 
                dmpl__Value__c, 
                dmpl__ValuePercentage__c 
            FROM 
                dmpl__IncentiveTarget__c 
            WHERE 
                Id = :incentiveTargetId];
    }
    

    private static List<dmpl__IncentiveResource__c> queryIncentiveResources(List<Id> incentivePlanIds) {
        SecurityHelper.ensureCanReadFields(new String[] {
            'dmpl__IncentivePlanId__c'
        }, 'dmpl__IncentiveResource__c');

        return [
            SELECT 
                Id, 
                dmpl__IncentivePlanId__c
            FROM 
                dmpl__IncentiveResource__c
            WHERE 
                dmpl__IncentivePlanId__c IN :incentivePlanIds
        ];
    }

    private static String getIncentiveResourcesQuery(Id incentivePlanId) {
        return 'SELECT Id, dmpl__IncentivePlanId__c FROM dmpl__IncentiveResource__c WHERE dmpl__IncentivePlanId__c = \'' + incentivePlanId + '\'';
    }

    @testVisible
    private static List<dmpl__IncentivePeriod__c> queryIncentivePeriods(Id incentivePlanId) {
        SecurityHelper.ensureCanReadFields(new String[] {
            'dmpl__IncentivePlanId__c'
        }, 'dmpl__IncentivePeriod__c');

        return [
            SELECT 
                Id, 
                dmpl__IncentivePlanId__c,
                dmpl__DateFrom__c
            FROM 
                dmpl__IncentivePeriod__c
            WHERE 
                dmpl__IncentivePlanId__c = :incentivePlanId
                AND dmpl__SimulationType__c = null
        ];
    }
}