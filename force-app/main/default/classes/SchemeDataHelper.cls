public with sharing class SchemeDataHelper {
      public static dmpl__Scheme__c createScheme() {
        return (dmpl__Scheme__c) TestFactory.createSObject(
            new dmpl__Scheme__c(),
            'SchemeDefaults',
            true
        );
    }

    public static dmpl__Scheme__c getSchemeById(String id) {
        List<dmpl__Scheme__c> records = [
            SELECT Id, Name
            FROM dmpl__Scheme__c
            WHERE Id = :id
            LIMIT 1];
        return records.isEmpty() ? null : records[0];
    }

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
        Id branchId
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
                dmpl__BranchId__c = branchId
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
    public static dmpl__SchemeLine__c createSchemeSlab(
        dmpl__Scheme__c scheme,
    String title,
    Decimal seqNum,
    String filterCriteria,
    String rewardApplicability
    ) {
        return (dmpl__SchemeLine__c) TestFactory.createSObject(
            new dmpl__SchemeLine__c(
            dmpl__SchemeId__c = scheme != null ? scheme.Id : null,
        dmpl__Title__c = title != null ? title : null,
        dmpl__SequenceNumber__c = seqNum != null ? seqNum : null,
        dmpl__DefinitionFilterCriteria__c = filterCriteria != null ? filterCriteria : null,
        dmpl__RewardApplicability__c = rewardApplicability != null ? rewardApplicability : null
            
        ),
        //'SchemeSlabDefaults',
        true
            );
    }
    
    public static dmpl__SchemePeriod__c createSchemePeriod(
        dmpl__Scheme__c scheme,
    String schemePeriodName,
    Date dateFrom,
    Date dateTo
    ) {
        return (dmpl__SchemePeriod__c) TestFactory.createSObject(
            new dmpl__SchemePeriod__c(
            dmpl__SchemeId__c = scheme != null ? scheme.Id : null,
        Name = schemePeriodName != null ? schemePeriodName : null,
        dmpl__DateFrom__c = dateFrom != null ? dateFrom : null,
        dmpl__DateTo__c = dateTo != null ? dateTo : null
            
        ),
        //'SchemePeriodDefaults',
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
    
    public static dmpl__SchemeCondition__c createSchemeCondition(
        Id schemeId,
    Id schemeLineId,
    String conditionType,
    Decimal conditionValue,
    Decimal uomQuantity,
    Decimal uomQuantity1,
    Id itemId,
    Id itemGroupId,
    String conditionOperator,
    Decimal conditionQuantity,
    Decimal sequenceNumber
    ) {
        return (dmpl__SchemeCondition__c) TestFactory.createSObject(
            new dmpl__SchemeCondition__c(
            dmpl__SchemeId__c = schemeId,
        dmpl__SchemeLineId__c = schemeLineId,
        dmpl__ConditionType__c = conditionType,
        dmpl__ConditionValue__c = conditionValue,
        dmpl__UOMQuantity__c = uomQuantity,
        dmpl__UOMQuantity1__c = uomQuantity1,
        dmpl__ItemId__c = itemId,
        dmpl__ItemGroupId__c = itemGroupId,
        dmpl__ConditionOperator__c = conditionOperator,
        dmpl__ConditionQuantity__c = conditionQuantity,
        dmpl__SequenceNumber__c = sequenceNumber
            ),
        true
            );
    }
    
    public static dmpl__SchemeCondition__c getSchemeCondition(Id schemeLineId) {
        return [
            SELECT 
                Id,
                dmpl__SchemeId__c,
				dmpl__SchemeLineId__c,
				dmpl__ConditionType__c,
				dmpl__ConditionValue__c,
				dmpl__UOMQuantity__c,
            	dmpl__UOMQuantity1__c,
				dmpl__ItemId__c,
				dmpl__ItemGroupId__c,
				dmpl__ConditionOperator__c,
				dmpl__ConditionQuantity__c,
				dmpl__SequenceNumber__c
            FROM dmpl__SchemeCondition__c
            WHERE dmpl__SchemeLineId__c = :schemeLineId
            LIMIT 1
        ];
    }
    public static dmpl__SchemeCondition__c getSchemeConditionbyId(Id recordId) {
        return [
            SELECT 
                Id,
                dmpl__SchemeId__c,
				dmpl__SchemeLineId__c,
				dmpl__ConditionType__c,
				dmpl__ConditionValue__c,
				dmpl__UOMQuantity__c,
            	dmpl__UOMQuantity1__c,
				dmpl__ItemId__c,
				dmpl__ItemGroupId__c,
				dmpl__ConditionOperator__c,
				dmpl__ConditionQuantity__c,
				dmpl__SequenceNumber__c
            FROM dmpl__SchemeCondition__c
            WHERE Id = :recordId
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
            	dmpl__UOMQuantity1__c,
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
    public static dmpl__SchemeBenefit__c createSchemeBenefit(
        Id schemeId,
    Id schemeLineId,
    Decimal sequenceNumber,
    String rewardType,
    Id discountedItemId,
    Id discountedItemGroupId,
    Decimal discountPercent,
    Decimal discountAmount,
    Decimal uomQuantity,
    Boolean exludeQualifyingItems,
    Boolean repeatReward
    ) {
        return (dmpl__SchemeBenefit__c) TestFactory.createSObject(
            new dmpl__SchemeBenefit__c(
            dmpl__SchemeId__c = schemeId,
        dmpl__SchemeLineId__c = schemeLineId,
        dmpl__SequenceNumber__c = sequenceNumber,
        dmpl__RewardType__c = rewardType,
        dmpl__DiscountedItemId__c = discountedItemId,
        dmpl__DiscountedItemGroupId__c = discountedItemGroupId,
        dmpl__DiscountPercent__c = discountPercent,
        dmpl__DiscountAmount__c = discountAmount,
        dmpl__UOMQuantity__c = uomQuantity,
        dmpl__ExcludeQualifyingItems__c = exludeQualifyingItems,
        dmpl__RepeatReward__c = repeatReward
            ),
        true
            );
    }
    
    public static dmpl__SchemeBenefit__c getSchemeBenefits(Id schemeLineId) {
        return [
            SELECT 
                Id,
                dmpl__SchemeId__c,
				dmpl__SchemeLineId__c,
				dmpl__SequenceNumber__c,
				dmpl__RewardType__c,
				dmpl__DiscountedItemId__c,
				dmpl__DiscountedItemGroupId__c,
				dmpl__DiscountPercent__c,
				dmpl__DiscountAmount__c,
				dmpl__DiscountedItemQuantity__c,
				dmpl__UOMQuantity__c,
				dmpl__ExcludeQualifyingItems__c,
				dmpl__RepeatReward__c
            FROM dmpl__SchemeBenefit__c
            WHERE dmpl__SchemeLineId__c = :schemeLineId 
            LIMIT 1
        ];
    }
    public static dmpl__SchemeBenefit__c getSchemeBenefitbyId(Id recordId) {
        return [
            SELECT 
                Id,
                dmpl__SchemeId__c,
				dmpl__SchemeLineId__c,
				dmpl__SequenceNumber__c,
				dmpl__RewardType__c,
				dmpl__DiscountedItemId__c,
				dmpl__DiscountedItemGroupId__c,
				dmpl__DiscountPercent__c,
				dmpl__DiscountAmount__c,
				dmpl__DiscountedItemQuantity__c,
				dmpl__UOMQuantity__c,
				dmpl__ExcludeQualifyingItems__c,
				dmpl__RepeatReward__c
            FROM dmpl__SchemeBenefit__c
            WHERE Id = :recordId 
            LIMIT 1
        ];
    }
    
    public static dmpl__SchemeBenefit__c getSchemeBenefits() {
        return [
            SELECT 
                Id,
                dmpl__Title__c,
                dmpl__SchemeId__c,
				dmpl__SchemeLineId__c,
				dmpl__SequenceNumber__c,
				dmpl__RewardType__c,
				dmpl__DiscountedItemId__c,
				dmpl__DiscountedItemGroupId__c,
				dmpl__DiscountPercent__c,
				dmpl__DiscountAmount__c,
				dmpl__DiscountedItemQuantity__c,
				dmpl__UOMQuantity__c,
				dmpl__ExcludeQualifyingItems__c,
				dmpl__RepeatReward__c
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

     public static dmpl__SchemeAccountBudget__c createSchemesAccountBudget(
        Decimal budgetAmount,
        Id schemeId
    ) {
        return (dmpl__SchemeAccountBudget__c) TestFactory.createSObject(
            new dmpl__SchemeAccountBudget__c(
                dmpl__BudgetAmount__c = budgetAmount,
                dmpl__SchemeId__c = schemeId
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
    
    
    public static dmpl__SchemeLedger__c createSchemeLedger(
        Id partnerAccountId,
    Id branchId,
    Id schemeLineId,
    Id billId,
    Id saleOrderId,
    Id saleOrderLineId,
    Id saleInvoiceId,
    Id saleInvoiceLineId,
    Id saleReturnId,
    Id saleReturnLineId,
    Id repairOrderId,
    Id schemeBenefitId,
    Decimal discountAmount,
    Decimal discount,
    Decimal rewardPoint
    ) {
        return (dmpl__SchemeLedger__c) TestFactory.createSObject(
            new dmpl__SchemeLedger__c(
            dmpl__PartnerAccountId__c = partnerAccountId ,
        dmpl__BranchId__c = branchId,
        dmpl__SchemeLineId__c =  schemeLineId,
        dmpl__BillId__c =  billId,
        dmpl__SaleOrderId__c = saleOrderId ,
        dmpl__SaleOrderLineId__c = saleOrderLineId ,
        dmpl__SaleInvoiceId__c = saleInvoiceId ,
        dmpl__SaleInvoiceLineId__c = saleInvoiceLineId,
        dmpl__SaleReturnId__c = saleReturnId ,
        dmpl__SaleReturnLineId__c = saleReturnLineId ,
        dmpl__RepairOrderId__c =  repairOrderId,
        dmpl__SchemeBenefitId__c =  schemeBenefitId,
        dmpl__DiscountAmount__c = discountAmount,
        dmpl__Discount__c = discount,
        dmpl__RewardPoints__c = rewardPoint
            ),
        'SchemeLedgerDefaults',
        true
            );
    }
    
    public static dmpl__SchemeLedger__c getSchemeLedger() {
        return [
            SELECT Id,
				dmpl__AccountId__c,
				dmpl__LineAmount__c,
				dmpl__PartnerAccountId__c,
				dmpl__BranchId__c,
				dmpl__SchemeLineId__c,
				dmpl__BillId__c,
				dmpl__SaleOrderId__c,
				dmpl__SaleOrderLineId__c,
				dmpl__SaleInvoiceId__c,
				dmpl__SaleInvoiceLineId__c,
				dmpl__SaleReturnId__c,
				dmpl__SaleReturnLineId__c,
				dmpl__RepairOrderId__c,
				dmpl__DiscountAmount__c,
				dmpl__SchemeBenefitId__c,
				dmpl__Discount__c,
				dmpl__RewardPoints__c
            FROM dmpl__SchemeLedger__c
            LIMIT 1
        ];
    }
    
    public static dmpl__SchemeLedger__c getSchemeLedger(Id recordId) {
        return [
            SELECT Id, 
				dmpl__AccountId__c,
				dmpl__LineAmount__c,
				dmpl__PartnerAccountId__c,
				dmpl__BranchId__c,
				dmpl__SchemeLineId__c,
				dmpl__BillId__c,
				dmpl__SaleOrderId__c,
				dmpl__SaleOrderLineId__c,
				dmpl__SaleInvoiceId__c,
				dmpl__SaleInvoiceLineId__c,
				dmpl__SaleReturnId__c,
				dmpl__SaleReturnLineId__c,
				dmpl__RepairOrderId__c,
				dmpl__DiscountAmount__c,
				dmpl__SchemeBenefitId__c,
				dmpl__Discount__c,
				dmpl__RewardPoints__c
            FROM dmpl__SchemeLedger__c
            WHERE Id = :recordId
            LIMIT 1
        ];
    }
    
    public static dmpl__SchemeConsumption__c createSchemeConsumption(
        string name,
    Id partnerAccountId,
    Id branchId,
    Id itemId,
    Id itemGroupId,
    Decimal consumedQuantity,
    Decimal consumedAmount
    ) {
        return (dmpl__SchemeConsumption__c) TestFactory.createSObject(
            new dmpl__SchemeConsumption__c(
            Name = name,
        dmpl__PartnerAccountId__c = partnerAccountId ,
        dmpl__BranchId__c = branchId,
        dmpl__ItemId__c = itemId,
        dmpl__ItemGroupId__c = itemGroupId,
        dmpl__ConsumedQuantity__c = consumedQuantity,
        dmpl__ConsumedAmount__c = consumedAmount
            ),
        true
            );
    }
    public static dmpl__SchemeConsumption__c getSchemeConsumption(Id recordId) {
        return [
            SELECT Id, 
				Name,
				dmpl__PartnerAccountId__c,
				dmpl__BranchId__c,
				dmpl__ItemId__c,
				dmpl__ItemGroupId__c,
				dmpl__ConsumedQuantity__c,
				dmpl__ConsumedAmount__c
            FROM dmpl__SchemeConsumption__c
            WHERE Id = :recordId
            LIMIT 1
        ];
    }
    
    
	public static dmpl__SchemeAccountBudget__c createSchemeAccountBudget(
		Id partnerAccountId,
		Id partnerAccountGroupId,
		Id schemeId,
		Decimal budgetAmount,
		Decimal utilizeAmount
	) {
        return (dmpl__SchemeAccountBudget__c) TestFactory.createSObject(
            new dmpl__SchemeAccountBudget__c(
				dmpl__PartnerAccountId__c = partnerAccountId,
				dmpl__PartnerAccountGroupId__c = partnerAccountGroupId,
				dmpl__SchemeId__c= schemeId,
				dmpl__BudgetAmount__c = budgetAmount,
				dmpl__UtilizedAmount__c = utilizeAmount
			),
            true
        );
    }
    
    public static dmpl__SchemeAccountBudget__c getSchemeAccountBudget() {
        return [
            SELECT Id,
					dmpl__BudgetAmount__c, 
					dmpl__UtilizedAmount__c, 
					dmpl__SchemeId__c,
					dmpl__PartnerAccountId__c,
					dmpl__PartnerAccountGroupId__c
            FROM dmpl__SchemeAccountBudget__c
            LIMIT 1
        ];
    }

    public static dmpl__SchemeAccountBudget__c getSchemeAccountBudget(Id recordId) {
        return [
            SELECT Id, 
					dmpl__BudgetAmount__c, 
					dmpl__UtilizedAmount__c, 
					dmpl__SchemeId__c,
					dmpl__PartnerAccountId__c,
					dmpl__PartnerAccountGroupId__c
            FROM dmpl__SchemeAccountBudget__c
            WHERE Id = :recordId
            LIMIT 1
        ];
    }

    public static dmpl__SchemeBenefit__c createSchemeBenefit() {
        return (dmpl__SchemeBenefit__c) TestFactory.createSObject(
            new dmpl__SchemeBenefit__c(),
            'SchemeBenefitDefaults',
            true
        );
    }
 
    public static dmpl__SchemeBenefit__c getSchemeBenefit() {
        List<dmpl__SchemeBenefit__c> schemeBenefits =  [
            SELECT Id, dmpl__Title__c, dmpl__DiscountAmount__c, dmpl__RewardType__c
            FROM dmpl__SchemeBenefit__c
            LIMIT 1
        ];
        return schemeBenefits.isEmpty() ? null : schemeBenefits[0];
    }
 
    public static dmpl__SchemeCondition__c createSchemeCondition(
        Id schemeId,
        Id schemeLineId,
        Id itemId,
        Id itemGroupId,
        Id lotTypeId,
        Id skuId
    ) {
        return (dmpl__SchemeCondition__c) TestFactory.createSObject(
            new dmpl__SchemeCondition__c(
                dmpl__SchemeId__c = schemeId,
                dmpl__SchemeLineId__c = schemeLineId,
                dmpl__ItemId__c = itemId,
                dmpl__ItemGroupId__c = itemGroupId,
                dmpl__ItemLotTypeId__c = lotTypeId,
                dmpl__ItemSKUId__c = skuId
            ),
            'SchemeConditionDefaults',
            true
        );
    }
 
    public static dmpl__SchemeLine__c createSchemeLine(Id schemeId, Id rewardAccountGroupId) {
        if (schemeId == null) {
            schemeId = createScheme().Id;
        }
        return (dmpl__SchemeLine__c) TestFactory.createSObject(
            new dmpl__SchemeLine__c(
                dmpl__SchemeId__c = schemeId,
                dmpl__RewardAccountGroup__c = rewardAccountGroupId
            ),
            'SchemeLineDefaults',
            true
        );
    }
 
    public static dmpl__SchemeLine__c createSchemeLine(Id schemeId) {
        return createSchemeLine(schemeId, null);
    }
 
    public static dmpl__SchemeLine__c getSchemeLineRecord() {
        List<dmpl__SchemeLine__c> records = [
            SELECT Id, dmpl__DefinitionCustomLogic__c, dmpl__DefinitionFilterCriteria__c,
                   dmpl__RewardApplicability__c, dmpl__RewardCustomLogic__c,
                   dmpl__SequenceNumber__c, dmpl__Title__c
            FROM dmpl__SchemeLine__c
            LIMIT 1
        ];
        return records.isEmpty() ? null : records[0];
    }
 
    public static dmpl__SchemePeriod__c createSchemePeriod(Id schemeId) {
        if (schemeId == null) {
            schemeId = createScheme().Id;
        }
        return (dmpl__SchemePeriod__c) TestFactory.createSObject(
            new dmpl__SchemePeriod__c(
                dmpl__SchemeId__c = schemeId
            ),
            'SchemePeriodDefaults',
            true
        );
    }
 
    public static dmpl__SchemePeriod__c getSchemePeriodRecord() {
        List<dmpl__SchemePeriod__c> records = [
            SELECT Id, Name, dmpl__DateFrom__c, dmpl__DateTo__c, dmpl__Status__c
            FROM dmpl__SchemePeriod__c
            LIMIT 1
        ];
        return records.isEmpty() ? null : records[0];
    }
 
}