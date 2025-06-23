public with sharing class DynamicTextParser {

    @TestVisible
    public static String parse(
        String source, 
        Object sourceObject){
        if(String.isEmpty(source)){
            source = '';
        }
        source = populateStaticFields(source, sourceObject);
        if(sourceObject instanceof List<SObject>){
            return populateRootCollections(source, (List<SObject>)sourceObject);
        }else {
            source = populateCollections(source, (SObject)sourceObject);
            return populateFields(source, (SObject)sourceObject);
        }
    }
    
    @TestVisible
    public static Boolean parseResult(
        String responsePayload,
        String responseSuccessPath,
        String responseSuccessValue,
        String responseSchema,
        SObject editableObject,
        List<SObject> editedObjects){
            if(String.isEmpty(responsePayload)){
                return false;
            }
            try {
                Map<String, Object> responseMap = new Map<String, Object>();
                Object responseTyped = JSON.deserializeUntyped(responsePayload);
                if(responseTyped instanceof Map<String, Object>){
                    responseMap = (Map<String, Object>)responseTyped;
                }else if(responseTyped instanceof List<Object>){
                    responseMap.put('root', responseTyped);
                }
                if(responseMap!=null){
                    parseResponseSchema(
                        responseSchema,
                        responseMap,
                        editableObject,
                        editedObjects);
                    return evalKeyValue(responseSuccessPath, responseMap) == responseSuccessValue;    
                }    
            } catch (Exception ex) {
                ExceptionLogHelper.logException(ex);
            }
            return false;
        }
    
    @TestVisible
    public static String populateCollections(
        String source, 
        SObject sourceObject){
        Pattern p = Pattern.compile('\\{!!(.*?)\\}');
        Matcher m = p.matcher(source);
        String result = source;
        while(m.find()) {
            String childSource = result.substringBetween(m.group(0));
            List<String> childResults = new List<String>();
            Object resultObject = evalValue(m.group(1), sourceObject);
            if(resultObject != sourceObject ){
                List<SObject> childObjects = (List<SObject>)resultObject;
                if(childObjects!=null){
                    for(SObject childObject : childObjects){
                        childResults.add(populateFields(childSource, childObject));
                    }    
                }    
            }
            if(!String.isEmpty(childSource)){
                result = result.replace(childSource,String.join(childResults, ','));
                result = result.replace(m.group(0), '');
                m.reset(result);    
            }
        }
        return result;
    }

    @TestVisible
    public static String populateRootCollections(
        String source, 
        List<SObject> sourceObjects){
        Pattern p = Pattern.compile('\\{!!!(.*?)\\}');
        Matcher m = p.matcher(source);
        String result = source;
        while(m.find()) {
            String childSource = result.substringBetween(m.group(0));
            List<String> childResults = new List<String>();
            for(SObject sourceObject : sourceObjects){
                String objectString = populateCollections(childSource, sourceObject);
                objectString = populateFields(objectString, sourceObject);
                childResults.add(objectString);
            }    
            if(!String.isEmpty(childSource)){
                result = result.replace(childSource,String.join(childResults, ','));
                result = result.replace(m.group(0), '');
                m.reset(result);    
            }
        }
        return result;
    }

    @TestVisible
    public static String populateFields(
        String source, 
        SObject sourceObject){
        Pattern p = Pattern.compile('\\{!(.*?)\\}');
        Matcher m = p.matcher(source);
        String result = source;
        List<String> triedValues = new List<String>();
        while(m.find()) {
            if(triedValues.contains(m.group(1))) {continue;}
            Object value = evalValue(m.group(1), sourceObject);
            if(value != sourceObject){
                result = result.replace(
                    m.group(0), 
                    String.valueOf(value == null?'':value));
                m.reset(result);    
            }else {
                triedValues.add(m.group(1));
            }
        }
        return result;
    }

    public static List<String> getDynamicFieldList(
        String source){
        Pattern p = Pattern.compile('\\{!(.*?)\\}');
        Matcher m = p.matcher(source);
        List<String> triedValues = new List<String>();
        while(m.find()) {
            if(triedValues.contains(m.group(1))) {
                continue;
            }
            triedValues.add(m.group(1));
        }
        return triedValues;
    }

    private static String populateStaticFields(String source, object sourceObject){
        if(sourceObject instanceof List<SObject>){
            source = source.replace('{!rootCount}', ((List<SObject>)sourceObject).size().format());
        }

        return source;
    }

    @TestVisible
    private static Object evalValue(
        String pattern, 
        SObject sourceObject){
        if(String.isBlank(pattern) || sourceObject == null){
            return null;
        }
        Object activeObject = sourceObject;
        List<String> parts = pattern.split('\\.');
        for (String part : parts) {
            if(activeObject==null){
                continue;
            }
            Map<String, Object> fieldValues = ((SObject)activeObject).getPopulatedFieldsAsMap();
            if(fieldValues.containsKey(part) ||
                HasPropertyOrRelation((SObject)activeObject, part)){
                if(fieldValues.containsKey(part)){
                    activeObject = fieldValues.get(part);
                } else {
                    try {
                        activeObject =((SObject)activeObject).getSObjects(part);    
                    } catch (Exception e) {
                        activeObject = null;
                    }
                }
            }else{
                activeObject = sourceObject;
            }
        }

        return activeObject;
    }

    @TestVisible
    private static Object evalKeyValue(
        String pattern, 
        Map<String,Object> sourceMap){
            if(String.isBlank(pattern) || sourceMap == null){
                return null;
            }
            Object activeObject = sourceMap;
            List<String> parts = pattern.split('\\.');
            for (String part : parts) {
                if(activeObject instanceof Map<String, Object>){
                    Map<String, Object> fieldValues = (Map<String,Object>)activeObject;
                    if(fieldValues!=null && fieldValues.containsKey(part)){
                        activeObject = fieldValues.get(part);
                        if(activeObject instanceof Object[]
                            && ((Object[])activeObject).size()>0){
                            activeObject = ((Object[])activeObject)[0];
                        }
                    }
                }
            }
            return activeObject;
    }

    @TestVisible
    private static void parseResponseSchema(
        String responseSchema,
        Map<String,Object> sourceMap,
        SObject editableObject,
        List<SObject> editedObjects){
            if(String.isBlank(responseSchema)){
                return;
            }
            List<String> parts = responseSchema.split('\\n');
            for (String part : parts){
                part = part.trim();
                if(String.isBlank(part)){
                    continue;
                }
                List<String> pairs = part.split(':');
                if(pairs.size()>1){
                    setObjectValue(
                        editableObject, 
                        editedObjects,
                        pairs[0], 
                        evalKeyValue(
                            pairs[1], 
                            sourceMap));
                }
            }
    }
    
    @TestVisible
    private static void setObjectValue(
        SObject editableObject, 
        List<SObject> editedObjects,
        String objectPattern,
        Object value
        ){
            Pattern p = Pattern.compile('\\{!(.*?)\\}');
            Matcher m = p.matcher(objectPattern);
            while(m.find()) {
                setValue(
                    m.group(1), 
                    editableObject,
                    editedObjects,
                    value);
            }    
        }

    @TestVisible
    private static void setValue(
        String pattern, 
        SObject sourceObject,
        List<SObject> editedObjects,
        Object value){
        SObject activeObject = sourceObject;
        List<String> parts = pattern.split('\\.');
        for (String part : parts) {
            if(activeObject!=null){
                SObject relatedObect = null;
                SObject[] relatedObects = null;
                try {
                    relatedObect = activeObject.getSObject(part);    
                } catch (Exception e) {}
                try {
                    relatedObects =activeObject.getSObjects(part);    
                } catch (Exception e) {}

                if(relatedObect!=null){
                    activeObject = relatedObect;
                } else if(relatedObect!=null && relatedObects.size()>0){
                    activeObject = relatedObects[0];
                } else {
                    try {
                        Map<String,SObjectField> fieldsMap = activeObject.getSObjectType().getDescribe().fields.getMap();
                        if(fieldsMap.containsKey(part)){
                            DescribeFieldResult describeF = fieldsMap.get(part).getDescribe();
                            activeObject.put(part, convert(describeF.getType(), value));
                        }else{
                            activeObject.put(part, value);
                        }
                        if(!editedObjects.contains(activeObject)){
                            editedObjects.add(activeObject);
                        }                            
                    } catch (Exception e) {}
                }
            }
        }
    }
    
    private static Boolean HasPropertyOrRelation(SObject obectToCheck, String property){
        DescribeSObjectResult sobjectDescribe = ((SObject)obectToCheck).getSObjectType().getDescribe();
        if(sobjectDescribe.fields.getMap().containsKey(property)) {
            return true;
        }else {
            for(ChildRelationship relation : sobjectDescribe.getChildRelationships()){
                if(relation.getRelationshipName() == property){
                    return true;
                }
            }
        }
        return false;
    }

    public static Object convert(Schema.DisplayType type, Object value) {
        switch on type {
            when base64,
            Combobox, 
            Email, 
            EncryptedString, 
            ID, 
            MultiPicklist, 
            Phone, 
            Picklist, 
            String, 
            TextArea,
            URL  {
                return value;
            }
            when Boolean{
                return Boolean.valueOf(value);
            }
            when Currency, Percent{
                if(value instanceof String)
                    return Decimal.valueOf((String)value);
                else 
                    return (Decimal)value;
            }
            when Date{
                return Date.valueOf(value);
            }
            when DateTime{
                return Datetime.valueOf(value);
            }
            when Double{
                if(value instanceof String)
                    return Double.valueOf((String)value);
                else
                    return Double.valueOf(value);
            }
            when Integer{
                if(value instanceof String)
                    return Integer.valueOf((String)value);
                else
                    return Integer.valueOf(value);
            }
            when Long{
                if(value instanceof String)
                    return Long.valueOf((String)value);
                else
                    return (Long)(value);
            }
        }
        return value;
    }
}