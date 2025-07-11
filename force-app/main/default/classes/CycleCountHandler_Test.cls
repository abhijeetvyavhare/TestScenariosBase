@isTest
public with sharing class CycleCountHandler_Test {

    @TestSetup
    static void makeData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        TestDataHelpers.createBranch(partnerAccount);

		Test.startTest();
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1', false, true, false, true, 'MG Road', 'Bengaluru', 'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India', '560095','9876543210');
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2', false, true, false, false, '45 Residency Road', 'Pune', 'Maharashtra', 'India', '411001', '22 Commerce Avenue', 'Pune', 'Maharashtra', 'India', '411038','91-99665544433');
        Account partnerAccount3 = TestDataHelpers.createPartnerAccount('Partner 3', false, true, false, true, '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '91-9123456789');
        dmpl__Branch__c branch1=TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id, true, true, false, true);
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partnerAccount3.Id, false, true, true, false);
        dmpl__Item__c  item1 = TestDataHelpers.createItem('Item 1','Product',true,false,false,'675654',false);
		dmpl__ItemGroup__c itemGroup1 = TestDataHelpers.createItemGroup('Item Group 1','Tax');
		dmpl__StorageLocation__c storageLocation1 = TestDataHelpers.createStorageLocation('Storage Location 1',branch1.Id,true,'Warehouse');
 		dmpl__StorageLocation__c storageLocation3 = TestDataHelpers.createStorageLocation('Storage Location 3',branch3.Id,true,null);
		dmpl__InventoryCycleCount__c cycleCount1  = CycleCountTestDataHelpers.createCycleCount(partnerAccount1.Id, branch1.Id, itemGroup1.Id, storageLocation1.Id, 'Quantity Available');
		Test.stopTest();
    }
    
    @isTest
    static void createCycleCountTestPositive() {
        dmpl__InventoryCycleCount__c cycleCount = (dmpl__InventoryCycleCount__c) TestFactory.createSObject(
            new dmpl__InventoryCycleCount__c(
                dmpl__MaximumItems__c = 2,
                dmpl__PartnerAccountId__c = TestDataHelpers.getPartnerAccount().Id,
                dmpl__BranchId__c = TestDataHelpers.getBranch().Id),
            'InventoryCycleCountDefaults'
        );

        Test.startTest();
        insert cycleCount;
        Test.stopTest();

        dmpl__InventoryCycleCount__c checkCycleCount = [SELECT Id, Name FROM dmpl__InventoryCycleCount__c LIMIT 1];
        System.assertNotEquals(
            String.valueOf(checkCycleCount.Name),
            null,
            'Expected to see that the Cycle Count Created Wiht Custom Name.'
        );
    }

	/******************************* Cycle Count *******************************/

	@isTest 
	static void createCycleCountwithStorageLocationPositive(){
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1'); 
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation('Storage Location 1');
		dmpl__InventoryCycleCount__c cycleCount;
		try{
			cycleCount = CycleCountTestDataHelpers.createCycleCount(partner.Id, branch.Id, null, storageLocation.Id, null);
		}catch(Exception e){
			System.Assert.isTrue(cycleCount != null, 'Expected the cycle count creation not to fail');
		}
		System.AssertEquals(partner.Id, cycleCount.dmpl__PartnerAccountId__c, 'Partner 1 Should Match');
		System.AssertEquals(branch.Id, cycleCount.dmpl__BranchId__c, 'Branch 1 Should Match');
		System.AssertEquals(storageLocation.Id, cycleCount.dmpl__StorageLocationId__c, 'Storage Location 1 Should Match');
		Test.stopTest();
	}

	@isTest 
	static void createCycleCountwithItemGroupPositive(){
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1'); 
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 1');
		dmpl__InventoryCycleCount__c cycleCount;
		try{
			cycleCount = CycleCountTestDataHelpers.createCycleCount(partner.Id, branch.Id, itemGroup.Id, null, null);
		}catch(Exception e){
			System.Assert.isTrue(cycleCount != null, 'Expected the cycle count creation not to fail');
		}
		System.AssertEquals(partner.Id, cycleCount.dmpl__PartnerAccountId__c, 'Partner 1 Should Match');
		System.AssertEquals(branch.Id, cycleCount.dmpl__BranchId__c, 'Branch 1 Should Match');
		System.AssertEquals(itemGroup.Id, cycleCount.dmpl__ItemGroupId__c, 'Item Group 1 Should Match');
		Test.stopTest();
	}
	
	@isTest 
	static void createCycleCountwithCountQuantityTypeAsQuantityAvailablePositive(){
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1'); 
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__InventoryCycleCount__c cycleCount;
		try{
			cycleCount = CycleCountTestDataHelpers.createCycleCount(partner.Id, branch.Id, null, null, 'Quantity Available');
		}catch(Exception e){
			System.Assert.isTrue(cycleCount != null, 'Expected the cycle count creation not to fail');
		}
		System.AssertEquals(partner.Id, cycleCount.dmpl__PartnerAccountId__c, 'Partner 1 Should Match');
		System.AssertEquals(branch.Id, cycleCount.dmpl__BranchId__c, 'Branch 1 Should Match');
		System.AssertEquals('Quantity Available', cycleCount.dmpl__CountQuantityType__c, 'Quantity Available CountQuantityType Should Match');
		Test.stopTest();
	}

	@isTest 
	static void createCycleCountwithCountQuantityTypeAsQuantityInHandPositive(){
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1'); 
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__InventoryCycleCount__c cycleCount;
		try{
			cycleCount = CycleCountTestDataHelpers.createCycleCount(partner.Id, branch.Id, null, null, 'Quantity In Hand');
		}catch(Exception e){
			System.Assert.isTrue(cycleCount != null, 'Expected the cycle count creation not to fail');
		}
		System.AssertEquals(partner.Id, cycleCount.dmpl__PartnerAccountId__c, 'Partner 1 Should Match');
		System.AssertEquals(branch.Id, cycleCount.dmpl__BranchId__c, 'Branch 1 Should Match');
		System.AssertEquals('Quantity In Hand', cycleCount.dmpl__CountQuantityType__c, 'Quantity In Hand CountQuantityType Should Match');
		Test.stopTest();
	}
	
	@isTest 
	static void createCycleCountwithCountQuantityTypeAsActualQuantityPositive(){
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1'); 
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__InventoryCycleCount__c cycleCount;
		try{
			cycleCount = CycleCountTestDataHelpers.createCycleCount(partner.Id, branch.Id, null, null, 'Actual Quantity');
		}catch(Exception e){
			System.Assert.isTrue(cycleCount != null, 'Expected the cycle count creation not to fail');
		}
		System.AssertEquals(partner.Id, cycleCount.dmpl__PartnerAccountId__c, 'Partner 1 Should Match');
		System.AssertEquals(branch.Id, cycleCount.dmpl__BranchId__c, 'Branch 1 Should Match');
		System.AssertEquals('Actual Quantity', cycleCount.dmpl__CountQuantityType__c, 'Actual Quantity Hand CountQuantityType Should Match');
		Test.stopTest();
	}

	@isTest 
	static void createCycleCountwithoutPartnerAccountNegative(){
		Test.startTest();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation('Storage Location 1');
		dmpl__InventoryCycleCount__c cycleCount;
		try{
			cycleCount = CycleCountTestDataHelpers.createCycleCount(null, branch.Id, null, storageLocation.Id, null);
			System.Assert.isTrue(cycleCount == null, 'Expected the cycle count creation to fail As partner Account not tagged');
		}catch(Exception e){
			System.Assert.isTrue(cycleCount == null, 'Expected the cycle count creation to fail As partner Account not tagged');
		}
		Test.stopTest();
	}

	@isTest 
	static void createCycleCountwithoutBranchNegative(){
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1'); 
		dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation('Storage Location 1');
		dmpl__InventoryCycleCount__c cycleCount;
		try{
			cycleCount = CycleCountTestDataHelpers.createCycleCount(partner.Id, null, null, storageLocation.Id, null);
			System.Assert.isTrue(cycleCount == null, 'Expected the cycle count creation to fail As Branch not tagged');
		}catch(Exception e){
			System.Assert.isTrue(cycleCount == null, 'Expected the cycle count creation to fail As Branch not tagged');
		}
		Test.stopTest();
	}

	@isTest 
	static void createCycleCountwithWrongStorageLocationNegative(){
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1'); 
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation('Storage Location 3');
		dmpl__InventoryCycleCount__c cycleCount;
		try{
			cycleCount = CycleCountTestDataHelpers.createCycleCount(partner.Id, branch.Id, null, storageLocation.Id, null);
			//System.Assert.isTrue(cycleCount == null, 'Expected the cycle count creation to fail As Wrong Storage Location tagged!');
		}catch(Exception e){
			System.Assert.isTrue(cycleCount == null, 'Expected the cycle count creation to fail As Wrong Storage Location tagged');
		}
		Test.stopTest();
	}

	@isTest 
	static void createCycleCountwithWrongPartnerAccountNegative(){
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 2'); 
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation('Storage Location 1');
		dmpl__InventoryCycleCount__c cycleCount;
		try{
			cycleCount = CycleCountTestDataHelpers.createCycleCount(partner.Id, branch.Id, null, storageLocation.Id, null);
			System.Assert.isTrue(cycleCount == null, 'Expected the cycle count creation to fail As Wrong Partner Account tagged');
		}catch(Exception e){
			System.Assert.isTrue(cycleCount == null, 'Expected the cycle count creation to fail As Wrong Partner Account tagged');
		}
		Test.stopTest();
	}

	@isTest 
	static void createCycleCountwithWrongBranchNegative(){
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1'); 
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 3');
		dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation('Storage Location 1');
		dmpl__InventoryCycleCount__c cycleCount;
		try{
			cycleCount = CycleCountTestDataHelpers.createCycleCount(partner.Id, branch.Id, null, storageLocation.Id, null);
			System.Assert.isTrue(cycleCount == null, 'Expected the cycle count creation to fail As Wrong Branch tagged');
		}catch(Exception e){
			System.Assert.isTrue(cycleCount == null, 'Expected the cycle count creation to fail As Wrong Branch tagged');
		}
		Test.stopTest();
	}

	/******************************* Cycle Count Line *******************************/

	@isTest 
	static void createCycleCountLinewithItemLotPositive(){

		Test.startTest();
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.getCycleCount();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		dmpl__ItemLotType__c itemLotType = TestDataHelpers.CreateItemLotType(item);
		dmpl__InventoryCycleCountLine__c cycleCountLine;
		try{
			cycleCountLine = CycleCountTestDataHelpers.createCycleCountLine(cycleCount.Id, item.Id, itemLotType.Id,1,0,1);
		}catch(Exception e){
			System.Assert.isTrue(cycleCountLine != null, 'Expected the cycle count creation not to fail');
		}
		cycleCountLine = CycleCountTestDataHelpers.getCycleCountLine(cycleCountLine.Id);

		System.assertEquals(cycleCount.Id, cycleCountLine.dmpl__CycleCountId__c, 'Cycle Count ID should match');
		System.assertEquals(item.Id, cycleCountLine.dmpl__ItemId__c, 'Item 1 should match');
		System.assertEquals(itemLotType.Id, cycleCountLine.dmpl__ItemLotTypeId__c, 'Lot ID should match');
		// System.assertEquals(0, cycleCountLine.dmpl__QuantityAvailable__c, 'Quantity Available should be 0');
		System.assertEquals(0, cycleCountLine.dmpl__OnHandQuantity__c, 'Quantity In Hand should be 0');
		
		Test.stopTest();
	}
	@isTest 
	static void createCycleCountLinewithDiscrepancyQuantityPositive(){

		Test.startTest();
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.getCycleCount();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		dmpl__InventoryCycleCountLine__c cycleCountLine;
		try{
			cycleCountLine = CycleCountTestDataHelpers.createCycleCountLine(cycleCount.Id, item.Id, null, 5, 0, 1);
		}catch(Exception e){

			System.Assert.isTrue(cycleCountLine != null, 'Expected the cycle count creation not to fail');
		}
		cycleCountLine = CycleCountTestDataHelpers.getCycleCountLine(cycleCountLine.Id);

		System.assertEquals(cycleCount.Id, cycleCountLine.dmpl__CycleCountId__c, 'Cycle Count ID should match');
		System.assertEquals(item.Id, cycleCountLine.dmpl__ItemId__c, 'Item 1 should match');
		// System.assertEquals(0, cycleCountLine.dmpl__QuantityAvailable__c, 'Quantity Available should be 0');
		System.assertEquals(0, cycleCountLine.dmpl__OnHandQuantity__c, 'Quantity In Hand should be 0');
		System.assertEquals(5, cycleCountLine.dmpl__DiscrepencyQuantity__c, 'Discrepancy Quantity should be 5');
		
		Test.stopTest();
	}
	@isTest 
	static void createCycleCountLinewithOnHandQuantityPositive(){

		Test.startTest();
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.getCycleCount();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		dmpl__InventoryCycleCountLine__c cycleCountLine;
		try{
			cycleCountLine = CycleCountTestDataHelpers.createCycleCountLine(cycleCount.Id, item.Id, null, 1, 10, 1);
		}catch(Exception e){
			System.Assert.isTrue(cycleCountLine != null, 'Expected the cycle count creation not to fail');
		}
		cycleCountLine = CycleCountTestDataHelpers.getCycleCountLine(cycleCountLine.Id);

		System.assertEquals(cycleCount.Id, cycleCountLine.dmpl__CycleCountId__c, 'Cycle Count ID should match');
		System.assertEquals(item.Id, cycleCountLine.dmpl__ItemId__c, 'Item 1 should match');
		System.assertEquals(10, cycleCountLine.dmpl__ExpectedQuantity__c, 'Expected Quantity should be 10');
		System.assertEquals(10, cycleCountLine.dmpl__OnHandQuantity__c, 'On Hand Quantity should be 10');
		System.assertEquals(-9, cycleCountLine.dmpl__DiscrepencyQuantity__c, 'Discrepancy Quantity should be -9');

		Test.stopTest();
	}
	@isTest 
	static void createCycleCountLinewithUnitCostPositive(){

		Test.startTest();
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.getCycleCount();
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		dmpl__InventoryCycleCountLine__c cycleCountLine;
		try{
			cycleCountLine = CycleCountTestDataHelpers.createCycleCountLine(cycleCount.Id, item.Id, null, 1, 0, 500);
		}catch(Exception e){
			System.Assert.isTrue(cycleCountLine != null, 'Expected the cycle count line to be created successfully');
		}
		cycleCountLine = CycleCountTestDataHelpers.getCycleCountLine(cycleCountLine.Id);

		System.assertEquals(cycleCount.Id, cycleCountLine.dmpl__CycleCountId__c, 'Cycle Count ID should match');
		System.assertEquals(item.Id, cycleCountLine.dmpl__ItemId__c, 'Item 1 should match');
		System.assertEquals(500, cycleCountLine.dmpl__DiscrepancyCostValue__c, 'Discrepancy Cost Value should be 500');
		System.assertEquals(1, cycleCountLine.dmpl__DiscrepencyQuantity__c, 'Discrepancy Quantity should be 1');
		System.assertEquals(0, cycleCountLine.dmpl__ExpectedQuantity__c, 'Expected Quantity should be 0');
		System.assertEquals(500, cycleCountLine.dmpl__UnitCost__c, 'Unit Cost should be 500');

		Test.stopTest();
	}
	@isTest 
	static void createCycleCountLinewithoutItemNegative(){

		Test.startTest();
		dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.getCycleCount();
		dmpl__InventoryCycleCountLine__c cycleCountLine;
		try{
			cycleCountLine = CycleCountTestDataHelpers.createCycleCountLine(cycleCount.Id, null, null, 0, 0, 0);
			System.Assert.isTrue(cycleCountLine == null, 'Expected the cycle count creation to fail as No Item Tagged');
		}catch(Exception e){
			System.Assert.isTrue(cycleCountLine == null, 'Expected the cycle count creation to fail as No Item Tagged');
		}
		Test.stopTest();
	}

	
}