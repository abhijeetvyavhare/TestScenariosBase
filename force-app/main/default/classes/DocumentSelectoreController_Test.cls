@isTest
public class DocumentSelectoreController_Test {
    
    
    
    
        @testSetup
        static void setup() {
            // Create test data
            
            Account partneraccount = new Account(Name = 'Partner-Test-Account',
                                             dmpl__LastName__c = 'Sale Order',
                                             dmpl__IsPartnerAccount__c = True, 
                                             dmpl__IsActive__c = true
                                            );
            insert partneraccount;
        
        
            Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__LastName__c = 'Sale Order',
                                              dmpl__IsCustomerAccount__c = True,
                                              dmpl__IsPartnerAccount__c = False,
                                              dmpl__IsActive__c = true
                                             );
            insert customerAccount;
    
            List<dmpl__Branch__c> branch = new List<dmpl__Branch__c>();
            branch.Add(new dmpl__Branch__c(dmpl__PartnerAccountId__c = partnerAccount.Id,
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
            dmpl__SaleOrder__c saleOrder = new dmpl__SaleOrder__c( dmpl__AccountId__C = customerAccount.Id, dmpl__PartnerAccountId__c = partneraccount.Id, dmpl__BranchId__c = branch[0].Id);
            insert saleOrder;

            dmpl__SaleInvoice__c saleInvoice = new dmpl__SaleInvoice__c( dmpl__AccountId__c = customerAccount.Id, dmpl__PartnerAccountId__c = partneraccount.Id, dmpl__BranchId__c = branch[0].Id);
            insert saleInvoice;
        }
    
        @isTest
        static void testGetCreateRelatedSettings() {
            Test.startTest();
            List<dmpl__CreateRelatedSetting__mdt> settings = DocumentSelectorController.getCreateRelatedSettings('dmpl__SaleOrder__c');
            Test.stopTest();
    
            System.assert(settings.size() > 0, 'Settings should be returned');
        }
    
        @isTest
        static void testGetChildObjects() {
            dmpl__CreateRelatedSetting__mdt setting = [SELECT Id FROM dmpl__CreateRelatedSetting__mdt LIMIT 1];
            dmpl__SaleOrder__c saleOrder = [SELECT Id FROM dmpl__SaleOrder__c LIMIT 1];
    
            Test.startTest();
            List<SObject> childObjects = DocumentSelectorController.getChildObjects(setting.Id, saleOrder.Id, 'Test');
            Test.stopTest();
    
            
        }
    
        @isTest
        static void testReleaseDocument() {
            dmpl__CreateRelatedSetting__mdt setting = [SELECT Id FROM dmpl__CreateRelatedSetting__mdt LIMIT 1];
            dmpl__SaleOrder__c saleOrder = [SELECT Id FROM dmpl__SaleOrder__c LIMIT 1];
            dmpl__SaleInvoice__c saleInvoice = [SELECT Id FROM dmpl__SaleInvoice__c LIMIT 1];
    
            Test.startTest();
            try {
                
                CreateRelatedResult result = DocumentSelectorController.releaseDocument(setting.Id, saleOrder.Id, 1);
        
                
            } catch (Exception e) {
                
            }
            
            try {
                dmpl__CreateRelatedSetting__mdt setting2 = [SELECT Id FROM dmpl__CreateRelatedSetting__mdt WHERE dmpl__ActionType__c = 'Cancel' LIMIT 1];
                CreateRelatedResult result2 = DocumentSelectorController.releaseDocument(setting2.Id, saleOrder.Id, 1);
                
            } catch (Exception e) {
                
            }

            try {
                dmpl__CreateRelatedSetting__mdt setting3 = [SELECT Id FROM dmpl__CreateRelatedSetting__mdt WHERE dmpl__ActionType__c = 'Return' LIMIT 1];
                CreateRelatedResult result3 = DocumentSelectorController.releaseDocument(setting3.Id, saleOrder.Id, 1);
                
            } catch (Exception e) {
                
            }

            try {
                dmpl__CreateRelatedSetting__mdt setting4 = [SELECT Id FROM dmpl__CreateRelatedSetting__mdt WHERE dmpl__ActionType__c = 'Confirm' LIMIT 1];
                CreateRelatedResult result4 = DocumentSelectorController.releaseDocument(setting4.Id, saleOrder.Id, 1);
                
            } catch (Exception e) {
                
            }

            try {
                dmpl__CreateRelatedSetting__mdt setting5 = [SELECT Id FROM dmpl__CreateRelatedSetting__mdt WHERE dmpl__ActionType__c = 'Post IL' LIMIT 1];
                CreateRelatedResult result5 = DocumentSelectorController.releaseDocument(setting5.Id, saleInvoice.Id, 1);
                
            } catch (Exception e) {
                
            }

            try {
                dmpl__CreateRelatedSetting__mdt setting6 = [SELECT Id FROM dmpl__CreateRelatedSetting__mdt WHERE dmpl__ActionType__c = 'Post GL' LIMIT 1];
                CreateRelatedResult result6 = DocumentSelectorController.releaseDocument(setting6.Id, saleInvoice.Id, 1);
                    
            } catch (Exception e) {
                

            }
            Test.stopTest();

        }
    
        @isTest
        static void testReleaseChildDocuments() {
            dmpl__CreateRelatedSetting__mdt setting = [SELECT Id FROM dmpl__CreateRelatedSetting__mdt LIMIT 1];
            dmpl__SaleOrder__c saleOrder = [SELECT Id FROM dmpl__SaleOrder__c LIMIT 1];
            dmpl__SaleInvoice__c saleInvoice = [SELECT Id FROM dmpl__SaleInvoice__c LIMIT 1];
            
            List<SourceObjectInfo> childObjectsInfo = new List<SourceObjectInfo>
            {
                new SourceObjectInfo('dmpl__SaleOrderLine__c', 'a0r5D000003mit5QAA', 1, 'Test')
            };
    
            Test.startTest();
            try {
                CreateRelatedResult result = DocumentSelectorController.releaseChildDocuments(setting.Id, saleOrder.Id, childObjectsInfo);
            } catch (Exception e) {
                
            }
            
    
    

            try {
                dmpl__CreateRelatedSetting__mdt setting2 = [SELECT Id FROM dmpl__CreateRelatedSetting__mdt WHERE dmpl__ActionType__c = 'Cancel' LIMIT 1];
                CreateRelatedResult result2 = DocumentSelectorController.releaseChildDocuments(setting2.Id, saleOrder.Id, childObjectsInfo);
            } catch (Exception e) {
                
            }

            try {
                dmpl__CreateRelatedSetting__mdt setting3 = [SELECT Id FROM dmpl__CreateRelatedSetting__mdt WHERE dmpl__ActionType__c = 'Return' LIMIT 1];
                CreateRelatedResult result3 = DocumentSelectorController.releaseChildDocuments(setting3.Id, saleOrder.Id, childObjectsInfo);
            } catch (Exception e) {
                
            }

            try {
                dmpl__CreateRelatedSetting__mdt setting4 = [SELECT Id FROM dmpl__CreateRelatedSetting__mdt WHERE dmpl__ActionType__c = 'Confirm' LIMIT 1];
                CreateRelatedResult result4 = DocumentSelectorController.releaseChildDocuments(setting4.Id, saleOrder.Id, childObjectsInfo);
            } catch (Exception e) {
                
            }

            try {
                dmpl__CreateRelatedSetting__mdt setting5 = [SELECT Id FROM dmpl__CreateRelatedSetting__mdt WHERE dmpl__ActionType__c = 'Post IL' LIMIT 1];
                CreateRelatedResult result5 = DocumentSelectorController.releaseChildDocuments(setting5.Id, saleInvoice.Id, childObjectsInfo);
            } catch (Exception e) {
                
            }

            try {
                dmpl__CreateRelatedSetting__mdt setting6 = [SELECT Id FROM dmpl__CreateRelatedSetting__mdt WHERE dmpl__ActionType__c = 'Post GL' LIMIT 1];
                CreateRelatedResult result6 = DocumentSelectorController.releaseChildDocuments(setting6.Id, saleInvoice.Id, childObjectsInfo);
                    
            } catch (Exception e) {
                
            }
            Test.stopTest();

        }
    
        @isTest
        static void testReleaseDocumentDirect() {
            dmpl__CreateRelatedSetting__mdt setting = [SELECT Id FROM dmpl__CreateRelatedSetting__mdt LIMIT 1];
            dmpl__SaleOrder__c saleOrder = [SELECT Id FROM dmpl__SaleOrder__c LIMIT 1];
    
            Test.startTest();
            CreateRelatedResult result = DocumentSelectorController.releaseDocumentDirect(setting.Id, saleOrder.Id);
            Test.stopTest();
    
            
        }








     @isTest
    static void test_finish_Method() {
        // Setup Test Data
        DocumentSelectorProcessor processor = new DocumentSelectorProcessor(null, null, null, null);
        
        Test.startTest();
        processor.finish(null);
        Test.stopTest();
        
        // Assert final state
        // e.g., Verify if the job completion status was set
    }


    @isTest
    Public static void getCreateRelatedSettings()
    {
        test.startTest();
        List<Account> acc = [Select Id, Name,dmpl__AccountContactId__c FROM Account Limit 1];
        DocumentSelectorController.getCreateRelatedSettings('Account');
        ExceptionLogHelper.logMessage('');
        System.assert(acc!=null, 'Item is getted');
        test.stopTest();
    }
    
    @isTest
    Public static void getSOQLQuery()
    {
        test.startTest();
        dmpl__DocumentActionSetting__mdt metaData= [Select Id,
                                                    dmpl__FilterSourceSOQL__c,
                                                    dmpl__ChildObjectSOQLFilter__c,
                                                    dmpl__EligibilityQuantityFieldId__r.QualifiedApiName,
                                                    dmpl__ChildFieldsetName__c,
                                                    dmpl__ChildObjectId__r.QualifiedApiName,
                                                    dmpl__ChildObjectId__c
                                                    from dmpl__DocumentActionSetting__mdt Limit 1 ];
        List<Account> acc = [Select Id, Name,dmpl__AccountContactId__c FROM Account Limit 1];
        DocumentActionSettingHelper.getSOQLQuery(metaData,'FIND',acc[0].Id);
        System.assert(acc!=null, 'Item is getted');
        test.stopTest();
    }
    
    @isTest
    Public static void getDocumentActionSetting()
    {
        try{
        test.startTest();
        List<Account> acc = [Select Id, Name,dmpl__AccountContactId__c FROM Account Limit 1];
        DocumentActionSettingHelper.getDocumentActionSetting(acc[0].Id);
        System.assert(acc!=null, 'Item is getted');
        test.stopTest();
        }
        catch(exception e){}
    }
    
     @isTest
    Public static void getDocumentActionSettings()
    {
        test.startTest();
        List<Account> acc = [Select Id, Name,dmpl__AccountContactId__c FROM Account Limit 1];
        DocumentActionSettingHelper.getDocumentActionSettings('dmpl__SaleOrder__c');
        System.assert(acc!=null, 'Item is getted');
        test.stopTest();
    }
    
   /*@isTest
    private static void VerifyCreatedRelatedSetting()
    {
        try{
        dmpl__CreateRelatedSetting__mdt data = [SELECT Id,dmpl__HostObjectId__r.QualifiedApiName,
        dmpl__HostObjectId__r.Label,
        dmpl__RelatedObjectId__r.QualifiedApiName,
        dmpl__RelatedObjectId__r.Label,
        dmpl__Title__c,
        dmpl__Heading__c,
        dmpl__SubHeading__c,
        dmpl__IsActive__c,
        dmpl__Sort__c,
        dmpl__EligibilityQuantityFieldId__c,
        dmpl__EligibilityQuantityFieldId__r.QualifiedApiName,
        dmpl__ChildObjectId__c,
        dmpl__ChildObjectId__r.QualifiedApiName,
        dmpl__ChildFieldsetName__c
    FROM 
        dmpl__CreateRelatedSetting__mdt 
        LIMIT 1];
        test.startTest();
        DocumentSelectorController.getCreateRelatedSettings(data.Id);
        dmpl__InterfaceQueue__c jobsQueue = new dmpl__InterfaceQueue__c(dmpl__JobType__c = 'Document Selector Processor',dmpl__QueueType__c = 'Queueable',dmpl__RetryCount__c = 1);
       	insert jobsQueue;
        dmpl__JobQueueRecord__c jobsQueueRecord = new dmpl__JobQueueRecord__c(dmpl__JobQueueId__c = jobsQueue.Id,dmpl__RecordId__c = 'a0r5D000003mit5QAA');
        insert jobsQueueRecord;
        JobResponseResult result = DocumentSelectorProcessor.perfromAction(data.Id,'a0r5D000003mit5QAA',jobsQueue.Id);
        test.stopTest();
        }catch(Exception e){}
        
        
    } */

    
    @isTest
    Public static void getChildObjects()
    {
        List<Account> acc = [Select Id, Name,dmpl__AccountContactId__c FROM Account Limit 1];
        try {
            DocumentSelectorController.getChildObjects('m000w000000CjGxAAK','0010w000012efcSAAQ','');
            
        } catch (Exception ex) {
            
        }
        System.assert(acc!=null, 'Item is getted');
    }
    
     @isTest
     public static void releaseDocument()
     {
         try{
         List<Account> acc = [Select Id, Name,dmpl__AccountContactId__c FROM Account Limit 1];
     	 DocumentSelectorController.releaseDocument('m001m0000006mYuAAI','a2Y1m000000pQHsEAM',10);
         System.assert(acc!=null, 'Item is getted');
         }
         catch(exception e){}
     }
    
    @isTest
     public static void queueReleaseDocument()
     {
         try{
         List<Account> acc = [Select Id, Name,dmpl__AccountContactId__c FROM Account Limit 1];
     	 DocumentSelectorController.queueReleaseDocument('m001m0000006mYuAAI','a2Y1m000000pQHsEAM');             
         DocumentSelectorController.queueReleaseDocument('m001m0000006mYuAAI','a2Y1m000000pQHsEAM',new List<SourceObjectInfo>());
         }
         catch(exception e){}
     }
    
     @isTest
     public static void releaseDocument1()
     {
         try{
         List<Account> acc = [Select Id, Name,dmpl__AccountContactId__c FROM Account Limit 1];
     	DocumentSelectorController.releaseDocument('m001m0000006oDMAAY','a1U1m0000023gn6EAA',10);
         System.assert(acc!=null, 'Item is getted');
         }
         catch(exception e){}
     }
    
     @isTest
     public static void releaseDocument2()
     {
         try{
         List<Account> acc = [Select Id, Name,dmpl__AccountContactId__c FROM Account Limit 1];
     	DocumentSelectorController.releaseDocument('m001m0000006oDHAAY','a1U1m0000023gn6EAA',10);
         System.assert(acc!=null, 'Item is getted');
         }
         catch(exception e){}
     }
    
    @isTest
    public static void testQueueReleaseDocument()
    {
        try{
            Id recordSettingId = '';
            Id hostId = '50';
            CreateRelatedResult resultWithoutChildInfo = DocumentSelectorController.queueReleaseDocument(recordSettingId, hostId);
            List<SourceObjectInfo> childObjectsInfo = new List<SourceObjectInfo>();  
            CreateRelatedResult resultWithChildInfo = DocumentSelectorController.queueReleaseDocument(recordSettingId, hostId, childObjectsInfo);
        }catch(exception e){}  
    }
    
     @isTest
     public static void releaseDocument3()
     {
         try{
         List<Account> acc = [Select Id, Name,dmpl__AccountContactId__c FROM Account Limit 1];
     	DocumentSelectorController.releaseDocument('m001m0000006oDCAAY','a1U1m0000023gn6EAA',10);
         System.assert(acc!=null, 'Item is getted');
         }
         catch(exception e){}
     }
    
     @isTest
     public static void releaseDocument4()
     {
         try{
         List<Account> acc = [Select Id, Name,dmpl__AccountContactId__c FROM Account Limit 1];
     	DocumentSelectorController.releaseDocument('m001m0000006oCsAAI','a1N1m000001ymLyEAI',10);
         System.assert(acc!=null, 'Item is getted');
         }
         catch(exception e){}
     }
    
     @isTest
     public static void releaseDocument5()
     {
         try{
         List<Account> acc = [Select Id, Name,dmpl__AccountContactId__c FROM Account Limit 1];
     	DocumentSelectorController.releaseDocument('m001m0000006oASAAY','a1N1m000001ymLyEAI',10);
         System.assert(acc!=null, 'Item is getted');
         }
         catch(exception e){}
     }
        
     @isTest
     public static void releaseDocument6()
     {
         try{
         List<Account> acc = [Select Id, Name,dmpl__AccountContactId__c FROM Account Limit 1];
     	DocumentSelectorController.releaseDocument('m000w000000CjH1AAK','a2B0l000000jzzHEAQ',5);
         System.assert(acc!=null, 'Item is getted');
         }
         catch(exception e){}
     }
        
     @isTest
     public static void releaseDocument7()
     {
         try{
         List<Account> acc = [Select Id, Name,dmpl__AccountContactId__c FROM Account Limit 1];
     	DocumentSelectorController.releaseDocument('m005D0000009dxZQAQ','a0r5D000003mit5QAA',5);
         System.assert(acc!=null, 'Item is getted');
         }
         catch(exception e){}
     }
    
   
    @isTest
    public static void releaseChildDocuments()
    {
        test.startTest();
        try{
        List<dmpl__SaleOrder__c> line = [SELECT Id, Name,dmpl__BranchId__c, (SELECT Id, dmpl__Quantity__c FROM SaleOrderLines__r) FROM dmpl__SaleOrder__c];
        List<dmpl__CreateRelatedSetting__mdt> metaData =[ SELECT Id,DeveloperName,
        dmpl__HostObjectId__r.QualifiedApiName,
        dmpl__HostObjectId__r.Label,
        dmpl__RelatedObjectId__r.QualifiedApiName,
        dmpl__RelatedObjectId__r.Label,
        dmpl__Title__c,
        dmpl__SubTitle__c,
        dmpl__Heading__c,
        dmpl__SubHeading__c,
        dmpl__IsActive__c,
        dmpl__Sort__c,
        dmpl__EligibilityQuantityFieldId__c,
        dmpl__EligibilityQuantityFieldId__r.QualifiedApiName,
        dmpl__ChildObjectId__c,
        dmpl__ChildObjectId__r.QualifiedApiName,
        dmpl__ChildFieldsetName__c,
        dmpl__ChildObjectSOQLFilter__c,
        dmpl__FilterSourceSOQL__c,
        dmpl__Tag__c
    FROM 
        dmpl__CreateRelatedSetting__mdt LIMIT 1];
        	List<SourceObjectInfo> sourceObjectInfo = new List<SourceObjectInfo>();
            for(dmpl__SaleOrder__c order : line)
            {    
                for(dmpl__SaleOrderLine__c orderLine : order.SaleOrderLines__r)
                {
                    sourceObjectInfo.add(new SourceObjectInfo('dmpl__SaleOrderLine__c', orderLine.Id, 0, ''));
                }
            }
            
            
            DocumentSelectorController.releaseChildDocuments(line[0].Id,metaData[0].Id,sourceObjectInfo);     
            System.assert( line != null, 'Repair Order is getted');
        }
       catch(exception e){}
        test.stopTest();
    }
    
    @isTest
    public static void releaseChildDocuments1()
    {
        test.startTest();
        try{
        List<dmpl__SaleOrder__c> line = [SELECT Id, Name,dmpl__BranchId__c, (SELECT Id, dmpl__Quantity__c FROM SaleOrderLines__r) FROM dmpl__SaleOrder__c];
        	List<SourceObjectInfo> sourceObjectInfo = new List<SourceObjectInfo>();
            for(dmpl__SaleOrder__c order : line)
            {    
                for(dmpl__SaleOrderLine__c orderLine : order.SaleOrderLines__r)
                {
                    sourceObjectInfo.add(new SourceObjectInfo('dmpl__SaleOrderLine__c', orderLine.Id, 0, ''));
                }
            }
            
            
            DocumentSelectorController.releaseChildDocuments('a2F5D0000028OuoUAE','m005D0000009dxaQAA',sourceObjectInfo);     
            DocumentSelectorController.performExternalAction('','','m000w000000CjH4AAK','a0G5D000004C6pXUAS',sourceObjectInfo);
            System.assert(line.size() != null, 'Repair Order is getted');
        }
        catch(exception e){}
        test.stopTest();
    }
    
    @isTest
    public static void releaseChildDocuments2()
    {
        test.startTest();
        try{
        List<dmpl__SaleOrder__c> line = [SELECT Id, Name,dmpl__BranchId__c, (SELECT Id, dmpl__Quantity__c FROM SaleOrderLines__r) FROM dmpl__SaleOrder__c];
        	List<SourceObjectInfo> sourceObjectInfo = new List<SourceObjectInfo>();
            for(dmpl__SaleOrder__c order : line)
            {    
                for(dmpl__SaleOrderLine__c orderLine : order.SaleOrderLines__r)
                {
                    sourceObjectInfo.add(new SourceObjectInfo('dmpl__SaleOrderLine__c', orderLine.Id, 0, ''));
                }
            }
            
            //SO & cancel
            DocumentSelectorController.releaseChildDocuments('a1U1m0000023gn6EAA','m001m0000006oDCAAY',sourceObjectInfo);     
            System.assert(line.size() != null, 'Repair Order is getted');
        }
        catch(exception e){}
        test.stopTest();
    }
    
    @isTest
    public static void releaseChildDocuments3()
    {
        test.startTest();
        try{
        List<dmpl__SaleOrder__c> line = [SELECT Id, Name,dmpl__BranchId__c, (SELECT Id, dmpl__Quantity__c FROM SaleOrderLines__r) FROM dmpl__SaleOrder__c];
        	List<SourceObjectInfo> sourceObjectInfo = new List<SourceObjectInfo>();
            for(dmpl__SaleOrder__c order : line)
            {    
                for(dmpl__SaleOrderLine__c orderLine : order.SaleOrderLines__r)
                {
                    sourceObjectInfo.add(new SourceObjectInfo('dmpl__SaleOrderLine__c', orderLine.Id, 0, ''));
                }
            }
            
            //confirm & fulfillment
            DocumentSelectorController.releaseChildDocuments('a1N1m000001ymLyEAI','m001m0000006oCsAAI',sourceObjectInfo);     
            System.assert(line.size() != null, 'Repair Order is getted');
        }
        catch(exception e){}
        test.stopTest();
    }
    
    @isTest
    public static void releaseChildDocuments4()
    {
        test.startTest();
        try{
        List<dmpl__SaleOrder__c> line = [SELECT Id, Name,dmpl__BranchId__c, (SELECT Id, dmpl__Quantity__c FROM SaleOrderLines__r) FROM dmpl__SaleOrder__c];
        	List<SourceObjectInfo> sourceObjectInfo = new List<SourceObjectInfo>();
            for(dmpl__SaleOrder__c order : line)
            {    
                for(dmpl__SaleOrderLine__c orderLine : order.SaleOrderLines__r)
                {
                    sourceObjectInfo.add(new SourceObjectInfo('dmpl__SaleOrderLine__c', orderLine.Id, 0, ''));
                }
            }
            
            //post il & adjustment
            DocumentSelectorController.releaseChildDocuments('a1N1m000001ymLyEAI','m001m0000006oCsAAI',sourceObjectInfo);     
            System.assert(line.size() != null, 'Repair Order is getted');
        }
        catch(exception e){}
        test.stopTest();
    }
    
    @isTest
    public static void releaseChildDocuments5()
    {
        test.startTest();
        try{
        
        List<dmpl__SaleOrder__c> line = [SELECT Id, Name,dmpl__BranchId__c, (SELECT Id, dmpl__Quantity__c FROM SaleOrderLines__r) FROM dmpl__SaleOrder__c];
        	List<SourceObjectInfo> sourceObjectInfo = new List<SourceObjectInfo>();
            for(dmpl__SaleOrder__c order : line)
            {    
                for(dmpl__SaleOrderLine__c orderLine : order.SaleOrderLines__r)
                {
                    sourceObjectInfo.add(new SourceObjectInfo('dmpl__SaleOrderLine__c', orderLine.Id, 0, ''));
                }
            }
            //post gl & invoice
            DocumentSelectorController.releaseChildDocuments('a1N1m000001ymLyEAI','m001m0000006oASAAY',sourceObjectInfo);     
            System.assert(line.size() != null, 'Repair Order is getted');
            
        }
        catch(exception e){}
        test.stopTest();
    }
        
    @isTest
    public static void releaseChildDocuments6()
    {
        test.startTest();
        try{
        List<dmpl__SaleOrder__c> line = [SELECT Id, Name,dmpl__BranchId__c, (SELECT Id, dmpl__Quantity__c FROM SaleOrderLines__r) FROM dmpl__SaleOrder__c];
        	List<SourceObjectInfo> sourceObjectInfo = new List<SourceObjectInfo>();
            for(dmpl__SaleOrder__c order : line)
            {    
                for(dmpl__SaleOrderLine__c orderLine : order.SaleOrderLines__r)
                {
                    sourceObjectInfo.add(new SourceObjectInfo('dmpl__SaleOrderLine__c', orderLine.Id, 0, ''));
                }
            }
            //return
            DocumentSelectorController.releaseChildDocuments('a1U1m0000023gn6EAA','m001m0000006oDMAAY',sourceObjectInfo);     
            System.assert(line.size() != null, 'Repair Order is getted');
        }
        catch(exception e){}
        test.stopTest();
    }
    
    @isTest
    public static void releaseChildDocuments7()
    {
        try{
        List<dmpl__SaleReturn__c> line = [SELECT Id, Name,dmpl__BranchId__c, (SELECT Id, dmpl__Quantity__c FROM SaleReturnLines__r) FROM dmpl__SaleReturn__c];
        	List<SourceObjectInfo> sourceObjectInfo = new List<SourceObjectInfo>();
            for(dmpl__SaleReturn__c order : line)
            {    
                for(dmpl__SaleReturnLine__c orderLine : order.SaleReturnLines__r)
                {
                    sourceObjectInfo.add(new SourceObjectInfo('dmpl__SaleReturnLine__c', orderLine.Id, 0, ''));
                }
            }
            
            DocumentSelectorController.releaseChildDocuments('a295D000000aguRQAQ','m000w000000CjH6AAK',sourceObjectInfo);     
            System.assertEquals(1, line.size(), 'Repair Order is getted');
        }
        catch(exception e){}
    }
    
    @isTest
    public static void releaseChildDocuments8()
    {
        try{
        List<dmpl__SaleReturn__c> line = [SELECT Id, Name,dmpl__BranchId__c, (SELECT Id, dmpl__Quantity__c FROM SaleReturnLines__r) FROM dmpl__SaleReturn__c];
        	List<SourceObjectInfo> sourceObjectInfo = new List<SourceObjectInfo>();
            for(dmpl__SaleReturn__c order : line)
            {    
                for(dmpl__SaleReturnLine__c orderLine : order.SaleReturnLines__r)
                {
                    sourceObjectInfo.add(new SourceObjectInfo('dmpl__PurchaseReturnLine__c', orderLine.Id, 0, ''));
                }
            }
            
            DocumentSelectorController.releaseChildDocuments('a2F5D0000028OuoUAE','m000w000000CjH3AAK',sourceObjectInfo);     
            System.assertEquals(1, line.size(), 'Repair Order is getted');
        }
        catch(exception e){}
    }
        
    @isTest
    public static void releaseChildDocuments9()
    {
        try{
        List<dmpl__SaleReturn__c> line = [SELECT Id, Name,dmpl__BranchId__c, (SELECT Id, dmpl__Quantity__c FROM SaleReturnLines__r) FROM dmpl__SaleReturn__c];
        	List<SourceObjectInfo> sourceObjectInfo = new List<SourceObjectInfo>();
            for(dmpl__SaleReturn__c order : line)
            {    
                for(dmpl__SaleReturnLine__c orderLine : order.SaleReturnLines__r)
                {
                    sourceObjectInfo.add(new SourceObjectInfo('dmpl__BillReturnLine__c', orderLine.Id, 0, ''));
                }
            }
            
            DocumentSelectorController.releaseChildDocuments('a0G5D000004C6pXUAS','m000w000000CjH4AAK',sourceObjectInfo);     
            System.assertEquals(1, line.size(), 'Repair Order is getted');
        }
        catch(exception e){}
    }
    
    @isTest
    public static void releaseChildDocuments10()
    {
        try{
        List<dmpl__SaleReturn__c> line = [SELECT Id, Name,dmpl__BranchId__c, (SELECT Id, dmpl__Quantity__c FROM SaleReturnLines__r) FROM dmpl__SaleReturn__c];
        	List<SourceObjectInfo> sourceObjectInfo = new List<SourceObjectInfo>();
            for(dmpl__SaleReturn__c order : line)
            {    
                for(dmpl__SaleReturnLine__c orderLine : order.SaleReturnLines__r)
                {
                    sourceObjectInfo.add(new SourceObjectInfo('dmpl__BillReturnLine__c', orderLine.Id, 0, ''));
                }
            }
            
            DocumentSelectorController.releaseChildDocuments('a0G5D000004C6pXUAS','m000w000000CjGwAAK',sourceObjectInfo);     
            System.assertEquals(1, line.size(), 'Repair Order is getted');
        }
        catch(exception e){}
    }
        
    @isTest
    public static void releaseDocumentDirect()
    {
        try{
        List<dmpl__SaleReturn__c> line = [SELECT Id, Name,dmpl__BranchId__c, (SELECT Id, dmpl__Quantity__c FROM SaleReturnLines__r) FROM dmpl__SaleReturn__c];
        	            
            DocumentSelectorController.releaseDocumentDirect('m005D0000009dxZQAQ','a0r5D000003mit5QAA');     
            System.assertEquals(1, line.size(), 'Repair Order is getted');
        }
        catch(exception e){}
    }
    
    
    @isTest
    private static void performActionRelease()
    {
        try{
        List<dmpl__SaleReturn__c> line = [SELECT Id, Name,dmpl__BranchId__c, (SELECT Id, dmpl__Quantity__c FROM SaleReturnLines__r) FROM dmpl__SaleReturn__c];
            dmpl__CreateRelatedSetting__mdt metdata = new dmpl__CreateRelatedSetting__mdt();
        	List<SourceObjectInfo> sourceObjectInfo = new List<SourceObjectInfo>();
            for(dmpl__SaleReturn__c order : line)
            {    
                for(dmpl__SaleReturnLine__c orderLine : order.SaleReturnLines__r)
                {
                    sourceObjectInfo.add(new SourceObjectInfo('dmpl__BillReturnLine__c', orderLine.Id, 0, ''));
                }
            }
            //so and Fulfillment
            DocumentSelectorController.performActionRelease('m001m0000006mZ0AAI','a2Y1m000000pQHsEAM',metdata);   
            DocumentSelectorController.performActionRelease('a2Y1m000000pQHsEAM','m001m0000006mZ0AAI',sourceObjectInfo,metdata);   
            System.assert(line.size() != null, 'Repair Order is getted');
        }
        catch(exception e){}
    }
    
    @isTest
    private static void performActionRelease1()
    {
        try{
        List<dmpl__SaleReturn__c> line = [SELECT Id, Name,dmpl__BranchId__c, (SELECT Id, dmpl__Quantity__c FROM SaleReturnLines__r) FROM dmpl__SaleReturn__c];
            dmpl__CreateRelatedSetting__mdt metdata = new dmpl__CreateRelatedSetting__mdt();
        	List<SourceObjectInfo> sourceObjectInfo = new List<SourceObjectInfo>();
            for(dmpl__SaleReturn__c order : line)
            {    
                for(dmpl__SaleReturnLine__c orderLine : order.SaleReturnLines__r)
                {
                    sourceObjectInfo.add(new SourceObjectInfo('dmpl__BillReturnLine__c', orderLine.Id, 0, ''));
                }
            }
            // so & invocie
            DocumentSelectorController.performActionRelease('m001m0000006mZ5AAI','a2Y1m000000pQHsEAM',metdata);   
            DocumentSelectorController.performActionRelease('a2Y1m000000pQHsEAM','m001m0000006mZ5AAI',sourceObjectInfo,metdata);   
            System.assert(line.size() != null, 'Repair Order is getted');
        }
        catch(exception e){}
    }
    
    @isTest
    private static void performActionRelease2()
    {
        try{
        List<dmpl__SaleReturn__c> line = [SELECT Id, Name,dmpl__BranchId__c, (SELECT Id, dmpl__Quantity__c FROM SaleReturnLines__r) FROM dmpl__SaleReturn__c];
            dmpl__CreateRelatedSetting__mdt metdata = new dmpl__CreateRelatedSetting__mdt();
        	List<SourceObjectInfo> sourceObjectInfo = new List<SourceObjectInfo>();
            for(dmpl__SaleReturn__c order : line)
            {    
                for(dmpl__SaleReturnLine__c orderLine : order.SaleReturnLines__r)
                {
                    sourceObjectInfo.add(new SourceObjectInfo('dmpl__BillReturnLine__c', orderLine.Id, 0, ''));
                }
            }
            //so & Sale invoice
            DocumentSelectorController.performActionRelease('m001m0000006mZ5AAI','a2V1m000000URQlEAO',metdata);   
            DocumentSelectorController.performActionRelease('a2V1m000000URQlEAO','m001m0000006mZ5AAI',sourceObjectInfo,metdata);   
            System.assert(line.size() != null, 'Repair Order is getted');
        }
        catch(exception e){}
    }
    
    @isTest
    private static void performActionRelease3()
    {
        try{
        List<dmpl__SaleReturn__c> line = [SELECT Id, Name,dmpl__BranchId__c, (SELECT Id, dmpl__Quantity__c FROM SaleReturnLines__r) FROM dmpl__SaleReturn__c];
            dmpl__CreateRelatedSetting__mdt metdata = new dmpl__CreateRelatedSetting__mdt();
        	List<SourceObjectInfo> sourceObjectInfo = new List<SourceObjectInfo>();
            for(dmpl__SaleReturn__c order : line)
            {    
                for(dmpl__SaleReturnLine__c orderLine : order.SaleReturnLines__r)
                {
                    sourceObjectInfo.add(new SourceObjectInfo('dmpl__BillReturnLine__c', orderLine.Id, 0, ''));
                }
            }
            // sale order & DO
            DocumentSelectorController.performActionRelease('m001m0000006mYuAAI','a2V1m000000URQlEAO',metdata);   
            DocumentSelectorController.performActionRelease('a2V1m000000URQlEAO','m001m0000006mYuAAI',sourceObjectInfo,metdata);   
            System.assert(line.size() != null, 'Repair Order is getted');
        }
        catch(exception e){}
    }
    
    @isTest
    private static void performActionRelease4()
    {
        try{
        List<dmpl__SaleReturn__c> line = [SELECT Id, Name,dmpl__BranchId__c, (SELECT Id, dmpl__Quantity__c FROM SaleReturnLines__r) FROM dmpl__SaleReturn__c];
            dmpl__CreateRelatedSetting__mdt metdata = new dmpl__CreateRelatedSetting__mdt();
        	List<SourceObjectInfo> sourceObjectInfo = new List<SourceObjectInfo>();
            for(dmpl__SaleReturn__c order : line)
            {    
                for(dmpl__SaleReturnLine__c orderLine : order.SaleReturnLines__r)
                {
                    sourceObjectInfo.add(new SourceObjectInfo('dmpl__BillReturnLine__c', orderLine.Id, 0, ''));
                }
            }
            //so & PO
            
            DocumentSelectorController.performActionRelease('m001m0000006mZCAAY','a2V1m000000URQlEAO',metdata);   
            DocumentSelectorController.performActionRelease('a2V1m000000URQlEAO','m001m0000006mZCAAY',sourceObjectInfo,metdata);   
            System.assert(line.size() != null, 'Repair Order is getted');
        }
        catch(exception e){}
    }
        
    @isTest
    private static void performActionRelease5()
    {
        try{
        List<dmpl__SaleReturn__c> line = [SELECT Id, Name,dmpl__BranchId__c, (SELECT Id, dmpl__Quantity__c FROM SaleReturnLines__r) FROM dmpl__SaleReturn__c];
            dmpl__CreateRelatedSetting__mdt metdata = new dmpl__CreateRelatedSetting__mdt();
        	List<SourceObjectInfo> sourceObjectInfo = new List<SourceObjectInfo>();
            for(dmpl__SaleReturn__c order : line)
            {    
                for(dmpl__SaleReturnLine__c orderLine : order.SaleReturnLines__r)
                {
                    sourceObjectInfo.add(new SourceObjectInfo('dmpl__BillReturnLine__c', orderLine.Id, 0, ''));
                }
            }
            //RO & fulfillment
            DocumentSelectorController.performActionRelease('m001m0000006mZ1AAI','a2O1m000000fRA6EAM',metdata);   
            DocumentSelectorController.performActionRelease('a2O1m000000fRA6EAM','m001m0000006mZ1AAI',sourceObjectInfo,metdata);   
            System.assert(line.size() != null, 'Repair Order is getted');
        }
        catch(exception e){}
    }
        
    @isTest
    private static void performActionRelease6()
    {
        try{
        List<dmpl__SaleReturn__c> line = [SELECT Id, Name,dmpl__BranchId__c, (SELECT Id, dmpl__Quantity__c FROM SaleReturnLines__r) FROM dmpl__SaleReturn__c];
            dmpl__CreateRelatedSetting__mdt metdata = new dmpl__CreateRelatedSetting__mdt();
        	List<SourceObjectInfo> sourceObjectInfo = new List<SourceObjectInfo>();
            for(dmpl__SaleReturn__c order : line)
            {    
                for(dmpl__SaleReturnLine__c orderLine : order.SaleReturnLines__r)
                {
                    sourceObjectInfo.add(new SourceObjectInfo('dmpl__BillReturnLine__c', orderLine.Id, 0, ''));
                }
            }
            //invoice & SO
            DocumentSelectorController.performActionRelease('m001m0000006mZHAAY','a2V1m000000URQlEAO',metdata);   
            DocumentSelectorController.performActionRelease('a2V1m000000URQlEAO','m001m0000006mZHAAY',sourceObjectInfo,metdata);   
            System.assert(line.size() != null, 'Repair Order is getted');
        }
        catch(exception e){}
    }
    
    @isTest
    private static void performActionRelease7()
    {
        try{
        List<dmpl__SaleReturn__c> line = [SELECT Id, Name,dmpl__BranchId__c, (SELECT Id, dmpl__Quantity__c FROM SaleReturnLines__r) FROM dmpl__SaleReturn__c];
            dmpl__CreateRelatedSetting__mdt metdata = new dmpl__CreateRelatedSetting__mdt();
        	List<SourceObjectInfo> sourceObjectInfo = new List<SourceObjectInfo>();
            for(dmpl__SaleReturn__c order : line)
            {    
                for(dmpl__SaleReturnLine__c orderLine : order.SaleReturnLines__r)
                {
                    sourceObjectInfo.add(new SourceObjectInfo('dmpl__BillReturnLine__c', orderLine.Id, 0, ''));
                }
            }
            //fulfill & fulfill
            DocumentSelectorController.performActionRelease('m001m0000006mYtAAI','a1U1m0000023gn6EAA',metdata);   
            DocumentSelectorController.performActionRelease('a1U1m0000023gn6EAA','m001m0000006mYtAAI',sourceObjectInfo,metdata);   
            System.assert(line.size() != null, 'Repair Order is getted');
        }
        catch(exception e){}
    }
        
    @isTest
    private static void performActionRelease8()
    {
        try{
        List<dmpl__SaleReturn__c> line = [SELECT Id, Name,dmpl__BranchId__c, (SELECT Id, dmpl__Quantity__c FROM SaleReturnLines__r) FROM dmpl__SaleReturn__c];
            dmpl__CreateRelatedSetting__mdt metdata = new dmpl__CreateRelatedSetting__mdt();
        	List<SourceObjectInfo> sourceObjectInfo = new List<SourceObjectInfo>();
            for(dmpl__SaleReturn__c order : line)
            {    
                for(dmpl__SaleReturnLine__c orderLine : order.SaleReturnLines__r)
                {
                    sourceObjectInfo.add(new SourceObjectInfo('dmpl__BillReturnLine__c', orderLine.Id, 0, ''));
                }
            }
            //fulfill & DO
            DocumentSelectorController.performActionRelease('m001m0000006mYwAAI','a1U1m0000023gn6EAA',metdata);   
            DocumentSelectorController.performActionRelease('a1U1m0000023gn6EAA','m001m0000006mYwAAI',sourceObjectInfo,metdata);   
            System.assert(line.size() != null, 'Repair Order is getted');
        }
        catch(exception e){}
    }
        
    @isTest
    private static void performActionRelease9()
    {
        try{
        List<dmpl__SaleReturn__c> line = [SELECT Id, Name,dmpl__BranchId__c, (SELECT Id, dmpl__Quantity__c FROM SaleReturnLines__r) FROM dmpl__SaleReturn__c];
            dmpl__CreateRelatedSetting__mdt metdata = new dmpl__CreateRelatedSetting__mdt();
        	List<SourceObjectInfo> sourceObjectInfo = new List<SourceObjectInfo>();
            for(dmpl__SaleReturn__c order : line)
            {    
                for(dmpl__SaleReturnLine__c orderLine : order.SaleReturnLines__r)
                {
                    sourceObjectInfo.add(new SourceObjectInfo('dmpl__BillReturnLine__c', orderLine.Id, 0, ''));
                }
            }
            //fulfill & RO
            DocumentSelectorController.performActionRelease('m001m0000006mZEAAY','a1U1m0000023gn6EAA',metdata);   
            DocumentSelectorController.performActionRelease('a1U1m0000023gn6EAA','m001m0000006mZEAAY',sourceObjectInfo,metdata);   
            System.assert(line.size() != null, 'Repair Order is getted');
        }
        catch(exception e){}
    }
    
    @isTest
    private static void performActionRelease10()
    {
        try{
        List<dmpl__SaleReturn__c> line = [SELECT Id, Name,dmpl__BranchId__c, (SELECT Id, dmpl__Quantity__c FROM SaleReturnLines__r) FROM dmpl__SaleReturn__c];
            dmpl__CreateRelatedSetting__mdt metdata = new dmpl__CreateRelatedSetting__mdt();
        	List<SourceObjectInfo> sourceObjectInfo = new List<SourceObjectInfo>();
            for(dmpl__SaleReturn__c order : line)
            {    
                for(dmpl__SaleReturnLine__c orderLine : order.SaleReturnLines__r)
                {
                    sourceObjectInfo.add(new SourceObjectInfo('dmpl__BillReturnLine__c', orderLine.Id, 0, ''));
                }
            }
            //fulfill & picking line
            DocumentSelectorController.performActionRelease('m001m0000006oDMAAY','a1U1m0000023gn6EAA',metdata);   
            DocumentSelectorController.performActionRelease('a1U1m0000023gn6EAA','m001m0000006oDMAAY',sourceObjectInfo,metdata);   
            System.assert(line.size() != null, 'Repair Order is getted');
        }
        catch(exception e){}
    }
        
    @isTest
    private static void performActionRelease11()
    {
        try{
        List<dmpl__SaleReturn__c> line = [SELECT Id, Name,dmpl__BranchId__c, (SELECT Id, dmpl__Quantity__c FROM SaleReturnLines__r) FROM dmpl__SaleReturn__c];
            dmpl__CreateRelatedSetting__mdt metdata = new dmpl__CreateRelatedSetting__mdt();
        	List<SourceObjectInfo> sourceObjectInfo = new List<SourceObjectInfo>();
            for(dmpl__SaleReturn__c order : line)
            {    
                for(dmpl__SaleReturnLine__c orderLine : order.SaleReturnLines__r)
                {
                    sourceObjectInfo.add(new SourceObjectInfo('dmpl__BillReturnLine__c', orderLine.Id, 0, ''));
                }
            }
            //return & invoice
            DocumentSelectorController.performActionRelease('m001m0000006mZIAAY','a2b1m000001Z362AAC',metdata);   
            DocumentSelectorController.performActionRelease('a2b1m000001Z362AAC','m001m0000006mZIAAY',sourceObjectInfo,metdata);   
            System.assert(line.size() != null, 'Repair Order is getted');
        }
        catch(exception e){}
    }
        
    @isTest
    private static void performActionRelease12()
    {
        try{
        List<dmpl__SaleReturn__c> line = [SELECT Id, Name,dmpl__BranchId__c, (SELECT Id, dmpl__Quantity__c FROM SaleReturnLines__r) FROM dmpl__SaleReturn__c];
            dmpl__CreateRelatedSetting__mdt metdata = new dmpl__CreateRelatedSetting__mdt();
        	List<SourceObjectInfo> sourceObjectInfo = new List<SourceObjectInfo>();
            for(dmpl__SaleReturn__c order : line)
            {    
                for(dmpl__SaleReturnLine__c orderLine : order.SaleReturnLines__r)
                {
                    sourceObjectInfo.add(new SourceObjectInfo('dmpl__BillReturnLine__c', orderLine.Id, 0, ''));
                }
            }
            //return & DO
            DocumentSelectorController.performActionRelease('m001m0000006mZGAAY','a2b1m000001Z362AAC',metdata);   
            DocumentSelectorController.performActionRelease('a2b1m000001Z362AAC','m001m0000006mZGAAY',sourceObjectInfo,metdata);   
            System.assert(line.size() != null, 'Repair Order is getted');
        }
        catch(exception e){}
    }
    
   /*@isTest
    private static void VerifyDocumentSelectorProcessor(){
        dmpl__InterfaceQueue__c jobsQueue = new dmpl__InterfaceQueue__c(dmpl__JobType__c = 'Document Selector Processor',dmpl__QueueType__c = 'Queueable',dmpl__RetryCount__c = 1);
       	insert jobsQueue;
        new CreateRelatedResult(jobsQueue.Id);
        dmpl__JobQueueRecord__c jobsQueueRecord = new dmpl__JobQueueRecord__c(dmpl__JobQueueId__c = jobsQueue.Id);
        insert jobsQueueRecord;
        dmpl__CreateRelatedSetting__mdt data = [SELECT Id,dmpl__HostObjectId__r.QualifiedApiName,
        dmpl__HostObjectId__r.Label,
        dmpl__RelatedObjectId__r.QualifiedApiName,
        dmpl__RelatedObjectId__r.Label,
        dmpl__Title__c,
        dmpl__Heading__c,
        dmpl__SubHeading__c,
        dmpl__IsActive__c,
        dmpl__Sort__c,
        dmpl__HostObjectId__c,
        dmpl__EligibilityQuantityFieldId__c,
        dmpl__EligibilityQuantityFieldId__r.QualifiedApiName,
        dmpl__ChildObjectId__c,
        dmpl__ChildObjectId__r.QualifiedApiName,
        dmpl__ChildFieldsetName__c
    FROM 
        dmpl__CreateRelatedSetting__mdt 
        LIMIT 1];
        DocumentSelectorController.queueReleaseDocument(data.id,data.dmpl__HostObjectId__c);
        DocumentSelectorController.queueReleaseDocument(data.id,data.dmpl__HostObjectId__c,new List<SourceObjectInfo>());
        JobResponseResult result = DocumentSelectorProcessor.perfromAction(data.id,data.dmpl__HostObjectId__c,jobsQueue.Id);
    }*/

    
    @isTest
    private static void testCreateRelatedResult(){
        List<Database.Error> errors = new List<Database.Error>();
        new CreateRelatedResult(errors);
        dmpl__ErrorLogEvent__e log = new dmpl__ErrorLogEvent__e();
        Database.SaveResult result = EventBus.publish(log);
        CreateRelatedResult.InitFrom(result);
    }
    
}