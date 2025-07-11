public with sharing class ItemDataHelper {
    
    public static dmpl__Item__c createItem(
        String name,
        String itemCode
    ) {
        return (dmpl__Item__c) TestFactory.createSObject(
            new dmpl__Item__c(
                Name = name,
                dmpl__ItemCode__c = itemCode,
                dmpl__TrackLots__c=false,
                dmpl__ServiceDurationInMinutes__c=40,
                dmpl__IsPackage__c=true  
            ),
            'ItemDefaults',
            true
        );
    }
	public static dmpl__Item__c createItem(String name) {
        return (dmpl__Item__c) TestFactory.createSObject(
            new dmpl__Item__c(Name = name), true
        );
    }

    public static dmpl__Item__c updateItem(
        dmpl__Item__c item
     ) {
        return (dmpl__Item__c) TestFactory.createSObject(
            new dmpl__Item__c(
                Id = item.Id,
                dmpl__IsPackage__c=false
                
            ),
            'ItemDefaults',
            true
        );
    }

    public static dmpl__Item__c getItemByCode(
        String itemCode
    ) {
        return [
            SELECT Id, Name, dmpl__ItemCode__c, dmpl__TrackLots__c,
                   dmpl__ServiceDurationInMinutes__c, dmpl__IsPackage__c
            FROM dmpl__Item__c 
            WHERE dmpl__ItemCode__c = :itemCode
            LIMIT 1
        ];
    }



    public static dmpl__ItemUnitOfMeasure__c createItemUnitOfMeasure(
        dmpl__Item__c item,
        String name,
        Decimal conversionFactor
    ) {
        return (dmpl__ItemUnitOfMeasure__c) TestFactory.createSObject(
            new dmpl__ItemUnitOfMeasure__c(
                Name = name,
                dmpl__ItemId__c = item.Id,
                dmpl__ConversionRatio__c = conversionFactor
                
            ),
            'ItemUnitOfMeasureDefaults',
            true
        );
    }

    public static dmpl__ItemUnitOfMeasure__c updateItemUnitOfMeasure(
        dmpl__ItemUnitOfMeasure__c itemUOM,
        Decimal newConversionFactor
    ) {
        return (dmpl__ItemUnitOfMeasure__c) TestFactory.createSObject(
            new dmpl__ItemUnitOfMeasure__c(
                Id = itemUOM.Id,
                dmpl__ConversionRatio__c= newConversionFactor
            ),
            'ItemUnitOfMeasureDefaults',
            true
        );
    }

    public static dmpl__ItemUnitOfMeasure__c getItemUnitOfMeasure(
        Id itemId
    ) {
        return [
            SELECT Id, Name, dmpl__ItemId__c, dmpl__ConversionRatio__c
                  
            FROM dmpl__ItemUnitOfMeasure__c
            WHERE dmpl__ItemId__c = :itemId
            LIMIT 1
        ];
    }
    
    public static dmpl__ItemLotType__c createItemLotType(
        dmpl__Item__c item,
        String name,
        Boolean isSample,
        Boolean isSaleable,
        Boolean isPromo
    ) {
        return (dmpl__ItemLotType__c) TestFactory.createSObject(
            new dmpl__ItemLotType__c(
                Name = name,
                dmpl__ItemId__c = item.Id,
                dmpl__IsSample__c = isSample,
                dmpl__IsSaleable__c = isSaleable,
                dmpl__IsPromo__c = isPromo
            ),
            'ItemLotTypeDefaults',
            true
        );
    }

    public static dmpl__ItemLotType__c  createItemLotType(
        dmpl__Item__c item,
        String name,
        Decimal mrp,
        Id ExternalItemCode
    ) {
        return (dmpl__ItemLotType__c) TestFactory.createSObject(
            new dmpl__ItemLotType__c(
                Name = name,
                dmpl__ItemId__c = item.Id,
                dmpl__MRP__c  = mrp,
                dmpl__ExternalItemCode__c = ExternalItemCode    
            ),
            'ItemLotTypeDefaults',
            true
        );
    }

    public static dmpl__ItemLotType__c updateItemLotType(
        dmpl__ItemLotType__c itemLotType,
        String newName,
        Boolean isSample,
        Boolean isSaleable,
        Boolean isPromo
    ) {
        return (dmpl__ItemLotType__c) TestFactory.createSObject(
            new dmpl__ItemLotType__c(
                Name = newName,
                dmpl__IsSample__c = isSample,
                dmpl__IsSaleable__c = isSaleable,
                dmpl__IsPromo__c = isPromo
            ),
            'ItemLotTypeDefaults',
            true
        );
    }

    public static dmpl__ItemLotType__c getItemLotType(
        Id itemId
    ) {
        return [
            SELECT Id, Name, dmpl__ItemId__c, IsDeleted, 
                   dmpl__IsSample__c, dmpl__IsSaleable__c, dmpl__IsPromo__c, dmpl__MRP__c,dmpl__ExternalItemCode__c
            FROM dmpl__ItemLotType__c
            WHERE dmpl__ItemId__c = :itemId
            LIMIT 1
        ];
    }
    
    public static dmpl__ItemLotType__c getItemLotType(
       dmpl__ItemLotType__c itemLotType 
    ) {
        return [
            SELECT Id, Name, dmpl__ItemId__c, IsDeleted, 
                   dmpl__IsSample__c, dmpl__IsSaleable__c, dmpl__IsPromo__c,dmpl__MRP__c,dmpl__ExternalItemCode__c
            FROM dmpl__ItemLotType__c
            WHERE Id = :itemLotType.Id
            LIMIT 1
        ];
    }
    

    public static dmpl__ItemFeature__c createItemFeature(
        dmpl__Item__c item,
        String name,
        Decimal maxComponentCount,
        Decimal minComponentCount
    ) {
        return (dmpl__ItemFeature__c) TestFactory.createSObject(
            new dmpl__ItemFeature__c(
                Name = name,
                dmpl__ItemId__c = item.Id,
                dmpl__MaxComponentCount__c = maxComponentCount,
                dmpl__MinComponentCount__c = minComponentCount
            ),
            'ItemFeatureDefaults',
            true
        );
    }

    public static dmpl__ItemFeature__c updateItemFeature(
        dmpl__ItemFeature__c itemFeature,
        String newName,
        Decimal maxComponentCount,
        Decimal minComponentCount
    ) {
        Id existingItemId = itemFeature.dmpl__ItemId__c;
        return (dmpl__ItemFeature__c) TestFactory.createSObject(
            new dmpl__ItemFeature__c(
                Name = newName,
                 dmpl__ItemId__c = existingItemId,
                dmpl__MaxComponentCount__c = maxComponentCount,
                dmpl__MinComponentCount__c = minComponentCount
            ),
            'ItemFeatureDefaults',
            true
        );
    }

    public static dmpl__ItemFeature__c getItemFeature(
        Id itemId
    ) {
        return [
            SELECT Id, Name, dmpl__ItemId__c,
                   dmpl__MaxComponentCount__c, dmpl__MinComponentCount__c
            FROM dmpl__ItemFeature__c
            WHERE dmpl__ItemId__c = :itemId
            LIMIT 1
        ];
    }
    
     public static dmpl__ItemComponent__c createItemComponent(
        dmpl__Item__c item,
        dmpl__Item__c componentItem,
        dmpl__ItemFeature__c feature,
        String packageType,
        Decimal quantity
    ) {
        return (dmpl__ItemComponent__c) TestFactory.createSObject(
            new dmpl__ItemComponent__c(
                dmpl__ItemId__c = item.Id,
                dmpl__ComponentItemId__c = componentItem.Id,
                dmpl__FeatureId__c = feature.Id,
                dmpl__PackageType__c = packageType,
                dmpl__Quantity__c = quantity
            ),
            'ItemComponentDefaults',
            true
        );
    }

    public static dmpl__ItemComponent__c updateItemComponent(
        dmpl__ItemComponent__c itemComponent,
        String packageType,
        Decimal quantity
    ) {
        Id existingItemId = itemComponent.dmpl__ItemId__c;
        Id existingComponentItemId = itemComponent.dmpl__ComponentItemId__c;
        Id existingFeatureId = itemComponent.dmpl__FeatureId__c;
        
        return (dmpl__ItemComponent__c) TestFactory.createSObject(
            new dmpl__ItemComponent__c(
                dmpl__ItemId__c = existingItemId,
                dmpl__ComponentItemId__c = existingComponentItemId,
                dmpl__FeatureId__c = existingFeatureId,
                dmpl__PackageType__c = packageType,
                dmpl__Quantity__c = quantity
            ),
            'ItemComponentDefaults',
            true
        );
    }

    public static dmpl__ItemComponent__c getItemComponent(
        Id itemId,
        Id componentItemId
    ) {
        return [
            SELECT Id, Name, dmpl__ItemId__c, dmpl__ComponentItemId__c,
                   dmpl__FeatureId__c, dmpl__PackageType__c, dmpl__Quantity__c
            FROM dmpl__ItemComponent__c
            WHERE dmpl__ItemId__c = :itemId
            AND dmpl__ComponentItemId__c = :componentItemId
            LIMIT 1
        ];
    }
   
    public static dmpl__ItemAlias__c createItemAlias(
        dmpl__Item__c item,
        dmpl__ItemLotType__c lotType,
        String name
    ) {
        return (dmpl__ItemAlias__c) TestFactory.createSObject(
            new dmpl__ItemAlias__c(
                Name = name,
                dmpl__ItemId__c = item.Id,
                dmpl__ItemLotTypeId__c = lotType.Id
            ),
            'ItemAliasDefaults',
            true
        );
    }

    public static dmpl__ItemAlias__c updateItemAlias(
        dmpl__ItemAlias__c itemAlias,
        String newName,
        dmpl__ItemLotType__c newLotType
    ) {
           Id existingItemId = itemAlias.dmpl__ItemId__c;
        return (dmpl__ItemAlias__c) TestFactory.createSObject(
            new dmpl__ItemAlias__c(
                
                Name = newName,
                  dmpl__ItemId__c = existingItemId,
                dmpl__ItemLotTypeId__c = newLotType.Id
            ),
            'ItemAliasDefaults',
            true
        );
    }

    public static dmpl__ItemAlias__c getItemAlias(
        Id itemId
    ) {
        return [
            SELECT Id, Name, dmpl__ItemId__c, dmpl__ItemLotTypeId__c, OwnerId
            FROM dmpl__ItemAlias__c
            WHERE dmpl__ItemId__c = :itemId
            LIMIT 1
        ];
    }
    
    public static dmpl__ItemAlternate__c createItemAlternate(
        dmpl__Item__c item,
        Decimal quantityAvailable,
        Decimal quantityInHand
    ) {
        return (dmpl__ItemAlternate__c) TestFactory.createSObject(
            new dmpl__ItemAlternate__c(
                dmpl__ItemId__c = item.Id,
                dmpl__QuantityAvailable__c = quantityAvailable,
                dmpl__QuantityInHand__c = quantityInHand
            ),
            'ItemAlternateDefaults',
            true
        );
    }
	public static dmpl__ItemServiceContractLine__c createItemServiceContractLine(
        dmpl__ItemServiceContract__c itemServiceContract,
        dmpl__Item__c componentItem
    ) {
        return (dmpl__ItemServiceContractLine__c) TestFactory.createSObject(
            new dmpl__ItemServiceContractLine__c(
                dmpl__ItemServiceContractId__c = itemServiceContract.Id,
                dmpl__ComponentItemId__c = componentItem.Id
            ),
            'ItemServiceContractLineDefaults',
            true
        );
    }

    public static dmpl__ItemAlternate__c updateItemAlternate(
        dmpl__ItemAlternate__c itemAlternate,
        Decimal newQuantityAvailable,
        Decimal newQuantityInHand
    ) {
        Id existingItemId = itemAlternate.dmpl__ItemId__c;
        return (dmpl__ItemAlternate__c) TestFactory.createSObject(
            new dmpl__ItemAlternate__c(
                dmpl__ItemId__c = existingItemId,
                dmpl__QuantityAvailable__c = newQuantityAvailable,
                dmpl__QuantityInHand__c = newQuantityInHand
            ),
            'ItemAlternateDefaults',
            true
        );
    }

    public static dmpl__ItemAlternate__c getItemAlternate(
        Id itemId
    ) {
        return [
            SELECT Id, dmpl__ItemId__c, dmpl__QuantityAvailable__c, dmpl__QuantityInHand__c
            FROM dmpl__ItemAlternate__c 
            WHERE dmpl__ItemId__c = :itemId
            LIMIT 1
        ];
    }
    
    public static dmpl__ItemServiceContract__c createItemServiceContract(
        dmpl__Item__c item,
        Boolean activeServiceContractRequired,
        Boolean billToPartnerAccount,
        Boolean isScopeRestricted,
        Boolean populateContractLines,
        Boolean restrictAssetContractLinesGeneration,
        Boolean singleUseContract
    ) {
        return (dmpl__ItemServiceContract__c) TestFactory.createSObject(
            new dmpl__ItemServiceContract__c(
                dmpl__ItemId__c = item.Id,
                dmpl__ActiveServiceContractRequired__c = activeServiceContractRequired,
                dmpl__BillToPartnerAccount__c = billToPartnerAccount,
                dmpl__IsScopeRestricted__c = isScopeRestricted,
                dmpl__PopulateContractLines__c = populateContractLines,
                dmpl__RestrictAssetContractLinesGeneration__c = restrictAssetContractLinesGeneration,
                dmpl__SingleUseContract__c = singleUseContract
            ),
            'ItemServiceContractDefaults',
            true
        );
    }

    public static dmpl__ItemServiceContract__c createItemServiceContract(
        Id item,
        String name,
        Account billingAccount,
        Integer  fromDays,
        Date dateEffectiveFrom,
        String cpTreatment
    ) {
        return (dmpl__ItemServiceContract__c) TestFactory.createSObject(
            new dmpl__ItemServiceContract__c(
                dmpl__ItemId__c = item,
                dmpl__BillingAccountId__c = billingAccount?.Id,
                dmpl__FromDays__c = fromDays,  
                dmpl__DateEffectiveFrom__c = dateEffectiveFrom,
                dmpl__ContractPostingTreatment__c = cpTreatment
            ),
            true
        );
    }

    public static dmpl__ItemServiceContract__c updateItemServiceContract(
        dmpl__ItemServiceContract__c itemServiceContract,
        Boolean activeServiceContractRequired,
        Boolean billToPartnerAccount,
        Boolean isScopeRestricted,
        Boolean populateContractLines,
        Boolean restrictAssetContractLinesGeneration,
        Boolean singleUseContract
    ) {
        Id existingItemId = itemServiceContract.dmpl__ItemId__c;
        return (dmpl__ItemServiceContract__c) TestFactory.createSObject(
            new dmpl__ItemServiceContract__c(
                dmpl__ItemId__c = existingItemId,
                dmpl__ActiveServiceContractRequired__c = activeServiceContractRequired,
                dmpl__BillToPartnerAccount__c = billToPartnerAccount,
                dmpl__IsScopeRestricted__c = isScopeRestricted,
                dmpl__PopulateContractLines__c = populateContractLines,
                dmpl__RestrictAssetContractLinesGeneration__c = restrictAssetContractLinesGeneration,
                dmpl__SingleUseContract__c = singleUseContract
            ),
            'ItemServiceContractDefaults',
            true
        );
    }

    public static dmpl__ItemServiceContract__c getItemServiceContract(
        Id itemId
    ) {
        return [
            SELECT Id, dmpl__ItemId__c, dmpl__ActiveServiceContractRequired__c, 
                   dmpl__BillToPartnerAccount__c, dmpl__IsScopeRestricted__c,
                   dmpl__PopulateContractLines__c, dmpl__RestrictAssetContractLinesGeneration__c,
                   dmpl__SingleUseContract__c
            FROM dmpl__ItemServiceContract__c 
            WHERE dmpl__ItemId__c = :itemId
            LIMIT 1
        ];
    }
    
    public static dmpl__ItemServiceContractLine__c createItemServiceContractLine(
        dmpl__ItemServiceContract__c itemServiceContract,
        Boolean isInScope,
        Decimal quantity
    ) {
        return (dmpl__ItemServiceContractLine__c) TestFactory.createSObject(
            new dmpl__ItemServiceContractLine__c(
                dmpl__ItemServiceContractId__c = itemServiceContract.Id,
                dmpl__IsInScope__c = isInScope,
                dmpl__Quantity__c = quantity
            ),
            'ItemServiceContractLineDefaults',
            true
        );
    }

    public static dmpl__ItemServiceContractLine__c updateItemServiceContractLine(
        dmpl__ItemServiceContractLine__c itemServiceContractLine,
        Boolean isInScope,
        Decimal quantity
    ) {
        Id existingContractId = itemServiceContractLine.dmpl__ItemServiceContractId__c;
        return (dmpl__ItemServiceContractLine__c) TestFactory.createSObject(
            new dmpl__ItemServiceContractLine__c(
                dmpl__ItemServiceContractId__c = existingContractId,
                dmpl__IsInScope__c = isInScope,
                dmpl__Quantity__c = quantity
            ),
            'ItemServiceContractLineDefaults',
            true
        );
    }

    public static dmpl__ItemServiceContractLine__c getItemServiceContractLine(
        Id itemServiceContractId
    ) {
        return [
            SELECT Id, dmpl__ItemServiceContractId__c, dmpl__IsInScope__c,
                   dmpl__Quantity__c
            FROM dmpl__ItemServiceContractLine__c 
            WHERE dmpl__ItemServiceContractId__c = :itemServiceContractId
            LIMIT 1
        ];
    }
 
    public static dmpl__ItemRelation__c createItemRelation(
        dmpl__Item__c item,
        Decimal price,
        Decimal quantity
    ) {
        return (dmpl__ItemRelation__c) TestFactory.createSObject(
            new dmpl__ItemRelation__c(
                dmpl__ItemId__c = item.Id,
                dmpl__Price__c = price,
                dmpl__Quantity__c = quantity
            ),
            'ItemRelationDefaults',
            true
        );
    }

    public static dmpl__ItemRelation__c updateItemRelation(
        dmpl__ItemRelation__c itemRelation,
        Decimal price,
        Decimal quantity
    ) {
        Id existingItemId = itemRelation.dmpl__ItemId__c;
        return (dmpl__ItemRelation__c) TestFactory.createSObject(
            new dmpl__ItemRelation__c(
                dmpl__ItemId__c = existingItemId,
                dmpl__Price__c = price,
                dmpl__Quantity__c = quantity
            ),
            'ItemRelationDefaults',
            true
        );
    }

    public static dmpl__ItemRelation__c getItemRelation(
        Id itemId
    ) {
        return [
            SELECT Id, dmpl__ItemId__c, dmpl__Price__c,
                   dmpl__Quantity__c
            FROM dmpl__ItemRelation__c 
            WHERE dmpl__ItemId__c = :itemId
            LIMIT 1
        ];
    }
    
    public static dmpl__ItemMaintenanceSchedule__c createItemMaintenanceSchedule(
        dmpl__Item__c item
    ) {
        return (dmpl__ItemMaintenanceSchedule__c) TestFactory.createSObject(
            new dmpl__ItemMaintenanceSchedule__c(
                dmpl__ItemId__c = item.Id,
                dmpl__Sequence__c = 1,
                dmpl__ToDurationDays__c = 30,
                dmpl__ToUsageHours__c = 100.00,
                dmpl__ToUsageReading__c = 1000.00
            ),
            'ItemMaintenanceScheduleDefaults',
            true
        );
    }

    public static dmpl__ItemMaintenanceSchedule__c updateItemMaintenanceSchedule(
        dmpl__Item__c item
    ) {
        return (dmpl__ItemMaintenanceSchedule__c) TestFactory.createSObject(
            new dmpl__ItemMaintenanceSchedule__c(
                dmpl__ItemId__c = item.Id,
                dmpl__Sequence__c = 2,
                dmpl__ToDurationDays__c = 60,
                dmpl__ToUsageHours__c = 200.00,
                dmpl__ToUsageReading__c = 2000.00
            ),
            'ItemMaintenanceScheduleDefaults',
            true
        );
    }

    public static dmpl__ItemMaintenanceSchedule__c getItemMaintenanceSchedule(
        Id itemId
    ) {
        return [
            SELECT Id, dmpl__ItemId__c, dmpl__Sequence__c,
                   dmpl__ToDurationDays__c, dmpl__ToUsageHours__c,
                   dmpl__ToUsageReading__c
            FROM dmpl__ItemMaintenanceSchedule__c 
            WHERE dmpl__ItemId__c = :itemId
            LIMIT 1
        ];
    }

    public static dmpl__ItemMaintenanceScheduleDetails__c createItemMaintenanceScheduleDetails(
        Id itemMaintenanceScheduleId
    ) {
        return (dmpl__ItemMaintenanceScheduleDetails__c) TestFactory.createSObject(
            new dmpl__ItemMaintenanceScheduleDetails__c(
                dmpl__ItemMaintenanceScheduleId__c = itemMaintenanceScheduleId,
                dmpl__LastServiceDate__c = Date.today()
            ),
            'ItemMaintenanceScheduleDetailsDefaults',
            true
        );
    }

    public static dmpl__ItemMaintenanceScheduleDetails__c updateItemMaintenanceScheduleDetails(
        Id itemMaintenanceScheduleId
    ) {
        return (dmpl__ItemMaintenanceScheduleDetails__c) TestFactory.createSObject(
            new dmpl__ItemMaintenanceScheduleDetails__c(
                dmpl__ItemMaintenanceScheduleId__c = itemMaintenanceScheduleId,
                dmpl__LastServiceDate__c = Date.today().addDays(30)
            ),
            'ItemMaintenanceScheduleDetailsDefaults',
            true
        );
    }

    public static dmpl__ItemMaintenanceScheduleDetails__c getItemMaintenanceScheduleDetails(
        Id itemMaintenanceScheduleId
    ) {
        return [
            SELECT Id, dmpl__ItemMaintenanceScheduleId__c, dmpl__LastServiceDate__c
            FROM dmpl__ItemMaintenanceScheduleDetails__c
            WHERE dmpl__ItemMaintenanceScheduleId__c = :itemMaintenanceScheduleId
            LIMIT 1
        ];
    }
      
    public static dmpl__ItemInventoryAttribute__c createItemInventoryAttribute(
        dmpl__Item__c item
    ) {
        return (dmpl__ItemInventoryAttribute__c) TestFactory.createSObject(
            new dmpl__ItemInventoryAttribute__c(
                dmpl__ItemId__c = item.Id,
                dmpl__MaximumStockLevel__c = 1000.00,
                dmpl__MinimumOrderQuantity__c = 10.00,
                dmpl__MinimumStockLevel__c = 100.00,
                dmpl__MaximumOrderQuantity__c = 500.00
            ),
            'ItemInventoryAttributeDefaults',
            true
        );
    }

public static dmpl__ItemInventoryAttribute__c createItemInventoryAttribute(
    Id partnerAccountId,
    Id branchId,
    Id itemId,
    String abcCategory,
    String fsnCategory,
    Decimal minimumStockLevel,
    Decimal maximumStockLevel,
    Decimal reorderLevel,
    Id skuId
) {
    return (dmpl__ItemInventoryAttribute__c) TestFactory.createSObject(
        new dmpl__ItemInventoryAttribute__c(
            dmpl__PartnerAccountId__c = partnerAccountId,
            dmpl__BranchId__c = branchId,
            dmpl__ItemId__c = itemId,
            dmpl__ABCCategory__c = abcCategory,
            dmpl__FSNCategory__c = fsnCategory,
            dmpl__MinimumStockLevel__c = minimumStockLevel,
            dmpl__MaximumStockLevel__c = maximumStockLevel,
			dmpl__MinimumOrderQuantity__c = 10.00,
			dmpl__MaximumOrderQuantity__c = 500.00,
            dmpl__ReorderLevel__c = reorderLevel,
            dmpl__SKUId__c = skuId
        ),
        true
    );
}

public static dmpl__ItemInventoryAttribute__c getItemInventoryAttribute(dmpl__ItemInventoryAttribute__c itemInventoryAttribute) {
    return [
        SELECT 
            Id,
            dmpl__PartnerAccountId__c,
            dmpl__BranchId__c,
            dmpl__ItemId__c,
            dmpl__ABCCategory__c,
            dmpl__FSNCategory__c,
            dmpl__MinimumStockLevel__c,
            dmpl__MaximumStockLevel__c,
            dmpl__ReorderLevel__c,
            dmpl__SKUId__c
        FROM dmpl__ItemInventoryAttribute__c
        WHERE Id = :itemInventoryAttribute.Id
        LIMIT 1
    ];
}


    public static dmpl__ItemInventoryAttribute__c updateItemInventoryAttribute(
        dmpl__Item__c item
    ) {
        return (dmpl__ItemInventoryAttribute__c) TestFactory.createSObject(
            new dmpl__ItemInventoryAttribute__c(
                dmpl__ItemId__c = item.Id,
                dmpl__MaximumStockLevel__c = 2000.00,
                dmpl__MinimumOrderQuantity__c = 20.00,
                dmpl__MinimumStockLevel__c = 200.00,
                dmpl__MaximumOrderQuantity__c = 1000.00
            ),
            'ItemInventoryAttributeDefaults',
            true
        );
    }

    public static dmpl__ItemInventoryAttribute__c getItemInventoryAttribute(
        Id itemId
    ) {
        return [
            SELECT Id, dmpl__ItemId__c, dmpl__MaximumStockLevel__c,
                   dmpl__MinimumOrderQuantity__c, dmpl__MinimumStockLevel__c,
                   dmpl__MaximumOrderQuantity__c
            FROM dmpl__ItemInventoryAttribute__c
            WHERE dmpl__ItemId__c = :itemId
            LIMIT 1
        ];
    }
      
    public static dmpl__ItemImageDetail__c createItemImageDetail(dmpl__Item__c item) {
        return (dmpl__ItemImageDetail__c) TestFactory.createSObject(
            new dmpl__ItemImageDetail__c(
                dmpl__ItemId__c = item.Id,
                Name = 'Test Image',
                dmpl__LinkUrl__c = 'https://test-image-url.com'
            ),
            'ItemImageDetailDefaults',
            true
        );
    }


    public static dmpl__ItemImageDetail__c updateItemImageDetail(dmpl__Item__c item) {
        return (dmpl__ItemImageDetail__c) TestFactory.createSObject(
            new dmpl__ItemImageDetail__c(
                dmpl__ItemId__c = item.Id,
                Name = 'Updated Test Image',
                dmpl__LinkUrl__c = 'https://updated-test-image-url.com'
            ),
            'ItemImageDetailDefaults',
            true
        );
    }

    public static dmpl__ItemImageDetail__c getItemImageDetail(Id itemId) {
        return [
            SELECT Id, dmpl__ItemId__c, Name, dmpl__LinkUrl__c, dmpl__Shape__c
            FROM dmpl__ItemImageDetail__c
            WHERE dmpl__ItemId__c = :itemId
            LIMIT 1
        ];
    }
    
    public static dmpl__SKU__c createSKU(Boolean isDefault, dmpl__Item__c item) {
        return (dmpl__SKU__c) TestFactory.createSObject(
            new dmpl__SKU__c(
                dmpl__ItemId__c = item.Id,
                dmpl__IsDefault__c = isDefault,
                Name = 'Test SKU'
            ),
            'SKUDefaults',
            true
        );
    }

    public static dmpl__SKU__c updateSKU(Boolean isDefault, dmpl__Item__c item) {
        return (dmpl__SKU__c) TestFactory.createSObject(
            new dmpl__SKU__c(
                dmpl__ItemId__c = item.Id,
                dmpl__IsDefault__c = isDefault,
                Name = 'Updated Test SKU'
            ),
            'SKUDefaults',
            true
        );
    }

    public static List<dmpl__SKU__c> getSKU(Id itemId) {
        return [
            SELECT Id, dmpl__ItemId__c, dmpl__IsDefault__c, Name
            FROM dmpl__SKU__c
            WHERE dmpl__ItemId__c = :itemId
            LIMIT 1
        ];
    }
    
    public static dmpl__ItemImageDetail__c createItemImageDetail(
        String name,
        Id itemId,
        Id itemComponentId,
        Id componentItemId,
        String shape,
        String linkUrl,
        String coordinate
        ) {
        return (dmpl__ItemImageDetail__c) TestFactory.createSObject(
            new dmpl__ItemImageDetail__c(
                Name = name,
                dmpl__ComponentItemId__c = componentItemId,
                dmpl__ItemId__c = itemId,
                dmpl__ItemComponentId__c = itemComponentId,
                dmpl__Shape__c = shape,
                dmpl__LinkUrl__c = linkUrl,
                dmpl__Coordinate__c = coordinate
            ),
            'ItemImageDetailDefaults',
            true
        );
    }


     public static dmpl__ItemImageDetail__c getItemImageDetail(dmpl__ItemImageDetail__c imageid) {
        return [
            SELECT Id, dmpl__ItemId__c, Name, dmpl__Shape__c, dmpl__LinkUrl__c,dmpl__ComponentItemId__c,dmpl__ItemComponentId__c,dmpl__Detail__c
            FROM dmpl__ItemImageDetail__c
            WHERE Id = :imageid.Id
            LIMIT 1
        ];
    }
    

    public static dmpl__ItemLot__c createItemLot(
    Id partnerAccountId,
    Id branchId,
    Id itemId,
    Id skuId,
    Date dateOfMfg,
    Date dateOfExpiry,
    Decimal cost,
    Decimal unitCost,
    String serialNumber,
    String registrationNumber,
    Date dateOfInward,
    Date purchaseDate,
    Decimal quantitySold,
    Id storageLocationId
    ) {
    return (dmpl__ItemLot__c) TestFactory.createSObject(
        new dmpl__ItemLot__c(
            dmpl__PartnerAccountId__c = partnerAccountId,
            dmpl__BranchId__c = branchId,
            dmpl__ItemId__c = itemId,
            dmpl__SKUId__c = skuId,
            dmpl__DateOfMfg__c = dateOfMfg,
            dmpl__DateOfExpiry__c = dateOfExpiry,
            dmpl__Cost__c = cost,
            dmpl__UnitCost__c = unitCost,
            dmpl__SerialNumber__c = serialNumber,
            dmpl__RegistrationNumber__c = registrationNumber,
            dmpl__DateOfInward__c = dateOfInward,
            dmpl__PurchaseDate__c = purchaseDate,
            dmpl__QuantitySold__c = quantitySold,
            dmpl__StorageLocationId__c = storageLocationId
        ),
        true
    );
    }

    public static dmpl__ItemLot__c getItemLot() {
        return [SELECT
        Id,
        Name,
        dmpl__ItemLotTypeId__c,
        dmpl__QuantitySold__c,
        dmpl__QuantityInHand__c,
        dmpl__PartnerAccountId__c,
        dmpl__SKUId__c,
        dmpl__Cost__c,
        dmpl__ItemId__c,
        dmpl__BatchNo__c,
        dmpl__StorageLocationId__c,
        dmpl__PurchaseDate__c,
        dmpl__UnitCost__c,
        dmpl__BranchId__c,
        dmpl__QuantityTransferOut__c,
        dmpl__ComponentNumber__c,
        dmpl__DateOfMfg__c,
        dmpl__DateOfInward__c,
        dmpl__RegistrationNumber__c,
        dmpl__SupplierInvoiceNumber__c,
        dmpl__DateOfRegistration__c,
        dmpl__DateOfExpiry__c,
        dmpl__QuantityInTransit__c,
        dmpl__QuantityInPendingDeliveries__c,
        dmpl__QuantityPicked__c,
        dmpl__QuantityTransferIn__c,
        dmpl__QuantityOnAllocation__c,
        dmpl__QuantityOnInward__c,
        dmpl__QuantityAdjustedIn__c,
        dmpl__QuantityAdjustedOut__c,
        dmpl__QuantityAssembledIn__c,
        dmpl__QuantityOnFulfillment__c,
        dmpl__QuantityOnOutward__c,
        dmpl__SerialNumber__c,
        dmpl__SaleDate__c
        FROM dmpl__ItemLot__c LIMIT 1];
    }
    public static dmpl__ItemLot__c getItemLot(dmpl__ItemLot__c itemlot) {
        return [SELECT
        Id,
        Name,
        dmpl__ItemLotTypeId__c,
        dmpl__QuantitySold__c,
        dmpl__QuantityInHand__c,
        dmpl__PartnerAccountId__c,
        dmpl__SKUId__c,
        dmpl__Cost__c,
        dmpl__ItemId__c,
        dmpl__BatchNo__c,
        dmpl__StorageLocationId__c,
        dmpl__PurchaseDate__c,
        dmpl__UnitCost__c,
        dmpl__BranchId__c,
        dmpl__QuantityTransferOut__c,
        dmpl__ComponentNumber__c,
        dmpl__DateOfMfg__c,
        dmpl__DateOfInward__c,
        dmpl__RegistrationNumber__c,
        dmpl__SupplierInvoiceNumber__c,
        dmpl__DateOfRegistration__c,
        dmpl__DateOfExpiry__c,
        dmpl__QuantityInTransit__c,
        dmpl__QuantityInPendingDeliveries__c,
        dmpl__QuantityPicked__c,
        dmpl__QuantityTransferIn__c,
        dmpl__QuantityOnAllocation__c,
        dmpl__QuantityOnInward__c,
        dmpl__QuantityAdjustedIn__c,
        dmpl__QuantityAdjustedOut__c,
        dmpl__QuantityAssembledIn__c,
        dmpl__QuantityOnFulfillment__c,
        dmpl__QuantityOnOutward__c,
        dmpl__SerialNumber__c,
        dmpl__SaleDate__c
        FROM dmpl__ItemLot__c  WHERE Id = :itemlot.Id LIMIT 1];
    }
    public static dmpl__ItemLotType__c CreateItemLotType(dmpl__Item__c item )
    {
        return (dmpl__ItemLotType__c)TestFactory.createSObject(
            new dmpl__ItemLotType__c(
                dmpl__PriceCode__c = 'PC1001',
                dmpl__VariationCode__c = 'VC1001',
                dmpl__ItemId__c = item.Id,
                dmpl__IsPromo__c = false
            ),
            true
        );
       
    }

	public static dmpl__ItemMaintenanceSchedule__c createItemMaintenanceSchedule(
        Id itemId,
        String skuId,
        Integer fromDurationDays,
        Decimal fromUsageHours,
        Integer toDurationDays,
        Decimal toUsageHours,
        Decimal fromUsageReading,
        Decimal toUsageReading,
        Integer dueInDays,
        Decimal dueOnUsage,
        Decimal dueInUsageHours,
        Integer numberOfReminders,
        Integer reminderOffset1,
        Integer reminderOffset2,
        Integer reminderOffset3,
        Integer reminderOffset4,
        Integer reminderOffset5,
		Decimal sequence
    ) {
        return (dmpl__ItemMaintenanceSchedule__c) TestFactory.createSObject(
            new dmpl__ItemMaintenanceSchedule__c(
                dmpl__ItemId__c = itemId,
				dmpl__SKUId__c = skuId,
				dmpl__FromDurationDays__c = fromDurationDays,
				dmpl__FromUsageHours__c = fromUsageHours,
				dmpl__ToDurationDays__c = toDurationDays,
				dmpl__ToUsageHours__c = toUsageHours,
				dmpl__FromUsageReading__c = fromUsageReading,
				dmpl__ToUsageReading__c = toUsageReading,
				dmpl__DueInDays__c = dueInDays,
				dmpl__DueOnUsage__c = dueOnUsage,
				dmpl__DueinUsageHours__c = dueInUsageHours,
				dmpl__ReminderDaysOffset1__c = reminderOffset1,
				dmpl__ReminderDaysOffset2__c = reminderOffset2,
				dmpl__ReminderDaysOffset3__c = reminderOffset3,
				dmpl__ReminderDaysOffset4__c = reminderOffset4,
				dmpl__ReminderDaysOffset5__c = reminderOffset5,
				dmpl__Numberofreminder__c = numberOfReminders,
				dmpl__Sequence__c = sequence
            ),
            true
        );
    }
	public static dmpl__ItemMaintenanceSchedule__c getItemMaintenanceSchedulebyId(
        Id id
    ) {
        return [
            SELECT dmpl__Sequence__c,
                Id, dmpl__ItemId__c, dmpl__SKUId__c, dmpl__FromDurationDays__c,
                dmpl__FromUsageHours__c, dmpl__ToDurationDays__c, dmpl__ToUsageHours__c,
                dmpl__FromUsageReading__c, dmpl__ToUsageReading__c, dmpl__DueInDays__c,
                dmpl__DueOnUsage__c, dmpl__DueinUsageHours__c,
                dmpl__ReminderDaysOffset1__c, dmpl__ReminderDaysOffset2__c,
                dmpl__ReminderDaysOffset3__c, dmpl__ReminderDaysOffset4__c,
                dmpl__ReminderDaysOffset5__c, dmpl__Numberofreminder__c
            FROM dmpl__ItemMaintenanceSchedule__c 
            WHERE Id = :id
            LIMIT 1
        ];
    }

	//item
 
    // Scenario 1: Just Name
    public static dmpl__Item__c itemCreation(String itemName) {
        return (dmpl__Item__c) TestFactory.createSObject(
            new dmpl__Item__c(
                Name = itemName,
                dmpl__IsActive__c = true
            ),
            true
        );
    }
 
    // Scenario 2: Name + Item Type
    public static dmpl__Item__c itemCreation(String itemName, String itemType) {
        return (dmpl__Item__c) TestFactory.createSObject(
            new dmpl__Item__c(
                Name = itemName,
                dmpl__ItemType__c = itemType,
                dmpl__IsActive__c = true
            ),
            true
        );
    }
 
    // Scenario 4 & 5: Name + Item Type + SubType
    public static dmpl__Item__c itemCreation(String itemName, String itemType, String itemSubType) {
        return (dmpl__Item__c) TestFactory.createSObject(
            new dmpl__Item__c(
                Name = itemName,
                dmpl__ItemType__c = itemType,
                dmpl__ItemSubType__c = itemSubType,
                dmpl__IsActive__c = true
            ),
            true
        );
    }
 
    // Scenario 6: Name + Primary UOM
    public static dmpl__Item__c itemCreation(String itemName, String quantityUOM, Boolean isUOMOnly) {
        return (dmpl__Item__c) TestFactory.createSObject(
            new dmpl__Item__c(
                Name = itemName,
                dmpl__QuantityUnitOfMeasure__c = quantityUOM,
                dmpl__IsActive__c = true
            ),
            true
        );
    }
 
    // Scenario 9: Name + Track Inventory flag
    public static dmpl__Item__c itemCreation(String itemName, Boolean trackInventory) {
        return (dmpl__Item__c) TestFactory.createSObject(
            new dmpl__Item__c(
                Name = itemName,
                dmpl__TrackInventory__c = trackInventory,
                dmpl__IsActive__c = true
            ),
            true
        );
    }
 
    // Fetch created Item
    public static dmpl__Item__c getItem(String itemName) {
        return [
            SELECT Id,
                   Name,
                   dmpl__ItemType__c,
                   dmpl__ItemSubType__c,
                   dmpl__QuantityUnitOfMeasure__c,
                   dmpl__TrackInventory__c,
                   dmpl__Description__c,
                   dmpl__IsActive__c
            FROM dmpl__Item__c
            WHERE Name = :itemName
            LIMIT 1
        ];
    }
    public static dmpl__Item__c itemCreationWithoutCategories(String itemName) {
        return (dmpl__Item__c) TestFactory.createSObject(
            new dmpl__Item__c(
                Name = itemName,
                dmpl__ABCCategory__c = null,
                dmpl__FSNCategory__c = null,
                dmpl__IsActive__c = true
            ),
            true
        );
    }
    public static dmpl__Item__c itemCreationWithoutGTIN(String itemName) {
        return (dmpl__Item__c) TestFactory.createSObject(
            new dmpl__Item__c(
                Name = itemName,
                dmpl__GTIN__c = null,
                dmpl__IsActive__c = true
            ),
            true
        );
    }
    public static dmpl__Item__c itemCreationWithInactiveStatus(String itemName) {
        return (dmpl__Item__c) TestFactory.createSObject(
            new dmpl__Item__c(
                Name = itemName,
                dmpl__IsActive__c = false
            ),
            true
        );
    }
    public static dmpl__Item__c itemCreationWithIsDiscontinued(String itemName) {
        return (dmpl__Item__c) TestFactory.createSObject(
            new dmpl__Item__c(
                Name = itemName,
                dmpl__IsDiscontinued__c = true,
                dmpl__IsActive__c = true
            ),
            true
        );
    }
    public static dmpl__Item__c itemCreationWithOnlySoldInPackage(String itemName) {
        return (dmpl__Item__c) TestFactory.createSObject(
            new dmpl__Item__c(
                Name = itemName,
                dmpl__OnlySoldInPackage__c = true,
                dmpl__IsActive__c = true
            ),
            true
        );
    }
    public static dmpl__Item__c itemCreationWithIsSKURequired(String itemName) {
        return (dmpl__Item__c) TestFactory.createSObject(
            new dmpl__Item__c(
                Name = itemName,
                dmpl__IsSKURequired__c = true,
                dmpl__IsActive__c = true
            ),
            true
        );
    }
    public static dmpl__Item__c itemCreationWithIsRegistrationRequired(String itemName) {
        return (dmpl__Item__c) TestFactory.createSObject(
            new dmpl__Item__c(
                Name = itemName,
                dmpl__IsRegistrationRequired__c = true,
                dmpl__IsActive__c = true
            ),
            true
        );
    }
    public static dmpl__Item__c itemCreationWithoutFamilyAndSegment(String itemName) {
        return (dmpl__Item__c) TestFactory.createSObject(
            new dmpl__Item__c(
                Name = itemName,
                dmpl__ItemFamily__c = null,
                dmpl__ItemSegment__c = null,
                dmpl__IsActive__c = true
            ),
            true
        );
    }
    public static dmpl__Item__c itemCreationWithFamilyAndSegment(String itemName, String itemFamily, String itemSegment) {
        return (dmpl__Item__c) TestFactory.createSObject(
            new dmpl__Item__c(
                Name = itemName,
                dmpl__ItemFamily__c = itemFamily,
                dmpl__ItemSegment__c = itemSegment,
                dmpl__IsActive__c = true
            ),
            true
        );
    }
    public static dmpl__Item__c itemCreationWithAllowService(String itemName) {
        return (dmpl__Item__c) TestFactory.createSObject(
            new dmpl__Item__c(
                Name = itemName,
                dmpl__AllowService__c = true,
                dmpl__IsActive__c = true
            ),
            true
        );
    }
    public static dmpl__Item__c itemCreationWithTrackLots(String itemName) {
        return (dmpl__Item__c) TestFactory.createSObject(
            new dmpl__Item__c(
                Name = itemName,
                dmpl__TrackLots__c = true,
                dmpl__IsActive__c = true
            ),
            true
        );
    }
    public static dmpl__Item__c itemCreationWithTrackAsset(String itemName) {
        return (dmpl__Item__c) TestFactory.createSObject(
            new dmpl__Item__c(
                Name = itemName,
                dmpl__TrackAsset__c = true,
                dmpl__IsActive__c = true
            ),
            true
        );
    }
    public static dmpl__Item__c itemCreationWithoutRFID(String itemName) {
        return (dmpl__Item__c) TestFactory.createSObject(
            new dmpl__Item__c(
                Name = itemName,
                dmpl__RFID__c = null,
                dmpl__IsActive__c = true
            ),
            true
        );
    }
 
    //Item Alias
   
    public static dmpl__ItemAlias__c itemAliasCreation(String aliasName, Id itemId) {
        return (dmpl__ItemAlias__c) TestFactory.createSObject(
            new dmpl__ItemAlias__c(
                Name = aliasName,
                dmpl__ItemId__c = itemId
            ),
            true
        );
    }
 
    public static dmpl__ItemAlias__c itemAliasCreationWithoutName(Id itemId) {
        return (dmpl__ItemAlias__c) TestFactory.createSObject(
            new dmpl__ItemAlias__c(
                Name = null,
                dmpl__ItemId__c = itemId
            ),
            false
        );
    }
 
    public static dmpl__ItemAlias__c getItemAlias(String aliasName) {
        return [
            SELECT Id, Name, dmpl__ItemId__c
            FROM dmpl__ItemAlias__c
            WHERE Name = :aliasName
            LIMIT 1
        ];
    }
 
    public static dmpl__ItemAlias__c itemAliasWithLotTypeCreation(String aliasName, Id itemId, Id itemLotTypeId) {
        return (dmpl__ItemAlias__c) TestFactory.createSObject(
            new dmpl__ItemAlias__c(
                Name = aliasName,
                dmpl__ItemId__c = itemId,
                dmpl__ItemLotTypeId__c = itemLotTypeId
            ),
            true
        );
    }
 
    public static dmpl__ItemAlias__c itemAliasWithoutLotTypeCreation(String aliasName, Id itemId) {
        return (dmpl__ItemAlias__c) TestFactory.createSObject(
            new dmpl__ItemAlias__c(
                Name = aliasName,
                dmpl__ItemId__c = itemId,
                dmpl__ItemLotTypeId__c = null
            ),
            true
        );
    }
 
    public static dmpl__ItemAlias__c itemAliasWithoutItemCreation(String aliasName) {
        return (dmpl__ItemAlias__c) TestFactory.createSObject(
            new dmpl__ItemAlias__c(
                Name = aliasName,
                dmpl__ItemId__c = null
            ),
            false
        );
    }
 
    public static dmpl__ItemAlias__c itemAliasWithItemOnly(String aliasName, Id itemId) {
        return (dmpl__ItemAlias__c) TestFactory.createSObject(
            new dmpl__ItemAlias__c(
                Name = aliasName,
                dmpl__ItemId__c = itemId
            ),
            true
        );
    }
 
    public static dmpl__ItemAlias__c itemAliasWithInactiveItem(String aliasName, Id itemId) {
        return (dmpl__ItemAlias__c) TestFactory.createSObject(
            new dmpl__ItemAlias__c(
                Name = aliasName,
                dmpl__ItemId__c = itemId
            ),
            true
        );
    }
 
    public static dmpl__ItemAlias__c itemAliasWithDiscontinuedItem(String aliasName, Id itemId) {
        return (dmpl__ItemAlias__c) TestFactory.createSObject(
            new dmpl__ItemAlias__c(
                Name = aliasName,
                dmpl__ItemId__c = itemId
            ),
            true
        );
    }
 
    public static dmpl__ItemAlias__c itemAliasWithSKU(String aliasName, Id itemId, Id skuId) {
        return (dmpl__ItemAlias__c) TestFactory.createSObject(
            new dmpl__ItemAlias__c(
                Name = aliasName,
                dmpl__ItemId__c = itemId,
                dmpl__SKUId__c = skuId
            ),
            true
        );
    }
 
    public static dmpl__ItemAlias__c itemAliasWithoutSKU(String aliasName, Id itemId) {
        return (dmpl__ItemAlias__c) TestFactory.createSObject(
            new dmpl__ItemAlias__c(
                Name = aliasName,
                dmpl__ItemId__c = itemId,
                dmpl__SKUId__c = null
            ),
            true
        );
    }
 
    public static dmpl__ItemAlias__c itemAliasWithPartnerAccount(String aliasName, Id itemId, Id partnerAccountId) {
        return (dmpl__ItemAlias__c) TestFactory.createSObject(
            new dmpl__ItemAlias__c(
                Name = aliasName,
                dmpl__ItemId__c = itemId,
                dmpl__PartnerAccountId__c = partnerAccountId
            ),
            true
        );
    }
 
    public static dmpl__ItemAlias__c itemAliasWithoutPartnerAccount(String aliasName, Id itemId) {
        return (dmpl__ItemAlias__c) TestFactory.createSObject(
            new dmpl__ItemAlias__c(
                Name = aliasName,
                dmpl__ItemId__c = itemId,
                dmpl__PartnerAccountId__c = null
            ),
            true
        );
    }
    //item alternate
    public static dmpl__ItemAlternate__c createAlternateForInactiveItem(Id itemId, Id alternateItemId) {
        return (dmpl__ItemAlternate__c) TestFactory.createSObject(
            new dmpl__ItemAlternate__c(
                dmpl__ItemId__c = itemId,
                dmpl__AlternateItemId__c = alternateItemId
            ),
            true
        );
    }

    public static dmpl__ItemAlternate__c createAlternateForDiscontinuedItem(Id itemId, Id alternateItemId) {
        return (dmpl__ItemAlternate__c) TestFactory.createSObject(
            new dmpl__ItemAlternate__c(
                dmpl__ItemId__c = itemId,
                dmpl__AlternateItemId__c = alternateItemId
            ),
            true
        );
    }

    public static dmpl__ItemAlternate__c createAlternateWithoutType(Id itemId, Id alternateItemId) {
        return (dmpl__ItemAlternate__c) TestFactory.createSObject(
            new dmpl__ItemAlternate__c(
                dmpl__ItemId__c = itemId,
                dmpl__AlternateItemId__c = alternateItemId,
                dmpl__AlternateType__c = null
            ),
            true
        );
    }

    public static dmpl__ItemAlternate__c createAlternateWithType(Id itemId, Id alternateItemId, String type) {
        return (dmpl__ItemAlternate__c) TestFactory.createSObject(
            new dmpl__ItemAlternate__c(
                dmpl__ItemId__c = itemId,
                dmpl__AlternateItemId__c = alternateItemId,
                dmpl__AlternateType__c = type
            ),
            true
        );
    }

    public static dmpl__ItemAlternate__c createAlternateWithoutAltItem(Id itemId) {
        return (dmpl__ItemAlternate__c) TestFactory.createSObject(
            new dmpl__ItemAlternate__c(
                dmpl__ItemId__c = itemId,
                dmpl__AlternateItemId__c = null
            ),
            false
        );
    }

    public static dmpl__ItemAlternate__c createAlternateOnlyItems(Id itemId, Id altItemId) {
        return (dmpl__ItemAlternate__c) TestFactory.createSObject(
            new dmpl__ItemAlternate__c(
                dmpl__ItemId__c = itemId,
                dmpl__AlternateItemId__c = altItemId
            ),
            true
        );
    }

    public static dmpl__ItemAlternate__c createAlternateWithQtyAvailable(Id itemId, Id altItemId, Decimal qty) {
        return (dmpl__ItemAlternate__c) TestFactory.createSObject(
            new dmpl__ItemAlternate__c(
                dmpl__ItemId__c = itemId,
                dmpl__AlternateItemId__c = altItemId,
                dmpl__QuantityAvailable__c = qty
            ),
            true
        );
    }

    public static dmpl__ItemAlternate__c createAlternateWithoutQtyAvailable(Id itemId, Id altItemId) {
        return (dmpl__ItemAlternate__c) TestFactory.createSObject(
            new dmpl__ItemAlternate__c(
                dmpl__ItemId__c = itemId,
                dmpl__AlternateItemId__c = altItemId,
                dmpl__QuantityAvailable__c = null
            ),
            true
        );
    }

    public static dmpl__ItemAlternate__c createAlternateWithoutQtyInHand(Id itemId, Id altItemId) {
        return (dmpl__ItemAlternate__c) TestFactory.createSObject(
            new dmpl__ItemAlternate__c(
                dmpl__ItemId__c = itemId,
                dmpl__AlternateItemId__c = altItemId,
                dmpl__QuantityInHand__c = null
            ),
            true
        );
    }

    public static dmpl__ItemAlternate__c createAlternateWithQtyInHand(Id itemId, Id altItemId, Decimal qtyInHand) {
        return (dmpl__ItemAlternate__c) TestFactory.createSObject(
            new dmpl__ItemAlternate__c(
                dmpl__ItemId__c = itemId,
                dmpl__AlternateItemId__c = altItemId,
                dmpl__QuantityInHand__c = qtyInHand
            ),
            true
        );
    }
    //item component
        public static dmpl__ItemComponent__c createItemComponent(
        dmpl__Item__c item,
        dmpl__Item__c componentItem,
        dmpl__ItemFeature__c feature,
        String packageType,
        Decimal quantity,
        String applicableFor,
        Decimal minQuantity,
        Decimal maxQuantity,
        Id skuId,
        Boolean isBundled,
        Boolean isMandatory,
        Boolean isQuantityEditable,
        Boolean isSelected
    ) {
        return (dmpl__ItemComponent__c) TestFactory.createSObject(
            new dmpl__ItemComponent__c(
                dmpl__ItemId__c = item != null ? item.Id : null,
                dmpl__ComponentItemId__c = componentItem != null ? componentItem.Id : null,
                dmpl__FeatureId__c = feature != null ? feature.Id : null,
                dmpl__PackageType__c = packageType,
                dmpl__Quantity__c = quantity,
                dmpl__ApplicableFor__c = applicableFor,
                dmpl__MinQuantity__c = minQuantity,
                dmpl__MaxQuantity__c = maxQuantity,
                dmpl__SKUId__c = skuId,
                dmpl__IsBundled__c = isBundled,
                dmpl__IsMandatory__c = isMandatory,
                dmpl__IsQuantityEditable__c = isQuantityEditable,
                dmpl__IsSelected__c = isSelected
            ),
            'ItemComponentDefaults',
            true
        );
    }

}