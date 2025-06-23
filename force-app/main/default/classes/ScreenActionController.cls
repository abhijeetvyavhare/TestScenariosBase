public with sharing class ScreenActionController {

    @AuraEnabled(cacheable = true)
    public static SObject getSourceObject(String objectApiName, Id recordId)
    {
        String safeRecordId = String.escapeSingleQuotes(recordId);
        String safeRecordApiName = String.escapeSingleQuotes(objectApiName);
        SecurityHelper.ensureCanReadFields(new List<String>
        {
            'dmpl__PartnerAccountId__c',
            'dmpl__BranchId__c',
            'dmpl__AccountId__c'
        }, safeRecordApiName);

        return CollectionHelper.getFirstIfExists(Database.query(
            'SELECT Id, dmpl__PartnerAccountId__c, dmpl__BranchId__c, dmpl__AccountId__c FROM ' 
            + String.escapeSingleQuotes(safeRecordApiName)
            + ' WHERE Id = :safeRecordId' ));
    }

    @AuraEnabled(cacheable = true)
    public static List<dmpl__DomainSetting__mdt> getActionSettings(String actionSettingName, String objectApiName)
    {
        return (new AppointmentActionDFSHelper()).getActionDomainSetting(
            actionSettingName, 
            String.escapeSingleQuotes(objectApiName));
    }


    //Deprecated
    @AuraEnabled(cacheable = true)
    public static List<dmpl__DomainSetting__mdt> getRecordFormActionSettings(String actionSettingName, String objectApiName)
    {
        return (new RecordFormDFSHelper()).getActionDomainSetting(
            actionSettingName, 
            String.escapeSingleQuotes(objectApiName));
    }
    
    @AuraEnabled(cacheable = true)
    public static List<dmpl__ScreenActionSetting__mdt> geScreenActionSettings(String objectApiName, String recordTypeId)
    {
        String safeRecordApiName = String.escapeSingleQuotes(objectApiName);
        String recordTypeName = null;
        SObjectType objectType = Schema.getGlobalDescribe().get(objectApiName);
        if(objectType!=null){
            if(!String.isBlank(recordTypeId)){
                Schema.RecordTypeInfo info = objectType.getDescribe().getRecordTypeInfosById().get(recordTypeId);
                if(info!=null){
                    recordTypeName = info.getDeveloperName();
                }
            } else {
                for(Schema.RecordTypeInfo info : objectType.getDescribe().getRecordTypeInfos()){
                    if(info.isAvailable() && info.isDefaultRecordTypeMapping()){
                        recordTypeName = info.getDeveloperName();
                        break;
                    }
                }
            }
        }
        
        return [SELECT
            Id,
            dmpl__DisabledFields__c,
            dmpl__ObjectNameId__c,
            dmpl__RecordPanelFieldset__c,
            dmpl__RecordPanelTitle__c,
            dmpl__Tab1Section1Fieldset__c,
            dmpl__Tab3Section1Fieldset__c,
            dmpl__Tab2Section1Fieldset__c,
            dmpl__Tab1Section1Title__c,
            dmpl__Tab3Section1Title__c,
            dmpl__Tab2Section1Title__c,
            dmpl__Tab1Section2Fieldset__c,
            dmpl__Tab3Section2Fieldset__c,
            dmpl__Tab2Section2Fieldset__c,
            dmpl__Tab1Section2Title__c,
            dmpl__Tab3Section2Title__c,
            dmpl__Tab2Section2Title__c,
            dmpl__Tab1Title__c,
            dmpl__Title__c,
            dmpl__Tab3Title__c,
            dmpl__Tab2Title__c,
            dmpl__CustomLookupShowNew__c,
            dmpl__HideLeftPanel__c,
            dmpl__ShowBillingAddressOptions__c,
            dmpl__ShowShippingAddressOptions2__c,
            dmpl__CustomLookupFieldName__r.QualifiedApiName,
            dmpl__CustomLookupFieldsetName__c,
            dmpl__CustomLookupFilter__c,
            dmpl__CustomLookupFieldName2__r.QualifiedApiName,
            dmpl__CustomLookupFieldsetName2__c,
            dmpl__CustomLookupFilter2__c,
            dmpl__ShowNewAccountAction__c,
            dmpl__HideDefaultShippingAddress2__c,
            dmpl__HideDefaultBillingAddress__c
        FROM dmpl__ScreenActionSetting__mdt
        WHERE 
            dmpl__ObjectNameId__r.QualifiedApiName =:safeRecordApiName
            AND (dmpl__RecordTypeName__c =: recordTypeName OR dmpl__RecordTypeName__c = null)
        ORDER BY dmpl__RecordTypeName__c DESC NULLS LAST LIMIT 1];
    }
}