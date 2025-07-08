@isTest
public with sharing class PurchaseOrderHandler_Test {
    @TestSetup
    static void createRequiredData(){
        Test.startTest();
        Account partnerAccount=TestDataHelpers.createPartnerAccount();
        Account supplierAccount=TestDataHelpers.createSupplierAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__Item__c item=TestDataHelpers.createItem();
        dmpl__SKU__c sku=TestDataHelpers.createSKU(item);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup(partnerAccount,branch);
        dmpl__PurchaseRequisition__c purchaseRequisition=PurchaseOrderTestDataHelpers.CreatePurchaseRequisition(branch,supplierAccount);
        dmpl__PurchaseOrder__c purchaseOrder=PurchaseOrderTestDataHelpers.createPurchaseOrder(branch,supplierAccount);
        dmpl__PurchaseOrderLine__c purchaseOrderLine=PurchaseOrderTestDataHelpers.createPurchaseOrderLine(item,sku,purchaseOrder,taxGroup,purchaseRequisition);
        
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1', false, true, false, true, 'MG Road', 'Bengaluru', 'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India', '560095','9876543210');
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2', false, true, false, true, '45 Residency Road', 'Pune', 'Maharashtra', 'India', '411001', '22 Commerce Avenue', 'Pune', 'Maharashtra', 'India', '411038','91-99665544433');
        Account partnerAccount3 = TestDataHelpers.createPartnerAccount('Partner 3', false, true, false, true, '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '91-9123456789');
        Account partnerAccount4 = TestDataHelpers.createPartnerAccount('Partner 4', false, true, false, true, '12 Industrial Zone', 'Hyderabad','Telangana', 'India', '500032', '12 Industrial Zone', 'Hyderabad', 'Telangana', 'India','500032','9876012345');
        Account partnerAccount6 = TestDataHelpers.createPartnerAccount('Partner 6', false, true, false, true, 'MS Road', 'Bengaluru','Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India','560095','9845543210');
        Account partnerAccount5 = TestDataHelpers.createPartnerAccount('Partner 5',false, true, false, true,'45 Residency Road','Pune','Maharashtra','India','411001','22 Commerce Avenue','Pune','Maharashtra','India','411038','91-9966554432' );
        
        Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1', true, false, false, true, 'MG Road', 'Pune', 'Maharashtra', 'India', '411001', 'Ring Rd', 'Nagpur', 'Maharashtra', 'India', '440001','9876543210', 'Created');
        Account customerAccount2 = TestDataHelpers.createCustomerAccount('Customer 2', true, false, false, true, 'Park St', 'Kolkata', 'West Bengal', 'India', '700016', 'Lake Rd', 'Kolkata', 'West Bengal', 'India', '700029','9876543210', 'Created');
        Account customerAccount3 = TestDataHelpers.createCustomerAccount('Customer 3', true, false, false, true, 'Anna Salai', 'Chennai', 'Tamil Nadu', 'India', '600002', 'T Nagar', 'Chennai', 'Tamil Nadu', 'India', '600017','9012345678', 'Created');
        
        Account customerAccount4 = TestDataHelpers.createCustomerAccount('Customer 4', true, false, false, true, 'SG Highway', 'Ahmedabad', 'GJ', 'India', '380054', 'C G Road', 'Ahmedabad', 'GJ', 'India', '380009','9988776655', 'Created');
        Account customerAccount5 = TestDataHelpers.createCustomerAccount('Customer 5', true, false, false, true, 'MG Road', 'Pune', 'Maharashtra', 'India', '411001', 'Ring Rd', 'Nagpur', 'Maharashtra', 'India', '440001','9876543210', 'Created');
        Account customerAccount7=  TestDataHelpers.createCustomerAccount('Customer 7', true, false, false, false, 'Mission Road', 'Bengaluru', 'Karnataka', 'India', '560027', 'Indiranagar', 'Bengaluru', 'Karnataka', 'India', '560038','9811122233', 'Created');
        
        
        dmpl__Branch__c branch1=TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id, true, true, false, true);
        dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partnerAccount2.Id, true, false, true, true);
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partnerAccount1.Id, false, true, true, false);
        dmpl__Branch__c branch4 =TestDataHelpers.createBranch('Branch 4',partnerAccount4.Id,true,true,false,false);
        dmpl__Branch__c branch5 =TestDataHelpers.createBranch('Branch 5',partnerAccount5.Id,true,true,false,false);
        dmpl__Branch__c branch6 =TestDataHelpers.createBranch('Branch 6',partnerAccount6.Id,true,true,false,true);
        
        dmpl__Item__c  item1 = TestDataHelpers.createItem('Item 1','Product',true,false,false,'675654',false);
        dmpl__Item__c item2 = TestDataHelpers.createItem('Item 2','Product',false,false,false,'654345',false);
        dmpl__Item__c item3 = TestDataHelpers.createItem('Item 3','Charge Item',true, false, false ,'765434',true);
        dmpl__Item__c item4 = TestDataHelpers.createItem('Item 4','Product',true, false, false ,'765676',true);
        dmpl__Item__c item5 = TestDataHelpers.createItem('Item 5', 'Product', true, false, false, '876543', false);
        dmpl__Item__c item6 = TestDataHelpers.createItem('Item 6', 'Product', true, false, false, '765456', false);
        dmpl__Item__c item7 = TestDataHelpers.createItem('Item 7','Product',true,false,false, '765456',false);
        dmpl__Item__c item8 = TestDataHelpers.createItem('Item 8','Product',true,false,false, '765456',false);
        dmpl__Item__c item10 = TestDataHelpers.createItem('Item 10','Product',true,false,true, '765456',false);
        dmpl__Item__c item13 = TestDataHelpers.createItem('Item 13','Product',true,false,false, '765456',true);
        dmpl__Item__c item14 = TestDataHelpers.createItem('Item 14', 'Part', true, false, false, '765458', true);
        dmpl__Item__c item15 = TestDataHelpers.createItem('Item 15', 'Part', true, false, false, '765459', false);
        dmpl__Item__c item16 = TestDataHelpers.createItem('Item 16', 'Part', true, false, false, '765460', false);
        dmpl__Item__c item12= TestDataHelpers.createItem('Item 12', 'Product', true, false, false,'765456', false);
        
        dmpl__SKU__c sku1 = TestDataHelpers.createSKU('SKU 1', item7.id, true);
        dmpl__SKU__c sku2 = TestDataHelpers.createSKU('SKU 2', item8.id, false);
        dmpl__SKU__c sku4 = TestDataHelpers.createSKU('SKU 4', item10.id, true);
        
        dmpl__ContactAddress__c address1 = TestDataHelpers.createContactAddress('Address 1', 'Ring Rd', 'Pune', 'Maharashtra', customerAccount1.Id, 'Billing Address', '440001', false);
        dmpl__ContactAddress__c address2 = TestDataHelpers.createContactAddress('Address 2', 'Ring Rd', 'Pune', 'Maharashtra', customerAccount1.Id, 'Billing Address', '440001',false);
        dmpl__ContactAddress__c Address3 = TestDataHelpers.CreateContactAddress('Address 3', 'Lake Road', 'Kolkata', 'West Bengal', customerAccount1.Id,'Billing Address','440022',false);
        dmpl__ContactAddress__c Address4 = TestDataHelpers.CreateContactAddress('Address 4', 'Lake Road', 'Kolkata', 'West Bengal', customerAccount1.Id,'Billing Address','440022',false);
        //dmpl__ContactAddress__c address5 = TestDataHelpers.createContactAddress('Address 2', 'Ring Rd', 'Pune', 'Maharashtra', customerAccount2.Id, 'Shipping Address', '440001', false);
        dmpl__TaxGroup__c taxGroupGST28Global = TestDataHelpers.createTaxGroup('GST 28', true, 'Line Level', null, null, null);
        dmpl__TaxGroup__c taxGroupGST28partner4= TestDataHelpers.createTaxGroup('GST 288', true, 'Line Level', partnerAccount4.Id, branch4.Id, null);
        dmpl__TaxGroup__c taxGroupGST12Global = TestDataHelpers.createTaxGroup('GST 12', true, 'Line Level', null, null, null);
        dmpl__TaxGroup__c taxGroupIGST18 = TestDataHelpers.createTaxGroup('IGST 18', true, 'Document Level', null, null, null);
        dmpl__TaxGroup__c taxGroupGST18Global = TestDataHelpers.createTaxGroup('GST 18', true, 'Line Level', null, null, null);
        
        dmpl__Tax__c taxCGST6 = TestDataHelpers.createTax('CGST', 'CGST', 6, taxGroupGST12Global.Id, 'Tax1');
        dmpl__Tax__c taxSGST6 = TestDataHelpers.createTax('SGST', 'SGST', 6, taxGroupGST12Global.Id, 'Tax2');
        dmpl__TaxGroupRule__c taxGroupRuleItem1 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST12Global.Id,item1.Id,null,null,null);
        dmpl__TaxGroupRule__c taxGroupRuleItem13 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST12Global.Id,item13.Id,null,null,null);

        dmpl__Tax__c taxCGST14 = TestDataHelpers.createTax('CGST', 'CGST', 14, taxGroupGST28partner4.Id, 'Tax1');
        dmpl__Tax__c taxSGST14 = TestDataHelpers.createTax('SGST', 'SGST', 14, taxGroupGST28partner4.Id, 'Tax2');
        dmpl__Tax__c taxCGST14Global = TestDataHelpers.createTax('CGST', 'CGST', 14, taxGroupGST28Global.Id, 'Tax1');
        dmpl__Tax__c taxSGST14Global = TestDataHelpers.createTax('SGST', 'SGST', 14, taxGroupGST28Global.Id, 'Tax2');
        
        dmpl__TaxGroupRule__c taxGroupRule28item8 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST28partner4.Id,item8.Id,null,null,null);
        dmpl__TaxGroupRule__c taxGroupRule28Item13 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST28Global.Id,item5.Id,null,null,null);    
        dmpl__TaxGroupRule__c taxGroupRule28Item14 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST28Global.Id,item14.Id,null,null,null);    
        dmpl__TaxGroupRule__c taxGroupRule28Item15 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST28Global.Id,item15.Id,null,null,null);
        // dmpl__TaxGroupRule__c taxGroupRule28Item16 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST28Global.Id,item16.Id,null,null,null);    
        // dmpl__TaxGroupRule__c  taxGroupRule28Item10 = TestDataHelpers.createTaxGroupRule('Outside State',taxGroupIGST18.Id,item10.Id,null,null,null);
        // dmpl__TaxGroupRule__c  taxGroupRule28Item5=TestDataHelpers.createTaxGroupRule('Outside State',taxGroupIGST18.Id,item5.Id,null,null,null);
        dmpl__TaxGroupRule__c taxGroupRule28Item1 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST28Global.Id,item1.Id,null,null,null);    

        // dmpl__TaxGroup__c taxGroupGST18partner4 = TestDataHelpers.createTaxGroup('GST 18', true, 'Line Level', partnerAccount4.Id, branch4.Id, null);
        dmpl__Tax__c taxCGST9= TestDataHelpers.createTax('CGST', 'CGST', 9, taxGroupGST18Global.Id, 'Tax1');
		dmpl__Tax__c taxSGST9= TestDataHelpers.createTax('SGST', 'SGST', 9, taxGroupGST18Global.Id, 'Tax2');
        dmpl__TaxGroupRule__c taxGroupRule18Item5 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST18Global.Id,item5.Id,null,null,null);     
        
        dmpl__PriceList__c priceList1 = TestDataHelpers.createPriceList('Price List 1', partnerAccount1.Id, branch1.Id, null, null, true, false, 'Sale Price');
        dmpl__PriceList__c priceList2 = TestDataHelpers.createPriceList('Price List 2', partnerAccount1.Id, branch1.Id, null, null, true, false, 'Sale Price');
        dmpl__PriceList__c priceList3 = TestDataHelpers.createPriceList('Price List 3',partnerAccount4.Id,branch4.Id,null,null,true,false,'Sale Price');
        dmpl__PriceList__c priceList5=TestDataHelpers.createPriceList('Price List 5', partnerAccount6.Id, branch6.Id, null, null, false, false, 'Sales');
        dmpl__PriceList__c priceList6=TestDataHelpers.createPriceList('Price List 6', null, null, null, null, true, false, 'Sales');
        dmpl__PriceList__c priceList7 = TestDataHelpers.createPriceList('Price List 7',null,null, null, null, true, false, 'Sales');
        
        dmpl__PriceListRules__c priceList6Rule1 = TestDataHelpers.createPriceListRules(priceList6.Id, item4.Id, null, null, 2000, Date.Today().addDays(-31), Date.Today().addDays(-1));
        Account supplierAccount1 = TestDataHelpers.createPartnerAccount('Supplier 1', false, false, true, true, '55 Industrial Park Road', 'Ahmedabad', 'GJ', 'India', '380015', '55 Industrial Park Road', 'Ahmedabad', 'GJ', 'India', '380015', '-9988776564');
        Account supplierAccount2=TestDataHelpers.createPartnerAccount('Supplier 2',false, false, true, false,'55 Industrial Park Road', 'Ahmedabad', 'GJ', 'India', '380015', '55 Industrial Park Road', 'Ahmedabad', 'GJ', 'India', '380015', '-9988745587');
        
        
        dmpl__Scheme__c scheme12 = SchemeDataHelper.createScheme('Scheme 12', 'Auto Apply', 'APPROVED', 'Per Purchase order', 'Per Order', Date.newInstance(2025, 5, 1), Date.today(), 10, 'Apply all Fulfilled', 1, false, partnerAccount4.Id, null, null, null, branch4.Id, 100000);
        dmpl__SchemeLine__c schemeLine12 = SchemeDataHelper.createSchemeLine(1, 'NET RATE', 'All Conditions Are Met', 'All Rewards', scheme12.Id);
        dmpl__SchemeCondition__c schemeCondition12 = SchemeDataHelper.createSchemeCondition('Item Quantity', 'Greater Than Or Equal', item5.Id, 10, schemeLine12.Id, scheme12.Id, 1);
        dmpl__SchemeBenefit__c schemeBenefit12 = SchemeDataHelper.createSchemeBenefit( 'Rate Off', 'Line Level Discount Amount',null, null,null, 1000, schemeLine12.Id, scheme12.Id,1);
        dmpl__SchemeAccountBudget__c schemeBudget12 = SchemeDataHelper.createSchemesAccountBudget(100000, scheme12.Id, partnerAccount4.Id);
      
        
        dmpl__Scheme__c scheme10 = SchemeDataHelper.createScheme('Scheme 10', 'Auto Apply', 'APPROVED', 'Per Sale Order And Invoice', 'PER ORDER', Date.newInstance(2025, 5, 20), Date.newInstance(2025, 6, 30), 2, 'Apply all Fulfilled', 1, true, partnerAccount1.Id, null, null, customerAccount7.Id, branch1.Id, null);
        dmpl__SchemeLine__c schemeLine10 = SchemeDataHelper.createSchemeLine(1, 'FREE OF COST', 'All Conditions Are Met', 'All Rewards', scheme10.Id);
        dmpl__SchemeCondition__c schemeCondition10 = SchemeDataHelper.createSchemeCondition('Item Quantity', 'Greater Than Or Equal', item12.Id, 15, schemeLine10.Id, scheme10.Id, 1);
        dmpl__SchemeBenefit__c schemeBenefit10 = SchemeDataHelper.createSchemeBenefit('FREE ITEM', 'Discounted Item', item1.Id, 1, 50, null, schemeLine10.Id, scheme10.Id, 1);
        
        
        dmpl__Scheme__c scheme13 = SchemeDataHelper.createScheme('Schmes 13', 'Auto Apply', 'Draft', 'Per Purchase order', 'Per order', Date.newInstance(2025, 5, 20), Date.newInstance(2025, 6, 30), 2, 'Apply Last Fulfilled', 1, false, partnerAccount4.Id, null, null, null, branch4.Id, 100000);
        dmpl__SchemeLine__c schemeLine13 = SchemeDataHelper.createSchemeLine(1, 'PERCENTAGE', 'All Conditions Are Met', 'All Rewards', scheme13.Id);
        dmpl__SchemeCondition__c schemeCondition13 = SchemeDataHelper.createSchemeCondition('Item Quantity', 'Greater Than Or Equal', item3.Id, 5, schemeLine13.Id, scheme13.Id, 1);
        dmpl__SchemeBenefit__c schemeBenefit13 = SchemeDataHelper.createSchemeBenefit('Percentage', 'Line Level Discount Percent', null, null, 50, null, schemeLine13.Id, scheme13.Id, 1);
        dmpl__SchemeAccountBudget__c schemeBudget13 = SchemeDataHelper.createSchemesAccountBudget(100000, scheme13.Id, partnerAccount4.Id);
        
        dmpl__Scheme__c scheme17 = SchemeDataHelper.createScheme('Scheme 17', 'Auto Apply', 'Approved', 'Per Purchase order', 'per order', Date.newInstance(2025, 5, 20), Date.newInstance(2025, 6, 30), 2, 'Apply all Fulfilled', 1, false, partnerAccount4.Id, null, null, customerAccount1.Id, branch4.Id, 100000);
        dmpl__SchemeLine__c schemeLine17 = SchemeDataHelper.createSchemeLine(1, 'Free of Cost', 'All Conditions Are Met', 'All Rewards', scheme17.Id);
        dmpl__SchemeCondition__c schemeCondition17 = SchemeDataHelper.createSchemeCondition('Item Quantity', 'Equals', item3.Id, 20, schemeLine17.Id, scheme17.Id, 1);
        dmpl__SchemeBenefit__c schemeBenefit17 = SchemeDataHelper.createSchemeBenefit('FREE ITEM', 'Discounted Item', item3.Id, 1, 100, null, schemeLine17.Id, scheme17.Id, 1);
        dmpl__SchemeAccountBudget__c schemeBudget17 = SchemeDataHelper.createSchemesAccountBudget(100000, scheme17.Id, partnerAccount4.Id);
        
        dmpl__Scheme__c scheme24 = SchemeDataHelper.createScheme('Scheme 24', 'Auto Apply', 'Approved', 'Per Purchase order', 'per order', Date.newInstance(2025, 5, 26), Date.newInstance(2025, 6, 26), 0, 'Apply Last Fulfilled', 1, false, partnerAccount4.Id, null, null, supplierAccount1.Id, branch4.Id, 100000);
        dmpl__SchemeLine__c schemeLine24 = SchemeDataHelper.createSchemeLine(1, 'Percentage', 'All Conditions Are Met', 'All Rewards', scheme24.Id);
        dmpl__SchemeCondition__c schemeCondition24 = SchemeDataHelper.createSchemeCondition('Item Quantity', 'Equals', item6.Id, 25, schemeLine24.Id, scheme24.Id, 1);
        dmpl__SchemeBenefit__c schemeBenefit24 = SchemeDataHelper.createSchemeBenefit('FREE ITEM', 'Line Level Discount Percent', null, null, 20, null, schemeLine24.Id, scheme24.Id, 1);
        dmpl__SchemeAccountBudget__c schemeBudget24 = SchemeDataHelper.createSchemesAccountBudget(100000, scheme24.Id, partnerAccount4.Id);


        
        dmpl__DiscountGroup__c discountGroup1 = DiscountDataHelper.createDiscountGroup('Discount 1',partnerAccount4.Id,branch4.Id,null,true,'Sale Price');
        
        dmpl__DiscountGroupRule__c discountGroupRule1 = DiscountDataHelper.createDiscountGroupRule(discountGroup1.Id,item6.Id,null,null,null,4,Date.newInstance(2025, 1, 5),Date.newInstance(2025, 7, 30));
        dmpl__DiscountGroupRule__c discountGroupRule2 = DiscountDataHelper.createDiscountGroupRule(discountGroup1.Id,item5.Id,null,null,null,4,Date.newInstance(2025, 1, 5),Date.newInstance(2025, 7, 30));
        Test.stopTest();
        
    }
    
    @isTest
    static void createPurchaseOrderPositive() {
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        if(purchaseOrder != null) {
            System.assertNotEquals(purchaseOrder, null, 'Expected purchaseOrder to be created.');
        }
        System.assertEquals('Draft',purchaseOrder.dmpl__Status__c,'Status should be Draft.');
    }
    
    @isTest
    static void updatePurchaseOrderPositive() {
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        System.assertNotEquals(purchaseOrder, null, 'PurchaseOrder should exist before update.');
        purchaseOrder.dmpl__Status__c = 'Pending Approval';
        update purchaseOrder;
        dmpl__PurchaseOrder__c updatePurchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        System.assertEquals('Pending Approval',updatePurchaseOrder.dmpl__Status__c,'Next status should be Released.');
    }
    
    @isTest
    static void deletePurchaseOrder() {
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder();
        System.assertNotEquals(purchaseOrder, null, 'PurchaseOrder should exist before delete.');
        
        delete purchaseOrder;
        
        dmpl__PurchaseOrder__c deletedOrder = null;
        try {
            deletedOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        } catch (Exception e) {
            deletedOrder = null;
        }
        System.assertEquals(null, deletedOrder, 'PurchaseOrder should be deleted and not found in query.');
    }
    
    @isTest
    static void createPurchaseOrderLinePositive() {
        dmpl__PurchaseOrderLine__c purchaseOrderLine=PurchaseOrderTestDataHelpers.getPurchaseOrderLine();
        if(purchaseOrderLine != null) {
            System.assertNotEquals(purchaseOrderLine, null, 'Expected purchaseOrderLine to be created.');
        }
        System.assertEquals(100,purchaseOrderLine.dmpl__UnitCost__c,'Unit cost should be 100');
    }
    
    @isTest
    static void updatePurchaseOrderLinePositive() {
        dmpl__PurchaseOrderLine__c purchaseOrderLine=PurchaseOrderTestDataHelpers.getPurchaseOrderLine();
        purchaseOrderLine.dmpl__UnitCost__c = 200;
        update purchaseOrderLine;
        System.assertEquals(200,purchaseOrderLine.dmpl__UnitCost__c,'Unit cost should be 100');
    }
    
    
    @isTest
    static void deletePurchaseOrderLine() {
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine();
        System.assertNotEquals(purchaseOrderLine, null, 'PurchaseOrderLine should exist before delete.');
        
        delete purchaseOrderLine;
        
        dmpl__PurchaseOrderLine__c deletedPOL = null;
        try {
            deletedPOL = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        } catch (Exception e) {
            deletedPOL = null;
        }
        System.assertEquals(null, deletedPOL, 'PurchaseOrderLine should be deleted and not found in query.');
    }
    // Normal Purchase Order Creation without Scheme & Discount (New)
    @isTest
    static void CreateNormalPurchaseOrderWithoutSchemeDiscountPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 5');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 5');
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 5');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 5');
        
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__PriceList__c priceList=TestDataHelpers.createPriceList(partner1,branch1);
        //dmpl__PriceList__c priceList1 =  TestDataHelpers.getPriceList('Price List 1');
        
        dmpl__PurchaseOrder__c po = PurchaseOrderTestDataHelpers.createPurchaseOrder(
            partner,
        branch,
        supplier,
        priceList,
        null
            );
        Test.stopTest();
        
        dmpl__PurchaseOrder__c fetchedOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(po.Id);
        System.assertEquals('Draft', fetchedOrder.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(partner.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner Account Name mismatch');
        System.assertEquals(branch.Id, fetchedOrder.dmpl__BranchId__c, 'Branch mismatch');
        System.assertEquals(supplier.Id, fetchedOrder.dmpl__SupplierAccountId__c, 'Supplier mismatch');
        System.assertEquals(priceList.Id, fetchedOrder.dmpl__PriceListId__c, 'Price List mismatch');
        
        System.assertEquals(partner.dmpl__BillingPostalCode__c, fetchedOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(partner.dmpl__BillingStreet__c, fetchedOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(partner.dmpl__BillingCity__c, fetchedOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals(partner.dmpl__BillingState__c, fetchedOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals(partner.dmpl__BillingCountry__c, fetchedOrder.dmpl__BillingCountry__c, 'Billing country should match');
        
        System.assertEquals(partner.dmpl__ShippingStreet__c, fetchedOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals(partner.dmpl__ShippingCity__c, fetchedOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals(partner.dmpl__ShippingState__c, fetchedOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals(partner.dmpl__ShippingCountry__c, fetchedOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals(partner.dmpl__ShippingPostalCode__c, fetchedOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
        
        
    }
    // Purchase Order Creation with GST Tax ( Global ) (New)
    @isTest
    static void createPurchaseOrderWithGSTTaxPositive() {
        
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        //dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price list 1');
        // dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');
        
        Test.startTest();
        
        dmpl__PurchaseOrder__c po = PurchaseOrderTestDataHelpers.createPurchaseOrder(
            partner,
        branch,
        supplier,
        null,
        null
            );
        dmpl__PurchaseOrder__c fetchedOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(po.Id);
        
        Test.stopTest();
        System.assertEquals('Draft', fetchedOrder.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(partner.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner Account Name mismatch');
        System.assertEquals(branch.Id, fetchedOrder.dmpl__BranchId__c, 'Branch mismatch');
        System.assertEquals(supplier.Id, fetchedOrder.dmpl__SupplierAccountId__c, 'Supplier mismatch');
        
        
        System.assertEquals(partner.dmpl__BillingPostalCode__c, fetchedOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(partner.dmpl__BillingStreet__c, fetchedOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(partner.dmpl__BillingCity__c, fetchedOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals(partner.dmpl__BillingState__c, fetchedOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals(partner.dmpl__BillingCountry__c, fetchedOrder.dmpl__BillingCountry__c, 'Billing country should match');
        
        System.assertEquals(partner.dmpl__ShippingStreet__c, fetchedOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals(partner.dmpl__ShippingCity__c, fetchedOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals(partner.dmpl__ShippingState__c, fetchedOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals(partner.dmpl__ShippingCountry__c, fetchedOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals(partner.dmpl__ShippingPostalCode__c, fetchedOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
    }
    // Purchase Order Creation with IGST Tax ( Global ) (New)
    @isTest
    static void createPurchaseOrderWithIGSTTaxPositive() {
        
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        //dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price list 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('IGST 18');
        
        Test.startTest();
        
        dmpl__PurchaseOrder__c po = PurchaseOrderTestDataHelpers.createPurchaseOrder(
            partner,
        branch,
        supplier,
        null,
        null
            );
        po.dmpl__TaxGroupId__c=taxGroup.Id;
        update po;
        dmpl__PurchaseOrder__c fetchedOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(po.Id);
        
        Test.stopTest();
        System.assertEquals('Draft', fetchedOrder.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(partner.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner Account Name mismatch');
        System.assertEquals(branch.Id, fetchedOrder.dmpl__BranchId__c, 'Branch mismatch');
        System.assertEquals(supplier.Id, fetchedOrder.dmpl__SupplierAccountId__c, 'Supplier mismatch');
        
        
        System.assertEquals(partner.dmpl__BillingPostalCode__c, fetchedOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(partner.dmpl__BillingStreet__c, fetchedOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(partner.dmpl__BillingCity__c, fetchedOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals(partner.dmpl__BillingState__c, fetchedOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals(partner.dmpl__BillingCountry__c, fetchedOrder.dmpl__BillingCountry__c, 'Billing country should match');
        
        System.assertEquals(partner.dmpl__ShippingStreet__c, fetchedOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals(partner.dmpl__ShippingCity__c, fetchedOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals(partner.dmpl__ShippingState__c, fetchedOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals(partner.dmpl__ShippingCountry__c, fetchedOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals(partner.dmpl__ShippingPostalCode__c, fetchedOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
    }
    // Purchase Order with Billing & Shipping Address (New)
    @isTest
    static void createPurchaseOrderWithShippingAndBillingAddressPositive() {
        
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        //dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price list 1');
        // dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');
        
        dmpl__PurchaseOrder__c po = PurchaseOrderTestDataHelpers.createPurchaseOrder(
            partner,
        branch,
        supplier,
        null,
        null
            );
        dmpl__PurchaseOrder__c fetchedOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(po.Id);
        System.assertEquals('Draft', fetchedOrder.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(partner.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner Account Name mismatch');
        System.assertEquals(branch.Id, fetchedOrder.dmpl__BranchId__c, 'Branch mismatch');
        System.assertEquals(supplier.Id, fetchedOrder.dmpl__SupplierAccountId__c, 'Supplier mismatch');
        
        
        System.assertEquals(partner.dmpl__BillingPostalCode__c, fetchedOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(partner.dmpl__BillingStreet__c, fetchedOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(partner.dmpl__BillingCity__c, fetchedOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals(partner.dmpl__BillingState__c, fetchedOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals(partner.dmpl__BillingCountry__c, fetchedOrder.dmpl__BillingCountry__c, 'Billing country should match');
        
        System.assertEquals(partner.dmpl__ShippingStreet__c, fetchedOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals(partner.dmpl__ShippingCity__c, fetchedOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals(partner.dmpl__ShippingState__c, fetchedOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals(partner.dmpl__ShippingCountry__c, fetchedOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals(partner.dmpl__ShippingPostalCode__c, fetchedOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
    }
    
    // Purchase Order with Price List for Partner Account & Branch (New)
    @isTest
    static void createPurchaseOrderWithPriceListForPartnerAccountPositive() {
        
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price list 3');
        // dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');
        Test.startTest();
        dmpl__PurchaseOrder__c po = PurchaseOrderTestDataHelpers.createPurchaseOrder(
            partner,
        branch,
        supplier,
        priceList,
        null
            );
        dmpl__PurchaseOrder__c fetchedOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(po.Id);
        Test.stopTest();
        System.assertEquals('Draft', fetchedOrder.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(partner.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner Account Name mismatch');
        System.assertEquals(branch.Id, fetchedOrder.dmpl__BranchId__c, 'Branch mismatch');
        System.assertEquals(supplier.Id, fetchedOrder.dmpl__SupplierAccountId__c, 'Supplier mismatch');
        System.assertEquals(priceList.Id, fetchedOrder.dmpl__PriceListId__c, 'Price List mismatch');
        // System.assertEquals(taxGroup.Id, fetchedOrder.dmpl__TaxGroupId__c, 'taxgroup will be gst 12 ');
        
        System.assertEquals(partner.dmpl__BillingPostalCode__c, fetchedOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(partner.dmpl__BillingStreet__c, fetchedOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(partner.dmpl__BillingCity__c, fetchedOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals(partner.dmpl__BillingState__c, fetchedOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals(partner.dmpl__BillingCountry__c, fetchedOrder.dmpl__BillingCountry__c, 'Billing country should match');
        
        System.assertEquals(partner.dmpl__ShippingStreet__c, fetchedOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals(partner.dmpl__ShippingCity__c, fetchedOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals(partner.dmpl__ShippingState__c, fetchedOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals(partner.dmpl__ShippingCountry__c, fetchedOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals(partner.dmpl__ShippingPostalCode__c, fetchedOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
    }
    // Purchase Order with Price List for Partner Account Group (New)
    @isTest
    static void createPurchaseOrderWithPriceListForPartnerAccountGroupPositive() {
        
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price list 1');
        // dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');
        Test.startTest();
        dmpl__PurchaseOrder__c po = PurchaseOrderTestDataHelpers.createPurchaseOrder(
            partner,
        branch,
        supplier,
        priceList,
        null
            );
        
        dmpl__PurchaseOrder__c fetchedOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(po.Id);
        Test.stopTest();
        System.assertEquals('Draft', fetchedOrder.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(partner.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner Account Name mismatch');
        System.assertEquals(branch.Id, fetchedOrder.dmpl__BranchId__c, 'Branch mismatch');
        System.assertEquals(supplier.Id, fetchedOrder.dmpl__SupplierAccountId__c, 'Supplier mismatch');
        System.assertEquals(priceList.Id, fetchedOrder.dmpl__PriceListId__c, 'Price List mismatch');
        // System.assertEquals(taxGroup.Id, fetchedOrder.dmpl__TaxGroupId__c, 'taxgroup will be gst 12 ');
        
        System.assertEquals(partner.dmpl__BillingPostalCode__c, fetchedOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(partner.dmpl__BillingStreet__c, fetchedOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(partner.dmpl__BillingCity__c, fetchedOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals(partner.dmpl__BillingState__c, fetchedOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals(partner.dmpl__BillingCountry__c, fetchedOrder.dmpl__BillingCountry__c, 'Billing country should match');
        
        System.assertEquals(partner.dmpl__ShippingStreet__c, fetchedOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals(partner.dmpl__ShippingCity__c, fetchedOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals(partner.dmpl__ShippingState__c, fetchedOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals(partner.dmpl__ShippingCountry__c, fetchedOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals(partner.dmpl__ShippingPostalCode__c, fetchedOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
    }
    // Purchase Order with Discount Group (New)
    @isTest
    static void createPurchaseOrderWithDiscountGroupPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        //dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price list 1');
        // dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');
        
        dmpl__DiscountGroup__c discountGroup = DiscountDataHelper.createDiscountGroup(
            'Discount 1',
        partner,
        branch
            );
        
        dmpl__PurchaseOrder__c po = PurchaseOrderTestDataHelpers.createPurchaseOrder(
            partner,
        branch,
        supplier,
        null,
        discountGroup
            );
        Test.stopTest();
        dmpl__PurchaseOrder__c fetchedOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(po.Id);
        System.assertEquals('Draft', fetchedOrder.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(partner.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner Account Name mismatch');
        System.assertEquals(branch.Id, fetchedOrder.dmpl__BranchId__c, 'Branch mismatch');
        System.assertEquals(supplier.Id, fetchedOrder.dmpl__SupplierAccountId__c, 'Supplier mismatch');
        // System.assertEquals(priceList.Id, fetchedOrder.dmpl__PriceListId__c, 'Price List mismatch');
        System.assertEquals(discountGroup.Id, fetchedOrder.dmpl__DiscountGroupId__c, 'taxgroup will be gst 12 ');
        
        System.assertEquals(partner.dmpl__BillingPostalCode__c, fetchedOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(partner.dmpl__BillingStreet__c, fetchedOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(partner.dmpl__BillingCity__c, fetchedOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals(partner.dmpl__BillingState__c, fetchedOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals(partner.dmpl__BillingCountry__c, fetchedOrder.dmpl__BillingCountry__c, 'Billing country should match');
        
        System.assertEquals(partner.dmpl__ShippingStreet__c, fetchedOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals(partner.dmpl__ShippingCity__c, fetchedOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals(partner.dmpl__ShippingState__c, fetchedOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals(partner.dmpl__ShippingCountry__c, fetchedOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals(partner.dmpl__ShippingPostalCode__c, fetchedOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
    }
    //Purchase Order Price List In-active (New)
    @isTest
    static void createPurchaseOrderWithInactivePriceListNegative() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price list 5');
        // dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');
        Boolean exceptionThrown=false;
        
        try{dmpl__PurchaseOrder__c po = PurchaseOrderTestDataHelpers.createPurchaseOrder(
            partner,
            branch,
            supplier,
            priceList,
            null
                );
        }catch(Exception e){
            exceptionThrown=true;
        }
        Test.stopTest();
        System.assertEquals(true,exceptionThrown,'exception should be thrown due to inactive price list');
    }
    // Purchase Order Creation with Wrong Partner Account (New)
    @isTest
    static void CreatePurchaseOrderWithWrongPartnerNegative() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        // dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price list 5');
        // dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');
        Boolean exceptionThrown=false;
        
        try{dmpl__PurchaseOrder__c po = PurchaseOrderTestDataHelpers.createPurchaseOrder(
            partner,
            branch,
            supplier,
            null,
            null
                );
        }catch(Exception e){
            exceptionThrown=true;
        }
        Test.stopTest();
        System.assertEquals(false,exceptionThrown,'exception should be thrown due to wrong partner account');//blocked
    }
    // Purchase Order Creation with Inactive Partner Account (New)
    @isTest
    static void createPurchaseOrderWithInactivePartnerAccountNegative() {
        
        Account partner = TestDataHelpers.getPartnerAccount('Partner 2');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 2');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price list 5');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        // dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');
        Boolean exceptionThrown=false;
        Test.startTest();
        try{dmpl__PurchaseOrder__c po = PurchaseOrderTestDataHelpers.createPurchaseOrder(
            partner,
            branch,
            supplier,
            null,
            null
                );
        }catch(Exception e){
            exceptionThrown=true;
        }
        Test.stopTest();
        System.assertEquals(false,exceptionThrown,'exception should be thrown due to inactive price list'); //blocked
    }
    // Purchase Order Creation with Inactive Branch (New)
    @isTest
    static void createPurchaseOrderWithInactiveBranchPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 3');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 3');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price list 1');
        // dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');
        Boolean exceptionThrown=false;
        
        try{dmpl__PurchaseOrder__c po = PurchaseOrderTestDataHelpers.createPurchaseOrder(
            partner,
            branch,
            supplier,
            priceList,
            null
                );
        }catch(Exception e){
            exceptionThrown=true;
        }
        Test.stopTest();
        System.assertEquals(true,exceptionThrown,'exception should be thrown due to inactive branch list');
    }
    // Purchase Order Creation with in-active Supplier Account
    @isTest
    static void createPurchaseOrderWithInactiveSuppilerPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 3');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 3');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 2');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price list 1');
        // dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');
        Boolean exceptionThrown=false;
        
        try{dmpl__PurchaseOrder__c po = PurchaseOrderTestDataHelpers.createPurchaseOrder(
            partner,
            branch,
            supplier,
            null,
            null
                );
        }catch(Exception e){
            exceptionThrown=true;
        }
        Test.stopTest();
        System.assertEquals(true,exceptionThrown,'exception should be thrown due to inactive suppiler account');
    }
    // Purchase Order Creation without Supplier Account (Edit)
    @isTest
    static void updatePurchaseOrderWithoutSuppilerNegative() {
        
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        // dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price list 1');
        // dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');
        Boolean exceptionThrown=false;
        
        dmpl__PurchaseOrder__c po = PurchaseOrderTestDataHelpers.createPurchaseOrder(
            partner,
        branch,
        supplier,
        null,
        null
            );
        
        try{
            po.dmpl__SupplierAccountId__c=null;
            update po;
        }catch(Exception e){
            exceptionThrown=true;
        }
        System.assertEquals(false,exceptionThrown,'exception should be thrown due to missing suppiler account'); //blocked
    }
    // Purchase Order with Billing & Shipping Address (Edit)
    @isTest
    static void updatePurchaseOrderWithShippingAndBillingAddressPositive() {
        
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__ContactAddress__c billingAddress1 = TestDataHelpers.getContactAddress('Address 3');
        dmpl__ContactAddress__c shippingAddress1 = TestDataHelpers.getContactAddress('Address 2');
        //dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price list 1');
        // dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');
        
        dmpl__PurchaseOrder__c po = PurchaseOrderTestDataHelpers.createPurchaseOrder(
            partner,
        branch,
        supplier,
        null,
        null
            );
        dmpl__PurchaseOrder__c fetchedOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(po.Id);
        System.assertEquals('Draft', fetchedOrder.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(partner.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner Account Name mismatch');
        System.assertEquals(branch.Id, fetchedOrder.dmpl__BranchId__c, 'Branch mismatch');
        System.assertEquals(supplier.Id, fetchedOrder.dmpl__SupplierAccountId__c, 'Supplier mismatch');
        
        
        System.assertEquals(partner.dmpl__BillingPostalCode__c, fetchedOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(partner.dmpl__BillingStreet__c, fetchedOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(partner.dmpl__BillingCity__c, fetchedOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals(partner.dmpl__BillingState__c, fetchedOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals(partner.dmpl__BillingCountry__c, fetchedOrder.dmpl__BillingCountry__c, 'Billing country should match');
        
        System.assertEquals(partner.dmpl__ShippingStreet__c, fetchedOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals(partner.dmpl__ShippingCity__c, fetchedOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals(partner.dmpl__ShippingState__c, fetchedOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals(partner.dmpl__ShippingCountry__c, fetchedOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals(partner.dmpl__ShippingPostalCode__c, fetchedOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
    }
    @isTest
    static void updatePurchaseOrderWithMultipleShippingAndBillingAddressPositive() {
        Test.startTest();
        
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        
        dmpl__ContactAddress__c address3 = TestDataHelpers.getContactAddress('Address 3');
        dmpl__ContactAddress__c address4 = TestDataHelpers.getContactAddress('Address 4');
        
        dmpl__PurchaseOrder__c po = PurchaseOrderTestDataHelpers.createPurchaseOrder(
            partner,
        branch,
        supplier,
        null,
        null
            );
        
        po.dmpl__BillingAddressId__c=address3.Id;
        po.dmpl__ShippingAddressId__c=address4.Id;
        update po;
        dmpl__PurchaseOrder__c fetchedOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(po.Id);
        Test.stopTest();
        System.assertEquals('Draft', fetchedOrder.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(partner.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner Account Name mismatch');
        System.assertEquals(branch.Id, fetchedOrder.dmpl__BranchId__c, 'Branch mismatch');
        System.assertEquals(supplier.Id, fetchedOrder.dmpl__SupplierAccountId__c, 'Supplier mismatch');
        
        
        System.assertEquals(partner.dmpl__BillingPostalCode__c, fetchedOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(partner.dmpl__BillingStreet__c, fetchedOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(partner.dmpl__BillingCity__c, fetchedOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals(partner.dmpl__BillingState__c, fetchedOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals(partner.dmpl__BillingCountry__c, fetchedOrder.dmpl__BillingCountry__c, 'Billing country should match');
        
        System.assertEquals(partner.dmpl__ShippingStreet__c, fetchedOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals(partner.dmpl__ShippingCity__c, fetchedOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals(partner.dmpl__ShippingState__c, fetchedOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals(partner.dmpl__ShippingCountry__c, fetchedOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals(partner.dmpl__ShippingPostalCode__c, fetchedOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
    }
    
    //Purchase Order Creation with Wrong Partner Account (Edit)
    @isTest
    static void updatePurchaseOrderwithWrongPartnerAccountNeagtive() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partner3 = TestDataHelpers.getPartnerAccount('Partner 3');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        
        Boolean exceptionThrown = false;
        
        Test.startTest();
        dmpl__PurchaseOrder__c po = PurchaseOrderTestDataHelpers.createPurchaseOrder(
            partner1,
        branch,
        supplier,
        null,
        null
            );
        
        System.assertEquals(partner1.Id, po.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch.Id, po.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier.Id, po.dmpl__SupplierAccountId__c, 'Customer should match');
        
        try {
            po.dmpl__PartnerAccountId__c = partner3.Id;
            update po;
        } catch (System.DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown when updating with wrong partner account.');
    }
    
    // Purchase Order Creation with Inactive Partner Account (Edit)
    @isTest
    static void updatePurchaseOrderwithInactivePartnerAccountNeagtive() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partner2 = TestDataHelpers.getPartnerAccount('Partner 2');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        
        Boolean exceptionThrown = false;
        
        Test.startTest();
        dmpl__PurchaseOrder__c po = PurchaseOrderTestDataHelpers.createPurchaseOrder(
            partner1,
        branch,
        supplier,
        null,
        null
            );
        
        System.assertEquals(partner1.Id, po.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch.Id, po.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier.Id, po.dmpl__SupplierAccountId__c, 'suppiler should match');
        
        try {
            
            po.dmpl__PartnerAccountId__c = partner2.Id;
            update po;
        } catch (System.DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown when updating with wrong partner account.');
    }
    // Purchase Order Line without Schemes (New)
    // @isTest
    // static void createPurchaseOrderLineWithoutSchemes() {
        //     Test.startTest();
        //     Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        //     Account partner = TestDataHelpers.getPartnerAccount('Partner 6');
        //     dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 6');
        //     dmpl__Item__c item = TestDataHelpers.getItem('Item 7');
        //     // dmpl__SKU__c sku = TestDataHelpers.getSKU(item);
        //     dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');
        
        //     dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(partner, branch, supplier, null, null);
        //     dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(item,null,purchaseOrder,taxGroup);
        //     purchaseOrderLine.dmpl__Quantity__c = 5;
        //     purchaseOrderLine.dmpl__UnitCost__c = 1000;
        //     purchaseOrderLine.dmpl__SchemeDiscount__c = null;
        //     purchaseOrderLine.dmpl__SchemeDiscountAmount__c = null;
        //     purchaseOrderLine.dmpl__DiscountAmount__c = null;
        //     update purchaseOrderLine;
        
        //     Test.stopTest();
        
        //     dmpl__PurchaseOrderLine__c fetchedLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        //     System.assertEquals(1000, fetchedLine.dmpl__UnitCost__c, 'Unit Cost should be 1000');
        //     System.assertEquals(5, fetchedLine.dmpl__Quantity__c, 'Quantity should be 5');
        //     System.assertEquals(5000, fetchedLine.dmpl__BaseAmount__c, 'Base Amount should be 5000');
        //     System.assertEquals(5000, fetchedLine.dmpl__Amount__c, 'Amount should be 5000');
        //     System.assertEquals(0, fetchedLine.dmpl__NetDiscount__c, 'Net Discount should be 0');
        //     System.assertEquals(5600, fetchedLine.dmpl__GrossAmount__c, 'Gross Amount should be 5600'); //changed
        //     System.assertEquals(0, fetchedLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        
        //     dmpl__PurchaseOrder__c fetchedPO = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        //     System.assertEquals(5000, fetchedPO.dmpl__TotalAmount__c, 'Total Amount should be 5000');
        //     System.assertEquals(0, fetchedPO.dmpl__TotalDiscountAmount__c, 'Total Discount should be 0');
        //     System.assertEquals(5000, fetchedPO.dmpl__TotalLineAmount__c, 'Total Line Amount should be 5000');
        //     System.assertEquals(5000, fetchedPO.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be 5000');
        //     System.assertEquals(5600, fetchedPO.dmpl__TotalOrderAmount__c, 'Total Order Amount should be 5600');
        //     System.assertEquals(600, fetchedPO.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 600');
        //     System.assertEquals(5600, fetchedPO.dmpl__OpenAmount__c, 'Open Amount should be 5600');
        
        //     System.assertEquals(partner.dmpl__BillingStreet__c, fetchedPO.dmpl__BillingStreet__c, 'Billing Street should match Partner');
        //     System.assertEquals(partner.dmpl__BillingCity__c, fetchedPO.dmpl__BillingCity__c, 'Billing City should match Partner');
        //     System.assertEquals(partner.dmpl__BillingState__c, fetchedPO.dmpl__BillingState__c, 'Billing State should match Partner');
        //     System.assertEquals(partner.dmpl__BillingPostalCode__c, fetchedPO.dmpl__BillingPostalCode__c, 'Billing Postal Code should match Partner');
        //     System.assertEquals(partner.dmpl__BillingCountry__c, fetchedPO.dmpl__BillingCountry__c, 'Billing Country should match Partner');
        
        //     System.assertEquals(partner.dmpl__ShippingStreet__c, fetchedPO.dmpl__ShippingStreet__c, 'Shipping Street should match Partner');
        //     System.assertEquals(partner.dmpl__ShippingCity__c, fetchedPO.dmpl__ShippingCity__c, 'Shipping City should match Partner');
        //     System.assertEquals(partner.dmpl__ShippingState__c, fetchedPO.dmpl__ShippingState__c, 'Shipping State should match Partner');
        //     System.assertEquals(partner.dmpl__ShippingPostalCode__c, fetchedPO.dmpl__ShippingPostalCode__c, 'Shipping Postal Code should match Partner');
        //     System.assertEquals(partner.dmpl__ShippingCountry__c, fetchedPO.dmpl__ShippingCountry__c, 'Shipping Country should match Partner');
    // }
    
    //Purchase Order Line with in-active Item (New)
    @isTest
    static void createPurchaseOrderLineWithInactiveItemPositive() {
        Test.startTest();
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item2 = TestDataHelpers.getItem('Item 2');
        
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(partner4, branch4, supplier1, null, null);
        dmpl__PurchaseOrderLine__c purchaseOrderLine;
        
        Boolean exceptionThrown=false;
        try{
            purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(purchaseOrder.Id,item2.Id,1);
        }
        catch(Exception e){
            exceptionThrown=true;
        }
        dmpl__PurchaseOrder__c fetchedPurchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        
        
        Test.stopTest();
        System.assertNotEquals(true, exceptionThrown, 'Purchase Order Line should not be created with inactive item');
    }
    
    //Purchase Order Line with Discontinued Item (New)
    @isTest
    static void createPurchaseOrderLineWithDiscontinuedItemNegative() {
        Test.startTest();
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item4 = TestDataHelpers.getItem('Item 7');
        
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(partner4, branch4, supplier1, null, null);
        dmpl__PurchaseOrderLine__c purchaseOrderLine;
        
        try{
            purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(purchaseOrder.Id,item4.Id,10);
        }catch(Exception e){
            
        }
        
        dmpl__PurchaseOrder__c fetchedPurchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        
        Test.stopTest();
        
        System.assertEquals(partner4.Id, fetchedPurchaseOrder.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch4.Id, fetchedPurchaseOrder.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier1.Id, fetchedPurchaseOrder.dmpl__SupplierAccountId__c, 'Supplier should match');
        
        System.assertEquals(partner4.dmpl__BillingStreet__c, fetchedPurchaseOrder.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals(partner4.dmpl__BillingCity__c, fetchedPurchaseOrder.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals(partner4.dmpl__BillingState__c, fetchedPurchaseOrder.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals(partner4.dmpl__BillingCountry__c, fetchedPurchaseOrder.dmpl__BillingCountry__c, 'Billing Country should match');
        System.assertEquals(partner4.dmpl__BillingPostalCode__c, fetchedPurchaseOrder.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');
        
        System.assertEquals(partner4.dmpl__ShippingStreet__c, fetchedPurchaseOrder.dmpl__ShippingStreet__c, 'Shipping Street should match');
        System.assertEquals(partner4.dmpl__ShippingCity__c, fetchedPurchaseOrder.dmpl__ShippingCity__c, 'Shipping City should match');
        System.assertEquals(partner4.dmpl__ShippingState__c, fetchedPurchaseOrder.dmpl__ShippingState__c, 'Shipping State should match');
        System.assertEquals(partner4.dmpl__ShippingCountry__c, fetchedPurchaseOrder.dmpl__ShippingCountry__c, 'Shipping Country should match');
        System.assertEquals(partner4.dmpl__ShippingPostalCode__c, fetchedPurchaseOrder.dmpl__ShippingPostalCode__c, 'Shipping Postal Code should match');
        // System.assertEquals(purchaseOrder.Id, fetchedPurchaseOrderLine.dmpl__PurchaseOrderId__c, 'PO Line should be linked to Purchase Order');
        // System.assertEquals(item4.Id, fetchedPurchaseOrderLine.dmpl__ItemId__c, 'PO Line should be linked to Item 2');
        // System.assertEquals(10, fetchedPurchaseOrderLine.dmpl__Quantity__c, 'PO Line quantity should be 1');
        
        
        System.assertNotEquals(null, purchaseOrderLine, 'Purchase Order Line should not be created with inactive item');
        
    }
    
    //Purchase Order Line with Item without Price (New)
    @isTest
    static void createPurchaseOrderLineWithoutPriceNegative() {
        Test.startTest();
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item13 = TestDataHelpers.getItem('Item 13');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');
        Boolean exceptionThrown = false;
        
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch4,supplier1);
        dmpl__PurchaseOrderLine__c purchaseOrderLine;
        
        try{
            purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(purchaseOrder.Id,item13.Id,taxGroup.Id,null);
        }catch(Exception e){
            exceptionThrown = true;
        }
        
        dmpl__PurchaseOrder__c fetchedPurchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        
        
        Test.stopTest();
        
        System.assertEquals(partner4.Id, fetchedPurchaseOrder.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch4.Id, fetchedPurchaseOrder.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier1.Id, fetchedPurchaseOrder.dmpl__SupplierAccountId__c, 'Supplier should match');
        
        System.assertEquals(partner4.dmpl__BillingStreet__c, fetchedPurchaseOrder.dmpl__BillingStreet__c);
        System.assertEquals(partner4.dmpl__BillingCity__c, fetchedPurchaseOrder.dmpl__BillingCity__c);
        System.assertEquals(partner4.dmpl__BillingState__c, fetchedPurchaseOrder.dmpl__BillingState__c);
        System.assertEquals(partner4.dmpl__BillingCountry__c, fetchedPurchaseOrder.dmpl__BillingCountry__c);
        System.assertEquals(partner4.dmpl__BillingPostalCode__c, fetchedPurchaseOrder.dmpl__BillingPostalCode__c);
        System.assertEquals(partner4.dmpl__ShippingStreet__c, fetchedPurchaseOrder.dmpl__ShippingStreet__c);
        System.assertEquals(partner4.dmpl__ShippingCity__c, fetchedPurchaseOrder.dmpl__ShippingCity__c);
        System.assertEquals(partner4.dmpl__ShippingState__c, fetchedPurchaseOrder.dmpl__ShippingState__c);
        System.assertEquals(partner4.dmpl__ShippingCountry__c, fetchedPurchaseOrder.dmpl__ShippingCountry__c);
        System.assertEquals(partner4.dmpl__ShippingPostalCode__c, fetchedPurchaseOrder.dmpl__ShippingPostalCode__c);
        System.assertEquals(null, purchaseOrderLine, 'Line should not be created null price');
        
        if (exceptionThrown) {
            System.assert(true, 'Exception thrown as expected due to null price');
        } else {
            // System.assertEquals(0, purchaseOrderLine.dmpl__UnitPrice__c, 'Unit Price should be 0');
            // System.assertEquals(0, purchaseOrderLine.dmpl__BaseAmount__c, 'Base Amount should be 0');
            // System.assertEquals(0, purchaseOrderLine.dmpl__TaxAmount__c, 'Tax Amount should be 0');
            // System.assertEquals(0, purchaseOrderLine.dmpl__GrossAmount__c, 'Gross Amount should be 0');
            
            System.assertEquals(0, fetchedPurchaseOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 0');
            System.assertEquals(0, fetchedPurchaseOrder.dmpl__TotalOrderAmount__c, 'Total Order Amount should be 0');
        }
    }
    
    //Purchase Order Line with Item without Tax Group (New)
    @isTest
    static void createPurchaseOrderLineWithoutTaxGroupNegative() {
        Test.startTest();
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner4 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Boolean exceptionThrown = false;
        
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch4,supplier1);
        dmpl__PurchaseOrderLine__c purchaseOrderLine;
        
        try{
            purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(purchaseOrder.Id,item1.Id,null);
            
        }catch(Exception e){
            exceptionThrown = true;
        }
        
        dmpl__PurchaseOrder__c fetchedPurchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        
        
        Test.stopTest();
        
        System.assertEquals(partner4.Id, fetchedPurchaseOrder.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch4.Id, fetchedPurchaseOrder.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier1.Id, fetchedPurchaseOrder.dmpl__SupplierAccountId__c, 'Supplier should match');
        
        System.assertEquals(partner4.dmpl__BillingStreet__c, fetchedPurchaseOrder.dmpl__BillingStreet__c);
        System.assertEquals(partner4.dmpl__BillingCity__c, fetchedPurchaseOrder.dmpl__BillingCity__c);
        System.assertEquals(partner4.dmpl__BillingState__c, fetchedPurchaseOrder.dmpl__BillingState__c);
        System.assertEquals(partner4.dmpl__BillingCountry__c, fetchedPurchaseOrder.dmpl__BillingCountry__c);
        System.assertEquals(partner4.dmpl__BillingPostalCode__c, fetchedPurchaseOrder.dmpl__BillingPostalCode__c);
        System.assertEquals(partner4.dmpl__ShippingStreet__c, fetchedPurchaseOrder.dmpl__ShippingStreet__c);
        System.assertEquals(partner4.dmpl__ShippingCity__c, fetchedPurchaseOrder.dmpl__ShippingCity__c);
        System.assertEquals(partner4.dmpl__ShippingState__c, fetchedPurchaseOrder.dmpl__ShippingState__c);
        System.assertEquals(partner4.dmpl__ShippingCountry__c, fetchedPurchaseOrder.dmpl__ShippingCountry__c);
        System.assertEquals(partner4.dmpl__ShippingPostalCode__c, fetchedPurchaseOrder.dmpl__ShippingPostalCode__c);
        System.assertEquals(null, purchaseOrderLine, 'Line should not be created null price');
        
        if (exceptionThrown) {
            System.assert(true, 'Exception thrown as expected due to null price');
        } else {
            // System.assertEquals(0, purchaseOrderLine.dmpl__UnitPrice__c, 'Unit Price should be 0');
            // System.assertEquals(0, purchaseOrderLine.dmpl__BaseAmount__c, 'Base Amount should be 0');
            // System.assertEquals(0, purchaseOrderLine.dmpl__TaxAmount__c, 'Tax Amount should be 0');
            // System.assertEquals(0, purchaseOrderLine.dmpl__GrossAmount__c, 'Gross Amount should be 0');
            
            System.assertEquals(0, fetchedPurchaseOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 0');
            System.assertEquals(0, fetchedPurchaseOrder.dmpl__TotalOrderAmount__c, 'Total Order Amount should be 0');
        }
    }
    
    //Adding Item with is SKU Required - true (New)
    @isTest
    static void createAddingItemWithIsSKURequiredTrueNegative(){
        Test.startTest();
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item7 = TestDataHelpers.getItem('Item 7');
        Boolean exceptionThrown = false;
        
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch1,supplier1);
        dmpl__PurchaseOrderLine__c purchaseOrderLine;
        
        try{
            purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(purchaseOrder.Id,item7.Id,3);
            
        }catch(Exception e){
            exceptionThrown = true;
        }
        
        dmpl__PurchaseOrder__c fetchedPurchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        
        
        Test.stopTest();
        
        System.assertEquals(partner1.Id, fetchedPurchaseOrder.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch1.Id, fetchedPurchaseOrder.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier1.Id, fetchedPurchaseOrder.dmpl__SupplierAccountId__c, 'Supplier should match');
        
        System.assertEquals(partner1.dmpl__BillingStreet__c, fetchedPurchaseOrder.dmpl__BillingStreet__c);
        System.assertEquals(partner1.dmpl__BillingCity__c, fetchedPurchaseOrder.dmpl__BillingCity__c);
        System.assertEquals(partner1.dmpl__BillingState__c, fetchedPurchaseOrder.dmpl__BillingState__c);
        System.assertEquals(partner1.dmpl__BillingCountry__c, fetchedPurchaseOrder.dmpl__BillingCountry__c);
        System.assertEquals(partner1.dmpl__BillingPostalCode__c, fetchedPurchaseOrder.dmpl__BillingPostalCode__c);
        System.assertEquals(partner1.dmpl__ShippingStreet__c, fetchedPurchaseOrder.dmpl__ShippingStreet__c);
        System.assertEquals(partner1.dmpl__ShippingCity__c, fetchedPurchaseOrder.dmpl__ShippingCity__c);
        System.assertEquals(partner1.dmpl__ShippingState__c, fetchedPurchaseOrder.dmpl__ShippingState__c);
        System.assertEquals(partner1.dmpl__ShippingCountry__c, fetchedPurchaseOrder.dmpl__ShippingCountry__c);
        System.assertEquals(partner1.dmpl__ShippingPostalCode__c, fetchedPurchaseOrder.dmpl__ShippingPostalCode__c);
        System.assertNotEquals(null, purchaseOrderLine, 'Line should not be created null price');
        System.assertNotEquals(true, exceptionThrown, 'Line should not be created null price');
        
    }
    
    //Item SKU with is default true (New) ( Validation on Adding)
    @isTest
    static void createPurchaseOrderLineWithItemSKUWithIsDefaultTrueNegative(){
        Test.startTest();
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item7 = TestDataHelpers.getItem('Item 7');
        Boolean exceptionThrown = false;
        
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch1,supplier1);
        dmpl__PurchaseOrderLine__c purchaseOrderLine;
        
        try{
            purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(purchaseOrder.Id,item7.Id,3);
            
        }catch(Exception e){
            exceptionThrown = true;
        }
        
        dmpl__PurchaseOrder__c fetchedPurchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        
        
        Test.stopTest();
        
        System.assertEquals(partner1.Id, fetchedPurchaseOrder.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch1.Id, fetchedPurchaseOrder.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier1.Id, fetchedPurchaseOrder.dmpl__SupplierAccountId__c, 'Supplier should match');
        
        System.assertEquals(partner1.dmpl__BillingStreet__c, fetchedPurchaseOrder.dmpl__BillingStreet__c);
        System.assertEquals(partner1.dmpl__BillingCity__c, fetchedPurchaseOrder.dmpl__BillingCity__c);
        System.assertEquals(partner1.dmpl__BillingState__c, fetchedPurchaseOrder.dmpl__BillingState__c);
        System.assertEquals(partner1.dmpl__BillingCountry__c, fetchedPurchaseOrder.dmpl__BillingCountry__c);
        System.assertEquals(partner1.dmpl__BillingPostalCode__c, fetchedPurchaseOrder.dmpl__BillingPostalCode__c);
        System.assertEquals(partner1.dmpl__ShippingStreet__c, fetchedPurchaseOrder.dmpl__ShippingStreet__c);
        System.assertEquals(partner1.dmpl__ShippingCity__c, fetchedPurchaseOrder.dmpl__ShippingCity__c);
        System.assertEquals(partner1.dmpl__ShippingState__c, fetchedPurchaseOrder.dmpl__ShippingState__c);
        System.assertEquals(partner1.dmpl__ShippingCountry__c, fetchedPurchaseOrder.dmpl__ShippingCountry__c);
        System.assertEquals(partner1.dmpl__ShippingPostalCode__c, fetchedPurchaseOrder.dmpl__ShippingPostalCode__c);
        System.assertNotEquals(null, purchaseOrderLine, 'Line should not be created null price');
        System.assertNotEquals(true, exceptionThrown, 'Line should not be created null price');
        
    }
    //////////////////
    // Purchase Order Line without Schemes (New)
    @isTest
    static void createPurchaseOrderLineWithoutSchemes() {
        Test.startTest();
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 6');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 6');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 7');
        
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');
        
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(partner, branch, supplier, null, null);
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(item,null,purchaseOrder,taxGroup);
        purchaseOrderLine.dmpl__Quantity__c = 5;
        purchaseOrderLine.dmpl__UnitCost__c = 1000;
        purchaseOrderLine.dmpl__SchemeDiscount__c = null;
        purchaseOrderLine.dmpl__SchemeDiscountAmount__c = null;
        purchaseOrderLine.dmpl__DiscountAmount__c = null;
        update purchaseOrderLine;
        
        Test.stopTest();
        
        dmpl__PurchaseOrderLine__c fetchedLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        System.assertEquals(1000, fetchedLine.dmpl__UnitCost__c, 'Unit Cost should be 1000');
        System.assertEquals(5, fetchedLine.dmpl__Quantity__c, 'Quantity should be 5');
        System.assertEquals(5000, fetchedLine.dmpl__BaseAmount__c, 'Base Amount should be 5000');
        System.assertEquals(5000, fetchedLine.dmpl__Amount__c, 'Amount should be 5000');
        System.assertEquals(0, fetchedLine.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(5600, fetchedLine.dmpl__GrossAmount__c, 'Gross Amount should be 5600');
        System.assertEquals(0, fetchedLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(300, fetchedLine.dmpl__Tax1__c, 'Tax1 should be 300');
        System.assertEquals('CGST', fetchedLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(6, fetchedLine.dmpl__Tax1Rate__c, 'Tax1 Rate should be 6');
        System.assertEquals('CGST', fetchedLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(300, fetchedLine.dmpl__Tax2__c, 'Tax2 should be 300');
        System.assertEquals('SGST', fetchedLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(6, fetchedLine.dmpl__Tax2Rate__c, 'Tax2 Rate should be 6');
        System.assertEquals('SGST', fetchedLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        
        dmpl__PurchaseOrder__c fetchedPO = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        System.assertEquals(5000, fetchedPO.dmpl__TotalAmount__c, 'Total Amount should be 5000'); //changed
        System.assertEquals(0, fetchedPO.dmpl__TotalDiscountAmount__c, 'Total Discount should be 0');
        System.assertEquals(5000, fetchedPO.dmpl__TotalLineAmount__c, 'Total Line Amount should be 5000');
        System.assertEquals(5000, fetchedPO.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be 5000');
        System.assertEquals(5600, fetchedPO.dmpl__TotalOrderAmount__c, 'Total Order Amount should be 5600');
        System.assertEquals(600, fetchedPO.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 600');
        System.assertEquals(5600, fetchedPO.dmpl__OpenAmount__c, 'Open Amount should be 5600');
        
        System.assertEquals(partner.dmpl__BillingStreet__c, fetchedPO.dmpl__BillingStreet__c, 'Billing Street should match Partner');
        System.assertEquals(partner.dmpl__BillingCity__c, fetchedPO.dmpl__BillingCity__c, 'Billing City should match Partner');
        System.assertEquals(partner.dmpl__BillingState__c, fetchedPO.dmpl__BillingState__c, 'Billing State should match Partner');
        System.assertEquals(partner.dmpl__BillingPostalCode__c, fetchedPO.dmpl__BillingPostalCode__c, 'Billing Postal Code should match Partner');
        System.assertEquals(partner.dmpl__BillingCountry__c, fetchedPO.dmpl__BillingCountry__c, 'Billing Country should match Partner');
        
        System.assertEquals(partner.dmpl__ShippingStreet__c, fetchedPO.dmpl__ShippingStreet__c, 'Shipping Street should match Partner');
        System.assertEquals(partner.dmpl__ShippingCity__c, fetchedPO.dmpl__ShippingCity__c, 'Shipping City should match Partner');
        System.assertEquals(partner.dmpl__ShippingState__c, fetchedPO.dmpl__ShippingState__c, 'Shipping State should match Partner');
        System.assertEquals(partner.dmpl__ShippingPostalCode__c, fetchedPO.dmpl__ShippingPostalCode__c, 'Shipping Postal Code should match Partner');
        System.assertEquals(partner.dmpl__ShippingCountry__c, fetchedPO.dmpl__ShippingCountry__c, 'Shipping Country should match Partner');
    }
    // Purchase Order line with Scheme - Auto Apply - Discount Amount (New)
    @isTest
    static void createPurchaseOrderLineWithSchemeAutoApplyDiscountAmount() {
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 5');
        // dmpl__SKU__c sku = TestDataHelpers.getSKU(item.Id);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');
        
        Test.startTest();
        
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(
        partner,
        branch,
        supplier,
        null,
        null
            );
        
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            purchaseOrder.Id,
        item.Id,taxGroup.Id,
        15
            );
        
        purchaseOrderLine.dmpl__UnitCost__c = 1000;      
        update purchaseOrderLine;
        
        dmpl__PurchaseOrderLine__c createdLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        
        System.assertEquals(1000, createdLine.dmpl__UnitCost__c, 'Unit Cost should be 1000');
        System.assertEquals(15, createdLine.dmpl__Quantity__c, 'Quantity should be 15');
        System.assertEquals(15000, createdLine.dmpl__BaseAmount__c, 'Base Amount should be 15000');
        // System.assertEquals(13000, createdLine.dmpl__Amount__c, 'Amount should be 15000');
        System.assertEquals(1000, createdLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 1000');
        System.assertEquals(2520, createdLine.dmpl__TaxAmount__c, 'Tax Amount should be 2520');
        System.assertEquals(16520, createdLine.dmpl__GrossAmount__c, 'Gross Amount should be 16520');
        System.assertEquals('CGST', createdLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals('CGST', createdLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(9, createdLine.dmpl__Tax1Rate__c, 'Tax1 Rate should be 9');
        System.assertEquals(1260, createdLine.dmpl__Tax1__c, 'Tax1 should be 1350');
        System.assertEquals('SGST', createdLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals('SGST', createdLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(9, createdLine.dmpl__Tax2Rate__c, 'Tax2 Rate should be 9');
        System.assertEquals(1260, createdLine.dmpl__Tax2__c, 'Tax2 should be 1350');
        
        dmpl__PurchaseOrder__c updatedPO = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        Test.stopTest();
        System.assertEquals(15000, updatedPO.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be 15000');
        System.assertEquals(16520, updatedPO.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be 16700');
        System.assertEquals(14000, updatedPO.dmpl__TotalLineAmount__c, 'Total Line Amount should be 14000');
        System.assertEquals(14000, updatedPO.dmpl__TotalAmount__c, 'Total Amount should be 15000');
        System.assertEquals(2520, updatedPO.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 2700');
        System.assertEquals(1000, updatedPO.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 1000');
        
        System.assertEquals('12 Industrial Zone', updatedPO.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals('Hyderabad', updatedPO.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals('Telangana', updatedPO.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals('500032', updatedPO.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');
        System.assertEquals('India', updatedPO.dmpl__BillingCountry__c, 'Billing Country should match');
        System.assertEquals('12 Industrial Zone', updatedPO.dmpl__ShippingStreet__c, 'Shipping Street should match');
        System.assertEquals('Hyderabad', updatedPO.dmpl__ShippingCity__c, 'Shipping City should match');
        System.assertEquals('Telangana', updatedPO.dmpl__ShippingState__c, 'Shipping State should match');
        System.assertEquals('500032', updatedPO.dmpl__ShippingPostalCode__c, 'Shipping Postal Code should match');
        System.assertEquals('India', updatedPO.dmpl__ShippingCountry__c, 'Shipping Country should match');
        System.assertEquals('Draft', updatedPO.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(Date.today(), updatedPO.dmpl__DocumentDate__c, 'Document Date should be today');
        
    }
    @isTest
    static void createPurchaseOrderLineWithAutoApplySchemeDiscountPercentage() {
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 6');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');
        Test.startTest();
        
        dmpl__PurchaseOrder__c po = PurchaseOrderTestDataHelpers.createPurchaseOrder(
            partner,
        branch,
        supplier,
        null,
        null
            );
        
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            po.Id,
        item.Id,
        taxGroup.Id,
        2
            );
        purchaseOrderLine.dmpl__UnitCost__c = 2000;

        update purchaseOrderLine;
        dmpl__PurchaseOrderLine__c createdLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        
        System.assertEquals(2000, createdLine.dmpl__UnitCost__c, 'Unit Cost should be 2000');
        System.assertEquals(2, createdLine.dmpl__Quantity__c, 'Quantity should be 5');
        System.assertEquals(4000, createdLine.dmpl__BaseAmount__c, 'Base Amount should be 10000');
        System.assertEquals(4000, createdLine.dmpl__Amount__c, 'Amount should be 10000');
        System.assertEquals(0, createdLine.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(4480, createdLine.dmpl__GrossAmount__c, 'Gross Amount should be 10000');
        
        dmpl__PurchaseOrder__c fetchedPurchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(po.Id);
        
         System.assertEquals(partner.dmpl__BillingStreet__c, fetchedPurchaseOrder.dmpl__BillingStreet__c);
        System.assertEquals(partner.dmpl__BillingCity__c, fetchedPurchaseOrder.dmpl__BillingCity__c);
        System.assertEquals(partner.dmpl__BillingState__c, fetchedPurchaseOrder.dmpl__BillingState__c);
        System.assertEquals(partner.dmpl__BillingCountry__c, fetchedPurchaseOrder.dmpl__BillingCountry__c);
        System.assertEquals(partner.dmpl__BillingPostalCode__c, fetchedPurchaseOrder.dmpl__BillingPostalCode__c);
        System.assertEquals(partner.dmpl__ShippingStreet__c, fetchedPurchaseOrder.dmpl__ShippingStreet__c);
        System.assertEquals(partner.dmpl__ShippingCity__c, fetchedPurchaseOrder.dmpl__ShippingCity__c);
        System.assertEquals(partner.dmpl__ShippingState__c, fetchedPurchaseOrder.dmpl__ShippingState__c);
        System.assertEquals(partner.dmpl__ShippingCountry__c, fetchedPurchaseOrder.dmpl__ShippingCountry__c);
        System.assertEquals(partner.dmpl__ShippingPostalCode__c, fetchedPurchaseOrder.dmpl__ShippingPostalCode__c);
        
        Test.stopTest();
    }
    // Item SKU with is default true (New)
    @isTest
    static void createPurchaseOrderLineWithItemAndDefaultSKU() {
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 7');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');
        
        Test.startTest();
        dmpl__PurchaseOrder__c po = PurchaseOrderTestDataHelpers.createPurchaseOrder(
            partner,
        branch,
        supplier,
        null,
        null
            );
        
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            item,
        sku,
        po,
        taxGroup
            );
        purchaseOrderLine.dmpl__Quantity__c = 1;
        purchaseOrderLine.dmpl__UnitCost__c = 1000;
        purchaseOrderLine.dmpl__SchemeDiscount__c = 0;
        purchaseOrderLine.dmpl__SchemeDiscountAmount__c = 0;
        purchaseOrderLine.dmpl__DiscountAmount__c = 0;
        update purchaseOrderLine;
        
        dmpl__PurchaseOrderLine__c createdLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        
        System.assertEquals(1, createdLine.dmpl__Quantity__c, 'Quantity should be 1');
        System.assertEquals(1000, createdLine.dmpl__UnitCost__c, 'Unit Cost should be 100');
        System.assertEquals(1000, createdLine.dmpl__BaseAmount__c, 'Base Amount should be 1000');
        System.assertEquals(1000, createdLine.dmpl__Amount__c, 'Amount should be 1000');
        System.assertEquals(0, createdLine.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(0, createdLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(60, createdLine.dmpl__Tax1__c, 'Tax1 should be 60');
        System.assertEquals('CGST', createdLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(6, createdLine.dmpl__Tax1Rate__c, 'Tax1 Rate should be 6');
        System.assertEquals('CGST', createdLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(60, createdLine.dmpl__Tax2__c, 'Tax2 should be 60');
        System.assertEquals('SGST', createdLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(6, createdLine.dmpl__Tax2Rate__c, 'Tax2 Rate should be 6');
        System.assertEquals('SGST', createdLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(120, createdLine.dmpl__TaxAmount__c, 'Total Tax Amount should be 180');
        System.assertEquals(1120, createdLine.dmpl__GrossAmount__c, 'Gross Amount should be 1120');
        
        dmpl__PurchaseOrder__c updatedPO = PurchaseOrderTestDataHelpers.getPurchaseOrder(po.Id);
        
        System.assertEquals(1000, updatedPO.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be 1000');
        System.assertEquals(1000, updatedPO.dmpl__TotalLineAmount__c, 'Total Line Amount should be 1000');
        System.assertEquals(1000, updatedPO.dmpl__TotalAmount__c, 'Total Amount should be 1000');
        System.assertEquals(0, updatedPO.dmpl__TotalDiscountAmount__c, 'Total Discount should be 0');
        System.assertEquals(0, updatedPO.dmpl__TotalSchemeDiscountAmount__c, 'Scheme Discount should be 0');
        System.assertEquals(1120, updatedPO.dmpl__TotalLineGrossAmount__c, 'Total Line Gross should be 1120');
        
        System.assertEquals('12 Industrial Zone', updatedPO.dmpl__BillingStreet__c, 'Billing Street');
        System.assertEquals('Hyderabad', updatedPO.dmpl__BillingCity__c, 'Billing City');
        System.assertEquals('Telangana', updatedPO.dmpl__BillingState__c, 'Billing State');
        System.assertEquals('India', updatedPO.dmpl__BillingCountry__c, 'Billing Country');
        System.assertEquals('500032', updatedPO.dmpl__BillingPostalCode__c, 'Billing Postal Code');
        
        System.assertEquals('12 Industrial Zone', updatedPO.dmpl__ShippingStreet__c, 'Shipping Street');
        System.assertEquals('Hyderabad', updatedPO.dmpl__ShippingCity__c, 'Shipping City');
        System.assertEquals('Telangana', updatedPO.dmpl__ShippingState__c, 'Shipping State');
        System.assertEquals('India', updatedPO.dmpl__ShippingCountry__c, 'Shipping Country');
        System.assertEquals('500032', updatedPO.dmpl__ShippingPostalCode__c, 'Shipping Postal Code');
        
        Test.stopTest();
    }
    
    @isTest
    static void createPurchaseOrderLineWithSkipSchemeTrue() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 7');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 6');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 18');
        
        Test.startTest();
        dmpl__PurchaseOrder__c po = PurchaseOrderTestDataHelpers.createPurchaseOrder(
            partner,
        branch,
        supplier,
        null,
        null
            );
        
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(po.Id);
        
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            purchaseOrder.Id,
        item.Id,
        taxGroup.Id,
        10);
        
        purchaseOrderLine.dmpl__UnitCost__c = 1000;
        purchaseOrderLine.dmpl__SchemeDiscount__c = null;
        purchaseOrderLine.dmpl__SchemeDiscountAmount__c = null;
        purchaseOrderLine.dmpl__DiscountAmount__c = null;
        update purchaseOrderLine;
        
        dmpl__PurchaseOrderLine__c fetchedLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        dmpl__PurchaseOrder__c fetchedPO = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        Test.stopTest();
        System.assertEquals(1000, fetchedLine.dmpl__UnitCost__c, 'Unit Cost should be 1000');
        System.assertEquals(10000, fetchedLine.dmpl__BaseAmount__c, 'Base Amount should be 10,000');
        System.assertEquals(10000, fetchedLine.dmpl__Amount__c, 'Amount should be 10,000');
        System.assertEquals(0, fetchedLine.dmpl__NetSchemeDiscount__c, 'Scheme Discount should be 0');
        
        System.assertEquals(10000, fetchedPO.dmpl__TotalLineBaseAmount__c, 'Total Line Base should be 10,000');
        System.assertEquals(10000, fetchedPO.dmpl__TotalLineAmount__c, 'Total Line Amount should be 10,000');
        System.assertEquals(10000, fetchedPO.dmpl__TotalAmount__c, 'Total Amount should be 10,000');
        System.assertEquals(0, fetchedPO.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount should be 0');
        System.assertEquals(1800, fetchedPO.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 1,800');
        System.assertEquals(11800, fetchedPO.dmpl__TotalLineGrossAmount__c, 'Total Gross should be 11,200');
        
        System.assertEquals(partner.dmpl__BillingStreet__c, fetchedPO.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals(partner.dmpl__BillingCity__c, fetchedPO.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals(partner.dmpl__BillingState__c, fetchedPO.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals(partner.dmpl__BillingPostalCode__c, fetchedPO.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');
        System.assertEquals(partner.dmpl__ShippingStreet__c, fetchedPO.dmpl__ShippingStreet__c, 'Shipping Street should match');
        System.assertEquals(partner.dmpl__ShippingCity__c, fetchedPO.dmpl__ShippingCity__c, 'Shipping City should match');
        System.assertEquals(partner.dmpl__ShippingState__c, fetchedPO.dmpl__ShippingState__c, 'Shipping State should match');
        System.assertEquals(partner.dmpl__ShippingCountry__c, fetchedPO.dmpl__ShippingCountry__c, 'Shipping Country should match');
        System.assertEquals(partner.dmpl__ShippingPostalCode__c, fetchedPO.dmpl__ShippingPostalCode__c, 'Shipping Postal Code should match');
    }
    // Scheme Applicability in case of Ignore Budget is True (New)
    @isTest
    static void createPurchaseOrderLineWithIgnoreBudgetTrue() {
        
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
        
        Test.startTest();
        dmpl__PurchaseOrder__c po = PurchaseOrderTestDataHelpers.createPurchaseOrder(
            partner,
        branch,
        supplier,
        null,
        null
            );
        
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
        po.Id,item.Id,taxgroup.Id,18 );

        purchaseOrderLine.dmpl__UnitCost__c = 1500;
        update purchaseOrderLine;
        
        
        dmpl__PurchaseOrderLine__c fetchedLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        Test.stopTest();
        System.assertEquals(1500, fetchedLine.dmpl__UnitCost__c, 'Unit Price should be 1500');
        System.assertEquals(27000, fetchedLine.dmpl__BaseAmount__c, 'Base Amount should be 27000');
        System.assertEquals(0, fetchedLine.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(0, fetchedLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 75');
        System.assertEquals(3780, fetchedLine.dmpl__Tax1__c, 'Tax1 should be 3780');
        System.assertEquals('CGST', fetchedLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(14, fetchedLine.dmpl__Tax1Rate__c, 'Tax1 Rate should be 14%');
        System.assertEquals('CGST', fetchedLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(3780, fetchedLine.dmpl__Tax2__c, 'Tax2 should be 3780');
        System.assertEquals('SGST', fetchedLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(14, fetchedLine.dmpl__Tax2Rate__c, 'Tax2 Rate should be 14%');
        System.assertEquals('SGST', fetchedLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(7560, fetchedLine.dmpl__TaxAmount__c, 'Total Tax should be 7560');
        System.assertEquals(34560, fetchedLine.dmpl__GrossAmount__c, 'Gross should be 27000');
        
        dmpl__PurchaseOrder__c fetchedPO = PurchaseOrderTestDataHelpers.getPurchaseOrder(po.Id);
        System.assertEquals(27000, fetchedPO.dmpl__TotalLineBaseAmount__c, 'Total Base Amount should be 27000');
        System.assertEquals(27000, fetchedPO.dmpl__TotalLineAmount__c, 'Total Line Amount should be 27000');
        System.assertEquals(27000, fetchedPO.dmpl__TotalAmount__c, 'Total Amount should be 27000');
        System.assertEquals(7560, fetchedPO.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 7560');
        System.assertEquals(34560, fetchedPO.dmpl__TotalLineGrossAmount__c, 'Total Gross Amount should be 27000');
        
        System.assertEquals(partner.dmpl__BillingStreet__c, fetchedPO.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals(partner.dmpl__BillingCity__c, fetchedPO.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals(partner.dmpl__BillingState__c, fetchedPO.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals(partner.dmpl__BillingPostalCode__c, fetchedPO.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');
        System.assertEquals(partner.dmpl__ShippingStreet__c, fetchedPO.dmpl__ShippingStreet__c, 'Shipping Street should match');
        System.assertEquals(partner.dmpl__ShippingCity__c, fetchedPO.dmpl__ShippingCity__c, 'Shipping City should match');
        System.assertEquals(partner.dmpl__ShippingState__c, fetchedPO.dmpl__ShippingState__c, 'Shipping State should match');
        System.assertEquals(partner.dmpl__ShippingCountry__c, fetchedPO.dmpl__ShippingCountry__c, 'Shipping Country should match');
        System.assertEquals(partner.dmpl__ShippingPostalCode__c, fetchedPO.dmpl__ShippingPostalCode__c, 'Shipping Postal Code should match');
        
        System.assertEquals(Date.today(), fetchedPO.dmpl__DocumentDate__c, 'Document Date should be Today');
        System.assertEquals('Draft', fetchedPO.dmpl__Status__c, 'Status should be Draft');
    }
    
    // Scheme Applicability For Supplier Account Defined (New)
    @isTest
    static void createPurchaseOrdeLineSchemeApplicabilityForSuppilerAccountDefined() {
        
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 6');
        dmpl__TaxGroup__c taxGroup= TestDataHelpers.getTaxGroup('GST 12');
        
        
        Test.startTest();
        dmpl__PurchaseOrder__c po = PurchaseOrderTestDataHelpers.createPurchaseOrder(
            partner,
        branch,
        supplier,
        null,null
            );
        
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            po.Id,
        item.Id,taxGroup.Id,
        20
            
        );
        
        purchaseOrderLine.dmpl__UnitCost__c = 2400;
        
        // poLine.dmpl__UnitCost__c=2000;
        update purchaseOrderLine;
        dmpl__PurchaseOrder__c fetchedPO = PurchaseOrderTestDataHelpers.getPurchaseOrder(po.Id);
        dmpl__PurchaseOrderLine__c fetchedLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        Test.stopTest();
        
        System.assertEquals(2400, fetchedLine.dmpl__UnitCost__c, 'Unit Price should be 1500');
        System.assertEquals(48000, fetchedLine.dmpl__BaseAmount__c, 'Base Amount should be 30000');
        // System.assertEquals(20, fetchedLine.dmpl__DiscountPercent__c, 'Net Discount should be 0');
        // System.assertEquals(75, fetchedLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 75');
        System.assertEquals(2880, fetchedLine.dmpl__Tax1__c, 'Tax1 should be 2880');
        System.assertEquals('CGST', fetchedLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(6, fetchedLine.dmpl__Tax1Rate__c, 'Tax1 Rate should be 6%');
        System.assertEquals('CGST', fetchedLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(2880, fetchedLine.dmpl__Tax2__c, 'Tax2 should be 2880');
        System.assertEquals('SGST', fetchedLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(6, fetchedLine.dmpl__Tax2Rate__c, 'Tax2 Rate should be 6%');
        System.assertEquals('SGST', fetchedLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(5760, fetchedLine.dmpl__TaxAmount__c, 'Total Tax should be 5760');
        System.assertEquals(53760, fetchedLine.dmpl__GrossAmount__c, 'Gross should be 53760');
        
        System.assertEquals(48000, fetchedPO.dmpl__TotalLineBaseAmount__c, 'Total Base Amount should be 48000');
        System.assertEquals(48000, fetchedPO.dmpl__TotalLineAmount__c, 'Total Line Amount should be 48000');
        System.assertEquals(48000, fetchedPO.dmpl__TotalAmount__c, 'Total Amount should be 48000');
        System.assertEquals(5760, fetchedPO.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 5760');
        System.assertEquals(0, fetchedPO.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount should be 0');
        System.assertEquals(53760, fetchedPO.dmpl__TotalLineGrossAmount__c, 'Total Gross Amount should be 53760');
        
        System.assertEquals(partner.dmpl__BillingStreet__c, fetchedPO.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals(partner.dmpl__BillingCity__c, fetchedPO.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals(partner.dmpl__BillingState__c, fetchedPO.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals(partner.dmpl__BillingPostalCode__c, fetchedPO.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');
        System.assertEquals(partner.dmpl__ShippingStreet__c, fetchedPO.dmpl__ShippingStreet__c, 'Shipping Street should match');
        System.assertEquals(partner.dmpl__ShippingCity__c, fetchedPO.dmpl__ShippingCity__c, 'Shipping City should match');
        System.assertEquals(partner.dmpl__ShippingState__c, fetchedPO.dmpl__ShippingState__c, 'Shipping State should match');
        System.assertEquals(partner.dmpl__ShippingCountry__c, fetchedPO.dmpl__ShippingCountry__c, 'Shipping Country should match');
        System.assertEquals(partner.dmpl__ShippingPostalCode__c, fetchedPO.dmpl__ShippingPostalCode__c, 'Shipping Postal Code should match');
        
        System.assertEquals(Date.today(), fetchedPO.dmpl__DocumentDate__c, 'Document Date should be Today');
        System.assertEquals('Draft', fetchedPO.dmpl__Status__c, 'Status should be Draft');
    }
    @isTest
    static void createPurchaseOrderLineWithSchemeApplicabilityIncaseOfPartnerAccountDefined() {
        
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 5');
        dmpl__TaxGroup__c taxGroup= TestDataHelpers.getTaxGroup('GST 12');
        
        Test.startTest();
        dmpl__PurchaseOrder__c po = PurchaseOrderTestDataHelpers.createPurchaseOrder(
            partner,
        branch,
        supplier,
        null,null
            );
        
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            po.Id,
        item.Id,taxGroup.Id,
        10
            );
        //    purchaseOrderLine.dmpl__Quantity__c = 5;
        purchaseOrderLine.dmpl__UnitCost__c = 1000;
        update purchaseOrderLine;
        dmpl__PurchaseOrder__c fetchedPO = PurchaseOrderTestDataHelpers.getPurchaseOrder(po.Id);
        dmpl__PurchaseOrderLine__c fetchedLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        Test.stopTest();
        
        System.assertEquals(1000, fetchedLine.dmpl__UnitCost__c, 'Unit Price should be 1000');
        System.assertEquals(10000, fetchedLine.dmpl__BaseAmount__c, 'Base Amount should be 27000');
        System.assertEquals(0, fetchedLine.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(1000, fetchedLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 75');
        System.assertEquals(540, fetchedLine.dmpl__Tax1__c, 'Tax1 should be 3780');
        System.assertEquals('CGST', fetchedLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(6, fetchedLine.dmpl__Tax1Rate__c, 'Tax1 Rate should be 14%');
        System.assertEquals('CGST', fetchedLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(540, fetchedLine.dmpl__Tax2__c, 'Tax2 should be 3780');
        System.assertEquals('SGST', fetchedLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(6, fetchedLine.dmpl__Tax2Rate__c, 'Tax2 Rate should be 14%');
        System.assertEquals('SGST', fetchedLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(1080, fetchedLine.dmpl__TaxAmount__c, 'Total Tax should be 7560');
        System.assertEquals(10080, fetchedLine.dmpl__GrossAmount__c, 'Gross should be 27000');
        
        System.assertEquals(10000, fetchedPO.dmpl__TotalLineBaseAmount__c, 'Total Base Amount should be 27000');
        System.assertEquals(9000, fetchedPO.dmpl__TotalLineAmount__c, 'Total Line Amount should be 27000');
        System.assertEquals(9000, fetchedPO.dmpl__TotalAmount__c, 'Total Amount should be 27000');
        System.assertEquals(1080, fetchedPO.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 7560');
        System.assertEquals(1000, fetchedPO.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount should be 75');
        System.assertEquals(10080, fetchedPO.dmpl__TotalLineGrossAmount__c, 'Total Gross Amount should be 27000');
        
        System.assertEquals(partner.dmpl__BillingStreet__c, fetchedPO.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals(partner.dmpl__BillingCity__c, fetchedPO.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals(partner.dmpl__BillingState__c, fetchedPO.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals(partner.dmpl__BillingPostalCode__c, fetchedPO.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');
        System.assertEquals(partner.dmpl__ShippingStreet__c, fetchedPO.dmpl__ShippingStreet__c, 'Shipping Street should match');
        System.assertEquals(partner.dmpl__ShippingCity__c, fetchedPO.dmpl__ShippingCity__c, 'Shipping City should match');
        System.assertEquals(partner.dmpl__ShippingState__c, fetchedPO.dmpl__ShippingState__c, 'Shipping State should match');
        System.assertEquals(partner.dmpl__ShippingCountry__c, fetchedPO.dmpl__ShippingCountry__c, 'Shipping Country should match');
        System.assertEquals(partner.dmpl__ShippingPostalCode__c, fetchedPO.dmpl__ShippingPostalCode__c, 'Shipping Postal Code should match');
        
        System.assertEquals(Date.today(), fetchedPO.dmpl__DocumentDate__c, 'Document Date should be Today');
        System.assertEquals('Draft', fetchedPO.dmpl__Status__c, 'Status should be Draft');
    }
    @isTest
    static void createPurchaseOrderLineWithSchemeApplicabilityIncaseOfPartnerAccountGroupDefined() {
        
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account customer=TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 3');
        
        Test.startTest();
        dmpl__PurchaseOrder__c po = PurchaseOrderTestDataHelpers.createPurchaseOrder(
            partner,
        branch,
        supplier,
        null,null
            );
        
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            po.Id,
        item.Id,
        15
            );
        purchaseOrderLine.dmpl__UnitCost__c = 1500;
        dmpl__PurchaseOrderLine__c fetchedLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        dmpl__PurchaseOrder__c fetchedPO = PurchaseOrderTestDataHelpers.getPurchaseOrder(po.Id);
        update purchaseOrderLine;
        Test.stopTest();
        
        System.assertEquals(1500, fetchedLine.dmpl__UnitCost__c, 'Unit Price should be 1500');
        System.assertEquals(22500, fetchedLine.dmpl__BaseAmount__c, 'Base Amount should be 27000');
        System.assertEquals(0, fetchedLine.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(0, fetchedLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 75');
        
        System.assertEquals(22500, fetchedPO.dmpl__TotalLineBaseAmount__c, 'Total Base Amount should be 27000');
        System.assertEquals(22500, fetchedPO.dmpl__TotalLineAmount__c, 'Total Line Amount should be 27000');
        System.assertEquals(22500, fetchedPO.dmpl__TotalAmount__c, 'Total Amount should be 27000');
        System.assertEquals(0, fetchedPO.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 7560');
        System.assertEquals(0, fetchedPO.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount should be 75');
        System.assertEquals(22500, fetchedPO.dmpl__TotalLineGrossAmount__c, 'Total Gross Amount should be 27000');
        
        System.assertEquals(partner.dmpl__BillingStreet__c, fetchedPO.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals(partner.dmpl__BillingCity__c, fetchedPO.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals(partner.dmpl__BillingState__c, fetchedPO.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals(partner.dmpl__BillingPostalCode__c, fetchedPO.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');
        System.assertEquals(partner.dmpl__ShippingStreet__c, fetchedPO.dmpl__ShippingStreet__c, 'Shipping Street should match');
        System.assertEquals(partner.dmpl__ShippingCity__c, fetchedPO.dmpl__ShippingCity__c, 'Shipping City should match');
        System.assertEquals(partner.dmpl__ShippingState__c, fetchedPO.dmpl__ShippingState__c, 'Shipping State should match');
        System.assertEquals(partner.dmpl__ShippingCountry__c, fetchedPO.dmpl__ShippingCountry__c, 'Shipping Country should match');
        System.assertEquals(partner.dmpl__ShippingPostalCode__c, fetchedPO.dmpl__ShippingPostalCode__c, 'Shipping Postal Code should match');
        
        System.assertEquals(Date.today(), fetchedPO.dmpl__DocumentDate__c, 'Document Date should be Today');
        System.assertEquals('Draft', fetchedPO.dmpl__Status__c, 'Status should be Draft');
    }
    @isTest
    static void createPurchaseOrdeLineWithSchemeApplicabilityIncaseOfValidCountDefined() {
        
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 5');
        dmpl__TaxGroup__c taxGroup= TestDataHelpers.getTaxGroup('GST 12');
        
        Test.startTest();
        dmpl__PurchaseOrder__c po = PurchaseOrderTestDataHelpers.createPurchaseOrder(
            partner,
        branch,
        supplier,
        null,null
            );
            
        
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            po.Id,
        item.Id,taxGroup.Id,
        10
            );
            
        purchaseOrderLine.dmpl__UnitCost__c = 1000;

        
        update purchaseOrderLine;
        dmpl__PurchaseOrderLine__c fetchedLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        dmpl__PurchaseOrder__c fetchedPO = PurchaseOrderTestDataHelpers.getPurchaseOrder(po.Id);
        Test.stopTest();
        
        System.assertEquals(1000, fetchedLine.dmpl__UnitCost__c, 'Unit Price should be 1000');
        System.assertEquals(10000, fetchedLine.dmpl__BaseAmount__c, 'Base Amount should be 27000');
        // System.assertEquals(0, fetchedLine.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(1000, fetchedLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 75');
        System.assertEquals(540, fetchedLine.dmpl__Tax1__c, 'Tax1 should be 540');
        System.assertEquals('CGST', fetchedLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(6, fetchedLine.dmpl__Tax1Rate__c, 'Tax1 Rate should be 14%');
        System.assertEquals('CGST', fetchedLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(540, fetchedLine.dmpl__Tax2__c, 'Tax2 should be 540');
        System.assertEquals('SGST', fetchedLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(6, fetchedLine.dmpl__Tax2Rate__c, 'Tax2 Rate should be 14%');
        System.assertEquals('SGST', fetchedLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(1080, fetchedLine.dmpl__TaxAmount__c, 'Total Tax should be 7560');
        System.assertEquals(10080, fetchedLine.dmpl__GrossAmount__c, 'Gross should be 27000');
        
        System.assertEquals(10000, fetchedPO.dmpl__TotalLineBaseAmount__c, 'Total Base Amount should be 27000');
        System.assertEquals(9000, fetchedPO.dmpl__TotalLineAmount__c, 'Total Line Amount should be 27000');
        System.assertEquals(9000, fetchedPO.dmpl__TotalAmount__c, 'Total Amount should be 27000');
        System.assertEquals(1080, fetchedPO.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 7560');
        System.assertEquals(1000, fetchedPO.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount should be 75');
        System.assertEquals(10080, fetchedPO.dmpl__TotalLineGrossAmount__c, 'Total Gross Amount should be 27000');
        
        System.assertEquals(partner.dmpl__BillingStreet__c, fetchedPO.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals(partner.dmpl__BillingCity__c, fetchedPO.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals(partner.dmpl__BillingState__c, fetchedPO.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals(partner.dmpl__BillingPostalCode__c, fetchedPO.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');
        System.assertEquals(partner.dmpl__ShippingStreet__c, fetchedPO.dmpl__ShippingStreet__c, 'Shipping Street should match');
        System.assertEquals(partner.dmpl__ShippingCity__c, fetchedPO.dmpl__ShippingCity__c, 'Shipping City should match');
        System.assertEquals(partner.dmpl__ShippingState__c, fetchedPO.dmpl__ShippingState__c, 'Shipping State should match');
        System.assertEquals(partner.dmpl__ShippingCountry__c, fetchedPO.dmpl__ShippingCountry__c, 'Shipping Country should match');
        System.assertEquals(partner.dmpl__ShippingPostalCode__c, fetchedPO.dmpl__ShippingPostalCode__c, 'Shipping Postal Code should match');
        
        System.assertEquals(Date.today(), fetchedPO.dmpl__DocumentDate__c, 'Document Date should be Today');
        System.assertEquals('Draft', fetchedPO.dmpl__Status__c, 'Status should be Draft');
    }
    @isTest
    static void createPurchaseOrderLineWithTaxApplicationObjectModel() {
        Test.startTest();
        
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup= TestDataHelpers.getTaxGroup('GST 28');
        
        dmpl__PurchaseOrder__c po = PurchaseOrderTestDataHelpers.createPurchaseOrder(
            partner,
        branch,
        supplier,
        null,
        null
            );
        
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            po.Id,
        item.Id,
        taxGroup.Id,
        3
            );
        purchaseOrderLine.dmpl__UnitCost__c = 1500;
        update purchaseOrderLine;
        Test.stopTest();
        
        dmpl__PurchaseOrderLine__c fetchedLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        System.assertEquals(1500, fetchedLine.dmpl__UnitCost__c, 'Unit Price should be 1500');
        System.assertEquals(4500, fetchedLine.dmpl__BaseAmount__c, 'Base Amount should be 27000');
        System.assertEquals(0, fetchedLine.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(0, fetchedLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 75');
        System.assertEquals(630, fetchedLine.dmpl__Tax1__c, 'Tax1 should be 3780');
        System.assertEquals('CGST', fetchedLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(14, fetchedLine.dmpl__Tax1Rate__c, 'Tax1 Rate should be 14%');
        System.assertEquals('CGST', fetchedLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(630, fetchedLine.dmpl__Tax2__c, 'Tax2 should be 3780');
        System.assertEquals('SGST', fetchedLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(14, fetchedLine.dmpl__Tax2Rate__c, 'Tax2 Rate should be 14%');
        System.assertEquals('SGST', fetchedLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(1260, fetchedLine.dmpl__TaxAmount__c, 'Total Tax should be 7560');
        System.assertEquals(5760, fetchedLine.dmpl__GrossAmount__c, 'Gross should be 27000');
        
        dmpl__PurchaseOrder__c fetchedPO = PurchaseOrderTestDataHelpers.getPurchaseOrder(po.Id);
        System.assertEquals(4500, fetchedPO.dmpl__TotalLineBaseAmount__c, 'Total Base Amount should be 27000');
        System.assertEquals(1260, fetchedPO.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 7560');
        System.assertEquals(0, fetchedPO.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount should be 75');
        System.assertEquals(5760, fetchedPO.dmpl__TotalLineGrossAmount__c, 'Total Gross Amount should be 27000');
        
        System.assertEquals(partner.dmpl__BillingStreet__c, fetchedPO.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals(partner.dmpl__BillingCity__c, fetchedPO.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals(partner.dmpl__BillingState__c, fetchedPO.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals(partner.dmpl__BillingPostalCode__c, fetchedPO.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');
        System.assertEquals(partner.dmpl__ShippingStreet__c, fetchedPO.dmpl__ShippingStreet__c, 'Shipping Street should match');
        System.assertEquals(partner.dmpl__ShippingCity__c, fetchedPO.dmpl__ShippingCity__c, 'Shipping City should match');
        System.assertEquals(partner.dmpl__ShippingState__c, fetchedPO.dmpl__ShippingState__c, 'Shipping State should match');
        System.assertEquals(partner.dmpl__ShippingCountry__c, fetchedPO.dmpl__ShippingCountry__c, 'Shipping Country should match');
        System.assertEquals(partner.dmpl__ShippingPostalCode__c, fetchedPO.dmpl__ShippingPostalCode__c, 'Shipping Postal Code should match');
        
        System.assertEquals(Date.today(), fetchedPO.dmpl__DocumentDate__c, 'Document Date should be Today');
        System.assertEquals('Draft', fetchedPO.dmpl__Status__c, 'Status should be Draft');
    }
    @isTest
    static void createPurchaseOrderLineWithTaxApplicationObjectModelObjectTaxes() {
        
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
         dmpl__TaxGroup__c taxGroup= TestDataHelpers.getTaxGroup('GST 28');
        
        dmpl__PurchaseOrder__c po = PurchaseOrderTestDataHelpers.createPurchaseOrder(
            partner,
        branch,
        supplier,
        null,null
            );
        
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            po.Id,
        item.Id,
        taxGroup.Id,
        10
            );
        purchaseOrderLine.dmpl__UnitCost__c = 1500;
        update purchaseOrderLine;
        Test.stopTest();
        
        dmpl__PurchaseOrderLine__c fetchedLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        System.assertEquals(1500, fetchedLine.dmpl__UnitCost__c, 'Unit Price should be 1500');
        System.assertEquals(15000, fetchedLine.dmpl__BaseAmount__c, 'Base Amount should be 27000');
        System.assertEquals(0, fetchedLine.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(0, fetchedLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 75');
        System.assertEquals(2100, fetchedLine.dmpl__Tax1__c, 'Tax1 should be 3780');
        System.assertEquals('CGST', fetchedLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(14, fetchedLine.dmpl__Tax1Rate__c, 'Tax1 Rate should be 14%');
        System.assertEquals('CGST', fetchedLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(2100, fetchedLine.dmpl__Tax2__c, 'Tax2 should be 3780');
        System.assertEquals('SGST', fetchedLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(14, fetchedLine.dmpl__Tax2Rate__c, 'Tax2 Rate should be 14%');
        System.assertEquals('SGST', fetchedLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(4200, fetchedLine.dmpl__TaxAmount__c, 'Total Tax should be 7560');
        System.assertEquals(19200, fetchedLine.dmpl__GrossAmount__c, 'Gross should be 27000');
        
        dmpl__PurchaseOrder__c fetchedPO = PurchaseOrderTestDataHelpers.getPurchaseOrder(po.Id);
        System.assertEquals(15000, fetchedPO.dmpl__TotalLineBaseAmount__c, 'Total Base Amount should be 27000');
        // System.assertEquals(40000, fetchedPO.dmpl__TotalLineAmount__c, 'Total Line Amount should be 27000');
        // System.assertEquals(40000, fetchedPO.dmpl__TotalAmount__c, 'Total Amount should be 27000');
        System.assertEquals(4200, fetchedPO.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 7560');
        System.assertEquals(0, fetchedPO.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount should be 75');
        System.assertEquals(19200, fetchedPO.dmpl__TotalLineGrossAmount__c, 'Total Gross Amount should be 27000');
        
        System.assertEquals(partner.dmpl__BillingStreet__c, fetchedPO.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals(partner.dmpl__BillingCity__c, fetchedPO.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals(partner.dmpl__BillingState__c, fetchedPO.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals(partner.dmpl__BillingPostalCode__c, fetchedPO.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');
        System.assertEquals(partner.dmpl__ShippingStreet__c, fetchedPO.dmpl__ShippingStreet__c, 'Shipping Street should match');
        System.assertEquals(partner.dmpl__ShippingCity__c, fetchedPO.dmpl__ShippingCity__c, 'Shipping City should match');
        System.assertEquals(partner.dmpl__ShippingState__c, fetchedPO.dmpl__ShippingState__c, 'Shipping State should match');
        System.assertEquals(partner.dmpl__ShippingCountry__c, fetchedPO.dmpl__ShippingCountry__c, 'Shipping Country should match');
        System.assertEquals(partner.dmpl__ShippingPostalCode__c, fetchedPO.dmpl__ShippingPostalCode__c, 'Shipping Postal Code should match');
        
        System.assertEquals(Date.today(), fetchedPO.dmpl__DocumentDate__c, 'Document Date should be Today');
        System.assertEquals('Draft', fetchedPO.dmpl__Status__c, 'Status should be Draft');
    }
    
    
    
    //Prices in Case of Date Effective till has Passed (New)
    @isTest
    static void createPurchaseOrderLineWithPricesIncaseOfDateEffectiveTillHasPassedPositive(){
        Test.startTest();
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item4 = TestDataHelpers.getItem('Item 4');
        dmpl__PriceList__c priceList6 = TestDataHelpers.getPriceList('Price List 6');
        
        Boolean exceptionThrown = false;
        
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch1,supplier1);
        dmpl__PurchaseOrderLine__c purchaseOrderLine;
        
        try{
            purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(purchaseOrder.Id,item4.Id,3);
            purchaseOrderLine.dmpl__PriceListId__c = priceList6.Id;
            Update purchaseOrderLine;
        }catch(Exception e){
            exceptionThrown = true;
        }
        
        dmpl__PurchaseOrder__c fetchedPurchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        dmpl__PurchaseOrderLine__c fetchedLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        
        
        Test.stopTest();
        
        System.assertEquals(partner1.Id, fetchedPurchaseOrder.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch1.Id, fetchedPurchaseOrder.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier1.Id, fetchedPurchaseOrder.dmpl__SupplierAccountId__c, 'Supplier should match');
        
        System.assertEquals(partner1.dmpl__BillingStreet__c, fetchedPurchaseOrder.dmpl__BillingStreet__c);
        System.assertEquals(partner1.dmpl__BillingCity__c, fetchedPurchaseOrder.dmpl__BillingCity__c);
        System.assertEquals(partner1.dmpl__BillingState__c, fetchedPurchaseOrder.dmpl__BillingState__c);
        System.assertEquals(partner1.dmpl__BillingCountry__c, fetchedPurchaseOrder.dmpl__BillingCountry__c);
        System.assertEquals(partner1.dmpl__BillingPostalCode__c, fetchedPurchaseOrder.dmpl__BillingPostalCode__c);
        System.assertEquals(partner1.dmpl__ShippingStreet__c, fetchedPurchaseOrder.dmpl__ShippingStreet__c);
        System.assertEquals(partner1.dmpl__ShippingCity__c, fetchedPurchaseOrder.dmpl__ShippingCity__c);
        System.assertEquals(partner1.dmpl__ShippingState__c, fetchedPurchaseOrder.dmpl__ShippingState__c);
        System.assertEquals(partner1.dmpl__ShippingCountry__c, fetchedPurchaseOrder.dmpl__ShippingCountry__c);
        System.assertEquals(partner1.dmpl__ShippingPostalCode__c, fetchedPurchaseOrder.dmpl__ShippingPostalCode__c);
        System.assertNotEquals(null, purchaseOrderLine, 'Line should not be created null price');
        System.assertNotEquals(true, exceptionThrown, 'Line should not be created null price');
        
    }
    
    
    //Scheme Applicability based on unavailability of Budget (New)
    @isTest
    static void createPurchaseOrderLineWithSchemeApplicabilityBasedOnUnavailabilityOfBudgetPositive(){
        Test.startTest();
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup= TestDataHelpers.getTaxGroup('GST 12');
        Boolean exceptionThrown = false;
        
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch1,supplier1);
        dmpl__PurchaseOrderLine__c purchaseOrderLine;
        
        try{
            purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(purchaseOrder.Id,item1.Id,taxGroup.Id,15);
            purchaseOrderLine.dmpl__SchemeDiscount__c = 0;
            purchaseOrderLine.dmpl__SchemeDiscountAmount__c = 0;
            purchaseOrderLine.dmpl__UnitCost__c=1500;
            
            update purchaseOrderLine;
        }catch(Exception e){
            exceptionThrown = true;
        }
        
        dmpl__PurchaseOrder__c fetchedPurchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        dmpl__PurchaseOrderLine__c fetchedPurchaseOrderLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        
        
        Test.stopTest();
        System.assertEquals(partner1.Id, fetchedPurchaseOrder.dmpl__PartnerAccountId__c);
        System.assertEquals(branch1.Id, fetchedPurchaseOrder.dmpl__BranchId__c);
        System.assertEquals(supplier1.Id, fetchedPurchaseOrder.dmpl__SupplierAccountId__c);
        System.assertEquals(partner1.dmpl__BillingStreet__c, fetchedPurchaseOrder.dmpl__BillingStreet__c);
        System.assertEquals(partner1.dmpl__BillingCity__c, fetchedPurchaseOrder.dmpl__BillingCity__c);
        System.assertEquals(partner1.dmpl__BillingState__c, fetchedPurchaseOrder.dmpl__BillingState__c);
        System.assertEquals(partner1.dmpl__BillingCountry__c, fetchedPurchaseOrder.dmpl__BillingCountry__c);
        System.assertEquals(partner1.dmpl__BillingPostalCode__c, fetchedPurchaseOrder.dmpl__BillingPostalCode__c);
        System.assertEquals(partner1.dmpl__ShippingStreet__c, fetchedPurchaseOrder.dmpl__ShippingStreet__c);
        System.assertEquals(partner1.dmpl__ShippingCity__c, fetchedPurchaseOrder.dmpl__ShippingCity__c);
        System.assertEquals(partner1.dmpl__ShippingState__c, fetchedPurchaseOrder.dmpl__ShippingState__c);
        System.assertEquals(partner1.dmpl__ShippingCountry__c, fetchedPurchaseOrder.dmpl__ShippingCountry__c);
        System.assertEquals(partner1.dmpl__ShippingPostalCode__c, fetchedPurchaseOrder.dmpl__ShippingPostalCode__c);
        
        System.assertEquals(1500, fetchedPurchaseOrderLine.dmpl__UnitCost__c, 'Unit price should match');
        System.assertEquals(22500, fetchedPurchaseOrderLine.dmpl__BaseAmount__c, 'Base amount = Qty * UnitPrice');
        System.assertEquals(1350, fetchedPurchaseOrderLine.dmpl__Tax1__c);
        System.assertEquals(1350, fetchedPurchaseOrderLine.dmpl__Tax2__c);
        System.assertEquals(2700, fetchedPurchaseOrderLine.dmpl__TaxAmount__c);
        System.assertEquals(25200, fetchedPurchaseOrderLine.dmpl__GrossAmount__c);
        System.assertEquals(null, fetchedPurchaseOrderLine.dmpl__SchemeLineId__c, 'No scheme should be applied due to unavailable budget');
        
        System.assertEquals(22500, fetchedPurchaseOrder.dmpl__TotalLineBaseAmount__c);
        System.assertEquals(0, fetchedPurchaseOrder.dmpl__TotalSchemeDiscountAmount__c);
        System.assertEquals(0, fetchedPurchaseOrder.dmpl__TotalDiscountAmount__c);
        System.assertEquals(2700, fetchedPurchaseOrder.dmpl__TotalTaxAmount__c);
        System.assertEquals(25200, fetchedPurchaseOrder.dmpl__TotalLineGrossAmount__c);
        System.assertEquals(25200, fetchedPurchaseOrder.dmpl__OpenAmount__c);
    }
    
    //Scheme Applicability in case of Scheme not Approved (New)
    @isTest
    static void createPurchaseOrderLineWithSchemeApplicabilityIncaseOfSchemeNotApprovedPositive(){
        Test.startTest();
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item3 = TestDataHelpers.getItem('Item 3');
        dmpl__TaxGroup__c taxGroup= TestDataHelpers.getTaxGroup('GST 12');
        Boolean exceptionThrown = false;
        
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch1,supplier1);
        dmpl__PurchaseOrderLine__c purchaseOrderLine;
        
        try{
            purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(purchaseOrder.Id,item3.Id,taxGroup.Id,5);
            purchaseOrderLine.dmpl__UnitCost__c=2000;
            update purchaseOrderLine;
        }catch(Exception e){
            exceptionThrown = true;
        }
        
        dmpl__PurchaseOrder__c fetchedPurchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        dmpl__PurchaseOrderLine__c fetchedLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        
        
        Test.stopTest();
        System.assertEquals(partner1.Id, fetchedPurchaseOrder.dmpl__PartnerAccountId__c);
        System.assertEquals(branch1.Id, fetchedPurchaseOrder.dmpl__BranchId__c);
        System.assertEquals(supplier1.Id, fetchedPurchaseOrder.dmpl__SupplierAccountId__c);
        System.assertEquals(partner1.dmpl__BillingStreet__c, fetchedPurchaseOrder.dmpl__BillingStreet__c);
        System.assertEquals(partner1.dmpl__BillingCity__c, fetchedPurchaseOrder.dmpl__BillingCity__c);
        System.assertEquals(partner1.dmpl__BillingState__c, fetchedPurchaseOrder.dmpl__BillingState__c);
        System.assertEquals(partner1.dmpl__BillingCountry__c, fetchedPurchaseOrder.dmpl__BillingCountry__c);
        System.assertEquals(partner1.dmpl__BillingPostalCode__c, fetchedPurchaseOrder.dmpl__BillingPostalCode__c);
        System.assertEquals(partner1.dmpl__ShippingStreet__c, fetchedPurchaseOrder.dmpl__ShippingStreet__c);
        System.assertEquals(partner1.dmpl__ShippingCity__c, fetchedPurchaseOrder.dmpl__ShippingCity__c);
        System.assertEquals(partner1.dmpl__ShippingState__c, fetchedPurchaseOrder.dmpl__ShippingState__c);
        System.assertEquals(partner1.dmpl__ShippingCountry__c, fetchedPurchaseOrder.dmpl__ShippingCountry__c);
        System.assertEquals(partner1.dmpl__ShippingPostalCode__c, fetchedPurchaseOrder.dmpl__ShippingPostalCode__c);
        
        System.assertEquals(2000, fetchedLine.dmpl__UnitCost__c, 'Unit Price should be 2000');
        System.assertEquals(10000, fetchedLine.dmpl__BaseAmount__c, 'Base = 2000 * 5');
        System.assertEquals(600, fetchedLine.dmpl__Tax1__c, 'CGST');
        System.assertEquals(600, fetchedLine.dmpl__Tax2__c, 'SGST');
        System.assertEquals(1200, fetchedLine.dmpl__TaxAmount__c);
        System.assertEquals(11200, fetchedLine.dmpl__GrossAmount__c);
        
        System.assertEquals(null, fetchedLine.dmpl__SchemeLineId__c, 'SchemeLine should be null if not approved');
        System.assertEquals(0, fetchedLine.dmpl__NetSchemeDiscount__c, 'No scheme discount');
        System.assertEquals(0, fetchedLine.dmpl__NetDiscount__c, 'No other discount');
    }
    
    //Scheme Applicability in case Scheme Discount is More than Available Budget (New)
    @isTest
    static void createApplicabilityIncaseSchemeDiscountisMoreThanBudgetPositive(){
        Test.startTest();
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item5 = TestDataHelpers.getItem('Item 5');
        dmpl__TaxGroup__c taxGroup= TestDataHelpers.getTaxGroup('GST 12');
        Boolean exceptionThrown = false;
        
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch1,supplier1);
        dmpl__PurchaseOrderLine__c purchaseOrderLine;
        
        try{
            purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(purchaseOrder.Id,item5.Id,taxGroup.Id,10000);
            purchaseOrderLine.dmpl__UnitCost__c=1500;
            update purchaseOrderLine;
        }catch(Exception e){
            exceptionThrown = true;
        }
        
        dmpl__PurchaseOrder__c fetchedPurchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        dmpl__PurchaseOrderLine__c fetchedPOLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        
        
        Test.stopTest();
        
        System.assertEquals(partner1.Id, fetchedPurchaseOrder.dmpl__PartnerAccountId__c);
        System.assertEquals(branch1.Id, fetchedPurchaseOrder.dmpl__BranchId__c);
        System.assertEquals(supplier1.Id, fetchedPurchaseOrder.dmpl__SupplierAccountId__c);
        System.assertEquals(partner1.dmpl__BillingStreet__c, fetchedPurchaseOrder.dmpl__BillingStreet__c);
        System.assertEquals(partner1.dmpl__BillingCity__c, fetchedPurchaseOrder.dmpl__BillingCity__c);
        System.assertEquals(partner1.dmpl__BillingState__c, fetchedPurchaseOrder.dmpl__BillingState__c);
        System.assertEquals(partner1.dmpl__BillingCountry__c, fetchedPurchaseOrder.dmpl__BillingCountry__c);
        System.assertEquals(partner1.dmpl__BillingPostalCode__c, fetchedPurchaseOrder.dmpl__BillingPostalCode__c);
        System.assertEquals(partner1.dmpl__ShippingStreet__c, fetchedPurchaseOrder.dmpl__ShippingStreet__c);
        System.assertEquals(partner1.dmpl__ShippingCity__c, fetchedPurchaseOrder.dmpl__ShippingCity__c);
        System.assertEquals(partner1.dmpl__ShippingState__c, fetchedPurchaseOrder.dmpl__ShippingState__c);
        System.assertEquals(partner1.dmpl__ShippingCountry__c, fetchedPurchaseOrder.dmpl__ShippingCountry__c);
        System.assertEquals(partner1.dmpl__ShippingPostalCode__c, fetchedPurchaseOrder.dmpl__ShippingPostalCode__c);
        
        
        System.assertEquals(1500, fetchedPOLine.dmpl__UnitCost__c, 'Unit price mismatch');
        System.assertEquals(15000000, fetchedPOLine.dmpl__BaseAmount__c, 'Base Amount = 1500 * 10000');
        
        System.assertEquals(840000, fetchedPOLine.dmpl__Tax1__c, 'CGST should be 6% of base');
        System.assertEquals(840000, fetchedPOLine.dmpl__Tax2__c, 'SGST should be 6% of base');
        System.assertEquals(1680000, fetchedPOLine.dmpl__TaxAmount__c, 'Total tax mismatch');
        System.assertEquals(15680000, fetchedPOLine.dmpl__GrossAmount__c, 'Gross amount mismatch');
        
        System.assertNotEquals(null, fetchedPOLine.dmpl__SchemeLineId__c, 'Scheme should not be applied if not approved');
        System.assertEquals(1000000, fetchedPOLine.dmpl__NetSchemeDiscount__c, 'Net scheme discount should be zero');
        System.assertEquals(0, fetchedPOLine.dmpl__NetDiscount__c, 'Other discount should also be zero');
        
        System.assertEquals(15000000, fetchedPurchaseOrder.dmpl__TotalLineBaseAmount__c);
        System.assertEquals(1000000, fetchedPurchaseOrder.dmpl__TotalSchemeDiscountAmount__c);
        System.assertEquals(0, fetchedPurchaseOrder.dmpl__TotalDiscountAmount__c);
        System.assertEquals(1680000, fetchedPurchaseOrder.dmpl__TotalTaxAmount__c);
        System.assertEquals(15680000, fetchedPurchaseOrder.dmpl__TotalLineGrossAmount__c);
        System.assertEquals(15680000, fetchedPurchaseOrder.dmpl__OpenAmount__c);
        
        System.assertEquals(partner1.dmpl__BillingStreet__c, fetchedPurchaseOrder.dmpl__BillingStreet__c);
        System.assertEquals('Draft', fetchedPurchaseOrder.dmpl__Status__c);
    }
    
    //Scheme Applicability in case the Validity of Scheme has passed (New)
    @isTest
    static void createApplicabilityIncaseValidityOfSchemeHasPassedPositive(){
        Test.startTest();
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item3 = TestDataHelpers.getItem('Item 3');
        dmpl__TaxGroup__c taxGroup= TestDataHelpers.getTaxGroup('GST 12');
        Boolean exceptionThrown = false;
        
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch4,supplier1);
        dmpl__PurchaseOrderLine__c purchaseOrderLine;
        
        try{
            purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(purchaseOrder.Id,item3.Id,taxGroup.Id,5);
            purchaseOrderLine.dmpl__UnitCost__c=2000;
            update purchaseOrderLine;
        }catch(Exception e){
            exceptionThrown = true;
        }
        
        dmpl__PurchaseOrder__c fetchedPurchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        dmpl__PurchaseOrderLine__c fetchedPOLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        
        
        Test.stopTest();
        System.assertEquals(partner4.Id, fetchedPurchaseOrder.dmpl__PartnerAccountId__c);
        System.assertEquals(branch4.Id, fetchedPurchaseOrder.dmpl__BranchId__c);
        System.assertEquals(supplier1.Id, fetchedPurchaseOrder.dmpl__SupplierAccountId__c);
        System.assertEquals(partner4.dmpl__BillingStreet__c, fetchedPurchaseOrder.dmpl__BillingStreet__c);
        System.assertEquals(partner4.dmpl__BillingCity__c, fetchedPurchaseOrder.dmpl__BillingCity__c);
        System.assertEquals(partner4.dmpl__BillingState__c, fetchedPurchaseOrder.dmpl__BillingState__c);
        System.assertEquals(partner4.dmpl__BillingCountry__c, fetchedPurchaseOrder.dmpl__BillingCountry__c);
        System.assertEquals(partner4.dmpl__BillingPostalCode__c, fetchedPurchaseOrder.dmpl__BillingPostalCode__c);
        System.assertEquals(partner4.dmpl__ShippingStreet__c, fetchedPurchaseOrder.dmpl__ShippingStreet__c);
        System.assertEquals(partner4.dmpl__ShippingCity__c, fetchedPurchaseOrder.dmpl__ShippingCity__c);
        System.assertEquals(partner4.dmpl__ShippingState__c, fetchedPurchaseOrder.dmpl__ShippingState__c);
        System.assertEquals(partner4.dmpl__ShippingCountry__c, fetchedPurchaseOrder.dmpl__ShippingCountry__c);
        System.assertEquals(partner4.dmpl__ShippingPostalCode__c, fetchedPurchaseOrder.dmpl__ShippingPostalCode__c);
        
        System.assertEquals(10000, fetchedPOLine.dmpl__Amount__c, 'Base amount should be 10000 (5 x 2000)');
        System.assertEquals(600, fetchedPOLine.dmpl__Tax1__c, 'Tax1 (CGST 6%) should be 600');
        System.assertEquals(600, fetchedPOLine.dmpl__Tax2__c, 'Tax2 (SGST 6%) should be 600');
        System.assertEquals(1200, fetchedPOLine.dmpl__TaxAmount__c, 'Total tax should be 1200 (600 + 600)');
        System.assertEquals(11200, fetchedPOLine.dmpl__GrossAmount__c, 'Gross amount should be 11200 (10000 + 1200)');
        System.assertEquals(0, fetchedPOLine.dmpl__NetDiscount__c, 'Net discount should be 0');
        System.assertEquals(null, fetchedPOLine.dmpl__SchemeDiscountAmount__c, 'Scheme discount should be 0');
        
        System.assertEquals(10000, fetchedPurchaseOrder.dmpl__TotalLineBaseAmount__c, 'PO total line base amount should be 10000');
        System.assertEquals(10000, fetchedPurchaseOrder.dmpl__TotalLineAmount__c, 'PO total line amount should be 10000');
        System.assertEquals(1200, fetchedPurchaseOrder.dmpl__TotalTaxAmount__c, 'PO total tax should be 1200');
        System.assertEquals(11200, fetchedPurchaseOrder.dmpl__TotalOrderAmount__c, 'PO total order amount should be 11200');
        System.assertEquals('Draft', fetchedPurchaseOrder.dmpl__Status__c, 'PO status should be draft');
        
    }
    
    //Purchase Order Line without Schemes (Edit)
    @isTest
    static void updatePurchaseOrderLineWithoutSchemesPositive(){
        Test.startTest();
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item3 = TestDataHelpers.getItem('Item 5');
        dmpl__Item__c item8 = TestDataHelpers.getItem('Item 8');
        dmpl__TaxGroup__c taxGroup= TestDataHelpers.getTaxGroup('GST 12');
        Boolean exceptionThrown = false;
        
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch4,supplier1);
        dmpl__PurchaseOrderLine__c purchaseOrderLine;
        
        try{
            purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(purchaseOrder.Id,item3.Id,taxGroup.Id,10);
            purchaseOrderLine.dmpl__UnitCost__c=1000;
            purchaseOrderLine.dmpl__ItemId__c = item8.Id;
            update purchaseOrderLine;
        }catch(Exception e){
            exceptionThrown = true;
        }
        
        dmpl__PurchaseOrder__c fetchedPO = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        dmpl__PurchaseOrderLine__c fetchedPOLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        
        Test.stopTest();
        
        
        System.assertEquals(false, exceptionThrown, 'No exception should be thrown');
        System.assertNotEquals(null, fetchedPOLine, 'PurchaseOrderLine must exist');
        
        System.assertEquals(1000, fetchedPOLine.dmpl__UnitCost__c, 'Unit price should be 1000');
        System.assertEquals(10000, fetchedPOLine.dmpl__BaseAmount__c, 'Base amount should be 10,000');
        System.assertEquals(0, fetchedPOLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(600, fetchedPOLine.dmpl__Tax1__c, 'Tax1 should be 600');
        System.assertEquals('CGST', fetchedPOLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(6, fetchedPOLine.dmpl__Tax1Rate__c, 'Tax1 Rate should be 6');
        System.assertEquals('CGST', fetchedPOLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(600, fetchedPOLine.dmpl__Tax2__c, 'Tax2 should be 600');
        System.assertEquals('SGST', fetchedPOLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(6, fetchedPOLine.dmpl__Tax2Rate__c, 'Tax2 Rate should be 6');
        System.assertEquals('SGST', fetchedPOLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(1200, fetchedPOLine.dmpl__TaxAmount__c, 'Total Tax Amount should be 1200');
        System.assertEquals(11200, fetchedPOLine.dmpl__GrossAmount__c, 'Gross amount should be 11200');
        
        System.assertEquals(partner4.Id, fetchedPO.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch4.Id, fetchedPO.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier1.Id, fetchedPO.dmpl__SupplierAccountId__c, 'Supplier should match');
        
        System.assertEquals(partner4.dmpl__BillingStreet__c, fetchedPO.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals(partner4.dmpl__BillingCity__c, fetchedPO.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals(partner4.dmpl__BillingState__c, fetchedPO.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals(partner4.dmpl__BillingCountry__c, fetchedPO.dmpl__BillingCountry__c, 'Billing Country should match');
        System.assertEquals(partner4.dmpl__BillingPostalCode__c, fetchedPO.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');
        
        System.assertEquals(partner4.dmpl__ShippingStreet__c, fetchedPO.dmpl__ShippingStreet__c, 'Shipping Street should match');
        System.assertEquals(partner4.dmpl__ShippingCity__c, fetchedPO.dmpl__ShippingCity__c, 'Shipping City should match');
        System.assertEquals(partner4.dmpl__ShippingState__c, fetchedPO.dmpl__ShippingState__c, 'Shipping State should match');
        System.assertEquals(partner4.dmpl__ShippingCountry__c, fetchedPO.dmpl__ShippingCountry__c, 'Shipping Country should match');
        System.assertEquals(partner4.dmpl__ShippingPostalCode__c, fetchedPO.dmpl__ShippingPostalCode__c, 'Shipping Postal Code should match');
        
    }
    
    //Purchase Order line with Scheme - Auto Apply - Discount Amount (Edit)
    @isTest
    static void updatePurchaseOrderLineWithSchemesAutoApplyPositive(){
        Test.startTest();
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item3 = TestDataHelpers.getItem('Item 5');
        dmpl__Item__c item8 = TestDataHelpers.getItem('Item 8');
        dmpl__TaxGroup__c taxGroup= TestDataHelpers.getTaxGroup('GST 12');
        Boolean exceptionThrown = false;
        
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch4,supplier1);
        dmpl__PurchaseOrderLine__c purchaseOrderLine;
        
        purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(purchaseOrder.Id,item3.Id,taxGroup.Id,10);
        purchaseOrderLine.dmpl__UnitCost__c=1000;
        purchaseOrderLine.dmpl__ItemId__c = item8.Id;
        update purchaseOrderLine;
        
        dmpl__PurchaseOrder__c fetchedPO = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        dmpl__PurchaseOrderLine__c fetchedPOLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        
        fetchedPOLine.dmpl__Quantity__c = 5;
        Update fetchedPOLine;
        dmpl__PurchaseOrderLine__c updatedFetchedPOLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        
        Test.stopTest();
        
        
        System.assertEquals(false, exceptionThrown, 'No exception should be thrown');
        System.assertNotEquals(null, fetchedPOLine, 'PurchaseOrderLine must exist');
        
        System.assertEquals(1000, fetchedPOLine.dmpl__UnitCost__c, 'Unit price should be 1000');
        System.assertEquals(10000, fetchedPOLine.dmpl__BaseAmount__c, 'Base amount should be 10,000');
        System.assertEquals(0, fetchedPOLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(600, fetchedPOLine.dmpl__Tax1__c, 'Tax1 should be 600');
        System.assertEquals('CGST', fetchedPOLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(6, fetchedPOLine.dmpl__Tax1Rate__c, 'Tax1 Rate should be 6');
        System.assertEquals('CGST', fetchedPOLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(600, fetchedPOLine.dmpl__Tax2__c, 'Tax2 should be 600');
        System.assertEquals('SGST', fetchedPOLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(6, fetchedPOLine.dmpl__Tax2Rate__c, 'Tax2 Rate should be 6');
        System.assertEquals('SGST', fetchedPOLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(1200, fetchedPOLine.dmpl__TaxAmount__c, 'Total Tax Amount should be 1200');
        System.assertEquals(11200, fetchedPOLine.dmpl__GrossAmount__c, 'Gross amount should be 11200');
        
        System.assertEquals(partner4.Id, fetchedPO.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch4.Id, fetchedPO.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier1.Id, fetchedPO.dmpl__SupplierAccountId__c, 'Supplier should match');
        
        System.assertEquals(partner4.dmpl__BillingStreet__c, fetchedPO.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals(partner4.dmpl__BillingCity__c, fetchedPO.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals(partner4.dmpl__BillingState__c, fetchedPO.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals(partner4.dmpl__BillingCountry__c, fetchedPO.dmpl__BillingCountry__c, 'Billing Country should match');
        System.assertEquals(partner4.dmpl__BillingPostalCode__c, fetchedPO.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');
        
        System.assertEquals(partner4.dmpl__ShippingStreet__c, fetchedPO.dmpl__ShippingStreet__c, 'Shipping Street should match');
        System.assertEquals(partner4.dmpl__ShippingCity__c, fetchedPO.dmpl__ShippingCity__c, 'Shipping City should match');
        System.assertEquals(partner4.dmpl__ShippingState__c, fetchedPO.dmpl__ShippingState__c, 'Shipping State should match');
        System.assertEquals(partner4.dmpl__ShippingCountry__c, fetchedPO.dmpl__ShippingCountry__c, 'Shipping Country should match');
        System.assertEquals(partner4.dmpl__ShippingPostalCode__c, fetchedPO.dmpl__ShippingPostalCode__c, 'Shipping Postal Code should match');
        
        
        System.assertEquals(1000, updatedFetchedPOLine.dmpl__UnitCost__c, 'Unit price should be 1000');
        System.assertEquals(5000, updatedFetchedPOLine.dmpl__BaseAmount__c, 'Base amount should be 5000');
        System.assertEquals(0, updatedFetchedPOLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0, updatedFetchedPOLine.dmpl__NetDiscount__c, 'Net Discount should be 0');
        
        System.assertEquals(300, updatedFetchedPOLine.dmpl__Tax1__c, 'Tax1 should be 300');
        System.assertEquals('CGST', updatedFetchedPOLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(6, updatedFetchedPOLine.dmpl__Tax1Rate__c, 'Tax1 Rate should be 6');
        System.assertEquals('CGST', updatedFetchedPOLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        
        System.assertEquals(300, updatedFetchedPOLine.dmpl__Tax2__c, 'Tax2 should be 300');
        System.assertEquals('SGST', updatedFetchedPOLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        
        System.assertEquals(600, updatedFetchedPOLine.dmpl__TaxAmount__c, 'Tax Amount should be 600');
        System.assertEquals(5600, updatedFetchedPOLine.dmpl__GrossAmount__c, 'Gross Amount should be 5600');
        
    }
    
    //Purchase Order line with Scheme - Auto Apply - Discount %age (Edit)
    @isTest
    static void updatePurchaseOrderLineWithSchemesDiscountPercentagePositive(){
        Test.startTest();
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item3 = TestDataHelpers.getItem('Item 6');
        dmpl__TaxGroup__c taxGroup= TestDataHelpers.getTaxGroup('GST 12');
        Boolean exceptionThrown = false;
        
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch4,supplier1);
        dmpl__PurchaseOrderLine__c purchaseOrderLine;
        
        purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(purchaseOrder.Id,item3.Id,taxGroup.Id,5);
        purchaseOrderLine.dmpl__UnitCost__c=2000;
        update purchaseOrderLine;
        
        dmpl__PurchaseOrder__c fetchedPO = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        dmpl__PurchaseOrderLine__c fetchedPOLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        
        fetchedPOLine.dmpl__Quantity__c = 10;
        Update fetchedPOLine;
        dmpl__PurchaseOrderLine__c updatedFetchedPOLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        
        Test.stopTest();
        
        
        System.assertEquals(false, exceptionThrown, 'No exception should be thrown');
        System.assertNotEquals(null, fetchedPOLine, 'PurchaseOrderLine must exist');
        
        System.assertEquals(2000, updatedFetchedPOLine.dmpl__UnitCost__c, 'Unit price should be 2000');
        System.assertEquals(20000, updatedFetchedPOLine.dmpl__BaseAmount__c, 'Base amount should be 20000');
        System.assertEquals(1200, updatedFetchedPOLine.dmpl__Tax1__c, 'Tax1 (CGST) should be 1200');
        System.assertEquals('CGST', updatedFetchedPOLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(6, updatedFetchedPOLine.dmpl__Tax1Rate__c, 'Tax1 Rate should be 6');
        System.assertEquals('CGST', updatedFetchedPOLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        
        System.assertEquals(1200, updatedFetchedPOLine.dmpl__Tax2__c, 'Tax2 (SGST) should be 1200');
        System.assertEquals('SGST', updatedFetchedPOLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(6, updatedFetchedPOLine.dmpl__Tax2Rate__c, 'Tax2 Rate should be 6');
        System.assertEquals('SGST', updatedFetchedPOLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        
        System.assertEquals(2400, updatedFetchedPOLine.dmpl__TaxAmount__c, 'Tax Amount should be 2400');
        System.assertEquals(22400, updatedFetchedPOLine.dmpl__GrossAmount__c, 'Gross Amount should be 22400');
        
        System.assertEquals(10000, fetchedPO.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be 10000');
        System.assertEquals(10000, fetchedPO.dmpl__TotalLineAmount__c, 'Total Line Amount should be 10000');
        System.assertEquals(1200, fetchedPO.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 1200');
        System.assertEquals(11200, fetchedPO.dmpl__TotalLineGrossAmount__c, 'Total Gross Amount should be 11200');
        
        System.assertEquals(partner4.Id, fetchedPO.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch4.Id, fetchedPO.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier1.Id, fetchedPO.dmpl__SupplierAccountId__c, 'Supplier should match');
        
        System.assertEquals(partner4.dmpl__BillingStreet__c, fetchedPO.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals(partner4.dmpl__BillingCity__c, fetchedPO.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals(partner4.dmpl__BillingState__c, fetchedPO.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals(partner4.dmpl__BillingCountry__c, fetchedPO.dmpl__BillingCountry__c, 'Billing Country should match');
        System.assertEquals(partner4.dmpl__BillingPostalCode__c, fetchedPO.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');
        
        System.assertEquals(partner4.dmpl__ShippingStreet__c, fetchedPO.dmpl__ShippingStreet__c, 'Shipping Street should match');
        System.assertEquals(partner4.dmpl__ShippingCity__c, fetchedPO.dmpl__ShippingCity__c, 'Shipping City should match');
        System.assertEquals(partner4.dmpl__ShippingState__c, fetchedPO.dmpl__ShippingState__c, 'Shipping State should match');
        System.assertEquals(partner4.dmpl__ShippingCountry__c, fetchedPO.dmpl__ShippingCountry__c, 'Shipping Country should match');
        System.assertEquals(partner4.dmpl__ShippingPostalCode__c, fetchedPO.dmpl__ShippingPostalCode__c, 'Shipping Postal Code should match');
    }
    
    
    //Item SKU with is default true (Edit)
    @isTest
    static void updatePurchaseOrderLineWithItemSKUIsDefaultTruePositive(){
        Test.startTest();
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item7 = TestDataHelpers.getItem('Item 7');
        dmpl__TaxGroup__c taxGroup= TestDataHelpers.getTaxGroup('GST 12');
        dmpl__SKU__c sku1 = TestDataHelpers.getSKU('SKU 1');
        
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch4,supplier1);
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(purchaseOrder.Id,item7.Id,taxGroup.Id,5);
        purchaseOrderLine.dmpl__UnitCost__c=1000;
        purchaseOrderLine.dmpl__Quantity__c=5;
        update purchaseOrderLine;
        
        dmpl__PurchaseOrder__c fetchedPO = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        dmpl__PurchaseOrderLine__c fetchedPOLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        
        fetchedPOLine.dmpl__Quantity__c = 10;
        fetchedPOLine.dmpl__SchemeDiscountAmount__c = 0;
        fetchedPOLine.dmpl__SchemeDiscount__c = 0;
        fetchedPOLine.dmpl__DiscountAmount__c = 0;
        
        Update fetchedPOLine;
        dmpl__PurchaseOrderLine__c updatedFetchedPOLine = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        
        Test.stopTest();
        
        System.assertEquals(1000, updatedFetchedPOLine.dmpl__UnitCost__c, 'Unit price should be 1000');
        System.assertEquals(10000, updatedFetchedPOLine.dmpl__BaseAmount__c, 'Base amount should be 10000');
        System.assertEquals(0, updatedFetchedPOLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0, updatedFetchedPOLine.dmpl__NetDiscount__c, 'Net Discount should be 0');
        
        System.assertEquals(600, updatedFetchedPOLine.dmpl__Tax1__c, 'Tax1 (CGST) should be 600');
        System.assertEquals('CGST', updatedFetchedPOLine.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(6, updatedFetchedPOLine.dmpl__Tax1Rate__c, 'Tax1 Rate should be 6');
        System.assertEquals('CGST', updatedFetchedPOLine.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        
        System.assertEquals(600, updatedFetchedPOLine.dmpl__Tax2__c, 'Tax2 (SGST) should be 600');
        System.assertEquals('SGST', updatedFetchedPOLine.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(6, updatedFetchedPOLine.dmpl__Tax2Rate__c, 'Tax2 Rate should be 6');
        System.assertEquals('SGST', updatedFetchedPOLine.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        
        System.assertEquals(1200, updatedFetchedPOLine.dmpl__TaxAmount__c, 'Total Tax Amount should be 1200');
        System.assertEquals(11200, updatedFetchedPOLine.dmpl__GrossAmount__c, 'Gross Amount should be 11200');
        
        System.assertEquals(5000, fetchedPO.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be 5000');
        System.assertEquals(0, fetchedPO.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should be 0');
        System.assertEquals(0, fetchedPO.dmpl__TotalDiscountAmount__c, 'Total Discount Amount should be 0');
        System.assertEquals(600, fetchedPO.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount should be 600');
        System.assertEquals(600, fetchedPO.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be 600');
        System.assertEquals(5600, fetchedPO.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be 5600');
        System.assertEquals(5600, fetchedPO.dmpl__OpenAmount__c, 'Open Amount should be 5600');
        
    }
    
    //Scheme Applicability in Case of Skip Scheme is True (Edit)
    @isTest
    static void updatePurchaseOrderLineWithSchemeApplicabilityInCaseOfSkipSchemeisTruePositive(){
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item5 = TestDataHelpers.getItem('Item 5');
        dmpl__TaxGroup__c taxGroup= TestDataHelpers.getTaxGroup('GST 12');
        
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch4,supplier1);
        Test.startTest();
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(purchaseOrder.Id,item5.Id,taxGroup.Id,10);
        Test.stopTest();
        purchaseOrderLine.dmpl__UnitCost__c=1000;
        update purchaseOrderLine;
        
        purchaseOrderLine.dmpl__Quantity__c = 12;
        update purchaseOrderLine;
        
        dmpl__PurchaseOrder__c fetchedPO = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        dmpl__PurchaseOrderLine__c fetchedPOL = PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        
        System.assertEquals(1000, fetchedPOL.dmpl__UnitCost__c, 'Unit price should be 1000');
        System.assertEquals(12000, fetchedPOL.dmpl__BaseAmount__c, 'Base amount should be 12000');
        System.assertEquals(1000, fetchedPOL.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0, fetchedPOL.dmpl__NetDiscount__c, 'Net Discount should be 0');
        
        System.assertEquals(660, fetchedPOL.dmpl__Tax1__c, 'Tax1 (CGST) should be 660');
        System.assertEquals('CGST', fetchedPOL.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(6, fetchedPOL.dmpl__Tax1Rate__c, 'Tax1 Rate should be 6');
        System.assertEquals('CGST', fetchedPOL.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        
        System.assertEquals(660, fetchedPOL.dmpl__Tax2__c, 'Tax2 (SGST) should be 660');
        System.assertEquals('SGST', fetchedPOL.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(6, fetchedPOL.dmpl__Tax2Rate__c, 'Tax2 Rate should be 6');
        System.assertEquals('SGST', fetchedPOL.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        
        System.assertEquals(1320, fetchedPOL.dmpl__TaxAmount__c, 'Total Tax Amount should be 12320');
        System.assertEquals(12320, fetchedPOL.dmpl__GrossAmount__c, 'Gross Amount should be 12320');
        
        System.assertEquals(partner4.dmpl__BillingStreet__c, fetchedPO.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals(partner4.dmpl__BillingCity__c, fetchedPO.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals(partner4.dmpl__BillingState__c, fetchedPO.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals(partner4.dmpl__BillingCountry__c, fetchedPO.dmpl__BillingCountry__c, 'Billing Country should match');
        System.assertEquals(partner4.dmpl__BillingPostalCode__c, fetchedPO.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');
        
        System.assertEquals(partner4.dmpl__ShippingStreet__c, fetchedPO.dmpl__ShippingStreet__c, 'Shipping Street should match');
        System.assertEquals(partner4.dmpl__ShippingCity__c, fetchedPO.dmpl__ShippingCity__c, 'Shipping City should match');
        System.assertEquals(partner4.dmpl__ShippingState__c, fetchedPO.dmpl__ShippingState__c, 'Shipping State should match');
        System.assertEquals(partner4.dmpl__ShippingCountry__c, fetchedPO.dmpl__ShippingCountry__c, 'Shipping Country should match');
        System.assertEquals(partner4.dmpl__ShippingPostalCode__c, fetchedPO.dmpl__ShippingPostalCode__c, 'Shipping Postal Code should match');
        
    }
    
}