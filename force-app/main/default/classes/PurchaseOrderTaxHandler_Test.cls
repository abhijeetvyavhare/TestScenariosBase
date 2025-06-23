@isTest
public with sharing class PurchaseOrderTaxHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account supplierAccount = TestDataHelpers.createSupplierAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup(partnerAccount, branch);
        dmpl__Tax__c tax = TestDataHelpers.createTax(taxGroup);
        dmpl__PurchaseRequisition__c purchaseRequisition = PurchaseOrderTestDataHelpers.createPurchaseRequisition(branch, supplierAccount);
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch, supplierAccount);
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(item, sku, purchaseOrder, taxGroup, purchaseRequisition);
        dmpl__PurchaseOrderTax__c purchaseOrderTax = PurchaseOrderTestDataHelpers.CreatePurchaseOrderTax(purchaseOrder, tax, purchaseOrderLine);
    }

    @isTest
    static void createPurchaseOrderTaxPositive() {
        dmpl__PurchaseOrderTax__c purchaseOrderTax = PurchaseOrderTestDataHelpers.getPurchaseOrderTax();
        System.assertNotEquals(null, purchaseOrderTax, 'Expected purchase order tax to be created.');
        System.assertEquals(-4.00, purchaseOrderTax.dmpl__TaxOnAmount__c, 'TaxOnAmount should be -4.00');
        System.assertEquals(10.00, purchaseOrderTax.dmpl__TaxRate__c, 'TaxRate should be 10.00');
    }

    @isTest
    static void updatePurchaseOrderTaxPositive() {
        dmpl__PurchaseOrderTax__c purchaseOrderTax = PurchaseOrderTestDataHelpers.getPurchaseOrderTax();
        System.assertNotEquals(null, purchaseOrderTax, 'Purchase order tax should exist before update.');
        purchaseOrderTax.dmpl__TaxRate__c = 5;
        update purchaseOrderTax;
        dmpl__PurchaseOrderTax__c updatedTax = PurchaseOrderTestDataHelpers.getPurchaseOrderTax(purchaseOrderTax.Id);
        System.assertEquals(5, updatedTax.dmpl__TaxRate__c, 'TaxRate should be updated to 5.');
    }

    @isTest
    static void deletePurchaseOrderTax() {
        dmpl__PurchaseOrderTax__c purchaseOrderTax = PurchaseOrderTestDataHelpers.getPurchaseOrderTax();
        System.assertNotEquals(null, purchaseOrderTax, 'Purchase order tax should exist before delete.');

        delete purchaseOrderTax;

        dmpl__PurchaseOrderTax__c deletedTax = null;
        try {
            deletedTax = PurchaseOrderTestDataHelpers.getPurchaseOrderTax(purchaseOrderTax.Id);
        } catch (Exception e) {
            deletedTax = null;
        }
        System.assertEquals(null, deletedTax, 'Purchase order tax should be deleted and not found in query.');
    }
}