public with sharing class CreateRelatedSettingHelper {

    public static String getSOQLQuery(
        dmpl__CreateRelatedSetting__mdt recordSetting,
        String searchKey,
        Id recordId){
        List<FieldsetFieldInfo> fields = MetadataHelper.getFieldsByFieldSetName(
            recordSetting.dmpl__ChildObjectId__r.QualifiedApiName,
            recordSetting.dmpl__ChildFieldsetName__c);
        String query = 'SELECT Id';
        String searchQuery = '';
        for(FieldsetFieldInfo info : fields){
            query += ', ' + info.apiName;
            if(info.type == 'STRING' && !String.isBlank(searchKey)){
                if(!String.isBlank(searchQuery)){
                    searchQuery += ' OR ';
                }
                searchQuery += info.apiName + ' LIKE \'%' + searchKey + '%\'';
            }
        } 
        if(recordSetting.dmpl__ShowUOMQty__c){
            query += ', dmpl__ConversionRatio__c';
        }
        if(recordSetting.dmpl__ShowUOMQty1__c){
            query += ', dmpl__ConversionRatio1__c';
        }
        query += ' FROM ' + recordSetting.dmpl__ChildObjectId__r.QualifiedApiName;
        query += ' WHERE ' + recordSetting.dmpl__EligibilityQuantityFieldId__r.QualifiedApiName + ' >= 0 ';
        if(!String.isBlank(recordSetting.dmpl__ChildObjectSOQLFilter__c)){
            query += ' AND (' + recordSetting.dmpl__ChildObjectSOQLFilter__c + ')';
        }
        if(!string.isBlank(searchKey)){
            query += ' AND (' + searchQuery + ')';
        }
        if(!string.isBlank(recordSetting.dmpl__FilterSourceSOQL__c)){
            SObject dynamicObject = Database.query(recordSetting.dmpl__FilterSourceSOQL__c);
            query = DynamicTextParser.populateFields(query, dynamicObject);
        }
        query += ' Limit 2000';

        System.debug(query);
        return query;
    }

    public static List<dmpl__CreateRelatedSetting__mdt> getCreateRelatedSettings(string objectApiName){
        return [SELECT
        dmpl__ActionType__c,
        dmpl__HostObjectId__r.QualifiedApiName,
        dmpl__HostObjectId__r.Label,
        dmpl__RelatedObjectId__r.QualifiedApiName,
        dmpl__RelatedObjectId__r.Label,
        dmpl__Title__c,
        dmpl__SubTitle__c,
        dmpl__Heading__c,
        dmpl__SubHeading__c,
        dmpl__IsActive__c,
        dmpl__Sort__c,
        dmpl__EligibilityQuantityFieldId__c,
        dmpl__EligibilityQuantityFieldId__r.QualifiedApiName,
        dmpl__ChildObjectId__c,
        dmpl__ChildObjectId__r.QualifiedApiName,
        dmpl__ChildFieldsetName__c,
        dmpl__RestrictAllRecordsRelease__c,
        dmpl__CustomClassName__c,
        dmpl__Tag__c,
        dmpl__SkipConfirmationPage__c,
        dmpl__HideActionFieldName__c,
        dmpl__AsyncRecordCount__c,
        dmpl__ShowUOMQty__c,
        dmpl__ShowUOMQty1__c,
        dmpl__UOMLabel__c,
        dmpl__UOMLabel1__c
    FROM 
        dmpl__CreateRelatedSetting__mdt
    WHERE 
        dmpl__HostObjectId__r.QualifiedApiName =:objectApiName
    ORDER BY
        dmpl__Sort__c ASC];
    }

    public static dmpl__CreateRelatedSetting__mdt getCreateRelatedSettingsWithTag(
        string objectApiName,
        string actionType,
        string relatedObjectApiName,
        string tag){
            List<dmpl__CreateRelatedSetting__mdt> settings = [SELECT
            dmpl__ActionType__c,
            dmpl__HostObjectId__r.QualifiedApiName,
            dmpl__HostObjectId__r.Label,
            dmpl__RelatedObjectId__r.QualifiedApiName,
            dmpl__RelatedObjectId__r.Label,
            dmpl__Title__c,
            dmpl__SubTitle__c,
            dmpl__Heading__c,
            dmpl__SubHeading__c,
            dmpl__IsActive__c,
            dmpl__Sort__c,
            dmpl__EligibilityQuantityFieldId__c,
            dmpl__EligibilityQuantityFieldId__r.QualifiedApiName,
            dmpl__ChildObjectId__c,
            dmpl__ChildObjectId__r.QualifiedApiName,
            dmpl__ChildFieldsetName__c,
            dmpl__RestrictAllRecordsRelease__c,
            dmpl__CustomClassName__c,
            dmpl__Tag__c,
            dmpl__SkipConfirmationPage__c,
            dmpl__HideActionFieldName__c,
            dmpl__AsyncRecordCount__c,
            dmpl__ShowUOMQty__c,
            dmpl__ShowUOMQty1__c,
            dmpl__UOMLabel__c,
            dmpl__UOMLabel1__c
        FROM 
            dmpl__CreateRelatedSetting__mdt
        WHERE 
            dmpl__HostObjectId__r.QualifiedApiName =:objectApiName
            AND dmpl__ActionType__c = :actionType
            AND dmpl__IsActive__c = true
            AND dmpl__Tag__c = :tag
        ORDER BY
            dmpl__Sort__c ASC
        LIMIT 1];
        if(settings.size()>0){
            return settings[0];
        }
        return null;
    }

    public static dmpl__CreateRelatedSetting__mdt getCreateRelatedSettings(
        string objectApiName,
        string actionType,
        string relatedObjectApiName){
            List<dmpl__CreateRelatedSetting__mdt> settings = [SELECT
            dmpl__ActionType__c,
            dmpl__HostObjectId__r.QualifiedApiName,
            dmpl__HostObjectId__r.Label,
            dmpl__RelatedObjectId__r.QualifiedApiName,
            dmpl__RelatedObjectId__r.Label,
            dmpl__Title__c,
            dmpl__SubTitle__c,
            dmpl__Heading__c,
            dmpl__SubHeading__c,
            dmpl__IsActive__c,
            dmpl__Sort__c,
            dmpl__EligibilityQuantityFieldId__c,
            dmpl__EligibilityQuantityFieldId__r.QualifiedApiName,
            dmpl__ChildObjectId__c,
            dmpl__ChildObjectId__r.QualifiedApiName,
            dmpl__ChildFieldsetName__c,
            dmpl__RestrictAllRecordsRelease__c,
            dmpl__CustomClassName__c,
            dmpl__Tag__c,
            dmpl__SkipConfirmationPage__c,
            dmpl__HideActionFieldName__c,
            dmpl__AsyncRecordCount__c,
            dmpl__ShowUOMQty__c,
            dmpl__ShowUOMQty1__c,
            dmpl__UOMLabel__c,
            dmpl__UOMLabel1__c
        FROM 
            dmpl__CreateRelatedSetting__mdt
        WHERE 
            dmpl__HostObjectId__r.QualifiedApiName =:objectApiName
            AND dmpl__ActionType__c = :actionType
            AND dmpl__IsActive__c = true
            AND dmpl__RelatedObjectId__r.QualifiedApiName = :relatedObjectApiName
            AND dmpl__Tag__c = null
        ORDER BY
            dmpl__Sort__c ASC
        LIMIT 1];
        if(settings.size()>0){
            return settings[0];
        }
        return null;
    }

    public static dmpl__CreateRelatedSetting__mdt getCreateRelatedSettings(
        string objectApiName,
        string actionType){
            List<dmpl__CreateRelatedSetting__mdt> settings = [SELECT
            dmpl__ActionType__c,
            dmpl__HostObjectId__r.QualifiedApiName,
            dmpl__HostObjectId__r.Label,
            dmpl__RelatedObjectId__r.QualifiedApiName,
            dmpl__RelatedObjectId__r.Label,
            dmpl__Title__c,
            dmpl__SubTitle__c,
            dmpl__Heading__c,
            dmpl__SubHeading__c,
            dmpl__IsActive__c,
            dmpl__Sort__c,
            dmpl__EligibilityQuantityFieldId__c,
            dmpl__EligibilityQuantityFieldId__r.QualifiedApiName,
            dmpl__ChildObjectId__c,
            dmpl__ChildObjectId__r.QualifiedApiName,
            dmpl__ChildFieldsetName__c,
            dmpl__RestrictAllRecordsRelease__c,
            dmpl__CustomClassName__c,
            dmpl__Tag__c,
            dmpl__SkipConfirmationPage__c,
            dmpl__HideActionFieldName__c,
            dmpl__AsyncRecordCount__c,
            dmpl__ShowUOMQty__c,
            dmpl__ShowUOMQty1__c,
            dmpl__UOMLabel__c,
            dmpl__UOMLabel1__c
        FROM 
            dmpl__CreateRelatedSetting__mdt
        WHERE 
            dmpl__HostObjectId__r.QualifiedApiName =:objectApiName
            AND dmpl__ActionType__c = :actionType
            AND dmpl__IsActive__c = true
            AND dmpl__Tag__c = null
        ORDER BY
            dmpl__Sort__c ASC
        LIMIT 1];
        if(settings.size()>0){
            return settings[0];
        }
        return null;
    }

    public static dmpl__CreateRelatedSetting__mdt getCreateRelatedSetting(Id recordId){
        return [SELECT
        DeveloperName,
        dmpl__ActionType__c,
        dmpl__HostObjectId__r.QualifiedApiName,
        dmpl__HostObjectId__r.Label,
        dmpl__RelatedObjectId__r.QualifiedApiName,
        dmpl__RelatedObjectId__r.Label,
        dmpl__Title__c,
        dmpl__SubTitle__c,
        dmpl__Heading__c,
        dmpl__SubHeading__c,
        dmpl__IsActive__c,
        dmpl__Sort__c,
        dmpl__EligibilityQuantityFieldId__c,
        dmpl__EligibilityQuantityFieldId__r.QualifiedApiName,
        dmpl__ChildObjectId__c,
        dmpl__ChildObjectId__r.QualifiedApiName,
        dmpl__ChildFieldsetName__c,
        dmpl__ChildObjectSOQLFilter__c,
        dmpl__FilterSourceSOQL__c,
        dmpl__CustomClassName__c,
        dmpl__Tag__c,
        dmpl__SkipConfirmationPage__c,
        dmpl__HideActionFieldName__c,
        dmpl__AsyncRecordCount__c,
        dmpl__ShowUOMQty__c,
        dmpl__ShowUOMQty1__c,
        dmpl__UOMLabel__c,
        dmpl__UOMLabel1__c
    FROM 
        dmpl__CreateRelatedSetting__mdt
    WHERE 
        Id =:recordId
    ORDER BY
        dmpl__Sort__c ASC];
    }
}