public with sharing class ItemLotService extends MetadataService{
    public static final String OBJECT_ITEMLOT = 'dmpl__ItemLot__c';

    public static final string FIELD_ITEMLOT_BRANCHID = 'BranchId__c'; 
    public static final string FIELD_ITEMLOT_ISTRANSACTIONLOCKED = 'IsTransactionLocked__c'; 
    public static final string FIELD_ITEMLOT_ITEMID = 'ItemId__c'; 
    public static final string FIELD_ITEMLOT_ITEMLOTTYPEID = 'ItemLotTypeId__c'; 
    public static final string FIELD_ITEMLOT_PARTNERACCOUNTID = 'PartnerAccountId__c'; 
    public static final string FIELD_ITEMLOT_QTYADJUSTEDIN = 'QuantityAdjustedIn__c'; 
    public static final string FIELD_ITEMLOT_QTYADJUSTEDOUT = 'QuantityAdjustedOut__c'; 
    public static final string FIELD_ITEMLOT_QTYASSEMBLEDIN = 'QuantityAssembledIn__c'; 
    public static final string FIELD_ITEMLOT_QTYASSEMBLEDOUT = 'QuantityAssembledOut__c'; 
    public static final string FIELD_ITEMLOT_QTYAVAILABLE = 'QuantityAvailable__c'; 
    public static final string FIELD_ITEMLOT_QTYDAMAGED = 'QuantityDamaged__c'; 
    public static final string FIELD_ITEMLOT_QTYEXPIRED = 'QuantityExpired__c'; 
    public static final string FIELD_ITEMLOT_QTYINHAND = 'QuantityInHand__c'; 
    public static final string FIELD_ITEMLOT_QTYINPENDINGDELIVERIES = 'QuantityInPendingDeliveries__c'; 
    public static final string FIELD_ITEMLOT_QTYINTRANSIT = 'QuantityInTransit__c'; 
    public static final string FIELD_ITEMLOT_QTYONALLOCATION = 'QuantityOnAllocation__c'; 
    public static final string FIELD_ITEMLOT_QTYONFUILFILMENT = 'QuantityOnFulfillment__c'; 
    public static final string FIELD_ITEMLOT_QTYONHOLD = 'QuantityOnHold__c';
    public static final string FIELD_ITEMLOT_QTYONINSPECTION = 'QuantityOnInspection__c'; 
    public static final string FIELD_ITEMLOT_QTYONINWARD = 'QuantityOnInward__c'; 
    public static final string FIELD_ITEMLOT_QTYONLOAN = 'QuantityOnLoan__c'; 
    public static final string FIELD_ITEMLOT_QTYONOUTWARD = 'QuantityOnOutward__c'; 
    public static final string FIELD_ITEMLOT_QTYPICKED = 'QuantityPicked__c'; 
    public static final string FIELD_ITEMLOT_QTYPURCHASED = 'QuantityPurchased__c'; 
    public static final string FIELD_ITEMLOT_QTYPURCHASERETURNED = 'QuantityPurchaseReturned__c'; 
    public static final string FIELD_ITEMLOT_QTYSALERETURNED = 'QuantitySaleReturned__c'; 
    public static final string FIELD_ITEMLOT_QTYSHORTAGE = 'QuantityShortage__c'; 
    public static final string FIELD_ITEMLOT_QTYSOLD = 'QuantitySold__c'; 
    public static final string FIELD_ITEMLOT_QTYTRANSFERIN = 'QuantityTransferIn__c'; 
    public static final string FIELD_ITEMLOT_QTYTRANSFEROUT = 'QuantityTransferOut__c'; 
    public static final string FIELD_ITEMLOT_SKUID = 'SKUId__c'; 
    public static final string FIELD_ITEMLOT_STORAGELOCATIONID = 'StorageLocationId__c'; 
    
    public ItemLotService() {
        super(OBJECT_ITEMLOT);
    }
}