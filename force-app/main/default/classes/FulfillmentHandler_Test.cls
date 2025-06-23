@isTest
public class FulfillmentHandler_Test {
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
        
        dmpl__SKU__c sku1 = TestDataHelpers.createSKU('SKU 1', item1.Id, false); 
        //dmpl__SKU__c sku1 = TestDataHelpers.createSKU('SKU 1', item7.id, true);
        dmpl__SKU__c sku2 = TestDataHelpers.createSKU('SKU 2', item8.id, false);
        dmpl__SKU__c sku4 = TestDataHelpers.createSKU('SKU 4', item4.Id, false);
        dmpl__SKU__c sku3 = TestDataHelpers.createSKU('SKU 3', item3.Id, false);
        dmpl__SKU__c sku9 = TestDataHelpers.createSKU('SKU 9', item9.Id, false);
        dmpl__SKU__c sku8 = TestDataHelpers.createSKU('SKU 8', item8.Id, false);
 
        dmpl__PriceListRules__c priceListRule1 = TestDataHelpers.createPriceListRules(priceList1.id, item1.id,null,null,1500, System.today().addDays(-15),System.today()+9);
        dmpl__PriceListRules__c priceListRule3 = TestDataHelpers.createPriceListRules(priceList1.id, item3.id,null,null,2000, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule4 = TestDataHelpers.createPriceListRules(priceList1.id, item4.id,null,null,2000, System.today()-1,System.today()+9);  
        dmpl__PriceListRules__c priceListRule5 = TestDataHelpers.createPriceListRules(priceList3.id, item6.id,null,null,2000, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule7 = TestDataHelpers.createPriceListRules(priceList3.id, item5.id,null,null,1000, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule8 = TestDataHelpers.createPriceListRules(priceList1.id, item5.id,null,null,1000, System.today().addDays(-1),System.today()+9);
        dmpl__PriceListRules__c priceListRule9 = TestDataHelpers.createPriceListRules(priceList1.id, item6.id,null,null,2400, System.today()-1,System.today()+9);  
        dmpl__PriceListRules__c priceListRule10 = TestDataHelpers.createPriceListRules(priceList3.id, item1.id,null,null,1500, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule11 = TestDataHelpers.createPriceListRules(priceList3.id, item8.id,null,null,1500, System.today()-1,System.today()+9);
		dmpl__PriceListRules__c priceListRule12 = TestDataHelpers.createPriceListRules(priceList1.id, item8.id,null,null,1500, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule2 = TestDataHelpers.createPriceListRules(priceList7.id, item8.id,null,null,1500, System.today()-1,System.today()+9);

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
      //  dmpl__TaxGroupRule__c taxGroupRule28item8 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST28partner4.Id,item8.Id,null,null,null); 
        dmpl__TaxGroupRule__c taxGroupRule29Item8 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST28partner1.Id,item8.Id,null,null,null);
       
        dmpl__Resource__c resource2 = TestDataHelpers.createResource('Resource 2', partnerAccount1.Id, branch1.Id, false);
        dmpl__StorageLocation__c storageLocation1 = FulfillmentTestDataHelpers.createStorageLocation('Storage Location 1',branch1,true,'Warehouse'); 
        
        Asset asset1 = FulfillmentTestDataHelpers.createAsset('Asset 1',customerAccount1,item1);
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
    
    @isTest 
    public static void fulfillmentAllocationLineWithDiscountinuedItemPositiveEdit(){
        Account Partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item4 = TestDataHelpers.getItem('Item 4');
        dmpl__SKU__c sku4 = TestDataHelpers.getSKU('SKU 4');

        Test.startTest();
        dmpl__InventoryFulfillment__c fulfillment = FulfillmentTestDataHelpers.createInventoryFulfillment(Partner1, customerAccount1, branch1, null, null);

        System.assertNotEquals(null, fulfillment.Id, 'Fulfillment should be created');
        dmpl__InventoryFulfillment__c retrievedFulfillment = FulfillmentTestDataHelpers.getInventoryFulfillment(fulfillment.Id);
        
        System.assertEquals(Partner1.Id, retrievedFulfillment.dmpl__PartnerAccountId__c, 'Partner Account ID should match');
        System.assertEquals(branch1.Id, retrievedFulfillment.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(customerAccount1.Id, retrievedFulfillment.dmpl__AccountId__c, 'Customer Account ID should match');
        System.assertEquals(System.today(), retrievedFulfillment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', retrievedFulfillment.dmpl__Status__c, 'Status should be Draft');

        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = FulfillmentTestDataHelpers.createInventoryFulfillmentOrderLine(fulfillment, item4, 10, 2400, null, null, sku4, null, null);
        System.assertNotEquals(null, fulfillmentOrderLine.Id, 'Fulfillment Order Line should be created');

        dmpl__InventoryFulfillmentOrderLine__c retrievedFulfillmentOrderLine = FulfillmentTestDataHelpers.getInventoryFulfillmentOrderLine(fulfillmentOrderLine.Id);
        System.assertEquals(item4.Id, retrievedFulfillmentOrderLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(10, retrievedFulfillmentOrderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(2400, retrievedFulfillmentOrderLine.dmpl__UnitCost__c, 'Unit Cost should match');
        
        dmpl__InventoryFulfillmentAllocationLine__c fullfillmentAllocationLine = FulfillmentTestDataHelpers.createInventoryFulfillmentAllocationLine(item4, 10, 2400, sku4, null, fulfillment, fulfillmentOrderLine, null);
        System.assertNotEquals(null, fullfillmentAllocationLine.Id, 'Fulfillment Allocation Line should be created');

        dmpl__InventoryFulfillmentAllocationLine__c retrievedFullfillmentAllocationLine = FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(fullfillmentAllocationLine.Id);
        System.assertEquals(item4.Id, retrievedFullfillmentAllocationLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(10, retrievedFullfillmentAllocationLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(10, retrievedFullfillmentAllocationLine.dmpl__AllocatedQuantity__c, 'Allocated Quantity should match');

        fullfillmentAllocationLine.dmpl__Quantity__c = 5;
        update fullfillmentAllocationLine;

        dmpl__InventoryFulfillmentAllocationLine__c updatedFullfillmentAllocationLine = FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(fullfillmentAllocationLine.Id);
        System.assertEquals(item4.Id, updatedFullfillmentAllocationLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(5, updatedFullfillmentAllocationLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(5, updatedFullfillmentAllocationLine.dmpl__AllocatedQuantity__c, 'Allocated Quantity should match');
        Test.stopTest();
    }
    
    @isTest 
    public static void fulfillmentAllocationLineWithRemovingRequiredSKUNegativeEdit(){
        Account Partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item9 = TestDataHelpers.getItem('Item 9');
        dmpl__SKU__c sku3 = TestDataHelpers.getSKU('SKU 9');

        Test.startTest();

        dmpl__InventoryFulfillment__c fulfillment = FulfillmentTestDataHelpers.createInventoryFulfillment(Partner1,customerAccount1,branch1,null,null);
        System.assertNotEquals(null, fulfillment.Id, 'Fulfillment should be created');
        
        dmpl__InventoryFulfillment__c retrievedFulfillment = FulfillmentTestDataHelpers.getInventoryFulfillment(fulfillment.Id);
        System.assertEquals(Partner1.Id, retrievedFulfillment.dmpl__PartnerAccountId__c, 'Partner Account ID should match');
        System.assertEquals(branch1.Id, retrievedFulfillment.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(customerAccount1.Id, retrievedFulfillment.dmpl__AccountId__c, 'Customer Account ID should match');
        System.assertEquals(System.today(), retrievedFulfillment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', retrievedFulfillment.dmpl__Status__c, 'Status should be Draft');

        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = FulfillmentTestDataHelpers.createInventoryFulfillmentOrderLine(fulfillment, item9, 1, 1500, null, null, sku3, null, null);
        System.assertNotEquals(null, fulfillmentOrderLine.Id, 'Fulfillment Order Line should be created');
        
        dmpl__InventoryFulfillmentOrderLine__c retrievedFulfillmentOrderLine = FulfillmentTestDataHelpers.getInventoryFulfillmentOrderLine(fulfillmentOrderLine.Id);
        System.assertEquals(item9.Id, retrievedFulfillmentOrderLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(1, retrievedFulfillmentOrderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, retrievedFulfillmentOrderLine.dmpl__UnitCost__c, 'Unit Cost should match');
        System.assertEquals(sku3.Id, retrievedFulfillmentOrderLine.dmpl__SKUId__c, 'SKU ID should match');

        dmpl__InventoryFulfillmentAllocationLine__c fullfillmentAllocationLine = FulfillmentTestDataHelpers.createInventoryFulfillmentAllocationLine(item9 , 1, 1500, sku3, null, fulfillment, fulfillmentOrderLine, null);
        System.assertNotEquals(null, fullfillmentAllocationLine.Id, 'Fulfillment Allocation Line should be created');
        
        dmpl__InventoryFulfillmentAllocationLine__c retrievedFullfillmentAllocationLine = FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(fullfillmentAllocationLine.Id);
        System.assertEquals(item9.Id, retrievedFullfillmentAllocationLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(1, retrievedFullfillmentAllocationLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, retrievedFullfillmentAllocationLine.dmpl__UnitCost__c, 'Unit Cost should match');
        System.assertEquals(1, retrievedFullfillmentAllocationLine.dmpl__AllocatedQuantity__c, 'Allocated Quantity should match');
        System.assertEquals(fulfillment.Id, retrievedFullfillmentAllocationLine.dmpl__FulfillmentOrderId__c, 'Fulfillment ID should match');
        System.assertEquals(fulfillmentOrderLine.Id, retrievedFullfillmentAllocationLine.dmpl__FulfillmentOrderLineId__c, 'Fulfillment Order Line ID should match');

        try {
            fullfillmentAllocationLine.dmpl__SKUId__c = null; 
            update fullfillmentAllocationLine;
            System.assert(false, 'Expected an exception due to removing required SKU');
        } catch (DmlException e) {
            String errorMsg = e.getMessage().toLowerCase();
            System.assert(errorMsg.contains('dmpl__skuid__c'), 'Expected validation exception related to dmpl__SKUId__c. Actual message: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest 
    public static void fulfillmentAllocationLineWithNoRequiredSKUPositiveEdit(){
        Account Partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku1 = TestDataHelpers.getSKU('SKU 1');

        Test.startTest();

        dmpl__InventoryFulfillment__c fulfillment = FulfillmentTestDataHelpers.createInventoryFulfillment(Partner1, customerAccount1, branch1, null, null);
        System.assertNotEquals(null, fulfillment.Id, 'Fulfillment should be created');
        
        dmpl__InventoryFulfillment__c retrievedFulfillment = FulfillmentTestDataHelpers.getInventoryFulfillment(fulfillment.Id);
        System.assertEquals(Partner1.Id, retrievedFulfillment.dmpl__PartnerAccountId__c, 'Partner Account ID should match');
        System.assertEquals(branch1.Id, retrievedFulfillment.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(customerAccount1.Id, retrievedFulfillment.dmpl__AccountId__c, 'Customer Account ID should match');
        System.assertEquals(System.today(), retrievedFulfillment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', retrievedFulfillment.dmpl__Status__c, 'Status should be Draft');

        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = FulfillmentTestDataHelpers.createInventoryFulfillmentOrderLine(fulfillment, item1, 10, 1500, null, null, sku1, null, null);
        System.assertNotEquals(null, fulfillmentOrderLine.Id, 'Fulfillment Order Line should be created');
        
        dmpl__InventoryFulfillmentOrderLine__c retrievedFulfillmentOrderLine = FulfillmentTestDataHelpers.getInventoryFulfillmentOrderLine(fulfillmentOrderLine.Id);
        System.assertEquals(item1.Id, retrievedFulfillmentOrderLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(10, retrievedFulfillmentOrderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, retrievedFulfillmentOrderLine.dmpl__UnitCost__c, 'Unit Cost should match');

        dmpl__InventoryFulfillmentAllocationLine__c fullfillmentAllocationLine = FulfillmentTestDataHelpers.createInventoryFulfillmentAllocationLine(item1, 10, 1500, sku1, null, fulfillment, fulfillmentOrderLine, null);
        System.assertNotEquals(null, fullfillmentAllocationLine.Id, 'Fulfillment Allocation Line should be created');
        
        dmpl__InventoryFulfillmentAllocationLine__c retrievedFullfillmentAllocationLine = FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(fullfillmentAllocationLine.Id);
        System.assertEquals(item1.Id, retrievedFullfillmentAllocationLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(10, retrievedFullfillmentAllocationLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, retrievedFullfillmentAllocationLine.dmpl__UnitCost__c, 'Unit Cost should match');
        System.assertEquals(10, retrievedFullfillmentAllocationLine.dmpl__AllocatedQuantity__c, 'Allocated Quantity should match');

        fullfillmentAllocationLine.dmpl__Quantity__c = 3;
        update fullfillmentAllocationLine;
        
        dmpl__InventoryFulfillmentAllocationLine__c updatedFullfillmentAllocationLine = FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(fullfillmentAllocationLine.Id);
        System.assertEquals(3, updatedFullfillmentAllocationLine.dmpl__Quantity__c, 'Quantity should be updated to 3');
        System.assertEquals(item1.Id, updatedFullfillmentAllocationLine.dmpl__ItemId__c, 'Item ID should remain the same');
        System.assertEquals(1500, updatedFullfillmentAllocationLine.dmpl__UnitCost__c, 'Unit Cost should remain the same');
        
        Test.stopTest();
    }
    
    @isTest 
    public static void fulfillmentAllocationLineWithStorageLocationPositiveEdit(){
        Account Partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__StorageLocation__c storageLocation1 = FulfillmentTestDataHelpers.getStorageLocation('Storage Location 1');

        Test.startTest();

        dmpl__InventoryFulfillment__c fulfillment = FulfillmentTestDataHelpers.createInventoryFulfillment(Partner1, customerAccount1, branch1, null, null);
        System.assertNotEquals(null, fulfillment.Id, 'Fulfillment should be created');
        
        dmpl__InventoryFulfillment__c retrievedFulfillment = FulfillmentTestDataHelpers.getInventoryFulfillment(fulfillment.Id);
        System.assertEquals(Partner1.Id, retrievedFulfillment.dmpl__PartnerAccountId__c, 'Partner Account ID should match');
        System.assertEquals(branch1.Id, retrievedFulfillment.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(customerAccount1.Id, retrievedFulfillment.dmpl__AccountId__c, 'Customer Account ID should match');
        System.assertEquals(System.today(), retrievedFulfillment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', retrievedFulfillment.dmpl__Status__c, 'Status should be Draft');

        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = FulfillmentTestDataHelpers.createInventoryFulfillmentOrderLine(fulfillment, item1, 5, 1500, storageLocation1, null, null, null, null);
        System.assertNotEquals(null, fulfillmentOrderLine.Id, 'Fulfillment Order Line should be created');
        
        dmpl__InventoryFulfillmentOrderLine__c retrievedFulfillmentOrderLine = FulfillmentTestDataHelpers.getInventoryFulfillmentOrderLine(fulfillmentOrderLine.Id);
        System.assertEquals(item1.Id, retrievedFulfillmentOrderLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(5, retrievedFulfillmentOrderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, retrievedFulfillmentOrderLine.dmpl__UnitCost__c, 'Unit Cost should match');
        System.assertEquals(storageLocation1.Id, retrievedFulfillmentOrderLine.dmpl__StorageLocationId__c, 'Storage Location ID should match');
        
        dmpl__InventoryFulfillmentAllocationLine__c fullfillmentAllocationLine = FulfillmentTestDataHelpers.createInventoryFulfillmentAllocationLine(item1, 5, 1500, null, null, fulfillment, fulfillmentOrderLine, storageLocation1);
        System.assertNotEquals(null, fullfillmentAllocationLine.Id, 'Fulfillment Allocation Line should be created');
        
        dmpl__InventoryFulfillmentAllocationLine__c retrievedFullfillmentAllocationLine = FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(fullfillmentAllocationLine.Id);
        System.assertEquals(item1.Id, retrievedFullfillmentAllocationLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(5, retrievedFullfillmentAllocationLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(storageLocation1.Id, retrievedFullfillmentAllocationLine.dmpl__StorageLocationId__c, 'Storage Location ID should match');
        System.assertEquals(1500, retrievedFullfillmentAllocationLine.dmpl__UnitCost__c, 'Unit Cost should match');

        fullfillmentAllocationLine.dmpl__Quantity__c = 4;
        update fullfillmentAllocationLine;
        
        dmpl__InventoryFulfillmentAllocationLine__c updatedFullfillmentAllocationLine = FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(fullfillmentAllocationLine.Id);
        System.assertEquals(4, updatedFullfillmentAllocationLine.dmpl__Quantity__c, 'Quantity should be updated to 4');
        System.assertEquals(storageLocation1.Id, updatedFullfillmentAllocationLine.dmpl__StorageLocationId__c, 'Storage Location ID should remain the same');
        System.assertEquals(1500, updatedFullfillmentAllocationLine.dmpl__UnitCost__c, 'Unit Cost should remain the same');
        System.assertEquals(item1.Id, updatedFullfillmentAllocationLine.dmpl__ItemId__c, 'Item ID should remain the same');

        Test.stopTest();
    }
    
    @isTest 
    public static void fulfillmentAllocationLineWithEnteredQuantityPositiveEdit(){
        Account Partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item8 = TestDataHelpers.getItem('Item 8');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 8');

        Test.startTest();

        dmpl__InventoryFulfillment__c fulfillment = FulfillmentTestDataHelpers.createInventoryFulfillment(Partner1, customerAccount1, branch1, null, null);
        System.assertNotEquals(null, fulfillment.Id, 'Fulfillment should be created');
        
        dmpl__InventoryFulfillment__c retrievedFulfillment = FulfillmentTestDataHelpers.getInventoryFulfillment(fulfillment.Id);
        System.assertEquals(Partner1.Id, retrievedFulfillment.dmpl__PartnerAccountId__c, 'Partner Account ID should match');
        System.assertEquals(branch1.Id, retrievedFulfillment.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(customerAccount1.Id, retrievedFulfillment.dmpl__AccountId__c, 'Customer Account ID should match');
        System.assertEquals(System.today(), retrievedFulfillment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', retrievedFulfillment.dmpl__Status__c, 'Status should be Draft');

        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = FulfillmentTestDataHelpers.createInventoryFulfillmentOrderLine(fulfillment, item8, 17, 1500, null, null, sku, null, null);
        System.assertNotEquals(null, fulfillmentOrderLine.Id, 'Fulfillment Order Line should be created');
        
        dmpl__InventoryFulfillmentOrderLine__c retrievedFulfillmentOrderLine = FulfillmentTestDataHelpers.getInventoryFulfillmentOrderLine(fulfillmentOrderLine.Id);
        System.assertEquals(item8.Id, retrievedFulfillmentOrderLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(17, retrievedFulfillmentOrderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, retrievedFulfillmentOrderLine.dmpl__UnitCost__c, 'Unit Cost should match');
        System.assertEquals(fulfillment.Id, retrievedFulfillmentOrderLine.dmpl__FulfillmentId__c, 'Fulfillment ID should match');

        dmpl__InventoryFulfillmentAllocationLine__c fullfillmentAllocationLine = FulfillmentTestDataHelpers.createInventoryFulfillmentAllocationLine(item8, 17, 1500, null, sku, null, fulfillment, fulfillmentOrderLine);
        System.assertNotEquals(null, fullfillmentAllocationLine.Id, 'Fulfillment Allocation Line should be created');
        
        dmpl__InventoryFulfillmentAllocationLine__c retrievedFullfillmentAllocationLine = FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(fullfillmentAllocationLine.Id);
        System.assertEquals(item8.Id, retrievedFullfillmentAllocationLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(17, retrievedFullfillmentAllocationLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, retrievedFullfillmentAllocationLine.dmpl__UnitCost__c, 'Unit Cost should match');
        System.assertEquals(17, retrievedFullfillmentAllocationLine.dmpl__AllocatedQuantity__c, 'Allocated Quantity should match');
        System.assertEquals(17, retrievedFullfillmentAllocationLine.dmpl__EligibleReturnQuantity__c, 'Eligible Return Quantity should match');
        System.assertEquals(fulfillment.Id, retrievedFullfillmentAllocationLine.dmpl__FulfillmentOrderId__c, 'Fulfillment ID should match');

        fullfillmentAllocationLine.dmpl__Quantity__c = 10;
        update fullfillmentAllocationLine;
        
        dmpl__InventoryFulfillmentAllocationLine__c updatedFullfillmentAllocationLine = FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(fullfillmentAllocationLine.Id);
        System.assertEquals(10, updatedFullfillmentAllocationLine.dmpl__Quantity__c, 'Quantity should be updated to 10');
        System.assertEquals(item8.Id, updatedFullfillmentAllocationLine.dmpl__ItemId__c, 'Item ID should remain the same');
        System.assertEquals(1500, updatedFullfillmentAllocationLine.dmpl__UnitCost__c, 'Unit Cost should remain the same');
        System.assertEquals(10, updatedFullfillmentAllocationLine.dmpl__AllocatedQuantity__c, 'Allocated Quantity should be updated to 10');
        System.assertEquals(fulfillment.Id, updatedFullfillmentAllocationLine.dmpl__FulfillmentOrderId__c, 'Fulfillment ID should remain the same');
        System.assertEquals(10, updatedFullfillmentAllocationLine.dmpl__EligibleReturnQuantity__c, 'Eligible Return Quantity should be updated to 10');

        Test.stopTest();
    }
    @isTest 
    public static void fulfillmentAllocationLineWithSaleOrderLineReferencePositiveEdit(){
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

        fullfillmentAllocationLine1.dmpl__Quantity__c = 3;
        update fullfillmentAllocationLine1;
        
        dmpl__InventoryFulfillmentAllocationLine__c updatedAllocationLine = FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(fullfillmentAllocationLine1.Id);
        System.assertEquals(3, updatedAllocationLine.dmpl__AllocatedQuantity__c, 'Allocated Quantity should be 3');
        System.assertEquals(3, updatedAllocationLine.dmpl__EligibleReturnQuantity__c, 'Eligible Return Quantity should be 3');
        System.assertEquals(3, updatedAllocationLine.dmpl__PendingDeliveryQuantity__c, 'Pending Delivery Quantity should be 3');
        System.assertEquals(3, updatedAllocationLine.dmpl__PendingInvoiceQuantity__c, 'Pending Invoice Quantity should be 3');
        System.assertEquals(3, updatedAllocationLine.dmpl__PendingPickingQuantity__c, 'Pending Picking Quantity should be 3');
        System.assertEquals(3, updatedAllocationLine.dmpl__Quantity__c, 'Quantity should be 3');
        System.assertEquals(1500, updatedAllocationLine.dmpl__UnitCost__c, 'Unit Cost should be 1500');
        System.assertEquals(saleOrderLine.Id, updatedAllocationLine.dmpl__SaleOrderLineId__c, 'Sale Order Line ID should match');
        
        Test.stopTest();
    }
    
    @isTest 
    public static void fulfillmentAllocationLineWithRepairOrderLineReferencePositiveEdit(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Asset asset1 = FulfillmentTestDataHelpers.getAsset('Asset 1');
        dmpl__Item__c item8 = TestDataHelpers.getItem('Item 8');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 8');

        Test.startTest();
        dmpl__RepairOrder__c repairOrder = FulfillmentTestDataHelpers.createRepairOrder(partner1, branch1, customerAccount1, asset1, 1000);

        System.assertNotEquals(null, repairOrder.Id, 'Repair Order should be created');
        dmpl__RepairOrder__c retrievedRepairOrder = FulfillmentTestDataHelpers.getRepairOrder(repairOrder.Id);
        System.assertEquals(partner1.Id, retrievedRepairOrder.dmpl__PartnerAccountId__c, 'Partner Account ID should match');
        System.assertEquals(branch1.Id, retrievedRepairOrder.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(customerAccount1.Id, retrievedRepairOrder.dmpl__AccountId__c, 'Customer Account ID should match');
        System.assertEquals(asset1.Id, retrievedRepairOrder.dmpl__AssetId__c, 'Asset ID should match');
        System.assertEquals(Date.today(), retrievedRepairOrder.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', retrievedRepairOrder.dmpl__Status__c, 'Status should be Draft');

        dmpl__RepairOrderLine__c repairOrderLine = FulfillmentTestDataHelpers.createRepairOrderLine(repairOrder, item8, 10, 999);

        System.assertNotEquals(null, repairOrderLine.Id, 'Repair Order Line should be created');
        dmpl__RepairOrderLine__c retrievedRepairOrderLine = FulfillmentTestDataHelpers.getRepairOrderLine(repairOrderLine.Id);
        System.assertEquals(item8.Id, retrievedRepairOrderLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(10, retrievedRepairOrderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(partner1.Id, retrievedRepairOrderLine.dmpl__PartnerAccountId__c, 'Partner Account ID should match');
        System.assertEquals(branch1.Id, retrievedRepairOrderLine.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(9990, retrievedRepairOrderLine.dmpl__BaseAmount__c, 'Base Amount should match');
        System.assertEquals(repairOrder.Id, retrievedRepairOrderLine.dmpl__RepairOrderId__c, 'Repair Order ID should match');
        System.assertEquals(9990, retrievedRepairOrderLine.dmpl__GrossAmount__c, 'Gross Amount should match');

        dmpl__InventoryFulfillment__c fulfillment = FulfillmentTestDataHelpers.createInventoryFulfillment(partner1, customerAccount1, branch1, repairOrder, null);

        System.assertNotEquals(null, fulfillment.Id, 'Fulfillment should be created');
        dmpl__InventoryFulfillment__c retrievedFulfillment = FulfillmentTestDataHelpers.getInventoryFulfillment(fulfillment.Id);
        System.assertEquals(partner1.Id, retrievedFulfillment.dmpl__PartnerAccountId__c, 'Partner Account ID should match');
        System.assertEquals(branch1.Id, retrievedFulfillment.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(customerAccount1.Id, retrievedFulfillment.dmpl__AccountId__c, 'Customer Account ID should match');
        System.assertEquals(Date.today(), retrievedFulfillment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', retrievedFulfillment.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(repairOrder.Id, retrievedFulfillment.dmpl__RepairOrderId__c, 'Repair Order ID should match');

        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = FulfillmentTestDataHelpers.createInventoryFulfillmentOrderLine(fulfillment, item8, 17, 999, null, null, sku, null, repairOrderLine);
        System.assertNotEquals(null, fulfillmentOrderLine.Id, 'Fulfillment Order Line should be created');
        dmpl__InventoryFulfillmentOrderLine__c retrievedFulfillmentOrderLine = FulfillmentTestDataHelpers.getInventoryFulfillmentOrderLine(fulfillmentOrderLine.Id);
        System.assertEquals(item8.Id, retrievedFulfillmentOrderLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(17, retrievedFulfillmentOrderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(999, retrievedFulfillmentOrderLine.dmpl__UnitCost__c, 'Unit Cost should match');
        System.assertEquals(repairOrderLine.Id, retrievedFulfillmentOrderLine.dmpl__RepairOrderLineId__c, 'Repair Order Line ID should match');
        System.assertEquals(17, retrievedFulfillmentOrderLine.dmpl__PendingAllocationQuantity__c, 'Pending Allocation Quantity should match');

        dmpl__InventoryFulfillmentAllocationLine__c allocationLine = FulfillmentTestDataHelpers.createInventoryFulfillmentAllocationLine(item8, 10, sku, 999, fulfillment, fulfillmentOrderLine, repairOrderLine);
        System.assertNotEquals(null, allocationLine.Id, 'Fulfillment Allocation Line should be created');
        dmpl__InventoryFulfillmentAllocationLine__c retrievedAllocationLine = FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(allocationLine.Id);
        System.assertEquals(item8.Id, retrievedAllocationLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(10, retrievedAllocationLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(999, retrievedAllocationLine.dmpl__UnitCost__c, 'Unit Cost should match');
        System.assertEquals(fulfillment.Id, retrievedAllocationLine.dmpl__FulfillmentOrderId__c, 'Fulfillment Order ID should match');
        System.assertEquals(fulfillmentOrderLine.Id, retrievedAllocationLine.dmpl__FulfillmentOrderLineId__c, 'Fulfillment Order Line ID should match');
        System.assertEquals(repairOrderLine.Id, retrievedAllocationLine.dmpl__RepairOrderLineId__c, 'Repair Order Line ID should match');

        allocationLine.dmpl__Quantity__c = 8;
        update allocationLine;
        
        dmpl__InventoryFulfillmentAllocationLine__c updatedAllocationLine = FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(allocationLine.Id);
        System.assertEquals(8, updatedAllocationLine.dmpl__Quantity__c, 'Quantity should be updated to 8');
        System.assertEquals(item8.Id, updatedAllocationLine.dmpl__ItemId__c, 'Item ID should remain the same');
        System.assertEquals(999, updatedAllocationLine.dmpl__UnitCost__c, 'Unit Cost should remain the same');
        System.assertEquals(fulfillment.Id, updatedAllocationLine.dmpl__FulfillmentOrderId__c, 'Fulfillment Order ID should remain the same');
        System.assertEquals(fulfillmentOrderLine.Id, updatedAllocationLine.dmpl__FulfillmentOrderLineId__c, 'Fulfillment Order Line ID should remain the same');
        System.assertEquals(repairOrderLine.Id, updatedAllocationLine.dmpl__RepairOrderLineId__c, 'Repair Order Line ID should remain the same');
        
        Test.stopTest();
    }
    
    @isTest
    public static void fulfillmentAllocationLineWithNoItemLotPositiveEdit(){
        Account Partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku1 = TestDataHelpers.getSKU('SKU 1');
 
        Test.startTest();
        dmpl__InventoryFulfillment__c fulfillment = FulfillmentTestDataHelpers.createInventoryFulfillment(Partner1, customerAccount1, branch1, null, null);
        System.assertNotEquals(null, fulfillment.Id, 'Fulfillment should be created');
        dmpl__InventoryFulfillment__c retrievedFulfillment = FulfillmentTestDataHelpers.getInventoryFulfillment(fulfillment.Id);
        System.assertEquals(Partner1.Id, retrievedFulfillment.dmpl__PartnerAccountId__c, 'Partner Account ID should match');
        System.assertEquals(branch1.Id, retrievedFulfillment.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(customerAccount1.Id, retrievedFulfillment.dmpl__AccountId__c, 'Customer Account ID should match');
        System.assertEquals(System.today(), retrievedFulfillment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', retrievedFulfillment.dmpl__Status__c, 'Status should be Draft');
       
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = FulfillmentTestDataHelpers.createInventoryFulfillmentOrderLine(fulfillment, item1, 10, 1500, null, null, sku1, null, null);
        System.assertNotEquals(null, fulfillmentOrderLine.Id, 'Fulfillment Order Line should be created');
        dmpl__InventoryFulfillmentOrderLine__c retrievedFulfillmentOrderLine = FulfillmentTestDataHelpers.getInventoryFulfillmentOrderLine(fulfillmentOrderLine.Id);
        System.assertEquals(item1.Id, retrievedFulfillmentOrderLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(10, retrievedFulfillmentOrderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, retrievedFulfillmentOrderLine.dmpl__UnitCost__c, 'Unit Cost should match');
 
        dmpl__InventoryFulfillmentAllocationLine__c fullfillmentAllocationLine = FulfillmentTestDataHelpers.createInventoryFulfillmentAllocationLine(item1, 10, 1500, null, sku1, null, fulfillment, fulfillmentOrderLine);
        System.assertNotEquals(null, fullfillmentAllocationLine.Id, 'Fulfillment Allocation Line should be created');
        dmpl__InventoryFulfillmentAllocationLine__c retrievedFullfillmentAllocationLine = FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(fullfillmentAllocationLine.Id);
        System.assertEquals(item1.Id, retrievedFullfillmentAllocationLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(10, retrievedFullfillmentAllocationLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, retrievedFullfillmentAllocationLine.dmpl__UnitCost__c, 'Unit Cost should match');
 
        fullfillmentAllocationLine.dmpl__Quantity__c = 9;
        update fullfillmentAllocationLine;
       
        dmpl__InventoryFulfillmentAllocationLine__c updatedFullfillmentAllocationLine = FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(fullfillmentAllocationLine.Id);
        System.assertEquals(9, updatedFullfillmentAllocationLine.dmpl__Quantity__c, 'Quantity should be updated to 9');
        System.assertEquals(item1.Id, updatedFullfillmentAllocationLine.dmpl__ItemId__c, 'Item ID should remain the same');
        System.assertEquals(1500, updatedFullfillmentAllocationLine.dmpl__UnitCost__c, 'Unit Cost should remain the same');
 
        Test.stopTest();
    }
    @isTest
    public static void fulfillmentAllocationLineWithZeroQuantityNegativeNew(){
        Account Partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku1 = TestDataHelpers.getSKU('SKU 1');
       
        Test.startTest();
        dmpl__InventoryFulfillment__c fulfillment = FulfillmentTestDataHelpers.createInventoryFulfillment(Partner1, customerAccount1, branch1, null, null);
        System.assertNotEquals(null, fulfillment.Id, 'Fulfillment should be created');
        dmpl__InventoryFulfillment__c retrievedFulfillment = FulfillmentTestDataHelpers.getInventoryFulfillment(fulfillment.Id);
        System.assertEquals(Partner1.Id, retrievedFulfillment.dmpl__PartnerAccountId__c, 'Partner Account ID should match');
        System.assertEquals(branch1.Id, retrievedFulfillment.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(customerAccount1.Id, retrievedFulfillment.dmpl__AccountId__c, 'Customer Account ID should match');
        System.assertEquals(System.today(), retrievedFulfillment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', retrievedFulfillment.dmpl__Status__c, 'Status should be Draft');
       
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = FulfillmentTestDataHelpers.createInventoryFulfillmentOrderLine(fulfillment, item1, 5, 1500, null, null, sku1, null, null);
        System.assertNotEquals(null, fulfillmentOrderLine.Id, 'Fulfillment Order Line should be created');
        dmpl__InventoryFulfillmentOrderLine__c retrievedFulfillmentOrderLine = FulfillmentTestDataHelpers.getInventoryFulfillmentOrderLine(fulfillmentOrderLine.Id);
        System.assertEquals(item1.Id, retrievedFulfillmentOrderLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(5, retrievedFulfillmentOrderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, retrievedFulfillmentOrderLine.dmpl__UnitCost__c, 'Unit Cost should match');
 
        try {
            dmpl__InventoryFulfillmentAllocationLine__c fullfillmentAllocationLine =
                FulfillmentTestDataHelpers.createInventoryFulfillmentAllocationLine(
                    item1, 0, 1500, null, sku1, null, fulfillment, fulfillmentOrderLine
                );
            System.assert(false, 'Expected exception was not thrown');
        } catch (Exception e) {
            String errorMsg = e.getMessage().toLowerCase();
 
            Boolean correctExceptionThrown = errorMsg.contains('dmpl__quantity__c') &&
                                            errorMsg.contains('expects') &&
                                            errorMsg.contains('postive');
 
            System.assert(
                correctExceptionThrown,
                'Expected validation exception related to dmpl__Quantity__c requiring positive decimal. Actual message: ' + e.getMessage()
            );
        }
       
        Test.stopTest();
    }
    @isTest
    public static void fulfillmentAllocationLineWithZeroQuantityNegativeEdit() {
        Account Partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku1 = TestDataHelpers.getSKU('SKU 1');
 
        Test.startTest();
 
        dmpl__InventoryFulfillment__c fulfillment = FulfillmentTestDataHelpers.createInventoryFulfillment(Partner1, customerAccount1, branch1, null, null);
        System.assertNotEquals(null, fulfillment.Id, 'Fulfillment should be created');
        dmpl__InventoryFulfillment__c retrievedFulfillment = FulfillmentTestDataHelpers.getInventoryFulfillment(fulfillment.Id);
        System.assertEquals(Partner1.Id, retrievedFulfillment.dmpl__PartnerAccountId__c, 'Partner Account ID should match');
        System.assertEquals(branch1.Id, retrievedFulfillment.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(customerAccount1.Id, retrievedFulfillment.dmpl__AccountId__c, 'Customer Account ID should match');
        System.assertEquals(System.today(), retrievedFulfillment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', retrievedFulfillment.dmpl__Status__c, 'Status should be Draft');
 
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = FulfillmentTestDataHelpers.createInventoryFulfillmentOrderLine(fulfillment, item1, 15, 1500, null, null, sku1, null, null);
        System.assertNotEquals(null, fulfillmentOrderLine.Id, 'Fulfillment Order Line should be created');
        dmpl__InventoryFulfillmentOrderLine__c retrievedFulfillmentOrderLine = FulfillmentTestDataHelpers.getInventoryFulfillmentOrderLine(fulfillmentOrderLine.Id);
        System.assertEquals(item1.Id, retrievedFulfillmentOrderLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(15, retrievedFulfillmentOrderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, retrievedFulfillmentOrderLine.dmpl__UnitCost__c, 'Unit Cost should match');
 
        dmpl__InventoryFulfillmentAllocationLine__c fullfillmentAllocationLine = FulfillmentTestDataHelpers.createInventoryFulfillmentAllocationLine(item1 , 10 , 1500 , null, sku1 , null, fulfillment , fulfillmentOrderLine);
        System.assertNotEquals(null, fullfillmentAllocationLine.Id, 'Fulfillment Allocation Line should be created');
        dmpl__InventoryFulfillmentAllocationLine__c retrievedFullfillmentAllocationLine = FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(fullfillmentAllocationLine.Id);
        System.assertEquals(item1.Id, retrievedFullfillmentAllocationLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(10, retrievedFullfillmentAllocationLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, retrievedFullfillmentAllocationLine.dmpl__UnitCost__c, 'Unit Cost should match');
        System.assertEquals(fulfillment.Id, retrievedFullfillmentAllocationLine.dmpl__FulfillmentOrderId__c, 'Fulfillment ID should match');
        System.assertEquals(fulfillmentOrderLine.Id, retrievedFullfillmentAllocationLine.dmpl__FulfillmentOrderLineId__c, 'Fulfillment Order Line ID should match');
       
        try {
            fullfillmentAllocationLine.dmpl__Quantity__c = 0;
            update fullfillmentAllocationLine;
            System.assert(false, 'Expected exception was not thrown');
        } catch (Exception e) {
            String errorMsg = e.getMessage().toLowerCase();
            System.debug('Error message: ' + e.getMessage());
 
            Boolean correctExceptionThrown = errorMsg.contains('dmpl__quantity__c') &&
                                            errorMsg.contains('expects') &&
                                            errorMsg.contains('postive decimals');
 
            System.assert(correctExceptionThrown,
                'Expected validation exception related to dmpl__Quantity__c requiring positive decimal. Actual message: ' + e.getMessage());
        }
        Test.stopTest();
 
    }
    @isTest
    public static void fulfillmentAllocationLineWithFulfillmentOrderLineReferencePositiveEdit() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku1 = TestDataHelpers.getSKU('SKU 1');
       
        Test.startTest();
        dmpl__InventoryFulfillment__c fulfillment = FulfillmentTestDataHelpers.createInventoryFulfillment(partner1, customerAccount1, branch1, null, null);
        System.assertNotEquals(null, fulfillment.Id, 'Fulfillment should be created');
        dmpl__InventoryFulfillment__c retrievedFulfillment = FulfillmentTestDataHelpers.getInventoryFulfillment(fulfillment.Id);
        System.assertEquals(partner1.Id, retrievedFulfillment.dmpl__PartnerAccountId__c, 'Partner Account ID should match');
        System.assertEquals(branch1.Id, retrievedFulfillment.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(customerAccount1.Id, retrievedFulfillment.dmpl__AccountId__c, 'Customer Account ID should match');
        System.assertEquals(System.today(), retrievedFulfillment.dmpl__DocumentDate__c, 'Document Date should match');
        System.assertEquals('Draft', retrievedFulfillment.dmpl__Status__c, 'Status should be Draft');
       
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = FulfillmentTestDataHelpers.createInventoryFulfillmentOrderLine(fulfillment, item1, 10, 1500, null, null, sku1, null, null);
        System.assertNotEquals(null, fulfillmentOrderLine.Id, 'Fulfillment Order Line should be created');
        dmpl__InventoryFulfillmentOrderLine__c retrievedFulfillmentOrderLine = FulfillmentTestDataHelpers.getInventoryFulfillmentOrderLine(fulfillmentOrderLine.Id);
        System.assertEquals(item1.Id, retrievedFulfillmentOrderLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(10, retrievedFulfillmentOrderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, retrievedFulfillmentOrderLine.dmpl__UnitCost__c, 'Unit Cost should match');
       
        dmpl__InventoryFulfillmentAllocationLine__c fullfillmentAllocationLine = FulfillmentTestDataHelpers.createInventoryFulfillmentAllocationLine(item1, 10, 1500, null, sku1, null, fulfillment, fulfillmentOrderLine);
        System.assertNotEquals(null, fullfillmentAllocationLine.Id, 'Fulfillment Allocation Line should be created');
        dmpl__InventoryFulfillmentAllocationLine__c retrievedFullfillmentAllocationLine = FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(fullfillmentAllocationLine.Id);
        System.assertEquals(item1.Id, retrievedFullfillmentAllocationLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(10, retrievedFullfillmentAllocationLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(1500, retrievedFullfillmentAllocationLine.dmpl__UnitCost__c, 'Unit Cost should match');
        System.assertEquals(fulfillment.Id, retrievedFullfillmentAllocationLine.dmpl__FulfillmentOrderId__c, 'Fulfillment ID should match');
        System.assertEquals(fulfillmentOrderLine.Id, retrievedFullfillmentAllocationLine.dmpl__FulfillmentOrderLineId__c, 'Fulfillment Order Line ID should match');
        System.assertEquals(10, retrievedFullfillmentAllocationLine.dmpl__AllocatedQuantity__c, 'Allocated Quantity should match');
       
        fullfillmentAllocationLine.dmpl__Quantity__c = 5;
        update fullfillmentAllocationLine;
       
        dmpl__InventoryFulfillmentAllocationLine__c updatedFullfillmentAllocationLine = FulfillmentTestDataHelpers.getInventoryFulfillmentAllocationLine(fullfillmentAllocationLine.Id);
        System.assertEquals(5, updatedFullfillmentAllocationLine.dmpl__Quantity__c, 'Quantity should be updated to 5');
        System.assertEquals(item1.Id, updatedFullfillmentAllocationLine.dmpl__ItemId__c, 'Item ID should remain the same');
        System.assertEquals(1500, updatedFullfillmentAllocationLine.dmpl__UnitCost__c, 'Unit Cost should remain the same');
        System.assertEquals(5, updatedFullfillmentAllocationLine.dmpl__AllocatedQuantity__c, 'Allocated Quantity should be updated to 5');
        System.assertEquals(fulfillment.Id, updatedFullfillmentAllocationLine.dmpl__FulfillmentOrderId__c, 'Fulfillment ID should remain the same');
        System.assertEquals(fulfillmentOrderLine.Id, updatedFullfillmentAllocationLine.dmpl__FulfillmentOrderLineId__c, 'Fulfillment Order Line ID should remain the same');
       
        Test.stopTest();
    }

    @isTest
    static void updateFulfillmentOrderLineWithSaleOrderLineReferenceEdit() {
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__PriceList__c priceList1 = TestDataHelpers.getPriceList('Price List 1');
        
        Test.startTest();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(customerAccount1.Id,partnerAccount1.Id,branch1.Id,null,null,false,null);
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(saleOrder.Id,item1.Id,12,null);
        
        
        dmpl__InventoryFulfillment__c fulfillment = FulfillmentTestDataHelpers.createInventoryFulfillmentWithAllValues(partnerAccount1, customerAccount1, branch1,null,saleOrder,Date.today(),'Draft');
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = FulfillmentTestDataHelpers.createInventoryFulfillmentOrderLine(fulfillment, item1, 12, 1500, null, null, null, saleOrderLine, null);
        dmpl__SaleOrder__c saleOrder1=SaleOrderDataHelper.getSaleOrder(saleOrder.Id);
        dmpl__SaleOrderLine__c saleOrderLine1 = SaleOrderDataHelper.getSaleOrderLine(saleOrder1.Id);
        
        System.assertEquals(customerAccount1.Id, saleOrder1.dmpl__AccountId__c, 'Account ID should be Customer 1 ID');
        System.assertEquals('Price List 1', saleOrder1.dmpl__PriceListId__r.Name, 'Price List Id Mismatch');
       
        System.assertEquals('Within State', saleOrder1.dmpl__TaxSupplyType__c, 'Tax Supply Type should be Within State');
        System.assertEquals('MG Road', saleOrder1.dmpl__BillingStreet__c, 'Billing Street should be MG Road');
        System.assertEquals('Pune', saleOrder1.dmpl__BillingCity__c, 'Billing City should be Bengaluru');
        System.assertEquals('Maharashtra', saleOrder1.dmpl__BillingState__c, 'Billing State should be Karnataka');
        System.assertEquals('India', saleOrder1.dmpl__BillingCountry__c, 'Billing Country should be India');
        System.assertEquals('411001', saleOrder1.dmpl__BillingPostalCode__c, 'Billing Postal Code should be 560001');
        System.assertEquals(Date.today(), saleOrder1.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('Draft', saleOrder1.dmpl__Status__c, 'Status should be Draft');
        
        System.assertNotEquals(null, saleOrderLine1.Id, 'Sale Order Line should be created');
         
        System.assertEquals('GST 28', saleOrderLine1.dmpl__TaxGroupId__r.Name, 'Tax Group should be GST 28');
        System.assertEquals(1500, saleOrderLine1.dmpl__UnitPrice__c, 'Unit Price mismatch');
        System.assertEquals(18000, saleOrderLine1.dmpl__BaseAmount__c, 'Base Amount mismatch');
        System.assertEquals(0, saleOrderLine1.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount mismatch');
        System.assertEquals(0, saleOrderLine1.dmpl__NetDiscount__c, 'Net Discount mismatch');
        System.assertEquals(5040, saleOrderLine1.dmpl__TaxAmount__c, 'Tax Amount should be 5040');
        System.assertEquals(23040, saleOrderLine1.dmpl__GrossAmount__c, 'Gross Amount mismatch');
        System.assertEquals(1500, saleOrderLine1.dmpl__UnitPrice__c, 'Unit Price should be 1500');
        System.debug(saleOrderLine1.dmpl__GrossAmount__c);
        System.assertEquals(2520, saleOrderLine1.dmpl__Tax1__c, 'Tax1 should be 2520');
        System.assertEquals('CGST', saleOrderLine1.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(14, saleOrderLine1.dmpl__Tax1Rate__c, 'Tax1 Rate should be 14');
        System.assertEquals('CGST', saleOrderLine1.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(2520, saleOrderLine1.dmpl__Tax2__c, 'Tax2 should be 2520');
        System.assertEquals('SGST', saleOrderLine1.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        System.assertEquals(14, saleOrderLine1.dmpl__Tax2Rate__c, 'Tax2 Rate should be 14');
        System.assertEquals('SGST', saleOrderLine1.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(18000, saleOrderLine1.dmpl__BaseAmount__c, 'Base Amount should be 18000');
        System.assertEquals(0, saleOrderLine1.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0, saleOrderLine1.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(5040, saleOrderLine1.dmpl__TaxAmount__c, 'Tax Amount should be 5040');
        System.assertEquals(23040, saleOrderLine1.dmpl__GrossAmount__c, 'Gross Amount should be 23040');
        
        System.assertEquals(partnerAccount1.Id, fulfillment.dmpl__PartnerAccountId__c, 'Partner Account ID should be Partner 1');
        System.assertEquals(branch1.Id, fulfillment.dmpl__BranchId__c, 'Branch ID should be Branch 1');
        System.assertEquals(customerAccount1.Id, fulfillment.dmpl__AccountId__c, 'Customer Account ID should be Customer 1');
        System.assertEquals(Date.today(), fulfillment.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('Draft', fulfillment.dmpl__Status__c, 'Status should be Draft');
        
        System.assertEquals(item1.Id, fulfillmentOrderLine.dmpl__ItemId__c, 'Item ID should be Item 1');
        System.assertEquals(1500, fulfillmentOrderLine.dmpl__UnitCost__c, 'Unit Cost should be 1500');
        System.assertEquals(12, fulfillmentOrderLine.dmpl__Quantity__c, 'Quantity should be 12');
        System.assertEquals(saleOrderLine.Id, fulfillmentOrderLine.dmpl__SaleOrderLineId__c, 'Sale Order Line ID should be same');
        
        fulfillmentOrderLine.dmpl__Quantity__c = 10;
        update fulfillmentOrderLine;
        
        System.assertEquals(item1.Id, fulfillmentOrderLine.dmpl__ItemId__c, 'Item ID should be Item 1');
        System.assertEquals(1500, fulfillmentOrderLine.dmpl__UnitCost__c, 'Unit Cost should be 1500');
        System.assertEquals(10, fulfillmentOrderLine.dmpl__Quantity__c, 'Quantity should be 10');
        System.assertEquals(saleOrderLine.Id, fulfillmentOrderLine.dmpl__SaleOrderLineId__c, 'Sale Order Line ID should be same');
        Test.stopTest();
    }
    
    @isTest
    public static void updateFulfillmentOrderLineWithRepairOrderLineReferenceEdit() {
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Item__c item8 = TestDataHelpers.getItem('Item 8');
        dmpl__SKU__c sku2 = TestDataHelpers.createSKU(item8);
        Asset asset1 = FulfillmentTestDataHelpers.createAsset('Asset 1',customerAccount1,item1);
        dmpl__PriceList__c priceList7 = TestDataHelpers.getPriceList('Price List 7');
        Date today = Date.today();
        
        Test.startTest();
        dmpl__RepairOrder__c repairOrder = FulfillmentTestDataHelpers.createRepairOrder(
            partnerAccount1,
        branch1,
        customerAccount1,
        asset1,
        1000
            );
        
        dmpl__RepairOrderLine__c repairOrderLine = FulfillmentTestDataHelpers.createRepairOrderLine(
            repairOrder,
        item8,
        18
            );
        
        dmpl__InventoryFulfillment__c fulfillment = FulfillmentTestDataHelpers.createInventoryFulfillmentWithAllValues(
            partnerAccount1,
        customerAccount1,
        branch1,
        repairOrder,
        null,
        today,
        'Draft'
            );
        
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = FulfillmentTestDataHelpers.createInventoryFulfillmentOrderLine(
            fulfillment,
        item8,
        18,
        999,
        null,
        null,
        sku2,
        null,
        repairOrderLine
            );
        dmpl__RepairOrder__c repairOrder1 = FulfillmentTestDataHelpers.getRepairOrder(repairOrder.Id);
       
       // System.debug('Repair Order Line = '+repairOrderLine1);
        System.assertEquals(customerAccount1.Id, repairOrder1.dmpl__AccountId__c, 'Customer Id Mismatch');
        //System.assertEquals('Repair1', repairOrder1.dmpl__AccountName__c, 'Customer account name should match');
        System.assertEquals('Price List 1', repairOrder1.dmpl__PriceListId__r.Name, 'Price List should Match');
        //System.assertEquals('Within State', repairOrder1.dmpl__TaxSupplyType__c, 'Tax supply type should be wihtin state');
        System.assertEquals('MG Road', repairOrder1.dmpl__BillingStreet__c, 'Billing Street mismatch');
        System.assertEquals('Pune', repairOrder1.dmpl__BillingCity__c, 'Billing city mismatch');
        System.assertEquals('Maharashtra', repairOrder1.dmpl__BillingState__c, 'Billing State mismatch');
        System.assertEquals('India', repairOrder1.dmpl__BillingCountry__c, 'Billing Country mismatch');
        System.assertEquals('411001', repairOrder1.dmpl__BillingPostalCode__c, 'Billing Postal Code mismatch');
        System.assertEquals(Date.today(), repairOrder1.dmpl__DocumentDate__c, 'Document Date mismatch');
        System.assertEquals('Draft', repairOrder1.dmpl__Status__c, 'Status should be Draft');
        
         dmpl__RepairOrderLine__c repairOrderLine1 = FulfillmentTestDataHelpers.getRepairOrderLine(repairOrder.Id);
        System.assertNotEquals(null, repairOrderLine1.Id, 'Repair Order Line should be created');
        System.assertEquals(1500, repairOrderLine1.dmpl__UnitPrice__c, 'Unit Price should be 999');
        //System.assertEquals(2157.84, repairOrderLine1.dmpl__Tax1__c, 'Tax1 should be 2157.84');
        //System.assertEquals('CGST', repairOrderLine1.dmpl__Tax1Name__c, 'Tax1 Name should be CGST');
        System.assertEquals(6, repairOrderLine1.dmpl__Tax1Rate__c, 'Tax1 Rate should be 6');
        System.assertEquals('CGST', repairOrderLine1.dmpl__Tax1Type__c, 'Tax1 Type should be CGST');
        System.assertEquals(2157.84, repairOrderLine1.dmpl__Tax2__c, 'Tax2 should be 2157.84');
        //System.assertEquals('SGST', repairOrderLine1.dmpl__Tax2Name__c, 'Tax2 Name should be SGST');
        //System.assertEquals(6, repairOrderLine1.dmpl__Tax2Rate__c, 'Tax2 Rate should be 6');
        //System.assertEquals('SGST', repairOrderLine1.dmpl__Tax2Type__c, 'Tax2 Type should be SGST');
        System.assertEquals(27000, repairOrderLine1.dmpl__BaseAmount__c, 'Base Amount should be 17982');
        System.assertEquals(0, repairOrderLine1.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 0');
        System.assertEquals(0, repairOrderLine1.dmpl__NetDiscount__c, 'Net Discount should be 0');
        System.assertEquals(4315.68, repairOrderLine1.dmpl__TaxAmount__c, 'Tax Amount should be 4315.68');
        System.assertEquals(27000, repairOrderLine1.dmpl__GrossAmount__c, 'Gross Amount should be 20140');
        
        System.assertEquals(partnerAccount1.Id, fulfillment.dmpl__PartnerAccountId__c, 'Partner Account ID should be Partner 1');
        System.assertEquals(branch1.Id, fulfillment.dmpl__BranchId__c, 'Branch ID should be Branch 1');
        System.assertEquals(customerAccount1.Id, fulfillment.dmpl__AccountId__c, 'Customer Account ID should be Customer 1');
        System.assertEquals(Date.today(), fulfillment.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('Draft', fulfillment.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(repairOrder.Id, fulfillment.dmpl__RepairOrderId__c, 'Repair Order should be RO25060003');
        
        System.assertEquals(item8.Id, fulfillmentOrderLine.dmpl__ItemId__c, 'Item ID should be Item 1');
        System.assertEquals(18, fulfillmentOrderLine.dmpl__Quantity__c, 'Quantity should be 18');
        System.assertEquals(999, fulfillmentOrderLine.dmpl__UnitCost__c, 'Unit Cost should be 999');
        System.assertEquals(repairOrderLine.Id, fulfillmentOrderLine.dmpl__RepairOrderLineId__c, 'Repair Order Line should be ROL25060004');
        
        fulfillmentOrderLine.dmpl__Quantity__c = 10;
        fulfillmentOrderLine.dmpl__ItemId__c = item8.Id;
        update fulfillmentOrderLine;
        
        System.assertEquals(item8.Id, fulfillmentOrderLine.dmpl__ItemId__c, 'Item ID should be Item 1');
        System.assertEquals(10, fulfillmentOrderLine.dmpl__Quantity__c, 'Quantity should be 18');
        System.assertEquals(999, fulfillmentOrderLine.dmpl__UnitCost__c, 'Unit Cost should be 999');
        System.assertEquals(repairOrderLine.Id, fulfillmentOrderLine.dmpl__RepairOrderLineId__c, 'Repair Order Line should be ROL25060004');
        Test.stopTest();
    }
}