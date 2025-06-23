public with sharing class MessageHelper {

    public static void evaluateMessageRules(
        String objectApiName,
        TriggerHandler.TriggerContext triggerContext,
        List<Id> recordIds){
            MessageService mss = new MessageService();
            List<dmpl__MessageConfiguration__c> configs = CollectionHelper.getObjectsByFilter(
                mss.getMessageConfigs(objectApiName),
                'dmpl__TriggerEvent__c',
                triggerContext.toString());
            if(configs == null || configs.size()==0){
                return;
            }
            evaluateMessageRulesInternal(
                objectApiName,
                triggerContext.toString(),
                recordIds);
            
    }

    public static JobResponseResult evaluateTimerMessageRules(Id queueId){
        try {
            MessageService mss = new MessageService();
            List<dmpl__MessageConfiguration__c> configs = CollectionHelper.getObjectsByFilter(
                mss.getMessageConfigs(),
                'dmpl__TriggerEvent__c',
                MessageService.FIELD_MESSAGE_TRIGGEREVENT_SCHEDULED);
            configs = CollectionHelper.getObjectsByFilterOrNull(
                configs,
                'dmpl__JobQueueId__c',
                queueId);
            if(configs == null || configs.size()==0){
                return new JobResponseResult(true);
            }
            for(dmpl__MessageConfiguration__c config : configs){
                mss.saveMessages(
                    mss.createMessages(
                        config,
                        getSourceObjects(
                            config, 
                            new List<Id>())));
            }
            return new JobResponseResult(true);
        } catch (Exception error) {
            ExceptionLogHelper.logException(
                error, 
                queueId);
            throw error;
        }
    }

    @future (callout=true)
    @testVisible
    private static void evaluateMessageRulesInternal(
        String objectApiName,
        String triggerContext,
        List<Id> recordIds){
            MessageService mss = new MessageService();
            List<dmpl__MessageConfiguration__c> configs = mss.getMessageConfigs(objectApiName);
            for(dmpl__MessageConfiguration__c config : configs){
                if(config.dmpl__TriggerEvent__c != triggerContext){
                    continue;
                }
                mss.saveMessages(
                    mss.createMessages(
                        config,
                        getSourceObjects(
                            config, 
                            recordIds)));
            }
    }

    @testVisible
    private static List<SObject> getSourceObjects(
        dmpl__MessageConfiguration__c config,
        List<Id> recordIds){
            String dbQuery = (new RuleEvaluator()).evaluateRules(config);
            return Database.query(dbQuery);
    }

    @testVisible
    private class RuleEvaluator{
        
        @testVisible
        private String evaluateRules(dmpl__MessageConfiguration__c config){
            List<String> fields = new List<String>{ 'Id' };
            fields.addAll(DynamicTextParser.getDynamicFieldList(config.dmpl__MessageBody__c 
                + config.dmpl__Recipient__c 
                + config.dmpl__Sender__c 
                + config.dmpl__SenderName__c 
                + config.dmpl__Subject__c));
            String dbQuery = 'SELECT '
                + String.join(fields, ',')
                + ' FROM ' 
                + config.dmpl__TriggerObjectName__c ;
            List<String> conditions = new List<String>();
            for(dmpl__MessageRule__c rule : config.dmpl__MessageRules__r){
                conditions.add(buildCondition(rule));
            }
            
            String dbWhereClause1 = null;
            if (config.dmpl__TriggerEvent__c != MessageService.FIELD_MESSAGE_TRIGGEREVENT_SCHEDULED) {
                dbWhereClause1 = ' (Id IN :recordIds) ';
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
        private String buildCondition(dmpl__MessageRule__c rule){
            return String.format(
                '{0} {1} {2}',
                new List<String>{
                    rule.dmpl__FieldName__c,
                    getOperator(rule),
                    (rule.dmpl__FieldValue__c == null) ? (null) : (rule.dmpl__FieldValue__c)
                });
        }

        @testVisible
        private String getOperator(dmpl__MessageRule__c rule){
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