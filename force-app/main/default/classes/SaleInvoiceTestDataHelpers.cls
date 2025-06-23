public with sharing class SaleInvoiceTestDataHelpers {
    public static dmpl__SaleInvoice__c createSaleInvoice(
        Account customerAccount,
        dmpl__Branch__c branch,
        dmpl__SaleOrder__c saleOrder,
        dmpl__PriceList__c priceList
    ){   
       return (dmpl__SaleInvoice__c)TestFactory.createSObject(
        new dmpl__SaleInvoice__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                dmpl__BranchId__c = Branch.Id,
                                dmpl__PriceListId__c=priceList.Id,
                                dmpl__DocumentDate__c = date.today(),
                                dmpl__AccountId__c = customerAccount.Id,
                                dmpl__TCSEligibleAmount__c = 100,
                                dmpl__FinanceAmount__c=100,
                                dmpl__AmountPaid__c =1 ,
                                dmpl__Status__c='Draft'
                                ),
                                'SaleInvoiceDefaults',
                                true
            );
    }
    
    public static dmpl__SaleInvoice__c getSaleInvoice(){
        return [SELECT 
                Id,
                Name,
                dmpl__AccountId__c,
                dmpl__ClaimId__c,
                dmpl__PerformKPICalculation__c,
                dmpl__InvoiceGroup__c,
                dmpl__PerformGLPosting__c,
                dmpl__Status__c,
                dmpl__BranchId__c,
                dmpl__SaleOrderId__c,
                dmpl__OutstandingAmount__c,
                dmpl__PartnerAccountId__c,
                dmpl__DocumentDate__c,
                dmpl__ClaimBatchId__c,
                dmpl__TotalLineGrossAmount__c,
                dmpl__TaxGroupId__c,
                dmpl__TCSEligibleAmount__c,
                dmpl__FinanceAmount__c,
                dmpl__TransactionType__c,
                dmpl__AmountPaid__c,
                dmpl__PriceListId__c
                FROM dmpl__SaleInvoice__c   
                LIMIT 1
            ];
    }

    public static dmpl__SaleInvoice__c getSaleInvoice(Id id){
        return [SELECT 
                Id,
                Name,
                dmpl__AccountId__c,
                dmpl__ClaimId__c,
                dmpl__PerformKPICalculation__c,
                dmpl__InvoiceGroup__c,
                dmpl__PerformGLPosting__c,
                dmpl__Status__c,
                dmpl__BranchId__c,
                dmpl__SaleOrderId__c,
                dmpl__OutstandingAmount__c,
                dmpl__PartnerAccountId__c,
                dmpl__DocumentDate__c,
                dmpl__FinanceAmount__c,
                dmpl__AmountPaid__c,
                dmpl__ClaimBatchId__c,
                dmpl__TotalLineGrossAmount__c,
                dmpl__TaxGroupId__c,
                dmpl__TCSEligibleAmount__c,
                dmpl__TransactionType__c,
                dmpl__PriceListId__c
                FROM dmpl__SaleInvoice__c   
                WHERE Id =: id
                LIMIT 1
            ];
    }

    public static dmpl__SaleInvoiceLine__c createSaleInvoiceLine(
        dmpl__SaleInvoice__c saleInvoice,
        dmpl__Item__c item,
        dmpl__SKU__c sku,
        dmpl__ItemLot__c itemLot,
        dmpl__TaxGroup__c taxGroup,
        dmpl__PriceListRules__c priceRule  
    ){
        return (dmpl__SaleInvoiceLine__c)TestFactory.createSObject(
            new dmpl__SaleInvoiceLine__c(
                dmpl__SaleInvoiceId__c = saleInvoice.id,
                dmpl__ItemId__c = item.Id,
                dmpl__SKUId__c = sku.Id,
                dmpl__TaxGroupId__c = taxGroup.Id,
                dmpl__Quantity__c = 10,
                //dmpl__AllocatedQuantity__c = 0,
                dmpl__DiscountAmount__c = 100,
                dmpl__Discount__c = 1,
                dmpl__SchemeDiscount__c = 10,
                dmpl__ContractDiscount__c = 10
            ),
            'SaleInvoiceLineDefaults',
            true
        );
    }
    
    public static dmpl__SaleInvoiceLine__c getSaleInvoiceLine(){
        return [SELECT 
        Id,
        Name,
        dmpl__Discount__c,
        dmpl__DiscountAmount__c,
        dmpl__GeneralLedgerId__c ,
        dmpl__GLAccountId__c ,
        dmpl__InventoryLedgerId__c ,
        dmpl__ItemLotId__c,
        dmpl__SaleOrderLineId__c,
        dmpl__SchemeDiscount__c ,
        dmpl__SchemeDiscountAmount__c ,
        dmpl__StorageLocationId__c ,
        dmpl__TaxAmount__c ,
        dmpl__TaxGroupId__c,
        dmpl__UnitPrice__c,
        dmpl__RepairOrderLineId__c,
        dmpl__SaleInvoiceId__c,
        dmpl__SchemeLineId__c,
        dmpl__SchemeLineId__r.Name,
        dmpl__SKUId__c,
        dmpl__AssetId__c,
        dmpl__ItemId__c,
        dmpl__EligibleReturnQuantity__c,
        dmpl__Quantity__c,
        dmpl__ContractDiscount__c,
        dmpl__AllocatedQuantity__c
        FROM dmpl__SaleInvoiceLine__c   
        LIMIT 1
        ];
    }
    
    public static dmpl__SaleInvoiceLine__c getSaleInvoiceLine(Id id){
        return [SELECT 
        Id,
        Name,
        dmpl__Discount__c,
        dmpl__DiscountAmount__c,
        dmpl__GeneralLedgerId__c ,
        dmpl__GLAccountId__c ,
        dmpl__InventoryLedgerId__c ,
        dmpl__ItemLotId__c,
        dmpl__SaleOrderLineId__c,
        dmpl__SchemeDiscount__c ,
        dmpl__SchemeDiscountAmount__c ,
        dmpl__StorageLocationId__c ,
        dmpl__TaxAmount__c ,
        dmpl__TaxGroupId__c,
        dmpl__UnitPrice__c,
        dmpl__RepairOrderLineId__c,
        dmpl__SaleInvoiceId__c,
        dmpl__SchemeLineId__c,
        dmpl__SchemeLineId__r.Name,
        dmpl__SKUId__c,
        dmpl__AssetId__c,
        dmpl__ItemId__c,
        dmpl__EligibleReturnQuantity__c,
        dmpl__Quantity__c,
        dmpl__ContractDiscount__c,
        dmpl__AllocatedQuantity__c
        FROM dmpl__SaleInvoiceLine__c   
        LIMIT 1
        ];
    }
    
    public static dmpl__SaleInvoiceTax__c createSaleInvoiceTax(
        dmpl__SaleInvoice__c saleInvoice,
        dmpl__SaleInvoiceLine__c line
    ) {
        dmpl__SaleInvoiceTax__c tax = new dmpl__SaleInvoiceTax__c(
            dmpl__SaleInvoiceId__c = saleInvoice.Id,
            dmpl__SaleInvoiceLineId__c = line.Id,
            dmpl__TaxAmount__c = 100,
            dmpl__IsGLPosted__c = false,
            dmpl__IsGLPostingApproved__c = false
        );
        insert tax;
        return tax;
    }

    public static dmpl__SaleInvoiceTax__c getSaleInvoiceTax(Id taxId) {
        return [SELECT 
                Id, 
                dmpl__TaxAmount__c,
                dmpl__SaleInvoiceId__c,
                dmpl__SaleInvoiceLineId__c
                FROM dmpl__SaleInvoiceTax__c 
                WHERE Id = :taxId
                LIMIT 1];
    }

    public static dmpl__SaleInvoiceTax__c getSaleInvoiceTax() {
        return [SELECT 
                Id, 
                dmpl__TaxAmount__c,
                dmpl__SaleInvoiceId__c,
                dmpl__SaleInvoiceLineId__c
                FROM dmpl__SaleInvoiceTax__c 
                LIMIT 1];
    }
}