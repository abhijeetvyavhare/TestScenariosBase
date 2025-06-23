@namespaceAccessible
public with sharing class ItemHelper {
    private static Boolean skipValidations = false; 
    private static final string OBJECT_ITEM = 'dmpl__Item__c';
 
    public static final string ITEM_TYPE_PRODUCT = 'Product';
    public static final string ITEM_TYPE_PART = 'Part';
    public static final string ITEM_TYPE_WORKITEM = 'Work Item';
    public static final string ITEM_TYPE_CHARGEITEM = 'Charge Item';
    public static final string ITEM_TYPE_SERVICECONTRACT = 'Service Contract';
    public static final string ITEM_TYPE_SUBSCRIPTION = 'Subscription';
    public static final string ITEM_TYPE_DISCOUNT = 'Discount';

    public static final Integer LINE_QUANTITY_DECIMAL_PRECISION = 6;
    public static final Integer ITEM_QUANTITY_DECIMAL_PRECISION = 2;

    private static final List<String> LIST_NON_EDITABLE_FIELDS = new List<String>{};
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{};
    private static final List<String> LIST_FIELDS_LOCKEDIFTRANSACTED = new List<String>{
        'dmpl__AllowService__c',
        'dmpl__ClaimToAccountId__c',
        'dmpl__ContractPostingTreatment__c',
        'dmpl__InventoryValuationMethod__c',
        'dmpl__InvoiceGroup__c',
        'dmpl__IsPackage__c',
        'dmpl__IsSKURequired__c',
        'dmpl__ItemSubType__c',
        'dmpl__ItemType__c',
        'dmpl__TrackAsset__c',
        'dmpl__TrackInventory__c',
        'dmpl__TrackLots__c',
        'dmpl__QuantityUnitOfMeasure__c'
    };

    public static void validateData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__Item__c> oldEntries, 
        List<dmpl__Item__c> newEntries)
    { 
        try{     
            if(isInsert){
                FieldMappingHelper.copyFieldMappingData(
                    newEntries);
            }
            if(skipValidations){
                return;
            }
            if(isInsert){
                validateNewItemFields(newEntries);
            }else if(isUpdate){
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, oldEntries, newEntries);
                DocumentHelper.validateChangeInKeyFields(LIST_NON_EDITABLE_FIELDS, oldEntries, newEntries);
                // DocumentHelper.validateChangeInLockedIfTransactedFields(
                //     LIST_FIELDS_LOCKEDIFTRANSACTED, 
                //     oldEntries, 
                //     newEntries, 
                //     queryTransactedItemIds(
                //         CollectionHelper.extractIds(oldEntries)));
            }else if(isDelete){
                DocumentHelper.validateCanBeDeleted(
                    oldEntries, 
                    queryTransactedItemIds(
                        CollectionHelper.extractIds(oldEntries)));
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }
    
    public static void postData(
        Boolean isInsert, 
        Boolean isDelete,
        Boolean isUpdate, 
        List<dmpl__Item__c> oldEntries, 
        List<dmpl__Item__c> newEntries)
    {
        if(isUpdate){
            OrgCacheHelper.removeSObjects(newEntries);
        } else if(isDelete){
            OrgCacheHelper.removeSObjects(oldEntries);
        }
    }

    public static void setQuantityFromUOM(
        List<SObject> newEntries,
        List<SObject> oldEntries,
        Map<Id, dmpl__Item__c> items){
        setQuantityFromUOM(newEntries, oldEntries, items, null, null);
    }

    public static void setQuantityFromUOM(
        List<SObject> newEntries,
        List<SObject> oldEntries,
        Map<Id, dmpl__Item__c> items,
        String quantityFieldName,
        String itemFieldName){
        if(quantityFieldName == null){
            quantityFieldName = 'dmpl__Quantity__c';
        }
        if(itemFieldName == null){
            itemFieldName = 'dmpl__ItemId__c';
        }
        List<String> uoms = CollectionHelper.extractStrings(
            newEntries,
            'dmpl__UOM__c');
        List<String> uoms1 = CollectionHelper.extractStrings(
            newEntries,
            'dmpl__UOM1__c');
        if ((uoms.size() == 0 && uoms1.size() == 0)) {
            return;
        }
        for (SObject line : newEntries) {
            dmpl__Item__c item = items.get((Id)line.get(itemFieldName));
            if(item == null){
                continue;
            }
            if(line.get(quantityFieldName) != null ){
                Integer lineDecimalPrecision = (item.dmpl__UOMDecimalPrecision__c != null) ? (Integer)item.dmpl__UOMDecimalPrecision__c : LINE_QUANTITY_DECIMAL_PRECISION;
                line.put(quantityFieldName, ((Decimal)line.get(quantityFieldName)).setScale(lineDecimalPrecision, RoundingMode.HALF_UP)); 
            }
            if(line.get('dmpl__UOM__c') == null && line.get('dmpl__UOM1__c') == null){
                continue;
            }
            Boolean isQuantityModified = false;
            if(oldEntries != null){
                SObject oldEntry = CollectionHelper.getObject(
                    oldEntries,
                    (Id)line.get('Id'));
                isQuantityModified = (oldEntry != null 
                    && oldEntry.get(quantityFieldName) != line.get(quantityFieldName));
            }
            List<dmpl__ItemUnitOfMeasure__c> itemUOMs = item.dmpl__ItemUnitOfMeasures__r;
            List<String> availbleUOMs = CollectionHelper.extractStrings(
                itemUOMs,
                'dmpl__QuantityUnitOfMeasure__c');

            if ((line.get('dmpl__UOM__c') != null && !availbleUOMs.contains((String)line.get('dmpl__UOM__c'))) || 
                (line.get('dmpl__UOM1__c') != null && !availbleUOMs.contains((String)line.get('dmpl__UOM1__c')))) {
                line.addError(system.Label.Validation_Invalid_UOM);
                continue;
            }
            
            dmpl__ItemUnitOfMeasure__c itemUOM = line.get('dmpl__UOM__c') != null ? ((dmpl__ItemUnitOfMeasure__c)CollectionHelper.getObjectByString(
                itemUOMs,
                'dmpl__QuantityUnitOfMeasure__c',
                (String)line.get('dmpl__UOM__c'))) : null;
            dmpl__ItemUnitOfMeasure__c itemUOM1 = line.get('dmpl__UOM1__c') !=null ? ((dmpl__ItemUnitOfMeasure__c)CollectionHelper.getObjectByString(
                itemUOMs,
                'dmpl__QuantityUnitOfMeasure__c',
                (String)line.get('dmpl__UOM1__c'))) : null;
            if(itemUOM == null && line.get('dmpl__UOMQuantity__c') != null){
                line.put('dmpl__UOMQuantity__c', null);
            }
            if(itemUOM1 == null && line.get('dmpl__UOMQuantity1__c') != null){
                line.put('dmpl__UOMQuantity1__c', null);
            }
            Decimal lineQuantity = (line.get(quantityFieldName)!= null) ? ((Decimal)line.get(quantityFieldName)) : 0;
            Integer UOMPrecision = (itemUOM ==null || itemUOM.dmpl__UOMDecimalPrecision__c ==null) ? ITEM_QUANTITY_DECIMAL_PRECISION : (Integer)itemUOM.dmpl__UOMDecimalPrecision__c;
            Integer UOM1Precision = (itemUOM1 ==null || itemUOM1.dmpl__UOMDecimalPrecision__c ==null) ? ITEM_QUANTITY_DECIMAL_PRECISION : (Integer)itemUOM1.dmpl__UOMDecimalPrecision__c;

            if(itemUOM != null && line.get('dmpl__UOMQuantity__c') != null){
                line.put(
                    'dmpl__UOMQuantity__c', 
                    ((Decimal)line.get('dmpl__UOMQuantity__c')).setScale(
                        UOMPrecision, 
                        RoundingMode.HALF_UP));
            }
            if(itemUOM1 != null && line.get('dmpl__UOMQuantity1__c') != null){
                line.put(
                    'dmpl__UOMQuantity1__c', 
                    ((Decimal)line.get('dmpl__UOMQuantity1__c')).setScale(
                        UOM1Precision, 
                        RoundingMode.HALF_UP));
            }

            if((!isQuantityModified) && ((itemUOM != null && line.get('dmpl__UOMQuantity__c')!= null) 
                || (itemUOM1 != null && line.get('dmpl__UOMQuantity1__c') != null))){ 
                if((itemUOM != null && line.get('dmpl__UOMQuantity__c')!= null) 
                    || (itemUOM1 != null && line.get('dmpl__UOMQuantity1__c') != null)){
                        lineQuantity = 0;
                        if(itemUOM != null && line.get('dmpl__UOMQuantity__c') != null) {
                            line.put('dmpl__ConversionRatio__c', itemUOM.dmpl__ConversionRatio__c);
                            lineQuantity += ((Decimal)line.get('dmpl__UOMQuantity__c')) * itemUOM.dmpl__ConversionRatio__c;
                        }
                        if(itemUOM1 != null && line.get('dmpl__UOMQuantity1__c') != null) {
                            line.put('dmpl__ConversionRatio1__c', itemUOM1.dmpl__ConversionRatio__c);
                            lineQuantity += ((Decimal)line.get('dmpl__UOMQuantity1__c')) * itemUOM1.dmpl__ConversionRatio__c;
                        }
                }
                if(item.dmpl__UOMDecimalPrecision__c ==null){
                    line.put(quantityFieldName, lineQuantity);
                }else {
                    line.put(quantityFieldName, lineQuantity.setScale((Integer)item.dmpl__UOMDecimalPrecision__c, RoundingMode.HALF_UP));
                }
            }else if((Decimal)line.get(quantityFieldName) > 0 
                && (itemUOM != null || itemUOM1 != null)){
                    if(item.dmpl__UOMDecimalPrecision__c ==null){
                        line.put(quantityFieldName, lineQuantity);
                    }else {
                        line.put(quantityFieldName, lineQuantity.setScale((Integer)item.dmpl__UOMDecimalPrecision__c, RoundingMode.HALF_UP));
                    }
                if(itemUOM != null && itemUOM1 != null){
                    if(itemUOM.dmpl__ConversionRatio__c >= itemUOM1.dmpl__ConversionRatio__c ){
                        Decimal floorQuantity = Math.floor(lineQuantity/itemUOM.dmpl__ConversionRatio__c);
                        line.put('dmpl__UOMQuantity__c', floorQuantity.setScale(
                            UOMPrecision, 
                            RoundingMode.HALF_UP));
                        line.put('dmpl__UOMQuantity1__c', (
                            (lineQuantity - (floorQuantity * itemUOM.dmpl__ConversionRatio__c))/itemUOM1.dmpl__ConversionRatio__c)?.setScale(
                                UOM1Precision, 
                                RoundingMode.HALF_UP));
                    }else{
                        Decimal floorQuantity = Math.floor(lineQuantity/itemUOM1.dmpl__ConversionRatio__c);
                        line.put('dmpl__UOMQuantity1__c', floorQuantity.setScale(
                            UOM1Precision, 
                            RoundingMode.HALF_UP));
                        line.put('dmpl__UOMQuantity__c', (
                            (lineQuantity - (floorQuantity * itemUOM1.dmpl__ConversionRatio__c))/itemUOM.dmpl__ConversionRatio__c)?.setScale(
                                    UOMPrecision, 
                                    RoundingMode.HALF_UP));
                    }
                }else if(itemUOM != null && itemUOM.dmpl__ConversionRatio__c > 0){
                    line.put('dmpl__UOMQuantity__c', (lineQuantity/ itemUOM.dmpl__ConversionRatio__c)?.setScale(UOMPrecision, RoundingMode.HALF_UP));
                }else if(itemUOM1 != null && itemUOM1.dmpl__ConversionRatio__c > 0){
                    line.put('dmpl__UOMQuantity1__c', (lineQuantity/ itemUOM1.dmpl__ConversionRatio__c)?.setScale(UOM1Precision, RoundingMode.HALF_UP));
                }
                if(itemUOM!=null){
                    line.put('dmpl__ConversionRatio__c', itemUOM.dmpl__ConversionRatio__c);
                }
                if(itemUOM1!=null){
                    line.put('dmpl__ConversionRatio1__c', itemUOM1.dmpl__ConversionRatio__c);
                }
            }
        }
    }

    @namespaceAccessible
    public static dmpl__Item__c getCachedItem(Id itemId){
        if (!OrgCacheHelper.isPlatformCacheEnabled(OBJECT_ITEM)){
            return (dmpl__Item__c)CollectionHelper.getFirstIfExists(queryItems(new List<Id>{ itemId }));
        }
        dmpl__Item__c item = (dmpl__Item__c)OrgCacheHelper.getSObject(OBJECT_ITEM, itemId);
        if(item == null){
            item = (dmpl__Item__c)CollectionHelper.getFirstIfExists(queryItems(new List<Id>{ itemId }));
            if(item!=null){
                OrgCacheHelper.setSObject(item);
            }
        }

        return item;
    }

    @namespaceAccessible
    public static List<dmpl__Item__c> getCachedItems(List<Id> itemIds){
        if (!OrgCacheHelper.isPlatformCacheEnabled(OBJECT_ITEM)){
            return queryItems(itemIds);
        }
        List<dmpl__Item__c> items = new List<dmpl__Item__c>();
        List<Id> missingItemIds = new List<Id>();
        for(Id itemId : itemIds){
            dmpl__Item__c item = (dmpl__Item__c)OrgCacheHelper.getSObject(OBJECT_ITEM, itemId);
            if(item == null){
                missingItemIds.add(itemId);
            }else{
                items.add(item);
            }
        }
        if(missingItemIds.size()>0){
            List<dmpl__Item__c> missingItems = queryItems(missingItemIds);
            OrgCacheHelper.setSObjects(missingItems);
            items.addAll(missingItems);
        }

        return items;
    }

    // private static List<Id> queryTransactedItemIds(List<Id> itemIds){
    //     SecurityHelper.ensureCanReadField(
    //         'dmpl__ItemId__c', 
    //         'dmpl__InventoryLedger__c');
    //     return = CollectionHelper.extractIds([
    //         SELECT dmpl__ItemId__c
    //         FROM dmpl__InventoryLedger__c
    //         WHERE dmpl__ItemId__c IN:itemIds
    //     ]);
    // }

    private static List<Id> queryTransactedItemIds(List<Id> itemIds){
        SecurityHelper.ensureCanReadField(
            'dmpl__ItemId__c', 
            'dmpl__InventoryLedger__c');
            List<AggregateResult> results =   [
            SELECT dmpl__ItemId__c
            FROM dmpl__InventoryLedger__c
            WHERE dmpl__ItemId__c IN:itemIds
            GROUP BY dmpl__ItemId__c
        ];
        List<Id> itemId = new List<Id>();

        Set<Id> transactedIdSet = new Set<Id>();
        for (AggregateResult result : results) {
            Id transactedId = (Id) result.get('dmpl__ItemId__c'); 
            transactedIdSet.add(transactedId);
        }
        for(id i: transactedIdSet){
            itemId.add(i);
        }
        return itemId;
    }
    
    private static void validateNewItemFields(
        List<dmpl__Item__c> newEntries){
            for(dmpl__Item__c lineEntry : newEntries){
                if(lineEntry.dmpl__TrackAsset__c 
                    && (!lineEntry.dmpl__TrackLots__c)){
                        lineEntry.addError(
                            String.valueOf(System.Label.Item_TrackAssetRequiresTrackLots));
                    }
            }
    }

    private static List<dmpl__Item__c> queryItems(List<Id> itemIds){
        SecurityHelper.ensureCanReadFields(new String[]{
            'dmpl__AllowService__c',
            'dmpl__ClaimToAccountId__c',
            'dmpl__ContractPostingTreatment__c',
            'dmpl__DiscountItemGroupId__c',
            'dmpl__InventoryValuationMethod__c',
            'dmpl__InvoiceGroup__c',
            'dmpl__IsActive__c',
            'dmpl__IsPackage__c',
            'dmpl__IsRegistrationRequired__c',
            'dmpl__IsSKURequired__c',
            'dmpl__ItemCode__c',
            'dmpl__Description__c',
            'dmpl__ItemSubType__c',
            'dmpl__ItemType__c',
            'dmpl__ProductDemoItemGroup__c',
            'dmpl__ProductMaintenanceScheduleId__c',
            'dmpl__RequireInspectionOnDelivery__c',
            'dmpl__RequireInspectionOnReceipt__c',
            'dmpl__RequireRepairOrderOnReceipt__c',
            'dmpl__SchemeItemGroupId__c',
            'dmpl__ServiceDurationInMinutes__c',
            'dmpl__TaxItemGroupId__c',
            'dmpl__TrackAsset__c',
            'dmpl__TrackInventory__c',
            'dmpl__TrackLots__c',
            'dmpl__QuantityUnitOfMeasure__c',
            'dmpl__OnlySoldInPackage__c',
            'dmpl__MarkupRate__c',
            'dmpl__PricingMethod__c',
            'dmpl__ChargeType__c',
            'dmpl__BillingType__c',
            'dmpl__BillingFrequency__c',
            'dmpl__SubscriptionDurationInMonths__c'
        }, OBJECT_ITEM);
        SecurityHelper.ensureCanReadFields(new String[]{
            'dmpl__ItemId__c',
            'dmpl__ApplicableFor__c',
            'dmpl__ComponentItemId__c',
            'dmpl__ComponentSKUId__c',
            'dmpl__FeatureId__r',
            'dmpl__IsBundled__c',
            'dmpl__IsMandatory__c',
            'dmpl__IsQuantityEditable__c',
            'dmpl__IsSelected__c',
            'dmpl__SKUId__c',
            'dmpl__MaxQuantity__c',
            'dmpl__MinQuantity__c',
            'dmpl__PackageType__c',
            'dmpl__Quantity__c',
            'dmpl__SortOrder__c',
            'dmpl__FeatureType__c'
        }, 'dmpl__ItemComponent__c');
        SecurityHelper.ensureCanReadFields(new String[]{
            'dmpl__FeatureGroup__c',
            'dmpl__MaxComponentCount__c',
            'dmpl__MinComponentCount__c',
            'dmpl__ShowinCatalog__c',
            'dmpl__SortOrder__c'
        }, 'dmpl__ItemFeature__c');
        SecurityHelper.ensureCanReadFields(new String[]{
            'dmpl__ItemId__c',
            'dmpl__IsDefault__c',
            'dmpl__ProductColor__c',
            'dmpl__QuantityUnitOfMeasure__c',
            'dmpl__UnitOfMeasureOfConversion__c'
        }, 'dmpl__SKU__c');
        SecurityHelper.ensureCanReadFields(new String[]{
            'dmpl__ItemId__c',
            'dmpl__AlternateItemId__c',
            'dmpl__AlternateType__c',
            'dmpl__EffectiveFromDate__c',
            'dmpl__EffectiveToDate__c'
        }, 'dmpl__ItemAlternate__c');       
        return [SELECT Id, 
            Name, 
            dmpl__AllowService__c,
            dmpl__ClaimToAccountId__c,
            dmpl__ContractPostingTreatment__c,
            dmpl__DiscountItemGroupId__c,
            dmpl__InventoryValuationMethod__c,
            dmpl__InvoiceGroup__c,
            dmpl__IsActive__c,
            dmpl__IsPackage__c,
            dmpl__IsRegistrationRequired__c,
            dmpl__IsSKURequired__c,
            dmpl__ItemCode__c,
            dmpl__Description__c,
            dmpl__ItemSubType__c,
            dmpl__ItemType__c,
            dmpl__ProductDemoItemGroup__c,
            dmpl__ProductMaintenanceScheduleId__c,
            dmpl__RequireInspectionOnDelivery__c,
            dmpl__RequireInspectionOnReceipt__c,
            dmpl__RequireRepairOrderOnReceipt__c,
            dmpl__SchemeItemGroupId__c,
            dmpl__ServiceDurationInMinutes__c,
            dmpl__TaxItemGroupId__c,
            dmpl__TrackAsset__c,
            dmpl__TrackInventory__c,
            dmpl__TrackLots__c,
            dmpl__QuantityUnitOfMeasure__c,
            dmpl__OnlySoldInPackage__c,
            dmpl__MarkupRate__c,
            dmpl__PricingMethod__c,
            dmpl__ChargeType__c,
            dmpl__BillingType__c,
            dmpl__BillingFrequency__c,
            dmpl__SubscriptionDurationInMonths__c,
            dmpl__UOMDecimalPrecision__c,
            (SELECT
                Id,
                dmpl__ItemId__c,
                dmpl__QuantityUnitOfMeasure__c,
                Name,
                dmpl__ConversionRatio__c,
                dmpl__UOMDecimalPrecision__c
            FROM dmpl__ItemUnitOfMeasures__r),
            (
                SELECT 
                    Id,
                    dmpl__ItemId__c,
                    dmpl__ApplicableFor__c,
                    dmpl__ComponentItemId__c,
                    dmpl__ComponentItemId__r.dmpl__ItemCode__c,
                    dmpl__ComponentItemId__r.dmpl__Description__c,
                    dmpl__ComponentItemId__r.Name,
                    dmpl__ComponentSKUId__c,
                    dmpl__ComponentSKUId__r.Name,
                    dmpl__FeatureId__c,
                    dmpl__FeatureId__r.Name,
                    dmpl__FeatureId__r.dmpl__FeatureGroup__c,
                    dmpl__FeatureId__r.dmpl__MaxComponentCount__c,
                    dmpl__FeatureId__r.dmpl__MinComponentCount__c,
                    dmpl__FeatureId__r.dmpl__ShowinCatalog__c,
                    dmpl__FeatureId__r.dmpl__SortOrder__c,
                    dmpl__IsBundled__c,
                    dmpl__IsMandatory__c,
                    dmpl__IsQuantityEditable__c,
                    dmpl__IsSelected__c,
                    dmpl__SKUId__c,
                    dmpl__MaxQuantity__c,
                    dmpl__MinQuantity__c,
                    dmpl__PackageType__c,
                    dmpl__Quantity__c,
                    dmpl__SortOrder__c,
                    dmpl__PartnerAccountId__c,
                    dmpl__PartnerAccountGroupId__c,
                    dmpl__FeatureType__c
                FROM dmpl__ItemComponents__r
                ORDER BY 
                    dmpl__FeatureId__r.dmpl__SortOrder__c, 
                    dmpl__SortOrder__c
            ),
            (SELECT
                Id, 
                dmpl__ItemId__c,
                dmpl__IsDefault__c,
                dmpl__ProductColor__c,
                dmpl__QuantityUnitOfMeasure__c,
                dmpl__UnitOfMeasureOfConversion__c
            FROM dmpl__SKUs__r
            ),
            (SELECT
                Id, 
                dmpl__ItemId__c,
                dmpl__AlternateItemId__c,
                dmpl__AlternateType__c,
                dmpl__EffectiveFromDate__c,
                dmpl__EffectiveToDate__c
            FROM dmpl__ItemsAlternates__r
            )
        FROM dmpl__Item__c
        WHERE Id IN:itemIds];
    }

    public static List<dmpl__Item__c> queryItems(
        string itemType, 
        Integer pageNumber, 
        Integer pageSize){
        String itemTypeSafe = String.escapeSingleQuotes(itemType);
        SecurityHelper.ensureCanReadFields(new String[]{
            'dmpl__AllowService__c',
            'dmpl__ClaimToAccountId__c',
            'dmpl__ContractPostingTreatment__c',
            'dmpl__DiscountItemGroupId__c',
            'dmpl__InventoryValuationMethod__c',
            'dmpl__InvoiceGroup__c',
            'dmpl__IsActive__c',
            'dmpl__IsPackage__c',
            'dmpl__IsRegistrationRequired__c',
            'dmpl__IsSKURequired__c',
            'dmpl__ItemCode__c',
            'dmpl__Description__c',
            'dmpl__ItemSubType__c',
            'dmpl__ItemType__c',
            'dmpl__ProductDemoItemGroup__c',
            'dmpl__ProductMaintenanceScheduleId__c',
            'dmpl__RequireInspectionOnDelivery__c',
            'dmpl__RequireInspectionOnReceipt__c',
            'dmpl__SchemeItemGroupId__c',
            'dmpl__ServiceDurationInMinutes__c',
            'dmpl__TaxItemGroupId__c',
            'dmpl__TrackAsset__c',
            'dmpl__TrackInventory__c',
            'dmpl__TrackLots__c',
            'dmpl__QuantityUnitOfMeasure__c',
            'dmpl__OnlySoldInPackage__c'
        }, OBJECT_ITEM);
        SecurityHelper.ensureCanReadFields(new String[]{
            'dmpl__ItemId__c',
            'dmpl__IsDefault__c',
            'dmpl__ProductColor__c',
            'dmpl__QuantityUnitOfMeasure__c',
            'dmpl__UnitOfMeasureOfConversion__c'
        }, 'dmpl__SKU__c');
        SecurityHelper.ensureCanReadFields(new String[]{
            'dmpl__ItemId__c',
            'dmpl__AlternateItemId__c',
            'dmpl__AlternateItemName__c',
            'dmpl__AlternateItemCode__c',
            'dmpl__AlternateType__c',
            'dmpl__EffectiveFromDate__c',
            'dmpl__EffectiveToDate__c'
        }, 'dmpl__ItemAlternate__c');
        return [SELECT Id, 
            Name, 
            dmpl__AllowService__c,
            dmpl__ClaimToAccountId__c,
            dmpl__ContractPostingTreatment__c,
            dmpl__DiscountItemGroupId__c,
            dmpl__InventoryValuationMethod__c,
            dmpl__InvoiceGroup__c,
            dmpl__IsActive__c,
            dmpl__IsPackage__c,
            dmpl__IsRegistrationRequired__c,
            dmpl__IsSKURequired__c,
            dmpl__ItemCode__c,
            dmpl__Description__c,
            dmpl__ItemSubType__c,
            dmpl__ItemType__c,
            dmpl__ProductDemoItemGroup__c,
            dmpl__ProductMaintenanceScheduleId__c,
            dmpl__RequireInspectionOnDelivery__c,
            dmpl__RequireInspectionOnReceipt__c,
            dmpl__SchemeItemGroupId__c,
            dmpl__ServiceDurationInMinutes__c,
            dmpl__TaxItemGroupId__c,
            dmpl__TrackAsset__c,
            dmpl__TrackInventory__c,
            dmpl__TrackLots__c,
            dmpl__QuantityUnitOfMeasure__c,
            dmpl__OnlySoldInPackage__c,
            (SELECT
                Id, 
                dmpl__ItemId__c,
                dmpl__IsDefault__c,
                dmpl__ProductColor__c,
                dmpl__QuantityUnitOfMeasure__c,
                dmpl__UnitOfMeasureOfConversion__c
            FROM dmpl__SKUs__r
            ),
            (SELECT
                Id, 
                dmpl__ItemId__c,
                dmpl__AlternateItemId__c,
                dmpl__AlternateItemName__c,
                dmpl__AlternateItemCode__c,
                dmpl__AlternateType__c,
                dmpl__EffectiveFromDate__c,
                dmpl__EffectiveToDate__c
            FROM dmpl__ItemsAlternates__r
            )
        FROM dmpl__Item__c
        WHERE dmpl__ItemType__c =:itemTypeSafe
        LIMIT :pageSize
        OFFSET : (pageNumber-1) * pageSize];
    }
}