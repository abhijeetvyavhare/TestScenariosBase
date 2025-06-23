public with sharing class ChecklistLineHelper {

    public static void validateData(
        Boolean isInsert, 
        Boolean isUpdate, 
        Boolean isDelete, 
        List<dmpl__CheckListLines__c> newEntries, 
        List<dmpl__CheckListLines__c> oldEntries)
    {
        try {
            if(isInsert){
                FieldMappingHelper.copyFieldMappingData(
                    newEntries);
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void postData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<dmpl__CheckListLines__c> newEntries, List<dmpl__CheckListLines__c> oldEntries)
    {
        if(isDelete){
            deleteServiceRecommendations(oldEntries);
        }
    }

    public static void afterPostData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<dmpl__CheckListLines__c> newEntries, List<dmpl__CheckListLines__c> oldEntries)
    {
        if(isInsert){
            insertServiceRecommendations(newEntries);
        } else if(isUpdate){
            updateServiceRecommendations(newEntries, oldEntries);
        }
    }

    private static void deleteServiceRecommendations(List<dmpl__CheckListLines__c> oldEntries)
    {
        SecurityHelper.ensureCanDeleteObject('dmpl__ServiceRecommendation__c');
        DELETE [SELECT Id, Name FROM dmpl__ServiceRecommendation__c WHERE dmpl__ChecklistLineId__c IN : DocumentHelper.extractIds(oldEntries) AND dmpl__IsUtilized__c = false];
    }

    private static void insertServiceRecommendations(List<dmpl__CheckListLines__c> newEntries)
    {
        List<dmpl__ServiceRecommendation__c> newServiceRecommendations = new List<dmpl__ServiceRecommendation__c>();
        List<dmpl__ServiceRecommendationRule__c> serviceRecommendationRules = queryServiceRecommendationRules(DocumentHelper.extractIds(newEntries, 'dmpl__CheckListTemplateLineId__c'));

        for(dmpl__CheckListLines__c checklistLine : newEntries)
        {
            List<dmpl__ServiceRecommendationRule__c> filteredServiceRecommendationRules = DocumentHelper.getObjectsByFilter(serviceRecommendationRules, 'dmpl__ChecklistTemplateLineId__c', checklistLine.dmpl__ChecklistTemplateLineId__c);
            for(dmpl__ServiceRecommendationRule__c serviceRecommendationRule : filteredServiceRecommendationRules)
            {
                if((serviceRecommendationRule.dmpl__RAGValue__c != '' && checklistLine.dmpl__RAGValue__c != '' && serviceRecommendationRule.dmpl__ValueGreaterThan__c == null && serviceRecommendationRule.dmpl__ValueLessThan__c == null && serviceRecommendationRule.dmpl__RAGValue__c == checklistLine.dmpl__RAGValue__c)
                ||( serviceRecommendationRule.dmpl__ValueGreaterThan__c != null && serviceRecommendationRule.dmpl__ValueLessThan__c == null && checklistLine.dmpl__NumericValue__c != null  && checklistLine.dmpl__NumericValue__c >  serviceRecommendationRule.dmpl__ValueGreaterThan__c)
                ||( serviceRecommendationRule.dmpl__ValueLessThan__c != null && serviceRecommendationRule.dmpl__ValueGreaterThan__c == null && checklistLine.dmpl__NumericValue__c != null  && checklistLine.dmpl__NumericValue__c <  serviceRecommendationRule.dmpl__ValueLessThan__c)
                ||( serviceRecommendationRule.dmpl__ValueGreaterThan__c != null && serviceRecommendationRule.dmpl__ValueLessThan__c != null && checklistLine.dmpl__NumericValue__c != null  && checklistLine.dmpl__NumericValue__c <  serviceRecommendationRule.dmpl__ValueLessThan__c && checklistLine.dmpl__NumericValue__c > serviceRecommendationRule.dmpl__ValueGreaterThan__c)
                ||( serviceRecommendationRule.dmpl__RAGValue__c == null && serviceRecommendationRule.dmpl__ValueGreaterThan__c == null && serviceRecommendationRule.dmpl__ValueLessThan__c == null && checklistLine.dmpl__TextValue__c != null && checklistLine.dmpl__DataType__c == 'Text'))
                {
                    newServiceRecommendations.add(
                        new dmpl__ServiceRecommendation__c(
                            dmpl__ChecklistLineId__c = checklistLine.Id,
                            dmpl__ServiceRequestId__c = checklistLine.dmpl__ServiceRequestId__c,
                            dmpl__RepairOrderId__c = checklistLine.dmpl__RepairOrderId__c,
                            dmpl__QuoteId__c = checklistLine.dmpl__QuoteId__c,
                            dmpl__RecommendationType__c = serviceRecommendationRule.dmpl__RecommendationType__c,
                            dmpl__ItemId__c = serviceRecommendationRule.dmpl__ItemId__c,
                            dmpl__NumericValue__c = checklistLine.dmpl__NumericValue__c,
                            dmpl__TextValue__c = checklistLine.dmpl__TextValue__c,
                            dmpl__ValueType__c = checklistLine.dmpl__DataType__c,
                            dmpl__Condition__c = checklistLine.dmpl__RAGValue__c
                        )
                    );
                }
            }
        }

        if(newServiceRecommendations.size() > 0)
        {
            SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__ChecklistLineId__c','dmpl__ServiceRequestId__c','dmpl__RepairOrderId__c','dmpl__QuoteId__c','dmpl__RecommendationType__c','dmpl__NumericValue__c','dmpl__ItemId__c','dmpl__TextValue__c','dmpl__ValueType__c','dmpl__Condition__c'}, 'dmpl__ServiceRecommendation__c');
            insert newServiceRecommendations;
        }
    }

    private static void updateServiceRecommendations(List<dmpl__CheckListLines__c> newEntries, List<dmpl__CheckListLines__c> oldEntries)
    {
        List<dmpl__CheckListLines__c> modifiedObjects = new List<dmpl__CheckListLines__c>();
        Map<Id, dmpl__CheckListLines__c> oldEntriesMap = new Map<Id, dmpl__CheckListLines__c>(oldEntries);
        modifiedObjects.addAll((List<dmpl__CheckListLines__c>)DocumentHelper.getModifiedNewObjects('dmpl__RAGValue__c', oldEntries, newEntries));
        modifiedObjects.addAll((List<dmpl__CheckListLines__c>)DocumentHelper.getModifiedNewObjects('dmpl__NumericValue__c', oldEntries, newEntries));

        List<dmpl__ServiceRecommendation__c> serviceRecommendations = queryServiceRecommendations(DocumentHelper.extractIds(modifiedObjects, 'Id'));
        List<dmpl__ServiceRecommendationRule__c> serviceRecommendationRules = queryServiceRecommendationRules(DocumentHelper.extractIds(modifiedObjects, 'dmpl__CheckListTemplateLineId__c'));

        List<dmpl__ServiceRecommendation__c> insertServiceRecommendations = new List<dmpl__ServiceRecommendation__c>();
        List<dmpl__ServiceRecommendation__c> deleteServiceRecommendations = new List<dmpl__ServiceRecommendation__c>();
        for(dmpl__ChecklistLines__c lineEntry : modifiedObjects)
        {
            dmpl__CheckListLines__c oldEntry = oldEntriesMap.get(lineEntry.Id);
                List<dmpl__ServiceRecommendation__c> currentServiceRecommendations = DocumentHelper.getObjectsByFilter(serviceRecommendations, 'dmpl__ChecklistLineId__c', lineEntry.Id);
                List<dmpl__ServiceRecommendationRule__c> eligibleServiceRecommendations = getEligibleServiceRecommendationRules(serviceRecommendationRules, lineEntry);

                // INSERT CASE
                for(dmpl__ServiceRecommendationRule__c eligibleServiceRecommendation : eligibleServiceRecommendations)
                {
                    Boolean isFound = false;
                    for(dmpl__ServiceRecommendation__c currentServiceRecommendation : currentServiceRecommendations)
                    {
                        if(currentServiceRecommendation.dmpl__ItemId__c == eligibleServiceRecommendation.dmpl__ItemId__c)
                        {
                            isFound = true;
                            break;
                        }
                    }
                    if(!isFound)
                    {
                        insertServiceRecommendations.add(
                            new dmpl__ServiceRecommendation__c(
                            dmpl__ChecklistLineId__c = lineEntry.Id,
                            dmpl__ServiceRequestId__c = lineEntry.dmpl__ServiceRequestId__c,
                            dmpl__RepairOrderId__c = lineEntry.dmpl__RepairOrderId__c,
                            dmpl__QuoteId__c = lineEntry.dmpl__QuoteId__c,
                            dmpl__ItemId__c = eligibleServiceRecommendation.dmpl__ItemId__c,
                            dmpl__RecommendationType__c = eligibleServiceRecommendation.dmpl__RecommendationType__c,
                            dmpl__NumericValue__c = lineEntry.dmpl__NumericValue__c,
                            dmpl__TextValue__c = lineEntry.dmpl__TextValue__c,
                            dmpl__ValueType__c = lineEntry.dmpl__DataType__c,
                            dmpl__Condition__c = lineEntry.dmpl__RAGValue__c
                        ));
                    }
                }

                // DELETE CASE
                for(dmpl__ServiceRecommendation__c currentServiceRecommendation : currentServiceRecommendations)
                {
                    Boolean isFound = false;
                    for(dmpl__ServiceRecommendationRule__c eligibleServiceRecommendation : eligibleServiceRecommendations)
                    {
                        if(currentServiceRecommendation.dmpl__ItemId__c == eligibleServiceRecommendation.dmpl__ItemId__c)
                        {
                            isFound = true;
                            break;
                        }
                    }

                    if(!isFound)
                    {
                        deleteServiceRecommendations.add(currentServiceRecommendation);
                    }
                }
            }

        if(insertServiceRecommendations.size()>0){
            SecurityHelper.ensureCanCreateFields(new String[]{
                'dmpl__ChecklistLineId__c',
                'dmpl__ServiceRequestId__c',
                'dmpl__RepairOrderId__c',
                'dmpl__QuoteId__c',
                'dmpl__ItemId__c',
                'dmpl__RecommendationType__c',
                'dmpl__NumericValue__c',
                'dmpl__TextValue__c',
                'dmpl__ValueType__c',
                'dmpl__Condition__c' 
            },
            'dmpl__ServiceRecommendation__c');
            insert insertServiceRecommendations;
        }

        if(deleteServiceRecommendations.size()>0){
            SecurityHelper.ensureCanDeleteObject('dmpl__ServiceRecommendation__c');
            delete deleteServiceRecommendations;
        }
    }

    private static List<dmpl__ServiceRecommendationRule__c> getEligibleServiceRecommendationRules(List<dmpl__ServiceRecommendationRule__c> serviceRecommendationRules, dmpl__CheckListLines__c checklistLine)
    {
        List<dmpl__ServiceRecommendationRule__c> result = new List<dmpl__ServiceRecommendationRule__c>();
        for(dmpl__ServiceRecommendationRule__c serviceRecommendationRule : serviceRecommendationRules)
        {
            if((serviceRecommendationRule.dmpl__RAGValue__c != '' && checklistLine.dmpl__RAGValue__c != '' && serviceRecommendationRule.dmpl__ValueGreaterThan__c == null && serviceRecommendationRule.dmpl__ValueLessThan__c == null && serviceRecommendationRule.dmpl__RAGValue__c == checklistLine.dmpl__RAGValue__c)
                ||( serviceRecommendationRule.dmpl__ValueGreaterThan__c != null && serviceRecommendationRule.dmpl__ValueLessThan__c == null && checklistLine.dmpl__NumericValue__c != null  && checklistLine.dmpl__NumericValue__c >  serviceRecommendationRule.dmpl__ValueGreaterThan__c)
                ||( serviceRecommendationRule.dmpl__ValueLessThan__c != null && serviceRecommendationRule.dmpl__ValueGreaterThan__c == null && checklistLine.dmpl__NumericValue__c != null  && checklistLine.dmpl__NumericValue__c <  serviceRecommendationRule.dmpl__ValueLessThan__c)
                ||( serviceRecommendationRule.dmpl__ValueGreaterThan__c != null && serviceRecommendationRule.dmpl__ValueLessThan__c != null && checklistLine.dmpl__NumericValue__c != null  && checklistLine.dmpl__NumericValue__c <  serviceRecommendationRule.dmpl__ValueLessThan__c && checklistLine.dmpl__NumericValue__c > serviceRecommendationRule.dmpl__ValueGreaterThan__c)
                ||( serviceRecommendationRule.dmpl__RAGValue__c == null && serviceRecommendationRule.dmpl__ValueGreaterThan__c == null && serviceRecommendationRule.dmpl__ValueLessThan__c == null && checklistLine.dmpl__TextValue__c != null && checklistLine.dmpl__DataType__c == 'Text'))
                result.add(serviceRecommendationRule);
        }

        return result;
    }

    private static List<dmpl__ServiceRecommendation__c> queryServiceRecommendations(List<Id> checklistIds)
    {
        SecurityHelper.ensureCanReadFields(new String[]{
            'dmpl__AssetId__c',
            'dmpl__ChecklistLineId__c',
            'dmpl__ComplaintLineId__c',
            'dmpl__Condition__c',
            'dmpl__ExternalId__c',
            'dmpl__IsConsumed__c',
            'dmpl__IsUtilized__c',
            'dmpl__ItemId__c',
            'dmpl__NumericValue__c',
            'dmpl__QuoteId__c',
            'dmpl__QuoteLineId__c',
            'dmpl__RecommendationRemarks__c',
            'dmpl__RepairOrderId__c',
            'dmpl__RepairOrderLineId__c',
            'dmpl__ServiceRequestId__c',
            'dmpl__ServiceRequestLineId__c',
            'dmpl__TextValue__c',
            'dmpl__ValueType__c'
        },
        'dmpl__ServiceRecommendation__c');
        return [SELECT
            dmpl__AssetId__c,
            dmpl__ChecklistLineId__c,
            dmpl__ComplaintLineId__c,
            dmpl__Condition__c,
            dmpl__ExternalId__c,
            dmpl__IsConsumed__c,
            dmpl__IsUtilized__c,
            dmpl__ItemId__c,
            dmpl__NumericValue__c,
            dmpl__QuoteId__c,
            dmpl__QuoteLineId__c,
            dmpl__RecommendationRemarks__c,
            dmpl__RepairOrderId__c,
            dmpl__RepairOrderLineId__c,
            dmpl__ServiceRequestId__c,
            dmpl__ServiceRequestLineId__c,
            dmpl__TextValue__c,
            dmpl__ValueType__c,
            Id,
            Name
        FROM
            dmpl__ServiceRecommendation__c
            WHERE dmpl__ChecklistLineId__c IN : checklistIds];
    }

    private static List<dmpl__ServiceRecommendationRule__c> queryServiceRecommendationRules(List<Id> checklistTemplateLineIds)
    {
        SecurityHelper.ensureCanReadFields(new String[]{
            'dmpl__ChecklistTemplateLineId__c',
            'dmpl__ItemId__c',
            'dmpl__Quantity__c',
            'dmpl__RAGValue__c',
            'dmpl__RecommendationType__c',
            'dmpl__ValueLessThan__c',
            'dmpl__ValueGreaterThan__c',
            'dmpl__ComplaintId__c'
        },
        'dmpl__ServiceRecommendationRule__c');
        return [
        SELECT
            dmpl__ChecklistTemplateLineId__c,
            dmpl__ComplaintId__c,
            dmpl__ItemId__c,
            dmpl__Quantity__c,
            dmpl__RAGValue__c,
            dmpl__RecommendationType__c,
            dmpl__ValueGreaterThan__c,
            dmpl__ValueLessThan__c,
            Id,
            Name
        FROM
            dmpl__ServiceRecommendationRule__c
            WHERE dmpl__ChecklistTemplateLineId__c IN : checklistTemplateLineIds];
    }

    public static void createChecklistLines(List<dmpl__DeliveryOrder__c> lineEntries){

        List<dmpl__CheckListTemplateLine__c> checkListTemplateLines = queryChecklistTemplateLines('Delivery');
        List<dmpl__CheckListLines__c> checkListLines = new List<dmpl__CheckListLines__c>();

        for(dmpl__DeliveryOrder__c order : lineEntries)
        {
            for(dmpl__CheckListTemplateLine__c checkListTemplateLine : checkListTemplateLines)
            {
                checkListLines.add( new dmpl__CheckListLines__c (
                    dmpl__DeliveryOrderId__c = order.Id,
                    dmpl__ChecklistTemplateId__c = checkListTemplateLine.dmpl__ChecklistTemplateId__c,
                    dmpl__CheckListTemplateLineId__c = checkListTemplateLine.Id,
                    dmpl__DataType__c = checkListTemplateLine.dmpl__DataType__c,
                    Name = checkListTemplateLine.Name
                ));
            }
        }
        SecurityHelper.ensureCanCreateObject('dmpl__CheckListLines__c');
        SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__DeliveryOrderId__c','dmpl__ChecklistTemplateId__c','dmpl__CheckListTemplateLineId__c','dmpl__DataType__c'}, 'dmpl__CheckListLines__c');
        if(checkListLines.size() > 0)
            insert checkListLines;
    }

    public static void createChecklistLines(List<dmpl__RepairOrder__c> lineEntries){

        List<dmpl__CheckListTemplateLine__c> checkListTemplateLines = queryChecklistTemplateLines('Repair Order');
        List<dmpl__CheckListLines__c> checkListLines = new List<dmpl__CheckListLines__c>();

        for(dmpl__RepairOrder__c order : lineEntries)
        {
            for(dmpl__CheckListTemplateLine__c checkListTemplateLine : checkListTemplateLines)
            {
                checkListLines.add( new dmpl__CheckListLines__c (
                    dmpl__RepairOrderId__c = order.Id,
                    dmpl__ChecklistTemplateId__c = checkListTemplateLine.dmpl__ChecklistTemplateId__c,
                    dmpl__CheckListTemplateLineId__c = checkListTemplateLine.Id,
                    dmpl__DataType__c = checkListTemplateLine.dmpl__DataType__c,
                    Name = checkListTemplateLine.Name
                ));
            }
        }
        SecurityHelper.ensureCanCreateObject('dmpl__CheckListLines__c');
        SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__RepairOrderId__c','dmpl__ChecklistTemplateId__c','dmpl__CheckListTemplateLineId__c','dmpl__DataType__c'}, 'dmpl__CheckListLines__c');
        if(checkListLines.size() > 0)
            insert checkListLines;               
    }

    public static void createChecklistLines(List<dmpl__GoodsReceipt__c> lineEntries){

        List<dmpl__CheckListTemplateLine__c> checkListTemplateLines = queryChecklistTemplateLines('Goods Receipt');
        List<dmpl__CheckListLines__c> checkListLines = new List<dmpl__CheckListLines__c>();

        for(dmpl__GoodsReceipt__c order : lineEntries)
        {
            for(dmpl__CheckListTemplateLine__c checkListTemplateLine : checkListTemplateLines)
            {
                checkListLines.add( new dmpl__CheckListLines__c (
                    dmpl__GoodsReceiptId__c = order.Id,
                    dmpl__ChecklistTemplateId__c = checkListTemplateLine.dmpl__ChecklistTemplateId__c,
                    dmpl__CheckListTemplateLineId__c = checkListTemplateLine.Id,
                    dmpl__DataType__c = checkListTemplateLine.dmpl__DataType__c,
                    Name = checkListTemplateLine.Name
                ));
            }
        }

        SecurityHelper.ensureCanCreateObject('dmpl__CheckListLines__c');
        SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__GoodsReceiptId__c','dmpl__ChecklistTemplateId__c','dmpl__CheckListTemplateLineId__c','dmpl__DataType__c'}, 'dmpl__CheckListLines__c');
        if(checkListLines.size() > 0)
            insert checkListLines;
    }

    public static void createChecklistLines(List<dmpl__InspectionLine__c> lineEntries){

        List<dmpl__CheckListTemplateLine__c> checkListTemplateLines = queryChecklistTemplateLines('Inspection');
        List<dmpl__CheckListLines__c> checkListLines = new List<dmpl__CheckListLines__c>();

        for(dmpl__InspectionLine__c order : lineEntries)
        {
            for(dmpl__CheckListTemplateLine__c checkListTemplateLine : checkListTemplateLines)
            {
                checkListLines.add( new dmpl__CheckListLines__c (
                    dmpl__InspectionLineId__c = order.Id,
                    dmpl__ChecklistTemplateId__c = checkListTemplateLine.dmpl__ChecklistTemplateId__c,
                    dmpl__CheckListTemplateLineId__c = checkListTemplateLine.Id,
                    dmpl__DataType__c = checkListTemplateLine.dmpl__DataType__c,
                    Name = checkListTemplateLine.Name
                ));
            }
        }

        SecurityHelper.ensureCanCreateObject('dmpl__CheckListLines__c');
        SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__InspectionLineId__c','dmpl__ChecklistTemplateId__c','dmpl__CheckListTemplateLineId__c','dmpl__DataType__c'}, 'dmpl__CheckListLines__c');
        if(checkListLines.size() > 0)
            insert checkListLines;
    }

    private static List<dmpl__CheckListTemplateLine__c> queryChecklistTemplateLines(String type)
    {
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__ChecklistTemplateId__c',' dmpl__DataType__c,'}, 'dmpl__CheckListTemplateLine__c');
        return [Select Id,Name,dmpl__ChecklistTemplateId__c,dmpl__DataType__c from dmpl__CheckListTemplateLine__c Where dmpl__ChecklistTemplateId__r.dmpl__Type__c =: type];
    }
    
}