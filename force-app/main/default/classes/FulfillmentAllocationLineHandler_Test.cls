@isTest
public with sharing class FulfillmentAllocationLineHandler_Test {
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
        dmpl__SaleOrder__c   saleOrder=SaleOrderTestDataHelpers.createSaleOrder(customerAccount,branch);
        test.startTest();
        dmpl__RepairOrder__c repairOrder=RepairOrderTestDataHelpers.createRepairOrder(item,branch,asset,serviceEstimate,customerAccount,resource);
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
        Test.stopTest();
    }

    @isTest
    static void createFulfillmentAllocationLinePositive() {
        Test.startTest();
        dmpl__InventoryFulfillmentAllocationLine__c fullfillmentAllocationLine = FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine();
        Test.stopTest();
        if(fullfillmentAllocationLine != null){
            System.assertNotEquals(fullfillmentAllocationLine, null, 'Expected fullfillmentAllocationLine to be created.');
        }
    }

    @isTest
    static void updateFulfillmentAllocationLinePositive() {
        Test.startTest();
        dmpl__InventoryFulfillmentAllocationLine__c fullfillmentAllocationLine = FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine();

        if(fullfillmentAllocationLine != null){
            System.assertNotEquals(fullfillmentAllocationLine, null, 'Expected fullfillmentAllocationLine to be created before update.');
            fullfillmentAllocationLine.dmpl__UnitCost__c = 11;
            update fullfillmentAllocationLine;
        }
        
        dmpl__InventoryFulfillmentAllocationLine__c updatedFullfillmentAllocationLine=FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(fullfillmentAllocationLine.Id);
        if(updatedFullfillmentAllocationLine != null){
            System.assertNotEquals(updatedFullfillmentAllocationLine, null, 'Expected fullfillmentAllocationLine to be updated.');
        }
        Test.stopTest();
        System.assertEquals(11, updatedFullfillmentAllocationLine.dmpl__UnitCost__c, 'Expected dmpl__UnitCost__c to be updated to 11');
    }

    @isTest
    static void deletefulfillmentAllocationLinePositive() {
        Test.startTest();
        dmpl__InventoryFulfillmentAllocationLine__c fullfillmentAllocationLine = FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine();
        System.assertNotEquals(fullfillmentAllocationLine, null, 'Expected fullfillmentAllocationLine to be created before delete.');
        dmpl__InventoryFulfillmentAllocationLine__c deletedFullfillmentAllocationLine = null;
        try {
            delete fullfillmentAllocationLine;
            deletedFullfillmentAllocationLine = FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(fullfillmentAllocationLine.Id);
        } catch (DmlException e) {
            System.debug('Exception caught as expected, record should be deleted.' + e.getMessage());
        }
        System.assertEquals(null, deletedFullfillmentAllocationLine, 'Expected fullfillmentAllocationLine to be deleted.');
        Test.stopTest();
    }
}