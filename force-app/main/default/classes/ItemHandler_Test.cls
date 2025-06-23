@isTest
public with sharing class ItemHandler_Test {
     @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__Item__c item = ItemDataHelper.createItem('Test Item', 'TEST123'); 
        dmpl__ItemUnitOfMeasure__c itemUOM = ItemDataHelper.createItemUnitOfMeasure(item, 'Test UOM', 1); 

        dmpl__ItemLotType__c itemLotType = ItemDataHelper.createItemLotType(
            item,
            'Test Lot Type',
            true,
            false,
            true
        );  
        dmpl__ItemFeature__c itemFeature = ItemDataHelper.createItemFeature(item, 'Test Feature', 1, 1);
        dmpl__ItemAlias__c itemAlias = ItemDataHelper.createItemAlias(
            item,
            itemLotType,
            'Test Alias'
        );
        dmpl__ItemAlternate__c itemAlternate = ItemDataHelper.createItemAlternate(
            item,
            100.0,
            50.0
        );
        dmpl__ItemServiceContract__c itemServiceContract = ItemDataHelper.createItemServiceContract(
            item,
            true,
            true,
            false,
            true,
            false,
            true
        );
        dmpl__ItemServiceContractLine__c contractLine = ItemDataHelper.createItemServiceContractLine(
            itemServiceContract,
            true,
            10.0
        );
        dmpl__ItemRelation__c itemRelation = ItemDataHelper.createItemRelation(
            item,
            100.0,
            5.0
        );
        dmpl__ItemMaintenanceSchedule__c itemMaintenanceSchedule = ItemDataHelper.createItemMaintenanceSchedule(item);
        dmpl__ItemMaintenanceScheduleDetails__c scheduleDetails = ItemDataHelper.createItemMaintenanceScheduleDetails(itemMaintenanceSchedule.Id);
        dmpl__ItemInventoryAttribute__c inventoryAttribute = ItemDataHelper.createItemInventoryAttribute(item);
        dmpl__ItemImageDetail__c imageDetail = ItemDataHelper.createItemImageDetail(item);
        dmpl__SKU__c sku = ItemDataHelper.createSKU(true, item);
        dmpl__Item__c componentItem = ItemDataHelper.createItem('Component Item', 'COMP123');
        dmpl__ItemComponent__c itemComponent = ItemDataHelper.createItemComponent(
            item,
            componentItem,
            itemFeature,
            'Multiple Of Package',
            2
        );
    }
 
    @isTest
    static void createItemPositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        System.assert(item != null, 'Item should be created');
        System.assertEquals('Test Item', item.Name, 'Item name should be Test Item');
        System.assertEquals('TEST123', item.dmpl__ItemCode__c, 'Item code should be TEST123');
        System.assertEquals(true, item.dmpl__IsPackage__c, 'Item should be a package');
        System.assertEquals(40, item.dmpl__ServiceDurationInMinutes__c, 'Service duration should be 40 minutes');
    }

    @isTest
    static void updateItemPositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        item.dmpl__IsPackage__c = false;
        update item;
        dmpl__Item__c updatedItem = ItemDataHelper.getItemByCode('TEST123');
        System.assertEquals(false, updatedItem.dmpl__IsPackage__c, 'Item should not be a package');

    }

    @isTest
    static void deleteItem() {
        dmpl__Item__c testItem = ItemDataHelper.createItem('Test Item1', 'TEST456');
        
        System.assertNotEquals(null, testItem, 'Item should be created before delete.');
        System.assertNotEquals(null, testItem.Id, 'Item ID should not be null.');
        
        delete testItem;
        
        dmpl__Item__c deletedItem = null;
        try {
            deletedItem = ItemDataHelper.getItemByCode('TEST456');
        } catch (Exception e) {
            deletedItem = null;
        }
        
        System.assertEquals(null, deletedItem, 'Item should be deleted and not found in query.');
    }

    @isTest
    static void createItemUnitOfMeasurePositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
         dmpl__ItemUnitOfMeasure__c itemUOM=ItemDataHelper.getItemUnitOfMeasure(item.Id);
        System.assert(itemUOM != null, 'Item unit of measure should be created');
        System.assertEquals('Test UOM', itemUOM.Name, 'Item unit of measure name should be Test UOM');
    }

    @isTest
    static void updateItemUnitOfMeasurePositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemUnitOfMeasure__c itemUOM = ItemDataHelper.getItemUnitOfMeasure(item.Id);
        itemUOM.dmpl__ConversionRatio__c = 2;
        update itemUOM;
        dmpl__ItemUnitOfMeasure__c updatedItemUOM = ItemDataHelper.getItemUnitOfMeasure(item.Id);
        System.assertEquals(2, updatedItemUOM.dmpl__ConversionRatio__c, 'Item unit of measure conversion ratio should be 2');
    }

    @isTest
    static void deleteItemUnitOfMeasurePositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemUnitOfMeasure__c itemUOM = ItemDataHelper.getItemUnitOfMeasure(item.Id);
        
        System.assertNotEquals(null, itemUOM, 'Item unit of measure should be created before delete.');
        System.assertNotEquals(null, itemUOM.Id, 'Item unit of measure ID should not be null.');
        
        delete itemUOM;
        
        dmpl__ItemUnitOfMeasure__c deletedItemUOM = null;
        try {
            deletedItemUOM = ItemDataHelper.getItemUnitOfMeasure(item.Id);
        } catch (Exception e) {
            deletedItemUOM = null;
        }
        
        System.assertEquals(null, deletedItemUOM, 'Item unit of measure should be deleted and not found in query.');
    }
    
    @isTest
    static void createItemLotTypePositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemLotType__c itemLotType = ItemDataHelper.getItemLotType(item.Id);
        System.assert(itemLotType != null, 'Item lot type should be created');
        System.assertEquals('Test Lot Type', itemLotType.Name, 'Item lot type name should be Test Lot Type');
        System.assertEquals(true, itemLotType.dmpl__IsSample__c, 'Item lot type should be marked as sample');
        System.assertEquals(false, itemLotType.dmpl__IsSaleable__c, 'Item lot type should not be marked as saleable');
        System.assertEquals(true, itemLotType.dmpl__IsPromo__c, 'Item lot type should be marked as promo');
    }

    @isTest 
    static void updateItemLotTypePositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemLotType__c itemLotType = ItemDataHelper.getItemLotType(item.Id);
        
        dmpl__ItemLotType__c updatedItemLotType = ItemDataHelper.updateItemLotType(
            itemLotType,
            'Updated Lot Type',
            false,
            true,
            false
        );
        
        System.assertEquals('Updated Lot Type', updatedItemLotType.Name, 'Item lot type name should be Updated Lot Type');
        System.assertEquals(false, updatedItemLotType.dmpl__IsSample__c, 'Item lot type should not be marked as sample');
        System.assertEquals(true, updatedItemLotType.dmpl__IsSaleable__c, 'Item lot type should be marked as saleable');
        System.assertEquals(false, updatedItemLotType.dmpl__IsPromo__c, 'Item lot type should not be marked as promo');
    }
    
    @isTest
    static void deleteItemLotType() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        
        dmpl__ItemLotType__c itemLotType = ItemDataHelper.getItemLotType(item.Id);
        
        System.assertNotEquals(null, itemLotType, 'Item Lot Type should be created before delete.');
        System.assertNotEquals(null, itemLotType.Id, 'Item Lot Type ID should not be null.');
        
        delete itemLotType;
        
        dmpl__ItemLotType__c deletedLotType = null;
        try {
            deletedLotType = ItemDataHelper.getItemLotType(item.Id);
        } catch (Exception e) {
            deletedLotType = null;
        }
        
        System.assertEquals(null, deletedLotType, 'Item Lot Type should be deleted and not found in query.');
    }
    
    @isTest
    static void createItemFeaturePositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemFeature__c itemFeature = ItemDataHelper.getItemFeature(item.Id);
        System.assert(itemFeature != null, 'Item feature should be created');
        System.assertEquals('Test Feature', itemFeature.Name, 'Item feature name should be Test Feature');
        System.assertEquals(1, itemFeature.dmpl__MaxComponentCount__c, 'Item feature max component count should be 1');
        System.assertEquals(1, itemFeature.dmpl__MinComponentCount__c, 'Item feature min component count should be 1');
    }

    @isTest
    static void updateItemFeaturePositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemFeature__c itemFeature = ItemDataHelper.getItemFeature(item.Id);
        
        itemFeature.dmpl__MaxComponentCount__c = 2;
        update itemFeature;
        
        dmpl__ItemFeature__c updatedItemFeature = ItemDataHelper.getItemFeature(item.Id);
        
        System.assertEquals(2, updatedItemFeature.dmpl__MaxComponentCount__c, 'Item feature max component count should be 2');
        System.assertEquals(1, updatedItemFeature.dmpl__MinComponentCount__c, 'Item feature min component count should be 1');
        System.assertEquals('Test Feature', updatedItemFeature.Name, 'Item feature name should be Test Feature');
    }

    @isTest
    static void deleteItemFeature() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
    
        dmpl__ItemFeature__c itemFeature = ItemDataHelper.getItemFeature(item.Id);
        
        System.assertNotEquals(null, itemFeature, 'Item Feature should be created before delete.');
        System.assertNotEquals(null, itemFeature.Id, 'Item Feature ID should not be null.');
    
        delete itemFeature;
    
        dmpl__ItemFeature__c deletedFeature = null;
        try {
            deletedFeature = ItemDataHelper.getItemFeature(item.Id);
        } catch (Exception e) {
            deletedFeature = null;
        }
    
        System.assertEquals(null, deletedFeature, 'Item Feature should be deleted and not found in query.');
    }
   
    @isTest
    static void createItemComponentPositive() {
       
        dmpl__Item__c parentItem = ItemDataHelper.getItemByCode('TEST123');
        dmpl__Item__c componentItem = ItemDataHelper.getItemByCode('COMP123');
        dmpl__ItemFeature__c retrievedFeature = ItemDataHelper.getItemFeature(parentItem.Id);
        Test.startTest();
        dmpl__ItemComponent__c itemComponent = ItemDataHelper.createItemComponent(
            parentItem,
            componentItem,
            retrievedFeature,
            'Multiple Of Package',
            2
        );
        Test.stopTest();

        System.assertNotEquals(null, itemComponent, 'Item component should be created');
        System.assertEquals('Multiple Of Package', itemComponent.dmpl__PackageType__c, 'Package type should be Multiple Of Package');
        System.assertEquals(2, itemComponent.dmpl__Quantity__c, 'Quantity should be 2');
    }

    @isTest
    static void updateItemComponentPositive() {
       
        dmpl__Item__c parentItem = ItemDataHelper.getItemByCode('TEST123');
        dmpl__Item__c componentItem = ItemDataHelper.getItemByCode('COMP123');
        dmpl__ItemFeature__c retrievedFeature = ItemDataHelper.getItemFeature(parentItem.Id);
        dmpl__ItemComponent__c itemComponent = ItemDataHelper.createItemComponent(
            parentItem,
            componentItem,
            retrievedFeature,
            'Multiple Of Package',
            2
        );
        Test.startTest();
        dmpl__ItemComponent__c updatedItemComponent = ItemDataHelper.updateItemComponent(
            itemComponent,
            'Independent Of Package',
            3
        );
        Test.stopTest();

        System.assertEquals('Independent Of Package', updatedItemComponent.dmpl__PackageType__c, 'Package type should be Independent Of Package');
        System.assertEquals(3, updatedItemComponent.dmpl__Quantity__c, 'Quantity should be 3');
    }

    @isTest
    static void deleteItemComponentPositive() {
      
        dmpl__Item__c parentItem = ItemDataHelper.getItemByCode('TEST123');
        dmpl__Item__c componentItem = ItemDataHelper.createItem('Component Item', 'COMP123');
        dmpl__ItemFeature__c retrievedFeature = ItemDataHelper.getItemFeature(parentItem.Id);
         
       
        dmpl__ItemComponent__c itemComponent = ItemDataHelper.createItemComponent(
            parentItem,
            componentItem,
            retrievedFeature,
            'Multiple Of Package',
            2
        );
        
        System.assertNotEquals(null, itemComponent, 'Item Component should be created before delete.');
        System.assertNotEquals(null, itemComponent.Id, 'Item Component ID should not be null.');
        
        Test.startTest();
        delete itemComponent;
        
        dmpl__ItemComponent__c deletedComponent = null;
        try {
            deletedComponent = ItemDataHelper.getItemComponent(parentItem.Id, componentItem.Id);
        } catch (Exception e) {
            deletedComponent = null;
        }
        Test.stopTest();
        
        System.assertEquals(null, deletedComponent, 'Item Component should be deleted and not found in query.');
    }

    @isTest
    static void createItemAliasPositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        

        dmpl__ItemLotType__c lotType = ItemDataHelper.getItemLotType(item.Id);
        
        Test.startTest();
        dmpl__ItemAlias__c itemAlias = ItemDataHelper.getItemAlias(item.Id);
        Test.stopTest();

        System.assertNotEquals(null, itemAlias, 'Item Alias should be created');
        System.assertEquals('Test Alias', itemAlias.Name, 'Alias name should be Test Alias');
        System.assertEquals(item.Id, itemAlias.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(lotType.Id, itemAlias.dmpl__ItemLotTypeId__c, 'Lot Type ID should match');
    }

    @isTest
    static void updateItemAliasPositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        
        dmpl__ItemLotType__c originalLotType = ItemDataHelper.getItemLotType(item.Id);
        
        dmpl__ItemAlias__c itemAlias = ItemDataHelper.getItemAlias(item.Id);
        
       
        dmpl__ItemLotType__c newLotType = ItemDataHelper.createItemLotType(
            item,
            'New Lot Type',
            false,
            true,
            true
        );
        
        Test.startTest();
        dmpl__ItemAlias__c updatedAlias = ItemDataHelper.updateItemAlias(
            itemAlias,
            'Updated Alias',
            newLotType
        );
        Test.stopTest();

        System.assertEquals('Updated Alias', updatedAlias.Name, 'Alias name should be updated');
        System.assertEquals(newLotType.Id, updatedAlias.dmpl__ItemLotTypeId__c, 'Lot Type should be updated');
    }

    @isTest
    static void deleteItemAliasPositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        
        dmpl__ItemLotType__c lotType = ItemDataHelper.getItemLotType(item.Id);
        dmpl__ItemAlias__c itemAlias = ItemDataHelper.getItemAlias(item.Id);
        
        System.assertNotEquals(null, itemAlias, 'Item Alias should be created before delete');
        System.assertNotEquals(null, itemAlias.Id, 'Item Alias ID should not be null');
        
        Test.startTest();
        delete itemAlias;
        
        dmpl__ItemAlias__c deletedAlias = null;
        try {
            deletedAlias = ItemDataHelper.getItemAlias(item.Id);
        } catch (Exception e) {
            deletedAlias = null;
        }
        Test.stopTest();
        
        System.assertEquals(null, deletedAlias, 'Item Alias should be deleted and not found in query');
    }

    @isTest
    static void createItemAlternatePositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        
        dmpl__ItemAlternate__c itemAlternate = ItemDataHelper.getItemAlternate(item.Id);
        
        System.assertNotEquals(null, itemAlternate, 'Item Alternate should be created');
        System.assertNotEquals(null, itemAlternate.Id, 'Item Alternate ID should not be null');
        System.assertEquals(item.Id, itemAlternate.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(100.0, itemAlternate.dmpl__QuantityAvailable__c, 'Quantity Available should match');
        System.assertEquals(50.0, itemAlternate.dmpl__QuantityInHand__c, 'Quantity In Hand should match');
    }

    @isTest 
    static void updateItemAlternatePositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        
        dmpl__ItemAlternate__c itemAlternate = ItemDataHelper.getItemAlternate(item.Id);
        
        Test.startTest();
        dmpl__ItemAlternate__c updatedAlternate = ItemDataHelper.updateItemAlternate(
            itemAlternate,
            200.0,
            150.0
        );
        Test.stopTest();

        System.assertEquals(200.0, updatedAlternate.dmpl__QuantityAvailable__c, 'Quantity Available should be updated');
        System.assertEquals(150.0, updatedAlternate.dmpl__QuantityInHand__c, 'Quantity In Hand should be updated');
    }

    @isTest
    static void deleteItemAlternatePositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        
        dmpl__ItemAlternate__c itemAlternate = ItemDataHelper.getItemAlternate(item.Id);
        
        System.assertNotEquals(null, itemAlternate, 'Item Alternate should be created before delete');
        System.assertNotEquals(null, itemAlternate.Id, 'Item Alternate ID should not be null');
        
        Test.startTest();
        delete itemAlternate;
        
        dmpl__ItemAlternate__c deletedAlternate = null;
        try {
            deletedAlternate = ItemDataHelper.getItemAlternate(item.Id);
        } catch (Exception e) {
            deletedAlternate = null;
        }
        Test.stopTest();
        
        System.assertEquals(null, deletedAlternate, 'Item Alternate should be deleted and not found in query');
    }
    
    @isTest
    static void createItemServiceContractPositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        
        Test.startTest();
        dmpl__ItemServiceContract__c itemServiceContract = ItemDataHelper.getItemServiceContract(item.Id);
        Test.stopTest();

        System.assertNotEquals(null, itemServiceContract, 'Item Service Contract should be created');
        System.assertEquals(item.Id, itemServiceContract.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(true, itemServiceContract.dmpl__ActiveServiceContractRequired__c, 'Active Service Contract Required should be true');
        System.assertEquals(true, itemServiceContract.dmpl__BillToPartnerAccount__c, 'Bill To Partner Account should be true');
        System.assertEquals(false, itemServiceContract.dmpl__IsScopeRestricted__c, 'Is Scope Restricted should be false');
        System.assertEquals(true, itemServiceContract.dmpl__PopulateContractLines__c, 'Populate Contract Lines should be true');
        System.assertEquals(false, itemServiceContract.dmpl__RestrictAssetContractLinesGeneration__c, 'Restrict Asset Contract Lines Generation should be false');
        System.assertEquals(true, itemServiceContract.dmpl__SingleUseContract__c, 'Single Use Contract should be true');
    }

    @isTest
    static void updateItemServiceContractPositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        
        dmpl__ItemServiceContract__c itemServiceContract = ItemDataHelper.getItemServiceContract(item.Id);
        
        Test.startTest();
        dmpl__ItemServiceContract__c updatedContract = ItemDataHelper.updateItemServiceContract(
            itemServiceContract,
            false,
            false,
            true,
            false,
            true,
            false
        );
        Test.stopTest();

        System.assertEquals(false, updatedContract.dmpl__ActiveServiceContractRequired__c, 'Active Service Contract Required should be updated to false');
        System.assertEquals(false, updatedContract.dmpl__BillToPartnerAccount__c, 'Bill To Partner Account should be updated to false');
        System.assertEquals(true, updatedContract.dmpl__IsScopeRestricted__c, 'Is Scope Restricted should be updated to true');
        System.assertEquals(false, updatedContract.dmpl__PopulateContractLines__c, 'Populate Contract Lines should be updated to false');
        System.assertEquals(true, updatedContract.dmpl__RestrictAssetContractLinesGeneration__c, 'Restrict Asset Contract Lines Generation should be updated to true');
        System.assertEquals(false, updatedContract.dmpl__SingleUseContract__c, 'Single Use Contract should be updated to false');
    }

    @isTest
    static void deleteItemServiceContractPositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        
        dmpl__ItemServiceContract__c itemServiceContract = ItemDataHelper.getItemServiceContract(item.Id);
        System.assertNotEquals(null, itemServiceContract, 'Item Service Contract should be created before delete');
        System.assertNotEquals(null, itemServiceContract.Id, 'Item Service Contract ID should not be null');
        
        Test.startTest();
        delete itemServiceContract;
        
        dmpl__ItemServiceContract__c deletedContract = null;
        try {
            deletedContract = ItemDataHelper.getItemServiceContract(item.Id);
        } catch (Exception e) {
            deletedContract = null;
        }
        Test.stopTest();
        
        System.assertEquals(null, deletedContract, 'Item Service Contract should be deleted and not found in query');
    }

    @isTest
    static void createItemServiceContractLinePositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        
        
        dmpl__ItemServiceContract__c itemServiceContract = ItemDataHelper.getItemServiceContract(item.Id);
        Test.startTest();
        dmpl__ItemServiceContractLine__c contractLine = ItemDataHelper.getItemServiceContractLine(itemServiceContract.Id);
        Test.stopTest();

        System.assertNotEquals(null, contractLine, 'Contract Line should be created');
        System.assertNotEquals(null, contractLine.Id, 'Contract Line ID should not be null');
        System.assertEquals(itemServiceContract.Id, contractLine.dmpl__ItemServiceContractId__c, 'Service Contract ID should match');
        System.assertEquals(true, contractLine.dmpl__IsInScope__c, 'Is In Scope should be true');
        System.assertEquals(10.0, contractLine.dmpl__Quantity__c, 'Quantity should be 10');
    }

    @isTest
    static void updateItemServiceContractLinePositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        
        dmpl__ItemServiceContract__c itemServiceContract = ItemDataHelper.getItemServiceContract(item.Id);
        
        dmpl__ItemServiceContractLine__c contractLine = ItemDataHelper.getItemServiceContractLine(itemServiceContract.Id);
        Test.startTest();
        dmpl__ItemServiceContractLine__c updatedContractLine = ItemDataHelper.updateItemServiceContractLine(
            contractLine,
            false,
            20.0
        );
        Test.stopTest();

        System.assertEquals(false, updatedContractLine.dmpl__IsInScope__c, 'Is In Scope should be updated to false');
        System.assertEquals(20.0, updatedContractLine.dmpl__Quantity__c, 'Quantity should be updated to 20');
    }

    @isTest
    static void deleteItemServiceContractLinePositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        
        dmpl__ItemServiceContract__c itemServiceContract = ItemDataHelper.getItemServiceContract(item.Id);
        
        dmpl__ItemServiceContractLine__c contractLine = ItemDataHelper.getItemServiceContractLine(itemServiceContract.Id);
        
        System.assertNotEquals(null, contractLine, 'Contract Line should be created before delete');
        System.assertNotEquals(null, contractLine.Id, 'Contract Line ID should not be null');
        
        Test.startTest();
        delete contractLine;
        
        dmpl__ItemServiceContractLine__c deletedContractLine = null;
        try {
            deletedContractLine = ItemDataHelper.getItemServiceContractLine(itemServiceContract.Id);
        } catch (Exception e) {
            deletedContractLine = null;
        }
        Test.stopTest();
        
        System.assertEquals(null, deletedContractLine, 'Contract Line should be deleted and not found in query');
    }

    @isTest
    static void createItemRelationPositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        
        Test.startTest();
        dmpl__ItemRelation__c itemRelation = ItemDataHelper.getItemRelation(item.Id);
        Test.stopTest();

        System.assertNotEquals(null, itemRelation, 'Item Relation should be created');
        System.assertEquals(item.Id, itemRelation.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(100.0, itemRelation.dmpl__Price__c, 'Price should be 100');
        System.assertEquals(5.0, itemRelation.dmpl__Quantity__c, 'Quantity should be 5');
    }

    @isTest
    static void updateItemRelationPositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        
        dmpl__ItemRelation__c itemRelation = ItemDataHelper.getItemRelation(item.Id);
        
        Test.startTest();
        dmpl__ItemRelation__c updatedItemRelation = ItemDataHelper.updateItemRelation(
            itemRelation,
            200.0,
            10.0
        );
        Test.stopTest();

        System.assertEquals(200.0, updatedItemRelation.dmpl__Price__c, 'Price should be updated to 200');
        System.assertEquals(10.0, updatedItemRelation.dmpl__Quantity__c, 'Quantity should be updated to 10');
    }

    @isTest
    static void deleteItemRelationPositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        
        dmpl__ItemRelation__c itemRelation = ItemDataHelper.getItemRelation(item.Id);
        
        System.assertNotEquals(null, itemRelation, 'Item Relation should be created before delete');
        System.assertNotEquals(null, itemRelation.Id, 'Item Relation ID should not be null');
        
        Test.startTest();
        delete itemRelation;
        
        dmpl__ItemRelation__c deletedItemRelation = null;
        try {
            deletedItemRelation = ItemDataHelper.getItemRelation(item.Id);
        } catch (Exception e) {
            deletedItemRelation = null;
        }
        Test.stopTest();
        
        System.assertEquals(null, deletedItemRelation, 'Item Relation should be deleted and not found in query');
    }

    @isTest
    static void createItemMaintenanceSchedulePositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        
        Test.startTest();
        dmpl__ItemMaintenanceSchedule__c itemMaintenanceSchedule = ItemDataHelper.getItemMaintenanceSchedule(item.Id);
        Test.stopTest();

        System.assertNotEquals(null, itemMaintenanceSchedule, 'Item Maintenance Schedule should be created');
        System.assertEquals(1, itemMaintenanceSchedule.dmpl__Sequence__c, 'Sequence should be 1');
        System.assertEquals(30, itemMaintenanceSchedule.dmpl__ToDurationDays__c, 'Duration Days should be 30');
        System.assertEquals(100.00, itemMaintenanceSchedule.dmpl__ToUsageHours__c, 'Usage Hours should be 100');
        System.assertEquals(1000.00, itemMaintenanceSchedule.dmpl__ToUsageReading__c, 'Usage Reading should be 1000');
    }

    @isTest
    static void updateItemMaintenanceSchedulePositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        
        dmpl__ItemMaintenanceSchedule__c itemMaintenanceSchedule = ItemDataHelper.getItemMaintenanceSchedule(item.Id);
        
        Test.startTest();
        dmpl__ItemMaintenanceSchedule__c updatedSchedule = ItemDataHelper.updateItemMaintenanceSchedule(item);
        Test.stopTest();

        System.assertEquals(2, updatedSchedule.dmpl__Sequence__c, 'Sequence should be updated to 2');
        System.assertEquals(60, updatedSchedule.dmpl__ToDurationDays__c, 'Duration Days should be updated to 60');
        System.assertEquals(200.00, updatedSchedule.dmpl__ToUsageHours__c, 'Usage Hours should be updated to 200');
        System.assertEquals(2000.00, updatedSchedule.dmpl__ToUsageReading__c, 'Usage Reading should be updated to 2000');
    }

    @isTest
    static void deleteItemMaintenanceSchedulePositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        
        dmpl__ItemMaintenanceSchedule__c itemMaintenanceSchedule = ItemDataHelper.getItemMaintenanceSchedule(item.Id);
        
        System.assertNotEquals(null, itemMaintenanceSchedule, 'Item Maintenance Schedule should be created before delete');
        System.assertNotEquals(null, itemMaintenanceSchedule.Id, 'Item Maintenance Schedule ID should not be null');
        
        Test.startTest();
        delete itemMaintenanceSchedule;
        
        dmpl__ItemMaintenanceSchedule__c deletedSchedule = null;
        try {
            deletedSchedule = ItemDataHelper.getItemMaintenanceSchedule(item.Id);
        } catch (Exception e) {
            deletedSchedule = null;
        }
        Test.stopTest();
        
        System.assertEquals(null, deletedSchedule, 'Item Maintenance Schedule should be deleted and not found in query');
    }
    
    @isTest
    static void createItemMaintenanceScheduleDetailsPositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemMaintenanceSchedule__c itemMaintenanceSchedule = ItemDataHelper.getItemMaintenanceSchedule(item.Id);
        
        Test.startTest();
        dmpl__ItemMaintenanceScheduleDetails__c scheduleDetails = ItemDataHelper.getItemMaintenanceScheduleDetails(itemMaintenanceSchedule.Id);
        Test.stopTest();

        System.assertNotEquals(null, scheduleDetails, 'Item Maintenance Schedule Details should be created');
        System.assertEquals(Date.today(), scheduleDetails.dmpl__LastServiceDate__c, 'Last Service Date should be today');
    }

    @isTest 
    static void updateItemMaintenanceScheduleDetailsPositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemMaintenanceSchedule__c itemMaintenanceSchedule = ItemDataHelper.getItemMaintenanceSchedule(item.Id);
        dmpl__ItemMaintenanceScheduleDetails__c scheduleDetails = ItemDataHelper.getItemMaintenanceScheduleDetails(itemMaintenanceSchedule.Id);
        
        Test.startTest();
        dmpl__ItemMaintenanceScheduleDetails__c updatedDetails = ItemDataHelper.updateItemMaintenanceScheduleDetails(itemMaintenanceSchedule.Id);
        Test.stopTest();

        System.assertEquals(Date.today().addDays(30), updatedDetails.dmpl__LastServiceDate__c, 'Last Service Date should be updated to 30 days from today');
    }

    @isTest
    static void deleteItemMaintenanceScheduleDetailsPositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemMaintenanceSchedule__c itemMaintenanceSchedule = ItemDataHelper.getItemMaintenanceSchedule(item.Id);
        dmpl__ItemMaintenanceScheduleDetails__c scheduleDetails = ItemDataHelper.getItemMaintenanceScheduleDetails(itemMaintenanceSchedule.Id);
        
        System.assertNotEquals(null, scheduleDetails, 'Item Maintenance Schedule Details should be created before delete');
        System.assertNotEquals(null, scheduleDetails.Id, 'Item Maintenance Schedule Details ID should not be null');
        
        Test.startTest();
        delete scheduleDetails;
        
        dmpl__ItemMaintenanceScheduleDetails__c deletedDetails = null;
        try {
            deletedDetails = ItemDataHelper.getItemMaintenanceScheduleDetails(itemMaintenanceSchedule.Id);
        } catch (Exception e) {
            deletedDetails = null;
        }
        Test.stopTest();
        
        System.assertEquals(null, deletedDetails, 'Item Maintenance Schedule Details should be deleted and not found in query');
    }
     
    @isTest
    static void createItemInventoryAttributePositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        
        Test.startTest();
        dmpl__ItemInventoryAttribute__c inventoryAttribute = ItemDataHelper.getItemInventoryAttribute(item.Id);
        Test.stopTest();

        System.assertNotEquals(null, inventoryAttribute, 'Item Inventory Attribute should be created');
        System.assertEquals(1000.00, inventoryAttribute.dmpl__MaximumStockLevel__c, 'Maximum Stock Level should be 1000');
        System.assertEquals(10.00, inventoryAttribute.dmpl__MinimumOrderQuantity__c, 'Minimum Order Quantity should be 10');
        System.assertEquals(100.00, inventoryAttribute.dmpl__MinimumStockLevel__c, 'Minimum Stock Level should be 100');
        System.assertEquals(500.00, inventoryAttribute.dmpl__MaximumOrderQuantity__c, 'Maximum Order Quantity should be 500');
    }

    @isTest
    static void updateItemInventoryAttributePositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemInventoryAttribute__c inventoryAttribute = ItemDataHelper.getItemInventoryAttribute(item.Id);
        
        Test.startTest();
        dmpl__ItemInventoryAttribute__c updatedAttribute = ItemDataHelper.updateItemInventoryAttribute(item);
        Test.stopTest();

        System.assertEquals(2000.00, updatedAttribute.dmpl__MaximumStockLevel__c, 'Maximum Stock Level should be updated to 2000');
        System.assertEquals(20.00, updatedAttribute.dmpl__MinimumOrderQuantity__c, 'Minimum Order Quantity should be updated to 20');
        System.assertEquals(200.00, updatedAttribute.dmpl__MinimumStockLevel__c, 'Minimum Stock Level should be updated to 200');
        System.assertEquals(1000.00, updatedAttribute.dmpl__MaximumOrderQuantity__c, 'Maximum Order Quantity should be updated to 1000');
    }

    @isTest
    static void deleteItemInventoryAttributePositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemInventoryAttribute__c inventoryAttribute = ItemDataHelper.getItemInventoryAttribute(item.Id);
        
        System.assertNotEquals(null, inventoryAttribute, 'Item Inventory Attribute should be created before delete');
        System.assertNotEquals(null, inventoryAttribute.Id, 'Item Inventory Attribute ID should not be null');
        
        Test.startTest();
        delete inventoryAttribute;
        
        dmpl__ItemInventoryAttribute__c deletedAttribute = null;
        try {
            deletedAttribute = ItemDataHelper.getItemInventoryAttribute(item.Id);
        } catch (Exception e) {
            deletedAttribute = null;
        }
        Test.stopTest();
        
        System.assertEquals(null, deletedAttribute, 'Item Inventory Attribute should be deleted and not found in query');
    }
    
    @isTest
    static void createItemImageDetailPositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        
        Test.startTest();
        dmpl__ItemImageDetail__c imageDetail = ItemDataHelper.getItemImageDetail(item.Id);
        Test.stopTest();

        System.assertNotEquals(null, imageDetail, 'Item Image Detail should be created');
        System.assertEquals('Test Image', imageDetail.Name, 'Name should be Test Image');
        System.assertEquals('https://test-image-url.com', imageDetail.dmpl__LinkUrl__c, 'Link URL should match test URL');
    }

    @isTest 
    static void updateItemImageDetailPositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemImageDetail__c imageDetail = ItemDataHelper.getItemImageDetail(item.Id);
        
        Test.startTest();
        dmpl__ItemImageDetail__c updatedImageDetail = ItemDataHelper.updateItemImageDetail(item);
        Test.stopTest();

        System.assertEquals('Updated Test Image', updatedImageDetail.Name, 'Name should be updated');
        System.assertEquals('https://updated-test-image-url.com', updatedImageDetail.dmpl__LinkUrl__c, 'Link URL should be updated');
    }

    @isTest
    static void deleteItemImageDetailPositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        dmpl__ItemImageDetail__c imageDetail = ItemDataHelper.getItemImageDetail(item.Id);
        
        System.assertNotEquals(null, imageDetail, 'Item Image Detail should be created before delete');
        System.assertNotEquals(null, imageDetail.Id, 'Item Image Detail ID should not be null');
        
        Test.startTest();
        delete imageDetail;
        
        dmpl__ItemImageDetail__c deletedImageDetail = null;
        try {
            deletedImageDetail = ItemDataHelper.getItemImageDetail(item.Id);
        } catch (Exception e) {
            deletedImageDetail = null;
        }
        Test.stopTest();
        
        System.assertEquals(null, deletedImageDetail, 'Item Image Detail should be deleted and not found in query');
    }
     
    @isTest
    static void createSKUPositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        
        Test.startTest();
        List<dmpl__SKU__c> sku = ItemDataHelper.getSKU(item.Id);
        Test.stopTest();

        System.assertNotEquals(null, sku, 'SKU should be created');
        System.assertEquals('Test SKU', sku[0].Name, 'Name should be Test SKU');
        System.assertEquals(true, sku[0].dmpl__IsDefault__c, 'IsDefault should be true');
    }

    @isTest 
    static void updateSKUPositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        List<dmpl__SKU__c> sku = ItemDataHelper.getSKU(item.Id);
        
        Test.startTest();
        dmpl__SKU__c updatedSKU = ItemDataHelper.updateSKU(false, item);
        Test.stopTest();

        System.assertEquals('Updated Test SKU', updatedSKU.Name, 'Name should be updated');
        System.assertEquals(false, updatedSKU.dmpl__IsDefault__c, 'IsDefault should be updated to false');
    }

    @isTest
    static void deleteSKUPositive() {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        List<dmpl__SKU__c> sku = ItemDataHelper.getSKU(item.Id);
        
        System.assertNotEquals(null, sku, 'SKU should be created before delete');
        System.assertNotEquals(null, sku[0].Id, 'SKU ID should not be null');
        
        Test.startTest();
        Database.delete(sku, false);
        
        List<dmpl__SKU__c> deletedSKUs = ItemDataHelper.getSKU(item.Id);
        Test.stopTest();
        
        System.assertEquals(0, deletedSKUs.size(), 'SKU should be deleted and not found in query');
    }
     
}