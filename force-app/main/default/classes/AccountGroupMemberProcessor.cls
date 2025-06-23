public with sharing class AccountGroupMemberProcessor implements Database.Batchable<SObject> {
    
    public static final Integer BATCH_SIZE = 200;
    private Id invokedQueueId;
    private Id accountGroupId;
    private String batchQuery;

    public static JobResponseResult perfromAction(
        Id recordId,
        Id queueId){
        try {
            dmpl__AccountGroup__c ag = queryAccountGroup(recordId);
            if(ag.dmpl__DynamicMemberType__c == 'Report Data'){
                return processReportData(
                    recordId, 
                    queueId,
                    ag);
            }else{
                return processFieldsFilterData(
                    recordId,
                    queueId, 
                    ag);
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error, queueId);
            throw error;
        }
    }

    public AccountGroupMemberProcessor(
        Id agId,
        Id queueId,
        String query){
            invokedQueueId  =queueId;
            accountGroupId = agId;
            batchQuery = query;
    }

    public Database.QueryLocator start(
        Database.BatchableContext bc){
        try {
            InterfaceQueueHelper.addStatusUpdate(
                invokedQueueId,
                'Starting AG Batch '
            );
            System.debug('Starting Batch Query' + batchQuery);
            return Database.getQueryLocator(batchQuery);
        } catch (Exception error) {
            ExceptionLogHelper.logException(error, invokedQueueId);
            throw error;
        }
    }

    public void execute(
        Database.BatchableContext bc, 
        List<SObject> scope){
        try {
            List<dmpl__AccountGroupMember__c> members = new List<dmpl__AccountGroupMember__c>();
            for(SObject a : scope){
                members.add(
                    new dmpl__AccountGroupMember__c(
                        dmpl__AccountId__c = a.Id,
                        dmpl__AccountGroupId__c = accountGroupId,
                        dmpl__BatchInstanceId__c = bc.getJobId()
                    )
                );
            }      
            System.debug('Inserting' + members);
            insert members;
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
                'Finished AG Batch '
            );
        try {
            Database.executeBatch(
                new AccountGroupMemberCleaner(
                    bc.getJobId(),
                    invokedQueueId,
                    accountGroupId
                ), 
                BATCH_SIZE);
        } catch (Exception error) {
            ExceptionLogHelper.logException(error, invokedQueueId);
            throw error;
        }
    }

    @testVisible
    private static JobResponseResult processFieldsFilterData(
        Id recordId,
        Id queueId,
        dmpl__AccountGroup__c ag ){
        Id batchId = Database.executeBatch(
            new AccountGroupMemberProcessor(
                recordId,
                queueId,
                getFilterQuery(ag)
            ), 
            BATCH_SIZE);
        return new JobResponseResult(
            true, 
            null, 
            'Apex Batch Job Enqueued With Job Id ' + batchId);
    }
    
    @testVisible
    private static JobResponseResult processReportData(
        Id recordId,
        Id queueId,
        dmpl__AccountGroup__c ag ){
        Report report = getReportRow(ag.dmpl__ReportId__c);
        if(report==null){
            throw new DMPLException('Report Not Found');
        }
        Reports.reportResults reportResult = Reports.ReportManager.runReport(report.Id, true);
        reportResult.getAllData();
        Reports.ReportFactWithDetails factDetails = 
            (Reports.ReportFactWithDetails)reportResult.getFactMap().get('T!T');
        List<Reports.ReportDetailRow> reportRows = factDetails.getRows();
        System.debug('Value of reportRows.size()' + reportRows.size());
        List<dmpl__AccountGroupMember__c> members = new List<dmpl__AccountGroupMember__c>();
        for(Reports.ReportDetailRow reportRow : reportRows){
            List<Reports.ReportDataCell> datacells = reportRow.getDataCells();
            Reports.ReportDataCell datacell = datacells[0];
            id accountId = (id)datacell.getValue();
            members.add(
                    new dmpl__AccountGroupMember__c(
                        dmpl__AccountId__c = accountId,
                        dmpl__AccountGroupId__c = ag.Id,
                        dmpl__BatchInstanceId__c = report.Id
                    )
                );
        }
        
        insert members;
        

        Database.executeBatch(
            new AccountGroupMemberCleaner(
                report.Id,
                queueId
            ), 
            BATCH_SIZE);


        return new JobResponseResult(
            true, 
            null, 
            'Successfully Inserted Members ' + members.size());   

    }

    @testVisible
    private static String getFilterQuery(dmpl__AccountGroup__c ag){
        String dbQuery = 'SELECT Id FROM Account ';
        List<String> conditions = new List<String>();
        for(dmpl__AccountGroupRule__c rule : ag.dmpl__AccountGroupRules__r){
            conditions.add(buildCondition(rule));
        }
        if(ag.dmpl__RuleSuccessCriteria__c != null 
            && ag.dmpl__RuleSuccessCriteria__c != 'Always (No Criteria)'
            && conditions.size()>0){
            dbQuery += ' WHERE ';
        }

        if(ag.dmpl__RuleSuccessCriteria__c == 'Custom Logic Is Met'){
            dbQuery += parseCustomCondition(
                ag.dmpl__RuleSuccessCustomLogic__c,
                conditions);    
        }else if(ag.dmpl__RuleSuccessCriteria__c == 'All Rules Are Met'){
            dbQuery += String.join(
                conditions, 
                ' AND ');
        }else if(ag.dmpl__RuleSuccessCriteria__c == 'Any Rule Is Met'){
            dbQuery += String.join(
                conditions, 
                ' OR ');
        }
        System.debug('Query ' + dbQuery);
        return dbQuery;
    }
    
    @testVisible
    private static Report getReportRow(String reportName){
        List <Report> reportList = 
        [
            SELECT 
                Id, 
                DeveloperName 
            FROM 
                Report 
            WHERE 
                DeveloperName = :reportName];
        if(reportList!=null  && reportList.size()>0){
            return reportList[0];
        }
        return null;
    }

    private static String parseCustomCondition(
        String customLogic,
        List<String> conditions
    ){
        return String.format(
            customLogic, 
            conditions);
    }

    @testVisible
    private static String buildCondition(dmpl__AccountGroupRule__c rule){
        return String.format(
            '{0} {1} {2}',
            new List<String>{
                rule.dmpl__FieldName__c,
                getOperator(rule),
                rule.dmpl__FieldValue__c == null 
                    ? null : rule.dmpl__FieldValue__c
            });
    }

    @testVisible
    private static String getOperator(dmpl__AccountGroupRule__c rule){
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

    private static dmpl__AccountGroup__c queryAccountGroup(Id accountGroupId){
        return [
            SELECT 
                Id,
                dmpl__DynamicMemberType__c,
                dmpl__ReportId__c,
                dmpl__RuleSuccessCriteria__c,
                dmpl__RuleSuccessCustomLogic__c,
                (SELECT
                    dmpl__SequenceNumber__c,
                    dmpl__FieldName__c,
                    dmpl__FieldValue__c,
                    dmpl__Operation__c
                FROM
                    dmpl__AccountGroupRules__r
                    ORDER BY dmpl__SequenceNumber__c)
            FROM dmpl__AccountGroup__c
            WHERE 
                Id =:accountGroupId
        ];
    }
}