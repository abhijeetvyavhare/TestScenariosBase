public with sharing class ResourceAvailabilityController {
    
    @AuraEnabled(cacheable = true)
    public static ResourceInfo getUserDetails(){
        try{
            return ResourceAvailabilityHelper.getUserDetails();
        }catch(Exception error){
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    @AuraEnabled(cacheable = false)
    public static Boolean postCheckIn(
        String latitude,
        String longitude,
        String currentDateTime
    ){
        try{
            return ResourceAvailabilityHelper.postCheckIn(
                latitude,
                longitude,
                currentDateTime);
        }catch(Exception error){
            ExceptionLogHelper.logException(error);
            throw error;
        }
    } 
    
    @AuraEnabled(cacheable = false)
    public static Boolean postCheckOut(
        String latitude,
        String longitude,
        String currentDateTime
    ){
        try{
            return ResourceAvailabilityHelper.postCheckOut(
                latitude,
                longitude,
                currentDateTime);
        }catch(Exception error){
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }
    
    @AuraEnabled(cacheable = true)
    public static List<dmpl__Resource__c> getResourceDetailsByBranch(
        String branchId,
        String startDate,
        String endDate
    ){
        try{
            return ResourceAvailabilityHelper.getResourceDetailsByBranch(
                branchId,
                startDate,
                endDate);
        }catch(Exception error){
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    @AuraEnabled(cacheable = true)
    public static Decimal getCheckInLocationTolerance(){
        try {
            return OrgSettingHelper.OrgSetting()?.dmpl__LocationTolerance__c;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}