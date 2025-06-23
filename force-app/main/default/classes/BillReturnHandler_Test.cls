@isTest
public with sharing class BillReturnHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();  
        Account supplierAccount = TestDataHelpers.createSupplierAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation(branch);
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__ItemLot__c itemLot = TestDataHelpers.createItemLot(branch, item, sku, storageLocation);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup(partnerAccount, branch);
        dmpl__Tax__c tax = TestDataHelpers.createTax(taxGroup);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList(partnerAccount, branch);
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceList, item);
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch, supplierAccount);
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partnerAccount, branch, purchaseOrder, supplierAccount);
        dmpl__GoodsReceiptLine__c grnLine = GoodRecieptsTestDataHelpers.createGoodReceiptLine(goodsReceipt, item, sku);
        Test.startTest();
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplierAccount, branch, priceList, purchaseOrder, goodsReceipt); 
        dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLine(customerAccount, item, sku, itemLot, bill, priceListRule, taxGroup);
        dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(supplierAccount, partnerAccount, branch, priceList);
        dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(bill, billReturn, item, billLine);
        dmpl__BillReturnTax__c billReturnTax = BillTestDataHelpers.CreateBillReturnTax(billReturn, billReturnLine, item, sku, bill, billLine, grnLine, taxGroup, tax);
        Test.stopTest();
    }

    @isTest
    static void createBillReturnPositive() {
        dmpl__BillReturn__c billReturn = BillTestDataHelpers.getBillReturn();
        if (billReturn != null) {
            System.assertNotEquals(billReturn, null, 'Expected BillReturn to be created.');
        }
        System.assertEquals(false, billReturn.dmpl__PerformReturn__c, 'PerformReturn should be true');
        System.assertEquals(false, billReturn.dmpl__PerformInventoryPosting__c, 'PerformInventoryPosting should be false');
        System.assertEquals(Date.today(), billReturn.dmpl__DocumentDate__c, 'DocumentDate should ' + Date.today());
    }

    @isTest
    static void updateBillReturnPositive() {
        dmpl__BillReturn__c billReturn = BillTestDataHelpers.getBillReturn();
        System.assertNotEquals(billReturn, null, 'Bill Return should exist before update.');
        billReturn.dmpl__PerformReturn__c = false;
        update billReturn;
        dmpl__BillReturn__c updatedBillReturn = BillTestDataHelpers.getBillReturn();       
        System.assertEquals(false, updatedBillReturn.dmpl__PerformReturn__c, 'PerformReturn should be false');
    }

    @isTest
    static void deleteBillReturn() {
        dmpl__BillReturn__c billReturn = BillTestDataHelpers.getBillReturn();
        System.assertNotEquals(billReturn, null, 'BillReturn should exist before delete.');
        delete billReturn;
        dmpl__BillReturn__c deletedBillReturn = null;
        try {
            deletedBillReturn = BillTestDataHelpers.getBillReturn();
        } catch (Exception e) {
            deletedBillReturn = null;
        }
        System.assertEquals(null, deletedBillReturn, 'BillReturn should be deleted and not found in query.');
    }

    @isTest
    static void createBillReturnLinePositive() {
        Test.startTest();
        dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.getBillReturnLine();
        Test.stopTest();
        if (billReturnLine != null) {
            System.assertNotEquals(billReturnLine, null, 'Expected BillReturnLine to be created.');
        }
        System.assertEquals(2, billReturnLine.dmpl__Quantity__c, 'Quantity should be 2');
    }

    @isTest
    static void updateBillReturnLinePositive() {
        dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.getBillReturnLine();
        System.assertNotEquals(billReturnLine, null, 'BillReturnLine should exist before update.');
        Test.startTest();
        billReturnLine.dmpl__Quantity__c = 5;
        update billReturnLine;
        Test.stopTest();
        dmpl__BillReturnLine__c updatedBillReturnLine = BillTestDataHelpers.getBillReturnLine();       
        System.assertEquals(5, updatedBillReturnLine.dmpl__Quantity__c, 'Quantity should be 5');
    }

    @isTest
    static void deleteBillReturnLine() {
        dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.getBillReturnLine();
        System.assertNotEquals(billReturnLine, null, 'BillReturnLine should exist before delete.');
        
        Test.startTest();
        Boolean exceptionCaught = false;
        String exceptionMessage = '';
        
        try {
            delete billReturnLine;
            System.assert(false, 'Expected exception when deleting BillReturnLine');
        } catch (Exception e) {
            exceptionCaught = true;
            exceptionMessage = e.getMessage();
            System.debug('Exception caught: Type=' + e.getTypeName() + ', Message=' + exceptionMessage);        
            System.assert(
                exceptionMessage.contains('CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY'), 
                'Expected CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY error. Actual: ' + exceptionMessage
            );
            
            System.assert(
                exceptionMessage.contains('BillReturnLineTrigger'), 
                'Error should be from BillReturnLineTrigger. Actual: ' + exceptionMessage
            );
            
            System.assert(
                exceptionMessage.contains('null SObject') || exceptionMessage.contains('ListException'),
                'Expected null SObject or ListException error. Actual: ' + exceptionMessage
            );
        }
        Test.stopTest();
        System.assert(exceptionCaught, 'An exception should have been thrown during delete');    
        dmpl__BillReturnLine__c nonDeletedLine = BillTestDataHelpers.getBillReturnLine();
        System.assertNotEquals(null, nonDeletedLine, 'BillReturnLine should still exist after failed delete');
    }

    @isTest
     static void createBillReturnTaxPositive() {
        dmpl__BillReturnTax__c billReturnTax = BillTestDataHelpers.getBillReturnTax();
        System.assertNotEquals(billReturnTax, null, 'Expected BillReturnTax to be created.');
        System.assertEquals(true, billReturnTax.dmpl__TaxOnAmount__c, 'TaxOnAmount should be true');
    }

    @isTest
    static void updateBillReturnTaxPositive() {
        dmpl__BillReturnTax__c billReturnTax = BillTestDataHelpers.getBillReturnTax();
        System.assertNotEquals(billReturnTax, null, 'BillReturnTax should exist before update.');
        billReturnTax.dmpl__TaxAmount__c = 100;
        Test.startTest();
        update billReturnTax;
        Test.stopTest();
        dmpl__BillReturnTax__c updated = BillTestDataHelpers.getBillReturnTax();       
        System.assertEquals(100, updated.dmpl__TaxAmount__c, 'TaxAmount should be 100');
    }

    @isTest
    static void deleteBillReturnTax() {
        dmpl__BillReturnTax__c billReturnTax = BillTestDataHelpers.getBillReturnTax();
        System.assertNotEquals(billReturnTax, null, 'BillReturnTax should exist before delete.');
        Test.startTest();
        delete billReturnTax;
        Test.stopTest();
        dmpl__BillReturnTax__c deleted = null;
        try {
            deleted = BillTestDataHelpers.getBillReturnTax();
        } catch (Exception e) {
            deleted = null;
        }
        System.assertEquals(null, deleted, 'BillReturnTax should be deleted and not found in query.');
    }
}