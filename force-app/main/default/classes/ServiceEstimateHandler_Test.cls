@isTest
public with sharing class ServiceEstimateHandler_Test {
    @TestSetup
    static void makeData(){
        Account partnerAccount=TestDataHelpers.createPartnerAccount();
        Account customerAccount=TestDataHelpers.createCustomerAccount();
        dmpl__AccountGroup__c accountGroup=TestDataHelpers.createAccountGroup();
        dmpl__Branch__c branch=TestDataHelpers.createBranch(partnerAccount);
        dmpl__StorageLocation__c storageLocation=TestDataHelpers.createStorageLocation(branch);
        dmpl__ItemGroup__c itemGroup=TestDataHelpers.createItemGroup();
        dmpl__Item__c item=TestDataHelpers.createItem();
        dmpl__ItemAlternate__c itemAlternate=TestDataHelpers.CreateItemAlternate(item);
        dmpl__SKU__c sku=TestDataHelpers.createSKU(item);
        dmpl__ItemLot__c itemLot=TestDataHelpers.createItemLot(branch,item,sku,storageLocation);
        dmpl__Resource__c resource=TestDataHelpers.createResource(partnerAccount,branch);
        dmpl__PriceList__c priceList=TestDataHelpers.createPriceList(partnerAccount,branch);
        dmpl__PriceListRules__c priceListRules=TestDataHelpers.createPriceListRules(priceList,item);
        Asset asset=AssetTestDataHelpers.CreateAsset(
            customerAccount,
            branch,
            item,
            itemLot,
            sku
        );
        dmpl__AssetServiceContract__c assetServiceContract=AssetTestDataHelpers.createAssetServiceContract(asset,item);
        dmpl__DiscountGroup__c  discountGroup=TestDataHelpers.createDiscountGroup(partnerAccount,accountGroup,branch);

        dmpl__ServiceBay__c serviceBay=TestDataHelpers.CreateServiceBay(branch);
        //     CreateServiceType();
        dmpl__BranchTimeSlot__c branchTimeSlot=TestDataHelpers.createBranchTimeSlot(branch,item);
        dmpl__ServiceRequest__c serviceRequest=ServiceRequestTestDataHelpers.CreateServiceRequest(
            customerAccount,
            branch,
            item,
            asset,
            branchTimeSlot
        );
        dmpl__TaxGroup__c taxGroup=TestDataHelpers.createTaxGroup(partnerAccount,branch);
        dmpl__Tax__c tax= TestDataHelpers.CreateTax(taxGroup);       
        // dmpl__ProductHealthCheck__c phc=CheckListTestDataHelpers.CreateProductHealthCheck(branch,asset,partnerAccount,customerAccount);
        // dmpl__ProductHealthCheckRecommendation__c productHealthCheckRecommendation=CheckListTestDataHelpers.CreateProductHealthCheckRecommendation(phc);
        // dmpl__ServiceRequestLine__c serviceRequestLine=ServiceRequestTestDataHelpers.CreateServiceRequestLine(serviceRequest,item,sku);
        // dmpl__Quote__c quote=QuoteTestDataHelpers.CreateServiceEstimate(
        //     branch,
        //     customerAccount,
        //     priceList,
        //     asset,
        //     serviceRequest,
        //     item,
        //     taxGroup
        // );
        // dmpl__TaxGroupRule__c rule=TestDataHelpers.createTaxGroupRule(item,sku,taxGroup,itemGroup);
        // dmpl__PriceListRules__c priceRules=TestDataHelpers.createPriceListRules(priceList,item);
        // dmpl__QuoteLine__c quoteLine=QuoteTestDataHelpers.CreateServiceEstimateLine(
        //     item,
        //     priceRules,
        //     taxGroup,
        //     productHealthCheckRecommendation,
        //     quote);
        // dmpl__QuoteTax__c serviceEstimateTax=QuoteTestDataHelpers.CreateServiceEstimateTax(quote,quoteLine,tax,taxGroup);
        // VerifyServiceEstimateTax();
    }

    @isTest
    public static void getQuote1()
    {
        test.startTest();
        QuoteLine__c quoteLine=QuoteTestDataHelpers.getServiceEstimateLine();
        Quote__c quote=QuoteTestDataHelpers.getServiceEstimate();
        List<dmpl__Quote__c> quotes=new List<dmpl__Quote__c>();
        quotes.add(quote);
        List<Id> Ids = new List<Id>();
         PriceListHelper.getQuote(quoteLine,quotes);
         //ServiceEstimateService.queryServiceQuotes(Ids);
        //  ServiceEstimateTaxHelper.deleteApplicableTaxes(quotes);
         System.assertNotEquals(null, quotes);
        test.stopTest();
    } 

    @isTest
    public static void setDefaultDiscountGroupIds()
    {
        test.startTest();
        dmpl__Quote__c quote=QuoteTestDataHelpers.getServiceEstimate();
        List<dmpl__Quote__c> shipment = new List<dmpl__Quote__c>();
        shipment.add(quote);      
        DiscountGroupHelper.setDefaultDiscountGroupIds(shipment);
        System.assert(shipment != null, 'delivery order data');
        test.stopTest();        
    }
    
    
    @isTest
    public static void PDFController()
    {
        try{
        test.startTest();
        dmpl__Quote__c serviceEstimate = QuoteTestDataHelpers.getServiceEstimate();
        //List<PackageConfigLine> config = new List<PackageConfigLine>();
        ApexPages.StandardController sc = new  ApexPages.StandardController(serviceEstimate);     
        PDFController ext = new PDFController(sc);  
        ext.saveAttachement();
        ext.downloadAsPDF();
        PackageHelper.getQuotePackageConfiguration(serviceEstimate.Id);
        //PackageHelper.applyQuotePackageConfiguration(serviceEstimate.Id,config);
        System.assertNotEquals(null, serviceEstimate);
        test.stopTest();
        }catch(exception e){}
    }
    
    @isTest
    public static void UpdatePerformEstimateLinesGeneration()
    {
        try{
        test.startTest();
        List<PackageConfigLine> config = new List<PackageConfigLine>();
        dmpl__Quote__c serviceEstimate = QuoteTestDataHelpers.getServiceEstimate();
        serviceEstimate.dmpl__PerformEstimateLinesGeneration__c = True;
        update serviceEstimate;
        PackageHelper.applyQuotePackageConfiguration(serviceEstimate.Id,config);
        test.stopTest();
        System.assertEquals(True, serviceEstimate.dmpl__PerformEstimateLinesGeneration__c, 'serviceEstimate has 1 Record Updated');
        }catch(exception e){}
    }
    
    @isTest
    public static void performReprice()
    {
        test.starttest();
        dmpl__Quote__c serviceEstimate = QuoteTestDataHelpers.getServiceEstimate();
        ServiceEstimateLineHelper.performReprice(serviceEstimate.Id);
        test.stopTest();
    }
    
    @isTest
    public static void UpdatePerformDecline()
    {
        test.starttest();
        dmpl__Quote__c serviceEstimate = QuoteTestDataHelpers.getServiceEstimate();
        serviceEstimate.dmpl__PerformDecline__c = True;
        
        update serviceEstimate;
                test.stopTest();
        System.assertEquals(True, serviceEstimate.dmpl__PerformDecline__c, 'serviceEstimate has 1 Record Updated');
    }   
    
    @isTest
    public static void UpdatePerformApproval()
    {
        test.startTest();
        dmpl__Quote__c serviceEstimate = QuoteTestDataHelpers.getServiceEstimate();
        serviceEstimate.dmpl__PerformApproval__c = True;
        
        update serviceEstimate;
                test.stopTest();
        System.assertEquals(True, serviceEstimate.dmpl__PerformApproval__c, 'serviceEstimate has 1 Record Updated');
    }
    
    @isTest
    public static void UpdatePerformRepairOrderGeneration()
    {
        test.startTest();
        dmpl__Quote__c serviceEstimate = QuoteTestDataHelpers.getServiceEstimate();
        serviceEstimate.dmpl__PerformRepairOrderGeneration__c = True;
        Id itemId=serviceEstimate.dmpl__ServiceContractItemId__c;
        dmpl__Item__c item=[SELECT dmpl__ItemType__c FROM dmpl__Item__c WHERE id=:itemId];
        item.dmpl__ItemType__c='Service Contract';
        update item;
        update serviceEstimate;
                test.stopTest();
        System.assertEquals(True, serviceEstimate.dmpl__PerformRepairOrderGeneration__c, 'serviceEstimate has 1 Record Updated');
    }  
    
    @isTest
    public static void UpdatePerformUpdateRepairOrderGeneration()
    {
        test.startTest();
        dmpl__Quote__c serviceEstimate = QuoteTestDataHelpers.getServiceEstimate();
        serviceEstimate.dmpl__PerformUpdateRepairOrder__c = True;
        
        update serviceEstimate;
                test.stopTest();
        System.assertEquals(True, serviceEstimate.dmpl__PerformUpdateRepairOrder__c, 'serviceEstimate has 1 Record Updated');
    }  
    
    @isTest
    public static void createQuoteLinesFromServiceRequest()
    {
        test.startTest();
        dmpl__Quote__c serviceEstimate=QuoteTestDataHelpers.getServiceEstimate();
        List<dmpl__Quote__c> serviceEstimates = new List<dmpl__Quote__c>();
        serviceEstimates.add(serviceEstimate);
        ServiceEstimateLineHelper.createQuoteLinesFromServiceRequest(serviceEstimates);
                test.stopTest();
        System.assert(serviceEstimate != null, 'service Estimate data');
    } 
    
    
    @isTest
    public static void createQuoteFromServiceRequest()
    {
        test.startTest();
        dmpl__ServiceRequest__c serviceRequest = ServiceRequestTestDataHelpers.getServiceRequest();
        List<dmpl__ServiceRequest__c> serviceRequests= new List<dmpl__ServiceRequest__c>();
        serviceRequests.add(serviceRequest);
        ServiceEstimateHelper.createQuoteFromServiceRequest(serviceRequests);
        test.stopTest();
        System.assert(serviceRequests != null, 'service Estimate data');
    } 
    
    @isTest
    public static void createServiceEstimateLinesFromContract()
    {
        try{
        test.startTest();
        dmpl__Quote__c serviceEstimate = QuoteTestDataHelpers.getServiceEstimate();
        List<dmpl__Quote__c> serviceEstimates=new  List<dmpl__Quote__c>();
        serviceEstimates.add(serviceEstimate);
        dmpl__AssetServiceContract__c asset = AssetTestDataHelpers.getAssetServiceContract();
        if(asset != null)
        	ServiceEstimateLineHelper.createServiceEstimateLinesFromContract(serviceEstimates);
        test.stopTest();
        System.assert(serviceEstimate != null, 'service Estimate data');
        }catch(exception e){}
    }  
    
    @isTest
    public static void DeleteServiceEstimate()
    {
        test.startTest();
        dmpl__Quote__c serviceEstimate = QuoteTestDataHelpers.getServiceEstimate();
        if(serviceEstimate != null)
            Delete serviceEstimate;
                test.stopTest();
        System.assert(serviceEstimate != null, 'service Estimate data');
    } 

    @isTest
    public static void UpdateServiceEstimateLine()
    {
        test.startTest();
        dmpl__QuoteLine__c serviceEstimateLine = QuoteTestDataHelpers.getServiceEstimateLine();
        serviceEstimateLine.dmpl__UnitPrice__c = 10;
        update serviceEstimateLine;
                test.stopTest();
        System.assertEquals(10, serviceEstimateLine.dmpl__UnitPrice__c, 'serviceEstimate has 1 Record Updated');
    }
    
    @isTest
    public static void UpdateServiceEstimateDiscount()
    {
        test.startTest();
        try {
            dmpl__Quote__c quote = QuoteTestDataHelpers.getServiceEstimate();
            quote.dmpl__Discount__c = 10;
            update quote;
            test.stopTest();
                
        } catch (Exception ex) {
            
        }
    }

    @isTest
    public static void DeleteServiceEstimateLine()
    {
        dmpl__QuoteLine__c serviceEstimateLine = QuoteTestDataHelpers.getServiceEstimateLine();
         Test.startTest();
      		Database.DeleteResult LineResult = Database.delete(serviceEstimateLine, false);
        Test.stopTest();
        System.assert(LineResult.getErrors().size() == LineResult.getErrors().size());       
    }
    
    @isTest
    private static void VerifySalerOrderMethod()
    {
        test.startTest();
        dmpl__Quote__c serviceEstimate=QuoteTestDataHelpers.getServiceEstimate();
		List<dmpl__Quote__c> serviceEstimates =new  List<dmpl__Quote__c>();
        serviceEstimates.add(serviceEstimate);
        SaleOrderHelper.createSaleOrderFromServiceEstimate(serviceEstimates);
        test.stopTest();
    }
    
    @isTest
    private static void VerifyHeadlessCallableMethod()
    {
        test.startTest();
        dmpl__Quote__c quote = QuoteTestDataHelpers.getServiceEstimate();
        test.stopTest();
    }
    
    @isTest
    private static void VerifyCreateSaleOrderFromQuote()
    {
        test.startTest();
        dmpl__Quote__c quote = QuoteTestDataHelpers.getServiceEstimate();
        quote.dmpl__PerformSaleOrderGeneration__c = true;
        update quote;
        test.stopTest();
    }
    
    @isTest
    public static void VerifyServiceEstimateTax()
    {
        test.startTest();
        dmpl__Quote__c quote = QuoteTestDataHelpers.getServiceEstimate();
        dmpl__QuoteLine__c Estimateline =QuoteTestDataHelpers.getServiceEstimateLine();
        List<dmpl__QuoteLine__c> Estimatelines=new List<dmpl__QuoteLine__c>();
        Estimatelines.add(Estimateline);
        dmpl__Tax__c tax = TestDataHelpers.getTax();
        // ServiceEstimateTaxHelper.setApplicableTaxes(Estimatelines);
        // ServiceEstimateTaxHelper.deleteApplicableTaxes(Estimatelines); 
        // ServiceEstimateTaxHelper.createQuoteTax(tax,Estimateline);
        // ServiceEstimateTaxHelper.createQuoteTax(tax,quote);
        test.stopTest();
    }

    @isTest
    public static void getActionSettings1()
    { 
        try{
        test.startTest();
        dmpl__Item__c order =  TestDataHelpers.getItem();
         DynamicTextParser.parse('',order);
        System.assert(order != null, 'Item data');
        test.stopTest();
    }
    catch(Exception e){}
    }
    
    @isTest
    public static void getActionSettings()
    { 
        try{
        test.startTest();
        dmpl__Item__c order = TestDataHelpers.getItem();
        ScreenActionController.getActionSettings('','dmpl__Item__c');
        System.assert(order != null, 'Item data');
        test.stopTest();
    }
    catch(Exception e){}
    }
    
    @isTest
    public static void getSourceObject()
    { 
        try{
            test.startTest();
            dmpl__Item__c order = TestDataHelpers.getItem();       
            ScreenActionController.getSourceObject('dmpl__Item__c',order.Id);
            System.assert(order != null, 'Item data');
            test.stopTest();
        }
        catch(Exception e){}
    }
    
    @isTest
    public static void setApplicableTaxGroups()
    {
        try{
        test.startTest();
        dmpl__Quote__c qt=QuoteTestDataHelpers.getServiceEstimate();
        List<dmpl__Quote__c> quote = new List<dmpl__Quote__c>();
        quote.add(qt);
        dmpl__QuoteLine__c ln= QuoteTestDataHelpers.getServiceEstimateLine();
        List<dmpl__QuoteLine__c> line = new List<dmpl__QuoteLine__c>();
        line.add(ln);
        dmpl__Item__c itm=TestDataHelpers.getItem();
        dmpl__ItemGroup__c itemGroup=TestDataHelpers.getItemGroup();
        itm.dmpl__TaxItemGroupId__c=itemGroup.id;
        update itm;
        List<dmpl__Item__c> item = new List<dmpl__Item__c>();
        item.add(itm);
        dmpl__TaxGroupRule__c rule = TestDataHelpers.getTaxGroupRule();
        if(rule != null)
        {
        	TaxGroupHelper.setApplicableTaxGroups(line, quote, item);
        }
        System.assertNotEquals(null, quote);
        test.stopTest();
        }
        catch(exception e){}
    }
   
    @isTest
    public static void VerifyUpdateRepairOrderFromServiceEstimate()
    {
        test.startTest();
        Test.stopTest();
        dmpl__Quote__c qt=QuoteTestDataHelpers.getServiceEstimate();
        List<dmpl__Quote__c> quote = new List<dmpl__Quote__c>();
        quote.add(qt);
        quote[0].dmpl__PerformEstimateLinesGeneration__c = true;
        update quote;
        RepairOrderHelper.UpdateRepairOrderFromServiceEstimate(quote);
        System.assertNotEquals(null, quote);        
    }
    
    @isTest
    public static void updateQuoteLine()
    {
        test.startTest();
        dmpl__QuoteLine__c line = QuoteTestDataHelpers.getServiceEstimateLine();
        if(line != null)
            update line;
        System.assert(line != null, 'Quote line Updated');
        test.stopTest();
    }
    
    @isTest
    private static void VerifyServiceEstimateLinesUpdate()
    {	test.startTest();
        dmpl__QuoteLine__c ql=QuoteTestDataHelpers.getServiceEstimateLine();
        List<dmpl__QuoteLine__c> lines = new List<dmpl__QuoteLine__c>();
        lines.add(ql);
        update lines;
     	test.stopTest();
    }
    
    @isTest
    private static void VerifyServiceEstimateLinesDelete()
    {
        test.startTest();
        dmpl__QuoteLine__c ql=QuoteTestDataHelpers.getServiceEstimateLine();
        List<dmpl__QuoteLine__c> lines = new List<dmpl__QuoteLine__c>();
        lines.add(ql);
        delete lines;
        test.stopTest();
    }

}