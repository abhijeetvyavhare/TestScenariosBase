@isTest
public class RepairOrderTaxTestDataHelpers {
    
    public static dmpl__RepairOrderTax__c getRepairOrderTax(Id taxId) {
        return [SELECT Id, dmpl__TaxRate__c, dmpl__TaxAmount__c, dmpl__TaxOnAmount__c,
                dmpl__RepairOrderId__c, dmpl__RepairOrderLineId__c, dmpl__TaxId__c, dmpl__TaxGroupId__c
                FROM dmpl__RepairOrderTax__c 
                WHERE Id = :taxId];
    }
    
    public static dmpl__RepairOrderTax__c getRepairOrderTaxByRepairOrder(Id repairOrderId) {
        return [SELECT Id, dmpl__TaxRate__c, dmpl__TaxAmount__c, dmpl__TaxOnAmount__c,
                dmpl__RepairOrderId__c, dmpl__RepairOrderLineId__c, dmpl__TaxId__c, dmpl__TaxGroupId__c
                FROM dmpl__RepairOrderTax__c 
                WHERE dmpl__RepairOrderId__c = :repairOrderId
                LIMIT 1];
    }
    
    public static List<dmpl__RepairOrderTax__c> getRepairOrderTaxesByRepairOrder(Id repairOrderId) {
        return [SELECT Id, dmpl__TaxRate__c, dmpl__TaxAmount__c, dmpl__TaxOnAmount__c,
                dmpl__RepairOrderId__c, dmpl__RepairOrderLineId__c, dmpl__TaxId__c, dmpl__TaxGroupId__c
                FROM dmpl__RepairOrderTax__c 
                WHERE dmpl__RepairOrderId__c = :repairOrderId];
    }
    
    public static dmpl__Tax__c getOrCreateTax() {
        List<dmpl__Tax__c> existingTaxes = [SELECT Id FROM dmpl__Tax__c LIMIT 1];
        if (!existingTaxes.isEmpty()) {
            return existingTaxes[0];
        }
        
        // First create TaxGroup since it's required for Tax
        dmpl__TaxGroup__c taxGroup = getOrCreateTaxGroup();
        
        dmpl__Tax__c tax = new dmpl__Tax__c(
            Name = 'Test - Tax',
            dmpl__TaxGroupId__c = taxGroup.Id,
            dmpl__Type__c = 'Cess',
            dmpl__Rate__c = 10,
            dmpl__PostingFieldName__c = 'Tax1'
        );
        insert tax;
        return tax;
    }
    
    public static dmpl__TaxGroup__c getOrCreateTaxGroup() {
        List<dmpl__TaxGroup__c> existingGroups = [SELECT Id FROM dmpl__TaxGroup__c LIMIT 1];
        if (!existingGroups.isEmpty()) {
            return existingGroups[0];
        }
        
        // Get required records from TestDataHelpers
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__AccountGroup__c accountGroup = TestDataHelpers.createAccountGroup();
        
        dmpl__TaxGroup__c taxGroup = new dmpl__TaxGroup__c(
            Name = 'Test - Tax Group',
            dmpl__PartnerAccountId__c = partnerAccount.Id,
            dmpl__BranchId__c = branch.Id,
            dmpl__PartnerAccountGroupId__c = accountGroup.Id,
            dmpl__Description__c = 'Test-Description',
            dmpl__IsActive__c = true,
            dmpl__TaxGroupType__c = 'Line Level'
        );
        insert taxGroup;
        return taxGroup;
    }
    
    public static dmpl__RepairOrderTax__c createRepairOrderTax(dmpl__RepairOrder__c repairOrder) {
        dmpl__RepairOrderLine__c repairOrderLine = RepairOrderTestDataHelpers.getRepairOrderLine();
        dmpl__Tax__c tax = getOrCreateTax();
        dmpl__TaxGroup__c taxGroup = getOrCreateTaxGroup();
        
        return RepairOrderTestDataHelpers.createRepairOrderTax(repairOrder, repairOrderLine, tax, taxGroup);
    }
    
    public static dmpl__RepairOrderTax__c createRepairOrderTaxWithNegativeRate(dmpl__RepairOrder__c repairOrder) {
        dmpl__RepairOrderTax__c tax = createRepairOrderTax(repairOrder);
        tax.dmpl__TaxRate__c = -10;
        return tax;
    }
    
    public static dmpl__RepairOrderTax__c createCleanRepairOrderTax(dmpl__RepairOrder__c repairOrder) {
        dmpl__RepairOrderTax__c tax = createRepairOrderTax(repairOrder);
        return new dmpl__RepairOrderTax__c(
            dmpl__RepairOrderId__c = tax.dmpl__RepairOrderId__c,
            dmpl__RepairOrderLineId__c = tax.dmpl__RepairOrderLineId__c,
            dmpl__TaxId__c = tax.dmpl__TaxId__c,
            dmpl__TaxOnAmount__c = tax.dmpl__TaxOnAmount__c,
            dmpl__TaxAmount__c = tax.dmpl__TaxAmount__c,
            dmpl__TaxGroupId__c = tax.dmpl__TaxGroupId__c,
            dmpl__TaxRate__c = tax.dmpl__TaxRate__c
        );
    }
    
    public static List<dmpl__RepairOrderTax__c> createBulkRepairOrderTaxes(List<dmpl__RepairOrder__c> repairOrders) {
        List<dmpl__RepairOrderTax__c> taxes = new List<dmpl__RepairOrderTax__c>();
        for(dmpl__RepairOrder__c repairOrder : repairOrders) {
            taxes.add(createCleanRepairOrderTax(repairOrder));
        }
        return taxes;
    }
    
    public static void deleteRepairOrderTaxes(List<dmpl__RepairOrderTax__c> taxes) {
        if(taxes != null && !taxes.isEmpty()) {
            delete taxes;
        }
    }
    
    public static void deleteRepairOrderTaxesByRepairOrder(Id repairOrderId) {
        List<dmpl__RepairOrderTax__c> taxes = getRepairOrderTaxesByRepairOrder(repairOrderId);
        deleteRepairOrderTaxes(taxes);
    }
}