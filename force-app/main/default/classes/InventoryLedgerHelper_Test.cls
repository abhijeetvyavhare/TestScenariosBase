@isTest
public class InventoryLedgerHelper_Test {
    
    @testSetup
    public static void Setup()
    {
        //System.runAs(PostInstallHelper.AssignAdministratorAllPermissions(UserInfo.getUserId())){
            CreateAccountGroup();
            CreateAccount();
            CreateBranch();
            CreateItem();
            CreateSKU();
            CreateItemLot();
            CreateClaim();
            CreateReconciliation();
            CreateProduct();
            CreateClaimBatch();
            CreateAdjustment();
            CreateComplaint();
            CreateComplaintFaultCode();
            CreateItemServiceContract();
            CreateResource();
            CreateAsset();
            CreateServiceBay();
            CreateClaimLine();
            CreateAdjustmentLine();
            PostAdjustment();
        //}
    }
    
  
    @isTest
    public static void UpdateAdjustmentLine()
    {
        test.startTest();
        dmpl__InventoryAdjustmentLine__c adjustmentLine = [Select Id,Name,dmpl__Quantity__c From dmpl__InventoryAdjustmentLine__c LIMIT 1];
        adjustmentLine.dmpl__Quantity__c = 0;
        update adjustmentLine;
        test.stopTest();
        System.assertEquals(0, adjustmentLine.dmpl__Quantity__c, 'Test adjustment Line have 1 updated record');
    }
    
    @isTest
    public static void DeleteAdjustmentLine()
    {
        try{
            test.startTest();
            dmpl__InventoryAdjustmentLine__c AdjustmentLine = [Select Id,Name,dmpl__Quantity__c From dmpl__InventoryAdjustmentLine__c LIMIT 1];
            delete AdjustmentLine;
            test.stopTest();
            System.assertEquals(1, adjustmentLine.dmpl__Quantity__c, 'Test adjustment Line have 1 deleted record');
        }catch(exception e){}
    }
    
    @isTest
    public static void DeleteInventoryLedger()
    {
        try{
        test.startTest();
        dmpl__InventoryLedger__c inventory = [Select Id,Name,dmpl__InventoryLedgerType__c,dmpl__BranchId__c,dmpl__PartnerAccountId__c,dmpl__ItemId__c,dmpl__SKUId__c From dmpl__InventoryLedger__c LIMIT 1];
        if(inventory != null)
            delete inventory;
        test.stopTest();
        System.assertEquals('Adjustment', inventory.dmpl__InventoryLedgerType__c, 'Test inventory ledger have 1 updated record');
        }
        catch(exception e){}
    }
    
    @isTest
    public static void UpdateInventoryLedger()
    {
        //try{
        test.startTest();
        List<dmpl__InventoryStock__c> stock = [Select Id,Name,dmpl__QuantityOnInward__c,dmpl__BranchId__c,dmpl__QuantityTransferOut__c,dmpl__PartnerAccountId__c,dmpl__ItemId__c,dmpl__SKUId__c,dmpl__QuantityInPendingDeliveries__c,dmpl__QuantityInTransit__c,dmpl__QuantityPicked__c,dmpl__QuantityOnOutward__c,dmpl__QuantityOnAllocation__c,dmpl__QuantityTransferIn__c,dmpl__QuantityAssembledIn__c,dmpl__QuantityInPipeline__c,dmpl__QuantityOnFulfillment__c From dmpl__InventoryStock__c LIMIT 1];
        dmpl__InventoryLedger__c inventory = [Select Id,Name,dmpl__Quantity__c,dmpl__PartnerAccountId__c,dmpl__ItemId__c,dmpl__SKUId__c,dmpl__RelatedBranchId__c,dmpl__RelatedPartnerAccountId__c,dmpl__PendingDeliveriesQuantity__c,dmpl__AllocatedQuantity__c,dmpl__PipelineQuantity__c,dmpl__PickedQuantity__c From dmpl__InventoryLedger__c LIMIT 1];
        if(inventory == null || inventory != null)
            inventory.dmpl__Quantity__c = 2;
       // update inventory;
        InventoryStockHelper.getRelatedBranchItemLocation(inventory,stock);
        InventoryStockHelper.unDoTransferOutwardLedgerEntry(inventory,stock[0]);
        InventoryStockHelper.unDoTransferInwardLedgerEntry(inventory,stock[0]);
        InventoryStockHelper.unDoTransitLedgerEntry(inventory,stock[0]);
        InventoryStockHelper.unDoFulfillmentLedgerEntry(inventory,stock[0]);
        InventoryStockHelper.doAssembleLedgerEntry(inventory,stock[0]);
          test.stopTest();
    }
     @isTest
    public static void UpdateInventoryLedger1()
    {
        //try{
        test.startTest();
        List<dmpl__InventoryStock__c> stock = [Select Id,Name,dmpl__QuantityOnInward__c,dmpl__BranchId__c,dmpl__QuantityTransferOut__c,dmpl__PartnerAccountId__c,dmpl__QuantitySoftCommitted__c,dmpl__ItemId__c,dmpl__SKUId__c,dmpl__QuantityInPendingDeliveries__c,dmpl__QuantityInTransit__c,dmpl__QuantityPicked__c,dmpl__QuantityOnOutward__c,dmpl__QuantityOnAllocation__c,dmpl__QuantityTransferIn__c,dmpl__QuantityAssembledIn__c,dmpl__QuantityInPipeline__c,dmpl__QuantityOnFulfillment__c From dmpl__InventoryStock__c LIMIT 1];
        dmpl__InventoryLedger__c inventory = [Select Id,Name,dmpl__Quantity__c,dmpl__SoftCommittedQuantity__c,dmpl__PartnerAccountId__c,dmpl__ItemId__c,dmpl__SKUId__c,dmpl__RelatedBranchId__c,dmpl__RelatedPartnerAccountId__c,dmpl__PendingDeliveriesQuantity__c,dmpl__AllocatedQuantity__c,dmpl__PipelineQuantity__c,dmpl__PickedQuantity__c From dmpl__InventoryLedger__c LIMIT 1];
             InventoryStockHelper.unDoInwardLedgerEntry(inventory,stock[0]);
             InventoryStockHelper.doOutwardLedgerEntry(inventory,stock[0]);
             InventoryStockHelper.unDoOutwardLedgerEntry(inventory,stock[0]);
             InventoryStockHelper.unDoAssembleLedgerEntry(inventory,stock[0]);
             InventoryStockHelper.doFulfillmentLedgerEntry(inventory,stock[0]);
            InventoryStockHelper.doAllocationLedgerEntry(inventory,stock[0]);
        
        test.stopTest();
       // System.assertEquals(2, inventory.dmpl__Quantity__c, 'Test inventory ledger have 1 deleted record');
       // }
        //catch(Exception e){}
    }
    
    private static void CreateAccountGroup()
    {
    	dmpl__AccountGroup__c accountGroup= new dmpl__AccountGroup__c (Name= 'Test-AccountGroup', 
                                                                       dmpl__AccountGroupType__c='Scheme');
        insert accountGroup;
        
    }
    
    private static void CreateAccount()
    {
        List<Account> account = new List<Account>();
        dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c LIMIT 1];
        account.add(new Account(Name = 'Test - Account', 
            					Fax = '09876',
                               Phone = '1234567891',
                               Website = 'www.Dealermatix.com',
                               Type = 'Prospect',
                               dmpl__LastName__c = 'Account',
                               NumberOfEmployees = 2,
                               Industry = 'Education',
                               AnnualRevenue = 1000,
                               Description = 'Accounts added',
                               dmpl__IsPartnerAccount__c = false,
                               dmpl__IsActive__c = True,
                               dmpl__IsTaxExempted__c = True,
                               dmpl__IsSupplierAccount__c = false,
                               dmpl__IsCustomerAccount__c = False,
                               dmpl__PartnerTaxAccountGroupId__c = accountGroup.Id,
                               dmpl__CustomerPriceAccountGroupId__c = accountGroup.Id,
                               dmpl__CustomerDiscountAccountGroupId__c = accountGroup.Id,
                               dmpl__PartnerSchemeAccountGroupId__c = accountGroup.Id,                                
                               dmpl__PartnerPriceAccountGroupId__c = accountGroup.Id,
                               dmpl__PartnerDiscountAccountGroupId__c = accountGroup.Id,
                               dmpl__CustomerSchemeAccountGroupId__c = accountGroup.Id
                               ));
        insert account;
          
        Account partneraccount = new Account(Name = 'Partner-Test-Account',dmpl__IsPartnerAccount__c = True,dmpl__LastName__c = 'Account', dmpl__IsActive__c = true);
        insert partneraccount;
        
        Account supplieraccount = new Account(Name = 'Supplier-Test-Account',dmpl__IsSupplierAccount__c = True,dmpl__LastName__c = 'Account', dmpl__IsActive__c = true);
        insert supplieraccount;
        
        Account customeraccount = new Account(Name = 'Customer-Test-Account',dmpl__IsCustomerAccount__c = True,dmpl__LastName__c = 'Account', dmpl__IsActive__c = true);
        insert customeraccount;
        
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
        
        
        List<dmpl__Branch__c> relatedBranch = new List<dmpl__Branch__c>();
        branch.Add(new dmpl__Branch__c(Name = 'Test-Related-Branch'));
        insert relatedBranch;
    }
    
    private static void CreateItem()
    {
        List<dmpl__Item__c> item = new List<dmpl__Item__c>();
        item.Add(new dmpl__Item__c(Name = 'Test-Item',
                                   dmpl__ItemCode__c = 'DMPL',
                                   dmpl__ItemType__c = '',
                                   dmpl__ItemSubType__c = '',
                                   dmpl__Description__c = '',
                                   dmpl__ItemFamily__c = 'Sample',
                                   dmpl__ItemSegment__c = 'Sample',
                                   dmpl__Make__c = 'Sample',
                                   dmpl__Model__c = 'Sample',
                                   dmpl__TrackInventory__c = true,
                                   dmpl__TrackLots__c = true,
                                   dmpl__IsSKURequired__c = true,
                                   dmpl__RequireInspectionOnReceipt__c = true,
                                   dmpl__RequireInspectionOnDelivery__c = true,
                                   dmpl__AllowService__c = true,
                                   dmpl__TrackAsset__c = true,                               
                                   dmpl__IsActive__c = true,
                                   dmpl__IsRegistrationRequired__c = true,
                                   dmpl__GTIN__c = 'BR123',
                                   dmpl__RFID__c = 'O1234fgh',
                                   dmpl__IsPackage__c = true
        ));
        insert item;
        
    }
    
    private static void CreateSKU()
    {
        List<dmpl__SKU__c> Skus = new List<dmpl__SKU__c>();
        dmpl__Item__c listofitem = [Select Id, Name from dmpl__Item__c];
       
        Skus.add(new dmpl__SKU__c(Name = 'Harrier XMA - Automatic - Orcus White',
                                  dmpl__SKUCode__c = 'Test - SKU - Code',
                                 dmpl__UnitOfMeasureOfConversion__c = 10,
                                 dmpl__ProductColor__c = 'Sample',
                                 dmpl__IsDefault__c = false,
                                 dmpl__QuantityUnitOfMeasure__c ='Sample',
                            	 dmpl__ItemId__c = listofitem.Id
        					));
        insert Skus;
        
    }
    
    private static void CreateItemLot()
    {
        List<dmpl__ItemLot__c> itemLot = new List<dmpl__ItemLot__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id, Name from dmpl__SKU__c];
        itemLot.Add(new dmpl__ItemLot__c(dmpl__BranchId__c = branch.Id,
                                         dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                         dmpl__ItemId__c = item.Id,
                                         dmpl__SKUId__c = sku.Id,
                                         dmpl__BatchNo__c = '12345',
                                         dmpl__SerialNumber__c = '4675',
                                         dmpl__SupplierInvoiceNumber__c = '74985',
                                         dmpl__DateOfReceipt__c = date.today(),
                                         dmpl__DateOfMfg__c = date.today(),
                                         dmpl__TotalCost__c = 100,
                                         dmpl__DateOfSupplierInvoice__c = date.today(),
                                         dmpl__Cost__c = 100
        ));
        insert itemLot;
        
        List<dmpl__ItemLot__c> relatedItemLot = new List<dmpl__ItemLot__c>();
        relatedItemLot.Add(new dmpl__ItemLot__c(dmpl__LandedCost__c = 1000,
                                               dmpl__BranchId__c = branch.Id,
            dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c));
        insert relatedItemLot;
    }
    
    private static void CreateClaim()
    {
        List<dmpl__Claim__c> claim = new List<dmpl__Claim__c>();
        Account account = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        claim.add(new dmpl__Claim__c(dmpl__BranchId__c = branch.Id,
                                     dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                     dmpl__DocumentDate__c = date.today(),
                                     dmpl__SupplierNameId__c = account.Id
                                    ));
        insert claim;
        
    }
    
    private static void CreateProduct()
    {
        List<Product2> product = new List<Product2>();
        product.add(new Product2(Name = 'Test-Product',
                                 ProductCode = '754382',
                                 IsActive = true,
                                 Family = 'none'
                                ));
        insert product;
        
    }
    
    private static void CreateClaimBatch()
    {
        List<dmpl__ClaimBatch__c> claimBatch = new List<dmpl__ClaimBatch__c>();
        Account account = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        Product2 product = [Select Id, Name FROM Product2 LIMIT 1];
        claimBatch.add(new dmpl__ClaimBatch__c(dmpl__BranchId__c = branch.Id,
                                     dmpl__PartnerAccountId__c = partnerAccount.Id,
                                     dmpl__DocumentDate__c = date.today(),
                                     dmpl__SupplierNameId__c = account.Id,
                                     dmpl__ServiceContractId__c = product.Id));
        insert claimBatch;
        
    }
    
    private static void CreateComplaint()
    {
        List<dmpl__Complaint__c> complaint = new List<dmpl__Complaint__c>();
        complaint.add(new dmpl__Complaint__c(Name = 'Complaint-Test',
                                             dmpl__Code__c = '37592',
                                             dmpl__Description__c = ''
                                            
                                            ));
        insert complaint;
        
    }
    
    private static void CreateComplaintFaultCode()
    {
        List<dmpl__ComplaintFault__c> complaintFaultCode = new List<dmpl__ComplaintFault__c>();
        dmpl__Complaint__c complaint = [Select Id,Name FROM dmpl__Complaint__c LIMIT 1];
        complaintFaultCode.add(new dmpl__ComplaintFault__c(Name = 'Test-Complaint-Fault-Code',
                                                              dmpl__ComplaintId__c = complaint.Id
                                                              ));
        insert complaintFaultCode;
        
    }
    
    private static void CreateItemServiceContract()
    {
        List<dmpl__ItemServiceContract__c> serviceContract = new List<dmpl__ItemServiceContract__c>();
        dmpl__Item__c item = [Select Id,Name FROm dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c LIMIT 1];
        serviceContract.add(new dmpl__ItemServiceContract__c(dmpl__ItemId__c = item.Id,
                                                             dmpl__SKUId__c = sku.Id,
                                                             dmpl__MaximumUsageHours__c = 10,
                                                             dmpl__MaximumUsageReading__c = 10,
                                                             dmpl__MinimumUsageHours__c = 10,
                                                             dmpl__MinimumUsageReading__c = 10,
                                                             dmpl__GraceUsageDays__c = 2,
                                                             dmpl__FromDays__c = 2,
                                                             dmpl__GraceUsageHours__c = 5,
                                                             dmpl__GraceUsageReading__c = 5,
                                                             dmpl__ToDays__c = 5
                                                            ));
        insert serviceContract;
        
    }
    
    private static void CreateResource()
    {
        List<dmpl__Resource__c> resource = new List<dmpl__Resource__c>();
        Account partnerAccount = [Select Id,Name From Account LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        resource.add(new dmpl__Resource__c(Name = 'Test - Resource',
                                           dmpl__ResourceType__c = 'Technician',
                                           dmpl__IsActive__c = true,
                                           dmpl__Phone__c = '9999999999',
                                           dmpl__DefaultPartnerAccountId__c = partnerAccount.Id,
                                           dmpl__DefaultBranchId__c = branch.Id
                                          ));
        insert resource;
        
    }
    
    private static void CreateAsset()
    {
        List<Asset> asset = new List<Asset>();
        Account account = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__ItemLot__c itemLot = [Select Id, Name From dmpl__ItemLot__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c LIMIT 1];
        asset.add(new Asset(Name = 'Test-Asset',
                           AccountId = account.Id,
                           dmpl__LastServiceBranchId__c = branch.Id,
                           dmpl__ItemId__c = item.Id,
                           dmpl__ItemLotId__c = itemLot.Id,
                           dmpl__SKUId__c = sku.Id,
                           dmpl__RegistrationNumber__c = 'Axb371',
                           dmpl__SaleDate__c = date.today()
                           ));
        insert asset;
        
    }
    
    private static void CreateServiceBay()
    {
        List<dmpl__ServiceBay__c> serviceBay = new List<dmpl__ServiceBay__c>();
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c];
        serviceBay.add(new dmpl__ServiceBay__c(dmpl__BranchId__c = branch.Id,
                                               Name = 'Test-Service-Bay',
                                               dmpl__ServiceBayType__c = 'Warehouse',
                                               dmpl__AllowInventory__c = true
                                              ));
        insert serviceBay;
       
    }
    
    private static void CreateRepairOrder()
    {
     	List<dmpl__RepairOrder__c> repairOrder = new List<dmpl__RepairOrder__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        Account account = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        dmpl__Item__c item = [Select Id,Name FROM dmpl__Item__c LIMIT 1];
        dmpl__Resource__c resource = [select Id,Name FROM dmpl__Resource__c LIMIT 1];
        Asset asset = [Select Id,Name,AccountId FROM Asset LIMIT 1];
        repairOrder.add(new dmpl__RepairOrder__c(dmpl__BranchId__c = branch.Id,
            									 dmpl__DocumentDate__c = date.today(),
                                                 dmpl__AccountId__c = asset.AccountId,
                                                 dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                 dmpl__PackageServiceId__c = item.Id,
                                                 dmpl__UsageReading__c = 10,
                                                 dmpl__UsageReadingHours__c = 5,
                                                 dmpl__CustomerVoice__c = 'Text',
                                                 dmpl__ServiceAdvisorId__c = resource.Id,
                                                 dmpl__AssetId__c = asset.Id
                                                ));
        insert repairOrder;
        
    }
    
    private static void CreateRepairOrderLine()
    {
        List<dmpl__RepairOrderLine__c> repairOrderLine = new List<dmpl__RepairOrderLine__c>();
        dmpl__RepairOrder__c repairOrder = [Select Id,Name FROM dmpl__RepairOrder__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name FROM dmpl__Item__c LIMIT 1];
		dmpl__Resource__c resource = [select Id,Name FROM dmpl__Resource__c LIMIT 1];
        dmpl__Complaint__c complaint = [Select Id,Name FROM dmpl__Complaint__c LIMIT 1];
        dmpl__ComplaintFault__c complaintfault = [Select Id,Name,dmpl__ComplaintId__c FROM dmpl__ComplaintFault__c LIMIT 1];
        repairOrderLine.add(new dmpl__RepairOrderLine__c(dmpl__ItemId__c = item.Id,
                                                         dmpl__Quantity__c = 5,
                                                         dmpl__UnitPrice__c = 10,
                                                         dmpl__PackageClassification__c = 'Optional Item',
                                                         dmpl__ActionTaken__c = 'Replace',
                                                         dmpl__TechnicianId__c = resource.Id,
                                                         dmpl__WorkStartedBy__c = date.today(),
                                                         dmpl__WorkEndedAt__c = date.today(),
                                                         dmpl__WorkStatus__c = 'Started',
                                                         dmpl__StandardDurationHours__c = 10,
                                                         dmpl__ActualDurationHours__c = 10,
                                                         dmpl__ComplaintCodeId__c = complaint.Id,
                                                         dmpl__ComplaintFaultCodeId__c = complaintfault.Id,
                                                         dmpl__RepairOrderId__c = repairOrder.Id
                                                        ));
        insert repairOrderLine;
        
    }
    
    private static void CreateClaimLine()
    {
        List<dmpl__ClaimLine__c> claimLine = new List<dmpl__ClaimLine__c>();
        Account account = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__Claim__c claim = [Select Id,Name FROM dmpl__Claim__c LIMIT 1];
        dmpl__ClaimBatch__c claimBatch = [Select Id,Name FROM dmpl__ClaimBatch__c LIMIT 1];
        dmpl__Complaint__c complaint = [Select Id,Name FROM dmpl__Complaint__c LIMIT 1];
        dmpl__ComplaintFault__c complaintfault = [Select Id,Name,dmpl__ComplaintId__c FROM dmpl__ComplaintFault__c LIMIT 1];
        dmpl__ItemServiceContract__c serviceContract = [Select Id,Name FROM dmpl__ItemServiceContract__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name FROM dmpl__Item__c LIMIT 1];
        claimLine.add(new dmpl__ClaimLine__c(dmpl__BranchId__c = branch.Id,
                                             dmpl__BatchClaimId__c = claim.Id,
                                             dmpl__ClaimId__c = claim.Id,
                                             dmpl__ItemCode__c = 'bxfs543',
                                     		 dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                             dmpl__ItemId__c = item.Id,
                                             dmpl__ClaimQuantity__c = 2,
                                             dmpl__ClaimType__c = 'Reimbursment',
                                             dmpl__UnitPrice__c =100,
                                     		 dmpl__ApproveQuantity__c = 10,
                                             dmpl__RejectQuantity__c = 2,
                                             dmpl__ClaimBatchId__c = claimBatch.Id,
                                             dmpl__ComplaintId__c = complaintfault.dmpl__ComplaintId__c,
                                             dmpl__ComplaintFaultCodeId__c = complaintfault.Id,
                                             dmpl__ServiceContractId__c = serviceContract.Id
                                    ));
        insert claimLine;
        
    }

	private static void CreateReconciliation()
    {
    	List<dmpl__ClaimReconciliation__c> reconciliation = new List<dmpl__ClaimReconciliation__c>();
        Account account = [Select Id,Name From Account LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        Account supplierAccount = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        reconciliation.add(new dmpl__ClaimReconciliation__c(dmpl__BranchId__c = branch.Id,
                                                       dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                       dmpl__SupplierId__c = supplierAccount.Id,
            										   dmpl__CreditNoteAmount__c = 100));
        insert reconciliation;
        
    }
	    
    private static void CreateAdjustment()
    {
        List<dmpl__InventoryAdjustment__c> adjustment = new List<dmpl__InventoryAdjustment__c>();
        Account account = [Select Id,Name From Account LIMIT 1];
        dmpl__Claim__c claim = [Select Id,Name FROM dmpl__Claim__c LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__ClaimReconciliation__c reconciliation = [Select Id,Name FROM dmpl__ClaimReconciliation__c LIMIt 1];
        dmpl__ClaimBatch__c claimBatch = [Select id,Name FROM dmpl__ClaimBatch__c LIMIT 1];
        adjustment.add(new dmpl__InventoryAdjustment__c(dmpl__BranchId__c = branch.Id,
                                                        dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                        dmpl__DocumentDate__c = date.today(),
                                                        dmpl__ClaimId__c = claim.Id,
                                                        dmpl__ReconciliationId__c = reconciliation.Id,
                                                        dmpl__ClaimBatchId__c = claimBatch.Id
                                                        ));
        insert adjustment;
        
    }
    
    private static void PostAdjustment()
    {
        dmpl__InventoryAdjustment__c adjustment = [Select Id, Name, dmpl__PerformInventoryPosting__c FROM dmpl__InventoryAdjustment__c];
        adjustment.dmpl__PerformInventoryPosting__c = true;
        update adjustment;
    }
    
    private static void CreateAdjustmentLine()
    {
        List<dmpl__InventoryAdjustmentLine__c> adjustmentLine = new List<dmpl__InventoryAdjustmentLine__c>();
        Account account = [Select Id,Name From Account LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__ItemLot__c itemLot = [Select Id, Name From dmpl__ItemLot__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c LIMIT 1];
        dmpl__ClaimLine__c claimLine = [Select Id,Name FROM dmpl__ClaimLine__c LIMIT 1];
        dmpl__InventoryAdjustment__c adjustment = [Select Id, Name FROM dmpl__InventoryAdjustment__c];
        adjustmentLine.Add(new dmpl__InventoryAdjustmentLine__c(dmpl__ItemId__c = item.Id,
                                                                dmpl__InventoryAdjustmentId__c = adjustment.Id,
                                                                dmpl__Quantity__c = 1,
                                                                dmpl__ItemLotId__c = itemLot.Id,
                                                                dmpl__SKUId__c = sku.Id,
                                                                dmpl__ClaimLineId__c = claimLine.Id,
                                                                dmpl__TotalCost__c = 100,
                                                                dmpl__UnitCost__c = 100,
                                                                dmpl__Remarks__c = 'Text'
                                                                ));
        insert adjustmentLine;
        
    }
}