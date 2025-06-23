@isTest
public with sharing class PurchaseOrderRequisitionHandler_Test {

    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account supplierAccount = TestDataHelpers.createSupplierAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__PurchaseRequisition__c requisition = PurchaseOrderTestDataHelpers.CreatePurchaseRequisition(branch, supplierAccount);
        dmpl__PurchaseRequisitionLine__c requisitionLine = PurchaseOrderTestDataHelpers.CreatePurchaseRequisitionLine(requisition, item, sku);
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch, supplierAccount);
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(item, sku, purchaseOrder, TestDataHelpers.createTaxGroup(partnerAccount, branch));
        dmpl__PurchaseOrderRequisition__c purchaseOrderRequisition = PurchaseOrderTestDataHelpers.createPurchaseOrderRequisition(
            partnerAccount,
            purchaseOrder,
            purchaseOrderLine,
            requisition,
            requisitionLine,
            branch
        );
    }

    @isTest
    static void createPurchaseOrderRequisitionPositive() {
        dmpl__PurchaseOrderRequisition__c purchaseOrderRequisition = PurchaseOrderTestDataHelpers.getPurchaseOrderRequisition();
        System.assertNotEquals(purchaseOrderRequisition, null, 'Expected PurchaseOrderRequisition to be created.');
        System.assertEquals(5, purchaseOrderRequisition.dmpl__RequestedQuantity__c, 'RequestedQuantity should be 5.');
        System.assertEquals(4, purchaseOrderRequisition.dmpl__OrderedQuantity__c, 'OrderedQuantity should be 4.');
    }

    @isTest
    static void updatePurchaseOrderRequisitionPositive() {
        dmpl__PurchaseOrderRequisition__c purchaseOrderRequisition = PurchaseOrderTestDataHelpers.getPurchaseOrderRequisition();
        System.assertNotEquals(purchaseOrderRequisition, null, 'PurchaseOrderRequisition should exist before update.');

        purchaseOrderRequisition.dmpl__RequestedQuantity__c = 10;
        update purchaseOrderRequisition;

        dmpl__PurchaseOrderRequisition__c updatedRequisition = PurchaseOrderTestDataHelpers.getPurchaseOrderRequisition(purchaseOrderRequisition.Id);
        System.assertEquals(10, updatedRequisition.dmpl__RequestedQuantity__c, 'RequestedQuantity should be updated to 10.');
        System.assertEquals(4, updatedRequisition.dmpl__OrderedQuantity__c, 'OrderedQuantity should remain unchanged.');
    }

    @isTest
    static void deletePurchaseOrderRequisition() {
        dmpl__PurchaseOrderRequisition__c purchaseOrderRequisition = PurchaseOrderTestDataHelpers.getPurchaseOrderRequisition();
        System.assertNotEquals(purchaseOrderRequisition, null, 'PurchaseOrderRequisition should exist before delete.');

        delete purchaseOrderRequisition;

        dmpl__PurchaseOrderRequisition__c deletedRequisition = null;
        try {
            deletedRequisition = PurchaseOrderTestDataHelpers.getPurchaseOrderRequisition(purchaseOrderRequisition.Id);
        } catch (Exception e) {
            deletedRequisition = null;
        }

        System.assertEquals(null, deletedRequisition, 'PurchaseOrderRequisition should be deleted and not found.');
    }
}