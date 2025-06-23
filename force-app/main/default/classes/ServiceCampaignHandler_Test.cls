@isTest
public with sharing class ServiceCampaignHandler_Test {
    @TestSetup
    static void createRequiredData() {
        dmpl__AccountGroup__c accountGroup = TestDataHelpers.createAccountGroup();
        Account account = TestDataHelpers.createAccount(accountGroup);
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();        
        dmpl__Branch__c branch =TestDataHelpers.createBranch(partnerAccount);   
        dmpl__Resource__c resource =TestDataHelpers.createResource(partnerAccount, branch);  
        dmpl__ServiceLead__c serviceLead = ServiceLeadTestDataHelpers.createServiceLead(branch, customerAccount, resource); 
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__SKU__c sku =TestDataHelpers.createSKU(item);
        dmpl__ItemServiceContract__c itemServiceContract = ServiceCampaignTestDataHelpers.createItemServiceContract(item, sku);
        dmpl__ItemMaintenanceSchedule__c itemMaintenanceSchedule = TestDataHelpers.createItemMaintenanceSchedule(item, sku);
        dmpl__ServiceCampaign__c serviceCampaign = ServiceCampaignTestDataHelpers.createServiceCampaign(serviceLead, item, itemServiceContract, itemMaintenanceSchedule, branch, partnerAccount);
        dmpl__ServiceCampaignItem__c serviceCampaignItem = ServiceCampaignTestDataHelpers.createServiceCampaignItem(serviceCampaign, item, itemServiceContract);
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation(branch); 
        dmpl__ItemLot__c itemLot = TestDataHelpers.createItemLot(branch, item, sku, storageLocation);
        Asset asset = ServiceCampaignTestDataHelpers.CreateAsset(account, branch, item, itemLot, sku);
        dmpl__ServiceCampaignMember__c serviceCampaignMember = ServiceCampaignTestDataHelpers.createServiceCampaignMember(serviceCampaign, item, branch, asset, partnerAccount, account);
        dmpl__ServiceCampaignRule__c serviceCampaignRule = ServiceCampaignTestDataHelpers.createServiceCampaignRule(serviceCampaign);
    }

    @isTest
    static void createServiceCampaignPositive() {
        dmpl__ServiceCampaign__c serviceCampaign = ServiceCampaignTestDataHelpers.getServiceCampaign();
        System.assertNotEquals(serviceCampaign, null, 'Expected Service Campaign to be created.');
        System.assertEquals(serviceCampaign.dmpl__Type__c, 'Service', 'Type should be Service.');
        System.assertEquals(serviceCampaign.Name, 'Service - Campaign', 'Name should be Service - Campaign.');
        System.assertEquals(serviceCampaign.dmpl__ReminderDaysOffset1__c, 3, 'Reminder Days Offset 1 should be 3.');
        System.assertEquals(serviceCampaign.dmpl__IsActive__c, true, 'is Active should be true.');
        System.assertEquals(serviceCampaign.dmpl__ReportId__c, 'Sample Report', 'Report Id  should be Sample Report.');
        System.assertEquals(serviceCampaign.dmpl__ApexJobId__c, 'Job1', 'Apex Job Id should be Job1.');
        System.assertEquals(serviceCampaign.dmpl__CronExpression__c, 'Cron Expression', 'Cron Expression should be Cron Expression.');

        dmpl__ServiceCampaignItem__c serviceCampaignItem = ServiceCampaignTestDataHelpers.getServiceCampaignItem();
        System.assertNotEquals(serviceCampaignItem, null, 'Expected Service Campaign Item to be created.');
        System.assertEquals(serviceCampaignItem.dmpl__IsMandatory__c, true, 'Is Mandatory should be true.');
        System.assertEquals(serviceCampaignItem.dmpl__Quantity__c, 4, 'Quantity should be 4.');
        
        dmpl__ServiceCampaignMember__c serviceCampaignMember = ServiceCampaignTestDataHelpers.getServiceCampaignMember();
        System.assertNotEquals(serviceCampaignMember, null, 'Expected Service Campaign Member to be created.');
        
        dmpl__ServiceCampaignRule__c serviceCampaignRule = ServiceCampaignTestDataHelpers.getServiceCampaignRule();
        System.assertNotEquals(serviceCampaignRule, null, 'Expected Service Campaign Rule to be created.');
        
    }

    @isTest
    static void updateServiceCampaignPositive() {
        dmpl__ServiceCampaign__c serviceCampaign = ServiceCampaignTestDataHelpers.getServiceCampaign();
        System.assertNotEquals(serviceCampaign, null, 'Service Campaign should exist before update.');
        serviceCampaign.Name = 'Service - Campaign updated';
        serviceCampaign.dmpl__ReminderDaysOffset1__c = 2;
        serviceCampaign.dmpl__IsActive__c = false;
        serviceCampaign.dmpl__ReportId__c = 'Sample Report1';
        serviceCampaign.dmpl__ApexJobId__c = 'Job2';
        serviceCampaign.dmpl__CronExpression__c = 'Cron Exp1';
        update serviceCampaign;

        dmpl__ServiceCampaign__c UpdatedServiceCampaign = ServiceCampaignTestDataHelpers.getServiceCampaign();
        System.assertEquals(UpdatedServiceCampaign.Name, 'Service - Campaign updated', 'Name should be Service - Campaign updated after update.');
        System.assertEquals(UpdatedServiceCampaign.dmpl__ReminderDaysOffset1__c, 2, 'Reminder Days Offset 1 should be 2 after update.');
        System.assertEquals(serviceCampaign.dmpl__IsActive__c, false, 'is Active should be false after update.');
        System.assertEquals(serviceCampaign.dmpl__ReportId__c, 'Sample Report1', 'Report Id  should be Sample Report1 after update.');
        System.assertEquals(serviceCampaign.dmpl__ApexJobId__c, 'Job2', 'Apex Job Id should be Job2.');
        System.assertEquals(serviceCampaign.dmpl__CronExpression__c, 'Cron Exp1', 'Cron Expression should be Cron Exp1 after update.');

        dmpl__ServiceCampaignItem__c serviceCampaignItem = ServiceCampaignTestDataHelpers.getServiceCampaignItem();
        System.assertNotEquals(serviceCampaignItem, null, 'Service Campaign Item should exist before update.');
        serviceCampaignItem.dmpl__IsMandatory__c = false;
        serviceCampaignItem.dmpl__Quantity__c = 2;
        update serviceCampaignItem;

        dmpl__ServiceCampaignItem__c updatedServiceCampaignItem = ServiceCampaignTestDataHelpers.getServiceCampaignItem();
        System.assertEquals(updatedServiceCampaignItem.dmpl__IsMandatory__c, false, 'Is Mandatory should be false after update.');
        System.assertEquals(updatedServiceCampaignItem.dmpl__Quantity__c, 2, 'Quantity should be 2 after update.');
    }

    @isTest
    static void deleteServiceCampaign() {
        dmpl__ServiceCampaign__c serviceCampaign = ServiceCampaignTestDataHelpers.getServiceCampaign();
        System.assertNotEquals(serviceCampaign, null, 'Service Campaign should exist before delete.');
        Id serviceCampaignId = serviceCampaign.Id;
        delete serviceCampaign;
        dmpl__ServiceCampaign__c deletedServiceCampaign = null;
        try {
            deletedServiceCampaign = ServiceCampaignTestDataHelpers.getServiceCampaign(serviceCampaignId);
        } catch (Exception e) {
            deletedServiceCampaign = null;
        }
        System.assertEquals(deletedServiceCampaign, null, 'Service Campaign should be deleted and not found in query.');
    }
}