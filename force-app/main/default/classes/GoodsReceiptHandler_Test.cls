@isTest
private class GoodsReceiptHandler_Test {
    @TestSetup
    static void createRequiredData(){
        dmpl__AccountGroup__c accountGroup=TestDataHelpers.createAccountGroup();
        Account partnerAccount= TestDataHelpers.createPartnerAccount();
        Account customerAccount= TestDataHelpers.createCustomerAccount();
        Account supplierAccount= TestDataHelpers.createSupplierAccount();
        dmpl__Branch__c branch=TestDataHelpers.createBranch(partnerAccount);
        dmpl__ItemGroup__c itemGroup=TestDataHelpers.createItemGroup();
        dmpl__Item__c item=TestDataHelpers.createItem();
        dmpl__StorageLocation__c storageLocation=TestDataHelpers.createStorageLocation(branch);
        dmpl__SKU__c sku=TestDataHelpers.createSKU(item);
        dmpl__ItemLot__c itemLot=TestDataHelpers.createItemLot(branch,item,sku,storageLocation);
        dmpl__PriceList__c priceList=TestDataHelpers.createPriceList(partnerAccount,branch);
        dmpl__TaxGroup__c taxGroup=TestDataHelpers.createTaxGroup(partnerAccount,branch);
        dmpl__PurchaseRequisition__c purchaseRequisition=PurchaseOrderTestDataHelpers.CreatePurchaseRequisition(branch,supplierAccount);
        dmpl__PurchaseOrder__c purchaseOrder=PurchaseOrderTestDataHelpers.createPurchaseOrder(branch,supplierAccount);
        dmpl__PurchaseOrderLine__c purchaseOrderLine=PurchaseOrderTestDataHelpers.createPurchaseOrderLine(item,sku,purchaseOrder,taxGroup,purchaseRequisition);
        dmpl__Shipment__c shipment=ShipmentTestDataHelper.createShipment(supplierAccount,branch,purchaseOrder);
        dmpl__ShipmentLine__c shipmentLine=ShipmentTestDataHelper.createShipmentLine(item,shipment,sku,purchaseOrderLine);
        dmpl__GoodsReceipt__c goodsReceipt=GoodRecieptsTestDataHelpers.createGoodsReceipt(partnerAccount,branch,purchaseOrder,supplierAccount);
        dmpl__GoodsReceiptLine__c grnLine=GoodRecieptsTestDataHelpers.createGoodReceiptLine(goodsReceipt,item,sku);
        dmpl__InspectionLine__c inspectionLine=GoodRecieptsTestDataHelpers.createInspectionLine(item,sku,goodsReceipt);
        
        
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1', false, true, false, true, 'MG Road', 'Bengaluru', 'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India', '560095','9876543210');
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2', false, true, false, false, '45 Residency Road', 'Pune', 'Maharashtra', 'India', '411001', '22 Commerce Avenue', 'Pune', 'Maharashtra', 'India', '411038','91-99665544433');
        Account partnerAccount3 = TestDataHelpers.createPartnerAccount('Partner 3', false, true, false, true, '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '91-9123456789');
        Account partnerAccount4 = TestDataHelpers.createPartnerAccount('Partner 4', false, true, false, true, '12 Industrial Zone', 'Hyderabad','Telangana', 'India', '500032', '12 Industrial Zone', 'Hyderabad', 'Telangana', 'India','500032','9876012345');
        dmpl__Branch__c branch1=TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id, true, true, false, true);
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partnerAccount1.Id, false, true, true, false);
        dmpl__Branch__c branch4 =TestDataHelpers.createBranch('Branch 4',partnerAccount4.Id,true,true,false,false);
        Account supplierAccount1 = TestDataHelpers.createPartnerAccount('Supplier 1', false, false, true, true, '55 Industrial Park Road', 'Ahmedabad', 'GJ', 'India', '380015', '55 Industrial Park Road', 'Ahmedabad', 'GJ', 'India', '380015', '-9988776564');
        Account supplierAccount2=TestDataHelpers.createPartnerAccount('Supplier 2',false, false, true, false,'55 Industrial Park Road', 'Ahmedabad', 'GJ', 'India', '380015', '55 Industrial Park Road', 'Ahmedabad', 'GJ', 'India', '380015', '-9988745587');

        dmpl__Item__c  item1 = TestDataHelpers.createItem('Item 1','Product',true,false,false,'675654',false);
        dmpl__Item__c item2 = TestDataHelpers.createItem('Item 2','Product',false,false,false,'654345',false);
        dmpl__Item__c item3 = TestDataHelpers.createItem('Item 3','Charge Item',true, false, false ,'765434',true);
        dmpl__Item__c item4 = TestDataHelpers.createItem('Item 4','Product',true, false, false ,'765676',true);
        dmpl__Item__c item5 = TestDataHelpers.createItem('Item 5', 'Product', true, false, false, '876543', false);
        dmpl__Item__c item6 = TestDataHelpers.createItem('Item 6', 'Product', true, false, false, '765456', false);
        dmpl__Item__c item7 = TestDataHelpers.createItem('Item 7','Product',true,false,false, '765456',false);
        dmpl__Item__c item8 = TestDataHelpers.createItem('Item 8','Product',true,false,false, '765456',false);
        dmpl__Item__c item10 = TestDataHelpers.createItem('Item 10','Product',true,false,true, '765456',false);
        dmpl__Item__c item13 = TestDataHelpers.createItem('Item 13','Product',true,false,false, '765456',true);
        dmpl__Item__c item14 = TestDataHelpers.createItem('Item 14', 'Part', true, false, false, '765458', true);
        dmpl__Item__c item11= TestDataHelpers.createItem('Item 11', 'Product', true, false, false,'765456', false);
        
        dmpl__TaxGroup__c taxGroupGST18partner1 = TestDataHelpers.createTaxGroup('GST 18', false, 'Line Level', partnerAccount1.Id, branch1.Id, null);
        dmpl__TaxGroup__c taxGroupGST12Global = TestDataHelpers.createTaxGroup('GST 12', true, 'Line Level', null, null, null);
        
        dmpl__Tax__c taxCGST6 = TestDataHelpers.createTax('CGST', 'CGST', 6, taxGroupGST12Global.Id, 'Tax1');
        dmpl__Tax__c taxSGST6 = TestDataHelpers.createTax('SGST', 'SGST', 6, taxGroupGST12Global.Id, 'Tax2');
        dmpl__TaxGroupRule__c taxGroupRule12Item6 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST12Global.Id,item6.Id,null,null,null);
        dmpl__TaxGroupRule__c taxGroupRuleItem1 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST12Global.Id,item1.Id,null,null,null);
                
        dmpl__SKU__c sku1 = TestDataHelpers.createSKU('SKU 1', item7.id, true);
        dmpl__SKU__c sku2 = TestDataHelpers.createSKU('SKU 2', item8.id, false);
        dmpl__SKU__c sku4 = TestDataHelpers.createSKU('SKU 4', item11.id, true);
        
        
        dmpl__StorageLocation__c storageLocation2 = TestDataHelpers.createStorageLocation(
            'Storage Location 2',
        branch1.Id,
        true,
        'Warehouse'
            );
        
        
        
    }
    
    @isTest
    static void createGoodsReceiptPositive() {
        dmpl__GoodsReceipt__c goodsReceipt=GoodRecieptsTestDataHelpers.getGoodsReceipt();
        if(goodsReceipt !=null) {
            System.assertNotEquals(goodsReceipt, null, 'Expected Goods receipt to be created.');
        }
        System.assertEquals( date.today(),goodsReceipt.dmpl__DocumentDate__c, 'Expected Document Date to be today.');
        System.assertEquals( true,goodsReceipt.dmpl__PerformReceive__c, 'Expected Perform Receive to be true.');
        System.assertEquals( true,goodsReceipt.dmpl__PerformInspection__c, 'Expected Perform Inspection to be true.');
        System.assertEquals( true,goodsReceipt.dmpl__PerformInspectionComplete__c, 'Expected Perform Inspection Complete to be true.');
        System.assertEquals( true,goodsReceipt.dmpl__IsInspectionCompleted__c, 'Expected Is Inspection Completed to be true.');
        
        dmpl__GoodsReceiptLine__c grnLine=GoodRecieptsTestDataHelpers.getGoodReceiptLine();
        if(grnLine !=null) {
            System.assertNotEquals(grnLine, null, 'Expected Goods receipt line to be created.');
        }
        System.assertEquals( 1,grnLine.dmpl__ReceivedQuantity__c, 'Expected Quantity Received to be 1.');
        System.assertEquals( 1,grnLine.dmpl__OrderedQuantity__c, 'Expected Quantity Ordered to be 1.');
        System.assertEquals( 1,grnLine.dmpl__SupplierQuantity__c, 'Expected Quantity Supplier to be 1.');
    }
    
    @isTest
    static void updateGoodsReceiptPositive() {
        dmpl__GoodsReceipt__c goodsReceipt=GoodRecieptsTestDataHelpers.getGoodsReceipt();
        System.assertNotEquals(goodsReceipt, null, 'Goods receipt should exist before update.');
        goodsReceipt.dmpl__PerformReceive__c = false;
        goodsReceipt.dmpl__PerformInspection__c = false;
        goodsReceipt.dmpl__PerformInspectionComplete__c = false;
        goodsReceipt.dmpl__IsInspectionCompleted__c = false;
        update goodsReceipt;
        
        dmpl__GoodsReceipt__c updatedGoodsReceipt = GoodRecieptsTestDataHelpers.getGoodsReceipt();
        System.assertEquals( false,goodsReceipt.dmpl__PerformReceive__c, 'Expected Perform Receive to be false.');
        System.assertEquals( false,goodsReceipt.dmpl__PerformInspection__c, 'Expected Perform Inspection to be false.');
        System.assertEquals( false,goodsReceipt.dmpl__PerformInspectionComplete__c, 'Expected Perform Inspection Complete to be false.');
        System.assertEquals( false,goodsReceipt.dmpl__IsInspectionCompleted__c, 'Expected Is Inspection Completed to be false.');
        
        dmpl__GoodsReceiptLine__c grnLine=GoodRecieptsTestDataHelpers.getGoodReceiptLine();
        System.assertNotEquals(grnLine, null, 'Goods receipt line should exist before update.');
        grnLine.dmpl__ReceivedQuantity__c = 2;
        grnLine.dmpl__OrderedQuantity__c = 2;
        grnLine.dmpl__SupplierQuantity__c = 2;
        update grnLine;
        
        dmpl__GoodsReceiptLine__c updatedGRNLine = GoodRecieptsTestDataHelpers.getGoodReceiptLine();
        System.assertEquals( 2,updatedGRNLine.dmpl__ReceivedQuantity__c, 'Expected Quantity Received to be 2.');
        System.assertEquals( 2,updatedGRNLine.dmpl__OrderedQuantity__c, 'Expected Quantity Ordered to be 2.');
        System.assertEquals( 2,updatedGRNLine.dmpl__SupplierQuantity__c, 'Expected Quantity Supplier to be 2.');
    }
    
    @isTest
    static void deleteGoodsReceiptLineNegative() {
        dmpl__GoodsReceiptLine__c grnLine = GoodRecieptsTestDataHelpers.getGoodReceiptLine();
        System.assertNotEquals(null, grnLine, 'GoodsReceiptLine should exist before delete');
        
        Test.startTest();
        try {
            delete grnLine;
            System.assert(false, 'Expected DML exception when deleting GoodsReceiptLine');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY'),
            'Expected CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY error');
            System.assert(e.getMessage().contains('dmpl.GoodsReceiptLineTrigger'),
            'Error should be from GoodsReceiptLineTrigger');
        }
        Test.stopTest();
        
        dmpl__GoodsReceiptLine__c nonDeletedLine = GoodRecieptsTestDataHelpers.getGoodReceiptLine();
        System.assertNotEquals(null, nonDeletedLine, 'GoodsReceiptLine should still exist after failed delete');
    }
    
    /****************************** Goods Recipts ******************************/
    @isTest
    static void createGoodsReceiptWithCorrectPartnerAndBranchPositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__GoodsReceipt__c goodsReceipt;
        try{
            goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partner, branch, null, supplier);
        }catch(Exception e){
            System.Assert.isTrue(false,'Exception not Expected!');
        }
        System.assertEquals(partner.Id, goodsReceipt.dmpl__PartnerAccountId__c, 'Partner Account must match');
        System.assertEquals(branch.Id, goodsReceipt.dmpl__BranchId__c, 'Partner Account must match');
        System.assertEquals(supplier.Id, goodsReceipt.dmpl__SupplierAccountId__c, 'Partner Account must match');
        Test.stopTest();
    }
    @isTest
    static void createGoodsReceiptWithSupplierAccountPositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__GoodsReceipt__c goodsReceipt;
        try{
            goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partner, branch, null, supplier);
        }catch(Exception e){
            System.Assert.isTrue(false,'Exception not Expected!');
        }
        System.assertEquals(partner.Id, goodsReceipt.dmpl__PartnerAccountId__c, 'Partner Account must match');
        System.assertEquals(branch.Id, goodsReceipt.dmpl__BranchId__c, 'Partner Account must match');
        System.assertEquals(supplier.Id, goodsReceipt.dmpl__SupplierAccountId__c, 'Partner Account must match');
        Test.stopTest();
    }
    @isTest
    static void createGoodsReceiptWithWrongPartnerAccountNegative(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__GoodsReceipt__c goodsReceipt;
        try{
            goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partner, branch, null, supplier);
            System.Assert.isTrue(false,'Exception Expected!');
        }catch(Exception e){
            System.Assert.isTrue(true,'Exception Expected!');
        }
        Test.stopTest();
    }
    @isTest
    static void createGoodsReceiptWithInactivePartnerAccountNegative(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 2');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__GoodsReceipt__c goodsReceipt;
        try{
            dmpl__Branch__c branch = TestDataHelpers.createBranch('Branch 2', partner.Id, true, false, true, true);
            goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partner, branch, null, supplier);
            System.Assert.isTrue(false,'Exception Expected!');
        }catch(Exception e){
            System.Assert.isTrue(true,'Exception Expected!');
        }
        Test.stopTest();
    }
    @isTest
    static void createGoodsReceiptWithWrongBranchNegative(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 3');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 3');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__GoodsReceipt__c goodsReceipt;
        try{
            goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partner, branch, null, supplier);
            System.Assert.isTrue(false,'Exception Expected!');
        }catch(Exception e){
            System.Assert.isTrue(true,'Exception Expected!');
        }
        Test.stopTest();
    }
    @isTest
    static void createGoodsReceiptWithInactiveBranchNegative(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 3');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 3');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__GoodsReceipt__c goodsReceipt;
        try{
            goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partner, branch, null, supplier);
            System.Assert.isTrue(false,'Exception Expected!');
        }catch(Exception e){
            System.Assert.isTrue(true,'Exception Expected!');
        }
        Test.stopTest();
    }
    @isTest
    static void createGoodsReceiptWithNoSupplierAccountNegative(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__GoodsReceipt__c goodsReceipt;
        try{
            goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partner, branch, null, null);
            // System.Assert.isTrue(false,'Exception Expected!');
        }catch(Exception e){
            System.Assert.isTrue(true,'Exception Expected!');
        }
        Test.stopTest();
    }
    @isTest
    static void updateGoodsReceiptWithSupplierAccountPositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__GoodsReceipt__c goodsReceipt;
        try{
            goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partner, branch, null, supplier);
        }catch(Exception e){
            System.Assert.isTrue(false,'Exception not Expected!');
        }
        System.assertEquals(partner.Id, goodsReceipt.dmpl__PartnerAccountId__c, 'Partner Account must match');
        System.assertEquals(branch.Id, goodsReceipt.dmpl__BranchId__c, 'Partner Account must match');
        System.assertEquals(supplier.Id, goodsReceipt.dmpl__SupplierAccountId__c, 'Partner Account must match');
        
        try{
            goodsReceipt.dmpl__SupplierAccountId__c = null;
            update goodsReceipt;
            System.Assert.isTrue(false,'Exception Expected!: update must fail');
        }catch(Exception e){
            System.Assert.isTrue(true,'Exception Expected!');
        }
        
        Test.stopTest();
    }
    @isTest
    static void updateGoodsReceiptWithWrongPartnerAccountNegative(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__GoodsReceipt__c goodsReceipt;
        try{
            goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partner, branch, null, supplier);
        }catch(Exception e){
            System.Assert.isTrue(false,'Exception not Expected!');
        }
        System.assertEquals(partner.Id, goodsReceipt.dmpl__PartnerAccountId__c, 'Partner Account must match');
        System.assertEquals(branch.Id, goodsReceipt.dmpl__BranchId__c, 'Partner Account must match');
        System.assertEquals(supplier.Id, goodsReceipt.dmpl__SupplierAccountId__c, 'Partner Account must match');
        
        partner = TestDataHelpers.getPartnerAccount('Partner 3');
        try{
            goodsReceipt.dmpl__PartnerAccountId__c = partner?.Id;
            update goodsReceipt;
            System.Assert.isTrue(false,'Exception Expected!: update must fail');
        }catch(Exception e){
            System.Assert.isTrue(true,'Exception Expected!');
        }
        
        Test.stopTest();
    }
    @isTest
    static void updateGoodsReceiptWithInactivePartnerAccountNegative(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__GoodsReceipt__c goodsReceipt;
        try{
            goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partner, branch, null, supplier);
        }catch(Exception e){
            System.Assert.isTrue(false,'Exception not Expected!');
        }
        System.assertEquals(partner.Id, goodsReceipt.dmpl__PartnerAccountId__c, 'Partner Account must match');
        System.assertEquals(branch.Id, goodsReceipt.dmpl__BranchId__c, 'Partner Account must match');
        System.assertEquals(supplier.Id, goodsReceipt.dmpl__SupplierAccountId__c, 'Partner Account must match');
        
        partner = TestDataHelpers.getPartnerAccount('Partner 2');
        try{
            goodsReceipt.dmpl__PartnerAccountId__c = partner?.Id;
            update goodsReceipt;
            System.Assert.isTrue(false,'Exception Expected!: update must fail');
        }catch(Exception e){
            System.Assert.isTrue(true,'Exception Expected!');
        }
        
        Test.stopTest();
    }
    @isTest
    static void updateGoodsReceiptWithWrongBranchNegative(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__GoodsReceipt__c goodsReceipt;
        try{
            goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partner, branch, null, supplier);
        }catch(Exception e){
            System.Assert.isTrue(false,'Exception not Expected!');
        }
        System.assertEquals(partner.Id, goodsReceipt.dmpl__PartnerAccountId__c, 'Partner Account must match');
        System.assertEquals(branch.Id, goodsReceipt.dmpl__BranchId__c, 'Partner Account must match');
        System.assertEquals(supplier.Id, goodsReceipt.dmpl__SupplierAccountId__c, 'Partner Account must match');
        
        branch = TestDataHelpers.getBranch('Branch 4');
        try{
            goodsReceipt.dmpl__BranchId__c = branch?.Id;
            update goodsReceipt;
            System.Assert.isTrue(false,'Exception Expected!: update must fail');
        }catch(Exception e){
            System.Assert.isTrue(true,'Exception Expected!');
        }
        
        Test.stopTest();
    }
    
    //Goods Receipt line with damage quantity (New)
    @isTest
    static void createGoodsReceiptLineWithDamageQuantityPositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partner, branch, null, supplier);
        dmpl__GoodsReceiptLine__c goodsReceiptLine = GoodRecieptsTestDataHelpers.createGoodsReceiptLine(
            goodsReceipt.Id,
        Item1.Id,
        null,
        null,
        50,
        50,
        5,
        0,
        10
            );
        
        dmpl__GoodsReceipt__c fetchedGoodsReceipt = GoodRecieptsTestDataHelpers.getGoodsReceipt(goodsReceipt.Id);
        dmpl__GoodsReceiptLine__c FetchedGoodsReceiptLine = GoodRecieptsTestDataHelpers.getGoodsReceiptLine(goodsReceiptLine.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedGoodsReceipt.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedGoodsReceipt.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier.Id, fetchedGoodsReceipt.dmpl__SupplierAccountId__c, 'Supplier Account should match');
        System.assertEquals(Date.today(), fetchedGoodsReceipt.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('Draft', fetchedGoodsReceipt.dmpl__Status__c, 'Status should be Draft');
        
        System.assertEquals(item1.Id, FetchedGoodsReceiptLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(50, FetchedGoodsReceiptLine.dmpl__OrderedQuantity__c, 'Ordered Quantity should be 50');
        System.assertEquals(50, FetchedGoodsReceiptLine.dmpl__ReceivedQuantity__c, 'Received Quantity should be 50');
        System.assertEquals(5, FetchedGoodsReceiptLine.dmpl__DamagedQuantity__c, 'Damaged Quantity should be 5');
        System.assertEquals(5, FetchedGoodsReceiptLine.dmpl__ClaimableQuantity__c, 'Claimable Quantity should be 5');
        
    }
    
    
    //Goods Receipt line with damage quantity (Edit)
    @isTest
    static void updateGoodsReceiptLineWithDamageQuantityPositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partner, branch, null, supplier);
        dmpl__GoodsReceiptLine__c goodsReceiptLine = GoodRecieptsTestDataHelpers.createGoodsReceiptLine(
            goodsReceipt.Id,
        Item1.Id,
        null,
        null,
        50,
        50,
        5,
        0,
        10
            );
        
        goodsReceiptLine.dmpl__DamagedQuantity__c = 10;
        Update goodsReceiptLine;
        
        dmpl__GoodsReceipt__c fetchedGoodsReceipt = GoodRecieptsTestDataHelpers.getGoodsReceipt(goodsReceipt.Id);
        dmpl__GoodsReceiptLine__c FetchedGoodsReceiptLine = GoodRecieptsTestDataHelpers.getGoodsReceiptLine(goodsReceiptLine.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedGoodsReceipt.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedGoodsReceipt.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier.Id, fetchedGoodsReceipt.dmpl__SupplierAccountId__c, 'Supplier Account should match');
        System.assertEquals(Date.today(), fetchedGoodsReceipt.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('Draft', fetchedGoodsReceipt.dmpl__Status__c, 'Status should be Draft');
        
        System.assertEquals(item1.Id, FetchedGoodsReceiptLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(50, FetchedGoodsReceiptLine.dmpl__OrderedQuantity__c, 'Ordered Quantity should be 50');
        System.assertEquals(50, FetchedGoodsReceiptLine.dmpl__ReceivedQuantity__c, 'Received Quantity should be 50');
        System.assertEquals(10, FetchedGoodsReceiptLine.dmpl__DamagedQuantity__c, 'Damaged Quantity should be 5');
        System.assertEquals(10, FetchedGoodsReceiptLine.dmpl__ClaimableQuantity__c, 'Claimable Quantity should be 5');
        
    }
    
    //Goods Receipt line without unit cost (New)
    @isTest
    static void createGoodsReceiptLineWithoutUnitCostPositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partner, branch, null, supplier);
        dmpl__GoodsReceiptLine__c goodsReceiptLine = GoodRecieptsTestDataHelpers.createGoodsReceiptLine(
            goodsReceipt.Id,
        Item1.Id,
        null,
        null,
        50,
        50,
        5,
        0,
        null
            );
        
        dmpl__GoodsReceipt__c fetchedGoodsReceipt = GoodRecieptsTestDataHelpers.getGoodsReceipt(goodsReceipt.Id);
        dmpl__GoodsReceiptLine__c FetchedGoodsReceiptLine = GoodRecieptsTestDataHelpers.getGoodsReceiptLine(goodsReceiptLine.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedGoodsReceipt.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedGoodsReceipt.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier.Id, fetchedGoodsReceipt.dmpl__SupplierAccountId__c, 'Supplier Account should match');
        System.assertEquals(Date.today(), fetchedGoodsReceipt.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('Draft', fetchedGoodsReceipt.dmpl__Status__c, 'Status should be Draft');
        
        System.assertEquals(item1.Id, FetchedGoodsReceiptLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(50, FetchedGoodsReceiptLine.dmpl__OrderedQuantity__c, 'Ordered Quantity should be 50');
        System.assertEquals(50, FetchedGoodsReceiptLine.dmpl__ReceivedQuantity__c, 'Received Quantity should be 50');
        System.assertEquals(5, FetchedGoodsReceiptLine.dmpl__DamagedQuantity__c, 'Damaged Quantity should be 5');
        System.assertEquals(5, FetchedGoodsReceiptLine.dmpl__ClaimableQuantity__c, 'Claimable Quantity should be 5');
        
    }
    
    //Goods Receipt line without unit cost (Edit)
    @isTest
    static void updateGoodsReceiptLineWithoutUnitCostPositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partner, branch, null, supplier);
        dmpl__GoodsReceiptLine__c goodsReceiptLine = GoodRecieptsTestDataHelpers.createGoodsReceiptLine(
            goodsReceipt.Id,
        Item1.Id,
        null,
        null,
        50,
        50,
        5,
        0,
        1500
            );
        goodsReceiptLine.dmpl__UnitCost__c = null;
        update goodsReceiptLine;
        
        dmpl__GoodsReceipt__c fetchedGoodsReceipt = GoodRecieptsTestDataHelpers.getGoodsReceipt(goodsReceipt.Id);
        dmpl__GoodsReceiptLine__c FetchedGoodsReceiptLine = GoodRecieptsTestDataHelpers.getGoodsReceiptLine(goodsReceiptLine.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedGoodsReceipt.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedGoodsReceipt.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier.Id, fetchedGoodsReceipt.dmpl__SupplierAccountId__c, 'Supplier Account should match');
        System.assertEquals(Date.today(), fetchedGoodsReceipt.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('Draft', fetchedGoodsReceipt.dmpl__Status__c, 'Status should be Draft');
        
        System.assertEquals(item1.Id, FetchedGoodsReceiptLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(50, FetchedGoodsReceiptLine.dmpl__OrderedQuantity__c, 'Ordered Quantity should be 50');
        System.assertEquals(50, FetchedGoodsReceiptLine.dmpl__ReceivedQuantity__c, 'Received Quantity should be 50');
        System.assertEquals(5, FetchedGoodsReceiptLine.dmpl__DamagedQuantity__c, 'Damaged Quantity should be 5');
        System.assertEquals(5, FetchedGoodsReceiptLine.dmpl__ClaimableQuantity__c, 'Claimable Quantity should be 5');
        
    }
    
    //Goods Receipt line with purchase order line reference (New)
    @isTest
    static void createGoodsReceiptLineWithPurchaseOrderLineReferencePositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c  item6 = TestDataHelpers.getItem('Item 6');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');
        
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch,supplier);
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(item6,null,purchaseOrder,taxGroup);
        purchaseOrderLine.dmpl__Quantity__c = 10;
        purchaseOrderLine.dmpl__UnitCost__c = 2400;
        update purchaseOrderLine;
        
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partner, branch, purchaseOrder, supplier);
        dmpl__GoodsReceiptLine__c goodsReceiptLine = GoodRecieptsTestDataHelpers.createGoodsReceiptLine(
            goodsReceipt.Id,
        item6.Id,
        null,
        purchaseOrderLine.id,
        15,
        15,
        5,
        null,
        2400
            );
        
        
        dmpl__PurchaseOrder__c fetchedPO = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        dmpl__PurchaseOrderLine__c fetchedPOL =PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        
        dmpl__GoodsReceipt__c fetchedGoodsReceipt = GoodRecieptsTestDataHelpers.getGoodsReceipt(goodsReceipt.Id);
        dmpl__GoodsReceiptLine__c FetchedGoodsReceiptLine = GoodRecieptsTestDataHelpers.getGoodsReceiptLine(goodsReceiptLine.Id);
        Test.stopTest();
        
        System.assertEquals('Draft', fetchedPO.dmpl__Status__c, 'PO Status should be Draft');
        System.assertEquals(Date.today(), fetchedPO.dmpl__DocumentDate__c, 'PO Document Date should be today');
        
        System.assertEquals('CGST', fetchedPOL.dmpl__Tax1Name__c, 'Tax1 Name should match');
        System.assertEquals(6, fetchedPOL.dmpl__Tax1Rate__c, 'Tax1 Rate should match');
        System.assertEquals('CGST', fetchedPOL.dmpl__Tax1Type__c, 'Tax1 Type should match');
        
        System.assertEquals(24000, fetchedPO.dmpl__TotalLineBaseAmount__c, 'Total Base Amount should match');
        System.assertEquals(4, fetchedPO.dmpl__TotalSchemeDiscountAmount__c, 'Scheme Discount should be 0');
        System.assertEquals(100, fetchedPO.dmpl__TotalDiscountAmount__c, 'Discount Amount should be 0');
        System.assertEquals(2867.52, fetchedPO.dmpl__TotalLineTaxAmount__c, 'Total Line Tax Amount should match');
        System.assertEquals(2867.52, fetchedPO.dmpl__TotalTaxAmount__c, 'Total Tax Amount should match');
        System.assertEquals(26763.52, fetchedPO.dmpl__TotalLineGrossAmount__c, 'Total Gross Amount should match');
        System.assertEquals(26764.00, fetchedPO.dmpl__OpenAmount__c, 'Open Amount should match');
        
        System.assertEquals(2400, fetchedPOL.dmpl__UnitCost__c, 'Unit Price should match');
        System.assertEquals(1433.76, fetchedPOL.dmpl__Tax1__c, 'Tax1 should match');
        System.assertEquals('CGST', fetchedPOL.dmpl__Tax1Name__c, 'Tax1 Name should match');
        System.assertEquals(6, fetchedPOL.dmpl__Tax1Rate__c, 'Tax1 Rate should match');
        System.assertEquals('CGST', fetchedPOL.dmpl__Tax1Type__c, 'Tax1 Type should match');
        
        System.assertEquals(1433.76, fetchedPOL.dmpl__Tax2__c, 'Tax2 should match');
        System.assertEquals('SGST', fetchedPOL.dmpl__Tax2Name__c, 'Tax2 Name should match');
        System.assertEquals(6, fetchedPOL.dmpl__Tax2Rate__c, 'Tax2 Rate should match');
        System.assertEquals('SGST', fetchedPOL.dmpl__Tax2Type__c, 'Tax2 Type should match');
        
        System.assertEquals(24000, fetchedPOL.dmpl__BaseAmount__c, 'Base Amount should match');
        System.assertEquals(4, fetchedPOL.dmpl__NetSchemeDiscount__c, 'Net Scheme Discount should be 4');
        System.assertEquals(100, fetchedPOL.dmpl__NetDiscount__c, 'Net Discount should be 100');
        System.assertEquals(2867.52, fetchedPOL.dmpl__TaxAmount__c, 'Tax Amount should match');
        System.assertEquals(26763.52, fetchedPOL.dmpl__GrossAmount__c, 'Gross Amount should match');
        
        
        System.assertEquals(partner.Id, fetchedGoodsReceipt.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedGoodsReceipt.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier.Id, fetchedGoodsReceipt.dmpl__SupplierAccountId__c, 'Supplier Account should match');
        System.assertEquals(Date.today(), fetchedGoodsReceipt.dmpl__DocumentDate__c, 'GR Document Date should be today');
        System.assertEquals('Draft', fetchedGoodsReceipt.dmpl__Status__c, 'GR Status should be Draft');
        
        System.assertEquals(goodsReceipt.Id, FetchedGoodsReceiptLine.dmpl__GoodsReceiptId__c, 'Goods Receipt ID should match');
        System.assertEquals(item6.Id, FetchedGoodsReceiptLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(2400, FetchedGoodsReceiptLine.dmpl__UnitCost__c, 'Unit Cost should match');
        System.assertEquals(purchaseOrderLine.Id, FetchedGoodsReceiptLine.dmpl__PurchaseOrderLineId__c, 'POL ID should match');
        
    }
    
    
    // Goods Receipt line with purchase order line reference (Edit)
    @isTest
    static void updateGoodsReceiptLineWithPurchaseOrderLineReferencePositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c  item6 = TestDataHelpers.getItem('Item 6');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch,supplier);
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(item6,null,purchaseOrder,null);
        purchaseOrderLine.dmpl__Quantity__c = 10;
        purchaseOrderLine.dmpl__UnitCost__c = 2400;
        update purchaseOrderLine;
        
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partner, branch, null, supplier);
        dmpl__GoodsReceiptLine__c goodsReceiptLine = GoodRecieptsTestDataHelpers.createGoodsReceiptLine(
            goodsReceipt.Id,
        item6.Id,
        null,
        null,
        15,
        15,
        5,
        null,
        2400
            );
        goodsReceipt.dmpl__PurchaseOrderId__c = purchaseOrder.Id;
        goodsReceiptLine.dmpl__PurchaseOrderLineId__c = purchaseOrderLine.Id;
        Update goodsReceipt;
        Update goodsReceiptLine;
        
        
        dmpl__PurchaseOrder__c fetchedPO = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder.Id);
        dmpl__PurchaseOrderLine__c fetchedPOL =PurchaseOrderTestDataHelpers.getPurchaseOrderLine(purchaseOrderLine.Id);
        
        dmpl__GoodsReceipt__c fetchedGoodsReceipt = GoodRecieptsTestDataHelpers.getGoodsReceipt(goodsReceipt.Id);
        dmpl__GoodsReceiptLine__c FetchedGoodsReceiptLine = GoodRecieptsTestDataHelpers.getGoodsReceiptLine(goodsReceiptLine.Id);
        Test.stopTest();
        
    }
    
    //Goods Receipt line without purchase order line reference (New)
    @isTest
    static void createGoodsReceiptLineWithoutpurchaseOrderLinePositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partner, branch, null, supplier);
        dmpl__GoodsReceiptLine__c goodsReceiptLine = GoodRecieptsTestDataHelpers.createGoodsReceiptLine(
            goodsReceipt.Id,
        Item1.Id,
        null,
        null,
        50,
        50,
        5,
        0,
        1500
            );
        
        dmpl__GoodsReceipt__c fetchedGoodsReceipt = GoodRecieptsTestDataHelpers.getGoodsReceipt(goodsReceipt.Id);
        dmpl__GoodsReceiptLine__c FetchedGoodsReceiptLine = GoodRecieptsTestDataHelpers.getGoodsReceiptLine(goodsReceiptLine.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedGoodsReceipt.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedGoodsReceipt.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier.Id, fetchedGoodsReceipt.dmpl__SupplierAccountId__c, 'Supplier Account should match');
        System.assertEquals(Date.today(), fetchedGoodsReceipt.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('Draft', fetchedGoodsReceipt.dmpl__Status__c, 'Status should be Draft');
        
        System.assertEquals(item1.Id, FetchedGoodsReceiptLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(50, FetchedGoodsReceiptLine.dmpl__OrderedQuantity__c, 'Ordered Quantity should be 50');
        System.assertEquals(50, FetchedGoodsReceiptLine.dmpl__ReceivedQuantity__c, 'Received Quantity should be 50');
        System.assertEquals(5, FetchedGoodsReceiptLine.dmpl__DamagedQuantity__c, 'Damaged Quantity should be 5');
        System.assertEquals(5, FetchedGoodsReceiptLine.dmpl__ClaimableQuantity__c, 'Claimable Quantity should be 5');
        
    }
    
    //Goods Receipt line without purchase order line reference (Edit)
    @isTest
    static void updateGoodsReceiptLineWithoutpurchaseOrderLinePositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch,supplier);
        dmpl__PurchaseOrderLine__c purchaseOrderLine = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(item1,null,purchaseOrder,null);
        purchaseOrderLine.dmpl__Quantity__c = 10;
        purchaseOrderLine.dmpl__UnitCost__c = 2400;
        update purchaseOrderLine;
        
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partner, branch, null, supplier);
        dmpl__GoodsReceiptLine__c goodsReceiptLine = GoodRecieptsTestDataHelpers.createGoodsReceiptLine(
            goodsReceipt.Id,
        Item1.Id,
        null,
        purchaseOrderLine.Id,
        50,
        50,
        5,
        0,
        1500
            );
        
        goodsReceipt.dmpl__PurchaseOrderId__c = null;
        update goodsReceipt;
        goodsReceiptLine.dmpl__PurchaseOrderLineId__c = null;
        Update goodsReceiptLine;
        
        dmpl__GoodsReceipt__c fetchedGoodsReceipt = GoodRecieptsTestDataHelpers.getGoodsReceipt(goodsReceipt.Id);
        dmpl__GoodsReceiptLine__c FetchedGoodsReceiptLine = GoodRecieptsTestDataHelpers.getGoodsReceiptLine(goodsReceiptLine.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedGoodsReceipt.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedGoodsReceipt.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier.Id, fetchedGoodsReceipt.dmpl__SupplierAccountId__c, 'Supplier Account should match');
        System.assertEquals(Date.today(), fetchedGoodsReceipt.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('Draft', fetchedGoodsReceipt.dmpl__Status__c, 'Status should be Draft');
        
        System.assertEquals(item1.Id, FetchedGoodsReceiptLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(50, FetchedGoodsReceiptLine.dmpl__OrderedQuantity__c, 'Ordered Quantity should be 50');
        System.assertEquals(50, FetchedGoodsReceiptLine.dmpl__ReceivedQuantity__c, 'Received Quantity should be 50');
        System.assertEquals(5, FetchedGoodsReceiptLine.dmpl__DamagedQuantity__c, 'Damaged Quantity should be 5');
        System.assertEquals(5, FetchedGoodsReceiptLine.dmpl__ClaimableQuantity__c, 'Claimable Quantity should be 5');
        
    }
    
    //Goods Receipt line with shipment line reference (New)
    @isTest
    static void craeteGoodsReceiptLineWithShipmentLineReference(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Shipment__c shipment  = ShipmentTestDataHelper.createShipment(
            Date.Today(),
        partner.Id,
        branch.Id,
        null,
        null
            );
        
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
            item1,
        shipment,
        null,
        null
            );
        
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partner, branch, null, supplier);
        dmpl__GoodsReceiptLine__c goodsReceiptLine = GoodRecieptsTestDataHelpers.createGoodsReceiptLine(
            goodsReceipt.Id,
        Item1.Id,
        null,
        null,
        50,
        50,
        5,
        0,
        1500
            );
        goodsReceipt.dmpl__ShipmentId__c = shipment.Id;
        goodsReceiptLine.dmpl__ShipmentLineId__c = shipmentLine.Id;
        Update goodsReceipt;
        Update goodsReceiptLine;
        
        dmpl__GoodsReceipt__c fetchedGoodsReceipt = GoodRecieptsTestDataHelpers.getGoodsReceipt(goodsReceipt.Id);
        dmpl__GoodsReceiptLine__c FetchedGoodsReceiptLine = GoodRecieptsTestDataHelpers.getGoodsReceiptLine(goodsReceiptLine.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedGoodsReceipt.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedGoodsReceipt.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier.Id, fetchedGoodsReceipt.dmpl__SupplierAccountId__c, 'Supplier Account should match');
        System.assertEquals(Date.today(), fetchedGoodsReceipt.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('Draft', fetchedGoodsReceipt.dmpl__Status__c, 'Status should be Draft');
        
        System.assertEquals(item1.Id, FetchedGoodsReceiptLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(50, FetchedGoodsReceiptLine.dmpl__OrderedQuantity__c, 'Ordered Quantity should be 50');
        System.assertEquals(50, FetchedGoodsReceiptLine.dmpl__ReceivedQuantity__c, 'Received Quantity should be 50');
        System.assertEquals(5, FetchedGoodsReceiptLine.dmpl__DamagedQuantity__c, 'Damaged Quantity should be 5');
        System.assertEquals(5, FetchedGoodsReceiptLine.dmpl__ClaimableQuantity__c, 'Claimable Quantity should be 5');
        System.assertEquals(shipment.Id, FetchedGoodsReceipt.dmpl__ShipmentId__c, 'Claimable Quantity should be 5');
        System.assertEquals(shipmentLine.Id, FetchedGoodsReceiptLine.dmpl__ShipmentLineId__c, 'Claimable Quantity should be 5');
        
    }
    
    //Goods Receipt line with shipment line reference (Edit)
    
    @isTest
    static void updateGoodsReceiptLineWithShipmentLineReference(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Shipment__c shipment  = ShipmentTestDataHelper.createShipment(
            Date.Today(),
        partner.Id,
        branch.Id,
        null,
        null
            );
        
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
            item1,
        shipment,
        null,
        null
            );
        
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partner, branch, null, supplier);
        dmpl__GoodsReceiptLine__c goodsReceiptLine = GoodRecieptsTestDataHelpers.createGoodsReceiptLine(
            goodsReceipt.Id,
        Item1.Id,
        null,
        null,
        50,
        50,
        5,
        0,
        1500
            );
        goodsReceipt.dmpl__ShipmentId__c = shipment.Id;
        goodsReceiptLine.dmpl__ShipmentLineId__c = shipmentLine.Id;
        Update goodsReceipt;
        Update goodsReceiptLine;
        
        dmpl__GoodsReceipt__c fetchedGoodsReceipt = GoodRecieptsTestDataHelpers.getGoodsReceipt(goodsReceipt.Id);
        dmpl__GoodsReceiptLine__c FetchedGoodsReceiptLine = GoodRecieptsTestDataHelpers.getGoodsReceiptLine(goodsReceiptLine.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedGoodsReceipt.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedGoodsReceipt.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier.Id, fetchedGoodsReceipt.dmpl__SupplierAccountId__c, 'Supplier Account should match');
        System.assertEquals(Date.today(), fetchedGoodsReceipt.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('Draft', fetchedGoodsReceipt.dmpl__Status__c, 'Status should be Draft');
        
        System.assertEquals(item1.Id, FetchedGoodsReceiptLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(50, FetchedGoodsReceiptLine.dmpl__OrderedQuantity__c, 'Ordered Quantity should be 50');
        System.assertEquals(50, FetchedGoodsReceiptLine.dmpl__ReceivedQuantity__c, 'Received Quantity should be 50');
        System.assertEquals(5, FetchedGoodsReceiptLine.dmpl__DamagedQuantity__c, 'Damaged Quantity should be 5');
        System.assertEquals(5, FetchedGoodsReceiptLine.dmpl__ClaimableQuantity__c, 'Claimable Quantity should be 5');
        System.assertEquals(shipment.Id, FetchedGoodsReceipt.dmpl__ShipmentId__c, 'Claimable Quantity should be 5');
        System.assertEquals(shipmentLine.Id, FetchedGoodsReceiptLine.dmpl__ShipmentLineId__c, 'Claimable Quantity should be 5');
        
    }
    
    // Goods Receipt line without shipment line reference (New)
    @isTest
    static void craeteGoodsReceiptLineWithoutShipmentLineReference(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        
        
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partner, branch, null, supplier);
        dmpl__GoodsReceiptLine__c goodsReceiptLine = GoodRecieptsTestDataHelpers.createGoodsReceiptLine(
            goodsReceipt.Id,
        Item1.Id,
        null,
        null,
        50,
        50,
        5,
        0,
        1500
            );
        
        dmpl__GoodsReceipt__c fetchedGoodsReceipt = GoodRecieptsTestDataHelpers.getGoodsReceipt(goodsReceipt.Id);
        dmpl__GoodsReceiptLine__c FetchedGoodsReceiptLine = GoodRecieptsTestDataHelpers.getGoodsReceiptLine(goodsReceiptLine.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedGoodsReceipt.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedGoodsReceipt.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier.Id, fetchedGoodsReceipt.dmpl__SupplierAccountId__c, 'Supplier Account should match');
        System.assertEquals(Date.today(), fetchedGoodsReceipt.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('Draft', fetchedGoodsReceipt.dmpl__Status__c, 'Status should be Draft');
        
        System.assertEquals(item1.Id, FetchedGoodsReceiptLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(50, FetchedGoodsReceiptLine.dmpl__OrderedQuantity__c, 'Ordered Quantity should be 50');
        System.assertEquals(50, FetchedGoodsReceiptLine.dmpl__ReceivedQuantity__c, 'Received Quantity should be 50');
        System.assertEquals(5, FetchedGoodsReceiptLine.dmpl__DamagedQuantity__c, 'Damaged Quantity should be 5');
        System.assertEquals(5, FetchedGoodsReceiptLine.dmpl__ClaimableQuantity__c, 'Claimable Quantity should be 5');
        System.assertEquals(null, FetchedGoodsReceipt.dmpl__ShipmentId__c, 'Claimable Quantity should be 5');
        System.assertEquals(null, FetchedGoodsReceiptLine.dmpl__ShipmentLineId__c, 'Claimable Quantity should be 5');
        
    }
    
    // Goods Receipt line without shipment line reference (Edit)
    @isTest
    static void updateGoodsReceiptLineWithoutShipmentLineReference(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Shipment__c shipment  = ShipmentTestDataHelper.createShipment(
            Date.Today(),
        partner.Id,
        branch.Id,
        null,
        null
            );
        
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
            item1,
        shipment,
        null,
        null
            );
        
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partner, branch, null, supplier);
        dmpl__GoodsReceiptLine__c goodsReceiptLine = GoodRecieptsTestDataHelpers.createGoodsReceiptLine(
        goodsReceipt.Id,
        Item1.Id,
        null,
        null,
        50,
        50,
        5,
        0,
        1500
            );
        goodsReceipt.dmpl__ShipmentId__c = shipment.Id;
        goodsReceiptLine.dmpl__ShipmentLineId__c = shipmentLine.Id;
        Update goodsReceipt;
        Update goodsReceiptLine;
        
        
        goodsReceipt.dmpl__ShipmentId__c = null;
        goodsReceiptLine.dmpl__ShipmentLineId__c = null;
        Update goodsReceipt;
        Update goodsReceiptLine;
        
        
        dmpl__GoodsReceipt__c fetchedGoodsReceipt = GoodRecieptsTestDataHelpers.getGoodsReceipt(goodsReceipt.Id);
        dmpl__GoodsReceiptLine__c FetchedGoodsReceiptLine = GoodRecieptsTestDataHelpers.getGoodsReceiptLine(goodsReceiptLine.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedGoodsReceipt.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedGoodsReceipt.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier.Id, fetchedGoodsReceipt.dmpl__SupplierAccountId__c, 'Supplier Account should match');
        System.assertEquals(Date.today(), fetchedGoodsReceipt.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('Draft', fetchedGoodsReceipt.dmpl__Status__c, 'Status should be Draft');
        
        System.assertEquals(item1.Id, FetchedGoodsReceiptLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(50, FetchedGoodsReceiptLine.dmpl__OrderedQuantity__c, 'Ordered Quantity should be 50');
        System.assertEquals(50, FetchedGoodsReceiptLine.dmpl__ReceivedQuantity__c, 'Received Quantity should be 50');
        System.assertEquals(5, FetchedGoodsReceiptLine.dmpl__DamagedQuantity__c, 'Damaged Quantity should be 5');
        System.assertEquals(5, FetchedGoodsReceiptLine.dmpl__ClaimableQuantity__c, 'Claimable Quantity should be 5');
        System.assertEquals(null, FetchedGoodsReceipt.dmpl__ShipmentId__c, 'Claimable Quantity should be 5');
        System.assertEquals(null, FetchedGoodsReceiptLine.dmpl__ShipmentLineId__c, 'Claimable Quantity should be 5');
        
    }
    
    //Goods Receipt line with received qty > supplier quantity (New)
    @isTest
    static void createGoodsReceiptLineWithReceviedQuantityGreaterThanSupplierQuantiyPositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partner, branch, null, supplier);
        dmpl__GoodsReceiptLine__c goodsReceiptLine = GoodRecieptsTestDataHelpers.createGoodsReceiptLine(
            goodsReceipt.Id,
        Item1.Id,
        null,
        null,
        10  ,
        12,
        null,
        10,
        1500
            );
        
        dmpl__GoodsReceipt__c fetchedGoodsReceipt = GoodRecieptsTestDataHelpers.getGoodsReceipt(goodsReceipt.Id);
        dmpl__GoodsReceiptLine__c FetchedGoodsReceiptLine = GoodRecieptsTestDataHelpers.getGoodsReceiptLine(goodsReceiptLine.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedGoodsReceipt.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch.Id, fetchedGoodsReceipt.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier.Id, fetchedGoodsReceipt.dmpl__SupplierAccountId__c, 'Supplier should match');
        System.assertEquals(Date.today(), fetchedGoodsReceipt.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('Draft', fetchedGoodsReceipt.dmpl__Status__c, 'Status should be Draft');
        
        System.assertEquals(goodsReceipt.Id, FetchedGoodsReceiptLine.dmpl__GoodsReceiptId__c, 'Goods Receipt ID should match');
        System.assertEquals(item1.Id, FetchedGoodsReceiptLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(10, FetchedGoodsReceiptLine.dmpl__OrderedQuantity__c, 'Ordered Quantity should be 10');
        System.assertEquals(12, FetchedGoodsReceiptLine.dmpl__ReceivedQuantity__c, 'Received Quantity should be 12');
        System.assertEquals(2, FetchedGoodsReceiptLine.dmpl__ExcessQuantity__c, 'Excess Quantity should be 2');
        System.assertEquals(1500, FetchedGoodsReceiptLine.dmpl__UnitCost__c, 'Unit Cost should be 1500');
        
    }
    
    //Goods Receipt line with received qty < supplier quantity (New)
    @isTest
    static void createGoodsReceiptLineWithReceviedQuantityLessThanSupplierQuantiyPositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partner, branch, null, supplier);
        dmpl__GoodsReceiptLine__c goodsReceiptLine = GoodRecieptsTestDataHelpers.createGoodsReceiptLine(
            goodsReceipt.Id,
        Item1.Id,
        null,
        null,
        10  ,
        8,
        null,
        10,
        1500
            );
        
        dmpl__GoodsReceipt__c fetchedGoodsReceipt = GoodRecieptsTestDataHelpers.getGoodsReceipt(goodsReceipt.Id);
        dmpl__GoodsReceiptLine__c FetchedGoodsReceiptLine = GoodRecieptsTestDataHelpers.getGoodsReceiptLine(goodsReceiptLine.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedGoodsReceipt.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedGoodsReceipt.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier.Id, fetchedGoodsReceipt.dmpl__SupplierAccountId__c, 'Supplier Account should match');
        System.assertEquals(Date.today(), fetchedGoodsReceipt.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('Draft', fetchedGoodsReceipt.dmpl__Status__c, 'Status should be Draft');
        
        System.assertEquals(goodsReceipt.Id, FetchedGoodsReceiptLine.dmpl__GoodsReceiptId__c, 'Goods Receipt ID should match');
        System.assertEquals(item1.Id, FetchedGoodsReceiptLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(10, FetchedGoodsReceiptLine.dmpl__OrderedQuantity__c, 'Ordered Quantity should be 10');
        System.assertEquals(8, FetchedGoodsReceiptLine.dmpl__ReceivedQuantity__c, 'Received Quantity should be 8');
        System.assertEquals(2, FetchedGoodsReceiptLine.dmpl__ShortageQuantity__c, 'Shortage Quantity should be 2');
        System.assertEquals(2, FetchedGoodsReceiptLine.dmpl__ClaimableQuantity__c, 'Claimable Quantity should be 2');
        System.assertEquals(1500, FetchedGoodsReceiptLine.dmpl__UnitCost__c, 'Unit Cost should be 1500');
        
    }
    
    //Goods Receipt line with received qty > supplier quantity (Edit)
    @isTest
    static void updateGoodsReceiptLineWithReceviedQuantityGreaterThanSupplierQuantiyPositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partner, branch, null, supplier);
        dmpl__GoodsReceiptLine__c goodsReceiptLine = GoodRecieptsTestDataHelpers.createGoodsReceiptLine(
            goodsReceipt.Id,
        Item1.Id,
        null,
        null,
        10  ,
        12,
        null,
        10,
        1500
            );
        goodsReceiptLine.dmpl__ReceivedQuantity__c = 15;
        update goodsReceiptLine;
        
        dmpl__GoodsReceipt__c fetchedGoodsReceipt = GoodRecieptsTestDataHelpers.getGoodsReceipt(goodsReceipt.Id);
        dmpl__GoodsReceiptLine__c FetchedGoodsReceiptLine = GoodRecieptsTestDataHelpers.getGoodsReceiptLine(goodsReceiptLine.Id);
        Test.stopTest();
        
        System.assertEquals(partner.Id, fetchedGoodsReceipt.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedGoodsReceipt.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier.Id, fetchedGoodsReceipt.dmpl__SupplierAccountId__c, 'Supplier Account should match');
        System.assertEquals(Date.today(), fetchedGoodsReceipt.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('Draft', fetchedGoodsReceipt.dmpl__Status__c, 'Status should be Draft');
        
        System.assertEquals(goodsReceipt.Id, FetchedGoodsReceiptLine.dmpl__GoodsReceiptId__c, 'Goods Receipt ID should match');
        System.assertEquals(item1.Id, FetchedGoodsReceiptLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(10, FetchedGoodsReceiptLine.dmpl__OrderedQuantity__c, 'Ordered Quantity should be 10');
        System.assertEquals(15, FetchedGoodsReceiptLine.dmpl__ReceivedQuantity__c, 'Received Quantity should be 15');
        System.assertEquals(5, FetchedGoodsReceiptLine.dmpl__ExcessQuantity__c, 'Excess Quantity should be 5');
        System.assertEquals(1500, FetchedGoodsReceiptLine.dmpl__UnitCost__c, 'Unit Cost should be 1500');
        
    }
    
    //Goods Receipt line with received qty < supplier quantity (Edit)
    @isTest
    static void updateGoodsReceiptLineWithReceviedQuantityLessThanSupplierQuantiyPositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partner, branch, null, supplier);
        dmpl__GoodsReceiptLine__c goodsReceiptLine = GoodRecieptsTestDataHelpers.createGoodsReceiptLine(
            goodsReceipt.Id,
        Item1.Id,
        null,
        null,
        10  ,
        8,
        null,
        10,
        1500
            );
        goodsReceiptLine.dmpl__ReceivedQuantity__c = 7;
        update goodsReceiptLine;
        
        dmpl__GoodsReceipt__c fetchedGoodsReceipt = GoodRecieptsTestDataHelpers.getGoodsReceipt(goodsReceipt.Id);
        dmpl__GoodsReceiptLine__c FetchedGoodsReceiptLine = GoodRecieptsTestDataHelpers.getGoodsReceiptLine(goodsReceiptLine.Id);
        Test.stopTest();
        
        System.assertEquals(partner.Id, fetchedGoodsReceipt.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch.Id, fetchedGoodsReceipt.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier.Id, fetchedGoodsReceipt.dmpl__SupplierAccountId__c, 'Supplier should match');
        System.assertEquals(Date.today(), fetchedGoodsReceipt.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('Draft', fetchedGoodsReceipt.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(goodsReceipt.Id, FetchedGoodsReceiptLine.dmpl__GoodsReceiptId__c, 'Goods Receipt ID should match');
        System.assertEquals(item1.Id, FetchedGoodsReceiptLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(10, FetchedGoodsReceiptLine.dmpl__OrderedQuantity__c, 'Ordered Quantity should be 10');
        System.assertEquals(7, FetchedGoodsReceiptLine.dmpl__ReceivedQuantity__c, 'Received Quantity should be 7');
        System.assertEquals(3, FetchedGoodsReceiptLine.dmpl__ShortageQuantity__c, 'Shortage Quantity should be 3');
        System.assertEquals(3, FetchedGoodsReceiptLine.dmpl__ClaimableQuantity__c, 'Claimable Quantity should be 3');
        System.assertEquals(1500, FetchedGoodsReceiptLine.dmpl__UnitCost__c, 'Unit Cost should be 1500');
        
    }
    
    //Goods Receipt line with storage location (New)
    @isTest
    static void craeteGoodsReceiptLineWithStorageLocationReferencePositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Shipment__c shipment  = ShipmentTestDataHelper.createShipment(
            Date.Today(),
        partner.Id,
        branch.Id,
        null,
        null
            );
        
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
            item1,
        shipment,
        null,
        null
            );
        
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partner, branch, null, supplier);
        dmpl__GoodsReceiptLine__c goodsReceiptLine = GoodRecieptsTestDataHelpers.createGoodsReceiptLine(
            goodsReceipt.Id,
        Item1.Id,
        null,
        null,
        1000,
        1000,
        0,
        1000,
        1500
            );
        
        dmpl__StorageLocation__c storageLocation2 = TestDataHelpers.getStorageLocation('Storage Location 2');
        goodsReceiptLine.dmpl__StorageLocationId__c = storageLocation2.Id;
        Update goodsReceiptLine;
        
        dmpl__GoodsReceipt__c fetchedGoodsReceipt = GoodRecieptsTestDataHelpers.getGoodsReceipt(goodsReceipt.Id);
        dmpl__GoodsReceiptLine__c FetchedGoodsReceiptLine = GoodRecieptsTestDataHelpers.getGoodsReceiptLine(goodsReceiptLine.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedGoodsReceipt.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedGoodsReceipt.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier.Id, fetchedGoodsReceipt.dmpl__SupplierAccountId__c, 'Supplier Account should match');
        System.assertEquals(Date.today(), fetchedGoodsReceipt.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('Draft', fetchedGoodsReceipt.dmpl__Status__c, 'Status should be Draft');
        
        System.assertEquals(item1.Id, FetchedGoodsReceiptLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(1000, FetchedGoodsReceiptLine.dmpl__OrderedQuantity__c, 'Ordered Quantity should be 50');
        System.assertEquals(1000, FetchedGoodsReceiptLine.dmpl__ReceivedQuantity__c, 'Received Quantity should be 50');
        System.assertEquals(0, FetchedGoodsReceiptLine.dmpl__DamagedQuantity__c, 'Damaged Quantity should be 5');
        System.assertEquals(0, FetchedGoodsReceiptLine.dmpl__ClaimableQuantity__c, 'Claimable Quantity should be 5');
        System.assertEquals(storageLocation2.Id, FetchedGoodsReceiptLine.dmpl__StorageLocationId__c, 'Claimable Quantity should be 5');
        
    }
    /////////////
    // Goods Receipt creation with inactive branch (Edit)
    @isTest
    static void updateGoodsReceiptWithInactiveBranchNegative(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__GoodsReceipt__c goodsReceipt;
        try{
            goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partner, branch, null, supplier);
        }catch(Exception e){
            System.Assert.isTrue(false,'Exception not Expected!');
        }
        System.assertEquals(partner.Id, goodsReceipt.dmpl__PartnerAccountId__c, 'Partner Account must match');
        System.assertEquals(branch.Id, goodsReceipt.dmpl__BranchId__c, 'Partner Account must match');
        System.assertEquals(supplier.Id, goodsReceipt.dmpl__SupplierAccountId__c, 'Partner Account must match');
        
        branch = TestDataHelpers.getBranch('Branch 3');
        try{
            goodsReceipt.dmpl__BranchId__c = branch?.Id;
            update goodsReceipt;
            System.Assert.isTrue(false,'Exception Expected!: update must fail');
        }catch(Exception e){
            System.Assert.isTrue(true,'Exception Expected!');
        }
        
        Test.stopTest();
    }


    // Goods Receipt creation with backward Goods Receipt date (New)
    @isTest
    static void createGoodsReceiptLineWithBackwardGoodsReceiptDatePositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        Date backDate = Date.newInstance(2025, 6, 1);
        
        
        
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partner, branch, null, supplier,backDate);
        dmpl__GoodsReceipt__c fetchedGoodsReceipt = GoodRecieptsTestDataHelpers.getGoodsReceipt(goodsReceipt.Id);

        Test.stopTest();
        System.assertEquals(partner.Id, fetchedGoodsReceipt.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedGoodsReceipt.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier.Id, fetchedGoodsReceipt.dmpl__SupplierAccountId__c, 'Supplier Account should match');
        System.assertEquals(backDate, fetchedGoodsReceipt.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('Draft', fetchedGoodsReceipt.dmpl__Status__c, 'Status should be Draft');
    }
    // Goods Receipt creation with backward Goods Receipt date (Edit)
    @isTest
    static void updateGoodsReceiptLineWithBackwardGoodsReceiptDatePositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        Date backDate = Date.newInstance(2025, 6, 13);
        Date backDate1 = Date.newInstance(2025, 6, 10);
        Boolean exceptionThrown=false;

        
        try{
            dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partner, branch, null, supplier);
        goodsReceipt.dmpl__DocumentDate__c=backdate1;
        update goodsReceipt;

        }
        catch(Exception e ){
            exceptionThrown=true;
        }
        Test.stopTest();
        System.assertEquals(true,exceptionThrown,'System should throw exception as document date is not editable');
    }
    @isTest
    static void createGoodsReceiptLineWithPurchaseOrderReferencePositive(){
    Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
    dmpl__Item__c item = TestDataHelpers.getItem('Item 1');

    dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');
    Test.startTest();

    dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(partner, branch, supplier, null, null);
        dmpl__PurchaseOrderLine__c line = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
        purchaseOrder.Id,
        item.Id,
        15
    );

    dmpl__GoodsReceipt__c fetchedGoodsReceipt =GoodRecieptsTestDataHelpers.createGoodsReceipt(partner,branch,purchaseOrder,supplier);
    Test.stopTest();
    System.assertEquals(partner.Id, fetchedGoodsReceipt.dmpl__PartnerAccountId__c, 'Partner Account should match');
    System.assertEquals(branch.Id, fetchedGoodsReceipt.dmpl__BranchId__c, 'Branch should match');
    System.assertEquals(supplier.Id, fetchedGoodsReceipt.dmpl__SupplierAccountId__c, 'Supplier Account should match');
    System.assertEquals(purchaseOrder.Id,fetchedGoodsReceipt.dmpl__PurchaseOrderId__c, 'Document Date should be today');

    }
    // Goods Receipt creation without purchase order reference (New)
    @isTest
    static void createGoodsReceiptLineWithoutPurchaseOrderReferencePositive(){
    Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
    dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
    
    Test.startTest();
    dmpl__GoodsReceipt__c GRLine =GoodRecieptsTestDataHelpers.createGoodsReceipt(partner,branch,null,supplier);
    Test.stopTest();
    }
    @isTest
    static void updateGoodsReceiptLineWithPurchaseOrderReferencePositive(){
    Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
    dmpl__Item__c item = TestDataHelpers.getItem('Item 1');

    dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');
    Test.startTest();

    dmpl__GoodsReceipt__c goodReceipt =GoodRecieptsTestDataHelpers.createGoodsReceipt(partner,branch,null,supplier);

    System.assertEquals(null,goodReceipt.dmpl__PurchaseOrderId__c,'Good receipt without purchase order');

    dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(partner, branch, supplier, null, null);
        dmpl__PurchaseOrderLine__c line = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
        purchaseOrder.Id,
        item.Id,
        15
    );
        dmpl__GoodsReceipt__c GoodsReceiptwithPO = GoodRecieptsTestDataHelpers.getGoodsReceipt(goodReceipt.Id);
        GoodsReceiptwithPO.dmpl__PurchaseOrderId__c=purchaseOrder.Id;
        update GoodsReceiptwithPO;
        dmpl__GoodsReceipt__c fetchedGoodsReceipt = GoodRecieptsTestDataHelpers.getGoodsReceipt(GoodsReceiptwithPO.Id);
    Test.stopTest();
    System.assertEquals(partner.Id, fetchedGoodsReceipt.dmpl__PartnerAccountId__c, 'Partner Account should match');
    System.assertEquals(branch.Id, fetchedGoodsReceipt.dmpl__BranchId__c, 'Branch should match');
    System.assertEquals(supplier.Id, fetchedGoodsReceipt.dmpl__SupplierAccountId__c, 'Supplier Account should match');
    System.assertEquals(purchaseOrder.Id,fetchedGoodsReceipt.dmpl__PurchaseOrderId__c, 'Purchase order should match');
    }
    // Goods Receipt creation without purchase order reference (Edit)
    @isTest
    static void updateGoodsReceiptLineWithOUTPurchaseOrderReferencePositive(){
    Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
    dmpl__Item__c item = TestDataHelpers.getItem('Item 1');

    dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');
    Test.startTest();

    dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(partner, branch, supplier, null, null);
        dmpl__PurchaseOrderLine__c line = PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
        purchaseOrder.Id,
        item.Id,
        15
    );

        dmpl__GoodsReceipt__c goodReceipt =GoodRecieptsTestDataHelpers.createGoodsReceipt(partner,branch,PurchaseOrder,supplier);

        dmpl__GoodsReceipt__c GoodsReceiptwithPO = GoodRecieptsTestDataHelpers.getGoodsReceipt(goodReceipt.Id);
        GoodsReceiptwithPO.dmpl__PurchaseOrderId__c=null;
        update GoodsReceiptwithPO;
        dmpl__GoodsReceipt__c fetchedGoodsReceipt = GoodRecieptsTestDataHelpers.getGoodsReceipt(GoodsReceiptwithPO.Id);
    Test.stopTest();
    System.assertEquals(partner.Id, GoodReceipt.dmpl__PartnerAccountId__c, 'Partner Account should match');
    System.assertEquals(branch.Id, GoodReceipt.dmpl__BranchId__c, 'Branch should match');
    System.assertEquals(supplier.Id, GoodReceipt.dmpl__SupplierAccountId__c, 'Supplier Account should match');
    }

 @isTest
static void updateGoodsReceiptWithNoSupplierAccountPositive() {

    Test.startTest();
    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
    Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
    Boolean exceptionThrown=false;


    dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
        partner,
        branch,
        null,
        supplier        
    );
    
    dmpl__GoodsReceipt__c fetchedGR = GoodRecieptsTestDataHelpers.getGoodsReceipt(goodsReceipt.Id);
    try{    fetchedGR.dmpl__SupplierAccountId__c = null;
    update fetchedGR;
}catch(Exception e){
    exceptionthrown= true;

}
System.assertEquals(true,exceptionThrown,'it should throw exception as field suppiler account is not editable after saving ');
    Test.stopTest();
}
// Goods Receipt creation with shipment reference (New)
@isTest
static void createGoodsReceiptLineWithShipmentReferencePositive(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Date documentDate = System.today();
        Date shipmentDate = System.today();
        
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch1,supplier1);
        
        
        dmpl__Shipment__c shipment  = ShipmentTestDataHelper.createShipment(
        Date.Today(),
        partnerAccount1.Id,
        branch1.Id,
        supplier1.id,
        purchaseOrder.Id
            );
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.CreateGoodReceiptFromShipment(shipment);

        Test.stopTest();
    System.assertEquals(partnerAccount1.Id, shipment.dmpl__PartnerAccountId__c, 'Partner Account should match');
    System.assertEquals(branch1.Id, shipment.dmpl__BranchId__c, 'Branch should match');
    System.assertEquals(supplier1.Id, shipment.dmpl__SupplierAccountId__c, 'Supplier Account should match');
    System.assertEquals(shipment.Id,goodsReceipt.dmpl__ShipmentId__c,'shipment should match');
}
    @isTest
    static void createGoodsReceiptWithoutShipmentReferencePositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partner, branch, null, supplier);

        System.assertEquals(partner.Id, goodsReceipt.dmpl__PartnerAccountId__c, 'Partner Account must match');
        System.assertEquals(branch.Id, goodsReceipt.dmpl__BranchId__c, 'Partner Account must match');
        System.assertEquals(supplier.Id, goodsReceipt.dmpl__SupplierAccountId__c, 'Partner Account must match');
        Test.stopTest();
    }
    @isTest
    static void updateGoodsReceiptWithShipmentReferencePositive() {
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        
        dmpl__Shipment__c shipment  = ShipmentTestDataHelper.createShipment(
        Date.Today(),
        partnerAccount1.Id,
        branch1.Id,
        supplier1.id,
        null
            );
        
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
        item1,
        shipment,
        null,
        null,
        1500,
        1
            );
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
        partnerAccount1,
        branch1,
        null,
        supplier1
        );
        goodsReceipt.dmpl__ShipmentId__c=shipment.Id;
        update goodsReceipt;

        System.assertEquals(partnerAccount1.Id, shipment.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch1.Id, shipment.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier1.Id, shipment.dmpl__SupplierAccountId__c, 'Supplier should match');
        System.assertEquals(Date.today(), shipment.dmpl__ShipmentDate__c, 'Shipment date should be today');
        System.assertEquals(shipment.Id,goodsReceipt.dmpl__ShipmentId__c,'shipment should match');
}
@isTest
static void updateGoodsReceiptWithoutShipmentReferencePositive(){
        Test.startTest();
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Date documentDate = System.today();
        Date shipmentDate = System.today();
        
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch1,supplier1);
        
        
        dmpl__Shipment__c shipment  = ShipmentTestDataHelper.createShipment(
        Date.Today(),
        partnerAccount1.Id,
        branch1.Id,
        supplier1.id,
        purchaseOrder.Id
            );
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.CreateGoodReceiptFromShipment(shipment);
        goodsReceipt.dmpl__ShipmentId__c=null;

        Test.stopTest();
    System.assertEquals(partnerAccount1.Id, shipment.dmpl__PartnerAccountId__c, 'Partner Account should match');
    System.assertEquals(branch1.Id, shipment.dmpl__BranchId__c, 'Branch should match');
    System.assertEquals(supplier1.Id, shipment.dmpl__SupplierAccountId__c, 'Supplier Account should match');
    System.assertEquals(null,goodsReceipt.dmpl__ShipmentId__c,'shipment should match');
}
@isTest
static void createGoodsReceiptWithInactiveSupplierPositive() {
    Test.startTest();

    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
    Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
    dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
    Date today = Date.today();

    dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
        partner,
        branch,
        null, 
        supplier,
        today
    );

    dmpl__GoodsReceiptLine__c goodsReceiptLine = GoodRecieptsTestDataHelpers.createGoodsReceiptLine(
        goodsReceipt.Id,
        item.Id,
        null,       
        null,       
        1000,       
        1000,       
        0,          
        1000,       
        1500        
        );

    dmpl__GoodsReceipt__c fetchedGR = GoodRecieptsTestDataHelpers.getGoodsReceipt(goodsReceipt.Id);
    dmpl__GoodsReceiptLine__c fetchedGRLine = GoodRecieptsTestDataHelpers.getGoodsReceiptLine(goodsReceiptLine.Id);

    Test.stopTest();

    System.assertEquals(partner.Id, fetchedGR.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
    System.assertEquals(branch.Id, fetchedGR.dmpl__BranchId__c, 'Branch should be Branch 1');
    System.assertEquals(supplier.Id, fetchedGR.dmpl__SupplierAccountId__c, 'Supplier Account should be Supplier 1');
    System.assertEquals(today, fetchedGR.dmpl__DocumentDate__c, 'Document Date should be Today');

    System.assertEquals(item.Id, fetchedGRLine.dmpl__ItemId__c, 'Item should be Item 1');
    System.assertEquals(1500, fetchedGRLine.dmpl__UnitCost__c, 'Unit Cost should be 1500');
    System.assertEquals(1000, fetchedGRLine.dmpl__ReceivedQuantity__c, 'Received Quantity should be 1000');
    System.assertEquals(1000, fetchedGRLine.dmpl__OrderedQuantity__c, 'Ordered Quantity should be 1000');
    System.assertEquals(0, fetchedGRLine.dmpl__ShortageQuantity__c, 'Shortage Quantity should be 0');
    System.assertEquals(0, fetchedGRLine.dmpl__DamagedQuantity__c, 'Damaged Quantity should be 0');
    System.assertEquals(0, fetchedGRLine.dmpl__ClaimableQuantity__c, 'Claimable Quantity should be 0');
    System.assertEquals(1000, fetchedGRLine.dmpl__SupplierQuantity__c, 'Supplier Quantity should be 1000');
}
// Goods Receipt creation with inactive supplier (Edit)
@isTest
    static void updateGoodsReceiptWithInactiveSuppilerNegative(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__GoodsReceipt__c goodsReceipt;
        try{
            goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partner, branch, null, supplier);
        }catch(Exception e){
            System.Assert.isTrue(false,'Exception not Expected!');
        }
        System.assertEquals(partner.Id, goodsReceipt.dmpl__PartnerAccountId__c, 'Partner Account must match');
        System.assertEquals(branch.Id, goodsReceipt.dmpl__BranchId__c, 'Partner Account must match');
        System.assertEquals(supplier.Id, goodsReceipt.dmpl__SupplierAccountId__c, 'Partner Account must match');
        
        supplier = TestDataHelpers.getSupplierAccount('Supplier 2');
        try{
            goodsReceipt.dmpl__supplierAccountId__c = supplier?.Id;
            update goodsReceipt;
            System.Assert.isTrue(false,'Exception Expected!: update must fail');
        }catch(Exception e){
            System.Assert.isTrue(true,'Exception Expected!');
        }
        
        Test.stopTest();
    }

@isTest
static void createGoodsReceiptWithRequiredSKUPositive() {
    Test.startTest();

    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
    Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
    dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');

    dmpl__Item__c item = TestDataHelpers.getItem('Item 7');
    Date today = Date.today();

    dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
        partner,
        branch,
        null, 
        supplier,
        today
    );

    dmpl__GoodsReceiptLine__c goodsReceiptLine = GoodRecieptsTestDataHelpers.createGoodsReceiptLine(
        goodsReceipt.Id,
        item.Id,
        sku.Id,       
        null,       
        1000,       
        1000,       
        0,          
        1000,       
        1500        
        );

    dmpl__GoodsReceipt__c fetchedGR = GoodRecieptsTestDataHelpers.getGoodsReceipt(goodsReceipt.Id);
    dmpl__GoodsReceiptLine__c fetchedGRLine = GoodRecieptsTestDataHelpers.getGoodsReceiptLine(goodsReceiptLine.Id);

    Test.stopTest();

    System.assertEquals(partner.Id, fetchedGR.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
    System.assertEquals(branch.Id, fetchedGR.dmpl__BranchId__c, 'Branch should be Branch 1');
    System.assertEquals(supplier.Id, fetchedGR.dmpl__SupplierAccountId__c, 'Supplier Account should be Supplier 1');
    System.assertEquals(today, fetchedGR.dmpl__DocumentDate__c, 'Document Date should be Today');

    System.assertEquals(item.Id, fetchedGRLine.dmpl__ItemId__c, 'Item should be Item 1');
    System.assertEquals(1500, fetchedGRLine.dmpl__UnitCost__c, 'Unit Cost should be 1500');
    System.assertEquals(1000, fetchedGRLine.dmpl__ReceivedQuantity__c, 'Received Quantity should be 1000');
    System.assertEquals(1000, fetchedGRLine.dmpl__OrderedQuantity__c, 'Ordered Quantity should be 1000');
    System.assertEquals(0, fetchedGRLine.dmpl__ShortageQuantity__c, 'Shortage Quantity should be 0');
    System.assertEquals(0, fetchedGRLine.dmpl__DamagedQuantity__c, 'Damaged Quantity should be 0');
    System.assertEquals(0, fetchedGRLine.dmpl__ClaimableQuantity__c, 'Claimable Quantity should be 0');
    System.assertEquals(1000, fetchedGRLine.dmpl__SupplierQuantity__c, 'Supplier Quantity should be 1000');
}
// Goods Receipt line with no required SKU (New)
@isTest
static void createGoodsReceiptWithNoRequiredSKUPositive() {
    Test.startTest();

    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
    Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
    dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
    Date today = Date.today();

    dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
        partner,
        branch,
        null, 
        supplier,
        today
    );

    dmpl__GoodsReceiptLine__c goodsReceiptLine = GoodRecieptsTestDataHelpers.createGoodsReceiptLine(
        goodsReceipt.Id,
        item.Id,
        null,       
        null,       
        1000,       
        1000,       
        0,          
        1000,       
        1500        
        );

    dmpl__GoodsReceipt__c fetchedGR = GoodRecieptsTestDataHelpers.getGoodsReceipt(goodsReceipt.Id);
    dmpl__GoodsReceiptLine__c fetchedGRLine = GoodRecieptsTestDataHelpers.getGoodsReceiptLine(goodsReceiptLine.Id);

    Test.stopTest();

    System.assertEquals(partner.Id, fetchedGR.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
    System.assertEquals(branch.Id, fetchedGR.dmpl__BranchId__c, 'Branch should be Branch 1');
    System.assertEquals(supplier.Id, fetchedGR.dmpl__SupplierAccountId__c, 'Supplier Account should be Supplier 1');
    System.assertEquals(today, fetchedGR.dmpl__DocumentDate__c, 'Document Date should be Today');

    System.assertEquals(item.Id, fetchedGRLine.dmpl__ItemId__c, 'Item should be Item 1');
    System.assertEquals(1500, fetchedGRLine.dmpl__UnitCost__c, 'Unit Cost should be 1500');
    System.assertEquals(1000, fetchedGRLine.dmpl__ReceivedQuantity__c, 'Received Quantity should be 1000');
    System.assertEquals(1000, fetchedGRLine.dmpl__OrderedQuantity__c, 'Ordered Quantity should be 1000');
    System.assertEquals(0, fetchedGRLine.dmpl__ShortageQuantity__c, 'Shortage Quantity should be 0');
    System.assertEquals(0, fetchedGRLine.dmpl__DamagedQuantity__c, 'Damaged Quantity should be 0');
    System.assertEquals(0, fetchedGRLine.dmpl__ClaimableQuantity__c, 'Claimable Quantity should be 0');
    System.assertEquals(1000, fetchedGRLine.dmpl__SupplierQuantity__c, 'Supplier Quantity should be 1000');
}
@isTest
static void createGoodsReceiptWithInactiveItemNegative() {
    Test.startTest();

    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
    Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
    dmpl__Item__c item = TestDataHelpers.getItem('Item 2');
    Date today = Date.today();
    Boolean exceptionThrown=false;

    dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
        partner,
        branch,
        null, 
        supplier,
        today
    );
    try{    
        dmpl__GoodsReceiptLine__c goodsReceiptLine = GoodRecieptsTestDataHelpers.createGoodsReceiptLine(
        goodsReceipt.Id,
        item.Id,
        null,       
        null,       
        1000,       
        1000,       
        0,          
        1000,       
        1500        
        );
    }catch(Exception e){
        exceptionThrown =true;
    }
    Test.stopTest();

    System.assertEquals(true,exceptionThrown, 'Exception to be thrown due to inactive item 2 ');
}
@isTest
static void createGoodsReceiptWithDiscontinuedItemNegative() {
    Test.startTest();

    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
    Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
    dmpl__Item__c item = TestDataHelpers.getItem('Item 4');
    Date today = Date.today();
    Boolean exceptionThrown=false;

    dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
        partner,
        branch,
        null, 
        supplier,
        today
    );
        dmpl__GoodsReceiptLine__c goodsReceiptLine = GoodRecieptsTestDataHelpers.createGoodsReceiptLine(
        goodsReceipt.Id,
        item.Id,
        null,       
        null,       
        1000,       
        1000,       
        0,          
        1000,       
        1500        
        );

    Test.stopTest();
    dmpl__GoodsReceipt__c fetchedGR = GoodRecieptsTestDataHelpers.getGoodsReceipt(goodsReceipt.Id);
    dmpl__GoodsReceiptLine__c fetchedGRLine = GoodRecieptsTestDataHelpers.getGoodsReceiptLine(goodsReceiptLine.Id);
    System.assertEquals(partner.Id, fetchedGR.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
    System.assertEquals(branch.Id, fetchedGR.dmpl__BranchId__c, 'Branch should be Branch 1');
    System.assertEquals(supplier.Id, fetchedGR.dmpl__SupplierAccountId__c, 'Supplier Account should be Supplier 1');
    System.assertEquals(today, fetchedGR.dmpl__DocumentDate__c, 'Document Date should be Today');

}

    // Goods Receipt line with inactive item (Edit)
    @isTest
static void updateGoodsReceiptLineWithInactiveItemNegative() {
    Test.startTest();

    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
    Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
    dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
    dmpl__Item__c item4 = TestDataHelpers.getItem('Item 4');
    Date today = Date.today();
    Boolean exceptionThrown=false;

    dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
        partner,
        branch,
        null, 
        supplier,
        today
    );   
        dmpl__GoodsReceiptLine__c goodsReceiptLine = GoodRecieptsTestDataHelpers.createGoodsReceiptLine(
        goodsReceipt.Id,
        item1.Id,
        null,       
        null,       
        1000,       
        1000,       
        0,          
        1000,       
        1500        
        );
        try{
            goodsReceiptLine.dmpl__ItemId__c=item4.Id;
            update goodsReceiptLine;
    }catch(Exception e){
        exceptionThrown =true;
    }
    Test.stopTest();

    System.assertEquals(true,exceptionThrown, 'Exception to be thrown due to inactive item  ');
}
// Goods Receipt line with discountinued item (Edit)
   @isTest
static void updateGoodsReceiptLineWithDiscontinuedItemNegative() {
    Test.startTest();

    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
    Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
    dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
    dmpl__Item__c item4 = TestDataHelpers.getItem('Item 4');
    Date today = Date.today();
    Boolean exceptionThrown=false;

    dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
        partner,
        branch,
        null, 
        supplier,
        today
    );   
        dmpl__GoodsReceiptLine__c goodsReceiptLine = GoodRecieptsTestDataHelpers.createGoodsReceiptLine(
        goodsReceipt.Id,
        item1.Id,
        null,       
        null,       
        1000,       
        1000,       
        0,          
        1000,       
        1000       
        );
        try{
            goodsReceiptLine.dmpl__ItemId__c=item4.Id;
            update goodsReceiptLine;
    }catch(Exception e){
        exceptionThrown =true;
    }
    Test.stopTest();

    System.assertEquals(true,exceptionThrown, 'Exception to be thrown due to discontinued item  ');
}
// Goods Receipt line with removing required SKU (Edit)
   @isTest
    static void updateGoodsReceiptLineWithRemovingSKUNegative() {
    Test.startTest();

    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
    Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
    dmpl__Item__c item11 = TestDataHelpers.getItem('Item 11');
    dmpl__Item__c item4 = TestDataHelpers.getItem('Item 4');
    dmpl__SKU__c sku4 = TestDataHelpers.getSKU('SKU 4');
    Date today = Date.today();
    Boolean exceptionThrown=false;

    dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
        partner,
        branch,
        null, 
        supplier,
        today
    );   
        dmpl__GoodsReceiptLine__c goodsReceiptLine = GoodRecieptsTestDataHelpers.createGoodsReceiptLine(
        goodsReceipt.Id,
        item11.Id,
        sku4.Id,
        null,
        1000,       
        1000,       
        0,          
        1000,       
        1500       
        );
        try{
            goodsReceiptLine.dmpl__SKUId__c=null;
            update goodsReceiptLine;
    }catch(Exception e){
        exceptionThrown =true;
    }
    Test.stopTest();

    System.assertEquals(true,exceptionThrown, 'Exception to be thrown while editing since item required sku ');
}




// Goods Receipt line with no required SKU (Edit)
@isTest
static void updateGoodsReceiptLineWithNoRequiredSKUNegative() {
    Test.startTest();

    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
    Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
    dmpl__Item__c item = TestDataHelpers.getItem('Item 7');
    dmpl__Item__c item3 = TestDataHelpers.getItem('Item 3');
    dmpl__SKU__c sku1 = TestDataHelpers.getSKU('SKU 1');
    Date today = Date.today();
    Boolean exceptionThrown=false;
    dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(
        partner,
        branch,
        null, 
        supplier,
        today
    );

    dmpl__GoodsReceiptLine__c goodsReceiptLine = GoodRecieptsTestDataHelpers.createGoodsReceiptLine(
        goodsReceipt.Id,
        item.Id,
        sku1.Id,       
        null,       
        5,       
        null,       
        0,          
        null,       
        1000        
        );

    dmpl__GoodsReceipt__c fetchedGR = GoodRecieptsTestDataHelpers.getGoodsReceipt(goodsReceipt.Id);
    dmpl__GoodsReceiptLine__c fetchedGRLine = GoodRecieptsTestDataHelpers.getGoodsReceiptLine(goodsReceiptLine.Id);
    try{    fetchedGRLine.dmpl__ItemId__c=item3.Id;
    fetchedGRLine.dmpl__OrderedQuantity__c=5;
    update fetchedGRLine;}
    catch(Exception e){
        exceptionThrown=true;
    }

    Test.stopTest();
    System.assertEquals(true,exceptionThrown,'exception should be thrown since item is not editable once goods receipt is made');
}
// Goods Receipt line without storage location (New)
@isTest
    static void createGoodsReceiptLineWithoutStorageLocationPositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partner, branch, null, supplier);
        dmpl__GoodsReceiptLine__c goodsReceiptLine = GoodRecieptsTestDataHelpers.createGoodsReceiptLine(
            goodsReceipt.Id,
        Item1.Id,
        null,
        null,
        1000,
        1000,
        0,
        0,
        1500
            );
        
        dmpl__GoodsReceipt__c fetchedGoodsReceipt = GoodRecieptsTestDataHelpers.getGoodsReceipt(goodsReceipt.Id);
        dmpl__GoodsReceiptLine__c FetchedGoodsReceiptLine = GoodRecieptsTestDataHelpers.getGoodsReceiptLine(goodsReceiptLine.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedGoodsReceipt.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedGoodsReceipt.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier.Id, fetchedGoodsReceipt.dmpl__SupplierAccountId__c, 'Supplier Account should match');
        System.assertEquals(Date.today(), fetchedGoodsReceipt.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('Draft', fetchedGoodsReceipt.dmpl__Status__c, 'Status should be Draft');
        
        System.assertEquals(item1.Id, FetchedGoodsReceiptLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(1000, FetchedGoodsReceiptLine.dmpl__OrderedQuantity__c, 'Ordered Quantity should be 50');
        System.assertEquals(1000, FetchedGoodsReceiptLine.dmpl__ReceivedQuantity__c, 'Received Quantity should be 50');
        System.assertEquals(0, FetchedGoodsReceiptLine.dmpl__DamagedQuantity__c, 'Damaged Quantity should be 5');
    }
    // Goods Receipt line with storage location (Edit)
    @isTest
    static void updateGoodsReceiptLineWithStorageLocationPositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__StorageLocation__c storageLocation2 = TestDataHelpers.getStorageLocation('Storage Location 2');
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partner, branch, null, supplier);
        dmpl__GoodsReceiptLine__c goodsReceiptLine = GoodRecieptsTestDataHelpers.createGoodsReceiptLine(
            goodsReceipt.Id,
        Item1.Id,
        null,
        null,
        1000,
        1000,
        0,
        0,
        1500
            );
        goodsReceiptLine.dmpl__StorageLocationId__c=storageLocation2.Id;
        update goodsReceiptLine;
        System.assertEquals(storageLocation2.Id, goodsReceiptLine.dmpl__StorageLocationId__c, ' storage location should match');
        
        dmpl__GoodsReceipt__c fetchedGoodsReceipt = GoodRecieptsTestDataHelpers.getGoodsReceipt(goodsReceipt.Id);
        dmpl__GoodsReceiptLine__c FetchedGoodsReceiptLine = GoodRecieptsTestDataHelpers.getGoodsReceiptLine(goodsReceiptLine.Id);
        FetchedGoodsReceiptLine.dmpl__SupplierQuantity__c=1500;
        FetchedGoodsReceiptLine.dmpl__ReceivedQuantity__c=1500;
        FetchedGoodsReceiptLine.dmpl__OrderedQuantity__c=1500;
        update FetchedGoodsReceiptLine;
    

        Test.stopTest();
        System.assertEquals(partner.Id, fetchedGoodsReceipt.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedGoodsReceipt.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier.Id, fetchedGoodsReceipt.dmpl__SupplierAccountId__c, 'Supplier Account should match');
        System.assertEquals(Date.today(), fetchedGoodsReceipt.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('Draft', fetchedGoodsReceipt.dmpl__Status__c, 'Status should be Draft');
        
        System.assertEquals(item1.Id, FetchedGoodsReceiptLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(1500, FetchedGoodsReceiptLine.dmpl__OrderedQuantity__c, 'Ordered Quantity should be 1500');
        System.assertEquals(1500, FetchedGoodsReceiptLine.dmpl__ReceivedQuantity__c, 'Received Quantity should be 1500');
        System.assertEquals(1500, FetchedGoodsReceiptLine.dmpl__SupplierQuantity__c, 'supplier Quantity should be 1500');
        
    }
    // Goods Receipt line without storage location (Edit)
    @isTest
    static void updateGoodsReceiptLineWithoutStorageLocationPositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__StorageLocation__c storageLocation2 = TestDataHelpers.getStorageLocation('Storage Location 2');
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partner, branch, null, supplier);
        dmpl__GoodsReceiptLine__c goodsReceiptLine = GoodRecieptsTestDataHelpers.createGoodsReceiptLine(
            goodsReceipt.Id,
        Item1.Id,
        null,
        null,
        1000,
        1000,
        0,
        1000,
        1500
            );
        goodsReceiptLine.dmpl__StorageLocationId__c=storageLocation2.Id;
        update goodsReceiptLine;
        System.assertEquals(storageLocation2.Id, goodsReceiptLine.dmpl__StorageLocationId__c, ' storage location should match');
        
        dmpl__GoodsReceipt__c fetchedGoodsReceipt = GoodRecieptsTestDataHelpers.getGoodsReceipt(goodsReceipt.Id);
        dmpl__GoodsReceiptLine__c FetchedGoodsReceiptLine = GoodRecieptsTestDataHelpers.getGoodsReceiptLine(goodsReceiptLine.Id);
        FetchedGoodsReceiptLine.dmpl__SupplierQuantity__c=1500;
        FetchedGoodsReceiptLine.dmpl__ReceivedQuantity__c=1500;
        FetchedGoodsReceiptLine.dmpl__OrderedQuantity__c=1500;
        update FetchedGoodsReceiptLine;
    

        Test.stopTest();
        System.assertEquals(partner.Id, fetchedGoodsReceipt.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedGoodsReceipt.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier.Id, fetchedGoodsReceipt.dmpl__SupplierAccountId__c, 'Supplier Account should match');
        System.assertEquals(Date.today(), fetchedGoodsReceipt.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('Draft', fetchedGoodsReceipt.dmpl__Status__c, 'Status should be Draft');
        
        System.assertEquals(item1.Id, FetchedGoodsReceiptLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(1500, FetchedGoodsReceiptLine.dmpl__OrderedQuantity__c, 'Ordered Quantity should be 1500');
        System.assertEquals(1500, FetchedGoodsReceiptLine.dmpl__ReceivedQuantity__c, 'Received Quantity should be 1500');
        System.assertEquals(1500, FetchedGoodsReceiptLine.dmpl__SupplierQuantity__c, 'supplier Quantity should be 1500');
    }
    // Goods Receipt line without ordered quantity (New)
    @isTest
    static void createGoodsReceiptLineWithoutOrderedQuantityPositive(){
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partner, branch, null, supplier);
        dmpl__GoodsReceiptLine__c goodsReceiptLine = GoodRecieptsTestDataHelpers.createGoodsReceiptLine(
            goodsReceipt.Id,
        Item1.Id,
        null,
        null,
        null,
        1000,
        0,
        0,
        1500
            );
        
        dmpl__GoodsReceipt__c fetchedGoodsReceipt = GoodRecieptsTestDataHelpers.getGoodsReceipt(goodsReceipt.Id);
        dmpl__GoodsReceiptLine__c FetchedGoodsReceiptLine = GoodRecieptsTestDataHelpers.getGoodsReceiptLine(goodsReceiptLine.Id);
        Test.stopTest();
        System.assertEquals(partner.Id, fetchedGoodsReceipt.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedGoodsReceipt.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier.Id, fetchedGoodsReceipt.dmpl__SupplierAccountId__c, 'Supplier Account should match');
        System.assertEquals(Date.today(), fetchedGoodsReceipt.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('Draft', fetchedGoodsReceipt.dmpl__Status__c, 'Status should be Draft');
        
        System.assertEquals(item1.Id, FetchedGoodsReceiptLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(null, FetchedGoodsReceiptLine.dmpl__OrderedQuantity__c, 'Ordered Quantity should be 50');
        System.assertEquals(1000, FetchedGoodsReceiptLine.dmpl__ReceivedQuantity__c, 'Received Quantity should be 50');
        System.assertEquals(0, FetchedGoodsReceiptLine.dmpl__DamagedQuantity__c, 'Damaged Quantity should be 5');
    }


    

    


}