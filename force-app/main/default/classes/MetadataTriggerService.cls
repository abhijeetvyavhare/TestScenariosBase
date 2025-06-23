public with sharing class MetadataTriggerService {
    public class MetadataTriggerServiceException extends Exception {
    }
    private String objType = '';

    public MetadataTriggerService(String objectTypeName) {
        this.objType = objectTypeName;
    }

    public string objectTypeName {
        get{
            return this.objType;
        }
    }

    /**
     * @description This query finds an ordered list trigger handler classes
     * to execute. It ignores any classes that are marked as disabled.
     *
     * Note: It will exclude any triggerHandler metadata records for which
     * the user's email address is found in a related disabled_for__mdt
     * record.
     *
     * Admin's and Developers can selectively disable trigger handlers
     * for all or selected individuals *without* deploying.
     * @return      `List<dmpl__DMSTriggerMapping__mdt>`
     */
    @suppressWarnings('PMD.ApexCRUDViolation')
    public List<dmpl__DMSTriggerMapping__mdt> getMetadataTriggers() {
        return [
            SELECT 
                dmpl__ClassName__c,
                dmpl__DisableForUserIds__c,
                dmpl__EnableMessaging__c,
                dmpl__EnableKPI__c
            FROM dmpl__DMSTriggerMapping__mdt
            WHERE
                dmpl__ObjectName__r.QualifiedApiName = :this.objType
                AND dmpl__Enabled__c = TRUE
            ORDER BY dmpl__ExecutionOrder__c
        ];
    }

    /**
     * @description This determines the active sObject type by describing the first
     * record in the trigger New / Old list
     * @return      `String`
     */
    public static String getSObjectType() {
        if (Trigger.new != null) {
            return Trigger.new[0].getSObjectType().getDescribe().getName();
        } else if (Trigger.old != null) {
            return Trigger.old[0].getSObjectType().getDescribe().getName();
        }
        throw new MetadataTriggerServiceException(
            'Trigger.new && Trigger.old are both null. Are you excercising this method outside of a trigger context?'
        );
    }
}