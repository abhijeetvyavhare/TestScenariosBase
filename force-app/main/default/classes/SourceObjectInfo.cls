global with sharing class SourceObjectInfo {
    @AuraEnabled
    global String objectApiName {get;set;}

    @AuraEnabled
    global Id objectId {get;set;}
    
    @AuraEnabled
    global Decimal quantity {get;set;}
    
    @AuraEnabled
    global String data {get;set;}

    @AuraEnabled
    global Id objectGroupId {get;set;}

    @AuraEnabled
    public List<SourceObjectField> fields {get;set;}

    global Map<String, Id> resultDocuments { get; set; }

    global SourceObjectInfo(){

    }
    
    public SourceObjectInfo(Id objectId)
    {
        this.objectId = objectId;
    }

    public SourceObjectInfo(String objectApiName, Id objectId, Decimal quantity, String data)
    {
        this.objectApiName = objectApiName;
        this.objectId = objectId;
        this.quantity = quantity;
        this.data = data;
    }

    @testVisible
    public SourceObjectInfo(String objectApiName, Id objectId, Decimal quantity, String data, Id objectGroupId)
    {
        this.objectApiName = objectApiName;
        this.objectId = objectId;
        this.quantity = quantity;
        this.data = data;
        this.objectGroupId = objectGroupId;
    }

    public static List<ID> extractIds(List<SourceObjectInfo> records)
    {
        List<ID> resultIds = new List<ID>();
        for(SourceObjectInfo record : records){
            if(record.objectId != null && !resultIds.contains(record.objectId)){
                resultIds.Add(record.objectId);
            }
        }
        return resultIds;
    }

    public static SourceObjectInfo getSourceObjectInfo(List<SourceObjectInfo> records, Id lineId){
        if(records == null){
            return null;
        }
        for(SourceObjectInfo info : records){
            if(info.objectId == lineId){
                return info;
            }
        }
        return null;
    }

    public static Decimal getRequestedQuantity(List<SourceObjectInfo> records, Id lineId){
        if(records == null){
            return 0;
        }
        for(SourceObjectInfo info : records){
            if(info.objectId == lineId){
                return info.quantity;
            }
        }
        return 0;
    }

    public static Decimal getRequestedQuantity(
        List<SourceObjectInfo> records, 
        Id lineId, 
        Id groupId){
        if(records == null){
            return 0;
        }
        for(SourceObjectInfo info : records){
            if(info.objectId == lineId 
                && info.objectGroupId == groupId){
                return info.quantity;
            }
        }
        return 0;
    }

    public static void reduceRequestedQuantity(
        List<SourceObjectInfo> records, 
        Id lineId, 
        Id groupId,
        Decimal quantity){
        if(records == null){
            return;
        }
        for(SourceObjectInfo info : records){
            if(info.objectId == lineId 
                && info.objectGroupId == groupId){
                info.quantity = info.quantity -quantity;
                return;
            }
        }
        return;
    }

    public Id getDestinationObjectId(String sourceDocumentKey){
        if(this.resultDocuments!=null 
            && this.resultDocuments.containsKey(sourceDocumentKey)){
            return this.resultDocuments.get(sourceDocumentKey);
        }
        return null;
    }

    @testVisible
    public static List<SourceObjectInfo> generateFromQueue(
        List<dmpl__JobQueueRecord__c> scope,
        Map<String, Id> resultDocuments){
        List<SourceObjectInfo> sourceobjects = new List<SourceObjectInfo>();
        if(scope == null){
            return sourceobjects;
        }
        for(dmpl__JobQueueRecord__c queRecord : scope){
            SourceObjectInfo info = new SourceObjectInfo(
                queRecord.dmpl__RecordApiName__c,
                Id.valueOf(queRecord.dmpl__RecordId__c),
                queRecord.dmpl__Quantity__c,
                queRecord.dmpl__RecordData__c);
            info.resultDocuments = resultDocuments;
            sourceobjects.add(info);
        }
        return sourceobjects;
    }

    public static List<dmpl__JobQueueRecord__c> generateToQueue(Id queueId, List<SourceObjectInfo> scope){
        List<dmpl__JobQueueRecord__c> queueRecords = new List<dmpl__JobQueueRecord__c>();
        if(scope == null){
            return queueRecords;
        }
        for(SourceObjectInfo sourceObj : scope){
            queueRecords.add(
                new dmpl__JobQueueRecord__c(
                    dmpl__JobQueueId__c = queueId,
                    dmpl__RecordApiName__c = sourceObj.objectApiName,
                    dmpl__RecordId__c = sourceObj.objectId,
                    dmpl__Quantity__c = sourceObj.quantity,
                    dmpl__RecordData__c = sourceObj.data));
        }
        return queueRecords;
    }
    
    public static List<dmpl__JobQueueRecord__c> generateToQueue(Id queueId, List<SObject> scope){
        List<dmpl__JobQueueRecord__c> queueRecords = new List<dmpl__JobQueueRecord__c>();
        if(scope == null){
            return queueRecords;
        }
        for(SObject sourceObj : scope){
            queueRecords.add(
                new dmpl__JobQueueRecord__c(
                    dmpl__JobQueueId__c = queueId,
                    dmpl__RecordId__c = (String)sourceObj.get('Id')));
        }
        return queueRecords;
    }

    public static List<SourceObjectInfo> createFrom(List<SObject> scope){
        List<SourceObjectInfo> infos = new List<SourceObjectInfo>();
        if(scope == null){
            return infos;
        }
        for(SObject sourceObj : scope){
            infos.add(new SourceObjectInfo(sourceObj.Id));
        }
        return infos;
    }
}