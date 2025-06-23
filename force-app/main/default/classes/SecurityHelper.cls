@namespaceAccessible
public with sharing class SecurityHelper {
    private enum FLSType {
        ACCESSIBLE,
        UPDATABLE,
        CREATABLE
    }

    @namespaceAccessible
    public static void ensureCanReadField(string fieldName, string objectName){
        try{
            if(!canReadField(fieldName, objectName)){
                throw new DMPLNoAccessException(DMPLNoAccessException.AccessType.ReadAccess, objectName, fieldName);
            }
        }catch(DMPLNoAccessException ex){
            ExceptionLogHelper.logException(ex);
            throw ex;
        }
    }
    
    @namespaceAccessible
    public static void ensureCanWriteField(string fieldName, string objectName){
        try{
            if(!canWriteField(fieldName, objectName)){
                throw new DMPLNoAccessException(DMPLNoAccessException.AccessType.WriteAccess, objectName, fieldName);
            }
        }catch(DMPLNoAccessException ex){
            ExceptionLogHelper.logException(ex);
            throw ex;
        }
    }

    @namespaceAccessible
    public static void ensureCanCreateField(string fieldName, string objectName){
        try{
            if(!canCreateField(fieldName, objectName)){
                throw new DMPLNoAccessException(DMPLNoAccessException.AccessType.CreateAccess, objectName, fieldName);
            }
        }catch(DMPLNoAccessException ex){
            ExceptionLogHelper.logException(ex);
            throw ex;
        }
    }

    @namespaceAccessible
    public static void ensureCanReadFields(List<string> fieldNames, string objectName){
        try{
            List<String> fieldsNotReadble = new List<String>();
            if(!canReadFields(fieldNames, objectName, fieldsNotReadble)){
                throw new DMPLNoAccessException(DMPLNoAccessException.AccessType.ReadAccess, objectName,  String.join(fieldsNotReadble, ','));
            }
        }catch(DMPLNoAccessException ex){
            ExceptionLogHelper.logException(ex);
            throw ex;
        }
    }

    @namespaceAccessible
    public static void ensureCanWriteFields(List<string> fieldNames, string objectName){
        try{
            List<String> fieldsNotUpdateable = new List<String>();
            if(!canWriteFields(fieldNames, objectName, fieldsNotUpdateable)){
                System.debug('fieldsNotUpdateable '+fieldsNotUpdateable);
                throw new DMPLNoAccessException(DMPLNoAccessException.AccessType.WriteAccess, objectName, String.join(fieldsNotUpdateable, ','));
            }
        }catch(DMPLNoAccessException ex){
            ExceptionLogHelper.logException(ex);
            throw ex;
        }
    }

    @namespaceAccessible
    public static void ensureCanCreateFields(List<string> fieldNames, string objectName){
        try{
            List<String> fieldsNotUpdateable = new List<String>();
            if(!canCreateFields(fieldNames, objectName, fieldsNotUpdateable)){
                throw new DMPLNoAccessException(DMPLNoAccessException.AccessType.CreateAccess, objectName, String.join(fieldsNotUpdateable, ','));
            }
        }catch(DMPLNoAccessException ex){
            ExceptionLogHelper.logException(ex);
            throw ex;
        }
    }

    @namespaceAccessible
    public static void ensureCanReadObject(string objectName){
        try{
            if(!canReadObject(objectName)){
                throw new DMPLNoAccessException(DMPLNoAccessException.AccessType.ReadAccess, objectName);
            }
        }catch(DMPLNoAccessException ex){
            ExceptionLogHelper.logException(ex);
            throw ex;
        }   
    }

    @namespaceAccessible
    public static void ensureCanWriteObject(string objectName){
        try{
            if(!canWriteObject(objectName)){
                throw new DMPLNoAccessException(DMPLNoAccessException.AccessType.WriteAccess, objectName);
            }
        }catch(DMPLNoAccessException ex){
            ExceptionLogHelper.logException(ex);
            throw ex;
        }
    }
    
    @namespaceAccessible
    public static void ensureCanCreateObject(string objectName){
        try{
            if(!canCreateObject(objectName)){
                throw new DMPLNoAccessException(DMPLNoAccessException.AccessType.CreateAccess, objectName);
            }
        }catch(DMPLNoAccessException ex){
            ExceptionLogHelper.logException(ex);
            throw ex;
        }
    }

    @namespaceAccessible
    public static void ensureCanDeleteObject(string objectName){
        try{
            if(!canDeleteObject(objectName)){
                throw new DMPLNoAccessException(DMPLNoAccessException.AccessType.DeleteAccess, objectName);
            }
        }catch(DMPLNoAccessException ex){
            ExceptionLogHelper.logException(ex);
            throw ex;
        }
    }

    @namespaceAccessible
    public static Boolean canReadField(string fieldName, string objectName){
        SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        if(objType!=null && objType.getDescribe().isAccessible() && !String.isEmpty(fieldName)){
            Map<String, Map<FLSType, Boolean>> objResults = getFLSOnObject(objectName);
            Boolean canRead = objResults.get(fieldName.toLowerCase())?.get(SecurityHelper.FLSType.ACCESSIBLE);
            return (canRead != null && canRead);
        }
        return false;
    }
    
    @namespaceAccessible
    public static Boolean canWriteField(string fieldName, string objectName){
        SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        if(objType!=null && objType.getDescribe().isUpdateable() && !String.isEmpty(fieldName)){
            Map<String, Map<FLSType, Boolean>> objResults = getFLSOnObject(objectName);
            Boolean canUpdate = objResults.get(fieldName.toLowerCase())?.get(SecurityHelper.FLSType.UPDATABLE);
            return (canUpdate != null && canUpdate);
        }
        return false;
    }

    @namespaceAccessible
    public static Boolean canCreateField(string fieldName, string objectName){
        SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        if(objType!=null && objType.getDescribe().isCreateable() && !String.isEmpty(fieldName)){
            Map<String, Map<FLSType, Boolean>> objResults = getFLSOnObject(objectName);
            Boolean canCreate = objResults.get(fieldName.toLowerCase())?.get(SecurityHelper.FLSType.CREATABLE);
            return (canCreate != null && canCreate);
        }
        return false;
    }

    @namespaceAccessible
    public static Boolean canReadFields(List<string> fieldNames, string objectName, List<String> fieldsNotReadble){
        SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        if (objType==null || (!objType.getDescribe().isAccessible())){
            return false;
        }
        Map<String, Map<FLSType, Boolean>> objResults = getFLSOnObject(objectName);
        for(String fieldName : fieldNames){
            if(!String.isEmpty(fieldName)){
                Boolean canRead = objResults.get(fieldName.toLowerCase())?.get(SecurityHelper.FLSType.ACCESSIBLE);
                if((canRead != null && (!canRead))){
                    fieldsNotReadble.add(fieldName);
                    System.debug('SH-Read' + objectName+'-' +fieldName);
                }
            }
        }
        return fieldsNotReadble.size()==0;
    }

    @namespaceAccessible
    public static Boolean canWriteFields(List<string> fieldNames, string objectName, List<String> fieldsNotUpdateable){
        SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        if (objType==null || (!objType.getDescribe().isUpdateable())){
            return false;
        }
        Map<String, Map<FLSType, Boolean>> objResults = getFLSOnObject(objectName);
        for(String fieldName : fieldNames){
            if(!String.isEmpty(fieldName)){
                Boolean canUpdate = objResults.get(fieldName.toLowerCase())?.get(SecurityHelper.FLSType.UPDATABLE);
                if((canUpdate != null && (!canUpdate))){
                    fieldsNotUpdateable.add(fieldName);
                    System.debug('SH-Update' + objectName+'-' +fieldName);
                }
            }
        }
        return fieldsNotUpdateable.size()==0;
    }

    @namespaceAccessible
    public static Boolean canCreateFields(List<string> fieldNames, string objectName, List<String> fieldsNotCreatable){
        SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        if (objType==null || (!objType.getDescribe().isCreateable())){
            return false;
        }
        Map<String, Map<FLSType, Boolean>> objResults = getFLSOnObject(objectName);
        for(String fieldName : fieldNames){
            if(!String.isEmpty(fieldName)){
                Boolean canCreate = objResults.get(fieldName.toLowerCase())?.get(SecurityHelper.FLSType.CREATABLE);
                if((canCreate != null && (!canCreate))){
                    fieldsNotCreatable.add(fieldName);
                    System.debug('SH-Create' + objectName+'-' +fieldName);
                }
            }
        }
        return fieldsNotCreatable.size()==0;
    }

    @namespaceAccessible
    public static Boolean canReadObject(string objectName){
        SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        return objType!=null && objType.getDescribe().isAccessible();
    }

    @namespaceAccessible
    public static Boolean canWriteObject(string objectName){
        SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        return objType!=null && objType.getDescribe().isUpdateable();
    }
    
    @namespaceAccessible
    public static Boolean canCreateObject(string objectName){
        SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        return objType!=null && objType.getDescribe().isCreateable();
    }

    @namespaceAccessible
    public static Boolean canDeleteObject(string objectName){
        SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        return objType!=null && objType.getDescribe().isDeletable();        
    }

    private static Map<String, Map<FLSType, Boolean>> getFLSOnObject(
        String objectApiName
    ) {
        if (SessionCacheHelper.isPlatformCacheEnabled()) {
            Map<String, Map<FLSType, Boolean>> cachedFLS = (Map<String, Map<FLSType, Boolean>>)SessionCacheHelper.getObject('FPC' + objectApiName.remove('_'));
            if(cachedFLS == null){
                cachedFLS = calculateFLS(objectApiName);
                SessionCacheHelper.setObject('FPC'+objectApiName.remove('_'), cachedFLS);
            }
            return cachedFLS;
        } else {
            return calculateFLS(objectApiName);
        }
    }

    private static Map<String, Map<FLSType, Boolean>> calculateFLS(string objType) {
        Schema.DescribeSObjectResult[] descResult = Schema.describeSObjects(
            new List<String>{ objType }
        );
        Map<String, Map<FLSType, Boolean>> results = new Map<String, Map<FLSType, Boolean>>();
        if(descResult.size()>0){
            for (SObjectField field : descResult[0].fields.getMap().values()) {
                DescribeFieldResult fieldDetails = field.getDescribe();
                String fieldKey = String.valueOf(field).toLowerCase();
                results.put(fieldKey, new Map<FLSType, Boolean>());
                results.get(fieldKey)
                    .put(FLSType.ACCESSIBLE, fieldDetails.isAccessible());
                results.get(fieldKey)
                    .put(FLSType.UPDATABLE, fieldDetails.isUpdateable());
                results.get(fieldKey)
                    .put(FLSType.CREATABLE, fieldDetails.isCreateable());
            }    
        }
        return results;
    }
}