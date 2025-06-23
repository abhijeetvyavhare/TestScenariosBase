public with sharing class MetadataController {
    
    @AuraEnabled(cacheable = true)
    public static List<FieldsetInfo> getFieldSetList(
        String objectApiName){
            return MetadataHelper.getFieldSetList(objectApiName);
    }

    @AuraEnabled(cacheable = true)
    public static List<FieldsetFieldInfo> getFieldsByFieldSetName(
        String objectApiName, 
        String fieldSetName){
            return MetadataHelper.getFieldsByFieldSetName(objectApiName, fieldSetName);
    }
}