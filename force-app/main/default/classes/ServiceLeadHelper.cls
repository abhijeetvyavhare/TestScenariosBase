public with sharing class ServiceLeadHelper {

    private static Boolean skipValidations = false;
    private static final string OBJECT_SERVICELEAD = 'dmpl__ServiceLead__c';
    private static final string FIELD_SERVICELEAD_STATUS = 'dmpl__Status__c';
    private static final string FIELD_SERVICELEAD_PARTNERACCOUNTID = 'dmpl__PartnerAccountId__c';
    private static final string FIELD_SERVICELEAD_BRANCHID = 'dmpl__BranchId__c';
    private static final string FIELD_SERVICELEAD_RESOURCEID = 'dmpl__ResourceId__c';

    public static void validateData(
        Boolean isInsert, 
        Boolean isUpdate, 
        Boolean isDelete, 
        List<dmpl__ServiceLead__c> newEntries,
        List<dmpl__ServiceLead__c> oldEntries)
    {
        try {
            if(isInsert){
                FieldMappingHelper.copyFieldMappingData(
                    newEntries);
            }
            if(skipValidations){
                return;
            }
            DocumentStatusDFSHelper dfsHelper = new DocumentStatusDFSHelper();
            if(isInsert){
                ValidationHelper.validatePartnerAndBranch(
                    FIELD_SERVICELEAD_PARTNERACCOUNTID, 
                    FIELD_SERVICELEAD_BRANCHID, 
                    newEntries);
                ValidationHelper.validateResource(
                    FIELD_SERVICELEAD_RESOURCEID, 
                    newEntries);
            }else if(isUpdate){
                dfsHelper.DocumentStatusRestrictEdits_Edit(
                    OBJECT_SERVICELEAD, 
                    FIELD_SERVICELEAD_STATUS, 
                    oldEntries, 
                    newEntries);
                dfsHelper.DocumentStatusRestrictFieldsEdits(
                    OBJECT_SERVICELEAD, 
                    FIELD_SERVICELEAD_STATUS, 
                    oldEntries, 
                    newEntries);
                ValidationHelper.validatePartnerAndBranch(
                    FIELD_SERVICELEAD_PARTNERACCOUNTID, 
                    FIELD_SERVICELEAD_BRANCHID, 
                    newEntries);
                ValidationHelper.validateResource(
                    FIELD_SERVICELEAD_RESOURCEID, 
                    newEntries);
            }else if(isDelete){
                dfsHelper.DocumentStatusRestrictEdits_Delete(
                    OBJECT_SERVICELEAD, 
                    FIELD_SERVICELEAD_STATUS, 
                    oldEntries);
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void postData(
        Boolean isInsert,  
        Boolean isUpdate, 
        Boolean isDelete, 
        List<dmpl__ServiceLead__c> newEntries,
        List<dmpl__ServiceLead__c> oldEntries 
        )
    { 
        try {
            DocumentStatusDFSHelper dfsHelper = new DocumentStatusDFSHelper();
            if(isInsert){
                assignResource(newEntries);
                dfsHelper.DocumentStatusSetFlag(
                    OBJECT_SERVICELEAD, 
                    FIELD_SERVICELEAD_STATUS, 
                    newEntries);
                dfsHelper.DocumentStatusReSetFlag(
                    OBJECT_SERVICELEAD, 
                    FIELD_SERVICELEAD_STATUS, 
                    newEntries);
                DocumentNameHelper.generateDocumentName(newEntries);
            }else if(isUpdate){
                dfsHelper.DocumentStatusSetFlag(
                    OBJECT_SERVICELEAD, 
                    FIELD_SERVICELEAD_STATUS, 
                    oldEntries, 
                    newEntries);
                dfsHelper.DocumentStatusReSetFlag(
                    OBJECT_SERVICELEAD, 
                    FIELD_SERVICELEAD_STATUS, 
                    oldEntries, 
                    newEntries); 
            } 
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void afterPostData(
        Boolean isInsert,
        Boolean isUpdate, 
        Boolean isDelete, 
        List<dmpl__ServiceLead__c> newEntries,
        List<dmpl__ServiceLead__c> oldEntries)
    {
        if(isUpdate)
        {
        }
    }

    public static void createLeadFromCase(List<dmpl__Case__c> caseEnties){
        List<dmpl__ServiceLead__c> newEntries = new List<dmpl__ServiceLead__c>();
        for(dmpl__Case__c caseEntry : caseEnties){
            newEntries.add(
                createLeadFromCase(caseEntry));
        }
        if(newEntries.size()>0){
            SecurityHelper.ensureCanCreateObject('dmpl__ServiceLead__c');
            SecurityHelper.ensureCanCreateFields(new string[]{
                'dmpl__AccountId__c',
                'dmpl__AccountName__c',
                'dmpl__AssetId__c',
                'dmpl__BranchId__c',
                'dmpl__CaseId__c',
                'dmpl__ContactId__c',
                'dmpl__ContactName__c',
                'dmpl__ContactNumber__c',
                'dmpl__Mobile__c',
                'dmpl__PartnerAccountId__c',
                'dmpl__AccountPhone__c'
            }, 'dmpl__ServiceLead__c');
    
            Insert newEntries;
        }
    }

    public static dmpl__ServiceLead__c convertLead(Object data){
        System.debug(JSON.serializePretty(data));
        Map<Object,Object> dataMap = (Map<Object,Object>) data;
        List<Object> accountFields = (List<Object>)dataMap.get('accountFields');
        List<Object> contactFields = (List<Object>)dataMap.get('contactFields');
        List<Object> srFields = (List<Object>)dataMap.get('serviceRequestFields');
        List<Object> leadFields = (List<Object>)dataMap.get('leadFields');
        
        Boolean createNewAccount = Boolean.valueOf(dataMap.get('createNewAccount'));
        Boolean createNewContact = Boolean.valueOf(dataMap.get('createNewContact'));
        Boolean createNewServiceRequest = Boolean.valueOf(dataMap.get('createNewServiceRequest'));
        Id leadId = String.valueOf(dataMap.get('leadId'));

        Account account;
        Contact contact;
        dmpl__ServiceRequest__c request;
        dmpl__ServiceLead__c lead = queryLead(leadFields, leadId);
        if(lead == null){
            throw new DMPLException('Lead not found.');
        }
        
        if(createNewAccount){
            account = createNewAccount(accountFields);
        }
        
        if(createNewContact){
            contact = createNewContact(
                contactFields,
                account == null ? lead.dmpl__AccountId__c : account.Id);
        }

        if(createNewServiceRequest){
            request = createNewServiceRequest(
                srFields,
                leadFields,
                lead,
                account == null ? lead.dmpl__AccountId__c : account.Id,
                contact == null ? lead.dmpl__ContactId__c : contact.Id);
        }
        
        return updateLead(
            leadFields,
            lead,
            request !=null ?request.Id:null,
            account,
            contact);
    }

    private static dmpl__ServiceLead__c createLeadFromCase(dmpl__Case__c caseEntry){
        return new dmpl__ServiceLead__c(
            dmpl__AccountId__c = caseEntry.dmpl__AccountId__c,
            dmpl__AccountName__c = caseEntry.dmpl__AccountName__c,
            dmpl__AssetId__c = caseEntry.dmpl__AssetId__c,
            dmpl__BranchId__c = caseEntry.dmpl__BranchId__c,
            dmpl__CaseId__c = caseEntry.Id,
            dmpl__ContactId__c = caseEntry.dmpl__ContactId__c,
            dmpl__ContactName__c = caseEntry.dmpl__ContactName__c,
            dmpl__ContactNumber__c = caseEntry.dmpl__ContactNumber__c,
            dmpl__Mobile__c = caseEntry.dmpl__Mobile__c,
            dmpl__PartnerAccountId__c = caseEntry.dmpl__PartnerAccountId__c,
            dmpl__AccountPhone__c = caseEntry.dmpl__AccountPhone__c
        );
    }

    private static Account createNewAccount(List<Object> accountFields){
        SObject account = new Account();
        for(Object nvPair : accountFields){
            Map<Object,Object> nvPairMap = (Map<Object,Object>)nvPair;
            account.put((String)nvPairMap.get('fieldName'), nvPairMap.get('fieldValue'));
        }
        insert account;
        return (Account)account;
    }

    @testVisible
    private static Contact createNewContact(
        List<Object> contactFields,
        Id accountId){
        SObject contact = new Contact(
            AccountId = accountId
        );
        for(Object nvPair : contactFields){
            Map<Object,Object> nvPairMap = (Map<Object,Object>)nvPair;
            contact.put((String)nvPairMap.get('fieldName'), nvPairMap.get('fieldValue'));
        }
        insert contact;
        return (Contact)contact;
    }
    
    private static dmpl__ServiceRequest__c createNewServiceRequest(
        List<Object> srFields,
        List<Object> leadFields,
        dmpl__ServiceLead__c lead,
        Id accountId,
        Id contactId){
        dmpl__ServiceRequest__c request = new dmpl__ServiceRequest__c(
            dmpl__AccountId__c = accountId,
            dmpl__ContactId__c = contactId,
            dmpl__PartnerAccountId__c = lead.dmpl__PartnerAccountId__c,
            dmpl__BranchId__c = lead.dmpl__BranchId__c,
            dmpl__ServiceLeadId__c = lead.Id
        );
        for(Object nvPair : srFields){
            Map<Object,Object> nvPairMap = (Map<Object,Object>)nvPair;
            request.put((String)nvPairMap.get('fieldName'), nvPairMap.get('fieldValue'));
        }

        insert request;
        return (dmpl__ServiceRequest__c)request;
    }

    private static dmpl__ServiceLead__c queryLead(
        List<Object> leadFields,
        Id leadId){
        List<String> fielNames = new List<String>{
            'Id', 
            'Name', 
            'dmpl__PartnerAccountId__c', 
            'dmpl__BranchId__c', 
            'dmpl__AccountId__c', 
            'dmpl__ContactId__c'};
        for(Object nvPair : leadFields){
            Map<Object,Object> nvPairMap = (Map<Object,Object>)nvPair;
            if((String)nvPairMap.get('fieldName') != 'Id' 
                && (String)nvPairMap.get('fieldName') != 'Name'){
                    if(!fielNames.contains((String)nvPairMap.get('fieldName'))){
                        fielNames.add((String)nvPairMap.get('fieldName'));
                    }
                }
        }
        String query = 'SELECT ' + String.join(fielNames, ',') + ' FROM dmpl__ServiceLead__c WHERE Id=:leadId';
        System.debug(query);
        List<SObject> leads = Database.query(query);
        if(leads.size()>0){
            return (dmpl__ServiceLead__c)leads[0];
        }
        return null;
    }

    private static dmpl__ServiceLead__c updateLead(
        List<Object> leadFields,
        dmpl__ServiceLead__c lead,
        Id requestId,
        Account account,
        Contact contact){
        for(Object nvPair : leadFields){
            Map<Object,Object> nvPairMap = (Map<Object,Object>)nvPair;
            lead.put((String)nvPairMap.get('fieldName'), nvPairMap.get('fieldValue'));
        }
        if(requestId!=null){
            lead.dmpl__ServiceRequestId__c = requestId;
        }
        if(account!=null){
            lead.dmpl__AccountId__c = account.Id;
        }
        if(contact!=null){
            lead.dmpl__ContactId__c = contact.Id;
        }
        update lead;
        return lead;
    }
    
    private static void assignResource(
        List<ServiceLead__c> newEntries){
        List<dmpl__PartnerResource__c> resources = queryPartnerResource(
            CollectionHelper.extractIds(
                newEntries, 
                'dmpl__PartnerAccountId__c'),
            CollectionHelper.extractIds(
                newEntries, 
                'dmpl__BranchId__c'));
        for(ServiceLead__c lead : newEntries){
            List<dmpl__PartnerResource__c> applicableResources = getApplicablePartnerResources(
                resources,
                lead.dmpl__PartnerAccountId__c,
                lead.dmpl__BranchId__c);
                for(dmpl__PartnerResource__c resource : applicableResources){
                    if(resource.dmpl__RuleSuccessCriteria__c == null 
                        || resource.dmpl__RuleSuccessCriteria__c == 'All Rules Are Met'){
                        if(isAllRuleMet(
                            lead, 
                            resource)){
                                lead.dmpl__ResourceId__c = resource.dmpl__ResourceId__c;
                                break;
                        }
                    }else if(resource.dmpl__RuleSuccessCriteria__c == 'Any Rule Is Met'){
                        if(isAnyRuleMet(
                            lead, 
                            resource)){
                                lead.dmpl__ResourceId__c = resource.dmpl__ResourceId__c;
                                break;
                        }
                    }else if(resource.dmpl__RuleSuccessCriteria__c == 'Always (No Criteria)'){
                        lead.dmpl__ResourceId__c = resource.dmpl__ResourceId__c;
                        break;
                    }
                }
        }

    }

    private static Boolean isAllRuleMet(ServiceLead__c lead, dmpl__PartnerResource__c resource){
        if(resource.dmpl__ResourceAssignmentRules__r.size() == 0){
            return false;
        }
        Map<String, Schema.SObjectField> fieldMap = lead.getSObjectType().getDescribe().fields.getMap();
        for (dmpl__ResourceAssignmentRule__c rule :resource.dmpl__ResourceAssignmentRules__r){
            if(!evaluateRule(
                fieldMap.get(rule.dmpl__FieldName__c),
                lead,
                rule)){
                return false;
            }
        }
        return true;
    }

    private static Boolean isAnyRuleMet(ServiceLead__c lead, dmpl__PartnerResource__c resource){
        if(resource.dmpl__ResourceAssignmentRules__r.size() == 0){
            return false;
        }
        Map<String, Schema.SObjectField> fieldMap = lead.getSObjectType().getDescribe().fields.getMap();
        for (dmpl__ResourceAssignmentRule__c rule :resource.dmpl__ResourceAssignmentRules__r){
            if(evaluateRule(
                fieldMap.get(rule.dmpl__FieldName__c),
                lead,
                rule)){
                return true;
            }
        }
        return false;
    }

    private static Boolean evaluateRule(
        Schema.SObjectField field,
        ServiceLead__c lead, 
        dmpl__ResourceAssignmentRule__c rule){
        if(field == null){
            return false;
        }
        Schema.DisplayType dataType = field.getDescribe().getType();
        if(dataType == Schema.DisplayType.Double 
            || dataType == Schema.DisplayType.INTEGER 
            || dataType == Schema.DisplayType.LONG){
                return evaluateNumnericValues(
                    dataType, 
                    rule.dmpl__Operation__c, 
                    lead.get(rule.dmpl__FieldName__c), 
                    rule.dmpl__FieldValue__c);
        }else if(dataType == Schema.DisplayType.DATE 
            || dataType == Schema.DisplayType.DATETIME){
                return evaluateDateTimeValues(
                    dataType, 
                    rule.dmpl__Operation__c, 
                    lead.get(rule.dmpl__FieldName__c), 
                    rule.dmpl__FieldValue__c);
        }else{
            if(rule.dmpl__Operation__c == 'equals'){
                return lead.get(rule.dmpl__FieldName__c) == rule.dmpl__FieldValue__c;
            } else if(rule.dmpl__Operation__c == 'notEqual'){
                return lead.get(rule.dmpl__FieldName__c) != rule.dmpl__FieldValue__c;
            }    
        }
        return false;
    }

    public static Boolean evaluateNumnericValues(
        Schema.DisplayType dataType,
        String operator,
        object value1,
        object value2){
        
        if(dataType == Schema.DisplayType.Double){
            Double dblValue1 = (Double)value1;
            Double dblValue2 = Double.valueOf(value2);
            if(operator == 'equals'){
                return dblValue1 == dblValue2;
            } else if(operator == 'notEqual'){
                return dblValue1 != dblValue2;
            }else if(operator == 'lessThan'){
                return dblValue1 < dblValue2;
            }else if(operator == 'greaterThan'){
                return dblValue1 > dblValue2;
            }else if(operator == 'lessOrEqual'){
                return dblValue1 <= dblValue2;
            }else if(operator == 'greaterOrEqual'){
                return dblValue1 >= dblValue2;
            }
        }else if(dataType == Schema.DisplayType.LONG){
            Long longValue1 = (Long)value1;
            Long longValue2 = Long.valueOf((String)value2);
            if(operator == 'equals'){
                return longValue1 == longValue2;
            } else if(operator == 'notEqual'){
                return longValue1 != longValue2;
            }else if(operator == 'lessThan'){
                return longValue1 < longValue2;
            }else if(operator == 'greaterThan'){
                return longValue1 > longValue2;
            }else if(operator == 'lessOrEqual'){
                return longValue1 <= longValue2;
            }else if(operator == 'greaterOrEqual'){
                return longValue1 >= longValue2;
            }
        }else if(dataType == Schema.DisplayType.INTEGER){
            Long intValue1 = (Integer)value1;
            Long intValue2 = Integer.valueOf(value2);
            if(operator == 'equals'){
                return intValue1 == intValue2;
            } else if(operator == 'notEqual'){
                return intValue1 != intValue2;
            }else if(operator == 'lessThan'){
                return intValue1 < intValue2;
            }else if(operator == 'greaterThan'){
                return intValue1 > intValue2;
            }else if(operator == 'lessOrEqual'){
                return intValue1 <= intValue2;
            }else if(operator == 'greaterOrEqual'){
                return intValue1 >= intValue2;
            }
        }
        return false;
    }

    public static Boolean evaluateDateTimeValues(
        Schema.DisplayType dataType,
        String operator,
        object value1,
        object value2){
        
        if(dataType == Schema.DisplayType.DATE){
            Date dValue1 = (Date)value1;
            Date dValue2 = Date.valueOf((String)value2);
            if(operator == 'equals'){
                return dValue1 == dValue2;
            } else if(operator == 'notEqual'){
                return dValue1 != dValue2;
            }else if(operator == 'lessThan'){
                return dValue1 < dValue2;
            }else if(operator == 'greaterThan'){
                return dValue1 > dValue2;
            }else if(operator == 'lessOrEqual'){
                return dValue1 <= dValue2;
            }else if(operator == 'greaterOrEqual'){
                return dValue1 >= dValue2;
            }
        }else if(dataType == Schema.DisplayType.DATETIME){
            Datetime dtValue1 = (Datetime)value1;
            Datetime dtValue2 = Datetime.valueOf((String)value2);
            if(operator == 'equals'){
                return dtValue1 == dtValue2;
            } else if(operator == 'notEqual'){
                return dtValue1 != dtValue2;
            }else if(operator == 'lessThan'){
                return dtValue1 < dtValue2;
            }else if(operator == 'greaterThan'){
                return dtValue1 > dtValue2;
            }else if(operator == 'lessOrEqual'){
                return dtValue1 <= dtValue2;
            }else if(operator == 'greaterOrEqual'){
                return dtValue1 >= dtValue2;
            }
        }
        return false;
    }

    public static List<dmpl__PartnerResource__c> getApplicablePartnerResources(
        List<dmpl__PartnerResource__c> resources,
        Id partnerAccountId,
        Id branchId){
            List<dmpl__PartnerResource__c> applicableResources = new List<dmpl__PartnerResource__c>();
            for (dmpl__PartnerResource__c partnerResource : resources){
                if(partnerResource.dmpl__PartnerAccountId__c == partnerAccountId 
                    && (partnerResource.dmpl__BranchId__c == null
                        || partnerResource.dmpl__BranchId__c == branchId))
                {
                    applicableResources.add(partnerResource); 
                }
            }
            return applicableResources;
        }

    public static List<dmpl__PartnerResource__c> queryPartnerResource(
        List<ID> partnerAccountIds,
        List<ID> branchAccountIds){
            return [SELECT 
                ID,
                dmpl__AssignmentSequenceNumber__c,
                dmpl__PartnerAccountId__c,
                dmpl__ResourceId__c,
                dmpl__BranchId__c,
                dmpl__RuleSuccessCriteria__c,
                (
                    SELECT 
                    ID,
                    dmpl__FieldName__c,
                    dmpl__FieldValue__c,
                    dmpl__Operation__c
                    FROM dmpl__ResourceAssignmentRules__r
                )
            FROM dmpl__PartnerResource__c
            WHERE (dmpl__PartnerAccountId__c IN :partnerAccountIds 
                    AND dmpl__BranchId__c = null)  
                OR dmpl__BranchId__c IN :branchAccountIds
            ORDER BY dmpl__AssignmentSequenceNumber__c];
    } 

}