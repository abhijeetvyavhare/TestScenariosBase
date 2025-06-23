@namespaceAccessible
public with sharing class MetadataHelper {

    @namespaceAccessible
    public static List<FieldsetInfo> getFieldSetList(String objectApiName){
        List<FieldsetInfo> fsLsit = new List<FieldsetInfo>();
        if(String.isBlank(objectApiName)){
            return fsLsit;
        }
        System.Type objectType = Type.forName(objectApiName);
        if(objectType!=null){
            List<Schema.FieldSet> fsSource = ((SObject)objectType.newInstance())
                .getSObjectType().getDescribe().FieldSets.getMap().values();
            for(Schema.FieldSet fs : fsSource){
                fsLsit.add(
                    new FieldsetInfo(
                        fs.name, 
                        fs.label, 
                        fs.namespace));
            }
        }
        return fsLsit;
    }
    
    @namespaceAccessible
    public static List<FieldsetFieldInfo> getFieldsByFieldSetName(
        String objectApiName, 
        String fieldSetName){
        List<FieldsetFieldInfo> fsFields = new List<FieldsetFieldInfo>();
        if(String.isBlank(objectApiName) || String.isBlank(fieldSetName)){
            return fsFields;
        }
        String fsName = fieldSetName.toLowerCase();
        String fsNameQualified = fsName.startsWith('dmpl__') ? 
            fsName : 
            'dmpl__' + fsName;
        System.Type objectType = Type.forName(objectApiName);
        if(objectType==null){
            return fsFields;
        }
        Map<String, Schema.FieldSet> fsMap = ((SObject)objectType.newInstance()).getSObjectType().getDescribe().FieldSets.getMap();
        if(fsMap == null){
            return fsFields;
        }
        if(fsMap.containsKey(fsName)){
            for(Schema.FieldSetMember memberField: fsMap.get(fsName).getFields()){
                FieldsetFieldInfo fsField = new FieldsetFieldInfo(memberField);
                fsFields.add(fsField);
            }
            return fsFields;
        } else if(fsMap.containsKey(fsNameQualified)){
            for(Schema.FieldSetMember memberField: fsMap.get(fsNameQualified).getFields()){
                FieldsetFieldInfo fsField = new FieldsetFieldInfo(memberField);
                fsFields.add(fsField);
            }
            return fsFields;
        }else{
            for(Schema.FieldSet fs : fsMap.values()){
                if(fs.name == fsName){
                    for(Schema.FieldSetMember memberField: fs.getFields()){
                        FieldsetFieldInfo fsField = new FieldsetFieldInfo(memberField);
                        fsFields.add(fsField);
                    }
                    return fsFields;        
                }
            }
        }
        return fsFields;
    }

    public static Map<String, Schema.SObjectField> getFieldMap(
        Schema.SObjectType sObjectType){
        Schema.DescribeSObjectResult objectInfo = sObjectType.getDescribe();
        Map<String, Schema.SObjectField> fieldMap = null;
        //  (Map<String, Schema.SObjectField>)OrgCacheHelper.getObject(
        //     String.join(
        //         new String[]{
        //             objectInfo.getName().remove('_'), 
        //             'mdfm'
        //         },''));
        // if(fieldMap!=null){
        //     return fieldMap;
        // }
        fieldMap = objectInfo.fields.getMap();
        // OrgCacheHelper.setObject(
        //     String.join(
        //         new String[]{
        //             objectInfo.getName().remove('_'), 
        //             'mdfm'
        //         },''), 
        //     fieldMap);
        return fieldMap;
    }

    public static Schema.SObjectField getField(
        Schema.SObjectType sObjectType, 
        String fielName){
        Map<String, Schema.SObjectField> fieldMap = getFieldMap(sObjectType);
        if(fieldMap !=null && fieldMap.containsKey(fielName)){
            return fieldMap.get(fielName);
        }
        return null;
    }
}