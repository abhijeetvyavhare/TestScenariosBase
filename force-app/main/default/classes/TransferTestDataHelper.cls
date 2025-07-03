@isTest
public with sharing class TransferTestDataHelper {
    public static dmpl__Transfer__c createTransfer(Account partnerAccount,dmpl__Branch__c branch) {
        return (dmpl__Transfer__c) TestFactory.createSObject(
            new dmpl__Transfer__c(
                dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                dmpl__BranchId__c = branch.Id,
                dmpl__ToBranchId__c = branch.Id,
                dmpl__PerformInwardPosting__c = false,
                dmpl__PerformInwardReceive__c = false,
                dmpl__TransferTime__c = Date.today()  
            ),
            'TransferDefaults',
            true
        );
    }

    public static dmpl__Transfer__c createTransfer(Account partnerAccount,dmpl__Branch__c fromBranch,dmpl__Branch__c toBranch) {
        return (dmpl__Transfer__c) TestFactory.createSObject(
            new dmpl__Transfer__c(
                dmpl__PartnerAccountId__c = partnerAccount.Id,
                dmpl__BranchId__c = fromBranch.Id,
                dmpl__ToBranchId__c = toBranch.Id,
                dmpl__PerformInwardPosting__c = false,
                dmpl__PerformInwardReceive__c = false,
                dmpl__TransferTime__c = Date.today()  
            ),
            //'TransferDefaults',
            true
        );
    }

    public static dmpl__Transfer__c getTransfer() {
        return [
            SELECT 
				Id,
                dmpl__PartnerAccountId__c,
                dmpl__BranchId__c,
                dmpl__ToBranchId__c,
                dmpl__PerformInwardPosting__c,
                dmpl__PerformInwardReceive__c,
                dmpl__TransferTime__c 
            FROM dmpl__Transfer__c 
            LIMIT 1
        ];
        
    }

    public static dmpl__TransferInwardLine__c createTransferInwardLine(
        Id transferId,
        Id branchId,
        Id itemId,
        Integer quantity) {
        return (dmpl__TransferInwardLine__c) TestFactory.createSObject(
            new dmpl__TransferInwardLine__c(
                dmpl__TransferId__c = transferId,
                dmpl__BranchId__c = branchId,
                dmpl__ItemId__c = itemId,
                dmpl__Quantity__c = quantity
                
            ),
            'TransferInwardLineDefaults',
            true
        );
    }
    public static dmpl__TransferInwardLine__c createTransferInwardLine(
        Id transferId,
        Id outwardId,
        Id branchId,
        Id itemId,
        Integer quantity) {
        return (dmpl__TransferInwardLine__c) TestFactory.createSObject(
            new dmpl__TransferInwardLine__c(
                dmpl__TransferId__c = transferId,
                dmpl__TransferOutwardLineId__c = outwardId,
                dmpl__BranchId__c = branchId,
                dmpl__ItemId__c = itemId,
                dmpl__Quantity__c = quantity
                
            ),
            'TransferInwardLineDefaults',
            true
        );
    }

    public static dmpl__TransferInwardLine__c createTransferInwardLine(dmpl__TransferOutwardLine__c transferOutwardLine ,dmpl__Transfer__c transfer,dmpl__Branch__c branch) {
        return (dmpl__TransferInwardLine__c) TestFactory.createSObject(
            new dmpl__TransferInwardLine__c(
                dmpl__TransferId__c = transfer.Id,
                dmpl__TransferOutwardLineId__c = transferOutwardLine.Id,
                dmpl__Quantity__c = 1,
                dmpl__BranchId__c = branch.Id
                
            ),
            'TransferInwardLineDefaults',
            true
        );
    }

    public static dmpl__TransferOutwardLine__c createTransferOutwardLine(dmpl__Transfer__c transfer,dmpl__Item__c item) {
        return (dmpl__TransferOutwardLine__c) TestFactory.createSObject(
            new dmpl__TransferOutwardLine__c(
                dmpl__TransferId__c = transfer.Id,
                dmpl__ItemId__c = item.Id,
                dmpl__Quantity__c = 1,
                dmpl__UnitCost__c = 10              
            ),
            'TransferOutwardLineDefaults',
            true
        );
    }

    public static dmpl__TransferOutwardLine__c getTransferOutwardLine() {
        return [
            SELECT 
				Id,
                dmpl__TransferId__c,
                dmpl__Quantity__c,
                dmpl__UnitCost__c,
                dmpl__ItemId__c,
				dmpl__PendingInwardQuantity__c,
				dmpl__ItemLotId__c,
				dmpl__TransferType__c
            FROM dmpl__TransferOutwardLine__c 
            LIMIT 1
        ];
    }
    public static dmpl__TransferOutwardLine__c getTransferOutwardLine(Id recordId) {
        return [
            SELECT 
				Id,
                dmpl__TransferId__c,
                dmpl__Quantity__c,
                dmpl__UnitCost__c,
                dmpl__ItemId__c,
				dmpl__PendingInwardQuantity__c,
				dmpl__ItemLotId__c,
				dmpl__TransferType__c
            FROM dmpl__TransferOutwardLine__c 
			WHERE Id = :recordId
            LIMIT 1
        ];
    }

    public static dmpl__TransferInwardLine__c getTransferInwardLine() {
        return [
            SELECT 
                dmpl__TransferId__c,
                dmpl__Quantity__c,
                dmpl__TransferOutwardLineId__c,
                dmpl__BranchId__c
            FROM dmpl__TransferInwardLine__c LIMIT 1
        ];
        
    }

     public static dmpl__TransferInwardLine__c getTransferInwardLine(Id inwardId) {
        return [
            SELECT 
                dmpl__TransferId__c,
                dmpl__Quantity__c,
                dmpl__TransferOutwardLineId__c,
                dmpl__BranchId__c,
                dmpl__ItemId__c
            FROM dmpl__TransferInwardLine__c
            WHERE Id = :inwardId
            LIMIT 1
        ];
        
    }

    public static dmpl__TransferLine__c createTransferLine(dmpl__Transfer__c transfer) {
        return (dmpl__TransferLine__c) TestFactory.createSObject(
            new dmpl__TransferLine__c(
                dmpl__TransferId__c=transfer.Id,
                dmpl__Quantity__c=1
                
            ),
            'TransferLineDefaults',
            true
        );
    }

    public static dmpl__TransferLine__c getTransferLine() {
        return [
            SELECT 
                dmpl__TransferId__c,
                dmpl__Quantity__c
            FROM dmpl__TransferLine__c LIMIT 1
        ];
        
    }

	public static dmpl__TransferLine__c getTransferLine(Id id) {
        return [
            SELECT 
				Id,
				dmpl__ItemId__c,
				dmpl__ItemLotId__c,
				dmpl__TransferType__c,
				dmpl__Quantity__c,
                dmpl__TransferId__c
            FROM dmpl__TransferLine__c WHERE id = :id LIMIT 1
        ];
        
    }

	public static dmpl__TransferOutwardLine__c createTransferOutwardLine(
		Id transferId,
		Id itemId,
		Id itemLotId,
		String transferType,
		Decimal quantity
	) {
        return (dmpl__TransferOutwardLine__c) TestFactory.createSObject(
            new dmpl__TransferOutwardLine__c(
				dmpl__TransferId__c = transferId,
                dmpl__ItemId__c = itemId,
				dmpl__ItemLotId__c = itemLotId,
				dmpl__TransferType__c = transferType,
				dmpl__Quantity__c  = quantity
            ),
            true
        );
    }
    public static dmpl__TransferOutwardLine__c createTransferOutwardLine(
		Id transferId,
		Id itemId,
		Id skuId,
		Decimal quantity,
        Decimal unitCost,
        Id storageLocationId,
        Id requisitionId,
        Id requisitionLineId
	) {
        return (dmpl__TransferOutwardLine__c) TestFactory.createSObject(
            new dmpl__TransferOutwardLine__c(
				dmpl__TransferId__c = transferId,
                dmpl__ItemId__c = itemId,
				dmpl__SKUId__c = skuId,
				dmpl__Quantity__c  = quantity,
                dmpl__UnitCost__c = unitCost,
                dmpl__StorageLocationId__c = storageLocationId,
                dmpl__RequisitionId__c = requisitionId,
                dmpl__RequisitionLineId__c = requisitionLineId
            ),
            true
        );
    }

}