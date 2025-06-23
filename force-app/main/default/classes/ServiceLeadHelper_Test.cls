@isTest
public class ServiceLeadHelper_Test {
    
     @testSetup
    public static void setup()
    {
        System.runAs(PostInstallHelper.AssignAdministratorAllPermissions(UserInfo.getUserId())){
            CreateAccountGroup();
            CreateBranch();
            CreateResource();
            createPartnerResources();
            createPartnerResources1();
            createPartnerResources2();
            createAssignmentRule();
            createAssignmentRule1();
            createAssignmentRule2();
            CreateServiceLead();
            createCases();
           }
    }

    
    @isTest
    private static void VerifyConvertLeadFromCase()
    {	
        try{	
            ServiceLeadController.getLeadConvertStatus();
            List<Contact> contact = [Select Id,Name From Contact LIMIT 1];
            List<dmpl__Case__c> cases = [SELECT dmpl__PartnerAccountId__c,
            dmpl__AccountId__c,
            dmpl__BranchId__c,
            dmpl__ResourceId__c,
            dmpl__AccountPhone__c,
            dmpl__Priority__c,
            dmpl__CaseSource__c,
            dmpl__CaseReason__c,
            dmpl__Status__c,
            dmpl__DateTimeOpened__c,
            dmpl__Mobile__c,
            dmpl__AccountName__c,
            dmpl__Remarks__c FROM dmpl__Case__c];
            ServiceLeadHelper.createLeadFromCase(cases);
            ServiceLeadHelper.createNewContact(contact,cases[0].dmpl__AccountId__c);
        }
       catch(Exception e){}
    }

    @isTest
    private static void VerifyConvertLead()
    {	
        //try{													
            dmpl__ServiceLead__c lead = [SELECT dmpl__PartnerAccountId__c,
            dmpl__AccountId__c,
            dmpl__BranchId__c,
            dmpl__ResourceId__c,
            dmpl__ReminderOffsetNumber__c,
            dmpl__DocumentDate__c FROM dmpl__ServiceLead__c LIMIT 1];
        List<dmpl__Case__c> cases=[select Id,Name,dmpl__AccountId__c,dmpl__AccountName__c,dmpl__AssetId__c,dmpl__BranchId__c,dmpl__ContactId__c,dmpl__ContactName__c,dmpl__ContactNumber__c,dmpl__Mobile__c,dmpl__PartnerAccountId__c,dmpl__AccountPhone__c from dmpl__Case__c LIMIT 1];
            Map<Object,Object> nvPair = new Map<Object,Object>();
            nvPair.put('fieldName', 'Name');
            nvPair.put('fieldValue', 'Sample');

    

            Map<Object,Object> dataMap = new Map<Object,Object>();
            dataMap.put('accountFields', new List<Object>{nvPair});
            dataMap.put('contactFields', new List<Object>());
            dataMap.put('serviceRequestFields', new List<Object>());
            dataMap.put('leadFields', new List<Object>());

            dataMap.put('createNewAccount', true);
            dataMap.put('createNewContact', false);
            dataMap.put('createNewServiceRequest', true);
            dataMap.put('leadId', lead.Id);
            ServiceLeadHelper.createLeadFromCase(cases);
            
            ServiceLeadController.convertLead(dataMap);
    //     }
    //    catch(Exception e){}
    }
    
    @isTest
    private static void deleteServicelEad()
    {
        test.startTest();
        dmpl__ServiceLead__c lead = [Select Id,Name From dmpl__ServiceLead__c LIMIT 1];
        if(lead != null)
            delete lead;
        System.assert(lead != null, 'Lead data');
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
    
    private static void CreateServiceLead()
    {
        List<dmpl__ServiceLead__c> serviceLead = new List<dmpl__ServiceLead__c>();
        Account customerAccount =[Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch' LIMIT 1];
        dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        serviceLead.add(new dmpl__ServiceLead__c(
                                           dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                           dmpl__AccountId__c=customerAccount.Id,
                                           dmpl__BranchId__c= branch.Id,
                                           dmpl__ResourceId__c=resource.Id,
                                           dmpl__ReminderOffsetNumber__c= Integer.valueOf('12'),
                                           dmpl__DocumentDate__c= date.today()
                                          ));
        insert serviceLead;
    }
     @isTest
    public static void VerifyevaluateNew(){
        // try{
        test.startTest();
        ServiceLeadHelper.evaluateDateTimeValues(Schema.DisplayType.Long,'equals','3.14159','3.14159');
        ServiceLeadHelper.evaluateDateTimeValues(Schema.DisplayType.Double,'notEqual','2023-05-09 12:00:00','2023-05-08 12:00:00');
        ServiceLeadHelper.evaluateDateTimeValues(Schema.DisplayType.Double,'greaterOrEqual','2023-05-08 12:00:00','2023-05-08 12:00:00');
        ServiceLeadHelper.evaluateDateTimeValues(Schema.DisplayType.Double,'lessOrEqual','2023-05-07 12:00:00','2023-05-08 12:00:00');
        ServiceLeadHelper.evaluateDateTimeValues(Schema.DisplayType.Double,'greaterThan','2023-05-09 12:00:00','2023-05-08 12:00:00');
        ServiceLeadHelper.evaluateDateTimeValues(Schema.DisplayType.Double,'lessThan','2023-05-06 12:00:00','2023-05-08 12:00:00'); 
        test.stopTest();
        // }
        // catch(Exception e){}
    }
    
    @isTest
    public static void VerifyevaluateDateTime(){
        // try{
        test.startTest();
        ServiceLeadHelper.evaluateDateTimeValues(Schema.DisplayType.DATE,'equals',Date.today(),'2023-06-21');
        ServiceLeadHelper.evaluateDateTimeValues(Schema.DisplayType.DATE,'notEqual',Date.today(),'2023-05-08');
        ServiceLeadHelper.evaluateDateTimeValues(Schema.DisplayType.DATE,'greaterOrEqual',Date.today(),'2023-06-21');
        ServiceLeadHelper.evaluateDateTimeValues(Schema.DisplayType.DATE,'lessOrEqual',Date.today(),'2023-06-21');
        ServiceLeadHelper.evaluateDateTimeValues(Schema.DisplayType.DATE,'greaterThan',Date.today(),'2023-05-08');
        ServiceLeadHelper.evaluateDateTimeValues(Schema.DisplayType.DATE,'lessThan',Date.today(),'2023-06-24');
        test.stopTest();
        // }
        // catch(Exception e){}
    }
     @isTest
    public static void VerifyevaluateDate(){
        // try{
        test.startTest();
        ServiceLeadHelper.evaluateDateTimeValues(Schema.DisplayType.DATETIME,'equals',DateTime.newInstanceGmt(2023, 06, 21, 12, 00, 00),'2023-05-08 12:00:00');
        ServiceLeadHelper.evaluateDateTimeValues(Schema.DisplayType.DATETIME,'notEqual',DateTime.newInstanceGmt(2023, 06, 21, 12, 00, 00),'2023-05-08 12:00:00');
        ServiceLeadHelper.evaluateDateTimeValues(Schema.DisplayType.DATETIME,'greaterOrEqual',DateTime.newInstanceGmt(2023, 06, 21, 12, 00, 00),'2023-06-21 12:00:00');
        ServiceLeadHelper.evaluateDateTimeValues(Schema.DisplayType.DATETIME,'lessOrEqual',DateTime.newInstanceGmt(2023, 06, 21, 12, 00, 00),'2023-06-21 12:00:00');
        ServiceLeadHelper.evaluateDateTimeValues(Schema.DisplayType.DATETIME,'greaterThan',DateTime.newInstanceGmt(2023, 06, 21, 12, 00, 00),'2023-05-08 12:00:00');
        ServiceLeadHelper.evaluateDateTimeValues(Schema.DisplayType.DATETIME,'lessThan',DateTime.newInstanceGmt(2023, 06, 21, 12, 00, 00),'2023-06-24 12:00:00');
        test.stopTest();
        // }
        // catch(Exception e){}
    }
    
     @isTest
    public static void VerifyevaluateNumber(){
        // try{
        test.startTest();
        Double  dbl  = 5.1234;
        ServiceLeadHelper.evaluateNumnericValues(Schema.DisplayType.Double,'equals',dbl,5.1234);
        ServiceLeadHelper.evaluateDateTimeValues(Schema.DisplayType.Double,'notEqual',dbl,2.1234);
        ServiceLeadHelper.evaluateDateTimeValues(Schema.DisplayType.Double,'greaterOrEqual',dbl,5.1234);
        ServiceLeadHelper.evaluateDateTimeValues(Schema.DisplayType.Double,'lessOrEqual',dbl,5.1234);
        ServiceLeadHelper.evaluateDateTimeValues(Schema.DisplayType.Double,'greaterThan',dbl,4.1234);
        ServiceLeadHelper.evaluateDateTimeValues(Schema.DisplayType.Double,'lessThan',dbl,6.1234);
        test.stopTest();
        // }
        // catch(Exception e){}
    }
    
    @isTest
    public static void VerifyevaluateLongNumber(){
        // try{
        test.startTest();
        Long  dbl  =677;
        ServiceLeadHelper.evaluateNumnericValues(Schema.DisplayType.LONG,'equals',dbl,'677');
        ServiceLeadHelper.evaluateDateTimeValues(Schema.DisplayType.LONG,'notEqual',dbl,'977');
        ServiceLeadHelper.evaluateDateTimeValues(Schema.DisplayType.LONG,'greaterOrEqual',dbl,'677');
        ServiceLeadHelper.evaluateDateTimeValues(Schema.DisplayType.LONG,'lessOrEqual',dbl,'677');
        ServiceLeadHelper.evaluateDateTimeValues(Schema.DisplayType.LONG,'greaterThan',dbl,'477');
        ServiceLeadHelper.evaluateDateTimeValues(Schema.DisplayType.LONG,'lessThan',dbl,'677');
        test.stopTest();
        // }
        // catch(Exception e){}
    }
    
    @isTest
    public static void VerifyevaluateIntNumber(){
        // try{
        test.startTest();
        integer  dbl  =2;
        ServiceLeadHelper.evaluateNumnericValues(Schema.DisplayType.Integer,'equals',dbl,2);
        ServiceLeadHelper.evaluateDateTimeValues(Schema.DisplayType.LONG,'notEqual',dbl,'977');
        ServiceLeadHelper.evaluateDateTimeValues(Schema.DisplayType.LONG,'greaterOrEqual',dbl,'677');
        ServiceLeadHelper.evaluateDateTimeValues(Schema.DisplayType.LONG,'lessOrEqual',dbl,'677');
        ServiceLeadHelper.evaluateDateTimeValues(Schema.DisplayType.LONG,'greaterThan',dbl,'477');
        ServiceLeadHelper.evaluateDateTimeValues(Schema.DisplayType.LONG,'lessThan',dbl,'677');
        test.stopTest();
        // }
        // catch(Exception e){}
    }
    
     @isTest
    public static void VerifyevaluateNumnericValues(){
        try{
            test.startTest();
            dmpl__ServiceLead__c serviceLead = [Select Id,Name,dmpl__Mobile__c From dmpl__ServiceLead__c LIMIT 1];
            dmpl__PartnerResource__c partnerResource = [Select Id,Name From dmpl__PartnerResource__c LIMIT 1];
            dmpl__ResourceAssignmentRule__c assignmentRule = [Select Id,Name,dmpl__Operation__c From dmpl__ResourceAssignmentRule__c LIMIT 1];
            ServiceLeadHelper.evaluateNumnericValues(Schema.DisplayType.INTEGER,'equals','dmpl__ReminderOffsetNumber__c','12');
            test.stopTest();
        }
        catch(Exception e){}
    }
    
    private static void createCases()
    {
        List<dmpl__Case__c> cases = new List<dmpl__Case__c>();
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        Account customerAccount =[Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        
        List<Asset> assets = new List<Asset>{ new Asset(Name = 'Test-Asset',
                            AccountId = customerAccount.Id,
                            dmpl__RegistrationNumber__c = 'Axb371',
                            dmpl__SaleDate__c = date.today()
                           )};
        insert assets;

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
                                    dmpl__AssetId__c = assets[0].Id,
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
                                    dmpl__AssignmentSequenceNumber__c=121));
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