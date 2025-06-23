@isTest(SeeAllData=true)
public class DocumentSelector_Test {

    @isTest
    private static void testReleaseChildDocuments_SaleOrder() {
        try {
            // Query existing dmpl__CreateRelatedSetting__mdt record for dmpl__SaleOrder__c
            dmpl__CreateRelatedSetting__mdt metaData = [SELECT Id, dmpl__HostObjectId__c FROM dmpl__CreateRelatedSetting__mdt WHERE dmpl__HostObjectId__c = 'dmpl__SaleOrder__c' LIMIT 1];

            DocumentSelectorController.releaseChildDocuments(metaData.Id, null, new List<SourceObjectInfo>{});

        } catch (Exception e) {
            System.debug('Exception caught: ' + e.getMessage());
        }
    }


    @isTest
    private static void testReleaseChildDocuments_RepairOrder() {
        try {
            // Query existing dmpl__CreateRelatedSetting__mdt record for dmpl__RepairOrder__c
            dmpl__CreateRelatedSetting__mdt metaData = [SELECT Id, dmpl__HostObjectId__c FROM dmpl__CreateRelatedSetting__mdt WHERE dmpl__HostObjectId__c = 'dmpl__RepairOrder__c' LIMIT 1];

            // Perform releaseChildDocuments
            DocumentSelectorController.releaseChildDocuments(null, metaData.Id, new List<SourceObjectInfo>{});

            // Add assertions based on expected behavior
            // Example:
            // System.assertNotEquals(null, result, 'Expected result not null');
        } catch (Exception e) {
            System.debug('Exception caught: ' + e.getMessage());
            // Log or handle exception appropriately
        }
    }

    // Test method for verifying queueReleaseDocument
    @isTest
    private static void testQueueReleaseDocument() {
        try {
            // Query existing dmpl__CreateRelatedSetting__mdt record for dmpl__DeliveryOrder__c
            dmpl__CreateRelatedSetting__mdt metaData = [SELECT Id, dmpl__HostObjectId__c FROM dmpl__CreateRelatedSetting__mdt WHERE dmpl__HostObjectId__c = 'dmpl__DeliveryOrder__c' LIMIT 1];

            // Create hostId (example: Account record)
            Account testAccount = new Account(Name = 'Test Account');
            insert testAccount;

            // Perform queueReleaseDocument without childObjectsInfo
            CreateRelatedResult resultWithoutChildInfo = DocumentSelectorController.queueReleaseDocument(metaData.Id, testAccount.Id);

            // Create childObjectsInfo (example: List<SourceObjectInfo>)
            List<SourceObjectInfo> childObjectsInfo = new List<SourceObjectInfo>();  

            // Perform queueReleaseDocument with childObjectsInfo
            CreateRelatedResult resultWithChildInfo = DocumentSelectorController.queueReleaseDocument(metaData.Id, testAccount.Id, childObjectsInfo);

            // Add assertions based on expected behavior
            // Example:
            // System.assertNotEquals(null, resultWithoutChildInfo, 'Expected resultWithoutChildInfo not null');
            // System.assertNotEquals(null, resultWithChildInfo, 'Expected resultWithChildInfo not null');
        } catch(Exception e) {
            System.debug('Exception caught: ' + e.getMessage());
            // Log or handle exception appropriately
        }
    }

    // Utility method to create test child objects info (if needed)
    public static List<SourceObjectInfo> createTestChildObjectsInfo() {
        // Implement as needed based on your specific test data creation logic
        return new List<SourceObjectInfo>(); // Placeholder, replace with actual implementation
    }

    @isTest
    private static void Verify3()
    {
        try{
        dmpl__CreateRelatedSetting__mdt metaData = getCreateRelatedSetting('dmpl__DeliveryOrder__c');
        //DocumentSelectorController.releaseDocument(metaData.Id,null);
        }catch(Exception e){}
    }
     
    @isTest
    private static void Verify4()
    {
        try{
        dmpl__CreateRelatedSetting__mdt metaData = getCreateRelatedSetting('dmpl__SaleInvoice__c');
            if(metaData != null){
        //DocumentSelectorController.releaseDocument(metaData.Id,null);
            DocumentSelectorController.releaseChildDocuments(null,metaData.Id,new List<SourceObjectInfo>{});
            }
        }catch(Exception e){}
    }
     
    @isTest
    private static void Verify5()
    {
        try{
        dmpl__CreateRelatedSetting__mdt metaData = getCreateRelatedSetting('dmpl__InventoryFulfillment__c');
            if(metaData != null){
        DocumentSelectorController.releaseDocument(metaData.Id,null,4);
            DocumentSelectorController.releaseChildDocuments(null,metaData.Id,new List<SourceObjectInfo>{});
            }
        }catch(Exception e){}
    }
     
    @isTest
    private static void Verify6()
    {
        try{
        dmpl__CreateRelatedSetting__mdt metaData = getCreateRelatedSetting('dmpl__PurchaseReturn__c');
            if(metaData != null){
        //DocumentSelectorController.releaseDocument(metaData.Id,null);
            DocumentSelectorController.releaseChildDocuments(null,metaData.Id,new List<SourceObjectInfo>{});
            }
        }catch(Exception e){}
    }
     
     @isTest
    private static void Verify7()
    {
        try{
        dmpl__CreateRelatedSetting__mdt metaData = getCreateRelatedSetting('dmpl__BillReturn__c');
            if(metaData != null){
        //DocumentSelectorController.releaseDocument(metaData.Id,null);
            DocumentSelectorController.releaseChildDocuments(null,metaData.Id,new List<SourceObjectInfo>{});
            }
        }catch(Exception e){}
    }
     
     @isTest
    private static void Verify8()
    {
        try{
        dmpl__CreateRelatedSetting__mdt metaData = getCreateRelatedSetting('dmpl__GoodsReceipt__c');
            if(metaData != null){
        //DocumentSelectorController.releaseDocument(metaData.Id,null);
            DocumentSelectorController.releaseChildDocuments(null,metaData.Id,new List<SourceObjectInfo>{});
            }
        }catch(Exception e){}
    }
         
    public static dmpl__CreateRelatedSetting__mdt getCreateRelatedSetting(String objectAPIName){
         return [SELECT
         DeveloperName,
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
         dmpl__CreateRelatedSetting__mdt
     WHERE
         dmpl__HostObjectId__r.QualifiedApiName =: objectAPIName
     LIMIT 1
     ];
     } 
}