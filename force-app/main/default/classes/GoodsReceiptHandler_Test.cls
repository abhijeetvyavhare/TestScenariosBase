@isTest
private class GoodsReceiptHandler_Test {
    @TestSetup
    static void createRequiredData(){
        dmpl__AccountGroup__c accountGroup=TestDataHelpers.createAccountGroup();
        Account partnerAccount= TestDataHelpers.createPartnerAccount();
        Account customerAccount= TestDataHelpers.createCustomerAccount();
        Account supplierAccount= TestDataHelpers.createSupplierAccount();
        dmpl__Branch__c branch=TestDataHelpers.createBranch(partnerAccount);
        dmpl__ItemGroup__c itemGroup=TestDataHelpers.createItemGroup();
        dmpl__Item__c item=TestDataHelpers.createItem();
        dmpl__StorageLocation__c storageLocation=TestDataHelpers.createStorageLocation(branch);
        dmpl__SKU__c sku=TestDataHelpers.createSKU(item);
        dmpl__ItemLot__c itemLot=TestDataHelpers.createItemLot(branch,item,sku,storageLocation);
        dmpl__PriceList__c priceList=TestDataHelpers.createPriceList(partnerAccount,branch);
        dmpl__TaxGroup__c taxGroup=TestDataHelpers.createTaxGroup(partnerAccount,branch);
        dmpl__PurchaseRequisition__c purchaseRequisition=PurchaseOrderTestDataHelpers.CreatePurchaseRequisition(branch,supplierAccount);
        dmpl__PurchaseOrder__c purchaseOrder=PurchaseOrderTestDataHelpers.createPurchaseOrder(branch,supplierAccount);
        dmpl__PurchaseOrderLine__c purchaseOrderLine=PurchaseOrderTestDataHelpers.createPurchaseOrderLine(item,sku,purchaseOrder,taxGroup,purchaseRequisition);
        dmpl__Shipment__c shipment=ShipmentTestDataHelper.createShipment(supplierAccount,branch,purchaseOrder);
        dmpl__ShipmentLine__c shipmentLine=ShipmentTestDataHelper.createShipmentLine(item,shipment,sku,purchaseOrderLine);
        dmpl__GoodsReceipt__c goodsReceipt=GoodRecieptsTestDataHelpers.createGoodsReceipt(partnerAccount,branch,purchaseOrder,supplierAccount);
        dmpl__GoodsReceiptLine__c grnLine=GoodRecieptsTestDataHelpers.createGoodReceiptLine(goodsReceipt,item,sku);
        dmpl__InspectionLine__c inspectionLine=GoodRecieptsTestDataHelpers.createInspectionLine(item,sku,goodsReceipt);
    }

    @isTest
    static void createGoodsReceiptPositive() {
        dmpl__GoodsReceipt__c goodsReceipt=GoodRecieptsTestDataHelpers.getGoodsReceipt();
        if(goodsReceipt !=null) {
            System.assertNotEquals(goodsReceipt, null, 'Expected Goods receipt to be created.');
        }
        System.assertEquals( date.today(),goodsReceipt.dmpl__DocumentDate__c, 'Expected Document Date to be today.');
        System.assertEquals( true,goodsReceipt.dmpl__PerformReceive__c, 'Expected Perform Receive to be true.');  
        System.assertEquals( true,goodsReceipt.dmpl__PerformInspection__c, 'Expected Perform Inspection to be true.');
        System.assertEquals( true,goodsReceipt.dmpl__PerformInspectionComplete__c, 'Expected Perform Inspection Complete to be true.'); 
        System.assertEquals( true,goodsReceipt.dmpl__IsInspectionCompleted__c, 'Expected Is Inspection Completed to be true.');
        
        dmpl__GoodsReceiptLine__c grnLine=GoodRecieptsTestDataHelpers.getGoodReceiptLine();
        if(grnLine !=null) {
            System.assertNotEquals(grnLine, null, 'Expected Goods receipt line to be created.');
        }
        System.assertEquals( 1,grnLine.dmpl__ReceivedQuantity__c, 'Expected Quantity Received to be 1.');
        System.assertEquals( 1,grnLine.dmpl__OrderedQuantity__c, 'Expected Quantity Ordered to be 1.');  
        System.assertEquals( 1,grnLine.dmpl__SupplierQuantity__c, 'Expected Quantity Supplier to be 1.');
    }

    @isTest
    static void updateGoodsReceiptPositive() {
        dmpl__GoodsReceipt__c goodsReceipt=GoodRecieptsTestDataHelpers.getGoodsReceipt();
        System.assertNotEquals(goodsReceipt, null, 'Goods receipt should exist before update.');
        goodsReceipt.dmpl__PerformReceive__c = false;
        goodsReceipt.dmpl__PerformInspection__c = false;
        goodsReceipt.dmpl__PerformInspectionComplete__c = false;
        goodsReceipt.dmpl__IsInspectionCompleted__c = false;
        update goodsReceipt;

        dmpl__GoodsReceipt__c updatedGoodsReceipt = GoodRecieptsTestDataHelpers.getGoodsReceipt();
        System.assertEquals( false,goodsReceipt.dmpl__PerformReceive__c, 'Expected Perform Receive to be false.');  
        System.assertEquals( false,goodsReceipt.dmpl__PerformInspection__c, 'Expected Perform Inspection to be false.');
        System.assertEquals( false,goodsReceipt.dmpl__PerformInspectionComplete__c, 'Expected Perform Inspection Complete to be false.'); 
        System.assertEquals( false,goodsReceipt.dmpl__IsInspectionCompleted__c, 'Expected Is Inspection Completed to be false.');
        
        dmpl__GoodsReceiptLine__c grnLine=GoodRecieptsTestDataHelpers.getGoodReceiptLine();
        System.assertNotEquals(grnLine, null, 'Goods receipt line should exist before update.');
        grnLine.dmpl__ReceivedQuantity__c = 2;
        grnLine.dmpl__OrderedQuantity__c = 2;
        grnLine.dmpl__SupplierQuantity__c = 2;
        update grnLine;

        dmpl__GoodsReceiptLine__c updatedGRNLine = GoodRecieptsTestDataHelpers.getGoodReceiptLine();
        System.assertEquals( 2,updatedGRNLine.dmpl__ReceivedQuantity__c, 'Expected Quantity Received to be 2.');  
        System.assertEquals( 2,updatedGRNLine.dmpl__OrderedQuantity__c, 'Expected Quantity Ordered to be 2.');
        System.assertEquals( 2,updatedGRNLine.dmpl__SupplierQuantity__c, 'Expected Quantity Supplier to be 2.');
    }

    @isTest
    static void deleteGoodsReceiptLineNegative() {
        dmpl__GoodsReceiptLine__c grnLine = GoodRecieptsTestDataHelpers.getGoodReceiptLine();
        System.assertNotEquals(null, grnLine, 'GoodsReceiptLine should exist before delete');
    
        Test.startTest();
        try {
            delete grnLine;
            System.assert(false, 'Expected DML exception when deleting GoodsReceiptLine');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY'), 
                 'Expected CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY error');
            System.assert(e.getMessage().contains('dmpl.GoodsReceiptLineTrigger'), 
                 'Error should be from GoodsReceiptLineTrigger');
        }
        Test.stopTest();
    
        dmpl__GoodsReceiptLine__c nonDeletedLine = GoodRecieptsTestDataHelpers.getGoodReceiptLine();
        System.assertNotEquals(null, nonDeletedLine, 'GoodsReceiptLine should still exist after failed delete');
    }
}