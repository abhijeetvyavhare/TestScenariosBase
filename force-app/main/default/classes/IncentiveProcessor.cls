public with sharing class IncentiveProcessor implements Database.Batchable<SObject> {
    public static final Integer BATCH_SIZE = 50;
    private static final String COMPENSATION_MAX = 'AnyOneMax';
    private static final string COMPENSATION_MIN = 'AnyOneMin';
    private static final string COMPENSATION_ALL = 'All';
    private static final string COMPENSATION_CUSTOM = 'Formulae';

    private static final String DEFINITION_FILTER_CRITERIA_ALWAYS_NO_CRITERIA = 'Always (No Criteria)';
    private static final String DEFINITION_FILTER_CRITERIA_ALL_CONDITIONS = 'All Conditions Are Met';
    private static final String DEFINITION_FILTER_CRITERIA_ANY_CONDITION = 'Any Condition Is Met';
    private static final String DEFINITION_FILTER_CRITERIA_CUSTOM_LOGIC = 'Custom Logic Is Met';
    
    private static final String REWARD_APPLICABILITY_ALL_REWARDS = 'All Rewards';
    private static final String REWARD_APPLICABILITY_ANYONE_LOWESTVALUE = 'Any One With Lowest Value';
    private static final String REWARD_APPLICABILITY_ANYONE_HIGHESTVALUE = 'Any One With Highest Value';
    private static final String REWARD_APPLICABILITY_CUSTOMLOGIC = 'Custom Logic';

    private static final String CONDITION_OPERATOR_EQUALS = 'equals';
    private static final String CONDITION_OPERATOR_DOSESNOT_EQUALS = 'notEqual';
    private static final String CONDITION_OPERATOR_GREATER_THAN = 'greaterThan';
    private static final String CONDITION_OPERATOR_GREATERTHAN_OR_EQUALS = 'greaterOrEqual';
    private static final String CONDITION_OPERATOR_LESS_THAN = 'lessThan';
    private static final String CONDITION_OPERATOR_LESSTHAN_OR_EQUALS = 'lessOrEqual';

    private static final String REWARD_FIXEDAMOUNT =  'Fixed Amount';
    private static final String REWARD_AMOUNTPERUNIT = 'Amount Per Unit';
    private static final String REWARD_AMOUNTPERUNIT_INCREMENTAL = 'Amount Per Unit Incremental';
    private static final String REWARD_PERCENTONVALUE = 'Percentage On Value';
    private static final String REWARD_KPIREWARDVALUE =  'KPI Reward Value';
    private static final String REWARD_KPIREWARDPERCENT =  'KPI Reward Value Percentage';
    private static final String REWARD_RESOURCEREWARD =  'Resource Reward Value Percentage';
    private static final String REWARD_REFERENCERESOURCEREWARD =  'Slab Reward Percentage';
    private static final String REWARD_GIFTS = 'Gifts';
    private static final String REWARD_DISCOUNTGROUP = 'Discount Group';
    private static final String REWARD_REWARDPOINT = 'Reward Points';

    private Id invokedQueueId;
    private Id incentivePeriodId;

    public static JobResponseResult perfromAction(
        Id incentivePeriodId,
        Id queueId){
        try {
            Id batchId = Database.executeBatch(
                new IncentiveProcessor(
                    incentivePeriodId,
                    queueId), 
                BATCH_SIZE);
            return new JobResponseResult(
                true, 
                null, 
                'Apex Batch Job Enqueued With Job Id ' + batchId);
        } catch (Exception error) {
            ExceptionLogHelper.logException(error, queueId);
            throw error;
        }
    }

    public static JobResponseResult perfromAction(
        Id incentivePeriodId){
        try {
            Id batchId = Database.executeBatch(
                new IncentiveProcessor(
                    incentivePeriodId,
                    null), 
                BATCH_SIZE);
            return new JobResponseResult(
                true, 
                null, 
                'Apex Batch Job Enqueued With Job Id ' + batchId);
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public IncentiveProcessor(){
        this.invokedQueueId = null;
        this.incentivePeriodId = null;
    }

    public IncentiveProcessor(
        Id incentivePeriodId,
        Id queueId){
            this.invokedQueueId = queueId;
            this.incentivePeriodId = incentivePeriodId;
        }

    public Database.QueryLocator start(
        Database.BatchableContext bc){
        try {
            InterfaceQueueHelper.addStatusUpdate(
                invokedQueueId,
                'Starting Processor Batch '
            );
            dmpl__IncentivePeriod__c incentivePeriod = queryIncentivePeriod(this.incentivePeriodId);
            CompensationProcessor compensationProcessor = new CompensationProcessor();
            compensationProcessor.deleteCompensation(this.incentivePeriodId);
            return Database.getQueryLocatorWithBinds(
                'SELECT Id FROM dmpl__IncentiveResource__c WHERE dmpl__IncentivePlanId__c = :incentivePlanId',
                new Map<String, Object>{ 
                    'incentivePlanId' => incentivePeriod.dmpl__IncentivePlanId__c
                },
                AccessLevel.SYSTEM_MODE);
        } catch (Exception error) {
            ExceptionLogHelper.logException(error, invokedQueueId);
            throw error;
        }
    }

    public void execute(
        Database.BatchableContext bc, 
        List<SObject> scope){
        try {

            process(
                this.incentivePeriodId, 
                CollectionHelper.extractIds(scope, 'Id'));
      
            InterfaceQueueHelper.addStatusUpdate(
                invokedQueueId,
                'Processed Batch Count ' + scope.size()
            );
        } catch (Exception error) {
            ExceptionLogHelper.logException(error, invokedQueueId);
            throw error;
        }
    }
    
    public void finish(
        Database.BatchableContext bc){
            InterfaceQueueHelper.addStatusUpdate(
                invokedQueueId,
                'Finished Batch '
            );
    }
    
    public Boolean process (
        Id incentivePeriodId,
        List<Id> resourceIds) {
        try {
            dmpl__IncentivePeriod__c incentivePeriod = queryIncentivePeriod(incentivePeriodId);
            if(incentivePeriod == null 
                || incentivePeriod.dmpl__Status__c == 'Approved'
                || incentivePeriod.dmpl__Status__c == 'Posted'){
                return false;
            }
            List<dmpl__IncentiveLine__c> incentiveLines = queryIncentiveLines(
                incentivePeriod.dmpl__IncentivePlanId__c);
            if(incentiveLines.size() == 0){
                return false;
            }
            List<dmpl__IncentiveResource__c> resources = queryResources(
                incentivePeriod.dmpl__IncentivePlanId__c,
                incentivePeriodId,
                resourceIds);

            Map<Id, dmpl__KPIConfiguration__c> kpiConfigs = new Map<Id,dmpl__KPIConfiguration__c>(getKPIConfigs(
                incentiveLines));
                
            List<dmpl__KPIData__c> kpiData = queryKPIData(
                incentivePeriod, 
                resources,
                kpiConfigs);
            List<IncentiveLineResult> incentiveLineResults = new List<IncentiveLineResult>();
            for(dmpl__IncentiveLine__c incentiveLine : incentiveLines){
                IncentiveLineProcessor incentiveLineProcessor = new IncentiveLineProcessor();
                List<IncentiveLineResult> incentiveLineResults1 =  incentiveLineProcessor.process(
                    incentivePeriod,
                    incentiveLine,
                    resources,
                    kpiData,
                    kpiConfigs,
                    incentiveLineResults);
                incentiveLineResults.addAll(incentiveLineResults1);
            }

            String debugLog = getDebugLog(incentiveLineResults);
            CompensationProcessor compensationProcessor = new CompensationProcessor();
            String compensationDebugLog = compensationProcessor.process(
                incentivePeriod,
                incentiveLineResults,
                resources);
            System.debug(compensationDebugLog);
            updateIncentivePeriod(
                incentivePeriod, 
                'Calculated',
                debugLog + compensationDebugLog);   
            return true;
        } catch (Exception ex) {
            ExceptionLogHelper.logException(ex);
            return false;
        }
    }

    String getDebugLog(List<IncentiveLineResult> incentiveLineResults){
        String debugLog = '';
        for(IncentiveLineResult re : incentiveLineResults){
            debugLog += 'Resource: '+ re.resource?.Name +  ' (' + re.resourceId+ ')\n';
            debugLog += 'Incentive Line : ' + re.incentiveLine.Name + (re.incentiveLine.dmpl__Title__c != null ? '(' + re.incentiveLine.dmpl__Title__c + ')' : '') + '\n';
            debugLog += 'Is Applicable: ' + re.isApplicable+ '\n';
            debugLog += 'Total Reward: ' + re.totalReward+ '\n';
            debugLog += 'Total Points: ' + re.totalPoints+ '\n';
            for(IncentiveTargetResult target : re.targetResults){
                debugLog += '--KPI Id: ' + target.kpiId + ' (' + target.kpiName + ')\n';
                debugLog += '--Target Value: ' + target.targetValue+ '\n';
                debugLog += '--Reached Value: ' + target.reachedValue+ '\n';
                debugLog += '--Is Applicable: ' + target.isApplicable+ '\n';
            }
        }
        System.debug(debugLog);
        return debugLog;
    }

    private void updateIncentivePeriod(
        dmpl__IncentivePeriod__c period,
        String status,
        String debugLog){
            period.dmpl__Status__c = status;
            period.dmpl__ProcessLog__c = debugLog.abbreviate(130000);
            update period;
    }

    private List<dmpl__IncentiveResource__c> queryResources(
        Id incentivePlanId,
        Id incentivePeriodId,
        List<Id> resourceIds){
            if(resourceIds == null || resourceIds.size() == 0){
                return [SELECT 
                    Id,
                    Name,
                    dmpl__ResourceId__c,
                    dmpl__PartnerAccountId__c,
                    dmpl__AccountId__c,
                    dmpl__BranchId__c,
                    (SELECT 
                        dmpl__IncentiveTargetId__c,
                        dmpl__KPIConfigurationId__c,
                        dmpl__Value__c
                    FROM dmpl__IncentiveResourceTargets__r
                    WHERE dmpl__IncentivePeriodId__c = :incentivePeriodId)
                FROM
                    dmpl__IncentiveResource__c
                WHERE
                    dmpl__IncentivePlanId__c = :incentivePlanId];
            }else{
                return [SELECT 
                    Id,
                    Name,
                    dmpl__ResourceId__c,
                    dmpl__PartnerAccountId__c,
                    dmpl__AccountId__c,
                    dmpl__BranchId__c,
                    (SELECT 
                        dmpl__IncentiveTargetId__c,
                        dmpl__KPIConfigurationId__c,
                        dmpl__Value__c
                    FROM dmpl__IncentiveResourceTargets__r
                    WHERE dmpl__IncentivePeriodId__c = :incentivePeriodId
                    AND dmpl__IncentiveResourceId__c IN: resourceIds)
                FROM
                    dmpl__IncentiveResource__c
                WHERE
                    dmpl__IncentivePlanId__c = :incentivePlanId
                    AND Id IN :resourceIds];
            }
    }

    private dmpl__IncentivePeriod__c queryIncentivePeriod(
        Id incentivePeriodId){
        return [SELECT
            Id,
            Name,
            dmpl__IncentivePlanId__c,
            dmpl__DateFrom__c,
            dmpl__DateTo__c,
            dmpl__Status__c,
            dmpl__ProcessLog__c,
            dmpl__IncentivePlanId__r.dmpl__BranchId__c,
            dmpl__IncentivePlanId__r.dmpl__PartnerAccountId__c,
            dmpl__IncentivePlanId__r.dmpl__MemberType__c
        FROM
            dmpl__IncentivePeriod__c
        WHERE
            Id = :incentivePeriodId];
    }

    private List<dmpl__KPIData__c> queryKPIData(
        dmpl__IncentivePeriod__c incentivePeriod,
        List<dmpl__IncentiveResource__c> resources,
        Map<Id, dmpl__KPIConfiguration__c> kpiConfigs){

            Id periodId = incentivePeriod.Id;
            List<Id> resourceIds = new List<Id>();
            List<String> fieldNames = new List<String>{
                'Id', 
                'dmpl__ResourceId__c', 
                'dmpl__BranchId__c', 
                'dmpl__PartnerAccountId__c', 
                'dmpl__KPIConfigurationId__c', 
                'dmpl__AccountId__c', 
                'dmpl__KPIValue__c',
                'dmpl__KPIValueSum__c',
                'dmpl__KPIValueCount__c'
            };
            fieldNames = CollectionHelper.addStrings(
                fieldNames,
                kpiConfigs.values(), 
                'dmpl__ResultValueFieldName__c');
            fieldNames = CollectionHelper.addStrings(
                fieldNames,
                kpiConfigs.values(), 
                'dmpl__ResultRewardFieldName__c');

            String query = 'SELECT ' 
                + String.join(fieldNames, ',')
                + ' FROM dmpl__KPIData__c WHERE dmpl__IncentivePeriodId__c = :periodId ';
            if(incentivePeriod.dmpl__IncentivePlanId__r.dmpl__MemberType__c == 'Branch'){
                resourceIds = CollectionHelper.extractIds(resources, 'dmpl__BranchId__c');
                query += ' AND dmpl__BranchId__c IN :resourceIds';
            }else if(incentivePeriod.dmpl__IncentivePlanId__r.dmpl__MemberType__c == 'Partner'){
                resourceIds = CollectionHelper.extractIds(resources, 'dmpl__PartnerAccountId__c');
                query += ' AND dmpl__PartnerAccountId__c IN :resourceIds';
            }else if(incentivePeriod.dmpl__IncentivePlanId__r.dmpl__MemberType__c == 'Resource'){
                resourceIds = CollectionHelper.extractIds(resources, 'dmpl__ResourceId__c');
                query += ' AND dmpl__ResourceId__c IN :resourceIds';
            }else if(incentivePeriod.dmpl__IncentivePlanId__r.dmpl__MemberType__c == 'Customer'){
                resourceIds = CollectionHelper.extractIds(resources, 'dmpl__AccountId__c');
                query += ' AND dmpl__AccountId__c IN :resourceIds';
            }
        return (List<dmpl__KPIData__c>)Database.query(query);
    }

    private List<dmpl__KPIConfiguration__c> getKPIConfigs(
        List<dmpl__IncentiveLine__c> incentiveLines){
        List<Id> configIds = CollectionHelper.extractIds(
            incentiveLines, 
            'dmpl__IncentiveTargets__r', 
            'dmpl__KPIConfigurationId__c');
        return [SELECT 
            Id,
            Name,
            dmpl__ResultValueFieldName__c, 
            dmpl__ResultRewardFieldName__c, 
            dmpl__ValueFunction__c, 
            dmpl__RewardFunction__c
        FROM 
            dmpl__KPIConfiguration__c
        WHERE Id IN :configIds];
    }

    private List<dmpl__IncentiveLine__c> queryIncentiveLines(
        Id incentivePlanId){
        return [SELECT 
            Id, 
            Name,
            dmpl__Title__c,
            dmpl__SequenceNumber__c,
            dmpl__DefinitionCustomLogic__c,
            dmpl__DefinitionFilterCriteria__c,
            dmpl__RewardApplicability__c,
            dmpl__RewardCustomLogic__c,
            dmpl__UseSlabAbsoluteValue__c,
            dmpl__IncentivePlanId__r.dmpl__CompensationEligibility__c,
            dmpl__IncentivePlanId__r.dmpl__CompensationEligibilityFormula__c,
            (
                SELECT 
                    Id, 
                    Name,
                    dmpl__SequenceNumber__c, 
                    dmpl__TargetValueType__c,
                    dmpl__KPIConfigurationId__c, 
                    dmpl__Operation__c,
                    dmpl__ValuePercentage__c,
                    dmpl__Value__c
                FROM 
                    dmpl__IncentiveTargets__r
                ORDER BY dmpl__SequenceNumber__c
            ),
            (
                SELECT
                    Id,
                    dmpl__FromPercentage__c,
                    dmpl__ToPercentage__c,
                    dmpl__CompensationType__c,
                    dmpl__DiscountGroupId__c,
                    dmpl__FromValue__c,
                    dmpl__Gifts__c,
                    dmpl__IncentiveAmountPerUnit__c,
                    dmpl__IncentiveFixedAmount__c,
                    dmpl__AmountPercentage__c,
                    dmpl__KPIConfigurationId__c,
                    dmpl__ResourceRewardFieldName__c,
                    dmpl__GiftPoints__c,
                    dmpl__SequenceNumber__c,
                    dmpl__ReferenceIncentiveLineId__c,
                    dmpl__ReferenceIncentiveTargetId__c,
                    dmpl__ToValue__c
                FROM
                    dmpl__CompensationSlabs__r
                ORDER BY dmpl__SequenceNumber__c
            )
            FROM 
                dmpl__IncentiveLine__c 
            WHERE 
                dmpl__IncentivePlanId__c = :incentivePlanId
            ORDER BY dmpl__SequenceNumber__c];
    }

    private class IncentiveLineResult{
        IncentiveLineResult(
            Id resourceId,
            dmpl__IncentiveLine__c incentiveLine){
                this.resourceId = resourceId;
                this.incentiveLine = incentiveLine;
                this.totalReward = 0;
                this.totalPoints = 0;
        }
        public dmpl__IncentiveLine__c incentiveLine;
        public Id resourceId;
        public Boolean isApplicable;    
        public Decimal totalReward;
        public Decimal totalPoints;
        public String gift;
        public Id discountGroupId;
        public dmpl__IncentiveResource__c resource;
        public List<IncentiveTargetResult> targetResults;

        public Decimal getTargetResult(Id kpiId){
            for(IncentiveTargetResult targetResult : targetResults){
                if(targetResult.kpiId == kpiId){
                    return targetResult.targetValue;
                }
            }
            return 0;
        }
        
        public IncentiveTargetResult getTargetResultObject(Id kpiId){
            for(IncentiveTargetResult targetResult : targetResults){
                if(targetResult.kpiId == kpiId){
                    return targetResult;
                }
            }
            return null;
        }

        public Decimal getReachedResult(Id kpiId){
            for(IncentiveTargetResult targetResult : targetResults){
                if(targetResult.kpiId == kpiId){
                    return targetResult.reachedValue;
                }
            }
            return 0;
        }
        
        public Decimal getReachedResultIncremental(Id kpiId){
            for(IncentiveTargetResult targetResult : targetResults){
                if(targetResult.kpiId == kpiId){
                    return targetResult.reachedValue - targetResult.targetValue;
                }
            }
            return 0;
        }
        
        public Decimal getReachedResultIncrementalOnTargetId(Id incentiveTargetId){ 
            for(IncentiveTargetResult targetResult : targetResults){
                if(targetResult.incentiveTargetId == incentiveTargetId){
                    return targetResult.reachedValue - targetResult.targetValue;
                }
            }
            return 0;
        }

        public List<Boolean> getTargetResults(){
            List<Boolean> results = new List<Boolean>();
            for(IncentiveTargetResult targetResult : targetResults){
                results.add(targetResult.isApplicable);
            }
            return results;
        }
    }

    private class IncentiveTargetResult{
        IncentiveTargetResult(){
            this.reachedValue = 0;
            this.targetValue = 0;
            this.isApplicable = false;
        }
        public Decimal reachedValue;
        public Decimal targetValue;
        public Boolean isApplicable;
        public Id kpiId;
        public String kpiName;
        public Id incentiveTargetId;
        public dmpl__KPIData__c kpiData;
    }

    private class CompensationLineResult{
        public IncentiveLineResult incentiveLineResult;
        public Id resourceId;
        public Decimal totalReward;
        public Decimal totalPoints;
        public String gift;
        public Id discountGroupId;
        public String debugLog;
    }

    private class IncentiveLineProcessor{
        
        private dmpl__IncentivePeriod__c incentivePeriod;
        private dmpl__IncentiveLine__c incentiveLine;
        private List<dmpl__KPIData__c> kpiData;
        Map<Id, dmpl__KPIConfiguration__c> kpiConfigs;
        List<IncentiveLineResult> incentiveLineResults;

        public List<IncentiveLineResult> process(
            dmpl__IncentivePeriod__c incentivePeriod,
            dmpl__IncentiveLine__c incentiveLine,
            List<dmpl__IncentiveResource__c> resources,
            List<dmpl__KPIData__c> kpiData,
            Map<Id, dmpl__KPIConfiguration__c> kpiConfigs,
            List<IncentiveLineResult> incentiveLineResults){
                this.incentiveLine = incentiveLine;
                this.incentivePeriod = incentivePeriod;
                this.kpiData = kpiData;
                this.kpiConfigs = kpiConfigs;
                this.incentiveLineResults = incentiveLineResults;
                List<IncentiveLineResult> results = new List<IncentiveLineResult>();    
                for(dmpl__IncentiveResource__c resource : resources){
                    incentiveLineResults.add(evaluateIncentiveLine(resource));
                }
            return results;
        }

        private IncentiveLineResult evaluateIncentiveLine(
            dmpl__IncentiveResource__c resource){
                IncentiveLineResult result = new IncentiveLineResult(
                    resource.Id,
                    this.incentiveLine);
                result.resource = resource;
                result.targetResults = new List<IncentiveTargetResult>();
                String filterCriteria = this.incentiveLine.dmpl__DefinitionFilterCriteria__c;
                for(dmpl__IncentiveTarget__c target : this.incentiveLine.dmpl__IncentiveTargets__r){
                    result.targetResults.add(
                        evaluateIncentiveTarget(
                            target,
                            resource,
                            result));
                }
                if(filterCriteria == DEFINITION_FILTER_CRITERIA_ALL_CONDITIONS){    
                    result.isApplicable = BooleanEvaluate.allConditions(result.getTargetResults()).evaluate();
                }else if(filterCriteria == DEFINITION_FILTER_CRITERIA_ANY_CONDITION){
                    result.isApplicable = BooleanEvaluate.anyConditions(result.getTargetResults()).evaluate();
                } else if(filterCriteria == DEFINITION_FILTER_CRITERIA_CUSTOM_LOGIC){
                    result.isApplicable = (new BooleanEvaluate(this.incentiveLine.dmpl__DefinitionCustomLogic__c,result.getTargetResults())).evaluate();
                }else {
                    result.isApplicable = true;
                }
                if(result.isApplicable){
                    result.totalReward = calculateRewards(result);
                    calculateNonMonetaryRewards(result);
                }
                return result;
        }

        private IncentiveTargetResult evaluateIncentiveTarget(
            dmpl__IncentiveTarget__c target,
            dmpl__IncentiveResource__c resource,
            IncentiveLineResult result){
                IncentiveTargetResult targetResult = new IncentiveTargetResult();
                targetResult.reachedValue = getAchivedValue(target, resource, targetResult);
                targetResult.targetValue = getTargetValue(target, resource);        
                targetResult.kpiId = target.dmpl__KPIConfigurationId__c;
                targetResult.incentiveTargetId = target.Id;
                if(target.dmpl__KPIConfigurationId__c!=null){
                    targetResult.kpiName = this.kpiConfigs.get(target.dmpl__KPIConfigurationId__c)?.Name;
                }
                targetResult.isApplicable = evaluateCurrencyOperator(
                    targetResult.reachedValue,
                    target.dmpl__Operation__c,
                    targetResult.targetValue);
            return targetResult;
        }

        private Decimal getTargetValue(
            dmpl__IncentiveTarget__c target,
            dmpl__IncentiveResource__c resource){

            Decimal targetValue = target.dmpl__Value__c != null ? target.dmpl__Value__c : 0;
            dmpl__IncentiveResourceTarget__c resourceTarget = (dmpl__IncentiveResourceTarget__c)CollectionHelper.getFirstIfExists(
                CollectionHelper.getObjectsByFilter(
                    resource.dmpl__IncentiveResourceTargets__r, 
                    'dmpl__IncentiveTargetId__c', 
                    target.Id,
                    'dmpl__KPIConfigurationId__c',
                    target.dmpl__KPIConfigurationId__c));
            if(resourceTarget!=null && resourceTarget.dmpl__Value__c != null && resourceTarget.dmpl__Value__c > 0){
                targetValue = resourceTarget.dmpl__Value__c;
            }
            if(target.dmpl__ValuePercentage__c !=null){
                return targetValue * target.dmpl__ValuePercentage__c /100;
            }else {
                return targetValue;
            }
        }

        private Decimal getAchivedValue(
            dmpl__IncentiveTarget__c target,
            dmpl__IncentiveResource__c resource,
            IncentiveTargetResult targetResult){
                if(this.incentivePeriod.dmpl__IncentivePlanId__r.dmpl__MemberType__c == 'Branch'){
                    for(dmpl__KPIData__c data : kpiData){
                        if(data.dmpl__KPIConfigurationId__c == target.dmpl__KPIConfigurationId__c
                            && data.dmpl__BranchId__c == resource.dmpl__BranchId__c){
                                targetResult.kpiData = data;
                                return getAchivedValueData(data);
                        }
                    }
                }else if(this.incentivePeriod.dmpl__IncentivePlanId__r.dmpl__MemberType__c == 'Partner'){
                    for(dmpl__KPIData__c data : kpiData){
                        if(data.dmpl__KPIConfigurationId__c == target.dmpl__KPIConfigurationId__c
                            && data.dmpl__PartnerAccountId__c == resource.dmpl__PartnerAccountId__c){
                                targetResult.kpiData = data;
                                return getAchivedValueData(data);
                        }
                    }
                }else if(this.incentivePeriod.dmpl__IncentivePlanId__r.dmpl__MemberType__c == 'Resource'){
                    for(dmpl__KPIData__c data : kpiData){
                        if(data.dmpl__KPIConfigurationId__c == target.dmpl__KPIConfigurationId__c
                            && data.dmpl__ResourceId__c == resource.dmpl__ResourceId__c){
                                targetResult.kpiData = data;
                                return getAchivedValueData(data);
                        }
                    }
                }else if(this.incentivePeriod.dmpl__IncentivePlanId__r.dmpl__MemberType__c == 'Customer'){
                    for(dmpl__KPIData__c data : kpiData){
                        if(data.dmpl__KPIConfigurationId__c == target.dmpl__KPIConfigurationId__c
                            && data.dmpl__AccountId__c == resource.dmpl__AccountId__c){
                                targetResult.kpiData = data;
                                return getAchivedValueData(data);
                        }
                    }
                }
                return 0;
        }

        private Decimal getAchivedValueData(
            dmpl__KPIData__c data){
                if(data.dmpl__KPIValue__c != null && data.dmpl__KPIValue__c >0){
                    return data.dmpl__KPIValue__c;
                }
                dmpl__KPIConfiguration__c kpiConfig = this.kpiConfigs.get(data.dmpl__KPIConfigurationId__c);
                if(this.kpiConfigs != null){
                    if(kpiConfig.dmpl__ValueFunction__c == 'Formula Field' 
                        && String.isNotBlank(kpiConfig.dmpl__ResultValueFieldName__c)){
                        return (Decimal)data.get(kpiConfig.dmpl__ResultValueFieldName__c);
                    }else if(kpiConfig.dmpl__ValueFunction__c == 'Sum'){
                        return data.dmpl__KPIValueSum__c;
                    }else if(kpiConfig.dmpl__ValueFunction__c == 'Count'){
                        return data.dmpl__KPIValueCount__c;
                    }else if(kpiConfig.dmpl__ValueFunction__c == 'Average' && data.dmpl__KPIValueCount__c > 0){
                        return (data.dmpl__KPIValueSum__c/data.dmpl__KPIValueCount__c);
                    }                    
                }
                return 0;
        }

        private Boolean evaluateCurrencyOperator(
            Decimal reachedValue, 
            string operator, 
            Decimal targetValue){
                reachedValue = (reachedValue == null) ? 0 : reachedValue;
                targetValue = (targetValue == null) ? 0 : targetValue;
                if(operator == CONDITION_OPERATOR_GREATERTHAN_OR_EQUALS){
                    return (reachedValue >= targetValue);
                }else if(operator == CONDITION_OPERATOR_GREATER_THAN){
                    return (reachedValue > targetValue);
                }else if(operator == CONDITION_OPERATOR_EQUALS){
                    return (reachedValue == targetValue);
                }else if(operator == CONDITION_OPERATOR_LESSTHAN_OR_EQUALS){
                    return (reachedValue <= targetValue);
                }else if(operator == CONDITION_OPERATOR_LESS_THAN){
                    return (reachedValue < targetValue);
                }else if(operator == CONDITION_OPERATOR_DOSESNOT_EQUALS){
                    return (reachedValue != targetValue);
                }else{
                    return false;
                }
        }
        
        private Decimal calculateRewards(
            IncentiveLineResult result){
            if(result.incentiveLine.dmpl__RewardApplicability__c == REWARD_APPLICABILITY_ANYONE_LOWESTVALUE){
                return calculateAnyOneLowestValue(calculateReward(result));
            }else if(result.incentiveLine.dmpl__RewardApplicability__c == REWARD_APPLICABILITY_ANYONE_HIGHESTVALUE){
                return calculateAnyOneHighestValue(calculateReward(result));
            }else if(result.incentiveLine.dmpl__RewardApplicability__c == REWARD_APPLICABILITY_CUSTOMLOGIC){
                return calculateCustomLogic(calculateReward(result));
            }else {
                return calculateAllRewards(calculateReward(result));
            }
        }

        private List<Decimal> calculateReward(
            IncentiveLineResult result){
            List<Decimal> rewards = new List<Decimal>();
            for(dmpl__IncentiveCompensationSlab__c slab : result.incentiveLine.dmpl__CompensationSlabs__r){
                if(!isSlabApplicable(result, slab)){
                    System.debug('Slab Not Applicable' + slab.Id);
                    continue;
                }
                System.debug('Slab Applicable' + slab.Id);
                if(slab.dmpl__CompensationType__c == REWARD_FIXEDAMOUNT){
                    rewards.add(slab.dmpl__IncentiveFixedAmount__c);
                }else if(slab.dmpl__CompensationType__c	== REWARD_AMOUNTPERUNIT){
                    rewards.add(slab.dmpl__IncentiveAmountPerUnit__c * result.getReachedResult(slab.dmpl__KPIConfigurationId__c));
                }else if(slab.dmpl__CompensationType__c	== REWARD_AMOUNTPERUNIT_INCREMENTAL){
                    if(slab.dmpl__ReferenceIncentiveTargetId__c != null){
                        rewards.add(slab.dmpl__IncentiveAmountPerUnit__c * result.getReachedResultIncrementalOnTargetId(slab.dmpl__ReferenceIncentiveTargetId__c));
                    }else {
                        rewards.add(slab.dmpl__IncentiveAmountPerUnit__c * result.getReachedResultIncremental(slab.dmpl__KPIConfigurationId__c));
                    }
                }else if(slab.dmpl__CompensationType__c	== REWARD_PERCENTONVALUE){
                    Decimal val1 = result.getReachedResult(slab.dmpl__KPIConfigurationId__c);
                    rewards.add(slab.dmpl__AmountPercentage__c * result.getReachedResult(slab.dmpl__KPIConfigurationId__c)/100);
                }else if(slab.dmpl__CompensationType__c	== REWARD_REFERENCERESOURCEREWARD){
                    rewards.add(slab.dmpl__AmountPercentage__c * getSlabReward(result, slab.dmpl__ReferenceIncentiveLineId__c)/100);
                }else if(slab.dmpl__CompensationType__c	== REWARD_KPIREWARDVALUE){
                    rewards.add(getAchivedRewardData(result.getTargetResultObject(slab.dmpl__KPIConfigurationId__c)?.kpiData));
                }else if(slab.dmpl__CompensationType__c	== REWARD_KPIREWARDPERCENT){
                    rewards.add(slab.dmpl__AmountPercentage__c * getAchivedRewardData(result.getTargetResultObject(slab.dmpl__KPIConfigurationId__c)?.kpiData) /100);
                }else if(slab.dmpl__CompensationType__c	== REWARD_RESOURCEREWARD){
                    //return calculateResourceReward(result);
                }
            }
            return rewards;
        }
    
        private void calculateNonMonetaryRewards(IncentiveLineResult result){
            for(dmpl__IncentiveCompensationSlab__c slab : result.incentiveLine.dmpl__CompensationSlabs__r){
                if(!isSlabApplicable(result, slab)){
                    continue;
                }
                if(slab.dmpl__CompensationType__c == REWARD_REWARDPOINT){
                    result.totalPoints += slab.dmpl__GiftPoints__c;
                }else if(slab.dmpl__CompensationType__c	== REWARD_GIFTS){
                    result.gift = slab.dmpl__Gifts__c;
                }else if(slab.dmpl__CompensationType__c	== REWARD_DISCOUNTGROUP){
                    result.discountGroupId = slab.dmpl__DiscountGroupId__c;
                }
            }
        }

        private Decimal getAchivedRewardData(
            dmpl__KPIData__c data){
                if(data == null){
                    return 0;
                }
                if(data.dmpl__RewardValue__c != null && data.dmpl__RewardValue__c >0){
                    return data.dmpl__RewardValue__c;
                }
                dmpl__KPIConfiguration__c kpiConfig = this.kpiConfigs.get(data.dmpl__KPIConfigurationId__c);
                if(this.kpiConfigs != null){
                    if(kpiConfig.dmpl__RewardFunction__c == 'Formula Field' 
                        && String.isNotBlank(kpiConfig.dmpl__ResultRewardFieldName__c)){
                        return (Decimal)data.get(kpiConfig.dmpl__ResultRewardFieldName__c);
                    }else if(kpiConfig.dmpl__RewardFunction__c == 'Sum'){
                        return data.dmpl__RewardValueSum__c;
                    }else if(kpiConfig.dmpl__RewardFunction__c == 'Count'){
                        return data.dmpl__KPIValueCount__c;
                    }else if(kpiConfig.dmpl__RewardFunction__c == 'Average' && data.dmpl__KPIValueCount__c > 0){
                        return (data.dmpl__RewardValueSum__c/data.dmpl__KPIValueCount__c);
                    }                    
                }
                return 0;
        }

        private Decimal getSlabReward(
            IncentiveLineResult orgResult,
            Id incentiveLineId){
                System.debug('Calculating Slab Reward for ' + incentiveLineId);
                for(IncentiveLineResult result : this.incentiveLineResults){
                    if(result.incentiveLine.Id == incentiveLineId 
                        && result.resourceId == orgResult.resourceId){
                        System.debug('FOund Calculating Slab Reward for ' + result.totalReward);
                        return result.totalReward;
                    }
                }
                System.debug('Not FOund Calculating Slab Reward for ' + incentiveLineId);
                return 0;
        }

        private Boolean isSlabApplicable(
            IncentiveLineResult result,
            dmpl__IncentiveCompensationSlab__c slab){
                Decimal value = 0;
                Decimal valuePercent = 0;
                for(IncentiveTargetResult targetResult : result.targetResults){
                    if(slab.dmpl__KPIConfigurationId__c != null){
                        if(targetResult.kpiId == slab.dmpl__KPIConfigurationId__c){
                            value = targetResult.reachedValue;
                            if(targetResult.targetValue > 0){
                                valuePercent = (targetResult.reachedValue / targetResult.targetValue) * 100;
                            }else {
                                valuePercent = 0;
                            }
                            break;
                        }
                    }
                }
                if(result.incentiveLine.dmpl__UseSlabAbsoluteValue__c){
                    if(slab.dmpl__FromValue__c != null && slab.dmpl__ToValue__c != null){
                        return (value >= slab.dmpl__FromValue__c && value <= slab.dmpl__ToValue__c);
                    }else if(slab.dmpl__FromValue__c != null){
                        return (value >= slab.dmpl__FromValue__c);
                    }else if(slab.dmpl__ToValue__c != null){
                        return (value <= slab.dmpl__ToValue__c);
                    }    
                }else{
                    if(slab.dmpl__FromPercentage__c != null && slab.dmpl__ToPercentage__c != null){
                        return (valuePercent >= slab.dmpl__FromPercentage__c && valuePercent <= slab.dmpl__ToPercentage__c);
                    }else if(slab.dmpl__FromPercentage__c != null){
                        return (valuePercent >= slab.dmpl__FromPercentage__c);
                    }else if(slab.dmpl__ToPercentage__c != null){
                        return (valuePercent <= slab.dmpl__ToPercentage__c);
                    }
                }
                return false;
        }
        
        private Decimal calculateAllRewards(
            List<Decimal> rewards){
                Decimal totalReward = 0;
                for(Decimal reward : rewards){
                    totalReward += reward;
                }
                return totalReward;
        }

        private Decimal calculateAnyOneLowestValue(
            List<Decimal> rewards){
                Decimal lowestReward = 0;
                for(Decimal reward : rewards){
                    if(reward < lowestReward){
                        lowestReward = reward;
                    }
                }
                return lowestReward;
        }

        private Decimal calculateAnyOneHighestValue (
            List<Decimal> rewards){
                Decimal highestReward = 0;
                for(Decimal reward : rewards){
                    if(reward > highestReward){
                        highestReward = reward;
                    }
                }
                return highestReward;
        }

        private Decimal calculateCustomLogic (
            List<Decimal> rewards){
                // Calculate Custom Logic
                return 0;
        }
    }

    private class CompensationProcessor{
        public String process(
            dmpl__IncentivePeriod__c incentivePeriod,
            List<IncentiveLineResult> incentiveLineResults,
            List<dmpl__IncentiveResource__c> resources){
                if(incentiveLineResults.size() == 0){
                    return 'No Compensation Results';
                }
                Map<Id, CompensationLineResult> resourceRewards = new Map<Id, CompensationLineResult>();
                for(dmpl__IncentiveResource__c resource : resources){
                    resourceRewards.put(
                        resource.Id,
                        processCompensations(
                            incentiveLineResults,
                            resource.Id));
                }

                String debugLog = '';
                for(Id resourceId : resourceRewards.keySet()){
                    debugLog += 'Resource Id: ' + resourceId + '\n';
                    debugLog += 'Reward: ' + resourceRewards.get(resourceId).totalReward + '\n';
                    debugLog += 'Points: ' + resourceRewards.get(resourceId).totalPoints + '\n';
                }

                dmpl__IncentiveCompensation__c compensation = createCompensation(incentivePeriod);
                updateResourceRewards(
                    incentivePeriod,
                    compensation,
                    resourceRewards);
                return debugLog;
        }
        
        private dmpl__IncentiveCompensation__c createCompensation(
            dmpl__IncentivePeriod__c incentivePeriod){
                dmpl__IncentiveCompensation__c compensation = (dmpl__IncentiveCompensation__c)CollectionHelper.getFirstIfExists(
                    queryCompensation(incentivePeriod.Id));
                if(compensation == null){
                    compensation = new dmpl__IncentiveCompensation__c(
                        dmpl__IncentivePeriodId__c = incentivePeriod.Id,
                        dmpl__Status__c = 'Draft',
                        dmpl__BranchId__c = incentivePeriod.dmpl__IncentivePlanId__r.dmpl__BranchId__c,
                        dmpl__IncentivePlanId__c = incentivePeriod.dmpl__IncentivePlanId__c,
                        dmpl__PartnerAccountId__c = incentivePeriod.dmpl__IncentivePlanId__r.dmpl__PartnerAccountId__c);
                        insert compensation;
                }
                return compensation;
        }
        
        public void deleteCompensation(Id incentivePeriodId){
            dmpl__IncentiveCompensation__c compensation = (dmpl__IncentiveCompensation__c)CollectionHelper.getFirstIfExists(
                queryCompensation(incentivePeriodId));
            if(compensation!=null){
                delete compensation;
            }
        }

        private void updateResourceRewards(
            dmpl__IncentivePeriod__c incentivePeriod,
            dmpl__IncentiveCompensation__c compensation,
            Map<Id, CompensationLineResult> resourceRewards){
                List<dmpl__IncentiveCompensationLine__c> compensationLines = new List<dmpl__IncentiveCompensationLine__c>();
                for(Id resourceId : resourceRewards.keySet()){
                    compensationLines.add(
                        new dmpl__IncentiveCompensationLine__c(
                            dmpl__CompensationId__c = compensation.Id,
                            dmpl__IncentivePeriodId__c = incentivePeriod.Id,
                            dmpl__IncentivePlanId__c = incentivePeriod.dmpl__IncentivePlanId__c,
                            dmpl__IncentiveResourceId__c = resourceId,
                            dmpl__IncentiveAmount__c = resourceRewards.get(resourceId)?.totalReward,
                            dmpl__GiftPoints__c  = resourceRewards.get(resourceId)?.totalPoints,
                            dmpl__Gifts__c = resourceRewards.get(resourceId)?.gift,
                            dmpl__ProcessLog__c = resourceRewards.get(resourceId)?.debugLog,
                            dmpl__DiscountGroupId__c = resourceRewards.get(resourceId)?.discountGroupId));
                }
                insert compensationLines;
        }

        private CompensationLineResult processCompensations (
            List<IncentiveLineResult> incentiveLineResults,
            Id resourceId){
                List<IncentiveLineResult> applicableIncentiveLineResults = new List<IncentiveLineResult>();
                for(IncentiveLineResult incentiveLineResult : incentiveLineResults){
                    if(incentiveLineResult.resourceId == resourceId){
                        applicableIncentiveLineResults.add(incentiveLineResult);
                    }
                }
                CompensationLineResult compensationLineResult = new CompensationLineResult();
                compensationLineResult.resourceId = resourceId;
                compensationLineResult.totalReward = processCompensation(applicableIncentiveLineResults);
                processNonMonetaryCompensation(applicableIncentiveLineResults, compensationLineResult);
                addToProcessLog(applicableIncentiveLineResults, compensationLineResult);
                return compensationLineResult;
        }

        private void addToProcessLog(
            List<IncentiveLineResult> incentiveLineResults,
            CompensationLineResult compensationLineResult){
                String debugLog = 'Resource Id: ' + compensationLineResult.resourceId + '\n';
                debugLog += 'Reward: ' + compensationLineResult.totalReward + '\n';
                debugLog += 'Points: ' + compensationLineResult.totalPoints + '\n';

                for(IncentiveLineResult re : incentiveLineResults){
                    debugLog += '--Incentive Line : ' + re.incentiveLine.Name + (re.incentiveLine.dmpl__Title__c != null ? '(' + re.incentiveLine.dmpl__Title__c + ')' : '') + '\n';
                    debugLog += '--Is Applicable: ' + re.isApplicable+ '\n';
                    debugLog += '--Total Reward: ' + re.totalReward+ '\n';
                    debugLog += '--Total Points: ' + re.totalPoints+ '\n';
                    for(IncentiveTargetResult target : re.targetResults){
                        debugLog += '----KPI : ' + target.kpiName + '(' + target.kpiId + ')\n';
                        debugLog += '----Is Applicable: ' + target.isApplicable+ '\n';
                        debugLog += '----Target Value: ' + target.targetValue+ '\n';
                        debugLog += '----Reached Value: ' + target.reachedValue+ '\n';
                    }
                }

            compensationLineResult.debugLog = debugLog;
        }

        private Decimal processCompensation (
            List<IncentiveLineResult> incentiveLineResults){                
                if(incentiveLineResults.size() == 0){
                    System.debug('No Incentive Line Results');
                    return 0;
                }
                
                String compensationEligibily = incentiveLineResults[0].incentiveLine.dmpl__IncentivePlanId__r.dmpl__CompensationEligibility__c;
                if(compensationEligibily == COMPENSATION_MAX){
                    return processMaxCompensation(incentiveLineResults, false);
                }else if(compensationEligibily == COMPENSATION_MIN){
                    return processMinCompensation(incentiveLineResults, false);
                }else if(compensationEligibily == COMPENSATION_ALL || compensationEligibily == null){
                    return processAllCompensation(incentiveLineResults, false);
                }else if(compensationEligibily == COMPENSATION_CUSTOM){
                    return processCustomCompensation(incentiveLineResults, false);
                }
                return 0;
        }

        private void processNonMonetaryCompensation(
            List<IncentiveLineResult> incentiveLineResults,
            CompensationLineResult compensationLineResult){                
                if(incentiveLineResults.size() == 0){
                    return;
                }
                for(IncentiveLineResult incentiveLineResult : incentiveLineResults){
                    String compensationEligibily = incentiveLineResults[0].incentiveLine.dmpl__IncentivePlanId__r.dmpl__CompensationEligibility__c;
                    if(compensationEligibily == COMPENSATION_MAX){
                        compensationLineResult.totalPoints = processMaxCompensation(incentiveLineResults, true);
                    }else if(compensationEligibily == COMPENSATION_MIN){
                        compensationLineResult.totalPoints = processMinCompensation(incentiveLineResults, true);
                    }else if(compensationEligibily == COMPENSATION_ALL || compensationEligibily == null){
                        compensationLineResult.totalPoints = processAllCompensation(incentiveLineResults, true);
                    }else if(compensationEligibily == COMPENSATION_CUSTOM){
                        compensationLineResult.totalPoints = processCustomCompensation(incentiveLineResults, true);
                    }
                    
                    if(incentiveLineResult.gift != null){
                        compensationLineResult.gift = incentiveLineResult.gift;
                    }
                    if(incentiveLineResult.discountGroupId != null){
                        compensationLineResult.discountGroupId = incentiveLineResult.discountGroupId;
                    }
                }
        }
        
        private Decimal processMaxCompensation(List<IncentiveLineResult> incentiveLineResults, Boolean isPoints){
            Decimal maxReward = 0;
            for(IncentiveLineResult incentiveLineResult : incentiveLineResults){
                if(isPoints){
                    if(incentiveLineResult.totalPoints > maxReward){
                        maxReward = incentiveLineResult.totalPoints;
                    }
                }else {
                    if(incentiveLineResult.totalReward > maxReward){
                        maxReward = incentiveLineResult.totalReward;
                    }
                }
            }
            return maxReward;
        }

        private Decimal processMinCompensation(List<IncentiveLineResult> incentiveLineResults, Boolean isPoints){
            Decimal minReward = 0;
            for(IncentiveLineResult incentiveLineResult : incentiveLineResults){
                if(isPoints){
                    if(incentiveLineResult.totalPoints < minReward){
                        minReward = incentiveLineResult.totalPoints;
                    }
                }else {
                    if(incentiveLineResult.totalReward < minReward){
                        minReward = incentiveLineResult.totalReward;
                    }
                }
            }
            return minReward;
        }

        private Decimal processAllCompensation(List<IncentiveLineResult> incentiveLineResults, Boolean isPoints){
            Decimal totalReward = 0;
            if(isPoints){
                for(IncentiveLineResult incentiveLineResult : incentiveLineResults){
                    totalReward += incentiveLineResult.totalPoints;
                }
            }else{
                for(IncentiveLineResult incentiveLineResult : incentiveLineResults){
                    totalReward += incentiveLineResult.totalReward;
                }
            }
            return totalReward;
        }

        private Decimal processCustomCompensation(List<IncentiveLineResult> incentiveLineResults, Boolean isPoints){
            return processAllCompensation(incentiveLineResults, false);
        }

        private List<dmpl__IncentiveCompensation__c> queryCompensation(
            Id incentivePeriodId){
                return [SELECT
                    Id,
                    Name,
                    dmpl__BranchId__c,
                    dmpl__IncentivePlanId__c,
                    dmpl__IncentivePeriodId__c,
                    dmpl__PartnerAccountId__c,
                    dmpl__Status__c
                FROM
                    dmpl__IncentiveCompensation__c
                WHERE
                    dmpl__IncentivePeriodId__c = :incentivePeriodId];
        }
    }
}