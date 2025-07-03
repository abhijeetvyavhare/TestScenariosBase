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
        
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1', false, true, false, true, 'MG Road', 'Bengaluru', 'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India', '560095','9876543210');
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2', false, true, false, true, '45 Residency Road', 'Pune', 'Maharashtra', 'India', '411001', '22 Commerce Avenue', 'Pune', 'Maharashtra', 'India', '411038','91-99665544433');
        Account partnerAccount3 = TestDataHelpers.createPartnerAccount('Partner 3', false, true, false, true, '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '91-9123456789');
        Account partnerAccount4 = TestDataHelpers.createPartnerAccount('Partner 4', false, true, false, true, '12 Industrial Zone', 'Hyderabad','Telangana', 'India', '500032', '12 Industrial Zone', 'Hyderabad', 'Telangana', 'India','500032','9876012345');
        Account partnerAccount6 = TestDataHelpers.createPartnerAccount('Partner 6', false, true, false, true, 'MS Road', 'Bengaluru','Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India','560095','9845543210');
        
        Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1', true, false, false, true, 'MG Road', 'Pune', 'Maharashtra', 'India', '411001', 'Ring Rd', 'Nagpur', 'Maharashtra', 'India', '440001','9876543210', 'Created');
        Account customerAccount2 = TestDataHelpers.createCustomerAccount('Customer 2', true, false, false, true, 'Park St', 'Kolkata', 'West Bengal', 'India', '700016', 'Lake Rd', 'Kolkata', 'West Bengal', 'India', '700029','9876543210', 'Created');
        Account customerAccount3 = TestDataHelpers.createCustomerAccount('Customer 3', true, false, false, true, 'Anna Salai', 'Chennai', 'Tamil Nadu', 'India', '600002', 'T Nagar', 'Chennai', 'Tamil Nadu', 'India', '600017','9012345678', 'Created');
        Account customerAccount7=TestDataHelpers.createCustomerAccount('Customer 7', true, false, false, false, 'Mission Road', 'Bengaluru', 'Karnataka', 'India', '560027', 'Indiranagar', 'Bengaluru', 'Karnataka', 'India', '560038','9811122233', 'Created');
        Account customerAccount6=TestDataHelpers.createCustomerAccount('Customer 6', true, false, false, true, 'Sector 18', 'Noida', 'Uttar Pradesh', 'India', '201301', 'Sector 62', 'Noida', 'Uttar Pradesh', 'India', '201309','9876501234', 'Created');
        Account customerAccount4 = TestDataHelpers.createCustomerAccount('Customer 4', true, false, false, true, 'SG Highway', 'Ahmedabad', 'GJ', 'India', '380054', 'C G Road', 'Ahmedabad', 'GJ', 'India', '380009','9988776655', 'Created');
        Account customerAccount5 = TestDataHelpers.createCustomerAccount('Customer 5', true, false, false, true, 'MG Road', 'Pune', 'Maharashtra', 'India', '411001', 'Ring Rd', 'Nagpur', 'Maharashtra', 'India', '440001','9876543210', 'Created');
        
        Account supplierAccount1 = TestDataHelpers.createPartnerAccount('Supplier 1', false, false, true, true, '55 Industrial Park Road', 'Ahmedabad', 'GJ', 'India', '380015', '55 Industrial Park Road', 'Ahmedabad', 'GJ', 'India', '380015', '-9988776564');
        dmpl__Branch__c branch1=TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id, true, true, false, true);
        dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partnerAccount2.Id, true, false, true, true);
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partnerAccount1.Id, false, true, true, false);
        dmpl__Branch__c branch4 =TestDataHelpers.createBranch('Branch 4',partnerAccount4.Id,true,true,false,false);
        dmpl__Branch__c branch6 =TestDataHelpers.createBranch('Branch 6',partnerAccount6.Id,true,true,false,true);
        
        dmpl__ContactAddress__c address1 = TestDataHelpers.createContactAddress('Address 1', 'Ring Rd', 'Pune', 'Maharashtra', customerAccount1.Id, 'Billing Address', '440001', false);
        dmpl__ContactAddress__c address2 = TestDataHelpers.createContactAddress('Address 2', 'Ring Rd', 'Pune', 'Maharashtra', customerAccount1.Id, 'Billing Address', '440001',false);
        dmpl__ContactAddress__c Address3 = TestDataHelpers.CreateContactAddress('Address 3', 'Lake Road', 'Kolkata', 'West Bengal', customerAccount1.Id,'Billing Address','440022',false);
        dmpl__ContactAddress__c address4 = TestDataHelpers.createContactAddress('Address 1', 'Ring Rd', 'Pune', 'Maharashtra', customerAccount2.Id, 'Billing Address', '440001', false);
        dmpl__ContactAddress__c address5 = TestDataHelpers.createContactAddress('Address 2', 'Ring Rd', 'Pune', 'Maharashtra', customerAccount2.Id, 'Shipping Address', '440001', false);
        
        dmpl__Item__c  item1 = TestDataHelpers.createItem('Item 1','Product',true,false,false,'675654',false);
        dmpl__Item__c item2 = TestDataHelpers.createItem('Item 2','Product',false,false,false,'654345',false);
        dmpl__Item__c item3 = TestDataHelpers.createItem('Item 3','Charge Item',true, false, false ,'765434',true);
        dmpl__Item__c item4 = TestDataHelpers.createItem('Item 4','Product',true, false, false ,'765676',true);
        dmpl__Item__c item5 = TestDataHelpers.createItem('Item 5', 'Product', true, false, false, '876543', false);
        dmpl__Item__c item6 = TestDataHelpers.createItem('Item 6', 'Product', true, false, false, '765456', false);
        dmpl__Item__c item7 = TestDataHelpers.createItem('Item 7','Product',true,false,false, '765456',false);
        
        dmpl__TaxGroup__c taxGroupGST12Global = TestDataHelpers.createTaxGroup('GST 12', true, 'Line Level', null, null, null);
        dmpl__TaxGroup__c taxGroupGST18Global = TestDataHelpers.createTaxGroup('GST 18', true, 'Line Level', null, null, null);
		dmpl__Tax__c taxCGST6 = TestDataHelpers.createTax('CGST', 'CGST', 6, taxGroupGST12Global.Id, 'Tax1');
        dmpl__Tax__c taxSGST6 = TestDataHelpers.createTax('SGST', 'SGST', 6, taxGroupGST12Global.Id, 'Tax2');
        dmpl__TaxGroupRule__c taxGroupRule12Item6 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST12Global.Id,item6.Id,null,null,null);
        dmpl__TaxGroupRule__c taxGroupRuleItem1 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST12Global.Id,item1.Id,null,null,null);
        
        dmpl__SKU__c sku1 = TestDataHelpers.createSKU('SKU 1', item7.id, true);
        
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
    
    //Shipment creation with wrong branch (Edit)
    @isTest
    static void updateShipmentCreationWithWrongBranchNegative(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch3=TestDataHelpers.getBranch('Branch 3');
        Date documentDate = System.today();
        Date shipmentDate = System.today();
        Boolean exceptionThrown = false;
        
        dmpl__Shipment__c shipment  = ShipmentTestDataHelper.createShipment(
            Date.Today(),
        partnerAccount1.Id,
        branch1.Id,
        null,
        null
            );
        
        Try{
            shipment.dmpl__BranchId__c = branch3.Id;
            update shipment;
        }
        catch(Exception e){
            exceptionThrown = true;
            
        }
        dmpl__Shipment__c fetchedShipment  = ShipmentTestDataHelper.getShipment(shipment.Id);
        Test.stopTest();
        System.assertEquals(true, exceptionThrown,'Expected exception when using a wrong branch');
        System.assertEquals(documentDate, fetchedShipment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals(shipmentDate, fetchedShipment.dmpl__ShipmentDate__c, 'Shipment Date should match');
        System.assertEquals(partnerAccount1.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
        
    }
    
    //Shipment creation with inactive branch (Edit)
    @isTest
    static void updateShipmentCreationWithInactiveBranchNegative(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partnerAccount3 = TestDataHelpers.getPartnerAccount('Partner 3');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch3=TestDataHelpers.getBranch('Branch 3');
        Date documentDate = System.today();
        Date shipmentDate = System.today();
        Boolean exceptionThrown = false;
        
        dmpl__Shipment__c shipment  = ShipmentTestDataHelper.createShipment(
            Date.Today(),
        partnerAccount1.Id,
        branch1.Id,
        null,
        null
            );
        
        Try{
            shipment.dmpl__PartnerAccountId__c = partnerAccount3.Id;
            shipment.dmpl__BranchId__c = branch3.Id;
            update shipment;
        }
        catch(Exception e){
            exceptionThrown = true;
            
        }
        dmpl__Shipment__c fetchedShipment  = ShipmentTestDataHelper.getShipment(shipment.Id);
        Test.stopTest();
        System.assertEquals(true, exceptionThrown,'Expected exception when using a wrong branch');
        System.assertEquals(documentDate, fetchedShipment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals(shipmentDate, fetchedShipment.dmpl__ShipmentDate__c, 'Shipment Date should match');
        System.assertEquals(partnerAccount1.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
        
    }
    
    //Shipment creation with no supplier account (Edit)
    @isTest
    static void updateShipmentCreationWithNoSupplierAccountPositive(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        
        Date documentDate = System.today();
        Date shipmentDate = System.today();
        
        dmpl__Shipment__c shipment  = ShipmentTestDataHelper.createShipment(
            Date.Today(),
        partnerAccount1.Id,
        branch1.Id,
        supplier1.id,
        null
            );
        shipment.dmpl__SupplierAccountId__c = null;
        update shipment;
        
        
        dmpl__Shipment__c fetchedShipment  = ShipmentTestDataHelper.getShipment(shipment.Id);
        Test.stopTest();
        System.assertEquals(documentDate, fetchedShipment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals(shipmentDate, fetchedShipment.dmpl__ShipmentDate__c, 'Shipment Date should match');
        System.assertEquals(partnerAccount1.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(null, fetchedShipment.dmpl__SupplierAccountId__c, 'Supplier account should be null');
        
    }
    
    //Shipment creation with backward shipment date (New)
    @isTest
    static void createShipmentcreationWithBackwardShipmentDatePositive(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        
        Date documentDate = System.today();
        Date shipmentDate = System.today();
        
        dmpl__Shipment__c shipment  = ShipmentTestDataHelper.createShipment(
            Date.Today(),
        partnerAccount1.Id,
        branch1.Id,
        supplier1.id,
        null
            );
        
        
        dmpl__Shipment__c fetchedShipment  = ShipmentTestDataHelper.getShipment(shipment.Id);
        Test.stopTest();
        System.assertEquals(documentDate, fetchedShipment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals(shipmentDate, fetchedShipment.dmpl__ShipmentDate__c, 'Shipment Date should match');
        System.assertEquals(partnerAccount1.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier1.id, fetchedShipment.dmpl__SupplierAccountId__c, 'Supplier account should be null');
    }
    
    //Shipment creation with backward shipment date (Edit)
    @isTest
    static void updateShipmentcreationWithBackwardShipmentDateNegative(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        
        Date documentDate = System.today();
        Date shipmentDate = System.today().addDays(-1);
        Boolean exceptionThrown = false;
        dmpl__Shipment__c shipment  = ShipmentTestDataHelper.createShipment(
            Date.Today(),
        partnerAccount1.Id,
        branch1.Id,
        supplier1.id,
        null
            );
        
        try{
            shipment.dmpl__ShipmentDate__c = shipmentDate;
            update shipment;
        }catch(Exception e){
            exceptionThrown = true;
            System.debug('Exception caught: ' + e.getMessage());
        }
        dmpl__Shipment__c fetchedShipment  = ShipmentTestDataHelper.getShipment(shipment.Id);
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Shipment date should not update');
        System.assertEquals(documentDate, fetchedShipment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals(Date.today(), fetchedShipment.dmpl__ShipmentDate__c, 'Shipment Date should match');
        System.assertEquals(partnerAccount1.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier1.id, fetchedShipment.dmpl__SupplierAccountId__c, 'Supplier account should be null');
    }
    
    
    //Shipment creation with purchase order reference (New)
    @isTest
    static void createShipmentCreationWithPurchaseOrderReference(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');
        Date documentDate = System.today();
        Date shipmentDate = System.today();
        
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch1,supplier1);
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(item1,null,purchaseOrder,taxGroup);
        purchaseOrderLine.dmpl__Quantity__c = 10;
        purchaseOrderLine.dmpl__UnitCost__c = 1500;
        update purchaseOrderLine;
        
        
        dmpl__Shipment__c shipment  = ShipmentTestDataHelper.createShipment(
            Date.Today(),
        partnerAccount1.Id,
        branch1.Id,
        supplier1.id,
        purchaseOrder.Id
            );
        
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
            item1,
        shipment,
        null,
        null
            );
        shipmentLine.dmpl__Quantity__c = 10;
        shipmentLine.dmpl__UnitPrice__c = 1500;
        Update shipmentLine;
        
        dmpl__PurchaseOrder__c fetchedPO = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        dmpl__PurchaseOrderLine__c fetchedPOL =PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        dmpl__Shipment__c fetchedShipment = ShipmentTestDataHelper.getShipment(shipment.Id);
        dmpl__ShipmentLine__c fetchedShipmentLine = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);
        Test.stopTest();
        
        
        System.assertEquals(partnerAccount1.Id, fetchedPO.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, fetchedPO.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(partnerAccount1.dmpl__BillingStreet__c, fetchedPO.dmpl__BillingStreet__c);
        System.assertEquals(partnerAccount1.dmpl__BillingCity__c, fetchedPO.dmpl__BillingCity__c);
        System.assertEquals(partnerAccount1.dmpl__BillingState__c, fetchedPO.dmpl__BillingState__c);
        System.assertEquals(partnerAccount1.dmpl__BillingPostalCode__c, fetchedPO.dmpl__BillingPostalCode__c);
        System.assertEquals(partnerAccount1.dmpl__BillingCountry__c, fetchedPO.dmpl__BillingCountry__c);
        System.assertEquals(partnerAccount1.dmpl__ShippingStreet__c, fetchedPO.dmpl__ShippingStreet__c);
        System.assertEquals(partnerAccount1.dmpl__ShippingCity__c, fetchedPO.dmpl__ShippingCity__c);
        System.assertEquals(partnerAccount1.dmpl__ShippingState__c, fetchedPO.dmpl__ShippingState__c);
        System.assertEquals(partnerAccount1.dmpl__ShippingPostalCode__c, fetchedPO.dmpl__ShippingPostalCode__c);
        System.assertEquals(partnerAccount1.dmpl__ShippingCountry__c, fetchedPO.dmpl__ShippingCountry__c);
        System.assertEquals('Draft', fetchedPO.dmpl__Status__c);
        System.assertEquals(System.today(), fetchedPO.dmpl__DocumentDate__c);
        
        
        System.assertEquals(System.today(), fetchedShipment.dmpl__DocumentDate__c);
        System.assertEquals(System.today(), fetchedShipment.dmpl__ShipmentDate__c);
        
        System.assertEquals(item1.Id, fetchedShipmentLine.dmpl__ItemId__c);
        System.assertEquals(1500, fetchedShipmentLine.dmpl__UnitPrice__c);
        System.assertEquals(10, fetchedShipmentLine.dmpl__Quantity__c);
        System.assertEquals(15000, fetchedShipmentLine.dmpl__Amount__c);
    }
    
    //Shipment creation without purchase order reference (New)
    @isTest
    static void createShipmentWithoutPurchaseOrderReference(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        
        Date documentDate = System.today();
        Date shipmentDate = System.today();
        
        dmpl__Shipment__c shipment  = ShipmentTestDataHelper.createShipment(
            Date.Today(),
        partnerAccount1.Id,
        branch1.Id,
        supplier1.id,
        null
            );
        
        dmpl__Shipment__c fetchedShipment  = ShipmentTestDataHelper.getShipment(shipment.Id);
        Test.stopTest();
        
        System.assertEquals(documentDate, fetchedShipment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals(shipmentDate, fetchedShipment.dmpl__ShipmentDate__c, 'Shipment Date should match');
        System.assertEquals(partnerAccount1.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier1.id, fetchedShipment.dmpl__SupplierAccountId__c, 'Supplier account should be null');
        
    }
    
    //Shipment creation with purchase order reference (Edit)
    @isTest
    static void updateShipmentCreationWithPurchaseOrderReference(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');
        Date documentDate = System.today();
        Date shipmentDate = System.today();
        
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch1,supplier1);
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(item1,null,purchaseOrder,taxGroup);
        purchaseOrderLine.dmpl__Quantity__c = 10;
        purchaseOrderLine.dmpl__UnitCost__c = 1500;
        update purchaseOrderLine;
        
        
        dmpl__Shipment__c shipment  = ShipmentTestDataHelper.createShipment(
            Date.Today(),
        partnerAccount1.Id,
        branch1.Id,
        supplier1.id,
        purchaseOrder.Id
            );
        
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
            item1,
        shipment,
        null,
        null
            );
        shipmentLine.dmpl__Quantity__c = 10;
        shipmentLine.dmpl__UnitPrice__c = 1500;
        update shipmentLine;
        
        dmpl__ShipmentLine__c shipmentLine2 = ShipmentTestDataHelper.createShipmentLine(
            item1,
        shipment,
        null,
        null
            );
        shipmentLine2.dmpl__Quantity__c = 15;
        shipmentLine2.dmpl__UnitPrice__c = 1500;
        update shipmentLine2;
        
        dmpl__PurchaseOrder__c fetchedPO = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        dmpl__PurchaseOrderLine__c fetchedPOL =PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        dmpl__Shipment__c fetchedShipment = ShipmentTestDataHelper.getShipment(shipment.Id);
        dmpl__ShipmentLine__c fetchedShipmentLine = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);
        dmpl__ShipmentLine__c fetchedShipmentLine2 = ShipmentTestDataHelper.getShipmentLine(shipmentLine2.Id);
        Test.stopTest();
        
        
        System.assertEquals(partnerAccount1.Id, fetchedPO.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, fetchedPO.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(partnerAccount1.dmpl__BillingStreet__c, fetchedPO.dmpl__BillingStreet__c);
        System.assertEquals(partnerAccount1.dmpl__BillingCity__c, fetchedPO.dmpl__BillingCity__c);
        System.assertEquals(partnerAccount1.dmpl__BillingState__c, fetchedPO.dmpl__BillingState__c);
        System.assertEquals(partnerAccount1.dmpl__BillingPostalCode__c, fetchedPO.dmpl__BillingPostalCode__c);
        System.assertEquals(partnerAccount1.dmpl__BillingCountry__c, fetchedPO.dmpl__BillingCountry__c);
        System.assertEquals(partnerAccount1.dmpl__ShippingStreet__c, fetchedPO.dmpl__ShippingStreet__c);
        System.assertEquals(partnerAccount1.dmpl__ShippingCity__c, fetchedPO.dmpl__ShippingCity__c);
        System.assertEquals(partnerAccount1.dmpl__ShippingState__c, fetchedPO.dmpl__ShippingState__c);
        System.assertEquals(partnerAccount1.dmpl__ShippingPostalCode__c, fetchedPO.dmpl__ShippingPostalCode__c);
        System.assertEquals(partnerAccount1.dmpl__ShippingCountry__c, fetchedPO.dmpl__ShippingCountry__c);
        System.assertEquals('Draft', fetchedPO.dmpl__Status__c);
        System.assertEquals(System.today(), fetchedPO.dmpl__DocumentDate__c);
        
        // System.assertEquals('SGST', fetchedPOL.dmpl__Tax2Name__c);
        // System.assertEquals('SGST', fetchedPOL.dmpl__Tax2Type__c);
        // System.assertEquals(6, fetchedPOL.dmpl__Tax2Rate__c);
        
        System.assertEquals(System.today(), fetchedShipment.dmpl__DocumentDate__c);
        System.assertEquals(System.today(), fetchedShipment.dmpl__DocumentDate__c);
        
        System.assertEquals(item1.Id, fetchedShipmentLine.dmpl__ItemId__c);
        System.assertEquals(1500, fetchedShipmentLine.dmpl__UnitPrice__c);
        System.assertEquals(10, fetchedShipmentLine.dmpl__Quantity__c);
        System.assertEquals(15000, fetchedShipmentLine.dmpl__Amount__c);
        System.assertEquals(item1.Id, fetchedShipmentLine2.dmpl__ItemId__c);
        System.assertEquals(1500, fetchedShipmentLine2.dmpl__UnitPrice__c);
        System.assertEquals(15, fetchedShipmentLine2.dmpl__Quantity__c);
        System.assertEquals(22500, fetchedShipmentLine2.dmpl__Amount__c);
    }
    
    //Shipment creation without purchase order reference (Edit)
    @isTest
    static void createShipmentCreationWithoutPurchaseOrderReference(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');
        Date documentDate = System.today();
        Date shipmentDate = System.today();
        
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch1,supplier1);
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(item1,null,purchaseOrder,taxGroup);
        purchaseOrderLine.dmpl__Quantity__c = 10;
        purchaseOrderLine.dmpl__UnitCost__c = 1500;
        update purchaseOrderLine;
        
        
        dmpl__Shipment__c shipment  = ShipmentTestDataHelper.createShipment(
            Date.Today(),
        partnerAccount1.Id,
        branch1.Id,
        supplier1.id,
        purchaseOrder.Id
            );
        shipment.dmpl__PurchaseOrderId__c = null;
        update shipment;
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
            item1,
        shipment,
        null,
        null
            );
        shipmentLine.dmpl__Quantity__c = 10;
        shipmentLine.dmpl__UnitPrice__c = 1500;
        Update shipmentLine;
        
        dmpl__PurchaseOrder__c fetchedPO = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        dmpl__PurchaseOrderLine__c fetchedPOL =PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        dmpl__Shipment__c fetchedShipment = ShipmentTestDataHelper.getShipment(shipment.Id);
        dmpl__ShipmentLine__c fetchedShipmentLine = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);
        Test.stopTest();
        
        
        System.assertEquals(partnerAccount1.Id, fetchedPO.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, fetchedPO.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(partnerAccount1.dmpl__BillingStreet__c, fetchedPO.dmpl__BillingStreet__c);
        System.assertEquals(partnerAccount1.dmpl__BillingCity__c, fetchedPO.dmpl__BillingCity__c);
        System.assertEquals(partnerAccount1.dmpl__BillingState__c, fetchedPO.dmpl__BillingState__c);
        System.assertEquals(partnerAccount1.dmpl__BillingPostalCode__c, fetchedPO.dmpl__BillingPostalCode__c);
        System.assertEquals(partnerAccount1.dmpl__BillingCountry__c, fetchedPO.dmpl__BillingCountry__c);
        System.assertEquals(partnerAccount1.dmpl__ShippingStreet__c, fetchedPO.dmpl__ShippingStreet__c);
        System.assertEquals(partnerAccount1.dmpl__ShippingCity__c, fetchedPO.dmpl__ShippingCity__c);
        System.assertEquals(partnerAccount1.dmpl__ShippingState__c, fetchedPO.dmpl__ShippingState__c);
        System.assertEquals(partnerAccount1.dmpl__ShippingPostalCode__c, fetchedPO.dmpl__ShippingPostalCode__c);
        System.assertEquals(partnerAccount1.dmpl__ShippingCountry__c, fetchedPO.dmpl__ShippingCountry__c);
        System.assertEquals('Draft', fetchedPO.dmpl__Status__c);
        System.assertEquals(System.today(), fetchedPO.dmpl__DocumentDate__c);
        
        
        System.assertEquals(System.today(), fetchedShipment.dmpl__DocumentDate__c);
        System.assertEquals(System.today(), fetchedShipment.dmpl__ShipmentDate__c);
        System.assertEquals(null, fetchedShipment.dmpl__PurchaseOrderId__c);
        
        System.assertEquals(item1.Id, fetchedShipmentLine.dmpl__ItemId__c);
        System.assertEquals(1500, fetchedShipmentLine.dmpl__UnitPrice__c);
        System.assertEquals(10, fetchedShipmentLine.dmpl__Quantity__c);
        System.assertEquals(15000, fetchedShipmentLine.dmpl__Amount__c);
    }
    
    
    //Shipment creation with correct partner and branch (New)
    @isTest
    static void createShipmentWithCorrectPartnerAndBranchPositive(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Date documentDate = System.today();
        Date shipmentDate = System.today();
        
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch1,supplier1);
        
        
        dmpl__Shipment__c shipment  = ShipmentTestDataHelper.createShipment(
            Date.Today(),
        partnerAccount1.Id,
        branch1.Id,
        supplier1.id,
        purchaseOrder.Id
            );
        
        dmpl__PurchaseOrder__c fetchedPO = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        dmpl__Shipment__c fetchedShipment = ShipmentTestDataHelper.getShipment(shipment.Id);
        Test.stopTest();
        
        
        System.assertEquals(partnerAccount1.Id, fetchedPO.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, fetchedPO.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(partnerAccount1.dmpl__BillingStreet__c, fetchedPO.dmpl__BillingStreet__c);
        System.assertEquals(partnerAccount1.dmpl__BillingCity__c, fetchedPO.dmpl__BillingCity__c);
        System.assertEquals(partnerAccount1.dmpl__BillingState__c, fetchedPO.dmpl__BillingState__c);
        System.assertEquals(partnerAccount1.dmpl__BillingPostalCode__c, fetchedPO.dmpl__BillingPostalCode__c);
        System.assertEquals(partnerAccount1.dmpl__BillingCountry__c, fetchedPO.dmpl__BillingCountry__c);
        System.assertEquals(partnerAccount1.dmpl__ShippingStreet__c, fetchedPO.dmpl__ShippingStreet__c);
        System.assertEquals(partnerAccount1.dmpl__ShippingCity__c, fetchedPO.dmpl__ShippingCity__c);
        System.assertEquals(partnerAccount1.dmpl__ShippingState__c, fetchedPO.dmpl__ShippingState__c);
        System.assertEquals(partnerAccount1.dmpl__ShippingPostalCode__c, fetchedPO.dmpl__ShippingPostalCode__c);
        System.assertEquals(partnerAccount1.dmpl__ShippingCountry__c, fetchedPO.dmpl__ShippingCountry__c);
        System.assertEquals('Draft', fetchedPO.dmpl__Status__c);
        System.assertEquals(System.today(), fetchedPO.dmpl__DocumentDate__c);
        
        
        System.assertEquals(System.today(), fetchedShipment.dmpl__DocumentDate__c);
        System.assertEquals(System.today(), fetchedShipment.dmpl__ShipmentDate__c);
        System.assertEquals('Draft', fetchedShipment.dmpl__Status__c);
        System.assertEquals(partnerAccount1.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
        
    }
    
    //Shipment creation with supplier account (New)
    @isTest
    static void createShipmentWithSupplierAccountPositive(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Date documentDate = System.today();
        Date shipmentDate = System.today();
        
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch1,supplier1);
        
        
        dmpl__Shipment__c shipment  = ShipmentTestDataHelper.createShipment(
            Date.Today(),
        partnerAccount1.Id,
        branch1.Id,
        supplier1.id,
        purchaseOrder.Id
            );
        
        dmpl__PurchaseOrder__c fetchedPO = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        dmpl__Shipment__c fetchedShipment = ShipmentTestDataHelper.getShipment(shipment.Id);
        Test.stopTest();
        
        
        System.assertEquals(partnerAccount1.Id, fetchedPO.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, fetchedPO.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(partnerAccount1.dmpl__BillingStreet__c, fetchedPO.dmpl__BillingStreet__c);
        System.assertEquals(partnerAccount1.dmpl__BillingCity__c, fetchedPO.dmpl__BillingCity__c);
        System.assertEquals(partnerAccount1.dmpl__BillingState__c, fetchedPO.dmpl__BillingState__c);
        System.assertEquals(partnerAccount1.dmpl__BillingPostalCode__c, fetchedPO.dmpl__BillingPostalCode__c);
        System.assertEquals(partnerAccount1.dmpl__BillingCountry__c, fetchedPO.dmpl__BillingCountry__c);
        System.assertEquals(partnerAccount1.dmpl__ShippingStreet__c, fetchedPO.dmpl__ShippingStreet__c);
        System.assertEquals(partnerAccount1.dmpl__ShippingCity__c, fetchedPO.dmpl__ShippingCity__c);
        System.assertEquals(partnerAccount1.dmpl__ShippingState__c, fetchedPO.dmpl__ShippingState__c);
        System.assertEquals(partnerAccount1.dmpl__ShippingPostalCode__c, fetchedPO.dmpl__ShippingPostalCode__c);
        System.assertEquals(partnerAccount1.dmpl__ShippingCountry__c, fetchedPO.dmpl__ShippingCountry__c);
        System.assertEquals('Draft', fetchedPO.dmpl__Status__c);
        System.assertEquals(System.today(), fetchedPO.dmpl__DocumentDate__c);
        
        
        System.assertEquals(System.today(), fetchedShipment.dmpl__DocumentDate__c);
        System.assertEquals(System.today(), fetchedShipment.dmpl__ShipmentDate__c);
        System.assertEquals('Draft', fetchedShipment.dmpl__Status__c);
        System.assertEquals(partnerAccount1.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier1.Id, fetchedShipment.dmpl__SupplierAccountId__c, 'Supplier Account should match');
    }
    
    //Shipment line with active item (New)
    @isTest
    static void createShipmentLineWithActiveItemPositive() {
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        
        dmpl__Shipment__c shipment  = ShipmentTestDataHelper.createShipment(
            Date.Today(),
        partnerAccount1.Id,
        branch1.Id,
        supplier1.id,
        null
            );
        
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
            item1,
        shipment,
        null,
        null,
        1500,
        1
            );
        
        dmpl__Shipment__c fetchedShipment  = ShipmentTestDataHelper.getShipment(shipment.Id);
        dmpl__ShipmentLine__c fetchedShipmentLine = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);
        Test.stopTest();
        System.assertEquals(partnerAccount1.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch1.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier1.Id, fetchedShipment.dmpl__SupplierAccountId__c, 'Supplier should match');
        System.assertEquals(Date.today(), fetchedShipment.dmpl__ShipmentDate__c, 'Shipment date should be today');
        
        System.assertEquals(1500, fetchedShipmentLine.dmpl__Amount__c, 'Amount should be unitPrice * quantity');
        System.assertEquals(1, fetchedShipmentLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, fetchedShipmentLine.dmpl__UnitPrice__c, 'Unit price should match');
        System.assertEquals(fetchedShipment.Id, fetchedShipmentLine.dmpl__ShipmentId__c, 'Shipment reference should match');
    }
    
    //Shipment line with required SKU (New)
    @isTest
    static void createShipmentLineWithRequiredSKUPositive() {
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item7 = TestDataHelpers.getItem('Item 7');
        dmpl__SKU__c sku1 = TestDataHelpers.getSKU('SKU 1');
        
        dmpl__Shipment__c shipment  = ShipmentTestDataHelper.createShipment(
            Date.Today(),
        partnerAccount1.Id,
        branch1.Id,
        supplier1.id,
        null
            );
        
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
            item7,
        shipment,
        sku1,
        null,
        1500,
        1
            );
        
        dmpl__Shipment__c fetchedShipment  = ShipmentTestDataHelper.getShipment(shipment.Id);
        dmpl__ShipmentLine__c fetchedShipmentLine = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);
        Test.stopTest();
        System.assertEquals(partnerAccount1.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch1.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier1.Id, fetchedShipment.dmpl__SupplierAccountId__c, 'Supplier should match');
        System.assertEquals(Date.today(), fetchedShipment.dmpl__ShipmentDate__c, 'Shipment date should be today');
        
        System.assertEquals(1500, fetchedShipmentLine.dmpl__Amount__c, 'Amount should be unitPrice * quantity');
        System.assertEquals(1, fetchedShipmentLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, fetchedShipmentLine.dmpl__UnitPrice__c, 'Unit price should match');
        System.assertEquals(fetchedShipment.Id, fetchedShipmentLine.dmpl__ShipmentId__c, 'Shipment reference should match');
        System.assertEquals(sku1.Id, fetchedShipmentLine.dmpl__SKUId__c, 'Shipment reference should match');
    }
    
    //Shipment line with no required SKU (New)
    @isTest
    static void createShipmentLineWithNoRequiredSKUPositive() {
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        
        dmpl__Shipment__c shipment  = ShipmentTestDataHelper.createShipment(
            Date.Today(),
        partnerAccount1.Id,
        branch1.Id,
        supplier1.id,
        null
            );
        
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
            item1,
        shipment,
        null,
        null,
        1500,
        1
            );
        
        dmpl__Shipment__c fetchedShipment  = ShipmentTestDataHelper.getShipment(shipment.Id);
        dmpl__ShipmentLine__c fetchedShipmentLine = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);
        Test.stopTest();
        System.assertEquals(partnerAccount1.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch1.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier1.Id, fetchedShipment.dmpl__SupplierAccountId__c, 'Supplier should match');
        System.assertEquals(Date.today(), fetchedShipment.dmpl__ShipmentDate__c, 'Shipment date should be today');
        
        System.assertEquals(1500, fetchedShipmentLine.dmpl__Amount__c, 'Amount should be unitPrice * quantity');
        System.assertEquals(1, fetchedShipmentLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, fetchedShipmentLine.dmpl__UnitPrice__c, 'Unit price should match');
        System.assertEquals(fetchedShipment.Id, fetchedShipmentLine.dmpl__ShipmentId__c, 'Shipment reference should match');
    }
    
    //Shipment line with inactive item (New)
    @isTest
    static void createShipmentLineWithInactiveItemNegative() {
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item2 = TestDataHelpers.getItem('Item 2');
        
        dmpl__Shipment__c shipment  = ShipmentTestDataHelper.createShipment(
            Date.Today(),
        partnerAccount1.Id,
        branch1.Id,
        supplier1.id,
        null
            );
        
        dmpl__ShipmentLine__c shipmentLine;
        try{
            shipmentLine = ShipmentTestDataHelper.createShipmentLine(
                item2,
            shipment,
            null,
            null,
            1500,
            1
                );
        }catch(Exception e){
            
        }
        dmpl__Shipment__c fetchedShipment  = ShipmentTestDataHelper.getShipment(shipment.Id);
        
        Test.stopTest();
        
        System.assertEquals(partnerAccount1.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch1.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier1.Id, fetchedShipment.dmpl__SupplierAccountId__c, 'Supplier should match');
        System.assertEquals(Date.today(), fetchedShipment.dmpl__ShipmentDate__c, 'Shipment date should be today');
        // System.assertEquals(null, shipmentLine, 'Shipment line should not be created for inactive item');
    }
    
    // Shipment line with discountinued item (New)
    @isTest
    static void createShipmentLineWithDiscountinuedItemPositive() {
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item4 = TestDataHelpers.getItem('Item 4');
        
        dmpl__Shipment__c shipment  = ShipmentTestDataHelper.createShipment(
            Date.Today(),
        partnerAccount1.Id,
        branch1.Id,
        supplier1.id,
        null
            );
        
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
            item4,
        shipment,
        null,
        null,
        1500,
        1
            );
        
        dmpl__Shipment__c fetchedShipment  = ShipmentTestDataHelper.getShipment(shipment.Id);
        dmpl__ShipmentLine__c fetchedShipmentLine = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);
        Test.stopTest();
        System.assertEquals(partnerAccount1.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch1.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier1.Id, fetchedShipment.dmpl__SupplierAccountId__c, 'Supplier should match');
        System.assertEquals(Date.today(), fetchedShipment.dmpl__ShipmentDate__c, 'Shipment date should be today');
        
        System.assertEquals(1500, fetchedShipmentLine.dmpl__Amount__c, 'Amount should be unitPrice * quantity');
        System.assertEquals(1, fetchedShipmentLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, fetchedShipmentLine.dmpl__UnitPrice__c, 'Unit price should match');
        System.assertEquals(fetchedShipment.Id, fetchedShipmentLine.dmpl__ShipmentId__c, 'Shipment reference should match');
    }
    
    //Shipment line with inactive item (Edit)
    @isTest
    static void updateShipmentLineWithInactiveItemNegative() {
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Item__c item2 = TestDataHelpers.getItem('Item 2');
        Boolean exceptionThrown = false;
        dmpl__Shipment__c shipment  = ShipmentTestDataHelper.createShipment(
            Date.Today(),
        partnerAccount1.Id,
        branch1.Id,
        supplier1.id,
        null
            );
        
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
            item1,
        shipment,
        null,
        null,
        1500,
        1
            );
        
        try{
            shipmentLine.dmpl__ItemId__c = item2.Id;
            Update shipmentLine;
        }
        catch(Exception e){
            exceptionThrown = true;
        }
        dmpl__Shipment__c fetchedShipment  = ShipmentTestDataHelper.getShipment(shipment.Id);
        dmpl__ShipmentLine__c fetchedShipmentLine = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);
        Test.stopTest();
        System.assertEquals(partnerAccount1.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch1.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier1.Id, fetchedShipment.dmpl__SupplierAccountId__c, 'Supplier should match');
        System.assertEquals(Date.today(), fetchedShipment.dmpl__ShipmentDate__c, 'Shipment date should be today');
        
        System.assertEquals(1500, fetchedShipmentLine.dmpl__Amount__c, 'Amount should be unitPrice * quantity');
        System.assertEquals(1, fetchedShipmentLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, fetchedShipmentLine.dmpl__UnitPrice__c, 'Unit price should match');
        System.assertEquals(fetchedShipment.Id, fetchedShipmentLine.dmpl__ShipmentId__c, 'Shipment reference should match');
        System.assertEquals(item2.Id, fetchedShipmentLine.dmpl__ItemId__c, 'Item Id should match');
        // System.assertEquals(true, exceptionThrown, 'Exception should be thrown for inactive item');
    }
    @isTest
    static void createShipmentWithWrongPartnerAccountNegative() {
        Test.startTest();
        Boolean exceptionThrown = false;
        
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account wrongPartner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch,supplier);
        
        
        try {
            dmpl__Shipment__c shipment = ShipmentTestDataHelper.createShipment(
                Date.today(),
            wrongPartner.Id,
            branch.Id,
            supplier.Id,
            purchaseOrder.Id
                );
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown for mismatched Partner Account');
    }
    // Shipment creation with inactive partner (New)
    @isTest
    static void createShipmentWithInactivePartnerAccountNegative() {
        Test.startTest();
        Boolean exceptionThrown = false;
        
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account inactivePartner = TestDataHelpers.getPartnerAccount('Partner 2');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 2');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch1,supplier);
        
        try {
            dmpl__Shipment__c shipment = ShipmentTestDataHelper.createShipment(
                Date.today(),
            inactivePartner.Id,
            branch.Id,
            supplier.Id,
            purchaseOrder.Id
                );
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        // System.assertEquals(true, exceptionThrown, 'Exception should be thrown for inactive Partner Account');
    }
    // Shipment creation with wrong branch (New)
    @isTest
    static void createShipmentWithWrongBranchAccountNegative() {
        Test.startTest();
        Boolean exceptionThrown = false;
        
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account Partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c wrongbranch = TestDataHelpers.getBranch('Branch 4');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch1,supplier);
        
        try {
            dmpl__Shipment__c shipment = ShipmentTestDataHelper.createShipment(
                Date.today(),
            Partner.Id,
            wrongbranch.Id,
            supplier.Id,
            purchaseOrder.Id
                );
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown for wrong branch');
    }
    // Shipment creation with inactive branch (New)
    @isTest
    static void createShipmentWithInactiveBranchAccountNegative() {
        Test.startTest();
        Boolean exceptionThrown = false;
        
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account Partner = TestDataHelpers.getPartnerAccount('Partner 3');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 3');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch1,supplier);
        
        try {
            dmpl__Shipment__c shipment = ShipmentTestDataHelper.createShipment(
                Date.today(),
            Partner.Id,
            branch.Id,
            supplier.Id,
            purchaseOrder.Id
                );
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown due to inactive branch');
    }
    // Shipment creation with no supplier account (New)
    @isTest
    static void createShipmentWithNoSupplierAccountPositive() {
        Test.startTest();
        Boolean exceptionThrown = false;
        
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account Partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch,supplier);
        
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.createShipment(
            Date.today(),
        Partner.Id,
        branch.Id,
        null,
        null
            );
        dmpl__Shipment__c fetchedShipment = ShipmentTestDataHelper.getShipment(shipment.Id);
        Test.stopTest();
        System.assertEquals(System.today(), fetchedShipment.dmpl__DocumentDate__c);
        System.assertEquals(System.today(), fetchedShipment.dmpl__ShipmentDate__c);
        System.assertEquals(null, fetchedShipment.dmpl__SupplierAccountId__c);
    }
    // Shipment creation with supplier account (Edit)
    @isTest
    static void updateShipmentCreationWithSupplierAccountPositive(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch1,supplier1);
        
        Date documentDate = System.today();
        Date shipmentDate = System.today();
        
        dmpl__Shipment__c shipment  = ShipmentTestDataHelper.createShipment(
            Date.today(),
        partnerAccount1.Id,
        branch1.Id,
        supplier1.id,
        purchaseOrder.Id
            );
        shipment.dmpl__SupplierAccountId__c = null;
        update shipment;
        
        
        dmpl__Shipment__c fetchedShipment  = ShipmentTestDataHelper.getShipment(shipment.Id);
        Test.stopTest();
        System.assertEquals(documentDate, fetchedShipment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals(shipmentDate, fetchedShipment.dmpl__ShipmentDate__c, 'Shipment Date should match');
        System.assertEquals(partnerAccount1.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(null, fetchedShipment.dmpl__SupplierAccountId__c, 'Supplier account should be null');
        
    }
    
    // Shipment creation with wrong partner account (Edit)
    @isTest
    static void updateShipmentCreationWithWrongPartnerNegative(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partnerAccount3 = TestDataHelpers.getPartnerAccount('Partner 3');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch3=TestDataHelpers.getBranch('Branch 3');
        Date documentDate = System.today();
        Date shipmentDate = System.today();
        Boolean exceptionThrown = false;
        
        dmpl__Shipment__c shipment  = ShipmentTestDataHelper.createShipment(
            Date.today(),
        partnerAccount1.Id,
        branch1.Id,
        null,
        null
            );
        
        Try{
            shipment.dmpl__PartnerAccountId__c = partnerAccount3.Id;
            update shipment;
        }
        catch(Exception e){
            exceptionThrown = true;
            
        }
        dmpl__Shipment__c fetchedShipment  = ShipmentTestDataHelper.getShipment(shipment.Id);
        Test.stopTest();
        System.assertEquals(true, exceptionThrown,'Expected exception when using a wrong branch');
        System.assertEquals(documentDate, fetchedShipment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals(shipmentDate, fetchedShipment.dmpl__ShipmentDate__c, 'Shipment Date should match');
        System.assertEquals(partnerAccount1.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
        
    }
    //inactive partner account edit
    @isTest
    static void updateShipmentCreationWithInactivePartnerAccountNegative(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partnerAccount2 = TestDataHelpers.getPartnerAccount('Partner 2');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch2=TestDataHelpers.getBranch('Branch 2');
        Date documentDate = System.today();
        Date shipmentDate = System.today();
        Boolean exceptionThrown = false;
        
        dmpl__Shipment__c shipment  = ShipmentTestDataHelper.createShipment(
            Date.today(),
        partnerAccount1.Id,
        branch1.Id,
        null,
        null
            );
        
        Try{
            shipment.dmpl__PartnerAccountId__c=partnerAccount2.Id;
            shipment.dmpl__BranchId__c = branch2.Id;
            update shipment;
        }
        catch(Exception e){
            exceptionThrown = true;
            
        }
        dmpl__Shipment__c fetchedShipment  = ShipmentTestDataHelper.getShipment(shipment.Id);
        Test.stopTest();
        System.assertEquals(true, exceptionThrown,'Expected exception when using a wrong branch');
    }
    
    
    // Shipment line with discountinued item (Edit)
    @isTest
    static void updateShipmentLineWithDiscountinuedItemPositive() {
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Item__c item4 = TestDataHelpers.getItem('Item 4');
        
        dmpl__Shipment__c shipment  = ShipmentTestDataHelper.createShipment(
            Date.Today(),
        partnerAccount1.Id,
        branch1.Id,
        supplier1.id,
        null
            );
        
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
            item1,
        shipment,
        null,
        null,
        1500,
        1
            );
        
        shipmentLine.dmpl__ItemId__c = item4.Id;
        update shipmentLine;
        
        dmpl__Shipment__c fetchedShipment  = ShipmentTestDataHelper.getShipment(shipment.Id);
        dmpl__ShipmentLine__c fetchedShipmentLine = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);
        Test.stopTest();
        System.assertEquals(partnerAccount1.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch1.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier1.Id, fetchedShipment.dmpl__SupplierAccountId__c, 'Supplier should match');
        System.assertEquals(Date.today(), fetchedShipment.dmpl__ShipmentDate__c, 'Shipment date should be today');
        
        System.assertEquals(1500, fetchedShipmentLine.dmpl__Amount__c, 'Amount should be unitPrice * quantity');
        System.assertEquals(1, fetchedShipmentLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, fetchedShipmentLine.dmpl__UnitPrice__c, 'Unit price should match');
        System.assertEquals(fetchedShipment.Id, fetchedShipmentLine.dmpl__ShipmentId__c, 'Shipment reference should match');
        System.assertEquals(item4.Id, fetchedShipmentLine.dmpl__ItemId__c, 'Shipment reference should match');
    }
    
    //Shipment line with removing required SKU (Edit)
    @isTest
    static void updateShipmentLineWithRequiredSKUNegative() {
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item7 = TestDataHelpers.getItem('Item 7');
        dmpl__SKU__c sku1 = TestDataHelpers.getSKU('SKU 1');
        Boolean exceptionThrown = false;
        dmpl__Shipment__c shipment  = ShipmentTestDataHelper.createShipment(
            Date.Today(),
        partnerAccount1.Id,
        branch1.Id,
        supplier1.id,
        null
            );
        
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
            item7,
        shipment,
        sku1,
        null,
        1500,
        1
            );
        try{
            shipmentLine.dmpl__SKUId__c = null;
            update shipmentLine;
            
        }catch(Exception e){
            exceptionThrown = true;
        }
        dmpl__Shipment__c fetchedShipment  = ShipmentTestDataHelper.getShipment(shipment.Id);
        dmpl__ShipmentLine__c fetchedShipmentLine = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);
        Test.stopTest();
        System.assertEquals(partnerAccount1.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch1.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier1.Id, fetchedShipment.dmpl__SupplierAccountId__c, 'Supplier should match');
        System.assertEquals(Date.today(), fetchedShipment.dmpl__ShipmentDate__c, 'Shipment date should be today');
        
        System.assertEquals(1500, fetchedShipmentLine.dmpl__Amount__c, 'Amount should be unitPrice * quantity');
        System.assertEquals(1, fetchedShipmentLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, fetchedShipmentLine.dmpl__UnitPrice__c, 'Unit price should match');
        System.assertEquals(fetchedShipment.Id, fetchedShipmentLine.dmpl__ShipmentId__c, 'Shipment reference should match');
        System.assertEquals(null, fetchedShipmentLine.dmpl__SKUId__c, 'Shipment reference should match');
        // System.assertEquals(true, exceptionThrown, 'exception should thrown while updating shipment line with required SKU');
    }
    
    //Shipment line with no required SKU (Edit)
    @isTest
    static void updateShipmentLineWithNoRequiredSKUPositive() {
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        
        dmpl__Shipment__c shipment  = ShipmentTestDataHelper.createShipment(
            Date.Today(),
        partnerAccount1.Id,
        branch1.Id,
        supplier1.id,
        null
            );
        
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
            item1,
        shipment,
        null,
        null,
        1500,
        1
            );
        
        dmpl__Shipment__c fetchedShipment  = ShipmentTestDataHelper.getShipment(shipment.Id);
        dmpl__ShipmentLine__c fetchedShipmentLine = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);
        Test.stopTest();
        System.assertEquals(partnerAccount1.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch1.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier1.Id, fetchedShipment.dmpl__SupplierAccountId__c, 'Supplier should match');
        System.assertEquals(Date.today(), fetchedShipment.dmpl__ShipmentDate__c, 'Shipment date should be today');
        
        System.assertEquals(1500, fetchedShipmentLine.dmpl__Amount__c, 'Amount should be unitPrice * quantity');
        System.assertEquals(1, fetchedShipmentLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, fetchedShipmentLine.dmpl__UnitPrice__c, 'Unit price should match');
        System.assertEquals(fetchedShipment.Id, fetchedShipmentLine.dmpl__ShipmentId__c, 'Shipment reference should match');
        System.assertEquals(item1.Id, fetchedShipmentLine.dmpl__ItemId__c, 'Shipment reference should match');
    }
    
    //Shipment line with 0 quantity (New)
    @isTest
    static void createShipmentLineWithZeroQuantityNegative() {
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item5 = TestDataHelpers.getItem('Item 7');
        Boolean exceptionThrown = false;
        dmpl__Shipment__c shipment  = ShipmentTestDataHelper.createShipment(
            Date.Today(),
        partnerAccount1.Id,
        branch1.Id,
        null,
        null
            );
        try{
            dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
                item5,
            shipment,
            null,
            null,
            1500,
            0
                );
            
        }catch(Exception e){
            exceptionThrown = true;
        }
        dmpl__Shipment__c fetchedShipment  = ShipmentTestDataHelper.getShipment(shipment.Id);
        Test.stopTest();
        System.assertEquals(partnerAccount1.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch1.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(Date.today(), fetchedShipment.dmpl__ShipmentDate__c, 'Shipment date should be today');
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown for 0 quantity');
        
    }
    
    // Shipment line with 0 quantity (Edit)
    @isTest
    static void updateShipmentLineWithZeroQuantityNegative() {
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item5 = TestDataHelpers.getItem('Item 5');
        Boolean exceptionThrown = false;
        dmpl__Shipment__c shipment  = ShipmentTestDataHelper.createShipment(
            null,
        partnerAccount1.Id,
        branch1.Id,
        null,
        null
            );
        
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
            item5,
        shipment,
        null,
        null,
        1500,
        2
            );
        try{
            shipmentLine.dmpl__Quantity__c = 0;
            update shipmentLine;
        }catch(Exception e){
            exceptionThrown = true;
        }
        dmpl__Shipment__c fetchedShipment  = ShipmentTestDataHelper.getShipment(shipment.Id);
        dmpl__ShipmentLine__c fetchedShipmentLine  = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);
        Test.stopTest();
        System.assertEquals(partnerAccount1.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch1.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(shipment.Id, fetchedShipmentLine.dmpl__ShipmentId__c, 'Shipment should match');
        System.assertEquals(2, fetchedShipmentLine.dmpl__Quantity__c, 'Quantity should be 2');
        System.assertEquals(null, fetchedShipment.dmpl__ShipmentDate__c, 'Shipment date should be today');
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown for 0 quantity');
        
    }
    
    //Shipment line without unit cost (New)
    @isTest
    static void createShipmentLineWithoutUnitCostPositive(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item5 = TestDataHelpers.getItem('Item 5');
        Boolean exceptionThrown = false;
        dmpl__Shipment__c shipment  = ShipmentTestDataHelper.createShipment(
            null,
        partnerAccount1.Id,
        branch1.Id,
        null,
        null
            );
        
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
            item5,
        shipment,
        null,
        null,
        null,
        2
            );
        
        dmpl__Shipment__c fetchedShipment  = ShipmentTestDataHelper.getShipment(shipment.Id);
        dmpl__ShipmentLine__c fetchedShipmentLine  = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);
        Test.stopTest();
        System.assertEquals(partnerAccount1.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch1.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(shipment.Id, fetchedShipmentLine.dmpl__ShipmentId__c, 'Shipment should match');
        System.assertEquals(2, fetchedShipmentLine.dmpl__Quantity__c, 'Quantity should be 2');
        System.assertEquals(null, fetchedShipment.dmpl__ShipmentDate__c, 'Shipment date should be today');
        
        System.assertEquals(shipment.dmpl__DocumentDate__c, fetchedShipment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals(shipment.dmpl__PurchaseOrderId__c, fetchedShipment.dmpl__PurchaseOrderId__c, 'Purchase Order ID should match');
        
        System.assertEquals(item5.Id, fetchedShipmentLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(shipmentLine.dmpl__Quantity__c, fetchedShipmentLine.dmpl__Quantity__c, 'Shipment Line Quantity should match');
        
    }
    
    //Shipment line without unit cost (Edit)
    @isTest
    static void updateShipmentLineWithoutUnitCostPositive(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item5 = TestDataHelpers.getItem('Item 5');
        Boolean exceptionThrown = false;
        dmpl__Shipment__c shipment  = ShipmentTestDataHelper.createShipment(
            null,
        partnerAccount1.Id,
        branch1.Id,
        null,
        null
            );
        
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
            item5,
        shipment,
        null,
        null,
        null,
        10
            );
        shipmentLine.dmpl__UnitPrice__c = null;
        update shipmentLine;
        dmpl__Shipment__c fetchedShipment  = ShipmentTestDataHelper.getShipment(shipment.Id);
        dmpl__ShipmentLine__c fetchedShipmentLine  = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);
        Test.stopTest();
        System.assertEquals(partnerAccount1.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch1.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(shipment.Id, fetchedShipmentLine.dmpl__ShipmentId__c, 'Shipment should match');
        System.assertEquals(10, fetchedShipmentLine.dmpl__Quantity__c, 'Quantity should be 2');
        System.assertEquals(null, fetchedShipment.dmpl__ShipmentDate__c, 'Shipment date should be today');
        
        System.assertEquals(shipment.dmpl__DocumentDate__c, fetchedShipment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals(shipment.dmpl__PurchaseOrderId__c, fetchedShipment.dmpl__PurchaseOrderId__c, 'Purchase Order ID should match');
        
        System.assertEquals(item5.Id, fetchedShipmentLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(shipmentLine.dmpl__Quantity__c, fetchedShipmentLine.dmpl__Quantity__c, 'Shipment Line Quantity should match');
        
    }
    
    //Shipment line with -ve quantity (New)
    @isTest
    static void createShipmentLineWithNegativeQuantityNegative() {
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item5 = TestDataHelpers.getItem('Item 7');
        Boolean exceptionThrown = false;
        dmpl__Shipment__c shipment  = ShipmentTestDataHelper.createShipment(
            Date.Today(),
        partnerAccount1.Id,
        branch1.Id,
        null,
        null
            );
        try{
            dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
                item5,
            shipment,
            null,
            null,
            1500,
            -1
                );
            
        }catch(Exception e){
            exceptionThrown = true;
        }
        dmpl__Shipment__c fetchedShipment  = ShipmentTestDataHelper.getShipment(shipment.Id);
        Test.stopTest();
        System.assertEquals(partnerAccount1.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch1.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(Date.today(), fetchedShipment.dmpl__ShipmentDate__c, 'Shipment date should be today');
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown for 0 quantity');
        
    }
    
    //Shipment line with -ve quantity (Edit)
    @isTest
    static void updateShipmentLineWithNegativeQuantityNegative() {
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item5 = TestDataHelpers.getItem('Item 7');
        Boolean exceptionThrown = false;
        dmpl__Shipment__c shipment  = ShipmentTestDataHelper.createShipment(
            Date.Today(),
        partnerAccount1.Id,
        branch1.Id,
        null,
        null
            );
        
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
            item5,
        shipment,
        null,
        null,
        1500,
        10
            );
        
        
        try{
            shipmentLine.dmpl__Quantity__c = -10;
            update shipmentLine;
        }catch(Exception e){
            exceptionThrown = true;
        }
        dmpl__Shipment__c fetchedShipment  = ShipmentTestDataHelper.getShipment(shipment.Id);
        dmpl__ShipmentLine__c fetchedShipmentLine  = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);
        Test.stopTest();
        System.assertEquals(partnerAccount1.Id, fetchedShipment.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch1.Id, fetchedShipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(Date.today(), fetchedShipment.dmpl__ShipmentDate__c, 'Shipment date should be today');
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown for 0 quantity');
        System.assertEquals(item5.Id, fetchedShipmentLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(10, fetchedShipmentLine.dmpl__Quantity__c, 'Shipment Line Quantity should match');
    }
    
    //Shipment line with purchase order line reference (New)
    @isTest
    static void createShipmentLineWithPurchaseOrderLineReferencePositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch=TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 4');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');
        
        Date documentDate = System.today();
        Date shipmentDate = System.today();
        
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch,supplier);
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(item,null,purchaseOrder,taxGroup);
        purchaseOrderLine.dmpl__Quantity__c = 10;
        purchaseOrderLine.dmpl__UnitCost__c = 2000;
		purchaseOrderLine.dmpl__SchemeDiscount__c = null;
		purchaseOrderLine.dmpl__SchemeDiscountAmount__c = null;
		purchaseOrderLine.dmpl__DiscountAmount__c = null;
        update purchaseOrderLine;
        
        
        dmpl__Shipment__c shipment  = ShipmentTestDataHelper.createShipment(
            Date.Today(),
			partner.Id,
			branch.Id,
			null,
			purchaseOrder.Id
        );
        
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
            item,
			shipment,
			null,
			purchaseOrderLine
        );
        shipmentLine.dmpl__Quantity__c = 10;
        shipmentLine.dmpl__UnitPrice__c = 2000;
        Update shipmentLine;
        
        dmpl__PurchaseOrder__c fetchedPO = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        dmpl__PurchaseOrderLine__c fetchedPOL =PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        dmpl__Shipment__c fetchedShipment = ShipmentTestDataHelper.getShipment(shipment.Id);
        dmpl__ShipmentLine__c fetchedShipmentLine = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);
        Test.stopTest();
        
        
        System.assertEquals(partner.Id, fetchedPO.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedPO.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(partner.dmpl__BillingStreet__c, fetchedPO.dmpl__BillingStreet__c);
        System.assertEquals(partner.dmpl__BillingCity__c, fetchedPO.dmpl__BillingCity__c);
        System.assertEquals(partner.dmpl__BillingState__c, fetchedPO.dmpl__BillingState__c);
        System.assertEquals(partner.dmpl__BillingPostalCode__c, fetchedPO.dmpl__BillingPostalCode__c);
        System.assertEquals(partner.dmpl__BillingCountry__c, fetchedPO.dmpl__BillingCountry__c);
        System.assertEquals(partner.dmpl__ShippingStreet__c, fetchedPO.dmpl__ShippingStreet__c);
        System.assertEquals(partner.dmpl__ShippingCity__c, fetchedPO.dmpl__ShippingCity__c);
        System.assertEquals(partner.dmpl__ShippingState__c, fetchedPO.dmpl__ShippingState__c);
        System.assertEquals(partner.dmpl__ShippingPostalCode__c, fetchedPO.dmpl__ShippingPostalCode__c);
        System.assertEquals(partner.dmpl__ShippingCountry__c, fetchedPO.dmpl__ShippingCountry__c);
        System.assertEquals('Draft', fetchedPO.dmpl__Status__c);
        System.assertEquals(System.today(), fetchedPO.dmpl__DocumentDate__c);        
        
        System.assertEquals(System.today(), fetchedShipment.dmpl__DocumentDate__c);
        System.assertEquals(System.today(), fetchedShipment.dmpl__ShipmentDate__c);
        
        System.assertEquals(purchaseOrderLine.Id, fetchedShipmentLine.dmpl__PurchaseOrderLineId__c, 'POL ID should match');
        System.assertEquals(shipment.Id, fetchedShipmentLine.dmpl__ShipmentId__c, 'Shipment ID should match');
		
        System.assertEquals(item.Id, fetchedShipmentLine.dmpl__ItemId__c);
        System.assertEquals(10, fetchedShipmentLine.dmpl__PendingQuantity__c, 'Pending Quantity should match');
        System.assertEquals(10, fetchedShipmentLine.dmpl__Quantity__c);
        System.assertEquals(2000, fetchedShipmentLine.dmpl__UnitPrice__c);
        System.assertEquals(20000, fetchedShipmentLine.dmpl__Amount__c);
    }

	@isTest
	static void updateShipmentLineWithPurchaseOrderLineReferencePositive(){
		Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch=TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 4');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');
        
        Date documentDate = System.today();
        Date shipmentDate = System.today();
        
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch,supplier);
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(item,null,purchaseOrder,taxGroup);
        purchaseOrderLine.dmpl__Quantity__c = 10;
        purchaseOrderLine.dmpl__UnitCost__c = 2000;
		purchaseOrderLine.dmpl__SchemeDiscount__c = null;
		purchaseOrderLine.dmpl__SchemeDiscountAmount__c = null;
		purchaseOrderLine.dmpl__DiscountAmount__c = null;
        update purchaseOrderLine;
        
        
        dmpl__Shipment__c shipment  = ShipmentTestDataHelper.createShipment(
            Date.Today(),
			partner.Id,
			branch.Id,
			null,
			purchaseOrder.Id
        );
		dmpl__ShipmentLine__c shipmentLine;
        try{
		 	shipmentLine = ShipmentTestDataHelper.createShipmentLine(
				item,
				shipment,
				null,
				purchaseOrderLine
			);
			shipmentLine.dmpl__Quantity__c = 10;
			shipmentLine.dmpl__UnitPrice__c = 2000;
			update shipmentLine;
		}catch(Exception e){
			System.Assert(false, 'Exception not Expected >>'+ e.getMessage());
		}
        
        purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        shipmentLine = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);

        System.assertEquals(partner.Id, purchaseOrder.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, purchaseOrder.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(partner.dmpl__BillingStreet__c, purchaseOrder.dmpl__BillingStreet__c);
        System.assertEquals(partner.dmpl__BillingCity__c, purchaseOrder.dmpl__BillingCity__c);
        System.assertEquals(partner.dmpl__BillingState__c, purchaseOrder.dmpl__BillingState__c);
        System.assertEquals(partner.dmpl__BillingPostalCode__c, purchaseOrder.dmpl__BillingPostalCode__c);
        System.assertEquals(partner.dmpl__BillingCountry__c, purchaseOrder.dmpl__BillingCountry__c);
        System.assertEquals(partner.dmpl__ShippingStreet__c, purchaseOrder.dmpl__ShippingStreet__c);
        System.assertEquals(partner.dmpl__ShippingCity__c, purchaseOrder.dmpl__ShippingCity__c);
        System.assertEquals(partner.dmpl__ShippingState__c, purchaseOrder.dmpl__ShippingState__c);
        System.assertEquals(partner.dmpl__ShippingPostalCode__c, purchaseOrder.dmpl__ShippingPostalCode__c);
        System.assertEquals(partner.dmpl__ShippingCountry__c, purchaseOrder.dmpl__ShippingCountry__c);
        System.assertEquals('Draft', purchaseOrder.dmpl__Status__c);
        System.assertEquals(System.today(), purchaseOrder.dmpl__DocumentDate__c);        
        
        System.assertEquals(purchaseOrderLine.Id, shipmentLine.dmpl__PurchaseOrderLineId__c, 'POL ID should match');
        System.assertEquals(shipment.Id, shipmentLine.dmpl__ShipmentId__c, 'Shipment ID should match');
		
        System.assertEquals(item.Id, shipmentLine.dmpl__ItemId__c);
        System.assertEquals(10, shipmentLine.dmpl__PendingQuantity__c, 'Pending Quantity should match');
        System.assertEquals(10, shipmentLine.dmpl__Quantity__c);
        System.assertEquals(2000, shipmentLine.dmpl__UnitPrice__c);
        System.assertEquals(20000, shipmentLine.dmpl__Amount__c);

		try{
			shipmentLine.dmpl__Quantity__c = 20;
			update shipmentLine;
		}catch(Exception e){
			System.Assert(false, 'Exception not Expected >>'+ e.getMessage());
		}
        shipmentLine = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);
        System.assertEquals(20, shipmentLine.dmpl__PendingQuantity__c, 'Pending Quantity should match');
        System.assertEquals(20, shipmentLine.dmpl__Quantity__c);
        System.assertEquals(2000, shipmentLine.dmpl__UnitPrice__c);
        System.assertEquals(40000, shipmentLine.dmpl__Amount__c);

		Test.stopTest();
	}
	@isTest
	static void createShipmentLineWithoutPurchaseOrderLineReferenceNegative(){
		Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 4');
        
        
        dmpl__Shipment__c shipment  = ShipmentTestDataHelper.createShipment(
            Date.Today(),
			partner.Id,
			branch.Id,
			null,
			null
        );
		dmpl__ShipmentLine__c shipmentLine;
        try{
		 	shipmentLine = ShipmentTestDataHelper.createShipmentLine(
				item,
				shipment,
				null,
				null
			);
			shipmentLine.dmpl__Quantity__c = 10;
			shipmentLine.dmpl__UnitPrice__c = 2000;
			update shipmentLine;
		}catch(Exception e){
			System.Assert(false, 'Exception not Expected >>'+ e.getMessage());
		}
        
        shipmentLine = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);
        System.assertEquals(shipment.Id, shipmentLine.dmpl__ShipmentId__c, 'Shipment ID should match');
		
        System.assertEquals(item.Id, shipmentLine.dmpl__ItemId__c);
        System.assertEquals(10, shipmentLine.dmpl__PendingQuantity__c, 'Pending Quantity should match');
        System.assertEquals(10, shipmentLine.dmpl__Quantity__c);
        System.assertEquals(2000, shipmentLine.dmpl__UnitPrice__c);
        System.assertEquals(20000, shipmentLine.dmpl__Amount__c);

		Test.stopTest();
	}
	@isTest
	static void updateShipmentLineWithoutPurchaseOrderLineReferenceNegative(){
		Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 4');
        
        Date documentDate = System.today();
        Date shipmentDate = System.today();
        
        
        dmpl__Shipment__c shipment  = ShipmentTestDataHelper.createShipment(
            Date.Today(),
			partner.Id,
			branch.Id,
			null,
			null
        );
		dmpl__ShipmentLine__c shipmentLine;
        try{
		 	shipmentLine = ShipmentTestDataHelper.createShipmentLine(
				item,
				shipment,
				null,
				null
			);
			shipmentLine.dmpl__Quantity__c = 10;
			shipmentLine.dmpl__UnitPrice__c = 2000;
			update shipmentLine;
		}catch(Exception e){
			System.Assert(false, 'Exception not Expected >>'+ e.getMessage());
		}
        
        shipmentLine = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);  
        System.assertEquals(shipment.Id, shipmentLine.dmpl__ShipmentId__c, 'Shipment ID should match');
		
        System.assertEquals(item.Id, shipmentLine.dmpl__ItemId__c);
        System.assertEquals(10, shipmentLine.dmpl__PendingQuantity__c, 'Pending Quantity should match');
        System.assertEquals(10, shipmentLine.dmpl__Quantity__c);
        System.assertEquals(2000, shipmentLine.dmpl__UnitPrice__c);
        System.assertEquals(20000, shipmentLine.dmpl__Amount__c);

		try{
			shipmentLine.dmpl__Quantity__c = 20;
			update shipmentLine;
		}catch(Exception e){
			System.Assert(false, 'Exception not Expected >>'+ e.getMessage());
		}
        shipmentLine = ShipmentTestDataHelper.getShipmentLine(shipmentLine.Id);
        System.assertEquals(20, shipmentLine.dmpl__PendingQuantity__c, 'Pending Quantity should match');
        System.assertEquals(20, shipmentLine.dmpl__Quantity__c);
        System.assertEquals(2000, shipmentLine.dmpl__UnitPrice__c);
        System.assertEquals(40000, shipmentLine.dmpl__Amount__c);

		Test.stopTest();
	}
}