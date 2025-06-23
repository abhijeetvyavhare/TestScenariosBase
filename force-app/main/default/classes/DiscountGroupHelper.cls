@namespaceAccessible
public with sharing class DiscountGroupHelper {

    public static final string DISCOUNTTYPE_SALE = 'Sale Price';
    public static final string DISCOUNTTYPE_PURCHASE = 'Purchase Price';

    private static final string FIELDNAME_SALEORDERLINE_ITEMID = 'dmpl__ItemId__c';
    private static final string FIELDNAME_SALEORDERLINE_SKUID = 'dmpl__SKUId__c';
    private static final string FIELDNAME_SALEORDER_DOCUMENTDATE = 'dmpl__DocumentDate__c';
    private static final string FIELDNAME_SALEORDER_PARTNERID = 'dmpl__PartnerAccountId__c';
    private static final string FIELDNAME_SALEORDER_CUSTOMERID = 'dmpl__AccountId__c';
    private static final string FIELDNAME_ACCOUNT_PARTNERACCOUNTGROUPID = 'dmpl__PartnerPriceAccountGroupId__c';
    private static final string FIELDNAME_ACCOUNT_CUSTOMERACCOUNTGROUPID = 'dmpl__CustomerPriceAccountGroupId__c';
    private static final string FIELDNAME_ACCOUNT_ACCOUNTGROUPID = 'dmpl__AccountGroupId__c';
    private static final string FIELDNAME_SALEORDER_ACCOUNTID = 'dmpl__AccountId__c';
    private static final string FIELDNAME_SALEORDER_BRANCHID = 'dmpl__BranchId__c';
    private static final string FIELDNAME_SALEORDER_DISCOUNTGROUPID = 'dmpl__DiscountGroupId__c';

    @namespaceAccessible
    public static Id getDefaultDiscountGroupId(String discountType, Id accountId, Id partnerId, Id branchId, date documentDate){
        return queryDefaultDiscountGroupId(discountType, accountId, partnerId, branchId, documentDate);
    }

    @namespaceAccessible
    public static Double getApplicableDiscount(Id discountGroupId, Id itemId, Id skuId, date documentDate){
        if(skuId == null){
            return queryDiscount(discountGroupId, itemId, documentDate);
        } else {
            return queryDiscount(discountGroupId, itemId, skuId, documentDate);
        }
    }

    @namespaceAccessible
    public static void setDefaultDiscountGroupIds(List<SaleOrder__c> ofSaleOrders){
        List<dmpl__AccountGroupMember__c> partnerAccountGroupIds = queryDiscountAccountGroupMembers(DocumentHelper.extractIds(ofSaleOrders, FIELDNAME_SALEORDER_PARTNERID));
        List<dmpl__AccountGroupMember__c> customerAccountGroupIds = queryDiscountAccountGroupMembers(DocumentHelper.extractIds(ofSaleOrders, FIELDNAME_SALEORDER_CUSTOMERID));
        List<dmpl__DiscountGroup__c> discountGroups = queryDefaultDiscountGroupIds(DISCOUNTTYPE_SALE, 
                                                            DocumentHelper.extractIds(ofSaleOrders,FIELDNAME_SALEORDER_BRANCHID),
                                                            DocumentHelper.extractIds(ofSaleOrders, FIELDNAME_SALEORDER_PARTNERID),
                                                            partnerAccountGroupIds, 
                                                            customerAccountGroupIds);
        SecurityHelper.ensureCanWriteField('dmpl__DiscountGroupId__c', 'dmpl__SaleOrder__c');
        for(SaleOrder__c saleOrder: ofSaleOrders){
            if(saleOrder.dmpl__DiscountGroupId__c != null){
                continue;
            }
            for(dmpl__DiscountGroup__c discountGroup : discountGroups){
                if(
                    (saleOrder.PartnerAccountId__c == discountGroup.PartnerAccountId__c || discountGroup.PartnerAccountId__c == null)
                    && (saleOrder.BranchId__c == discountGroup.BranchId__c || discountGroup.BranchId__c == null)
                    && (discountGroup.dmpl__PartnerAccountGroupId__c == getAccountGroupId(saleOrder.dmpl__PartnerAccountId__c, partnerAccountGroupIds) || discountGroup.dmpl__PartnerAccountGroupId__c == null)
                    && (discountGroup.dmpl__CustomerAccountGroupId__c == getAccountGroupId(saleOrder.dmpl__AccountId__c, customerAccountGroupIds) || discountGroup.dmpl__CustomerAccountGroupId__c == null)){

                        saleOrder.dmpl__DiscountGroupId__c = discountGroup.Id;
                        break;
                }
            }
        }
    }

    @namespaceAccessible
    public static void setDefaultDiscountGroupIds(List<SaleInvoice__c> ofSaleInvoices){
        List<dmpl__AccountGroupMember__c> partnerAccountGroupIds = queryDiscountAccountGroupMembers(DocumentHelper.extractIds(ofSaleInvoices, FIELDNAME_SALEORDER_PARTNERID));
        List<dmpl__AccountGroupMember__c> customerAccountGroupIds = queryDiscountAccountGroupMembers(DocumentHelper.extractIds(ofSaleInvoices, FIELDNAME_SALEORDER_CUSTOMERID));
        List<dmpl__DiscountGroup__c> discountGroups = queryDefaultDiscountGroupIds(DISCOUNTTYPE_SALE, 
                                                                            DocumentHelper.extractIds(ofSaleInvoices,FIELDNAME_SALEORDER_BRANCHID),
                                                                            DocumentHelper.extractIds(ofSaleInvoices, FIELDNAME_SALEORDER_PARTNERID),
                                                                            partnerAccountGroupIds, 
                                                                            customerAccountGroupIds);
        SecurityHelper.ensureCanWriteField('dmpl__DiscountGroupId__c', 'dmpl__SaleInvoice__c');
        for(SaleInvoice__c saleInvoice: ofSaleInvoices){
            if(saleInvoice.dmpl__DiscountGroupId__c != null){
                continue;
            }
            for(dmpl__DiscountGroup__c discountGroup : discountGroups){
                if(
                    (saleInvoice.PartnerAccountId__c == discountGroup.PartnerAccountId__c || discountGroup.PartnerAccountId__c == null)
                    && (saleInvoice.BranchId__c == discountGroup.BranchId__c || discountGroup.BranchId__c == null)
                    && (discountGroup.dmpl__PartnerAccountGroupId__c == getAccountGroupId(saleInvoice.dmpl__PartnerAccountId__c, partnerAccountGroupIds) || discountGroup.dmpl__PartnerAccountGroupId__c == null)
                    && (discountGroup.dmpl__CustomerAccountGroupId__c == getAccountGroupId(saleInvoice.dmpl__AccountId__c, customerAccountGroupIds) || discountGroup.dmpl__CustomerAccountGroupId__c == null)){

                        saleInvoice.dmpl__DiscountGroupId__c = discountGroup.Id;
                        break;
                }
            }
        }
    }

    @namespaceAccessible
    public static void setDefaultDiscountGroupIds(List<PurchaseOrder__c> ofPurchaseOrders){
        List<dmpl__AccountGroupMember__c> partnerAccountGroupIds = queryDiscountAccountGroupMembers(DocumentHelper.extractIds(ofPurchaseOrders, FIELDNAME_SALEORDER_PARTNERID));
        List<dmpl__DiscountGroup__c> discountGroups = queryDefaultDiscountGroupIds(DISCOUNTTYPE_PURCHASE, 
                                                                DocumentHelper.extractIds(ofPurchaseOrders,FIELDNAME_SALEORDER_BRANCHID),
                                                                DocumentHelper.extractIds(ofPurchaseOrders, FIELDNAME_SALEORDER_PARTNERID),
                                                                partnerAccountGroupIds, 
                                                                new List<dmpl__AccountGroupMember__c>());
        SecurityHelper.ensureCanWriteField('dmpl__DiscountGroupId__c', 'dmpl__PurchaseOrder__c');
        for(PurchaseOrder__c purchaseOrder: ofPurchaseOrders){
            if(purchaseOrder.dmpl__DiscountGroupId__c != null){
                continue;
            }
            for(dmpl__DiscountGroup__c discountGroup : discountGroups){
                if(
                    (purchaseOrder.PartnerAccountId__c == discountGroup.PartnerAccountId__c || discountGroup.PartnerAccountId__c == null)
                    && (purchaseOrder.BranchId__c == discountGroup.BranchId__c || discountGroup.BranchId__c == null)
                    && (discountGroup.dmpl__PartnerAccountGroupId__c == getAccountGroupId(purchaseOrder.dmpl__PartnerAccountId__c, partnerAccountGroupIds) || discountGroup.dmpl__PartnerAccountGroupId__c == null)){

                        purchaseOrder.dmpl__DiscountGroupId__c = discountGroup.Id;
                        break;
                }
            }
        }
    }

    @namespaceAccessible
    public static void setDefaultDiscountGroupIds(List<dmpl__Bill__c> ofBills){
        List<dmpl__AccountGroupMember__c> partnerAccountGroupIds = queryDiscountAccountGroupMembers(DocumentHelper.extractIds(ofBills, FIELDNAME_SALEORDER_PARTNERID));
        List<dmpl__DiscountGroup__c> discountGroups = queryDefaultDiscountGroupIds(DISCOUNTTYPE_PURCHASE, 
                                                                        DocumentHelper.extractIds(ofBills,FIELDNAME_SALEORDER_BRANCHID),
                                                                        DocumentHelper.extractIds(ofBills, FIELDNAME_SALEORDER_PARTNERID),
                                                                        partnerAccountGroupIds, 
                                                                        new List<dmpl__AccountGroupMember__c>());
        SecurityHelper.ensureCanWriteField('dmpl__DiscountGroupId__c', 'dmpl__Bill__c');
        for(dmpl__Bill__c bill: ofBills){
            if(bill.dmpl__DiscountGroupId__c != null){
                continue;
            }
            for(dmpl__DiscountGroup__c discountGroup : discountGroups){
                if(
                    (bill.PartnerAccountId__c == discountGroup.PartnerAccountId__c || discountGroup.PartnerAccountId__c == null)
                    && (bill.BranchId__c == discountGroup.BranchId__c || discountGroup.BranchId__c == null)
                    && (discountGroup.dmpl__PartnerAccountGroupId__c == getAccountGroupId(bill.dmpl__PartnerAccountId__c, partnerAccountGroupIds) 
                            || discountGroup.dmpl__PartnerAccountGroupId__c == null)){

                        bill.dmpl__DiscountGroupId__c = discountGroup.Id;
                        break;
                }
            }
        }
    }

    @namespaceAccessible
    public static void setDefaultDiscountGroupIds(List<RepairOrder__c> ofRepairOrders){
        List<dmpl__AccountGroupMember__c> partnerAccountGroupIds = queryDiscountAccountGroupMembers(DocumentHelper.extractIds(ofRepairOrders, FIELDNAME_SALEORDER_PARTNERID));
        List<dmpl__AccountGroupMember__c> customerAccountGroupIds = queryDiscountAccountGroupMembers(DocumentHelper.extractIds(ofRepairOrders, FIELDNAME_SALEORDER_CUSTOMERID));
        List<dmpl__DiscountGroup__c> discountGroups = queryDefaultDiscountGroupIds(DISCOUNTTYPE_SALE, 
                                                                    DocumentHelper.extractIds(ofRepairOrders,FIELDNAME_SALEORDER_BRANCHID),
                                                                    DocumentHelper.extractIds(ofRepairOrders, FIELDNAME_SALEORDER_PARTNERID),
                                                                    partnerAccountGroupIds, 
                                                                    customerAccountGroupIds);
        SecurityHelper.ensureCanWriteField('dmpl__DiscountGroupId__c', 'dmpl__SaleInvoice__c');
        for(RepairOrder__c repairOrder : ofRepairOrders){
            if(repairOrder.dmpl__DiscountGroupId__c != null){
                continue;
            }
            for(dmpl__DiscountGroup__c discountGroup : discountGroups){
                if(
                    (repairOrder.PartnerAccountId__c == discountGroup.PartnerAccountId__c || discountGroup.PartnerAccountId__c == null)
                    && (repairOrder.BranchId__c == discountGroup.BranchId__c || discountGroup.BranchId__c == null)
                    && (discountGroup.dmpl__PartnerAccountGroupId__c == getAccountGroupId(repairOrder.dmpl__PartnerAccountId__c, partnerAccountGroupIds) || discountGroup.dmpl__PartnerAccountGroupId__c == null)
                    && (discountGroup.dmpl__CustomerAccountGroupId__c == getAccountGroupId(repairOrder.dmpl__AccountId__c, customerAccountGroupIds) || discountGroup.dmpl__CustomerAccountGroupId__c == null)){

                        repairOrder.dmpl__DiscountGroupId__c = discountGroup.Id;
                        break;
                }
            }
        }
    }

    @namespaceAccessible
    public static void setDefaultDiscountGroupIds(List<Quote__c> ofQuotes){
        List<dmpl__AccountGroupMember__c> partnerAccountGroupIds = queryDiscountAccountGroupMembers(DocumentHelper.extractIds(ofQuotes, FIELDNAME_SALEORDER_PARTNERID));
        List<dmpl__AccountGroupMember__c> customerAccountGroupIds = queryDiscountAccountGroupMembers(DocumentHelper.extractIds(ofQuotes, FIELDNAME_SALEORDER_CUSTOMERID));
        List<dmpl__DiscountGroup__c> discountGroups = queryDefaultDiscountGroupIds(DISCOUNTTYPE_SALE, 
                                                                    DocumentHelper.extractIds(ofQuotes,FIELDNAME_SALEORDER_BRANCHID),
                                                                    DocumentHelper.extractIds(ofQuotes, FIELDNAME_SALEORDER_PARTNERID),
                                                                    partnerAccountGroupIds, 
                                                                    customerAccountGroupIds);
        SecurityHelper.ensureCanWriteField('dmpl__DiscountGroupId__c', 'dmpl__SaleInvoice__c');
        for(Quote__c quote : ofQuotes){
            if(quote.dmpl__DiscountGroupId__c != null){
                continue;
            }
            for(dmpl__DiscountGroup__c discountGroup : discountGroups){
                if(
                    (quote.PartnerAccountId__c == discountGroup.PartnerAccountId__c || discountGroup.PartnerAccountId__c == null)
                    && (quote.BranchId__c == discountGroup.BranchId__c || discountGroup.BranchId__c == null)
                    && (discountGroup.dmpl__PartnerAccountGroupId__c == getAccountGroupId(quote.dmpl__PartnerAccountId__c, partnerAccountGroupIds) || discountGroup.dmpl__PartnerAccountGroupId__c == null)
                    && (discountGroup.dmpl__CustomerAccountGroupId__c == getAccountGroupId(quote.dmpl__AccountId__c, customerAccountGroupIds) || discountGroup.dmpl__CustomerAccountGroupId__c == null)){

                        quote.dmpl__DiscountGroupId__c = discountGroup.Id;
                        break;
                }
            }
        }
    }

    @namespaceAccessible
    public static void setDefaultDiscountGroupIds(List<ServiceRequest__c> ofServiceRequests){
        List<dmpl__AccountGroupMember__c> partnerAccountGroupIds = queryDiscountAccountGroupMembers(DocumentHelper.extractIds(ofServiceRequests, FIELDNAME_SALEORDER_PARTNERID));
        List<dmpl__AccountGroupMember__c> customerAccountGroupIds = queryDiscountAccountGroupMembers(DocumentHelper.extractIds(ofServiceRequests, FIELDNAME_SALEORDER_CUSTOMERID));
        List<dmpl__DiscountGroup__c> discountGroups = queryDefaultDiscountGroupIds(DISCOUNTTYPE_SALE, 
                                                            DocumentHelper.extractIds(ofServiceRequests,FIELDNAME_SALEORDER_BRANCHID),
                                                            DocumentHelper.extractIds(ofServiceRequests, FIELDNAME_SALEORDER_PARTNERID),
                                                            partnerAccountGroupIds, 
                                                            customerAccountGroupIds);
        SecurityHelper.ensureCanWriteField('dmpl__DiscountGroupId__c', 'dmpl__ServiceRequest__c');
        for(ServiceRequest__c serviceRequest: ofServiceRequests){
            if(serviceRequest.dmpl__DiscountGroupId__c != null){
                continue;
            }
            for(dmpl__DiscountGroup__c discountGroup : discountGroups){
                if(
                    (serviceRequest.PartnerAccountId__c == discountGroup.PartnerAccountId__c || discountGroup.PartnerAccountId__c == null)
                    && (serviceRequest.BranchId__c == discountGroup.BranchId__c || discountGroup.BranchId__c == null)
                    && (discountGroup.dmpl__PartnerAccountGroupId__c == getAccountGroupId(serviceRequest.dmpl__PartnerAccountId__c, partnerAccountGroupIds) || discountGroup.dmpl__PartnerAccountGroupId__c == null)
                    && (discountGroup.dmpl__CustomerAccountGroupId__c == getAccountGroupId(serviceRequest.dmpl__AccountId__c, customerAccountGroupIds) || discountGroup.dmpl__CustomerAccountGroupId__c == null)){

                        serviceRequest.dmpl__DiscountGroupId__c = discountGroup.Id;
                        break;
                }
            }
        }
    }

    @namespaceAccessible
    public static void setDefaultDiscountGroupIds(List<DeliveryOrder__c> ofDeliveryOrders){
        List<dmpl__AccountGroupMember__c> partnerAccountGroupIds = queryDiscountAccountGroupMembers(DocumentHelper.extractIds(ofDeliveryOrders, FIELDNAME_SALEORDER_PARTNERID));
        List<dmpl__AccountGroupMember__c> customerAccountGroupIds = queryDiscountAccountGroupMembers(DocumentHelper.extractIds(ofDeliveryOrders, FIELDNAME_SALEORDER_CUSTOMERID));
        List<dmpl__DiscountGroup__c> discountGroups = queryDefaultDiscountGroupIds(DISCOUNTTYPE_SALE, 
                                                            DocumentHelper.extractIds(ofDeliveryOrders,FIELDNAME_SALEORDER_BRANCHID),
                                                            DocumentHelper.extractIds(ofDeliveryOrders, FIELDNAME_SALEORDER_PARTNERID),
                                                            partnerAccountGroupIds, 
                                                            customerAccountGroupIds);
        SecurityHelper.ensureCanWriteField('dmpl__DiscountGroupId__c', 'dmpl__DeliveryOrder__c');
        for(DeliveryOrder__c deliveryOrder: ofDeliveryOrders){
            if(deliveryOrder.dmpl__DiscountGroupId__c != null){
                continue;
            }
            for(dmpl__DiscountGroup__c discountGroup : discountGroups){
                if(
                    (deliveryOrder.PartnerAccountId__c == discountGroup.PartnerAccountId__c || discountGroup.PartnerAccountId__c == null)
                    && (deliveryOrder.BranchId__c == discountGroup.BranchId__c || discountGroup.BranchId__c == null)
                    && (discountGroup.dmpl__PartnerAccountGroupId__c == getAccountGroupId(deliveryOrder.dmpl__PartnerAccountId__c, partnerAccountGroupIds) || discountGroup.dmpl__PartnerAccountGroupId__c == null)
                    && (discountGroup.dmpl__CustomerAccountGroupId__c == getAccountGroupId(deliveryOrder.dmpl__AccountId__c, customerAccountGroupIds) || discountGroup.dmpl__CustomerAccountGroupId__c == null)){

                        deliveryOrder.dmpl__DiscountGroupId__c = discountGroup.Id;
                        break;
                }
            }
        }
    }

    @namespaceAccessible
    public static void setApplicableDiscounts(List<SaleOrderLine__c> saleOrderLines, List<SaleOrder__c> ofSaleOrders, List<Item__c> lineItems){
        List<dmpl__DiscountGroupRule__c> applicableDiscounts = queryDiscountRules(saleOrderLines, ofSaleOrders, lineItems);
        List<dmpl__ItemGroupMember__c> itemGroupIds = queryDiscountItemGroupMembers(DocumentHelper.extractIds(saleOrderLines, FIELDNAME_SALEORDERLINE_ITEMID));
        SecurityHelper.ensureCanWriteField('dmpl__ContractDiscount__c', 'dmpl__SaleOrderLine__c');
        for(SaleOrderLine__c orderLine: saleOrderLines){
            for(dmpl__DiscountGroupRule__c discountRule : applicableDiscounts){
                SaleOrder__c saleOrder = getSaleOrder(orderLine, ofSaleOrders);
                if(
                    (orderLine.ItemId__c == discountRule.ItemId__c || discountRule.ItemId__c == null)
                    && (orderLine.SKUId__c == discountRule.SKUID__c || discountRule.SKUID__c == null)
                    && (saleOrder.dmpl__DiscountGroupId__c == discountRule.dmpl__DiscountGroupId__c || discountRule.dmpl__DiscountGroupId__r?.dmpl__IsDefault__c)
                    && (discountRule.dmpl__ItemGroupId__c == getItemGroupId(orderLine.dmpl__ItemId__c, itemGroupIds) || discountRule.dmpl__ItemGroupId__c == null)
                    && (saleOrder.DocumentDate__c >= discountRule.dmpl__DateEffectiveFrom__c || discountRule.dmpl__DateEffectiveFrom__c == null)
                    && (saleOrder.DocumentDate__c <= discountRule.dmpl__DateEffectiveTill__c || discountRule.dmpl__DateEffectiveTill__c == null)
                ){
                    orderLine.dmpl__ContractDiscount__c = discountRule.dmpl__DiscountPercent__c;    
                    orderLine.dmpl__DiscountGroupRuleId__c = discountRule.Id;
                    break;
                }
            }    
        }
    }

    @namespaceAccessible
    public static void setApplicableDiscounts(List<SaleInvoiceLine__c> saleInvoiceLines, List<SaleInvoice__c> ofSaleInvoices, List<Item__c> lineItems){
        List<Id> partnerAccountIds = DocumentHelper.extractIds(ofSaleInvoices, FIELDNAME_SALEORDER_PARTNERID);
        List<dmpl__AccountGroupMember__c> partnerAccountGroupIds = queryDiscountAccountGroupMembers(partnerAccountIds);
        List<dmpl__AccountGroupMember__c> customerAccountGroupIds = queryDiscountAccountGroupMembers(DocumentHelper.extractIds(ofSaleInvoices, FIELDNAME_SALEORDER_CUSTOMERID));

        List<dmpl__DiscountGroupRule__c> applicableDiscounts = queryDiscountRules(DocumentHelper.extractIds(saleInvoiceLines, FIELDNAME_SALEORDERLINE_ITEMID),
                                                                DocumentHelper.extractIds(saleInvoiceLines, FIELDNAME_SALEORDERLINE_SKUID),
                                                                getMinDocumentDate(ofSaleInvoices),
                                                                lineItems,
                                                                partnerAccountIds,
                                                                DocumentHelper.extractIds(ofSaleInvoices, FIELDNAME_SALEORDER_BRANCHID),
                                                                partnerAccountGroupIds,
                                                                customerAccountGroupIds);

        List<dmpl__ItemGroupMember__c> itemGroupIds = queryDiscountItemGroupMembers(DocumentHelper.extractIds(saleInvoiceLines, FIELDNAME_SALEORDERLINE_ITEMID));
        SecurityHelper.ensureCanWriteField('dmpl__ContractDiscount__c', 'dmpl__SaleInvoiceLine__c');
        for(SaleInvoiceLine__c invoiceLine: saleInvoiceLines){
            for(dmpl__DiscountGroupRule__c discountRule : applicableDiscounts){
                SaleInvoice__c saleInvoice = getSaleInvoice(invoiceLine, ofSaleInvoices);
                if(
                    (invoiceLine.ItemId__c == discountRule.ItemId__c || discountRule.ItemId__c == null)
                    && (invoiceLine.SKUId__c == discountRule.SKUID__c || discountRule.SKUID__c == null)
                    && (saleInvoice.dmpl__DiscountGroupId__c == discountRule.dmpl__DiscountGroupId__c || discountRule.dmpl__DiscountGroupId__r?.dmpl__IsDefault__c)
                    && (discountRule.dmpl__ItemGroupId__c == getItemGroupId(invoiceLine.dmpl__ItemId__c, itemGroupIds) || discountRule.dmpl__ItemGroupId__c == null)
                    && (saleInvoice.DocumentDate__c >= discountRule.dmpl__DateEffectiveFrom__c || discountRule.dmpl__DateEffectiveFrom__c == null)
                    && (saleInvoice.DocumentDate__c <= discountRule.dmpl__DateEffectiveTill__c || discountRule.dmpl__DateEffectiveTill__c == null)
                ){
                    invoiceLine.dmpl__ContractDiscount__c = discountRule.dmpl__DiscountPercent__c;
                    invoiceLine.dmpl__DiscountGroupRuleId__c = discountRule.Id;
                    break;
                }
            }    
        }
    }

    @namespaceAccessible
    public static void setApplicableDiscounts(List<PurchaseOrderLine__c> purchaseOrderLines, List<PurchaseOrder__c> ofPurchaseOrders, List<Item__c> lineItems){
        List<dmpl__DiscountGroupRule__c> applicableDiscounts = queryDiscountRules(DocumentHelper.extractIds(purchaseOrderLines, FIELDNAME_SALEORDERLINE_ITEMID),
                                                                DocumentHelper.extractIds(purchaseOrderLines, FIELDNAME_SALEORDERLINE_SKUID),
                                                                getMinDocumentDate(ofPurchaseOrders),
                                                                lineItems,
                                                                DocumentHelper.extractIds(ofPurchaseOrders, FIELDNAME_SALEORDER_DISCOUNTGROUPID));

        List<dmpl__ItemGroupMember__c> itemGroupIds = queryDiscountItemGroupMembers(DocumentHelper.extractIds(purchaseOrderLines, FIELDNAME_SALEORDERLINE_ITEMID));
        SecurityHelper.ensureCanWriteField('dmpl__ContractDiscount__c', 'dmpl__PurchaseOrderLine__c');
        for(PurchaseOrderLine__c orderLine: purchaseOrderLines){
            for(dmpl__DiscountGroupRule__c discountRule : applicableDiscounts){
                PurchaseOrder__c purchaseOrder = getPurchaseOrder(orderLine, ofPurchaseOrders);
                if(
                    (orderLine.ItemId__c == discountRule.ItemId__c || discountRule.ItemId__c == null)
                    && (orderLine.SKUId__c == discountRule.SKUID__c || discountRule.SKUID__c == null)
                    && (purchaseOrder.dmpl__DiscountGroupId__c == discountRule.dmpl__DiscountGroupId__c || discountRule.dmpl__DiscountGroupId__r?.dmpl__IsDefault__c)
                    && (discountRule.dmpl__ItemGroupId__c == getItemGroupId(orderLine.dmpl__ItemId__c, itemGroupIds) || discountRule.dmpl__ItemGroupId__c == null)
                    && (purchaseOrder.DocumentDate__c >= discountRule.dmpl__DateEffectiveFrom__c || discountRule.dmpl__DateEffectiveFrom__c == null)
                    && (purchaseOrder.DocumentDate__c <= discountRule.dmpl__DateEffectiveTill__c || discountRule.dmpl__DateEffectiveTill__c == null)
                ){
                    orderLine.dmpl__ContractDiscount__c = discountRule.dmpl__DiscountPercent__c;
                    break;
                }
            }    
        }
    }

    @namespaceAccessible
    public static void setApplicableDiscounts(List<dmpl__BillLine__c> billLines, List<Bill__c> ofBills, List<Item__c> lineItems){
        List<dmpl__DiscountGroupRule__c> applicableDiscounts = queryDiscountRules(DocumentHelper.extractIds(billLines, FIELDNAME_SALEORDERLINE_ITEMID),
                                                                DocumentHelper.extractIds(billLines, FIELDNAME_SALEORDERLINE_SKUID),
                                                                getMinDocumentDate(ofBills),
                                                                lineItems,
                                                                DocumentHelper.extractIds(ofBills, FIELDNAME_SALEORDER_DISCOUNTGROUPID));

        List<dmpl__ItemGroupMember__c> itemGroupIds = queryDiscountItemGroupMembers(DocumentHelper.extractIds(billLines, FIELDNAME_SALEORDERLINE_ITEMID));
        SecurityHelper.ensureCanWriteField('dmpl__ContractDiscount__c', 'dmpl__BillLine__c');
        for(dmpl__BillLine__c billLine: billLines){
            for(dmpl__DiscountGroupRule__c discountRule : applicableDiscounts){
                Bill__c bill = getPurchaseInvoice(billLine, ofBills);
                if(
                    (billLine.ItemId__c == discountRule.ItemId__c || discountRule.ItemId__c == null)
                    && (billLine.SKUId__c == discountRule.SKUID__c || discountRule.SKUID__c == null)
                    && (bill.dmpl__DiscountGroupId__c == discountRule.dmpl__DiscountGroupId__c || discountRule.dmpl__DiscountGroupId__r?.dmpl__IsDefault__c)
                    && (discountRule.dmpl__ItemGroupId__c == getItemGroupId(billLine.dmpl__ItemId__c, itemGroupIds) || discountRule.dmpl__ItemGroupId__c == null)
                    && (bill.DocumentDate__c >= discountRule.dmpl__DateEffectiveFrom__c || discountRule.dmpl__DateEffectiveFrom__c == null)
                    && (bill.DocumentDate__c <= discountRule.dmpl__DateEffectiveTill__c || discountRule.dmpl__DateEffectiveTill__c == null)
                ){
                    billLine.dmpl__ContractDiscount__c = discountRule.dmpl__DiscountPercent__c;
                    break;
                }
            }    
        }
    }

    @namespaceAccessible
    public static void setApplicableDiscounts(List<dmpl__RepairOrderLine__c> repairOrderLines, List<RepairOrder__c> ofRepairOrders, List<Item__c> lineItems){
        List<dmpl__DiscountGroupRule__c> applicableDiscounts = queryDiscountRules(DocumentHelper.extractIds(repairOrderLines, FIELDNAME_SALEORDERLINE_ITEMID),
                                                                DocumentHelper.extractIds(repairOrderLines, FIELDNAME_SALEORDERLINE_SKUID),
                                                                getMinDocumentDate(ofRepairOrders),
                                                                lineItems,
                                                                DocumentHelper.extractIds(ofRepairOrders, FIELDNAME_SALEORDER_DISCOUNTGROUPID));

        List<dmpl__ItemGroupMember__c> itemGroupIds = queryDiscountItemGroupMembers(DocumentHelper.extractIds(repairOrderLines, FIELDNAME_SALEORDERLINE_ITEMID));
        SecurityHelper.ensureCanWriteField('dmpl__ContractDiscount__c', 'dmpl__BillLine__c');
        for(dmpl__RepairOrderLine__c repairOrderLine: repairOrderLines){
            for(dmpl__DiscountGroupRule__c discountRule : applicableDiscounts){
                RepairOrder__c repairOrder = getRepairOrder(repairOrderLine, ofRepairOrders);
                if(
                    (repairOrderLine.ItemId__c == discountRule.ItemId__c || discountRule.ItemId__c == null)
                    && (repairOrderLine.SKUId__c == discountRule.SKUID__c || discountRule.SKUID__c == null)
                    && (repairOrder.dmpl__DiscountGroupId__c == discountRule.dmpl__DiscountGroupId__c || discountRule.dmpl__DiscountGroupId__r?.dmpl__IsDefault__c)
                    && (discountRule.dmpl__ItemGroupId__c == getItemGroupId(repairOrderLine.dmpl__ItemId__c, itemGroupIds) || discountRule.dmpl__ItemGroupId__c == null)
                    && (repairOrder.DocumentDate__c >= discountRule.dmpl__DateEffectiveFrom__c || discountRule.dmpl__DateEffectiveFrom__c == null)
                    && (repairOrder.DocumentDate__c <= discountRule.dmpl__DateEffectiveTill__c || discountRule.dmpl__DateEffectiveTill__c == null)
                ){
                    repairOrderLine.dmpl__ContractDiscount__c = discountRule.dmpl__DiscountPercent__c;
                    break;
                }
            }    
        }
    }

    @namespaceAccessible
    public static void setApplicableDiscounts(List<dmpl__QuoteLine__c> quoteLines, List<Quote__c> ofQuotes, List<Item__c> lineItems){
        List<dmpl__DiscountGroupRule__c> applicableDiscounts = queryDiscountRules(DocumentHelper.extractIds(quoteLines, FIELDNAME_SALEORDERLINE_ITEMID),
                                                                DocumentHelper.extractIds(quoteLines, FIELDNAME_SALEORDERLINE_SKUID),
                                                                getMinDocumentDate(ofQuotes),
                                                                lineItems,
                                                                DocumentHelper.extractIds(ofQuotes, FIELDNAME_SALEORDER_DISCOUNTGROUPID));

        List<dmpl__ItemGroupMember__c> itemGroupIds = queryDiscountItemGroupMembers(DocumentHelper.extractIds(quoteLines, FIELDNAME_SALEORDERLINE_ITEMID));
        SecurityHelper.ensureCanWriteField('dmpl__ContractDiscount__c', 'dmpl__QuoteLine__c');
        for(QuoteLine__c quoteLine: quoteLines){
            for(dmpl__DiscountGroupRule__c discountRule : applicableDiscounts){
                Quote__c quote = getQuote(quoteLine, ofQuotes);
                if(
                    (quoteLine.ItemId__c == discountRule.ItemId__c || discountRule.ItemId__c == null)
                    && (quoteLine.SKUId__c == discountRule.SKUID__c || discountRule.SKUID__c == null)
                    && (quote.dmpl__DiscountGroupId__c == discountRule.dmpl__DiscountGroupId__c || discountRule.dmpl__DiscountGroupId__r?.dmpl__IsDefault__c)
                    && (discountRule.dmpl__ItemGroupId__c == getItemGroupId(quoteLine.dmpl__ItemId__c, itemGroupIds) || discountRule.dmpl__ItemGroupId__c == null)
                    && (quote.DocumentDate__c >= discountRule.dmpl__DateEffectiveFrom__c || discountRule.dmpl__DateEffectiveFrom__c == null)
                    && (quote.DocumentDate__c <= discountRule.dmpl__DateEffectiveTill__c || discountRule.dmpl__DateEffectiveTill__c == null)
                ){
                    quoteLine.dmpl__ContractDiscount__c = discountRule.dmpl__DiscountPercent__c;
                    break;
                }
            }    
        }
    }

    @namespaceAccessible
    public static void setApplicableDiscounts(List<dmpl__ServiceRequestLine__c> serviceRequestLines, List<ServiceRequest__c> ofServiceRequests, List<Item__c> lineItems){
        List<dmpl__DiscountGroupRule__c> applicableDiscounts = queryDiscountRules(DocumentHelper.extractIds(serviceRequestLines, FIELDNAME_SALEORDERLINE_ITEMID),
                                                                DocumentHelper.extractIds(serviceRequestLines, FIELDNAME_SALEORDERLINE_SKUID),
                                                                getMinDocumentDate(ofServiceRequests),
                                                                lineItems,
                                                                DocumentHelper.extractIds(ofServiceRequests, FIELDNAME_SALEORDER_DISCOUNTGROUPID));

        List<dmpl__ItemGroupMember__c> itemGroupIds = queryDiscountItemGroupMembers(DocumentHelper.extractIds(serviceRequestLines, FIELDNAME_SALEORDERLINE_ITEMID));
        SecurityHelper.ensureCanWriteField('dmpl__ContractDiscount__c', 'dmpl__ServiceRequestLine__c');
        for(ServiceRequestLine__c serviceRequestLine: serviceRequestLines){
            for(dmpl__DiscountGroupRule__c discountRule : applicableDiscounts){
                ServiceRequest__c serviceRequest = getServiceRequest(serviceRequestLine, ofServiceRequests);
                if(
                    (serviceRequestLine.ItemId__c == discountRule.ItemId__c || discountRule.ItemId__c == null)
                    && (serviceRequestLine.SKUId__c == discountRule.SKUID__c || discountRule.SKUID__c == null)
                    && (serviceRequest.dmpl__DiscountGroupId__c == discountRule.dmpl__DiscountGroupId__c || discountRule.dmpl__DiscountGroupId__r?.dmpl__IsDefault__c)
                    && (discountRule.dmpl__ItemGroupId__c == getItemGroupId(serviceRequestLine.dmpl__ItemId__c, itemGroupIds) || discountRule.dmpl__ItemGroupId__c == null)
                    && (serviceRequest.DocumentDate__c >= discountRule.dmpl__DateEffectiveFrom__c || discountRule.dmpl__DateEffectiveFrom__c == null)
                    && (serviceRequest.DocumentDate__c <= discountRule.dmpl__DateEffectiveTill__c || discountRule.dmpl__DateEffectiveTill__c == null)
                ){
                    serviceRequestLine.dmpl__ContractDiscount__c = discountRule.dmpl__DiscountPercent__c;
                    break;
                }
            }    
        }
    }

    @namespaceAccessible
    public static void setApplicableDiscounts(List<dmpl__DeliveryOrderLine__c> deliveryOrderLines, List<DeliveryOrder__c> ofDeliveryOrders, List<Item__c> lineItems){
        List<dmpl__DiscountGroupRule__c> applicableDiscounts = queryDiscountRules(DocumentHelper.extractIds(deliveryOrderLines, FIELDNAME_SALEORDERLINE_ITEMID),
                                                                DocumentHelper.extractIds(deliveryOrderLines, FIELDNAME_SALEORDERLINE_SKUID),
                                                                getMinDocumentDate(ofDeliveryOrders),
                                                                lineItems,
                                                                DocumentHelper.extractIds(ofDeliveryOrders, FIELDNAME_SALEORDER_DISCOUNTGROUPID));

        List<dmpl__ItemGroupMember__c> itemGroupIds = queryDiscountItemGroupMembers(DocumentHelper.extractIds(deliveryOrderLines, FIELDNAME_SALEORDERLINE_ITEMID));
        SecurityHelper.ensureCanWriteField('dmpl__ContractDiscount__c', 'dmpl__DeliveryOrderLine__c');
        for(DeliveryOrderLine__c deliveryOrderLine: deliveryOrderLines){
            for(dmpl__DiscountGroupRule__c discountRule : applicableDiscounts){
                DeliveryOrder__c deliveryOrder = getDeliveryOrder(deliveryOrderLine, ofDeliveryOrders);
                if(
                    (deliveryOrderLine.ItemId__c == discountRule.ItemId__c || discountRule.ItemId__c == null)
                    && (deliveryOrderLine.SKUId__c == discountRule.SKUID__c || discountRule.SKUID__c == null)
                    && (deliveryOrder.dmpl__DiscountGroupId__c == discountRule.dmpl__DiscountGroupId__c || discountRule.dmpl__DiscountGroupId__r?.dmpl__IsDefault__c)
                    && (discountRule.dmpl__ItemGroupId__c == getItemGroupId(deliveryOrderLine.dmpl__ItemId__c, itemGroupIds) || discountRule.dmpl__ItemGroupId__c == null)
                    && (deliveryOrder.DocumentDate__c >= discountRule.dmpl__DateEffectiveFrom__c || discountRule.dmpl__DateEffectiveFrom__c == null)
                    && (deliveryOrder.DocumentDate__c <= discountRule.dmpl__DateEffectiveTill__c || discountRule.dmpl__DateEffectiveTill__c == null)
                ){
                    deliveryOrderLine.dmpl__ContractDiscount__c = discountRule.dmpl__DiscountPercent__c;
                    break;
                }
            }    
        }
    }

    private static List<dmpl__DiscountGroup__c> queryDefaultDiscountGroupIds(String discountType, 
                                                        // List<SaleOrder__c> ofSaleOrders, 
                                                        List<Id> branchIds,
                                                        List<Id> partnerAccountIds,
                                                        List<dmpl__AccountGroupMember__c> partnerAccountGroupIds, 
                                                        List<dmpl__AccountGroupMember__c> customerAccountGroupIds){

        // List<Id> branchIds = DocumentHelper.extractIds(ofSaleOrders, FIELDNAME_SALEORDER_BRANCHID);
        // List<Id> partnerAccountIds =  DocumentHelper.extractIds(ofSaleOrders, FIELDNAME_SALEORDER_PARTNERID);

        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__BranchId__c','dmpl__CustomerAccountGroupId__c','dmpl__PartnerAccountGroupId__c'}, 'dmpl__DiscountGroup__c');
        return [
                SELECT
                    Id,
                    dmpl__PartnerAccountId__c,
                    dmpl__BranchId__c,
                    dmpl__CustomerAccountGroupId__c,
                    dmpl__PartnerAccountGroupId__c
                FROM
                    dmpl__DiscountGroup__c
                WHERE
                    dmpl__DiscountType__c = :discountType
                    AND dmpl__IsActive__c = true
                    AND (dmpl__PartnerAccountId__c IN :partnerAccountIds OR dmpl__PartnerAccountId__c = null)
                    AND (dmpl__BranchId__c IN :branchIds OR dmpl__BranchId__c = null)
                    AND (dmpl__CustomerAccountGroupId__c IN:DocumentHelper.extractIds(customerAccountGroupIds, FIELDNAME_ACCOUNT_ACCOUNTGROUPID) OR dmpl__CustomerAccountGroupId__c = null)
                    AND (dmpl__PartnerAccountGroupId__c IN:DocumentHelper.extractIds(partnerAccountGroupIds, FIELDNAME_ACCOUNT_ACCOUNTGROUPID) OR dmpl__PartnerAccountGroupId__c = null)
                    // AND dmpl__IsDefault__c = true
                ORDER BY dmpl__BranchId__c DESC NULLS LAST, dmpl__PartnerAccountId__c DESC NULLS LAST, dmpl__PartnerAccountGroupId__c DESC NULLS LAST, dmpl__CustomerAccountGroupId__c DESC NULLS LAST];
    }

    private static Id queryDefaultDiscountGroupId(String priceType, Id accountId, Id partnerId, Id branchId, date documentDate){
        SecurityHelper.ensureCanReadFields(new string[]{'Id'}, 'dmpl__DiscountGroup__c');
        return [
                SELECT
                    Id
                FROM
                    dmpl__DiscountGroup__c
                WHERE
                    dmpl__DiscountType__c = :priceType
                    AND dmpl__IsActive__c = true 
                    AND (dmpl__PartnerAccountId__c =:partnerId OR dmpl__PartnerAccountId__c = null)
                    AND (dmpl__BranchId__c =:branchId OR dmpl__BranchId__c = null)
                    AND (dmpl__CustomerAccountGroupId__c =:queryAccountGroupId(accountId) OR dmpl__CustomerAccountGroupId__c = null)
                    AND (dmpl__PartnerAccountGroupId__c =:queryAccountGroupId(partnerId) OR dmpl__PartnerAccountGroupId__c = null)
                    AND dmpl__IsDefault__c = true
                ORDER BY dmpl__BranchId__c DESC NULLS LAST, dmpl__PartnerAccountId__c DESC NULLS LAST, dmpl__PartnerAccountGroupId__c DESC NULLS LAST, dmpl__CustomerAccountGroupId__c DESC NULLS LAST
                LIMIT 1]?.Id;
    }

    @TestVisible  
    private static Double queryDiscount(Id discountGroupId, Id itemId, date documentDate){

        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__DiscountPercent__c'}, 'dmpl__DiscountGroupRule__c');
        return [SELECT 
            dmpl__DiscountPercent__c
        FROM 
            dmpl__DiscountGroupRule__c 
        WHERE 
            (dmpl__ItemId__c =:itemId OR dmpl__ItemId__c = null)
            AND (dmpl__DateEffectiveFrom__c <=:documentDate OR dmpl__DateEffectiveFrom__c = null)
            AND (dmpl__DateEffectiveTill__c >=:documentDate OR dmpl__DateEffectiveTill__c = null)
        ORDER BY dmpl__ItemId__c DESC NULLS LAST, dmpl__DateEffectiveFrom__c DESC NULLS LAST
        LIMIT 1]?.dmpl__DiscountPercent__c;
    }
    
    @TestVisible   
    private static Double queryDiscount(Id priceListId, Id itemId, Id skuId, date documentDate){

        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__DiscountPercent__c'}, 'dmpl__DiscountGroupRule__c');
        return [SELECT 
            dmpl__DiscountPercent__c
        FROM 
            dmpl__DiscountGroupRule__c 
        WHERE 
            (dmpl__ItemId__c =:itemId OR dmpl__ItemId__c = null)
            AND (dmpl__SKUId__c =:skuId OR dmpl__SKUId__c = null)
            AND (dmpl__DateEffectiveFrom__c <=:documentDate OR dmpl__DateEffectiveFrom__c = null)
            AND (dmpl__DateEffectiveTill__c >=:documentDate OR dmpl__DateEffectiveTill__c = null)
        ORDER BY dmpl__ItemId__c DESC NULLS LAST, dmpl__SKUId__c DESC NULLS LAST, dmpl__DateEffectiveFrom__c DESC NULLS LAST
        LIMIT 1]?.dmpl__DiscountPercent__c;
    }

    private static List<dmpl__DiscountGroupRule__c> queryDiscountRules(List<SaleOrderLine__c> saleOrderLines, List<SaleOrder__c> ofSaleOrders, List<Item__c> lineItems){
        List<Id> itemIds = DocumentHelper.extractIds(saleOrderLines, FIELDNAME_SALEORDERLINE_ITEMID);
        date minDocumentDate = getMinDocumentDate(ofSaleOrders);
        List<Id> partnerAccountIds = DocumentHelper.extractIds(ofSaleOrders, FIELDNAME_SALEORDER_PARTNERID);
        List<Id> branchIds = DocumentHelper.extractIds(ofSaleOrders, FIELDNAME_SALEORDER_BRANCHID);
        List<dmpl__AccountGroupMember__c> partnerAccountGroupIds = queryDiscountAccountGroupMembers(partnerAccountIds);
        List<dmpl__AccountGroupMember__c> customerAccountGroupIds = queryDiscountAccountGroupMembers(DocumentHelper.extractIds(ofSaleOrders, FIELDNAME_SALEORDER_CUSTOMERID));

        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__ItemId__c','dmpl__SKUId__c','dmpl__DateEffectiveTill__c','dmpl__DiscountPercent__c','dmpl__DateEffectiveFrom__c'}, 'dmpl__DiscountGroupRule__c');
        return [SELECT 
            dmpl__ItemId__c,
            dmpl__ItemGroupId__c,
            dmpl__SKUId__c,
            dmpl__DiscountPercent__c,
            dmpl__DateEffectiveFrom__c,
            dmpl__DateEffectiveTill__c,
            dmpl__DiscountGroupId__c,
            dmpl__DiscountGroupId__r.dmpl__IsDefault__c
        FROM 
            dmpl__DiscountGroupRule__c 
        WHERE 
            (dmpl__ItemId__c IN :itemIds OR dmpl__ItemId__c = null)
            AND (dmpl__SKUId__c IN :DocumentHelper.extractIds(saleOrderLines, FIELDNAME_SALEORDERLINE_SKUID) OR dmpl__SKUId__c = null)
            AND (dmpl__DateEffectiveFrom__c <=:minDocumentDate OR dmpl__DateEffectiveFrom__c =null)
            AND (dmpl__DateEffectiveTill__c >=:minDocumentDate OR dmpl__DateEffectiveTill__c = null)

            AND (dmpl__DiscountGroupId__r.dmpl__PartnerAccountId__c IN :partnerAccountIds OR dmpl__DiscountGroupId__r.dmpl__PartnerAccountId__c = null)
            AND (dmpl__DiscountGroupId__r.dmpl__BranchId__c IN :branchIds OR dmpl__DiscountGroupId__r.dmpl__BranchId__c = null)
            AND (dmpl__DiscountGroupId__r.dmpl__CustomerAccountGroupId__c IN:DocumentHelper.extractIds(customerAccountGroupIds, FIELDNAME_ACCOUNT_ACCOUNTGROUPID) OR dmpl__DiscountGroupId__r.dmpl__CustomerAccountGroupId__c = null)
            AND (dmpl__DiscountGroupId__r.dmpl__PartnerAccountGroupId__c IN:DocumentHelper.extractIds(partnerAccountGroupIds, FIELDNAME_ACCOUNT_ACCOUNTGROUPID) OR dmpl__DiscountGroupId__r.dmpl__PartnerAccountGroupId__c = null)
        ORDER BY dmpl__ItemId__c DESC NULLS LAST, dmpl__SKUId__c DESC NULLS LAST, dmpl__DateEffectiveFrom__c DESC NULLS LAST];
    }

    private static List<dmpl__DiscountGroupRule__c> queryDiscountRules(List<Id> itemIds,
                                                                            List<Id> skuIds, 
                                                                            date minDocumentDate, 
                                                                            List<Item__c> lineItems,
                                                                            List<Id> discountGroupIds){
       
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__ItemId__c','dmpl__SKUId__c','dmpl__DateEffectiveTill__c','dmpl__DiscountPercent__c','dmpl__DateEffectiveFrom__c'}, 'dmpl__DiscountGroupRule__c');
        return [SELECT 
            dmpl__ItemId__c,
            dmpl__ItemGroupId__c,
            dmpl__SKUId__c,
            dmpl__DiscountPercent__c,
            dmpl__DateEffectiveFrom__c,
            dmpl__DateEffectiveTill__c,
            dmpl__DiscountGroupId__c,
            dmpl__DiscountGroupId__r.dmpl__IsDefault__c
        FROM 
            dmpl__DiscountGroupRule__c 
        WHERE 
            (dmpl__ItemId__c IN :itemIds OR dmpl__ItemId__c = null)
            AND (dmpl__SKUId__c IN :skuIds OR dmpl__SKUId__c = null)
            AND (dmpl__DateEffectiveFrom__c <=:minDocumentDate OR dmpl__DateEffectiveFrom__c =null)
            AND (dmpl__DateEffectiveTill__c >=:minDocumentDate OR dmpl__DateEffectiveTill__c = null)
            AND (dmpl__DiscountGroupId__c IN :discountGroupIds)
        ORDER BY dmpl__ItemId__c DESC NULLS LAST, dmpl__SKUId__c DESC NULLS LAST, dmpl__DateEffectiveFrom__c DESC NULLS LAST];
    }
    
    private static List<dmpl__DiscountGroupRule__c> queryDiscountRules(List<Id> itemIds,
                                                                            List<Id> skuIds, 
                                                                            date minDocumentDate, 
                                                                            List<Item__c> lineItems,
                                                                            List<Id> partnerAccountIds,
                                                                            List<Id> branchIds,
                                                                            List<dmpl__AccountGroupMember__c> partnerAccountGroupIds,
                                                                            List<dmpl__AccountGroupMember__c> customerAccountGroupIds){
       
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__ItemId__c','dmpl__SKUId__c','dmpl__DateEffectiveTill__c','dmpl__DiscountPercent__c','dmpl__DateEffectiveFrom__c'}, 'dmpl__DiscountGroupRule__c');
        return [SELECT 
            dmpl__ItemId__c,
            dmpl__ItemGroupId__c,
            dmpl__SKUId__c,
            dmpl__DiscountPercent__c,
            dmpl__DateEffectiveFrom__c,
            dmpl__DateEffectiveTill__c,
            dmpl__DiscountGroupId__c,
            dmpl__DiscountGroupId__r.dmpl__IsDefault__c
        FROM 
            dmpl__DiscountGroupRule__c 
        WHERE 
            (dmpl__ItemId__c IN :itemIds OR dmpl__ItemId__c = null)
            AND (dmpl__SKUId__c IN :skuIds OR dmpl__SKUId__c = null)
            AND (dmpl__DateEffectiveFrom__c <=:minDocumentDate OR dmpl__DateEffectiveFrom__c =null)
            AND (dmpl__DateEffectiveTill__c >=:minDocumentDate OR dmpl__DateEffectiveTill__c = null)
            AND (dmpl__DiscountGroupId__r.dmpl__PartnerAccountId__c IN :partnerAccountIds OR dmpl__DiscountGroupId__r.dmpl__PartnerAccountId__c = null)
            AND (dmpl__DiscountGroupId__r.dmpl__BranchId__c IN :branchIds OR dmpl__DiscountGroupId__r.dmpl__BranchId__c = null)
            AND (dmpl__DiscountGroupId__r.dmpl__CustomerAccountGroupId__c IN:DocumentHelper.extractIds(customerAccountGroupIds, FIELDNAME_ACCOUNT_ACCOUNTGROUPID) OR dmpl__DiscountGroupId__r.dmpl__CustomerAccountGroupId__c = null)
            AND (dmpl__DiscountGroupId__r.dmpl__PartnerAccountGroupId__c IN:DocumentHelper.extractIds(partnerAccountGroupIds, FIELDNAME_ACCOUNT_ACCOUNTGROUPID) OR dmpl__DiscountGroupId__r.dmpl__PartnerAccountGroupId__c = null)
        ORDER BY dmpl__ItemId__c DESC NULLS LAST, dmpl__SKUId__c DESC NULLS LAST, dmpl__DateEffectiveFrom__c DESC NULLS LAST];
    }


   @TestVisible private static Id queryPartnerAccountGroupId(Id accountId){

        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__PartnerPriceAccountGroupId__c'}, 'Account');
        return [
            SELECT 
                dmpl__PartnerPriceAccountGroupId__c 
            FROM 
                Account
            WHERE
                ID=:accountId]?.Id;
    }

    @TestVisible private static Id queryAccountGroupId(Id accountId){

        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__AccountGroupId__c'}, 'dmpl__AccountGroupMember__c');
        return [
            SELECT 
                dmpl__AccountGroupId__c 
            FROM 
                dmpl__AccountGroupMember__c
            WHERE
                dmpl__AccountId__c=:accountId]?.dmpl__AccountGroupId__c;
    }

  @TestVisible  private static List<Account> queryPartnerAccountGroupIds(List<Id> accountIds){

        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__PartnerPriceAccountGroupId__c'}, 'Account');
        return [
            SELECT 
                Id,
                dmpl__PartnerPriceAccountGroupId__c 
            FROM 
                Account
            WHERE
                dmpl__PartnerPriceAccountGroupId__c != null
                AND ID IN :accountIds];
    }

    private static List<dmpl__AccountGroupMember__c> queryDiscountAccountGroupMembers(
        List<ID> accountIds)
    {
        SecurityHelper.ensureCanReadFields(new List<String>
        {
            'dmpl__AccountGroupType__c'
        },'dmpl__AccountGroup__c');

        SecurityHelper.ensureCanReadFields(new List<String>
        {
            'dmpl__AccountId__c',
            'dmpl__AccountGroupId__c'
        },'dmpl__AccountGroupMember__c');

        return [ SELECT ID, 
            dmpl__AccountId__c,
            dmpl__AccountGroupId__c
        FROM dmpl__AccountGroupMember__c
        WHERE dmpl__AccountId__c IN : accountIds
        AND dmpl__AccountGroupId__r.dmpl__AccountGroupType__c = 'Discount' Limit 2000];
    }    

    private static List<dmpl__ItemGroupMember__c> queryDiscountItemGroupMembers(
        List<ID> itemIds)
    {
        SecurityHelper.ensureCanReadFields(new List<String>
        {
            'dmpl__ItemGroupType__c'
        },'dmpl__ItemGroup__c');

        SecurityHelper.ensureCanReadFields(new List<String>
        {
            'dmpl__ItemId__c',
            'dmpl__ItemGroupId__c'
        },'dmpl__ItemGroupMember__c');

        return [ SELECT ID, 
            dmpl__ItemId__c,
            dmpl__ItemGroupId__c
        FROM dmpl__ItemGroupMember__c
        WHERE dmpl__ItemId__c IN : itemIds
        AND dmpl__ItemGroupId__r.dmpl__ItemGroupType__c = 'Discount' Limit 1000];
    }    

   @TestVisible private static Id queryCustomerAccountGroupId(Id accountId){

        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__CustomerPriceAccountGroupId__c'}, 'Account');
        return [
            SELECT 
                dmpl__CustomerPriceAccountGroupId__c 
            FROM 
                Account
            WHERE
                ID=:accountId]?.dmpl__CustomerPriceAccountGroupId__c;
    }

    private static List<Account> queryCustomerAccountGroupIds(List<Id> accountIds){

        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__CustomerPriceAccountGroupId__c'}, 'Account');
        return [
            SELECT 
                Id,
                dmpl__PartnerPriceAccountGroupId__c,
                dmpl__CustomerPriceAccountGroupId__c 
            FROM 
                Account
            WHERE
                dmpl__PartnerPriceAccountGroupId__c != null
                AND ID IN :accountIds];
    }

    private static date getMinDocumentDate(List<SObject> documents){
        List<Date> documentDates = new List<Date>();
        for(SObject document : documents){
            documentDates.add((Date)document.get(FIELDNAME_SALEORDER_DOCUMENTDATE));
        }
        if(documentDates.size()>0){
            documentDates.sort();
            return documentDates[0];
        }
        return null;
    }
	
    @TestVisible
    private static SaleOrder__c getSaleOrder(SaleOrderLine__c saleOrderLine, List<SaleOrder__c> ofSaleOrders){
        for(SaleOrder__c saleOrder : ofSaleOrders){
            if(saleOrderLine.SaleOrderId__c == saleOrder.Id){
                return saleOrder;
            }
        }
        return null;
    }

    @TestVisible
    private static SaleInvoice__c getSaleInvoice(SaleInvoiceLine__c saleInvoiceLine, List<SaleInvoice__c> ofSaleInvoices){
        for(SaleInvoice__c saleInvoice : ofSaleInvoices){
            if(saleInvoiceLine.SaleInvoiceId__c == saleInvoice.Id){
                return saleInvoice;
            }
        }
        return null;
    }

    @TestVisible
    private static PurchaseOrder__c getPurchaseOrder(PurchaseOrderLine__c purchaseOrderLine, List<PurchaseOrder__c> purchaseOrders){
        for(PurchaseOrder__c purchaseOrder : purchaseOrders){
            if(purchaseOrderLine.PurchaseOrderId__c == purchaseOrder.Id){
                return purchaseOrder;
            }
        }
        return null;
    }

    @TestVisible
    private static Bill__c getPurchaseInvoice(BillLine__c purchaseInvoiceLine, List<Bill__c> purchaseInvoices){
        for(Bill__c purchaseInvoice : purchaseInvoices){
            if(purchaseInvoiceLine.PurchaseInvoiceId__c == purchaseInvoice.Id){
                return purchaseInvoice;
            }
        }
        return null;
    }

    @TestVisible
    private static Quote__c getQuote(QuoteLine__c quoteLine, List<Quote__c> quotes){
        for(Quote__c quote : quotes){
            if(quoteLine.QuoteId__c == quote.Id){
                return quote;
            }
        }
        return null;
    }

    @TestVisible
    private static ServiceRequest__c getServiceRequest(ServiceRequestLine__c serviceRequestLine, List<ServiceRequest__c> serviceRequests){
        for(ServiceRequest__c serviceRequest : serviceRequests){
            if(serviceRequestLine.ServiceRequestId__c == serviceRequest.Id){
                return serviceRequest;
            }
        }
        return null;
    }

    
    @TestVisible
    private static DeliveryOrder__c getDeliveryOrder(DeliveryOrderLine__c deliveryOrderLine, List<DeliveryOrder__c> deliveryOrders){
        for(DeliveryOrder__c deliveryOrder : deliveryOrders){
            if(deliveryOrderLine.dmpl__DeliveryId__c == deliveryOrder.Id){
                return deliveryOrder;
            }
        }
        return null;
    }

    @TestVisible
    private static RepairOrder__c getRepairOrder(RepairOrderLine__c repairOrderLine, List<RepairOrder__c> repairOrders){
        for(RepairOrder__c repairOrder : repairOrders){
            if(repairOrderLine.RepairOrderId__c == repairOrder.Id){
                return repairOrder;
            }
        }
        return null;
    }


 @TestVisible   private static Id getPartnerAccountGroupId(Id partnerAccountId, List<Account> partnerAccountGroupIds){
        for(Account account : partnerAccountGroupIds){
            if(account.Id == partnerAccountId){
                return account.dmpl__PartnerPriceAccountGroupId__c;
            }
        }
        return null;
    }

    @TestVisible   private static Id getAccountGroupId(Id accountId, List<dmpl__AccountGroupMember__c> accountGroupMembers){
        for(dmpl__AccountGroupMember__c accountGroupMember : accountGroupMembers){
            if(accountGroupMember.dmpl__AccountId__c == accountId){
                return accountGroupMember.dmpl__AccountGroupId__c;
            }
        }
        return null;
    }

    @TestVisible   private static Id getItemGroupId(Id itemId, List<dmpl__ItemGroupMember__c> itemGroupMembers){
        for(dmpl__ItemGroupMember__c itemGroupMember : itemGroupMembers){
            if(itemGroupMember.dmpl__ItemId__c == itemId){
                return itemGroupMember.dmpl__ItemGroupId__c;
            }
        }
        return null;
    }

 @TestVisible   private static Id getCustomerAccountGroupId(Id customerAccountId, List<Account> customerAccountGroupIds){
        for(Account account : customerAccountGroupIds){
            if(account.Id == customerAccountId){
                return account.dmpl__CustomerPriceAccountGroupId__c;
            }
        }
        return null;
    }
}