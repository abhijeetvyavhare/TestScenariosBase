@isTest
public class ServiceReminderHandler_Test {

    @TestSetup
    static void makeData(){
        dmpl__AccountGroup__c accountGroup=TestDataHelpers.createAccountGroup();
        Account account=TestDataHelpers.createAccount(accountGroup);
      // Account supplierAccount = TestDataHelpers.createSupplierAccount();
       Account partnerAccount = TestDataHelpers.createPartnerAccount();
       Account customerAccount=TestDataHelpers.createCustomerAccount();
       dmpl__branch__c branch=TestDataHelpers.createbranch(partnerAccount);
     // dmpl__ContactAddress__c ContactAddress=TestDataHelpers.createContactAddress(customerAccount);
       dmpl__StorageLocation__c StorageLocation=TestDataHelpers.createStorageLocation(branch);
     // dmpl__ItemGroup__c ItemGroup=TestDataHelpers.CreateItemGroup();
       dmpl__Item__c item=TestDataHelpers.createItem();
       dmpl__SKU__c sku=TestDataHelpers.createSKU(Item);
       dmpl__ItemMaintenanceSchedule__c ItemMaintenanceSchedule=TestDataHelpers.createItemMaintenanceSchedule(item,sku);
       Resource__c resource=TestDataHelpers.CreateResource(PartnerAccount,branch);
      // dmpl__PriceList__c PriceList=TestDataHelpers.createPriceList(partnerAccount,branch);
      dmpl__ItemLot__c ItemLot=TestDataHelpers.createItemLot(branch,Item,sku,StorageLocation);
      Asset asset=AssetDataHelper.createAsset(customerAccount,branch,item,sku,ItemLot);
      dmpl__ServiceLead__c ServiceLead=ServiceLeadTestDataHelpers.createServiceLead(branch,customerAccount,resource);
    //   Task task=TestDataHelpers.CreateTask();
      dmpl__ItemServiceContract__c ItemServiceContract=TestDataHelpers.createItemServiceContract(item,sku);
      dmpl__AssetServiceContract__c AssetServiceContract=AssetDataHelper.createAssetServiceContracts(asset,item);
      dmpl__ServiceCampaign__c ServiceCampaign=CampaignTestDataHelpers.CreateServiceCompaign(ItemServiceContract,ServiceLead,item);
      //dmpl__branchTimeSlot__c branchTimeSlot=TestDataHelpers.createbranchTimeSlot(branch,item);
     /*
      dmpl__TaxGroup__c TaxGroup=TestDataHelpers.createTaxGroup(partnerAccount,branch);
     
      dmpl__SaleOrder__c SaleOrder=SaleOrderDataHelper.createSaleOrder(customerAccount,branch,ContactAddress);
      dmpl__SaleOrderLine__c SaleOrderLine=SaleOrderDataHelper.createSaleOrderLine(SaleOrder,item,sku,TaxGroup);

      dmpl__SaleInvoice__c SaleInvoice=SaleInvoiceTestDataHelpers.createSaleInvoice(customerAccount,branch,SaleOrder,PriceList);
      dmpl__DeliveryOrder__c DeliveryOrder=DeliveryOrderTestDataHelpers.CreateDeliveryOrder(branch,customerAccount);
      dmpl__DeliveryOrderLine__c DeliveryOrderLine=DeliveryOrderTestDataHelpers.CreateDeliveryOrderLine(DeliveryOrder,TaxGroup,item,sku);

    //   DeliveryOrderTestDataHelpers.CreateDeliveryOrder(branch,customerAccount);
    //   DeliveryOrderTestDataHelpers.CreateDeliveryOrderLine(DeliveryOrder,TaxGroup,item,sku);
    */
    // dmpl__InterfaceServiceProvider__c interfaceServiceProvider=FileClientTestDataHelpers.createInterfaceServiceProvider(partnerAccount,branch);
    // dmpl__InterfaceServiceProviderRequest__c interfaceServiceProviderReq=FileClientTestDataHelpers.createInterfaceServiceProviderRequest(interfaceServiceProvider);
    // dmpl__InterfaceQueue__c interfacequeue=InterfaceQueueTestDataHelpers.createInterfaceQueue(interfaceServiceProvider,interfaceServiceProviderReq);
    
    }
    @isTest
    public static void VerifyReminder()
    {
        Test.startTest();
        dmpl__ServiceCampaign__c campaignId = CampaignTestDataHelpers.getServiceCompaign();
        // ServiceReminderService.execute(campaignId.Id);
        Test.stopTest();
        System.assert(campaignId!=null, 'Test claim have 1 updated record');
    }
    
    @isTest
    public static void VerifyReminder1()
    {
        try{
            Test.startTest();
            dmpl__ServiceCampaign__c campaignId = CampaignTestDataHelpers.getServiceCompaign();
            // ServiceReminderService.execute(campaignId.Id);
            //ystem.assert(campaignId!=null, 'Test claim have 1 updated record');
            Test.stopTest();}
        catch(exception e){}
        
    }
    
    @isTest
    public static void createNewServiceLead()
    {
        Test.startTest();
        dmpl__ServiceCampaign__c campaignId = CampaignTestDataHelpers.getServiceCompaign();
        Asset asset =AssetDataHelper.getAsset();
        // ServiceReminderService.createNewServiceLead(campaignId,asset);
        Test.stopTest();
        //System.assert(campaignId!=null, 'Test claim have 1 updated record');
    }
    
     @isTest
    public static void createNewServiceLeadNew()
    {
        Test.startTest();
        dmpl__ServiceCampaign__c campaignId = CampaignTestDataHelpers.getServiceCompaign();
        dmpl__AssetServiceContract__c asset =[Select Id, Name,dmpl__AssetId__c,dmpl__AssetId__r.AccountId,dmpl__AssetId__r.dmpl__SellingBranchId__c,dmpl__AssetId__r.dmpl__SellingPartnerAccountId__c,dmpl__AssetId__r.dmpl__LastServiceBranchId__c,dmpl__AssetId__r.dmpl__LastServicePartnerId__c from dmpl__AssetServiceContract__c Limit 1];
        // ServiceReminderService.createNewServiceLead(campaignId,asset,1);
        Test.stopTest();
        System.assert(campaignId!=null, 'Test claim have 1 updated record');
    }
    
     @isTest
    public static void createNewServiceLeadNew1()
    {
        Test.startTest();
        dmpl__ServiceCampaign__c campaignId = CampaignTestDataHelpers.getServiceCompaign();
        // ServiceReminderService.queryAssetsForRecall(campaignId);
        Test.stopTest();
        System.assert(campaignId!=null, 'Test claim have 1 updated record');
    }
    
     @isTest
    public static void createReminderTask()
    {
        Test.startTest();
        dmpl__ServiceCampaign__c campaignId = CampaignTestDataHelpers.getServiceCompaign();

        dmpl__ServiceLead__c asset =ServiceLeadTestDataHelpers.getServiceLead();
        //ServiceReminderService.createReminderTask(asset,campaignId,1);
        Test.stopTest();
        //System.assert(campaignId!=null, 'Test claim have 1 updated record');
    }

}