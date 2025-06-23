@isTest
public class ServiceCampaignMantenanceSchedularH_Test {

    @TestSetup
    static void makeData(){
        dmpl__AccountGroup__c accountGroup=TestDataHelpers.createAccountGroup();
        Account account=TestDataHelpers.createAccount(accountGroup);
      // Account supplierAccount = TestDataHelpers.createSupplierAccount();
       Account partnerAccount = TestDataHelpers.createPartnerAccount();
       Account customerAccount=TestDataHelpers.createCustomerAccount();
       dmpl__branch__c branch=TestDataHelpers.createbranch(partnerAccount);
     // dmpl__ContactAddress__c ContactAddress=TestDataHelpers.createContactAddress(customerAccount);
     //  dmpl__StorageLocation__c StorageLocation=TestDataHelpers.createStorageLocation(branch);
     // dmpl__ItemGroup__c ItemGroup=TestDataHelpers.CreateItemGroup();
       dmpl__Item__c item=TestDataHelpers.createItem();
       dmpl__SKU__c sku=TestDataHelpers.createSKU(Item);
       dmpl__ItemMaintenanceSchedule__c ItemMaintenanceSchedule=TestDataHelpers.createItemMaintenanceSchedule(item,sku);
       Resource__c resource=TestDataHelpers.CreateResource(PartnerAccount,branch);
      // dmpl__PriceList__c PriceList=TestDataHelpers.createPriceList(partnerAccount,branch);
     // dmpl__ItemLot__c ItemLot=TestDataHelpers.createItemLot(branch,Item,sku,StorageLocation);
     // Asset asset=AssetDataHelper.createAsset(customerAccount,branch,item,sku,ItemLot);
      dmpl__ServiceLead__c ServiceLead=ServiceLeadTestDataHelpers.createServiceLead(branch,customerAccount,resource);
      dmpl__ItemServiceContract__c ItemServiceContract=TestDataHelpers.createItemServiceContract(item,sku);
      //dmpl__AssetServiceContract__c AssetServiceContract=AssetDataHelper.createAssetServiceContracts(asset,item);
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
    private static void VerifyBatchClass()
    {
        test.startTest();
        dmpl__ServiceCampaign__c serviceCampaign =CampaignTestDataHelpers.getServiceCompaign();
        // dmpl__InterfaceQueue__c interfacequeue =InterfaceQueueTestDataHelpers.getInterfaceQueue();
        // system.debug(serviceCampaign.id+'  '+interfacequeue.id);
        //JobResponseResult result = ServiceCampaignMantenanceSchedular.perfromAction(serviceCampaign.Id,interfacequeue.Id);
        test.stopTest();
    }
}