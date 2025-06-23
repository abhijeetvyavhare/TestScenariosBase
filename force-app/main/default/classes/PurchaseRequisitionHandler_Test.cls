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
    
}