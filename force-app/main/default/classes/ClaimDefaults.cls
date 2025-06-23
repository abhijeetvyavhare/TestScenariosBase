@isTest
public with sharing class ClaimDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__ApproveAll__c' => true,
            'dmpl__AsOnDate__c' => Date.today(),
            'dmpl__BillReturnId__c' => null,
            'dmpl__BranchId__c' => null,
            'dmpl__ClaimBatchId__c' => null,
            'dmpl__ClaimType__c' => 'Damaged',
            'dmpl__DocumentDate__c' => Date.today().addDays(-1),
            'dmpl__GoodsReceiptId__c' => null,
            'dmpl__InvoiceGroup__c' => 'Service',
            'dmpl__ItemServiceContractId__c' => null,
            'dmpl__PartnerAccountId__c' => null,
            'dmpl__PerformPopulateLines__c' => false,
            'dmpl__PerformReconciliation__c' => false,
            'dmpl__PurchaseReturnId__c' => null,
            'dmpl__RejectAll__c' => false,
            'dmpl__Remarks__c' => 'Test Claim',
            'dmpl__RepairOrderId__c' => null,
            'dmpl__SaleInvoiceId__c' => null,
            'dmpl__ServiceInvoiceAsOnDate__c' => Date.today(),
            'dmpl__Status__c' => 'Draft',
            'dmpl__SupplierNameId__c' => null,
            'dmpl__WorkOrderAsonDate__c' => Date.today().addDays(-5)
        };
    }
}