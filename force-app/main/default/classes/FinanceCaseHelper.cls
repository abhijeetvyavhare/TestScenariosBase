public with sharing class FinanceCaseHelper {

    private static Boolean skipValidations = false;

    private static final string OBJECT_FINANCECASE = 'dmpl__FinanceCase__c';
    private static final string FIELD_FINANCECASE_SALEORDERID = 'dmpl__SaleOrderId__c';
    private static final string FIELD_FINANCECASE_SALEINVOICEID = 'dmpl__SaleInvoiceId__c';
    private static final string FIELD_FINANCECASE_BRANCHID = 'dmpl__BranchId__c';
    private static final string FIELD_FINANCECASE_PARTNERACCOUNTID = 'dmpl__PartnerAccountId__c';
    private static final string FIELD_FINANCECASE_STATUS = 'dmpl__Status__c';
    private static final string FIELD_FINANCECASE_DISBURSEDAMOUNT = 'dmpl__DisbursedAmount__c';
    private static final string FIELD_SALEINVOICE_SALEORDERID = 'dmpl__SaleOrderId__c';
    

    private static final List<String> LIST_NON_EDITABLE_FIELDS = new List<String>{FIELD_FINANCECASE_SALEORDERID,FIELD_FINANCECASE_SALEINVOICEID,FIELD_FINANCECASE_BRANCHID,FIELD_FINANCECASE_PARTNERACCOUNTID};

    public static void validateData(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__FinanceCase__c> oldEntries, List<dmpl__FinanceCase__c> newEntries)
    {
        try{
            if(isInsert){
                FieldMappingHelper.copyFieldMappingData(
                    newEntries);
            }
        if(skipValidations){
            return;
        }

        DocumentStatusDFSHelper dfsHelper = new DocumentStatusDFSHelper();
        if(isInsert){
            ValidationHelper.validatePartnerAndBranch(FIELD_FINANCECASE_PARTNERACCOUNTID, FIELD_FINANCECASE_BRANCHID, newEntries);
            StatusHelper.validateStatusNew(OBJECT_FINANCECASE, FIELD_FINANCECASE_STATUS, newEntries);
        }else if(isUpdate){
            StatusHelper.validateStatusEdit(OBJECT_FINANCECASE, FIELD_FINANCECASE_STATUS, oldEntries, newEntries);
            DocumentHelper.validateChangeInKeyFields(LIST_NON_EDITABLE_FIELDS, oldEntries, newEntries);
            dfsHelper.DocumentStatusRestrictEdits_Edit(OBJECT_FINANCECASE, FIELD_FINANCECASE_STATUS, oldEntries, newEntries);
            dfsHelper.DocumentStatusRestrictFieldsEdits(OBJECT_FINANCECASE, FIELD_FINANCECASE_STATUS, oldEntries, newEntries);
        }else if(isDelete){
            dfsHelper.DocumentStatusRestrictEdits_Delete(OBJECT_FINANCECASE, FIELD_FINANCECASE_STATUS, oldEntries);
        }
    } catch (Exception error) {
        ExceptionLogHelper.logException(error);
        throw error;
    }
    }

    public static void afterPostData(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__FinanceCase__c> oldEntries, List<dmpl__FinanceCase__c> newEntries)
    {
        try{
        if(isInsert){
            SaleOrderHelper.updateFinanceAmount(DocumentHelper.extractIds(newEntries,FIELD_FINANCECASE_SALEORDERID));
            SaleInvoiceHelper.updateFinanceAmount(DocumentHelper.extractIds(newEntries, FIELD_FINANCECASE_SALEINVOICEID));
        }else if(isUpdate){
            List<Id> modifiedObjects = DocumentHelper.getModifiedNewObjectIds(FIELD_FINANCECASE_DISBURSEDAMOUNT, FIELD_FINANCECASE_SALEORDERID, oldEntries, newEntries);
            if(modifiedObjects.size()>0){
                SaleOrderHelper.updateFinanceAmount(modifiedObjects);
            }
            modifiedObjects = DocumentHelper.getModifiedNewObjectIds(FIELD_FINANCECASE_DISBURSEDAMOUNT, FIELD_FINANCECASE_SALEINVOICEID, oldEntries, newEntries);
            if(modifiedObjects.size()>0){
                SaleInvoiceHelper.updateFinanceAmount(modifiedObjects);
            }
        }
        else{
            SaleOrderHelper.updateFinanceAmount(DocumentHelper.extractIds(oldEntries,FIELD_FINANCECASE_SALEORDERID));
            SaleInvoiceHelper.updateFinanceAmount(DocumentHelper.extractIds(oldEntries, FIELD_FINANCECASE_SALEINVOICEID));
        }
    } catch (Exception error) {
        ExceptionLogHelper.logException(error);
        throw error;
    }
    }

    public static void updateFinanceCaseTaggingToInvoice(List<dmpl__SaleInvoice__c> saleInvoices)
    {
        try{
            skipValidations = true;
            List<dmpl__FinanceCase__c> financeLines = queryFinanceCasesForSaleOrders(DocumentHelper.extractIds(saleInvoices,FIELD_SALEINVOICE_SALEORDERID));
            for(dmpl__FinanceCase__c financeCase : financeLines){
                dmpl__SaleInvoice__c saleInvoice = getSaleInvoce(saleInvoices, financeCase.dmpl__SaleOrderId__c);
                if(saleInvoice != null && financeCase.dmpl__SaleInvoiceId__c == null){
                    financeCase.dmpl__SaleInvoiceId__c = saleInvoice.Id;
                }
            }
            if(financeLines.size() > 0){
                SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__SaleOrderId__c','dmpl__SaleInvoiceId__c'}, 'dmpl__FinanceCase__c');
                update financeLines;
            }
        }finally{
            skipValidations = false;
        }
    }

    private static dmpl__SaleInvoice__c getSaleInvoce(List<dmpl__SaleInvoice__c> saleInvoices, Id saleOrderId){
        for(dmpl__SaleInvoice__c saleInvoice : saleInvoices){
            if(saleInvoice.dmpl__SaleOrderId__c == saleOrderId){
                return saleInvoice;
            }
        }
        return null;
    }

    private static List<dmpl__FinanceCase__c> queryFinanceCasesForSaleOrders(List<ID> saleOrderIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__SaleOrderId__c','dmpl__SaleInvoiceId__c'}, 'dmpl__FinanceCase__c');
        return [SELECT Id,
            Name,
            dmpl__SaleOrderId__c,
            dmpl__SaleInvoiceId__c
        FROM dmpl__FinanceCase__c 
        WHERE dmpl__SaleOrderId__c IN : saleOrderIds];
    }
}