public with sharing class InventoryCycleCountService extends MetadataService {

    public static final String OBJECT_INVENTORYCYCLECOUNT = 'dmpl__InventoryCycleCount__c';
    public static final string OBJECT_INVENTORYCYCLECOUNTLINE = 'dmpl__InventoryCycleCountLine__c';

    public static final String FIELD_INVENTORYCYCLECOUNT_STATUS = 'dmpl__Status__c';
    public static final string FIELD_INVENTORYCYCLECOUNT_PARTNERACCOUNTID = 'dmpl__PartnerAccountId__c';
    public static final string FIELD_INVENTORYCYCLECOUNT_BRANCHID = 'dmpl__BranchId__c';
    public static final string FIELD_INVENTORYCYCLECOUNT_DOCUMENTDATE ='dmpl__DocumentDate__c';
    public static final String FIELD_INVENTORYCYCLECOUNT_PERFORMSTARTCOUNTING = 'dmpl__PerformStartCounting__c';
    public static final String FIELD_INVENTORYCYCLECOUNT_PERFORMFINISHCOUNTING = 'dmpl__PerformFinishCounting__c';
    public static final String FIELD_INVENTORYCYCLECOUNT_PERFORMRELEASEADJUSTMENT = 'dmpl__PerformReleaseAdjustment__c';
    public static final String FIELD_INVENTORYCYCLECOUNT_ISCOUNTINGSTARTED = 'dmpl__IsCountingStarted__c';
    public static final String FIELD_INVENTORYCYCLECOUNT_ISCOUNTINGFINISHED = 'dmpl__IsCountingFinished__c';
    public static final String FIELD_INVENTORYCYCLECOUNT_ISADJUSTMENTRELEASED = 'dmpl__IsAdjustmentReleased__c';
    public static final String FIELD_INVENTORYCYCLECOUNT_ASSIGNEDTOID = 'dmpl__AssignedToId__c';
    public static final String FIELD_INVENTORYCYCLECOUNT_ITEMID = 'dmpl__ItemId__c';
    public static final String FIELD_INVENTORYCYCLECOUNT_ABCFILTER = 'dmpl__FilterABC__c';
    public static final String FIELD_INVENTORYCYCLECOUNT_FSNFILTER = 'dmpl__FilterFSN__c';
    public static final String FIELD_INVENTORYCYCLECOUNT_LOCKINVETORY = 'dmpl__LockInventory__c';

    public static final string FIELD_INVENTORYCYCLECOUNTLINE_ITEMID = 'dmpl__ItemId__c';
    public static final string FIELD_INVENTORYCYCLECOUNTLINE_ITEMGROUPID = 'dmpl__ItemGroupId__c';        
    public static final string FIELD_INVENTORYCYCLECOUNTLINE_CYCLECOUNTID = 'dmpl__CycleCountId__c';
    public static final string FIELD_INVENTORYCYCLECOUNT_ID = 'ID';
    public static final string FIELD_INVENTORYCYCLECOUNTLINE_SKUID = 'dmpl__SKUId__c';
    public static final string FIELD_INVENTORYCYCLECOUNTLINE_ITEMLOTID = 'dmpl__ItemLotId__c ';
    public static final string FIELD_INVENTORYCYCLECOUNTLINE_DISCREPENCYQUANTITY = 'dmpl__DiscrepencyQuantity__c';
    public static final string FIELD_INVENTORYCYCLECOUNTLINE_EXPECTEDQUANTITY = 'dmpl__ExpectedQuantity__c';
    public static final string FIELD_INVENTORYCYCLECOUNTLINE_ONHANDQUANTITY = 'dmpl__OnHandQuantity__c';
    public static final string FIELD_INVENTORYCYCLECOUNTLINE_PICKEDQUANTITY = 'dmpl__PickedQuantity__c';
    public static final string FIELD_INVENTORYCYCLECOUNTLINE_RECORDEDQUANTITY = 'dmpl__RecordedQuantity__c';
    public static final string FIELD_INVENTORYCYCLECOUNTLINE_ISAPPROVED = 'dmpl__IsApproved__c';

    public static final string RELATION_INVENTORYCYCLECOUNT_STATUS = 'dmpl__CycleCountId__r.dmpl__Status__c';

    public InventoryCycleCountService(){
        super(OBJECT_INVENTORYCYCLECOUNT);
    }
    
}