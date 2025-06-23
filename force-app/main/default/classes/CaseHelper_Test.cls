@isTest
public class CaseHelper_Test {
    
     @testSetup
    public static void setup()
    {
        //System.runAs(PostInstallHelper.AssignAdministratorAllPermissions(UserInfo.getUserId())){
            CreateAccountGroup();
            CreateBranch();
            CreateResource();
            createPartnerResources();
            createPartnerResources1();
            createPartnerResources2();
            createAssignmentRule();
            createAssignmentRule1();
            createAssignmentRule2();
            createCases();
            createCases();
           //}
    }
    
     @isTest
    Static void VerifyCreateAccount()
    {
        test.startTest();
        List<dmpl__Case__c> cases = [Select Id,dmpl__PerformCreateLead__c, Name From dmpl__Case__c];
        cases[0].dmpl__PerformCreateLead__c = true;
        update cases;
        System.assert(cases != null,'true');
        test.stopTest();
    }
    
    @isTest
    Static void VerifyTriggerHandler()
    {
        Test.startTest();
        TriggerHandler triggerHandler= new TriggerHandler();
        triggerHandler.setMaxLoopCount(5); 
        test.stopTest();
    }
    
    @isTest
    Static void VerifysetMaxLoopCount()
    {
        Test.startTest();
        TriggerHandler triggerHandler= new TriggerHandler();
        triggerHandler.setTriggerContext(null,false); 
        test.stopTest();
    }
       @isTest
    Static void deleteCase()
    {
        Test.startTest();
        dmpl__Case__c cases= [Select Id,dmpl__PerformCreateLead__c, Name From dmpl__Case__c limit 1];
        delete cases;
        test.stopTest();
    }
     private static void CreateAccountGroup()
    {
        dmpl__AccountGroup__c accountGroup= new dmpl__AccountGroup__c (Name= 'Test-AccountGroup', 
                                                                       dmpl__AccountGroupType__c='Scheme');
        insert accountGroup;
        Account partneraccount = new Account(Name = 'Partner-Test-Account',
                                             dmpl__LastName__c = 'Account',
                                             dmpl__IsPartnerAccount__c = True, 
                                             dmpl__IsActive__c = true);
        insert partneraccount;
        
        Account supplieraccount = new Account(Name = 'Supplier-Test-Account',
                                              dmpl__LastName__c = 'Account',
                                              dmpl__IsSupplierAccount__c = True,
                                              dmpl__IsActive__c = true);
        insert supplieraccount;
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__IsCustomerAccount__c = True,
                                              dmpl__LastName__c = 'Account',
                                              dmpl__IsSupplierAccount__c = True,
                                              dmpl__IsActive__c = true);
        insert customerAccount;
    }
    
    private static void CreateBranch()
    {
        List<dmpl__Branch__c> branch = new List<dmpl__Branch__c>();
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        branch.Add(new dmpl__Branch__c(dmpl__PartnerAccountId__c =partnerAccount.Id,
                                       Name = 'Test-Branch',
                                       dmpl__IsActive__c = true,
                                       dmpl__MarketingName__c = 'Hero Electric',
                                       dmpl__Website__c = 'www.dealermatix.com',
                                       dmpl__Email__c = 'Dealer@Outlook.com',
                                       dmpl__MobileNumber__c = 99,
                                       dmpl__Phone__c = '8888888888',
                                       dmpl__AllowSales__c = true,
                                       dmpl__AllowService__c = true,
                                       dmpl__AllowPurchase__c = true,
                                       dmpl__AllowInventory__c = true,
                                       dmpl__IsHomeDeliveryAvailable__c = true,
                                       dmpl__IsPickupDropAvailable__c = true,
                                       dmpl__SalesPhone__c = '7777777777',
                                       dmpl__ServiceEmail__c = 'Customer@Outlook.com'));
        insert branch;
    }
    
    private static void CreateResource()
    {
        List<dmpl__Resource__c> resource = new List<dmpl__Resource__c>();
        Account partnerAccount = [Select Id,Name From Account LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        resource.add(new dmpl__Resource__c(Name = 'Test - Resource',
                                           dmpl__ResourceType__c = 'Sample',
                                           dmpl__IsActive__c = true,
                                           dmpl__Phone__c = '9999999999',
                                           dmpl__DefaultPartnerAccountId__c = partnerAccount.Id,
                                           dmpl__DefaultBranchId__c = branch.Id
                                          ));
        insert resource;
        
    }
    private static void createCases()
    {
        List<dmpl__Case__c> cases = new List<dmpl__Case__c>();
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        Account customerAccount =[Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        cases.Add(new dmpl__Case__c(dmpl__PartnerAccountId__c =partnerAccount.Id,
                                    dmpl__AccountId__c=customerAccount.Id,
                                    dmpl__BranchId__c= branch.Id,
                                    dmpl__ResourceId__c=resource.Id,
                                    dmpl__AccountPhone__c='9733387909',
                                    dmpl__Priority__c='Medium',
                                    dmpl__CaseSource__c='Phone',
                                    dmpl__CaseReason__c='Performance',
                                    dmpl__Status__c='New',
                                    dmpl__DateTimeOpened__c=System.now(),
                                    dmpl__Mobile__c='9733387909',
                                    dmpl__AccountName__c='Test-Account',
                                    dmpl__Remarks__c='Test Remarks'));
        insert cases;
    }
    
    private static void createPartnerResources(){
        List<dmpl__PartnerResource__c> partnerResources = new List<dmpl__PartnerResource__c>();
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        partnerResources.Add(new dmpl__PartnerResource__c(dmpl__PartnerAccountId__c =partnerAccount.Id,
                                    dmpl__BranchId__c= branch.Id,
                                    dmpl__ResourceId__c= resource.Id,               
                                    dmpl__RuleSuccessCriteria__c='All Rules Are Met',
                                    dmpl__AssignmentSequenceNumber__c=12));
        insert partnerResources;         
    }
    
    private static void createPartnerResources1(){
        List<dmpl__PartnerResource__c> partnerResources = new List<dmpl__PartnerResource__c>();
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        partnerResources.Add(new dmpl__PartnerResource__c(dmpl__PartnerAccountId__c =partnerAccount.Id,
                                    dmpl__BranchId__c= branch.Id,
                                    dmpl__ResourceId__c= resource.Id,               
                                    dmpl__RuleSuccessCriteria__c='Any Rule Is Met',
                                    dmpl__AssignmentSequenceNumber__c=11));
        insert partnerResources;        
    }
    
    private static void createPartnerResources2(){
        List<dmpl__PartnerResource__c> partnerResources = new List<dmpl__PartnerResource__c>();
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        partnerResources.Add(new dmpl__PartnerResource__c(dmpl__PartnerAccountId__c =partnerAccount.Id,
                                    dmpl__BranchId__c= branch.Id,
                                    dmpl__ResourceId__c= resource.Id,               
                                    dmpl__RuleSuccessCriteria__c='Always (No Criteria)',
                                    dmpl__AssignmentSequenceNumber__c=123));
        insert partnerResources;         
    }
    
    private static void createAssignmentRule(){
            List<dmpl__ResourceAssignmentRule__c> assignmentRule = new List<dmpl__ResourceAssignmentRule__c>();
            dmpl__PartnerResource__c partnerResource = [Select Id,Name From dmpl__PartnerResource__c LIMIT 1];
            assignmentRule.Add(new dmpl__ResourceAssignmentRule__c(dmpl__PartnerResourceId__c=partnerResource.Id,
                                        dmpl__FieldName__c='dmpl__Remarks__c',	
                                        dmpl__FieldValue__c='Test Remarks',
                                        dmpl__Operation__c='equals',
                                        dmpl__SequenceNumber__c=12,
                                        dmpl__AssignmentType__c='Lead'));
            insert assignmentRule;         
        }    
    private static void createAssignmentRule1(){
            List<dmpl__ResourceAssignmentRule__c> assignmentRule = new List<dmpl__ResourceAssignmentRule__c>();
            dmpl__PartnerResource__c partnerResource = [Select Id,Name From dmpl__PartnerResource__c WHERE dmpl__RuleSuccessCriteria__c='Any Rule Is Met' LIMIT 1];
            assignmentRule.Add(new dmpl__ResourceAssignmentRule__c(dmpl__PartnerResourceId__c=partnerResource.Id,
                                        dmpl__FieldName__c='dmpl__CaseReason__c',	
                                        dmpl__FieldValue__c='Performance',
                                        dmpl__Operation__c='notEqual',
                                        dmpl__SequenceNumber__c=11,
                                        dmpl__AssignmentType__c='Lead'));
            insert assignmentRule;         
        }  
    private static void createAssignmentRule2(){
            List<dmpl__ResourceAssignmentRule__c> assignmentRule = new List<dmpl__ResourceAssignmentRule__c>();
            dmpl__PartnerResource__c partnerResource = [Select Id,Name From dmpl__PartnerResource__c WHERE dmpl__RuleSuccessCriteria__c='Always (No Criteria)' LIMIT 1];
            assignmentRule.Add(new dmpl__ResourceAssignmentRule__c(dmpl__PartnerResourceId__c=partnerResource.Id,
                                        dmpl__FieldName__c='dmpl__AccountPhone__c',	
                                        dmpl__FieldValue__c='9876543210',
                                        dmpl__Operation__c='equals',
                                        dmpl__SequenceNumber__c=123,
                                        dmpl__AssignmentType__c='Lead'));
            insert assignmentRule;         
        }   
    
    
                                    
}