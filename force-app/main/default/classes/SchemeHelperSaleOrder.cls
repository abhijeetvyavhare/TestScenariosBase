@SuppressWarnings('PMD')
public with sharing class SchemeHelperSaleOrder {
    
    // private static final String SCHEMTYPE_SALES_PER_ORDER = 'Sales Per Order';
    // private static final String SCHEMTYPE_SALES_PER_PERIOD = 'Sales Per Period';
    // private static final String MULTIPLEFULFILLMENT_TREATMENT_ALL_FULFILLED = 'Apply All Fulfilled';
    // private static final String MULTIPLEFULFILLMENT_TREATMENT_FIRST_FULFILLED = 'Apply First Fulfilled';
    // private static final String MULTIPLEFULFILLMENT_TREATMENT_LASTFULFILLED = 'Apply Last Fulfilled';

    // private static final String DEFINITION_FILTER_CRITERIA_ALWAYS_NO_CRITERIA = 'Always (No Criteria)';
    // private static final String DEFINITION_FILTER_CRITERIA_ALL_CONDITIONS = 'All Conditions Are Met';
    // private static final String DEFINITION_FILTER_CRITERIA_ANY_CONDITION = 'Any Condition Is Met';
    // private static final String DEFINITION_FILTER_CRITERIA_CUSTOM_LOGIC = 'Custom Logic Is Met';

    // private static final String REWARD_APPLICABILITY_ALL_REWARDS = 'All Rewards';
    // private static final String REWARD_APPLICABILITY_ANYONE_LOWESTVALUE = 'Any One With Lowest Value';
    // private static final String REWARD_APPLICABILITY_ANYONE_HIGHESTVALUE = 'Any One With Highest Value';
    // private static final String REWARD_APPLICABILITY_CUSTOMLOGIC = 'Custom Logic';

    // private static final String REWARD_TYPE_LL_DISCOUNT_PERCENT = 'Line Level Discount Percent';
    // private static final String REWARD_TYPE_LL_DISCOUNT_AMOUNT = 'Line Level Discount Amount';
    // private static final String REWARD_TYPE_DISCOUNTED_ITEM = 'Discounted Item';
    // private static final String REWARD_TYPE_DISCOUNTED_ITEMGROUP = 'Discounted Item Group';

    // private static final String CONDITION_TYPE_QUANTITY = 'Quantity';
    // private static final String CONDITION_TYPE_VALUE = 'Value';
    // private static final String CONDITION_TYPE_VALUE_WITHTAX = 'Value With Tax';
    // private static final String CONDITION_TYPE_ITEM_QUANTITY = 'Item Quantity';
    // private static final String CONDITION_TYPE_ITEM_VALUE = 'Item Value';
    // private static final String CONDITION_TYPE_ITEM_VALUE_WITHTAX = 'Item Value With Tax';
    // private static final String CONDITION_TYPE_ITEMGROUP_QUANTITY = 'Item Group Quantity';
    // private static final String CONDITION_TYPE_ITEMGROUP_VALUE = 'Item Group Value';
    // private static final String CONDITION_TYPE_ITEMGROUP_VALUE_WITHTAX = 'Item Group Value With Tax';

    // private static final String CONDITION_OPERATOR_EQUALS = 'Equals';
    // private static final String CONDITION_OPERATOR_DOSESNOT_EQUALS = 'Does Not Equal';
    // private static final String CONDITION_OPERATOR_GREATER_THAN = 'Greater Than';
    // private static final String CONDITION_OPERATOR_GREATERTHAN_OR_EQUALS = 'Greater Than Or Equal';
    // private static final String CONDITION_OPERATOR_LESS_THAN = 'Less Than';
    // private static final String CONDITION_OPERATOR_LESSTHAN_OR_EQUALS = 'Less Than Or Equal';

    // private static final String STATUS_APPROVED = 'Approved';

    // private static Boolean isAlreadyProcessing =false;
    // private static List<dmpl__SaleOrderLine__c> allLines;
    // private static List<dmpl__SaleOrderLine__c> insertedLines;
    // private static Map<Id, dmpl__SaleOrderLine__c> updatedLines;

    // public static void processSaleOrderLines(List<dmpl__SaleOrderLine__c> orderLines)
    // {
    //     if(isAlreadyProcessing)
    //         {return;}
    //     //
    //     isAlreadyProcessing = true;
    //     //
    //     dmpl__SaleOrderLine__c orderLine = orderLines.get(orderLines.size()-1);
    //     List<SchemeLine__c> activeSchemeLines = getActiveSchemeLines(orderLine);
    //     if(activeSchemeLines.size()==0){
    //         return;
    //     }
    //     //
    //     Map<Id,Integer> perOrderResults = new Map<Id,Integer>();
    //     Map<Id,Boolean> perPeriodResults = new Map<Id,Boolean>();
    //     List<AggregateResult> orderSummary = getOrderSummary(orderLine);
    //     for(SchemeLine__c  schemeLine : activeSchemeLines)
    //     {
    //         if(schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_SALES_PER_ORDER){
    //             perOrderResults.put(
    //                 schemeLine.Id, 
    //                 evaluatePerOrderSchemeLine(
    //                     schemeLine, 
    //                     orderLine, 
    //                     orderSummary));
    //         }else if(schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_SALES_PER_PERIOD){
    //             perPeriodResults.put(
    //                 schemeLine.Id, 
    //                 evaluatePerPeriodSchemeLine(
    //                     schemeLine, 
    //                     orderLine, 
    //                     orderSummary));
    //         }
            
    //     }
    //     //
    //     List<Id> ignoredSchemeLines = getIgnoredSchemeLines(
    //         activeSchemeLines, 
    //         perOrderResults);
    //     allLines = getOrderLines(orderLine);
    //     updatedLines = new Map<Id, dmpl__SaleOrderLine__c>();
    //     insertedLines = new List<dmpl__SaleOrderLine__c>();
    //     //
    //     for(SchemeLine__c  schemeLine : activeSchemeLines){
    //         if(ignoredSchemeLines.contains(schemeLine.Id)){
    //             resetPerOrderSchemeLine(
    //                 schemeLine, 
    //                 orderLine);
    //             continue;
    //         }
    //         //
    //         if(schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_SALES_PER_ORDER){
    //             if(perOrderResults.get(schemeLine.Id)>0) {
    //                 applyPerOrderSchemeLine(
    //                     schemeLine, 
    //                     orderLine,
    //                     perOrderResults.get(schemeLine.Id));
    //             }else {
    //                 resetPerOrderSchemeLine(
    //                     schemeLine, 
    //                     orderLine);
    //             }
    //         } else if(schemeLine.SchemeId__r.SchemeType__c == SCHEMTYPE_SALES_PER_PERIOD){
    //             if(perPeriodResults.get(schemeLine.Id)) {
    //                 applyPerPeriodSchemeLine(
    //                     schemeLine, 
    //                     orderLine);
    //             } else {
    //                 resetPerOrderSchemeLine(
    //                     schemeLine, 
    //                     orderLine);
    //             } 
    //         }
    //     }
    //     //
    //     updateLines();
    //     insertLines();
    //     //
    //     isAlreadyProcessing = false;
    //     //
    // }

    // private static void updateLines()
    // {
    //     if(updatedLines.size()>0)
    //         update updatedLines.values();
    // }

    // private static void insertLines()
    // {
    //     if(insertedLines.size()>0)
    //         insert insertedLines;
    // }

    // private static List<Id> getIgnoredSchemeLines(List<SchemeLine__c> activeSchemeLines, Map<Id,Integer> perOrderResults){
    //     List<Id> ignoredSchemeLines = new List<Id>();
    //     Map<Id, SchemeLine__c> consolidatedSchemes = new Map<Id, SchemeLine__c>();
    //     for(SchemeLine__c  schemeLine : activeSchemeLines){
    //         if((perOrderResults.get(schemeLine.Id) != null && perOrderResults.get(schemeLine.Id)==0) 
    //             || schemeLine.SchemeId__r.MultipleFulfilmentTreatment__c == MULTIPLEFULFILLMENT_TREATMENT_ALL_FULFILLED){
    //             continue;
    //         }else if(schemeLine.SchemeId__r.MultipleFulfilmentTreatment__c == MULTIPLEFULFILLMENT_TREATMENT_FIRST_FULFILLED){
    //             if(consolidatedSchemes.containsKey(schemeLine.SchemeId__r.Id)){
    //                 ignoredSchemeLines.add(schemeLine.Id);
    //             }
    //             else {
    //                 consolidatedSchemes.put(
    //                     schemeLine.SchemeId__r.Id, 
    //                     schemeLine);
    //             }
    //         }else if(schemeLine.SchemeId__r.MultipleFulfilmentTreatment__c == MULTIPLEFULFILLMENT_TREATMENT_LASTFULFILLED){
    //             if(consolidatedSchemes.containsKey(schemeLine.SchemeId__r.Id)){
    //                 SchemeLine__c oldLine = consolidatedSchemes.put(
    //                     schemeLine.SchemeId__r.Id, 
    //                     schemeLine);
    //                 ignoredSchemeLines.add(oldLine.Id);
    //             }else {
    //                 consolidatedSchemes.put(
    //                     schemeLine.SchemeId__r.Id, 
    //                     schemeLine);
    //             }
    //         }
    //     }
    //     //
    //     return ignoredSchemeLines;
    // }

    // private static Integer evaluatePerOrderSchemeLine(
    //     SchemeLine__c schemeLine, 
    //     dmpl__SaleOrderLine__c orderLine, 
    //     List<AggregateResult> orderSummary)
    // {
    //     if(schemeLine.DefinitionFilterCriteria__c == DEFINITION_FILTER_CRITERIA_ALWAYS_NO_CRITERIA){
    //         return 1;
    //     }
    //     //
    //     List<Integer> conditionResults = new List<Integer>();
    //     for(SchemeCondition__c  condition : schemeLine.SchemeConditions__r){
    //         conditionResults.add(
    //             evaluatePerOrderCondition(
    //                 condition, 
    //                 orderSummary));
    //     }
    //     //
    //    return evaluateConditions(
    //        schemeLine.DefinitionFilterCriteria__c, 
    //        conditionResults);
    // }
    
    // private static Boolean evaluatePerPeriodSchemeLine(
    //     SchemeLine__c schemeLine, 
    //     dmpl__SaleOrderLine__c orderLine, 
    //     List<AggregateResult> orderSummary)
    // {
    //     return false;
    // }

    // private static void applyPerOrderSchemeLine(
    //     SchemeLine__c schemeLine, 
    //     dmpl__SaleOrderLine__c orderLine,
    //     Integer qualifyingCount)
    // {
    //     if(schemeLine.RewardApplicability__c == REWARD_APPLICABILITY_ALL_REWARDS){
    //         for(SchemeBenefit__c  benefit : schemeLine.SchemeBenefits__r){
    //             applyPerOrderBenefit(
    //                 benefit, 
    //                 orderLine,
    //                 qualifyingCount);
    //         }
    //     } else if(schemeLine.RewardApplicability__c == REWARD_APPLICABILITY_ANYONE_LOWESTVALUE){
    //         applyPerOrderBenefit(
    //             getMinimumBenefit(
    //                 schemeLine, 
    //                 orderLine), 
    //             orderLine,
    //             qualifyingCount);
    //     } else if(schemeLine.RewardApplicability__c == REWARD_APPLICABILITY_ANYONE_HIGHESTVALUE){
    //         applyPerOrderBenefit(
    //             getMaximumBenefit(
    //                 schemeLine, 
    //                 orderLine),
    //             orderLine,
    //             qualifyingCount);
    //     } else if(schemeLine.RewardApplicability__c == REWARD_APPLICABILITY_CUSTOMLOGIC){
    //     }
    // }

    // private static void resetPerOrderSchemeLine(
    //     SchemeLine__c schemeLine, 
    //     dmpl__SaleOrderLine__c orderLine){
    //     resetPerOrderBenefit(
    //         schemeLine.Id, 
    //         orderLine);
    // }

    // @testVisible
    // private static void applyPerPeriodSchemeLine(
    //     SchemeLine__c schemeLine, 
    //     dmpl__SaleOrderLine__c orderLine){
        
    // }

    // @testVisible
    // private static SchemeBenefit__c getMinimumBenefit(
    //     SchemeLine__c schemeLine, 
    //     dmpl__SaleOrderLine__c orderLine){
    //     SchemeBenefit__c minBenefit = null;
    //     Decimal minBenefitValue = 0;
    //     for(SchemeBenefit__c  benefit : schemeLine.SchemeBenefits__r){
    //         if(benefit.RewardType__c == REWARD_TYPE_LL_DISCOUNT_AMOUNT){
    //             if(benefit.DiscountAmount__c < minBenefitValue || minBenefitValue == 0){
    //                 minBenefitValue=benefit.DiscountAmount__c;
    //                 minBenefit=benefit;
    //             }
    //         }else if(benefit.RewardType__c == REWARD_TYPE_LL_DISCOUNT_PERCENT){
    //             if(benefit.DiscountPercent__c < minBenefitValue || minBenefitValue == 0){
    //                 minBenefitValue=benefit.DiscountPercent__c;
    //                 minBenefit=benefit;
    //             }
    //         }
    //     }
    //     return minBenefit;
    // }

    // private static SchemeBenefit__c getMaximumBenefit(
    //     SchemeLine__c schemeLine, 
    //     dmpl__SaleOrderLine__c orderLine){
    //     SchemeBenefit__c maxBenefit = null;
    //     Decimal maxBenefitValue = 0;
    //     for(SchemeBenefit__c  benefit : schemeLine.SchemeBenefits__r){
    //         if(benefit.RewardType__c ==  REWARD_TYPE_LL_DISCOUNT_AMOUNT){
    //             if(benefit.DiscountAmount__c > maxBenefitValue){
    //                 maxBenefitValue=benefit.DiscountAmount__c;
    //                 maxBenefit=benefit;
    //             }
    //         }else if(benefit.RewardType__c == REWARD_TYPE_LL_DISCOUNT_PERCENT){
    //             if(benefit.DiscountPercent__c > maxBenefitValue){
    //                 maxBenefitValue=benefit.DiscountPercent__c;
    //                 maxBenefit=benefit;
    //             }
    //         }
    //     }
    //     return maxBenefit;
    // }

    // @testVisible
    // private static Integer evaluatePerOrderCondition(
    //     SchemeCondition__c condition, 
    //     List<AggregateResult> orderSummary){
    //     if(condition.ConditionType__c == CONDITION_TYPE_QUANTITY){
    //         return evaluateNumberOperator(
    //             getTotalQuantity(orderSummary), 
    //             condition.ConditionOperator__c, 
    //             condition.ConditionQuantity__c);
    //     }
    //     else if(condition.ConditionType__c == CONDITION_TYPE_VALUE){
    //         return evaluateCurrencyOperator(
    //             getTotalValue(orderSummary, false), 
    //             condition.ConditionOperator__c, 
    //             condition.ConditionValue__c);
    //     }
    //     else if(condition.ConditionType__c == CONDITION_TYPE_VALUE_WITHTAX){
    //         return evaluateCurrencyOperator(
    //             getTotalValue(orderSummary, true), 
    //             condition.ConditionOperator__c, 
    //             condition.ConditionValue__c);
    //     }
    //     else if(condition.ConditionType__c == CONDITION_TYPE_ITEM_QUANTITY){
    //         return evaluateNumberOperator(
    //             getTotalItemQuantity(
    //                 orderSummary, 
    //                 condition.ItemId__c), 
    //             condition.ConditionOperator__c, 
    //             condition.ConditionQuantity__c);            
    //     }
    //     else if(condition.ConditionType__c == CONDITION_TYPE_ITEM_VALUE){
    //         return evaluateCurrencyOperator(
    //             getTotalItemValue(
    //                 orderSummary, 
    //                 condition.ItemId__c, 
    //                 false), 
    //             condition.ConditionOperator__c, 
    //             condition.ConditionValue__c);            
    //     }
    //     else if(condition.ConditionType__c == CONDITION_TYPE_ITEM_VALUE_WITHTAX){
    //         return evaluateCurrencyOperator(
    //             getTotalItemValue(
    //                 orderSummary, 
    //                 condition.ItemId__c,
    //                 true), 
    //             condition.ConditionOperator__c, 
    //             condition.ConditionValue__c);            
    //     }
    //     else if(condition.ConditionType__c == CONDITION_TYPE_ITEMGROUP_QUANTITY){
    //         return evaluateNumberOperator(
    //             getTotalItemGroupQuantity(
    //                 orderSummary, 
    //                 condition.ItemGroupId__c), 
    //             condition.ConditionOperator__c, 
    //             condition.ConditionQuantity__c);            
    //     }
    //     else if(condition.ConditionType__c == CONDITION_TYPE_ITEMGROUP_VALUE){
    //         return evaluateCurrencyOperator(
    //             getTotalItemGroupValue(
    //                 orderSummary, 
    //                 condition.ItemGroupId__c,
    //                 false),
    //             condition.ConditionOperator__c, 
    //             condition.ConditionValue__c);
    //     }
    //     else if(condition.ConditionType__c == CONDITION_TYPE_ITEMGROUP_VALUE_WITHTAX){
    //         return evaluateCurrencyOperator(
    //             getTotalItemGroupValue(
    //                 orderSummary, 
    //                 condition.ItemGroupId__c,
    //                 true),
    //             condition.ConditionOperator__c, 
    //             condition.ConditionValue__c);
    //     }
    //     return 0;
    // }
    
	// @TestVisible
    // private static Double getTotalQuantity(List<AggregateResult> orderSummary)
    // {
    //     Double totalQuantity =0;
    //     for(AggregateResult result : orderSummary)
    //         totalQuantity += Double.valueOf(result.get('TotalQuantity'));

    //     return totalQuantity;
    // }

    // @TestVisible
    // private static Double getTotalItemQuantity(List<AggregateResult> orderSummary, Id itemId)
    // {
    //     Double totalQuantity =0;
    //     for(AggregateResult result : orderSummary)
    //         if(itemId == result.get('dmpl__ItemId__c'))
    //             totalQuantity += Double.valueOf(result.get('TotalQuantity'));

    //     return totalQuantity;
    // }

    // @TestVisible
    // private static Double getTotalItemSKUQuantity(List<AggregateResult> orderSummary, Id skuId)
    // {
    //     Double totalQuantity =0;
    //     for(AggregateResult result : orderSummary)
    //         if(skuId == result.get('SKUId__c'))
    //             totalQuantity += Double.valueOf(result.get('TotalQuantity'));

    //     return totalQuantity;
    // }

    // @TestVisible
    // private static Double getTotalItemGroupQuantity(List<AggregateResult> orderSummary, Id itemGroupId)
    // {
    //     Double totalQuantity =0;
    //     for(AggregateResult result : orderSummary)
    //         if(itemGroupId == result.get('ItemGroupId__c'))
    //             totalQuantity += Double.valueOf(result.get('TotalQuantity'));

    //     return totalQuantity;
    // }

    // @TestVisible
    // private static Decimal getTotalValue(
    //     List<AggregateResult> orderSummary,
    //     Boolean includeTax)
    // {
    //     Decimal totalValue =0;
    //     for(AggregateResult result : orderSummary){
    //         totalValue += Double.valueOf(result.get('TotalAmount'));
    //         if(includeTax){
    //             totalValue += Double.valueOf(result.get('TaxAmount'));
    //         }    
    //     }
    //     return totalValue;
    // }

    // @TestVisible
    // private static Decimal getTotalItemValue(
    //     List<AggregateResult> orderSummary, 
    //     Id itemId,
    //     Boolean includeTax)
    // {
    //     Decimal totalValue =0;
    //     for(AggregateResult result : orderSummary){
    //         if(itemId == result.get('dmpl__ItemId__c')){
    //             totalValue += Double.valueOf(result.get('TotalAmount'));
    //             if(includeTax){
    //                 totalValue += Double.valueOf(result.get('TaxAmount'));
    //             }    
    //         }
    //     }
    //     return totalValue;
    // }

    // @TestVisible
    // private static Decimal getTotalItemGroupValue(
    //     List<AggregateResult> orderSummary, 
    //     Id itemGroupId,
    //     Boolean includeTax)
    // {
    //     Decimal totalValue =0;
    //     for(AggregateResult result : orderSummary){
    //         if(itemGroupId == result.get('ItemGroupId__c')){
    //             totalValue += Double.valueOf(result.get('TotalAmount'));
    //             if(includeTax){
    //                 totalValue += Double.valueOf(result.get('TaxAmount'));
    //             }    
    //         }
    //     }
    //     return totalValue;
    // }

    // @TestVisible
    // private static Decimal getTotalItemSKUValue(List<AggregateResult> orderSummary, Id skuId)
    // {
    //     Decimal totalValue =0;
    //     for(AggregateResult result : orderSummary)
    //         if(skuId == result.get('dmpl__SKUId__c'))
    //             totalValue += Double.valueOf(result.get('TotalAmount'));
    //     return totalValue;
    // }

    // private static void applyPerOrderBenefit(
    //     SchemeBenefit__c benefit, 
    //     dmpl__SaleOrderLine__c orderLine,
    //     Integer qualifyingCount){
    //     if(benefit == null)
    //         return;
    //     //
    //     if(benefit.RewardType__c == REWARD_TYPE_LL_DISCOUNT_PERCENT){
    //         applyOrderDiscountPercent(
    //             benefit, 
    //             orderLine);
    //     }else if(benefit.RewardType__c == REWARD_TYPE_LL_DISCOUNT_AMOUNT){
    //         applyOrderDiscountAmount(
    //             benefit, 
    //             orderLine);
    //     }else if(benefit.RewardType__c == REWARD_TYPE_DISCOUNTED_ITEM){
    //         resetPerOrderBenefit(
    //             benefit.SchemeLineId__c, 
    //             orderLine);
    //         applyOrderDiscountdItem(
    //             benefit, 
    //             orderLine,
    //             qualifyingCount,
    //             false);
    //     }else if(benefit.RewardType__c == REWARD_TYPE_DISCOUNTED_ITEMGROUP){
    //         resetPerOrderBenefit(
    //             benefit.SchemeLineId__c, 
    //             orderLine);
    //         applyOrderDiscountdItem(
    //             benefit, 
    //             orderLine,
    //             qualifyingCount,
    //             true);
    //     }
    // }

    // private static void resetPerOrderBenefit(
    //     Id schemeLineId, 
    //     dmpl__SaleOrderLine__c orderLine){
    //     for(dmpl__SaleOrderLine__c line : allLines){
    //         if(line.SchemeLineId__c == schemeLineId){
    //             resetOrderDiscountPercent(line);
    //             resetOrderDiscountAmount(line);
    //         }
    //     }
    // }

    // private static void applyOrderDiscountPercent(
    //     SchemeBenefit__c benefit, 
    //     dmpl__SaleOrderLine__c orderLine){
    //     for(dmpl__SaleOrderLine__c line : allLines) {
    //         line.SchemeDiscount__c = benefit.DiscountPercent__c;
    //         line.SchemeDiscountAmount__c = null;
    //         line.SchemeLineId__c = benefit.SchemeLineId__c;
    //         if(!updatedLines.containsKey(line.Id))
    //             updatedLines.put(line.Id, line);
    //     }
    // }

    // private static void resetOrderDiscountPercent(
    //     dmpl__SaleOrderLine__c orderLine){
    //     orderLine.SchemeDiscount__c = null;
    //     orderLine.SchemeLineId__c = null;
    //     if(!updatedLines.containsKey(orderLine.Id))
    //         updatedLines.put(orderLine.Id, orderLine);
    // }

    // @TestVisible
    // private static void applyOrderDiscountAmount(
    //     SchemeBenefit__c benefit, 
    //     dmpl__SaleOrderLine__c orderLine){
    //     for(dmpl__SaleOrderLine__c line : allLines) {
    //         line.SchemeDiscountAmount__c = benefit.DiscountAmount__c;
    //         line.SchemeDiscount__c =null;
    //         line.SchemeLineId__c = benefit.SchemeLineId__c;
    //         if(!updatedLines.containsKey(line.Id))
    //             updatedLines.put(line.Id, line);
    //     }
    // }

    // private static void resetOrderDiscountAmount(dmpl__SaleOrderLine__c orderLine){
    //     orderLine.SchemeDiscountAmount__c = null;
    //     orderLine.SchemeLineId__c = null;
    //     if(!updatedLines.containsKey(orderLine.Id))
    //         updatedLines.put(orderLine.Id, orderLine);
    // }

    // @TestVisible
    // private static void applyOrderDiscountdItem(
    //     SchemeBenefit__c benefit, 
    //     dmpl__SaleOrderLine__c orderLine,
    //     Integer qualifyingCount,
    //     Boolean isItemGroup){
    //     Double quantityToDiscount = benefit.DiscountedItemQuantity__c == null ? orderLine.dmpl__Quantity__c : benefit.DiscountedItemQuantity__c;
    //     if(benefit.dmpl__RepeatReward__c!=null && benefit.dmpl__RepeatReward__c){
    //         quantityToDiscount = quantityToDiscount * qualifyingCount;
    //     }
    //     if(benefit.dmpl__ExcludeQualifyingItems__c!=null && benefit.dmpl__ExcludeQualifyingItems__c){
    //         quantityToDiscount = Integer.valueOf(Math.floor(quantityToDiscount/2));
    //     }
    //     //
    //     Boolean isDecending =  benefit.dmpl__DiscountedItemRanking__c == 'High To Low';
    //     List<LineWrapper> sortedLines = new List<LineWrapper>();
    //     for(dmpl__SaleOrderLine__c line : allLines){
    //         sortedLines.add(new LineWrapper(line, isDecending));
    //     }
    //     sortedLines.sort();
    //     //
    //     for(LineWrapper lineWrapper : sortedLines) {
    //         dmpl__SaleOrderLine__c line = (dmpl__SaleOrderLine__c)lineWrapper.source;
    //         if(quantityToDiscount <=0)
    //             return;
    //         if(isItemGroup){
    //             if(line.dmpl__ItemId__r?.dmpl__SchemeItemGroupId__c != benefit.DiscountedItemGroupId__c){
    //                 continue;
    //             }
    //         }else {
    //             if(line.ItemId__c != benefit.DiscountedItemId__c){
    //                 continue;
    //             }   
    //         }
    
    //         if(line.Quantity__c<= quantityToDiscount){
    //             quantityToDiscount -= line.Quantity__c;
    //             if(benefit.dmpl__DiscountAmount__c >0){
    //                 line.SchemeDiscountAmount__c = benefit.dmpl__DiscountAmount__c;
    //                 line.SchemeDiscount__c =0;
    //             }else if(benefit.dmpl__DiscountPercent__c >0){
    //                 line.SchemeDiscountAmount__c = 0;
    //                 line.SchemeDiscount__c = benefit.dmpl__DiscountPercent__c;
    //             }
    //             line.SchemeLineId__c = benefit.SchemeLineId__c;
    //             if(!updatedLines.containsKey(line.Id))
    //                 updatedLines.put(line.Id, line);
    //         }
    //         else {
    //             dmpl__SaleOrderLine__c newLine = line.clone(
    //                 false, 
    //                 true, 
    //                 true, 
    //                 false);
    //             line.Quantity__c -= quantityToDiscount;
    //             if(!updatedLines.containsKey(line.Id))
    //                 updatedLines.put(line.Id, line);

    //             newLine.Quantity__c = quantityToDiscount;
    //             if(benefit.dmpl__DiscountAmount__c >0){
    //                 newLine.SchemeDiscountAmount__c = benefit.dmpl__DiscountAmount__c;
    //                 newLine.SchemeDiscount__c =0;
    //             }else if(benefit.dmpl__DiscountPercent__c >0){
    //                 newLine.SchemeDiscountAmount__c = 0;
    //                 newLine.SchemeDiscount__c = benefit.dmpl__DiscountPercent__c;
    //             }
    //             newLine.SchemeLineId__c = benefit.SchemeLineId__c;
    //             insertedLines.add(newLine);
    //             return;
    //         }
    //     }
    // }

    // private static Integer evaluateNumberOperator(
    //     Double reachedValue, 
    //     string operator, 
    //     Decimal conditionValue){
    //     if(operator == CONDITION_OPERATOR_GREATERTHAN_OR_EQUALS)
    //         return (reachedValue >= conditionValue) ? Integer.valueOf(Math.floor(reachedValue/conditionValue)):0;
    //     else if(operator == CONDITION_OPERATOR_GREATER_THAN)
    //         return (reachedValue > conditionValue) ? Integer.valueOf(Math.floor(reachedValue/conditionValue)):0;
    //     else if(operator == CONDITION_OPERATOR_EQUALS)
    //         return (reachedValue == conditionValue)? 1 : 0;
    //     else if(operator == CONDITION_OPERATOR_LESSTHAN_OR_EQUALS)
    //         return (reachedValue <= conditionValue)? 1:0;
    //     else if(operator == CONDITION_OPERATOR_LESS_THAN)
    //         return (reachedValue < conditionValue) ? 1:0;
    //     else if(operator == CONDITION_OPERATOR_DOSESNOT_EQUALS)
    //         return (reachedValue != conditionValue)?1:0;
    //     else
    //         return 0;
    // }

    // private static Integer evaluateCurrencyOperator(
    //     Decimal reachedValue, 
    //     string operator, 
    //     Decimal conditionValue){
    //     if(operator == CONDITION_OPERATOR_GREATERTHAN_OR_EQUALS)
    //         return (reachedValue >= conditionValue) ? Integer.valueOf(Math.floor(reachedValue/conditionValue)):0;
    //     else if(operator == CONDITION_OPERATOR_GREATER_THAN)
    //         return (reachedValue > conditionValue) ? Integer.valueOf(Math.floor(reachedValue/conditionValue)):0;
    //     else if(operator == CONDITION_OPERATOR_EQUALS)
    //         return (reachedValue == conditionValue) ? 1 : 0;
    //     else if(operator == CONDITION_OPERATOR_LESSTHAN_OR_EQUALS)
    //         return (reachedValue <= conditionValue) ? 1 : 0;
    //     else if(operator == CONDITION_OPERATOR_LESS_THAN)
    //         return (reachedValue < conditionValue) ? 1 : 0;
    //     else if(operator == CONDITION_OPERATOR_DOSESNOT_EQUALS)
    //         return (reachedValue != conditionValue) ? 1 : 0;
    //     else
    //         return 0;
    // }

    // private static Integer evaluateConditions(
    //     string filterCriteria, 
    //     List<Integer> conditions){
    //     Integer maxValue = 0;
    //     if(filterCriteria == DEFINITION_FILTER_CRITERIA_ALL_CONDITIONS)
    //     {    
    //         for(Integer result : conditions){
    //             if(result == 0){
    //                 return 0;
    //             }
    //             if(result > maxValue){
    //                 maxValue = result;
    //             }
    //         }
    //     }
    //     else if(filterCriteria == DEFINITION_FILTER_CRITERIA_ANY_CONDITION)
    //     {
    //         for(Integer result : conditions){
    //             if(result > maxValue){
    //                 maxValue  = result;
    //             }
    //         }
    //     }
    //     return maxValue;
    // }

    // private static List<AggregateResult> getOrderSummary(dmpl__SaleOrderLine__c orderLine)
    // {
    //     SecurityHelper.ensureCanReadFields(new string[]
    //     {
    //         'dmpl__AccountId__c'
    //     }, 'dmpl__SaleOrder__c');
    //     SecurityHelper.ensureCanReadFields(new string[]
    //     {
    //         'dmpl__BaseAmount__c',
    //         'dmpl__TaxAmount__c',
    //         'dmpl__ItemId__c',
    //         'dmpl__Quantity__c',
    //         'dmpl__SKUId__c',
    //         'dmpl__SaleOrderId__c'
    //     }, 'dmpl__SaleOrderLine__c');
    //     return 
    //     [
    //         SELECT
    //             dmpl__ItemId__c dmpl__ItemId__c,
    //             SKUId__c SKUId__c,
    //             ItemId__r.SchemeItemGroupId__c ItemGroupId__c,
    //             SUM(Quantity__c) TotalQuantity,
    //             SUM(BaseAmount__c) TotalAmount,
    //             SUM(TaxAmount__c) TaxAmount,
    //             SaleOrderId__r.AccountId__c AccountId__c,
    //             SaleOrderId__r.AccountId__r.CustomerSchemeAccountGroupId__c AccountGroupId__c
    //         FROM
    //             dmpl__SaleOrderLine__c
    //         WHERE
    //             SaleOrderId__c =: orderLine.SaleOrderId__c
    //         GROUP BY
    //             dmpl__ItemId__c,
    //             SKUId__c,
    //             ItemId__r.SchemeItemGroupId__c,
    //             SaleOrderId__r.AccountId__c,
    //             SaleOrderId__r.AccountId__r.CustomerSchemeAccountGroupId__c
    //     ];
    // }

    // private static List<dmpl__SaleOrderLine__c> getOrderLines(dmpl__SaleOrderLine__c orderLine)
    // {
    //     SecurityHelper.ensureCanReadFields(new string[]
    //     {
    //         'dmpl__SchemeLineId__c',
    //         'dmpl__SchemeDiscount__c',
    //         'dmpl__SchemeDiscountAmount__c',
    //         'dmpl__ItemId__c',
    //         'dmpl__Quantity__c'
    //     }, 'dmpl__SaleOrderLine__c');
    //     return 
    //     [
    //         SELECT
    //             Id,
    //             SchemeLineId__c,
    //             SchemeDiscount__c,
    //             SchemeDiscountAmount__c,
    //             ItemId__c,
    //             dmpl__ItemId__r.dmpl__SchemeItemGroupId__c,
    //             Quantity__c,
    //             dmpl__UnitPrice__c
    //         FROM
    //             dmpl__SaleOrderLine__c
    //         WHERE
    //         dmpl__SaleOrderId__c =: orderLine.SaleOrderId__c
    //     ];
    // }

    // private static List<SchemeLine__c> getActiveSchemeLines(dmpl__SaleOrderLine__c orderLine)
    // {
    //     Id accountId = orderLine.dmpl__SaleOrderId__r.dmpl__AccountId__c;
    //     Id partnerAccountId = orderLine.dmpl__SaleOrderId__r.PartnerAccountId__c;
    //     Id accountGroupId = orderLine.dmpl__SaleOrderId__r.dmpl__AccountId__r.PartnerSchemeAccountGroupId__c;
       
    //     SecurityHelper.ensureCanReadFields(new string[]
    //     {
    //         'dmpl__SchemeType__c',
    //         'dmpl__PeriodType__c',
    //         'dmpl__MultipleFulfilmentTreatment__c'
    //     }, 'dmpl__Scheme__c');
    //     SecurityHelper.ensureCanReadFields(new string[]
    //         {
    //             'dmpl__DefinitionFilterCriteria__c',
    //             'dmpl__DefinitionCustomLogic__c',
    //             'dmpl__RewardApplicability__c'
    //         }, 'dmpl__SchemeLine__c');
    //         SecurityHelper.ensureCanReadFields(new string[]
    //         {
    //             'dmpl__ConditionType__c',
    //             'dmpl__ConditionOperator__c',
    //             'dmpl__AccountId__c',
    //             'dmpl__AccountGroupId__c',
    //             'dmpl__ItemId__c',
    //             'dmpl__ItemGroupId__c',
    //             'dmpl__ConditionQuantity__c',
    //             'dmpl__ConditionValue__c',
    //             'dmpl__SequenceNumber__c'
    //         }, 'dmpl__SchemeCondition__c');
    //         SecurityHelper.ensureCanReadFields(new string[]
    //         {
    //             'dmpl__SchemeLineId__c',
    //             'dmpl__DiscountAmount__c',
    //             'dmpl__DiscountPercent__c',
    //             'dmpl__DiscountedItemId__c',
    //             'dmpl__DiscountedItemSKUId__c',
    //             'dmpl__DiscountedItemGroupId__c',
    //             'dmpl__DiscountedItemQuantity__c',
    //             'dmpl__RewardType__c',
    //             'dmpl__RepeatReward__c',
    //             'dmpl__ExcludeQualifyingItems__c',
    //             'dmpl__SequenceNumber__c'
    //         }, 'dmpl__SchemeBenefit__c');
    //     return 
    //     [
    //         SELECT
    //         Id,
    //         Name,
    //         DefinitionFilterCriteria__c,
    //         DefinitionCustomLogic__c,
    //         RewardApplicability__c,
    //         SchemeId__r.Id,
    //         SchemeId__r.Name,
    //         SchemeId__r.SchemeType__c,
    //         SchemeId__r.PeriodType__c,
    //         SchemeId__r.MultipleFulfilmentTreatment__c,
    //         (
    //             SELECT 
    //             Id,
    //             Name,
    //             ConditionType__c,
    //             ConditionOperator__c,
    //             AccountId__c,
    //             AccountGroupId__c,
    //             ItemId__c,
    //             ItemSKUId__c,
    //             ItemSKUId__r.Name,
    //             ItemGroupId__c,
    //             ConditionQuantity__c,
    //             ConditionValue__c
    //         FROM 
    //             SchemeConditions__r
    //         WHERE 
    //             (AccountId__c = NULL OR AccountId__c =: accountId)
    //             AND (AccountGroupId__c = NULL OR AccountGroupId__c =: accountGroupId)
    //         ORDER BY SequenceNumber__c ASC
    //             ),
    //         (
    //             SELECT
    //             Id,
    //             SchemeLineId__c,
    //             Name,
    //             DiscountAmount__c,
    //             DiscountPercent__c,
    //             DiscountedItemId__c,
    //             DiscountedItemId__r.Name,
    //             DiscountedItemSKUId__c,
    //             DiscountedItemSKUId__r.Name,
    //             DiscountedItemGroupId__c,
    //             DiscountedItemGroupId__r.Name,
    //             DiscountedItemQuantity__c,
    //             RewardType__c,
    //             RepeatReward__c,
    //             ExcludeQualifyingItems__c,
    //             DiscountedItemRanking__c
    //             FROM 
    //                 SchemeBenefits__r
    //             ORDER BY SequenceNumber__c ASC
    //         )
    //         FROM 
    //             SchemeLine__c
    //         WHERE
    //             SchemeId__c IN 
    //             (SELECT
    //                 Id
    //             FROM 
    //                 Scheme__c
    //             WHERE
    //                 (PartnerAccountId__c = NULL OR PartnerAccountId__c =: partnerAccountId)
    //                 AND (ValidFrom__c <= : orderLine.SaleOrderId__r.DocumentDate__c OR ValidFrom__c = null)
    //                 AND (ValidTo__c >= :orderLine.SaleOrderId__r.DocumentDate__c OR ValidTo__c = NULL)
    //                 AND Status__c = :STATUS_APPROVED)
    //         ORDER BY 
    //             SequenceNumber__c ASC
    //     ];
    // }

    // public class LineWrapper implements Comparable {

    //     public SObject source;
    //     public Boolean descending;
    //     public LineWrapper(SObject sourceObject, Boolean isDescending) {
    //         source = sourceObject;
    //         descending = isDescending;
    //     }
    
    //     public Integer compareTo(Object compareTo) {
    //         LineWrapper compareToLine = (LineWrapper)compareTo;
    //         Integer returnValue = 0;
    //         if ((Decimal)(source.get('dmpl__UnitPrice__c')) > (Decimal)(compareToLine.source.get('dmpl__UnitPrice__c'))) {
    //             returnValue = descending?-1:1;
    //         } else if ((Decimal)(source.get('dmpl__UnitPrice__c')) < (Decimal)(compareToLine.source.get('dmpl__UnitPrice__c'))) {
    //             returnValue = descending?1:-1;
    //         }    
    //         return returnValue;
    //     }
    // }
}