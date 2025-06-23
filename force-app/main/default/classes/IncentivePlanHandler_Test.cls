@isTest
public with sharing class IncentivePlanHandler_Test {
    @TestSetup
    static void createRequiredData() {
        dmpl__AccountGroup__c accountGroup = TestDataHelpers.createAccountGroup();
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account supplierAccount = TestDataHelpers.createSupplierAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2', false, true, false, true, '45 Residency Road', 'Pune', 'Maharashtra', 'India', '411001', '22 Commerce Avenue', 'Pune', 'Maharashtra', 'India', '411038','91-99665544433');
        dmpl__Scheme__c scheme1 = SchemeTestDataHelper.createScheme(
            'Scheme 1',
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
        
        IncentivePlanDataHelper.createIncentiveResource(
            plan.Id,
        resource.Id,
        partnerAccount.Id,
        branch.Id
            );
        
        IncentivePlanDataHelper.createIncentiveLine(
            plan.Id,
        'Test Line',
        'All',
        'All',
        1,
        false
            );
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
    static void createCompensationWithoutPartnerAccountNegative() {
        Boolean exceptionThrown = false;
        
        Test.startTest();
        try {
            dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
            dmpl__Branch__c branch = TestDataHelpers.getBranch();
            
            dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(
                incentivePlan.Id,
            branch.Id,
            null,  // Partner Account is null
            null,
            null
                );
            
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        
        System.assertEquals(true, exceptionThrown, 'DmlException should be thrown when Partner Account is missing');
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
    static void createCompensationWithoutPartnerAccountNegative() {
        Boolean exceptionThrown = false;
        
        Test.startTest();
        try {
            dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.getIncentivePlan();
            Account partnerAccount = TestDataHelpers.getPartnerAccount();
            
            dmpl__IncentiveCompensation__c compensation = IncentivePlanDataHelper.createCompensation(
                incentivePlan.Id,
            null,
            partnerAccount.Id,
            null,
            null
                );
            
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        
        System.assertEquals(true, exceptionThrown, 'DmlException should be thrown when branch is missing');
    }
    
    //Compensation creation with Incentive Plan(New)
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
    static void createCompensationWithoutPartnerAccountNegative() {
        Boolean exceptionThrown = false;
        
        Test.startTest();
        try {
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
            
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        
        System.assertEquals(true, exceptionThrown, 'DmlException should be thrown when branch is missing');
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
        
        System.assertEquals(compensation.Id, fetchedCompensationLine.dmpl__IncentiveCompensationId__c, 'Compensation reference should match');
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
        
        System.assertEquals(compensation.Id, updatedCompensationLine.dmpl__IncentiveCompensationId__c, 'Compensation reference should match');
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
        try {
            dmpl__IncentiveCompensationLine__c compensationLine = IncentivePlanDataHelper.createCompensationLine(
                compensation.Id,
            incentivePlan.Id,
            null
                );
        }catch (DmlException e) {
            exceptionThrown = true;
            System.debug('Expected exception caught: ' + e.getMessage());
        }
        
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
        
        System.assertEquals(compensation.Id, fetchedCompensationLine.dmpl__IncentiveCompensationId__c, 'Compensation reference should match');
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
        System.assertEquals(compensation.Id, updatedCompensationLine.dmpl__IncentiveCompensation__c, 'Compensation should remain unchanged.');
        System.assertEquals(scheme.Id, updatedCompensationLine.dmpl__Scheme__c, 'Scheme should remain unchanged.');
        System.assertNotEquals(null, updatedCompensationLine.Id, 'Compensation Line should exist.');
        System.assertEquals('Yearly', plan1.dmpl__PlanFrequency__c, 'Plan frequency should be Yearly.');
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
        try{
            dmpl__IncentiveCompensationLine__c compensationLine = IncentivePlanDataHelper.createCompensationLine(
                compensation.Id,
            null,
            scheme.Id
                );
        } catch (DmlException e) {
            exceptionThrown = true;
            System.debug('Expected exception caught: ' + e.getMessage());
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown when Incentive Plan is missing.');
        
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
        
        System.assertEquals(compensation.Id, fetchedCompensationLine.dmpl__IncentiveCompensationId__c, 'Compensation reference should match');
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
        fetchedCompensationLine.dmpl__IncentiveCompensationId__c = compensation1.Id;
        update fetchedCompensationLine;
        
        dmpl__IncentiveCompensationLine__c updatedCompensationLine = IncentivePlanDataHelper.getCompensationLine(fetchedCompensationLine.Id);
        
        Test.stopTest();
        
        System.assertEquals(compensation1.Id, updatedCompensationLine.dmpl__IncentiveCompensationId__c, 'Compensation Line should reference the updated Compensation record.');
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
        
        System.assertEquals(compensation.Id, fetchedCompensationLine.dmpl__IncentiveCompensationId__c, 'Compensation reference should match');
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
        fetchedCompensationLine.dmpl__IncentiveCompensationId__c = compensation1.Id;
        update fetchedCompensationLine;
        
        dmpl__IncentiveCompensationLine__c updatedCompensationLine = IncentivePlanDataHelper.getCompensationLine(fetchedCompensationLine.Id);
        
        Test.stopTest();
        
        System.assertEquals(compensation1.Id, updatedCompensationLine.dmpl__IncentiveCompensationId__c, 'Compensation Line should reference the updated Compensation record.');
        System.assertEquals(incentivePlan.Id, updatedCompensationLine.dmpl__IncentivePlanId__c, 'Incentive Plan should remain unchanged.');
        System.assertEquals(scheme.Id, updatedCompensationLine.dmpl__SchemeId__c, 'Scheme should remain unchanged.');
        System.assertEquals(branch1.Id, compensation1.dmpl__BranchId__c, 'Branch on compensation1 should be correct.');
        System.assertEquals(partnerAccount1.Id, compensation1.dmpl__PartnerAccountId__c, 'Partner Account on compensation1 should be correct.');
    }
    
    
}