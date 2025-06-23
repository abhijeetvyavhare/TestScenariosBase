public with sharing class CheckinCheckoutController {
    /*
    * Captures Check-In and Check-Out details in Resource Availability and Resource Availability Data Objects.
    */
    // @AuraEnabled(cacheable=false)
    // public static Boolean markCheckInCheckOut(
    //  String lat,
    //  String lon,
    //  String timeDate,
    //  Boolean isCheckIn){
    //     return handleCheckInOut(lat,lon,timeDate,isCheckIn);
    // }


    //UserId - ResourceId
    //QueryAvailabitu
    //Get ResourceAvailability for the day
    //If Not Create The ResourceAvaIlabilityObject -- Additon 5 Fields
    //CreateRAD
    //RAD - AVID
    //Upser , Insert

    //CheckOut 

    /*public static Boolean handleCheckInOut(
        String lat,
        String lon,
        String timeDate,
        Boolean isCheckIn){
        Boolean isSuccess = false;
        List<dmpl__ResourceAvailabilityData__c> toBeInserted= new List<dmpl__ResourceAvailabilityData__c>();
        String resourceId = getResource(UserInfo.getUserId());
        List<dmpl__ResourceAvailability__c> resourceAvailability = getResourceAvailability();
        if (resourceAvailability.isEmpty() && resourceId != '') {

            dmpl__ResourceAvailability__c resourceAvailabilityNew = new dmpl__ResourceAvailability__c();
            resourceAvailabilityNew.dmpl__ResourceId__c = Id.valueOf(resourceId);
            if(isCheckIn){
                resourceAvailabilityNew.dmpl__CheckIn__c = DateTime.ValueOf(timeDate); 
                resourceAvailabilityNew.dmpl__CheckinLocation__Latitude__s = Decimal.valueOf(lat); 
                resourceAvailabilityNew.dmpl__CheckinLocation__Longitude__s = Decimal.valueOf(lon); 
            }
            else {
                resourceAvailabilityNew.dmpl__CheckOut__c = DateTime.valueOf(timeDate);
                resourceAvailabilityNew.dmpl__CheckOutLocation__Latitude__s = Decimal.valueOf(lat); 
                resourceAvailabilityNew.dmpl__CheckOutLocation__Longitude__s = Decimal.valueOf(lon); 
            } 
            resourceAvailabilityNew.dmpl__Date__c = DateTime.ValueOf(timeDate).date();
            insert resourceAvailabilityNew;

            if (resourceAvailabilityNew.Id != null) {
                dmpl__ResourceAvailabilityData__c newResourceAvailabilityData = new dmpl__ResourceAvailabilityData__c();
                newResourceAvailabilityData.dmpl__AttendenceLocation__Latitude__s = Decimal.valueOf(lat);
                newResourceAvailabilityData.dmpl__AttendenceLocation__Longitude__s = Decimal.valueOf(lon);
                newResourceAvailabilityData.dmpl__AttendenceTime__c = DateTime.valueOf(timeDate);
                newResourceAvailabilityData.dmpl__Time__c = DateTime.valueOf(timeDate);
                newResourceAvailabilityData.dmpl__ResourceAvailabilityId__c = resourceAvailabilityNew.Id;
                if(isCheckIn)newResourceAvailabilityData.dmpl__Type__c = 'Check-In';
                else newResourceAvailabilityData.dmpl__Type__c = 'Check-Out';
                newResourceAvailabilityData.dmpl__ResourceId__c = Id.valueOf(resourceId);
                insert newResourceAvailabilityData;
                isSuccess = true;
            }
        } 
        else if (resourceAvailability.size() > 0){
            for(dmpl__ResourceAvailability__c record : resourceAvailability){
                dmpl__ResourceAvailabilityData__c newResourceAvailabilityData = new dmpl__ResourceAvailabilityData__c();
                newResourceAvailabilityData.dmpl__AttendenceTime__c = DateTime.valueOf(timeDate);
                newResourceAvailabilityData.dmpl__Time__c = DateTime.valueOf(timeDate);
                newResourceAvailabilityData.dmpl__AttendenceLocation__Latitude__s = Decimal.valueOf(lat);
                newResourceAvailabilityData.dmpl__AttendenceLocation__Longitude__s = Decimal.valueOf(lon);
                if(isCheckIn)newResourceAvailabilityData.dmpl__Type__c = 'Check-In';
                else newResourceAvailabilityData.dmpl__Type__c = 'Check-Out';
                newResourceAvailabilityData.dmpl__ResourceAvailabilityId__c = record.Id;
                newResourceAvailabilityData.dmpl__ResourceId__c = Id.valueOf(resourceId);
                toBeInserted.add(newResourceAvailabilityData);
                if(isCheckIn){
                    record.dmpl__CheckIn__c = DateTime.ValueOf(timeDate); 
                    record.dmpl__CheckinLocation__Latitude__s = Decimal.valueOf(lat); 
                    record.dmpl__CheckinLocation__Longitude__s = Decimal.valueOf(lon); 
                    if(record.dmpl__CheckOut__c !=  null){
                        record.dmpl__PenaltyHours__c =( record.dmpl__CheckOut__c.getTime() - record.dmpl__CheckIn__c.getTime())/ 3600000;
                    }
                }
                else {
                    record.dmpl__CheckOut__c = DateTime.valueOf(timeDate);
                    record.dmpl__CheckOutLocation__Latitude__s = Decimal.valueOf(lat); 
                    record.dmpl__CheckOutLocation__Longitude__s = Decimal.valueOf(lon); 
                    record.dmpl__WorkingHours__c =( record.dmpl__CheckOut__c.getTime() - record.dmpl__CheckIn__c.getTime())/ 3600000;
                }
            }
            if(toBeInserted != null){
                insert toBeInserted;
                isSuccess = true;
            }
        }
        update resourceAvailability;

        if(!isCheckIn)markAttendance(resourceId);
        return isSuccess;
    }*/

    /*private static void markAttendance(Id resourceId){
        List<dmpl__ResourceAvailability__c> availability = getLastAvailability();
        Id bhId =  getResource(resourceId);
        if(availability.size() == 0)return;
        if(availability != null) {
            long duration = availability[0].dmpl__LastCheckOutTime__c?.getTime() - availability[0].dmpl__FirstCheckInTime__c?.getTime();
            duration = duration / 1000;
            duration = duration / 60;
            duration = duration / 60;
           
            if(duration > 8){
                availability[0].dmpl__AvailabilityType__c = 'Present';
            }else if(duration > 4){
                availability[0].dmpl__AvailabilityType__c = 'Half Day';
            }
            availability[0].dmpl__CheckOut__c = availability[0].dmpl__LastCheckOutTime__c;
            update availability;
        }
    }*/

    /*
    * Retrieves information of available and balance leaves for perticular resource.
    */
    /*@AuraEnabled(cacheable=true)
    public static List<dmpl__ResourceLeave__c> getResourceLeave(){
        String resourceId = getResource(UserInfo.getUserId());
        if(resourceId != null){
            return [SELECT Id,
                    dmpl__LeaveTypeId__c,
                    dmpl__LeaveTypeId__r.Name,
                    dmpl__Available__c,
                    dmpl__Balance__c,
                    dmpl__ResourceId__c
                FROM dmpl__ResourceLeave__c
                WHERE dmpl__ResourceId__c = :resourceId];
        }else{
            return new List<dmpl__ResourceLeave__c>();
        }
    }*/

    /*
    * Retrieves duration for which user had logged In.
    */
    /*@AuraEnabled(cacheable=true)
    public static Decimal getCheckInDuration(){
        List<dmpl__ResourceAvailability__c> lastAvailability = getLastAvailability();
        if(lastAvailability.size() == 0)return 0;
        if(lastAvailability != null){
            if(isCheckedIn()){
               	system.debug('here : ');
                if (lastAvailability[0].dmpl__FirstCheckInTime__c != null ){
                    Long nowTime = Datetime.now().getTime();
                    long duration = nowTime - lastAvailability[0].dmpl__FirstCheckInTime__c?.getTime();

                    Long seconds = duration / 1000;
                    system.debug('seconds : '+seconds);
                    return seconds;
                }
                else{
                    return 0;
                }
            }
            else{
                Long duration = lastAvailability[0].dmpl__LastCheckOutTime__c?.getTime()- lastAvailability[0].dmpl__FirstCheckInTime__c?.getTime();

                system.debug('mid '+ duration );
                Long seconds = duration / 1000;
                
                system.debug('checkout : '+ seconds);
                return seconds;
            }
        }
        else{
            return 0;
        }
    }*/


    /*@AuraEnabled(cacheable=true)
    public static Boolean isCheckedIn(){
        List<dmpl__ResourceAvailability__c> lastAvailability = getLastAvailability();
        if(lastAvailability.size() == 0)return false;
        if(lastAvailability != null 
        && lastAvailability[0].dmpl__ResourceAvailabilities__r.size() > 0){
            if(lastAvailability[0].dmpl__ResourceAvailabilities__r[0].dmpl__Type__c == 'Check-In'){
                return true;
            }
        }
        return false;
    }

    @AuraEnabled(cacheable=true)
    public static dmpl__Resource__c getResourceLocation() {
        id resourceId =  getResource(UserInfo.getUserId());

        dmpl__Resource__c resource = new dmpl__Resource__c();

        if(resourceId != NULL) {
            resource = [
                SELECT Id, 
                    dmpl__DefaultPartnerAccountId__r.dmpl__AccountLocation__c
                FROM dmpl__Resource__c
                WHERE Id = :resourceId LIMIT 1
            ];
        }

        return resource;
    }

    public static List<dmpl__ResourceAvailability__c> getLastAvailability(){
        String resourceId = getResource(UserInfo.getUserId());
        return [SELECT Id, 
                dmpl__ResourceId__c,
                dmpl__Duration__c,
                dmpl__FirstCheckInTime__c,
                dmpl__LastcheckOutTime__c,
                dmpl__AvailabilityType__c,
                (SELECT Id,
                    dmpl__Type__c,
                    dmpl__AttendenceTime__c,
                    dmpl__ResourceId__c
                FROM dmpl__ResourceAvailabilities__r
                ORDER BY createdDate DESC
                LIMIT 1)
            FROM dmpl__ResourceAvailability__c 
            WHERE dmpl__ResourceId__c = :resourceId
            AND dmpl__Date__c = TODAY
            AND dmpl__AvailabilityType__c = null];
    }
    

    private static List<dmpl__ResourceAvailability__c> getResourceAvailability(){
        String resourceId = getResource(UserInfo.getUserId());
        system.debug('resou' + resourceId);
        if(resourceId != null){
            return [SELECT Id, 
                    dmpl__ResourceId__c,
                    dmpl__Duration__c,
                    dmpl__CheckinLocation__Latitude__s,
                    dmpl__CheckOutLocation__Latitude__s,
                    dmpl__CheckOutLocation__Longitude__s,
                    dmpl__CheckinLocation__Longitude__s,
                    dmpl__CheckIn__c,
                    dmpl__CheckOut__c,
                    dmpl__CheckInEC__c,
                    dmpl__CheckOutEC__c
                FROM dmpl__ResourceAvailability__c 
                WHERE dmpl__ResourceId__c = :resourceId
                AND dmpl__Date__c = TODAY];
        }else{
            return new List<dmpl__ResourceAvailability__c>();
        }
    }

    private static String getResource(Id recordId){
        List<dmpl__Resource__c> resource= [SELECT Id
            FROM dmpl__Resource__c 
            WHERE dmpl__UserId__c =:recordId 
            OR Id = :recordId
            LIMIT 1];
        if(resource.size()>0){
            return resource[0].Id;
        }
        else return '';
    }


    @AuraEnabled(cacheable=true)
    public static void isResourceWithinTwoHundread(Decimal resourceLat, Decimal resourceLong) {
         system.debug(resourceLat);
         system.debug(resourceLong);
         
        system.debug('here ::::: ');
        List<dmpl__ResourceAvailability__c> LastAvailability = getResourceAvailability();
        if(LastAvailability.isEmpty()) {
            return;
        }

        system.debug('Inside ');

        id resourceId =  getResource(UserInfo.getUserId());
        dmpl__Resource__c resource = new dmpl__Resource__c();

        if (resourceId != null) {
            resource = [
                SELECT Id, 
                    dmpl__DefaultPartnerAccountId__r.dmpl__AccountLocation__Latitude__s,
                    dmpl__DefaultPartnerAccountId__r.dmpl__AccountLocation__Longitude__s,
                    dmpl__DefaultBranchId__c
                FROM dmpl__Resource__c
                WHERE Id = :resourceId LIMIT 1
            ];
        }

        if(resource.id != NULL 
            && resource.dmpl__DefaultPartnerAccountId__r != null
                && resource.dmpl__DefaultPartnerAccountId__r.dmpl__AccountLocation__Latitude__s != null
                    && resource.dmpl__DefaultPartnerAccountId__r.dmpl__AccountLocation__Longitude__s != null
                        && resource.dmpl__DefaultBranchId__c != null) {

            Decimal distance = distance1(resource.dmpl__DefaultPartnerAccountId__r.dmpl__AccountLocation__Latitude__s,
                                        resource.dmpl__DefaultPartnerAccountId__r.dmpl__AccountLocation__Longitude__s,
                                        resourceLat, resourceLong);
            system.debug(distance);
            // if(distance <= 200) {
            //     if(isCheckedIn()) {
            //         LastAvailability[0].dmpl__CheckInEC__c = resource.dmpl__DefaultBranchId__c;
            //     }
            //     else if(!isCheckedIn() ) {
            //         LastAvailability[0].dmpl__CheckOutEC__c = resource.dmpl__DefaultBranchId__c;
            //     }

            //     update LastAvailability;
            //     return;
            // }
        }

        List<dmpl__Branch__c> branchList = getBranch();
        Decimal minDistance = null;
        dmpl__Branch__c closestBranch = null;

        for(dmpl__Branch__c branch : branchList) {
            Decimal distanceToBranch = distance1(branch.dmpl__GeoLocation__Latitude__s,
                                                branch.dmpl__GeoLocation__Longitude__s,
                                                resourceLat,
                                                resourceLong);
            if (minDistance ==null || distanceToBranch < minDistance) {
                minDistance = distanceToBranch;
                closestBranch = branch;
            }
        }

        system.debug('Inside closestBranch : ' + closestBranch);
        dmpl__ResourceAvailability__c lastAvailabilityRecord = LastAvailability[0];
        if (closestBranch != null) {
            if (isCheckedIn()) 
                lastAvailabilityRecord.dmpl__CheckInEC__c = closestBranch.Id;
            else 
                lastAvailabilityRecord.dmpl__CheckOutEC__c = closestBranch.Id;
        }
    
        update lastAvailabilityRecord;

        system.debug('At last ');
    }

    private static Decimal distance1(Decimal lat1, Decimal lon1, Decimal lat2, Decimal lon2) {
            // Decimal latDiff = Math.abs(lat2 - lat1);
            // Decimal lonDiff = Math.abs(lon2 - lon1);
    
            // Decimal distanceLat = latDiff * 111132;
            // Decimal distanceLon = lonDiff * 111132;
    
            // Decimal distance = Math.sqrt((distanceLat * distanceLat) + (distanceLon * distanceLon));
    
            // return distance;
            return 210;
    }

    private static list<dmpl__Branch__c> getBranch() {
        return [SELECT Id,
                    dmpl__GeoLocation__Latitude__s,
                    dmpl__GeoLocation__Longitude__s
                FROM dmpl__Branch__c];
    }*/
}