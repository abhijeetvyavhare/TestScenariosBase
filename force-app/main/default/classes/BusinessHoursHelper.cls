@namespaceAccessible
public with sharing class BusinessHoursHelper {
    
    @namespaceAccessible
    public static BusinessHours getCachedDefaultBusinessHours(){
        if (!OrgCacheHelper.isPlatformCacheEnabled('BusinessHours')){
            return queryDefaultBusinessHours();
        }
        BusinessHours businessHours = (BusinessHours)OrgCacheHelper.getObject('defaultbusinesshours');
        if(businessHours == null){
            businessHours = queryDefaultBusinessHours();
            OrgCacheHelper.setObject('defaultbusinesshours',businessHours);
        }

        return businessHours;
    }

    @namespaceAccessible
    public static BusinessHours getCachedBusinessHours(Id businessHoursId){
        if (!OrgCacheHelper.isPlatformCacheEnabled('BusinessHours')){
            return queryBusinessHours(businessHoursId);
        }
        BusinessHours businessHours = (BusinessHours)OrgCacheHelper.getSObject('BusinessHours', businessHoursId);
        if(businessHours == null){
            businessHours = queryBusinessHours(businessHoursId);
            OrgCacheHelper.setSObject(businessHours);
        }

        return businessHours;
    }

    @namespaceAccessible
    public static BusinessHours queryBusinessHours(Id businessHoursId){
        SecurityHelper.ensureCanReadFields(new String[]{
            'IsActive',
            'Name',
            'IsDefault',
            'FridayEndTime',
            'FridayStartTime',
            'MondayEndTime',
            'MondayStartTime',
            'SaturdayEndTime',
            'SaturdayStartTime',
            'SundayEndTime',
            'SundayStartTime',
            'ThursdayEndTime',
            'ThursdayStartTime',
            'TimeZoneSidKey',
            'TuesdayEndTime',
            'TuesdayStartTime',
            'WednesdayEndTime',
            'WednesdayStartTime'
        }, 'BusinessHours');
        return [SELECT
            IsActive,
            Name,
            IsDefault,
            FridayEndTime,
            FridayStartTime,
            MondayEndTime,
            MondayStartTime,
            SaturdayEndTime,
            SaturdayStartTime,
            SundayEndTime,
            SundayStartTime,
            ThursdayEndTime,
            ThursdayStartTime,
            TimeZoneSidKey,
            TuesdayEndTime,
            TuesdayStartTime,
            WednesdayEndTime,
            WednesdayStartTime
        FROM BusinessHours
        WHERE Id =:businessHoursId];
    }

    @namespaceAccessible
    public static BusinessHours queryDefaultBusinessHours(){
        SecurityHelper.ensureCanReadFields(new String[]{
            'IsActive',
            'Name',
            'IsDefault',
            'FridayEndTime',
            'FridayStartTime',
            'MondayEndTime',
            'MondayStartTime',
            'SaturdayEndTime',
            'SaturdayStartTime',
            'SundayEndTime',
            'SundayStartTime',
            'ThursdayEndTime',
            'ThursdayStartTime',
            'TimeZoneSidKey',
            'TuesdayEndTime',
            'TuesdayStartTime',
            'WednesdayEndTime',
            'WednesdayStartTime'
        }, 'BusinessHours');
        return [SELECT
            IsActive,
            Name,
            IsDefault,
            FridayEndTime,
            FridayStartTime,
            MondayEndTime,
            MondayStartTime,
            SaturdayEndTime,
            SaturdayStartTime,
            SundayEndTime,
            SundayStartTime,
            ThursdayEndTime,
            ThursdayStartTime,
            TimeZoneSidKey,
            TuesdayEndTime,
            TuesdayStartTime,
            WednesdayEndTime,
            WednesdayStartTime
        FROM BusinessHours
        WHERE IsDefault = true];
    }
}