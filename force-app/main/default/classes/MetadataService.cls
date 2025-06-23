global with sharing virtual class MetadataService {

    global static final String FIELD_STATUS = 'dmpl__Status__c';
    global static final string FIELD_PARTNER_ACCOUNT_ID = 'dmpl__PartnerAccountId__c';
    global static final string FIELD_BRANCH_ID = 'dmpl__BranchId__c';
    global static final string FIELD_DOCUMENT_DATE ='dmpl__DocumentDate__c';
    global static final String FIELD_ITEM_ID = 'dmpl__ItemId__c';
    global static final string FIELD_ITEM_GROUP_ID = 'dmpl__ItemGroupId__c';        
    global static final string FIELD_SKU_ID = 'dmpl__SKUId__c';
    global static final string FIELD_ITEM_LOT_ID = 'dmpl__ItemLotId__c ';
    global static final string FIELD_IS_APPROVED = 'dmpl__IsApproved__c';
    global static final string FIELD_DATE_EFFECTIVE_FROM = 'dmpl__DateEffectiveFrom__c';
    global static final string FIELD_DATE_EFFECTIVE_TILL = 'dmpl__DateEffectiveTill__c';

    private String sObjectType;
    
    global MetadataService(String sObjectType) {
        this.sObjectType = sObjectType;
    }

    global SObject queryObject(
        String fieldName,
        Id recordId){
            return queryObjectForType(
                sObjectType,
                fieldName, 
                recordId);
    }

    global SObject queryObject(
        String fieldName,
        String lookupFieldName,
        Id lookupRecordId){
            return queryObjectForType(
                sObjectType,
                fieldName,
                lookupFieldName, 
                lookupRecordId);
    }

    global SObject queryObject(
        List<String> fieldNames,
        Id recordId){
            return queryObjectForType(
                sObjectType,
                fieldNames, 
                recordId);
    }

    global SObject queryObject(
        List<String> fieldNames,
        String lookupFieldName,
        Id lookupRecordId){
            return queryObjectForType(
                sObjectType,
                fieldNames, 
                lookupFieldName,
                lookupRecordId);
    }
    
    global SObject queryObjectWithRelation(
        List<String> fieldNames,
        String relationName,
        List<String> relatedFieldNames,
        Id recordId){
            return queryObjectWithRelationForType(
                sObjectType, 
                fieldNames, 
                relationName, 
                relatedFieldNames, 
                recordId);
        }

    global SObject queryObjectWithRelation(
        List<String> fieldNames,
        String relationName,
        List<String> relatedFieldNames,
        String lookupFieldName,
        Id lookupRecordId){
            return queryObjectWithRelationForType(
                sObjectType, 
                fieldNames, 
                relationName, 
                relatedFieldNames, 
                lookupFieldName, 
                lookupRecordId);
        }

    global List<SObject> queryObjects(
        String fieldName,
        List<Id> recordIds){
            return queryObjectsForType(
                sObjectType,
                fieldName,
                recordIds);
    }

    global List<SObject> queryObjects(
        String fieldName,
        String lookupFieldName,
        List<Id> lookupRecordIds){
            return queryObjectsForType(
                sObjectType,
                fieldName,
                lookupFieldName,
                lookupRecordIds);
    }

    global List<SObject> queryObjects(
        List<String> fieldNames,
        List<Id> recordIds){
            return queryObjectsForType(
                sObjectType,
                fieldNames,
                recordIds);
    }

    global List<SObject> queryObjects(
        List<String> fieldNames,
        String lookupFieldName,
        List<Id> lookupRecordIds){
            return queryObjectsForType(
                sObjectType,
                fieldNames,
                lookupFieldName,
                lookupRecordIds);
    }

    global List<SObject> queryObjects(
        List<String> fieldNames,
        String lookupFieldName,
        Id lookupRecordId){
            return queryObjectsForType(
                sObjectType,
                fieldNames,
                lookupFieldName,
                lookupRecordId);
    }
    
    global List<SObject> queryObjectsWithRelation(
        List<String> fieldNames,
        String relationName,
        List<String> relatedFieldNames,
        String lookupFieldName,
        Id lookupRecordId){
            return queryObjectsWithRelationForType(
                sObjectType, 
                fieldNames, 
                relationName, 
                relatedFieldNames, 
                lookupFieldName, 
                lookupRecordId);
        }
        
    global List<SObject> queryObjectsWithRelation(
        List<String> fieldNames,
        String relationName,
        List<String> relatedFieldNames,
        Id recordId){
            return queryObjectsWithRelationForType(
                sObjectType, 
                fieldNames, 
                relationName, 
                relatedFieldNames, 
                recordId);
        }

    global SObject queryObjectForType(
        String objectType,
        String fieldName,
        Id recordId){
            SecurityHelper.ensureCanReadField(
                fieldName, 
                objectType);
            Id resolvedRecordId = recordId;
            return CollectionHelper.getFirstIfExists(
                Database.query(
                    buildQuery(
                        objectType,
                        getSelectStatement(fieldName), 
                        getWhereClause(recordId))));
    }

    global SObject queryObjectForType(
        String objectType,
        String fieldName,
        String lookupFieldName,
        Id lookupRecordId){
            SecurityHelper.ensureCanReadField(
                fieldName, 
                objectType);
            Id resolvedRecordId = lookupRecordId;
            return CollectionHelper.getFirstIfExists(
                Database.query(
                    buildQuery(
                        objectType,
                        getSelectStatement(fieldName), 
                        getWhereClause(
                            lookupFieldName, 
                            lookupRecordId))));
    }

    global SObject queryObjectForType(
        String objectType,
        List<String> fieldNames,
        Id recordId){
            SecurityHelper.ensureCanReadFields(
                fieldNames, 
                objectType);
            Id resolvedRecordId = recordId;
            return CollectionHelper.getFirstIfExists(
                Database.query(
                    buildQuery(
                        objectType,
                        getSelectStatement(fieldNames), 
                        getWhereClause(recordId))));
    }

    global SObject queryObjectForType(
        String objectType,
        List<String> fieldNames,
        String lookupFieldName,
        Id lookupRecordId){
            SecurityHelper.ensureCanReadFields(
                fieldNames, 
                objectType);
            Id resolvedRecordId = lookupRecordId;
            return CollectionHelper.getFirstIfExists(
                Database.query(
                    buildQuery(
                        objectType,
                        getSelectStatement(fieldNames), 
                        getWhereClause(
                            lookupFieldName,
                            lookupRecordId))));
    }
    
    global SObject queryObjectWithRelationForType(
        String objectType,
        List<String> fieldNames,
        String relationName,
        List<String> relatedFieldNames,
        Id recordId){
            SecurityHelper.ensureCanReadFields(
                fieldNames, 
                objectType);
            Id resolvedRecordId = recordId;
            return CollectionHelper.getFirstIfExists(
                Database.query(
                    buildQuery(
                        objectType,
                        getSelectStatement(
                            fieldNames,
                            relationName,
                            relatedFieldNames), 
                        getWhereClause(
                            recordId))));
    }

    global SObject queryObjectWithRelationForType(
        String objectType,
        List<String> fieldNames,
        String relationName,
        List<String> relatedFieldNames,
        String lookupFieldName,
        Id lookupRecordId){
            SecurityHelper.ensureCanReadFields(
                fieldNames, 
                objectType);
            Id resolvedRecordId = lookupRecordId;
            return CollectionHelper.getFirstIfExists(
                Database.query(
                    buildQuery(
                        objectType,
                        getSelectStatement(
                            fieldNames,
                            relationName,
                            relatedFieldNames), 
                        getWhereClause(
                            lookupFieldName,
                            lookupRecordId))));
    }

    global List<SObject> queryObjectsForType(
        String objectType,
        String fieldName,
        List<Id> recordIds){
            SecurityHelper.ensureCanReadField(
                fieldName, 
                objectType);
            List<Id> resolvedRecordIds = recordIds;
            return Database.query(
                buildQuery(
                    objectType,
                    getSelectStatement(fieldName), 
                    getWhereClause(recordIds)));
    }

    global List<SObject> queryObjectsForType(
        String objectType,
        String fieldName,
        String lookupFieldName,
        List<Id> lookupRecordIds){
            SecurityHelper.ensureCanReadField(
                fieldName, 
                objectType);
            List<Id> resolvedRecordIds = lookupRecordIds;
            return Database.query(
                buildQuery(
                    objectType,
                    getSelectStatement(fieldName), 
                    getWhereClause(
                        lookupFieldName,
                        lookupRecordIds)));
    }


    global List<SObject> queryObjectsForType(
        String objectType,
        List<String> fieldNames,
        List<Id> recordIds){
            SecurityHelper.ensureCanReadFields(
                fieldNames, 
                objectType);
            List<Id> resolvedRecordIds = recordIds;
            return Database.query(
                buildQuery(
                    objectType,
                    getSelectStatement(fieldNames), 
                    getWhereClause(recordIds)));
    }
    
    global List<SObject> queryObjectsForType(
        String objectType,
        List<String> fieldNames,
        String lookupFieldName,
        List<Id> lookupRecordIds){
            SecurityHelper.ensureCanReadFields(
                fieldNames, 
                objectType);
            List<Id> resolvedRecordIds = lookupRecordIds;
            return Database.query(
                buildQuery(
                    objectType,
                    getSelectStatement(fieldNames), 
                    getWhereClause(
                        lookupFieldName,
                        lookupRecordIds)));
    }

    global List<SObject> queryObjectsForType(
        String objectType,
        List<String> fieldNames,
        String lookupFieldName,
        Id lookupRecordId){
            SecurityHelper.ensureCanReadFields(
                fieldNames, 
                objectType);
            Id resolvedRecordId = lookupRecordId;
            return Database.query(
                buildQuery(
                    objectType,
                    getSelectStatement(fieldNames), 
                    getWhereClause(
                        lookupFieldName,
                        lookupRecordId)));
    }

    global List<SObject> queryObjectsForType(
        String objectType,
        String fieldName,
        String lookupFieldName,
        Id lookupRecordId){
            SecurityHelper.ensureCanReadField(
                fieldName, 
                objectType);
            Id resolvedRecordId = lookupRecordId;
            return Database.query(
                buildQuery(
                    objectType,
                    getSelectStatement(fieldName), 
                    getWhereClause(
                        lookupFieldName,
                        lookupRecordId)));
    }

    global List<SObject> queryObjectsWithRelationForType(
        String objectType,
        List<String> fieldNames,
        String relationName,
        List<String> relatedFieldNames,
        Id recordId){
            SecurityHelper.ensureCanReadFields(
                fieldNames, 
                objectType);
            Id resolvedRecordId = recordId;
            return Database.query(
                buildQuery(
                    objectType,
                    getSelectStatement(
                        fieldNames, 
                        relationName, 
                        relatedFieldNames), 
                    getWhereClause(recordId)));
    }

    global List<SObject> queryObjectsWithRelationForType(
        String objectType,
        List<String> fieldNames,
        String relationName,
        List<String> relatedFieldNames,
        List<Id> recordIds){
            SecurityHelper.ensureCanReadFields(
                fieldNames, 
                objectType);
            List<Id> resolvedRecordIds = recordIds;
            return Database.query(
                buildQuery(
                    objectType,
                    getSelectStatement(
                        fieldNames,
                        relationName,
                        relatedFieldNames), 
                    getWhereClause(recordIds)));
    }

    global List<SObject> queryObjectsWithRelationForType(
        String objectType,
        List<String> fieldNames,
        String relationName,
        List<String> relatedFieldNames,
        String lookupFieldName,
        Id lookupRecordId){
            SecurityHelper.ensureCanReadFields(
                fieldNames, 
                objectType);
            Id resolvedRecordId = lookupRecordId;
            return Database.query(
                buildQuery(
                    objectType,
                    getSelectStatement(fieldNames), 
                    getWhereClause(
                        lookupFieldName,
                        lookupRecordId)));
    }

    global Database.SaveResult updateObject(SObject recordToUpdate){
        if(recordToUpdate == null){
            throw new DMPLException();
        }
        // Map<String,Object> fields = recordToUpdate.getPopulatedFieldsAsMap();
        // SecurityHelper.ensureCanWriteFields(
        //     new List<String>(fields.keySet()), 
        //     recordToUpdate.getSObjectType().getDescribe().getName());
        
        return Database.update(recordToUpdate);
    }

    global Database.SaveResult[] updateObjects(List<SObject> recordsToUpdate){
        if(recordsToUpdate == null){
            throw new DMPLException();
        }
        if(recordsToUpdate.size() ==0){
            return null;
        }
        // Map<String,Object> fields = recordsToUpdate[0].getPopulatedFieldsAsMap();
        // SecurityHelper.ensureCanWriteFields(
        //     new List<String>(fields.keySet()), 
        //     recordsToUpdate[0].getSObjectType().getDescribe().getName());
        
        return Database.update(recordsToUpdate);
    }

    private string buildQuery(
        string objectType,
        string selectStatement, 
        string whereClause){
        return ' SELECT ' 
            + selectStatement 
            + ' FROM '
            + objectType 
            + ' WHERE '
            + whereClause;
    }

    private string getSelectStatement(
        String fieldName){
            List<String> fieldNames = new List<String>{ fieldName };
        if(!fieldNames.contains('Id')){
            fieldNames.add('Id');
        }
        if(!fieldNames.contains('Name')){
            fieldNames.add('Name');
        }
        return String.join(
                fieldNames, 
                ',');
    }

    private string getSelectStatement(
        List<String> fieldNames){
        if(!fieldNames.contains('Id')){
            fieldNames.add('Id');
        }
        if(!fieldNames.contains('Name')){
            fieldNames.add('Name');
        }
        return String.join(
                fieldNames, 
                ',');
    }

    private string getSelectStatement(
        List<String> fieldNames,
        String relationName,
        List<String> relatedFieldNames){
        if(!fieldNames.contains('Id')){
            fieldNames.add('Id');
        }
        if(!fieldNames.contains('Name')){
            fieldNames.add('Name');
        }
        fieldNames.add(
            '(SELECT ' 
            + getSelectStatement(relatedFieldNames)
            + ' FROM '
            + relationName + 
            ' )');
        return String.join(
                fieldNames, 
                ',');
    }

    private string getWhereClause(
        List<Id> recordIds){
        return ' Id IN :resolvedRecordIds';
    }

    private string getWhereClause(
        String lookupFieldName,
        List<Id> recordIds){
        return ' ' + lookupFieldName + ' IN :resolvedRecordIds';
    }

    private string getWhereClause(
        Id recordId){
        return ' Id = :resolvedRecordId';
    }
    
    private string getWhereClause(
        String lookupFieldName,
        Id recordId){
        return ' ' + lookupFieldName + ' = :resolvedRecordId';
    }
}