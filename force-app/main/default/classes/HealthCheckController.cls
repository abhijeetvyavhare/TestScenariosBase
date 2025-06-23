public with sharing class HealthCheckController {
   
    @AuraEnabled(cacheable = false)
    public static List<dmpl__ChecklistTemplate__c> getHealthCheckTemplates(Id itemId){
    try
        {
            SecurityHelper.ensureCanReadFields(new string[]{
                'dmpl__Type__c',
                'dmpl__ParentChecklistId__c',
                'dmpl__ItemId__c',
                'dmpl__Code__c'}, 
                'dmpl__ChecklistTemplate__c');
            return [SELECT Id, Name, dmpl__Code__c, dmpl__ItemId__c, dmpl__ParentChecklistId__c, dmpl__Type__c, (SELECT Id, Name, dmpl__DataType__c, dmpl__DefaultValue__c, dmpl__GroupBy__c FROM dmpl__CheckList_Template_Lines__r) FROM dmpl__ChecklistTemplate__c WHERE dmpl__Type__c = 'Health Check' AND dmpl__ItemId__c = : itemId];
        }
        catch(Exception e)
        {
            throw new DMPLException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable = false)
    public static List<dmpl__CheckListLines__c> getChecklistLines(Id parentRecordId){
        try {
            SecurityHelper.ensureCanReadFields(new string[]{
                'dmpl__BooleanValue__c',
                'dmpl__BranchId__c',
                'dmpl__ChecklistTemplateId__c',
                'dmpl__CheckListTemplateLineId__c',
                'dmpl__DataType__c',
                'dmpl__DeliveryOrderId__c',
                'dmpl__GoodsReceiptId__c',
                'dmpl__NumericValue__c',
                'dmpl__PartnerAccountId__c',
                'dmpl__RAGValue__c',
                'dmpl__Remarks__c',
                'dmpl__RepairOrderId__c',
                'dmpl__ServiceRequestId__c',
                'dmpl__TextValue__c',
                'dmpl__InspectionLineId__c'}, 
                'dmpl__CheckListLines__c');
            return [SELECT
            dmpl__BooleanValue__c,
            dmpl__BranchId__c,
            dmpl__ChecklistTemplateId__c,
            dmpl__CheckListTemplateLineId__c,
            dmpl__DataType__c,
            dmpl__DeliveryOrderId__c,
            dmpl__GoodsReceiptId__c,
            dmpl__InspectionLineId__c,
            dmpl__NumericValue__c,
            dmpl__PartnerAccountId__c,
            dmpl__RAGValue__c,
            dmpl__Remarks__c,
            dmpl__RepairOrderId__c,
            dmpl__ServiceRequestId__c,
            dmpl__TextValue__c,
            Id,
            Name
        FROM
            dmpl__CheckListLines__c
            WHERE dmpl__ServiceRequestId__c = : parentRecordId OR dmpl__RepairOrderId__c = : parentRecordId];
        } catch (Exception e) {
            throw new DMPLException(e.getMessage());
        }
    }

}