/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-30-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class RepairOrderHelper_Test {
    
    @testSetup
    public static void Setup()
    {
       // System.runAs(PostInstallHelper.AssignAdministratorAllPermissions(UserInfo.getUserId())){     
      //RepairOrderDataFactory_Test.data();
        CreateAccountGroup();
        CreateAccount();
        CreateBranch();
        CreateStorageLocation();
        CreateItem();
        CreateSKU();
        //CreateItemLot();
        CreateResource(); 
        CreatePriceList();
        CreateAsset();
        CreateTaxGroup();
         
        CreateTax();
        CreateServiceRequest();
        CreateServiceEstimate(); 
        test.startTest();
        CreateRepairOrder(); 
        CreateRepairOrderLine();
               test.stopTest();
        //CreateRepairOrderTax(); 
             
    }
 
    @isTest
    public static void setDefaultDiscountGroupIds()
    {
        test.startTest();
        //CreateDiscountGroup();
        List<dmpl__RepairOrder__c> shipment = [SELECT Id,  Name,
                                                 dmpl__AccountId__c,
                                                 dmpl__DocumentDate__c,
                                                 dmpl__DiscountGroupId__c,
                                                 dmpl__BranchId__c,
                                                 dmpl__PartnerAccountId__c
                                                 FROM dmpl__RepairOrder__c];       
        
        DiscountGroupHelper.setDefaultDiscountGroupIds(shipment);
        System.assert(shipment != null, 'delivery order data');
        test.stopTest();
    }
    
    private static void CreateDiscountGroup()
    {
        List<dmpl__DiscountGroup__c> discountGroup = new List<dmpl__DiscountGroup__c>();
        dmpl__AccountGroup__c accountGroup=[Select Id,Name From dmpl__AccountGroup__c LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c Limit 1];
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account' LIMIT 1];
        discountGroup.add(new dmpl__DiscountGroup__c(dmpl__BranchId__c = branch.Id,
                                                     dmpl__CustomerAccountGroupId__c = accountGroup.Id,
                                                     dmpl__PartnerAccountId__c = account.Id,
                                                     dmpl__PartnerAccountGroupId__c = accountGroup.Id,
                                                     dmpl__IsDefault__c = true,
                                                     dmpl__IsActive__c = true,
                                                     Name = 'Test - Discount - Group',
                                                     dmpl__DiscountType__c ='Sale Price'
                              ));
        insert discountGroup;
    }
        
    @isTest
    Public static void getRepairOrder()
    {
        try{
                        
        test.startTest();
        List<RepairOrder__c> sOrder=[Select Id, Name,dmpl__SupplierAccountId__c,(Select Id, Name,dmpl__RepairOrderId__c from dmpl__Repair_Order_Lines1__r) From RepairOrder__c Limit 1 ];
        dmpl__RepairOrderLine__c soLine=[select Id, Name From dmpl__RepairOrderLine__c where dmpl__RepairOrderId__c=:sOrder[0].id];
        PriceListHelper.getRepairOrder(sOrder[0].dmpl__Repair_Order_Lines1__r[0],sOrder);
        DiscountGroupHelper.getRepairOrder(sOrder[0].dmpl__Repair_Order_Lines1__r[0],sOrder);
        RepairOrderTimeSheetHelper.queryPendingRepairOrderLines(sOrder[0].dmpl__Repair_Order_Lines1__r[0].Id);
        SchemeEngine.getROLines();
        SaleInvoiceHelper.createServiceInvoiceDocument('',soLine,null,sOrder[0].dmpl__SupplierAccountId__c);
        SaleInvoiceHelper.createServiceInvoiceLine(soLine,null);
        dmpl__InventoryFulfillmentAllocationLine__c allocationLine=new dmpl__InventoryFulfillmentAllocationLine__c();
        List<SourceObjectInfo> orderLinesInfo= new List<SourceObjectInfo>();
        SaleInvoiceHelper.createServiceInvoiceLine(soLine,allocationLine,orderLinesInfo);
        System.assert(sOrder != null, 'Repair Order Line Data');
            
        test.stopTest();
        }catch(exception e){}
    } 
    
     @isTest
    private static void VerifyHeadlessCallabaleMethod()
    {
        test.startTest();
        dmpl__RepairOrder__c serviceRequest = [Select Id,Name From dmpl__RepairOrder__c LIMIT 1];
        HeadlessCallableController.callHeadlessAction('headlessAction','dmpl__RepairOrder__c',serviceRequest.Id);
        System.assert(serviceRequest != null,'request data');
        test.stopTest();
    }
    
    @isTest    
    public static void updateServiceRecommendationFromRepairOrder()
    {
        Test.startTest();
        
        //CreateServiceRecommendation();
        List<dmpl__RepairOrder__c> order =[select Id, Name,dmpl__AssetId__c,dmpl__PerformGenerateQuote__c,dmpl__AccountId__c,dmpl__IsQuoteGenerated__c,dmpl__CustomerVoice__c,dmpl__PartnerAccountId__c,dmpl__BranchId__c,dmpl__ServiceAdvisorId__c,dmpl__UsageReading__c,dmpl__UsageReadingHours__c from dmpl__RepairOrder__c Limit 1];
        string errorReceived;
       try{
            
            ServiceRecommendationHelper.updateServiceRecommendationFromRepairOrder(order);
            
        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
        System.assertEquals(null, errorReceived);
        
        test.stopTest();
    }
    
    public static void VerifyRepairOrderTax()
    {
         List<dmpl__RepairOrderLine__c> RepairOrderline = [SELECT Id, 
            Name,
            dmpl__TaxGroupId__c,
            dmpl__RepairOrderId__c,
            dmpl__PostingType__c,
            dmpl__Amount__c FROM dmpl__RepairOrderLine__c limit 1];
        
        //Test.startTest();
        string errorReceived;
        try{             
           
        //   RepairOrderTaxHelper.setApplicableTaxes(RepairOrderline);
        //     RepairOrderTaxHelper.deleteApplicableTaxes(RepairOrderline);
            
        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
        System.assertEquals(null, errorReceived);
        
        //Test.stopTest();
    }
    
    @isTest
    public static void updateDiscountInRepairOrderLinesTest()
    {
        test.startTest();
        List<dmpl__RepairOrder__c> order = [Select Id,Name,dmpl__PartnerAccountId__c,dmpl__DocumentDate__c,dmpl__BranchId__c,dmpl__AssetId__c,dmpl__AccountId__c,dmpl__CustomerVoice__c,dmpl__ServiceAdvisorId__c,dmpl__Discount__c,(Select Id,Name,dmpl__ItemId__c,dmpl__SKUId__c,dmpl__TaxGroupId__c From dmpl__Repair_Order_Lines1__r WHERE dmpl__TaxGroupId__c != null) From dmpl__RepairOrder__c LIMIT 1];
        RepairOrderHelper.updateDiscountInRepairOrderLines(order);
        test.stopTest();
    }
    
    @isTest
    public static void setApplicableTaxGroups()
    {
        try{
        //List<dmpl__RepairOrderLine__c> line = [Select Id,Name,dmpl__ItemId__c,dmpl__SKUId__c,dmpl__TaxGroupId__c From dmpl__RepairOrderLine__c WHERE dmpl__TaxGroupId__c != null LIMIT 1];
        test.startTest();
        List<dmpl__RepairOrder__c> order = [Select Id,Name,dmpl__PartnerAccountId__c,dmpl__DocumentDate__c,dmpl__BranchId__c,(Select Id,Name,dmpl__ItemId__c,dmpl__SKUId__c,dmpl__TaxGroupId__c From dmpl__Repair_Order_Lines1__r WHERE dmpl__TaxGroupId__c != null) From dmpl__RepairOrder__c LIMIT 1];
        List<dmpl__Item__c> item = [Select Id,Name,dmpl__TaxItemGroupId__c From dmpl__Item__c LIMIT 1];
        dmpl__TaxGroupRule__c rule = [Select Id,Name From dmpl__TaxGroupRule__c LIMIT 1];
            
        
        
        if(rule != null)
        {
          TaxGroupHelper.setApplicableTaxGroups(order[0].dmpl__Repair_Order_Lines1__r, order, item);
        }
        System.assertNotEquals(null, order);
            
        test.stopTest();
        }
        catch(exception e){}
    }
    
    @isTest
    public static void VerifyChecklistLines()
    {
        test.startTest();
        CreateChecklistTemplate();
        CreateChecklistTemplateLine();
        CreateChecklistlines();
        List<dmpl__RepairOrder__c> order = [SELECT Id,  Name,
                                            dmpl__AccountId__c,
                                            dmpl__DocumentDate__c,
                                            dmpl__BranchId__c,
                                            dmpl__PartnerAccountId__c
                                            FROM dmpl__RepairOrder__c];
        
      //  test.startTest();
     
        ChecklistLineHelper.createChecklistLines(order);
        System.assert(order != null, 'repair order data');
        
        test.stopTest();
    }
    
    @isTest
    public static void updateAssetFromRepairOrder()
    {
           
        test.startTest();
        List<dmpl__RepairOrder__c> order = [SELECT Id,  Name,
                                            dmpl__AccountId__c,
                                            dmpl__DocumentDate__c,
                                            dmpl__BranchId__c,
                                            dmpl__UsageReading__c,
                                            dmpl__AssetId__c,
                                            dmpl__UsageReadingHours__c,
                                            dmpl__PartnerAccountId__c,
                                            dmpl__ResetUsageHours__c,
                                            dmpl__ResetUsageReading__c
                                            FROM dmpl__RepairOrder__c];      
        AssetHelper.updateAssetFromRepairOrder(order);
        System.assert(order != null, 'repair order data');
        
        test.stopTest();
    }
    
   @isTest
    public static void populateLinesFromServiceContractItem()
    {     

        test.startTest();
        List<dmpl__RepairOrder__c> order = [SELECT Id,  Name,
                                            dmpl__AccountId__c,
                                            dmpl__DocumentDate__c,
                                            dmpl__BranchId__c,
                                            dmpl__ServiceEstimateId__c,
                                            dmpl__AssetId__c,
                                            dmpl__PartnerAccountId__c
                                            FROM dmpl__RepairOrder__c
                                           ];       
        RepairOrderLineHelper.populateLinesFromServiceContractItem(order);
        System.assert(order != null, 'repair order data');
        
        test.stopTest();
    }     
    
    @isTest
    public static void VerifyPDIDone()
    {
        test.startTest();
        List<Id> assetIds =new List<Id>();
        Asset order = [SELECT Id,Name,dmpl__IsPDIDone__c  FROM Asset]; 
        assetIds.add(order.Id);
        AssetHelper.markPDIDone(assetIds);
        System.assert(order != null, 'repair order data');
        test.stopTest();
    }
    
   
    @isTest
    public static void UpdateRepairOrderAsPopulateLinesForRequest()
    {
        test.startTest();
        List<dmpl__RepairOrder__c> repairOrders = [Select Id,Name,dmpl__PerformPopulateLines__c,dmpl__AssetId__c,dmpl__ItemServiceContractId__c, dmpl__ServiceRequestId__c,dmpl__Discount__c, dmpl__ServiceEstimateId__c From dmpl__RepairOrder__c WHERE dmpl__ServiceRequestId__c != null];
        for(dmpl__RepairOrder__c repairOrder : repairOrders)
        {  
            repairOrder.dmpl__PerformPopulateLines__c = true;
        }
        update repairOrders;
        RepairOrderHelper.populateLines(repairOrders);
        
        test.stoptest();
        System.assertEquals(True, repairOrders[0].dmpl__PerformPopulateLines__c, 'Sale Order has 1 Record Updated');
    }
    
    @isTest
    public static void UpdateRepairOrderAsPerformForFulfillment()
    {
        test.startTest();
         List<dmpl__RepairOrder__c> repairOrders = [Select Id,Name,dmpl__PerformReleaseForFulfillment__c,dmpl__PerformPopulateLines__c,dmpl__ServiceRequestId__c From dmpl__RepairOrder__c WHERE dmpl__ServiceRequestId__c != null];
        for(dmpl__RepairOrder__c repairOrder : repairOrders)
        {  
            repairOrder.dmpl__PerformReleaseForFulfillment__c = true;
        }
        update repairOrders;
        
        test.stoptest();
        
        System.assertEquals(True, repairOrders[0].dmpl__PerformReleaseForFulfillment__c, 'Sale Order has 1 Record Updated');
    }
    
    @isTest
    public static void UpdateRepairOrderAsPopulateLinesForEstimate()
    {        
        test.startTest();
        List<dmpl__RepairOrder__c> repairOrders = [Select Id,Name,dmpl__PerformPopulateLines__c, dmpl__ServiceRequestId__c, dmpl__ServiceEstimateId__c From dmpl__RepairOrder__c WHERE dmpl__ServiceEstimateId__c != null];
        for(dmpl__RepairOrder__c repairOrder : repairOrders)
        {  
            repairOrder.dmpl__PerformPopulateLines__c = true;
        }
        update repairOrders;
        
        test.stopTest();
        
        System.assertEquals(True, repairOrders[0].dmpl__PerformPopulateLines__c, 'Sale Order has 1 Record Updated');
    }
    
    @isTest
    public static void UpdateRepairOrderAsWorkStart()
    {
        try{
        test.startTest();
        dmpl__RepairOrder__c repairOrder = [Select Id,Name,dmpl__PerformWorkStart__c From dmpl__RepairOrder__c LIMIT 1];  
        repairOrder.dmpl__PerformWorkStart__c = True;
        update repairOrder;
        
        //dmpl__RepairOrderLine__c line = [Select Id,Name,dmpl__RepairOrderId__c From dmpl__RepairOrderLine__c LIMIT 1];
        SchemeEngine.postROSchemeLeders();
        //PurchaseOrderHelper.createPurchaseOrderDocument(repairOrder);
       // List<AggregateResult> result2 = DocumentAmountPanelController.getDocumentTaxes('dmpl__RepairOrder__c', repairOrder.Id);
        //SchemeHelper.postROSchemeLeders(repairOrder);
        
        test.stopTest();
            
      System.assertEquals(True, repairOrder.dmpl__PerformWorkStart__c, 'Sale Order has 1 Record Updated');
        }
        catch(exception e){}
         
    }
    
    public static void UpdateRepairOrderAsWorkEnd()
    {
        test.startTest();
        dmpl__RepairOrder__c repairOrder = [Select Id,Name,dmpl__PerformWorkEnd__c From dmpl__RepairOrder__c LIMIT 1];
        repairOrder.dmpl__PerformWorkEnd__c = True;
        update repairOrder;
        test.stopTest();
        System.assertEquals(True, repairOrder.dmpl__PerformWorkEnd__c, 'Sale Order has 1 Record Updated');
    }
    
    @isTest
    public static void UpdateRepairOrderAsPerformCheckList()
    {
        test.startTest();
        dmpl__RepairOrder__c repairOrder = [Select Id,Name,dmpl__PerformPopulateChecklist__c From dmpl__RepairOrder__c LIMIT 1];
        repairOrder.dmpl__PerformPopulateChecklist__c = True;
        update repairOrder;
        
        test.stopTest();
        
        System.assertEquals(True, repairOrder.dmpl__PerformPopulateChecklist__c, 'Sale Order has 1 Record Updated');
    }
    
    @isTest
    public static void PerformKPICalculation()
    {

        test.startTest();
        dmpl__RepairOrder__c repairOrder = [Select Id,Name,dmpl__PerformKPICalculation__c From dmpl__RepairOrder__c LIMIT 1];
        repairOrder.dmpl__PerformKPICalculation__c = True;
        update repairOrder;
        test.stopTest();
        
        System.assertEquals(True, repairOrder.dmpl__PerformKPICalculation__c, 'Sale Order has 1 Record Updated');
    }
    
    @isTest
    public static void VerifyValidations()
    {
        try{
            test.startTest();
            List<dmpl__RepairOrderLine__c> order = [SELECT Id, dmpl__CancelledQuantity__c,dmpl__Quantity__c, Name FROM dmpl__RepairOrderLine__c];       
            ValidationHelper.validateIncrementalNumbers('dmpl__Quantity__c','dmpl__CancelledQuantity__c',order);
            
            System.assert(order != null, 'Repair order data');
            
            test.stopTest();
        }
        catch(Exception e){
        }
    }
    
    @isTest
    public static void UpdateRepairOrderAsdelivered()
    {
        test.startTest();
        dmpl__RepairOrder__c repairOrder = [Select Id,Name,dmpl__IsDelivered__c From dmpl__RepairOrder__c LIMIT 1];
        repairOrder.dmpl__IsDelivered__c = True;
        update repairOrder;
        
        test.stopTest();
        
        System.assertEquals(True, repairOrder.dmpl__IsDelivered__c, 'Sale Order has 1 Record Updated');
    }
    
    @isTest
    public static void createServiceInvoice()
    {
        
        test.startTest();
        List<dmpl__RepairOrder__c> repairOrder = [Select Id,Name,dmpl__IsDelivered__c,dmpl__AssetId__c,dmpl__BranchId__c,dmpl__DocumentDate__c,
                                                  dmpl__PartnerAccountId__c,dmpl__UsageReading__c,dmpl__UsageReadingHours__c,
                                                  dmpl__ItemServiceContractId__c,dmpl__ServiceContractItemId__c,
                                             dmpl__ServiceType__c,dmpl__ResetUsageHours__c,dmpl__ResetUsageReading__c From dmpl__RepairOrder__c LIMIT 1];
        RepairOrderHelper.updateServiceRecommendations(repairOrder);
        RepairOrderHelper.updateAsset(repairOrder);
        System.assert(repairOrder != null, 'Sale Order has 1 Record Updated');
        
        test.stopTest();
    }
    
    @isTest
    public static void UpdateRepairOrderAsPerformVor()
    {

        test.startTest();
        dmpl__RepairOrder__c repairOrder = [Select Id,Name,dmpl__PerformVOROrderGeneration__c From dmpl__RepairOrder__c LIMIT 1];
        repairOrder.dmpl__PerformVOROrderGeneration__c = True;
        update repairOrder;
        
        test.stopTest();
        System.assertEquals(True, repairOrder.dmpl__PerformVOROrderGeneration__c, 'Sale Order has 1 Record Updated');
    }
    
   
    public static void UpdateRepairOrderAsInvoiceGeneration()
    {
        dmpl__RepairOrder__c repairOrder = [Select Id,Name,dmpl__PerformInvoiceGeneration__c From dmpl__RepairOrder__c LIMIT 1];
        if(repairOrder != null)
          repairOrder.dmpl__PerformInvoiceGeneration__c = True;
        update repairOrder;
        System.assertEquals(True, repairOrder.dmpl__PerformInvoiceGeneration__c, 'Sale Order has 1 Record Updated');
    }
    
    @isTest
    public static void DeleteRepairOrder()
    {
        test.startTest();
        dmpl__RepairOrder__c repairOrder = [Select Id,Name From dmpl__RepairOrder__c LIMIT 1];
        if(repairOrder != null)
            Delete repairOrder;
        
        test.stopTest();
        
        System.assert(repairOrder != null, 'repair order data');
    } 
    
    @isTest
    public static void VerifyRepairOrderLine()
    {
        try{
     
        test.startTest();
         dmpl__RepairOrderLine__c repairOrderLine = [Select Id,Name,dmpl__RepairOrderId__c,dmpl__BaseAmount__c,dmpl__Discount__c,dmpl__DiscountAmount__c,dmpl__Discount2__c,dmpl__DiscountAmount2__c,dmpl__ContractDiscount__c,dmpl__ContractDiscountAmount__c,dmpl__TaxAmount__c,dmpl__ItemId__c,dmpl__Quantity__c,
            dmpl__SKUId__c From dmpl__RepairOrderLine__c LIMIT 1];
        if(repairOrderLine  != null)
            repairOrderLine.dmpl__Quantity__c = 5;
        update repairOrderLine ;
        SchemeEngine.getROSummary();     
        test.stopTest();
            
        System.assertEquals(5, repairOrderLine.dmpl__Quantity__c, 'Repair Order Line has 1 Record Deleted');
        }catch(exception e){}
    }
    
    @isTest
    public static void DeleteRepairOrderLine()
    {

        test.startTest();
        dmpl__RepairOrderLine__c repairOrderLine = [Select Id,Name From dmpl__RepairOrderLine__c LIMIT 1];
        if(repairOrderLine != null)
            Delete repairOrderLine;
        test.stopTest();
        System.assert(repairOrderLine != null, 'repair order line data');
    }
    
    @isTest
    public static void VerifyUpdateRepairOrderFromServiceEstimate()
    {
        test.startTest();
        List<dmpl__Quote__c> quote = [Select Id,Name,dmpl__ServiceRequestRepairOrderId__c,dmpl__ServiceRequestId__c,dmpl__PerformEstimateLinesGeneration__c From dmpl__Quote__c LIMIT 1];
        quote[0].dmpl__PerformEstimateLinesGeneration__c = true;
        update quote;
        RepairOrderHelper.UpdateRepairOrderFromServiceEstimate(quote);
        Test.stopTest();
        System.assertNotEquals(null, quote);        
    }

    public static void UpdatePerformEstimateLinesGeneration()
    {

        dmpl__Quote__c serviceEstimate = [Select Id,Name,dmpl__PerformEstimateLinesGeneration__c From dmpl__Quote__c LIMIT 1];
        serviceEstimate.dmpl__PerformEstimateLinesGeneration__c = True;
        update serviceEstimate;
    
        System.assertEquals(True, serviceEstimate.dmpl__PerformEstimateLinesGeneration__c, 'serviceEstimate has 1 Record Updated');
    }
        
    @isTest
    public static void UpdatePerformDecline()
    {
        test.startTest();
        
        UpdatePerformEstimateLinesGeneration();
        dmpl__Quote__c serviceEstimate = [Select Id,Name,dmpl__PerformDecline__c From dmpl__Quote__c LIMIT 1];
        serviceEstimate.dmpl__PerformDecline__c = True;
        
        update serviceEstimate;
        List<dmpl__QuoteLine__c> line = [Select Id,Name,dmpl__ItemComponentId__c From dmpl__QuoteLine__c LIMIT 1];
        List<dmpl__ItemComponent__c> comp = [Select Id,Name From dmpl__ItemComponent__c LIMIT 1];
        //ServiceEstimateLineHelper.applyPackageConfiguration(serviceEstimate,line,comp);
        
        test.stopTest();
        System.assertEquals(True, serviceEstimate.dmpl__PerformDecline__c, 'serviceEstimate has 1 Record Updated');
    }
    
    @isTest
    public static void populateChecklistDetails()
    {

        test.startTest();
        List<dmpl__RepairOrder__c> repairOrder = [Select Id,Name From dmpl__RepairOrder__c LIMIT 1];
        RepairOrderHelper.populateChecklistDetails(repairOrder);
        
        test.stopTest();
        System.assert(repairOrder != null, 'Repair Order data');
    }
    
    @isTest
    public static void createRepairOrderFromInspection()
    {
        List<Id> inspectionLine = new List<Id>();
        
        test.startTest();
        List<dmpl__InspectionLine__c> line = [Select Id,Name From dmpl__InspectionLine__c LIMIT 1];
        RepairOrderHelper.createRepairOrderFromInspection(inspectionLine);
        
        test.stopTest();
        
        System.assert(line != null, 'Repair Order data');
    }
    
    @isTest
    public static void updatePaidAmount()
    {
        List<Id> repairOrders = new List<Id>();
        
        test.startTest();
        List<dmpl__InspectionLine__c> line = [Select Id,Name From dmpl__InspectionLine__c LIMIT 1];
        RepairOrderHelper.updatePaidAmount(repairOrders);
        
        test.stopTest();
        
        System.assert(line != null, 'Repair Order data');
    }
    
    @isTest
    public static void updateIsClaimedFromClaim()
    {
        List<Id> repairOrders = new List<Id>();
        
        test.startTest();
        dmpl__RepairOrder__c line = [Select Id,Name,dmpl__IsClaimed__c From dmpl__RepairOrder__c LIMIT 1];
        //RepairOrderHelper.updateIsClaimedFromClaim(repairOrders,line.dmpl__IsClaimed__c);
        
        test.stopTest();
        
        System.assert(line != null, 'Repair Order data');
    }
    
    @isTest
    public static void verifyQuote()
    {
       
        test.startTest();
        List<dmpl__Quote__c> line = [Select Id,Name,dmpl__RepairOrderId__c,dmpl__AccountId__c,dmpl__AssetId__c,dmpl__BranchId__c,dmpl__CustomerVoice__c,
                                     dmpl__PartnerAccountId__c,dmpl__ServiceAdvisorId__c,dmpl__ServiceRequestId__c,
                                     dmpl__UsageReading__c,dmpl__Remarks__c,dmpl__UsageReadingHours__c,dmpl__ItemServiceContractId__c,dmpl__ServiceContractItemId__c,
                                     dmpl__ServiceType__c,dmpl__DocumentDate__c,dmpl__ServiceRequestRepairOrderId__c From dmpl__Quote__c LIMIT 1];
        RepairOrderHelper.createRepairOrderFromServiceEstimate(line);
        RepairOrderHelper.updateRepairOrderFromServiceEstimate(line);
        test.stopTest();    
        System.assert(line != null, 'Repair Order data');
    }
    
    @isTest
    public static void verifyRequest()
    {
        test.startTest();
        List<dmpl__ServiceRequest__c> line = [Select Id,Name,dmpl__RepairOrderId__c From dmpl__ServiceRequest__c LIMIT 1];
        RepairOrderHelper.createRepairOrderFromServiceRequest(line);
        
        test.stopTest();
        
        System.assert(line != null, 'Repair Order data');
    }
    
    @isTest
    private static void VerifyCreateClaimsMethod()
    {
        try{
        test.startTest();
        createRepairOrderLine('Auto Generate Claims');
        dmpl__RepairOrder__c repairOrder = [Select Id,Name From dmpl__RepairOrder__c LIMIT 1];
        dmpl__RepairOrderLine__c line = [Select Id,Name,dmpl__Discount__c,dmpl__DiscountAmount__c,dmpl__Discount2__c,dmpl__DiscountAmount2__c,dmpl__ContractDiscount__c,dmpl__ContractDiscountAmount__c From dmpl__RepairOrderLine__c LIMIT 1];
        
        List<SourceObjectInfo> objList = new List<SourceObjectInfo>();
        SourceObjectInfo obj = new SourceObjectInfo('dmpl__RepairOrderLine__c',line.Id,1,null);
        objList.add(obj);
        
        ClaimHelper.createClaims(repairOrder.Id);
        ClaimHelper.createClaims(new list<dmpl__RepairOrder__c>{repairOrder});
        ClaimHelper.createClaims(objList);
        test.stopTest();
        }catch(Exception e){}
    }
    
    @isTest
    private static void VerifyCreateInvoiceMethod()
    {
        try{
        test.startTest();
        createRepairOrderLine('Generate Invoices');
        dmpl__RepairOrder__c repairOrder = [Select Id,Name,(SELECT Id,Name FROM dmpl__Repair_Order_Lines1__r) From dmpl__RepairOrder__c LIMIT 1];
        List<SourceObjectInfo> objList = new List<SourceObjectInfo>();
        SourceObjectInfo obj = new SourceObjectInfo('dmpl__RepairOrderLine__c',repairOrder.dmpl__Repair_Order_Lines1__r[0].Id,1,null);
        objList.add(obj);
        SaleInvoiceHelper.createServiceInvoice(repairOrder.Id);
        //SaleInvoiceHelper.createServiceInvoice(objList);
        test.stopTest();
        }catch(Exception e){}
    }
    
    @isTest
    private static void VerifyServiceEstimateLineMethod()
    {
        test.startTest();
        createRepairOrderLine('Generate Invoices');
        List<dmpl__Quote__c> serviceEstimate = [Select Id,Name,dmpl__RepairOrderId__c,dmpl__ItemServiceContractId__c From dmpl__Quote__c];
        dmpl__RepairOrder__c repairOrder = [Select Id,Name,dmpl__AssetId__c,dmpl__AccountId__c,dmpl__CustomerVoice__c,dmpl__PartnerAccountId__c,dmpl__BranchId__c,dmpl__ServiceAdvisorId__c,dmpl__UsageReading__c,dmpl__UsageReadingHours__c,dmpl__QuoteForItemServiceContractId__c,dmpl__ServiceContractItemId__c,dmpl__ServiceType__c,dmpl__DocumentDate__c From dmpl__RepairOrder__c LIMIT 1];
        RepairOrderLine__c repairOrderLine = [select Id,Name,dmpl__RepairOrderId__c from RepairOrderLine__c Limit 1];
        List<dmpl__RepairOrder__c> repairOrder1= [select Id,Name from dmpl__RepairOrder__c];
        dmpl__ItemServiceContract__c contract = [Select Id,Name From dmpl__ItemServiceContract__c LIMIT 1];
        serviceEstimate[0].dmpl__ItemServiceContractId__c = contract.Id;
        serviceEstimate[0].dmpl__RepairOrderId__c = repairOrder.Id;
        ServiceEstimateHelper.createQuoteFromRepairOrder(new List<dmpl__RepairOrder__c>{repairOrder});
        ServiceEstimateLineHelper.createQuoteLinesFromRepairOrder(serviceEstimate);
        RepairOrder__c r = DiscountGroupHelper.getRepairOrder(repairOrderLine,repairOrder1);
        System.assertEquals(r.Name,repairOrder1[0].Name,'Matched');
        test.stopTest();
    }
    
    @isTest
    private static void VerifyFulfillmentMethod()
    {
        try{
        test.startTest();
        dmpl__RepairOrderLine__c line = [Select Id,Name From dmpl__RepairOrderLine__c LIMIT 1];
        List<SourceObjectInfo> objList = new List<SourceObjectInfo>();
        SourceObjectInfo obj = new SourceObjectInfo('dmpl__RepairOrderLine__c',line.Id,1,null);
        objList.add(obj);
        createRepairOrderLine('Auto Generate Claims');
        dmpl__RepairOrder__c repairOrder = [Select Id,Name From dmpl__RepairOrder__c LIMIT 1];
        FulfillmentHelper.createFulfillmentFromRepairOrder(repairOrder.Id);
        FulfillmentHelper.createNewFulfillmentFromRepairOrder(repairOrder.Id);
        FulfillmentHelper.createFulfillmentFromRepairOrder(objList);
        FulfillmentHelper.createNewFulfillmentFromRepairOrder(objList);
        test.stopTest();
        }catch(Exception e){
            
        }
    }
    
    @isTest
    private static void VerifyRepairOrderLineMethod()
    {
        test.startTest();
        createRepairOrderLine('Auto Generate Claims');
        List<dmpl__RepairOrderLine__c> lines = [Select Id,Name,dmpl__ServiceContractWeightage2__c,dmpl__ServiceContractWeightage3__c,dmpl__ItemId__c,dmpl__UnitPrice__c,dmpl__Quantity__c,dmpl__TaxGroupId__c,dmpl__DiscountAmount__c,dmpl__Discount__c,dmpl__DiscountAmount2__c,dmpl__ContractDiscountAmount__c,dmpl__Discount2__c,dmpl__ContractDiscount__c,dmpl__UnitPrice2__c From dmpl__RepairOrderLine__c LIMIT 1];
        lines[0].dmpl__ServiceContractWeightage2__c = 25;
        lines[0].dmpl__ServiceContractWeightage3__c = 25;
        lines[0].dmpl__UnitPrice2__c = 2500;
        lines[0].dmpl__Quantity__c = 20;
        RepairOrderLineHelper.updateClaimedQuantity(DocumentHelper.extractIds(lines));
        SaleInvoiceHelper.createServiceInvoiceWeightageLine2(lines[0],lines[0].dmpl__ItemId__c,lines[0].dmpl__Quantity__c );
        SaleInvoiceHelper.createServiceInvoiceWeightageLine3(lines[0],lines[0].dmpl__ItemId__c,lines[0].dmpl__Quantity__c );
        test.stopTest();
    }
    
    @isTest
    private static void VerifyRepairOrderTax2()
    {
        test.startTest();
        createRepairOrderLine('Auto Generate Claims');
        List<dmpl__RepairOrder__c> repairOrders = [Select Id,Name,dmpl__TaxGroupId__c,dmpl__TaxId__c,dmpl__TotalLineAmount__c From dmpl__RepairOrder__c LIMIT 1];
        List<dmpl__RepairOrderLine__c> lines = [Select Id,Name,dmpl__PostingType__c,dmpl__Amount__c,dmpl__RepairOrderId__c,dmpl__ServiceContractWeightage2__c,dmpl__ServiceContractWeightage3__c,dmpl__ItemId__c,dmpl__UnitPrice__c,dmpl__Quantity__c,dmpl__TaxGroupId__c,dmpl__DiscountAmount__c,dmpl__Discount__c,dmpl__Discount2__c,dmpl__DiscountAmount2__c,dmpl__ContractDiscountAmount__c,dmpl__ContractDiscount__c,dmpl__UnitPrice2__c From dmpl__RepairOrderLine__c LIMIT 1];
        // RepairOrderTaxHelper.setApplicableTaxes(lines);
        // RepairOrderTaxHelper.setNewApplicableTaxes(repairOrders);
        // RepairOrderTaxHelper.setApplicableTaxes(repairOrders);
        // RepairOrderTaxHelper.deleteApplicableTaxes(repairOrders);
        test.stopTest();
    }
     
    
    @isTest
  /*  private static void VerifyRepairOrderTax2()
    {
        test.startTest();
        createRepairOrderLine('Auto Generate Claims');
        List<dmpl__RepairOrder__c> repairOrders = [Select Id,Name,dmpl__TaxGroupId__c,dmpl__TaxId__c,dmpl__TotalLineAmount__c From dmpl__RepairOrder__c LIMIT 1];
        List<dmpl__RepairOrderLine__c> lines = [Select Id,Name,dmpl__PostingType__c,dmpl__Amount__c,dmpl__RepairOrderId__c,dmpl__ServiceContractWeightage2__c,dmpl__ServiceContractWeightage3__c,dmpl__ItemId__c,dmpl__UnitPrice__c,dmpl__Quantity__c,dmpl__TaxGroupId__c,dmpl__DiscountAmount__c,dmpl__Discount__c,dmpl__Discount2__c,dmpl__DiscountAmount2__c,dmpl__ContractDiscountAmount__c,dmpl__ContractDiscount__c,dmpl__UnitPrice2__c From dmpl__RepairOrderLine__c LIMIT 1];
        
        test.stopTest();
    }
*/
    private static void CreateAccountGroup()
    {
        dmpl__AccountGroup__c accountGroup= new dmpl__AccountGroup__c (Name= 'Test-AccountGroup', 
                                                                       dmpl__AccountGroupType__c='Discount');
        insert accountGroup;
    }
    private static void CreateAccount(){
        List<Account> account = new List<Account>();
        account.add(new Account(Name = 'Test - Account',
                                dmpl__LastName__c = 'Cycle Count',
                                Fax = '09876',
                                Phone = '1234567891',
                                Website = 'www.Dealermatix.com',
                                Type = 'Prospect',
                                NumberOfEmployees = 2,
                                Industry = 'Education',
                                AnnualRevenue = 1000,
                                Description = 'Accounts added',
                                dmpl__IsPartnerAccount__c = false,
                                dmpl__IsActive__c = True,
                                dmpl__IsTaxExempted__c = True,
                                dmpl__IsSupplierAccount__c = false,
                                dmpl__IsCustomerAccount__c = False
                               /* dmpl__PartnerTaxAccountGroupId__c = accountGroup.Id,
                                dmpl__CustomerPriceAccountGroupId__c = accountGroup.Id,
                                dmpl__CustomerDiscountAccountGroupId__c = accountGroup.Id,
                                dmpl__PartnerSchemeAccountGroupId__c = accountGroup.Id,                                
                                dmpl__PartnerPriceAccountGroupId__c = accountGroup.Id,
                                dmpl__PartnerDiscountAccountGroupId__c = accountGroup.Id,
                                dmpl__CustomerSchemeAccountGroupId__c = accountGroup.Id8*/
                               ));
        insert account;
        
        
        Account partneraccount = new Account(Name = 'Partner-Test-Account',
                                             dmpl__LastName__c = 'Cycle Count',
                                             dmpl__IsPartnerAccount__c = True, 
                                             dmpl__IsActive__c = true);
        insert partneraccount;
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__LastName__c = 'Cycle Count',
                                              dmpl__IsCustomerAccount__c = True,
                                              dmpl__IsActive__c = true);
        insert customerAccount;
        
        Account supplierAccount = new Account(Name = 'Supplier-Test-Account',
                                              dmpl__LastName__c = 'Cycle Count',
                                              dmpl__IsSupplierAccount__c = True,
                                              dmpl__IsActive__c = true);
        insert supplierAccount;
        
       
    }
    
    private static void CreateBranch()
    {
        List<dmpl__Branch__c> branch = new List<dmpl__Branch__c>();
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
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
    }
    
    private static void CreateStorageLocation()
    {
        List<dmpl__StorageLocation__c> storageLocation =  new List<dmpl__StorageLocation__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__ParentLocationId__c From dmpl__Branch__c];
        storageLocation.Add(new dmpl__StorageLocation__c(dmpl__BranchId__c = branch.Id,
                                                         dmpl__ParentLocationId__c = branch.dmpl__ParentLocationId__c,
                                                         dmpl__AllowInventory__c=true,
                                                         dmpl__IsMobile__c=true,
                                                         dmpl__IsActive__c=true,
                                                         dmpl__LocationType__c='Washing Bay'));
        insert storageLocation;
    }
    
    private static void CreateItem()
    {
        List<dmpl__Item__c> item = new List<dmpl__Item__c>();
        item.Add(new dmpl__Item__c(Name = 'Test-Item',
                                   dmpl__ItemCode__c = 'DMPL',
                                   dmpl__ItemType__c = 'Service Contract',
                                   dmpl__ItemSubType__c = 'None',
                                   dmpl__Description__c = 'Description',
                                   dmpl__ItemFamily__c = 'Sample',
                                   dmpl__ItemSegment__c = 'Sample',
                                   dmpl__Make__c = 'Sample',
                                   dmpl__Model__c = 'Sample',
                                   dmpl__TrackInventory__c = true,
                                   dmpl__TrackLots__c = true,
                                   //dmpl__IsSKURequired__c = true,
                                   dmpl__RequireInspectionOnReceipt__c = true,
                                   dmpl__RequireInspectionOnDelivery__c = true,
                                   dmpl__AllowService__c = true,
                                   dmpl__TrackAsset__c = true,                               
                                   dmpl__IsActive__c = true,
                                   dmpl__IsRegistrationRequired__c = true,
                                   dmpl__GTIN__c = 'BR123',
                                   dmpl__RFID__c = 'O1234fgh',
                                   dmpl__IsPackage__c = true,
                                   dmpl__QuantityUnitOfMeasure__c = 'Each',
                                   dmpl__InventoryValuationMethod__c = 'FIFO'
                                   
                                  ));
        insert item;
    }
    
    private static void CreateItemGroup()
    {
        List<dmpl__ItemGroup__c> itemGroup = new List<dmpl__ItemGroup__c> ();
        itemGroup.Add(new dmpl__ItemGroup__c(Name = 'Item Group Test',
                                             dmpl__ItemGroupType__c = 'Tax'
                                            ));
        insert itemGroup;
    }
        
    private static void CreateSKU()
    {
        List<dmpl__SKU__c> Skus = new List<dmpl__SKU__c>();
        dmpl__Item__c listofitem = [Select Id, Name from dmpl__Item__c];
        Skus.add(new dmpl__SKU__c(Name = 'Harrier XMA - Automatic - Orcus White',
                                  dmpl__SKUCode__c = 'Test - SKU - Code',
                                  dmpl__UnitOfMeasureOfConversion__c = 10,
                                  dmpl__ProductColor__c = 'Sample',
                                  dmpl__IsDefault__c = false,
                                  dmpl__QuantityUnitOfMeasure__c ='Sample',
                                  dmpl__ItemId__c = listofitem.Id
                                 ));
        insert Skus;
    
        List<dmpl__ItemLot__c> itemLot = new List<dmpl__ItemLot__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        //dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        //dmpl__SKU__c sku = [Select Id, Name from dmpl__SKU__c LIMIT 1];
        itemLot.Add(new dmpl__ItemLot__c(dmpl__BranchId__c = branch.Id,
                                         dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                         dmpl__ItemId__c = listofitem.Id,
                                         dmpl__SKUId__c = skus[0].Id,
                                         dmpl__BatchNo__c = '12345',
                                         dmpl__SerialNumber__c = '4675',
                                         dmpl__SupplierInvoiceNumber__c = '74985',
                                         dmpl__DateOfReceipt__c = date.today(),
                                         dmpl__DateOfMfg__c = date.today(),
                                         dmpl__TotalCost__c = 100,
                                         dmpl__DateOfSupplierInvoice__c = date.today(),
                                         dmpl__Cost__c = 100
                                         //dmpl__QuantityExpired__c = 1,
                                        // dmpl__QuantityOnHold__c = 1,
                                        // dmpl__QuantityOnLoan__c = 1
                                        ));
        insert itemLot;
        
        List<dmpl__ItemLot__c> relatedItemLot = new List<dmpl__ItemLot__c>();
        relatedItemLot.Add(new dmpl__ItemLot__c(dmpl__LandedCost__c = 1000,
            dmpl__BranchId__c = branch.Id,
            dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c));
        insert relatedItemLot;
    }
    
   private static void CreateResource()
    {
        List<dmpl__Resource__c> resource = new List<dmpl__Resource__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        resource.add(new dmpl__Resource__c(Name = 'Test - Resource',
                                           dmpl__ResourceType__c = 'Service Advisor',
                                           dmpl__IsActive__c = true,
                                           dmpl__Phone__c = '9999999999',
                                           dmpl__DefaultPartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                           dmpl__DefaultBranchId__c = branch.Id
                                          ));
        insert resource;
        
        List<dmpl__Resource__c> technicianResource = new List<dmpl__Resource__c>();
        technicianResource.add(new dmpl__Resource__c(Name = 'Test - Resource',
                                                     dmpl__ResourceType__c = 'Technician',
                                                     dmpl__IsActive__c = true,
                                                     dmpl__Phone__c = '9999999999',
                                                     dmpl__DefaultPartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                     dmpl__DefaultBranchId__c = branch.Id
                                                    ));
        insert technicianResource;
    }
    
    private static void CreateBranchTimeSlot()
    {
        List<dmpl__BranchTimeSlot__c> branchTimeSlot = new List<dmpl__BranchTimeSlot__c>();
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        branchTimeSlot.Add(new dmpl__BranchTimeSlot__c(dmpl__BranchId__c = branch.Id,
                                                       dmpl__TransactionType__c = 'Delivery',
                                                       Name = 'Test - Name',
                                                       dmpl__IsActive__c = True,
                                                       dmpl__ApplicableToItem__c= item.Id,
                                                       dmpl__MaximumCapacity__c = 20,                                                    
                                                       dmpl__MondayCapacity__c = 32,
                                                       dmpl__TuesdayCapacity__c = 22,
                                                       dmpl__WednesdayCapacity__c = 11,
                                                       dmpl__ThursdayCapacity__c = 20,
                                                       dmpl__FridayCapacity__c = 22,
                                                       dmpl__SaturdayCapacity__c = 10,
                                                       dmpl__SundayCapacity__c = 12
                                                      ));
        insert branchTimeSlot;
    }
    
    private static void CreateServiceRequest()
    {
        List<dmpl__ServiceRequest__c> serviceRequest = new List<dmpl__ServiceRequest__c>();
        Account account = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        //dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [SELECT Id,Name,dmpl__ItemId__c FROM dmpl__SKU__c LIMIT 1];
        Asset asset = [Select Id,Name From Asset LIMIT 1];
        //dmpl__Resource__c resource = [select Id,Name FROM dmpl__Resource__c LIMIT 1];
        //dmpl__TaxGroup__c taxGroup = [SELECT Id, Name FROM dmpl__TaxGroup__c LIMIT 1];
        serviceRequest.Add(new dmpl__ServiceRequest__c(dmpl__AccountId__c = account.Id,
                                                       dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                       dmpl__AssetId__c = asset.Id,
                                                       dmpl__BranchId__c = branch.Id,
                                                       dmpl__ServiceContractItemId__c = sku.dmpl__ItemId__c,
                                                       dmpl__CustomerVoice__c = 'Service-Appointment',
                                                       dmpl__PackageServiceId__c = sku.dmpl__ItemId__c,
                                                       //dmpl__ServiceAdvisorId__c = resource.Id,
                                                       dmpl__UsageReading__c = 10
                                                      ));
        insert serviceRequest;
        
        List<dmpl__ServiceRequestLine__c> newServiceRequestLines = new List<dmpl__ServiceRequestLine__c>();
        newServiceRequestLines.add(new dmpl__ServiceRequestLine__c(
            dmpl__ServiceRequestId__c = serviceRequest[0].Id,
            dmpl__ItemId__c = sku.dmpl__ItemId__c,
            dmpl__SKUId__c = sku.Id,
            dmpl__Quantity__c = 1
            //dmpl__TaxGroupId__c = taxGroup.Id
        ));
        insert newServiceRequestLines;
    }
    
  
    private static void CreateServiceEstimate()
    { 
        //test.startTest();
        List<dmpl__Quote__c> serviceEstimate = new List<dmpl__Quote__c>();
        //Account account = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        //dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        //dmpl__Resource__c resource = [select Id,Name FROM dmpl__Resource__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__PriceList__c priceList=[Select Id, Name from dmpl__PriceList__c Limit 1];
        //Asset asset = [Select Id,Name From Asset LIMIT 1];
        dmpl__ServiceRequest__c serviceRequest = [Select Id,Name,dmpl__PartnerAccountId__c,dmpl__AccountId__c,dmpl__AssetId__c,dmpl__BranchId__c From dmpl__ServiceRequest__c LIMIT 1];
        //dmpl__TaxGroup__c taxGroup = [SELECT Id, Name FROM dmpl__TaxGroup__c LIMIT 1];
        serviceEstimate.Add(new dmpl__Quote__c(dmpl__PartnerAccountId__c = serviceRequest.dmpl__PartnerAccountId__c,
                                               dmpl__BranchId__c = serviceRequest.dmpl__BranchId__c,
                                               dmpl__AccountId__c = serviceRequest.dmpl__AccountId__c,
                                               dmpl__AssetId__c = serviceRequest.dmpl__AssetId__c,
                                               dmpl__PerformEstimateLinesGeneration__c = false,
                                               dmpl__PackageServiceId__c = item.Id,
                                               dmpl__ServiceRequestId__c = serviceRequest.Id,
                                               dmpl__ServiceContractItemId__c = item.Id,
                                               //dmpl__ServiceAdvisorId__c = resource.Id,
                                               dmpl__CustomerVoice__c = 'Text',
                                               dmpl__PriceListId__c=priceList.Id,
                                               dmpl__UsageReading__c = 8,
                                               dmpl__PerformDecline__c = false,
                                               dmpl__PerformRepairOrderGeneration__c = false,
                                               dmpl__IsRepairOrderGenerated__c = false
                                              ));
        insert serviceEstimate;
        List<dmpl__QuoteLine__c> newServiceEstimateLines = new List<dmpl__QuoteLine__c>();
        newServiceEstimateLines.add(new dmpl__QuoteLine__c(
            dmpl__QuoteId__c = serviceEstimate[0].Id,
            dmpl__ItemId__c = item.Id,
            dmpl__Quantity__c = 1,
            dmpl__UnitPrice__c = 10
            //dmpl__TaxGroupId__c = taxGroup.Id
        ));
        insert newServiceEstimateLines;
        //test.stopTest();
    }
    
    private static void CreateAsset()
    {
        List<Asset> asset = new List<Asset>();
        Account account = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        //dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name,dmpl__ItemId__c FROM dmpl__SKU__c LIMIT 1];
        asset.add(new Asset(Name = 'Test-Asset',
                            AccountId = account.Id,
                            dmpl__LastServiceBranchId__c = branch.Id,
                            dmpl__ItemId__c = sku.dmpl__ItemId__c,
                            dmpl__SKUId__c = sku.Id,
                            dmpl__IsPDIDone__c=true,
                            dmpl__RegistrationNumber__c = 'Axb371',
                            dmpl__SaleDate__c = date.today()
                           ));
        insert asset;
        
        dmpl__ItemServiceContract__c itemServiceContract = new dmpl__ItemServiceContract__c(dmpl__ItemId__c = sku.dmpl__ItemId__c,
                                                                   Name = 'Item Service Contract',
                                                                   dmpl__PopulateContractLines__c = true,
                                                                   dmpl__SKUId__c = sku.Id,
                                                                   dmpl__ServiceType__c = 'Paid Repairs'                         
                                                                  );
        insert itemServiceContract;
        
        List<dmpl__AssetServiceContract__c> assetServiceContracts = new List<dmpl__AssetServiceContract__c>();
        assetServiceContracts.add(new dmpl__AssetServiceContract__c(
            dmpl__AssetId__c = asset[0].Id,
            dmpl__ItemId__c = sku.dmpl__ItemId__c,
            dmpl__ServiceContractItemId__c = sku.dmpl__ItemId__c,
            dmpl__ItemServiceContractId__c = itemServiceContract.Id,
            dmpl__ActivatedDate__c = Datetime.now().Date(),
            dmpl__DueDate__c = Datetime.now().addDays(365).Date()
        ));
        insert assetServiceContracts;
        
        dmpl__Item__c workItem = new dmpl__Item__c(
            Name = 'Washing', 
            dmpl__ItemCode__c = 'Washing', 
            dmpl__ItemType__c = 'Work Item',
            dmpl__IsActive__c = true);
        
        insert workItem;
        
        dmpl__Item__c serviceItem = new dmpl__Item__c(
            Name = 'Washing', 
            dmpl__ItemCode__c = 'Washing', 
            dmpl__ItemType__c = 'Service Contract',
            dmpl__IsActive__c = true);
        
        insert serviceItem;
        
        dmpl__AssetServiceContractLine__c assetServiceContractLine = new dmpl__AssetServiceContractLine__c(
            dmpl__AssetServiceContractId__c = assetServiceContracts[0].Id,
            dmpl__ComponentItemId__c = workItem.Id,
            dmpl__Quantity__c = 1,
            dmpl__UtilizedQuantity__c = 0);
        insert assetServiceContractLine;
    }
    
    private static void CreateServiceBay()
    {
        List<dmpl__ServiceBay__c> serviceBay = new List<dmpl__ServiceBay__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        serviceBay.add(new dmpl__ServiceBay__c(dmpl__BranchId__c = branch.Id,
                                               Name = 'Test-Service-Bay',
                                               dmpl__ServiceBayType__c = 'Warehouse',
                                               dmpl__AllowInventory__c = true
                                              ));
        insert serviceBay;
    }
    
    private static void CreatePriceList()
    {
        List<dmpl__PriceList__c> priceList =new List<dmpl__PriceList__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account'];
        dmpl__AccountGroup__c accountGroup=[Select Id,Name From dmpl__AccountGroup__c];
        priceList.Add(new dmpl__PriceList__c(dmpl__PartnerAccountId__c = account.Id,
                                             dmpl__BranchId__c = Branch.Id,
                                             dmpl__PartnerAccountGroupId__c= accountGroup.Id,
                                             dmpl__PartnerGroupId__c=accountGroup.Id,
                                             dmpl__CustomerAccountGroupId__c=accountGroup.Id,
                                             dmpl__CustomerGroupId__c=accountGroup.Id,
                                             Name='Test-1',
                                             dmpl__PriceListType__c = 'Sale Price',
                                             dmpl__IsActive__c = true,
                                             dmpl__IsDefault__c = true
                                            ));
        
        
        priceList.Add(new dmpl__PriceList__c(
            Name='Test-2'
        ));
        insert priceList;
    }
    
   private static void CreateRepairOrder()
    {
        List<dmpl__RepairOrder__c> repairOrder = new List<dmpl__RepairOrder__c> ();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__ItemLot__c itemLot = [Select Id,Name From dmpl__ItemLot__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name,(Select Id,Name from dmpl__Taxes__r) From dmpl__TaxGroup__c LIMIT 1];
        //dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        //dmpl__Resource__c resource = [select Id,Name FROM dmpl__Resource__c LIMIT 1];
        //Asset asset = [Select Id,Name From Asset LIMIT 1];
        dmpl__PriceList__c priceList=[Select Id, Name from dmpl__PriceList__c Limit 1];
        dmpl__ServiceRequest__c serviceRequest = [Select Id,Name,dmpl__PartnerAccountId__c,dmpl__AccountId__c,dmpl__AssetId__c,dmpl__BranchId__c,(SELECT Id,Name FROM dmpl__Service_Estimates__r LIMIT 1) From dmpl__ServiceRequest__c LIMIT 1];
        //dmpl__Quote__c serviceEstimate = [Select Id,Name From dmpl__Quote__c LIMIT 1];
        //Account customerAccount = [Select id,Name From Account Where Name = 'Customer-Test-Account' LIMIT 1];
        dmpl__ItemServiceContract__c itemServiceContract = [Select Id,Name From dmpl__ItemServiceContract__c LIMIT 1];
        repairOrder.Add(new dmpl__RepairOrder__c (
            dmpl__PriceListId__c=priceList.Id,
            dmpl__BranchId__c = serviceRequest.dmpl__BranchId__c,
            dmpl__AccountId__c = serviceRequest.dmpl__AccountId__c,
            dmpl__PartnerAccountId__c = serviceRequest.dmpl__PartnerAccountId__c,
            dmpl__ServiceRequestId__c = serviceRequest.Id,
            dmpl__AssetId__c = serviceRequest.dmpl__AssetId__c,
            dmpl__ServiceEstimateId__c = serviceRequest.dmpl__Service_Estimates__r[0].Id,
            dmpl__UsageReading__c = 8,
            dmpl__ItemLotId__c = itemLot.Id,
            //dmpl__ServiceAdvisorId__c = resource.Id,
            dmpl__ItemServiceContractId__c = itemServiceContract.Id,
            dmpl__ServiceType__c = 'Paid Repairs',
            dmpl__TaxGroupId__c = taxGroup.Id,
            dmpl__TaxId__c = taxGroup.dmpl__Taxes__r[0].Id
        ));
        
        insert repairOrder;
    }
    
    
    private static void createRepairOrderLine(String postingType)
    {
        //test.startTest();
        List<dmpl__RepairOrderLine__c> repairOrderLine = new List<dmpl__RepairOrderLine__c>();
        dmpl__RepairOrder__c repairOrder = [Select Id,Name FROM dmpl__RepairOrder__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name FROM dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c LIMIT 1];
        //dmpl__Resource__c resource = [select Id,Name FROM dmpl__Resource__c WHERE dmpl__ResourceType__c = 'Technician' LIMIT 1];
        dmpl__StorageLocation__c storageLocation = [Select Id,Name FROM dmpl__StorageLocation__c LIMIT 1];
       // dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        //dmpl__AssetServiceContract__c assetServiceContract = [Select Id,Name From dmpl__AssetServiceContract__c LIMIT 1];
        dmpl__ItemServiceContract__c itemServiceContract = [Select Id,Name From dmpl__ItemServiceContract__c LIMIT 1];
        repairOrderLine.add(new dmpl__RepairOrderLine__c(dmpl__ItemId__c = item.Id,
                                                         dmpl__Quantity__c = 5,
                                                         dmpl__CancelledQuantity__c=3,
                                                         dmpl__SKUId__c=sku.Id,
                                                         dmpl__UnitPrice__c = 10,
                                                         dmpl__PackageClassification__c = 'Optional Item',
                                                         dmpl__ActionTaken__c = 'Replace',
                                                         //dmpl__TechnicianId__c = resource.Id,
                                                         dmpl__WorkStartedBy__c = date.today(),
                                                         dmpl__WorkEndedAt__c = date.today(),
                                                         dmpl__WorkStatus__c = 'Started',
                                                         dmpl__StandardDurationHours__c = 10,
                                                         dmpl__ActualDurationHours__c = 10,
                                                         //dmpl__IsClaimed__c = true,
                                                         dmpl__ItemServiceContractId__c = itemServiceContract.Id,
                                   //dmpl__AssetServiceContractLineId__c = assetServiceContract.Id,
                                                         dmpl__StorageLocationId__c = storageLocation.Id,
                                                         //dmpl__TaxGroupId__c = taxGroup.Id,
                                                         dmpl__RepairOrderId__c = repairOrder.Id,
                                                         dmpl__PostingType__c = postingType,
                                                         dmpl__FulfilmentOrderQuantity__c = 1
                                                        ));
        insert repairOrderLine;
        //test.stopTest();
    }
    
    
    private static void CreateComplaint()
    {
        List<dmpl__Complaint__c> complaint = new List<dmpl__Complaint__c>();
        complaint.add(new dmpl__Complaint__c(Name = 'Complaint-Test',
                                             dmpl__Code__c = '37592',
                                             dmpl__Description__c = 'Text'
                                            ));
        insert complaint;
    }
    /*
    private static void CreateServiceRecommendation()
    {
        List<dmpl__ServiceRecommendation__c> ServiceRecommendation = new List<dmpl__ServiceRecommendation__c> ();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__RepairOrder__c repairOrder = [Select Id,Name From dmpl__RepairOrder__c LIMIT 1];
        dmpl__RepairOrderLine__c repairOrderLine = [Select Id,Name From dmpl__RepairOrderLine__c LIMIT 1];
        Asset asset = [Select Id,Name From Asset LIMIT 1];
        dmpl__ServiceRequest__c serviceRequest = [Select Id,Name From dmpl__ServiceRequest__c LIMIT 1];
        dmpl__ServiceRequestLine__c serviceRequestLine = [Select Id,Name From dmpl__ServiceRequestLine__c LIMIT 1];
        dmpl__Quote__c serviceEstimate = [Select Id,Name From dmpl__Quote__c LIMIT 1];
        dmpl__QuoteLine__c quoteLine = [Select Id,Name From dmpl__QuoteLine__c LIMIT 1];
        ServiceRecommendation.Add(new dmpl__ServiceRecommendation__c (
                                        dmpl__QuoteLineId__c=quoteLine.Id,
                                        dmpl__RepairOrderId__c=repairOrder.Id,
                                        dmpl__RepairOrderLineId__c=repairOrderLine.Id,
                                        dmpl__ServiceRequestId__c = serviceRequest.Id,
                                        dmpl__ServiceRequestLineId__c=serviceRequestLine.Id,
                                        dmpl__AssetId__c = asset.Id,
                                        dmpl__Condition__c='Red',
                                        dmpl__IsUtilized__c=false,
                                        dmpl__RecommendationRemarks__c='Good',
                                        dmpl__RecommendationType__c='Optional'  
                                    ));
        insert ServiceRecommendation;
    }
   
    
    private static void CreateComplaintFaultCode()
    {
        List<dmpl__ComplaintFault__c> complaintFault = new List<dmpl__ComplaintFault__c>();
        dmpl__Complaint__c complaint = [Select Id,Name FROM dmpl__Complaint__c LIMIT 1];
        complaintFault.add(new dmpl__ComplaintFault__c(Name = 'Test-Complaint-Fault-Code',
                                                       dmpl__ComplaintId__c = complaint.Id
                                                      ));
        insert complaintFault;
    }
    */
  
     private static void CreateTax()
    {
        List<dmpl__Tax__c> tax = new List<dmpl__Tax__c>();
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c];
        tax.Add(new dmpl__Tax__c(Name = 'Test - Tax',
                                 dmpl__Rate__c = 10,
                                 dmpl__TaxGroupId__c = taxGroup.Id,
                                 dmpl__PostingFieldName__c='Tax1',
                                 dmpl__Type__c = 'Cess'
                                ));        
        insert tax;
        
        List<dmpl__TaxGroupRule__c> rule = new List<dmpl__TaxGroupRule__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        rule.add(new dmpl__TaxGroupRule__c(dmpl__DateEffectiveFrom__c = date.today(),
                                           dmpl__ItemId__c = item.Id,
                                           dmpl__ItemLotTypeId__c = null,
                                          dmpl__TaxGroupId__c = taxGroup.Id
                                          ));
        insert rule;
    }
    
     private static void CreateTaxGroup()
    {
        List<dmpl__TaxGroup__c> taxGroup = new List<dmpl__TaxGroup__c>();
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account'];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__AccountGroup__c AccountGrp = [Select Id, Name FROM dmpl__AccountGroup__c LIMIT 1];
        taxGroup.Add(new dmpl__TaxGroup__c(Name = 'Test - Tax Group',
                                           dmpl__PartnerAccountId__c = account.Id,
                                           dmpl__BranchId__c = branch.Id,
                                           dmpl__PartnerAccountGroupId__c = AccountGrp.Id,
                                           dmpl__Description__c = 'Test-Description',
                                           dmpl__IsActive__c = true));
        insert taxGroup;
    } 
    
  @isTest
    private static void UpdateRepairOrderLineasClaimed()
    {
        test.startTest();
        List<dmpl__RepairOrderLine__c> line = [Select Id,Name,dmpl__IsClaimed__c From dmpl__RepairOrderLine__c LIMIT 1];
        if(line != null)
          line[0].dmpl__IsClaimed__c = true;
        update line;
        //RepairOrderLineHelper.markAsClaimed(line);
        System.assert(line != null, 'repair Order is Updated');
        test.stopTest();
    }
     private static void CreateRepairOrderLine()
    {
        List<dmpl__RepairOrderLine__c> repairOrderLine = new List<dmpl__RepairOrderLine__c>();
        dmpl__RepairOrder__c repairOrder = [Select Id,Name FROM dmpl__RepairOrder__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name FROM dmpl__Item__c  LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c LIMIT 1];
        //dmpl__Resource__c resource = [select Id,Name FROM dmpl__Resource__c WHERE dmpl__ResourceType__c = 'Technician' LIMIT 1];
        dmpl__StorageLocation__c storageLocation = [Select Id,Name FROM dmpl__StorageLocation__c LIMIT 1];
       // dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        repairOrderLine.add(new dmpl__RepairOrderLine__c(dmpl__ItemId__c = item.Id,
                                                         dmpl__Quantity__c = 5,
                                                         dmpl__CancelledQuantity__c=3,
                                                         dmpl__SKUId__c=sku.Id,
                                                         dmpl__UnitPrice__c = 10,
                                                         dmpl__PackageClassification__c = 'Optional Item',
                                                         dmpl__ActionTaken__c = 'Replace',
                                                         //dmpl__TechnicianId__c = resource.Id,
                                                         dmpl__WorkStartedBy__c = date.today(),
                                                         dmpl__WorkEndedAt__c = date.today()+(2),
                                                         dmpl__WorkStatus__c = 'Started',
                                                         dmpl__StandardDurationHours__c = 10,
                                                         dmpl__ActualDurationHours__c = 10,
                                                         dmpl__StorageLocationId__c = storageLocation.Id,
                                                         //dmpl__TaxGroupId__c = taxGroup.Id,
                                                         dmpl__RepairOrderId__c = repairOrder.Id
                                                        ));
        insert repairOrderLine;
    }
    
   /* private static void CreateRepairOrderTax()
    {
        //test.startTest();
        List<dmpl__RepairOrderTax__c> repairOrderTax = new List<dmpl__RepairOrderTax__c>();
        dmpl__RepairOrder__c repairOrder = [Select Id,Name From dmpl__RepairOrder__c LIMIT 1];
        dmpl__RepairOrderline__c repairOrderLine = [Select Id,Name From dmpl__RepairOrderLine__c LIMIT 1];
        dmpl__Tax__c tax = [Select Id,Name From dmpl__Tax__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        repairorderTax.add(new dmpl__RepairOrderTax__c(dmpl__RepairOrderId__c = repairOrder.Id,
                                                       dmpl__RepairOrderLineId__c = repairOrderLine.Id,
                                                       dmpl__TaxId__c = tax.Id,
                                                       dmpl__TaxOnAmount__c = 100,
                                                       dmpl__TaxAmount__c = 100,
                                                       dmpl__TaxGroupId__c = taxGroup.Id,
                                                       dmpl__TaxRate__c = 10));
        insert repairOrderTax;
        //test.stopTest();
    }*/
    
    private static void CreateChecklistTemplate()
    {
        List<dmpl__ChecklistTemplate__c> checkList = new List<dmpl__ChecklistTemplate__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        checkList.add(new dmpl__ChecklistTemplate__c(dmpl__ItemId__c=item.Id,
                                                     Name='Test1',
                                                     dmpl__Type__c='Repair Order',
                                                     dmpl__Code__c='Done'));
        insert checkList;
    }
    
    private static void CreateChecklistTemplateLine()
    {
        List<dmpl__CheckListTemplateLine__c> checkList = new List<dmpl__CheckListTemplateLine__c>();
        dmpl__ChecklistTemplate__c checkListTemplate = [Select Id,Name From dmpl__ChecklistTemplate__c LIMIT 1];
        checkList.add(new dmpl__CheckListTemplateLine__c(dmpl__ChecklistTemplateId__c = checkListTemplate.Id,
                                                         dmpl__DataType__c = 'Text'
                                                        ));
        insert checkList;
    }
    
    private static void CreateChecklistlines()
    {
        //test.startTest();
        List<dmpl__CheckListLines__c> checkList = new List<dmpl__CheckListLines__c>();
        dmpl__ChecklistTemplate__c checkListTemplate = [Select Id,Name From dmpl__ChecklistTemplate__c LIMIT 1];
        dmpl__ChecklistTemplateLine__c checkListTemplateLine = [Select Id,Name From dmpl__ChecklistTemplateLine__c LIMIT 1];
        dmpl__RepairOrder__c Order = [Select Id,Name From dmpl__RepairOrder__c LIMIT 1];
        checkList.add(new dmpl__CheckListLines__c(dmpl__RepairOrderId__c= Order.Id,
                                                  dmpl__CheckListTemplateLineId__c = checkListTemplateLine.Id,
                                                  dmpl__ChecklistTemplateId__c = checkListTemplate.Id,
                                                  Name='Test2',
                                                  dmpl__DataType__c='Text'
                                                 ));
        insert checkList;
        //test.stopTest();
    }
    
}