public with sharing class ResourceLeaveService {

    public static void createResoureLeavesFromEntitlement(
        List<dmpl__LeaveEntitlement__c> newRecords
    ){  
        List<dmpl__ResourceLeave__c> toBeInserted = new List<dmpl__ResourceLeave__c>();
        List<dmpl__ResourceGroup__c> resourceGroups = getResourecGroups(
            DocumentHelper.extractIds(
                newRecords,
                'dmpl__ResourceGroupId__c'));
        List<Id> resourceIds = new List<Id>();
        for(dmpl__ResourceGroup__c record : resourceGroups){
            for(dmpl__ResourceGroupMember__c entry : record.dmpl__ResourceGroupMembers__r){
                resourceIds.add(entry.dmpl__ResourceId__c);
            }
        }
        for(dmpl__LeaveEntitlement__c record : newRecords){
            resourceIds.add(record.dmpl__ResourceId__c);
        }
        for(dmpl__LeaveEntitlement__c record : newRecords){
            for(dmpl__ResourceGroup__c entry : resourceGroups){
                if(record.dmpl__ResourceGroupId__c == entry.Id){
                    for(dmpl__ResourceGroupMember__c member : entry.dmpl__ResourceGroupMembers__r){
                        toBeInserted.add(
                            new dmpl__ResourceLeave__c(
                                dmpl__Available__c = record.dmpl__FixedCount__c,
                                dmpl__Balance__c = record.dmpl__FixedCount__c,
                                dmpl__LeaveTypeId__c = record.dmpl__LeaveTypeId__c,
                                dmpl__ResourceId__c = member.dmpl__ResourceId__c));
                    }
                }
            }
            if(record.dmpl__ResourceId__c!=null){
                toBeInserted.add(new dmpl__ResourceLeave__c(
                        dmpl__Available__c = record.dmpl__FixedCount__c,
                        dmpl__Balance__c = record.dmpl__FixedCount__c,
                        dmpl__LeaveTypeId__c = record.dmpl__LeaveTypeId__c,
                        dmpl__ResourceId__c = record.dmpl__ResourceId__c));
            }  
        }
        if(toBeInserted.size()>0){
            insert toBeInserted;
        }
    }

    public static List<dmpl__ResourceGroup__c> getResourecGroups(
        List<Id> recordIds
    ){
        return [SELECT Id,
            (SELECT Id,
            dmpl__ResourceId__c
            FROM dmpl__ResourceGroupMembers__r)
        FROM dmpl__ResourceGroup__c
        WHERE Id IN :recordIds];
    }
}