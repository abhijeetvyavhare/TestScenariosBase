public class KPIConfigurationDataProcessor implements Database.Batchable<SObject>{
    public static final Integer BATCH_SIZE = 200;
    private Id invokedQueueId;
    private string dbQuery;
    private dmpl__KPIConfiguration__c config;
    private List<dmpl__IncentiveTarget__c> applicableTargets;
    private List<dmpl__IncentivePeriod__c> periods;
    private Boolean hasError = false;
    private Datetime lastSystemModstamp;
    private Datetime thisSystemModstamp;

    public KPIConfigurationDataProcessor(
        dmpl__KPIConfiguration__c config, 
        List<dmpl__IncentiveTarget__c> applicableTargets,
        List<dmpl__IncentivePeriod__c> periods,
        String query,
        Id queueId,
        Datetime executionDateTime){
        this.invokedQueueId = queueId;
        this.dbQuery = query;
        this.applicableTargets = applicableTargets;
        this.periods = periods;
        this.config = config;
        if(config.dmpl__LastExecutedSystemModstamp__c == null){
            this.lastSystemModstamp = Datetime.newInstance(2000, 1, 1, 1, 1, 1);
        }else{
            this.lastSystemModstamp = config.dmpl__LastExecutedSystemModstamp__c;
        }
        this.thisSystemModstamp = executionDateTime;
    }

    public Database.QueryLocator start(
        Database.BatchableContext bc){
        try {
            InterfaceQueueHelper.addStatusUpdate(
                invokedQueueId,
                'Starting KPIDataProcessor Batch '
            );
            return Database.getQueryLocatorWithBinds(
                this.dbQuery,
                new Map<String, Object>{
                    'lastSystemModstamp' => this.lastSystemModstamp
                },
                AccessLevel.SYSTEM_MODE);
        } catch (Exception error) {
            hasError = true;
            ExceptionLogHelper.logException(error, invokedQueueId);
            throw error;
        }
    }

    public void execute(
        Database.BatchableContext bc, 
        List<SObject> scope){
        try {
            System.debug('Scope  ' + scope);
            (new KPIConfigurationService()).createKPIData(
                config,
                applicableTargets,
                periods,
                scope);
            InterfaceQueueHelper.addStatusUpdate(
                invokedQueueId,
                'Processed Batch Count ' + scope.size()
            );
        } catch (Exception error) {
            hasError = true;
            ExceptionLogHelper.logException(error, invokedQueueId);
            throw error;
        }
    }

    public void finish(
        Database.BatchableContext bc){
        try {
            System.debug('Finished Batch ' + hasError);
            if(!hasError){
                config.dmpl__LastExecutedSystemModstamp__c = this.thisSystemModstamp;
                update config;
            }
            InterfaceQueueHelper.addStatusUpdate(
                invokedQueueId,
                'Finished Batch '
            );
        } catch (Exception error) {
            ExceptionLogHelper.logException(error, invokedQueueId);
            throw error;
        }
    }
}