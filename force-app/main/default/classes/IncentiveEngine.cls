public without sharing class IncentiveEngine {


    private static final String MEMBER_TYPE_PARTNER = 'Partner';
    private static final String MEMBER_TYPE_BRANCH = 'Branch';
    private static final String MEMBER_TYPE_CUSTOMER = 'Customer';
    private static final String MEMBER_TYPE_RESOURCE = 'Resource';

    private static final String DEFINITION_FILTER_CRITERIA_ALWAYS_NO_CRITERIA = 'Always (No Criteria)';
    private static final String DEFINITION_FILTER_CRITERIA_ALL_CONDITIONS = 'All Conditions Are Met';
    private static final String DEFINITION_FILTER_CRITERIA_ANY_CONDITION = 'Any Condition Is Met';
    private static final String DEFINITION_FILTER_CRITERIA_CUSTOM_LOGIC = 'Custom Logic Is Met';

    private static final String REWARD_APPLICABILITY_ALL_REWARDS = 'All Rewards';
    private static final String REWARD_APPLICABILITY_ANYONE_LOWESTVALUE = 'Any One With Lowest Value';
    private static final String REWARD_APPLICABILITY_ANYONE_HIGHESTVALUE = 'Any One With Highest Value';
    private static final String REWARD_APPLICABILITY_CUSTOMLOGIC = 'Custom Logic';

    private static final String REWARD_TYPE_FIXEDAMOUNT = 'Fixed Amount';
    private static final String REWARD_TYPE_PERCENTAGEONVALUE = 'Percentage On Value';
    private static final String REWARD_TYPE_AMOUNTPERUNIT = 'Amount Per Unit';
    private static final String REWARD_TYPE_PERCENTAGEONPROFIT = 'Percentage On Profit';
    private static final String REWARD_TYPE_GIFTS = 'Gifts';
    private static final String REWARD_TYPE_DISCOUNTGROUP = 'Discount Group';
    private static final String REWARD_TYPE_SCHEMEREWARDS = 'Scheme Rewards';
    private static final String REWARD_TYPE_PERCONVALUEREWARDS = 'Percentage On Value';
    private static final String REWARD_TYPE_PERUNITREWARDS = 'Amount Per Unit';
    private static final String REWARD_TYPE_PERUNITINCREMENTALREWARDS = 'Amount Per Unit Incremental';

    private static final String CONDITION_TYPE_NOOFSALEORDER = 'No Of Sale Orders';
    private static final String CONDITION_TYPE_SALEORDERAMOUNT = 'Sale Order Amount';

    private static final String CONDITION_OPERATOR_EQUALS = 'Equals';
    private static final String CONDITION_OPERATOR_DOSESNOT_EQUALS = 'Does Not Equal';
    private static final String CONDITION_OPERATOR_GREATER_THAN = 'Greater Than';
    private static final String CONDITION_OPERATOR_GREATERTHAN_OR_EQUALS = 'Greater Than Or Equal';
    private static final String CONDITION_OPERATOR_LESS_THAN = 'Less Than';
    private static final String CONDITION_OPERATOR_LESSTHAN_OR_EQUALS = 'Less Than Or Equal';

    private static final String DISCOUNTED_ITEM_RANKING_DECENDING = 'High To Low';
    
    private static final String STATUS_APPROVED = 'Approved';

    private static Boolean isAlreadyProcessing =false;
    private static dmpl__IncentiveCompensationLine__c document;
    private static List<IncentiveLine__c> activeIncentiveLines;
    private static List<dmpl__PerformanceKPI__c> periodSummary;
    private static Map<SObject,Id> appliedBenefits;
    private static Id partnerAccountId;
    private static Id accountId;
    private static Id branchId;
    private static Id incentivePeriodId;
    private static Id incentivePlanId;
    private static Id incentiveResourceId;
    private static Map<Id, List<dmpl__ItemGroupMember__c>> itemGroups;
    private static Boolean isQualifying;
    private static Id applyBenefit;
    private static Integer applyBenefitCustomIndex;
    private static List<SourceObjectInfo> preferedItemList;
    private Map<Id,Integer> perDocumentResults = new Map<Id,Integer>();
    private Map<Id,Boolean> perPeriodResults = new Map<Id,Boolean>();
    private List<IncentiveLine__c> qualifiedIncentiveLines;
    private static List<IncentiveCompensationSlab__c> qualifiedCompensationSlabs;
    private static List<dmpl__IncentiveResourceTarget__c> incentiveTargetResources;
    private static Map<Id,Double> targetAchivedValues;
    private Id applyIncentiveLine;

    public static void processIncentives(List<dmpl__IncentiveCompensationLine__c> documents){

        List<Id> incentiveResourceIds = DocumentHelper.extractIds(documents, 'dmpl__IncentiveResourceId__c');
        setIncentiveTargetResources(incentiveResourceIds);
        setActiveIncentiveLines(DocumentHelper.extractIds(documents, 'dmpl__IncentivePlanId__c'),
                                    DocumentHelper.extractIds(documents, 'dmpl__IncentivePeriodId__c'));


        for(dmpl__IncentiveCompensationLine__c aObject : documents){
            IncentiveEngine engine = new IncentiveEngine(
                aObject,
                false);

            engine.process();
        }
    }
    
    private IncentiveEngine(
        dmpl__IncentiveCompensationLine__c pDocument,
        Boolean pIsQualifying){
        document = pDocument;
        isQualifying = pIsQualifying;
        qualifiedCompensationSlabs = new List<IncentiveCompensationSlab__c>();
        targetAchivedValues= new Map<Id,Double>();
    }
    
    // private IncentiveEngine(
    //     dmpl__IncentiveCompensationLine__c pDocument,
    //     Id incentiveLineId,
    //     Id benefitId,
    //     Integer benefitCustomIndex,
    //     List<SourceObjectInfo> selectedItemInfo){
    //     isQualifying = false;
    //     document = pDocument;
    //     applyIncentiveLine = incentiveLineId;
    //     applyBenefit = benefitId;
    //     applyBenefitCustomIndex = benefitCustomIndex;
    //     preferedItemList = selectedItemInfo;
    // }

    private Boolean process()
    {
        if(isAlreadyProcessing){
            return false;
        }
        
        isAlreadyProcessing = true;
        setDocumentDefaults();
        List<IncentiveLine__c> currentPlanIncentiveLines =
                            CollectionHelper.getObjectsByFilter
                                (activeIncentiveLines,'dmpl__IncentivePlanId__c',incentivePlanId);
               
        if(document == null 
            || currentPlanIncentiveLines == null 
            || currentPlanIncentiveLines.size()==0){
            return false;
        }
        periodSummary = getPeriodSummary();

        for(IncentiveLine__c  incentiveLine : currentPlanIncentiveLines){
            perDocumentResults.put(
                    incentiveLine.Id, 
                    evaluateIncentiveLine(
                        incentiveLine));
        }
    
        for(IncentiveLine__c  incentiveLine : currentPlanIncentiveLines){
                if(perDocumentResults.get(incentiveLine.Id)>0) {
                        applyCompensationIncentiveLine(
                            incentiveLine,
                            perDocumentResults.get(incentiveLine.Id));    
                }
        }
        isAlreadyProcessing = false;
        return true;
    }


    private static void setDocumentDefaults(){
        if(document == null){
            return;
        }
        incentivePeriodId = document.dmpl__IncentivePeriodId__c;
        incentivePlanId = document.dmpl__IncentivePlanId__c;
        incentiveResourceId = document.dmpl__IncentiveResourceId__c;

        appliedBenefits = new Map<SObject,Id>();
    }

    private static void setActiveIncentiveLines(List<Id> incetivePlanIds, List<Id> incentivePeriodIds)
    {

        SecurityHelper.ensureCanReadFields(new string[]
        {
            'dmpl__MemberType__c',
            'dmpl__PeriodType__c',
            'dmpl__Status__c'
        }, 'dmpl__IncentivePlan__c');
        SecurityHelper.ensureCanReadFields(new string[]
            {
                'dmpl__Title__c',
                'dmpl__IncentivePlanId__c',
                'dmpl__DefinitionFilterCriteria__c',
                'dmpl__DefinitionCustomLogic__c',
                'dmpl__RewardApplicability__c'
                // 'dmpl__RewardCustomLogic__c'
            }, 'dmpl__IncentiveLine__c');
            SecurityHelper.ensureCanReadFields(new string[]
            {
                'dmpl__IncentiveTargetType__c',
                'dmpl__AccountId__c',
                // 'dmpl__AccountGroupId__c',
                'dmpl__ItemId__c',
                'dmpl__ItemSKUId__c',
                'dmpl__ItemGroupId__c',
                // 'dmpl__ItemLotTypeId__c',
                'dmpl__Value__c',
                'dmpl__CustomKPIFieldName__c',
                'dmpl__FinancerId__c',
                'dmpl__FinancerSchemeId__c',
                'dmpl__InsuranceSchemeId__c',
                'dmpl__InsurerId__c',
                'dmpl__IncentivePeriodId__c'
            }, 'dmpl__IncentiveTarget__c');
            SecurityHelper.ensureCanReadFields(new string[]
            {
                'dmpl__IncentiveLineId__c',
                'dmpl__RewardPoints__c',
                'dmpl__CompensationType__c',
                'dmpl__FromPercentage__c',
                'dmpl__ToPercentage__c',
                'dmpl__Gifts__c',
                'dmpl__GiftPoints__c',
                'dmpl__IncentiveAmountPerUnit__c',
                'dmpl__IncentiveFixedAmount__c',
                'dmpl__PercentageonProfit__c',
                'dmpl__TargetPercentage__c',
                'dmpl__AmountPercentage__c'
            }, 'dmpl__IncentiveCompensationSlab__c');
        activeIncentiveLines = 
        [
            SELECT
            Id,
            Name,
            dmpl__Title__c,
            dmpl__IncentivePlanId__c,
            dmpl__DefinitionFilterCriteria__c,
            dmpl__DefinitionCustomLogic__c,
            dmpl__RewardApplicability__c,
            // dmpl__RewardCustomLogic__c,
            dmpl__IncentivePlanId__r.Id,
            dmpl__IncentivePlanId__r.Name,
            dmpl__IncentivePlanId__r.dmpl__MemberType__c,
            dmpl__IncentivePlanId__r.dmpl__PeriodType__c,
            // dmpl__IncentivePlanId__r.dmpl__MultipleFulfilmentTreatment__c,
            // dmpl__IncentivePlanId__r.dmpl__Application__c,
            // dmpl__IncentivePlanId__r.dmpl__ValidCount__c,
            (
                SELECT 
                Id,
                Name,
                dmpl__IncentiveTargetType__c,
                // dmpl__ConditionOperator__c,
                dmpl__AccountId__c,
                // dmpl__AccountGroupId__c,
                dmpl__ItemId__c,
                dmpl__SKUId__c,
                dmpl__SKUId__r.Name,
                dmpl__ItemGroupId__c,
                dmpl__Value__c,
                dmpl__CustomKPIFieldName__c,
                dmpl__FinancerId__c,
                dmpl__FinancerSchemeId__c,
                dmpl__InsuranceSchemeId__c,
                dmpl__InsurerId__c,
                dmpl__IncentivePeriodId__c,
                dmpl__IncentivePlanId__r.dmpl__MemberType__c
            FROM 
                dmpl__IncentiveTargets__r
                Where 
                dmpl__IncentivePeriodId__c IN: incentivePeriodIds
            ORDER BY dmpl__SequenceNumber__c ASC
            ),
            (
                SELECT
                Id,
                dmpl__IncentiveLineId__c,
                Name,
                dmpl__CompensationType__c,
                dmpl__FromPercentage__c,
                dmpl__ToPercentage__c,
                dmpl__Gifts__c,
                dmpl__GiftPoints__c,
                dmpl__IncentiveAmountPerUnit__c,
                dmpl__IncentiveFixedAmount__c,
                dmpl__PercentageonProfit__c,
                dmpl__TargetPercentage__c,
                dmpl__AmountPercentage__c,
                dmpl__SchemeId__c,
                dmpl__DiscountGroupId__c
                FROM 
                    dmpl__CompensationSlabs__r
                ORDER BY dmpl__SequenceNumber__c ASC
            )
            FROM 
                dmpl__IncentiveLine__c
            WHERE
                dmpl__IncentivePlanId__c IN: incetivePlanIds
                AND dmpl__IncentivePlanId__r.dmpl__Status__c =: STATUS_APPROVED
                
            ORDER BY 
                dmpl__SequenceNumber__c ASC
        ];
    }

    private static void setIncentiveTargetResources(List<Id> incentiveResourceIds){
        SecurityHelper.ensureCanReadFields(new string[]
        {
            'dmpl__IncentiveTargetType__c'
        }, 'dmpl__IncentiveTarget__c');
        SecurityHelper.ensureCanReadFields(new string[]
        {
            'dmpl__AccountId__c',
            'dmpl__BranchId__c',
            'dmpl__PartnerAccountId__c',
            'dmpl__ResourceId__c'
        }, 'dmpl__IncentiveResource__c');
        SecurityHelper.ensureCanReadFields(new string[]
            {
                'dmpl__IncentiveResourceId__c',
                'dmpl__IncentiveTargetId__c',
                'dmpl__Value__c'
            }, 'dmpl__IncentiveResourceTarget__c');
        incentiveTargetResources = 
        [
            SELECT
            Id,
            dmpl__IncentiveResourceId__c,
            dmpl__IncentiveResourceId__r.dmpl__AccountId__c,
            dmpl__IncentiveResourceId__r.dmpl__BranchId__c,
            dmpl__IncentiveResourceId__r.dmpl__PartnerAccountId__c,
            dmpl__IncentiveResourceId__r.dmpl__ResourceId__c,
            dmpl__IncentiveTargetId__c,
            dmpl__IncentiveTargetId__r.dmpl__IncentiveTargetType__c,
            dmpl__Value__c
            FROM 
                dmpl__IncentiveResourceTarget__c
            WHERE
            dmpl__IncentiveResourceId__c IN: incentiveResourceIds
        ];
    }

    private static Integer evaluateIncentiveLine(IncentiveLine__c incentiveLine)
    {
        if(incentiveLine.DefinitionFilterCriteria__c == DEFINITION_FILTER_CRITERIA_ALWAYS_NO_CRITERIA){
            return 1;
        }
        //
        List<Integer> targetResults = new List<Integer>();
        List<IncentiveTarget__c> targets = CollectionHelper.getObjectsByFilter(
                incentiveLine.dmpl__IncentiveTargets__r, 
                'dmpl__IncentivePeriodId__c', 
                incentivePeriodId);

        ensureItemGroupRetreived();
        for(IncentiveTarget__c  target : targets){
            targetResults.add(
                evaluateIncentiveTarget(target, incentiveLine.dmpl__CompensationSlabs__r));
        }
        //
       return evaluateConditions(
            incentiveLine.DefinitionFilterCriteria__c, 
           incentiveLine.dmpl__DefinitionCustomLogic__c, 
           targetResults);
    }
    
    @testVisible
    private static void applyCompensationIncentiveLine(
        IncentiveLine__c incentiveLine, 
        Integer qualifyingCount)
    {
        // if(incentiveLine.RewardApplicability__c == REWARD_APPLICABILITY_ALL_REWARDS){
            for(dmpl__IncentiveCompensationSlab__c  benefit : qualifiedCompensationSlabs){
                applyIncentiveBenefit(
                    benefit);
            }
        // } 
    }

    @testVisible
    private static Integer evaluateIncentiveTarget(
                            IncentiveTarget__c target,
                            List<dmpl__IncentiveCompensationSlab__c> compensationSlabs)
    {
        dmpl__IncentiveResourceTarget__c incentiveTargetResource = setCurrentIncentiveTargetResource(target.Id);
        Double reachedValue = 0;
        if(incentiveTargetResource == null)
            return 0;

        if(target.dmpl__IncentiveTargetType__c == 'No Of Unique Invoices')
            reachedValue = getNoOfUniqueInvoices(target, incentiveTargetResource);
        else if(target.dmpl__IncentiveTargetType__c == 'No Of Unique Items')
            reachedValue = getNoOfUniqueItemsValue(target, incentiveTargetResource);
        else
            reachedValue = getReachedValue(target, incentiveTargetResource);
        
        return evaluateCompensationSlabs(
            reachedValue, 
            incentiveTargetResource.Value__c,
            compensationSlabs);
    }

    private static dmpl__IncentiveResourceTarget__c setCurrentIncentiveTargetResource(Id targetId)
    {
        for(dmpl__IncentiveResourceTarget__c incentiveResource : incentiveTargetResources)
        {
            if(incentiveResource.dmpl__IncentiveTargetId__c == targetId
                && incentiveResource.dmpl__IncentiveResourceId__c == incentiveResourceId)
                {
                    return incentiveResource;
                }
        }
        return null;
    }

    private static Integer evaluateCompensationSlabs(
                        Double reachedValue, 
                        Decimal conditionValue,
                        List<dmpl__IncentiveCompensationSlab__c> compensationSlabs)
    {
        Decimal percentage = Math.floor(reachedValue*100/conditionValue);
        System.debug('Percentage ' + percentage);
        for(dmpl__IncentiveCompensationSlab__c slab : compensationSlabs)
        {
            if(percentage >= slab.dmpl__FromPercentage__c && (percentage <= slab.dmpl__ToPercentage__c || (slab.dmpl__ToPercentage__c == null || slab.dmpl__ToPercentage__c == 0)))
            {
                qualifiedCompensationSlabs.Add(slab);
                if(!targetAchivedValues.containsKey(slab.Id))
                    targetAchivedValues.put(slab.Id,reachedValue);
                return 1;
            }
        }
        if(qualifiedCompensationSlabs.size() > 0)
            return 1;
        else
            return 0;
    }
    
    @TestVisible
    private static Double getReachedValue(IncentiveTarget__c target, dmpl__IncentiveResourceTarget__c incentiveResource)
    {
        Double value =0;
        for(dmpl__PerformanceKPI__c result : periodSummary){

            if(result.dmpl__IncentiveTargetId__c != target.Id)
                continue;

            if((target.dmpl__IncentivePlanId__r.dmpl__MemberType__c == MEMBER_TYPE_RESOURCE
                && result.dmpl__ResourceId__c == 
                    incentiveResource.dmpl__IncentiveResourceId__r.dmpl__ResourceId__c
                )

            || (target.dmpl__IncentivePlanId__r.dmpl__MemberType__c == MEMBER_TYPE_PARTNER
                && result.dmpl__PartnerAccountId__c == 
                    incentiveResource.dmpl__IncentiveResourceId__r.dmpl__PartnerAccountId__c)

            || (target.dmpl__IncentivePlanId__r.dmpl__MemberType__c == MEMBER_TYPE_BRANCH
                && result.dmpl__BranchId__c == 
                    incentiveResource.dmpl__IncentiveResourceId__r.dmpl__BranchId__c)

            || (target.dmpl__IncentivePlanId__r.dmpl__MemberType__c == MEMBER_TYPE_CUSTOMER
                && result.dmpl__AccountId__c == 
                    incentiveResource.dmpl__IncentiveResourceId__r.dmpl__AccountId__c))
            {
                If((target.dmpl__ItemId__c == result.dmpl__ItemId__c || target.dmpl__ItemId__c == null)
                    && (target.dmpl__AccountId__c == null || target.dmpl__AccountId__c == result.dmpl__AccountId__c))
                {
                        if(target.dmpl__ItemGroupId__c != null)
                        {
                            if(!doesItemGroupContains(target.dmpl__ItemGroupId__c, target.dmpl__ItemId__c, target.dmpl__SKUId__c))
                                continue;
                        }
                    
                    if(target.dmpl__IncentiveTargetType__c == 'No Of Sale Orders')
                    {
                        value += Double.valueOf(result.dmpl__NumberOfOrders__c) == null ? 0 : Double.valueOf(result.dmpl__NumberOfOrders__c);
                        document.dmpl__NoofBookings__c = value;
                    }
                    else if(target.dmpl__IncentiveTargetType__c == 'No Of Invoices')
                    {
                        value += Double.valueOf(result.dmpl__NumberOfInvoices__c) == null ? 0 : Double.valueOf(result.dmpl__NumberOfInvoices__c);
                        document.dmpl__NoofInvoices__c = value;
                    }
                    else if(target.dmpl__IncentiveTargetType__c == 'Sale Order Amount')
                    {
                        
                        value += Double.valueOf(result.dmpl__TotalSaleOrderAmount__c) == null ? 0 : Double.valueOf(result.dmpl__TotalSaleOrderAmount__c);
                        document.dmpl__SaleOrderAmount__c = value;
                    }
                    else if(target.dmpl__IncentiveTargetType__c == 'Sale Amount')
                    {
                        value += Double.valueOf(result.dmpl__TotalSaleInvoiceAmount__c) == null ? 0 : Double.valueOf(result.dmpl__TotalSaleInvoiceAmount__c);
                        document.dmpl__SaleAmount__c = value;
                    }
                    else if(target.dmpl__IncentiveTargetType__c == 'Sale Order Quantity')
                    {
                        value += Double.valueOf(result.dmpl__TotalSaleOrderQuantity__c) == null ? 0 : Double.valueOf(result.dmpl__TotalSaleOrderQuantity__c);
                        document.dmpl__SaleOrderQuantity__c = value;
                    }
                    else if(target.dmpl__IncentiveTargetType__c == 'Invoice Quantity')
                    {
                        value += Double.valueOf(result.dmpl__TotalSaleInvoiceQuantity__c) == null ? 0 : Double.valueOf(result.dmpl__TotalSaleInvoiceQuantity__c);
                        document.dmpl__SaleQuantity__c = value;
                    }
                    else if(target.dmpl__IncentiveTargetType__c == 'Purchase Order Amount')
                    {
                        value += Double.valueOf(result.dmpl__TotalPurchaseOrderAmount__c) == null ? 0 : Double.valueOf(result.dmpl__TotalPurchaseOrderAmount__c);
                        document.dmpl__PurchaseOrderAmount__c = value;
                    }
                    else if(target.dmpl__IncentiveTargetType__c == 'Purchase Order Quantity')
                    {
                        value += Double.valueOf(result.dmpl__TotalPurchaseOrderQuantity__c) == null ? 0 : Double.valueOf(result.dmpl__TotalPurchaseOrderQuantity__c);
                        document.dmpl__PurchaseOrderQuantity__c = value;
                    }
                    else if(target.dmpl__IncentiveTargetType__c == 'Custom KPI')
                    {
                        value += Double.valueOf(result.get(target.dmpl__CustomKPIFieldName__c)) == null ? 0 : Double.valueOf(result.get(target.dmpl__CustomKPIFieldName__c));
                        document.dmpl__CustomKPIValue__c = value;
                    }
                }
            }
        }
        return value;
    }

    @TestVisible
    private static Double getNoOfUniqueInvoices(IncentiveTarget__c target, dmpl__IncentiveResourceTarget__c incentiveResource)
    {
        Double value =0;
        // List<dmpl__PerformanceKPI__c> uniqueKPISummary = (List<dmpl__PerformanceKPI__c>)DocumentHelper.extractUniqueValues(periodSummary,'dmpl__AccountId__c');
        List<Id> accountIds = new List<Id>();
        for(dmpl__PerformanceKPI__c result : periodSummary){

            if(result.dmpl__IncentiveTargetId__c != target.Id)
                continue;

            if((target.dmpl__IncentivePlanId__r.dmpl__MemberType__c == MEMBER_TYPE_RESOURCE
                && result.dmpl__ResourceId__c == 
                    incentiveResource.dmpl__IncentiveResourceId__r.dmpl__ResourceId__c
                )

            || (target.dmpl__IncentivePlanId__r.dmpl__MemberType__c == MEMBER_TYPE_PARTNER
                && result.dmpl__PartnerAccountId__c == 
                    incentiveResource.dmpl__IncentiveResourceId__r.dmpl__PartnerAccountId__c)

            || (target.dmpl__IncentivePlanId__r.dmpl__MemberType__c == MEMBER_TYPE_BRANCH
                && result.dmpl__BranchId__c == 
                    incentiveResource.dmpl__IncentiveResourceId__r.dmpl__BranchId__c)

            || (target.dmpl__IncentivePlanId__r.dmpl__MemberType__c == MEMBER_TYPE_CUSTOMER
                && result.dmpl__AccountId__c == 
                    incentiveResource.dmpl__IncentiveResourceId__r.dmpl__AccountId__c))
            {
                If((target.dmpl__ItemId__c == null || target.dmpl__ItemId__c == result.dmpl__ItemId__c)
                    && (target.dmpl__AccountId__c == null || target.dmpl__AccountId__c == result.dmpl__AccountId__c))
                    {
                        if(target.dmpl__ItemGroupId__c != null)
                        {
                            if(!doesItemGroupContains(target.dmpl__ItemGroupId__c, target.dmpl__ItemId__c, target.dmpl__SKUId__c))
                                continue;
                        }
                    }
                    if(!accountIds.contains(result.dmpl__AccountId__c))
                    {
                        accountIds.add(result.dmpl__AccountId__c);
                        value += 1;
                        document.dmpl__NoOfUniqueInvoices__c = value;
                    }
            }
        }
        return value;
    }

    @TestVisible
    private static Double getNoOfUniqueItemsValue(IncentiveTarget__c target, dmpl__IncentiveResourceTarget__c incentiveResource)
    {
        Double value =0;
        // List<dmpl__PerformanceKPI__c> uniqueKPISummary = (List<dmpl__PerformanceKPI__c>)DocumentHelper.extractUniqueValues(periodSummary,'dmpl__ItemId__c');
        List<Id> accountIds = new List<Id>();
        for(dmpl__PerformanceKPI__c result : periodSummary){

            if(result.dmpl__IncentiveTargetId__c != target.Id)
                continue;

            if((target.dmpl__IncentivePlanId__r.dmpl__MemberType__c == MEMBER_TYPE_RESOURCE
                && result.dmpl__ResourceId__c == 
                    incentiveResource.dmpl__IncentiveResourceId__r.dmpl__ResourceId__c
                )

            || (target.dmpl__IncentivePlanId__r.dmpl__MemberType__c == MEMBER_TYPE_PARTNER
                && result.dmpl__PartnerAccountId__c == 
                    incentiveResource.dmpl__IncentiveResourceId__r.dmpl__PartnerAccountId__c)

            || (target.dmpl__IncentivePlanId__r.dmpl__MemberType__c == MEMBER_TYPE_BRANCH
                && result.dmpl__BranchId__c == 
                    incentiveResource.dmpl__IncentiveResourceId__r.dmpl__BranchId__c)

            || (target.dmpl__IncentivePlanId__r.dmpl__MemberType__c == MEMBER_TYPE_CUSTOMER
                && result.dmpl__AccountId__c == 
                    incentiveResource.dmpl__IncentiveResourceId__r.dmpl__AccountId__c))
            {
                If((target.dmpl__ItemId__c == null || target.dmpl__ItemId__c == result.dmpl__ItemId__c)
                    && (target.dmpl__AccountId__c == null || target.dmpl__AccountId__c == result.dmpl__AccountId__c))
                    {
                        if(target.dmpl__ItemGroupId__c != null)
                        {
                            if(!doesItemGroupContains(target.dmpl__ItemGroupId__c, target.dmpl__ItemId__c, target.dmpl__SKUId__c))
                                continue;
                        }
                    }
                    if(!accountIds.contains(result.dmpl__AccountId__c))
                    {
                        accountIds.add(result.dmpl__AccountId__c);
                        value += 1;
                        document.dmpl__NoOfUniqueItems__c = value;
                    }
            }
        }
        return value;
    }

    @testVisible
    private static void applyIncentiveBenefit(
        dmpl__IncentiveCompensationSlab__c compensation){
        if(compensation == null)
            return;
        //
        if(compensation.dmpl__CompensationType__c == REWARD_TYPE_FIXEDAMOUNT){
            applyFixedAmount(
                compensation);
        }
        if(compensation.dmpl__CompensationType__c == REWARD_TYPE_GIFTS){
            applyGiftRewards(
                compensation);
        }
        if(compensation.dmpl__CompensationType__c == REWARD_TYPE_SCHEMEREWARDS){
            applySchemeRewards(
                compensation);
        }
        if(compensation.dmpl__CompensationType__c == REWARD_TYPE_DISCOUNTGROUP){
            applyDiscountGroupRewards(
                compensation);
        }
        if(compensation.dmpl__CompensationType__c == REWARD_TYPE_PERUNITREWARDS){
            applyPerUnitRewards(
                compensation);
        }
        if(compensation.dmpl__CompensationType__c == REWARD_TYPE_PERCONVALUEREWARDS){
            applyPercentageOnValueRewards(
                compensation);
        }
        if(compensation.dmpl__CompensationType__c == REWARD_TYPE_PERUNITINCREMENTALREWARDS){
            applyPerUnitIncrementalRewards(
                compensation);
        }
    }

    @testVisible
    private static void applyFixedAmount(
        dmpl__IncentiveCompensationSlab__c benefit){
            document.dmpl__IncentiveAmount__c = benefit.dmpl__IncentiveFixedAmount__c;
            appliedBenefits.put(document, benefit.Id);
    }

    @testVisible
    private static void applyGiftRewards(
        dmpl__IncentiveCompensationSlab__c benefit){
            document.dmpl__Gifts__c = benefit.dmpl__Gifts__c;
            document.dmpl__GiftPoints__c = benefit.dmpl__GiftPoints__c;
            appliedBenefits.put(document, benefit.Id);
    }

    @testVisible
    private static void applySchemeRewards(
        dmpl__IncentiveCompensationSlab__c benefit){
            document.dmpl__SchemeId__c = benefit.dmpl__SchemeId__c;
            appliedBenefits.put(document, benefit.Id);
    }

    @testVisible
    private static void applyDiscountGroupRewards(
        dmpl__IncentiveCompensationSlab__c benefit){
            document.dmpl__DiscountGroupId__c = benefit.dmpl__DiscountGroupId__c;
            appliedBenefits.put(document, benefit.Id);
    }

    @testVisible
    private static void applyPerUnitRewards(
        dmpl__IncentiveCompensationSlab__c benefit){
            Double value = targetAchivedValues.get(benefit.Id);
            if(benefit.dmpl__IncentiveAmountPerUnit__c > 0 && value > 0)
                document.dmpl__IncentiveAmount__c = benefit.dmpl__IncentiveAmountPerUnit__c * value;
            appliedBenefits.put(document, benefit.Id);
    }

    @testVisible
    private static void applyPerUnitIncrementalRewards(
        dmpl__IncentiveCompensationSlab__c benefit){
            Double value = targetAchivedValues.get(benefit.Id);
            if(benefit.dmpl__IncentiveAmountPerUnit__c > 0 && value > 0)
                document.dmpl__IncentiveAmount__c = benefit.dmpl__IncentiveAmountPerUnit__c * value + benefit.dmpl__IncentiveAmountPerUnit__c * value ;
            appliedBenefits.put(document, benefit.Id);
    }

    @testVisible
    private static void applyPercentageOnValueRewards(
        dmpl__IncentiveCompensationSlab__c benefit){
            Double value = targetAchivedValues.get(benefit.Id);
            Decimal benefitAmount = benefit.dmpl__AmountPercentage__c * value/100;
            if(document.dmpl__IncentiveAmount__c == null || benefitAmount > document.dmpl__IncentiveAmount__c)
            {
                document.dmpl__IncentiveAmount__c = benefitAmount;
                appliedBenefits.put(document, benefit.Id);
            }
    }

    @testVisible
    private static Integer evaluateCurrencyOperator(
        Decimal reachedValue, 
        string operator, 
        Decimal conditionValue){
        if(operator == CONDITION_OPERATOR_GREATERTHAN_OR_EQUALS)
            return (reachedValue >= conditionValue) ? Integer.valueOf(Math.floor(reachedValue/conditionValue)):0;
        else if(operator == CONDITION_OPERATOR_GREATER_THAN)
            return (reachedValue > conditionValue) ? Integer.valueOf(Math.floor(reachedValue/conditionValue)):0;
        else if(operator == CONDITION_OPERATOR_EQUALS)
            return (reachedValue == conditionValue) ? 1 : 0;
        else if(operator == CONDITION_OPERATOR_LESSTHAN_OR_EQUALS)
            return (reachedValue <= conditionValue) ? 1 : 0;
        else if(operator == CONDITION_OPERATOR_LESS_THAN)
            return (reachedValue < conditionValue) ? 1 : 0;
        else if(operator == CONDITION_OPERATOR_DOSESNOT_EQUALS)
            return (reachedValue != conditionValue) ? 1 : 0;
        else
            return 0;
    }

    @testVisible
    private static Integer evaluateConditions(
        string filterCriteria, 
        string customLogic,
        List<Integer> conditions){
        Integer maxValue = 0;
        if(filterCriteria == DEFINITION_FILTER_CRITERIA_ALL_CONDITIONS)
        {    
            for(Integer result : conditions){
                if(result == 0){
                    return 0;
                }
                if(result > maxValue){
                    maxValue = result;
                }
            }
        }
        else if(filterCriteria == DEFINITION_FILTER_CRITERIA_ANY_CONDITION)
        {
            for(Integer result : conditions){
                if(result > maxValue){
                    maxValue  = result;
                }
            }
        } else if(filterCriteria == DEFINITION_FILTER_CRITERIA_CUSTOM_LOGIC)
        {
            System.debug('Start custom' + customLogic);
            Pattern p = Pattern.compile('\\{(.*?)\\}');
            string[] orCondtions = customLogic.split('OR');
            if(orCondtions.size()==0){
                orCondtions = new String[]{customLogic};
            }
            Integer orMaxValue = -1;
            for(string orCondition : orCondtions){
                System.debug('or condition' + orCondition);
                string[] andCondtions = orCondition.split('AND');
                if(andCondtions.size()==0){
                    andCondtions = new String[]{orCondition};
                }
                Integer andMaxValue = -1;
                for(String andCondtion : andCondtions){
                    System.debug('and condition' + andCondtion);
                    Integer result = 0;
                    Matcher m = p.matcher(andCondtion);
                    if(m.find()) {
                        Integer condIndex = Integer.valueOf(m.group(1));
                        if(condIndex > 0 && condIndex <= conditions.size()){
                            result = conditions[condIndex-1];
                        }
                        System.debug('Matched' + condIndex + ' ' + result);
                    }else {
                         System.debug('No Match');
                        return 0;
                    }
                    if(andMaxValue == -1){
                        andMaxValue  = result;
                    }else if(result < andMaxValue){
                        andMaxValue  = result;
                    }
                    System.debug('and Max Value' + andMaxValue);
                }
                if(orMaxValue == -1){
                    orMaxValue  = andMaxValue;
                }else if(andMaxValue > orMaxValue){
                    orMaxValue  = andMaxValue;
                }    
                System.debug('or Max Value' + orMaxValue);
            }
            maxValue = orMaxValue;
            System.debug('Final Max Value' + maxValue);
        }
        return maxValue;
    }

    @testVisible
    private static void ensureItemGroupRetreived(){
        if(itemGroups!=null){
            return;
        }
        itemGroups = (Map<Id, List<dmpl__ItemGroupMember__c>>)CollectionHelper.mapFromCollectionWithCollectionValues( 
            'dmpl__ItemGroupId__c',
            ItemGroupHelper.getCachedItemGroupIds(
                'Incentive', 
                CollectionHelper.extractIds(
                    periodSummary, 
                    'dmpl__ItemId__c')));
    }

    @testVisible
    private static Boolean doesItemGroupContains(
        Id lookupItemGroupId, 
        Id itemId, 
        Id sKUId){
            if(!itemGroups.containsKey(lookupItemGroupId)){
                return false;
            }
            List<dmpl__ItemGroupMember__c> igMembers = itemGroups.get(lookupItemGroupId);
            for(dmpl__ItemGroupMember__c igMember : igMembers){
                if(igMember.dmpl__ItemId__c == itemId 
                    && (igMember.dmpl__SKUId__c == null || igMember.dmpl__SKUId__c == sKUId)){
                        return true;
                    }
            }
        return false;
    }

    @testVisible
    private static List<dmpl__PerformanceKPI__c> getPeriodSummary(){

        List<String> customFieldAPINames = new List<String>();

        for(dmpl__IncentiveLine__c incetiveLine : activeIncentiveLines)
        {
            for(dmpl__IncentiveTarget__c target : incetiveLine.dmpl__IncentiveTargets__r){
                if(target.dmpl__CustomKPIFieldName__c != null && !customFieldAPINames.contains(target.dmpl__CustomKPIFieldName__c)){
                    customFieldAPINames.Add(target.dmpl__CustomKPIFieldName__c);
                }
            }
        }

        List<string> fieldList = new List<string>{
            'dmpl__AccountId__c',
            'dmpl__BranchId__c',
            'dmpl__IncentivePeriodId__c',
            'dmpl__IncentivePlanId__c',
            'dmpl__IncentiveTargetId__c',
            'dmpl__ItemId__c',
            'dmpl__PartnerAccountId__c',
            'dmpl__ResourceId__c',
            'dmpl__SchemeId__c',
            'dmpl__SchemePeriodId__c',
            'dmpl__SupplierAccountId__c',
            // 'dmpl__TargetValue__c',
            'dmpl__TotalAmount__c',
            'dmpl__TotalQuantity__c',
            'dmpl__NumberOfOrders__c',
            'dmpl__NumberOfInvoices__c',
            'dmpl__TotalSaleInvoiceAmount__c',
            'dmpl__TotalSaleOrderAmount__c',
            'dmpl__TotalRepairOrderAmount__c',
            'dmpl__TotalPurchaseOrderAmount__c',
            'dmpl__TotalBillAmount__c',
            'dmpl__TotalSaleInvoiceQuantity__c',
            'dmpl__TotalSaleOrderQuantity__c',
            'dmpl__TotalRepairOrderQuantity__c',
            'dmpl__TotalPurchaseOrderQuantity__c',
            'dmpl__TotalBillQuantity__c',
            'dmpl__NumberOfPurchaseOrders__c',
            'dmpl__NumberOfRepairOrders__c',
            'dmpl__NumberOfBills__c'
        }; 

        if(customFieldAPINames.size() > 0)
            fieldList.addAll(customFieldAPINames);

        SecurityHelper.ensureCanReadFields(fieldList, 'dmpl__PerformanceKPI__c');

        String whereClause  = 'Where (dmpl__IncentivePlanId__c =: incentivePlanId)'
                                + ' AND (dmpl__IncentivePeriodId__c =: incentivePeriodId)';
                          
        String query = 'SELECT Id,'+ String.join(fieldList , ',') +' FROM dmpl__PerformanceKPI__c ' + whereClause;

        return Database.query(query);
    }
    
    public class LineWrapper implements Comparable {

        public SObject source;
        public Boolean descending;
        public LineWrapper(SObject sourceObject, Boolean isDescending) {
            source = sourceObject;
            descending = isDescending;
        }
    
        public Integer compareTo(Object compareTo) {
            LineWrapper compareToLine = (LineWrapper)compareTo;
            Integer returnValue = 0;
            if ((Decimal)(source.get('dmpl__UnitPrice__c')) > (Decimal)(compareToLine.source.get('dmpl__UnitPrice__c'))) {
                returnValue = descending?-1:1;
            } else if ((Decimal)(source.get('dmpl__UnitPrice__c')) < (Decimal)(compareToLine.source.get('dmpl__UnitPrice__c'))) {
                returnValue = descending?1:-1;
            }    
            return returnValue;
        }
    }
}