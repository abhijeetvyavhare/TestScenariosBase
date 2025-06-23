public with sharing class SchemeReturnEngine {
    
    private static final String MULTIPLEFULFILLMENT_TREATMENT_ALL_FULFILLED = 'Apply All Fulfilled';
    private static final String MULTIPLEFULFILLMENT_TREATMENT_FIRST_FULFILLED = 'Apply First Fulfilled';
    private static final String MULTIPLEFULFILLMENT_TREATMENT_LASTFULFILLED = 'Apply Last Fulfilled';

    private static final String DEFINITION_FILTER_CRITERIA_ALWAYS_NO_CRITERIA = 'Always (No Criteria)';
    private static final String DEFINITION_FILTER_CRITERIA_ALL_CONDITIONS = 'All Conditions Are Met';
    private static final String DEFINITION_FILTER_CRITERIA_ANY_CONDITION = 'Any Condition Is Met';
    private static final String DEFINITION_FILTER_CRITERIA_CUSTOM_LOGIC = 'Custom Logic Is Met';

    private static final String REWARD_APPLICABILITY_ALL_REWARDS = 'All Rewards';
    private static final String REWARD_APPLICABILITY_ANYONE_LOWESTVALUE = 'Any One With Lowest Value';
    private static final String REWARD_APPLICABILITY_ANYONE_HIGHESTVALUE = 'Any One With Highest Value';
    private static final String REWARD_APPLICABILITY_CUSTOMLOGIC = 'Custom Logic';

    private static final String REWARD_TYPE_LL_DISCOUNT_PERCENT = 'Line Level Discount Percent';
    private static final String REWARD_TYPE_LL_DISCOUNT_AMOUNT = 'Line Level Discount Amount';
    private static final String REWARD_TYPE_DISCOUNTED_ITEM = 'Discounted Item';
    private static final String REWARD_TYPE_DISCOUNTED_ITEMGROUP = 'Discounted Item Group';
    private static final String REWARD_TYPE_REWARDPOINTS = 'Reward Points';

    private static final String CONDITION_TYPE_QUANTITY = 'Quantity';
    private static final String CONDITION_TYPE_VALUE = 'Value';
    private static final String CONDITION_TYPE_VALUE_WITHTAX = 'Value With Tax';
    private static final String CONDITION_TYPE_ITEM_QUANTITY = 'Item Quantity';
    private static final String CONDITION_TYPE_ITEM_VALUE = 'Item Value';
    private static final String CONDITION_TYPE_ITEM_VALUE_WITHTAX = 'Item Value With Tax';
    private static final String CONDITION_TYPE_ITEMGROUP_QUANTITY = 'Item Group Quantity';
    private static final String CONDITION_TYPE_ITEMGROUP_VALUE = 'Item Group Value';
    private static final String CONDITION_TYPE_ITEMGROUP_VALUE_WITHTAX = 'Item Group Value With Tax';

    private static final String CONDITION_OPERATOR_EQUALS = 'Equals';
    private static final String CONDITION_OPERATOR_DOSESNOT_EQUALS = 'Does Not Equal';
    private static final String CONDITION_OPERATOR_GREATER_THAN = 'Greater Than';
    private static final String CONDITION_OPERATOR_GREATERTHAN_OR_EQUALS = 'Greater Than Or Equal';
    private static final String CONDITION_OPERATOR_LESS_THAN = 'Less Than';
    private static final String CONDITION_OPERATOR_LESSTHAN_OR_EQUALS = 'Less Than Or Equal';

    private static final String DISCOUNTED_ITEM_RANKING_DECENDING = 'High To Low';
    private static final String SCHEMTYPE_PER_SO = 'Per Sale Order';
    private static final String SCHEMTYPE_PER_SI = 'Per Sale Invoice';
    private static final String SCHEMTYPE_PER_SOSI = 'Per Sale Order And Invoice';
    private static final String SCHEMTYPE_PERPERIOD_SI = 'Per Period Sale Invoice';
    private static final String SCHEMTYPE_PERPERIOD_SO = 'Per Period Sale Order';
    private static final String SCHEMTYPE_PER_ROSI = 'Per Repair Order And Invoice';
    private static final String STATUS_APPROVED = 'Approved';
    
    private static String adjustmentItemId;
    private static Boolean isExecuting = false;
    private Date documentDate;
    private dmpl__SaleReturn__c returnInvoice;
    private dmpl__SaleInvoice__c saleInvoice;
    private List<dmpl__SaleInvoiceLine__c> allLines;
    private List<dmpl__SaleReturnLine__c> allReturnLines;
    private Map<Id, dmpl__SaleReturnLine__c> updatedLines;
    private List<dmpl__SaleReturnLine__c> insertedLines;
    private List<dmpl__SaleReturnLine__c> deletedLines;
    private List<OrderSummaryRow> invoiceSummary;
    private List<AggregateResult> returnSummary;
    private List<dmpl__PerformanceKPI__c> periodSummary;
    private List<Id> ignoredSchemeLines;
    private Boolean isQualifying;
    private Map<Id,Integer> perDocumentResults = new Map<Id,Integer>();
    private Id partnerAccountId;
    private Id accountId;
    private Id parentAccountId;
    private List<Id> partnerAccountGroupIds;
    private List<Id> accountGroupIds;
    private Map<Id, List<dmpl__ItemGroupMember__c>> itemGroups;

    public static void processSchemeReturn(
        List<SObject> documents){
        if(isExecuting){
            return;
        }
        isExecuting = true;
        for(SObject aObject : documents){
            SchemeReturnEngine engine = new SchemeReturnEngine(
                aObject,
                false);
            engine.processSaleReturn();
        }
        isExecuting = false;
    }

    @testvisible
    private SchemeReturnEngine(
        SObject pDocument,
        Boolean pIsQualifying){
            returnInvoice = (dmpl__SaleReturn__c)pDocument;
        isQualifying = pIsQualifying;
    }
    
    @testvisible
    private Boolean processSaleReturn(){
        if(returnInvoice.dmpl__SaleInvoiceId__c == null){
            return false;
        }

        saleInvoice = getSaleInvoice(returnInvoice.dmpl__SaleInvoiceId__c);
        setDocumentDefaults();
        returnSummary = getSRSummary(returnInvoice.Id);
        invoiceSummary = getEffectiveSummary(
            getSISummary(returnInvoice.dmpl__SaleInvoiceId__c));
        
        Map<Id, dmpl__SchemeLine__c> applicableSchemeLines = new Map<Id,dmpl__SchemeLine__c>(
            getActiveSchemeLines());
        Map<Id, dmpl__SchemeLine__c> appliedSchemeLines =  new Map<Id,dmpl__SchemeLine__c>(getAppliedSchemeLines(
            queryAppliedSchemeLines(
                returnInvoice.dmpl__SaleInvoiceId__c)));
        
        updatedLines = new Map<Id, dmpl__SaleReturnLine__c>();
        insertedLines = new List<dmpl__SaleReturnLine__c>();  
        deletedLines = new List<dmpl__SaleReturnLine__c>();  
        allLines = getSILines(returnInvoice.dmpl__SaleInvoiceId__c);
        allReturnLines = getSRLines(returnInvoice.Id);

        // List<SchemeLine__c> perPeriodSchemeLines = getPerPeriodSchemeLines(activeSchemeLines);
        // List<Id> perPeriodSchemeLineIds = DocumentHelper.extractIds(perPeriodSchemeLines, 'dmpl__SchemeId__c');
        // if(perPeriodSchemeLineIds.size() > 0)
        // {
        //     List<Account> parentAccount = AccountHelper.getCachedAccounts(new List<Id>{ accountId });
        //     if(parentAccount.size()> 0 )
        //         parentAccountId = parentAccount[0].ParentId;

        //     if(parentAccountId == null)
        //         parentAccountId = accountId;
        //     //
        //     List<Account> relatedAccounts =  [SELECT Id FROM Account WHERE ParentId =: parentAccountId];
            
        //     periodSummary = getPeriodSummary(perPeriodSchemeLineIds, DocumentHelper.extractIds(relatedAccounts));
        // }

        for(SchemeLine__c  schemeLine : applicableSchemeLines.values()){
            perDocumentResults.put(
                schemeLine.Id, 
                evaluatePerDocumentSchemeLine(schemeLine));
        }
        ignoredSchemeLines = getIgnoredSchemeLines(
            perDocumentResults,
            applicableSchemeLines.values());
        //
        for(dmpl__SchemeLine__c appliedSchemeLine : appliedSchemeLines.values()){
            if(!perDocumentResults.containsKey(appliedSchemeLine.Id)
                || perDocumentResults.get(appliedSchemeLine.Id)==0){
                    revertSchemeLine(appliedSchemeLine);
            }else{
                revertSchemeLineImapct(appliedSchemeLine);
            }
        }

        // System.debug('REVERT');
        for(SchemeLine__c  schemeLine : applicableSchemeLines.values()){
            if(ignoredSchemeLines.contains(schemeLine.Id)){
                System.debug('Ignoring' + schemeLine.Name);
                dmpl__SaleReturnLine__c adjustmentLine = findAdjustmentLine(schemeLine.Id);
                if(adjustmentLine!=null){
                    deletedLines.add(adjustmentLine);
                }
                continue;
            }
            if(appliedSchemeLines.containsKey(schemeLine.Id)){
                System.debug('Already Applied' + schemeLine.Name);
                continue;
            }
            //
            System.debug('Evaluating' + schemeLine.Name);
            if(perDocumentResults.get(schemeLine.Id)>0) {
                if(schemeLine.dmpl__SchemeId__r.dmpl__Application__c == 'Auto Apply'){
                    System.debug('Applying' + schemeLine.Name);
                    applyPerDocumentSchemeLine(
                        schemeLine,
                        perDocumentResults.get(schemeLine.Id));    
                }
            }
        }
        //
        updateLines();
        insertLines();
        postSchemeLeders();   
        return false;
    }
	
    @testVisible
    private void updateLines()
        {
            if(updatedLines.size()>0)
                update updatedLines.values();
            if(deletedLines.size()>0){
                delete deletedLines;
            }
        }
    private void insertLines()
    {
        if(insertedLines.size()>0)
            insert insertedLines;
    }
    
    private void postSchemeLeders(){
        // if(schemeType == SCHEMTYPE_PER_SO || perPeriodSchemeType == SCHEMTYPE_PERPERIOD_SO){
        //     postSOSchemeLeders();
        // } else if(schemeType == SCHEMTYPE_PER_PO || perPeriodSchemeType == SCHEMTYPE_PERPERIOD_PO){
        //     postPOSchemeLeders();
        // } else if(schemeType == SCHEMTYPE_PER_SI || perPeriodSchemeType == SCHEMTYPE_PERPERIOD_SI){
        //     postSISchemeLeders();
        // } else if(schemeType == SCHEMTYPE_PER_BILL || perPeriodSchemeType == SCHEMTYPE_PERPERIOD_BILL){
        //     postBillSchemeLeders();
        // } else if(schemeType == SCHEMTYPE_PER_RO || perPeriodSchemeType == SCHEMTYPE_PERPERIOD_RO){
        //     postROSchemeLeders();
        // }
    }
    
    @testvisible
    private void revertSchemeLine(dmpl__SchemeLine__c appliedSchemeLine){
        Map<Id, dmpl__SaleInvoiceLine__c> allLinesMap = new Map<Id, dmpl__SaleInvoiceLine__c>(allLines);
        
        for(dmpl__SaleReturnLine__c returnLine : allReturnLines){
            if(returnLine.dmpl__SchemeLineId__c == appliedSchemeLine.Id){
                returnLine.dmpl__SchemeDiscount__c = null;
                returnLine.dmpl__SchemeDiscountAmount__c = null;
                if(returnLine.Id != null && !updatedLines.containsKey(returnLine.Id))
                    updatedLines.put(returnLine.Id, returnLine);
            }
        }

        dmpl__SaleReturnLine__c adjustmentLine = getAdjustmentLine(appliedSchemeLine.Id);
        adjustmentLine.dmpl__SchemeDiscountAmount__c = 0;
        adjustmentLine.dmpl__SchemeDiscount__c = 0;
        
        for(dmpl__SaleInvoiceLine__c invoiceLine : allLines){
            if(invoiceLine.dmpl__SchemeLineId__c != appliedSchemeLine.Id){
                continue;
            }
            if(invoiceLine.dmpl__SchemeDiscount__c !=null){
                adjustmentLine.dmpl__SchemeDiscountAmount__c += (invoiceLine.dmpl__SchemeDiscount__c * invoiceLine.dmpl__BaseAmount__c/100);
            }
            if(invoiceLine.dmpl__SchemeDiscountAmount__c !=null){
                adjustmentLine.dmpl__SchemeDiscountAmount__c += invoiceLine.dmpl__SchemeDiscount__c;
            }
        }
    }

    @testvisible
    private void revertSchemeLineImapct(dmpl__SchemeLine__c appliedSchemeLine){
        Map<Id, dmpl__SaleInvoiceLine__c> allLinesMap = new Map<Id, dmpl__SaleInvoiceLine__c>(allLines);
        for(dmpl__SaleReturnLine__c returnLine : allReturnLines){
            if(returnLine.dmpl__SaleInvoiceLineId__c !=null){
                dmpl__SaleInvoiceLine__c invoiceLine = allLinesMap.get(returnLine.dmpl__SaleInvoiceLineId__c);
                if(invoiceLine == null 
                    || invoiceLine.dmpl__SchemeLineId__c != appliedSchemeLine.Id){
                        continue;
                    }
                if(invoiceLine.dmpl__SchemeDiscount__c !=null){
                    returnLine.dmpl__SchemeDiscount__c = invoiceLine.dmpl__SchemeDiscount__c;
                }
                if(invoiceLine.dmpl__SchemeDiscountAmount__c !=null){
                    returnLine.dmpl__SchemeDiscountAmount__c = ((Decimal)(invoiceLine.dmpl__SchemeDiscountAmount__c 
                        * (returnLine.dmpl__Quantity__c/invoiceLine.dmpl__Quantity__c))).setScale(2);
                }
                if(returnLine.Id != null && !updatedLines.containsKey(returnLine.Id)){
                    updatedLines.put(returnLine.Id, returnLine);
                }
            }
        }

        dmpl__SaleReturnLine__c adjustmentLine = findAdjustmentLine(appliedSchemeLine.Id);
        if(adjustmentLine!=null){
            deletedLines.add(adjustmentLine);
        }
    }

    private dmpl__SaleReturnLine__c getAdjustmentLine(Id schemeLineId){
        dmpl__SaleReturnLine__c adjustmentLine = findAdjustmentLine(schemeLineId);        
        IF(adjustmentLine == null){
            adjustmentLine = new dmpl__SaleReturnLine__c(
                dmpl__ItemId__c = adjustmentItemId,
                dmpl__SchemeLineId__c = schemeLineId,
                dmpl__SaleReturnId__c = returnInvoice.Id,
                dmpl__SaleInvoiceId__c = saleInvoice.Id
            );
            insertedLines.add(adjustmentLine);
        }
        return adjustmentLine;
    }

    private dmpl__SaleReturnLine__c findAdjustmentLine(Id schemeLineId){
        for(dmpl__SaleReturnLine__c line : allReturnLines){
            if(line.dmpl__SchemeLineId__c == schemeLineId 
                && line.dmpl__ItemId__c == adjustmentItemId){
                    if(line.dmpl__SchemeLineId__c !=null 
                    && !updatedLines.containsKey(line.Id))
                    updatedLines.put(line.Id, line);
                    return line;
            }
        }
        return null;
    }

    @testVisible
    private void applyPerDocumentSchemeLine(
        SchemeLine__c schemeLine, 
        Integer qualifyingCount){

        string periodType = schemeLine.dmpl__SchemeId__r.dmpl__PeriodType__c;
        if(schemeLine.RewardApplicability__c == REWARD_APPLICABILITY_ALL_REWARDS){
            for(SchemeBenefit__c  benefit : schemeLine.SchemeBenefits__r){
                applyPerDocumentBenefit(
                    benefit, 
                    qualifyingCount,
                    periodType);
            }
        } else if(schemeLine.RewardApplicability__c == REWARD_APPLICABILITY_ANYONE_LOWESTVALUE){
            applyPerDocumentBenefit(
                getMinimumBenefit(schemeLine), 
                qualifyingCount,
                periodType);
        } else if(schemeLine.RewardApplicability__c == REWARD_APPLICABILITY_ANYONE_HIGHESTVALUE){
            applyPerDocumentBenefit(
                getMaximumBenefit(schemeLine),
                qualifyingCount,
                periodType);
        } else if(schemeLine.RewardApplicability__c == REWARD_APPLICABILITY_CUSTOMLOGIC){
        }
    }

    @testvisible
    private void applyPerDocumentBenefit(
        SchemeBenefit__c benefit, 
        Integer qualifyingCount,
        String periodType){
        if(benefit == null){
            return;
        }
        //
        dmpl__SaleReturnLine__c adjustmentLine = getAdjustmentLine(benefit.dmpl__SchemeLineId__c);
        adjustmentLine.dmpl__SchemeDiscountAmount__c = 0;
        adjustmentLine.dmpl__SchemeDiscount__c = 0;
        //
        if(benefit.RewardType__c == REWARD_TYPE_LL_DISCOUNT_PERCENT){
            applyDocumentDiscountPercent(
                adjustmentLine,
                benefit);
        }else if(benefit.RewardType__c == REWARD_TYPE_LL_DISCOUNT_AMOUNT){
            applyDocumentDiscountAmount(
                adjustmentLine,
                benefit);
        }else if(benefit.RewardType__c == REWARD_TYPE_DISCOUNTED_ITEM){
            applyDocumentDiscountdItem(
                adjustmentLine,
                benefit,
                benefit.dmpl__RepeatReward__c ? qualifyingCount : qualifyingCount > 0 ? 1 : 0,
                false,
                periodType);
        }else if(benefit.RewardType__c == REWARD_TYPE_DISCOUNTED_ITEMGROUP){
            applyDocumentDiscountdItem(
                adjustmentLine,
                benefit, 
                benefit.dmpl__RepeatReward__c ? qualifyingCount : qualifyingCount > 0 ? 1 : 0,
                true,
                periodType);
        }else if(benefit.RewardType__c == REWARD_TYPE_REWARDPOINTS){
            applyDocumentRewardPoints(
                adjustmentLine,
                benefit);
        }
    }

    @testvisible
    private SchemeBenefit__c getMinimumBenefit(SchemeLine__c schemeLine){
        SchemeBenefit__c minBenefit = null;
        Decimal minBenefitValue = 0;
        for(SchemeBenefit__c  benefit : schemeLine.SchemeBenefits__r){
            if(benefit.RewardType__c == REWARD_TYPE_LL_DISCOUNT_AMOUNT){
                if(benefit.DiscountAmount__c < minBenefitValue || minBenefitValue == 0){
                    minBenefitValue = benefit.DiscountAmount__c;
                    minBenefit = benefit;
                }
            }else if(benefit.RewardType__c == REWARD_TYPE_LL_DISCOUNT_PERCENT){
                if(benefit.DiscountPercent__c < minBenefitValue || minBenefitValue == 0){
                    minBenefitValue = benefit.DiscountPercent__c;
                    minBenefit = benefit;
                }
            }else if(benefit.RewardType__c == REWARD_TYPE_REWARDPOINTS){
                if(benefit.dmpl__RewardPoints__c < minBenefitValue || minBenefitValue == 0){
                    minBenefitValue = benefit.dmpl__RewardPoints__c;
                    minBenefit = benefit;
                }
            }
        }
        If(minBenefit == null && schemeLine.SchemeBenefits__r.size()>0){
            minBenefit = schemeLine.SchemeBenefits__r[0];
        }
        return minBenefit;
    }

    @testVisible
    private SchemeBenefit__c getMaximumBenefit(SchemeLine__c schemeLine){
        SchemeBenefit__c maxBenefit = null;
        Decimal maxBenefitValue = 0;
        for(SchemeBenefit__c  benefit : schemeLine.SchemeBenefits__r){
            if(benefit.RewardType__c ==  REWARD_TYPE_LL_DISCOUNT_AMOUNT){
                if(benefit.DiscountAmount__c > maxBenefitValue){
                    maxBenefitValue = benefit.DiscountAmount__c;
                    maxBenefit = benefit;
                }
            }else if(benefit.RewardType__c == REWARD_TYPE_LL_DISCOUNT_PERCENT){
                if(benefit.DiscountPercent__c > maxBenefitValue){
                    maxBenefitValue = benefit.DiscountPercent__c;
                    maxBenefit = benefit;
                }
            }else if(benefit.RewardType__c == REWARD_TYPE_REWARDPOINTS){
                if(benefit.dmpl__RewardPoints__c > maxBenefitValue){
                    maxBenefitValue = benefit.dmpl__RewardPoints__c;
                    maxBenefit = benefit;
                }
            }
        }
        If(maxBenefit == null && schemeLine.SchemeBenefits__r.size()>0){
            maxBenefit = schemeLine.SchemeBenefits__r[schemeLine.SchemeBenefits__r.size()-1];
        }
        return maxBenefit;
    }

    @testVisible
    private void applyDocumentDiscountPercent(
        dmpl__SaleReturnLine__c adjustmentLine,
        SchemeBenefit__c benefit){
        if(adjustmentLine.dmpl__SchemeDiscountAmount__c == null){
            adjustmentLine.dmpl__SchemeDiscountAmount__c =0;
        }
        //reduce quantity that is returned
        for(dmpl__SaleInvoiceLine__c line : allLines) {
            adjustmentLine.dmpl__SchemeDiscountAmount__c -= (benefit.dmpl__DiscountPercent__c * line.dmpl__BaseAmount__c/100);
        }
        for(dmpl__SaleReturnLine__c returnLine : allReturnLines) {
            if(returnLine.dmpl__ItemId__c != adjustmentItemId){
                adjustmentLine.dmpl__SchemeDiscountAmount__c += (benefit.dmpl__DiscountPercent__c * returnLine.dmpl__BaseAmount__c/100);
            }
        }
    }

    @TestVisible
    private void applyDocumentDiscountAmount(
        dmpl__SaleReturnLine__c adjustmentLine,
        SchemeBenefit__c benefit){
        Decimal totalAmount = 0;
        for(dmpl__SaleInvoiceLine__c line : allLines) {
            totalAmount += (Decimal)line.get('dmpl__BaseAmount__c');
        }
        if(totalAmount == 0){
            return;
        }
        if(adjustmentLine.dmpl__SchemeDiscountAmount__c == null){
            adjustmentLine.dmpl__SchemeDiscountAmount__c =0;
        }
        for(dmpl__SaleInvoiceLine__c line : allLines) {
            Decimal lineAmount = (benefit.dmpl__DiscountAmount__c * ((Decimal)line.get('dmpl__BaseAmount__c')/totalAmount));
            adjustmentLine.dmpl__SchemeDiscountAmount__c -= lineAmount.setScale(2);
        }
        for(dmpl__SaleReturnLine__c returnLine : allReturnLines) {
            if(returnLine.dmpl__ItemId__c != adjustmentItemId){
                Decimal lineAmount = (benefit.dmpl__DiscountAmount__c * ((Decimal)returnLine.dmpl__BaseAmount__c/totalAmount));
                adjustmentLine.dmpl__SchemeDiscountAmount__c += lineAmount.setScale(2);
            }
        }
    }

    @TestVisible
    private void applyDocumentRewardPoints(
        dmpl__SaleReturnLine__c adjustmentLine,
        SchemeBenefit__c benefit){
        for(dmpl__SaleInvoiceLine__c line : allLines) {
            adjustmentLine.dmpl__SchemeRewardPoints__c -=  benefit.dmpl__RewardPoints__c;
            if(adjustmentLine.Id != null && !updatedLines.containsKey(adjustmentLine.Id))
                updatedLines.put(adjustmentLine.Id, adjustmentLine);
        }
    }

    @testvisible
    private void applyDocumentDiscountdItem(
        dmpl__SaleReturnLine__c adjustmentLine,
        SchemeBenefit__c benefit, 
        Integer qualifyingCount,
        Boolean isItemGroup,
        String periodType){
        
        Double quantityToDiscount = benefit.dmpl__DiscountedItemQuantity__c == null 
        ? 99999 : benefit.dmpl__DiscountedItemQuantity__c;
        
        quantityToDiscount = quantityToDiscount * qualifyingCount;
        System.debug('Starting Item Discount');
        if(isItemGroup){
            ensureItemGroupRetreived(periodType == 'Per order' ? periodType : 'Per Period');
            for(dmpl__SaleInvoiceLine__c line : allLines) {
                if(doesItemGroupContains(
                    benefit.dmpl__DiscountedItemGroupId__c, 
                    line.dmpl__ItemId__c,
                    line.dmpl__SKUId__c,
                    line.dmpl__ItemLotTypeId__c)){
                        adjustmentLine.dmpl__SchemeDiscountAmount__c -= (benefit.dmpl__DiscountPercent__c * quantityToDiscount * line.dmpl__UnitPrice__c/100);
                        return;    
                    }
            }
        }else{
            for(dmpl__SaleInvoiceLine__c line : allLines) {
                if(line.dmpl__ItemId__c == benefit.dmpl__DiscountedItemId__c){
                    adjustmentLine.dmpl__SchemeDiscountAmount__c -= (benefit.dmpl__DiscountPercent__c * quantityToDiscount * line.dmpl__UnitPrice__c/100);
                    return;
                }
            }
        }
    }

    @testvisible
    private List<Id> getIgnoredSchemeLines(
        Map<Id,Integer> perDocumentResults,
        List<dmpl__SchemeLine__c> activeSchemeLines){
        List<Id> ignoredSchemeLines = new List<Id>();
        Map<Id, SchemeLine__c> consolidatedSchemes = new Map<Id, SchemeLine__c>();
        for(SchemeLine__c  schemeLine : activeSchemeLines){
            if(schemeLine == null){
                continue;
            }
            
            if((perDocumentResults.get(schemeLine.Id) != null 
                    && perDocumentResults.get(schemeLine.Id)==0) 
                || schemeLine.SchemeId__r.MultipleFulfilmentTreatment__c == MULTIPLEFULFILLMENT_TREATMENT_ALL_FULFILLED){
                continue;
            }else if(schemeLine.SchemeId__r.MultipleFulfilmentTreatment__c == MULTIPLEFULFILLMENT_TREATMENT_FIRST_FULFILLED){
                if(consolidatedSchemes.containsKey(schemeLine.SchemeId__r.Id)){
                    ignoredSchemeLines.add(schemeLine.Id);
                }
                else {
                    consolidatedSchemes.put(
                        schemeLine.SchemeId__r.Id, 
                        schemeLine);
                }
            }else if(schemeLine.SchemeId__r.MultipleFulfilmentTreatment__c == MULTIPLEFULFILLMENT_TREATMENT_LASTFULFILLED){
                if(consolidatedSchemes.containsKey(schemeLine.SchemeId__r.Id)){
                    SchemeLine__c oldLine = consolidatedSchemes.put(
                        schemeLine.SchemeId__r.Id, 
                        schemeLine);
                    ignoredSchemeLines.add(oldLine.Id);
                }else {
                    consolidatedSchemes.put(
                        schemeLine.SchemeId__r.Id, 
                        schemeLine);
                }
            }
        }
        //
        return ignoredSchemeLines;
    }

    @testvisible
    private Integer evaluatePerDocumentSchemeLine(
        SchemeLine__c schemeLine){
        if(schemeLine.DefinitionFilterCriteria__c == DEFINITION_FILTER_CRITERIA_ALWAYS_NO_CRITERIA){
            return 1;
        }
        //
        List<Integer> conditionResults = new List<Integer>();
        for(SchemeCondition__c  condition : schemeLine.SchemeConditions__r){
            conditionResults.add(
                evaluatePerDocumentCondition(condition));
        }
        //
       return evaluateConditions(
           schemeLine.DefinitionFilterCriteria__c, 
           schemeLine.dmpl__DefinitionCustomLogic__c, 
           conditionResults);
    }

    @testVisible
    private Integer evaluatePerDocumentCondition(
        SchemeCondition__c condition){
        if(condition.ConditionType__c == CONDITION_TYPE_QUANTITY){
            return evaluateNumberOperator(
                getTotalQuantity(condition), 
                condition.ConditionOperator__c, 
                condition.ConditionQuantity__c);
        }
        else if(condition.ConditionType__c == CONDITION_TYPE_VALUE){
            return evaluateCurrencyOperator(
                getTotalValue(condition, false), 
                condition.ConditionOperator__c, 
                condition.ConditionValue__c);
        }
        else if(condition.ConditionType__c == CONDITION_TYPE_VALUE_WITHTAX){
            return evaluateCurrencyOperator(
                getTotalValue(condition, true), 
                condition.ConditionOperator__c, 
                condition.ConditionValue__c);
        }
        else if(condition.ConditionType__c == CONDITION_TYPE_ITEM_QUANTITY){
            return evaluateNumberOperator(
                getTotalItemQuantity(condition), 
                condition.ConditionOperator__c, 
                condition.ConditionQuantity__c);            
        }
        else if(condition.ConditionType__c == CONDITION_TYPE_ITEM_VALUE){
            return evaluateCurrencyOperator(
                getTotalItemValue(
                    condition, 
                    false), 
                condition.ConditionOperator__c, 
                condition.ConditionValue__c);            
        }
        else if(condition.ConditionType__c == CONDITION_TYPE_ITEM_VALUE_WITHTAX){
            return evaluateCurrencyOperator(
                getTotalItemValue(
                    condition,
                    true), 
                condition.ConditionOperator__c, 
                condition.ConditionValue__c);            
        }
        else if(condition.ConditionType__c == CONDITION_TYPE_ITEMGROUP_QUANTITY){
            return evaluateNumberOperator(
                getTotalItemGroupQuantity(condition), 
                condition.ConditionOperator__c, 
                condition.ConditionQuantity__c);            
        }
        else if(condition.ConditionType__c == CONDITION_TYPE_ITEMGROUP_VALUE){
            return evaluateCurrencyOperator(
                getTotalItemGroupValue(
                    condition,
                    false),
                condition.ConditionOperator__c, 
                condition.ConditionValue__c);
        }
        else if(condition.ConditionType__c == CONDITION_TYPE_ITEMGROUP_VALUE_WITHTAX){
            return evaluateCurrencyOperator(
                getTotalItemGroupValue(
                    condition,
                    true),
                condition.ConditionOperator__c, 
                condition.ConditionValue__c);
        }
        return 0;
    }

    @testVisible
    private Integer evaluateNumberOperator(
        Double reachedValue, 
        string operator, 
        Decimal conditionValue){
        if(operator == CONDITION_OPERATOR_GREATERTHAN_OR_EQUALS)
            return (reachedValue >= conditionValue) && (conditionValue>0) ? Integer.valueOf(Math.floor(reachedValue/conditionValue)):0;
        else if(operator == CONDITION_OPERATOR_GREATER_THAN)
            return (reachedValue > conditionValue) && (conditionValue>0) ? Integer.valueOf(Math.floor(reachedValue/conditionValue)):0;
        else if(operator == CONDITION_OPERATOR_EQUALS)
            return (reachedValue == conditionValue)? 1 : 0;
        else if(operator == CONDITION_OPERATOR_LESSTHAN_OR_EQUALS)
            return (reachedValue <= conditionValue)? 1:0;
        else if(operator == CONDITION_OPERATOR_LESS_THAN)
            return (reachedValue < conditionValue) ? 1:0;
        else if(operator == CONDITION_OPERATOR_DOSESNOT_EQUALS)
            return (reachedValue != conditionValue)?1:0;
        else
            return 0;
    }

    @testVisible
    private Integer evaluateCurrencyOperator(
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

    @testvisible
    private Integer evaluateConditions(
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

    @TestVisible
    private Double getTotalQuantity(SchemeCondition__c condition)
    {
        Double totalQuantity =0;
        for(OrderSummaryRow result : invoiceSummary){
            if((condition.dmpl__AccountId__c == null
                    || condition.dmpl__AccountId__c == accountId)
                && (condition.dmpl__AccountGroupId__c == null
                    || accountGroupIds.contains(condition.dmpl__AccountGroupId__c))){
                totalQuantity += result.TotalQuantity;
            }
        }
        return totalQuantity;
    }

    @TestVisible
    private Double getTotalItemQuantity(SchemeCondition__c condition)
    {
        Double totalQuantity =0;
        for(OrderSummaryRow result : invoiceSummary){
            if((condition.dmpl__ItemId__c == result.ItemId)
                && (condition.dmpl__ItemSKUId__c == null
                    || condition.dmpl__ItemSKUId__c == result.SKUId)
                && (condition.dmpl__ItemLotTypeId__c == null
                    || condition.dmpl__ItemLotTypeId__c == result.ItemLotTypeId)
                && (condition.dmpl__AccountId__c == null
                    || condition.dmpl__AccountId__c == accountId)
                && (condition.dmpl__AccountGroupId__c == null
                    || accountGroupIds.contains(condition.dmpl__AccountGroupId__c))){
                        totalQuantity += result.TotalQuantity;
            }
        }
        return totalQuantity;
    }

    @TestVisible
    private Double getTotalItemGroupQuantity(SchemeCondition__c condition)
    {
        Double totalQuantity =0;
        ensureItemGroupRetreived('Per order');
        for(OrderSummaryRow result : invoiceSummary){
            if(doesItemGroupContains(
                condition.dmpl__ItemGroupId__c, 
                result.ItemId,
                result.SKUId,
                result.ItemLotTypeId)
                && (condition.dmpl__AccountId__c == null
                    || condition.dmpl__AccountId__c == accountId)
                && (condition.dmpl__AccountGroupId__c == null
                    || accountGroupIds.contains(condition.dmpl__AccountGroupId__c))){
                    totalQuantity += result.TotalQuantity;
                }
        }
        return totalQuantity;
    }

    @TestVisible
    private Decimal getTotalValue(
        SchemeCondition__c condition, 
        Boolean includeTax)
    {
        Decimal totalValue =0;
        for(OrderSummaryRow result : invoiceSummary){
            if((condition.dmpl__AccountId__c == null
                    || condition.dmpl__AccountId__c == accountId)
                && (condition.dmpl__AccountGroupId__c == null
                    || accountGroupIds.contains(condition.dmpl__AccountGroupId__c))){
                        totalValue += result.TotalAmount;
                        if(includeTax){
                            totalValue += result.TaxAmount == null ? 0 : result.TaxAmount;            
                    }
            }    
        }
        return totalValue;
    }

    @TestVisible
    private Decimal getTotalItemValue(
        SchemeCondition__c condition,
        Boolean includeTax)
    {
        Decimal totalValue =0;
        for(OrderSummaryRow result : invoiceSummary){
            if((condition.dmpl__ItemId__c == result.ItemId)
                && (condition.dmpl__ItemSKUId__c == null
                    || condition.dmpl__ItemSKUId__c == result.SKUId)
                && (condition.dmpl__ItemLotTypeId__c == null
                    || condition.dmpl__ItemLotTypeId__c == result.ItemLotTypeId)
                && (condition.dmpl__AccountId__c == null
                    || condition.dmpl__AccountId__c == accountId)
                && (condition.dmpl__AccountGroupId__c == null
                    || accountGroupIds.contains(condition.dmpl__AccountGroupId__c))){
                    totalValue += result.TotalAmount;
                    if(includeTax){
                        totalValue += result.TaxAmount;
                }    
            }
        }
        return totalValue;
    }

    @TestVisible
    private Decimal getTotalItemGroupValue(
        SchemeCondition__c condition,
        Boolean includeTax)
    {
        Decimal totalValue =0;
        ensureItemGroupRetreived('Per order');
        for(OrderSummaryRow result : invoiceSummary){
            if(doesItemGroupContains(
                condition.dmpl__ItemGroupId__c, 
                result.ItemId,
                result.SKUId,
                result.ItemLotTypeId)
                && (condition.dmpl__AccountId__c == null
                    || condition.dmpl__AccountId__c == accountId)
                && (condition.dmpl__AccountGroupId__c == null
                    || accountGroupIds.contains(condition.dmpl__AccountGroupId__c))){
                    totalValue += result.TotalAmount;
                    if(includeTax){
                        totalValue += result.TaxAmount == null ? 0 : result.TaxAmount;
                    }    
            }
        }
        return totalValue;
    }

    private List<OrderSummaryRow> getEffectiveSummary(
        List<AggregateResult> invSummary){
            List<OrderSummaryRow> summaryRows = new List<OrderSummaryRow>();
            for(AggregateResult result : invSummary){
                OrderSummaryRow summaryRow = new OrderSummaryRow(
                    (Id)result.get('dmpl__ItemId__c'),
                    (Id)result.get('dmpl__SKUId__c'),
                    (Id)result.get('dmpl__ItemLotTypeId__c'),
                    (Double)result.get('TotalQuantity'),
                    (Double)result.get('TotalAmount'),
                    (Double)result.get('TaxAmount')
                );
                for(AggregateResult returnResult : returnSummary){
                    if(summaryRow.ItemId == (Id)returnResult.get('dmpl__ItemId__c') 
                    && summaryRow.SKUId == (Id)returnResult.get('dmpl__SKUId__c') 
                    && summaryRow.ItemLotTypeId == (Id)returnResult.get('dmpl__ItemLotTypeId__c')){
                        summaryRow.TotalAmount -=(Double)returnResult.get('TotalAmount');
                        summaryRow.TotalQuantity -=(Double)returnResult.get('TotalQuantity');
                        summaryRow.TaxAmount -=(Double)returnResult.get('TaxAmount');
                    } 
                }
                summaryRows.add(summaryRow);
            }
            return summaryRows;
    }

    @testVisible
    private void ensureItemGroupRetreived(string schemeType){
        if(itemGroups!=null && itemGroups.size() > 0){
            return;
        }
        itemGroups = (Map<Id, List<dmpl__ItemGroupMember__c>>)CollectionHelper.mapFromCollectionWithCollectionValues( 
            'dmpl__ItemGroupId__c',
            ItemGroupHelper.getCachedItemGroupIds(
                'Scheme', 
                schemeType == 'Per order' ? extractItemIds(
                                                invoiceSummary)
                                            : CollectionHelper.extractIds(
                                                periodSummary, 
                                                'dmpl__ItemId__c')));
    }

    @testVisible
    private Boolean doesItemGroupContains(
        Id lookupItemGroupId, 
        Id itemId, 
        Id sKUId, 
        Id itemLotTypeId){
            if(!itemGroups.containsKey(lookupItemGroupId)){
                return false;
            }
            List<dmpl__ItemGroupMember__c> igMembers = itemGroups.get(lookupItemGroupId);
            for(dmpl__ItemGroupMember__c igMember : igMembers){
                if(igMember.dmpl__ItemId__c == itemId 
                    && (igMember.dmpl__SKUId__c == null || igMember.dmpl__SKUId__c == sKUId)
                    && (igMember.dmpl__LotTypeId__c == null || igMember.dmpl__LotTypeId__c == itemLotTypeId)){
                        return true;
                    }
            }
        return false;
    }

    @TestVisible
    private List<Id> queryAppliedSchemeLines(
        Id saleInvoiceId){
        return CollectionHelper.extractIds([
            SELECT
                dmpl__SchemeLineId__c
            FROM    
                dmpl__SaleInvoiceLine__c
            WHERE 
                dmpl__SaleInvoiceId__c = :saleInvoiceId
                AND (dmpl__SchemeLineId__r.dmpl__SchemeId__r.dmpl__SchemeType__c = 'Per Sale Invoice'
                    OR dmpl__SchemeLineId__r.dmpl__SchemeId__r.dmpl__SchemeType__c = 'Per Sale Order And Invoice')
            GROUP BY dmpl__SchemeLineId__c
        ], 'dmpl__SchemeLineId__c');
    }
    
    private dmpl__SaleInvoice__c getSaleInvoice(Id invoiceId){
        return [SELECT 
            Id, 
            Name, 
            dmpl__DocumentDate__c,
            dmpl__Status__c,
            dmpl__PartnerAccountId__c,
            dmpl__BranchId__c,
            dmpl__PriceListId__c,
            dmpl__TaxSupplyType__c,
            dmpl__AccountId__c 
        From dmpl__SaleInvoice__c WHERE Id = :invoiceId];
    }

    private void setDocumentDefaults(){
        if(returnInvoice == null){
            return;
        }
        adjustmentItemId = OrgSettingHelper.getSchemeAdjustmentItemId();
        accountId = saleInvoice.dmpl__AccountId__c;
        partnerAccountId = saleInvoice.dmpl__PartnerAccountId__c;
        documentDate = saleInvoice.dmpl__DocumentDate__c;
        accountGroupIds = AccountGroupHelper.getCachedAccountGroupIds(
            'Scheme',
            accountId);
        partnerAccountGroupIds = AccountGroupHelper.getCachedAccountGroupIds(
            'Scheme',
            partnerAccountId);
    }

    @testvisible
    private List<dmpl__SaleInvoiceLine__c> getSILines(Id documentId){
        SecurityHelper.ensureCanReadFields(new string[]
        {
            'dmpl__SchemeLineId__c',
            'dmpl__SchemeDiscount__c',
            'dmpl__SchemeDiscountAmount__c',
            'dmpl__NetSchemeDiscount__c',
            'dmpl__BaseAmount__c',
            'dmpl__ItemId__c',
            'dmpl__SKUId__c',
            'dmpl__ItemLotTypeId__c',
            'dmpl__Quantity__c',
            'dmpl__UnitPrice__c',
            'dmpl__SchemeRewardPoints__c'
        }, 'dmpl__SaleInvoiceLine__c');
        return 
        [
            SELECT
                Id,
                dmpl__SchemeLineId__c,
                dmpl__SchemeDiscount__c,
                dmpl__SchemeDiscountAmount__c,
                dmpl__NetSchemeDiscount__c,
                dmpl__BaseAmount__c,
                dmpl__ItemId__c,
                dmpl__SKUId__c,
                dmpl__ItemLotTypeId__c,
                dmpl__Quantity__c,
                dmpl__UnitPrice__c,
                dmpl__SaleInvoiceId__r.dmpl__PartnerAccountId__c,
                dmpl__SaleInvoiceId__r.dmpl__BranchId__c,
                dmpl__SchemeRewardPoints__c
            FROM
                dmpl__SaleInvoiceLine__c
            WHERE
                dmpl__SaleInvoiceId__c =: documentId
        ];
    }
    
    @testvisible
    private List<dmpl__SaleReturnLine__c> getSRLines(
        Id documentId){
        SecurityHelper.ensureCanReadFields(new string[]
        {
            'dmpl__SchemeLineId__c',
            'dmpl__SchemeDiscount__c',
            'dmpl__SchemeDiscountAmount__c',
            'dmpl__NetSchemeDiscount__c',
            'dmpl__BaseAmount__c',
            'dmpl__ItemId__c',
            'dmpl__SKUId__c',
            'dmpl__ItemLotTypeId__c',
            'dmpl__Quantity__c',
            'dmpl__UnitPrice__c',
            'dmpl__SaleInvoiceLineId__c',
            'dmpl__SchemeRewardPoints__c'
        }, 'dmpl__SaleReturnLine__c');
        return
        [
            SELECT
                Id,
                dmpl__SchemeLineId__c,
                dmpl__SchemeDiscount__c,
                dmpl__SchemeDiscountAmount__c,
                dmpl__NetSchemeDiscount__c,
                dmpl__BaseAmount__c,
                dmpl__ItemId__c,
                dmpl__SKUId__c,
                dmpl__ItemLotTypeId__c,
                dmpl__Quantity__c,
                dmpl__UnitPrice__c,
                dmpl__SaleInvoiceLineId__c,
                dmpl__SaleReturnId__r.dmpl__PartnerAccountId__c,
                dmpl__SaleReturnId__r.dmpl__BranchId__c,
                dmpl__SchemeRewardPoints__c
            FROM
                dmpl__SaleReturnLine__c
            WHERE
                dmpl__SaleReturnId__c =: documentId
        ];
    }

    @testvisible
    private List<dmpl__SchemeLine__c> getActiveSchemeLines(){
        List<String> schemeTypes = new List<String>();
        schemeTypes.add(SCHEMTYPE_PER_SI);
        schemeTypes.add(SCHEMTYPE_PER_SOSI);
        schemeTypes.add(SCHEMTYPE_PER_ROSI);
        schemeTypes.add(SCHEMTYPE_PERPERIOD_SI);
        schemeTypes.add(SCHEMTYPE_PERPERIOD_SO);
        SecurityHelper.ensureCanReadFields(new string[]
        {
            'dmpl__SchemeType__c',
            'dmpl__PeriodType__c',
            'dmpl__SchemeBudget__c',
            'dmpl__UtilizedAmount__c',
            'dmpl__MultipleFulfilmentTreatment__c',
            'dmpl__IncludeChildAccountTransactions__c',
            'dmpl__IncludeRelatedAccountTransactions__c'
        }, 'dmpl__Scheme__c');
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
                'dmpl__ItemLotTypeId__c',
                'dmpl__ConditionQuantity__c',
                'dmpl__ConditionValue__c',
                'dmpl__SequenceNumber__c'
            }, 'dmpl__SchemeCondition__c');
            SecurityHelper.ensureCanReadFields(new string[]
            {
                'dmpl__SchemeLineId__c',
                'dmpl__DiscountAmount__c',
                'dmpl__DiscountPercent__c',
                'dmpl__DiscountedItemId__c',
                'dmpl__DiscountedItemSKUId__c',
                'dmpl__DiscountedItemGroupId__c',
                'dmpl__DiscountedItemQuantity__c',
                'dmpl__RewardPoints__c',
                'dmpl__RewardType__c',
                'dmpl__RepeatReward__c',
                'dmpl__ExcludeQualifyingItems__c',
                'dmpl__SequenceNumber__c'
            }, 'dmpl__SchemeBenefit__c');
        return 
        [
            SELECT
            Id,
            Name,
            dmpl__Title__c,
            dmpl__DefinitionFilterCriteria__c,
            dmpl__DefinitionCustomLogic__c,
            dmpl__RewardApplicability__c,
            dmpl__RewardCustomLogic__c,
            dmpl__SchemeId__r.Id,
            dmpl__SchemeId__r.Name,
            dmpl__SchemeId__r.dmpl__SchemeType__c,
            dmpl__SchemeId__r.dmpl__PeriodType__c,
            dmpl__SchemeId__r.dmpl__SchemeBudget__c,
            dmpl__SchemeId__r.dmpl__UtilizedAmount__c,
            dmpl__SchemeId__r.dmpl__MultipleFulfilmentTreatment__c,
            dmpl__SchemeId__r.dmpl__Application__c,
            dmpl__SchemeId__r.dmpl__ValidCount__c,
            dmpl__SchemeId__r.dmpl__IncludeChildAccountTransactions__c,
            dmpl__SchemeId__r.dmpl__IncludeRelatedAccountTransactions__c,
            (
                SELECT 
                Id,
                Name,
                dmpl__ConditionType__c,
                dmpl__ConditionOperator__c,
                dmpl__AccountId__c,
                dmpl__AccountGroupId__c,
                dmpl__ItemId__c,
                dmpl__ItemSKUId__c,
                dmpl__ItemSKUId__r.Name,
                dmpl__ItemGroupId__c,
                dmpl__ItemLotTypeId__c,
                dmpl__ConditionQuantity__c,
                dmpl__ConditionValue__c
            FROM 
                dmpl__SchemeConditions__r
            WHERE 
                (dmpl__AccountId__c = NULL OR dmpl__AccountId__c =: accountId)
                AND (dmpl__AccountGroupId__c = NULL OR dmpl__AccountGroupId__c IN : accountGroupIds)
            ORDER BY dmpl__SequenceNumber__c ASC
            ),
            (
                SELECT
                Id,
                dmpl__SchemeLineId__c,
                Name,
                dmpl__Title__c,
                dmpl__DiscountAmount__c,
                dmpl__DiscountPercent__c,
                dmpl__DiscountedItemId__c,
                dmpl__DiscountedItemId__r.Name,
                dmpl__DiscountedItemSKUId__c,
                dmpl__DiscountedItemSKUId__r.Name,
                dmpl__DiscountedItemGroupId__c,
                dmpl__DiscountedItemGroupId__r.Name,
                dmpl__DiscountedItemQuantity__c,
                dmpl__RewardPoints__c,
                dmpl__RewardType__c,
                dmpl__RepeatReward__c,
                dmpl__ExcludeQualifyingItems__c,
                dmpl__DiscountedItemRanking__c,
                dmpl__LimitExpiryDays__c
                FROM 
                    dmpl__SchemeBenefits__r
                ORDER BY dmpl__SequenceNumber__c ASC
            )
            FROM 
                dmpl__SchemeLine__c
            WHERE
                dmpl__SchemeId__c IN 
                (SELECT
                    Id
                FROM 
                    dmpl__Scheme__c
                WHERE
                    (dmpl__PartnerAccountId__c = NULL OR dmpl__PartnerAccountId__c =: partnerAccountId)
                    AND (dmpl__PartnerAccountGroupId__c = NULL OR dmpl__PartnerAccountGroupId__c IN :partnerAccountGroupIds)
                    AND (dmpl__AccountId__c = NULL OR dmpl__AccountId__c =: accountId)
                    AND (dmpl__AccountGroupId__c = NULL OR dmpl__AccountGroupId__c IN :accountGroupIds)
                    AND (dmpl__ValidFrom__c <= : documentDate OR dmpl__ValidFrom__c = null)
                    AND (dmpl__ValidTo__c >= : documentDate OR dmpl__ValidTo__c = NULL)
                    AND dmpl__Status__c =: STATUS_APPROVED
                    AND dmpl__SchemeType__c IN :schemeTypes)
            ORDER BY 
                dmpl__SequenceNumber__c ASC
        ];
    }

    @testvisible
    private List<dmpl__SchemeLine__c> getAppliedSchemeLines(
        List<Id> schemeLineIds
    ){
        SecurityHelper.ensureCanReadFields(new string[]
        {
            'dmpl__SchemeType__c','dmpl__PeriodType__c','dmpl__MultipleFulfilmentTreatment__c','dmpl__IncludeChildAccountTransactions__c','dmpl__IncludeRelatedAccountTransactions__c'
        }, 'dmpl__Scheme__c');
        SecurityHelper.ensureCanReadFields(new string[]
        {
            'dmpl__DefinitionFilterCriteria__c','dmpl__DefinitionCustomLogic__c','dmpl__RewardApplicability__c'
        }, 'dmpl__SchemeLine__c');
        SecurityHelper.ensureCanReadFields(new string[]
        {
            'dmpl__ConditionType__c','dmpl__ConditionOperator__c','dmpl__AccountId__c','dmpl__AccountGroupId__c','dmpl__ItemId__c','dmpl__ItemGroupId__c','dmpl__ItemLotTypeId__c','dmpl__ConditionQuantity__c','dmpl__ConditionValue__c','dmpl__SequenceNumber__c'
        }, 'dmpl__SchemeCondition__c');
        SecurityHelper.ensureCanReadFields(new string[]
        {
            'dmpl__SchemeLineId__c','dmpl__DiscountAmount__c','dmpl__DiscountPercent__c','dmpl__DiscountedItemId__c','dmpl__DiscountedItemSKUId__c','dmpl__DiscountedItemGroupId__c','dmpl__DiscountedItemQuantity__c','dmpl__RewardPoints__c','dmpl__RewardType__c','dmpl__RepeatReward__c','dmpl__ExcludeQualifyingItems__c','dmpl__SequenceNumber__c'
        }, 'dmpl__SchemeBenefit__c');
         
        return [
            SELECT
            Id,
            Name,
            dmpl__Title__c,
            dmpl__DefinitionFilterCriteria__c,
            dmpl__DefinitionCustomLogic__c,
            dmpl__RewardApplicability__c,
            dmpl__RewardCustomLogic__c,
            dmpl__SchemeId__r.Id,
            dmpl__SchemeId__r.Name,
            dmpl__SchemeId__r.dmpl__SchemeType__c,
            dmpl__SchemeId__r.dmpl__PeriodType__c,
            dmpl__SchemeId__r.dmpl__MultipleFulfilmentTreatment__c,
            dmpl__SchemeId__r.dmpl__Application__c,
            dmpl__SchemeId__r.dmpl__ValidCount__c,
            dmpl__SchemeId__r.dmpl__IncludeChildAccountTransactions__c,
            dmpl__SchemeId__r.dmpl__IncludeRelatedAccountTransactions__c,
            (
                SELECT 
                Id,
                Name,
                dmpl__ConditionType__c,
                dmpl__ConditionOperator__c,
                dmpl__AccountId__c,
                dmpl__AccountGroupId__c,
                dmpl__ItemId__c,
                dmpl__ItemSKUId__c,
                dmpl__ItemSKUId__r.Name,
                dmpl__ItemGroupId__c,
                dmpl__ItemLotTypeId__c,
                dmpl__ConditionQuantity__c,
                dmpl__ConditionValue__c
            FROM 
                dmpl__SchemeConditions__r
            ORDER BY dmpl__SequenceNumber__c ASC
            ),
            (
                SELECT 
                    Id,
                    dmpl__SchemeBenefitId__c
                FROM 
                    dmpl__SchemeLedger__r
            ),
            (
                SELECT
                Id,
                dmpl__SchemeLineId__c,
                Name,
                dmpl__Title__c,
                dmpl__DiscountAmount__c,
                dmpl__DiscountPercent__c,
                dmpl__DiscountedItemId__c,
                dmpl__DiscountedItemId__r.Name,
                dmpl__DiscountedItemSKUId__c,
                dmpl__DiscountedItemSKUId__r.Name,
                dmpl__DiscountedItemGroupId__c,
                dmpl__DiscountedItemGroupId__r.Name,
                dmpl__DiscountedItemQuantity__c,
                dmpl__RewardPoints__c,
                dmpl__RewardType__c,
                dmpl__RepeatReward__c,
                dmpl__ExcludeQualifyingItems__c,
                dmpl__DiscountedItemRanking__c,
                dmpl__LimitExpiryDays__c
                FROM 
                    dmpl__SchemeBenefits__r
                ORDER BY dmpl__SequenceNumber__c ASC
            )
            FROM 
                dmpl__SchemeLine__c
            WHERE
                Id IN :schemeLineIds
            ORDER BY 
                dmpl__SequenceNumber__c ASC
        ];
    }

    @testVisible
    private List<AggregateResult> getSISummary(Id invoiceId){
        SecurityHelper.ensureCanReadFields(new string[]
        {
            'dmpl__AccountId__c'
        }, 'dmpl__SaleInvoice__c');
        SecurityHelper.ensureCanReadFields(new string[]
        {
            'dmpl__BaseAmount__c',
            'dmpl__TaxAmount__c',
            'dmpl__ItemId__c',
            'dmpl__Quantity__c',
            'dmpl__SKUId__c',
            'dmpl__ItemLotTypeId__c',
            'dmpl__SaleInvoiceId__c'
        }, 'dmpl__SaleInvoiceLine__c');
        return 
        [
            SELECT
                dmpl__ItemId__c dmpl__ItemId__c,
                dmpl__SKUId__c dmpl__SKUId__c,
                dmpl__ItemLotTypeId__c dmpl__ItemLotTypeId__c,
                SUM(dmpl__Quantity__c) TotalQuantity,
                SUM(dmpl__BaseAmount__c) TotalAmount,
                SUM(dmpl__TaxAmount__c) TaxAmount
            FROM
                dmpl__SaleInvoiceLine__c
            WHERE
                dmpl__SaleInvoiceId__c =: invoiceId
            GROUP BY
                dmpl__ItemId__c,
                dmpl__SKUId__c,
                dmpl__ItemLotTypeId__c
        ];
    }

    @testVisible
    private List<AggregateResult> getSRSummary(Id invoiceId){
        SecurityHelper.ensureCanReadFields(new string[]
        {
            'dmpl__BaseAmount__c',
            'dmpl__TaxAmount__c',
            'dmpl__ItemId__c',
            'dmpl__Quantity__c',
            'dmpl__SKUId__c',
            'dmpl__ItemLotTypeId__c',
            'dmpl__SaleReturnId__c'
        }, 'dmpl__SaleReturnLine__c');
        return 
        [
            SELECT
                dmpl__ItemId__c dmpl__ItemId__c,
                dmpl__SKUId__c dmpl__SKUId__c,
                dmpl__ItemLotTypeId__c dmpl__ItemLotTypeId__c,
                SUM(dmpl__Quantity__c) TotalQuantity,
                SUM(dmpl__BaseAmount__c) TotalAmount,
                SUM(dmpl__TaxAmount__c) TaxAmount
            FROM
                dmpl__SaleReturnLine__c
            WHERE
                dmpl__SaleReturnId__c =: invoiceId
            GROUP BY
                dmpl__ItemId__c,
                dmpl__SKUId__c,
                dmpl__ItemLotTypeId__c
        ];
    }
    
    public List<Id> extractItemIds(
        List<OrderSummaryRow> records){
        List<Id> resultIds = new List<Id>();
        for(OrderSummaryRow record : records){
            if(record.ItemId != null && !resultIds.contains(record.ItemId)){
                resultIds.Add(record.ItemId);
            }
        }
        return resultIds;
    }

    private class OrderSummaryRow{
        public OrderSummaryRow(
            Id itemId,
            Id sKUId,
            Id itemLotTypeId,
            Double totalQuantity,
            Double totalAmount,
            Double taxAmount){
                this.ItemId = itemId;
                this.SKUId = sKUId;
                this.ItemLotTypeId = itemLotTypeId;
                this.TotalQuantity = totalQuantity;
                this.TotalAmount = totalAmount;
                this.TaxAmount = taxAmount;
        }
        
        public Id ItemId {get;set;}
        public Id SKUId {get;set;}
        public Id ItemLotTypeId {get;set;}

        public Double TotalQuantity {get;set;}
        public Double TotalAmount {get;set;}
        public Double TaxAmount {get;set;}

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