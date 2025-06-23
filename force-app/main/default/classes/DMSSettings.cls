global with sharing class DMSSettings {
    
    global static dmpl__DMSSetting__mdt getDMSSettingIfExists(string settingType, string objectApiName){
        List<dmpl__DMSSetting__mdt> settings = (new DMSSettings()).getDMSSettingsOfType(settingType, objectApiName);
        if(settings.size() > 0){
            return settings[0];
        }
        return null;
    }

    global List<dmpl__DMSSetting__mdt> getDMSSettingsOfType(string settingType, string objectApiName){
        return [SELECT
            dmpl__BooleanValue__c,
            dmpl__DateTimeValue__c,
            dmpl__DateValue__c,
            dmpl__EmailValue__c,
            dmpl__NumericValue__c,
            dmpl__PercentValue__c,
            dmpl__PhoneValue__c,
            dmpl__SettingType__c,
            dmpl__TextAreaValue__c,
            dmpl__TextValue__c,
            dmpl__UrlValue__c,
            dmpl__ObjectApiNameId__r.QualifiedApiName
        FROM dmpl__DMSSetting__mdt
        WHERE dmpl__SettingType__c =:settingType
            AND dmpl__ObjectApiNameId__r.QualifiedApiName =:objectApiName
        WITH SECURITY_ENFORCED];
    }

    global List<dmpl__DMSSetting__mdt> getDMSSettingsOfType(List<string> settingTypes, string objectApiName){
        return [SELECT
            dmpl__BooleanValue__c,
            dmpl__DateTimeValue__c,
            dmpl__DateValue__c,
            dmpl__EmailValue__c,
            dmpl__NumericValue__c,
            dmpl__PercentValue__c,
            dmpl__PhoneValue__c,
            dmpl__SettingType__c,
            dmpl__TextAreaValue__c,
            dmpl__TextValue__c,
            dmpl__UrlValue__c,
            dmpl__ObjectApiNameId__r.QualifiedApiName
        FROM dmpl__DMSSetting__mdt
        WHERE dmpl__SettingType__c IN :settingTypes
            AND dmpl__ObjectApiNameId__r.QualifiedApiName =:objectApiName
        WITH SECURITY_ENFORCED];
    }
     
    global List<dmpl__DMSSetting__mdt> getDMSSettings(string settingName, string objectApiName){
        return [SELECT
            dmpl__BooleanValue__c,
            dmpl__DateTimeValue__c,
            dmpl__DateValue__c,
            dmpl__EmailValue__c,
            dmpl__NumericValue__c,
            dmpl__PercentValue__c,
            dmpl__PhoneValue__c,
            dmpl__SettingType__c,
            dmpl__TextAreaValue__c,
            dmpl__TextValue__c,
            dmpl__UrlValue__c,
            dmpl__ObjectApiNameId__r.QualifiedApiName
        FROM dmpl__DMSSetting__mdt
        WHERE DeveloperName =:settingName
            AND dmpl__ObjectApiNameId__r.QualifiedApiName =:objectApiName
        WITH SECURITY_ENFORCED];
    }

    global List<dmpl__DMSSetting__mdt> getDMSSettings(string settingName){
        return [SELECT
            dmpl__BooleanValue__c,
            dmpl__DateTimeValue__c,
            dmpl__DateValue__c,
            dmpl__EmailValue__c,
            dmpl__NumericValue__c,
            dmpl__PercentValue__c,
            dmpl__PhoneValue__c,
            dmpl__SettingType__c,
            dmpl__TextAreaValue__c,
            dmpl__TextValue__c,
            dmpl__UrlValue__c,
            dmpl__ObjectApiNameId__r.QualifiedApiName
        FROM dmpl__DMSSetting__mdt
        WHERE DeveloperName =:settingName
        WITH SECURITY_ENFORCED];
    }

    global dmpl__DMSSetting__mdt getDMSSetting(string settingName, string objectApiName){
        return [SELECT
            dmpl__BooleanValue__c,
            dmpl__DateTimeValue__c,
            dmpl__DateValue__c,
            dmpl__EmailValue__c,
            dmpl__NumericValue__c,
            dmpl__PercentValue__c,
            dmpl__PhoneValue__c,
            dmpl__SettingType__c,
            dmpl__TextAreaValue__c,
            dmpl__TextValue__c,
            dmpl__UrlValue__c,
            dmpl__ObjectApiNameId__r.QualifiedApiName
        FROM dmpl__DMSSetting__mdt
        WHERE DeveloperName =:settingName
            AND dmpl__ObjectApiNameId__r.QualifiedApiName =:objectApiName
        WITH SECURITY_ENFORCED
        LIMIT 1];
    }
    
    global dmpl__DMSSetting__mdt getDMSSetting(string settingName){
        return [SELECT
            dmpl__BooleanValue__c,
            dmpl__DateTimeValue__c,
            dmpl__DateValue__c,
            dmpl__EmailValue__c,
            dmpl__NumericValue__c,
            dmpl__PercentValue__c,
            dmpl__PhoneValue__c,
            dmpl__SettingType__c,
            dmpl__TextAreaValue__c,
            dmpl__TextValue__c,
            dmpl__UrlValue__c,
            dmpl__ObjectApiNameId__r.QualifiedApiName
        FROM dmpl__DMSSetting__mdt
        WHERE DeveloperName =:settingName
        WITH SECURITY_ENFORCED
        LIMIT 1];
    }
}