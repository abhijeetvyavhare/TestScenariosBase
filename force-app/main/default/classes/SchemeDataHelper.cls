public with sharing class SchemeDataHelper {
   public static dmpl__Scheme__c createScheme(
        String schemeName,
        String application,
        String status,
        String schemeType,
        String periodType,
        Date validFrom,
        Date validTo,
        Integer validCount,
        String multipleFulfilmentTreatment,
        Integer sequenceNumber,
        Boolean ignoreBudget,
        Id partnerAccountId,
        Id partnerAccountGroupId,
        Id accountGroupId,
        Id accountId,
        Id branchId,
        Decimal schemeBudget
    ) {
        return (dmpl__Scheme__c) TestFactory.createSObject(
            new dmpl__Scheme__c(
                Name = schemeName,
                dmpl__Application__c = application,
                dmpl__Status__c = status,
                dmpl__SchemeType__c = schemeType,
                dmpl__PeriodType__c = periodType,
                dmpl__ValidFrom__c = validFrom,
                dmpl__ValidTo__c = validTo,
                dmpl__ValidCount__c = validCount,
                dmpl__MultipleFulfilmentTreatment__c = multipleFulfilmentTreatment,
                dmpl__SequenceNumber__c = sequenceNumber,
                dmpl__IgnoreBudget__c = ignoreBudget,
                dmpl__PartnerAccountId__c = partnerAccountId,
                dmpl__PartnerAccountGroupId__c = partnerAccountGroupId,
                dmpl__AccountGroupId__c = accountGroupId,
                dmpl__AccountId__c = accountId,
                dmpl__BranchId__c = branchId,
                dmpl__SchemeBudget__c = schemeBudget
            ),
            //'SchemeDefaults',
            true
        );
    }

    public static dmpl__Scheme__c getScheme() {
        return [
            SELECT 
                Id, 
                Name,
                dmpl__ValidFrom__c,
                dmpl__ValidTo__c,
                dmpl__BusinessHoursId__c,
                dmpl__Status__c,
                dmpl__SchemeType__c,
                dmpl__Application__c,
                dmpl__PeriodType__c,
                dmpl__ValidCount__c,
                dmpl__MultipleFulfilmentTreatment__c,
                dmpl__SequenceNumber__c,
                dmpl__IgnoreBudget__c,
                dmpl__PartnerAccountId__c,
                dmpl__PartnerAccountGroupId__c,
                dmpl__AccountGroupId__c,
                dmpl__AccountId__c,
                dmpl__BranchId__c
            FROM dmpl__Scheme__c
            LIMIT 1
        ];
    }

    public static dmpl__Scheme__c getScheme(String schemeName) {
        return [
            SELECT 
                Id, 
                Name,
                dmpl__ValidFrom__c,
                dmpl__ValidTo__c,
                dmpl__BusinessHoursId__c,
                dmpl__Status__c,
                dmpl__SchemeType__c,
                dmpl__Application__c,
                dmpl__PeriodType__c,
                dmpl__ValidCount__c,
                dmpl__MultipleFulfilmentTreatment__c,
                dmpl__SequenceNumber__c,
                dmpl__IgnoreBudget__c,
                dmpl__PartnerAccountId__c,
                dmpl__PartnerAccountGroupId__c,
                dmpl__AccountGroupId__c,
                dmpl__AccountId__c,
                dmpl__BranchId__c
            FROM dmpl__Scheme__c
            WHERE Name = :schemeName
            LIMIT 1
        ];
    }

    public static dmpl__SchemeLine__c createSchemeLine(
        Integer sequenceNumber,
        String title,
        String definitionFilterCriteria,
        String rewardApplicability,
        Id schemeId
    ) {
        return (dmpl__SchemeLine__c) TestFactory.createSObject(
            new dmpl__SchemeLine__c(
                dmpl__SequenceNumber__c = sequenceNumber,
                dmpl__Title__c = title,
                dmpl__DefinitionFilterCriteria__c = definitionFilterCriteria,
                dmpl__RewardApplicability__c = rewardApplicability,
                dmpl__SchemeId__c = schemeId
            ),
            //'SchemeLineDefaults',
            true
        );
    }

    public static dmpl__SchemeLine__c getSchemeLine(Id schemeId) {
        return [
            SELECT 
                Id,
                dmpl__SequenceNumber__c,
                dmpl__Title__c,
                dmpl__DefinitionFilterCriteria__c,
                dmpl__RewardApplicability__c,
                dmpl__SchemeId__c
            FROM dmpl__SchemeLine__c
            WHERE dmpl__SchemeId__c = :schemeId
            LIMIT 1
        ];
    }

    public static dmpl__SchemeLine__c getSchemeLine() {
        return [
            SELECT 
                Id,
                dmpl__SequenceNumber__c,
                dmpl__Title__c,
                dmpl__DefinitionFilterCriteria__c,
                dmpl__RewardApplicability__c,
                dmpl__SchemeId__c
            FROM dmpl__SchemeLine__c
            LIMIT 1
        ];
    }

    public static dmpl__SchemeCondition__c createSchemeCondition(
        String conditionType,
        String conditionOperator,
        Id itemId,
        Decimal conditionQuantity,
        Id schemeLineId,
        Id schemeId,
        Decimal sequenceNumber
    ) {
        return (dmpl__SchemeCondition__c) TestFactory.createSObject(
            new dmpl__SchemeCondition__c(
                dmpl__ConditionType__c = conditionType,
                dmpl__ConditionOperator__c = conditionOperator,
                dmpl__ItemId__c = itemId,
                dmpl__ConditionQuantity__c = conditionQuantity,
                dmpl__SchemeLineId__c = schemeLineId,
                dmpl__SchemeId__c = schemeId,
                dmpl__SequenceNumber__c =1
            ),
            //'SchemeConditionDefaults',
            true
        );
    }

    public static dmpl__SchemeCondition__c getSchemeCondition(Id schemeLineId) {
        return [
            SELECT 
                Id,
                dmpl__ConditionType__c,
                dmpl__ConditionOperator__c,
                dmpl__ItemId__c,
                dmpl__ConditionQuantity__c,
                dmpl__SchemeLineId__c,
                dmpl__SchemeId__c
            FROM dmpl__SchemeCondition__c
            WHERE dmpl__SchemeLineId__c = :schemeLineId
            LIMIT 1
        ];
    }
    
    public static dmpl__SchemeCondition__c getSchemeCondition() {
        return [
            SELECT 
                Id,
                dmpl__ConditionType__c,
                dmpl__ConditionOperator__c,
                dmpl__ItemId__c,
                dmpl__ConditionQuantity__c,
                dmpl__SchemeLineId__c,
                dmpl__SchemeId__c
            FROM dmpl__SchemeCondition__c
            LIMIT 1
        ];
    }

    public static dmpl__SchemeBenefit__c createSchemeBenefit(
        String title,
        String rewardType,
        Id discountedItemId,
        Decimal discountedItemQuantity,
        Decimal discountPercent,
        Decimal discountAmount,
        Id schemeLineId,
        Id schemeId,
        Decimal sequenceNumber
    ) {
        return (dmpl__SchemeBenefit__c) TestFactory.createSObject(
            new dmpl__SchemeBenefit__c(
                dmpl__Title__c = title,
                dmpl__RewardType__c = rewardType,
                dmpl__DiscountedItemId__c = discountedItemId,
                dmpl__DiscountedItemQuantity__c = discountedItemQuantity,
                dmpl__DiscountPercent__c = discountPercent,
                dmpl__SchemeLineId__c = schemeLineId,
                dmpl__SchemeId__c = schemeId,
                dmpl__DiscountAmount__c = discountAmount,
                dmpl__SequenceNumber__c =1

            ),
            //'SchemeBenefitDefaults',
            true
        );
    }

    public static dmpl__SchemeBenefit__c getSchemeBenefits(Id schemeLineId) {
        return [
            SELECT 
                Id,
                dmpl__Title__c,
                dmpl__RewardType__c,
                dmpl__DiscountedItemId__c,
                dmpl__DiscountedItemQuantity__c,
                dmpl__DiscountPercent__c,
                dmpl__SchemeLineId__c,
                dmpl__DiscountAmount__c,
                dmpl__SchemeId__c
            FROM dmpl__SchemeBenefit__c
            WHERE dmpl__SchemeLineId__c = :schemeLineId
            LIMIT 1
        ];
    }

    public static dmpl__SchemeBenefit__c getSchemeBenefits() {
        return [
            SELECT 
                Id,
                dmpl__Title__c,
                dmpl__RewardType__c,
                dmpl__DiscountedItemId__c,
                dmpl__DiscountedItemQuantity__c,
                dmpl__DiscountPercent__c,
                dmpl__SchemeLineId__c,
                dmpl__SchemeId__c
            FROM dmpl__SchemeBenefit__c
            LIMIT 1
        ];
    }
    
    public static dmpl__SchemeAccountBudget__c createSchemesAccountBudget(
        Decimal budgetAmount,
        Id schemeId, 
        Id partenerAccountId
    ) {
        return (dmpl__SchemeAccountBudget__c) TestFactory.createSObject(
            new dmpl__SchemeAccountBudget__c(
                dmpl__BudgetAmount__c = budgetAmount,
                dmpl__SchemeId__c = schemeId,
                dmpl__PartnerAccountId__c = partenerAccountId
            ),
            //'SchemeBudgetDefaults',
            true
        );
    }

    public static dmpl__SchemeAccountBudget__c getSchemesAccountBudget(Id schemeId) {
        return [
            SELECT 
                Id,
                dmpl__BudgetAmount__c,
                dmpl__SchemeId__c,
                dmpl__PartnerAccountId__c
            FROM dmpl__SchemeAccountBudget__c
            WHERE dmpl__SchemeId__c = :schemeId
            LIMIT 1
        ];
    }

    public static dmpl__SchemeAccountBudget__c getSchemesAccountBudget() {
        return [
            SELECT 
                Id,
                dmpl__BudgetAmount__c,
                dmpl__SchemeId__c
            FROM dmpl__SchemeAccountBudget__c
            LIMIT 1
        ];
    }
}