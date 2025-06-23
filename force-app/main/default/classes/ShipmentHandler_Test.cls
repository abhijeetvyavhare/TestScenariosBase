@isTest
public with sharing class ShipmentHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account supplierAccount = TestDataHelpers.createSupplierAccount();
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__PurchaseOrder__c createPurchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch, supplierAccount);
        dmpl__Shipment__c createShipment = ShipmentTestDataHelper.createShipment(supplierAccount, branch, createPurchaseOrder);
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__PurchaseRequisition__c purchaseRequisition = PurchaseOrderTestDataHelpers.CreatePurchaseRequisition(branch, supplierAccount);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup(partnerAccount, branch);
        dmpl__PurchaseOrderLine__c createPurchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(item, sku, createPurchaseOrder, taxGroup, purchaseRequisition);
        dmpl__ShipmentLine__c ShipmentLine = ShipmentTestDataHelper.createShipmentLine(item, createShipment, sku, createPurchaseOrderLine);
    }
    
    @isTest
    static void createShipmentPositive() {
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.getShipment();
        System.assertNotEquals(null, shipment);
        System.assert(shipment.dmpl__PerformReleaseReceipt__c);
    }

    @isTest
    static void createShipmentLinePositive() {
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.getShipmentLine();
        System.assertNotEquals(null, shipmentLine);
        System.assertEquals(1, shipmentLine.dmpl__Quantity__c);
    }
    
    @isTest
    static void updateShipmentPositive() {
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.getShipment();
        System.assertNotEquals(null, shipment, 'Shipment should exist before update.');
        
        Boolean newPerformReleaseReceipt = !shipment.dmpl__PerformReleaseReceipt__c;
        shipment.dmpl__PerformReleaseReceipt__c = newPerformReleaseReceipt;
        
        update shipment;
        
        dmpl__Shipment__c updatedShipment = ShipmentTestDataHelper.getShipment();
        System.assertEquals(newPerformReleaseReceipt, updatedShipment.dmpl__PerformReleaseReceipt__c, 'Shipment PerformReleaseReceipt should be updated.');
    }

    @isTest
    static void updateShipmentLinePositive() {
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.getShipmentLine();
        System.assertNotEquals(null, shipmentLine);
        shipmentLine.dmpl__Quantity__c = 5;
        update shipmentLine;
        dmpl__ShipmentLine__c updatedShipmentLine = ShipmentTestDataHelper.getShipmentLine();
        System.assertEquals(5, updatedShipmentLine.dmpl__Quantity__c);
    }
    
    
    @isTest
    static void deleteSaleInvoice() {
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.getShipment();
        System.assertNotEquals(null, shipment, 'Shipment should exist before delete.');
        
        delete shipment;
        
        dmpl__Shipment__c deletedShipment;
        try {
            deletedShipment = ShipmentTestDataHelper.getShipment();
        } catch (Exception e) {
            deletedShipment = null;
        }
        System.assertEquals(null, deletedShipment, 'Shipment should be deleted and not found in query.');
    }

    @isTest
    static void deleteShipmentLine() {
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.getShipmentLine();
        System.assertNotEquals(null, shipmentLine, 'ShipmentLine should exist before delete.');
        
        delete shipmentLine;
        
        dmpl__ShipmentLine__c deletedShipmentLine;
        try {
            deletedShipmentLine = ShipmentTestDataHelper.getShipmentLine();
        } catch (Exception e) {
            deletedShipmentLine = null;
        }
        System.assertEquals(null, deletedShipmentLine, 'ShipmentLine should be deleted and not found in query.');
    }
}