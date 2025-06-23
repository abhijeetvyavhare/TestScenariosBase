@isTest
public with sharing class AutoPurchaseOrderLineRelHandler_Test {

    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account supplierAccount = TestDataHelpers.createSupplierAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__ItemLotType__c itemLot = TestDataHelpers.createItemLotType(item);
        dmpl__AutoPurchaseOrder__c autoPurchaseOrder = AutoPurchaseDataHelper.createAutoPurchaseOrder(partnerAccount, supplierAccount, branch);
        dmpl__AutoPurchaseOrderLine__c autoPurchaseOrderLine = AutoPurchaseDataHelper.createAutoPurchaseOrderLine(autoPurchaseOrder, item, sku);
        dmpl__AutoPurchaseOrderLineRelation__c autoPurchaseOrderLineRelation = AutoPurchaseOrderLineRelationDataHelper.createAutoPurchaseOrderLineRelation(
            autoPurchaseOrder,
            autoPurchaseOrderLine,
            item,
            itemLot,
            sku
        );
    }

    @isTest
    static void createAutoPurchaseOrderLineRelationPositive() {
        dmpl__AutoPurchaseOrderLineRelation__c relation = AutoPurchaseOrderLineRelationDataHelper.getAutoPurchaseOrderLineRelation();
        System.assertNotEquals(null, relation, 'Relation record should be created.');
        System.assertEquals(1000, relation.dmpl__UnitCost__c);
        System.assertEquals(100, relation.dmpl__OrderQuantity__c);
    }

    @isTest
    static void updateAutoPurchaseOrderLineRelationPositive() {
        dmpl__AutoPurchaseOrderLineRelation__c relation = AutoPurchaseOrderLineRelationDataHelper.getAutoPurchaseOrderLineRelation();
        System.assertNotEquals(null, relation, 'Relation should exist for update.');

        relation.dmpl__UnitCost__c = 2000;
        relation.dmpl__OrderQuantity__c = 500;

        update relation;

        dmpl__AutoPurchaseOrderLineRelation__c updated = AutoPurchaseOrderLineRelationDataHelper.getAutoPurchaseOrderLineRelation(relation.Id);
        System.assertEquals(2000, updated.dmpl__UnitCost__c, 'Unit cost should be updated.');
        System.assertEquals(500, updated.dmpl__OrderQuantity__c, 'Order quantity should be updated.');
    }

    @isTest
    static void deleteAutoPurchaseOrderLineRelation() {
        dmpl__AutoPurchaseOrderLineRelation__c relation = AutoPurchaseOrderLineRelationDataHelper.getAutoPurchaseOrderLineRelation();
        System.assertNotEquals(null, relation, 'Relation should exist before delete.');

        delete relation;

        dmpl__AutoPurchaseOrderLineRelation__c deletedRelation = null;
        try {
            deletedRelation = AutoPurchaseOrderLineRelationDataHelper.getAutoPurchaseOrderLineRelation(relation.Id);
        } catch (Exception e) {
            deletedRelation = null;
        }

        System.assertEquals(null, deletedRelation, 'Relation record should be deleted.');
    }
}