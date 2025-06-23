public with sharing class InventoryLedgerService extends MetadataService {

    public static final String OBJECT_INVENTORYLEDGER = 'dmpl__InventoryLedger__c';

    public static final string FIELD_INVENTORYLEDGER_UNITCOST = 'dmpl__UnitCost__c'; 
    public static final string FIELD_INVENTORYLEDGER_STORAGELOCATIONID = 'dmpl__StorageLocationId__c'; 
    public static final string FIELD_INVENTORYLEDGER_SOURCEDOCUMENT ='dmpl__SourceDocument__c'; 
    public static final string FIELD_INVENTORYLEDGER_SKUID ='dmpl__SKUId__c'; 
    public static final string FIELD_INVENTORYLEDGER_SHORTAGEQUANTITY ='dmpl__ShortageQuantity__c'; 
    public static final string FIELD_INVENTORYLEDGER_RELATEDPARTNERACCOUNTID ='dmpl__RelatedPartnerAccountId__c'; 
    public static final string FIELD_INVENTORYLEDGER_RELATEDITEMLOTID = 'dmpl__RelatedItemLotId__c'; 
    public static final string FIELD_INVENTORYLEDGER_RELATEDBRANHCID = 'dmpl__RelatedBranchId__c'; 
    public static final string FIELD_INVENTORYLEDGER_QUANTITY ='dmpl__Quantity__c'; 
    public static final string FIELD_INVENTORYLEDGER_PIPELINEQUANTITY = 'dmpl__PipelineQuantity__c'; 
    public static final string FIELD_INVENTORYLEDGER_PICKEDQUANTITY ='dmpl__PickedQuantity__c'; 
    public static final string FIELD_INVENTORYLEDGER_PENDINGDELIVERYQUANTITY ='dmpl__PendingDeliveriesQuantity__c'; 
    public static final string FIELD_INVENTORYLEDGER_PARTNERACCOUNTID = 'dmpl__PartnerAccountId__c'; 
    public static final string FIELD_INVENTORYLEDGER_ITEMLOTTYPEID = 'dmpl__ItemLotTypeId__c'; 
    public static final string FIELD_INVENTORYLEDGER_ITEMLOTID = 'dmpl__ItemLotId__c'; 
    public static final string FIELD_INVENTORYLEDGER_ITEMID = 'dmpl__ItemId__c'; 
    public static final string FIELD_INVENTORYLEDGER_ITEMCODE ='dmpl__ItemCode__c'; 
    public static final string FIELD_INVENTORYLEDGER_ISSTOCKPOSTED = 'dmpl__IsInventoryStockPosted__c'; 
    public static final string FIELD_INVENTORYLEDGER_INWARDQUANTITY = 'dmpl__InwardQuantity__c'; 
    public static final string FIELD_INVENTORYLEDGER_INVENTORYLEDGERTYPE = 'dmpl__InventoryLedgerType__c'; 
    public static final string FIELD_INVENTORYLEDGER_HASHCODE = 'dmpl__HashCode__c'; 
    public static final string FIELD_INVENTORYLEDGER_EXTERNALID = 'dmpl__ExternalId__c'; 
    public static final string FIELD_INVENTORYLEDGER_DOCUMENTDATE = 'dmpl__DocumentDate__c'; 
    public static final string FIELD_INVENTORYLEDGER_DAMAGEDQUANTITY = 'dmpl__DamagedQuantity__c'; 
    public static final string FIELD_INVENTORYLEDGER_BRANCHID = 'dmpl__BranchId__c'; 
    public static final string FIELD_INVENTORYLEDGER_ALLOCATEDQUANTITY = 'dmpl__AllocatedQuantity__c';
    public static final string FIELD_INVENTORYLEDGER_SOFTCOMMITTEDQUANTITY = 'dmpl__SoftCommittedQuantity__c';
    
    public static final String FIELD_OBJECT_INVENTORYLEDGERID =  'dmpl__InventoryLedgerId__c';

    public InventoryLedgerService(){
        super(OBJECT_INVENTORYLEDGER);
    }
    
    public Map<Id, dmpl__InventoryLedger__c> queryLedgerRecords(
        List<sObject> newEntries, 
        List<sObject> oldEntries, 
        InventoryLedgerTypeEnums ledgerType){
        List<string> lineIds = new List<string>();
        //
        if(newEntries!=null){
            for(sObject newLine : newEntries){
                lineIds.Add((ID)newLine.Get(FIELD_OBJECT_INVENTORYLEDGERID));
            }
        }

        if(oldEntries!=null){
            for(sObject oldLine : oldEntries){
                lineIds.Add((ID)oldLine.Get(FIELD_OBJECT_INVENTORYLEDGERID));
            }
        }
        return new Map<Id,dmpl__InventoryLedger__c>([SELECT id,
            dmpl__BranchId__c,
            dmpl__StorageLocationId__c,
            dmpl__InventoryLedgerType__c,
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__ItemLotTypeId__c,
            dmpl__ItemLotId__c,
            dmpl__UnitCost__c,
            dmpl__DocumentDate__c,
            dmpl__Quantity__c,
            dmpl__AllocatedQuantity__c,
            dmpl__DamagedQuantity__c,
            dmpl__InwardQuantity__c,
            dmpl__PendingDeliveriesQuantity__c,
            dmpl__PickedQuantity__c,
            dmpl__PipelineQuantity__c,
            dmpl__SoftCommittedQuantity__c,
            dmpl__ShortageQuantity__c,
            dmpl__SourceDocument__c,
            dmpl__RelatedBranchId__c,
            dmpl__RelatedPartnerAccountId__c,
            dmpl__RelatedItemLotId__c
            FROM dmpl__InventoryLedger__c
            WHERE Id in : lineIds]);
    }

    public Map<Id, dmpl__Item__c> queryItems(
        List<sObject> newEntries, 
        List<sObject> oldEntries){
        List<string> lineIds = new List<string>();
        //
        if(newEntries!=null){
            for(sObject newLine : newEntries){
                if(!lineIds.contains((ID)newLine.Get(FIELD_ITEM_ID))){
                    lineIds.Add((ID)newLine.Get(FIELD_ITEM_ID));
                }
            }
        }
        if(oldEntries!=null){
            for(sObject oldLine : oldEntries){
                if(!lineIds.contains((ID)oldLine.Get(FIELD_ITEM_ID))){
                    lineIds.Add((ID)oldLine.Get(FIELD_ITEM_ID));
                }
            }
        }
        return new Map<Id,dmpl__Item__c>(ItemHelper.getCachedItems(lineIds)); 
    }

    public List<sObject> queryMasterDocuments(
        InventoryLedgerTypeEnums ledgerType, 
        List<ID> documentIds, 
        string masterObjectName){
        string query = 'SELECT Id, dmpl__DocumentDate__c, Name, dmpl__PartnerAccountId__c, dmpl__BranchId__c  FROM '
            + String.escapeSingleQuotes(masterObjectName) 
            + ' WHERE Id IN (\'' + String.join(documentIds,'\',\'') + '\')';
        
        return Database.query(query);
    }
}