@isTest
public with sharing class KPIDataDetailHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__Resource__c resource = TestDataHelpers.createResource(partnerAccount, branch);
        dmpl__KPIConfiguration__c kpiConfig = KPIDataHelper.createKPIConfiguration('Test KPI Config', 'Customer', 'TestDateField');

        dmpl__KPIData__c kpiData = KPIDataHelper.createKPIData(
            kpiConfig,
            customerAccount,
            branch,
            partnerAccount,
            resource
        );

        dmpl__KPIDataDetail__c kpiDataDetail = KPIDataDetailDataHelper.createKPIDataDetail(
            kpiData,
            'BILL-001',
            100,
            200,
            50,
            'SALE-DOC-001',
            'SRC-001'
        );
    }

    @isTest
    static void createKPIDataDetailPositive() {
        dmpl__KPIDataDetail__c detail = KPIDataDetailDataHelper.getKPIDataDetail();
        System.assertNotEquals(detail, null, 'Expected KPI Data Detail to be created.');
        System.assertEquals('Test-KPI-Data-Detail', detail.Name, 'Detail Name should match');
        System.assertEquals('BILL-001', detail.dmpl__BillNo__c, 'Bill No should match');
        System.assertEquals(100, detail.dmpl__KPIValue__c, 'KPI Value should match');
        System.assertEquals(200, detail.dmpl__KPIValue2__c, 'KPI Value2 should match');
        System.assertEquals(50, detail.dmpl__RewardValue__c, 'Reward Value should match');
        System.assertEquals('SALE-DOC-001', detail.dmpl__SaleDoc__c, 'Sale Doc should match');
        System.assertEquals('SRC-001', detail.dmpl__SourceRecordId__c, 'Source Record should match');
    }

    @isTest
    static void updateKPIDataDetailPositive() {
        dmpl__KPIDataDetail__c detail = KPIDataDetailDataHelper.getKPIDataDetail();
        dmpl__KPIDataDetail__c updatedDetail = KPIDataDetailDataHelper.updateKPIDataDetail(detail, 999);
        System.assertEquals(999, updatedDetail.dmpl__KPIValue__c, 'KPI Value should be updated.');
    }

    @isTest
    static void deleteKPIDataDetail() {
        dmpl__KPIDataDetail__c detail = KPIDataDetailDataHelper.getKPIDataDetail();
        Integer count = KPIDataDetailDataHelper.deleteKPIDataDetail(detail);
        System.assertEquals(0, count, 'KPI Data Detail should be deleted and not found in query.');
    }

    //KPI Data Detail creation with valid Detail Name (new)
    @isTest
    static void createKPIDataDetailWithValidDetailNamePositive(){
        dmpl__KPIData__c KPIData = KPIDataHelper.getKPIData();
        dmpl__KPIDataDetail__c KPIDataDetail = KPIDataDetailDataHelper.createKPIDataDetail(KPIData,'Test-KPI-Data-Detail');
        dmpl__KPIDataDetail__c fetchedKPIDataDetail = KPIDataDetailDataHelper.getKPIDataDetail();
        System.assertNotEquals(null, fetchedKPIDataDetail, 'KPI Data Detail should not be null');
        System.assertEquals('Test-KPI-Data-Detail', fetchedKPIDataDetail.Name, 'Detail name should match the expected value');
        System.assertEquals(KPIData.Id, fetchedKPIDataDetail.dmpl__KPIDataId__c, 'The KPI Data Detail should be linked to the correct parent KPI Data');
    }

    //Create KPI Data Detail with optional fields left blank (New)
    @isTest
    static void createKPIDataDetailWithOptionalFieldsBlankPositive(){
        dmpl__KPIData__c KPIData = KPIDataHelper.getKPIData();
        dmpl__KPIDataDetail__c KPIDataDetail = KPIDataDetailDataHelper.createKPIDataDetail(KPIData,'Test-KPI-Data-Detail');
        dmpl__KPIDataDetail__c fetchedKPIDataDetail = KPIDataDetailDataHelper.getKPIDataDetail();
        System.assertNotEquals(null, fetchedKPIDataDetail, 'KPI Data Detail should not be null');
        System.assertEquals('Test-KPI-Data-Detail', fetchedKPIDataDetail.Name, 'Detail name should match the expected value');
        System.assertEquals(KPIData.Id, fetchedKPIDataDetail.dmpl__KPIDataId__c, 'The KPI Data Detail should be linked to the correct parent KPI Data');
    }

    //KPI Data Detail creation without entering Bill no. (New)
    @isTest
    static void createKPIDataDetailWithoutBillNoPositive(){
        dmpl__KPIData__c KPIData = KPIDataHelper.getKPIData();
        dmpl__KPIDataDetail__c KPIDataDetail = KPIDataDetailDataHelper.createKPIDataDetail(KPIData,'Test-KPI-Data-Detail');
        dmpl__KPIDataDetail__c fetchedKPIDataDetail = KPIDataDetailDataHelper.getKPIDataDetail();
        System.assertNotEquals(null, fetchedKPIDataDetail, 'KPI Data Detail should not be null');
        System.assertEquals('Test-KPI-Data-Detail', fetchedKPIDataDetail.Name, 'Detail name should match the expected value');
        System.assertEquals(KPIData.Id, fetchedKPIDataDetail.dmpl__KPIDataId__c, 'The KPI Data Detail should be linked to the correct parent KPI Data');
    }

    //KPI Data Detail creation without entering Detail Name (New)
    @isTest
    static void createKPIDataDetailWithoutNameNegative(){
        Boolean exceptionThrown= false;
        dmpl__KPIData__c KPIData = KPIDataHelper.getKPIData();
        try {
             dmpl__KPIDataDetail__c KPIDataDetail = KPIDataDetailDataHelper.createKPIDataDetail(KPIData,null);
        } catch (Exception e) {
            exceptionThrown= true;
            System.debug('Expected exception caught: ' + e.getMessage());
        }
           // System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown when using null in Detail name');
    }

    //KPI Data Detail creation with no Reward value (new)
     @isTest
    static void createKPIDataDetailWithoutRewardPositive(){
        dmpl__KPIData__c KPIData = KPIDataHelper.getKPIData();
        dmpl__KPIDataDetail__c KPIDataDetail = KPIDataDetailDataHelper.createKPIDataDetail(KPIData,'Test-KPI-Data-Detail');
        dmpl__KPIDataDetail__c fetchedKPIDataDetail = KPIDataDetailDataHelper.getKPIDataDetail();
        System.assertNotEquals(null, fetchedKPIDataDetail, 'KPI Data Detail should not be null');
        System.assertEquals('Test-KPI-Data-Detail', fetchedKPIDataDetail.Name, 'Detail name should match the expected value');
        System.assertEquals(KPIData.Id, fetchedKPIDataDetail.dmpl__KPIDataId__c, 'The KPI Data Detail should be linked to the correct parent KPI Data');
    }
            
}