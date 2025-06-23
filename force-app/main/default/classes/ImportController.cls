public with sharing class ImportController {
    @AuraEnabled
    public static List<ImportResult> importFieldsetData(
        String objectApiName, 
        Id recordId, 
        String parentFieldName,
        String fieldsetName, 
        String jsonString){
            return importHelper.importFieldsetData(
                objectApiName,
                recordId,
                parentFieldName,
                fieldsetName,
                jsonString
            );
   }

    @testVisible
    @AuraEnabled(cacheable=true)
    public static List<dmpl__DMSSetting__mdt> getDMSImportSettings(
        String objectApiName){
            return new DMSSettings().getDMSSettingsOfType(
                new List<String>{
                    'Import Panel Relation Name',
                    'Import Panel Fieldset Name'},
                objectApiName);
   }
}