public class IncentiveResourceProcessor implements Database.Batchable<SObject> {
    public static Integer BATCH_SIZE = 200;
    private Id invokedQueueId;
    private Id incentivePlanId;
    private String batchQuery;
    private String memberType;
    private String customerType;

    private static final string FIELD_INCENTIVEPLAN_MEMBERTYPE = 'dmpl__MemberType__c';
    private static final string MEMBERTYPE_PARTNER = 'Partner';
    private static final string MEMBERTYPE_BRANCH = 'Branch';
    private static final string MEMBERTYPE_RESOURCE = 'Resource';
    private static final string MEMBERTYPE_CUSTOMER = 'Customer';

    public IncentiveResourceProcessor(String query, Id queueId, Id planId, String memberType, String customerType) {
        this.batchQuery = query;
        this.invokedQueueId = queueId;
        this.incentivePlanId = planId;
        this.customerType = customerType;
        this.memberType = memberType;
    }

    public static JobResponseResult performAction(Id recordId, Id queueId) {
        try {
            return processIncentiveResource(recordId, queueId);
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static JobResponseResult processIncentiveResource(Id recordId, Id queueId) {
        dmpl__IncentivePlan__c plan = queryForIncentivePlan(recordId);
        Id batchId = Database.executeBatch(new IncentiveResourceProcessor(
            createResourceQuery(plan),
            queueId,
            recordId,
            plan.dmpl__MemberType__c,
            plan.dmpl__AccountGroupId__c != null ? 'AccountGroupMember' : 'Account'), BATCH_SIZE);
        return new JobResponseResult(true, null, 'Apex Batch Job Enqueued With Job Id ' + batchId);
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        try {
            InterfaceQueueHelper.addStatusUpdate(invokedQueueId, 'Starting Incentive Target Batch');
            System.debug('Starting Batch Query: ' + batchQuery);
            return Database.getQueryLocator(batchQuery);
        } catch (Exception error) {
            ExceptionLogHelper.logException(error, invokedQueueId);
            throw error;
        }
    }

    public void execute(Database.BatchableContext bc, List<SObject> scope) {
        if(this.memberType == MEMBERTYPE_PARTNER){
            createPartners(scope);
        }else if(this.memberType == MEMBERTYPE_BRANCH){
            createBranches(scope);
        }else if(this.memberType == MEMBERTYPE_RESOURCE){
            createResources(scope);
        }else if(this.memberType == MEMBERTYPE_CUSTOMER){
            if(this.customerType == 'Account'){
                createCustomers(scope);
            }else if(this.customerType == 'AccountGroupMember'){
                createAGCustomers(scope);
            }
        }
    }

    public void finish(Database.BatchableContext bc) {
        try {
            InterfaceQueueHelper.addStatusUpdate(invokedQueueId, 'Incentive Target Batch Completed');
        } catch (Exception error) {
            ExceptionLogHelper.logException(error, invokedQueueId);
        }
    }

    private static string createResourceQuery(dmpl__IncentivePlan__c plan){
        String memberType = plan.dmpl__MemberType__c;
        if(memberType == MEMBERTYPE_PARTNER){
            return createPartnersQuery(plan);
        }else if(memberType == MEMBERTYPE_BRANCH){
            return createBranchesQuery(plan);
        }else if(memberType == MEMBERTYPE_RESOURCE){
            return createResourcesQuery(plan);
        }else if(memberType == MEMBERTYPE_CUSTOMER){
            return createCustomersQuery(plan);
        }
        return null;
    }

    private static dmpl__IncentivePlan__c queryForIncentivePlan(Id incentivePlanId) {
        List<dmpl__IncentivePlan__c> plans = [SELECT 
               Id,
               Name,
               dmpl__SupplierAccountId__c,
               dmpl__AccountGroupId__c,
               dmpl__AccountId__c,
               dmpl__PartnerAccountId__c,
               dmpl__BranchId__c,
               dmpl__ValidFrom__c,
               dmpl__ValidTo__c,
               dmpl__MemberType__c,
               dmpl__MemberResourceType__c,
               dmpl__ResourceGroupId__c,
               dmpl__PartnerAccountGroupId__c
               FROM dmpl__IncentivePlan__c
               WHERE Id = :incentivePlanId];
        if(plans.size() > 0){
            return plans[0];
        }
        return null;
    }
    
    private static String createPartnersQuery(dmpl__IncentivePlan__c incentivePlan){
        SecurityHelper.ensureCanReadFields(new string[]{
            'Id',
            'Name'
        },'Account');
        
        String query = 'SELECT Id, Name FROM Account WHERE dmpl__IsPartnerAccount__c = true AND dmpl__IsActive__c = true';
        if(incentivePlan.dmpl__PartnerAccountId__c != null){
            query += ' AND Id = ' + '\'' + incentivePlan.dmpl__PartnerAccountId__c + '\'';
        }
        if(incentivePlan.dmpl__PartnerAccountGroupId__c != null){
            query += ' AND Id IN (SELECT dmpl__AccountId__c FROM dmpl__AccountGroupMember__c WHERE dmpl__AccountGroupId__c = ' + '\'' + incentivePlan.dmpl__PartnerAccountGroupId__c + '\'' + ')';
        }
        return query;
    }

    private void createPartners(List<SObject> scope){
        List<dmpl__IncentiveResource__c> resources = new List<dmpl__IncentiveResource__c>();
        for(SObject partner : scope){
            resources.add(new dmpl__IncentiveResource__c(
                Name = (String)partner.get('Name'), 
                dmpl__IncentivePlanId__c = incentivePlanId,
                dmpl__PartnerAccountId__c = partner.Id
            ));
        }    
        SecurityHelper.ensureCanCreateFields(new List<String>
        {
            'Name',
            'dmpl__IncentivePlanId__c',
            'dmpl__PartnerAccountId__c'
        }, 'dmpl__IncentiveResource__c');
        
        insert resources;
    }

    private static String createBranchesQuery(dmpl__IncentivePlan__c incentivePlan){
        SecurityHelper.ensureCanReadFields(new string[]{
            'Id',
            'Name',
            'dmpl__PartnerAccountId__c'
        },'dmpl__Branch__c');
        String query = 'SELECT Id, Name, dmpl__PartnerAccountId__c FROM dmpl__Branch__c WHERE dmpl__IsActive__c = true ';
        if(incentivePlan.dmpl__PartnerAccountId__c != null){
            query += 'AND dmpl__PartnerAccountId__c = ' + '\'' + incentivePlan.dmpl__PartnerAccountId__c + '\'';
        }
        if(incentivePlan.dmpl__PartnerAccountGroupId__c != null){
            query += 'AND dmpl__PartnerAccountId__c IN (SELECT dmpl__AccountId__c FROM dmpl__AccountGroupMember__c WHERE dmpl__AccountGroupId__c = ' + '\'' + incentivePlan.dmpl__PartnerAccountGroupId__c + '\'' + ')';
        }
        return query;
    }

    private void createBranches(List<SObject> scope){
        List<dmpl__IncentiveResource__c> resources = new List<dmpl__IncentiveResource__c>();        
        for(SObject branch : scope){
            resources.add(new dmpl__IncentiveResource__c(
                Name = (String)branch.get('Name'), 
                dmpl__IncentivePlanId__c = incentivePlanId,
                dmpl__PartnerAccountId__c = (Id)branch.get('dmpl__PartnerAccountId__c'),
                dmpl__BranchId__c = branch.Id
            ));
        }    
        SecurityHelper.ensureCanCreateFields(new List<String>
        {
            'Name',
            'dmpl__IncentivePlanId__c',
            'dmpl__PartnerAccountId__c',
            'dmpl__BranchId__c'
        }, 'dmpl__IncentiveResource__c');
        
        insert resources;
    }

    private static String createResourcesQuery(dmpl__IncentivePlan__c incentivePlan){
        SecurityHelper.ensureCanReadFields(new string[]{
            'Name',
            'dmpl__Type__c',
            'dmpl__DefaultPartnerAccountId__c',
            'dmpl__DefaultBranchId__c'
        },'dmpl__Resource__c');
        String query = 'SELECT Id, Name, dmpl__Type__c, dmpl__DefaultPartnerAccountId__c, dmpl__DefaultBranchId__c FROM dmpl__Resource__c WHERE dmpl__IsActive__c = true ';
        if(incentivePlan.dmpl__MemberResourceType__c != null){
            query += ' AND  dmpl__Type__c = ' + '\'' + incentivePlan.dmpl__MemberResourceType__c + '\'';
        }
        if(incentivePlan.dmpl__ResourceGroupId__c != null){
            query += ' AND Id IN (SELECT dmpl__ResourceId__c FROM dmpl__ResourceGroupMember__c WHERE dmpl__ResourceGroupId__c = ' + '\'' + incentivePlan.dmpl__ResourceGroupId__c + '\'' + ')';
        }
        return query;
    }

    private void createResources(List<SObject> scope){
        List<dmpl__IncentiveResource__c> incentiveResources = new List<dmpl__IncentiveResource__c>();
        for(SObject resource : scope){
            incentiveResources.add(new dmpl__IncentiveResource__c(
                Name = (String)resource.get('Name'), 
                dmpl__IncentivePlanId__c = incentivePlanId,
                dmpl__PartnerAccountId__c = (Id)resource.get('dmpl__DefaultPartnerAccountId__c'),
                dmpl__BranchId__c = (Id)resource.get('dmpl__DefaultBranchId__c'),
                dmpl__ResourceId__c = resource.Id
            ));
        }    
        SecurityHelper.ensureCanCreateFields(new List<String>
        {
            'Name',
            'dmpl__IncentivePlanId__c',
            'dmpl__PartnerAccountId__c',
            'dmpl__BranchId__c',
            'dmpl__ResourceId__c'
        }, 'dmpl__IncentiveResource__c');
        
        insert incentiveResources;
    }

    @testVisible
    private static String createCustomersQuery(dmpl__IncentivePlan__c incentivePlan){
        Id accountGroupId = incentivePlan.dmpl__AccountGroupId__c;
        if(accountGroupId == null){
            return 'SELECT Id, Name FROM Account WHERE dmpl__IsCustomerAccount__c = true AND dmpl__IsActive__c = true';
        }else {
            SecurityHelper.ensureCanReadFields(new string[]{
                'Id',
                'Name',
                'dmpl__AccountId__c',
                'dmpl__AccountGroupId__c'
            },'dmpl__AccountGroupMember__c');
            return 'SELECT Id, dmpl__AccountId__r.Name, dmpl__AccountId__c, dmpl__AccountGroupId__c,dmpl__AccountGroupId__r.Name ' +
                'FROM dmpl__AccountGroupMember__c ' +
                'WHERE dmpl__AccountGroupId__c = ' + '\'' + incentivePlan.dmpl__AccountGroupId__c + '\'';
        }
    }

    @testVisible
    private void createAGCustomers(List<SObject> scope){
        List<dmpl__IncentiveResource__c> resources = new List<dmpl__IncentiveResource__c>();
        for(SObject accountGroupMember : scope){
            resources.add(new dmpl__IncentiveResource__c(
                Name = (String)accountGroupMember.getSobject('dmpl__AccountId__r')?.get('Name'),
                dmpl__IncentivePlanId__c = incentivePlanId,
                dmpl__AccountId__c = (Id)accountGroupMember.get('dmpl__AccountId__c')
            ));
        }    
        SecurityHelper.ensureCanCreateFields(new List<String>
        {
            'Name',
            'dmpl__IncentivePlanId__c',
            'dmpl__AccountId__c'
        }, 'dmpl__IncentiveResource__c');
        
        insert resources;
    }

    @testVisible
    private void createCustomers(List<SObject> scope){
        List<dmpl__IncentiveResource__c> resources = new List<dmpl__IncentiveResource__c>();
        for(SObject account : scope){
            resources.add(new dmpl__IncentiveResource__c(
                Name = (String)account.get('Name'), 
                dmpl__IncentivePlanId__c = incentivePlanId,
                dmpl__AccountId__c = account.Id
            ));
        }    
        SecurityHelper.ensureCanCreateFields(new List<String>
        {
            'Name',
            'dmpl__IncentivePlanId__c',
            'dmpl__AccountId__c'
        }, 'dmpl__IncentiveResource__c');
        
        insert resources;
    }
}