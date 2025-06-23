public with sharing class ProductDemoHelper {
    private static Boolean skipValidations = false;
    private static final string OBJECT_PRODUCTDEMO = 'dmpl__ProductDemo__c';
    private static final string FIELD_PRODUCTDEMO_STATUS = 'dmpl__Status__c';
    private static final string FIELD_PRODUCTDEMO_PARTNERACCOUNTID = 'dmpl__PartnerAccountId__c';
    private static final string FIELD_PRODUCTDEMO_BRANCHID = 'dmpl__BranchId__c';
    private static final string FIELD_PRODUCTDEMO_ACCOUNTID = 'dmpl__AccountId__c';
    private static final string FIELD_PRODUCTDEMO_ITEMID = 'dmpl__ItemId__c';
    private static final string FIELD_PRODUCTDEMO_DEMODATETIME ='dmpl__DemoDateTime__c';
    private static final string FIELD_PRODUCTDEMO_DEMODATE ='dmpl__DemoDate__c';
    private static final string FIELD_PRODUCTDEMO_DEMOTIME ='dmpl__DemoTime__c';
    private static final string FIELD_PRODUCTDEMO_SLOTID ='dmpl__DemoSlotId__c';
    private static final string FIELD_PRODUCTDEMO_ISCONFIRMED ='dmpl__IsConfirmed__c';
    private static final string FIELD_PRODUCTDEMO_ISCANCELLED ='dmpl__IsCancelled__c';
    private static final string FIELD_PRODUCTDEMO_TIMESLOTBOOKINGID ='dmpl__DemoTimeSlotBookingId__c';
    
    private static final List<String> LIST_NON_EDITABLE_FIELDS = new List<String>{FIELD_PRODUCTDEMO_ACCOUNTID, FIELD_PRODUCTDEMO_ITEMID};
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{FIELD_PRODUCTDEMO_DEMODATETIME,FIELD_PRODUCTDEMO_TIMESLOTBOOKINGID};
   
    public static void validateData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__ProductDemo__c> oldEntries, 
        List<dmpl__ProductDemo__c> newEntries)
    {
        try{
            if(isInsert){
                FieldMappingHelper.copyFieldMappingData(
                    newEntries);
            }
            if(skipValidations){
                return;
            }
            DocumentStatusDFSHelper dfsHelper = new DocumentStatusDFSHelper();
            if(isInsert){
                StatusHelper.validateStatusNew(OBJECT_PRODUCTDEMO, FIELD_PRODUCTDEMO_STATUS, newEntries);
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, newEntries);
                ValidationHelper.validatePartnerAndBranch(FIELD_PRODUCTDEMO_PARTNERACCOUNTID, FIELD_PRODUCTDEMO_BRANCHID, newEntries);
            }else if(isUpdate){
                StatusHelper.validateStatusEdit(OBJECT_PRODUCTDEMO, FIELD_PRODUCTDEMO_STATUS, oldEntries, newEntries);
                DocumentHelper.validateChangeInKeyFields(LIST_NON_EDITABLE_FIELDS, oldEntries, newEntries);
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, oldEntries, newEntries);
                dfsHelper.DocumentStatusRestrictEdits_Edit(OBJECT_PRODUCTDEMO, FIELD_PRODUCTDEMO_STATUS, oldEntries, newEntries);
                dfsHelper.DocumentStatusRestrictFieldsEdits(OBJECT_PRODUCTDEMO, FIELD_PRODUCTDEMO_STATUS, oldEntries, newEntries);
            }else if(isDelete){
                dfsHelper.DocumentStatusRestrictEdits_Delete(OBJECT_PRODUCTDEMO, FIELD_PRODUCTDEMO_STATUS, oldEntries);
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void postData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__ProductDemo__c> oldEntries, 
        List<dmpl__ProductDemo__c> newEntries)
    { 
        DocumentStatusDFSHelper dfsHelper = new DocumentStatusDFSHelper();

        if(isInsert){
            dfsHelper.DocumentStatusSetFlag(OBJECT_PRODUCTDEMO, FIELD_PRODUCTDEMO_STATUS, newEntries);
            dfsHelper.DocumentStatusReSetFlag(OBJECT_PRODUCTDEMO, FIELD_PRODUCTDEMO_STATUS, newEntries);
            BranchTimeSlotBookingHelper.reserveDemoTimeSlots(newEntries);
            assignResource(newEntries);
        }else if(isUpdate){
            dfsHelper.DocumentStatusSetFlag(OBJECT_PRODUCTDEMO, FIELD_PRODUCTDEMO_STATUS, oldEntries, newEntries);
            dfsHelper.DocumentStatusReSetFlag(OBJECT_PRODUCTDEMO, FIELD_PRODUCTDEMO_STATUS, oldEntries, newEntries);
            List<dmpl__ProductDemo__c> modifiedObjects = DocumentHelper.getModifiedNewObjects(new String[]{FIELD_PRODUCTDEMO_SLOTID, FIELD_PRODUCTDEMO_DEMODATE, FIELD_PRODUCTDEMO_ISCANCELLED, FIELD_PRODUCTDEMO_ISCONFIRMED}, oldEntries, newEntries);
            if(modifiedObjects.size()>0){
                BranchTimeSlotBookingHelper.releaseDemoTimeSlots(modifiedObjects);
                BranchTimeSlotBookingHelper.reserveDemoTimeSlots(modifiedObjects);
            }
        }else if(isDelete){
            BranchTimeSlotBookingHelper.releaseDemoTimeSlots(oldEntries);
        }
    }

    private static void assignResource(
        List<dmpl__ProductDemo__c> newEntries){
        List<dmpl__PartnerResource__c> resources = ServiceLeadHelper.queryPartnerResource(
            CollectionHelper.extractIds(
                newEntries, 
                'dmpl__PartnerAccountId__c'),
            CollectionHelper.extractIds(
                newEntries, 
                'dmpl__BranchId__c'));
        for(dmpl__ProductDemo__c productDemo : newEntries){
            List<dmpl__PartnerResource__c> applicableResources = ServiceLeadHelper.getApplicablePartnerResources(
                resources,
                productDemo.dmpl__PartnerAccountId__c,
                productDemo.dmpl__BranchId__c);
                for(dmpl__PartnerResource__c resource : applicableResources){
                    if(resource.dmpl__RuleSuccessCriteria__c == null 
                        || resource.dmpl__RuleSuccessCriteria__c == 'All Rules Are Met'){
                        if(isAllRuleMet(
                            productDemo, 
                            resource)){
                                productDemo.dmpl__ResourceId__c = resource.dmpl__ResourceId__c;
                                break;
                        }
                    }else if(resource.dmpl__RuleSuccessCriteria__c == 'Any Rule Is Met'){
                        if(isAnyRuleMet(
                            productDemo, 
                            resource)){
                                productDemo.dmpl__ResourceId__c = resource.dmpl__ResourceId__c;
                                break;
                        }
                    }else if(resource.dmpl__RuleSuccessCriteria__c == 'Always (No Criteria)'){
                        productDemo.dmpl__ResourceId__c = resource.dmpl__ResourceId__c;
                        break;
                    }
                }
        }

    }

    private static Boolean isAllRuleMet(dmpl__ProductDemo__c productDemo, dmpl__PartnerResource__c resource){
        if(resource.dmpl__ResourceAssignmentRules__r.size() == 0){
            return false;
        }
        Map<String, Schema.SObjectField> fieldMap = productDemo.getSObjectType().getDescribe().fields.getMap();
        for (dmpl__ResourceAssignmentRule__c rule :resource.dmpl__ResourceAssignmentRules__r){
            if(!evaluateRule(
                fieldMap.get(rule.dmpl__FieldName__c),
                productDemo,
                rule)){
                return false;
            }
        }
        return true;
    }

    private static Boolean isAnyRuleMet(dmpl__ProductDemo__c productDemo, dmpl__PartnerResource__c resource){
        if(resource.dmpl__ResourceAssignmentRules__r.size() == 0){
            return false;
        }
        Map<String, Schema.SObjectField> fieldMap = productDemo.getSObjectType().getDescribe().fields.getMap();
        for (dmpl__ResourceAssignmentRule__c rule :resource.dmpl__ResourceAssignmentRules__r){
            if(evaluateRule(
                fieldMap.get(rule.dmpl__FieldName__c),
                productDemo,
                rule)){
                return true;
            }
        }
        return false;
    }

    private static Boolean evaluateRule(
        Schema.SObjectField field,
        dmpl__ProductDemo__c productDemo, 
        dmpl__ResourceAssignmentRule__c rule){
        if(field == null){
            return false;
        }
        Schema.DisplayType dataType = field.getDescribe().getType();
        if(dataType == Schema.DisplayType.Double 
            || dataType == Schema.DisplayType.INTEGER 
            || dataType == Schema.DisplayType.LONG){
                return ServiceLeadHelper.evaluateNumnericValues(
                    dataType, 
                    rule.dmpl__Operation__c, 
                    productDemo.get(rule.dmpl__FieldName__c), 
                    rule.dmpl__FieldValue__c);
        }else if(dataType == Schema.DisplayType.DATE 
            || dataType == Schema.DisplayType.DATETIME){
                return ServiceLeadHelper.evaluateDateTimeValues(
                    dataType, 
                    rule.dmpl__Operation__c, 
                    productDemo.get(rule.dmpl__FieldName__c), 
                    rule.dmpl__FieldValue__c);
        }else{
            if(rule.dmpl__Operation__c == 'equals'){
                return productDemo.get(rule.dmpl__FieldName__c) == rule.dmpl__FieldValue__c;
            } else if(rule.dmpl__Operation__c == 'notEqual'){
                return productDemo.get(rule.dmpl__FieldName__c) != rule.dmpl__FieldValue__c;
            }    
        }
        return false;
    }
}