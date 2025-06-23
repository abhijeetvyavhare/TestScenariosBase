@isTest
public with sharing class InventoryCycleCountHandler_Test {
    @TestSetup
    static void createRequiredData(){
        dmpl__AccountGroup__c accountGroup=TestDataHelpers.createAccountGroup();
        Account partnerAccount=TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch=TestDataHelpers.createBranch(partnerAccount);
        dmpl__Item__c item=TestDataHelpers.createItem();
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation(branch);
        dmpl__ItemLot__c itemLot = TestDataHelpers.createItemLot(branch,item,sku,storageLocation);
        dmpl__InventoryCycleCount__c cycleCount=CycleCountTestDataHelpers.createCycleCount(branch,item);
        dmpl__InventoryCycleCountLine__c cycleCountLine = CycleCountTestDataHelpers.createCycleCountLine(cycleCount, itemLot);
        dmpl__InventoryCycleCountRule__c cycleCountRule = CycleCountTestDataHelpers.createCycleCountRule(cycleCount);
    }
    
    @isTest
    static void createInventoryCycleCountPositive(){
        dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.getCycleCount();
        if(cycleCount != null){
            System.assertNotEquals(cycleCount, null, 'Expected cycleCount to be created.');
        }
        System.assertEquals( false, cycleCount.dmpl__PerformStartCounting__c, 'PerformStartCounting should be false');
        System.assertEquals( false, cycleCount.dmpl__PerformFinishCounting__c, 'PerformFinishCounting should be false');
        System.assertEquals( false, cycleCount.dmpl__PerformReleaseAdjustment__c, 'PerformReleaseAdjustment should be false');
        System.assertEquals( 2, cycleCount.dmpl__MaximumItems__c, 'MaximumItems should be 2');
    }
    
    @isTest
    static void updateInventoryCycleCountPositive() {
        dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.getCycleCount();
        System.assertNotEquals(cycleCount, null, 'Expected cycleCount to be created before update.');
        
        cycleCount.dmpl__PerformStartCounting__c = true;
        cycleCount.dmpl__PerformFinishCounting__c = true;
        cycleCount.dmpl__PerformReleaseAdjustment__c = true;
        cycleCount.dmpl__MaximumItems__c = 5;
        cycleCount.dmpl__PartCostFrom__c = 60;
        cycleCount.dmpl__PartCostTo__c = 70;
        cycleCount.dmpl__PartStockFrom__c = 60;
        cycleCount.dmpl__PartStockTo__c = 70;
        
        update cycleCount;
        
        dmpl__InventoryCycleCount__c updatedCycleCount = CycleCountTestDataHelpers.getCycleCount(cycleCount.Id);
        System.debug(updatedCycleCount);
        System.assertNotEquals(updatedCycleCount, null, 'Expected updated cycleCount to be found.');
        System.assertEquals(5, updatedCycleCount.dmpl__MaximumItems__c, 'MaximumItems should be 5');
    }
    
    @isTest
    static void deleteInventoryCycleCountPositive() {
        dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.getCycleCount();
        
        if (cycleCount != null) {
            System.assertNotEquals(cycleCount, null, 'Expected cycleCount to be created before delete.');
            
            try {
                delete cycleCount;
                System.assert(true, 'Delete operation succeeded.'); 
            } catch (DmlException e) {
                System.assert(false, 'Delete operation failed: ' + e.getMessage());
            }
        } else {
            System.assert(false, 'CycleCount was not found for deletion.');
        }
    }
    
    
    @isTest
    static void createInventoryCycleCountLinePositive() {
        dmpl__InventoryCycleCountLine__c cycleCountLine = CycleCountTestDataHelpers.getCycleCountLine();
        if(cycleCountLine != null){
            System.assertNotEquals(cycleCountLine, null, 'Expected cycleCountLine to be created.');
        }
        System.assertNotEquals(cycleCountLine.Id, null, 'Expected cycleCountLine Id to be not null');
    }
    
    @isTest
    static void updateInventoryCycleCountLineTestPositive() {
        dmpl__InventoryCycleCountLine__c cycleCountLine = CycleCountTestDataHelpers.getCycleCountLine();
        if(cycleCountLine != null){
            System.assertNotEquals(cycleCountLine, null, 'Expected cycleCountLine to be created before update.');
            
            cycleCountLine.dmpl__IsApproved__c = false;
            cycleCountLine.dmpl__UnitCost__c = 150;
            cycleCountLine.dmpl__OnHandQuantity__c = 20;
            cycleCountLine.dmpl__PickedQuantity__c = 10;
            cycleCountLine.dmpl__RecordedQuantity__c = 18;
            cycleCountLine.dmpl__RecordedDamagedQuantity__c = 0;
            cycleCountLine.dmpl__RecordedExpiredQuantity__c = 3;
            cycleCountLine.dmpl__Remarks__c = 'Updated Successfully';
            update cycleCountLine;
        }
        
        dmpl__InventoryCycleCountLine__c updatedLine=CycleCountTestDataHelpers.getCycleCountLine();
        System.assertEquals(10, updatedLine.dmpl__PickedQuantity__c, 'PickedQuantity should be 10');
    }
    
    @isTest
    static void deleteInventoryCycleCountLineTestPositive() {
        dmpl__InventoryCycleCountLine__c cycleCountLine = CycleCountTestDataHelpers.getCycleCountLine();
        System.assertNotEquals(null, cycleCountLine, 'Expected cycleCountLine to be created before delete.');
        Id lineId = cycleCountLine.Id;
        delete cycleCountLine;
        dmpl__InventoryCycleCountLine__c deletedLine;
        try {
            deletedLine = CycleCountTestDataHelpers.getCycleCountLine(lineId);
        } catch (Exception e) {
            deletedLine = null;
        }
        System.assertEquals(null, deletedLine, 'Expected cycleCountLine to be deleted.');
    }

    
    @isTest
    static void createInventoryCycleCountRulePositive() {
        dmpl__InventoryCycleCountRule__c cycleCountRule = CycleCountTestDataHelpers.getCycleCountRule();
        if (cycleCountRule != null) {
            System.assertNotEquals(cycleCountRule, null, 'Expected cycleCountRule to be created.');
        }
        System.assertNotEquals(cycleCountRule.name, null, 'Name should not be null');
        System.assertNotEquals(cycleCountRule.dmpl__CycleCountId__c, null, 'Expected dmpl__CycleCountId__c to be set.');
        System.assertEquals('dmpl__ItemId__c', cycleCountRule.dmpl__FieldName__c, 'Expected dmpl__FieldName__c to be dmpl__ItemId__c');
        System.assertEquals('TestValue', cycleCountRule.dmpl__FieldValue__c, 'Expected dmpl__FieldValue__c to be TestValue');
        System.assertEquals('equals', cycleCountRule.dmpl__Operation__c, 'Expected dmpl__Operation__c to be equals');
    }

    @isTest
    static void updateInventoryCycleCountRulePositive() {
        dmpl__InventoryCycleCountRule__c cycleCountRule = CycleCountTestDataHelpers.getCycleCountRule();
        if (cycleCountRule != null) {
            System.assertNotEquals(cycleCountRule, null, 'Expected cycleCountRule to be created before update.');
            cycleCountRule.dmpl__FieldName__c = 'dmpl__ItemLotId__c';
            cycleCountRule.dmpl__FieldValue__c = 'UpdatedValue';
            cycleCountRule.dmpl__Operation__c = 'notEqual';
            update cycleCountRule;
        }
        dmpl__InventoryCycleCountRule__c updatedCycleCountRule = CycleCountTestDataHelpers.getCycleCountRule(cycleCountRule.Id);
        if (updatedCycleCountRule != null) {
            System.assertNotEquals(updatedCycleCountRule, null, 'Expected cycleCountRule to be updated.');
        }
        System.assertEquals('dmpl__ItemLotId__c', updatedCycleCountRule.dmpl__FieldName__c, 'Expected dmpl__FieldName__c to be dmpl__ItemLotId__c');
        System.assertEquals('UpdatedValue', updatedCycleCountRule.dmpl__FieldValue__c, 'Expected dmpl__FieldValue__c to be UpdatedValue');
        System.assertEquals('notEqual', updatedCycleCountRule.dmpl__Operation__c, 'Expected dmpl__Operation__c to be notEqual');
    }

    @isTest
    static void deleteInventoryCycleCountRulePositive() {
        dmpl__InventoryCycleCountRule__c cycleCountRule = CycleCountTestDataHelpers.getCycleCountRule();
        System.assertNotEquals(cycleCountRule, null, 'Expected cycleCountRule to be created before delete.');
        dmpl__InventoryCycleCountRule__c deletedCycleCountRule = null;
        delete cycleCountRule;
        try {
            deletedCycleCountRule = CycleCountTestDataHelpers.getCycleCountRule(cycleCountRule.Id);
        } catch (Exception e) {
           	deletedCycleCountRule=null;
        }
        System.assertEquals(null, deletedCycleCountRule, 'Expected cycleCountRule to be deleted.');
    }
}