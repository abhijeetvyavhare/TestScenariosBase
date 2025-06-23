public with sharing class KPIConfigurationHelper {

    public static void evaluateKPIConfigRules(
        String objectApiName,
        TriggerHandler.TriggerContext triggerContext,
        List<Id> recordIds)
    {
        KPIConfigurationService kcs = new KPIConfigurationService();
        List<dmpl__KPIConfiguration__c> configs = getConfigsByFilter(
            kcs.getKPIConfigs(objectApiName),
            triggerContext.toString());
        if(configs == null || configs.size()==0){
            return;
        }
        if(System.isFuture() || System.isBatch() || System.isQueueable() ||  System.isScheduled()){
            evaluateKPIConfigRulesExec(
                objectApiName,
                triggerContext.toString(),
                recordIds);
        } else {
            evaluateKPIConfigRulesInternal(
                objectApiName,
                triggerContext.toString(),
                recordIds);
        }
    }

    public static List<dmpl__KPIConfiguration__c> getConfigsByFilter(List<dmpl__KPIConfiguration__c> configs, String triggerContext){
        List<dmpl__KPIConfiguration__c> result = new List<dmpl__KPIConfiguration__c>();
        for(dmpl__KPIConfiguration__c config : configs){
            if(config.dmpl__TriggerEvent__c == 'AFTER_ALL' 
                || config.dmpl__TriggerEvent__c == triggerContext
                || (triggerContext == 'AFTER_INSERT' && config.dmpl__TriggerEvent__c == 'AFTER_UPSERT')
                || (triggerContext == 'AFTER_UPDATE' && config.dmpl__TriggerEvent__c == 'AFTER_UPSERT')){
                result.add(config);
            }
        }
        return result;
    }

    public static JobResponseResult evaluateTimerKPIConfigRules(
        Id queueId)
    {
        try {
            KPIConfigurationService kcs = new KPIConfigurationService();
            List<dmpl__KPIConfiguration__c> configs = CollectionHelper.getObjectsByFilter(
                kcs.getKPIConfigs(),
                'dmpl__TriggerEvent__c',
                KPIConfigurationService.FIELD_KPICONFIG_TRIGGEREVENT_SCHEDULED);
            configs = CollectionHelper.getObjectsByFilter(
                configs,
                'dmpl__JobQueueId__c',
                queueId);
            if(configs == null || configs.size()==0){
                return new JobResponseResult(true);
            }
            
            List<dmpl__IncentiveTarget__c> targets = kcs.getIncentiveTargets(
                CollectionHelper.extractIds(configs));
            List<dmpl__IncentivePeriod__c> periods = kcs.getIncentivePeriods(
                CollectionHelper.extractIds(
                    targets, 
                    'dmpl__IncentivePlanId__c'));
            for(dmpl__KPIConfiguration__c config : configs){
                if(config.dmpl__IsActive__c == false 
                    || config.dmpl__IsActive__c == null){
                    continue;
                }
                List<dmpl__IncentiveTarget__c> appTargets = (List<dmpl__IncentiveTarget__c>)CollectionHelper.getObjectsByFilter(
                        targets,
                        'dmpl__KPIConfigurationId__c',
                        config.Id);
                if(appTargets.size() == 0){
                    System.debug('Skip Processing Config ' + config.Id);
                    continue;
                }
                System.debug('Processing Config ' + config.Id);
                String dbQuery = (new RuleEvaluator()).evaluateRules(config);
                System.debug('Query : ' + dbQuery);
                Database.executeBatch(
                    new KPIConfigurationDataProcessor(
                        config,
                        appTargets,
                        periods,
                        dbQuery,
                        queueId,
                        Datetime.now()),
                    KPIConfigurationDataProcessor.BATCH_SIZE);
            }
            return new JobResponseResult(true);
        } catch (Exception error) {
            ExceptionLogHelper.logException(
                error, 
                queueId);
            throw error;
        }
    }

    @future
    @testVisible
    private static void evaluateKPIConfigRulesInternal(
        String objectApiName,
        String triggerContext,
        List<Id> recordIds){
            evaluateKPIConfigRulesExec(
                objectApiName,
                triggerContext,
                recordIds);
        }

    private static void evaluateKPIConfigRulesExec(
        String objectApiName,
        String triggerContext,
        List<Id> recordIds)
    {
        KPIConfigurationService kcs = new KPIConfigurationService();
        List<dmpl__KPIConfiguration__c> configs = kcs.getKPIConfigs(objectApiName);
        List<dmpl__IncentiveTarget__c> targets = kcs.getIncentiveTargets(
            CollectionHelper.extractIds(configs));
        List<dmpl__IncentivePeriod__c> periods = kcs.getIncentivePeriods(
            CollectionHelper.extractIds(
                targets, 
                'dmpl__IncentivePlanId__c'));
        for(dmpl__KPIConfiguration__c config : configs){
            if(config.dmpl__TriggerEvent__c != triggerContext
                || config.dmpl__IsActive__c == false){
                continue;
            }
            List<dmpl__IncentiveTarget__c> appTargets = (List<dmpl__IncentiveTarget__c>)CollectionHelper.getObjectsByFilter(
                targets,
                'dmpl__KPIConfigurationId__c',
                config.Id);
            if(appTargets.size() == 0){
                System.debug('Skip Processing Config ' + config.Id);
                continue;
            }
            System.debug('Processing Config ' + config.Id);
                kcs.createKPIData(
                    config,
                    appTargets,
                    periods,
                    getSourceObjects(
                        config, 
                        recordIds));
        }
    }

    @testVisible
    private static List<SObject> getSourceObjects(
        dmpl__KPIConfiguration__c config,
        List<Id> recordIds)
    {
        try {
            String dbQuery = (new RuleEvaluator()).evaluateRules(config);
            return Database.query(dbQuery);
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            return new List<SObject>();   
        }
    }

    @testVisible
    private class RuleEvaluator{

        @testVisible
        private String evaluateRules(dmpl__KPIConfiguration__c config){
            List<String> fields = new List<String>{ 
                'Id',
                config.dmpl__ValueFieldName__c,
                config.dmpl__RewardFieldName__c,
                config.dmpl__ResourceFieldName__c,
                config.dmpl__PartnerFieldName__c,
                config.dmpl__ItemFieldName__c,
                config.dmpl__BranchFieldName__c,
                config.dmpl__AccountFieldName__c,
                config.dmpl__DateFieldName__c
            };
            
            if(string.isBlank(config.dmpl__TriggerObjectName__c)){
                return null;
            }
            SObjectType sObjectType = Schema.getGlobalDescribe().get(config.dmpl__TriggerObjectName__c);
            if(sObjectType == null){
                return null;
            }
            Map<String, Schema.SObjectField> fieldMap = MetadataHelper.getFieldMap(sObjectType);
            List<String> fieldNames = new List<String>();
            for(String field : fields){
                //&& fieldMap.containsKey(field)
                if(String.isNotEmpty(field) 
                    
                    && !fieldNames.contains(field)){
                    fieldNames.add(field);
                }
            }

            String dbQuery = 'SELECT '
                + String.join(fieldNames, ',')
                + ' FROM ' 
                + config.dmpl__TriggerObjectName__c ;
            List<String> conditions = new List<String>();
            for(dmpl__KPIRules__c rule : config.dmpl__KPI_Rules__r){
                conditions.add(buildCondition(rule));
            }
            
            String dbWhereClause1 = null;
            if (config.dmpl__TriggerEvent__c != KPIConfigurationService.FIELD_KPICONFIG_TRIGGEREVENT_SCHEDULED) {
                dbWhereClause1 = ' (Id IN :recordIds) ';
            }else {
                dbWhereClause1 = ' ( SystemModstamp > :lastSystemModstamp ) ';
            }
            
            String dbWhereClause = '';
            if(config.dmpl__RuleSuccessCriteria__c == 'Custom Logic Is Met'){
                dbWhereClause = parseCustomCondition(
                    config.dmpl__RuleSuccessCustomLogic__c,
                    conditions);    
            }else if(config.dmpl__RuleSuccessCriteria__c == 'All Rules Are Met'){
                dbWhereClause = String.join(
                    conditions, 
                    ' AND ');
            }else if(config.dmpl__RuleSuccessCriteria__c == 'Any Rule Is Met'){
                dbWhereClause = String.join(
                    conditions, 
                    ' OR ');
            }
            if(String.isNotBlank(dbWhereClause1) || String.isNotBlank(dbWhereClause)){
                dbQuery += ' WHERE ';
            }
            if(!String.isEmpty(dbWhereClause1)){
                dbQuery += ' (' + dbWhereClause1 + ')';
            }
            if(!String.isEmpty(dbWhereClause)){
                if(!String.isEmpty(dbWhereClause1)){
                    dbQuery += ' AND ';
                }
                dbQuery += ' (' + dbWhereClause + ')';
            }
            System.debug('Query ' + dbQuery);
            return dbQuery;
        }

        private String parseCustomCondition(
            String customLogic,
            List<String> conditions
        ){
            return String.format(
                customLogic, 
                conditions);
        }

        @testVisible
        private String buildCondition(dmpl__KPIRules__c rule){
            return String.format(
                '{0} {1} {2}',
                new List<String>{
                    rule.dmpl__FieldName__c,
                    getOperator(rule),
                    (rule.dmpl__FieldValue__c == null) ? (null) : (rule.dmpl__FieldValue__c)
                });
        }

        @testVisible
        private String getOperator(dmpl__KPIRules__c rule){
            switch on rule.dmpl__Operation__c {
                when 'equals' {
                    return ' = ';
                }
                when 'notEqual' {
                    return ' != ';
                }
                when 'lessThan' {
                    return ' < ';
                }
                when 'greaterThan' {
                    return ' > ';
                }
                when 'lessOrEqual' {
                    return ' <= ';
                }
                when 'greaterOrEqual' {
                    return ' >= ';
                }
                when 'like' {
                    return ' LIKE ';
                }
                when 'in' {
                    return ' IN ';
                }
                when 'notIn' {
                    return ' NOT IN ';
                }
                when 'includes' {
                    return ' INCLUDES ';
                }
                when 'excludes' {
                    return ' EXCLUDES ';
                }
                when else {
                    return ' = ';
                }
            }
        }
    }
}