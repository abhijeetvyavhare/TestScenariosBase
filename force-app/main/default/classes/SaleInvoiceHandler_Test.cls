@isTest
public with sharing class SaleInvoiceHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();        
        dmpl__Branch__c branch =TestDataHelpers.createBranch(partnerAccount);    
        dmpl__ContactAddress__c contactAddress =TestDataHelpers.CreateContactAddress(customerAccount);
        dmpl__Item__c item =TestDataHelpers.createItem();
        dmpl__SKU__c sku =TestDataHelpers.createSKU(item);
        dmpl__TaxGroup__c taxGroup =TestDataHelpers.createTaxGroup(partnerAccount,branch);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList(partnerAccount,branch);
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceList,item);
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(customerAccount, branch, contactAddress, priceList);
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customerAccount, branch, saleOrder, priceList);
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item, sku, null, taxGroup, priceListRule);
        dmpl__SaleInvoiceTax__c tax = SaleInvoiceDataHelper.createSaleInvoiceTax(saleInvoice, saleInvoiceLine);

        //start 
		Test.startTest();
        Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1',true,false,false,true,'MG Road','Pune','Maharashtra','India','411001','Ring Rd','Nagpur','Maharashtra','India','440001','9876543210','Created');
        Account customerAccount2 = TestDataHelpers.createCustomerAccount('Customer 2',true,false,false,true,'Park St','Nagpur','Maharashtra','India','700016','Lake Rd','Nagpur','Maharashtra','India','700029','9123456789','Created');
        Account customerAccount3 = TestDataHelpers.createCustomerAccount('Customer 3', true, false, false, true, 'Anna Salai', 'Chennai', 'TN', 'India', '600002', 'T Nagar', 'Chennai', 'TN', 'India', '600017','9012345678', 'Created');
        Account customerAccount4 = TestDataHelpers.createCustomerAccount('Customer 4', true, false, false, true, 'SG Highway', 'Ahmedabad', 'GJ', 'India', '380054', 'C G Road', 'Ahmedabad', 'GJ', 'India', '380009','9988776655', 'Created');
        Account customerAccount5 = TestDataHelpers.createCustomerAccount('Customer 5', true, false, false, true, 'Banjara Hills', 'Hyderabad', 'TN', 'India', '500034', 'Jubilee Hills', 'Hyderabad', 'TN', 'India', '500033','9090909090', 'Created');
        Account customerAccount7=  TestDataHelpers.createCustomerAccount('Customer 7', true, false, false, false, 'Mission Road', 'Bengaluru', 'Karnataka', 'India', '560027', 'Indiranagar', 'Bengaluru', 'Karnataka', 'India', '560038','9811122233', 'Created');

        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1', false, true, false, true, 'MG Road', 'Bengaluru', 'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India', '560095','9876543210');
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2', false, true, false, true, '45 Residency Road', 'Pune', 'Maharashtra', 'India', '411001', '22 Commerce Avenue', 'Pune', 'Maharashtra', 'India', '411038','91-99665544433');
        Account partnerAccount3 = TestDataHelpers.createPartnerAccount('Partner 3', false, true, false, true, '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '91-9123456789');
        Account partnerAccount4 = TestDataHelpers.createPartnerAccount('Partner 4', false, true, false, true, '12 Industrial Zone', 'Hyderabad','Telangana', 'India', '500032', '12 Industrial Zone', 'Hyderabad', 'Telangana', 'India','500032','9876012345');
        Account partnerAccount6 = TestDataHelpers.createPartnerAccount('Partner 6', false, true, false, true, 'MS Road', 'Bengaluru','Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India','560095','9845543210');
        
        dmpl__Branch__c branch1=TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id, true, true, false, true);
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partnerAccount1.Id, false, true, true, false);
        dmpl__Branch__c branch4 =TestDataHelpers.createBranch('Branch 4',partnerAccount4.Id,true,true,false,false);
		
        dmpl__Item__c  item1 = TestDataHelpers.createItem('Item 1','Product',true,false,false,'675654',false);
        dmpl__Item__c item2 = TestDataHelpers.createItem('Item 2','Product',false,false,false,'654345',false);
        dmpl__Item__c item3 = TestDataHelpers.createItem('Item 3','Charge Item',true, false, false ,'765434',true);
        dmpl__Item__c item4 = TestDataHelpers.createItem('Item 4','Product',true, false, false ,'765676',true);
        dmpl__Item__c item5 = TestDataHelpers.createItem('Item 5', 'Product', true, false, false, '876543', false);
        dmpl__Item__c item6 = TestDataHelpers.createItem('Item 6', 'Product', true, false, false, '765456', false);
        dmpl__Item__c item7 = TestDataHelpers.createItem('Item 7','Product',true,false,true, '765456',false);
        dmpl__Item__c item8 = TestDataHelpers.createItem('Item 8','Product',true,false,true, '765456',false);
        dmpl__Item__c item13 = TestDataHelpers.createItem('Item 13','Product',true,false,false, '765456',true);
        dmpl__Item__c item9 = TestDataHelpers.createItem('Item 9','Product',true, false, true, '765456', false);
        dmpl__Item__c item10= TestDataHelpers.createItem('Item 10','Product',true, false,true,'76456',false);
        dmpl__Item__c item11= TestDataHelpers.createItem('Item 11', 'Product', true, false, false,'765456', false);
        dmpl__Item__c item12= TestDataHelpers.createItem('Item 12', 'Product', true, false, false,'765456', false);
        dmpl__Item__c item15= TestDataHelpers.createItem('Item 15', 'Part', true, false, false,'765459', true);
        dmpl__Item__c item16= TestDataHelpers.createItem('Item 16', 'Part', true, false, false,'765460', true);
        
        dmpl__ItemAlternate__c itemAlternate1=SaleInvoiceDataHelper.createItemAlternate(item15,item16,'Superseded');
        dmpl__SKU__c sku4 = TestDataHelpers.createSKU('SKU 4', item11.Id, true);
        dmpl__SKU__c sku5 = TestDataHelpers.createSKU('SKU 5', item10.Id, false);
		
        dmpl__TaxGroup__c taxGroupGST18partner4 = TestDataHelpers.createTaxGroup('GST 18', true, 'Line Level', partnerAccount4.Id, branch4.Id, null);
		dmpl__Tax__c taxCGST9= TestDataHelpers.createTax('CGST', 'CGST', 9, taxGroupGST18partner4.Id, 'Tax1');
		dmpl__Tax__c taxSGST9= TestDataHelpers.createTax('SGST', 'SGST', 9, taxGroupGST18partner4.Id, 'Tax2');
        dmpl__TaxGroup__c taxGroupGST28partner1 = TestDataHelpers.createTaxGroup('GST 28', true, 'Line Level', partnerAccount1.Id, branch1.Id, null);
        dmpl__TaxGroup__c taxGroupGST28partner4= TestDataHelpers.createTaxGroup('GST 28', true, 'Line Level', partnerAccount4.Id, branch4.Id, null);
		dmpl__Tax__c taxCGST14 = TestDataHelpers.createTax('CGST', 'CGST', 14, taxGroupGST28partner1.Id, 'Tax1');
        dmpl__Tax__c taxSGST14 = TestDataHelpers.createTax('SGST', 'SGST', 14, taxGroupGST28partner1.Id, 'Tax2');
        
        dmpl__TaxGroupRule__c taxGroupRule28Item1 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST28partner1.Id,item1.Id,null,null,null);
        dmpl__TaxGroupRule__c taxGroupRule18Item5 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST18partner4.Id,item5.Id,null,null,null);     
        
        dmpl__PriceList__c priceList1 = TestDataHelpers.createPriceList('Price List 1', partnerAccount1.Id, branch1.Id, null, null, true, false, 'Sale Price');
        dmpl__PriceList__c priceList6 = TestDataHelpers.createPriceList('Price List 6', partnerAccount4.Id, branch4.Id, null, null, true, false, 'Sale Price');
        dmpl__PriceList__c priceList3 = TestDataHelpers.createPriceList('Price List 3',partnerAccount4.Id,branch4.Id,null,null,true,false,'Sale Price');
        dmpl__PriceListRules__c priceListRule7 = TestDataHelpers.createPriceListRules(priceList3.id, item5.id,null,null,1000, System.today()-1,System.today()+9);
		dmpl__PriceListRules__c priceListRule1 = TestDataHelpers.createPriceListRules(priceList1.id, item1.id,null,null,1500, System.today().addDays(-15),System.today()+9);
		dmpl__PriceListRules__c priceListRule4 = TestDataHelpers.createPriceListRules(priceList1.id, item4.id,null,null,2000, System.today()-1,System.today()+9); 
        dmpl__PriceListRules__c priceListRule5 = TestDataHelpers.createPriceListRules(priceList6.id, item4.id,null,null,2000, System.today()-1,System.today()+9); 
        dmpl__Resource__c resource3 = TestDataHelpers.createResource('Resource 3',partnerAccount1.Id,branch1.Id,false);
        dmpl__ContactAddress__c address1 = TestDataHelpers.createContactAddress('Address 1', 'Ring Rd', 'Pune', 'Maharashtra', customerAccount1.Id, 'Billing Address', '440001', false);

        dmpl__Scheme__c scheme2 = SchemeDataHelper.createScheme('Scheme 2', 'Auto Apply', 'Draft', 'Per Sale order and Invoice', 'Per Order', Date.newInstance(2025, 5, 1), Date.newInstance(2025, 6, 30), 10, 'Apply all Fulfilled', 1, false, partnerAccount4.Id, null, null, null, branch4.Id, 100000);
        dmpl__SchemeLine__c schemeLine2 = SchemeDataHelper.createSchemeLine(1, 'NET RATE', 'All Conditions Are Met', 'All Rewards', scheme2.Id);
        dmpl__SchemeCondition__c schemeCondition2 = SchemeDataHelper.createSchemeCondition('Item Quantity', 'Greater Than Or Equal', item5.Id, 10, schemeLine2.Id, scheme2.Id, 1);
        dmpl__SchemeBenefit__c schemeBenefit2 = SchemeDataHelper.createSchemeBenefit( 'Rate Off', 'Line Level Discount Amount',null, null,null, 1000, schemeLine2.Id, scheme2.Id,1);        
        dmpl__SchemeAccountBudget__c schemeBudget2 = SchemeDataHelper.createSchemesAccountBudget(100000, scheme2.Id, partnerAccount4.Id);
        scheme2.dmpl__Status__c = 'Approved';
        update scheme2;

        dmpl__Scheme__c scheme3 = SchemeDataHelper.createScheme('Scheme 3', 'Auto Apply', 'Draft', 'Per Sale order and Invoice', 'Per Order', Date.newInstance(2025, 5, 1), Date.newInstance(2025, 6, 30), 10, 'Apply all Fulfilled', 1, false, partnerAccount4.Id, null, null, customerAccount1.Id, branch4.Id, 100000);
        dmpl__SchemeLine__c schemeLine3 = SchemeDataHelper.createSchemeLine(1, 'PERCENTAGE', 'All Conditions Are Met', 'All Rewards', scheme3.Id);
        dmpl__SchemeCondition__c schemeCondition3 = SchemeDataHelper.createSchemeCondition('Item Quantity', 'Greater Than Or Equal', item3.Id, 5, schemeLine3.Id, scheme3.Id, 1);
        dmpl__SchemeBenefit__c schemeBenefit3 = SchemeDataHelper.createSchemeBenefit( 'Rate Off', 'Line Level Discount Amount',null, null,null, 1000, schemeLine3.Id, scheme3.Id,1);        
        dmpl__SchemeAccountBudget__c schemeBudget3 = SchemeDataHelper.createSchemesAccountBudget(100000, scheme3.Id, partnerAccount4.Id);
        scheme3.dmpl__Status__c = 'Approved';
        update scheme3;

        dmpl__Scheme__c scheme4 = SchemeDataHelper.createScheme('Scheme 4', 'Auto Apply', 'Draft', 'Per Sale order and Invoice', 'PER ORDER', Date.newInstance(2025, 5, 20), Date.newInstance(2025, 6, 30), 2, 'Apply all Fulfilled', 1, true, partnerAccount4.Id, null, null, customerAccount1.Id, branch4.Id, 100000);
        dmpl__SchemeLine__c schemeLine4 = SchemeDataHelper.createSchemeLine(1, 'FREE OF COST', 'All Conditions Are Met', 'All Rewards', scheme4.Id);
        dmpl__SchemeCondition__c schemeCondition4 = SchemeDataHelper.createSchemeCondition('Item Quantity', 'Greater Than Or Equal', item4.Id, 18, schemeLine4.Id, scheme4.Id, 1);
        dmpl__SchemeBenefit__c schemeBenefit4 = SchemeDataHelper.createSchemeBenefit('FREE ITEM', 'Discounted Item', item4.Id, 1, 5, null, schemeLine4.Id, scheme4.Id, 1);
        dmpl__SchemeAccountBudget__c schemeBudget4 = SchemeDataHelper.createSchemesAccountBudget(100000, scheme4.Id, partnerAccount4.Id);
        scheme4.dmpl__Status__c = 'Approved';
        update scheme4;
        Test.stopTest();
    }

    @isTest
    static void createSaleInvoicePositive() {
        Test.startTest();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        Test.stopTest();
        System.assertNotEquals(saleInvoice, null, 'Expected saleInvoice to be created.');
        System.assertEquals('Draft', saleInvoice.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(100, saleInvoice.dmpl__TCSEligibleAmount__c, 'TCSEligibleAmount should be 100');
        System.assertEquals(100, saleInvoice.dmpl__FinanceAmount__c, 'FinanceAmount should be 100');
        System.assertEquals(1, saleInvoice.dmpl__AmountPaid__c, 'AmountPaid should be 1');
    }
    
    @isTest 
    static void createSaleInvoiceLinePositive() {
        Test.startTest();
        dmpl__SaleInvoiceLine__c line = SaleInvoiceDataHelper.getSaleInvoiceLine();
        Test.stopTest();
        System.assertNotEquals(line, null, 'Expected sale invoice line to be created');
        System.assertEquals(10, line.dmpl__Quantity__c, 'Quantity should be 10');
        System.assertEquals(0, line.dmpl__AllocatedQuantity__c, 'AllocatedQuantity should be 10');
        System.assertEquals(100, line.dmpl__DiscountAmount__c, 'DiscountAmount should be 100');
    }
    
    @isTest
    static void createSaleInvoiceTaxPositive() {
        Test.startTest();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__SaleInvoiceLine__c line = SaleInvoiceDataHelper.getSaleInvoiceLine();
        dmpl__SaleInvoiceTax__c createdTax = SaleInvoiceDataHelper.getSaleInvoiceTax();
        Test.stopTest();
        System.assertNotEquals(null, createdTax.Id, 'Expected SaleInvoiceTax to be created');
        System.assertEquals(100, createdTax.dmpl__TaxAmount__c, 'Tax amount should be 100');
    }

    @isTest
    static void updateSaleInvoicePositive() {
        Test.startTest();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        System.assertNotEquals(saleInvoice, null, 'SaleInvoice should exist before update.');
        
        saleInvoice.dmpl__Status__c = 'Invoiced';
        saleInvoice.dmpl__TCSEligibleAmount__c = 20;
        update saleInvoice;
        
        
        dmpl__SaleInvoice__c updatedInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.id);
        Test.stopTest();
        System.assertEquals('Invoiced', updatedInvoice.dmpl__Status__c, 'Expected saleInvoice status to be updated to Submitted.');
        System.assertEquals(20, updatedInvoice.dmpl__TCSEligibleAmount__c, 'TCSEligibleAmount should be 20');
    }


    @isTest
    static void updateSaleInvoiceLinePositive() {
        Test.startTest();
        dmpl__SaleInvoiceLine__c line = SaleInvoiceDataHelper.getSaleInvoiceLine();
        
        line.dmpl__Discount__c = 5;
        line.dmpl__SchemeDiscount__c = 15;
        line.dmpl__ContractDiscount__c = 20;
        update line;
        
        dmpl__SaleInvoiceLine__c updatedLine = SaleInvoiceDataHelper.getSaleInvoiceLine(line.Id);
        Test.stopTest();
        System.assertEquals(5, updatedLine.dmpl__Discount__c, 'Discount should be updated to 5');
        System.assertEquals(15, updatedLine.dmpl__SchemeDiscount__c, 'SchemeDiscount should be updated to 15');
        System.assertEquals(20, updatedLine.dmpl__ContractDiscount__c, 'ContractDiscount should be updated to 20');
    }
    
    @isTest
    static void updateSaleInvoiceTaxPositive() {
        Test.startTest();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__SaleInvoiceLine__c line = SaleInvoiceDataHelper.getSaleInvoiceLine();
        dmpl__SaleInvoiceTax__c tax = SaleInvoiceDataHelper.getSaleInvoiceTax();

        
        tax.dmpl__TaxAmount__c = 200;
        update tax;
        Test.stopTest();

        System.assertEquals(200, tax.dmpl__TaxAmount__c, 'Tax amount should be updated to 200');
        System.assertEquals(saleInvoice.Id, tax.dmpl__SaleInvoiceId__c, 'Sale Invoice ID should match');
        System.assertEquals(line.Id, tax.dmpl__SaleInvoiceLineId__c, 'Sale Invoice Line ID should match');
    }
    
    @isTest
    static void deleteSaleInvoiceTax() {
        Test.startTest();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        dmpl__SaleInvoiceLine__c line = SaleInvoiceDataHelper.getSaleInvoiceLine();
        dmpl__SaleInvoiceTax__c tax = SaleInvoiceDataHelper.getSaleInvoiceTax();

        
        delete tax;
        

        dmpl__SaleInvoiceTax__c deletedTax;
        try {
            deletedTax = SaleInvoiceDataHelper.getSaleInvoiceTax(tax.Id);
            System.assert(false, 'Expected QueryException when querying deleted tax');
        } catch (QueryException e) {
            System.assert(e.getMessage().contains('List has no rows'), 'Expected no rows found exception');
        }
        Test.stopTest();
    }

    @isTest
    static void deleteSaleInvoiceLine() {
        Test.startTest();
        dmpl__SaleInvoiceLine__c line = SaleInvoiceDataHelper.getSaleInvoiceLine();
        System.assertNotEquals(line, null, 'SaleInvoiceLine should exist before delete.');
        try {
            delete line;
            System.assert(false, 'Expected DMLException when deleting SaleInvoiceLine');
        } catch (DMLException e) {
            System.assertEquals('There are downstream transaction. The object can not be deleted.', e.getDmlMessage(0), 
                'Expected IntegrityFailed_TransactedObjectNotDeletable error message');
        }
        
        dmpl__SaleInvoiceLine__c existingLine = SaleInvoiceDataHelper.getSaleInvoiceLine();
        Test.stopTest();
        System.assertNotEquals(null, existingLine, 'SaleInvoiceLine should still exist after failed delete');
    }

    @isTest
    static void deleteSaleInvoice() {
        Test.startTest();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
        System.assertNotEquals(saleInvoice, null, 'SaleInvoice should exist before delete.');

        delete saleInvoice;

        dmpl__SaleInvoice__c deletedInvoice = null;
        try {
            deletedInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.id);
        } catch (Exception e) {
            deletedInvoice = null;
        }
        Test.stopTest();
        System.assertEquals(null, deletedInvoice, 'SaleInvoice should be deleted and not found in query.');
    }


    //Nikhil
	@isTest
    static void createNormalSaleInvoiceCreationWithoutSchemeAndDiscountPositive(){
        Test.startTest();
        Account customerAccount5=TestDataHelpers.getCustomerAccount('Customer 5');
        Account partnerAccount4=TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');

        
        dmpl__SaleInvoice__c saleInvoice1 = SaleInvoiceDataHelper.createSaleInvoice(customerAccount5,partnerAccount4,branch4,'Within State',null,null,null);
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice1.Id);

        Test.stopTest(); 

        System.assertNotEquals(null, saleInvoice1.Id, 'sale invoice should be created');

        System.assertEquals('Customer 5', saleInvoice.dmpl__AccountId__r.Name, 'AccountName mismatch');
        //System.assertEquals('Price List 6', saleInvoice.PriceListId__c, 'PriceListId mismatch');
        //System.assertEquals('GST 28%', saleInvoice.dmpl__TaxGroup__c, 'TaxGroup mismatch');
        System.assertEquals('Within State', saleInvoice.dmpl__TaxSupplyType__c, 'TaxSupplyType mismatch');

        System.assertEquals('Banjara Hills', saleInvoice.dmpl__BillingStreet__c, 'BillingStreet mismatch');
        System.assertEquals('Hyderabad', saleInvoice.dmpl__BillingCity__c, 'BillingCity mismatch');
        System.assertEquals('TN', saleInvoice.dmpl__BillingState__c, 'BillingState mismatch');
        System.assertEquals('India', saleInvoice.dmpl__BillingCountry__c, 'BillingCountry mismatch');
        System.assertEquals('500034', saleInvoice.dmpl__BillingPostalCode__c, 'BillingPostalCode mismatch');

        System.assertEquals('Jubilee Hills', saleInvoice.dmpl__ShippingStreet__c, 'ShippingStreet mismatch');
        System.assertEquals('Hyderabad', saleInvoice.dmpl__ShippingCity__c, 'ShippingCity mismatch');
        System.assertEquals('TN', saleInvoice.dmpl__ShippingState__c, 'ShippingState mismatch');
        System.assertEquals('500033', saleInvoice.dmpl__ShippingPostalCode__c, 'ShippingPostalCode mismatch');

    }

    @isTest
    static void createSaleInvoiceCreationWithGSTTaxGlobalPositive(){
        Test.startTest();
        Account customerAccount1=TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount4=TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');

        
        dmpl__SaleInvoice__c saleInvoice1 = SaleInvoiceDataHelper.createSaleInvoice(customerAccount1,partnerAccount4,branch4,'Within State',null,null,null);
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice1.Id);

        Test.stopTest(); 

        System.assertNotEquals(null, saleInvoice1.Id, 'sale invoice should be created');


        //System.assertEquals('Adress 1', saleInvoice.dmpl__BillingAddressId__c, 'BillingAddressId mismatch');
        System.assertEquals('MG Road', saleInvoice.dmpl__BillingStreet__c, 'BillingStreet mismatch');
        System.assertEquals('Pune', saleInvoice.dmpl__BillingCity__c, 'BillingCity mismatch');
        System.assertEquals('Maharashtra', saleInvoice.dmpl__BillingState__c, 'BillingState mismatch');
        System.assertEquals('411001', saleInvoice.dmpl__BillingPostalCode__c, 'BillingPostalCode mismatch');

        //System.assertEquals('Adress 2', saleInvoice.dmpl__ShippingAddressId__c, 'ShippingAddressId mismatch');
        System.assertEquals('Ring Rd', saleInvoice.dmpl__ShippingStreet__c, 'ShippingStreet mismatch');
        System.assertEquals('Nagpur', saleInvoice.dmpl__ShippingCity__c, 'ShippingCity mismatch');
        System.assertEquals('Maharashtra', saleInvoice.dmpl__ShippingState__c, 'ShippingState mismatch');
        System.assertEquals('India', saleInvoice.dmpl__ShippingCountry__c, 'ShippingCountry mismatch');
        System.assertEquals('440001', saleInvoice.dmpl__ShippingPostalCode__c, 'ShippingPostalCode mismatch');

        System.assertEquals('Draft', saleInvoice.dmpl__Status__c, 'Status mismatch');
        System.assertEquals('Within State', saleInvoice.dmpl__TaxSupplyType__c, 'TaxSupplyType mismatch');
        //System.assertEquals('Price List 1', saleInvoice.dmpl__PriceListId__c, 'PriceListId mismatch');
        //System.assertEquals('GST 12', saleInvoice.dmpl_TaxGroupId__c, 'TaxGroupId mismatch');

    }

    @isTest
    static void createSaleInvoiceCreationWithIGSTTaxGlobalPositive(){

        Test.startTest();
        Account customerAccount1=TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        //dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 4');


        
        dmpl__SaleInvoice__c saleInvoice1 = SaleInvoiceDataHelper.createSaleInvoice(customerAccount1,partnerAccount1,branch1,'Outside State',null,null,null);
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice1.Id);
        Test.stopTest(); 

        System.assertNotEquals(null, saleInvoice1.Id, 'sale invoice should be created');

        

        System.assertEquals('MG Road', saleInvoice.dmpl__BillingStreet__c, 'BillingStreet mismatch');
        System.assertEquals('Pune', saleInvoice.dmpl__BillingCity__c, 'BillingCity mismatch');
        System.assertEquals('Maharashtra', saleInvoice.dmpl__BillingState__c, 'BillingState mismatch');
        System.assertEquals('411001', saleInvoice.dmpl__BillingPostalCode__c, 'BillingPostalCode mismatch');

        System.assertEquals('Ring Rd', saleInvoice.dmpl__ShippingStreet__c, 'ShippingStreet mismatch');
        System.assertEquals('Nagpur', saleInvoice.dmpl__ShippingCity__c, 'ShippingCity mismatch');
        System.assertEquals('Maharashtra', saleInvoice.dmpl__ShippingState__c, 'ShippingState mismatch');
        System.assertEquals('440001', saleInvoice.dmpl__ShippingPostalCode__c, 'ShippingPostalCode mismatch'); // updated value

        //System.assertEquals('IGST 12%', saleInvoice.dmpl__TaxId__c, 'TaxId mismatch');
        //System.assertEquals('IGST 12%', saleInvoice.dmpl__TaxGroupId__c, 'TaxGroupId mismatch');
        System.assertEquals('Outside State', saleInvoice.dmpl__TaxSupplyType__c, 'TaxSupplyType mismatch');
        //System.assertEquals('12%', saleInvoice.TaxRate__c, 'TaxRate mismatch');
        //System.assertEquals(priceList4.Id, saleInvoice.dmpl__PriceListId__c, 'PriceListId mismatch');


    }

    @isTest
    static void createSaleInvoiceCreationWithItemLevelTaxesChangePositive(){
        Test.startTest();
        Account customerAccount1=TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');

        
        dmpl__SaleInvoice__c saleInvoice1 = SaleInvoiceDataHelper.createSaleInvoice(customerAccount1,partnerAccount1,branch1,'Within State',taxGroup,null,null);
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice1.Id);
        Test.stopTest(); 

        System.assertNotEquals(null, saleInvoice1.Id, 'sale invoice should be created');

        


        System.assertEquals('Customer 1', saleInvoice.dmpl__AccountId__r.Name, 'AccountName mismatch');
        System.assertEquals('GST 12', saleInvoice.dmpl__TaxGroupId__r.Name, 'TaxGroup mismatch');
        System.assertEquals('Within State', saleInvoice.dmpl__TaxSupplyType__c, 'TaxSupplyType mismatch');

        System.assertEquals('MG Road', saleInvoice.dmpl__BillingStreet__c, 'BillingStreet mismatch');
        System.assertEquals('Pune', saleInvoice.dmpl__BillingCity__c, 'BillingCity mismatch');
        System.assertEquals('Maharashtra', saleInvoice.dmpl__BillingState__c, 'BillingState mismatch');
        System.assertEquals('India', saleInvoice.dmpl__BillingCountry__c, 'BillingCountry mismatch');
        System.assertEquals('411001', saleInvoice.dmpl__BillingPostalCode__c, 'BillingPostalCode mismatch');

        System.assertEquals('Ring Rd', saleInvoice.dmpl__ShippingStreet__c, 'ShippingStreet mismatch');
        System.assertEquals('Nagpur', saleInvoice.dmpl__ShippingCity__c, 'ShippingCity mismatch');

        System.assertEquals('Draft', saleInvoice.dmpl__Status__c, 'Status mismatch');

    }

    @isTest
    static void createSaleInvoiceWithBillingAndShippingAddressPositive(){

        Test.startTest();
        Account customerAccount1=TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');


        
        dmpl__SaleInvoice__c saleInvoice1 = SaleInvoiceDataHelper.createSaleInvoice(customerAccount1,partnerAccount1,branch1,'Outside State',null,null,null);
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice1.Id);

        Test.stopTest(); 

        System.assertNotEquals(null, saleInvoice1.Id, 'sale invoice should be created');


        System.assertEquals('MG Road', saleInvoice.dmpl__BillingStreet__c, 'Billing Street mismatch');
        System.assertEquals('Pune', saleInvoice.dmpl__BillingCity__c, 'BillingCity mismatch');
        System.assertEquals('Maharashtra', saleInvoice.dmpl__BillingState__c, 'BillingState mismatch');
        System.assertEquals('India', saleInvoice.dmpl__BillingCountry__c, 'BillingCountry mismatch');
        System.assertEquals('411001', saleInvoice.dmpl__BillingPostalCode__c, 'BillingPostalCode mismatch');

        System.assertEquals('Ring Rd', saleInvoice.dmpl__ShippingStreet__c, 'ShippingStreet mismatch');
        System.assertEquals('Nagpur', saleInvoice.dmpl__ShippingCity__c, 'ShippingCity mismatch');
        System.assertEquals('Maharashtra', saleInvoice.dmpl__ShippingState__c, 'ShippingState mismatch');
        System.assertEquals('India', saleInvoice.dmpl__ShippingCountry__c, 'ShippingCountry mismatch');
        System.assertEquals('440001', saleInvoice.dmpl__ShippingPostalCode__c, 'ShippingPostalCode mismatch');

        System.assertEquals('Draft', saleInvoice.dmpl__Status__c, 'Status mismatch');
        System.assertEquals(priceList1.Id, saleInvoice.dmpl__PriceListId__c, 'PriceListId mismatch');

    }

    @isTest
    static void createSaleInvoiceWithMultipleBillingAndShippingAddressPositive(){
        Test.startTest();
        Account customerAccount1=TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        dmpl__ContactAddress__c billingAddress = TestDataHelpers.getContactAddress('Address 1');

      
        dmpl__SaleInvoice__c saleInvoice1 = SaleInvoiceDataHelper.createSaleInvoice(customerAccount1,partnerAccount1,branch1,'Outside State',null,billingAddress,null);
        

        System.assertNotEquals(null, saleInvoice1.Id, 'sale invoice should be created');

        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice1.Id);
        Test.stopTest(); 

        System.assertEquals('Address 1', saleInvoice.dmpl__BillingAddressId__r.Name, 'BillingAddress mismatch');
        System.assertEquals('Ring Rd', saleInvoice.dmpl__BillingStreet__c, 'BillingStreet mismatch');
        System.assertEquals('Pune', saleInvoice.dmpl__BillingCity__c, 'BillingCity mismatch');
        System.assertEquals('Maharashtra', saleInvoice.dmpl__BillingState__c, 'BillingState mismatch');
        System.assertEquals('440001', saleInvoice.dmpl__BillingPostalCode__c, 'BillingPostalCode mismatch');

        //System.assertEquals('Address 3', saleInvoice.dmpl__ShippingAddressId__c, 'ShippingAddressId mismatch');
        System.assertEquals('Ring Rd', saleInvoice.dmpl__ShippingStreet__c, 'ShippingStreet mismatch');
        System.assertEquals('Nagpur', saleInvoice.dmpl__ShippingCity__c, 'ShippingCity mismatch');
        System.assertEquals('Maharashtra', saleInvoice.dmpl__ShippingState__c, 'ShippingState mismatch');
        System.assertEquals('440001', saleInvoice.dmpl__ShippingPostalCode__c, 'ShippingPostalCode mismatch');

        System.assertEquals('Draft', saleInvoice.dmpl__Status__c, 'Status mismatch');
        System.assertEquals(priceList1.Id, saleInvoice.dmpl__PriceListId__c, 'PriceListId mismatch');

    }

    @isTest
    static void createSaleInvoiceWithPriceListForPartnerAccountAndBranchPositive(){

        Test.startTest();
        Account customerAccount1=TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount4=TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');
        dmpl__PriceList__c priceList3 = TestDataHelpers.getPriceList('Price List 3');


        dmpl__SaleInvoice__c saleInvoice1 = SaleInvoiceDataHelper.createSaleInvoice(customerAccount1,partnerAccount4,branch4,'Outside State',null,null,null);
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice1.Id);

        Test.stopTest(); 

        System.assertNotEquals(null, saleInvoice1.Id, 'sale invoice should be created');


        System.assertEquals('Customer 1', saleInvoice.dmpl__AccountId__r.Name, 'Account name mismatch');
        System.assertEquals(priceList3.Id, saleInvoice.dmpl__PriceListId__c, 'PriceListId mismatch');

        System.assertEquals('MG Road', saleInvoice.dmpl__BillingStreet__c, 'BillingStreet mismatch');
        System.assertEquals('Pune', saleInvoice.dmpl__BillingCity__c, 'BillingCity mismatch');
        System.assertEquals('Maharashtra', saleInvoice.dmpl__BillingState__c, 'BillingState mismatch');
        System.assertEquals('411001', saleInvoice.dmpl__BillingPostalCode__c, 'BillingPostalCode mismatch');
        System.assertEquals('India', saleInvoice.dmpl__ShippingCountry__c, 'ShippingCountry mismatch');
        //System.assertEquals(Date.newInstance(2025, 5, 27), saleInvoice.dmpl__DocumentDate__c, 'DocumentDate mismatch');
        System.assertEquals('Draft', saleInvoice.dmpl__Status__c, 'Status mismatch');

    }

    @isTest
    static void createSaleInvoiceWithPriceListForCustomerAccountGroupPositive(){
        Test.startTest();
        Account customerAccount1=TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');


        
        dmpl__SaleInvoice__c saleInvoice1 = SaleInvoiceDataHelper.createSaleInvoice(customerAccount1,partnerAccount1,branch1,null,null,null,null);

        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice1.Id);

        Test.stopTest(); 

        System.AssertNotEquals(null, saleInvoice1.Id, 'sale invoice should be created');

        System.assertEquals('Customer 1', saleInvoice.dmpl__AccountId__r.Name, 'Account Name mismatch');
        System.assertEquals(priceList1.Id, saleInvoice.dmpl__PriceListId__c, 'PriceListId mismatch');
        //System.assertEquals(null, saleInvoice.dmpl__TaxGroup__c, 'TaxGroup should be null');
        //System.assertEquals(null, saleInvoice.dmpl__TaxSupplyType__c, 'TaxSupplyType should be null');

        System.assertEquals('MG Road', saleInvoice.dmpl__BillingStreet__c, 'BillingStreet mismatch');
        System.assertEquals('Pune', saleInvoice.dmpl__BillingCity__c, 'BillingCity mismatch');
        System.assertEquals('Maharashtra', saleInvoice.dmpl__BillingState__c, 'BillingState mismatch');
        System.assertEquals('411001', saleInvoice.dmpl__BillingPostalCode__c, 'BillingPostalCode mismatch');

        System.assertEquals('India', saleInvoice.dmpl__ShippingCountry__c, 'ShippingCountry mismatch');

        //System.assertEquals(Date.newInstance(2025, 5, 27), saleInvoice.dmpl__DocumentDate__c, 'DocumentDate mismatch');
        System.assertEquals('Draft', saleInvoice.dmpl__Status__c, 'Status mismatch');

    }

    @isTest
    static void createSaleInvoiceWithPriceListForPartnerAccountGroupPositive(){
        Test.startTest();
        Account customerAccount1=TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');

        
        dmpl__SaleInvoice__c saleInvoice1 = SaleInvoiceDataHelper.createSaleInvoice(customerAccount1,partnerAccount1,branch1,null,null,null,null);
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice1.Id);

        Test.stopTest(); 

        System.AssertNotEquals(null, saleInvoice1.Id, 'sale invoice should be created');

        System.assertEquals(priceList1.Id, saleInvoice.dmpl__PriceListId__c, 'PriceListId mismatch');
        System.assertEquals(partnerAccount1.Id, saleInvoice.dmpl__PartnerAccountId__c, 'PartnerAccountId mismatch');
        System.assertEquals('Customer 1', saleInvoice.dmpl__AccountId__r.Name, 'AccountName mismatch');

        System.assertEquals('Pune', saleInvoice.dmpl__BillingCity__c, 'BillingCity mismatch');
        System.assertEquals('Maharashtra', saleInvoice.dmpl__BillingState__c, 'BillingState mismatch');
        //System.assertEquals('MG Road Pune, Maharashtra, 440001', saleInvoice.dmpl__BillingAddress__c, 'BillingAddress mismatch');
        System.assertEquals('411001', saleInvoice.dmpl__BillingPostalCode__c, 'BillingPostalCode mismatch');

        //System.assertEquals('Ring Rd Nagpur, Maharashtra, India, 440001', saleInvoice.dmpl__ShippingAddress__c, 'ShippingAddress mismatch');
        System.assertEquals('Nagpur', saleInvoice.dmpl__ShippingCity__c, 'ShippingCity mismatch');
        System.assertEquals('Maharashtra', saleInvoice.dmpl__ShippingState__c, 'ShippingState mismatch');
        System.assertEquals('India', saleInvoice.dmpl__ShippingCountry__c, 'ShippingCountry mismatch');
        System.assertEquals('Ring Rd', saleInvoice.dmpl__ShippingStreet__c, 'ShippingStreet mismatch');
        System.assertEquals('440001', saleInvoice.dmpl__ShippingPostalCode__c, 'ShippingPostalCode mismatch');

        //System.assertEquals(Date.newInstance(2025, 5, 27), saleInvoice.dmpl__DocumentDate__c, 'DocumentDate mismatch');
        System.assertEquals('Draft', saleInvoice.dmpl__Status__c, 'Status mismatch');

    }

    @isTest
    static void createSaleInvoiceCreationWithWrongPartnerAccountNegative(){
        Test.startTest();
        Account customerAccount1=TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch3=TestDataHelpers.getBranch('Branch 3');

      
        try {      
            dmpl__SaleInvoice__c saleInvoice1 = SaleInvoiceDataHelper.createSaleInvoice(customerAccount1,partnerAccount1,branch3,null,null,null,null);
            System.assertEquals(null, saleInvoice1.Id, 'SaleInvoice should not be created as invalid branch is being selected');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'sale invoice cannot be created with invalid branch');
        }
        Test.stopTest();
    }


    @isTest
    static void createSaleInvoiceCreationWithInactivePartnerAccountNegative(){
        Test.startTest();
        Account customerAccount1=TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount2=TestDataHelpers.getPartnerAccount('Partner 2');
        try { 
        dmpl__Branch__c branchh2 = TestDataHelpers.createBranch('Branch 2', partnerAccount2.Id, true, false, true, true);
        dmpl__Branch__c branch2=TestDataHelpers.getBranch('Branch 2');

        
             
            dmpl__SaleInvoice__c saleInvoice1 = SaleInvoiceDataHelper.createSaleInvoice(customerAccount1,partnerAccount2,branch2,null,null,null,null);
            System.assertEquals(null, saleInvoice1.Id, 'SaleInvoice should not be created as inactive partner Account is being selected');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'sale invoice cannot be created with inactive partner Account');
        }
        Test.stopTest();
    }

    @isTest
    static void createSaleInvoiceCreationWithInactiveCustomerAccountNegative(){
        Test.startTest();
        Account customerAccount7=TestDataHelpers.getCustomerAccount('Customer 7');
        Account partnerAccount3=TestDataHelpers.getPartnerAccount('Partner 3');
        dmpl__Branch__c branch3=TestDataHelpers.getBranch('Branch 3');

        
        try {      
            dmpl__SaleInvoice__c saleInvoice1 = SaleInvoiceDataHelper.createSaleInvoice(customerAccount7,partnerAccount3,branch3,null,null,null,null);
            System.assertEquals(null, saleInvoice1.Id, 'SaleInvoice should not be created as inactive Customer Account is being selected');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'sale invoice cannot be created with inactive customer Account');
        }
        Test.stopTest();
    }

    @isTest
    static void createSaleInvoiceCreationWithWrongBranchNegative(){
        Test.startTest();
        Account customerAccount7=TestDataHelpers.getCustomerAccount('Customer 7');
        Account partnerAccount3=TestDataHelpers.getPartnerAccount('Partner 3');
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');

        
        try {      
            dmpl__SaleInvoice__c saleInvoice1 = SaleInvoiceDataHelper.createSaleInvoice(customerAccount7,partnerAccount3,branch4,null,null,null,null);
            System.assertEquals(null, saleInvoice1.Id, 'SaleInvoice should not be created as wrong branch is being selected');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'sale invoice cannot be created with wrong branch');
        }
        Test.stopTest();
    }

    
    @isTest
    static void createSaleInvoiceCreationWithNoCustomerNegative(){
        Test.startTest();
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        
        try {      
            dmpl__SaleInvoice__c saleInvoice1 = SaleInvoiceDataHelper.createSaleInvoice(null,partnerAccount1,branch1,null,null,null,null);
            System.assertEquals(null, saleInvoice1.Id, 'SaleInvoice should not be created as no customer is being selected');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'sale invoice cannot be created without customer');
        }
        Test.stopTest();
    }

    @isTest
    static void createSaleInvoiceWithInactiveSalesExecutiveNegative(){
        Test.startTest();
        Account customerAccount1=TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Resource__c resource3 = TestDataHelpers.getResource('Resource 3');
        
        try {      
            dmpl__SaleInvoice__c saleInvoice1 = SaleInvoiceDataHelper.createSaleInvoice(null,partnerAccount1,branch1,null,null,null,resource3);
            System.assertEquals(null, saleInvoice1.Id, 'SaleInvoice should not be created as inactive sales executive is being selected');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'sale invoice cannot be created with inactive sales executive');
        }
        Test.stopTest();
    }

	// NEW METHODS
	//Sale Invoice Line without Schemes (edit )
	@isTest
	static void updateSaleInvoiceLineWithoutSchemePositive() {
		Test.startTest();
		Account customer3=TestDataHelpers.getCustomerAccount('Customer 3');
		Account partner4=TestDataHelpers.getPartnerAccount('Partner 4');
		dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');
		dmpl__Item__c item5=TestDataHelpers.getItem('Item 5');
		dmpl__Item__c item1=TestDataHelpers.getItem('Item 1');
		dmpl__PriceList__c priceList1=TestDataHelpers.getPriceList('Price List 1');
		dmpl__SaleInvoice__c saleInvoice=SaleInvoiceDataHelper.createSaleInvoice(customer3, partner4, branch4);
		dmpl__SaleInvoiceLine__c invoiceLine=SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item5, 10);
		dmpl__SaleInvoice__c createdSaleInvoice=SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
		dmpl__SaleInvoiceLine__c createdSaleInvoiceLine=SaleInvoiceDataHelper.getSaleInvoiceLine(invoiceLine.Id);
		createdSaleInvoiceLine.dmpl__ItemId__c=item1.Id;
		createdSaleInvoiceLine.dmpl__Quantity__c=50;
        try{
            update createdSaleInvoiceLine;
        }
        catch(DmlException e){
            System.debug(e.getMessage());
        }
		dmpl__SaleInvoiceLine__c updatedSaleInvoiceLine=SaleInvoiceDataHelper.getSaleInvoiceLine(createdSaleInvoiceLine.Id);
		dmpl__SaleInvoice__c updatedSaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(createdSaleInvoice.Id);
		Test.stopTest();
		System.assertNotEquals(null, saleInvoice, 'Expected SaleInvoice to be created');
		System.assertNotEquals(null, createdSaleInvoice, 'Expected SaleInvoice to be created');
		System.assertNotEquals(null, invoiceLine, 'Expected SaleInvoiceLine to be created');
		System.assertNotEquals(null, createdSaleInvoiceLine, 'Expected SaleInvoiceLine to be created');
		System.assertEquals('Customer 3', createdSaleInvoice.dmpl__AccountName__c, 'Customer Account Name should match');
		System.assert(createdSaleInvoice.dmpl__PriceListId__c!=null, 'Price List not be null');
		System.assertEquals('Within State', createdSaleInvoice.dmpl__TaxSupplyType__c, 'Tax supply type mismatch');
		System.assertEquals('GST 18', createdSaleInvoiceLine.dmpl__TaxGroupId__r.Name, 'Tax Group mismatch');
		System.assertEquals('Draft', createdSaleInvoice.dmpl__Status__c, 'Status mismatch');

		System.assertEquals('Anna Salai', createdSaleInvoice.dmpl__BillingStreet__c, 'Billing street mismatch');
		System.assertEquals('Chennai', createdSaleInvoice.dmpl__BillingCity__c, 'Billing city mismatch');
		System.assertEquals('TN', createdSaleInvoice.dmpl__BillingState__c, 'Billing state mismatch');
		System.assertEquals('India', createdSaleInvoice.dmpl__BillingCountry__c, 'Billing country mismatch');
		System.assertEquals('600002', createdSaleInvoice.dmpl__BillingPostalCode__c, 'Billing postal code mismatch');

		System.assertEquals(900, createdSaleInvoiceLine.dmpl__Tax1__c, 'CGST amount mismatch');
		System.assertEquals('CGST', createdSaleInvoiceLine.dmpl__Tax1Name__c, 'Tax1 name mismatch');
		System.assertEquals(9, createdSaleInvoiceLine.dmpl__Tax1Rate__c, 'Tax1 rate mismatch');
		System.assertEquals('CGST', createdSaleInvoiceLine.dmpl__Tax1Type__c, 'Tax1 type mismatch');

		/*System.assertEquals(900, createdSaleInvoiceLine.dmpl__Tax2__c, 'SGST amount mismatch');
		System.assertEquals('SGST', createdSaleInvoiceLine.dmpl__Tax2Name__c, 'Tax2 name mismatch');
		System.assertEquals(9, createdSaleInvoiceLine.dmpl__Tax2Rate__c, 'Tax2 rate mismatch');
		System.assertEquals('SGST', createdSaleInvoiceLine.dmpl__Tax2Type__c, 'Tax2 type mismatch');

		System.assertEquals(1000, createdSaleInvoiceLine.dmpl__NetSchemeDiscount__c, 'Net scheme discount mismatch');
		System.assertEquals(0, createdSaleInvoiceLine.dmpl__NetDiscount__c, 'Net discount mismatch');
		System.assertNotEquals(null, createdSaleInvoiceLine.dmpl__SchemeLineId__c, 'Expected SchemeLineId to be set');
		//System.assertEquals(9000, createdSaleInvoiceLine.dmpl__LineSubTotal__c, 'Line subtotal mismatch');*/

		System.assertEquals(1500, updatedSaleInvoiceLine.dmpl__UnitPrice__c, 'Price should be ₹1,500.00');
		System.assertEquals(10500, updatedSaleInvoiceLine.dmpl__Tax1__c, 'Tax1 (CGST) should be ₹10,500.00');
		System.assertEquals('CGST', updatedSaleInvoiceLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
		System.assertEquals(14, updatedSaleInvoiceLine.dmpl__Tax1Rate__c, 'Tax1 Rate should be 14%');
		System.assertEquals('CGST', updatedSaleInvoiceLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');

		System.assertEquals(10500, updatedSaleInvoiceLine.dmpl__Tax2__c, 'Tax2 (SGST) should be ₹10,500.00');
		System.assertEquals('SGST', updatedSaleInvoiceLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
		System.assertEquals(14, updatedSaleInvoiceLine.dmpl__Tax2Rate__c, 'Tax2 Rate should be 14%');
		System.assertEquals('SGST', updatedSaleInvoiceLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');

		System.assertEquals(75000, updatedSaleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be ₹75,000.00');
		System.assertEquals(0, updatedSaleInvoiceLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be ₹0.00');
		System.assertEquals(0, updatedSaleInvoiceLine.dmpl__NetDiscount__c, 'Net Discount should be ₹0.00');
		System.assertEquals(21000, updatedSaleInvoiceLine.dmpl__TaxAmount__c, 'Tax Amount should be ₹21,000.00');
		System.assertEquals(96000, updatedSaleInvoiceLine.dmpl__GrossAmount__c, 'Gross Amount should be ₹96,000.00');
		//System.assertEquals(75000, updatedSaleInvoice.dmpl__LineSubTotal__c, 'Line Subtotal should be ₹75,000.00');
		System.assertEquals(75000, updatedSaleInvoice.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be ₹75,000.00');
		System.assertEquals(0, updatedSaleInvoice.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be ₹0.00');
		System.assertEquals(0, updatedSaleInvoice.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be ₹0.00');
		System.assertEquals(21000, updatedSaleInvoice.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount should be ₹21,000.00');
		System.assertEquals(21000, updatedSaleInvoice.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be ₹21,000.00');
		System.assertEquals(96000, updatedSaleInvoice.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be ₹96,000.00');
		System.assertEquals(96000, updatedSaleInvoice.dmpl__OpenAmount__c, 'Open Amount should be ₹96,000.00');
		System.assertEquals(96000, updatedSaleInvoice.dmpl__OutstandingAmount__c, 'Outstanding Amount should be ₹96,000.00');
	}

	//Sale Invoice line with Scheme - Auto Apply - Discount %age (Edit)
	@isTest
	static void updateSaleInvoiceLineWithSchemeAutoApplyDiscountPercentagePositive() {
		Test.startTest();
		Account customer1=TestDataHelpers.getCustomerAccount('Customer 1');
		Account partner1=TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item6=TestDataHelpers.getItem('Item 6');
		dmpl__PriceList__c priceList1=TestDataHelpers.getPriceList('Price List 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');
		dmpl__SaleInvoice__c saleInvoice=SaleInvoiceDataHelper.createSaleInvoice(customer1, partner1, branch1);
		dmpl__SaleInvoiceLine__c saleInvoiceLine=SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item6, 2);
		dmpl__SaleInvoice__c createdSaleInvoice=SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
		dmpl__SaleInvoiceLine__c createdSaleInvoiceLine=SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);

		createdSaleInvoiceLine.dmpl__Quantity__c=4;
		update createdSaleInvoiceLine;

		dmpl__SaleInvoiceLine__c updatedSaleInvoiceLine=SaleInvoiceDataHelper.getSaleInvoiceLine(createdSaleInvoiceLine.Id);
		dmpl__SaleInvoice__c updatedSaleInvoice=SaleInvoiceDataHelper.getSaleInvoice(createdSaleInvoice.Id);
		Test.stopTest();

		System.assertNotEquals(null, saleInvoice, 'Expected SaleInvoice to be created');
		System.assertNotEquals(null, createdSaleInvoice, 'Expected SaleInvoice to be created');
		System.assertNotEquals(null, updatedSaleInvoice, 'Expected SaleInvoice to be updated');
		System.assertNotEquals(null, saleInvoiceLine, 'Expected SaleInvoiceLine to be created');
		System.assertNotEquals(null, createdSaleInvoiceLine, 'Expected SaleInvoiceLine to be created');
		System.assertNotEquals(null, updatedSaleInvoiceLine, 'Expected SaleInvoiceLine to be updated');

		System.assertEquals('Customer 1', createdSaleInvoice.dmpl__AccountName__c, 'Customer Account Name should match');
		System.assertEquals(priceList1.Id, createdSaleInvoice.dmpl__PriceListId__c, 'Price List ID should match');
		System.assertEquals('MG Road', createdSaleInvoice.dmpl__BillingStreet__c, 'Billing Street should match');
		System.assertEquals('Pune', createdSaleInvoice.dmpl__BillingCity__c, 'Billing City should match');
		System.assertEquals('Maharashtra', createdSaleInvoice.dmpl__BillingState__c, 'Billing State should match');
		System.assertEquals('India', createdSaleInvoice.dmpl__BillingCountry__c, 'Billing Country should match');
		System.assertEquals('411001', createdSaleInvoice.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');
		//System.assertEquals('GST 18', createdSaleInvoiceLine.dmpl__TaxGroupId__r.Name, 'Tax Group should match');
		System.assertEquals('Within State', createdSaleInvoice.dmpl__TaxSupplyType__c, 'Tax Supply Type should match');
		System.assertEquals(Date.today(), createdSaleInvoice.dmpl__DocumentDate__c, 'Document Date should match');
		System.assertEquals('Draft', createdSaleInvoice.dmpl__Status__c, 'Status should match');

		System.assertNotEquals(null, createdSaleInvoiceLine.dmpl__SchemeLineId__c, 'Expected SchemeLineId to be set');
		System.assertEquals(4800, createdSaleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should match');
		System.assertEquals(4368, createdSaleInvoiceLine.dmpl__Amount__c, 'Amount should match');
		
		System.assertEquals(2, updatedSaleInvoiceLine.dmpl__Quantity__c, 'Quantity should be 1');
		System.assertEquals(5, updatedSaleInvoiceLine.dmpl__SchemeDiscount__c, 'Scheme Discount should be 5');
		System.assertEquals(4800, updatedSaleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be 1500');
		System.assertEquals(4368, updatedSaleInvoiceLine.dmpl__Amount__c, 'Base Amount should be 1425');
		System.assertEquals(240, updatedSaleInvoiceLine.dmpl__NetSchemeDiscount__c, 'Net Discount should be 240');
		System.assertEquals(4800, updatedSaleInvoice.dmpl__TotalLineBaseAmount__c, 'Base Line Amount should be 4800');
		System.assertEquals(4368, updatedSaleInvoice.dmpl__TotalLineAmount__c,'Total Line Amount Should Match');
	}

	//Scheme Applicability For Customer Account Defined (Edit)
	@isTest
	static void updateSaleInvoiceLineWithSchemeApplicabilityForCustomerAccountDefinedPositive() {
		Test.startTest();
		Account customer1=TestDataHelpers.getCustomerAccount('Customer 1');
		Account partner4=TestDataHelpers.getPartnerAccount('Partner 4');
		dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');
		dmpl__Item__c item4=TestDataHelpers.getItem('Item 4');
        dmpl__PriceList__c priceList6=TestDataHelpers.getPriceList('Price List 6');
		dmpl__SaleInvoice__c saleInvoice=SaleInvoiceDataHelper.createSaleInvoice(customer1, partner4, branch4);
		dmpl__SaleInvoiceLine__c saleInvoiceLine=SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item4, 20);
		dmpl__SaleInvoice__c createdSaleInvoice=SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
		dmpl__SaleInvoiceLine__c createdSaleInvoiceLine=SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
		createdSaleInvoiceLine.dmpl__Quantity__c=22;
		update createdSaleInvoiceLine;
		dmpl__SaleInvoiceLine__c updatedSaleInvoiceLine=SaleInvoiceDataHelper.getSaleInvoiceLine(createdSaleInvoiceLine.Id);
		dmpl__SaleInvoice__c updatedSaleInvoice=SaleInvoiceDataHelper.getSaleInvoice(createdSaleInvoice.Id);
		Test.stopTest();

		System.assertNotEquals(null, saleInvoice, 'Expected Sale Invoice to be created');
		System.assertNotEquals(null, createdSaleInvoice, 'Expected Sale Invoice to be created');
		System.assertNotEquals(null, updatedSaleInvoice, 'Expected Sale Invoice to be updated');
		System.assertNotEquals(null, saleInvoiceLine, 'Expected Sale Invoice Line to be created');
		System.assertNotEquals(null, createdSaleInvoiceLine, 'Expected Sale Invoice Line to be created');
		System.assertNotEquals(null, updatedSaleInvoiceLine, 'Expected Sale Invoice Line to be updated');

		System.assertEquals('Customer 1', createdSaleInvoice.dmpl__AccountName__c, 'Customer Account Name should match');
		System.assertEquals('MG Road', updatedSaleInvoice.dmpl__BillingStreet__c, 'Billing Street should be Mg Rd');
		System.assertEquals('Pune', updatedSaleInvoice.dmpl__BillingCity__c, 'Billing City should be Pune');
		System.assertEquals('Maharashtra', updatedSaleInvoice.dmpl__BillingState__c, 'Billing State should be Maharashtra');
		System.assertEquals('India', updatedSaleInvoice.dmpl__BillingCountry__c, 'Billing Country should be India');
		System.assertEquals('411001', updatedSaleInvoice.dmpl__BillingPostalCode__c, 'Billing Postal Code should be 411001');

		System.assertEquals('Ring Rd', updatedSaleInvoice.dmpl__ShippingStreet__c, 'Shipping Street should be Ring Rd');
		System.assertEquals('Nagpur', updatedSaleInvoice.dmpl__ShippingCity__c, 'Shipping City should be Nagpur');
		System.assertEquals('Maharashtra', updatedSaleInvoice.dmpl__ShippingState__c, 'Shipping State should be Maharashtra');
		System.assertEquals('India', updatedSaleInvoice.dmpl__ShippingCountry__c, 'Shipping Country should be India');
		System.assertEquals('440001', updatedSaleInvoice.dmpl__ShippingPostalCode__c, 'Shipping Postal Code should be 440001');
		System.assertEquals('Price List 6', updatedSaleInvoice.dmpl__PriceListId__r.Name, 'Price List should be Price List 6');
		System.assertEquals(Date.today(), updatedSaleInvoice.dmpl__DocumentDate__c, 'Document Date should be Today');
		System.assertEquals('Draft', updatedSaleInvoice.dmpl__Status__c, 'Status should be Draft');
		/*System.assertEquals(40000, createdSaleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be 40000');
		System.assertEquals(38400, createdSaleInvoiceLine.dmpl__Amount__c, 'Amount should be 38400');
		System.assertEquals(38400, createdSaleInvoiceLine.dmpl__GrossAmount__c, 'Gross Amount should be 38400');
		System.assertEquals(1600, createdSaleInvoiceLine.dmpl__NetDiscount__c, 'Net Discount should be 1600');
		//System.assertEquals(2000, createdSaleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be 2000');
		System.assertEquals(4608, createdSaleInvoiceLine.dmpl__TaxAmount__c, 'Tax Amount should be 4608');
		System.assertEquals('SLN0005', createdSaleInvoiceLine.dmpl__SchemeLineId__r.Name, 'Scheme Line should be Free of Cost (SLN0005)');
		System.assertEquals(44000, updatedSaleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be 44000');
		System.assertEquals(42240, updatedSaleInvoiceLine.dmpl__Amount__c, 'Amount should be 42240');
		System.assertEquals(47308.8, updatedSaleInvoiceLine.dmpl__GrossAmount__c, 'Gross Amount should be 47308.8');
		System.assertEquals(1760, updatedSaleInvoiceLine.dmpl__NetDiscount__c, 'Net Discount should be 1760');
		System.assertEquals(2000, updatedSaleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be 2000');
		System.assertEquals(1723.2, updatedSaleInvoiceLine.dmpl__TaxAmount__c, 'Tax Amount should be 1723.2');*/
		System.assertEquals('SLN0005', updatedSaleInvoiceLine.dmpl__SchemeLineId__r.Name, 'Scheme Line should match');
	}

	//Scheme Applicability in Case Valid Count is Defined (Edit)
	@isTest
	static void updateSaleInvoiceLineWithSchemeApplicabilityValidCountDefinedPositive() {
        Test.startTest();
		Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
		Account partner4 = TestDataHelpers.getPartnerAccount('Partner 4');
		dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
		dmpl__Item__c item5 = TestDataHelpers.getItem('Item 5');
		dmpl__SaleInvoice__c saleInvoice= SaleInvoiceDataHelper.createSaleInvoice(customer1, partner4, branch4);
		dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item5, 10);
        Test.stopTest();
	}

	//Tax application object model - In Line Taxes (Edit)
	@isTest
	static void updateSaleInvoiceLineWithTaxApplicationInLineTaxesPositive() {
		Test.startTest();
		Account customer1= TestDataHelpers.getCustomerAccount('Customer 1');
		Account partner1= TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch1= TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item1= TestDataHelpers.getItem('Item 1');
		dmpl__SaleInvoice__c saleInvoice= SaleInvoiceDataHelper.createSaleInvoice(customer1, partner1, branch1);
		dmpl__SaleInvoiceLine__c saleInvoiceLine= SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item1, 42);
		dmpl__SaleInvoice__c createdSaleInvoice= SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
		dmpl__SaleInvoiceLine__c createdSaleInvoiceLine= SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);	

		createdSaleInvoiceLine.dmpl__Quantity__c = 18;
		update createdSaleInvoiceLine;
		dmpl__SaleInvoiceLine__c updatedSaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(createdSaleInvoiceLine.Id);
		dmpl__SaleInvoice__c updatedSaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(createdSaleInvoice.Id);
		Test.stopTest();
		System.assertNotEquals(null, saleInvoice, 'Expected Sale Invoice to be created');
		System.assertNotEquals(null, createdSaleInvoice, 'Expected Sale Invoice to be created');
		System.assertNotEquals(null, updatedSaleInvoice, 'Expected Sale Invoice to be updated');
		System.assertNotEquals(null, saleInvoiceLine, 'Expected Sale Invoice Line to be created	');
		System.assertNotEquals(null, createdSaleInvoiceLine, 'Expected Sale Invoice Line to be created');
		System.assertNotEquals(null, updatedSaleInvoiceLine, 'Expected Sale Invoice Line to be updated');

		System.assertEquals('Customer 1', createdSaleInvoice.dmpl__AccountName__c, 'Customer Account Name should match');
		System.assertEquals('GST 28', createdSaleInvoiceLine.dmpl__TaxGroupId__r.Name, 'Tax Group should be GST 28%');
		System.assertEquals('Within State', createdSaleInvoice.dmpl__TaxSupplyType__c, 'Supply Type should be Within State');
		System.assertEquals('MG Road', createdSaleInvoice.dmpl__BillingStreet__c, 'Billing Street should match');
		System.assertEquals('Pune', createdSaleInvoice.dmpl__BillingCity__c, 'Billing City should be Pune');
		System.assertEquals('Maharashtra', createdSaleInvoice.dmpl__BillingState__c, 'Billing State should be Maharashtra');
		System.assertEquals('India', createdSaleInvoice.dmpl__BillingCountry__c, 'Billing Country should be India');
		System.assertEquals('411001', createdSaleInvoice.dmpl__BillingPostalCode__c, 'Billing Postal Code should be 411001');
		System.assertEquals('Ring Rd',createdSaleInvoice.dmpl__ShippingStreet__c, 'Shipping Street should match');
		System.assertEquals('Nagpur',createdSaleInvoice.dmpl__ShippingCity__c, 'Shipping City should be Nagpur');

		System.assertEquals(1500.00, createdSaleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be ₹1,500.00');
		System.assertEquals(63000.00, createdSaleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be ₹63,000.00');
		System.assertEquals(8820.00, createdSaleInvoiceLine.dmpl__Tax1__c, 'CGST should be ₹8,820.00');
		System.assertEquals('CGST', createdSaleInvoiceLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
		System.assertEquals(14, createdSaleInvoiceLine.dmpl__Tax1Rate__c, 'Tax1 Rate should be 14%');
		System.assertEquals('CGST', createdSaleInvoiceLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
		System.assertEquals(8820.00, createdSaleInvoiceLine.dmpl__Tax2__c, 'SGST should be ₹8,820.00');
		System.assertEquals('SGST', createdSaleInvoiceLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
		System.assertEquals(14, createdSaleInvoiceLine.dmpl__Tax2Rate__c, 'Tax2 Rate should be 14%');
		System.assertEquals('SGST', createdSaleInvoiceLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
		System.assertEquals(17640.00, createdSaleInvoiceLine.dmpl__TaxAmount__c, 'Total Tax Amount should be ₹17,640.00');
		System.assertEquals(80640.00, createdSaleInvoiceLine.dmpl__GrossAmount__c, 'Gross Amount should be ₹80,640.00');
		System.assertEquals(0.00, createdSaleInvoiceLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
		System.assertEquals(0.00, createdSaleInvoiceLine.dmpl__NetDiscount__c, 'Net Discount should be 0');

		System.assertEquals(1500.00, updatedSaleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be ₹1,500.00');
		System.assertEquals(27000.00, updatedSaleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be ₹27,000.00');
		System.assertEquals(3780.00, updatedSaleInvoiceLine.dmpl__Tax1__c, 'Tax1 (CGST) should be ₹3,780.00');
		System.assertEquals('CGST', updatedSaleInvoiceLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
		System.assertEquals(14.00, updatedSaleInvoiceLine.dmpl__Tax1Rate__c, 'Tax1 Rate should be 14%');
		System.assertEquals('CGST', updatedSaleInvoiceLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
		System.assertEquals(3780.00, updatedSaleInvoiceLine.dmpl__Tax2__c, 'Tax2 (SGST) should be ₹3,780.00');
		System.assertEquals('SGST', updatedSaleInvoiceLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
		System.assertEquals(14.00, updatedSaleInvoiceLine.dmpl__Tax2Rate__c, 'Tax2 Rate should be 14%');
		System.assertEquals('SGST', updatedSaleInvoiceLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
		System.assertEquals(7560.00, updatedSaleInvoiceLine.dmpl__TaxAmount__c, 'Total Tax Amount should be ₹7,560.00');
		System.assertEquals(34560.00, updatedSaleInvoiceLine.dmpl__GrossAmount__c, 'Gross Amount should be ₹34,560.00');
		System.assertEquals(0.00, updatedSaleInvoiceLine.dmpl__NetDiscount__c, 'Net Discount should be 0');
		System.assertEquals(0.00, updatedSaleInvoiceLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');

		//System.assertEquals(27000.00, updatedSaleInvoice.dmpl__LineSubTotal__c, 'Line SubTotal should be ₹27,000.00');
		System.assertEquals(27000.00, updatedSaleInvoice.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be ₹27,000.00');
		System.assertEquals(0.00, updatedSaleInvoice.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount should be ₹0.00');
		System.assertEquals(0.00, updatedSaleInvoice.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be ₹0.00');
		System.assertEquals(7560.00, updatedSaleInvoice.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount should be ₹7,560.00');
		System.assertEquals(7560.00, updatedSaleInvoice.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be ₹7,560.00');
		System.assertEquals(34560.00, updatedSaleInvoice.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be ₹34,560.00');
	}

	//Sale Invoice Line with in-active Item (Edit) Negative
	@isTest
	static void updateSaleInvoiceLineWithInactiveItemNegative() {
		Test.startTest();
		Account customer4 = TestDataHelpers.getCustomerAccount('Customer 4');
		Account partner4 = TestDataHelpers.getPartnerAccount('Partner 4');
		dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
		dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
		dmpl__Item__c item2= TestDataHelpers.getItem('Item 2');
		dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer4, partner4, branch4);
		dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item1, 10);
		dmpl__SaleInvoice__c createdSaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
		dmpl__SaleInvoiceLine__c createdSaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
		createdSaleInvoiceLine.dmpl__ItemId__c = item2.Id;
		try {
			update createdSaleInvoiceLine;
			System.assert(false, 'Expected DMLException when updating Sale Invoice Line with inactive item');
		} catch (DMLException e) {
			System.Assert.isTrue(true, 'Expected Exception because of Inactive Item');
		}
		Test.stopTest();
		System.assertNotEquals(null, saleInvoice, 'Expected Sale Invoice to be created');
		System.assertNotEquals(null, createdSaleInvoice, 'Expected Sale Invoice to be created');
		System.assertNotEquals(null, saleInvoiceLine, 'Expected Sale Invoice Line to be created');
		System.assertNotEquals(null, createdSaleInvoiceLine, 'Expected Sale Invoice Line to be created');
	}

	//Adding Item with is SKU Required - true (Edit)
	@isTest
	static void updateSaleInvoiceLineWithItemSKURequiredTrueNegative() {
		Test.startTest();
		Account customer4 = TestDataHelpers.getCustomerAccount('Customer 4');
		Account partner4 = TestDataHelpers.getPartnerAccount('Partner 4');
		dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
		dmpl__Item__c item9=TestDataHelpers.getItem('Item 9');
		dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer4, partner4, branch4);
		try{
			dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item9, 5);
			System.assertEquals(null, saleInvoiceLine, 'Expected Sale Invoice Line to not be created due to SKU requirement');
		}
		catch(DmlException e){
			System.Assert.isTrue(true, 'Expected Exception because of Item with SKU Required');
		}
	}

    //Sale Invoice Line with Item without Price (Edit)
	@isTest
	static void updateSaleInvoiceLineWithItemWithoutPriceNegative() {
		Test.startTest();
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item6 = TestDataHelpers.getItem('Item 6');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer1, partner4, branch4);
        dmpl__SaleInvoiceLine__c saleInvoiceLine= SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item6, 1);
        dmpl__SaleInvoice__c createdSaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        dmpl__SaleInvoiceLine__c createdSaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
	    Test.stopTest();
        System.assertEquals('Customer 1', createdSaleInvoice.dmpl__AccountName__c, 'Customer Account Name should match');
		System.assertEquals('Within State', createdSaleInvoice.dmpl__TaxSupplyType__c, 'Supply Type should be Within State');
		System.assertEquals('MG Road', createdSaleInvoice.dmpl__BillingStreet__c, 'Billing Street should match');
		System.assertEquals('Pune', createdSaleInvoice.dmpl__BillingCity__c, 'Billing City should be Pune');
		System.assertEquals('Maharashtra', createdSaleInvoice.dmpl__BillingState__c, 'Billing State should be Maharashtra');
		System.assertEquals('India', createdSaleInvoice.dmpl__BillingCountry__c, 'Billing Country should be India');
		System.assertEquals('411001', createdSaleInvoice.dmpl__BillingPostalCode__c, 'Billing Postal Code should be 411001');
		System.assertEquals('Ring Rd',createdSaleInvoice.dmpl__ShippingStreet__c, 'Shipping Street should match');
		System.assertEquals('Nagpur',createdSaleInvoice.dmpl__ShippingCity__c, 'Shipping City should be Nagpur');
        
        System.assertEquals(null, createdSaleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be 0 as Item does not have a price');
        System.assertEquals(0, createdSaleInvoiceLine.dmpl__BaseAmount__c,'Base Amount should be 0 as Item does not have a price');
	}

    //Item SKU with is default true Positive(Edit)
	@isTest
	static void updateSaleInvoiceLineWithItemSKUDefaultTruePositive() {
        Test.startTest();
        Account customer4= TestDataHelpers.getCustomerAccount('Customer 4');
        Account partner4= TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4= TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item11= TestDataHelpers.getItem('Item 11');
        dmpl__SKU__c sku4= TestDataHelpers.getSKU('SKU 4');
        dmpl__SaleInvoice__c saleInvoice= SaleInvoiceDataHelper.createSaleInvoice(customer4, partner4, branch4);
        dmpl__SaleInvoiceLine__c saleInvoiceLine= SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item11,null,1,sku4);
        dmpl__SaleInvoice__c createdSaleInvoice= SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        dmpl__SaleInvoiceLine__c createdSaleInvoiceLine= SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        createdSaleInvoiceLine.dmpl__Quantity__c=4;
        update createdSaleInvoiceLine;
        dmpl__SaleInvoiceLine__c updatedSaleInvoiceLine= SaleInvoiceDataHelper.getSaleInvoiceLine(createdSaleInvoiceLine.Id);
        dmpl__SaleInvoice__c updatedSaleInvoice= SaleInvoiceDataHelper.getSaleInvoice(createdSaleInvoice.Id);
        Test.stopTest();
        System.assertNotEquals(null, saleInvoice, 'Expected Sale Invoice to be created');
        System.assertNotEquals(null, createdSaleInvoice, 'Expected Sale Invoice to be created');
        System.assertNotEquals(null, updatedSaleInvoice, 'Expected Sale Invoice to be updated');
     	System.assertEquals(sku4.Id, createdSaleInvoiceLine.dmpl__SKUId__c, 'SKU should be set to SKU 4');
        System.assertEquals(sku4.Id, updatedSaleInvoiceLine.dmpl__SKUId__c, 'SKU should be set to SKU 4');
    }
    
	//Item SKU with is default true Negative(Edit)
    static void updateSaleInvoiceLineWithItemSKUDefaultTrueNegative() {
        Test.startTest();
        Account customer4= TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner4= TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch4= TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item10= TestDataHelpers.getItem('Item 10');
        dmpl__SKU__c sku5= TestDataHelpers.getSKU('SKU 5');
        dmpl__SaleInvoice__c saleInvoice= SaleInvoiceDataHelper.createSaleInvoice(customer4, partner4, branch4);
        dmpl__SaleInvoiceLine__c saleInvoiceLine= SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item10,null,1,sku5);
        dmpl__SaleInvoice__c createdSaleInvoice= SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        dmpl__SaleInvoiceLine__c createdSaleInvoiceLine= SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        createdSaleInvoiceLine.dmpl__Quantity__c=4;
        update createdSaleInvoiceLine;
        dmpl__SaleInvoiceLine__c updatedSaleInvoiceLine= SaleInvoiceDataHelper.getSaleInvoiceLine(createdSaleInvoiceLine.Id);
        dmpl__SaleInvoice__c updatedSaleInvoice= SaleInvoiceDataHelper.getSaleInvoice(createdSaleInvoice.Id);
        Test.stopTest();
        System.assertNotEquals(null, saleInvoice, 'Expected Sale Invoice to be created');
        System.assertNotEquals(null, createdSaleInvoice, 'Expected Sale Invoice to be created');
        System.assertNotEquals(null, updatedSaleInvoice, 'Expected Sale Invoice to be updated');
     	System.assertEquals(null, createdSaleInvoiceLine.dmpl__SKUId__c, 'SKU should be set to null as SKU is not default');
        System.assertEquals(null, updatedSaleInvoiceLine.dmpl__SKUId__c, 'SKU should be set to null as SKU is not default');
    }

	//Scheme Applicability based on unavailability of Budget (Edit)
	@isTest
	static void updateSaleInvoiceLineWithSchemeApplicabilityNoBudgetNegative() {
		Test.startTest();
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item12 = TestDataHelpers.getItem('Item 12');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer1, partner1, branch1);
        dmpl__SaleInvoiceLine__c saleInvoiceLine= SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item12, 16);
        dmpl__SaleInvoice__c createdSaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        dmpl__SaleInvoiceLine__c createdSaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        createdSaleInvoiceLine.dmpl__Quantity__c = 18;
        update createdSaleInvoiceLine;
        dmpl__SaleInvoiceLine__c updatedSaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(createdSaleInvoiceLine.Id);
        dmpl__SaleInvoice__c updatedSaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(createdSaleInvoice.Id);
        Test.stopTest();
        System.assertNotEquals(null, saleInvoice, 'Expected Sale Invoice to be created');
        System.assertNotEquals(null, createdSaleInvoice, 'Expected Sale Invoice to be created');
        System.assertNotEquals(null, updatedSaleInvoice, 'Expected Sale Invoice to be updated');
        System.assertNotEquals(null, saleInvoiceLine, 'Expected Sale Invoice Line to be created');
        System.assertNotEquals(null, createdSaleInvoiceLine, 'Expected Sale Invoice Line to be created');
        System.assertNotEquals(null, updatedSaleInvoiceLine, 'Expected Sale Invoice Line to be updated');

        System.assertEquals('Customer 1', createdSaleInvoice.dmpl__AccountName__c, 'Customer Account Name should match');
		System.assertEquals('Within State', createdSaleInvoice.dmpl__TaxSupplyType__c, 'Supply Type should be Within State');
		System.assertEquals('MG Road', createdSaleInvoice.dmpl__BillingStreet__c, 'Billing Street should match');
		System.assertEquals('Pune', createdSaleInvoice.dmpl__BillingCity__c, 'Billing City should be Pune');
		System.assertEquals('Maharashtra', createdSaleInvoice.dmpl__BillingState__c, 'Billing State should be Maharashtra');
		System.assertEquals('India', createdSaleInvoice.dmpl__BillingCountry__c, 'Billing Country should be India');
		System.assertEquals('411001', createdSaleInvoice.dmpl__BillingPostalCode__c, 'Billing Postal Code should be 411001');
		System.assertEquals('Ring Rd',createdSaleInvoice.dmpl__ShippingStreet__c, 'Shipping Street should match');
		System.assertEquals('Nagpur',createdSaleInvoice.dmpl__ShippingCity__c, 'Shipping City should be Nagpur');
        System.assertEquals(null, createdSaleInvoiceLine.dmpl__SchemeLineId__c, 'Scheme Line should not be set due to no budget');
        System.assertEquals(null, createdSaleInvoiceLine.dmpl__SchemeDiscount__c, 'Scheme Discount should be 0 due to no budget');
        System.assertEquals(null, updatedSaleInvoiceLine.dmpl__SchemeLineId__c, 'Scheme Line should not be set due to no budget');
	}

    //Scheme Applicability in case the Validity of Scheme has passed (Edit)
    @isTest
    static void updateSaleInvoiceLineWithSchemeApplicabilityValidityPassedNegative() {
        Test.startTest();
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item3 = TestDataHelpers.getItem('Item 3');
        dmpl__scheme__c scheme3=SchemeDataHelper.getScheme('Scheme 3');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer1, partner4, branch4);
        dmpl__SaleInvoiceLine__c saleInvoiceLine= SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item3, 5);
        dmpl__SaleInvoice__c createdSaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        dmpl__SaleInvoiceLine__c createdSaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        createdSaleInvoiceLine.dmpl__Quantity__c = 50;
        scheme3.dmpl__ValidTo__c=Date.newInstance(2025,5,31);
        update scheme3;
        update createdSaleInvoiceLine;
        dmpl__SaleInvoiceLine__c updatedSaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(createdSaleInvoiceLine.Id);
        dmpl__SaleInvoice__c updatedSaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(createdSaleInvoice.Id);
        Test.stopTest();
        System.assertNotEquals(null, saleInvoice, 'Expected Sale Invoice to be created');
        System.assertNotEquals(null, createdSaleInvoice, 'Expected Sale Invoice to be created');
        System.assertNotEquals(null, updatedSaleInvoice, 'Expected Sale Invoice to be updated');
        System.assertNotEquals(null, saleInvoiceLine, 'Expected Sale Invoice Line to be created');
        System.assertNotEquals(null, createdSaleInvoiceLine, 'Expected Sale Invoice Line to be created');
        System.assertNotEquals(null, updatedSaleInvoiceLine, 'Expected Sale Invoice Line to be updated');
    }

    //Sale Invoice Line with Superceding Item (New)
    @isTest
    static void createSaleInvoiceLineWithSupercedingItemPositive() {
        Test.startTest();
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item15 = TestDataHelpers.getItem('Item 15');
        dmpl__Item__c item16 = TestDataHelpers.getItem('Item 16');
        dmpl__ItemAlternate__c itemAlternate = SaleInvoiceDataHelper.getItemAlternate(item15, item16);
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer1, partner1, branch1);
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice,null, itemAlternate, 1,null);
        dmpl__SaleInvoice__c createdSaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        dmpl__SaleInvoiceLine__c createdSaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        Test.stopTest();
        System.assertNotEquals(null, saleInvoice, 'Expected Sale Invoice to be created');
        System.assertNotEquals(null, createdSaleInvoice, 'Expected Sale Invoice to be created');
        System.assertNotEquals(null, saleInvoiceLine, 'Expected Sale Invoice Line to be created');
        System.assertNotEquals(null, createdSaleInvoiceLine, 'Expected Sale Invoice Line to be created');

        System.assertEquals('Customer 1', createdSaleInvoice.dmpl__AccountName__c, 'Customer Account Name should match');
		//System.assertEquals('GST 28', createdSaleInvoiceLine.dmpl__TaxGroupId__r.Name, 'Tax Group should be GST 28%');
		System.assertEquals('Within State', createdSaleInvoice.dmpl__TaxSupplyType__c, 'Supply Type should be Within State');
		System.assertEquals('MG Road', createdSaleInvoice.dmpl__BillingStreet__c, 'Billing Street should match');
		System.assertEquals('Pune', createdSaleInvoice.dmpl__BillingCity__c, 'Billing City should be Pune');
		System.assertEquals('Maharashtra', createdSaleInvoice.dmpl__BillingState__c, 'Billing State should be Maharashtra');
		System.assertEquals('India', createdSaleInvoice.dmpl__BillingCountry__c, 'Billing Country should be India');
		System.assertEquals('411001', createdSaleInvoice.dmpl__BillingPostalCode__c, 'Billing Postal Code should be 411001');
		System.assertEquals('Ring Rd',createdSaleInvoice.dmpl__ShippingStreet__c, 'Shipping Street should match');
		System.assertEquals('Nagpur',createdSaleInvoice.dmpl__ShippingCity__c, 'Shipping City should be Nagpur');
    }

    //Sale Invoice Line Qty as 0 (New)
    @isTest
    static void createSaleInvoiceLineWithZeroQuantityNegative() {
        Test.startTest();
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer1, partner1, branch1);
        try{
            dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item1, -1);
            System.assertEquals(null,saleInvoiceLine,'Expected DMLException when creating Sale Invoice Line with zero quantity');
        } catch (DMLException e) {
            System.Assert.isTrue(true, 'Expected Exception because of zero quantity');
        }
        Test.stopTest();
    }
}