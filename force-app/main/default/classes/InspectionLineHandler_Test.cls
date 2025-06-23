@isTest
public class InspectionLineHandler_Test {
	@TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account supplierAccount = TestDataHelpers.createSupplierAccount();
        dmpl__Branch__c branch =TestDataHelpers.createBranch(partnerAccount);  
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__GoodsReceipt__c goodsReceipt = InspectionLineTestDataHelpers.createGoodsReceipt(partnerAccount, supplierAccount, branch);
        dmpl__InspectionLine__c inspectionLine = InspectionLineTestDataHelpers.createInspectionLine(item, goodsReceipt);
    }
    
    @isTest
    static void createInspectionLine() {
        dmpl__InspectionLine__c inspectionLine = InspectionLineTestDataHelpers.getInspectionLine();
        
        System.assertEquals(1, inspectionLine.dmpl__Quantity__c, 'Quantity mismatch');
        System.assertEquals(1, inspectionLine.dmpl__AdjustmentQuantity__c, 'Adjustment Quantity mismatch');
        System.assertEquals(0, inspectionLine.dmpl__DamagedQuantity__c, 'Damaged Quantity mismatch');
        System.assertEquals(1, inspectionLine.dmpl__InspectionQuantity__c, 'Inspection Quantity mismatch');
        System.assertEquals(1, inspectionLine.dmpl__OrderQuantity__c, 'Order Quantity mismatch');
        System.assertEquals(1, inspectionLine.dmpl__ReceivedQuantity__c, 'Received Quantity mismatch');
        System.assertEquals(1199, inspectionLine.dmpl__UnitCost__c, 'Unit Cost mismatch');
    }
    
    @isTest
    static void updateInspectionLinePositive() {
        dmpl__InspectionLine__c inspectionLine = InspectionLineTestDataHelpers.getInspectionLine();
        
        inspectionLine.dmpl__Quantity__c = 5;
        inspectionLine.dmpl__AdjustmentQuantity__c = 2;
        inspectionLine.dmpl__DamagedQuantity__c = 1;
        inspectionLine.dmpl__InspectionQuantity__c = 4;
        inspectionLine.dmpl__OrderQuantity__c = 6;
        inspectionLine.dmpl__ReceivedQuantity__c = 5;
        inspectionLine.dmpl__UnitCost__c = 1500;
        
        update inspectionLine;
        
        dmpl__InspectionLine__c updatedInspectionLine = InspectionLineTestDataHelpers.getInspectionLine();
        
        System.assertEquals(5, updatedInspectionLine.dmpl__Quantity__c, 'Quantity should be updated to 5');
        System.assertEquals(2, updatedInspectionLine.dmpl__AdjustmentQuantity__c, 'Adjustment Quantity should be updated to 2');
        System.assertEquals(1, updatedInspectionLine.dmpl__DamagedQuantity__c, 'Damaged Quantity should be updated to 1');
        System.assertEquals(4, updatedInspectionLine.dmpl__InspectionQuantity__c, 'Inspection Quantity should be updated to 4');
        System.assertEquals(6, updatedInspectionLine.dmpl__OrderQuantity__c, 'Order Quantity should be updated to 6');
        System.assertEquals(5, updatedInspectionLine.dmpl__ReceivedQuantity__c, 'Received Quantity should be updated to 5');
        System.assertEquals(1500, updatedInspectionLine.dmpl__UnitCost__c, 'Unit Cost should be updated to 1500');
    }
    
    @isTest
    static void deleteInspectionLineNegative() {
        dmpl__InspectionLine__c inspectionLine = InspectionLineTestDataHelpers.getInspectionLine();
        Id inspectionLineId = inspectionLine.Id;
        
        System.assertNotEquals(null, inspectionLine, 'Inspection Line should exist before delete.');
        
        Boolean exceptionThrown = false;
        String exceptionMessage = '';
        
        try {
            delete inspectionLine;
        } catch (DmlException e) {
            exceptionThrown = true;
            exceptionMessage = e.getMessage();
        }
        
        System.assertEquals(true, exceptionThrown, 'DmlException should be thrown when trying to delete Inspection Line with downstream transactions.');
        System.assert(exceptionMessage.contains('There are downstream transaction'), 'Exception message should contain validation error about downstream transactions.');
        
        List<dmpl__InspectionLine__c> existingInspectionLines = InspectionLineTestDataHelpers.getInspectionLine(inspectionLineId);
        
        System.assertEquals(1, existingInspectionLines.size(), 'Inspection Line should still exist after failed deletion.');
    }
}