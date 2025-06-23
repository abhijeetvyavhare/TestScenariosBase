@SuppressWarnings('PMD')
public with sharing class SchemeHelper {
    
    private static Boolean skipValidations = false;

    private static final String FIELD_SCHEME_VALID_TO = 'dmpl__ValidTo__c';
    private static final String FIELD_SCHEME_VALID_FROM = 'dmpl__ValidFrom__c';

    private static final string PERIODTYPE_YEARLY = 'Yearly';
    private static final string PERIODTYPE_QUATERLY = 'Quarterly';
    private static final string PERIODTYPE_MONTHLY = 'Monthly';
    private static final string PERIODTYPE_WEEKLY = 'Weekly';
    private static final string PERIODTYPE_BIWEEKLY = 'Bi Weekly';
    private static final string PERIODTYPE_DAILY = 'Daily';

    private static final String FIELD_SCHEME_PERFORMCLONESCHEME = 'dmpl__PerformCloneScheme__c';
    
    public static void validateData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__Scheme__c> oldEntries, 
        List<dmpl__Scheme__c> newEntries)
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
                ValidationHelper.validateIncrementalDates(
                    FIELD_SCHEME_VALID_FROM,
                    FIELD_SCHEME_VALID_TO,
                    newEntries);
                
            }else if(isUpdate){
                ValidationHelper.validateIncrementalDates(
                    FIELD_SCHEME_VALID_FROM,
                    FIELD_SCHEME_VALID_TO,
                    newEntries);
                
            }else if(isDelete){
               
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
        List<dmpl__Scheme__c> oldEntries, 
        List<dmpl__Scheme__c> newEntries)
    {
        try{
            if(isInsert){
                
            }else if(isUpdate){
                list<dmpl__Scheme__c> modifiedObjects = documentHelper.getApprovedObjects(FIELD_SCHEME_PERFORMCLONESCHEME,oldEntries, newEntries);
                    if(modifiedObjects.size()>0){
                        SchemeCloneHelper.cloneScheme(oldEntries, modifiedObjects);
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
        List<dmpl__Scheme__c> oldEntries, 
        List<dmpl__Scheme__c> newEntries)
    {
        try{
            if(isInsert){
                CreatePeriods(newEntries);
            }else if(isUpdate){
            }
        }
        catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void updateSchemeUtilizedAmount(List<dmpl__SchemeLedger__c> schemeLedgers){
        List<Id> schemeIds = DocumentHelper.extractIds(schemeLedgers, 'dmpl__SchemeId__c');
        Map<Id,dmpl__Scheme__c> schemes = querySchemes(schemeIds);
        for(dmpl__SchemeLedger__c schemeLedger : schemeLedgers)
        {
            dmpl__Scheme__c scheme = schemes.get(schemeLedger.dmpl__SchemeId__c);
            scheme.dmpl__UtilizedAmount__c = (scheme.dmpl__UtilizedAmount__c == null 
                                            ? 0 : scheme.dmpl__UtilizedAmount__c) 
                                            + (schemeLedger.dmpl__Discount__c > 0 
                                                ? schemeLedger.dmpl__NetSchemeDiscount__c 
                                            : schemeLedger.dmpl__DiscountAmount__c); 
        }

        if(schemes.size() > 0)
            update schemes.values();
    }

    public static void removeSchemeUtilizedAmount(List<dmpl__SchemeLedger__c> schemeLedgers){
        List<Id> schemeIds = DocumentHelper.extractIds(schemeLedgers, 'dmpl__SchemeId__c');
        Map<Id,dmpl__Scheme__c> schemes = querySchemes(schemeIds);
        for(dmpl__SchemeLedger__c schemeLedger : schemeLedgers)
        {
            dmpl__Scheme__c scheme = schemes.get(schemeLedger.dmpl__SchemeId__c);
            scheme.dmpl__UtilizedAmount__c = (scheme.dmpl__UtilizedAmount__c == null 
                                            ? 0 : scheme.dmpl__UtilizedAmount__c) 
                                            - (schemeLedger.dmpl__Discount__c > 0 
                                            ? (schemeLedger.dmpl__Discount__c * schemeLedger.dmpl__LineAmount__c/ 100) 
                                            : schemeLedger.dmpl__DiscountAmount__c); 
            // scheme.dmpl__UtilizedAmount__c = (scheme.dmpl__UtilizedAmount__c == null 
            //                                 ? 0 : scheme.dmpl__UtilizedAmount__c) 
            //                                 - (schemeLedger.dmpl__Discount__c > 0 
            //                                 ? schemeLedger.dmpl__NetSchemeDiscount__c
            //                                 : schemeLedger.dmpl__DiscountAmount__c); 
        }

        if(schemes.size() > 0)
            update schemes.values();
    }
    
    private static void CreatePeriods(List<dmpl__Scheme__c> newEntries){
        List<dmpl__SchemePeriod__c> periods = new List<dmpl__SchemePeriod__c>();
        for(dmpl__Scheme__c plan : newEntries){
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
    
	@testVisible
    private static List<dmpl__SchemePeriod__c> createYearlyPeriods(dmpl__Scheme__c scheme){
        if(scheme.dmpl__ValidFrom__c == null){
            scheme.dmpl__ValidFrom__c = Date.today();
        }
        if(scheme.dmpl__ValidTo__c == null){
            scheme.dmpl__ValidTo__c = scheme.dmpl__ValidFrom__c.addYears(1).addDays(-1);
        }

        return new List<dmpl__SchemePeriod__c>{
            new dmpl__SchemePeriod__c(
                Name = formatDate(scheme.dmpl__ValidFrom__c, 'MMMM - yyyy') + ' - ' + formatDate(scheme.dmpl__ValidTo__c, 'MMMM - yyyy'),
                dmpl__DateFrom__c = scheme.dmpl__ValidFrom__c,
                dmpl__DateTo__c = scheme.dmpl__ValidTo__c,
                dmpl__SchemeId__c = scheme.Id
            )
        };
    }
    
    private static List<dmpl__SchemePeriod__c> createQuarterlyPeriods(dmpl__Scheme__c plan){
        if(plan.dmpl__ValidFrom__c == null){
            plan.dmpl__ValidFrom__c = Date.today();
        }
        if(plan.dmpl__ValidTo__c == null){
            plan.dmpl__ValidTo__c = plan.dmpl__ValidFrom__c.addYears(1).addDays(-1);
        }

        Integer startMonth = plan.dmpl__ValidFrom__c.month();
        List<dmpl__SchemePeriod__c> periods = new List<dmpl__SchemePeriod__c>();
        for(Date bookingDate = Date.newInstance(plan.dmpl__ValidFrom__c.year(), startMonth, 1); 
            bookingDate <= plan.dmpl__ValidTo__c; 
            bookingDate = bookingDate.addMonths(3))
        {
            Date startDate = date.newInstance(bookingDate.year(),bookingDate.month(), 1);
            Date endDate = date.newInstance(bookingDate.year(),bookingDate.month(), 1).addMonths(3).addDays(-1);
            periods.add(
                new dmpl__SchemePeriod__c(
                    Name = formatDate(startDate, 'MMMM - yyyy') + ' - ' + formatDate(endDate, 'MMMM - yyyy'),
                    dmpl__DateFrom__c = startDate,
                    dmpl__DateTo__c = endDate,
                    dmpl__SchemeId__c = plan.Id
                )
            );
        }   
        return periods;
    }

    @testVisible
    private static List<dmpl__SchemePeriod__c> createMonthlyPeriods(dmpl__Scheme__c plan){
        if(plan.dmpl__ValidFrom__c == null){
            plan.dmpl__ValidFrom__c = Date.today();
        }
        if(plan.dmpl__ValidTo__c == null){
            plan.dmpl__ValidTo__c = plan.dmpl__ValidFrom__c.addYears(1).addDays(-1);
        }

        Integer startMonth = plan.dmpl__ValidFrom__c.month();
        List<dmpl__SchemePeriod__c> periods = new List<dmpl__SchemePeriod__c>();
        for(Date bookingDate = Date.newInstance(plan.dmpl__ValidFrom__c.year(), startMonth, 1); 
            bookingDate <= plan.dmpl__ValidTo__c; 
            bookingDate = bookingDate.addMonths(1))
        {
            periods.add(
                new dmpl__SchemePeriod__c(
                    Name = formatDate(bookingDate, 'MMMM - yyyy'),
                    dmpl__DateFrom__c = date.newInstance(bookingDate.year(),bookingDate.month(), 1),
                    dmpl__DateTo__c = date.newInstance(bookingDate.year(),bookingDate.month(), 1).addMonths(1).addDays(-1),
                    dmpl__SchemeId__c = plan.Id
                )
            );
        }   
        return periods;
    }

    @testVisible
    private static List<dmpl__SchemePeriod__c> createWeeklyPeriods(dmpl__Scheme__c plan, Integer noOfWeeks){
        if(plan.dmpl__ValidFrom__c == null){
            plan.dmpl__ValidFrom__c = Date.today();
        }
        if(plan.dmpl__ValidTo__c == null){
            plan.dmpl__ValidTo__c = plan.dmpl__ValidFrom__c.addMonths(1).addDays(-1);
        }

        Integer daysJump = 7 * noOfWeeks;
        if(noOfWeeks <= 0){
            noOfWeeks = 1;
        }
        List<dmpl__SchemePeriod__c> periods = new List<dmpl__SchemePeriod__c>();
        for(Date bookingDate = plan.dmpl__ValidFrom__c.toStartofWeek(); 
            bookingDate <= plan.dmpl__ValidTo__c; 
            bookingDate = bookingDate.addDays(daysJump))
        {
            periods.add(
                new dmpl__SchemePeriod__c(
                    Name = formatDate(bookingDate, 'dd - MMMM - yyyy') + ' - ' + formatDate(bookingDate.addDays(daysJump-1), 'dd - MMMM - yyyy'),
                    dmpl__DateFrom__c = bookingDate,
                    dmpl__DateTo__c = bookingDate.addDays(daysJump-1),
                    dmpl__SchemeId__c = plan.Id
                )
            );
        }   
        return periods;
    }

    @testVisible
    private static List<dmpl__SchemePeriod__c> createDailyPeriods(dmpl__Scheme__c plan){
        if(plan.dmpl__ValidFrom__c == null){
            plan.dmpl__ValidFrom__c = Date.today();
        }
        if(plan.dmpl__ValidTo__c == null){
            plan.dmpl__ValidTo__c = plan.dmpl__ValidFrom__c.addMonths(1).addDays(-1);
        }
        
        BusinessHours businessHours = null;
        if(plan.dmpl__BusinessHoursId__c != null){
            businessHours = BusinessHoursHelper.getCachedBusinessHours(plan?.dmpl__BusinessHoursId__c);
        }
        
        if(businessHours == null){
            businessHours = BusinessHoursHelper.getCachedDefaultBusinessHours();
        }

        List<dmpl__SchemePeriod__c> periods = new List<dmpl__SchemePeriod__c>();
        for(Date bookingDate = plan.dmpl__ValidFrom__c; 
            bookingDate <= plan.dmpl__ValidTo__c; 
            bookingDate = bookingDate.addDays(1))
        {
            if(!System.BusinessHours.isWithin(businessHours.Id, bookingDate)){
                continue;
            }

            periods.add(
                new dmpl__SchemePeriod__c(
                    Name = formatDate(bookingDate, 'dd - MMMM - yyyy'),
                    dmpl__DateFrom__c = bookingDate,
                    dmpl__DateTo__c = bookingDate,
                    dmpl__SchemeId__c = plan.Id
                )
            );
        }   
        return periods;
    }

    private static String formatDate(Date sourceDate, String stringFormat){
        Datetime dt = Datetime.newInstance(sourceDate.year(), sourceDate.month(), sourceDate.day());
        return dt.format(stringFormat);
    }

    public static void schemeConditionFilter(
        list<dmpl__SchemeCondition__c> conditions){
            set<id>slSet = new set<id>();
            list<dmpl__SchemeCondition__c> cond = new list<dmpl__SchemeCondition__c>();
            dmpl__SchemeLine__c schemeLineobj = new dmpl__SchemeLine__c();
            for(SchemeCondition__c condition : conditions){
                if(condition.dmpl__SchemeLineId__c != null){
                    slSet.add(condition.dmpl__SchemeLineId__c);
                    cond.add(condition);
                }
            }
            if(!slSet.isEmpty()){
                schemeLineobj = [ SELECT Id, dmpl__DefinitionFilterCriteria__c FROM dmpl__SchemeLine__c WHERE Id IN:slSet Limit 1];
            }
            if(schemeLineobj != null && schemeLineobj.dmpl__DefinitionFilterCriteria__c != null && schemeLineobj.dmpl__DefinitionFilterCriteria__c == 'Always (No Criteria)'){
                for(SchemeCondition__c condition : cond){
                    condition.addError('Scheme Condition cannot be added.');
                } 
                
            }
        }
    
    public static void schemeConditionPicklistFilter(
        list<dmpl__SchemeLine__c> schemeLine, Map<Id,dmpl__SchemeLine__c> oldMap){
            set<id>slSet = new set<id>();
            list<dmpl__SchemeLine__c> sLineList = new list<dmpl__SchemeLine__c>();
            list<dmpl__SchemeCondition__c> condition = new list<dmpl__SchemeCondition__c>();
            for(dmpl__SchemeLine__c schLine : schemeLine){
                if((oldMap != null || oldMap == null) && oldMap.get(schLine.Id).dmpl__DefinitionFilterCriteria__c != 'Always (No Criteria)'
                   && schLine.dmpl__DefinitionFilterCriteria__c == 'Always (No Criteria)')
                {
                    sLineList.add(schLine);
                    slSet.add(schLine.id);
                }
            }
            condition = [SELECT Id, dmpl__SchemeLineId__c FROM dmpl__SchemeCondition__c WHERE dmpl__SchemeLineId__c IN:slSet];
            if(!condition.isEmpty()){
                for(dmpl__SchemeLine__c schLine : sLineList){
                    schLine.addError('Definition Filter Criteria Cannot be Always as Scheme Condition Exists.');
                }
            }
        }
   
  
    public static void conditionTypeValidation(
        list<SchemeCondition__c> conditions, 
        Map<Id,SchemeCondition__c> oldMap){
            // for(SchemeCondition__c condition : conditions)
            //     if((oldMap != null || oldMap == null )&& condition.ConditionType__c != null || (oldMap.get(condition.id).ConditionType__c != condition.ConditionType__c))
            // {
            //     if(condition.ConditionType__c == 'Quantity' && condition.dmpl__ConditionQuantity__c == null 
            //        ||condition.ConditionType__c == 'Quantity' && condition.dmpl__ConditionOperator__c == null){
            //         condition.addError('Condition Quantity Required');
            //     }
                
            //     else if(condition.ConditionType__c == 'Value' && condition.dmpl__ConditionValue__c == null 
            //             ||condition.ConditionType__c == 'Value With Tax' && condition.dmpl__ConditionValue__c == null )
            //     {
            //         condition.addError('Condition Value Required');
            //     }
            //     else if(condition.ConditionType__c == 'Item Quantity' && condition.dmpl__ItemId__c == null || (condition.ConditionType__c == 'Item Quantity' && condition.dmpl__ConditionQuantity__c == null)
            //             || condition.ConditionType__c == 'Item Value' && condition.dmpl__ItemId__c == null  || (condition.ConditionType__c == 'Item Value' && condition.dmpl__ConditionValue__c == null) 
            //             || condition.ConditionType__c == 'Item Value With Tax' && condition.dmpl__ItemId__c == null || (condition.ConditionType__c == 'Item Value With Tax' && condition.dmpl__ConditionValue__c == null))
            //     {
            //         condition.addError('Item Required');
            //     }
            //     else if((condition.ConditionType__c == 'Item Group Quantity'|| condition.ConditionType__c == 'Item Group Value' || condition.ConditionType__c == 'Item Group Value With Tax') && condition.dmpl__ItemGroupId__c == null)
            //     {
            //         condition.addError('Item Group Required');
            //     }
            // }
        }
    
 
    public static void rewardTypeValidation(
        list<dmpl__SchemeBenefit__c> benefits,  Map<Id,dmpl__SchemeBenefit__c> oldMap){
            for(dmpl__SchemeBenefit__c benefit : benefits){
                if((oldMap != null || oldMap == null )&& benefit.dmpl__RewardType__c != null || (oldMap.get(benefit.id).dmpl__RewardType__c != benefit.dmpl__RewardType__c)){
                    if(benefit.dmpl__RewardType__c == 'Line Level Discount Percent' && benefit.dmpl__DiscountPercent__c== null)
                    {
                        benefit.addError('Discount Percent Required');
                    }
                    else if(benefit.dmpl__RewardType__c == 'Line Level Discount Amount' && benefit.dmpl__DiscountAmount__c== null)
                    {
                        benefit.addError('Discount Amount Required');
                    }
                    else if(benefit.dmpl__RewardType__c == 'Discounted Item' && benefit.dmpl__DiscountedItemId__c== null)
                    {
                        benefit.addError('Discounted Item Required');
                    }
                    else if(benefit.dmpl__RewardType__c == 'Discounted Item Group' && benefit.dmpl__DiscountedItemGroupId__c== null)
                    {
                        benefit.addError('Discounted Item Group Required');
                    }
                }
            }
        }

        private static Map<Id,dmpl__Scheme__c> querySchemes(List<Id> schemeIds)
        {
            SecurityHelper.ensureCanReadFields(new List<String>
            {
                'Id',
                'dmpl__UtilizedAmount__c'
            },'dmpl__Scheme__c');

            return new Map<Id, dmpl__Scheme__c>([ SELECT ID, 
                dmpl__UtilizedAmount__c
            FROM dmpl__Scheme__c
            WHERE Id IN: schemeIds]);
        }
}