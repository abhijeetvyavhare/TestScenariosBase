public with sharing class IncentivePlanDataHelper {
    public static dmpl__IncentivePlan__c createIncentivePlan(
        String periodType,
        String memberType,
        String status,
        Date periodStartDate,
        Date periodEndDate,
        Id accountGroupId,
        Id partnerAccountId,
        Id supplierAccountId
    ) {
        return (dmpl__IncentivePlan__c) TestFactory.createSObject(
            new dmpl__IncentivePlan__c(
                Name = 'Test Incentive Plan',
                dmpl__PeriodType__c = periodType,
                dmpl__MemberType__c = memberType,
                dmpl__Status__c = status,
                dmpl__PeriodStartDate__c = periodStartDate,
                dmpl__PeriodEndDate__c = periodEndDate,
                dmpl__AccountGroupId__c = accountGroupId,
                dmpl__PartnerAccountId__c = partnerAccountId,
                dmpl__SupplierAccountId__c = supplierAccountId
            ),
            'IncentivePlanDefaults',
            true
        );
    }

    public static dmpl__IncentivePlan__c createIncentivePlan(
        String incentivePlanName,
        String periodType,
        String memberType,
        Date periodStartDate,
        Date periodEndDate,
        Account supplierAccount,
        Account partnerAccount
    ) {
        return (dmpl__IncentivePlan__c) TestFactory.createSObject(
            new dmpl__IncentivePlan__c(
                Name = incentivePlanName!=null ? incentivePlanName : null,
                dmpl__PeriodType__c = periodType !=null ? periodType : null,
                dmpl__MemberType__c = memberType != null ? memberType : null,
                dmpl__PeriodStartDate__c = periodStartDate != null ? periodStartDate : null,
                dmpl__PeriodEndDate__c = periodEndDate != null ? periodEndDate : null,
                dmpl__SupplierAccountId__c = supplierAccount !=null ? supplierAccount.Id : null,
                dmpl__PartnerAccountId__c = partnerAccount != null ? partnerAccount.Id : null
            ),
            //'IncentivePlanDefaults',
            true
        );
    }

    public static dmpl__IncentivePlan__c getIncentivePlan() {
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__PeriodType__c, 
                dmpl__MemberType__c, 
                dmpl__Status__c, 
                dmpl__PeriodStartDate__c, 
                dmpl__PeriodEndDate__c,
                dmpl__AccountGroupId__c, 
                dmpl__PartnerAccountId__c, 
                dmpl__SupplierAccountId__c
            FROM dmpl__IncentivePlan__c
            LIMIT 1
        ];
    }

    public static dmpl__IncentivePlan__c getIncentivePlan(Id planId) {
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__PeriodType__c, 
                dmpl__MemberType__c, 
                dmpl__Status__c, 
                dmpl__PeriodStartDate__c, 
                dmpl__PeriodEndDate__c,
                dmpl__AccountGroupId__c, 
                dmpl__PartnerAccountId__c, 
                dmpl__SupplierAccountId__c
            FROM dmpl__IncentivePlan__c
            WHERE Id = :planId
            LIMIT 1
        ];
    }

    public static dmpl__IncentivePlan__c updateIncentivePlan(dmpl__IncentivePlan__c plan, String newStatus) {
        plan.dmpl__Status__c = newStatus;
        update plan;
        return getIncentivePlan(plan.Id);
    }

    public static Integer deleteIncentivePlan(dmpl__IncentivePlan__c plan) {
        Id planId = plan.Id;
        delete plan;
        return [
            SELECT COUNT() FROM dmpl__IncentivePlan__c WHERE Id = :planId
        ];
    }

    public static dmpl__IncentivePeriod__c createIncentivePeriod(
        Id incentivePlanId,
        Date dateFrom,
        Date dateTo,
        String periodName,
        String status
    ) {
        return (dmpl__IncentivePeriod__c) TestFactory.createSObject(
            new dmpl__IncentivePeriod__c(
                Name = periodName,
                dmpl__IncentivePlanId__c = incentivePlanId,
                dmpl__DateFrom__c = dateFrom,
                dmpl__DateTo__c = dateTo,
                dmpl__Status__c = status
            ),
            'IncentivePeriodDefaults',
            true
        );
    }

    public static dmpl__IncentivePeriod__c createIncentivePeriod(
        String periodName,
        Date dateFrom,
        Date dateTo,
        dmpl__IncentivePlan__c incentivePlan
    ) {
        return (dmpl__IncentivePeriod__c) TestFactory.createSObject(
            new dmpl__IncentivePeriod__c(
                Name = periodName !=null ? periodName : null,
                dmpl__DateFrom__c = dateFrom !=null ? dateFrom : null,
                dmpl__DateTo__c = dateTo !=null ? dateTo : null,
                dmpl__IncentivePlanId__c = incentivePlan !=null ? incentivePlan.Id : null
            ),
            //'IncentivePeriodDefaults',
            true
        );
    }

    public static dmpl__IncentivePeriod__c getIncentivePeriod() {
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__IncentivePlanId__c, 
                dmpl__DateFrom__c, 
                dmpl__DateTo__c, 
                dmpl__Status__c
            FROM dmpl__IncentivePeriod__c
            LIMIT 1
        ];
    }

    public static dmpl__IncentivePeriod__c getIncentivePeriod(Id periodId) {
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__IncentivePlanId__c, 
                dmpl__DateFrom__c, 
                dmpl__DateTo__c, 
                dmpl__Status__c
            FROM dmpl__IncentivePeriod__c
            WHERE Id = :periodId
            LIMIT 1
        ];
    }

    public static dmpl__IncentivePeriod__c updateIncentivePeriod(dmpl__IncentivePeriod__c period, String newStatus) {
        period.dmpl__Status__c = newStatus;
        update period;
        return getIncentivePeriod(period.Id);
    }

    public static Integer deleteIncentivePeriod(dmpl__IncentivePeriod__c period) {
        Id periodId = period.Id;
        delete period;
        return [
            SELECT COUNT() FROM dmpl__IncentivePeriod__c WHERE Id = :periodId
        ];
    }

    public static dmpl__IncentiveResource__c createIncentiveResource(
        Id incentivePlanId,
        Id resourceId,
        Id partnerAccountId,
        Id branchId
    ) {
        return (dmpl__IncentiveResource__c) TestFactory.createSObject(
            new dmpl__IncentiveResource__c(
                Name = 'Test Incentive Resource',
                dmpl__IncentivePlanId__c = incentivePlanId,
                dmpl__ResourceId__c = resourceId,
                dmpl__PartnerAccountId__c = partnerAccountId,
                dmpl__BranchId__c = branchId
            ),
            'IncentiveResourceDefaults',
            true
        );
    }

    public static dmpl__IncentiveResource__c createIncentiveResource(
        Account partnerAccount,
        dmpl__Branch__c branch,
        String incentiveResourceName,
        dmpl__IncentivePlan__c incentivePlan
    ) {
        return (dmpl__IncentiveResource__c) TestFactory.createSObject(
            new dmpl__IncentiveResource__c(
                dmpl__PartnerAccountId__c= partnerAccount != null ? partnerAccount.Id : null,
                dmpl__BranchId__c = branch !=null ? branch.Id :null,
                Name = incentiveResourceName != null ? incentiveResourceName : null,
                dmpl__IncentivePlanId__c = incentivePlan != null ? incentivePlan.Id : null
                
                
            ),
            //'IncentiveResourceDefaults',
            true
        );
    }

    public static dmpl__IncentiveResource__c getIncentiveResource() {
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__IncentivePlanId__c, 
                dmpl__ResourceId__c, 
                dmpl__PartnerAccountId__c, 
                dmpl__BranchId__c
            FROM dmpl__IncentiveResource__c
            LIMIT 1
        ];
    }

    public static dmpl__IncentiveResource__c getIncentiveResource(Id resourceId) {
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__IncentivePlanId__c, 
                dmpl__ResourceId__c, 
                dmpl__PartnerAccountId__c, 
                dmpl__BranchId__c
            FROM dmpl__IncentiveResource__c
            WHERE Id = :resourceId
            LIMIT 1
        ];
    }

    public static dmpl__IncentiveResource__c updateIncentiveResource(dmpl__IncentiveResource__c resource, Id newBranchId) {
        resource.dmpl__BranchId__c = newBranchId;
        update resource;
        return getIncentiveResource(resource.Id);
    }

    public static Integer deleteIncentiveResource(dmpl__IncentiveResource__c resource) {
        Id resourceId = resource.Id;
        delete resource;
        return [
            SELECT COUNT() FROM dmpl__IncentiveResource__c WHERE Id = :resourceId
        ];
    }

    public static dmpl__IncentiveLine__c createIncentiveLine(
        Id incentivePlanId,
        String title,
        String definitionFilterCriteria,
        String rewardApplicability,
        Integer sequenceNumber,
        Boolean useSlabAbsoluteValue
    ) {
        return (dmpl__IncentiveLine__c) TestFactory.createSObject(
            new dmpl__IncentiveLine__c(
                dmpl__IncentivePlanId__c = incentivePlanId,
                dmpl__SequenceNumber__c = sequenceNumber,
                dmpl__UseSlabAbsoluteValue__c = useSlabAbsoluteValue
            ),
            'IncentiveLineDefaults',
            true
        );
    }

    public static dmpl__IncentiveLine__c getIncentiveLine() {
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__IncentivePlanId__c, 
                dmpl__Title__c, 
                dmpl__DefinitionFilterCriteria__c,
                dmpl__RewardApplicability__c, 
                dmpl__SequenceNumber__c, 
                dmpl__UseSlabAbsoluteValue__c
            FROM dmpl__IncentiveLine__c
            LIMIT 1
        ];
    }

    public static dmpl__IncentiveLine__c getIncentiveLine(Id lineId) {
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__IncentivePlanId__c, 
                dmpl__Title__c, 
                dmpl__DefinitionFilterCriteria__c,
                dmpl__RewardApplicability__c, 
                dmpl__SequenceNumber__c, 
                dmpl__UseSlabAbsoluteValue__c
            FROM dmpl__IncentiveLine__c
            WHERE Id = :lineId
            LIMIT 1
        ];
    }

    public static dmpl__IncentiveLine__c updateIncentiveLine(dmpl__IncentiveLine__c line, String newTitle) {
        line.dmpl__Title__c = newTitle;
        update line;
        return getIncentiveLine(line.Id);
    }

    public static Integer deleteIncentiveLine(dmpl__IncentiveLine__c line) {
        Id lineId = line.Id;
        delete line;
        return [
            SELECT COUNT() FROM dmpl__IncentiveLine__c WHERE Id = :lineId
        ];
    }

	
    public static dmpl__IncentiveLine__c createIncentiveLine(
        Id incentivePlanId,
        String rewardApplicability,
        String definitionFilterCriteria
    ) {
        return (dmpl__IncentiveLine__c) TestFactory.createSObject(
            new dmpl__IncentiveLine__c(
                dmpl__IncentivePlanId__c = incentivePlanId,
				dmpl__RewardApplicability__c = rewardApplicability,
				dmpl__DefinitionFilterCriteria__c = definitionFilterCriteria
            ),
            'IncentiveLineDefaults',
            true
        );
    }

	public static dmpl__IncentiveCompensationSlab__c createCompensationSlab(
        Id incentivePlanId,
		String memberResourceType,
        String compensationType,
        Id incentivePeriodId,
		Id referenceIncentiveLineId,
		Decimal giftPoints,
        Decimal sequenceNumber
    ) {
        return (dmpl__IncentiveCompensationSlab__c) TestFactory.createSObject(
            new dmpl__IncentiveCompensationSlab__c(
                dmpl__IncentivePlanId__c = incentivePlanId,
				dmpl__MemberResourceType__c = memberResourceType,
                dmpl__CompensationType__c = compensationType,
                dmpl__IncentivePeriodId__c = incentivePeriodId,
				dmpl__ReferenceIncentiveLineId__c = referenceIncentiveLineId,
				dmpl__GiftPoints__c = giftPoints,
                dmpl__SequenceNumber__c = sequenceNumber
            ),
            'CompensationSlabDefaults',
            true
        );
    }

    public static dmpl__IncentiveCompensationSlab__c getCompensationSlab() {
        return [
            SELECT Id, 
				dmpl__IncentivePlanId__c,
				dmpl__IncentivePeriodId__c, 
				dmpl__FromPercentage__c, 
				dmpl__ToPercentage__c,
                dmpl__CompensationType__c, 
				dmpl__IncentiveFixedAmount__c, 
				dmpl__SequenceNumber__c,
				dmpl__MemberResourceType__c,
				dmpl__ReferenceIncentiveLineId__c,
				dmpl__GiftPoints__c
            FROM dmpl__IncentiveCompensationSlab__c
            LIMIT 1
        ];
    }

    public static dmpl__IncentiveCompensationSlab__c getCompensationSlab(Id slabId) {
        return [
            SELECT Id, 
				dmpl__IncentivePlanId__c,
				dmpl__IncentivePeriodId__c, 
				dmpl__FromPercentage__c, 
				dmpl__ToPercentage__c,
                dmpl__CompensationType__c, 
				dmpl__IncentiveFixedAmount__c, 
				dmpl__SequenceNumber__c,
				dmpl__MemberResourceType__c,
				dmpl__ReferenceIncentiveLineId__c,
				dmpl__GiftPoints__c
			FROM dmpl__IncentiveCompensationSlab__c
            WHERE Id = :slabId
            LIMIT 1
        ];
    }

     
    public static dmpl__IncentiveCompensation__c createCompensation(
        Id incentivePlanId,
    Id branchId,
    Id partnerAccountId,
    Id accountID,
    Id incentivePeriodId
    ) {
        return (dmpl__IncentiveCompensation__c) TestFactory.createSObject(
            new dmpl__IncentiveCompensation__c(
            dmpl__AccountId__c =  accountID,
        dmpl__BranchId__c = branchId,
        dmpl__PartnerAccountId__c = partnerAccountId,
        dmpl__IncentivePeriodId__c = incentivePeriodId,
        dmpl__IncentivePlanId__c = incentivePlanId
            ),
        'CompensationDefaults',
        true
            );
    }
    
    
    public static dmpl__IncentiveCompensation__c getCompensation(Id compensationId) {
        return [
            SELECT Id, Name, dmpl__AccountId__c, dmpl__BranchId__c, dmpl__PartnerAccountId__c, dmpl__IncentivePeriodId__c, dmpl__IncentivePlanId__c, dmpl__Status__c, dmpl__TotalIncentiveAmount__c
            FROM dmpl__IncentiveCompensation__c
            WHERE Id = :compensationId
            LIMIT 1
        ];
    }
    
    public static dmpl__IncentiveCompensationLine__c createCompensationLine(
        Id compensationId,
        Id incentivePlanId,
        Id schemeId
        ) {
        return (dmpl__IncentiveCompensationLine__c) TestFactory.createSObject(
            new dmpl__IncentiveCompensationLine__c(
                dmpl__CompensationId__c = compensationId,
                dmpl__IncentivePlanId__c = incentivePlanId,
                dmpl__SchemeId__c = schemeId
                ),
                true
            );
    }
    
    public static dmpl__IncentiveCompensationLine__c getCompensationLine(Id lineId) {
        return [
            SELECT Id, dmpl__CompensationId__c, dmpl__IncentivePlanId__c, dmpl__IncentivePeriodId__c, dmpl__ItemId__c, dmpl__SKUId__c,
                   dmpl__IncentiveAmount__c, dmpl__Status__c,dmpl__SchemeId__c
            FROM dmpl__IncentiveCompensationLine__c
            WHERE Id = :lineId
            LIMIT 1
        ];
    }
    
}