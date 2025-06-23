@isTest
public with sharing class InventoryCycleCountLineHandler_Test {
    @TestSetup
    static void makeData(){
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation(branch);
        dmpl__ItemLot__c itemLot = TestDataHelpers.createItemLot(branch,item,sku,storageLocation);
        dmpl__InventoryCycleCount__c cycleCount = CycleCountTestDataHelpers.createCycleCount(branch, item);
        dmpl__InventoryCycleCountLine__c cycleCountLine = CycleCountTestDataHelpers.createCycleCountLine(cycleCount, itemLot);
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

}