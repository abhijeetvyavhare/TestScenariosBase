@namespaceAccessible
public with sharing class StatusHelper {

    @namespaceAccessible
    public static void validateStatusNew(string objectApiName, string statusFieldApiName, List<SObject> newObjects){
        if(newObjects == null){
            return;
        }
        for(SObject lineEntry : newObjects){
            if(!isStatusStartInSequence(objectApiName, statusFieldApiName, lineEntry)){
                lineEntry.addError(String.format(
                    String.valueOf(System.Label.IntegrityFailed_StatusNotValid), 
                    new String[]{(String)lineEntry.get(statusFieldApiName)}));   
            }
        }
    }

    @namespaceAccessible
    public static void validateStatusEdit(string objectApiName, string statusFieldApiName, List<SObject> oldObjects, List<SObject> newObjects){
        if(newObjects == null || oldObjects==null){
            return;
        }
        Map<Id, SObject> oldObjectsMap = new Map<Id, SObject>(oldObjects);
        for(SObject lineEntry : newObjects){
            SObject oldEntry = oldObjectsMap.get(lineEntry.Id);
            if(oldEntry != null 
                && oldEntry.get(statusFieldApiName) != lineEntry.get(statusFieldApiName) 
                && !isStatusMovementInSequence(objectApiName, statusFieldApiName, lineEntry, oldEntry)){                    
                lineEntry.addError(String.format(
                    String.valueOf(System.Label.IntegrityFailed_StatusMoveNotValid), 
                    new String[]{(String)lineEntry.get(statusFieldApiName), (String)oldEntry.get(statusFieldApiName)})); 
            }   
        }
    }

    private static Boolean isStatusMovementInSequence(string objectApiName, string statusFieldApiName, SObject newObject, SObject oldObject){        
        if((new DocumentStatusDFSHelper()).DocumentStatusJumpsAllowd(objectApiName, statusFieldApiName)){
            return true;
        } else if(newObject == null || oldObject ==null){
            return false;
        }
        Schema.DescribeSObjectResult sObjectInfo = Schema.getGlobalDescribe().get(objectApiName).getDescribe();   
        Schema.SObjectField statusField = sObjectInfo.fields.getMap().get(statusFieldApiName);
        if(statusField==null){
            return false;
        }
        Schema.PicklistEntry oldStatusEntry;
        Schema.PicklistEntry newStatusEntry;
        List<Schema.PicklistEntry> statusList = statusField.getDescribe().getPicklistValues();
        for(Schema.PicklistEntry statusEntry : statusList){
            if(statusEntry.getValue() == newObject.get(statusFieldApiName)){
                newStatusEntry = statusEntry;
            }
            if(statusEntry.getValue() == oldObject.get(statusFieldApiName)){
                oldStatusEntry = statusEntry;
            }
        }
        return (statusList.indexOf(newStatusEntry) - statusList.indexOf(oldStatusEntry) == 1);
    }

    private static Boolean isStatusStartInSequence(string objectApiName, string statusFieldApiName, SObject newObject)
    {
        if(newObject == null){
            return false;
        }
        if(newObject.get(statusFieldApiName)==null 
            || (new DocumentStatusDFSHelper()).DocumentStatusJumpStartAllowd(objectApiName, statusFieldApiName)){
            return true;
        }
        Schema.DescribeSObjectResult sObjectInfo = Schema.getGlobalDescribe().get(objectApiName).getDescribe();   
        Schema.SObjectField statusField = sObjectInfo.fields.getMap().get(statusFieldApiName);
        if(statusField==null){
            return false;
        }
        Schema.PicklistEntry newStatusEntry;
        List<Schema.PicklistEntry> statusList = statusField.getDescribe().getPicklistValues();
        for(Schema.PicklistEntry statusEntry : statusList){
            if(statusEntry.getValue() == newObject.get(statusFieldApiName)){
                return (statusList.indexOf(statusEntry) == 0);
            }
        }
        return false;
    }
}