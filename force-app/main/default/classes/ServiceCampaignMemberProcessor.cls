public with sharing class ServiceCampaignMemberProcessor implements Database.Batchable<SObject> {
    
    public static final Integer BATCH_SIZE = 200;
    private Id invokedQueueId;
    private Id serviceCampaignId;
    private String batchQuery;
    private dmpl__ServiceCampaign__c serviceCampaign;

    public static JobResponseResult perfromAction(
        Id recordId,
        Id queueId){
        try {
            dmpl__ServiceCampaign__c sc = queryServiceCampaignMember(recordId);
            if(sc.dmpl__DynamicMemberType__c == 'Report Data'){
                return processReportData(
                    recordId, 
                    queueId,
                    sc);
            }else{
                return processFieldsFilterData(
                    recordId,
                    queueId, 
                    sc);
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error, queueId);
            throw error;
        }
    }

    public ServiceCampaignMemberProcessor(
        Id agId,
        Id queueId,
        String query,
        dmpl__ServiceCampaign__c sc){
            invokedQueueId  =queueId;
            serviceCampaignId = agId;
            batchQuery = query;
            serviceCampaign = sc;
            System.debug(batchQuery);
    }

    public Database.QueryLocator start(
        Database.BatchableContext bc){
        try {
            InterfaceQueueHelper.addStatusUpdate(
                invokedQueueId,
                'Starting AG Batch '
            );
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
            List<dmpl__ServiceCampaignMember__c> members = new List<dmpl__ServiceCampaignMember__c>();
            for(SObject a : scope){
                Id accountId = null;
                Id assetId = null;
                if(serviceCampaign.dmpl__DynamicMemberObject__c == null 
                    || serviceCampaign.dmpl__DynamicMemberObject__c == 'Account'){
                    accountId = a.Id;
                } else if(serviceCampaign.dmpl__DynamicMemberObject__c == 'Asset'){
                    accountId = (Id)a.get('AccountId');
                    assetId = a.Id;
                } else {
                    accountId = (Id)a.get('dmpl__AccountId__c');
                    assetId = (Id)a.get('dmpl__AssetId__c');
                }
                members.add(
                    new dmpl__ServiceCampaignMember__c(
                        dmpl__ServiceCampaignId__c = serviceCampaignId,
                        dmpl__AccountId__c = accountId,
                        dmpl__AssetId__c = assetId,
                        dmpl__BatchInstanceId__c = bc.getJobId(),
                        dmpl__PartnerAccountId__c = serviceCampaign.dmpl__PartnerAccountId__c,
                        dmpl__BranchId__c = serviceCampaign.dmpl__BranchId__c
                    )
                );
            }      
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
                new ServiceCampaignMemberCleaner(
                    bc.getJobId(),
                    invokedQueueId,
                    serviceCampaignId
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
        dmpl__ServiceCampaign__c sc ){
        Id batchId = Database.executeBatch(
            new ServiceCampaignMemberProcessor(
                recordId,
                queueId,
                getFilterQuery(sc),
                sc
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
        dmpl__ServiceCampaign__c sc ){
        Report report = getReportRow(sc.dmpl__ReportId__c);
        if(report==null){
            throw new DMPLException('Report Not Found');
        }
        Reports.reportResults reportResult = Reports.ReportManager.runReport(report.Id, true);
        reportResult.getAllData();
        Reports.ReportFactWithDetails factDetails = 
            (Reports.ReportFactWithDetails)reportResult.getFactMap().get('T!T');
        List<Reports.ReportDetailRow> reportRows = factDetails.getRows();
        List<dmpl__ServiceCampaignMember__c> members = new List<dmpl__ServiceCampaignMember__c>();
        for(Reports.ReportDetailRow reportRow : reportRows){
            List<Reports.ReportDataCell> datacells = reportRow.getDataCells();
            Reports.ReportDataCell datacell = datacells[0];
            id accountId = (id)datacell.getValue();
            members.add(
                    new dmpl__ServiceCampaignMember__c(
                        dmpl__ServiceCampaignId__c = sc.Id,
                        dmpl__AccountId__c = accountId,
                        dmpl__BatchInstanceId__c = report.Id,
                        dmpl__PartnerAccountId__c = sc.dmpl__PartnerAccountId__c,
                        dmpl__BranchId__c = sc.dmpl__BranchId__c
                    )
                );
        }
        
        insert members;
        
        Database.executeBatch(
            new ServiceCampaignMemberCleaner(
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
    private static String getFilterQuery(dmpl__ServiceCampaign__c sc){
        String dbQuery = '';
        
        if(sc.dmpl__DynamicMemberObject__c == null || sc.dmpl__DynamicMemberObject__c == 'Account'){
            dbQuery = 'SELECT Id FROM Account ';
        } else if(sc.dmpl__DynamicMemberObject__c == 'Asset'){
            dbQuery = 'SELECT Id, AccountId FROM Asset ';
        } else {
            dbQuery = 'SELECT dmpl__AccountId__c, dmpl__AssetId__c FROM ' + sc.dmpl__DynamicMemberObject__c;
        }
        List<String> conditions = new List<String>();
        for(dmpl__ServiceCampaignRule__c rule : sc.dmpl__ServiceCampaignRules__r){
            conditions.add(buildCondition(rule));
        }
        if(sc.dmpl__RuleSuccessCriteria__c != null 
            && sc.dmpl__RuleSuccessCriteria__c != 'Always (No Criteria)'
            && conditions.size()>0){
            dbQuery += ' WHERE ';
        }

        if(sc.dmpl__RuleSuccessCriteria__c == 'Custom Logic Is Met'){
            dbQuery += parseCustomCondition(
                sc.dmpl__RuleSuccessCustomLogic__c,
                conditions);    
        }else if(sc.dmpl__RuleSuccessCriteria__c == 'All Rules Are Met'){
            dbQuery += String.join(
                conditions, 
                ' AND ');
        }else if(sc.dmpl__RuleSuccessCriteria__c == 'Any Rule Is Met'){
            dbQuery += String.join(
                conditions, 
                ' OR ');
        }
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
    private static String buildCondition(ServiceCampaignRule__c rule){
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
    private static String getOperator(dmpl__ServiceCampaignRule__c rule){
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

    private static dmpl__ServiceCampaign__c queryServiceCampaignMember(Id serviceCampaignId){
        return [
            SELECT 
                Id,
                dmpl__DynamicMemberType__c,
                dmpl__ReportId__c,
                dmpl__RuleSuccessCriteria__c,
                dmpl__RuleSuccessCustomLogic__c,
                dmpl__PartnerAccountId__c,
                dmpl__BranchId__c,
                dmpl__DynamicMemberObject__c,
                (SELECT
                    dmpl__SequenceNumber__c,
                    dmpl__FieldName__c,
                    dmpl__FieldValue__c,
                    dmpl__Operation__c
                FROM
                    dmpl__ServiceCampaignRules__r)
            FROM dmpl__ServiceCampaign__c
            WHERE 
                dmpl__IsActive__c = true
                AND Id =: serviceCampaignId
                AND (dmpl__StartDate__c =  null OR dmpl__StartDate__c <= TODAY)
                AND (dmpl__EndDate__c =  null OR dmpl__EndDate__c >= TODAY)
        ];
    }
}