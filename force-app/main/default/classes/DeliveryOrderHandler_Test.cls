@isTest
public with sharing class DeliveryOrderHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(customerAccount, branch);
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup(partnerAccount, branch);
        dmpl__Tax__c tax = TestDataHelpers.createTax(taxGroup);
        dmpl__ContactAddress__c contactAddress = TestDataHelpers.createContactAddress(customerAccount);
        dmpl__DeliveryOrderLine__c deliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(item, sku, deliveryOrder);
        dmpl__DeliveryOrderTax__c deliveryOrderTax = DeliveryOrderDataHelper.createDeliveryOrderTax(deliveryOrder, deliveryOrderLine, tax);


        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1', false, true, false, true, 'MG Road', 'Bengaluru', 'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India', '560095','9876543210');
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2', false, true, false, false, '45 Residency Road', 'Pune', 'Maharashtra', 'India', '411001', '22 Commerce Avenue', 'Pune', 'Maharashtra', 'India', '411038','91-99665544433');
        Account partnerAccount3 = TestDataHelpers.createPartnerAccount('Partner 3', false, true, false, true, '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '91-9123456789');
        Account partnerAccount4 = TestDataHelpers.createPartnerAccount('Partner 4', false, true, false, true, '12 Industrial Zone', 'Hyderabad','Telangana', 'India', '500032', '12 Industrial Zone', 'Hyderabad', 'Telangana', 'India','500032','9876012345');
        Account partnerAccount6 = TestDataHelpers.createPartnerAccount('Partner 6', false, true, false, true, 'MS Road', 'Bengaluru','Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India','560095','9845543210');
 
        Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1', true, false, false, true, 'MG Road', 'Pune', 'Maharashtra', 'India', '411001', 'Ring Rd', 'Nagpur', 'Maharashtra', 'India', '440001','9876543210', 'Created');
        Account customerAccount2 = TestDataHelpers.createCustomerAccount('Customer 2', true, false, false, true, 'Park St', 'Kolkata', 'West Bengal', 'India', '700016', 'Lake Rd', 'Kolkata', 'West Bengal', 'India', '700029','9876543210', 'Created');
        Account customerAccount3 = TestDataHelpers.createCustomerAccount('Customer 3', true, false, false, true, 'Anna Salai', 'Chennai', 'Tamil Nadu', 'India', '600002', 'T Nagar', 'Chennai', 'Tamil Nadu', 'India', '600017','9012345678', 'Created');
        Account customerAccount7 = TestDataHelpers.createCustomerAccount('Customer 7', true, false, false, false, 'Mission Road', 'Bengaluru', 'Karnataka', 'India', '560027', 'Indiranagar', 'Bengaluru', 'Karnataka', 'India', '560038','9811122233', 'Created');
        Account customerAccount6 = TestDataHelpers.createCustomerAccount('Customer 6', true, false, false, true, 'Sector 18', 'Noida', 'Uttar Pradesh', 'India', '201301', 'Sector 62', 'Noida', 'Uttar Pradesh', 'India', '201309','9876501234', 'Created');
        Account customerAccount4 = TestDataHelpers.createCustomerAccount('Customer 4', true, false, false, true, 'SG Highway', 'Ahmedabad', 'GJ', 'India', '380054', 'C G Road', 'Ahmedabad', 'GJ', 'India', '380009','9988776655', 'Created');
        Account customerAccount5 = TestDataHelpers.createCustomerAccount('Customer 5', true, false, false, true, 'MG Road', 'Pune', 'Maharashtra', 'India', '411001', 'Ring Rd', 'Nagpur', 'Maharashtra', 'India', '440001','9876543210', 'Created');
       

        dmpl__Branch__c branch1 = TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id, true, true, false, true);
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partnerAccount1.Id, false, true, true, false);
        dmpl__Branch__c branch4 = TestDataHelpers.createBranch('Branch 4',partnerAccount4.Id,true,true,false,false);
        dmpl__Branch__c branch6 = TestDataHelpers.createBranch('Branch 6',partnerAccount6.Id,true,true,false,true);
 
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
 
        dmpl__Item__c  item1 = TestDataHelpers.createItem('Item 1','Product',true,false,false,'675654',false);
        dmpl__Item__c item2 = TestDataHelpers.createItem('Item 2','Product',false,false,false,'654345',false);
        dmpl__Item__c item3 = TestDataHelpers.createItem('Item 3','Charge Item',true, false, false ,'765434',true);
        dmpl__Item__c item4 = TestDataHelpers.createItem('Item 4','Product',true, false, false ,'765676',true);
        dmpl__Item__c item5 = TestDataHelpers.createItem('Item 5', 'Product', true, false, false, '876543', false);
        dmpl__Item__c item6 = TestDataHelpers.createItem('Item 6', 'Product', true, false, false, '765456', false);
        dmpl__Item__c item7 = TestDataHelpers.createItem('Item 7','Product',true,false,true, '765456',false);
        dmpl__Item__c item8 = TestDataHelpers.createItem('Item 8','Product',true,false,false, '765456',false);
    	dmpl__Item__c item9 = TestDataHelpers.createItem('Item 9', 'Product', true, false, true, '765456', false);
        dmpl__Item__c item10 = TestDataHelpers.createItem('Item 10','Product',true,false,true, '765456',false);
        dmpl__Item__c item13 = TestDataHelpers.createItem('Item 13','Product',true,false,false, '765456',true);
        dmpl__Item__c item14 = TestDataHelpers.createItem('Item 14', 'Part', true, false, false, '765458', true);
        dmpl__Item__c item15 = TestDataHelpers.createItem('Item 15', 'Part', true, false, false, '765459', false);
        dmpl__Item__c item16 = TestDataHelpers.createItem('Item 16', 'Part', true, false, false, '765460', false);
        
        dmpl__ItemGroup__c itemGroup1 = TestDataHelpers.createItemGroup('Item Group 1','Tax');
        dmpl__ItemGroupMember__c itemGroupMemeber1 = TestDataHelpers.createItemGroupMember(itemGroup1.Id,item1.Id);
        dmpl__ItemGroupMember__c itemGroupMemeber2 = TestDataHelpers.createItemGroupMember(itemGroup1.Id,item2.Id);
 
   

        dmpl__SKU__c sku1 = TestDataHelpers.createSKU('SKU 1', item7.id, true);
        dmpl__SKU__c sku2 = TestDataHelpers.createSKU('SKU 2', item8.id, false);
        dmpl__SKU__c sku3 = TestDataHelpers.createSKU('SKU 3', item9.Id, false);
        dmpl__SKU__c sku4 = TestDataHelpers.createSKU('SKU 4', item10.id, true);
 
 
        dmpl__PriceListRules__c priceListRule1 = TestDataHelpers.createPriceListRules(priceList1.id, item1.id,null,null,1500, System.today().addDays(-15),System.today()+9);
        dmpl__PriceListRules__c priceListRule3 = TestDataHelpers.createPriceListRules(priceList1.id, item3.id,null,null,2000, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule4 = TestDataHelpers.createPriceListRules(priceList1.id, item4.id,null,null,2000, System.today()-1,System.today()+9);  
        dmpl__PriceListRules__c priceListRule5 = TestDataHelpers.createPriceListRules(priceList3.id, item6.id,null,null,2000, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule7 = TestDataHelpers.createPriceListRules(priceList3.id, item5.id,null,null,1000, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule8 = TestDataHelpers.createPriceListRules(priceList1.id, item5.id,null,null,1000, System.today().addDays(-1),System.today()+9);
        dmpl__PriceListRules__c priceListRule9 = TestDataHelpers.createPriceListRules(priceList1.id, item6.id,null,null,2400, System.today()-1,System.today()+9);  
        dmpl__PriceListRules__c priceListRule10 = TestDataHelpers.createPriceListRules(priceList3.id, item1.id,null,null,1500, System.today()-1,System.today()+9);
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
        dmpl__TaxGroupRule__c taxGroupRule12Item4 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST12Global.Id,item6.Id,null,null,null);
        dmpl__TaxGroupRule__c taxGroupRuleItem1 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST12Global.Id,item1.Id,null,null,null);
  
        dmpl__TaxGroupRule__c taxGroupRule28item8 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST28partner4.Id,item8.Id,null,null,null);
        dmpl__TaxGroupRule__c taxGroupRule28Item13 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST28partner1.Id,item13.Id,null,null,null);    
        dmpl__TaxGroupRule__c taxGroupRule28Item14 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST28partner1.Id,item14.Id,null,null,null);    
        dmpl__TaxGroupRule__c taxGroupRule28Item15 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST28partner1.Id,item15.Id,null,null,null);
        dmpl__TaxGroupRule__c taxGroupRule28Item16 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST28partner1.Id,item16.Id,null,null,null);    
        dmpl__TaxGroupRule__c  taxGroupRule28Item10 = TestDataHelpers.createTaxGroupRule('Outside State',taxGroupIGST18.Id,item10.Id,null,null,null);
        dmpl__TaxGroupRule__c  taxGroupRule28Item5=TestDataHelpers.createTaxGroupRule('Outside State',taxGroupIGST18.Id,item5.Id,null,null,null);
    
        dmpl__StorageLocation__c storageLocation3 = TestDataHelpers.createStorageLocation(
            'Storage Location 3',
            branch3.Id,
            true,
            null
        );
      
         
        dmpl__StorageLocation__c storageLocation1 = TestDataHelpers.createStorageLocation(
            'Storage Location 1',
            branch1.Id,
            true,
            'Warehouse'
        );
 
   
     
    }

    
         @isTest
    static void createOrderCreationWithCorrectPartnerAndBranchPostive() {
        Test.startTest();
        Account partner4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(customer1, branch4);
        dmpl__DeliveryOrder__c fetchedOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        Test.stopTest();
       System.assertEquals(customer1.Id, fetchedOrder.dmpl__AccountId__c, 'Account Id must be Customer1 Id');
		System.assertEquals(customer1.Name, fetchedOrder.dmpl__AccountId__r.Name, 'Account Name mismatch');
		System.assertEquals(customer1.dmpl__BillingStreet__c, fetchedOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(customer1.dmpl__BillingCity__c, fetchedOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals(customer1.dmpl__BillingState__c, fetchedOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals(customer1.dmpl__BillingCountry__c, fetchedOrder.dmpl__BillingCountry__c, 'Billing state should match');
        System.assertEquals(customer1.dmpl__BillingPostalCode__c, fetchedOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(customer1.dmpl__ShippingStreet__c, fetchedOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals(customer1.dmpl__ShippingCity__c, fetchedOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals(customer1.dmpl__ShippingState__c, fetchedOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals(customer1.dmpl__ShippingCountry__c, fetchedOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals(customer1.dmpl__ShippingPostalCode__c, fetchedOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
        
    }
    
    @isTest
    static void createDeliveryOrderCreationWithCustomerAccountPositive(){
        Test.startTest();
        Account partner4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(customer1, branch4);
        dmpl__DeliveryOrder__c fetchedOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        Test.stopTest();
        System.assertEquals(customer1.Id, fetchedOrder.dmpl__AccountId__c, 'Account Id must be Customer1 Id');
		System.assertEquals(customer1.Name, fetchedOrder.dmpl__AccountId__r.Name, 'Account Name mismatch');
		System.assertEquals(customer1.dmpl__BillingStreet__c, fetchedOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(customer1.dmpl__BillingCity__c, fetchedOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals(customer1.dmpl__BillingState__c, fetchedOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals(customer1.dmpl__BillingCountry__c, fetchedOrder.dmpl__BillingCountry__c, 'Billing state should match');
        System.assertEquals(customer1.dmpl__BillingPostalCode__c, fetchedOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(customer1.dmpl__ShippingStreet__c, fetchedOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals(customer1.dmpl__ShippingCity__c, fetchedOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals(customer1.dmpl__ShippingState__c, fetchedOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals(customer1.dmpl__ShippingCountry__c, fetchedOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals(customer1.dmpl__ShippingPostalCode__c, fetchedOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
        
    }
    
    @isTest
    static void createDeliveryOrderCreationWithRepairOrderReferencePositive() {
        Test.startTest();
        
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Asset asset = TestDataHelpers.createAsset('Asset 1', customer1.Id, item1.Id);
        
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrder(
            partner1,
        customer1,
        branch1,
        asset,
        300
            );
        
        dmpl__RepairOrderLine__c repairOrderLine = RepairOrderTestDataHelpers.createRepairOrderLine(
            repairOrder.Id,
        item1.Id,
        10.00,
        1500.00
            );
        
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(
         partner1.Id,
        customer1.Id,
        branch1.Id,
        repairOrder.Id,
        null,
        null
            );
        
        dmpl__DeliveryOrder__c fetchedOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        
        Test.stopTest();
        
     	System.assertEquals(customer1.Id, fetchedOrder.dmpl__AccountId__c, 'Account Id must be Customer1 Id');
		System.assertEquals(customer1.Name, fetchedOrder.dmpl__AccountId__r.Name, 'Account Name mismatch');
		System.assertEquals(customer1.dmpl__BillingStreet__c, fetchedOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(customer1.dmpl__BillingCity__c, fetchedOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals(customer1.dmpl__BillingState__c, fetchedOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals(customer1.dmpl__BillingCountry__c, fetchedOrder.dmpl__BillingCountry__c, 'Billing state should match');
        System.assertEquals(customer1.dmpl__BillingPostalCode__c, fetchedOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(customer1.dmpl__ShippingStreet__c, fetchedOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals(customer1.dmpl__ShippingCity__c, fetchedOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals(customer1.dmpl__ShippingState__c, fetchedOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals(customer1.dmpl__ShippingCountry__c, fetchedOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals(customer1.dmpl__ShippingPostalCode__c, fetchedOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
        
        System.assertEquals('Draft', fetchedOrder.dmpl__Status__c, 'Status mismatch');
    }
    
    @isTest
    static void createDeliveryOrderCreationWithWrongPartnerAccountNegative() {
        Boolean exceptionThrown = false;
        
        Test.startTest();
        
        Account partner3 = TestDataHelpers.getPartnerAccount('Partner 3');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        
        Test.stopTest();
        try {
            dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner3.Id,customer1.Id, branch1.Id,null,null, null);

        } catch (Exception e) {
            exceptionThrown = true;
            System.debug('Expected exception caught: ' + e.getMessage());
        }
        
        System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown when using a wrong partner account');
    }
    
    @isTest
    static void createDeliveryOrderWithInactivePartnerAccountNegative(){
        Boolean exceptionThrown = false;
        
        Test.startTest();
        
        Account partner2 = TestDataHelpers.getPartnerAccount('Partner 2');
		
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        
        Test.stopTest();
        try {
			dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partner2.Id, true, false, true, true);
            dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner2.Id,customer1.Id, branch2.Id,null,null,null);
        } catch (Exception e) {
            exceptionThrown = true;
            System.debug('Expected exception caught: ' + e.getMessage());
        }
        
        System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown when using a wrong partner account');
        
    }
    
    @isTest
    static void createDeliveryOrderCreationWithWrongBranchNegative(){
        Boolean exceptionThrown = false;
        
        Test.startTest();
        
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner2 = TestDataHelpers.getPartnerAccount('Partner 2');
        
        Test.stopTest();
        try {
        	dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partner2.Id, true, false, true, true);

            dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner1.Id,customer1.Id, branch2.Id,null,null,null);
        } catch (Exception e) {
            exceptionThrown = true;
            System.debug('Expected exception caught: ' + e.getMessage());
        }
        
        System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown when using a wrong Branch account');
        
    }
    
    @isTest
    static void createDeliveryOrderCreationWithInactiveBranchNegative(){
        Boolean exceptionThrown = false;
        
        Test.startTest();
        
        Account partner3 = TestDataHelpers.getPartnerAccount('Partner 3');
        dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        
        Test.stopTest();
        try {
            dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(customer1, branch3);
        } catch (Exception e) {
            exceptionThrown = true;
            System.debug('Expected exception caught: ' + e.getMessage());
        }
        
        System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown when using a wrong partner account');
        
    }
    
    @isTest
    static void createDeliveryOrderCreationWithNoCustomerAccountNegative(){
        Boolean exceptionThrown = false;
        
        Test.startTest();
        
        Account partner3 = TestDataHelpers.getPartnerAccount('Partner 3');
        dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');
        
        Test.stopTest();
        try {
            dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(null, branch3);
        } catch (Exception e) {
            exceptionThrown = true;
            System.debug('Expected exception caught: ' + e.getMessage());
        }
        
        System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown when using a wrong partner account');
        
    }
    @isTest
    static void createDeliveryOrderreationWithNoSaleOrderPositive() {
        Test.startTest();
        
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(
            partner1.Id,
        customer1.Id,
        branch1.Id,
        null,
        null,
        null
            );
        
        dmpl__DeliveryOrder__c fetchedOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        
        Test.stopTest();
        
        System.assertEquals(partner1.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner mismatch');
        System.assertEquals(branch1.Id, fetchedOrder.dmpl__BranchId__c, 'Branch mismatch');
        System.assertEquals(customer1.Id, fetchedOrder.dmpl__AccountId__c, 'Customer mismatch');
        
         System.assertEquals(customer1.Id, fetchedOrder.dmpl__AccountId__c, 'Account Id must be Customer1 Id');
		System.assertEquals(customer1.Name, fetchedOrder.dmpl__AccountId__r.Name, 'Account Name mismatch');
		System.assertEquals(customer1.dmpl__BillingStreet__c, fetchedOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(customer1.dmpl__BillingCity__c, fetchedOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals(customer1.dmpl__BillingState__c, fetchedOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals(customer1.dmpl__BillingCountry__c, fetchedOrder.dmpl__BillingCountry__c, 'Billing state should match');
        System.assertEquals(customer1.dmpl__BillingPostalCode__c, fetchedOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(customer1.dmpl__ShippingStreet__c, fetchedOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals(customer1.dmpl__ShippingCity__c, fetchedOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals(customer1.dmpl__ShippingState__c, fetchedOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals(customer1.dmpl__ShippingCountry__c, fetchedOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals(customer1.dmpl__ShippingPostalCode__c, fetchedOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
        System.assertEquals(null, fetchedOrder.dmpl__SaleOrderId__c, 'Sale Order should be null');
    }
    
    @isTest
    static void createDeliveryOrderCreationWithNoRepairOrderPositive() {
        Test.startTest();
        
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(
            partner1.Id,
        customer1.Id,
        branch1.Id,
        null,
        null,
        null
            );
        
        dmpl__DeliveryOrder__c fetchedOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        
        Test.stopTest();
        
        System.assertEquals(partner1.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner mismatch');
        System.assertEquals(branch1.Id, fetchedOrder.dmpl__BranchId__c, 'Branch mismatch');
        System.assertEquals(customer1.Id, fetchedOrder.dmpl__AccountId__c, 'Customer mismatch');
        System.assertEquals(customer1.Id, fetchedOrder.dmpl__AccountId__c, 'Account Id must be Customer1 Id');
		System.assertEquals(customer1.Name, fetchedOrder.dmpl__AccountId__r.Name, 'Account Name mismatch');
		System.assertEquals(customer1.dmpl__BillingStreet__c, fetchedOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(customer1.dmpl__BillingCity__c, fetchedOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals(customer1.dmpl__BillingState__c, fetchedOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals(customer1.dmpl__BillingCountry__c, fetchedOrder.dmpl__BillingCountry__c, 'Billing state should match');
        System.assertEquals(customer1.dmpl__BillingPostalCode__c, fetchedOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(customer1.dmpl__ShippingStreet__c, fetchedOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals(customer1.dmpl__ShippingCity__c, fetchedOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals(customer1.dmpl__ShippingState__c, fetchedOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals(customer1.dmpl__ShippingCountry__c, fetchedOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals(customer1.dmpl__ShippingPostalCode__c, fetchedOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
        System.assertEquals(null, fetchedOrder.dmpl__SaleOrderId__c, 'Sale Order should be null');
        System.assertEquals(null, fetchedOrder.dmpl__RepairOrderId__c, 'Sale Order should be null');
    }
    
    @isTest
    static void updateDeliveryOrderCreationWithCustomerAccountPositive() {
        Test.startTest();
        
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account customer3 = TestDataHelpers.getCustomerAccount('Customer 3');
        
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(
            partner1.Id,
        customer3.Id,
        branch1.Id,
        null,
        null,
        null
            );
        
        dmpl__DeliveryOrder__c fetchedOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        
        Test.stopTest();
        
        System.assertEquals(customer3.Id, fetchedOrder.dmpl__AccountId__c, 'Customer mismatch');
		System.assertEquals(customer3.Name, fetchedOrder.dmpl__AccountId__r.Name, 'Account Name mismatch');
		System.assertEquals(customer3.dmpl__BillingStreet__c, fetchedOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(customer3.dmpl__BillingCity__c, fetchedOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals(customer3.dmpl__BillingState__c, fetchedOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals(customer3.dmpl__BillingCountry__c, fetchedOrder.dmpl__BillingCountry__c, 'Billing state should match');
        System.assertEquals(customer3.dmpl__BillingPostalCode__c, fetchedOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(customer3.dmpl__ShippingStreet__c, fetchedOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals(customer3.dmpl__ShippingCity__c, fetchedOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals(customer3.dmpl__ShippingState__c, fetchedOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals(customer3.dmpl__ShippingCountry__c, fetchedOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals(customer3.dmpl__ShippingPostalCode__c, fetchedOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
        System.assertEquals(branch1.Id, fetchedOrder.dmpl__BranchId__c, 'Branch mismatch');
        System.assertEquals(partner1.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner mismatch');
    }
    

    
    @isTest
    static void createDeliveryOrderLinePositive() {
        dmpl__DeliveryOrderLine__c deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine();
        
        System.assertEquals(1, deliveryOrderLine.dmpl__Quantity__c, 'Quantity should be 1.');
    }

    @isTest
    static void createDeliveryOrderTaxPositive() {
        dmpl__DeliveryOrderTax__c deliveryOrderTax = DeliveryOrderDataHelper.getDeliveryOrderTax();
        
        System.assertEquals(150, deliveryOrderTax.dmpl__TaxAmount__c, 'Tax Amount of Delivery Order Tax must be 150');
    }

    @isTest
    static void updateDeliveryOrderPositive() {
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder();
        System.assertNotEquals(deliveryOrder, null, 'Delivery Order should exist before update.');
        deliveryOrder.dmpl__Discount__c = 99;
        update deliveryOrder;
        dmpl__DeliveryOrder__c deliveryOrderUpdated = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        System.assertEquals(99, deliveryOrderUpdated.dmpl__Discount__c, 'Expected Delivery ORder Discount to be updated to 99.');
    }

    @isTest
    static void updateDeliveryOrderLinePositive() {
        dmpl__DeliveryOrderLine__c deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine();
        
        deliveryOrderLine.dmpl__Quantity__c = 5;
        update deliveryOrderLine;
        dmpl__DeliveryOrderLine__c updatedLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);
        System.assertEquals(5, updatedLine.dmpl__Quantity__c, 'Quantity should be updated to 5.');
    }

    @isTest
    static void updateDeliveryOrderTaxPositive() {
        dmpl__DeliveryOrderTax__c deliveryOrderTax = DeliveryOrderDataHelper.getDeliveryOrderTax();
        System.assertNotEquals(deliveryOrderTax, null, 'Delivery Order Tax should exist before update.');
        deliveryOrderTax.dmpl__TaxAmount__c = 100;
        update deliveryOrderTax;
        dmpl__DeliveryOrderTax__c deliveryOrderTaxUpdated = DeliveryOrderDataHelper.getDeliveryOrderTax(deliveryOrderTax.id);
        System.assertEquals(100, deliveryOrderTaxUpdated.dmpl__TaxAmount__c, 'Expected saleInvoice status to be updated to Submitted.');
    }
  
    @isTest
    static void deleteDeliveryOrderTax() {
        dmpl__DeliveryOrderTax__c deliveryOrderTax = DeliveryOrderDataHelper.getDeliveryOrderTax();
        

        delete deliveryOrderTax;

        dmpl__DeliveryOrderTax__c deletedTax;
        try {
            deletedTax = DeliveryOrderDataHelper.getDeliveryOrderTax(deliveryOrderTax.Id);
        } catch (Exception e) {
            deletedTax = null;
        }
        System.assertEquals(null, deletedTax, 'DeliveryOrderTax should be deleted and not found in query.');
    }

    @isTest
    static void deleteDeliveryOrderLine() {
        dmpl__DeliveryOrderLine__c deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine();
        
    
        try {
            delete deliveryOrderLine;
        } catch (DmlException e) {
            System.debug('Delete failed: ' + e.getMessage());
            System.assert(e.getMessage().contains('downstream transaction'), 'Expected FIELD_CUSTOM_VALIDATION_EXCEPTION due to downstream transaction.');
            return;
        }
        dmpl__DeliveryOrderLine__c deletedLine;
        try {
            deletedLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);
        } catch (Exception e) {
            deletedLine = null;
        }
        System.assertEquals(null, deletedLine, 'DeliveryOrderLine should be deleted and not found in query.');
    }

    @isTest
    static void deleteDeliveryOrder() {
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder();
        

        delete deliveryOrder;

        dmpl__DeliveryOrder__c deletedOrder;
        try {
            deletedOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        } catch (Exception e) {
            deletedOrder = null;
        }
        System.assertEquals(null, deletedOrder, 'DeliveryOrder should be deleted and not found in query.');
    }



    @isTest
    static void createDeliveryOrderLineWithWrongStorageLocationNegativeTest() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1'); 
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 8');
        dmpl__StorageLocation__c wrongStorageLocation = TestDataHelpers.getStorageLocation('Storage Location 3');

        dmpl__DeliveryOrder__c createdDeliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(
            partnerAccount.Id,
            customerAccount.Id,
            branch.Id,
            null,
            null,
            null
        );
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(createdDeliveryOrder.Id);
       System.assertEquals('Customer 1', deliveryOrder.dmpl__AccountName__c, 'Account name should match');
       String expectedbillingAddress = 'MG Road\nPune, Maharashtra, India, 411001';
        System.assertEquals(expectedbillingAddress, deliveryOrder.dmpl__BillingAddress__c, 'Billing address should match');
        System.assertEquals('Pune', deliveryOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals('411001', deliveryOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals('Maharashtra', deliveryOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals('MG Road', deliveryOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(Date.today(), deliveryOrder.dmpl__DocumentDate__c, 'Document date should match');
        String expectedShippingAddress = 'Ring Rd\nNagpur, Maharashtra, India, 440001';
        System.assertEquals(expectedShippingAddress, deliveryOrder.dmpl__ShippingAddress__c, 'Shipping address should match');
        System.assertEquals('Nagpur', deliveryOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals('India', deliveryOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals('440001', deliveryOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
        System.assertEquals('Maharashtra', deliveryOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals('Ring Rd', deliveryOrder.dmpl__ShippingStreet__c, 'Shipping street should match');


        Test.startTest();
        try {
            dmpl__DeliveryOrderLine__c deliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(
                deliveryOrder.Id,
                item.Id,
                null, 
                1, 
                100, 
                wrongStorageLocation.Id,
                null, 
                null ,
				null
            );
           
        } catch (Exception e) {
            System.assertEquals('Storage Location is not valid', e.getMessage(), 'Expected validation error for invalid storage location');
        }
        Test.stopTest();
    }


		
	
	@isTest
	static void createDeliveryOrderLineWithActiveItemPositive () {
		Test.startTest();
		Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
		Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
		dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder( partner1.Id, customer1.Id, branch1.Id, null, null,null);
		dmpl__DeliveryOrderLine__c deliveryOrderLine;
		try{
			deliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(deliveryOrder.Id, item1.Id, null, 2, 1500, null, null, null, null);
		}catch(Exception e){
			System.Assert.isTrue(false, 'Need to be able to create a delivery order line');
		}

		deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
		deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);

		System.assertEquals(customer1.Id, deliveryOrder.dmpl__AccountId__c, 'Account Id must be Customer1 Id');
		System.assertEquals(customer1.Name, deliveryOrder.dmpl__AccountId__r.Name, 'Account Name mismatch');
		System.assertEquals(customer1.dmpl__BillingStreet__c, deliveryOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(customer1.dmpl__BillingCity__c, deliveryOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals(customer1.dmpl__BillingState__c, deliveryOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals(customer1.dmpl__BillingCountry__c, deliveryOrder.dmpl__BillingCountry__c, 'Billing state should match');
        System.assertEquals(customer1.dmpl__BillingPostalCode__c, deliveryOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
		
        System.assertEquals(customer1.dmpl__ShippingStreet__c, deliveryOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals(customer1.dmpl__ShippingCity__c, deliveryOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals(customer1.dmpl__ShippingState__c, deliveryOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals(customer1.dmpl__ShippingCountry__c, deliveryOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals(customer1.dmpl__ShippingPostalCode__c, deliveryOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
        
		
		
		System.assertEquals(partner1.Id, deliveryOrder.dmpl__PartnerAccountId__c, 'Partner Account ID mismatch');
		System.assertEquals(partner1.Name, deliveryOrder.dmpl__PartnerAccountId__r.Name, 'Partner Account ID mismatch');
		System.assertEquals(branch1.Id, deliveryOrder.dmpl__BranchId__c, 'Branch ID mismatch');
		System.assertEquals(branch1.Name, deliveryOrder.dmpl__BranchId__r.Name, 'Branch ID mismatch');

		System.assertEquals(item1.Id, deliveryOrderLine.dmpl__ItemId__c, 'Item ID must be Item 1 ID');
		System.assertEquals(item1.Name, deliveryOrderLine.dmpl__ItemId__r.Name, 'Item Name mismatch');
		System.assertEquals(1500, deliveryOrderLine.dmpl__UnitPrice__c, 'Unit Cost mismatch');
		System.assertEquals(2, deliveryOrderLine.dmpl__Quantity__c, 'Quantity mismatch');

		Test.stopTest();
	}



	
	@isTest
	static void createDeliveryOrderLineWithRequiredSKUPositive () {
		Test.startTest();
		Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
		Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Item__c item10 = TestDataHelpers.getItem('Item 10'); 
		dmpl__SKU__c sku4 = TestDataHelpers.getSKU('SKU 4'); 
		dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('IGST 18'); 
		dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner1.Id, customer1.Id, branch1.Id, null, null,null);
		dmpl__DeliveryOrderLine__c deliveryOrderLine;
		try{
			deliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(deliveryOrder.Id, item10.Id, taxGroup.Id, 10, 1200, null, null, null, sku4.Id);
		}catch(Exception e){
			System.Assert.isTrue(false, 'Need to be able to create a delivery order line');
		}

		deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
		deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);

		System.assertEquals(customer1.Id, deliveryOrder.dmpl__AccountId__c, 'Account Id must be Customer1 Id');
		System.assertEquals(customer1.Name, deliveryOrder.dmpl__AccountId__r.Name, 'Account Name mismatch');
		System.assertEquals(customer1.dmpl__BillingStreet__c, deliveryOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(customer1.dmpl__BillingCity__c, deliveryOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals(customer1.dmpl__BillingState__c, deliveryOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals(customer1.dmpl__BillingCountry__c, deliveryOrder.dmpl__BillingCountry__c, 'Billing state should match');
        System.assertEquals(customer1.dmpl__BillingPostalCode__c, deliveryOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
		
        System.assertEquals(customer1.dmpl__ShippingStreet__c, deliveryOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals(customer1.dmpl__ShippingCity__c, deliveryOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals(customer1.dmpl__ShippingState__c, deliveryOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals(customer1.dmpl__ShippingCountry__c, deliveryOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals(customer1.dmpl__ShippingPostalCode__c, deliveryOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
        
		
		
		System.assertEquals(partner1.Id, deliveryOrder.dmpl__PartnerAccountId__c, 'Partner Account ID mismatch');
		System.assertEquals(partner1.Name, deliveryOrder.dmpl__PartnerAccountId__r.Name, 'Partner Account ID mismatch');
		System.assertEquals(branch1.Id, deliveryOrder.dmpl__BranchId__c, 'Branch ID mismatch');
		System.assertEquals(branch1.Name, deliveryOrder.dmpl__BranchId__r.Name, 'Branch ID mismatch');

		System.assertEquals(item10.Id, deliveryOrderLine.dmpl__ItemId__c, 'Item ID must be Item 10 ID');
		System.assertEquals(item10.Name, deliveryOrderLine.dmpl__ItemId__r.Name, 'Item Name mismatch');
		System.assertEquals(sku4.Id, deliveryOrderLine.dmpl__SKUId__c, 'SKU ID must be SKU 4 ID');
		System.assertEquals(sku4.Name, deliveryOrderLine.dmpl__SKUId__r.Name, 'SKU Name mismatch');
		System.assertEquals(1200, deliveryOrderLine.dmpl__UnitPrice__c, 'Unit Price mismatch');
		System.assertEquals(taxGroup.Id, deliveryOrderLine.dmpl__TaxGroupId__c, 'Tax Group ID must be IGST 18%'); 
		System.assertEquals(taxGroup.Name, deliveryOrderLine.dmpl__TaxGroupId__r.Name, 'Tax Group Name mismatch'); 
		System.assertEquals(10, deliveryOrderLine.dmpl__Quantity__c, 'Quantity mismatch');

		Test.stopTest();
	}

	
	@isTest
	static void createDeliveryOrderLineWithNoRequiredSKUPositive () {
		Test.startTest();
		Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
		Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
		dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('IGST 18'); 
		dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner1.Id, customer1.Id, branch1.Id, null, null,null);
		dmpl__DeliveryOrderLine__c deliveryOrderLine;
		try{
			deliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(deliveryOrder.Id, item1.Id, taxGroup.Id, 10, 1500, null, null, null, null);
		}catch(Exception e){
			System.Assert.isTrue(false, 'Need to be able to create a delivery order line');
		}

		deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
		deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);
		
		System.assertEquals(customer1.Id, deliveryOrder.dmpl__AccountId__c, 'Account Id must be Customer1 Id');
		System.assertEquals(customer1.Name, deliveryOrder.dmpl__AccountId__r.Name, 'Account Name mismatch');
		System.assertEquals(customer1.dmpl__BillingStreet__c, deliveryOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(customer1.dmpl__BillingCity__c, deliveryOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals(customer1.dmpl__BillingState__c, deliveryOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals(customer1.dmpl__BillingCountry__c, deliveryOrder.dmpl__BillingCountry__c, 'Billing state should match');
        System.assertEquals(customer1.dmpl__BillingPostalCode__c, deliveryOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
		
        System.assertEquals(customer1.dmpl__ShippingStreet__c, deliveryOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals(customer1.dmpl__ShippingCity__c, deliveryOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals(customer1.dmpl__ShippingState__c, deliveryOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals(customer1.dmpl__ShippingCountry__c, deliveryOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals(customer1.dmpl__ShippingPostalCode__c, deliveryOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
        
		
		
		System.assertEquals(partner1.Id, deliveryOrder.dmpl__PartnerAccountId__c, 'Partner Account ID mismatch');
		System.assertEquals(partner1.Name, deliveryOrder.dmpl__PartnerAccountId__r.Name, 'Partner Account ID mismatch');
		System.assertEquals(branch1.Id, deliveryOrder.dmpl__BranchId__c, 'Branch ID mismatch');
		System.assertEquals(branch1.Name, deliveryOrder.dmpl__BranchId__r.Name, 'Branch ID mismatch');


		System.assertEquals(15000, deliveryOrder.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount mismatch');
		System.assertEquals(17700, deliveryOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount mismatch');
		System.assertEquals(15000, deliveryOrder.dmpl__TotalLineAmount__c, 'Total Line Amount mismatch');
		System.assertEquals(17700, deliveryOrder.dmpl__TotalAmount__c, 'Total Amount mismatch');
		System.assertEquals(2700, deliveryOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount mismatch');

		System.assertEquals(deliveryOrder.Id, deliveryOrderLine.dmpl__DeliveryId__c, 'Delivery ID must match the expected Delivery Order ID');
		System.assertEquals(item1.Id, deliveryOrderLine.dmpl__ItemId__c, 'Item ID must match Item 1 ID');
		System.assertEquals(item1.Name, deliveryOrderLine.dmpl__ItemId__r.Name, 'Item Name mismatch');
		System.assertEquals(10, deliveryOrderLine.dmpl__Quantity__c, 'Quantity mismatch');
		System.assertEquals(taxGroup.Id, deliveryOrderLine.dmpl__TaxGroupId__c, 'Tax Group ID must be IGST 18%'); 
		System.assertEquals(taxGroup.Name, deliveryOrderLine.dmpl__TaxGroupId__r.Name, 'Tax Group Name mismatch'); 
		System.assertEquals(1500, deliveryOrderLine.dmpl__UnitPrice__c, 'Unit Price mismatch');
		System.assertEquals(15000, deliveryOrderLine.dmpl__Amount__c, 'Amount mismatch');
		System.assertEquals(15000, deliveryOrderLine.dmpl__BaseAmount__c, 'Base Amount mismatch');
		System.assertEquals(17700, deliveryOrderLine.dmpl__GrossAmount__c, 'Gross Amount mismatch');
		System.assertEquals(0, deliveryOrderLine.dmpl__NetDiscount__c, 'Net Discount mismatch');
		System.assertEquals(2700, deliveryOrderLine.dmpl__TaxAmount__c, 'Tax Amount mismatch');

		Test.stopTest();
	}

	
	@isTest
	static void createDeliveryOrderLineWithStorageLocationPositive () {
		Test.startTest();

		Account partner4 = TestDataHelpers.getPartnerAccount('Partner 4');
		dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
		Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
		dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 288'); 
		dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation('Storage Location 1'); 
		dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner4.Id, customer1.Id, branch4.Id, null, null,null);
		dmpl__DeliveryOrderLine__c deliveryOrderLine;
		try{
			deliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(deliveryOrder.Id, item1.Id, taxGroup.Id, 5, 1500, storageLocation.Id, null, null, null);
		}catch(Exception e){
			System.Assert.isTrue(false, 'Need to be able to create a delivery order line');
		}

		deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
		deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);
		
		System.assertEquals(customer1.Id, deliveryOrder.dmpl__AccountId__c, 'Account Id must be Customer1 Id');
		System.assertEquals(customer1.Name, deliveryOrder.dmpl__AccountId__r.Name, 'Account Name mismatch');
		System.assertEquals(customer1.dmpl__BillingStreet__c, deliveryOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(customer1.dmpl__BillingCity__c, deliveryOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals(customer1.dmpl__BillingState__c, deliveryOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals(customer1.dmpl__BillingCountry__c, deliveryOrder.dmpl__BillingCountry__c, 'Billing state should match');
        System.assertEquals(customer1.dmpl__BillingPostalCode__c, deliveryOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
		
        System.assertEquals(customer1.dmpl__ShippingStreet__c, deliveryOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals(customer1.dmpl__ShippingCity__c, deliveryOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals(customer1.dmpl__ShippingState__c, deliveryOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals(customer1.dmpl__ShippingCountry__c, deliveryOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals(customer1.dmpl__ShippingPostalCode__c, deliveryOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
        
		
		
		System.assertEquals(partner4.Id, deliveryOrder.dmpl__PartnerAccountId__c, 'Partner Account ID mismatch');
		System.assertEquals(partner4.Name, deliveryOrder.dmpl__PartnerAccountId__r.Name, 'Partner Account ID mismatch');
		System.assertEquals(branch4.Id, deliveryOrder.dmpl__BranchId__c, 'Branch ID mismatch');
		System.assertEquals(branch4.Name, deliveryOrder.dmpl__BranchId__r.Name, 'Branch ID mismatch');

		System.assertEquals(item1.Id, deliveryOrderLine.dmpl__ItemId__c, 'Item ID must be item 1');
		System.assertEquals(item1.Name, deliveryOrderLine.dmpl__ItemId__r.Name, 'Item Name mismatch');
		System.assertEquals(5, deliveryOrderLine.dmpl__Quantity__c, 'Quantity mismatch');
		System.assertEquals(taxGroup.Id, deliveryOrderLine.dmpl__TaxGroupId__c, 'Tax Group ID must be GST 28%');
		System.assertEquals(taxGroup.Name, deliveryOrderLine.dmpl__TaxGroupId__r.Name, 'Tax Group Name mismatch');
		System.assertEquals(1500, deliveryOrderLine.dmpl__UnitPrice__c, 'Unit Price mismatch');
		System.assertEquals(storageLocation.Id, deliveryOrderLine.dmpl__StorageLocationId__c, 'Storage Location ID must be Storage Location 1');
		System.assertEquals(storageLocation.Name, deliveryOrderLine.dmpl__StorageLocationId__r.Name, 'Storage Location Name mismatch');
		System.assertEquals(7500, deliveryOrderLine.dmpl__Amount__c, 'Amount mismatch');
		System.assertEquals(7500, deliveryOrderLine.dmpl__BaseAmount__c, 'Base Amount mismatch');
		System.assertEquals(9600, deliveryOrderLine.dmpl__GrossAmount__c, 'Gross Amount mismatch');
		
		System.assertEquals(2100, deliveryOrderLine.dmpl__TaxAmount__c, 'Tax Amount mismatch');

		System.assertEquals(7500, deliveryOrder.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount mismatch');
		System.assertEquals(9600, deliveryOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount mismatch');
		System.assertEquals(7500, deliveryOrder.dmpl__TotalLineAmount__c, 'Total Line Amount mismatch');
		System.assertEquals(9600, deliveryOrder.dmpl__TotalAmount__c, 'Total Amount mismatch');
		System.assertEquals(2100, deliveryOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount mismatch');
		

		Test.stopTest();
	}
	
	@isTest
	static void createDeliveryOrderLineWithEnteredQuantityPositive () {
		Test.startTest();

		
		Account partner4 = TestDataHelpers.getPartnerAccount('Partner 4');
		dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
		Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
		dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 288'); 
		dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner4.Id, customer1.Id, branch4.Id, null, null,null);
		dmpl__DeliveryOrderLine__c deliveryOrderLine;
		try{
			deliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(deliveryOrder.Id, item1.Id, taxGroup.Id, 2, 1500, null, null, null, null);
		}catch(Exception e){
			System.Assert.isTrue(false, 'Need to be able to create a delivery order line');
		}

		deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
		deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);
		
		System.assertEquals(customer1.Id, deliveryOrder.dmpl__AccountId__c, 'Account Id must be Customer1 Id');
		System.assertEquals(customer1.Name, deliveryOrder.dmpl__AccountId__r.Name, 'Account Name mismatch');
		System.assertEquals(customer1.dmpl__BillingStreet__c, deliveryOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(customer1.dmpl__BillingCity__c, deliveryOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals(customer1.dmpl__BillingState__c, deliveryOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals(customer1.dmpl__BillingCountry__c, deliveryOrder.dmpl__BillingCountry__c, 'Billing state should match');
        System.assertEquals(customer1.dmpl__BillingPostalCode__c, deliveryOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
		
        System.assertEquals(customer1.dmpl__ShippingStreet__c, deliveryOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals(customer1.dmpl__ShippingCity__c, deliveryOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals(customer1.dmpl__ShippingState__c, deliveryOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals(customer1.dmpl__ShippingCountry__c, deliveryOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals(customer1.dmpl__ShippingPostalCode__c, deliveryOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
        
		
		
		System.assertEquals(partner4.Id, deliveryOrder.dmpl__PartnerAccountId__c, 'Partner Account ID mismatch');
		System.assertEquals(partner4.Name, deliveryOrder.dmpl__PartnerAccountId__r.Name, 'Partner Account ID mismatch');
		System.assertEquals(branch4.Id, deliveryOrder.dmpl__BranchId__c, 'Branch ID mismatch');
		System.assertEquals(branch4.Name, deliveryOrder.dmpl__BranchId__r.Name, 'Branch ID mismatch');

		System.assertEquals(item1.Id, deliveryOrderLine.dmpl__ItemId__c, 'Item ID must be item 1');
		System.assertEquals(item1.Name, deliveryOrderLine.dmpl__ItemId__r.Name, 'Item Name mismatch');
		System.assertEquals(2, deliveryOrderLine.dmpl__Quantity__c, 'Quantity mismatch');
		System.assertEquals(taxGroup.Id, deliveryOrderLine.dmpl__TaxGroupId__c, 'Tax Group ID must be GST 28%');
		System.assertEquals(taxGroup.Name, deliveryOrderLine.dmpl__TaxGroupId__r.Name, 'Tax Group Name mismatch');
		System.assertEquals(1500, deliveryOrderLine.dmpl__UnitPrice__c, 'Unit Price mismatch');
		System.assertEquals(3000, deliveryOrderLine.dmpl__Amount__c, 'Amount mismatch');
		System.assertEquals(3000, deliveryOrderLine.dmpl__BaseAmount__c, 'Base Amount mismatch');
		System.assertEquals(3840, deliveryOrderLine.dmpl__GrossAmount__c, 'Gross Amount mismatch');
		System.assertEquals(0, deliveryOrderLine.dmpl__NetDiscount__c, 'Net Discount mismatch');
		System.assertEquals(840, deliveryOrderLine.dmpl__TaxAmount__c, 'Tax Amount mismatch');


		System.assertEquals(3000, deliveryOrder.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount mismatch');
		System.assertEquals(3840, deliveryOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount mismatch');
		System.assertEquals(3000, deliveryOrder.dmpl__TotalLineAmount__c, 'Total Line Amount mismatch');
		System.assertEquals(3840, deliveryOrder.dmpl__TotalAmount__c, 'Total Amount mismatch');
		System.assertEquals(840, deliveryOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount mismatch');
		System.assertEquals(0, deliveryOrder.dmpl__TotalDiscountAmount__c, 'Total Discount Amount mismatch');


		Test.stopTest();
	}
	
	@isTest
	static void createDeliveryOrderLineWithSaleOrderLineReferencePositive () {
		Test.startTest();

		Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
		Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
		dmpl__PriceList__c priceList1 =  TestDataHelpers.getPriceList('Price List 1');
		dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('IGST 18');
		dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder( customer1.Id, partner1.Id,branch1.Id, null, null, true, null);
		dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(saleOrder.Id, item1.Id, 10, null);
		dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner1.Id, customer1.Id, branch1.Id, null, saleOrder.Id,null);
		dmpl__DeliveryOrderLine__c deliveryOrderLine;
		
			deliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(deliveryOrder.Id, item1.Id, taxGroup.Id, 10, 1500, null, saleOrderLine.Id, null, null);
		
			
		

		deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
		deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);
		
		

		System.assertEquals(customer1.Id, deliveryOrder.dmpl__AccountId__c, 'Account Id must be Customer1 Id');
		System.assertEquals(customer1.Name, deliveryOrder.dmpl__AccountId__r.Name, 'Account Name mismatch');
		System.assertEquals(customer1.dmpl__BillingStreet__c, deliveryOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(customer1.dmpl__BillingCity__c, deliveryOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals(customer1.dmpl__BillingState__c, deliveryOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals(customer1.dmpl__BillingCountry__c, deliveryOrder.dmpl__BillingCountry__c, 'Billing state should match');
        System.assertEquals(customer1.dmpl__BillingPostalCode__c, deliveryOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
		
        System.assertEquals(customer1.dmpl__ShippingStreet__c, deliveryOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals(customer1.dmpl__ShippingCity__c, deliveryOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals(customer1.dmpl__ShippingState__c, deliveryOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals(customer1.dmpl__ShippingCountry__c, deliveryOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals(customer1.dmpl__ShippingPostalCode__c, deliveryOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
        
		
		
		System.assertEquals(partner1.Id, deliveryOrder.dmpl__PartnerAccountId__c, 'Partner Account ID mismatch');
		System.assertEquals(partner1.Name, deliveryOrder.dmpl__PartnerAccountId__r.Name, 'Partner Account ID mismatch');
		System.assertEquals(branch1.Id, deliveryOrder.dmpl__BranchId__c, 'Branch ID mismatch');
		System.assertEquals(branch1.Name, deliveryOrder.dmpl__BranchId__r.Name, 'Branch ID mismatch');

		System.assertEquals(15000, deliveryOrder.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount mismatch');
		System.assertEquals(17700, deliveryOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount mismatch');
		System.assertEquals(15000, deliveryOrder.dmpl__TotalLineAmount__c, 'Total Line Amount mismatch');
		System.assertEquals(17700, deliveryOrder.dmpl__TotalAmount__c, 'Total Amount mismatch');
		System.assertEquals(2700, deliveryOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount mismatch');


		System.assertEquals(deliveryOrder.Id, deliveryOrderLine.dmpl__DeliveryId__c, 'Delivery ID must match DN25060005');
		System.assertEquals(item1.Id, deliveryOrderLine.dmpl__ItemId__c, 'Item ID must be item 1');
		System.assertEquals(item1.Name, deliveryOrderLine.dmpl__ItemId__r.Name, 'Item Name mismatch');
		System.assertEquals(10, deliveryOrderLine.dmpl__Quantity__c, 'Quantity mismatch');
		System.assertEquals(1500, deliveryOrderLine.dmpl__UnitPrice__c, 'Unit Price mismatch');
		System.assertEquals(taxGroup.Id, deliveryOrderLine.dmpl__TaxGroupId__c, 'Tax Group ID must be IGST 18%');
		System.assertEquals(taxGroup.Name, deliveryOrderLine.dmpl__TaxGroupId__r.Name, 'Tax Group Name mismatch');
		System.assertEquals(15000, deliveryOrderLine.dmpl__Amount__c, 'Amount mismatch');
		System.assertEquals(15000, deliveryOrderLine.dmpl__BaseAmount__c, 'Base Amount mismatch');
		System.assertEquals(17700, deliveryOrderLine.dmpl__GrossAmount__c, 'Gross Amount mismatch');

		Test.stopTest();
	}
	
	@isTest
	static void createDeliveryOrderLineWithRepairOrderLineReferencePositive () {
		Test.startTest();

		Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
		Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Item__c item5 = TestDataHelpers.getItem('Item 5');
		Asset asset = TestDataHelpers.createAsset('Asset 1', customer1.Id, item5.Id);
		dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrder(partner1, customer1, branch1, asset, 100);
        dmpl__RepairOrderLine__c repairOrderLine = RepairOrderTestDataHelpers.createRepairOrderLine(repairOrder.Id, item5.Id, 10.00, 1000.00);
		dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner1.Id, customer1.Id, branch1.Id, null, null,null);
		dmpl__DeliveryOrderLine__c deliveryOrderLine;
		try{
			deliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(deliveryOrder.Id, item5.Id, null, 10, 1000, null, null, null, null);
		}catch(Exception e){
			System.Assert.isTrue(false, 'Need to be able to create a delivery order line');
		}

		deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
		deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);
		
		
		System.assertEquals(customer1.Id, deliveryOrder.dmpl__AccountId__c, 'Account Id must be Customer1 Id');
		System.assertEquals(customer1.Name, deliveryOrder.dmpl__AccountId__r.Name, 'Account Name mismatch');
		System.assertEquals(customer1.dmpl__BillingStreet__c, deliveryOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(customer1.dmpl__BillingCity__c, deliveryOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals(customer1.dmpl__BillingState__c, deliveryOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals(customer1.dmpl__BillingCountry__c, deliveryOrder.dmpl__BillingCountry__c, 'Billing state should match');
        System.assertEquals(customer1.dmpl__BillingPostalCode__c, deliveryOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
		
        System.assertEquals(customer1.dmpl__ShippingStreet__c, deliveryOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals(customer1.dmpl__ShippingCity__c, deliveryOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals(customer1.dmpl__ShippingState__c, deliveryOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals(customer1.dmpl__ShippingCountry__c, deliveryOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals(customer1.dmpl__ShippingPostalCode__c, deliveryOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
        
		
		
		System.assertEquals(partner1.Id, deliveryOrder.dmpl__PartnerAccountId__c, 'Partner Account ID mismatch');
		System.assertEquals(partner1.Name, deliveryOrder.dmpl__PartnerAccountId__r.Name, 'Partner Account ID mismatch');
		System.assertEquals(branch1.Id, deliveryOrder.dmpl__BranchId__c, 'Branch ID mismatch');
		System.assertEquals(branch1.Name , deliveryOrder.dmpl__BranchId__r.Name, 'Branch ID mismatch');

		System.assertEquals(deliveryOrder.Id, deliveryOrderLine.dmpl__DeliveryId__c, 'Delivery ID must match DN25060027');
		System.assertEquals(item5.Id, deliveryOrderLine.dmpl__ItemId__c, 'Item ID must be Item 5');
		System.assertEquals(item5.Name, deliveryOrderLine.dmpl__ItemId__r.Name, 'Item Name mismatch');
		System.assertEquals(10, deliveryOrderLine.dmpl__Quantity__c, 'Quantity mismatch');
		System.assertEquals(1000, deliveryOrderLine.dmpl__UnitPrice__c, 'Unit Price mismatch');
		System.assertEquals(10000, deliveryOrderLine.dmpl__BaseAmount__c, 'Base Amount mismatch');
		System.assertEquals(10000, deliveryOrderLine.dmpl__GrossAmount__c, 'Gross Amount mismatch');
		System.assertEquals(null, deliveryOrderLine.dmpl__TaxAmount__c, 'Tax Amount must be zero');
		System.assertEquals(10000, deliveryOrderLine.dmpl__Amount__c, 'Amount mismatch');

		Test.stopTest();
	}
	
	@isTest
	static void createDeliveryOrderLineWithInactiveItemNegative () {
		Test.startTest();

		Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
		Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Item__c item2 = TestDataHelpers.getItem('Item 2');
		dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder( partner1.Id, customer1.Id, branch1.Id, null, null,null);
		dmpl__DeliveryOrderLine__c deliveryOrderLine;
		try{
			deliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(deliveryOrder.Id, item2.Id, null, 5, 1500, null, null, null, null);
			System.Assert.isTrue(false, 'Need Not to be able to create a delivery order line');
		}catch(Exception e){
			System.Assert.isTrue(true, 'Need Not to be able to create a delivery order line');
		}

		Test.stopTest();
	}
	
	@isTest
	static void createDeliveryOrderLineWithDiscountinuedItemPositive () {
		Test.startTest();

		Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
		Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Item__c item4 = TestDataHelpers.getItem('Item 4');
		dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('IGST 18'); 
		dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner1.Id, customer1.Id, branch1.Id, null, null,null);
		dmpl__DeliveryOrderLine__c deliveryOrderLine;
		try{
			deliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(deliveryOrder.Id, item4.Id, taxGroup.Id, 10, 1500, null, null, null, null);
		}catch(Exception e){
			System.Assert.isTrue(false, 'Need to be able to create a delivery order line');
		}

		deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
		deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);
		
		
		System.assertEquals(customer1.Id, deliveryOrder.dmpl__AccountId__c, 'Account Id must be Customer1 Id');
		System.assertEquals(customer1.Name, deliveryOrder.dmpl__AccountId__r.Name, 'Account Name mismatch');
		System.assertEquals(customer1.dmpl__BillingStreet__c, deliveryOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(customer1.dmpl__BillingCity__c, deliveryOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals(customer1.dmpl__BillingState__c, deliveryOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals(customer1.dmpl__BillingCountry__c, deliveryOrder.dmpl__BillingCountry__c, 'Billing state should match');
        System.assertEquals(customer1.dmpl__BillingPostalCode__c, deliveryOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
		
        System.assertEquals(customer1.dmpl__ShippingStreet__c, deliveryOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals(customer1.dmpl__ShippingCity__c, deliveryOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals(customer1.dmpl__ShippingState__c, deliveryOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals(customer1.dmpl__ShippingCountry__c, deliveryOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals(customer1.dmpl__ShippingPostalCode__c, deliveryOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
        
		
		
		System.assertEquals(partner1.Id, deliveryOrder.dmpl__PartnerAccountId__c, 'Partner Account ID mismatch');
		System.assertEquals(partner1.Name, deliveryOrder.dmpl__PartnerAccountId__r.Name, 'Partner Account ID mismatch');
		System.assertEquals(branch1.Id, deliveryOrder.dmpl__BranchId__c, 'Branch ID mismatch');
		System.assertEquals(branch1.Name, deliveryOrder.dmpl__BranchId__r.Name, 'Branch ID mismatch');

		System.assertEquals(15000, deliveryOrder.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount mismatch');
		System.assertEquals(17700, deliveryOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount mismatch');
		System.assertEquals(15000, deliveryOrder.dmpl__TotalLineAmount__c, 'Total Line Amount mismatch');
		System.assertEquals(17700, deliveryOrder.dmpl__TotalAmount__c, 'Total Amount mismatch');
		System.assertEquals(2700, deliveryOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount mismatch');

		System.assertEquals(deliveryOrder.Id, deliveryOrderLine.dmpl__DeliveryId__c, 'Delivery ID must match DN25060005');
		System.assertEquals(item4.Id, deliveryOrderLine.dmpl__ItemId__c, 'Item ID must be item 4');
		System.assertEquals(item4.Name, deliveryOrderLine.dmpl__ItemId__r.Name, 'Item Name mismatch');
		System.assertEquals(10, deliveryOrderLine.dmpl__Quantity__c, 'Quantity mismatch');
		System.assertEquals(taxGroup.Id, deliveryOrderLine.dmpl__TaxGroupId__c, 'Tax Group ID must be IGST 18%');
		System.assertEquals(taxGroup.Name, deliveryOrderLine.dmpl__TaxGroupId__r.Name, 'Tax Group Name mismatch');
		System.assertEquals(1500, deliveryOrderLine.dmpl__UnitPrice__c, 'Unit Price mismatch');
		System.assertEquals(15000, deliveryOrderLine.dmpl__Amount__c, 'Amount mismatch');
		System.assertEquals(15000, deliveryOrderLine.dmpl__BaseAmount__c, 'Base Amount mismatch');
		System.assertEquals(17700, deliveryOrderLine.dmpl__GrossAmount__c, 'Gross Amount mismatch');


		Test.stopTest();
	}
	
	@isTest
	static void createDeliveryOrderLineWithNoStorageLocationPositive () {
		Test.startTest();

		Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
		Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
		dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('IGST 18'); 
		dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner1.Id, customer1.Id, branch1.Id, null, null,null);
		dmpl__DeliveryOrderLine__c deliveryOrderLine;
		try{
			deliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(deliveryOrder.Id, item1.Id, taxGroup.Id, 20, 1500, null, null, null, null);
		}catch(Exception e){
			System.Assert.isTrue(false, 'Need to be able to create a delivery order line');
		}

		deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
		deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);
		
		
		System.assertEquals(customer1.Id, deliveryOrder.dmpl__AccountId__c, 'Account Id must be Customer1 Id');
		System.assertEquals(customer1.Name, deliveryOrder.dmpl__AccountId__r.Name, 'Account Name mismatch');
		System.assertEquals(customer1.dmpl__BillingStreet__c, deliveryOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(customer1.dmpl__BillingCity__c, deliveryOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals(customer1.dmpl__BillingState__c, deliveryOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals(customer1.dmpl__BillingCountry__c, deliveryOrder.dmpl__BillingCountry__c, 'Billing state should match');
        System.assertEquals(customer1.dmpl__BillingPostalCode__c, deliveryOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
		
        System.assertEquals(customer1.dmpl__ShippingStreet__c, deliveryOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals(customer1.dmpl__ShippingCity__c, deliveryOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals(customer1.dmpl__ShippingState__c, deliveryOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals(customer1.dmpl__ShippingCountry__c, deliveryOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals(customer1.dmpl__ShippingPostalCode__c, deliveryOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
        
		
		
		System.assertEquals(partner1.Id, deliveryOrder.dmpl__PartnerAccountId__c, 'Partner Account ID mismatch');
		System.assertEquals(partner1.Name, deliveryOrder.dmpl__PartnerAccountId__r.Name, 'Partner Account ID mismatch');
		System.assertEquals(branch1.Id, deliveryOrder.dmpl__BranchId__c, 'Branch ID mismatch');
		System.assertEquals(branch1.Name, deliveryOrder.dmpl__BranchId__r.Name, 'Branch ID mismatch');

		
		System.assertEquals(30000, deliveryOrder.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount mismatch');
		System.assertEquals(35400, deliveryOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount mismatch');
		System.assertEquals(30000, deliveryOrder.dmpl__TotalLineAmount__c, 'Total Line Amount mismatch');
		System.assertEquals(35400, deliveryOrder.dmpl__TotalAmount__c, 'Total Amount mismatch');
		System.assertEquals(5400, deliveryOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount mismatch');
		

		System.assertEquals(item1.Id, deliveryOrderLine.dmpl__ItemId__c, 'Item ID must be item 1');
		System.assertEquals(item1.Name, deliveryOrderLine.dmpl__ItemId__r.Name, 'Item Name mismatch');
		System.assertEquals(20, deliveryOrderLine.dmpl__Quantity__c, 'Quantity mismatch');
		System.assertEquals(1500, deliveryOrderLine.dmpl__UnitPrice__c, 'Unit Price mismatch');
		System.assertEquals(taxGroup.Id, deliveryOrderLine.dmpl__TaxGroupId__c, 'Tax Group ID must be IGST 18%');
		System.assertEquals(taxGroup.Name, deliveryOrderLine.dmpl__TaxGroupId__r.Name, 'Tax Group Name mismatch');
		System.assertEquals(30000, deliveryOrderLine.dmpl__BaseAmount__c, 'Base Amount mismatch');
		System.assertEquals(5400, deliveryOrderLine.dmpl__TaxAmount__c, 'Tax Amount mismatch');
		System.assertEquals(35400, deliveryOrderLine.dmpl__GrossAmount__c, 'Gross Amount mismatch');
		

		Test.stopTest();
	}

     @isTest
    static void createDeliveryOrderLineWithNoItemLot() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');

        Test.startTest();
        
        dmpl__DeliveryOrder__c createddeliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(
            partnerAccount.Id,
            customerAccount.Id, 
            branch.Id,
            null,
            null,
            null
        );
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(createddeliveryOrder.Id);
        System.assertEquals('Customer 1', deliveryOrder.dmpl__AccountName__c, 'Account name should match');
        String expectedbillingAddress = 'MG Road\nPune, Maharashtra, India, 411001';
        System.assertEquals(expectedbillingAddress, deliveryOrder.dmpl__BillingAddress__c, 'Billing address should match');
        System.assertEquals('Pune', deliveryOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals('411001', deliveryOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals('Maharashtra', deliveryOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals('MG Road', deliveryOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(Date.today(), deliveryOrder.dmpl__DocumentDate__c, 'Document date should match');
         String expectedShippingAddress = 'Ring Rd\nNagpur, Maharashtra, India, 440001';
       System.assertEquals(expectedShippingAddress, deliveryOrder.dmpl__ShippingAddress__c, 'Shipping address should match');
        System.assertEquals('Nagpur', deliveryOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals('India', deliveryOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals('440001', deliveryOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
        System.assertEquals('Maharashtra', deliveryOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals('Ring Rd', deliveryOrder.dmpl__ShippingStreet__c, 'Shipping street should match');

        dmpl__DeliveryOrderLine__c createdeliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(
            deliveryOrder.Id,
            item.Id,
            null,
            2,
            1500,
            null,
            null,
            null,
            null
        );
        dmpl__DeliveryOrderLine__c deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine(createdeliveryOrderLine.Id);
        System.assertEquals(item.Id, deliveryOrderLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(2, deliveryOrderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, deliveryOrderLine.dmpl__UnitPrice__c, 'Unit price should match');
        System.assertEquals(3000, deliveryOrderLine.dmpl__GrossAmount__c, 'Gross amount should match');
        System.assertEquals(3000, deliveryOrderLine.dmpl__Amount__c, 'Amount should match');
        System.assertEquals(2, deliveryOrderLine.dmpl__PendingInvoiceQuantity__c, 'Pending invoice quantity should match');
        System.assertEquals(2, deliveryOrderLine.dmpl__PendingShippedQuantity__c, 'Pending shipped quantity should match');
        System.assertEquals(null, deliveryOrderLine.dmpl__ItemLotTypeId__c, 'Item lot type should be null');

        Test.stopTest();
    }


     @isTest
    static void createDeliveryOrderLineWithBlankQuantity() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 7');

        Test.startTest();
        
        dmpl__DeliveryOrder__c createdeliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(
            partnerAccount.Id,
            customerAccount.Id,
            branch.Id,
            null,
            null,
            null
        );
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(createdeliveryOrder.Id);
        System.assertEquals('Customer 1', deliveryOrder.dmpl__AccountName__c, 'Account name should match');
           String expectedbillingAddress = 'MG Road\nPune, Maharashtra, India, 411001';
        System.assertEquals(expectedbillingAddress, deliveryOrder.dmpl__BillingAddress__c, 'Billing address should match');
        System.assertEquals('Pune', deliveryOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals('411001', deliveryOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals('Maharashtra', deliveryOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals('MG Road', deliveryOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(Date.today(), deliveryOrder.dmpl__DocumentDate__c, 'Document date should match');
        String expectedShippingAddress = 'Ring Rd\nNagpur, Maharashtra, India, 440001';
        System.assertEquals(expectedShippingAddress, deliveryOrder.dmpl__ShippingAddress__c, 'Shipping address should match');
        System.assertEquals('Nagpur', deliveryOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals('India', deliveryOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals('440001', deliveryOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
        System.assertEquals('Maharashtra', deliveryOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals('Ring Rd', deliveryOrder.dmpl__ShippingStreet__c, 'Shipping street should match');

        try {
            dmpl__DeliveryOrderLine__c deliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(
                deliveryOrder.Id,
                item.Id,
                null,
                null, 
                null,
                null,
                null,
                null,
                null
            );
           
       } catch (Exception e) {
			System.debug('Exception message: ' + e.getMessage());
			System.assert(true, 'Exception should be related to blank quantity');
		}


        Test.stopTest();
    }


       @isTest
    static void createDeliveryOrderLineWithoutSaleOrderLine() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 10');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 4');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('IGST 18');
        dmpl__SKU__c sku4 = TestDataHelpers.getSKU('SKU 4');

        Test.startTest();
        
        dmpl__DeliveryOrder__c createdeliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(
            partnerAccount.Id,
            customerAccount.Id,
            branch.Id,
            null,
            null,
            null
        );

       dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(createdeliveryOrder.Id);
        System.assertEquals('Customer 1', deliveryOrder.dmpl__AccountName__c, 'Account name should match');
        String expectedbillingAddress = 'MG Road\nPune, Maharashtra, India, 411001';
        System.assertEquals(expectedbillingAddress, deliveryOrder.dmpl__BillingAddress__c, 'Billing address should match');
        System.assertEquals('Pune', deliveryOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals('411001', deliveryOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals('Maharashtra', deliveryOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals('MG Road', deliveryOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(Date.today(), deliveryOrder.dmpl__DocumentDate__c, 'Document date should match');
        String expectedShippingAddress = 'Ring Rd\nNagpur, Maharashtra, India, 440001';
        System.assertEquals(expectedShippingAddress, deliveryOrder.dmpl__ShippingAddress__c, 'Shipping address should match');
        System.assertEquals('Nagpur', deliveryOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals('India', deliveryOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals('440001', deliveryOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
        System.assertEquals('Maharashtra', deliveryOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals('Ring Rd', deliveryOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
        

        dmpl__DeliveryOrderLine__c deliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(
            deliveryOrder.Id,
            item.Id,
            taxGroup.Id,
            5,
            1200,
            null,
            null,
            null,
            sku4.Id
        );
       
        System.assertEquals(deliveryOrder.Id, deliveryOrderLine.dmpl__DeliveryId__c, 'Delivery order ID should match');
        System.assertEquals(item.Id, deliveryOrderLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(5, deliveryOrderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(taxGroup.Id, deliveryOrderLine.dmpl__TaxGroupId__c, 'Tax group should match');
        System.assertEquals(1200, deliveryOrderLine.dmpl__UnitPrice__c, 'Unit price should match');

        Test.stopTest();
    }


    @isTest
    static void createDeliveryOrderLineWithInactiveItemEdit() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Item__c item2 = TestDataHelpers.getItem('Item 2');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
      Test.startTest();
    
        dmpl__DeliveryOrder__c createdeliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(
            partnerAccount.Id,
            customerAccount.Id,
            branch.Id,
            null,
            null,
            null
        );

        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(createdeliveryOrder.Id);
        System.assertEquals('Customer 1', deliveryOrder.dmpl__AccountName__c, 'Account name should match');
        String expectedbillingAddress = 'MG Road\nPune, Maharashtra, India, 411001';
        System.assertEquals(expectedbillingAddress, deliveryOrder.dmpl__BillingAddress__c, 'Billing address should match');
        System.assertEquals('Pune', deliveryOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals('411001', deliveryOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals('Maharashtra', deliveryOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals('MG Road', deliveryOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(Date.today(), deliveryOrder.dmpl__DocumentDate__c, 'Document date should match');
        String expectedShippingAddress = 'Ring Rd\nNagpur, Maharashtra, India, 440001';
        System.assertEquals(expectedShippingAddress, deliveryOrder.dmpl__ShippingAddress__c, 'Shipping address should match');
        System.assertEquals('Nagpur', deliveryOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals('India', deliveryOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals('440001', deliveryOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
        System.assertEquals('Maharashtra', deliveryOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals('Ring Rd', deliveryOrder.dmpl__ShippingStreet__c, 'Shipping street should match');

       
        dmpl__DeliveryOrderLine__c createddeliveryOrderLine1 = DeliveryOrderDataHelper.createDeliveryOrderLine(
            deliveryOrder.Id,
            item1.Id,
             taxGroup.Id,
             5,
            1500,
            null,
            null,
            null,
            null
        );
        dmpl__DeliveryOrderLine__c deliveryOrderLine1 = DeliveryOrderDataHelper.getDeliveryOrderLine(createddeliveryOrderLine1.Id);
        System.assertEquals(deliveryOrder.Id, deliveryOrderLine1.dmpl__DeliveryId__c, 'Delivery order ID should match');
        System.assertEquals(item1.Id, deliveryOrderLine1.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(5, deliveryOrderLine1.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(taxGroup.Id, deliveryOrderLine1.dmpl__TaxGroupId__c, 'Tax group should match');
        System.assertEquals(1500, deliveryOrderLine1.dmpl__UnitPrice__c, 'Unit price should match');
        System.assertEquals(7500, deliveryOrderLine1.dmpl__Amount__c, 'Amount should match');
        System.assertEquals(7500, deliveryOrderLine1.dmpl__BaseAmount__c, 'Base amount should match');
        System.assertEquals(9600, deliveryOrderLine1.dmpl__GrossAmount__c, 'Gross amount should match');
        System.assertEquals(0, deliveryOrderLine1.dmpl__NetDiscount__c, 'Net discount should match');
        System.assertEquals(2100, deliveryOrderLine1.dmpl__TaxAmount__c, 'Tax amount should match');

        
        try {
           
            dmpl__DeliveryOrderLine__c deliveryOrderLine2 = DeliveryOrderDataHelper.createDeliveryOrderLine(
                deliveryOrder.Id,
                item2.Id,
                taxGroup.Id,
                 5,
                1500,
                null,
                null,
                null,
                null
            );
              
          
        } catch (Exception e) {
            System.assert( e.getMessage().contains('FIELD_FILTER_VALIDATION_EXCEPTION'),'Expected FIELD_FILTER_VALIDATION_EXCEPTION due to inactive item');
          }
        Test.stopTest();
    } 


 @isTest
    static void createDeliveryOrderwithitemdiscontinuedEdit() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
       Test.startTest();
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(
            partnerAccount.Id,
            customerAccount.Id,
            branch.Id,
            null,
            null,
            null
        );

    
        dmpl__DeliveryOrderLine__c createddeliveryOrderLine1 = DeliveryOrderDataHelper.createDeliveryOrderLine(
            deliveryOrder.Id,
            item1.Id,
             taxGroup.Id,
             1,
            1500,
            null,
            null,
            null,
            null
        );
        dmpl__DeliveryOrderLine__c deliveryOrderLine1 = DeliveryOrderDataHelper.getDeliveryOrderLine(createddeliveryOrderLine1.Id);
        System.assertEquals(1, deliveryOrderLine1.dmpl__Quantity__c, 'Quantity should be 1');
        System.assertEquals(1500, deliveryOrderLine1.dmpl__UnitPrice__c, 'Unit price should be 1500');
        System.assertEquals(1500, deliveryOrderLine1.dmpl__Amount__c, 'Amount should be 1500');
        System.assertEquals(1500, deliveryOrderLine1.dmpl__BaseAmount__c, 'Base amount should be 1500');
        System.assertEquals(1920, deliveryOrderLine1.dmpl__GrossAmount__c, 'Gross amount should be 1920');
        System.assertEquals(0, deliveryOrderLine1.dmpl__NetDiscount__c, 'Net discount should be 0');
        System.assertEquals(420, deliveryOrderLine1.dmpl__TaxAmount__c, 'Tax amount should be 420');

        
        dmpl__DeliveryOrderLine__c createddeliveryOrderLine2 = DeliveryOrderDataHelper.createDeliveryOrderLine(
            deliveryOrder.Id,
            item1.Id,
            taxGroup.Id,
               3,
            1500,
            null,
            null,
            null,
            null
        );
        dmpl__DeliveryOrderLine__c deliveryOrderLine2 = DeliveryOrderDataHelper.getDeliveryOrderLine(createddeliveryOrderLine2.Id);
        System.assertEquals(3, deliveryOrderLine2.dmpl__Quantity__c, 'Quantity should be 3');
        System.assertEquals(1500, deliveryOrderLine2.dmpl__UnitPrice__c, 'Unit price should be 1500');
        System.assertEquals(4500, deliveryOrderLine2.dmpl__Amount__c, 'Amount should be 4500');
        System.assertEquals(4500, deliveryOrderLine2.dmpl__BaseAmount__c, 'Base amount should be 4500');
        System.assertEquals(5760, deliveryOrderLine2.dmpl__GrossAmount__c, 'Gross amount should be 5760');
        System.assertEquals(0, deliveryOrderLine2.dmpl__NetDiscount__c, 'Net discount should be 0');
        System.assertEquals(1260, deliveryOrderLine2.dmpl__TaxAmount__c, 'Tax amount should be 1260');

        deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        System.assertEquals(6000, deliveryOrder.dmpl__TotalLineBaseAmount__c, 'Total line base amount should be 6000');
        System.assertEquals(7680, deliveryOrder.dmpl__TotalLineGrossAmount__c, 'Total line gross amount should be 7680');
        System.assertEquals(6000, deliveryOrder.dmpl__TotalLineAmount__c, 'Total line amount should be 4500');
        System.assertEquals(7680, deliveryOrder.dmpl__TotalAmount__c, 'Total amount should be 5760');
         Test.stopTest();
    }
   

@isTest
    static void createDeliveryOrderLineWithoutSKUEdit() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');

        Test.startTest();
        
       
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(
            partnerAccount.Id,
            customerAccount.Id,
            branch.Id,
            null,
            null,
            null
        );

		
        dmpl__DeliveryOrderLine__c deliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(
            deliveryOrder.Id,
            item.Id,
            null,
            5,
            1000,
            null,
            null,
            null,
            null
        );
        deliveryOrderLine=DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id); 
        System.assertEquals(5, deliveryOrderLine.dmpl__Quantity__c, 'Initial quantity should be 5');
        System.assertEquals(1000, deliveryOrderLine.dmpl__UnitPrice__c, 'Unit price should be 1000');
        System.assertEquals(item.Id, deliveryOrderLine.dmpl__ItemId__c, 'Item should match');

       
        deliveryOrderLine.dmpl__Quantity__c = 6;
        update deliveryOrderLine;

       
        dmpl__DeliveryOrderLine__c updatedLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);

        System.assertEquals(6, updatedLine.dmpl__Quantity__c, 'Updated quantity should be 6');
        System.assertEquals(1000, updatedLine.dmpl__UnitPrice__c, 'Unit price should remain 1000');
        System.assertEquals(item.Id, updatedLine.dmpl__ItemId__c, 'Item should remain unchanged');

        Test.stopTest();
    }


  @isTest
    static void createDeliveryOrderLineWithStorageLocationEdit() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation('Storage Location 1');

        Test.startTest();
        
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(
            partnerAccount.Id,
            customerAccount.Id,
            branch.Id,
            null,
            null,
            null
        );
         deliveryOrder=DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        System.assertEquals('Customer 1', deliveryOrder.dmpl__AccountName__c, 'Account name should match');
        String expectedbillingAddress = 'MG Road\nPune, Maharashtra, India, 411001';
        System.assertEquals(expectedbillingAddress, deliveryOrder.dmpl__BillingAddress__c, 'Billing address should match');
        System.assertEquals('Pune', deliveryOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals('411001', deliveryOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals('Maharashtra', deliveryOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals('MG Road', deliveryOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(Date.today(), deliveryOrder.dmpl__DocumentDate__c, 'Document date should match');
        String expectedShippingAddress = 'Ring Rd\nNagpur, Maharashtra, India, 440001';
        System.assertEquals(expectedShippingAddress, deliveryOrder.dmpl__ShippingAddress__c, 'Shipping address should match');
        System.assertEquals('Nagpur', deliveryOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals('India', deliveryOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals('440001', deliveryOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
        System.assertEquals('Maharashtra', deliveryOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals('Ring Rd', deliveryOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
        
       

        dmpl__DeliveryOrderLine__c deliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(
            deliveryOrder.Id,
            item.Id,
            null,
            20,
            1500,
            storageLocation.Id,
            null,
            null,
            null
        );

        deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);
        System.assertEquals(deliveryOrder.Id, deliveryOrderLine.dmpl__DeliveryId__c, 'Delivery order ID should match');
        System.assertEquals(item.Id, deliveryOrderLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(20, deliveryOrderLine.dmpl__Quantity__c, 'Initial quantity should be 20');
        System.assertEquals(1500, deliveryOrderLine.dmpl__UnitPrice__c, 'Unit price should match');
        System.assertEquals(storageLocation.Id, deliveryOrderLine.dmpl__StorageLocationId__c, 'Storage location should match');

      
        deliveryOrderLine.dmpl__Quantity__c = 25;
        update deliveryOrderLine;

      
        dmpl__DeliveryOrderLine__c updatedLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);
        System.assertEquals(25, updatedLine.dmpl__Quantity__c, 'Updated quantity should be 25');
        System.assertEquals(1500, updatedLine.dmpl__UnitPrice__c, 'Unit price should remain unchanged');
        System.assertEquals(storageLocation.Id, updatedLine.dmpl__StorageLocationId__c, 'Storage location should remain unchanged');

        Test.stopTest();
    }   

 @isTest
    static void createDeliveryOrderLineWithQuantityEdit() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');

        Test.startTest();
        
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(
            partnerAccount.Id,
            customerAccount.Id,
            branch.Id,
            null,
            null,
            null
        );
        
        deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        System.assertEquals('Customer 1', deliveryOrder.dmpl__AccountName__c, 'Account name should match');
        String expectedbillingAddress = 'MG Road\nPune, Maharashtra, India, 411001';
        System.assertEquals(expectedbillingAddress, deliveryOrder.dmpl__BillingAddress__c, 'Billing address should match');
        System.assertEquals('Pune', deliveryOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals('411001', deliveryOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals('Maharashtra', deliveryOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals('MG Road', deliveryOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(Date.today(), deliveryOrder.dmpl__DocumentDate__c, 'Document date should match');
        String expectedShippingAddress = 'Ring Rd\nNagpur, Maharashtra, India, 440001';
        System.assertEquals(expectedShippingAddress, deliveryOrder.dmpl__ShippingAddress__c, 'Shipping address should match');
        System.assertEquals('Nagpur', deliveryOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals('India', deliveryOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals('440001', deliveryOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
        System.assertEquals('Maharashtra', deliveryOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals('Ring Rd', deliveryOrder.dmpl__ShippingStreet__c, 'Shipping street should match');

        dmpl__DeliveryOrderLine__c deliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(
            deliveryOrder.Id,
            item.Id,
            taxGroup.Id,
            5,
            1500,
            null,
            null,
            null,
            null
            
        );
      
        
        deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);
        System.assertEquals(deliveryOrder.Id, deliveryOrderLine.dmpl__DeliveryId__c, 'Delivery order ID should match');
        System.assertEquals(item.Id, deliveryOrderLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(5, deliveryOrderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(taxGroup.Id, deliveryOrderLine.dmpl__TaxGroupId__c, 'Tax group should match');
        System.assertEquals(1500, deliveryOrderLine.dmpl__UnitPrice__c, 'Unit price should match');
        System.assertEquals(7500, deliveryOrderLine.dmpl__Amount__c, 'Amount should match');
        System.assertEquals(7500, deliveryOrderLine.dmpl__BaseAmount__c, 'Base amount should match');
        System.assertEquals(9600, deliveryOrderLine.dmpl__GrossAmount__c, 'Gross amount should match');
        System.assertEquals(0, deliveryOrderLine.dmpl__NetDiscount__c, 'Net discount should match');
        System.assertEquals(2100, deliveryOrderLine.dmpl__TaxAmount__c, 'Tax amount should match');
         
        deliveryOrder= DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        System.assertEquals(7500, deliveryOrder.dmpl__TotalLineBaseAmount__c, 'Total line base amount should match');
        System.assertEquals(9600, deliveryOrder.dmpl__TotalLineGrossAmount__c, 'Total line gross amount should match');
        System.assertEquals(7500, deliveryOrder.dmpl__TotalLineAmount__c, 'Total line amount should match');
        System.assertEquals(9600, deliveryOrder.dmpl__TotalAmount__c, 'Total amount should match');
        System.assertEquals(2100, deliveryOrder.dmpl__TotalTaxAmount__c, 'Total tax amount should match');
        System.assertEquals(0, deliveryOrder.dmpl__TotalDiscountAmount__c, 'Total discount amount should match');

        Test.stopTest();
    }
 @isTest
    static void createDeliveryOrderLineWithoutRepairOrderLine() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 5');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('IGST 18');

        Test.startTest();
        
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(
            partnerAccount.Id,
            customerAccount.Id, 
            branch.Id,
            null,
            null,
            null
        );

        deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        System.assertEquals('Customer 1', deliveryOrder.dmpl__AccountName__c, 'Account name should match');
        String expectedbillingAddress = 'MG Road\nPune, Maharashtra, India, 411001';
        System.assertEquals(expectedbillingAddress, deliveryOrder.dmpl__BillingAddress__c, 'Billing address should match');
        System.assertEquals('Pune', deliveryOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals('411001', deliveryOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals('Maharashtra', deliveryOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals('MG Road', deliveryOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(Date.today(), deliveryOrder.dmpl__DocumentDate__c, 'Document date should match');
        String expectedShippingAddress = 'Ring Rd\nNagpur, Maharashtra, India, 440001';
        System.assertEquals(expectedShippingAddress, deliveryOrder.dmpl__ShippingAddress__c, 'Shipping address should match');
        System.assertEquals('Nagpur', deliveryOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals('India', deliveryOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals('440001', deliveryOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
        System.assertEquals('Maharashtra', deliveryOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals('Ring Rd', deliveryOrder.dmpl__ShippingStreet__c, 'Shipping street should match');

        dmpl__DeliveryOrderLine__c deliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(
            deliveryOrder.Id,
            item.Id,
            taxGroup.Id,
            10,
            1000,
            null,
            null,
            null,
            null
        );
         deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);
        System.assertEquals(deliveryOrder.Id, deliveryOrderLine.dmpl__DeliveryId__c, 'Delivery order ID should match');
        System.assertEquals(item.Id, deliveryOrderLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(10, deliveryOrderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(taxGroup.Id, deliveryOrderLine.dmpl__TaxGroupId__c, 'Tax group should match');
        System.assertEquals(1000, deliveryOrderLine.dmpl__UnitPrice__c, 'Unit price should match');
        System.assertEquals(10000, deliveryOrderLine.dmpl__Amount__c, 'Amount should match');
        System.assertEquals(10000, deliveryOrderLine.dmpl__BaseAmount__c, 'Base amount should match');
        System.assertEquals(11800, deliveryOrderLine.dmpl__GrossAmount__c, 'Gross amount should match');
        System.assertEquals(0, deliveryOrderLine.dmpl__NetDiscount__c, 'Net discount should match');
        System.assertEquals(1800, deliveryOrderLine.dmpl__TaxAmount__c, 'Tax amount should match');

        deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        System.assertEquals(10000, deliveryOrder.dmpl__TotalLineBaseAmount__c, 'Total line base amount should match');
        System.assertEquals(11800, deliveryOrder.dmpl__TotalLineGrossAmount__c, 'Total line gross amount should match');
        System.assertEquals(10000, deliveryOrder.dmpl__TotalLineAmount__c, 'Total line amount should match');
        System.assertEquals(11800, deliveryOrder.dmpl__TotalAmount__c, 'Total amount should match');
        System.assertEquals(1800, deliveryOrder.dmpl__TotalTaxAmount__c, 'Total tax amount should match');

        Test.stopTest();
    }
    
    
    @isTest
    public static void deliveryOrderLineWithRepairOrderLineReferencePositiveEdit() {
        
        
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Asset asset1 = TestDataHelpers.createAsset('Asset 1', customerAccount1.Id, item1.Id);
        

        Test.startTest();

        dmpl__RepairOrder__c repairOrder1 = RepairOrderTestDataHelpers.createRepairOrder(
            partnerAccount1,
            customerAccount1,
            branch1,
            asset1,
            1000
        );
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.getRepairOrdersById(repairOrder1.Id)[0];
        

        System.assertEquals(customerAccount1.Id, repairOrder.dmpl__AccountId__c, 'Customer Account ID should match');
        System.assertEquals(1000, repairOrder.dmpl__UsageReading__c, 'Usage Reading should match');
        System.assertEquals(Date.today(), repairOrder.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Price List 1', repairOrder.dmpl__PriceListId__r.Name, 'Price List mismatch');
        System.assertEquals(customerAccount1.dmpl__BillingStreet__c, repairOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(customerAccount1.dmpl__BillingCity__c, repairOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals(customerAccount1.dmpl__BillingCountry__c, repairOrder.dmpl__BillingCountry__c, 'Billing country should match');
        System.assertEquals(customerAccount1.dmpl__BillingPostalCode__c, repairOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');

        
        dmpl__RepairOrderLine__c repairOrderLine1 = RepairOrderTestDataHelpers.createRepairOrderLine(
            repairOrder,
            item1,
            15,
            999
        );

        dmpl__RepairOrderLine__c repairOrderLine = RepairOrderTestDataHelpers.getRepairOrderLine(repairOrderLine1.Id);

        System.assertEquals(999, repairOrderLine.dmpl__UnitPrice__c, 'Unit Price mismatch');
        
        
        
        

        
        
        
        

        
        System.assertEquals(0, repairOrderLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount mismatch');
        System.assertEquals(0, repairOrderLine.dmpl__NetDiscount__c, 'Net Discount mismatch');
        
        

        
        dmpl__DeliveryOrder__c deliveryOrder1 = DeliveryOrderDataHelper.createDeliveryOrder(partnerAccount1.Id, customerAccount1.Id, branch1.Id, repairOrder.Id, null,null);
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder1.Id);

        System.assertEquals(Date.today(), deliveryOrder.dmpl__DocumentDate__c, 'Document Date should match');
        
        System.assertEquals(customerAccount1.Id, deliveryOrder.dmpl__AccountId__c, 'Account Id must be Customer1 Id');
        System.assertEquals(customerAccount1.Name, deliveryOrder.dmpl__AccountId__r.Name, 'Account Name mismatch');
        System.assertEquals(customerAccount1.dmpl__BillingStreet__c, deliveryOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(customerAccount1.dmpl__BillingCity__c, deliveryOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals(customerAccount1.dmpl__BillingState__c, deliveryOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals(customerAccount1.dmpl__BillingCountry__c, deliveryOrder.dmpl__BillingCountry__c, 'Billing country should match');
        System.assertEquals(customerAccount1.dmpl__BillingPostalCode__c, deliveryOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(repairOrder.Id, deliveryOrder.dmpl__RepairOrderId__c, 'Repair Order ID mismatch');

        
        dmpl__TaxGroup__c taxGroup18 = TestDataHelpers.getTaxGroup('IGST 18');
        dmpl__DeliveryOrderLine__c deliveryOrderLine1 = DeliveryOrderDataHelper.createDeliveryOrderLine(deliveryOrder.Id,Item1.Id,taxGroup18.Id,15,1500,null,null,repairOrderLine.Id,null);
        dmpl__DeliveryOrderLine__c deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine1.Id);

        System.assertEquals(1500, deliveryOrderLine.dmpl__UnitPrice__c, 'Unit Price mismatch');
        System.assertEquals(Item1.Id, deliveryOrderLine.dmpl__ItemId__c, 'Item ID mismatch');
        System.assertEquals(15, deliveryOrderLine.dmpl__Quantity__c, 'Quantity mismatch');
        System.assertEquals(taxGroup18.Id, deliveryOrderLine.dmpl__TaxGroupId__c, 'Tax Group ID mismatch');

        System.assertEquals(22500, deliveryOrderLine.dmpl__BaseAmount__c, 'Base Amount mismatch');
        System.assertEquals(4050, deliveryOrderLine.dmpl__TaxAmount__c, 'Tax Amount mismatch');
        System.assertEquals(26550, deliveryOrderLine.dmpl__GrossAmount__c, 'Gross Amount mismatch');
        System.assertEquals(22500, deliveryOrderLine.dmpl__Amount__c, 'Amount should equal Gross Amount');
        System.assertEquals(repairOrderLine.Id, deliveryOrderLine.dmpl__RepairOrderLineId__c, 'Repair Order Line reference mismatch');

        
        deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder1.Id);
        System.assertEquals(22500, deliveryOrder.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount mismatch');
        System.assertEquals(26550, deliveryOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount mismatch');
        System.assertEquals(22500, deliveryOrder.dmpl__TotalLineAmount__c, 'Total Line Amount mismatch');
        System.assertEquals(26550, deliveryOrder.dmpl__TotalAmount__c, 'Total Amount mismatch');
        System.assertEquals(4050, deliveryOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount mismatch');
        System.assertEquals(Date.today(), deliveryOrder.dmpl__DocumentDate__c, 'Document Date mismatch');

        
        dmpl__DeliveryOrderLine__c deliveryOrderLineToUpdate = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);
        deliveryOrderLineToUpdate.dmpl__Quantity__c = 17;
        update deliveryOrderLineToUpdate;
        deliveryOrderLineToUpdate = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);

        System.assertEquals(1500, deliveryOrderLineToUpdate.dmpl__UnitPrice__c, 'Unit Price mismatch');
        System.assertEquals(Item1.Id, deliveryOrderLineToUpdate.dmpl__ItemId__c, 'Item ID mismatch');
        System.assertEquals(17, deliveryOrderLineToUpdate.dmpl__Quantity__c, 'Quantity mismatch');
        System.assertEquals(taxGroup18.Id, deliveryOrderLineToUpdate.dmpl__TaxGroupId__c, 'Tax Group ID mismatch');

        System.assertEquals(25500, deliveryOrderLineToUpdate.dmpl__BaseAmount__c, 'Base Amount mismatch');
        System.assertEquals(4590, deliveryOrderLineToUpdate.dmpl__TaxAmount__c, 'Tax Amount mismatch');
        System.assertEquals(30090, deliveryOrderLineToUpdate.dmpl__GrossAmount__c, 'Gross Amount mismatch');
        System.assertEquals(25500, deliveryOrderLineToUpdate.dmpl__Amount__c, 'Amount should equal Gross Amount');
        System.assertEquals(repairOrderLine.Id, deliveryOrderLineToUpdate.dmpl__RepairOrderLineId__c, 'Repair Order Line reference mismatch');

        
         deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder1.Id);
        System.assertEquals(25500, deliveryOrder.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount mismatch');
        System.assertEquals(30090, deliveryOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount mismatch');
        System.assertEquals(25500, deliveryOrder.dmpl__TotalLineAmount__c, 'Total Line Amount mismatch');
        System.assertEquals(30090, deliveryOrder.dmpl__TotalAmount__c, 'Total Amount mismatch');
        System.assertEquals(4590, deliveryOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount mismatch');
        System.assertEquals(Date.today(), deliveryOrder.dmpl__DocumentDate__c, 'Document Date mismatch');

        Test.stopTest();
    }

    
    @isTest
    public static void deliveryOrderLineWithZeroQuantityPositiveEdit() {

        
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');

        Test.startTest();

        dmpl__DeliveryOrder__c deliveryOrder1 = DeliveryOrderDataHelper.createDeliveryOrder(partnerAccount1.Id, customerAccount1.Id, branch1.Id, null, null,null);
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder1.Id);

        System.assertEquals(partnerAccount1.Id, deliveryOrder.dmpl__PartnerAccountId__c, 'partner account Id mismatch');
        System.assertEquals(customerAccount1.Id, deliveryOrder.dmpl__AccountId__c, 'Account Id must be Customer1 Id');
        System.assertEquals(customerAccount1.Name, deliveryOrder.dmpl__AccountId__r.Name, 'Account Name mismatch');
        System.assertEquals(customerAccount1.dmpl__BillingStreet__c, deliveryOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(customerAccount1.dmpl__BillingCity__c, deliveryOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals(customerAccount1.dmpl__BillingState__c, deliveryOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals(customerAccount1.dmpl__BillingCountry__c, deliveryOrder.dmpl__BillingCountry__c, 'Billing country should match');
        System.assertEquals(customerAccount1.dmpl__BillingPostalCode__c, deliveryOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(Date.today(), deliveryOrder.dmpl__DocumentDate__c, 'Document Date should match');

        
        dmpl__Item__c item8 = TestDataHelpers.getItem('Item 8');
        dmpl__DeliveryOrderLine__c deliveryOrderLine1 = DeliveryOrderDataHelper.createDeliveryOrderLine(deliveryOrder.Id,item8.Id,null,2,1500,null,null,null,null);
        dmpl__DeliveryOrderLine__c deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine1.Id);

        System.assertEquals(1500, deliveryOrderLine.dmpl__UnitPrice__c, 'Unit Price mismatch');
        System.assertEquals(item8.Id, deliveryOrderLine.dmpl__ItemId__c, 'Item ID mismatch');
        System.assertEquals(deliveryOrder.Id, deliveryOrderLine.dmpl__DeliveryId__c, 'Delivery ID mismatch');
        System.assertEquals(2, deliveryOrderLine.dmpl__Quantity__c, 'Quantity mismatch');
        System.assertEquals(2, deliveryOrderLine.dmpl__EligibleReturnQuantity__c, 'Eligible Return Quantity mismatch');
        System.assertEquals(2, deliveryOrderLine.dmpl__PendingInvoiceQuantity__c, 'Pending Invoice Quantity mismatch');
        System.assertEquals(2, deliveryOrderLine.dmpl__PendingShippedQuantity__c, 'Pending Shipped Quantity mismatch');
        System.assertEquals(3000, deliveryOrderLine.dmpl__BaseAmount__c, 'Base Amount mismatch');
        System.assertEquals(3000, deliveryOrderLine.dmpl__GrossAmount__c, 'Gross Amount mismatch');
        System.assertEquals(3000, deliveryOrderLine.dmpl__Amount__c, 'Amount should equal Gross Amount');

        
        dmpl__DeliveryOrderLine__c deliveryOrderLineToUpdate = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);
        deliveryOrderLineToUpdate.dmpl__Quantity__c = 1;
        update deliveryOrderLineToUpdate;
        deliveryOrderLineToUpdate = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);
        
        Test.stopTest();

        System.assertEquals(1500, deliveryOrderLineToUpdate.dmpl__UnitPrice__c, 'Unit Price mismatch');
        System.assertEquals(item8.Id, deliveryOrderLineToUpdate.dmpl__ItemId__c, 'Item ID mismatch');
        System.assertEquals(deliveryOrder.Id, deliveryOrderLineToUpdate.dmpl__DeliveryId__c, 'Delivery ID mismatch');
        System.assertEquals(1, deliveryOrderLineToUpdate.dmpl__Quantity__c, 'Quantity mismatch');
        System.assertEquals(1, deliveryOrderLineToUpdate.dmpl__EligibleReturnQuantity__c, 'Eligible Return Quantity mismatch');
        System.assertEquals(1, deliveryOrderLineToUpdate.dmpl__PendingInvoiceQuantity__c, 'Pending Invoice Quantity mismatch');
        System.assertEquals(1, deliveryOrderLineToUpdate.dmpl__PendingShippedQuantity__c, 'Pending Shipped Quantity mismatch');
        System.assertEquals(1500, deliveryOrderLineToUpdate.dmpl__BaseAmount__c, 'Base Amount mismatch');
        System.assertEquals(1500, deliveryOrderLineToUpdate.dmpl__GrossAmount__c, 'Gross Amount mismatch');
        System.assertEquals(1500, deliveryOrderLineToUpdate.dmpl__Amount__c, 'Amount should equal Gross Amount');

    }

    
    @isTest
    public static void deliveryOrderLineWithZeroQuantityNegativeNew() {

        
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        
        Test.startTest();
        
        dmpl__DeliveryOrder__c deliveryOrder1 = DeliveryOrderDataHelper.createDeliveryOrder(partnerAccount1.Id, customerAccount1.Id, branch1.Id, null, null,null);
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder1.Id);

        System.assertEquals(partnerAccount1.Id, deliveryOrder.dmpl__PartnerAccountId__c, 'partner account Id mismatch');
        System.assertEquals(customerAccount1.Id, deliveryOrder.dmpl__AccountId__c, 'Customer account ID mismatch');
        System.assertEquals(branch1.Id, deliveryOrder.dmpl__BranchId__c, 'Branch ID mismatch');
        System.assertEquals(customerAccount1.Id, deliveryOrder.dmpl__AccountId__c, 'Account Id must be Customer1 Id');
        System.assertEquals(customerAccount1.Name, deliveryOrder.dmpl__AccountId__r.Name, 'Account Name mismatch');
        System.assertEquals(customerAccount1.dmpl__BillingStreet__c, deliveryOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(customerAccount1.dmpl__BillingCity__c, deliveryOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals(customerAccount1.dmpl__BillingState__c, deliveryOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals(customerAccount1.dmpl__BillingCountry__c, deliveryOrder.dmpl__BillingCountry__c, 'Billing country should match');
        System.assertEquals(customerAccount1.dmpl__BillingPostalCode__c, deliveryOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(customerAccount1.dmpl__ShippingStreet__c, deliveryOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals(customerAccount1.dmpl__ShippingCity__c, deliveryOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals(customerAccount1.dmpl__ShippingState__c, deliveryOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals(customerAccount1.dmpl__ShippingCountry__c, deliveryOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals(customerAccount1.dmpl__ShippingPostalCode__c, deliveryOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
        System.assertEquals(Date.today(), deliveryOrder.dmpl__DocumentDate__c, 'Document Date should match');
        
        
        dmpl__Item__c item8 = TestDataHelpers.getItem('Item 8');
        dmpl__DeliveryOrderLine__c deliveryOrderLine;
        try {
            deliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(deliveryOrder.Id,item8.Id,null,0,1500,null,null,null,null);
            System.assert(false,'Need Not to be able to create a delivery order line with zero quantity updated');
        } catch (Exception e) {
            System.assert(true,'Need Not to be able to create a delivery order line with zero quantity');
        }

        Test.stopTest();
    }

    
    @isTest
    public static void deliveryOrderLineWithoutUnitCostPositiveNew() {
        
        
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        
        Test.startTest();
        
        dmpl__DeliveryOrder__c deliveryOrder1 = DeliveryOrderDataHelper.createDeliveryOrder(partnerAccount1.Id, customerAccount1.Id, branch1.Id, null, null,null);
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder1.Id);
        
        System.assertEquals(partnerAccount1.Id, deliveryOrder.dmpl__PartnerAccountId__c, 'partner account Id mismatch');
        System.assertEquals(customerAccount1.Id, deliveryOrder.dmpl__AccountId__c, 'Customer account ID mismatch');
        System.assertEquals(branch1.Id, deliveryOrder.dmpl__BranchId__c, 'Branch ID mismatch');
        System.assertEquals(customerAccount1.Id, deliveryOrder.dmpl__AccountId__c, 'Account Id must be Customer1 Id');
        System.assertEquals(customerAccount1.Name, deliveryOrder.dmpl__AccountId__r.Name, 'Account Name mismatch');
        System.assertEquals(customerAccount1.dmpl__BillingStreet__c, deliveryOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(customerAccount1.dmpl__BillingCity__c, deliveryOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals(customerAccount1.dmpl__BillingState__c, deliveryOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals(customerAccount1.dmpl__BillingCountry__c, deliveryOrder.dmpl__BillingCountry__c, 'Billing country should match');
        System.assertEquals(customerAccount1.dmpl__BillingPostalCode__c, deliveryOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(customerAccount1.dmpl__ShippingStreet__c, deliveryOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals(customerAccount1.dmpl__ShippingCity__c, deliveryOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals(customerAccount1.dmpl__ShippingState__c, deliveryOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals(customerAccount1.dmpl__ShippingCountry__c, deliveryOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals(customerAccount1.dmpl__ShippingPostalCode__c, deliveryOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
        System.assertEquals(Date.today(), deliveryOrder.dmpl__DocumentDate__c, 'Document Date should match');

        
        dmpl__Item__c item7 = TestDataHelpers.getItem('Item 7');
		dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('IGST 18'); 
        dmpl__DeliveryOrderLine__c deliveryOrderLine1 = DeliveryOrderDataHelper.createDeliveryOrderLine(deliveryOrder.Id,item7.Id,taxGroup.Id,5,0,null,null,null,sku?.Id);
        dmpl__DeliveryOrderLine__c deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine1.Id);

        Test.stopTest();

        System.assertEquals(0, deliveryOrderLine.dmpl__UnitPrice__c, 'Unit Price mismatch');
        System.assertEquals(item7.Id, deliveryOrderLine.dmpl__ItemId__c, 'Item ID mismatch');
        System.assertEquals(5, deliveryOrderLine.dmpl__Quantity__c, 'Quantity mismatch');
        System.assertEquals(taxGroup.Id, deliveryOrderLine.dmpl__TaxGroupId__c, 'Tax Group ID mismatch');
        System.assertEquals(deliveryOrder.Id, deliveryOrderLine.dmpl__DeliveryId__c, 'Delivery ID mismatch');
    
    }

    
    @isTest
    public static void deliveryOrderLineWithoutUnitCostPositiveEdit() {
        
        
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        
        Test.startTest();
        
        dmpl__DeliveryOrder__c deliveryOrder1 = DeliveryOrderDataHelper.createDeliveryOrder(partnerAccount1.Id, customerAccount1.Id, branch1.Id, null, null,null);
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder1.Id);
        
        System.assertEquals(partnerAccount1.Id, deliveryOrder.dmpl__PartnerAccountId__c, 'partner account Id mismatch');
        System.assertEquals(customerAccount1.Id, deliveryOrder.dmpl__AccountId__c, 'Customer account ID mismatch');
        System.assertEquals(branch1.Id, deliveryOrder.dmpl__BranchId__c, 'Branch ID mismatch');
        System.assertEquals(customerAccount1.Id, deliveryOrder.dmpl__AccountId__c, 'Account Id must be Customer1 Id');
        System.assertEquals(customerAccount1.Name, deliveryOrder.dmpl__AccountId__r.Name, 'Account Name mismatch');
        System.assertEquals(customerAccount1.dmpl__BillingStreet__c, deliveryOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(customerAccount1.dmpl__BillingCity__c, deliveryOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals(customerAccount1.dmpl__BillingState__c, deliveryOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals(customerAccount1.dmpl__BillingCountry__c, deliveryOrder.dmpl__BillingCountry__c, 'Billing country should match');
        System.assertEquals(customerAccount1.dmpl__BillingPostalCode__c, deliveryOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(customerAccount1.dmpl__ShippingStreet__c, deliveryOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals(customerAccount1.dmpl__ShippingCity__c, deliveryOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals(customerAccount1.dmpl__ShippingState__c, deliveryOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals(customerAccount1.dmpl__ShippingCountry__c, deliveryOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals(customerAccount1.dmpl__ShippingPostalCode__c, deliveryOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
        System.assertEquals(Date.today(), deliveryOrder.dmpl__DocumentDate__c, 'Document Date should match');

        
        dmpl__Item__c item7 = TestDataHelpers.getItem('Item 7');
		dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('IGST 18'); 
        dmpl__DeliveryOrderLine__c deliveryOrderLine1 = DeliveryOrderDataHelper.createDeliveryOrderLine(deliveryOrder.Id,item7.Id,taxGroup.Id,10,0,null,null,null,sku?.Id);
        dmpl__DeliveryOrderLine__c deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine1.Id);

        System.assertEquals(0, deliveryOrderLine.dmpl__UnitPrice__c, 'Unit Price mismatch');
        System.assertEquals(item7.Id, deliveryOrderLine.dmpl__ItemId__c, 'Item ID mismatch');
        System.assertEquals(10, deliveryOrderLine.dmpl__Quantity__c, 'Quantity mismatch');
        System.assertEquals(taxGroup.Id, deliveryOrderLine.dmpl__TaxGroupId__c, 'Tax Group ID mismatch');
        System.assertEquals(deliveryOrder.Id, deliveryOrderLine.dmpl__DeliveryId__c, 'Delivery ID mismatch');

        
        dmpl__DeliveryOrderLine__c deliveryOrderLineToUpdate = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);
        deliveryOrderLineToUpdate.dmpl__Quantity__c = 12;
        update deliveryOrderLineToUpdate;

        Test.stopTest();

        System.assertEquals(0, deliveryOrderLineToUpdate.dmpl__UnitPrice__c, 'Unit Price mismatch');
        System.assertEquals(item7.Id, deliveryOrderLineToUpdate.dmpl__ItemId__c, 'Item ID mismatch');
        System.assertEquals(12, deliveryOrderLineToUpdate.dmpl__Quantity__c, 'Quantity mismatch');
        System.assertEquals(taxGroup.Id, deliveryOrderLineToUpdate.dmpl__TaxGroupId__c, 'Tax Group ID mismatch');
        System.assertEquals(deliveryOrder.Id, deliveryOrderLineToUpdate.dmpl__DeliveryId__c, 'Delivery ID mismatch');

        
        System.assertEquals(0, deliveryOrder.dmpl__TotalLineAmount__c, 'Total Line Amount mismatch');
        System.assertEquals(0, deliveryOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount mismatch');
        System.assertEquals(0, deliveryOrder.dmpl__TotalAmount__c, 'Amount should equal Total Line Gross Amount');
        System.assertEquals(0, deliveryOrder.dmpl__TotalLineBaseAmount__c, 'Amount should equal Total Line Gross Amount');
    }



    












        
    @isTest
        static void deliveryOrderCreationWithRepairOrderReferencePositiveEdit() {
            Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
            dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
            Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
            dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
            
            Asset asset = TestDataHelpers.createAsset('Asset 1', customer1.Id, item1.Id);
            Account partner4 = TestDataHelpers.getPartnerAccount('Partner 4');
            dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
            dmpl__PriceList__c priceList1 =  TestDataHelpers.getPriceList('Price List 1');

            Test.startTest();
            dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrder(partner1, customer1, branch1, asset, 300);
            System.assertNotEquals(null, repairOrder.Id, 'Repair Order must be created');
            dmpl__RepairOrder__c retrievedRepairOrder = RepairOrderTestDataHelpers.getRepairOrdersById(repairOrder.Id)[0];

            System.assertEquals(customer1.Name, retrievedRepairOrder.dmpl__AccountName__c, 'Account Name mismatch');
            System.assertEquals(priceList1.Id, retrievedRepairOrder.dmpl__PriceListId__c, 'Price List ID mismatch');
            System.assertEquals(customer1.dmpl__BillingStreet__c, retrievedRepairOrder.dmpl__BillingStreet__c, 'Billing street should match');
            System.assertEquals(customer1.dmpl__BillingCity__c, retrievedRepairOrder.dmpl__BillingCity__c, 'Billing city should match');
            System.assertEquals(customer1.dmpl__BillingState__c, retrievedRepairOrder.dmpl__BillingState__c, 'Billing state should match');
            System.assertEquals(customer1.dmpl__BillingCountry__c, retrievedRepairOrder.dmpl__BillingCountry__c, 'Billing country should match');
            System.assertEquals(customer1.dmpl__BillingPostalCode__c, retrievedRepairOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
            System.assertEquals(System.today(), retrievedRepairOrder.dmpl__DocumentDate__c, 'Document Date mismatch');
            System.assertEquals('Draft', retrievedRepairOrder.dmpl__Status__c, 'Status mismatch');

            dmpl__RepairOrderLine__c repairOrderLine = RepairOrderTestDataHelpers.createRepairOrderLine(repairOrder.Id, item1.Id, 10, 1500);
            System.assertNotEquals(null, repairOrderLine.Id, 'Repair Order Line must be created');
            dmpl__RepairOrderLine__c retrievedRepairOrderLine = RepairOrderTestDataHelpers.getRepairOrderLine(repairOrderLine.Id);
           
            System.assertEquals(1500, retrievedRepairOrderLine.dmpl__UnitPrice__c, 'Unit Price mismatch');
            
            
            
            
            
            
            
            
            System.assertEquals(15000, retrievedRepairOrderLine.dmpl__BaseAmount__c, 'Base Amount mismatch');
            System.assertEquals(0, retrievedRepairOrderLine.dmpl__NetDiscount__c, 'Net Discount mismatch');
            System.assertEquals(0, retrievedRepairOrderLine.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount mismatch');
            
            

            dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner4.Id, customer1.Id, branch4.Id, repairOrder.Id, null, null);
            System.assertNotEquals(null, deliveryOrder.Id, 'Delivery Order must be created');
            dmpl__DeliveryOrder__c retrievedDeliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
            System.assertEquals(customer1.Name, retrievedDeliveryOrder.dmpl__AccountName__c, 'Account Name mismatch');
            System.assertEquals(customer1.dmpl__BillingStreet__c, retrievedDeliveryOrder.dmpl__BillingStreet__c, 'Billing street should match');
            System.assertEquals(customer1.dmpl__BillingCity__c, retrievedDeliveryOrder.dmpl__BillingCity__c, 'Billing city should match');
            System.assertEquals(customer1.dmpl__BillingState__c, retrievedDeliveryOrder.dmpl__BillingState__c, 'Billing state should match');
            System.assertEquals(customer1.dmpl__ShippingStreet__c, retrievedDeliveryOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
            System.assertEquals(repairOrder.Id, retrievedDeliveryOrder.dmpl__RepairOrderId__c, 'Repair Order ID mismatch');

            Test.stopTest();
        }

        @isTest
        static void deliveryOrderCreationWithWrongPartnerAccountNegativeEdit(){
            Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
            dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
            Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
            Account partner4 = TestDataHelpers.getPartnerAccount('Partner 4');

            Test.startTest();

            dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner1.Id, customer1.Id, branch1.Id, null, null, null);
            System.assertNotEquals(null, deliveryOrder.Id, 'Delivery Order must be created');
            dmpl__DeliveryOrder__c retrievedDeliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
            System.assertEquals(customer1.Name, retrievedDeliveryOrder.dmpl__AccountName__c, 'Account Name mismatch');
            System.assertEquals(customer1.dmpl__BillingStreet__c, retrievedDeliveryOrder.dmpl__BillingStreet__c, 'Billing street should match');
            System.assertEquals(customer1.dmpl__BillingCity__c, retrievedDeliveryOrder.dmpl__BillingCity__c, 'Billing city should match');
            System.assertEquals(customer1.dmpl__BillingState__c, retrievedDeliveryOrder.dmpl__BillingState__c, 'Billing state should match');
            System.assertEquals(customer1.dmpl__ShippingStreet__c, retrievedDeliveryOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
            System.assertEquals(customer1.dmpl__ShippingCity__c, retrievedDeliveryOrder.dmpl__ShippingCity__c, 'Shipping city should match');
            System.assertEquals(customer1.dmpl__ShippingState__c, retrievedDeliveryOrder.dmpl__ShippingState__c, 'Shipping state should match');
            System.assertEquals(customer1.dmpl__ShippingCountry__c, retrievedDeliveryOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
            
            try {
                deliveryOrder.dmpl__PartnerAccountId__c = partner4.Id; 
                update deliveryOrder;
                
            } catch (Exception e) {
                System.assert(e.getMessage().contains('Partner Account must be same as Delivery Order Partner Account'), 'Exception message mismatch');
            }
            Test.stopTest();
        }

        @isTest 
        public static void deliveryOrderCreationWithInactiveBranchNegativeEdit(){
            Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
            dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
            Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
            dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');

            Test.startTest();
            
            dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner1.Id, customer1.Id, branch1.Id, null, null, null);
            System.assertNotEquals(null, deliveryOrder.Id, 'Delivery Order must be created');
            dmpl__DeliveryOrder__c retrievedDeliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
            System.assertEquals(customer1.Name, retrievedDeliveryOrder.dmpl__AccountName__c, 'Account Name mismatch');
            System.assertEquals(customer1.dmpl__BillingStreet__c, retrievedDeliveryOrder.dmpl__BillingStreet__c, 'Billing street should match');
            System.assertEquals(customer1.dmpl__BillingCity__c, retrievedDeliveryOrder.dmpl__BillingCity__c, 'Billing city should match');
            System.assertEquals(customer1.dmpl__BillingState__c, retrievedDeliveryOrder.dmpl__BillingState__c, 'Billing state should match');
            
            System.assertEquals(customer1.dmpl__ShippingStreet__c, retrievedDeliveryOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
            System.assertEquals(customer1.dmpl__ShippingCity__c, retrievedDeliveryOrder.dmpl__ShippingCity__c, 'Shipping city should match');
            System.assertEquals(customer1.dmpl__ShippingState__c, retrievedDeliveryOrder.dmpl__ShippingState__c, 'Shipping state should match');
            System.assertEquals(customer1.dmpl__ShippingCountry__c, retrievedDeliveryOrder.dmpl__ShippingCountry__c, 'Shipping country should match');


            try {
                deliveryOrder.dmpl__BranchId__c = branch3.Id;
                update deliveryOrder;
                
            } catch (Exception e) {
                System.assert(e.getMessage().contains('Branch must be active'), 'Exception message mismatch');
            }
            Test.stopTest();
        }

        @isTest
        public static void deliveryOrderWithNoCustomerAccountNegativeEdit(){
            Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
            dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
            Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');

            Test.startTest();
            dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner1.Id, customer1.Id, branch1.Id, null, null, null);
            System.assertNotEquals(null, deliveryOrder.Id, 'Delivery Order must be created');
            dmpl__DeliveryOrder__c retrievedDeliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
            System.assertEquals(customer1.Name, retrievedDeliveryOrder.dmpl__AccountName__c, 'Account Name mismatch');
            System.assertEquals(customer1.dmpl__BillingStreet__c, retrievedDeliveryOrder.dmpl__BillingStreet__c, 'Billing street should match');
            System.assertEquals(customer1.dmpl__BillingCity__c, retrievedDeliveryOrder.dmpl__BillingCity__c, 'Billing city should match');
            System.assertEquals(customer1.dmpl__BillingState__c, retrievedDeliveryOrder.dmpl__BillingState__c, 'Billing state should match');
            
            System.assertEquals(customer1.dmpl__ShippingStreet__c, retrievedDeliveryOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
            System.assertEquals(customer1.dmpl__ShippingCity__c, retrievedDeliveryOrder.dmpl__ShippingCity__c, 'Shipping city should match');
            System.assertEquals(customer1.dmpl__ShippingState__c, retrievedDeliveryOrder.dmpl__ShippingState__c, 'Shipping state should match');
            System.assertEquals(customer1.dmpl__ShippingCountry__c, retrievedDeliveryOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
            
            try {
                deliveryOrder.dmpl__AccountId__c = null; 
                update deliveryOrder;
                
            } catch (Exception e) {
                System.assert(e.getMessage().contains('Account is required'), 'Exception message mismatch');
            }
            Test.stopTest();
        }

        @isTest
        public static void deliveryOrderCreationWithNoSaleOrderPositiveEdit(){
            Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
            dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
            Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
            Account customer5 = TestDataHelpers.getCustomerAccount('Customer 5');

            Test.startTest();
            dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner1.Id, customer1.Id, branch1.Id, null, null, null);
            System.assertNotEquals(null, deliveryOrder.Id, 'Delivery Order must be created');
            dmpl__DeliveryOrder__c retrievedDeliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
            System.assertEquals(customer1.Name, retrievedDeliveryOrder.dmpl__AccountName__c, 'Account Name mismatch');
            System.assertEquals(customer1.dmpl__BillingStreet__c, retrievedDeliveryOrder.dmpl__BillingStreet__c, 'Billing street should match');
            System.assertEquals(customer1.dmpl__BillingCity__c, retrievedDeliveryOrder.dmpl__BillingCity__c, 'Billing city should match');
            System.assertEquals(customer1.dmpl__BillingState__c, retrievedDeliveryOrder.dmpl__BillingState__c, 'Billing state should match');
            
            System.assertEquals(customer1.dmpl__ShippingStreet__c, retrievedDeliveryOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
            System.assertEquals(customer1.dmpl__ShippingCity__c, retrievedDeliveryOrder.dmpl__ShippingCity__c, 'Shipping city should match');
            System.assertEquals(customer1.dmpl__ShippingState__c, retrievedDeliveryOrder.dmpl__ShippingState__c, 'Shipping state should match');
            System.assertEquals(customer1.dmpl__ShippingCountry__c, retrievedDeliveryOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
            
            System.assertEquals(0, retrievedDeliveryOrder.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be zero');
            System.assertEquals(0, retrievedDeliveryOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be zero');
            System.assertEquals(0, retrievedDeliveryOrder.dmpl__TotalLineAmount__c, 'Total Line Amount should be zero');
            System.assertEquals(0, retrievedDeliveryOrder.dmpl__TotalAmount__c, 'Total Amount should be zero');
            System.assertEquals(0, retrievedDeliveryOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be zero');

            deliveryOrder.dmpl__AccountId__c = customer5.Id;
            update deliveryOrder;
            retrievedDeliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
            System.assertEquals(customer1.Name, retrievedDeliveryOrder.dmpl__AccountName__c, 'Account Name mismatch');
            System.assertEquals(customer1.dmpl__BillingStreet__c, retrievedDeliveryOrder.dmpl__BillingStreet__c, 'Billing street should match');
            System.assertEquals(customer1.dmpl__BillingCity__c, retrievedDeliveryOrder.dmpl__BillingCity__c, 'Billing city should match');
            System.assertEquals(customer1.dmpl__BillingState__c, retrievedDeliveryOrder.dmpl__BillingState__c, 'Billing state should match');
            
            System.assertEquals(customer1.dmpl__ShippingStreet__c, retrievedDeliveryOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
            System.assertEquals(customer1.dmpl__ShippingCity__c, retrievedDeliveryOrder.dmpl__ShippingCity__c, 'Shipping city should match');
            System.assertEquals(customer1.dmpl__ShippingState__c, retrievedDeliveryOrder.dmpl__ShippingState__c, 'Shipping state should match');
            System.assertEquals(customer1.dmpl__ShippingCountry__c, retrievedDeliveryOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
            
            System.assertEquals(0, retrievedDeliveryOrder.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount should be zero');
            System.assertEquals(0, retrievedDeliveryOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount should be zero');
            System.assertEquals(0, retrievedDeliveryOrder.dmpl__TotalLineAmount__c, 'Total Line Amount should be zero');
            System.assertEquals(0, retrievedDeliveryOrder.dmpl__TotalAmount__c, 'Total Amount should be zero');
            System.assertEquals(0, retrievedDeliveryOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount should be zero');

            Test.stopTest();
        }

        @isTest 
        public static void deliveryOrderCreationWithNoRepairOrderPositiveEdit(){
            Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
            dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
            Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
            Account customer5 = TestDataHelpers.getCustomerAccount('Customer 5');

            Test.startTest();
            dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner1.Id, customer1.Id, branch1.Id, null, null, null);
            System.assertNotEquals(null, deliveryOrder.Id, 'Delivery Order must be created');
            dmpl__DeliveryOrder__c retrievedDeliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
            System.assertEquals(customer1.Name, retrievedDeliveryOrder.dmpl__AccountName__c, 'Account Name mismatch');
            System.assertEquals(customer1.dmpl__BillingStreet__c, retrievedDeliveryOrder.dmpl__BillingStreet__c, 'Billing street should match');
            System.assertEquals(customer1.dmpl__BillingCity__c, retrievedDeliveryOrder.dmpl__BillingCity__c, 'Billing city should match');
            System.assertEquals(customer1.dmpl__BillingState__c, retrievedDeliveryOrder.dmpl__BillingState__c, 'Billing state should match');
            System.assertEquals(customer1.dmpl__ShippingStreet__c, retrievedDeliveryOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
            System.assertEquals(customer1.dmpl__ShippingCountry__c, retrievedDeliveryOrder.dmpl__ShippingCountry__c, 'Shipping country should match');

            System.assertEquals(customer1.dmpl__BillingPostalCode__c, retrievedDeliveryOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
            System.assertEquals(System.today(), retrievedDeliveryOrder.dmpl__DocumentDate__c, 'Document Date mismatch');


            deliveryOrder.dmpl__AccountId__c = customer5.Id; 
            update deliveryOrder;
            retrievedDeliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
            System.assertEquals(customer1.Name, retrievedDeliveryOrder.dmpl__AccountName__c, 'Account Name mismatch after update');
            
            System.assertEquals(customer1.dmpl__BillingStreet__c, retrievedDeliveryOrder.dmpl__BillingStreet__c, 'Billing street should match after update');
            System.assertEquals(customer1.dmpl__BillingCity__c, retrievedDeliveryOrder.dmpl__BillingCity__c, 'Billing city should match after update');
            System.assertEquals(customer1.dmpl__BillingState__c, retrievedDeliveryOrder.dmpl__BillingState__c, 'Billing state should match after update');
            System.assertEquals(customer1.dmpl__BillingCountry__c, retrievedDeliveryOrder.dmpl__BillingCountry__c, 'Billing country should match after update');
            System.assertEquals(customer1.dmpl__BillingPostalCode__c, retrievedDeliveryOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match after update');
            System.assertEquals(System.today(), retrievedDeliveryOrder.dmpl__DocumentDate__c, 'Document Date should remain unchanged after update');
            System.assertEquals(customer1.dmpl__ShippingStreet__c, retrievedDeliveryOrder.dmpl__ShippingStreet__c, 'Shipping street should match after update');
            System.assertEquals(customer1.dmpl__ShippingCountry__c, retrievedDeliveryOrder.dmpl__ShippingCountry__c, 'Shipping country should match after update');

            Test.stopTest();
        }


    @isTest
    public static void deliveryOrderWithDefinedDeliveryAddressPositiveNew(){

        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__ContactAddress__c deliveryAddress = TestDataHelpers.getContactAddress('Address 1');

        Test.startTest();
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner1.Id, customer1.Id, branch1.Id, null, null, deliveryAddress.Id);
        System.assertNotEquals(null, deliveryOrder.Id, 'Delivery Order must be created');
        dmpl__DeliveryOrder__c retrievedDeliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        System.assertEquals(customer1.Name, retrievedDeliveryOrder.dmpl__AccountName__c, 'Account Name mismatch');
        System.assertEquals(customer1.dmpl__BillingStreet__c, retrievedDeliveryOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(customer1.dmpl__BillingCity__c, retrievedDeliveryOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals(customer1.dmpl__BillingState__c, retrievedDeliveryOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals(branch1.Id, retrievedDeliveryOrder.dmpl__BranchId__c, 'Branch Name mismatch');
        
        System.assertEquals(customer1.dmpl__ShippingStreet__c, retrievedDeliveryOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals(customer1.dmpl__ShippingCity__c, retrievedDeliveryOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals(customer1.dmpl__ShippingState__c, retrievedDeliveryOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals(customer1.dmpl__ShippingPostalCode__c, retrievedDeliveryOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
        System.assertEquals(System.today(), retrievedDeliveryOrder.dmpl__DocumentDate__c, 'Document Date mismatch');
        
        Test.stopTest();
    }

    @isTest
    public static void deliveryOrderWithDefinedDeliveryAddressPositiveEdit(){
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__ContactAddress__c deliveryAddress = TestDataHelpers.getContactAddress('Address 1');
        dmpl__ContactAddress__c newDeliveryAddress = TestDataHelpers.getContactAddress('Address 2');
        
        Test.startTest();
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner1.Id, customer1.Id, branch1.Id, null, null, deliveryAddress.Id);
        System.assertNotEquals(null, deliveryOrder.Id, 'Delivery Order must be created');
        dmpl__DeliveryOrder__c retrievedDeliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        System.assertEquals(System.today(), retrievedDeliveryOrder.dmpl__DocumentDate__c, 'Document Date mismatch');
        System.assertEquals(customer1.Id, retrievedDeliveryOrder.dmpl__AccountId__c, 'Account Id mismatch');
        System.assertEquals(partner1.Id, retrievedDeliveryOrder.dmpl__PartnerAccountId__c, 'Partner Account ID mismatch');
        System.assertEquals(branch1.Id, retrievedDeliveryOrder.dmpl__BranchId__c, 'Branch ID mismatch');
        System.assertEquals(customer1.dmpl__BillingStreet__c, retrievedDeliveryOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(customer1.dmpl__BillingCity__c, retrievedDeliveryOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals(customer1.dmpl__BillingState__c, retrievedDeliveryOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals(customer1.dmpl__ShippingCity__c, retrievedDeliveryOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals(customer1.dmpl__ShippingCountry__c, retrievedDeliveryOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals(customer1.dmpl__ShippingPostalCode__c, retrievedDeliveryOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
        System.assertEquals(deliveryAddress.Id, retrievedDeliveryOrder.dmpl__DeliveryAddressId__c, 'Delivery Address ID mismatch');

        deliveryOrder.dmpl__DeliveryAddressId__c = newDeliveryAddress.Id;
        update deliveryOrder;
        retrievedDeliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        System.assertEquals(partner1.Id, retrievedDeliveryOrder.dmpl__PartnerAccountId__c, 'Partner Account ID mismatch after update');
        System.assertEquals(branch1.Id, retrievedDeliveryOrder.dmpl__BranchId__c, 'Branch ID mismatch after update');
        System.assertEquals(customer1.Id, retrievedDeliveryOrder.dmpl__AccountId__c, 'Account Id mismatch after update');
        System.assertEquals(newDeliveryAddress.Id, retrievedDeliveryOrder.dmpl__DeliveryAddressId__c, 'Delivery Address ID mismatch after update');
        System.assertEquals(customer1.dmpl__BillingStreet__c, retrievedDeliveryOrder.dmpl__BillingStreet__c, 'Billing street should match after update');
        System.assertEquals(customer1.dmpl__BillingCity__c, retrievedDeliveryOrder.dmpl__BillingCity__c, 'Billing city should match after update');
        System.assertEquals(customer1.dmpl__BillingState__c, retrievedDeliveryOrder.dmpl__BillingState__c, 'Billing state should match after update');
        System.assertEquals(customer1.dmpl__BillingCountry__c, retrievedDeliveryOrder.dmpl__BillingCountry__c, 'Billing country should match after update');
        System.assertEquals(customer1.dmpl__BillingPostalCode__c, retrievedDeliveryOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match after update');
        System.assertEquals(customer1.dmpl__ShippingStreet__c, retrievedDeliveryOrder.dmpl__ShippingStreet__c, 'Shipping street should match after update');
        System.assertEquals(customer1.dmpl__ShippingCity__c, retrievedDeliveryOrder.dmpl__ShippingCity__c, 'Shipping city should match after update');
        System.assertEquals(customer1.dmpl__ShippingState__c, retrievedDeliveryOrder.dmpl__ShippingState__c, 'Shipping state should match after update');
        System.assertEquals(customer1.dmpl__ShippingCountry__c, retrievedDeliveryOrder.dmpl__ShippingCountry__c, 'Shipping country should match after update');
        System.assertEquals(customer1.dmpl__ShippingPostalCode__c, retrievedDeliveryOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should match after update');
        System.assertEquals(System.today(), retrievedDeliveryOrder.dmpl__DocumentDate__c, 'Document Date should remain unchanged after update');
        System.assertEquals(newDeliveryAddress.Id, retrievedDeliveryOrder.dmpl__DeliveryAddressId__c, 'Delivery Address ID should match after update');

        Test.stopTest();
    }


    @isTest 
    public static void deliveryOrderCreationWithWrongBranchNegativeEdit(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        
        Test.startTest();
        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner1.Id, customer1.Id, branch1.Id, null, null, null);
        System.assertNotEquals(null, deliveryOrder.Id, 'Delivery Order must be created');
        dmpl__DeliveryOrder__c retrievedDeliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        System.assertEquals(customer1.Name, retrievedDeliveryOrder.dmpl__AccountName__c, 'Account Name mismatch');
        System.assertEquals(customer1.dmpl__BillingStreet__c, retrievedDeliveryOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(customer1.dmpl__BillingCity__c, retrievedDeliveryOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals(customer1.dmpl__BillingState__c, retrievedDeliveryOrder.dmpl__BillingState__c, 'Billing state should match');
        
        System.assertEquals(customer1.dmpl__ShippingStreet__c, retrievedDeliveryOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals(customer1.dmpl__ShippingCity__c, retrievedDeliveryOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals(customer1.dmpl__ShippingState__c, retrievedDeliveryOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals(customer1.dmpl__ShippingCountry__c, retrievedDeliveryOrder.dmpl__ShippingCountry__c, 'Shipping country should match');

        try {
            deliveryOrder.dmpl__BranchId__c = branch4.Id; 
            update deliveryOrder;
            
         } catch (Exception e) {
            System.assert(e.getMessage().contains('Wrong branch'), 'Exception message mismatch');
        }
        Test.stopTest();
    }

    @isTest 
    public static void deliveryOrderCreationWithSaleOrderReferencePositiveEdit(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
		Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
		dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('IGST 18');

        Test.startTest();

        dmpl__DeliveryOrder__c deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner1.Id, customer1.Id, branch1.Id, null, null, null);

        System.assertNotEquals(null, deliveryOrder.Id, 'Delivery Order must be created');
        dmpl__DeliveryOrder__c retrievedDeliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        System.assertEquals(customer1.Id, retrievedDeliveryOrder.dmpl__AccountId__c, 'Account Id mismatch');
        System.assertEquals(branch1.Id, retrievedDeliveryOrder.dmpl__BranchId__c, 'Branch ID mismatch');
        System.assertEquals(partner1.Id, retrievedDeliveryOrder.dmpl__PartnerAccountId__c, 'Partner Account ID mismatch');
        System.assertEquals(customer1.dmpl__BillingStreet__c, retrievedDeliveryOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(customer1.dmpl__BillingCity__c, retrievedDeliveryOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals(customer1.dmpl__BillingState__c, retrievedDeliveryOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals(customer1.dmpl__BillingCountry__c, retrievedDeliveryOrder.dmpl__BillingCountry__c, 'Billing country should match');
        System.assertEquals(customer1.dmpl__BillingPostalCode__c, retrievedDeliveryOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(customer1.dmpl__ShippingStreet__c, retrievedDeliveryOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals(customer1.dmpl__ShippingCity__c, retrievedDeliveryOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals(customer1.dmpl__ShippingState__c, retrievedDeliveryOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals(customer1.dmpl__ShippingCountry__c, retrievedDeliveryOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals(customer1.dmpl__ShippingPostalCode__c, retrievedDeliveryOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
    

		dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder( customer1.Id, partner1.Id,branch1.Id, null, null, true, null);


		dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(saleOrder.Id, item1.Id, 3, null);

        deliveryOrder.dmpl__SaleOrderId__c = saleOrder.Id;
        update deliveryOrder;

		deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
       

        System.assertEquals(customer1.Id, deliveryOrder.dmpl__AccountId__c, 'Account Id must be Customer1 Id');
		System.assertEquals(customer1.Name, deliveryOrder.dmpl__AccountId__r.Name, 'Account Name mismatch');
		System.assertEquals(customer1.dmpl__BillingStreet__c, deliveryOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(customer1.dmpl__BillingCity__c, deliveryOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals(customer1.dmpl__BillingState__c, deliveryOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals(customer1.dmpl__BillingCountry__c, deliveryOrder.dmpl__BillingCountry__c, 'Billing country should match');
        System.assertEquals(customer1.dmpl__BillingPostalCode__c, deliveryOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(customer1.dmpl__ShippingStreet__c, deliveryOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals(customer1.dmpl__ShippingCity__c, deliveryOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals(customer1.dmpl__ShippingState__c, deliveryOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals(customer1.dmpl__ShippingCountry__c, deliveryOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals(customer1.dmpl__ShippingPostalCode__c, deliveryOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
		System.assertEquals(partner1.Id, deliveryOrder.dmpl__PartnerAccountId__c, 'Partner Account ID mismatch');
		System.assertEquals(partner1.Name, deliveryOrder.dmpl__PartnerAccountId__r.Name, 'Partner Account ID mismatch');
		System.assertEquals(branch1.Id, deliveryOrder.dmpl__BranchId__c, 'Branch ID mismatch');
		System.assertEquals(branch1.Name, deliveryOrder.dmpl__BranchId__r.Name, 'Branch ID mismatch');
		
		
		
		
		

		Test.stopTest();
    }


	
	@isTest
	static void createDeliveryOrderCreationWithSaleOrderReferencePositive(){
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 8');
		dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder( customer?.Id, partner?.Id,branch?.Id, null, null, true, null);
		dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(saleOrder?.Id, item?.Id, 1, null);
		saleOrderLine.dmpl__UnitPrice__c = 1500;
		update saleOrderLine;

		dmpl__DeliveryOrder__c deliveryOrder; 
		try{
			deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner?.Id, customer?.Id, branch?.Id, null, saleOrder?.Id, null);
		}catch(Exception e){
			System.Assert.isTrue(deliveryOrder != null, 'Delivery Order Must be Created!');
		}

		deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);

		System.assertEquals(saleOrder?.Id, deliveryOrder?.dmpl__SaleOrderId__c, 'Sale Order should match');
        System.assertEquals(customer?.Id, deliveryOrder?.dmpl__AccountId__c, 'Account Id must be Customer? Id');
		System.assertEquals(customer?.Name, deliveryOrder?.dmpl__AccountId__r?.Name, 'Account Name mismatch');
		System.assertEquals(customer?.dmpl__BillingStreet__c, deliveryOrder?.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(customer?.dmpl__BillingCity__c, deliveryOrder?.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals(customer?.dmpl__BillingState__c, deliveryOrder?.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals(customer?.dmpl__BillingCountry__c, deliveryOrder?.dmpl__BillingCountry__c, 'Billing country should match');
        System.assertEquals(customer?.dmpl__BillingPostalCode__c, deliveryOrder?.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(customer?.dmpl__ShippingStreet__c, deliveryOrder?.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals(customer?.dmpl__ShippingCity__c, deliveryOrder?.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals(customer?.dmpl__ShippingState__c, deliveryOrder?.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals(customer?.dmpl__ShippingCountry__c, deliveryOrder?.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals(customer?.dmpl__ShippingPostalCode__c, deliveryOrder?.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
		System.assertEquals(partner?.Id, deliveryOrder?.dmpl__PartnerAccountId__c, 'Partner Account ID mismatch');
		System.assertEquals(partner?.Name, deliveryOrder?.dmpl__PartnerAccountId__r?.Name, 'Partner Account ID mismatch');
		System.assertEquals(branch?.Id, deliveryOrder?.dmpl__BranchId__c, 'Branch ID mismatch');
		System.assertEquals(branch?.Name, deliveryOrder?.dmpl__BranchId__r?.Name, 'Branch ID mismatch');
		Test.stopTest();
	}
	
	@isTest
	static void updateDeliveryOrderCreationWithInActivePartnerAccountNegative(){
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
		Account customer = TestDataHelpers.getCustomerAccount('Customer 1');

		dmpl__DeliveryOrder__c deliveryOrder; 
		try{
			deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner?.Id, customer?.Id, branch?.Id, null, null, null);
		}catch(Exception e){
			System.Assert.isTrue(deliveryOrder != null, 'Delivery Order Must be Created!');
		}

		deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);

        System.assertEquals(customer?.Id, deliveryOrder?.dmpl__AccountId__c, 'Account Id must be Customer? Id');
		System.assertEquals(customer?.Name, deliveryOrder?.dmpl__AccountId__r?.Name, 'Account Name mismatch');
		System.assertEquals(customer?.dmpl__BillingStreet__c, deliveryOrder?.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(customer?.dmpl__BillingCity__c, deliveryOrder?.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals(customer?.dmpl__BillingState__c, deliveryOrder?.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals(customer?.dmpl__BillingCountry__c, deliveryOrder?.dmpl__BillingCountry__c, 'Billing country should match');
        System.assertEquals(customer?.dmpl__BillingPostalCode__c, deliveryOrder?.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(customer?.dmpl__ShippingStreet__c, deliveryOrder?.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals(customer?.dmpl__ShippingCity__c, deliveryOrder?.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals(customer?.dmpl__ShippingState__c, deliveryOrder?.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals(customer?.dmpl__ShippingCountry__c, deliveryOrder?.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals(customer?.dmpl__ShippingPostalCode__c, deliveryOrder?.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
		System.assertEquals(partner?.Id, deliveryOrder?.dmpl__PartnerAccountId__c, 'Partner Account ID mismatch');
		System.assertEquals(partner?.Name, deliveryOrder?.dmpl__PartnerAccountId__r?.Name, 'Partner Account ID mismatch');
		System.assertEquals(branch?.Id, deliveryOrder?.dmpl__BranchId__c, 'Branch ID mismatch');
		System.assertEquals(branch?.Name, deliveryOrder?.dmpl__BranchId__r?.Name, 'Branch ID mismatch');
		

		
		partner = TestDataHelpers.getPartnerAccount('Partner 2');

		try {
        	branch = TestDataHelpers.createBranch('Branch 2', partner.Id, true, false, true, true);
			deliveryOrder.dmpl__PartnerAccountId__c = partner?.Id;
			deliveryOrder.dmpl__BranchId__c = branch?.Id;
			update deliveryOrder;
			System.assert(false, 'Update should have failed but it succeeded.');
		} catch (Exception e) {
			deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
			System.assert(true, 'Delivery Order must not be updated. >> '+ e.getMessage());
		}


		Test.stopTest();
	}
	
	@isTest
	static void createDeliveryOrderLineWithoutItemLotPositive(){
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		Account customer = TestDataHelpers.getCustomerAccount('Customer 1');

		dmpl__DeliveryOrder__c deliveryOrder; 
		try{
			deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner?.Id, customer?.Id, branch?.Id, null,null, null);
		}catch(Exception e){
			System.Assert.isTrue(deliveryOrder != null, 'Delivery Order Must be Created!');
		}
		deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        System.assertEquals(customer?.Id, deliveryOrder?.dmpl__AccountId__c, 'Account Id must be Customer? Id');
		System.assertEquals(customer?.Name, deliveryOrder?.dmpl__AccountId__r?.Name, 'Account Name mismatch');
		System.assertEquals(customer?.dmpl__BillingStreet__c, deliveryOrder?.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(customer?.dmpl__BillingCity__c, deliveryOrder?.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals(customer?.dmpl__BillingState__c, deliveryOrder?.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals(customer?.dmpl__BillingCountry__c, deliveryOrder?.dmpl__BillingCountry__c, 'Billing country should match');
        System.assertEquals(customer?.dmpl__BillingPostalCode__c, deliveryOrder?.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(customer?.dmpl__ShippingStreet__c, deliveryOrder?.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals(customer?.dmpl__ShippingCity__c, deliveryOrder?.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals(customer?.dmpl__ShippingState__c, deliveryOrder?.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals(customer?.dmpl__ShippingCountry__c, deliveryOrder?.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals(customer?.dmpl__ShippingPostalCode__c, deliveryOrder?.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
		System.assertEquals(partner?.Id, deliveryOrder?.dmpl__PartnerAccountId__c, 'Partner Account ID mismatch');
		System.assertEquals(partner?.Name, deliveryOrder?.dmpl__PartnerAccountId__r?.Name, 'Partner Account ID mismatch');
		System.assertEquals(branch?.Id, deliveryOrder?.dmpl__BranchId__c, 'Branch ID mismatch');
		System.assertEquals(branch?.Name, deliveryOrder?.dmpl__BranchId__r?.Name, 'Branch ID mismatch');

		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
		dmpl__DeliveryOrderLine__c deliveryOrderLine;
		try{
			deliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(deliveryOrder.Id,item.Id,taxGroup.Id,1,1500,null,null,null,null);
		}catch(Exception e){
			System.Assert.isTrue(deliveryOrderLine != null, 'Delivery Order Line Must be Created!');
		}

        deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);
        System.assertEquals(item.Id, deliveryOrderLine.dmpl__ItemId__c, 'Item ID mismatch');
        System.assertEquals(taxGroup.Id, deliveryOrderLine.dmpl__TaxGroupId__c, 'Tax Group ID mismatch');
        System.assertEquals(deliveryOrder.Id, deliveryOrderLine.dmpl__DeliveryId__c, 'Delivery ID mismatch');
		System.assertEquals(1500, deliveryOrderLine.dmpl__UnitPrice__c, 'Unit Price mismatch');
        System.assertEquals(1, deliveryOrderLine.dmpl__Quantity__c, 'Quantity mismatch');
		System.assertEquals(1500, deliveryOrderLine.dmpl__Amount__c, 'Amount mismatch');
		System.assertEquals(1500, deliveryOrderLine.dmpl__BaseAmount__c, 'Base Amount mismatch');
		System.assertEquals(1920, deliveryOrderLine.dmpl__GrossAmount__c, 'Gross Amount mismatch');
		System.assertEquals(0, deliveryOrderLine.dmpl__NetDiscount__c, 'Net Discount mismatch');
		System.assertEquals(420, deliveryOrderLine.dmpl__TaxAmount__c, 'Tax Amount mismatch');


		deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
		System.assertEquals(1500, deliveryOrder.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount mismatch');
		System.assertEquals(1920, deliveryOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount mismatch');
		System.assertEquals(1500, deliveryOrder.dmpl__TotalLineAmount__c, 'Total Line Amount mismatch');
		System.assertEquals(1920, deliveryOrder.dmpl__TotalAmount__c, 'Total Amount mismatch');
		System.assertEquals(420, deliveryOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount mismatch');
		System.assertEquals(0, deliveryOrder.dmpl__TotalDiscountAmount__c, 'Total Discount Amount mismatch');
		Test.stopTest();
	}
	
	@isTest
	static void createDeliveryOrderLineWithRemovingRequiredSKUPositive(){
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
		Account customer = TestDataHelpers.getCustomerAccount('Customer 1');

		dmpl__DeliveryOrder__c deliveryOrder; 
		try{
			deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner?.Id, customer?.Id, branch?.Id, null, null, null);
		}catch(Exception e){
			System.Assert.isTrue(deliveryOrder != null, 'Delivery Order Must be Created!');
		}
		deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        System.assertEquals(customer?.Id, deliveryOrder?.dmpl__AccountId__c, 'Account Id must be Customer? Id');
		System.assertEquals(customer?.Name, deliveryOrder?.dmpl__AccountId__r?.Name, 'Account Name mismatch');
		System.assertEquals(customer?.dmpl__BillingStreet__c, deliveryOrder?.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(customer?.dmpl__BillingCity__c, deliveryOrder?.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals(customer?.dmpl__BillingState__c, deliveryOrder?.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals(customer?.dmpl__BillingCountry__c, deliveryOrder?.dmpl__BillingCountry__c, 'Billing country should match');
        System.assertEquals(customer?.dmpl__BillingPostalCode__c, deliveryOrder?.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(customer?.dmpl__ShippingStreet__c, deliveryOrder?.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals(customer?.dmpl__ShippingCity__c, deliveryOrder?.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals(customer?.dmpl__ShippingState__c, deliveryOrder?.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals(customer?.dmpl__ShippingCountry__c, deliveryOrder?.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals(customer?.dmpl__ShippingPostalCode__c, deliveryOrder?.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
		System.assertEquals(partner?.Id, deliveryOrder?.dmpl__PartnerAccountId__c, 'Partner Account ID mismatch');
		System.assertEquals(partner?.Name, deliveryOrder?.dmpl__PartnerAccountId__r?.Name, 'Partner Account ID mismatch');
		System.assertEquals(branch?.Id, deliveryOrder?.dmpl__BranchId__c, 'Branch ID mismatch');
		System.assertEquals(branch?.Name, deliveryOrder?.dmpl__BranchId__r?.Name, 'Branch ID mismatch');

		dmpl__Item__c item = TestDataHelpers.getItem('Item 9');
		dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 3');
		dmpl__DeliveryOrderLine__c deliveryOrderLine;
		try{
			deliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(deliveryOrder.Id,item.Id,null,1,1500,null,null,null,sku?.Id);
		}catch(Exception e){
			System.Assert.isTrue(deliveryOrderLine != null, 'Delivery Order Must be Created!');
		}

        deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);
        System.assertEquals(item.Id, deliveryOrderLine.dmpl__ItemId__c, 'Item ID mismatch');
        System.assertEquals(sku.Id, deliveryOrderLine.dmpl__SKUId__c, 'SKU ID mismatch');
        System.assertEquals(deliveryOrder.Id, deliveryOrderLine.dmpl__DeliveryId__c, 'Delivery ID mismatch');
		System.assertEquals(1500, deliveryOrderLine.dmpl__UnitPrice__c, 'Unit Price mismatch');
        System.assertEquals(1, deliveryOrderLine.dmpl__Quantity__c, 'Quantity mismatch');

		try {
			deliveryOrderLine.dmpl__SKUId__c = null;
			update deliveryOrderLine;
		} catch (Exception e) {
			deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);
			System.assert(deliveryOrderLine.dmpl__SKUId__c != null, 'Delivery Order Line must not be updated.');
		}
        System.assertEquals(null, deliveryOrderLine.dmpl__SKUId__c, 'SKU ID mismatch');

		Test.stopTest();
	}

	
	@isTest
	static void createDeliveryOrderLineWithSaleOrderLineReference2Positive(){
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder( customer?.Id, partner?.Id,branch?.Id, null, null, true, null);
		Test.startTest();
		dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(saleOrder?.Id, item?.Id, 15, null);

		dmpl__DeliveryOrder__c deliveryOrder; 
		try{
			deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner?.Id, customer?.Id, branch?.Id, null, saleOrder?.Id, null);
		}catch(Exception e){
			System.Assert.isTrue(deliveryOrder != null, 'Delivery Order Must be Created!');
		}

		deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
		System.assertEquals(saleOrder?.Id, deliveryOrder?.dmpl__SaleOrderId__c, 'Sale Order should match');
        System.assertEquals(customer?.Id, deliveryOrder?.dmpl__AccountId__c, 'Account Id must be Customer? Id');
		System.assertEquals(customer?.Name, deliveryOrder?.dmpl__AccountId__r?.Name, 'Account Name mismatch');
		System.assertEquals(customer?.dmpl__BillingStreet__c, deliveryOrder?.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(customer?.dmpl__BillingCity__c, deliveryOrder?.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals(customer?.dmpl__BillingState__c, deliveryOrder?.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals(customer?.dmpl__BillingCountry__c, deliveryOrder?.dmpl__BillingCountry__c, 'Billing country should match');
        System.assertEquals(customer?.dmpl__BillingPostalCode__c, deliveryOrder?.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(customer?.dmpl__ShippingStreet__c, deliveryOrder?.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals(customer?.dmpl__ShippingCity__c, deliveryOrder?.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals(customer?.dmpl__ShippingState__c, deliveryOrder?.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals(customer?.dmpl__ShippingCountry__c, deliveryOrder?.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals(customer?.dmpl__ShippingPostalCode__c, deliveryOrder?.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
		System.assertEquals(partner?.Id, deliveryOrder?.dmpl__PartnerAccountId__c, 'Partner Account ID mismatch');
		System.assertEquals(partner?.Name, deliveryOrder?.dmpl__PartnerAccountId__r?.Name, 'Partner Account ID mismatch');
		System.assertEquals(branch?.Id, deliveryOrder?.dmpl__BranchId__c, 'Branch ID mismatch');
		System.assertEquals(branch?.Name, deliveryOrder?.dmpl__BranchId__r?.Name, 'Branch ID mismatch');

        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
		dmpl__DeliveryOrderLine__c deliveryOrderLine;
		try{
			deliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(deliveryOrder.Id,item.Id,taxGroup.Id,10,1500,null, null,null,null);
		}catch(Exception e){
			System.Assert.isTrue(deliveryOrderLine != null, 'Delivery Order Line Must be Created!');
		}

        deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);
        System.assertEquals(item.Id, deliveryOrderLine.dmpl__ItemId__c, 'Item ID mismatch');
        System.assertEquals(taxGroup.Id, deliveryOrderLine.dmpl__TaxGroupId__c, 'Tax Group ID mismatch');
        System.assertEquals(deliveryOrder.Id, deliveryOrderLine.dmpl__DeliveryId__c, 'Delivery ID mismatch');
		System.assertEquals(1500, deliveryOrderLine.dmpl__UnitPrice__c, 'Unit Price mismatch');
        System.assertEquals(10, deliveryOrderLine.dmpl__Quantity__c, 'Quantity mismatch');
		System.assertEquals(15000, deliveryOrderLine.dmpl__Amount__c, 'Amount mismatch');
		System.assertEquals(15000, deliveryOrderLine.dmpl__BaseAmount__c, 'Base Amount mismatch');
		System.assertEquals(19200, deliveryOrderLine.dmpl__GrossAmount__c, 'Gross Amount mismatch');

		deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
		System.assertEquals(15000, deliveryOrder.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount mismatch');
		System.assertEquals(19200, deliveryOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount mismatch');
		System.assertEquals(15000, deliveryOrder.dmpl__TotalLineAmount__c, 'Total Line Amount mismatch');
		System.assertEquals(19200, deliveryOrder.dmpl__TotalAmount__c, 'Total Amount mismatch');
		System.assertEquals(4200, deliveryOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount mismatch');

		try{
			deliveryOrderLine.dmpl__Quantity__c = 15;
			deliveryOrderLine.dmpl__SaleOrderLineId__c = saleOrderLine?.Id;
			update deliveryOrderLine;
		}catch(Exception e){
			System.assert(false, 'delivery Order Line must get Update !>>'+e.getMessage());
		}

		deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id); 
		System.assertEquals(22500, deliveryOrder.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount mismatch');
		System.assertEquals(28800, deliveryOrder.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount mismatch');
		System.assertEquals(22500, deliveryOrder.dmpl__TotalLineAmount__c, 'Total Line Amount mismatch');
		System.assertEquals(28800, deliveryOrder.dmpl__TotalAmount__c, 'Total Amount mismatch');
		System.assertEquals(6300, deliveryOrder.dmpl__TotalTaxAmount__c, 'Total Tax Amount mismatch');

		Test.stopTest();
	}
	
	@isTest
	static void updateDeliveryOrderLineWithZeroQuantityNegative(){
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 7');
		dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
		dmpl__DeliveryOrder__c deliveryOrder; 
		try{
			deliveryOrder = DeliveryOrderDataHelper.createDeliveryOrder(partner?.Id, customer?.Id, branch?.Id, null, null, null);
		}catch(Exception e){
			System.Assert.isTrue(deliveryOrder != null, 'Delivery Order Must be Created!');
		}

		deliveryOrder = DeliveryOrderDataHelper.getDeliveryOrder(deliveryOrder.Id);
        System.assertEquals(customer?.Id, deliveryOrder?.dmpl__AccountId__c, 'Account Id must be Customer? Id');
		System.assertEquals(customer?.Name, deliveryOrder?.dmpl__AccountId__r?.Name, 'Account Name mismatch');
		System.assertEquals(customer?.dmpl__BillingStreet__c, deliveryOrder?.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(customer?.dmpl__BillingCity__c, deliveryOrder?.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals(customer?.dmpl__BillingState__c, deliveryOrder?.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals(customer?.dmpl__BillingCountry__c, deliveryOrder?.dmpl__BillingCountry__c, 'Billing country should match');
        System.assertEquals(customer?.dmpl__BillingPostalCode__c, deliveryOrder?.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(customer?.dmpl__ShippingStreet__c, deliveryOrder?.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals(customer?.dmpl__ShippingCity__c, deliveryOrder?.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals(customer?.dmpl__ShippingState__c, deliveryOrder?.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals(customer?.dmpl__ShippingCountry__c, deliveryOrder?.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals(customer?.dmpl__ShippingPostalCode__c, deliveryOrder?.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
		System.assertEquals(partner?.Id, deliveryOrder?.dmpl__PartnerAccountId__c, 'Partner Account ID mismatch');
		System.assertEquals(partner?.Name, deliveryOrder?.dmpl__PartnerAccountId__r?.Name, 'Partner Account ID mismatch');
		System.assertEquals(branch?.Id, deliveryOrder?.dmpl__BranchId__c, 'Branch ID mismatch');
		System.assertEquals(branch?.Name, deliveryOrder?.dmpl__BranchId__r?.Name, 'Branch ID mismatch');

		dmpl__DeliveryOrderLine__c deliveryOrderLine;
		try{
			deliveryOrderLine = DeliveryOrderDataHelper.createDeliveryOrderLine(deliveryOrder.Id,item.Id,null,10,1200,null,null,null,sku?.Id);
		}catch(Exception e){
			System.Assert.isTrue(deliveryOrderLine != null, 'Delivery Order Line Must be Created!');
		}

        deliveryOrderLine = DeliveryOrderDataHelper.getDeliveryOrderLine(deliveryOrderLine.Id);
        System.assertEquals(item.Id, deliveryOrderLine.dmpl__ItemId__c, 'Item ID mismatch');
        System.assertEquals(deliveryOrder.Id, deliveryOrderLine.dmpl__DeliveryId__c, 'Delivery ID mismatch');
		System.assertEquals(1200, deliveryOrderLine.dmpl__UnitPrice__c, 'Unit Price mismatch');
        System.assertEquals(10, deliveryOrderLine.dmpl__Quantity__c, 'Quantity mismatch');

		try{
			deliveryOrderLine.dmpl__Quantity__c = 0;
			update deliveryOrderLine;
			System.assert(false, 'delivery Order Line must get Update!');
		}catch(Exception e){
			System.assert(True, 'delivery Order Line must get Update!');
		}


		Test.stopTest();
	}

    
}