public with sharing class LeaveEntitlementDataHelper {
    public static dmpl__LeaveEntitlement__c createLeaveEntitlement(dmpl__LeaveType__c leaveType, dmpl__Resource__c resource, dmpl__ResourceGroup__c resourceGroup) {
        return (dmpl__LeaveEntitlement__c) TestFactory.createSObject(
            new dmpl__LeaveEntitlement__c(
                dmpl__LeaveTypeId__c = leaveType.Id,
                dmpl__ResourceId__c = resource.Id,
                dmpl__ResourceGroupId__c = resourceGroup.Id
            ),
            'LeaveEntitlementDefault',
            true
        );
    }

     public static dmpl__LeaveEntitlement__c createLeaveEntitlement(
            String name,
            dmpl__LeaveType__c leaveType,
            dmpl__Resource__c resource,
            Decimal fixedCount
        ) {
            return (dmpl__LeaveEntitlement__c) TestFactory.createSObject(
            new dmpl__LeaveEntitlement__c(
                dmpl__LeaveTypeId__c = leaveType != null ? leaveType.Id : null,
                dmpl__ResourceId__c = resource != null ? resource.Id : null,
                dmpl__FixedCount__c = fixedCount
            ),
            //'LeaveEntitlementDefaults',
            true
        );
    }
    
    public static dmpl__LeaveEntitlement__c getLeaveEntitlement() {
        return [
            SELECT Id, Name, dmpl__FixedCount__c, dmpl__LeaveTypeId__c,
                   dmpl__ResourceId__c, dmpl__ResourceGroupId__c
            FROM dmpl__LeaveEntitlement__c
            LIMIT 1
        ];
    }

    public static dmpl__LeaveEntitlement__c getLeaveEntitlementRecord(Id entitlementId) {
        return [
            SELECT Name, dmpl__FixedCount__c
            FROM dmpl__LeaveEntitlement__c
            WHERE Id = :entitlementId
            LIMIT 1
        ];
    }

    public static Boolean existsLeaveEntitlement(Id entitlementId) {
        return [SELECT count() FROM dmpl__LeaveEntitlement__c WHERE Id = :entitlementId] > 0;
    }
}