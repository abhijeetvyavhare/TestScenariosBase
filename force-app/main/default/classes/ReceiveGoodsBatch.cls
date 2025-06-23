public with sharing class ReceiveGoodsBatch implements Database.Batchable<SObject>
{
    public static final Integer BATCH_SIZE = 50;
    private Id invokedQueueId;
    private Id goodsReceiptId;
    private String batchQuery;
    private dmpl__GoodsReceipt__c goodsReceipt;

    public static JobResponseResult perfromAction(Id recordId,Id queueId)
    {
        try 
        {
            return processGoodsReceipt(recordId, queueId);
        } 
        catch (Exception error) 
        {
            ExceptionLogHelper.logException(error, queueId);
            throw error;
        }
    }

    public static JobResponseResult processGoodsReceipt(Id recordId, Id queueId)
    {
        String query = 'SELECT ID,Name,dmpl__IsApproved__c,dmpl__UnitCost__c,dmpl__InventoryLedgerInspectionId__c,dmpl__ItemLotId__c,dmpl__ItemLotId__r.Name,dmpl__OrderedQuantity__c,dmpl__ReceivedQuantity__c,dmpl__GoodsReceiptId__c,dmpl__SKUId__c,dmpl__ItemLotTypeId__c,dmpl__SerialNumber__c,dmpl__StorageLocationId__c,dmpl__SupplierQuantity__c,dmpl__ItemId__c,dmpl__ComponentNumber__c,dmpl__MRP__c,dmpl__ReturnedQuantity__c FROM dmpl__GoodsReceiptLine__c WHERE dmpl__IsApproved__c = false AND dmpl__GoodsReceiptId__c = \''+recordId+'\' ORDER BY CreatedDate, Name';
        Id batchId = Database.executeBatch(
            new ReceiveGoodsBatch(
                recordId,
                queueId,
                query
            ), 
            BATCH_SIZE);
        return new JobResponseResult(
            true, 
            null, 
            'Apex Batch Job Enqueued With Job Id ' + batchId);  
    }

    public ReceiveGoodsBatch(
        Id recordId,
        Id queueId,
        String query)
        {
            invokedQueueId = queueId;
            goodsReceiptId = recordId;
            batchQuery = query;
        }

    public Database.QueryLocator start(Database.BatchableContext bc)
    {
        try 
        {
            InterfaceQueueHelper.addStatusUpdate(invokedQueueId,'Starting Receive Goods Batch');
            return Database.getQueryLocator(batchQuery);
        } 
        catch (Exception error) 
        {
            ExceptionLogHelper.logException(error, invokedQueueId);
            throw error;
        }
    }

    public void execute(Database.BatchableContext bc, List<SObject> scope)
    {
        try
        {
            GoodReceiptLineHelper.receiveLinesFromReceiveGoodsBatch((List<dmpl__GoodsReceiptLine__c>)scope);
        }
        catch(Exception error)
        {
            ExceptionLogHelper.logException(error);
        }
    }

    public void finish(Database.BatchableContext bc)
    {
        InterfaceQueueHelper.addStatusUpdate(invokedQueueId,'Finished IG Batch - Receive Goods Batch');
    }
}