public with sharing class RecordPanelController {
    @AuraEnabled(cacheable = true)
    public static List<FieldsetFieldInfo> getFieldsByFieldSetName(String objectApiName, String fieldSetName)
    {
        try {
            String fsName = fieldSetName.toLowerCase();
            List<FieldsetFieldInfo> fsFields = new List<FieldsetFieldInfo>();
            System.Type objectType = Type.forName(objectApiName);
            if(objectType==null){
                return fsFields;
            }
            Map<String, Schema.FieldSet> fsMap = ((SObject)objectType.newInstance()).getSObjectType().getDescribe().FieldSets.getMap();
            if(fsMap == null || !fsMap.containsKey(fsName)){
                return fsFields;
            }
            for(Schema.FieldSetMember memberField: fsMap.get(fsName).getFields()){
                FieldsetFieldInfo fsField = new FieldsetFieldInfo(memberField);
                fsFields.add(fsField);
            }
            return fsFields;
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }
}