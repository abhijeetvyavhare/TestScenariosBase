global with sharing class GlobalExtensionHelper {
    
    global static void executeQueue(Id queueId){
        JobTypeHelper.executeQueue(queueId);
    }

    global static CreateRelatedResult releaseDocument(
        Id recordSettingId, 
        Id hostId,
        Integer recordCount){
            return DocumentSelectorController.releaseDocument(
                recordSettingId,
                hostId,
                recordCount);
        }

    global static CreateRelatedResult releaseChildDocuments(
        Id recordSettingId, 
        Id hostId,
        List<SourceObjectInfo> childObjectsInfo){
            return DocumentSelectorController.releaseChildDocuments(
                recordSettingId,
                hostId,
                childObjectsInfo);
    }

    global static void processSchemes(List<SObject> documents){
        SchemeEngine.processSchemes(documents);
    }
    
    global static Boolean applySchemeBenefit(
        SObject document,
        Id schemeLineId,
        Id benefitId,
        Integer benefitCustomIndex,
        List<SourceObjectInfo> selectedItemInfo){
        return SchemeEngine.applySchemeBenefit(document, schemeLineId, benefitId, benefitCustomIndex, selectedItemInfo);
    }

    global static Boolean resetSchemeBenefit(
        SObject document){
        return SchemeEngine.resetSchemeBenefit(document);
    }
    
    global static List<SchemeLine__c> getQualifiedSchemeLines(SObject document){
        return SchemeEngine.getQualifiedSchemeLines(document);
    }
}