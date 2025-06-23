public with sharing class ResourceAvailabilityProcessor implements Database.Batchable<SObject> 
{
    public static final Integer BATCH_SIZE = 200;
    private Id invokedQueueId;
    private String batchQuery;
    private Decimal captureHalfDayTolerance;

    public static JobResponseResult perfromAction(
        Id recordId,
        Id queueId
    ){
        try {
            return processResourceAvailabilities(
                recordId,
                queueId);
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public ResourceAvailabilityProcessor(
        string query,
        string queueId
    ){
        this.batchQuery = query;
        this.invokedQueueId = queueId;
        this.captureHalfDayTolerance = OrgSettingHelper.OrgSetting()?.dmpl__HalfShiftTolerance__c;
    }

    private static string getResourceQuery()
    {
        return 'SELECT Id,'
            +' Name, '
            +'dmpl__BusinessHoursId__c, '
            +'dmpl__DefaultBranchId__c, '
            +'dmpl__DefaultBranchId__r.dmpl__PayrollBusinessHoursId__c '
            +'FROM  dmpl__Resource__c ';
    }

    public Database.QueryLocator start(
        Database.BatchableContext bc){
            try {
                InterfaceQueueHelper.addStatusUpdate(
                    invokedQueueId,
                    'Starting Resource Availability Batch'
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
        List<SObject> scope){
        try {
            System.debug('scope' + scope);
            List<dmpl__ResourceAvailability__c> toBeUpserted = new List<dmpl__ResourceAvailability__c>();
            Map<Id,dmpl__ResourceAvailability__c> resourceToAvailability = queryResourceAvailabilities(
                DocumentHelper.extractIds(
                    scope));
            Map<Id,Id> resourceBusinessHour = getResourceBusinessHour(scope);
            Map<Id,BusinessHours> currentBusinessHour = getCurrentBusinessHour(resourceBusinessHour.values());
            System.debug('resourceToAvailability ' + resourceToAvailability);
            System.debug('resourceBusinessHour ' + resourceBusinessHour);

            performAutoCheckOut(
                scope,
                resourceToAvailability,
                resourceBusinessHour);

            for(SObject record : scope){
                if((resourceBusinessHour == null
                || !resourceBusinessHour.containsKey(record.Id)) 
                || (resourceBusinessHour.containsKey(record.Id) 
                && System.BusinessHours.isWithin(resourceBusinessHour.get(record.Id),Date.Today()))
                || (resourceBusinessHour.containsKey(record.Id) 
                && !System.BusinessHours.isWithin(resourceBusinessHour.get(record.Id),Date.Today())
                && resourceToAvailability.containsKey(record.Id))){
                    dmpl__ResourceAvailability__c existingAvailability = resourceToAvailability.containsKey(record.Id) ? resourceToAvailability.get(record.Id) : null;
                    system.debug('existingAvailability ikiki ' + existingAvailability);
                    if(resourceBusinessHour.containsKey(record.Id)){
                        system.debug('resourceBusinessHour'+resourceBusinessHour.get(record.Id));
                        System.debug('is working ' + System.BusinessHours.isWithin(resourceBusinessHour.get(record.Id),Date.Today()));
                    }
                    if(existingAvailability!=null){
                        if(resourceBusinessHour.containsKey(record.Id)){
                            BusinessHours currentBusinessHourRec = currentBusinessHour.get(resourceBusinessHour.get(existingAvailability.dmpl__ResourceId__c));
                            Decimal fulldayTolerance = getFulldayTolerance(currentBusinessHourRec);
                            system.debug('fulldayTolerance' + fulldayTolerance);
                            if(existingAvailability.dmpl__Duration__c != null 
                            && (existingAvailability.dmpl__Duration__c > captureHalfDayTolerance  )){
                                system.debug('update the availability');
                                existingAvailability.dmpl__AvailabilityType__c = 'HalfDay';
                                toBeUpserted.add(existingAvailability);
                            }
                            if(existingAvailability.dmpl__Duration__c != null 
                            && existingAvailability.dmpl__Duration__c >= fulldayTolerance){
                                existingAvailability.dmpl__AvailabilityType__c = 'Present';
                                toBeUpserted.add(existingAvailability);
                            }else{
                                existingAvailability.dmpl__AvailabilityType__c = 'Absent';
                            	toBeUpserted.add(existingAvailability);
                            }
                        }
                        else{
                            existingAvailability.dmpl__AvailabilityType__c = 'Absent';
                            toBeUpserted.add(existingAvailability);
                        }
                    }else{
                        system.debug('insert the availability');
                        toBeUpserted.add(new dmpl__ResourceAvailability__c(
                            dmpl__AvailabilityType__c = 'Absent',
                            dmpl__ResourceId__c = record.Id,
                            dmpl__Date__c = Date.Today()
                        ));
                    }
                }
                else{
                    system.debug('marking holiday');
                    List<Holiday> holidays = getHolidays();
                    Date todayDate = Date.today();
                    for(Holiday holidayRecords : holidays){
                        if(todayDate == holidayRecords.ActivityDate){
                            System.debug('holiday' + Date.Today()+ ' ' + System.BusinessHours.isWithin(resourceBusinessHour.get(record.Id),Date.Today()));
                            dmpl__ResourceAvailability__c newRecord = new dmpl__ResourceAvailability__c(
                            dmpl__AvailabilityType__c = 'Holiday',
                            dmpl__ResourceId__c = record.Id,
                            dmpl__Date__c = Date.Today());
                            toBeUpserted.add(newRecord);
                        }
                        else{
                            System.debug('weekday ' + Date.Today()+ ' ' + System.BusinessHours.isWithin(resourceBusinessHour.get(record.Id),Date.Today()));
                            dmpl__ResourceAvailability__c newRecord = new dmpl__ResourceAvailability__c(
                            dmpl__AvailabilityType__c = 'Weekend',
                            dmpl__ResourceId__c = record.Id,
                            dmpl__Date__c = Date.Today());
                            toBeUpserted.add(newRecord);
                        }
                    }
                }
            }

            if(toBeUpserted.size() > 0 || toBeUpserted != null){
                upsert toBeUpserted;
            }
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
        try {
            InterfaceQueueHelper.addStatusUpdate(
                invokedQueueId,
                'Finished IG Batch');
        } catch (Exception error) {
            ExceptionLogHelper.logException(error, invokedQueueId);
            throw error;
        }
    }

    public static JobResponseResult processResourceAvailabilities(
        Id recordId,
        Id queueId
    ){
        string query = getResourceQuery();
        Id batchId = Database.executeBatch(
            new ResourceAvailabilityProcessor(
                query,
                queueId), 
            BATCH_SIZE);
        return new JobResponseResult(
            true, 
            null, 
            'Apex Batch Job Enqueued With Job Id ' + batchId);
    }

    public static Map<Id,Id> getResourceBusinessHour(
        List<SObject> scope
    ){ 
        Map<Id,Id> resourceBusinessHour = new Map<Id,Id>();
        List<Id> resourceIds = DocumentHelper.extractIds(scope);
        Map<Id,Id> businessHoursFirstPriorityMap = getResourceBusinessHourFirstPriority(resourceIds);
        for(dmpl__Resource__c record : (List<dmpl__Resource__c>)scope){
            if(businessHoursFirstPriorityMap.containsKey(record.Id)){
                resourceBusinessHour.put(record.Id,businessHoursFirstPriorityMap.get(record.Id));
            }else if(record.dmpl__BusinessHoursId__c != null 
            || record.dmpl__DefaultBranchId__r?.dmpl__PayrollBusinessHoursId__c != null){
                resourceBusinessHour.put(record.Id,
                record.dmpl__BusinessHoursId__c != null ? 
                record.dmpl__BusinessHoursId__c : 
                record.dmpl__DefaultBranchId__r?.dmpl__PayrollBusinessHoursId__c);
            }
        }
        return resourceBusinessHour;
    }

    public static Map<Id,Id> getResourceBusinessHourFirstPriority(
        List<Id> resourceIds){
        Map<Id,Id> businessHoursFirstPriority = new Map<Id,Id>();
        List<dmpl__ResourceBusinessHours__c> resourceBusinessHours = [
            SELECT Id,
            dmpl__BusinessHoursId__c,
            dmpl__ResourceId__c
            FROM dmpl__ResourceBusinessHours__c
            WHERE dmpl__ResourceId__c IN : resourceIds];
        for(dmpl__ResourceBusinessHours__c record : resourceBusinessHours){
            if(record.dmpl__ResourceId__c != null && record.dmpl__BusinessHoursId__c != null){
                businessHoursFirstPriority.put(record.dmpl__ResourceId__c,record.dmpl__BusinessHoursId__c);
            }
        }
        return businessHoursFirstPriority;
    }
    
    public static void performAutoCheckOut(
        List<SObject> newEntries,
        Map<Id,dmpl__ResourceAvailability__c> resourceToAvailability,
        Map<Id,Id> resourceBusinessHour
    ){
        List<dmpl__ResourceAvailability__c> toBeUpserted = new List<dmpl__ResourceAvailability__c>();
        List<dmpl__ResourceAvailabilityData__c> toBeInserted = new List<dmpl__ResourceAvailabilityData__c>();

        for(SObject record : newEntries){
            if(!resourceBusinessHour.containsKey(record.Id)
            || (resourceBusinessHour.containsKey(record.Id)
            && System.BusinessHours.isWithin(resourceBusinessHour.get(record.Id),Date.Today()))
            || (resourceBusinessHour.containsKey(record.Id)
            && !System.BusinessHours.isWithin(resourceBusinessHour.get(record.Id),Date.Today())
            && resourceToAvailability.containsKey(record.Id))
            ){
                dmpl__ResourceAvailability__c existingAvailability = resourceToAvailability.containsKey(record.Id) ? resourceToAvailability.get(record.Id) : null;
                system.debug(existingAvailability + ' existingAvailability');
                if(existingAvailability != null
                && existingAvailability.dmpl__ResourceAvailabilities__r.size() > 0
                && existingAvailability.dmpl__ResourceAvailabilities__r[0].dmpl__Type__c == 'Check-In'){
                    toBeInserted.add(new dmpl__ResourceAvailabilityData__c(
                        dmpl__Type__c = 'Check-Out',
                        dmpl__AttendenceTime__c = System.Now(),
                        dmpl__ResourceId__c = record.Id,
                        dmpl__ResourceAvailabilityId__c = existingAvailability.Id
                    ));
                }
            }
        }
        if(toBeInserted.size() > 0 || toBeInserted != null){
            insert toBeInserted;
        }
    }

    public static Map<Id,dmpl__ResourceAvailability__c> queryResourceAvailabilities(
        List<Id> resourceIds
    ){
        Map<Id,dmpl__ResourceAvailability__c> resourceToAvailability = new Map<Id,dmpl__ResourceAvailability__c>();
        List<dmpl__ResourceAvailability__c> availabilities = [SELECT Id,
                dmpl__ResourceId__c,
                dmpl__AvailabilityType__c,
                dmpl__Date__c,
                dmpl__Duration__c,
                (SELECT Id,
                    dmpl__Type__c
                FROM dmpl__ResourceAvailabilities__r
                ORDER BY createdDate DESC LIMIT 1)
            FROM dmpl__ResourceAvailability__c
            WHERE dmpl__Date__c = TODAY 
            AND dmpl__ResourceId__c IN : resourceIds];

        if(availabilities.size() <= 0){
            return resourceToAvailability;
        }
        for(dmpl__ResourceAvailability__c record : availabilities){
            resourceToAvailability.put(record.dmpl__ResourceId__c,record);
        }
        return resourceToAvailability;
    }

    private List<Holiday> getHolidays(){
        return [SELECT Id,
            Name,
            ActivityDate
            FROM Holiday];
    }

    private Map<Id,BusinessHours> getCurrentBusinessHour(List<Id> businessHoursId){
        List<BusinessHours> businessHoursrecords = [SELECT Id, Name, IsActive, MondayStartTime, MondayEndTime,
                        TuesdayStartTime, TuesdayEndTime, WednesdayStartTime, WednesdayEndTime,
                        ThursdayStartTime, ThursdayEndTime, FridayStartTime, FridayEndTime,
                        SaturdayStartTime, SaturdayEndTime, SundayStartTime, SundayEndTime
                FROM BusinessHours
                WHERE IsActive = true
                AND Id =: businessHoursId];
      Map<Id,BusinessHours> businessHourMap = new Map<Id,BusinessHours>();
      for(BusinessHours record :businessHoursrecords){
        businessHourMap.put(record.Id,record);
      }
      return businessHourMap;
    }

    private Decimal getFulldayTolerance(BusinessHours record){
        DateTime now = DateTime.now();
        String dayName = now.format('EEEE');
        Time startTime;
        Time endTime;

        switch on dayName {
            when 'Monday' {
                startTime = record.MondayStartTime;
                endTime = record.MondayEndTime;
            }
            when 'Tuesday' {
                startTime = record.TuesdayStartTime;
                endTime = record.TuesdayEndTime;
            }
            when 'Wednesday' {
                startTime = record.WednesdayStartTime;
                endTime = record.WednesdayEndTime;
            }
            when 'Thursday' {
                startTime = record.ThursdayStartTime;
                endTime = record.ThursdayEndTime;
            }
            when 'Friday' {
                startTime = record.FridayStartTime;
                endTime = record.FridayEndTime;
            }
        }
        if(startTime == null || endTime ==null)return 24;
        Decimal shiftHours = calculateShift(startTime,endTime);
        if(shiftHours == 0)shiftHours=24;
        return shiftHours;
    }

    private Decimal calculateShift(Time startTime,Time endTime){
        DateTime startDateTime = DateTime.newInstance(Date.today(), startTime);
        DateTime endDateTime = DateTime.newInstance(Date.today(), endTime);
        Long differenceInMillis = endDateTime.getTime() - startDateTime.getTime();
        Long differenceInMinutes = differenceInMillis / (1000 * 60); 
        Decimal shiftHours = differenceInMinutes/60;
        return shiftHours;
    }
}