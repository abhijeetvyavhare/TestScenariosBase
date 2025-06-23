public with sharing class PaymentAdjustmentHelper {
    
    private static Boolean skipValidations = false;

    private static String OBJECT_BILL = 'dmpl__Bill__c';
    private static String OBJECT_PAYMENT = 'dmpl__Payment__c';
    private static String OBJECT_SALEORDER = 'dmpl__SaleOrder__c';
    private static String OBJECT_DEBITNOTE = 'dmpl__DebitNote__c';
    private static String OBJECT_CREDITNOTE = 'dmpl__CreditNote__c';
    private static String OBJECT_REPAIRORDER = 'dmpl__RepairOrder__c';
    private static String OBJECT_SALEINVOICE = 'dmpl__SaleInvoice__c';
    private static String OBJECT_PURCHASEORDER = 'dmpl__PurchaseOrder__c';
    private static String OBJECT_SERVICEREQUEST = 'dmpl__ServiceRequest__c';

    public static void validateData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__PaymentAdjustment__c> oldEntries, 
        List<dmpl__PaymentAdjustment__c> newEntries)
    {
        try {
            if(isInsert){
                FieldMappingHelper.copyFieldMappingData(
                    newEntries);
            }
            if(skipValidations){
                return;
            }
            if(isInsert){
            }
            if(isInsert || isUpdate){
                verifyValidCombination(newEntries);
            }else if(isDelete){
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
        List<dmpl__PaymentAdjustment__c> oldEntries, 
        List<dmpl__PaymentAdjustment__c> newEntries)
    { 
        try {
            if(isInsert){
                postAdjustments(
                    newEntries,
                    false);
            }else if(isUpdate){
                postAdjustments(
                    oldEntries,
                    true);
                postAdjustments(
                    newEntries,
                    false);
            }else if(isDelete){
                postAdjustments(
                    oldEntries,
                    true);
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static List<dmpl__PaymentAdjustment__c> postAdjustments(
        List<Object> documents){
            List<dmpl__PaymentAdjustment__c> insertedAdjustments = new List<dmpl__PaymentAdjustment__c>();
            for(Object document : documents){
                Map<Object,Object> documentMap = (Map<Object,Object>) document;
                insertedAdjustments.add(createPaymentAdjustment(documentMap));
            }
            insert insertedAdjustments;
            return insertedAdjustments;
        }

    public static Map<String, List<SObject>> getOpenDocuments(
        string paymentType,
        string partnerAccountId, 
        string branchId, 
        string accountId,
        Boolean onlyPayments){
            String queryFields ='';
            String whereClause = '';
            Map<String, List<SObject>> openDocuments = new Map<String, List<SObject>>();
            dmpl__DMSOrgSetting__mdt  orgSetting = OrgSettingHelper.OrgSetting();
            if(partnerAccountId == null 
                || branchId == null 
                || accountId == null)
                return new Map<String, List<SObject>>();
            
            if(paymentType == 'PaymentTaken'){
                if(!onlyPayments ){
                    if(orgSetting != null && orgSetting.dmpl__ShowInvoicesInPaymentAdjustment__c)
                    {
                    whereClause = 'dmpl__OpenAmount__c > 0 '
                    +'AND dmpl__PartnerAccountId__c =:partnerAccountId '
                    +'AND dmpl__BranchId__c =:branchId '
                    +'AND dmpl__AccountId__c =:accountId';
                    openDocuments.put(
                        OBJECT_SALEINVOICE,
                        Database.query(buildQuery(
                            new List<String>{
                                'Name',
                                'dmpl__DocumentDate__c',
                                'dmpl__AdjustedAmount__c',
                                'dmpl__OpenAmount__c',
                                'dmpl__TotalAmount__c'
                            }, 
                            OBJECT_SALEINVOICE, 
                            whereClause)));
                        }
                        
                    if(orgSetting != null && orgSetting.dmpl__ShowOrdersInPaymentAdjustment__c){
                        whereClause = 'dmpl__OpenAmount__c > 0 '
                        +'AND dmpl__PartnerAccountId__c =:partnerAccountId '
                        +'AND dmpl__BranchId__c =:branchId '
                        +'AND dmpl__AccountId__c =:accountId';
                        openDocuments.put(
                            OBJECT_SALEORDER,
                            Database.query(buildQuery(
                                new List<String>{
                                    'Name',
                                    'dmpl__DocumentDate__c',
                                    'dmpl__AdvanceAmount__c',
                                    'dmpl__OpenAmount__c',
                                    'dmpl__TotalOrderAmount__c'
                                }, 
                                OBJECT_SALEORDER, 
                                whereClause)));

                        whereClause = 'dmpl__OpenAmount__c > 0 '
                        +'AND dmpl__PartnerAccountId__c =:partnerAccountId '
                        +'AND dmpl__BranchId__c =:branchId '
                        +'AND dmpl__AccountId__c =:accountId';
                        openDocuments.put(
                            OBJECT_REPAIRORDER,
                            Database.query(buildQuery(
                                new List<String>{
                                    'Name',
                                    'dmpl__DocumentDate__c',
                                    'dmpl__AdvanceAmount__c',
                                    'dmpl__OpenAmount__c',
                                    'dmpl__TotalAmount__c'
                                }, 
                                OBJECT_REPAIRORDER, 
                                whereClause)));
                    }

                    whereClause = 'dmpl__OpenAmount__c > 0 '
                    +'AND dmpl__PartnerAccountId__c =:partnerAccountId '
                    +'AND dmpl__BranchId__c =:branchId '
                    +'AND dmpl__AccountId__c =:accountId';
                    openDocuments.put(
                        OBJECT_SERVICEREQUEST,
                        Database.query(buildQuery(
                            new List<String>{
                                'Name',
                                'dmpl__DocumentDate__c',
                                'dmpl__AdvanceAmount__c',
                                'dmpl__OpenAmount__c',
                                'dmpl__TotalAmount__c'
                            }, 
                            OBJECT_SERVICEREQUEST, 
                            whereClause)));         
                } else {
                    whereClause = 'dmpl__OpenAdvanceAmount__c > 0 '
                    +'AND dmpl__PartnerAccountId__c =:partnerAccountId '
                    +'AND dmpl__BranchId__c =:branchId '
                    +'AND dmpl__SupplierAccountId__c =:accountId';
                    openDocuments.put(
                        OBJECT_PURCHASEORDER,
                        Database.query(buildQuery(
                            new List<String>{
                                'Name',
                                'dmpl__DocumentDate__c',
                                'dmpl__AdjustedAdvanceAmount__c',
                                'dmpl__OpenAdvanceAmount__c',
                                'dmpl__TotalAmount__c'
                            }, 
                            OBJECT_PURCHASEORDER, 
                            whereClause))); 
                }
                whereClause = 'dmpl__OpenAmount__c > 0 '
                +'AND dmpl__PartnerAccountId__c =:partnerAccountId '
                +'AND dmpl__BranchId__c =:branchId '
                +'AND dmpl__AccountId__c =:accountId';
                openDocuments.put(
                    OBJECT_DEBITNOTE,
                    Database.query(buildQuery(
                        new List<String>{
                            'Name',
                            'dmpl__DocumentDate__c',
                            'dmpl__AdjustedAmount__c',
                            'dmpl__OpenAmount__c',
                            'dmpl__Amount__c'
                        }, 
                        OBJECT_DEBITNOTE, 
                        whereClause)));

                whereClause = 'dmpl__OpenAmount2__c > 0 '
                +'AND dmpl__PaymentType__c = \'PaymentGiven\' '
                +'AND dmpl__PartnerAccountId__c =:partnerAccountId '
                +'AND dmpl__BranchId__c =:branchId '
                +'AND dmpl__AccountId__c =:accountId';
                openDocuments.put(
                    OBJECT_PAYMENT,
                    Database.query(buildQuery(
                        new List<String>{
                            'Name',
                            'dmpl__PaymentDate__c',
                            'dmpl__AdjustedAmount__c',
                            'dmpl__OpenAmount2__c',
                            'dmpl__Amount__c'
                        }, 
                        OBJECT_PAYMENT, 
                        whereClause)));
            }else{ //Payment Given
                if(!onlyPayments){
                    whereClause = 'dmpl__OpenAmount__c > 0 '
                    +'AND dmpl__PartnerAccountId__c =:partnerAccountId '
                    +'AND dmpl__BranchId__c =:branchId '
                    +'AND dmpl__SupplierAccountId__c =:accountId';
                    openDocuments.put(
                        OBJECT_BILL,
                        Database.query(buildQuery(
                            new List<String>{
                                'Name',
                                'dmpl__DocumentDate__c',
                                'dmpl__AdjustedAmount__c',
                                'dmpl__OpenAmount__c',
                                'dmpl__TotalAmount__c'
                            }, 
                            OBJECT_BILL, 
                            whereClause)));

                    if(orgSetting != null && orgSetting.dmpl__ShowOrdersInPaymentAdjustment__c){
                        whereClause = 'dmpl__OpenAmount__c > 0 '
                        +'AND dmpl__PartnerAccountId__c =:partnerAccountId '
                        +'AND dmpl__BranchId__c =:branchId '
                        +'AND dmpl__SupplierAccountId__c =:accountId';
                        openDocuments.put(
                            OBJECT_PURCHASEORDER,
                            Database.query(buildQuery(
                                new List<String>{
                                    'Name',
                                    'dmpl__DocumentDate__c',
                                    'dmpl__AdvanceAmount__c',
                                    'dmpl__OpenAmount__c',
                                    'dmpl__TotalAmount__c'
                                }, 
                                OBJECT_PURCHASEORDER, 
                                whereClause)));
                    }
                }else {
                    whereClause = 'dmpl__OpenAdvanceAmount__c > 0 '
                    +'AND dmpl__PartnerAccountId__c =:partnerAccountId '
                    +'AND dmpl__BranchId__c =: branchId '
                    +'AND dmpl__AccountId__c =: accountId';
                    openDocuments.put(
                        OBJECT_SALEORDER,
                        Database.query(buildQuery(
                            new List<String>{
                                'Name',
                                'dmpl__DocumentDate__c',
                                'dmpl__AdjustedAdvanceAmount__c',
                                'dmpl__OpenAdvanceAmount__c',
                                'dmpl__TotalOrderAmount__c'
                            }, 
                            OBJECT_SALEORDER, 
                            whereClause)));
                }
                whereClause = 'dmpl__OpenAmount2__c > 0 '
                +'AND dmpl__PaymentType__c = \'PaymentTaken\' '
                +'AND dmpl__PartnerAccountId__c =:partnerAccountId '
                +'AND dmpl__BranchId__c =: branchId '
                +'AND dmpl__AccountId__c =: accountId';
                openDocuments.put(
                    OBJECT_PAYMENT,
                    Database.query(buildQuery(
                        new List<String>{
                            'Name',
                            'dmpl__PaymentDate__c',
                            'dmpl__AdjustedAmount__c',
                            'dmpl__OpenAmount2__c',
                            'dmpl__Amount__c'
                        }, 
                        OBJECT_PAYMENT, 
                        whereClause)));

                whereClause = 'dmpl__OpenAmount__c > 0 '
                +'AND dmpl__PartnerAccountId__c =:partnerAccountId '
                +'AND dmpl__BranchId__c =: branchId '
                +'AND dmpl__AccountId__c =: accountId';
                openDocuments.put(
                    OBJECT_CREDITNOTE,
                    Database.query(buildQuery(
                        new List<String>{
                            'Name',
                            'dmpl__DocumentDate__c',
                            'dmpl__AdjustedAmount__c',
                            'dmpl__OpenAmount__c',
                            'dmpl__Amount__c'
                        }, 
                        OBJECT_CREDITNOTE, 
                        whereClause)));
            }
        return openDocuments;
    }

    public static Map<String, List<SObject>> getOpenDocuments(
        string paymentType,
        string partnerAccountId, 
        string branchId, 
        string accountId,
        string searchKey,
        Boolean onlyPayments){
        String searchKeyStripped = searchKey.replaceAll('[^0-9]', '');
        if(String.isBlank(searchKeyStripped)){
            return getOpenDocuments(
                paymentType,
                partnerAccountId,
                branchId,
                accountId,
                onlyPayments);
        }
        Integer searchKeyNumberic = Integer.valueOf(searchKeyStripped);
        Map<String, List<SObject>> openDocuments = new Map<String, List<SObject>>();
        if(partnerAccountId == null 
            || branchId == null 
            || accountId == null)
            return new Map<String, List<SObject>>();
            String queryFields = '';
            String whereClause = '';
            String soqlQuery = '';
        if(paymentType == 'PaymentTaken'){
            if(!onlyPayments){
                whereClause = 'dmpl__OpenAmount__c > 0 '
                +'AND dmpl__PartnerAccountId__c =:partnerAccountId '
                +'AND dmpl__BranchId__c =:branchId '
                +'AND dmpl__AccountId__c =:accountId '
                +'AND (Name Like \'%' +searchKey+ '%\' '
                +'OR dmpl__TotalAmount__c =:searchKeyNumberic '
                +'OR dmpl__OpenAmount__c = :searchKeyNumberic '
                +'OR DAY_IN_MONTH(dmpl__DocumentDate__c) =:searchKeyNumberic '
                +'OR dmpl__OpenAmount__c =:searchKeyNumberic)';
                openDocuments.put(
                    OBJECT_SALEINVOICE,
                    Database.query(buildQuery(
                        new List<String>{
                            'Name',
                            'dmpl__DocumentDate__c',
                            'dmpl__AdjustedAmount__c',
                            'dmpl__OpenAmount__c',
                            'dmpl__TotalAmount__c'
                        }, 
                        OBJECT_SALEINVOICE, 
                        whereClause)));

                whereClause = 'dmpl__OpenAmount__c > 0 '
                +'AND dmpl__PartnerAccountId__c =:partnerAccountId '
                +'AND dmpl__BranchId__c =:branchId '
                +'AND dmpl__AccountId__c =:accountId '
                +'AND (Name Like \'%' +searchKey+ '%\' '
                +'OR dmpl__TotalOrderAmount__c =:searchKeyNumberic '
                +'OR dmpl__OpenAmount__c = :searchKeyNumberic '
                +'OR DAY_IN_MONTH(dmpl__DocumentDate__c) =:searchKeyNumberic '
                +'OR dmpl__OpenAmount__c =:searchKeyNumberic)';
                openDocuments.put(
                    OBJECT_SALEORDER,
                    Database.query(buildQuery(
                        new List<String>{
                            'Name',
                            'dmpl__DocumentDate__c',
                            'dmpl__AdvanceAmount__c',
                            'dmpl__OpenAmount__c',
                            'dmpl__TotalOrderAmount__c'
                        }, 
                        OBJECT_SALEORDER, 
                        whereClause)));

                whereClause = 'dmpl__OpenAmount__c > 0 '
                +'AND dmpl__PartnerAccountId__c =:partnerAccountId '
                +'AND dmpl__BranchId__c =:branchId '
                +'AND dmpl__AccountId__c =:accountId '
                +'AND (Name Like \'%' +searchKey+ '%\' '
                +'OR dmpl__TotalAmount__c =:searchKeyNumberic '
                +'OR dmpl__OpenAmount__c = :searchKeyNumberic '
                +'OR DAY_IN_MONTH(dmpl__DocumentDate__c) =:searchKeyNumberic '
                +'OR dmpl__OpenAmount__c =:searchKeyNumberic)';
                openDocuments.put(
                    OBJECT_REPAIRORDER,
                    Database.query(buildQuery(
                        new List<String>{
                            'Name',
                            'dmpl__DocumentDate__c',
                            'dmpl__AdvanceAmount__c',
                            'dmpl__OpenAmount__c',
                            'dmpl__TotalAmount__c'
                        }, 
                        OBJECT_REPAIRORDER, 
                        whereClause)));
            }
            whereClause = 'dmpl__OpenAmount__c > 0 '
            +'AND dmpl__PartnerAccountId__c =:partnerAccountId '
            +'AND dmpl__BranchId__c =:branchId '
            +'AND dmpl__AccountId__c =:accountId '
            +'AND  (Name Like \'%' +searchKey+ '%\' '
            +'OR dmpl__Amount__c =:searchKeyNumberic '
            +'OR dmpl__OpenAmount__c = :searchKeyNumberic '
            +'OR DAY_IN_MONTH(dmpl__DocumentDate__c) =:searchKeyNumberic '
            +'OR dmpl__OpenAmount__c =:searchKeyNumberic)';
            openDocuments.put(
                OBJECT_DEBITNOTE,
                Database.query(buildQuery(
                    new List<String>{
                        'Name',
                        'dmpl__DocumentDate__c',
                        'dmpl__AdjustedAmount__c',
                        'dmpl__OpenAmount__c',
                        'dmpl__Amount__c'
                    }, 
                    OBJECT_DEBITNOTE, 
                    whereClause)));

            whereClause = 'dmpl__OpenAmount2__c > 0 '
            +'AND dmpl__PaymentType__c = \'PaymentGiven\' '
            +'AND dmpl__PartnerAccountId__c =:partnerAccountId '
            +'AND dmpl__BranchId__c =:branchId '
            +'AND dmpl__AccountId__c =:accountId '
            +'AND (Name Like \'%' +searchKey+ '%\' '
            +'OR dmpl__Amount__c =:searchKeyNumberic '
            +'OR dmpl__OpenAmount2__c = :searchKeyNumberic '
            +'OR DAY_IN_MONTH(dmpl__PaymentDate__c) =:searchKeyNumberic '
            +'OR dmpl__OpenAmount__c =:searchKeyNumberic)';
            openDocuments.put(
                OBJECT_PAYMENT,
                Database.query(buildQuery(
                    new List<String>{
                        'Name',
                        'dmpl__PaymentDate__c',
                        'dmpl__AdjustedAmount__c',
                        'dmpl__OpenAmount2__c',
                        'dmpl__Amount__c'
                    }, 
                    OBJECT_PAYMENT, 
                    whereClause)));
             
        }else{ //Payment Given
            if(!onlyPayments){
                whereClause = 'dmpl__OpenAmount__c > 0 '+
                'AND dmpl__PartnerAccountId__c =:partnerAccountId '+
                'AND dmpl__BranchId__c =:branchId '
                +'AND dmpl__SupplierAccountId__c =:accountId '
                +'AND  (Name Like  \'%' +searchKey+ '%\' '
                +'OR dmpl__TotalAmount__c =:searchKeyNumberic '
                +'OR dmpl__OpenAmount__c = :searchKeyNumberic '
                +'OR DAY_IN_MONTH(dmpl__DocumentDate__c) =:searchKeyNumberic '
                +'OR dmpl__OpenAmount__c =:searchKeyNumberic)';
                openDocuments.put(
                    OBJECT_BILL,
                    Database.query(buildQuery(
                        new List<String>{
                            'Name',
                            'dmpl__DocumentDate__c',
                            'dmpl__AdjustedAmount__c',
                            'dmpl__OpenAmount__c',
                            'dmpl__TotalAmount__c'
                        }, 
                        OBJECT_BILL, 
                        whereClause)));
            
                whereClause = 'dmpl__OpenAmount__c > 0 '
                +'AND dmpl__PartnerAccountId__c =:partnerAccountId '
                +'AND dmpl__BranchId__c =:branchId '
                +'AND dmpl__SupplierAccountId__c =:accountId '
                +'AND  (Name Like \'%' +searchKey+ '%\' '
                +'OR dmpl__TotalAmount__c =:searchKeyNumberic '
                +'OR dmpl__OpenAmount__c = :searchKeyNumberic '
                +'OR DAY_IN_MONTH(dmpl__DocumentDate__c) =:searchKeyNumberic '
                +'OR dmpl__OpenAmount__c =:searchKeyNumberic)';
                openDocuments.put(
                    OBJECT_PURCHASEORDER,
                    Database.query(buildQuery(
                        new List<String>{
                            'Name',
                            'dmpl__DocumentDate__c',
                            'dmpl__AdjustedAmount__c',
                            'dmpl__OpenAmount__c',
                            'dmpl__TotalAmount__c'
                        }, 
                        OBJECT_PURCHASEORDER, 
                        whereClause)));       
            }

            whereClause = 'dmpl__OpenAmount2__c > 0 '
            +'AND dmpl__PaymentType__c = \'PaymentTaken\' '
            +'AND dmpl__PartnerAccountId__c =:partnerAccountId '
            +'AND dmpl__BranchId__c =:branchId '
            +'AND dmpl__AccountId__c =:accountId '
            +'AND (Name Like \'%' +searchKey+ '%\' '
            +'OR dmpl__Amount__c =:searchKeyNumberic '
            +'OR dmpl__OpenAmount2__c = :searchKeyNumberic '
            +'OR DAY_IN_MONTH(dmpl__PaymentDate__c) =:searchKeyNumberic '
            +'OR dmpl__OpenAmount__c =:searchKeyNumberic)';
            openDocuments.put(
                OBJECT_PAYMENT,
                Database.query(buildQuery(
                    new List<String>{
                        'Name',
                        'dmpl__PaymentDate__c',
                        'dmpl__AdjustedAmount__c',
                        'dmpl__OpenAmount2__c',
                        'dmpl__Amount__c'
                    }, 
                    OBJECT_PAYMENT, 
                    whereClause))); 

            whereClause = 'dmpl__OpenAmount__c > 0 '
            +'AND dmpl__PartnerAccountId__c =:partnerAccountId '
            +'AND dmpl__BranchId__c =:branchId '
            +'AND dmpl__AccountId__c =:accountId AND '
            +'(Name Like  \'%' +searchKey+ '%\' '
            +'OR dmpl__Amount__c =:searchKeyNumberic '
            +'OR dmpl__OpenAmount__c = :searchKeyNumberic '
            +'OR DAY_IN_MONTH(dmpl__DocumentDate__c) =:searchKeyNumberic '
            +'OR dmpl__OpenAmount__c =:searchKeyNumberic)';
            openDocuments.put(
                OBJECT_CREDITNOTE,
                Database.query(buildQuery(
                    new List<String>{
                        'Name',
                        'dmpl__DocumentDate__c',
                        'dmpl__AdjustedAmount__c',
                        'dmpl__OpenAmount__c',
                        'dmpl__Amount__c'
                    }, 
                    OBJECT_CREDITNOTE, 
                    whereClause)));
        }      
        return openDocuments;
    }

    public static List<String> getDynamicFieldList(
        String sObjectType){
        List<String> queryFields = new List<String>();
        Set<String> sObjectFields = new Set<String>();
        String dynamicFields = getDynamicFields();
        List<String> fieldsToAdd = dynamicFields.split(',');

        Map<String, Schema.SObjectField> sObjectFieldMetaData = MetadataHelper.getFieldMap(
            Schema.getGlobalDescribe().get(sObjectType));

        for(Schema.SObjectField field : sObjectFieldMetaData.values()){
            sObjectFields.add(
                field.getDescribe().getName());
        }
        for(String s : fieldsToAdd){
            if(sObjectFields.contains(s)){
                queryFields.add(s);
            }
        }
        return queryFields;
    }

    public static List<List<String>> extractColumns(){
        List<String> fieldNames = new List<String>();
        List<List<String>> fieldMetaData = new List<List<String>>();
        List<Schema.SObjectField> fields = new List<Schema.SObjectField>();
        fields.addALL(MetadataHelper.getFieldMap(Schema.getGlobalDescribe().get('dmpl__Bill__c')).Values());
        fields.addALL(MetadataHelper.getFieldMap(Schema.getGlobalDescribe().get('dmpl__Claim__c')).Values());
        fields.addALL(MetadataHelper.getFieldMap(Schema.getGlobalDescribe().get('dmpl__Payment__c')).Values());
        fields.addALL(MetadataHelper.getFieldMap(Schema.getGlobalDescribe().get('dmpl__DebitNote__c')).Values());
        fields.addALL(MetadataHelper.getFieldMap(Schema.getGlobalDescribe().get('dmpl__SaleOrder__c')).Values());
        fields.addALL(MetadataHelper.getFieldMap(Schema.getGlobalDescribe().get('dmpl__CreditNote__c')).Values());
        fields.addALL(MetadataHelper.getFieldMap(Schema.getGlobalDescribe().get('dmpl__SaleInvoice__c')).Values());
        fields.addALL(MetadataHelper.getFieldMap(Schema.getGlobalDescribe().get('dmpl__RepairOrder__c')).Values());
        fields.addALL(MetadataHelper.getFieldMap(Schema.getGlobalDescribe().get('dmpl__PurchaseOrder__c')).Values());
        System.debug(fields + 'fields');
        List<String> dynamicFields = getDynamicFields().split(',');
        for(Schema.SObjectField field : fields){
            if(dynamicFields.contains(field.getDescribe().getName()) 
            && !fieldNames.contains(field.getDescribe().getName())){
                fieldNames.add(field.getDescribe().getName());
                fieldMetaData.add(new List<String>{
                    field.getDescribe().getName(),
                    field.getDescribe().getLabel(),
                    field.getDescribe().getType().toString()});
            }
        }
        return fieldMetaData;
    }

    public static String buildQuery(
        List<String> fieldList, 
        String sObjectName, 
        String whereClause){
        List<String> fieldsToQuery  = new List<String>();
        List<String> dynamicFields = getDynamicFieldList(sObjectName);
        fieldstoQuery.addAll(fieldList);
        fieldstoQuery.addAll(dynamicFields);
        return String.format('SELECT {0} FROM {1} WHERE {2}',
            new List<String>{
                String.join(fieldsToQuery,','),
                sObjectName,
                whereClause
            });
    }

    public static List<FieldsetFieldInfo> getFieldsetInfo(){
        return MetadataHelper.getFieldsByFieldSetName(
            OBJECT_PAYMENT,
            getFieldsetName());
    }

    private static void verifyValidCombination(
        List<dmpl__PaymentAdjustment__c> newEntries){
        for(dmpl__PaymentAdjustment__c adjustment : newEntries){
            if((adjustment.dmpl__SaleOrderId__c!=null 
                    && adjustment.dmpl__PaymentId__c == null
                    && adjustment.dmpl__CreditNoteId__c == null
                    && adjustment.dmpl__SaleInvoiceId__c == null)
                || (adjustment.dmpl__SaleInvoiceId__c != null 
                    && adjustment.dmpl__PaymentId__c == null
                    && adjustment.dmpl__CreditNoteId__c == null
                    && adjustment.dmpl__SaleOrderId__c == null)
                || (adjustment.dmpl__PurchaseOrderId__c != null 
                    && adjustment.dmpl__PaymentId__c == null
                    && adjustment.dmpl__CreditNoteId__c == null
                    && adjustment.dmpl__BillId__c == null)
                || (adjustment.dmpl__BillId__c != null 
                    && adjustment.dmpl__PaymentId__c == null
                    && adjustment.dmpl__CreditNoteId__c == null
                    && adjustment.dmpl__PurchaseOrderId__c == null)
                || (adjustment.dmpl__RepairOrderId__c != null 
                    && adjustment.dmpl__PaymentId__c == null
                    && adjustment.dmpl__CreditNoteId__c == null
                    && adjustment.dmpl__SaleInvoiceId__c == null)
                // || (adjustment.dmpl__ServiceRequestId__c != null 
                //     && adjustment.dmpl__PaymentId__c == null
                //     && adjustment.dmpl__CreditNoteId__c == null
                //     && adjustment.dmpl__SaleInvoiceId__c == null)
                || (adjustment.dmpl__DebitNoteId__c != null 
                    && adjustment.dmpl__PaymentId__c == null
                    && adjustment.dmpl__CreditNoteId__c == null)){
                        adjustment.addError('Not a valid adjustment combination!');
                    }
            List<Id> documentIds = new List<Id>();
            if(adjustment.dmpl__SaleOrderId__c!=null){
                documentIds.add(adjustment.dmpl__SaleOrderId__c);
            }
            if(adjustment.dmpl__SaleInvoiceId__c!=null){
                documentIds.add(adjustment.dmpl__SaleInvoiceId__c);
            }
            if(adjustment.dmpl__PurchaseOrderId__c!=null){
                documentIds.add(adjustment.dmpl__PurchaseOrderId__c);
            }
            if(adjustment.dmpl__BillId__c!=null){
                documentIds.add(adjustment.dmpl__BillId__c);
            }
            if(adjustment.dmpl__RepairOrderId__c!=null){
                documentIds.add(adjustment.dmpl__RepairOrderId__c);
            }
            if(adjustment.dmpl__ServiceRequestId__c!=null){
                documentIds.add(adjustment.dmpl__ServiceRequestId__c);
            }
            if(adjustment.dmpl__DebitNoteId__c!=null){
                documentIds.add(adjustment.dmpl__DebitNoteId__c);
            }
            if(adjustment.dmpl__CreditNoteId__c!=null){
                documentIds.add(adjustment.dmpl__CreditNoteId__c);
            }
            if(adjustment.dmpl__PaymentId__c!=null){
                documentIds.add(adjustment.dmpl__PaymentId__c);
            }
            if(documentIds.size()!= 2){
                adjustment.addError('Adjustment needs two documents only!');
            }
        }
    }
    
    @testVisible
    private static dmpl__PaymentAdjustment__c createPaymentAdjustment(
        Map<Object,Object> documentMap){
            dmpl__PaymentAdjustment__c adjustmentDocument = new dmpl__PaymentAdjustment__c(
                dmpl__DocumentDate__c = date.today(),
                dmpl__AdjustmentAmount__c = (Double)documentMap.get('adjustedAmount')
            );
            setAdjustmentDocumentId(
                adjustmentDocument,
                (String)documentMap.get('documenApiName'),
                (Id)documentMap.get('documentId'));
            setAdjustmentDocumentId(
                adjustmentDocument,
                (String)documentMap.get('adjustedDocumentApiName'),
                (Id)documentMap.get('adjustedDocumentId'));
            return adjustmentDocument;
        }

        @testVisible
        private static void setAdjustmentDocumentId(
        dmpl__PaymentAdjustment__c adjustmentDocument,
        string objectApiName,
        Id documentId){
            if(objectApiName == 'dmpl__Payment__c'){
                adjustmentDocument.dmpl__PaymentId__c = documentId;    
            }else if(objectApiName == 'dmpl__SaleOrder__c'){
                adjustmentDocument.dmpl__SaleOrderId__c = documentId;
            }else if(objectApiName == 'dmpl__PurchaseOrder__c'){
                adjustmentDocument.dmpl__PurchaseOrderId__c = documentId;
            }else if(objectApiName == 'dmpl__SaleInvoice__c'){
                adjustmentDocument.dmpl__SaleInvoiceId__c = documentId;
            }else if(objectApiName == 'dmpl__Bill__c'){
                adjustmentDocument.dmpl__BillId__c = documentId;
            }else if(objectApiName == 'dmpl__RepairOrder__c'){
                adjustmentDocument.dmpl__RepairOrderId__c = documentId;
            }else if(objectApiName == 'dmpl__CreditNote__c'){
                adjustmentDocument.dmpl__CreditNoteId__c = documentId;
            }else if(objectApiName == 'dmpl__DebitNote__c'){
                adjustmentDocument.dmpl__DebitNoteId__c = documentId;
            }else if(objectApiName == 'dmpl__ServiceRequest__c'){
                adjustmentDocument.dmpl__DebitNoteId__c = documentId;
            }
    }

    private static void postAdjustments(
        List<dmpl__PaymentAdjustment__c> adjustments,
        Boolean undoPosting){
        List<SObject> objectsToUpdate = new List<SObject>();

        objectsToUpdate.addAll(
            postPaymentAdjustments(
                getPaymentAdjustments(
                    adjustments),
                undoPosting));
    
        objectsToUpdate.addAll(
            postInvoiceAdjustments(
                getInvoiceAdjustments(
                    adjustments),
                undoPosting));

        objectsToUpdate.addAll(
            postCreditNoteAdjustments(
                getCreditNoteAdjustments(
                    adjustments),
                undoPosting));            

        objectsToUpdate.addAll(
            postDebitNoteAdjustments(
                getDebitNoteAdjustments(
                    adjustments),
                undoPosting));
                    
        objectsToUpdate.addAll(
            postBillAdjustments(
                getBillAdjustments(
                    adjustments),
                undoPosting));
        
        objectsToUpdate.addAll(
            postSOAdjustments(
                getSOAdjustments(
                    adjustments),
                undoPosting));

        objectsToUpdate.addAll(
            postPOAdjustments(
                getPOAdjustments(
                    adjustments),
                undoPosting));

        objectsToUpdate.addAll(
            postROAdjustments(
                getROAdjustments(
                    adjustments),
                undoPosting));

        objectsToUpdate.addAll(
            postSRAdjustments(
                getSRAdjustments(
                    adjustments),
                undoPosting));

        update objectsToUpdate;
    }

    private static List<dmpl__PaymentAdjustment__c> getPaymentAdjustments(
        List<dmpl__PaymentAdjustment__c> adjustments){
        List<dmpl__PaymentAdjustment__c> paymentAdjustments = new List<dmpl__PaymentAdjustment__c>();
        for(dmpl__PaymentAdjustment__c adjustment : adjustments){
            if(adjustment.dmpl__PaymentId__c!=null){
                paymentAdjustments.add(adjustment);
            }
        }
        
        return paymentAdjustments;
    }
    
    private static List<dmpl__PaymentAdjustment__c> getInvoiceAdjustments(
        List<dmpl__PaymentAdjustment__c> adjustments){
        List<dmpl__PaymentAdjustment__c> invoiceAdjustments = new List<dmpl__PaymentAdjustment__c>();
        for(dmpl__PaymentAdjustment__c adjustment : adjustments){
            if(adjustment.dmpl__SaleInvoiceId__c!=null){
                invoiceAdjustments.add(adjustment);
            }
        }
        return invoiceAdjustments;
    }

    private static List<dmpl__PaymentAdjustment__c> getCreditNoteAdjustments(
        List<dmpl__PaymentAdjustment__c> adjustments){
        List<dmpl__PaymentAdjustment__c> creditNoteAdjustments = new List<dmpl__PaymentAdjustment__c>();
        for(dmpl__PaymentAdjustment__c adjustment : adjustments){
            if(adjustment.dmpl__CreditNoteId__c!=null){
                creditNoteAdjustments.add(adjustment);
            }
        }
        return creditNoteAdjustments;
    }

    private static List<dmpl__PaymentAdjustment__c> getDebitNoteAdjustments(
        List<dmpl__PaymentAdjustment__c> adjustments){
        List<dmpl__PaymentAdjustment__c> debitNoteAdjustments = new List<dmpl__PaymentAdjustment__c>();
        for(dmpl__PaymentAdjustment__c adjustment : adjustments){
            if(adjustment.dmpl__DebitNoteId__c!=null){
                debitNoteAdjustments.add(adjustment);
            }
        }
        return debitNoteAdjustments;
    }

    private static List<dmpl__PaymentAdjustment__c> getBillAdjustments(
        List<dmpl__PaymentAdjustment__c> adjustments){
        List<dmpl__PaymentAdjustment__c> billAdjustments = new List<dmpl__PaymentAdjustment__c>();
        for(dmpl__PaymentAdjustment__c adjustment : adjustments){
            if(adjustment.dmpl__BillId__c!=null){
                billAdjustments.add(adjustment);
            }
        }
        return billAdjustments;
    }

    private static List<dmpl__PaymentAdjustment__c> getSOAdjustments(
        List<dmpl__PaymentAdjustment__c> adjustments){
        List<dmpl__PaymentAdjustment__c> soAdjustments = new List<dmpl__PaymentAdjustment__c>();
        for(dmpl__PaymentAdjustment__c adjustment : adjustments){
            if(adjustment.dmpl__SaleOrderId__c!=null){
                soAdjustments.add(adjustment);
            }
        }
        return soAdjustments;
    }

    private static List<dmpl__PaymentAdjustment__c> getPOAdjustments(
        List<dmpl__PaymentAdjustment__c> adjustments){
        List<dmpl__PaymentAdjustment__c> poAdjustments = new List<dmpl__PaymentAdjustment__c>();
        for(dmpl__PaymentAdjustment__c adjustment : adjustments){
            if(adjustment.dmpl__PurchaseOrderId__c!=null){
                poAdjustments.add(adjustment);
            }
        }
        return poAdjustments;
    }

    private static List<dmpl__PaymentAdjustment__c> getROAdjustments(
        List<dmpl__PaymentAdjustment__c> adjustments){
        List<dmpl__PaymentAdjustment__c> roAdjustments = new List<dmpl__PaymentAdjustment__c>();
        for(dmpl__PaymentAdjustment__c adjustment : adjustments){
            if(adjustment.dmpl__RepairOrderId__c!=null){
                roAdjustments.add(adjustment);
            }
        }
        return roAdjustments;
    }

    private static List<dmpl__PaymentAdjustment__c> getSRAdjustments(
        List<dmpl__PaymentAdjustment__c> adjustments){
        List<dmpl__PaymentAdjustment__c> srAdjustments = new List<dmpl__PaymentAdjustment__c>();
        for(dmpl__PaymentAdjustment__c adjustment : adjustments){
            if(adjustment.dmpl__ServiceRequestId__c!=null){
                srAdjustments.add(adjustment);
            }
        }
        return srAdjustments;
    }

    private static List<SObject> postPaymentAdjustments(
        List<dmpl__PaymentAdjustment__c> adjustments,
        Boolean undoPosting){

        List<dmpl__Payment__c> payments = queryPayments(
            DocumentHelper.extractIds(
                adjustments, 
                'dmpl__PaymentId__c'));
        for(dmpl__PaymentAdjustment__c adjustment : adjustments){
            dmpl__Payment__c payment = (dmpl__Payment__c)DocumentHelper.getObject(
                payments, 
                adjustment.dmpl__PaymentId__c);
            if(payment == null){
                adjustment.addError('Payment Document Not Found!');
                continue;
            }
            if(undoPosting){
                payment.dmpl__AdjustedAmount__c -= adjustment.dmpl__AdjustmentAmount__c;
            }else{
                if(adjustment.dmpl__AdjustmentAmount__c > payment.dmpl__OpenAmount2__c){
                    adjustment.addError('Adjusted Amount can not be greater than Open Amount!');
                    continue;
                }
                if(payment.dmpl__AdjustedAmount__c == null){
                    payment.dmpl__AdjustedAmount__c = adjustment.dmpl__AdjustmentAmount__c;
                }else{
                    payment.dmpl__AdjustedAmount__c += adjustment.dmpl__AdjustmentAmount__c;
                }
            }
        }

        return payments;
    }

    private static List<SObject> postInvoiceAdjustments(
        List<dmpl__PaymentAdjustment__c> adjustments,
        Boolean undoPosting){
        List<dmpl__SaleInvoice__c> invoices = queryInvoices(
            DocumentHelper.extractIds(
                adjustments, 
                'dmpl__SaleInvoiceId__c'));
        for(dmpl__PaymentAdjustment__c adjustment : adjustments){
            dmpl__SaleInvoice__c invoice = (dmpl__SaleInvoice__c)DocumentHelper.getObject(
                invoices, 
                adjustment.dmpl__SaleInvoiceId__c);
            if(invoice == null){
                adjustment.addError('Sale Invoice Document Not Found!');
                continue;
            }
            if(undoPosting){
                invoice.dmpl__AdjustedAmount__c -= adjustment.dmpl__AdjustmentAmount__c;
            }else{
                if(adjustment.dmpl__AdjustmentAmount__c > invoice.dmpl__OpenAmount__c){
                    adjustment.addError('Adjusted Amount can not be greater than Open Amount!');
                    continue;
                }
                if(invoice.dmpl__AdjustedAmount__c == null){
                    invoice.dmpl__AdjustedAmount__c = adjustment.dmpl__AdjustmentAmount__c;    
                }else{
                    invoice.dmpl__AdjustedAmount__c += adjustment.dmpl__AdjustmentAmount__c;
                }
            }
        }
        return invoices;
    }

    private static List<SObject> postCreditNoteAdjustments(
        List<dmpl__PaymentAdjustment__c> adjustments,
        Boolean undoPosting){
        List<dmpl__CreditNote__c> creditNotes = queryCreditNotes(
            DocumentHelper.extractIds(
                adjustments, 
                'dmpl__CreditNoteId__c'));
        for(dmpl__PaymentAdjustment__c adjustment : adjustments){
            dmpl__CreditNote__c creditNote = (dmpl__CreditNote__c)DocumentHelper.getObject(
                creditNotes, 
                adjustment.dmpl__CreditNoteId__c);
            if(creditNote == null){
                adjustment.addError('Credit Note Document Not Found!');
                continue;
            }
            if(undoPosting){
                creditNote.dmpl__AdjustedAmount__c -= adjustment.dmpl__AdjustmentAmount__c;
            }else{
                if(adjustment.dmpl__AdjustmentAmount__c > creditNote.dmpl__OpenAmount__c){
                    adjustment.addError('Adjusted Amount can not be greater than Open Amount!');
                    continue;
                }
                if(creditNote.dmpl__AdjustedAmount__c == null){
                    creditNote.dmpl__AdjustedAmount__c = adjustment.dmpl__AdjustmentAmount__c;    
                }else{
                    creditNote.dmpl__AdjustedAmount__c += adjustment.dmpl__AdjustmentAmount__c;
                }
            }
        }
        return creditNotes;
    }
    private static List<SObject> postDebitNoteAdjustments(
        List<dmpl__PaymentAdjustment__c> adjustments,
        Boolean undoPosting){
        List<dmpl__DebitNote__c> debitNotes = queryDebitNotes(
            DocumentHelper.extractIds(
                adjustments, 
                'dmpl__DebitNoteId__c'));
        for(dmpl__PaymentAdjustment__c adjustment : adjustments){
            dmpl__DebitNote__c debitNote = (dmpl__DebitNote__c)DocumentHelper.getObject(
                debitNotes, 
                adjustment.dmpl__DebitNoteId__c);
            if(debitNote == null){
                adjustment.addError('Debit Note Document Not Found!');
                continue;
            }
            if(undoPosting){
                debitNote.dmpl__AdjustedAmount__c -= adjustment.dmpl__AdjustmentAmount__c;
            }else{
                if(adjustment.dmpl__AdjustmentAmount__c > debitNote.dmpl__OpenAmount__c){
                    adjustment.addError('Adjusted Amount can not be greater than Open Amount!');
                    continue;
                }
                if(debitNote.dmpl__AdjustedAmount__c == null){
                    debitNote.dmpl__AdjustedAmount__c = adjustment.dmpl__AdjustmentAmount__c;    
                }else{
                    debitNote.dmpl__AdjustedAmount__c += adjustment.dmpl__AdjustmentAmount__c;
                }
            }
        }
        return debitNotes;
    }
    
    @testVisible
    private static List<SObject> postBillAdjustments(
        List<dmpl__PaymentAdjustment__c> adjustments,
        Boolean undoPosting){
        List<dmpl__Bill__c> bills = queryBills(
            DocumentHelper.extractIds(
                adjustments, 
                'dmpl__BillId__c'));
        for(dmpl__PaymentAdjustment__c adjustment : adjustments){
            dmpl__Bill__c bill = (dmpl__Bill__c)DocumentHelper.getObject(
                bills, 
                adjustment.dmpl__BillId__c);
            if(bill == null){
                adjustment.addError('Bill Document Not Found!');
                continue;
            }
            if(undoPosting){
                bill.dmpl__AdjustedAmount__c -= adjustment.dmpl__AdjustmentAmount__c;
            }else{
                if(adjustment.dmpl__AdjustmentAmount__c > bill.dmpl__OpenAmount__c){
                    adjustment.addError('Adjusted Amount can not be greater than Open Amount!');
                    continue;
                }
                if(bill.dmpl__AdjustedAmount__c == null){
                    bill.dmpl__AdjustedAmount__c = adjustment.dmpl__AdjustmentAmount__c;    
                }else{
                    bill.dmpl__AdjustedAmount__c += adjustment.dmpl__AdjustmentAmount__c;
                }
            }
        }
        return bills;
    }

    private static List<SObject> postSOAdjustments(
        List<dmpl__PaymentAdjustment__c> adjustments,
        Boolean undoPosting){
        List<dmpl__SaleOrder__c> sos = querySos(
            DocumentHelper.extractIds(
                adjustments, 
                'dmpl__SaleOrderId__c'));
        for(dmpl__PaymentAdjustment__c adjustment : adjustments){
            dmpl__SaleOrder__c so = (dmpl__SaleOrder__c)DocumentHelper.getObject(
                sos, 
                adjustment.dmpl__SaleOrderId__c);
            if(so == null){
                adjustment.addError('SO Document Not Found!');
                continue;
            }
            if(adjustment.dmpl__SaleInvoiceId__c!=null){
                if(undoPosting){
                    so.dmpl__AdjustedAdvanceAmount__c -= adjustment.dmpl__AdjustmentAmount__c;
                }else{
                    if(adjustment.dmpl__AdjustmentAmount__c > so.dmpl__OpenAdvanceAmount__c){
                        adjustment.addError('Adjusted Amount can not be greater than Open Amount!');
                        continue;
                    }
                    if(so.dmpl__AdjustedAdvanceAmount__c == null){
                        so.dmpl__AdjustedAdvanceAmount__c = adjustment.dmpl__AdjustmentAmount__c;    
                    }else{
                        so.dmpl__AdjustedAdvanceAmount__c += adjustment.dmpl__AdjustmentAmount__c;
                    }
                }
            }else{
                if(undoPosting){
                    so.dmpl__AdvanceAmount__c -= adjustment.dmpl__AdjustmentAmount__c;
                }else{
                    if(adjustment.dmpl__AdjustmentAmount__c > so.dmpl__OpenAmount__c){
                        adjustment.addError('Adjusted Amount can not be greater than Open Amount!');
                        continue;
                    }
                    if(so.dmpl__AdvanceAmount__c == null){
                        so.dmpl__AdvanceAmount__c = adjustment.dmpl__AdjustmentAmount__c;    
                    }else{
                        so.dmpl__AdvanceAmount__c += adjustment.dmpl__AdjustmentAmount__c;
                    }
                }
            }
        }
        return sos;
    }
    @testvisible
    private static List<SObject> postPOAdjustments(
        List<dmpl__PaymentAdjustment__c> adjustments,
        Boolean undoPosting){
        List<dmpl__PurchaseOrder__c> pos = queryPos(
            DocumentHelper.extractIds(
                adjustments, 
                'dmpl__PurchaseOrderId__c'));
        for(dmpl__PaymentAdjustment__c adjustment : adjustments){
            dmpl__PurchaseOrder__c po = (dmpl__PurchaseOrder__c)DocumentHelper.getObject(
                pos, 
                adjustment.dmpl__PurchaseOrderId__c);
            if(po == null){
                adjustment.addError('Purchase Order Document Not Found!');
                continue;
            }
            if(adjustment.dmpl__BillId__c!=null){
                if(undoPosting){
                    po.dmpl__AdjustedAdvanceAmount__c -= adjustment.dmpl__AdjustmentAmount__c;
                }else{
                    if(adjustment.dmpl__AdjustmentAmount__c > po.dmpl__OpenAdvanceAmount__c){
                        adjustment.addError('Adjusted Amount can not be greater than Open Amount!');
                        continue;
                    }
                    if(po.dmpl__AdjustedAdvanceAmount__c == null){
                        po.dmpl__AdjustedAdvanceAmount__c = adjustment.dmpl__AdjustmentAmount__c;    
                    }else{
                        po.dmpl__AdjustedAdvanceAmount__c += adjustment.dmpl__AdjustmentAmount__c;
                    }
                }
            }else{
                if(undoPosting){
                    po.dmpl__AdvanceAmount__c -= adjustment.dmpl__AdjustmentAmount__c;
                }else{
                    if(adjustment.dmpl__AdjustmentAmount__c > po.dmpl__OpenAmount__c){
                        adjustment.addError('Adjusted Amount can not be greater than Open Amount!');
                        continue;
                    }
                    if(po.dmpl__AdvanceAmount__c == null){
                        po.dmpl__AdvanceAmount__c = adjustment.dmpl__AdjustmentAmount__c;    
                    }else{
                        po.dmpl__AdvanceAmount__c += adjustment.dmpl__AdjustmentAmount__c;
                    }
                }
            }
        }
        return pos;
    }
    @testvisible
    private static List<SObject> postROAdjustments(
        List<dmpl__PaymentAdjustment__c> adjustments,
        Boolean undoPosting){
        List<dmpl__RepairOrder__c> ros = queryRos(
            DocumentHelper.extractIds(
                adjustments, 
                'dmpl__RepairOrderId__c'));
        for(dmpl__PaymentAdjustment__c adjustment : adjustments){
            dmpl__RepairOrder__c ro = (dmpl__RepairOrder__c)DocumentHelper.getObject(
                ros, 
                adjustment.dmpl__RepairOrderId__c);
            if(ro == null){
                adjustment.addError('Repair Order Document Not Found!');
                continue;
            }
            if(adjustment.dmpl__SaleInvoiceId__c!=null){
                if(undoPosting){
                    ro.dmpl__AdjustedAdvanceAmount__c -= adjustment.dmpl__AdjustmentAmount__c;
                }else{
                    if(adjustment.dmpl__AdjustmentAmount__c > ro.dmpl__OpenAdvanceAmount__c){
                        adjustment.addError('Adjusted Amount can not be greater than Open Amount!');
                        continue;
                    }
                    if(ro.dmpl__AdjustedAdvanceAmount__c == null){
                        ro.dmpl__AdjustedAdvanceAmount__c = adjustment.dmpl__AdjustmentAmount__c;    
                    }else{
                        ro.dmpl__AdjustedAdvanceAmount__c += adjustment.dmpl__AdjustmentAmount__c;
                    }
                }
            }else{
                if(undoPosting){
                    ro.dmpl__AdvanceAmount__c -= adjustment.dmpl__AdjustmentAmount__c;
                }else{
                    if(adjustment.dmpl__AdjustmentAmount__c > ro.dmpl__OpenAmount__c){
                        adjustment.addError('Adjusted Amount can not be greater than Open Amount!');
                        continue;
                    }
                    if(ro.dmpl__AdvanceAmount__c == null){
                        ro.dmpl__AdvanceAmount__c = adjustment.dmpl__AdjustmentAmount__c;    
                    }else{
                        ro.dmpl__AdvanceAmount__c += adjustment.dmpl__AdjustmentAmount__c;
                    }
                }
            }
        }
        return ros;
    }

    @testvisible
    private static List<SObject> postSRAdjustments(
        List<dmpl__PaymentAdjustment__c> adjustments,
        Boolean undoPosting){
        List<dmpl__ServiceRequest__c> srs = querySrs(
            DocumentHelper.extractIds(
                adjustments, 
                'dmpl__ServiceRequestId__c'));
        for(dmpl__PaymentAdjustment__c adjustment : adjustments){
            dmpl__ServiceRequest__c sr = (dmpl__ServiceRequest__c)DocumentHelper.getObject(
                srs, 
                adjustment.dmpl__ServiceRequestId__c);
            if(sr == null){
                adjustment.addError('Service Request Document Not Found!');
                continue;
            }
            if(adjustment.dmpl__SaleInvoiceId__c!=null){ //Invoice
                if(undoPosting){
                sr.dmpl__AdjustedAdvanceAmount__c -= adjustment.dmpl__AdjustmentAmount__c;
                }else{
                    if(adjustment.dmpl__AdjustmentAmount__c > sr.dmpl__OpenAmount__c){
                        adjustment.addError('Adjusted Amount can not be greater than Open Amount!');
                        continue;
                    }
                    if(sr.dmpl__AdjustedAdvanceAmount__c == null){
                        sr.dmpl__AdjustedAdvanceAmount__c = adjustment.dmpl__AdjustmentAmount__c;    
                    }else{
                        sr.dmpl__AdjustedAdvanceAmount__c += adjustment.dmpl__AdjustmentAmount__c;
                    }
                }
            }else{
                if(undoPosting){
                    sr.dmpl__AdvanceAmount__c -= adjustment.dmpl__AdjustmentAmount__c;
                }else{
                    if(adjustment.dmpl__AdjustmentAmount__c > sr.dmpl__OpenAmount__c){
                        adjustment.addError('Adjusted Amount can not be greater than Open Amount!');
                        continue;
                    }
                    if(sr.dmpl__AdvanceAmount__c == null){
                        sr.dmpl__AdvanceAmount__c = adjustment.dmpl__AdjustmentAmount__c;    
                    }else{
                        sr.dmpl__AdvanceAmount__c += adjustment.dmpl__AdjustmentAmount__c;
                    }
                }
            }
        }
        return srs;
    }

    private static List<dmpl__Payment__c> queryPayments(
        List<Id> paymentIds){
        return [SELECT 
                Id, 
                dmpl__OpenAmount2__c,
                dmpl__AdjustedAmount__c 
            FROM dmpl__Payment__c
            WHERE Id IN :paymentIds];
    }
    
    private static List<dmpl__SaleInvoice__c> queryInvoices(
        List<Id> invoiceIds){
        return [SELECT 
                Id, 
                dmpl__OpenAmount__c,
                dmpl__AdjustedAmount__c 
            FROM dmpl__SaleInvoice__c
            WHERE Id IN :invoiceIds];
    }
    
    private static List<dmpl__CreditNote__c> queryCreditNotes(
        List<Id> creditNoteIds){
        return [SELECT 
                Id, 
                dmpl__OpenAmount__c,
                dmpl__AdjustedAmount__c 
            FROM dmpl__CreditNote__c
            WHERE Id IN :creditNoteIds];
    }
    
    private static List<dmpl__DebitNote__c> queryDebitNotes(
        List<Id> debitNoteIds){
        return [SELECT 
                Id, 
                dmpl__OpenAmount__c,
                dmpl__AdjustedAmount__c 
            FROM dmpl__DebitNote__c
            WHERE Id IN :debitNoteIds];
    }
    
    private static List<dmpl__Bill__c> queryBills(
        List<Id> billIds){
        return [SELECT 
                Id, 
                dmpl__OpenAmount__c,
                dmpl__AdjustedAmount__c 
            FROM dmpl__Bill__c
            WHERE Id IN :billIds];
    }
    
    private static List<dmpl__SaleOrder__c> querySos(
        List<Id> soIds){
        return [SELECT 
                Id, 
                dmpl__OpenAmount__c,
                dmpl__AdvanceAmount__c,
                dmpl__AdjustedAdvanceAmount__c,
                dmpl__OpenAdvanceAmount__c
            FROM dmpl__SaleOrder__c
            WHERE Id IN :soIds];
    }

    private static List<dmpl__PurchaseOrder__c> queryPos(
        List<Id> poIds){
        return [SELECT 
                Id, 
                dmpl__OpenAmount__c,
                dmpl__AdvanceAmount__c,
                dmpl__AdjustedAdvanceAmount__c,
                dmpl__OpenAdvanceAmount__c
            FROM dmpl__PurchaseOrder__c
            WHERE Id IN :poIds];
    }

    private static List<dmpl__RepairOrder__c> queryRos(
        List<Id> roIds){
        return [SELECT 
                Id, 
                dmpl__OpenAmount__c,
                dmpl__AdvanceAmount__c,
                dmpl__AdjustedAdvanceAmount__c,
                dmpl__OpenAdvanceAmount__c
            FROM dmpl__RepairOrder__c
            WHERE Id IN :roIds];
    }
    private static List<dmpl__ServiceRequest__c> querySrs(
        List<Id> srIds){
        return [SELECT 
                Id, 
                dmpl__OpenAmount__c,
                dmpl__AdvanceAmount__c,
                dmpl__AdjustedAdvanceAmount__c
            FROM dmpl__ServiceRequest__c
            WHERE Id IN :srIds];
    }

    private static String getDynamicFields(){
        dmpl__DMSOrgSetting__mdt orgSetting = OrgSettingHelper.orgSetting();
        if(orgSetting != null){
            return orgSetting.dmpl__PaymentAdjustmentPanelFields__c != null ?orgSetting.dmpl__PaymentAdjustmentPanelFields__c:'';
        }
        return '';
    }

    private static String getFieldsetName(){
        dmpl__DMSOrgSetting__mdt orgSetting = OrgSettingHelper.orgSetting();
        if(orgSetting != null){
            return orgSetting.dmpl__PaymentFieldsetName__c != null ?orgSetting.dmpl__PaymentFieldsetName__c:'';
        }
        return '';
    }
}