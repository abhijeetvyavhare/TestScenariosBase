public with sharing class ComplaintLineHelper {

    public static void validateData(
        Boolean isInsert, 
        Boolean isUpdate, 
        Boolean isDelete, 
        List<dmpl__ComplaintLine__c> newEntries, 
        List<dmpl__ComplaintLine__c> oldEntries){
    }
    
    public static void postData(
        Boolean isInsert, 
        Boolean isUpdate, 
        Boolean isDelete, 
        List<dmpl__ComplaintLine__c> newEntries, 
        List<dmpl__ComplaintLine__c> oldEntries)  {
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

    public static void afterPostData(
        Boolean isInsert, 
        Boolean isUpdate, 
        Boolean isDelete, 
        List<dmpl__ComplaintLine__c> newEntries, 
        List<dmpl__ComplaintLine__c> oldEntries)
    {
        if(isInsert){
            insertServiceRecommendations(newEntries);
        } else if(isUpdate){
            updateServiceRecommendations(newEntries, oldEntries);
        } else if(isDelete){
            deleteServiceRecommendations(oldEntries);
        }
    }

    private static void deleteServiceRecommendations(List<dmpl__ComplaintLine__c> oldEntries){
        SecurityHelper.ensureCanDeleteObject('dmpl__ServiceRecommendation__c');
        DELETE [SELECT Id, Name FROM dmpl__ServiceRecommendation__c WHERE dmpl__ComplaintLineId__c IN : DocumentHelper.extractIds(oldEntries)];
    }

    private static void insertServiceRecommendations(List<dmpl__ComplaintLine__c> newEntries){
        List<dmpl__ServiceRecommendation__c> newServiceRecommendations = new List<dmpl__ServiceRecommendation__c>();
        List<dmpl__ComplaintItem__c> complaintItems = queryComplaintItems(
            DocumentHelper.extractIds(
                newEntries, 
                'dmpl__ComplaintId__c'));

        for(dmpl__ComplaintLine__c complaintLine : newEntries){
            List<dmpl__ComplaintItem__c> comItems = DocumentHelper.getObjectsByFilter(
                complaintItems, 
                'dmpl__ComplaintId__c', 
                complaintLine.dmpl__ComplaintId__c);
            String source = complaintLine.dmpl__RepairOrderId__c != null ? 
                'Repair Order Complaint' : complaintLine.dmpl__ServiceRequestId__c != null ?
                'Service Request Complaint' : 'Service Estimate Complaint';
            for(dmpl__ComplaintItem__c comItem : comItems){
                String itemDescription = (comItem.dmpl__ItemId__r?.dmpl__Description__c == null) ? ('') : (' - ' + comItem.dmpl__ItemId__r?.dmpl__Description__c);
                if(comItem.dmpl__ComplaintFaultCodeId__c == null 
                    || comItem.dmpl__ComplaintFaultCodeId__c == complaintLine.dmpl__ComplaintFaultCodeId__c ){
                    newServiceRecommendations.add(
                        new dmpl__ServiceRecommendation__c(
                            dmpl__ComplaintLineId__c = complaintLine.Id,
                                    dmpl__Source__c = source,
                                    dmpl__ServiceRequestId__c = complaintLine.dmpl__ServiceRequestId__c,
                                    dmpl__RepairOrderId__c = complaintLine.dmpl__RepairOrderId__c,
                                    dmpl__QuoteId__c = complaintLine.dmpl__ServiceEstimateId__c,
                                    dmpl__RecommendationType__c = comItem.dmpl__IsMandatory__c !=null 
                                        && comItem.dmpl__IsMandatory__c ==true ? 'Madatory' : 'Optional',
                                    dmpl__Recommendation__c = getRecommendationText(comItem),
                                    dmpl__Title__c = comItem.dmpl__ItemId__r?.Name + itemDescription,
                                    dmpl__IconName__c = 'standard:incident',
                                    dmpl__ItemId__c = comItem.dmpl__ItemId__c,
                                    dmpl__Quantity__c = comItem.dmpl__Quantity__c,
                                    dmpl__ComplaintItemId__c = comItem.Id,
                                    dmpl__AcceptLabel__c = 'Accept',
                                    dmpl__RejectLabel__c = 'Dismiss'
                        )
                    );
                }
            }
        }

        if(newServiceRecommendations.size() > 0){
            SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__complaintLineId__c','dmpl__ServiceRequestId__c','dmpl__RepairOrderId__c','dmpl__QuoteId__c','dmpl__RecommendationType__c','dmpl__NumericValue__c','dmpl__ItemId__c','dmpl__TextValue__c','dmpl__ValueType__c','dmpl__Condition__c'}, 'dmpl__ServiceRecommendation__c');
            insert newServiceRecommendations;
        }
    }

    private static void updateServiceRecommendations(List<dmpl__ComplaintLine__c> newEntries, List<dmpl__ComplaintLine__c> oldEntries){
        List<dmpl__ComplaintLine__c> modifiedObjects = new List<dmpl__ComplaintLine__c>();
        Map<Id, dmpl__ComplaintLine__c> oldEntriesMap = new Map<Id, dmpl__ComplaintLine__c>(oldEntries);
        modifiedObjects.addAll((List<dmpl__ComplaintLine__c>)DocumentHelper.getModifiedNewObjects('dmpl__ComplaintId__c', oldEntries, newEntries));
        modifiedObjects.addAll((List<dmpl__ComplaintLine__c>)DocumentHelper.getModifiedNewObjects('dmpl__ComplaintFaultCodeId__c', oldEntries, newEntries));

        List<dmpl__ServiceRecommendation__c> serviceRecommendations = queryServiceRecommendations(DocumentHelper.extractIds(modifiedObjects));
        List<dmpl__ComplaintItem__c> complaintItems = queryComplaintItems(
            DocumentHelper.extractIds(
                newEntries, 
                'dmpl__ComplaintId__c'));

        List<dmpl__ServiceRecommendation__c> insertServiceRecommendations = new List<dmpl__ServiceRecommendation__c>();
        List<dmpl__ServiceRecommendation__c> deleteServiceRecommendations = new List<dmpl__ServiceRecommendation__c>();
        for(dmpl__ComplaintLine__c lineEntry : modifiedObjects){
            dmpl__ComplaintLine__c oldEntry = oldEntriesMap.get(lineEntry.Id);
            List<dmpl__ComplaintItem__c> comItems = DocumentHelper.getObjectsByFilter(
                complaintItems, 
                'dmpl__ComplaintId__c', 
                lineEntry.dmpl__ComplaintId__c);

            List<dmpl__ServiceRecommendation__c> currentServiceRecommendations = DocumentHelper.getObjectsByFilter(
                serviceRecommendations, 
                'dmpl__ComplaintLineId__c', 
                lineEntry.Id);

            String source = lineEntry.dmpl__RepairOrderId__c != null ? 
                'Repair Order Complaint' : lineEntry.dmpl__ServiceRequestId__c != null ?
                'Service Request Complaint' : 'Service Estimate Complaint';
                for(dmpl__ComplaintItem__c comItem : comItems){
                    if(CollectionHelper.getObjectsByFilter(
                        currentServiceRecommendations, 
                        'dmpl__ComplaintItemId__c', 
                        comItem.Id) == null){
                            insertServiceRecommendations.add(
                                new dmpl__ServiceRecommendation__c(
                                    dmpl__ComplaintLineId__c = lineEntry.Id,
                                    dmpl__Source__c = source,
                                    dmpl__ServiceRequestId__c = lineEntry.dmpl__ServiceRequestId__c,
                                    dmpl__RepairOrderId__c = lineEntry.dmpl__RepairOrderId__c,
                                    dmpl__QuoteId__c = lineEntry.dmpl__ServiceEstimateId__c,
                                    dmpl__RecommendationType__c = comItem.dmpl__IsMandatory__c !=null 
                                        && comItem.dmpl__IsMandatory__c ==true ? 'Madatory' : 'Optional',
                                    dmpl__Recommendation__c = getRecommendationText(comItem),
                                    dmpl__Title__c = comItem.dmpl__ItemId__r?.Name,
                                    dmpl__IconName__c = 'standard:incident',
                                    dmpl__ItemId__c = comItem.dmpl__ItemId__c,
                                    dmpl__Quantity__c = comItem.dmpl__Quantity__c,
                                    dmpl__ComplaintItemId__c = comItem.Id,
                                    dmpl__AcceptLabel__c = 'Accept',
                                    dmpl__RejectLabel__c = 'Dismiss'
                            ));
                    }
                }

                for(dmpl__ServiceRecommendation__c currentServiceRecommendation : currentServiceRecommendations){
                    if(CollectionHelper.getObject(
                        comItems, 
                        currentServiceRecommendation.dmpl__ComplaintItemId__c) == null){
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

    private static String getRecommendationText(dmpl__ComplaintItem__c comItem){
        String recommText = 'Complaint : ' + comItem.dmpl__ComplaintId__r.Name;
        if(comItem.dmpl__ComplaintFaultCodeId__c != null ){
            recommText += ' Fault : ' + comItem.dmpl__ComplaintFaultCodeId__r.Name;
        }
        if(comItem.dmpl__Quantity__c !=null){
            recommText += ' Recommended Qty :' + comItem.dmpl__Quantity__c;
        }
        return recommText;
    }

    private static List<dmpl__ServiceRecommendation__c> queryServiceRecommendations(List<Id> complaintLineIds){
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
            dmpl__ComplaintItemId__c,
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
            WHERE dmpl__ComplaintLineId__c IN : complaintLineIds];
    }

    private static List<dmpl__ComplaintItem__c> queryComplaintItems(List<Id> complaintIds){
        return [
        SELECT
            dmpl__ComplaintId__c,
            dmpl__ComplaintId__r.Name,
            dmpl__ComplaintFaultCodeId__c,
            dmpl__ComplaintFaultCodeId__r.Name,
            dmpl__ItemId__c,
            dmpl__ItemId__r.Name,
            dmpl__ItemId__r.dmpl__Description__c,
            dmpl__Quantity__c,
            dmpl__IsMandatory__c,
            Id,
            Name
        FROM
            dmpl__ComplaintItem__c
        WHERE 
            dmpl__ItemId__c != null
            AND dmpl__ComplaintId__c IN : complaintIds];
    }
}