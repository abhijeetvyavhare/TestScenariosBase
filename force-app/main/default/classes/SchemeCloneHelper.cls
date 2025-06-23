public class SchemeCloneHelper {
    
    private static final String FIELD_SCHEME_ID = 'id';
    private static final String FIELD_SCHEME_PERFORMCLONESCHEME = 'dmpl__PerformCloneScheme__c';
   
    public static void afterPostData(Boolean isInsert, Boolean isDelete,Boolean isUpdate,  List<dmpl__Scheme__c> newEntries, List<dmpl__Scheme__c> oldEntries)
    {
        if(isInsert)
        {
        }
        {
        }
    }


    public static void cloneScheme(
        List<dmpl__Scheme__c> oldEntries, 
        List<dmpl__Scheme__c> modifiedObjects)
    {
        try{
            list<dmpl__Scheme__c> scheme = new list<dmpl__Scheme__c>();
            list<dmpl__SchemeLine__c> schemeLine = new list<dmpl__SchemeLine__c>();
            list<dmpl__SchemeCondition__c> schemeCondition = new list<dmpl__SchemeCondition__c>();
            list<dmpl__SchemeBenefit__c> schemeBenefit = new list<dmpl__SchemeBenefit__c>();
            // list<dmpl__Scheme__c> modifiedObjects = documentHelper.getApprovedObjects(FIELD_SCHEME_PERFORMCLONESCHEME,oldEntries, newEntries);
            if(modifiedObjects.size()>0){
                List<Id> schemeIds = DocumentHelper.extractIds(modifiedObjects,FIELD_SCHEME_ID);
                Map<Id,dmpl__SchemeLine__c> schLine = getSchemeLines(schemeIds);
                for(dmpl__Scheme__c sch : modifiedObjects){
                    scheme.add(CloneScheme(sch));
                }
                insert scheme;
                for(dmpl__Scheme__c schemes: scheme){
                    schemeLine.addall(CloneSchemeLine(schLine.values(),schemes.id));
                }
                insert schemeLine;
                for(dmpl__SchemeLine__c schemeLines: schemeLine){
                    dmpl__SchemeLine__c parentSchemeLine = schLine.get(schemeLines.dmpl__ParentSchemeLine__c);
                    schemeCondition.addall(CloneSchemeCondition(parentSchemeLine.SchemeConditions__r,schemeLines.id));
                    schemeBenefit.addall(CloneSchemeBenefit(parentSchemeLine.SchemeBenefits__r,schemeLines.id));
                }
                insert schemeCondition;
                insert schemeBenefit;
                //
                updateExistingSchemes(modifiedObjects, new Map<Id, dmpl__Scheme__c>(oldEntries));
            }
        }
        catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    private static void updateExistingSchemes(List<dmpl__Scheme__c> schemes,  Map<Id, dmpl__Scheme__c> oldEnties)
    {
        for(dmpl__Scheme__c scheme : schemes)
        {
            dmpl__Scheme__c oldEntry = oldEnties.get(scheme.Id);
            scheme.Name = oldEntry.Name;
            scheme.dmpl__PerformCloneScheme__c = false;
        }
    }
    
    @testVisible
    private static dmpl__Scheme__c CloneScheme(dmpl__Scheme__c originalScheme){
        dmpl__Scheme__c clonedScheme = new dmpl__Scheme__c();
        clonedScheme.Name = originalScheme.Name;
        clonedScheme.dmpl__BranchId__c = originalScheme.dmpl__BranchId__c ;
        clonedScheme.dmpl__BusinessHoursId__c= originalScheme.dmpl__BusinessHoursId__c;
        clonedScheme.dmpl__IsClaimable__c= originalScheme.dmpl__IsClaimable__c;
        clonedScheme.dmpl__ClaimablePercentage__c= originalScheme.dmpl__ClaimablePercentage__c;
        clonedScheme.dmpl__MultipleFulfilmentTreatment__c= originalScheme.dmpl__MultipleFulfilmentTreatment__c;
        clonedScheme.dmpl__OriginalSchemeId__c= originalScheme.dmpl__OriginalSchemeId__c;
        clonedScheme.dmpl__PartnerAccountId__c = originalScheme.dmpl__PartnerAccountId__c;
        clonedScheme.dmpl__PartnerAccountGroupId__c= originalScheme.dmpl__PartnerAccountGroupId__c;
        clonedScheme.dmpl__PeriodType__c= originalScheme.dmpl__PeriodType__c;
        clonedScheme.dmpl__SchemeQuota__c= originalScheme.dmpl__SchemeQuota__c;
        clonedScheme.dmpl__SchemeType__c= originalScheme.dmpl__SchemeType__c;
        clonedScheme.dmpl__Status__c= originalScheme.dmpl__Status__c;
        clonedScheme.dmpl__SupplierAccountId__c = originalScheme.dmpl__SupplierAccountId__c;
        clonedScheme.dmpl__ValidFrom__c= originalScheme.dmpl__ValidFrom__c;
        clonedScheme.dmpl__ValidTo__c= originalScheme.dmpl__ValidTo__c;
        clonedScheme.dmpl__ReferenceSchemeId__c= originalScheme.Id;
        // clonedScheme.dmpl__PerformCloneScheme__c= originalScheme.dmpl__PerformCloneScheme__c;
        
        return  clonedScheme;
    }
    
    @testVisible
    private static list<dmpl__SchemeLine__c> CloneSchemeLine(list<dmpl__SchemeLine__c> originalSchemeLine, Id schemeId){
        list<dmpl__SchemeLine__c> clonedSchemeLine = new list<dmpl__SchemeLine__c>();
        for (dmpl__SchemeLine__c lineEntry : originalSchemeLine){
            dmpl__SchemeLine__c record = new dmpl__SchemeLine__c();
            record.dmpl__DefinitionFilterCriteria__c = lineEntry.dmpl__DefinitionFilterCriteria__c;
            record.dmpl__DefinitionCustomLogic__c = lineEntry.dmpl__DefinitionCustomLogic__c;
            record.dmpl__RewardApplicability__c = lineEntry.dmpl__RewardApplicability__c;
            record.dmpl__RewardAccountGroup__c = lineEntry.dmpl__RewardAccountGroup__c;
            record.dmpl__RewardCustomLogic__c = lineEntry.dmpl__RewardCustomLogic__c;
            record.dmpl__SchemeId__c = schemeId;
            record.dmpl__SequenceNumber__c = lineEntry.dmpl__SequenceNumber__c;
            record.dmpl__ParentSchemeLine__c = lineEntry.id;
            clonedSchemeLine.add(record);
        }
        return clonedSchemeLine;
    }
    
    @testVisible
    private static list<dmpl__SchemeCondition__c> CloneSchemeCondition(list<dmpl__SchemeCondition__c> originalSchemeCondition, Id schemeLineId){
        list<dmpl__SchemeCondition__c> clonedSchemeCondition = new list<dmpl__SchemeCondition__c>();
        for (dmpl__SchemeCondition__c lineEntry : originalSchemeCondition){
            dmpl__SchemeCondition__c record = new dmpl__SchemeCondition__c();
            record.dmpl__AccountId__c = lineEntry.dmpl__AccountId__c;
            record.dmpl__AccountGroupId__c = lineEntry.dmpl__AccountGroupId__c;
            record.dmpl__ConditionOperator__c = lineEntry.dmpl__ConditionOperator__c;
            record.dmpl__ConditionQuantity__c = lineEntry.dmpl__ConditionQuantity__c;
            record.dmpl__ConditionType__c = lineEntry.dmpl__ConditionType__c;
            record.dmpl__SchemeLineId__c = schemeLineId;
            record.dmpl__ConditionValue__c = lineEntry.dmpl__ConditionValue__c;
            record.dmpl__ItemGroupId__c = lineEntry.dmpl__ItemGroupId__c;
            record.dmpl__PartnerAccountId__c = lineEntry.dmpl__PartnerAccountId__c;
            record.dmpl__RewardGroup__c = lineEntry.dmpl__RewardGroup__c;
            record.dmpl__SchemeId__c = lineEntry.dmpl__SchemeId__c;
            record.dmpl__SequenceNumber__c = lineEntry.dmpl__SequenceNumber__c;
            record.dmpl__ItemSKUId__c = lineEntry.dmpl__ItemSKUId__c;
            record.dmpl__ItemId__c = lineEntry.dmpl__ItemId__c;
            clonedSchemeCondition.add(record);
        }
        return clonedSchemeCondition;
    }
    
    @testVisible
    private static list<dmpl__SchemeBenefit__c> CloneSchemeBenefit(list<dmpl__SchemeBenefit__c> originalSchemeBenefit, Id schemeLineId){
        list<dmpl__SchemeBenefit__c> clonedSchemeBenefit = new list<dmpl__SchemeBenefit__c>();
        for (dmpl__SchemeBenefit__c lineEntry : originalSchemeBenefit){
            dmpl__SchemeBenefit__c record = new dmpl__SchemeBenefit__c();
            record.dmpl__DiscountAmount__c = lineEntry.dmpl__DiscountAmount__c;
            record.dmpl__DiscountPercent__c = lineEntry.dmpl__DiscountPercent__c;
            record.dmpl__DiscountedItemId__c = lineEntry.dmpl__DiscountedItemId__c;
            record.dmpl__DiscountedItemGroupId__c = lineEntry.dmpl__DiscountedItemGroupId__c;
            record.dmpl__DiscountedItemQuantity__c = lineEntry.dmpl__DiscountedItemQuantity__c;
            record.dmpl__SchemeLineId__c = schemeLineId;
            record.dmpl__DiscountedItemRanking__c = lineEntry.dmpl__DiscountedItemRanking__c;
            record.dmpl__DiscountedItemSKUId__c = lineEntry.dmpl__DiscountedItemSKUId__c;
            record.dmpl__ExcludeQualifyingItems__c = lineEntry.dmpl__ExcludeQualifyingItems__c;
            record.dmpl__RecommendationText__c = lineEntry.dmpl__RecommendationText__c;
            record.dmpl__RepeatReward__c = lineEntry.dmpl__RepeatReward__c;
            record.dmpl__RewardPoints__c = lineEntry.dmpl__RewardPoints__c;
            record.dmpl__RewardType__c = lineEntry.dmpl__RewardType__c;
            record.dmpl__SchemeId__c = lineEntry.dmpl__SchemeId__c;
            record.dmpl__SequenceNumber__c = lineEntry.dmpl__SequenceNumber__c;
            clonedSchemeBenefit.add(record);
        }
        return clonedSchemeBenefit;
    }
    
    @testVisible
    private static Map<Id, dmpl__SchemeLine__c> getSchemeLines(list<Id>schemeIds)
    {
        return new Map<Id, dmpl__SchemeLine__c>([SELECT
                                                 Id,
                                                 Name,
                                                 dmpl__DefinitionFilterCriteria__c,
                                                 dmpl__DefinitionCustomLogic__c,
                                                 dmpl__RewardApplicability__c,
                                                 dmpl__RewardAccountGroup__c,
                                                 dmpl__RewardCustomLogic__c,
                                                 dmpl__SchemeId__c,
                                                 dmpl__SequenceNumber__c,
                                                 (
                                                     SELECT 
                                                     Id,
                                                     Name,
                                                     dmpl__AccountId__c,
                                                     dmpl__AccountGroupId__c,
                                                     dmpl__ConditionOperator__c,
                                                     dmpl__ConditionQuantity__c,
                                                     dmpl__ConditionType__c,
                                                     dmpl__ConditionValue__c,
                                                     dmpl__ItemGroupId__c,
                                                     dmpl__PartnerAccountId__c,
                                                     dmpl__RewardGroup__c,
                                                     dmpl__SchemeId__c,
                                                     dmpl__SchemeLineId__c,
                                                     dmpl__SequenceNumber__c,
                                                     dmpl__ItemSKUId__c,
                                                     dmpl__ItemId__c
                                                     FROM 
                                                     SchemeConditions__r),
                                                 (
                                                     SELECT 
                                                     Id,
                                                     Name,
                                                     dmpl__DiscountAmount__c,
                                                     dmpl__DiscountPercent__c,
                                                     dmpl__DiscountedItemId__c,
                                                     dmpl__DiscountedItemGroupId__c,
                                                     dmpl__DiscountedItemQuantity__c,
                                                     dmpl__DiscountedItemRanking__c,
                                                     dmpl__DiscountedItemSKUId__c,
                                                     dmpl__ExcludeQualifyingItems__c,
                                                     dmpl__RepeatReward__c,
                                                     dmpl__RewardPoints__c,
                                                     dmpl__RewardType__c,
                                                     dmpl__SchemeId__c,
                                                     dmpl__SchemeLineId__c,
                                                     dmpl__RecommendationText__c,
                                                     dmpl__SequenceNumber__c
                                                     FROM 
                                                     SchemeBenefits__r)
                                                 FROM 
                                                 dmpl__SchemeLine__c
                                                 WHERE dmpl__SchemeId__c IN: schemeIds ]);
    }
    
    public static void deepClone(  List<dmpl__Scheme__c> newTrigger ) {
    List<dmpl__Scheme__c> schemesToClone = new List<dmpl__Scheme__c>();
    for (dmpl__Scheme__c scheme : newTrigger) {
        if (scheme.dmpl__PerformCloneScheme__c ) {
            schemesToClone.add(scheme);
        }
    }
   
    if (!schemesToClone.isEmpty()) {
        List<dmpl__Scheme__c> clonedSchemes = new List<dmpl__Scheme__c>();
        for (dmpl__Scheme__c schemeToClone : schemesToClone) {
            dmpl__Scheme__c clonedScheme = schemeToClone.clone(false, true, false, false);
            clonedScheme.Name += ' Cloned';
            clonedScheme.dmpl__PerformCloneScheme__c = false;
            clonedSchemes.add(clonedScheme);
        }
        insert clonedSchemes;
    }
}
    
    public static void deepCloneCheck(List<dmpl__Scheme__c> newTrigger){
 Set<Id> schemeIdsToClone = new Set<Id>();
    for (dmpl__Scheme__c scheme : newTrigger) {
        if (scheme.dmpl__PerformCloneScheme__c) {
            schemeIdsToClone.add(scheme.Id);
        }
    }
   
    Map<Id, dmpl__Scheme__c> clonedSchemes = new Map<Id, dmpl__Scheme__c>();
    for (dmpl__Scheme__c schemeToClone : [SELECT Id, Name,dmpl__PeriodType__c,dmpl__SchemeType__c
                                          FROM dmpl__Scheme__c
                                          WHERE Id IN :schemeIdsToClone]) {
        dmpl__Scheme__c clonedScheme = schemeToClone.clone(false, true, false, false);
        clonedScheme.Name += ' Cloned';
        clonedSchemes.put(schemeToClone.Id, clonedScheme);
    }
    insert clonedSchemes.values();

    List<dmpl__SchemeLine__c> schemesToClone = [SELECT Id, Name, dmpl__DefinitionFilterCriteria__c, dmpl__DefinitionCustomLogic__c, dmpl__RewardApplicability__c, dmpl__RewardAccountGroup__c, dmpl__RewardCustomLogic__c, dmpl__SchemeId__c, dmpl__SequenceNumber__c,
                                                      (SELECT Id, Name, dmpl__AccountId__c, dmpl__AccountGroupId__c, dmpl__ConditionOperator__c, dmpl__ConditionQuantity__c, dmpl__ConditionType__c, dmpl__ConditionValue__c, dmpl__ItemGroupId__c, dmpl__PartnerAccountId__c, dmpl__RewardGroup__c, dmpl__SchemeId__c, dmpl__SchemeLineId__c, dmpl__SequenceNumber__c, dmpl__ItemSKUId__c, dmpl__ItemId__c FROM SchemeConditions__r),
                                                      (SELECT Id, Name, dmpl__DiscountAmount__c, dmpl__DiscountPercent__c, dmpl__DiscountedItemId__c, dmpl__DiscountedItemGroupId__c, dmpl__DiscountedItemQuantity__c, dmpl__DiscountedItemRanking__c, dmpl__DiscountedItemSKUId__c, dmpl__ExcludeQualifyingItems__c, dmpl__RepeatReward__c, dmpl__RewardPoints__c, dmpl__RewardType__c, dmpl__SchemeId__c, dmpl__SchemeLineId__c, dmpl__RecommendationText__c, dmpl__SequenceNumber__c FROM SchemeBenefits__r)
                                               FROM dmpl__SchemeLine__c
                                               WHERE dmpl__SchemeId__c IN :schemeIdsToClone];
    List<dmpl__SchemeLine__c> clonedSchemeLines = new List<dmpl__SchemeLine__c>();
    List<dmpl__SchemeCondition__c> clonedSchemeConditions = new List<dmpl__SchemeCondition__c>();
    List<dmpl__SchemeBenefit__c> clonedSchemeBenefits = new List<dmpl__SchemeBenefit__c>();
   
    for (dmpl__SchemeLine__c schemeLine : schemesToClone) {
        dmpl__Scheme__c clonedScheme = clonedSchemes.get(schemeLine.dmpl__SchemeId__c);
        dmpl__SchemeLine__c clonedSchemeLine = schemeLine.clone(false, true, false, false);
        clonedSchemeLine.dmpl__SchemeId__c = clonedScheme.Id;
        clonedSchemeLines.add(clonedSchemeLine);
       
        for (dmpl__SchemeCondition__c condition : schemeLine.SchemeConditions__r) {
            dmpl__SchemeCondition__c clonedCondition = condition.clone(false, true, false, false);
            clonedCondition.dmpl__SchemeId__c = clonedScheme.Id;
            clonedCondition.dmpl__SchemeLineId__c = clonedSchemeLine.Id;
            clonedSchemeConditions.add(clonedCondition);
        }
       
        for (dmpl__SchemeBenefit__c benefit : schemeLine.SchemeBenefits__r) {
            dmpl__SchemeBenefit__c clonedBenefit = benefit.clone(false, true, false, false);
            clonedBenefit.dmpl__SchemeId__c = clonedScheme.Id;
            clonedBenefit.dmpl__SchemeLineId__c = clonedSchemeLine.Id;
            clonedSchemeBenefits.add(clonedBenefit);
        }
    }
    insert clonedSchemeLines;
insert clonedSchemeConditions;
insert clonedSchemeBenefits;
}

}