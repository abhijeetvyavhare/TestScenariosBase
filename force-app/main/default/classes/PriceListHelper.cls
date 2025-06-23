@namespaceAccessible
public with sharing class PriceListHelper {

    public static final string PRICELIST_TYPE_SALE = 'Sale Price';
    public static final string PRICELIST_TYPE_PURCHASE = 'Purchase Price';

    private static final string FIELDNAME_SALEORDERLINE_ITEMID = 'dmpl__ItemId__c';
    private static final string FIELDNAME_SALEORDERLINE_SKUID = 'dmpl__SKUId__c';
    private static final string FIELDNAME_SALEORDER_DOCUMENTDATE = 'DocumentDate__c';
    private static final string FIELDNAME_SALEORDER_PARTNERID = 'dmpl__PartnerAccountId__c';
    private static final string FIELDNAME_SALEORDER_CUSTOMERID = 'dmpl__AccountId__c';
    private static final string FIELDNAME_ACCOUNT_PARTNERACCOUNTGROUPID = 'dmpl__PartnerPriceAccountGroupId__c';
    private static final string FIELDNAME_ACCOUNT_CUSTOMERACCOUNTGROUPID = 'dmpl__CustomerPriceAccountGroupId__c';
    private static final string FIELDNAME_SALEORDER_ACCOUNTID = 'dmpl__AccountId__c';
    private static final string FIELDNAME_SALEORDER_BRANCHID = 'dmpl__BranchId__c';
    private static final string FIELDNAME_PRICELISTRULEID = 'dmpl__PriceListRuleId__c';
    private static final string FIELDNAME_SALEORDERLINE_ISPRICEBUNDLED = 'dmpl__IsPriceBundled__c';
    private static final string FIELDNAME_SALEORDER_PRICELISTID = 'dmpl__PriceListId__c';
    private static final string FIELDNAME_SALEORDERLINE_ITEMLOTTYPEID = 'dmpl__ItemLotTypeId__c';
    

    private static List<Item__c> itemWithAccountGroups = new List<Item__c>();

    @namespaceAccessible
    public static Id getDefaultPriceListId(
        String priceType, 
        Id accountId, 
        Id partnerId, 
        Id branchId, 
        date pricingDate){
        return queryDefaultPriceListId(
            priceType, 
            accountId, 
            partnerId, 
            branchId, 
            pricingDate);
    }

    @namespaceAccessible
    public static Double getApplicablePrice(
        Id priceListId, 
        Id itemId, 
        Id skuId, 
        date pricingDate){
        if(skuId == null){
            return queryPrice(
                priceListId, 
                itemId, 
                pricingDate);
        } else {
            return queryPrice(
                priceListId, 
                itemId, 
                skuId, 
                pricingDate);
        }
    }
    
    @namespaceAccessible
    public static List<dmpl__PriceListRules__c> getApplicablePrice(
        Id priceListId, 
        List<Id> itemIds, 
        List<Id> SKUIds, 
        Date pricingDate){
        return queryPriceRules(
            priceListId, 
            itemIds, 
            SKUIds, 
            pricingDate);
    }

    @namespaceAccessible
    public static void setDefaultPriceListIds(
        List<SaleOrder__c> ofSaleOrders){
        List<Account> partnerAccountGroupIds = queryPartnerAccountGroupIds(
            DocumentHelper.extractIds(
                ofSaleOrders, 
                FIELDNAME_SALEORDER_PARTNERID));
        List<Account> customerAccountGroupIds = queryCustomerAccountGroupIds(
            DocumentHelper.extractIds(
                ofSaleOrders, 
                FIELDNAME_SALEORDER_CUSTOMERID));
        List<dmpl__PriceList__c> priceLists = queryDefaultPriceListIds(
            PRICELIST_TYPE_SALE, 
            ofSaleOrders, 
            partnerAccountGroupIds, 
            customerAccountGroupIds);
        SecurityHelper.ensureCanWriteField(
            'dmpl__PriceListId__c', 
            'dmpl__SaleOrder__c');
        for(SaleOrder__c saleOrder: ofSaleOrders){
            if(saleOrder.dmpl__PriceListId__c != null){
                continue;
            }
            for(dmpl__PriceList__c priceList : priceLists){
                if(
                    (saleOrder.PartnerAccountId__c == priceList.PartnerAccountId__c || priceList.PartnerAccountId__c == null)
                    && (saleOrder.BranchId__c == priceList.BranchId__c || priceList.BranchId__c == null)
                    && (priceList.dmpl__PartnerAccountGroupId__c == getPartnerAccountGroupId(saleOrder.dmpl__PartnerAccountId__c, partnerAccountGroupIds) || priceList.dmpl__PartnerAccountGroupId__c == null)
                    && (priceList.dmpl__CustomerAccountGroupId__c == getCustomerAccountGroupId(saleOrder.dmpl__AccountId__c, customerAccountGroupIds) || priceList.dmpl__CustomerAccountGroupId__c == null)){
                        saleOrder.dmpl__PriceListId__c = priceList.Id;
                        break;
                }
            }
        }
    }

    @namespaceAccessible
    public static void setDefaultPriceListIds(
        List<SaleInvoice__c> ofSaleInvoices){
        List<Account> partnerAccountGroupIds = queryPartnerAccountGroupIds(
            DocumentHelper.extractIds(
                ofSaleInvoices, 
                FIELDNAME_SALEORDER_PARTNERID));
        List<Account> customerAccountGroupIds = queryCustomerAccountGroupIds(
            DocumentHelper.extractIds(
                ofSaleInvoices, 
                FIELDNAME_SALEORDER_CUSTOMERID));
        List<dmpl__PriceList__c> priceLists = queryDefaultPriceListIds(
            PRICELIST_TYPE_SALE, 
            ofSaleInvoices, 
            partnerAccountGroupIds, 
            customerAccountGroupIds);
        SecurityHelper.ensureCanWriteField(
            'dmpl__PriceListId__c', 
            'dmpl__SaleInvoice__c');
        for(SaleInvoice__c saleInvoice: ofSaleInvoices){
            if(saleInvoice.dmpl__PriceListId__c != null){
                continue;
            }
            for(dmpl__PriceList__c priceList : priceLists){
                if(
                    (saleInvoice.PartnerAccountId__c == priceList.PartnerAccountId__c || priceList.PartnerAccountId__c == null)
                    && (saleInvoice.BranchId__c == priceList.BranchId__c || priceList.BranchId__c == null)
                    && (priceList.dmpl__PartnerAccountGroupId__c == getPartnerAccountGroupId(saleInvoice.dmpl__PartnerAccountId__c, partnerAccountGroupIds) || priceList.dmpl__PartnerAccountGroupId__c == null)
                    && (priceList.dmpl__CustomerAccountGroupId__c == getCustomerAccountGroupId(saleInvoice.dmpl__AccountId__c, customerAccountGroupIds) || priceList.dmpl__CustomerAccountGroupId__c == null)){

                        saleInvoice.dmpl__PriceListId__c = priceList.Id;
                        break;
                }
            }
        }
    }

    @namespaceAccessible
    public static void setDefaultPriceListIds(
        List<PurchaseOrder__c> ofPurchaseOrder){
        List<Account> partnerAccountGroupIds = queryPartnerAccountGroupIds(
            DocumentHelper.extractIds(
                ofPurchaseOrder, 
                FIELDNAME_SALEORDER_PARTNERID));
        List<dmpl__PriceList__c> priceLists = queryDefaultPriceListIds(
            PRICELIST_TYPE_PURCHASE, 
            ofPurchaseOrder, 
            partnerAccountGroupIds, 
            new List<Account>());
        SecurityHelper.ensureCanWriteField(
            'dmpl__PriceListId__c', 
            'dmpl__PurchaseOrder__c');
        for(PurchaseOrder__c purchaseOrder: ofPurchaseOrder){
            if(purchaseOrder.dmpl__PriceListId__c != null){
                continue;
            }
            for(dmpl__PriceList__c priceList : priceLists){
                if(
                    (purchaseOrder.PartnerAccountId__c == priceList.PartnerAccountId__c || priceList.PartnerAccountId__c == null)
                    && (purchaseOrder.BranchId__c == priceList.BranchId__c || priceList.BranchId__c == null)
                    && (priceList.dmpl__PartnerAccountGroupId__c == getPartnerAccountGroupId(purchaseOrder.dmpl__PartnerAccountId__c, partnerAccountGroupIds) || priceList.dmpl__PartnerAccountGroupId__c == null)
                    ){

                    purchaseOrder.dmpl__PriceListId__c = priceList.Id;
                    break;
                }
            }
        }
    }

    @namespaceAccessible
    public static void setDefaultPriceListIds(
        List<AutoPurchaseOrder__c> ofAutoPurchaseOrder){
        List<Account> partnerAccountGroupIds = queryPartnerAccountGroupIds(
            DocumentHelper.extractIds(
                ofAutoPurchaseOrder, 
                FIELDNAME_SALEORDER_PARTNERID));
        List<dmpl__PriceList__c> priceLists = queryDefaultPriceListIds(
            PRICELIST_TYPE_PURCHASE, 
            ofAutoPurchaseOrder, 
            partnerAccountGroupIds, 
            new List<Account>());
        SecurityHelper.ensureCanWriteField(
            'dmpl__PriceListId__c', 
            'dmpl__PurchaseOrder__c');
        for(AutoPurchaseOrder__c autoPurchaseOrder: ofAutoPurchaseOrder){
            if(autoPurchaseOrder.dmpl__PriceListId__c != null){
                continue;
            }
            for(dmpl__PriceList__c priceList : priceLists){
                if(
                    (AutoPurchaseOrder.PartnerAccountId__c == priceList.PartnerAccountId__c || priceList.PartnerAccountId__c == null)
                    && (AutoPurchaseOrder.BranchId__c == priceList.BranchId__c || priceList.BranchId__c == null)
                    && (priceList.dmpl__PartnerAccountGroupId__c == getPartnerAccountGroupId(AutoPurchaseOrder.dmpl__PartnerAccountId__c, partnerAccountGroupIds) || priceList.dmpl__PartnerAccountGroupId__c == null)
                    ){

                        AutoPurchaseOrder.dmpl__PriceListId__c = priceList.Id;
                    break;
                }
            }
        }
    }

    @namespaceAccessible
    public static void setDefaultPriceListIds(List<Bill__c> ofPurchaseInvoice){
        List<Account> partnerAccountGroupIds = queryPartnerAccountGroupIds(
            DocumentHelper.extractIds(
                ofPurchaseInvoice, 
                FIELDNAME_SALEORDER_PARTNERID));
        List<dmpl__PriceList__c> priceLists = queryDefaultPriceListIds(
            PRICELIST_TYPE_PURCHASE, 
            ofPurchaseInvoice, 
            partnerAccountGroupIds, 
            new List<Account>());
        SecurityHelper.ensureCanWriteField(
            'dmpl__PriceListId__c', 
            'dmpl__Bill__c');
        for(Bill__c purchaseInvoice: ofPurchaseInvoice){
            if(purchaseInvoice.dmpl__PriceListId__c != null){
                continue;
            }
            for(dmpl__PriceList__c priceList : priceLists){
                if(
                    (purchaseInvoice.PartnerAccountId__c == priceList.PartnerAccountId__c || priceList.PartnerAccountId__c == null)
                    && (purchaseInvoice.BranchId__c == priceList.BranchId__c || priceList.BranchId__c == null)
                    && (priceList.dmpl__PartnerAccountGroupId__c == getPartnerAccountGroupId(purchaseInvoice.dmpl__PartnerAccountId__c, partnerAccountGroupIds) || priceList.dmpl__PartnerAccountGroupId__c == null)
                    ){
                        purchaseInvoice.dmpl__PriceListId__c = priceList.Id;
                        break;
                }
            }
        }
    }

    @namespaceAccessible
    public static void setDefaultPriceListIds(
        List<Quote__c> ofQuote){
        List<Account> partnerAccountGroupIds = queryPartnerAccountGroupIds(
            DocumentHelper.extractIds(
                ofQuote, 
                FIELDNAME_SALEORDER_PARTNERID));
        List<Account> customerAccountGroupIds = queryCustomerAccountGroupIds(
            DocumentHelper.extractIds(
                ofQuote, 
                FIELDNAME_SALEORDER_CUSTOMERID));
        List<dmpl__PriceList__c> priceLists = queryDefaultPriceListIds(
            PRICELIST_TYPE_SALE, 
            ofQuote, 
            partnerAccountGroupIds, 
            customerAccountGroupIds);
        SecurityHelper.ensureCanWriteField(
            'dmpl__PriceListId__c', 
            'dmpl__Quote__c');
        for(Quote__c quote: ofQuote){
            if(quote.dmpl__PriceListId__c != null){
                continue;
            }
            for(dmpl__PriceList__c priceList : priceLists){
                if(
                    (quote.PartnerAccountId__c == priceList.PartnerAccountId__c || priceList.PartnerAccountId__c == null)
                    && (quote.BranchId__c == priceList.BranchId__c || priceList.BranchId__c == null)
                    && (priceList.dmpl__PartnerAccountGroupId__c == getPartnerAccountGroupId(quote.dmpl__PartnerAccountId__c, partnerAccountGroupIds) || priceList.dmpl__PartnerAccountGroupId__c == null)
                    && (priceList.dmpl__CustomerAccountGroupId__c == getCustomerAccountGroupId(quote.dmpl__AccountId__c, customerAccountGroupIds) || priceList.dmpl__CustomerAccountGroupId__c == null)){
                    {
                        quote.dmpl__PriceListId__c = priceList.Id;
                        break;
                    }
                }
            }
        }
    }

    @namespaceAccessible
    public static void setDefaultPriceListIds(
        List<ServiceRequest__c> ofServiceRequest){
        List<Account> partnerAccountGroupIds = queryPartnerAccountGroupIds(
            DocumentHelper.extractIds(ofServiceRequest, 
            FIELDNAME_SALEORDER_PARTNERID));
        List<Account> customerAccountGroupIds = queryCustomerAccountGroupIds(
            DocumentHelper.extractIds(
                ofServiceRequest, 
                FIELDNAME_SALEORDER_CUSTOMERID));
        List<dmpl__PriceList__c> priceLists = queryDefaultPriceListIds(
            PRICELIST_TYPE_SALE, 
            ofServiceRequest, 
            partnerAccountGroupIds, 
            customerAccountGroupIds);
        SecurityHelper.ensureCanWriteField(
            'dmpl__PriceListId__c', 
            'dmpl__ServiceRequest__c');
        for(ServiceRequest__c serviceRequest: ofServiceRequest){
            if(serviceRequest.dmpl__PriceListId__c != null){
                continue;
            }
            for(dmpl__PriceList__c priceList : priceLists){
                if(
                    (serviceRequest.PartnerAccountId__c == priceList.PartnerAccountId__c || priceList.PartnerAccountId__c == null)
                    && (serviceRequest.BranchId__c == priceList.BranchId__c || priceList.BranchId__c == null)
                    && (priceList.dmpl__PartnerAccountGroupId__c == getPartnerAccountGroupId(serviceRequest.dmpl__PartnerAccountId__c, partnerAccountGroupIds) || priceList.dmpl__PartnerAccountGroupId__c == null)
                    && (priceList.dmpl__CustomerAccountGroupId__c == getCustomerAccountGroupId(serviceRequest.dmpl__AccountId__c, customerAccountGroupIds) || priceList.dmpl__CustomerAccountGroupId__c == null)){
                    {
                        serviceRequest.dmpl__PriceListId__c = priceList.Id;
                        break;
                    }
                }
            }
        }
    }

    @namespaceAccessible
    public static void setDefaultPriceListIds(List<DeliveryOrder__c> ofDeliveryOrder){
        List<Account> partnerAccountGroupIds = queryPartnerAccountGroupIds(DocumentHelper.extractIds(ofDeliveryOrder, FIELDNAME_SALEORDER_PARTNERID));
        List<Account> customerAccountGroupIds = queryCustomerAccountGroupIds(DocumentHelper.extractIds(ofDeliveryOrder, FIELDNAME_SALEORDER_CUSTOMERID));
        List<dmpl__PriceList__c> priceLists = queryDefaultPriceListIds(PRICELIST_TYPE_SALE, ofDeliveryOrder, partnerAccountGroupIds, customerAccountGroupIds);
        SecurityHelper.ensureCanWriteField('dmpl__PriceListId__c', 'dmpl__DeliveryOrder__c');
        for(DeliveryOrder__c deliveryOrder: ofDeliveryOrder){
            if(deliveryOrder.dmpl__PriceListId__c != null){
                continue;
            }
            for(dmpl__PriceList__c priceList : priceLists){
                if(
                    (deliveryOrder.PartnerAccountId__c == priceList.PartnerAccountId__c || priceList.PartnerAccountId__c == null)
                    && (deliveryOrder.BranchId__c == priceList.BranchId__c || priceList.BranchId__c == null)
                    && (priceList.dmpl__PartnerAccountGroupId__c == getPartnerAccountGroupId(deliveryOrder.dmpl__PartnerAccountId__c, partnerAccountGroupIds) || priceList.dmpl__PartnerAccountGroupId__c == null)
                    && (priceList.dmpl__CustomerAccountGroupId__c == getCustomerAccountGroupId(deliveryOrder.dmpl__AccountId__c, customerAccountGroupIds) || priceList.dmpl__CustomerAccountGroupId__c == null)){
                    {

                        deliveryOrder.dmpl__PriceListId__c = priceList.Id;
                        break;
                    }
                }
            }
        }
    }

    @namespaceAccessible
   public static void setDefaultPriceListIds(
    List<RepairOrder__c> ofRepairOrder){
        List<Account> partnerAccountGroupIds = queryPartnerAccountGroupIds(
            DocumentHelper.extractIds(
                ofRepairOrder, 
                FIELDNAME_SALEORDER_PARTNERID));
        List<Account> customerAccountGroupIds = queryCustomerAccountGroupIds(
            DocumentHelper.extractIds(
                ofRepairOrder, 
                FIELDNAME_SALEORDER_CUSTOMERID));
        List<dmpl__PriceList__c> priceLists = queryDefaultPriceListIds(
            PRICELIST_TYPE_SALE, 
            ofRepairOrder, 
            partnerAccountGroupIds, 
            new List<Account>());
        SecurityHelper.ensureCanWriteField(
            'dmpl__PriceListId__c', 
            'dmpl__RepairOrder__c');
        for(RepairOrder__c repairOrder : ofRepairOrder){
            if(repairOrder.dmpl__PriceListId__c != null){
                continue;
            }
            for(dmpl__PriceList__c priceList : priceLists){
                if(
                    (repairOrder.PartnerAccountId__c == priceList.PartnerAccountId__c || priceList.PartnerAccountId__c == null)
                    && (repairOrder.BranchId__c == priceList.BranchId__c || priceList.BranchId__c == null)
                    && (priceList.dmpl__PartnerAccountGroupId__c == getPartnerAccountGroupId(repairOrder.dmpl__PartnerAccountId__c, partnerAccountGroupIds) || priceList.dmpl__PartnerAccountGroupId__c == null)
                    && (priceList.dmpl__CustomerAccountGroupId__c == getCustomerAccountGroupId(repairOrder.dmpl__AccountId__c, customerAccountGroupIds) || priceList.dmpl__CustomerAccountGroupId__c == null))
                    {
                        repairOrder.dmpl__PriceListId__c = priceList.Id;
                        break;
                    }
            }
        }
    }

    @namespaceAccessible
   public static void setDefaultPriceListIds(
        List<SaleReturn__c> ofSaleReturn){
        List<Account> partnerAccountGroupIds = queryPartnerAccountGroupIds(
            DocumentHelper.extractIds(
                ofSaleReturn, 
                FIELDNAME_SALEORDER_PARTNERID));
        List<Account> customerAccountGroupIds = queryCustomerAccountGroupIds(
            DocumentHelper.extractIds(
                ofSaleReturn, 
                FIELDNAME_SALEORDER_CUSTOMERID));
        List<dmpl__PriceList__c> priceLists = queryDefaultPriceListIds(
            PRICELIST_TYPE_SALE, 
            ofSaleReturn, 
            partnerAccountGroupIds, 
            new List<Account>());
        SecurityHelper.ensureCanWriteField(
            'dmpl__PriceListId__c', 
            'dmpl__SaleReturn__c');
        for(SaleReturn__c saleReturn : ofSaleReturn){
            if(saleReturn.dmpl__PriceListId__c != null){
                continue;
            }
            for(dmpl__PriceList__c priceList : priceLists){
                if(
                    (saleReturn.PartnerAccountId__c == priceList.PartnerAccountId__c || priceList.PartnerAccountId__c == null)
                    && (saleReturn.BranchId__c == priceList.BranchId__c || priceList.BranchId__c == null)
                    && (priceList.dmpl__PartnerAccountGroupId__c == getPartnerAccountGroupId(saleReturn.dmpl__PartnerAccountId__c, partnerAccountGroupIds) || priceList.dmpl__PartnerAccountGroupId__c == null)
                    && (priceList.dmpl__CustomerAccountGroupId__c == getCustomerAccountGroupId(saleReturn.dmpl__AccountId__c, customerAccountGroupIds) || priceList.dmpl__CustomerAccountGroupId__c == null))
                    {
                        saleReturn.dmpl__PriceListId__c = priceList.Id;
                        break;
                    }
            }
        }
    }

    @namespaceAccessible
   public static void setDefaultPriceListIds(
        List<BillReturn__c> ofBillReturn){
        List<Account> partnerAccountGroupIds = queryPartnerAccountGroupIds(
            DocumentHelper.extractIds(
                ofBillReturn, 
                FIELDNAME_SALEORDER_PARTNERID));
        List<dmpl__PriceList__c> priceLists = queryDefaultPriceListIds(
            PRICELIST_TYPE_SALE, 
            ofBillReturn, 
            partnerAccountGroupIds, 
            new List<Account>());
        SecurityHelper.ensureCanWriteField(
            'dmpl__PriceListId__c', 
            'dmpl__BillReturn__c');
        for(BillReturn__c billReturn : ofBillReturn){
            if(billReturn.dmpl__PriceListId__c != null){
                continue;
            }
            for(dmpl__PriceList__c priceList : priceLists){
                if(
                    (billReturn.PartnerAccountId__c == priceList.PartnerAccountId__c || priceList.PartnerAccountId__c == null)
                    && (billReturn.BranchId__c == priceList.BranchId__c || priceList.BranchId__c == null)
                    && (priceList.dmpl__PartnerAccountGroupId__c == getPartnerAccountGroupId(billReturn.dmpl__PartnerAccountId__c, partnerAccountGroupIds) || priceList.dmpl__PartnerAccountGroupId__c == null))
                    {
                        billReturn.dmpl__PriceListId__c = priceList.Id;
                        break;
                    }
            }
        }
    }

    public static void setDefaultPriceListIds(
        List<dmpl__InventoryAdjustment__c> ofAdjustments){
        List<Account> partnerAccountGroupIds = queryPartnerAccountGroupIds(
            DocumentHelper.extractIds(
                ofAdjustments, 
                FIELDNAME_SALEORDER_PARTNERID));
        List<dmpl__PriceList__c> priceLists = queryDefaultPriceListIds(
            PRICELIST_TYPE_PURCHASE, 
            ofAdjustments, 
            partnerAccountGroupIds, 
            new List<Account>());
        SecurityHelper.ensureCanWriteField(
            'dmpl__PriceListId__c', 
            'dmpl__InventoryAdjustment__c');
        for(dmpl__InventoryAdjustment__c adjustment : ofAdjustments){
            if(adjustment.dmpl__PriceListId__c != null){
                continue;
            }
            for(dmpl__PriceList__c priceList : priceLists){
                if(
                    (adjustment.PartnerAccountId__c == priceList.PartnerAccountId__c || priceList.PartnerAccountId__c == null)
                    && (adjustment.BranchId__c == priceList.BranchId__c || priceList.BranchId__c == null)
                    && (priceList.dmpl__PartnerAccountGroupId__c == getPartnerAccountGroupId(adjustment.dmpl__PartnerAccountId__c, partnerAccountGroupIds) || priceList.dmpl__PartnerAccountGroupId__c == null))
                    {
                        adjustment.dmpl__PriceListId__c = priceList.Id;
                        break;
                    }
            }
        }
    }

    @namespaceAccessible
    public static void setApplicablePrices(
        List<SaleOrderLine__c> saleOrderLines, 
        List<SaleOrder__c> ofSaleOrders, 
        List<Item__c> lineItems,
        Boolean isReprice){
        List<dmpl__PriceListRules__c> applicablePrices = queryPriceRules(
            saleOrderLines, 
            ofSaleOrders, 
            lineItems);
        SecurityHelper.ensureCanWriteFields(
            new List<String>{
                'dmpl__UnitPrice__c',
                'dmpl__UnitPrice2__c'
            },
            'dmpl__SaleOrderLine__c');
        for(SaleOrderLine__c orderLine: saleOrderLines){
            SaleOrder__c saleOrder = getSaleOrder(orderLine, ofSaleOrders);
            if(orderLine.dmpl__IsPriceBundled__c
                || (orderLine.dmpl__UnitPrice__c!=null
                    && !isReprice)){
                continue;
            }
            for(dmpl__PriceListRules__c priceRule : applicablePrices){
                Date priceDate = orderLine.dmpl__PriceAsOnDate__c !=null ?
                    orderLine.dmpl__PriceAsOnDate__c : (saleOrder.dmpl__PriceAsOnDate__c != null ? 
                        (Date)saleOrder.dmpl__PriceAsOnDate__c : saleOrder.DocumentDate__c);
                if(
                    orderLine.ItemId__c == priceRule.ItemId__c
                    && ((orderLine.dmpl__PriceListId__c == null && saleOrder.dmpl__PriceListId__c == priceRule.dmpl__PriceListId__c)
                        || orderLine.dmpl__PriceListId__c == priceRule.dmpl__PriceListId__c)
                    && (orderLine.SKUId__c == priceRule.SKUID__c || priceRule.SKUID__c == null)
                    && (orderLine.dmpl__ItemLotTypeId__c == priceRule.dmpl__ItemLotTypeId__c || priceRule.dmpl__ItemLotTypeId__c == null)
                    && (priceDate >= priceRule.dmpl__DateEffectiveFrom__c || priceRule.dmpl__DateEffectiveFrom__c == null)
                    && (priceDate <= priceRule.dmpl__DateEffectiveTill__c || priceRule.dmpl__DateEffectiveTill__c == null)
                ){
                    orderLine.dmpl__UnitPrice__c = priceRule.dmpl__Price__c;
                    orderLine.dmpl__UnitPrice2__c = priceRule.dmpl__Price2__c;
                    break;
                }
            }    
        }
    }

    @namespaceAccessible
    public static void setApplicablePrices(
        List<SObject> documentLines, 
        List<SObject> ofDocuments, 
        List<Item__c> lineItems, 
        List<ID> priceListRuleIds, 
        string masterChildFieldName){
        List<dmpl__PriceListRules__c> applicablePrices = queryPriceRules(
            documentLines, 
            ofDocuments, 
            lineItems, 
            priceListRuleIds);
        SecurityHelper.ensureCanWriteField(
            'dmpl__UnitPrice__c', 
            'dmpl__SaleOrderLine__c');
        for(SObject documentLine: documentLines){
            if(documentLine.get(FIELDNAME_PRICELISTRULEID) == null 
                || (Boolean)documentLine.get(FIELDNAME_SALEORDERLINE_ISPRICEBUNDLED)){
                continue;
            }
            for(dmpl__PriceListRules__c priceRule : applicablePrices){
                SObject document = getSObject(
                    documentLine, 
                    ofDocuments, 
                    masterChildFieldName);
                if(
                    documentLine.get(FIELDNAME_SALEORDERLINE_ITEMID) == priceRule.ItemId__c
                    && (document.get(FIELDNAME_SALEORDER_PRICELISTID) == priceRule.dmpl__PriceListId__c || priceRule.dmpl__PriceListId__r?.dmpl__IsDefault__c)
                    && (documentLine.get('SKUId__c') == priceRule.SKUID__c || priceRule.SKUID__c == null)
                    && (documentLine.get('dmpl__ItemLotTypeId__c') == priceRule.dmpl__ItemLotTypeId__c || priceRule.dmpl__ItemLotTypeId__c == null)
                    &&(documentLine.get(FIELDNAME_PRICELISTRULEID) == priceRule.Id)
                ){
                    documentLine.put('dmpl__UnitPrice__c', priceRule.dmpl__Price__c);
                    documentLine.put('dmpl__UnitPrice2__c', priceRule.dmpl__Price2__c);
                    break;
                }
            }    
        }
    }

    @namespaceAccessible
    public static void setApplicablePrices(
        List<SaleInvoiceLine__c> saleInvoiceLines, 
        List<SaleInvoice__c> ofSaleInvoices, 
        List<Item__c> lineItems,
        Boolean isReprice){
        List<dmpl__PriceListRules__c> applicablePrices = queryPriceRules(
            saleInvoiceLines, 
            ofSaleInvoices, 
            lineItems);
        SecurityHelper.ensureCanWriteFields(
            new List<String>{
                'dmpl__UnitPrice__c',
                'dmpl__UnitPrice2__c'
            },
            'dmpl__SaleInvoiceLine__c');
        for(SaleInvoiceLine__c invoiceLine: saleInvoiceLines){
            if((invoiceLine.dmpl__UnitPrice__c != null 
                && !isReprice)
                || invoiceLine.dmpl__IsPriceBundled__c){
                continue;
            }
            for(dmpl__PriceListRules__c priceRule : applicablePrices){
                SaleInvoice__c saleInvoice = getSaleInvoice(
                    invoiceLine, 
                    ofSaleInvoices);
                Date priceDate = invoiceLine.dmpl__PriceAsOnDate__c !=null ? 
                    invoiceLine.dmpl__PriceAsOnDate__c : (saleInvoice.dmpl__PriceAsOnDate__c != null ? 
                        (Date)saleInvoice.dmpl__PriceAsOnDate__c : saleInvoice.DocumentDate__c);
                if(
                    invoiceLine.ItemId__c == priceRule.ItemId__c
                    && ((invoiceLine.dmpl__PriceListId__c == null && saleInvoice.dmpl__PriceListId__c == priceRule.dmpl__PriceListId__c)
                    || invoiceLine.dmpl__PriceListId__c == priceRule.dmpl__PriceListId__c)
                    && (invoiceLine.SKUId__c == priceRule.SKUID__c || priceRule.SKUID__c == null)
                    && (invoiceLine.dmpl__ItemLotTypeId__c == priceRule.dmpl__ItemLotTypeId__c || priceRule.dmpl__ItemLotTypeId__c == null)
                    && (priceDate >= priceRule.dmpl__DateEffectiveFrom__c || priceRule.dmpl__DateEffectiveFrom__c == null)
                    && (priceDate <= priceRule.dmpl__DateEffectiveTill__c || priceRule.dmpl__DateEffectiveTill__c == null)
                ){
                    invoiceLine.dmpl__UnitPrice__c = priceRule.dmpl__Price__c;
                    invoiceLine.dmpl__UnitPrice2__c = priceRule.dmpl__Price2__c;
                    break;
                }
            }    
        }
    }

    @namespaceAccessible
    public static void setApplicablePrices(
        List<PurchaseOrderLine__c> purchaseOrderLines, 
        List<PurchaseOrder__c> purchaseOrders, 
        List<Item__c> lineItems,
        Boolean isReprice){
        List<dmpl__PriceListRules__c> applicablePrices = queryPriceRules(
            purchaseOrderLines, 
            purchaseOrders, 
            lineItems);
        SecurityHelper.ensureCanWriteFields(
            new List<String>{
                'dmpl__UnitCost__c',
                'dmpl__UnitCost2__c'
            },
            'dmpl__PurchaseOrderLine__c');
        for(PurchaseOrderLine__c orderLine: purchaseOrderLines){
            if(orderLine.dmpl__UnitCost__c != null
                && !isReprice){
                continue;
            }
            for(dmpl__PriceListRules__c priceRule : applicablePrices){
                PurchaseOrder__c purchaseOrder = getPurchaseOrder(
                    orderLine, 
                    purchaseOrders);
                Date priceDate = orderLine.dmpl__PriceAsOnDate__c !=null ? 
                    orderLine.dmpl__PriceAsOnDate__c : (purchaseOrder.dmpl__PriceAsOnDate__c != null ? 
                        (Date)purchaseOrder.dmpl__PriceAsOnDate__c : purchaseOrder.DocumentDate__c);
                if(
                    orderLine.ItemId__c == priceRule.ItemId__c
                    && ((orderLine.dmpl__PriceListId__c == null && purchaseOrder.dmpl__PriceListId__c == priceRule.dmpl__PriceListId__c)
                    || orderLine.dmpl__PriceListId__c == priceRule.dmpl__PriceListId__c)
                    && (orderLine.SKUId__c == priceRule.SKUID__c || priceRule.SKUID__c == null)
                    && (orderLine.dmpl__ItemLotTypeId__c == priceRule.dmpl__ItemLotTypeId__c || priceRule.dmpl__ItemLotTypeId__c == null)
                    && (priceDate >= priceRule.dmpl__DateEffectiveFrom__c || priceRule.dmpl__DateEffectiveFrom__c == null)
                    && (priceDate <= priceRule.dmpl__DateEffectiveTill__c || priceRule.dmpl__DateEffectiveTill__c == null)
                ){
                    orderLine.dmpl__UnitCost__c = priceRule.dmpl__Price__c;
                    orderLine.dmpl__UnitCost2__c = priceRule.dmpl__Price2__c;
                    break;
                }
            }    
        }
    }

    @namespaceAccessible
    public static void setApplicablePrices(
        List<AutoPurchaseOrderLine__c> autoPurchaseOrderLines, 
        List<AutoPurchaseOrder__c> autoPurchaseOrders, 
        List<Item__c> lineItems,
        Boolean isReprice){
        List<dmpl__PriceListRules__c> applicablePrices = queryPriceRules(
            autoPurchaseOrderLines, 
            autoPurchaseOrders, 
            lineItems);
        SecurityHelper.ensureCanWriteFields(
            new List<String>{
                'dmpl__UnitCost__c'
            },
            'dmpl__AutoPurchaseOrderLine__c');
        for(AutoPurchaseOrderLine__c orderLine: autoPurchaseOrderLines){
            if(orderLine.dmpl__UnitCost__c != null){
                continue;
            }
            for(dmpl__PriceListRules__c priceRule : applicablePrices){
                AutoPurchaseOrder__c autoPurchaseOrder = getAutoPurchaseOrder(
                    orderLine, 
                    autoPurchaseOrders);
                if(
                    orderLine.ItemId__c == priceRule.ItemId__c
                    && ((orderLine.dmpl__PriceListId__c == null && autoPurchaseOrder.dmpl__PriceListId__c == priceRule.dmpl__PriceListId__c)
                    || orderLine.dmpl__PriceListId__c == priceRule.dmpl__PriceListId__c)
                    && (orderLine.SKUId__c == priceRule.SKUID__c || priceRule.SKUID__c == null)
                    && (orderLine.dmpl__ItemLotTypeId__c == priceRule.dmpl__ItemLotTypeId__c || priceRule.dmpl__ItemLotTypeId__c == null)
                    && (autoPurchaseOrder.DocumentDate__c >= priceRule.dmpl__DateEffectiveFrom__c || priceRule.dmpl__DateEffectiveFrom__c == null)
                    && (autoPurchaseOrder.DocumentDate__c <= priceRule.dmpl__DateEffectiveTill__c || priceRule.dmpl__DateEffectiveTill__c == null)
                ){
                    orderLine.dmpl__UnitCost__c = priceRule.dmpl__Price__c;
                    break;
                }
            }    
        }
    }

    @namespaceAccessible
    public static void setApplicablePrices(
        List<BillLine__c> purchaseInvoiceLines, 
        List<Bill__c> purchaseInvoices, 
        List<Item__c> lineItems,
        Boolean isReprice){
        List<dmpl__PriceListRules__c> applicablePrices = queryPriceRules(
            purchaseInvoiceLines, 
            purchaseInvoices, 
            lineItems);
        SecurityHelper.ensureCanWriteFields(
        new List<String>{
            'dmpl__UnitCost__c',
            'dmpl__UnitCost2__c'
        },
        'dmpl__BillLine__c');
        for(BillLine__c invoiceLine: purchaseInvoiceLines){
            if(invoiceLine.dmpl__UnitCost__c != null
                && !isReprice){
                continue;
            }
            for(dmpl__PriceListRules__c priceRule : applicablePrices){
                Bill__c purchaseInvoice = getPurchaseInvoice(
                    invoiceLine, 
                    purchaseInvoices);
                Date priceDate = invoiceLine.dmpl__PriceAsOnDate__c !=null ? 
                    invoiceLine.dmpl__PriceAsOnDate__c : (purchaseInvoice.dmpl__PriceAsOnDate__c != null ? 
                        (Date)purchaseInvoice.dmpl__PriceAsOnDate__c : purchaseInvoice.DocumentDate__c);
                if(
                    invoiceLine.ItemId__c == priceRule.ItemId__c
                    && ((invoiceLine.dmpl__PriceListId__c == null && purchaseInvoice.dmpl__PriceListId__c == priceRule.dmpl__PriceListId__c)
                    || invoiceLine.dmpl__PriceListId__c == priceRule.dmpl__PriceListId__c)
                    && (invoiceLine.SKUId__c == priceRule.SKUID__c || priceRule.SKUID__c == null)
                    && (invoiceLine.dmpl__ItemLotTypeId__c == priceRule.dmpl__ItemLotTypeId__c || priceRule.dmpl__ItemLotTypeId__c == null)
                    && (priceDate >= priceRule.dmpl__DateEffectiveFrom__c || priceRule.dmpl__DateEffectiveFrom__c == null)
                    && (priceDate <= priceRule.dmpl__DateEffectiveTill__c || priceRule.dmpl__DateEffectiveTill__c == null)
                ){
                    invoiceLine.dmpl__UnitCost__c = priceRule.dmpl__Price__c;
                    invoiceLine.dmpl__UnitCost2__c = priceRule.dmpl__Price2__c;
                    break;
                }
            }    
        }
    }

    @namespaceAccessible
    public static void setApplicablePrices(
        List<QuoteLine__c> quoteLines, 
        List<Quote__c> quotes, 
        List<Item__c> lineItems,
        Boolean isReprice){
        List<dmpl__PriceListRules__c> applicablePrices = queryPriceRules(
            quoteLines, 
            quotes, 
            lineItems);
        SecurityHelper.ensureCanWriteFields(
            new List<String>{
                'dmpl__UnitPrice__c',
                'dmpl__UnitPrice2__c'
            },
            'dmpl__QuoteLine__c');
        for(QuoteLine__c invoiceLine: quoteLines){
            if(invoiceLine.dmpl__UnitPrice__c !=null 
                && !isReprice){
                    continue;
                }
            for(dmpl__PriceListRules__c priceRule : applicablePrices){
                Quote__c quote = getQuote(
                    invoiceLine, 
                    quotes);
                Date priceDate = invoiceLine.dmpl__PriceAsOnDate__c !=null ? 
                    invoiceLine.dmpl__PriceAsOnDate__c : (quote.dmpl__PriceAsOnDate__c != null ? 
                        (Date)quote.dmpl__PriceAsOnDate__c : quote.DocumentDate__c);
                if(
                    invoiceLine.ItemId__c == priceRule.ItemId__c
                    && ((invoiceLine.dmpl__PriceListId__c == null && quote.dmpl__PriceListId__c == priceRule.dmpl__PriceListId__c)
                    || invoiceLine.dmpl__PriceListId__c == priceRule.dmpl__PriceListId__c)
                    && (invoiceLine.SKUId__c == priceRule.SKUID__c || priceRule.SKUID__c == null)
                    && (invoiceLine.dmpl__ItemLotTypeId__c == priceRule.dmpl__ItemLotTypeId__c || priceRule.dmpl__ItemLotTypeId__c == null)
                    && (priceDate >= priceRule.dmpl__DateEffectiveFrom__c || priceRule.dmpl__DateEffectiveFrom__c == null)
                    && (priceDate <= priceRule.dmpl__DateEffectiveTill__c || priceRule.dmpl__DateEffectiveTill__c == null)
                ){
                    invoiceLine.dmpl__UnitPrice__c = priceRule.dmpl__Price__c;
                    invoiceLine.dmpl__UnitPrice2__c = priceRule.dmpl__Price2__c;
                    break;
                }
            }    
        }
    }

    @namespaceAccessible
    public static void setApplicablePrices(
        List<ServiceRequestLine__c> serviceRequestLines, 
        List<ServiceRequest__c> serviceRequests, 
        List<Item__c> lineItems,
        Boolean isReprice){
        List<dmpl__PriceListRules__c> applicablePrices = queryPriceRules(
            serviceRequestLines, 
            serviceRequests, 
            lineItems);
        SecurityHelper.ensureCanWriteFields(
            new List<String>{
                'dmpl__UnitPrice__c',
                'dmpl__UnitPrice2__c'
            },
            'dmpl__ServiceRequestLine__c');
        for(ServiceRequestLine__c serviceRequestLine: serviceRequestLines){
            if(serviceRequestLine.dmpl__UnitPrice__c != null
                && !isReprice ){
                continue;
            }
            for(dmpl__PriceListRules__c priceRule : applicablePrices){
                ServiceRequest__c ServiceRequest = getServiceRequest(serviceRequestLine, serviceRequests);
                Date priceDate = serviceRequestLine.dmpl__PriceAsOnDate__c !=null ? 
                    serviceRequestLine.dmpl__PriceAsOnDate__c : (ServiceRequest.dmpl__PriceAsOnDate__c != null ?
                        (Date)ServiceRequest.dmpl__PriceAsOnDate__c : ServiceRequest.DocumentDate__c);
                if(serviceRequestLine.ItemId__c == priceRule.ItemId__c
                    && ((serviceRequestLine.dmpl__PriceListId__c == null && ServiceRequest.dmpl__PriceListId__c == priceRule.dmpl__PriceListId__c)
                    || serviceRequestLine.dmpl__PriceListId__c == priceRule.dmpl__PriceListId__c)
                    && (serviceRequestLine.SKUId__c == priceRule.SKUID__c || priceRule.SKUID__c == null)
                    && (serviceRequestLine.dmpl__ItemLotTypeId__c == priceRule.dmpl__ItemLotTypeId__c || priceRule.dmpl__ItemLotTypeId__c == null)
                    && (priceDate >= priceRule.dmpl__DateEffectiveFrom__c || priceRule.dmpl__DateEffectiveFrom__c == null)
                    && (priceDate <= priceRule.dmpl__DateEffectiveTill__c || priceRule.dmpl__DateEffectiveTill__c == null)
                ){
                    serviceRequestLine.dmpl__UnitPrice__c = priceRule.dmpl__Price__c;
                    serviceRequestLine.dmpl__UnitPrice2__c = priceRule.dmpl__Price2__c;
                    break;
                }
            }    
        }
    }

    @namespaceAccessible
    public static void setApplicablePrices(
        List<DeliveryOrderLine__c> deliveryOrderLines, 
        List<DeliveryOrder__c> deliveryOrders, 
        List<Item__c> lineItems){
        List<dmpl__PriceListRules__c> applicablePrices = queryPriceRules(
            deliveryOrderLines, 
            deliveryOrders, 
            lineItems);
        SecurityHelper.ensureCanWriteFields(
            new List<String>{
                'dmpl__UnitPrice__c',
                'dmpl__UnitPrice2__c'
            },
            'dmpl__DeliveryOrderLine__c');
        for(DeliveryOrderLine__c deliveryOrderLine: deliveryOrderLines){
            if(deliveryOrderLine.dmpl__UnitPrice__c != null){
                continue;
            }
            for(dmpl__PriceListRules__c priceRule : applicablePrices){
                DeliveryOrder__c DeliveryOrder = getDeliveryOrder(
                    deliveryOrderLine, 
                    deliveryOrders);
                if(
                    deliveryOrderLine.ItemId__c == priceRule.ItemId__c
                    && (DeliveryOrder.dmpl__PriceListId__c == priceRule.dmpl__PriceListId__c || priceRule.dmpl__PriceListId__r?.dmpl__IsDefault__c)
                    && (deliveryOrderLine.SKUId__c == priceRule.SKUID__c || priceRule.SKUID__c == null)
                    && (deliveryOrderLine.dmpl__ItemLotTypeId__c == priceRule.dmpl__ItemLotTypeId__c || priceRule.dmpl__ItemLotTypeId__c == null)
                    && (DeliveryOrder.DocumentDate__c >= priceRule.dmpl__DateEffectiveFrom__c || priceRule.dmpl__DateEffectiveFrom__c == null)
                    && (DeliveryOrder.DocumentDate__c <= priceRule.dmpl__DateEffectiveTill__c || priceRule.dmpl__DateEffectiveTill__c == null)
                ){
                    deliveryOrderLine.dmpl__UnitPrice__c = priceRule.dmpl__Price__c;
                    deliveryOrderLine.dmpl__UnitPrice2__c = priceRule.dmpl__Price2__c;
                    break;
                }
            }    
        }
    }

    @namespaceAccessible
    public static void setApplicablePrices(
        List<RepairOrderLine__c> repairOrderLines, 
        List<RepairOrder__c> repairOrders, 
        List<Item__c> lineItems,
        Boolean isReprice){
        List<dmpl__PriceListRules__c> applicablePrices = queryPriceRules(
            repairOrderLines, 
            repairOrders, 
            lineItems);
        SecurityHelper.ensureCanWriteFields(
            new List<String>{
                'dmpl__UnitPrice__c',
                'dmpl__UnitPrice2__c'
            },
            'dmpl__RepairOrderLine__c');
        for(RepairOrderLine__c repairOrderLine: repairOrderLines){
            if(repairOrderLine.dmpl__UnitPrice__c != null
                && !isReprice){
                continue;
            }
            for(dmpl__PriceListRules__c priceRule : applicablePrices){
                RepairOrder__c repairOrder = getRepairOrder(repairOrderLine, repairOrders);
                Date priceDate = repairOrderLine.dmpl__PriceAsOnDate__c !=null ? 
                    repairOrderLine.dmpl__PriceAsOnDate__c : (repairOrder.dmpl__PriceAsOnDate__c != null ? 
                        (Date)repairOrder.dmpl__PriceAsOnDate__c : repairOrder.DocumentDate__c);
                if(
                    repairOrderLine.ItemId__c == priceRule.ItemId__c
                    && ((repairOrderLine.dmpl__PriceListId__c == null && repairOrder.dmpl__PriceListId__c == priceRule.dmpl__PriceListId__c)
                    || repairOrderLine.dmpl__PriceListId__c == priceRule.dmpl__PriceListId__c)
                    && (repairOrderLine.SKUId__c == priceRule.SKUID__c || priceRule.SKUID__c == null)
                    && (repairOrderLine.dmpl__ItemLotTypeId__c == priceRule.dmpl__ItemLotTypeId__c || priceRule.dmpl__ItemLotTypeId__c == null)
                    && (priceDate >= priceRule.dmpl__DateEffectiveFrom__c || priceRule.dmpl__DateEffectiveFrom__c == null)
                    && (priceDate <= priceRule.dmpl__DateEffectiveTill__c || priceRule.dmpl__DateEffectiveTill__c == null)
                ){
                    repairOrderLine.dmpl__UnitPrice__c = priceRule.dmpl__Price__c;
                    repairOrderLine.dmpl__UnitPrice2__c = priceRule.dmpl__Price2__c;
                    break;
                }
            }    
        }
    }

    @namespaceAccessible
    public static void setApplicablePrices(
        List<SaleReturnLine__c> saleReturnLines, 
        List<SaleReturn__c> ofSaleReturns, 
        List<Item__c> lineItems,
        Boolean isReprice){
        List<dmpl__PriceListRules__c> applicablePrices = queryPriceRules(
            saleReturnLines, 
            ofSaleReturns, 
            lineItems);
        SecurityHelper.ensureCanWriteFields(
            new List<String>{
                'dmpl__UnitPrice__c',
                'dmpl__UnitPrice2__c'
            },
            'dmpl__SaleReturnLine__c');
        for(SaleReturnLine__c returnLine: saleReturnLines){
            if(returnLine.dmpl__UnitPrice__c != null
                && !isReprice){
                continue;
            }
            for(dmpl__PriceListRules__c priceRule : applicablePrices){
                SaleReturn__c saleReturn = getSaleReturn(
                    returnLine, 
                    ofSaleReturns);
                
                Date priceDate = returnLine.dmpl__PriceAsOnDate__c !=null ? 
                    returnLine.dmpl__PriceAsOnDate__c : (saleReturn.dmpl__PriceAsOnDate__c != null 
                    ? (Date)saleReturn.dmpl__PriceAsOnDate__c : saleReturn.DocumentDate__c);
                if(
                    returnLine.ItemId__c == priceRule.ItemId__c
                    && (saleReturn.dmpl__PriceListId__c == priceRule.dmpl__PriceListId__c || priceRule.dmpl__PriceListId__r?.dmpl__IsDefault__c)
                    && (returnLine.SKUId__c == priceRule.SKUID__c || priceRule.SKUID__c == null)
                    && (returnLine.dmpl__ItemLotTypeId__c == priceRule.dmpl__ItemLotTypeId__c || priceRule.dmpl__ItemLotTypeId__c == null)
                    && (priceDate >= priceRule.dmpl__DateEffectiveFrom__c || priceRule.dmpl__DateEffectiveFrom__c == null)
                    && (priceDate <= priceRule.dmpl__DateEffectiveTill__c || priceRule.dmpl__DateEffectiveTill__c == null)
                ){
                    returnLine.dmpl__UnitPrice__c = priceRule.dmpl__Price__c;
                    returnLine.dmpl__UnitPrice2__c = priceRule.dmpl__Price2__c;
                    break;
                }
            }    
        }
    }

    @namespaceAccessible
    public static void setApplicablePrices(
        List<BillReturnLine__c> billReturnLines, 
        List<BillReturn__c> ofBillReturns, 
        List<Item__c> lineItems,
        Boolean isReprice){
        List<dmpl__PriceListRules__c> applicablePrices = queryPriceRules(
            billReturnLines, 
            ofBillReturns, 
            lineItems);
        SecurityHelper.ensureCanWriteFields(
            new List<String>{
                'dmpl__UnitPrice__c',
                'dmpl__UnitPrice2__c'
            },
            'dmpl__BillReturnLine__c');
        for(BillReturnLine__c billreturnLine: billReturnLines){
            if(billreturnLine.dmpl__UnitPrice__c != null
                && !isReprice){
                continue;
            }
            for(dmpl__PriceListRules__c priceRule : applicablePrices){
                BillReturn__c billReturn = getBillReturn(
                    billreturnLine, 
                    ofBillReturns);
                    
            Date priceDate = billreturnLine.dmpl__PriceAsOnDate__c !=null ? 
            billreturnLine.dmpl__PriceAsOnDate__c : (billReturn.dmpl__PriceAsOnDate__c != null 
            ? (Date)billReturn.dmpl__PriceAsOnDate__c : billReturn.DocumentDate__c);
                if(
                    billreturnLine.ItemId__c == priceRule.ItemId__c
                    && (billReturn.dmpl__PriceListId__c == priceRule.dmpl__PriceListId__c || priceRule.dmpl__PriceListId__r?.dmpl__IsDefault__c)
                    && (billreturnLine.SKUId__c == priceRule.SKUID__c || priceRule.SKUID__c == null)
                    && (billreturnLine.dmpl__ItemLotTypeId__c == priceRule.dmpl__ItemLotTypeId__c || priceRule.dmpl__ItemLotTypeId__c == null)
                    && (priceDate >= priceRule.dmpl__DateEffectiveFrom__c || priceRule.dmpl__DateEffectiveFrom__c == null)
                    && (priceDate <= priceRule.dmpl__DateEffectiveTill__c || priceRule.dmpl__DateEffectiveTill__c == null)
                ){
                    billreturnLine.dmpl__UnitCost__c = priceRule.dmpl__Price__c;
                    billreturnLine.dmpl__UnitCost2__c = priceRule.dmpl__Price2__c;
                    break;
                }
            }    
        }
    }

    public static void setApplicablePrices(
        List<dmpl__InventoryAdjustmentLine__c> adjustmentLines, 
        List<dmpl__InventoryAdjustment__c> ofAdjustments, 
        List<Item__c> lineItems,
        Boolean isReprice){
        List<dmpl__PriceListRules__c> applicablePrices = queryPriceRules(
            adjustmentLines, 
            ofAdjustments, 
            lineItems);
        SecurityHelper.ensureCanWriteFields(
            new List<String>{
                'dmpl__UnitCost__c',
                'dmpl__UnitCost2__c'
            },
            'dmpl__InventoryAdjustmentLine__c');
        for(dmpl__InventoryAdjustmentLine__c adjustmentLine : adjustmentLines){
            if(adjustmentLine.dmpl__UnitCost__c != null
                && !isReprice){
                continue;
            }
            for(dmpl__PriceListRules__c priceRule : applicablePrices){
                dmpl__InventoryAdjustment__c adjustment = getAdjustment(
                    adjustmentLine, 
                    ofAdjustments);
                
                Date priceDate = adjustmentLine.dmpl__PriceAsOnDate__c !=null ? 
                    adjustmentLine.dmpl__PriceAsOnDate__c : (adjustment.dmpl__PriceAsOnDate__c != null 
                    ? (Date)adjustment.dmpl__PriceAsOnDate__c : adjustment.DocumentDate__c);
                if(
                    adjustmentLine.ItemId__c == priceRule.ItemId__c
                    && (adjustment.dmpl__PriceListId__c == priceRule.dmpl__PriceListId__c || priceRule.dmpl__PriceListId__r?.dmpl__IsDefault__c)
                    && (adjustmentLine.SKUId__c == priceRule.SKUID__c || priceRule.SKUID__c == null)
                    && (adjustmentLine.dmpl__ItemLotTypeId__c == priceRule.dmpl__ItemLotTypeId__c || priceRule.dmpl__ItemLotTypeId__c == null)
                    && (priceDate >= priceRule.dmpl__DateEffectiveFrom__c || priceRule.dmpl__DateEffectiveFrom__c == null)
                    && (priceDate <= priceRule.dmpl__DateEffectiveTill__c || priceRule.dmpl__DateEffectiveTill__c == null)
                ){
                    adjustmentLine.dmpl__UnitCost__c = priceRule.dmpl__Price__c;
                    adjustmentLine.dmpl__UnitCost2__c = priceRule.dmpl__Price__c;
                    break;
                }
            }    
        }
    }

    private static List<dmpl__PriceList__c> queryDefaultPriceListIds(
        String priceType, 
        List<SObject> ofDocuments, 
        List<Account> partnerAccountGroupIds, 
        List<Account> customerAccountGroupIds){
        List<Id> branchIds = DocumentHelper.extractIds(
            ofDocuments, 
            FIELDNAME_SALEORDER_BRANCHID);
        List<Id> partnerAccountIds =  DocumentHelper.extractIds(
            ofDocuments, 
            FIELDNAME_SALEORDER_PARTNERID);

        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__PartnerAccountId__c',
            'dmpl__BranchId__c',
            'dmpl__CustomerAccountGroupId__c',
            'dmpl__PartnerAccountGroupId__c'
        }, 'dmpl__PriceList__c');
        return [
                SELECT
                    Id,
                    dmpl__PartnerAccountId__c,
                    dmpl__BranchId__c,
                    dmpl__CustomerAccountGroupId__c,
                    dmpl__PartnerAccountGroupId__c
                FROM
                    dmpl__PriceList__c
                WHERE
                    dmpl__PriceListType__c = :priceType
                    AND dmpl__IsActive__c = true
                    AND (dmpl__PartnerAccountId__c IN :partnerAccountIds OR dmpl__PartnerAccountId__c = null)
                    AND (dmpl__BranchId__c IN :branchIds OR dmpl__BranchId__c = null)
                    AND (dmpl__CustomerAccountGroupId__c IN:DocumentHelper.extractIds(customerAccountGroupIds, FIELDNAME_ACCOUNT_CUSTOMERACCOUNTGROUPID) OR dmpl__CustomerAccountGroupId__c = null)
                    AND (dmpl__PartnerAccountGroupId__c IN:DocumentHelper.extractIds(partnerAccountGroupIds, FIELDNAME_ACCOUNT_PARTNERACCOUNTGROUPID) OR dmpl__PartnerAccountGroupId__c = null)
                ORDER BY dmpl__SequenceNumber__c DESC NULLS LAST, dmpl__BranchId__c DESC NULLS LAST, dmpl__PartnerAccountId__c DESC NULLS LAST, dmpl__PartnerAccountGroupId__c DESC NULLS LAST, dmpl__CustomerAccountGroupId__c DESC NULLS LAST];
    }

    private static Id queryDefaultPriceListId(
        String priceType, 
        Id accountId, 
        Id partnerId, 
        Id branchId, 
        date priceDate){
        SecurityHelper.ensureCanReadFields(new string[]{
            'Id'
        }, 'dmpl__PriceList__c');
        return [
                SELECT
                    Id
                FROM
                    dmpl__PriceList__c
                WHERE
                    dmpl__PriceListType__c = :priceType
                    AND dmpl__IsActive__c = true 
                    AND (dmpl__PartnerAccountId__c =:partnerId OR dmpl__PartnerAccountId__c = null)
                    AND (dmpl__BranchId__c =:branchId OR dmpl__BranchId__c = null)
                    AND (dmpl__CustomerAccountGroupId__c =:queryCustomerAccountGroupId(accountId) OR dmpl__CustomerAccountGroupId__c = null)
                    AND (dmpl__PartnerAccountGroupId__c =:queryPartnerAccountGroupId(partnerId) OR dmpl__PartnerAccountGroupId__c = null)
                ORDER BY dmpl__SequenceNumber__c DESC NULLS LAST, dmpl__BranchId__c DESC NULLS LAST, dmpl__PartnerAccountId__c DESC NULLS LAST, dmpl__PartnerAccountGroupId__c DESC NULLS LAST, dmpl__CustomerAccountGroupId__c DESC NULLS LAST
                LIMIT 1]?.Id;
    }

    private static Double queryPrice(
        Id priceListId, 
        Id itemId, 
        date priceDate){
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__Price__c'
        }, 'dmpl__PriceListRules__c');
        return [SELECT 
            dmpl__Price__c
        FROM 
            dmpl__PriceListRules__c 
        WHERE 
            dmpl__ItemId__c =:itemId
            AND (dmpl__PriceListId__c =:priceListId OR dmpl__PriceListId__r.dmpl__IsDefault__c = true)
            AND (dmpl__DateEffectiveFrom__c <=:priceDate OR dmpl__DateEffectiveFrom__c = null)
            AND (dmpl__DateEffectiveTill__c >=:priceDate OR dmpl__DateEffectiveTill__c = null)
        ORDER BY dmpl__DateEffectiveFrom__c DESC NULLS LAST
        LIMIT 1]?.dmpl__Price__c;
    }
    
    private static Double queryPrice(
        Id priceListId, 
        Id itemId, 
        Id skuId, 
        date priceDate){
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__Price__c'
        }, 'dmpl__PriceListRules__c');
        return [SELECT 
            dmpl__Price__c
        FROM 
            dmpl__PriceListRules__c 
        WHERE 
            dmpl__ItemId__c =:itemId
            AND (dmpl__PriceListId__c =:priceListId OR dmpl__PriceListId__r.dmpl__IsDefault__c = true)
            AND (dmpl__SKUId__c =:skuId OR dmpl__SKUId__c = null)
            AND (dmpl__DateEffectiveFrom__c <=:priceDate OR dmpl__DateEffectiveFrom__c = null)
            AND (dmpl__DateEffectiveTill__c >=:priceDate OR dmpl__DateEffectiveTill__c = null)
        ORDER BY dmpl__DateEffectiveFrom__c DESC NULLS LAST
        LIMIT 1]?.dmpl__Price__c;
    }

    private static List<dmpl__PriceListRules__c> queryPriceRules(
        List<SObject> lines, 
        List<SObject> documents, 
        List<Item__c> lineItems){
        List<Id> itemIds = DocumentHelper.extractIds(
            lines, 
            FIELDNAME_SALEORDERLINE_ITEMID);
        List<Id> priceListIds  = DocumentHelper.extractIds(
            documents, 
            'dmpl__PriceListId__c');
        List<Id> linePriceListIds  = DocumentHelper.extractIds(
            lines, 
            'dmpl__PriceListId__c');
        for(Id priceListId : linePriceListIds){
            if(!priceListIds.contains(priceListId)){
                priceListIds.add(priceListId);
            }
        }
        date minDocumentDate = getMinDocumentDate(
            documents,
            lines);

        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__ItemId__c',
            'dmpl__SKUId__c',
            'dmpl__ItemLotTypeId__c',
            'dmpl__DateEffectiveTill__c',
            'dmpl__DateEffectiveFrom__c',
            'dmpl__Price__c',
            'dmpl__Price2__c'
        }, 'dmpl__PriceListRules__c');
        return [SELECT 
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__ItemLotTypeId__c,
            dmpl__Price__c,
            dmpl__DateEffectiveFrom__c,
            dmpl__DateEffectiveTill__c,
            dmpl__PriceListId__c,
            dmpl__Price2__c,
            dmpl__PriceListId__r.dmpl__IsDefault__c
        FROM 
            dmpl__PriceListRules__c 
        WHERE 
            dmpl__ItemId__c IN :itemIds
            AND (dmpl__PriceListId__c IN :priceListIds OR dmpl__PriceListId__r.dmpl__IsDefault__c = true)
            AND (dmpl__SKUId__c IN :DocumentHelper.extractIds(lines, FIELDNAME_SALEORDERLINE_SKUID) OR dmpl__SKUId__c = null)
            AND (dmpl__ItemLotTypeId__c IN :DocumentHelper.extractIds(lines, FIELDNAME_SALEORDERLINE_ITEMLOTTYPEID) OR dmpl__ItemLotTypeId__c = null)
            //AND (dmpl__DateEffectiveFrom__c <=:minDocumentDate OR dmpl__DateEffectiveFrom__c = null) -- Multiple Document with overlappig From Date
            AND (dmpl__DateEffectiveTill__c >=:minDocumentDate OR dmpl__DateEffectiveTill__c = null)
        ORDER BY dmpl__DateEffectiveFrom__c DESC NULLS LAST, dmpl__ItemId__c DESC NULLS LAST, dmpl__SKUId__c DESC NULLS LAST,dmpl__ItemLotTypeId__c  DESC NULLS LAST];
    }

    private static List<dmpl__PriceListRules__c> queryPriceRules(
        List<SObject> lines, 
        List<SObject> documents, 
        List<Item__c> lineItems, 
        List<Id> priceListRuleIds){
        List<Id> itemIds = DocumentHelper.extractIds(
            lines, 
            FIELDNAME_SALEORDERLINE_ITEMID);
        List<Id> priceListIds  = DocumentHelper.extractIds(
            documents, 
            'dmpl__PriceListId__c');

        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__ItemId__c',
            'dmpl__SKUId__c',
            'dmpl__ItemLotTypeId__c',
            'dmpl__DateEffectiveTill__c',
            'dmpl__DateEffectiveFrom__c',
            'dmpl__Price__c',
            'dmpl__Price2__c'
        }, 'dmpl__PriceListRules__c');
        return [SELECT 
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__ItemLotTypeId__c,
            dmpl__Price__c,
            dmpl__Price2__c,
            dmpl__DateEffectiveFrom__c,
            dmpl__DateEffectiveTill__c,
            dmpl__PriceListId__c,
            dmpl__PriceListId__r.dmpl__IsDefault__c
        FROM 
            dmpl__PriceListRules__c 
        WHERE 
            dmpl__ItemId__c IN :itemIds
            AND (dmpl__PriceListId__c IN :priceListIds OR dmpl__PriceListId__r.dmpl__IsDefault__c = true)
            AND (dmpl__SKUId__c IN :DocumentHelper.extractIds(lines, FIELDNAME_SALEORDERLINE_SKUID) OR dmpl__SKUId__c = null)
            AND (dmpl__ItemLotTypeId__c IN :DocumentHelper.extractIds(lines, FIELDNAME_SALEORDERLINE_ITEMLOTTYPEID) OR dmpl__ItemLotTypeId__c = null)
            AND (Id IN: priceListRuleIds) 
        ORDER BY dmpl__DateEffectiveFrom__c, dmpl__ItemId__c, dmpl__SKUId__c, dmpl__ItemLotTypeId__c DESC NULLS LAST];
    }

    private static List<dmpl__PriceListRules__c> queryPriceRules(
        Id priceListId, 
        List<Id> itemIds, 
        List<Id> skuIds, 
        Date priceDate){
        SecurityHelper.ensureCanReadFields(
            new string[]
            {
                'dmpl__ItemId__c',
                'dmpl__SKUId__c',
                'dmpl__ItemLotTypeId__c',
                'dmpl__DateEffectiveTill__c',
                'dmpl__DateEffectiveFrom__c',
                'dmpl__Price__c',
                'dmpl__Price2__c'
            }, 'dmpl__PriceListRules__c');
        return [SELECT 
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__ItemLotTypeId__c,
            dmpl__Price__c,
            dmpl__Price2__c,
            dmpl__DateEffectiveFrom__c,
            dmpl__DateEffectiveTill__c,
            dmpl__PriceListId__c,
            dmpl__PriceListId__r.dmpl__IsDefault__c
        FROM 
            dmpl__PriceListRules__c 
        WHERE 
            dmpl__ItemId__c IN :itemIds
            AND (dmpl__PriceListId__c =:priceListId OR dmpl__PriceListId__r.dmpl__IsDefault__c = true)
            AND (dmpl__SKUId__c IN :skuIds OR dmpl__SKUId__c = null)
            AND (dmpl__DateEffectiveFrom__c <=:priceDate OR dmpl__DateEffectiveFrom__c = null)
            AND (dmpl__DateEffectiveTill__c >=:priceDate OR dmpl__DateEffectiveTill__c = null)
        ORDER BY dmpl__DateEffectiveFrom__c DESC NULLS LAST, dmpl__ItemId__c DESC NULLS LAST, dmpl__SKUId__c DESC NULLS LAST,dmpl__ItemLotTypeId__c DESC NULLS LAST];
    }

    private static Id queryPartnerAccountGroupId(
        Id accountId){
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__PartnerPriceAccountGroupId__c'
        }, 'Account');
        return [
            SELECT 
                dmpl__PartnerPriceAccountGroupId__c 
            FROM 
                Account
            WHERE
                ID=:accountId]?.Id;
    }

    private static List<Account> queryPartnerAccountGroupIds(
        List<Id> accountIds){
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__PartnerPriceAccountGroupId__c'
        }, 'Account');
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

    private static Id queryCustomerAccountGroupId(
        Id accountId){
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__CustomerPriceAccountGroupId__c'
        }, 'Account');
        return [
            SELECT 
                dmpl__CustomerPriceAccountGroupId__c 
            FROM 
                Account
            WHERE
                ID=:accountId]?.dmpl__CustomerPriceAccountGroupId__c;
    }

    private static List<Account> queryCustomerAccountGroupIds(
        List<Id> accountIds){

        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__CustomerPriceAccountGroupId__c'
        }, 'Account');
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

    private static date getMinDocumentDate(
        List<SObject> documents,
        List<SObject> lines){
        List<Date> documentDates = new List<Date>();
        for(SObject document : documents){
            if(document.get('dmpl__PriceAsOnDate__c') != null){
                documentDates.add((Date)document.get('dmpl__PriceAsOnDate__c'));
            }else {
                documentDates.add((Date)document.get(FIELDNAME_SALEORDER_DOCUMENTDATE));
            }
        }
        for(SObject line : lines){
            if(line.get('dmpl__PriceAsOnDate__c') != null){
                documentDates.add((Date)line.get('dmpl__PriceAsOnDate__c'));
            }
        }
        if(documentDates.size()>0){
            documentDates.sort();
            return documentDates[0];
        }
        return null;
    }

    @TestVisible
    private static SaleOrder__c getSaleOrder(
        SaleOrderLine__c saleOrderLine, 
        List<SaleOrder__c> ofSaleOrders){
        for(SaleOrder__c saleOrder : ofSaleOrders){
            if(saleOrderLine.SaleOrderId__c == saleOrder.Id){
                return saleOrder;
            }
        }
        return null;
    }

    @TestVisible
    private static SaleReturn__c getSaleReturn(
        SaleReturnLine__c saleReturnLine, 
        List<SaleReturn__c> ofSaleReturns){
        for(SaleReturn__c saleReturn : ofSaleReturns){
            if(saleReturnLine.SaleReturnId__c == saleReturn.Id){
                return saleReturn;
            }
        }
        return null;
    }

    @TestVisible
    private static BillReturn__c getBillReturn(
        BillReturnLine__c billReturnLine, 
        List<BillReturn__c> ofBillReturns){
        for(BillReturn__c billReturn : ofBillReturns){
            if(billReturnLine.BillReturnId__c == billReturn.Id){
                return billReturn;
            }
        }
        return null;
    }

    private static dmpl__InventoryAdjustment__c getAdjustment(
        dmpl__InventoryAdjustmentLine__c adjustmentLine, 
        List<dmpl__InventoryAdjustment__c> ofAdjustments){
        for(dmpl__InventoryAdjustment__c adjustment : ofAdjustments){
            if(adjustmentLine.dmpl__InventoryAdjustmentId__c == adjustment.Id){
                return adjustment;
            }
        }
        return null;
    }

     @TestVisible
    private static Sobject getSObject(
        SObject saleOrderLine, 
        List<SObject> ofSaleOrders, string relatedField){
        for(SObject saleOrder : ofSaleOrders){
            if(saleOrderLine.get(relatedField) == saleOrder.Id){
                return saleOrder;
            }
        }
        return null;
    }

    @TestVisible
    private static PurchaseOrder__c getPurchaseOrder(
        PurchaseOrderLine__c purchaseOrderLine, 
        List<PurchaseOrder__c> purchaseOrders){
        for(PurchaseOrder__c purchaseOrder : purchaseOrders){
            if(purchaseOrderLine.PurchaseOrderId__c == purchaseOrder.Id){
                return purchaseOrder;
            }
        }
        return null;
    }

    @TestVisible
    private static AutoPurchaseOrder__c getAutoPurchaseOrder(
        AutoPurchaseOrderLine__c autoPurchaseOrderLine, 
        List<AutoPurchaseOrder__c> autoPurchaseOrders){
        for(AutoPurchaseOrder__c autoPurchaseOrder : autoPurchaseOrders){
            if(autoPurchaseOrderLine.AutoPurchaseOrderId__c == autoPurchaseOrder.Id){
                return autoPurchaseOrder;
            }
        }
        return null;
    }

    @TestVisible
    private static Bill__c getPurchaseInvoice(
        BillLine__c purchaseInvoiceLine, 
        List<Bill__c> purchaseInvoices){
        for(Bill__c purchaseInvoice : purchaseInvoices){
            if(purchaseInvoiceLine.PurchaseInvoiceId__c == purchaseInvoice.Id){
                return purchaseInvoice;
            }
        }
        return null;
    }

    @TestVisible
    private static Quote__c getQuote(
        QuoteLine__c quoteLine, 
        List<Quote__c> quotes){
        for(Quote__c quote : quotes){
            if(quoteLine.QuoteId__c == quote.Id){
                return quote;
            }
        }
        return null;
    }

    @TestVisible
    private static ServiceRequest__c getServiceRequest(
        ServiceRequestLine__c serviceRequestLine, 
        List<ServiceRequest__c> serviceRequests){
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
    private static RepairOrder__c getRepairOrder(
        RepairOrderLine__c repairOrderLine, 
        List<RepairOrder__c> repairOrders){
        for(RepairOrder__c repairOrder : repairOrders){
            if(repairOrderLine.RepairOrderId__c == repairOrder.Id){
                return repairOrder;
            }
        }
        return null;
    }

    @TestVisible
    private static SaleInvoice__c getSaleInvoice(
        SaleInvoiceLine__c saleInvoiceLine, 
        List<SaleInvoice__c> ofSaleInvoices){
        for(SaleInvoice__c saleInvoice : ofSaleInvoices){
            if(saleInvoiceLine.SaleInvoiceId__c == saleInvoice.Id){
                return saleInvoice;
            }
        }
        return null;
    }

    private static Id getPartnerAccountGroupId(
        Id partnerAccountId, 
        List<Account> partnerAccountGroupIds){
        for(Account account : partnerAccountGroupIds){
            if(account.Id == partnerAccountId){
                return account.dmpl__PartnerPriceAccountGroupId__c;
            }
        }
        return null;
    }

    private static Id getCustomerAccountGroupId(
        Id customerAccountId, 
        List<Account> customerAccountGroupIds){
        for(Account account : customerAccountGroupIds){
            if(account.Id == customerAccountId){
                return account.dmpl__CustomerPriceAccountGroupId__c;
            }
        }
        return null;
    }
}