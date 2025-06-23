public without sharing class InventoryStockService extends MetadataService{
    public static final String OBJECT_INVENTORY_STOCK = 'dmpl__InventoryStock__c';

    public static final string FIELD_INVENTORYSTOCK_BRANCHID = 'dmpl__BranchId__c';
    public static final string FIELD_INVENTORYSTOCK_EXTERNALID = 'dmpl__ExternalId__c';
    public static final string FIELD_INVENTORYSTOCK_FINANCIALYEAR = 'dmpl__FinancialYear__c';
    public static final string FIELD_INVENTORYSTOCK_HASHCODE = 'dmpl__HashCode__c';
    public static final string FIELD_INVENTORYSTOCK_ISTRANSACTIONLOCKED  = 'dmpl__IsTransactionLocked__c';
    public static final string FIELD_INVENTORYSTOCK_ITEMID = 'dmpl__ItemId__c';
    public static final string FIELD_INVENTORYSTOCK_ITEMLOTYPEID = 'dmpl__ItemLotTypeId__c';
    public static final string FIELD_INVENTORYSTOCK_PARTNERACCOUNTID = 'dmpl__PartnerAccountId__c';
    public static final string FIELD_INVENTORYSTOCK_QTYADJUSTEDIN = 'dmpl__QuantityAdjustedIn__c';
    public static final string FIELD_INVENTORYSTOCK_QTYADJUSTEDOUT = 'dmpl__QuantityAdjustedOut__c';
    public static final string FIELD_INVENTORYSTOCK_QTYASSEMBLEDIN = 'dmpl__QuantityAssembledIn__c';
    public static final string FIELD_INVENTORYSTOCK_QTYASSEMBLEDOUT = 'dmpl__QuantityAssembledOut__c';
    public static final string FIELD_INVENTORYSTOCK_QTYAVAILABLE = 'dmpl__QuantityAvailable__c';
    public static final string FIELD_INVENTORYSTOCK_QTYDAMAGED = 'dmpl__QuantityDamaged__c';
    public static final string FIELD_INVENTORYSTOCK_QTYEXPIRED = 'dmpl__QuantityExpired__c';
    public static final string FIELD_INVENTORYSTOCK_QTYEXTERNAL = 'dmpl__QuantityExternal__c';
    public static final string FIELD_INVENTORYSTOCK_QTYINHAND = 'dmpl__QuantityInHand__c';
    public static final string FIELD_INVENTORYSTOCK_QTYINPENDINGDELIVERIES = 'dmpl__QuantityInPendingDeliveries__c';
    public static final string FIELD_INVENTORYSTOCK_QTYINPIPELINE = 'dmpl__QuantityInPipeline__c';
    public static final string FIELD_INVENTORYSTOCK_QTYINTRANSIT = 'dmpl__QuantityInTransit__c';
    public static final string FIELD_INVENTORYSTOCK_QTYONALLOCATION  = 'dmpl__QuantityOnAllocation__c';
    public static final string FIELD_INVENTORYSTOCK_QTYONFULFILMENT = 'dmpl__QuantityOnFulfillment__c';
    public static final string FIELD_INVENTORYSTOCK_QTYONHOLD = 'dmpl__QuantityOnHold__c';
    public static final string FIELD_INVENTORYSTOCK_QTYONINSPECTION = 'dmpl__QuantityOnInspection__c';
    public static final string FIELD_INVENTORYSTOCK_QTYONINWARD = 'dmpl__QuantityOnInward__c';
    public static final string FIELD_INVENTORYSTOCK_QTYONLOAN = 'dmpl__QuantityOnLoan__c';
    public static final string FIELD_INVENTORYSTOCK_QTYONOUTWARD = 'dmpl__QuantityOnOutward__c';
    public static final string FIELD_INVENTORYSTOCK_QTYPICKED = 'dmpl__QuantityPicked__c';
    public static final string FIELD_INVENTORYSTOCK_QTYPROJECTED = 'dmpl__QuantityProjected__c';
    public static final string FIELD_INVENTORYSTOCK_QTYPURCHASED = 'dmpl__QuantityPurchased__c';
    public static final string FIELD_INVENTORYSTOCK_QTYPURCHASEDRETURN = 'dmpl__QuantityPurchaseReturned__c';
    public static final string FIELD_INVENTORYSTOCK_QTYSALERETURNED = 'dmpl__QuantitySaleReturned__c';
    public static final string FIELD_INVENTORYSTOCK_QTYSHORTAGE = 'dmpl__QuantityShortage__c';
    public static final string FIELD_INVENTORYSTOCK_QTYSOLD = 'dmpl__QuantitySold__c';
    public static final string FIELD_INVENTORYSTOCK_QTYTRANSFEREDIN =  'dmpl__QuantityTransferIn__c';
    public static final string FIELD_INVENTORYSTOCK_QTYTRANSFEREDOUT = 'dmpl__QuantityTransferOut__c';
    public static final string FIELD_INVENTORYSTOCK_SKUID = 'dmpl__SKUId__c';
    public static final string FIELD_INVENTORYSTOCK_STORAGELOCATION = 'dmpl__StorageLocationId__c';

    public InventoryStockService() {
        super(OBJECT_INVENTORY_STOCK);
    }
}