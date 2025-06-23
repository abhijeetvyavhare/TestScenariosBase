public with sharing class PaymentHelper {

    private static Boolean skipValidations = false;   

    private static final string OBJECT_PAYMENT = 'dmpl__Payment__c';
    private static final string FIELD_PAYMENT_SALEORDERID = 'dmpl__SaleOrderId__c';
    private static final string FIELD_PAYMENT_SALEINVOICEID = 'dmpl__SaleInvoiceId__c';
    private static final string FIELD_PAYMENT_BRANCHID = 'dmpl__BranchId__c';
    private static final string FIELD_PAYMENT_PARTNERACCOUNTID = 'dmpl__PartnerAccountId__c';
    private static final string FIELD_PAYMENT_ACCOUNTID = 'dmpl__AccountId__c';
    private static final string FIELD_PAYMENT_BILLID = 'dmpl__BillId__c';
    private static final string FIELD_PAYMENT_OPENAMOUNT = 'dmpl__OpenAmount__c';
    private static final string FIELD_PAYMENT_REPAIRORDERID = 'dmpl__RepairOrderId__c';
    private static final string FIELD_PAYMENT_SERVICEINVOICEID = 'dmpl__ServiceInvoiceId__c';
    private static final string FIELD_PAYMENT_STATUS = 'dmpl__Status__c';
    private static final string FIELD_PAYMENT_AMOUNT = 'dmpl__Amount__c';
    private static final string FIELD_SALEINVOICE_SALEORDERID = 'dmpl__SaleOrderId__c';

    private static final string FIELD_PAYMENT_ISGLPOSTINGAPPROVED = 'dmpl__IsGLPostingApproved__c';

    private static final List<String> LIST_NON_EDITABLE_FIELDS = new List<String>{};
    private static final List<String> LIST_FIELDS_SOURCEPOULATED = new List<String>{FIELD_PAYMENT_PARTNERACCOUNTID, FIELD_PAYMENT_BRANCHID,FIELD_PAYMENT_ACCOUNTID};
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{
        FIELD_PAYMENT_OPENAMOUNT,
        'dmpl__IsGLPosted__c',
        'dmpl__IsRelatedGLPosted__c',
        'dmpl__RelatedGeneralLedgerId__c',
        'dmpl__GeneralLedgerId__c'
    };

    public static void validateData(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__Payment__c> oldEntries, List<dmpl__Payment__c> newEntries)
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
                StatusHelper.validateStatusNew(OBJECT_PAYMENT, FIELD_PAYMENT_STATUS, newEntries);
                ValidationHelper.validatePartnerAndBranch(FIELD_PAYMENT_PARTNERACCOUNTID, FIELD_PAYMENT_BRANCHID, newEntries);
            }else if(isUpdate){
                StatusHelper.validateStatusEdit(OBJECT_PAYMENT, FIELD_PAYMENT_STATUS, oldEntries, newEntries);
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, oldEntries, newEntries);
                DocumentHelper.validateChangeInKeyFields(LIST_NON_EDITABLE_FIELDS, oldEntries, newEntries);
                DocumentHelper.validateChangeInSourcePopulatedFields(LIST_FIELDS_SOURCEPOULATED, oldEntries, newEntries, FIELD_PAYMENT_SALEORDERID);
                DocumentHelper.validateChangeInSourcePopulatedFields(LIST_FIELDS_SOURCEPOULATED, oldEntries, newEntries, FIELD_PAYMENT_SALEINVOICEID);
                DocumentHelper.validateChangeInSourcePopulatedFields(LIST_FIELDS_SOURCEPOULATED, oldEntries, newEntries, FIELD_PAYMENT_REPAIRORDERID);
                dfsHelper.DocumentStatusRestrictEdits_Edit(OBJECT_PAYMENT, FIELD_PAYMENT_STATUS, oldEntries, newEntries);
                dfsHelper.DocumentStatusRestrictFieldsEdits(OBJECT_PAYMENT, FIELD_PAYMENT_STATUS, oldEntries, newEntries);
            }else if(isDelete){
                dfsHelper.DocumentStatusRestrictEdits_Delete(OBJECT_PAYMENT, FIELD_PAYMENT_STATUS, oldEntries);
            }
            } catch (Exception error) {
                ExceptionLogHelper.logException(error);
                throw error;
            }
     }


    public static void postData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__Payment__c> oldEntries, 
        List<dmpl__Payment__c> newEntries){
        List<dmpl__Payment__c> modifiedPaymentObjects = DocumentHelper.getPostedObjects(
            FIELD_PAYMENT_ISGLPOSTINGAPPROVED, 
            oldEntries, 
            newEntries);
        if(modifiedPaymentObjects.Size() > 0){
            List<dmpl__Payment__c> paymentsTakenNew = CollectionHelper.getObjectsByFilter(modifiedPaymentObjects, 'dmpl__PaymentType__c', 'PaymentTaken');
            List<dmpl__Payment__c> paymentsTakenOld = CollectionHelper.getObjectsByFilter(oldEntries, 'dmpl__PaymentType__c', 'PaymentTaken');
            if(paymentsTakenNew.size()>0 || paymentsTakenOld.size()>0){
                GeneralLedgerHelper.createLedger(
                    GeneralLedgerTypeEnums.PaymentTaken, 
                    isInsert, 
                    isDelete, 
                    isUpdate, 
                    paymentsTakenOld, 
                    paymentsTakenNew);
                GeneralLedgerHelper.createLedger(
                    GeneralLedgerTypeEnums.PaymentTakenRelated, 
                    isInsert, 
                    isDelete, 
                    isUpdate, 
                    paymentsTakenOld, 
                    paymentsTakenNew);
            }
            List<dmpl__Payment__c> paymentsGivenNew = CollectionHelper.getObjectsByFilter(modifiedPaymentObjects, 'dmpl__PaymentType__c', 'PaymentGiven');
            List<dmpl__Payment__c> paymentsGivenOld = CollectionHelper.getObjectsByFilter(oldEntries, 'dmpl__PaymentType__c', 'PaymentGiven');
            if(paymentsGivenNew.size()>0 || paymentsGivenOld.size() >0){
                GeneralLedgerHelper.createLedger(
                    GeneralLedgerTypeEnums.PaymentGiven, 
                    isInsert, 
                    isDelete, 
                    isUpdate, 
                    paymentsGivenOld, 
                    paymentsGivenNew);
                GeneralLedgerHelper.createLedger(
                    GeneralLedgerTypeEnums.PaymentGivenRelated, 
                    isInsert, 
                    isDelete, 
                    isUpdate, 
                    paymentsGivenOld, 
                    paymentsGivenNew);
            }
        }
    }

    public static void afterPostData(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__Payment__c> oldEntries, List<dmpl__Payment__c> newEntries)
    {
        try{
            if(isInsert){
                SaleOrderHelper.updatePaidAmount(DocumentHelper.extractIds(DocumentHelper.getObjectsWithNotNull(newEntries,FIELD_PAYMENT_SALEORDERID), FIELD_PAYMENT_SALEORDERID));
                SaleInvoiceHelper.updatePaidAmount(DocumentHelper.extractIds(DocumentHelper.getObjectsWithNotNull(newEntries,FIELD_PAYMENT_SALEINVOICEID), FIELD_PAYMENT_SALEINVOICEID));
                RepairOrderHelper.updatePaidAmount(DocumentHelper.extractIds(DocumentHelper.getObjectsWithNotNull(newEntries,FIELD_PAYMENT_REPAIRORDERID), FIELD_PAYMENT_REPAIRORDERID));
            }else if(isUpdate){
                List<Id> modifiedObjects = DocumentHelper.getModifiedNewObjectIds(FIELD_PAYMENT_AMOUNT, FIELD_PAYMENT_SALEORDERID, oldEntries, DocumentHelper.getObjectsWithNotNull(newEntries,FIELD_PAYMENT_SALEORDERID));
                if(modifiedObjects.size()>0){
                    SaleOrderHelper.updatePaidAmount(modifiedObjects);
                }
                modifiedObjects = DocumentHelper.getModifiedNewObjectIds(FIELD_PAYMENT_AMOUNT, FIELD_PAYMENT_SALEINVOICEID, oldEntries, DocumentHelper.getObjectsWithNotNull(newEntries, FIELD_PAYMENT_SALEINVOICEID));
                if(modifiedObjects.size()>0){
                    SaleInvoiceHelper.updatePaidAmount(modifiedObjects);
                }
                modifiedObjects = DocumentHelper.getModifiedNewObjectIds(FIELD_PAYMENT_AMOUNT, FIELD_PAYMENT_REPAIRORDERID, oldEntries, DocumentHelper.getObjectsWithNotNull(newEntries, FIELD_PAYMENT_REPAIRORDERID));
                if(modifiedObjects.size()>0){
                    RepairOrderHelper.updatePaidAmount(modifiedObjects);
                }
            }
            else{
                SaleOrderHelper.updatePaidAmount(DocumentHelper.extractIds(DocumentHelper.getObjectsWithNotNull(oldEntries,FIELD_PAYMENT_SALEORDERID), FIELD_PAYMENT_SALEORDERID));
                SaleInvoiceHelper.updatePaidAmount(DocumentHelper.extractIds(DocumentHelper.getObjectsWithNotNull(oldEntries,FIELD_PAYMENT_SALEINVOICEID), FIELD_PAYMENT_SALEINVOICEID));
                RepairOrderHelper.updatePaidAmount(DocumentHelper.extractIds(DocumentHelper.getObjectsWithNotNull(oldEntries,FIELD_PAYMENT_REPAIRORDERID), FIELD_PAYMENT_REPAIRORDERID));
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void updatePaymentsTaggingToInvoice(List<dmpl__SaleInvoice__c> saleInvoices)
    {
        try{
            skipValidations = true;
            List<dmpl__Payment__c> payments = queryPaymentsForSaleOrders(DocumentHelper.extractIds(saleInvoices,FIELD_SALEINVOICE_SALEORDERID));
            for(dmpl__Payment__c payment : payments){
                dmpl__SaleInvoice__c saleInvoice = getSaleInvoce(saleInvoices, payment.dmpl__SaleOrderId__c);
                if(saleInvoice != null && payment.dmpl__SaleInvoiceId__c == null){
                    payment.dmpl__SaleInvoiceId__c = saleInvoice.Id;
                }
            }

            if(payments.size() > 0){
                SecurityHelper.ensureCanWriteFields(new String[]{'dmpl__SaleOrderId__c','dmpl__SaleInvoiceId__c'}, 'dmpl__Payment__c');
                update payments;
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

    private static List<dmpl__Payment__c> queryPaymentsForSaleOrders(List<ID> saleOrderIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__SaleOrderId__c','dmpl__SaleInvoiceId__c'}, 'dmpl__Payment__c');
        return [SELECT Id,
            dmpl__SaleOrderId__c,
            dmpl__SaleInvoiceId__c
        FROM dmpl__Payment__c
        WHERE dmpl__SaleOrderId__c IN : saleOrderIds];
    }

    @TestVisible
    private static List<AggregateResult> queryPaymentsForClaims(List<ID> claimIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__ClaimId__c','dmpl__Amount__c'}, 'dmpl__Payment__c');
        return [SELECT
        dmpl__ClaimId__c,
        SUM(dmpl__Amount__c) TotalAmount
        FROM dmpl__Payment__c
        Where dmpl__ClaimId__c IN : claimIds
        GROUP BY dmpl__ClaimId__c];
    }
    
    @AuraEnabled(cacheable = true)
    public static List<sObject> getGSTR1_Summary_Detail(string recordId,string type)
    {
        try
        {
            List<sObject> records = Database.query('Select Name,Id,dmpl__CentralTax__c,dmpl__Cess__c,dmpl__CountofDocuments__c,dmpl__DocumentDate__c,dmpl__GSTR1Id__c,dmpl__GSTR1TableDetails__c,dmpl__IntegratedTax__c,dmpl__InvoiceValue__c,dmpl__ReportLink__c,dmpl__StateUTTax__c,dmpl__TaxableValue__c,dmpl__Type__c,dmpl__TaxAmount__c FROM dmpl__GSTR1Summary__c where dmpl__GSTR1__r.Id=\'' + recordId + '\' and dmpl__Type__c=\'' + type + '\' ORDER BY dmpl__GSTR1TableDetails__c');
            return records;
        }
        catch(Exception e)
        {
            throw new DMPLException(e.getMessage());
        }
    }
    @AuraEnabled(cacheable = true)
    public static List<sObject> getSaleOrderTax(string recordId,string type)
    {
        try
        {
            List<sObject> records = Database.query('Select Name,Id,dmpl__CentralTax__c,dmpl__Cess__c,dmpl__IntegratedTax__c,dmpl__TaxableValue__c,dmpl__StateUTTax__c,dmpl__GST3BTableDetails__c, dmpl__PlaceofSupply__c,dmpl__GSTR3BTableSubDetails__c, dmpl__ReportLink__c FROM dmpl__GSTR3BSummary__c where dmpl__GSTR3B__r.Id=\'' + recordId + '\' and dmpl__Type__c=\'' + type + '\' ORDER BY dmpl__GST3BTableDetails__c, dmpl__GSTR3BTableSubDetails__c');
            return records;
        }
        catch(Exception e)
        {
            throw new DMPLException(e.getMessage());
        }
    }
}