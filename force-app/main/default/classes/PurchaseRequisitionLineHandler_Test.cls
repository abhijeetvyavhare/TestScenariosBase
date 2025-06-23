@isTest
private class PurchaseRequisitionLineHandler_Test {
    
    @TestSetup
    static void createRequiredData() {

        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        

        dmpl__PurchaseRequisition__c purchaseRequisition = RequisitionTestDataHelpers.CreateRequistion(
            partnerAccount,
            branch
        );
        
        dmpl__PurchaseRequisitionLine__c requisitionLine = RequisitionTestDataHelpers.CreateRequistionLine(
            purchaseRequisition,
            item,
            sku
        );
    }

    @isTest
    static void createPurchaseRequisitionLinePositive() {

        dmpl__PurchaseRequisition__c purchaseRequisition = RequisitionTestDataHelpers.getRequisition();
        dmpl__Item__c item = TestDataHelpers.getItem();
        dmpl__SKU__c sku = TestDataHelpers.getSKU();

        Test.startTest();

        dmpl__PurchaseRequisitionLine__c requisitionLine = RequisitionTestDataHelpers.CreateRequistionLine(
            purchaseRequisition,
            item,
            sku
        );
        Test.stopTest();

        System.assertNotEquals(null, requisitionLine.Id, 'Purchase Requisition Line should be created');
        System.assertEquals(purchaseRequisition.Id, requisitionLine.dmpl__PurchaseRequisitionId__c, 'Purchase Requisition should be linked');
        System.assertEquals(item.Id, requisitionLine.dmpl__ItemId__c, 'Item should be linked');
        System.assertEquals(sku.Id, requisitionLine.dmpl__SKUId__c, 'SKU should be linked');
        System.assertEquals(1, requisitionLine.dmpl__Quantity__c, 'Quantity should be 1');
    }

    @isTest
    static void updatePurchaseRequisitionLinePositive() {

        dmpl__PurchaseRequisitionLine__c existingLine = RequisitionTestDataHelpers.getRequisitionLine();
        dmpl__PurchaseRequisition__c purchaseRequisition = RequisitionTestDataHelpers.getRequisition();
        dmpl__Item__c item = TestDataHelpers.getItem();
        dmpl__SKU__c sku = TestDataHelpers.getSKU();

        Test.startTest();
        existingLine.dmpl__Quantity__c = 2;
        update existingLine;
        Test.stopTest();

        // Verify results
        dmpl__PurchaseRequisitionLine__c updatedLine = RequisitionTestDataHelpers.getRequisitionLine();
        System.assertEquals(2, updatedLine.dmpl__Quantity__c, 'Quantity should be updated to 2');
    }

    @isTest
    static void deletePurchaseRequisitionLinePositive() {
        dmpl__PurchaseRequisitionLine__c existingLine = RequisitionTestDataHelpers.getRequisitionLine();

        Test.startTest();
        delete existingLine;
        Test.stopTest();

        List<dmpl__PurchaseRequisitionLine__c> remainingLines = [
            SELECT Id 
            FROM dmpl__PurchaseRequisitionLine__c 
            WHERE Id = :existingLine.Id
        ];
        System.assertEquals(0, remainingLines.size(), 'Purchase Requisition Line should be deleted');
    }
}