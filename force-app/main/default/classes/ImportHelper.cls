public with sharing class ImportHelper {
    public static List<ImportResult> importFieldsetData(
        String objectApiName, 
        Id recordId, 
        String parentFieldName,
        String fieldsetName, 
        String jsonString){
            List<ImportResult> insertResults = new List<ImportResult>();
            try
            {
                if(jsonString == null){
                    return insertResults;
                }
                List<FieldsetFieldInfo> fieldsetFields = MetadataHelper.getFieldsByFieldSetName(
                    objectApiName, 
                    fieldsetName);
                List<Object> parsedData = (List<Object>)JSON.deserializeUntyped(
                    jsonString);
                List<SObject> insertedObjects = (List<SObject>)Type.forName(
                    'List<' + objectApiName + '>').newInstance();
                Map<String, Map<String,SObject>> lookupSources = getLookupSources(
                    fieldsetFields,
                    parsedData);
                Type sObjectType = Type.forName(objectApiName);
                if(sObjectType == null){
                    throw new DMPLException(
                        'Object Not Found :' + objectApiName);
                }
                Map<String, Schema.SObjectField> fields = ((SObject)sObjectType.newInstance()).getSObjectType().getDescribe().fields.getMap();
                for(Object entry: parsedData){   
                    ImportResult resultRow = new ImportResult();
                    SObject newObject = (SObject)sObjectType.newInstance();
                    Map<String,Object> sourceMap = (Map<String,Object>) entry;
                    if(String.isNotEmpty(parentFieldName)){
                        newObject.put(
                            parentFieldName,
                            recordId);
                    }
                    for(FieldsetFieldInfo field : fieldsetFields){
                        if(field.apiName.contains('.')){
                            List<String> nvPair = field.apiName.split('\\.');
                            if(nvPair.size()==2){
                                if(lookupSources.containsKey(field.apiName)
                                    && lookupSources.get(field.apiName).containsKey(
                                        (String)sourceMap.get(field.apiName))){
                                            try {
                                                newObject.put(
                                                    nvPair[0].contains('__r') ? 
                                                        nvPair[0].replace('__r', '__c') :
                                                        nvPair[0] + 'Id',
                                                    lookupSources.get(field.apiName).get(
                                                        (String)sourceMap.get(field.apiName)).Id);    
                                            } catch (Exception ex) {
                                                resultRow.addError(ex.getMessage());
                                            }
                                    }else{
                                        resultRow.addError('Field : ' + field.label + ' ('+ field.apiName + ') Value Not Found: ' + (String)sourceMap.get(field.apiName));
                                    }
                            }
                        }else{
                            try {
                                System.debug('SEtting ' + field.apiName + ' : ' + parseField(
                                    sourceMap.get(field.apiName), 
                                    fields.get(field.apiName)));
                                newObject.put(
                                    field.apiName, 
                                    parseField(
                                        sourceMap.get(field.apiName), 
                                        fields.get(field.apiName)));                                                                        
                            } catch (Exception ex) {
                                System.debug('error' + ex.getMessage());
                                resultRow.addError(ex.getMessage());
                            }
                        }
                    }
                    insertedObjects.add(newObject);
                    insertResults.add(resultRow);
                }
                
                if(insertedObjects.size() > 0 ){
                    Database.UpsertResult[] results = Database.Upsert(
                        insertedObjects, 
                        false);
                    for(Integer i = 0; i < insertedObjects.size(); i ++){
                        SObject insertedEntry = insertedObjects.get(i);
                        Database.UpsertResult result = results[i];
                        ImportResult resultRow = insertResults[i];
                        resultRow.objectApiName = objectApiName;
                        resultRow.isSuccess = result.isSuccess();
                        if(result.getErrors().size()>0){
                            resultRow.setErrors(result.getErrors());
                        }
                        if(result.isSuccess()){
                            resultRow.objectId = insertedEntry.Id;
                            if (objectApiName == 'Case') {
                                resultRow.name = (String)insertedEntry.get('CaseNumber');
                            } else {
                                resultRow.name = (String)insertedEntry.get('Name');
                            }
                        }
                    }
                }
            } catch(Exception e){
                throw new AuraHandledException(e.getMessage());
            }
            return insertResults;
   }

   private static Map<String, Map<String,SObject>> getLookupSources(
        List<FieldsetFieldInfo> fieldsetFields,
        List<Object> parsedData){
            Map<String, Map<String,SObject>> lookupSources = new Map<String, Map<String,SObject>>();
            for(FieldsetFieldInfo field : fieldsetFields){
                if(field.apiName.contains('.')){
                    lookupSources.put(
                        field.apiName, 
                        getLookupSource(
                            field,
                            parsedData
                        ));
                }
            }
            return lookupSources;
    }

    @testVisible
    private static Map<String, SObject> getLookupSource(
        FieldsetFieldInfo field,
        List<Object> parsedData){
            List<String> lookupSource = new List<String>();
            for(Object entry: parsedData){   
                String fieldValue = (String)((Map<String,Object>) entry).get(field.apiName);
                if(!lookupSource.contains(fieldValue)){
                    lookupSource.add(fieldValue);
                }
            }
            List<String> nvPair = field.apiName.split('\\.');
            if(nvPair.size()==2){
                String objectTypeName = getTargetObjectTypeName(nvPair[0]);
                System.debug('objectTypeName ' + objectTypeName);
                if(String.isNotBlank(objectTypeName)){
                    String query = 'SELECT Id, ' 
                        + nvPair[1] 
                        + ' FROM ' 
                        + objectTypeName 
                        + ' WHERE '
                        + nvPair[1] + ' IN :lookupSource'
                        + ' LIMIT 1000';
                    System.debug('Query1 : ' + query);
                    List<SObject> result = Database.query(query); 
                    return CollectionHelper.stringMapFromCollectionByKey(
                        nvPair[1],
                        result
                    );
                }
            }
            return new Map<String, SObject>();
    }

    @testvisible
    private static object parseField(
        object fieldValue, 
        Schema.SObjectField soField){
        if(soField == null){
            return fieldValue;
        }else{
            Schema.SoapType fieldType = soField.getDescribe().getSoapType();
            switch on fieldType {
                when  DATE {
                    return Date.valueOf((String)fieldValue);
                }
                when  DATETIME {
                    return Datetime.valueOf((String)fieldValue);
                }
                when String {
                    return String.valueOf(fieldValue);
                }
                when Integer {
                    return Integer.valueOf(fieldValue);
                }
                when Double {
                    return Double.valueOf(fieldValue);
                }
                when Boolean {
                    return Boolean.valueOf(fieldValue);
                }
                when else {
                    return fieldValue;
                }
            }
        }
    }

    @testvisible
    private static String getTargetObjectTypeName(
        String fieldName){
        Type sObjectType = null;
        fieldName = fieldName.replace('Id__r', '__c');
        sObjectType = Type.forName(fieldName);
        if(sObjectType != null){
            return fieldName;
        }

        fieldName = fieldName.replace('Substitute', '');
        sObjectType = Type.forName(fieldName);
        if(sObjectType != null){
            return fieldName;
        }

        fieldName = fieldName.replace('Discounted', '');
        sObjectType = Type.forName(fieldName);
        if(sObjectType != null){
            return fieldName;
        }

        fieldName = fieldName.replace('Alternate', '');
        sObjectType = Type.forName(fieldName);
        if(sObjectType != null){
            return fieldName;
        }

        fieldName = fieldName.replace('SalesExecutive', 'Resource');
        sObjectType = Type.forName(fieldName);
        if(sObjectType != null){
            return fieldName;
        }

        fieldName = fieldName.replace('ServiceAdvisor', 'Resource');
        sObjectType = Type.forName(fieldName);
        if(sObjectType != null){
            return fieldName;
        }

        fieldName = fieldName.replace('PartnerAccountGroup', 'AccountGroup');
        sObjectType = Type.forName(fieldName);
        if(sObjectType != null){
            return fieldName;
        }
        
        fieldName = fieldName.remove('dmpl__').remove('__c');
        sObjectType = Type.forName(fieldName);
        if(sObjectType != null){
            return fieldName;
        }

        fieldName = fieldName.replace('Partner', '');
        sObjectType = Type.forName(fieldName);
        if(sObjectType != null){
            return fieldName;
        }

        fieldName = fieldName.replace('Supplier', '');
        sObjectType = Type.forName(fieldName);
        if(sObjectType != null){
            return fieldName;
        }

        return '';
    }
}