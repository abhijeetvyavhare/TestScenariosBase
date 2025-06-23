public with sharing class FieldSalesLineHelper {
    private static Boolean skipValidations = false;

    public static void postData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__FieldSalesLine__c> oldEntries, 
        List<dmpl__FieldSalesLine__c> newEntries){
        try{
            tagRelatedLot(isInsert, isDelete, isUpdate, oldEntries, newEntries);
            if(isInsert){
                setItemData(
                    newEntries);
            }
            if(isUpdate){
                Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
                    ItemHelper.getCachedItems(
                    DocumentHelper.extractIds(
                        newEntries, 
                        'dmpl__ItemId__c')));
                           List<dmpl__FieldSalesLine__c> modifiedObjects = DocumentHelper.getModifiedNewObjects(
                                new string[]{
                                    'dmpl__Quantity__c',
                                    'dmpl__UOM__c',
                                    'dmpl__UOM1__c', 
                                    'dmpl__UOMQuantity__c',
                                    'dmpl__UOMQuantity1__c'
                                }, 
                                oldEntries, 
                                newEntries); 
                        if(modifiedObjects.size()>0){
                            ItemHelper.setQuantityFromUOM(newEntries, oldEntries, items);
                        }
                    }
                } catch (Exception error) {
                    ExceptionLogHelper.logException(error);
                    throw error;
                }
        }

        private static void setItemData(
            List<dmpl__FieldSalesLine__c> newEntries)
        {
            Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
                ItemHelper.getCachedItems(
                    DocumentHelper.extractIds(
                        newEntries, 
                        'dmpl__ItemId__c')));
            ItemHelper.setQuantityFromUOM(
                newEntries, 
                null,
                items);
        }

        private static void tagRelatedLot(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__FieldSalesLine__c> oldEntries, 
        List<dmpl__FieldSalesLine__c> newEntries)
    {
        Map<Id, dmpl__ItemLot__c> itemLots = getRelatedLots(
            newEntries, 
            oldEntries);
        List<dmpl__ItemLot__c> insertedItemLots = new List<dmpl__ItemLot__c>();
        List<dmpl__ItemLot__c> updatedItemLots = new List<dmpl__ItemLot__c>();
        Map<ID, dmpl__FieldSales__c> fieldSaleDocuments = queryFieldSalesDocuments(
            DocumentHelper.extractIds(
                newEntries, 
                'dmpl__FieldSalesId__c'));
        if(isInsert || isUpdate){
            for(dmpl__FieldSalesLine__c lineEntry : newEntries){
                dmpl__FieldSales__c fieldSaleDocument = fieldSaleDocuments.get(lineEntry.dmpl__FieldSalesId__c);
                if(fieldSaleDocument == null)
                    lineEntry.addError(String.format(String.valueOf(System.Label.Generic_MissingObject), new string[]{dmpl__ItemLot__c.class.getName()}));
                if(lineEntry.dmpl__ItemLotId__c == null)
                    continue;
                dmpl__ItemLot__c sourceItemLot = itemLots.get(lineEntry.dmpl__ItemLotId__c);
                if(sourceItemLot==null)
                    lineEntry.addError(String.format(String.valueOf(System.Label.Generic_MissingObject), new string[]{dmpl__ItemLot__c.class.getName()}));
                dmpl__ItemLot__c oldItemLot = null;
                if(isUpdate){
                    dmpl__FieldSalesLine__c oldEntry = getOldTransferLine(oldEntries, lineEntry);
                    oldItemLot = itemLots.get(oldEntry.dmpl__RelatedItemLotId__c);
                }
                dmpl__ItemLot__c itemLot = createItemLot(
                    lineEntry, 
                    sourceItemLot, 
                    oldItemLot, 
                    fieldSaleDocument);
                if(itemLot!=null){
                    lineEntry.dmpl__RelatedItemLotId__r = itemLot;
                    if(itemLot.Id !=null)
                        updatedItemLots.Add(itemLot);
                    else
                        insertedItemLots.Add(itemLot);
                }
            }
            try {
                ItemLotHelper.skipValidations = true;
                FieldSalesLineHelper.skipValidations = true;
                if (insertedItemLots.size()>0) {
                    SecurityHelper.ensureCanCreateObject('dmpl__ItemLot__c');
                    SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__ItemId__c','dmpl__SKUId__c','dmpl__MRP__c','dmpl__DateOfSupplierInvoice__c','dmpl__DateOfReceipt__c','dmpl__SupplierInvoiceNumber__c','dmpl__BatchNo__c','dmpl__ComponentNumber__c','dmpl__DateOfExpiry__c','dmpl__Cost__c','dmpl__DateOfMfg__c','dmpl__DateOfSupplierDispatch__c'}, 'dmpl__ItemLot__c');
                    insert insertedItemLots;                
                }
                if(updatedItemLots.size()>0){
                    SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__ItemId__c','dmpl__SKUId__c','dmpl__MRP__c','dmpl__DateOfSupplierInvoice__c','dmpl__DateOfReceipt__c','dmpl__SupplierInvoiceNumber__c','dmpl__BatchNo__c','dmpl__ComponentNumber__c','dmpl__DateOfExpiry__c','dmpl__Cost__c','dmpl__DateOfMfg__c','dmpl__DateOfSupplierDispatch__c'}, 'dmpl__ItemLot__c');
                    update updatedItemLots;
                }                    
            } finally {
                ItemLotHelper.skipValidations = false;
                FieldSalesLineHelper.skipValidations = false;
            }
            for(dmpl__FieldSalesLine__c lineEntry : newEntries){
                if(lineEntry.dmpl__RelatedItemLotId__r!=null){
                    SecurityHelper.ensureCanWriteField('dmpl__RelatedItemLotId__c','dmpl__TransferOutwardLine__c');
                    lineEntry.dmpl__RelatedItemLotId__c = lineEntry.dmpl__RelatedItemLotId__r.Id;
                }
            }
        }
    }

    private static Map<Id, dmpl__ItemLot__c> getRelatedLots(
        List<dmpl__FieldSalesLine__c> newLineEntries, 
        List<dmpl__FieldSalesLine__c> oldLineEntries)
    {
        List<ID> itemLotIds = new List<ID>();
        if(newLineEntries!=null)
        {
            for(dmpl__FieldSalesLine__c lineEntry : newLineEntries)
            {
                if(lineEntry.dmpl__ItemLotId__c!=null && !itemLotIds.Contains(lineEntry.dmpl__ItemLotId__c))
                    itemLotIds.Add(lineEntry.dmpl__ItemLotId__c);
                if(lineEntry.dmpl__RelatedItemLotId__c!=null && !itemLotIds.Contains(lineEntry.dmpl__RelatedItemLotId__c))
                    itemLotIds.Add(lineEntry.dmpl__RelatedItemLotId__c);
            }
        }
        if(oldLineEntries!=null)
        {
            for(dmpl__FieldSalesLine__c lineEntry : oldLineEntries)
            {
                if(!itemLotIds.Contains(lineEntry.dmpl__ItemLotId__c))
                    itemLotIds.Add(lineEntry.dmpl__ItemLotId__c);
                if(lineEntry.dmpl__RelatedItemLotId__c!=null && !itemLotIds.Contains(lineEntry.dmpl__RelatedItemLotId__c))
                    itemLotIds.Add(lineEntry.dmpl__RelatedItemLotId__c);
            }
        }
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__ItemId__c','dmpl__PurchaseDate__c','dmpl__RegistrationNumber__c','dmpl__SerialNumber__c','dmpl__SKUId__c','dmpl__ItemLotTypeId__c','dmpl__MRP__c','dmpl__DateOfSupplierInvoice__c','dmpl__DateOfReceipt__c','dmpl__SupplierInvoiceNumber__c','dmpl__BatchNo__c','dmpl__ComponentNumber__c','dmpl__DateOfExpiry__c','dmpl__Cost__c','dmpl__DateOfMfg__c','dmpl__DateOfSupplierDispatch__c'}, 'dmpl__ItemLot__c');
        return new Map<Id,dmpl__ItemLot__c>([SELECT id,
            dmpl__BatchNo__c,
            dmpl__ComponentNumber__c,
            dmpl__Cost__c,
            dmpl__SerialNumber__c,
            dmpl__PurchaseDate__c,
            dmpl__RegistrationNumber__c,
            dmpl__DateOfExpiry__c,
            dmpl__DateOfMfg__c,
            dmpl__DateOfSupplierDispatch__c,
            dmpl__DateOfSupplierInvoice__c,
            dmpl__SupplierInvoiceNumber__c,
            dmpl__DateOfReceipt__c,
            dmpl__ItemId__c,
            dmpl__MRP__c,
            Name,
            dmpl__SKUId__c,
            dmpl__ItemLotTypeId__c
            FROM dmpl__ItemLot__c WHERE id IN : itemLotIds]);
    }

    @testVisible
    private static dmpl__FieldSalesLine__c getOldTransferLine(
        List<dmpl__FieldSalesLine__c> oldEntries,
        dmpl__FieldSalesLine__c lineEntry)
    {
        for(dmpl__FieldSalesLine__c oldEntry : oldEntries)
            if(oldEntry.Id == lineEntry.Id )            
                return oldEntry;
        return null;
    }

    @testVisible
    private static dmpl__ItemLot__c createItemLot(
        dmpl__FieldSalesLine__c sourceEntry, 
        dmpl__ItemLot__c sourceItemLot, 
        dmpl__ItemLot__c oldItemLot, 
        dmpl__FieldSales__c fieldSaleDocument) 
    {
        dmpl__ItemLot__c itemLot = oldItemLot;
        if(itemLot == null)
            itemLot = new dmpl__ItemLot__c();
        itemLot.dmpl__PartnerAccountId__c = fieldSaleDocument.dmpl__PartnerAccountId__c;
        itemLot.dmpl__BranchId__c = fieldSaleDocument.dmpl__BranchId__c;
        itemLot.dmpl__RelatedItemLotId__c = sourceItemLot.Id;
        itemLot.dmpl__RelatedItemLotId__r = sourceItemLot;
        itemLot.dmpl__BatchNo__c = sourceItemLot.dmpl__BatchNo__c;
        itemLot.dmpl__SerialNumber__c = sourceItemLot.dmpl__SerialNumber__c;
        itemLot.dmpl__ComponentNumber__c = sourceItemLot.dmpl__ComponentNumber__c;
        itemLot.dmpl__RegistrationNumber__c = sourceItemLot.dmpl__RegistrationNumber__c;
        itemLot.dmpl__SupplierInvoiceNumber__c = sourceItemLot.dmpl__SupplierInvoiceNumber__c;
        itemLot.dmpl__DateOfSupplierInvoice__c = sourceItemLot.dmpl__DateOfSupplierInvoice__c;
        itemLot.dmpl__DateOfSupplierDispatch__c = sourceItemLot.dmpl__DateOfSupplierDispatch__c;
        itemLot.dmpl__PurchaseDate__c = sourceItemLot.dmpl__PurchaseDate__c;
        itemLot.dmpl__Cost__c = sourceItemLot.dmpl__Cost__c;
        itemLot.dmpl__DateOfExpiry__c = sourceItemLot.dmpl__DateOfExpiry__c;
        itemLot.dmpl__DateOfMfg__c = sourceItemLot.dmpl__DateOfMfg__c;
        itemLot.dmpl__DateOfSupplierDispatch__c = sourceItemLot.dmpl__DateOfSupplierDispatch__c;
        itemLot.dmpl__DateOfSupplierInvoice__c = sourceItemLot.dmpl__DateOfSupplierInvoice__c;
        itemLot.dmpl__SupplierInvoiceNumber__c = sourceItemLot.dmpl__SupplierInvoiceNumber__c;
        itemLot.dmpl__DateOfReceipt__c = sourceItemLot.dmpl__DateOfReceipt__c;
        itemLot.dmpl__ItemId__c = sourceItemLot.dmpl__ItemId__c;
        itemLot.dmpl__MRP__c = sourceItemLot.dmpl__MRP__c;
        itemLot.dmpl__SKUId__c = sourceItemLot.dmpl__SKUId__c;
        itemLot.dmpl__ItemLotTypeId__c = sourceItemLot.dmpl__ItemLotTypeId__c;
        itemLot.dmpl__StorageLocationId__c = fieldSaleDocument.dmpl__StorageLocationId__c;
        return itemLot;
    }

    private static Map<ID, dmpl__FieldSales__c> queryFieldSalesDocuments(List<ID> documentIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__PartnerAccountId__c',
            'dmpl__BranchId__c',
            'dmpl__DocumentDate__c',
            'dmpl__Status__c'
        }, 'dmpl__FieldSales__c');
        return new Map<ID, dmpl__FieldSales__c>([SELECT id,
        dmpl__PartnerAccountId__c,
        dmpl__BranchId__c,
        dmpl__DocumentDate__c,
        dmpl__Status__c,
        dmpl__StorageLocationId__c
        FROM dmpl__FieldSales__c
        WHERE Id IN : documentIds]);
    }
   
}