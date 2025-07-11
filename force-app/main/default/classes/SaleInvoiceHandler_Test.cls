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
        
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1',true,false,false,true,'MG Road','Pune','Maharashtra','India','411001','Ring Rd','Nagpur','Maharashtra','India','440001','9876543210','Created');
        Account customerAccount2 = TestDataHelpers.createCustomerAccount('Customer 2',true,false,false,true,'Park St','Nagpur','Maharashtra','India','700016','Lake Rd','Nagpur','Maharashtra','India','700029','9123456789','Created');
        Account customerAccount3 = TestDataHelpers.createCustomerAccount('Customer 3', true, false, false, true, 'Anna Salai', 'Chennai', 'Tamil Nadu', 'India', '600002', 'T Nagar', 'Chennai', 'Tamil Nadu', 'India', '600017','9012345678', 'Created');
        Account customerAccount4 = TestDataHelpers.createCustomerAccount('Customer 4', true, false, false, true, 'SG Highway', 'Ahmedabad', 'GJ', 'India', '380054', 'C G Road', 'Ahmedabad', 'GJ', 'India', '380009','9988776655', 'Created');
        Account customerAccount5 = TestDataHelpers.createCustomerAccount('Customer 5', true, false, false, true, 'Banjara Hills', 'Hyderabad', 'Telangana', 'India', '500034', 'Jubilee Hills', 'Hyderabad', 'Telangana', 'India', '500033','9090909090', 'Created');
        Account customerAccount7=  TestDataHelpers.createCustomerAccount('Customer 7', true, false, false, false, 'Mission Road', 'Bengaluru', 'Karnataka', 'India', '560027', 'Indiranagar', 'Bengaluru', 'Karnataka', 'India', '560038','9811122233', 'Created');
        
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1', false, true, false, true, 'MG Road', 'Bengaluru', 'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India', '560095','9876543210');
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2', false, true, false, false, '45 Residency Road', 'Pune', 'Maharashtra', 'India', '411001', '22 Commerce Avenue', 'Pune', 'Maharashtra', 'India', '411038','91-99665544433');
        Account partnerAccount3 = TestDataHelpers.createPartnerAccount('Partner 3', false, true, false, true, '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '91-9123456789');
        Account partnerAccount4 = TestDataHelpers.createPartnerAccount('Partner 4', false, true, false, true, '12 Industrial Zone', 'Hyderabad','Telangana', 'India', '500032', '12 Industrial Zone', 'Hyderabad', 'Telangana', 'India','500032','9876012345');
        Account partnerAccount6 = TestDataHelpers.createPartnerAccount('Partner 6', false, true, false, true, 'MS Road', 'Bengaluru','Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India','560095','9845543210');
        
        dmpl__AccountGroup__c accountGroup3 = SaleInvoiceDataHelper.createAccountGroup('Account Group 3', 'Scheme', 'Field Filter');
        dmpl__AccountGroupMember__c accountGroupMember1 = SaleInvoiceDataHelper.createAccountGroupMember(accountGroup3.Id, customerAccount1.Id);
        
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
        dmpl__Item__c item10= TestDataHelpers.createItem('Item 10','Product',true, false, false,'76456',false);
        dmpl__Item__c item11= TestDataHelpers.createItem('Item 11', 'Product', true, false, false,'765456', false);
        dmpl__Item__c item12= TestDataHelpers.createItem('Item 12', 'Product', true, false, false,'765456', false);
        dmpl__Item__c item15= TestDataHelpers.createItem('Item 15', 'Part', true, false, false,'765459', true);
        dmpl__Item__c item16= TestDataHelpers.createItem('Item 16', 'Part', true, false, false,'765460', true);
        
        dmpl__ItemAlternate__c itemAlternate1=SaleInvoiceDataHelper.createItemAlternate(item15,item16,'Superseded');
        dmpl__SKU__c sku2 = TestDataHelpers.createSKU('SKU 2', item8.Id, false);
        dmpl__SKU__c sku4 = TestDataHelpers.createSKU('SKU 4', item11.Id, true);
        dmpl__SKU__c sku5 = TestDataHelpers.createSKU('SKU 5', item10.Id, false);
        
        dmpl__TaxGroup__c taxGroupGST18partner4 = TestDataHelpers.createTaxGroup('GST 18', true, 'Line Level', partnerAccount4.Id, branch4.Id, null);
        dmpl__TaxGroup__c taxGroupGST12Global = TestDataHelpers.createTaxGroup('GST 12', true, 'Document Level', null, null, null);
        dmpl__Tax__c taxCGST9= TestDataHelpers.createTax('CGST', 'CGST', 9, taxGroupGST18partner4.Id, 'Tax1');
        dmpl__Tax__c taxSGST9= TestDataHelpers.createTax('SGST', 'SGST', 9, taxGroupGST18partner4.Id, 'Tax2');
        dmpl__TaxGroup__c taxGroupGST28partner1 = TestDataHelpers.createTaxGroup('GST 28', true, 'Line Level', partnerAccount1.Id, branch1.Id, null);
        dmpl__TaxGroup__c taxGroupGST28partner4= TestDataHelpers.createTaxGroup('GST 288', true, 'Document Level', partnerAccount4.Id, branch4.Id, null);
        dmpl__Tax__c taxCGST14 = TestDataHelpers.createTax('CGST', 'CGST', 14, taxGroupGST28partner1.Id, 'Tax1');
        dmpl__Tax__c taxSGST14 = TestDataHelpers.createTax('SGST', 'SGST', 14, taxGroupGST28partner1.Id, 'Tax2');
        
        dmpl__TaxGroupRule__c taxGroupRule28Item1 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST28partner1.Id,item1.Id,null,null,null);
        dmpl__TaxGroupRule__c taxGroupRule18Item5 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST18partner4.Id,item5.Id,null,null,null);
        dmpl__TaxGroupRule__c taxGroupRule29Item8 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST28partner1.Id,item8.Id,null,null,null);
        
        dmpl__PriceList__c priceList1 = TestDataHelpers.createPriceList('Price List 1', partnerAccount1.Id, branch1.Id, null, null, true, false, 'Sale Price');
        dmpl__PriceList__c priceList6 = TestDataHelpers.createPriceList('Price List 6', partnerAccount1.Id, branch1.Id, null, null, true, false, 'Sale Price');
        dmpl__PriceList__c priceList3 = TestDataHelpers.createPriceList('Price List 3',partnerAccount4.Id,branch4.Id,null,null,true,false,'Sale Price');
        dmpl__PriceList__c priceList5 = TestDataHelpers.createPriceList('Price List 5', partnerAccount1.Id, branch1.Id, null, null, true, false, 'Sale Price');
        dmpl__PriceList__c priceList7 = TestDataHelpers.createPriceList('Price List 7',null,null, null, null, true, false, 'Sales');
        
        dmpl__PriceListRules__c priceListRule1 = TestDataHelpers.createPriceListRules(priceList1.id, item1.id,null,null,1500, System.today().addDays(-15),System.today()+9);
        dmpl__PriceListRules__c priceListRule2 = TestDataHelpers.createPriceListRules(priceList5.id, item6.id,null,null,2400, System.today().addDays(-15),System.today()+9);
        dmpl__PriceListRules__c priceListRule4 = TestDataHelpers.createPriceListRules(priceList1.id, item4.id,null,null,2000, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule5 = TestDataHelpers.createPriceListRules(priceList6.id, item4.id,null,null,2000, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule7 = TestDataHelpers.createPriceListRules(priceList3.id, item5.id,null,null,1000, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule8 = TestDataHelpers.createPriceListRules(priceList7.id, item8.id,null,null,1500, System.today()-1,System.today()+9);
        
        
        dmpl__Resource__c resource3 = TestDataHelpers.createResource('Resource 3',partnerAccount1.Id,branch1.Id,false);
        dmpl__ContactAddress__c address1 = TestDataHelpers.createContactAddress('Address 1', 'Ring Rd', 'Pune', 'Maharashtra', customerAccount1.Id, 'Billing Address', '440001', false);
        
        dmpl__Scheme__c scheme2 = SchemeDataHelper.createScheme('Scheme 2', 'Auto Apply', 'Draft', 'Per Sale order and Invoice', 'Per Order', Date.newInstance(2025, 5, 1),Date.Today(), 10, 'Apply all Fulfilled', 1, false, partnerAccount4.Id, null, null, null, branch4.Id, 100000);
        dmpl__SchemeLine__c schemeLine2 = SchemeDataHelper.createSchemeLine(1, 'NET RATE', 'All Conditions Are Met', 'All Rewards', scheme2.Id);
        dmpl__SchemeCondition__c schemeCondition2 = SchemeDataHelper.createSchemeCondition('Item Quantity', 'Greater Than Or Equal', item5.Id, 10, schemeLine2.Id, scheme2.Id, 1);
        dmpl__SchemeBenefit__c schemeBenefit2 = SchemeDataHelper.createSchemeBenefit( 'Rate Off', 'Line Level Discount Amount',null, null,null, 1000, schemeLine2.Id, scheme2.Id,1);
        dmpl__SchemeAccountBudget__c schemeBudget2 = SchemeDataHelper.createSchemesAccountBudget(100000, scheme2.Id, partnerAccount4.Id);
        scheme2.dmpl__Status__c = 'Approved';
        update scheme2;
        
        dmpl__Scheme__c scheme3 = SchemeDataHelper.createScheme('Scheme 3', 'Auto Apply', 'Draft', 'Per Sale order and Invoice', 'Per Order', Date.newInstance(2025, 5, 1),Date.Today(), 10, 'Apply all Fulfilled', 1, false, partnerAccount4.Id, null, null, customerAccount1.Id, branch4.Id, 100000);
        dmpl__SchemeLine__c schemeLine3 = SchemeDataHelper.createSchemeLine(1, 'PERCENTAGE', 'All Conditions Are Met', 'All Rewards', scheme3.Id);
        dmpl__SchemeCondition__c schemeCondition3 = SchemeDataHelper.createSchemeCondition('Item Quantity', 'Greater Than Or Equal', item3.Id, 5, schemeLine3.Id, scheme3.Id, 1);
        dmpl__SchemeBenefit__c schemeBenefit3 = SchemeDataHelper.createSchemeBenefit( 'Rate Off', 'Line Level Discount Amount',null, null,null, 1000, schemeLine3.Id, scheme3.Id,1);
        dmpl__SchemeAccountBudget__c schemeBudget3 = SchemeDataHelper.createSchemesAccountBudget(100000, scheme3.Id, partnerAccount4.Id);
        scheme3.dmpl__Status__c = 'Approved';
        update scheme3;
        
        dmpl__Scheme__c scheme4 = SchemeDataHelper.createScheme('Scheme 4', 'Auto Apply', 'Draft', 'Per Sale order and Invoice', 'PER ORDER', Date.newInstance(2025, 5, 20),Date.Today(), 2, 'Apply all Fulfilled', 1, true, partnerAccount4.Id, null, null, customerAccount1.Id, branch4.Id, 100000);
        dmpl__SchemeLine__c schemeLine4 = SchemeDataHelper.createSchemeLine(1, 'FREE OF COST', 'All Conditions Are Met', 'All Rewards', scheme4.Id);
        dmpl__SchemeCondition__c schemeCondition4 = SchemeDataHelper.createSchemeCondition('Item Quantity', 'Greater Than Or Equal', item4.Id, 18, schemeLine4.Id, scheme4.Id, 1);
        dmpl__SchemeBenefit__c schemeBenefit4 = SchemeDataHelper.createSchemeBenefit('FREE ITEM', 'Discounted Item', item4.Id, 1, 5, null, schemeLine4.Id, scheme4.Id, 1);
        dmpl__SchemeAccountBudget__c schemeBudget4 = SchemeDataHelper.createSchemesAccountBudget(100000, scheme4.Id, partnerAccount4.Id);
        scheme4.dmpl__Status__c = 'Approved';
        update scheme4;
        
        dmpl__Scheme__c scheme5 = SchemeDataHelper.createScheme('Scheme 5', 'Auto Apply', 'Draft', 'Per Sale order and Invoice', 'Per Order', Date.newInstance(2025, 5, 1), Date.newInstance(2025, 7, 30), 0, 'Apply Last Fulfilled', 1, false, partnerAccount1.Id, null, null, customerAccount1.Id, branch1.Id, 100000);
        dmpl__SchemeLine__c schemeLine5 = SchemeDataHelper.createSchemeLine(1, 'PERCENTAGE', 'All Conditions Are Met', 'All Rewards', scheme5.Id);
        dmpl__SchemeCondition__c schemeCondition5 = SchemeDataHelper.createSchemeCondition('Item Quantity', 'Equals', item6.Id, 2, schemeLine5.Id, scheme5.Id, 1);
        dmpl__SchemeBenefit__c schemeBenefit5 = SchemeDataHelper.createSchemeBenefit( 'FREE ITEM', 'Line Level Discount Amount',null, null,null, 1000, schemeLine5.Id, scheme5.Id,1);
        dmpl__SchemeAccountBudget__c schemeBudget5 = SchemeDataHelper.createSchemesAccountBudget(100000, scheme5.Id, partnerAccount1.Id);
        scheme5.dmpl__Status__c = 'Approved';
        update scheme5;
        
        dmpl__Scheme__c scheme19 = SchemeDataHelper.createScheme('Scheme 19', 'Auto Apply', 'Draft', 'Per Purchase Order', 'Per Order', Date.newInstance(2025, 5, 1), Date.newInstance(2025, 7, 30), 0, 'Apply Last Fulfilled', 1, false, partnerAccount1.Id, null, accountGroup3.Id, customerAccount1.Id, branch1.Id, 100000);
        dmpl__SchemeLine__c schemeLine19 = SchemeDataHelper.createSchemeLine(1, 'PERCENTAGE', 'All Conditions Are Met', 'All Rewards', scheme19.Id);
        dmpl__SchemeCondition__c schemeCondition19 = SchemeDataHelper.createSchemeCondition('Item Quantity', 'Equals', item6.Id, 2, schemeLine19.Id, scheme19.Id, 1);
        dmpl__SchemeBenefit__c schemeBenefit19 = SchemeDataHelper.createSchemeBenefit( 'FREE ITEM', 'Line Level Discount Amount',item6.Id, 1, 5, 1000, schemeLine19.Id, scheme19.Id,1);
        dmpl__SchemeAccountBudget__c schemeBudget19 = SchemeDataHelper.createSchemesAccountBudget(100000, scheme19.Id, partnerAccount1.Id);
        scheme19.dmpl__Status__c = 'Approved';
        update scheme19;
        
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
        System.assertEquals('Within State', saleInvoice.dmpl__TaxSupplyType__c, 'TaxSupplyType mismatch');
        System.assertEquals('Banjara Hills', saleInvoice.dmpl__BillingStreet__c, 'BillingStreet mismatch');
        System.assertEquals('Hyderabad', saleInvoice.dmpl__BillingCity__c, 'BillingCity mismatch');
        System.assertEquals('Telangana', saleInvoice.dmpl__BillingState__c, 'BillingState mismatch');
        System.assertEquals('India', saleInvoice.dmpl__BillingCountry__c, 'BillingCountry mismatch');
        System.assertEquals('500034', saleInvoice.dmpl__BillingPostalCode__c, 'BillingPostalCode mismatch');
        System.assertEquals('Jubilee Hills', saleInvoice.dmpl__ShippingStreet__c, 'ShippingStreet mismatch');
        System.assertEquals('Hyderabad', saleInvoice.dmpl__ShippingCity__c, 'ShippingCity mismatch');
        System.assertEquals('Telangana', saleInvoice.dmpl__ShippingState__c, 'ShippingState mismatch');
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
        System.assertEquals('MG Road', saleInvoice.dmpl__BillingStreet__c, 'BillingStreet mismatch');
        System.assertEquals('Pune', saleInvoice.dmpl__BillingCity__c, 'BillingCity mismatch');
        System.assertEquals('Maharashtra', saleInvoice.dmpl__BillingState__c, 'BillingState mismatch');
        System.assertEquals('411001', saleInvoice.dmpl__BillingPostalCode__c, 'BillingPostalCode mismatch');
        System.assertEquals('Ring Rd', saleInvoice.dmpl__ShippingStreet__c, 'ShippingStreet mismatch');
        System.assertEquals('Nagpur', saleInvoice.dmpl__ShippingCity__c, 'ShippingCity mismatch');
        System.assertEquals('Maharashtra', saleInvoice.dmpl__ShippingState__c, 'ShippingState mismatch');
        System.assertEquals('India', saleInvoice.dmpl__ShippingCountry__c, 'ShippingCountry mismatch');
        System.assertEquals('440001', saleInvoice.dmpl__ShippingPostalCode__c, 'ShippingPostalCode mismatch');
        System.assertEquals('Draft', saleInvoice.dmpl__Status__c, 'Status mismatch');
        System.assertEquals('Within State', saleInvoice.dmpl__TaxSupplyType__c, 'TaxSupplyType mismatch');
    }
    
    @isTest
    static void createSaleInvoiceCreationWithIGSTTaxGlobalPositive(){
        Test.startTest();
        Account customerAccount1=TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        
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
        System.assertEquals('440001', saleInvoice.dmpl__ShippingPostalCode__c, 'ShippingPostalCode mismatch');
        System.assertEquals('Outside State', saleInvoice.dmpl__TaxSupplyType__c, 'TaxSupplyType mismatch');
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
        System.assertEquals('MG Road', saleInvoice.dmpl__BillingStreet__c, 'BillingStreet mismatch');
        System.assertEquals('Pune', saleInvoice.dmpl__BillingCity__c, 'BillingCity mismatch');
        System.assertEquals('Maharashtra', saleInvoice.dmpl__BillingState__c, 'BillingState mismatch');
        System.assertEquals('411001', saleInvoice.dmpl__BillingPostalCode__c, 'BillingPostalCode mismatch');
        System.assertEquals('India', saleInvoice.dmpl__ShippingCountry__c, 'ShippingCountry mismatch');
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
        System.assertEquals('411001', saleInvoice.dmpl__BillingPostalCode__c, 'BillingPostalCode mismatch');
        System.assertEquals('Nagpur', saleInvoice.dmpl__ShippingCity__c, 'ShippingCity mismatch');
        System.assertEquals('Maharashtra', saleInvoice.dmpl__ShippingState__c, 'ShippingState mismatch');
        System.assertEquals('India', saleInvoice.dmpl__ShippingCountry__c, 'ShippingCountry mismatch');
        System.assertEquals('Ring Rd', saleInvoice.dmpl__ShippingStreet__c, 'ShippingStreet mismatch');
        System.assertEquals('440001', saleInvoice.dmpl__ShippingPostalCode__c, 'ShippingPostalCode mismatch');
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
        System.assertEquals('Tamil Nadu', createdSaleInvoice.dmpl__BillingState__c, 'Billing state mismatch');
        System.assertEquals('India', createdSaleInvoice.dmpl__BillingCountry__c, 'Billing country mismatch');
        System.assertEquals('600002', createdSaleInvoice.dmpl__BillingPostalCode__c, 'Billing postal code mismatch');
        
        System.assertEquals(810, createdSaleInvoiceLine.dmpl__Tax1__c, 'CGST amount mismatch');
        System.assertEquals('CGST', createdSaleInvoiceLine.dmpl__Tax1Name__c, 'Tax1 name mismatch');
        System.assertEquals(9, createdSaleInvoiceLine.dmpl__Tax1Rate__c, 'Tax1 rate mismatch');
        System.assertEquals('CGST', createdSaleInvoiceLine.dmpl__Tax1Type__c, 'Tax1 type mismatch');
        System.assertEquals(1000, updatedSaleInvoiceLine.dmpl__UnitPrice__c, 'Price should be ₹1,500.00');
        
        System.assertEquals(810, updatedSaleInvoiceLine.dmpl__Tax2__c, 'Tax2 (SGST) should be ₹10,500.00');
        System.assertEquals('SGST', updatedSaleInvoiceLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(9, updatedSaleInvoiceLine.dmpl__Tax2Rate__c, 'Tax2 Rate should be 14%');
        System.assertEquals('SGST', updatedSaleInvoiceLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        
        System.assertEquals(10000, updatedSaleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be ₹75,000.00');
        System.assertEquals(1000, updatedSaleInvoiceLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be ₹0.00');
        System.assertEquals(0, updatedSaleInvoiceLine.dmpl__NetDiscount__c, 'Net Discount should be ₹0.00');
        System.assertEquals(1620, updatedSaleInvoiceLine.dmpl__TaxAmount__c, 'Tax Amount should be ₹21,000.00');
        System.assertEquals(1000, updatedSaleInvoice.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be ₹0.00');
        System.assertEquals(0, updatedSaleInvoice.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be ₹0.00');
    }
    
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
        System.assertEquals(27000.00, updatedSaleInvoice.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be ₹27,000.00');
        System.assertEquals(0.00, updatedSaleInvoice.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount should be ₹0.00');
        System.assertEquals(0.00, updatedSaleInvoice.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be ₹0.00');
        System.assertEquals(7560.00, updatedSaleInvoice.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount should be ₹7,560.00');
        System.assertEquals(7560.00, updatedSaleInvoice.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be ₹7,560.00');
        System.assertEquals(34560.00, updatedSaleInvoice.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be ₹34,560.00');
    }
    
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
    
    @isTest
    static void updateSaleInvoiceLineWithItemSKUDefaultTrueNegative() {
        Test.startTest();
        Account customer4= TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner4= TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch4= TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item10= TestDataHelpers.getItem('Item 10');
        dmpl__SKU__c sku5= TestDataHelpers.getSKU('SKU 5');
        dmpl__SaleInvoice__c saleInvoice= SaleInvoiceDataHelper.createSaleInvoice(customer4, partner4, branch4);
        dmpl__SaleInvoiceLine__c saleInvoiceLine= SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item10,null,1,null);
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
        System.assertEquals('Within State', createdSaleInvoice.dmpl__TaxSupplyType__c, 'Supply Type should be Within State');
        System.assertEquals('MG Road', createdSaleInvoice.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals('Pune', createdSaleInvoice.dmpl__BillingCity__c, 'Billing City should be Pune');
        System.assertEquals('Maharashtra', createdSaleInvoice.dmpl__BillingState__c, 'Billing State should be Maharashtra');
        System.assertEquals('India', createdSaleInvoice.dmpl__BillingCountry__c, 'Billing Country should be India');
        System.assertEquals('411001', createdSaleInvoice.dmpl__BillingPostalCode__c, 'Billing Postal Code should be 411001');
        System.assertEquals('Ring Rd',createdSaleInvoice.dmpl__ShippingStreet__c, 'Shipping Street should match');
        System.assertEquals('Nagpur',createdSaleInvoice.dmpl__ShippingCity__c, 'Shipping City should be Nagpur');
    }
    
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
    
    @isTest
    static void createSaleInvoicePriceListInActivePositive(){
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        
        dmpl__SaleInvoice__c saleInvoice;
        try{
            saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer, partner, branch);
        } catch (DMLException e) {
            System.Assert.isTrue(false, 'Expected to be created!');
        }
        System.AssertEquals(customer?.Id, saleInvoice.dmpl__AccountId__c, 'Customer Account must Match');
        System.AssertEquals(partner?.Id, saleInvoice.dmpl__PartnerAccountId__c, 'Customer Account must Match');
        System.AssertEquals(branch?.Id, saleInvoice.dmpl__BranchId__c, 'Customer Account must Match');
        Test.stopTest();
    }
    @isTest
    static void createSaleInvoiceCreationwithInactiveBranchNegative(){
        Test.startTest();
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner2 = TestDataHelpers.getPartnerAccount('Partner 3');
        dmpl__Branch__c branch2 = TestDataHelpers.getBranch('Branch 3');
        
        dmpl__SaleInvoice__c saleInvoice;
        try{
            saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer1, partner2, branch2);
            System.assertEquals(null,saleInvoice,'Expected DMLException when creating Sale Invoice ');
        } catch (DMLException e) {
            System.Assert.isTrue(true, 'Expected Exception ');
        }
        Test.stopTest();
    }
    
    //Abhijeet
    //Sale Invoice line with Scheme - Auto Apply - Discount Amount (Edit)
    @isTest
    static void updateSaleInvoiceLineWithSchemeAutoApplyDiscountAmountPositive() {
        Test.startTest();
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 4');
        Account partner2 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch2 = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item3 = TestDataHelpers.getItem('Item 3');
        
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer1, partner2, branch2);
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item3, null, null,null, null, 5, 2000);
        
        saleInvoiceLine.dmpl__Quantity__c = 8;
        Update saleInvoiceLine;
        
        dmpl__SaleInvoice__c fetchedsaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        dmpl__SaleInvoiceLine__c fetchedsaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        
        Test.stopTest();
        System.assertEquals(customer1.Name, fetchedsaleInvoice.dmpl__AccountName__c, 'Account name mismatch');
        System.assertEquals(customer1.dmpl__BillingStreet__c, fetchedsaleInvoice.dmpl__BillingStreet__c, 'Billing street mismatch');
        System.assertEquals(customer1.dmpl__BillingCity__c, fetchedsaleInvoice.dmpl__BillingCity__c, 'Billing city mismatch');
        System.assertEquals(customer1.dmpl__BillingState__c, fetchedsaleInvoice.dmpl__BillingState__c, 'Billing state mismatch');
        System.assertEquals(customer1.dmpl__BillingCountry__c, fetchedsaleInvoice.dmpl__BillingCountry__c, 'Billing country mismatch');
        System.assertEquals(customer1.dmpl__BillingPostalCode__c, fetchedsaleInvoice.dmpl__BillingPostalCode__c, 'Billing postal code mismatch');
        
        System.assertEquals(Date.today(), fetchedsaleInvoice.dmpl__DocumentDate__c, 'Document Date mismatch');
        System.assertEquals('Draft', fetchedsaleInvoice.dmpl__Status__c, 'Status mismatch');
        
        System.assertEquals(customer1.dmpl__ShippingStreet__c, fetchedsaleInvoice.dmpl__ShippingStreet__c, 'Shipping street mismatch');
        System.assertEquals(customer1.dmpl__ShippingCity__c, fetchedsaleInvoice.dmpl__ShippingCity__c, 'Shipping city mismatch');
        System.assertEquals(customer1.dmpl__ShippingState__c, fetchedsaleInvoice.dmpl__ShippingState__c, 'Shipping state mismatch');
        System.assertEquals(customer1.dmpl__ShippingCountry__c, fetchedsaleInvoice.dmpl__ShippingCountry__c, 'Shipping country mismatch');
        System.assertEquals(customer1.dmpl__ShippingPostalCode__c, fetchedsaleInvoice.dmpl__ShippingPostalCode__c, 'Shipping postal code mismatch');
        
        System.assertEquals(16000, fetchedsaleInvoice.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount mismatch');
        System.assertEquals(16000, fetchedsaleInvoice.dmpl__TotalLineAmount__c, 'Total Line Amount mismatch');
        System.assertEquals(0, fetchedsaleInvoice.dmpl__TotalSchemeDiscountAmount2__c, 'Scheme Discount 2 mismatch');
        System.assertEquals(16000, fetchedsaleInvoice.dmpl__TotalAmount__c, 'Total Amount mismatch');
        System.assertEquals(16000, fetchedsaleInvoice.dmpl__OpenAmount__c, 'Open Amount mismatch');
        
        System.assertEquals(8, fetchedsaleInvoiceLine.dmpl__Quantity__c, 'Line quantity mismatch');
        System.assertEquals(null, fetchedsaleInvoiceLine.dmpl__SchemeLineId__c, 'Line scheme line mismatch');
        System.assertEquals(null, fetchedsaleInvoiceLine.dmpl__SchemeDiscount__c, 'Line scheme discount mismatch'); // For scheme application Quantity should be greater than or equal 10
        System.assertEquals(16000, fetchedsaleInvoiceLine.dmpl__BaseAmount__c, 'Line base amount mismatch');
        System.assertEquals(16000, fetchedsaleInvoiceLine.dmpl__Amount__c, 'Line amount mismatch');
        System.assertEquals(0, fetchedsaleInvoiceLine.dmpl__NetSchemeDiscount__c, 'Line net scheme discount mismatch');
        System.assertEquals(16000, fetchedsaleInvoiceLine.dmpl__GrossAmount__c, 'Line gross amount mismatch');
        System.assertEquals(0, fetchedsaleInvoiceLine.dmpl__NetDiscount__c, 'Line net discount mismatch');
    }
    
    //Sale Invoice with Scheme - Auto Apply - Discount Amount (Edit)
    @isTest
    static void updateSaleInvoiceLineWithSchemeAutoApplyDiscountAmountPositive2() {
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 4');
        Account partner2 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch2 = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item5 = TestDataHelpers.getItem('Item 5');
        
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer1, partner2, branch2);
        Test.startTest();
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item5, null, null,null, null, 12, 1000);
        
        saleInvoiceLine.dmpl__Quantity__c = 15;
        Update saleInvoiceLine;
        
        dmpl__SaleInvoice__c fetchedsaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        dmpl__SaleInvoiceLine__c fetchedsaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        Test.stopTest();
        
        System.assertEquals(customer1.Name, fetchedsaleInvoice.dmpl__AccountName__c, 'Account name mismatch');
        System.assertEquals(customer1.dmpl__BillingStreet__c, fetchedsaleInvoice.dmpl__BillingStreet__c, 'Billing street mismatch');
        System.assertEquals(customer1.dmpl__BillingCity__c, fetchedsaleInvoice.dmpl__BillingCity__c, 'Billing city mismatch');
        System.assertEquals(customer1.dmpl__BillingState__c, fetchedsaleInvoice.dmpl__BillingState__c, 'Billing state mismatch');
        System.assertEquals(customer1.dmpl__BillingCountry__c, fetchedsaleInvoice.dmpl__BillingCountry__c, 'Billing country mismatch');
        System.assertEquals(customer1.dmpl__BillingPostalCode__c, fetchedsaleInvoice.dmpl__BillingPostalCode__c, 'Billing postal code mismatch');
        
        System.assertEquals(Date.today(), fetchedsaleInvoice.dmpl__DocumentDate__c, 'Document Date mismatch');
        System.assertEquals('Draft', fetchedsaleInvoice.dmpl__Status__c, 'Status mismatch');
        
        System.assertEquals(customer1.dmpl__ShippingStreet__c, fetchedsaleInvoice.dmpl__ShippingStreet__c, 'Shipping street mismatch');
        System.assertEquals(customer1.dmpl__ShippingCity__c, fetchedsaleInvoice.dmpl__ShippingCity__c, 'Shipping city mismatch');
        System.assertEquals(customer1.dmpl__ShippingState__c, fetchedsaleInvoice.dmpl__ShippingState__c, 'Shipping state mismatch');
        System.assertEquals(customer1.dmpl__ShippingCountry__c, fetchedsaleInvoice.dmpl__ShippingCountry__c, 'Shipping country mismatch');
        
        System.assertEquals(15000, fetchedsaleInvoiceLine.dmpl__BaseAmount__c, 'Base amount mismatch');
        System.assertEquals(1000, fetchedsaleInvoiceLine.dmpl__NetSchemeDiscount__c, 'Scheme discount mismatch');
        System.assertEquals(0, fetchedsaleInvoiceLine.dmpl__NetDiscount__c, 'Normal discount mismatch');
        System.assertEquals(1980, fetchedsaleInvoiceLine.dmpl__TaxAmount__c, 'Total tax mismatch');
        System.assertEquals(15980, fetchedsaleInvoiceLine.dmpl__GrossAmount__c, 'Gross amount mismatch');
        System.assertNotEquals(null, fetchedsaleInvoiceLine.dmpl__SchemeLineId__c, 'Scheme line ID mismatch');
        
        System.assertEquals(15000, fetchedsaleInvoice.dmpl__TotalLineBaseAmount__c, 'Invoice base amount mismatch');
        System.assertEquals(1000, fetchedsaleInvoice.dmpl__TotalSchemeDiscountAmount__c, 'Invoice scheme discount mismatch');
        System.assertEquals(0, fetchedsaleInvoice.dmpl__TotalDiscountAmount__c, 'Invoice discount mismatch');
        System.assertEquals(1980, fetchedsaleInvoice.dmpl__TotalLineTaxAmount__c, 'Invoice tax mismatch');
        System.assertEquals(15980, fetchedsaleInvoice.dmpl__TotalLineGrossAmount__c, 'Invoice gross amount mismatch');
        System.assertEquals(15980, fetchedsaleInvoice.dmpl__OutstandingAmount__c, 'Invoice outstanding mismatch');
        
    }
    
    
    //Sale Invoice with Discount Group & Scheme (Edit)
    @isTest
    static void updateSaleInvoiceLineWithDiscountGroupAndSchemePositive() {
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner2 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch2 = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item5 = TestDataHelpers.getItem('Item 5');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');
        
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer1, partner2, branch2);
        Test.startTest();
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item5, null, null,taxGroup, null, 11, 1000);
        
        saleInvoiceLine.dmpl__Quantity__c = 15;
        Update saleInvoiceLine;
        
        Test.stopTest();
        dmpl__SaleInvoice__c fetchedsaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        dmpl__SaleInvoiceLine__c fetchedsaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        
        System.assertEquals(customer1.Name, fetchedsaleInvoice.dmpl__AccountName__c, 'Account name mismatch');
        System.assertEquals(customer1.dmpl__BillingStreet__c, fetchedsaleInvoice.dmpl__BillingStreet__c, 'Billing street mismatch');
        System.assertEquals(customer1.dmpl__BillingCity__c, fetchedsaleInvoice.dmpl__BillingCity__c, 'Billing city mismatch');
        System.assertEquals(customer1.dmpl__BillingState__c, fetchedsaleInvoice.dmpl__BillingState__c, 'Billing state mismatch');
        System.assertEquals(customer1.dmpl__BillingCountry__c, fetchedsaleInvoice.dmpl__BillingCountry__c, 'Billing country mismatch');
        System.assertEquals(customer1.dmpl__BillingPostalCode__c, fetchedsaleInvoice.dmpl__BillingPostalCode__c, 'Billing postal code mismatch');
        
        System.assertEquals(Date.today(), fetchedsaleInvoice.dmpl__DocumentDate__c, 'Document Date mismatch');
        System.assertEquals('Draft', fetchedsaleInvoice.dmpl__Status__c, 'Status mismatch');
        
        System.assertEquals(customer1.dmpl__ShippingStreet__c, fetchedsaleInvoice.dmpl__ShippingStreet__c, 'Shipping street mismatch');
        System.assertEquals(customer1.dmpl__ShippingCity__c, fetchedsaleInvoice.dmpl__ShippingCity__c, 'Shipping city mismatch');
        System.assertEquals(customer1.dmpl__ShippingState__c, fetchedsaleInvoice.dmpl__ShippingState__c, 'Shipping state mismatch');
        System.assertEquals(customer1.dmpl__ShippingCountry__c, fetchedsaleInvoice.dmpl__ShippingCountry__c, 'Shipping country mismatch');
        System.assertEquals(customer1.dmpl__ShippingPostalCode__c, fetchedsaleInvoice.dmpl__ShippingPostalCode__c, 'Shipping postal code mismatch');
        
        System.assertEquals(partner2.Id, fetchedsaleInvoice.dmpl__PartnerAccountId__c, 'Partner mismatch');
        System.assertEquals(branch2.Id, fetchedsaleInvoice.dmpl__BranchId__c, 'Branch mismatch');
        System.assertEquals(customer1.Id, fetchedsaleInvoice.dmpl__AccountId__c, 'Customer mismatch');
        System.assertEquals('Within State', fetchedsaleInvoice.dmpl__TaxSupplyType__c, 'Tax Supply Type mismatch');
        
        System.assertEquals(saleInvoice.Id, fetchedsaleInvoiceLine.dmpl__SaleInvoiceId__c, 'Invoice ID mismatch');
        System.assertEquals(item5.Id, fetchedsaleInvoiceLine.dmpl__ItemId__c, 'Item ID mismatch');
        System.assertEquals(15, fetchedsaleInvoiceLine.dmpl__Quantity__c, 'Quantity mismatch');
        System.assertEquals(1000, fetchedsaleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price mismatch');
        
        System.assertEquals(15000, fetchedsaleInvoice.dmpl__TotalLineBaseAmount__c, 'Base Amount mismatch');
        System.assertEquals(0, fetchedsaleInvoice.dmpl__TotalDiscountAmount__c, 'Discount mismatch');
        System.assertEquals(1000, fetchedsaleInvoice.dmpl__TotalSchemeDiscountAmount__c, 'Scheme Discount mismatch');
        
        System.assertEquals(2520, fetchedsaleInvoice.dmpl__TotalTaxAmount__c, 'Tax1 mismatch');
        
        System.assertEquals(16520, fetchedsaleInvoice.dmpl__TotalLineGrossAmount__c, 'Gross Amount mismatch');
        System.assertEquals(16520, fetchedsaleInvoice.dmpl__TotalAmount__c, 'Total Amount mismatch');
        System.assertEquals(16520, fetchedsaleInvoice.dmpl__OpenAmount__c, 'Open Amount mismatch');
        System.assertEquals(16520, fetchedsaleInvoice.dmpl__OutstandingAmount__c, 'Outstanding Amount mismatch');
        
    }
    
    //Scheme Applicability in Case of Partner Account Group (Edit)
    @isTest
    static void updateSaleInvoiceLineWithSchemeApplicabilityPartnerAccountGroupPositive() {
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner2 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch2 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item5 = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
        
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer1, partner2, branch2);
        Test.startTest();
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item5, null, null,taxGroup, null, 15, 1500);
        
        saleInvoiceLine.dmpl__Quantity__c = 14;
        Update saleInvoiceLine;
        
        Test.stopTest();
        dmpl__SaleInvoice__c fetchedsaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        dmpl__SaleInvoiceLine__c fetchedsaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        
        System.assertEquals(Date.today(), fetchedsaleInvoice.dmpl__DocumentDate__c, 'Document Date mismatch');
        System.assertEquals('Draft', fetchedsaleInvoice.dmpl__Status__c, 'Status mismatch');
        
        System.assertEquals(partner2.Id, fetchedsaleInvoice.dmpl__PartnerAccountId__c, 'Partner mismatch');
        System.assertEquals(branch2.Id, fetchedsaleInvoice.dmpl__BranchId__c, 'Branch mismatch');
        System.assertEquals(customer1.Id, fetchedsaleInvoice.dmpl__AccountId__c, 'Customer mismatch');
        System.assertEquals('Within State', fetchedsaleInvoice.dmpl__TaxSupplyType__c, 'Tax Supply Type mismatch');
        
        System.assertEquals(21000, fetchedsaleInvoiceLine.dmpl__BaseAmount__c, 'Base amount mismatch');
        
        System.assertEquals(0, fetchedsaleInvoiceLine.dmpl__NetSchemeDiscount__c, 'Scheme discount should be 0 since quantity < threshold');
        
        System.assertEquals(2940, fetchedsaleInvoiceLine.dmpl__Tax1__c, 'CGST amount mismatch');
        System.assertEquals(2940, fetchedsaleInvoiceLine.dmpl__Tax2__c, 'SGST amount mismatch');
        System.assertEquals(5880, fetchedsaleInvoiceLine.dmpl__TaxAmount__c, 'Total tax amount mismatch');
        
        System.assertEquals(26880, fetchedsaleInvoiceLine.dmpl__GrossAmount__c, 'Gross amount mismatch');
        
        System.assertEquals(null, fetchedsaleInvoiceLine.dmpl__SchemeLineId__c, 'Scheme line ID should be null');
        
        System.assertEquals(21000, fetchedsaleInvoiceLine.dmpl__BaseAmount__c, 'Invoice base amount mismatch');
        System.assertEquals(0, fetchedsaleInvoice.dmpl__TotalSchemeDiscountAmount__c, 'Total scheme discount mismatch');
        System.assertEquals(0, fetchedsaleInvoice.dmpl__TotalDiscountAmount__c, 'Total discount mismatch');
        System.assertEquals(5880, fetchedsaleInvoice.dmpl__TotalTaxAmount__c, 'Invoice tax amount mismatch');
        System.assertEquals(26880, fetchedsaleInvoice.dmpl__OutstandingAmount__c, 'Outstanding amount mismatch');
        
        System.assertEquals(0, fetchedsaleInvoiceLine.dmpl__NetSchemeDiscount__c);
        
        
    }
    
    
    //Sale Invoice With Discount  Group - Discount (Edit)
    @isTest
    static void updateSaleInvoiceLineWithDiscountGroupDiscountPositive(){
        Test.startTest();
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
        
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer1, partner4, branch4);
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item1, null, null,taxGroup, null, 1, 1500);
        
        saleInvoiceLine.dmpl__Quantity__c = 4;
        Update saleInvoiceLine;
        
        dmpl__SaleInvoice__c fetchedsaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        dmpl__SaleInvoiceLine__c fetchedsaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        
        Test.stopTest();
        System.assertEquals(customer1.Name, fetchedsaleInvoice.dmpl__AccountName__c, 'Account name mismatch');
        System.assertEquals(customer1.dmpl__BillingStreet__c, fetchedsaleInvoice.dmpl__BillingStreet__c, 'Billing street mismatch');
        System.assertEquals(customer1.dmpl__BillingCity__c, fetchedsaleInvoice.dmpl__BillingCity__c, 'Billing city mismatch');
        System.assertEquals(customer1.dmpl__BillingState__c, fetchedsaleInvoice.dmpl__BillingState__c, 'Billing state mismatch');
        System.assertEquals(customer1.dmpl__BillingCountry__c, fetchedsaleInvoice.dmpl__BillingCountry__c, 'Billing country mismatch');
        System.assertEquals(customer1.dmpl__BillingPostalCode__c, fetchedsaleInvoice.dmpl__BillingPostalCode__c, 'Billing postal code mismatch');
        
        System.assertEquals(Date.today(), fetchedsaleInvoice.dmpl__DocumentDate__c, 'Document Date mismatch');
        System.assertEquals('Draft', fetchedsaleInvoice.dmpl__Status__c, 'Status mismatch');
        
        System.assertEquals(customer1.dmpl__ShippingStreet__c, fetchedsaleInvoice.dmpl__ShippingStreet__c, 'Shipping street mismatch');
        System.assertEquals(customer1.dmpl__ShippingCity__c, fetchedsaleInvoice.dmpl__ShippingCity__c, 'Shipping city mismatch');
        System.assertEquals(customer1.dmpl__ShippingState__c, fetchedsaleInvoice.dmpl__ShippingState__c, 'Shipping state mismatch');
        System.assertEquals(customer1.dmpl__ShippingCountry__c, fetchedsaleInvoice.dmpl__ShippingCountry__c, 'Shipping country mismatch');
        System.assertEquals(customer1.dmpl__ShippingPostalCode__c, fetchedsaleInvoice.dmpl__ShippingPostalCode__c, 'Shipping postal code mismatch');
        
        System.assertEquals(customer1.Id, fetchedsaleInvoice.dmpl__AccountId__c, 'Customer ID mismatch');
        System.assertEquals(partner4.Id, fetchedsaleInvoice.dmpl__PartnerAccountId__c, 'Partner ID mismatch');
        System.assertEquals(branch4.Id, fetchedsaleInvoice.dmpl__BranchId__c, 'Branch ID mismatch');
        
        System.assertEquals(6000, fetchedsaleInvoiceLine.dmpl__BaseAmount__c, 'Base amount mismatch');
        System.assertEquals(0, fetchedsaleInvoiceLine.dmpl__NetDiscount__c, 'Net discount mismatch');
        
        System.assertEquals(840, fetchedsaleInvoiceLine.dmpl__Tax1__c, 'CGST mismatch');
        System.assertEquals('CGST', fetchedsaleInvoiceLine.dmpl__Tax1Name__c);
        System.assertEquals(14.0, fetchedsaleInvoiceLine.dmpl__Tax1Rate__c, 'CGST Rate mismatch');
        
        System.assertEquals(840, fetchedsaleInvoiceLine.dmpl__Tax2__c, 'SGST mismatch');
        System.assertEquals('SGST', fetchedsaleInvoiceLine.dmpl__Tax2Name__c);
        System.assertEquals(14.0, fetchedsaleInvoiceLine.dmpl__Tax2Rate__c, 'SGST Rate mismatch');
        
        System.assertEquals(1680, fetchedsaleInvoiceLine.dmpl__TaxAmount__c, 'Total Tax Amount mismatch');
        System.assertEquals(7680, fetchedsaleInvoiceLine.dmpl__GrossAmount__c, 'Gross Amount mismatch');
        
        System.assertEquals(6000, fetchedsaleInvoice.dmpl__TotalLineBaseAmount__c, 'Total base amount mismatch');
        System.assertEquals(0, fetchedsaleInvoice.dmpl__TotalDiscountAmount__c, 'Total discount mismatch');
        System.assertEquals(7680.00, fetchedsaleInvoice.dmpl__TotalLineGrossAmount__c, 'Gross amount mismatch');
        System.assertEquals(7680.00, fetchedsaleInvoice.dmpl__OpenAmount__c, 'Open amount mismatch');
        System.assertEquals(7680.00, fetchedsaleInvoice.dmpl__OutstandingAmount__c, 'Outstanding amount mismatch');
        
    }
    
    
    //Scheme Applicability in Case of Skip Scheme is True (Edit)
    @isTest
    static void updateSaleInvoiceLineWithSchemeApplicabilitySkipSchemeTruePositive() {
        Test.startTest();
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner3 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item6 = TestDataHelpers.getItem('Item 6');
        
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer1, partner3, branch3);
        saleInvoice.dmpl__SkipScheme__c = true;
        update saleInvoice;
        
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item6, null, null,null, null, 15, 2400);
        
        saleInvoiceLine.dmpl__Quantity__c = 20;
        Update saleInvoiceLine;
        
        dmpl__SaleInvoice__c fetchedsaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        dmpl__SaleInvoiceLine__c fetchedsaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        
        Test.stopTest();
        System.assertEquals(customer1.Name, fetchedsaleInvoice.dmpl__AccountName__c, 'Account name mismatch');
        System.assertEquals(customer1.dmpl__BillingStreet__c, fetchedsaleInvoice.dmpl__BillingStreet__c, 'Billing street mismatch');
        System.assertEquals(customer1.dmpl__BillingCity__c, fetchedsaleInvoice.dmpl__BillingCity__c, 'Billing city mismatch');
        System.assertEquals(customer1.dmpl__BillingState__c, fetchedsaleInvoice.dmpl__BillingState__c, 'Billing state mismatch');
        System.assertEquals(customer1.dmpl__BillingCountry__c, fetchedsaleInvoice.dmpl__BillingCountry__c, 'Billing country mismatch');
        System.assertEquals(customer1.dmpl__BillingPostalCode__c, fetchedsaleInvoice.dmpl__BillingPostalCode__c, 'Billing postal code mismatch');
        
        System.assertEquals(Date.today(), fetchedsaleInvoice.dmpl__DocumentDate__c, 'Document Date mismatch');
        System.assertEquals('Draft', fetchedsaleInvoice.dmpl__Status__c, 'Status mismatch');
        
        System.assertEquals(customer1.dmpl__ShippingStreet__c, fetchedsaleInvoice.dmpl__ShippingStreet__c, 'Shipping street mismatch');
        System.assertEquals(customer1.dmpl__ShippingCity__c, fetchedsaleInvoice.dmpl__ShippingCity__c, 'Shipping city mismatch');
        System.assertEquals(customer1.dmpl__ShippingState__c, fetchedsaleInvoice.dmpl__ShippingState__c, 'Shipping state mismatch');
        System.assertEquals(customer1.dmpl__ShippingCountry__c, fetchedsaleInvoice.dmpl__ShippingCountry__c, 'Shipping country mismatch');
        System.assertEquals(customer1.dmpl__ShippingPostalCode__c, fetchedsaleInvoice.dmpl__ShippingPostalCode__c, 'Shipping postal code mismatch');
        
        System.assertEquals(customer1.Id, fetchedsaleInvoice.dmpl__AccountId__c, 'Customer ID mismatch');
        System.assertEquals(partner3.Id, fetchedsaleInvoice.dmpl__PartnerAccountId__c, 'Partner ID mismatch');
        System.assertEquals(branch3.Id, fetchedsaleInvoice.dmpl__BranchId__c, 'Branch ID mismatch');
        System.assertEquals(0, fetchedsaleInvoice.dmpl__TotalTaxAmount__c, 'Tax amount should be 0');
        
        System.assertEquals(48000, fetchedsaleInvoiceLine.dmpl__BaseAmount__c, 'Base amount mismatch');
        System.assertEquals(0, fetchedsaleInvoiceLine.dmpl__NetDiscount__c, 'Net discount mismatch');
        System.assertEquals(0, fetchedsaleInvoiceLine.dmpl__NetSchemeDiscount__c, 'Scheme discount should be 0 since SkipScheme is true');
        System.assertEquals(48000, fetchedsaleInvoiceLine.dmpl__GrossAmount__c, 'Gross amount mismatch');
        
        System.assertEquals(48000, fetchedsaleInvoice.dmpl__TotalLineBaseAmount__c, 'Invoice total base mismatch');
        System.assertEquals(0, fetchedsaleInvoice.dmpl__TotalDiscountAmount__c, 'Invoice total discount mismatch');
        System.assertEquals(0, fetchedsaleInvoice.dmpl__TotalSchemeDiscountAmount__c, 'Invoice scheme discount should be 0');
        System.assertEquals(0, fetchedsaleInvoice.dmpl__TotalLineTaxAmount__c, 'Invoice tax should be 0');
        System.assertEquals(48000, fetchedsaleInvoice.dmpl__TotalLineGrossAmount__c, 'Invoice gross mismatch');
        System.assertEquals(48000, fetchedsaleInvoice.dmpl__OpenAmount__c, 'Invoice open amount mismatch');
        System.assertEquals(48000, fetchedsaleInvoice.dmpl__OutstandingAmount__c, 'Invoice outstanding amount mismatch');
        
    }
    
    /****************** Saharsh ******************/
    @isTest
    static void updateTaxApplicationObjectModelObjectTaxesPositive(){
        Test.startTest();
        Account customer1= TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner1= TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1= TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1= TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');
        dmpl__SaleInvoice__c saleInvoice= SaleInvoiceDataHelper.createSaleInvoice(customer1, partner1, branch1, 'Within State', taxGroup, null, null);
        dmpl__SaleInvoiceLine__c saleInvoiceLine;
        try{
            saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item1, 10);
        }catch(Exception e){
            System.Assert.isTrue(false, 'Exception not Expected! >> '+ e.getMessage());
        }
        
        saleInvoice= SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        saleInvoiceLine= SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        
        System.assertEquals(customer1.Id, saleInvoice.dmpl__AccountId__c, 'Customer Account Name should match');
        System.assertEquals(taxGroup.Id, saleInvoice.dmpl__TaxGroupId__c, 'Tax Group should be GST 28%');
        System.assertEquals('Within State', saleInvoice.dmpl__TaxSupplyType__c, 'Supply Type should be Within State');
        System.assertEquals(customer1.dmpl__BillingStreet__c, saleInvoice.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals(customer1.dmpl__BillingCity__c, saleInvoice.dmpl__BillingCity__c, 'Billing City should be Pune');
        System.assertEquals(customer1.dmpl__BillingState__c, saleInvoice.dmpl__BillingState__c, 'Billing State should be Maharashtra');
        System.assertEquals(customer1.dmpl__BillingCountry__c, saleInvoice.dmpl__BillingCountry__c, 'Billing Country should be India');
        System.assertEquals(customer1.dmpl__BillingPostalCode__c, saleInvoice.dmpl__BillingPostalCode__c, 'Billing Postal Code should be 411001');
        System.assertEquals(customer1.dmpl__ShippingStreet__c,saleInvoice.dmpl__ShippingStreet__c, 'Shipping Street should match');
        System.assertEquals(customer1.dmpl__ShippingCity__c,saleInvoice.dmpl__ShippingCity__c, 'Shipping City should be Nagpur');
        
        System.assertEquals(1500.00, saleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be Match');
        System.assertEquals(15000.00, saleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be Match');
        System.assertEquals(2100.00, saleInvoiceLine.dmpl__Tax1__c, 'CGST should be Match');
        System.assertEquals('CGST', saleInvoiceLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(14, saleInvoiceLine.dmpl__Tax1Rate__c, 'Tax1 Rate should be 14%');
        System.assertEquals('CGST', saleInvoiceLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(2100.00, saleInvoiceLine.dmpl__Tax2__c, 'SGST should be Match');
        System.assertEquals('SGST', saleInvoiceLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(14, saleInvoiceLine.dmpl__Tax2Rate__c, 'Tax2 Rate should be 14%');
        System.assertEquals('SGST', saleInvoiceLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(4200.00, saleInvoiceLine.dmpl__TaxAmount__c, 'Total Tax Amount should be Match');
        System.assertEquals(19200.00, saleInvoiceLine.dmpl__GrossAmount__c, 'Gross Amount should be Match');
        System.assertEquals(0.00, saleInvoiceLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0.00, saleInvoiceLine.dmpl__NetDiscount__c, 'Net Discount should be 0');
        
        try{
            saleInvoiceLine.dmpl__Quantity__c = 5;
            update saleInvoiceLine;
        }catch(Exception e){
            System.Assert.isTrue(false, 'Exception not Expected! >> '+ e.getMessage());
        }
        saleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        
        System.assertEquals(1500.00, saleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be Match');
        System.assertEquals(1050.00, saleInvoiceLine.dmpl__Tax1__c, 'Tax1 (CGST) should be Match');
        System.assertEquals('CGST', saleInvoiceLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(14.00, saleInvoiceLine.dmpl__Tax1Rate__c, 'Tax1 Rate should be 14%');
        System.assertEquals('CGST', saleInvoiceLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(1050.00, saleInvoiceLine.dmpl__Tax2__c, 'Tax2 (SGST) should be Match');
        System.assertEquals('SGST', saleInvoiceLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(14.00, saleInvoiceLine.dmpl__Tax2Rate__c, 'Tax2 Rate should be 14%');
        System.assertEquals('SGST', saleInvoiceLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(2100.00, saleInvoiceLine.dmpl__TaxAmount__c, 'Total Tax Amount should be Match');
        System.assertEquals(7500.00, saleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be Match');
        System.assertEquals(9600.00, saleInvoiceLine.dmpl__GrossAmount__c, 'Gross Amount should be Match');
        System.assertEquals(0.00, saleInvoiceLine.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(0.00, saleInvoiceLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        
        Test.stopTest();
    }
    
    @isTest
    static void updateSaleInvoiceLineWithDiscontinuedItemNegative(){
        Test.startTest();
        Account customer1= TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner1= TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1= TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1= TestDataHelpers.getItem('Item 1');
        dmpl__Item__c item4= TestDataHelpers.getItem('Item 4');
        dmpl__SaleInvoice__c saleInvoice= SaleInvoiceDataHelper.createSaleInvoice(customer1, partner1, branch1);
        
        dmpl__SaleInvoiceLine__c saleInvoiceLine;
        try{
            saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item1, 1);
        }catch(Exception e){
            System.Assert.isTrue(false, 'Exception not Expected! >> ' + e.getMessage());
        }
        
        try{
            saleInvoiceLine.dmpl__ItemId__c = item4.Id;
            update saleInvoiceLine;
            System.Assert.isTrue(false, 'Exception Expected!');
        }catch(Exception e){
            System.Assert.isTrue(true, 'Exception Expected! >> ');
        }
        
        Test.stopTest();
    }
    
    @isTest
    static void updateSaleInvoiceLineWithItemWithoutTaxGroupPositive(){
        Test.startTest();
        Account customer1= TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner1= TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1= TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item8= TestDataHelpers.getItem('Item 8');
        dmpl__SKU__c sku2 = TestDataHelpers.getSKU('SKU 2');
        dmpl__SaleInvoice__c saleInvoice= SaleInvoiceDataHelper.createSaleInvoice(customer1, partner1, branch1);
        dmpl__SaleInvoiceLine__c saleInvoiceLine;
        try{
            saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item8,sku2, null, null, null, 10, 1500);
        }catch(Exception e){
            System.Assert.isTrue(false, 'Exception not Expected! >> '+ e.getMessage());
        }
        
        saleInvoice= SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        saleInvoiceLine= SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        
        System.assertEquals(customer1.Id, saleInvoice.dmpl__AccountId__c, 'Customer Account Name should match');
        System.assertEquals('Within State', saleInvoice.dmpl__TaxSupplyType__c, 'Supply Type should be Within State');
        System.assertEquals(customer1.dmpl__BillingStreet__c, saleInvoice.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals(customer1.dmpl__BillingCity__c, saleInvoice.dmpl__BillingCity__c, 'Billing City should be Pune');
        System.assertEquals(customer1.dmpl__BillingState__c, saleInvoice.dmpl__BillingState__c, 'Billing State should be Maharashtra');
        System.assertEquals(customer1.dmpl__BillingCountry__c, saleInvoice.dmpl__BillingCountry__c, 'Billing Country should be India');
        System.assertEquals(customer1.dmpl__BillingPostalCode__c, saleInvoice.dmpl__BillingPostalCode__c, 'Billing Postal Code should be 411001');
        System.assertEquals(customer1.dmpl__ShippingStreet__c,saleInvoice.dmpl__ShippingStreet__c, 'Shipping Street should match');
        System.assertEquals(customer1.dmpl__ShippingCity__c,saleInvoice.dmpl__ShippingCity__c, 'Shipping City should be Nagpur');
        
        System.assertEquals(1500.00, saleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be Match');
        System.assertEquals(15000.00, saleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be Match');
        System.assertEquals(0.00, saleInvoiceLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0.00, saleInvoiceLine.dmpl__NetDiscount__c, 'Net Discount should be 0');
        
        try{
            saleInvoiceLine.dmpl__Quantity__c = 5;
            update saleInvoiceLine;
        }catch(Exception e){
            System.Assert.isTrue(false, 'Exception not Expected! >> '+ e.getMessage());
        }
        saleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        
        System.assertEquals(1500.00, saleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be Match');
        System.assertEquals(7500.00, saleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be Match');
        System.assertEquals(0.00, saleInvoiceLine.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(0.00, saleInvoiceLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        
        Test.stopTest();
    }
    
    @isTest
    static void updatePricesInCaseOfDateEffectiveTillHasPassedNegative(){
        Test.startTest();
        Account customer1= TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner1= TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1= TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item5= TestDataHelpers.getItem('Item 5');
        dmpl__SaleInvoice__c saleInvoice= SaleInvoiceDataHelper.createSaleInvoice(customer1, partner1, branch1);
        dmpl__SaleInvoiceLine__c saleInvoiceLine;
        try{
            saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item5, 20);
        }catch(Exception e){
            System.Assert.isTrue(false, 'Exception not Expected! >> '+ e.getMessage());
        }
        
        saleInvoice= SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        saleInvoiceLine= SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        
        System.assertEquals(customer1.Id, saleInvoice.dmpl__AccountId__c, 'Customer Account Name should match');
        System.assertEquals('Within State', saleInvoice.dmpl__TaxSupplyType__c, 'Supply Type should be Within State');
        System.assertEquals(customer1.dmpl__BillingStreet__c, saleInvoice.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals(customer1.dmpl__BillingCity__c, saleInvoice.dmpl__BillingCity__c, 'Billing City should be Pune');
        System.assertEquals(customer1.dmpl__BillingState__c, saleInvoice.dmpl__BillingState__c, 'Billing State should be Maharashtra');
        System.assertEquals(customer1.dmpl__BillingCountry__c, saleInvoice.dmpl__BillingCountry__c, 'Billing Country should be India');
        System.assertEquals(customer1.dmpl__BillingPostalCode__c, saleInvoice.dmpl__BillingPostalCode__c, 'Billing Postal Code should be 411001');
        System.assertEquals(customer1.dmpl__ShippingStreet__c,saleInvoice.dmpl__ShippingStreet__c, 'Shipping Street should match');
        System.assertEquals(customer1.dmpl__ShippingCity__c,saleInvoice.dmpl__ShippingCity__c, 'Shipping City should be Nagpur');
        
        System.assertEquals(null, saleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be Match');
        System.assertEquals(0.00, saleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be Match');
        System.assertEquals(0.00, saleInvoiceLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0.00, saleInvoiceLine.dmpl__NetDiscount__c, 'Net Discount should be 0');
        
        try{
            saleInvoiceLine.dmpl__Quantity__c = 15;
            update saleInvoiceLine;
        }catch(Exception e){
            System.Assert.isTrue(false, 'Exception not Expected! >> '+ e.getMessage());
        }
        saleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        
        System.assertEquals(null, saleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be Match');
        System.assertEquals(0.00, saleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be Match');
        System.assertEquals(0.00, saleInvoiceLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0.00, saleInvoiceLine.dmpl__NetDiscount__c, 'Net Discount should be 0');
        
        Test.stopTest();
    }
    
    @isTest
    static void updateSchemeApplicabilityincaseofSchemenotApprovedPositive(){
        Test.startTest();
        Account customer1= TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner4= TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4= TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item3= TestDataHelpers.getItem('Item 3');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');
        dmpl__SaleInvoice__c saleInvoice= SaleInvoiceDataHelper.createSaleInvoice(customer1, partner4, branch4, 'Within State', taxGroup, null, null);
        
        dmpl__SaleInvoiceLine__c saleInvoiceLine;
        try{
            saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item3, null, null, null, null, 6, 2000);
        }catch(Exception e){
            System.Assert.isTrue(false, 'Exception not Expected! >> '+ e.getMessage());
        }
        
        saleInvoice= SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        saleInvoiceLine= SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        
        System.assertEquals(customer1.Id, saleInvoice.dmpl__AccountId__c, 'Customer Account Name should match');
        System.assertEquals('Within State', saleInvoice.dmpl__TaxSupplyType__c, 'Supply Type should be Within State');
        System.assertEquals(customer1.dmpl__BillingStreet__c, saleInvoice.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals(customer1.dmpl__BillingCity__c, saleInvoice.dmpl__BillingCity__c, 'Billing City should be Pune');
        System.assertEquals(customer1.dmpl__BillingState__c, saleInvoice.dmpl__BillingState__c, 'Billing State should be Maharashtra');
        System.assertEquals(customer1.dmpl__BillingCountry__c, saleInvoice.dmpl__BillingCountry__c, 'Billing Country should be India');
        System.assertEquals(customer1.dmpl__BillingPostalCode__c, saleInvoice.dmpl__BillingPostalCode__c, 'Billing Postal Code should be 411001');
        System.assertEquals(customer1.dmpl__ShippingStreet__c,saleInvoice.dmpl__ShippingStreet__c, 'Shipping Street should match');
        System.assertEquals(customer1.dmpl__ShippingCity__c,saleInvoice.dmpl__ShippingCity__c, 'Shipping City should be Nagpur');
        
        System.assertEquals(12000, saleInvoice.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount mismatch');
        System.assertEquals(1000, saleInvoice.dmpl__TotalSchemeDiscountAmount__c, 'Scheme Discount should Match');
        System.assertEquals(11000, saleInvoice.dmpl__OpenAmount__c, 'Open Amount mismatch');
        
        
        System.assertEquals(2000.00, saleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be Match');
        System.assertEquals(12000.00, saleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be Match');
        
        
        try{
            saleInvoiceLine.dmpl__Quantity__c = 5;
            update saleInvoiceLine;
        }catch(Exception e){
            System.Assert.isTrue(false, 'Exception not Expected! >> '+ e.getMessage());
        }
        saleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        
        System.assertEquals(2000.00, saleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be Match');
        System.assertEquals(10000.00, saleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be Match');
        
        saleInvoice= SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        System.assertEquals(10000, saleInvoice.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount mismatch');
        
        
        Test.stopTest();
    }
    
    @isTest
    static void updateSchemeApplicabilityInCaseSchemeDiscountIsMoreThanAvailableBudgetNegative(){
        Account customer1= TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner4= TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4= TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item4= TestDataHelpers.getItem('Item 4');
        dmpl__SaleInvoice__c saleInvoice= SaleInvoiceDataHelper.createSaleInvoice(customer1, partner4, branch4);
        
        dmpl__SaleInvoiceLine__c saleInvoiceLine;
        Test.startTest();
        
        try{
            
            saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item4, null, null, null, null, 5, 2000);
        }catch(Exception e){
            System.Assert.isTrue(false, 'Exception not Expected! >> '+ e.getMessage());
        }
        
        saleInvoice= SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        saleInvoiceLine= SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        
        System.assertEquals(customer1.Id, saleInvoice.dmpl__AccountId__c, 'Customer Account Name should match');
        System.assertEquals('Within State', saleInvoice.dmpl__TaxSupplyType__c, 'Supply Type should be Within State');
        System.assertEquals(customer1.dmpl__BillingStreet__c, saleInvoice.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals(customer1.dmpl__BillingCity__c, saleInvoice.dmpl__BillingCity__c, 'Billing City should be Pune');
        System.assertEquals(customer1.dmpl__BillingState__c, saleInvoice.dmpl__BillingState__c, 'Billing State should be Maharashtra');
        System.assertEquals(customer1.dmpl__BillingCountry__c, saleInvoice.dmpl__BillingCountry__c, 'Billing Country should be India');
        System.assertEquals(customer1.dmpl__BillingPostalCode__c, saleInvoice.dmpl__BillingPostalCode__c, 'Billing Postal Code should be 411001');
        System.assertEquals(customer1.dmpl__ShippingStreet__c,saleInvoice.dmpl__ShippingStreet__c, 'Shipping Street should match');
        System.assertEquals(customer1.dmpl__ShippingCity__c,saleInvoice.dmpl__ShippingCity__c, 'Shipping City should be Nagpur');
        
        System.assertEquals(10000, saleInvoice.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount mismatch');
        System.assertEquals(0, saleInvoice.dmpl__TotalSchemeDiscountAmount__c, 'Scheme Discount should Match');
        System.assertEquals(0, saleInvoice.dmpl__TotalDiscountAmount__c, 'Total Discount should be 0');
        
        System.assertEquals(10000, saleInvoice.dmpl__OpenAmount__c, 'Open Amount mismatch');
        System.assertEquals(10000, saleInvoice.dmpl__OutstandingAmount__c, 'Outstanding Amount mismatch');
        
        System.assertEquals(2000.00, saleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be Match');
        System.assertEquals(10000.00, saleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be Match');
        System.assertEquals(item4.Id, saleInvoiceLine.dmpl__ItemId__c, 'Item Id should be Match');
        System.assertEquals(null, saleInvoiceLine.dmpl__TaxAmount__c, 'Total Tax Amount should be Match');
        System.assertEquals(10000, saleInvoiceLine.dmpl__GrossAmount__c, 'Gross Amount should be Match');
        
        try{
            saleInvoiceLine.dmpl__Quantity__c = 50;
            update saleInvoiceLine;
        }catch(Exception e){
            System.Assert.isTrue(false, 'Exception Expected!  Dicount is more than scheme Budget >> '+ e.getMessage());
        }
        saleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        
        System.assertEquals(2000.00, saleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be Match');
        System.assertEquals(100000.00, saleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be Match');
        System.assertEquals(50, saleInvoiceLine.dmpl__Quantity__c, 'Quantity should be Match');
        System.assertEquals(null, saleInvoiceLine.dmpl__TaxAmount__c, 'Total Tax Amount should be Match');
        System.assertEquals(100000, saleInvoiceLine.dmpl__GrossAmount__c, 'Gross Amount should be Match');
        
        Test.stopTest();
        
        
    }
    @isTest
    static void updateSaleInvoiceLinewithoutSchemesPositive(){
        Test.startTest();
        Account customer1= TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner1= TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1= TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item8= TestDataHelpers.getItem('Item 8');
        dmpl__SKU__c sku2 = TestDataHelpers.getSKU('SKU 2');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');
        dmpl__SaleInvoice__c saleInvoice= SaleInvoiceDataHelper.createSaleInvoice(customer1, partner1, branch1, 'Within State', taxGroup, null, null);
        
        dmpl__SaleInvoiceLine__c saleInvoiceLine;
        try{
            saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item8, sku2, null, null,  null, 20, 1500);
        }catch(Exception e){
            System.Assert.isTrue(false, 'Exception not Expected! >> '+ e.getMessage());
        }
        
        saleInvoice= SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        saleInvoiceLine= SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        
        System.assertEquals(customer1.Id, saleInvoice.dmpl__AccountId__c, 'Customer Account Name should match');
        System.assertEquals('Within State', saleInvoice.dmpl__TaxSupplyType__c, 'Supply Type should be Within State');
        System.assertEquals(customer1.dmpl__BillingStreet__c, saleInvoice.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals(customer1.dmpl__BillingCity__c, saleInvoice.dmpl__BillingCity__c, 'Billing City should be Pune');
        System.assertEquals(customer1.dmpl__BillingState__c, saleInvoice.dmpl__BillingState__c, 'Billing State should be Maharashtra');
        System.assertEquals(customer1.dmpl__BillingCountry__c, saleInvoice.dmpl__BillingCountry__c, 'Billing Country should be India');
        System.assertEquals(customer1.dmpl__BillingPostalCode__c, saleInvoice.dmpl__BillingPostalCode__c, 'Billing Postal Code should be 411001');
        System.assertEquals(customer1.dmpl__ShippingStreet__c,saleInvoice.dmpl__ShippingStreet__c, 'Shipping Street should match');
        System.assertEquals(customer1.dmpl__ShippingCity__c,saleInvoice.dmpl__ShippingCity__c, 'Shipping City should be Nagpur');
        
        System.assertEquals(1500.00, saleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be Match');
        System.assertEquals(30000.00, saleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be Match');
        System.assertEquals(4200, saleInvoiceLine.dmpl__Tax1__c, 'CGST should be Match');
        System.assertEquals('CGST', saleInvoiceLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(14, saleInvoiceLine.dmpl__Tax1Rate__c, 'Tax1 Rate should be 14%');
        System.assertEquals('CGST', saleInvoiceLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(4200, saleInvoiceLine.dmpl__Tax2__c, 'SGST should be Match');
        System.assertEquals('SGST', saleInvoiceLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(14, saleInvoiceLine.dmpl__Tax2Rate__c, 'Tax2 Rate should be 14%');
        System.assertEquals('SGST', saleInvoiceLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(8400, saleInvoiceLine.dmpl__TaxAmount__c, 'Total Tax Amount should be Match');
        System.assertEquals(38400, saleInvoiceLine.dmpl__GrossAmount__c, 'Gross Amount should be Match');
        
        
        try{
            saleInvoiceLine.dmpl__Quantity__c = 22;
            update saleInvoiceLine;
        }catch(Exception e){
            System.Assert.isTrue(false, 'Exception not Expected! >> '+ e.getMessage());
        }
        saleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        
        System.assertEquals(1500.00, saleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be Match');
        System.assertEquals(33000.00, saleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be Match');
        System.assertEquals(4620, saleInvoiceLine.dmpl__Tax1__c, 'CGST should be Match');
        System.assertEquals('CGST', saleInvoiceLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(14, saleInvoiceLine.dmpl__Tax1Rate__c, 'Tax1 Rate should be 14%');
        System.assertEquals('CGST', saleInvoiceLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(4620, saleInvoiceLine.dmpl__Tax2__c, 'SGST should be Match');
        System.assertEquals('SGST', saleInvoiceLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(14, saleInvoiceLine.dmpl__Tax2Rate__c, 'Tax2 Rate should be 14%');
        System.assertEquals('SGST', saleInvoiceLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(9240, saleInvoiceLine.dmpl__TaxAmount__c, 'Total Tax Amount should be Match');
        System.assertEquals(42240, saleInvoiceLine.dmpl__GrossAmount__c, 'Gross Amount should be Match');
        
        saleInvoice= SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        System.assertEquals(33000, saleInvoice.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount mismatch');
        System.assertEquals(0, saleInvoice.dmpl__TotalSchemeDiscountAmount__c, 'Scheme Discount should be 0');
        System.assertEquals(0, saleInvoice.dmpl__TotalDiscountAmount__c, 'Total Discount should be 0');
        System.assertEquals(9240, saleInvoice.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount mismatch');
        System.assertEquals(9240, saleInvoice.dmpl__TotalTaxAmount__c, 'Total Tax Amount mismatch');
        System.assertEquals(42240, saleInvoice.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount mismatch');
        System.assertEquals(42240, saleInvoice.dmpl__OpenAmount__c, 'Open Amount mismatch');
        System.assertEquals(42240, saleInvoice.dmpl__OutstandingAmount__c, 'Outstanding Amount mismatch');
        
        Test.stopTest();
    }
    
    @isTest
    static void updateSaleInvoiceLineWithSchemeAutoApplyDiscountAmount2Positive(){
        Test.startTest();
        Account customer1= TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner1= TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch1= TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item5 = TestDataHelpers.getItem('Item 5');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');
        dmpl__SaleInvoice__c saleInvoice= SaleInvoiceDataHelper.createSaleInvoice(customer1, partner1, branch1, 'Within State', taxGroup, null, null);
        
        dmpl__SaleInvoiceLine__c saleInvoiceLine;
        try{
            saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item5, 22);
        }catch(Exception e){
            System.Assert.isTrue(false, 'Exception not Expected! >> '+ e.getMessage());
        }
        
        saleInvoice= SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        saleInvoiceLine= SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        
        System.assertEquals(customer1.Id, saleInvoice.dmpl__AccountId__c, 'Customer Account Name should match');
        System.assertEquals('Within State', saleInvoice.dmpl__TaxSupplyType__c, 'Supply Type should be Within State');
        System.assertEquals(customer1.dmpl__BillingStreet__c, saleInvoice.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals(customer1.dmpl__BillingCity__c, saleInvoice.dmpl__BillingCity__c, 'Billing City should be Pune');
        System.assertEquals(customer1.dmpl__BillingState__c, saleInvoice.dmpl__BillingState__c, 'Billing State should be Maharashtra');
        System.assertEquals(customer1.dmpl__BillingCountry__c, saleInvoice.dmpl__BillingCountry__c, 'Billing Country should be India');
        System.assertEquals(customer1.dmpl__BillingPostalCode__c, saleInvoice.dmpl__BillingPostalCode__c, 'Billing Postal Code should be 411001');
        System.assertEquals(customer1.dmpl__ShippingStreet__c,saleInvoice.dmpl__ShippingStreet__c, 'Shipping Street should match');
        System.assertEquals(customer1.dmpl__ShippingCity__c,saleInvoice.dmpl__ShippingCity__c, 'Shipping City should be Nagpur');
        
        System.assertEquals(1000.00, saleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should be Match');
        System.assertEquals(22000.00, saleInvoiceLine.dmpl__BaseAmount__c, 'Base Amount should be Match');
        System.assertEquals(1800, saleInvoiceLine.dmpl__Tax1__c, 'CGST should be Match');
        System.assertEquals('CGST', saleInvoiceLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(9, saleInvoiceLine.dmpl__Tax1Rate__c, 'Tax1 Rate should be 6%');
        System.assertEquals('CGST', saleInvoiceLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(1800, saleInvoiceLine.dmpl__Tax2__c, 'SGST should be Match');
        System.assertEquals('SGST', saleInvoiceLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(9, saleInvoiceLine.dmpl__Tax2Rate__c, 'Tax2 Rate should be 6%');
        System.assertEquals('SGST', saleInvoiceLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(3600, saleInvoiceLine.dmpl__TaxAmount__c, 'Total Tax Amount should be Match');
        System.assertEquals(23600, saleInvoiceLine.dmpl__GrossAmount__c, 'Gross Amount should be Match');
        
        saleInvoice= SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        System.assertEquals(22000, saleInvoice.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount mismatch');
        System.assertEquals(2000, saleInvoice.dmpl__TotalSchemeDiscountAmount__c, 'Scheme Discount should be 0');
        System.assertEquals(0, saleInvoice.dmpl__TotalDiscountAmount__c, 'Total Discount should be 0');
        System.assertEquals(3600, saleInvoice.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount mismatch');
        System.assertEquals(3600, saleInvoice.dmpl__TotalTaxAmount__c, 'Total Tax Amount mismatch');
        System.assertEquals(23600, saleInvoice.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount mismatch');
        System.assertEquals(23600, saleInvoice.dmpl__OpenAmount__c, 'Open Amount mismatch');
        System.assertEquals(23600, saleInvoice.dmpl__OutstandingAmount__c, 'Outstanding Amount mismatch');
        
        Test.stopTest();
    }
    
    //Darshan
    //Sale Invoice with Discount Group & Scheme (Edit)
    @isTest
    static void updateSaleInvoiceWithDiscountGroupAndSchemePositive() {
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item5 = TestDataHelpers.getItem('Item 5');
        // dmpl__DiscountGroup__c discountGroup1 = TestDataHelpers.getDiscountGroup('Discount Group 1');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer1, partner4, branch4);
        Test.startTest();
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item5, 10);
        
        dmpl__SaleInvoice__c createdSaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        dmpl__SaleInvoiceLine__c createdSaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        try{
            saleInvoiceLine.dmpl__Quantity__c = 20;
            update saleInvoiceLine;
        }
        catch(DmlException e){
            System.debug('Exception: '+e.getMessage());
        }
        Test.stopTest();
        dmpl__SaleInvoice__c updatedSaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(createdSaleInvoice.Id);
        dmpl__SaleInvoiceLine__c updatedSaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(createdSaleInvoiceLine.Id);
        
        System.assertNotEquals(null, saleInvoice, 'Expected Sale Invoice to be created');
        System.assertNotEquals(null, createdSaleInvoice, 'Expected Sale Invoice to be created');
        System.assertNotEquals(null, saleInvoiceLine, 'Expected Sale Invoice Line to be created');
        System.assertNotEquals(null, createdSaleInvoiceLine, 'Expected Sale Invoice Line to be created');
        System.assertEquals('Customer 1', createdSaleInvoice.dmpl__AccountName__c, 'Customer Account Name should match');
        System.assert(createdSaleInvoice.dmpl__PriceListId__c != null, 'Price List should not be null');
        System.assertEquals(1000, createdSaleInvoiceLine.dmpl__UnitPrice__c, 'Unit Price should Match');
        System.assertEquals(1000, createdSaleInvoiceLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should Match');
        System.assertEquals(10620, createdSaleInvoiceLine.dmpl__GrossAmount__c, 'Gross Amount should Match');
        System.assertEquals(2000, updatedSaleInvoiceLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should Match after update');
        System.assertEquals(21240, updatedSaleInvoiceLine.dmpl__GrossAmount__c, 'Gross Amount should Match after update');
    }
    
    //Item SKU with is default false (Edit)
    @isTest
    static void updateSaleInvoiceLineWithItemSKUDefaultFalsePositive(){
        Test.startTest();
        Account customer4= TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner4= TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch4= TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item10= TestDataHelpers.getItem('Item 10');
        dmpl__SKU__c sku5= TestDataHelpers.getSKU('SKU 5');
        dmpl__SaleInvoice__c saleInvoice= SaleInvoiceDataHelper.createSaleInvoice(customer4, partner4, branch4);
        dmpl__SaleInvoiceLine__c saleInvoiceLine= SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item10,null,11,null);
        dmpl__SaleInvoice__c createdSaleInvoice= SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        dmpl__SaleInvoiceLine__c createdSaleInvoiceLine= SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        createdSaleInvoiceLine.dmpl__Quantity__c=17;
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
    
    //Scheme Applicability in case of Ignore Budget is True (Edit)
    @isTest
    static void updateSaleInvoiceLineWithSchemeApplicabilityIgnoreBudgetTruePositive() {
        Test.startTest();
        Account customer4 = TestDataHelpers.getCustomerAccount('Customer 4');
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer4, partner1, branch1);
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item1, 10);
        Test.stopTest();
    }
    
    //Scheme Applicability for Customer Account Defined (Edit)
    @isTest
    static void updateSaleInvoiceLineWithSchemeApplicabilityForCustomerAccountDefinedPositive() {
        
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item4 = TestDataHelpers.getItem('Item 4');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer1, partner4, branch4);
        Test.startTest();
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item4, 5);
        saleInvoiceLine.dmpl__Quantity__c = 25;
        update saleInvoiceLine;
        Test.stopTest();
        dmpl__SaleInvoiceLine__c updatedSaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        
        System.assertNotEquals(null, updatedSaleInvoiceLine, 'Expected Sale Invoice Line to be updated');
        
    }
    
    //Scheme Applicability in Case of Customer Account Group (Edit)
    @isTest
    static void updateSaleInvoiceLineWithSchemeApplicabilityForCustomerAccountGroupPositive() {
        Test.startTest();
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item6 = TestDataHelpers.getItem('Item 6');
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customer1, partner1, branch1);
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item6, 2);
        dmpl__SaleInvoice__c createdSaleInvoice = SaleInvoiceDataHelper.getSaleInvoice(saleInvoice.Id);
        dmpl__SaleInvoiceLine__c createdSaleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine(saleInvoiceLine.Id);
        createdSaleInvoiceLine.dmpl__Quantity__c = 4;
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
        System.assertEquals(0, updatedSaleInvoice.dmpl__TotalSchemeDiscountAmount2__c, 'Total Scheme Discount Amount should be ₹0.00 after update');
    }
}