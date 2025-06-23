public with sharing class DocumentNameSettingDataHelper {
    public static dmpl__DocumentNameSetting__c createDocumentNameSetting(){
        return (dmpl__DocumentNameSetting__c) TestFactory.createSObject(
            new dmpl__DocumentNameSetting__c(),
            'DocumentNameSettingDefaults',
            true
        );
    }

    public static dmpl__DocumentNameSetting__c getDocumentNameSetting(){
        List<dmpl__DocumentNameSetting__c> results =  [
            SELECT Id, Name, dmpl__ObjectApiName__c, dmpl__LastNumberUsed__c, dmpl__DocumentSeries__c
            FROM dmpl__DocumentNameSetting__c
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }
}