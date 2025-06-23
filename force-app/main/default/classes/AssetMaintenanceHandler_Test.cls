@isTest
public with sharing class AssetMaintenanceHandler_Test {
    @TestSetup
    static void createRequiredData(){
        dmpl__AccountGroup__c accountGroup=TestDataHelpers.createAccountGroup();
        Account account=TestDataHelpers.createAccount(accountGroup);
        Account customerAccount=TestDataHelpers.createCustomerAccount();
        Account partnerAccount=TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch=TestDataHelpers.createBranch(partnerAccount);
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation(branch);
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__ItemLot__c itemLot = TestDataHelpers.createItemLot(branch,item,sku,storageLocation);
        dmpl__Resource__c resource = TestDataHelpers.createResource(partnerAccount, branch);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList(partnerAccount, branch);
        
        Asset asset=AssetTestDataHelpers.CreateAsset(account, branch, item, itemLot, sku);
        dmpl__Quote__c serviceEstimate = QuoteTestDataHelpers.CreateServiceEstimate(
            branch,
            customerAccount,
            priceList,
            asset,
            null,
            item
        );
        
        dmpl__RepairOrder__c repairOrder=RepairOrderTestDataHelpers.createRepairOrder(
            item,
            branch,
            asset,
            serviceEstimate,
            customerAccount,
            resource
        );
        dmpl__ServiceLead__c ServiceLead=ServiceLeadTestDataHelpers.createServiceLead(branch,customerAccount,resource);
        dmpl__ItemServiceContract__c ItemServiceContract=AssetTestDataHelpers.createItemServiceContract(item,sku);
        dmpl__ServiceCampaign__c serviceCampaign=CampaignTestDataHelpers.CreateServiceCompaign(ItemServiceContract,ServiceLead,item);

        dmpl__AssetMaintenance__c assetMaintenance = AssetTestDataHelpers.createAssetMaintenance(
            asset,
            partnerAccount,
            branch,
            repairOrder,
            serviceCampaign,
            itemServiceContract,
            item
        );
    }

    @isTest
    static void createAssetMaintenancePositive() {
        dmpl__AssetMaintenance__c assetMaintenance = AssetTestDataHelpers.getAssetMaintenance();
        if(assetMaintenance != null){
            System.assertNotEquals(assetMaintenance, null, 'Expected assetMaintenance to be created.');
        }
        System.assertEquals(false, assetMaintenance.dmpl__isExecuted__c, 'Expected dmpl__isExecuted__c to be false');
        System.assertEquals(false, assetMaintenance.dmpl__isMandatory__c, 'Expected dmpl__isMandatory__c to be false');
        System.assertNotEquals(assetMaintenance.dmpl__AssetId__c, null, 'Expected dmpl__Asset__c to be set.');
        System.assertNotEquals(assetMaintenance.dmpl__BranchId__c, null, 'Expected dmpl__Branch__c to be set.');
        System.assertNotEquals(assetMaintenance.dmpl__PartnerAccountId__c, null, 'Expected dmpl__PartnerAccount__c to be set.');
        System.assertNotEquals(assetMaintenance.dmpl__RepairOrderId__c, null, 'Expected dmpl__RepairOrder__c to be set.');
        System.assertNotEquals(assetMaintenance.dmpl__ServiceCampaignId__c, null, 'Expected dmpl__ServiceCampaign__c to be set.');
        System.assertNotEquals(assetMaintenance.dmpl__ItemServiceContractId__c, null, 'Expected dmpl__ItemServiceContract__c to be set.');
    }

    @isTest
    static void updateAssetMaintenancePositive() {
        dmpl__AssetMaintenance__c assetMaintenance = AssetTestDataHelpers.getAssetMaintenance();
        if(assetMaintenance != null){
            System.assertNotEquals(assetMaintenance, null, 'Expected assetMaintenance to be created before update.');
            assetMaintenance.dmpl__isExecuted__c = true;
            assetMaintenance.dmpl__isMandatory__c = true;
            update assetMaintenance;
        }
        
        dmpl__AssetMaintenance__c updatedAssetMaintenance = AssetTestDataHelpers.getAssetMaintenance(assetMaintenance.Id);
        if(updatedAssetMaintenance != null){
            System.assertNotEquals(updatedAssetMaintenance, null, 'Expected assetMaintenance to be updated.');
        }
        System.assertEquals(true, updatedAssetMaintenance.dmpl__isExecuted__c, 'Expected dmpl__isExecuted__c to be true');
        System.assertEquals(true, updatedAssetMaintenance.dmpl__isMandatory__c, 'Expected dmpl__isMandatory__c to be true');
    }

    @isTest
    static void deleteAssetMaintenancePositive() {
        dmpl__AssetMaintenance__c assetMaintenance = AssetTestDataHelpers.getAssetMaintenance();
        System.assertNotEquals(assetMaintenance, null, 'Expected asset to be created before delete.');
        dmpl__AssetMaintenance__c deletedAssetMaintenance = null;
        delete assetMaintenance;
        try{
            deletedAssetMaintenance = AssetTestDataHelpers.getAssetMaintenance(assetMaintenance.Id);
        }
        catch(Exception e) {
            deletedAssetMaintenance = null;
        }
        System.assertEquals(null, deletedAssetMaintenance, 'Expected assetMaintenance to be deleted.');
    }
}