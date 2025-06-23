public with sharing class ClaimLineHelper 
{
    private static Boolean skipValidations = false;

    private static final string FIELD_CLAIM_CLAIMTYPE = 'dmpl__ClaimType__c';
    private static final string CLAIMTYPE_SALE = 'Sale';
    private static final string CLAIMTYPE_SERVICE = 'Service';
    private static final string CLAIMTYPE_PURCHASE = 'Purchase';
    private static final string CLAIMTYPE_DAMAGED = 'Damaged';
    private static final string CLAIMTYPE_SHORTAGE = 'Shortage';
    private static final string FIELD_CLAIMLINE_ITEMID = 'dmpl__ItemId__c';
    private static final string CLAIMTYPE_EXCESS = 'Excess';

    private static final List<String> LIST_FIELDS_NEGATIVENOTALLOWED = new List<String>{
        'dmpl__ApproveQuantity__c', 
        'dmpl__ClaimQuantity__c', 
        'dmpl__RejectQuantity__c'
    };

    public static void validateData(
        Boolean isInsert, 
        Boolean isUpdate, 
        Boolean isDelete, 
        List<dmpl__ClaimLine__c> newEntries, 
        List<dmpl__ClaimLine__c> oldEntries){
            if(isInsert){
                FieldMappingHelper.copyFieldMappingData(
                    newEntries);
            }
            if(isInsert || isUpdate){   
                ValidationHelper.validatePostiveOrZeroDecimal(
                    LIST_FIELDS_NEGATIVENOTALLOWED,
                    newEntries);
            }
    }
    public static void postData(
        Boolean isInsert, 
        Boolean isUpdate, 
        Boolean isDelete, 
        List<dmpl__ClaimLine__c> newEntries, 
        List<dmpl__ClaimLine__c> oldEntries){
            try{
                if(isInsert){
                    setItemData(
                        newEntries);
                   
                }else if(isUpdate){
                    List<dmpl__ClaimLine__c>  modifiedObjects = DocumentHelper.getModifiedNewObjects(
                        new string[]{
                            'dmpl__ClaimQuantity__c',
                            'dmpl__UOM__c',
                            'dmpl__UOM1__c', 
                            'dmpl__UOMQuantity__c',
                            'dmpl__UOMQuantity1__c'
                        }, 
                        oldEntries, 
                        newEntries); 
                    Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
                        ItemHelper.getCachedItems(
                        DocumentHelper.extractIds(
                            newEntries, 
                            'dmpl__ItemId__c')));
                            if(modifiedObjects.size()>0){
                                ItemHelper.setQuantityFromUOM(
                                newEntries, 
                                oldEntries, 
                                items,
                                'dmpl__ClaimQuantity__c',
                                null);
                            }  
                }
            } catch (Exception error) {
                ExceptionLogHelper.logException(error);
                throw error;
            }
        }

    public static void afterPostData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<dmpl__ClaimLine__c> newEntries, List<dmpl__ClaimLine__c> oldEntries)
    {
        try{
            if(isDelete){
                RepairOrderLineHelper.updateClaimedQuantity(DocumentHelper.extractIds(oldEntries, 'dmpl__RepairOrderLineId__c'));
            }else if(isInsert){
                RepairOrderLineHelper.updateClaimedQuantity(DocumentHelper.extractIds(newEntries, 'dmpl__RepairOrderLineId__c'));
            }else if(isUpdate){
                List<dmpl__ClaimLine__c> modifiedObjects = DocumentHelper.getModifiedNewObjects('dmpl__RepairOrderId__c', oldEntries, newEntries);
                if(modifiedObjects.size()>0){
                    RepairOrderLineHelper.updateClaimedQuantity(DocumentHelper.extractIds(modifiedObjects, 'dmpl__RepairOrderLineId__c'));
                }
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static Map<Id, dmpl__Claim__c> createClaimLinesFromClaim(
        List<dmpl__Claim__c> claims,
        List<SourceObjectInfo> orderLinesInfo)
    {
        return createClaimLines(claims, orderLinesInfo);
    }

    public static void markAllClaimLines(Map<Id, dmpl__Claim__c> claims)
    {
        List<dmpl__ClaimLine__c> claimLines = queryClaimLines(DocumentHelper.extractIds(claims.values()));

        for(dmpl__ClaimLine__c line : claimLines)
        {
            dmpl__Claim__c claim = claims.get(line.dmpl__ClaimId__c);
            if(claim != null && claim.dmpl__ApproveAll__c)
            {
                line.dmpl__ApproveQuantity__c = line.dmpl__ClaimQuantity__c;
                line.dmpl__RejectQuantity__c = 0;
            }
            else  if(claim != null && claim.dmpl__RejectAll__c)
            {
                line.dmpl__RejectQuantity__c = line.dmpl__ClaimQuantity__c;
                line.dmpl__ApproveQuantity__c = 0;
            }
        }

        SecurityHelper.ensureCanWriteFields(new string[]{
            'dmpl__ApproveQuantity__c',
            'dmpl__RejectQuantity__c'
        }, 'dmpl__ClaimLine__c');
        if(claimLines.size() > 0)
            update claimLines;
    }

    public static void markIsReconciliationCreated(List<dmpl__Claim__c> claims)
    {
        List<dmpl__ClaimLine__c> claimLines = queryClaimLines(DocumentHelper.extractIds(claims));

        for(dmpl__ClaimLine__c line : claimLines)
            line.dmpl__IsClaimReconciliationCreated__c = true;

            SecurityHelper.ensureCanWriteFields(new string[]{
                'dmpl__IsClaimReconciliationCreated__c'
            }, 'dmpl__ClaimLine__c');
        if(claimLines.size() > 0)
            update claimLines;
    }

    private static void setItemData(
        List<dmpl__ClaimLine__c> newEntries)
    {
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
            ItemHelper.getCachedItems(
                DocumentHelper.extractIds(
                    newEntries, 
                    FIELD_CLAIMLINE_ITEMID)));
                ItemHelper.setQuantityFromUOM(
                    newEntries, 
                    null,
                    items,
                    'dmpl__ClaimQuantity__c',
                    null);
    }

    public static void markIsReconciliationCreated(List<dmpl__ClaimBatch__c> claimBatches)
    {
        List<dmpl__ClaimLine__c> claimLines = queryClaimLines(DocumentHelper.extractIds(claimBatches));

        for(dmpl__ClaimLine__c line : claimLines)
            line.dmpl__IsClaimReconciliationCreated__c = true;

            SecurityHelper.ensureCanWriteFields(new string[]{
                'dmpl__IsClaimReconciliationCreated__c'
            }, 'dmpl__ClaimLine__c');
        if(claimLines.size() > 0)
            update claimLines;
    }

    public static void populateClaimLinesInClaimBatch(List<dmpl__ClaimBatch__c> newEntries)
    {
        List<dmpl__ClaimBatchLine__c> claimBatchLines = queryClaimBatchLines(DocumentHelper.extractIds(newEntries));
        List<dmpl__ClaimLine__c> claimLines = queryClaimLines(DocumentHelper.extractIds(claimBatchLines, 'dmpl__ClaimId__c'));

        for(dmpl__ClaimBatchLine__c claimBatchLine : claimBatchLines)
        {
            for(dmpl__ClaimLine__c claimLine : claimLines)
            {
                if(claimLine.dmpl__ClaimId__c == claimBatchLine.dmpl__ClaimId__c)
                {
                    claimLine.dmpl__ClaimBatchId__c = claimBatchLine.dmpl__ClaimBatchId__c;
                    claimLine.dmpl__ClaimBatchLineId__c = claimBatchLine.Id;
                }
            }
        }

        if(claimLines.size() > 0)
        {
            try{
                SecurityHelper.ensureCanWriteFields(new string[]{
                    'dmpl__ClaimId__c',
                    'dmpl__ClaimBatchId__c',
                    'dmpl__ClaimBatchLineId__c'
                }, 'dmpl__ClaimLine__c');
                skipValidations = true;
                update claimLines;
            }
            catch(Exception ex)
            {
                ExceptionLogHelper.logException(ex);
                throw ex;
            }
            finally{
                skipValidations = false;
            }
        }
    }

    private static List<dmpl__ClaimBatchLine__c> queryClaimBatchLines(List<Id> claimBatchIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__ClaimBatchId__c',
            'dmpl__ClaimId__c'
        }, 'dmpl__ClaimBatchLine__c');
        return [SELECT Id, Name, dmpl__ClaimBatchId__c, dmpl__ClaimId__c FROM dmpl__ClaimBatchLine__c WHERE dmpl__ClaimBatchId__c IN : claimBatchIds];
    }

    private static Map<Id,dmpl__Claim__c> createClaimLines(
        List<dmpl__Claim__c> claims,
        List<SourceObjectInfo> orderLinesInfo)
    {
        List<dmpl__Claim__c> sourceAsSale = DocumentHelper.getObjectsByFilter(claims, FIELD_CLAIM_CLAIMTYPE, CLAIMTYPE_SALE);
        List<dmpl__Claim__c> sourceAsService = DocumentHelper.getObjectsByFilter(claims, FIELD_CLAIM_CLAIMTYPE, CLAIMTYPE_SERVICE);
        List<dmpl__Claim__c> sourceAsPurchase = DocumentHelper.getObjectsByFilter(claims, FIELD_CLAIM_CLAIMTYPE, CLAIMTYPE_PURCHASE);
        List<dmpl__Claim__c> sourceAsDamage = DocumentHelper.getObjectsByFilter(claims, FIELD_CLAIM_CLAIMTYPE, CLAIMTYPE_DAMAGED);
        List<dmpl__Claim__c> sourceAsShortage = DocumentHelper.getObjectsByFilter(claims, FIELD_CLAIM_CLAIMTYPE, CLAIMTYPE_SHORTAGE);
        List<dmpl__Claim__c> sourceAsExcess = DocumentHelper.getObjectsByFilter(claims, FIELD_CLAIM_CLAIMTYPE, CLAIMTYPE_EXCESS);

        if(sourceAsSale.size() > 0)
        {
            // TO BE IMPLEMENTED
        }

        if(sourceAsService.size() > 0)
        {
            createClaimLinesForServiceAsOnDate(
                DocumentHelper.getObjectsWithNull(
                    sourceAsService, 
                    'dmpl__RepairOrderId__c'));
            createClaimLinesForService(
                DocumentHelper.getObjectsWithNotNull(
                    sourceAsService, 
                    'dmpl__RepairOrderId__c'),
                orderLinesInfo);
        }

        if(sourceAsPurchase.size() > 0)
        {
            // createClaimLinesForPurchaseReturn(sourceAsPurchase);
            createClaimLinesForBillReturn(sourceAsPurchase);
        }

        if(sourceAsDamage.size() > 0)
        {
            createClaimLinesForBillReturn(sourceAsDamage);
        }

        if(sourceAsShortage.size() > 0)
        {
            createClaimLinesForBillReturn(sourceAsShortage);
        }

        if(sourceAsExcess.size() > 0)
        {
            createClaimLinesForBillReturn(sourceAsExcess);
        }
        return new Map<Id,dmpl__Claim__c>(claims);
    }
    
    @TestVisible
    private static void createClaimLinesForServiceAsOnDate(List<dmpl__Claim__c> claims){
        List<dmpl__ClaimLine__c> newClaimLines = new List<dmpl__ClaimLine__c>();
        List<Date> asOnDates = new List<Date>();
        for(dmpl__Claim__c claim : claims) {
            asOnDates.add(Date.valueOf(claim.dmpl__AsOnDate__c));
        }
        asOnDates.sort();
        Date maxAsOnDate  = asOnDates.Size() > 0 ? asOnDates[asOnDates.Size() -1] : System.now().date();
        List<dmpl__RepairOrder__c> repairOrders = queryRepairOrdersAsOnDate(
            DocumentHelper.extractIds(
                claims,
                'dmpl__BranchId__c'),
                maxAsOnDate);
        if(repairOrders.size() ==0){
            return;
        }
        
        for(dmpl__Claim__c claim : claims){
            for(dmpl__RepairOrder__c repairOrder : repairOrders){
                if((claim.dmpl__AsOnDate__c >= repairOrder.dmpl__DocumentDate__c)){
                    for(dmpl__RepairOrderLine__c repairOrderLine : repairOrder.dmpl__Repair_Order_Lines1__r){
                        if(repairOrderLine.dmpl__PostingType__c != 'Generate Claims' 
                            && repairOrderLine.dmpl__PostingType__c != 'Auto Generate Claims'){
                            continue;
                        }
                        if(DocumentHelper.getObjectsByFilter(newClaimLines, 'dmpl__RepairOrderLineId__c', repairOrderLine.Id).Size() == 0){
                            newClaimLines.add(new dmpl__ClaimLine__c(
                                dmpl__ClaimId__c = claim.Id,
                                dmpl__BranchId__c = repairOrder.dmpl__BranchId__c,
                                dmpl__ItemId__c = repairOrderLine.dmpl__ItemId__c,
                                dmpl__ClaimQuantity__c = repairOrderLine.dmpl__ClaimableQuantity__c,
                                dmpl__UnitPrice__c = repairOrderLine.dmpl__UnitPrice__c * (repairOrderLine.dmpl__ServiceContractWeightage__c /100),
                                dmpl__TechnicianId__c = repairOrderLine.dmpl__TechnicianId__c,
                                dmpl__RepairOrderId__c = repairOrderLine.dmpl__RepairOrderId__c,
                                dmpl__RepairOrderLineId__c = repairOrderLine.Id,
                                dmpl__ServiceContractId__c = repairOrderLine.dmpl__ItemServiceContractId__c
                            ));
                        }
                    }
                }
            }
        }

        if(newClaimLines.size() > 0){
            try
            {
                skipValidations = true;
                insert newClaimLines;
            }
            catch(exception ex)
            {
                ExceptionLogHelper.logException(ex);
                throw ex;
            }
            finally
            {
                skipValidations = false;
            }
        }
    }

    @TestVisible
    private static void createClaimLinesForService(
        List<dmpl__Claim__c> claims,
        List<SourceObjectInfo> orderLinesInfo){
        List<dmpl__ClaimLine__c> newClaimLines = new List<dmpl__ClaimLine__c>();
        List<dmpl__RepairOrder__c> repairOrders = null;
        if(orderLinesInfo!=null){
            repairOrders = queryRepairOrders(
                DocumentHelper.extractIds(
                    claims,
                    'dmpl__RepairOrderId__c'),
                    SourceObjectInfo.extractIds(orderLinesInfo));
        }else{
            repairOrders = queryRepairOrders(
                DocumentHelper.extractIds(
                    claims,
                    'dmpl__RepairOrderId__c'));
        }
        
        List<Id> itemServiceContractIds = new List<Id>();
        for(dmpl__RepairOrder__c repairOrder : repairOrders){
            itemServiceContractIds = DocumentHelper.extractIds(
                repairOrder.dmpl__Repair_Order_Lines1__r, 
                'dmpl__ItemServiceContractId__c');
            itemServiceContractIds.addAll(DocumentHelper.extractIds(
                repairOrder.dmpl__Repair_Order_Lines1__r, 
                'dmpl__ItemServiceContractId2__c'));
            itemServiceContractIds.addAll(DocumentHelper.extractIds(
                repairOrder.dmpl__Repair_Order_Lines1__r, 
                'dmpl__ItemServiceContractId3__c'));
        }
        List<dmpl__ItemServiceContract__c> itemServiceContracts = queryItemServiceContracts(
            itemServiceContractIds);
        for(dmpl__Claim__c claim : claims){
            dmpl__RepairOrder__c repairOrder = (dmpl__RepairOrder__c)CollectionHelper.getObject(
                repairOrders,
                claim.dmpl__RepairOrderId__c);
            if(repairOrder == null){
                continue;
            }
            for(dmpl__RepairOrderLine__c repairOrderLine : repairOrder.dmpl__Repair_Order_Lines1__r){
                if(DocumentHelper.getObjectsByFilter(
                    newClaimLines, 
                    'dmpl__RepairOrderLineId__c', 
                    repairOrderLine.Id).Size() != 0){
                    continue;
                }
                if(repairOrderLine.dmpl__InvoiceGroup__c != claim.dmpl__InvoiceGroup__c){
                    continue;
                }

                if(claim.dmpl__ItemServiceContractId__c == repairOrderLine.dmpl__ItemServiceContractId__c
                    && (repairOrderLine.dmpl__PostingType__c == 'Generate Claims' 
                    ||  repairOrderLine.dmpl__PostingType__c == 'Auto Generate Claims')){
                    newClaimLines.add(
                        createClaimLine(
                            claim,
                            repairOrder,
                            repairOrderLine));
                } 
                if(repairOrderLine.dmpl__ServiceContractWeightage2__c >0
                    && repairOrderLine.dmpl__ItemServiceContractId2__c !=null
                    && (repairOrderLine.dmpl__ItemServiceContractId2__r.dmpl__ContractPostingTreatment__c =='Auto Generate Claims'
                        || repairOrderLine.dmpl__ItemServiceContractId2__r.dmpl__ContractPostingTreatment__c  =='Generate Claims')
                    && claim.dmpl__ItemServiceContractId__c == repairOrderLine.dmpl__ItemServiceContractId2__c){
                        dmpl__ItemServiceContract__c itemContract = (dmpl__ItemServiceContract__c)DocumentHelper.getObject(
                            itemServiceContracts,
                            repairOrderLine.dmpl__ItemServiceContractId2__c);
                        if(itemContract!=null && itemContract.dmpl__WeightageInvoiceChargeItem__c!=null){
                            dmpl__ClaimLine__c existingLine = (dmpl__ClaimLine__c)DocumentHelper.getObjectByFilter(
                                newClaimLines,
                                'dmpl__ItemId__c',
                                itemContract.dmpl__WeightageInvoiceChargeItem__c);
                            if(existingLine!=null){
                                existingLine.dmpl__UnitPrice__c += repairOrderLine.dmpl__Quantity__c 
                                    * repairOrderLine.dmpl__UnitPrice__c 
                                    * (repairOrderLine.dmpl__ServiceContractWeightage2__c/100);
                            }else {
                                newClaimLines.add(
                                    createClaimLine2(
                                        claim,
                                        repairOrder,
                                        repairOrderLine,
                                        itemContract.dmpl__WeightageInvoiceChargeItem__c));
                            }
                        }
                }
                if(repairOrderLine.dmpl__ServiceContractWeightage3__c >0
                    && repairOrderLine.dmpl__ItemServiceContractId3__c !=null
                    && (repairOrderLine.dmpl__ItemServiceContractId3__r.dmpl__ContractPostingTreatment__c  =='Auto Generate Claims'
                        || repairOrderLine.dmpl__ItemServiceContractId3__r.dmpl__ContractPostingTreatment__c  =='Generate Claims')
                    && claim.dmpl__ItemServiceContractId__c == repairOrderLine.dmpl__ItemServiceContractId3__c){
                    dmpl__ItemServiceContract__c itemContract = (dmpl__ItemServiceContract__c)DocumentHelper.getObject(
                        itemServiceContracts,
                        repairOrderLine.dmpl__ItemServiceContractId3__c);
                    if(itemContract!=null && itemContract.dmpl__WeightageInvoiceChargeItem__c!=null){
                        dmpl__ClaimLine__c existingLine = (dmpl__ClaimLine__c)DocumentHelper.getObjectByFilter(
                            newClaimLines,
                            'dmpl__ItemId__c',
                            itemContract.dmpl__WeightageInvoiceChargeItem__c);
                        if(existingLine!=null){
                            existingLine.dmpl__UnitPrice__c += repairOrderLine.dmpl__Quantity__c 
                                * repairOrderLine.dmpl__UnitPrice__c 
                                * (repairOrderLine.dmpl__ServiceContractWeightage2__c/100);
                        }else {
                            newClaimLines.add(
                                createClaimLine3(
                                    claim,
                                    repairOrder,
                                    repairOrderLine,
                                    itemContract.dmpl__WeightageInvoiceChargeItem__c));
                        }
                    }
                }   
            }
        }

        if(newClaimLines.size() > 0){
            try
            {
                skipValidations = true;
                insert newClaimLines;
            }
            catch(exception ex)
            {
                ExceptionLogHelper.logException(ex);
                throw ex;
            }
            finally
            {
                skipValidations = false;
            }
        }
    }

    @testVisible
    private static dmpl__ClaimLine__c createClaimLine(
        dmpl__Claim__c claim, 
        dmpl__RepairOrder__c repairOrder, 
        dmpl__RepairOrderLine__c repairOrderLine){
        return new dmpl__ClaimLine__c(
            dmpl__ClaimId__c = claim.Id,
            dmpl__BranchId__c = repairOrder.dmpl__BranchId__c,
            dmpl__ItemId__c = repairOrderLine.dmpl__ItemId__c,
            dmpl__ClaimQuantity__c = repairOrderLine.dmpl__ClaimableQuantity__c,
            dmpl__UnitPrice__c = repairOrderLine.dmpl__UnitPrice__c,
            dmpl__Discount__c = (100 - repairOrderLine.dmpl__ServiceContractWeightage__c),
            dmpl__TechnicianId__c = repairOrderLine.dmpl__TechnicianId__c,
            dmpl__RepairOrderId__c = repairOrderLine.dmpl__RepairOrderId__c,
            dmpl__RepairOrderLineId__c = repairOrderLine.Id,
            dmpl__ServiceContractId__c = repairOrderLine.dmpl__ItemServiceContractId__c
        );
    }

    @testVisible
    private static dmpl__ClaimLine__c createClaimLine2(
        dmpl__Claim__c claim, 
        dmpl__RepairOrder__c repairOrder, 
        dmpl__RepairOrderLine__c repairOrderLine,
        Id weightageInvoiceChargeItem){
            return new dmpl__ClaimLine__c(
                dmpl__ClaimId__c = claim.Id,
                dmpl__BranchId__c = repairOrder.dmpl__BranchId__c,
                dmpl__ItemId__c = weightageInvoiceChargeItem,
                dmpl__ClaimQuantity__c = 1,
                dmpl__UnitPrice__c = repairOrderLine.dmpl__ClaimableQuantity__c * repairOrderLine.dmpl__UnitPrice__c * (repairOrderLine.dmpl__ServiceContractWeightage2__c/100),
                dmpl__TechnicianId__c = repairOrderLine.dmpl__TechnicianId__c,
                dmpl__RepairOrderId__c = repairOrderLine.dmpl__RepairOrderId__c,
                dmpl__RepairOrderLineId__c = repairOrderLine.Id,
                dmpl__ServiceContractId__c = repairOrderLine.dmpl__ItemServiceContractId__c
            );  
    }

    @testVisible
    private static dmpl__ClaimLine__c createClaimLine3(
        dmpl__Claim__c claim, 
        dmpl__RepairOrder__c repairOrder, 
        dmpl__RepairOrderLine__c repairOrderLine,
        Id weightageInvoiceChargeItem){
            return new dmpl__ClaimLine__c(
                dmpl__ClaimId__c = claim.Id,
                dmpl__BranchId__c = repairOrder.dmpl__BranchId__c,
                dmpl__ItemId__c = weightageInvoiceChargeItem,
                dmpl__ClaimQuantity__c = 1,
                dmpl__UnitPrice__c = repairOrderLine.dmpl__ClaimableQuantity__c * repairOrderLine.dmpl__UnitPrice__c * (repairOrderLine.dmpl__ServiceContractWeightage2__c/100),
                dmpl__TechnicianId__c = repairOrderLine.dmpl__TechnicianId__c,
                dmpl__RepairOrderId__c = repairOrderLine.dmpl__RepairOrderId__c,
                dmpl__RepairOrderLineId__c = repairOrderLine.Id,
                dmpl__ServiceContractId__c = repairOrderLine.dmpl__ItemServiceContractId__c
            );  
    }

    private static List<dmpl__ItemServiceContract__c> queryItemServiceContracts(
        List<Id> itemServiceContractIds){
        return [SELECT 
            Id, 
            Name, 
            dmpl__ContractPostingTreatment__c,
            dmpl__BillingAccountId__c, 
            dmpl__WeightageInvoiceChargeItem__c
        FROM 
            dmpl__ItemServiceContract__c 
        WHERE 
            Id IN : itemServiceContractIds];
    }

    //To Be Deleted
    @TestVisible
    private static void createClaimLinesForPurchaseReturn(List<dmpl__Claim__c> claims)
    {
        List<dmpl__ClaimLine__c> newClaimLines = new List<dmpl__ClaimLine__c>();
        List<dmpl__PurchaseReturnLine__c> purchaseReturnLinesToUpdate = new List<dmpl__PurchaseReturnLine__c>();

        List<Date> asOnDates = new List<Date>();
        for(dmpl__Claim__c claim : claims) {
            asOnDates.add(Date.valueOf(claim.dmpl__AsOnDate__c));
        }
        asOnDates.sort();
        Date maxAsOnDate  = asOnDates.Size() > 0 ? asOnDates[asOnDates.Size() -1] : System.now().date();
        List<dmpl__PurchaseReturnLine__c> returnLines = queryPurchaseReturnLines(DocumentHelper.extractIds(claims,'dmpl__BranchId__c'), DocumentHelper.extractIds(claims,'dmpl__PurchaseReturnId__c'), maxAsOnDate);

        for(dmpl__Claim__c claim : claims)
        {
            for(dmpl__PurchaseReturnLine__c returnLine : returnLines)
            {
                if((claim.dmpl__PurchaseReturnId__c != null && claim.dmpl__PurchaseReturnId__c == returnLine.dmpl__PurchaseReturnId__c) 
                    || (claim.dmpl__PurchaseReturnId__c == null && claim.dmpl__AsOnDate__c >= returnLine.dmpl__PurchaseReturnId__r.dmpl__DocumentDate__c))
                {
       
                    if(DocumentHelper.getObjectsByFilter(newClaimLines, 'dmpl__PurchaseReturnLineId__c', returnLine.Id).Size() == 0)
                        {
                            newClaimLines.add(new dmpl__ClaimLine__c(
                                dmpl__ClaimId__c = claim.Id,
                                dmpl__BranchId__c = returnLine.dmpl__PurchaseReturnId__r.dmpl__BranchId__c,
                                dmpl__ItemId__c = returnLine.dmpl__ItemId__c,
                                dmpl__ClaimQuantity__c = returnLine.dmpl__ClaimableQuantity__c,
                                dmpl__UnitPrice__c = returnLine.dmpl__UnitCost__c,
                                dmpl__UnitPrice2__c = returnLine.dmpl__UnitCost2__c,
                                dmpl__PurchaseReturnLineId__c = returnLine.Id
                            ));
                        }
                        purchaseReturnLinesToUpdate.add(returnLine);
                }
            }
        }

        if(newClaimLines.size() > 0)
        {
            try
            {
                skipValidations = true;
                SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__ClaimId__c','dmpl__BranchId__c','dmpl__ItemId__c','dmpl__UnitPrice__c','dmpl__UnitPrice2__c','dmpl__ClaimQuantity__c','dmpl__PurchaseReturnLineId__c'}, 'dmpl__ClaimLine__c');
                insert newClaimLines;
                PurchaseReturnLineHelper.markAsClaimed(purchaseReturnLinesToUpdate);
            }
            catch(exception ex)
            {
                ExceptionLogHelper.logException(ex);
                throw ex;
            }
            finally
            {
                skipValidations = false;
            }
        }
    }

    @TestVisible
    private static void createClaimLinesForBillReturn(List<dmpl__Claim__c> claims)
    {
        List<dmpl__ClaimLine__c> newClaimLines = new List<dmpl__ClaimLine__c>();
        List<dmpl__BillReturnLine__c> billReturnLinesToUpdate = new List<dmpl__BillReturnLine__c>();

        List<Date> asOnDates = new List<Date>();
        for(dmpl__Claim__c claim : claims) {
            asOnDates.add(Date.valueOf(claim.dmpl__AsOnDate__c));
        }
        asOnDates.sort();
        Date maxAsOnDate  = asOnDates.Size() > 0 ? asOnDates[asOnDates.Size() -1] : System.now().date();
        List<dmpl__BillReturnLine__c> returnLines = queryBillReturnLines(DocumentHelper.extractIds(claims,'dmpl__BranchId__c'), DocumentHelper.extractIds(claims,'dmpl__BillReturnId__c'), maxAsOnDate);

        for(dmpl__Claim__c claim : claims)
        {
            for(dmpl__BillReturnLine__c returnLine : returnLines)
            {
                if((claim.dmpl__BillReturnId__c != null && claim.dmpl__BillReturnId__c == returnLine.dmpl__BillReturnId__c) 
                    || (claim.dmpl__BillReturnId__c == null && claim.dmpl__AsOnDate__c >= returnLine.dmpl__BillReturnId__r.dmpl__DocumentDate__c))
                {
                    if(claim.dmpl__ClaimType__c  ==  CLAIMTYPE_PURCHASE || claim.dmpl__ClaimType__c == returnLine.dmpl__ReturnType__c)
                    {
        
                        if(DocumentHelper.getObjectsByFilter(newClaimLines, 'dmpl__BillReturnLineId__c', returnLine.Id).Size() == 0)
                        {
                            newClaimLines.add(new dmpl__ClaimLine__c(
                                dmpl__ClaimId__c = claim.Id,
                                dmpl__BranchId__c = returnLine.dmpl__BillReturnId__r.dmpl__BranchId__c,
                                dmpl__ItemId__c = returnLine.dmpl__ItemId__c,
                                dmpl__ClaimQuantity__c = returnLine.dmpl__ClaimableQuantity__c,
                                dmpl__UnitPrice__c = returnLine.dmpl__UnitCost__c,
                                dmpl__UnitPrice2__c = returnLine.dmpl__UnitCost2__c,
                                dmpl__BillReturnLineId__c = returnLine.Id
                            ));
                        }
                        billReturnLinesToUpdate.add(returnLine);
                    }
                }
            }
        }

        if(newClaimLines.size() > 0)
        {
            try
            {
                skipValidations = true;
                insert newClaimLines;
                BillReturnLineHelper.markAsClaimed(billReturnLinesToUpdate);
            }
            catch(exception ex)
            {
                ExceptionLogHelper.logException(ex);
                throw ex;
            }
            finally
            {
                skipValidations = false;
            }
        }
    }

    private static List<dmpl__RepairOrder__c> queryRepairOrders(List<Id> repairOrderIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__AssetId__c',
            'dmpl__BranchId__c',
            'dmpl__CancelPendingQuantity__c',
            'dmpl__DocumentDate__c',
            'dmpl__IsClaimed__c',
            'dmpl__IsDelivered__c',
            'dmpl__PartnerAccountId__c',
            'dmpl__OrderAmount__c'
        }, 'dmpl__RepairOrder__c');
        return [SELECT
        Id, 
        Name,
        dmpl__AssetId__c,
        dmpl__BranchId__c,
        dmpl__CancelPendingQuantity__c,
        dmpl__DocumentDate__c,
        dmpl__IsClaimed__c,
        dmpl__IsDelivered__c,
        dmpl__PartnerAccountId__c,
        dmpl__OrderAmount__c,
        (
            SELECT
                dmpl__AllocatedQuantity__c,
                dmpl__CancelledQuantity__c,
                dmpl__ComplaintCodeId__c,
                dmpl__ComplaintFaultCodeId__c,
                dmpl__IsClaimed__c,
                dmpl__IsInvoiced__c,
                dmpl__IsPackageService__c,
                dmpl__ItemId__c,
                dmpl__PostingType__c,
                dmpl__PurchaseOrderLineId__c,
                dmpl__Quantity__c,
                dmpl__RepairOrderId__c,
                dmpl__SKUId__c,
                dmpl__StorageLocationId__c,
                dmpl__TechnicianId__c,
                dmpl__UnitPrice__c,
                dmpl__UnitPrice2__c,
                dmpl__InvoiceGroup__c, 
                dmpl__ClaimableQuantity__c,
                dmpl__ItemServiceContractId__c,
                dmpl__ItemServiceContractId2__c,
                dmpl__ItemServiceContractId3__c,
                dmpl__ServiceContractWeightage__c,
                dmpl__ServiceContractWeightage2__c,
                dmpl__ServiceContractWeightage3__c,
                dmpl__ItemServiceContractId2__r.dmpl__ContractPostingTreatment__c,
                dmpl__ItemServiceContractId3__r.dmpl__ContractPostingTreatment__c
            FROM
                dmpl__Repair_Order_Lines1__r
            WHERE 
                (dmpl__PostingType__c = 'Generate Claims' 
                    OR dmpl__PostingType__c = 'Auto Generate Claims'
                    OR dmpl__ItemServiceContractId2__r.dmpl__ContractPostingTreatment__c  ='Generate Claims'
                    OR dmpl__ItemServiceContractId2__r.dmpl__ContractPostingTreatment__c  ='Auto Generate Claims'
                    OR dmpl__ItemServiceContractId3__r.dmpl__ContractPostingTreatment__c = 'Generate Claims'
                    OR dmpl__ItemServiceContractId3__r.dmpl__ContractPostingTreatment__c = 'Auto Generate Claims')
                AND dmpl__PackageClassification__c != 'Packaged Item'
                AND dmpl__ClaimableQuantity__c > 0
        )
        FROM
            dmpl__RepairOrder__c 
        WHERE 
            (Id IN: repairOrderIds)];
    }


    @testVisible
    private static List<dmpl__RepairOrder__c> queryRepairOrders(List<Id> repairOrderIds, List<Id> repairOrderLineIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__AssetId__c',
            'dmpl__BranchId__c',
            'dmpl__CancelPendingQuantity__c',
            'dmpl__DocumentDate__c',
            'dmpl__IsClaimed__c',
            'dmpl__IsDelivered__c',
            'dmpl__PartnerAccountId__c',
            'dmpl__OrderAmount__c'
        }, 'dmpl__RepairOrder__c');
        return [SELECT
        Id, 
        Name,
        dmpl__AssetId__c,
        dmpl__BranchId__c,
        dmpl__CancelPendingQuantity__c,
        dmpl__DocumentDate__c,
        dmpl__IsClaimed__c,
        dmpl__IsDelivered__c,
        dmpl__PartnerAccountId__c,
        dmpl__OrderAmount__c,
        (
            SELECT
                dmpl__AllocatedQuantity__c,
                dmpl__CancelledQuantity__c,
                dmpl__ComplaintCodeId__c,
                dmpl__ComplaintFaultCodeId__c,
                dmpl__IsClaimed__c,
                dmpl__IsInvoiced__c,
                dmpl__IsPackageService__c,
                dmpl__ItemId__c,
                dmpl__PostingType__c,
                dmpl__PurchaseOrderLineId__c,
                dmpl__Quantity__c,
                dmpl__RepairOrderId__c,
                dmpl__SKUId__c,
                dmpl__StorageLocationId__c,
                dmpl__TechnicianId__c,
                dmpl__UnitPrice__c,
                dmpl__UnitPrice2__c,
                dmpl__InvoiceGroup__c, 
                dmpl__ClaimableQuantity__c,
                dmpl__ItemServiceContractId__c,
                dmpl__ItemServiceContractId2__c,
                dmpl__ItemServiceContractId3__c,
                dmpl__ServiceContractWeightage__c,
                dmpl__ServiceContractWeightage2__c,
                dmpl__ServiceContractWeightage3__c,
                dmpl__ItemServiceContractId2__r.dmpl__ContractPostingTreatment__c,
                dmpl__ItemServiceContractId3__r.dmpl__ContractPostingTreatment__c
            FROM
                dmpl__Repair_Order_Lines1__r
            WHERE 
                (dmpl__PostingType__c = 'Generate Claims' 
                    OR dmpl__PostingType__c = 'Auto Generate Claims'
                    OR dmpl__ItemServiceContractId2__r.dmpl__ContractPostingTreatment__c  ='Generate Claims'
                    OR dmpl__ItemServiceContractId2__r.dmpl__ContractPostingTreatment__c  ='Auto Generate Claims'
                    OR dmpl__ItemServiceContractId3__r.dmpl__ContractPostingTreatment__c = 'Generate Claims'
                    OR dmpl__ItemServiceContractId3__r.dmpl__ContractPostingTreatment__c = 'Auto Generate Claims')
                AND dmpl__PackageClassification__c != 'Packaged Item'
                AND dmpl__ClaimableQuantity__c > 0
                AND Id IN :repairOrderLineIds
        )
        FROM
            dmpl__RepairOrder__c 
        WHERE 
            (Id IN: repairOrderIds)];
    }

    //To be Discontinued
    //Insted generate cliam from service order
    private static List<dmpl__RepairOrder__c> queryRepairOrdersAsOnDate(List<Id> branchIds, Date AsOnDate)
    {
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__AssetId__c',
            'dmpl__BranchId__c',
            'dmpl__CancelPendingQuantity__c',
            'dmpl__DocumentDate__c',
            'dmpl__IsClaimed__c',
            'dmpl__IsDelivered__c',
            'dmpl__PartnerAccountId__c',
            'dmpl__OrderAmount__c'
        }, 'dmpl__RepairOrder__c');
        return [SELECT
        Id, 
        Name,
        dmpl__AssetId__c,
        dmpl__BranchId__c,
        dmpl__CancelPendingQuantity__c,
        dmpl__DocumentDate__c,
        dmpl__IsClaimed__c,
        dmpl__IsDelivered__c,
        dmpl__PartnerAccountId__c,
        dmpl__OrderAmount__c,
        (
            SELECT
                dmpl__AllocatedQuantity__c,
                dmpl__CancelledQuantity__c,
                dmpl__ComplaintCodeId__c,
                dmpl__ComplaintFaultCodeId__c,
                dmpl__IsClaimed__c,
                dmpl__IsInvoiced__c,
                dmpl__IsPackageService__c,
                dmpl__ItemId__c,
                dmpl__PostingType__c,
                dmpl__PurchaseOrderLineId__c,
                dmpl__Quantity__c,
                dmpl__RepairOrderId__c,
                dmpl__SKUId__c,
                dmpl__StorageLocationId__c,
                dmpl__TechnicianId__c,
                dmpl__UnitPrice__c,
                dmpl__UnitPrice2__c,
                dmpl__ClaimableQuantity__c,
                dmpl__ItemServiceContractId__c,
                dmpl__ItemServiceContractId2__c,
                dmpl__ItemServiceContractId3__c,
                dmpl__ServiceContractWeightage__c,
                dmpl__ServiceContractWeightage2__c,
                dmpl__ServiceContractWeightage3__c,
                dmpl__ItemServiceContractId2__r.dmpl__ContractPostingTreatment__c,
                dmpl__ItemServiceContractId3__r.dmpl__ContractPostingTreatment__c
            FROM
                dmpl__Repair_Order_Lines1__r
            WHERE 
            (dmpl__PostingType__c = 'Generate Claims' 
                OR dmpl__PostingType__c = 'Auto Generate Claims'
                OR dmpl__ItemServiceContractId2__r.dmpl__ContractPostingTreatment__c  ='Generate Claims'
                OR dmpl__ItemServiceContractId2__r.dmpl__ContractPostingTreatment__c  ='Auto Generate Claims'
                OR dmpl__ItemServiceContractId3__r.dmpl__ContractPostingTreatment__c = 'Generate Claims'
                OR dmpl__ItemServiceContractId3__r.dmpl__ContractPostingTreatment__c = 'Auto Generate Claims')
            AND dmpl__PackageClassification__c != 'Packaged Item'
            AND dmpl__ClaimableQuantity__c > 0
            AND dmpl__IsClaimed__c = false
        )
        FROM
            dmpl__RepairOrder__c 
        WHERE 
            dmpl__BranchId__c IN : branchIds
            AND (dmpl__DocumentDate__c <= : AsOnDate)
            AND dmpl__IsClaimed__c = false
            AND (dmpl__IsInvoiceGenerated__c = true OR dmpl__IsDelivered__c = true)];
    }

    @testVisible
    private static List<dmpl__GoodsReceipt__c> queryGoodsReceipts(Id branchId, Id goodsReceiptId, Date asOnDate)
    {
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__BranchId__c',
            'dmpl__DocumentDate__c',
            'dmpl__PartnerAccountId__c',
            'dmpl__PurchaseOrderId__c',
            'dmpl__SupplierAccountId__c'
        }, 'dmpl__GoodsReceipt__c');
        return [SELECT
        Id,
        Name,
        dmpl__BranchId__c,
        dmpl__DocumentDate__c,
        dmpl__PartnerAccountId__c,
        dmpl__PurchaseOrderId__c,
        dmpl__SupplierAccountId__c,
        (
            SELECT
                dmpl__ExcessQuantity__c,
                dmpl__GoodsReceiptId__c,
                dmpl__InspectionQuantity__c,
                dmpl__InvoiceQuantity__c,
                dmpl__IsApproved__c,
                dmpl__ItemId__c,
                dmpl__ItemLotId__c,
                dmpl__OrderedQuantity__c,
                dmpl__PendingInvoiceQuantity__c,
                dmpl__ReceivedQuantity__c,
                dmpl__ReturnedQuantity__c,
                dmpl__ShortageQuantity__c,
                dmpl__SKUId__c,
                dmpl__SupplierQuantity__c,
                dmpl__ClaimableQuantity__c,
                Id,
                Name
            FROM
                dmpl__GoodsReceiptLines__r
            WHERE
                dmpl__IsClaimed__c = false
                AND dmpl__ClaimableQuantity__c > 0
        )
        FROM
            dmpl__GoodsReceipt__c
        WHERE 
            dmpl__IsClaimed__c = false 
            AND dmpl__BranchId__c = : branchId
            AND (dmpl__DocumentDate__c <= : AsOnDate OR Id = : goodsReceiptId)
            AND dmpl__IsReceived__c = true];
    }

    //To Be Deleted
    private static List<dmpl__PurchaseReturnLine__c> queryPurchaseReturnLines(List<Id> branchIds, List<Id> purchaseReturnIds, Date asOnDate)
    {
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__BranchId__c',
            'dmpl__DocumentDate__c',
            'dmpl__PartnerAccountId__c'
        }, 'dmpl__PurchaseReturn__c');

        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__PurchaseReturnId__c',
            'dmpl__ClaimableQuantity__c',
            'dmpl__UnitCost__c',
            'dmpl__UnitCost2__c',
            'dmpl__SKUId__c',
            'dmpl__IsILPosted__c',
            'dmpl__ItemId__c',
            'dmpl__ReturnType__c'
        }, 'dmpl__PurchaseReturnLine__c');
        
        return [SELECT
            Id,
            Name,
            dmpl__PurchaseReturnId__r.dmpl__BranchId__c,
            dmpl__PurchaseReturnId__r.dmpl__DocumentDate__c,
            dmpl__PurchaseReturnId__r.dmpl__PartnerAccountId__c,
            dmpl__PurchaseReturnId__r.dmpl__SupplierAccountId__c,
            dmpl__ClaimableQuantity__c,
            dmpl__PurchaseReturnId__c,
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__UnitCost__c,
            dmpl__UnitCost2__c,
            dmpl__ReturnType__c
        FROM
            dmpl__PurchaseReturnLine__c
        WHERE 
            dmpl__IsClaimed__c = false 
            AND dmpl__ClaimableQuantity__c > 0
            // AND dmpl__IsILPosted__c = true
            AND dmpl__PurchaseReturnId__r.dmpl__BranchId__c IN: branchIds
            AND (dmpl__PurchaseReturnId__r.dmpl__DocumentDate__c <= : AsOnDate OR dmpl__PurchaseReturnId__c IN: purchaseReturnIds)];
    }

    private static List<dmpl__BillReturnLine__c> queryBillReturnLines(List<Id> branchIds, List<Id> billReturnIds, Date asOnDate)
    {
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__BranchId__c',
            'dmpl__DocumentDate__c',
            'dmpl__PartnerAccountId__c'
        }, 'dmpl__BillReturn__c');

        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__PurchaseReturnId__c',
            'dmpl__ClaimableQuantity__c',
            'dmpl__UnitCost__c',
            'dmpl__UnitCost2__c',
            'dmpl__SKUId__c',
            'dmpl__IsILPosted__c',
            'dmpl__ItemId__c',
            'dmpl__ReturnType__c'
        }, 'dmpl__BillReturnLine__c');
        
        return [SELECT
            Id,
            Name,
            dmpl__BillReturnId__r.dmpl__BranchId__c,
            dmpl__BillReturnId__r.dmpl__DocumentDate__c,
            dmpl__BillReturnId__r.dmpl__PartnerAccountId__c,
            dmpl__BillReturnId__r.dmpl__SupplierAccountId__c,
            dmpl__ClaimableQuantity__c,
            dmpl__BillReturnId__c,
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__UnitCost__c,
            dmpl__UnitCost2__c,
            dmpl__ReturnType__c
        FROM
            dmpl__BillReturnLine__c
        WHERE 
            dmpl__IsClaimed__c = false 
            AND dmpl__ClaimableQuantity__c > 0
            // AND dmpl__IsILPosted__c = true
            AND dmpl__BillReturnId__r.dmpl__BranchId__c IN: branchIds
            AND (dmpl__BillReturnId__r.dmpl__DocumentDate__c <= : AsOnDate OR dmpl__BillReturnId__c IN: billReturnIds)];
    }

    private static List<dmpl__ClaimLine__c> queryClaimLines(List<Id> claimIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__ApproveQuantity__c',
            'dmpl__RejectQuantity__c',
            'dmpl__ClaimQuantity__c',
            'dmpl__ClaimId__c'
        }, 'dmpl__ClaimLine__c');
        return [SELECT
        Id,
        dmpl__ApproveQuantity__c,
        dmpl__RejectQuantity__c,
        dmpl__ClaimQuantity__c,
        dmpl__ClaimId__c,
        dmpl__IsClaimReconciliationCreated__c
        FROM
            dmpl__ClaimLine__c
        WHERE 
            dmpl__ClaimId__c in: claimIds OR dmpl__ClaimBatchId__c IN : claimIds];
    }
}