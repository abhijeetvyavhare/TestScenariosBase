public with sharing class TaxHelper {
    private static final string FIELDNAME_TAXGROUPID = 'dmpl__TaxGroupId__c';
    private static final string FIELDNAME_TAXID = 'dmpl__TaxId__c';
    private static final string FIELDNAME_TAXELIGBLEAMOUNT = 'dmpl__TCSEligibleAmount__c';
    private static final string FIELDNAME_PARTNERACCOUNTID = 'dmpl__PartnerAccountId__c';

    private static final List<String> LIST_FIELDS_TAXPOSTING = new List<String>{
        'dmpl__TaxId__c',
        'dmpl__TaxAmount__c',
        'dmpl__TaxGroupId__c',
        'dmpl__TaxOnAmount__c',
        'dmpl__TaxRate__c'
    };

    private static final List<String> LIST_TAX_NAMES = new List<String>{
        'Tax1',
        'Tax2',
        'Tax3',
        'Tax4', 
        'Tax5',
        'Tax6'
    };

    public static void setLinesTaxes(
        List<SObject> lines){
            setLineTaxValues(
                lines);
        }

    public static void createLinesTaxes(
        Boolean isNew,
        List<SObject> lines){
            if(OrgSettingHelper.disableTaxPosting()){
                return;
            }
            createTaxePostings(
                isNew,
                lines);
        }
    
    public static void setHeaderTaxes(
        List<SObject> headers){
            setHeaderTaxValues(
                headers);
        }

    public static void createHeaderTaxes(
        Boolean isNew,
        List<SObject> headers){
            if(OrgSettingHelper.disableTaxPosting()){
                return;
            }
            createHeaderTaxPostings(
                isNew,
                headers);
        }

    public static void deleteLinesTaxes(
        List<SObject> lines){
            if(OrgSettingHelper.disableTaxPosting()){
                return;
            }
            if(lines == null 
                || lines.size() == 0){
                return;
            }
            String sObjectName = getSObjectName(
                lines);
            if(sObjectName == null){
                return;
            }
            String taxPostingObjectName = getTaxPostingObjectName(
                sObjectName);
            List<SObject> existingTaxes = queryExistingLineTaxes(
                taxPostingObjectName,
                DocumentHelper.extractIds(
                    lines));
            SecurityHelper.ensureCanDeleteObject(
                taxPostingObjectName);
            delete existingTaxes;
        }

    public static void deleteHeaderTaxes(
        List<SObject> headers){
            if(OrgSettingHelper.disableTaxPosting()){
                return;
            }
            if(headers == null 
                || headers.size() == 0){
                return;
            }
            String sObjectName = getSObjectName(
                headers);
            if(sObjectName == null){
                return;
            }
            String taxPostingObjectName = getTaxPostingObjectName(
                sObjectName);
            List<SObject> existingTaxes = queryExistingHeaderTaxes(
                taxPostingObjectName,
                DocumentHelper.extractIds(
                    headers));
            SecurityHelper.ensureCanDeleteObject(
                taxPostingObjectName);
            delete existingTaxes;
        }
    
    private static void setLineTaxValues(
        List<SObject> lines){
            String sObjectName = getSObjectName(
                lines);
            if(sObjectName == null){
                return;
            }
            Map<Id, SObject> headers = queryHeaders(
                sObjectName,
                getHeaderObjectName(
                    sObjectName), 
                lines);
            Map<Id, dmpl__TaxGroup__c> taxGroups = queryTaxGroupsWithTaxes(
                DocumentHelper.extractIds(
                    lines, 
                    FIELDNAME_TAXGROUPID));
            for(SObject line : lines){
                SObject header = headers.get(
                    (Id)line.get(getHeaderFieldName(sObjectName)));
                if(header != null){
                    Account partnerAccount = (Account)header.getSObject('dmpl__PartnerAccountId__r');
                    if(partnerAccount !=null){
                        line.put(
                            'dmpl__ApplyPostTaxDiscount__c', 
                            partnerAccount?.dmpl__ApplyPostTaxDiscount__c);
                    }
                }

                reSetLineTax(line);
                if(line.get(FIELDNAME_TAXGROUPID) == null){
                    continue;
                }
                dmpl__TaxGroup__c taxGroup = taxGroups.get(
                    (Id)line.get(FIELDNAME_TAXGROUPID));
                if(taxGroup == null){
                    continue;
                }
                
                Decimal totalTaxAmount = 0;
                for(Tax__c tax : taxGroup.Taxes__r){
                    totalTaxAmount = totalTaxAmount + setLineTax(tax, line); 
                }
                line.put(
                    'dmpl__TaxAmount__c', 
                    totalTaxAmount);
            }
        }

    private static void createTaxePostings(
        Boolean isNew,
        List<SObject> lines){
            String sObjectName = getSObjectName(
                lines);
            if(sObjectName == null){
                return;
            }
            String taxPostingObjectName = getTaxPostingObjectName(
                sObjectName);
            Map<Id, dmpl__TaxGroup__c> taxGroups = queryTaxGroupsWithTaxes(
                DocumentHelper.extractIds(
                    lines, 
                    FIELDNAME_TAXGROUPID));
            List<SObject> existingTaxes = isNew 
                ? null 
                : queryExistingLineTaxes(
                    taxPostingObjectName,
                    DocumentHelper.extractIds(
                        lines));
            List<SObject> lineTaxes = new List<SObject>();
            for(SObject line : lines){
                if(line.get(FIELDNAME_TAXGROUPID) == null){
                    continue;
                }
                dmpl__TaxGroup__c taxGroup = taxGroups.get(
                    (Id)line.get(FIELDNAME_TAXGROUPID));
                if(taxGroup == null){
                    continue;
                }
                for(Tax__c tax : taxGroup.Taxes__r){
                    SObject lineTax = null;
                    if (!isNew){
                        lineTax = popLineTax(
                            existingTaxes, 
                            tax,
                            line,
                            taxPostingObjectName);
                    }
                    lineTaxes.Add(
                        createLineTax(
                            sObjectName,
                            taxPostingObjectName,
                            tax, 
                            line,
                            lineTax));
                }
            }
            if(!isNew){
                SecurityHelper.ensureCanDeleteObject(
                    taxPostingObjectName);
                delete existingTaxes;
            }
            SecurityHelper.ensureCanCreateObject(
                taxPostingObjectName);
            SecurityHelper.ensureCanCreateFields(
                LIST_FIELDS_TAXPOSTING, 
                taxPostingObjectName);
            upsert lineTaxes;
        }

    private static void setHeaderTaxValues(
        List<SObject> headers){
            String sObjectName = getSObjectName(
                headers);
            if(sObjectName == null){
                return;
            }
            Map<Id, dmpl__TaxGroup__c> taxGroups = queryTaxGroupsWithTaxes(
                DocumentHelper.extractIds(
                    headers, 
                    FIELDNAME_TAXGROUPID));
            for(SObject header : headers){
                reSetHeaderTax(header);
                if(header.get(FIELDNAME_TAXGROUPID) == null 
                    || header.get(FIELDNAME_TAXID) == null
                    || header.get(FIELDNAME_TAXELIGBLEAMOUNT) == null){
                        continue;
                }
                dmpl__TaxGroup__c taxGroup = taxGroups.get((Id)header.get(FIELDNAME_TAXGROUPID));
                if(taxGroup == null){
                    continue;
                }
                for(Tax__c tax : taxGroup.Taxes__r){
                    if((Id)header.get('dmpl__TaxId__c') == tax.Id){
                        setHeaderTax(
                            tax, 
                            header);
                    }
                }
            }
        }

    private static void createHeaderTaxPostings(
        Boolean isNew,
        List<SObject> headers){
            String sObjectName = getSObjectName(
                headers);
            if(sObjectName == null){
                return;
            }
            String taxPostingObjectName = getTaxPostingObjectName(
                sObjectName);
            Map<Id, dmpl__TaxGroup__c> taxGroups = queryTaxGroupsWithTaxes(
                DocumentHelper.extractIds(
                    headers, 
                    FIELDNAME_TAXGROUPID));
            List<SObject> existingHeaderTaxes = isNew 
                ? null 
                : queryExistingHeaderTaxes(
                    taxPostingObjectName,
                        DocumentHelper.extractIds(
                            headers));
            List<SObject> headerTaxes = new List<SObject>();
            for(SObject header : headers){
                if(header.get(FIELDNAME_TAXGROUPID) == null 
                    || header.get(FIELDNAME_TAXID) == null
                    || header.get(FIELDNAME_TAXELIGBLEAMOUNT) == null){
                        continue;
                }
                dmpl__TaxGroup__c taxGroup = taxGroups.get(
                    (Id)header.get(FIELDNAME_TAXGROUPID));
                if(taxGroup == null){
                    continue;
                }
                for(Tax__c tax : taxGroup.Taxes__r){
                    if((Id)header.get('dmpl__TaxId__c') == tax.Id){
                        SObject headerTax = null;
                        if (!isNew){
                            headerTax = popHeaderTax(
                                existingHeaderTaxes, 
                                tax,
                                header,
                                taxPostingObjectName);
                        }
                        headerTaxes.Add(
                            createHeaderTax(
                                taxPostingObjectName,
                                tax, 
                                header,
                                headerTax));
                    }
                }
            }
            
            if(!isNew){    
                SecurityHelper.ensureCanDeleteObject(
                    taxPostingObjectName);
                delete existingHeaderTaxes;
            }
            SecurityHelper.ensureCanCreateObject(
                taxPostingObjectName);
            SecurityHelper.ensureCanCreateFields(
                LIST_FIELDS_TAXPOSTING, 
                taxPostingObjectName);
            upsert headerTaxes;    
        }

    private static Decimal calculateLineAmount(SObject line){
        Map<String, Schema.SObjectField> lineFieldMap = line.getSObjectType().getDescribe().fields.getMap();
        Decimal UnitPrice2 = 0;
        if(lineFieldMap.containsKey('dmpl__UnitPrice2__c')){
            UnitPrice2 = (Decimal)line.get('dmpl__UnitPrice2__c') > 0 
                ? ((Decimal)line.get('dmpl__UnitPrice2__c')) 
                : ((Decimal)line.get('dmpl__UnitPrice__c') > 0 
                    ? (Decimal)line.get('dmpl__UnitPrice__c') 
                    : 0);               
        }else if(lineFieldMap.containsKey('dmpl__UnitCost2__c')){
            UnitPrice2 = (Decimal)line.get('dmpl__UnitCost2__c') > 0 
                ? ((Decimal)line.get('dmpl__UnitCost2__c')) 
                : ((Decimal)line.get('dmpl__UnitCost__c') > 0 
                    ? (Decimal)line.get('dmpl__UnitCost__c') 
                    : 0);               
        }
        
        Decimal quantity = ((Decimal)line.get('dmpl__Quantity__c') > 0 
                    ? (Decimal)line.get('dmpl__Quantity__c') 
                    : 0);
        if(lineFieldMap.containsKey('dmpl__CancelledQuantity__c')){
            quantity = quantity - ((Decimal)line.get('dmpl__CancelledQuantity__c') > 0 
                    ? (Decimal)line.get('dmpl__CancelledQuantity__c') 
                    : 0);
        }
        Decimal BaseAmount = UnitPrice2 * quantity; 
        
        // calculate SchemeDiscountAmount
        Decimal SchemeDiscountAmount = 0;
        if(lineFieldMap.containsKey('dmpl__SchemeDiscount__c')){
            Decimal SchemeDiscount = (Decimal)line.get('dmpl__SchemeDiscount__c') > 0 
                ? ((Decimal)line.get('dmpl__SchemeDiscount__c')/100) 
                : 0;
            if((Decimal)line.get('dmpl__SchemeDiscountAmount__c') > 0){
                SchemeDiscountAmount = (Decimal)line.get('dmpl__SchemeDiscountAmount__c');
            } else if((Decimal)line.get('dmpl__SchemeDiscount__c') > 0){
                SchemeDiscountAmount= BaseAmount * SchemeDiscount;
            }
        }

        // calculate DiscountAmount
        Decimal DiscountAmount = 0;
        if(lineFieldMap.containsKey('dmpl__Discount__c')){
            Decimal Discount = (Decimal)line.get('dmpl__Discount__c') > 0 
                ? ((Decimal)line.get('dmpl__Discount__c')/100) 
                : 0;
            if((Decimal)line.get('dmpl__DiscountAmount__c') > 0){
                DiscountAmount = (Decimal)line.get('dmpl__DiscountAmount__c');
            }else if((Decimal)line.get('dmpl__Discount__c') > 0){
                DiscountAmount = BaseAmount* Discount;
            }
        }

        // calculate DiscountAmount2
        Decimal DiscountAmount2 = 0;
        if(lineFieldMap.containsKey('dmpl__Discount2__c')){
            Decimal Discount2 = (Decimal)line.get('dmpl__Discount2__c') > 0 
                ? ((Decimal)line.get('dmpl__Discount2__c')/100) 
                : 0;
            if((Decimal)line.get('dmpl__DiscountAmount2__c') > 0){
                DiscountAmount2 = (Decimal)line.get('dmpl__DiscountAmount2__c');
            }else if((Decimal)line.get('dmpl__Discount2__c') > 0){
                DiscountAmount2 = BaseAmount * Discount2;
            }
        }

            // calculate ContractDiscountAmount
        Decimal ContractDiscountAmount = 0;
        if(lineFieldMap.containsKey('dmpl__ContractDiscount__c')){
            Decimal ContractDiscount = (Decimal)line.get('dmpl__ContractDiscount__c') > 0 
                ? ((Decimal)line.get('dmpl__ContractDiscount__c')/100) 
                : 0;
            if((Decimal)line.get('dmpl__ContractDiscountAmount__c') > 0){
                ContractDiscountAmount = (Decimal)line.get('dmpl__ContractDiscountAmount__c');
            }else if((Decimal)line.get('dmpl__ContractDiscount__c') >0){
                ContractDiscountAmount = BaseAmount * ContractDiscount;
            }
        }

        return ((Boolean)line.get('dmpl__ApplyPostTaxDiscount__c'))
            ? (BaseAmount)
            : (BaseAmount 
                - SchemeDiscountAmount 
                - DiscountAmount 
                - DiscountAmount2 
                - ContractDiscountAmount);
    }

    private static String getSObjectName(
        List<SObject> objects){
        if(objects == null 
            || objects.size() == 0){
            return null;
        }
        SObject aObject = objects[0];
        if(aObject == null){
            return null;
        }
        return aObject
            .getSObjectType()
            .getDescribe()
            .getName();
    }

    private static String getTaxPostingObjectName(
        String sObjectName){
        if(sObjectName == null){
            return null;
        }
        if(sObjectName == 'dmpl__SaleOrderLine__c' 
            || sObjectName == 'dmpl__SaleOrder__c'){
            return 'dmpl__SaleOrderTax__c';
        }else if (sObjectName == 'dmpl__SaleInvoiceLine__c' 
            || sObjectName == 'dmpl__SaleInvoice__c'){
            return 'dmpl__SaleInvoiceTax__c';
        }else if (sObjectName == 'dmpl__PurchaseOrderLine__c' 
            || sObjectName == 'dmpl__PurchaseOrder__c'){
            return 'dmpl__PurchaseOrderTax__c';
        }else if (sObjectName == 'dmpl__RepairOrderLine__c' 
            || sObjectName == 'dmpl__RepairOrder__c'){
            return 'dmpl__RepairOrderTax__c';
        }else if (sObjectName == 'dmpl__QuoteLine__c' 
            || sObjectName == 'dmpl__Quote__c'){
            return 'dmpl__QuoteTax__c';
        }else if (sObjectName == 'dmpl__ServiceRequestLine__c' 
            || sObjectName == 'dmpl__ServiceRequest__c'){
            return 'dmpl__ServiceRequestTax__c';
        }else if (sObjectName == 'dmpl__BillReturnLine__c' 
            || sObjectName == 'dmpl__BillReturn__c'){
            return 'dmpl__BillReturnTax__c';
        }else if (sObjectName == 'dmpl__DeliveryOrderLine__c' 
            || sObjectName == 'dmpl__DeliveryOrder__c'){
            return 'dmpl__DeliveryOrderTax__c';
        }else if (sObjectName == 'dmpl__SaleReturnLine__c' 
            || sObjectName == 'dmpl__SaleReturn__c'){
            return 'dmpl__SaleReturnTax__c';
        }else if (sObjectName == 'dmpl__BillLine__c' 
            || sObjectName == 'dmpl__Bill__c'){
            return 'dmpl__PurchaseInvoiceTax__c';
        }
        return null;
    }

    private static String getTaxPostingHeaderFieldName(
        String sObjectName){
        if(sObjectName == null){
            return null;
        }
        if(sObjectName == 'dmpl__SaleOrderTax__c'){
            return 'dmpl__SaleOrderId__c';
        }else if(sObjectName == 'dmpl__SaleInvoiceTax__c'){
            return 'dmpl__SaleInvoiceId__c';
        }else if(sObjectName == 'dmpl__PurchaseOrderTax__c'){
            return 'dmpl__PurchaseOrderId__c';
        }else if(sObjectName == 'dmpl__RepairOrderTax__c'){
            return 'dmpl__RepairOrderId__c';
        }else if(sObjectName == 'dmpl__QuoteTax__c'){
            return 'dmpl__QuoteId__c';
        }else if(sObjectName == 'dmpl__ServiceRequestTax__c'){
            return 'dmpl__ServiceRequestId__c';
        }else if(sObjectName == 'dmpl__BillReturnTax__c'){
            return 'dmpl__BillReturnId__c';
        }else if(sObjectName == 'dmpl__DeliveryOrderTax__c'){
            return 'dmpl__DeliveryOrderId__c';
        }else if(sObjectName == 'dmpl__SaleReturnTax__c'){
            return 'dmpl__SaleReturnId__c';
        }else if(sObjectName == 'dmpl__PurchaseInvoiceTax__c'){
            return 'dmpl__BillId__c';
        }
        return null;
    }

    private static String getTaxPostingLineFieldName(
        String sObjectName){
        if(sObjectName == null){
            return null;
        }
        if(sObjectName == 'dmpl__SaleOrderTax__c'){
            return 'dmpl__SaleOrderLineId__c';
        }else if(sObjectName == 'dmpl__SaleInvoiceTax__c'){
            return 'dmpl__SaleInvoiceLineId__c';
        }else if(sObjectName == 'dmpl__PurchaseOrderTax__c'){
            return 'dmpl__PurchaseOrderLineId__c';
        }else if(sObjectName == 'dmpl__RepairOrderTax__c'){
            return 'dmpl__RepairOrderLineId__c';
        }else if(sObjectName == 'dmpl__QuoteTax__c'){
            return 'dmpl__QuoteLineId__c';
        }else if(sObjectName == 'dmpl__ServiceRequestTax__c'){
            return 'dmpl__ServiceRequestLineId__c';
        }else if(sObjectName == 'dmpl__BillReturnTax__c'){
            return 'dmpl__BillReturnLineId__c';
        }else if(sObjectName == 'dmpl__DeliveryOrderTax__c'){
            return 'dmpl__DeliveryOrderLineId__c';
        }else if(sObjectName == 'dmpl__SaleReturnTax__c'){
            return 'dmpl__SaleReturnLineId__c';
        }else if(sObjectName == 'dmpl__PurchaseInvoiceTax__c'){
            return 'dmpl__BillLineId__c';
        }
        return null;
    }

    private static String getHeaderFieldName(
        String sObjectName){
        if(sObjectName == null){
            return null;
        }
        if(sObjectName == 'dmpl__SaleOrderLine__c'){
            return 'dmpl__SaleOrderId__c';
        }else if(sObjectName == 'dmpl__SaleInvoiceLine__c'){
            return 'dmpl__SaleInvoiceId__c';
        }else if(sObjectName == 'dmpl__PurchaseOrderLine__c'){
            return 'dmpl__PurchaseOrderId__c';
        }else if(sObjectName == 'dmpl__RepairOrderLine__c'){
            return 'dmpl__RepairOrderId__c';
        }else if(sObjectName == 'dmpl__QuoteLine__c'){
            return 'dmpl__QuoteId__c';
        }else if(sObjectName == 'dmpl__ServiceRequestLine__c'){
            return 'dmpl__ServiceRequestId__c';
        }else if(sObjectName == 'dmpl__BillReturnLine__c'){
            return 'dmpl__BillReturnId__c';
        }else if(sObjectName == 'dmpl__DeliveryOrderLine__c'){
            return 'dmpl__DeliveryId__c';
        }else if(sObjectName == 'dmpl__SaleReturnLine__c'){
            return 'dmpl__SaleReturnId__c';
        }else if(sObjectName == 'dmpl__BillLine__c'){
            return 'dmpl__PurchaseInvoiceId__c';
        }
        return null;
    }

    private static String getHeaderObjectName(
        String sObjectName){
            if(sObjectName == null){
                return null;
            }
            if(sObjectName == 'dmpl__SaleOrderLine__c'){
                return 'dmpl__SaleOrder__c';
            }else if(sObjectName == 'dmpl__SaleInvoiceLine__c'){
                return 'dmpl__SaleInvoice__c';
            }else if(sObjectName == 'dmpl__PurchaseOrderLine__c'){
                return 'dmpl__PurchaseOrder__c';
            }else if(sObjectName == 'dmpl__RepairOrderLine__c'){
                return 'dmpl__RepairOrder__c';
            }else if(sObjectName == 'dmpl__QuoteLine__c'){
                return 'dmpl__Quote__c';
            }else if(sObjectName == 'dmpl__ServiceRequestLine__c'){
                return 'dmpl__ServiceRequest__c';
            }else if(sObjectName == 'dmpl__BillReturnLine__c'){
                return 'dmpl__BillReturn__c';
            }else if(sObjectName == 'dmpl__DeliveryOrderLine__c'){
                return 'dmpl__DeliveryOrder__c';
            }else if(sObjectName == 'dmpl__SaleReturnLine__c'){
                return 'dmpl__SaleReturn__c';
            }else if(sObjectName == 'dmpl__BillLine__c'){
                return 'dmpl__Bill__c';
            }
            return null;
        }

    private static SObject popLineTax(
        List<SObject> existingTaxes,
        Tax__c tax,
        SObject line,
        String taxPostingObjectName){
            if(existingTaxes == null){
                return null;
            }
            SObject taxLinePopped = null;
            for(SObject taxLine : existingTaxes){
                if(taxLine.get(
                    getTaxPostingLineFieldName(
                        taxPostingObjectName)) == line.Id 
                    && taxLine.get('dmpl__TaxId__c') == tax.Id){
                    taxLinePopped = taxLine;
                    break;
                }
            }
            if(taxLinePopped !=null){
                existingTaxes.remove(existingTaxes.indexOf(taxLinePopped));
            }
            return taxLinePopped;
        }

    private static SObject popHeaderTax(
        List<SObject> existingTaxes,
        Tax__c tax,
        SObject header,
        String taxPostingObjectName){
            if(existingTaxes == null){
                return null;
            }
            SObject taxLinePopped = null;
            for(SObject taxLine : existingTaxes){
                if(taxLine.get(getTaxPostingLineFieldName(taxPostingObjectName)) == null 
                    && taxLine.get(getTaxPostingHeaderFieldName(taxPostingObjectName)) == header.Id
                    && taxLine.get('dmpl__TaxId__c') == tax.Id){
                    taxLinePopped = taxLine;
                    break;
                }
            }
            if(taxLinePopped !=null){
                existingTaxes.remove(existingTaxes.indexOf(taxLinePopped));
            }
            return taxLinePopped;
        }

    private static SObject createLineTax(
        String sObjectName,
        String taxPostingObjectName,
        Tax__c tax, 
        SObject line,
        SObject lineTax){
            if(lineTax == null){
                lineTax = (SObject)Type.forName(
                    taxPostingObjectName).newInstance();
            }
            
            if(lineTax.get(
                getTaxPostingLineFieldName(
                    taxPostingObjectName)) == null){
                lineTax.put(
                    getTaxPostingLineFieldName(
                            taxPostingObjectName), 
                        line.Id);
            }
            if(lineTax.get(
                getTaxPostingHeaderFieldName(
                    taxPostingObjectName)) == null){
                lineTax.put(
                    getTaxPostingHeaderFieldName(
                            taxPostingObjectName), 
                        (Id)line.get(
                            getHeaderFieldName(sObjectName)));
            }
            lineTax.put('dmpl__TaxId__c', tax.Id);
            lineTax.put('dmpl__TaxAmount__c', ((Decimal)line.get('dmpl__Amount__c') * tax.Rate__c) / 100);
            lineTax.put('dmpl__TaxGroupId__c', (Id)line.get('dmpl__TaxGroupId__c'));
            if(taxPostingObjectName == 'dmpl__BillReturnTax__c'){
                lineTax.put('dmpl__TaxOnLineAmount__c', (Decimal)line.get('dmpl__Amount__c'));
            }else {
                lineTax.put('dmpl__TaxOnAmount__c', (Decimal)line.get('dmpl__Amount__c'));
            }
            lineTax.put('dmpl__TaxRate__c', tax.Rate__c);
            return lineTax;
        }

    private static Decimal setLineTax(
        Tax__c tax, 
        SObject line){
            Decimal taxAmount = (calculateLineAmount(line) * tax.Rate__c) / 100;
            if(tax.dmpl__PostingFieldName__c == null){
                return taxAmount;
            }
            line.put(
                'dmpl__' + tax.dmpl__PostingFieldName__c + '__c', 
                taxAmount);
            line.put(
                'dmpl__' + tax.dmpl__PostingFieldName__c + 'Rate__c',
                tax.Rate__c);
            line.put(
                'dmpl__' + tax.dmpl__PostingFieldName__c + 'Name__c', 
                tax.Name);
            line.put(
                'dmpl__' + tax.dmpl__PostingFieldName__c + 'Type__c', 
                tax.dmpl__Type__c);
            return taxAmount;
        }

    private static void reSetLineTax(
        SObject line){
            for(String fieldName : LIST_TAX_NAMES){
                line.put(
                    'dmpl__' + fieldName + '__c', 
                    null);
                line.put(
                    'dmpl__' + fieldName + 'Rate__c',
                    null);
                line.put(
                    'dmpl__' + fieldName + 'Name__c', 
                    null);
                line.put(
                    'dmpl__' + fieldName + 'Type__c', 
                    null);
            }
        }

    private static SObject createHeaderTax(
        String taxPostingObjectName,
        Tax__c tax, 
        SObject header,
        SObject headerTax){
            Map<String, Object> headerMap = header.getPopulatedFieldsAsMap();
            if(headerTax == null){
                headerTax = (SObject)Type.forName(
                    taxPostingObjectName).newInstance();
            }
            if(headerTax.get(
                getTaxPostingHeaderFieldName(
                    taxPostingObjectName)) == null){
                headerTax.put(
                    getTaxPostingHeaderFieldName(taxPostingObjectName), 
                    header.Id);
            }
            headerTax.put(
                'dmpl__TaxId__c', 
                tax.Id);
            if(headerMap.containsKey('dmpl__TCSEligibleAmount__c')){
                headerTax.put(
                    'dmpl__TaxAmount__c', 
                    ((Decimal)header.get('dmpl__TCSEligibleAmount__c') * tax.Rate__c) / 100);
                headerTax.put(
                    'dmpl__TaxOnAmount__c', 
                    (Decimal)header.get('dmpl__TCSEligibleAmount__c'));
            }
            if(headerMap.containsKey('dmpl__TaxGroupId__c')){
                headerTax.put(
                    'dmpl__TaxGroupId__c', 
                    (Id)header.get('dmpl__TaxGroupId__c'));
            }
            headerTax.put(
                'dmpl__TaxRate__c', 
                tax.Rate__c);
            return headerTax;
        }
  
    private static void setHeaderTax(
        Tax__c tax, 
        SObject header){
            String postingFieldName = 'Tax1';
            header.put(
                'dmpl__' 
                    + postingFieldName
                    + '__c', 
                ((Decimal)header.get(
                    'dmpl__TCSEligibleAmount__c') 
                    * tax.Rate__c) / 100);
            header.put(
                'dmpl__' 
                    + postingFieldName
                    + 'Rate__c',
                tax.Rate__c);
            header.put(
                'dmpl__' 
                    + postingFieldName
                    + 'Name__c', 
                tax.Name);
            header.put(
                'dmpl__' 
                    + postingFieldName 
                    + 'Type__c', 
                tax.dmpl__Type__c);
        }

    private static void reSetHeaderTax(
        SObject header){
            String postingFieldName = 'Tax1';
            header.put(
                'dmpl__' 
                    + postingFieldName
                    + '__c', 
                null);
            header.put(
                'dmpl__' 
                    + postingFieldName
                    + 'Rate__c',
                null);
            header.put(
                'dmpl__' 
                    + postingFieldName
                    + 'Name__c', 
                null);
            header.put(
                'dmpl__' 
                    + postingFieldName 
                    + 'Type__c', 
                null);
        }

    private static Map<Id, dmpl__TaxGroup__c> queryTaxGroupsWithTaxes(
        List<Id> taxGroupIds){
        SecurityHelper.ensureCanReadFields(new String[]{
            'dmpl__Rate__c',
            'dmpl__TaxGroupId__c'
        },'dmpl__Tax__c');
        return new Map<Id,dmpl__TaxGroup__c>([
            SELECT Id,
                (SELECT 
                    Id, 
                    Name,
                    dmpl__Rate__c,
                    dmpl__Type__c,
                    dmpl__PostingFieldName__c
                FROM dmpl__Taxes__r)
            FROM dmpl__TaxGroup__c
            WHERE Id IN:taxGroupIds
        ]);
    }
 
    private static Map<Id, SObject> queryHeaders(
        String lineObjectName,
        String sObjectName,
        List<SObject> lines){
        List<Id> headerIds = DocumentHelper.extractIds(
            lines, 
            getHeaderFieldName(
                lineObjectName));
        // SecurityHelper.ensureCanReadFields(new String[]{'dmpl__PartnerAccountId__c'},'SObject');
        // SecurityHelper.ensureCanReadFields(new String[]{'dmpl__ApplyPostTaxDiscount__c'},'dmpl__Account__c');
        return new Map<Id,SObject>(
            Database.query(
                'SELECT Id, ' +
                'dmpl__PartnerAccountId__c, ' +
                'dmpl__PartnerAccountId__r.dmpl__ApplyPostTaxDiscount__c ' +
                'FROM ' + sObjectName + ' ' +
                'WHERE Id IN : headerIds'));
    }
   
    private static List<SObject> queryExistingLineTaxes(
        String sObjectName,
        List<id> lineIds){
        SecurityHelper.ensureCanReadFields(new String[]{
            'Id'}, sObjectName);
        String lineFieldName = getTaxPostingLineFieldName(
            sObjectName);
        String headerFieldName = getTaxPostingHeaderFieldName(
            sObjectName);
        return Database.query('SELECT Id, dmpl__TaxId__c, ' 
            + lineFieldName + ', '
            + headerFieldName
            + ' FROM ' 
            + sObjectName
            + '  WHERE ' 
            +  lineFieldName
            + '  IN :lineIds');
    }
       
    private static List<SObject> queryExistingHeaderTaxes(
        String sObjectName,
        List<Id> headerIds){
        // SecurityHelper.ensureCanReadFields(new String[]{
        //     'Id'
        // },sObjectName);
        String lineFieldName = getTaxPostingLineFieldName(
            sObjectName);
        String headerFieldName = getTaxPostingHeaderFieldName(
            sObjectName);
        return Database.query('SELECT Id, dmpl__TaxId__c,' 
            + lineFieldName + ', '
            + headerFieldName
            +' FROM ' 
            + sObjectName 
            + '  WHERE ' 
            + lineFieldName 
            + ' = null AND '
            + headerFieldName
            + '  IN :headerIds');
    }
}