/****/
public with sharing class AssetDataHelper {
    public static Asset createAsset(
        Account customerAccount,
        dmpl__Branch__c Branch,
        dmpl__Item__c item,
        dmpl__SKU__c sku,
        dmpl__ItemLot__c itemLot
    ) {
        return (Asset) TestFactory.createSObject(
            new Asset(
                Name = 'Test-Asset',
                AccountId = customerAccount.Id,
                dmpl__ItemId__c = item.Id,
                dmpl__SKUId__c = sku.Id,
                dmpl__RegistrationNumber__c = 'Test - Reg no.',
                dmpl__ItemLotId__c = itemLot.Id,
                dmpl__SupplierInvoicedate__c = Date.today(),
                dmpl__SupplierInvoiceNumber__c = '1111111111',
                dmpl__SaleDate__c = Date.today(),
                dmpl__SaleInvoiceNumber__c = '150',
                dmpl__LastServiceBranchId__c = Branch.Id,
                dmpl__LastServiceDate__c = Date.today(),
                dmpl__LastServicePartnerId__c = customerAccount.Id,
                dmpl__LastUsageReading__c = 50.00,
                dmpl__CurrentUsageReading__c = 60.00
            ),
            'AssetDefaults',
            true
        );
    }

    public static Asset getAsset() {
        return [
            SELECT Id, Name
            FROM Asset
            LIMIT 1
        ];
    }

    public static dmpl__AssetServiceContract__c createAssetServiceContracts(
        Asset asset,
        dmpl__Item__c item
    ) {
        return (dmpl__AssetServiceContract__c) TestFactory.createSObject(
            new dmpl__AssetServiceContract__c(
                dmpl__AssetId__c = asset.Id,
                dmpl__ItemId__c = item.Id,
                dmpl__ServiceContractItemId__c = item.Id,
                dmpl__ActivatedDate__c = Datetime.now().Date(),
                dmpl__ValidtillDate__c = Datetime.now().addDays(365).Date(),
                dmpl__DueDate__c = Datetime.now().addDays(365).Date()
            ),
            'AssetServiceContractDefaults',
            true
        );
    }
    public static dmpl__AssetServiceContract__c getAssetServiceContracts() {
        return [
            SELECT Id, Name
            FROM dmpl__AssetServiceContract__c
            LIMIT 1
        ];
    }
}