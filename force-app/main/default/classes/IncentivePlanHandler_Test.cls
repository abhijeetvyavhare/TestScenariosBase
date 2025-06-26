@isTest
public with sharing class IncentivePlanHandler_Test {
    @TestSetup
    static void createRequiredData() {
        dmpl__AccountGroup__c accountGroup = TestDataHelpers.createAccountGroup();
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account supplierAccount = TestDataHelpers.createSupplierAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__Scheme__c scheme = SchemeDataHelper.createScheme('Scheme 2', 'Auto Apply', 'Draft', 'Per Sale order and Invoice', 'Per Order', Date.newInstance(2025, 5, 1), Date.newInstance(2025, 6, 30), 10, 'Apply all Fulfilled', 1, false, partnerAccount.Id, null, null, null, branch.Id, 100000);
        
        dmpl__IncentivePlan__c plan = IncentivePlanDataHelper.createIncentivePlan(
            'Yearly',
        'Resource',
        'Draft',
        Date.today(),
        Date.today().addYears(1).addDays(-1),
        accountGroup.Id,
        partnerAccount.Id,
        supplierAccount.Id
            );
        
        dmpl__IncentivePeriod__c period = IncentivePlanDataHelper.createIncentivePeriod(
            plan.Id,
        Date.today(),
        Date.today().addMonths(1).addDays(-1),
        'Test Period',
        'Approved'
            );
        
        dmpl__Resource__c resource = TestDataHelpers.createResource(partnerAccount, branch);
        
        dmpl__IncentiveResource__c incentiveResource = IncentivePlanDataHelper.createIncentiveResource(
            plan.Id,
        resource.Id,
        partnerAccount.Id,
        branch.Id
            );
        
        dmpl__IncentiveLine__c incentiveLine = IncentivePlanDataHelper.createIncentiveLine(
            plan.Id,
        'Test Line',
        'All',
        'All',
        1,
        false
            );
        
        Account supplierAccount1 = TestDataHelpers.createPartnerAccount('Supplier 1', false, false, true, true, '55 Industrial Park Road', 'Ahmedabad', 'GJ', 'India', '380015', '55 Industrial Park Road', 'Ahmedabad', 'GJ', 'India', '380015', '-9988776564');
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1', false, true, false, true, 'MG Road', 'Bengaluru', 'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India', '560095','9876543210');
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2', false, true, false, false, '45 Residency Road', 'Pune', 'Maharashtra', 'India', '411001', '22 Commerce Avenue', 'Pune', 'Maharashtra', 'India', '411038','91-99665544433');
        Account partnerAccount4 = TestDataHelpers.createPartnerAccount('Partner 4', false, true, false, true, '12 Industrial Zone', 'Hyderabad','Telangana', 'India', '500032', '12 Industrial Zone', 'Hyderabad', 'Telangana', 'India','500032','9876012345');
        dmpl__Branch__c branch4 =TestDataHelpers.createBranch('Branch 4',partnerAccount4.Id,true,true,false,false);
        dmpl__Branch__c branch1 =TestDataHelpers.createBranch('Branch 4',partnerAccount1.Id,true,true,false,false);
        
    }
    
    @isTest
    static void createIncentivePlanPositive() {
        dmpl__IncentivePlan__c plan = IncentivePlanDataHelper.getIncentivePlan();
        System.assertNotEquals(plan, null, 'Expected Incentive Plan to be created.');
        System.assertEquals('Yearly', plan.dmpl__PeriodType__c, 'PeriodType should match');
        System.assertEquals('Resource', plan.dmpl__MemberType__c, 'MemberType should match');
        System.assertEquals('Draft', plan.dmpl__Status__c, 'Status should match');
    }
    
    @isTest
    static void createIncentivePeriodPositive() {
        dmpl__IncentivePeriod__c period = IncentivePlanDataHelper.getIncentivePeriod();
        System.assertNotEquals(period, null, 'Expected Incentive Period to be created.');
        System.assertEquals(null, period.dmpl__Status__c, 'Status should match');
    }
    
    @isTest
    static void createIncentiveLinePositive() {
        dmpl__IncentiveLine__c line = IncentivePlanDataHelper.getIncentiveLine();
        System.assertNotEquals(line, null, 'Expected Incentive Line to be created.');
        System.assertEquals(null, line.dmpl__DefinitionFilterCriteria__c, 'DefinitionFilterCriteria should match');
        System.assertEquals(null, line.dmpl__RewardApplicability__c, 'RewardApplicability should match');
        System.assertEquals(1, line.dmpl__SequenceNumber__c, 'SequenceNumber should match');
        System.assertEquals(false, line.dmpl__UseSlabAbsoluteValue__c, 'UseSlabAbsoluteValue should match');
    }
    
    @isTest
    static void updateIncentivePlanPositive() {
        dmpl__IncentivePlan__c plan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentivePlan__c updatedPlan = IncentivePlanDataHelper.updateIncentivePlan(plan, 'Approved');
        System.assertEquals('Approved', updatedPlan.dmpl__Status__c, 'Status should be updated.');
    }
    
    @isTest
    static void updateIncentivePeriodPositive() {
        dmpl__IncentivePeriod__c period = IncentivePlanDataHelper.getIncentivePeriod();
        dmpl__IncentivePeriod__c updatedPeriod = IncentivePlanDataHelper.updateIncentivePeriod(period, 'Approved');
        System.assertEquals('Approved', updatedPeriod.dmpl__Status__c, 'Status should be updated.');
    }
    
    @isTest
    static void updateIncentiveLinePositive() {
        dmpl__IncentiveLine__c line = IncentivePlanDataHelper.getIncentiveLine();
        dmpl__IncentiveLine__c updatedLine = IncentivePlanDataHelper.updateIncentiveLine(line, 'Updated Line');
        System.assertEquals('Updated Line', updatedLine.dmpl__Title__c, 'Line Title should be updated.');
    }
    
    @isTest
    static void deleteIncentivePlan() {
        dmpl__IncentivePlan__c plan = IncentivePlanDataHelper.getIncentivePlan();
        Integer count = IncentivePlanDataHelper.deleteIncentivePlan(plan);
        System.assertEquals(0, count, 'Incentive Plan should be deleted and not found in query.');
    }
    
    @isTest
    static void deleteIncentivePeriod() {
        dmpl__IncentivePeriod__c period = IncentivePlanDataHelper.getIncentivePeriod();
        Integer count = IncentivePlanDataHelper.deleteIncentivePeriod(period);
        System.assertEquals(0, count, 'Incentive Period should be deleted and not found in query.');
    }
    
    @isTest
    static void deleteIncentiveLine() {
        dmpl__IncentiveLine__c line = IncentivePlanDataHelper.getIncentiveLine();
        Integer count = IncentivePlanDataHelper.deleteIncentiveLine(line);
        System.assertEquals(0, count, 'Incentive Line should be deleted and not found in query.');
    }
    
    @isTest
    static void createIncentiveResourcePositive() {
        dmpl__IncentiveResource__c resource = IncentivePlanDataHelper.getIncentiveResource();
        System.assertNotEquals(resource, null, 'Expected Incentive Resource to be created.');
    }
    
    @isTest
    static void updateIncentiveResourcePositive() {
        dmpl__IncentiveResource__c resource = IncentivePlanDataHelper.getIncentiveResource();
        dmpl__Branch__c newBranch = TestDataHelpers.createBranch(TestDataHelpers.createPartnerAccount());
        dmpl__IncentiveResource__c updatedResource = IncentivePlanDataHelper.updateIncentiveResource(resource, newBranch.Id);
        System.assertEquals(newBranch.Id, updatedResource.dmpl__BranchId__c, 'Branch should be updated.');
    }
    
    @isTest
    static void deleteIncentiveResource() {
        dmpl__IncentiveResource__c resource = IncentivePlanDataHelper.getIncentiveResource();
        Integer count = IncentivePlanDataHelper.deleteIncentiveResource(resource);
        System.assertEquals(0, count, 'Incentive Resource should be deleted and not found in query.');
    }
    
    
    /******************************  Incentive Line  ******************************/
    
    @isTest
    static void createIncentiveLineWithAllRewardsPositive(){
        
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentiveLine__c incentiveLine;
        try{
            incentiveLine =  IncentivePlanDataHelper.createIncentiveLine( incentivePlan.Id , 'All Rewards' , 'All conditions are met');
        }catch(Exception e){
            System.Assert.isTrue(incentiveLine != null, 'Incentive Line Expected to be Successfully created!');
        }
        
        System.assertEquals(incentivePlan.Id, incentiveLine.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals('All Rewards', incentiveLine.dmpl__RewardApplicability__c, 'Reward Applicability should be All Rewards');
        System.assertEquals('All conditions are met', incentiveLine.dmpl__DefinitionFilterCriteria__c, 'Definition Filter Criteria should be All conditions are met');
        Test.stopTest();
    }
    
    @isTest
    static void createIncentiveLineWithAnyOneLowestValuePositive(){
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentiveLine__c incentiveLine;
        try{
            incentiveLine =  IncentivePlanDataHelper.createIncentiveLine( incentivePlan.Id , 'Any One With Lowest Value' , 'All conditions are met');
        }catch(Exception e){
            System.Assert.isTrue(incentiveLine != null, 'Incentive Line Expected to be Successfully created!');
        }
        
        System.assertEquals(incentivePlan.Id, incentiveLine.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals('Any One With Lowest Value', incentiveLine.dmpl__RewardApplicability__c, 'Reward Applicability should be Any One With Lowest Value');
        System.assertEquals('All conditions are met', incentiveLine.dmpl__DefinitionFilterCriteria__c, 'Definition Filter Criteria should be All conditions are met');
        Test.stopTest();
    }
    
    @isTest
    static void createIncentiveLineWithAnyOneHighestValuePositive(){
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentiveLine__c incentiveLine;
        try{
            incentiveLine =  IncentivePlanDataHelper.createIncentiveLine( incentivePlan.Id , 'Any One With Highest Value' , 'All conditions are met');
        }catch(Exception e){
            System.Assert.isTrue(incentiveLine != null, 'Incentive Line Expected to be Successfully created!');
        }
        
        System.assertEquals(incentivePlan.Id, incentiveLine.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals('Any One With Highest Value', incentiveLine.dmpl__RewardApplicability__c, 'Reward Applicability should be Any One With Highest Value');
        System.assertEquals('All conditions are met', incentiveLine.dmpl__DefinitionFilterCriteria__c, 'Definition Filter Criteria should be All conditions are met');
        Test.stopTest();
    }
    
    @isTest
    static void createIncentiveLineWithCustomLogicPositive(){
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentiveLine__c incentiveLine;
        try{
            incentiveLine =  IncentivePlanDataHelper.createIncentiveLine( incentivePlan.Id , 'Custom Logic' , 'All conditions are met');
        }catch(Exception e){
            System.Assert.isTrue(incentiveLine != null, 'Incentive Line Expected to be Successfully created!');
        }
        
        System.assertEquals(incentivePlan.Id, incentiveLine.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals('Custom Logic', incentiveLine.dmpl__RewardApplicability__c, 'Reward Applicability should be Custom Logic');
        System.assertEquals('All conditions are met', incentiveLine.dmpl__DefinitionFilterCriteria__c, 'Definition Filter Criteria should be All conditions are met');
        Test.stopTest();
    }
    
    @isTest
    static void createIncentiveLineWithAllConditionsMetPositive(){
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentiveLine__c incentiveLine;
        try{
            incentiveLine =  IncentivePlanDataHelper.createIncentiveLine( incentivePlan.Id , null , 'All conditions are met');
        }catch(Exception e){
            System.Assert.isTrue(incentiveLine != null, 'Incentive Line Expected to be Successfully created!');
        }
        
        System.assertEquals(incentivePlan.Id, incentiveLine.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals(null, incentiveLine.dmpl__RewardApplicability__c, 'Reward Applicability should be Nothing');
        System.assertEquals('All conditions are met', incentiveLine.dmpl__DefinitionFilterCriteria__c, 'Definition Filter Criteria should be All conditions are met');
        Test.stopTest();
    }
    
    @isTest
    static void createIncentiveLineWithAnyConditionMetPositive(){
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentiveLine__c incentiveLine;
        try{
            incentiveLine =  IncentivePlanDataHelper.createIncentiveLine( incentivePlan.Id , null , 'Any Condition Is Met');
        }catch(Exception e){
            System.Assert.isTrue(incentiveLine != null, 'Incentive Line Expected to be Successfully created!');
        }
        
        System.assertEquals(incentivePlan.Id, incentiveLine.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals(null, incentiveLine.dmpl__RewardApplicability__c, 'Reward Applicability should be Nothing');
        System.assertEquals('Any Condition Is Met', incentiveLine.dmpl__DefinitionFilterCriteria__c, 'Definition Filter Criteria should be Any Condition Is Met');
        Test.stopTest();
    }
    
    @isTest
    static void createIncentiveLineWithCustomLogicMetPositive(){
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentiveLine__c incentiveLine;
        try{
            incentiveLine =  IncentivePlanDataHelper.createIncentiveLine( incentivePlan.Id , null , 'Custom Logic Is Met');
        }catch(Exception e){
            System.Assert.isTrue(incentiveLine != null, 'Incentive Line Expected to be Successfully created!');
        }
        
        System.assertEquals(incentivePlan.Id, incentiveLine.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals(null, incentiveLine.dmpl__RewardApplicability__c, 'Reward Applicability should be Nothing');
        System.assertEquals('Custom Logic Is Met', incentiveLine.dmpl__DefinitionFilterCriteria__c, 'Definition Filter Criteria should be Custom Logic Is Met');
        Test.stopTest();
    }
    
    @isTest
    static void createIncentiveLineWithoutIncentivePlanNegative(){
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__IncentiveLine__c incentiveLine;
        try{
            incentiveLine =  IncentivePlanDataHelper.createIncentiveLine( null , 'Any One With Highest Value' , 'All conditions are met');
            System.Assert.isTrue(incentiveLine == null, 'Incentive Line Expected not to be created!');
        }catch(Exception e){
            System.Assert.isTrue(incentiveLine == null, 'Incentive Line Expected not to be created!');
        }
        Test.stopTest();
    }
    
    /******************************  Incentive Compensation Slab  ******************************/
    
    @isTest
    static void createCompensationSlabCreationWithMemeberResourceTypeAsSalespersonPositive(){
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        String memberResourceType ='Salesperson' ;
        String compensationType ='Fixed Amount' ;
        dmpl__IncentivePeriod__c period = IncentivePlanDataHelper.getIncentivePeriod();
        dmpl__IncentiveLine__c incentiveLine = IncentivePlanDataHelper.getIncentiveLine();
        Decimal giftPoints = null ;
        Decimal sequenceNumber = 1;
        
        dmpl__IncentiveCompensationSlab__c compensationSlab;
        try{
            compensationSlab = IncentivePlanDataHelper.createCompensationSlab(incentivePlan?.Id, memberResourceType, compensationType, period?.Id ,incentiveLine?.Id, giftPoints, sequenceNumber);
        }catch(Exception e){
            System.Assert.isTrue(compensationSlab != null, 'Compensation slab must get created! >> ' + e.getMessage());
        }
        compensationSlab = IncentivePlanDataHelper.getCompensationSlab(compensationSlab.Id);
        System.assertNotEquals(null, compensationSlab, 'Compensation slab should not be null');
        System.assertEquals(incentivePlan?.Id, compensationSlab.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals(memberResourceType, compensationSlab.dmpl__MemberResourceType__c, 'Member Resource Type should match');
        System.assertEquals(compensationType, compensationSlab.dmpl__CompensationType__c, 'Compensation Type should match');
        System.assertEquals(period?.Id, compensationSlab.dmpl__IncentivePeriodId__c, 'Incentive Period ID should match');
        System.assertEquals(incentiveLine?.Id, compensationSlab.dmpl__ReferenceIncentiveLineId__c, 'Reference Incentive Line ID should match');
        System.assertEquals(giftPoints, compensationSlab.dmpl__GiftPoints__c, 'Gift Points should match');
        System.assertEquals(sequenceNumber, compensationSlab.dmpl__SequenceNumber__c, 'Sequence Number should match');
        Test.stopTest();
    }
    
    @isTest
    static void createCompensationSlabCreationWithMemeberResourceTypeAsServiceadvisorPositive(){
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        String memberResourceType ='Service Advisor' ;
        String compensationType ='Fixed Amount' ;
        dmpl__IncentivePeriod__c period = IncentivePlanDataHelper.getIncentivePeriod();
        dmpl__IncentiveLine__c incentiveLine = IncentivePlanDataHelper.getIncentiveLine();
        Decimal giftPoints = null ;
        Decimal sequenceNumber = 1;
        
        dmpl__IncentiveCompensationSlab__c compensationSlab;
        try{
            compensationSlab = IncentivePlanDataHelper.createCompensationSlab(incentivePlan?.Id, memberResourceType, compensationType, period?.Id ,incentiveLine?.Id, giftPoints, sequenceNumber);
        }catch(Exception e){
            System.Assert.isTrue(compensationSlab != null, 'Compensation slab must get created! >> ' + e.getMessage());
        }
        compensationSlab = IncentivePlanDataHelper.getCompensationSlab(compensationSlab.Id);
        
        System.assertNotEquals(null, compensationSlab, 'Compensation slab should not be null');
        System.assertEquals(incentivePlan?.Id, compensationSlab.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals(memberResourceType, compensationSlab.dmpl__MemberResourceType__c, 'Member Resource Type should match');
        System.assertEquals(compensationType, compensationSlab.dmpl__CompensationType__c, 'Compensation Type should match');
        System.assertEquals(period?.Id, compensationSlab.dmpl__IncentivePeriodId__c, 'Incentive Period ID should match');
        System.assertEquals(incentiveLine?.Id, compensationSlab.dmpl__ReferenceIncentiveLineId__c, 'Reference Incentive Line ID should match');
        System.assertEquals(giftPoints, compensationSlab.dmpl__GiftPoints__c, 'Gift Points should match');
        System.assertEquals(sequenceNumber, compensationSlab.dmpl__SequenceNumber__c, 'Sequence Number should match');
        Test.stopTest();
    }
    
    @isTest
    static void createCompensationSlabCreationWithMemeberResourceTypeAsManagerPositive(){
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        String memberResourceType ='Manager' ;
        String compensationType ='Fixed Amount' ;
        dmpl__IncentivePeriod__c period = IncentivePlanDataHelper.getIncentivePeriod();
        dmpl__IncentiveLine__c incentiveLine = IncentivePlanDataHelper.getIncentiveLine();
        Decimal giftPoints = null ;
        Decimal sequenceNumber = 1;
        
        dmpl__IncentiveCompensationSlab__c compensationSlab;
        try{
            compensationSlab = IncentivePlanDataHelper.createCompensationSlab(incentivePlan?.Id, memberResourceType, compensationType, period?.Id ,incentiveLine?.Id, giftPoints, sequenceNumber);
        }catch(Exception e){
            System.Assert.isTrue(compensationSlab != null, 'Compensation slab must get created! >> ' + e.getMessage());
        }
        compensationSlab = IncentivePlanDataHelper.getCompensationSlab(compensationSlab.Id);
        
        System.assertNotEquals(null, compensationSlab, 'Compensation slab should not be null');
        System.assertEquals(incentivePlan?.Id, compensationSlab.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals(memberResourceType, compensationSlab.dmpl__MemberResourceType__c, 'Member Resource Type should match');
        System.assertEquals(compensationType, compensationSlab.dmpl__CompensationType__c, 'Compensation Type should match');
        System.assertEquals(period?.Id, compensationSlab.dmpl__IncentivePeriodId__c, 'Incentive Period ID should match');
        System.assertEquals(incentiveLine?.Id, compensationSlab.dmpl__ReferenceIncentiveLineId__c, 'Reference Incentive Line ID should match');
        System.assertEquals(giftPoints, compensationSlab.dmpl__GiftPoints__c, 'Gift Points should match');
        System.assertEquals(sequenceNumber, compensationSlab.dmpl__SequenceNumber__c, 'Sequence Number should match');
        Test.stopTest();
    }
    
    @isTest
    static void createCompensationSlabCreationWithGiftAsRewardPointsPositive(){
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        String memberResourceType ='Manager' ;
        String compensationType ='Fixed Amount' ;
        dmpl__IncentivePeriod__c period = IncentivePlanDataHelper.getIncentivePeriod();
        dmpl__IncentiveLine__c incentiveLine = IncentivePlanDataHelper.getIncentiveLine();
        Decimal giftPoints = 2 ;
        Decimal sequenceNumber = 1;
        
        dmpl__IncentiveCompensationSlab__c compensationSlab;
        try{
            compensationSlab = IncentivePlanDataHelper.createCompensationSlab(incentivePlan?.Id, memberResourceType, compensationType, period?.Id ,incentiveLine?.Id, giftPoints, sequenceNumber);
        }catch(Exception e){
            System.Assert.isTrue(compensationSlab != null, 'Compensation slab must get created! >> ' + e.getMessage());
        }
        compensationSlab = IncentivePlanDataHelper.getCompensationSlab(compensationSlab.Id);
        
        System.assertNotEquals(null, compensationSlab, 'Compensation slab should not be null');
        System.assertEquals(incentivePlan?.Id, compensationSlab.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
        System.assertEquals(memberResourceType, compensationSlab.dmpl__MemberResourceType__c, 'Member Resource Type should match');
        System.assertEquals(compensationType, compensationSlab.dmpl__CompensationType__c, 'Compensation Type should match');
        System.assertEquals(period?.Id, compensationSlab.dmpl__IncentivePeriodId__c, 'Incentive Period ID should match');
        System.assertEquals(incentiveLine?.Id, compensationSlab.dmpl__ReferenceIncentiveLineId__c, 'Reference Incentive Line ID should match');
        System.assertEquals(giftPoints, compensationSlab.dmpl__GiftPoints__c, 'Gift Points should match');
        System.assertEquals(sequenceNumber, compensationSlab.dmpl__SequenceNumber__c, 'Sequence Number should match');
        Test.stopTest();
    }
    
    @isTest
    static void createCompensationSlabCreationWithoutReferenceIncentiveLineNegative(){
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        String memberResourceType ='Manager' ;
        String compensationType ='Fixed Amount' ;
        dmpl__IncentivePeriod__c period = null;
        dmpl__IncentiveLine__c incentiveLine = IncentivePlanDataHelper.getIncentiveLine();
        Decimal giftPoints = null ;
        Decimal sequenceNumber = 1;
        
        dmpl__IncentiveCompensationSlab__c compensationSlab;
        try{
            compensationSlab = IncentivePlanDataHelper.createCompensationSlab(incentivePlan?.Id, memberResourceType, compensationType, period?.Id ,incentiveLine?.Id, giftPoints, sequenceNumber);
            System.Assert.isTrue(compensationSlab == null, 'Compensation slab must get Fail! ');
        }catch(Exception e){
            System.Assert.isTrue(compensationSlab == null, 'Compensation slab must get Fail! >> ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    static void createCompensationSlabCreationWithoutIncentivePlanNegative(){
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = null;
        String memberResourceType ='Manager' ;
        String compensationType ='Fixed Amount' ;
        dmpl__IncentivePeriod__c period = IncentivePlanDataHelper.getIncentivePeriod();
        dmpl__IncentiveLine__c incentiveLine = IncentivePlanDataHelper.getIncentiveLine();
        Decimal giftPoints = null ;
        Decimal sequenceNumber = 1;
        
        dmpl__IncentiveCompensationSlab__c compensationSlab;
        try{
            compensationSlab = IncentivePlanDataHelper.createCompensationSlab(incentivePlan?.Id, memberResourceType, compensationType, period?.Id ,incentiveLine?.Id, giftPoints, sequenceNumber);
            System.Assert.isTrue(compensationSlab == null, 'Compensation slab must get Fail! ');
        }catch(Exception e){
            System.Assert.isTrue(compensationSlab == null, 'Compensation slab must get Fail! >> ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    static void createCompensationSlabCreationWithoutResourceTypeNegative(){
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        String memberResourceType =null ;
        String compensationType ='Fixed Amount' ;
        dmpl__IncentivePeriod__c period = IncentivePlanDataHelper.getIncentivePeriod();
        dmpl__IncentiveLine__c incentiveLine = IncentivePlanDataHelper.getIncentiveLine();
        Decimal giftPoints = null ;
        Decimal sequenceNumber = 1;
        
        dmpl__IncentiveCompensationSlab__c compensationSlab;
        try{
            compensationSlab = IncentivePlanDataHelper.createCompensationSlab(incentivePlan?.Id, memberResourceType, compensationType, period?.Id ,incentiveLine?.Id, giftPoints, sequenceNumber);
            System.Assert.isTrue(compensationSlab == null, 'Compensation slab must get Fail! ');
        }catch(Exception e){
            System.Assert.isTrue(compensationSlab == null, 'Compensation slab must get Fail! >> ' + e.getMessage());
        }
        Test.stopTest();
    }
    //Incentice Plan Test Scenarios
    @isTest
    static void createIncentivePlanWithNamePositive(){
        Date periodStartDate = Date.newInstance(2025, 6, 20);
        Date periodEndDate = Date.newInstance(2025, 7, 20);
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.createIncentivePlan('Incentive A','Monthly','Resource',periodStartDate,periodEndDate,null,null);
        Test.stopTest();
        
        System.assertNotEquals(null, incentivePlan.Id, 'IncentivePlan should be created');
        System.assertEquals('Incentive A', incentivePlan.Name, 'Name should match');
        System.assertEquals('Monthly', incentivePlan.dmpl__PeriodType__c, 'Period Type should be Monthly');
        System.assertEquals(Date.newInstance(2025, 6, 20), incentivePlan.dmpl__PeriodStartDate__c, 'Start date should be 20/06/2025');
        System.assertEquals(Date.newInstance(2025, 7, 20), incentivePlan.dmpl__PeriodEndDate__c, 'End date should be 20/07/2025');
        System.assertEquals('Resource', incentivePlan.dmpl__MemberType__c, 'Member Type should be Resource');
    }
    
    @isTest
    static void createIncentivePlanWithoutNameNagative(){
        Date periodStartDate = Date.newInstance(2025, 6, 20);
        Date periodEndDate = Date.newInstance(2025, 7, 20);
        Test.startTest();
        try {
            dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.createIncentivePlan(null,'Monthly','Resource',periodStartDate,periodEndDate,null,null);
            System.assertEquals(null, incentivePlan.Id, 'IncentivePlan should not be created without name');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'IncentivePlan should not be created without name');
        }
        Test.stopTest();
    }
    @isTest
    static void updateIncentivePlanWithoutNameNegative(){
        Date periodStartDate = Date.newInstance(2025, 6, 20);
        Date periodEndDate = Date.newInstance(2025, 7, 20);
        
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.createIncentivePlan('Incentive A','Monthly','Resource',periodStartDate,periodEndDate,null,null);
        
        System.assertNotEquals(null, incentivePlan.Id, 'IncentivePlan should be created');
        
        System.assertEquals('Incentive A', incentivePlan.Name, 'Name should match');
        System.assertEquals('Monthly', incentivePlan.dmpl__PeriodType__c, 'Period Type should be Monthly');
        System.assertEquals(Date.newInstance(2025, 6, 20), incentivePlan.dmpl__PeriodStartDate__c, 'Start date should be 20/06/2025');
        System.assertEquals(Date.newInstance(2025, 7, 20), incentivePlan.dmpl__PeriodEndDate__c, 'End date should be 20/07/2025');
        System.assertEquals('Resource', incentivePlan.dmpl__MemberType__c, 'Member Type should be Resource');
        
        Test.startTest();
        Boolean exceptionCaught = false;
        try{
            incentivePlan.Name = null;
            update incentivePlan;
            
        }catch (Exception e) {
            exceptionCaught = true;
        }
        System.assertEquals(true,exceptionCaught,'Expected Exception because of missing name field');
        
        Test.stopTest();
        
    }
    
    @isTest
    static void createIncentivePlanWithSupplierAccountPositive(){
        Date periodStartDate = Date.newInstance(2025, 6, 20);
        Date periodEndDate = Date.newInstance(2025, 7, 20);
        Account supplierAccount1=TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.createIncentivePlan('Incentive A','Monthly','Resource',periodStartDate,periodEndDate,supplierAccount1,null);
        Test.stopTest();
        
        System.assertNotEquals(null, incentivePlan.Id, 'IncentivePlan should be created');
        
        System.assertEquals('Incentive A', incentivePlan.Name, 'Name should match');
        System.assertEquals('Monthly', incentivePlan.dmpl__PeriodType__c, 'Period Type should be Monthly');
        System.assertEquals(Date.newInstance(2025, 6, 20), incentivePlan.dmpl__PeriodStartDate__c, 'Start date should be 20/06/2025');
        System.assertEquals(Date.newInstance(2025, 7, 20), incentivePlan.dmpl__PeriodEndDate__c, 'End date should be 20/07/2025');
        System.assertEquals('Resource', incentivePlan.dmpl__MemberType__c, 'Member Type should be Resource');
        System.AssertEquals(supplierAccount1.Id, incentivePlan.dmpl__SupplierAccountId__c, 'Supplier Account should be same');
    }
    
    @isTest
    static void createIncentivePlanWithNoSupplierAccountPositive(){
        Date periodStartDate = Date.newInstance(2025, 6, 20);
        Date periodEndDate = Date.newInstance(2025, 7, 20);
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.createIncentivePlan('Incentive A','Monthly','Resource',periodStartDate,periodEndDate,null,null);
        
        Test.stopTest();
        
        System.assertNotEquals(null, incentivePlan.Id, 'IncentivePlan should be created');
        
        System.assertEquals('Incentive A', incentivePlan.Name, 'Name should match');
        System.assertEquals('Monthly', incentivePlan.dmpl__PeriodType__c, 'Period Type should be Monthly');
        System.assertEquals(Date.newInstance(2025, 6, 20), incentivePlan.dmpl__PeriodStartDate__c, 'Start date should be 20/06/2025');
        System.assertEquals(Date.newInstance(2025, 7, 20), incentivePlan.dmpl__PeriodEndDate__c, 'End date should be 20/07/2025');
        System.assertEquals('Resource', incentivePlan.dmpl__MemberType__c, 'Member Type should be Resource');
    }
    
    
    @isTest
    static void createIncentivePlanWithInactivePartnerAccountNagative(){
        Date periodStartDate = Date.newInstance(2025, 6, 20);
        Date periodEndDate = Date.newInstance(2025, 7, 20);
        Account partnerAccount2 = TestDataHelpers.getPartnerAccount('Partner 2');
        Test.startTest();
        try {
            dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.createIncentivePlan('Incentive A','Monthly','Resource',periodStartDate,periodEndDate,null,partnerAccount2);
            System.assertEquals(null, incentivePlan.Id, 'IncentivePlan should not be created with inactive partner Account');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'IncentivePlan should not be created with inactive partner Account');
        }
        
        Test.stopTest();
        
    }
    
    @isTest
    static void updateIncentivePlanWithInactivePartnerAccountNagative(){
        Date periodStartDate = Date.newInstance(2025, 6, 20);
        Date periodEndDate = Date.newInstance(2025, 7, 20);
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partnerAccount2 = TestDataHelpers.getPartnerAccount('Partner 2');
        
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.createIncentivePlan('Incentive A','Monthly','Resource',periodStartDate,periodEndDate,null,partnerAccount1);
        
        
        System.assertNotEquals(null, incentivePlan.Id, 'IncentivePlan should be created');
        System.assertEquals('Incentive A', incentivePlan.Name, 'Name should match');
        System.assertEquals('Monthly', incentivePlan.dmpl__PeriodType__c, 'Period Type should be Monthly');
        System.assertEquals(Date.newInstance(2025, 6, 20), incentivePlan.dmpl__PeriodStartDate__c, 'Start date should be 20/06/2025');
        System.assertEquals(Date.newInstance(2025, 7, 20), incentivePlan.dmpl__PeriodEndDate__c, 'End date should be 20/07/2025');
        System.assertEquals('Resource', incentivePlan.dmpl__MemberType__c, 'Member Type should be Resource');
        System.assertEquals(partnerAccount1.Id, incentivePlan.dmpl__PartnerAccountId__c, 'Partner Account should be same');
        
        
        Boolean exceptionThrown = false;
        try {
            incentivePlan.dmpl__PartnerAccountId__c = partnerAccount2.Id;
            update incentivePlan;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true,exceptionThrown, 'Expected exception when assigning inactive Partner Account');
        Test.startTest();
    }
    
    @isTest
    static void updateIncentivePlanWithSupplierAccountPositive(){
        Date periodStartDate = Date.newInstance(2025, 6, 20);
        Date periodEndDate = Date.newInstance(2025, 7, 20);
        Account supplierAccount1=TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.createIncentivePlan('Incentive A','Monthly','Resource',periodStartDate,periodEndDate,null,null);
        
        
        System.assertNotEquals(null, incentivePlan.Id, 'IncentivePlan should be created');
        System.assertEquals('Incentive A', incentivePlan.Name, 'Name should match');
        System.assertEquals('Monthly', incentivePlan.dmpl__PeriodType__c, 'Period Type should be Monthly');
        System.assertEquals(Date.newInstance(2025, 6, 20), incentivePlan.dmpl__PeriodStartDate__c, 'Start date should be 20/06/2025');
        System.assertEquals(Date.newInstance(2025, 7, 20), incentivePlan.dmpl__PeriodEndDate__c, 'End date should be 20/07/2025');
        System.assertEquals('Resource', incentivePlan.dmpl__MemberType__c, 'Member Type should be Resource');
        
        Boolean exceptionThrown = false;
        try {
            incentivePlan.dmpl__SupplierAccountId__c = supplierAccount1.Id;
            update incentivePlan;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(false,exceptionThrown, 'exception caught when assigning supplier Account');
        
        dmpl__IncentivePlan__c incentivePlan1 = IncentivePlanDataHelper.getIncentivePlan(incentivePlan.Id);
        Test.stopTest();
        
        System.assertEquals('Incentive A', incentivePlan.Name, 'Name should match');
        System.assertEquals('Monthly', incentivePlan.dmpl__PeriodType__c, 'Period Type should be Monthly');
        System.assertEquals(Date.newInstance(2025, 6, 20), incentivePlan.dmpl__PeriodStartDate__c, 'Start date should be 20/06/2025');
        System.assertEquals(Date.newInstance(2025, 7, 20), incentivePlan.dmpl__PeriodEndDate__c, 'End date should be 20/07/2025');
        System.assertEquals('Resource', incentivePlan.dmpl__MemberType__c, 'Member Type should be Resource');
        System.AssertEquals(supplierAccount1.Id, incentivePlan.dmpl__SupplierAccountId__c, 'Supplier Account should be same');
        
    }
    
    
    @isTest
    static void updateIncentivePlanWithNoSupplierAccountPositive(){
        Date periodStartDate = Date.newInstance(2025, 6, 20);
        Date periodEndDate = Date.newInstance(2025, 7, 20);
        Account supplierAccount1=TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.createIncentivePlan('Incentive A','Monthly','Resource',periodStartDate,periodEndDate,supplierAccount1,null);
        
        System.assertNotEquals(null, incentivePlan.Id, 'IncentivePlan should be created');
        
        System.assertEquals('Incentive A', incentivePlan.Name, 'Name should match');
        System.assertEquals('Monthly', incentivePlan.dmpl__PeriodType__c, 'Period Type should be Monthly');
        System.assertEquals(Date.newInstance(2025, 6, 20), incentivePlan.dmpl__PeriodStartDate__c, 'Start date should be 20/06/2025');
        System.assertEquals(Date.newInstance(2025, 7, 20), incentivePlan.dmpl__PeriodEndDate__c, 'End date should be 20/07/2025');
        System.assertEquals('Resource', incentivePlan.dmpl__MemberType__c, 'Member Type should be Resource');
        System.AssertEquals(supplierAccount1.Id, incentivePlan.dmpl__SupplierAccountId__c, 'Supplier Account should be same');
        
        Boolean exceptionThrown = false;
        Test.startTest();
        try{
            incentivePlan.dmpl__SupplierAccountId__c = null;
            update incentivePlan;
        }catch (Exception e) {
            exceptionThrown = true;
            
        }
        System.assertEquals(false,exceptionThrown, 'exception caught when removing supplier Account');
        
        Test.stopTest();
        System.assertEquals('Incentive A', incentivePlan.Name, 'Name should match');
        System.assertEquals('Monthly', incentivePlan.dmpl__PeriodType__c, 'Period Type should be Monthly');
        System.assertEquals(Date.newInstance(2025, 6, 20), incentivePlan.dmpl__PeriodStartDate__c, 'Start date should be 20/06/2025');
        System.assertEquals(Date.newInstance(2025, 7, 20), incentivePlan.dmpl__PeriodEndDate__c, 'End date should be 20/07/2025');
        System.assertEquals('Resource', incentivePlan.dmpl__MemberType__c, 'Member Type should be Resource');
    }
    
    
    @isTest
    static void createIncentivePlanWithDefinedPeriodTypePositive(){
        Date periodStartDate = Date.newInstance(2025, 6, 20);
        Date periodEndDate = Date.newInstance(2025, 7, 20);
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.createIncentivePlan('Incentive A','Monthly','Resource',periodStartDate,periodEndDate,null,null);
        Test.stopTest();
        
        System.assertNotEquals(null, incentivePlan.Id, 'IncentivePlan should be created');
        System.assertEquals('Incentive A', incentivePlan.Name, 'Name should match');
        System.assertEquals('Monthly', incentivePlan.dmpl__PeriodType__c, 'Period Type should be Monthly');
        System.assertEquals(Date.newInstance(2025, 6, 20), incentivePlan.dmpl__PeriodStartDate__c, 'Start date should be 20/06/2025');
        System.assertEquals(Date.newInstance(2025, 7, 20), incentivePlan.dmpl__PeriodEndDate__c, 'End date should be 20/07/2025');
        System.assertEquals('Resource', incentivePlan.dmpl__MemberType__c, 'Member Type should be Resource');
    }
    
    @isTest
    static void createIncentivePlanWithoutPeriodTypeNegative(){
        Date periodStartDate = Date.newInstance(2025, 6, 20);
        Date periodEndDate = Date.newInstance(2025, 7, 20);
        Test.startTest();
        try{
            dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.createIncentivePlan('Incentive A',null,'Resource',periodStartDate,periodEndDate,null,null);
            System.assertEquals(null, incentivePlan.Id, 'incentive plan should not be created without period type');
        }catch (Exception e) {
            System.Assert.isTrue(true, 'Incentive plan should not be created without period type');
        }
        Test.stopTest();
    }
    
    @isTest
    static void updateIncentivePlanWithoutPeriodTypeNegative(){
        Date periodStartDate = Date.newInstance(2025, 6, 20);
        Date periodEndDate = Date.newInstance(2025, 7, 20);
        
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.createIncentivePlan('Incentive A','Monthly','Resource',periodStartDate,periodEndDate,null,null);
        
        System.assertNotEquals(null, incentivePlan.Id, 'IncentivePlan should be created');
        System.assertEquals('Incentive A', incentivePlan.Name, 'Name should match');
        System.assertEquals('Monthly', incentivePlan.dmpl__PeriodType__c, 'Period Type should be Monthly');
        System.assertEquals(Date.newInstance(2025, 6, 20), incentivePlan.dmpl__PeriodStartDate__c, 'Start date should be 20/06/2025');
        System.assertEquals(Date.newInstance(2025, 7, 20), incentivePlan.dmpl__PeriodEndDate__c, 'End date should be 20/07/2025');
        System.assertEquals('Resource', incentivePlan.dmpl__MemberType__c, 'Member Type should be Resource');
        
        Test.startTest();
        Boolean exceptionThrown = false;
        try{
            incentivePlan.dmpl__PeriodType__c = null;
            update incentivePlan;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown,'Expected exception when removing period type');
        Test.stopTest();
    }
    
    
    //Incentive Period Test Scenarios
    @isTest
    static void createIncentivePeriodWithPeriodNamePositive(){
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        Date dateFrom = Date.newInstance(2025, 6, 20);
        Date dateTo = Date.newInstance(2025, 7, 20);
        
        Test.startTest();
        dmpl__IncentivePeriod__c incentivePeriod = IncentivePlanDataHelper.createIncentivePeriod('25-Jun',dateFrom,dateTo,incentivePlan);
        Test.stopTest();
        
        System.assertNotEquals(null, incentivePeriod.Id, 'incentivePeriod should be created');
        System.assertEquals('25-Jun', incentivePeriod.Name, 'Name should be 25-Jun');
        System.assertEquals(Date.newInstance(2025, 6, 20), incentivePeriod.dmpl__DateFrom__c, 'DateFrom should be 20/06/2025');
        System.assertEquals(Date.newInstance(2025, 7, 20), incentivePeriod.dmpl__DateTo__c, 'DateTo should be 20/07/2025');
        System.assertEquals(incentivePlan.Id, incentivePeriod.dmpl__IncentivePlanId__c, 'incentive plan should be match');
        
        
    }
    
    @isTest
    static void createIncentivePeriodWithoutPeriodNameNegative(){
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        Date dateFrom = Date.newInstance(2025, 6, 20);
        Date dateTo = Date.newInstance(2025, 7, 20);
        
        Test.startTest();
        try{
            dmpl__IncentivePeriod__c incentivePeriod = IncentivePlanDataHelper.createIncentivePeriod(null,dateFrom,dateTo,incentivePlan);
            System.assertEquals(null, incentivePeriod.Id, 'incentivePeriod should not be created without period Name');
        }catch (Exception e) {
            System.Assert.isTrue(true, 'IncentivePeriod should not be created without period Name');
        }
        Test.stopTest();
        
    }
    
    @isTest
    static void updateIncentivePeriodWithoutPeriodNameNegative(){
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        Date dateFrom = Date.newInstance(2025, 6, 20);
        Date dateTo = Date.newInstance(2025, 7, 20);
        
        dmpl__IncentivePeriod__c incentivePeriod = IncentivePlanDataHelper.createIncentivePeriod('25-Jun',dateFrom,dateTo,incentivePlan);
        
        System.assertNotEquals(null, incentivePeriod.Id, 'incentivePeriod should be created');
        System.assertEquals('25-Jun', incentivePeriod.Name, 'Name should be 25-Jun');
        System.assertEquals(Date.newInstance(2025, 6, 20), incentivePeriod.dmpl__DateFrom__c, 'DateFrom should be 20/06/2025');
        System.assertEquals(Date.newInstance(2025, 7, 20), incentivePeriod.dmpl__DateTo__c, 'DateTo should be 20/07/2025');
        System.assertEquals(incentivePlan.Id, incentivePeriod.dmpl__IncentivePlanId__c, 'incentive plan should be match');
        
        Test.startTest();
        Boolean exceptionThrown = false;
        try{
            incentivePeriod.Name = null;
            update incentivePeriod;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown,'Expected exception when removing period Name');
        Test.stopTest();
        
    }
    
    @isTest
    static void createIncentivePeriodWithDefiningDateFromAndDateToPositive(){
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        Date dateFrom = Date.newInstance(2025, 6, 20);
        Date dateTo = Date.newInstance(2025, 7, 20);
        
        Test.startTest();
        dmpl__IncentivePeriod__c incentivePeriod = IncentivePlanDataHelper.createIncentivePeriod('25-Jun',dateFrom,dateTo,incentivePlan);
        Test.stopTest();
        
        System.assertNotEquals(null, incentivePeriod.Id, 'incentivePeriod should be created');
        System.assertEquals('25-Jun', incentivePeriod.Name, 'Name should be 25-Jun');
        System.assertEquals(Date.newInstance(2025, 6, 20), incentivePeriod.dmpl__DateFrom__c, 'DateFrom should be 20/06/2025');
        System.assertEquals(Date.newInstance(2025, 7, 20), incentivePeriod.dmpl__DateTo__c, 'DateTo should be 20/07/2025');
        System.assertEquals(incentivePlan.Id, incentivePeriod.dmpl__IncentivePlanId__c, 'incentive plan should be match');
        
    }
    
    @isTest
    static void createIncentivePeriodWithoutDefiningDateFromAndDateToNegative(){
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        Test.startTest();
        try{
            dmpl__IncentivePeriod__c incentivePeriod = IncentivePlanDataHelper.createIncentivePeriod('25-Jun',null,null,incentivePlan);
            System.assertEquals(null, incentivePeriod.Id, 'incentivePeriod should not be created without date from and date to');
        }catch (Exception e) {
            System.Assert.isTrue(true, 'incentivePeriod should not be created without date from and date to');
        }
        Test.stopTest();
        
    }
    
    @isTest
    static void updateIncentivePeriodWithoutDefiningDateFromAndDateToNegative(){
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        Date dateFrom = Date.newInstance(2025, 6, 20);
        Date dateTo = Date.newInstance(2025, 7, 20);
        
        dmpl__IncentivePeriod__c incentivePeriod = IncentivePlanDataHelper.createIncentivePeriod('25-Jun',dateFrom,dateTo,incentivePlan);
        
        System.assertNotEquals(null, incentivePeriod.Id, 'incentivePeriod should be created');
        System.assertEquals('25-Jun', incentivePeriod.Name, 'Name should be 25-Jun');
        System.assertEquals(Date.newInstance(2025, 6, 20), incentivePeriod.dmpl__DateFrom__c, 'DateFrom should be 20/06/2025');
        System.assertEquals(Date.newInstance(2025, 7, 20), incentivePeriod.dmpl__DateTo__c, 'DateTo should be 20/07/2025');
        System.assertEquals(incentivePlan.Id, incentivePeriod.dmpl__IncentivePlanId__c, 'incentive plan should be match');
        
        Test.startTest();
        Boolean exceptionThrown = false;
        try{
            incentivePeriod.dmpl__DateFrom__c = null;
            incentivePeriod.dmpl__DateTo__c = null;
            update incentivePeriod;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown,'Expected exception when removing period date from & date to');
    }
    
    @isTest
    static void createIncentivePeriodWithInvalidDateRangeNegative(){
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        Date dateFrom = Date.newInstance(2025, 6, 20);
        Date dateTo = Date.newInstance(2025, 2, 11);
        
        Test.startTest();
        try{
            dmpl__IncentivePeriod__c incentivePeriod = IncentivePlanDataHelper.createIncentivePeriod('25-Jun',dateFrom,dateTo,incentivePlan);
            System.assertEquals(null, incentivePeriod.Id, 'incentivePeriod should not be created with invalid date range');
        }catch (Exception e) {
            System.Assert.isTrue(true, 'IncentivePeriod should not be created with invalid date range');
        }
        Test.stopTest();
        
    }
    
    
    @isTest
    static void updateIncentivePeriodWithInvalidDateRangeNegative(){
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        Date dateFrom = Date.newInstance(2025, 6, 20);
        Date dateTo = Date.newInstance(2025, 7, 20);
        
        dmpl__IncentivePeriod__c incentivePeriod = IncentivePlanDataHelper.createIncentivePeriod('25-Jun',dateFrom,dateTo,incentivePlan);
        
        System.assertNotEquals(null, incentivePeriod.Id, 'incentivePeriod should be created');
        System.assertEquals('25-Jun', incentivePeriod.Name, 'Name should be 25-Jun');
        System.assertEquals(Date.newInstance(2025, 6, 20), incentivePeriod.dmpl__DateFrom__c, 'DateFrom should be 20/06/2025');
        System.assertEquals(Date.newInstance(2025, 7, 20), incentivePeriod.dmpl__DateTo__c, 'DateTo should be 20/07/2025');
        
        Test.startTest();
        Boolean exceptionThrown = false;
        try{
            incentivePeriod.dmpl__DateFrom__c = Date.newInstance(2025, 7, 20);
            incentivePeriod.dmpl__DateTo__c = Date.newInstance(2025, 2, 11);
            update incentivePeriod;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown,'Expected exception when updating invalid date range');
        Test.stopTest();
        
    }
    
    @isTest
    static void createIncentivePeriodWithIncentivePlanReferencePositive(){
        Date periodStartDate = Date.newInstance(2025, 6, 20);
        Date periodEndDate = Date.newInstance(2025, 7, 20);
        
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.createIncentivePlan('Incentive A','Monthly','Resource',periodStartDate,periodEndDate,null,null);
        System.assertNotEquals(null, incentivePlan.Id, 'IncentivePlan should be created');
        System.assertEquals('Incentive A', incentivePlan.Name, 'Name should match');
        System.assertEquals('Monthly', incentivePlan.dmpl__PeriodType__c, 'Period Type should be Monthly');
        System.assertEquals(Date.newInstance(2025, 6, 20), incentivePlan.dmpl__PeriodStartDate__c, 'Start date should be 20/06/2025');
        System.assertEquals(Date.newInstance(2025, 7, 20), incentivePlan.dmpl__PeriodEndDate__c, 'End date should be 20/07/2025');
        System.assertEquals('Resource', incentivePlan.dmpl__MemberType__c, 'Member Type should be Resource');
        
        Date dateFrom = Date.newInstance(2025, 6, 20);
        Date dateTo = Date.newInstance(2025, 7, 20);
        
        Test.startTest();
        dmpl__IncentivePeriod__c incentivePeriod = IncentivePlanDataHelper.createIncentivePeriod('25-Jun',dateFrom,dateTo,incentivePlan);
        Test.stopTest();
        
        System.assertNotEquals(null, incentivePeriod.Id, 'incentivePeriod should be created');
        System.assertEquals('25-Jun', incentivePeriod.Name, 'Name should be 25-Jun');
        System.assertEquals(Date.newInstance(2025, 6, 20), incentivePeriod.dmpl__DateFrom__c, 'DateFrom should be 20/06/2025');
        System.assertEquals(Date.newInstance(2025, 7, 20), incentivePeriod.dmpl__DateTo__c, 'DateTo should be 20/07/2025');
        System.assertEquals(incentivePlan.Id, incentivePeriod.dmpl__IncentivePlanId__c, 'incentive plan should be match');
        
    }
    
    @isTest
    static void createIncentivePeriodWithoutIncentivePlanReferenceNegative(){
        
        Date dateFrom = Date.newInstance(2025, 6, 20);
        Date dateTo = Date.newInstance(2025, 7, 20);
        
        Test.startTest();
        try{
            dmpl__IncentivePeriod__c incentivePeriod = IncentivePlanDataHelper.createIncentivePeriod('25-Jun',dateFrom,dateTo,null);
            System.assertEquals(null, incentivePeriod.Id, 'Incentice period should not becreated without incentive plan reference');
        }catch(Exception e){
            System.Assert.isTrue(true, 'Incentive period should not be created without incentive plan reference');
        }
        Test.stopTest();
        
    }
    
    //Incentive resource
    @isTest
    static void createIncentiveResourceWithIncentivePlanReferencePositive(){
        
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');
        Account partnerAccount4=TestDataHelpers.getPartnerAccount('Partner 4');
        //dmpl__Resource__c resource4 = TestDataHelpers.getResource('Resource 4');
        
        Date periodStartDate = Date.newInstance(2025, 6, 20);
        Date periodEndDate = Date.newInstance(2025, 7, 20);
        
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.createIncentivePlan('Incentive A','Monthly','Resource',periodStartDate,periodEndDate,null,null);
        System.assertNotEquals(null, incentivePlan.Id, 'IncentivePlan should be created');
        System.assertEquals('Incentive A', incentivePlan.Name, 'Name should match');
        System.assertEquals('Monthly', incentivePlan.dmpl__PeriodType__c, 'Period Type should be Monthly');
        System.assertEquals(Date.newInstance(2025, 6, 20), incentivePlan.dmpl__PeriodStartDate__c, 'Start date should be 20/06/2025');
        System.assertEquals(Date.newInstance(2025, 7, 20), incentivePlan.dmpl__PeriodEndDate__c, 'End date should be 20/07/2025');
        System.assertEquals('Resource', incentivePlan.dmpl__MemberType__c, 'Member Type should be Resource');
        
        Test.startTest();
        dmpl__IncentiveResource__c incentiveResource = IncentivePlanDataHelper.createIncentiveResource(partnerAccount4,branch4,'Resource 4',incentivePlan);
        Test.stopTest();
        
        System.assertNotEquals(null, incentiveResource.Id, 'incentiveResource should be created');
        System.assertEquals(partnerAccount4.Id, incentiveResource.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 4');
        System.assertEquals(branch4.Id, incentiveResource.dmpl__BranchId__c, 'Branch should be Branch 4');
        System.assertEquals('Resource 4', incentiveResource.Name, 'Resource Name should be Resource 4');
        System.assertEquals(incentivePlan.Id, incentiveResource.dmpl__IncentivePlanId__c, 'Incentive Plan should be present');
        
    }
    
    
    @isTest
    static void createIncentiveResourceWithoutIncentivePlanReferenceNegative(){
        
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');
        Account partnerAccount4=TestDataHelpers.getPartnerAccount('Partner 4');
        
        Test.startTest();
        try{
            dmpl__IncentiveResource__c incentiveResource = IncentivePlanDataHelper.createIncentiveResource(partnerAccount4,branch4,'Resource 4',null);
            System.assertEquals(null, incentiveResource.Id, 'incentiveResource should not be created without incentive plan');
        }catch(Exception e){
            System.Assert.isTrue(true, 'incentiveResource should not be created without incentive plan');
            
        }
        Test.stopTest();
    }
    
    
    @isTest
    static void updateIncentiveResourceWithoutIncentivePlanReferenceNegative(){
        
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');
        Account partnerAccount4=TestDataHelpers.getPartnerAccount('Partner 4');
        
        Date periodStartDate = Date.newInstance(2025, 6, 20);
        Date periodEndDate = Date.newInstance(2025, 7, 20);
        
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.createIncentivePlan('Incentive A','Monthly','Resource',periodStartDate,periodEndDate,null,null);
        System.assertNotEquals(null, incentivePlan.Id, 'IncentivePlan should be created');
        System.assertEquals('Incentive A', incentivePlan.Name, 'Name should match');
        System.assertEquals('Monthly', incentivePlan.dmpl__PeriodType__c, 'Period Type should be Monthly');
        System.assertEquals(Date.newInstance(2025, 6, 20), incentivePlan.dmpl__PeriodStartDate__c, 'Start date should be 20/06/2025');
        System.assertEquals(Date.newInstance(2025, 7, 20), incentivePlan.dmpl__PeriodEndDate__c, 'End date should be 20/07/2025');
        System.assertEquals('Resource', incentivePlan.dmpl__MemberType__c, 'Member Type should be Resource');
        
        dmpl__IncentiveResource__c incentiveResource = IncentivePlanDataHelper.createIncentiveResource(partnerAccount4,branch4,'Resource 4',incentivePlan);
        
        System.assertNotEquals(null, incentiveResource.Id, 'incentiveResource should be created');
        System.assertEquals(partnerAccount4.Id, incentiveResource.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 4');
        System.assertEquals(branch4.Id, incentiveResource.dmpl__BranchId__c, 'Branch should be Branch 4');
        System.assertEquals('Resource 4', incentiveResource.Name, 'Resource Name should be Resource 4');
        System.assertEquals(incentivePlan.Id, incentiveResource.dmpl__IncentivePlanId__c, 'Incentive Plan should be present');
        
        Test.startTest();
        Boolean exceptionThrown = false;
        try{
            incentiveResource.dmpl__IncentivePlanId__c = null;
            update incentiveResource;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown,'Expected exception when removing incentive plan from incentive resource');
        Test.stopTest();
    }
    
    @isTest
    static void createIncentiveResourceWithNoPartnerAccountNegative(){
        
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        
        Test.startTest();
        try{
            dmpl__IncentiveResource__c incentiveResource = IncentivePlanDataHelper.createIncentiveResource(null,branch4,'Resource 4',incentivePlan);
            System.assertEquals(null, incentiveResource.Id, 'incentiveResource should not be created without partner account');
        }catch (Exception e) {
            System.Assert.isTrue(true, 'incentiveResource should not be created without partner account');
        }
        Test.stopTest();
    }
    
    @isTest
    static void createIncentiveResourceWithInactivePartnerAccountNegative(){
        
        Account partnerAccount2 = TestDataHelpers.getPartnerAccount('Partner 2');
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        
        Test.startTest();
        try{
            dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partnerAccount2.Id, true, false, true, true);
            dmpl__IncentiveResource__c incentiveResource = IncentivePlanDataHelper.createIncentiveResource(partnerAccount2,branch2,'Resource 4',incentivePlan);
            System.assertEquals(null, incentiveResource.Id, 'incentiveResource should not be created with Inactive partner account');
        }catch (Exception e) {
            System.Assert.isTrue(true, 'incentiveResource should not be created with Inactive partner account');
        }
        Test.stopTest();
    }
    
    @isTest
    static void updateIncentiveResourceWithInactivePartnerAccountNegative(){
        
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');
        Account partnerAccount4=TestDataHelpers.getPartnerAccount('Partner 4');
        Account partnerAccount2 = TestDataHelpers.getPartnerAccount('Partner 2');
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        
        
        dmpl__IncentiveResource__c incentiveResource = IncentivePlanDataHelper.createIncentiveResource(partnerAccount4,branch4,'Resource 4',incentivePlan);
        
        System.assertNotEquals(null, incentiveResource.Id, 'incentiveResource should be created');
        System.assertEquals(partnerAccount4.Id, incentiveResource.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 4');
        System.assertEquals(branch4.Id, incentiveResource.dmpl__BranchId__c, 'Branch should be Branch 4');
        System.assertEquals('Resource 4', incentiveResource.Name, 'Resource Name should be Resource 4');
        System.assertEquals(incentivePlan.Id, incentiveResource.dmpl__IncentivePlanId__c, 'Incentive Plan should be present');
        
        Test.startTest();
        Boolean exceptionThrown = false;
        try{
            dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partnerAccount2.Id, true, false, true, true);
            incentiveResource.dmpl__PartnerAccountId__c = partnerAccount2.Id;
            incentiveResource.dmpl__BranchId__c = branch2.Id;
            update incentiveResource;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown,'Expected exception updating inactive partner account to incentive resource');
        Test.stopTest();
    }
    
    @isTest
    static void createIncentiveResourceWithNoBranchNegative(){
        
        Account partnerAccount4=TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        
        Test.startTest();
        try{
            dmpl__IncentiveResource__c incentiveResource = IncentivePlanDataHelper.createIncentiveResource(partnerAccount4,null,'Resource 4',incentivePlan);
            System.assertEquals(null, incentiveResource.Id, 'incentiveResource should not be created without branch');
        }catch (Exception e) {
            System.Assert.isTrue(true, 'incentiveResource should not be created without partner account');
        }
        Test.stopTest();
    }
    
    //Compensation creation with partner Account(New)
    @isTest
    static void createCompensationWithPartnerAccountPositive(){
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(
            incentivePlan.Id,
        branch.Id,
        partnerAccount.Id,
        null,
        null
            );
        dmpl__IncentiveCompensation__c fetchedCompensation = IncentivePlanDataHelper.getCompensation(compensation.Id);
        Test.stopTest();
        
        System.assertNotEquals(null, fetchedCompensation, 'Fetched compensation should not be null');
        System.assertEquals(partnerAccount.Id, fetchedCompensation.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedCompensation.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(incentivePlan.Id, fetchedCompensation.dmpl__IncentivePlanId__c, 'Incentive Plan should match');
    }
    
    //Compensation creation with Partner Account (Edit)
    @isTest
    static void updateCompensationWithPartnerAccountPositive(){
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(
            incentivePlan.Id,
        branch.Id,
        partnerAccount.Id,
        null,
        null
            );
        Account partnerAccount2 = TestDataHelpers.getPartnerAccount('Partner 2');
        dmpl__IncentiveCompensation__c fetchedCompensation = IncentivePlanDataHelper.getCompensation(compensation.Id);
        fetchedCompensation.dmpl__PartnerAccountId__c = partnerAccount2.Id;
        update fetchedCompensation;
        dmpl__IncentiveCompensation__c updatedCompensation = IncentivePlanDataHelper.getCompensation(fetchedCompensation.Id);
        
        Test.stopTest();
        
        System.assertNotEquals(null, updatedCompensation, 'Fetched compensation should not be null');
        System.assertEquals(partnerAccount2.Id, updatedCompensation.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, updatedCompensation.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(incentivePlan.Id, updatedCompensation.dmpl__IncentivePlanId__c, 'Incentive Plan should match');
    }
    
    //Compensation creation without Partner Account (New)
    @isTest
    static void createCompensationWithoutPartnerAccountPositive() {
        Boolean exceptionThrown = false;
        
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(
            incentivePlan.Id,
        branch.Id,
        null,  // Partner Account is null
        null,
        null
            );
        
        dmpl__IncentiveCompensation__c fetchedCompensation = IncentivePlanDataHelper.getCompensation(compensation.Id);
        Test.stopTest();
        
        System.assertNotEquals(null, fetchedCompensation, 'Fetched compensation should not be null');
        System.assertEquals(null, fetchedCompensation.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedCompensation.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(incentivePlan.Id, fetchedCompensation.dmpl__IncentivePlanId__c, 'Incentive Plan should match');
    }
    
    //Compensation creation with Branch(New)
    @isTest
    static void createCompensationWithBranchPositive(){
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(
            incentivePlan.Id,
        branch.Id,
        partnerAccount.Id,
        null,
        null
            );
        dmpl__IncentiveCompensation__c fetchedCompensation = IncentivePlanDataHelper.getCompensation(compensation.Id);
        Test.stopTest();
        
        System.assertNotEquals(null, fetchedCompensation, 'Fetched compensation should not be null');
        System.assertEquals(partnerAccount.Id, fetchedCompensation.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedCompensation.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(incentivePlan.Id, fetchedCompensation.dmpl__IncentivePlanId__c, 'Incentive Plan should match');
    }
    
    //Compensation creation with Branch (Edit)
    @isTest
    static void updateCompensationWithBranchPositive(){
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1', false, true, false, true, 'MG Road', 'Bengaluru', 'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India', '560095','9876543210');
        dmpl__Branch__c branch1=TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id, true, true, false, true);
        
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(
            incentivePlan.Id,
        branch.Id,
        partnerAccount.Id,
        null,
        null
            );
        dmpl__IncentiveCompensation__c fetchedCompensation = IncentivePlanDataHelper.getCompensation(compensation.Id);
        fetchedCompensation.dmpl__BranchId__c = branch1.Id;
        Update fetchedCompensation;
        
        dmpl__IncentiveCompensation__c updatedCompensation = IncentivePlanDataHelper.getCompensation(fetchedCompensation.Id);
        Test.stopTest();
        
        System.assertNotEquals(null, updatedCompensation, 'Fetched compensation should not be null');
        System.assertEquals(partnerAccount1.Id, updatedCompensation.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, updatedCompensation.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(incentivePlan.Id, updatedCompensation.dmpl__IncentivePlanId__c, 'Incentive Plan should match');
    }
    
    //Compensation creation without Branch (New)
    @isTest
    static void createCompensationWithoutBranchPositive() {
        Boolean exceptionThrown = false;
        
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(
            incentivePlan.Id,
        null,
        partnerAccount.Id,
        null,
        null);
        
        dmpl__IncentiveCompensation__c fetchedCompensation = IncentivePlanDataHelper.getCompensation(compensation.Id);
        Test.stopTest();
        
        System.assertNotEquals(null, fetchedCompensation, 'Fetched compensation should not be null');
        System.assertEquals(partnerAccount.Id, fetchedCompensation.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(null, fetchedCompensation.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(incentivePlan.Id, fetchedCompensation.dmpl__IncentivePlanId__c, 'Incentive Plan should match');
    }
    
    //Compensation creation with Incentive Plan(New)
    @isTest
    static void createCompensationWithIncentivePlanPositive(){
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(
            incentivePlan.Id,
        branch.Id,
        partnerAccount.Id,
        null,
        null
            );
        dmpl__IncentiveCompensation__c fetchedCompensation = IncentivePlanDataHelper.getCompensation(compensation.Id);
        Test.stopTest();
        
        System.assertNotEquals(null, fetchedCompensation, 'Fetched compensation should not be null');
        System.assertEquals(partnerAccount.Id, fetchedCompensation.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedCompensation.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(incentivePlan.Id, fetchedCompensation.dmpl__IncentivePlanId__c, 'Incentive Plan should match');
    }
    
    //Compensation creation with Incentive Plan (Edit)
    @isTest
    static void updateCompensationWithIncentivePlanPositive(){
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__AccountGroup__c accountGroup = TestDataHelpers.getAccountGroup();
        Account supplierAccount = TestDataHelpers.getSupplierAccount();
        
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(
            incentivePlan.Id,
        branch.Id,
        partnerAccount.Id,
        null,
        null
            );
        
        dmpl__IncentivePlan__c plan = IncentivePlanDataHelper.createIncentivePlan(
            'Yearly',
        'Resource',
        'Draft',
        Date.today(),
        Date.today().addYears(1).addDays(-1),
        accountGroup.Id,
        partnerAccount.Id,
        supplierAccount.Id
            );
        
        dmpl__IncentiveCompensation__c fetchedCompensation = IncentivePlanDataHelper.getCompensation(compensation.Id);
        fetchedCompensation.dmpl__IncentivePlanId__c = plan.Id;
        Update fetchedCompensation;
        
        dmpl__IncentiveCompensation__c updatedCompensation = IncentivePlanDataHelper.getCompensation(fetchedCompensation.Id);
        Test.stopTest();
        System.assertEquals(partnerAccount.Id, updatedCompensation.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, updatedCompensation.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(plan.Id, updatedCompensation.dmpl__IncentivePlanId__c, 'Incentive Plan should be updated');
        
    }
    
    //Compensation creation without Incentive Plan (New)
    @isTest
    static void createCompensationWithoutEncentivePlanPositive() {
        Boolean exceptionThrown = false;
        
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(
            null,
        branch.Id,
        partnerAccount.Id,
        null,
        null
            );
        
        dmpl__IncentiveCompensation__c fetchedCompensation = IncentivePlanDataHelper.getCompensation(compensation.Id);
        Test.stopTest();
        
        System.assertNotEquals(null, fetchedCompensation, 'Fetched compensation should not be null');
        System.assertEquals(partnerAccount.Id, fetchedCompensation.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedCompensation.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(null, fetchedCompensation.dmpl__IncentivePlanId__c, 'Incentive Plan should match');
    }
    
    //Compensation creation with Scheme(New)
    @isTest
    static void createCompensationLineCreationWithSchemePositive() {
        Boolean exceptionThrown = false;
        
        Test.startTest();
        
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Scheme__c scheme = SchemeTestDataHelper.getScheme();
        
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(
            null,
        branch.Id,
        partnerAccount.Id,
        null,
        null
            );
        
        dmpl__IncentiveCompensationLine__c compensationLine = IncentivePlanDataHelper.createCompensationLine(
            compensation.Id,
        incentivePlan.Id,
        scheme.Id
            );
        
        dmpl__IncentiveCompensationLine__c fetchedCompensationLine = IncentivePlanDataHelper.getCompensationLine(compensationLine.Id);
        
        Test.stopTest();
        
        System.assertEquals(compensation.Id, fetchedCompensationLine.dmpl__CompensationId__c, 'Compensation reference should match');
        System.assertEquals(scheme.Id, fetchedCompensationLine.dmpl__SchemeId__c, 'Scheme reference should match');
        System.assertEquals(incentivePlan.Id, fetchedCompensationLine.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
    }
    
    //Compensation creation with Scheme(Edit)
    @isTest
    static void updateCompensationLineCreationWithSchemePositive() {
        Boolean exceptionThrown = false;
        
        Test.startTest();
        
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Scheme__c scheme = SchemeTestDataHelper.getScheme();
        
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(
            null,
        branch.Id,
        partnerAccount.Id,
        null,
        null
            );
        
        dmpl__IncentiveCompensationLine__c compensationLine = IncentivePlanDataHelper.createCompensationLine(
            compensation.Id,
        incentivePlan.Id,
        scheme.Id
            );
        
        dmpl__IncentiveCompensationLine__c fetchedCompensationLine = IncentivePlanDataHelper.getCompensationLine(compensationLine.Id);
        
        dmpl__Scheme__c scheme2 = SchemeTestDataHelper.createScheme(
            'Scheme 2',
        '',
        '',
        'Per Sale Order',
        'Weekly',
        Date.today(),
        Date.today().addMonths(1),
        0,
        '',
        0,
        false,
        (Id)null,
        (Id)null,
        (Id)null,
        (Id)null,
        (Id)null
            );
        fetchedCompensationLine.dmpl__SchemeId__c = scheme2.Id;
        Update fetchedCompensationLine;
        dmpl__IncentiveCompensationLine__c updatedCompensationLine = IncentivePlanDataHelper.getCompensationLine(fetchedcompensationLine.Id);
        
        Test.stopTest();
        
        System.assertEquals(compensation.Id, updatedCompensationLine.dmpl__CompensationId__c, 'Compensation reference should match');
        System.assertEquals(scheme2.Id, updatedCompensationLine.dmpl__SchemeId__c, 'Scheme reference should match');
        System.assertEquals(incentivePlan.Id, updatedCompensationLine.dmpl__IncentivePlanId__c, 'Incentive Plan ID should match');
    }
    
    //Compensation creation without Scheme(New)
    @isTest
    static void createCompensationLineWithoutSchemeNegative() {
        Boolean exceptionThrown = false;
        
        Test.startTest();
        
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(
            null,
        branch.Id,
        partnerAccount.Id,
        null,
        null
            );
        
        Test.stopTest();
        dmpl__IncentiveCompensationLine__c compensationLine = IncentivePlanDataHelper.createCompensationLine(
            compensation.Id,
        incentivePlan.Id,
        null
            );
        
        System.assertEquals(true, exceptionThrown, 'An exception should be thrown when Scheme is missing.');
    }
    
    //Compensation creation with Incentive  Plan Id(New)
    @isTest
    static void createCompensationLineWithIncentivePlanPositive() {
        Test.startTest();
        
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Scheme__c scheme = SchemeTestDataHelper.getScheme();
        
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(
            incentivePlan.Id,
        branch.Id,
        partnerAccount.Id,
        null,
        null
            );
        
        dmpl__IncentiveCompensationLine__c compensationLine = IncentivePlanDataHelper.createCompensationLine(
            compensation.Id,
        incentivePlan.Id,
        scheme.Id
            );
        
        dmpl__IncentiveCompensationLine__c fetchedCompensationLine = IncentivePlanDataHelper.getCompensationLine(compensationLine.Id);
        
        Test.stopTest();
        
        System.assertEquals(compensation.Id, fetchedCompensationLine.dmpl__CompensationId__c, 'Compensation reference should match');
        System.assertEquals(incentivePlan.Id, fetchedCompensationLine.dmpl__IncentivePlanId__c, 'Incentive Plan reference should match');
        System.assertEquals(scheme.Id, fetchedCompensationLine.dmpl__SchemeId__c, 'Scheme reference should match');
        System.assertEquals(incentivePlan.Id, compensation.dmpl__IncentivePlanId__c, 'Compensation should reference the correct Incentive Plan');
        System.assertEquals(branch.Id, compensation.dmpl__BranchId__c, 'Compensation should reference the correct Branch');
        System.assertEquals(partnerAccount.Id, compensation.dmpl__PartnerAccountId__c, 'Compensation should reference the correct Partner Account');
    }
    
    //Compensation creation with Incentive  Plan Id(Edit)
    @isTest
    static void updateCompensationLineWithIncentivePlanPositive() {
        Test.startTest();
        
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Scheme__c scheme = SchemeTestDataHelper.getScheme();
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplierAccount = TestDataHelpers.getPartnerAccount('Supplier 1');
        dmpl__AccountGroup__c accountGroup = TestDataHelpers.getAccountGroup();
        
        
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(
            incentivePlan.Id,
        branch.Id,
        partnerAccount.Id,
        null,
        null
            );
        
        dmpl__IncentiveCompensationLine__c compensationLine = IncentivePlanDataHelper.createCompensationLine(
            compensation.Id,
        incentivePlan.Id,
        scheme.Id
            );
        
        dmpl__IncentivePlan__c plan1 = IncentivePlanDataHelper.createIncentivePlan(
            'Yearly',
        'Resource',
        'Draft',
        Date.today(),
        Date.today().addYears(1).addDays(-1),
        accountGroup.Id,
        partnerAccount1.Id,
        supplierAccount.Id
            );
        
        dmpl__IncentiveCompensationLine__c fetchedCompensationLine = IncentivePlanDataHelper.getCompensationLine(compensationLine.Id);
        fetchedCompensationLine.dmpl__IncentivePlanId__c = plan1.Id;
        Update fetchedCompensationLine;
        dmpl__IncentiveCompensationLine__c updatedCompensationLine = IncentivePlanDataHelper.getCompensationLine(fetchedCompensationLine.Id);
        Test.stopTest();
        System.assertEquals(plan1.Id, updatedCompensationLine.dmpl__IncentivePlanId__c, 'Incentive Plan should be updated.');
        System.assertEquals(compensation.Id, updatedCompensationLine.dmpl__CompensationId__c, 'Compensation should remain unchanged.');
        System.assertEquals(scheme.Id, updatedCompensationLine.dmpl__SchemeId__c, 'Scheme should remain unchanged.');
        System.assertNotEquals(null, updatedCompensationLine.Id, 'Compensation Line should exist.');
        System.assertEquals('Yearly', plan1.dmpl__PeriodType__c, 'Plan frequency should be Yearly.');
        System.assertEquals('Draft', plan1.dmpl__Status__c, 'Plan status should be Draft.');
        System.assertEquals(partnerAccount1.Id, plan1.dmpl__PartnerAccountId__c, 'Plan should link to correct partner.');
        System.assertEquals(accountGroup.Id, plan1.dmpl__AccountGroupId__c, 'Plan should link to correct account group.');
        System.assertEquals(supplierAccount.Id, plan1.dmpl__SupplierAccountId__c, 'Plan should link to correct supplier.');
        System.assertEquals(partnerAccount.Id, compensation.dmpl__PartnerAccountId__c, 'Compensation should still point to original partner.');
        System.assertEquals(branch.Id, compensation.dmpl__BranchId__c, 'Compensation should still point to original branch.');
    }
    
    //Compensation creation without Incentive  Plan Id(New)
    @isTest
    static void createCompensationLineWithoutIncentivePlanNegative() {
        
        Boolean exceptionThrown = false;
        Test.startTest();
        
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Scheme__c scheme = SchemeTestDataHelper.getScheme();
        
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(
            incentivePlan.Id,
        branch.Id,
        partnerAccount.Id,
        null,
        null
            );
        dmpl__IncentiveCompensationLine__c compensationLine = IncentivePlanDataHelper.createCompensationLine(
            compensation.Id,
        null,
        scheme.Id
            );
        dmpl__IncentiveCompensationLine__c fetchedCompensationLine = IncentivePlanDataHelper.getCompensationLine(compensationLine.Id);
        
        Test.stopTest();
        
        System.assertEquals(compensation.Id, fetchedCompensationLine.dmpl__CompensationId__c, 'Compensation reference should match');
        System.assertEquals(null, fetchedCompensationLine.dmpl__IncentivePlanId__c, 'Incentive Plan reference should match');
        System.assertEquals(scheme.Id, fetchedCompensationLine.dmpl__SchemeId__c, 'Scheme reference should match');
        System.assertEquals(incentivePlan.Id, compensation.dmpl__IncentivePlanId__c, 'Compensation should reference the correct Incentive Plan');
        System.assertEquals(branch.Id, compensation.dmpl__BranchId__c, 'Compensation should reference the correct Branch');
        System.assertEquals(partnerAccount.Id, compensation.dmpl__PartnerAccountId__c, 'Compensation should reference the correct Partner Account');
    }
    
    //Compensation creation with Compensation(New)
    @isTest
    static void createCompensationLineWithCompensationPositive() {
        Test.startTest();
        
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Scheme__c scheme = SchemeTestDataHelper.getScheme();
        
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(
            incentivePlan.Id,
        branch.Id,
        partnerAccount.Id,
        null,
        null
            );
        
        dmpl__IncentiveCompensationLine__c compensationLine = IncentivePlanDataHelper.createCompensationLine(
            compensation.Id,
        incentivePlan.Id,
        scheme.Id
            );
        
        dmpl__IncentiveCompensationLine__c fetchedCompensationLine = IncentivePlanDataHelper.getCompensationLine(compensationLine.Id);
        
        Test.stopTest();
        
        System.assertEquals(compensation.Id, fetchedCompensationLine.dmpl__CompensationId__c, 'Compensation reference should match');
        System.assertEquals(incentivePlan.Id, fetchedCompensationLine.dmpl__IncentivePlanId__c, 'Incentive Plan reference should match');
        System.assertEquals(scheme.Id, fetchedCompensationLine.dmpl__SchemeId__c, 'Scheme reference should match');
        System.assertEquals(incentivePlan.Id, compensation.dmpl__IncentivePlanId__c, 'Compensation should reference the correct Incentive Plan');
        System.assertEquals(branch.Id, compensation.dmpl__BranchId__c, 'Compensation should reference the correct Branch');
        System.assertEquals(partnerAccount.Id, compensation.dmpl__PartnerAccountId__c, 'Compensation should reference the correct Partner Account');
    }
    
    //Compensation creation with Compensation(Edit)
    @isTest
    static void updateCompensationLineWithCompensationPositive() {
        Test.startTest();
        
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Scheme__c scheme = SchemeTestDataHelper.getScheme();
        
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(
            incentivePlan.Id,
        branch.Id,
        partnerAccount.Id,
        null,
        null
            );
        
        dmpl__IncentiveCompensation__c compensation1 = IncentivePlanDataHelper.createCompensation(
            incentivePlan.Id,
        branch1.Id,
        partnerAccount1.Id,
        null,
        null
            );
        
        dmpl__IncentiveCompensationLine__c compensationLine = IncentivePlanDataHelper.createCompensationLine(
            compensation.Id,
        incentivePlan.Id,
        scheme.Id
            );
        
        dmpl__IncentiveCompensationLine__c fetchedCompensationLine = IncentivePlanDataHelper.getCompensationLine(compensationLine.Id);
        fetchedCompensationLine.dmpl__CompensationId__c = compensation1.Id;
        update fetchedCompensationLine;
        
        dmpl__IncentiveCompensationLine__c updatedCompensationLine = IncentivePlanDataHelper.getCompensationLine(fetchedCompensationLine.Id);
        
        Test.stopTest();
        
        System.assertEquals(compensation1.Id, updatedCompensationLine.dmpl__CompensationId__c, 'Compensation Line should reference the updated Compensation record.');
        System.assertEquals(incentivePlan.Id, updatedCompensationLine.dmpl__IncentivePlanId__c, 'Incentive Plan should remain unchanged.');
        System.assertEquals(scheme.Id, updatedCompensationLine.dmpl__SchemeId__c, 'Scheme should remain unchanged.');
        System.assertEquals(branch1.Id, compensation1.dmpl__BranchId__c, 'Branch on compensation1 should be correct.');
        System.assertEquals(partnerAccount1.Id, compensation1.dmpl__PartnerAccountId__c, 'Partner Account on compensation1 should be correct.');
    }
    
    //Compensation creation without Compensation(New)
    @isTest
    static void createCompensationLineWithoutCompensationNegative() {
        Boolean exceptionThrown = false;
        
        Test.startTest();
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Scheme__c scheme = SchemeTestDataHelper.getScheme();
        
        try {
            dmpl__IncentiveCompensationLine__c compensationLine = IncentivePlanDataHelper.createCompensationLine(
                null,
            incentivePlan.Id,
            scheme.Id
                );
        } catch (DmlException e) {
            exceptionThrown = true;
            System.debug('Expected exception caught: ' + e.getMessage());
        }
        Test.stopTest();
        
        System.assertEquals(true, exceptionThrown, 'An exception should be thrown when Compensation is missing.');
    }
    
    //Compensation creation with Required Fields(New)
    @isTest
    static void createCompensationLineWithRequiredFieldsPositive() {
        Test.startTest();
        
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Scheme__c scheme = SchemeTestDataHelper.getScheme();
        
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(
            incentivePlan.Id,
        branch.Id,
        partnerAccount.Id,
        null,
        null
            );
        
        dmpl__IncentiveCompensationLine__c compensationLine = IncentivePlanDataHelper.createCompensationLine(
            compensation.Id,
        incentivePlan.Id,
        scheme.Id
            );
        
        dmpl__IncentiveCompensationLine__c fetchedCompensationLine = IncentivePlanDataHelper.getCompensationLine(compensationLine.Id);
        
        Test.stopTest();
        
        System.assertEquals(compensation.Id, fetchedCompensationLine.dmpl__CompensationId__c, 'Compensation reference should match');
        System.assertEquals(incentivePlan.Id, fetchedCompensationLine.dmpl__IncentivePlanId__c, 'Incentive Plan reference should match');
        System.assertEquals(scheme.Id, fetchedCompensationLine.dmpl__SchemeId__c, 'Scheme reference should match');
        System.assertEquals(incentivePlan.Id, compensation.dmpl__IncentivePlanId__c, 'Compensation should reference the correct Incentive Plan');
        System.assertEquals(branch.Id, compensation.dmpl__BranchId__c, 'Compensation should reference the correct Branch');
        System.assertEquals(partnerAccount.Id, compensation.dmpl__PartnerAccountId__c, 'Compensation should reference the correct Partner Account');
    }
    
    //Compensation creation with Required Fields(Edit)
    @isTest
    static void updateCompensationLineWithRequiredFieldsPositive() {
        Test.startTest();
        
        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Scheme__c scheme = SchemeTestDataHelper.getScheme();
        
        dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(
            incentivePlan.Id,
        branch.Id,
        partnerAccount.Id,
        null,
        null
            );
        
        dmpl__IncentiveCompensation__c compensation1 = IncentivePlanDataHelper.createCompensation(
            incentivePlan.Id,
        branch1.Id,
        partnerAccount1.Id,
        null,
        null
            );
        
        dmpl__IncentiveCompensationLine__c compensationLine = IncentivePlanDataHelper.createCompensationLine(
            compensation.Id,
        incentivePlan.Id,
        scheme.Id
            );
        
        dmpl__IncentiveCompensationLine__c fetchedCompensationLine = IncentivePlanDataHelper.getCompensationLine(compensationLine.Id);
        fetchedCompensationLine.dmpl__CompensationId__c = compensation1.Id;
        update fetchedCompensationLine;
        
        dmpl__IncentiveCompensationLine__c updatedCompensationLine = IncentivePlanDataHelper.getCompensationLine(fetchedCompensationLine.Id);
        
        Test.stopTest();
        
        System.assertEquals(compensation1.Id, updatedCompensationLine.dmpl__CompensationId__c, 'Compensation Line should reference the updated Compensation record.');
        System.assertEquals(incentivePlan.Id, updatedCompensationLine.dmpl__IncentivePlanId__c, 'Incentive Plan should remain unchanged.');
        System.assertEquals(scheme.Id, updatedCompensationLine.dmpl__SchemeId__c, 'Scheme should remain unchanged.');
        System.assertEquals(branch1.Id, compensation1.dmpl__BranchId__c, 'Branch on compensation1 should be correct.');
        System.assertEquals(partnerAccount1.Id, compensation1.dmpl__PartnerAccountId__c, 'Partner Account on compensation1 should be correct.');
    }
    
}