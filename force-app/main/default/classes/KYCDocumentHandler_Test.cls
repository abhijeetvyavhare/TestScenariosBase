@isTest
public class KYCDocumentHandler_Test {
	@TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();        
        dmpl__Branch__c branch =TestDataHelpers.createBranch(partnerAccount);    
        dmpl__ContactAddress__c contactAddress =TestDataHelpers.CreateContactAddress(customerAccount);
        dmpl__Item__c item =TestDataHelpers.createItem();
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList(partnerAccount,branch);
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceList,item);
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(TestDataHelpers.getCustomerAccount(),TestDataHelpers.getBranch(),
                                                                                TestDataHelpers.getContactAddress(),TestDataHelpers.getPriceList());
        dmpl__KYCDocument__c KYCDocument = KYCDocumentsTestDataHelpers.createKYCDocuments(saleOrder);
    }
    
    @isTest
    static void createKYCDocumentPositive() {
        dmpl__KYCDocument__c KYCDocument = KYCDocumentsTestDataHelpers.getKYCDocument();
        
        System.assertEquals('3534534', KYCDocument.dmpl__DocumentNumber__c, 'Document number mismatch');
    }
    
    @isTest
    static void updateKYCDocumentPositive() {
        dmpl__KYCDocument__c KYCDocument = KYCDocumentsTestDataHelpers.getKYCDocument();
        
        KYCDocument.dmpl__DocumentNumber__c = '343434';
        
        update KYCDocument;
        
        dmpl__KYCDocument__c updatedKYCDocument = KYCDocumentsTestDataHelpers.getKYCDocument();
        System.assertEquals('343434', updatedKYCDocument.dmpl__DocumentNumber__c, 'Document number mismatch');
    }
    
    @isTest
    static void deleteKYCDocument() {
        dmpl__KYCDocument__c kycDocument = KYCDocumentsTestDataHelpers.getKYCDocument();
        System.assertNotEquals(null, kycDocument, 'KYC Document should exist before deletion.');
    
        Id docId = kycDocument.Id;
    
        delete kycDocument;
    
        dmpl__KYCDocument__c deletedDoc;
    
        try {
            deletedDoc = KYCDocumentsTestDataHelpers.getKYCDocument(docId);
        } catch (Exception e) {
            deletedDoc = null;
        }
    
        System.assertEquals(null, deletedDoc, 'KYC Document should be deleted and not found in query.');
    }

}