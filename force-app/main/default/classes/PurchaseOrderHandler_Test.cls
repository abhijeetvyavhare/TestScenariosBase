@isTest
public with sharing class PurchaseOrderHandler_Test {
    @TestSetup
    static void createRequiredData(){
        Account partnerAccount=TestDataHelpers.createPartnerAccount();
        Account supplierAccount=TestDataHelpers.createSupplierAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__Item__c item=TestDataHelpers.createItem();
        dmpl__SKU__c sku=TestDataHelpers.createSKU(item);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup(partnerAccount,branch);
        dmpl__PurchaseRequisition__c purchaseRequisition=PurchaseOrderTestDataHelpers.CreatePurchaseRequisition(branch,supplierAccount);
        dmpl__PurchaseOrder__c purchaseOrder=PurchaseOrderTestDataHelpers.createPurchaseOrder(branch,supplierAccount);
        dmpl__PurchaseOrderLine__c purchaseOrderLine=PurchaseOrderTestDataHelpers.createPurchaseOrderLine(item,sku,purchaseOrder,taxGroup,purchaseRequisition);
    }

    @isTest
    static void createPurchaseOrderPositive() {
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        if(purchaseOrder != null) {
            System.assertNotEquals(purchaseOrder, null, 'Expected purchaseOrder to be created.');
        }
        System.assertEquals('Draft',purchaseOrder.dmpl__Status__c,'Status should be Draft.');
    }

    @isTest 
    static void updatePurchaseOrderPositive() {
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        System.assertNotEquals(purchaseOrder, null, 'PurchaseOrder should exist before update.');
        purchaseOrder.dmpl__Status__c = 'Pending Approval';
        update purchaseOrder;
        dmpl__PurchaseOrder__c updatePurchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        System.assertEquals('Pending Approval',updatePurchaseOrder.dmpl__Status__c,'Next status should be Released.');
    }

    @isTest
    static void deletePurchaseOrder() {
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        System.assertNotEquals(purchaseOrder, null, 'PurchaseOrder should exist before delete.');

        delete purchaseOrder;

        dmpl__PurchaseOrder__c deletedOrder = null;
        try {
            deletedOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        } catch (Exception e) {
            deletedOrder = null;
        }
        System.assertEquals(null, deletedOrder, 'PurchaseOrder should be deleted and not found in query.');
    }

    @isTest
    static void createPurchaseOrderLinePositive() {
        dmpl__PurchaseOrderLine__c purchaseOrderLine=PurchaseOrderTestDataHelpers.getPurchaseOrderLine();
        if(purchaseOrderLine != null) {
            System.assertNotEquals(purchaseOrderLine, null, 'Expected purchaseOrderLine to be created.');
        }
        System.assertEquals(100,purchaseOrderLine.dmpl__UnitCost__c,'Unit cost should be 100');
    }
    
    @isTest
    static void updatePurchaseOrderLinePositive() {
        dmpl__PurchaseOrderLine__c purchaseOrderLine=PurchaseOrderTestDataHelpers.getPurchaseOrderLine();
        purchaseOrderLine.dmpl__UnitCost__c = 200;
        update purchaseOrderLine;
        System.assertEquals(200,purchaseOrderLine.dmpl__UnitCost__c,'Unit cost should be 100');
    }


    @isTest
    static void deletePurchaseOrderLine() {
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine();
        System.assertNotEquals(purchaseOrderLine, null, 'PurchaseOrderLine should exist before delete.');

        delete purchaseOrderLine;

        dmpl__PurchaseOrderLine__c deletedPOL = null;
        try {
            deletedPOL = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        } catch (Exception e) {
            deletedPOL = null;
        }
        System.assertEquals(null, deletedPOL, 'PurchaseOrderLine should be deleted and not found in query.');
    }
}