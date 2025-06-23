public with sharing class SchemeController {
    @AuraEnabled(cacheable = false)
    public static Boolean applyScheme(
        String objectApiName,
        Id recordId,
        Id schemeLineId,
        Id benefitId,
        Integer benefitIndex,
        List<SourceObjectInfo> selectedItemInfo){
        return SchemeEngine.applySchemeBenefit(
            getDocumentObject(
                String.escapeSingleQuotes(objectApiName), 
                recordId),
            schemeLineId,
            benefitId,
            benefitIndex,
            selectedItemInfo
        );
    }

    @AuraEnabled(cacheable = false)
    public static Boolean resetScheme(
        String objectApiName,
        Id recordId){
        return SchemeEngine.resetSchemeBenefit(
            getDocumentObject(
                String.escapeSingleQuotes(objectApiName), 
                recordId));
    }

    @AuraEnabled(cacheable = false)
    public static List<dmpl__SchemeLine__c> getQualifiedSchemeSlabs(
        String objectApiName,
        Id recordId){
        return SchemeEngine.getQualifiedSchemeLines(
            getDocumentObject(
                String.escapeSingleQuotes(objectApiName), 
                recordId)
        );
    }
    
    @AuraEnabled(cacheable = false)
    public static List<dmpl__ItemGroupMember__c> getQualifiedBenefits(
        Id benefitId,
        String searchKey,
        List<Id> itemGroupIds){
        if(String.isBlank(searchKey)){
            return [
                SELECT 
                    dmpl__ItemId__c,
                    dmpl__ItemId__r.Name,
                    dmpl__ItemId__r.dmpl__Description__c,
                    dmpl__ItemGroupId__c,
                    dmpl__ItemGroupId__r.Name
                FROM 
                    dmpl__ItemGroupMember__c
                WHERE 
                    dmpl__ItemGroupId__c IN :itemGroupIds
            ];
        }else{
            return [
                SELECT 
                    dmpl__ItemId__c,
                    dmpl__ItemId__r.Name,
                    dmpl__ItemId__r.dmpl__Description__c,
                    dmpl__ItemGroupId__c,
                    dmpl__ItemGroupId__r.Name
                FROM 
                    dmpl__ItemGroupMember__c
                WHERE 
                    dmpl__ItemGroupId__c IN :itemGroupIds
                    AND dmpl__ItemId__r.Name Like : '%'+searchKey+'%'
            ];
        }
    }

    @AuraEnabled(cacheable = true)
    public static List<dmpl__ServiceRecommendation__c> getRecommendations(Id recordId){
        return [
            SELECT 
                Id,
                Name
                // ,
                // IconName__c,
                // Recommendation__c
            FROM
                dmpl__ServiceRecommendation__c
            WHERE 
                dmpl__RepairOrderId__c =:recordId
        ];
    }

    @AuraEnabled(cacheable = true)
    public static List<AggregateResult> getSchemeLedgerEntries(String objectApiName, Id recordId){
        if(objectApiName == 'dmpl__SaleOrder__c'){
            return getSOSchemeLedgerEntries(recordId);
        } else if(objectApiName == 'dmpl__SaleInvoice__c'){
            return getSISchemeLedgerEntries(recordId);
        } else if(objectApiName == 'dmpl__PurchaseOrder__c'){
            return getPOSchemeLedgerEntries(recordId);
        } else if(objectApiName == 'dmpl__Bill__c'){
            return getBillSchemeLedgerEntries(recordId);
        } else if(objectApiName == 'dmpl__RepairOrder__c'){
            return getROSchemeLedgerEntries(recordId);
        }
        return null;
    }
    
    @AuraEnabled(cacheable = false)
    public static SchemeLine__c[] getSchemeLines(ID schemeId)
    {
        try 
        {
            SecurityHelper.ensureCanReadFields(new string[]
            {
                'dmpl__DefinitionFilterCriteria__c',
                'dmpl__DefinitionCustomLogic__c',
                'dmpl__RewardApplicability__c'
            }, 'dmpl__SchemeLine__c');
            SecurityHelper.ensureCanReadFields(new string[]
            {
                'dmpl__ConditionType__c',
                'dmpl__ConditionOperator__c',
                'dmpl__AccountId__c',
                'dmpl__AccountGroupId__c',
                'dmpl__ItemId__c',
                'dmpl__ItemGroupId__c',
                'dmpl__ConditionQuantity__c',
                'dmpl__ConditionValue__c',
                'dmpl__SequenceNumber__c'
            }, 'dmpl__SchemeCondition__c');
            SecurityHelper.ensureCanReadFields(new string[]
            {
                'dmpl__DiscountAmount__c',
                'dmpl__DiscountPercent__c',
                'dmpl__DiscountedItemId__c',
                'dmpl__DiscountedItemSKUId__c',
                'dmpl__DiscountedItemGroupId__c',
                'dmpl__DiscountedItemQuantity__c',
                'dmpl__RewardType__c',
                'dmpl__SequenceNumber__c'
            }, 'dmpl__SchemeBenefit__c');


            return [Select 
            Id,
            Name,
            dmpl__Title__c,
            dmpl__DefinitionFilterCriteria__c,
            dmpl__DefinitionCustomLogic__c,
            dmpl__RewardApplicability__c,
            dmpl__RewardCustomLogic__c,
            dmpl__SequenceNumber__c,
            dmpl__SchemeId__c,
            dmpl__SchemeId__r.Name,
            dmpl__SchemeId__r.dmpl__Status__c,
            (Select 
                Id,
                Name,
                dmpl__Title__c,
                dmpl__SchemeId__c,
                dmpl__SchemeLineId__c,
                dmpl__ConditionType__c,
                dmpl__ConditionOperator__c,
                dmpl__AccountId__c,
                dmpl__AccountId__r.Name,
                dmpl__AccountGroupId__c,
                dmpl__AccountGroupId__r.Name,
                dmpl__ItemId__c,
                dmpl__ItemId__r.Name,
                dmpl__ItemGroupId__c,
                dmpl__ItemGroupId__r.Name,
                dmpl__ConditionQuantity__c,
                dmpl__ConditionValue__c,
                dmpl__SequenceNumber__c
            FROM
                dmpl__SchemeConditions__r
                ORDER BY dmpl__SequenceNumber__c ASC),
            (Select 
                Id,
                Name,
                dmpl__Title__c,
                dmpl__SchemeId__c,
                dmpl__SchemeLineId__c,
                dmpl__DiscountAmount__c,
                dmpl__DiscountPercent__c,
                dmpl__DiscountedItemId__c,
                dmpl__DiscountedItemId__r.Name,
                dmpl__DiscountedItemSKUId__c,
                dmpl__DiscountedItemSKUId__r.Name,
                dmpl__DiscountedItemGroupId__c,
                dmpl__DiscountedItemGroupId__r.Name,
                dmpl__DiscountedItemQuantity__c,
                dmpl__RewardType__c,
                dmpl__SequenceNumber__c
            FROM
                dmpl__SchemeBenefits__r
                ORDER BY dmpl__SequenceNumber__c ASC)
            FROM 
                dmpl__SchemeLine__c 
            WHERE 
                dmpl__SchemeId__c = : schemeId
            ORDER BY dmpl__SequenceNumber__c ASC];
        } 
        catch (Exception e) 
        {
            throw new DMPLException(e.getMessage());
        }
    }
 
    @TestVisible
    private static List<AggregateResult> getSOSchemeLedgerEntries(Id recordId){
        return [SELECT 
                dmpl__SchemeLineId__r.dmpl__Title__c
            FROM
                dmpl__SchemeLedger__c
            WHERE 
                dmpl__SaleOrderId__c =:recordId
            GROUP BY
                dmpl__SchemeLineId__r.dmpl__Title__c];
    }

    @TestVisible
    private static List<AggregateResult> getSISchemeLedgerEntries(Id recordId){
        return [SELECT 
                dmpl__SchemeLineId__r.dmpl__Title__c
            FROM
                dmpl__SchemeLedger__c
            WHERE 
                dmpl__SaleInvoiceId__c =:recordId
            GROUP BY
                dmpl__SchemeLineId__r.dmpl__Title__c];
    }

	@TestVisible    
    private static List<AggregateResult> getPOSchemeLedgerEntries(Id recordId){
        return [SELECT 
                dmpl__SchemeLineId__r.dmpl__Title__c
            FROM
                dmpl__SchemeLedger__c
            WHERE 
                dmpl__PurchaseOrderId__c =:recordId
            GROUP BY
                dmpl__SchemeLineId__r.dmpl__Title__c];
    }

	@TestVisible    
    private static List<AggregateResult> getBillSchemeLedgerEntries(Id recordId){
        return [SELECT 
                dmpl__SchemeLineId__r.dmpl__Title__c
            FROM
                dmpl__SchemeLedger__c
            WHERE 
                dmpl__BillId__c =:recordId
            GROUP BY
                dmpl__SchemeLineId__r.dmpl__Title__c];
    }

    @TestVisible
    private static List<AggregateResult> getROSchemeLedgerEntries(Id recordId){
        return [SELECT 
                dmpl__SchemeLineId__r.dmpl__Title__c
            FROM
                dmpl__SchemeLedger__c
            WHERE 
                dmpl__RepairOrderId__c =:recordId
            GROUP BY
                dmpl__SchemeLineId__r.dmpl__Title__c];
    }

    @testVisible
    private static SObject getDocumentObject(
        String objectApiName,
        Id recordId){
        
            return Database.query(String.format('SELECT Id,dmpl__SkipScheme__c, Name,dmpl__TransactionType__c, {0}, dmpl__PartnerAccountId__c, dmpl__DocumentDate__c FROM {1} WHERE Id =:recordId',
                new String[]{
                    objectApiName == 'dmpl__PurchaseOrder__c' 
                        || objectApiName == 'dmpl__Bill__c' ? 'dmpl__SupplierAccountId__c' : 'dmpl__AccountId__c',
                    objectApiName
                }));
    }
}