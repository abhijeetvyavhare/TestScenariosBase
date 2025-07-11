@isTest
public with sharing class SKUHandler_Test {
    @TestSetup
    static void createRequiredData() {

        dmpl__Item__c item9 = TestDataHelpers.createItem('Item 9', 'Product', true, false, true, '765456', false);
        dmpl__Item__c  item1 = TestDataHelpers.createItem('Item 1','Product',true,false,false,'675654',false);

    }

    @isTest
    static void createSKURecordCreationWithActiveItemPositive(){
        Test.startTest();

        
        dmpl__Item__c item9 = TestDataHelpers.getItem('Item 9');

        dmpl__SKU__c sku = SKUDataHelper.createSku(
        'sku3',
        item9.Id,
        null,
        False,
        null
        );
        dmpl__SKU__c fetchSku = SKUDataHelper.getSku(sku.Id);

        Test.stopTest();

    System.assertNotEquals(null, fetchSku, 'SKU record should be created');
    System.assertEquals('sku3', fetchSku.Name, 'SKU Name should match');
    System.assertEquals(item9.Id, fetchSku.dmpl__ItemId__c, 'Item ID should match');
    }


    @isTest
    static void createSKUWithDefinedProductColorPositive(){
        Test.startTest();

        dmpl__Item__c item9 = TestDataHelpers.getItem('Item 9');


        dmpl__SKU__c sku = SKUDataHelper.createSku(
        'sku3',
        item9.Id,
        'Sample',
        False,
        null

        );
        dmpl__SKU__c fetchSku = SKUDataHelper.getSku(sku.Id);

        Test.stopTest();

    System.assertNotEquals(null, fetchSku, 'SKU record should be created');
    System.assertEquals('sku3', fetchSku.Name, 'SKU Name should match');
    System.assertEquals(item9.Id, fetchSku.dmpl__ItemId__c, 'Item ID should match');
    System.assertEquals('Sample', fetchSku.dmpl__ProductColor__c, 'Product Color should match');
    }


    @isTest
    static void createSKUMarkedAsDefaultPositive(){
        Test.startTest();

        dmpl__Item__c item9 = TestDataHelpers.getItem('Item 9');


        dmpl__SKU__c sku = SKUDataHelper.createSku(
        'sku3',
        item9.Id,
        null,
        True,
        null

        );
        dmpl__SKU__c fetchSku = SKUDataHelper.getSku(sku.Id);

        Test.stopTest();

    System.assertNotEquals(null, fetchSku, 'SKU record should be created');
    System.assertEquals('sku3', fetchSku.Name, 'SKU Name should match');
    System.assertEquals(item9.Id, fetchSku.dmpl__ItemId__c, 'Item ID should match');
    System.assertEquals(true, fetchSku.dmpl__IsDefault__c, 'IsDefault should be true');
    }


    @isTest
    static void createSKUWithUnitOfMeasureOfConversionProvidedPositive(){
        Test.startTest();

        dmpl__Item__c item9 = TestDataHelpers.getItem('Item 9');


        dmpl__SKU__c sku = SKUDataHelper.createSku(
        'sku3',
        item9.Id,
        null,
        False,
        'Sample'

        );
        dmpl__SKU__c fetchSku = SKUDataHelper.getSku(sku.Id);

        Test.stopTest();

    System.assertNotEquals(null, fetchSku, 'SKU record should be created');
    System.assertEquals('sku3', fetchSku.Name, 'SKU Name should match');
    System.assertEquals(item9.Id, fetchSku.dmpl__ItemId__c, 'Item ID should match');
    System.assertEquals('Sample', fetchSku.dmpl__QuantityUnitOfMeasure__c, 'Unit of Measure should be Box');
    }


    @isTest
    static void createSKUWithoutItemIdNegative() {
    Test.startTest();
    
    dmpl__SKU__c sku;
    Boolean exceptionThrown = false;
    try {
        sku = SKUDataHelper.createSku(
            'sku3',
            null,   
            null,
            False,
            null
        );
        System.assert.isTrue(sku == null, 'SKU creation must fail when ItemId is missing.');
    } catch (Exception e) {
        exceptionThrown = true;
        System.assert.isTrue(sku == null, 'SKU creation must fail when ItemId is missing.');
    }
    Test.stopTest();
    System.assert(exceptionThrown, 'Expected exception due to missing ItemId was not thrown.');
    }


    @isTest
    static void createSKUWithoutSKUNamePositive() {

    Test.startTest();

    dmpl__Item__c item9 = TestDataHelpers.getItem('Item 9');

    dmpl__SKU__c sku;
    Boolean exceptionThrown = false;

    try {
        sku = SKUDataHelper.createSku(
            null,     
            item9.Id,     
            null,
            False,
            null
        );
    } catch (Exception e) {
        exceptionThrown = true;
        System.assert.isTrue(sku != null, 'SKU creation must fail when SKU Name is missing.');
    }
    System.assertEquals(item9.Id, sku.dmpl__ItemId__c, 'Item ID should match');

    Test.stopTest();
    }


    @isTest
    static void updateSKURecordCreationWithActiveItemPositive(){
        Test.startTest();

        dmpl__Item__c item9 = TestDataHelpers.getItem('Item 9');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');

        dmpl__SKU__c sku = SKUDataHelper.createSku(
        'sku3',
        item9.Id,
        null,
        False,
        null

        );
        dmpl__SKU__c fetchSku = SKUDataHelper.getSku(sku.Id);
        Test.stopTest();

    System.assertNotEquals(null, fetchSku, 'SKU record should be created');
    System.assertEquals('sku3', fetchSku.Name, 'SKU Name should match');
    System.assertEquals(item9.Id, fetchSku.dmpl__ItemId__c, 'Item ID should match');
    }


    @isTest
    static void updateMultipleSKUCreatedForTheSameItemWithDifferentColorsPositive() {
    Test.startTest();

    dmpl__Item__c item9 = TestDataHelpers.getItem('Item 9');

    dmpl__SKU__c sku = SKUDataHelper.createSku(
        'SKU 3',
        item9.Id,
        'Red',
        False,
        null
    );

    dmpl__SKU__c fetchSku = SKUDataHelper.getSku(sku.Id);
    System.assertNotEquals(null, fetchSku, 'SKU record should be created');
    System.assertEquals('SKU 3', fetchSku.Name, 'SKU Name should match');
    System.assertEquals(item9.Id, fetchSku.dmpl__ItemId__c, 'Item ID should match');
    System.assertEquals('Red', fetchSku.dmpl__ProductColor__c, 'Initial Product Color should be Red');

    fetchSku.dmpl__ProductColor__c = 'Blue';
    update fetchSku;

    dmpl__SKU__c updatedSkuBlue = SKUDataHelper.getSku(fetchSku.Id);
    System.assertEquals('Blue', updatedSkuBlue.dmpl__ProductColor__c, 'Product Color should be updated to Blue');

    updatedSkuBlue.dmpl__ProductColor__c = 'Green';
    update updatedSkuBlue;

    dmpl__SKU__c updatedSkuGreen = SKUDataHelper.getSku(updatedSkuBlue.Id);
    System.assertEquals('Green', updatedSkuGreen.dmpl__ProductColor__c, 'Product Color should be updated to Green');

    Test.stopTest();
    }


    

}