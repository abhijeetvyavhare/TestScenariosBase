public with sharing class FieldSalesHelper {

    private static Boolean skipValidations = false;

    private static final string OBJECT_FIELDSALES = 'dmpl__FieldSales__c';
    private static final string FIELDSALES_STATUS = 'dmpl__Status__c';
    private static final string FIELD_PERFORMRELEASELOAD = 'dmpl__PerformReleaseLoad__c';
    private static final string FIELD_PERFORMRELEASEUNLOAD = 'dmpl__PerformReleaseUnload__c';
    private static final string FIELD_PERFORMRELEASEVISITPLAN = 'dmpl__PerformReleaseVisitPlan__c';
    private static final string FIELD_PERFORMLOAD = 'Dmpl__PerformLoad__c';
    private static final string FIELD_PERFORMUNLOAD = 'Dmpl__PerformUnload__c';


    private static final List<String> LIST_FIELDS_NONEDITABLE = new List<String>{

    };
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{

    };
    private static final List<String> LIST_FIELDS_LOCKEDIFTRANSACTED = new List<String>{

    };

    private static final List<String> LIST_FIELDS_NEGATIVEANDZERONOTALLOWED = new List<String>{
  
    };
    
    private static final List<String> LIST_FIELDS_NEGATIVENOTALLOWED = new List<String>{
    };
    public static void validateData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__FieldSales__c> oldEntries, 
        List<dmpl__FieldSales__c> newEntries)
    {
        try{
            if(isInsert){
                FieldMappingHelper.copyFieldMappingData(
                    newEntries);
            }
            if(isInsert || isUpdate){   
                ValidationHelper.validatePostiveDecimal(
                    LIST_FIELDS_NEGATIVEANDZERONOTALLOWED,
                    newEntries);
                ValidationHelper.validatePostiveOrZeroDecimal(
                    LIST_FIELDS_NEGATIVENOTALLOWED,
                    newEntries);
            }
            if(skipValidations){
                return;
            }

            DocumentStatusDFSHelper dfsHelper = new DocumentStatusDFSHelper();
            if(isInsert){
                DocumentHelper.validateChangeInSystemFields(
                    LIST_FIELDS_SYSTEM, 
                    newEntries);
            }else if(isUpdate){
                DocumentHelper.validateChangeInSystemFields(
                    LIST_FIELDS_SYSTEM, 
                    oldEntries, 
                    newEntries);
                DocumentHelper.validateChangeInKeyFields(
                    LIST_FIELDS_NONEDITABLE, 
                    oldEntries, 
                    newEntries);
            }
        }catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void postData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__FieldSales__c> oldEntries, 
        List<dmpl__FieldSales__c> newEntries)
    {
        try{
            if(isUpdate){
            List<dmpl__FieldSales__c> modifiedObjects = DocumentHelper.getApprovedObjects(
                FIELD_PERFORMRELEASELOAD, oldEntries, newEntries);
                if(modifiedObjects.size()>0){
                    createTransferForLoad(modifiedObjects);
                }
                modifiedObjects = DocumentHelper.getApprovedObjects(
                    FIELD_PERFORMRELEASEUNLOAD, oldEntries, newEntries);
                    if(modifiedObjects.size()>0){
                        createTransferForUnload(modifiedObjects);
                    } 
                modifiedObjects = DocumentHelper.getApprovedObjects(
                    FIELD_PERFORMRELEASEVISITPLAN, oldEntries, newEntries);
                    if(modifiedObjects.size()>0){
                        createVisitPlan(modifiedObjects);
                    }    
                
                modifiedObjects = DocumentHelper.getApprovedObjects(
                    FIELD_PERFORMLOAD, oldEntries, newEntries);
                    if(modifiedObjects.size()>0){
                        List<Id>fieldId = CollectionHelper.extractIds(modifiedObjects,'Id'); 
                        createJob(fieldId);
                    }
                modifiedObjects = DocumentHelper.getApprovedObjects(
                    FIELD_PERFORMUNLOAD, oldEntries, newEntries);
                    if(modifiedObjects.size()>0){
                        updateCollectedAmount(modifiedObjects);
                        updateFieldSalesLine(modifiedObjects);
                    }
                   
                }
            if(isInsert){
                
            }

        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }
    public static void afterPostData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__FieldSales__c> oldEntries, 
        List<dmpl__FieldSales__c> newEntries)
    {
        //updateCollectedAmount(newEntries);

    }

    public static void createTransferForLoad(List<SourceObjectInfo> linesInfo){
        if(linesInfo == null || linesInfo.size() ==0){
            return;
        }
        TransferHelper.createTransferForLoadFromFieldSales(linesInfo);
    }

    public static void createTransferForLoad(List<dmpl__FieldSales__c> lineEntries){
        TransferHelper.createTransferForLoadFromFieldSales(lineEntries);
        SecurityHelper.ensureCanWriteField('dmpl__PerformReleaseLoad__c', 'dmpl__FieldSales__c');
        SecurityHelper.ensureCanWriteField('dmpl__IsLoadReleased__c', 'dmpl__FieldSales__c');
        for(dmpl__FieldSales__c lineEntry : lineEntries){
            lineEntry.dmpl__PerformReleaseLoad__c = false;
            lineEntry.dmpl__IsLoadReleased__c = true;
        }
    }

    public static void createTransferForUnload(List<SourceObjectInfo> linesInfo){
        if(linesInfo == null || linesInfo.size() ==0){
            return;
        }
        TransferHelper.createTransferForUnloadFromFieldSales(linesInfo);
    }

    public static void createTransferForUnload(List<dmpl__FieldSales__c> lineEntries){
        TransferHelper.createTransferForUnloadFromFieldSales(lineEntries);
        SecurityHelper.ensureCanWriteField('dmpl__PerformReleaseUnload__c', 'dmpl__FieldSales__c');
        SecurityHelper.ensureCanWriteField('dmpl__IsUnloadReleased__c', 'dmpl__FieldSales__c');
        for(dmpl__FieldSales__c lineEntry : lineEntries){
            lineEntry.dmpl__PerformReleaseUnload__c = false;
            lineEntry.dmpl__IsUnloadReleased__c = true;
        }
    }

    public static void createVisitPlan(List<SourceObjectInfo> linesInfo){
        if(linesInfo == null || linesInfo.size() ==0){
            return;
        }
        system.debug(linesInfo);
        //VisitPlanHelper.createVisitPlanFromFieldSales(linesInfo);
    }

    public static void createVisitPlan(List<dmpl__FieldSales__c> lineEntries){
        List<dmpl__FieldSalesInvoice__c>fieldSalesInvoice = queryrelatedFieldSalesInvoices(CollectionHelper.extractIds(lineEntries,'Id'));
        List<dmpl__VisitPlan__c> createdResults = VisitPlanHelper.createVisitPlanFromFieldSales(lineEntries,fieldSalesInvoice);
        SecurityHelper.ensureCanWriteField('dmpl__PerformReleaseVisitPlan__c', 'dmpl__FieldSales__c');
        SecurityHelper.ensureCanWriteField('dmpl__IsPlanReleased__c', 'dmpl__FieldSales__c');
        for(dmpl__FieldSales__c lineEntry : lineEntries){
            lineEntry.dmpl__PerformReleaseVisitPlan__c = false;
            lineEntry.dmpl__IsPlanReleased__c = true;
            lineEntry.dmpl__VisitPlanId__c =  createdResults[0].Id;
        }

    }
    private static void createJob(List<Id> fieldSaleId){
        List<dmpl__InterfaceQueue__c> newInterfaceQueues = new List<dmpl__InterfaceQueue__c>();
        for(Id fieldId : fieldSaleId)
        {
            newInterfaceQueues.add(new dmpl__InterfaceQueue__c(
                dmpl__JobType__c = 'Field Sales Invoice Processor',
                dmpl__InterfaceRecordId__c = fieldId,
                dmpl__QueueType__c = 'Queueable'
            ));
        }
        SecurityHelper.ensureCanCreateObject('dmpl__InterfaceQueue__c');
        SecurityHelper.ensureCanCreateFields(
            new string[]{
                'dmpl__JobType__c',
                'dmpl__InterfaceRecordId__c',
                'dmpl__QueueType__c'
            }, 'dmpl__InterfaceQueue__c');
        
        insert newInterfaceQueues;
    }
    
    @testVisible
    private static void updateCollectedAmount(List<dmpl__FieldSales__c>newEntries){
        List<dmpl__FieldSalesInvoice__c>fieldSaleInvoices = queryrelatedFieldSalesInvoices(CollectionHelper.extractIds(newEntries,'Id'));
        List<Id>SaleInvoiceId = CollectionHelper.extractIds(fieldSaleInvoices,'dmpl__InvoiceId__c');
        List<dmpl__SaleInvoice__c>invoice  = queryrelatedSalesInvoices(SaleInvoiceId);
        List<dmpl__FieldSalesInvoice__c> fieldSaleInvoiceToUpdate = new List<dmpl__FieldSalesInvoice__c>();
        for(dmpl__FieldSalesInvoice__c fieldSaleInvoice : fieldSaleInvoices){
           for(dmpl__SaleInvoice__c inv : invoice){
               if(inv.Id == fieldSaleInvoice.dmpl__InvoiceId__c){
                dmpl__FieldSalesInvoice__c fieldSale = new dmpl__FieldSalesInvoice__c();
                   fieldSale.dmpl__CollectedAmount__c = inv.dmpl__AdjustedAmount__c;
                   fieldSale.Id = fieldSaleInvoice.Id;
                   fieldSaleInvoiceToUpdate.add(fieldSale);
               }
           }
       
    }
    if(fieldSaleInvoiceToUpdate.size()>0){
        update fieldSaleInvoiceToUpdate;
    }
}

    @testVisible
    private static void updateFieldSalesLine(list<dmpl__FieldSales__c>newEntries){
        List<dmpl__FieldSalesInvoice__c>fieldSaleInvoices = queryrelatedFieldSalesInvoices(CollectionHelper.extractIds(newEntries,'Id'));
        List<Id>SaleInvoiceId = CollectionHelper.extractIds(fieldSaleInvoices,'dmpl__InvoiceId__c');
        List<dmpl__FieldSalesLine__c>fieldSalesLineToUpdate = new List<dmpl__FieldSalesLine__c>();
        List<AggregateResult> invoiceLines = [
            SELECT dmpl__ItemId__c,dmpl__ItemLotId__c,dmpl__SKUId__c, SUM(dmpl__Quantity__c) quantity, 
                   SUM(dmpl__GrossAmount__c) amount
            FROM dmpl__SaleInvoiceLine__c
            WHERE dmpl__SaleInvoiceId__c IN :SaleInvoiceId
            GROUP BY dmpl__ItemId__c,dmpl__ItemLotId__c,dmpl__SKUId__c
        ];

        List<dmpl__FieldSalesLine__c> fieldSalesLines = queryrelatedFieldSalesLines(CollectionHelper.extractIds(newEntries,'Id'));
        for (AggregateResult entry : invoiceLines){
            for(dmpl__FieldSalesLine__c fsl :fieldSalesLines){
                if(fsl.dmpl__ItemId__c == (Id)entry.get('dmpl__ItemId__c') 
                    && fsl.dmpl__SKUId__c == (Id)entry.get('dmpl__SKUId__c') 
                    && fsl.dmpl__ItemLotId__c == (Id)entry.get('dmpl__ItemLotId__c')){
                    dmpl__FieldSalesLine__c fieldSalesLine = new dmpl__FieldSalesLine__c();
                    fieldSalesLine.Id = fsl.Id;
                    fieldSalesLine.dmpl__SoldQuantity__c = (Double)entry.get('quantity');
                    fieldSalesLine.dmpl__ReceivedQuantity__c = (Double)entry.get('quantity');
                    fieldSalesLineToUpdate.add(fieldSalesLine);
                }
            }
        }
        if(fieldSalesLineToUpdate.size()>0){
            update fieldSalesLineToUpdate;
        }
        

    }
   
    @testVisible
    private static void createVisit(List<dmpl__FieldSales__c> newEntries){
        List<dmpl__FieldSalesInvoice__c>fieldSaleInvoices = queryrelatedFieldSalesInvoices(CollectionHelper.extractIds(newEntries,'Id'));
    
    }
  private static list<dmpl__FieldSalesInvoice__c> queryrelatedFieldSalesInvoices(
    List<Id> fieldSalesId
  ) {
    return [
      SELECT Id, dmpl__InvoiceId__c,
      dmpl__AccountId__c
      FROM dmpl__FieldSalesInvoice__c
      WHERE dmpl__FieldSalesId__c IN :fieldSalesId
    ];
  }
  private static list<dmpl__SaleInvoice__c> queryrelatedSalesInvoices(
    List<Id> SalesInvoiceId
  ) {
    return [
      SELECT Id, dmpl__AdjustedAmount__c
      FROM dmpl__SaleInvoice__c
      WHERE Id IN :SalesInvoiceId
    ];
  }
  private static list<dmpl__FieldSalesLine__c> queryrelatedFieldSalesLines(
    List<Id> fieldSalesId
  ) {
    return [
      SELECT Id,
      dmpl__SoldQuantity__c,
      dmpl__DamagedQuantity__c,
      dmpl__ReceivedQuantity__c,
      dmpl__ItemId__c,
      dmpl__ItemLotId__c,
      dmpl__SKUId__c
      FROM dmpl__FieldSalesLine__c
      WHERE dmpl__FieldSalesId__c IN :fieldSalesId
    ];
}
}