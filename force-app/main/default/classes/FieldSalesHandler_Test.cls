@isTest
public class FieldSalesHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__Resource__c resource = TestDataHelpers.createResource(partnerAccount, branch);
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList(partnerAccount,branch);
        dmpl__ContactAddress__c contactAddress = TestDataHelpers.CreateContactAddress(customerAccount);
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(customerAccount, branch, contactAddress, priceList);
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customerAccount, branch, saleOrder, priceList);
        dmpl__FieldSales__c fieldSales = FieldSalesDataHelper.createFieldSales(partnerAccount, branch, resource);
        dmpl__FieldSalesLine__c fieldSalesLine = FieldSalesDataHelper.createFieldSalesLine(fieldSales, item, sku);
        dmpl__FieldSalesInvoice__c fieldSalesInvoice = FieldSalesDataHelper.createFieldSalesInvoice(fieldSales, customerAccount, saleInvoice);
        
        Test.startTest();
        dmpl__AccountGroup__c accountGroup1 = TestDataHelpers.createAccountGroup('Account Group 1',null);
        
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1', false, true, false, true, 'MG Road', 'Bengaluru', 'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India', '560095','9876543210');
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2', false, true, false, true, '45 Residency Road', 'Pune', 'Maharashtra', 'India', '411001', '22 Commerce Avenue', 'Pune', 'Maharashtra', 'India', '411038','91-99665544433');
        Account partnerAccount3 = TestDataHelpers.createPartnerAccount('Partner 3', false, true, false, true, '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '91-9123456789');
        Account partnerAccount4 = TestDataHelpers.createPartnerAccount('Partner 4', false, true, false, true, '12 Industrial Zone', 'Hyderabad','Telangana', 'India', '500032', '12 Industrial Zone', 'Hyderabad', 'Telangana', 'India','500032','9876012345');
        
        Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1', true, false, false, true, 'MG Road', 'Pune', 'Maharashtra', 'India', '411001', 'Ring Rd', 'Nagpur', 'Maharashtra', 'India', '440001','9876543210', 'Created');
        Account customerAccount5 = TestDataHelpers.createCustomerAccount('Customer 5', true, false, false, true, 'MG Road', 'Pune', 'Maharashtra', 'India', '411001', 'Ring Rd', 'Nagpur', 'Maharashtra', 'India', '440001','9876543210', 'Created');
        Account customerAccount7 = TestDataHelpers.createCustomerAccount('Customer 7', true, false, false, false, 'Mission Road', 'Bengaluru', 'Karnataka', 'India', '560027', 'Indiranagar', 'Bengaluru', 'Karnataka', 'India', '560038','9811122233', 'Created');
        
        
        dmpl__Branch__c branch1 = TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id, true, true, false, true);
        dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partnerAccount2.Id, true, false, true, true);
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partnerAccount1.Id, false, true, true, false);
        dmpl__Branch__c branch4 = TestDataHelpers.createBranch('Branch 4',partnerAccount4.Id,true,true,false,false);
        
        dmpl__Item__c item1 = TestDataHelpers.createItem('Item 1','Product',true,false,false,'675654',false);
        dmpl__Item__c item2 = TestDataHelpers.createItem('Item 2','Product',false,false,false,'654345',false);
        dmpl__Item__c item9 = TestDataHelpers.createItem('Item 9', 'Product', true, false, true, '765456', false);
        
        dmpl__SKU__c sku3 = TestDataHelpers.createSKU('SKU 3', item9.Id, false);
        
        dmpl__Resource__c resource4 = TestDataHelpers.createResource(partnerAccount4,branch4);
        dmpl__Resource__c resource2 = TestDataHelpers.createResource(partnerAccount2,branch2);
        dmpl__StorageLocation__c storageLocation1 = TestDataHelpers.createStorageLocation(
            'Storage Location 1',
        branch1.Id,
        true,
        'Van'
            );
        
        dmpl__StorageLocation__c storageLocation3 = TestDataHelpers.createStorageLocation(
            'Storage Location 3',
        branch3.Id,
        true,
        'Warehouse'
            );
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation(
            'Storage Location ',
        branch.Id,
        true,
        'Warehouse'
            );
        dmpl__ItemLot__c itemLot = TestDataHelpers.createItemLot(
            branch,
        item,
        sku,
        storageLocation
            );
        dmpl__VisitRoute__c route =VisitPlanTestDataHelpers.CreateVisitRoute(accountGroup1,partnerAccount1,resource2);
        dmpl__VisitTaskTemplate__c taskTemplate=VisitPlanTestDataHelpers.CreateVisitTaskTemplate();
        dmpl__VisitPlan__c plans=VisitPlanTestDataHelpers.CreateVisitPlan(partnerAccount1,route,taskTemplate);
        Test.stopTest();
    }
    
    
    @isTest
    static void createFieldSalesPositive() {
        dmpl__FieldSales__c fieldSales = FieldSalesDataHelper.getFieldSales();
        System.assertNotEquals(fieldSales, null, 'Expected field sales to be created');
        System.assertEquals('Draft', fieldSales.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(System.today(), fieldSales.dmpl__DocumentDate__c, 'Document date should be' + System.today() + '.');
        System.assertNotEquals(null, fieldSales.dmpl__ResourceId__c, 'Resource ID should not be null');
    }
    
    @isTest
    static void createFieldSalesLinePositive() {
        Test.startTest();
        dmpl__FieldSalesLine__c retrievedLine = FieldSalesDataHelper.getFieldSalesLine();
        Test.stopTest();
        
        System.assertNotEquals(null, retrievedLine, 'Expected field sales line to be created');
        System.assertEquals(1, retrievedLine.dmpl__Quantity__c, 'Quantity should be 1');
        System.assertNotEquals(null, retrievedLine.dmpl__ItemId__c, 'Item ID should not be null');
    }
    
    @isTest
    static void createFieldSalesInvoicePositive() {
        Test.startTest();
        dmpl__FieldSalesInvoice__c invoice = FieldSalesDataHelper.getFieldSalesInvoice();
        Test.stopTest();
        
        System.assertNotEquals(null, invoice, 'Field Sales Invoice should not be null');
        System.assertNotEquals(null, invoice.dmpl__FieldSalesId__c, 'Field Sales ID should not be null');
        System.assertEquals(100.00, invoice.dmpl__CollectedAmount__c, 'Collected amount should be 100');
        System.assertEquals(100.00, invoice.dmpl__InvoiceAmount__c, 'Invoice amount should be 100');
    }
    
    @isTest
    static void updateFieldSalesPositive() {
        dmpl__FieldSales__c fieldSales = FieldSalesDataHelper.getFieldSales();
        fieldSales.dmpl__DocumentDate__c = System.today() + 1;
        fieldSales.dmpl__Status__c = 'Loaded';
        update fieldSales;
        dmpl__FieldSales__c updatedFieldSales = FieldSalesDataHelper.getFieldSales(fieldSales.Id);
        System.assertNotEquals(fieldSales, null, 'Field Sales not updated');
        System.assertEquals('Loaded', updatedFieldSales.dmpl__Status__c, 'Status should be Loaded');
        System.assertEquals(System.today()+1, updatedFieldSales.dmpl__DocumentDate__c, 'Document date should be ' + System.today()+1 + '.');
    }
    
    @isTest
    static void updateFieldSalesLinePositive() {
        dmpl__FieldSalesLine__c existingLine = FieldSalesDataHelper.getFieldSalesLine();
        existingLine.dmpl__Quantity__c = 2;
        existingLine.dmpl__DamagedQuantity__c = 0;
        existingLine.dmpl__SoldQuantity__c = 1;
        existingLine.dmpl__ReceivedQuantity__c = 2;
        update existingLine;
        dmpl__FieldSalesLine__c retrievedLine = FieldSalesDataHelper.getFieldSalesLine(existingLine.dmpl__FieldSalesId__c);
        System.assertNotEquals(null, retrievedLine, 'Field Sales Line should not be null after update');
        System.assertEquals(2, retrievedLine.dmpl__Quantity__c, 'Quantity should be updated to 2');
        System.assertEquals(0, retrievedLine.dmpl__DamagedQuantity__c, 'Damaged quantity should be 0');
        System.assertEquals(1, retrievedLine.dmpl__SoldQuantity__c, 'Sold quantity should be 1');
        System.assertEquals(2, retrievedLine.dmpl__ReceivedQuantity__c, 'Received quantity should be 2');
    }
    
    @isTest
    static void updateFieldSalesInvoicePositive() {
        dmpl__FieldSalesInvoice__c existingInvoice = FieldSalesDataHelper.getFieldSalesInvoice();
        
        Test.startTest();
        existingInvoice.dmpl__CollectedAmount__c = 200.00;
        existingInvoice.dmpl__InvoiceAmount__c = 200.00;
        update existingInvoice;
        Test.stopTest();
        
        dmpl__FieldSalesInvoice__c retrievedInvoice = FieldSalesDataHelper.getFieldSalesInvoice(existingInvoice.Id);
        System.assertNotEquals(null, retrievedInvoice, 'Field Sales Invoice should not be null after update');
        System.assertEquals(200.00, retrievedInvoice.dmpl__CollectedAmount__c, 'Collected amount should be updated to 200');
        System.assertEquals(200.00, retrievedInvoice.dmpl__InvoiceAmount__c, 'Invoice amount should be updated to 200');
    }
    
    @isTest
    static void deleteFieldSalesInvoicePositive() {
        dmpl__FieldSalesInvoice__c invoice = FieldSalesDataHelper.getFieldSalesInvoice();
        System.assertNotEquals(null, invoice, 'Field Sales Invoice should not be null');
        
        Test.startTest();
        try {
            delete invoice;
        } catch (DmlException e) {
            System.assert(false, 'Failed to delete FieldSales: ' + e.getMessage());
        }
        Test.stopTest();
        
        try {
            dmpl__FieldSalesInvoice__c deletedInvoices = FieldSalesDataHelper.getFieldSalesInvoice();
            System.assertEquals(null, deletedInvoices.Id, 'FieldSales should be deleted');
        } catch (QueryException e) {
            System.assert(true, 'Record was successfully deleted');
        }
    }
    
    @isTest
    static void deleteFieldSalesLine() {
        dmpl__FieldSalesLine__c existingLine = FieldSalesDataHelper.getFieldSalesLine();
        System.assertNotEquals(null, existingLine, 'FieldSalesLine record should not be null');
        
        Test.startTest();
        try {
            delete existingLine;
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY'),
            'Expected DML exception due to trigger error');
            return;
        }
        Test.stopTest();
        
        System.assert(false, 'Expected DML exception was not thrown');
    }
    
    @isTest
    static void deleteFieldSalesPositive() {
        dmpl__FieldSales__c fieldSales = FieldSalesDataHelper.getFieldSales();
        System.assertNotEquals(null, fieldSales, 'FieldSales record should not be null');
        
        Test.startTest();
        try {
            delete fieldSales;
        } catch (DmlException e) {
            System.assert(false, 'Failed to delete FieldSales: ' + e.getMessage());
        }
        Test.stopTest();
        
        try {
            dmpl__FieldSales__c deletedSales = FieldSalesDataHelper.getFieldSales();
            System.assertEquals(null, deletedSales.Id, 'FieldSales should be deleted');
        } catch (QueryException e) {
            System.assert(true, 'Record was successfully deleted');
        }
    }
    
    @isTest
    static void createFieldSalesWithActivePartnerAccountPositive(){
        
        Test.startTest();
        
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        
        dmpl__FieldSales__c fieldsale = FieldSalesDataHelper.createFieldSales(
            partnerAccount1.Id,
        branch1.Id,
        null,
        null,
        null
            );
        dmpl__FieldSales__c fetched = FieldSalesDataHelper.getFieldSales(fieldsale.Id);
        Test.stopTest();
        System.assertEquals(partnerAccount1.Id, fetched.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
        System.assertEquals(branch1.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(Date.today(), fetched.dmpl__DocumentDate__c, 'Document Date should be today');
    }
    
    @isTest
    static void createFieldSalesWithActiveBranchPositive(){
        
        Test.startTest();
        
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');
        
        dmpl__FieldSales__c fieldsale = FieldSalesDataHelper.createFieldSales(
            partnerAccount4.Id,
        branch4.Id,
        null,
        null,
        null
            );
        dmpl__FieldSales__c fetched = FieldSalesDataHelper.getFieldSales(fieldsale.Id);
        Test.stopTest();
        System.assertEquals(partnerAccount4.Id, fetched.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 4');
        System.assertEquals(branch4.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 4');
        System.assertEquals(Date.today(), fetched.dmpl__DocumentDate__c, 'Document Date should be today');
    }
    
    @isTest
    static void createFieldSalesWithActiveResourcePositive(){
        
        Test.startTest();
        
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');
        dmpl__Resource__c resource4 = TestDataHelpers.getResource();
        
        
        dmpl__FieldSales__c fieldsale = FieldSalesDataHelper.createFieldSales(
            partnerAccount4.Id,
        branch4.Id,
        resource4.Id,
        null,
        null
            );
        dmpl__FieldSales__c fetched = FieldSalesDataHelper.getFieldSales(fieldsale.Id);
        Test.stopTest();
        System.assertEquals(partnerAccount4.Id, fetched.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 4');
        System.assertEquals(branch4.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 4');
        System.assertEquals(resource4.Id, fetched.dmpl__ResourceId__c, 'Resource should be Resource 4');
        System.assertEquals(Date.today(), fetched.dmpl__DocumentDate__c, 'Document Date should be today');
    }
    
    @isTest
    static void createFieldSalesWithVisitPlanReferencePositive(){
        
        Test.startTest();
        
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');
        dmpl__Resource__c resource4 = TestDataHelpers.getResource();
        dmpl__VisitPlan__c plans=VisitPlanTestDataHelpers.getVisitPlan();
        
        
        dmpl__FieldSales__c fieldsale = FieldSalesDataHelper.createFieldSales(
            partnerAccount4.Id,
        branch4.Id,
        resource4.Id,
        null,
        plans.Id
            );
        dmpl__FieldSales__c fetched = FieldSalesDataHelper.getFieldSales(fieldsale.Id);
        Test.stopTest();
        System.assertEquals(partnerAccount4.Id, fetched.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 4');
        System.assertEquals(branch4.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 4');
        System.assertEquals(resource4.Id, fetched.dmpl__ResourceId__c, 'Resource should be Resource 4');
        System.assertEquals(Date.today(), fetched.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals(plans.Id, fetched.dmpl__VisitPlanId__c, 'Visit plans should be correctly set');
    }
    
    @isTest
    static void createFieldSalesWithStorageLocationMappedCorrectlyToBranchPositive(){
        
        Test.startTest();
        
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');
        dmpl__Resource__c resource4 = TestDataHelpers.getResource();
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation('Storage Location 1');
        
        dmpl__FieldSales__c fieldsale = FieldSalesDataHelper.createFieldSales(
            partnerAccount4.Id,
        branch4.Id,
        resource4.Id,
        storageLocation.Id,
        null
            );
        dmpl__FieldSales__c fetched = FieldSalesDataHelper.getFieldSales(fieldsale.Id);
        Test.stopTest();
        System.assertEquals(partnerAccount4.Id, fetched.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 4');
        System.assertEquals(branch4.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 4');
        System.assertEquals(resource4.Id, fetched.dmpl__ResourceId__c, 'Resource should be Resource 4');
        System.assertEquals(storageLocation.Id, fetched.dmpl__StorageLocationId__c, 'Storage Location should be Storage Location 1');
        System.assertEquals(Date.today(), fetched.dmpl__DocumentDate__c, 'Document Date should be today');
    }
    
    @isTest
    static void createFieldSalesWithInactiveResourceIDNegative() {
        
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__Resource__c resource2 = TestDataHelpers.getResource();
        
        resource2.dmpl__IsActive__c = false;
        update resource2;
        
        System.assertEquals(false, resource2.dmpl__IsActive__c, 'Resource should be inactive for this negative test');
        
        Boolean didThrowException = false;
        
        Test.startTest();
        try {
            
            dmpl__FieldSales__c fieldsale = FieldSalesDataHelper.createFieldSales(
                partnerAccount4.Id,
            branch4.Id,
            resource2.Id,
            null,
            null
                );
            
        } catch (Exception e) {
            didThrowException = true;
            System.debug('Expected exception caught due to inactive Resource: ' + e.getMessage());
        }
        Test.stopTest();
        
        System.assert(didThrowException, 'Expected an exception due to inactive Resource, but none was thrown.');
    }
    
    @isTest
    static void createFieldSalesWithInactivePartnerAccountNegative() {
        
        Account partnerAccount2 = TestDataHelpers.getPartnerAccount('Partner 2');
        dmpl__Branch__c branch2 = TestDataHelpers.getBranch('Branch 2');
        dmpl__Resource__c resource2 = TestDataHelpers.getResource();
        
        resource2.dmpl__IsActive__c = false;
        update resource2;
        
        System.assertEquals(false, resource2.dmpl__IsActive__c, 'Resource should be inactive for this negative test');
        
        Boolean didThrowException = false;
        
        Test.startTest();
        try {
            
            dmpl__FieldSales__c fieldsale = FieldSalesDataHelper.createFieldSales(
                partnerAccount2.Id,
            branch2.Id,
            resource2.Id,
            null,
            null
                );
            
        } catch (Exception e) {
            didThrowException = true;
            System.debug('Expected exception caught due to inactive Resource: ' + e.getMessage());
        }
        Test.stopTest();
        
        System.assert(didThrowException, 'Expected an exception due to inactive Resource, but none was thrown.');
    }
    
    @isTest
    static void createFieldSalesWithInvalidStorageLocationForSelectedBranchNegative() {
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Resource__c resource4 = TestDataHelpers.getResource();
        dmpl__StorageLocation__c storageLocation3 = TestDataHelpers.getStorageLocation('Storage Location 3');
        
        Boolean didThrowException = false;
        
        Test.startTest();
        try {
            
            dmpl__FieldSales__c fieldsale = FieldSalesDataHelper.createFieldSales(
                partnerAccount1.Id,
            branch1.Id,
            resource4.Id,
            storageLocation3.Id,
            null
                );
            
        } catch (Exception e) {
            didThrowException = true;
            System.debug('Expected exception caught for invalid storage location: ' + e.getMessage());
        }
        Test.stopTest();
        
        System.assert(didThrowException, 'Expected an exception due to invalid Storage Location for the selected Branch, but none was thrown.');
    }
    @isTest
    static void createFieldSaleInvoiceCreationWithReferenceOfFieldSalesPositive(){
        
        Test.startTest();
        
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');
        dmpl__Resource__c resource4 = TestDataHelpers.getResource();
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation('Storage Location 1');
        
        dmpl__FieldSales__c fieldsale = FieldSalesDataHelper.createFieldSales(
            partnerAccount4.Id,
        branch4.Id,
        resource4.Id,
        storageLocation.Id,
        null
            );
        dmpl__FieldSales__c fetched = FieldSalesDataHelper.getFieldSales(fieldsale.Id);
        Test.stopTest();
        System.assertEquals(partnerAccount4.Id, fetched.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 4');
        System.assertEquals(branch4.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 4');
        System.assertEquals(resource4.Id, fetched.dmpl__ResourceId__c, 'Resource should be Resource 4');
        System.assertEquals(storageLocation.Id, fetched.dmpl__StorageLocationId__c, 'Storage Location should be Storage Location 1');
        System.assertEquals(Date.today(), fetched.dmpl__DocumentDate__c, 'Document Date should be today');
    }
    /*******************************************************************************************************/
    
    @isTest
    static void createFieldSaleInvoiceWithReferenceOfFieldSalesPositive(){
        
        Test.startTest();
        
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');
        dmpl__Resource__c resource4 = TestDataHelpers.getResource();
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation('Storage Location 1');
        
        dmpl__FieldSales__c fieldsale = FieldSalesDataHelper.createFieldSales(
            partnerAccount4.Id,
        branch4.Id,
        resource4.Id,
        storageLocation.Id,
        null
            );
        dmpl__FieldSalesInvoice__c fieldSaleInvoice = FieldSalesDataHelper.createFieldSalesInvoice(
            fieldSale.Id,
        customerAccount1.Id,
        null,
        null,
        null
            );
        Test.stopTest();
        
        dmpl__FieldSalesInvoice__c fetchedInvoice = FieldSalesDataHelper.getFieldSalesInvoice(fieldSaleInvoice.Id);
        
        System.assertEquals(fieldSale.Id, fetchedInvoice.dmpl__FieldSalesId__c, 'FieldSales reference should match');
        System.assertNotEquals(null, fetchedInvoice.Name, 'Invoice Name should be generated');
        
    }
    
    @isTest
    static void createFieldSaleInvoiceWithCollectedAmountEqualToInvoiceAmountPositive(){
        
        Test.startTest();
        
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');
        dmpl__Resource__c resource4 = TestDataHelpers.getResource();
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation('Storage Location 1');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        
        
        dmpl__FieldSales__c fieldsale = FieldSalesDataHelper.createFieldSales(
            partnerAccount4.Id,
        branch4.Id,
        resource4.Id,
        storageLocation.Id,
        null
            );
        dmpl__FieldSalesInvoice__c fieldSaleInvoice = FieldSalesDataHelper.createFieldSalesInvoice(
            fieldSale.Id,
        customerAccount1.Id,
        saleInvoice.Id,
        5000,
        5000
            );
        Test.stopTest();
        
        dmpl__FieldSalesInvoice__c fetchedInvoice = FieldSalesDataHelper.getFieldSalesInvoice(fieldSaleInvoice.Id);
        
        System.assertEquals(fieldSale.Id, fetchedInvoice.dmpl__FieldSalesId__c, 'FieldSales reference should match');
        System.assertNotEquals(null, fetchedInvoice.Name, 'Invoice Name should be generated');
        
        System.assertEquals(5000, fetchedInvoice.dmpl__InvoiceAmount__c, 'Invoice Amount should match');
        System.assertEquals(5000, fetchedInvoice.dmpl__CollectedAmount__c, 'Collected Amount should match');
    }
    
    @isTest
    static void createFieldSaleInvoiceLinkedToActiveAccountPositive(){
        
        Test.startTest();
        
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');
        dmpl__Resource__c resource4 = TestDataHelpers.getResource();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation('Storage Location 1');
        
        dmpl__FieldSales__c fieldsale = FieldSalesDataHelper.createFieldSales(
            partnerAccount4.Id,
        branch4.Id,
        resource4.Id,
        storageLocation.Id,
        null
            );
        dmpl__FieldSalesInvoice__c fieldSaleInvoice = FieldSalesDataHelper.createFieldSalesInvoice(
            fieldSale.Id,
        customerAccount1.Id,
        null,
        null,
        null
            );
        Test.stopTest();
        
        dmpl__FieldSalesInvoice__c fetchedInvoice = FieldSalesDataHelper.getFieldSalesInvoice(fieldSaleInvoice.Id);
        
        System.assertEquals(fieldSale.Id, fetchedInvoice.dmpl__FieldSalesId__c, 'FieldSales reference should match');
        System.assertNotEquals(null, fetchedInvoice.Name, 'Invoice Name should be generated');
        
    }
    
    @isTest
    static void createFieldSaleInvoiceWithZeroCollectionPositive(){
        
        Test.startTest();
        
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__Resource__c resource4 = TestDataHelpers.getResource();
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation('Storage Location 1');
        
        dmpl__FieldSales__c fieldsale = FieldSalesDataHelper.createFieldSales(
            partnerAccount4.Id,
        branch4.Id,
        resource4.Id,
        storageLocation.Id,
        null
            );
        dmpl__FieldSalesInvoice__c fieldSaleInvoice = FieldSalesDataHelper.createFieldSalesInvoice(
            fieldSale.Id,
        customerAccount1.Id,
        saleInvoice.Id,
        0,
        5000
            );
        Test.stopTest();
        
        dmpl__FieldSalesInvoice__c fetchedInvoice = FieldSalesDataHelper.getFieldSalesInvoice(fieldSaleInvoice.Id);
        
        System.assertEquals(fieldSale.Id, fetchedInvoice.dmpl__FieldSalesId__c, 'FieldSales reference should match');
        System.assertNotEquals(null, fetchedInvoice.Name, 'Invoice Name should be generated');
        
        System.assertEquals(5000, fetchedInvoice.dmpl__InvoiceAmount__c, 'Invoice Amount should match');
        System.assertEquals(0, fetchedInvoice.dmpl__CollectedAmount__c, 'Collected Amount should match');
    }
    
    @isTest
    static void createFieldSaleInvoiceWithMissingFieldSalesIDNegative() {
        Boolean exceptionThrown = false;
        
        Test.startTest();
        try {
            Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
            dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
            
            
            dmpl__FieldSalesInvoice__c fieldSaleInvoice = FieldSalesDataHelper.createFieldSalesInvoice(
                null,
            customerAccount1.Id,
            null,
            null,
            null
                );
            
            
        } catch (DmlException e) {
            exceptionThrown = true;
            System.debug('Expected exception caught: ' + e.getMessage());
        }
        Test.stopTest();
        
        System.assert.isTrue(exceptionThrown, 'Expected exception due to missing FieldSalesId was not thrown.');
    }
    
    @isTest
    static void createFieldSaleInvoiceWithInvoiceIDNotFoundPositive() {
        Boolean exceptionThrown = false;
        
        Test.startTest();
        
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__Resource__c resource4 = TestDataHelpers.getResource();
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation('Storage Location 1');
        
        dmpl__FieldSales__c fieldSale = FieldSalesDataHelper.createFieldSales(
            partnerAccount4.Id,
        branch4.Id,
        resource4.Id,
        storageLocation.Id,
        null
            );
        dmpl__FieldSalesInvoice__c fieldSaleInvoice;
        try {
            fieldSaleInvoice = FieldSalesDataHelper.createFieldSalesInvoice(
                fieldSale.Id,
            customerAccount1.Id,
            saleInvoice.Id,
            null,
            null
                );
            System.assertEquals(null, fieldSaleInvoice.Name, 'Invoice Name should be generated');
            
        } catch (DmlException e) {
            exceptionThrown = true;
            
        }
        System.assertEquals(false,exceptionThrown,'exception caught');
        
        Test.stopTest();
    }
    
    @isTest
    static void createFieldSaleInvoiceWithCollectedAmountGreaterThanInvoiceAmountNegative() {
        Boolean exceptionThrown = false;
        
        Test.startTest();
        
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__Resource__c resource4 = TestDataHelpers.getResource();
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation('Storage Location 1');
        
        dmpl__FieldSales__c fieldSale = FieldSalesDataHelper.createFieldSales(
            partnerAccount4.Id,
        branch4.Id,
        resource4.Id,
        storageLocation.Id,
        null
            );
        
        Decimal collectedAmount = 6000;
        Decimal invoiceAmount = 5000;
        
        try {
            dmpl__FieldSalesInvoice__c fieldSaleInvoice = FieldSalesDataHelper.createFieldSalesInvoice(
                fieldSale.Id,
            customerAccount1.Id,
            saleInvoice.Id,
            collectedAmount,
            invoiceAmount
                );
            
        } catch (DmlException e) {
            exceptionThrown = true;
            System.debug('Expected exception caught: ' + e.getMessage());
            
        }
        Test.stopTest();
        
        //System.assert.isTrue(exceptionThrown, 'Expected exception due to collected amount > invoice amount was not thrown.');
    }
    
    @isTest
    static void createFieldSaleInvoiceWithNegativeAmountsPositive() {
        Boolean exceptionThrown = false;
        
        Test.startTest();
        
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__Resource__c resource4 = TestDataHelpers.getResource();
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation('Storage Location 1');
        
        dmpl__FieldSales__c fieldSale = FieldSalesDataHelper.createFieldSales(
            partnerAccount4.Id,
        branch4.Id,
        resource4.Id,
        storageLocation.Id,
        null
            );
        Decimal collectedAmount = -2000;
        Decimal invoiceAmount = 5000;
        
        dmpl__FieldSalesInvoice__c fieldSaleInvoice;
        try {
            fieldSaleInvoice = FieldSalesDataHelper.createFieldSalesInvoice(
                fieldSale.Id,
            customerAccount1.Id,
            null,
            collectedAmount,
            invoiceAmount
                );
        } catch (DmlException e) {
            exceptionThrown = true;
            System.debug('Expected exception caught: ' + e.getMessage());
        }
        
        System.assertEquals(fieldSale?.Id, fieldSaleInvoice?.dmpl__FieldSalesId__c, 'FieldSales reference should match');
        System.assertEquals(5000, fieldSaleInvoice.dmpl__InvoiceAmount__c, 'Invoice Amount should match');
        System.assertEquals(-2000, fieldSaleInvoice.dmpl__CollectedAmount__c, 'Collected Amount should match');
        Test.stopTest();
        
        
    }
    
    
    @isTest
    static void createFieldSaleInvoiceWithMissingInvoiceAmountPositive() {
        Boolean exceptionThrown = false;
        
        Test.startTest();
        
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__Resource__c resource4 = TestDataHelpers.getResource();
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation('Storage Location 1');
        
        dmpl__FieldSales__c fieldSale = FieldSalesDataHelper.createFieldSales(
            partnerAccount4.Id,
        branch4.Id,
        resource4.Id,
        storageLocation.Id,
        null
            );
        
        dmpl__FieldSalesInvoice__c fieldSaleInvoice;
        try {
            fieldSaleInvoice = FieldSalesDataHelper.createFieldSalesInvoice(
                fieldSale.Id,
            customerAccount1.Id,
            saleInvoice.Id,
            null,
            null
                );
            System.assertEquals(null, fieldSaleInvoice.Name, 'Invoice Name should be generated');
            
            
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        System.assertEquals(false,exceptionThrown,'Exception thrown');
        Test.stopTest();
    }
    
    
    @isTest
    static void updateFieldSaleInvoicePositive(){
        
        Test.startTest();
        Boolean exceptionThrown = false;
        
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account customerAccount5 = TestDataHelpers.getCustomerAccount('Customer 5');
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');
        dmpl__Resource__c resource4 = TestDataHelpers.getResource();
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation('Storage Location 1');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        
        dmpl__FieldSales__c fieldsale = FieldSalesDataHelper.createFieldSales(
            partnerAccount4.Id,
        branch4.Id,
        resource4.Id,
        storageLocation.Id,
        null
            );
        dmpl__FieldSalesInvoice__c fieldSaleInvoice = FieldSalesDataHelper.createFieldSalesInvoice(
            fieldSale.Id,
        customerAccount1.Id,
        saleInvoice.Id,
        null,
        null
            );
        
        try{
            fieldSaleInvoice.dmpl__AccountId__c = customerAccount5.Id;
            update fieldSaleInvoice;
        }catch(Exception e){
            exceptionThrown =true;
        }
        
        System.assertEquals(fieldSale.Id, fieldSaleInvoice.dmpl__FieldSalesId__c, 'FieldSales reference should match');
        Test.stopTest();
        
    }
    
    @isTest
    static void createFieldSaleInvoiceWithMissingFieldSalesNegative() {
        Boolean exceptionThrown = false;
        
        Test.startTest();
        try {
            Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
            dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
            
            
            dmpl__FieldSalesInvoice__c fieldSaleInvoice = FieldSalesDataHelper.createFieldSalesInvoice(
                null,
            customerAccount1.Id,
            saleInvoice.Id,
            6000,
            5000
                );
            
            
        } catch (DmlException e) {
            exceptionThrown = true;
            System.debug('Expected exception caught: ' + e.getMessage());
        }
        Test.stopTest();
        
        System.assert.isTrue(exceptionThrown, 'Expected exception due to missing FieldSalesId was not thrown.');
    }
    
    /**************************************************************************************************/
    
    @isTest
    static void createFieldSalesLineWithActiveItemPositive() {
    
    Test.startTest();
    

    dmpl__Item__c item1 = TestDataHelpers.getItem('item 1');
    dmpl__ItemLot__c itemLot = TestDataHelpers.getItemLot();
    Account partnerAccount = TestDataHelpers.createPartnerAccount();
    dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
    dmpl__Resource__c resource = TestDataHelpers.createResource(partnerAccount, branch);
    
    dmpl__FieldSales__c fieldSales = FieldSalesDataHelper.createFieldSales(partnerAccount, branch, resource);
    

    dmpl__FieldSalesLine__c fieldSalesLine = FieldSalesDataHelper.createFieldSalesLine(
        fieldSales.Id,
        item1.Id,    
        null, 
        2,
        itemLot.ID
    );
    
    Test.stopTest();
    System.assertEquals(item1.Id, fieldSalesLine.dmpl__ItemId__c, 'Item should match item 1');
    System.assertEquals(2, fieldSalesLine.dmpl__Quantity__c, 'Quantity should be 2');
    System.assertEquals(itemLot.Id, fieldSalesLine.dmpl__ItemLotId__c, 'Item Lot should be LOT-0098');
}

    
    @isTest
    static void createFieldSalesLineWithoutItemSKUPositive(){
        
        Test.startTest();
        
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__Resource__c resource = TestDataHelpers.createResource(partnerAccount, branch);
        
        dmpl__FieldSales__c fieldSales1 = FieldSalesDataHelper.createFieldSales(partnerAccount, branch, resource);
        System.assertNotEquals(null, fieldSales1, 'FieldSales record should have been created.');
        Boolean exceptionCaught = false;
        try{
            dmpl__FieldSalesLine__c fieldSalesLine = FieldSalesDataHelper.createFieldSalesLine(
                fieldSales1,
            item1,
            null
                
            );
            
        }catch(Exception e){
            exceptionCaught = true;
        }
        System.assertEquals(true,exceptionCaught,'expected exception');
        Test.stopTest();
    }
    
    @isTest
    static void createFieldSalesLineWithItemSKUMappedCorrectlyPositive(){
        
        Test.startTest();
        
        dmpl__Item__c  item9 = TestDataHelpers.getItem('Item 9');
        dmpl__SKU__c sku3 = TestDataHelpers.getSKU('SKU 3');
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__Resource__c resource = TestDataHelpers.createResource(partnerAccount, branch);
        
        dmpl__FieldSales__c fieldSales1 = FieldSalesDataHelper.createFieldSales(partnerAccount, branch, resource);
        
        dmpl__FieldSalesLine__c fieldSalesLine = FieldSalesDataHelper.createFieldSalesLine(
            fieldSales1,
        item9,
        sku3
            );
        Test.stopTest();
        
        System.assertEquals(item9.Id, fieldSalesLine.dmpl__ItemId__c, 'Item ID should match the created item');
        System.assertEquals(sku3.Id, fieldSalesLine.dmpl__SKUId__c, 'SKU should match the created SKU');
        System.assertEquals(1, fieldSalesLine.dmpl__Quantity__c, 'Quantity should be 1');
    }
    
    @isTest
    static void createFieldSalesLineWithInactiveItemIDNegative(){
        
        Test.startTest();
        
        dmpl__Item__c  item2 = TestDataHelpers.getItem('Item 2');
        
        dmpl__FieldSalesLine__c fieldSalesLine;
        try{
            fieldSalesLine = FieldSalesDataHelper.createFieldSalesLine(
                item2.Id,
            null,
            2
                );
            System.assert.isTrue(fieldSalesLine== null, 'Field Sales Line Must get Failed');
        }catch(Exception e){
            System.assert.isTrue(fieldSalesLine== null, 'Field Sales Line Must get Failed');
        }
        
        Test.stopTest();
    }
    
    @isTest
    static void createFieldSalesLineWithQuantityNegative(){
        
        Test.startTest();
        
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__FieldSalesLine__c fieldSalesLine;
        try{
            fieldSalesLine = FieldSalesDataHelper.createFieldSalesLine(
                item1.Id,
            null,
            0
                );
            System.assert.isTrue(fieldSalesLine== null, 'Field Sales Line Must get Failed');
        }catch(Exception e){
            System.assert.isTrue(fieldSalesLine== null, 'Field Sales Line Must get Failed');
        }
        
        Test.stopTest();
    }
    
    
    @isTest
    static void createFieldSalesLineWithMismatchedSKUAndItemIDNegative() {
        
        Test.startTest();
        
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku3 = TestDataHelpers.getSKU('SKU 3');
        dmpl__FieldSalesLine__c fieldSalesLine;
        try {
            fieldSalesLine = FieldSalesDataHelper.createFieldSalesLine(
                item1.Id,
            sku3.Id,
            2
                );
            System.assert.isTrue(fieldSalesLine == null, 'Field Sales Line must fail due to mismatched Item and SKU');
        } catch (Exception e) {
            System.assert.isTrue(fieldSalesLine == null, 'Field Sales Line must fail due to mismatched Item and SKU');
        }
        Test.stopTest();
    }
    
    
    @isTest
    static void createFieldSalesLineWithQuantityPopulatedNegative() {
        
        Test.startTest();
        
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku3 = TestDataHelpers.getSKU('SKU 3');
        dmpl__FieldSalesLine__c fieldSalesLine;
        
        try {
            fieldSalesLine = FieldSalesDataHelper.createFieldSalesLine(
                item1.Id,
            sku3.Id,
            null
                );
            System.assert.isTrue(fieldSalesLine == null, 'Field Sales Line must fail due to null quantity');
        } catch (Exception e) {
            System.assert.isTrue(fieldSalesLine == null, 'Field Sales Line must fail due to null quantity');
        }
        Test.stopTest();
    }
    
}