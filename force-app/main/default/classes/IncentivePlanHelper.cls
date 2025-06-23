public with sharing class IncentivePlanHelper {

    private static Boolean skipValidations = false;
    private static final string OBJECT_INCENTIVEPLAN = 'dmpl__IncentivePlan__c';
    private static final string FIELD_INCENTIVEPLAN_STATUS = 'dmpl__Status__c';
    private static final string FIELD_INCENTIVEPLAN_BRANCHID = 'dmpl__BranchId__c';
    private static final string FIELD_INCENTIVEPLAN_PARTNERACCOUNTID = 'dmpl__PartnerAccountId__c';
    private static final string FIELD_INCENTIVEPLAN_PARTNERACCOUNTGROUPID = 'dmpl__PartnerAccountGroupId__c';
    private static final string FIELD_INCENTIVEPLAN_MEMBERTYPE = 'dmpl__MemberType__c';
    private static final string FIELD_INCENTIVEPLAN_PERIODTYPE = 'dmpl__PeriodType__c';
    private static final string FIELD_INCENTIVEPLAN_RESOURCETYPE = 'dmpl__MemberResourceType__c';
    private static final String FIELD_INCENTIVEPLAN_VALID_TO = 'dmpl__ValidTo__c';
    private static final String FIELD_INCENTIVEPLAN_VALID_FROM = 'dmpl__ValidFrom__c';
    private static final string MEMBERTYPE_PARTNER = 'Partner';
    private static final string MEMBERTYPE_BRANCH = 'Branch';
    private static final string MEMBERTYPE_RESOURCE = 'Resource';
    private static final string MEMBERTYPE_CUSTOMER = 'Customer';
    private static final string PERIODTYPE_YEARLY = 'Yearly';
    private static final string PERIODTYPE_QUATERLY = 'Quarterly';
    private static final string PERIODTYPE_MONTHLY = 'Monthly';
    private static final string PERIODTYPE_WEEKLY = 'Weekly';
    private static final string PERIODTYPE_BIWEEKLY = 'Bi Weekly';
    private static final string PERIODTYPE_DAILY = 'Daily';

    
    private static final List<String> LIST_NON_EDITABLE_FIELDS = new List<String>{
        FIELD_INCENTIVEPLAN_BRANCHID,
        FIELD_INCENTIVEPLAN_MEMBERTYPE,
        FIELD_INCENTIVEPLAN_PARTNERACCOUNTGROUPID,
        FIELD_INCENTIVEPLAN_PARTNERACCOUNTID,
        FIELD_INCENTIVEPLAN_PERIODTYPE,
        FIELD_INCENTIVEPLAN_RESOURCETYPE
    };
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{
    };
    
    public static void validateData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__IncentivePlan__c> oldEntries, 
        List<dmpl__IncentivePlan__c> newEntries)
    {   
        try{   
            if(isInsert){
                FieldMappingHelper.copyFieldMappingData(
                    newEntries);
            }
            if(skipValidations){
                return;
            }

            DocumentStatusDFSHelper dfsHelper = new DocumentStatusDFSHelper();
            if(isInsert){
                ValidationHelper.validateIncrementalDates(
                    FIELD_INCENTIVEPLAN_VALID_FROM,
                    FIELD_INCENTIVEPLAN_VALID_TO,
                    newEntries);
                accountOrAccountGroupValidation(newEntries);
                resourceValidation(newEntries);
                periodValidation(newEntries);
                StatusHelper.validateStatusNew(
                    OBJECT_INCENTIVEPLAN, 
                    FIELD_INCENTIVEPLAN_STATUS, 
                    newEntries);
            }else if(isUpdate){
                ValidationHelper.validateIncrementalDates(
                    FIELD_INCENTIVEPLAN_VALID_FROM,
                    FIELD_INCENTIVEPLAN_VALID_TO,
                    newEntries);
                accountOrAccountGroupValidation(newEntries);
                resourceValidation(newEntries);
                periodValidation(newEntries);
                StatusHelper.validateStatusEdit(
                    OBJECT_INCENTIVEPLAN, 
                    FIELD_INCENTIVEPLAN_STATUS, 
                    oldEntries, 
                    newEntries);
                DocumentHelper.validateChangeInSystemFields(
                    LIST_FIELDS_SYSTEM, 
                    oldEntries, 
                    newEntries);
                DocumentHelper.validateChangeInKeyFields(
                    LIST_NON_EDITABLE_FIELDS, 
                    oldEntries, 
                    newEntries, 
                    queryTransactedObjectIds(newEntries));
                dfsHelper.DocumentStatusRestrictEdits_Edit(
                    OBJECT_INCENTIVEPLAN, 
                    FIELD_INCENTIVEPLAN_STATUS, 
                    oldEntries, 
                    newEntries);
                dfsHelper.DocumentStatusRestrictFieldsEdits(
                    OBJECT_INCENTIVEPLAN, 
                    FIELD_INCENTIVEPLAN_STATUS, 
                    oldEntries, 
                    newEntries);
            }else if(isDelete){
                dfsHelper.DocumentStatusRestrictEdits_Delete(
                    OBJECT_INCENTIVEPLAN, 
                    FIELD_INCENTIVEPLAN_STATUS, 
                    oldEntries);
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
        List<dmpl__IncentivePlan__c> oldEntries, 
        List<dmpl__IncentivePlan__c> newEntries)
    {
        try{
            DocumentStatusDFSHelper dfsHelper = new DocumentStatusDFSHelper();
            if(isInsert){
                dfsHelper.DocumentStatusSetFlag(
                    OBJECT_INCENTIVEPLAN, 
                    FIELD_INCENTIVEPLAN_STATUS, 
                    newEntries);
                dfsHelper.DocumentStatusReSetFlag(
                    OBJECT_INCENTIVEPLAN, 
                    FIELD_INCENTIVEPLAN_STATUS, 
                    newEntries);
            }else if(isUpdate){
                dfsHelper.DocumentStatusSetFlag(
                    OBJECT_INCENTIVEPLAN, 
                    FIELD_INCENTIVEPLAN_STATUS, 
                    oldEntries, 
                    newEntries);
                dfsHelper.DocumentStatusReSetFlag(
                    OBJECT_INCENTIVEPLAN, 
                    FIELD_INCENTIVEPLAN_STATUS, 
                    oldEntries, 
                    newEntries);
                    List<dmpl__IncentivePlan__c> modifiedEntries = DocumentHelper.getApprovedObjects(
                        'dmpl__CopySourceTargets__c', 
                        oldEntries, 
                        newEntries);
                    if(modifiedEntries.size() > 0){
                        copyResourceTargets(modifiedEntries);
                    }
            }
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
        List<dmpl__IncentivePlan__c> oldEntries, 
        List<dmpl__IncentivePlan__c> newEntries)
    {
        try{
            DocumentStatusDFSHelper dfsHelper = new DocumentStatusDFSHelper();
            if(isInsert){
                List<Id>incentivePlanIds = DocumentHelper.extractIds(newEntries,'Id');
                if(incentivePlanIds.size()>0){
                    createInterfaceQueue(incentivePlanIds);
                }
                CreatePeriods(newEntries);
            }
        }
        catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static Id createSimulation(Map<Object,Object> data){
        dmpl__IncentivePeriod__c period = new dmpl__IncentivePeriod__c();
        if(data.containsKey('dmpl__IncentivePlanId__c')){
            period.dmpl__IncentivePlanId__c = (Id)data.get('dmpl__IncentivePlanId__c');
        }
        if(data.containsKey('dmpl__SimulationName__c')){
            period.dmpl__SimulationName__c = (String)data.get('dmpl__SimulationName__c');
        }
        if(data.containsKey('dmpl__SimulationType__c')){
            period.dmpl__SimulationType__c = (String)data.get('dmpl__SimulationType__c');
        }
        if(data.containsKey('dmpl__SimulationSourcePeriod__c')){
            period.dmpl__SimulationSourcePeriod__c = (Id)data.get('dmpl__SimulationSourcePeriod__c');
        }
        if(data.containsKey('dmpl__SimulationDeviation__c') && !String.isBlank((String) data.get('dmpl__SimulationDeviation__c'))){
            period.dmpl__SimulationDeviation__c = Decimal.valueOf((String) data.get('dmpl__SimulationDeviation__c'));
        }
        
        period.Name = period.dmpl__SimulationName__c + ' - ' + period.dmpl__SimulationType__c;
        
        insert period;
        return period.Id;
    }

    private static void copyResourceTargets(List<dmpl__IncentivePlan__c> newEntries){
        for(dmpl__IncentivePlan__c entry : newEntries){
            entry.dmpl__CopySourceTargets__c = false;
        }
    }

    private static void CreatePeriods(List<dmpl__IncentivePlan__c> newEntries){
        List<dmpl__IncentivePeriod__c> periods = new List<dmpl__IncentivePeriod__c>();
        for(dmpl__IncentivePlan__c plan : newEntries){
            if(plan.dmpl__PeriodType__c == PERIODTYPE_YEARLY){
                periods.addAll(createYearlyPeriods(plan));
            }else if(plan.dmpl__PeriodType__c == PERIODTYPE_QUATERLY){
                periods.addAll(createQuarterlyPeriods(plan));
            }else if(plan.dmpl__PeriodType__c == PERIODTYPE_MONTHLY){
                periods.addAll(createMonthlyPeriods(plan));
            }else if(plan.dmpl__PeriodType__c == PERIODTYPE_WEEKLY){
                periods.addAll(createWeeklyPeriods(plan, 1));
            }else if(plan.dmpl__PeriodType__c == PERIODTYPE_BIWEEKLY){
                periods.addAll(createWeeklyPeriods(plan, 2));
            }else if(plan.dmpl__PeriodType__c == PERIODTYPE_DAILY){
                periods.addAll(createDailyPeriods(plan));
            }
        }

        insert periods;
    }

    private static List<dmpl__IncentivePeriod__c> createYearlyPeriods(dmpl__IncentivePlan__c plan){
        if(plan.dmpl__PeriodStartDate__c == null){
            plan.dmpl__PeriodStartDate__c = Date.today();
        }
        if(plan.dmpl__PeriodEndDate__c == null){
            plan.dmpl__PeriodEndDate__c = plan.dmpl__PeriodStartDate__c.addYears(1).addDays(-1);
        }

        return new List<dmpl__IncentivePeriod__c>{
            new dmpl__IncentivePeriod__c(
                Name = formatDate(plan.dmpl__PeriodStartDate__c, 'MMMM - yyyy') + ' - ' + formatDate(plan.dmpl__PeriodEndDate__c, 'MMMM - yyyy'),
                dmpl__DateFrom__c = plan.dmpl__PeriodStartDate__c,
                dmpl__DateTo__c = plan.dmpl__PeriodEndDate__c,
                dmpl__IncentivePlanId__c = plan.Id
            )
        };
    }
    
    @testVisible
    private static List<dmpl__IncentivePeriod__c> createQuarterlyPeriods(dmpl__IncentivePlan__c plan){
        if(plan.dmpl__PeriodStartDate__c == null){
            plan.dmpl__PeriodStartDate__c = Date.today();
        }
        if(plan.dmpl__PeriodEndDate__c == null){
            plan.dmpl__PeriodEndDate__c = plan.dmpl__PeriodStartDate__c.addYears(1).addDays(-1);
        }

        Integer startMonth = plan.dmpl__PeriodStartDate__c.month();
        List<dmpl__IncentivePeriod__c> periods = new List<dmpl__IncentivePeriod__c>();
        for(Date bookingDate = Date.newInstance(plan.dmpl__PeriodStartDate__c.year(), startMonth, 1); 
            bookingDate <= plan.dmpl__PeriodEndDate__c; 
            bookingDate = bookingDate.addMonths(3))
        {
            Date startDate = date.newInstance(bookingDate.year(),bookingDate.month(), 1);
            Date endDate = date.newInstance(bookingDate.year(),bookingDate.month(), 1).addMonths(3).addDays(-1);
            periods.add(
                new dmpl__IncentivePeriod__c(
                    Name = formatDate(startDate, 'MMMM - yyyy') + ' - ' + formatDate(endDate, 'MMMM - yyyy'),
                    dmpl__DateFrom__c = startDate,
                    dmpl__DateTo__c = endDate,
                    dmpl__IncentivePlanId__c = plan.Id
                )
            );
        }   
        return periods;
    }

    @testVisible
    private static List<dmpl__IncentivePeriod__c> createMonthlyPeriods(dmpl__IncentivePlan__c plan){
        if(plan.dmpl__PeriodStartDate__c == null){
            plan.dmpl__PeriodStartDate__c = Date.today();
        }
        if(plan.dmpl__PeriodEndDate__c == null){
            plan.dmpl__PeriodEndDate__c = plan.dmpl__PeriodStartDate__c.addYears(1).addDays(-1);
        }

        Integer startMonth = plan.dmpl__PeriodStartDate__c.month();
        List<dmpl__IncentivePeriod__c> periods = new List<dmpl__IncentivePeriod__c>();
        for(Date bookingDate = Date.newInstance(plan.dmpl__PeriodStartDate__c.year(), startMonth, 1); 
            bookingDate <= plan.dmpl__PeriodEndDate__c; 
            bookingDate = bookingDate.addMonths(1))
        {
            periods.add(
                new dmpl__IncentivePeriod__c(
                    Name = formatDate(bookingDate, 'MMMM - yyyy'),
                    dmpl__DateFrom__c = date.newInstance(bookingDate.year(),bookingDate.month(), 1),
                    dmpl__DateTo__c = date.newInstance(bookingDate.year(),bookingDate.month(), 1).addMonths(1).addDays(-1),
                    dmpl__IncentivePlanId__c = plan.Id
                )
            );
        }   
        return periods;
    }

    @testVisible
    private static List<dmpl__IncentivePeriod__c> createWeeklyPeriods(dmpl__IncentivePlan__c plan, Integer noOfWeeks){
        if(plan.dmpl__PeriodStartDate__c == null){
            plan.dmpl__PeriodStartDate__c = Date.today();
        }
        if(plan.dmpl__PeriodEndDate__c == null){
            plan.dmpl__PeriodEndDate__c = plan.dmpl__PeriodStartDate__c.addMonths(1).addDays(-1);
        }

        Integer daysJump = 7 * noOfWeeks;
        if(noOfWeeks <= 0){
            noOfWeeks = 1;
        }
        List<dmpl__IncentivePeriod__c> periods = new List<dmpl__IncentivePeriod__c>();
        for(Date bookingDate = plan.dmpl__PeriodStartDate__c.toStartofWeek(); 
            bookingDate <= plan.dmpl__PeriodEndDate__c; 
            bookingDate = bookingDate.addDays(daysJump))
        {
            periods.add(
                new dmpl__IncentivePeriod__c(
                    Name = formatDate(bookingDate, 'dd - MMMM - yyyy') + ' - ' + formatDate(bookingDate.addDays(daysJump-1), 'dd - MMMM - yyyy'),
                    dmpl__DateFrom__c = bookingDate,
                    dmpl__DateTo__c = bookingDate.addDays(daysJump-1),
                    dmpl__IncentivePlanId__c = plan.Id
                )
            );
        }   
        return periods;
    }

    @testVisible
    private static List<dmpl__IncentivePeriod__c> createDailyPeriods(dmpl__IncentivePlan__c plan){
        if(plan.dmpl__PeriodStartDate__c == null){
            plan.dmpl__PeriodStartDate__c = Date.today();
        }
        if(plan.dmpl__PeriodEndDate__c == null){
            plan.dmpl__PeriodEndDate__c = plan.dmpl__PeriodStartDate__c.addMonths(1).addDays(-1);
        }
        
        BusinessHours businessHours = null;
        if(plan.dmpl__BusinessHoursId__c != null){
            businessHours = BusinessHoursHelper.getCachedBusinessHours(plan?.dmpl__BusinessHoursId__c);
        }
        
        if(businessHours == null){
            businessHours = BusinessHoursHelper.getCachedDefaultBusinessHours();
        }

        List<dmpl__IncentivePeriod__c> periods = new List<dmpl__IncentivePeriod__c>();
        for(Date bookingDate = plan.dmpl__PeriodStartDate__c; 
            bookingDate <= plan.dmpl__PeriodEndDate__c; 
            bookingDate = bookingDate.addDays(1))
        {
            if(!System.BusinessHours.isWithin(businessHours.Id, bookingDate)){
                continue;
            }

            periods.add(
                new dmpl__IncentivePeriod__c(
                    Name = formatDate(bookingDate, 'dd - MMMM - yyyy'),
                    dmpl__DateFrom__c = bookingDate,
                    dmpl__DateTo__c = bookingDate,
                    dmpl__IncentivePlanId__c = plan.Id
                )
            );
        }   
        return periods;
    }

    private static String formatDate(Date sourceDate, String stringFormat){
        Datetime dt = Datetime.newInstance(sourceDate.year(), sourceDate.month(), sourceDate.day());
        return dt.format(stringFormat);
    }

    private static List<Id> queryTransactedObjectIds(List<dmpl__IncentivePlan__c> newEntries){
        List<Id> incentivePlanIds = CollectionHelper.extractIds(newEntries);
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__IncentivePlanId__c'
        },'dmpl__IncentiveResource__c');
        List<Id> transactedIds = CollectionHelper.extractIds(
            [SELECT dmpl__IncentivePlanId__c
            FROM dmpl__IncentiveResource__c
            WHERE dmpl__IncentivePlanId__c IN :incentivePlanIds]);
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__IncentivePlanId__c'
        },'dmpl__IncentiveTarget__c');
        transactedIds.addAll(
            CollectionHelper.extractIds(
                [SELECT dmpl__IncentivePlanId__c
                FROM dmpl__IncentiveTarget__c
                WHERE dmpl__IncentivePlanId__c IN :incentivePlanIds]));
        return transactedIds;
    }
    
    private static void resourceValidation(List<dmpl__IncentivePlan__c> incentivePlans){
        for(dmpl__IncentivePlan__c incetivePlan : incentivePlans){
            if(incetivePlan.dmpl__MemberType__c != 'Resource' && incetivePlan.dmpl__ResourceType__c != null){
                incetivePlan.addError('Resource type can only be selected when member type is resource.');
            }
        }
    }

    private static void periodValidation(List<dmpl__IncentivePlan__c> incentivePlans){
        for(dmpl__IncentivePlan__c plan : incentivePlans){
            Date startDate = plan.dmpl__PeriodStartDate__c;
            Date endDate = plan.dmpl__PeriodEndDate__c;
            
            if((plan.dmpl__PeriodType__c == PERIODTYPE_WEEKLY 
                || plan.dmpl__PeriodType__c == PERIODTYPE_BIWEEKLY
                || plan.dmpl__PeriodType__c == PERIODTYPE_DAILY)){
                    if(startDate == null){
                        startDate = Date.today();
                    }
                    if(endDate == null){
                        endDate = startDate.addYears(1).addDays(-1);
                    }
        
                    if(startDate.daysBetween(endDate) > 366){
                        plan.addError('Period should not be more than 1 year for daily, weekly and bi-weekly period types.');
                    }
            }
        }
    }

    private static void accountOrAccountGroupValidation(List<dmpl__IncentivePlan__c> incentivePlans){
        for(dmpl__IncentivePlan__c incetivePlan : incentivePlans){
            if(incetivePlan.dmpl__PartnerAccountGroupId__c != null && incetivePlan.dmpl__PartnerAccountId__c != null ||(incetivePlan.dmpl__PartnerAccountGroupId__c != null && incetivePlan.dmpl__BranchId__c != null)){
                incetivePlan.addError('Either Partner Account Group Or Partner Account can be selected.');
            }
        }
    }

    private static Map<Id, List<Resource__c>> getIncentivePlanResourceMap(List<dmpl__IncentivePlan__c> records, List<Id> groupIds) {
        Map<Id, List<dmpl__Resource__c>> incentivePlanResourceMap = new Map<Id, List<dmpl__Resource__c>>();
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__IncentiveResourceGroupId__c'
        },'dmpl__Resource__c');
        List<dmpl__Resource__c> resources =[SELECT Id,Name,dmpl__IncentiveResourceGroupId__c FROM dmpl__Resource__c WHERE dmpl__IncentiveResourceGroupId__c IN :groupIds AND dmpl__IsActive__c = true];
        Map<Id, List<dmpl__Resource__c>> resourceGroupMap = new Map<Id, List<dmpl__Resource__c>>();
        for (dmpl__Resource__c res : resources) {
            if (!resourceGroupMap.containsKey(res.dmpl__IncentiveResourceGroupId__c)) {
                resourceGroupMap.put(res.dmpl__IncentiveResourceGroupId__c, new List<dmpl__Resource__c>());
            }
            resourceGroupMap.get(res.dmpl__IncentiveResourceGroupId__c).add(res);
        }
        for (dmpl__IncentivePlan__c plan : records) {
            if (resourceGroupMap.containsKey(plan.dmpl__ResourceGroupId__c)) {
                incentivePlanResourceMap.put(plan.Id, resourceGroupMap.get(plan.dmpl__ResourceGroupId__c));
            } else {
                incentivePlanResourceMap.put(plan.Id, new List<dmpl__Resource__c>());
            }
        }
        return incentivePlanResourceMap;
    }
    private static void createInterfaceQueue(List<Id> incentivePlanIds)
    {
        List<dmpl__InterfaceQueue__c> newInterfaceQueues = new List<dmpl__InterfaceQueue__c>();
        for(Id planIds : incentivePlanIds)
        {
            newInterfaceQueues.add(new dmpl__InterfaceQueue__c(
                dmpl__JobType__c = 'Incentive Resource Processor',
                dmpl__InterfaceRecordId__c = planIds,
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
}