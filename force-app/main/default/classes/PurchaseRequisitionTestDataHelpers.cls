@isTest
public class PurchaseRequisitionTestDataHelpers {

    public static dmpl__PurchaseRequisition__c CreateRequistion(
        Account partnerAccount,
        dmpl__Branch__c branch
    ) {
        return (dmpl__PurchaseRequisition__c)TestFactory.createSObject(
            new dmpl__PurchaseRequisition__c(
                dmpl__PartnerAccountId__c = partnerAccount.Id,
                dmpl__BranchId__c = branch.Id,
                dmpl__DocumentDate__c = date.today(),
                dmpl__Status__c = 'Draft',
                dmpl__Remarks__c = 'Test-Remarks'
            ),
            'PurchaseRequisitionDefaults',
            true
        );
    }
    public static dmpl__PurchaseRequisition__c CreateRequistion(
        Account partnerAccount,
        dmpl__Branch__c branch,
        Account supplierAccount,
        Id requestedByUserId
    ) {
        return (dmpl__PurchaseRequisition__c)TestFactory.createSObject(
            new dmpl__PurchaseRequisition__c(
                dmpl__PartnerAccountId__c = partnerAccount.Id,
                dmpl__BranchId__c = branch.Id,
                dmpl__SupplierAccountId__c = supplierAccount?.Id,
                dmpl__RequestedById__c = requestedByUserId==null? null : requestedByUserId
            ),
            true
        );
    }

    public static dmpl__PurchaseRequisition__c getRequisition(dmpl__PurchaseRequisition__c purchaseRequisition){
        return [SELECT 
            Id, 
            Name,
            dmpl__Status__c,
            dmpl__DocumentDate__c,
            dmpl__RequestedById__c,
            dmpl__PartnerAccountId__c,
            dmpl__BranchId__c,
            dmpl__SupplierAccountId__c from dmpl__PurchaseRequisition__c 
            WHERE Id = :purchaseRequisition.Id limit 1
        ];
    }

    public static dmpl__PurchaseRequisitionLine__c CreateRequistionLine(
        dmpl__PurchaseRequisition__c purchaseRequisition,
        dmpl__Item__c item,
        dmpl__SKU__c sku
    ) {
        return (dmpl__PurchaseRequisitionLine__c)TestFactory.createSObject(
            new dmpl__PurchaseRequisitionLine__c(
                dmpl__PurchaseRequisitionId__c = purchaseRequisition.Id,
                dmpl__ItemId__c = item.Id,
                dmpl__SKUId__c = sku.Id,
                dmpl__Quantity__c = 1
            ),
            'PurchaseRequisitionLineDefaults',
            true
        );
    }

    public static dmpl__PurchaseRequisition__c getRequisition(){
        return [SELECT 
        Id, 
        Name,
        dmpl__Status__c,
        dmpl__PerformReleaseOrder__c,
        dmpl__IsOrderReleased__c,
        (SELECT 
        Id,
        Name,
        dmpl__Quantity__c 
        FROM dmpl__PurchaseRequisitionLines__r)
        FROM dmpl__PurchaseRequisition__c LIMIT 1];
    }

    public static dmpl__PurchaseRequisitionLine__c getRequisitionLine(){
        return [SELECT 
        id, 
        name,
        dmpl__Quantity__c
        FROM dmpl__PurchaseRequisitionLine__c LIMIT 1];
    }
}