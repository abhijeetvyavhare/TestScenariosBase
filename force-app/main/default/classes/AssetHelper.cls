@namespaceAccessible
public with sharing class AssetHelper {

    private static Boolean skipValidations = false; 
    private static final string OBJECT_ASSET = 'Asset';
    private static final string FIELD_ASSET_ISPDIDONE = 'dmpl__IsPDIDone__c';
    private static final string FIELD_REPAIRORDER_ASSETID = 'dmpl__AssetId__c';
    private static final string FIELD_SALEINVOICELINELINE_SALEINVOICEID = 'dmpl__SaleInvoiceId__c';
    
    private static final List<String> LIST_NON_EDITABLE_FIELDS = new List<String>{};
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{};
    private static final List<String> LIST_FIELDS_LOCKEDIFTRANSACTED = new List<String>{};

    public static void validateData(
        Boolean isInsert, 
        Boolean isDelete,
        Boolean isUpdate, 
        List<Asset> oldEntries, 
        List<Asset> newEntries){ 
        try{     
            if(isInsert){
                FieldMappingHelper.copyFieldMappingData(
                    newEntries);
            }
            if(skipValidations){
                return;
            }
            if(isUpdate){
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, oldEntries, newEntries);
                DocumentHelper.validateChangeInKeyFields(LIST_NON_EDITABLE_FIELDS, oldEntries, newEntries);
            }else if(isDelete){
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void validateUsageReadings(List<SObject> documents){
        if(orgSettingHelper.IsServiceContractValidationsDisabled()){
            return;
        }
        Map<Id, Asset> assets = queryAssets(DocumentHelper.extractIds(documents, FIELD_REPAIRORDER_ASSETID));
        for(SObject document : documents){
            Asset asset = assets.get((Id)document.get('dmpl__AssetId__c'));
            if(asset == null){
                continue;}
            if(document.get('dmpl__UsageReading__c') !=null 
                && (Decimal)document.get('dmpl__UsageReading__c') < asset.dmpl__LastUsageReading__c){
                document.addError('Usage Reading for the Asset seems Incorrect! Please check and try again.');
            }
            if(document.get('dmpl__UsageReadingHours__c') !=null 
                && (Decimal)document.get('dmpl__UsageReadingHours__c') < asset.dmpl__LastUsageReadingHours__c){
                document.addError('Usage Reading for the Asset seems Incorrect! Please check and try again.');
            }
        }
    }

    public static void markPDIDone(List<Id> assetIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{FIELD_ASSET_ISPDIDONE}, OBJECT_ASSET);
        List<Asset> assets = [Select Id,dmpl__IsPDIDone__c from Asset Where Id IN: assetIds];

        for(Asset asset : assets)
            asset.dmpl__IsPDIDone__c = true;
        
        SecurityHelper.ensureCanWriteFields(new string[]{FIELD_ASSET_ISPDIDONE}, OBJECT_ASSET);
        if(assets.Size() > 0)
            update assets;
    }

    public static void createAssets(List<dmpl__SaleInvoice__c> invoices, List<dmpl__SaleInvoiceLine__c> invoiceLines){
        Map<Id, dmpl__Item__c> items = new Map<Id, dmpl__Item__c>(
            ItemHelper.getCachedItems(
                DocumentHelper.extractIds(invoiceLines, 'dmpl__ItemId__c')));
        Map<Id, dmpl__ItemLot__c> itemLots = new Map<Id, dmpl__ItemLot__c>(queryItemLots(
                DocumentHelper.extractIds(invoiceLines, 'dmpl__ItemLotId__c')));

        List<Asset> assetsToCreate = new List<Asset>();
        Map<Id,Asset> parentAssets = new Map<Id,Asset>();
        List<Asset> childAssetsToCreate = new List<Asset>();
        List<dmpl__AssetServiceContract__c> serviceContractsToCreate = new List<dmpl__AssetServiceContract__c>();
        for(dmpl__SaleInvoice__c invoice : invoices){
            for(dmpl__SaleInvoiceLine__c invoiceLine : (List<dmpl__SaleInvoiceLine__c>)DocumentHelper.getObjects(
                    invoiceLines, 
                    FIELD_SALEINVOICELINELINE_SALEINVOICEID, 
                    invoice.Id)){
                dmpl__Item__c item = items.get(invoiceLine.dmpl__ItemId__c);
                if(item == null){
                    throw new DMPLException(
                        String.format(
                            String.valueOf(System.Label.Generic_MissingObject), 
                            new String[]{dmpl__Item__c.class.getName()}));
                }
                if(item.dmpl__TrackAsset__c){
                    dmpl__ItemLot__c itemLot = itemLots.get(invoiceLine.dmpl__ItemLotId__c);
                    if(itemLot == null){
                        throw new DMPLException(
                            String.format(
                                String.valueOf(System.Label.Generic_MissingObject), 
                                new String[]{dmpl__ItemLot__c.class.getName()}));
                    }
    
                    Asset asset = AssetHelper.newAsset(invoice, invoiceLine, item, itemLot);
                    parentAssets.put(invoiceLine.Id, asset);
                    if(invoiceLine.dmpl__PackageSaleInvoiceLineId__c == null){
                        assetsToCreate.add(asset);
                    }else {
                        Asset parentAsset = parentAssets.get(invoiceLine.dmpl__PackageSaleInvoiceLineId__c);
                        asset.Parent = parentAsset;
                        childAssetsToCreate.add(asset);
                    }
                }
            }
        }

        createAssets(assetsToCreate);

        for(Asset asset : assetsToCreate){
            for(Asset childAsset : childAssetsToCreate){
                if(childAsset.Parent == asset){
                    childAsset.ParentId = asset.Id;
                }
            }
        }
        //
        createAssets(childAssetsToCreate);
        //
        for(dmpl__SaleInvoiceLine__c line : invoiceLines){
            Asset asset = parentAssets.get(line.Id);
            if(asset!=null){
                line.dmpl__AssetId__c = asset.Id;
            }
        }
        update invoiceLines;
        // system.debug(invoices);
        // system.debug(invoiceLines);
    }

    public static void updateAssetFromRepairOrder(List<dmpl__RepairOrder__c> repairOrders)
    {
        Map<Id, Asset> assets = queryAssets(DocumentHelper.extractIds(repairOrders, FIELD_REPAIRORDER_ASSETID));
        List<Asset> assetsToUpdate = new List<Asset>();
        for(dmpl__RepairOrder__c repairOrder : repairOrders)
        {
            Asset asset = assets.get(repairOrder.dmpl__AssetId__c);
            if(asset == null)
                continue;
            asset.dmpl__LastServiceBranchId__c = repairOrder.dmpl__BranchId__c;
            asset.dmpl__LastServiceDate__c = repairOrder.dmpl__DocumentDate__c;
            asset.dmpl__LastServicePartnerId__c = repairOrder.dmpl__PartnerAccountId__c;
            if(repairOrder.dmpl__ResetUsageHours__c){
                asset.dmpl__LastUsageReadingHours__c = 0;
                asset.dmpl__UsageHoursResetAt__c = repairOrder.dmpl__UsageReadingHours__c;
            } else {
                asset.dmpl__LastUsageReadingHours__c = repairOrder.dmpl__UsageReadingHours__c;
            }
            if(repairOrder.dmpl__ResetUsageReading__c){
                asset.dmpl__LastUsageReading__c = 0;
                asset.dmpl__UsageReadingResetAt__c = repairOrder.dmpl__UsageReading__c;
            } else {
                asset.dmpl__LastUsageReading__c = repairOrder.dmpl__UsageReading__c;
            }
            assetsToUpdate.add(asset);
        }

        if(assetsToUpdate.Size() > 0){
            SecurityHelper.ensureCanWriteFields(new List<String>{
                'dmpl__LastServiceBranchId__c',
                'dmpl__LastServiceDate__c',
                'dmpl__LastServicePartnerId__c',
                'dmpl__LastUsageReading__c',
                'dmpl__LastUsageReadingHours__c'
            },OBJECT_ASSET);            
            update assetsToUpdate;
        }
    }

    public static void updateAssetMaintenanceFromRepairOrder(
        List<dmpl__RepairOrder__c> repairOrders){
        List<dmpl__AssetMaintenance__c> assetMnts = queryAssetMaintenance(
            DocumentHelper.extractIds(
                repairOrders));
        for(dmpl__AssetMaintenance__c assetMnt : assetMnts){
            assetMnt.dmpl__IsExecuted__c = true;
        }

        if(assetMnts.Size() > 0){
            SecurityHelper.ensureCanWriteFields(new List<String>{
                'dmpl__IsExecuted__c'
            },'dmpl__AssetMaintenance__c');            
            update assetMnts;
        }
    }
    
    private static Asset newAsset(dmpl__SaleInvoice__c invoice, dmpl__SaleInvoiceLine__c invoiceLine, dmpl__Item__c item, dmpl__ItemLot__c itemLot){
        return new Asset(
            Name = itemLot.dmpl__SerialNumber__c,
            AccountId = invoice.dmpl__AccountId__c,
            AssetProvidedById = invoice.dmpl__PartnerAccountId__c,
            AssetServicedById = invoice.dmpl__PartnerAccountId__c,
            dmpl__BatchNo__c = itemLot.dmpl__BatchNo__c,
            dmpl__ComponentNumber__c = itemLot.dmpl__ComponentNumber__c,
            ContactId = invoice.dmpl__ContactId__c,
            InstallDate = invoice.dmpl__DocumentDate__c,
            dmpl__InstallationAddressId__c = invoice.dmpl__ShippingAddressId__c,
            dmpl__IsPDIDone__c = false,
            dmpl__ItemId__c = item.Id,
            dmpl__ItemLotId__c = itemLot.Id,
            dmpl__SKUId__c = invoiceLine.dmpl__SKUId__c,
            dmpl__LastServiceBranchId__c = invoice.dmpl__BranchId__c,
            dmpl__LastServiceDate__c = invoice.dmpl__DocumentDate__c,
            dmpl__LastServicePartnerId__c = invoice.dmpl__PartnerAccountId__c,
            dmpl__LotNumber__c = itemLot.Name,
            ManufactureDate = itemLot.dmpl__DateOfMfg__c,
            Price = invoiceLine.dmpl__Amount__c,
            PurchaseDate = invoice.dmpl__DocumentDate__c,
            dmpl__PutToUseDate__c = invoice.dmpl__DocumentDate__c,
            Quantity = invoiceLine.dmpl__Quantity__c,
            dmpl__RegistrationNumber__c = itemLot.dmpl__RegistrationNumber__c,
            dmpl__RegistrationDate__c = itemLot.dmpl__DateOfRegistration__c,
            dmpl__SaleDate__c = invoice.dmpl__DocumentDate__c,
            dmpl__SaleInvoiceNumber__c = invoice.Name,
            dmpl__SellingBranchId__c = invoice.dmpl__BranchId__c,
            dmpl__SellingPartnerAccountId__c = invoice.dmpl__PartnerAccountId__c,
            SerialNumber = itemLot.dmpl__SerialNumber__c,
            dmpl__SupplierInvoicedate__c = itemLot.dmpl__DateOfSupplierInvoice__c,
            dmpl__SupplierInvoiceNumber__c = itemLot.dmpl__SupplierInvoiceNumber__c,
            ParentId = invoice.dmpl__AssetId__c,
            dmpl__InvoiceId__c = invoice.Id
        );
    }
    
    private static void createAssets(List<Asset> assets){
        SecurityHelper.ensureCanCreateObject(OBJECT_ASSET);
        SecurityHelper.ensureCanCreateFields(new List<String>
        {
            'Name',
            'ContactId',
            'AccountId',
            'dmpl__SaleDate__c',
            'dmpl__BatchNo__c',
            'dmpl__ComponentNumber__c',
            'dmpl__InstallationAddressId__c',
            'dmpl__IsPDIDone__c',
            'dmpl__ItemId__c',
            'dmpl__ItemLotId__c',
            'dmpl__SKUId__c',
            'dmpl__LastServiceBranchId__c',
            'dmpl__LastServiceDate__c',
            'dmpl__LastServicePartnerId__c',
            'dmpl__LotNumber__c',
            'dmpl__PutToUseDate__c',
            'dmpl__RegistrationNumber__c',
            'dmpl__RegistrationDate__c',
            'dmpl__SaleInvoiceNumber__c',
            'dmpl__SellingBranchId__c',
            'dmpl__SellingPartnerAccountId__c',
            'dmpl__SupplierInvoicedate__c',
            'dmpl__SupplierInvoiceNumber__c'
        }, OBJECT_ASSET);
        try {
            skipValidations = true;
            insert assets;
        } finally {
            skipValidations = false;
        }
    }

    private static List<dmpl__ItemLot__c> queryItemLots(List<ID> itemLotIds)
    {
        SecurityHelper.ensureCanReadFields(new List<String>{
            'Name', 
            'dmpl__ReturnedQuantity__c',
            'dmpl__ItemId__c',
            'dmpl__SKUId__c',
            'dmpl__BatchNo__c',
            'dmpl__ComponentNumber__c',
            'dmpl__DateOfMfg__c',
            'dmpl__RegistrationNumber__c',
            'dmpl__DateOfRegistration__c',
            'dmpl__SerialNumber__c',
            'dmpl__DateOfSupplierInvoice__c',
            'dmpl__SupplierInvoiceNumber__c',
            'dmpl__Quantity__c'
        },'dmpl__SaleInvoiceLine__c');
        return [ SELECT ID, 
            Name, 
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__BatchNo__c,
            dmpl__ComponentNumber__c,
            dmpl__DateOfMfg__c,
            dmpl__RegistrationNumber__c,
            dmpl__DateOfRegistration__c,
            dmpl__SerialNumber__c,
            dmpl__DateOfSupplierInvoice__c,
            dmpl__SupplierInvoiceNumber__c
        FROM dmpl__ItemLot__c
        WHERE ID IN : itemLotIds];
    }

    private static Map<Id, Asset> queryAssets(List<Id> assetIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__LastServiceBranchId__c','dmpl__LastServiceDate__c','dmpl__LastServicePartnerId__c','dmpl__LastUsageReading__c','dmpl__LastUsageReadingHours__c'}, OBJECT_ASSET);
        return new Map<Id, Asset>([
        SELECT ID,
            dmpl__LastServiceBranchId__c,
            dmpl__LastServiceDate__c,
            dmpl__LastServicePartnerId__c,
            dmpl__LastUsageReading__c,
            dmpl__LastUsageReadingHours__c,
            dmpl__UsageHoursResetAt__c,
            dmpl__UsageReadingResetAt__c,
            dmpl__CommutativeUsageHours__c,
            dmpl__CommutativeUsageReading__c
        FROM Asset
        WHERE ID IN : assetIds]);
    }

    private static List<dmpl__AssetMaintenance__c> queryAssetMaintenance(
        List<Id> repairOrderIds){
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__IsExecuted__c'
        }, 'dmpl__AssetMaintenance__c');
        return [SELECT 
            Id,
            dmpl__IsExecuted__c
        FROM dmpl__AssetMaintenance__c
        WHERE Id IN (SELECT 
            dmpl__AssetMaintenanceId__c
            FROM dmpl__RepairOrderLine__c
            WHERE dmpl__RepairOrderId__c IN:repairOrderIds)];
    }
}