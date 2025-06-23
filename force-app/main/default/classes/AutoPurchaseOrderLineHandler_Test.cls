@isTest
public with sharing class AutoPurchaseOrderLineHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account supplierAccount = TestDataHelpers.createSupplierAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__AutoPurchaseOrder__c autoPurchaseOrder = AutoPurchaseDataHelper.createAutoPurchaseOrder(partnerAccount, supplierAccount, branch);
        dmpl__AutoPurchaseOrderLine__c autoPurchaseOrderLine = AutoPurchaseDataHelper.createAutoPurchaseOrderLine(autoPurchaseOrder, item, sku);
    }

    @isTest
    static void createAutoPurchaseOrderLinePositive() {
        dmpl__AutoPurchaseOrderLine__c autoPurchaseOrderLine = AutoPurchaseDataHelper.getAutoPurchaseOrderLine();
        System.assertNotEquals(null, autoPurchaseOrderLine, 'autoPurchaseOrderLine record should be created.');
        System.assertEquals(1, autoPurchaseOrderLine.dmpl__MaximumQuantity__c);
        System.assertEquals(1, autoPurchaseOrderLine.dmpl__MinimumQuantity__c);
    }

    @isTest
    static void updateAutoPurchaseOrderLinePositive() {
        dmpl__AutoPurchaseOrderLine__c autoPurchaseOrderLine = AutoPurchaseDataHelper.getAutoPurchaseOrderLine();
        System.assertNotEquals(null, autoPurchaseOrderLine, 'autoPurchaseOrderLine record should be created before update.');
        autoPurchaseOrderLine.dmpl__MaximumQuantity__c = 5;
        update autoPurchaseOrderLine;
        dmpl__AutoPurchaseOrderLine__c updateAutoPurchaseOrderLine = AutoPurchaseDataHelper.getAutoPurchaseOrderLine(autoPurchaseOrderLine.Id);
        System.assertEquals(5, updateAutoPurchaseOrderLine.dmpl__MaximumQuantity__c);
        System.assertEquals(1, updateAutoPurchaseOrderLine.dmpl__MinimumQuantity__c);
    }

    @isTest
    static void deleteAutoPurchaseOrderLine() {
    dmpl__AutoPurchaseOrderLine__c autoPurchaseOrderLine = AutoPurchaseDataHelper.getAutoPurchaseOrderLine();
    System.assertNotEquals(autoPurchaseOrderLine, null, 'AutoPurchaseOrderLine should exist before delete.');

    List<dmpl__AutoPurchaseOrderLineRelation__c> relations = [
        SELECT Id FROM dmpl__AutoPurchaseOrderLineRelation__c
        WHERE dmpl__AutoPurchaseOrderLineId__c = :autoPurchaseOrderLine.Id
    ];
    if (!relations.isEmpty()) {
        delete relations;
    }

    try {
        delete autoPurchaseOrderLine;
        dmpl__AutoPurchaseOrderLine__c deletedLine =
            AutoPurchaseDataHelper.getAutoPurchaseOrderLine(autoPurchaseOrderLine.Id);
        System.assertEquals(null, deletedLine, 'AutoPurchaseOrderLine should be deleted and not found.');
    } catch (DmlException e) {
        System.assert(
            e.getMessage().contains('downstream transaction'),
            'Unexpected error while deleting: ' + e.getMessage()
        );
    }
}


}