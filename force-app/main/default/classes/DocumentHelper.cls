@namespaceAccessible
public with sharing class DocumentHelper 
{
    private static final String FIELDNAME_ID = 'Id';

    @namespaceAccessible
    public static void validateIsPostiveNumberic(
        String fieldName, 
        List<SObject> oldEntries, 
        List<SObject> newEntries){
            ValidationHelper.validatePostiveNumber(
                fieldName, 
                newEntries);
    }

    @namespaceAccessible
    public static void validateChangeInKeyFields(
        List<String> keyFields, 
        List<SObject> oldEntries, 
        List<SObject> newEntries){
        if(newEntries == null || oldEntries==null){
            return;
        }
        Map<Id, SObject> oldObjectsMap = new Map<Id, SObject>(oldEntries);
        for(SObject lineEntry : newEntries){
            SObject oldEntry = oldObjectsMap.get(lineEntry.Id);
            if(oldEntry != null){
                String rowError = '';
                for(String fieldName: keyFields){
                    if(oldEntry.get(fieldName) != lineEntry.get(fieldName)) {                    
                        rowError += String.format(
                            String.valueOf(System.Label.IntegrityFailed_KeyFieldNotEditable), 
                            new String[]{fieldName}); 
                    } 
                }
                if(String.isNotBlank(rowError)){
                    lineEntry.addError(rowError);
                }
            }
        }
    }

    @namespaceAccessible
    public static void validateChangeInKeyFields(
        List<String> keyFields, 
        List<SObject> oldEntries, 
        List<SObject> newEntries, 
        List<Id> transactedIds){
        if(newEntries == null || oldEntries==null){
            return;
        }
        Map<Id, SObject> oldObjectsMap = new Map<Id, SObject>(oldEntries);
        for(SObject lineEntry : newEntries){
            SObject oldEntry = oldObjectsMap.get(lineEntry.Id);
            if(oldEntry != null && transactedIds.contains(lineEntry.Id)){
                String rowError = '';
                for(String fieldName: keyFields){
                    if(oldEntry.get(fieldName) != lineEntry.get(fieldName)) {                    
                        rowError += String.format(
                        String.valueOf(System.Label.IntegrityFailed_KeyFieldNotEditable), 
                        new String[]{fieldName}); 
                    } 
                }
                if(String.isNotBlank(rowError)){
                    lineEntry.addError(rowError);
                }
            }
        }
    }

    @namespaceAccessible
    public static void validateChangeInSystemFields(
        List<String> systemFields, 
        List<SObject> oldEntries, 
        List<SObject> newEntries){
        if(newEntries == null || oldEntries==null){
            return;
        }
        Map<Id, SObject> oldObjectsMap = new Map<Id, SObject>(oldEntries);
        for(SObject lineEntry : newEntries){
            SObject oldEntry = oldObjectsMap.get(lineEntry.Id);
            if(oldEntry != null){
                String rowError = '';
                for(String fieldName: systemFields){
                    if(oldEntry.get(fieldName) != lineEntry.get(fieldName)) {                    
                        rowError += String.format(
                            String.valueOf(System.Label.IntegrityFailed_SystemFieldNotEditable), 
                            new String[]{fieldName}); 
                    } 
                }
                if(String.isNotBlank(rowError)){
                    lineEntry.addError(rowError);
                }
            }   
        }
    }

    @namespaceAccessible
    public static void validateChangeInSystemFields(
        List<String> systemFields, 
        List<SObject> newEntries){
        if(newEntries == null){
            return;
        }
        for(SObject lineEntry : newEntries){
            String rowError = '';
            for(String fieldName: systemFields){
                if(lineEntry.get(fieldName) !=null) {
                    if(lineEntry.get(fieldName) instanceof Boolean && ((Boolean)lineEntry.get(fieldName) == false)){
                        continue;
                    }else{
                        rowError += String.format(
                            String.valueOf(System.Label.IntegrityFailed_SystemFieldNotEditable), 
                            new String[]{fieldName});     
                    }          
                } 
            }
            if(String.isNotBlank(rowError)){
                lineEntry.addError(rowError);
            }
        }
    }

    @namespaceAccessible
    public static void validateChangeInSourcePopulatedFields(
        List<String> fields, 
        List<SObject> oldEntries, 
        List<SObject> newEntries, 
        string sourceFieldName){
        if(newEntries == null || oldEntries==null){
            return;
        }
        Map<Id, SObject> oldObjectsMap = new Map<Id, SObject>(oldEntries);
        for(SObject lineEntry : newEntries){
            SObject oldEntry = oldObjectsMap.get(lineEntry.Id);
            if(oldEntry != null){
                String rowError = '';
                for(String fieldName: fields){
                    if(oldEntry.get(sourceFieldName) != null &&
                        oldEntry.get(fieldName) != lineEntry.get(fieldName)) {
                        rowError += String.format(
                            String.valueOf(System.Label.IntegrityFailed_SourcePopulatedFieldNotEditable), 
                            new String[]{fieldName}); 
                    } 
                }
                if(String.isNotBlank(rowError)){
                    lineEntry.addError(rowError);
                }
            }   
        }
    }

    @namespaceAccessible
    public static void validateChangeInSourcePopulatedFields(
        List<String> fields, 
        List<SObject> oldEntries, 
        List<SObject> newEntries, 
        List<Id> sourcePopulatedIds, 
        String sourceFieldName){
        if(newEntries == null || oldEntries==null){
            return;
        }
        Map<Id, SObject> oldObjectsMap = new Map<Id, SObject>(oldEntries);
        for(SObject lineEntry : newEntries){
            SObject oldEntry = oldObjectsMap.get(lineEntry.Id);
            if(oldEntry != null && sourcePopulatedIds.contains((Id)oldEntry.get(sourceFieldName))){
                String rowError = '';
                for(String fieldName: fields){
                    if(oldEntry.get(fieldName) != lineEntry.get(fieldName)) {
                        rowError += String.format(
                            String.valueOf(System.Label.IntegrityFailed_SourcePopulatedFieldNotEditable), 
                            new String[]{fieldName}); 
                    } 
                }
                if(String.isNotBlank(rowError)){
                    lineEntry.addError(rowError);
                }
            }   
        }
    }

    @namespaceAccessible
    public static void validateChangeInLockedIfTransactedFields(
        List<String> fields, 
        List<SObject> oldEntries, 
        List<SObject> newEntries, 
        String quantityFielName){
        if(newEntries == null || oldEntries==null || fields == null){
            return;
        }
        Map<Id, SObject> oldObjectsMap = new Map<Id, SObject>(oldEntries);
        for(SObject lineEntry : newEntries){
            SObject oldEntry = oldObjectsMap.get(lineEntry.Id);
            if(oldEntry != null){
                String rowError = '';
                for(String fieldName: fields){
                    if(Double.valueOf(oldEntry.get(quantityFielName)) > 0
                        && oldEntry.get(fieldName) != lineEntry.get(fieldName)) {                    
                        rowError += String.format(
                            String.valueOf(System.Label.IntegrityFailed_TransactedFieldNotEditable), 
                            new String[]{fieldName}); 
                    } 
                }
                if(String.isNotBlank(rowError)){
                    lineEntry.addError(rowError);
                }
            }   
        }
    }

    @namespaceAccessible
    public static void validateChangeInLockedIfPostedFields(
        List<String> fields, 
        List<SObject> oldEntries, 
        List<SObject> newEntries, 
        String postedFieldName){
        if(newEntries == null || oldEntries==null){
            return;
        }
        Map<Id, SObject> oldObjectsMap = new Map<Id, SObject>(oldEntries);
        for(SObject lineEntry : newEntries){
            SObject oldEntry = oldObjectsMap.get(lineEntry.Id);
            if(oldEntry != null){
                String rowError = '';
                for(String fieldName: fields){
                    if(Boolean.valueOf(oldEntry.get(postedFieldName)) == true
                        && oldEntry.get(fieldName) != lineEntry.get(fieldName)) {                    
                        rowError += String.format(
                            String.valueOf(System.Label.IntegrityFailed_TransactedFieldNotEditable), 
                            new String[]{fieldName}); 
                    } 
                }
                if(String.isNotBlank(rowError)){
                    lineEntry.addError(rowError);
                }
            }   
        }
    }

    @namespaceAccessible
    public static void validateChangeInLockedIfTransactedFields(
        List<String> fields, 
        List<SObject> oldEntries, 
        List<SObject> newEntries, 
        List<Id> transactedIds){
        if(newEntries == null || oldEntries==null){
            return;
        }
        Map<Id, SObject> oldObjectsMap = new Map<Id, SObject>(oldEntries);
        for(SObject lineEntry : newEntries){
            SObject oldEntry = oldObjectsMap.get(lineEntry.Id);
            if(oldEntry != null){
                String rowError = '';
                for(String fieldName: fields){
                    if(transactedIds.contains(oldEntry.Id)
                        && oldEntry.get(fieldName) != lineEntry.get(fieldName)) {                    
                        rowError += String.format(
                            String.valueOf(System.Label.IntegrityFailed_TransactedFieldNotEditable), 
                            new String[]{fieldName}); 
                    } 
                }
                if(String.isNotBlank(rowError)){
                    lineEntry.addError(rowError);
                }
            }   
        }
    }

    @namespaceAccessible
    public static void validateCanBeDeleted(
        List<SObject> oldEntries, 
        String quantityFielName){
        if(oldEntries==null){
            return;
        }
        for(SObject oldEntry : oldEntries){
            if(Double.valueOf(oldEntry.get(quantityFielName)) > 0) {
                oldEntry.addError(String.valueOf(System.Label.IntegrityFailed_TransactedObjectNotDeletable)); 
            } 
        }
    }

    @namespaceAccessible
    public static void validateCanBeDeleted(
        List<SObject> oldEntries, 
        List<Id> transactedIds){
        if(oldEntries==null){
            return;
        }
        for(SObject oldEntry : oldEntries){
            if(transactedIds?.contains(oldEntry.Id)) {
                oldEntry.addError(String.valueOf(System.Label.IntegrityFailed_TransactedObjectNotDeletable)); 
            } 
        }
    }

    @namespaceAccessible
    public static void validateCantBeDeleted(
        List<SObject> oldEntries){
        if(oldEntries==null){
            return;
        }
        for(SObject oldEntry : oldEntries){
            oldEntry.addError(String.valueOf(System.Label.IntegrityFailed_TransactedObjectNotDeletable)); 
        }
    }

    @namespaceAccessible
    public static void validateCanBePosted(
        List<SObject> modifiedEntries, 
        String quantityFielName){
        if(modifiedEntries==null){
            return;
        }
        for(SObject oldEntry : modifiedEntries){
            if(Double.valueOf(oldEntry.get(quantityFielName)) > 0) {
                oldEntry.addError(String.valueOf(System.Label.IntegrityFailed_TransactedObjectNotPostable)); 
            } 
        }
    }
    
    @namespaceAccessible
    public static List<SObject> getModifiedNewObjects(
        string fieldNameToCheck, 
        List<SObject> oldEntries, 
        List<SObject> newEntries){
        List<SObject> modifiedObjects = new List<SObject>();
        if(newEntries == null || oldEntries==null){
            return modifiedObjects;
        }
        Map<Id, SObject> oldObjectsMap = new Map<Id, SObject>(oldEntries);
        for(SObject lineEntry : newEntries){
            SObject oldEntry = oldObjectsMap.get(lineEntry.Id);
            if(oldEntry != null){
                if(oldEntry.get(fieldNameToCheck) != lineEntry.get(fieldNameToCheck)) {                    
                    modifiedObjects.add(lineEntry);
                } 
            }   
        }
        return modifiedObjects;
    }

    @namespaceAccessible
    public static List<Id> getModifiedNewObjectIds(
        string fieldNameToCheck, 
        String idFieldName, 
        List<SObject> oldEntries, 
        List<SObject> newEntries){
        List<Id> modifiedObjects = new List<Id>();
        if(newEntries == null || oldEntries==null){
            return modifiedObjects;
        }
        Map<Id, SObject> oldObjectsMap = new Map<Id, SObject>(oldEntries);
        for(SObject lineEntry : newEntries){
            SObject oldEntry = oldObjectsMap.get(lineEntry.Id);
            if(oldEntry != null){
                if(lineEntry.get(idFieldName) != null && oldEntry.get(fieldNameToCheck) != lineEntry.get(fieldNameToCheck)) {                    
                    modifiedObjects.add((Id)lineEntry.get(idFieldName));
                } 
            }   
        }
        return modifiedObjects;
    }

    @namespaceAccessible
    public static List<SObject> getModifiedNewObjects(
        List<String> fieldNamesToCheck, 
        List<SObject> oldEntries, 
        List<SObject> newEntries){
        List<SObject> modifiedObjects = new List<SObject>();
        if(newEntries == null || oldEntries==null){
            return modifiedObjects;
        }
        Map<Id, SObject> oldObjectsMap = new Map<Id, SObject>(oldEntries);
        for(SObject lineEntry : newEntries){
            SObject oldEntry = oldObjectsMap.get(lineEntry.Id);
            if(oldEntry != null){
                for(String fieldName: fieldNamesToCheck){
                    if(oldEntry.get(fieldName) != lineEntry.get(fieldName)) {                    
                        modifiedObjects.add(lineEntry);
                        break;
                    } 
                }
            }   
        }
        return modifiedObjects;
    }

    @namespaceAccessible
    public static List<Id> getModifiedNewObjectIds(
        List<String> fieldNamesToCheck, 
        String idFieldName, 
        List<SObject> oldEntries, 
        List<SObject> newEntries){
        List<Id> modifiedObjects = new List<Id>();
        if(newEntries == null || oldEntries==null){
            return modifiedObjects;
        }
        Map<Id, SObject> oldObjectsMap = new Map<Id, SObject>(oldEntries);
        for(SObject lineEntry : newEntries){
            SObject oldEntry = oldObjectsMap.get(lineEntry.Id);
            if(oldEntry != null){
                for(String fieldName: fieldNamesToCheck){
                    if(lineEntry.get(idFieldName) != null && oldEntry.get(fieldName) != lineEntry.get(fieldName)) {                    
                        modifiedObjects.add((Id)lineEntry.get(idFieldName));
                        break;
                    } 
                }
            }   
        }
        return modifiedObjects;
    }
    
    @namespaceAccessible
    public static List<SObject> getApprovedObjects(
        String approvalfieldNames, 
        List<SObject> oldEntries, 
        List<SObject> newEntries){
        List<SObject> modifiedObjects = new List<SObject>();
        if(newEntries == null || oldEntries==null){
            return modifiedObjects;
        }
        Map<Id, SObject> oldObjectsMap = new Map<Id, SObject>(oldEntries);
        for(SObject lineEntry : newEntries){
            SObject oldEntry = oldObjectsMap.get(lineEntry.Id);
            if(oldEntry != null){
                if(oldEntry.get(approvalfieldNames) != lineEntry.get(approvalfieldNames) 
                    && ((Boolean)lineEntry.get(approvalfieldNames))) {                    
                    modifiedObjects.add(lineEntry);
                } 
            }   
        }
        return modifiedObjects;
    }

    @namespaceAccessible
    public static List<SObject> getApprovedNewObjects(
        String approvalfieldNames, 
        List<SObject> newEntries){
        List<SObject> modifiedObjects = new List<SObject>();
        if(newEntries == null){
            return modifiedObjects;
        }
        for(SObject lineEntry : newEntries){
            if((Boolean)lineEntry.get(approvalfieldNames)) {
                modifiedObjects.add(lineEntry);
            } 
        }
        return modifiedObjects;
    }

    @namespaceAccessible
    public static List<SObject> getPostedObjects(
        String postingfieldName, 
        List<SObject> oldEntries, 
        List<SObject> newEntries){
        List<SObject> modifiedObjects = new List<SObject>();
        if(newEntries == null && oldEntries == null){
            return modifiedObjects;
        }
        if(newEntries!=null){
            for(SObject lineEntry : newEntries){
                if((Boolean)lineEntry.get(postingfieldName)) {
                    modifiedObjects.add(lineEntry);
                } 
            }
        }
        else if(oldEntries !=null){
            for(SObject lineEntry : oldEntries){
                if((Boolean)lineEntry.get(postingfieldName)) {
                    modifiedObjects.add(lineEntry);
                } 
            }
        }
        return modifiedObjects;
    }
    
    @namespaceAccessible
    public static SObject getObject(
        List<SObject> objects, 
        Id objectId)
    {
        for(SObject objectEntry : objects){
            if(objectEntry.Id == objectId){
                return objectEntry;
            }
        }
        return null;
    }

    @namespaceAccessible
    public static List<SObject> getObjects(
        List<SObject> objects, 
        String idFieldName, 
        Id objectId)
    {
        List<SObject> sObjects = new List<SObject>();
        for(SObject objectEntry : objects){
            if(objectEntry.get(idFieldName) == objectId){
                sObjects.add(objectEntry);
            }
        }
        return sObjects;
    }

    @namespaceAccessible
    public static SObject getObjectByFilter(
        List<SObject> objects, 
        String fieldName, 
        object value){
        for(SObject objectEntry : objects){
            if(objectEntry.get(fieldName) == value){
               return objectEntry;
            }
        }
        return null;
    }

    @namespaceAccessible
    public static List<SObject> getObjectsByFilter(
        List<SObject> objects, 
        String fieldName, 
        object value){
        List<SObject> sObjects = new List<SObject>();
        for(SObject objectEntry : objects){
            if(objectEntry.get(fieldName) == value){
                sObjects.add(objectEntry);
            }
        }
        return sObjects;
    }

    @namespaceAccessible
    public static List<SObject> getObjectsByFilter(
        List<SObject> objects, 
        String relatedObjectName, 
        String fieldName, 
        object value){
        List<SObject> sObjects = new List<SObject>();
        for(SObject objectEntry : objects){
            SObject relatedObject = objectEntry.getSObject(relatedObjectName);
            if(relatedObject != null && relatedObject.get(fieldName) == value){
                sObjects.add(objectEntry);
            }
        }
        return sObjects;
    }

    @namespaceAccessible
    public static List<SObject> getObjectsWithNotNull(
        List<SObject> objects, 
        String fieldName){
        List<SObject> sObjects = new List<SObject>();
        for(SObject objectEntry : objects){
            if(objectEntry.get(fieldName) != null){
                sObjects.add(objectEntry);
            }
        }
        return sObjects;
    }

    @namespaceAccessible
    public static List<SObject> getObjectsWithNull(
        List<SObject> objects, 
        String fieldName){
        List<SObject> sObjects = new List<SObject>();
        for(SObject objectEntry : objects){
            if(objectEntry.get(fieldName) == null){
                sObjects.add(objectEntry);
            }
        }
        return sObjects;
    }

    @namespaceAccessible
    public static List<ID> extractIds(
        List<SObject> records)
    {
        List<ID> resultIds = new List<ID>();
        for(SObject record : records){
            if(record.get(FIELDNAME_ID) != null && !resultIds.contains((ID)record.get(FIELDNAME_ID))){
                resultIds.Add((ID)record.get(FIELDNAME_ID));
            }
        }
        return resultIds;
    }

    @namespaceAccessible
    public static List<ID> extractIds(
        List<SObject> records, 
        string fieldName)
    {
        List<ID> resultIds = new List<ID>();
        for(SObject record : records){
            if(record.get(fieldName) != null && !resultIds.contains((ID)record.get(fieldName))){
                resultIds.Add((ID)record.get(fieldName));
            }
        }
        return resultIds;
    }

    @namespaceAccessible
    public static List<ID> extractIds(
        List<SObject> records, 
        string relationshipName, 
        string fieldName)
    {
        List<ID> resultIds = new List<ID>();
        for(SObject record : records){
            List<SObject> relatedRecords = (List<SObject>)record.getSObjects(relationshipName);
            if(relatedRecords !=null && relatedRecords.size() > 0){
                for(SObject relatedRecord : relatedRecords){
                    if(relatedRecord.get(fieldName) != null 
                        && !resultIds.contains((ID)relatedRecord.get(fieldName))){
                        resultIds.Add((ID)relatedRecord.get(fieldName));
                    }
                }
            }
        }
        return resultIds;
    }

    @namespaceAccessible
    public static List<ID> extractIdsFromLookup(
        List<SObject> records, 
        string lookupFieldReference, 
        string fieldName)
    {
        List<ID> resultIds = new List<ID>();
        for(SObject record : records){
            SObject relatedRecord = (SObject)record.GetsObject(lookupFieldReference);
            if(relatedRecord !=null){
                if(relatedRecord.get(fieldName) != null)
                    resultIds.Add((ID)relatedRecord.get(fieldName));
            }
        }
        return resultIds;
    }

    @namespaceAccessible
    public static List<Object> extractUniqueValues(
        List<SObject> records, 
        string fieldName)
    {
        List<Object> results = new List<Object>();
        for(SObject record : records){
            if(record.get(fieldName) != null && !results.contains(record.get(fieldName))){
                results.Add(record.get(fieldName));
            }
        }
        return results;
    }

    @namespaceAccessible
    public static List<Date> extractUniqueDateValues(
        List<SObject> records, 
        string fieldName)
    {
        List<Date> results = new List<Date>();
        for(SObject record : records){
            if(record.get(fieldName) != null && !results.contains((Date)record.get(fieldName))){
                results.Add((Date)record.get(fieldName));
            }
        }
        return results;
    }

    @namespaceAccessible
    public static Map<ID, List<SObject>> mapLinesWithDocument(
        List<ID> documentIds, 
        string documentIdFieldNameInLines, 
        List<SObject> lines)
    {
        Map<ID, List<SObject>> result = new Map<ID, List<SObject>>();
        for(ID objectId : documentIds){
            List<SObject> internalResult = new List<SObject>();
            for(SObject record : lines){
                if((ID)record.get(documentIdFieldNameInLines) == objectId){
                    internalResult.Add(record);
                }
            }
            result.put(objectId, internalResult);
        }
        return result;
    }
}