public with sharing class PackageHelper {

    private static final String PACKAGE_APPLICABLEFOR_SALES = 'Sale';
    private static final String PACKAGE_APPLICABLEFOR_PURCHASE = 'Purchase';
    private static final String PACKAGE_APPLICABLEFOR_SERVICE = 'Service';
    private static final String PACKAGE_TYPE_MULTIPLE = 'Multiple Of Package';
    private static final String PACKAGE_TYPE_INDEPENDENT = 'Independent Of Package';

    private static final string FIELD_SALEORDELINE_ITEMID = 'dmpl__ItemId__c';
    private static final string FIELD_SALEINVOICELINE_ITEMID = 'dmpl__ItemId__c';


    public static List<PackageComponentLine> getPackageConfiguration(
        Id itemId, 
        Id skuId, 
        Id partnerAccountId,
        Id accountId,
        Id branchId){
        
        dmpl__Item__c item = ItemHelper.getCachedItem(itemId);
        Account partnerAccount = AccountHelper.getCachedDealerAccount(partnerAccountId);
        
        if(item == null){
            return null;
        }

        List<dmpl__ItemComponent__c> components = getApplicableItemFeatures(
                    item, 
                    skuId, 
                    partnerAccount);
        Id priceListId = PriceListHelper.getDefaultPriceListId(PriceListHelper.PRICELIST_TYPE_SALE, 
            accountId, partnerAccountId, branchId, Date.today());
        List<Id> itemIds = CollectionHelper.extractIds(components, 'dmpl__ComponentItemId__c'); 
        List<Id> skuIds = CollectionHelper.extractIds(components, 'dmpl__ComponentSKUId__c');
        List<dmpl__PriceListRules__c> prices = PriceListHelper.getApplicablePrice(
                priceListId, 
                itemIds, 
                skuIds, 
                Date.today());
        
        List<AggregateResult> itemStock = queryItemStock(itemIds, skuIds, partnerAccountId, branchId);
        return generatePackageCoponentsLines(components, prices, itemStock);
    }

    public static List<PackageComponentLine> getSaleOrderPackageConfiguration(
        Id saleOrderLineId){
        List<dmpl__SaleOrderLine__c> saleOrderLines = querySaleOrderLines(saleOrderLineId);
        dmpl__SaleOrderLine__c packageSaleOrderLine = (dmpl__SaleOrderLine__c)CollectionHelper.getObject(saleOrderLines, saleOrderLineId);
        if(packageSaleOrderLine == null){
            throw new DMPLException(
                String.format(
                    String.valueOf(
                        System.Label.Generic_MissingObject), 
                        new String[]
                        {
                            dmpl__SaleOrderLine__c.class.getName()
                        }));
        }
        dmpl__Item__c item = ItemHelper.getCachedItem(packageSaleOrderLine.dmpl__ItemId__c);
        if(item==null || (!item.dmpl__IsPackage__c)){
            return null;
        }
        Account partnerAccount = AccountHelper.getCachedDealerAccount(packageSaleOrderLine.dmpl__SaleOrderId__r?.dmpl__PartnerAccountId__c);
        List<dmpl__ItemComponent__c> components = getApplicableItemFeatures(
                    PACKAGE_APPLICABLEFOR_SALES, 
                    item, 
                    packageSaleOrderLine.dmpl__SKUId__c, 
                    partnerAccount, 
                    saleOrderLines);
        List<Id> itemIds = CollectionHelper.extractIds(components, 'dmpl__ComponentItemId__c'); 
        List<Id> skuIds = CollectionHelper.extractIds(components, 'dmpl__ComponentSKUId__c');            
        List<dmpl__PriceListRules__c> prices = PriceListHelper.getApplicablePrice(
                packageSaleOrderLine.dmpl__SaleOrderId__r?.dmpl__PriceListId__c, 
                itemIds, 
                skuIds, 
                packageSaleOrderLine.dmpl__SaleOrderId__r?.dmpl__DocumentDate__c);
        
        List<AggregateResult> itemStock = queryItemStock(itemIds, skuIds, partnerAccount.Id, packageSaleOrderLine.dmpl__SaleOrderId__r?.dmpl__BranchId__c) ;
        return generatePackageCoponentsLines(components, prices, itemStock);
    }

    public static List<PackageComponentLine> getServiceRequestPackageConfiguration(
        Id serviceRequestLineId){
        List<dmpl__ServiceRequestLine__c> serviceRequestLines = queryServiceRequestLines(serviceRequestLineId);
        dmpl__ServiceRequestLine__c packageServiceRequestLine = (dmpl__ServiceRequestLine__c)CollectionHelper.getObject(serviceRequestLines, serviceRequestLineId);
        if(packageServiceRequestLine == null){
            throw new DMPLException(
                String.format(
                    String.valueOf(
                        System.Label.Generic_MissingObject), 
                        new String[]
                        {
                            dmpl__ServiceRequestLine__c.class.getName()
                        }));
        }
        dmpl__Item__c item = ItemHelper.getCachedItem(packageServiceRequestLine.dmpl__ItemId__c);
        if(item==null || (!item.dmpl__IsPackage__c)){
            return null;
        }
        Account partnerAccount = AccountHelper.getCachedDealerAccount(packageServiceRequestLine.dmpl__ServiceRequestId__r?.dmpl__PartnerAccountId__c);
        List<dmpl__ItemComponent__c> components = getApplicableItemFeatures(
                    PACKAGE_APPLICABLEFOR_SALES, 
                    item, 
                    packageServiceRequestLine.dmpl__SKUId__c, 
                    partnerAccount, 
                    serviceRequestLines);
        List<Id> itemIds = CollectionHelper.extractIds(components, 'dmpl__ComponentItemId__c'); 
        List<Id> skuIds = CollectionHelper.extractIds(components, 'dmpl__ComponentSKUId__c');            
        List<dmpl__PriceListRules__c> prices = PriceListHelper.getApplicablePrice(
            packageServiceRequestLine.dmpl__ServiceRequestId__r?.dmpl__PriceListId__c, 
                itemIds, 
                skuIds, 
                packageServiceRequestLine.dmpl__ServiceRequestId__r?.dmpl__DocumentDate__c);
        
        List<AggregateResult> itemStock = queryItemStock(itemIds, skuIds, partnerAccount.Id, packageServiceRequestLine.dmpl__ServiceRequestId__r?.dmpl__BranchId__c) ;
        return generatePackageCoponentsLines(components, prices, itemStock);
    }    
    
    public static List<PackageComponentLine> getPurchaseOrderPackageConfiguration(
        Id purchaseOrderLineId){
        List<dmpl__PurchaseOrderLine__c> purchaseOrderLines = queryPurchaseOrderLines(purchaseOrderLineId);
        dmpl__PurchaseOrderLine__c packagePurchaseOrderLine = (dmpl__PurchaseOrderLine__c)CollectionHelper.getObject(purchaseOrderLines, purchaseOrderLineId);
        if(packagePurchaseOrderLine == null){
            throw new DMPLException(
                String.format(
                    String.valueOf(
                        System.Label.Generic_MissingObject), 
                        new String[]
                        {
                            dmpl__PurchaseOrderLine__c.class.getName()
                        }));
        }
        dmpl__Item__c item = ItemHelper.getCachedItem(packagePurchaseOrderLine.dmpl__ItemId__c);
        if(item==null || (!item.dmpl__IsPackage__c)){
            return null;
        }
        Account partnerAccount = AccountHelper.getCachedDealerAccount(packagePurchaseOrderLine.dmpl__PurchaseOrderId__r?.dmpl__PartnerAccountId__c);
        List<dmpl__ItemComponent__c> components = getApplicableItemFeatures(
                    PACKAGE_APPLICABLEFOR_PURCHASE, 
                    item, 
                    packagePurchaseOrderLine.dmpl__SKUId__c, 
                    partnerAccount, 
                    purchaseOrderLines);
        List<Id> itemIds = CollectionHelper.extractIds(components, 'dmpl__ComponentItemId__c'); 
        List<Id> skuIds = CollectionHelper.extractIds(components, 'dmpl__ComponentSKUId__c');            
        List<dmpl__PriceListRules__c> prices = PriceListHelper.getApplicablePrice(
                packagePurchaseOrderLine.dmpl__PurchaseOrderId__r?.dmpl__PriceListId__c, 
                itemIds, 
                skuIds, 
                packagePurchaseOrderLine.dmpl__PurchaseOrderId__r?.dmpl__DocumentDate__c);
        
        List<AggregateResult> itemStock = queryItemStock(itemIds, skuIds, partnerAccount.Id, packagePurchaseOrderLine.dmpl__PurchaseOrderId__r?.dmpl__BranchId__c) ;
        return generatePackageCoponentsLines(components, prices, itemStock);
    }

    public static List<PackageComponentLine> getSaleInvoicePackageConfiguration(
        Id saleInvoiceLineId){
        List<dmpl__SaleInvoiceLine__c> saleInvoiceLines = querySaleInvoiceLines(saleInvoiceLineId);
        dmpl__SaleInvoiceLine__c packageSaleInvoiceLine = (dmpl__SaleInvoiceLine__c)CollectionHelper.getObject(saleInvoiceLines, saleInvoiceLineId);
        if(packageSaleInvoiceLine == null){
            throw new DMPLException(
                String.format(
                    String.valueOf(
                        System.Label.Generic_MissingObject), 
                        new String[]
                        {
                            dmpl__SaleInvoiceLine__c.class.getName()
                        }));
        }
        dmpl__Item__c item = ItemHelper.getCachedItem(packageSaleInvoiceLine.dmpl__ItemId__c);
        if(item==null || (!item.dmpl__IsPackage__c)){
            return null;
        }
        Account partnerAccount = AccountHelper.getCachedDealerAccount(packageSaleInvoiceLine.dmpl__SaleInvoiceId__r?.dmpl__PartnerAccountId__c);
        List<dmpl__ItemComponent__c> components = getApplicableItemFeatures(
                    PACKAGE_APPLICABLEFOR_SALES, 
                    item, 
                    packageSaleInvoiceLine.dmpl__SKUId__c, 
                    partnerAccount, 
                    saleInvoiceLines);
        List<Id> itemIds = CollectionHelper.extractIds(components, 'dmpl__ComponentItemId__c'); 
        List<Id> skuIds = CollectionHelper.extractIds(components, 'dmpl__ComponentSKUId__c');            
        List<dmpl__PriceListRules__c> prices = PriceListHelper.getApplicablePrice(
                packageSaleInvoiceLine.dmpl__SaleInvoiceId__r?.dmpl__PriceListId__c, 
                itemIds, 
                skuIds, 
                packageSaleInvoiceLine.dmpl__SaleInvoiceId__r?.dmpl__DocumentDate__c);
        
        List<AggregateResult> itemStock = queryItemStock(itemIds, skuIds, partnerAccount.Id, packageSaleInvoiceLine.dmpl__SaleInvoiceId__r?.dmpl__BranchId__c) ;
        return generatePackageCoponentsLines(components, prices, itemStock);
    }

    public static List<PackageComponentLine> getQuotePackageConfiguration(
        Id quoteLineId){
        List<dmpl__QuoteLine__c> quoteLines = queryQuoteLines(quoteLineId);
        dmpl__QuoteLine__c packageQuoteLine = (dmpl__QuoteLine__c)CollectionHelper.getObject(quoteLines, quoteLineId);
       
        if(packageQuoteLine == null){
            throw new DMPLException(
                String.format(
                    String.valueOf(
                        System.Label.Generic_MissingObject), 
                        new String[]
                        {
                            dmpl__QuoteLine__c.class.getName()
                        }));
        }
        dmpl__Item__c item = ItemHelper.getCachedItem(packageQuoteLine.dmpl__ItemId__c);
        if(item==null || (!item.dmpl__IsPackage__c)){
            return null;
        }
        Account partnerAccount = AccountHelper.getCachedDealerAccount(packageQuoteLine.dmpl__QuoteId__r?.dmpl__PartnerAccountId__c);
        List<dmpl__ItemComponent__c> components = getApplicableItemFeatures(
                    PACKAGE_APPLICABLEFOR_SALES, 
                    item, 
                    packageQuoteLine.dmpl__SKUId__c, 
                    partnerAccount, 
                    quoteLines);
        List<Id> itemIds = CollectionHelper.extractIds(components, 'dmpl__ComponentItemId__c'); 
        List<Id> skuIds = CollectionHelper.extractIds(components, 'dmpl__ComponentSKUId__c');            
        List<dmpl__PriceListRules__c> prices = PriceListHelper.getApplicablePrice(
                packageQuoteLine.dmpl__QuoteId__r?.dmpl__PriceListId__c, 
                itemIds, 
                skuIds, 
                packageQuoteLine.dmpl__QuoteId__r?.dmpl__DocumentDate__c);
        
        List<AggregateResult> itemStock = queryItemStock(itemIds, skuIds, partnerAccount.Id, packageQuoteLine.dmpl__QuoteId__r?.dmpl__BranchId__c) ;
        return generatePackageCoponentsLines(components, prices, itemStock);
    }


    public static void applySaleOrderPackageConfiguration(
        Id saleOrderLineId, 
        List<PackageConfigLine> componentSettings){
        List<dmpl__SaleOrderLine__c> saleOrderLines = querySaleOrderLines(saleOrderLineId);
        dmpl__SaleOrderLine__c packageSaleOrderLine = (dmpl__SaleOrderLine__c)CollectionHelper.getObject(saleOrderLines, saleOrderLineId);
        if(packageSaleOrderLine == null){
            throw new DMPLException(
                String.format(
                    String.valueOf(
                        System.Label.Generic_MissingObject), 
                        new String[]
                        {
                            dmpl__SaleOrderLine__c.class.getName()
                        }));
        }
        dmpl__Item__c item = ItemHelper.getCachedItem(packageSaleOrderLine.dmpl__ItemId__c);
        Account partnerAccount = AccountHelper.getCachedDealerAccount(packageSaleOrderLine.dmpl__SaleOrderId__r?.dmpl__PartnerAccountId__c);
        if(item!=null && item.dmpl__IsPackage__c){
            SaleOrderLineHelper.applyPackageConfiguration(
                packageSaleOrderLine, 
                saleOrderLines, 
                getModifiedComponents(
                    PACKAGE_APPLICABLEFOR_SALES, 
                    item, 
                    packageSaleOrderLine.dmpl__SKUId__c, 
                    partnerAccount, 
                    componentSettings));
        }
    }
    
    public static void applyServiceRequestPackageConfiguration(
        Id serviceRequestLineId, 
        List<PackageConfigLine> componentSettings){
        List<dmpl__ServiceRequestLine__c> serviceRequestLines = queryServiceRequestLines(serviceRequestLineId);
        dmpl__ServiceRequestLine__c packageServiceRequestLine = (dmpl__ServiceRequestLine__c)CollectionHelper.getObject(serviceRequestLines, serviceRequestLineId);
        if(packageServiceRequestLine == null){
            throw new DMPLException(
                String.format(
                    String.valueOf(
                        System.Label.Generic_MissingObject), 
                        new String[]
                        {
                            dmpl__ServiceRequestLine__c.class.getName()
                        }));
        }
        dmpl__Item__c item = ItemHelper.getCachedItem(packageServiceRequestLine.dmpl__ItemId__c);
        Account partnerAccount = AccountHelper.getCachedDealerAccount(packageServiceRequestLine.dmpl__ServiceRequestId__r?.dmpl__PartnerAccountId__c);
        if(item!=null && item.dmpl__IsPackage__c){
            ServiceRequestLineHelper.applyPackageConfiguration(
                packageServiceRequestLine, 
                serviceRequestLines, 
                getModifiedComponents(
                    PACKAGE_APPLICABLEFOR_SALES, 
                    item, 
                    packageServiceRequestLine.dmpl__SKUId__c, 
                    partnerAccount, 
                    componentSettings));
        }
    }
    
    public static void applyPurchaseOrderPackageConfiguration(
        Id purchaseOrderLineId, 
        List<PackageConfigLine> componentSettings){
        List<dmpl__PurchaseOrderLine__c> purchaseOrderLines = queryPurchaseOrderLines(purchaseOrderLineId);
        dmpl__PurchaseOrderLine__c packagePurchaseOrderLine = (dmpl__PurchaseOrderLine__c)CollectionHelper.getObject(purchaseOrderLines, purchaseOrderLineId);
        if(packagePurchaseOrderLine == null){
            throw new DMPLException(
                String.format(
                    String.valueOf(
                        System.Label.Generic_MissingObject), 
                        new String[]
                        {
                            dmpl__PurchaseOrderLine__c.class.getName()
                        }));
        }
        dmpl__Item__c item = ItemHelper.getCachedItem(packagePurchaseOrderLine.dmpl__ItemId__c);
        Account partnerAccount = AccountHelper.getCachedDealerAccount(packagePurchaseOrderLine.dmpl__PurchaseOrderId__r?.dmpl__PartnerAccountId__c);
        if(item!=null && item.dmpl__IsPackage__c){
            PurchaseOrderLineHelper.applyPackageConfiguration(
                packagePurchaseOrderLine, 
                PurchaseOrderLines, 
                getModifiedComponents(
                    PACKAGE_APPLICABLEFOR_PURCHASE, 
                    item, 
                    packagePurchaseOrderLine.dmpl__SKUId__c, 
                    partnerAccount, 
                    componentSettings));
        }
    }

    public static void applySaleInvoicePackageConfiguration(
        Id saleInvoiceLineId, 
        List<PackageConfigLine> componentSettings){
        List<dmpl__SaleInvoiceLine__c> saleInvoiceLines = querySaleInvoiceLines(saleInvoiceLineId);
        dmpl__SaleInvoiceLine__c packageSaleInvoiceLine = (dmpl__SaleInvoiceLine__c)CollectionHelper.getObject(saleInvoiceLines, saleInvoiceLineId);
        if(packageSaleInvoiceLine == null){
            throw new DMPLException(
                String.format(
                    String.valueOf(
                        System.Label.Generic_MissingObject), 
                        new String[]
                        {
                            dmpl__SaleInvoiceLine__c.class.getName()
                        }));
        }
        dmpl__Item__c item = ItemHelper.getCachedItem(packageSaleInvoiceLine.dmpl__ItemId__c);
        Account partnerAccount = AccountHelper.getCachedDealerAccount(packageSaleInvoiceLine.dmpl__SaleInvoiceId__r?.dmpl__PartnerAccountId__c);
        if(item!=null && item.dmpl__IsPackage__c){
            SaleInvoiceLineHelper.applyPackageConfiguration(
                packageSaleInvoiceLine, 
                saleInvoiceLines, 
                getModifiedComponents(
                    PACKAGE_APPLICABLEFOR_SALES, 
                    item, 
                    packageSaleInvoiceLine.dmpl__SKUId__c, 
                    partnerAccount, 
                    componentSettings));
        }
    }

    public static void applyQuotePackageConfiguration(
        Id quoteLineId, 
        List<PackageConfigLine> componentSettings){
        List<dmpl__QuoteLine__c> quoteLines = queryQuoteLines(quoteLineId);
        dmpl__QuoteLine__c packageQuoteLine = (dmpl__QuoteLine__c)CollectionHelper.getObject(quoteLines, quoteLineId);
        if(packageQuoteLine == null){
            throw new DMPLException(
                String.format(
                    String.valueOf(
                        System.Label.Generic_MissingObject), 
                        new String[]
                        {
                            dmpl__QuoteLine__c.class.getName()
                        }));
        }
        dmpl__Item__c item = ItemHelper.getCachedItem(packageQuoteLine.dmpl__ItemId__c);
        Account partnerAccount = AccountHelper.getCachedDealerAccount(packageQuoteLine.dmpl__QuoteId__r?.dmpl__PartnerAccountId__c);
        if(item!=null && item.dmpl__IsPackage__c){
            ServiceEstimateLineHelper.applyPackageConfiguration(
                packageQuoteLine, 
                quoteLines, 
                getModifiedComponents(
                    PACKAGE_APPLICABLEFOR_SALES, 
                    item, 
                    packageQuoteLine.dmpl__SKUId__c, 
                    partnerAccount, 
                    componentSettings));
                    
        }
    }

    public static void populatePackageItems(
        List<dmpl__SaleOrderLine__c> newEntries){
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
                    ItemHelper.getCachedItems(
                        DocumentHelper.extractIds(
                            newEntries, 
                            FIELD_SALEORDELINE_ITEMID)));
        Map<dmpl__SaleOrderLine__c, List<dmpl__ItemComponent__c>> packagedItems = new Map<dmpl__SaleOrderLine__c, List<dmpl__ItemComponent__c>>();
        Account partnerAccount = null;
        for(dmpl__SaleOrderLine__c line : newEntries){
            dmpl__Item__c item = items.get(line.dmpl__ItemId__c);
            if(item!=null && item.dmpl__IsPackage__c){
                packagedItems.put(
                    line, 
                    getDefaultAdditionComponents(
                        PACKAGE_APPLICABLEFOR_SALES, 
                        item, 
                        line.dmpl__SKUId__c,
                        partnerAccount));
            }
        }

        SaleOrderLineHelper.addPackageSaleOrderLines(packagedItems);
    }

    public static void populatePackageItems(
        List<dmpl__QuoteLine__c> newEntries){
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
                    ItemHelper.getCachedItems(
                        DocumentHelper.extractIds(
                            newEntries, 
                            FIELD_SALEORDELINE_ITEMID)));
        Map<dmpl__QuoteLine__c, List<dmpl__ItemComponent__c>> packagedItems = new Map<dmpl__QuoteLine__c, List<dmpl__ItemComponent__c>>();
        Account partnerAccount = null;
        for(dmpl__QuoteLine__c line : newEntries){
            dmpl__Item__c item = items.get(line.dmpl__ItemId__c);
            if(item!=null && item.dmpl__IsPackage__c){
                packagedItems.put(
                    line, 
                    getDefaultAdditionComponents(
                        PACKAGE_APPLICABLEFOR_SALES, 
                        item, 
                        line.dmpl__SKUId__c,
                        partnerAccount));
            }
        }

        ServiceEstimateLineHelper.addPackageQuoteLines(packagedItems);
    }

    public static void populatePackageItems(
        List<dmpl__ServiceRequestLine__c> newEntries){
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
                    ItemHelper.getCachedItems(
                        DocumentHelper.extractIds(
                            newEntries, 
                            FIELD_SALEORDELINE_ITEMID)));
        Map<dmpl__ServiceRequestLine__c, List<dmpl__ItemComponent__c>> packagedItems = new Map<dmpl__ServiceRequestLine__c, List<dmpl__ItemComponent__c>>();
        Account partnerAccount = null;
        for(dmpl__ServiceRequestLine__c line : newEntries){
            dmpl__Item__c item = items.get(line.dmpl__ItemId__c);
            if(item!=null && item.dmpl__IsPackage__c){
                packagedItems.put(
                    line, 
                    getDefaultAdditionComponents(
                        PACKAGE_APPLICABLEFOR_SALES, 
                        item, 
                        line.dmpl__SKUId__c,
                        partnerAccount));
            }
        }

        ServiceRequestLineHelper.addPackageServiceRequestLines(packagedItems);
    }

    public static void populatePackageItems(
        List<dmpl__PurchaseOrderLine__c> newEntries){
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
                    ItemHelper.getCachedItems(
                        DocumentHelper.extractIds(
                            newEntries, 
                            FIELD_SALEORDELINE_ITEMID)));
        Map<dmpl__PurchaseOrderLine__c, List<dmpl__ItemComponent__c>> packagedItems = new Map<dmpl__PurchaseOrderLine__c, List<dmpl__ItemComponent__c>>();
        Account partnerAccount = null;
        for(dmpl__PurchaseOrderLine__c line : newEntries){
            dmpl__Item__c item = items.get(line.dmpl__ItemId__c);
            if(item!=null && item.dmpl__IsPackage__c){
                packagedItems.put(
                    line, 
                    getDefaultAdditionComponents(
                        PACKAGE_APPLICABLEFOR_PURCHASE, 
                        item, 
                        line.dmpl__SKUId__c,
                        partnerAccount));
            }
        }

        purchaseOrderLineHelper.addPackagePurchaseOrderLines(packagedItems);
    }

    public static void populatePackageItems(List<dmpl__SaleInvoiceLine__c> newEntries){
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
                    ItemHelper.getCachedItems(
                        DocumentHelper.extractIds(
                            newEntries, 
                            FIELD_SALEINVOICELINE_ITEMID)));
        Map<dmpl__SaleInvoiceLine__c, List<dmpl__ItemComponent__c>> packagedItems = new Map<dmpl__SaleInvoiceLine__c, List<dmpl__ItemComponent__c>>();
        Account partnerAccount = null;
        for(dmpl__SaleInvoiceLine__c line : newEntries){
            if(line.dmpl__SaleOrderLineId__c!=null){
                continue;
            }
            dmpl__Item__c item = items.get(line.dmpl__ItemId__c);
            if(item!=null && item.dmpl__IsPackage__c){
                packagedItems.put(
                    line, 
                    getDefaultAdditionComponents(
                        PACKAGE_APPLICABLEFOR_SALES, 
                        item, 
                        line.dmpl__SKUId__c,
                        partnerAccount));
            }
        }

        SaleInvoiceLineHelper.addPackageSaleInvoiceLines(packagedItems);
    }

    public static void populatePackageItems(List<dmpl__Quote__c> newEntries){
        Map<Id, Asset> assets = new Map<Id, Asset>(queryAssets(DocumentHelper.extractIds(newEntries, 'dmpl__AssetId__c')));
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
                            ItemHelper.getCachedItems(
                                DocumentHelper.extractIds(
                                assets.values(), 
                                FIELD_SALEINVOICELINE_ITEMID)));
        Map<dmpl__Quote__c, List<dmpl__ItemComponent__c>> packagedItems = new Map<dmpl__Quote__c, List<dmpl__ItemComponent__c>>();
        Account partnerAccount = null;
        for(dmpl__Quote__c line : newEntries){
            // if(line.dmpl__SaleOrderLineId__c!=null){
            //     continue;
            // }
            Asset currentAsset = assets.get(line?.dmpl__AssetId__c);
            dmpl__Item__c item = items.get(currentAsset?.dmpl__ItemId__c);
            if(item!=null && item.dmpl__IsPackage__c){
                packagedItems.put(
                    line, 
                    getDefaultAdditionComponents(
                        PACKAGE_APPLICABLEFOR_SERVICE, 
                        item, 
                        currentAsset?.dmpl__SKUId__c,
                        partnerAccount));
            }
        }

       // ServiceEstimateLineHelper.addPackageQuoteLines(packagedItems);
    }

    public static Decimal getDefaultComponentQuantity(Decimal parentLineQuantity, dmpl__ItemComponent__c component){
        Decimal componentQuantity = component.dmpl__Quantity__c == null ? 0 : component.dmpl__Quantity__c;
        if(component.dmpl__PackageType__c  == PACKAGE_TYPE_MULTIPLE) {
            return componentQuantity * parentLineQuantity;
        }else if(component.dmpl__PackageType__c  == PACKAGE_TYPE_INDEPENDENT) {
            return componentQuantity;
        }
        return componentQuantity;
    }
    
    public static void validateComponentsAdd(List<dmpl__SaleOrderLine__c> newEntries, List<dmpl__SaleOrderLine__c> parentLines){
        List<Id> itemIds =  DocumentHelper.extractIds(newEntries, FIELD_SALEORDELINE_ITEMID);
        itemIds.addAll(DocumentHelper.extractIds(parentLines, FIELD_SALEORDELINE_ITEMID));
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
                    ItemHelper.getCachedItems(itemIds));
        for(dmpl__SaleOrderLine__c line : newEntries){
            if(line.dmpl__PackageSaleOrderLineId__c!=null){
                dmpl__SaleOrderLine__c parentLine = (dmpl__SaleOrderLine__c)CollectionHelper.getObject(parentLines, line.dmpl__PackageSaleOrderLineId__c);
                if(parentLine==null){
                    continue;
                }
                dmpl__Item__c item = items.get(parentLine.dmpl__ItemId__c);
                if(item==null){
                    continue;
                }
                dmpl__ItemComponent__c component = (dmpl__ItemComponent__c)CollectionHelper.getObject(item.dmpl__ItemComponents__r, line.dmpl__ItemComponentId__c);
                if(component==null || component.dmpl__IsMandatory__c){
                    line.addError(System.Label.PackageError_ComponentNotAllowedInPackage);
                } else if(line.dmpl__Quantity__c < component.dmpl__MinQuantity__c 
                    ||line.dmpl__Quantity__c > component.dmpl__MaxQuantity__c){
                    line.addError(System.Label.PackageError_ComponentQuantityNotInRange);
                }
            }
        }
    }

    public static void validateComponentsAdd(List<dmpl__ServiceRequestLine__c> newEntries, List<dmpl__ServiceRequestLine__c> parentLines){
        List<Id> itemIds =  DocumentHelper.extractIds(newEntries, FIELD_SALEORDELINE_ITEMID);
        itemIds.addAll(DocumentHelper.extractIds(parentLines, FIELD_SALEORDELINE_ITEMID));
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
                    ItemHelper.getCachedItems(itemIds));
        for(dmpl__ServiceRequestLine__c line : newEntries){
            if(line.dmpl__PackageServiceRequestLineId__c!=null){
                dmpl__ServiceRequestLine__c parentLine = (dmpl__ServiceRequestLine__c)CollectionHelper.getObject(parentLines, line.dmpl__PackageServiceRequestLineId__c);
                if(parentLine==null){
                    continue;
                }
                dmpl__Item__c item = items.get(parentLine.dmpl__ItemId__c);
                if(item==null){
                    continue;
                }
                dmpl__ItemComponent__c component = (dmpl__ItemComponent__c)CollectionHelper.getObject(item.dmpl__ItemComponents__r, line.dmpl__ItemComponentId__c);
                if(component==null || component.dmpl__IsMandatory__c){
                    line.addError(System.Label.PackageError_ComponentNotAllowedInPackage);
                } else if(line.dmpl__Quantity__c < component.dmpl__MinQuantity__c 
                    ||line.dmpl__Quantity__c > component.dmpl__MaxQuantity__c){
                    line.addError(System.Label.PackageError_ComponentQuantityNotInRange);
                }
            }
        }
    }

    public static void validateComponentsAdd(List<dmpl__SaleInvoiceLine__c> newEntries, List<dmpl__SaleInvoiceLine__c> parentLines){
        List<Id> itemIds =  DocumentHelper.extractIds(newEntries, FIELD_SALEINVOICELINE_ITEMID);
        itemIds.addAll(DocumentHelper.extractIds(parentLines, FIELD_SALEINVOICELINE_ITEMID));
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
                    ItemHelper.getCachedItems(itemIds));
        for(dmpl__SaleInvoiceLine__c line : newEntries){
            if(line.dmpl__PackageSaleInvoiceLineId__c!=null){
                dmpl__SaleInvoiceLine__c parentLine = (dmpl__SaleInvoiceLine__c)CollectionHelper.getObject(parentLines, line.dmpl__PackageSaleInvoiceLineId__c);
                if(parentLine==null){
                    continue;
                }
                dmpl__Item__c item = items.get(parentLine.dmpl__ItemId__c);
                if(item==null){
                    continue;
                }
                dmpl__ItemComponent__c component = (dmpl__ItemComponent__c)CollectionHelper.getObject(item.dmpl__ItemComponents__r, line.dmpl__ItemComponentId__c);
                if(component==null || component.dmpl__IsMandatory__c){
                    line.addError(System.Label.PackageError_ComponentNotAllowedInPackage);
                } else if(line.dmpl__Quantity__c < component.dmpl__MinQuantity__c 
                    ||line.dmpl__Quantity__c > component.dmpl__MaxQuantity__c){
                    line.addError(System.Label.PackageError_ComponentQuantityNotInRange);
                }
            }
        }
    }

    public static void validateComponentQuantityEdit(List<dmpl__SaleOrderLine__c> modifiedEntries, List<dmpl__SaleOrderLine__c> parentLines){
        List<Id> itemIds =  DocumentHelper.extractIds(modifiedEntries, FIELD_SALEORDELINE_ITEMID);
        itemIds.addAll(DocumentHelper.extractIds(parentLines, FIELD_SALEORDELINE_ITEMID));
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
                    ItemHelper.getCachedItems(itemIds));
        for(dmpl__SaleOrderLine__c line : modifiedEntries){
            if(line.dmpl__PackageSaleOrderLineId__c==null){
                dmpl__Item__c item = items.get(line.dmpl__ItemId__c);
                if(item!=null && item.dmpl__IsPackage__c){
                    line.addError(System.Label.PackageError_ComponentQuantityEditNotAllowed);
                }
            }else {
                dmpl__SaleOrderLine__c parentLine = (dmpl__SaleOrderLine__c)CollectionHelper.getObject(parentLines, line.dmpl__PackageSaleOrderLineId__c);
                if(parentLine==null){
                    continue;
                }
                dmpl__Item__c item = items.get(parentLine.dmpl__ItemId__c);
                if(item==null){
                    continue;
                }
                dmpl__ItemComponent__c component = (dmpl__ItemComponent__c)CollectionHelper.getObject(item.dmpl__ItemComponents__r, line.dmpl__ItemComponentId__c);
                if(component!=null && (!component.dmpl__IsQuantityEditable__c)){
                        line.addError(System.Label.PackageError_ComponentQuantityEditNotAllowed);
                } else if(line.dmpl__Quantity__c < component.dmpl__MinQuantity__c 
                    ||line.dmpl__Quantity__c > component.dmpl__MaxQuantity__c){
                    line.addError(System.Label.PackageError_ComponentQuantityNotInRange);
                }
            }
        }
    }

    public static void validateComponentQuantityEdit(List<dmpl__PurchaseOrderLine__c> modifiedEntries, List<dmpl__PurchaseOrderLine__c> parentLines){
        List<Id> itemIds =  DocumentHelper.extractIds(modifiedEntries, FIELD_SALEORDELINE_ITEMID);
        itemIds.addAll(DocumentHelper.extractIds(parentLines, FIELD_SALEORDELINE_ITEMID));
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
                    ItemHelper.getCachedItems(itemIds));
        for(dmpl__PurchaseOrderLine__c line : modifiedEntries){
            if(line.dmpl__PackagePurchaseOrderLineId__c==null){
                dmpl__Item__c item = items.get(line.dmpl__ItemId__c);
                // if(item!=null && item.dmpl__IsPackage__c){
                //     line.addError(System.Label.PackageError_ComponentQuantityEditNotAllowed);
                // }
            }else {
                dmpl__PurchaseOrderLine__c parentLine = (dmpl__PurchaseOrderLine__c)CollectionHelper.getObject(parentLines, line.dmpl__PackagePurchaseOrderLineId__c);
                if(parentLine==null){
                    continue;
                }
                dmpl__Item__c item = items.get(parentLine.dmpl__ItemId__c);
                if(item==null){
                    continue;
                }
                dmpl__ItemComponent__c component = (dmpl__ItemComponent__c)CollectionHelper.getObject(item.dmpl__ItemComponents__r, line.dmpl__ItemComponentId__c);
                if(component!=null && (!component.dmpl__IsQuantityEditable__c)){
                        line.addError(System.Label.PackageError_ComponentQuantityEditNotAllowed);
                } else if(line.dmpl__Quantity__c < component.dmpl__MinQuantity__c 
                    ||line.dmpl__Quantity__c > component.dmpl__MaxQuantity__c){
                    line.addError(System.Label.PackageError_ComponentQuantityNotInRange);
                }
            }
        }
    }

    public static void validateComponentQuantityEdit(List<dmpl__SaleInvoiceLine__c> modifiedEntries, List<dmpl__SaleInvoiceLine__c> parentLines){
        List<Id> itemIds =  DocumentHelper.extractIds(modifiedEntries, FIELD_SALEINVOICELINE_ITEMID);
        itemIds.addAll(DocumentHelper.extractIds(parentLines, FIELD_SALEINVOICELINE_ITEMID));
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
                    ItemHelper.getCachedItems(itemIds));
        for(dmpl__SaleInvoiceLine__c line : modifiedEntries){
            if(line.dmpl__PackageSaleInvoiceLineId__c==null 
                && line.dmpl__PackageSaleOrderLineId__c == null){
                dmpl__Item__c item = items.get(line.dmpl__ItemId__c);
                if(item!=null && item.dmpl__IsPackage__c){
                    line.addError(System.Label.PackageError_ComponentQuantityEditNotAllowed);
                }
            }else {
                dmpl__SaleInvoiceLine__c parentLine = (dmpl__SaleInvoiceLine__c)CollectionHelper.getObject(parentLines, line.dmpl__PackageSaleInvoiceLineId__c);
                if(parentLine==null){
                    continue;
                }
                dmpl__Item__c item = items.get(parentLine.dmpl__ItemId__c);
                if(item==null){
                    continue;
                }
                dmpl__ItemComponent__c component = (dmpl__ItemComponent__c)CollectionHelper.getObject(item.dmpl__ItemComponents__r, line.dmpl__ItemComponentId__c);
                if(component!=null && (!component.dmpl__IsQuantityEditable__c)){
                        line.addError(System.Label.PackageError_ComponentQuantityEditNotAllowed);
                } else if(line.dmpl__Quantity__c < component.dmpl__MinQuantity__c 
                    ||line.dmpl__Quantity__c > component.dmpl__MaxQuantity__c){
                    line.addError(System.Label.PackageError_ComponentQuantityNotInRange);
                }
            }
        }
    }

    public static void validateComponentsDelete(List<dmpl__SaleOrderLine__c> oldEntries, List<dmpl__SaleOrderLine__c> parentLines){
        List<Id> itemIds =  DocumentHelper.extractIds(oldEntries, FIELD_SALEORDELINE_ITEMID);
        itemIds.addAll(DocumentHelper.extractIds(parentLines, FIELD_SALEORDELINE_ITEMID));
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
                    ItemHelper.getCachedItems(itemIds));
        for(dmpl__SaleOrderLine__c line : oldEntries){
            if(line.dmpl__PackageSaleOrderLineId__c==null){
                continue;
            }
            dmpl__SaleOrderLine__c parentLine = (dmpl__SaleOrderLine__c)CollectionHelper.getObject(parentLines, line.dmpl__PackageSaleOrderLineId__c);
            if(parentLine==null){
                continue;
            }
            dmpl__Item__c item = items.get(parentLine.dmpl__ItemId__c);
            if(item==null){
                continue;
            }
            dmpl__ItemComponent__c component = (dmpl__ItemComponent__c)CollectionHelper.getObject(item.dmpl__ItemComponents__r, line.dmpl__ItemComponentId__c);
            if(component!=null && component.dmpl__IsMandatory__c){
                line.addError(System.Label.PackageError_CannotDelteAMandatoryComponent);
            }
        }
    }

    public static void validateComponentsDelete(List<dmpl__QuoteLine__c> oldEntries, List<dmpl__QuoteLine__c> parentLines){
        List<Id> itemIds =  DocumentHelper.extractIds(oldEntries, FIELD_SALEORDELINE_ITEMID);
        itemIds.addAll(DocumentHelper.extractIds(parentLines, FIELD_SALEORDELINE_ITEMID));
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
                    ItemHelper.getCachedItems(itemIds));
        for(dmpl__QuoteLine__c line : oldEntries){
            if(line.dmpl__PackageQuoteLineId__c==null){
                continue;
            }
            dmpl__QuoteLine__c parentLine = (dmpl__QuoteLine__c)CollectionHelper.getObject(parentLines, line.dmpl__PackageQuoteLineId__c);
            if(parentLine==null){
                continue;
            }
            dmpl__Item__c item = items.get(parentLine.dmpl__ItemId__c);
            if(item==null){
                continue;
            }
            dmpl__ItemComponent__c component = (dmpl__ItemComponent__c)CollectionHelper.getObject(item.dmpl__ItemComponents__r, line.dmpl__ItemComponentId__c);
            if(component!=null && component.dmpl__IsMandatory__c){
                line.addError(System.Label.PackageError_CannotDelteAMandatoryComponent);
            }
        }
    }

    public static void validateComponentsDelete(List<dmpl__PurchaseOrderLine__c> oldEntries, List<dmpl__PurchaseOrderLine__c> parentLines){
        List<Id> itemIds =  DocumentHelper.extractIds(oldEntries, FIELD_SALEORDELINE_ITEMID);
        itemIds.addAll(DocumentHelper.extractIds(parentLines, FIELD_SALEORDELINE_ITEMID));
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
                    ItemHelper.getCachedItems(itemIds));
        for(dmpl__PurchaseOrderLine__c line : oldEntries){
            if(line.dmpl__PackagePurchaseOrderLineId__c==null){
                continue;
            }
            dmpl__PurchaseOrderLine__c parentLine = (dmpl__PurchaseOrderLine__c)CollectionHelper.getObject(parentLines, line.dmpl__PackagePurchaseOrderLineId__c);
            if(parentLine==null){
                continue;
            }
            dmpl__Item__c item = items.get(parentLine.dmpl__ItemId__c);
            if(item==null){
                continue;
            }
            dmpl__ItemComponent__c component = (dmpl__ItemComponent__c)CollectionHelper.getObject(item.dmpl__ItemComponents__r, line.dmpl__ItemComponentId__c);
            if(component!=null && component.dmpl__IsMandatory__c){
                line.addError(System.Label.PackageError_CannotDelteAMandatoryComponent);
            }
        }
    }

    public static void validateComponentsDelete(List<dmpl__SaleInvoiceLine__c> oldEntries, List<dmpl__SaleInvoiceLine__c> parentLines){
        List<Id> itemIds =  DocumentHelper.extractIds(oldEntries, FIELD_SALEINVOICELINE_ITEMID);
        itemIds.addAll(DocumentHelper.extractIds(parentLines, FIELD_SALEINVOICELINE_ITEMID));
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
                    ItemHelper.getCachedItems(itemIds));
        for(dmpl__SaleInvoiceLine__c line : oldEntries){
            if(line.dmpl__PackageSaleInvoiceLineId__c==null){
                continue;
            }
            dmpl__SaleInvoiceLine__c parentLine = (dmpl__SaleInvoiceLine__c)CollectionHelper.getObject(parentLines, line.dmpl__PackageSaleInvoiceLineId__c);
            if(parentLine==null){
                continue;
            }
            dmpl__Item__c item = items.get(parentLine.dmpl__ItemId__c);
            if(item==null){
                continue;
            }
            dmpl__ItemComponent__c component = (dmpl__ItemComponent__c)CollectionHelper.getObject(item.dmpl__ItemComponents__r, line.dmpl__ItemComponentId__c);
            if(component!=null && component.dmpl__IsMandatory__c){
                line.addError(System.Label.PackageError_CannotDelteAMandatoryComponent);
            }
        }
    }

    private static List<dmpl__ItemComponent__c> getDefaultAdditionComponents(String applicableFor, dmpl__Item__c item, Id skuId, Account partnerAccount){
        List<dmpl__ItemComponent__c> componentItems = new List<dmpl__ItemComponent__c>();
        for(dmpl__ItemComponent__c component : getApplicableItemFeatures(item, skuId, partnerAccount)){
            if((applicableFor == component.dmpl__ApplicableFor__c || component.dmpl__ApplicableFor__c == null)
                && (component.dmpl__IsMandatory__c
                    || component.dmpl__IsSelected__c
                )
            ){
                componentItems.add(component);
            }
        }
        return componentItems;
    }

    private static List<dmpl__ItemComponent__c> getModifiedComponents(String applicableFor, dmpl__Item__c item, Id skuId, Account partnerAccount, List<PackageConfigLine> componentSettings){
        List<dmpl__ItemComponent__c> componentItems = new List<dmpl__ItemComponent__c>();
        for(dmpl__ItemComponent__c component : getApplicableItemFeatures(item, skuId, partnerAccount)){
            if(applicableFor != component.dmpl__ApplicableFor__c || component.dmpl__ApplicableFor__c == null){
                continue;
            }
            PackageConfigLine applicableLine = findPackageConfigLine(componentSettings, component.Id);
            if(applicableLine!=null){
                component.dmpl__IsSelected__c = applicableLine.isSelected;
                component.dmpl__Quantity__c = applicableLine.quantity;
            }
            if(component.dmpl__IsMandatory__c
                || component.dmpl__IsSelected__c){
                    componentItems.add(component);
            }
        }
        return componentItems;
    }
    
    @testVisible
    private static PackageConfigLine findPackageConfigLine(List<PackageConfigLine> componentSettings, Id itemComponentId){
        for(PackageConfigLine line :  componentSettings){
            if(line.Id == itemComponentId){
                return line;
            }
        }
        return null;
    }

    private static List<dmpl__ItemComponent__c> getApplicableItemFeatures(dmpl__Item__c item, Id skuId, Account partnerAccount){
        List<dmpl__ItemComponent__c> components = new List<dmpl__ItemComponent__c>();
        for(dmpl__ItemComponent__c component : item.dmpl__ItemComponents__r){
            if(
                (component.dmpl__SKUId__c == skuId 
                    || component.dmpl__SKUId__c == null)
                &&
                (component.dmpl__PartnerAccountId__c == partnerAccount?.Id
                    || component.dmpl__PartnerAccountGroupId__c == partnerAccount?.dmpl__PartnerItemComponentAccountGroupId__c
                    || (component.dmpl__PartnerAccountId__c ==null && component.dmpl__PartnerAccountGroupId__c == null))
                && component.dmpl__FeatureType__c == 'Product Configurator'
                ){
                components.add(component);
            }
        }
        return components;
    }

    private static List<dmpl__ItemComponent__c> getApplicableItemFeatures(String applicableFor, dmpl__Item__c item, Id skuId, Account partnerAccount, List<SObject> lines){
        List<dmpl__ItemComponent__c> componentItems = new List<dmpl__ItemComponent__c>();
        for(dmpl__ItemComponent__c component : getApplicableItemFeatures(item, skuId, partnerAccount)){
            if(applicableFor != component.dmpl__ApplicableFor__c || component.dmpl__ApplicableFor__c == null){
                continue;
            }
            SObject applicableLine = CollectionHelper.getObject(lines, 'dmpl__ItemComponentId__c', component.Id);
            if(applicableLine!=null){
                component.dmpl__IsSelected__c = true;
                component.dmpl__Quantity__c = (Decimal)applicableLine.get('dmpl__Quantity__c');
            }else {
                component.dmpl__IsSelected__c = false;
            }
            componentItems.add(component);
        }
        return componentItems;
    }

    private static List<dmpl__SaleOrderLine__c> querySaleOrderLines(
        ID saleOrderLineId){
            SecurityHelper.ensureCanReadFields(new List<String>{
                'dmpl__PartnerAccountId__c', 
                'dmpl__BranchId__c',
                'dmpl__DocumentDate__c',
                'dmpl__PriceListId__c'
            },'dmpl__SaleOrder__c');
        SecurityHelper.ensureCanReadFields(new List<String>{
            'dmpl__PackageSaleOrderLineId__c', 
            'dmpl__ItemComponentId__c',
            'dmpl__ItemId__c',
            'dmpl__SKUId__c',
            'dmpl__Quantity__c'
        },'dmpl__SaleOrderLine__c');
        return [ SELECT ID, 
            dmpl__PackageSaleOrderLineId__c,
            dmpl__ItemComponentId__c,
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__Quantity__c,
            dmpl__SaleOrderId__r.dmpl__PartnerAccountId__c,
            dmpl__SaleOrderId__r.dmpl__BranchId__c,
            dmpl__SaleOrderId__r.dmpl__DocumentDate__c,
            dmpl__SaleOrderId__r.dmpl__PriceListId__c
        FROM dmpl__SaleOrderLine__c
        WHERE ID =: saleOrderLineId
        OR dmpl__PackageSaleOrderLineId__c = :saleOrderLineId];
    }  
    
    private static List<dmpl__ServiceRequestLine__c> queryServiceRequestLines(
        ID serviceRequestLineId){
            // SecurityHelper.ensureCanReadFields(new List<String>{
            //     'dmpl__PartnerAccountId__c', 
            //     'dmpl__BranchId__c',
            //     'dmpl__DocumentDate__c',
            //     'dmpl__PriceListId__c'
            // },'dmpl__ServiceRequest__c');
        // SecurityHelper.ensureCanReadFields(new List<String>{
        //     'dmpl__PackageServiceRequestLineId__c', 
        //     'dmpl__ItemComponentId__c',
        //     'dmpl__ItemId__c',
        //     'dmpl__SKUId__c',
        //     'dmpl__Quantity__c'
        // },'dmpl__ServiceRequestLine__c');
        return [ SELECT ID, 
            dmpl__PackageServiceRequestLineId__c,
            dmpl__ItemComponentId__c,
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__Quantity__c,
            dmpl__ServiceRequestId__r.dmpl__PartnerAccountId__c,
            dmpl__ServiceRequestId__r.dmpl__BranchId__c,
            dmpl__ServiceRequestId__r.dmpl__DocumentDate__c,
            dmpl__ServiceRequestId__r.dmpl__PriceListId__c
        FROM dmpl__ServiceRequestLine__c
        WHERE ID =: serviceRequestLineId
        OR dmpl__PackageServiceRequestLineId__c = :serviceRequestLineId];
    }  

    private static List<dmpl__PurchaseOrderLine__c> queryPurchaseOrderLines(
        ID purchaseOrderLineId){
            SecurityHelper.ensureCanReadFields(new List<String>{
                'dmpl__PartnerAccountId__c', 
                'dmpl__BranchId__c',
                'dmpl__DocumentDate__c',
                'dmpl__PriceListId__c'
            },'dmpl__PurchaseOrder__c');
        SecurityHelper.ensureCanReadFields(new List<String>{
            'dmpl__PackagePurchaseOrderLineId__c', 
            'dmpl__ItemComponentId__c',
            'dmpl__ItemId__c',
            'dmpl__SKUId__c',
            'dmpl__Quantity__c'
        },'dmpl__PurchaseOrderLine__c');
        return [ SELECT ID, 
            dmpl__PackagePurchaseOrderLineId__c,
            dmpl__ItemComponentId__c,
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__Quantity__c,
            dmpl__PurchaseOrderId__r.dmpl__PartnerAccountId__c,
            dmpl__PurchaseOrderId__r.dmpl__BranchId__c,
            dmpl__PurchaseOrderId__r.dmpl__DocumentDate__c,
            dmpl__PurchaseOrderId__r.dmpl__PriceListId__c
        FROM dmpl__PurchaseOrderLine__c
        WHERE ID =: purchaseOrderLineId
        OR dmpl__PackagePurchaseOrderLineId__c = :purchaseOrderLineId];
    }  

    private static List<dmpl__SaleInvoiceLine__c> querySaleInvoiceLines(
        ID saleInvoiceLineId){
            SecurityHelper.ensureCanReadFields(new List<String>{
                'dmpl__PartnerAccountId__c', 
                'dmpl__BranchId__c',
                'dmpl__DocumentDate__c',
                'dmpl__PriceListId__c'
            },'dmpl__SaleInvoice__c');
        SecurityHelper.ensureCanReadFields(new List<String>{
            'dmpl__PackageSaleInvoiceLineId__c', 
            'dmpl__ItemComponentId__c',
            'dmpl__ItemId__c',
            'dmpl__SKUId__c',
            'dmpl__Quantity__c'
        },'dmpl__SaleInvoiceLine__c');
        return [ SELECT ID, 
            dmpl__PackageSaleInvoiceLineId__c,
            dmpl__ItemComponentId__c,
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__Quantity__c,
            dmpl__SaleInvoiceId__r.dmpl__PartnerAccountId__c,
            dmpl__SaleInvoiceId__r.dmpl__BranchId__c,
            dmpl__SaleInvoiceId__r.dmpl__DocumentDate__c,
            dmpl__SaleInvoiceId__r.dmpl__PriceListId__c
        FROM dmpl__SaleInvoiceLine__c
        WHERE ID =: saleInvoiceLineId
        OR dmpl__PackageSaleInvoiceLineId__c = :saleInvoiceLineId];
    }  

    private static List<dmpl__QuoteLine__c> queryQuoteLines(ID quoteLineId)
    {
        SecurityHelper.ensureCanReadFields(new List<String>{
            'dmpl__PartnerAccountId__c',
            'dmpl__BranchId__c',
            'dmpl__DocumentDate__c',
            'dmpl__PriceListId__c'
        },'dmpl__Quote__c');
        SecurityHelper.ensureCanReadFields(new List<String>{
            'dmpl__ItemId__c',
            'dmpl__ItemComponentId__c',
            'dmpl__SKUId__c',
            'dmpl__Quantity__c'
        },'dmpl__QuoteLine__c');
        return [
            SELECT Id,
            Name,
            dmpl__ItemId__c,
            dmpl__ItemComponentId__c,
            dmpl__SKUId__c,
            dmpl__Quantity__c,
            dmpl__PackageQuoteLineId__c,
            dmpl__QuoteId__r.dmpl__PartnerAccountId__c,
            dmpl__QuoteId__r.dmpl__BranchId__c,
            dmpl__QuoteId__r.dmpl__DocumentDate__c,
            dmpl__QuoteId__r.dmpl__PriceListId__c
        FROM
            dmpl__QuoteLine__c
        WHERE ID = : quoteLineId
        OR dmpl__PackageQuoteLineId__c = : quoteLineId];
    }

    private static List<dmpl__Quote__c> queryQuote(ID quoteId)
    {
        SecurityHelper.ensureCanReadFields(new List<String>{
            'dmpl__PartnerAccountId__c',
            'dmpl__BranchId__c',
            'dmpl__AssetId__c',
            'dmpl__PriceListId__c',
            'dmpl__DocumentDate__c'
        },'dmpl__Quote__c');
        SecurityHelper.ensureCanReadFields(new List<String>{
            'dmpl__ItemId__c',
            'dmpl__SKUId__c'
        },'Asset');
        return [
            SELECT
            Id,
            Name,
            dmpl__PartnerAccountId__c,
            dmpl__BranchId__c,
            dmpl__AssetId__c,
            dmpl__AssetId__r.dmpl__ItemId__c,
            dmpl__AssetId__r.dmpl__SKUId__c,
            dmpl__PriceListId__c,
            dmpl__DocumentDate__c
            FROM
            dmpl__Quote__c
            WHERE ID = : quoteId
        ];
    }

    private static List<Asset> queryAssets(List<Id> assetIds)
    {
        SecurityHelper.ensureCanReadFields(new List<String>{
            'dmpl__ItemId__c',
            'dmpl__SKUId__c'
        },'Asset');
        return [SELECT Id, Name, dmpl__ItemId__c, dmpl__SKUId__c FROM Asset WHERE Id IN : assetIds];
    }
    
    private static List<PackageComponentLine> generatePackageCoponentsLines(
        List<dmpl__ItemComponent__c> components, 
        List<dmpl__PriceListRules__c> prices, 
        List<AggregateResult> itemStocks){
        List<PackageComponentLine> componentLines = new List<PackageComponentLine>();
    
        for(dmpl__ItemComponent__c component : components){
            PackageComponentLine pcLine = new PackageComponentLine(component);
            componentLines.add(pcLine);
            if(component.dmpl__ComponentSKUId__c!=null){
                pcLine.UnitPrice = ((dmpl__PriceListRules__c)CollectionHelper.getObject(
                    prices, 
                    'dmpl__SKUId__c', 
                    component.dmpl__ComponentSKUId__c))?.dmpl__Price__c;
            }else {
                pcLine.UnitPrice = ((dmpl__PriceListRules__c)CollectionHelper.getObject(
                    prices, 
                    'dmpl__ItemId__c', 
                    component.dmpl__ComponentItemId__c))?.dmpl__Price__c;
            }

            for(AggregateResult itemStock : itemStocks){
                if(itemStock.get('dmpl__ItemId__c') != component.dmpl__ComponentItemId__c
                    || (component.dmpl__ComponentSKUId__c != null && component.dmpl__ComponentSKUId__c != itemStock.get('dmpl__SKUId__c'))){
                    continue;
                }

                pcLine.StockInHand = (Decimal)itemStock.get('QuantityInHand');
                pcLine.StockAvailable = (Decimal)itemStock.get('QuantityAvailable');
                break;
            }
        }
        return componentLines;
    }

    private static List<AggregateResult> queryItemStock(List<Id> itemIds, List<Id> SKUIds, Id partnerId, Id branchId)
    {
        SecurityHelper.ensureCanReadFields(new String[]{'dmpl__QuantityAvailable__c','dmpl__QuantityInHand__c'},'dmpl__InventoryStock__c');   
        return 
        [SELECT
            SUM(dmpl__QuantityAvailable__c) QuantityAvailable,
            SUM(dmpl__QuantityInHand__c) QuantityInHand,
            dmpl__ItemId__c,
            dmpl__SKUID__c
        FROM
            dmpl__InventoryStock__c
        WHERE
            dmpl__ItemId__c IN :itemIds
            AND (dmpl__SKUID__c IN :SKUIds OR dmpl__SKUID__c = null)
            AND dmpl__PartnerAccountId__c =:partnerId
            AND dmpl__BranchId__c =:branchId
        GROUP BY 
            dmpl__ItemId__c,
            dmpl__SKUID__c];
    }
}