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
}