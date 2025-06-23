@isTest
public with sharing class FulfillmentOrderLineHandler_Test {
    @TestSetup
    static void createRequiredData(){
        dmpl__AccountGroup__c accountGroup=TestDataHelpers.createAccountGroup();
        Account account=TestDataHelpers.createAccount(accountGroup);
        Account customerAccount=TestDataHelpers.createCustomerAccount();
        Account partnerAccount=TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch=TestDataHelpers.createBranch(partnerAccount);
        dmpl__Resource__c resource=TestDataHelpers.createResource(partnerAccount,branch);
        dmpl__Item__c item=TestDataHelpers.createItem();
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation(branch);
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup(partnerAccount, branch);
        dmpl__ItemLot__c itemLot = TestDataHelpers.createItemLot(branch,item,sku,storageLocation);
        Asset asset=AssetTestDataHelpers.CreateAsset(account, branch, item, itemLot, sku);
        dmpl__PriceList__c priceList=TestDataHelpers.createPriceList(partnerAccount,branch);
        dmpl__BranchTimeSlot__c brTimeSlot=TestDataHelpers.createBranchTimeSlot(branch,item);
        dmpl__ServiceRequest__c serviceRequest=ServiceRequestTestDataHelpers.createServiceRequest(customerAccount,branch,item,asset,brTimeSlot);
        dmpl__Quote__c  serviceEstimate=QuoteTestDataHelpers.CreateServiceEstimate(branch,customerAccount,priceList,asset,serviceRequest,item);
        dmpl__RepairOrder__c repairOrder=RepairOrderTestDataHelpers.createRepairOrder(item,branch,asset,serviceEstimate,customerAccount,resource);
        dmpl__SaleOrder__c   saleOrder=SaleOrderTestDataHelpers.createSaleOrder(customerAccount,branch);
        dmpl__InterfaceServiceProvider__c interfaceService = InterfaceServiceProviderTestDataHelpers.createInterfaceServiceProvider(partnerAccount,branch);
        dmpl__InterfaceServiceProviderRequest__c interfaceRequest=InterfaceServiceProviderTestDataHelpers.CreateInterfaceServiceProviderRequest(
            interfaceService
        );
        dmpl__InterfaceQueue__c interfaceQueue = InterfaceServiceProviderTestDataHelpers.createInterfaceQueue(interfaceService, interfaceRequest);
        dmpl__InventoryFulfillment__c fulfillment = FulfillmentTestDataHelpers.createInventoryFulfillment(
            partnerAccount,
            customerAccount,
            branch,
            repairOrder,
            saleOrder
        );
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder,
            item,
            sku,
            taxGroup
        );
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = FulfillmentTestDataHelpers.createInventoryFulfillmentOrderLine(
            fulfillment,
            item,
            sku,
            saleOrderLine
        );
    }

    @isTest
    static void createFulfillmentOrderLinePositive() {
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = FulfillmentTestDataHelpers.getInventoryFulfillmentOrderLine();
        if(fulfillmentOrderLine != null){
            System.assertNotEquals(fulfillmentOrderLine, null, 'Expected fulfillmentOrderLine to be created.');
        }
        System.assertNotEquals(fulfillmentOrderLine.dmpl__FulfillmentId__c, null, 'Expected dmpl__FulfillmentId__c to be set.');
        System.assertNotEquals(fulfillmentOrderLine.dmpl__ItemId__c, null, 'Expected dmpl__ItemId__c to be set.');
        System.assertNotEquals(fulfillmentOrderLine.dmpl__SKUId__c, null, 'Expected dmpl__SKUId__c to be set.');
        System.AssertNotEquals(fulfillmentOrderLine.dmpl__SaleOrderLineId__c, null, 'Expected dmpl__SaleOrderLineId__c to be set.');
    }

    @isTest
    static void updateFulfillmentOrderLinePositive() {
        dmpl__InventoryFulfillmentOrderLine__c FulfillmentOrderLine = FulfillmentTestDataHelpers.getInventoryFulfillmentOrderLine();
        if(FulfillmentOrderLine != null){
            System.assertNotEquals(fulfillmentOrderLine, null, 'Expected fulfillmentOrderLine to be created before update.');
            FulfillmentOrderLine.dmpl__IsILPosted__c = false;
            update FulfillmentOrderLine;
        }
        
        dmpl__InventoryFulfillmentOrderLine__c updatedFulfillmentOrderLine=FulfillmentTestDataHelpers.getInventoryFulfillmentOrderLine(FulfillmentOrderLine.Id);
        if(updatedFulfillmentOrderLine != null){
            System.assertNotEquals(updatedFulfillmentOrderLine, null, 'Expected FulfillmentOrderLine to be updated.');
        }
        System.assertEquals(false, updatedFulfillmentOrderLine.dmpl__IsILPosted__c, 'Expected dmpl__IsILPosted__c to be updated to false');
    }

    @isTest
    static void deleteFulfillmentOrderLinePositive() {
        dmpl__InventoryFulfillmentOrderLine__c FulfillmentOrderLine = FulfillmentTestDataHelpers.getInventoryFulfillmentOrderLine();
        System.assertNotEquals(FulfillmentOrderLine, null, 'Expected FulfillmentOrderLine to be created before delete.');
        dmpl__InventoryFulfillmentOrderLine__c deletedFulfillmentOrderLine = null;
        delete fulfillmentOrderLine;
        try {
            deletedFulfillmentOrderLine = FulfillmentTestDataHelpers.getInventoryFulfillmentOrderLine(FulfillmentOrderLine.Id);
        } catch (QueryException e) {
            // Expected exception, as the record should be deleted
            deletedFulfillmentOrderLine = null;
        }
        System.assertEquals(null, deletedFulfillmentOrderLine, 'Expected FulfillmentOrderLine to be deleted.');
    }
}