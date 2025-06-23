@isTest
public class ResourceGroupHelper_Test {
    @testSetup
    public static void Setup()
    {
        //System.runAs(PostInstallHelper.AssignAdministratorAllPermissions(UserInfo.getUserId())){
            Test.startTest();
            CreateResourceGroup();
            CreateResourceGroupRule();
            CreateResource();
            CreateJobQueue();
            Test.stopTest();                
        //}
    }
    
    @isTest
    public static void getResourceGroup()
    {
        try{
        test.startTest();
        dmpl__ResourceGroup__c res =[Select Id, Name from dmpl__ResourceGroup__c Limit 1];
       /* dmpl__InterfaceQueue__c queue = new dmpl__InterfaceQueue__c(
                                    dmpl__JobType__c = 'Account Group Member Processor',
                                    //dmpl__InterfaceRecordId__c = acc.Id,
                                    dmpl__QueueType__c = 'Queueable'
                                );
        insert queue;*/
        ResourceGroupHelper.processMembers(res.Id);
       

        test.stopTest();
        }
        
        catch(exception e){}
    }
    
    @isTest
    public static void getQueue()
    {
        try{
        test.startTest();
        dmpl__InterfaceQueue__c que =[Select Id from dmpl__InterfaceQueue__c Limit 1];
        dmpl__ResourceGroup__c res =[Select Id, Name,dmpl__ReportId__c from dmpl__ResourceGroup__c Limit 1];
       
        ResourceGroupMemberProcessor.processReportData(res.id,que.id,res);
       

        test.stopTest();
        }
        
        catch(exception e){}
    }
    
    @isTest
    public static void getResource()
    {
        try{
        test.startTest();
        List<Id> ids = new List<Id>();
        dmpl__Resource__c res =[Select Id from dmpl__Resource__c Limit 1];
        ids.add(res.Id);
        dmpl__ResourceGroup__c res1 =[Select Id, dmpl__ResourceGroupType__c  from dmpl__ResourceGroup__c Limit 1];
        
       ResourceGroupHelper.getCachedResourceGroupIds(res1.dmpl__ResourceGroupType__c,res.Id);
       ResourceGroupHelper.getCachedResourceGroupIds(res1.dmpl__ResourceGroupType__c,ids);
       
        

        test.stopTest();
        }
        
        catch(exception e){}
    }
    
    @isTest
    private static void buildConditionTest()
    {
        test.startTest();
        dmpl__ResourceGroupRule__c resorceGroupRule = [Select Id,dmpl__FieldName__c,dmpl__FieldValue__c,dmpl__Operation__c from dmpl__ResourceGroupRule__c Limit 1];
        ResourceGroupMemberProcessor.buildCondition(resorceGroupRule);
        test.stopTest();
    }
    
    private static void CreateResourceGroup()
    {
    	dmpl__ResourceGroup__c resourceGroup= new dmpl__ResourceGroup__c (Name= 'Test-ResourceGroup', 
                                                                       dmpl__ResourceGroupType__c='Incentive',
                                                                       dmpl__DynamicMemberType__c = 'Field Filter',
                                                                       dmpl__ReportId__c = 'Report1'
                                                                      );
        insert resourceGroup;
    }
    
    private static void CreateResourceGroupRule()
    {
        dmpl__ResourceGroup__c resourceGroup = [Select Id from dmpl__ResourceGroup__c Limit 1];
    	dmpl__ResourceGroupRule__c resourceGroupRule= new dmpl__ResourceGroupRule__c (
                                                                        dmpl__ResourceGroupId__c = resourceGroup.Id,
                                                                        dmpl__FieldName__c= 'Test-ResourceGroup', 
                                                                       	dmpl__FieldValue__c='Sample',
                                                                       dmpl__Operation__c = '',
                                                                        dmpl__SequenceNumber__c = 1
                                                                           
                                                                       
                                                                      );
        insert resourceGroupRule;
    }
    
    private static void CreateResource()
    {
    	dmpl__Resource__c resource= new dmpl__Resource__c (Name= 'Test-Resource' 
                                                                       
                                                           );
        insert resource;
    }
    
    private static void CreateJobQueue()
    {
    	dmpl__InterfaceQueue__c queue= new dmpl__InterfaceQueue__c (dmpl__JobType__c = 'Interface Job',
                                                                    dmpl__QueueType__c = 'Queueable',
                                                                    dmpl__RetryCount__c = 1
                                                                       
                                                           );
        insert queue;
    }
    
}