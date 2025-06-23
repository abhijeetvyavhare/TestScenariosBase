public with sharing class DocumentActionController {
    
    @AuraEnabled(cacheable = true)
    public static List<dmpl__DocumentActionSetting__mdt> getDocumentActionSettings(string objectApiName)
    {
        try {
            return DocumentActionSettingHelper.getDocumentActionSettings(objectApiName);
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    @AuraEnabled
    public static List<SObject> getChildObjects(
        Id recordSettingId, 
        Id hostId,
        String searchKey)
    {
        try {
            Id recordId = hostId;
            return Database.query(
                DocumentActionSettingHelper.getSOQLQuery(
                    DocumentActionSettingHelper.getDocumentActionSetting(recordSettingId),
                    searchKey,
                    hostId
                )
            ) ;
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    @AuraEnabled
    public static CreateRelatedResult performAction(
        Id recordSettingId, 
        Id hostId)
    {
        try {
            dmpl__DocumentActionSetting__mdt recordSetting = DocumentActionSettingHelper.getDocumentActionSetting(recordSettingId);
            switch on recordSetting.dmpl__HostObjectId__r.QualifiedApiName {
                when  'dmpl__SaleOrder__c'{
                    if(recordSetting.dmpl__ActionType__c == 'Cancel'){
                        return SaleOrderLineHelper.cancelSaleOrderLines(hostId);
                    }
                }
                when  'dmpl__InventoryFulfillment__c'{
                    if(recordSetting.dmpl__ActionType__c == 'Cancel'){
                        return FulfillmentHelper.cancelAllocation(hostId);
                    } else if(recordSetting.dmpl__ActionType__c == 'Confirm'){
                        return InventoryFulfillmentPickingLineHelper.confirmPickingFromFulfillment(hostId);
                    } else if(recordSetting.dmpl__ActionType__c == 'Return'){
                        return FulfillmentHelper.cancelPicking(hostId);
                    }
                }
                when else {
                    return perfromExternalAction(
                        'performAction',
                        recordSetting.dmpl__CustomClassName__c,
                        hostId,
                        recordSettingId,
                        null);
                }
            }
            return new CreateRelatedResult('No handler attached');
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    @AuraEnabled
    public static CreateRelatedResult performActionForSelectedObjects(
        Id hostId,
        Id recordSettingId, 
        List<SourceObjectInfo> childObjectsInfo)
    {
        try {
            dmpl__DocumentActionSetting__mdt recordSetting = DocumentActionSettingHelper.getDocumentActionSetting(recordSettingId);
            switch on recordSetting.dmpl__HostObjectId__r.QualifiedApiName {
                when 'dmpl__SaleOrder__c'{
                    if(recordSetting.dmpl__ActionType__c == 'Cancel'){
                        return SaleOrderLineHelper.cancelSaleOrderLines(
                            childObjectsInfo, 
                            hostId);
                    }
                }
                when 'dmpl__InventoryFulfillment__c'{
                    if(recordSetting.dmpl__ActionType__c == 'Cancel'){
                        return FulfillmentHelper.cancelAllocation(childObjectsInfo);
                    } else if(recordSetting.dmpl__ActionType__c == 'Confirm'){
                        return InventoryFulfillmentPickingLineHelper.confirmPickingFromFulfillment(childObjectsInfo, hostId);
                    } else if(recordSetting.dmpl__ActionType__c == 'Return'){
                        return FulfillmentHelper.cancelPicking(childObjectsInfo);
                    }
                }
                when else {
                    return perfromExternalAction(
                        'performActionForSelectedObjects',
                        recordSetting.dmpl__CustomClassName__c,
                        hostId,
                        recordSettingId,
                        childObjectsInfo);
                }
            }
            return new CreateRelatedResult('No handler attached');
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    @TestVisible
    private static CreateRelatedResult perfromExternalAction(
        String actionName,
        String className, 
        Id hostId,
        Id recordSettingId,
        List<SourceObjectInfo> childObjectsInfo){
    try
        {
            if(String.isBlank(actionName)){
                actionName = 'performAction';
            }
            System.Type typeName = Type.forName(className);
            if(typeName == null){
                throw new CalloutException(
                    'Type not found!. Please ensure that the controller class named is valid');
            }
            
            Object dynamicObject =  typeName.newInstance();
            if(dynamicObject == null){
                throw new CalloutException(
                    'Failed to create Dynamic Controller!. Please ensure that the controller class named \"' 
                    + className 
                    + '\" is creatable.');
            }

            Callable callable =  (Callable)dynamicObject;
            if(callable == null){
                throw new CalloutException(
                    'Callable Type Cast Failed!. Please ensure that the controller class named \"' 
                    + className 
                    + '\" implements Callable Interface.');
            }

            if(actionName == 'performAction'){
                return (CreateRelatedResult)callable.call(
                    actionName,
                    new Map<String, Object> {
                        'recordSettingId' => recordSettingId, 
                        'hostId' => hostId
                    });
            } else {
                return (CreateRelatedResult)callable.call(
                    actionName,
                    new Map<String, Object> {
                        'hostId' => hostId,
                        'recordSettingId' => recordSettingId, 
                        'childObjectsInfo' => childObjectsInfo
                    });
            }
        }
        catch(Exception e)
        {
            throw new DMPLException(e.getMessage());
        }
    }
}