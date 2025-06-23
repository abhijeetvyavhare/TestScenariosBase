@isTest
public class FieldSalesLineHandler_Test {
    private static dmpl__FieldSales__c fieldSales;
    private static dmpl__FieldSalesLine__c fieldSalesLine;
    private static dmpl__Item__c item;
    private static dmpl__SKU__c sku;
    
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__Resource__c resource = TestDataHelpers.createResource(partnerAccount, branch);
        item = TestDataHelpers.createItem();
        sku = TestDataHelpers.createSKU(item);
        
        fieldSales = FieldSalesDataHelper.createFieldSales(
            partnerAccount,
            branch,
            resource
        );
        
        fieldSalesLine = FieldSalesDataHelper.createFieldSalesLine(
            fieldSales,
            item,
            sku
        );
    }

    @isTest
    static void createFieldSalesLinePositive() {
        Test.startTest();
        dmpl__FieldSalesLine__c retrievedLine = FieldSalesDataHelper.getFieldSalesLine();
        Test.stopTest();
        
        System.assertNotEquals(null, retrievedLine, 'Expected field sales line to be created');
    }

    @isTest
    static void updateFieldSalesLinePositive() {
        dmpl__FieldSalesLine__c existingLine = FieldSalesDataHelper.getFieldSalesLine();
        
        Test.startTest();
        dmpl__FieldSalesLine__c updatedLine = FieldSalesDataHelper.updateFieldSalesLine(
            FieldSalesDataHelper.getFieldSales(),
            TestDataHelpers.getItem(),
            TestDataHelpers.getSKU(),
            existingLine
        );
        Test.stopTest();

        dmpl__FieldSalesLine__c retrievedLine = FieldSalesDataHelper.getFieldSalesLine(updatedLine.dmpl__FieldSalesId__c);
        
        System.assertNotEquals(null, updatedLine, 'Field Sales Line should not be null after update');
        System.assertEquals(updatedLine.Id, retrievedLine.Id, 'Field sales line IDs should match');
        System.assertEquals(updatedLine.dmpl__FieldSalesId__c, retrievedLine.dmpl__FieldSalesId__c, 'Field sales IDs should match');
        System.assertEquals(updatedLine.dmpl__ItemId__c, retrievedLine.dmpl__ItemId__c, 'Item IDs should match');
        System.assertEquals(updatedLine.dmpl__SKUId__c, retrievedLine.dmpl__SKUId__c, 'SKU IDs should match');
        System.assertEquals(2, retrievedLine.dmpl__Quantity__c, 'Quantity should be updated to 2');
        }

    // @isTest
    // static void deleteFieldSalesLine() {
    //     dmpl__FieldSalesLine__c existingLine = FieldSalesDataHelper.getFieldSalesLine();
        
    //     Test.startTest();
    //     delete existingLine;
    //     Test.stopTest();

    //     dmpl__FieldSalesLine__c deletedLine = null;
    //     try {
    //         deletedLine = FieldSalesDataHelper.getFieldSalesLine(existingLine.Id);
    //     } catch (Exception e) {
    //         deletedLine = null;
    //     }
    //     System.assertEquals(null, deletedLine, 'Field Sales Line should be deleted');
    // }

}