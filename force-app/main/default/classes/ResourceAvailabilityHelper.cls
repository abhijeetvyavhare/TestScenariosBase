public with sharing class ResourceAvailabilityHelper {
    
    public static ResourceInfo getUserDetails(){
        List<dmpl__Resource__c> resource = [
            SELECT Id,
                Name,
                dmpl__DefaultBranchId__c,
                dmpl__DefaultPartnerAccountId__c,
                dmpl__DefaultBranchId__r.dmpl__PartnerAccountId__c,
                dmpl__DefaultBranchId__r.dmpl__GeoLocation__Latitude__s,
                dmpl__DefaultBranchId__r.dmpl__GeoLocation__Longitude__s, 
                (SELECT Id,
                    Name,
                    dmpl__Date__c,
                    dmpl__Duration__c,
                    dmpl__BranchId__c,
                    dmpl__ResourceId__c,
                    dmpl__PartnerAccountId__c,
                    dmpl__FirstCheckInTime__c,
                    dmpl__LastCheckOutTime__c,
                    dmpl__AvailabilityType__c,
                    dmpl__PenaltyHours__c,
                    (SELECT Id,
                        dmpl__Type__c,
                        dmpl__AttendenceTime__c,
                        dmpl__ResourceId__c,
                        dmpl__AttendenceLocation__Latitude__s,
                        dmpl__AttendenceLocation__Longitude__s
                    FROM dmpl__ResourceAvailabilities__r
                    ORDER BY createdDate DESC
                    LIMIT 1)
                FROM dmpl__ResourceAvailabilities__r
                WHERE dmpl__Date__c = TODAY
                ORDER BY createdDate DESC
                LIMIT 1),
                (SELECT Id,
                    Name,
                    dmpl__Balance__c,
                    dmpl__ResourceId__c,
                    dmpl__Available__c,
                    dmpl__LeaveTypeId__c,
                    dmpl__LeaveTypeId__r.Name
                FROM dmpl__ResourceLeaves__r)
            FROM dmpl__Resource__c
            WHERE dmpl__UserId__c = :UserInfo.getUserId()
            AND dmpl__IsActive__c = true
            LIMIT 1];
        if(resource.size() > 0){
            return new ResourceInfo(true,resource[0]);
        }
        return new ResourceInfo(false,null);
    }

    public static Boolean postCheckIn(
        String latitude,
        String longitude,
        String currentDateTime
    ){
        dmpl__PartnerResource__c nearestBranch = getNearestBranch(
            latitude,
            longitude);
        Boolean isSuccess = false;
        ResourceInfo resourceDetails = getUserDetails();
        dmpl__Resource__c resourceData = resourceDetails.resourceData;

        if(resourceData != null){
            dmpl__ResourceAvailability__c availability = resourceData?.dmpl__ResourceAvailabilities__r.size() > 0 ? resourceData?.dmpl__ResourceAvailabilities__r : null;
            if(availability?.dmpl__ResourceAvailabilities__r?.dmpl__Type__c == 'Check-In'){
                return false;
            }
            if(availability == null){
                availability = new dmpl__ResourceAvailability__c(
                    dmpl__AvailabilityType__c = 'Present',
                    dmpl__ResourceId__c = resourceData?.Id,
                    dmpl__CheckIn__c = DateTime.ValueOf(currentDateTime),
                    dmpl__Date__c = DateTime.ValueOf(currentDateTime).date(),
                    dmpl__CheckInBranch__c = nearestBranch !=null ? nearestBranch?.dmpl__BranchId__c : resourceData?.dmpl__DefaultBranchId__c,
                    dmpl__PartnerAccountId__c = nearestBranch !=null ? nearestBranch?.dmpl__PartnerAccountId__c : resourceData?.dmpl__DefaultPartnerAccountId__c,
                    dmpl__CheckInLocation__Longitude__s = Decimal.ValueOf(longitude),
                    dmpl__CheckInLocation__Latitude__s = Decimal.valueOf(latitude),
                    dmpl__PenaltyHours__c = 0
                );
            }
            // DateTime currentTime = DateTime.valueOf(currentDateTime);
            // DateTime lastCheckOutTime = availability?.dmpl__ResourceAvailabilities__r?.dmpl__AttendenceTime__c;
            // if(lastCheckOutTime != null && currentTime != null){
            //     system.debug(Decimal.valueOf((lastCheckOutTime.getTime() - currentTime.getTime())/3600000));
            //     if(availability.dmpl__PenaltyHours__c != null){
            //         availability.dmpl__PenaltyHours__c += (Double)(currentTime.getTime() - lastCheckOutTime.getTime())/3600000;
            //     }else{
            //         availability.dmpl__PenaltyHours__c = (Double)(currentTime.getTime() - lastCheckOutTime.getTime())/3600000;
            //     }
            // }
            if(availability != null){
                upsert availability;
            }

            dmpl__ResourceAvailabilityData__c newChildRecord = new dmpl__ResourceAvailabilityData__c(
                dmpl__Type__c = 'Check-In',
                dmpl__ResourceId__c = resourceData?.Id,
                dmpl__AttendenceTime__c = DateTime.valueOf(currentDateTime),
                dmpl__ResourceAvailabilityId__c = availability.Id,
                dmpl__AttendenceLocation__Longitude__s = Decimal.valueOf(longitude),
                dmpl__AttendenceLocation__Latitude__s = Decimal.valueOf(latitude)
            );
            if(newChildRecord != null){
                insert newChildRecord;
                isSuccess = true;
            }
        }
        return isSuccess;
    }

    public static Boolean postCheckOut(
        String latitude,
        String longitude,
        String currentDateTime
    ){
        Boolean isSuccess = false;
        ResourceInfo resourceDetails = getUserDetails();
        System.debug(resourceDetails + ' resourceDetails');
        dmpl__Resource__c resourceData = resourceDetails.resourceData;
        System.debug(resourceData + ' resourceData');
        dmpl__PartnerResource__c nearestBranch = getNearestBranch(
            latitude,
            longitude);

        if(resourceData != null){
            dmpl__ResourceAvailability__c availability = resourceData?.dmpl__ResourceAvailabilities__r.size() > 0 ? resourceData?.dmpl__ResourceAvailabilities__r : null;
            if(availability == null 
            || availability?.dmpl__ResourceAvailabilities__r?.dmpl__Type__c == 'Check-Out'){
                return false;
            }
            availability.dmpl__CheckOut__c = DateTime.valueOf(currentDateTime);
            availability.dmpl__CheckOutBranch__c =  nearestBranch !=null ? nearestBranch?.dmpl__BranchId__c : resourceData?.dmpl__DefaultBranchId__c;
            availability.dmpl__CheckOutLocation__Longitude__s = Decimal.ValueOf(longitude);
            availability.dmpl__CheckOutLocation__Latitude__s = Decimal.valueOf(latitude);
            dmpl__ResourceAvailabilityData__c newChildRecord = new dmpl__ResourceAvailabilityData__c(
                dmpl__Type__c = 'Check-Out',
                dmpl__ResourceId__c = resourceData?.Id,
                dmpl__AttendenceTime__c = DateTime.valueOf(currentDateTime),
                dmpl__ResourceAvailabilityId__c = availability.Id,
                dmpl__AttendenceLocation__Longitude__s = Decimal.valueOf(longitude),
                dmpl__AttendenceLocation__Latitude__s = Decimal.valueOf(latitude)
            );
            if(newChildRecord != null){
                insert newChildRecord;
                isSuccess = true;
            }
            if(availability != null){
                update availability;
                isSuccess = true;
            }
        }
        return isSuccess;
    }

    public static List<dmpl__Resource__c> getResourceDetailsByBranch(
        string branchId,
        string startDate,
        string endDate
    ){
        try {
            Date startdt = Date.ValueOf(startDate);
            Date enddt = Date.ValueOf(endDate);
            List<String> queryFields = new List<String>{
                'Id',
                'Name',
                'dmpl__DefaultBranchId__r.Name'
            };
             
            String subQuery = 'SELECT Id, '
                + 'dmpl__Date__c, '
                + 'dmpl__ResourceId__c, '
                + 'dmpl__AvailabilityType__c '
                + 'FROM dmpl__ResourceAvailabilities__r '
                + 'WHERE dmpl__Date__c >= :startdt '
                + 'AND dmpl__Date__c <= :enddt';
             
            String whereClause = 'WHERE dmpl__IsActive__c = true';
            if (branchId != null && branchId != '') {
                whereClause += ' AND dmpl__DefaultBranchId__c = :branchId';
            }
             
            String query = 'SELECT '
                + String.join(queryFields, ', ')
                + ', (' + subQuery + ') '
                + 'FROM dmpl__Resource__c '
                + whereClause;
             
            // Execute the query
            return Database.query(query);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static dmpl__PartnerResource__c getNearestBranch(
        String lat,
        String lon
    ){
        Decimal minimum = -1;
        Decimal latitude = Decimal.valueOf(lat);
        Decimal longitude = Decimal.valueOf(lon);
        ResourceInfo resource= getUserDetails();
        if(resource.isResourceAvailable == false)return null;
        dmpl__PartnerResource__c nearestBranch = new dmpl__PartnerResource__c();
        List<dmpl__PartnerResource__c> branches = [
            SELECT Id,
                dmpl__BranchId__c,
                dmpl__PartnerAccountId__c,
                dmpl__BranchId__r.dmpl__GeoLocation__c,
                dmpl__BranchId__r.dmpl__GeoLocation__Latitude__s,
                dmpl__BranchId__r.dmpl__GeoLocation__Longitude__s
            FROM dmpl__PartnerResource__c 
            WHERE dmpl__ResourceId__c = :resource.resourceData.Id
            AND dmpl__BranchId__r.dmpl__GeoLocation__Longitude__s != null
            AND dmpl__BranchId__r.dmpl__GeoLocation__Latitude__s != null
            AND dmpl__FromDate__c <= TODAY
            AND (dmpl__ToDate__c = null 
            OR dmpl__ToDate__c >= TODAY)];
        
        for(dmpl__PartnerResource__c record: branches){
            Decimal currentMinimum = nearestDistance(record?.dmpl__BranchId__r?.dmpl__GeoLocation__Latitude__s,
                                                     record?.dmpl__BranchId__r?.dmpl__GeoLocation__Longitude__s,
                                                     latitude,
                                                     longitude);
            if(minimum == -1 
            || currentMinimum<minimum){
                minimum = currentMinimum;
                longitude = record?.dmpl__BranchId__r?.dmpl__GeoLocation__Longitude__s;
                latitude = record?.dmpl__BranchId__r?.dmpl__GeoLocation__Latitude__s;
                nearestBranch = record;
            }
        }
        return nearestBranch;
    }
    
    private static Decimal nearestDistance(Decimal lat1, Decimal lon1, Decimal lat2, Decimal lon2) {
            Decimal latDiff = Math.abs(lat2 - lat1);
            Decimal lonDiff = Math.abs(lon2 - lon1);
    
            Decimal distanceLat = latDiff * 111132;
            Decimal distanceLon = lonDiff * 111132;
    
            Decimal distance = Math.sqrt((distanceLat * distanceLat) + (distanceLon * distanceLon));
    
            return distance;
    }
}