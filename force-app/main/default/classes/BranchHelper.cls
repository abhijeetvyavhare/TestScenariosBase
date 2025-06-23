@namespaceAccessible
public with sharing class BranchHelper {
    private static Boolean skipValidations = false;
    private static final string OBJECT_BRANCH = 'dmpl__Branch__c';
    private static final string OBJECT_ACCOUNT = 'Account';
    private static final string FIELD_BRANCH_PARTNERACCOUNTID = 'dmpl__PartnerAccountId__c';

    private static final List<String> LIST_NON_EDITABLE_FIELDS = new List<String>{};
    private static final List<String> LIST_FIELDS_SOURCEPOULATED = new List<String>{};
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{};

    public static void validateData(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__Branch__c> oldEntries, List<dmpl__Branch__c> newEntries)
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
            }else if(isUpdate){
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, oldEntries, newEntries);
            }else if(isDelete){
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void postData(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__Branch__c> oldEntries, List<dmpl__Branch__c> newEntries)
    {
        if(isUpdate){
            OrgCacheHelper.removeSObjects(OBJECT_ACCOUNT, DocumentHelper.extractIds(newEntries, FIELD_BRANCH_PARTNERACCOUNTID));
        }
    }

    @namespaceAccessible
    public static List<BranchDateSlotResult> getBranchDateSlots(String transactionType, Id branchId, Id itemId, String serviceType, String serviceJobType, Integer daysCount){
        dmpl__Branch__c branch = (dmpl__Branch__c)CollectionHelper.getFirstIfExists(BranchHelper.getCachedBranches(new List<Id>{branchId}));
        dmpl__Item__c item = (dmpl__Item__c)CollectionHelper.getFirstIfExists(ItemHelper.getCachedItems(new List<Id>{itemId}));
        Id itemGroupId = item?.dmpl__ProductDemoItemGroup__c;
        BusinessHours businessHours = null;
        if(branch?.dmpl__BusinessHoursId__c != null){
            businessHours = BusinessHoursHelper.getCachedBusinessHours(branch?.dmpl__BusinessHoursId__c);
        }
        
        if(businessHours == null){
            businessHours = BusinessHoursHelper.getCachedDefaultBusinessHours();
        }

        List<Date> dates = new List<Date>();
        for(Date bookingDate = Date.today(); bookingDate<Date.today().addDays(daysCount); bookingDate = bookingDate.addDays(1)){
            if(System.BusinessHours.isWithin(businessHours.Id, bookingDate)){
                dates.add(bookingDate);
            }
        }

        SecurityHelper.ensureCanReadFields(new String[]{
            'dmpl__BookingDate__c',
            'dmpl__Capacity__c',
            'dmpl__CapacityUtilized__c'
        }, 'dmpl__BranchTimeSlotBooking__c');
        List<AggregateResult> dateCapacities= [
            SELECT dmpl__BookingDate__c BookingDate,
                dmpl__BranchTimeSlotId__c BranchTimeSlotId,
                Sum(dmpl__Capacity__c) Capacity,
                Sum(dmpl__CapacityUtilized__c) CapacityUtilized
            FROM dmpl__BranchTimeSlotBooking__c
            WHERE dmpl__BookingDate__c IN:dates
                AND dmpl__BranchTimeSlotId__r.dmpl__TransactionType__c =:transactionType
                AND dmpl__BranchTimeSlotId__r.dmpl__IsActive__c =true
                AND dmpl__BranchTimeSlotId__r.dmpl__BranchId__c =:branchId
                AND (
                        (dmpl__BranchTimeSlotId__r.dmpl__ApplicableToItem__c = null
                            AND dmpl__BranchTimeSlotId__r.dmpl__ApplicableToItemGroup__c = null)
                        OR dmpl__BranchTimeSlotId__r.dmpl__ApplicableToItem__c =: itemId
                        OR dmpl__BranchTimeSlotId__r.dmpl__ApplicableToItemGroup__c =: itemGroupId
                    )
                AND (
                    dmpl__BranchTimeSlotId__r.dmpl__ServiceType__c = null
                    OR dmpl__BranchTimeSlotId__r.dmpl__ServiceType__c =: serviceType)
                AND (
                    dmpl__BranchTimeSlotId__r.dmpl__ServiceJobType__c = null
                    OR dmpl__BranchTimeSlotId__r.dmpl__ServiceJobType__c =: serviceJobType)
            GROUP BY dmpl__BookingDate__c, dmpl__BranchTimeSlotId__c];

        List<BranchDateSlotResult> returnList = new List<BranchDateSlotResult>(); 
        for(Date bookingDate : dates){
            returnList.add(getDailyCapcity(bookingDate, branch, transactionType, itemId, serviceType, serviceJobType, dateCapacities));
        }
        return returnList;
    }
    
    @namespaceAccessible
    public static List<dmpl__BranchTimeSlot__c> getBranchTimeSlots(String transactionType, Id branchId, Id itemId, String serviceType, String serviceJobType, Date bookingDate){
        dmpl__Item__c item = (dmpl__Item__c)CollectionHelper.getFirstIfExists(ItemHelper.getCachedItems(new List<Id>{itemId}));
        Id itemGroupId = item?.dmpl__ProductDemoItemGroup__c;
        SecurityHelper.ensureCanReadFields(new String[]{
            'Name',
            'dmpl__DisplayName__c',
            'dmpl__StartTime__c',
            'dmpl__EndTime__c'
        }, 'dmpl__BranchTimeSlot__c');
        SecurityHelper.ensureCanReadFields(new String[]{
            'dmpl__BookingDate__c',
            'dmpl__Capacity__c',
            'dmpl__CapacityUtilized__c',
            'dmpl__FridayCapacity__c',
            'dmpl__MondayCapacity__c',
            'dmpl__SaturdayCapacity__c',
            'dmpl__SundayCapacity__c',
            'dmpl__ThursdayCapacity__c',
            'dmpl__TuesdayCapacity__c',
            'dmpl__WednesdayCapacity__c'
        }, 'dmpl__BranchTimeSlotBooking__c');
        List<dmpl__BranchTimeSlot__c> timeSlots = [
            SELECT Id,
                Name,
                dmpl__StartTime__c,
                dmpl__EndTime__c,
                dmpl__DisplayName__c,
                dmpl__MaximumCapacity__c,
                dmpl__FridayCapacity__c,
                dmpl__MondayCapacity__c,
                dmpl__SaturdayCapacity__c,
                dmpl__SundayCapacity__c,
                dmpl__ThursdayCapacity__c,
                dmpl__TuesdayCapacity__c,
                dmpl__WednesdayCapacity__c,
                (SELECT dmpl__Capacity__c,
                dmpl__CapacityUtilized__c
                FROM dmpl__BranchTimeSlotBookings__r
                WHERE dmpl__BookingDate__c =:bookingDate
                LIMIT 1)
            FROM dmpl__BranchTimeSlot__c
            WHERE 
                dmpl__TransactionType__c =:transactionType
                AND dmpl__IsActive__c =true
                AND dmpl__BranchId__c =:branchId
                AND (
                    (dmpl__ApplicableToItem__c = null AND dmpl__ApplicableToItemGroup__c = null)
                    OR dmpl__ApplicableToItem__c =: itemId
                    OR dmpl__ApplicableToItemGroup__c =: itemGroupId)
                AND (
                    dmpl__ServiceType__c = null
                    OR dmpl__ServiceType__c =: serviceType)
                AND (
                    dmpl__ServiceJobType__c = null
                    OR dmpl__ServiceJobType__c =: serviceJobType)
            ORDER BY dmpl__StartTime__c];
        
        for(dmpl__BranchTimeSlot__c timeSlot : timeSlots){
            timeSlot.dmpl__MaximumCapacity__c = getDayOfWeekCapacity(bookingDate, timeSlot);
        }
        return timeSlots;
    }

    @namespaceAccessible
    public static List<dmpl__Branch__c> getCachedBranches(List<Id> branchIds){
        if (!OrgCacheHelper.isPlatformCacheEnabled(OBJECT_BRANCH)){
            return queryBranches(branchIds);
        }
        List<dmpl__Branch__c> branches = new List<dmpl__Branch__c>();
        List<Id> missingBranchIds = new List<Id>();
        for(Id branchId : branchIds){
            dmpl__Branch__c branch = (dmpl__Branch__c)OrgCacheHelper.getSObject(OBJECT_BRANCH, branchId);
            if(branch == null){
                missingBranchIds.add(branchId);
            }else{
                branches.add(branch);
            }
        }
        if(missingBranchIds.size()>0){
            List<dmpl__Branch__c> missingbranches = queryBranches(missingBranchIds);
            OrgCacheHelper.setSObjects(missingbranches);
            branches.addAll(missingbranches);
        }

        return branches;
    }

    @namespaceAccessible
    public static List<dmpl__Branch__c> getNearbyBranches(string postalCode, string cityName, Integer radius){
        if(!String.isBlank(postalCode)){
            postalCode = postalCode + '%';
        }
        if(!String.isBlank(cityName)){
            cityName = cityName + '%';
        }
        SecurityHelper.ensureCanReadFields(new String[]{
            'Name',
            'dmpl__AllowInventory__c',
            'dmpl__AllowPurchase__c',
            'dmpl__AllowSales__c',
            'dmpl__AllowService__c',
            'dmpl__BranchType__c',
            'dmpl__BusinessHoursId__c',
            'dmpl__InventoryValuationMethod__c',
            'dmpl__IsActive__c',
            'dmpl__IsHomeDeliveryAvailable__c',
            'dmpl__IsPickupDropAvailable__c',
            'dmpl__MarketingName__c',
            'dmpl__MobileNumber__c',
            'dmpl__Email__c',
            'dmpl__Phone__c',
            'dmpl__SalesPhone__c',
            'dmpl__ServicePhone__c',
            'dmpl__SalesEmail__c',
            'dmpl__ServiceEmail__c',
            'dmpl__PartnerAccountId__c',
            'dmpl__AddressId__c',
            'dmpl__GeoLocation__c',
            'dmpl__Website__c'
        }, OBJECT_BRANCH);
        SecurityHelper.ensureCanReadFields(new String[]{
            'dmpl__City__c',
            'dmpl__State__c',
            'dmpl__Country__c',
            'dmpl__PostalCode__c',
            'dmpl__Street__c'
        }, 'dmpl__ContactAddress__c');
        if(String.isBlank(postalCode) && String.isBlank(cityName)){
            return [SELECT Id,
                Name,
                dmpl__AllowInventory__c,
                dmpl__AllowPurchase__c,
                dmpl__AllowSales__c,
                dmpl__AllowService__c,
                dmpl__BranchType__c,
                dmpl__BusinessHoursId__c,
                dmpl__InventoryValuationMethod__c,
                dmpl__IsActive__c,
                dmpl__IsHomeDeliveryAvailable__c,
                dmpl__IsPickupDropAvailable__c,
                dmpl__MarketingName__c,
                dmpl__MobileNumber__c,
                dmpl__Email__c,
                dmpl__Phone__c,
                dmpl__SalesPhone__c,
                dmpl__ServicePhone__c,
                dmpl__SalesEmail__c,
                dmpl__ServiceEmail__c,
                dmpl__PartnerAccountId__c,
                dmpl__AddressId__c,
                dmpl__GeoLocation__c,
                dmpl__Website__c,
                dmpl__AddressId__r.dmpl__City__c,
                dmpl__AddressId__r.dmpl__State__c,
                dmpl__AddressId__r.dmpl__Country__c,
                dmpl__AddressId__r.dmpl__PostalCode__c,
                dmpl__AddressId__r.dmpl__Street__c
            FROM dmpl__Branch__c
            WHERE dmpl__IsActive__c = true];
        } else if(!String.isBlank(postalCode)){
            return [SELECT Id,
                    Name,
                    dmpl__AllowInventory__c,
                    dmpl__AllowPurchase__c,
                    dmpl__AllowSales__c,
                    dmpl__AllowService__c,
                    dmpl__BranchType__c,
                    dmpl__BusinessHoursId__c,
                    dmpl__InventoryValuationMethod__c,
                    dmpl__IsActive__c,
                    dmpl__IsHomeDeliveryAvailable__c,
                    dmpl__IsPickupDropAvailable__c,
                    dmpl__MarketingName__c,
                    dmpl__MobileNumber__c,
                    dmpl__Email__c,
                    dmpl__Phone__c,
                    dmpl__SalesPhone__c,
                    dmpl__ServicePhone__c,
                    dmpl__SalesEmail__c,
                    dmpl__ServiceEmail__c,
                    dmpl__PartnerAccountId__c,
                    dmpl__AddressId__c,
                    dmpl__GeoLocation__c,
                    dmpl__Website__c,
                    dmpl__AddressId__r.dmpl__City__c,
                    dmpl__AddressId__r.dmpl__State__c,
                    dmpl__AddressId__r.dmpl__Country__c,
                    dmpl__AddressId__r.dmpl__PostalCode__c,
                    dmpl__AddressId__r.dmpl__Street__c
                FROM dmpl__Branch__c
                WHERE Id IN(
                    SELECT dmpl__BranchId__c 
                    FROM dmpl__BranchPostalCode__c
                    WHERE dmpl__PostalCodeId__r.Name LIKE :postalCode
                ) AND dmpl__IsActive__c = true];
        } else if(!String.isBlank(cityName)){
        return [SELECT Id,
                Name,
                dmpl__AllowInventory__c,
                dmpl__AllowPurchase__c,
                dmpl__AllowSales__c,
                dmpl__AllowService__c,
                dmpl__BranchType__c,
                dmpl__BusinessHoursId__c,
                dmpl__InventoryValuationMethod__c,
                dmpl__IsActive__c,
                dmpl__IsHomeDeliveryAvailable__c,
                dmpl__IsPickupDropAvailable__c,
                dmpl__MarketingName__c,
                dmpl__MobileNumber__c,
                dmpl__Email__c,
                dmpl__Phone__c,
                dmpl__SalesPhone__c,
                dmpl__ServicePhone__c,
                dmpl__SalesEmail__c,
                dmpl__ServiceEmail__c,
                dmpl__PartnerAccountId__c,
                dmpl__AddressId__c,
                dmpl__GeoLocation__c,
                dmpl__Website__c,
                dmpl__AddressId__r.dmpl__City__c,
                dmpl__AddressId__r.dmpl__State__c,
                dmpl__AddressId__r.dmpl__Country__c,
                dmpl__AddressId__r.dmpl__PostalCode__c,
                dmpl__AddressId__r.dmpl__Street__c
            FROM dmpl__Branch__c
            WHERE Id IN(
                SELECT dmpl__BranchId__c 
                FROM dmpl__BranchPostalCode__c
                WHERE dmpl__PostalCodeId__r.dmpl__City__c LIKE :cityName
            ) AND dmpl__IsActive__c = true];
        } else {
            return [SELECT Id,
                    Name,
                    dmpl__AllowInventory__c,
                    dmpl__AllowPurchase__c,
                    dmpl__AllowSales__c,
                    dmpl__AllowService__c,
                    dmpl__BranchType__c,
                    dmpl__BusinessHoursId__c,
                    dmpl__InventoryValuationMethod__c,
                    dmpl__IsActive__c,
                    dmpl__IsHomeDeliveryAvailable__c,
                    dmpl__IsPickupDropAvailable__c,
                    dmpl__MarketingName__c,
                    dmpl__MobileNumber__c,
                    dmpl__Email__c,
                    dmpl__Phone__c,
                    dmpl__SalesPhone__c,
                    dmpl__ServicePhone__c,
                    dmpl__SalesEmail__c,
                    dmpl__ServiceEmail__c,
                    dmpl__PartnerAccountId__c,
                    dmpl__AddressId__c,
                    dmpl__GeoLocation__c,
                    dmpl__Website__c,
                    dmpl__AddressId__r.dmpl__City__c,
                    dmpl__AddressId__r.dmpl__State__c,
                    dmpl__AddressId__r.dmpl__Country__c,
                    dmpl__AddressId__r.dmpl__PostalCode__c,
                    dmpl__AddressId__r.dmpl__Street__c
                FROM dmpl__Branch__c
                WHERE Id IN(
                    SELECT dmpl__BranchId__c 
                    FROM dmpl__BranchPostalCode__c
                    WHERE dmpl__PostalCodeId__r.Name LIKE :postalCode
                        OR dmpl__PostalCodeId__r.dmpl__City__c LIKE:cityName
                ) AND dmpl__IsActive__c = true];
        }
    }

    @namespaceAccessible
    public static List<dmpl__Branch__c> queryBranches(List<Id> branchIds){
        SecurityHelper.ensureCanReadFields(new String[]{
            'Name',
            'dmpl__AllowInventory__c',
            'dmpl__AllowPurchase__c',
            'dmpl__AllowSales__c',
            'dmpl__AllowService__c',
            'dmpl__BranchType__c',
            'dmpl__BusinessHoursId__c',
            'dmpl__InventoryValuationMethod__c',
            'dmpl__IsActive__c',
            'dmpl__IsHomeDeliveryAvailable__c',
            'dmpl__IsPickupDropAvailable__c',
            'dmpl__MarketingName__c',
            'dmpl__MobileNumber__c',
            'dmpl__Email__c',
            'dmpl__Phone__c',
            'dmpl__SalesPhone__c',
            'dmpl__ServicePhone__c',
            'dmpl__SalesEmail__c',
            'dmpl__ServiceEmail__c',
            'dmpl__PartnerAccountId__c',
            'dmpl__AddressId__c',
            'dmpl__GeoLocation__c',
            'dmpl__Website__c'
        }, OBJECT_BRANCH);
        SecurityHelper.ensureCanReadFields(new String[]
        {
            'dmpl__StartTime__c', 
            'dmpl__EndTime__c',
            'dmpl__MaximumCapacity__c',
            'dmpl__IsActive__c',
            'dmpl__ApplicableToItem__c',
            'dmpl__ApplicableToItemGroup__c',
            'dmpl__ServiceType__c',
            'dmpl__ServiceJobType__c',
            'dmpl__FridayCapacity__c',
            'dmpl__MondayCapacity__c',
            'dmpl__SaturdayCapacity__c',
            'dmpl__SundayCapacity__c',
            'dmpl__ThursdayCapacity__c',
            'dmpl__TuesdayCapacity__c',
            'dmpl__WednesdayCapacity__c'},
        'dmpl__BranchTimeSlot__c');
        
        return [SELECT Id,
                Name,
                dmpl__AllowInventory__c,
                dmpl__AllowPurchase__c,
                dmpl__AllowSales__c,
                dmpl__AllowService__c,
                dmpl__BranchType__c,
                dmpl__BusinessHoursId__c,
                dmpl__InventoryValuationMethod__c,
                dmpl__IsActive__c,
                dmpl__IsHomeDeliveryAvailable__c,
                dmpl__IsPickupDropAvailable__c,
                dmpl__MarketingName__c,
                dmpl__MobileNumber__c,
                dmpl__Email__c,
                dmpl__Phone__c,
                dmpl__SalesPhone__c,
                dmpl__ServicePhone__c,
                dmpl__SalesEmail__c,
                dmpl__ServiceEmail__c,
                dmpl__PartnerAccountId__c,
                dmpl__AddressId__c,
                dmpl__GeoLocation__c,
                dmpl__Website__c,
                (SELECT 
                    Id, 
                    dmpl__ApplicableToItem__c,
                    dmpl__ApplicableToItemGroup__c,
                    dmpl__ServiceType__c,
                    dmpl__ServiceJobType__c,
                    dmpl__DisplayName__c,
                    dmpl__EndTime__c,
                    dmpl__IsActive__c,
                    dmpl__MaximumCapacity__c,
                    dmpl__StartTime__c,
                    Name,
                    dmpl__TransactionType__c,
                    dmpl__FridayCapacity__c,
                    dmpl__MondayCapacity__c,
                    dmpl__SaturdayCapacity__c,
                    dmpl__SundayCapacity__c,
                    dmpl__ThursdayCapacity__c,
                    dmpl__TuesdayCapacity__c,
                    dmpl__WednesdayCapacity__c
                    FROM dmpl__TimeSlots__r)
            FROM dmpl__Branch__c
            WHERE Id IN:branchIds];
    }

    private static BranchDateSlotResult getDailyCapcity(
        Date bookingDate, 
        dmpl__Branch__c branch, 
        String transactionType, 
        Id itemId,
        String serviceType,
        String serviceJobType, 
        List<AggregateResult> dateCapacities){
        Id itemGroupId = null;
        Decimal dailyCapacity = 0;
        Decimal utilizedCapacity = 0;
        for(dmpl__BranchTimeSlot__c slot : branch.dmpl__TimeSlots__r){
            Boolean found = false;
            for(AggregateResult aggResult : dateCapacities){
                if((Id)aggResult.get('BranchTimeSlotId') == slot.Id 
                    && (Date)aggResult.get('BookingDate') == bookingDate){
                        found = true;
                        dailyCapacity += (Decimal)aggResult.get('Capacity');
                        utilizedCapacity +=(Decimal)aggResult.get('CapacityUtilized');
                    } 
            }

            if(!found 
                && slot.dmpl__TransactionType__c == transactionType
                && slot.dmpl__IsActive__c
                && (slot.dmpl__ServiceType__c == null || slot.dmpl__ServiceType__c == serviceType)
                && (slot.dmpl__ServiceJobType__c == null || slot.dmpl__ServiceJobType__c == serviceJobType)
                && (
                    (slot.dmpl__ApplicableToItem__c == null && slot.dmpl__ApplicableToItemGroup__c == null)
                    || slot.dmpl__ApplicableToItem__c == itemId
                    || slot.dmpl__ApplicableToItemGroup__c == itemGroupId)){
                        dailyCapacity+= getDayOfWeekCapacity(bookingDate, slot);
                    }
            
        }
        return new BranchDateSlotResult(bookingDate, dailyCapacity, utilizedCapacity);
    }

    @Testvisible
    private static Decimal getDayOfWeekCapacity(Date bookingDate, dmpl__BranchTimeSlot__c slot){
        Integer dayOfWeek = Math.mod(Date.newInstance(1900, 1, 1).daysBetween(bookingDate), 7);
        if(dayOfWeek == 0 && slot.dmpl__MondayCapacity__c!=null){
            return  slot.dmpl__MondayCapacity__c;
        } else if(dayOfWeek == 1 && slot.dmpl__TuesdayCapacity__c!=null){
            return  slot.dmpl__TuesdayCapacity__c;
        } else if(dayOfWeek == 2 && slot.dmpl__WednesdayCapacity__c!=null){
            return  slot.dmpl__WednesdayCapacity__c;
        } else if(dayOfWeek == 3 && slot.dmpl__ThursdayCapacity__c!=null){
            return  slot.dmpl__ThursdayCapacity__c;
        } else if(dayOfWeek == 4 && slot.dmpl__FridayCapacity__c!=null){
            return  slot.dmpl__FridayCapacity__c;
        } else if(dayOfWeek == 5 && slot.dmpl__SaturdayCapacity__c!=null){
            return  slot.dmpl__SaturdayCapacity__c;
        } else if(dayOfWeek == 6 && slot.dmpl__SundayCapacity__c!=null){
            return  slot.dmpl__SundayCapacity__c;
        } else {
            return slot.dmpl__MaximumCapacity__c;
        }
    }
}