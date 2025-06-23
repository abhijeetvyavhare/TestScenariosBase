public with sharing class VisitPlanProcessor implements Database.Batchable<SObject> {
    public static final Integer BATCH_SIZE = 200;
    private Id invokedQueueId;
    private String batchQuery;

    public static JobResponseResult perfromAction(
        Id recordId,
        Id queueId){
        try {
            return processVisitPlans(
                recordId,
                queueId);
        } catch (Exception error) {
            ExceptionLogHelper.logException(
                error, 
                queueId);
            throw error;
        }
    }

    public VisitPlanProcessor(
        string query,
        string queueId
    ){
        this.batchQuery = query;
        this.invokedQueueId = queueId;
    }

    public Database.QueryLocator start(
        Database.BatchableContext bc
    ){
            try {
                InterfaceQueueHelper.addStatusUpdate(
                    invokedQueueId,
                    'Starting Visit Plan Batch'
                );
                System.debug('Executing Batch Query' + batchQuery);
                return Database.getQueryLocator(batchQuery);
            } catch (Exception error) {
                ExceptionLogHelper.logException(error, invokedQueueId);
                throw error;
            }
    }

    public void execute(
        Database.BatchableContext bc, 
        List<SObject> scope
    ){
        system.debug('Scope ' +scope);
        Map<Id,List<dmpl__VisitRoute__c>> resourceTovisitRoutes = getResourceToVisitRoutes(
            scope);
        Map<Id,dmpl__VisitPlan__c> resourceTovisitPlan = createVisitPlans(
            resourceTovisitRoutes);
        List<dmpl__Visit__c> newVisits = createVisits(
            resourceTovisitPlan,
            scope);
        system.debug('resourceTovisitRoutes ' +resourceTovisitRoutes);
        system.debug('resourceTovisitPlan ' +resourceTovisitPlan);
        system.debug('newVisits ' +newVisits);
    }

    public static JobResponseResult processVisitPlans(
        Id recordId,
        Id queueId
    ){
        string query = getVisitRoutesQuery();
        Id batchId = Database.executeBatch(
            new VisitPlanProcessor(
                query,
                queueId), 
            BATCH_SIZE);
        return new JobResponseResult(
            true, 
            null, 
            'Apex Batch Job Enqueued With Job Id ' + batchId);
    }

    private static string getVisitRoutesQuery()
    {
        String weekNumber = getCurrentWeekNumber();
        String dayNumber = getCurrentDayNumber();
        return 'SELECT Id,'
            +'Name, '
            +'dmpl__ResourceId__c, '
            +'dmpl__VisitPurpose__c, '
            +'dmpl__VisitTaskTemplateId__c, '
            +'dmpl__ResourceId__r.dmpl__DefaultBranchId__c, '
            +'dmpl__ResourceId__r.dmpl__DefaultPartnerAccountId__c, '
            +'dmpl__StartTime__c, '
            +'dmpl__VisitRouteGroupId__c, '
            +'(SELECT Id, '
            +'dmpl__AccountId__c, '
            +'dmpl__AccountId__r.dmpl__AccountLocation__c ,'
            +'dmpl__AccountId__r.dmpl__AccountLocation__Latitude__s,'
            +'dmpl__AccountId__r.dmpl__AccountLocation__Longitude__s '
            +'FROM dmpl__VisitRouteStops__r '
            +'WHERE dmpl__AccountId__r.dmpl__IsActive__c = true '
            +'AND dmpl__WeekNumbers__c LIKE \'%' + weekNumber + '%\' '
            +'AND  dmpl__DayNumbers__c LIKE \'%' + dayNumber + '%\') '
            +'FROM  dmpl__VisitRoute__c '
            +'WHERE dmpl__WeekNumbers__c LIKE \'%' + weekNumber + '%\' '
            +'AND dmpl__DayNumbers__c LIKE \'%' + dayNumber + '%\'';          
    }

    private static String getCurrentWeekNumber(){
        DateTime todayDate = System.today();
        DateTime startDateOfMonth = DateTime.newInstance(
            system.today().toStartOfMonth().year(), 
            system.today().toStartOfMonth().month(), 
            1);
        Integer week= Math.mod(Integer.valueOf(todayDate.format('w'))-Integer.valueOf(startDateOfMonth.format('w'))+1,7);
        return String.valueOf(week);
    }

    private static string getCurrentDayNumber(){
        DateTime todayDate = system.today();
        return String.valueOf(todayDate.format('u'));
    }

    @testvisible
    private static Map<Id,List<dmpl__VisitRoute__c>> getResourceToVisitRoutes(
        List<dmpl__VisitRoute__c> visitRoutes
    ){
        Map<Id,List<dmpl__VisitRoute__c>> resourceTovisitRoutes=new Map<Id,List<dmpl__VisitRoute__c>>();
        for(dmpl__VisitRoute__c record : visitRoutes){
            if(record.dmpl__ResourceId__c == null){
                continue;
            }
            if(!resourceTovisitRoutes.containsKey(record.dmpl__ResourceId__c)){
                resourceTovisitRoutes.put(record.dmpl__ResourceId__c, new List<dmpl__VisitRoute__c>());
            }
            resourceTovisitRoutes.get(record.dmpl__ResourceId__c).add(record);
        }
        return resourceTovisitRoutes;
    }

    private static Map<Id,dmpl__VisitPlan__c> createVisitPlans(
        Map<Id,List<dmpl__VisitRoute__c>> resourceTovisitRoutes
    ){
        Map<Id,dmpl__VisitPlan__c> resourceTovisitPlan=new map<Id,dmpl__VisitPlan__c>();
        try{
            List<dmpl__VisitPlan__c> toBeInserted= new List<dmpl__VisitPlan__c>();
            for(Id resourceId : resourceTovisitRoutes.keySet()){
                dmpl__VisitRoute__c referenceRecord = resourceTovisitRoutes.get(resourceId)[0];
                dmpl__VisitPlan__c newRecord=new dmpl__VisitPlan__c();
                newRecord.dmpl__PlanEndDate__c = System.Today();
                newRecord.dmpl__PlanStartDate__c = setPlanStartDate(referenceRecord.dmpl__StartTime__c);
                newRecord.dmpl__AssignedResourceId__c = resourceId;
                newRecord.dmpl__ExecutedResourceId__c = resourceId;
                newRecord.dmpl__VisitPurpose__c = referenceRecord.dmpl__VisitPurpose__c;
                newRecord.dmpl__VisitTaskTemplateId__c = referenceRecord.dmpl__VisitTaskTemplateId__c;
                newRecord.dmpl__BranchId__c = referenceRecord.dmpl__ResourceId__r.dmpl__DefaultBranchId__c;
                newRecord.dmpl__PartnerAccountId__c = referenceRecord.dmpl__ResourceId__r.dmpl__DefaultPartnerAccountId__c;
                newRecord.dmpl__VisitRouteGroupId__c=referenceRecord.dmpl__VisitRouteGroupId__c;
                // newRecord.statime
                // newRecord.endTime
                toBeInserted.add(newRecord);
            }
            if(toBeInserted.size() > 0){
                insert toBeInserted;
            }
            for(dmpl__VisitPlan__c record : toBeInserted){
                resourceTovisitPlan.put(record.dmpl__AssignedResourceId__c,record);
            }
            return resourceTovisitPlan;
        }catch(Exception e){
            ExceptionLogHelper.logException(e);
            system.debug(e.getMessage());
        }  
        return resourceTovisitPlan;      
    }

    private static List<dmpl__Visit__c> createVisits(
        Map<Id,dmpl__VisitPlan__c> resourceTovisitPlan,
        List<dmpl__VisitRoute__c> visitRoutes
    ){
        List<dmpl__Visit__c> toBeInserted=new List<dmpl__Visit__c>();
        try{
            system.debug(visitRoutes);
            for(dmpl__VisitRoute__c record : visitRoutes){
                Id visitplanId = resourceTovisitPlan.get(record.dmpl__ResourceId__c).Id;
                for(dmpl__VisitRouteStop__c visitRouteStop : record.dmpl__VisitRouteStops__r){
                    dmpl__Visit__c visit = new dmpl__Visit__c();
                    visit.dmpl__VisitPlanId__c=visitplanId;
                    visit.dmpl__PlannedDate__c = System.Today();
                    visit.dmpl__VisitRouteId__c = record.Id;
                    visit.dmpl__VisitRouteStopId__c = visitRouteStop.Id;
                    visit.dmpl__PartnerAccountId__c = record.dmpl__ResourceId__r.dmpl__DefaultPartnerAccountId__c;
                    visit.dmpl__BranchId__c = record.dmpl__ResourceId__r.dmpl__DefaultBranchId__c;
                    visit.dmpl__VisitTaskTemplateId__c = record.dmpl__VisitTaskTemplateId__c;
                    visit.dmpl__VisitPurpose__c = record.dmpl__VisitPurpose__c;
                    visit.dmpl__AccountId__c = visitRouteStop.dmpl__AccountId__c;
                    visit.dmpl__AssignedLocation__Latitude__s = visitRouteStop.dmpl__AccountId__r.dmpl__AccountLocation__Latitude__s;
                    visit.dmpl__AssignedLocation__Longitude__s = visitRouteStop.dmpl__AccountId__r.dmpl__AccountLocation__Longitude__s;
                    toBeInserted.add(visit);
                }
            }
            if(toBeInserted.size()>0){
                insert toBeInserted;
            }
        }catch(Exception e){
            ExceptionLogHelper.logException(e);
            system.debug(e.getMessage());
        }
        return toBeInserted;
    }

    public void finish(
        Database.BatchableContext bc){
        try {
            InterfaceQueueHelper.addStatusUpdate(
                invokedQueueId,
                'Finished IG Batch');
        } catch (Exception error) {
            ExceptionLogHelper.logException(error, invokedQueueId);
            throw error;
        }
    }

    private static DateTime setPlanStartDate(Time plantime){
        Date dt=System.Today();
        DateTime planStartDate = DateTime.newInstance(
            dt.year(),
            dt.month(),
            dt.day(),
            plantime.hour(),
            plantime.minute(),
            plantime.second()
        );
        return planStartDate;
    }
}