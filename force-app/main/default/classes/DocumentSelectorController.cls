public with sharing class DocumentSelectorController {
    
    @AuraEnabled(cacheable = true)
    public static List<dmpl__CreateRelatedSetting__mdt> getCreateRelatedSettings(string objectApiName)
    {
        try {
            return CreateRelatedSettingHelper.getCreateRelatedSettings(objectApiName);
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    @AuraEnabled
    public static List<SObject> getChildObjects(
        Id recordSettingId, 
        Id hostId,
        String searchKey)
    {
        try {
            Id recordId = hostId;
            return Database.query(
                CreateRelatedSettingHelper.getSOQLQuery(
                    CreateRelatedSettingHelper.getCreateRelatedSetting(recordSettingId),
                    searchKey,
                    hostId
                )
            ) ;
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    @AuraEnabled
    public static CreateRelatedResult releaseDocument(
        Id recordSettingId, 
        Id hostId,
        Integer recordCount)
    {
        try {
            dmpl__CreateRelatedSetting__mdt recordSetting = CreateRelatedSettingHelper.getCreateRelatedSetting(recordSettingId);
            if(!String.isBlank(recordSetting.dmpl__CustomClassName__c)){
                return performExternalAction(
                    'performAction',
                    recordSetting.dmpl__CustomClassName__c,
                    recordSettingId,
                    hostId,
                    null);
            }
            Decimal asyncRecordCount = recordSetting.dmpl__AsyncRecordCount__c == null ? 0 : recordSetting.dmpl__AsyncRecordCount__c;
            if(asyncRecordCount > 0 
                && recordCount > asyncRecordCount){
                return queueReleaseDocument(
                    recordSettingId, 
                    hostId);
            } else if(recordSetting.dmpl__ActionType__c == null 
                || recordSetting.dmpl__ActionType__c == 'Release'){
                    return performActionRelease(
                        recordSettingId, 
                        hostId,
                        recordSetting);
            } else if(recordSetting.dmpl__ActionType__c == 'Cancel'){
                return performActionCancel(
                    recordSettingId, 
                    hostId,
                    recordSetting);
            } else if(recordSetting.dmpl__ActionType__c == 'Return'){
                return performActionReturn(
                    recordSettingId, 
                    hostId,
                    recordSetting);
            } else if(recordSetting.dmpl__ActionType__c == 'Confirm'){
                return performActionConfirm(
                    recordSettingId, 
                    hostId,
                    recordSetting);
            } else if(recordSetting.dmpl__ActionType__c == 'Post IL'){
                return performActionPostIL(
                    recordSettingId, 
                    hostId,
                    recordSetting);
            } else if(recordSetting.dmpl__ActionType__c == 'Post GL'){
                return performActionPostGL(
                    recordSettingId, 
                    hostId,
                    recordSetting);
            } else { 
                return new CreateRelatedResult('No handler attached');
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    @AuraEnabled
    public static CreateRelatedResult releaseChildDocuments(
        Id recordSettingId, 
        Id hostId,
        List<SourceObjectInfo> childObjectsInfo)
    {
        try {
            dmpl__CreateRelatedSetting__mdt recordSetting = CreateRelatedSettingHelper.getCreateRelatedSetting(recordSettingId);
            if(!String.isBlank(recordSetting.dmpl__CustomClassName__c)){
                return performExternalAction(
                    'performAction',
                    recordSetting.dmpl__CustomClassName__c,
                    recordSettingId,
                    hostId,
                    childObjectsInfo);
            }
            Decimal recordCount = recordSetting.dmpl__AsyncRecordCount__c == null ? 0 : recordSetting.dmpl__AsyncRecordCount__c;
            if(recordCount >0 
                && childObjectsInfo.size() > recordCount){
                return queueReleaseDocument(
                    recordSettingId, 
                    hostId,
                    childObjectsInfo);
            }else if(recordSetting.dmpl__ActionType__c == null 
                || recordSetting.dmpl__ActionType__c == 'Release'){
                return performActionRelease(
                    recordSettingId, 
                    hostId,
                    childObjectsInfo,
                    recordSetting);
            } else if(recordSetting.dmpl__ActionType__c == 'Cancel'){
                return performActionCancel(
                    recordSettingId, 
                    hostId,
                    childObjectsInfo,
                    recordSetting);
            } else if(recordSetting.dmpl__ActionType__c == 'Return'){
                return performActionReturn(
                    recordSettingId, 
                    hostId,
                    childObjectsInfo,
                    recordSetting);
            } else if(recordSetting.dmpl__ActionType__c == 'Confirm'){
                return performActionConfirm(
                    recordSettingId, 
                    hostId,
                    childObjectsInfo,
                    recordSetting);
            } else if(recordSetting.dmpl__ActionType__c == 'Post IL'){
                return performActionPostIL(
                    recordSettingId, 
                    hostId,
                    childObjectsInfo,
                    recordSetting);
            } else if(recordSetting.dmpl__ActionType__c == 'Post GL'){
                return performActionPostGL(
                    recordSettingId, 
                    hostId,
                    childObjectsInfo,
                    recordSetting);
            } else { 
                return new CreateRelatedResult('No handler attached');
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static CreateRelatedResult releaseDocumentDirect(
        Id recordSettingId, 
        Id hostId){
            return releaseChildDocuments(
                recordSettingId,  
                hostId, 
                SourceObjectInfo.createFrom(
                    getChildObjects(
                        recordSettingId, 
                        hostId, 
                        null)));
        }

    @testVisible
    private static CreateRelatedResult queueReleaseDocument(
        Id recordSettingId, 
        Id hostId){
            return InterfaceQueueService.queueDocumentAction(
                recordSettingId,
                hostId
            );
    }


    @testVisible
    private static CreateRelatedResult queueReleaseDocument(
        Id recordSettingId, 
        Id hostId,
        List<SourceObjectInfo> childObjectsInfo){
            return InterfaceQueueService.queueDocumentAction(
                recordSettingId,
                hostId,
                childObjectsInfo
            );
    }

    @testVisible
    private static CreateRelatedResult performActionRelease(
        Id recordSettingId, 
        Id hostId,
        dmpl__CreateRelatedSetting__mdt recordSetting)
    {
        try {
            switch on recordSetting.dmpl__HostObjectId__r.QualifiedApiName {
                when  'dmpl__SaleOrder__c'{
                    if(recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__InventoryFulfillment__c'){
                        if(recordSetting.dmpl__Tag__c == 'Allocate'){
                            return FulfillmentHelper.createFulfillmentFromSaleOrderAndAllocate(hostId);
                        }else if(String.isBlank(recordSetting.dmpl__Tag__c)){
                            return FulfillmentHelper.createFulfillmentFromSaleOrder(hostId);
                        }
                    }else if(recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__SaleInvoice__c'){
                        if(recordSetting.dmpl__Tag__c == 'OTC' ){
                            return SaleInvoiceHelper.createSaleInvoiceFromSaleOrder(hostId);
                        }else if(String.isBlank(recordSetting.dmpl__Tag__c)){
                            return SaleInvoiceHelper.createSaleInvoiceFromAllocatedLines(hostId);
                        }    
                    }else if(recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__DeliveryOrder__c'){
                        if(String.isBlank(recordSetting.dmpl__Tag__c)){
                            return SaleDeliveryHelper.createSaleDeliveryFromSaleOrder(hostId);
                        }
                    }
                }
                when  'dmpl__RepairOrder__c'{
                    if(recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__InventoryFulfillment__c'){
                        if(recordSetting.dmpl__Tag__c == 'Allocate'){
                            return FulfillmentHelper.createFulfillmentFromRepairOrderAndAllocate(hostId);
                        }else if(recordSetting.dmpl__Tag__c == 'Allocate New'){
                            return FulfillmentHelper.createNewFulfillmentFromRepairOrderAndAllocate(hostId);
                        }else if(recordSetting.dmpl__Tag__c == 'New'){
                            return FulfillmentHelper.createNewFulfillmentFromRepairOrder(hostId);
                        }else if(String.isBlank(recordSetting.dmpl__Tag__c)){
                            return FulfillmentHelper.createFulfillmentFromRepairOrder(hostId);
                        }
                    }else if(recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__SaleInvoice__c'){
                        if(String.isBlank(recordSetting.dmpl__Tag__c)){
                            return SaleInvoiceHelper.createServiceInvoice(hostId);
                        }    
                    }else if(recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__Claim__c'){
                        if(String.isBlank(recordSetting.dmpl__Tag__c)){
                            //return ClaimHelper.createClaims(hostId);
                        }    
                    }else if(recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__PurchaseOrder__c'){
                        if(String.isBlank(recordSetting.dmpl__Tag__c)){
                            return PurchaseOrderHelper.createPurchaseOrderFromRepairOrder(hostId);
                        }    
                    }else if(recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__DeliveryOrder__c'){
                        if(String.isBlank(recordSetting.dmpl__Tag__c)){
                            return SaleDeliveryHelper.createSaleDeliveryFromRepairOrder(hostId);
                        }
                    }
                }
                when  'dmpl__DeliveryOrder__c'{
                    if(recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__SaleInvoice__c'
                        && String.isBlank(recordSetting.dmpl__Tag__c)){
                        return SaleInvoiceHelper.createSaleInvoiceFromDeliveryOrder(hostId);
                    }
                }
                when  'dmpl__SaleInvoice__c'{
                    if(recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__SaleOrder__c'
                        && String.isBlank(recordSetting.dmpl__Tag__c)){
                        return SaleInvoiceHelper.createSaleInvoiceFromSaleOrder(hostId);
                    }
                } 
                when 'dmpl__InventoryFulfillment__c'{
                    if(recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__InventoryFulfillment__c'){
                        if(String.isBlank(recordSetting.dmpl__Tag__c)){
                            return InventoryFulfillmentAllocationLineHelper.createAllocationFromFulfillment(hostId);
                        }
                    } else if(recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__DeliveryOrder__c'){
                        if(recordSetting.dmpl__Tag__c == 'Picked'){
                            return SaleDeliveryHelper.createSaleDeliveryFromPicking(hostId);
                        }else if(String.isBlank(recordSetting.dmpl__Tag__c)){
                            return SaleDeliveryHelper.createSaleDeliveryFromFulfillment(hostId);
                        }
                    } else if(recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__InventoryFulfillmentPickingLine__c'){
                        if(String.isBlank(recordSetting.dmpl__Tag__c)){
                            return InventoryFulfillmentPickingLineHelper.createPickingFromFulfillment(hostId);
                        }
                    } else if(recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__PurchaseOrder__c'){
                        if(String.isBlank(recordSetting.dmpl__Tag__c)){
                            return PurchaseOrderHelper.createPurchaseOrderFromFulfillment(hostId);
                        } 
                    }   
                }
                when 'dmpl__PurchaseReturn__c'{
                    if(recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__DeliveryOrder__c' 
                        && String.isBlank(recordSetting.dmpl__Tag__c)){
                        return SaleDeliveryHelper.createSaleDeliveryFromPurchaseReturn(hostId);
                    }
                }
                when 'dmpl__BillReturn__c'{
                    if(recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__DeliveryOrder__c'
                        && String.isBlank(recordSetting.dmpl__Tag__c)){
                        return SaleDeliveryHelper.createSaleDeliveryFromBillReturn(hostId);
                    }
                }
                when 'dmpl__GoodsReceipt__c'{
                    if(recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__GoodsReceipt__c'){
                        if(recordSetting.dmpl__Tag__c == 'Start'){
                            return GoodsReceiptHelper.createInspectionLines(hostId);
                        }else if(recordSetting.dmpl__Tag__c == 'Complete' ){
                            return GoodsReceiptHelper.completeInspection(hostId);
                        }
                    }
                }
                when 'dmpl__PurchaseRequisition__c'{
                    if(recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__PurchaseOrder__c'){
                        return PurchaseOrderHelper.createPurchaseOrderFromRequisition(hostId);
                    } else if(recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__Transfer__c'){
                        return TransferHelper.createStockTransferFromRequisition(hostId);
                    }
                }
                when  'dmpl__Transfer__c'{
                    return TransferHelper.releaseOutwardDocument(hostId);
                }
                when else {
                    if(String.isBlank(recordSetting.dmpl__CustomClassName__c)){
                        return new CreateRelatedResult('No handler attached');
                    }else{
                        return performExternalAction(
                            'performAction',
                            recordSetting.dmpl__CustomClassName__c,
                            hostId,
                            recordSettingId,
                            null);
                    }
                }
            }
            return new CreateRelatedResult('No handler attached');
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    @testVisible
    private static CreateRelatedResult performActionRelease(
        Id recordSettingId, 
        Id hostId,
        List<SourceObjectInfo> childObjectsInfo,
        dmpl__CreateRelatedSetting__mdt recordSetting)
    {
        try {
            switch on recordSetting.dmpl__HostObjectId__r.QualifiedApiName {
                when 'dmpl__SaleOrder__c'{
                    if(recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__InventoryFulfillment__c'){
                        if(recordSetting.dmpl__Tag__c == 'Allocate'){
                            return FulfillmentHelper.createFulfillmentFromSaleOrderAndAllocate(childObjectsInfo);
                        }else if(String.isBlank(recordSetting.dmpl__Tag__c)){
                            return FulfillmentHelper.createFulfillmentFromSaleOrder(childObjectsInfo);
                        }
                    } 
                    else if(recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__SaleInvoice__c'){
                        if(recordSetting.dmpl__Tag__c == 'OTC'){
                            return SaleInvoiceHelper.createSaleInvoiceFromSaleOrder(childObjectsInfo);
                        }
                        else if(String.isBlank(recordSetting.dmpl__Tag__c)){
                            return SaleInvoiceHelper.createSaleInvoiceFromAllocatedLines(childObjectsInfo);
                        }
                    } else if(recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__PurchaseOrder__c'
                        && String.isBlank(recordSetting.dmpl__Tag__c)){
                        return SaleOrderLineHelper.createSaleOrderLinesFromPurchaseOrder(childObjectsInfo, hostId);
                    } else if(recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__DeliveryOrder__c' 
                        && String.isBlank(recordSetting.dmpl__Tag__c)){
                        return SaleDeliveryHelper.createSaleDeliveryFromSaleOrder(childObjectsInfo);
                    }
                }
                when 'dmpl__RepairOrder__c'{
                    if(recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__InventoryFulfillment__c'){
                        if(recordSetting.dmpl__Tag__c == 'Allocate'){
                            return FulfillmentHelper.createFulfillmentFromRepairOrderAndAllocate(childObjectsInfo);
                        }else if(recordSetting.dmpl__Tag__c == 'Allocate New'){
                            return FulfillmentHelper.createNewFulfillmentFromRepairOrderAndAllocate(childObjectsInfo);
                        }else if(recordSetting.dmpl__Tag__c == 'New'){
                            return FulfillmentHelper.createNewFulfillmentFromRepairOrder(childObjectsInfo);
                        } else if(String.isBlank(recordSetting.dmpl__Tag__c)){
                            return FulfillmentHelper.createFulfillmentFromRepairOrder(childObjectsInfo);
                        }
                    } 
                    else if(recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__SaleInvoice__c'){
                        if(String.isBlank(recordSetting.dmpl__Tag__c)){ 
                            return SaleInvoiceHelper.createServiceInvoice(childObjectsInfo);
                        }
                    } else if(recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__Claim__c'){
                        if(String.isBlank(recordSetting.dmpl__Tag__c)){ 
                            //return ClaimHelper.createClaim(childObjectsInfo);
                        }
                    } else if(recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__PurchaseOrder__c'
                        && String.isBlank(recordSetting.dmpl__Tag__c)){
                        return PurchaseOrderHelper.createPurchaseOrderFromFulfillment(childObjectsInfo);
                    }
                }
                when 'dmpl__SaleInvoice__c'{
                    if(recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__SaleOrder__c'
                        && String.isBlank(recordSetting.dmpl__Tag__c)){
                        return SaleInvoiceHelper.createSaleInvoiceFromSaleOrder(childObjectsInfo, hostId);
                    }
                }
                when 'dmpl__InventoryFulfillment__c'{
                    if(recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__SaleOrder__c'
                        && String.isBlank(recordSetting.dmpl__Tag__c)){
                        return FulfillmentHelper.populateFulfillmentFromSaleOrder(childObjectsInfo, hostId);
                    } else if(recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__InventoryFulfillment__c'
                        && String.isBlank(recordSetting.dmpl__Tag__c)){
                        return InventoryFulfillmentAllocationLineHelper.createAllocationFromFulfillment(childObjectsInfo);
                    } else if(recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__DeliveryOrder__c'){
                        if(recordSetting.dmpl__Tag__c == 'Picked'){
                            return SaleDeliveryHelper.createSaleDeliveryFromPicking(childObjectsInfo);
                        } else if(String.isBlank(recordSetting.dmpl__Tag__c)){
                            return SaleDeliveryHelper.createSaleDeliveryFromFulfillment(childObjectsInfo);
                        }
                    } else if(recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__RepairOrder__c'
                        && String.isBlank(recordSetting.dmpl__Tag__c)){
                        return FulfillmentHelper.populateFulfillmentFromRepairOrder(childObjectsInfo, hostId);
                    } else if(recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__InventoryFulfillmentPickingLine__c'
                        && String.isBlank(recordSetting.dmpl__Tag__c)){
                        return InventoryFulfillmentPickingLineHelper.createPickingFromFulfillment(childObjectsInfo);
                    } else if(recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__PurchaseOrder__c'
                        && String.isBlank(recordSetting.dmpl__Tag__c)){
                        return PurchaseOrderHelper.createPurchaseOrderFromFulfillment(childObjectsInfo);
                    }
                }
                when  'dmpl__SaleReturn__c'{
                    if(recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__SaleInvoice__c'
                        && String.isBlank(recordSetting.dmpl__Tag__c)){
                        return SaleReturnHelper.createSaleReturnFromSaleInvoice(childObjectsInfo, hostId);
                    }
                    else if(recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__DeliveryOrder__c'
                        && String.isBlank(recordSetting.dmpl__Tag__c)){
                        return SaleReturnHelper.createSaleReturnFromDelivery(childObjectsInfo, hostId);
                    }
                }
                when 'dmpl__PurchaseReturn__c'{
                    if(recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__Bill__c'
                        && String.isBlank(recordSetting.dmpl__Tag__c)){
                        return PurchaseReturnHelper.createPurchaseReturnFromPurchaseInvoice(childObjectsInfo, hostId);
                    } else if(recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__DeliveryOrder__c'
                        && String.isBlank(recordSetting.dmpl__Tag__c)){
                        return SaleDeliveryHelper.createSaleDeliveryFromPurchaseReturn(childObjectsInfo);
                    }
                }
                when 'dmpl__BillReturn__c'{
                    if(recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__Bill__c'
                        && String.isBlank(recordSetting.dmpl__Tag__c)){
                        return BillReturnHelper.createBillReturnFromBill(childObjectsInfo, hostId);
                    } else if(recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__DeliveryOrder__c'
                        && String.isBlank(recordSetting.dmpl__Tag__c)){
                        return SaleDeliveryHelper.createSaleDeliveryFromBillReturn(childObjectsInfo);
                    }
                }
                when 'dmpl__GoodsReceipt__c'{
                    if(recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__GoodsReceipt__c'
                        && String.isBlank(recordSetting.dmpl__Tag__c)){
                        return GoodsReceiptHelper.createInspectionLines(childObjectsInfo);
                    }
                }
                when 'dmpl__DeliveryOrder__c'{
                    if(recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__SaleOrder__c'
                        && String.isBlank(recordSetting.dmpl__Tag__c)){
                        return SaleDeliveryHelper.createSaleDeliveryFromSaleOrder(hostId, childObjectsInfo);
                    }else if(recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__SaleInvoice__c'
                        && String.isBlank(recordSetting.dmpl__Tag__c)){
                        return SaleInvoiceHelper.createSaleInvoiceFromDeliveryOrder(childObjectsInfo);
                    }
                }
                when 'dmpl__PurchaseRequisition__c'{
                    if(recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__PurchaseOrder__c'){
                        return PurchaseOrderHelper.createPurchaseOrderFromRequisition(childObjectsInfo);
                    } else if(recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__Transfer__c'){
                        return TransferHelper.createStockTransferFromRequisition(childObjectsInfo);
                    }
                }
                when 'dmpl__PurchaseOrder__c'{
                    if(recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__PurchaseRequisition__c'){
                        return PurchaseOrderHelper.createPurchaseOrderFromRequisition(childObjectsInfo, hostId);
                    }
                }
                when  'dmpl__Transfer__c'{
                    return TransferHelper.releaseOutwardDocument(childObjectsInfo, hostId);
                }
                when else {
                    if(String.isBlank(recordSetting.dmpl__CustomClassName__c)){
                        return new CreateRelatedResult('No handler attached');
                    }else{
                        return performExternalAction(
                            'performAction',
                            recordSetting.dmpl__CustomClassName__c,
                            hostId,
                            recordSettingId,
                            childObjectsInfo);
                    }
                }
            }
            return new CreateRelatedResult('No handler attached');
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    private static CreateRelatedResult performActionCancel(
        Id recordSettingId, 
        Id hostId,
        dmpl__CreateRelatedSetting__mdt recordSetting)
    {
        try {
            switch on recordSetting.dmpl__HostObjectId__r.QualifiedApiName {
                when 'dmpl__SaleOrder__c'{
                    return SaleOrderLineHelper.cancelSaleOrderLines(hostId);
                }
                when 'dmpl__Shipment__c'{
                    return ShipmentLineHelper.cancelShipmentLines(hostId);
                }
                when 'dmpl__InventoryFulfillment__c'{
                    return FulfillmentHelper.cancelAllocation(hostId);
                }
                when else {
                    return performExternalAction(
                        'performAction',
                        recordSetting.dmpl__CustomClassName__c,
                        hostId,
                        recordSettingId,
                        null);
                }
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    private static CreateRelatedResult performActionCancel(
        Id recordSettingId, 
        Id hostId,
        List<SourceObjectInfo> childObjectsInfo,
        dmpl__CreateRelatedSetting__mdt recordSetting)
    {
        try {
            switch on recordSetting.dmpl__HostObjectId__r.QualifiedApiName {
                when 'dmpl__SaleOrder__c'{
                    return SaleOrderLineHelper.cancelSaleOrderLines(
                        childObjectsInfo, 
                        hostId);
                }
                when 'dmpl__Shipment__c'{
                    return ShipmentLineHelper.cancelShipmentLines(
                        childObjectsInfo, 
                        hostId);
                }
                when 'dmpl__InventoryFulfillment__c'{
                    return FulfillmentHelper.cancelAllocation(
                        childObjectsInfo);
                }
                when else {
                    return new CreateRelatedResult('No handler attached');
                }
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    private static CreateRelatedResult performActionConfirm(
        Id recordSettingId, 
        Id hostId,
        dmpl__CreateRelatedSetting__mdt recordSetting)
    {
        try {
            switch on recordSetting.dmpl__HostObjectId__r.QualifiedApiName {
                when  'dmpl__InventoryFulfillment__c'{
                    return InventoryFulfillmentPickingLineHelper.confirmPickingFromFulfillment(hostId);
                }
                when  'dmpl__Transfer__c'{
                    return TransferHelper.receiveInwardDocument(hostId);
                }
                when else {
                    return performExternalAction(
                        'performAction',
                        recordSetting.dmpl__CustomClassName__c,
                        hostId,
                        recordSettingId,
                        null);
                }
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }
    

    private static CreateRelatedResult performActionConfirm(
        Id recordSettingId, 
        Id hostId,
        List<SourceObjectInfo> childObjectsInfo,
        dmpl__CreateRelatedSetting__mdt recordSetting)
    {
        try {
            switch on recordSetting.dmpl__HostObjectId__r.QualifiedApiName {
                when 'dmpl__InventoryFulfillment__c'{
                    if(recordSetting.dmpl__ActionType__c == 'Confirm'){
                        return InventoryFulfillmentPickingLineHelper.confirmPickingFromFulfillment(childObjectsInfo, hostId);
                    }
                }
                when  'dmpl__Transfer__c'{
                    return TransferHelper.receiveInwardDocument(childObjectsInfo, hostId);
                }
                when else {
                    return performExternalAction(
                        'performAction',
                        recordSetting.dmpl__CustomClassName__c,
                        hostId,
                        recordSettingId,
                        childObjectsInfo);
                }
            }
            return new CreateRelatedResult('No handler attached');
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    private static CreateRelatedResult performActionPostIL(
        Id recordSettingId, 
        Id hostId,
        dmpl__CreateRelatedSetting__mdt recordSetting)
    {
        try {
            switch on recordSetting.dmpl__HostObjectId__r.QualifiedApiName {
                when  'dmpl__DeliveryOrder__c'{
                    return SaleDeliveryHelper.PostIL(hostId);
                }
                when  'dmpl__InventoryAdjustment__c'{
                    return InventoryAdjustmentHelper.PostIL(hostId);
                }
                when  'dmpl__Transfer__c'{
                    if (recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__TransferLine__c') {
                        return TransferHelper.PostIL(hostId);
                    } else if (recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__TransferInwardLine__c') {
                        return TransferHelper.postInwardDocument(hostId);
                    }
                }
                when  'dmpl__SaleReturn__c'{
                    return SaleReturnHelper.PostIL(hostId);
                }
                when  'dmpl__GoodsReceipt__c'{
                    return GoodsReceiptHelper.PostIL(hostId);
                }
                when  'dmpl__Shipment__c'{
                    return ShipmentHelper.PostIL(hostId);
                }
                when  'dmpl__BillReturn__c'{
                    return BillReturnHelper.PostIL(hostId);
                }
                when else {
                    return performExternalAction(
                        'performAction',
                        recordSetting.dmpl__CustomClassName__c,
                        hostId,
                        recordSettingId,
                        null);
                }
            }
            return new CreateRelatedResult('No handler attached');
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    private static CreateRelatedResult performActionPostIL(
        Id recordSettingId, 
        Id hostId,
        List<SourceObjectInfo> childObjectsInfo,
        dmpl__CreateRelatedSetting__mdt recordSetting)
    {
        try {
            switch on recordSetting.dmpl__HostObjectId__r.QualifiedApiName {
                when 'dmpl__DeliveryOrder__c'{
                    if(recordSetting.dmpl__ActionType__c == 'Post IL'){
                        return SaleDeliveryHelper.PostIL(childObjectsInfo, hostId);
                    }
                }
                when 'dmpl__SaleReturn__c'{
                    if(recordSetting.dmpl__ActionType__c == 'Post IL'){
                        return SaleReturnHelper.PostIL(childObjectsInfo, hostId);
                    }
                }
                when 'dmpl__InventoryAdjustment__c'{
                    if(recordSetting.dmpl__ActionType__c == 'Post IL'){
                        return InventoryAdjustmentHelper.PostIL(childObjectsInfo, hostId);
                    }
                }
                when  'dmpl__Transfer__c'{
                    if(recordSetting.dmpl__ActionType__c == 'Post IL'){
                        if (recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__TransferLine__c') {
                            return TransferHelper.PostIL(childObjectsInfo, hostId);
                        } else if (recordSetting.dmpl__RelatedObjectId__r.QualifiedApiName == 'dmpl__TransferInwardLine__c') {
                            return TransferHelper.postInwardDocument(childObjectsInfo, hostId);
                        }
                    }
                }
                when 'dmpl__GoodsReceipt__c'{
                    if(recordSetting.dmpl__ActionType__c == 'Post IL'){
                        return GoodsReceiptHelper.PostIL(childObjectsInfo, hostId);
                    }
                }
                when 'dmpl__Shipment__c'{
                    if(recordSetting.dmpl__ActionType__c == 'Post IL'){
                        return ShipmentHelper.PostIL(childObjectsInfo, hostId);
                    }
                }
                when 'dmpl__BillReturn__c'{
                    if(recordSetting.dmpl__ActionType__c == 'Post IL'){
                        return BillReturnHelper.PostIL(childObjectsInfo, hostId);
                    }
                }
                when else {
                    return performExternalAction(
                        'performAction',
                        recordSetting.dmpl__CustomClassName__c,
                        hostId,
                        recordSettingId,
                        childObjectsInfo);
                }
            }
            return new CreateRelatedResult('No handler attached');
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    private static CreateRelatedResult performActionPostGL(
        Id recordSettingId, 
        Id hostId,
        dmpl__CreateRelatedSetting__mdt recordSetting)
    {
        try {
            switch on recordSetting.dmpl__HostObjectId__r.QualifiedApiName {
                when  'dmpl__SaleInvoice__c'{
                    return SaleInvoiceHelper.PostGL(hostId);
                }
                when  'dmpl__RepairOrder__c'{
                        return RepairOrderHelper.createServiceInvoice(hostId);
                }
                when else {
                    return performExternalAction(
                        'performAction',
                        recordSetting.dmpl__CustomClassName__c,
                        hostId,
                        recordSettingId,
                        null);
                }
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    private static CreateRelatedResult performActionPostGL(
        Id recordSettingId, 
        Id hostId,
        List<SourceObjectInfo> childObjectsInfo,
        dmpl__CreateRelatedSetting__mdt recordSetting)
    {
        try {
            switch on recordSetting.dmpl__HostObjectId__r.QualifiedApiName {
                when 'dmpl__SaleInvoice__c'{
                    if(recordSetting.dmpl__ActionType__c == 'Post GL'){
                        return SaleInvoiceHelper.PostGL(childObjectsInfo, hostId);
                    }
                }
                when  'dmpl__RepairOrder__c'{
                    return RepairOrderHelper.createServiceInvoice(childObjectsInfo, hostId);
                }
                when else {
                    return performExternalAction(
                        'performAction',
                        recordSetting.dmpl__CustomClassName__c,
                        hostId,
                        recordSettingId,
                        childObjectsInfo);
                }
            }
            return new CreateRelatedResult('No handler attached');
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    private static CreateRelatedResult performActionReturn(
        Id recordSettingId, 
        Id hostId,
        dmpl__CreateRelatedSetting__mdt recordSetting)
    {
        try {
            switch on recordSetting.dmpl__HostObjectId__r.QualifiedApiName {
                when  'dmpl__InventoryFulfillment__c'{
                    return FulfillmentHelper.cancelPicking(hostId);
                }
                when else {
                    return performExternalAction(
                        'performAction',
                        recordSetting.dmpl__CustomClassName__c,
                        hostId,
                        recordSettingId,
                        null);
                }
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    private static CreateRelatedResult performActionReturn(
        Id recordSettingId, 
        Id hostId,
        List<SourceObjectInfo> childObjectsInfo,
        dmpl__CreateRelatedSetting__mdt recordSetting)
    {
        try {
            switch on recordSetting.dmpl__HostObjectId__r.QualifiedApiName {
                when 'dmpl__InventoryFulfillment__c'{
                    if(recordSetting.dmpl__ActionType__c == 'Return'){
                        return FulfillmentHelper.cancelPicking(childObjectsInfo);
                    }
                }
                when else {
                    return performExternalAction(
                        'performAction',
                        recordSetting.dmpl__CustomClassName__c,
                        hostId,
                        recordSettingId,
                        childObjectsInfo);
                }
            }
            return new CreateRelatedResult('No handler attached');
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    @testVisible
    private static CreateRelatedResult performExternalAction(
        String actionName,
        String className, 
        Id recordSettingId,
        Id hostId,
        List<SourceObjectInfo> childObjectsInfo){
    try
        {
            if(String.isBlank(actionName)){
                actionName = 'performAction';
            }
            if(String.isBlank(className)){
                throw new CalloutException(
                    'Type Class Name not found!. Please ensure that the controller class named is valid');
            }
            System.Type typeName = Type.forName(className);
            if(typeName == null){
                throw new CalloutException(
                    'Type not found!. Please ensure that the controller class named is valid');
            }
            
            Object dynamicObject =  typeName.newInstance();
            if(dynamicObject == null){
                throw new CalloutException(
                    'Failed to create Dynamic Controller!. Please ensure that the controller class named \"' 
                    + className 
                    + '\" is creatable.');
            }

            Callable callable =  (Callable)dynamicObject;
            if(callable == null){
                throw new CalloutException(
                    'Callable Type Cast Failed!. Please ensure that the controller class named \"' 
                    + className 
                    + '\" implements Callable Interface.');
            }

            if(childObjectsInfo == null){
                return (CreateRelatedResult)callable.call(
                    actionName,
                    new Map<String, Object> {
                        'recordSettingId' => recordSettingId, 
                        'hostId' => hostId
                    });
            } else {
                return (CreateRelatedResult)callable.call(
                    actionName,
                    new Map<String, Object> {
                        'hostId' => hostId,
                        'recordSettingId' => recordSettingId, 
                        'childObjectsInfo' => childObjectsInfo
                    });
            }
        }
        catch(Exception e)
        {
            ExceptionLogHelper.logException(e);
            throw e;
        }
    }
}