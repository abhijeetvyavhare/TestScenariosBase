@isTest
public with sharing class SaleOrderHandler_Test {
    @TestSetup
    static void createRequiredData() {
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

        Contact contact = TestDataHelpers.createContact('Contact 1', '9113150885', '9889198008', customerAccount1.Id);

        dmpl__AccountGroup__c accountGroup1 = TestDataHelpers.createAccountGroup('Account Group 1',null);
        dmpl__AccountGroupMember__c accountGroupMember1 = TestDataHelpers.createAccountGroupMember(accountGroup1.id,partnerAccount1.id);
        dmpl__AccountGroupMember__c accountGroupMember2 = TestDataHelpers.createAccountGroupMember(accountGroup1.id,partnerAccount2.id);

        dmpl__PriceList__c priceList1 = TestDataHelpers.createPriceList('Price List 1', partnerAccount1.Id, branch1.Id, null, null, true, false, 'Sale Price');
        dmpl__PriceList__c priceList2 = TestDataHelpers.createPriceList('Price List 2', partnerAccount1.Id, branch1.Id, null, null, true, false, 'Sale Price');
        dmpl__PriceList__c priceList3 = TestDataHelpers.createPriceList('Price List 3',partnerAccount4.Id,branch4.Id,null,null,true,false,'Sale Price');
        dmpl__PriceList__c priceList5=TestDataHelpers.createPriceList('Price List 5', partnerAccount6.Id, branch6.Id, null, null, false, false, 'Sales');
        dmpl__PriceList__c priceList7 = TestDataHelpers.createPriceList('Price List 7',null,null, null, null, true, false, 'Sales');

        dmpl__Item__c  item1 = TestDataHelpers.createItem('Item 1','Product',true,false,false,'675654',false, false);
        dmpl__Item__c item2 = TestDataHelpers.createItem('Item 2','Product',false,false,false,'654345',false, false);
        dmpl__Item__c item3 = TestDataHelpers.createItem('Item 3','Charge Item',true, false, false ,'765434',true, false);
        dmpl__Item__c item4 = TestDataHelpers.createItem('Item 4','Product',true, false, false ,'765676',true, false);
        dmpl__Item__c item5 = TestDataHelpers.createItem('Item 5', 'Product', true, false, false, '876543', false, false);
        dmpl__Item__c item6 = TestDataHelpers.createItem('Item 6', 'Product', true, false, false, '765456', false, false);
        dmpl__Item__c item7 = TestDataHelpers.createItem('Item 7','Product',true,false,true, '765456',false,false);
        dmpl__Item__c item8 = TestDataHelpers.createItem('Item 8','Product',true,false,true, '765456',false, false);
        dmpl__Item__c item13 = TestDataHelpers.createItem('Item 13','Product',true,false,false, '765456',true, false);
        dmpl__Item__c item14 = TestDataHelpers.createItem('Item 14', 'Part', true, false, false, '765458', true, false);
        dmpl__Item__c item15 = TestDataHelpers.createItem('Item 15', 'Part', true, false, false, '765459', false, true);
        dmpl__Item__c item16 = TestDataHelpers.createItem('Item 16', 'Part', true, false, false, '765460', false, true);

        dmpl__ItemGroup__c itemGroup1 = TestDataHelpers.createItemGroup('Item Group 1','Tax');
        dmpl__ItemGroupMember__c itemGroupMemeber1 = TestDataHelpers.createItemGroupMember(itemGroup1.Id,item1.Id);
        dmpl__ItemGroupMember__c itemGroupMemeber2 = TestDataHelpers.createItemGroupMember(itemGroup1.Id,item2.Id);

        dmpl__ItemAlternate__c itemAlternate16 = TestDataHelpers.createItemAlternate(item15.Id,item16.Id,'Superseded',Date.newInstance(2025, 6, 30));
        dmpl__ItemAlternate__c itemAlternate13 = TestDataHelpers.createItemAlternate(item14.Id, item13.Id, 'Superseded', Date.newInstance(2025, 6, 30));
     
        dmpl__SKU__c sku1 = TestDataHelpers.createSKU('SKU 1', item7.id, true);
        dmpl__SKU__c sku2 = TestDataHelpers.createSKU('SKU 2', item8.id, false);

        dmpl__PriceListRules__c priceListRule1 = TestDataHelpers.createPriceListRules(priceList1.id, item1.id,null,null,1500, System.today().addDays(-15),System.today()+9);
        dmpl__PriceListRules__c priceListRule10 = TestDataHelpers.createPriceListRules(priceList3.id, item1.id,null,null,1500, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule3 = TestDataHelpers.createPriceListRules(priceList1.id, item3.id,null,null,2000, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule4 = TestDataHelpers.createPriceListRules(priceList1.id, item4.id,null,null,2000, System.today()-1,System.today()+9);  
        dmpl__PriceListRules__c priceListRule5 = TestDataHelpers.createPriceListRules(priceList3.id, item6.id,null,null,2000, System.today()-1,System.today()+9); 
        dmpl__PriceListRules__c priceListRule7 = TestDataHelpers.createPriceListRules(priceList3.id, item5.id,null,null,1000, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule8 = TestDataHelpers.createPriceListRules(priceList1.id, item5.id,null,null,1000, System.today().addDays(-1),System.today()+9);
        dmpl__PriceListRules__c priceListRule9 = TestDataHelpers.createPriceListRules(priceList1.id, item6.id,null,null,2400, System.today()-1,System.today()+9);  
        dmpl__PriceListRules__c priceListRule11 = TestDataHelpers.createPriceListRules(priceList3.id, item8.id,null,null,1500, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule13 = TestDataHelpers.createPriceListRules(priceList1.id, item13.id,null,null,1500, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule14 = TestDataHelpers.createPriceListRules(priceList1.id, item14.id,null,null,1500, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule12 = TestDataHelpers.createPriceListRules(priceList1.id, item15.id,null,null,1500, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule16 = TestDataHelpers.createPriceListRules(priceList1.id, item16.id,null,null,1500, System.today()-1,System.today()+9);

        dmpl__TaxGroup__c taxGroupGST28partner1 = TestDataHelpers.createTaxGroup('GST 28', true, 'Line Level', partnerAccount1.Id, branch1.Id, null);
        dmpl__TaxGroup__c taxGroupGST28partner4= TestDataHelpers.createTaxGroup('GST 288', true, 'Line Level', partnerAccount4.Id, branch4.Id, null);
        dmpl__TaxGroup__c taxGroupGST12Global = TestDataHelpers.createTaxGroup('GST 12', true, 'Line Level', null, null, null);
        dmpl__TaxGroup__c taxGroupIGST18 = TestDataHelpers.createTaxGroup('IGST 18', true, 'Line Level', null, null, null);

        dmpl__Tax__c taxCGST14 = TestDataHelpers.createTax('CGST', 'CGST', 14, taxGroupGST28partner1.Id, 'Tax1');
        dmpl__Tax__c taxSGST14 = TestDataHelpers.createTax('SGST', 'SGST', 14, taxGroupGST28partner1.Id, 'Tax2');
        dmpl__Tax__c taxCGST6 = TestDataHelpers.createTax('CGST', 'CGST', 6, taxGroupGST12Global.Id, 'Tax1');
        dmpl__Tax__c taxSGST6 = TestDataHelpers.createTax('SGST', 'SGST', 6, taxGroupGST12Global.Id, 'Tax2');
        dmpl__Tax__c taxIGST18 = TestDataHelpers.createTax('IGST', 'IGST', 18, taxGroupIGST18.Id, 'Tax3');
        dmpl__Tax__c taxCGST14_8 = TestDataHelpers.createTax('CGST', 'CGST', 14, taxGroupGST28partner4.Id, 'Tax1');
        dmpl__Tax__c taxSGST14_8 = TestDataHelpers.createTax('SGST', 'SGST', 14, taxGroupGST28partner4.Id, 'Tax2');

        dmpl__TaxGroupRule__c taxGroupRule28Item1 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST28partner1.Id,item1.Id,null,null,null);
        dmpl__TaxGroupRule__c taxGroupRule12Item5 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST12Global.Id,item5.Id,null,null,null);
        dmpl__TaxGroupRule__c taxGroupRule12Item4 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST12Global.Id,item6.Id,null,null,null);
        dmpl__TaxGroupRule__c taxGroupRuleItem1 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST12Global.Id,item1.Id,null,null,null);
        dmpl__TaxGroupRule__c taxGroupRuleIGST18 = TestDataHelpers.createTaxGroupRule('Outside State',taxGroupIGST18.Id,null,null,null,null);  
        dmpl__TaxGroupRule__c taxGroupRule28item8 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST28partner4.Id,item8.Id,null,null,null); 
        dmpl__TaxGroupRule__c taxGroupRule28Item13 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST28partner1.Id,item13.Id,null,null,null);    
        dmpl__TaxGroupRule__c taxGroupRule28Item14 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST28partner1.Id,item14.Id,null,null,null);    
        dmpl__TaxGroupRule__c taxGroupRule28Item15 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST28partner1.Id,item15.Id,null,null,null);
        dmpl__TaxGroupRule__c taxGroupRule28Item16 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST28partner1.Id,item16.Id,null,null,null); 
        dmpl__TaxGroupRule__c taxGroupRule18Item5IGST = TestDataHelpers.createTaxGroupRule('Outside State',taxGroupIGST18.Id,item5.Id,null,null,null);   
        
        dmpl__Resource__c resource2 = TestDataHelpers.createResource('Resource 2', partnerAccount1.Id, branch1.Id, false); 

        dmpl__DiscountGroup__c discountGroup1 = DiscountDataHelper.createDiscountGroup('Discount 1',partnerAccount4.Id,branch4.Id,null,true,'Sale Price');
        dmpl__DiscountGroup__c discountGroup2 = DiscountDataHelper.createDiscountGroup('Discount 2',partnerAccount1.Id,branch1.Id,null,true,'Purchase Price');

        dmpl__DiscountGroupRule__c discountGroupRule1 = DiscountDataHelper.createDiscountGroupRule(discountGroup1.Id,item6.Id,null,null,null,4,Date.newInstance(2025, 1, 5),Date.newInstance(2025, 7, 30)); 
        dmpl__DiscountGroupRule__c discountGroupRule2 = DiscountDataHelper.createDiscountGroupRule(discountGroup1.Id,item5.Id,null,null,null,4,Date.newInstance(2025, 1, 8),Date.newInstance(2025, 7, 30)); 
        dmpl__DiscountGroupRule__c discountGroupRule3 = DiscountDataHelper.createDiscountGroupRule(discountGroup2.Id,item6.Id,null,null,null,4,Date.newInstance(2025, 5, 6),Date.newInstance(2025, 11, 30));

        dmpl__ItemUnitOfMeasure__c uomCaseItem5 = TestDataHelpers.ItemUnitOfMeasure('Case','Case',1, item5.Id);
        dmpl__ItemUnitOfMeasure__c uomPiecesItem5 = TestDataHelpers.ItemUnitOfMeasure('Pieces','Pieces',0.033333, item5.Id);
        dmpl__ItemUnitOfMeasure__c uomCaseItem1 = TestDataHelpers.ItemUnitOfMeasure('Case','Case',1, item1.Id);
        dmpl__ItemUnitOfMeasure__c uomPiecesItem1 = TestDataHelpers.ItemUnitOfMeasure('Pieces','Pieces',0.033333, item1.Id);
        dmpl__ItemUnitOfMeasure__c uomCaseItem6 = TestDataHelpers.ItemUnitOfMeasure('Case','Case',1, item6.Id);
        dmpl__ItemUnitOfMeasure__c uomPiecesItem6 = TestDataHelpers.ItemUnitOfMeasure('Pieces','Pieces',0.033333, item6.Id);

        dmpl__Scheme__c scheme2 = SchemeDataHelper.createScheme('Scheme 2', 'Auto Apply', 'Draft', 'Per Sale order and Invoice', 'Per Order', Date.newInstance(2025, 5, 1), Date.newInstance(2025, 6, 30), 10, 'Apply all Fulfilled', 1, false, partnerAccount4.Id, null, null, null, branch4.Id, 100000);
        dmpl__SchemeLine__c schemeLine2 = SchemeDataHelper.createSchemeLine(1, 'NET RATE', 'All Conditions Are Met', 'All Rewards', scheme2.Id);
        dmpl__SchemeCondition__c schemeCondition2 = SchemeDataHelper.createSchemeCondition('Item Quantity', 'Greater Than Or Equal', item5.Id, 10, schemeLine2.Id, scheme2.Id, 1);
        dmpl__SchemeBenefit__c schemeBenefit2 = SchemeDataHelper.createSchemeBenefit( 'Rate Off', 'Line Level Discount Amount',null, null,null, 1000, schemeLine2.Id, scheme2.Id,1);        
        dmpl__SchemeAccountBudget__c schemeBudget2 = SchemeDataHelper.createSchemesAccountBudget(100000, scheme2.Id, partnerAccount4.Id);
        scheme2.dmpl__Status__c = 'Approved';
        update scheme2;
       
        dmpl__Scheme__c scheme9 = SchemeDataHelper.createScheme('Scheme 9', 'Auto Apply', 'Draft', 'Per Sale Order And Invoice', 'per order', Date.newInstance(2025, 5, 26), Date.newInstance(2025, 6, 26), 0, 'Apply all Fulfilled', 1,false, partnerAccount1.Id, null, null, customerAccount1.Id, branch1.Id, 100000);
        dmpl__SchemeLine__c schemeLine9 = SchemeDataHelper.createSchemeLine(1, 'Percentage', 'All Conditions Are Met', 'All Rewards', scheme9.Id);
        dmpl__SchemeCondition__c schemeCondition9 = SchemeDataHelper.createSchemeCondition('Item Quantity', 'Equals', item6.Id, 2, schemeLine9.Id, scheme9.Id, 1);
        dmpl__SchemeBenefit__c schemeBenefit9 = SchemeDataHelper.createSchemeBenefit('FREE ITEM', 'Line Level Discount Percent', null, 1, 5, null, schemeLine9.Id, scheme9.Id, 1);
        dmpl__SchemeAccountBudget__c schemeBudget9 = SchemeDataHelper.createSchemesAccountBudget(100000, scheme9.Id, partnerAccount1.Id);
        scheme9.dmpl__Status__c = 'Approved';
        update scheme9;

        dmpl__Scheme__c scheme20 = SchemeDataHelper.createScheme('Scheme 20', 'Auto Apply', 'Draft', 'Per Purchase order', 'PER ORDER', Date.newInstance(2025, 5, 20), Date.newInstance(2025, 6, 30), 2, 'Apply all Fulfilled', 1, true, partnerAccount1.Id, null, null, customerAccount1.Id, branch1.Id, 100000);
        dmpl__SchemeLine__c schemeLine20 = SchemeDataHelper.createSchemeLine(1, 'FREE OF COST', 'All Conditions Are Met', 'All Rewards', scheme20.Id);
        dmpl__SchemeCondition__c schemeCondition20 = SchemeDataHelper.createSchemeCondition('Item Quantity', 'Greater Than Or Equal', item1.Id, 18, schemeLine20.Id, scheme20.Id, 1);
        dmpl__SchemeBenefit__c schemeBenefit20 = SchemeDataHelper.createSchemeBenefit('FREE ITEM', 'Discounted Item', item1.Id, 1, 5, null, schemeLine20.Id, scheme20.Id, 1);
        dmpl__SchemeAccountBudget__c schemeBudget20 = SchemeDataHelper.createSchemesAccountBudget(100000, scheme20.Id, partnerAccount1.Id);
        scheme20.dmpl__Status__c = 'Approved';
        update scheme20;
    }
    
    @isTest
    static void createSaleOrderPositive() {
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        Account customerAccount1=TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList1=TestDataHelpers.getPriceList('Price List 1');
        
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id, 
            partnerAccount1.Id, 
            branch1.Id, 
            null, 
            null, 
            false,
            null
        );
        Test.stopTest();
        
        dmpl__SaleOrder__c saleOrder1 = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertNotEquals(null, saleOrder1.Id, 'Sale Order should be created');
        System.assertEquals('Draft', saleOrder1.dmpl__Status__c, 'Sale Order status should be Draft');
        System.assertEquals('Customer 1', saleOrder1.dmpl__AccountName__c, 'Account Name should match');
        System.assertEquals('Within State', saleOrder1.dmpl__TaxSupplyType__c, 'Tax Supply Type should match');
        System.assertEquals('MG Road', saleOrder1.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals('Pune', saleOrder1.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals('Maharashtra', saleOrder1.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals('India', saleOrder1.dmpl__BillingCountry__c, 'Billing Country should match');
        System.assertEquals('411001', saleOrder1.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');
        System.assertEquals(System.today(), saleOrder1.dmpl__DocumentDate__c, 'Document Date should match');
    }

    @isTest
    static void createSaleOrderLinePositive() {
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');

        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id,
            partnerAccount1.Id,
            branch1.Id,
            null,
            null,
            false,
            null
        );

        SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            15,
            null
        );
        Test.stopTest();

        dmpl__SaleOrderLine__c line = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertNotEquals(line, null, 'Expected Sale Order Line to be created.');
        System.assertEquals(15, line.dmpl__Quantity__c, 'Quantity should be 15');
        System.assertEquals(null, line.dmpl__Discount__c, 'Discount should be null');
        System.assertEquals(1500, line.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(22500, line.dmpl__BaseAmount__c, 'Base Amount should match');
        System.assertEquals(6300, line.dmpl__TaxAmount__c, 'Tax Amount should match');
        System.assertEquals(28800, line.dmpl__GrossAmount__c, 'Gross Amount should match');
        System.assertEquals(14, line.dmpl__Tax1Rate__c, 'Tax 1 rate should match');
        System.assertEquals(14, line.dmpl__Tax2Rate__c, 'Tax 2 rate should match');
        System.assertEquals('CGST', line.dmpl__Tax1Name__c, 'Tax 1 Name should match');
        System.assertEquals('SGST', line.dmpl__Tax2Name__c, 'Tax 2 Name should match');
        System.assertEquals('CGST', line.dmpl__Tax1Type__c, 'Tax 1 Type should match');
        System.assertEquals('SGST', line.dmpl__Tax2Type__c, 'Tax 2 Type should match');
    }

   @isTest
    static void updateSaleOrderPositive() {
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Contact contact = TestDataHelpers.getContact('Contact 1');

        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id,
            partnerAccount1.Id,
            branch1.Id,
            null,
            null,
            false,
            null
        );

        dmpl__SaleOrder__c blankContactOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals(null, blankContactOrder.dmpl__ContactId__c, 'Contact should be null initially');
        System.assertEquals(null, blankContactOrder.dmpl__ContactName__c, 'Contact Name should be null initially');
        System.assertEquals(null, blankContactOrder.dmpl__ContactNumber__c, 'Contact Number should be null initially');

        blankContactOrder.dmpl__ContactId__c = contact.Id;
        update blankContactOrder;

        dmpl__SaleOrder__c updatedOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals(contact.Id, updatedOrder.dmpl__ContactId__c, 'Contact Id should match');
        Test.stopTest();
    }

    @isTest
    static void updateSaleOrderLinePositive() {
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');

        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id,
            partnerAccount1.Id,
            branch1.Id,
            null,
            null,
            false,
            null
        );

        dmpl__SaleOrderLine__c createdLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            15,
            null
        );

        dmpl__SaleOrderLine__c lineBeforeUpdate = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertNotEquals(lineBeforeUpdate, null, 'Line should exist before update');
        System.assertEquals(15, lineBeforeUpdate.dmpl__Quantity__c, 'Initial quantity should be 15');
        System.assertEquals(null, lineBeforeUpdate.dmpl__Discount__c, 'Discount should be null');
        System.assertEquals(1500, lineBeforeUpdate.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(22500, lineBeforeUpdate.dmpl__BaseAmount__c, 'Base Amount should match');
        System.assertEquals(6300, lineBeforeUpdate.dmpl__TaxAmount__c, 'Tax Amount should match');
        System.assertEquals(28800, lineBeforeUpdate.dmpl__GrossAmount__c, 'Gross Amount should match');
        System.assertEquals(14, lineBeforeUpdate.dmpl__Tax1Rate__c, 'Tax 1 rate should match');
        System.assertEquals(14, lineBeforeUpdate.dmpl__Tax2Rate__c, 'Tax 2 rate should match');
        System.assertEquals('CGST', lineBeforeUpdate.dmpl__Tax1Name__c, 'Tax 1 Name should match');
        System.assertEquals('SGST', lineBeforeUpdate.dmpl__Tax2Name__c, 'Tax 2 Name should match');
        System.assertEquals('CGST', lineBeforeUpdate.dmpl__Tax1Type__c, 'Tax 1 Type should match');
        System.assertEquals('SGST', lineBeforeUpdate.dmpl__Tax2Type__c, 'Tax 2 Type should match');

        lineBeforeUpdate.dmpl__Quantity__c = 20;
        update lineBeforeUpdate;

        dmpl__SaleOrderLine__c lineAfterUpdate = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertNotEquals(lineAfterUpdate, null, 'Line should exist after update');
        System.assertEquals(20, lineAfterUpdate.dmpl__Quantity__c, 'Updated quantity should be 20');
        System.assertEquals(null, lineAfterUpdate.dmpl__Discount__c, 'Discount should remain null');
        System.assertEquals(1500, lineAfterUpdate.dmpl__UnitPrice__c, 'Unit Price should remain unchanged');
        System.assertEquals(30000, lineAfterUpdate.dmpl__BaseAmount__c, 'Updated Base Amount should match');
        System.assertEquals(8400, lineAfterUpdate.dmpl__TaxAmount__c, 'Updated Tax Amount should match');
        System.assertEquals(38400, lineAfterUpdate.dmpl__GrossAmount__c, 'Updated Gross Amount should match');
        System.assertEquals(4200.00, lineAfterUpdate.dmpl__Tax1__c, 'Tax 1 should match after update');
        System.assertEquals(4200.00, lineAfterUpdate.dmpl__Tax2__c, 'Tax 2 should match after update');
        System.assertEquals(14, lineAfterUpdate.dmpl__Tax1Rate__c, 'Tax 1 rate should match');
        System.assertEquals(14, lineAfterUpdate.dmpl__Tax2Rate__c, 'Tax 2 rate should match');
        System.assertEquals('CGST', lineAfterUpdate.dmpl__Tax1Name__c, 'Tax 1 Name should match');
        System.assertEquals('SGST', lineAfterUpdate.dmpl__Tax2Name__c, 'Tax 2 Name should match');
        System.assertEquals('CGST', lineAfterUpdate.dmpl__Tax1Type__c, 'Tax 1 Type should match');
        System.assertEquals('SGST', lineAfterUpdate.dmpl__Tax2Type__c, 'Tax 2 Type should match');
        Test.stopTest();
    }

    @isTest
    static void deleteSaleOrderLinePositive() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');

        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount.Id,
            partnerAccount.Id,
            branch.Id,
            null,
            null,
            false,
            null
        );
        dmpl__SaleOrderLine__c line = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            10,
            null
        );
        delete line;
        Test.stopTest();

        dmpl__SaleOrderLine__c deletedLine = null;
        try {
            deletedLine = SaleOrderDataHelper.getSaleOrderLine(line.Id);
        } catch (Exception e) {
            deletedLine = null;
        }
        System.assertEquals(null, deletedLine, 'SaleOrderLine should be deleted.');
    }

    @isTest
    static void deleteSaleOrderPositive() {
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');

        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id,
            partnerAccount1.Id,
            branch1.Id,
            null,
            null,
            false,
            null
        );
        delete saleOrder;
        Test.stopTest();

        dmpl__SaleOrder__c saleOrder1 = null;
        try {
            saleOrder1 = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        } catch (Exception e) {
            saleOrder1 = null;
        }
        System.assertEquals(null, saleOrder1, 'Sale Order should be deleted');
    }

    @isTest
    static void createSaleOrderWithGSTTaxGlobalPositive() {
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount2 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList1=TestDataHelpers.getPriceList('Price List 1');

        dmpl__SaleOrder__c prevSaleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id, 
            partnerAccount2.Id, 
            branch.Id, 
            null, 
            null, 
            false,
            null
        );

 		dmpl__SaleOrder__c saleOrder= SaleOrderDataHelper.getSaleOrder(prevSaleOrder.Id);
        System.assertNotEquals(null, saleOrder.Id, 'Sale Order should be created');
        System.assertEquals('Draft', saleOrder.dmpl__Status__c, 'Sale Order status should be Draft');
        System.assertEquals('Customer 1', saleOrder.dmpl__AccountName__c, 'Account Name should match');
        System.assertEquals('Within State', saleOrder.dmpl__TaxSupplyType__c, 'Tax Supply Type should match');
        System.assertEquals('MG Road', saleOrder.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals('Pune', saleOrder.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals('Maharashtra', saleOrder.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals('India', saleOrder.dmpl__BillingCountry__c, 'Billing Country should match');
        System.assertEquals('411001', saleOrder.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');
        System.assertEquals(System.today(), saleOrder.dmpl__DocumentDate__c, 'Document Date should match');
        Test.stopTest();
    }

    @isTest
    static void createSaleOrderWithPriceList() {
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');

        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id,
            partnerAccount1.Id,
            branch1.Id,
            null,
            null,
            false,
            null
        );

        dmpl__SaleOrderLine__c createdLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            10,
            null
        );

        dmpl__SaleOrder__c saleOrder1 = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertNotEquals(null, saleOrder1.Id, 'Sale Order should be created');
        System.assertEquals(priceList1.Id, saleOrder1.dmpl__PriceListId__c, 'Price List should match');
        System.assertEquals('Customer 1', saleOrder1.dmpl__AccountName__c, 'Account Name should match');
        System.assertEquals('Within State', saleOrder1.dmpl__TaxSupplyType__c, 'Tax Supply Type should match');
        System.assertEquals('MG Road', saleOrder1.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals('Pune', saleOrder1.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals('Maharashtra', saleOrder1.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals('India', saleOrder1.dmpl__BillingCountry__c, 'Billing Country should match');
        System.assertEquals('411001', saleOrder1.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');

        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertNotEquals(saleOrderLine, null, 'Line should exist before update');
        System.assertEquals(10, saleOrderLine.dmpl__Quantity__c, 'Initial quantity should be 10');
        System.assertEquals(null, saleOrderLine.dmpl__Discount__c, 'Discount should be null');
        System.assertEquals(1500, saleOrderLine.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(15000, saleOrderLine.dmpl__BaseAmount__c, 'Base Amount should match');
        System.assertEquals(4200, saleOrderLine.dmpl__TaxAmount__c, 'Tax Amount should match');
        System.assertEquals(19200, saleOrderLine.dmpl__GrossAmount__c, 'Gross Amount should match');
        Test.stopTest();
    }

    @isTest
    static void createSaleOrderWithInactiveBranchNegative() {
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c inactiveBranch = TestDataHelpers.getBranch('Branch 3');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        dmpl__ContactAddress__c address1 = TestDataHelpers.getContactAddress('Address 1');

        System.assertEquals(false, inactiveBranch.dmpl__IsActive__c, 'Branch should be inactive for this test');
        
        Test.startTest();
        try {
            dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
                customerAccount1.Id,
                partnerAccount1.Id,
                inactiveBranch.Id,
                address1.Id,
                null,
                false,
                null
            );
            System.assert(false, 'Expected an exception to be thrown for inactive branch');
        } catch (Exception e) {
            System.assertEquals('Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, The specified Branch is not active!: []', 
                e.getMessage(),
                'Expected validation error for inactive branch');
        }
        Test.stopTest();
    }
    
    @isTest
    static void saleOrderWithBillingShippingAddressPositive() {
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        dmpl__ContactAddress__c address1=TestDataHelpers.getContactAddress('Address 1');
        dmpl__ContactAddress__c address2=TestDataHelpers.getContactAddress('Address 2');
        
        Test.startTest();
        dmpl__SaleOrder__c saleOrder1 = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id,
            partnerAccount1.Id,
            branch1.Id,
            address1.Id,
            address2.Id,
            false,
            null
        );
        Test.stopTest();

		dmpl__SaleOrder__c saleOrder= SaleOrderDataHelper.getSaleOrder(saleOrder1.Id);
        System.assertNotEquals(null, saleOrder.Id, 'Sale Order should be created');
        System.assertEquals(customerAccount1.Id, saleOrder.dmpl__AccountId__c, 'Customer Account should match');
        System.assertEquals(partnerAccount1.Id, saleOrder.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, saleOrder.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(priceList1.Id, saleOrder.dmpl__PriceListId__c, 'Price List should match');
        System.assertEquals('Within State', saleOrder.dmpl__TaxSupplyType__c, 'Tax Supply Type should match');
        System.assertEquals('Ring Rd', saleOrder.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals('Pune', saleOrder.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals('Maharashtra', saleOrder.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals('India', saleOrder.dmpl__BillingCountry__c, 'Billing Country should match');
        System.assertEquals('440001', saleOrder.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');
        System.assertEquals('Ring Rd', saleOrder.dmpl__ShippingStreet__c, 'Shipping Street should match');
        System.assertEquals('Pune', saleOrder.dmpl__ShippingCity__c, 'Shipping City should match');
        System.assertEquals('Maharashtra', saleOrder.dmpl__ShippingState__c, 'Shipping State should match');
        System.assertEquals('India', saleOrder.dmpl__ShippingCountry__c, 'Shipping Country should match');
        System.assertEquals('440001', saleOrder.dmpl__ShippingPostalCode__c, 'Shipping Postal Code should match');
        System.assertEquals('Draft', saleOrder.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(System.today(), saleOrder.dmpl__DocumentDate__c, 'Document Date should match');
    }

    @isTest
    static void createSaleOrderWithInactivePartnerAccountNegative() {
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account inactivePartnerAccount = TestDataHelpers.getPartnerAccount('Partner 2');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 2');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        dmpl__ContactAddress__c address1=TestDataHelpers.getContactAddress('Address 1');

        inactivePartnerAccount.IsActive__c = false;
        update inactivePartnerAccount;
    
        System.assertEquals(false, inactivePartnerAccount.IsActive__c, 'Partner account should be inactive for this test');
    
        Test.startTest();
        try {
            dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
                customerAccount1.Id,
                inactivePartnerAccount.Id,
                branch.Id,
                address1.Id,
                null,
                false,
                null
            );
        } catch (Exception e) {
            String errorMsg = e.getMessage();
            Boolean correctException = errorMsg.contains('FIELD_CUSTOM_VALIDATION_EXCEPTION') &&
                                    errorMsg.contains('The partner account is not active!');
            System.assertEquals(true, correctException,
                'Expected validation error for inactive partner account but got: ' + errorMsg);
        }
        Test.stopTest();
    }

    @isTest
    static void createSaleOrderWithNoCustomerAccountNegative() {
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        dmpl__ContactAddress__c address1=TestDataHelpers.getContactAddress('Address 1');

        Test.startTest();
        try {
            dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
                null,
                partnerAccount1.Id, 
                branch1.Id,
                null,
                null,
                false,
                null
            );
        } catch(Exception e) {
            String errorMsg = e.getMessage();
            Boolean correctException = errorMsg.contains('FIELD_CUSTOM_VALIDATION_EXCEPTION') &&
                                     errorMsg.contains('Please Select a Customer Account');
            System.assert(correctException,
                'Expected validation error for missing customer account but got: ' + errorMsg);
        }
        Test.stopTest();
    }
    
    @isTest
    static void createSaleOrderWithPriceListForPartnerAccountAndBranchPositive() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__PriceList__c priceList3 = TestDataHelpers.getPriceList('Price List 3');
     
        Test.startTest();
        dmpl__SaleOrder__c saleOrder1 = SaleOrderDataHelper.createSaleOrder(
            customerAccount.Id,
            partnerAccount4.Id,
            branch4.Id,
            null,
            null,
            false,
            null
        );
        Test.stopTest();
       
        dmpl__SaleOrder__c saleOrder= SaleOrderDataHelper.getSaleOrder(saleOrder1.Id);
        System.assertNotEquals(null, saleOrder.Id, 'Sale Order should be created');
        System.assertEquals('Draft', saleOrder.dmpl__Status__c, 'Sale Order status should be Draft');
        System.assertEquals('Price List 3', saleOrder.dmpl__PriceListId__r.Name, 'Price List should match');
        System.assertEquals('Customer 1', saleOrder.dmpl__AccountName__c, 'Account Name should match');
        System.assertEquals('Within State', saleOrder.dmpl__TaxSupplyType__c, 'Tax Supply Type should match');
        System.assertEquals('MG Road', saleOrder.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals('Pune', saleOrder.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals('Maharashtra', saleOrder.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals('India', saleOrder.dmpl__BillingCountry__c, 'Billing Country should match');
        System.assertEquals('411001', saleOrder.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');
        System.assertEquals('Ring Rd', saleOrder.dmpl__ShippingStreet__c, 'Shipping Street should match');
        System.assertEquals('Nagpur', saleOrder.dmpl__ShippingCity__c, 'Shipping City should match');
    }
      
    @isTest
    static void saleOrderWithPriceListForPartnerAccountGroupPositive() {
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');

        Test.startTest();
        dmpl__SaleOrder__c saleOrder1 = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id,
            partnerAccount1.Id,
            branch1.Id,
            null,
            null,
            false,
            null
        );
        Test.stopTest();

		dmpl__SaleOrder__c saleOrder= SaleOrderDataHelper.getSaleOrder(saleOrder1.Id);
        System.assertNotEquals(null, saleOrder.Id, 'Sale Order should be created');
        System.assertEquals('Draft', saleOrder.dmpl__Status__c, 'Sale Order status should be Draft');
        System.assertEquals('Customer 1', saleOrder.dmpl__AccountName__c, 'Account Name should match');
        System.assertEquals('Price List 1', saleOrder.dmpl__PriceListId__r.Name, 'Price List should match');
        System.assertEquals('Within State', saleOrder.dmpl__TaxSupplyType__c, 'Tax Supply Type should match');
        System.assertEquals('MG Road', saleOrder.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals('Pune', saleOrder.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals('Maharashtra', saleOrder.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals('India', saleOrder.dmpl__BillingCountry__c, 'Billing Country should match');
        System.assertEquals('411001', saleOrder.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');
        System.assertEquals(System.today(), saleOrder.dmpl__DocumentDate__c, 'Document Date should match');
    }

    @isTest
    static void createSaleOrderWithPriceListForCustomerAccGrp() {
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id,
            partnerAccount1.Id,
            branch1.Id,
            null,
            null,
            false,
            null
        );
        Test.stopTest();

        dmpl__SaleOrder__c saleOrder1 = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals('Customer 1', saleOrder1.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals('Price List 1', saleOrder1.dmpl__PriceListId__r.Name, 'Price List should match');
        System.assertEquals('Within State', saleOrder1.dmpl__TaxSupplyType__c, 'Tax Group should match');
        System.assertEquals(System.today(), saleOrder1.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', saleOrder1.dmpl__Status__c, 'Status should be draft');
        System.assertEquals('MG Road', saleOrder1.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals('Pune', saleOrder1.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals('Maharashtra', saleOrder1.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals('India', saleOrder1.dmpl__BillingCountry__c, 'Billing Country should match');
        System.assertEquals('411001', saleOrder1.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');
    }

    @isTest
    static void createSaleOrderWithInactiveSalesExecutive() {
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Resource__c resource2 = TestDataHelpers.getResource('Resource 2');

        try {
            dmpl__SaleOrder__c  saleOrder = SaleOrderDataHelper.createSaleOrder(
                customerAccount1.Id,
                partnerAccount1.Id,
                branch1.Id,
                null,
                null,
                false,
                resource2.Id
            );
        } catch (Exception e) {
            System.assert(
                e.getMessage().contains('FIELD_FILTER_VALIDATION_EXCEPTION'),
                'Expected FIELD_FILTER_VALIDATION_EXCEPTION, but got: ' + e.getMessage()
            );
        }
        Test.stopTest();
    }  

    @isTest
    static void saleOrderLineItemWithoutTaxGroupNewNegative() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__ContactAddress__c address1 = TestDataHelpers.getContactAddress('Address 1');
        dmpl__ContactAddress__c address2 = TestDataHelpers.getContactAddress('Address 2');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 3');

        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customer.Id,
            partner.Id,
            branch.Id,
            address1.Id,
            address2.Id,
            false,
            null
        );

        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            10,
            null
        );
        Test.stopTest();

        dmpl__SaleOrder__c saleOrder1 = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals('Customer 1', saleOrder1.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals('Ring Rd', saleOrder1.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals('Pune', saleOrder1.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals('Maharashtra', saleOrder1.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals('440001', saleOrder1.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');
        System.assertEquals('Ring Rd', saleOrder1.dmpl__ShippingStreet__c, 'Shipping Street should match');
        System.assertEquals('Pune', saleOrder1.dmpl__ShippingCity__c, 'Shipping City should match');
        System.assertEquals('Maharashtra', saleOrder1.dmpl__ShippingState__c, 'Shipping State should match');
        System.assertEquals('440001', saleOrder1.dmpl__ShippingPostalCode__c, 'Shipping Postal Code should match');
        System.assertEquals('Draft', saleOrder1.dmpl__Status__c, 'Status should be draft');

        dmpl__SaleOrderLine__c orderLine1 = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals(10, orderLine1.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(2000, orderLine1.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(null, orderLine1.dmpl__Tax1__c, 'Tax1 should be null');
        System.assertEquals(null, orderLine1.dmpl__Tax1Name__c, 'Tax1 Name should match');
        System.assertEquals(null, orderLine1.dmpl__Tax1Rate__c, 'Tax1 Rate should be null');
        System.assertEquals(null, orderLine1.dmpl__Tax1Type__c, 'Tax1 Type should match');
        System.assertEquals(null, orderLine1.dmpl__Tax2__c, 'Tax2 should be null');
        System.assertEquals(null, orderLine1.dmpl__Tax2Name__c, 'Tax2 Name should match');
        System.assertEquals(null, orderLine1.dmpl__Tax2Rate__c, 'Tax2 Rate should be null');
        System.assertEquals(null, orderLine1.dmpl__Tax2Type__c, 'Tax2 Type should match');
        System.assertEquals(20000, orderLine1.dmpl__BaseAmount__c, 'Base Amount should match');
        System.assertEquals(0, orderLine1.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0, orderLine1.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(null, orderLine1.dmpl__TaxAmount__c, 'Tax Amount should be null');
        System.assertEquals(20000, orderLine1.dmpl__GrossAmount__c, 'Gross Amount should match');

        System.assertEquals(20000, saleOrder1.dmpl__LineSubTotal__c, 'Line Subtotal should match');
        System.assertEquals(20000, saleOrder1.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should match');
        System.assertEquals(0, saleOrder1.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount should be 0');
        System.assertEquals(0, saleOrder1.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 0');
        System.assertEquals(0, saleOrder1.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount should match');
        System.assertEquals(0, saleOrder1.dmpl__TotalTaxAmount__c, 'Total Tax Amount should match');
        System.assertEquals(20000, saleOrder1.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should match');
        System.assertEquals(20000, saleOrder1.dmpl__OpenAmount__c, 'Open Amount should match');
        System.assertEquals(20000, saleOrder1.dmpl__OutstandingAmount__c, 'Outstanding Amount should match');
    }

    @isTest
    static void saleOrderLineItemWithoutTaxGroupEditNegative() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__ContactAddress__c address1 = TestDataHelpers.getContactAddress('Address 1');
        dmpl__ContactAddress__c address2 = TestDataHelpers.getContactAddress('Address 2');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 3');

        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customer.Id,
            partner.Id,
            branch.Id,
            address1.Id,
            address2.Id,
            false,
            null
        );

        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            10,
            null
        );

        dmpl__SaleOrder__c saleOrder1 = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals('Customer 1', saleOrder1.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals('Ring Rd', saleOrder1.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals('Pune', saleOrder1.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals('Maharashtra', saleOrder1.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals('440001', saleOrder1.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');
        System.assertEquals('Ring Rd', saleOrder1.dmpl__ShippingStreet__c, 'Shipping Street should match');
        System.assertEquals('Pune', saleOrder1.dmpl__ShippingCity__c, 'Shipping City should match');
        System.assertEquals('Maharashtra', saleOrder1.dmpl__ShippingState__c, 'Shipping State should match');
        System.assertEquals('440001', saleOrder1.dmpl__ShippingPostalCode__c, 'Shipping Postal Code should match');
        System.assertEquals('Draft', saleOrder1.dmpl__Status__c, 'Status should be draft');

        dmpl__SaleOrderLine__c orderLine1 = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);    
        System.assertEquals(10, orderLine1.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(2000, orderLine1.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(null, orderLine1.dmpl__Tax1__c, 'Tax1 should be null');
        System.assertEquals(null, orderLine1.dmpl__Tax1Name__c, 'Tax1 Name should match');
        System.assertEquals(null, orderLine1.dmpl__Tax1Rate__c, 'Tax1 Rate should be null');
        System.assertEquals(null, orderLine1.dmpl__Tax1Type__c, 'Tax1 Type should match');
        System.assertEquals(null, orderLine1.dmpl__Tax2__c, 'Tax2 should be null');
        System.assertEquals(null, orderLine1.dmpl__Tax2Name__c, 'Tax2 Name should match');
        System.assertEquals(null, orderLine1.dmpl__Tax2Rate__c, 'Tax2 Rate should be null');
        System.assertEquals(null, orderLine1.dmpl__Tax2Type__c, 'Tax2 Type should match');

        saleOrderLine.dmpl__Quantity__c = 12;
        update saleOrderLine;

        dmpl__SaleOrderLine__c orderLineUpdated = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals(12, orderLineUpdated.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(2000, orderLineUpdated.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(null, orderLineUpdated.dmpl__Tax1__c, 'Tax1 should be null');
        System.assertEquals(null, orderLineUpdated.dmpl__Tax1Name__c, 'Tax1 Name should match');
        System.assertEquals(null, orderLineUpdated.dmpl__Tax1Rate__c, 'Tax1 Rate should be null');
        System.assertEquals(null, orderLineUpdated.dmpl__Tax1Type__c, 'Tax1 Type should match');
        System.assertEquals(null, orderLineUpdated.dmpl__Tax2__c, 'Tax2 should be null');
        System.assertEquals(null, orderLineUpdated.dmpl__Tax2Name__c, 'Tax2 Name should match');
        System.assertEquals(null, orderLineUpdated.dmpl__Tax2Rate__c, 'Tax2 Rate should be null');
        System.assertEquals(null, orderLineUpdated.dmpl__Tax2Type__c, 'Tax2 Type should match');
        System.assertEquals(24000, orderLineUpdated.dmpl__BaseAmount__c, 'Base Amount should match');
        System.assertEquals(0, orderLineUpdated.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0, orderLineUpdated.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(null, orderLineUpdated.dmpl__TaxAmount__c, 'Tax Amount should be null');
        System.assertEquals(24000, orderLineUpdated.dmpl__GrossAmount__c, 'Gross Amount should match');

        dmpl__SaleOrder__c updatedSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals(24000.00, updatedSaleOrder.dmpl__LineSubTotal__c, 'Line SubTotal should be 24000');
        System.assertEquals(24000.00, updatedSaleOrder.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be 24000');
        System.assertEquals(0, updatedSaleOrder.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 0');
        System.assertEquals(0, updatedSaleOrder.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 0');
        System.assertEquals(0, updatedSaleOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 0');
        System.assertEquals(24000.00, updatedSaleOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be 24000');
        System.assertEquals(24000.00, updatedSaleOrder.dmpl__OpenAmount__c, 'Open Amount should be 24000');
        System.assertEquals(24000.00, updatedSaleOrder.dmpl__OutstandingAmount__c, 'Outstanding Amount should be 24000');
        Test.stopTest();
    }

    @isTest
    static void schemeApplicabilityInCaseOfIgnoreBudgetTrueNegative() {
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');

        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id,
            partnerAccount1.Id, 
            branch1.Id,
            null,
            null,
            false,
            null
        );

        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            20,
            null
        );
        Test.stopTest();

        dmpl__SaleOrder__c saleOrder1 = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals('Customer 1', saleOrder1.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals('Price List 1', saleOrder1.dmpl__PriceListId__r.Name, 'Price List should match');
        System.assertEquals('Within State', saleOrder1.dmpl__TaxSupplyType__c, 'Tax Supply Type should match');
        System.assertEquals(System.today(), saleOrder1.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', saleOrder1.dmpl__Status__c, 'Status should be draft');
        System.assertEquals('MG Road', saleOrder1.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals('Pune', saleOrder1.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals('Maharashtra', saleOrder1.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals('India', saleOrder1.dmpl__BillingCountry__c, 'Billing Country should match');
        System.assertEquals('411001', saleOrder1.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');

        dmpl__SaleOrderLine__c orderLine1 = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals('GST 28', orderLine1.dmpl__TaxGroupId__r.Name, 'Tax Group should match');
        System.assertEquals(30000, orderLine1.dmpl__BaseAmount__c, 'Base Amount should match');
        System.assertEquals(20, orderLine1.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, orderLine1.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(8400, orderLine1.dmpl__TaxAmount__c, 'Tax Amount should match');
        System.assertEquals(38400, orderLine1.dmpl__GrossAmount__c, 'Gross Amount should match');
        System.assertEquals(4200.00, orderLine1.dmpl__Tax1__c, 'Tax 1 should match');
        System.assertEquals(4200.00, orderLine1.dmpl__Tax2__c, 'Tax 2 should match');
        System.assertEquals(14, orderLine1.dmpl__Tax1Rate__c, 'Tax 1 rate should match');
        System.assertEquals(14, orderLine1.dmpl__Tax2Rate__c, 'Tax 2 rate should match');
        System.assertEquals('CGST', orderLine1.dmpl__Tax1Name__c, 'Tax 1 Name should match');
        System.assertEquals('CGST', orderLine1.dmpl__Tax1Type__c, 'Tax 1 Type should match');
        System.assertEquals('SGST', orderLine1.dmpl__Tax2Type__c, 'Tax 2 Type should match');
        System.assertEquals('SGST', orderLine1.dmpl__Tax2Name__c, 'Tax 2 Name should match');

        System.assertEquals(30000, saleOrder1.dmpl__LineSubTotal__c, 'Line Subtotal should match');
        System.assertEquals(30000, saleOrder1.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should match');
        System.assertEquals(0, saleOrder1.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount should be 0');
        System.assertEquals(0, saleOrder1.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 0');
        System.assertEquals(8400, saleOrder1.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount should match');
        System.assertEquals(8400, saleOrder1.dmpl__TotalTaxAmount__c, 'Total Tax Amount should match');
        System.assertEquals(38400, saleOrder1.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should match');
        System.assertEquals(38400, saleOrder1.dmpl__OpenAmount__c, 'Open Amount should match');
        System.assertEquals(38400, saleOrder1.dmpl__OutstandingAmount__c, 'Outstanding Amount should match');
    }

    @isTest
    static void createSaleOrderLineWithInactiveItem() {
        Account customerAccount3 = TestDataHelpers.getCustomerAccount('Customer 3');
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c inactiveItem = TestDataHelpers.getItem('Item 2');

        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount3.Id,
            partnerAccount4.Id,
            branch4.Id,
            null,
            null,
            false,
            null
        );
        try {
            dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
                saleOrder.Id,
                inactiveItem.Id,
                3,
                null
            );
            System.assert(false, 'Expected an exception to be thrown for inactive item');
        } catch (Exception e) {
            System.assertEquals(
                'Insert failed. First exception on row 0; first error: FIELD_FILTER_VALIDATION_EXCEPTION, Item needs to be active and not set to be sold only on package!: [dmpl__ItemId__c]',
                e.getMessage(),
                'Expected validation error for inactive item'
            );
        }
        Test.stopTest();

        dmpl__SaleOrder__c saleOrder1 = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals('Customer 3', saleOrder1.dmpl__AccountName__c, 'Account Name should match');
        System.assertEquals('Within State', saleOrder1.dmpl__TaxSupplyType__c, 'Tax Supply Type should match');
        System.assertEquals('Anna Salai', saleOrder1.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals('Chennai', saleOrder1.dmpl__BillingCity__c, 'Billing City should match'); 
        System.assertEquals('Tamil Nadu', saleOrder1.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals('600002', saleOrder1.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');
        System.assertEquals(System.today(), saleOrder1.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', saleOrder1.dmpl__Status__c, 'Status should be Draft');
    }

    @isTest
    static void createSaleOrderWithInLineTaxes() {
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
 
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id,
            partnerAccount1.Id,
            branch1.Id,
            null,
            null,
            true,
            null
        );
        dmpl__SaleOrder__c saleOrder2 = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            3,
            null
        );
        Test.stopTest();
 
        dmpl__SaleOrder__c saleOrder1 = SaleOrderDataHelper.getSaleOrder(saleOrder2.Id);
        System.assertEquals('Customer 1', saleOrder1.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals('Price List 1', saleOrder1.dmpl__PriceListId__r.Name, 'Price List should match');
        System.assertEquals('Within State', saleOrder1.dmpl__TaxSupplyType__c, 'Tax Supply Type should match');
        System.assertEquals(System.today(), saleOrder1.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', saleOrder1.dmpl__Status__c, 'Status should be draft');
        System.assertEquals('MG Road', saleOrder1.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals('Pune', saleOrder1.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals('Maharashtra', saleOrder1.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals('India', saleOrder1.dmpl__BillingCountry__c, 'Billing Country should match');
        System.assertEquals('411001', saleOrder1.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');
        System.assertEquals('Draft', saleOrder1.dmpl__Status__c, 'Status should match');
 
        dmpl__SaleOrderLine__c orderLine1 = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals('GST 28', orderLine1.dmpl__TaxGroupId__r.Name, 'Tax Group should match');
        System.assertEquals(3, orderLine1.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(630, orderLine1.dmpl__Tax1__c, 'Tax 1 should match');
        System.assertEquals(630, orderLine1.dmpl__Tax2__c, 'Tax 2 should match');
        System.assertEquals(14, orderLine1.dmpl__Tax1Rate__c, 'Tax 1 rate should match');
        System.assertEquals(14, orderLine1.dmpl__Tax2Rate__c, 'Tax 2 rate should match');
        System.assertEquals('CGST', orderLine1.dmpl__Tax1Name__c, 'Tax 1 Name should match');
        System.assertEquals('CGST', orderLine1.dmpl__Tax1Type__c, 'Tax 1 Type should match');
        System.assertEquals('SGST', orderLine1.dmpl__Tax2Type__c, 'Tax 2 Type should match');
        System.assertEquals('SGST', orderLine1.dmpl__Tax2Name__c, 'Tax 2 Name should match');
        System.assertEquals(1500, orderLine1.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(1260, orderLine1.dmpl__TaxAmount__c, 'Tax Amount should match');
        System.assertEquals(5760, orderLine1.dmpl__GrossAmount__c, 'Gross Amount should match');
        System.assertEquals(4500, orderLine1.dmpl__BaseAmount__c, 'Gross Amount should match');
    }
    
    @isTest
    static void createSaleOrderWithPassedDateEffectiveNegative() {
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        dmpl__PriceListRules__c priceListRules1 = TestDataHelpers.getPriceListRules(priceList1.Id);

        priceListRules1.dmpl__DateEffectiveTill__c = Date.today().addDays(-1);
        update priceListRules1;

        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id,
            partnerAccount1.Id, 
            branch1.Id,
            null,
            null,
            true,
            null
        );

        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            2,
            null
        );
        Test.stopTest();

        dmpl__SaleOrder__c saleOrder1 = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals('Customer 1', saleOrder1.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals('Price List 1', saleOrder1.dmpl__PriceListId__r.Name, 'Price List should match');
        System.assertEquals('Within State', saleOrder1.dmpl__TaxSupplyType__c, 'Tax Supply Type should match');
        System.assertEquals(System.today(), saleOrder1.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', saleOrder1.dmpl__Status__c, 'Status should be draft');
        System.assertEquals('MG Road', saleOrder1.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals('Pune', saleOrder1.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals('Maharashtra', saleOrder1.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals('India', saleOrder1.dmpl__BillingCountry__c, 'Billing Country should match');
        System.assertEquals('411001', saleOrder1.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');

        dmpl__SaleOrderLine__c orderLine1 = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals('GST 28', orderLine1.dmpl__TaxGroupId__r.Name, 'Tax Group should match');
        System.assertEquals(2, orderLine1.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(0, orderLine1.dmpl__Tax1__c, 'Tax 1 should match');
        System.assertEquals(0, orderLine1.dmpl__Tax2__c, 'Tax 2 should match');
        System.assertEquals(null, orderLine1.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(0, orderLine1.dmpl__TaxAmount__c, 'Tax Amount should match'); 
        System.assertEquals(0, orderLine1.dmpl__GrossAmount__c, 'Gross Amount should match'); 
        System.assertEquals(0, orderLine1.dmpl__BaseAmount__c, 'Gross Amount should match');
    }
    
    @isTest
    static void createSaleOrderWithSchemeNotApproved() {
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');

        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id,
            partnerAccount1.Id,
            branch1.Id,
            null,
            null,
            false,
            null
        );

        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            10,
            null
        );
        Test.stopTest();

        dmpl__SaleOrder__c saleOrder1 = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals('Customer 1', saleOrder1.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals('Price List 1', saleOrder1.dmpl__PriceListId__r.Name, 'Price List should match');
        System.assertEquals('Within State', saleOrder1.dmpl__TaxSupplyType__c, 'Tax Supply Type should match');
        System.assertEquals('MG Road', saleOrder1.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals('Pune', saleOrder1.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals('Maharashtra', saleOrder1.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals('India', saleOrder1.dmpl__BillingCountry__c, 'Billing Country should match');
        System.assertEquals('411001', saleOrder1.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');
        System.assertEquals(System.today(), saleOrder1.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', saleOrder1.dmpl__Status__c, 'Status should be Draft');

        dmpl__SaleOrderLine__c orderLine1 = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals('GST 28', orderLine1.dmpl__TaxGroupId__r.Name, 'Tax Group should match');
        System.assertEquals(10, orderLine1.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, orderLine1.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(2100, orderLine1.dmpl__Tax1__c, 'Tax1 should match');
        System.assertEquals('CGST', orderLine1.dmpl__Tax1Name__c, 'Tax1 Name should match');
        System.assertEquals(14, orderLine1.dmpl__Tax1Rate__c, 'Tax1 Rate should match');
        System.assertEquals('CGST', orderLine1.dmpl__Tax1Type__c, 'Tax1 Type should match');
        System.assertEquals(2100, orderLine1.dmpl__Tax2__c, 'Tax2 should match');
        System.assertEquals('SGST', orderLine1.dmpl__Tax2Name__c, 'Tax2 Name should match');
        System.assertEquals('SGST', orderLine1.dmpl__Tax2Type__c, 'Tax2 Type should match');
        System.assertEquals(15000, orderLine1.dmpl__BaseAmount__c, 'Base Amount should match');
        System.assertEquals(0, orderLine1.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0, orderLine1.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(4200, orderLine1.dmpl__TaxAmount__c, 'Tax Amount should match');
        System.assertEquals(19200, orderLine1.dmpl__GrossAmount__c, 'Gross Amount should match');
        System.assertEquals(null, orderLine1.dmpl__SchemeLineId__c, 'No Scheme Line should be applied');
    }

    @isTest
    static void createSaleOrderWithInLineTaxesEdit() {
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');

        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id,
            partnerAccount1.Id, 
            branch1.Id,
            null,
            null,
            true,
            null
        );
        
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            3,
            null
        );
        
        saleOrderLine.dmpl__Quantity__c = 10;
        update saleOrderLine;
        Test.stopTest();

        dmpl__SaleOrder__c saleOrder1 = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals('Customer 1', saleOrder1.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals('Price List 1', saleOrder1.dmpl__PriceListId__r.Name, 'Price List should match');
        System.assertEquals('Within State', saleOrder1.dmpl__TaxSupplyType__c, 'Tax Supply Type should match');
        System.assertEquals(System.today(), saleOrder1.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', saleOrder1.dmpl__Status__c, 'Status should be draft');

        dmpl__SaleOrderLine__c orderLine1 = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals('GST 28', orderLine1.dmpl__TaxGroupId__r.Name, 'Tax Group should match');
        System.assertEquals(10, orderLine1.dmpl__Quantity__c, 'Quantity should be updated to 10');
        System.assertEquals(1500, orderLine1.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(2100, orderLine1.dmpl__Tax1__c, 'Tax1 should match');
        System.assertEquals('CGST', orderLine1.dmpl__Tax1Name__c, 'Tax1 Name should match');
        System.assertEquals(14, orderLine1.dmpl__Tax1Rate__c, 'Tax1 Rate should match');
        System.assertEquals('CGST', orderLine1.dmpl__Tax1Type__c, 'Tax1 Type should match');
        System.assertEquals(2100, orderLine1.dmpl__Tax2__c, 'Tax2 should match');
        System.assertEquals('SGST', orderLine1.dmpl__Tax2Name__c, 'Tax2 Name should match');
        System.assertEquals(14, orderLine1.dmpl__Tax2Rate__c, 'Tax2 Rate should match');
        System.assertEquals('SGST', orderLine1.dmpl__Tax2Type__c, 'Tax2 Type should match');
        System.assertEquals(15000, orderLine1.dmpl__BaseAmount__c, 'Base Amount should match');
        System.assertEquals(0, orderLine1.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0, orderLine1.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(4200, orderLine1.dmpl__TaxAmount__c, 'Tax Amount should match');
        System.assertEquals(19200, orderLine1.dmpl__GrossAmount__c, 'Gross Amount should match');
    }

    @isTest
    static void createSaleOrderWithSkipSchemeTrue() {
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');

        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id,
            partnerAccount1.Id, 
            branch1.Id,
            null,
            null,
            true,
            null
        );

        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            3,
            null
        );
        Test.stopTest();

        dmpl__SaleOrder__c saleOrder1 = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals('Customer 1', saleOrder1.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals('Price List 1', saleOrder1.dmpl__PriceListId__r.Name, 'Price List should match');
        System.assertEquals('Within State', saleOrder1.dmpl__TaxSupplyType__c, 'Tax Supply Type should match');
        System.assertEquals(System.today(), saleOrder1.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', saleOrder1.dmpl__Status__c, 'Status should be draft');
        System.assertEquals('MG Road', saleOrder1.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals('Pune', saleOrder1.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals('Maharashtra', saleOrder1.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals('India', saleOrder1.dmpl__BillingCountry__c, 'Billing Country should match');
        System.assertEquals('411001', saleOrder1.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');
        System.assertEquals('Draft', saleOrder1.dmpl__Status__c, 'Status should match');

        dmpl__SaleOrderLine__c orderLine1 = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals('GST 28', orderLine1.dmpl__TaxGroupId__r.Name, 'Tax Group should match');
        System.assertEquals(3, orderLine1.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(630, orderLine1.dmpl__Tax1__c, 'Tax 1 should match');
        System.assertEquals(630, orderLine1.dmpl__Tax2__c, 'Tax 2 should match');
        System.assertEquals(14, orderLine1.dmpl__Tax1Rate__c, 'Tax 1 rate should match');
        System.assertEquals(14, orderLine1.dmpl__Tax2Rate__c, 'Tax 2 rate should match');
        System.assertEquals('CGST', orderLine1.dmpl__Tax1Name__c, 'Tax 1 Name should match');
        System.assertEquals('CGST', orderLine1.dmpl__Tax1Type__c, 'Tax 1 Type should match');
        System.assertEquals('SGST', orderLine1.dmpl__Tax2Type__c, 'Tax 2 Type should match');
        System.assertEquals('SGST', orderLine1.dmpl__Tax2Name__c, 'Tax 2 Name should match');
        System.assertEquals(1500, orderLine1.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(1260, orderLine1.dmpl__TaxAmount__c, 'Tax Amount should match'); 
        System.assertEquals(5760, orderLine1.dmpl__GrossAmount__c, 'Gross Amount should match'); 
        System.assertEquals(4500, orderLine1.dmpl__BaseAmount__c, 'Gross Amount should match');
        System.assertEquals(0, orderLine1.dmpl__NetSchemeDiscount__c, 'Net scheme discount should match');
        System.assertEquals(0, orderLine1.dmpl__NetDiscount__c, 'Net discount should match');
    }

    @isTest
    static void editSaleOrderWithSkipSchemeTrue() {
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');

        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id,
            partnerAccount1.Id, 
            branch1.Id,
            null,
            null,
            true,
            null
        );

        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            3,
            null
        );
        

        dmpl__SaleOrder__c saleOrder1 = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals('Customer 1', saleOrder1.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals('Price List 1', saleOrder1.dmpl__PriceListId__r.Name, 'Price List should match');
        System.assertEquals('Within State', saleOrder1.dmpl__TaxSupplyType__c, 'Tax Supply Type should match');
        System.assertEquals(System.today(), saleOrder1.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', saleOrder1.dmpl__Status__c, 'Status should be draft');
        System.assertEquals('MG Road', saleOrder1.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals('Pune', saleOrder1.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals('Maharashtra', saleOrder1.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals('India', saleOrder1.dmpl__BillingCountry__c, 'Billing Country should match');
        System.assertEquals('411001', saleOrder1.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');
        System.assertEquals('Draft', saleOrder1.dmpl__Status__c, 'Status should match');

        dmpl__SaleOrderLine__c orderLine1 = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals('GST 28', orderLine1.dmpl__TaxGroupId__r.Name, 'Tax Group should match');
        System.assertEquals(3, orderLine1.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(630, orderLine1.dmpl__Tax1__c, 'Tax 1 should match');
        System.assertEquals(630, orderLine1.dmpl__Tax2__c, 'Tax 2 should match');
        System.assertEquals(14, orderLine1.dmpl__Tax1Rate__c, 'Tax 1 rate should match');
        System.assertEquals(14, orderLine1.dmpl__Tax2Rate__c, 'Tax 2 rate should match');
        System.assertEquals('CGST', orderLine1.dmpl__Tax1Name__c, 'Tax 1 Name should match');
        System.assertEquals('CGST', orderLine1.dmpl__Tax1Type__c, 'Tax 1 Type should match');
        System.assertEquals('SGST', orderLine1.dmpl__Tax2Type__c, 'Tax 2 Type should match');
        System.assertEquals('SGST', orderLine1.dmpl__Tax2Name__c, 'Tax 2 Name should match');
        System.assertEquals(1500, orderLine1.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(1260, orderLine1.dmpl__TaxAmount__c, 'Tax Amount should match'); 
        System.assertEquals(5760, orderLine1.dmpl__GrossAmount__c, 'Gross Amount should match'); 
        System.assertEquals(4500, orderLine1.dmpl__BaseAmount__c, 'Gross Amount should match');
        System.assertEquals(0, orderLine1.dmpl__NetSchemeDiscount__c, 'Net scheme discount should match');
        System.assertEquals(0, orderLine1.dmpl__NetDiscount__c, 'Net discount should match');

        orderLine1.dmpl__Quantity__c = 6;
        update orderLine1;
        
        dmpl__SaleOrderLine__c orderLine2 = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals('GST 28', orderLine1.dmpl__TaxGroupId__r.Name, 'Tax Group should match');
        System.assertEquals(6, orderLine2.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1260, orderLine2.dmpl__Tax1__c, 'Tax 1 should match');
        System.assertEquals(1260, orderLine2.dmpl__Tax2__c, 'Tax 2 should match');
        System.assertEquals(14, orderLine2.dmpl__Tax1Rate__c, 'Tax 1 rate should match');
        System.assertEquals(14, orderLine2.dmpl__Tax2Rate__c, 'Tax 2 rate should match');
        System.assertEquals('CGST', orderLine2.dmpl__Tax1Name__c, 'Tax 1 Name should match');
        System.assertEquals('CGST', orderLine2.dmpl__Tax1Type__c, 'Tax 1 Type should match');
        System.assertEquals('SGST', orderLine2.dmpl__Tax2Type__c, 'Tax 2 Type should match');
        System.assertEquals('SGST', orderLine2.dmpl__Tax2Name__c, 'Tax 2 Name should match');
        System.assertEquals(1500, orderLine2.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(2520, orderLine2.dmpl__TaxAmount__c, 'Tax Amount should match'); 
        System.assertEquals(11520, orderLine2.dmpl__GrossAmount__c, 'Gross Amount should match'); 
        System.assertEquals(9000, orderLine2.dmpl__BaseAmount__c, 'Gross Amount should match');
        System.assertEquals(0, orderLine2.dmpl__NetSchemeDiscount__c, 'Net scheme discount should match');
        System.assertEquals(0, orderLine2.dmpl__NetDiscount__c, 'Net discount should match');
        Test.stopTest();
    }
    
    @isTest
    static void createSaleOrderWithPassedDateEffectiveNegativeEdit() {
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        dmpl__PriceListRules__c priceListRules1 = TestDataHelpers.getPriceListRules(priceList1.Id);
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');

        priceListRules1.dmpl__DateEffectiveTill__c = Date.today().addDays(-1);
        update priceListRules1;

        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id,
            partnerAccount1.Id, 
            branch1.Id,
            null,
            null,
            true,
            null
        );

        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            3,
            null
        );

        saleOrderLine.dmpl__Quantity__c = 10;
        update saleOrderLine;
        Test.stopTest();

        dmpl__SaleOrder__c saleOrder1 = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals('Customer 1', saleOrder1.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals('Price List 1', saleOrder1.dmpl__PriceListId__r.Name, 'Price List should match');
        System.assertEquals('Within State', saleOrder1.dmpl__TaxSupplyType__c, 'Tax Supply Type should match');
        System.assertEquals(System.today(), saleOrder1.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', saleOrder1.dmpl__Status__c, 'Status should be draft');
        System.assertEquals('MG Road', saleOrder1.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals('Pune', saleOrder1.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals('Maharashtra', saleOrder1.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals('India', saleOrder1.dmpl__BillingCountry__c, 'Billing Country should match');
        System.assertEquals('411001', saleOrder1.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');

        dmpl__SaleOrderLine__c orderLine1 = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals('GST 28', orderLine1.dmpl__TaxGroupId__r.Name, 'Tax Group should match');
        System.assertEquals(10, orderLine1.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(0, orderLine1.dmpl__Tax1__c, 'Tax 1 should match');
        System.assertEquals(0, orderLine1.dmpl__Tax2__c, 'Tax 2 should match');
        System.assertEquals(null, orderLine1.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(0, orderLine1.dmpl__TaxAmount__c, 'Tax Amount should match'); 
        System.assertEquals(0, orderLine1.dmpl__GrossAmount__c, 'Gross Amount should match'); 
        System.assertEquals(0, orderLine1.dmpl__BaseAmount__c, 'Gross Amount should match');
    }

    @isTest
    static void saleOrderLineWithDiscontinuedItem() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 2');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        dmpl__Item__c discontinuedItem = TestDataHelpers.getItem('Item 4'); 

        Test.startTest();        
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount.Id,
                partnerAccount.Id,
                branch.Id,
                null,
                null,
                true,
                null
        );

        dmpl__SaleOrder__c createdOrder =SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals('Customer 2', createdOrder.dmpl__AccountName__c, 'Account Name should be Customer 2');
        System.assertEquals('Within State', createdOrder.dmpl__TaxSupplyType__c, 'Tax Supply Type should be Within State');
        System.assertEquals('Park St', createdOrder.dmpl__BillingStreet__c, 'Billing Street should be Park St');
        System.assertEquals('Kolkata', createdOrder.dmpl__BillingCity__c, 'Billing City should be Kolkata');
        System.assertEquals('West Bengal', createdOrder.dmpl__BillingState__c, 'Billing State should be West Bengal');
        System.assertEquals('India', createdOrder.dmpl__BillingCountry__c, 'Billing Country should be India');
        System.assertEquals('700016', createdOrder.dmpl__BillingPostalCode__c, 'Billing Postal Code should be 700016');
        System.assertEquals('Lake Rd', createdOrder.dmpl__ShippingStreet__c, 'Shipping Street should be Lake Rd');

        dmpl__SaleOrderLine__c sol = SaleOrderDataHelper.createSaleOrderLine(
            createdOrder.id, 
            discontinuedItem.id,
            5,
            null
        );
        Test.stopTest();
       
        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(createdOrder.id);
        System.assertEquals(null, createdSOL.dmpl__TaxGroupId__r.Name, 'Tax Group should match');
        System.assertEquals(2000, createdSOL.dmpl__UnitPrice__c, 'Unit price should be 2000');
        System.assertEquals(null, createdSOL.dmpl__Tax1__c, 'Tax1 amount should be null');
        System.assertEquals(null, createdSOL.dmpl__Tax1Name__c, 'Tax1 name should be CGST');
        System.assertEquals(null, createdSOL.dmpl__Tax1Rate__c, 'Tax1 rate should be null');
        System.assertEquals(null, createdSOL.dmpl__Tax1Type__c, 'Tax1 type should be CGST');
        System.assertEquals(null, createdSOL.dmpl__Tax2__c, 'Tax2 amount should be null');
        System.assertEquals(null, createdSOL.dmpl__Tax2Name__c, 'Tax2 name should be SGST');
        System.assertEquals(null, createdSOL.dmpl__Tax2Rate__c, 'Tax2 rate should be null');
        System.assertEquals(null, createdSOL.dmpl__Tax2Type__c, 'Tax2 type should be SGST');
        System.assertEquals(10000, createdSOL.dmpl__BaseAmount__c, 'Base amount should be 10000');
        System.assertEquals(0, createdSOL.dmpl__NetSchemeDiscount__c, 'Net scheme discount should be 0');
        System.assertEquals(0, createdSOL.dmpl__NetDiscount__c, 'Net discount should be 0');
        System.assertEquals(null, createdSOL.dmpl__TaxAmount__c, 'Tax amount should be null');
        System.assertEquals(10000, createdSOL.dmpl__GrossAmount__c, 'Gross amount should be 10000');
    }

    @isTest
    static void saleOrderLineWithDiscontinuedItemEditNegative() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 2');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
        dmpl__Item__c discontinuedItem = TestDataHelpers.getItem('Item 4');

        Test.startTest();        
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount.Id,
            partnerAccount.Id,
            branch.Id,
            null,
            null,
            true,
            null
        );

        dmpl__SaleOrder__c createdOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals('Customer 2', createdOrder.dmpl__AccountName__c, 'Account Name should be Customer 2');
        System.assertEquals('Within State', createdOrder.dmpl__TaxSupplyType__c, 'Tax Supply Type should be Within State');
        System.assertEquals('Park St', createdOrder.dmpl__BillingStreet__c, 'Billing Street should be Park St');
        System.assertEquals('Kolkata', createdOrder.dmpl__BillingCity__c, 'Billing City should be Kolkata');
        System.assertEquals('West Bengal', createdOrder.dmpl__BillingState__c, 'Billing State should be West Bengal');
        System.assertEquals('India', createdOrder.dmpl__BillingCountry__c, 'Billing Country should be India');
        System.assertEquals('700016', createdOrder.dmpl__BillingPostalCode__c, 'Billing Postal Code should be 700016');
        System.assertEquals('Lake Rd', createdOrder.dmpl__ShippingStreet__c, 'Shipping Street should be Lake Rd');

        dmpl__SaleOrderLine__c sol = SaleOrderDataHelper.createSaleOrderLine(
            createdOrder.Id, 
            discontinuedItem.Id, 
            5,
            null
        );

        System.assertNotEquals(null, sol.Id, 'Sale Order Line should have been created');

        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(createdOrder.Id);
        System.assertEquals(null, createdSOL.dmpl__TaxGroupId__r.Name, 'Tax Group should match');
        System.assertEquals(2000, createdSOL.dmpl__UnitPrice__c, 'Unit price should be 2000');
        System.assertEquals(null, createdSOL.dmpl__Tax1__c, 'Tax1 amount should be null');
        System.assertEquals(null, createdSOL.dmpl__Tax1Rate__c, 'Tax1 rate should be null');
        System.assertEquals(null, createdSOL.dmpl__Tax2__c, 'Tax2 amount should be null');
        System.assertEquals(null, createdSOL.dmpl__Tax2Rate__c, 'Tax2 rate should be null');
        System.assertEquals(10000, createdSOL.dmpl__BaseAmount__c, 'Base amount should be 10000');
        System.assertEquals(0, createdSOL.dmpl__NetSchemeDiscount__c, 'Net scheme discount should be 0');
        System.assertEquals(0, createdSOL.dmpl__NetDiscount__c, 'Net discount should be 0');
        System.assertEquals(null, createdSOL.dmpl__TaxAmount__c, 'Tax amount should be null');
        System.assertEquals(10000, createdSOL.dmpl__GrossAmount__c, 'Gross amount should be 10000');

        createdSOL.dmpl__Quantity__c = 7;
        update createdSOL;

        dmpl__SaleOrderLine__c updatedSOL = SaleOrderDataHelper.getSaleOrderLine(createdOrder.Id);
        System.assertEquals(2000, updatedSOL.dmpl__UnitPrice__c, 'Unit price should be 2000');
        System.assertEquals(null, updatedSOL.dmpl__Tax1__c, 'Tax1 amount should be null');
        System.assertEquals(null, updatedSOL.dmpl__Tax1Rate__c, 'Tax1 rate should be null');
        System.assertEquals(null, updatedSOL.dmpl__Tax2__c, 'Tax2 amount should be null');
        System.assertEquals(null, updatedSOL.dmpl__Tax2Rate__c, 'Tax2 rate should be null');
        System.assertEquals(14000, updatedSOL.dmpl__BaseAmount__c, 'Base amount should be 14000');
        System.assertEquals(0, updatedSOL.dmpl__NetSchemeDiscount__c, 'Net scheme discount should be 0');
        System.assertEquals(0, updatedSOL.dmpl__NetDiscount__c, 'Net discount should be 0');
        System.assertEquals(null, updatedSOL.dmpl__TaxAmount__c, 'Tax amount should be null');
        System.assertEquals(14000, updatedSOL.dmpl__GrossAmount__c, 'Gross amount should be 14000');
        Test.stopTest();
    }

    @isTest
    static void createSaleOrderWithInactiveCustomerAccountNegative() {
        Account customerAccount7 = TestDataHelpers.getCustomerAccount('Customer 7');
        Account partnerAccount2 = TestDataHelpers.getPartnerAccount('Partner 2');
        dmpl__Branch__c branch2 = TestDataHelpers.getBranch('Branch 2');
        System.assertEquals(false, customerAccount7.dmpl__IsActive__c, 'Customer account should be inactive for this test');
    
        Test.startTest();
        try {
            dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
                customerAccount7.Id,
                partnerAccount2.Id,
                branch2.Id,
                null,
                null,
                false,
                null
            );

            dmpl__SaleOrder__c createdSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
            System.assertEquals('Customer 1', createdSaleOrder.dmpl__AccountName__c, 'Account name should match');
            System.assertEquals('9876543456', createdSaleOrder.dmpl__AccountPhone__c, 'Account phone should match');
            System.assertEquals(null, createdSaleOrder.dmpl__PriceListId__c, 'Price list should be null');
            System.assertEquals('MG Road', createdSaleOrder.dmpl__BillingStreet__c, 'Billing street should match');
            System.assertEquals('Maharashtra', createdSaleOrder.dmpl__BillingState__c, 'Billing state should match');
            System.assertEquals('411001', createdSaleOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
            System.assertEquals('Draft', createdSaleOrder.dmpl__Status__c, 'Status should be Draft');
            System.assertEquals(System.today(), createdSaleOrder.dmpl__DocumentDate__c, 'Document date should be today');
            System.assert(false, 'Expected an exception to be thrown for inactive customer account');
        } catch (Exception e) {
            String errorMsg = e.getMessage();
            Boolean correctException = errorMsg.contains('FIELD_FILTER_VALIDATION_EXCEPTION') &&
                                    errorMsg.contains('dmpl__AccountId__c');
            System.assert(correctException, 'Expected FIELD_FILTER_VALIDATION_EXCEPTION related to dmpl__AccountId__c but got: ' + errorMsg);
        }
        Test.stopTest();
    }

    @isTest
    static void saleOrderWithMultipleBillingAndShippingAddress() {
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        dmpl__ContactAddress__c billingAddress = TestDataHelpers.getContactAddress('Address 1');
        dmpl__ContactAddress__c shippingAddress = TestDataHelpers.getContactAddress('Address 3');

        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
                customerAccount1.Id,
                partnerAccount1.Id,
                branch1.Id,
                billingAddress.Id,
                shippingAddress.Id,
                false,
                null
            );
        Test.stopTest();

        dmpl__SaleOrder__c createdSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertNotEquals(null, createdSaleOrder.Id, 'Sale Order should be created');
        System.assertEquals('Draft', createdSaleOrder.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(customerAccount1.Id, createdSaleOrder.dmpl__AccountId__c);
        System.assertEquals(partnerAccount1.Id, createdSaleOrder.dmpl__PartnerAccountId__c);
        System.assertEquals(branch1.Id, createdSaleOrder.dmpl__BranchId__c);
        System.assertEquals(billingAddress.Id, createdSaleOrder.dmpl__BillingAddressId__c);
        System.assertEquals('Ring Rd', createdSaleOrder.dmpl__BillingStreet__c);
        System.assertEquals('Pune', createdSaleOrder.dmpl__BillingCity__c);
        System.assertEquals('Maharashtra', createdSaleOrder.dmpl__BillingState__c);
        System.assertEquals('440001', createdSaleOrder.dmpl__BillingPostalCode__c);
        System.assertEquals(shippingAddress.Id, createdSaleOrder.dmpl__ShippingAddressId__c);
        System.assertEquals('Lake Road', createdSaleOrder.dmpl__ShippingStreet__c);
        System.assertEquals('Kolkata', createdSaleOrder.dmpl__ShippingCity__c);
        System.assertEquals('West Bengal', createdSaleOrder.dmpl__ShippingState__c);
        System.assertEquals('440022', createdSaleOrder.dmpl__ShippingPostalCode__c);
    }

    @isTest
    static void saleOrderWithWrongPartnerAndBranchSelectionNegative() {
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account wrongPartnerAccount = TestDataHelpers.getPartnerAccount('Partner 2');
        dmpl__Branch__c Branch3 = TestDataHelpers.getBranch('Branch 3');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');

        Test.startTest();
        try {
            dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
                customerAccount1.Id,
                wrongPartnerAccount.Id,    
                Branch3.Id,            
                null,
                null,
                false,
                null
            );
            System.assert(false, 'Sale order should not be created with mismatched partner and branch.');
        } catch (Exception e) {
            String errorMsg = e.getMessage().toLowerCase();
            Boolean correctExceptionThrown = errorMsg.contains('partner account is wrong') ||
                                            errorMsg.contains('field_custom_validation_exception') ||
                                            errorMsg.contains('partner') ||
                                            errorMsg.contains('branch');
            System.assert(correctExceptionThrown,
                'Expected validation failure due to mismatched Partner and Branch, but got: ' + e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void saleOrderWithWrongBranchSelectionNegative() {
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch2 = TestDataHelpers.getBranch('Branch 2');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        Test.startTest();
        try {
            dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
                customerAccount1.Id,
                partnerAccount1.Id,
                branch2.Id,
                null,
                null,
                false,
                null
            );
            System.assert(false, 'Sale order should not be created with a branch that does not belong to the same partner.');
        } catch (Exception e) {
            String errorMsg = e.getMessage().toLowerCase();
            Boolean correctExceptionThrown = errorMsg.contains('field_custom_validation_exception') &&
                                            errorMsg.contains('branch');
            System.assert(correctExceptionThrown,
                'Expected FIELD_CUSTOM_VALIDATION_EXCEPTION related to Branch but got: ' + e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void saleOrderLineWithoutSchemesNewPositive(){
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('item 1');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id,
            partnerAccount1.Id,
            branch1.Id,
            null,
            null,
            false,
            null
        );

        dmpl__SaleOrderLine__c sol = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.id, 
            item1.id,
            3,
            null
        );

        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(saleOrder.id);
        Test.stopTest();

        System.assertEquals(1500, createdSOL.dmpl__UnitPrice__c, 'Unit price should be 1500');
        System.assertEquals(630, createdSOL.dmpl__Tax1__c, 'Tax1 amount should be 630');
        System.assertEquals(14, createdSOL.dmpl__Tax1Rate__c, 'Tax1 rate should be 14%');
        System.assertEquals(4500, createdSOL.dmpl__BaseAmount__c, 'Base amount should be 4500');
        System.assertEquals(0, createdSOL.dmpl__NetSchemeDiscount__c, 'Net scheme discount should be 0');
        System.assertEquals(0, createdSOL.dmpl__NetDiscount__c, 'Net discount should be 0');
        System.assertEquals(1260, createdSOL.dmpl__TaxAmount__c, 'Tax amount should be 1260');
        System.assertEquals(5760, createdSOL.dmpl__GrossAmount__c, 'Gross amount should be 5760');

        dmpl__SaleOrder__c createdSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals('Customer 1', createdSaleOrder.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals(priceList1.Id, createdSaleOrder.dmpl__PriceListId__c, 'Price list should match');
        System.assertEquals('Within State', createdSaleOrder.dmpl__TaxSupplyType__c, 'Tax supply type should match');
        System.assertEquals('MG Road', createdSaleOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals('Pune', createdSaleOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals('Maharashtra', createdSaleOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals('India', createdSaleOrder.dmpl__BillingCountry__c, 'Billing country should match');
        System.assertEquals('411001', createdSaleOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals('Draft', createdSaleOrder.dmpl__Status__c, 'Status should be Draft');
    }

    @isTest()
    static void saleOrderWithItemLevelTaxChangesPositive(){
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('item 1');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');

        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id,
            partnerAccount1.Id,
            branch1.Id,
            null,
            null,
            false,
            null
        );

        dmpl__SaleOrderLine__c createdSaleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.id, 
            item1.id,
            3,
            null
        );
        Test.stopTest();

        dmpl__SaleOrder__c createdSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals('Customer 1', createdSaleOrder.dmpl__AccountName__c, 'Account name should be Customer 1');
        System.assertEquals(priceList1.Id, createdSaleOrder.dmpl__PriceListId__c, 'Price list should be Price List 1');
        System.assertEquals('Within State', createdSaleOrder.dmpl__TaxSupplyType__c, 'Tax supply type should be Within State');
        System.assertEquals('MG Road', createdSaleOrder.dmpl__BillingStreet__c, 'Billing street should be MG Road');
        System.assertEquals('Pune', createdSaleOrder.dmpl__BillingCity__c, 'Billing city should be Pune');
        System.assertEquals('Maharashtra', createdSaleOrder.dmpl__BillingState__c, 'Billing state should be Maharashtra');
        System.assertEquals('India', createdSaleOrder.dmpl__BillingCountry__c, 'Billing country should be India');
        System.assertEquals('411001', createdSaleOrder.dmpl__BillingPostalCode__c, 'Billing postal code should be 411001');
        System.assertEquals('Ring Rd', createdSaleOrder.dmpl__ShippingStreet__c, 'Shipping street should be Ring Rd');
        System.assertEquals('Nagpur', createdSaleOrder.dmpl__ShippingCity__c, 'Shipping city should be Nagpur');
        
        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(createdSaleOrder.id);
        System.assertEquals(1500, createdSOL.dmpl__UnitPrice__c, 'Price should be 1500');
        System.assertEquals(630, createdSOL.dmpl__Tax1__c, 'Tax1 amount should be 630');
        System.assertEquals(14, createdSOL.dmpl__Tax1Rate__c, 'Tax1 rate should be 14%');
        System.assertEquals(4500, createdSOL.dmpl__BaseAmount__c, 'Base amount should be 4500');
        System.assertEquals(1260, createdSOL.dmpl__TaxAmount__c, 'Tax amount should be 1260');
        System.assertEquals(5760, createdSOL.dmpl__GrossAmount__c, 'Gross amount should be 5760');
    }

    @isTest
    static void saleOrderWithIgnoreBudgetEditNegative() {
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');

        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id,
            partnerAccount1.Id, 
            branch1.Id,
            null,
            null,
            false,
            null
        );

        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            14,
            null
        );
        Test.stopTest();

        dmpl__SaleOrder__c saleOrder1 = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals('Customer 1', saleOrder1.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals(priceList1.Id, saleOrder1.dmpl__PriceListId__c, 'Price list should match');
        System.assertEquals('Within State', saleOrder1.dmpl__TaxSupplyType__c, 'Tax Supply Type should match');
        System.assertEquals('MG Road', saleOrder1.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals('Pune', saleOrder1.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals('Maharashtra', saleOrder1.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals('India', saleOrder1.dmpl__BillingCountry__c, 'Billing Country should match');
        System.assertEquals('411001', saleOrder1.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');
        System.assertEquals(System.today(), saleOrder1.dmpl__DocumentDate__c, 'Document Date should match');

        dmpl__SaleOrderLine__c orderLine1 = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals(1500, orderLine1.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(2940, orderLine1.dmpl__Tax1__c, 'Tax1 amount should match');
        System.assertEquals(21000, orderLine1.dmpl__BaseAmount__c, 'Base Amount should match');
        System.assertEquals(0, orderLine1.dmpl__NetSchemeDiscount__c, 'Net scheme discount should match');
        System.assertEquals(0, orderLine1.dmpl__NetDiscount__c, 'Net discount should match');
        System.assertEquals(5880, orderLine1.dmpl__TaxAmount__c, 'Tax Amount should match');
        System.assertEquals(26880, orderLine1.dmpl__GrossAmount__c, 'Gross Amount should match');
        System.assertEquals(null, orderLine1.dmpl__SchemeLineId__c, 'Scheme Line should be null');

        System.assertEquals(21000, saleOrder1.dmpl__LineSubTotal__c, 'Line subtotal should match');
        System.assertEquals(21000, saleOrder1.dmpl__TotalLineBaseAmount__c, 'Total base amount should match');
        System.assertEquals(0, saleOrder1.dmpl__TotalSchemeDiscountAmount__c, 'Total scheme discount should match');
        System.assertEquals(0, saleOrder1.dmpl__TotalDiscountAmount__c, 'Total discount should match');
        System.assertEquals(5880, saleOrder1.dmpl__TotalLineTaxAmount__c, 'Total tax amount should match');
        System.assertEquals(5880, saleOrder1.dmpl__TotalTaxAmount__c, 'Total tax amount should match');
        System.assertEquals(26880, saleOrder1.dmpl__TotalLineGrossAmount__c, 'Total gross should match');
        System.assertEquals(26880, saleOrder1.dmpl__OpenAmount__c, 'Open amount should match');
        System.assertEquals(26880, saleOrder1.dmpl__OutstandingAmount__c, 'Outstanding amount should match');
    }

    @isTest
    static void saleOrderWithTaxAppObjectModelObjectTaxesNewPositive(){
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__Tax__c tax = TestDataHelpers.getTax('CGST');

        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id,
            partnerAccount1.Id, 
            branch1.Id,
            null,
            null,
            false,
            null
        );

        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            3,
            null
        );
        dmpl__SaleOrder__c createdSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        Test.stopTest();

        System.assertEquals('Customer 1', createdSaleOrder.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals('Price List 1', createdSaleOrder.dmpl__PriceListId__r.Name, 'Price list should match');
        System.assertEquals('Within State', createdSaleOrder.dmpl__TaxSupplyType__c, 'Tax supply type should match');
        System.assertEquals('MG Road', createdSaleOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals('Pune', createdSaleOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals('Maharashtra', createdSaleOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals('India', createdSaleOrder.dmpl__BillingCountry__c, 'Billing country should match');
        System.assertEquals('411001', createdSaleOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(System.today(), createdSaleOrder.dmpl__DocumentDate__c, 'Document date should be today');
        System.assertEquals('Draft', createdSaleOrder.dmpl__Status__c, 'Status should be Draft');

        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(createdSaleOrder.Id);
        System.assertEquals(1500, createdSOL.dmpl__UnitPrice__c, 'Price should be 1500');
        System.assertEquals('GST 28', createdSOL.dmpl__TaxGroupId__r.Name, 'Tax group should match');
        System.assertEquals(630, createdSOL.dmpl__Tax1__c, 'Tax1 amount should be 630');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Name__c, 'Tax1 name should be CGST');
        System.assertEquals(14, createdSOL.dmpl__Tax1Rate__c, 'Tax1 rate should be 14%');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Type__c, 'Tax1 type should be CGST');
        System.assertEquals(630, createdSOL.dmpl__Tax2__c, 'Tax2 amount should be 630');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Name__c, 'Tax2 name should be SGST');
        System.assertEquals(14, createdSOL.dmpl__Tax2Rate__c, 'Tax2 rate should be 14%');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Type__c, 'Tax2 type should be SGST');
        System.assertEquals(4500, createdSOL.dmpl__BaseAmount__c, 'Base amount should be 4500');
        System.assertEquals(1260, createdSOL.dmpl__TaxAmount__c, 'Tax amount should be 1260');
        System.assertEquals(5760, createdSOL.dmpl__GrossAmount__c, 'Gross amount should be 5760');

        dmpl__SaleOrderTax__c saleOrderTax = SaleOrderDataHelper.getSaleOrderTaxes(createdSaleOrder.id);
        System.assertEquals(tax.Id, saleOrderTax.dmpl__TaxId__c, 'Tax ID should be CGST');
        System.assertEquals(630, saleOrderTax.dmpl__TaxAmount__c, 'Tax amount should be 630');
        System.assertEquals(4500, saleOrderTax.dmpl__TaxOnAmount__c, 'Tax on amount should be 4500');
        System.assertEquals('GST 28', saleOrderTax.dmpl__TaxGroupId__r.Name, 'Tax group should be GST 28%');
        System.assertEquals(14, saleOrderTax.dmpl__TaxRate__c, 'Tax rate should be 14');
        System.assertEquals(saleOrder.Id, saleOrderTax.dmpl__SaleOrderId__c, 'Sale Order ID should match');
        System.assertEquals(saleOrderLine.Id, saleOrderTax.dmpl__SaleOrderLineId__c, 'Sale Order Line ID should match');

        dmpl__SaleOrder__c createdSaleOrder2 = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals(4500, createdSaleOrder2.dmpl__LineSubTotal__c, 'Line subtotal should be 4500');
        System.assertEquals(4500, createdSaleOrder2.dmpl__TotalLineBaseAmount__c, 'Total base amount should be 4500');
        System.assertEquals(0, createdSaleOrder2.dmpl__TotalSchemeDiscountAmount__c, 'Total scheme discount should be 0');
        System.assertEquals(0, createdSaleOrder2.dmpl__TotalDiscountAmount__c, 'Total discount should be 0');
        System.assertEquals(1260, createdSaleOrder2.dmpl__TotalLineTaxAmount__c, 'Total line tax amount should be 1260');
        System.assertEquals(1260, createdSaleOrder2.dmpl__TotalTaxAmount__c, 'Total tax amount should be 1260');
        System.assertEquals(5760, createdSaleOrder2.dmpl__TotalLineGrossAmount__c, 'Total gross amount should be 5760');
        System.assertEquals(5760, createdSaleOrder2.dmpl__OpenAmount__c, 'Open amount should be 5760');
        System.assertEquals(5760, createdSaleOrder2.dmpl__OutstandingAmount__c, 'Outstanding amount should be 5760');
    }


    @isTest
    static void saleOrderWithTaxAppObjectModelObjectTaxesEditPositive(){
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__Tax__c tax = TestDataHelpers.getTax('CGST');

        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id,
            partnerAccount1.Id, 
            branch1.Id,
            null,
            null,
            false,
            null
        );

        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            3,
            null
        );
        saleOrderLine.dmpl__Quantity__c =2;
        update saleOrderLine;
        dmpl__SaleOrder__c createdSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        Test.stopTest();
        
        System.assertEquals('Customer 1', createdSaleOrder.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals('Price List 1', createdSaleOrder.dmpl__PriceListId__r.Name, 'Price list should match');
        System.assertEquals('Within State', createdSaleOrder.dmpl__TaxSupplyType__c, 'Tax supply type should match');
        System.assertEquals('MG Road', createdSaleOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals('Pune', createdSaleOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals('Maharashtra', createdSaleOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals('India', createdSaleOrder.dmpl__BillingCountry__c, 'Billing country should match');
        System.assertEquals('411001', createdSaleOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(System.today(), createdSaleOrder.dmpl__DocumentDate__c, 'Document date should be today');
        System.assertEquals('Draft', createdSaleOrder.dmpl__Status__c, 'Status should be Draft');

        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(createdSaleOrder.Id);        
        System.assertEquals(1500, createdSOL.dmpl__UnitPrice__c, 'Price should be 1500');
        System.assertEquals('GST 28', createdSOL.dmpl__TaxGroupId__r.Name, 'Tax group should match');
        System.assertEquals(420, createdSOL.dmpl__Tax1__c, 'Tax1 amount should be 630');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Name__c, 'Tax1 name should be CGST');
        System.assertEquals(14, createdSOL.dmpl__Tax1Rate__c, 'Tax1 rate should be 14%');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Type__c, 'Tax1 type should be CGST');
        System.assertEquals(420, createdSOL.dmpl__Tax2__c, 'Tax2 amount should be 420');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Name__c, 'Tax2 name should be SGST');
        System.assertEquals(14, createdSOL.dmpl__Tax2Rate__c, 'Tax2 rate should be 14%');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Type__c, 'Tax2 type should be SGST');
        System.assertEquals(3000, createdSOL.dmpl__BaseAmount__c, 'Base amount should be 3000');
        System.assertEquals(840, createdSOL.dmpl__TaxAmount__c, 'Tax amount should be 840');
        System.assertEquals(3840, createdSOL.dmpl__GrossAmount__c, 'Gross amount should be 3840');

        dmpl__SaleOrderTax__c saleOrderTax = SaleOrderDataHelper.getSaleOrderTaxes(createdSaleOrder.id);

        System.assertEquals(tax.Id, saleOrderTax.dmpl__TaxId__c, 'Tax ID should be CGST');
        System.assertEquals(420, saleOrderTax.dmpl__TaxAmount__c, 'Tax amount should be 420');
        System.assertEquals(3000, saleOrderTax.dmpl__TaxOnAmount__c, 'Tax on amount should be 3000');
        System.assertEquals('GST 28', saleOrderTax.dmpl__TaxGroupId__r.Name, 'Tax group should be GST 28%');
        System.assertEquals(14, saleOrderTax.dmpl__TaxRate__c, 'Tax rate should be 14');
        System.assertEquals(saleOrder.Id, saleOrderTax.dmpl__SaleOrderId__c, 'Sale Order ID should match');
        System.assertEquals(saleOrderLine.Id, saleOrderTax.dmpl__SaleOrderLineId__c, 'Sale Order Line ID should match');

        dmpl__SaleOrder__c createdSaleOrder2 = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);

        System.assertEquals(3000, createdSaleOrder2.dmpl__LineSubTotal__c, 'Line subtotal should be 3000');
        System.assertEquals(3000, createdSaleOrder2.dmpl__TotalLineBaseAmount__c, 'Total base amount should be 3000');
        System.assertEquals(0, createdSaleOrder2.dmpl__TotalSchemeDiscountAmount__c, 'Total scheme discount should be 0');
        System.assertEquals(0, createdSaleOrder2.dmpl__TotalDiscountAmount__c, 'Total discount should be 0');
        System.assertEquals(840, createdSaleOrder2.dmpl__TotalLineTaxAmount__c, 'Total line tax amount should be 840');
        System.assertEquals(840, createdSaleOrder2.dmpl__TotalTaxAmount__c, 'Total tax amount should be 840');
        System.assertEquals(3840, createdSaleOrder2.dmpl__TotalLineGrossAmount__c, 'Total gross amount should be 3840');
        System.assertEquals(3840, createdSaleOrder2.dmpl__OpenAmount__c, 'Open amount should be 3840');
        System.assertEquals(3840, createdSaleOrder2.dmpl__OutstandingAmount__c, 'Outstanding amount should be 3840');
    }

    @isTest
    static void saleOrderWithSchemeNotApprovedEdit() {
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');

        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id,
            partnerAccount1.Id,
            branch1.Id,
            null,
            null,
            false,
            null
        );

        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            10,
            null
        );
        
        dmpl__SaleOrder__c saleOrder1 = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals('Customer 1', saleOrder1.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals('Price List 1', saleOrder1.dmpl__PriceListId__r.Name, 'Price List should match');
        System.assertEquals('Within State', saleOrder1.dmpl__TaxSupplyType__c, 'Tax Supply Type should match');
        System.assertEquals('MG Road', saleOrder1.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals('Pune', saleOrder1.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals('Maharashtra', saleOrder1.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals('India', saleOrder1.dmpl__BillingCountry__c, 'Billing Country should match');
        System.assertEquals('411001', saleOrder1.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');
        System.assertEquals(System.today(), saleOrder1.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', saleOrder1.dmpl__Status__c, 'Status should be Draft');
        
        dmpl__SaleOrderLine__c orderLine1 = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals('GST 28', orderLine1.dmpl__TaxGroupId__r.Name, 'Tax Group should match');
        System.assertEquals(10, orderLine1.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, orderLine1.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(2100, orderLine1.dmpl__Tax1__c, 'Tax1 should match');
        System.assertEquals('CGST', orderLine1.dmpl__Tax1Name__c, 'Tax1 Name should match');
        System.assertEquals(14, orderLine1.dmpl__Tax1Rate__c, 'Tax1 Rate should match');
        System.assertEquals('CGST', orderLine1.dmpl__Tax1Type__c, 'Tax1 Type should match');
        System.assertEquals(2100, orderLine1.dmpl__Tax2__c, 'Tax2 should match');
        System.assertEquals('SGST', orderLine1.dmpl__Tax2Name__c, 'Tax2 Name should match');
        System.assertEquals('SGST', orderLine1.dmpl__Tax2Type__c, 'Tax2 Type should match');
        System.assertEquals(15000, orderLine1.dmpl__BaseAmount__c, 'Base Amount should match');
        System.assertEquals(0, orderLine1.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0, orderLine1.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(4200, orderLine1.dmpl__TaxAmount__c, 'Tax Amount should match');
        System.assertEquals(19200, orderLine1.dmpl__GrossAmount__c, 'Gross Amount should match');
        System.assertEquals(null, orderLine1.dmpl__SchemeLineId__c, 'No Scheme Line should be applied');
        
        orderLine1.dmpl__Quantity__c = 5;
        update orderLine1;
        
        orderLine1 = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals(1500, orderLine1.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(1050, orderLine1.dmpl__Tax1__c, 'Tax1 should match');
        System.assertEquals('CGST', orderLine1.dmpl__Tax1Name__c, 'Tax1 Name should match');
        System.assertEquals(14, orderLine1.dmpl__Tax1Rate__c, 'Tax1 Rate should match');
        System.assertEquals('CGST', orderLine1.dmpl__Tax1Type__c, 'Tax1 Type should match');
        System.assertEquals(1050, orderLine1.dmpl__Tax2__c, 'Tax2 should match');
        System.assertEquals('SGST', orderLine1.dmpl__Tax2Name__c, 'Tax2 Name should match');
        System.assertEquals(14, orderLine1.dmpl__Tax2Rate__c, 'Tax2 Rate should match');
        System.assertEquals('SGST', orderLine1.dmpl__Tax2Type__c, 'Tax2 Type should match');
        System.assertEquals(7500, orderLine1.dmpl__BaseAmount__c, 'Base Amount should match');
        System.assertEquals(0, orderLine1.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0, orderLine1.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(2100, orderLine1.dmpl__TaxAmount__c, 'Tax Amount should match');
        System.assertEquals(9600, orderLine1.dmpl__GrossAmount__c, 'Gross Amount should match');
        System.assertEquals(null, orderLine1.dmpl__SchemeLineId__c, 'No Scheme Line should be applied');
        
        dmpl__SaleOrder__c saleOrder3 = SaleOrderDataHelper.getSaleOrder(saleOrder1.Id);
        System.assertEquals(7500, saleOrder3.dmpl__LineSubTotal__c, 'Line Sub Total should match');
        System.assertEquals(7500, saleOrder3.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should match');
        System.assertEquals(0, saleOrder3.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 0');
        System.assertEquals(0, saleOrder3.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 0');
        System.assertEquals(2100, saleOrder3.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount should match');
        System.assertEquals(2100, saleOrder3.dmpl__TotalTaxAmount__c, 'Total Tax Amount should match');
        System.assertEquals(9600, saleOrder3.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should match');
        System.assertEquals(9600, saleOrder3.dmpl__OpenAmount__c, 'Open Amount should match');
        System.assertEquals(9600, saleOrder3.dmpl__OutstandingAmount__c, 'Outstanding Amount should match');
        Test.stopTest();
    }

    @isTest
    static void saleOrderLineWithoutSchemesEditPositive(){
       Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('item 1');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
       
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id,
            partnerAccount1.Id,
            branch1.Id,
            null,
            null,
            false,
            null
        );

        dmpl__SaleOrderLine__c sol = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.id, 
            item1.id,
            3,
            null
        );

        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(saleOrder.id);
        System.assertEquals(1500, createdSOL.dmpl__UnitPrice__c, 'Unit price should be 1500');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Name__c, 'tax1 name should be cgst');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Name__c, 'tax2 name should be sgst');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Type__c, 'Tax1 type should be cgst');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Type__c, 'Tax1 type should be sgst');
        System.assertEquals(630, createdSOL.dmpl__Tax1__c, 'Tax1 amount should be 630');
        System.assertEquals(14, createdSOL.dmpl__Tax1Rate__c, 'Tax1 rate should be 14%');
        System.assertEquals(630, createdSOL.dmpl__Tax2__c, 'Tax1 amount should be 630');
        System.assertEquals(14, createdSOL.dmpl__Tax2Rate__c, 'Tax1 rate should be 14%');
        System.assertEquals(4500, createdSOL.dmpl__BaseAmount__c, 'Base amount should be 4500');
        System.assertEquals(0, createdSOL.dmpl__NetSchemeDiscount__c, 'Net scheme discount should be 0');
        System.assertEquals(0, createdSOL.dmpl__NetDiscount__c, 'Net discount should be 0');
        System.assertEquals(1260, createdSOL.dmpl__TaxAmount__c, 'Tax amount should be 1260');
        System.assertEquals(5760, createdSOL.dmpl__GrossAmount__c, 'Gross amount should be 5760');

        dmpl__SaleOrder__c createdSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals('Customer 1', createdSaleOrder.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals(priceList1.Id, createdSaleOrder.dmpl__PriceListId__c, 'Price list should match');
        System.assertEquals('Within State', createdSaleOrder.dmpl__TaxSupplyType__c, 'Tax supply type should match');
        System.assertEquals('MG Road', createdSaleOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals('Pune', createdSaleOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals('Maharashtra', createdSaleOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals('India', createdSaleOrder.dmpl__BillingCountry__c, 'Billing country should match');
        System.assertEquals('411001', createdSaleOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals('Draft', createdSaleOrder.dmpl__Status__c, 'Status should be Draft');
        
        createdSOL.dmpl__Quantity__c = 6;
        update createdSOL;
        dmpl__SaleOrderLine__c updatedSOL = SaleOrderDataHelper.getSaleOrderLine(createdSaleOrder.Id);
        
        System.assertEquals(6, updatedSOL.dmpl__Quantity__c, 'Unit price should be 6');
        System.assertEquals(1500, updatedSOL.dmpl__UnitPrice__c, 'Unit price should be 1500');
        System.assertEquals(1260, updatedSOL.dmpl__Tax1__c, 'Tax1 should be 1260');
        System.assertEquals(14, updatedSOL.dmpl__Tax1Rate__c, 'Tax1 rate should be 14%');
        System.assertEquals(9000, updatedSOL.dmpl__BaseAmount__c, 'Base amount should be 9000');
        System.assertEquals(0, updatedSOL.dmpl__NetSchemeDiscount__c, 'Net scheme discount should be 0');
        System.assertEquals(0, updatedSOL.dmpl__NetDiscount__c, 'Net discount should be 0');
        System.assertEquals(2520, updatedSOL.dmpl__TaxAmount__c, 'Tax amount should be 2520');
        System.assertEquals(11520, updatedSOL.dmpl__GrossAmount__c, 'Gross amount should be 11520');
        System.assertEquals('CGST', updatedSOL.dmpl__Tax1Name__c, 'tax1 name should be cgst');
        System.assertEquals('SGST', updatedSOL.dmpl__Tax2Name__c, 'tax2 name should be sgst');
        System.assertEquals('CGST', updatedSOL.dmpl__Tax1Type__c, 'Tax1 type should be cgst');
        System.assertEquals('SGST', updatedSOL.dmpl__Tax2Type__c, 'Tax1 type should be sgst');
        
        dmpl__SaleOrder__c updatedSO = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals(9000, updatedSO.dmpl__LineSubTotal__c, 'Line subtotal should be 9000');
        System.assertEquals(9000, updatedSO.dmpl__TotalLineBaseAmount__c, 'Total base amount should be 9000');
        System.assertEquals(0, updatedSO.dmpl__TotalSchemeDiscountAmount__c, 'Total scheme discount should be 0');
        System.assertEquals(0, updatedSO.dmpl__TotalDiscountAmount__c, 'Total discount should be 0');
        System.assertEquals(2520, updatedSO.dmpl__TotalLineTaxAmount__c, 'Total tax amount should be 2520');
        System.assertEquals(2520, updatedSO.dmpl__TotalTaxAmount__c, 'Total tax amount should be 2520');
        System.assertEquals(11520, updatedSO.dmpl__TotalLineGrossAmount__c, 'Total gross should be 11520');
        System.assertEquals(11520, updatedSO.dmpl__OpenAmount__c, 'Open amount should be 11520');
        System.assertEquals(11520, updatedSO.dmpl__OutstandingAmount__c, 'Outstanding amount should be 11520');
        Test.stopTest();
    }

    @isTest
    static void saleOrderwithInActivePriceListNegative(){
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount6 = TestDataHelpers.getPartnerAccount('Partner 6');
        dmpl__Branch__c branch6 = TestDataHelpers.getBranch('Branch 6');
        dmpl__PriceList__c priceList5 = TestDataHelpers.getPriceList('Price List 5');
        
        Test.startTest();

    	Boolean exceptionCaught = false;
    	String exceptionMessage = '';
        
        try {
            dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
                customerAccount1.Id,
                partnerAccount6.Id,
                branch6.Id,
                null,
                null,
                false,
                null
            );
            System.assertNotEquals(priceList5.Id, saleOrder.dmpl__PriceListId__c, 'Price List 5 should be used for the order');
        } catch (Exception e) {
            exceptionCaught = true;
        	exceptionMessage = e.getMessage();
        	System.assert(exceptionMessage.containsIgnoreCase('inactive') && 
                     exceptionMessage.containsIgnoreCase('price') && 
                     exceptionMessage.containsIgnoreCase('list'), 
                     'Exception message should contain inactive price list validation: ' + exceptionMessage);
        }
        Test.stopTest();
    }

    @isTest
    static void saleOrderSchemeApplicabilityBasedOnUnavailibilityOfBudgetNewPositive(){
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('item 1');
        
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id,
            partnerAccount1.Id,
            branch1.Id,
            null, 
            null,
            false,
            null
        );

        dmpl__SaleOrderLine__c sol = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id, 
            item1.Id, 
            20,
            null
        );

        dmpl__SaleOrder__c createdSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals('Customer 1', createdSaleOrder.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals(priceList1.Id, createdSaleOrder.dmpl__PriceListId__c, 'Price list should match');
        System.assertEquals('Within State', createdSaleOrder.dmpl__TaxSupplyType__c, 'Tax Supply Type should match');
        System.assertEquals('MG Road', createdSaleOrder.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals('Pune', createdSaleOrder.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals('Maharashtra', createdSaleOrder.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals('India', createdSaleOrder.dmpl__BillingCountry__c, 'Billing Country should match');
        System.assertEquals('411001', createdSaleOrder.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');
        System.assertEquals(System.today(), createdSaleOrder.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', createdSaleOrder.dmpl__Status__c, 'Status should be Draft');
        Test.stopTest();
    }
    
    @isTest
    static void saleOrsderWithDiscountGroup() {
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__PriceList__c priceList3 = TestDataHelpers.getPriceList('Price List 3');
        dmpl__Item__c item6 = TestDataHelpers.getItem('Item 6');
        dmpl__DiscountGroup__c discountGroup1=DiscountDataHelper.getDiscountGroup('Discount 1');

        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id,
            partnerAccount4.Id,
            branch4.Id,
            null,
            null,
            false,
            null
        );

        dmpl__SaleOrderLine__c sol = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id, 
            item6.Id, 
            20,
            null
        );

        dmpl__SaleOrder__c createdSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals('Customer 1', createdSaleOrder.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals(priceList3.Id, createdSaleOrder.dmpl__PriceListId__c, 'Price list should match');
        System.assertEquals('MG Road', createdSaleOrder.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals('Pune', createdSaleOrder.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals('Maharashtra', createdSaleOrder.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals('411001', createdSaleOrder.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');
        System.assertEquals('Ring Rd', createdSaleOrder.dmpl__ShippingStreet__c, 'Shipping Street should match');
        System.assertEquals('Nagpur', createdSaleOrder.dmpl__ShippingCity__c, 'Shipping City should match');
        System.assertEquals('Maharashtra', createdSaleOrder.dmpl__ShippingState__c, 'Shipping State should match');
        System.assertEquals('440001', createdSaleOrder.dmpl__ShippingPostalCode__c, 'Shipping Postal Code should match');
        System.assertEquals('Draft', createdSaleOrder.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(discountGroup1.Id, createdSaleOrder.dmpl__DiscountGroupId__c, 'Discount Group should match');

        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals(2000, saleOrderLine.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(38400, saleOrderLine.dmpl__Amount__c, 'Amount should match');
        System.assertEquals(2304, saleOrderLine.dmpl__Tax1__c, 'Tax1 should match');
        System.assertEquals('CGST', saleOrderLine.dmpl__Tax1Name__c, 'Tax1 Name should match');
        System.assertEquals(6, saleOrderLine.dmpl__Tax1Rate__c, 'Tax1 Rate should match');
        System.assertEquals(2304, saleOrderLine.dmpl__Tax2__c, 'Tax2 should match');
        System.assertEquals('SGST', saleOrderLine.dmpl__Tax2Name__c, 'Tax2 Name should match');
        System.assertEquals(6, saleOrderLine.dmpl__Tax2Rate__c, 'Tax2 Rate should match');
        System.assertEquals(40000, saleOrderLine.dmpl__BaseAmount__c, 'Base Amount should match');
        System.assertEquals(0, saleOrderLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should match');
        System.assertEquals(1600, saleOrderLine.dmpl__NetDiscount__c, 'Net Discount should match');
        System.assertEquals(4608, saleOrderLine.dmpl__TaxAmount__c, 'Tax Amount should match');
        System.assertEquals(43008, saleOrderLine.dmpl__GrossAmount__c, 'Gross Amount should match');

        dmpl__SaleOrder__c createdSaleOrder2 = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals(40000, createdSaleOrder2.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should match');
        System.assertEquals(0, createdSaleOrder2.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should match');
        System.assertEquals(1600, createdSaleOrder2.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should match');
        System.assertEquals(4608, createdSaleOrder2.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount should match');
        System.assertEquals(4608, createdSaleOrder2.dmpl__TotalTaxAmount__c, 'Total Tax Amount should match');
        System.assertEquals(43008, createdSaleOrder2.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should match');
        System.assertEquals(43008, createdSaleOrder2.dmpl__OpenAmount__c, 'Open Amount should match');
        System.assertEquals(43008, createdSaleOrder2.dmpl__OutstandingAmount__c, 'Outstanding Amount should match');
        Test.stopTest();
    }

    @isTest
    static void schemeApplicabilityInCaseSchemeDiscountIsMoreThanAvailableBudget() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 5');

        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customer.Id,
            partner.Id,
            branch.Id,
            null,
            null,
            false,
            null
        );

        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            1100, 
            null
        );
        Test.stopTest();

        dmpl__SaleOrder__c saleOrder1 = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals('Customer 1', saleOrder1.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals('MG Road', saleOrder1.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals('Pune', saleOrder1.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals('Maharashtra', saleOrder1.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals('411001', saleOrder1.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');
        System.assertEquals('Draft', saleOrder1.dmpl__Status__c, 'Status should be draft');

        dmpl__SaleOrderLine__c orderLine1 = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals(1100, orderLine1.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1000, orderLine1.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(66000, orderLine1.dmpl__Tax1__c, 'Tax1 should match');
        System.assertEquals('CGST', orderLine1.dmpl__Tax1Name__c, 'Tax1 Name should match');
        System.assertEquals(6, orderLine1.dmpl__Tax1Rate__c, 'Tax1 Rate should match');
        System.assertEquals('CGST', orderLine1.dmpl__Tax1Type__c, 'Tax1 Type should match');
        System.assertEquals(66000, orderLine1.dmpl__Tax2__c, 'Tax2 should match');
        System.assertEquals('SGST', orderLine1.dmpl__Tax2Name__c, 'Tax2 Name should match');
        System.assertEquals(6, orderLine1.dmpl__Tax2Rate__c, 'Tax2 Rate should match');
        System.assertEquals('SGST', orderLine1.dmpl__Tax2Type__c, 'Tax2 Type should match');
        System.assertEquals(1100000, orderLine1.dmpl__BaseAmount__c, 'Base Amount should match');
        System.assertEquals(1232000, orderLine1.dmpl__GrossAmount__c, 'Gross Amount should match');

        System.assertEquals(1100000, saleOrder1.dmpl__LineSubTotal__c, 'Line SubTotal should match');
        System.assertEquals(1100000, saleOrder1.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should match');
        System.assertEquals(132000, saleOrder1.dmpl__TotalTaxAmount__c, 'Total Tax Amount should match');
        System.assertEquals(132000, saleOrder1.dmpl__TotalTaxAmount2__c, 'Total Tax Amount 2 should match');
        System.assertEquals(1232000, saleOrder1.dmpl__TotalOrderAmount__c, 'Total Order Amount should match');
        System.assertEquals(1232000, saleOrder1.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should match');
        System.assertEquals(1232000, saleOrder1.dmpl__OpenAmount__c, 'Open Amount should match');
        System.assertEquals(1232000, saleOrder1.dmpl__OutstandingAmount__c, 'Outstanding Amount should match');
    }

    @isTest
    static void saleOrderWithDiscountGroupAndSchemeNewPositive() {
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 3');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 3');
        dmpl__DiscountGroup__c discountGroup = DiscountDataHelper.getDiscountGroup('Discount 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 5');
        dmpl__Scheme__c scheme1 = SchemeDataHelper.getScheme('Scheme 2');
        
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customer.Id, 
            partner.Id, 
            branch.Id, 
            null, 
            null, 
            false, 
            null
        );
       
        dmpl__SaleOrder__c saleOrder2 = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id, 
            item.Id, 
            10, 
            null    
        );
        
        dmpl__SaleOrder__c finalOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals('Customer 3', finalOrder.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals('Anna Salai', finalOrder.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals('Chennai', finalOrder.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals('Tamil Nadu', finalOrder.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals('600002', finalOrder.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');
        System.assertEquals('Draft', finalOrder.dmpl__Status__c, 'Status should be draft');
        System.assertEquals('Price List 3', finalOrder.dmpl__PriceListId__r.Name, 'Price List should match');

        dmpl__SaleOrderLine__c orderLine = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals(10, orderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1000, orderLine.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(516, orderLine.dmpl__Tax1__c, 'Tax1 should match');
        System.assertEquals('CGST', orderLine.dmpl__Tax1Name__c, 'Tax1 Name should match');
        System.assertEquals(6, orderLine.dmpl__Tax1Rate__c, 'Tax1 Rate should match');
        System.assertEquals('CGST', orderLine.dmpl__Tax1Type__c, 'Tax1 Type should match');
        System.assertEquals(516, orderLine.dmpl__Tax2__c, 'Tax2 should match');
        System.assertEquals('SGST', orderLine.dmpl__Tax2Name__c, 'Tax2 Name should match');
        System.assertEquals(6, orderLine.dmpl__Tax2Rate__c, 'Tax2 Rate should match');
        System.assertEquals('SGST', orderLine.dmpl__Tax2Type__c, 'Tax2 Type should match');
        System.assertEquals(10000, orderLine.dmpl__BaseAmount__c, 'Base Amount should match');
        System.assertEquals(1000, orderLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should match');
        System.assertEquals(400, orderLine.dmpl__NetDiscount__c, 'Net Discount should match');
        System.assertEquals(1032, orderLine.dmpl__TaxAmount__c, 'Tax Amount should match');
        System.assertEquals(9632, orderLine.dmpl__GrossAmount__c, 'Gross Amount should match');

        System.assertEquals(8600, finalOrder.dmpl__LineSubTotal__c, 'Line SubTotal should match');
        System.assertEquals(10000, finalOrder.dmpl__TotalLineBaseAmount__c, 'Base Amount should match');
        System.assertEquals(1000, finalOrder.dmpl__TotalSchemeDiscountAmount__c, 'Scheme Discount should match');
        System.assertEquals(400, finalOrder.dmpl__TotalDiscountAmount__c, 'Discount Amount should match');
        System.assertEquals(1032, finalOrder.dmpl__TotalTaxAmount__c, 'Tax Amount should match');
        System.assertEquals(9632, finalOrder.dmpl__TotalLineGrossAmount__c, 'Gross Amount should match');
        System.assertEquals(9632, finalOrder.dmpl__OpenAmount__c, 'Open Amount should match');
        System.assertEquals(9632, finalOrder.dmpl__OutstandingAmount__c, 'Outstanding Amount should match');
        Test.stopTest();
    }

    @isTest
    static void saleOrderLineWithDiscountGroupandSchemeEdit() {
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 3');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 3');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 5');

        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customer.Id,
            partner.Id,
            branch.Id,
            null,
            null,
            false,
            null
        );

        dmpl__SaleOrder__c finalOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals('Customer 3', finalOrder.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals('Anna Salai', finalOrder.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals('Chennai', finalOrder.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals('Tamil Nadu', finalOrder.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals('600002', finalOrder.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');
        System.assertEquals('Draft', finalOrder.dmpl__Status__c, 'Status should be draft');
        System.assertEquals('Price List 3', finalOrder.dmpl__PriceListId__r.Name, 'Price List should match');

        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            20,
            null
        );

        dmpl__SaleOrderLine__c initialSOL = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals(1000, initialSOL.dmpl__UnitPrice__c, 'Unit Price should be 1000');
        System.assertEquals(20000, initialSOL.dmpl__BaseAmount__c, 'Base Amount should be 20000');
        System.assertEquals(800, initialSOL.dmpl__NetDiscount__c, 'Net Discount should be 800');
        System.assertEquals(2064, initialSOL.dmpl__TaxAmount__c, 'Tax Amount should be 2064');
        System.assertEquals(19264, initialSOL.dmpl__GrossAmount__c, 'Gross Amount should be 19264');

        initialSOL.dmpl__Quantity__c = 30;
        update initialSOL;

        Test.stopTest();

        dmpl__SaleOrderLine__c updatedSOL = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals(1000, updatedSOL.dmpl__UnitPrice__c, 'Unit Price should be 1000');
        System.assertEquals(30000, updatedSOL.dmpl__BaseAmount__c, 'Base Amount should be 30000');
        System.assertEquals(1200, updatedSOL.dmpl__NetDiscount__c, 'Net Discount should be 1200');
        System.assertEquals(3096, updatedSOL.dmpl__TaxAmount__c, 'Tax Amount should be 3096');
        System.assertEquals(28896, updatedSOL.dmpl__GrossAmount__c, 'Gross Amount should be 28896');

        dmpl__SaleOrder__c updatedSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals(25800, updatedSaleOrder.dmpl__LineSubTotal__c, 'Line SubTotal should be 27000');
        System.assertEquals(30000, updatedSaleOrder.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be 30000');
        System.assertEquals(3000, updatedSaleOrder.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 3000');
        System.assertEquals(1200, updatedSaleOrder.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 1200');
        System.assertEquals(3096, updatedSaleOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 3096');
        System.assertEquals(28896, updatedSaleOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be 28896');
        System.assertEquals(28896, updatedSaleOrder.dmpl__OpenAmount__c, 'Open Amount should be 28896');
        System.assertEquals(28896, updatedSaleOrder.dmpl__OutstandingAmount__c, 'Outstanding Amount should be 28896');
    }

    @isTest
    static void schemeApplicabilityCustomerAccountGroupNewPositive() {
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item6 = TestDataHelpers.getItem('Item 6');

        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id,
            partnerAccount1.Id,
            branch1.Id,
            null,
            null,
            false,
            null
        );

        dmpl__SaleOrder__c createdSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertNotEquals(null, createdSaleOrder.Id, 'Sale Order should be created');
        System.assertEquals('Customer 1', createdSaleOrder.dmpl__AccountName__c, 'Account Name should match');
        System.assertEquals('Price List 1', createdSaleOrder.dmpl__PriceListId__r.Name, 'Price List should match');
        System.assertEquals('Within State', createdSaleOrder.dmpl__TaxSupplyType__c, 'Tax Supply Type should match');
        System.assertEquals('MG Road', createdSaleOrder.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals('Pune', createdSaleOrder.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals('Maharashtra', createdSaleOrder.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals('India', createdSaleOrder.dmpl__BillingCountry__c, 'Billing Country should match');
        System.assertEquals('411001', createdSaleOrder.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');
        System.assertEquals(System.today(), createdSaleOrder.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', createdSaleOrder.dmpl__Status__c, 'Status should be Draft');

        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            createdSaleOrder.Id,
            item6.Id,
            2,
            null
        );
        Test.stopTest();
        
        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(createdSaleOrder.Id);
        System.assertNotEquals(null, createdSOL.Id, 'Sale Order Line should be created');
        System.assertEquals(2400, createdSOL.dmpl__UnitPrice__c, 'Unit Price should be 2400');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(262.08, createdSOL.dmpl__Tax1__c, 'Tax1 amount should be 288');
        System.assertEquals(6, createdSOL.dmpl__Tax1Rate__c, 'Tax1 rate should be 6%');
        System.assertEquals(262.08, createdSOL.dmpl__Tax2__c, 'Tax2 amount should be 288');
        System.assertEquals(6, createdSOL.dmpl__Tax2Rate__c, 'Tax2 rate should be 6%');
        System.assertEquals(524.16, createdSOL.dmpl__TaxAmount__c, 'Tax Amount should be 576');
        System.assertEquals(4800, createdSOL.dmpl__BaseAmount__c, 'Base amount should be 4800');
        System.assertEquals(240, createdSOL.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 240');
        System.assertEquals(192, createdSOL.dmpl__NetDiscount__c, 'Net Discount should be 192');
        System.assertEquals(4892.16, createdSOL.dmpl__GrossAmount__c, 'Gross Amount should be 4892.16');
        System.assertEquals(4368, createdSOL.dmpl__Amount__c, 'Amount should be 4368');
        System.assertEquals(5, createdSOL.dmpl__SchemeDiscount__c, 'Scheme Discount should be 5');

        dmpl__SaleOrder__c createdSaleOrder2 = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals(4368, createdSaleOrder2.dmpl__LineSubTotal__c, 'Line Subtotal should be 4368');
        System.assertEquals(4800, createdSaleOrder2.dmpl__TotalLineBaseAmount__c, 'Total Base Amount should be 4800');
        System.assertEquals(240, createdSaleOrder2.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 240');
        System.assertEquals(192, createdSaleOrder2.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 192');
        System.assertEquals(524.16, createdSaleOrder2.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 524.16');
        System.assertEquals(4892.16, createdSaleOrder2.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be 4892.16');
        System.assertEquals(4892, createdSaleOrder2.dmpl__OpenAmount__c, 'Open Amount should be 4892');
        System.assertEquals(4892.16, createdSaleOrder2.dmpl__OutstandingAmount__c, 'Outstanding Amount should be 4892.16');
    }

    @isTest
    static void schemeApplicabilityCustomerAccountGroupEditPositive() {
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item6 = TestDataHelpers.getItem('Item 6');

        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id,
            partnerAccount1.Id,
            branch1.Id,
            null,
            null,
            false,
            null
        );

        dmpl__SaleOrder__c createdSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertNotEquals(null, createdSaleOrder.Id, 'Sale Order should be created');
        System.assertEquals('Customer 1', createdSaleOrder.dmpl__AccountName__c, 'Account Name should match');
        System.assertEquals('Price List 1', createdSaleOrder.dmpl__PriceListId__r.Name, 'Price List should match');
        System.assertEquals('Within State', createdSaleOrder.dmpl__TaxSupplyType__c, 'Tax Supply Type should match');
        System.assertEquals('MG Road', createdSaleOrder.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals('Pune', createdSaleOrder.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals('Maharashtra', createdSaleOrder.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals('India', createdSaleOrder.dmpl__BillingCountry__c, 'Billing Country should match');
        System.assertEquals('411001', createdSaleOrder.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');
        System.assertEquals(System.today(), createdSaleOrder.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', createdSaleOrder.dmpl__Status__c, 'Status should be Draft');

        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            createdSaleOrder.Id,
            item6.Id,
            2,
            null
        );

        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(createdSaleOrder.Id);
        System.assertEquals(2400, createdSOL.dmpl__UnitPrice__c, 'Unit Price should be 2400');
        System.assertEquals(262.08, createdSOL.dmpl__Tax1__c, 'Tax1 amount should be 262.08');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(6, createdSOL.dmpl__Tax1Rate__c, 'Tax1 rate should be 6');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(262.08, createdSOL.dmpl__Tax2__c, 'Tax2 amount should be 262.08');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(6, createdSOL.dmpl__Tax2Rate__c, 'Tax2 rate should be 6');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(4368, createdSOL.dmpl__Amount__c, 'Amount should be 4368');
        System.assertEquals(4800, createdSOL.dmpl__BaseAmount__c, 'Base amount should be 4800');
        System.assertEquals(4892.16, createdSOL.dmpl__GrossAmount__c, 'Gross Amount should be 4892.16');
        System.assertEquals(192, createdSOL.dmpl__NetDiscount__c, 'Net Discount should be 192');
        System.assertEquals(240, createdSOL.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 240');
        System.assertEquals(5, createdSOL.dmpl__SchemeDiscount__c, 'Scheme Discount should be 5');
        System.assertEquals(524.16, createdSOL.dmpl__TaxAmount__c, 'Tax Amount should be 524.16');

      
        createdSOL.dmpl__Quantity__c = 3;
        update createdSOL;

        dmpl__SaleOrderLine__c updatedSOL = SaleOrderDataHelper.getSaleOrderLine(createdSaleOrder.Id);
        System.assertEquals(2400, updatedSOL.dmpl__UnitPrice__c, 'Unit Price should be 2400');
        System.assertEquals(414.72, updatedSOL.dmpl__Tax1__c, 'Tax1 amount should be 414.72');
        System.assertEquals('CGST', updatedSOL.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(6, updatedSOL.dmpl__Tax1Rate__c, 'Tax1 rate should be 6');
        System.assertEquals('CGST', updatedSOL.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(414.72, updatedSOL.dmpl__Tax2__c, 'Tax2 amount should be 414.72');
        System.assertEquals('SGST', updatedSOL.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(6, updatedSOL.dmpl__Tax2Rate__c, 'Tax2 rate should be 6');
        System.assertEquals('SGST', updatedSOL.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(6912, updatedSOL.dmpl__Amount__c, 'Amount should be 6912');
        System.assertEquals(7200, updatedSOL.dmpl__BaseAmount__c, 'Base amount should be 7200');
        System.assertEquals(7741.44, updatedSOL.dmpl__GrossAmount__c, 'Gross Amount should be 7741.44');
        System.assertEquals(288, updatedSOL.dmpl__NetDiscount__c, 'Net Discount should be 288');
        System.assertEquals(0, updatedSOL.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(829.44, updatedSOL.dmpl__TaxAmount__c, 'Tax Amount should be 829.44');
        System.assert(updatedSOL.Name.startsWith('DOC'), 'Name should start with DOC');

        dmpl__SaleOrder__c updatedSO = SaleOrderDataHelper.getSaleOrder(createdSaleOrder.Id);
        System.assertEquals(6912, updatedSO.dmpl__LineSubTotal__c, 'Line SubTotal should be 6912');
        System.assertEquals(7200, updatedSO.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be 7200');
        System.assertEquals(0, updatedSO.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 0');
        System.assertEquals(7741.44, updatedSO.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be 7741.44');
        System.assertEquals(7741, updatedSO.dmpl__OpenAmount__c, 'Open Amount should be 7741');
        System.assertEquals(7741.44, updatedSO.dmpl__OutstandingAmount__c, 'Outstanding Amount should be 7741.44');
        Test.stopTest();
    }

    @isTest
    static void schemeApplicabilityInCaseSchemeDiscountIsMoreThanAvailableBudgetEdit() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 5');

        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customer.Id,
            partner.Id,
            branch.Id,
            null,
            null,
            false,
            null
        );

        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            1,
            null
        );

        saleOrderLine.dmpl__Quantity__c = 1200;
        update saleOrderLine;

        Test.stopTest();

        dmpl__SaleOrder__c updatedSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        dmpl__SaleOrderLine__c updatedSaleOrderLine = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals(1200, updatedSaleOrderLine.dmpl__Quantity__c, 'Quantity should be 1200');
        System.assertEquals(1000, updatedSaleOrderLine.dmpl__UnitPrice__c, 'Unit Price should be 1000');
        System.assertEquals(72000, updatedSaleOrderLine.dmpl__Tax1__c, 'Tax1 should be 72000');
        System.assertEquals('CGST', updatedSaleOrderLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(6, updatedSaleOrderLine.dmpl__Tax1Rate__c, 'Tax1 Rate should be 6');
        System.assertEquals('CGST', updatedSaleOrderLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(72000, updatedSaleOrderLine.dmpl__Tax2__c, 'Tax2 should be 72000');
        System.assertEquals('SGST', updatedSaleOrderLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(6, updatedSaleOrderLine.dmpl__Tax2Rate__c, 'Tax2 Rate should be 6');
        System.assertEquals('SGST', updatedSaleOrderLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(1344000, updatedSaleOrderLine.dmpl__GrossAmount__c, 'Gross Amount should be 1344000');
        System.assertEquals(1200000, updatedSaleOrderLine.dmpl__Amount__c, 'Amount should be 1200000');
        System.assertEquals(1200000, updatedSaleOrderLine.dmpl__BaseAmount__c, 'Base Amount should be 1200000');
        System.assert(updatedSaleOrderLine.Name.startsWith('DOC'), 'Sale Order Line Name should start with DOC');

        System.assertEquals(1200000, updatedSaleOrder.dmpl__LineSubTotal__c, 'Line SubTotal should be 1200000');
        System.assertEquals(1200000, updatedSaleOrder.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be 1200000');
        System.assertEquals(144000, updatedSaleOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 144000');
        System.assertEquals(144000, updatedSaleOrder.dmpl__TotalTaxAmount2__c, 'Total Tax Amount 2 should be 144000');
        System.assertEquals(1344000, updatedSaleOrder.dmpl__TotalOrderAmount__c, 'Total Order Amount should be 1344000');
        System.assertEquals(1344000, updatedSaleOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be 1344000');
        System.assertEquals(1344000, updatedSaleOrder.dmpl__OpenAmount__c, 'Open Amount should be 1344000');
        System.assertEquals(1344000, updatedSaleOrder.dmpl__OutstandingAmount__c, 'Outstanding Amount should be 1344000');
        System.assert(updatedSaleOrder.Name.startsWith('SO'), 'Sale Order Name should start with SO');

        System.assertEquals('Customer 1', updatedSaleOrder.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals('MG Road', updatedSaleOrder.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals('Pune', updatedSaleOrder.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals('Maharashtra', updatedSaleOrder.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals('411001', updatedSaleOrder.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');
        System.assertEquals('Draft', updatedSaleOrder.dmpl__Status__c, 'Status should be draft');
    }

    @isTest
    static void saleOrderWithDiscountGroupEdit() {
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__PriceList__c priceList3 = TestDataHelpers.getPriceList('Price List 3');
        dmpl__Item__c item6 = TestDataHelpers.getItem('Item 6');
        dmpl__DiscountGroup__c discountGroup1 = DiscountDataHelper.getDiscountGroup('Discount 1');

        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id,
            partnerAccount4.Id,
            branch4.Id,
            null,
            null,
            false,
            null
        );

        dmpl__SaleOrderLine__c line = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item6.Id,
            20,
            null
        );

        line = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals(20, line.dmpl__Quantity__c, 'Initial quantity should be 20');
        System.assertEquals(40000, line.dmpl__BaseAmount__c, 'Base amount mismatch for 20 qty');
        System.assertEquals(1600, line.dmpl__NetDiscount__c, 'Discount mismatch for 20 qty');
        System.assertEquals(4608, line.dmpl__TaxAmount__c, 'Tax mismatch for 20 qty');
        System.assertEquals(43008, line.dmpl__GrossAmount__c, 'Gross mismatch for 20 qty');

        line.dmpl__Quantity__c = 30;
        update line;

        dmpl__SaleOrderLine__c updatedLine = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals(30, updatedLine.dmpl__Quantity__c, 'Quantity should be updated to 30');
        System.assertEquals(60000, updatedLine.dmpl__BaseAmount__c, 'Base amount mismatch for 30 qty');
        System.assertEquals(2400, updatedLine.dmpl__NetDiscount__c, 'Discount mismatch for 30 qty');
        System.assertEquals(6912, updatedLine.dmpl__TaxAmount__c, 'Tax mismatch for 30 qty');
        System.assertEquals(64512, updatedLine.dmpl__GrossAmount__c, 'Gross mismatch for 30 qty');

        dmpl__SaleOrder__c finalOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals(57600.00, finalOrder.dmpl__LineSubTotal__c);
        System.assertEquals(60000.00, finalOrder.dmpl__TotalLineBaseAmount__c);
        System.assertEquals(0, finalOrder.dmpl__TotalSchemeDiscountAmount__c);
        System.assertEquals(2400, finalOrder.dmpl__TotalDiscountAmount__c);
        System.assertEquals(6912, finalOrder.dmpl__TotalLineTaxAmount__c);
        System.assertEquals(6912, finalOrder.dmpl__TotalTaxAmount__c);
        System.assertEquals(64512, finalOrder.dmpl__TotalLineGrossAmount__c);
        System.assertEquals(64512, finalOrder.dmpl__OpenAmount__c);
        System.assertEquals(64512, finalOrder.dmpl__OutstandingAmount__c);
        Test.stopTest();
    }
   
    @isTest
    static void saleOrderLineWithInactiveItemEdit() {
        Account customerAccount3 = TestDataHelpers.getCustomerAccount('Customer 3');
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Item__c inactiveItem = TestDataHelpers.getItem('Item 2');

        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount3.Id,
            partnerAccount4.Id,
            branch4.Id,
            null,
            null,
            false,
            null
        );

        dmpl__SaleOrderLine__c saleOrderLine1 = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item1.Id,
            5,
            null
        );
        
        dmpl__SaleOrder__c saleOrder1 = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals('Customer 3', saleOrder1.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals('Within State', saleOrder1.dmpl__TaxSupplyType__c, 'Tax Supply Type should match');
        System.assertEquals('Anna Salai', saleOrder1.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals('Chennai', saleOrder1.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals('Tamil Nadu', saleOrder1.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals('600002', saleOrder1.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');
        System.assertEquals(System.today(), saleOrder1.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', saleOrder1.dmpl__Status__c, 'Status should be Draft');
        
        dmpl__SaleOrderLine__c orderLine1 = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertNotEquals(null, orderLine1.Id, 'Sale Order Line should be created');
        System.assertEquals(5, orderLine1.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, orderLine1.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(450, orderLine1.dmpl__Tax1__c, 'Tax1 should match');
        System.assertEquals('CGST', orderLine1.dmpl__Tax1Name__c, 'Tax1 Name should match');
        System.assertEquals(6, orderLine1.dmpl__Tax1Rate__c, 'Tax1 Rate should match');
        System.assertEquals('CGST', orderLine1.dmpl__Tax1Type__c, 'Tax1 Type should match');
        System.assertEquals(450, orderLine1.dmpl__Tax2__c, 'Tax2 should match');
        System.assertEquals('SGST', orderLine1.dmpl__Tax2Name__c, 'Tax2 Name should match');
        System.assertEquals(6, orderLine1.dmpl__Tax2Rate__c, 'Tax2 Rate should match');
        System.assertEquals('SGST', orderLine1.dmpl__Tax2Type__c, 'Tax2 Type should match');
        System.assertEquals(7500, orderLine1.dmpl__BaseAmount__c, 'Base Amount should match');
        System.assertEquals(0, orderLine1.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should match');
        System.assertEquals(0, orderLine1.dmpl__NetDiscount__c, 'Net Discount should match');
        System.assertEquals(900, orderLine1.dmpl__TaxAmount__c, 'Tax Amount should match');
        System.assertEquals(8400, orderLine1.dmpl__GrossAmount__c, 'Gross Amount should match');

        try {
            dmpl__SaleOrderLine__c saleOrderLine2 = SaleOrderDataHelper.createSaleOrderLine(
                saleOrder.Id,
                inactiveItem.Id,
                3,
                null
            );
            System.assert(false, 'Expected an exception to be thrown for inactive item');
        } catch (Exception e) {
            System.assertEquals(
                'Insert failed. First exception on row 0; first error: FIELD_FILTER_VALIDATION_EXCEPTION, Item needs to be active and not set to be sold only on package!: [dmpl__ItemId__c]',
                e.getMessage(),
                'Expected validation error for inactive item'
            );
        }
        Test.stopTest();
    }

   @isTest
    static void saleOrderWithAutoApplySchemeDiscountPercentage() {
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item6 = TestDataHelpers.getItem('Item 6');
        dmpl__Scheme__c scheme9 = SchemeDataHelper.getScheme('Scheme 9');

        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id,
            partnerAccount1.Id,
            branch1.Id,
            null,
            null,
            false,
            null
        );

        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item6.Id,
            2,
            null
        );

        dmpl__SaleOrderLine__c orderLine = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals(2, orderLine.dmpl__Quantity__c, 'Quantity should be 2');
        System.assertEquals(2400, orderLine.dmpl__UnitPrice__c, 'Unit Price should be 2400');
        System.assertEquals(262.08, orderLine.dmpl__Tax1__c, 'Tax1 should be 262.08');
        System.assertEquals('CGST', orderLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(6, orderLine.dmpl__Tax1Rate__c, 'Tax1 Rate should be 6%');
        System.assertEquals('CGST', orderLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(262.08, orderLine.dmpl__Tax2__c, 'Tax2 should be 262.08');
        System.assertEquals('SGST', orderLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(6, orderLine.dmpl__Tax2Rate__c, 'Tax2 Rate should be 6%');
        System.assertEquals('SGST', orderLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(4800, orderLine.dmpl__BaseAmount__c, 'Base Amount should be 4800');
        System.assertEquals(240, orderLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 240');
        System.assertEquals(524.16, orderLine.dmpl__TaxAmount__c, 'Tax Amount should be 524.16');
        System.assertEquals(4892.16, orderLine.dmpl__GrossAmount__c, 'Gross Amount should be 4892.16');

        dmpl__SaleOrder__c updatedSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals('Customer 1', updatedSaleOrder.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals('Within State', updatedSaleOrder.dmpl__TaxSupplyType__c, 'Tax Supply Type should match');
        System.assertEquals('MG Road', updatedSaleOrder.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals('Pune', updatedSaleOrder.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals('Maharashtra', updatedSaleOrder.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals('411001', updatedSaleOrder.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');
        System.assertEquals('Ring Rd', updatedSaleOrder.dmpl__ShippingStreet__c, 'Shipping Street should match');
        System.assertEquals('Nagpur', updatedSaleOrder.dmpl__ShippingCity__c, 'Shipping City should match');
        System.assertEquals('Maharashtra', updatedSaleOrder.dmpl__ShippingState__c, 'Shipping State should match');
        System.assertEquals('440001', updatedSaleOrder.dmpl__ShippingPostalCode__c, 'Shipping Postal Code should match');
        System.assertEquals('Draft', updatedSaleOrder.dmpl__Status__c, 'Status should be Draft');

        System.assertEquals(4368, updatedSaleOrder.dmpl__LineSubTotal__c, 'Line SubTotal should be 4368');
        System.assertEquals(4800, updatedSaleOrder.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be 4800');
        System.assertEquals(240, updatedSaleOrder.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 240');
        System.assertEquals(192.0, updatedSaleOrder.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 192');
        System.assertEquals(524.16, updatedSaleOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 524.16');
        System.assertEquals(4892.16, updatedSaleOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be 4892.16');
        System.assertEquals(4892, updatedSaleOrder.dmpl__OpenAmount__c, 'Open Amount should be 4892');
        System.assertEquals(4892.16, updatedSaleOrder.dmpl__OutstandingAmount__c, 'Outstanding Amount should be 4892.16');
        Test.stopTest();
    }

    @isTest
    static void saleOrderWithAutoApplySchemeDiscountPercentageEdit() {
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item6 = TestDataHelpers.getItem('Item 6');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Scheme__c scheme9 = SchemeDataHelper.getScheme('Scheme 9');
        dmpl__DiscountGroup__c discountGroup = DiscountDataHelper.getDiscountGroup('Discount 1');

        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id,
            partnerAccount1.Id,
            branch1.Id,
            null,
            null,
            false,
            null
        );

        dmpl__SaleOrderLine__c line1 = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id, 
            item6.Id, 
            2, 
            null
        );

        dmpl__SaleOrderLine__c line = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals(2, line.dmpl__Quantity__c, 'Initial quantity should be 2');
        System.assertEquals(2400, line.dmpl__UnitPrice__c, 'Unit price should be 2400');
        System.assertEquals(262.08, line.dmpl__Tax1__c, 'Tax1 should be 262.08');
        System.assertEquals('CGST', line.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(6, line.dmpl__Tax1Rate__c, 'Tax1 Rate should be 6%');
        System.assertEquals('CGST', line.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(262.08, line.dmpl__Tax2__c, 'Tax2 should be 262.08');
        System.assertEquals('SGST', line.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(6, line.dmpl__Tax2Rate__c, 'Tax2 Rate should be 6%');
        System.assertEquals('SGST', line.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(4800, line.dmpl__BaseAmount__c, 'Base Amount should be 4800');
        System.assertEquals(240, line.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 240');
        System.assertEquals(524.16, line.dmpl__TaxAmount__c, 'Tax Amount should be 524.16');
        System.assertEquals(4892.16, line.dmpl__GrossAmount__c, 'Gross Amount should be 4892.16');
        System.assertNotEquals(null, line.dmpl__SchemeLineId__c, 'SchemeLineId should not be null');
        System.assertEquals(5.0, line.dmpl__SchemeDiscount__c, 'Scheme Discount should be 5%');

        line.dmpl__Quantity__c = 1;
        update line;

        dmpl__SaleOrderLine__c updatedLine = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals(2400, updatedLine.dmpl__UnitPrice__c, 'Updated Unit price should be 2400');
        System.assertEquals(1, updatedLine.dmpl__Quantity__c, 'Updated quantity should be 1');
        System.assertEquals(138.24, updatedLine.dmpl__Tax1__c, 'Updated Tax1 should be 138.24');
        System.assertEquals('CGST', updatedLine.dmpl__Tax1Name__c, 'Updated Tax1 Name should be CGST');
        System.assertEquals(6, updatedLine.dmpl__Tax1Rate__c, 'Updated Tax1 Rate should be 6%');
        System.assertEquals('CGST', updatedLine.dmpl__Tax1Type__c, 'Updated Tax1 Type should be CGST');
        System.assertEquals(138.24, updatedLine.dmpl__Tax2__c, 'Updated Tax2 should be 138.24');
        System.assertEquals('SGST', updatedLine.dmpl__Tax2Name__c, 'Updated Tax2 Name should be SGST');
        System.assertEquals(6, updatedLine.dmpl__Tax2Rate__c, 'Updated Tax2 Rate should be 6%');
        System.assertEquals('SGST', updatedLine.dmpl__Tax2Type__c, 'Updated Tax2 Type should be SGST');
        System.assertEquals(2400, updatedLine.dmpl__BaseAmount__c, 'Updated Base Amount should be 2400');
        System.assertEquals(0, updatedLine.dmpl__NetSchemeDiscount__c, 'Updated Net Scheme Discount should be 0');
        System.assertEquals(276.48, updatedLine.dmpl__TaxAmount__c, 'Updated Tax Amount should be 276.48');
        System.assertEquals(2580.48, updatedLine.dmpl__GrossAmount__c, 'Updated Gross Amount should be 2580.48');

        dmpl__SaleOrder__c updatedSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals(2304, updatedSaleOrder.dmpl__LineSubTotal__c, 'SaleOrder Line Sub Total should be 2304');
        System.assertEquals(2400, updatedSaleOrder.dmpl__TotalLineBaseAmount__c, 'SaleOrder Base Amount should be 2400');
        System.assertEquals(0, updatedSaleOrder.dmpl__TotalSchemeDiscountAmount__c, 'SaleOrder Scheme Discount should be 0');
        System.assertEquals(96, updatedSaleOrder.dmpl__TotalDiscountAmount__c, 'SaleOrder Discount Amount should be 96');
        System.assertEquals(276.48, updatedSaleOrder.dmpl__TotalTaxAmount__c, 'SaleOrder Tax Amount should be 276.48');
        System.assertEquals(2580.48, updatedSaleOrder.dmpl__TotalLineGrossAmount__c, 'SaleOrder Gross Amount should be 2580.48');
        System.assertEquals(2580, updatedSaleOrder.dmpl__OpenAmount__c, 'SaleOrder Open Amount should be 2580');
        System.assertEquals(2580.48, updatedSaleOrder.dmpl__OutstandingAmount__c, 'SaleOrder Outstanding Amount should be 2580.48');
        Test.stopTest();
    }
    
    @isTest
    static void saleOrderWithSchemeAutoApplyDiscountAmount() {
        Account customerAccount2 = TestDataHelpers.getCustomerAccount('Customer 2');
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item5 = TestDataHelpers.getItem('Item 5');
        dmpl__ContactAddress__c billingAddress = TestDataHelpers.getContactAddress(customerAccount2.Id);
        dmpl__ContactAddress__c shippingAddress = TestDataHelpers.getContactAddress(customerAccount2.Id);

        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount2.Id,
            partnerAccount4.Id, 
            branch4.Id,
            billingAddress.Id,
            shippingAddress.Id,
            false,
            null
        );

        dmpl__SaleOrder__c createdSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertNotEquals(null, createdSaleOrder.Id, 'Sale Order should be created');
        System.assertEquals('Ring Rd', createdSaleOrder.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals('Pune', createdSaleOrder.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals('Maharashtra', createdSaleOrder.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals('440001', createdSaleOrder.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');
        System.assertEquals('Ring Rd', createdSaleOrder.dmpl__ShippingStreet__c, 'Shipping Street should match');
        System.assertEquals('Pune', createdSaleOrder.dmpl__ShippingCity__c, 'Shipping City should match');
        System.assertEquals('Maharashtra', createdSaleOrder.dmpl__ShippingState__c, 'Shipping State should match');
        System.assertEquals('India', createdSaleOrder.dmpl__ShippingCountry__c, 'Shipping Country should match');
        System.assertEquals('440001', createdSaleOrder.dmpl__ShippingPostalCode__c, 'Shipping Postal Code should match');
        System.assertEquals('Draft', createdSaleOrder.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals('Within State', createdSaleOrder.dmpl__TaxSupplyType__c, 'Tax Supply Type should match');

        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            createdSaleOrder.Id,
            item5.Id,
            10,
            null
        );

        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(createdSaleOrder.Id);
        System.assertEquals(1000, createdSOL.dmpl__UnitPrice__c, 'Unit Price should be 1000');
        System.assertEquals(10000, createdSOL.dmpl__BaseAmount__c, 'Base Amount should be 10000');
        System.assertEquals(1000, createdSOL.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 1000');
        System.assertEquals(400, createdSOL.dmpl__NetDiscount__c, 'Net Discount should be 400');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(516, createdSOL.dmpl__Tax1__c, 'Tax1 amount should be 540');
        System.assertEquals(6, createdSOL.dmpl__Tax1Rate__c, 'Tax1 rate should be 6');
        System.assertEquals(516, createdSOL.dmpl__Tax2__c, 'Tax2 amount should be 540');
        System.assertEquals(6, createdSOL.dmpl__Tax2Rate__c, 'Tax2 rate should be 6');
        System.assertEquals(1032, createdSOL.dmpl__TaxAmount__c, 'Tax Amount should be 1080');
        System.assertEquals(9632, createdSOL.dmpl__GrossAmount__c, 'Gross Amount should be 10080');
        
        dmpl__SaleOrder__c updatedSO = SaleOrderDataHelper.getSaleOrder(createdSaleOrder.Id);
        System.assertEquals(8600, updatedSO.dmpl__LineSubTotal__c, 'Line Sub Total should be 8600');
        System.assertEquals(10000, updatedSO.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be 10000');
        System.assertEquals(1000, updatedSO.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 1000');
        System.assertEquals(400, updatedSO.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 400');
        System.assertEquals(1032, updatedSO.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount should be 1032');
        System.assertEquals(1032, updatedSO.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 1032');
        System.assertEquals(9632, updatedSO.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be 9632');
        System.assertEquals(9632, updatedSO.dmpl__OpenAmount__c, 'Open Amount should be 9632');
        System.assertEquals(9632, updatedSO.dmpl__OutstandingAmount__c, 'Outstanding Amount should be 9632');
        Test.stopTest();
    }

    @isTest
    static void saleOrderWithSchemeAutoApplyDiscountAmountEdit() {
        Account customerAccount2 = TestDataHelpers.getCustomerAccount('Customer 2');
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item5 = TestDataHelpers.getItem('Item 5');
        dmpl__ContactAddress__c billingAddress = TestDataHelpers.getContactAddress(customerAccount2.Id);
        dmpl__ContactAddress__c shippingAddress = TestDataHelpers.getContactAddress(customerAccount2.Id);

        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount2.Id,
            partnerAccount4.Id, 
            branch4.Id,
            billingAddress.Id,
            shippingAddress.Id,
            false,
            null
        );

        dmpl__SaleOrder__c createdSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertNotEquals(null, createdSaleOrder.Id, 'Sale Order should be created');
        System.assertEquals('Ring Rd', createdSaleOrder.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals('Pune', createdSaleOrder.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals('Maharashtra', createdSaleOrder.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals('440001', createdSaleOrder.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');
        System.assertEquals('Ring Rd', createdSaleOrder.dmpl__ShippingStreet__c, 'Shipping Street should match');
        System.assertEquals('Pune', createdSaleOrder.dmpl__ShippingCity__c, 'Shipping City should match');
        System.assertEquals('Maharashtra', createdSaleOrder.dmpl__ShippingState__c, 'Shipping State should match');
        System.assertEquals('India', createdSaleOrder.dmpl__ShippingCountry__c, 'Shipping Country should match');
        System.assertEquals('440001', createdSaleOrder.dmpl__ShippingPostalCode__c, 'Shipping Postal Code should match');
        System.assertEquals('Draft', createdSaleOrder.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals('Within State', createdSaleOrder.dmpl__TaxSupplyType__c, 'Tax Supply Type should match');

        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            createdSaleOrder.Id,
            item5.Id,
            10,
            null
        );

        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(createdSaleOrder.Id);
        System.assertEquals(1000, createdSOL.dmpl__UnitPrice__c, 'Unit Price should be 1000');
        System.assertEquals(10000, createdSOL.dmpl__BaseAmount__c, 'Base Amount should be 10000');
        System.assertEquals(1000, createdSOL.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 1000');
        System.assertEquals(400, createdSOL.dmpl__NetDiscount__c, 'Net Discount should be 400');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(516, createdSOL.dmpl__Tax1__c, 'Tax1 amount should be 516');
        System.assertEquals(6, createdSOL.dmpl__Tax1Rate__c, 'Tax1 rate should be 6');
        System.assertEquals(516, createdSOL.dmpl__Tax2__c, 'Tax2 amount should be 516');
        System.assertEquals(6, createdSOL.dmpl__Tax2Rate__c, 'Tax2 rate should be 6');
        System.assertEquals(1032, createdSOL.dmpl__TaxAmount__c, 'Tax Amount should be 1032');
        System.assertEquals(9632, createdSOL.dmpl__GrossAmount__c, 'Gross Amount should be 9632');
        
        createdSOL.dmpl__Quantity__c = 20;
        update createdSOL;

        dmpl__SaleOrderLine__c updatedSOL = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals(1000, updatedSOL.dmpl__UnitPrice__c, 'Unit Price should be 1000');
        System.assertEquals(20000.00, updatedSOL.dmpl__BaseAmount__c, 'Base Amount should be 20000');
        System.assertEquals(2000, updatedSOL.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 2000');
        System.assertEquals(800, updatedSOL.dmpl__NetDiscount__c, 'Net Discount should be 800');
        System.assertEquals('CGST', updatedSOL.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals('SGST', updatedSOL.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals('CGST', updatedSOL.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', updatedSOL.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(1032, updatedSOL.dmpl__Tax1__c, 'Tax1 amount should be 1032');
        System.assertEquals(6, updatedSOL.dmpl__Tax1Rate__c, 'Tax1 rate should be 6');
        System.assertEquals(1032, updatedSOL.dmpl__Tax2__c, 'Tax2 amount should be 1032');
        System.assertEquals(6, updatedSOL.dmpl__Tax2Rate__c, 'Tax2 rate should be 6');
        System.assertEquals(2064, updatedSOL.dmpl__TaxAmount__c, 'Tax Amount should be 2064');
        System.assertEquals(19264, updatedSOL.dmpl__GrossAmount__c, 'Gross Amount should be 19264 ');

        dmpl__SaleOrder__c updatedSO = SaleOrderDataHelper.getSaleOrder(createdSaleOrder.Id);
        System.assertEquals(17200, updatedSO.dmpl__LineSubTotal__c, 'Line Sub Total should be 17200');
        System.assertEquals(20000, updatedSO.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be 20000');
        System.assertEquals(2000, updatedSO.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 2000');
        System.assertEquals(800, updatedSO.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 800');
        System.assertEquals(2064, updatedSO.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount should be 2064');
        System.assertEquals(2064, updatedSO.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 2064');
        System.assertEquals(19264, updatedSO.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be 19264');
        System.assertEquals(19264, updatedSO.dmpl__OpenAmount__c, 'Open Amount should be 19264');
        System.assertEquals(19264, updatedSO.dmpl__OutstandingAmount__c, 'Outstanding Amount should be 19264');
        Test.stopTest();
    }
    
    @isTest
    static void saleOrderLineWithSchemeAutoApplyDiscountAmountNew() {
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 3');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 3');
        dmpl__DiscountGroup__c discountGroup = DiscountDataHelper.getDiscountGroup('Discount 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 5');
 
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customer.Id,
            partner.Id,
            branch.Id,
            null,
            null,
            false,
            null
        );
     
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            12,
            null    
        );
 
        dmpl__SaleOrder__c finalOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals('Customer 3', finalOrder.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals('Anna Salai', finalOrder.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals('Chennai', finalOrder.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals('Tamil Nadu', finalOrder.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals('600002', finalOrder.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');
        System.assertEquals('Draft', finalOrder.dmpl__Status__c, 'Status should be draft');
        System.assertEquals('Price List 3', finalOrder.dmpl__PriceListId__r.Name, 'Price List should match');
        System.assertEquals('Discount 1', finalOrder.dmpl__DiscountGroupId__r.Name, 'Discount Group should match');
 
        dmpl__SaleOrderLine__c orderLine = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals(12, orderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1000, orderLine.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(631.20, orderLine.dmpl__Tax1__c, 'Tax1 should match');
        System.assertEquals('CGST', orderLine.dmpl__Tax1Name__c, 'Tax1 Name should match');
        System.assertEquals(6, orderLine.dmpl__Tax1Rate__c, 'Tax1 Rate should match');
        System.assertEquals('CGST', orderLine.dmpl__Tax1Type__c, 'Tax1 Type should match');
        System.assertEquals(631.20, orderLine.dmpl__Tax2__c, 'Tax2 should match');
        System.assertEquals('SGST', orderLine.dmpl__Tax2Name__c, 'Tax2 Name should match');
        System.assertEquals(6, orderLine.dmpl__Tax2Rate__c, 'Tax2 Rate should match');
        System.assertEquals('SGST', orderLine.dmpl__Tax2Type__c, 'Tax2 Type should match');
        System.assertEquals(12000, orderLine.dmpl__BaseAmount__c, 'Base Amount should match');
        System.assertEquals(1000, orderLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should match');
        System.assertEquals(480, orderLine.dmpl__NetDiscount__c, 'Net Discount should match');

        System.assertEquals(1262.40, orderLine.dmpl__TaxAmount__c, 'Tax Amount should match');
        System.assertEquals(11782.40, orderLine.dmpl__GrossAmount__c, 'Gross Amount should match');
        System.assertEquals(10520.00, finalOrder.dmpl__LineSubTotal__c, 'Line SubTotal should match');
        System.assertEquals(12000, finalOrder.dmpl__TotalLineBaseAmount__c, 'Base Amount should match');
        System.assertEquals(1000, finalOrder.dmpl__TotalSchemeDiscountAmount__c, 'Scheme Discount should match');
        System.assertEquals(480, finalOrder.dmpl__TotalDiscountAmount__c, 'Discount Amount should match');
        System.assertEquals(1262.40, finalOrder.dmpl__TotalTaxAmount__c, 'Tax Amount should match');
        System.assertEquals(11782.40, finalOrder.dmpl__TotalLineGrossAmount__c, 'Gross Amount should match');
        System.assertEquals(11782, finalOrder.dmpl__OpenAmount__c, 'Open Amount should match');
        System.assertEquals(11782.40, finalOrder.dmpl__OutstandingAmount__c, 'Outstanding Amount should match');
        Test.stopTest();
    }
 
    @isTest
    static void saleOrderLineWithSchemeAutoApplyDiscountAmountEdit() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 3');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 3');
        dmpl__DiscountGroup__c discountGroup = DiscountDataHelper.getDiscountGroup('Discount 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 5');
 
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customer.Id,
            partner.Id,
            branch.Id,
            null,
            null,
            false,
            null
        );
       
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            12,
            null    
        );
 
        saleOrderLine.dmpl__Quantity__c=5;
        update saleOrderLine;

        dmpl__SaleOrderLine__c orderLine = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        Test.stopTest();
 
        System.assertEquals(1000, orderLine.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(288, orderLine.dmpl__Tax1__c, 'Tax1 should match');
        System.assertEquals('CGST', orderLine.dmpl__Tax1Name__c, 'Tax1 Name should match');
        System.assertEquals(6, orderLine.dmpl__Tax1Rate__c, 'Tax1 Rate should match');
        System.assertEquals('CGST', orderLine.dmpl__Tax1Type__c, 'Tax1 Type should match');
        System.assertEquals(288,orderLine.dmpl__Tax2__c, 'Tax2 should match');
        System.assertEquals('SGST',orderLine.dmpl__Tax2Name__c, 'Tax2 Name should match');
        System.assertEquals(6,orderLine.dmpl__Tax2Rate__c, 'Tax2 Rate should match');
        System.assertEquals('SGST',orderLine.dmpl__Tax2Type__c, 'Tax2 Type should match');
        System.assertEquals(5000,orderLine.dmpl__BaseAmount__c, 'Base Amount should match');
        System.assertEquals(0,orderLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should match');
        System.assertEquals(200,orderLine.dmpl__NetDiscount__c, 'Net Discount should match');
        System.assertEquals(576,orderLine.dmpl__TaxAmount__c, 'Net TaxAmount should match');
        System.assertEquals(5376,orderLine.dmpl__GrossAmount__c,'Net Gross Amount should match');
 
        dmpl__SaleOrder__c so =SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals(4800.00, so.dmpl__LineSubTotal__c, 'Line Subtotal mismatch');
        System.assertEquals(5000.00, so.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount mismatch');
        System.assertEquals(0.00, so.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount mismatch');
        System.assertEquals(200.00, so.dmpl__TotalDiscountAmount__c, 'Total Discount Amount mismatch');
        System.assertEquals(576.00, so.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount mismatch');
        System.assertEquals(576.00, so.dmpl__TotalTaxAmount__c, 'Total Tax Amount mismatch');
        System.assertEquals(5376.00, so.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount mismatch');
        System.assertEquals(5376.00, so.dmpl__OpenAmount__c, 'Open Amount mismatch');
        System.assertEquals(5376.00, so.dmpl__OutstandingAmount__c, 'Outstanding Amount mismatch');      
    }
    
    @isTest
    static void saleOrderLineAddingItemWithIsSKURequiredTrueNewNegative() {
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 8');
 
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id,
            partnerAccount1.Id,
            branch1.Id,
            null,
            null,
            false,
            null
        );
 
        dmpl__SaleOrder__c createdSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        try {
            dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
                createdSaleOrder.Id,
                item.Id,
                3,
                null
            );
            System.assert(false, 'Expected exception was not thrown.');
        } catch (DmlException e) {
            System.assert(
                e.getMessage().contains('The product you selected mandates selection of SKU'),
                'Expected SKU validation error not thrown. Actual: ' + e.getMessage()
            );
        }
 
        System.assertEquals('Customer 1', createdSaleOrder.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals('Price List 3', createdSaleOrder.dmpl__PriceListId__r.Name, 'Price list should match');
        System.assertEquals('Within State', createdSaleOrder.dmpl__TaxSupplyType__c, 'Tax supply type should match');
        System.assertEquals('MG Road', createdSaleOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals('Pune', createdSaleOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals('Maharashtra', createdSaleOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals('India', createdSaleOrder.dmpl__BillingCountry__c, 'Billing country should match');
        System.assertEquals('411001', createdSaleOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(System.today(), createdSaleOrder.dmpl__DocumentDate__c, 'Document date should be today');
        System.assertEquals('Draft', createdSaleOrder.dmpl__Status__c, 'Status should be Draft');
        Test.stopTest();
    }
    
    @isTest
    static void addingItemWithIsSKURequiredTrueEditNegative() {
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 8'); 
        dmpl__SKU__c sku = TestDataHelpers.getSku('SKU 2');

        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id,
            partnerAccount1.Id, 
            branch1.Id,
            null,
            null,
            false,
            null
        );

        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            42,
            sku.Id
        );

        dmpl__SaleOrderLine__c soLine = SaleOrderDataHelper.getSaleOrderLine(saleOrder.id);
        System.assertEquals(1500.00, soLine.dmpl__UnitPrice__c, 'Price should match');
        System.assertEquals(8820.00, soLine.dmpl__Tax1__c, 'Tax1 should match');
        System.assertEquals('CGST', soLine.dmpl__Tax1Name__c, 'Tax1 Name should match');
        System.assertEquals(14, soLine.dmpl__Tax1Rate__c, 'Tax1 Rate should match');
        System.assertEquals('CGST', soLine.dmpl__Tax1Type__c, 'Tax1 Type should match');
        System.assertEquals(8820.00, soLine.dmpl__Tax2__c, 'Tax2 should match');
        System.assertEquals('SGST', soLine.dmpl__Tax2Name__c, 'Tax2 Name should match');
        System.assertEquals(14, soLine.dmpl__Tax2Rate__c, 'Tax2 Rate should match');
        System.assertEquals('SGST', soLine.dmpl__Tax2Type__c, 'Tax2 Type should match');
        System.assertEquals(63000.00, soLine.dmpl__BaseAmount__c, 'Base Amount should match');
        System.assertEquals(0.00, soLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should match');
        System.assertEquals(0.00, soLine.dmpl__NetDiscount__c, 'Net Discount should match');
        System.assertEquals(17640.00, soLine.dmpl__TaxAmount__c, 'Tax Amount should match');
        System.assertEquals(80640.00, soLine.dmpl__GrossAmount__c, 'Gross Amount should match');

        dmpl__SaleOrder__c createdSaleOrder2 = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals(63000.00, createdSaleOrder2.dmpl__LineSubTotal__c, 'Line Subtotal should match');
        System.assertEquals(63000.00, createdSaleOrder2.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should match');
        System.assertEquals(0.00, createdSaleOrder2.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should match');
        System.assertEquals(0.00, createdSaleOrder2.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should match');
        System.assertEquals(17640.00, createdSaleOrder2.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount should match');
        System.assertEquals(17640.00, createdSaleOrder2.dmpl__TotalTaxAmount__c, 'Total Tax Amount should match');
        System.assertEquals(80640.00, createdSaleOrder2.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should match');
        System.assertEquals(80640.00, createdSaleOrder2.dmpl__OpenAmount__c, 'Open Amount should match');
        System.assertEquals(80640.00, createdSaleOrder2.dmpl__OutstandingAmount__c, 'Outstanding Amount should match');

        try {
            soLine.dmpl__SKUId__c = null;
            update soLine;
        } catch (DmlException e) {
            System.assert(
                e.getMessage().contains('The product you selected mandates selection of SKU'),
                'Expected SKU validation error not thrown. Actual: ' + e.getMessage()
            );
        }
        Test.stopTest();
    }
    
    @isTest
    static void SchemeApplicabilityForPartnerAccDefinedNew(){
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 4');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 3');
        dmpl__DiscountGroup__c discountGroup = DiscountDataHelper.getDiscountGroup('Discount 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 5');
 
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customer.Id,
            partner.Id,
            branch.Id,
            null,
            null,
            false,
            null
        );

        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            12,
            null    
        );

        dmpl__SaleOrderLine__c orderLine = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals(12, orderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1000, orderLine.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(631.20, orderLine.dmpl__Tax1__c, 'Tax1 should match');
        System.assertEquals('CGST', orderLine.dmpl__Tax1Name__c, 'Tax1 Name should match');
        System.assertEquals(6, orderLine.dmpl__Tax1Rate__c, 'Tax1 Rate should match');
        System.assertEquals('CGST', orderLine.dmpl__Tax1Type__c, 'Tax1 Type should match');
        System.assertEquals(631.20, orderLine.dmpl__Tax2__c, 'Tax2 should match');
        System.assertEquals('SGST', orderLine.dmpl__Tax2Name__c, 'Tax2 Name should match');
        System.assertEquals(6, orderLine.dmpl__Tax2Rate__c, 'Tax2 Rate should match');
        System.assertEquals('SGST', orderLine.dmpl__Tax2Type__c, 'Tax2 Type should match');
        System.assertEquals(12000, orderLine.dmpl__BaseAmount__c, 'Base Amount should match');
        System.assertEquals(1000, orderLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should match');
        System.assertEquals(480, orderLine.dmpl__NetDiscount__c, 'Net Discount should match');
        System.assertEquals(1262.40, orderLine.dmpl__TaxAmount__c, 'Tax Amount should match');
        System.assertEquals(11782.40, orderLine.dmpl__GrossAmount__c, 'Gross Amount should match');
        Test.stopTest();
    }
 
    @isTest
	static void schemeApplicabilityForPartnerAccDefinedEditQuantity1() {
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 4');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 5');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customer.Id,
            partner.Id,
            branch.Id,
            null,
            null,
            false,
            null
        );
    
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            12,
            null
        );
        
        saleOrderLine.dmpl__Quantity__c = 8;
        update saleOrderLine;
        
        saleOrderLine = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        System.assertEquals(8, saleOrderLine.dmpl__Quantity__c, 'Quantity should be 8');
        System.assertEquals(1000, saleOrderLine.dmpl__UnitPrice__c, 'Unit Price mismatch');
        System.assertEquals(8000, saleOrderLine.dmpl__BaseAmount__c, 'Base Amount mismatch');
        System.assertEquals(460.8, saleOrderLine.dmpl__Tax1__c, 'Tax1 mismatch');
        System.assertEquals(460.8, saleOrderLine.dmpl__Tax2__c, 'Tax2 mismatch');
        System.assertEquals(320, saleOrderLine.dmpl__NetDiscount__c, 'Net Discount should be null');
        System.assertEquals(0, saleOrderLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be null');
        System.assertEquals(7680, saleOrderLine.dmpl__Amount__c, 'Amount mismatch');
        System.assertEquals(8601.6, saleOrderLine.dmpl__GrossAmount__c, 'Gross Amount mismatch');
        Test.stopTest();
    }
 
 	@isTest
	static void schemeApplicabilityForPartnerAccDefinedEditQuantity2() {
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 4');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 5');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customer.Id,
            partner.Id,
            branch.Id,
            null,
            null,
            false,
            null
        );
    
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            12,
            null
        );
        
        saleOrderLine.dmpl__Quantity__c = 14;
        update saleOrderLine;
    
        saleOrderLine = SaleOrderDataHelper.getSaleOrderLine( saleOrder.Id);
        System.assertEquals(14, saleOrderLine.dmpl__Quantity__c, 'Quantity should be 14');
        System.assertEquals(1000, saleOrderLine.dmpl__UnitPrice__c);
        System.assertEquals(14000, saleOrderLine.dmpl__BaseAmount__c);
        System.assertEquals(746.4, saleOrderLine.dmpl__Tax1__c);
        System.assertEquals(746.4, saleOrderLine.dmpl__Tax2__c);
        System.assertEquals(560, saleOrderLine.dmpl__NetDiscount__c);
        System.assertEquals(1000, saleOrderLine.dmpl__NetSchemeDiscount__c);
        System.assertEquals(12440, saleOrderLine.dmpl__Amount__c);
        System.assertEquals(13932.80, saleOrderLine.dmpl__GrossAmount__c);
        dmpl__SaleOrder__c updatedOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
    
        System.assertEquals(12440, updatedOrder.dmpl__LineSubTotal__c);
        System.assertEquals(14000, updatedOrder.dmpl__TotalLineBaseAmount__c);
        System.assertEquals(1000, updatedOrder.dmpl__TotalSchemeDiscountAmount__c);
        System.assertEquals(560, updatedOrder.dmpl__TotalDiscountAmount__c);
        System.assertEquals(1492.8, updatedOrder.dmpl__TotalTaxAmount__c);
        System.assertEquals(13932.8, updatedOrder.dmpl__TotalLineGrossAmount__c);
        System.assertEquals(13933, updatedOrder.dmpl__OpenAmount__c);
        System.assertEquals(13932.8, updatedOrder.dmpl__OutstandingAmount__c);
        Test.stopTest();
    }

    @isTest
    static void schemeApplicabilityValiditySchemeHasPassedNewNegative() {
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');

        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
        customerAccount1.Id,
        partnerAccount1.Id,
        branch1.Id,
        null,
        null,
        false,
        null
        );
     
        dmpl__SaleOrder__c createdSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertNotEquals(null, createdSaleOrder.Id, 'Sale Order should be created');
        System.assertEquals('Customer 1', createdSaleOrder.dmpl__AccountName__c, 'Account Name should match');
        System.assertEquals('Within State', createdSaleOrder.dmpl__TaxSupplyType__c, 'Tax Supply Type should match');
        System.assertEquals('MG Road', createdSaleOrder.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals('Pune', createdSaleOrder.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals('Maharashtra', createdSaleOrder.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals('India', createdSaleOrder.dmpl__BillingCountry__c, 'Billing Country should match');
        System.assertEquals(System.today(), createdSaleOrder.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', createdSaleOrder.dmpl__Status__c, 'Status should be Draft');

        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            createdSaleOrder.Id,
            item1.Id,
            15,
            null
        );
        Test.stopTest();

        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(createdSaleOrder.Id);
        System.assertNotEquals(null, createdSOL.Id, 'Sale Order Line should be created');
        System.assertEquals(1500, createdSOL.dmpl__UnitPrice__c, 'Unit Price should be 1500');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(3150, createdSOL.dmpl__Tax1__c, 'Tax1 amount should be 3150');
        System.assertEquals(14, createdSOL.dmpl__Tax1Rate__c, 'Tax1 rate should be 6%');
        System.assertEquals(3150, createdSOL.dmpl__Tax2__c, 'Tax2 amount should be 3150');
        System.assertEquals(14, createdSOL.dmpl__Tax2Rate__c, 'Tax2 rate should be 6%');
        System.assertEquals(6300, createdSOL.dmpl__TaxAmount__c, 'Tax Amount should be 6300');
        System.assertEquals(22500, createdSOL.dmpl__BaseAmount__c, 'Base Amount should be 22500');
        System.assertEquals(0, createdSOL.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0, createdSOL.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(28800, createdSOL.dmpl__GrossAmount__c, 'Gross Amount should be 28800');

        dmpl__SaleOrder__c createdSaleOrder2 = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals(22500, createdSaleOrder2.dmpl__LineSubTotal__c, 'Line Subtotal should be 22500');
        System.assertEquals(22500, createdSaleOrder2.dmpl__TotalLineBaseAmount__c, 'Total Base Amount should be 28800');
        System.assertEquals(0, createdSaleOrder2.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 0');
        System.assertEquals(0, createdSaleOrder2.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 0');
        System.assertEquals(6300, createdSaleOrder2.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 6300');
        System.assertEquals(28800, createdSaleOrder2.dmpl__OpenAmount__c, 'Open Amount should be 28800');
        System.assertEquals(28800, createdSaleOrder2.dmpl__OutstandingAmount__c, 'Outstanding Amount should be 28800');
    }

    @isTest
    static void schemeApplicabilityValiditySchemeHasPassedEditNegative() {
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');

        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
        customerAccount1.Id,
        partnerAccount1.Id,
        branch1.Id,
        null,
        null,
        false,
        null
        );
     
        dmpl__SaleOrder__c createdSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertNotEquals(null, createdSaleOrder.Id, 'Sale Order should be created');
        System.assertEquals('Customer 1', createdSaleOrder.dmpl__AccountName__c, 'Account Name should match');
        System.assertEquals('Within State', createdSaleOrder.dmpl__TaxSupplyType__c, 'Tax Supply Type should match');
        System.assertEquals('MG Road', createdSaleOrder.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals('Pune', createdSaleOrder.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals('Maharashtra', createdSaleOrder.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals('India', createdSaleOrder.dmpl__BillingCountry__c, 'Billing Country should match');
        System.assertEquals(System.today(), createdSaleOrder.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', createdSaleOrder.dmpl__Status__c, 'Status should be Draft');

        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            createdSaleOrder.Id,
            item1.Id,
            15,
            null
        );    

        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(createdSaleOrder.Id);
        System.assertNotEquals(null, createdSOL.Id, 'Sale Order Line should be created');
        System.assertEquals(1500, createdSOL.dmpl__UnitPrice__c, 'Unit Price should be 1500');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(3150, createdSOL.dmpl__Tax1__c, 'Tax1 amount should be 3150');
        System.assertEquals(14, createdSOL.dmpl__Tax1Rate__c, 'Tax1 rate should be 6%');
        System.assertEquals(3150, createdSOL.dmpl__Tax2__c, 'Tax2 amount should be 3150');
        System.assertEquals(14, createdSOL.dmpl__Tax2Rate__c, 'Tax2 rate should be 6%');
        System.assertEquals(6300, createdSOL.dmpl__TaxAmount__c, 'Tax Amount should be 6300');
        System.assertEquals(22500, createdSOL.dmpl__BaseAmount__c, 'Base Amount should be 22500');
        System.assertEquals(0, createdSOL.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0, createdSOL.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(28800, createdSOL.dmpl__GrossAmount__c, 'Gross Amount should be 28800');

        createdSOL.dmpl__Quantity__c = 20;
        update createdSOL;

        dmpl__SaleOrderLine__c updatedSOL = SaleOrderDataHelper.getSaleOrderLine(createdSaleOrder.Id);     
        System.assertNotEquals(null, updatedSOL.Id, 'Sale Order Line should be updated');   
        System.assertEquals(1500, updatedSOL.dmpl__UnitPrice__c, 'Unit Price should be 1500');
        System.assertEquals(30000, updatedSOL.dmpl__BaseAmount__c, 'Base Amount should be 30000');
        System.assertEquals(4200, updatedSOL.dmpl__Tax1__c, 'Tax1 should be 4200');
        System.assertEquals(4200, updatedSOL.dmpl__Tax2__c, 'Tax2 should be 4200');
        System.assertEquals(0, updatedSOL.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0, updatedSOL.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(38400, updatedSOL.dmpl__GrossAmount__c, 'Gross Amount should be 38400');
        System.assertEquals(8400, updatedSOL.dmpl__TaxAmount__c, 'Net Scheme Discount should be 8400');

        dmpl__SaleOrder__c createdSaleOrder2 = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals(30000, createdSaleOrder2.dmpl__LineSubTotal__c, 'Line Subtotal should be 38400');
        System.assertEquals(30000, createdSaleOrder2.dmpl__TotalLineBaseAmount__c, 'Total Base Amount should be 38400');
        System.assertEquals(0, createdSaleOrder2.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 0');
        System.assertEquals(0, createdSaleOrder2.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 0');
        System.assertEquals(8400, createdSaleOrder2.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount should be 8400');
        System.assertEquals(8400, createdSaleOrder2.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 6300');
        System.assertEquals(38400, createdSaleOrder2.dmpl__OpenAmount__c, 'Open Amount should be 38400');
        System.assertEquals(38400, createdSaleOrder2.dmpl__OutstandingAmount__c, 'Outstanding Amount should be 38400');
        Test.stopTest();
    }

    @isTest
    static void saleOrderLineWithSupercedingItemPositive() {
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item15 = TestDataHelpers.getItem('Item 15');
        dmpl__Item__c item16 = TestDataHelpers.getItem('Item 16');

        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id,
            partnerAccount1.Id,
            branch1.Id,
            null,
            null,
            false,
            null
        );

        dmpl__SaleOrder__c createdSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertNotEquals(null, createdSaleOrder.Id, 'Sale Order should be created');
        System.assertEquals('Customer 1', createdSaleOrder.dmpl__AccountName__c, 'Account Name should match');
        System.assertEquals('Price List 1', createdSaleOrder.dmpl__PriceListId__r.Name, 'Price List should match');
        System.assertEquals('Within State', createdSaleOrder.dmpl__TaxSupplyType__c, 'Tax Supply Type should match');
        System.assertEquals('MG Road', createdSaleOrder.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals('Pune', createdSaleOrder.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals('Maharashtra', createdSaleOrder.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals('India', createdSaleOrder.dmpl__BillingCountry__c, 'Billing Country should match');
        System.assertEquals('411001', createdSaleOrder.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');
        System.assertEquals(System.today(), createdSaleOrder.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', createdSaleOrder.dmpl__Status__c, 'Status should be Draft');

        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            createdSaleOrder.Id,
            item15.Id,
            10,
            null
        );
        Test.stopTest();

        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(createdSaleOrder.Id);
        System.assertNotEquals(null, createdSOL.Id, 'Sale Order Line should be created');
        System.assertEquals(item16.Id, createdSOL.dmpl__ItemId__c, 'Item should be superseded to Item 16');
        System.assertEquals(1500, createdSOL.dmpl__UnitPrice__c, 'Unit Price should be 1500');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(2100, createdSOL.dmpl__Tax1__c, 'Tax1 amount should be 2100');
        System.assertEquals(14, createdSOL.dmpl__Tax1Rate__c, 'Tax1 rate should be 14%');
        System.assertEquals(2100, createdSOL.dmpl__Tax2__c, 'Tax2 amount should be 2100');
        System.assertEquals(14, createdSOL.dmpl__Tax2Rate__c, 'Tax2 rate should be 14%');
        System.assertEquals(15000, createdSOL.dmpl__BaseAmount__c, 'Base amount should be 15000');
        System.assertEquals(0, createdSOL.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');  
        System.assertEquals(0, createdSOL.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(4200, createdSOL.dmpl__TaxAmount__c, 'Tax Amount should be 4200');
        System.assertEquals(19200, createdSOL.dmpl__GrossAmount__c, 'Gross Amount should be 19200');

        dmpl__SaleOrder__c updatedSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals(15000, updatedSaleOrder.dmpl__LineSubTotal__c, 'Line Subtotal should be 15000');
        System.assertEquals(15000, updatedSaleOrder.dmpl__TotalLineBaseAmount__c, 'Total Base Amount should be 15000');
        System.assertEquals(0, updatedSaleOrder.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 0');
        System.assertEquals(0, updatedSaleOrder.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 0');
        System.assertEquals(4200, updatedSaleOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 6300');
        System.assertEquals(19200, updatedSaleOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be 19200');
        System.assertEquals(19200.00, updatedSaleOrder.dmpl__OpenAmount__c, 'Open Amount should be 19200.00');
        System.assertEquals(19200, updatedSaleOrder.dmpl__OutstandingAmount__c, 'Outstanding Amount should be 19200');
        System.assertEquals(19200.00, updatedSaleOrder.dmpl__TotalOrderAmount__c, 'Total Order Amount should be 19200.00');
    }
    
    @isTest
    static void editSaleOrderLineWithSupercedingItemPositive() {
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item15 = TestDataHelpers.getItem('Item 15');
        dmpl__Item__c item16 = TestDataHelpers.getItem('Item 16');

        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id,
            partnerAccount1.Id,
            branch1.Id,
            null,
            null,
            false,
            null
        );

        dmpl__SaleOrder__c createdSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertNotEquals(null, createdSaleOrder.Id, 'Sale Order should be created');
        System.assertEquals('Customer 1', createdSaleOrder.dmpl__AccountName__c, 'Account Name should match');
        System.assertEquals('Price List 1', createdSaleOrder.dmpl__PriceListId__r.Name, 'Price List should match');
        System.assertEquals('Within State', createdSaleOrder.dmpl__TaxSupplyType__c, 'Tax Supply Type should match');
        System.assertEquals('MG Road', createdSaleOrder.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals('Pune', createdSaleOrder.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals('Maharashtra', createdSaleOrder.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals('India', createdSaleOrder.dmpl__BillingCountry__c, 'Billing Country should match');
        System.assertEquals('411001', createdSaleOrder.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');
        System.assertEquals(System.today(), createdSaleOrder.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', createdSaleOrder.dmpl__Status__c, 'Status should be Draft');

        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            createdSaleOrder.Id,
            item15.Id,
            10,
            null
        );

        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(createdSaleOrder.Id);
        createdSOL.dmpl__Quantity__c = 5;
        update createdSOL;
        Test.stopTest();

        dmpl__SaleOrderLine__c updatedSOL = SaleOrderDataHelper.getSaleOrderLine(createdSaleOrder.Id);
        System.assertEquals(item16.Id, updatedSOL.dmpl__ItemId__c, 'Item should be superseded to Item 16');
        System.assertEquals(5, updatedSOL.dmpl__Quantity__c, 'Quantity should be updated to 5');
        System.assertEquals(1500, updatedSOL.dmpl__UnitPrice__c, 'Unit Price should be 1500');
        System.assertEquals(7500, updatedSOL.dmpl__BaseAmount__c, 'Base Amount should be 7500');
        System.assertEquals(0, updatedSOL.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(0, updatedSOL.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(14, updatedSOL.dmpl__Tax1Rate__c, 'Tax1 Rate should be 14');
        System.assertEquals(14, updatedSOL.dmpl__Tax2Rate__c, 'Tax2 Rate should be 14');
        System.assertEquals('CGST', updatedSOL.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals('SGST', updatedSOL.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals('CGST', updatedSOL.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', updatedSOL.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(1050, updatedSOL.dmpl__Tax1__c, 'Tax1 should be 1050');
        System.assertEquals(1050, updatedSOL.dmpl__Tax2__c, 'Tax2 should be 1050');
        System.assertEquals(2100, updatedSOL.dmpl__TaxAmount__c, 'Total Tax Amount should be 2100');
        System.assertEquals(9600, updatedSOL.dmpl__GrossAmount__c, 'Gross Amount should be 9600');
    }

    @isTest
    static void createSaleOrderLineWithAlternateItem() {
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item13 = TestDataHelpers.getItem('Item 13');
        dmpl__Item__c item14 = TestDataHelpers.getItem('Item 14');
        dmpl__ItemAlternate__c itemAlternate = TestDataHelpers.getItemAlternate(item14.Id);

        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id,
            partnerAccount1.Id,
            branch1.Id,
            null,
            null,
            false,
            null
        );

        dmpl__SaleOrder__c createdSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertNotEquals(null, createdSaleOrder.Id, 'Sale Order should be created');
        System.assertEquals('Customer 1', createdSaleOrder.dmpl__AccountName__c, 'Account Name should match');
        System.assertEquals('Within State', createdSaleOrder.dmpl__TaxSupplyType__c, 'Tax Supply Type should match');
        System.assertEquals('MG Road', createdSaleOrder.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals('Pune', createdSaleOrder.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals('Maharashtra', createdSaleOrder.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals('India', createdSaleOrder.dmpl__BillingCountry__c, 'Billing Country should match');
        System.assertEquals(System.today(), createdSaleOrder.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', createdSaleOrder.dmpl__Status__c, 'Status should be Draft');

        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            createdSaleOrder.Id,
            item14.Id,
            10,
            null
        );
        Test.stopTest();

        dmpl__SaleOrderLine__c sol = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(createdSaleOrder.Id);
        System.assertNotEquals(null, createdSOL.Id, 'Sale Order Line should be created');
        System.assertEquals(item13.Id, createdSOL.dmpl__ItemId__c, 'Item should be superseded to Item 16');
        System.assertEquals(1500, createdSOL.dmpl__UnitPrice__c, 'Unit Price should be 1500');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(2100, createdSOL.dmpl__Tax1__c, 'Tax 1 should match');
        System.assertEquals(14, createdSOL.dmpl__Tax1Rate__c, 'Tax1 Rate should be 14%');
        System.assertEquals(14, createdSOL.dmpl__Tax2Rate__c, 'Tax2 Rate should be 14%');
        System.assertEquals(2100, createdSOL.dmpl__Tax1__c, 'Tax1 should be 2100');
        System.assertEquals(2100, createdSOL.dmpl__Tax2__c, 'Tax2 should be 2100');
        System.assertEquals(4200, createdSOL.dmpl__TaxAmount__c, 'Total Tax Amount should be 4200');
        System.assertEquals(15000, createdSOL.dmpl__BaseAmount__c, 'Base Amount should be 15000');
        System.assertEquals(0, createdSOL.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(0, createdSOL.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(19200, createdSOL.dmpl__GrossAmount__c, 'Gross Amount should be 19200');
    }

    @isTest
    static void saleOrderLineWithAlternateItemEditPositive() {
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item13 = TestDataHelpers.getItem('Item 13');
        dmpl__Item__c item14 = TestDataHelpers.getItem('Item 14');
        dmpl__ItemAlternate__c itemAlternate = TestDataHelpers.getItemAlternate(item14.Id);

        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id,
            partnerAccount1.Id,
            branch1.Id,
            null,
            null,
            false,
            null
        );

        dmpl__SaleOrder__c createdSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertNotEquals(null, createdSaleOrder.Id, 'Sale Order should be created');
        System.assertEquals('Customer 1', createdSaleOrder.dmpl__AccountName__c, 'Account Name should match');
        System.assertEquals('Within State', createdSaleOrder.dmpl__TaxSupplyType__c, 'Tax Supply Type should match');
        System.assertEquals('MG Road', createdSaleOrder.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals('Pune', createdSaleOrder.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals('Maharashtra', createdSaleOrder.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals('India', createdSaleOrder.dmpl__BillingCountry__c, 'Billing Country should match');
        System.assertEquals(System.today(), createdSaleOrder.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', createdSaleOrder.dmpl__Status__c, 'Status should be Draft');

        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            createdSaleOrder.Id,
            item14.Id,
            10,
            null
        );

        dmpl__SaleOrderLine__c sol = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(createdSaleOrder.Id);
        System.assertNotEquals(null, createdSOL.Id, 'Sale Order Line should be created');
        System.assertEquals(item13.Id, createdSOL.dmpl__ItemId__c, 'Item should be superseded to Item 16');
        System.assertEquals(1500, createdSOL.dmpl__UnitPrice__c, 'Unit Price should be 1500');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(2100, createdSOL.dmpl__Tax1__c, 'Tax 1 should match');
        System.assertEquals(14, createdSOL.dmpl__Tax1Rate__c, 'Tax1 Rate should be 14%');
        System.assertEquals(14, createdSOL.dmpl__Tax2Rate__c, 'Tax2 Rate should be 14%');
        System.assertEquals(2100, createdSOL.dmpl__Tax1__c, 'Tax1 should be 2100');
        System.assertEquals(2100, createdSOL.dmpl__Tax2__c, 'Tax2 should be 2100');
        System.assertEquals(4200, createdSOL.dmpl__TaxAmount__c, 'Total Tax Amount should be 4200');
        System.assertEquals(15000, createdSOL.dmpl__BaseAmount__c, 'Base Amount should be 15000');
        System.assertEquals(0, createdSOL.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(0, createdSOL.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(19200, createdSOL.dmpl__GrossAmount__c, 'Gross Amount should be 19200');

        createdSOL.dmpl__Quantity__c = 5;
        update createdSOL;

        dmpl__SaleOrderLine__c updatedSOL = SaleOrderDataHelper.getSaleOrderLine(createdSaleOrder.Id);
        System.assertNotEquals(null, updatedSOL.Id, 'Sale Order Line should be updated');
        System.assertEquals(item13.Id, updatedSOL.dmpl__ItemId__c, 'Item should be superseded to Item 16');
        System.assertEquals(1500, updatedSOL.dmpl__UnitPrice__c, 'Unit Price should be 1500');
        System.assertEquals('CGST', updatedSOL.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals('SGST', updatedSOL.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals('CGST', updatedSOL.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals('SGST', updatedSOL.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(1050, updatedSOL.dmpl__Tax1__c, 'Tax 1 should match');
        System.assertEquals(14, updatedSOL.dmpl__Tax1Rate__c, 'Tax1 Rate should be 14%');
        System.assertEquals(14, updatedSOL.dmpl__Tax2Rate__c, 'Tax2 Rate should be 14%');
        System.assertEquals(1050, updatedSOL.dmpl__Tax2__c, 'Tax2 should be 1050');
        System.assertEquals(2100, updatedSOL.dmpl__TaxAmount__c, 'Total Tax Amount should be 2100');
        System.assertEquals(7500, updatedSOL.dmpl__BaseAmount__c, 'Base Amount should be 7500');
        System.assertEquals(0, updatedSOL.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(0, updatedSOL.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(9600, updatedSOL.dmpl__GrossAmount__c, 'Gross Amount should be 9600');

        dmpl__SaleOrder__c updatedSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals(7500, updatedSaleOrder.dmpl__LineSubTotal__c, 'Line Subtotal should be 7500');
        System.assertEquals(7500, updatedSaleOrder.dmpl__TotalLineBaseAmount__c, 'Total Base Amount should be 7500');
        System.assertEquals(0, updatedSaleOrder.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 0');
        System.assertEquals(0, updatedSaleOrder.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 0');
        System.assertEquals(2100, updatedSaleOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 2100');
        System.assertEquals(2100, updatedSaleOrder.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount should be 2100');
        System.assertEquals(9600, updatedSaleOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be 9600');
        System.assertEquals(9600, updatedSaleOrder.dmpl__OpenAmount__c, 'Open Amount should be 9600');
        System.assertEquals(9600, updatedSaleOrder.dmpl__OutstandingAmount__c, 'Outstanding Amount should be 9600');
    }


    @isTest
    static void saleOrderSchemeApplicabilityBasedOnUnavailibilityOfBudgetEdit() {
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');

        Test.startTest();

        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount1.Id,
            partnerAccount1.Id,
            branch1.Id,
            null,
            null,
            false,
            null
        );

        
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item1.Id,
            20,  
            null
        );

        dmpl__SaleOrderLine__c createdSOL = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);
    
        System.assertEquals(1500, createdSOL.dmpl__UnitPrice__c, 'Unit Price should be 1500');
        System.assertEquals(4200, createdSOL.dmpl__Tax1__c, 'Tax1 should be 4200');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(14, createdSOL.dmpl__Tax1Rate__c, 'Tax1 Rate should be 14');
        System.assertEquals('CGST', createdSOL.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(4200, createdSOL.dmpl__Tax2__c, 'Tax2 should be 4200');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(14, createdSOL.dmpl__Tax2Rate__c, 'Tax2 Rate should be 14');
        System.assertEquals('SGST', createdSOL.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(30000, createdSOL.dmpl__BaseAmount__c, 'Base Amount should be 30000');
        System.assertEquals(0, createdSOL.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0, createdSOL.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(8400, createdSOL.dmpl__TaxAmount__c, 'Tax Amount should be 8400');
        System.assertEquals(38400, createdSOL.dmpl__GrossAmount__c, 'Gross Amount should be 38400');
        System.assertEquals(null, createdSOL.dmpl__SchemeLineId__c, 'No Scheme Line should be applied');

        dmpl__SaleOrder__c updatedOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals(30000, updatedOrder.dmpl__LineSubTotal__c, 'Line Subtotal should be 30000');

        System.assertEquals(30000, updatedOrder.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be 30000');
        System.assertEquals(0, updatedOrder.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 0');
        System.assertEquals(0, updatedOrder.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 0');
        System.assertEquals(8400, updatedOrder.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount should be 8400');
        System.assertEquals(8400, updatedOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 8400');
        System.assertEquals(38400, updatedOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be 38400');
        System.assertEquals(38400, updatedOrder.dmpl__OpenAmount__c, 'Open Amount should be 38400');
        System.assertEquals(38400, updatedOrder.dmpl__OutstandingAmount__c, 'Outstanding Amount should be 38400');

        createdSOL.dmpl__Quantity__c = 12;
        update createdSOL;

        dmpl__SaleOrderLine__c updatedSOL = SaleOrderDataHelper.getSaleOrderLine(saleOrder.Id);  
        System.assertEquals(1500, updatedSOL.dmpl__UnitPrice__c, 'Unit Price should be 1500');
        System.assertEquals(2520, updatedSOL.dmpl__Tax1__c, 'Tax1 should be 2520');
        System.assertEquals('CGST', updatedSOL.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(14, updatedSOL.dmpl__Tax1Rate__c, 'Tax1 Rate should be 14');
        System.assertEquals('CGST', updatedSOL.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(2520, updatedSOL.dmpl__Tax2__c, 'Tax2 should be 2520');
        System.assertEquals('SGST', updatedSOL.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(14, updatedSOL.dmpl__Tax2Rate__c, 'Tax2 Rate should be 14');
        System.assertEquals('SGST', updatedSOL.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(18000, updatedSOL.dmpl__BaseAmount__c, 'Base Amount should be 18000');
        System.assertEquals(0, updatedSOL.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0, updatedSOL.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(5040, updatedSOL.dmpl__TaxAmount__c, 'Tax Amount should be 5040');
        System.assertEquals(23040, updatedSOL.dmpl__GrossAmount__c, 'Gross Amount should be 23040');
        System.assertEquals(null, updatedSOL.dmpl__SchemeLineId__c, 'No Scheme Line should be applied');

        dmpl__SaleOrder__c finalOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals(18000, finalOrder.dmpl__LineSubTotal__c, 'Line Subtotal should be 18000');
        System.assertEquals(18000, finalOrder.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be 18000');
        System.assertEquals(0, finalOrder.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 0');
        System.assertEquals(0, finalOrder.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 0');
        System.assertEquals(5040, finalOrder.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount should be 5040');
        System.assertEquals(5040, finalOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 5040');
        System.assertEquals(23040, finalOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be 23040');
        System.assertEquals(23040, finalOrder.dmpl__OpenAmount__c, 'Open Amount should be 23040');
        System.assertEquals(23040, finalOrder.dmpl__OutstandingAmount__c, 'Outstanding Amount should be 23040');
        
        Test.stopTest();
    }
    
    @isTest
    static void saleOrderLineQtyAsZeroNewNegative(){       
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');

        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customer.Id,
            partner.Id,
            branch.Id,
            null,
            null,
            false,
            null
        );

        dmpl__SaleOrder__c updatedOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);

            try {
            dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
                saleOrder.Id,
                item.Id,
                0, 
                null
            );
            System.assert(false, 'Exception should have been thrown for zero quantity');
            }catch (DmlException e) {
                System.assert(
                e.getMessage().contains('Quantity should not be less than 0') || 
                e.getMessage().toLowerCase().contains('quantity'), 
                'Expected quantity-related error. Actual message: ' + e.getMessage()
            );
        }
        
        System.assertEquals('Customer 1', updatedOrder.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals('Price List 1', updatedOrder.dmpl__PriceListId__r.Name, 'Price list should match');
        System.assertEquals('Within State', updatedOrder.dmpl__TaxSupplyType__c, 'Tax supply type should match');
        System.assertEquals('MG Road', updatedOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals('Pune', updatedOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals('Maharashtra', updatedOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals('India', updatedOrder.dmpl__BillingCountry__c, 'Billing country should match');
        System.assertEquals('411001', updatedOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(Date.today(), updatedOrder.dmpl__DocumentDate__c, 'Document date should be today');
        System.assertEquals('Draft', updatedOrder.dmpl__Status__c, 'Status should be Draft');
        Test.stopTest();
    }
    
    @isTest
    static void saleOrderLineQuantityZeroEditNegative() {
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount('Customer 3');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 5');

        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customer.Id,
            partner.Id,
            branch.Id,
            null,
            null,
            false,
            null
        );

        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
            saleOrder.Id,
            item.Id,
            5,
            null    
        );

        dmpl__SaleOrder__c finalOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        dmpl__SaleOrderLine__c orderLine = SaleOrderDataHelper.getSaleOrderLine(finalOrder.Id);
        System.assertEquals('Draft', finalOrder.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals('Customer 3', finalOrder.dmpl__AccountName__c, 'Account name should match');
        System.assertEquals('Price List 3', finalOrder.dmpl__PriceListId__r.Name, 'Price list should match');
        System.assertEquals('Within State', finalOrder.dmpl__TaxSupplyType__c, 'Tax supply type should match');
        System.assertEquals('Anna Salai', finalOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals('Chennai', finalOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals('Tamil Nadu', finalOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals('India', finalOrder.dmpl__BillingCountry__c, 'Billing country should match');
        System.assertEquals('600002', finalOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(System.today(), finalOrder.dmpl__DocumentDate__c, 'Document date should be today');

        System.assertEquals(5, orderLine.dmpl__Quantity__c, 'Quantity should be 5');
        System.assertEquals(1000, orderLine.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(288, orderLine.dmpl__Tax1__c, 'Tax1 should match');
        System.assertEquals('CGST', orderLine.dmpl__Tax1Name__c, 'Tax1 Name should match');
        System.assertEquals(6, orderLine.dmpl__Tax1Rate__c, 'Tax1 Rate should match');
        System.assertEquals('CGST', orderLine.dmpl__Tax1Type__c, 'Tax1 Type should match');
        System.assertEquals(288, orderLine.dmpl__Tax2__c, 'Tax2 should match');
        System.assertEquals('SGST', orderLine.dmpl__Tax2Type__c, 'Tax2 Type should match');
        System.assertEquals(5000, orderLine.dmpl__BaseAmount__c, 'Base Amount should match');
        System.assertEquals(0, orderLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should match');
        System.assertEquals(200, orderLine.dmpl__NetDiscount__c, 'Net Discount should match');
        System.assertEquals(576, orderLine.dmpl__TaxAmount__c, 'Tax Amount should match');
        System.assertEquals(5376, orderLine.dmpl__GrossAmount__c, 'Gross Amount should match');

        System.assertEquals(4800, finalOrder.dmpl__LineSubTotal__c, 'Line Subtotal should match');
        System.assertEquals(5000, finalOrder.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should match');
        System.assertEquals(0, finalOrder.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount should match');
        System.assertEquals(200, finalOrder.dmpl__TotalDiscountAmount__c, 'Total Discount should match');
        System.assertEquals(576, finalOrder.dmpl__TotalLineTaxAmount__c, 'Total Line Tax should match');
        System.assertEquals(576, finalOrder.dmpl__TotalTaxAmount__c, 'Total Tax should match');
        System.assertEquals(5376, finalOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross should match');
        System.assertEquals(5376, finalOrder.dmpl__OpenAmount__c, 'Open Amount should match');
        System.assertEquals(5376, finalOrder.dmpl__OutstandingAmount__c, 'Outstanding Amount should match');

        try {
            orderLine.dmpl__Quantity__c = 0;
            update orderLine;
            System.assert(false, 'Exception should have been thrown for zero quantity');
        } catch (DmlException e) {
            System.assert(
                e.getMessage().contains('Quantity should not be less than 0') ||
                e.getMessage().toLowerCase().contains('quantity'),
                'Expected quantity-related error. Actual message: ' + e.getMessage()
            );
        }
        Test.stopTest();
    }

    @isTest
    static void itemSKUWithIsDefaultTrueAddingValidationNegative() {
        Test.startTest();
        Account customerAccount3 = TestDataHelpers.getCustomerAccount('Customer 3');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item7 = TestDataHelpers.getItem('Item 7');

        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(
            customerAccount3.Id,
            partnerAccount1.Id,
            branch1.Id,
            null,
            null,
            false,
            null
        );

        dmpl__SaleOrder__c createdSaleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertNotEquals(null, createdSaleOrder.Id, 'Sale Order should be created');
        System.assertEquals('Customer 3', createdSaleOrder.dmpl__AccountName__c, 'Account Name should match');
        System.assertEquals('Price List 1', createdSaleOrder.dmpl__PriceListId__r.Name, 'Price List should match');
        System.assertEquals('Within State', createdSaleOrder.dmpl__TaxSupplyType__c, 'Tax Supply Type should match');
        System.assertEquals('Anna Salai', createdSaleOrder.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals('Chennai', createdSaleOrder.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals('Tamil Nadu', createdSaleOrder.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals('600002', createdSaleOrder.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');
        System.assertEquals('India', createdSaleOrder.dmpl__BillingCountry__c, 'Billing Country should match');
        System.assertEquals(System.today(), createdSaleOrder.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', createdSaleOrder.dmpl__Status__c, 'Status should be Draft');

        try {
            dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(
                createdSaleOrder.Id,
                item7.Id,
                3,
                null
            );
            System.assert(false, 'Exception should have been thrown for default SKU');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('The product you selected mandates selection of SKU'), 
                          'Expected error message for default SKU. Actual: ' + e.getMessage());
        }
        Test.stopTest();
    }
}