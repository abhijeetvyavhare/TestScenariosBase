@isTest
public with sharing class SaleInvoiceDataHelper {
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
    
    public static dmpl__SaleInvoice__c createSaleInvoice(
        Account customerAccount,
        Account partnerAccount,
        dmpl__Branch__c branch,
        String taxSupplyType,
        dmpl__TaxGroup__c taxGroup,
        dmpl__ContactAddress__c billingAddress,
        dmpl__Resource__c resource
    ){
        return (dmpl__SaleInvoice__c)TestFactory.createSObject(
            new dmpl__SaleInvoice__c(dmpl__PartnerAccountId__c = partnerAccount.Id,
            dmpl__DocumentDate__c = date.today(),
            dmpl__BranchId__c = Branch.Id,
            dmpl__AccountId__c = customerAccount != null ?customerAccount.Id :null,
            dmpl__TaxSupplyType__c=taxSupplyType != null ? taxSupplyType : null,
            dmpl__TaxGroupId__c = taxGroup !=null ? taxGroup.Id : null,
            dmpl__BillingAddressId__c = billingAddress != null ? billingAddress.Id : null,
            dmpl__SalesExecutiveId__c = resource != null ? resource.Id : null
            
        ),
        //'SaleInvoiceDefaults',
        true
            );
    }
    
    public static dmpl__SaleInvoice__c createSaleInvoice(
        Account customerAccount,
    Account partnerAccount,
    dmpl__Branch__c branch
        
    ){
        return (dmpl__SaleInvoice__c)TestFactory.createSObject(
            new dmpl__SaleInvoice__c(dmpl__PartnerAccountId__c = partnerAccount.Id,
        dmpl__BranchId__c = Branch.Id,
        dmpl__AccountId__c = customerAccount.Id,
        dmpl__TaxSupplyType__c='Within State',
        dmpl__DocumentDate__c= Date.today(),
        dmpl__Status__c = 'Draft'
        
            ),
        //'SaleInvoiceDefaults',
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
                dmpl__TotalLineBaseAmount__c,
                dmpl__TotalSchemeDiscountAmount__c,
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
                dmpl__AccountId__r.Name,
                dmpl__TaxGroupId__r.Name,
                dmpl__BillingAddressId__r.Name,
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
                dmpl__TaxGroupId__c,
                dmpl__TCSEligibleAmount__c,
                dmpl__TransactionType__c,
                dmpl__PriceListId__c,
                dmpl__PriceListId__r.Name,
                dmpl__AccountName__c,
                dmpl__TaxSupplyType__c,
                dmpl__BillingStreet__c,
                dmpl__BillingCity__c,
                dmpl__BillingState__c,
                dmpl__BillingCountry__c,
                dmpl__BillingPostalCode__c,
                dmpl__ShippingStreet__c,
                dmpl__ShippingCity__c,
                dmpl__ShippingState__c,
                dmpl__ShippingPostalCode__c,
                dmpl__ShippingCountry__c,
                dmpl__TotalLineBaseAmount__c,
                dmpl__TotalSchemeDiscountAmount__c,
                dmpl__TotalLineGrossAmount__c,
                dmpl__TotalTaxAmount__c,
                dmpl__TotalLineTaxAmount__c,
                dmpl__TotalDiscountAmount__c,
                dmpl__TotalLineAmount__c,
                dmpl__TotalSchemeDiscountAmount2__c,
                dmpl__OpenAmount__c,
                dmpl__TotalAmount__c
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
            dmpl__AllocatedQuantity__c = 0,
            dmpl__DiscountAmount__c = 100,
            dmpl__Discount__c = 1,
            dmpl__SchemeDiscount__c = 10,
            dmpl__ContractDiscount__c = 10
                ),
            'SaleInvoiceLineDefaults',
            true
                );
    }

    public static dmpl__SaleInvoiceLine__c createSaleInvoiceLine(
            dmpl__SaleInvoice__c saleInvoice,
        dmpl__Item__c item,
        Integer Quantity
        ){
            return (dmpl__SaleInvoiceLine__c)TestFactory.createSObject(
                new dmpl__SaleInvoiceLine__c(
                dmpl__SaleInvoiceId__c = saleInvoice.id,
            dmpl__ItemId__c = item.Id,
            dmpl__Quantity__c = Quantity
                ),
            //'SaleInvoiceLineDefaults',
            true
                );
    }

    public static dmpl__SaleInvoiceLine__c createSaleInvoiceLine(
        dmpl__SaleInvoice__c saleInvoice,
    dmpl__Item__c item,
    dmpl__ItemAlternate__c itemAlternate,
    Integer Quantity,
    dmpl__SKU__c sku

    ){
        return (dmpl__SaleInvoiceLine__c)TestFactory.createSObject(
            new dmpl__SaleInvoiceLine__c(
            dmpl__SaleInvoiceId__c = saleInvoice.id,
        dmpl__AlternateItemId__c = itemAlternate?.Id ?? null,
        dmpl__ItemId__c = item?.Id ?? itemAlternate.dmpl__ItemId__c,
        dmpl__Quantity__c = Quantity,
        dmpl__skuId__c=sku?.Id ?? null
            ),
        //'SaleInvoiceLineDefaults',
        true
            );
    }

    public static dmpl__SaleInvoiceLine__c createSaleInvoiceLine(
        dmpl__SaleInvoice__c saleInvoice,
        dmpl__Item__c item,
        dmpl__SKU__c sku,
        dmpl__ItemLot__c itemLot,
        dmpl__TaxGroup__c taxGroup,
        dmpl__PriceListRules__c priceRule,
        Integer Quantity,
        Integer UnitPrice

        ){
            return (dmpl__SaleInvoiceLine__c)TestFactory.createSObject(
                new dmpl__SaleInvoiceLine__c(
                dmpl__SaleInvoiceId__c = saleInvoice?.id??null,
            dmpl__ItemId__c = item?.Id ?? null,
            dmpl__SKUId__c = sku?.Id ?? null,
            dmpl__TaxGroupId__c = taxGroup?.Id ?? null,
            dmpl__Quantity__c = Quantity,
            dmpl__UnitPrice__c = UnitPrice
                ),
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
        dmpl__GLAccountId__c,
        dmpl__InventoryLedgerId__c ,
        dmpl__ItemLotId__c,
        dmpl__SaleOrderLineId__c,
        dmpl__SchemeDiscount__c ,
        dmpl__SchemeDiscountAmount__c ,
        dmpl__NetSchemeDiscount__c,
        dmpl__NetDiscount__c,
        dmpl__GrossAmount__c,
        dmpl__BaseAmount__c,
        dmpl__StorageLocationId__c ,
        dmpl__TaxAmount__c ,
        dmpl__TaxGroupId__c,
        dmpl__TaxGroupId__r.Name,
        dmpl__UnitPrice__c,
        dmpl__Tax1__c,
        dmpl__Tax2__c,
        dmpl__Tax1Name__c,
        dmpl__Tax2Name__c,
        dmpl__Tax1Rate__c,
        dmpl__Tax2Rate__c,
        dmpl__Tax2Type__c,
        dmpl__Tax1Type__c,
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
        dmpl__AllocatedQuantity__c,
        dmpl__Amount__c
        FROM dmpl__SaleInvoiceLine__c   
        WHERE Id = :id
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
    
    public static dmpl__ItemAlternate__c CreateItemAlternate(
        dmpl__Item__c item,
    dmpl__Item__c alternateItem,
    String alternateType
    ) {
        return (dmpl__ItemAlternate__c) TestFactory.createSObject(
            new dmpl__ItemAlternate__c(
            dmpl__ItemId__c = item.Id,
        dmpl__AlternateItemId__c = alternateItem.Id,
        dmpl__AlternateType__c = alternateType,
        dmpl__EffectiveFromDate__c = Date.today()
            ),
        // 'ItemAlternateDefaults',
        true
            );
    }
    public static dmpl__ItemAlternate__c getItemAlternate(dmpl__Item__c item, dmpl__Item__c alternateItem) {
        return [SELECT Id, Name, dmpl__ItemId__c, dmpl__AlternateItemId__c, dmpl__AlternateItemName__c,  dmpl__AlternateType__c FROM dmpl__ItemAlternate__c where dmpl__ItemId__c=:item.Id and dmpl__AlternateItemId__c=:alternateItem.Id LIMIT 1];
    }

    public static dmpl__AccountGroup__c createAccountGroup(String name, String groupType, String memberType) {
        return (dmpl__AccountGroup__c) TestFactory.createSObject(
            new dmpl__AccountGroup__c(
                Name = name,
                dmpl__AccountGroupType__c = groupType,
                dmpl__DynamicMemberType__c = memberType,
                dmpl__RuleSuccessCriteria__c ='All Rules Are Met'
            ),
            true
        );
    }

     public static dmpl__AccountGroupMember__c createAccountGroupMember(Id accountGroupId, Id accountId) {
        return (dmpl__AccountGroupMember__c) TestFactory.createSObject(
            new dmpl__AccountGroupMember__c(
                dmpl__AccountGroupId__c = accountGroupId,
                dmpl__AccountId__c = accountId
            ),
            true
        );
    }

    public static dmpl__AccountGroup__c getAccountGroup() {
        return [SELECT Id, Name, dmpl__AccountGroupType__c, dmpl__DynamicMemberType__c FROM dmpl__AccountGroup__c LIMIT 1];
    }

    public static dmpl__AccountGroupMember__c getAccountGroupMember() {
        return [SELECT Id, Name, dmpl__AccountId__c, dmpl__AccountGroupId__c FROM dmpl__AccountGroupMember__c LIMIT 1];
    }

}