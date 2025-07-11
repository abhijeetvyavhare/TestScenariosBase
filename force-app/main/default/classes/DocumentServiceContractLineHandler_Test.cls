@isTest
public with sharing class DocumentServiceContractLineHandler_Test {
    @TestSetup
    static void createRequiredData(){
        dmpl__DocumentServiceContract__c documentServiceContractLine = DocumentServiceContractLineDataHelpers.createDocumentServiceContractLine();

         Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1', false, true, false, true, 'MG Road', 'Bengaluru', 'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India', '560095','9876543210');
         dmpl__Item__c item7 = TestDataHelpers.createItem('Item 7','Product',true,false,false, '765456',false);
        Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1', true, false, false, true, 'MG Road', 'Pune', 'Maharashtra', 'India', '411001', 'Ring Rd', 'Nagpur', 'Maharashtra', 'India', '440001','9876543210', 'Created');
        dmpl__Branch__c branch1=TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id, true, true, false, true);
        dmpl__Item__c  item1 = TestDataHelpers.createItem('Item 1','Product',true,false,false,'675654',false);
        dmpl__SKU__c sku1 = TestDataHelpers.createSKU('SKU 1', item7.id, true);
        dmpl__ContactAddress__c address1 = TestDataHelpers.createContactAddress('Address 1', 'Ring Rd', 'Pune', 'Maharashtra', customerAccount1.Id, 'Billing Address', '440001', false);

    }

    @isTest
    static void createDocumentServiceContractLinePositive() {
        dmpl__DocumentServiceContract__c documentServiceContractLine = DocumentServiceContractLineDataHelpers.getDocumentServiceContractLine();
        
        System.assertEquals(documentServiceContractLine.dmpl__Quantity__c, 20, 'Quantity mismatch');
        System.assertEquals(documentServiceContractLine.dmpl__IsInScope__c, true, 'Scope should true');
    }
    
    @isTest
    static void updateDocumentServiceContractLinePositive() {
        dmpl__DocumentServiceContract__c documentServiceContractLine = DocumentServiceContractLineDataHelpers.getDocumentServiceContractLine();
        
        documentServiceContractLine.dmpl__Quantity__c = 40;
        documentServiceContractLine.dmpl__IsInScope__c = true;
        
        update documentServiceContractLine;
        
        dmpl__DocumentServiceContract__c updatedDocumentServiceContractLine = DocumentServiceContractLineDataHelpers.getDocumentServiceContractLine();
        System.assertEquals(updatedDocumentServiceContractLine.dmpl__Quantity__c, 40, 'Quantity mismatch');
        System.assertEquals(updatedDocumentServiceContractLine.dmpl__IsInScope__c, true, 'Scope should true');
    }
    
    @isTest
    static void deleteDocumentServiceContractLine() {
        dmpl__DocumentServiceContract__c documentServiceContractLine = DocumentServiceContractLineDataHelpers.getDocumentServiceContractLine();
        System.assertNotEquals(null, documentServiceContractLine, 'Record should exist before deletion.');
    
        Id docId = documentServiceContractLine.Id;
    
        delete documentServiceContractLine;
        dmpl__DocumentServiceContract__c deletedDocLine;
    
        try {
            deletedDocLine = DocumentServiceContractLineDataHelpers.getDocumentServiceContractLine();
        } catch (Exception e) {
            deletedDocLine = null;
        }
    
        System.assertEquals(null, deletedDocLine, 'Document Service Contract Line should be deleted and not found in query.');
    }
    @isTest
    static void CreatedocumentServiceContractLineWithServiceRequestLinePositive() {
    
    Account customer = TestDataHelpers.getCustomerAccount('Customer 1'); 
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
    dmpl__Item__c item = TestDataHelpers.getItem('Item 1');

    Asset asset = AssetDataHelper.createAsset('Asset 1', customer.Id, item.Id);

    dmpl__ServiceRequest__c request = ServiceRequestTestDataHelpers.createServiceRequestWithId(
        customer,
        branch,
        item,
        asset,
        null
    );

    dmpl__ServiceRequestLine__c requestLine = ServiceRequestTestDataHelpers.createServiceRequestLineById(
        request,
        item,
        null
    );

    dmpl__DocumentServiceContract__c DocumentServiceLine= DocumentServiceContractLineDataHelpers.createDocumentServiceContractLine(requestLine,null,null);

    System.assertEquals(requestLine.Id, DocumentServiceLine.dmpl__ServiceRequestLineId__c, 'ServiceRequestLine should be linked');
}
// Document Service Contract Line creation with Sale order line reference (New)
@isTest
static void CreatedocumentServiceContractLineWithSaleOrderLinePositive() {
    Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
    dmpl__Item__c item = TestDataHelpers.getItem('Item 1');

    dmpl__ContactAddress__c deliveryAddress = TestDataHelpers.getContactAddress('Address 1');


    dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrderById(
        customer,
        branch,
        null,
        null
    );

    dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLineById(
        saleOrder.Id,
        item.Id,
        1,
        null
    );

    dmpl__DocumentServiceContract__c DocumentServiceLine= DocumentServiceContractLineDataHelpers.createDocumentServiceContractLine(null,saleOrderLine,null);

    System.assertNotEquals(null, DocumentServiceLine.Id, 'DocumentServiceContract should be inserted');
    //System.assertEquals(saleOrderLine.Id, DocumentServiceLine.dmpl__SaleOrderLineId__c, 'SaleOrderLine should be linked');
}
// Document Service Contract Line creation with Component Item (New)
@isTest
static void CreatedocumentServiceContractLineWithComponentItemPositive(){
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
            dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
            dmpl__Item__c item = TestDataHelpers.getItem('Item 7');

            dmpl__DocumentServiceContract__c DocumentServiceLine= DocumentServiceContractLineDataHelpers.createDocumentServiceContractLine(null,null,item);

            System.assertEquals(item.Id, DocumentServiceLine.dmpl__ComponentItemId__c, 'component item should match ');
        }
// Document Service Contract Line creation with 0 quantity (New)
@isTest
static void CreatedocumentServiceContractLineWithZeroQuantityPositive(){
    Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
            dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
            dmpl__Item__c item = TestDataHelpers.getItem('Item 7');

            dmpl__DocumentServiceContract__c DocumentServiceLine= DocumentServiceContractLineDataHelpers.createDocumentServiceContractLine(null,null,item);
            DocumentServiceLine.dmpl__Quantity__c=0;
            update DocumentServiceLine;

            System.assertEquals(0, DocumentServiceLine.dmpl__Quantity__c, 'quatity should be zero');
        }
}