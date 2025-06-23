public with sharing class BillReturnTaxHelper {
    
    private static final string FIELDNAME_BILLRETURNLINE_TAXGROUPID = 'dmpl__TaxGroupId__c';
    private static final string FIELD_RETURNTAX_BILLRETURNID = 'dmpl__BillReturnId__c';
    private static final string FIELD_PURCHASERETURNTAX_PURCHASEINVOICELINEID = 'dmpl__BillLineId__c';


    public static void setNewApplicableTaxes(List<dmpl__BillReturnLine__c> billReturnLines){
        dmpl__DMSOrgSetting__mdt  orgSetting = OrgSettingHelper.OrgSetting();
        if(orgSetting != null && orgSetting.dmpl__CopyTaxesInPurchaseReturn__c){
            copyInvoiceLineTaxesInternal(DocumentHelper.getObjectsWithNotNull(billReturnLines, 'dmpl__BillLineId__c'), orgSetting, true);
            setApplicableTaxesInternal(DocumentHelper.getObjectsWithNull(billReturnLines, 'dmpl__BillLineId__c'), true);
        } else {
            setApplicableTaxesInternal(billReturnLines, true);
        }
    }

    public static void setApplicableTaxes(List<dmpl__BillReturnLine__c> billReturnLines){
        dmpl__DMSOrgSetting__mdt  orgSetting = OrgSettingHelper.OrgSetting();
        if(orgSetting != null && orgSetting.dmpl__CopyTaxesInPurchaseReturn__c){
            copyInvoiceLineTaxesInternal(DocumentHelper.getObjectsWithNotNull(billReturnLines, 'dmpl__BillLineId__c'), orgSetting, false);
            setApplicableTaxesInternal(DocumentHelper.getObjectsWithNull(billReturnLines, 'dmpl__BillLineId__c'), false);
        } else {
            setApplicableTaxesInternal(billReturnLines, false);
        }
    }
    
    public static void deleteApplicableTaxes(List<dmpl__BillReturnLine__c> billReturnLines){
        if(billReturnLines == null || billReturnLines.size() == 0)
            return;
        List<dmpl__BillReturnTax__c> existingBillReturnTaxes= queryExistingBillReturnTaxes(DocumentHelper.extractIds(billReturnLines));
        SecurityHelper.ensureCanDeleteObject('dmpl__BillReturnTax__c');
        delete existingBillReturnTaxes;
    }

    public static void setApplicableTaxesInternal(List<dmpl__BillReturnLine__c> billReturnLines, Boolean isNew){
        Map<Id, dmpl__TaxGroup__c> taxGroups = queryTaxGroupsWithTaxes(DocumentHelper.extractIds(billReturnLines, FIELDNAME_BILLRETURNLINE_TAXGROUPID));
        List<dmpl__BillReturnTax__c> billReturnTaxes = new List<dmpl__BillReturnTax__c>();
        List<dmpl__BillReturnTax__c> existingbillReturnTaxes= new List<dmpl__BillReturnTax__c>();
        for(dmpl__BillReturnLine__c billReturnLine : billReturnLines){
            if(billReturnLine.dmpl__TaxGroupId__c == null){
                continue;
            }
            dmpl__TaxGroup__c taxGroup = taxGroups.get(billReturnLine.dmpl__TaxGroupId__c);
            if(taxGroup == null){
                continue;
            }
            for(Tax__c tax : taxGroup.Taxes__r){
                billReturnTaxes.Add(createBillReturnTax(tax, billReturnLine));
            }
        }

        if(!isNew){
            existingbillReturnTaxes= queryExistingBillReturnTaxes(DocumentHelper.extractIds(billReturnLines));
        }

        Savepoint sp = Database.setSavepoint();
        try {
            if(!isNew){
                SecurityHelper.ensureCanDeleteObject('dmpl__BillReturnTax__c');
                delete existingbillReturnTaxes;
            }
            SecurityHelper.ensureCanCreateObject('dmpl__BillReturnTax__c');
            SecurityHelper.ensureCanCreateFields(new String[]{'dmpl__BillReturnLineId__c','dmpl__BillReturnId__c','dmpl__TaxId__c','dmpl__TaxAmount__c','dmpl__TaxGroupId__c','dmpl__TaxOnAmount__c','dmpl__TaxRate__c'}, 'dmpl__BillReturnTax__c');
            insert billReturnTaxes;    
        } catch (Exception e) {
            Database.rollback(sp);
            throw e;
        }
    }

    public static void setLineLevelTaxAmount(
        List<BillReturnLine__c> billReturnLines){
        Map<Id, dmpl__TaxGroup__c> taxGroups = queryTaxGroupsWithTaxes(
            DocumentHelper.extractIds(
                billReturnLines, 
                FIELDNAME_BILLRETURNLINE_TAXGROUPID));
        for(BillReturnLine__c billReturnLine : billReturnLines){
            if(billReturnLine.dmpl__TaxGroupId__c == null){
                continue;
            }
            dmpl__TaxGroup__c taxGroup = taxGroups.get(
                billReturnLine.dmpl__TaxGroupId__c);
            if(taxGroup == null){
                continue;
            }
            billReturnLine.dmpl__TaxAmount__c =0;
            for(Tax__c tax : taxGroup.Taxes__r){
                billReturnLine.dmpl__TaxAmount__c += ((billReturnLine.dmpl__Amount__c * tax.Rate__c) / 100);
            }
        }
    }

    public static dmpl__BillReturnTax__c createBillReturnTax(Tax__c tax, BillReturnLine__c billReturnLine){
        return new dmpl__BillReturnTax__c(
            dmpl__BillReturnLineId__c = billReturnLine.Id,
            dmpl__BillReturnId__c = billReturnLine.dmpl__BillReturnId__c,
            dmpl__TaxId__c = tax.Id,
            dmpl__TaxAmount__c = (billReturnLine.dmpl__Amount__c * tax.Rate__c) / 100,
            dmpl__TaxGroupId__c = billReturnLine.dmpl__TaxGroupId__c,
            dmpl__TaxOnLineAmount__c= billReturnLine.dmpl__Amount__c,
            dmpl__TaxRate__c = tax.Rate__c);
    }

    public static dmpl__BillReturnTax__c createBillReturnTax(dmpl__PurchaseInvoiceTax__c invoiceLineTax, BillReturnLine__c billReturnLine){
        return new dmpl__BillReturnTax__c(
            dmpl__BillReturnLineId__c = billReturnLine.Id,
            dmpl__BillReturnId__c = billReturnLine.dmpl__BillReturnId__c,
            dmpl__TaxId__c = invoiceLineTax.dmpl__TaxId__c,
            dmpl__TaxAmount__c = (billReturnLine.dmpl__Amount__c * invoiceLineTax.dmpl__TaxRate__c) / 100,
            dmpl__TaxGroupId__c = invoiceLineTax.dmpl__TaxGroupId__c,
            dmpl__TaxOnLineAmount__c= billReturnLine.dmpl__Amount__c,
            dmpl__TaxRate__c = invoiceLineTax.dmpl__TaxRate__c);
    }
    
    public static void approveBillTaxLines(List<dmpl__BillReturn__c> returns){
        List<dmpl__BillReturnTax__c> taxLines = queryBillReturnTaxLines(returns);
        for(dmpl__BillReturn__c returnDocument : returns){
            approveTaxLines(DocumentHelper.getObjects(taxLines, FIELD_RETURNTAX_BILLRETURNID, returnDocument.Id));
        }
        SecurityHelper.ensureCanWriteFields(new String[]{'dmpl__IsGLPostingApproved__c'},'dmpl__BillReturnTax__c');
        Update taxLines;    
    }

    public static void copyInvoiceLineTaxesInternal(List<dmpl__BillReturnLine__c> billReturnLines, dmpl__DMSOrgSetting__mdt orgSetting, Boolean isNew){
        List<dmpl__PurchaseInvoiceTax__c> purchaseInvoiceTaxes = queryPurchaseInvoiceTaxes(DocumentHelper.extractIds(billReturnLines, FIELD_PURCHASERETURNTAX_PURCHASEINVOICELINEID));
        List<dmpl__BillReturnTax__c> billReturnTaxes = new List<dmpl__BillReturnTax__c>();
        List<dmpl__BillReturnTax__c> existingBillReturnTaxes= new List<dmpl__BillReturnTax__c>();

        Map<ID, List<SObject>> mappedLines = DocumentHelper.mapLinesWithDocument(DocumentHelper.extractIds(billReturnLines, 'dmpl__BillLineId__c'), 'dmpl__BillLineId__c', purchaseInvoiceTaxes);
        for(dmpl__BillReturnLine__c billReturnLine : billReturnLines){
            if(billReturnLine.dmpl__TaxGroupId__c == null){
                continue;
            }
            List<dmpl__PurchaseInvoiceTax__c> taxes = mappedLines.get(billReturnLine.dmpl__BillLineId__c);
            if(taxes.size() == 0){
                continue;
            }

            for(dmpl__PurchaseInvoiceTax__c tax : taxes){
                if(orgSetting.dmpl__PurchaseReturnTaxesValidity__c == null || tax.dmpl__DocumentDate__c.daysBetween(Date.today()) <= orgSetting.dmpl__PurchaseReturnTaxesValidity__c)
                    billReturnTaxes.Add(createBillReturnTax(tax, billReturnLine));
            }
        }

        if(!isNew){
            existingbillReturnTaxes= queryExistingBillReturnTaxes(DocumentHelper.extractIds(billReturnLines));
        }

        Savepoint sp = Database.setSavepoint();
        try {
            if(!isNew){
                SecurityHelper.ensureCanDeleteObject('dmpl__BillReturnTax__c');
                delete existingbillReturnTaxes;
            }
            SecurityHelper.ensureCanCreateObject('dmpl__BillReturnTax__c');
            SecurityHelper.ensureCanCreateFields(new String[]{'dmpl__BillReturnLineId__c','dmpl__BillReturnId__c','dmpl__TaxId__c','dmpl__TaxAmount__c','dmpl__TaxGroupId__c','dmpl__TaxOnAmount__c','dmpl__TaxRate__c'}, 'dmpl__BillReturnTax__c');
            insert billReturnTaxes;    
        } catch (Exception e) {
            Database.rollback(sp);
            throw e;
        }
    }   

    private static void approveTaxLines(List<dmpl__BillReturnTax__c> documentTaxLines)
    {   
        for(dmpl__BillReturnTax__c taxLine : documentTaxLines){
            taxLine.dmpl__IsGLPostingApproved__c = true;
        }
    }

    private static List<dmpl__BillReturnTax__c> queryBillReturnTaxLines(List<dmpl__BillReturn__c> documents){
        SecurityHelper.ensureCanReadFields(new String[]{'dmpl__BillReturnId__c', 'dmpl__IsGLPostingApproved__c'},'dmpl__BillReturnTax__c');
        return [SELECT ID, dmpl__BillReturnId__c, dmpl__IsGLPostingApproved__c
                FROM dmpl__BillReturnTax__c
                WHERE dmpl__BillReturnId__c IN :DocumentHelper.extractIds(documents)];
    }

    private static Map<Id, dmpl__TaxGroup__c> queryTaxGroupsWithTaxes(List<id> taxGroupIds){
        SecurityHelper.ensureCanReadFields(new String[]{'dmpl__Rate__c','dmpl__TaxGroupId__c'},'dmpl__Tax__c');
        return new Map<Id,dmpl__TaxGroup__c>([
            SELECT ID,
                (SELECT ID, dmpl__Rate__c
                FROM dmpl__Taxes__r)
            FROM dmpl__TaxGroup__c
            WHERE ID IN:taxGroupIds
        ]);

    }

    private static List<dmpl__BillReturnTax__c> queryExistingBillReturnTaxes(List<id> billReturnLineIds)
    {
        SecurityHelper.ensureCanReadFields(new String[]{'Id','dmpl__BillReturnId__c'},'dmpl__BillReturnTax__c');
        return [SELECT Id
        FROM dmpl__BillReturnTax__c 
        WHERE dmpl__BillReturnId__c IN :billReturnLineIds];
    }

    private static List<dmpl__PurchaseInvoiceTax__c> queryPurchaseInvoiceTaxes(List<id> purchaseInvoiceLineIds)
    {
        SecurityHelper.ensureCanReadFields(new String[]{
            'Id',
            'dmpl__TaxId__c',
            'dmpl__TaxAmount__c',
            'dmpl__TaxGroupId__c',
            'dmpl__TaxOnAmount__c',
            'dmpl__TaxRate__c',
            'dmpl__DocumentDate__c',
            'dmpl__BillLineId__c'},'dmpl__PurchaseInvoiceTax__c');
        return [SELECT Id,
            dmpl__TaxId__c,
            dmpl__TaxAmount__c,
            dmpl__TaxGroupId__c,
            dmpl__TaxOnAmount__c,
            dmpl__TaxRate__c,
            dmpl__DocumentDate__c,
            dmpl__BillLineId__c
        FROM dmpl__PurchaseInvoiceTax__c 
        WHERE dmpl__BillLineId__c IN :purchaseInvoiceLineIds];
    }
}