@namespaceAccessible
public with sharing class DMPLNoAccessException extends Exception {
    
    public enum AccessType {
        ReadAccess,
        WriteAccess,
        DeleteAccess,
        CreateAccess    
    }

    public AccessType accessType;
    public string objectName;
    public String fieldName;
    
    @namespaceAccessible
    public DMPLNoAccessException(AccessType accessType, string objectName){
        this.accessType = accessType;
        this.objectName = objectName;
    }

    @namespaceAccessible
    public DMPLNoAccessException(AccessType accessType, string objectName, string fieldName) {
        this.accessType = accessType;
        this.objectName = objectName;
        this.fieldName = fieldName;
    }
}