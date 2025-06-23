public with sharing class DocumentActionSettingHelper {
    
    public static String getSOQLQuery(
        dmpl__DocumentActionSetting__mdt recordSetting,
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
        query += ' FROM ' + recordSetting.dmpl__ChildObjectId__r.QualifiedApiName;
        query += ' WHERE ' + recordSetting.dmpl__EligibilityQuantityFieldId__r.QualifiedApiName + ' > 0 ';
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

    public static List<dmpl__DocumentActionSetting__mdt> getDocumentActionSettings(
        string objectApiName){
        return [SELECT
            dmpl__HostObjectId__r.QualifiedApiName,
            dmpl__HostObjectId__r.Label,
            dmpl__Title__c,
            dmpl__SubTitle__c,
            dmpl__IsActive__c,
            dmpl__Sort__c,
            dmpl__EligibilityQuantityFieldId__c,
            dmpl__EligibilityQuantityFieldId__r.QualifiedApiName,
            dmpl__ChildObjectId__c,
            dmpl__ChildObjectId__r.QualifiedApiName,
            dmpl__ChildFieldsetName__c,
            dmpl__RestrictAllRecordsRelease__c,
            dmpl__EditableFieldNames__c,
            dmpl__ActionType__c,
            dmpl__Tag__c,
            dmpl__SkipConfirmationPage__c,
            dmpl__HideActionFieldName__c
    FROM 
        dmpl__DocumentActionSetting__mdt
    WHERE 
        dmpl__HostObjectId__r.QualifiedApiName =:objectApiName
    ORDER BY
        dmpl__Sort__c ASC];
    }

    public static dmpl__DocumentActionSetting__mdt getDocumentActionSetting(Id recordId){
        return [SELECT
        DeveloperName,
        dmpl__HostObjectId__r.QualifiedApiName,
        dmpl__HostObjectId__r.Label,
        dmpl__Title__c,
        dmpl__SubTitle__c,
        dmpl__IsActive__c,
        dmpl__Sort__c,
        dmpl__EligibilityQuantityFieldId__c,
        dmpl__EligibilityQuantityFieldId__r.QualifiedApiName,
        dmpl__ChildObjectId__c,
        dmpl__ChildObjectId__r.QualifiedApiName,
        dmpl__ChildFieldsetName__c,
        dmpl__ChildObjectSOQLFilter__c,
        dmpl__FilterSourceSOQL__c,
        dmpl__EditableFieldNames__c,
        dmpl__ActionType__c,
        dmpl__Tag__c,
        dmpl__SkipConfirmationPage__c,
        dmpl__HideActionFieldName__c
    FROM 
        dmpl__DocumentActionSetting__mdt
    WHERE 
        Id =:recordId
    ORDER BY
        dmpl__Sort__c ASC];
    }
}