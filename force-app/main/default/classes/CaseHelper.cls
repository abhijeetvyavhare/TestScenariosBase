public with sharing class CaseHelper {
    private static Boolean skipValidations = false;
    
    private static final string OBJECT_CASE = 'dmpl__Case__c';
    private static final string FIELD_CASE_STATUS = 'dmpl__Status__c';
    private static final string FIELD_PERFORMACTION_CREATELEAD = 'dmpl__PerformCreateLead__c';

    public static void validateData(
        Boolean isInsert, 
        Boolean isUpdate, 
        Boolean isDelete, 
        List<dmpl__Case__c> newEntries,
        List<dmpl__Case__c> oldEntries)
    {
        try {
            if(isInsert){
                FieldMappingHelper.copyFieldMappingData(
                    newEntries);
            }
            if(skipValidations){
                return;
            }
            DocumentStatusDFSHelper dfsHelper = new DocumentStatusDFSHelper();
            if(isInsert){
            }else if(isUpdate){
                dfsHelper.DocumentStatusRestrictEdits_Edit(
                    OBJECT_CASE, 
                    FIELD_CASE_STATUS, 
                    oldEntries, 
                    newEntries);
                dfsHelper.DocumentStatusRestrictFieldsEdits(
                    OBJECT_CASE, 
                    FIELD_CASE_STATUS, 
                    oldEntries, 
                    newEntries);  
            }else if(isDelete){
                dfsHelper.DocumentStatusRestrictEdits_Delete(
                    OBJECT_CASE, 
                    FIELD_CASE_STATUS, 
                    oldEntries);  
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void postData(
        Boolean isInsert,  
        Boolean isUpdate, 
        Boolean isDelete, 
        List<dmpl__Case__c> newEntries,
        List<dmpl__Case__c> oldEntries 
        )
    { 
        try {
            DocumentStatusDFSHelper dfsHelper = new DocumentStatusDFSHelper();
            if(isInsert){
                assignResource(newEntries);
                dfsHelper.DocumentStatusSetFlag(
                    OBJECT_CASE, 
                    FIELD_CASE_STATUS, 
                    newEntries);
                dfsHelper.DocumentStatusReSetFlag(
                    OBJECT_CASE, 
                    FIELD_CASE_STATUS, 
                    newEntries);
                DocumentNameHelper.generateDocumentName(newEntries);               
            }else if(isUpdate){
                dfsHelper.DocumentStatusSetFlag(
                    OBJECT_CASE,
                    FIELD_CASE_STATUS, 
                    oldEntries, 
                    newEntries);
                dfsHelper.DocumentStatusReSetFlag(
                    OBJECT_CASE, 
                    FIELD_CASE_STATUS, 
                    oldEntries, 
                    newEntries);    
                List<dmpl__Case__c> modifiedObjects = DocumentHelper.getApprovedObjects(
                    FIELD_PERFORMACTION_CREATELEAD, 
                    oldEntries, 
                    newEntries);
                if(modifiedObjects.size()>0){
                    ServiceLeadHelper.createLeadFromCase(modifiedObjects);
                    for(dmpl__Case__c caseEntry : modifiedObjects){
                        caseEntry.dmpl__PerformCreateLead__c = false;
                    }
                }           
            } 
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void afterPostData(
        Boolean isInsert,
        Boolean isUpdate, 
        Boolean isDelete, 
        List<dmpl__Case__c> newEntries,
        List<dmpl__Case__c> oldEntries)
    {
        if(isUpdate)
        {
        }
    }

    private static void assignResource(
        List<Case__c> newEntries){
        List<dmpl__PartnerResource__c> resources = ServiceLeadHelper.queryPartnerResource(
            CollectionHelper.extractIds(
                newEntries, 
                'dmpl__PartnerAccountId__c'),
            CollectionHelper.extractIds(
                newEntries, 
                'dmpl__BranchId__c'));
        for(Case__c caseObj : newEntries){
            List<dmpl__PartnerResource__c> applicableResources = ServiceLeadHelper.getApplicablePartnerResources(
                resources,
                caseObj.dmpl__PartnerAccountId__c,
                caseObj.dmpl__BranchId__c);
                for(dmpl__PartnerResource__c resource : applicableResources){
                    if(resource.dmpl__RuleSuccessCriteria__c == null 
                        || resource.dmpl__RuleSuccessCriteria__c == 'All Rules Are Met'){
                        if(isAllRuleMet(
                            caseObj, 
                            resource)){
                                caseObj.dmpl__ResourceId__c = resource.dmpl__ResourceId__c;
                                break;
                        }
                    }else if(resource.dmpl__RuleSuccessCriteria__c == 'Any Rule Is Met'){
                        if(isAnyRuleMet(
                            caseObj, 
                            resource)){
                                caseObj.dmpl__ResourceId__c = resource.dmpl__ResourceId__c;
                                break;
                        }
                    }else if(resource.dmpl__RuleSuccessCriteria__c == 'Always (No Criteria)'){
                        caseObj.dmpl__ResourceId__c = resource.dmpl__ResourceId__c;
                        break;
                    }
                }
        }

    }

    private static Boolean isAllRuleMet(
        Case__c caseObj, 
        dmpl__PartnerResource__c resource){
        if(resource.dmpl__ResourceAssignmentRules__r.size() == 0){
            return false;
        }
        Map<String, Schema.SObjectField> fieldMap = caseObj.getSObjectType().getDescribe().fields.getMap();
        for (dmpl__ResourceAssignmentRule__c rule :resource.dmpl__ResourceAssignmentRules__r){
            if(!evaluateRule(
                fieldMap.get(rule.dmpl__FieldName__c),
                caseObj,
                rule)){
                return false;
            }
        }
        return true;
    }

    private static Boolean isAnyRuleMet(
        Case__c caseObj, 
        dmpl__PartnerResource__c resource){
        if(resource.dmpl__ResourceAssignmentRules__r.size() == 0){
            return false;
        }
        Map<String, Schema.SObjectField> fieldMap = caseObj.getSObjectType().getDescribe().fields.getMap();
        for (dmpl__ResourceAssignmentRule__c rule :resource.dmpl__ResourceAssignmentRules__r){
            if(evaluateRule(
                fieldMap.get(rule.dmpl__FieldName__c),
                caseObj,
                rule)){
                return true;
            }
        }
        return false;
    }

    private static Boolean evaluateRule(
        Schema.SObjectField field,
        Case__c caseObj, 
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
                    caseObj.get(rule.dmpl__FieldName__c), 
                    rule.dmpl__FieldValue__c);
        }else if(dataType == Schema.DisplayType.DATE 
            || dataType == Schema.DisplayType.DATETIME){
                return ServiceLeadHelper.evaluateDateTimeValues(
                    dataType, 
                    rule.dmpl__Operation__c, 
                    caseObj.get(rule.dmpl__FieldName__c), 
                    rule.dmpl__FieldValue__c);
        }else{
            if(rule.dmpl__Operation__c == 'equals'){
                return caseObj.get(rule.dmpl__FieldName__c) == rule.dmpl__FieldValue__c;
            } else if(rule.dmpl__Operation__c == 'notEqual'){
                return caseObj.get(rule.dmpl__FieldName__c) != rule.dmpl__FieldValue__c;
            }    
        }
        return false;
    }
}