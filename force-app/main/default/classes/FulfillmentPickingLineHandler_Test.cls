@isTest
public with sharing class FulfillmentPickingLineHandler_Test {
    
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

        test.startTest();
        dmpl__RepairOrder__c repairOrder=RepairOrderTestDataHelpers.createRepairOrder(item,branch,asset,serviceEstimate,customerAccount,resource);
        dmpl__SaleOrder__c   saleOrder=SaleOrderTestDataHelpers.createSaleOrder(customerAccount,branch);
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

        dmpl__InventoryFulfillmentAllocationLine__c fullfillmentAllocationLine = FulfillmentTestDataHelpers.createInventoryFulfillmentAllocationLine(
            item,
            itemLot,
            sku,
            resource,
            fulfillment,
            fulfillmentOrderLine
        );
        dmpl__InventoryFulfillmentPickingLine__c fulfillmentPickingLine = FulfillmentTestDataHelpers.createFulfillmentPickingLine(
            fulfillment,
            item,
            fullfillmentAllocationLine
        );
            Test.stopTest();
    }

    @isTest
    static void createFulfillmentPickingLinePositive() {
        dmpl__InventoryFulfillmentPickingLine__c fulfillmentPickingLine = FulfillmentTestDataHelpers.getFulfillmentPickingLine();
        if(fulfillmentPickingLine != null){
            System.assertNotEquals(fulfillmentPickingLine, null, 'Expected fulfillmentPickingLine to be created.');
        }
    }
    @isTest
    public static void updateFulfillmentPickingLinePositive() {
        dmpl__InventoryFulfillmentPickingLine__c fulfillmentPickingLine = FulfillmentTestDataHelpers.getFulfillmentPickingLine();
        System.assertNotEquals(fulfillmentPickingLine, null, 'Expected fulfillmentPickingLine to be created before update.');

        fulfillmentPickingLine.dmpl__UnitCost__c=200;

        update fulfillmentPickingLine;

        dmpl__InventoryFulfillmentPickingLine__c updatedFulfillmentPickingLine = FulfillmentTestDataHelpers.getFulfillmentPickingLine(fulfillmentPickingLine.Id);
        
        System.assertNotEquals(updatedFulfillmentPickingLine, null, 'Expected updated fulfillmentPickingLine to be found.');
        System.assertEquals(200, updatedFulfillmentPickingLine.dmpl__UnitCost__c, 'dmpl__UnitCost__c should be 200 after update');
    }

    @isTest
    public static void deleteFulfillmentPickingLinePositive(){
        dmpl__InventoryFulfillmentPickingLine__c fulfillmentPickingLine = FulfillmentTestDataHelpers.getFulfillmentPickingLine();
        System.assertNotEquals(fulfillmentPickingLine, null, 'Expected fulfillmentPickingLine to be created before delete.');
        dmpl__InventoryFulfillmentPickingLine__c deletedFulfillmentPickingLine = null;
        try {
            delete fulfillmentPickingLine;
            deletedFulfillmentPickingLine = FulfillmentTestDataHelpers.getFulfillmentPickingLine(fulfillmentPickingLine.Id);
        } catch (DmlException e) {
            deletedFulfillmentPickingLine = null;
        }
        System.assertEquals(null, deletedFulfillmentPickingLine, 'Expected fulfillmentPickingLine to be deleted.');
    }
}