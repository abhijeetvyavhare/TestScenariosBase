/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-14-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class ItemController {

    private static final Integer MAX_PAGE_SIZE = 1000;

    @AuraEnabled(cacheable = true)
    public static dmpl__Item__c getItem(Id itemId)
    {
        return ItemHelper.getCachedItem(itemId);
    }

    @AuraEnabled(cacheable = true)
    public static List<dmpl__Item__c> getItems(String itemType, Integer pageNumber, Integer pageSize)
    {
        if(pageSize >MAX_PAGE_SIZE){
            pageSize = MAX_PAGE_SIZE;
        }
        return ItemHelper.queryItems(itemType, pageNumber, pageSize);
    }

    @AuraEnabled(cacheable = true)
    public static Double getItemPrice(Id itemId, Id SKUId, Id priceListId, Date documentDate){
        return PriceListHelper.getApplicablePrice(priceListId, itemId, SKUId, documentDate);
    }
    
    @AuraEnabled(cacheable = true)
    public static Double getItemPrice(String priceType, Id accountId, Id partnerId, Id branchId, Id itemId, Id SKUId, Date documentDate){
        Id priceListId = PriceListHelper.getDefaultPriceListId(priceType, accountId, partnerId, branchId, documentDate);
        return PriceListHelper.getApplicablePrice(priceListId, itemId, SKUId, documentDate);
    }

    @AuraEnabled(cacheable = true)
    public static List<dmpl__PriceListRules__c> getItemPrices(List<Id> itemIds, List<Id> SKUIds, Id priceListId, Date documentDate){
        return PriceListHelper.getApplicablePrice(priceListId, itemIds, SKUIds, documentDate);
    }

    @AuraEnabled(cacheable = true)
    public static List<dmpl__PriceListRules__c> getItemPrices(String priceType, Id accountId, Id partnerId, Id branchId, List<Id> itemIds, List<Id> SKUIds, Date documentDate){
        Id priceListId = PriceListHelper.getDefaultPriceListId(priceType, accountId, partnerId, branchId, documentDate);
        return PriceListHelper.getApplicablePrice(priceListId, itemIds, SKUIds, documentDate);
    }

    @AuraEnabled(cacheable = true)
    public static Double getItemDiscount(Id itemId, Id SKUId, Id discountGroupId, Date documentDate){
        return DiscountGroupHelper.getApplicableDiscount(discountGroupId, itemId, SKUId, documentDate);
    }

    @AuraEnabled(cacheable = true)
    public static Id getTaxGroup(Id itemId, Id SKUId, Id partnerId, Id branchId, Date documentDate, String taxSupplyType){
        return TaxGroupHelper.getApplicableTaxGroup(partnerId, branchId, itemId, SKUId, documentDate, taxSupplyType);
    }

    @AuraEnabled(cacheable = true)
    public static List<AggregateResult> getItemStock(Id itemId, Id partnerId, Id branchId)
    {
        SecurityHelper.ensureCanReadFields(new String[]{'dmpl__QuantityAvailable__c','dmpl__QuantityInHand__c'},'dmpl__InventoryStock__c');
        List<AggregateResult> itemStock = 
        [SELECT
            SUM(QuantityAvailable__c) QuantityAvailable,
            SUM(QuantityInHand__c) QuantityInHand,
            BranchId__r.Name BranchName,
            BranchId__c BranchId
        FROM
            InventoryStock__c
        WHERE
            ItemId__c = :itemId
            AND PartnerAccountId__c =:partnerId
            // AND (BranchId__c =:branchId OR BranchId__c = null)
        GROUP BY
            BranchId__r.Name,
            BranchId__c
        ];
        // itemStock.addAll(
        //     [SELECT
        //     SUM(QuantityAvailable__c) QuantityAvailable,
        //     SUM(QuantityInHand__c) QuantityInHand
        // FROM
        //     InventoryStock__c
        // WHERE
        //     ItemId__c = :itemId
        //     AND PartnerAccountId__c =:partnerId
        //     AND BranchId__c !=:branchId
        // ]);
        return itemStock;
    }

    @AuraEnabled(cacheable = true)
    public static List<AggregateResult> getItemSKUStock(Id itemId, Id partnerId, Id branchId)
    {
        SecurityHelper.ensureCanReadFields(new String[]{'dmpl__QuantityAvailable__c','dmpl__QuantityInHand__c'},'dmpl__InventoryStock__c');
        List<AggregateResult> itemStock =  
        [SELECT
            SUM(QuantityAvailable__c) QuantityAvailable,
            SUM(QuantityInHand__c) QuantityInHand,
            SKUId__r.Name SKUName,
            BranchId__r.Name BranchName,
            BranchId__c BranchId
        FROM
            InventoryStock__c
        WHERE
            ItemId__c = :itemId
            AND PartnerAccountId__c =:partnerId
            // AND BranchId__c =:branchId
        GROUP BY
            SKUId__r.Name,
            BranchId__r.Name,
            BranchId__c
        ];

        // itemStock.addAll(
        // [SELECT
        //     SUM(QuantityAvailable__c) QuantityAvailable,
        //     SUM(QuantityInHand__c) QuantityInHand,
        //     SKUId__r.Name SKUName
        // FROM
        //     InventoryStock__c
        // WHERE
        //     ItemId__c = :itemId
        //     AND PartnerAccountId__c =:partnerId
        //     AND BranchId__c !=:branchId
        // GROUP BY
        //     SKUId__r.Name
        // ]);

        return itemStock;
    }

    @AuraEnabled(cacheable = true)
    public static List<AggregateResult> getItemSKUBranchStock(Id itemId, Id SKUId, Id partnerId)
    {
        SecurityHelper.ensureCanReadFields(new String[]{'dmpl__QuantityAvailable__c','dmpl__QuantityInHand__c'},'dmpl__InventoryStock__c');   
        return 
        [SELECT
            SUM(QuantityAvailable__c) QuantityAvailable,
            SUM(QuantityInHand__c) QuantityInHand,
            SKUId__r.Name SKUName,
            BranchId__r.Name BranchName,
            BranchId__c BranchId
        FROM
            InventoryStock__c
        WHERE
            ItemId__c = :itemId
            AND SKUID__c = :SKUId
            AND PartnerAccountId__c =:partnerId
        GROUP BY
            SKUId__r.Name,
            BranchId__r.Name,
            BranchId__c
        ];
    }

    @AuraEnabled(cacheable = true)
    public static List<AggregateResult> getItemLotTypeStock(Id itemId, Id itemLotTypeId, Id branchId)
    {
        SecurityHelper.ensureCanReadFields(new String[]{'dmpl__QuantityAvailable__c','dmpl__QuantityInHand__c'},'dmpl__ItemLot__c');   
        return 
        [SELECT
            SUM(QuantityAvailable__c) QuantityAvailable,
            SUM(QuantityInHand__c) QuantityInHand,
            dmpl__ItemLotTypeId__r.dmpl__ExternalItemCode__c SKUName,
            BranchId__r.Name BranchName,
            BranchId__c BranchId,
            MAX(dmpl__ItemLotTypeId__r.dmpl__MRP__c) MRP
        FROM
            ItemLot__c
        WHERE
            ItemId__c = :itemId
            AND dmpl__ItemLotTypeId__c = :itemLotTypeId
            AND BranchId__c =:branchId
        GROUP BY
            dmpl__ItemLotTypeId__r.dmpl__ExternalItemCode__c,
            BranchId__r.Name,
            BranchId__c
        ];
    }

    @AuraEnabled(cacheable = true)
    public static List<AggregateResult> getItemLotTypesStock(Id itemId, Id branchId)
    {
        SecurityHelper.ensureCanReadFields(new String[]{'dmpl__QuantityAvailable__c','dmpl__QuantityInHand__c'},'dmpl__ItemLot__c');   
        return 
        [SELECT
            SUM(QuantityAvailable__c) QuantityAvailable,
            SUM(QuantityInHand__c) QuantityInHand,
            dmpl__ItemLotTypeId__r.dmpl__ExternalItemCode__c SKUName,
            BranchId__r.Name BranchName,
            BranchId__c BranchId,
            MAX(dmpl__ItemLotTypeId__r.dmpl__MRP__c) MRP
        FROM
            ItemLot__c
        WHERE
            ItemId__c = :itemId
            // AND dmpl__ItemLotTypeId__c = :itemLotTypeId
            AND BranchId__c =:branchId
            AND dmpl__QuantityAvailable__c > 0
        GROUP BY
            dmpl__ItemLotTypeId__r.dmpl__ExternalItemCode__c,
            BranchId__r.Name,
            BranchId__c
        ];
    }

    @AuraEnabled(cacheable = true)
    public static List<AggregateResult> getItemAlternateStock(
        Id itemId, 
        Id partnerId, 
        Id branchId)
    {
        SecurityHelper.ensureCanReadFields(
            new String[]{
                'dmpl__QuantityAvailable__c',
                'dmpl__QuantityInHand__c'},
            'dmpl__InventoryStock__c');
        SecurityHelper.ensureCanReadFields(
            new String[]{
                'dmpl__AlternateItemId__c',
                'dmpl__AlternateType__c'},
            'dmpl__ItemAlternate__c');
        Map<Id,AggregateResult> itemAlternateMap = new Map<Id,AggregateResult>();
        List<dmpl__ItemAlternate__c> itemAlternates = [SELECT Id,
                dmpl__ItemId__c,
                dmpl__AlternateItemId__c,
                dmpl__AlternateType__c
            FROM dmpl__ItemAlternate__c
            WHERE dmpl__ItemId__c =:itemId
            AND (dmpl__EffectiveFromDate__c <=:Date.today() 
                OR dmpl__EffectiveFromDate__c = null) 
            AND (dmpl__EffectiveToDate__c >=:Date.today() 
                OR dmpl__EffectiveToDate__c = null)];
         
        List<AggregateResult> itemAlternatesWithoutStock = [SELECT
                Id,
                dmpl__AlternateType__c,
                dmpl__AlternateItemId__c,
                dmpl__AlternateItemId__r.Name ,dmpl__ItemId__c,
                SUM(QuantityAvailable__c) QuantityAvailable,
                SUM(QuantityInHand__c) QuantityInHand
            FROM dmpl__ItemAlternate__c
            WHERE dmpl__ItemId__c =:itemId
            AND (dmpl__EffectiveFromDate__c <=:Date.today() 
                OR dmpl__EffectiveFromDate__c = null) 
            AND (dmpl__EffectiveToDate__c >=:Date.today() 
                OR dmpl__EffectiveToDate__c = null)
            GROUP BY 
                Id,
                dmpl__ItemId__c,
                dmpl__AlternateType__c,
                dmpl__AlternateItemId__c,
                dmpl__AlternateItemId__r.Name];

        List<AggregateResult> itemStock = 
            [SELECT
                Id,
                ItemId__c,
                ItemId__r.Name,
                SUM(QuantityAvailable__c) QuantityAvailable,
                SUM(QuantityInHand__c) QuantityInHand,
                BranchId__r.Name BranchName,
                BranchId__c BranchId
            FROM
                InventoryStock__c
            WHERE
                ItemId__c IN :CollectionHelper.extractIds(itemAlternates, 'dmpl__AlternateItemId__c')
                AND PartnerAccountId__c =:partnerId
                AND (BranchId__c =:branchId)
            GROUP BY
                Id,
                ItemId__c,
                ItemId__r.Name,
                BranchId__r.Name,
                BranchId__c
            ];
        if(itemStock.size() == 0){
            //throw new AuraHandledException(System.Label.Item_Not_Found);
        }
        itemStock.addAll([SELECT Id,
            ItemId__c,
            ItemId__r.Name,
            SUM(QuantityAvailable__c) QuantityAvailable,
            SUM(QuantityInHand__c) QuantityInHand
        FROM
            InventoryStock__c
        WHERE
            ItemId__c IN :CollectionHelper.extractIds(itemAlternates, 'dmpl__AlternateItemId__c')
            AND PartnerAccountId__c =:partnerId
            AND (BranchId__c != :branchId)
        GROUP BY
            Id,
            ItemId__c,
            ItemId__r.Name
        ]);
        for (AggregateResult itemStockRecord : itemStock) {
            Id itemId2 = (Id)itemStockRecord.get('dmpl__ItemId__c'); 
            if (!itemAlternateMap.containsKey(itemId2)) {
                    itemAlternateMap.put(itemId2, itemStockRecord);
                }
        }

        for (AggregateResult itemAlternateRecord : itemAlternatesWithoutStock) {
            Id itemId1 = (Id)itemAlternateRecord.get('dmpl__AlternateItemId__c'); 
            if (!itemAlternateMap.containsKey(itemId1)) {
                itemAlternateMap.put(itemId1, itemAlternateRecord);
            }
        }
        return itemAlternateMap.values();
    }

    @AuraEnabled(cacheable=true)
    public static Map<Id,String> getAlternateItemTypes(Id itemId){
        Map<Id,String> itemTypes= new Map<Id,String>();
        List<dmpl__ItemAlternate__c> alternateItems = [
            SELECT Id, 
            dmpl__AlternateType__c, 
            dmpl__AlternateItemId__c 
            FROM dmpl__ItemAlternate__c 
            WHERE dmpl__ItemId__c = :itemId];
        for(dmpl__ItemAlternate__c item : alternateItems){
            itemTypes.put(item.dmpl__AlternateItemId__c,item.dmpl__AlternateType__c);
        }
        return itemTypes;
    }

    @AuraEnabled(cacheable=true)
    public static List<AggregateResult> getItemStocks(List<Id> itemIds, List<Id> partnerAccountIds, List<Id> branchIds)
    {
        List<AggregateResult> result = new List<AggregateResult>();
        try 
        {
            SecurityHelper.ensureCanReadFields(new String[]{'dmpl__QuantityAvailable__c','dmpl__QuantityInHand__c'},'dmpl__InventoryStock__c');
            result.addAll(
            [SELECT
                SUM(dmpl__QuantityAvailable__c) QuantityAvailable,
                SUM(dmpl__QuantityInHand__c) QuantityInHand,
                dmpl__ItemId__c ItemId,
                dmpl__ItemId__r.Name ItemName,
                dmpl__SKUId__c SKUId,
                dmpl__SKUId__r.Name SKUName,
                dmpl__BranchId__r.Name BranchName,
                dmpl__BranchId__c BranchId
            FROM
                dmpl__InventoryStock__c
            WHERE
                dmpl__ItemId__c IN : itemIds
                AND dmpl__BranchId__c IN: branchIds
            GROUP BY
                dmpl__ItemId__c,
                dmpl__ItemId__r.Name,
                dmpl__SKUId__c,
                dmpl__SKUId__r.Name,
                dmpl__BranchId__r.Name,
                dmpl__BranchId__c
            ]);
        } 
        catch (Exception e) 
        {
            ExceptionLogHelper.logException(e);
            throw new AuraHandledException(e.getMessage());
        }
        return result;
    }
}