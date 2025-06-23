@isTest
public class SchemeHelper_Test {
    
//     @testSetup
//     public static void Setup()
//     {
//         CreateAccountGroup();
//         CreateBranch();
//         CreateItemGroup(); 
//         CreateSKu();
//         //CreateTaxGroup();
//         CreateScheme1();
//         CreateScheme();
//         //CreateSchemeLine();
//         CreateSchemeCondition();
//         CreateSchemeBenefits();
//         test.startTest();
//         CreateSaleOrder();
//         test.stopTest();
//     }
    



//     @isTest
//     Static void Test1()
//     {
//         try{
//             dmpl__SchemeLine__c schemeLine = [Select Id,Name,RewardApplicability__c,dmpl__SchemeId__r.dmpl__PeriodType__c,dmpl__RewardCustomLogic__c,(Select Id,Name,dmpl__RewardType__c,dmpl__DiscountedItemId__c,dmpl__RepeatReward__c,dmpl__DiscountAmount__c,dmpl__SchemeLineId__c,dmpl__DiscountedItemQuantity__c FROM SchemeBenefits__r) From dmpl__SchemeLine__c LIMIT 1];
//             List<dmpl__SchemeCondition__c> conditions = [Select dmpl__AccountId__c, dmpl__SchemeId__c,dmpl__ItemId__c,dmpl__ItemGroupId__c,dmpl__AccountGroupId__c,dmpl__ItemSKUId__c,dmpl__ConditionType__c,dmpl__ConditionQuantity__c,dmpl__ConditionValue__c,dmpl__SequenceNumber__c,dmpl__SchemeLineId__c,dmpl__ConditionOperator__c
//                                                 from dmpl__SchemeCondition__c];
//             dmpl__SchemeBenefit__c benefit = [Select Id,Name,dmpl__DiscountedItemId__c,dmpl__RepeatReward__c,dmpl__DiscountAmount__c,dmpl__SchemeLineId__c,dmpl__DiscountedItemQuantity__c FROM dmpl__SchemeBenefit__c LIMIT 1];
            
//             try {
//                 SchemeEngine.evaluatePerDocumentSchemeLine(schemeLine);
//             }catch(Exception e){}

//             try {
//                 SchemeEngine.getCustomApplicableBenefits(schemeLine);
//             }catch(Exception e){}
            
            
//             for(dmpl__SchemeCondition__c condition : conditions){
//                 try {
//                     try{
//                         SchemeEngine.evaluatePerDocumentCondition(condition);
//                     }catch(Exception e){}
                    
//                     try{
//                         SchemeEngine.evaluatePerPeriodCondition(condition, schemeLine);
//                     }catch(Exception e){}
//                     try{
//                         SchemeEngine.getPerPeriodTotalQuantity(condition, schemeLine);
//                     }catch(Exception e){}
//                     try{
//                         SchemeEngine.getPerPeriodTotalValue(condition, schemeLine, true);
//                     }catch(Exception e){}
//                     try{
//                         SchemeEngine.getPerPeriodTotalItemQuantity(condition, schemeLine);
//                     }catch(Exception e){}
//                     try{
//                         SchemeEngine.getPerPeriodTotalItemValue(condition, schemeLine, true);
//                     }catch(Exception e){}
//                     try{
//                         SchemeEngine.getPerPeriodTotalItemGroupQuantity(condition, schemeLine);
//                     }catch(Exception e){}
//                     try{
//                         SchemeEngine.getPerPeriodTotalItemGroupValue(condition, schemeLine, true);
//                     }catch(Exception e){}
//                     try{
//                         SchemeEngine.getPerPeriodTotalItemGroupValue(condition, schemeLine, true);
//                     }catch(Exception e){}
                    
//                 }catch(Exception e){}
//             }
            
//             try{
//                 SchemeEngine.applyDocumentDiscountdItem(benefit, 1, true, '');
//             }catch(Exception e){}
//             try{
//                 SchemeEngine.applyDocumentDiscountdItem(benefit, 1, true, '');
//             }catch(Exception e){}
            

//             try{
//                 SchemeEngine.evaluateNumberOperator(5, 'Equals', 6);
//                 SchemeEngine.evaluateNumberOperator(5, 'Does Not Equal', 6);
//                 SchemeEngine.evaluateNumberOperator(5, 'Greater Than', 6);
//                 SchemeEngine.evaluateNumberOperator(5, 'Greater Than Or Equal', 6);
//                 SchemeEngine.evaluateNumberOperator(5, 'Less Than', 6);
//                 SchemeEngine.evaluateNumberOperator(5, 'Less Than Or Equal', 6);

//                 SchemeEngine.evaluateCurrencyOperator(5.5, 'Equals', 6.6);
//                 SchemeEngine.evaluateCurrencyOperator(5.2, 'Does Not Equal', 6.5);
//                 SchemeEngine.evaluateCurrencyOperator(5.3, 'Greater Than', 6.4);
//                 SchemeEngine.evaluateCurrencyOperator(5.2, 'Greater Than Or Equal', 6.3);
//                 SchemeEngine.evaluateCurrencyOperator(5.1, 'Less Than', 6.2);
//                 SchemeEngine.evaluateCurrencyOperator(5.2, 'Less Than Or Equal', 6.2);

                
//             }catch(Exception e){}


//             try{
//                 SchemeEngine.evaluateConditions('Custom Logic Is Met', '{1} OR {2} OR {3}',  new List<Integer>{1,2,3});
//             }catch(Exception e){}
//             try{
//                 SchemeEngine.evaluateConditions('All Conditions Are Met', '{1} OR {2} OR {3}',  new List<Integer>{1,2,3});
//             }catch(Exception e){}
//             try{
//                 SchemeEngine.evaluateConditions('Any Condition Is Met', '{1} OR {2} OR {3}',  new List<Integer>{1,2,3});
//             }catch(Exception e){}

            
//             System.assert(schemeLine != null, 'Condition data found');
//         }
//         catch(exception e){}
//     }







//     @isTest
//     Static void getTotalQuantity()
//     {
//         try{
//         List<dmpl__SaleOrder__c> saleOrders = [SELECT Id,Name,dmpl__AccountId__c,dmpl__PartnerAccountId__c,dmpl__DocumentDate__c FROM dmpl__SaleOrder__c];
//         CreateSchemeCondition();
//         dmpl__SchemeCondition__c condition = [Select dmpl__AccountId__c, dmpl__SchemeId__c,dmpl__ItemId__c,dmpl__ItemGroupId__c,dmpl__AccountGroupId__c,dmpl__ItemSKUId__c,dmpl__ConditionType__c,dmpl__ConditionQuantity__c,dmpl__ConditionValue__c,dmpl__SequenceNumber__c,dmpl__SchemeLineId__c,dmpl__ConditionOperator__c
//                                               from dmpl__SchemeCondition__c Where dmpl__ConditionType__c='Quantity' LIMIT 1];
//         dmpl__SchemeCondition__c condition1 = [Select dmpl__AccountId__c, dmpl__SchemeId__c,dmpl__ItemId__c,dmpl__ItemGroupId__c,dmpl__AccountGroupId__c,dmpl__ItemSKUId__c,dmpl__ConditionType__c,dmpl__ConditionQuantity__c,dmpl__ConditionValue__c,dmpl__SequenceNumber__c,dmpl__SchemeLineId__c,dmpl__ConditionOperator__c
//                                               from dmpl__SchemeCondition__c Where dmpl__ConditionType__c='Item Value With Tax' LIMIT 1];
//         dmpl__SchemeCondition__c condition2 = [Select dmpl__AccountId__c, dmpl__SchemeId__c,dmpl__ItemId__c,dmpl__ItemGroupId__c,dmpl__AccountGroupId__c,dmpl__ItemSKUId__c,dmpl__ConditionType__c,dmpl__ConditionQuantity__c,dmpl__ConditionValue__c,dmpl__SequenceNumber__c,dmpl__SchemeLineId__c,dmpl__ConditionOperator__c
//                                               from dmpl__SchemeCondition__c Where dmpl__ConditionType__c='Item Group Value' LIMIT 1];
//         dmpl__SchemeCondition__c condition3 = [Select dmpl__AccountId__c, dmpl__SchemeId__c,dmpl__ItemId__c,dmpl__ItemGroupId__c,dmpl__AccountGroupId__c,dmpl__ItemSKUId__c,dmpl__ConditionType__c,dmpl__ConditionQuantity__c,dmpl__ConditionValue__c,dmpl__SequenceNumber__c,dmpl__SchemeLineId__c,dmpl__ConditionOperator__c
//                                               from dmpl__SchemeCondition__c Where dmpl__ConditionType__c='Value' LIMIT 1];
//         test.startTest();
//         SchemeEngine.processSchemes(saleOrders);
//         SchemeEngine.getTotalValue(condition3, true);
//         SchemeEngine.getTotalItemValue(condition1, true);
//         SchemeEngine.getTotalItemGroupValue(condition2,true);
//         SchemeEngine.getTotalQuantity(condition);
//         System.assert(saleOrders != null, 'Aggregate order data');
//         test.stopTest();
//         }catch(exception e){}
//     }
    
//     @isTest
//     Static void evaluatePerOrderCondition()
//     {
//         test.startTest();
//         //CreateSchemeCondition();
//         //Id SchemeLineId = new Id();
//         dmpl__SchemeCondition__c condition = [Select dmpl__AccountId__c, dmpl__SchemeId__c,dmpl__ItemId__c,dmpl__ItemGroupId__c,dmpl__AccountGroupId__c,dmpl__ItemSKUId__c,dmpl__ConditionType__c,dmpl__ConditionQuantity__c,dmpl__ConditionValue__c,dmpl__SequenceNumber__c,dmpl__SchemeLineId__c,dmpl__ConditionOperator__c
//                                               from dmpl__SchemeCondition__c Where dmpl__ConditionType__c='Quantity' LIMIT 1];
        
//         List<AggregateResult> agg = [SELECT
//                                      dmpl__ItemId__c,
//                                      dmpl__SKUId__c,
//                                      dmpl__ItemId__r.SchemeItemGroupId__c,
//                                      SUM(Quantity__c) TotalQuantity,
//                                      SUM(Amount__c) TotalAmount
//                                      FROM
//                                      PurchaseOrderLine__c
//                                      GROUP BY
//                                      dmpl__ItemId__c,
//                                      dmpl__SKUId__c,
//                                      dmpl__ItemId__r.SchemeItemGroupId__c
//                                     ];
        
//         //SchemeHelper.evaluatePerDocumentCondition(condition,agg);
//         SchemeController.getSchemeLines(condition.dmpl__SchemeId__c);
//         SchemeController.getSchemeLedgerEntries('dmpl__SaleOrder__c',condition.dmpl__ItemId__C);
//         SchemeController.getSchemeLedgerEntries('dmpl__SaleInvoice__c',condition.dmpl__ItemId__C);
//         SchemeController.getSchemeLedgerEntries('dmpl__PurchaseOrder__c',condition.dmpl__ItemId__C);
//         SchemeController.getSchemeLedgerEntries('dmpl__Bill__c',condition.dmpl__ItemId__C);
//         SchemeController.getSchemeLedgerEntries('dmpl__RepairOrder__c',condition.dmpl__ItemId__C);
//         SchemeController.getRecommendations(condition.dmpl__ItemId__C);
//         System.assert(condition != null, 'Condition data found');
//         test.stopTest();
//     }
    
    
//     @isTest
//     Static void evaluatePerOrderConditionAsValue()
//     {
//         try{
//         //CreateSchemeCondition();
//         dmpl__SchemeLine__c schemeLine = [Select Id,Name,RewardApplicability__c,dmpl__SchemeId__r.dmpl__PeriodType__c,dmpl__RewardCustomLogic__c,(Select Id,Name,dmpl__RewardType__c,dmpl__DiscountedItemId__c,dmpl__RepeatReward__c,dmpl__DiscountAmount__c,dmpl__SchemeLineId__c,dmpl__DiscountedItemQuantity__c FROM SchemeBenefits__r) From dmpl__SchemeLine__c LIMIT 1];
//         dmpl__SchemeCondition__c condition = [Select dmpl__AccountId__c, dmpl__SchemeId__c,dmpl__ItemId__c,dmpl__ItemGroupId__c,dmpl__AccountGroupId__c,dmpl__ItemSKUId__c,dmpl__ConditionType__c,dmpl__ConditionQuantity__c,dmpl__ConditionValue__c,dmpl__SequenceNumber__c,dmpl__SchemeLineId__c,dmpl__ConditionOperator__c
//                                               from dmpl__SchemeCondition__c Where dmpl__ConditionType__c='Value' LIMIT 1];
//         dmpl__SchemeBenefit__c benefit = [Select Id,Name,dmpl__DiscountedItemId__c,dmpl__RepeatReward__c,dmpl__DiscountAmount__c,dmpl__SchemeLineId__c,dmpl__DiscountedItemQuantity__c FROM dmpl__SchemeBenefit__c LIMIT 1];
        
//         //SchemeHelper.evaluatePerDocumentCondition(condition,agg);
//         SchemeEngine.applyPerDocumentSchemeLine(schemeLine,12);
//         //SchemeEngine.getCustomApplicableBenefits(schemeLine);
//         //SchemeEngine.getMaximumBenefit(schemeLine);
//         //SchemeEngine.getTotalItemQuantity(condition);
//         //SchemeEngine.evaluatePerPeriodSchemeLine(schemeLine);
//         System.assert(condition != null, 'Condition data found');
//         }
//         catch(exception e){}
//     }
    
//     @isTest
//     Static void getTotalItemSKUQuantity()
//     {
//         try{
//         List<dmpl__SaleOrder__c> saleOrders = [SELECT Id,Name,dmpl__AccountId__c,dmpl__PartnerAccountId__c,dmpl__DocumentDate__c FROM dmpl__SaleOrder__c];
//         test.startTest();
//         dmpl__SchemeLine__c schemeLine = [Select Id,Name,RewardApplicability__c From dmpl__SchemeLine__c LIMIT 1];
//         dmpl__SchemeCondition__c condition = [Select dmpl__AccountId__c, dmpl__SchemeId__c,dmpl__ItemId__c,dmpl__ItemGroupId__c,dmpl__AccountGroupId__c,dmpl__ItemSKUId__c,dmpl__ConditionType__c,dmpl__ConditionQuantity__c,dmpl__ConditionValue__c,dmpl__SequenceNumber__c,dmpl__SchemeLineId__c,dmpl__ConditionOperator__c
//                                               from dmpl__SchemeCondition__c Where dmpl__ConditionType__c='Value' LIMIT 1];
//         dmpl__SKU__c sku = [Select Id,Name from dmpl__SKU__c LIMIT 1];
//         dmpl__SchemeBenefit__c benefit = [Select Id,Name,RewardType__c FROM dmpl__SchemeBenefit__c WHERE RewardType__c = 'Line Level Discount Amount' LIMIT 1];
//         SchemeEngine.processSchemes(saleOrders);
//         SchemeEngine.getMaximumBenefit(schemeLine);
//         SchemeEngine.getTotalItemQuantity(condition);
//         //SchemeEngine.getTotalItemSKUQuantity(agg,sku.Id);
//         System.assert(sku != null, 'sku data found');
//         test.stopTest();
//         }catch(exception e){}
//     }
    
//     //@isTest
//     Static void getTotalItemGroupQuantity()
//     {
//         try{
//         test.startTest();
//         //CreateSchemeCondition();
//         dmpl__ItemGroup__c item = [Select Id,Name from dmpl__ItemGroup__c LIMIT 1];
//         //dmpl__SchemeCondition__c condition = [Select dmpl__AccountId__c, dmpl__SchemeId__c,dmpl__ItemId__c,dmpl__ItemGroupId__c,dmpl__AccountGroupId__c,dmpl__ItemSKUId__c,dmpl__ConditionType__c,dmpl__ConditionQuantity__c,dmpl__ConditionValue__c,dmpl__SequenceNumber__c,dmpl__SchemeLineId__c,dmpl__ConditionOperator__c
//           //                                    from dmpl__SchemeCondition__c Where dmpl__ConditionType__c='Item Group Quantity' LIMIT 1];
//         List<Id> itemIds = new List<Id>();
//         List<Id> partnerAccountIds = new List<Id>();
//         List<Id> branchIds = new List<Id>();
//         List<AggregateResult> agg = [SELECT
//                                      dmpl__ItemId__c,
//                                      dmpl__SKUId__c,
//                                      dmpl__ItemId__r.dmpl__SchemeItemGroupId__c,
//                                      SUM(Quantity__c) TotalQuantity,
//                                      SUM(Amount__c) TotalAmount
//                                      FROM
//                                      dmpl__PurchaseOrderLine__c
//                                      GROUP BY
//                                      dmpl__ItemId__c,
//                                      dmpl__SKUId__c,
//                                      dmpl__ItemId__r.dmpl__SchemeItemGroupId__c
//                                     ];
//         ItemController.getItemStocks(itemIds,partnerAccountIds,branchIds);
//         BulkOrderProcessingController.getItemStocks(itemIds,partnerAccountIds,branchIds);
//         //SchemeEngine.getTotalItemGroupQuantity(condition);
//         //SchemeEngine.getTotalItemGroupQuantity(condition);
//         System.assert(item != null, 'item data found');
//         test.stopTest();
//         }
//         catch(exception e){}
//     }
    
//     @isTest
//     Static void evaluatePerOrderConditionAsItemValue()
//     {
//         try{
//         test.startTest();
//         CreateSchemeCondition();
//         dmpl__SchemeCondition__c condition = [Select dmpl__AccountId__c, dmpl__SchemeId__c,dmpl__ItemId__c,dmpl__ItemGroupId__c,dmpl__AccountGroupId__c,dmpl__ItemSKUId__c,dmpl__ConditionType__c,dmpl__ConditionQuantity__c,dmpl__ConditionValue__c,dmpl__SequenceNumber__c,dmpl__SchemeLineId__c,dmpl__ConditionOperator__c,
//                                              dmpl__ItemLotTypeId__c from dmpl__SchemeCondition__c Where dmpl__ConditionType__c='Quantity' LIMIT 1];
        
//         List<AggregateResult> agg = [SELECT
//                                      dmpl__ItemId__c,
//                                      dmpl__SKUId__c,
//                                      dmpl__ItemId__r.SchemeItemGroupId__c,
//                                      SUM(Quantity__c) TotalQuantity,
//                                      SUM(Amount__c) TotalAmount
//                                      FROM
//                                      dmpl__PurchaseOrderLine__c
//                                      GROUP BY
//                                      dmpl__ItemId__c,
//                                      dmpl__SKUId__c,
//                                      dmpl__ItemId__r.SchemeItemGroupId__c
//                                     ];
        
//         SchemeEngine.evaluatePerDocumentCondition(condition);
//         SchemeEngine.doesItemGroupContains(condition.dmpl__ItemGroupId__c,condition.dmpl__ItemId__c,condition.dmpl__ItemSKUId__c,condition.dmpl__ItemLotTypeId__c);
//         SchemeEngine.postPOSchemeLeders();
//         SchemeEngine.getPOLines();
//         SchemeEngine.getBillLines();
//         System.assert(condition != null, 'condition data found');
//         test.stopTest();
//         }
//         catch(exception e){}
//     }
    
//     @isTest
//     Static void applyDiscount()
//     {
//         try{
//         test.startTest();
//         CreateSaleOrder();
//         Integer count = 1;
//         List<Id> ids = new List<Id>();
//         List<SourceObjectInfo> info = new List<SourceObjectInfo>();
//         dmpl__SchemeLine__c schemeLine = [Select Id,Name,RewardApplicability__c,dmpl__SchemeId__r.dmpl__PeriodType__c From dmpl__SchemeLine__c LIMIT 1];
//         dmpl__SchemeBenefit__c benefit = [Select Id,Name,dmpl__DiscountedItemId__c,dmpl__RepeatReward__c,dmpl__DiscountAmount__c,dmpl__SchemeLineId__c,dmpl__DiscountedItemQuantity__c,dmpl__RewardType__c FROM dmpl__SchemeBenefit__c LIMIT 1];
//         dmpl__SaleOrderLine__c sale = [Select Id, Name,dmpl__SchemeDiscountAmount__c,dmpl__IsPriceBundled__c,dmpl__SchemeDiscount__c,dmpl__SchemeLineId__c FROM dmpl__SaleOrderLine__c LIMIT 1];
//         //SchemeHelper.applyDocumentDiscountAmount(benefit,sale);
//         //SchemeHelper.applyDocumentRewardPoints(benefit,sale);
//         //SchemeHelper.applyDocumentDiscountdItem(benefit,sale,12,sale.dmpl__IsPriceBundled__c);
//         SchemeEngine.applyPerDocumentBenefit(benefit,10,schemeLine.dmpl__SchemeId__r.dmpl__PeriodType__c);
//         //SchemeEngine.applyDocumentDiscountPercent(benefit);
//         SchemeEngine.applySchemeBenefit(benefit, schemeLine.Id, benefit.Id, 10,info);
//         //SchemeController.applyScheme('',sale.Id,schemeLine.Id,benefit.Id,1,info);
//         //SchemeHelper.getQualifiedSchemeLines(benefit);
//         SchemeController.getQualifiedBenefits(benefit.Id,'',ids);
//         System.assert(benefit != null, 'benefit data found');
//         test.stopTest();
//     	}
//         catch(exception e){}
//     }
    
//     @isTest
//     private static void applyDocumentDiscountPercent()
//     {
//         try{
//         test.startTest();
//         List<SourceObjectInfo> info = new List<SourceObjectInfo>();
//         dmpl__SchemeLine__c schemeLine = [Select Id,Name,RewardApplicability__c From dmpl__SchemeLine__c LIMIT 1];
//         dmpl__SchemeBenefit__c benefit = [Select Id,Name,dmpl__DiscountedItemId__c,dmpl__RepeatReward__c,dmpl__DiscountAmount__c,dmpl__SchemeLineId__c,dmpl__DiscountedItemQuantity__c,dmpl__RewardType__c FROM dmpl__SchemeBenefit__c LIMIT 1];
//         dmpl__SaleOrderLine__c sale = [Select Id, Name,dmpl__SchemeDiscountAmount__c,dmpl__IsPriceBundled__c,dmpl__SchemeDiscount__c,dmpl__SchemeLineId__c FROM dmpl__SaleOrderLine__c LIMIT 1];
//         SchemeEngine.applyDocumentDiscountPercent(benefit);
//         SchemeController.applyScheme('',sale.Id,schemeLine.Id,benefit.Id,1,info);
        
//         //SchemeEngine.applySchemeBenefit(benefit, benefit.dmpl__SchemeLineId__c, benefit.Id, 10);
//         test.stopTest();
//         }
//         catch(exception e){}
//     }
    
//     @isTest
//     Static void applyDiscount1()
//     {
//         try{
//         test.startTest();
//         //CreateSaleOrder();
//         Integer count = 1;
//         dmpl__SchemeLine__c schemeLine = [Select Id,Name,RewardApplicability__c,dmpl__SchemeId__r.dmpl__PeriodType__c From dmpl__SchemeLine__c LIMIT 1];    
//         dmpl__SchemeBenefit__c benefit = [Select Id,Name,dmpl__DiscountedItemId__c,RewardType__c,dmpl__RepeatReward__c,dmpl__DiscountAmount__c,dmpl__SchemeLineId__c,dmpl__DiscountedItemQuantity__c FROM dmpl__SchemeBenefit__c WHERE RewardType__c = 'Reward Points' LIMIT 1];
//         dmpl__SaleOrderLine__c sale = [Select Id, Name,dmpl__SchemeDiscountAmount__c,dmpl__IsPriceBundled__c,dmpl__SchemeDiscount__c,dmpl__SchemeLineId__c FROM dmpl__SaleOrderLine__c LIMIT 1];
//         //SchemeHelper.applyDocumentDiscountAmount(benefit,sale);
//         SchemeEngine.applyDocumentRewardPoints(benefit);
//         SchemeEngine.applyDocumentDiscountdItem(benefit,count,true,schemeLine.dmpl__SchemeId__r.dmpl__PeriodType__c);
//         SchemeEngine.evaluateNumberOperator(10,'',10.20);
//         SchemeEngine.evaluateCurrencyOperator(10.50,'',10.10);
//         SchemeEngine.ensureItemGroupRetreived('Per order');
//         //SchemeHelper.applyPerDocumentBenefit(benefit,sale,count);
//         //SchemeHelper.applyDocumentDiscountPercent(benefit,sale);
//         System.assert(benefit != null, 'benefit data found');
//         test.stopTest();
//     	}
//         catch(exception e){}
//     }
    
//     @isTest
//     Static void applyDiscount2()
//     {
//         try{
//         test.startTest();
//         CreateSaleOrder();
//         Integer count = 1;
//         dmpl__SchemeBenefit__c benefit = [Select Id,Name,dmpl__DiscountedItemId__c,dmpl__RepeatReward__c,dmpl__DiscountAmount__c,dmpl__SchemeLineId__c,dmpl__DiscountedItemQuantity__c FROM dmpl__SchemeBenefit__c LIMIT 1];
//         dmpl__SaleOrderLine__c sale = [Select Id, Name,dmpl__SchemeDiscountAmount__c,dmpl__IsPriceBundled__c,dmpl__SchemeDiscount__c,dmpl__SchemeLineId__c FROM dmpl__SaleOrderLine__c LIMIT 1];
//         //SchemeHelper.applyDocumentDiscountAmount(benefit,sale);
//         //SchemeHelper.applyDocumentRewardPoints(benefit,sale);
//         //SchemeHelper.applyDocumentDiscountdItem(benefit,sale,12,sale.dmpl__IsPriceBundled__c);
//         //SchemeHelper.applyPerDocumentBenefit(benefit,sale,count);
//         //SchemeHelper.applyDocumentDiscountPercent(benefit,sale);
//         SchemeController.getQualifiedSchemeSlabs('dmpl__SchemeLine__c',sale.Id);
//         SchemeController.getDocumentObject('',sale.Id);
//         System.assert(benefit != null, 'benefit data found');
//         test.stopTest();}
//         catch(exception e){}
//     }
    
//     @isTest
//     Static void applyDiscount3()
//     {
//         try{
//         test.startTest();
//         CreateSaleOrder();
//         Integer count = 1;
//         dmpl__SchemeBenefit__c benefit = [Select Id,Name,dmpl__DiscountedItemId__c,dmpl__RepeatReward__c,dmpl__DiscountAmount__c,dmpl__SchemeLineId__c,dmpl__DiscountedItemQuantity__c FROM dmpl__SchemeBenefit__c LIMIT 1];
//         dmpl__SaleOrderLine__c sale = [Select Id, Name,dmpl__SchemeDiscountAmount__c,dmpl__IsPriceBundled__c,dmpl__SchemeDiscount__c,dmpl__SchemeLineId__c FROM dmpl__SaleOrderLine__c LIMIT 1];
//         SchemeEngine.applyDocumentDiscountAmount(benefit,12);
        
//         //SchemeHelper.applyDocumentRewardPoints(benefit,sale);
//         //SchemeHelper.applyDocumentDiscountdItem(benefit,sale,12,sale.dmpl__IsPriceBundled__c);
//         //SchemeHelper.applyPerDocumentBenefit(benefit,sale,count);
//         //SchemeHelper.applyDocumentDiscountPercent(benefit,sale);
//         System.assert(benefit != null, 'benefit data found');
//         test.stopTest();}
//         catch(exception e){}
//     }
    
//     @isTest
//     Static void applyDiscount4()
//     {
//         try{
//         test.startTest();
//         CreateSaleOrder();
//         Integer count = 1;
//         dmpl__SchemeBenefit__c benefit = [Select Id,Name,dmpl__DiscountedItemId__c,dmpl__RepeatReward__c,dmpl__DiscountAmount__c,dmpl__SchemeLineId__c,dmpl__DiscountedItemQuantity__c FROM dmpl__SchemeBenefit__c LIMIT 1];
//         dmpl__SaleOrderLine__c sale = [Select Id, Name,dmpl__SchemeDiscountAmount__c,dmpl__IsPriceBundled__c,dmpl__SchemeDiscount__c,dmpl__SchemeLineId__c FROM dmpl__SaleOrderLine__c LIMIT 1];
//         //SchemeHelper.applyDocumentDiscountAmount(benefit,sale);
//         //SchemeHelper.applyDocumentRewardPoints(benefit,sale);
//         //SchemeHelper.applyDocumentDiscountdItem(benefit,sale,12,sale.dmpl__IsPriceBundled__c);
//         //SchemeHelper.applyPerDocumentBenefit(benefit,sale,count);
//         //SchemeHelper.applyDocumentDiscountPercent(benefit,sale);
//         System.assert(benefit != null, 'benefit data found');
//         test.stopTest();}
//         catch(exception e){}
//     }
    
//     @isTest
//     Static void applyPerPeriodSchemeLine()
//     {
//         test.startTest();
//         dmpl__SchemeLine__c line = [Select Id,Name,dmpl__SchemeId__c,dmpl__DefinitionFilterCriteria__c FROM dmpl__SchemeLine__c LIMIT 1];
//         dmpl__SaleOrderLine__c sale = [Select Id, Name,dmpl__SchemeDiscountAmount__c,dmpl__SchemeDiscount__c,dmpl__SchemeLineId__c FROM dmpl__SaleOrderLine__c LIMIT 1];
//         SchemeEngine.applyPerPeriodSchemeLine(line);
//         SchemeEngine.resetPerPeriodSchemeLine(line);
//        // SchemeEngine.evaluatePerPeriodSchemeLine(line);
//         System.assert(line != null, 'scheme line data found');
//         test.stopTest();
//     }
    
//     @isTest
//     Static void getMinimumBenefit()
//     {
//         try{
//         test.startTest();
//         CreateSchemeBenefitNew();
//         dmpl__SchemeBenefit__c benefit = [Select Id,Name,RewardType__c From dmpl__SchemeBenefit__c WHERE RewardType__c = 'Line Level Discount Amount' LIMIT 1];
//         dmpl__SchemeLine__c line = [Select Id,Name,dmpl__SchemeId__c FROM dmpl__SchemeLine__c LIMIT 1];
//         dmpl__SaleOrderLine__c sale = [Select Id, Name,dmpl__SchemeDiscountAmount__c,dmpl__SchemeDiscount__c,dmpl__SchemeLineId__c FROM dmpl__SaleOrderLine__c LIMIT 1];
//         SchemeEngine.getMaximumBenefit(line);
//         System.assert(line != null, 'scheme line data found');
//         test.stopTest();
//         }catch(exception e){}
//     }
    
//     @isTest
//     Static void getTotalItemSKUValue()
//     {
//         try{
//         test.startTest();
//         dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c LIMIT 1];
//         List<AggregateResult> agg = [SELECT
//                                      ItemId__c,
//                                      SKUId__c,
//                                      ItemId__r.SchemeItemGroupId__c,
//                                      SUM(Quantity__c) TotalQuantity,
//                                      SUM(Amount__c) TotalAmount
//                                      FROM
//                                      PurchaseOrderLine__c
//                                      GROUP BY
//                                      ItemId__c,
//                                      SKUId__c,
//                                      ItemId__r.SchemeItemGroupId__c
//                                     ];
//         SchemeEngine.getBillSummary();
//         //SchemeHelper.getTotalItemSKUValue(agg,sku.Id);
//         System.assert(sku != null, 'sku data found');
//         test.stopTest();
//         }catch(exception e){}
//     }
    
    
//     private static void CreateAccountGroup()
//     {
//         dmpl__AccountGroup__c accountGroup= new dmpl__AccountGroup__c (Name= 'Test-AccountGroup', 
//                                                                        dmpl__AccountGroupType__c='Scheme');
//         insert accountGroup;
    
//       /*  List<Account> account = new List<Account>();
//         account.add(new Account(Name = 'Test - Account', 
//                                 dmpl__LastName__c = 'Sale Order',
//                                 Fax = '09876',
//                                 Phone = '1234567891',
//                                 Website = 'www.Dealermatix.com',
//                                 Type = 'Prospect',
//                                 NumberOfEmployees = 2,
//                                 Industry = 'Education',
//                                 AnnualRevenue = 1000,
//                                 Description = 'Accounts added',
//                                 dmpl__IsPartnerAccount__c = false,
//                                 dmpl__IsActive__c = True,
//                                 dmpl__IsTaxExempted__c = True,
//                                 dmpl__IsSupplierAccount__c = false,
//                                 dmpl__IsCustomerAccount__c = False,
//                                 dmpl__PartnerTaxAccountGroupId__c = accountGroup.Id,
//                                 dmpl__CustomerPriceAccountGroupId__c = accountGroup.Id,
//                                 dmpl__CustomerDiscountAccountGroupId__c = accountGroup.Id,
//                                 dmpl__PartnerSchemeAccountGroupId__c = accountGroup.Id,                                
//                                 dmpl__PartnerPriceAccountGroupId__c = accountGroup.Id,
//                                 dmpl__PartnerDiscountAccountGroupId__c = accountGroup.Id,
//                                 dmpl__CustomerSchemeAccountGroupId__c = accountGroup.Id
//                                ));
//         insert account; */
        
//         Account partneraccount = new Account(Name = 'Partner-Test-Account',
//                                              dmpl__LastName__c = 'Sale Order',
//                                              dmpl__IsPartnerAccount__c = True, 
//                                              dmpl__IsActive__c = true);
//         insert partneraccount;
        
//         Account customerAccount = new Account(Name = 'Customer-Test-Account',
//                                               dmpl__LastName__c = 'Sale Order',
//                                               dmpl__IsCustomerAccount__c = True,
//                                               dmpl__IsPartnerAccount__c = True,
//                                               dmpl__IsActive__c = true);
//         insert customerAccount;
        
//       /*  Account supplierAccount = new Account(Name = 'Supplier-Test-Account',
//                                               dmpl__LastName__c = 'Sale Order',
//                                               dmpl__IsSupplierAccount__c = True,
//                                               dmpl__IsActive__c = true);
//         insert supplierAccount; */
//     }
    
//     private static void CreateBranch()
//     {
//         List<dmpl__Branch__c> branch = new List<dmpl__Branch__c>();
//         Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
//         branch.Add(new dmpl__Branch__c(dmpl__PartnerAccountId__c =partnerAccount.Id,
//                                        Name = 'Test-Branch',
//                                        dmpl__IsActive__c = true,
//                                        dmpl__MarketingName__c = 'Hero Electric',
//                                        dmpl__Website__c = 'www.dealermatix.com',
//                                        dmpl__Email__c = 'Dealer@Outlook.com',
//                                        dmpl__MobileNumber__c = 99,
//                                        dmpl__Phone__c = '8888888888',
//                                        dmpl__AllowSales__c = true,
//                                        dmpl__AllowService__c = true,
//                                        dmpl__AllowPurchase__c = true,
//                                        dmpl__AllowInventory__c = true,
//                                        dmpl__IsHomeDeliveryAvailable__c = true,
//                                        dmpl__IsPickupDropAvailable__c = true,
//                                        dmpl__SalesPhone__c = '7777777777',
//                                        dmpl__ServiceEmail__c = 'Customer@Outlook.com'));
        
//       /*  Account partnerAccount1 = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
//         branch.Add(new dmpl__Branch__c(dmpl__PartnerAccountId__c =partnerAccount.Id,
//                                        Name = 'Test-Branch1',
//                                        dmpl__IsActive__c = true,
//                                        dmpl__MarketingName__c = 'Hero Electric',
//                                        dmpl__Website__c = 'www.dealermatix.com',
//                                        dmpl__Email__c = 'Dealer@Outlook.com',
//                                        dmpl__MobileNumber__c = 99,
//                                        dmpl__Phone__c = '1888888888',
//                                        dmpl__AllowSales__c = true,
//                                        dmpl__AllowService__c = true,
//                                        dmpl__AllowPurchase__c = true,
//                                        dmpl__AllowInventory__c = true,
//                                        dmpl__IsHomeDeliveryAvailable__c = true,
//                                        dmpl__IsPickupDropAvailable__c = true,
//                                        dmpl__SalesPhone__c = '7177777777',
//                                        dmpl__ServiceEmail__c = 'Customer1@Outlook.com')); */
//         insert branch;
//     }
    
//     private static void CreateItemGroup()
//     {
//         List<dmpl__ItemGroup__c> itemGroup = new List<dmpl__ItemGroup__c> ();
//         itemGroup.Add(new dmpl__ItemGroup__c(Name = 'Item Group Test',
//                                              dmpl__ItemGroupType__c = 'Scheme'
//                                             ));
//         insert itemGroup;
    
//         List<dmpl__Item__c> productItem = new List<dmpl__Item__c>();
//         productItem.Add(new dmpl__Item__c(Name = 'Test-Item',
//                                           dmpl__ItemCode__c = 'DMPL',
//                                           dmpl__ItemType__c = 'Product',
//                                           dmpl__ItemSubType__c = '',
//                                           dmpl__SchemeItemGroupId__c=itemGroup[0].Id,
//                                           dmpl__Description__c = '',
//                                           dmpl__ItemFamily__c = 'Sample',
//                                           dmpl__ItemSegment__c = 'Sample',
//                                           dmpl__Make__c = 'Sample',
//                                           dmpl__Model__c = 'Sample',
//                                           dmpl__TrackInventory__c = true,
//                                           dmpl__TrackLots__c = true,
//                                           dmpl__IsSKURequired__c = true,
//                                           dmpl__RequireInspectionOnReceipt__c = true,
//                                           dmpl__RequireInspectionOnDelivery__c = true,
//                                           dmpl__AllowService__c = true,
//                                           dmpl__TrackAsset__c = true,                               
//                                           dmpl__IsActive__c = true,
//                                           dmpl__IsRegistrationRequired__c = true,
//                                           dmpl__GTIN__c = 'BR123',
//                                           dmpl__RFID__c = 'O1234fgh',
//                                           dmpl__IsPackage__c = true
//                                          ));
//         insert productItem;
        
//        /* List<dmpl__Item__c> chargeItem = new List<dmpl__Item__c>();
//         chargeItem.Add(new dmpl__Item__c(Name = 'Test-Item',
//                                          dmpl__ItemCode__c = 'DMPL',
//                                          dmpl__ItemType__c = 'Charge Item',
//                                          dmpl__ItemSubType__c = '',
//                                          dmpl__Description__c = '',
//                                          dmpl__ItemFamily__c = 'Sample',
//                                          dmpl__ItemSegment__c = 'Sample',
//                                          dmpl__Make__c = 'Sample',
//                                          dmpl__Model__c = 'Sample',                       
//                                          dmpl__IsActive__c = true,
//                                          dmpl__OnlySoldInPackage__c=True
//                                         ));
//         insert chargeItem;
        
//         List<dmpl__Item__c> subsItem = new List<dmpl__Item__c>();
//         subsItem.Add(new dmpl__Item__c(Name = 'Test-Item',
//                                        dmpl__ItemCode__c = 'DMPL',
//                                        dmpl__ItemType__c = 'Subscription',
//                                        dmpl__ItemSubType__c = '',
//                                        dmpl__Description__c = '',
//                                        dmpl__ItemFamily__c = 'Sample',
//                                        dmpl__ItemSegment__c = 'Sample',
//                                        dmpl__Make__c = 'Sample',
//                                        dmpl__Model__c = 'Sample',                       
//                                        dmpl__IsPackage__c = true
//                                       ));
//         insert subsItem; */
//     }
    
//     private static void CreateSKu()
//     {
//         List<dmpl__SKU__c> sku = new List<dmpl__SKU__c>();
//         dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
//         sku.add(new dmpl__SKU__c(Name = 'Test - SKU',
//                                  dmpl__SKUCode__c = 'Test - SKU - Code',
//                                  dmpl__UnitOfMeasureOfConversion__c = 10,
//                                  dmpl__ProductColor__c = 'Sample',
//                                  dmpl__IsDefault__c = false,
//                                  dmpl__QuantityUnitOfMeasure__c ='Sample',
//                                  dmpl__ItemId__c = item.Id));
//         insert sku;
    
//         List<dmpl__Resource__c> resource = new List<dmpl__Resource__c>();
//         Account partnerAccount = [Select Id,Name From Account LIMIT 1];
//         dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
//         resource.add(new dmpl__Resource__c(Name = 'Test - Resource',
//                                            dmpl__ResourceType__c = 'Technician',
//                                            dmpl__IsActive__c = true,
//                                            dmpl__Phone__c = '9999999999',
//                                            dmpl__DefaultPartnerAccountId__c = partnerAccount.Id,
//                                            dmpl__DefaultBranchId__c = branch.Id
//                                           ));
//         insert resource;
    
//         List<dmpl__TaxGroup__c> taxGroup = new List<dmpl__TaxGroup__c>();
//         Account account=[Select Id,Name from Account Where Name='Partner-Test-Account'];
//         //dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Limit 1];
//         dmpl__AccountGroup__c AccountGrp = [Select Id, Name FROM dmpl__AccountGroup__c LIMIT 1];
//         taxGroup.Add(new dmpl__TaxGroup__c(Name = 'Test - Tax Group',
//                                            dmpl__PartnerAccountId__c = account.Id,
//                                            dmpl__BranchId__c = branch.Id,
//                                            dmpl__PartnerAccountGroupId__c = AccountGrp.Id,
//                                            dmpl__Description__c = 'Test-Description',
//                                            dmpl__IsActive__c = true));
//         insert taxGroup;
//     }
    
//     private static void CreateScheme()
//     {
//         List<dmpl__Scheme__c> scheme = new List<dmpl__Scheme__c>();
//         dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch'];
//         Account customerAccount = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
//         dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c LIMIT 1];
//         scheme.Add(new dmpl__Scheme__c(dmpl__PeriodType__c = 'Per Order',
//                                        Name='Scheme1',
//                                        dmpl__ValidTo__c= Datetime.now().addDays(365).Date(),
//                                        dmpl__Status__c='Approved',
//                                        dmpl__MultipleFulfilmentTreatment__c='Apply Last Fulfilled',
//                                        dmpl__SchemeType__c='Per Sale Order',
//                                        dmpl__BranchId__c = branch.Id,
//                                        dmpl__ValidFrom__c = date.today()-(2),
//                                        dmpl__PartnerAccountId__c = null,
//                                        dmpl__PartnerAccountGroupId__c = null));
//         insert scheme;

//         List<dmpl__Scheme__c> scheme1 = new List<dmpl__Scheme__c>();
//         scheme1.Add(new dmpl__Scheme__c(dmpl__PeriodType__c = 'Quarterly',
//                                         Name='Scheme2',
//                                         dmpl__ValidTo__c= Datetime.now().addDays(365).Date(),
//                                         dmpl__Status__c='Approved',
//                                         dmpl__MultipleFulfilmentTreatment__c='Apply First Fulfilled',
//                                         dmpl__SchemeType__c='Sales Order Per Period',
//                                         dmpl__BranchId__c = branch.Id,
//                                         dmpl__ValidFrom__c = date.today()-(2),
//                                         dmpl__PartnerAccountId__c = null,
//                                         dmpl__PartnerAccountGroupId__c = null));
//         insert scheme1;
    
//         List<dmpl__SchemeLine__c> schemeLine = new List<dmpl__SchemeLine__c>();
//         //dmpl__Scheme__c scheme =[Select Id, Name,dmpl__SchemeType__c,dmpl__MultipleFulfilmentTreatment__c,dmpl__PeriodType__c from dmpl__Scheme__c 
//           //                       where  dmpl__SchemeType__c='Per Sale Order'
//             //                     Limit 1];
//         schemeLine.Add(new dmpl__SchemeLine__c(dmpl__DefinitionFilterCriteria__c = 'All Conditions Are Met',
//                                                dmpl__SchemeId__c = scheme1[0].Id,
//                                                dmpl__SequenceNumber__c = 1,
//                                                dmpl__RewardApplicability__c = 'All Rewards'));
//         insert schemeLine;
        
//         List<dmpl__SchemeLine__c> schemeLine1 = new List<dmpl__SchemeLine__c>();
//         dmpl__Scheme__c scheme2 =[Select Id, Name,dmpl__SchemeType__c,dmpl__MultipleFulfilmentTreatment__c,dmpl__PeriodType__c from dmpl__Scheme__c where  dmpl__SchemeType__c='Sales Order Per Period' Limit 1];
//         schemeLine1.Add(new dmpl__SchemeLine__c(dmpl__DefinitionFilterCriteria__c = 'Always (No Criteria)',
//                                                 dmpl__SchemeId__c = scheme2.Id,
//                                                 dmpl__SequenceNumber__c = 2,
//                                                 dmpl__RewardApplicability__c = 'Any One With Lowest Value'));
//         insert schemeLine1;
//     }
    
//     @isTest
//     private static void verifySchemes()
//     {
//         try{
//         test.startTest();
//         List<dmpl__Scheme__c> scheme = [Select Id,Name,dmpl__PeriodType__c From dmpl__Scheme__c LIMIT 1];
//         scheme[0].dmpl__PeriodType__c = 'Per Purchase Order';
//         update scheme;
        
//         scheme[0].dmpl__PeriodType__c = 'Per Sale Invoice';
//         update scheme;
        
//         scheme[0].dmpl__PeriodType__c = 'Per Sale Order And Invoice';
//         update scheme;
        
//         scheme[0].dmpl__PeriodType__c = 'Per Bill';
//         update scheme;
        
//         scheme[0].dmpl__PeriodType__c = 'Sales Order Per Period';
//         update scheme;
        
//         scheme[0].dmpl__PeriodType__c = 'Purchase Order Per Period';
//         update scheme;
//         test.stopTest();
//         }catch(exception e){}
//     }
    
//     private static void CreateScheme1()
//     {
//         List<dmpl__Scheme__c> scheme1 = new List<dmpl__Scheme__c>();
//         dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch'];
//         Account customerAccount = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
//         dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c LIMIT 1];
//         scheme1.Add(new dmpl__Scheme__c(dmpl__PeriodType__c = 'Monthly',
//                                         Name='Scheme2',
//                                         dmpl__ValidTo__c= Datetime.now().addDays(150).Date(),
//                                         dmpl__Status__c='Approved',
//                                         dmpl__MultipleFulfilmentTreatment__c='Apply First Fulfilled',
//                                         dmpl__SchemeType__c='Per Purchase Order',
//                                         dmpl__BranchId__c = branch.Id,
//                                         dmpl__ValidFrom__c = date.today(),
//                                         dmpl__PartnerAccountId__c = null,
//                                         dmpl__PartnerAccountGroupId__c = null));
//         insert scheme1;
//     }
    
//     private static void CreateSchemeCondition()
//     {
//         List<dmpl__SchemeCondition__c> schemeCondition = new List<dmpl__SchemeCondition__c>();
//         dmpl__Scheme__c scheme =[Select Id, Name from dmpl__Scheme__c Limit 1];
//         dmpl__SchemeLine__c schemeLine =[Select Id, Name from dmpl__SchemeLine__c WHERE dmpl__DefinitionFilterCriteria__c = 'All Conditions Are Met'  Limit 1];
//         Account customerAccount = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
//         dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c LIMIT 1];
//         dmpl__Item__c item = [Select Id,Name From dmpl__Item__c where dmpl__ItemType__c='Product'  LIMIT 1];
//         dmpl__ItemGroup__c itemGroup =[Select Id, Name from dmpl__ItemGroup__c Limit 1];
//         dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
//         schemeCondition.Add(new dmpl__SchemeCondition__c(dmpl__AccountId__c =customerAccount.Id,
//                                                          dmpl__SchemeId__c = scheme.Id,
//                                                          dmpl__ItemId__c=item.Id,
//                                                          dmpl__ItemGroupId__c=itemGroup.Id,         
//                                                          dmpl__AccountGroupId__c =accountGroup.Id,
//                                                          dmpl__ItemSKUId__c=sku.Id,         
//                                                          dmpl__ConditionType__c='Quantity',
//                                                          dmpl__ConditionQuantity__c =5,
//                                                          dmpl__ConditionValue__c = 100,
//                                                          dmpl__SequenceNumber__c = 1,
//                                                          dmpl__SchemeLineId__c=schemeLine.Id,
//                                                          dmpl__ConditionOperator__c = 'Greater Than'));
//         insert schemeCondition;
        
//         List<dmpl__SchemeCondition__c> schemeCondition1 = new List<dmpl__SchemeCondition__c>();
//         dmpl__Scheme__c scheme1 =[Select Id, Name from dmpl__Scheme__c  where  dmpl__SchemeType__c='Sales Order Per Period'  Limit 1];
//         dmpl__SchemeLine__c schemeLine1 =[Select Id, Name from dmpl__SchemeLine__c where dmpl__SchemeId__r.dmpl__SchemeType__c='Sales Order Per Period' AND dmpl__DefinitionFilterCriteria__c = 'All Conditions Are Met' Limit 1];
//         schemeCondition1.Add(new dmpl__SchemeCondition__c(dmpl__AccountId__c =customerAccount.Id,
//                                                           dmpl__SchemeId__c = scheme1.Id,
//                                                           dmpl__ItemId__c=item.Id,
//                                                           dmpl__ItemGroupId__c=itemGroup.Id,         
//                                                           dmpl__AccountGroupId__c =accountGroup.Id,
//                                                           dmpl__ItemSKUId__c=sku.Id,         
//                                                           dmpl__ConditionType__c='Value',
//                                                           dmpl__ConditionValue__c = 100,
//                                                           dmpl__SequenceNumber__c = 2,
//                                                           dmpl__SchemeLineId__c=schemeLine1.Id,
//                                                           dmpl__ConditionOperator__c = 'Greater Than'));
//         insert schemeCondition1;
        
//         List<dmpl__SchemeCondition__c> schemeCondition2 = new List<dmpl__SchemeCondition__c>();
//         schemeCondition2.Add(new dmpl__SchemeCondition__c(dmpl__AccountId__c =customerAccount.Id,
//                                                           dmpl__SchemeId__c = scheme.Id,
//                                                           dmpl__ItemId__c=item.Id,
//                                                           dmpl__ConditionType__c='Item Value With Tax',
//                                                           dmpl__ConditionValue__c = 100,
//                                                           dmpl__SequenceNumber__c = 3,
//                                                           dmpl__SchemeLineId__c=schemeLine.Id,        
//                                                           dmpl__ConditionOperator__c = 'Equals'));
//         insert schemeCondition2;
        
//         List<dmpl__SchemeCondition__c> schemeCondition3 = new List<dmpl__SchemeCondition__c>();
//         schemeCondition3.Add(new dmpl__SchemeCondition__c(dmpl__AccountId__c =customerAccount.Id,
//                                                           dmpl__SchemeId__c = scheme.Id,
//                                                           dmpl__ItemId__c=item.Id,
//                                                           dmpl__ItemGroupId__c=itemGroup.Id, 
//                                                           dmpl__ConditionType__c='Item Group Value',
//                                                           dmpl__ConditionValue__c = 100,
//                                                           dmpl__SequenceNumber__c = 3,
//                                                           dmpl__SchemeLineId__c=schemeLine.Id,        
//                                                           dmpl__ConditionOperator__c = 'Equals'));
//         insert schemeCondition3;
//     }
    
//     private static void CreateSchemeBenefits()
//     {
//         List<dmpl__SchemeBenefit__c> schemeBenefit = new List<dmpl__SchemeBenefit__c>();
//         dmpl__Scheme__c scheme =[Select Id, Name from dmpl__Scheme__c Limit 1];
//         dmpl__SchemeLine__c schemeLine =[Select Id, Name from dmpl__SchemeLine__c WHERE dmpl__RewardApplicability__c = 'All Rewards' Limit 1];
//         dmpl__Item__c item = [Select Id,Name From dmpl__Item__c where dmpl__ItemType__c='Product'  LIMIT 1];
//         dmpl__ItemGroup__c itemGroup =[Select Id, Name from dmpl__ItemGroup__c Limit 1];
//         dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
//         Account customerAccount = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
//         schemeBenefit.Add(new dmpl__SchemeBenefit__c(dmpl__SchemeId__c = scheme.Id, 
//                                                     DiscountPercent__c=5,
//                                                      DiscountAmount__c=100,
//                                                      dmpl__RewardType__c='Reward Points',
//                                                      dmpl__SequenceNumber__c = 1,
//                                                      dmpl__RepeatReward__c =  true,
//                                                      dmpl__SchemeLineId__c=schemeLine.Id       
//                                                     ));
//         insert schemeBenefit;
        
//         List<dmpl__SchemeBenefit__c> schemeBenefit1 = new List<dmpl__SchemeBenefit__c>();
//         dmpl__Scheme__c scheme1 =[Select Id, Name,dmpl__SchemeType__c,dmpl__MultipleFulfilmentTreatment__c,dmpl__PeriodType__c from dmpl__Scheme__c where  dmpl__SchemeType__c='Sales Order Per Period' Limit 1];
//         dmpl__SchemeLine__c schemeLine1 =[Select Id, Name from dmpl__SchemeLine__c  where dmpl__DefinitionFilterCriteria__c = 'Always (No Criteria)' AND dmpl__RewardApplicability__c = 'Any One With Lowest Value' Limit 1];
//         schemeBenefit1.Add(new dmpl__SchemeBenefit__c(dmpl__SchemeId__c = scheme1.Id, 
//                                                       DiscountAmount__c=500,
//                                                       DiscountPercent__c=4,
//                                                       dmpl__RewardType__c='Line Level Discount Amount',
//                                                       dmpl__SequenceNumber__c = 2,
//                                                       dmpl__RepeatReward__c =  true,
//                                                       dmpl__SchemeLineId__c=schemeLine1.Id       
//                                                      ));
//         insert schemeBenefit1;
        
//         List<dmpl__SchemeBenefit__c> schemeBenefit3 = new List<dmpl__SchemeBenefit__c>();
//         schemeBenefit3.Add(new dmpl__SchemeBenefit__c(dmpl__SchemeId__c = scheme1.Id, 
//                                                       DiscountAmount__c=500,
//                                                       DiscountPercent__c=4,
//                                                       dmpl__DiscountedItemId__c = item.Id,
//                                                       dmpl__RewardType__c='Discounted Item',
//                                                       dmpl__SequenceNumber__c = 2,
//                                                       dmpl__RepeatReward__c =  true,
//                                                       dmpl__SchemeLineId__c=schemeLine1.Id       
//                                                      ));
//         insert schemeBenefit3;
        
//         List<dmpl__SchemeBenefit__c> schemeBenefit4 = new List<dmpl__SchemeBenefit__c>();
//         schemeBenefit4.Add(new dmpl__SchemeBenefit__c(dmpl__SchemeId__c = scheme1.Id, 
//                                                       DiscountAmount__c=500,
//                                                       DiscountPercent__c=4,
//                                                       dmpl__DiscountedItemGroupId__c = itemGroup.Id,
//                                                       dmpl__RewardType__c='Discounted Item Group',
//                                                       dmpl__SequenceNumber__c = 2,
//                                                       dmpl__RepeatReward__c =  true,
//                                                       dmpl__SchemeLineId__c=schemeLine1.Id       
//                                                      ));
//         insert schemeBenefit4;
//     }    
    
//     @isTest
//     public static void CreateSchemeBenefitNew()
//     {
//         List<dmpl__SchemeBenefit__c> schemeBenefit = new List<dmpl__SchemeBenefit__c>();
//         dmpl__Scheme__c scheme =[Select Id, Name from dmpl__Scheme__c Limit 1];
//         dmpl__SchemeLine__c schemeLine =[Select Id, Name from dmpl__SchemeLine__c WHERE dmpl__RewardApplicability__c = 'All Rewards' Limit 1];
//         dmpl__Item__c item = [Select Id,Name From dmpl__Item__c where dmpl__ItemType__c='Product'  LIMIT 1];
//         dmpl__ItemGroup__c itemGroup =[Select Id, Name from dmpl__ItemGroup__c Limit 1];
//         dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
//         Account customerAccount = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
//         schemeBenefit.Add(new dmpl__SchemeBenefit__c(dmpl__SchemeId__c = scheme.Id, 
//                                                     DiscountPercent__c=5,
//                                                      DiscountAmount__c=100,
//                                                      dmpl__RewardType__c='Line Level Discount Amount',
//                                                      dmpl__SequenceNumber__c = 1,
//                                                      dmpl__RepeatReward__c =  true,
//                                                      dmpl__SchemeLineId__c=schemeLine.Id       
//                                                     ));
//         insert schemeBenefit;

//     }
    
//     private static void CreateSaleOrder()
//     {
//         List<dmpl__SaleOrder__c> saleOrder = new List<dmpl__SaleOrder__c>();
//         dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch' LIMIT 1];
//         //dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
//         Account partnerAccount1 = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
//         saleOrder.Add(new dmpl__SaleOrder__c(dmpl__AccountId__c = partnerAccount1.Id,
//                                              dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
//                                              dmpl__BranchId__c = branch.Id,
//                                              dmpl__DocumentDate__c = Date.today(),
//                                              dmpl__Status__c = 'Draft',
//                                              dmpl__RequiredDate__c = Date.today(),
//                                              //dmpl__SalesExecutiveId__c = resource.Id,
//                                              dmpl__BookingAmount__c = 100,
//                                              dmpl__PromisedDate__c = Date.today(),
//                                              dmpl__PerformReleaseFulfilment__c = false,
//                                              dmpl__PerformReleaseInvoice__c = false,
//                                              dmpl__PerformReleaseDelivery__c = false,
//                                              dmpl__AmountPaid__c = 100
//                                             ));
//         insert saleOrder;
    
//         List<dmpl__SaleOrderLine__c> saleOrderLine = new List<dmpl__SaleOrderLine__c>();
//         dmpl__Item__c item = [Select Id,Name From dmpl__Item__c Where dmpl__ItemType__c='Product' LIMIT 1];
//         dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
//         dmpl__SchemeLine__c schemeLine =[Select Id, Name from dmpl__SchemeLine__c where dmpl__SchemeId__r.dmpl__SchemeType__c='Sales Order Per Period' AND dmpl__RewardApplicability__c = 'All Rewards' Limit 1 ];
//         dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
//         saleOrderLine.Add(new dmpl__SaleOrderLine__c(dmpl__SaleOrderId__c = saleOrder[0].Id,
//                                                      dmpl__ItemId__c = item.Id,
//                                                      dmpl__SKUId__c = sku.Id,
//                                                      dmpl__Quantity__c = 4,
//                                                      dmpl__SchemeLineId__c=schemeLine.Id,
//                                                      dmpl__SchemeDiscount__c=5,
//                                                      dmpl__SchemeDiscountAmount__c = 100,
//                                                      dmpl__TaxGroupId__c = taxGroup.Id
//                                                     ));
//         insert saleOrderLine;
        
//         List<dmpl__SaleOrderLine__c> saleOrderLine1 = new List<dmpl__SaleOrderLine__c>();
//         saleOrderLine1.Add(new dmpl__SaleOrderLine__c(dmpl__SaleOrderId__c = saleOrder[0].Id,
//                                                       dmpl__ItemId__c = item.Id,
//                                                       dmpl__SKUId__c = sku.Id,
//                                                       dmpl__Quantity__c = 4,
//                                                       dmpl__SchemeLineId__c=schemeLine.Id,
//                                                       dmpl__SchemeDiscount__c=10.00,
//                                                       dmpl__SchemeDiscountAmount__c = 50,
//                                                       dmpl__TaxGroupId__c = taxGroup.Id
//                                                      ));
//         insert saleOrderLine1;
//     }
}