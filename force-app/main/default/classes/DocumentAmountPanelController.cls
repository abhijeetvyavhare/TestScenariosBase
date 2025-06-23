public with sharing class DocumentAmountPanelController {

    private static final string OBJECT_SALEORDER = 'dmpl__SaleOrder__c';
    private static final string OBJECT_SALEINVOICE = 'dmpl__SaleInvoice__c';
    private static final string OBJECT_PURCHASEORDER = 'dmpl__PurchaseOrder__c';
    private static final string OBJECT_BILL = 'dmpl__Bill__c';
    private static final string OBJECT_CLAIM = 'dmpl__Claim__c';
    private static final string OBJECT_QUOTE = 'dmpl__Quote__c';
    private static final string OBJECT_REPAIRORDER = 'dmpl__RepairOrder__c';
    private static final string OBJECT_RECONCILIATION = 'dmpl__ClaimReconciliation__c';
    private static final string OBJECT_CREDITNOTE = 'dmpl__CreditNote__c';
    private static final string OBJECT_DEBITNOTE = 'dmpl__DebitNote__c';
    private static final string OBJECT_SERVICEREQUEST = 'dmpl__ServiceRequest__c';
    private static final string OBJECT_DELIVERYORDER = 'dmpl__DeliveryOrder__c';
    private static final string OBJECT_SALERETURN = 'dmpl__SaleReturn__c';
    private static final string OBJECT_BILLRETURN = 'dmpl__BillReturn__c';
        
    @AuraEnabled(cacheable = true)
    public static DocumentAmountResult getDocumentAmounts(
        string objectApiName, 
        Id recordId,
        List<String> components){

        DocumentAmountResult daResult = new DocumentAmountResult();
        if(components.contains('DocumentTaxes')){
            daResult.DocumentTaxes = getDocumentTaxes(
                objectApiName, 
                recordId);
        }

        if(components.contains('DocumentPayments')){
            daResult.DocumentPayments = getDocumentPayments(
                objectApiName, 
                recordId);
        }

        if(components.contains('DocumentAdjustments')){
            daResult.DocumentAdjustments = getDocumentAdjustments(
                objectApiName, 
                recordId);
        }
        
        if(components.contains('DocumentFinanceCases')){
            daResult.DocumentFinanceCases = getDocumentFinanceCases(
                objectApiName, 
                recordId);
        }
        
        return daResult;
    }

    @AuraEnabled(cacheable = true)
    public static List<DocumentAmountTaxResult> getDocumentTaxes(
        string objectApiName, 
        Id recordId){
            //if(OrgSettingHelper.disableTaxPosting()){
                return getDocumentHostedTaxes(
                    objectApiName, 
                    recordId);
            // }else{
            //     try {
            //         if(objectApiName == OBJECT_SALEORDER){
            //             return convertToTaxAmountResult(getSaleOrderTaxes(recordId));
            //         }else if(objectApiName == OBJECT_SALEINVOICE){
            //             return convertToTaxAmountResult(getSaleInvoiceTaxes(recordId));
            //         }else if(objectApiName == OBJECT_REPAIRORDER){
            //             return convertToTaxAmountResult(getRepairOrderTaxes(recordId));
            //         }else if(objectApiName == OBJECT_PURCHASEORDER){
            //             return convertToTaxAmountResult(getPurchaseOrderTaxes(recordId));
            //         }else if(objectApiName == OBJECT_BILL){
            //             return convertToTaxAmountResult(getPurchaseInvoiceTaxes(recordId));
            //         }else if(objectApiName == OBJECT_QUOTE){
            //             return convertToTaxAmountResult(getQuoteTaxes(recordId));
            //         }else if(objectApiName == OBJECT_SERVICEREQUEST){
            //             return convertToTaxAmountResult(getServiceRequestTaxes(recordId));
            //         }else if(objectApiName == OBJECT_DELIVERYORDER){
            //             return convertToTaxAmountResult(getDeliveryOrderTaxes(recordId));
            //         }else if(objectApiName == OBJECT_SALERETURN){
            //             return convertToTaxAmountResult(getSaleReturnTaxes(recordId));
            //         }else if(objectApiName == OBJECT_BILLRETURN){
            //             return convertToTaxAmountResult(getBillReturnTaxes(recordId));}

            //     } catch (Exception error) {
            //         ExceptionLogHelper.logException(error);
            //         throw error;
            //     }
            // }
            //return new List<DocumentAmountTaxResult>();
    }

    @testVisible
    private static List<dmpl__PaymentAdjustment__c> getDocumentAdjustments(
        String objectApiName,
        Id recordId){
            try {
                if(objectApiName == OBJECT_SALEORDER){
                    return getSaleOrderAdjustments(recordId);
                }else if(objectApiName == OBJECT_SALEINVOICE){
                    return getSaleInvoiceAdjustments(recordId);
                }else if(objectApiName == OBJECT_PURCHASEORDER){
                    return getPurchaseOrderAdjustments(recordId);
                }  else if(objectApiName == OBJECT_BILL){
                    return getBillAdjustments(recordId);
                }  else if(objectApiName == OBJECT_REPAIRORDER){
                    return getRepairOrderAdjustments(recordId);
                }  else if(objectApiName == OBJECT_CREDITNOTE){
                    return getCreditNoteAdjustments(recordId);
                }  else if(objectApiName == OBJECT_DEBITNOTE){
                    return getDebitNoteAdjustments(recordId);
                }         
            } catch (Exception error) {
                ExceptionLogHelper.logException(error);
                throw error;
            }
            return new List<dmpl__PaymentAdjustment__c>();
    }

    @AuraEnabled(cacheable = true)
    public static List<Payment__c> getDocumentPayments(
        string objectApiName, 
        Id recordId){
        try {
            if(objectApiName == OBJECT_SALEORDER){
                return getSaleOrderPayments(recordId);
            }else if(objectApiName == OBJECT_SALEINVOICE){
                return getSaleInvoicePayments(recordId);
            }else if(objectApiName == OBJECT_PURCHASEORDER){
                return getPurchaseOrderPayments(recordId);
            }  else if(objectApiName == OBJECT_BILL){
                return getBillPayments(recordId);
            }  else if(objectApiName == OBJECT_CLAIM){
                return getClaimPayments(recordId);
            }  else if(objectApiName == OBJECT_RECONCILIATION){
                return getClaimReconciliationPayments(recordId);
            }  else if(objectApiName == OBJECT_REPAIRORDER){
                return getRepairOrderPayments(recordId);
            }         
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
        return new List<Payment__c>();
    }
    
    @AuraEnabled(cacheable = true)
    public static List<FinanceCase__c> getDocumentFinanceCases(
        string objectApiName, 
        Id recordId){
        try {
            if(objectApiName == OBJECT_SALEORDER){
                return getSaleOrderFinanceCases(recordId);
            }else if(objectApiName == OBJECT_SALEINVOICE){
                return getSaleInvoiceFinanceCases(recordId);
            }   
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
        return new List<FinanceCase__c>();
    }
    
    private static List<DocumentAmountTaxResult> getDocumentHostedTaxes(
        String sObjectName, 
        Id recordId){
            List<AggregateResult> headerTaxes = getHeaderTaxes(sObjectName, recordId);
            List<AggregateResult> lineTaxes = getLineTaxes(sObjectName, recordId);
            List<DocumentAmountTaxResult> allTaxes = new List<DocumentAmountTaxResult>();
            for (AggregateResult headerTax : headerTaxes) {
                if(headerTax.get('TaxName') != null){
                    allTaxes.add(new  DocumentAmountTaxResult('HeaderTaxes' ,
                            (String)headerTax.get('TaxName'),
                            headerTax.get('TaxAmount')));
                }
            }
            for (AggregateResult lineTax : lineTaxes) {
                for(Integer i=1; i<=6; i++){
                    if(lineTax.get('TaxAmount' + i) != null){
                        allTaxes.add(new  DocumentAmountTaxResult('LineTaxes' ,
                            (String)lineTax.get('TaxName' + i),
                            lineTax.get('TaxAmount' + i)));
                    }
                } 
            }
            return allTaxes;
    }

    private static List<AggregateResult> getLineTaxes(
        String sObjectName, 
        Id recordId){
            String lineQuery = 'SELECT dmpl__Tax1Name__c TaxName1, SUM(dmpl__Tax1__c) TaxAmount1, '
                + 'dmpl__Tax2Name__c TaxName2, SUM(dmpl__Tax2__c) TaxAmount2, '
                + 'dmpl__Tax3Name__c TaxName3, SUM(dmpl__Tax3__c) TaxAmount3, '
                + 'dmpl__Tax4Name__c TaxName4, SUM(dmpl__Tax4__c) TaxAmount4, '
                + 'dmpl__Tax5Name__c TaxName5, SUM(dmpl__Tax5__c) TaxAmount5, '
                + 'dmpl__Tax6Name__c TaxName6, SUM(dmpl__Tax6__c) TaxAmount6'
                + ' FROM ' 
                + getLineObjectName(sObjectName)
                + ' WHERE ' 
                + getHeaderFieldName(sObjectName)
                + ' =:recordId '
                + 'GROUP BY dmpl__Tax1Name__c, dmpl__Tax2Name__c, dmpl__Tax3Name__c, '
                + 'dmpl__Tax4Name__c, dmpl__Tax5Name__c, dmpl__Tax6Name__c';
            List<AggregateResult> lineTaxes = Database.query(lineQuery);
            return lineTaxes;
    }

    private static List<AggregateResult> getHeaderTaxes(
        String sObjectName, 
        Id recordId){
            if(sObjectName != OBJECT_SALEORDER && sObjectName != OBJECT_SALEINVOICE && sObjectName != OBJECT_PURCHASEORDER && sObjectName != OBJECT_BILL){
                return new List<AggregateResult>();
            }
            String headerQyery = 'SELECT dmpl__Tax1Name__c TaxName, SUM(dmpl__Tax1__c) TaxAmount ' 
                + ' FROM ' 
                + sObjectName 
                + ' WHERE Id =:recordId'
                + ' GROUP BY dmpl__Tax1Name__c';
            return Database.query(headerQyery);
    }

    private static List<DocumentAmountTaxResult> convertToTaxAmountResult(
        List<AggregateResult> taxResults){
            List<DocumentAmountTaxResult> taxAmountResults = new List<DocumentAmountTaxResult>();
            for (AggregateResult ar : taxResults) {
                DocumentAmountTaxResult taxAmountResult = new DocumentAmountTaxResult(ar);
                taxAmountResults.add(taxAmountResult);
            }
            return taxAmountResults;
    }

    private static String getLineObjectName(String objectApiName){
        if(objectApiName == OBJECT_SALEORDER){
            return 'dmpl__SaleOrderLine__c';
        }else if(objectApiName == OBJECT_SALEINVOICE){
            return 'dmpl__SaleInvoiceLine__c';
        }else if(objectApiName == OBJECT_REPAIRORDER){
            return 'dmpl__RepairOrderLine__c';
        }else if(objectApiName == OBJECT_PURCHASEORDER){
            return 'dmpl__PurchaseOrderLine__c';
        }else if(objectApiName == OBJECT_BILL){
            return 'dmpl__BillLine__c';
        }else if(objectApiName == OBJECT_QUOTE){
            return 'dmpl__QuoteLine__c';
        }else if(objectApiName == OBJECT_SERVICEREQUEST){
            return 'dmpl__ServiceRequestLine__c';
        }else if(objectApiName == OBJECT_DELIVERYORDER){
            return 'dmpl__DeliveryOrderLine__c';
        }else if(objectApiName == OBJECT_SALERETURN){
            return 'dmpl__SaleReturnLine__c';
        }else if(objectApiName == OBJECT_BILLRETURN){
            return 'dmpl__BillReturnLine__c';
        }
        return null;
    }

    private static String getHeaderFieldName(String objectApiName){
        if(objectApiName == OBJECT_SALEORDER){
            return 'dmpl__SaleOrderId__c';
        }else if(objectApiName == OBJECT_SALEINVOICE){
            return 'dmpl__SaleInvoiceId__c';
        }else if(objectApiName == OBJECT_REPAIRORDER){
            return 'dmpl__RepairOrderId__c';
        }else if(objectApiName == OBJECT_PURCHASEORDER){
            return 'dmpl__PurchaseOrderId__c';
        }else if(objectApiName == OBJECT_BILL){
            return 'dmpl__PurchaseInvoiceId__c';
        }else if(objectApiName == OBJECT_QUOTE){
            return 'dmpl__QuoteId__c';
        }else if(objectApiName == OBJECT_SERVICEREQUEST){
            return 'dmpl__ServiceRequestId__c';
        }else if(objectApiName == OBJECT_DELIVERYORDER){
            return 'dmpl__DeliveryOrderId__c';
        }else if(objectApiName == OBJECT_SALERETURN){
            return 'dmpl__SaleReturnId__c';
        }else if(objectApiName == OBJECT_BILLRETURN){
            return 'dmpl__BillReturnId__c';
        }
        return null;
    }
    
    private static List<AggregateResult> getSaleOrderTaxes(Id recordId){
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__TaxId__c',
            'dmpl__TaxAmount__c'
        }, 'dmpl__SaleOrderTax__c');
        return 
        [
        SELECT dmpl__TaxId__r.Name TaxName,
            Sum(dmpl__TaxAmount__c) TaxAmount
        FROM dmpl__SaleOrderTax__c
        WHERE dmpl__SaleOrderId__c =: recordId
        GROUP BY dmpl__TaxId__r.Name
        ];
    }
    
    @testVisible
    private static List<AggregateResult> getRepairOrderTaxes(Id recordId){
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__TaxId__c',
            'dmpl__TaxAmount__c',
            'dmpl__IsBillable__c'
        }, 'dmpl__RepairOrderTax__c');
        return 
        [
        SELECT dmpl__TaxId__r.Name TaxName,
            Sum(dmpl__TaxAmount__c) TaxAmount
        FROM dmpl__RepairOrderTax__c
        WHERE dmpl__RepairOrderId__c =: recordId
        AND dmpl__IsBillable__c = true
        WITH SECURITY_ENFORCED
        GROUP BY dmpl__TaxId__r.Name
        ];
    }

    @testVisible
    private static List<AggregateResult> getServiceQuoteTaxes(Id recordId){
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__TaxId__c',
            'dmpl__TaxAmount__c'
        }, 'dmpl__QuoteTax__c');
        return 
        [
        SELECT dmpl__TaxId__r.Name TaxName,
            Sum(dmpl__TaxAmount__c) TaxAmount
        FROM dmpl__QuoteTax__c
        WHERE dmpl__QuoteId__c =: recordId
        WITH SECURITY_ENFORCED
        GROUP BY dmpl__TaxId__r.Name
        ];
    }

    @testvisible
    private static List<AggregateResult> getServiceQuoteDiscounts(Id recordId){
        SecurityHelper.ensureCanReadFields(
            new string[]{
                'dmpl__NetDiscount__c',
                'dmpl__NetSchemeDiscount__c'
            }, 'dmpl__QuoteLine__c');
        return 
        [
        SELECT Sum(dmpl__NetDiscount__c) NetDiscount,
            Sum(dmpl__NetSchemeDiscount__c) NetSchemeAmount
        FROM dmpl__QuoteLine__c
        WHERE dmpl__QuoteId__c =: recordId
        ];
    }

    @testvisible
    private static List<AggregateResult> getPurchaseOrderTaxes(Id recordId){
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__TaxId__c',
            'dmpl__TaxAmount__c'
        }, 'dmpl__PurchaseOrderTax__c');
        return 
        [
        SELECT dmpl__TaxId__r.Name TaxName,
            Sum(dmpl__TaxAmount__c) TaxAmount
        FROM dmpl__PurchaseOrderTax__c
        WHERE dmpl__PurchaseOrderId__c =: recordId
        WITH SECURITY_ENFORCED
        GROUP BY dmpl__TaxId__r.Name
        ];
    }

    @Testvisible
    private static List<AggregateResult> getPurchaseInvoiceTaxes(Id recordId){
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__TaxId__c',
            'dmpl__TaxGroupId__c',
            'dmpl__TaxAmount__c'
        }, 'dmpl__PurchaseInvoiceTax__c');
        return 
        [SELECT dmpl__TaxId__r.Name TaxName,
            dmpl__TaxGroupId__r.dmpl__TaxGroupType__c TaxGroupType,
            Sum(dmpl__TaxAmount__c) TaxAmount
        FROM dmpl__PurchaseInvoiceTax__c
        WHERE dmpl__BillId__c =: recordId
        WITH SECURITY_ENFORCED
        GROUP BY dmpl__TaxId__r.Name,
            dmpl__TaxGroupId__r.dmpl__TaxGroupType__c];
    }

    @testvisible
    private static List<AggregateResult> getQuoteTaxes(Id recordId){
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__TaxId__c',
            'dmpl__TaxAmount__c'
        }, 'dmpl__QuoteTax__c');
        return 
        [
        SELECT dmpl__TaxId__r.Name TaxName,
            Sum(dmpl__TaxAmount__c) TaxAmount
        FROM dmpl__QuoteTax__c
        WHERE dmpl__QuoteId__c =: recordId
        WITH SECURITY_ENFORCED
        GROUP BY dmpl__TaxId__r.Name
        ];
    }
    
    @testvisible
    private static List<AggregateResult> getServiceRequestTaxes(Id recordId){
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__TaxId__c',
            'dmpl__TaxAmount__c'
        }, 'dmpl__ServiceRequestTax__c');
        return 
        [
        SELECT dmpl__TaxId__r.Name TaxName,
            Sum(dmpl__TaxAmount__c) TaxAmount
        FROM dmpl__ServiceRequestTax__c
        WHERE dmpl__ServiceRequestId__c =: recordId
        WITH SECURITY_ENFORCED
        GROUP BY dmpl__TaxId__r.Name
        ];
    }

    @testvisible
    private static List<AggregateResult> getDeliveryOrderTaxes(Id recordId){
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__TaxId__c',
            'dmpl__TaxAmount__c'
        }, 'dmpl__DeliveryOrderTax__c');
        return 
        [
        SELECT dmpl__TaxId__r.Name TaxName,
            Sum(dmpl__TaxAmount__c) TaxAmount
        FROM dmpl__DeliveryOrderTax__c
        WHERE dmpl__DeliveryOrderId__c =: recordId
        WITH SECURITY_ENFORCED
        GROUP BY dmpl__TaxId__r.Name
        ];
    }

    @testvisible
    private static List<AggregateResult> getSaleReturnTaxes(Id recordId){
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__TaxId__c',
            'dmpl__TaxAmount__c'
        }, 'dmpl__SaleReturnTax__c');
        return 
        [
        SELECT dmpl__TaxId__r.Name TaxName,
            Sum(dmpl__TaxAmount__c) TaxAmount
        FROM dmpl__SaleReturnTax__c
        WHERE dmpl__SaleReturnId__c =: recordId
        WITH SECURITY_ENFORCED
        GROUP BY dmpl__TaxId__r.Name
        ];
    }

    @testvisible
    private static List<AggregateResult> getBillReturnTaxes(Id recordId){
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__TaxId__c',
            'dmpl__TaxAmount__c'
        }, 'dmpl__BillReturnTax__c');
        return 
        [
        SELECT dmpl__TaxId__r.Name TaxName,
            Sum(dmpl__TaxAmount__c) TaxAmount
        FROM dmpl__BillReturnTax__c
        WHERE dmpl__BillReturnId__c =: recordId
        WITH SECURITY_ENFORCED
        GROUP BY dmpl__TaxId__r.Name
        ];
    }

    private static List<AggregateResult> getSaleInvoiceTaxes(Id recordId){
        
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__TaxAmount__c',
            'dmpl__TaxGroupId__c',
            'dmpl__SequenceNumber__c'
        }, 'dmpl__SaleInvoiceTax__c');
        return 
        [SELECT dmpl__TaxId__r.Name TaxName,
            dmpl__TaxGroupId__r.dmpl__TaxGroupType__c TaxGroupType,
            Sum(dmpl__TaxAmount__c) TaxAmount
        FROM dmpl__SaleInvoiceTax__c
        WHERE dmpl__SaleInvoiceId__c =: recordId
        WITH SECURITY_ENFORCED
        GROUP BY dmpl__TaxId__r.Name, 
            dmpl__TaxGroupId__r.dmpl__TaxGroupType__c];
    }
    
    @testVisible
    private static List<dmpl__PaymentAdjustment__c> getSaleOrderAdjustments(
        Id recordId){
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__BillId__c',
            'dmpl__CreditNoteId__c',
            'dmpl__DebitNoteId__c',
            'dmpl__DocumentDate__c',
            'dmpl__DocumentNumber__c',
            'dmpl__PaymentId__c',
            'dmpl__PurchaseOrderId__c',
            'dmpl__RepairOrderId__c',
            'dmpl__SaleInvoiceId__c',
            'dmpl__SaleOrderId__c',
            'dmpl__AdjustmentAmount__c'
        }, 'dmpl__PaymentAdjustment__c');
        return 
        [SELECT Id,
            Name,
            dmpl__BillId__c,
            dmpl__BillId__r.Name,
            dmpl__CreditNoteId__c,
            dmpl__CreditNoteId__r.Name,
            dmpl__DebitNoteId__c,
            dmpl__DebitNoteId__r.Name,
            dmpl__DocumentDate__c,
            dmpl__DocumentNumber__c,
            dmpl__PaymentId__c,
            dmpl__PaymentId__r.Name,
            dmpl__PurchaseOrderId__c,
            dmpl__PurchaseOrderId__r.Name,
            dmpl__RepairOrderId__c,
            dmpl__RepairOrderId__r.Name,
            dmpl__SaleInvoiceId__c,
            dmpl__SaleInvoiceId__r.Name,
            dmpl__SaleOrderId__c,
            dmpl__SaleOrderId__r.Name,
            dmpl__AdjustmentAmount__c
        FROM dmpl__PaymentAdjustment__c
        WHERE dmpl__SaleOrderId__c =: recordId
        WITH SECURITY_ENFORCED];
    }

    @testVisible
    private static List<dmpl__PaymentAdjustment__c> getSaleInvoiceAdjustments(
        Id recordId){
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__BillId__c',
            'dmpl__CreditNoteId__c',
            'dmpl__DebitNoteId__c',
            'dmpl__DocumentDate__c',
            'dmpl__DocumentNumber__c',
            'dmpl__PaymentId__c',
            'dmpl__PurchaseOrderId__c',
            'dmpl__RepairOrderId__c',
            'dmpl__SaleInvoiceId__c',
            'dmpl__SaleOrderId__c',
            'dmpl__AdjustmentAmount__c'
        }, 'dmpl__PaymentAdjustment__c');
        return 
        [SELECT Id,
            Name,
            dmpl__BillId__c,
            dmpl__BillId__r.Name,
            dmpl__CreditNoteId__c,
            dmpl__CreditNoteId__r.Name,
            dmpl__DebitNoteId__c,
            dmpl__DebitNoteId__r.Name,
            dmpl__DocumentDate__c,
            dmpl__DocumentNumber__c,
            dmpl__PaymentId__c,
            dmpl__PaymentId__r.Name,
            dmpl__PurchaseOrderId__c,
            dmpl__PurchaseOrderId__r.Name,
            dmpl__RepairOrderId__c,
            dmpl__RepairOrderId__r.Name,
            dmpl__SaleInvoiceId__c,
            dmpl__SaleInvoiceId__r.Name,
            dmpl__SaleOrderId__c,
            dmpl__SaleOrderId__r.Name,
            dmpl__AdjustmentAmount__c
        FROM dmpl__PaymentAdjustment__c
        WHERE dmpl__SaleInvoiceId__c =: recordId
        WITH SECURITY_ENFORCED
        ];
    }

    @testVisible
    private static List<dmpl__PaymentAdjustment__c> getBillAdjustments(
        Id recordId){
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__BillId__c',
            'dmpl__CreditNoteId__c',
            'dmpl__DebitNoteId__c',
            'dmpl__DocumentDate__c',
            'dmpl__DocumentNumber__c',
            'dmpl__PaymentId__c',
            'dmpl__PurchaseOrderId__c',
            'dmpl__RepairOrderId__c',
            'dmpl__SaleInvoiceId__c',
            'dmpl__SaleOrderId__c',
            'dmpl__AdjustmentAmount__c'
        }, 'dmpl__PaymentAdjustment__c');
        return 
        [SELECT Id,
            Name,
            dmpl__BillId__c,
            dmpl__BillId__r.Name,
            dmpl__CreditNoteId__c,
            dmpl__CreditNoteId__r.Name,
            dmpl__DebitNoteId__c,
            dmpl__DebitNoteId__r.Name,
            dmpl__DocumentDate__c,
            dmpl__DocumentNumber__c,
            dmpl__PaymentId__c,
            dmpl__PaymentId__r.Name,
            dmpl__PurchaseOrderId__c,
            dmpl__PurchaseOrderId__r.Name,
            dmpl__RepairOrderId__c,
            dmpl__RepairOrderId__r.Name,
            dmpl__SaleInvoiceId__c,
            dmpl__SaleInvoiceId__r.Name,
            dmpl__SaleOrderId__c,
            dmpl__SaleOrderId__r.Name,
            dmpl__AdjustmentAmount__c
        FROM dmpl__PaymentAdjustment__c
        WHERE dmpl__BillId__c =: recordId
        WITH SECURITY_ENFORCED
        ];
    }

    @testVisible
    private static List<dmpl__PaymentAdjustment__c> getCreditNoteAdjustments(
        Id recordId){
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__BillId__c',
            'dmpl__CreditNoteId__c',
            'dmpl__DebitNoteId__c',
            'dmpl__DocumentDate__c',
            'dmpl__DocumentNumber__c',
            'dmpl__PaymentId__c',
            'dmpl__PurchaseOrderId__c',
            'dmpl__RepairOrderId__c',
            'dmpl__SaleInvoiceId__c',
            'dmpl__SaleOrderId__c',
            'dmpl__AdjustmentAmount__c'
        }, 'dmpl__PaymentAdjustment__c');
        return 
        [SELECT Id,
            Name,
            dmpl__BillId__c,
            dmpl__BillId__r.Name,
            dmpl__CreditNoteId__c,
            dmpl__CreditNoteId__r.Name,
            dmpl__DebitNoteId__c,
            dmpl__DebitNoteId__r.Name,
            dmpl__DocumentDate__c,
            dmpl__DocumentNumber__c,
            dmpl__PaymentId__c,
            dmpl__PaymentId__r.Name,
            dmpl__PurchaseOrderId__c,
            dmpl__PurchaseOrderId__r.Name,
            dmpl__RepairOrderId__c,
            dmpl__RepairOrderId__r.Name,
            dmpl__SaleInvoiceId__c,
            dmpl__SaleInvoiceId__r.Name,
            dmpl__SaleOrderId__c,
            dmpl__SaleOrderId__r.Name,
            dmpl__AdjustmentAmount__c
        FROM dmpl__PaymentAdjustment__c
        WHERE dmpl__CreditNoteId__c =: recordId
        WITH SECURITY_ENFORCED
        ];
    }

    @testVisible
    private static List<dmpl__PaymentAdjustment__c> getPaymentAdjustments(
        Id recordId){
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__BillId__c',
            'dmpl__CreditNoteId__c',
            'dmpl__DebitNoteId__c',
            'dmpl__DocumentDate__c',
            'dmpl__DocumentNumber__c',
            'dmpl__PaymentId__c',
            'dmpl__PurchaseOrderId__c',
            'dmpl__RepairOrderId__c',
            'dmpl__SaleInvoiceId__c',
            'dmpl__SaleOrderId__c',
            'dmpl__AdjustmentAmount__c'
        }, 'dmpl__PaymentAdjustment__c');
        return 
        [SELECT Id,
            Name,
            dmpl__BillId__c,
            dmpl__BillId__r.Name,
            dmpl__CreditNoteId__c,
            dmpl__CreditNoteId__r.Name,
            dmpl__DebitNoteId__c,
            dmpl__DebitNoteId__r.Name,
            dmpl__DocumentDate__c,
            dmpl__DocumentNumber__c,
            dmpl__PaymentId__c,
            dmpl__PaymentId__r.Name,
            dmpl__PurchaseOrderId__c,
            dmpl__PurchaseOrderId__r.Name,
            dmpl__RepairOrderId__c,
            dmpl__RepairOrderId__r.Name,
            dmpl__SaleInvoiceId__c,
            dmpl__SaleInvoiceId__r.Name,
            dmpl__SaleOrderId__c,
            dmpl__SaleOrderId__r.Name,
            dmpl__AdjustmentAmount__c
        FROM dmpl__PaymentAdjustment__c
        WHERE dmpl__PaymentId__c =: recordId
        WITH SECURITY_ENFORCED
        ];
    }

    @testVisible
    private static List<dmpl__PaymentAdjustment__c> getPurchaseOrderAdjustments(
        Id recordId){
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__BillId__c',
            'dmpl__CreditNoteId__c',
            'dmpl__DebitNoteId__c',
            'dmpl__DocumentDate__c',
            'dmpl__DocumentNumber__c',
            'dmpl__PaymentId__c',
            'dmpl__PurchaseOrderId__c',
            'dmpl__RepairOrderId__c',
            'dmpl__SaleInvoiceId__c',
            'dmpl__SaleOrderId__c',
            'dmpl__AdjustmentAmount__c'
        }, 'dmpl__PaymentAdjustment__c');
        return 
        [SELECT Id,
            Name,
            dmpl__BillId__c,
            dmpl__BillId__r.Name,
            dmpl__CreditNoteId__c,
            dmpl__CreditNoteId__r.Name,
            dmpl__DebitNoteId__c,
            dmpl__DebitNoteId__r.Name,
            dmpl__DocumentDate__c,
            dmpl__DocumentNumber__c,
            dmpl__PaymentId__c,
            dmpl__PaymentId__r.Name,
            dmpl__PurchaseOrderId__c,
            dmpl__PurchaseOrderId__r.Name,
            dmpl__RepairOrderId__c,
            dmpl__RepairOrderId__r.Name,
            dmpl__SaleInvoiceId__c,
            dmpl__SaleInvoiceId__r.Name,
            dmpl__SaleOrderId__c,
            dmpl__SaleOrderId__r.Name,
            dmpl__AdjustmentAmount__c
        FROM dmpl__PaymentAdjustment__c
        WHERE dmpl__PurchaseOrderId__c =: recordId
        WITH SECURITY_ENFORCED
        ];
    }

    @testVisible
    private static List<dmpl__PaymentAdjustment__c> getRepairOrderAdjustments(
        Id recordId){
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__BillId__c',
            'dmpl__CreditNoteId__c',
            'dmpl__DebitNoteId__c',
            'dmpl__DocumentDate__c',
            'dmpl__DocumentNumber__c',
            'dmpl__PaymentId__c',
            'dmpl__PurchaseOrderId__c',
            'dmpl__RepairOrderId__c',
            'dmpl__SaleInvoiceId__c',
            'dmpl__SaleOrderId__c',
            'dmpl__AdjustmentAmount__c'
        }, 'dmpl__PaymentAdjustment__c');
        return 
        [SELECT Id,
            Name,
            dmpl__BillId__c,
            dmpl__BillId__r.Name,
            dmpl__CreditNoteId__c,
            dmpl__CreditNoteId__r.Name,
            dmpl__DebitNoteId__c,
            dmpl__DebitNoteId__r.Name,
            dmpl__DocumentDate__c,
            dmpl__DocumentNumber__c,
            dmpl__PaymentId__c,
            dmpl__PaymentId__r.Name,
            dmpl__PurchaseOrderId__c,
            dmpl__PurchaseOrderId__r.Name,
            dmpl__RepairOrderId__c,
            dmpl__RepairOrderId__r.Name,
            dmpl__SaleInvoiceId__c,
            dmpl__SaleInvoiceId__r.Name,
            dmpl__SaleOrderId__c,
            dmpl__SaleOrderId__r.Name,
            dmpl__AdjustmentAmount__c
        FROM dmpl__PaymentAdjustment__c
        WHERE dmpl__RepairOrderId__c =: recordId
        WITH SECURITY_ENFORCED
        ];
    }

    @testVisible
    private static List<dmpl__PaymentAdjustment__c> getDebitNoteAdjustments(
        Id recordId){
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__BillId__c',
            'dmpl__CreditNoteId__c',
            'dmpl__DebitNoteId__c',
            'dmpl__DocumentDate__c',
            'dmpl__DocumentNumber__c',
            'dmpl__PaymentId__c',
            'dmpl__PurchaseOrderId__c',
            'dmpl__RepairOrderId__c',
            'dmpl__SaleInvoiceId__c',
            'dmpl__SaleOrderId__c',
            'dmpl__AdjustmentAmount__c'
        }, 'dmpl__PaymentAdjustment__c');
        return 
        [SELECT Id,
            Name,
            dmpl__BillId__c,
            dmpl__BillId__r.Name,
            dmpl__CreditNoteId__c,
            dmpl__CreditNoteId__r.Name,
            dmpl__DebitNoteId__c,
            dmpl__DebitNoteId__r.Name,
            dmpl__DocumentDate__c,
            dmpl__DocumentNumber__c,
            dmpl__PaymentId__c,
            dmpl__PaymentId__r.Name,
            dmpl__PurchaseOrderId__c,
            dmpl__PurchaseOrderId__r.Name,
            dmpl__RepairOrderId__c,
            dmpl__RepairOrderId__r.Name,
            dmpl__SaleInvoiceId__c,
            dmpl__SaleInvoiceId__r.Name,
            dmpl__SaleOrderId__c,
            dmpl__SaleOrderId__r.Name,
            dmpl__AdjustmentAmount__c
        FROM dmpl__PaymentAdjustment__c
        WHERE dmpl__DebitNoteId__c =: recordId
        WITH SECURITY_ENFORCED
        ];
    }

    private static List<dmpl__Payment__c> getSaleOrderPayments(Id recordId){
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__PaymentMode__c',
            'dmpl__Amount__c'
        }, 'dmpl__Payment__c');
        return 
        [
        SELECT Id,
            Name,
            dmpl__Amount__c,
            dmpl__PaymentMode__c
        FROM dmpl__Payment__c
        WHERE dmpl__SaleOrderId__c =: recordId
        WITH SECURITY_ENFORCED
        ];
    }

    private static List<dmpl__Payment__c> getPurchaseOrderPayments(Id recordId)
    {
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__PaymentMode__c',
            'dmpl__Amount__c'
        }, 'dmpl__Payment__c');
        return 
        [
        SELECT Id,
            Name,
            dmpl__Amount__c,
            dmpl__PaymentMode__c
        FROM dmpl__Payment__c
        WHERE dmpl__PurchaseOrderId__c =: recordId
        WITH SECURITY_ENFORCED
        ];
    }

    private static List<dmpl__Payment__c> getBillPayments(Id recordId){
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__PaymentMode__c',
            'dmpl__Amount__c'
        }, 'dmpl__Payment__c');
        return 
        [
        SELECT Id,
            Name,
            dmpl__Amount__c,
            dmpl__PaymentMode__c
        FROM dmpl__Payment__c
        WHERE dmpl__BillId__c =: recordId
        WITH SECURITY_ENFORCED
        ];
    }

    private static List<dmpl__Payment__c> getRepairOrderPayments(Id recordId)
    {
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__PaymentMode__c',
            'dmpl__Amount__c'
        }, 'dmpl__Payment__c');
        return 
        [
        SELECT Id,
            Name,
            dmpl__Amount__c,
            dmpl__PaymentMode__c
        FROM dmpl__Payment__c
        WHERE dmpl__RepairOrderId__c =: recordId
        WITH SECURITY_ENFORCED
        ];
    }

    @testVisible
    private static List<dmpl__Payment__c> getClaimPayments(Id recordId)
    {
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__PaymentMode__c',
            'dmpl__Amount__c'
        }, 'dmpl__Payment__c');
        return 
        [
        SELECT Id,
            Name,
            dmpl__Amount__c,
            dmpl__PaymentMode__c
        FROM dmpl__Payment__c
        WHERE dmpl__ClaimId__c =: recordId
        WITH SECURITY_ENFORCED
        ];
    }

    private static List<dmpl__Payment__c> getClaimReconciliationPayments(Id recordId){
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__PaymentMode__c',
            'dmpl__Amount__c'
        }, 'dmpl__Payment__c');
        return 
        [
        SELECT Id,
            Name,
            dmpl__Amount__c,
            dmpl__PaymentMode__c
        FROM dmpl__Payment__c
        WHERE dmpl__ReconciliationId__c =: recordId
        WITH SECURITY_ENFORCED
        ];
    }

    private static List<dmpl__Payment__c> getSaleInvoicePayments(Id recordId){
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__PaymentMode__c',
            'dmpl__Amount__c'
        }, 'dmpl__Payment__c');
        return 
        [
        SELECT Id,
            Name,
            dmpl__Amount__c,
            dmpl__PaymentMode__c
        FROM dmpl__Payment__c
        WHERE dmpl__SaleInvoiceId__c =: recordId
        WITH SECURITY_ENFORCED
        ];
    }

    private static List<dmpl__FinanceCase__c> getSaleOrderFinanceCases(Id recordId){
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__FinanceProviderId__c',
            'dmpl__DisbursedAmount__c',
            'dmpl__RequestedAmount__c',
            'dmpl__ApprovedAmount__c'
        }, 'dmpl__FinanceCase__c');
        return 
        [
        SELECT Id,
            Name,
            dmpl__FinanceProviderId__r.Name,
            dmpl__ApprovedAmount__c,
            dmpl__RequestedAmount__c,
            dmpl__DisbursedAmount__c
        FROM dmpl__FinanceCase__c
        WHERE dmpl__SaleOrderId__c =: recordId
        WITH SECURITY_ENFORCED
        ];
    }

    private static List<dmpl__FinanceCase__c> getSaleInvoiceFinanceCases(Id recordId){
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__FinanceProviderId__c',
            'dmpl__DisbursedAmount__c',
            'dmpl__RequestedAmount__c',
            'dmpl__ApprovedAmount__c'
        }, 'dmpl__FinanceCase__c');
        return 
        [
        SELECT Id,
            Name,
            dmpl__FinanceProviderId__r.Name,
            dmpl__ApprovedAmount__c,
            dmpl__RequestedAmount__c,
            dmpl__DisbursedAmount__c
        FROM dmpl__FinanceCase__c
        WHERE dmpl__SaleInvoiceId__c =: recordId
        WITH SECURITY_ENFORCED
        ];
    }
}