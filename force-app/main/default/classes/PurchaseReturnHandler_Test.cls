@isTest
public with sharing class PurchaseReturnHandler_Test {
    @TestSetup
    static void createRequiredData(){
        Account supplierAccount = TestDataHelpers.createSupplierAccount();
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch =TestDataHelpers.createBranch(partnerAccount); 
        dmpl__PurchaseReturn__c purchaseReturn = PurchaseReturnDataHelper.createPurchaseRetrun(supplierAccount,partnerAccount,branch);
    }

    @isTest
    static void createPurchaseReturnPositive() {
        dmpl__PurchaseReturn__c purchaseReturn = PurchaseReturnDataHelper.getPurchaseRetrun();
        if(purchaseReturn != null){
            System.assertNotEquals(purchaseReturn, null, 'Expected purchaseReturn to be created.');
        }
        System.assertEquals('1', purchaseReturn.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals('Description1', purchaseReturn.dmpl__Description__c, 'Description should be Description1');
    }

    @isTest
    static void updatePurchaseRetrunPositive() {
        dmpl__PurchaseReturn__c purchaseReturn = PurchaseReturnDataHelper.getPurchaseRetrun();
        System.assertNotEquals(purchaseReturn, null, 'purchaseReturn should exist before update.');
        purchaseReturn.dmpl__Status__c = '2';
        update purchaseReturn;
        dmpl__PurchaseReturn__c updatedPurchaseReturn = PurchaseReturnDataHelper.getPurchaseRetrun(purchaseReturn.Id);
        System.assertEquals(updatedPurchaseReturn.dmpl__Status__c, '2', 'Status should be 2');
    }

    @isTest
    static void deletePurchaseReturn() {
        dmpl__PurchaseReturn__c purchaseReturn = PurchaseReturnDataHelper.getPurchaseRetrun();
        System.assertNotEquals(purchaseReturn, null, 'PurchaseReturn should exist before delete.');
        delete purchaseReturn;
        dmpl__PurchaseReturn__c deletedPurchaseReturn = null;
        try {
            deletedPurchaseReturn = PurchaseReturnDataHelper.getPurchaseRetrun(purchaseReturn.Id);
        } catch (Exception e) {
            deletedPurchaseReturn = null;
        }
        System.assertEquals(null, deletedPurchaseReturn, 'PurchaseReturn should be deleted and not found in query.');
    }

}