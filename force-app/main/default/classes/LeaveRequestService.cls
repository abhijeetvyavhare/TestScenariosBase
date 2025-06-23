public with sharing class LeaveRequestService {

    /*
    * Check if leave can be applied or not.
    */
    public static void validateLeaveRequest(
        List<dmpl__LeaveRequest__c> newEntries
    ){  
        Map<Id,dmpl__Resource__c> resources = getUserDetails(
            new List<Id>{UserInfo.getUserId()});
        System.debug('resources ' + resources);
        Id recordId = resources.size() > 0 ? resources.values()[0].Id : null;
        System.debug('recordId ' + recordId);
        List<Id> resourceIds = DocumentHelper.extractIds(
            newEntries, 
            'dmpl__ResourceId__c');
        if(recordId != null){
            resourceIds.add(recordId);
        }
        Map<Id, dmpl__ResourceLeave__c> resourceLeaves = getResourceLeaves(
            resourceIds);
        Boolean flag = false;
        for (dmpl__LeaveRequest__c record : newEntries) {
            for (dmpl__ResourceLeave__c resourceLeave : resourceLeaves.values()) {
                if(record.dmpl__ResourceId__c != null){
                    recordId = record.dmpl__ResourceId__c;
                }else{
                    record.dmpl__ResourceId__c = recordId;
                }
                if(recordId == null){
                    record.addError('No resource Selected!');
                    return;
                }
                if (record.dmpl__LeaveTypeId__c == resourceLeave.dmpl__LeaveTypeId__c
                && recordId == resourceLeave.dmpl__ResourceId__c) {
                    flag = true;
                    if(record.dmpl__Days__c!=null && record.dmpl__Days__c > resourceLeave.dmpl__Balance__c){
                        record.addError('Leave balance is not enough!');
                        return;
                    }
                }
            }
            if(!flag){
                record.addError('No Resource Leave Present');
                return;
            }
        }
    }

    /*
    * Records the entry of leave in Resource Availability
    * and recalculates the Resource Leaves.
    */
    public static void processApprovedLeaves(
        List<dmpl__LeaveRequest__c> newEntries
    ){
        List<dmpl__ResourceAvailability__c> toBeUpserted = new List<dmpl__ResourceAvailability__c>();
        List<dmpl__ResourceAvailability__c> availabilityData = getResourceAvailability(
            DocumentHelper.extractIds(
                newEntries, 
                'dmpl__ResourceId__c'));
            
        for (dmpl__LeaveRequest__c approvedLeave : newEntries){
            System.debug('days :' + approvedLeave.dmpl__Days__c );
            for (Integer i = 0; i < approvedLeave.dmpl__Days__c; i++){
                Boolean flag = false;
                for(dmpl__ResourceAvailability__c availability : availabilityData){
                    system.debug('leave date :' + approvedLeave.dmpl__FromDate__c.addDays(i));
                    system.debug('availability.dmpl__Date__c :' + availability.dmpl__Date__c);
                    if(((approvedLeave.dmpl__ResourceId__c != null 
                    && approvedLeave.dmpl__ResourceId__c == availability.dmpl__ResourceId__c))
                    && approvedLeave.dmpl__FromDate__c.addDays(i) == availability.dmpl__Date__c
                    ){
                        availability.dmpl__AvailabilityType__c = 'Leave';
                        availability.dmpl__LeaveRequestId__c = approvedLeave.Id;
                        toBeUpserted.add(availability);
                        flag = true;
                        break;
                    }
                }   
                if(!flag){//insert availability
                    dmpl__ResourceAvailability__c newResAvailability = new dmpl__ResourceAvailability__c();
                    newResAvailability.dmpl__AvailabilityType__c = 'Leave';
                    newResAvailability.dmpl__Date__c = approvedLeave.dmpl__FromDate__c.addDays(i);
                    newResAvailability.dmpl__ResourceId__c = approvedLeave.dmpl__ResourceId__c;
                    newResAvailability.dmpl__LeaveRequestId__c = approvedLeave.Id;
                    toBeUpserted.add(newResAvailability);
                }
            }
        }
        if (!toBeUpserted.isEmpty()) {
            upsert toBeUpserted;
        }
        recalculateApprovedLeaves(newEntries);
    }

    /*
    * Recalculates leave balances for approved leaves.
    */
    public static void recalculateApprovedLeaves(
        List<dmpl__LeaveRequest__c> newEntries
    ){
        Map<Id, dmpl__ResourceLeave__c> resourceLeaves = getResourceLeaves(
            DocumentHelper.extractIds(
                newEntries, 
                'dmpl__ResourceId__c'));
        for (dmpl__LeaveRequest__c leaveRequest : newEntries) {
            for(dmpl__ResourceLeave__c resourceLeave : resourceLeaves.values()){
                if(resourceLeave.dmpl__ResourceId__c == leaveRequest.dmpl__ResourceId__c
                && resourceLeave.dmpl__LeaveTypeId__c == leaveRequest.dmpl__LeaveTypeId__c){
                    if(leaveRequest.dmpl__ApplyFor__c == '1st Half' 
                    || leaveRequest.dmpl__ApplyFor__c == '2nd Half'){
                        system.debug('1 :'+leaveRequest.dmpl__ApplyFor__c);
                        system.debug('2 :'+resourceLeave.dmpl__Balance__c );
                        resourceLeave.dmpl__Balance__c -= 0.5;
                        system.debug('3 :'+resourceLeave.dmpl__Balance__c );

                    }else{
                        resourceLeave.dmpl__Balance__c -= leaveRequest.dmpl__Days__c;
                    }
                }
            }
        }
        if (!resourceLeaves.isEmpty()) {
            update resourceLeaves.values();
        }
    }

    /*
    * Handles cancelled leave requests and recalculates leaves.
    */
    public static void processCancelledLeaves(
        List<dmpl__LeaveRequest__c> newEntries, 
        List<dmpl__LeaveRequest__c> oldEntries
    ){
        List<dmpl__LeaveRequest__c> iterate = new List<dmpl__LeaveRequest__c>();
        Map<Id, dmpl__LeaveRequest__c> oldMap = new Map<Id, dmpl__LeaveRequest__c>(oldEntries);
        
        for (dmpl__LeaveRequest__c record : newEntries) {
            if (oldMap.get(record.Id).dmpl__Status__c == 'Approved' 
            && record.dmpl__Status__c == 'Cancelled') {
                iterate.add(record);
            }
        }
        
        List<Id> leaveIds = DocumentHelper.extractIds(iterate);
        List<dmpl__ResourceAvailability__c> recordsToBeDeleted = getResourceAvailability(leaveIds);
        
        if (!recordsToBeDeleted.isEmpty()) {
            delete recordsToBeDeleted;
        }

        recalculateCancelledLeaves(iterate);
    }

    /*
    * Recalculates leave balances for cancelled leaves.
    */
    public static void recalculateCancelledLeaves(List<dmpl__LeaveRequest__c> cancelledLeaves) {
        Map<Id, dmpl__ResourceLeave__c> resourceLeaves = getResourceLeaves(
            DocumentHelper.extractIds(
                cancelledLeaves, 
                'dmpl__ResourceId__c'));
        
        for (dmpl__LeaveRequest__c leaveRequest : cancelledLeaves) {
            for(dmpl__ResourceLeave__c resourceLeave : resourceLeaves.values()){
                if(resourceLeave.dmpl__ResourceId__c == leaveRequest.dmpl__ResourceId__c
                && resourceLeave.dmpl__LeaveTypeId__c == leaveRequest.dmpl__LeaveTypeId__c){
                    if(leaveRequest.dmpl__ApplyFor__c == '1st Half' 
                    || leaveRequest.dmpl__ApplyFor__c == '2nd Half'){
                        resourceLeave.dmpl__Balance__c += 0.5;
                    }else{
                        resourceLeave.dmpl__Balance__c += leaveRequest.dmpl__Days__c;
                    }
                }
            }
        }
        if (!resourceLeaves.isEmpty()) {
            update resourceLeaves.values();
        }
    }
    
    public static void updateDates(List<dmpl__LeaveRequest__c> request) {
        for(dmpl__LeaveRequest__c record:request){
            if(record.dmpl__ApplyFor__c != 'Multiple Days'){
                record.dmpl__ToDate__c = record.dmpl__FromDate__c;
            }
        }
    }

    public static Map<Id,dmpl__Resource__c> getUserDetails(
        List<Id> recordIds){
        return new Map<Id,dmpl__Resource__c>([
            SELECT Id,
                Name,
                dmpl__DefaultBranchId__c,
                dmpl__DefaultPartnerAccountId__c,
                dmpl__DefaultBranchId__r.dmpl__PartnerAccountId__c,
                dmpl__DefaultBranchId__r.dmpl__GeoLocation__Latitude__s,
                dmpl__DefaultBranchId__r.dmpl__GeoLocation__Longitude__s
            FROM dmpl__Resource__c
            WHERE (dmpl__UserId__c IN :recordIds
            OR Id IN :recordIds)
            AND dmpl__IsActive__c = true
        ]);
    }

    public static Map<Id, dmpl__ResourceLeave__c> getResourceLeaves(List<Id> recordIds) {
        return new Map<Id, dmpl__ResourceLeave__c>([
            SELECT Id, 
                Name, 
                dmpl__Available__c, 
                dmpl__Balance__c, 
                dmpl__LeaveTypeId__c, 
                dmpl__ResourceId__c
                FROM dmpl__ResourceLeave__c
            WHERE dmpl__ResourceId__c IN :recordIds
            OR Id IN :recordIds 
        ]);
    }

    public static List<dmpl__ResourceAvailability__c> getResourceAvailability(List<Id> recordIds) {
        return [
            SELECT Id,
                dmpl__AvailabilityType__c,
                dmpl__Date__c,
                dmpl__ResourceId__c
            FROM dmpl__ResourceAvailability__c
            WHERE dmpl__LeaveRequestId__c IN :recordIds
            OR dmpl__ResourceId__c IN :recordIds
        ];
    }
}