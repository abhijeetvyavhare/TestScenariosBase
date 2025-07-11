@isTest
public class PurchaseRequisitionHandler_Test {
    
    @TestSetup
    static void createRequiredData(){
        dmpl__AccountGroup__c accountGroup=TestDataHelpers.createAccountGroup();
        Account partnerAccount=TestDataHelpers.createPartnerAccount();
        Account customerAccount=TestDataHelpers.createCustomerAccount();
        Account supplierAccount=TestDataHelpers.createSupplierAccount();
        dmpl__Branch__c branch=TestDataHelpers.createBranch(partnerAccount);
        dmpl__Item__c item=TestDataHelpers.createItem();
        dmpl__SKU__c sku=TestDataHelpers.createSKU(item);
        dmpl__Resource__c resource=TestDataHelpers.createResource(partnerAccount,branch);
        dmpl__PriceList__c priceList=TestDataHelpers.createPriceList(partnerAccount,branch);
        dmpl__PurchaseRequisition__c purchaseRequisition=PurchaseRequisitionTestDataHelpers.CreateRequistion(partnerAccount,branch);
        dmpl__PurchaseRequisitionLine__c purchaseRequisitionLine=PurchaseRequisitionTestDataHelpers.CreateRequistionLine(purchaseRequisition,item,sku);
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1', false, true, false, true, 'MG Road', 'Bengaluru', 'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India', '560095','9876543210');
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2', false, true, false, false, '45 Residency Road', 'Pune', 'Maharashtra', 'India', '411001', '22 Commerce Avenue', 'Pune', 'Maharashtra', 'India', '411038','91-99665544433');        
        Account partnerAccount3 = TestDataHelpers.createPartnerAccount('Partner 3', false, true, false, true, '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '91-9123456789');
        
        dmpl__Branch__c branch1=TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id, true, true, false, true);
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partnerAccount3.Id, false, true, true, false);
        Account supplierAccount1 = TestDataHelpers.createPartnerAccount('Supplier 1', false, false, true, true, '55 Industrial Park Road', 'Ahmedabad', 'GJ', 'India', '380015', '55 Industrial Park Road', 'Ahmedabad', 'GJ', 'India', '380015', '-9988776564');
        Test.stopTest();
    }

    @isTest
    public static void createPurchaseRequisitionPositive() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        
        dmpl__PurchaseRequisition__c purchaseRequisition = PurchaseRequisitionTestDataHelpers.CreateRequistion(partnerAccount, branch);
        
        System.assertNotEquals(null, purchaseRequisition.Id, 'Purchase Requisition should be created');
        System.assertEquals('Draft', purchaseRequisition.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(partnerAccount.Id, purchaseRequisition.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, purchaseRequisition.dmpl__BranchId__c, 'Branch should match');
    }

    @isTest
    public static void UpdatePurchaseRequisitionPositive()
    {
        dmpl__PurchaseRequisition__c purchaseRequisition = PurchaseRequisitionTestDataHelpers.getRequisition();
        if(purchaseRequisition != null)
        {
            purchaseRequisition.dmpl__Status__c = 'Draft';
            purchaseRequisition.dmpl__PerformReleaseOrder__c = true;
        }
        update purchaseRequisition;
        System.assertEquals('Draft', purchaseRequisition.dmpl__Status__c, 'purchase Requisition have 1 updated record');
    }
    
    @isTest
    public static void DeletePurchaseRequisitionPositive()
    {
        dmpl__PurchaseRequisition__c purchaseRequisition = PurchaseRequisitionTestDataHelpers.getRequisition();
        delete purchaseRequisition;
        System.assertEquals('Draft', purchaseRequisition.dmpl__Status__c, 'purchase Requisition have 1 deleted record');
    }


    @isTest
    public static void createPurchaseRequisitionLinePositive() {
        dmpl__PurchaseRequisition__c purchaseRequisition = PurchaseRequisitionTestDataHelpers.getRequisition();
        dmpl__Item__c item = TestDataHelpers.getItem();
        dmpl__SKU__c sku = TestDataHelpers.getSKU();
        
        dmpl__PurchaseRequisitionLine__c purchaseRequisitionLine = PurchaseRequisitionTestDataHelpers.CreateRequistionLine(purchaseRequisition, item, sku);
        
        System.assertNotEquals(null, purchaseRequisitionLine.Id, 'Purchase Requisition Line should be created');
        System.assertEquals(purchaseRequisition.Id, purchaseRequisitionLine.dmpl__PurchaseRequisitionId__c, 'Purchase Requisition should match');
        System.assertEquals(item.Id, purchaseRequisitionLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(sku.Id, purchaseRequisitionLine.dmpl__SKUId__c, 'SKU should match');
    }
    
    
    @isTest
    public static void UpdatePurchaseRequisitionLinePositive()
    {
        dmpl__PurchaseRequisitionLine__c purchaseRequisitionLine = PurchaseRequisitionTestDataHelpers.getRequisitionLine();
        purchaseRequisitionLine.dmpl__Quantity__c = 5;
        update purchaseRequisitionLine;
        System.assertEquals(5, purchaseRequisitionLine.dmpl__Quantity__c, 'purchase Requisition Line have 1 updated record');
    }
    
    @isTest
    public static void DeletePurchaseRequisitionLinePositive()
    {
        dmpl__PurchaseRequisitionLine__c purchaseRequisitionLine = PurchaseRequisitionTestDataHelpers.getRequisitionLine();
        delete purchaseRequisitionLine;
        System.assertEquals(1, purchaseRequisitionLine.dmpl__Quantity__c, 'purchase Requisition Line have 1 deleted record');
    }    
    
    //Requisition created with active partner and branch
    @isTest
    public static void createRequisitionWithActivePartnerAndBranchPositive() {
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__PurchaseRequisition__c purchaseRequisition = PurchaseRequisitionTestDataHelpers.CreateRequistion(partner1, branch1, supplier, null);
        dmpl__PurchaseRequisition__c createdRequisition = PurchaseRequisitionTestDataHelpers.getRequisition(purchaseRequisition);
        Test.stopTest();
        System.assertNotEquals(null, createdRequisition, 'Requisition should be created with active partner and branch');
        System.assertEquals(partner1.Id, createdRequisition.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, createdRequisition.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier.Id, createdRequisition.dmpl__SupplierAccountId__c, 'Supplier Account should match');
    }

    //Requisition with inactive partner
    @isTest
    public static void createRequisitionWithInactivePartnerNegative() {
        Test.startTest();
        Account partner2 = TestDataHelpers.getPartnerAccount('Partner 2');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account supplier1= TestDataHelpers.getSupplierAccount('Supplier 1');
        try{
            dmpl__PurchaseRequisition__c purchaseRequisition = PurchaseRequisitionTestDataHelpers.CreateRequistion(partner2, branch1, supplier1, null);
            dmpl__PurchaseRequisition__c createdRequisition = PurchaseRequisitionTestDataHelpers.getRequisition(purchaseRequisition);
            System.assertEquals(null, createdRequisition, 'Requisition should not be created with inactive partner');
        }
        catch(Exception e) {
            System.debug('Exception occurred: ' + e.getMessage());
        }
        Test.stopTest();
    }

    //Requisition with inactive branch
    @isTest
    public static void createRequisitionWithInactiveBranchNegative() {
        Test.startTest();
        Account partner3 = TestDataHelpers.getPartnerAccount('Partner 3');
        dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        try{
            dmpl__PurchaseRequisition__c purchaseRequisition = PurchaseRequisitionTestDataHelpers.CreateRequistion(partner3, branch3, supplier1, null);
            dmpl__PurchaseRequisition__c createdRequisition = PurchaseRequisitionTestDataHelpers.getRequisition(purchaseRequisition);
            System.assertEquals(null, createdRequisition, 'Requisition should not be created with inactive branch');
        }
        catch(Exception e) {
            System.debug('Exception occurred: ' + e.getMessage());
        }
        Test.stopTest();
    }

    //Requisition creation with supplier
    @isTest
    public static void createRequisitionWithSupplierPositive() {
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__PurchaseRequisition__c purchaseRequisition = PurchaseRequisitionTestDataHelpers.CreateRequistion(partner1, branch1, supplier1, null);
        dmpl__PurchaseRequisition__c createdRequisition = PurchaseRequisitionTestDataHelpers.getRequisition(purchaseRequisition);
        Test.stopTest();
        System.assertNotEquals(null, createdRequisition, 'Requisition should be created with supplier');
        System.assertEquals(supplier1.Id, createdRequisition.dmpl__SupplierAccountId__c, 'Supplier Account should match');
    }

    //Requisition created without supplier
    @isTest
    public static void createRequisitionWithoutSupplierPositive() {
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__PurchaseRequisition__c purchaseRequisition = PurchaseRequisitionTestDataHelpers.CreateRequistion(partner1, branch1, null, null);
        dmpl__PurchaseRequisition__c createdRequisition = PurchaseRequisitionTestDataHelpers.getRequisition(purchaseRequisition);
        Test.stopTest();
        System.assertNotEquals(null, createdRequisition, 'Requisition should be created without supplier');
        System.assertEquals(null, createdRequisition.dmpl__SupplierAccountId__c, 'Supplier Account should be null');
    }

    //Requisition created with requested by
    @isTest
    public static void createRequisitionWithRequestedByPositive() {
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__PurchaseRequisition__c purchaseRequisition = PurchaseRequisitionTestDataHelpers.CreateRequistion(partner1, branch1, null, UserInfo.getUserId());
        dmpl__PurchaseRequisition__c createdRequisition = PurchaseRequisitionTestDataHelpers.getRequisition(purchaseRequisition);
        Test.stopTest();
        System.assertNotEquals(null, createdRequisition, 'Requisition should be created with requested by');
        System.assertEquals(UserInfo.getUserId(), createdRequisition.dmpl__RequestedById__c, 'Requested By should match current user');
    }

    //Requisition created without requested by
    @isTest
    public static void createRequisitionWithoutRequestedByPositive() {
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__PurchaseRequisition__c purchaseRequisition = PurchaseRequisitionTestDataHelpers.CreateRequistion(partner1, branch1, null, null);
        dmpl__PurchaseRequisition__c createdRequisition = PurchaseRequisitionTestDataHelpers.getRequisition(purchaseRequisition);
        Test.stopTest();
        System.assertNotEquals(null, createdRequisition, 'Requisition should be created without requested by');
        System.assertEquals(null, createdRequisition.dmpl__RequestedById__c, 'Requested By should be null');
    }
}