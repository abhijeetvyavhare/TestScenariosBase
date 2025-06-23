@namespaceAccessible
public with sharing class CollectionHelper {
    private static final String FIELDNAME_ID = 'Id';
    
    @namespaceAccessible
    public static SObject getObject(List<SObject> objects, Id objectId)
    {
        for(SObject objectEntry : objects){
            if(objectEntry.Id == objectId){
                return objectEntry;
            }
        }
        return null;
    }
    
    @namespaceAccessible
    public static SObject getObject(List<SObject> objects, String idFieldName, Id objectId)
    {
        for(SObject objectEntry : objects){
            if(objectEntry.get(idFieldName) == objectId){
                return objectEntry;
            }
        }
        return null;
    }
    
    public static SObject getObjectByString(List<SObject> objects, String stringFieldName, String stringValue)
    {
        for(SObject objectEntry : objects){
            if(objectEntry.get(stringFieldName) == stringValue){
                return objectEntry;
            }
        }
        return null;
    }

    @namespaceAccessible
    public static SObject getFirstIfExists(List<SObject> objects)
    {
        if(objects?.size()>0){
            return objects[0];
        }
        return null;
    }

    @namespaceAccessible
    public static List<SObject> getObjects(List<SObject> objects, String idFieldName, Id objectId)
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
    public static List<SObject> getObjectsByFilter(List<SObject> objects, String fieldName, object value){
        List<SObject> sObjects = new List<SObject>();
        if(objects!=null && objects.size()>0){
            for(SObject objectEntry : objects){
                if(objectEntry.get(fieldName) == value){
                    sObjects.add(objectEntry);
                }
            }
        }
        return sObjects;
    }

    public static List<SObject> getObjectsByFilterOrNull(List<SObject> objects, String fieldName, object value){
        List<SObject> sObjects = new List<SObject>();
        for(SObject objectEntry : objects){
            if(objectEntry.get(fieldName) == value || objectEntry.get(fieldName) == null){
                sObjects.add(objectEntry);
            }
        }
        return sObjects;
    }

    @namespaceAccessible
    public static List<SObject> getObjectsByFilter(
        List<SObject> objects, 
        String fieldName1, 
        object value1, 
        String fieldName2, 
        object value2){
        List<SObject> sObjects = new List<SObject>();
        for(SObject objectEntry : objects){
            if(objectEntry.get(fieldName1) == value1
                && objectEntry.get(fieldName2) == value2){
                sObjects.add(objectEntry);
            }
        }
        return sObjects;
    }

    @namespaceAccessible
    public static List<SObject> getObjectsWithNotNull(List<SObject> objects, String fieldName){
        List<SObject> sObjects = new List<SObject>();
        for(SObject objectEntry : objects){
            if(objectEntry.get(fieldName) != null){
                sObjects.add(objectEntry);
            }
        }
        return sObjects;
    }

    public static List<SObject> getObjectsWithNotNull(List<SObject> objects, List<String> fieldNamesToCheck){
        List<SObject> sObjects = new List<SObject>();
        for(SObject objectEntry : objects){
            for(String fieldName: fieldNamesToCheck){
                if(objectEntry.get(fieldName) != null) {                    
                    sObjects.add(objectEntry);
                    break;
                } 
            }
        }
        return sObjects;
    }
    
    @namespaceAccessible
    public static List<SObject> getObjectsWithNull(List<SObject> objects, String fieldName){
        List<SObject> sObjects = new List<SObject>();
        for(SObject objectEntry : objects){
            if(objectEntry.get(fieldName) == null){
                sObjects.add(objectEntry);
            }
        }
        return sObjects;
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
    public static List<SObject> getApprovedObjects(
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
    
    public static SObject findObjectByFilter(List<SObject> objects, String fieldName, object value){
        for(SObject objectEntry : objects){
            if(objectEntry.get(fieldName) == value){
                return objectEntry;
            }
        }
        return null;
    }

    @namespaceAccessible
    public static List<ID> extractIds(List<SObject> records)
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
    public static List<ID> extractIds(List<SObject> records, string fieldName)
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
    public static List<String> extractStrings(List<SObject> records, string fieldName)
    {
        List<String> resultIds = new List<String>();
        for(SObject record : records){
            if(record.get(fieldName) != null && !resultIds.contains((String)record.get(fieldName))){
                resultIds.Add((String)record.get(fieldName));
            }
        }
        return resultIds;
    }

    public static List<String> addStrings(List<String> results, List<SObject> records, string fieldName)
    {
        if(results == null){
            results = new List<String>();
        }
        for(SObject record : records){
            if(record.get(fieldName) != null && !results.contains((String)record.get(fieldName))){
                results.Add((String)record.get(fieldName));
            }
        }
        return results;
    }

    @namespaceAccessible
    public static List<Id> extractIds(List<AggregateResult> records, string fieldName)
    {
        List<Id> resultIds = new List<Id>();
        for(AggregateResult record : records){
            if(record.get(fieldName) != null && !resultIds.contains((ID)record.get(fieldName))){
                resultIds.Add((ID)record.get(fieldName));
            }
        }
        return resultIds;
    }
    
    @namespaceAccessible
    public static List<ID> extractIds(List<SObject> records, string relationshipName, string fieldName)
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
    public static List<String> extractStrings(List<SObject> records, string relationshipName, string fieldName)
    {
        List<String> resultStrings = new List<String>();
        for(SObject record : records){
            List<SObject> relatedRecords = (List<SObject>)record.getSObjects(relationshipName);
            if(relatedRecords !=null && relatedRecords.size() > 0){
                for(SObject relatedRecord : relatedRecords){
                    if(relatedRecord.get(fieldName) != null 
                        && !resultStrings.contains((String)relatedRecord.get(fieldName))){
                            resultStrings.Add((String)relatedRecord.get(fieldName));
                    }
                }
            }
        }
        return resultStrings;
    }

    @namespaceAccessible
    public static List<ID> extractCompoundIds(List<SObject> records, string compoundFieldName)
    {
        if(string.isBlank(compoundFieldName)){
            return new List<ID>();
        }
        if(!compoundFieldName.contains('.')){
            return extractIds(records, compoundFieldName);
        }
        List<ID> resultIds = new List<ID>();
        List<String> parts =  compoundFieldName.split('\\.');
        for(SObject record : records){
            SObject currentObject = record;
            for(String part : parts){
                if(currentObject != null){
                    if (part.endsWith('__c')) {
                        resultIds.add((Id)currentObject.get(part));
                        continue;
                    }
                    currentObject = currentObject.getSObject(part);    
                }
            }
        }
        return resultIds;
    }

    @namespaceAccessible
    public static List<Object> extractUniqueValues(List<SObject> records, string fieldName)
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
    public static List<Date> extractUniqueDateValues(List<SObject> records, string fieldName)
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
    public static Map<Id, SObject> idMapFromCollectionByKey(
        String key,
        List<SObject> incomingList
    ) {
        String objType = getSobjectTypeFromList(incomingList);
        Type dynamicMapType = Type.forName('Map<Id,' + objType + '>');
        Map<Id, SObject> returnValues = (Map<Id, SObject>) dynamicMapType.newInstance();
        for (SObject current : incomingList) {
            if (current.get(key) != null) {
                returnValues.put((Id) current.get(key), current);
            }
        }
        return returnValues;
    }

    @namespaceAccessible
    public static Map<String, SObject> stringMapFromCollectionByKey(
        String key,
        List<SObject> incomingList
    ) {
        String objType = getSobjectTypeFromList(incomingList);
        Type dynamicMapType = Type.forName('Map<String,' + objType + '>');
        Map<String, SObject> returnValues = (Map<String, SObject>) dynamicMapType.newInstance();
        for (SObject current : incomingList) {
            if (current.get(key) != null) {
                returnValues.put((String) current.get(key), current);
            }
        }
        return returnValues;
    }

    @namespaceAccessible
    public static Map<Date, SObject> dateMapFromCollectionByKey(
        String key,
        List<SObject> incomingList
    ) {
        String objType = getSobjectTypeFromList(incomingList);
        Type dynamicMapType = Type.forName('Map<Date,' + objType + '>');
        Map<Date, SObject> returnValues = (Map<Date, SObject>) dynamicMapType.newInstance();
        for (SObject current : incomingList) {
            if (current.get(key) != null) {
                returnValues.put((Date) current.get(key), current);
            }
        }
        return returnValues;
    }

    @namespaceAccessible
    public static Map<Date, AggregateResult> dateMapFromCollectionByKey(
        String key,
        List<AggregateResult> incomingList
    ) {
        Map<Date, AggregateResult> returnValues = new Map<Date, AggregateResult>();
        for (AggregateResult current : incomingList) {
            if (current.get(key) != null) {
                returnValues.put((Date) current.get(key), current);
            }
        }
        return returnValues;
    }

    @namespaceAccessible
    public static Map<Id, List<SObject>> mapFromCollectionWithCollectionValues(
        String key,
        List<SObject> incomingList
    ) {
        String objType = getSobjectTypeFromList(incomingList);
        Type listObjType = Type.forName('List<' + objType + '>');
        Type dynamicMapType = Type.forName('Map<Id, List<' + objType + '>>');
        Map<Id, List<SObject>> returnValues = (Map<Id, List<SObject>>) dynamicMapType.newInstance();
        for (SObject current : incomingList) {
            if (current.get(key) != null) {
                if (returnValues.keySet().contains((Id) current.get(key))) {
                    List<SObject> existingList = (List<SObject>) returnValues.get(
                        (Id) current.get(key)
                    );
                    existingList.add(current);
                    returnValues.put((id) current.get(key), existingList);
                } else {
                    List<SObject> newList = (List<SObject>) listObjType.newInstance();
                    newList.add(current);
                    returnValues.put((id) current.get(key), newList);
                }
            }
        }
        return returnValues;
    }

    @namespaceAccessible
    public static Map<String, List<SObject>> stringMapFromCollectionWithCollectionValues(
        String key,
        List<SObject> incomingList
    ) {
        String objType = getSobjectTypeFromList(incomingList);
        Type listObjType = Type.forName('List<' + objType + '>');
        Type dynamicMapType = Type.forName('Map<String, List<' + objType + '>>');
        Map<String, List<SObject>> returnValues = (Map<String, List<SObject>>) dynamicMapType.newInstance();
        for (SObject current : incomingList) {
            if (current.get(key) != null) {
                if (returnValues.keySet().contains((String) current.get(key))) {
                    List<SObject> existingList = (List<SObject>) returnValues.get(
                        (String) current.get(key)
                    );
                    existingList.add(current);
                    returnValues.put((String) current.get(key), existingList);
                } else {
                    List<SObject> newList = (List<SObject>) listObjType.newInstance();
                    newList.add(current);
                    returnValues.put((String) current.get(key), newList);
                }
            }
        }
        return returnValues;
    }

    @namespaceAccessible
    public static Map<Id, List<Id>> mapFromCollectionWithCollectionIdValues(
        String key1,
        String key2,
        List<SObject> incomingList
    ) {
        Map<Id, List<Id>> returnValues = new Map<Id, List<Id>>();
        for (SObject current : incomingList) {
            if (current.get(key1) != null) {
                if (returnValues.keySet().contains((Id) current.get(key1))) {
                    List<Id> existingList = (List<Id>) returnValues.get(
                        (Id) current.get(key1)
                    );
                    existingList.add((Id)current.get(key2));
                    returnValues.put((id) current.get(key1), existingList);
                } else {
                    List<Id> newList = new List<Id>();
                    newList.add((Id)current.get(key2));
                    returnValues.put((id) current.get(key1), newList);
                }
            }
        }
        return returnValues;
    }
    private static String getSobjectTypeFromList(List<SObject> incomingList) {
        return (!incomingList.isEmpty())
            ? String.valueOf(incomingList[0]?.getSObjectType())
            : 'sObject';
    }
}