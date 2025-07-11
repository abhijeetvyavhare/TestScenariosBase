@isTest
public class ServiceCampignHandler_Test {

	@isTest
    static void CreateCampaignCreationWithCampaignName() {
    Date startDate = Date.newInstance(2025, 6, 10);
    Date endDate = Date.newInstance(2025, 7, 30);


    Test.startTest();
    dmpl__ServiceCampaign__c serviceCampaign1 = CampaignTestDataHelpers.createServiceCampaign(
    'Campaign 1',
    'Field Filter',
    null,
    null,
    'All Rules Are Met',
    'Marketing',
    startDate,
    endDate
    );
    Test.stopTest();

    dmpl__ServiceCampaign__c serviceCampaign = CampaignTestDataHelpers.getServiceCampaignById(serviceCampaign1.Id);

    System.assertNotEquals(null, serviceCampaign, 'Service Campaign should be retrieved');
    System.assertEquals('Campaign 1', serviceCampaign.Name, 'Name should be Campaign 1');
    System.assertEquals('Field Filter', serviceCampaign.dmpl__DynamicMemberType__c, 'Dynamic Member should be Field Filter');
    System.assertEquals('Marketing', serviceCampaign.dmpl__Type__c, 'Type should be Marketing');
    System.assertEquals('All Rules Are Met', serviceCampaign.dmpl__RuleSuccessCriteria__c, 'Rule criteria should match');
    System.assertEquals(startDate, serviceCampaign.dmpl__StartDate__c, 'Start date should match');
    System.assertEquals(endDate, serviceCampaign.dmpl__EndDate__c, 'End date should match');
    }


@isTest
static void UpdateCampaignCreationWithCampaignName() {

    Date startDate = Date.newInstance(2025, 6, 10);
    Date endDate = Date.newInstance(2025, 7, 30);

    dmpl__ServiceCampaign__c createdCampaign = CampaignTestDataHelpers.createServiceCampaign(
        'Campaign 1',
        'Field Filter',
        null,
        null,
        'All Rules Are Met',
        'Marketing',
        startDate,
        endDate
    );

    
    dmpl__ServiceCampaign__c serviceCampaign = CampaignTestDataHelpers.getServiceCampaignById(createdCampaign.Id);

    Date startDateUpdated = Date.newInstance(2025, 5, 30);
    Date endDateUpdated = Date.newInstance(2025, 6, 10);

    serviceCampaign.Name = 'Campaign 2';
    serviceCampaign.dmpl__Type__c = 'Service';
    serviceCampaign.dmpl__StartDate__c = startDateUpdated;
    serviceCampaign.dmpl__EndDate__c = endDateUpdated;
    serviceCampaign.dmpl__Status__c = 'Start';

    update serviceCampaign;

    
    System.assertEquals('Campaign 2', serviceCampaign.Name, 'Name should be Campaign 2');
    System.assertEquals('Field Filter', serviceCampaign.dmpl__DynamicMemberType__c, 'Dynamic Member Type should be Field Filter');
    System.assertEquals('All Rules Are Met', serviceCampaign.dmpl__RuleSuccessCriteria__c, 'Rule Success Criteria should be All Rules Are Met');
    System.assertEquals(startDateUpdated, serviceCampaign.dmpl__StartDate__c, 'Start Date should be 5/30/2025');
    System.assertEquals(endDateUpdated, serviceCampaign.dmpl__EndDate__c, 'End Date should be 6/10/2025');
    System.assertEquals('Start', serviceCampaign.dmpl__Status__c, 'Status should be Start');
    System.assertEquals('Service', serviceCampaign.dmpl__Type__c, 'Type should be Service');
    }
    
    @isTest
    static void CreateCampaignCreationWithParentServiceContract() {
    
    Date startDate = Date.newInstance(2025, 5, 30);
    Date endDate = Date.newInstance(2025, 6, 10);

    dmpl__ServiceCampaign__c parent = CampaignTestDataHelpers.createServiceCampaign(
        'Campaign 1',
        null,           
        null,
        null,
        null,
        'Marketing',
        startDate,
        endDate
    );

    
    dmpl__ServiceCampaign__c child = CampaignTestDataHelpers.createServiceCampaign(
        'Campaign 2',
        'Field Filter',                  
        parent.Id,                      
        null,                           
        'All Rules Are Met',            
        'Service',                   
        startDate,
        endDate
    );

    dmpl__ServiceCampaign__c fetched = CampaignTestDataHelpers.getServiceCampaignById(child.Id);


    System.assertEquals('Campaign 2', fetched.Name, 'Name should be Campaign 2');
    System.assertEquals(parent.Id, fetched.dmpl__ParentServiceCampaignId__c, 'Parent Campaign should match');
    System.assertEquals('Field Filter', fetched.dmpl__DynamicMemberType__c, 'Dynamic Member Type should be Field Filter');
    System.assertEquals('All Rules Are Met', fetched.dmpl__RuleSuccessCriteria__c, 'Rule Success Criteria should match');
    System.assertEquals('Service', fetched.dmpl__Type__c, 'Type should be Service');
    System.assertEquals(startDate, fetched.dmpl__StartDate__c, 'Start Date should be 5/30/2025');
    System.assertEquals(endDate, fetched.dmpl__EndDate__c, 'End Date should be 6/10/2025');
}


    @isTest
    static void UpdateCampaigncreationwithParentServiceContract(){
    Date originalStartDate = Date.newInstance(2025, 5, 30);
    Date originalEndDate = Date.newInstance(2025, 6, 10);

    dmpl__ServiceCampaign__c parent = CampaignTestDataHelpers.createServiceCampaign(
        'Campaign 1',
        'Field Filter',   // dummy dynamic type for now
        null,
        null,
        null,
        'Service',
        originalStartDate,
        originalEndDate
    );


    // Step 2: Create child Campaign 2 with Campaign 1 as parent
    dmpl__ServiceCampaign__c child = CampaignTestDataHelpers.createServiceCampaign(
        'Campaign 2',
        'Field Filter',
        parent.Id,
        null,
        'All Rules Are Met',
        'Marketing',
        originalStartDate,
        originalEndDate
    );

    dmpl__ServiceCampaign__c createdChild = CampaignTestDataHelpers.getServiceCampaignById(child.Id);

    System.assertEquals('Campaign 2', createdChild.Name);
    System.assertEquals(parent.Id, createdChild.dmpl__ParentServiceCampaignId__c);
    System.assertEquals('Field Filter', createdChild.dmpl__DynamicMemberType__c);
    System.assertEquals('All Rules Are Met', createdChild.dmpl__RuleSuccessCriteria__c);
    System.assertEquals(originalStartDate, createdChild.dmpl__StartDate__c);
    System.assertEquals(originalEndDate, createdChild.dmpl__EndDate__c);
    System.assertEquals('Marketing', createdChild.dmpl__Type__c);

    Date updatedStartDate = Date.newInstance(2025, 6, 10);
    Date updatedEndDate = Date.newInstance(2025, 7, 30);

    parent.Name = 'Campaign 1';
    parent.dmpl__ParentServiceCampaignId__c = child.Id;
    parent.dmpl__DynamicMemberType__c = 'Field Filter';
    parent.dmpl__RuleSuccessCriteria__c = 'All Rules Are Met';
    parent.dmpl__StartDate__c = updatedStartDate;
    parent.dmpl__EndDate__c = updatedEndDate;
    parent.dmpl__Type__c = 'Marketing';

    update parent;

    dmpl__ServiceCampaign__c updatedParent = CampaignTestDataHelpers.getServiceCampaignById(parent.Id);

    System.assertEquals('Campaign 1', updatedParent.Name);
    System.assertEquals(child.Id, updatedParent.dmpl__ParentServiceCampaignId__c, 'Parent should now be Campaign 2');
    System.assertEquals('Field Filter', updatedParent.dmpl__DynamicMemberType__c);
    System.assertEquals('All Rules Are Met', updatedParent.dmpl__RuleSuccessCriteria__c);
    System.assertEquals(updatedStartDate, updatedParent.dmpl__StartDate__c);
    System.assertEquals(updatedEndDate, updatedParent.dmpl__EndDate__c);
    System.assertEquals('Marketing', updatedParent.dmpl__Type__c);
    }


    @isTest
    static void CreateCampaignCreationWithoutParentServiceContract(){
    Date startDate = Date.newInstance(2025, 6, 10);
    Date endDate = Date.newInstance(2025, 7, 30);

    dmpl__ServiceCampaign__c campaign = CampaignTestDataHelpers.createServiceCampaign(
        'Campaign 1',                    
        'Field Filter',                 
        null,                           
        null,                           
        'All Rules Are Met',            
        'Marketing',                    
        startDate,                     
        endDate                        
    );

    
    dmpl__ServiceCampaign__c fetched = CampaignTestDataHelpers.getServiceCampaignById(campaign.Id);

    System.assertEquals('Campaign 1', fetched.Name, 'Name should be Campaign 1');
    System.assertEquals(null, fetched.dmpl__ParentServiceCampaignId__c, 'Parent Campaign should be null');
    System.assertEquals('Marketing', fetched.dmpl__Type__c, 'Type should be Marketing');
    System.assertEquals('Field Filter', fetched.dmpl__DynamicMemberType__c, 'Dynamic Member Type should be Field Filter');
    System.assertEquals('All Rules Are Met', fetched.dmpl__RuleSuccessCriteria__c, 'Rule Criteria should be All Rules Are Met');
    System.assertEquals(startDate, fetched.dmpl__StartDate__c, 'Start Date should be 6/10/2025');
    System.assertEquals(endDate, fetched.dmpl__EndDate__c, 'End Date should be 7/30/2025');
    }

    @isTest
    static void CreateCampaigncreationwithItemServiceContract() {
    Date startDate = Date.newInstance(2025, 6, 10);
    Date endDate = Date.newInstance(2025, 7, 30);


    dmpl__ItemServiceContract__c contract = new dmpl__ItemServiceContract__c(Name = 'Service Contract 1');



    dmpl__ServiceCampaign__c campaign = CampaignTestDataHelpers.createServiceCampaign(
        'Campaign 1',
        'Field Filter',                 
        null,                          
        contract.Id,                    
        'All Rules Are Met',            
        'Marketing',                    
        startDate,
        endDate
    );

    dmpl__ServiceCampaign__c fetched = CampaignTestDataHelpers.getServiceCampaignById(campaign.Id);

    System.assertEquals('Campaign 1', fetched.Name, 'Name should be Campaign 1');
    System.assertEquals(contract.Id, fetched.dmpl__ItemServiceContractId__c, 'Item Service Contract should match');
    System.assertEquals('Field Filter', fetched.dmpl__DynamicMemberType__c, 'Dynamic Member Type should be Field Filter');
    System.assertEquals('All Rules Are Met', fetched.dmpl__RuleSuccessCriteria__c, 'Rule Criteria should be All Rules Are Met');
    System.assertEquals('Marketing', fetched.dmpl__Type__c, 'Type should be Marketing');
    System.assertEquals(startDate, fetched.dmpl__StartDate__c, 'Start Date should be 6/10/2025');
    System.assertEquals(endDate, fetched.dmpl__EndDate__c, 'End Date should be 7/30/2025');
    }

    @isTest
    static void UpdateCampaigncreationwithItemServiceContract(){
    Date startDate = Date.newInstance(2025, 6, 10);
    Date endDate = Date.newInstance(2025, 7, 30);


    dmpl__ItemServiceContract__c contract1 = new dmpl__ItemServiceContract__c(Name = 'Service Contract 1');


    dmpl__ItemServiceContract__c contract2 = new dmpl__ItemServiceContract__c(Name = 'Service Contract 2');


    dmpl__ServiceCampaign__c campaign = CampaignTestDataHelpers.createServiceCampaign(
        'Campaign 1',
        'Field Filter',                
        null,                          
        contract1.Id,                  
        'All Rules Are Met',           
        'Marketing',                  
        startDate,
        endDate
    );


    dmpl__ServiceCampaign__c created = CampaignTestDataHelpers.getServiceCampaignById(campaign.Id);
    System.assertEquals('Campaign 1', created.Name);
    System.assertEquals(contract1.Id, created.dmpl__ItemServiceContractId__c, 'Initial Item Service Contract should be Contract 1');
    System.assertEquals('Field Filter', created.dmpl__DynamicMemberType__c);
    System.assertEquals('All Rules Are Met', created.dmpl__RuleSuccessCriteria__c);
    System.assertEquals('Marketing', created.dmpl__Type__c);
    System.assertEquals(startDate, created.dmpl__StartDate__c);
    System.assertEquals(endDate, created.dmpl__EndDate__c);

    
    campaign.dmpl__ItemServiceContractId__c = contract2.Id;
    update campaign;

    dmpl__ServiceCampaign__c updated = CampaignTestDataHelpers.getServiceCampaignById(campaign.Id);
    System.assertEquals('Campaign 1', updated.Name);
    System.assertEquals(contract2.Id, updated.dmpl__ItemServiceContractId__c, 'Updated Item Service Contract should be Contract 2');
    System.assertEquals('Field Filter', updated.dmpl__DynamicMemberType__c);
    System.assertEquals('All Rules Are Met', updated.dmpl__RuleSuccessCriteria__c);
    System.assertEquals('Marketing', updated.dmpl__Type__c);
    System.assertEquals(startDate, updated.dmpl__StartDate__c);
    System.assertEquals(endDate, updated.dmpl__EndDate__c);


    }

    @isTest
    static void CreateCampaignCreationWithoutItemServiceContract() {
    Date startDate = Date.newInstance(2025, 6, 10);
    Date endDate = Date.newInstance(2025, 7, 30);

    dmpl__ServiceCampaign__c campaign = CampaignTestDataHelpers.createServiceCampaign(
        'Campaign 1',
        'Field Filter',
        null,
        null,
        'All Rules Are Met',
        'Marketing',
        startDate,
        endDate
    );

    dmpl__ServiceCampaign__c fetched = CampaignTestDataHelpers.getServiceCampaignById(campaign.Id);

    System.assertEquals('Campaign 1', fetched.Name);
    System.assertEquals(null, fetched.dmpl__ItemServiceContractId__c);
    System.assertEquals('Field Filter', fetched.dmpl__DynamicMemberType__c);
    System.assertEquals('All Rules Are Met', fetched.dmpl__RuleSuccessCriteria__c);
    System.assertEquals('Marketing', fetched.dmpl__Type__c);
    System.assertEquals(startDate, fetched.dmpl__StartDate__c);
    System.assertEquals(endDate, fetched.dmpl__EndDate__c);
}
    
}