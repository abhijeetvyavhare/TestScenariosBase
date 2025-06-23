@isTest
public class FulfillmentHandler1_Test {
    
    
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
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(customerAccount,branch,contactAddress,priceList);
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(saleOrder,item,sku,taxGroup);
        dmpl__SaleOrderTax__c saleOrderTax = SaleOrderDataHelper.createSaleOrderTax(saleOrder, saleOrderLine);
 
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
        //dmpl__PriceList__c priceList4 = TestDataHelpers.createPriceList('Price List 4',null, null,null,null,true,false,'Sale Price');
        dmpl__PriceList__c priceList5=TestDataHelpers.createPriceList('Price List 5', partnerAccount6.Id, branch6.Id, null, null, false, false, 'Sales');
        //dmpl__PriceList__c priceList6=TestDataHelpers.createPriceList('Price List 6', null, null, null, null, true, false, 'Sales');
         dmpl__PriceList__c priceList7 = TestDataHelpers.createPriceList('Price List 7',null,null, null, null, true, false, 'Sales');
 
        dmpl__Item__c  item1 = TestDataHelpers.createItem('Item 1','Product',true,false,false,'675654',false);
        dmpl__Item__c item2 = TestDataHelpers.createItem('Item 2','Product',false,false,false,'654345',false);
        dmpl__Item__c item3 = TestDataHelpers.createItem('Item 3','Charge Item',true, false, false ,'765434',true);
        dmpl__Item__c item4 = TestDataHelpers.createItem('Item 4','Product',true, false, false ,'765676',true);
        dmpl__Item__c item5 = TestDataHelpers.createItem('Item 5', 'Product', true, false, false, '876543', false);
        dmpl__Item__c item6 = TestDataHelpers.createItem('Item 6', 'Product', true, false, false, '765456', false);
        dmpl__Item__c item7 = TestDataHelpers.createItem('Item 7','Product',true,false,true, '765456',false);
        dmpl__Item__c item8 = TestDataHelpers.createItem('Item 8','Product',true,false,true, '765456',false);
        dmpl__Item__c item13 = TestDataHelpers.createItem('Item 13','Product',true,false,false, '765456',true);
        dmpl__Item__c item9 = TestDataHelpers.createItem('Item 9', 'Product', true, false, true, '765456', false);

        dmpl__ItemGroup__c itemGroup1 = TestDataHelpers.createItemGroup('Item Group 1','Tax');
        dmpl__ItemGroupMember__c itemGroupMemeber1 = TestDataHelpers.createItemGroupMember(itemGroup1.Id,item1.Id);
        dmpl__ItemGroupMember__c itemGroupMemeber2 = TestDataHelpers.createItemGroupMember(itemGroup1.Id,item2.Id);
     
        dmpl__SKU__c sku1 = TestDataHelpers.createSKU('SKU 1', item7.id, true);
        dmpl__SKU__c sku2 = TestDataHelpers.createSKU('SKU 2', item8.id, false);
 
        dmpl__PriceListRules__c priceListRule1 = TestDataHelpers.createPriceListRules(priceList1.id, item1.id,null,null,1500, System.today().addDays(-15),System.today()+9);
        dmpl__PriceListRules__c priceListRule3 = TestDataHelpers.createPriceListRules(priceList1.id, item3.id,null,null,2000, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule4 = TestDataHelpers.createPriceListRules(priceList1.id, item4.id,null,null,2000, System.today()-1,System.today()+9);  
        dmpl__PriceListRules__c priceListRule5 = TestDataHelpers.createPriceListRules(priceList3.id, item6.id,null,null,2000, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule7 = TestDataHelpers.createPriceListRules(priceList3.id, item5.id,null,null,1000, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule8 = TestDataHelpers.createPriceListRules(priceList1.id, item5.id,null,null,1000, System.today().addDays(-1),System.today()+9);
        dmpl__PriceListRules__c priceListRule9 = TestDataHelpers.createPriceListRules(priceList1.id, item6.id,null,null,2400, System.today()-1,System.today()+9);  
        dmpl__PriceListRules__c priceListRule10 = TestDataHelpers.createPriceListRules(priceList3.id, item1.id,null,null,1500, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule11 = TestDataHelpers.createPriceListRules(priceList3.id, item8.id,null,null,1500, System.today()-1,System.today()+9);

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
        //dmpl__TaxGroupRule__c taxGroupRuleItem4 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST28.Id,item4.Id,null,null,null);
        dmpl__TaxGroupRule__c taxGroupRule28item8 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST28partner4.Id,item8.Id,null,null,null);  
       
        dmpl__Resource__c resource2 = TestDataHelpers.createResource('Resource 2', partnerAccount1.Id, branch1.Id, false);
        dmpl__StorageLocation__c storageLocation1 = FulfillmentTestDataHelpers.createStorageLocation('Storage Location 1',branch1,true,'Warehouse'); 
        
    }
    @isTest
    public static void editfulfillmentpickingLineWithRemovingRequiredSkuNegative() {
 
        Account Partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item9 = TestDataHelpers.getItem('Item 9');
        dmpl__SKU__c sku3 = TestDataHelpers.createSKU(item9);
       
        Test.startTest();
        
        dmpl__InventoryFulfillment__c fulfillment1 = FulfillmentTestDataHelpers.createInventoryFulfillmentWithAllValues(Partner1,customerAccount1,branch1,null,null,Date.today(),'Draft');        
 		dmpl__InventoryFulfillment__c fulfillment=FulfillmentTestDataHelpers.getInventoryFulfillment(fulfillment1.Id);
        System.assertNotEquals(null, fulfillment.Id, 'Fulfillment should be created');
        System.assertEquals(Partner1.Id, fulfillment.dmpl__PartnerAccountId__c, 'Partner Account ID should match');
        System.assertEquals(branch1.Id, fulfillment.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(customerAccount1.Id, fulfillment.dmpl__AccountId__c, 'Customer Account ID should match');
        System.assertEquals(System.today(), fulfillment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', fulfillment.dmpl__Status__c, 'Status should be Draft');
 
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine1 = FulfillmentTestDataHelpers.createInventoryFulfillmentOrderLine(fulfillment, item9, 1, 1500, null, null, sku3, null, null);
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = FulfillmentTestDataHelpers.getInventoryFulfillmentOrderLine(fulfillmentOrderLine1.Id);
        System.assertNotEquals(null, fulfillmentOrderLine.Id, 'Fulfillment Order Line should be created');
        System.assertEquals(item9.Id, fulfillmentOrderLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(1, fulfillmentOrderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, fulfillmentOrderLine.dmpl__UnitCost__c, 'Unit Cost should match');
        System.assertEquals(fulfillment.Id, fulfillmentOrderLine.dmpl__FulfillmentId__c, 'Unit Cost should match');
 
        dmpl__InventoryFulfillmentAllocationLine__c fulfillmentAllocationLine1=FulfillmentTestDataHelpers.createInventoryFulfillmentAllocationLine( item9 , 1,sku3 ,fulfillment ,fulfillmentOrderLine );
        dmpl__InventoryFulfillmentAllocationLine__c fulfillmentAllocationLine=FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(fulfillmentAllocationLine1.Id);
        System.assertNotEquals(null, fulfillmentAllocationLine.Id, 'Fulfillment Allocation Line should be created');
        System.assertEquals(item9.Id, fulfillmentAllocationLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(1, fulfillmentAllocationLine.dmpl__Quantity__c, 'Quantity should match');
 
        dmpl__InventoryFulfillmentPickingLine__c fulfillmentPickingLine1 = FulfillmentTestDataHelpers.createFulfillmentPickingLine(fulfillment,item9,fulfillmentAllocationLine,null,1,null,null,sku3);
        dmpl__InventoryFulfillmentPickingLine__c fulfillmentPickingLine = FulfillmentTestDataHelpers.getFulfillmentPickingLine(fulfillmentPickingLine1.Id);
        System.assertNotEquals(null, fulfillmentPickingLine.Id, 'Fulfillment Picking Line should be created');
        System.assertEquals(item9.Id, fulfillmentPickingLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(1, fulfillmentPickingLine.dmpl__Quantity__c, 'Quantity should match');
 
        try {
            dmpl__InventoryFulfillmentPickingLine__c fulfillmentPickingLine2 = FulfillmentTestDataHelpers.getFulfillmentPickingLine(fulfillmentPickingLine1.Id);
            fulfillmentPickingLine2.dmpl__SKUId__c = null;
            
            update fulfillmentPickingLine2;
            
            System.assert(false, 'Expected exception was not thrown');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Specified field is not editable if there exists downstream transaction. Field Name : "dmpl__SKUId__c"'),'Exception message should mention the SKU field restriction, but was: ' + e.getMessage()); 
        }
       
        Test.stopTest();
       
    }
 
 
 
    @isTest
    public static void editfulfillmentpickingLineWithNoRequiredSku() {
 
        Account Partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
       
        Test.startTest();
        
        dmpl__InventoryFulfillment__c fulfillment1 = FulfillmentTestDataHelpers.createInventoryFulfillmentWithAllValues(Partner1,customerAccount1,branch1,null,null,Date.today(),'Draft');        
  		dmpl__InventoryFulfillment__c fulfillment=FulfillmentTestDataHelpers.getInventoryFulfillment(fulfillment1.Id);
        System.assertNotEquals(null, fulfillment.Id, 'Fulfillment should be created');
        System.assertEquals(Partner1.Id, fulfillment.dmpl__PartnerAccountId__c, 'Partner Account ID should match');
        System.assertEquals(branch1.Id, fulfillment.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(customerAccount1.Id, fulfillment.dmpl__AccountId__c, 'Customer Account ID should match');
        System.assertEquals(System.today(), fulfillment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', fulfillment.dmpl__Status__c, 'Status should be Draft');
 
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine1 = FulfillmentTestDataHelpers.createInventoryFulfillmentOrderLine(fulfillment, item1, 10, 1500, null, null, null, null, null);
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = FulfillmentTestDataHelpers.getInventoryFulfillmentOrderLine(fulfillmentOrderLine1.Id);
        System.assertNotEquals(null, fulfillmentOrderLine.Id, 'Fulfillment Order Line should be created');
        System.assertEquals(item1.Id, fulfillmentOrderLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(10, fulfillmentOrderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, fulfillmentOrderLine.dmpl__UnitCost__c, 'Unit Cost should match');
 
        dmpl__InventoryFulfillmentAllocationLine__c fulfillmentAllocationLine1 = FulfillmentTestDataHelpers.createInventoryFulfillmentAllocationLine( item1 , 10 ,fulfillment ,fulfillmentOrderLine );
        dmpl__InventoryFulfillmentAllocationLine__c fulfillmentAllocationLine=FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(fulfillmentAllocationLine1.Id);
        System.assertNotEquals(null, fulfillmentAllocationLine.Id, 'Fulfillment Allocation Line should be created');
        System.assertEquals(item1.Id, fulfillmentAllocationLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(10, fulfillmentAllocationLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(10, fulfillmentAllocationLine.dmpl__AllocatedQuantity__c, 'Allocated Quantity should match');
        System.assertEquals(fulfillmentOrderLine.Id, fulfillmentAllocationLine.dmpl__FulfillmentOrderLineId__c, 'Fulfillment Order Line should match');
        System.assertEquals(fulfillment.Id, fulfillmentAllocationLine.dmpl__FulfillmentOrderId__c, 'Fulfillment should match');
 
        dmpl__InventoryFulfillmentPickingLine__c fulfillmentPickingLine1 = FulfillmentTestDataHelpers.createFulfillmentPickingLine(fulfillment,item1,fulfillmentAllocationLine,10,1500,null);
        dmpl__InventoryFulfillmentPickingLine__c fulfillmentPickingLine = FulfillmentTestDataHelpers.getFulfillmentPickingLine(fulfillmentPickingLine1.Id);
        System.assertNotEquals(null, fulfillmentPickingLine.Id, 'Fulfillment Picking Line should be created');
        System.assertEquals(item1.Id, fulfillmentPickingLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(10, fulfillmentPickingLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(fulfillmentAllocationLine.Id, fulfillmentPickingLine.dmpl__FulfillmentAllocationLineId__c, 'Fulfillment Allocation Line should match');
        System.assertEquals(fulfillment.Id, fulfillmentPickingLine.dmpl__FulfillmentOrderId__c, 'Fulfillment should match');

        fulfillmentPickingLine.dmpl__Quantity__c = 5;
        update fulfillmentPickingLine;
        
        dmpl__InventoryFulfillmentPickingLine__c fulfillmentPickingLine2 = FulfillmentTestDataHelpers.getFulfillmentPickingLine(fulfillmentPickingLine.Id);
        System.assertEquals(5, fulfillmentPickingLine2.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(item1.Id, fulfillmentPickingLine2.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(1500, fulfillmentPickingLine2.dmpl__UnitCost__c, 'UnitCost should match');
        System.assertEquals(fulfillmentAllocationLine.Id, fulfillmentPickingLine2.dmpl__FulfillmentAllocationLineId__c, 'Fulfillment Allocation Line should match');
        System.assertEquals(fulfillment.Id, fulfillmentPickingLine2.dmpl__FulfillmentOrderId__c, 'Fulfillment should match');

        Test.stopTest();
       
    }
    
    @isTest
    public static void editFulfillmentPickingLineWithStorageLocation() {
 
        Account Partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__StorageLocation__c storageLocation1 = FulfillmentTestDataHelpers.getStorageLocation('Storage Location 1');
      
        Test.startTest();
        
        dmpl__InventoryFulfillment__c fulfillment1 = FulfillmentTestDataHelpers.createInventoryFulfillmentWithAllValues(Partner1,customerAccount1,branch1,null,null,Date.today(),'Draft');        
   		dmpl__InventoryFulfillment__c fulfillment=FulfillmentTestDataHelpers.getInventoryFulfillment(fulfillment1.Id);
        System.assertNotEquals(null, fulfillment.Id, 'Fulfillment should be created');
        System.assertEquals(Partner1.Id, fulfillment.dmpl__PartnerAccountId__c, 'Partner Account ID should match');
        System.assertEquals(branch1.Id, fulfillment.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(customerAccount1.Id, fulfillment.dmpl__AccountId__c, 'Customer Account ID should match');
        System.assertEquals(System.today(), fulfillment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', fulfillment.dmpl__Status__c, 'Status should be Draft');
 
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine1 = FulfillmentTestDataHelpers.createInventoryFulfillmentOrderLine(fulfillment, item1, 15, 1500, storageLocation1, null, null, null, null);
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = FulfillmentTestDataHelpers.getInventoryFulfillmentOrderLine(fulfillmentOrderLine1.Id);
        System.assertNotEquals(null, fulfillmentOrderLine.Id, 'Fulfillment Order Line should be created');
        System.assertEquals(item1.Id, fulfillmentOrderLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(15, fulfillmentOrderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, fulfillmentOrderLine.dmpl__UnitCost__c, 'Unit Cost should match');
        System.assertEquals(storageLocation1.Id, fulfillmentOrderLine.dmpl__StorageLocationId__c, 'Storage Location should match');
 
        dmpl__InventoryFulfillmentAllocationLine__c fulfillmentAllocationLine1=FulfillmentTestDataHelpers.createInventoryFulfillmentAllocationLine( item1 , 15 ,fulfillment ,fulfillmentOrderLine );
       	dmpl__InventoryFulfillmentAllocationLine__c fulfillmentAllocationLine=FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(fulfillmentAllocationLine1.Id);
        System.assertNotEquals(null, fulfillmentAllocationLine.Id, 'Fulfillment Allocation Line should be created');
        System.assertEquals(item1.Id, fulfillmentAllocationLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(15, fulfillmentAllocationLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(fulfillmentOrderLine.Id, fulfillmentAllocationLine.dmpl__FulfillmentOrderLineId__c, 'Fulfillment Order Line should match');
        System.assertEquals(fulfillment.Id, fulfillmentAllocationLine.dmpl__FulfillmentOrderId__c, 'Fulfillment should match');
        
        dmpl__InventoryFulfillmentPickingLine__c fulfillmentPickingLine1 = FulfillmentTestDataHelpers.createFulfillmentPickingLine(fulfillment,item1,fulfillmentAllocationLine,storageLocation1,10,1500,null,null);
        dmpl__InventoryFulfillmentPickingLine__c fulfillmentPickingLine = FulfillmentTestDataHelpers.getFulfillmentPickingLine(fulfillmentPickingLine1.Id);
        System.assertNotEquals(null, fulfillmentPickingLine.Id, 'Fulfillment Picking Line should be created');
        System.assertEquals(item1.Id, fulfillmentPickingLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(10, fulfillmentPickingLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(10, fulfillmentPickingLine.dmpl__PickedQuantity__c, 'Picked Quantity should match');
        System.assertEquals(System.today(), fulfillmentPickingLine.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals(fulfillmentAllocationLine.Id, fulfillmentPickingLine.dmpl__FulfillmentAllocationLineId__c, 'Fulfillment Allocation Line should match');
        System.assertEquals(fulfillment.Id, fulfillmentPickingLine.dmpl__FulfillmentOrderId__c, 'Fulfillment should match');
		System.assertEquals(storageLocation1.Id, fulfillmentPickingLine.dmpl__StorageLocationId__c, 'Storage Location should match');        
       
        fulfillmentPickingLine.dmpl__Quantity__c = 8;
        update fulfillmentPickingLine;
        
        dmpl__InventoryFulfillmentPickingLine__c fulfillmentPickingLine2 = FulfillmentTestDataHelpers.getFulfillmentPickingLine(fulfillmentPickingLine.Id);
        System.assertEquals(8, fulfillmentPickingLine2.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(item1.Id, fulfillmentPickingLine2.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(1500, fulfillmentPickingLine2.dmpl__UnitCost__c, 'UnitCost should match');
        System.assertEquals(8, fulfillmentPickingLine2.dmpl__PickedQuantity__c, 'Picked Quantity should match');
        System.assertEquals(storageLocation1.Id, fulfillmentPickingLine2.dmpl__StorageLocationId__c, 'Storage Location should match');

        Test.stopTest(); 
       
    }

    @isTest
    public static void editFulfillmentpickinglineWithEnteredQuantity() {
 
        Account Partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
       
        Test.startTest();
        dmpl__InventoryFulfillment__c fulfillment1 = FulfillmentTestDataHelpers.createInventoryFulfillmentWithAllValues(Partner1,customerAccount1,branch1,null,null,Date.today(),'Draft');        
 		dmpl__InventoryFulfillment__c fulfillment=FulfillmentTestDataHelpers.getInventoryFulfillment(fulfillment1.Id);
        System.assertNotEquals(null, fulfillment.Id, 'Fulfillment should be created');
        System.assertEquals(Partner1.Id, fulfillment.dmpl__PartnerAccountId__c, 'Partner Account ID should match');
        System.assertEquals(branch1.Id, fulfillment.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(customerAccount1.Id, fulfillment.dmpl__AccountId__c, 'Customer Account ID should match');
        System.assertEquals(System.today(), fulfillment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', fulfillment.dmpl__Status__c, 'Status should be Draft');
 
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine1 = FulfillmentTestDataHelpers.createInventoryFulfillmentOrderLine(fulfillment, item1, 10, 1500, null, null, null, null, null);
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = FulfillmentTestDataHelpers.getInventoryFulfillmentOrderLine(fulfillmentOrderLine1.Id);
        System.assertNotEquals(null, fulfillmentOrderLine.Id, 'Fulfillment Order Line should be created');
        System.assertEquals(item1.Id, fulfillmentOrderLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(10, fulfillmentOrderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, fulfillmentOrderLine.dmpl__UnitCost__c, 'Unit Cost should match');
 
        dmpl__InventoryFulfillmentAllocationLine__c fullfillmentAllocationLine1=FulfillmentTestDataHelpers.createInventoryFulfillmentAllocationLine( item1 , 10 ,fulfillment ,fulfillmentOrderLine );
        dmpl__InventoryFulfillmentAllocationLine__c fullfillmentAllocationLine=FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(fullfillmentAllocationLine1.Id);
        System.assertNotEquals(null, fullfillmentAllocationLine.Id, 'Fulfillment Allocation Line should be created');
        System.assertEquals(item1.Id, fullfillmentAllocationLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(10, fullfillmentAllocationLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(10, fullfillmentAllocationLine.dmpl__AllocatedQuantity__c, 'Allocated Quantity should match');
        System.assertEquals(fulfillmentOrderLine.Id, fullfillmentAllocationLine.dmpl__FulfillmentOrderLineId__c, 'Fulfillment Order Line should match');
        System.assertEquals(fulfillment.Id, fullfillmentAllocationLine.dmpl__FulfillmentOrderId__c, 'Fulfillment should match');
        
        dmpl__InventoryFulfillmentPickingLine__c fulfillmentPickingLine1 = FulfillmentTestDataHelpers.createFulfillmentPickingLine(fulfillment,item1,fullfillmentAllocationLine,10,1500,null);
        dmpl__InventoryFulfillmentPickingLine__c fulfillmentPickingLine = FulfillmentTestDataHelpers.getFulfillmentPickingLine(fulfillmentPickingLine1.Id);
        System.assertNotEquals(null, fulfillmentPickingLine.Id, 'Fulfillment Picking Line should be created');
        System.assertEquals(item1.Id, fulfillmentPickingLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(10, fulfillmentPickingLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(fullfillmentAllocationLine.Id, fulfillmentPickingLine.dmpl__FulfillmentAllocationLineId__c, 'Fulfillment Allocation Line should match');
        System.assertEquals(fulfillment.Id, fulfillmentPickingLine.dmpl__FulfillmentOrderId__c, 'Fulfillment should match');
       
        fulfillmentPickingLine.dmpl__Quantity__c = 5;
        update fulfillmentPickingLine;
        
        dmpl__InventoryFulfillmentPickingLine__c fulfillmentPickingLine2 = FulfillmentTestDataHelpers.getFulfillmentPickingLine(fulfillmentPickingLine.Id);
        System.assertEquals(5, fulfillmentPickingLine2.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(item1.Id, fulfillmentPickingLine2.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(1500, fulfillmentPickingLine2.dmpl__UnitCost__c, 'UnitCost should match');
        System.assertEquals(fullfillmentAllocationLine.Id, fulfillmentPickingLine2.dmpl__FulfillmentAllocationLineId__c, 'Fulfillment Allocation Line should match');
        System.assertEquals(fulfillment.Id, fulfillmentPickingLine2.dmpl__FulfillmentOrderId__c, 'Fulfillment should match');
        
        Test.stopTest();
       
    }
    
     
 
    @isTest
    public static void editFulfillmentpickingLineWithSaleOrderLineReference() {
        
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        
        Test.StartTest();
        
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(customerAccount1.Id,partnerAccount1.Id,branch1.Id,null,null,false,null);
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(saleOrder.Id,item.Id,3,null);
        dmpl__SaleOrder__c saleOrder1 = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertNotEquals(null, saleOrder1.Id, 'Sale Order should be created');
        System.assertEquals(priceList1.Id, saleOrder1.dmpl__PriceListId__c, 'Account Name should match');
        System.assertEquals('Customer 1', saleOrder1.dmpl__AccountName__c, 'Account Name should match');
        System.assertEquals('Within State', saleOrder1.dmpl__TaxSupplyType__c, 'Tax Supply Type should match');
        System.assertEquals('MG Road', saleOrder1.dmpl__BillingStreet__c, 'Billing Street should match');
        System.assertEquals('Pune', saleOrder1.dmpl__BillingCity__c, 'Billing City should match');
        System.assertEquals('Maharashtra', saleOrder1.dmpl__BillingState__c, 'Billing State should match');
        System.assertEquals('India', saleOrder1.dmpl__BillingCountry__c, 'Billing Country should match');
        System.assertEquals('411001', saleOrder1.dmpl__BillingPostalCode__c, 'Billing Postal Code should match');
        
        
        dmpl__SaleOrderLine__c orderLine1 = SaleOrderDataHelper.getSaleOrderLine(saleOrder1.Id);
        System.assertEquals(1500.00, orderLine1.dmpl__UnitPrice__c,          'Unit Price should match');
        System.assertEquals(630.00,  orderLine1.dmpl__Tax1__c,               'Tax1 amount should match');
        System.assertEquals('CGST',  orderLine1.dmpl__Tax1Name__c,           'Tax1 name should match');
        System.assertEquals(14.00,   orderLine1.dmpl__Tax1Rate__c,           'Tax1 rate should match');
        System.assertEquals('CGST',  orderLine1.dmpl__Tax1Type__c,           'Tax1 type should match');
        System.assertEquals(630.00,  orderLine1.dmpl__Tax2__c,               'Tax2 amount should match');
        System.assertEquals('SGST',  orderLine1.dmpl__Tax2Name__c,           'Tax2 name should match');
        System.assertEquals(14.00,   orderLine1.dmpl__Tax2Rate__c,           'Tax2 rate should match');
        System.assertEquals('SGST',  orderLine1.dmpl__Tax2Type__c,           'Tax2 type should match');
        System.assertEquals(4500.00, orderLine1.dmpl__BaseAmount__c,         'Base Amount should match');
        System.assertEquals(0.00,    orderLine1.dmpl__NetSchemeDiscount__c,  'Net Scheme Discount should match');
        System.assertEquals(0.00,    orderLine1.dmpl__NetDiscount__c,        'Net Discount should match');
        System.assertEquals(1260.00, orderLine1.dmpl__TaxAmount__c,          'Total Tax Amount should match');
        System.assertEquals(5760.00, orderLine1.dmpl__GrossAmount__c,        'Gross Amount should match');
        
        dmpl__SaleOrder__c saleOrder2 = SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        System.assertEquals(4500.00, saleOrder2.dmpl__LineSubTotal__c,               'Line Sub Total should match');
        System.assertEquals(4500.00, saleOrder2.dmpl__TotalLineBaseAmount__c,       'Total Line Base Amount should match');
        System.assertEquals(0.00,    saleOrder2.dmpl__TotalSchemeDiscountAmount__c, 'Total Scheme Discount Amount should match');
        System.assertEquals(0.00,    saleOrder2.dmpl__TotalDiscountAmount__c,       'Total Discount Amount should match');
        System.assertEquals(1260.00, saleOrder2.dmpl__TotalLineTaxAmount__c,       'Total Line Tax Amount should match');
        System.assertEquals(1260.00, saleOrder2.dmpl__TotalTaxAmount__c,           'Total Tax Amount should match');
        System.assertEquals(5760.00, saleOrder2.dmpl__TotalLineGrossAmount__c,     'Total Line Gross Amount should match');
        System.assertEquals(5760.00, saleOrder2.dmpl__OpenAmount__c,               'Open Amount should match');
        System.assertEquals(5760.00, saleOrder2.dmpl__OutstandingAmount__c,        'Outstanding Amount should match');
        
        dmpl__InventoryFulfillment__c fulfillment1 = FulfillmentTestDataHelpers.createInventoryFulfillment(partnerAccount1,customerAccount1,branch1,null,saleOrder1);
        dmpl__InventoryFulfillment__c fulfillment=FulfillmentTestDataHelpers.getInventoryFulfillment(fulfillment1.Id);
        System.assertEquals(partnerAccount1.Id, fulfillment.dmpl__PartnerAccountId__c, 'Fulfillment must get created with partner4');
        System.assertEquals(branch1.Id, fulfillment.dmpl__BranchId__c, 'Fulfillment must get created with branch4');
        System.assertEquals(customerAccount1.Id, fulfillment.dmpl__AccountId__c, 'Fulfillment must get created with customer3');
        System.assertEquals('Draft', fulfillment.dmpl__Status__c, 'Fulfillment must get created at draft stage');
        System.assertEquals(System.today(), fulfillment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals(saleOrder2.Id, fulfillment.dmpl__SaleOrderId__c, 'Fulfillment must get created with sale order reference');
        
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine1=FulfillmentTestDataHelpers.createInventoryFulfillmentOrderLine(fulfillment,item,3,1500,null,null,null,orderLine1,null);
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = FulfillmentTestDataHelpers.getInventoryFulfillmentOrderLine(fulfillmentOrderLine1.Id);
        System.assertNotEquals(null, fulfillmentOrderLine.Id, 'Fulfillment Order Line should be created');
        System.assertEquals(item.Id,fulfillmentOrderLine.dmpl__ItemId__c,'item should match');
        System.assertEquals(3,fulfillmentOrderLine.dmpl__Quantity__c,'Quantity should match');
        System.assertEquals(1500,fulfillmentOrderLine.dmpl__UnitCost__c,'Unit Cost should match');
        
        dmpl__InventoryFulfillmentAllocationLine__c fullfillmentAllocationLine1=FulfillmentTestDataHelpers.createInventoryFulfillmentAllocationLine(item,3,1500,null,null,null,orderLine1,fulfillment,fulfillmentOrderLine);
        dmpl__InventoryFulfillmentAllocationLine__c fullfillmentAllocationLine=FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(fullfillmentAllocationLine1.Id);
        System.assertNotEquals(null, fullfillmentAllocationLine.Id, 'Fulfillment Allocation Line should be created');
        System.assertEquals(item.Id,fullfillmentAllocationLine.dmpl__ItemId__c,'Unit Cost should match');
        System.assertEquals(3,fullfillmentAllocationLine.dmpl__Quantity__c,'Quantity should match');
        System.assertEquals(1500,fullfillmentAllocationLine.dmpl__UnitCost__c,'Unit Cost should match');
        System.assertEquals(fulfillmentOrderLine.Id, fullfillmentAllocationLine.dmpl__FulfillmentOrderLineId__c, 'Fulfillment Order Line should match');
        System.assertEquals(fulfillment.Id, fullfillmentAllocationLine.dmpl__FulfillmentOrderId__c, 'Fulfillment should match');
        System.assertEquals(orderLine1.Id, fullfillmentAllocationLine.dmpl__SaleOrderLineId__c, 'Sale Order Line should match');

        dmpl__InventoryFulfillmentPickingLine__c fullfillmentPickingLine1=FulfillmentTestDataHelpers.createFulfillmentPickingLine(fulfillment,fullfillmentAllocationLine,item,1500,3,3,orderLine1);
        dmpl__InventoryFulfillmentPickingLine__c fullfillmentPickingLine=FulfillmentTestDataHelpers.getFulfillmentPickingLine(fullfillmentPickingLine1.Id);
		System.assertNotEquals(null, fullfillmentPickingLine.Id, 'Fulfillment Picking Line should be created');
        System.assertEquals(item.Id,fullfillmentPickingLine.dmpl__ItemId__c,'Unit Cost should match');
        System.assertEquals(3,fullfillmentPickingLine.dmpl__Quantity__c,'Quantity should match');
        System.assertEquals(1500,fullfillmentPickingLine.dmpl__UnitCost__c,'Unit Cost should match');
        System.assertEquals(3,fullfillmentPickingLine.dmpl__RequestedQuantity__c,'Requested Quantity should match');
        System.assertEquals(3,fullfillmentPickingLine.dmpl__PickedQuantity__c,'Picked Quantity should match');
        System.assertEquals(fullfillmentAllocationLine.Id, fullfillmentPickingLine.dmpl__FulfillmentAllocationLineId__c, 'Fulfillment Allocation Line should match');
        System.assertEquals(fulfillment.Id, fullfillmentPickingLine.dmpl__FulfillmentOrderId__c, 'Fulfillment should match');

        fullfillmentPickingLine.dmpl__Quantity__c = 3;
        fullfillmentPickingLine.dmpl__RequestedQuantity__c= 2;
        fullfillmentPickingLine.dmpl__ReturnedQuantity__c= 1;

        update fullfillmentPickingLine;
        
        dmpl__InventoryFulfillmentPickingLine__c fullfillmentPickingLine2=FulfillmentTestDataHelpers.getFulfillmentPickingLine(fullfillmentPickingLine.Id);
        System.assertEquals(3, fullfillmentPickingLine2.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(2, fullfillmentPickingLine2.dmpl__PickedQuantity__c, 'Picked Quantity should match');
        System.assertEquals(2, fullfillmentPickingLine2.dmpl__RequestedQuantity__c, 'Requested Quantity should match');
        System.assertEquals(1500,fullfillmentPickingLine2.dmpl__UnitCost__c,'Unit Cost should match');
        System.assertEquals(fullfillmentAllocationLine.Id, fullfillmentPickingLine2.dmpl__FulfillmentAllocationLineId__c, 'Fulfillment Allocation Line should match');
        System.assertEquals(fulfillment.Id, fullfillmentPickingLine2.dmpl__FulfillmentOrderId__c, 'Fulfillment should match');

        Test.stopTest();
    }
 
 

}