global with sharing class FieldMappingHelper {
    
    global static void copyFieldMappingData(
        List<SObject> destinationObjects){
        if(destinationObjects == null
            || destinationObjects.size()==0){
            return;
        }
        String destinationObjectApiName = destinationObjects[0].getSObjectType().getDescribe().getName();
        List<dmpl__DMSFieldMapping__mdt> mappings = getNonRecordOnlyDistinctSourceMappings(
                destinationObjectApiName
            );
        
        for(dmpl__DMSFieldMapping__mdt mapping : mappings){
            if(mapping.dmpl__DestinationLookupFieldName__r?.QualifiedApiName == null
                || mapping.dmpl__SourceObjectNameId__r?.QualifiedApiName == null){
                continue;
            }
            copyFieldMappingData(
                mapping.dmpl__SourceObjectNameId__r.QualifiedApiName,
                CollectionHelper.extractIds(
                    destinationObjects, 
                    mapping.dmpl__DestinationLookupFieldName__r.QualifiedApiName),
                mapping.dmpl__DestinationLookupFieldName__r.QualifiedApiName,
                destinationObjects
            );
        }
    }

    public static List<dmpl__DMSFieldMapping__mdt> getFieldMappings(
        String sourceObjectApiName,
        String destinationObjectApiName){
            return [
                SELECT 
                    dmpl__DestinationFieldName__r.QualifiedApiName,
                    dmpl__SourceFieldNameId__r.QualifiedApiName,
                    dmpl__DestinationLookupFieldName__r.QualifiedApiName,
                    dmpl__RecordFormOnly__c,
                    dmpl__CopyOnlyIfEmpty__c,
                    dmpl__SequenceNumber__c
                FROM 
                    dmpl__DMSFieldMapping__mdt
                WHERE 
                    dmpl__Disabled__c = false
                    AND dmpl__SourceObjectNameId__r.QualifiedApiName =:sourceObjectApiName
                    AND dmpl__DestinationObjectNameId__r.QualifiedApiName =:destinationObjectApiName
                ORDER BY dmpl__SequenceNumber__c
            ];
        }

    public static List<dmpl__DMSFieldMapping__mdt> getAllFieldMappings(
        String destinationObjectApiName){
            return [
                SELECT 
                    dmpl__SourceObjectNameId__r.QualifiedApiName,
                    dmpl__SourceFieldNameId__r.QualifiedApiName,
                    dmpl__DestinationFieldName__r.QualifiedApiName,
                    dmpl__DestinationLookupFieldName__r.QualifiedApiName,
                    dmpl__RecordFormOnly__c,
                    dmpl__CopyOnlyIfEmpty__c,
                    dmpl__SequenceNumber__c
                FROM 
                    dmpl__DMSFieldMapping__mdt
                WHERE 
                    dmpl__Disabled__c = false
                    AND dmpl__DestinationObjectNameId__r.QualifiedApiName =:destinationObjectApiName
                ORDER BY dmpl__SequenceNumber__c
            ];
        }
    
    public static List<SObject> queryObjects(
        String sourceObjectApiName,
        List<dmpl__DMSFieldMapping__mdt> mappings,
        List<Id> objectIds
    ){
        List<String> fields = new List<String>();
        for(dmpl__DMSFieldMapping__mdt mapping : mappings){
            if(!fields.contains(mapping.dmpl__SourceFieldNameId__r.QualifiedApiName)){
                fields.add(mapping.dmpl__SourceFieldNameId__r.QualifiedApiName);
            }
        }
        String query = 'SELECT ' 
            + String.join(fields, ', ') 
            + ' FROM ' + sourceObjectApiName
            + ' WHERE Id IN :objectIds';
        System.debug(query);
        return Database.query(query);
    }

    private static List<dmpl__DMSFieldMapping__mdt> getNonRecordOnlyDistinctSourceMappings(
        String destinationObjectApiName){
        List<dmpl__DMSFieldMapping__mdt> mappings = [
            SELECT 
                dmpl__SourceObjectNameId__r.QualifiedApiName,
                dmpl__DestinationLookupFieldName__r.QualifiedApiName
            FROM 
                dmpl__DMSFieldMapping__mdt
            WHERE 
                dmpl__Disabled__c = false
                AND dmpl__RecordFormOnly__c = false
                AND dmpl__DestinationObjectNameId__r.QualifiedApiName =:destinationObjectApiName
            ORDER BY dmpl__SequenceNumber__c];
        
        Map<string, dmpl__DMSFieldMapping__mdt> uniqueMappings  = new Map<string, dmpl__DMSFieldMapping__mdt>();
        for(dmpl__DMSFieldMapping__mdt mapping : mappings){
            string key = mapping.dmpl__SourceObjectNameId__r.QualifiedApiName 
                + mapping.dmpl__DestinationLookupFieldName__r.QualifiedApiName;
            if(!uniqueMappings.containsKey(key)){
                uniqueMappings.put(
                    key,
                    mapping);
            }
        }
        return uniqueMappings.values();
    }

    private static void copyFieldMappingData(
        String sourceObjectApiName,
        List<Id> sourceObjectsIds,
        String sourceObjectIdFieldNameInDestination,
        List<SObject> destinationObjects
    ){
        if(String.isBlank(sourceObjectApiName)
            || sourceObjectsIds == null
            || sourceObjectsIds.size() ==0 
            || destinationObjects == null
            || destinationObjects.size()==0){
            return;
        }
        String destinationObjectApiName = destinationObjects[0].getSObjectType().getDescribe().getName();
        List<dmpl__DMSFieldMapping__mdt> mappings = getFieldMappings(
            sourceObjectApiName,
            destinationObjectApiName
        );
        if(mappings.size() ==0){
            return;
        }
        List<SObject> sourceObjectsPopulated = queryObjects(
            sourceObjectApiName,
            mappings,
            sourceObjectsIds
        );
        for(SObject destination : destinationObjects){
            if(destination.get(sourceObjectIdFieldNameInDestination) == null){
                continue;
            }
            SObject source = CollectionHelper.getObject(
                sourceObjectsPopulated, 
                (Id)destination.get(sourceObjectIdFieldNameInDestination));
            if(source == null){
                continue;
            }
            for(dmpl__DMSFieldMapping__mdt mapping :  mappings){
                if(mapping.dmpl__RecordFormOnly__c){
                    continue;
                }
                if((!mapping.dmpl__CopyOnlyIfEmpty__c)
                    || destination.get(
                        mapping.dmpl__DestinationFieldName__r.QualifiedApiName) == null){
                        destination.put(
                            mapping.dmpl__DestinationFieldName__r.QualifiedApiName, 
                            source.get(mapping.dmpl__SourceFieldNameId__r.QualifiedApiName));
                }
            }
        }
    }
}