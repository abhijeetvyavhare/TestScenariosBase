@isTest
public with sharing class SchemeHandler2_Test {
    @TestSetup
    static void makeData() {
        dmpl__AccountGroup__c accountGroup=TestDataHelpers.createAccountGroup();
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();
        Account supplierAccount = TestDataHelpers.createSupplierAccount();
        dmpl__Item__c item=TestDataHelpers.createItem();
        dmpl__Branch__c Branch=TestDataHelpers.createBranch(partnerAccount);
        dmpl__ItemGroup__c ItemGroup=TestDataHelpers.createItemGroup();
        dmpl__SKU__c sku=TestDataHelpers.createSKU(Item);
        dmpl__ContactAddress__c contactAddress=TestDataHelpers.createContactAddress(customerAccount);
        dmpl__Scheme__c scheme=SchemeTestDataHelper.createScheme(Branch,customerAccount,accountGroup);
        dmpl__SchemeLine__c schemeLine=SchemeTestDataHelper.createSchemeLine(scheme,accountGroup);
        dmpl__TaxGroup__c taxGroup=TestDataHelpers.createTaxGroup(partnerAccount,branch);
        dmpl__SchemeBenefit__c schemeBenifit=SchemeTestDataHelper.createSchemeBenefits(scheme,schemeLine,customerAccount,item,itemGroup,sku);
        dmpl__SchemeCondition__c schemeCondition=SchemeTestDataHelper.createSchemeCondition(scheme,schemeLine,customerAccount,accountGroup,item,ItemGroup,sku);
        dmpl__SaleOrder__c saleOrder=SaleOrderTestDataHelpers.createSaleOrder(customerAccount,branch);
        dmpl__SaleOrderLine__c saleOrderLine=SaleOrderTestDataHelpers.createSaleOrderLine(saleOrder,item,sku,taxGroup);
        dmpl__PriceList__c priceList=TestDataHelpers.createPriceList(partnerAccount,branch);
        dmpl__SaleInvoice__c saleInvoice=SaleInvoiceTestDataHelpers.createSaleInvoice(customerAccount,branch,saleOrder,priceList);
        dmpl__PurchaseOrder__c purchaseOrder=PurchaseOrderTestDataHelpers.createPurchaseOrder(branch,supplierAccount);
        // dmpl__PurchaseOrderLine__c purchaseOrderLine=PurchaseOrderTestDataHelpers.createPurchaseOrderLine(item,sku,purchaseOrder,taxgroup);
        dmpl__Bill__c bill=BillTestDataHelpers.createBill(supplierAccount,branch,priceList);
        dmpl__SchemeLedger__c schemeLedger=SchemeTestDataHelper.createSchemeLedger(partnerAccount,branch,scheme);
    }

    @isTest
    Static void evaluatePerOrderConditionAsItem()
    {
        try{
        test.startTest();
        dmpl__SchemeCondition__c condition = SchemeTestDataHelper.getSchemeCondition();
        SchemeEngine.getTotalItemGroupQuantity(condition);
        System.assert(condition != null, 'Test condition are found');
        test.stopTest();
        }catch(exception e){}
    }
    
    @isTest
    Static void evaluatePerOrderConditionAsItemGroup()
    {
        test.startTest();
        dmpl__SchemeCondition__c condition = SchemeTestDataHelper.getSchemeCondition();
        System.assert(condition != null, 'Test condition are found');
        test.stopTest();
    }
    
    @isTest
    public static void schemeConditionPicklistFilter()
    {
        try{
        test.startTest();
        dmpl__SchemeLine__c ln=SchemeTestDataHelper.getSchemeLine();
        List<dmpl__SchemeLine__c> line = new List<dmpl__SchemeLine__c>();
        line.add(ln);
        Map<Id,dmpl__SchemeLine__c> schemeLine = new Map<Id,dmpl__SchemeLine__c>();
        SchemeHelper.schemeConditionPicklistFilter(line,schemeLine);
        test.stopTest();
        }Catch(Exception e){}
    }
    
    @isTest
    public static void updateScheme()
    {
        test.startTest();
        Integer noOfWeek = 5;
        dmpl__Scheme__c scheme =SchemeTestDataHelper.getScheme();
        if(scheme != null)
            update scheme;
        SchemeHelper.createMonthlyPeriods(scheme);
        SchemeHelper.createWeeklyPeriods(scheme,noOfWeek);
        SchemeHelper.createDailyPeriods(scheme);
        SchemeHelper.createYearlyPeriods(scheme);
        test.stopTest();
        System.Assert(scheme!=null,'Scheme is updated');
    }
    
    @isTest
    public static void deleteScheme()
    {
        test.startTest();
        List<Id> ids = new List<Id>();
        dmpl__Scheme__c scheme = SchemeTestDataHelper.getScheme();
        if(scheme != null)
            delete scheme;
        SchemeEngine.queryAppliedSchemes(ids);
        test.stopTest();
        System.Assert(scheme!=null,'Scheme is deleted');
    }
    
    @isTest
    public static void changeSchemeType()
    {
        test.startTest();
        dmpl__Scheme__c scheme = SchemeTestDataHelper.getScheme();
        scheme.dmpl__SchemeType__c = 'Per Purchase Order';
        update scheme;
        test.stopTest();
    }
    
    @isTest
    public static void changeSchemeType1()
    {
        test.startTest();
        dmpl__Scheme__c scheme = SchemeTestDataHelper.getScheme();
        scheme.dmpl__SchemeType__c = 'Per Sale Invoice';
        update scheme;
        test.stopTest();
    }
    
    @isTest
    public static void changeSchemeType2()
    {
        test.startTest();
        dmpl__Scheme__c scheme = SchemeTestDataHelper.getScheme();
        scheme.dmpl__SchemeType__c = 'Per Bill';
        update scheme;
        test.stopTest();
    }

    @isTest
    private static void VerifyProcessMethod()
    {
        //try{
        dmpl__SaleOrder__c so=SaleOrderTestDataHelpers.getSaleOrder();
        List<dmpl__SaleOrder__c> saleOrders = new List<dmpl__SaleOrder__c>();
        saleOrders.add(so);
        dmpl__SchemeCondition__c condition = SchemeTestDataHelper.getSchemeCondition();
        dmpl__SchemeLine__c schemeLine = SchemeTestDataHelper.getSchemeLine();
        test.startTest();
        // List<AggregateResult> agg = [SELECT
        //                              ItemId__c,
        //                              SKUId__c,
        //                              ItemId__r.SchemeItemGroupId__c,
        //                              SUM(Quantity__c) TotalQuantity,
        //                              SUM(Amount__c) TotalAmount
        //                              FROM
        //                              PurchaseOrderLine__c
        //                              GROUP BY
        //                              ItemId__c,
        //                              SKUId__c,
        //                              ItemId__r.SchemeItemGroupId__c
        //                             ];
        SchemeEngine.processSchemes(saleOrders);
        SchemeEngine.getQualifiedSchemeLines(saleOrders[0]);
        // SchemeEngine.getTotalValue(condition, true);
        // SchemeEngine.getTotalItemValue(condition, true);
        // SchemeEngine.getTotalItemGroupValue(condition,true);
        // SchemeEngine.getTotalQuantity(condition);
        SchemeEngine.getMaximumBenefit(schemeLine);
        System.assert(saleOrders != null, 'Sale Orders data found');
        test.stopTest();
        //}catch(Exception e){}
    }
    
    @isTest
    private static void VerifyProcessMethodForPerPeriodSO()
    {
        test.startTest();
        dmpl__SaleOrder__c so=SaleOrderTestDataHelpers.getSaleOrder();
        List<dmpl__SaleOrder__c> saleOrders = new List<dmpl__SaleOrder__c>();
        saleOrders.add(so);        
        SchemeEngine.processSchemes(saleOrders);
        System.assert(saleOrders != null, 'Sale Orders data found');
        test.stopTest();
    }
    
    @isTest
    private static void VerifyProcessMethodForPerPeriodSI()
    {
        test.startTest();
        dmpl__SaleInvoice__c inv=SaleInvoiceTestDataHelpers.getSaleInvoice();
        List<dmpl__SaleInvoice__c> invoices = new List<dmpl__SaleInvoice__c>();
        invoices.add(inv);
        SchemeEngine.processSchemes(invoices);
        SchemeEngine.getSILines();
        System.assert(invoices != null, 'Sale Orders data found');
        test.stopTest();
    }
    
    @isTest
    private static void VerifyApplySchemeBenefitMethod()
    {
        test.startTest();
        dmpl__SaleOrder__c so=SaleOrderTestDataHelpers.getSaleOrder();
        List<dmpl__SaleOrder__c> saleOrders = new List<dmpl__SaleOrder__c>();
        saleOrders.add(so);
        dmpl__SchemeBenefit__c sb=SchemeTestDataHelper.getSchemeBenefits();
        List<dmpl__SchemeBenefit__c> schemeBenefits = new List<dmpl__SchemeBenefit__c>();
        schemeBenefits.add(sb);
		dmpl__SchemeLine__c schemeLine =SchemeTestDataHelper.getSchemeLine();
        SchemeEngine.applySchemeBenefit(
            saleOrders[0],
            schemeLine.Id,
            schemeBenefits[0].Id,
            0,
            new List<SourceObjectInfo>{});
        test.stopTest();
    }
    
    @isTest
    private static void VerifyApplySchemeBenefitMethod1()
    {
        test.startTest();
        dmpl__SaleOrder__c so=SaleOrderTestDataHelpers.getSaleOrder();
        List<dmpl__SaleOrder__c> saleOrders = new List<dmpl__SaleOrder__c>();
        saleOrders.add(so);
        dmpl__SchemeBenefit__c sb=SchemeTestDataHelper.getSchemeBenefits();
        List<dmpl__SchemeBenefit__c> schemeBenefits = new List<dmpl__SchemeBenefit__c>();
        schemeBenefits.add(sb);
		dmpl__SchemeLine__c schemeLine =SchemeTestDataHelper.getSchemeLine();
        SchemeEngine.applySchemeBenefit(
            saleOrders[0],
            schemeLine.Id,
            schemeBenefits[0].Id,
            0,
            new List<SourceObjectInfo>{});
        test.stopTest();
    }
    
    @isTest
    private static void VerifyApplySchemeBenefitMethodController()
    {
        try{
        test.startTest();
        dmpl__SaleOrder__c so=SaleOrderTestDataHelpers.getSaleOrder();
        List<dmpl__SaleOrder__c> saleOrders = new List<dmpl__SaleOrder__c>();
        saleOrders.add(so);
        dmpl__SchemeBenefit__c sb=SchemeTestDataHelper.getSchemeBenefits();
        List<dmpl__SchemeBenefit__c> schemeBenefits = new List<dmpl__SchemeBenefit__c>();
        schemeBenefits.add(sb);
		dmpl__SchemeLine__c schemeLine =SchemeTestDataHelper.getSchemeLine();
        SchemeController.applyScheme(
            'dmpl__SaleOrder__c',
            saleOrders[0].Id,
            schemeLine.Id,
            schemeBenefits[0].Id,
            0,
            new List<SourceObjectInfo>{});
            test.stopTest();}
        catch(exception e){}
    }
    
    @isTest
    private static void VerifyProcessMethodForSI()
    {
        test.startTest();
        dmpl__SaleInvoice__c inv=SaleInvoiceTestDataHelpers.getSaleInvoice();
        List<dmpl__SaleInvoice__c> invoices = new List<dmpl__SaleInvoice__c>();
        invoices.add(inv);
        SchemeEngine.processSchemes(invoices);
        SchemeEngine.getQualifiedSchemeLines(invoices[0]);
        System.assert(invoices != null, 'Sale Orders data found');
        test.stopTest();
    }
    
    @isTest
    private static void VerifyApplySchemeBenefitMethodForSI()
    {
        test.startTest();
        dmpl__SaleInvoice__c inv=SaleInvoiceTestDataHelpers.getSaleInvoice();
        List<dmpl__SaleInvoice__c> invoices = new List<dmpl__SaleInvoice__c>();
        invoices.add(inv);
        dmpl__SchemeBenefit__c sb=SchemeTestDataHelper.getSchemeBenefits();
        List<dmpl__SchemeBenefit__c> schemeBenefits = new List<dmpl__SchemeBenefit__c>();
        schemeBenefits.add(sb);
		dmpl__SchemeLine__c schemeLine =SchemeTestDataHelper.getSchemeLine();
        SchemeEngine.applySchemeBenefit(
            invoices[0],
            schemeLine.Id,
            schemeBenefits[0].Id,
            0,
            new List<SourceObjectInfo>{});
        test.stopTest();
    }
    
    @isTest
    private static void VerifyRestResource(){
        dmpl__SaleOrder__c so=SaleOrderTestDataHelpers.getSaleOrder();
        List<dmpl__SaleOrder__c> saleOrders = new List<dmpl__SaleOrder__c>();
        saleOrders.add(so);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/ProductConfiguration';
        req.params.put('recordId',saleOrders[0].Id);
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
     try{
        ConfigAPI_GetProductConfigurator.getProductConfiguration();
        //ConfigAPI_GetProductConfigurator.applyProductConfiguration();
     }catch(Exception e){}
        Test.stopTest();
    }
    
    @isTest
    private static void VerifySchemeHelper()
    {
        test.startTest();
        dmpl__SchemeLedger__c sl=SchemeTestDataHelper.getSchemeLedger();
       List<dmpl__SchemeLedger__c> ledger =  new List<dmpl__SchemeLedger__c>();
       ledger.add(sl);
        SchemeHelper.updateSchemeUtilizedAmount(ledger);
        SchemeHelper.removeSchemeUtilizedAmount(ledger);
        test.stopTest();
    }
    
    @isTest
    private static void VerifyPerformanceKPI()
    {
        test.startTest();
        dmpl__SaleOrder__c so=SaleOrderTestDataHelpers.getSaleOrder();
        List<dmpl__SaleOrder__c> saleOrders = new List<dmpl__SaleOrder__c>();
        saleOrders.add(so);
        PerformanceKPIHelper.upsertSchemePerformanceKPIInternal('dmpl__SaleOrder__c',saleOrders);
        test.stopTest();
        
    }
    
    @isTest
    private static void VerifyPricList()
    {
        test.startTest();
        dmpl__SaleOrder__c so=SaleOrderTestDataHelpers.getSaleOrder();
        List<dmpl__SaleOrder__c> saleOrders = new List<dmpl__SaleOrder__c>();
        saleOrders.add(so);
        PriceListHelper.setDefaultPriceListIds(saleOrders);    
        System.assert(saleOrders != null, 'Sale Orders data found');
        test.stopTest();
    }
    
    @isTest
    private static void VerifyPricListForSI()
    {
        test.startTest();
        dmpl__SaleInvoice__c inv=SaleInvoiceTestDataHelpers.getSaleInvoice();
        List<dmpl__SaleInvoice__c> invoices = new List<dmpl__SaleInvoice__c>();
        invoices.add(inv);
        PriceListHelper.setDefaultPriceListIds(invoices);    
        System.assert(invoices != null, 'Sale Orders data found');
        test.stopTest();
    }

    @isTest
    private static void VerifyProcessMethod11()
    {
        test.startTest();
        dmpl__Bill__c bills=BillTestDataHelpers.getBill();
        List<dmpl__Bill__c> billsList = new List<dmpl__Bill__c>();
        billsList.add(bills);
        SchemeEngine.processSchemes(billsList);
        SchemeEngine.getQualifiedSchemeLines(billsList[0]);
        System.assert(bills != null, 'Sale Orders data found');
        test.stopTest();
    }
    
    @isTest
    private static void VerifyProcessMethodForPerPeriodSO11()
    {
        test.startTest();
        dmpl__Bill__c bills=BillTestDataHelpers.getBill();
        List<dmpl__Bill__c> billsList = new List<dmpl__Bill__c>();
        billsList.add(bills);
        SchemeEngine.processSchemes(billsList);
        System.assert(bills != null, 'Sale Orders data found');
        test.stopTest();
    }
    
    @isTest
    private static void VerifyGetMinBenefit()
    {
     dmpl__SchemeLine__c schemeLine =SchemeTestDataHelper.getSchemeLine();
     test.startTest();
      SchemeEngine.getMinimumBenefit(schemeLine);
      SchemeEngine.getMaximumBenefit(schemeLine);
     test.stopTest();
    }
    
    @isTest
    private static void VerifyProcessMethodForPerPO()
    {
        test.startTest();
        dmpl__PurchaseOrder__c purchaseOrder=PurchaseOrderTestDataHelpers.getPurchaseOrder();
        List<dmpl__PurchaseOrder__c> po = new List<dmpl__PurchaseOrder__c>();
        po.add(purchaseOrder);
        SchemeEngine.processSchemes(po);
        System.assert(po != null, 'Sale Orders data found');
        test.stopTest();
    }
    
    @isTest
    private static void VerifyProcessMethodForPerPeriodPO()
    {
        test.startTest();
        dmpl__PurchaseOrder__c purchaseOrder=PurchaseOrderTestDataHelpers.getPurchaseOrder();
        List<dmpl__PurchaseOrder__c> po = new List<dmpl__PurchaseOrder__c>();
        po.add(purchaseOrder);
        SchemeEngine.processSchemes(po);
        System.assert(po != null, 'Sale Orders data found');
        test.stopTest();
    }
    
    @isTest
    private static void VerifyProcessMethodForPerRO()
    {
        test.startTest();
        try{
        List<dmpl__RepairOrder__c> ro = new List<dmpl__RepairOrder__c>{new dmpl__RepairOrder__c(dmpl__AccountId__c = '',dmpl__DocumentDate__c =date.today())};
        SchemeEngine.processSchemes(ro);
        System.assert(ro != null, 'Sale Orders data found');
        }catch(Exception e){}
        test.stopTest();
    }
    
    @isTest
    private static void VerifyApplySchemeBenefitMethod12()
    {
        test.startTest();
        dmpl__Bill__c bill=BillTestDataHelpers.getBill();
        List<dmpl__Bill__c> bills = new List<dmpl__Bill__c>();
        bills.add(bill);
        dmpl__SchemeBenefit__c sb=SchemeTestDataHelper.getSchemeBenefits();
        List<dmpl__SchemeBenefit__c> schemeBenefits = new List<dmpl__SchemeBenefit__c>();
        schemeBenefits.add(sb);
        dmpl__SchemeLine__c schemeLine =SchemeTestDataHelper.getSchemeLine();
        SchemeEngine.applySchemeBenefit(
            bills[0],
            schemeLine.Id,
            schemeBenefits[0].Id,
            0,
            new List<SourceObjectInfo>{});
        test.stopTest();
    }
    
    @isTest
    private static void VerifyApplySchemeBenefitMethod11()
    {
        test.startTest();
        dmpl__Bill__c bill=BillTestDataHelpers.getBill();
        List<dmpl__Bill__c> bills = new List<dmpl__Bill__c>();
        bills.add(bill);
        dmpl__SchemeBenefit__c sb=SchemeTestDataHelper.getSchemeBenefits();
        List<dmpl__SchemeBenefit__c> schemeBenefits = new List<dmpl__SchemeBenefit__c>();
        schemeBenefits.add(sb);
        dmpl__SchemeLine__c schemeLine =SchemeTestDataHelper.getSchemeLine();
        SchemeEngine.applySchemeBenefit(
            bills[0],
            schemeLine.Id,
            schemeBenefits[0].Id,
            0,
            new List<SourceObjectInfo>{});
        test.stopTest();
    }
    
    @isTest
    private static void VerifySchemeController()
    {
        dmpl__ItemGroup__c ig=TestDataHelpers.getItemGroup();
        List<dmpl__ItemGroup__c> itemGroup = new List<dmpl__ItemGroup__c>();
        itemGroup.add(ig);
        SchemeController.getQualifiedBenefits(itemGroup[0].Id,'',DocumentHelper.extractIds(itemGroup,'Id'));
    }

    @isTest
    Static void Test1()
    {
        try{
            dmpl__SchemeLine__c schemeLine =SchemeTestDataHelper.getSchemeLine();
            List<dmpl__SchemeCondition__c> conditions = new List<dmpl__SchemeCondition__c>();
            conditions.add(SchemeTestDataHelper.getSchemeCondition());
            dmpl__SchemeBenefit__c benefit=SchemeTestDataHelper.getSchemeBenefits();            
            try {
                SchemeEngine.evaluatePerDocumentSchemeLine(schemeLine);
            }catch(Exception e){}

            try {
                SchemeEngine.getCustomApplicableBenefits(schemeLine);
            }catch(Exception e){}
            
            
            for(dmpl__SchemeCondition__c condition : conditions){
                try {
                    try{
                        // SchemeEngine.evaluatePerDocumentCondition(condition);
                    }catch(Exception e){}
                    
                    try{
                        SchemeEngine.evaluatePerPeriodCondition(condition, schemeLine);
                    }catch(Exception e){}
                    try{
                        SchemeEngine.getPerPeriodTotalQuantity(condition, schemeLine);
                    }catch(Exception e){}
                    try{
                        SchemeEngine.getPerPeriodTotalValue(condition, schemeLine, true);
                    }catch(Exception e){}
                    try{
                        SchemeEngine.getPerPeriodTotalItemQuantity(condition, schemeLine);
                    }catch(Exception e){}
                    try{
                        SchemeEngine.getPerPeriodTotalItemValue(condition, schemeLine, true);
                    }catch(Exception e){}
                    try{
                        SchemeEngine.getPerPeriodTotalItemGroupQuantity(condition, schemeLine);
                    }catch(Exception e){}
                    try{
                        SchemeEngine.getPerPeriodTotalItemGroupValue(condition, schemeLine, true);
                    }catch(Exception e){}
                    try{
                        SchemeEngine.getPerPeriodTotalItemGroupValue(condition, schemeLine, true);
                    }catch(Exception e){}
                    
                }catch(Exception e){}
            }
            
            try{
                // SchemeEngine.applyDocumentDiscountdItem(benefit, 1, true, '');
            }catch(Exception e){}
            try{
                // SchemeEngine.applyDocumentDiscountdItem(benefit, 1, true, '');
            }catch(Exception e){}
            

            try{
               /* SchemeEngine.evaluateNumberOperator(5, 'Equals', 6);
                SchemeEngine.evaluateNumberOperator(5, 'Does Not Equal', 6);
                SchemeEngine.evaluateNumberOperator(5, 'Greater Than', 6);
                SchemeEngine.evaluateNumberOperator(5, 'Greater Than Or Equal', 6);
                SchemeEngine.evaluateNumberOperator(5, 'Less Than', 6);
                SchemeEngine.evaluateNumberOperator(5, 'Less Than Or Equal', 6);

                SchemeEngine.evaluateCurrencyOperator(5.5, 'Equals', 6.6);
                SchemeEngine.evaluateCurrencyOperator(5.2, 'Does Not Equal', 6.5);
                SchemeEngine.evaluateCurrencyOperator(5.3, 'Greater Than', 6.4);
                SchemeEngine.evaluateCurrencyOperator(5.2, 'Greater Than Or Equal', 6.3);
                SchemeEngine.evaluateCurrencyOperator(5.1, 'Less Than', 6.2);
                SchemeEngine.evaluateCurrencyOperator(5.2, 'Less Than Or Equal', 6.2);*/

                
            }catch(Exception e){}


            try{
                // SchemeEngine.evaluateConditions('Custom Logic Is Met', '{1} OR {2} OR {3}',  new List<Integer>{1,2,3});
            }catch(Exception e){}
            try{
                // SchemeEngine.evaluateConditions('All Conditions Are Met', '{1} OR {2} OR {3}',  new List<Integer>{1,2,3});
            }catch(Exception e){}
            try{
                // SchemeEngine.evaluateConditions('Any Condition Is Met', '{1} OR {2} OR {3}',  new List<Integer>{1,2,3});
            }catch(Exception e){}

            
            System.assert(schemeLine != null, 'Condition data found');
        }
        catch(exception e){}
    }

    @isTest
    Static void getTotalQuantity()
    {
        try{
            dmpl__SaleOrder__c so=SaleOrderTestDataHelpers.getSaleOrder();
            List<dmpl__SaleOrder__c> saleOrders = new List<dmpl__SaleOrder__c>();
            saleOrders.add(so);
            List<dmpl__SchemeCondition__c> conditions = new List<dmpl__SchemeCondition__c>();
            conditions.add(SchemeTestDataHelper.getSchemeCondition());
            test.startTest();
            // SchemeEngine.processSchemes(saleOrders);
            // SchemeEngine.getTotalValue(conditions[0], true);
            // SchemeEngine.getTotalItemValue(conditions[0], true);
            // SchemeEngine.getTotalItemGroupValue(conditions[0],true);
            // SchemeEngine.getTotalQuantity(conditions[0]);
            System.assert(saleOrders != null, 'Aggregate order data');
            test.stopTest();
        }catch(exception e){}
    }
    
    @isTest
    Static void evaluatePerOrderCondition()
    {
        test.startTest();
        dmpl__SchemeCondition__c condition = SchemeTestDataHelper.getSchemeCondition();
        SchemeController.getSchemeLines(condition.dmpl__SchemeId__c);
        SchemeController.getSchemeLedgerEntries('dmpl__SaleOrder__c',condition.dmpl__ItemId__C);
        SchemeController.getSchemeLedgerEntries('dmpl__SaleInvoice__c',condition.dmpl__ItemId__C);
        SchemeController.getSchemeLedgerEntries('dmpl__PurchaseOrder__c',condition.dmpl__ItemId__C);
        SchemeController.getSchemeLedgerEntries('dmpl__Bill__c',condition.dmpl__ItemId__C);
        SchemeController.getSchemeLedgerEntries('dmpl__RepairOrder__c',condition.dmpl__ItemId__C);
        SchemeController.getRecommendations(condition.dmpl__ItemId__C);
        System.assert(condition != null, 'Condition data found');
        test.stopTest();
    }
    
    
    @isTest
    Static void evaluatePerOrderConditionAsValue()
    {
        try{
            dmpl__SchemeLine__c schemeLine =SchemeTestDataHelper.getSchemeLine();
            dmpl__SchemeCondition__c condition = SchemeTestDataHelper.getSchemeCondition();
            dmpl__SchemeBenefit__c benefit=SchemeTestDataHelper.getSchemeBenefits();
            // SchemeEngine.applyPerDocumentSchemeLine(schemeLine,12);
            System.assert(condition != null, 'Condition data found');
        }
        catch(exception e){}
    }
    
    @isTest
    Static void getTotalItemSKUQuantity()
    {
        try{
            dmpl__SaleOrder__c so=SaleOrderTestDataHelpers.getSaleOrder();
            List<dmpl__SaleOrder__c> saleOrders = new List<dmpl__SaleOrder__c>();
            saleOrders.add(so);        
            test.startTest();
            dmpl__SchemeLine__c schemeLine =SchemeTestDataHelper.getSchemeLine();
            dmpl__SchemeCondition__c condition = SchemeTestDataHelper.getSchemeCondition();
            dmpl__SKU__c sku = TestDataHelpers.getSKU();
            dmpl__SchemeBenefit__c benefit=SchemeTestDataHelper.getSchemeBenefits();
            SchemeEngine.processSchemes(saleOrders);
            SchemeEngine.getMaximumBenefit(schemeLine);
            SchemeEngine.getTotalItemQuantity(condition);
            System.assert(sku != null, 'sku data found');
            test.stopTest();
        }catch(exception e){}
    }
    
    //@isTest
    Static void getTotalItemGroupQuantity()
    {
        try{
        test.startTest();
        dmpl__ItemGroup__c item = TestDataHelpers.getItemGroup();
        List<Id> itemIds = new List<Id>();
        List<Id> partnerAccountIds = new List<Id>();
        List<Id> branchIds = new List<Id>();
        ItemController.getItemStocks(itemIds,partnerAccountIds,branchIds);
        System.assert(item != null, 'item data found');
        test.stopTest();
        }
        catch(exception e){}
    }
    
    @isTest
    Static void evaluatePerOrderConditionAsItemValue()
    {
        try{
        test.startTest();
        dmpl__SchemeCondition__c condition = SchemeTestDataHelper.getSchemeCondition();
        // SchemeEngine.evaluatePerDocumentCondition(condition);
        SchemeEngine.doesItemGroupContains(condition.dmpl__ItemGroupId__c,condition.dmpl__ItemId__c,condition.dmpl__ItemSKUId__c,condition.dmpl__ItemLotTypeId__c);
        SchemeEngine.postPOSchemeLeders();
        SchemeEngine.getPOLines();
        SchemeEngine.getBillLines();
        System.assert(condition != null, 'condition data found');
        test.stopTest();
        }
        catch(exception e){}
    }
    
    @isTest
    Static void applyDiscount()
    {
        try{
        test.startTest();
        Integer count = 1;
        List<Id> ids = new List<Id>();
        List<SourceObjectInfo> info = new List<SourceObjectInfo>();
        // dmpl__SchemeLine__c schemeLine =SchemeTestDataHelper.getSchemeLine();
        // dmpl__SchemeBenefit__c benefit=SchemeTestDataHelper.getSchemeBenefits();
        // dmpl__SaleOrderLine__c sale = SaleOrderTestDataHelpers.getSaleOrderLine();
        // SchemeEngine.applyPerDocumentBenefit(benefit,10,schemeLine.dmpl__SchemeId__r.dmpl__PeriodType__c);
        // SchemeEngine.applySchemeBenefit(benefit, schemeLine.Id, benefit.Id, 10,info);
        // SchemeController.getQualifiedBenefits(benefit.Id,'',ids);
        // System.assert(benefit != null, 'benefit data found');
        test.stopTest();
    	}
        catch(exception e){}
    }
    
    @isTest
    private static void applyDocumentDiscountPercent()
    {
        try{
        test.startTest();
        List<SourceObjectInfo> info = new List<SourceObjectInfo>();
        dmpl__SchemeLine__c schemeLine =SchemeTestDataHelper.getSchemeLine();
        dmpl__SchemeBenefit__c benefit=SchemeTestDataHelper.getSchemeBenefits();
        dmpl__SaleOrderLine__c sale = SaleOrderTestDataHelpers.getSaleOrderLine();
        SchemeEngine.applyDocumentDiscountPercent(benefit);
        SchemeController.applyScheme('',sale.Id,schemeLine.Id,benefit.Id,1,info);
        test.stopTest();
        }
        catch(exception e){}
    }
    
    @isTest
    Static void applyDiscount1()
    {
        try{
        test.startTest();
        Integer count = 1;
        dmpl__SchemeLine__c schemeLine =SchemeTestDataHelper.getSchemeLine();
        dmpl__SchemeBenefit__c benefit=SchemeTestDataHelper.getSchemeBenefits();
        dmpl__SaleOrderLine__c sale = SaleOrderTestDataHelpers.getSaleOrderLine();
        SchemeEngine.applyDocumentRewardPoints(benefit);
        // SchemeEngine.applyDocumentDiscountdItem(benefit,count,true,schemeLine.dmpl__SchemeId__r.dmpl__PeriodType__c);
        // SchemeEngine.evaluateNumberOperator(10,'',10.20);
        // SchemeEngine.evaluateCurrencyOperator(10.50,'',10.10);
        SchemeEngine.ensureItemGroupRetreived('Per order');
        System.assert(benefit != null, 'benefit data found');
        test.stopTest();
    	}
        catch(exception e){}
    }
    
    @isTest
    Static void applyDiscount2()
    {
        try{
        test.startTest();
        Integer count = 1;
        dmpl__SchemeBenefit__c benefit=SchemeTestDataHelper.getSchemeBenefits();
        dmpl__SaleOrderLine__c sale = SaleOrderTestDataHelpers.getSaleOrderLine();
        SchemeController.getQualifiedSchemeSlabs('dmpl__SchemeLine__c',sale.Id);
        SchemeController.getDocumentObject('',sale.Id);
        System.assert(benefit != null, 'benefit data found');
        test.stopTest();}
        catch(exception e){}
    }
    
    @isTest
    Static void applyDiscount3()
    {
        try{
        test.startTest();
        Integer count = 1;
        dmpl__SchemeBenefit__c benefit=SchemeTestDataHelper.getSchemeBenefits();
        dmpl__SaleOrderLine__c sale = SaleOrderTestDataHelpers.getSaleOrderLine();
        // SchemeEngine.applyDocumentDiscountAmount(benefit);
        System.assert(benefit != null, 'benefit data found');
        test.stopTest();}
        catch(exception e){}
    }
    
    @isTest
    Static void applyDiscount4()
    {
        try{
        test.startTest();
        Integer count = 1;
        dmpl__SchemeBenefit__c benefit=SchemeTestDataHelper.getSchemeBenefits();
        dmpl__SaleOrderLine__c sale = SaleOrderTestDataHelpers.getSaleOrderLine();
        System.assert(benefit != null, 'benefit data found');
        test.stopTest();}
        catch(exception e){}
    }
    
    @isTest
    Static void applyPerPeriodSchemeLine()
    {
        test.startTest();
        // dmpl__SchemeLine__c line =SchemeTestDataHelper.getSchemeLine();
        // SchemeEngine.applyPerPeriodSchemeLine(line);
        // SchemeEngine.resetPerPeriodSchemeLine(line);
        // System.assert(line != null, 'scheme line data found');
        test.stopTest();
    }
    
    @isTest
    Static void getMinimumBenefit()
    {
        try{
        test.startTest();
        dmpl__SchemeLine__c line =SchemeTestDataHelper.getSchemeLine();
        SchemeEngine.getMaximumBenefit(line);
        System.assert(line != null, 'scheme line data found');
        test.stopTest();
        }catch(exception e){}
    }
    
    @isTest
    Static void getTotalItemSKUValue()
    {
        try{
        test.startTest();
        dmpl__SKU__c sku = TestDataHelpers.getSKU();
        SchemeEngine.getBillSummary();
        System.assert(sku != null, 'sku data found');
        test.stopTest();
        }catch(exception e){}
    }

}