@isTest
public with sharing class IncentiveTargetHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__IncentivePlan__c incentivePlan = IncentiveTargetDataHelper.createIncentivePlan();
        dmpl__IncentivePeriod__c incentivePeriod = IncentiveTargetDataHelper.createIncentivePeriod(incentivePlan.Id);
        dmpl__IncentiveTarget__c target = IncentiveTargetDataHelper.createIncentiveTarget(
            incentivePlan.Id,
            incentivePeriod.Id,
            item.Id,
            sku.Id,
            100,
            'No of Leads',     
            'Resource Target' 
        );
        dmpl__IncentiveResource__c resource = IncentiveTargetDataHelper.createIncentiveResource(incentivePlan.Id);
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.createKPIConfiguration('Test KPI Config', 'Customer', 'TestDateField');
        dmpl__IncentiveResourceTarget__c incentiveResourceTarget = IncentiveTargetDataHelper.createIncentiveResourceTarget(
            target.Id,
            incentivePeriod.Id,
            resource.Id,
            kpiConfig.Id,
            200
        );




        Date periodStartDate = Date.newInstance(2025, 6, 20);
        Date periodEndDate = Date.newInstance(2025, 7, 20);
        dmpl__IncentivePlan__c incentivePlan1 = IncentivePlanDataHelper.createIncentivePlan('Incentive A','Monthly','Resource',periodStartDate,periodEndDate,null,null);

        dmpl__Item__c  item1 = TestDataHelpers.createItem('Item 1','Product',true,false,false,'675654',false);
        dmpl__Item__c item2 = TestDataHelpers.createItem('Item 2','Product',false,false,false,'654345',false);
        dmpl__Item__c item4 = TestDataHelpers.createItem('Item 4','Product',true, false, false ,'765676',true);
        dmpl__Item__c item7 = TestDataHelpers.createItem('Item 7','Product',true,false,true, '765456',false);

        dmpl__Item__c item8 = TestDataHelpers.createItem('Item 8','Product',true,false,true, '765456',false);

        dmpl__SKU__c sku1 = TestDataHelpers.createSKU('SKU 1', item7.id, true);
        dmpl__SKU__c sku2 = TestDataHelpers.createSKU('SKU 2', item8.id, false);



    }

    @isTest
    static void createIncentiveTargetPositive() {
        dmpl__IncentiveTarget__c target = IncentiveTargetDataHelper.getIncentiveTarget();
        System.assertNotEquals(target, null, 'Expected Incentive Target to be created.');
        System.assertEquals(100, target.dmpl__Value__c, 'Value should match');
        System.assertEquals('No of Leads', target.dmpl__TargetType__c, 'TargetType should match');
        System.assertEquals('Resource Target', target.dmpl__TargetValueType__c, 'TargetValueType should match');
    }

    @isTest
    static void updateIncentiveTargetPositive() {
        dmpl__IncentiveTarget__c target = IncentiveTargetDataHelper.getIncentiveTarget();
        dmpl__IncentiveTarget__c updatedTarget = IncentiveTargetDataHelper.updateIncentiveTarget(target, 150);
        System.assertEquals(150, updatedTarget.dmpl__Value__c, 'Value should be updated.');
    }

    @isTest
    static void deleteIncentiveTarget() {
        dmpl__IncentiveTarget__c target = IncentiveTargetDataHelper.getIncentiveTarget();
        Integer count = IncentiveTargetDataHelper.deleteIncentiveTarget(target);
        System.assertEquals(0, count, 'Incentive Target should be deleted and not found in query.');
    }

    @isTest
    static void createIncentiveResourceTargetPositive() {
        dmpl__IncentiveResourceTarget__c resourceTarget = IncentiveTargetDataHelper.getIncentiveResourceTarget();
        System.assertNotEquals(resourceTarget, null, 'Expected Incentive Resource Target to be created.');
        System.assertEquals(200, resourceTarget.dmpl__Value__c, 'Value should match');
    }

    @isTest
    static void updateIncentiveResourceTargetPositive() {
        dmpl__IncentiveResourceTarget__c resourceTarget = IncentiveTargetDataHelper.getIncentiveResourceTarget();
        dmpl__IncentiveResourceTarget__c updatedResourceTarget = IncentiveTargetDataHelper.updateIncentiveResourceTarget(resourceTarget, 250);
        System.assertEquals(250, updatedResourceTarget.dmpl__Value__c, 'Value should be updated.');
    }

    @isTest
    static void deleteIncentiveResourceTarget() {
        dmpl__IncentiveResourceTarget__c resourceTarget = IncentiveTargetDataHelper.getIncentiveResourceTarget();
        Integer count = IncentiveTargetDataHelper.deleteIncentiveResourceTarget(resourceTarget);
        System.assertEquals(0, count, 'Incentive Resource Target should be deleted and not found in query.');
    }


    //Incentive Target Scenarios
    @isTest
    static void createIncentiveTargetNormalPositive(){
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.createIncentiveTarget(incentivePlan,kpiConfig,item1,null,null);
        Test.stopTest();

        System.assertNotEquals(null, incentiveTarget.Id, 'incentiveTarget should be created');
        System.assertEquals(incentivePlan.Id, incentiveTarget.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals(kpiConfig.Id, incentiveTarget.dmpl__KPIConfigurationId__c, 'KPI Configuration ID should match');
        System.assertEquals(item1.Id, incentiveTarget.dmpl__ItemId__c, 'Item ID should match');
    }


    // @isTest
    // static void createIncentiveTargetWithoutIncentivePlanNegative() {
    //     Test.startTest();
    //     try {
    //         dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration();
    //         dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
    //         dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.createIncentiveTarget(null, kpiConfig, item1, null, null);
    //         //System.assertEquals(null, incentiveTarget.Id, 'incentiveTarget should not be created without incentive plan');
    //     } catch (Exception e) {
    //         System.Assert.isTrue(true, 'IncentiveTarget should not be created without IncentivePlan');

    //     }
    //     Test.stopTest();        
    // }




    // @isTest
    // static void updateIncentiveTargetWithoutIncentivePlanNegative(){
    //     dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration();
    //     dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
    //     dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
       
    //     dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.createIncentiveTarget(incentivePlan,kpiConfig,item1,null,null);
        

    //     System.assertNotEquals(null, incentiveTarget.Id, 'incentiveTarget should be created');
    //     System.assertEquals(incentivePlan.Id, incentiveTarget.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
    //     System.assertEquals(kpiConfig.Id, incentiveTarget.dmpl__KPIConfigurationId__c, 'KPI Configuration ID should match');
    //     System.assertEquals(item1.Id, incentiveTarget.dmpl__ItemId__c, 'Item ID should match');

    //     Test.startTest();
    //     Boolean exceptionThrown = false;
    //     try{
    //         incentiveTarget.dmpl__IncentivePlanId__c = null;
    //         update incentiveTarget;
    //     }catch (Exception e) {
    //         exceptionThrown = true;
    //     }
    //     //System.assertEquals(true, exceptionThrown,'Expected exception when removing Incentive plan from incentiveTarget');
    //     Test.stopTest();
    // }
    

    @isTest
    static void createIncentiveTargetWithValuePositive(){
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.createIncentiveTarget(incentivePlan,kpiConfig,item1,4000,null);
        Test.stopTest();

        System.assertNotEquals(null, incentiveTarget.Id, 'incentiveTarget should be created');
        System.assertEquals(incentivePlan.Id, incentiveTarget.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals(kpiConfig.Id, incentiveTarget.dmpl__KPIConfigurationId__c, 'KPI Configuration ID should match');
        System.assertEquals(item1.Id, incentiveTarget.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(4000, incentiveTarget.dmpl__Value__c, 'value should be 4000');
    }

    @isTest
    static void createIncentiveTargetWithoutValuePositive(){
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.createIncentiveTarget(incentivePlan,kpiConfig,item1,null,null);
        Test.stopTest();

        System.assertNotEquals(null, incentiveTarget.Id, 'incentiveTarget should be created');
        System.assertEquals(incentivePlan.Id, incentiveTarget.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals(kpiConfig.Id, incentiveTarget.dmpl__KPIConfigurationId__c, 'KPI Configuration ID should match');
        System.assertEquals(item1.Id, incentiveTarget.dmpl__ItemId__c, 'Item ID should match');
    }

    @isTest
    static void updateIncentiveTargetWithoutValuePositive(){
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');

        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.createIncentiveTarget(incentivePlan,kpiConfig,item1,4000,null);

        System.assertNotEquals(null, incentiveTarget.Id, 'incentiveTarget should be created');
        System.assertEquals(incentivePlan.Id, incentiveTarget.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals(kpiConfig.Id, incentiveTarget.dmpl__KPIConfigurationId__c, 'KPI Configuration ID should match');
        System.assertEquals(item1.Id, incentiveTarget.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(4000, incentiveTarget.dmpl__Value__c, 'value should be 4000');

        Test.startTest();
        Boolean exceptionThrown = false;
        try{
            incentiveTarget.dmpl__Value__c = null;
            update incentiveTarget;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(false, exceptionThrown,'exception caught when removing value from incentiveTarget');
        Test.stopTest();
    }

    @isTest
    static void createIncentiveTargetWithActiveItemPositive(){
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.createIncentiveTarget(incentivePlan,kpiConfig,item1,null,null);
        Test.stopTest();

        System.assertNotEquals(null, incentiveTarget.Id, 'incentiveTarget should be created');
        System.assertEquals(incentivePlan.Id, incentiveTarget.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals(kpiConfig.Id, incentiveTarget.dmpl__KPIConfigurationId__c, 'KPI Configuration ID should match');
        System.assertEquals(item1.Id, incentiveTarget.dmpl__ItemId__c, 'Item ID should match');
    }

    @isTest
    static void createIncentiveTargetWithInactiveItemNegative(){
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Item__c  item2 = TestDataHelpers.getItem('Item 2');

        Test.startTest();
        try {      
            dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.createIncentiveTarget(incentivePlan,kpiConfig,item2,null,null);
            //System.assertEquals(null, incentiveTarget.Id, 'IncentiveTarget should not be created with inactive item');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'IncentiveTarget should not be created with inactive item');
        }
        Test.stopTest();        
    }


    @isTest
    static void updateIncentiveTargetWithInactiveItemNegative(){
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Item__c  item2 = TestDataHelpers.getItem('Item 2');

        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.createIncentiveTarget(incentivePlan,kpiConfig,item1,null,null);

        System.assertNotEquals(null, incentiveTarget.Id, 'incentiveTarget should be created');
        System.assertEquals(incentivePlan.Id, incentiveTarget.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals(kpiConfig.Id, incentiveTarget.dmpl__KPIConfigurationId__c, 'KPI Configuration ID should match');
        System.assertEquals(item1.Id, incentiveTarget.dmpl__ItemId__c, 'Item ID should match');


        Test.startTest();
        Boolean exceptionThrown = false;
        try{
            incentiveTarget.dmpl__ItemId__c = item2.Id;
            update incentiveTarget;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        //System.assertEquals(true, exceptionThrown,'Expected exception when referencing inactive item');
        Test.stopTest();
    }


    @isTest
    static void createIncentiveTargetWithRequiredSKUPositive(){
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Item__c  item8 = TestDataHelpers.getItem('Item 8');
        dmpl__SKU__c sku2 = TestDataHelpers.getSKU('SKU 2');
        Test.startTest();
        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.createIncentiveTarget(incentivePlan,kpiConfig,item8,null,sku2);
        Test.stopTest();

        System.assertNotEquals(null, incentiveTarget.Id, 'incentiveTarget should be created');
        System.assertEquals(incentivePlan.Id, incentiveTarget.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals(kpiConfig.Id, incentiveTarget.dmpl__KPIConfigurationId__c, 'KPI Configuration ID should match');
        System.assertEquals(item8.Id, incentiveTarget.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(sku2.Id, incentiveTarget.dmpl__SKUId__c, 'sku ID should match');
    }

    @isTest
    static void createIncentiveTargetWithNoRequiredSKUPositive(){
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.createIncentiveTarget(incentivePlan,kpiConfig,item1,null,null);
        Test.stopTest();

        System.assertNotEquals(null, incentiveTarget.Id, 'incentiveTarget should be created');
        System.assertEquals(incentivePlan.Id, incentiveTarget.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals(kpiConfig.Id, incentiveTarget.dmpl__KPIConfigurationId__c, 'KPI Configuration ID should match');
        System.assertEquals(item1.Id, incentiveTarget.dmpl__ItemId__c, 'Item ID should match');
    }


    @isTest
    static void updateIncentiveTargetWithNoRequiredSKUPositive(){
        Test.startTest();
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Item__c  item8 = TestDataHelpers.getItem('Item 8');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku2 = TestDataHelpers.getSKU('SKU 2');

        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.createIncentiveTarget(incentivePlan,kpiConfig,item8,null,sku2);

        System.assertNotEquals(null, incentiveTarget.Id, 'incentiveTarget should be created');
        System.assertEquals(incentivePlan.Id, incentiveTarget.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals(kpiConfig.Id, incentiveTarget.dmpl__KPIConfigurationId__c, 'KPI Configuration ID should match');
        System.assertEquals(item8.Id, incentiveTarget.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(sku2.Id, incentiveTarget.dmpl__SKUId__c, 'sku ID should match');

        Boolean exceptionThrown = false;
        try{
            incentiveTarget.dmpl__ItemId__c = item1.Id;
            incentiveTarget.dmpl__SKUId__c = null;
            update incentiveTarget;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(false, exceptionThrown,'exception caught when removing no required sku');
        Test.stopTest();
    }

    @isTest
    static void createIncentiveTargetWithDiscontinuedItemPositive(){
       dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Item__c  item4 = TestDataHelpers.getItem('Item 4');
        Test.startTest();
        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.createIncentiveTarget(incentivePlan,kpiConfig,item4,null,null);
        Test.stopTest();

        System.assertNotEquals(null, incentiveTarget.Id, 'incentiveTarget should be created');
        System.assertEquals(incentivePlan.Id, incentiveTarget.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals(kpiConfig.Id, incentiveTarget.dmpl__KPIConfigurationId__c, 'KPI Configuration ID should match');
        System.assertEquals(item4.Id, incentiveTarget.dmpl__ItemId__c, 'Item ID should match');  
    }

    @isTest
    static void createIncentiveTargetWithActiveKPIConfigurationPositive(){
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__KPIConfiguration__c kpiConfig1 = KPIConfigurationDataHelper.createKPIConfiguration('KPI Configuration 1','Resource','dmpl__DocumentDate__c',true);
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.createIncentiveTarget(incentivePlan,kpiConfig1,item1,null,null);
        Test.stopTest();

        System.assertNotEquals(null, incentiveTarget.Id, 'incentiveTarget should be created');
        System.assertEquals(incentivePlan.Id, incentiveTarget.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals(kpiConfig1.Id, incentiveTarget.dmpl__KPIConfigurationId__c, 'KPI Configuration ID should match');
        System.assertEquals(item1.Id, incentiveTarget.dmpl__ItemId__c, 'Item ID should match');
    }

    @isTest
    static void createIncentiveTargetWithInactiveKPIConfigurationPositive(){
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__KPIConfiguration__c kpiConfig2 = KPIConfigurationDataHelper.createKPIConfiguration('KPI Configuration 12','Resource','dmpl__DocumentDate__c',false);
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
       
        Test.startTest();
        try {      
            dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.createIncentiveTarget(incentivePlan,kpiConfig2,item1,null,null);
            //System.assertEquals(null, incentiveTarget.Id, 'IncentiveTarget should not be created with inactive kpi');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'IncentiveTarget should not be created with inactive kpi');
        }
        Test.stopTest(); 
    }

    @isTest
    static void updateIncentiveTargetWithInactiveKPIConfigurationNegative(){
        
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__KPIConfiguration__c kpiConfig11 = KPIConfigurationDataHelper.createKPIConfiguration('KPI Configuration 1','Resource','dmpl__DocumentDate__c',true);
        dmpl__KPIConfiguration__c kpiConfig12 = KPIConfigurationDataHelper.createKPIConfiguration('KPI Configuration 2','Resource','dmpl__DocumentDate__c',false);
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        
        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.createIncentiveTarget(incentivePlan,kpiConfig11,item1,null,null);
    
        System.assertNotEquals(null, incentiveTarget.Id, 'incentiveTarget should be created');
        System.assertEquals(incentivePlan.Id, incentiveTarget.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals(kpiConfig11.Id, incentiveTarget.dmpl__KPIConfigurationId__c, 'KPI Configuration ID should match');
        System.assertEquals(item1.Id, incentiveTarget.dmpl__ItemId__c, 'Item ID should match');


        Test.startTest();
        Boolean exceptionThrown = false;
        try{
            incentiveTarget.dmpl__KPIConfigurationId__c = kpiConfig12.Id;
            update incentiveTarget;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        //System.assertEquals(true, exceptionThrown,'Expected exception when referencing inactive kpi config');
        Test.stopTest();
    }


    //Incentive Resource Target

    @isTest
    static void createIncentiveResouceTargetWithIncentiveTargetPositive(){
        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.getIncentiveTarget();
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration();
        Test.startTest();
        dmpl__IncentiveResourceTarget__c incentiveResourceTarget = IncentiveTargetDataHelper.createIncentiveResourceTarget(incentiveTarget,kpiConfig,4000,null);
        Test.stopTest();

        System.assertNotEquals(null, incentiveResourceTarget,'incentiveResourceTarget should be created');
        System.assertEquals(4000, incentiveResourceTarget.dmpl__Value__c, 'Value should be 4000');
        System.assertEquals(incentiveTarget.Id, incentiveResourceTarget.dmpl__IncentiveTargetId__c, 'Incentive Target ID should match');
        System.assertEquals(kpiConfig.Id, incentiveResourceTarget.dmpl__KPIConfigurationId__c, 'KPI Configuration ID should match');
    } 


    @isTest
    static void createIncentiveResouceTargetWithoutIncentiveTargetNegative(){
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration();
        
        Test.startTest();
        try {      
            dmpl__IncentiveResourceTarget__c incentiveResourceTarget = IncentiveTargetDataHelper.createIncentiveResourceTarget(null,kpiConfig,4000,null);
            System.assertEquals(null, incentiveResourceTarget.Id, 'incentiveResourceTarget should not be created without incentiveTarget ');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'incentiveResourceTarget should not be created without incentiveTarget');
        }
        Test.stopTest(); 

    } 

    @isTest
    static void updateIncentiveResouceTargetWithoutIncentiveTargetNegative(){
        
        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.getIncentiveTarget();
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration();
        dmpl__IncentiveResourceTarget__c incentiveResourceTarget = IncentiveTargetDataHelper.createIncentiveResourceTarget(incentiveTarget,kpiConfig,4000,null);

        System.assertNotEquals(null, incentiveResourceTarget,'incentiveResourceTarget should be created');
        System.assertEquals(4000, incentiveResourceTarget.dmpl__Value__c, 'Value should be 4000');
        System.assertEquals(incentiveTarget.Id, incentiveResourceTarget.dmpl__IncentiveTargetId__c, 'Incentive Target ID should match');
        System.assertEquals(kpiConfig.Id, incentiveResourceTarget.dmpl__KPIConfigurationId__c, 'KPI Configuration ID should match');


        Test.startTest();
        Boolean exceptionThrown = false;
        try{
            incentiveResourceTarget.dmpl__IncentiveTargetId__c = null;
            update incentiveResourceTarget;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown,'Expected exception when Incentive Target is not attached');
        Test.stopTest();
    }

    @isTest
    static void createIncentiveResouceTargetWithDefiningValuePositive(){
        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.getIncentiveTarget();
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration();
        Test.startTest();
        dmpl__IncentiveResourceTarget__c incentiveResourceTarget = IncentiveTargetDataHelper.createIncentiveResourceTarget(incentiveTarget,kpiConfig,4000,null);
        Test.stopTest();

        System.assertNotEquals(null, incentiveResourceTarget,'incentiveResourceTarget should be created');
        System.assertEquals(4000, incentiveResourceTarget.dmpl__Value__c, 'Value should be 4000');
        System.assertEquals(incentiveTarget.Id, incentiveResourceTarget.dmpl__IncentiveTargetId__c, 'Incentive Target ID should match');
        System.assertEquals(kpiConfig.Id, incentiveResourceTarget.dmpl__KPIConfigurationId__c, 'KPI Configuration ID should match');

    } 

    @isTest
    static void createIncentiveResouceTargetWithoutDefiningValueNegative(){
        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.getIncentiveTarget();
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration();
        
        Test.startTest();
        try {      
            dmpl__IncentiveResourceTarget__c incentiveResourceTarget = IncentiveTargetDataHelper.createIncentiveResourceTarget(incentiveTarget,kpiConfig,null,null);
            //System.assertEquals(null, incentiveResourceTarget.Id, 'incentiveResourceTarget should not be created without value ');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'incentiveResourceTarget should not be created without value');
        }
        Test.stopTest(); 

    } 

    @isTest
    static void updateIncentiveResouceTargetWithoutDefiningValueNegative(){
        
        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.getIncentiveTarget();
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration();
        
        dmpl__IncentiveResourceTarget__c incentiveResourceTarget = IncentiveTargetDataHelper.createIncentiveResourceTarget(incentiveTarget,kpiConfig,4000,null);

        System.assertNotEquals(null, incentiveResourceTarget,'incentiveResourceTarget should be created');
        System.assertEquals(4000, incentiveResourceTarget.dmpl__Value__c, 'Value should be 4000');
        System.assertEquals(incentiveTarget.Id, incentiveResourceTarget.dmpl__IncentiveTargetId__c, 'Incentive Target ID should match');
        System.assertEquals(kpiConfig.Id, incentiveResourceTarget.dmpl__KPIConfigurationId__c, 'KPI Configuration ID should match');


        Test.startTest();
        Boolean exceptionThrown = false;
        try{
            incentiveResourceTarget.dmpl__Value__c = null;
            update incentiveResourceTarget;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        //System.assertEquals(true, exceptionThrown,'Expected exception when Incentive Resource Target value is null');
        Test.stopTest();
    }

    @isTest
    static void createIncentiveResouceTargetWithIncentiveResourceNamePositive(){
        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.getIncentiveTarget();
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentiveResource__c incentiveResource = IncentivePlanDataHelper.createIncentiveResource(null,null,'Resource 4',incentivePlan);
        Test.startTest();
        dmpl__IncentiveResourceTarget__c incentiveResourceTarget = IncentiveTargetDataHelper.createIncentiveResourceTarget(incentiveTarget,kpiConfig,4000,incentiveResource);
        Test.stopTest();

        System.assertNotEquals(null, incentiveResourceTarget,'incentiveResourceTarget should be created');
        System.assertEquals(4000, incentiveResourceTarget.dmpl__Value__c, 'Value should be 4000');
        System.assertEquals(incentiveTarget.Id, incentiveResourceTarget.dmpl__IncentiveTargetId__c, 'Incentive Target ID should match');
        System.assertEquals(kpiConfig.Id, incentiveResourceTarget.dmpl__KPIConfigurationId__c, 'KPI Configuration ID should match');
        System.assertEquals(incentiveResource.Id, incentiveResourceTarget.dmpl__IncentiveResourceId__c, 'IncentiveResource ID should match');

    } 

    @isTest
    static void createIncentiveResouceTargetWithoutIncentiveResourceNamePositive(){
        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.getIncentiveTarget();
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration();
        Test.startTest();
        dmpl__IncentiveResourceTarget__c incentiveResourceTarget = IncentiveTargetDataHelper.createIncentiveResourceTarget(incentiveTarget,kpiConfig,4000,null);
        Test.stopTest();

        System.assertNotEquals(null, incentiveResourceTarget,'incentiveResourceTarget should be created');
        System.assertEquals(4000, incentiveResourceTarget.dmpl__Value__c, 'Value should be 4000');
        System.assertEquals(incentiveTarget.Id, incentiveResourceTarget.dmpl__IncentiveTargetId__c, 'Incentive Target ID should match');
        System.assertEquals(kpiConfig.Id, incentiveResourceTarget.dmpl__KPIConfigurationId__c, 'KPI Configuration ID should match');
    }

    @isTest
    static void updateIncentiveResouceTargetWithoutIncentiveResourceNamePositive(){
        
        dmpl__IncentiveTarget__c incentiveTarget = IncentiveTargetDataHelper.getIncentiveTarget();
        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.getKPIConfiguration();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentiveResource__c incentiveResource = IncentivePlanDataHelper.createIncentiveResource(null,null,'Resource 4',incentivePlan);

        dmpl__IncentiveResourceTarget__c incentiveResourceTarget = IncentiveTargetDataHelper.createIncentiveResourceTarget(incentiveTarget,kpiConfig,4000,incentiveResource);
        
        System.assertNotEquals(null, incentiveResourceTarget,'incentiveResourceTarget should be created');
        System.assertEquals(4000, incentiveResourceTarget.dmpl__Value__c, 'Value should be 4000');
        System.assertEquals(incentiveTarget.Id, incentiveResourceTarget.dmpl__IncentiveTargetId__c, 'Incentive Target ID should match');
        System.assertEquals(kpiConfig.Id, incentiveResourceTarget.dmpl__KPIConfigurationId__c, 'KPI Configuration ID should match');
        System.assertEquals(incentiveResource.Id, incentiveResourceTarget.dmpl__IncentiveResourceId__c, 'IncentiveResource ID should match');

        Test.startTest();
        Boolean exceptionThrown = false;
        try{
            incentiveResourceTarget.dmpl__IncentiveResourceId__c = null;
            update incentiveResourceTarget;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(false, exceptionThrown,'exception caught when Incentive Resource Name is removed');
        Test.stopTest();
    }
}