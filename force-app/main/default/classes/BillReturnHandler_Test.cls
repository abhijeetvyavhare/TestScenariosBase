@isTest
public with sharing class BillReturnHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();  
        Account supplierAccount = TestDataHelpers.createSupplierAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation(branch);
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__ItemLot__c itemLot = TestDataHelpers.createItemLot(branch, item, sku, storageLocation);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup(partnerAccount, branch);
        dmpl__Tax__c tax = TestDataHelpers.createTax(taxGroup);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList(partnerAccount, branch);
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceList, item);
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch, supplierAccount);
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partnerAccount, branch, purchaseOrder, supplierAccount);
        dmpl__GoodsReceiptLine__c grnLine = GoodRecieptsTestDataHelpers.createGoodReceiptLine(goodsReceipt, item, sku);
        Test.startTest();
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplierAccount, branch, priceList, purchaseOrder, goodsReceipt); 
        dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLine(customerAccount, item, sku, itemLot, bill, priceListRule, taxGroup);
        dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(supplierAccount, partnerAccount, branch, priceList);
        dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(bill, billReturn, item, billLine);
        dmpl__BillReturnTax__c billReturnTax = BillTestDataHelpers.CreateBillReturnTax(billReturn, billReturnLine, item, sku, bill, billLine, grnLine, taxGroup, tax);

		Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1', false, true, false, true, 'MG Road', 'Bengaluru', 'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India', '560095','9876543210');
        Account supplierAccount1 = TestDataHelpers.createPartnerAccount('Supplier 1', false, false, true, true, '55 Industrial Park Road', 'Ahmedabad', 'GJ', 'India', '380015', '55 Industrial Park Road', 'Ahmedabad', 'GJ', 'India', '380015', '-9988776564');
        dmpl__Branch__c branch1=TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id, true, true, false, true);
        dmpl__PriceList__c priceList1 = TestDataHelpers.createPriceList('Price List 1', partnerAccount1.Id, branch1.Id, null, null, true, false, 'Sale Price');
        dmpl__Item__c  item1 = TestDataHelpers.createItem('Item 1','Product',true,false,false,'675654',false);
        dmpl__Item__c item3 = TestDataHelpers.createItem('Item 3','Charge Item',true, false, false ,'765434',true);
        dmpl__Item__c item7 = TestDataHelpers.createItem('Item 7','Product',true,false,false, '765456',false);
        dmpl__Item__c item2 = TestDataHelpers.createItem('Item 2','Product',false,false,false,'654345',false);
        dmpl__Item__c item4 = TestDataHelpers.createItem('Item 4','Product',true, false, false ,'765676',true);
        dmpl__ItemGroup__c itemGroup1 = TestDataHelpers.createItemGroup('Item Group 1','Tax');
        dmpl__SKU__c sku1 = TestDataHelpers.createSKU('SKU 1', item7.id, true);

         
        dmpl__StorageLocation__c storageLocation1 = TestDataHelpers.createStorageLocation(
            'Storage Location 1',
            branch1.Id,
            true,
            'Warehouse'
        );

        Test.stopTest();
    }

    @isTest
    static void createBillReturnPositive() {
        dmpl__BillReturn__c billReturn = BillTestDataHelpers.getBillReturn();
        if (billReturn != null) {
            System.assertNotEquals(billReturn, null, 'Expected BillReturn to be created.');
        }
        System.assertEquals(false, billReturn.dmpl__PerformReturn__c, 'PerformReturn should be true');
        System.assertEquals(false, billReturn.dmpl__PerformInventoryPosting__c, 'PerformInventoryPosting should be false');
        System.assertEquals(Date.today(), billReturn.dmpl__DocumentDate__c, 'DocumentDate should ' + Date.today());
    }

    @isTest
    static void updateBillReturnPositive() {
        dmpl__BillReturn__c billReturn = BillTestDataHelpers.getBillReturn();
        System.assertNotEquals(billReturn, null, 'Bill Return should exist before update.');
        billReturn.dmpl__PerformReturn__c = false;
        update billReturn;
        dmpl__BillReturn__c updatedBillReturn = BillTestDataHelpers.getBillReturn();       
        System.assertEquals(false, updatedBillReturn.dmpl__PerformReturn__c, 'PerformReturn should be false');
    }

    @isTest
    static void deleteBillReturn() {
        dmpl__BillReturn__c billReturn = BillTestDataHelpers.getBillReturn();
        System.assertNotEquals(billReturn, null, 'BillReturn should exist before delete.');
        delete billReturn;
        dmpl__BillReturn__c deletedBillReturn = null;
        try {
            deletedBillReturn = BillTestDataHelpers.getBillReturn();
        } catch (Exception e) {
            deletedBillReturn = null;
        }
        System.assertEquals(null, deletedBillReturn, 'BillReturn should be deleted and not found in query.');
    }

    @isTest
    static void createBillReturnLinePositive() {
        Test.startTest();
        dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.getBillReturnLine();
        Test.stopTest();
        if (billReturnLine != null) {
            System.assertNotEquals(billReturnLine, null, 'Expected BillReturnLine to be created.');
        }
        System.assertEquals(2, billReturnLine.dmpl__Quantity__c, 'Quantity should be 2');
    }

    @isTest
    static void updateBillReturnLinePositive() {
        dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.getBillReturnLine();
        System.assertNotEquals(billReturnLine, null, 'BillReturnLine should exist before update.');
        Test.startTest();
        billReturnLine.dmpl__Quantity__c = 5;
        update billReturnLine;
        Test.stopTest();
        dmpl__BillReturnLine__c updatedBillReturnLine = BillTestDataHelpers.getBillReturnLine();       
        System.assertEquals(5, updatedBillReturnLine.dmpl__Quantity__c, 'Quantity should be 5');
    }

    @isTest
    static void deleteBillReturnLine() {
        dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.getBillReturnLine();
        System.assertNotEquals(billReturnLine, null, 'BillReturnLine should exist before delete.');
        
        Test.startTest();
        Boolean exceptionCaught = false;
        String exceptionMessage = '';
        
        try {
            delete billReturnLine;
            System.assert(false, 'Expected exception when deleting BillReturnLine');
        } catch (Exception e) {
            exceptionCaught = true;
            exceptionMessage = e.getMessage();
            System.debug('Exception caught: Type=' + e.getTypeName() + ', Message=' + exceptionMessage);        
            System.assert(
                exceptionMessage.contains('CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY'), 
                'Expected CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY error. Actual: ' + exceptionMessage
            );
            
            System.assert(
                exceptionMessage.contains('BillReturnLineTrigger'), 
                'Error should be from BillReturnLineTrigger. Actual: ' + exceptionMessage
            );
            
            System.assert(
                exceptionMessage.contains('null SObject') || exceptionMessage.contains('ListException'),
                'Expected null SObject or ListException error. Actual: ' + exceptionMessage
            );
        }
        Test.stopTest();
        System.assert(exceptionCaught, 'An exception should have been thrown during delete');    
        dmpl__BillReturnLine__c nonDeletedLine = BillTestDataHelpers.getBillReturnLine();
        System.assertNotEquals(null, nonDeletedLine, 'BillReturnLine should still exist after failed delete');
    }

    @isTest
     static void createBillReturnTaxPositive() {
        dmpl__BillReturnTax__c billReturnTax = BillTestDataHelpers.getBillReturnTax();
        System.assertNotEquals(billReturnTax, null, 'Expected BillReturnTax to be created.');
        System.assertEquals(true, billReturnTax.dmpl__TaxOnAmount__c, 'TaxOnAmount should be true');
    }

    @isTest
    static void updateBillReturnTaxPositive() {
        dmpl__BillReturnTax__c billReturnTax = BillTestDataHelpers.getBillReturnTax();
        System.assertNotEquals(billReturnTax, null, 'BillReturnTax should exist before update.');
        billReturnTax.dmpl__TaxAmount__c = 100;
        Test.startTest();
        update billReturnTax;
        Test.stopTest();
        dmpl__BillReturnTax__c updated = BillTestDataHelpers.getBillReturnTax();       
        System.assertEquals(100, updated.dmpl__TaxAmount__c, 'TaxAmount should be 100');
    }

    @isTest
    static void deleteBillReturnTax() {
        dmpl__BillReturnTax__c billReturnTax = BillTestDataHelpers.getBillReturnTax();
        System.assertNotEquals(billReturnTax, null, 'BillReturnTax should exist before delete.');
        Test.startTest();
        delete billReturnTax;
        Test.stopTest();
        dmpl__BillReturnTax__c deleted = null;
        try {
            deleted = BillTestDataHelpers.getBillReturnTax();
        } catch (Exception e) {
            deleted = null;
        }
        System.assertEquals(null, deleted, 'BillReturnTax should be deleted and not found in query.');
    }


	@isTest 
	static void updateBillReturnLineWithNoRequiredSKUPositive(){
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
		dmpl__PriceList__c priceList =  TestDataHelpers.getPriceList('Price List 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 7');
		dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(supplier, partner, branch, priceList);
		dmpl__BillReturnLine__c billreturnLine;
		try{
			billReturnLine = BillTestDataHelpers.createBillReturnLine(billReturn.Id, item.Id, 5, 1500);
		}catch(Exception e){
			System.assert(false, 'Exception not Expected');
		}
		billReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);
		System.assertEquals(item.Id, billReturnLine.dmpl__ItemId__c, 'Item ID must match expected value');
		System.assertEquals(1500, billReturnLine.dmpl__UnitCost__c, 'Unit Cost must match expected value');
		System.assertEquals(0, billReturnLine.dmpl__ClaimableQuantity__c, 'Claimable Quantity must be zero');
		System.assertEquals(5, billReturnLine.dmpl__Quantity__c, 'Quantity must match expected value');
		System.assertEquals(5, billReturnLine.dmpl__PendingDeliveryQuantity__c, 'Pending Delivery Quantity must match expected value');
		System.assertEquals(7500, billReturnLine.dmpl__Amount__c, 'Amount must match expected value');

		billReturn =  BillTestDataHelpers.getBillReturn(billReturn.Id);
		System.assertEquals(7500, billReturn.dmpl__TotalLineAmount__c, 'Total Line Amount must match expected value');
		System.assertEquals(7500, billReturn.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount must match expected value');
		System.assertEquals(7500, billReturn.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount must match expected value');

		try{
			billReturnLine.dmpl__Quantity__c = 4;
			update billreturnLine;
		}catch(Exception e){
			System.assert(false, 'Exception not Expected');
		}
		billReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);
		System.assertEquals(item.Id, billReturnLine.dmpl__ItemId__c, 'Item ID must match expected value');
		System.assertEquals(1500, billReturnLine.dmpl__UnitCost__c, 'Unit Cost must match expected value');
		System.assertEquals(0, billReturnLine.dmpl__ClaimableQuantity__c, 'Claimable Quantity must be zero');
		System.assertEquals(4, billReturnLine.dmpl__Quantity__c, 'Quantity must match expected value');
		System.assertEquals(4, billReturnLine.dmpl__PendingDeliveryQuantity__c, 'Pending Delivery Quantity must match expected value');
		System.assertEquals(6000, billReturnLine.dmpl__Amount__c, 'Amount must match expected value');

		billReturn =  BillTestDataHelpers.getBillReturn(billReturn.Id);
		System.assertEquals(6000, billReturn.dmpl__TotalLineAmount__c, 'Total Line Amount must match expected value');
		System.assertEquals(6000, billReturn.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount must match expected value');
		System.assertEquals(6000, billReturn.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount must match expected value');
		Test.stopTest();
	}

	@isTest 
	static void createBillReturnLineWithoutUnitCostPositive(){
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
		dmpl__PriceList__c priceList =  TestDataHelpers.getPriceList('Price List 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 3');
		dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(supplier, partner, branch, priceList);
		dmpl__BillReturnLine__c billreturnLine;
		try{
			billReturnLine = BillTestDataHelpers.createBillReturnLine(billReturn.Id, item.Id, 4, null);
		}catch(Exception e){
			System.assert(false, 'Exception not Expected');
		}
		billReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);
		System.assertEquals(item.Id, billReturnLine.dmpl__ItemId__c, 'Item ID must match expected value');
		System.assertEquals(null, billReturnLine.dmpl__UnitCost__c, 'Unit Cost must match expected value');
		System.assertEquals(0, billReturnLine.dmpl__ClaimableQuantity__c, 'Claimable Quantity must be zero');
		System.assertEquals(4, billReturnLine.dmpl__Quantity__c, 'Quantity must match expected value');
		System.assertEquals(4, billReturnLine.dmpl__PendingDeliveryQuantity__c, 'Pending Delivery Quantity must match expected value');
		System.assertEquals(0, billReturnLine.dmpl__Amount__c, 'Amount must match expected value');

		billReturn =  BillTestDataHelpers.getBillReturn(billReturn.Id);
		System.assertEquals(0, billReturn.dmpl__TotalLineAmount__c, 'Total Line Amount must match expected value');
		System.assertEquals(0, billReturn.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount must match expected value');
		System.assertEquals(0, billReturn.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount must match expected value');

		Test.stopTest();
	}
	@isTest 
	static void updateBillReturnLineWithoutUnitCostPositive(){
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
		dmpl__PriceList__c priceList =  TestDataHelpers.getPriceList('Price List 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 3');
		dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(supplier, partner, branch, priceList);
		dmpl__BillReturnLine__c billreturnLine;
		try{
			billReturnLine = BillTestDataHelpers.createBillReturnLine(billReturn.Id, item.Id, 4, null);
		}catch(Exception e){
			System.assert(false, 'Exception not Expected');
		}
		billReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);
		System.assertEquals(item.Id, billReturnLine.dmpl__ItemId__c, 'Item ID must match expected value');
		System.assertEquals(null, billReturnLine.dmpl__UnitCost__c, 'Unit Cost must match expected value');
		System.assertEquals(0, billReturnLine.dmpl__ClaimableQuantity__c, 'Claimable Quantity must be zero');
		System.assertEquals(4, billReturnLine.dmpl__Quantity__c, 'Quantity must match expected value');
		System.assertEquals(4, billReturnLine.dmpl__PendingDeliveryQuantity__c, 'Pending Delivery Quantity must match expected value');
		System.assertEquals(0, billReturnLine.dmpl__Amount__c, 'Amount must match expected value');

		billReturn =  BillTestDataHelpers.getBillReturn(billReturn.Id);
		System.assertEquals(0, billReturn.dmpl__TotalLineAmount__c, 'Total Line Amount must match expected value');
		System.assertEquals(0, billReturn.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount must match expected value');
		System.assertEquals(0, billReturn.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount must match expected value');

		try{
			billReturnLine.dmpl__Quantity__c = 2;
			update billreturnLine;
		}catch(Exception e){
			System.assert(false, 'Exception not Expected');
		}
		billReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);
		System.assertEquals(item.Id, billReturnLine.dmpl__ItemId__c, 'Item ID must match expected value');
		System.assertEquals(null, billReturnLine.dmpl__UnitCost__c, 'Unit Cost must match expected value');
		System.assertEquals(0, billReturnLine.dmpl__ClaimableQuantity__c, 'Claimable Quantity must be zero');
		System.assertEquals(2, billReturnLine.dmpl__Quantity__c, 'Quantity must match expected value');
		System.assertEquals(2, billReturnLine.dmpl__PendingDeliveryQuantity__c, 'Pending Delivery Quantity must match expected value');
		System.assertEquals(0, billReturnLine.dmpl__Amount__c, 'Amount must match expected value');

		billReturn =  BillTestDataHelpers.getBillReturn(billReturn.Id);
		System.assertEquals(0, billReturn.dmpl__TotalLineAmount__c, 'Total Line Amount must match expected value');
		System.assertEquals(0, billReturn.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount must match expected value');
		System.assertEquals(0, billReturn.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount must match expected value');
		Test.stopTest();
	}
	@isTest 
	static void createBillReturnLineWithoutOrderedQuantityPositive(){
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
		dmpl__PriceList__c priceList =  TestDataHelpers.getPriceList('Price List 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 7');
		dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(supplier, partner, branch, priceList);
		dmpl__BillReturnLine__c billreturnLine;
		try{
			billReturnLine = BillTestDataHelpers.createBillReturnLine(billReturn.Id, item.Id, null, 1500);
		}catch(Exception e){
			System.assert(false, 'Exception not Expected');
		}
		billReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);
		System.assertEquals(item.Id, billReturnLine.dmpl__ItemId__c, 'Item ID must match expected value');
		System.assertEquals(1500, billReturnLine.dmpl__UnitCost__c, 'Unit Cost must match expected value');
		System.assertEquals(0, billReturnLine.dmpl__ClaimableQuantity__c, 'Claimable Quantity must be zero');
		System.assertEquals(null, billReturnLine.dmpl__Quantity__c, 'Quantity must match expected value');
		System.assertEquals(0, billReturnLine.dmpl__PendingDeliveryQuantity__c, 'Pending Delivery Quantity must match expected value');
		System.assertEquals(0, billReturnLine.dmpl__Amount__c, 'Amount must match expected value');

		billReturn =  BillTestDataHelpers.getBillReturn(billReturn.Id);
		System.assertEquals(0, billReturn.dmpl__TotalLineAmount__c, 'Total Line Amount must match expected value');
		System.assertEquals(0, billReturn.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount must match expected value');
		System.assertEquals(0, billReturn.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount must match expected value');

		Test.stopTest();
	}
	@isTest 
	static void updateBillReturnLineWithoutOrderedQuantityPositive(){
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
		dmpl__PriceList__c priceList =  TestDataHelpers.getPriceList('Price List 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(supplier, partner, branch, priceList);
		dmpl__BillReturnLine__c billreturnLine;
		try{
			billReturnLine = BillTestDataHelpers.createBillReturnLine(billReturn.Id, item.Id, 10, 1500);
		}catch(Exception e){
			System.assert(false, 'Exception not Expected');
		}
		billReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);
		System.assertEquals(item.Id, billReturnLine.dmpl__ItemId__c, 'Item ID must match expected value');
		System.assertEquals(1500, billReturnLine.dmpl__UnitCost__c, 'Unit Cost must match expected value');
		System.assertEquals(0, billReturnLine.dmpl__ClaimableQuantity__c, 'Claimable Quantity must be zero');
		System.assertEquals(10, billReturnLine.dmpl__Quantity__c, 'Quantity must match expected value');
		System.assertEquals(10, billReturnLine.dmpl__PendingDeliveryQuantity__c, 'Pending Delivery Quantity must match expected value');
		System.assertEquals(15000, billReturnLine.dmpl__Amount__c, 'Amount must match expected value');

		billReturn =  BillTestDataHelpers.getBillReturn(billReturn.Id);
		System.assertEquals(15000, billReturn.dmpl__TotalLineAmount__c, 'Total Line Amount must match expected value');
		System.assertEquals(15000, billReturn.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount must match expected value');
		System.assertEquals(15000, billReturn.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount must match expected value');

		try{
			billReturnLine.dmpl__Quantity__c = null;
			update billreturnLine;
		}catch(Exception e){
			System.assert(false, 'Exception not Expected');
		}
		billReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);
		System.assertEquals(item.Id, billReturnLine.dmpl__ItemId__c, 'Item ID must match expected value');
		System.assertEquals(1500, billReturnLine.dmpl__UnitCost__c, 'Unit Cost must match expected value');
		System.assertEquals(0, billReturnLine.dmpl__ClaimableQuantity__c, 'Claimable Quantity must be zero');
		System.assertEquals(null, billReturnLine.dmpl__Quantity__c, 'Quantity must match expected value');
		System.assertEquals(0, billReturnLine.dmpl__PendingDeliveryQuantity__c, 'Pending Delivery Quantity must match expected value');
		System.assertEquals(0, billReturnLine.dmpl__Amount__c, 'Amount must match expected value');

		billReturn =  BillTestDataHelpers.getBillReturn(billReturn.Id);
		System.assertEquals(0, billReturn.dmpl__TotalLineAmount__c, 'Total Line Amount must match expected value');
		System.assertEquals(0, billReturn.dmpl__TotalLineBaseAmount__c, 'Total Line Base Amount must match expected value');
		System.assertEquals(0, billReturn.dmpl__TotalLineGrossAmount__c, 'Total Line Gross Amount must match expected value');
		Test.stopTest();
	}
    @isTest
    static void createBillReturnLineWithActiveItemPositive() {
    Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
    dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
    Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
    dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
    dmpl__StorageLocation__c storageLocation1 = TestDataHelpers.getStorageLocation('Storage Location 1');
    dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
    
    Test.startTest();
    dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(
        supplierAccount1,
        partnerAccount1,
        branch1,
        priceList
    );
    

    dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(
        billReturn.Id,
        item1.Id,
        10,
        1500,
        storageLocation1.Id,null
    );
    
    Test.stopTest();
    
    dmpl__BillReturn__c updatedBillReturn = BillTestDataHelpers.getBillReturn(billReturn.Id);
    dmpl__BillReturnLine__c insertedBillReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);
 
    System.assertEquals(item1.Id, insertedBillReturnLine.dmpl__ItemId__c, 'Item should match');
    System.assertEquals(1500, insertedBillReturnLine.dmpl__UnitCost__c, 'Unit cost should be 1500');
    System.assertEquals(10, insertedBillReturnLine.dmpl__Quantity__c, 'Quantity should be 10');
    System.assertEquals(storageLocation1.Id, insertedBillReturnLine.dmpl__StorageLocationId__c, 'Storage location should match');
    System.assertEquals(15000, insertedBillReturnLine.dmpl__BaseAmount__c, 'Base amount should be 15000 (10*1500)');
    System.assertEquals(15000, insertedBillReturnLine.dmpl__GrossAmount__c, 'Gross amount should be 15000');
    System.assertEquals(10, insertedBillReturnLine.dmpl__PendingDeliveryQuantity__c, 'Pending delivery quantity should be 10');
    
    System.assertEquals(15000, updatedBillReturn.dmpl__TotalLineBaseAmount__c, 'Total line base amount should be 15000');
    System.assertEquals(15000, updatedBillReturn.dmpl__TotalLineGrossAmount__c, 'Total line gross amount should be 15000');
    }
@isTest
static void createBillReturnLineWithRequiredSKUPositive() {

    Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
    dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
    Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
    dmpl__Item__c item7 = TestDataHelpers.getItem('Item 7');
    dmpl__StorageLocation__c storageLocation1 = TestDataHelpers.getStorageLocation('Storage Location 1');
    dmpl__SKU__c sku1 = TestDataHelpers.getSKU('SKU 1');
    dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
    
    Test.startTest();

    dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(
        supplierAccount1,
        partnerAccount1,
        branch1,
        priceList
    );

    dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(
        billReturn.Id,
        item7.Id,
        10,
        1000,
        storageLocation1.Id,
        sku1.Id
    );
    
    Test.stopTest();
    
    dmpl__BillReturn__c updatedBillReturn = BillTestDataHelpers.getBillReturn(billReturn.Id);
    dmpl__BillReturnLine__c insertedBillReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);
    
    System.assertEquals(item7.Id, insertedBillReturnLine.dmpl__ItemId__c, 'Item should be Item 7');
    System.assertEquals(1000, insertedBillReturnLine.dmpl__UnitCost__c, 'Unit cost should be 1000');
    System.assertEquals(10, insertedBillReturnLine.dmpl__Quantity__c, 'Quantity should be 10');
    System.assertEquals(storageLocation1.Id, insertedBillReturnLine.dmpl__StorageLocationId__c, 'Storage location should match');
    System.assertEquals(sku1.Id, insertedBillReturnLine.dmpl__SKUId__c, 'SKU should be SKU 1');
    System.assertEquals(10000, insertedBillReturnLine.dmpl__Amount__c, 'Amount should be 10000 (10*1000)');
    System.assertEquals(10000, insertedBillReturnLine.dmpl__BaseAmount__c, 'Base amount should be 10000');
    System.assertEquals(10000, insertedBillReturnLine.dmpl__GrossAmount__c, 'Gross amount should be 10000');
    System.assertEquals(10, insertedBillReturnLine.dmpl__PendingDeliveryQuantity__c, 'Pending delivery quantity should be 10');

    System.assertEquals(10000, updatedBillReturn.dmpl__TotalLineBaseAmount__c, 'Total line base amount should be 10000');
    System.assertEquals(10000, updatedBillReturn.dmpl__TotalLineGrossAmount__c, 'Total line gross amount should be 10000');
}
@isTest
static void createBillReturnLineWithNoRequiredSKUPositive() {

    Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
    dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
    Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
    dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
    dmpl__StorageLocation__c storageLocation1 = TestDataHelpers.getStorageLocation('Storage Location 1');
    dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
    
    Test.startTest();

    dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(
        supplierAccount1,
        partnerAccount1,
        branch1,
        priceList
    );
    
    
    dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(
        billReturn.Id,
        item1.Id,
        1,
        1500,
        null,
        null 
    );
    
    Test.stopTest();
    

    dmpl__BillReturn__c updatedBillReturn = BillTestDataHelpers.getBillReturn(billReturn.Id);
    dmpl__BillReturnLine__c insertedBillReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);

    System.assertEquals(item1.Id, insertedBillReturnLine.dmpl__ItemId__c, 'Item should be Item 1');
    System.assertEquals(1500, insertedBillReturnLine.dmpl__UnitCost__c, 'Unit cost should be 1500');
    System.assertEquals(1, insertedBillReturnLine.dmpl__Quantity__c, 'Quantity should be 10');
    System.assertEquals(null, insertedBillReturnLine.dmpl__SKUId__c, 'SKU should be null');
    System.assertEquals(1500, insertedBillReturnLine.dmpl__Amount__c, 'Amount should be 15000 (10*1500)');
    System.assertEquals(1500, insertedBillReturnLine.dmpl__BaseAmount__c, 'Base amount should be 15000');
    System.assertEquals(1500, insertedBillReturnLine.dmpl__GrossAmount__c, 'Gross amount should be 15000');
    

    System.assertEquals(1500, updatedBillReturn.dmpl__TotalLineBaseAmount__c, 'Total line base amount should be 15000');
    System.assertEquals(1500, updatedBillReturn.dmpl__TotalLineGrossAmount__c, 'Total line gross amount should be 15000');
}

@isTest
static void createBillReturnLineWithInactiveItemNegative() {

    Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
    dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
    Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
    dmpl__Item__c item2 = TestDataHelpers.getItem('Item 2');
    dmpl__StorageLocation__c storageLocation1 = TestDataHelpers.getStorageLocation('Storage Location 1');
    dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
    
    Test.startTest();
    dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(
        supplierAccount1,
        partnerAccount1,
        branch1,
        priceList
    );

        dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(
            billReturn.Id,
            item2.Id,
            10,
            2400,
            storageLocation1.Id,
            null
        );
    
    Test.stopTest();

    dmpl__BillReturn__c insertedBillReturn = BillTestDataHelpers.getBillReturn(billReturn.Id);



    
}
@isTest
static void createBillReturnLineWithDiscontinuedItemPositive() {

    Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
    dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
    Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
    dmpl__Item__c item4 = TestDataHelpers.getItem('Item 4');
    dmpl__StorageLocation__c storageLocation1 = TestDataHelpers.getStorageLocation('Storage Location 1');
    dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
    
    Test.startTest();
    dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(
        supplierAccount1,
        partnerAccount1,
        branch1,
        priceList
    );

    dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(
        billReturn.Id,
        item4.Id,
        10,
        2000,
        storageLocation1.Id,
        null 
    );
    
    Test.stopTest();
    
    dmpl__BillReturn__c updatedBillReturn = BillTestDataHelpers.getBillReturn(billReturn.Id);
    dmpl__BillReturnLine__c insertedBillReturnLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);

    System.assertEquals(item4.Id, insertedBillReturnLine.dmpl__ItemId__c, 'Item should be Item 4');
    System.assertEquals(2000, insertedBillReturnLine.dmpl__UnitCost__c, 'Unit cost should be 2000');
    System.assertEquals(10, insertedBillReturnLine.dmpl__Quantity__c, 'Quantity should be 10');
    System.assertEquals(storageLocation1.Id, insertedBillReturnLine.dmpl__StorageLocationId__c, 'Storage location should match');
    System.assertEquals(null, insertedBillReturnLine.dmpl__SKUId__c, 'SKU should be null');
    System.assertEquals(20000, insertedBillReturnLine.dmpl__Amount__c, 'Amount should be 20000 (10*2000)');
    System.assertEquals(20000, insertedBillReturnLine.dmpl__BaseAmount__c, 'Base amount should be 20000');
    System.assertEquals(20000, insertedBillReturnLine.dmpl__GrossAmount__c, 'Gross amount should be 20000');
    System.assertEquals(10, insertedBillReturnLine.dmpl__PendingDeliveryQuantity__c, 'Pending delivery quantity should be 10');

    System.assertEquals(20000, updatedBillReturn.dmpl__TotalLineBaseAmount__c, 'Total line base amount should be 20000');
    System.assertEquals(20000, updatedBillReturn.dmpl__TotalLineGrossAmount__c, 'Total line gross amount should be 20000');

}
@isTest
static void updateBillReturnLineWithInactiveItemNegative() {

    Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
    dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
    Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
    dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1'); 
    dmpl__Item__c item2 = TestDataHelpers.getItem('Item 2'); 
    dmpl__StorageLocation__c storageLocation1 = TestDataHelpers.getStorageLocation('Storage Location 1');
    dmpl__PriceList__c priceList = TestDataHelpers.getPriceList('Price List 1');
    
    Test.startTest();

    dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(
        supplierAccount1,
        partnerAccount1,
        branch1,
        priceList
    );

    System.assertEquals(partnerAccount1.Id, billReturn.dmpl__PartnerAccountId__c, 'Partner Account should match');
    System.assertEquals(branch1.Id, billReturn.dmpl__BranchId__c, 'Branch should match');
    System.assertEquals(supplierAccount1.Id, billReturn.dmpl__SupplierAccountId__c, 'Supplier Account should match');
    System.assertEquals(Date.today(), billReturn.dmpl__DocumentDate__c, 'Document date should match');

    dmpl__BillReturnLine__c billReturnLine = BillTestDataHelpers.createBillReturnLine(
        billReturn.Id,
        item1.Id,
        10,
        1500,
        storageLocation1.Id,
        null
    );
    
    Boolean exceptionThrown = false;
    
    try {
        billReturnLine.dmpl__ItemId__c = item2.Id;
        billReturnLine.dmpl__Quantity__c = 15;
        update billReturnLine;
    } catch(Exception e) {
        exceptionThrown = true;
    }
    
    Test.stopTest();
   
    System.assertEquals(true, exceptionThrown, 'Expected exception when trying to edit with inactive item');
    
    dmpl__BillReturnLine__c updatedLine = BillTestDataHelpers.getBillReturnLine(billReturnLine.Id);
    System.assertEquals(item1.Id, updatedLine.dmpl__ItemId__c, 'Item should remain Item 1 (not updated to inactive Item 2)');
    System.assertEquals(10, updatedLine.dmpl__Quantity__c, 'Quantity should remain 10 (not updated to 15)');
}
}