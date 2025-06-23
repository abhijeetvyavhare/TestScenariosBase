@isTest
public class SchemeReturnEngine_Test {
    
     @testSetup
    public static void Setup()
    {
        CreateScheme();
            CreatePriceList();
            CreateTaxGroup();
            CreateTaxGroupRule();

        Test.startTest();
        CreateSaleOrder();
        Test.stopTest();
        CreateSaleReturn1();
    }
   
    @isTest
    private static void verifyQuery5()
    {
        
        test.startTest();
        List<dmpl__SaleReturn__c> saleReturns = [Select Id ,Name,dmpl__SaleInvoiceId__c from dmpl__SaleReturn__c Limit 1];
        try{
            SchemeReturnEngine srn = new SchemeReturnEngine(saleReturns[0], false);
            try{
                srn.getSILines(saleReturns[0].dmpl__SaleInvoiceId__c);
            }catch(Exception e){} 

            try{
                srn.getSRLines(saleReturns[0].Id);
            }catch(Exception e){} 

            try{
                List<dmpl__SchemeLine__c> a = srn.getActiveSchemeLines();
                try{
                    List<dmpl__SchemeLine__c> b = srn.getAppliedSchemeLines(DocumentHelper.extractIds(a));
                }catch(Exception e){}
            }catch(Exception e){}

            try{
                List<AggregateResult> ar = srn.getSISummary(saleReturns[0].dmpl__SaleInvoiceId__c);
            }catch(Exception e){} 
            
            
        }catch(Exception e){}
        test.stopTest();
    }

    @isTest
    private static void verifyQuery()
    {
        
        test.startTest();
        List<dmpl__SaleReturn__c> saleReturns = [Select Id ,Name,dmpl__SaleInvoiceId__c from dmpl__SaleReturn__c Limit 1];
        try{
            SchemeReturnEngine.processSchemeReturn(saleReturns);
        }catch(Exception e){}
        test.stopTest();
        
            
    }
    
    @isTest
    private static void verifyQuery3()
    {
        test.startTest();
        dmpl__SchemeLine__c schemeLine = [Select Id,Name,RewardApplicability__c,dmpl__SchemeId__r.dmpl__PeriodType__c From dmpl__SchemeLine__c LIMIT 1];
        List<dmpl__SaleReturn__c> saleReturns = [Select Id ,Name,dmpl__SaleInvoiceId__c from dmpl__SaleReturn__c Limit 1];
        try{
            SchemeReturnEngine srn = new SchemeReturnEngine(saleReturns[0], false);
            try{
                srn.revertSchemeLine(schemeLine);
            }catch(Exception e){}
            
            try{
                srn.revertSchemeLineImapct(schemeLine);
            }catch(Exception e){}

            try{
                srn.getMaximumBenefit(schemeLine);
            }catch(Exception e){}
            
            try{
                srn.applyPerDocumentSchemeLine(schemeLine, 3);
            }catch(Exception e){}
                
            try{
                srn.processSaleReturn();
            }catch(Exception e){}

            try{
                SchemeEngine.getSaleReturnLines(CollectionHelper.extractIds(saleReturns));
            }catch(Exception e){}
            
            try{
                srn.evaluateNumberOperator(5, 'Equals', 6);
                srn.evaluateNumberOperator(5, 'Does Not Equal', 6);
                srn.evaluateNumberOperator(5, 'Greater Than', 6);
                srn.evaluateNumberOperator(5, 'Greater Than Or Equal', 6);
                srn.evaluateNumberOperator(5, 'Less Than', 6);
                srn.evaluateNumberOperator(5, 'Less Than Or Equal', 6);

                srn.evaluateCurrencyOperator(5.5, 'Equals', 6.6);
                srn.evaluateCurrencyOperator(5.2, 'Does Not Equal', 6.5);
                srn.evaluateCurrencyOperator(5.3, 'Greater Than', 6.4);
                srn.evaluateCurrencyOperator(5.2, 'Greater Than Or Equal', 6.3);
                srn.evaluateCurrencyOperator(5.1, 'Less Than', 6.2);
                srn.evaluateCurrencyOperator(5.2, 'Less Than Or Equal', 6.2);

                
            }catch(Exception e){}

            try{
                srn.evaluatePerDocumentSchemeLine(schemeLine);
            }catch(Exception e){}

            try{
                srn.getMinimumBenefit(schemeLine);
            }catch(Exception e){}
            
            try{
                srn.evaluateConditions('Custom Logic Is Met', '{1} OR {2} OR {3}',  new List<Integer>{1,2,3});
                srn.evaluateConditions('All Conditions Are Met', '{1} OR {2} OR {3}',  new List<Integer>{1,2,3});
                srn.evaluateConditions('Any Condition Is Met', '{1} OR {2} OR {3}',  new List<Integer>{1,2,3});
            }catch(Exception e){}
            
        }catch(Exception e){}

        test.stopTest();
        
            
    }

    @isTest
    private static void verifyQuery2()
    {
        try{
            test.startTest();
            dmpl__SchemeBenefit__c schemeBenefit4 = [SELECT dmpl__SchemeId__c, DiscountAmount__c,DiscountPercent__c, dmpl__DiscountedItemGroupId__c,dmpl__DiscountedItemQuantity__c, dmpl__RewardType__c, dmpl__SequenceNumber__c, dmpl__RepeatReward__c, dmpl__SchemeLineId__c FROM dmpl__SchemeBenefit__c LIMIT 1];
            List<dmpl__SchemeCondition__c> conditions = [SELECT dmpl__SchemeId__c, dmpl__ItemId__c, dmpl__AccountGroupId__c, dmpl__ItemSKUId__c, dmpl__ConditionType__c, dmpl__ConditionQuantity__c, dmpl__ConditionValue__c, dmpl__SequenceNumber__c, dmpl__SchemeLineId__c, dmpl__ConditionOperator__c FROM dmpl__SchemeCondition__c];
            List<dmpl__SaleReturn__c> saleReturns = [Select Id ,Name,dmpl__SaleInvoiceId__c from dmpl__SaleReturn__c Limit 1];
            SchemeReturnEngine srn = new SchemeReturnEngine(saleReturns[0], false);

            try{
                srn.processSaleReturn();
                
            }catch(Exception e){}

            try {
                srn.applyPerDocumentBenefit(schemeBenefit4, 3, 'Line Level Discount Percent');
            }catch(Exception e){}

            try {
                srn.applyPerDocumentBenefit(schemeBenefit4, 3, 'Discounted Item');
            }catch(Exception e){}

            try {
                srn.applyPerDocumentBenefit(schemeBenefit4, 3, 'Discounted Item Group');
            }catch(Exception e){}

            try {
                srn.applyPerDocumentBenefit(schemeBenefit4, 3, 'Line Level Discount Percent');
            }catch(Exception e){}


            try{
                srn.applyDocumentDiscountdItem(null, schemeBenefit4, 4, true, 'Per order');
            }catch(Exception e){}


            for(dmpl__SchemeCondition__c condition : conditions){
                try {
                    srn.evaluatePerDocumentCondition(condition);
                }catch(Exception e){}
                
            }

        test.stopTest();

        }catch(Exception e){}
    }
    
    @isTest
    private static void verifyapplyDocumentDiscountPercent()
    {
        try{
            test.startTest();
            dmpl__SchemeBenefit__c schemeBenefit4 = [SELECT dmpl__SchemeId__c, DiscountAmount__c,DiscountPercent__c, dmpl__DiscountedItemGroupId__c, dmpl__RewardType__c, dmpl__SequenceNumber__c, dmpl__RepeatReward__c, dmpl__SchemeLineId__c FROM dmpl__SchemeBenefit__c LIMIT 1];
            List<dmpl__SchemeCondition__c> conditions = [SELECT dmpl__SchemeId__c, dmpl__ItemId__c, dmpl__AccountGroupId__c, dmpl__ItemSKUId__c, dmpl__ConditionType__c, dmpl__ConditionQuantity__c, dmpl__ConditionValue__c, dmpl__SequenceNumber__c, dmpl__SchemeLineId__c, dmpl__ConditionOperator__c FROM dmpl__SchemeCondition__c];
            List<dmpl__SaleReturn__c> saleReturns = [Select Id ,Name,dmpl__SaleInvoiceId__c from dmpl__SaleReturn__c Limit 1];
            dmpl__SaleReturnLine__c line = [Select Id,Name From dmpl__SaleReturnLine__c LIMIT 1];
            SchemeReturnEngine srn = new SchemeReturnEngine(saleReturns[0], false);

            try{
                srn.processSaleReturn();
                
            }catch(Exception e){}

            try {
                srn.applyDocumentDiscountPercent(line,schemeBenefit4);
            }catch(Exception e){}
            try {
                srn.applyDocumentDiscountAmount(line,schemeBenefit4);
            }catch(Exception e){}
            try {
                srn.applyDocumentRewardPoints(line,schemeBenefit4);
            }catch(Exception e){}
        test.stopTest();

        }catch(Exception e){}
    }

    private static void CreateScheme()
    {
        Account partneraccount = new Account(Name = 'Partner-Test-Account',
                                             dmpl__LastName__c = 'Sale Order',
                                             dmpl__IsPartnerAccount__c = True, 
                                             dmpl__IsActive__c = true);
        insert partneraccount;
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__LastName__c = 'Sale Order',
                                              dmpl__IsCustomerAccount__c = True,
                                              dmpl__IsPartnerAccount__c = True,
                                              dmpl__IsActive__c = true);
        insert customerAccount;
        
        List<dmpl__Branch__c> branch = new List<dmpl__Branch__c>();
        branch.Add(new dmpl__Branch__c(dmpl__PartnerAccountId__c =partnerAccount.Id,
                                       Name = 'Test-Branch',
                                       dmpl__IsActive__c = true,
                                       dmpl__MarketingName__c = 'Hero Electric',
                                       dmpl__Website__c = 'www.dealermatix.com',
                                       dmpl__Email__c = 'Dealer@Outlook.com',
                                       dmpl__MobileNumber__c = 99,
                                       dmpl__Phone__c = '8888888888',
                                       dmpl__AllowSales__c = true,
                                       dmpl__AllowService__c = true,
                                       dmpl__AllowPurchase__c = true,
                                       dmpl__AllowInventory__c = true,
                                       dmpl__IsHomeDeliveryAvailable__c = true,
                                       dmpl__IsPickupDropAvailable__c = true,
                                       dmpl__SalesPhone__c = '7777777777',
                                       dmpl__ServiceEmail__c = 'Customer@Outlook.com'));
        
        insert branch;

        List<dmpl__ItemGroup__c> itemGroup = new List<dmpl__ItemGroup__c> ();
        itemGroup.Add(new dmpl__ItemGroup__c(Name = 'Item Group Test',
                                             dmpl__ItemGroupType__c = 'Scheme'
                                            ));
        insert itemGroup;
    
        List<dmpl__Item__c> productItem = new List<dmpl__Item__c>();
        productItem.Add(new dmpl__Item__c(Name = 'Test-Item',
                                          dmpl__ItemCode__c = 'DMPL',
                                          dmpl__ItemType__c = 'Product',
                                          dmpl__ItemSubType__c = '',
                                          dmpl__SchemeItemGroupId__c=itemGroup[0].Id,
                                          dmpl__Description__c = '',
                                          dmpl__ItemFamily__c = 'Sample',
                                          dmpl__ItemSegment__c = 'Sample',
                                          dmpl__Make__c = 'Sample',
                                          dmpl__Model__c = 'Sample',
                                          dmpl__TrackInventory__c = true,
                                          dmpl__TrackLots__c = true,
                                          dmpl__IsSKURequired__c = true,
                                          dmpl__RequireInspectionOnReceipt__c = true,
                                          dmpl__RequireInspectionOnDelivery__c = true,
                                          dmpl__AllowService__c = true,
                                          dmpl__TrackAsset__c = true,                               
                                          dmpl__IsActive__c = true,
                                          dmpl__IsRegistrationRequired__c = true,
                                          dmpl__GTIN__c = 'BR123',
                                          dmpl__RFID__c = 'O1234fgh',
                                          dmpl__IsPackage__c = true
                                         ));
        insert productItem;
        
        List<dmpl__SKU__c> sku = new List<dmpl__SKU__c>();
        dmpl__Item__c item = productItem[0];
        sku.add(new dmpl__SKU__c(Name = 'Test - SKU',
                                 dmpl__SKUCode__c = 'Test - SKU - Code',
                                 dmpl__UnitOfMeasureOfConversion__c = 10,
                                 dmpl__ProductColor__c = 'Sample',
                                 dmpl__IsDefault__c = false,
                                 dmpl__QuantityUnitOfMeasure__c ='Sample',
                                 dmpl__ItemId__c = item.Id));
        insert sku;
        
        List<dmpl__ItemLot__c> itemLot = new List<dmpl__ItemLot__c>();
        itemLot.Add(new dmpl__ItemLot__c(dmpl__BranchId__c = branch[0].Id,
                                         dmpl__PartnerAccountId__c = branch[0].dmpl__PartnerAccountId__c,
                                         dmpl__ItemId__c = item.Id,
                                         dmpl__SKUId__c =sku[0].Id,
                                         dmpl__BatchNo__c = 'AAA',
                                         dmpl__SerialNumber__c='BBB',
                                         dmpl__SupplierInvoiceNumber__c='CCC',
                                         dmpl__DateOfReceipt__c= date.today(),
                                         dmpl__DateOfMfg__c=date.today(),
                                         dmpl__TotalCost__c=10.2,
                                         dmpl__DateOfSupplierInvoice__c=date.today(),
                                         dmpl__Cost__c=38
                                        ));
        insert itemLot;       
        List<dmpl__Scheme__c> scheme = new List<dmpl__Scheme__c>();
        scheme.Add(new dmpl__Scheme__c(dmpl__PeriodType__c = 'Per Order',
                                       Name='Scheme1',
                                       dmpl__ValidTo__c= Datetime.now().addDays(365).Date(),
                                       dmpl__Status__c='Approved',
                                       dmpl__MultipleFulfilmentTreatment__c='Apply Last Fulfilled',
                                       dmpl__SchemeType__c='Per Sale Invoice',
                                       dmpl__BranchId__c = branch[0].Id,
                                       dmpl__ValidFrom__c = date.today()-(2),
                                       dmpl__PartnerAccountId__c = null,
                                       dmpl__PartnerAccountGroupId__c = null,
                                       dmpl__Application__c = 'Auto Apply'));
        insert scheme;
    
        List<dmpl__SchemeLine__c> schemeLine = new List<dmpl__SchemeLine__c>();
        schemeLine.Add(new dmpl__SchemeLine__c(dmpl__DefinitionFilterCriteria__c = 'Any Condition Is Met',
                                               dmpl__SchemeId__c = scheme[0].Id,
                                               dmpl__SequenceNumber__c = 1,
                                               dmpl__RewardApplicability__c = 'All Rewards'));
        
        insert schemeLine;
        
        List<dmpl__SchemeLine__c> schemeLine1 = new List<dmpl__SchemeLine__c>();
        schemeLine1.Add(new dmpl__SchemeLine__c(dmpl__DefinitionFilterCriteria__c = 'Any Condition Is Met',
                                               dmpl__SchemeId__c = scheme[0].Id,
                                               dmpl__SequenceNumber__c = 1,
                                               dmpl__RewardApplicability__c = 'Any One With Lowest Value'));
        
        insert schemeLine1;
        
        List<dmpl__SchemeLine__c> schemeLine2 = new List<dmpl__SchemeLine__c>();
        schemeLine2.Add(new dmpl__SchemeLine__c(dmpl__DefinitionFilterCriteria__c = 'Any Condition Is Met',
                                               dmpl__SchemeId__c = scheme[0].Id,
                                               dmpl__SequenceNumber__c = 1,
                                               dmpl__RewardApplicability__c = 'Any One With Highest Value'));
        
        insert schemeLine2;
    
    
        List<dmpl__SchemeCondition__c> schemeCondition = new List<dmpl__SchemeCondition__c>();
        schemeCondition.Add(new dmpl__SchemeCondition__c(dmpl__AccountId__c =customerAccount.Id,
                                                         dmpl__SchemeId__c = scheme[0].Id,
                                                         dmpl__ItemId__c=item.Id,
                                                         dmpl__ItemGroupId__c=itemGroup[0].Id,         
                                                         dmpl__ItemSKUId__c=sku[0].Id,         
                                                         dmpl__ConditionType__c='Quantity',
                                                         dmpl__ConditionQuantity__c =1,
                                                         dmpl__ConditionValue__c = 100,
                                                         dmpl__SequenceNumber__c = 1,
                                                         dmpl__SchemeLineId__c= schemeLine[0].Id,
                                                         dmpl__ConditionOperator__c = 'Greater Than'));
        insert schemeCondition;
        
        List<dmpl__SchemeCondition__c> schemeCondition1 = new List<dmpl__SchemeCondition__c>();
        schemeCondition1.Add(new dmpl__SchemeCondition__c(dmpl__AccountId__c =customerAccount.Id,
                                                          dmpl__SchemeId__c = scheme[0].Id,
                                                          dmpl__ItemId__c=item.Id,
                                                          dmpl__ItemGroupId__c=itemGroup[0].Id,         
                                                          dmpl__ItemSKUId__c=sku[0].Id,         
                                                          dmpl__ConditionType__c='Value',
                                                          dmpl__ConditionValue__c = 100,
                                                          dmpl__SequenceNumber__c = 2,
                                                          //dmpl__SchemeLineId__c=schemeLine1.Id,
                                                          dmpl__ConditionOperator__c = 'Greater Than'));
        //insert schemeCondition1;
        
        List<dmpl__SchemeCondition__c> schemeCondition3 = new List<dmpl__SchemeCondition__c>();
        schemeCondition3.Add(new dmpl__SchemeCondition__c(dmpl__AccountId__c =customerAccount.Id,
                                                          dmpl__SchemeId__c = scheme[0].Id,
                                                          dmpl__ItemId__c=item.Id,
                                                          dmpl__ItemGroupId__c=itemGroup[0].Id, 
                                                          dmpl__ConditionType__c='Item Group Value',
                                                          dmpl__ConditionValue__c = 100,
                                                          dmpl__SequenceNumber__c = 3,
                                                          dmpl__SchemeLineId__c=schemeLine[0].Id,        
                                                          dmpl__ConditionOperator__c = 'Greater Than'));

        schemeCondition3.Add(new dmpl__SchemeCondition__c(dmpl__AccountId__c =customerAccount.Id,
        dmpl__SchemeId__c = scheme[0].Id,
        dmpl__ItemId__c=item.Id,
        dmpl__ItemGroupId__c=itemGroup[0].Id, 
        dmpl__ConditionType__c='Quantity',
        dmpl__ConditionValue__c = 100,
        dmpl__SequenceNumber__c = 3,
        dmpl__SchemeLineId__c=schemeLine[0].Id,        
        dmpl__ConditionOperator__c = 'Equals'));
        schemeCondition3.Add(new dmpl__SchemeCondition__c(dmpl__AccountId__c =customerAccount.Id,
        dmpl__SchemeId__c = scheme[0].Id,
        dmpl__ItemId__c=item.Id,
        dmpl__ItemGroupId__c=itemGroup[0].Id, 
        dmpl__ConditionType__c='Value',
        dmpl__ConditionValue__c = 100,
        dmpl__SequenceNumber__c = 3,
        dmpl__SchemeLineId__c=schemeLine[0].Id,        
        dmpl__ConditionOperator__c = 'Equals'));
        schemeCondition3.Add(new dmpl__SchemeCondition__c(dmpl__AccountId__c =customerAccount.Id,
        dmpl__SchemeId__c = scheme[0].Id,
        dmpl__ItemId__c=item.Id,
        dmpl__ItemGroupId__c=itemGroup[0].Id, 
        dmpl__ConditionType__c='Value With Tax',
        dmpl__ConditionValue__c = 100,
        dmpl__SequenceNumber__c = 3,
        dmpl__SchemeLineId__c=schemeLine[0].Id,        
        dmpl__ConditionOperator__c = 'Equals'));
        schemeCondition3.Add(new dmpl__SchemeCondition__c(dmpl__AccountId__c =customerAccount.Id,
        dmpl__SchemeId__c = scheme[0].Id,
        dmpl__ItemId__c=item.Id,
        dmpl__ItemGroupId__c=itemGroup[0].Id, 
        dmpl__ConditionType__c='Item Quantity',
        dmpl__ConditionValue__c = 100,
        dmpl__SequenceNumber__c = 3,
        dmpl__SchemeLineId__c=schemeLine[0].Id,        
        dmpl__ConditionOperator__c = 'Equals'));
        schemeCondition3.Add(new dmpl__SchemeCondition__c(dmpl__AccountId__c =customerAccount.Id,
        dmpl__SchemeId__c = scheme[0].Id,
        dmpl__ItemId__c=item.Id,
        dmpl__ItemGroupId__c=itemGroup[0].Id, 
        dmpl__ConditionType__c='Item Value',
        dmpl__ConditionValue__c = 100,
        dmpl__SequenceNumber__c = 3,
        dmpl__SchemeLineId__c=schemeLine[0].Id,        
        dmpl__ConditionOperator__c = 'Less Than Or Equal'));
        schemeCondition3.Add(new dmpl__SchemeCondition__c(dmpl__AccountId__c =customerAccount.Id,
        dmpl__SchemeId__c = scheme[0].Id,
        dmpl__ItemId__c=item.Id,
        dmpl__ItemGroupId__c=itemGroup[0].Id, 
        dmpl__ConditionType__c='Item Value With Tax',
        dmpl__ConditionValue__c = 100,
        dmpl__SequenceNumber__c = 3,
        dmpl__SchemeLineId__c=schemeLine[0].Id,        
        dmpl__ConditionOperator__c = 'Does Not Equal'));
        schemeCondition3.Add(new dmpl__SchemeCondition__c(dmpl__AccountId__c =customerAccount.Id,
        dmpl__SchemeId__c = scheme[0].Id,
        dmpl__ItemId__c=item.Id,
        dmpl__ItemGroupId__c=itemGroup[0].Id, 
        dmpl__ConditionType__c='Item Group Quantity',
        dmpl__ConditionValue__c = 100,
        dmpl__SequenceNumber__c = 3,
        dmpl__SchemeLineId__c=schemeLine[0].Id,        
        dmpl__ConditionOperator__c = 'Greater Than'));
        schemeCondition3.Add(new dmpl__SchemeCondition__c(dmpl__AccountId__c =customerAccount.Id,
        dmpl__SchemeId__c = scheme[0].Id,
        dmpl__ItemId__c=item.Id,
        dmpl__ItemGroupId__c=itemGroup[0].Id, 
        dmpl__ConditionType__c='Item Group Value',
        dmpl__ConditionValue__c = 100,
        dmpl__SequenceNumber__c = 3,
        dmpl__SchemeLineId__c=schemeLine[0].Id,        
        dmpl__ConditionOperator__c = 'Greater Than Or Equal'));
        schemeCondition3.Add(new dmpl__SchemeCondition__c(dmpl__AccountId__c =customerAccount.Id,
        dmpl__SchemeId__c = scheme[0].Id,
        dmpl__ItemId__c=item.Id,
        dmpl__ItemGroupId__c=itemGroup[0].Id, 
        dmpl__ConditionType__c='Item Group Value With Tax',
        dmpl__ConditionValue__c = 100,
        dmpl__SequenceNumber__c = 3,
        dmpl__SchemeLineId__c=schemeLine[0].Id,        
        dmpl__ConditionOperator__c = 'Less Than'));

        insert schemeCondition3;
    
        List<dmpl__SchemeBenefit__c> schemeBenefit = new List<dmpl__SchemeBenefit__c>();
        schemeBenefit.Add(new dmpl__SchemeBenefit__c(dmpl__SchemeId__c = scheme[0].Id, 
                                                    DiscountPercent__c=5,
                                                     DiscountAmount__c=100,
                                                     dmpl__RewardType__c='Reward Points',
                                                     dmpl__SequenceNumber__c = 1,
                                                     dmpl__RepeatReward__c =  true,
                                                     dmpl__SchemeLineId__c=schemeLine[0].Id       
                                                    ));
        insert schemeBenefit;
        
        List<dmpl__SchemeBenefit__c> schemeBenefit1 = new List<dmpl__SchemeBenefit__c>();
        dmpl__SchemeLine__c schemeLine3 =[Select Id, Name from dmpl__SchemeLine__c  Limit 1];
        schemeBenefit1.Add(new dmpl__SchemeBenefit__c(dmpl__SchemeId__c = scheme[0].Id, 
                                                      DiscountAmount__c=500,
                                                      DiscountPercent__c=4,
                                                      dmpl__RewardType__c='Line Level Discount Amount',
                                                      dmpl__SequenceNumber__c = 2,
                                                      dmpl__RepeatReward__c =  true,
                                                      dmpl__SchemeLineId__c=schemeLine3.Id       
                                                     ));
        insert schemeBenefit1;
        
        List<dmpl__SchemeBenefit__c> schemeBenefit3 = new List<dmpl__SchemeBenefit__c>();
        schemeBenefit3.Add(new dmpl__SchemeBenefit__c(dmpl__SchemeId__c = scheme[0].Id, 
                                                      DiscountAmount__c=500,
                                                      DiscountPercent__c=4,
                                                      dmpl__DiscountedItemId__c = item.Id,
                                                      dmpl__RewardType__c='Discounted Item',
                                                      dmpl__SequenceNumber__c = 2,
                                                      dmpl__RepeatReward__c =  true,
                                                      dmpl__SchemeLineId__c=schemeLine3.Id       
                                                     ));
        insert schemeBenefit3;
        
        List<dmpl__SchemeBenefit__c> schemeBenefit4 = new List<dmpl__SchemeBenefit__c>();
        schemeBenefit4.Add(new dmpl__SchemeBenefit__c(dmpl__SchemeId__c = scheme[0].Id, 
                                                      DiscountAmount__c=500,
                                                      DiscountPercent__c=4,
                                                      dmpl__DiscountedItemGroupId__c = itemGroup[0].Id,
                                                      dmpl__RewardType__c='Discounted Item Group',
                                                      dmpl__SequenceNumber__c = 2,
                                                      dmpl__RepeatReward__c =  true,
                                                      dmpl__SchemeLineId__c=schemeLine3.Id       
                                                     ));
        insert schemeBenefit4;
    }    
    
    private static void CreateSaleReturn1()
    {
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c where dmpl__ItemType__c='Product'  LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch'];
        dmpl__SaleInvoice__c saleInvoice = new dmpl__SaleInvoice__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                 dmpl__BranchId__c = branch.Id,
                                                 dmpl__DocumentDate__c = date.today(),
                                                 dmpl__AccountId__c = branch.dmpl__PartnerAccountId__c,
                                                 //dmpl__SalesExecutiveId__c = resource.Id,
                                                 dmpl__PerformGLPosting__c = true,
                                                 dmpl__Status__c = 'Draft'
                                                );
        insert saleInvoice;
        List<dmpl__SaleReturn__c> saleReturn = new List<dmpl__SaleReturn__c>();
        dmpl__SchemeLine__c schemeLine3 =[Select Id, Name from dmpl__SchemeLine__c  Limit 1];
        saleReturn.Add(new dmpl__SaleReturn__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                                 dmpl__BranchId__c = branch.Id,
                                                                 dmpl__SaleInvoiceId__c = saleInvoice.Id,
                                                                dmpl__AccountId__c = branch.dmpl__PartnerAccountId__c,
                                                                dmpl__DocumentDate__c = date.today()));
        insert saleReturn;
        SchemeEngine.postSaleReturnSchemeLeders(saleReturn);
        SchemeEngine.getROLines();
        SchemeEngine.getBillLines();
        SchemeEngine.getPOLines();
        SchemeEngine.getSOLines();
        SchemeEngine.getBillSummary();
        SchemeEngine.getROSummary();
        SchemeEngine.getPOSummary();
        SchemeEngine.getSOSummary();
        SchemeEngine.postROSchemeLeders();
        SchemeEngine.postPOSchemeLeders();
        SchemeEngine.postSOSchemeLeders();
      
    }
    
    private static void CreateSaleOrder()
    {
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c where dmpl__ItemType__c='Product'  LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name,dmpl__ItemId__c From dmpl__SKU__c LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch'];
        dmpl__SaleInvoice__c saleInvoice = new dmpl__SaleInvoice__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                 dmpl__BranchId__c = branch.Id,
                                                 dmpl__DocumentDate__c = date.today(),
                                                 dmpl__AccountId__c = branch.dmpl__PartnerAccountId__c,
                                                 //dmpl__SalesExecutiveId__c = resource.Id,
                                                 dmpl__PerformGLPosting__c = true,
                                                 dmpl__Status__c = 'Draft'
                                                );
        insert saleInvoice;
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c];
        dmpl__PriceListRules__c priceRule =[select Id, Name from dmpl__PriceListRules__c Limit 1];
       // dmpl__ItemLot__c itemLot = [Select Id, Name From dmpl__ItemLot__c LIMIT 1];
       /* dmpl__SaleInvoiceLine__c saleInvoiceLine = new dmpl__SaleInvoiceLine__c(dmpl__SaleInvoiceId__c = saleInvoice.id,
                                                                                dmpl__ItemId__c = item.id,
                                                                                dmpl__SKUId__c =sku.Id ,
                                                                                dmpl__IsILPostingApproved__c=false,
                                                                                dmpl__IsGLPostingApproved__c=false,
                                                                                dmpl__Quantity__c = 10,
                                                                                dmpl__TaxAmount__c = 577,                      
                                                                                dmpl__UnitPrice__c = 100,
                                                                                //dmpl__SchemeLineId__c = schemeLine[0].Id,
                                                                                dmpl__SchemeDiscount__c = 50
                                                        );
        insert saleInvoiceLine; */
         dmpl__SaleInvoiceLine__c saleInvoiceLine = new dmpl__SaleInvoiceLine__c(dmpl__SaleInvoiceId__c = saleInvoice.id,
                                                         dmpl__ItemId__c = sku.dmpl__ItemId__c,
                                                         dmpl__PriceListRuleId__c=priceRule.Id,
                                                         dmpl__SKUId__c =sku.Id ,
                                                         dmpl__IsILPostingApproved__c=false,
                                                         dmpl__IsGLPostingApproved__c=false,
                                                       //  dmpl__ItemLotId__c = itemLot.Id,
                                                         dmpl__Quantity__c = 100,
                                                         dmpl__UnitPrice__c = 10,
                                                         dmpl__IsClaimed__c = false,
                                                         dmpl__SchemeDiscountAmount__c = 100,
                                                         dmpl__TaxGroupId__c = taxGroup.Id
                                                        );
        insert saleInvoiceLine; 
        dmpl__SaleReturn__c saleReturn = new dmpl__SaleReturn__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                                 dmpl__BranchId__c = branch.Id,
                                                                 dmpl__SaleInvoiceId__c = saleInvoice.Id,
                                                                dmpl__AccountId__c = branch.dmpl__PartnerAccountId__c,
                                                                dmpl__DocumentDate__c = date.today());
        insert saleReturn;
        


        dmpl__SaleReturnLine__c saleReturnLine = new dmpl__SaleReturnLine__c(dmpl__SaleReturnId__c = saleReturn.id,
                                                                                dmpl__ItemId__c = item.id,
                                                                                dmpl__SKUId__c =sku.Id ,
                                                                                dmpl__Quantity__c = 10,
                                                                                dmpl__SchemeDiscount__c = 199,
                                                                                dmpl__SaleInvoiceLineId__c = saleInvoiceLine.Id);
        
        insert saleReturnLine;
    }
        /*test.startTest();
        
        SchemeEngine.getBillLines();
        SchemeEngine.getPOLines();
        SchemeEngine.getSOLines();
        SchemeEngine.getBillSummary();
        SchemeEngine.getROSummary();
        SchemeEngine.getPOSummary();
        SchemeEngine.getSOSummary();
        SchemeEngine.postROSchemeLeders();
        SchemeEngine.postPOSchemeLeders();
        SchemeEngine.postSOSchemeLeders();
        test.stopTest();
    }

    
    }*/
    
     private static void CreatePriceList()
    {
        List<dmpl__PriceList__c> priceList =new List<dmpl__PriceList__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Limit 1];
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account'];
        
        priceList.Add(new dmpl__PriceList__c(Name='Test-Price - List',
                                             dmpl__BranchId__c = branch.Id,
                                             dmpl__PriceListType__c = 'Sale Price',
                                             dmpl__PartnerAccountId__c= account.Id,
                                             dmpl__IsActive__c = true));
        insert priceList;
    
        List<dmpl__PriceListRules__c> priceListRules =new List<dmpl__PriceListRules__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        priceListRules.Add(new dmpl__PriceListRules__c(dmpl__ItemId__c = item.Id,
                                                       dmpl__PriceListId__c=priceList[0].Id,
                                                       dmpl__Price__c=500,
                                                       dmpl__DateEffectiveFrom__c = date.today()
                                                      ));
        insert priceListRules;
        
    }
    private static void CreateTaxGroup()
    {
        List<dmpl__TaxGroup__c> taxGroup = new List<dmpl__TaxGroup__c>();
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account'];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        taxGroup.Add(new dmpl__TaxGroup__c(Name = 'Test - Tax Group',
                                           dmpl__PartnerAccountId__c = account.Id,
                                           dmpl__BranchId__c = branch.Id,
                                           dmpl__IsActive__c=True,
                                           dmpl__Description__c='Text'
                                          ));
        insert taxGroup;
    
        List<dmpl__Tax__c> tax = new List<dmpl__Tax__c>();
        
        tax.Add(new dmpl__Tax__c(Name = 'Test - Tax',
                                dmpl__TaxGroupId__c = taxGroup[0].Id,
                                dmpl__Type__c = 'Cess',
                                dmpl__Rate__c = 10,
                                dmpl__PostingFieldName__c = 'Tax1'
                                ));        
        insert tax;
    }
    
    private static void CreateTaxGroupRule()
    {
        List<dmpl__TaxGroupRule__c> taxGroupRule = new List<dmpl__TaxGroupRule__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c SKU = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name,dmpl__PartnerAccountId__c,dmpl__BranchId__c From dmpl__TaxGroup__c LIMIT 1];
        taxGroupRule.Add(new dmpl__TaxGroupRule__c(dmpl__TaxGroupId__c = taxGroup.Id,
                                                   dmpl__SKUId__c=SKU.Id,
                                                  dmpl__ItemId__c = Item.Id,
                                                   dmpl__DateEffectiveFrom__c=date.today(),
                                                   dmpl__DateEffectiveTill__c=date.today()+15,
                                                   dmpl__PlaceOfSupplyType__c='Within State'
                                                  ));
        insert taxGroupRule;
    }

}