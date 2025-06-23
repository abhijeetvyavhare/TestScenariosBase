@namespaceAccessible
public with sharing class TaxGroupHelper {

    private static final string FIELDNAME_ITEMID = 'dmpl__ItemId__c';
    private static final string FIELDNAME_PARTNERID = 'dmpl__PartnerAccountId__c';
    private static final string FIELDNAME_BRANCHID = 'dmpl__BranchId__c';
    private static final string FIELDNAME_SKUID = 'dmpl__SKUId__c';
    private static final string FIELDNAME_ITEMLOTTYPEID = 'dmpl__ItemLotTypeId__c';
    private static final string FIELDNAME_ITEM_ITEMTAXGROUPID = 'dmpl__TaxItemGroupId__c';
    private static final string FIELDNAME_DOCUMENT_DATE = 'dmpl__DocumentDate__c';
    private static final string FIELDNAME_PARTNER_ACCOUNTGROUP_ID = 'dmpl__PartnerTaxAccountGroupId__c';

    @namespaceAccessible
    public static Id getApplicableTaxGroup(
        Id partnerId, 
        Id branchId, 
        Id itemId, 
        Id skuId, 
        date documentDate,
        String taxSupplyType){
        if(skuId == null){
            return queryTaxGroup(
                partnerId, 
                branchId, 
                itemId, 
                documentDate,
                taxSupplyType);
        } else {
            return queryTaxGroup(
                partnerId, 
                branchId, 
                itemId, 
                skuId, 
                documentDate,
                taxSupplyType);
        }
    }

    @namespaceAccessible
    public static void setApplicableTaxGroups(
        List<SaleOrderLine__c> saleOrderLines, 
        List<SaleOrder__c> ofSaleOrders, 
        List<Item__c> lineItems){
        List<Account> partnerAccountGroupIds = queryPartnerAccountGroupIds(
            DocumentHelper.extractIds(
                ofSaleOrders, 
                FIELDNAME_PARTNERID));
        List<dmpl__TaxGroupRule__c> applicableTaxGroups = queryTaxGroups(
            saleOrderLines, 
            ofSaleOrders, 
            lineItems, 
            partnerAccountGroupIds);

            System.debug('applicableTaxGroups ' + applicableTaxGroups);
        SecurityHelper.ensureCanWriteField(
            'dmpl__TaxGroupId__c', 
            'dmpl__SaleOrderLine__c');
        for(SaleOrderLine__c orderLine: saleOrderLines){
            if(orderLine.TaxGroupId__c != null){
                continue;
            }
            for(dmpl__TaxGroupRule__c taxGroup : applicableTaxGroups){
                dmpl__SaleOrder__c saleOrder = getSaleOrder(
                    orderLine, 
                    ofSaleOrders);
                if(saleOrder==null){
                    return;
                }
                if( 
                    saleOrder.dmpl__TaxSupplyType__c == taxGroup.dmpl__TaxSupplyType__c
                    && (saleOrder.PartnerAccountId__c == taxGroup.dmpl__TaxGroupId__r.dmpl__PartnerAccountId__c 
                        || taxGroup.dmpl__TaxGroupId__r.PartnerAccountId__c == null)
                    && (getPartnerAccountGroupId(
                        saleOrder.PartnerAccountId__c, 
                        partnerAccountGroupIds) == taxGroup.dmpl__TaxGroupId__r.dmpl__PartnerAccountGroupId__c 
                        || taxGroup.dmpl__TaxGroupId__r.dmpl__PartnerAccountGroupId__c == null)
                    && (saleOrder.BranchId__c == taxGroup.dmpl__TaxGroupId__r.BranchId__c 
                        || taxGroup.dmpl__TaxGroupId__r.BranchId__c == null)
                    && (orderLine.ItemId__c == taxGroup.ItemId__c 
                        || taxGroup.ItemId__c == null)
                    && (getItemTaxGroupId(
                        lineItems, 
                        orderLine.ItemId__c)  == taxGroup.dmpl__ItemGroupId__c 
                        || taxGroup.dmpl__ItemGroupId__c == null)
                    && (orderLine.SKUId__c == taxGroup.SKUID__c 
                        || taxGroup.SKUID__c == null)
                    && (orderLine.dmpl__ItemLotTypeId__c == taxGroup.dmpl__ItemLotTypeId__c 
                        || taxGroup.dmpl__ItemLotTypeId__c == null)
                    && (saleOrder.DocumentDate__c >= taxGroup.dmpl__DateEffectiveFrom__c 
                        || taxGroup.dmpl__DateEffectiveFrom__c == null)
                    && (saleOrder.DocumentDate__c <= taxGroup.dmpl__DateEffectiveTill__c 
                        || taxGroup.dmpl__DateEffectiveTill__c == null)
                ){
                    orderLine.TaxGroupId__c = taxGroup.dmpl__TaxGroupId__c;
                    break;
                }
            }    
        }
    }

    @namespaceAccessible
    public static void setApplicableTaxGroups(List<SaleInvoiceLine__c> saleInvoiceLines, List<SaleInvoice__c> ofSaleInvoices, List<Item__c> lineItems){
        List<Account> partnerAccountGroupIds = queryPartnerAccountGroupIds(DocumentHelper.extractIds(ofSaleInvoices, FIELDNAME_PARTNERID));
        List<dmpl__TaxGroupRule__c> applicableTaxGroups = queryTaxGroups(saleInvoiceLines, ofSaleInvoices, lineItems, partnerAccountGroupIds);
        SecurityHelper.ensureCanWriteField('dmpl__TaxGroupId__c', 'dmpl__SaleInvoiceLine__c');
        for(SaleInvoiceLine__c invoiceLine: saleInvoiceLines){
            if(invoiceLine.TaxGroupId__c != null){
                continue;
            }
            for(dmpl__TaxGroupRule__c taxGroup : applicableTaxGroups){
                dmpl__SaleInvoice__c saleInvoice = getSaleInvoice(invoiceLine, ofSaleInvoices);
                if(
                    saleInvoice.dmpl__TaxSupplyType__c == taxGroup.dmpl__TaxSupplyType__c
                    && (saleInvoice.PartnerAccountId__c == taxGroup.dmpl__TaxGroupId__r.dmpl__PartnerAccountId__c || taxGroup.dmpl__TaxGroupId__r.PartnerAccountId__c == null)
                    && (getPartnerAccountGroupId(saleInvoice.PartnerAccountId__c, partnerAccountGroupIds) == taxGroup.dmpl__TaxGroupId__r.dmpl__PartnerAccountGroupId__c || taxGroup.dmpl__TaxGroupId__r.dmpl__PartnerAccountGroupId__c == null)
                    && (saleInvoice.BranchId__c == taxGroup.dmpl__TaxGroupId__r.BranchId__c || taxGroup.dmpl__TaxGroupId__r.BranchId__c == null)
                    && (invoiceLine.ItemId__c == taxGroup.ItemId__c || taxGroup.ItemId__c == null)
                    && (getItemTaxGroupId(lineItems, invoiceLine.ItemId__c)  == taxGroup.dmpl__ItemGroupId__c || taxGroup.dmpl__ItemGroupId__c == null)
                    && (invoiceLine.SKUId__c == taxGroup.SKUID__c || taxGroup.SKUID__c == null)
                    && (invoiceLine.dmpl__ItemLotTypeId__c == taxGroup.dmpl__ItemLotTypeId__c || taxGroup.dmpl__ItemLotTypeId__c == null)
                    && (saleInvoice.DocumentDate__c >= taxGroup.dmpl__DateEffectiveFrom__c || taxGroup.dmpl__DateEffectiveFrom__c == null)
                    && (saleInvoice.DocumentDate__c <= taxGroup.dmpl__DateEffectiveTill__c || taxGroup.dmpl__DateEffectiveTill__c == null)
                ){
                    invoiceLine.TaxGroupId__c = taxGroup.dmpl__TaxGroupId__c;
                    break;
                }
            }    
        }
    }

    @namespaceAccessible
    public static void setApplicableTaxGroups(List<PurchaseOrderLine__c> purchaseOrderLines, List<PurchaseOrder__c> purchaseOrders, List<Item__c> lineItems){
        List<Account> partnerAccountGroupIds = queryPartnerAccountGroupIds(DocumentHelper.extractIds(purchaseOrders, FIELDNAME_PARTNERID));
        List<dmpl__TaxGroupRule__c> applicableTaxGroups = queryTaxGroups(purchaseOrderLines, purchaseOrders, lineItems, partnerAccountGroupIds);
        SecurityHelper.ensureCanWriteField('dmpl__TaxGroupId__c', 'dmpl__PurchaseOrderLine__c');
        for(PurchaseOrderLine__c orderLine: purchaseOrderLines){
            if(orderLine.TaxGroupId__c != null){
                continue;
            }
            for(dmpl__TaxGroupRule__c taxGroup : applicableTaxGroups){
                PurchaseOrder__c purchaseOrder = getPurchaseOrder(orderLine, purchaseOrders);
                if(
                    purchaseOrder.dmpl__TaxSupplyType__c == taxGroup.dmpl__TaxSupplyType__c
                    && (purchaseOrder.PartnerAccountId__c == taxGroup.dmpl__TaxGroupId__r.dmpl__PartnerAccountId__c || taxGroup.dmpl__TaxGroupId__r.PartnerAccountId__c == null)
                    && (getPartnerAccountGroupId(purchaseOrder.PartnerAccountId__c, partnerAccountGroupIds) == taxGroup.dmpl__TaxGroupId__r.dmpl__PartnerAccountGroupId__c || taxGroup.dmpl__TaxGroupId__r.dmpl__PartnerAccountGroupId__c == null)
                    && (purchaseOrder.BranchId__c == taxGroup.dmpl__TaxGroupId__r.BranchId__c || taxGroup.dmpl__TaxGroupId__r.BranchId__c == null)
                    && (orderLine.ItemId__c == taxGroup.ItemId__c || taxGroup.ItemId__c == null)
                    && (getItemTaxGroupId(lineItems, orderLine.ItemId__c)  == taxGroup.dmpl__ItemGroupId__c || taxGroup.dmpl__ItemGroupId__c == null)
                    && (orderLine.SKUId__c == taxGroup.SKUID__c || taxGroup.SKUID__c == null)
                    && (orderLine.dmpl__ItemLotTypeId__c == taxGroup.dmpl__ItemLotTypeId__c || taxGroup.dmpl__ItemLotTypeId__c == null)
                    && (purchaseOrder.DocumentDate__c >= taxGroup.dmpl__DateEffectiveFrom__c || taxGroup.dmpl__DateEffectiveFrom__c == null)
                    && (purchaseOrder.DocumentDate__c <= taxGroup.dmpl__DateEffectiveTill__c || taxGroup.dmpl__DateEffectiveTill__c == null)
                ){
                    orderLine.TaxGroupId__c = taxGroup.dmpl__TaxGroupId__c;
                    break;
                }
            }    
        }
    }

    @namespaceAccessible
    public static void setApplicableTaxGroups(List<BillLine__c> purchaseInvoiceLines, List<Bill__c> purchaseInvoices, List<Item__c> lineItems){
        List<Account> partnerAccountGroupIds = queryPartnerAccountGroupIds(DocumentHelper.extractIds(purchaseInvoices, FIELDNAME_PARTNERID));
        List<dmpl__TaxGroupRule__c> applicableTaxGroups = queryTaxGroups(purchaseInvoiceLines, purchaseInvoices, lineItems, partnerAccountGroupIds);
        SecurityHelper.ensureCanWriteField('dmpl__TaxGroupId__c', 'dmpl__BillLine__c');
        for(BillLine__c invoiceLine: purchaseInvoiceLines){
            if(invoiceLine.TaxGroupId__c != null){
                continue;
            }
            for(dmpl__TaxGroupRule__c taxGroup : applicableTaxGroups){
                Bill__c purchaseInvoice = getPurchaseInvoice(invoiceLine, purchaseInvoices);
                if(
                    purchaseInvoice.dmpl__TaxSupplyType__c == taxGroup.dmpl__TaxSupplyType__c
                    && (purchaseInvoice.PartnerAccountId__c == taxGroup.dmpl__TaxGroupId__r.dmpl__PartnerAccountId__c || taxGroup.dmpl__TaxGroupId__r.PartnerAccountId__c == null)
                    && (getPartnerAccountGroupId(purchaseInvoice.PartnerAccountId__c, partnerAccountGroupIds) == taxGroup.dmpl__TaxGroupId__r.dmpl__PartnerAccountGroupId__c || taxGroup.dmpl__TaxGroupId__r.dmpl__PartnerAccountGroupId__c == null)
                    && (purchaseInvoice.BranchId__c == taxGroup.dmpl__TaxGroupId__r.BranchId__c || taxGroup.dmpl__TaxGroupId__r.BranchId__c == null)
                    && (invoiceLine.ItemId__c == taxGroup.ItemId__c || taxGroup.ItemId__c == null)
                    && (getItemTaxGroupId(lineItems, invoiceLine.ItemId__c)  == taxGroup.dmpl__ItemGroupId__c || taxGroup.dmpl__ItemGroupId__c == null)
                    && (invoiceLine.SKUId__c == taxGroup.SKUID__c || taxGroup.SKUID__c == null)
                    && (invoiceLine.dmpl__ItemLotTypeId__c == taxGroup.dmpl__ItemLotTypeId__c || taxGroup.dmpl__ItemLotTypeId__c == null)
                    && (purchaseInvoice.DocumentDate__c >= taxGroup.dmpl__DateEffectiveFrom__c || taxGroup.dmpl__DateEffectiveFrom__c == null)
                    && (purchaseInvoice.DocumentDate__c <= taxGroup.dmpl__DateEffectiveTill__c || taxGroup.dmpl__DateEffectiveTill__c == null)
                ){
                    invoiceLine.TaxGroupId__c = taxGroup.dmpl__TaxGroupId__c;
                    break;
                }
            }    
        }
    }

    @namespaceAccessible
    public static void setApplicableTaxGroups(List<ServiceRequestLine__c> serviceRequestLines, List<ServiceRequest__c> serviceRequests, List<Item__c> lineItems){
        List<Account> partnerAccountGroupIds = queryPartnerAccountGroupIds(DocumentHelper.extractIds(serviceRequests, FIELDNAME_PARTNERID));
        List<dmpl__TaxGroupRule__c> applicableTaxGroups = queryTaxGroups(serviceRequestLines, serviceRequests, lineItems, partnerAccountGroupIds);
        SecurityHelper.ensureCanWriteField('dmpl__TaxGroupId__c', 'dmpl__ServiceRequestLine__c');
        for(ServiceRequestLine__c serviceRequestLine: serviceRequestLines){
            if(serviceRequestLine.TaxGroupId__c != null){
                continue;
            }
            for(dmpl__TaxGroupRule__c taxGroup : applicableTaxGroups){
                dmpl__ServiceRequest__c serviceRequest = getServiceRequest(serviceRequestLine, serviceRequests);
                if(
                    serviceRequest.dmpl__TaxSupplyType__c == taxGroup.dmpl__TaxSupplyType__c
                    && (serviceRequest.PartnerAccountId__c == taxGroup.dmpl__TaxGroupId__r.dmpl__PartnerAccountId__c || taxGroup.dmpl__TaxGroupId__r.PartnerAccountId__c == null)
                    && (getPartnerAccountGroupId(serviceRequest.PartnerAccountId__c, partnerAccountGroupIds) == taxGroup.dmpl__TaxGroupId__r.dmpl__PartnerAccountGroupId__c || taxGroup.dmpl__TaxGroupId__r.dmpl__PartnerAccountGroupId__c == null)
                    && (serviceRequest.BranchId__c == taxGroup.dmpl__TaxGroupId__r.BranchId__c || taxGroup.dmpl__TaxGroupId__r.BranchId__c == null)
                    && (serviceRequestLine.ItemId__c == taxGroup.ItemId__c || taxGroup.ItemId__c == null)
                    && (getItemTaxGroupId(lineItems, serviceRequestLine.ItemId__c)  == taxGroup.dmpl__ItemGroupId__c || taxGroup.dmpl__ItemGroupId__c == null)
                    && (serviceRequestLine.SKUId__c == taxGroup.SKUID__c || taxGroup.SKUID__c == null)
                    && (serviceRequestLine.dmpl__ItemLotTypeId__c == taxGroup.dmpl__ItemLotTypeId__c || taxGroup.dmpl__ItemLotTypeId__c == null)
                    && (serviceRequest.DocumentDate__c >= taxGroup.dmpl__DateEffectiveFrom__c || taxGroup.dmpl__DateEffectiveFrom__c == null)
                    && (serviceRequest.DocumentDate__c <= taxGroup.dmpl__DateEffectiveTill__c || taxGroup.dmpl__DateEffectiveTill__c == null)
                ){
                    serviceRequestLine.TaxGroupId__c = taxGroup.dmpl__TaxGroupId__c;
                    break;
                }
            }    
        }
    }

    @namespaceAccessible
    public static void setApplicableTaxGroups(List<DeliveryOrderLine__c> deliveryOrderLines, List<DeliveryOrder__c> deliveryOrders, List<Item__c> lineItems){
        List<Account> partnerAccountGroupIds = queryPartnerAccountGroupIds(DocumentHelper.extractIds(deliveryOrders, FIELDNAME_PARTNERID));
        List<dmpl__TaxGroupRule__c> applicableTaxGroups = queryTaxGroups(deliveryOrderLines, deliveryOrders, lineItems, partnerAccountGroupIds);
        SecurityHelper.ensureCanWriteField('dmpl__TaxGroupId__c', 'dmpl__DeliveryOrderLine__c');
        for(DeliveryOrderLine__c deliveryOrderLine: deliveryOrderLines){
            if(deliveryOrderLine.TaxGroupId__c != null){
                continue;
            }
            for(dmpl__TaxGroupRule__c taxGroup : applicableTaxGroups){
                DeliveryOrder__c deliveryOrder = getDeliveryOrder(deliveryOrderLine, deliveryOrders);
                if(
                    deliveryOrder.dmpl__TaxSupplyType__c == taxGroup.dmpl__TaxSupplyType__c
                    && (deliveryOrder.PartnerAccountId__c == taxGroup.dmpl__TaxGroupId__r.dmpl__PartnerAccountId__c || taxGroup.dmpl__TaxGroupId__r.PartnerAccountId__c == null)
                    && (getPartnerAccountGroupId(deliveryOrder.PartnerAccountId__c, partnerAccountGroupIds) == taxGroup.dmpl__TaxGroupId__r.dmpl__PartnerAccountGroupId__c || taxGroup.dmpl__TaxGroupId__r.dmpl__PartnerAccountGroupId__c == null)
                    && (deliveryOrder.BranchId__c == taxGroup.dmpl__TaxGroupId__r.BranchId__c || taxGroup.dmpl__TaxGroupId__r.BranchId__c == null)
                    && (deliveryOrderLine.ItemId__c == taxGroup.ItemId__c || taxGroup.ItemId__c == null)
                    && (getItemTaxGroupId(lineItems, deliveryOrderLine.ItemId__c)  == taxGroup.dmpl__ItemGroupId__c || taxGroup.dmpl__ItemGroupId__c == null)
                    && (deliveryOrderLine.SKUId__c == taxGroup.SKUID__c || taxGroup.SKUID__c == null)
                    && (deliveryOrderLine.dmpl__ItemLotTypeId__c == taxGroup.dmpl__ItemLotTypeId__c || taxGroup.dmpl__ItemLotTypeId__c == null)
                    && (deliveryOrder.DocumentDate__c >= taxGroup.dmpl__DateEffectiveFrom__c || taxGroup.dmpl__DateEffectiveFrom__c == null)
                    && (deliveryOrder.DocumentDate__c <= taxGroup.dmpl__DateEffectiveTill__c || taxGroup.dmpl__DateEffectiveTill__c == null)
                ){
                    deliveryOrderLine.TaxGroupId__c = taxGroup.dmpl__TaxGroupId__c;
                    break;
                }
            }    
        }
    }

    @namespaceAccessible
    public static void setApplicableTaxGroups(List<QuoteLine__c> quoteLines, List<Quote__c> quotes, List<Item__c> lineItems){
        List<Account> partnerAccountGroupIds = queryPartnerAccountGroupIds(DocumentHelper.extractIds(quotes, FIELDNAME_PARTNERID));
        List<dmpl__TaxGroupRule__c> applicableTaxGroups = queryTaxGroups(quoteLines, quotes, lineItems, partnerAccountGroupIds);
        SecurityHelper.ensureCanWriteField('dmpl__TaxGroupId__c', 'dmpl__QuoteLine__c');
        for(QuoteLine__c quoteLine: quoteLines){
            if(quoteLine.TaxGroupId__c != null){
                continue;
            }
            for(dmpl__TaxGroupRule__c taxGroup : applicableTaxGroups){
                Quote__c quote = getQuote(quoteLine, quotes);
                if(
                    quote.dmpl__TaxSupplyType__c == taxGroup.dmpl__TaxSupplyType__c
                    && (quote.PartnerAccountId__c == taxGroup.dmpl__TaxGroupId__r.dmpl__PartnerAccountId__c || taxGroup.dmpl__TaxGroupId__r.PartnerAccountId__c == null)
                    && (getPartnerAccountGroupId(quote.PartnerAccountId__c, partnerAccountGroupIds) == taxGroup.dmpl__TaxGroupId__r.dmpl__PartnerAccountGroupId__c || taxGroup.dmpl__TaxGroupId__r.dmpl__PartnerAccountGroupId__c == null)
                    && (quote.BranchId__c == taxGroup.dmpl__TaxGroupId__r.BranchId__c || taxGroup.dmpl__TaxGroupId__r.BranchId__c == null)
                    && (quoteLine.ItemId__c == taxGroup.ItemId__c || taxGroup.ItemId__c == null)
                    && (getItemTaxGroupId(lineItems, quoteLine.ItemId__c)  == taxGroup.dmpl__ItemGroupId__c || taxGroup.dmpl__ItemGroupId__c == null)
                    && (quoteLine.SKUId__c == taxGroup.SKUID__c || taxGroup.SKUID__c == null)
                    && (quoteLine.dmpl__ItemLotTypeId__c == taxGroup.dmpl__ItemLotTypeId__c || taxGroup.dmpl__ItemLotTypeId__c == null)
                    && (quote.DocumentDate__c >= taxGroup.dmpl__DateEffectiveFrom__c || taxGroup.dmpl__DateEffectiveFrom__c == null)
                    && (quote.DocumentDate__c <= taxGroup.dmpl__DateEffectiveTill__c || taxGroup.dmpl__DateEffectiveTill__c == null)
                ){
                    quoteLine.TaxGroupId__c = taxGroup.dmpl__TaxGroupId__c;
                    break;
                }
            }    
        }
    }

    @namespaceAccessible
    public static void setApplicableTaxGroups(List<RepairOrderLine__c> repairOrderLines, List<RepairOrder__c> repairOrders, List<Item__c> lineItems){
        List<Account> partnerAccountGroupIds = queryPartnerAccountGroupIds(DocumentHelper.extractIds(repairOrders, FIELDNAME_PARTNERID));
        List<dmpl__TaxGroupRule__c> applicableTaxGroups = queryTaxGroups(repairOrderLines, repairOrders, lineItems, partnerAccountGroupIds);
        SecurityHelper.ensureCanWriteField('dmpl__TaxGroupId__c', 'dmpl__RepairOrderLine__c');
        for(RepairOrderLine__c repairOrderLine: repairOrderLines){
            if(repairOrderLine.TaxGroupId__c != null){
                continue;
            }
            for(dmpl__TaxGroupRule__c taxGroup : applicableTaxGroups){
                RepairOrder__c repairOrder = getRepairOrder(repairOrderLine, repairOrders);
                if(
                    repairOrder.dmpl__TaxSupplyType__c == taxGroup.dmpl__TaxSupplyType__c
                    && (repairOrder.PartnerAccountId__c == taxGroup.dmpl__TaxGroupId__r.dmpl__PartnerAccountId__c || taxGroup.dmpl__TaxGroupId__r.PartnerAccountId__c == null)
                    && (getPartnerAccountGroupId(repairOrder.PartnerAccountId__c, partnerAccountGroupIds) == taxGroup.dmpl__TaxGroupId__r.dmpl__PartnerAccountGroupId__c || taxGroup.dmpl__TaxGroupId__r.dmpl__PartnerAccountGroupId__c == null)
                    && (repairOrder.BranchId__c == taxGroup.dmpl__TaxGroupId__r.BranchId__c || taxGroup.dmpl__TaxGroupId__r.BranchId__c == null)
                    && (repairOrderLine.ItemId__c == taxGroup.ItemId__c || taxGroup.ItemId__c == null)
                    && (getItemTaxGroupId(lineItems, repairOrderLine.ItemId__c)  == taxGroup.dmpl__ItemGroupId__c || taxGroup.dmpl__ItemGroupId__c == null)
                    && (repairOrderLine.SKUId__c == taxGroup.SKUID__c || taxGroup.SKUID__c == null)
                    && (repairOrderLine.dmpl__ItemLotTypeId__c == taxGroup.dmpl__ItemLotTypeId__c || taxGroup.dmpl__ItemLotTypeId__c == null)
                    && (repairOrder.DocumentDate__c >= taxGroup.dmpl__DateEffectiveFrom__c || taxGroup.dmpl__DateEffectiveFrom__c == null)
                    && (repairOrder.DocumentDate__c <= taxGroup.dmpl__DateEffectiveTill__c || taxGroup.dmpl__DateEffectiveTill__c == null)
                ){
                    repairOrderLine.TaxGroupId__c = taxGroup.dmpl__TaxGroupId__c;
                    break;
                }
            }    
        }
    }

    @namespaceAccessible
    public static void setApplicableTaxGroups(List<SaleReturnLine__c> returnLines, List<SaleReturn__c> returnDocuments, List<Item__c> lineItems){
        List<Account> partnerAccountGroupIds = queryPartnerAccountGroupIds(DocumentHelper.extractIds(returnDocuments, FIELDNAME_PARTNERID));
        List<dmpl__TaxGroupRule__c> applicableTaxGroups = queryTaxGroups(returnLines, returnDocuments, lineItems, partnerAccountGroupIds);
        SecurityHelper.ensureCanCreateField('dmpl__TaxGroupId__c', 'dmpl__SaleReturnLine__c');
        for(SaleReturnLine__c returnLine: returnLines){
            if(returnLine.TaxGroupId__c != null){
                continue;
            }
            for(dmpl__TaxGroupRule__c taxGroup : applicableTaxGroups){
                SaleReturn__c returnDocument = getReturnDocument(returnLine, returnDocuments);
                if(
                    returnDocument.dmpl__TaxSupplyType__c == taxGroup.dmpl__TaxSupplyType__c
                    && (returnDocument.PartnerAccountId__c == taxGroup.dmpl__TaxGroupId__r.dmpl__PartnerAccountId__c || taxGroup.dmpl__TaxGroupId__r.PartnerAccountId__c == null)
                    && (getPartnerAccountGroupId(returnDocument.PartnerAccountId__c, partnerAccountGroupIds) == taxGroup.dmpl__TaxGroupId__r.dmpl__PartnerAccountGroupId__c || taxGroup.dmpl__TaxGroupId__r.dmpl__PartnerAccountGroupId__c == null)
                    && (returnDocument.BranchId__c == taxGroup.dmpl__TaxGroupId__r.BranchId__c || taxGroup.dmpl__TaxGroupId__r.BranchId__c == null)
                    && (returnLine.ItemId__c == taxGroup.ItemId__c || taxGroup.ItemId__c == null)
                    && (getItemTaxGroupId(lineItems, returnLine.ItemId__c)  == taxGroup.dmpl__ItemGroupId__c || taxGroup.dmpl__ItemGroupId__c == null)
                    && (returnLine.SKUId__c == taxGroup.SKUID__c || taxGroup.SKUID__c == null)
                    && (returnLine.dmpl__ItemLotTypeId__c == taxGroup.dmpl__ItemLotTypeId__c || taxGroup.dmpl__ItemLotTypeId__c == null)
                    && (returnDocument.DocumentDate__c >= taxGroup.dmpl__DateEffectiveFrom__c || taxGroup.dmpl__DateEffectiveFrom__c == null)
                    && (returnDocument.DocumentDate__c <= taxGroup.dmpl__DateEffectiveTill__c || taxGroup.dmpl__DateEffectiveTill__c == null)
                ){
                    returnLine.TaxGroupId__c = taxGroup.dmpl__TaxGroupId__c;
                    break;
                }
            }    
        }
    }

    @namespaceAccessible
    public static void setApplicableTaxGroups(List<BillReturnLine__c> returnLines, List<BillReturn__c> returnDocuments, List<Item__c> lineItems){
        List<Account> partnerAccountGroupIds = queryPartnerAccountGroupIds(DocumentHelper.extractIds(returnDocuments, FIELDNAME_PARTNERID));
        List<dmpl__TaxGroupRule__c> applicableTaxGroups = queryTaxGroups(returnLines, returnDocuments, lineItems, partnerAccountGroupIds);
        SecurityHelper.ensureCanCreateField('dmpl__TaxGroupId__c', 'dmpl__BillReturnLine__c');
        for(BillReturnLine__c returnLine: returnLines){
            if(returnLine.TaxGroupId__c != null){
                continue;
            }
            for(dmpl__TaxGroupRule__c taxGroup : applicableTaxGroups){
                BillReturn__c returnDocument = getReturnDocument(returnLine, returnDocuments);
                if(
                    returnDocument.dmpl__TaxSupplyType__c == taxGroup.dmpl__TaxSupplyType__c
                    && (returnDocument.PartnerAccountId__c == taxGroup.dmpl__TaxGroupId__r.dmpl__PartnerAccountId__c || taxGroup.dmpl__TaxGroupId__r.PartnerAccountId__c == null)
                    && (getPartnerAccountGroupId(returnDocument.PartnerAccountId__c, partnerAccountGroupIds) == taxGroup.dmpl__TaxGroupId__r.dmpl__PartnerAccountGroupId__c || taxGroup.dmpl__TaxGroupId__r.dmpl__PartnerAccountGroupId__c == null)
                    && (returnDocument.BranchId__c == taxGroup.dmpl__TaxGroupId__r.BranchId__c || taxGroup.dmpl__TaxGroupId__r.BranchId__c == null)
                    && (returnLine.ItemId__c == taxGroup.ItemId__c || taxGroup.ItemId__c == null)
                    && (getItemTaxGroupId(lineItems, returnLine.ItemId__c)  == taxGroup.dmpl__ItemGroupId__c || taxGroup.dmpl__ItemGroupId__c == null)
                    && (returnLine.SKUId__c == taxGroup.SKUID__c || taxGroup.SKUID__c == null)
                    && (returnLine.dmpl__ItemLotTypeId__c == taxGroup.dmpl__ItemLotTypeId__c || taxGroup.dmpl__ItemLotTypeId__c == null)
                    && (returnDocument.DocumentDate__c >= taxGroup.dmpl__DateEffectiveFrom__c || taxGroup.dmpl__DateEffectiveFrom__c == null)
                    && (returnDocument.DocumentDate__c <= taxGroup.dmpl__DateEffectiveTill__c || taxGroup.dmpl__DateEffectiveTill__c == null)
                ){
                    returnLine.TaxGroupId__c = taxGroup.dmpl__TaxGroupId__c;
                    break;
                }
            }    
        }
    }

    @testVisible
    private static ID queryTaxGroup(
        Id partnerId, 
        Id branchId, 
        Id itemId, 
        date documentDate,
        String taxSupplyType){
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__TaxGroupId__c'}, 'dmpl__TaxGroupRule__c');
        return [SELECT 
            dmpl__TaxGroupId__c
        FROM 
            dmpl__TaxGroupRule__c 
        WHERE 
        dmpl__TaxGroupId__r.dmpl__IsActive__c = true
        AND dmpl__TaxSupplyType__c = :taxSupplyType
        AND (dmpl__ItemId__c =:itemId OR dmpl__ItemId__c = null)
        AND (
                dmpl__ItemGroupId__c = :queryItemTaxGroupId(itemId) 
                OR dmpl__ItemGroupId__c = null
                OR dmpl__ItemGroupId__c IN :queryItemTaxGroupIds(itemId)) 
        AND (dmpl__TaxGroupId__r.dmpl__PartnerAccountId__c =:partnerId OR dmpl__TaxGroupId__r.dmpl__PartnerAccountId__c = null)
        AND (dmpl__TaxGroupId__r.dmpl__PartnerAccountGroupId__c =:queryPartnerAccountGroupId(partnerId) OR dmpl__TaxGroupId__r.dmpl__PartnerAccountGroupId__c = null)
        AND (dmpl__TaxGroupId__r.dmpl__BranchId__c =:branchId OR dmpl__TaxGroupId__r.dmpl__BranchId__c = null)
        AND (dmpl__DateEffectiveFrom__c <=:documentDate OR dmpl__DateEffectiveFrom__c = null)
        AND (dmpl__DateEffectiveTill__c >=:documentDate OR dmpl__DateEffectiveTill__c = null)
    ORDER BY 
        dmpl__TaxGroupId__r.dmpl__BranchId__c DESC NULLS LAST, 
        dmpl__TaxGroupId__r.dmpl__PartnerAccountId__c DESC NULLS LAST, 
        dmpl__TaxGroupId__r.dmpl__PartnerAccountGroupId__c DESC NULLS LAST, 
        dmpl__SKUId__c DESC NULLS LAST, 
        dmpl__ItemId__c DESC NULLS LAST,  
        dmpl__ItemGroupId__c DESC NULLS LAST, 
        dmpl__DateEffectiveFrom__c DESC NULLS LAST
        LIMIT 1]?.dmpl__TaxGroupId__c;
    }
    
    @testVisible
    private static ID queryTaxGroup(
        Id partnerId, 
        Id branchId, 
        Id itemId, 
        Id skuId, 
        date documentDate,
        String taxSupplyType){

        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__TaxGroupId__c'}, 'dmpl__TaxGroupRule__c');
        return [SELECT 
            dmpl__TaxGroupId__c
        FROM 
            dmpl__TaxGroupRule__c 
        WHERE  
            dmpl__TaxGroupId__r.dmpl__IsActive__c = true
            AND dmpl__TaxSupplyType__c = :taxSupplyType
            AND (dmpl__ItemId__c =:itemId OR dmpl__ItemId__c = null)
            AND (
                    dmpl__ItemGroupId__c = :queryItemTaxGroupId(itemId) 
                    OR dmpl__ItemGroupId__c = null
                    OR dmpl__ItemGroupId__c IN :queryItemTaxGroupIds(itemId)
                    )
            AND (dmpl__SKUId__c =:skuId OR dmpl__SKUId__c = null)
            AND (dmpl__TaxGroupId__r.dmpl__PartnerAccountId__c =:partnerId OR dmpl__TaxGroupId__r.dmpl__PartnerAccountId__c = null)
            AND (dmpl__TaxGroupId__r.dmpl__PartnerAccountGroupId__c =:queryPartnerAccountGroupId(partnerId) OR dmpl__TaxGroupId__r.dmpl__PartnerAccountGroupId__c = null)
            AND (dmpl__TaxGroupId__r.dmpl__BranchId__c =:branchId OR dmpl__TaxGroupId__r.dmpl__BranchId__c = null)
            AND (dmpl__DateEffectiveFrom__c <=:documentDate OR dmpl__DateEffectiveFrom__c = null)
            AND (dmpl__DateEffectiveTill__c >=:documentDate OR dmpl__DateEffectiveTill__c = null)
        ORDER BY 
        dmpl__TaxGroupId__r.dmpl__BranchId__c DESC NULLS LAST, dmpl__TaxGroupId__r.dmpl__PartnerAccountId__c DESC NULLS LAST, dmpl__TaxGroupId__r.dmpl__PartnerAccountGroupId__c DESC NULLS LAST, dmpl__SKUId__c DESC NULLS LAST, dmpl__ItemId__c DESC NULLS LAST, dmpl__ItemGroupId__c DESC NULLS LAST, dmpl__DateEffectiveFrom__c 
        DESC NULLS LAST
        LIMIT 1]?.dmpl__TaxGroupId__c;
    }

    private static List<dmpl__TaxGroupRule__c> queryTaxGroups(
        List<SObject> lines, 
        List<SObject> documents, 
        List<Item__c> lineItems, 
        List<Account> partnerAccountGroupIds){
        
        List<Id> itemIds = DocumentHelper.extractIds(lines, FIELDNAME_ITEMID);
        date minDocumentDate = getMinDocumentDate(documents);
        
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__TaxGroupId__c','dmpl__DateEffectiveFrom__c','dmpl__ItemId__c','dmpl__ItemGroupId__c','dmpl__SKUId__c','dmpl__ItemLotTypeId__c'}, 'dmpl__TaxGroupRule__c');
        return [SELECT 
            dmpl__TaxGroupId__c,
            dmpl__TaxGroupId__r.dmpl__PartnerAccountId__c,
            dmpl__TaxGroupId__r.dmpl__PartnerAccountGroupId__c,
            dmpl__TaxGroupId__r.dmpl__BranchId__c,
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__ItemLotTypeId__c,
            dmpl__ItemGroupId__c,
            dmpl__DateEffectiveFrom__c,
            dmpl__DateEffectiveTill__c,
            dmpl__TaxSupplyType__c
        FROM 
            dmpl__TaxGroupRule__c 
        WHERE 
            dmpl__TaxGroupId__r.dmpl__IsActive__c = true
            AND (dmpl__ItemId__c IN :itemIds OR dmpl__ItemId__c = null)
            AND (dmpl__ItemGroupId__c IN :DocumentHelper.extractIds(lineItems, FIELDNAME_ITEM_ITEMTAXGROUPID) OR dmpl__ItemGroupId__c = null)
            AND (dmpl__SKUId__c =:DocumentHelper.extractIds(lines, FIELDNAME_SKUID) OR dmpl__SKUId__c = null)
            AND (dmpl__ItemLotTypeId__c =:DocumentHelper.extractIds(lines, FIELDNAME_ITEMLOTTYPEID) OR dmpl__ItemLotTypeId__c = null)
            AND (dmpl__TaxGroupId__r.dmpl__PartnerAccountId__c =:DocumentHelper.extractIds(documents, FIELDNAME_PARTNERID) OR dmpl__TaxGroupId__r.dmpl__PartnerAccountId__c = null)
            AND (dmpl__TaxGroupId__r.dmpl__PartnerAccountGroupId__c IN:DocumentHelper.extractIds(partnerAccountGroupIds,FIELDNAME_PARTNER_ACCOUNTGROUP_ID) OR dmpl__TaxGroupId__r.dmpl__PartnerAccountGroupId__c = null)
            AND (dmpl__TaxGroupId__r.dmpl__BranchId__c =:DocumentHelper.extractIds(documents, FIELDNAME_BRANCHID) OR dmpl__TaxGroupId__r.dmpl__BranchId__c = null)
            AND (dmpl__DateEffectiveFrom__c <=:minDocumentDate OR dmpl__DateEffectiveFrom__c = null)
            AND (dmpl__DateEffectiveTill__c >=:minDocumentDate OR dmpl__DateEffectiveTill__c = null)
        ORDER BY 
            dmpl__TaxGroupId__r.dmpl__SequenceNumber__c
            DESC NULLS LAST];
    }

    private static Id queryItemTaxGroupId(Id itemId){

        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__TaxItemGroupId__c'}, 'dmpl__Item__c');
        return [
            SELECT 
                dmpl__TaxItemGroupId__c 
            FROM 
                dmpl__Item__c
            WHERE
                ID=:itemId]?.dmpl__TaxItemGroupId__c;
    }


    private static List<Id> queryItemTaxGroupIds(Id itemId){

        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__TaxItemGroupId__c'}, 'dmpl__Item__c');
        return CollectionHelper.extractIds([
            SELECT 
                dmpl__ItemGroupId__c ItemGroupId
            FROM 
                dmpl__ItemGroupMember__c
            WHERE
                dmpl__ItemId__c=:itemId
            GROUP BY 
                dmpl__ItemGroupId__c], 'ItemGroupId');
    }

    private static Id queryPartnerAccountGroupId(Id accountId){
        
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__PartnerTaxAccountGroupId__c'}, 'Account');
        return [
            SELECT 
                dmpl__PartnerTaxAccountGroupId__c 
            FROM 
                Account
            WHERE
                ID=:accountId]?.Id;
    }

    private static List<Account> queryPartnerAccountGroupIds(List<Id> accountIds){

        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__PartnerTaxAccountGroupId__c'}, 'Account');
        return [
            SELECT 
                Id,
                dmpl__PartnerTaxAccountGroupId__c 
            FROM 
                Account
            WHERE
                dmpl__PartnerTaxAccountGroupId__c != null
                AND ID IN :accountIds];
    }


    private static date getMinDocumentDate(List<SObject> documents){
        List<Date> documentDates = new List<Date>();
        for(SObject document : documents){
            documentDates.add((Date)document.get(FIELDNAME_DOCUMENT_DATE));
        }
        if(documentDates.size()>0){
            documentDates.sort();
            return documentDates[0];
        }
        return null;
    }

    private static SaleOrder__c getSaleOrder(SaleOrderLine__c saleOrderLine, List<SaleOrder__c> ofSaleOrders){
        for(SaleOrder__c saleOrder : ofSaleOrders){
            if(saleOrderLine.SaleOrderId__c == saleOrder.Id){
                return saleOrder;
            }
        }
        return null;
    }

    private static SaleInvoice__c getSaleInvoice(SaleInvoiceLine__c saleInvoiceLine, List<SaleInvoice__c> ofSaleInvoices){
        for(SaleInvoice__c saleInvoice : ofSaleInvoices){
            if(saleInvoiceLine.SaleInvoiceId__c == saleInvoice.Id){
                return saleInvoice;
            }
        }
        return null;
    }

    @testVisible
    private static PurchaseOrder__c getPurchaseOrder(PurchaseOrderLine__c purchaseOrderLine, List<PurchaseOrder__c> purchaseOrders){
        for(PurchaseOrder__c purchaseOrder : purchaseOrders){
            if(purchaseOrderLine.PurchaseOrderId__c == purchaseOrder.Id){
                return purchaseOrder;
            }
        }
        return null;
    }

    @testVisible
    private static Bill__c getPurchaseInvoice(BillLine__c purchaseInvoiceLine, List<Bill__c> purchaseInvoices){
        for(Bill__c purchaseInvoice : purchaseInvoices){
            if(purchaseInvoiceLine.PurchaseInvoiceId__c == purchaseInvoice.Id){
                return purchaseInvoice;
            }
        }
        return null;
    }

    @testVisible
    private static ServiceRequest__c getServiceRequest(ServiceRequestLine__c serviceRequestLine, List<ServiceRequest__c> serviceRequests){
        for(ServiceRequest__c serviceRequest : serviceRequests){
            if(serviceRequestLine.ServiceRequestId__c == serviceRequest.Id){
                return serviceRequest;
            }
        }
        return null;
    }
    
    @testVisible
    private static DeliveryOrder__c getDeliveryOrder(DeliveryOrderLine__c deliveryOrderLine, List<DeliveryOrder__c> deliveryOrders){
        for(DeliveryOrder__c deliveryOrder : deliveryOrders){
            if(deliveryOrderLine.dmpl__DeliveryId__c == deliveryOrder.Id){
                return deliveryOrder;
            }
        }
        return null;
    }

    @testVisible
    private static Quote__c getQuote(QuoteLine__c quoteLine, List<Quote__c> quotes){
        for(Quote__c quote : quotes){
            if(quoteLine.QuoteId__c == quote.Id){
                return quote;
            }
        }
        return null;
    }

    @testVisible
    private static RepairOrder__c getRepairOrder(RepairOrderLine__c repairOrderLine, List<RepairOrder__c> repairOrders){
        for(RepairOrder__c repairOrder : repairOrders){
            if(repairOrderLine.RepairOrderId__c == repairOrder.Id){
                return repairOrder;
            }
        }
        return null;
    }

    @testVisible
    private static SaleReturn__c getReturnDocument(SaleReturnLine__c returnLine, List<SaleReturn__c> returnDocuments){
        for(SaleReturn__c returnDocument : returnDocuments){
            if(returnLine.SaleReturnId__c == returnDocument.Id){
                return returnDocument;
            }
        }
        return null;
    }

    @testVisible
    private static BillReturn__c getReturnDocument(BillReturnLine__c returnLine, List<BillReturn__c> returnDocuments){
        for(BillReturn__c returnDocument : returnDocuments){
            if(returnLine.BillReturnId__c == returnDocument.Id){
                return returnDocument;
            }
        }
        return null;
    }

    private static Id getItemTaxGroupId(List<dmpl__Item__c> lineItems, Id itemId){
        for(dmpl__Item__c item : lineItems){
            if(item.Id == itemId){
                return item.dmpl__TaxItemGroupId__c;
            }
        }
        return null;
    }

    private static Id getPartnerAccountGroupId(Id partnerAccountId, List<Account> partnerAccountGroupIds){
        for(Account account : partnerAccountGroupIds){
            if(account.Id == partnerAccountId){
                return account.dmpl__PartnerTaxAccountGroupId__c;
            }
        }
        return null;
    }
}