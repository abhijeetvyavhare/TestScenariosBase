@isTest
public with sharing class PurchaseReturnLineHandler_Test {
    
    @TestSetup
    static void createRequiredData() {
        Account supplierAccount = TestDataHelpers.createSupplierAccount();
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__PurchaseReturn__c purchaseReturn = PurchaseReturnDataHelper.createPurchaseRetrun(
            supplierAccount, 
            partnerAccount,
            branch
        );
        dmpl__AccountGroup__c accountGroup = TestDataHelpers.createAccountGroup();
        Account account = TestDataHelpers.createAccount(accountGroup);
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__Bill__c bill = PurchaseReturnDataHelper.createBill();
        dmpl__PurchaseReturnLine__c purchaseReturnLine = PurchaseReturnDataHelper.createPurchaseRetrunLine(
            purchaseReturn,
            item,
            sku,
            bill
        );
    }

    @isTest
    static void createPurchaseReturnLinePositive() {
        dmpl__PurchaseReturnLine__c purchaseReturnLine = PurchaseReturnDataHelper.getPurchaseRetrunLine();
        System.assertNotEquals(null, purchaseReturnLine, 'Expected PurchaseReturnLine to be created.');
        System.assertEquals('Damaged', purchaseReturnLine.dmpl__ReturnType__c, 'Return type should be Damaged');
        System.assertEquals(2, purchaseReturnLine.dmpl__Quantity__c, 'Quantity should be 2');
        System.assertEquals(100, purchaseReturnLine.dmpl__UnitCost__c, 'Unit cost should be 100');
    }

    @isTest
    static void updatePurchaseReturnLinePositive() {
        dmpl__PurchaseReturnLine__c purchaseReturnLine = PurchaseReturnDataHelper.getPurchaseRetrunLine();
        System.assertNotEquals(null, purchaseReturnLine, 'PurchaseReturnLine should exist before update.');

        purchaseReturnLine.dmpl__ReturnType__c = 'Excess';
        update purchaseReturnLine;

        dmpl__PurchaseReturnLine__c updatedLine = PurchaseReturnDataHelper.getPurchaseRetrunLine(purchaseReturnLine.Id);
        System.assertEquals('Excess', updatedLine.dmpl__ReturnType__c, 'Return type should be updated to Excess');
    }

    @isTest
    static void deletePurchaseReturnLine() {
        dmpl__PurchaseReturnLine__c purchaseReturnLine = PurchaseReturnDataHelper.getPurchaseRetrunLine();
        System.assertNotEquals(null, purchaseReturnLine, 'PurchaseReturnLine should exist before delete.');
        delete purchaseReturnLine;
        dmpl__PurchaseReturnLine__c deletedLine = null;
        try {
            deletedLine = PurchaseReturnDataHelper.getPurchaseRetrunLine(purchaseReturnLine.Id);
        } catch (Exception e) {
            deletedLine = null;
        }
        System.assertEquals(null, deletedLine, 'PurchaseReturnLine should be deleted and not found in query.');
    }
}