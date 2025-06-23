public with sharing class IncentiveTargetHelper {

    private static Boolean skipValidations = false;
    
    private static final List<String> LIST_NON_EDITABLE_FIELDS = new List<String>{
    };
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{
    };
    
    public static void validateData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__IncentiveTarget__c> oldEntries, 
        List<dmpl__IncentiveTarget__c> newEntries)
    {   
        try{   
            if(isInsert){
                FieldMappingHelper.copyFieldMappingData(
                    newEntries);
            }
            if(skipValidations){
                return;
            }
            if(isInsert){
            }
        }catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void postData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__IncentiveTarget__c> oldEntries, 
        List<dmpl__IncentiveTarget__c> newEntries)
    {
        try{
        }
        catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void afterPostData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__IncentiveTarget__c> oldEntries, 
        List<dmpl__IncentiveTarget__c> newEntries)
    {
        try{
            if(skipValidations){
                return;
            }
            if(isDelete){
                deleteIncentiveResourceTargets(oldEntries);
            }else if(isInsert){
                createInterfaceQueue(DocumentHelper.extractIds(newEntries,'Id'));

            }else if(isUpdate){
                List<dmpl__IncentiveTarget__c> modifiedObjects = DocumentHelper.getModifiedNewObjects(
                    new string[]{'dmpl__Value__c', 'dmpl__IncentivePeriodId__c', 'dmpl__TargetValueType__c'}, 
                    oldEntries, 
                    newEntries);
                if(modifiedObjects.size()>0){
                    deleteIncentiveResourceTargets(newEntries);
                    createInterfaceQueue(DocumentHelper.extractIds(modifiedObjects,'Id'));
                }
            }
        }
        catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    @testVisible
    private static void deleteIncentiveResourceTargets(List<dmpl__IncentiveTarget__c> incentiveTargets){
        List<dmpl__IncentiveResourceTarget__c> existingResourceTargets = queryIncentiveResourceTargets(
            CollectionHelper.extractIds(
                incentiveTargets, 
                'Id'));

        List<dmpl__IncentiveResourceTarget__c> filteredResourceTargets = new List<dmpl__IncentiveResourceTarget__c>();
        for(dmpl__IncentiveTarget__c target : incentiveTargets){
            if(target.dmpl__TargetValueType__c == 'Resource Target' 
                || target.dmpl__TargetValueType__c == 'Resource Target Percentage'){
                continue;
            }else{
                filteredResourceTargets.addAll((List<dmpl__IncentiveResourceTarget__c>)CollectionHelper.getObjectsByFilter(
                    existingResourceTargets, 
                    'dmpl__IncentiveTargetId__c', 
                    target.Id));       
            }
        }
        if(filteredResourceTargets.size() > 0){
            delete filteredResourceTargets;
        }
    }

    private static void createInterfaceQueue(List<Id> targetId)
    {
        List<dmpl__InterfaceQueue__c> newInterfaceQueues = new List<dmpl__InterfaceQueue__c>();
        for(Id ids : targetId)
        {
            newInterfaceQueues.add(new dmpl__InterfaceQueue__c(
                dmpl__JobType__c = 'Incentive Target Processor',
                dmpl__InterfaceRecordId__c = ids,
                dmpl__QueueType__c = 'Queueable'
            ));
        }

        SecurityHelper.ensureCanCreateObject('dmpl__InterfaceQueue__c');
        SecurityHelper.ensureCanCreateFields(
            new string[]{
                'dmpl__JobType__c',
                'dmpl__InterfaceRecordId__c',
                'dmpl__QueueType__c'
            }, 'dmpl__InterfaceQueue__c');

        insert newInterfaceQueues;
    }

    @testVisible
    private static List<dmpl__IncentiveResource__c> queryIncentiveResources(
        List<Id> incentivePlanIds){
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__IncentivePlanId__c'
        },'dmpl__IncentiveResource__c');
        return 
            [SELECT 
                Id, 
                dmpl__IncentivePlanId__c
            FROM 
                dmpl__IncentiveResource__c
            WHERE 
                dmpl__IncentivePlanId__c IN :incentivePlanIds];
    }

    @testVisible
    private static List<dmpl__IncentivePeriod__c> queryIncentivePeriods(
        List<Id> incentivePlanIds){
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__IncentivePlanId__c'
        },'dmpl__IncentivePeriod__c');
        return 
            [SELECT 
                Id, 
                dmpl__IncentivePlanId__c,
                dmpl__DateFrom__c
            FROM 
                dmpl__IncentivePeriod__c
            WHERE 
                dmpl__IncentivePlanId__c IN :incentivePlanIds
                AND dmpl__SimulationType__c = null];
    }

    @testVisible
    private static List<dmpl__IncentiveResourceTarget__c> queryIncentiveResourceTargets(
        List<Id> incentiveTargetIds){
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__IncentiveTargetId__c'
        },'dmpl__IncentiveResourceTarget__c');
        return 
            [SELECT 
                Id, 
                dmpl__IncentiveTargetId__c
            FROM 
                dmpl__IncentiveResourceTarget__c
            WHERE 
                dmpl__IncentiveTargetId__c IN :incentiveTargetIds];
    }
    @testVisible
    private static List<dmpl__IncentiveTarget__c> queryIncentiveTargets(
        List<Id> incentiveTargetIds){
        return 
            [SELECT 
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
                Id IN :incentiveTargetIds];
    }
}