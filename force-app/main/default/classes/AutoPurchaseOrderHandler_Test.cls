@isTest
public with sharing class AutoPurchaseOrderHandler_Test {
    @TestSetup
    static void createRequiredData(){
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account supplierAccount = TestDataHelpers.createSupplierAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__AutoPurchaseOrder__c autoPurchaseOrder = AutoPurchaseDataHelper.createAutoPurchaseOrder(partnerAccount, supplierAccount, branch);
    }

    @isTest
    static void createAutoPurchaseOrderTPositive() {
        dmpl__AutoPurchaseOrder__c autoPurchaseOrder = AutoPurchaseDataHelper.getAutoPurchaseOrder();
        System.assertNotEquals(null, autoPurchaseOrder, 'Auto Purchase Order should be created.');
        System.assertEquals('Minimum Stock Level', autoPurchaseOrder.dmpl__AutoOrderType__c);
        
    }

    @isTest
    static void updateAutoPurchaseOrderPositive() {
        dmpl__AutoPurchaseOrder__c autoPurchaseOrder = AutoPurchaseDataHelper.getAutoPurchaseOrder();

        autoPurchaseOrder.dmpl__Remarks__c = 'Updated by test';
        autoPurchaseOrder.dmpl__PerformOrderGeneration__c = false;
        update autoPurchaseOrder;
        dmpl__AutoPurchaseOrder__c updatedAutoPurchaseOrder = AutoPurchaseDataHelper.getAutoPurchaseOrder(autoPurchaseOrder.Id);
        System.assertEquals('Updated by test', updatedAutoPurchaseOrder.dmpl__Remarks__c);
        System.assertEquals(false, updatedAutoPurchaseOrder.dmpl__PerformOrderGeneration__c);
        
    }

    @isTest
    static void deleteAutoPurchaseOrder() {
        dmpl__AutoPurchaseOrder__c autoPurchaseOrder = AutoPurchaseDataHelper.getAutoPurchaseOrder();
        System.assertNotEquals(null, autoPurchaseOrder, 'Auto Purchase Order should exist before delete.');
        delete autoPurchaseOrder;
        dmpl__AutoPurchaseOrder__c deletedOrder = null;
        try {
            deletedOrder = AutoPurchaseDataHelper.getAutoPurchaseOrder(autoPurchaseOrder.Id);
        } catch (Exception e) {
            deletedOrder = null;
        }

        System.assertEquals(null, deletedOrder, 'Auto Purchase Order should be deleted and not found in query.');
    }
}