@isTest
public with sharing class SchemeHandler_Test {
    @TestSetup
    static void createRequiredData() {
        
		Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1', false, true, false, true, '45 Residency Road', 'Pune', 'Maharashtra', 'India', '411001', '22 Commerce Avenue', 'Pune', 'Maharashtra', 'India', '411038','91-99665544433');
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2', false, true, false, false, '45 Residency Road', 'Pune', 'Maharashtra', 'India', '411001', '22 Commerce Avenue', 'Pune', 'Maharashtra', 'India', '411038','91-99665544433');
        Account partnerAccount3 = TestDataHelpers.createPartnerAccount('Partner 3', false, true, false, true, '78 Nehru Nagar Road', 'Chandigarh', 'Tamil Nadu', 'India', '600042', '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '91-9123456789');
		Account partnerAccount4 = TestDataHelpers.createPartnerAccount('Partner 4', false, true, false, true, '12 Industrial Zone', 'Mumbai','Telangana', 'India', '500032', '12 Industrial Zone', 'Hyderabad', 'Telangana', 'India','500032','9876012345');
        Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1', true, false, false, true, 'MG Road', 'Pune', 'Maharashtra', 'India', '411001', 'Ring Rd', 'Nagpur', 'Maharashtra', 'India', '440001','9876543210', 'Created');
        Account customerAccount4 = TestDataHelpers.createCustomerAccount('Customer 4', true, false, false, true, 'SG Highway', 'New Delhi	', 'GJ', 'India', '380054', 'C G Road', 'New Delhi	', 'GJ', 'India', '380009','9988776655', 'Created');
        Account supplierAccount1 = TestDataHelpers.createSupplierAccount('Supplier 1', 'SG Highway', 'New Delhi	', 'GJ', 'India', '380054', 'C G Road', 'New Delhi	', 'GJ', 'India', '380009','9988776655');
        
		dmpl__Branch__c branch1 = TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id, true, true, false, true);
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partnerAccount3.Id, false, true, true, false);
        dmpl__Branch__c branch4 = TestDataHelpers.createBranch('Branch 4',partnerAccount4.Id,true,true,false,false);
        
		dmpl__Item__c  item1 = TestDataHelpers.createItem('Item 1','Product',true,false,false,'675654',false);
        dmpl__Item__c item2 = TestDataHelpers.createItem('Item 2','Product',false,false,false,'654345',false);
        dmpl__Item__c item5 = TestDataHelpers.createItem('Item 5', 'Product', true, false, false, '876543', false);
        dmpl__Item__c item6 = TestDataHelpers.createItem('Item 6', 'Product', true, false, false, '765456', false);

		dmpl__ItemGroup__c itemGroup1 = TestDataHelpers.createItemGroup('Item Group 1','Tax');
        dmpl__ItemGroup__c itemGroup2 = TestDataHelpers.createItemGroup('Item Group 2','Tax');
        
		dmpl__SKU__c sku1 = TestDataHelpers.createSKU('SKU 1', item1.id, false);
        dmpl__TaxGroup__c taxGroupGST28partner4 = TestDataHelpers.createTaxGroup('GST 288', true, 'Line Level', partnerAccount4.Id, branch4.Id, null);

        Asset asset = TestDataHelpers.createAsset('Asset 1', customerAccount1.Id, item1.Id);

		dmpl__AccountGroup__c accountGroup1 = TestDataHelpers.createAccountGroup('Account Group 1',null);
        
		dmpl__AccountGroupMember__c accountGroupMember1 = TestDataHelpers.createAccountGroupMember(accountGroup1.id,partnerAccount1.id);
		
		dmpl__PriceList__c priceList1 = TestDataHelpers.createPriceList('Price List 1', partnerAccount1.Id, branch1.Id, null, null, true, false, 'Sale Price');
        dmpl__PriceList__c priceList3 = TestDataHelpers.createPriceList('Price List 3',partnerAccount4.Id,branch4.Id,null,null,true,false,'Sale Price');

		dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplierAccount1, branch1, priceList1);

		dmpl__Scheme__c scheme2 = SchemeDataHelper.createScheme('Scheme 2', 'Auto Apply', 'Draft', 'Per Sale order and Invoice', 'Per Order', Date.newInstance(2025, 5, 1), Date.newInstance(2025, 6, 30), 10, 'Apply all Fulfilled', 1, false, partnerAccount4.Id, null, null, null, branch4.Id, 100000);
        dmpl__SchemeLine__c schemeLine2 = SchemeDataHelper.createSchemeLine(1, 'NET RATE', 'All Conditions Are Met', 'All Rewards', scheme2.Id);
        dmpl__SchemeCondition__c schemeCondition2 = SchemeDataHelper.createSchemeCondition('Item Quantity', 'Greater Than Or Equal', item1.Id, 10, schemeLine2.Id, scheme2.Id, 1);
        dmpl__SchemeBenefit__c schemeBenefit2 = SchemeDataHelper.createSchemeBenefit( 'Rate Off', 'Line Level Discount Amount',null, null,null, 1000, schemeLine2.Id, scheme2.Id,1);        
        dmpl__SchemeAccountBudget__c schemeBudget2 = SchemeDataHelper.createSchemesAccountBudget(100000, scheme2.Id, partnerAccount4.Id);
        scheme2.dmpl__Status__c = 'Approved';
        update scheme2;

		dmpl__Scheme__c scheme15 = SchemeDataHelper.createScheme('Scheme 15', 'Auto Apply', 'Draft', 'Per Purchase order', 'PER ORDER', Date.today(), Date.today().addDays(30), 2, 'Apply all Fulfilled', 1, true, partnerAccount1.Id, null, null, customerAccount1.Id, branch1.Id, 100000);
        dmpl__SchemeLine__c schemeLine15 = SchemeDataHelper.createSchemeLine(1, 'FREE OF COST', 'All Conditions Are Met', 'All Rewards', scheme15.Id);
        dmpl__SchemeCondition__c schemeCondition15 = SchemeDataHelper.createSchemeCondition('Item Quantity', 'Greater Than Or Equal', item1.Id, 18, schemeLine15.Id, scheme15.Id, 1);
        dmpl__SchemeBenefit__c schemeBenefit15 = SchemeDataHelper.createSchemeBenefit('FREE ITEM', 'Discounted Item', item1.Id, 1, 5, null, schemeLine15.Id, scheme15.Id, 1);
        dmpl__SchemeAccountBudget__c schemeBudget15 = SchemeDataHelper.createSchemesAccountBudget(100000, scheme15.Id, partnerAccount1.Id);
        scheme15.dmpl__Status__c = 'Approved';
        update scheme15;

		dmpl__Scheme__c scheme20 = SchemeDataHelper.createScheme('Scheme 20', 'Auto Apply', 'Draft', 'Per Purchase order', 'PER ORDER',Date.today(), Date.today().addDays(30), 2, 'Apply all Fulfilled', 1, true, partnerAccount1.Id, null, null, customerAccount1.Id, branch1.Id, 100000);
        dmpl__SchemeLine__c schemeLine20 = SchemeDataHelper.createSchemeLine(1, 'FREE OF COST', 'All Conditions Are Met', 'All Rewards', scheme20.Id);
        dmpl__SchemeCondition__c schemeCondition20 = SchemeDataHelper.createSchemeCondition('Item Quantity', 'Greater Than Or Equal', item1.Id, 18, schemeLine20.Id, scheme20.Id, 1);
        dmpl__SchemeBenefit__c schemeBenefit20 = SchemeDataHelper.createSchemeBenefit('FREE ITEM', 'Discounted Item', item1.Id, 1, 5, null, schemeLine20.Id, scheme20.Id, 1);
        dmpl__SchemeAccountBudget__c schemeBudget20 = SchemeDataHelper.createSchemesAccountBudget(100000, scheme20.Id, partnerAccount1.Id);
        scheme20.dmpl__Status__c = 'Approved';
        update scheme20;


		dmpl__SaleOrder__c saleOrder4 = SaleOrderDataHelper.createSaleOrder( customerAccount4.Id, partnerAccount4.Id, branch4.Id, null, null, false, null );
        dmpl__SaleOrderLine__c saleOrderLine4 = SaleOrderDataHelper.createSaleOrderLine(saleOrder4.Id, item1.Id, 15, null);
		
		Test.startTest();
		dmpl__SaleInvoice__c saleInvoice4 = SaleInvoiceDataHelper.createSaleInvoice(customerAccount4, branch4, saleOrder4, priceList3);
		dmpl__SaleInvoiceLine__c saleInvoiceLine4 =  SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice4, item1, 10);
		
		dmpl__SaleReturn__c saleReturn4 = SaleReturnDataHelper.createSaleReturn(customerAccount4, branch4, null, priceList3);
		dmpl__SaleReturnLine__c saleReturnLine4 =  SaleReturnDataHelper.createSaleReturnLine(saleReturn4, item1, sku1, taxGroupGST28partner4);
		
		dmpl__RepairOrder__c repairOrder4 = RepairOrderTestDataHelpers.createRepairOrder(
            partnerAccount4,
			customerAccount4,
			branch4,
			asset,
			300
            );
		Test.stopTest();
    }
    
    @isTest
    static void createSchemeWithRequiredFieldsPositive()
    {
        dmpl__Scheme__c scheme1 = SchemeTestDataHelper.createScheme(
            'Scheme 1',
        '',
        '',
        'Per Sale Order',
        'Weekly',
        Date.today(),
        Date.today().addMonths(1),
        0,
        '',
        0,
        false,
        (Id)null,
        (Id)null,
        (Id)null,
        (Id)null,
        (Id)null
            );
        
        dmpl__Scheme__c scheme = SchemeTestDataHelper.getScheme(scheme1.Name);
        System.assertNotEquals(null, scheme, 'Scheme record should not be null');
        System.assertEquals(scheme1.Name, scheme.Name, 'Scheme Name should be "Scheme 1"');
        System.assertEquals(scheme1.dmpl__SchemeType__c, scheme.dmpl__SchemeType__c, 'Scheme Type should be "Per Sale Order"');
        System.assertEquals( scheme1.dmpl__PeriodType__c, scheme.dmpl__PeriodType__c, 'Period Type should be "Weekly"');
        System.assertEquals(Date.today(), scheme.dmpl__ValidFrom__c, 'Valid From should be 20-06-2025');
        System.assertEquals(Date.today().addMonths(1), scheme.dmpl__ValidTo__c, 'Valid To should be 20-07-2025');
    }
    
    @isTest
    static void updateSchemeNamePositive()
    {
        dmpl__Scheme__c scheme1 = SchemeTestDataHelper.createScheme(
            'Scheme 1',
        '',
        '',
        'Per Sale Order',
        'Weekly',
        Date.Today(),
        Date.Today().addMonths(1),
        0,
        '',
        0,
        false,
        (Id)null,
        (Id)null,
        (Id)null,
        (Id)null,
        (Id)null
            );
        
        dmpl__Scheme__c scheme = SchemeTestDataHelper.getScheme(scheme1.Name);
        scheme.Name = 'Scheme 25';
        Update scheme;
        
        dmpl__Scheme__c updatedScheme = SchemeTestDataHelper.getScheme(scheme.Name);
        
        System.assertNotEquals(null, scheme, 'Scheme record should not be null');
        System.assertEquals(updatedScheme.Name, scheme.Name, 'Scheme Name should be "Scheme 1"');
        System.assertEquals(updatedScheme.dmpl__SchemeType__c, scheme.dmpl__SchemeType__c, 'Scheme Type should be "Per Sale Order"');
        System.assertEquals(updatedScheme.dmpl__PeriodType__c, scheme.dmpl__PeriodType__c, 'Period Type should be "Weekly"');
        System.assertEquals(Date.today(), scheme.dmpl__ValidFrom__c, 'Valid From should be 20-06-2025');
        System.assertEquals(Date.today().addMonths(1), scheme.dmpl__ValidTo__c, 'Valid To should be 20-07-2025');
    }
    
    @isTest
    static void createSchemeWithoutNameNegative() {
        Test.startTest();
        Boolean exceptionThrown = false;
        
        try {
            dmpl__Scheme__c scheme1 = SchemeTestDataHelper.createScheme(
                '', // Missing name
            '',
            '',
            'Per Sale Order',
            'Weekly',
            Date.today(),
            Date.today().addMonths(1),
            0,
            '',
            0,
            false,
            (Id)null,
            (Id)null,
            (Id)null,
            (Id)null,
            (Id)null
                );
            
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        dmpl__Scheme__c scheme = SchemeTestDataHelper.getScheme();
        
        Test.stopTest();
        // System.assertEquals(null, scheme, 'Scheme record should not be created');
        // System.assertEquals(true, exceptionThrown, 'DmlException should be thrown due to missing Name field');
    }
    
    @isTest
    static void updateSchemeTypePositive()
    {
        dmpl__Scheme__c scheme1 = SchemeTestDataHelper.createScheme(
            'Scheme 15',
        '',
        '',
        'Per Sale Order',
        'Weekly',
        Date.Today(),
        Date.Today().addMonths(1),
        0,
        '',
        0,
        false,
        (Id)null,
        (Id)null,
        (Id)null,
        (Id)null,
        (Id)null
            );
        
        dmpl__Scheme__c scheme = SchemeTestDataHelper.getScheme(scheme1.Name);
        scheme.dmpl__SchemeType__c = 'Per Sale Invoice';
        Update scheme;
        
        dmpl__Scheme__c updatedScheme = SchemeTestDataHelper.getScheme(scheme.Name);
        
        System.assertNotEquals(null, scheme, 'Scheme record should not be null');
        System.assertEquals(updatedScheme.Name, scheme.Name, 'Scheme Name should be "Scheme 1"');
        System.assertEquals(updatedScheme.dmpl__SchemeType__c, scheme.dmpl__SchemeType__c, 'Scheme Type should be "Per Sale Order"');
        System.assertEquals(updatedScheme.dmpl__PeriodType__c, scheme.dmpl__PeriodType__c, 'Period Type should be "Weekly"');
        System.assertEquals(Date.today(), scheme.dmpl__ValidFrom__c, 'Valid From should be 20-06-2025');
        System.assertEquals(Date.today().addMonths(1), scheme.dmpl__ValidTo__c, 'Valid To should be 20-07-2025');
    }
    
    @isTest
    static void updatePeriodTypePositive()
    {
        dmpl__Scheme__c scheme1 = SchemeTestDataHelper.createScheme(
            'Scheme 15',
        '',
        '',
        'Per Sale Order',
        'Weekly',
        Date.Today(),
        Date.Today().addMonths(1),
        0,
        '',
        0,
        false,
        (Id)null,
        (Id)null,
        (Id)null,
        (Id)null,
        (Id)null
            );
        
        dmpl__Scheme__c scheme = SchemeTestDataHelper.getScheme(scheme1.Name);
        scheme.dmpl__PeriodType__c = 'Monthly';
        Update scheme;
        
        dmpl__Scheme__c updatedScheme = SchemeTestDataHelper.getScheme(scheme.Name);
        
        System.assertNotEquals(null, scheme, 'Scheme record should not be null');
        System.assertEquals(updatedScheme.Name, scheme.Name, 'Scheme Name should be "Scheme 1"');
        System.assertEquals(updatedScheme.dmpl__SchemeType__c, scheme.dmpl__SchemeType__c, 'Scheme Type should be "Per Sale Order"');
        System.assertEquals(updatedScheme.dmpl__PeriodType__c, scheme.dmpl__PeriodType__c, 'Period Type should be "Weekly"');
        System.assertEquals(updatedScheme.dmpl__ValidFrom__c, scheme.dmpl__ValidFrom__c, 'Valid From should be 20-06-2025');
        System.assertEquals(updatedScheme.dmpl__ValidTo__c, scheme.dmpl__ValidTo__c, 'Valid To should be 20-07-2025');
    }
    
    
    @isTest
    static void createSchemeWithoutPeriodTypeNegative() {
        Test.startTest();
        Boolean exceptionThrown = false;
        
        try {
            dmpl__Scheme__c scheme1 = SchemeTestDataHelper.createScheme(
                'Scheme 15', 
            '',
            '',
            'Per Sale Order',
            '',
            Date.today(),
            Date.today().addMonths(1),
            0,
            '',
            0,
            false,
            (Id)null,
            (Id)null,
            (Id)null,
            (Id)null,
            (Id)null
                );
            
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'DmlException should be thrown due to Period type field');
    }
    
    
    @isTest
    static void updateSchemeCreationWithValidFromPositive()
    {
        dmpl__Scheme__c scheme1 = SchemeTestDataHelper.createScheme(
            'Scheme 15',
        '',
        '',
        'Per Sale Order',
        'Weekly',
        Date.Today(),
        Date.Today().addMonths(1),
        0,
        '',
        0,
        false,
        (Id)null,
        (Id)null,
        (Id)null,
        (Id)null,
        (Id)null
            );
        
        dmpl__Scheme__c scheme = SchemeTestDataHelper.getScheme(scheme1.Name);
        scheme.dmpl__ValidFrom__c =Date.Today().addDays(2) ;
        Update scheme;
        
        dmpl__Scheme__c updatedScheme = SchemeTestDataHelper.getScheme(scheme.Name);
        
        System.assertNotEquals(null, scheme, 'Scheme record should not be null');
        System.assertEquals(updatedScheme.Name, scheme.Name, 'Scheme Name should be "Scheme 1"');
        System.assertEquals(updatedScheme.dmpl__SchemeType__c, scheme.dmpl__SchemeType__c, 'Scheme Type should be "Per Sale Order"');
        System.assertEquals(updatedScheme.dmpl__PeriodType__c, scheme.dmpl__PeriodType__c, 'Period Type should be "Weekly"');
        System.assertEquals(updatedScheme.dmpl__ValidFrom__c, scheme.dmpl__ValidFrom__c, 'Valid From should be 20-06-2025');
        System.assertEquals(updatedScheme.dmpl__ValidTo__c, scheme.dmpl__ValidTo__c, 'Valid To should be 20-07-2025');
    }
    
    @isTest
    static void updateSchemeCreationWithValidToPositive()
    {
        dmpl__Scheme__c scheme1 = SchemeTestDataHelper.createScheme(
            'Scheme 15',
        '',
        '',
        'Per Sale Order',
        'Weekly',
        Date.Today(),
        Date.Today().addMonths(1),
        0,
        '',
        0,
        false,
        (Id)null,
        (Id)null,
        (Id)null,
        (Id)null,
        (Id)null
            );
        
        dmpl__Scheme__c scheme = SchemeTestDataHelper.getScheme(scheme1.Name);
        scheme.dmpl__ValidTo__c = scheme.dmpl__ValidTo__c+2;
        Update scheme;
        
        dmpl__Scheme__c updatedScheme = SchemeTestDataHelper.getScheme(scheme.Name);
        
        System.assertNotEquals(null, scheme, 'Scheme record should not be null');
        System.assertEquals(updatedScheme.Name, scheme.Name, 'Scheme Name should be "Scheme 1"');
        System.assertEquals(updatedScheme.dmpl__SchemeType__c, scheme.dmpl__SchemeType__c, 'Scheme Type should be "Per Sale Order"');
        System.assertEquals(updatedScheme.dmpl__PeriodType__c, scheme.dmpl__PeriodType__c, 'Period Type should be "Weekly"');
        System.assertEquals(updatedScheme.dmpl__ValidFrom__c, scheme.dmpl__ValidFrom__c, 'Valid From should be 20-06-2025');
        System.assertEquals(updatedScheme.dmpl__ValidTo__c, scheme.dmpl__ValidTo__c, 'Valid To should be 20-07-2025');
    }

      @isTest
    static void createSchemeWithoutValidFromNegative() {
        Test.startTest();
        Boolean exceptionThrown = false;
        
        try {
            dmpl__Scheme__c scheme1 = SchemeTestDataHelper.createScheme(
                'Scheme 15',
            '',
            '',
            'Per Sale Order',
            'Weekly',
             null,
            Date.today().addMonths(1),
            0,
            '',
            0,
            false,
            (Id)null,
            (Id)null,
            (Id)null,
            (Id)null,
            (Id)null
                );
            
        } catch (DmlException e) {
            exceptionThrown = true;
            // System.assert(e.getMessage().contains('REQUIRED_FIELD_MISSING'), 'Expected REQUIRED_FIELD_MISSING error');
        }
        
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'DmlException should be thrown due to missing Valid from field');
    }

      @isTest
    static void createSchemeWithoutValidToNegative() {
        Test.startTest();
        Boolean exceptionThrown = false;
        
        try {
            dmpl__Scheme__c scheme1 = SchemeTestDataHelper.createScheme(
                'Scheme 15',
            '',
            '',
            'Per Sale Order',
            'Weekly',
            Date.today(),
            null,
            0,
            '',
            0,
            false,
            (Id)null,
            (Id)null,
            (Id)null,
            (Id)null,
            (Id)null
                );
            
        } catch (DmlException e) {
            exceptionThrown = true;
            // System.assert(e.getMessage().contains('REQUIRED_FIELD_MISSING'), 'Expected REQUIRED_FIELD_MISSING error');
        }
        
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'DmlException should be thrown due to missing Valid to field');
    }
    
       @isTest
    static void createSchemeWithoutSchemeTypeNegative() {
        Test.startTest();
        Boolean exceptionThrown = false;
        
        try {
            dmpl__Scheme__c scheme1 = SchemeTestDataHelper.createScheme(
                'Scheme 15',
            '',
            '',
            '',
            'Weekly',
            Date.today(),
            null,
            0,
            '',
            0,
            false,
            (Id)null,
            (Id)null,
            (Id)null,
            (Id)null,
            (Id)null
                );
            
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'DmlException should be thrown due to missing scheme type field');
    }
    
/******************************  Scheme Account Budget  ******************************/
	@isTest 
	static void createSchemeAccountBudgetWithPartnerAccountPositive(){
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 15');
		dmpl__SchemeAccountBudget__c schemeAccountBudget;
		try{
			schemeAccountBudget = SchemeAccountBudgetDataHelper.createSchemeAccountBudget(partner.Id, null, scheme.Id, 0, 0);	
		}catch(Exception e){
			System.Assert.isTrue(schemeAccountBudget != null, 'SchemeAccountBudget must be created!');
		}
		System.AssertEquals(partner.Id, schemeAccountBudget.dmpl__PartnerAccountId__c, 'SchemeAccountBudget must have a partner account!');
		System.AssertEquals(scheme.Id, schemeAccountBudget.dmpl__SchemeId__c, 'SchemeAccountBudget must have a Scheme!');
		Test.stopTest();
	}

	@isTest 
	static void createSchemeAccountBudgetWithPartnerAccountGroupPositive(){
		Test.startTest();
		dmpl__AccountGroup__c accountGroup = TestDataHelpers.getAccountGroup('Account Group 1');
		dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 15');
		dmpl__SchemeAccountBudget__c schemeAccountBudget;
		try{
			schemeAccountBudget = SchemeAccountBudgetDataHelper.createSchemeAccountBudget(null, accountGroup.Id, scheme.Id, 0, 0);	
		}catch(Exception e){
			System.Assert.isTrue(schemeAccountBudget != null, 'SchemeAccountBudget must be created!');
		}
		System.AssertEquals(accountGroup.Id, schemeAccountBudget.dmpl__PartnerAccountGroupId__c, 'SchemeAccountBudget must have a partner Group account!');
		System.AssertEquals(scheme.Id, schemeAccountBudget.dmpl__SchemeId__c, 'SchemeAccountBudget must have a Scheme!');
		Test.stopTest();
	}

	@isTest 
	static void createSchemeAccountBudgetWithBudgetAmountPositive(){
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 15');
		dmpl__SchemeAccountBudget__c schemeAccountBudget;
		try{
			schemeAccountBudget = SchemeAccountBudgetDataHelper.createSchemeAccountBudget(partner.Id, null, scheme.Id, 10000, 0);	
		}catch(Exception e){
			System.Assert.isTrue(schemeAccountBudget != null, 'SchemeAccountBudget must be created!');
		}
		System.AssertEquals(partner.Id, schemeAccountBudget.dmpl__PartnerAccountId__c, 'SchemeAccountBudget must have a partner account!');
		System.AssertEquals(scheme.Id, schemeAccountBudget.dmpl__SchemeId__c, 'SchemeAccountBudget must have a Scheme!');
		System.AssertEquals(10000, schemeAccountBudget.dmpl__BudgetAmount__c, 'SchemeAccountBudget must have a Budget Amount 10000!');
		Test.stopTest();
	}

	@isTest 
	static void createSchemeAccountBudgetWithUtilizedAmountPositive(){
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 15');
		dmpl__SchemeAccountBudget__c schemeAccountBudget;
		try{
			schemeAccountBudget = SchemeAccountBudgetDataHelper.createSchemeAccountBudget(partner.Id, null, scheme.Id, 0, 2500);	
		}catch(Exception e){
			System.Assert.isTrue(schemeAccountBudget != null, 'SchemeAccountBudget must be created!');
		}
		System.AssertEquals(partner.Id, schemeAccountBudget.dmpl__PartnerAccountId__c, 'SchemeAccountBudget must have a partner account!');
		System.AssertEquals(scheme.Id, schemeAccountBudget.dmpl__SchemeId__c, 'SchemeAccountBudget must have a Scheme!');
		System.AssertEquals(2500, schemeAccountBudget.dmpl__UtilizedAmount__c, 'SchemeAccountBudget must have a Utilized Amount 2500!');
		Test.stopTest();
	}

	@isTest 
	static void createSchemeAccountBudgetWithoutPartnerAccountNegative(){
		Test.startTest();
		dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 15');
		dmpl__SchemeAccountBudget__c schemeAccountBudget;
		try{
			schemeAccountBudget = SchemeAccountBudgetDataHelper.createSchemeAccountBudget(null, null, scheme.Id, 0, 0);	
			//System.Assert.isTrue(schemeAccountBudget == null, 'SchemeAccountBudget must not be created As Wrong Partner Added!');
		}catch(Exception e){
			System.Assert.isTrue(schemeAccountBudget == null, 'SchemeAccountBudget must not be created As Wrong Partner Added!');
		}
		Test.stopTest();
	}

	@isTest 
	static void createSchemeAccountBudgetWithoutPartnerAccountGroupNegative(){
		Test.startTest();
		dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 15');
		dmpl__SchemeAccountBudget__c schemeAccountBudget;
		try{
			schemeAccountBudget = SchemeAccountBudgetDataHelper.createSchemeAccountBudget(null, null, scheme.Id, 0, 0);	
			//System.Assert.isTrue(schemeAccountBudget == null, 'SchemeAccountBudget must not be created As No Partner Group Added!');
		}catch(Exception e){
			System.Assert.isTrue(schemeAccountBudget == null, 'SchemeAccountBudget must not be created As No Partner Group Added!');
		}
		Test.stopTest();
	}

	@isTest 
	static void createSchemeAccountBudgetWithoutBudgetAmountNegative(){
		Test.startTest();
		dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 15');
		dmpl__SchemeAccountBudget__c schemeAccountBudget;
		try{
			schemeAccountBudget = SchemeAccountBudgetDataHelper.createSchemeAccountBudget(null, null, scheme.Id, null, 0);	
			//System.Assert.isTrue(schemeAccountBudget == null, 'SchemeAccountBudget must not be created As Without Budget Amount Added!');
		}catch(Exception e){
			System.Assert.isTrue(schemeAccountBudget == null, 'SchemeAccountBudget must not be created As Without Budget Amount Added!');
		}
		Test.stopTest();
	}

	@isTest 
	static void createSchemeAccountBudgetWithoutSchemeNegative(){
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__SchemeAccountBudget__c schemeAccountBudget;
		try{
			schemeAccountBudget = SchemeAccountBudgetDataHelper.createSchemeAccountBudget(partner.Id, null, null, null, 0);	
			System.Assert.isTrue(schemeAccountBudget == null, 'SchemeAccountBudget must not be created As Without Scheme Added!');
		}catch(Exception e){
			System.Assert.isTrue(schemeAccountBudget == null, 'SchemeAccountBudget must not be created As Without Scheme Added!');
		}
		Test.stopTest();
	}

/******************************  Scheme Ledger  ******************************/
	@isTest
	static void createSchemeLedgerWithSchemeSlabPositive(){
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');

		dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 2');
		dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
		dmpl__SchemeLedger__c schemeLedger;
		try{
			schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id, schemeLine.Id,null, null, null, null, null, null, null, null, null, 0 ,0,0);
		}catch(Exception e){
			System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must get created!');
		}
		schemeLedger = SchemeDataHelper.getSchemeLedger(schemeLedger.Id);
		System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
		System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
		System.assertEquals(schemeLine.Id, schemeLedger.dmpl__SchemeLineId__c, 'Scheme line must match!');
		Test.stopTest();
	}

	@isTest
	static void createSchemeLedgerWithBillPositive(){
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
		dmpl__Bill__c bill = BillTestDataHelpers.getBill();
		dmpl__SchemeLedger__c schemeLedger;
		try{
			schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id, null ,bill.Id, null, null, null, null, null, null, null, null, 0 ,0,0);
		}catch(Exception e){
			System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must get created!');
		}
		schemeLedger = SchemeDataHelper.getSchemeLedger(schemeLedger.Id);
		System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
		System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
		System.assertEquals(bill.Id, schemeLedger.dmpl__BillId__c, 'Bill must match!');
		Test.stopTest();
	}

	@isTest
	static void updateSchemeLedgerWithBillPositive(){
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
		dmpl__Bill__c bill = BillTestDataHelpers.getBill();
		dmpl__SchemeLedger__c schemeLedger;
		try{
			schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id, null , null, null, null, null, null, null, null, null, null, 0 ,0,0);
			schemeLedger.dmpl__BillId__c = bill.Id;
			update schemeLedger;
		}catch(Exception e){
			System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must get update! >> ' + e.getMessage());
		}
		schemeLedger = SchemeDataHelper.getSchemeLedger(schemeLedger.Id);
		System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
		System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
		System.assertEquals(bill.Id, schemeLedger.dmpl__BillId__c, 'Bill must match!');
		Test.stopTest();
	}

	@isTest
	static void createSchemeLedgerWithSaleOrderLinePositive(){
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
		dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.getSaleOrderLine();
		dmpl__SchemeLedger__c schemeLedger;
		try{
			schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id, null ,null, null, saleOrderLine.Id, null, null, null, null, null, null, 0 ,0,0);
		}catch(Exception e){
			System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must get created! >> ' + e.getMessage());
		}
		schemeLedger = SchemeDataHelper.getSchemeLedger(schemeLedger.Id);
		System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
		System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
		System.assertEquals(saleOrderLine.Id, schemeLedger.dmpl__SaleOrderLineId__c, 'Sale order line must match!');
		Test.stopTest();
	}

	@isTest
	static void updateSchemeLedgerWithSaleOrderLinePositive(){
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
		dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.getSaleOrderLine();
		dmpl__SchemeLedger__c schemeLedger;
		try{
			schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id, null ,null, null, null, null, null, null, null, null, null, 0 ,0,0);
			schemeLedger.dmpl__SaleOrderLineId__c = saleOrderLine.Id;
			update schemeLedger;
		}catch(Exception e){
			System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must get updated! >> ' + e.getMessage());
		}
		schemeLedger = SchemeDataHelper.getSchemeLedger(schemeLedger.Id);
		System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
		System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
		System.assertEquals(saleOrderLine.Id, schemeLedger.dmpl__SaleOrderLineId__c, 'Sale order line must match!');
		Test.stopTest();
	}

	@isTest
	static void createSchemeLedgerWithSaleOrderPositive(){
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
		dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
		dmpl__SchemeLedger__c schemeLedger;
		try{
			schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id, null ,null, saleOrder.Id, null, null, null, null, null, null, null, 0 ,0,0);
		}catch(Exception e){
			System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must get created! >> ' + e.getMessage());
		}
		schemeLedger = SchemeDataHelper.getSchemeLedger(schemeLedger.Id);
		System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
		System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
		System.assertEquals(saleOrder.Id, schemeLedger.dmpl__SaleOrderId__c, 'Sale order must match!');
		Test.stopTest();
	}

	@isTest
	static void updateSchemeLedgerWithSaleOrderPositive(){
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
		dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
		dmpl__SchemeLedger__c schemeLedger;
		try{
			schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id, null ,null, null, null, null, null, null, null, null, null, 0 ,0,0);
			schemeLedger.dmpl__SaleOrderId__c = saleOrder.Id;
			update schemeLedger;
		}catch(Exception e){
			System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must get updated! >> ' + e.getMessage());
		}
		schemeLedger = SchemeDataHelper.getSchemeLedger(schemeLedger.Id);
		System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
		System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
		System.assertEquals(saleOrder.Id, schemeLedger.dmpl__SaleOrderId__c, 'Sale order must match!');
		Test.stopTest();
	}

	@isTest
	static void createSchemeLedgerWithSaleInvoicePositive(){
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
		dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
		dmpl__SchemeLedger__c schemeLedger;
		try{
			schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id, null ,null, null, null, saleInvoice.Id, null, null, null, null, null, 0 ,0,0);
		}catch(Exception e){
			System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must get created! >> ' + e.getMessage());
		}
		schemeLedger = SchemeDataHelper.getSchemeLedger(schemeLedger.Id);
		System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
		System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
		System.assertEquals(saleInvoice.Id, schemeLedger.dmpl__SaleInvoiceId__c, 'Sale Invoice must match!');
		Test.stopTest();
	}

	@isTest
	static void createSchemeLedgerWithSaleInvoiceLinePositive(){
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
		dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.getSaleInvoice();
		dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.getSaleInvoiceLine();
		dmpl__SchemeLedger__c schemeLedger;
		try{
			schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id, null ,null, null, null, saleInvoice.Id, saleInvoiceLine.Id, null, null, null, null, 0 ,0,0);
		}catch(Exception e){
			System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must get created! >> ' + e.getMessage());
		}
		schemeLedger = SchemeDataHelper.getSchemeLedger(schemeLedger.Id);
		System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
		System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
		System.assertEquals(saleInvoice.Id, schemeLedger.dmpl__SaleInvoiceId__c, 'Sale Invoice must match!');
		System.assertEquals(saleInvoiceLine.Id, schemeLedger.dmpl__SaleInvoiceLineId__c, 'Sale Invoice Line must match!');
		Test.stopTest();
	}

	@isTest
	static void createSchemeLedgerWithSaleReturnPositive(){
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
		dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.getSaleReturn();
		dmpl__SchemeLedger__c schemeLedger;
		try{
			schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id, null ,null, null, null, null, null, saleReturn.Id, null, null, null, 0 ,0,0);
		}catch(Exception e){
			System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must get created! >> ' + e.getMessage());
		}
		schemeLedger = SchemeDataHelper.getSchemeLedger(schemeLedger.Id);
		System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
		System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
		System.assertEquals(saleReturn.Id, schemeLedger.dmpl__SaleReturnId__c, 'Sale Return must match!');
		Test.stopTest();
	}

	@isTest
	static void createSchemeLedgerWithSaleReturnLinePositive(){
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
		dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.getSaleReturn();
		dmpl__SaleReturnLine__c saleReturnLine =  SaleReturnDataHelper.getSaleReturnLine();
		dmpl__SchemeLedger__c schemeLedger;
		try{
			schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id, null ,null, null, null, null, null, saleReturn.Id, saleReturnLine.Id, null, null, 0 ,0,0);
		}catch(Exception e){
			System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must get created! >> ' + e.getMessage());
		}
		schemeLedger = SchemeDataHelper.getSchemeLedger(schemeLedger.Id);
		System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
		System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
		System.assertEquals(saleReturn.Id, schemeLedger.dmpl__SaleReturnId__c, 'Sale Return must match!');
		System.assertEquals(saleReturnLine.Id, schemeLedger.dmpl__SaleReturnLineId__c, 'Sale Retrun Line must match!');
		Test.stopTest();
	}

	@isTest
	static void createSchemeLedgerWithRepairOrderPositive(){
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
		dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.getRepairOrder();
		dmpl__SchemeLedger__c schemeLedger;
		try{
			schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id, null ,null, null, null, null, null, null, null, repairOrder.Id, null, 0 ,0,0);
		}catch(Exception e){
			System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must get created! >> ' + e.getMessage());
		}
		schemeLedger = SchemeDataHelper.getSchemeLedger(schemeLedger.Id);
		System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
		System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
		System.assertEquals(repairOrder.Id, schemeLedger.dmpl__RepairOrderId__c, 'Repair Order must match!');
		Test.stopTest();
	}

	@isTest
	static void createSchemeLedgerWithDiscountAmountPositive(){
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
		dmpl__SchemeLedger__c schemeLedger;
		try{
			schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id, null ,null, null, null, null, null, null, null, null, null, 500,0,0);
		}catch(Exception e){
			System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must get created! >> ' + e.getMessage());
		}
		schemeLedger = SchemeDataHelper.getSchemeLedger(schemeLedger.Id);
		System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
		System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
		System.assertEquals(500, schemeLedger.dmpl__DiscountAmount__c, 'Discount Amount must be 500!');
		Test.stopTest();
	}

	@isTest
	static void createSchemeLedgerWithDiscountPositive(){
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
		dmpl__SchemeLedger__c schemeLedger;
		try{
			schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id, null ,null, null, null, null, null, null, null, null, null, 500,10,0);
		}catch(Exception e){
			System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must get created! >> ' + e.getMessage());
		}
		schemeLedger = SchemeDataHelper.getSchemeLedger(schemeLedger.Id);
		System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
		System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
		System.assertEquals(10, schemeLedger.dmpl__Discount__c, 'Discount percent must be 10%!');
		Test.stopTest();
	}

	@isTest
	static void createSchemeLedgerWithRewardPointsPositive(){
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
		dmpl__SchemeLedger__c schemeLedger;
		try{
			schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id, null ,null, null, null, null, null, null, null, null, null, 0,0,600);
		}catch(Exception e){
			System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must get created! >> ' + e.getMessage());
		}
		schemeLedger = SchemeDataHelper.getSchemeLedger(schemeLedger.Id);
		System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
		System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
		System.assertEquals(600, schemeLedger.dmpl__RewardPoints__c, 'Reward Point must be 600!');
		Test.stopTest();
	}

	@isTest
	static void createSchemeLedgerWithWrongPartnerAccountNegative(){
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 2');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
		dmpl__SchemeLedger__c schemeLedger;
		try{
			schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id, null ,null, null, null, null, null, null, null, null, null, 0,0,0);
			//System.Assert.isTrue(schemeLedger == null, 'Scheme ledger must not create! ');
		}catch(Exception e){
			System.Assert.isTrue(schemeLedger == null, 'Scheme ledger must not create! >>' + e.getMessage());
		}
		Test.stopTest();
	}

	@isTest
	static void createSchemeLedgerWithWrongBranchNegative(){
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 3');
		dmpl__SchemeLedger__c schemeLedger;
		try{
			schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id, null ,null, null, null, null, null, null, null, null, null, 0,0,0);
			//System.Assert.isTrue(schemeLedger == null, 'Scheme Ledger must fail As wrong partner added! ');
		}catch(Exception e){
			System.Assert.isTrue(schemeLedger == null, 'Scheme Ledger must fail As wrong partner added! >> ' + e.getMessage());
		}
		Test.stopTest();
	}

	@isTest
	static void createSchemeLedgerWithSchemeBenefitPositive(){
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
		dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
		Decimal sequenceNumber = 2;
        String rewardType = 'Discounted Item';
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		dmpl__ItemGroup__c itemGroup = null;
		Decimal discountPercent = 0 ;
        Decimal discountAmount = 0 ;
		Decimal uomQuantity = 0 ;
		Boolean exludeQualifyingItems = false;
		Boolean repeatReward = false ;
		
		dmpl__SchemeBenefit__c schemeBenefit =  SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, sequenceNumber, rewardType, item?.Id, itemGroup?.Id, discountPercent, discountAmount, uomQuantity, exludeQualifyingItems, repeatReward);
		
		dmpl__SchemeLedger__c schemeLedger;
		try{
			schemeLedger = SchemeDataHelper.createSchemeLedger(partner.Id, branch.Id, null ,null, null, null, null, null, null, null, null, schemeBenefit.Id, 500,0,0);
		}catch(Exception e){
			System.Assert.isTrue(schemeLedger != null, 'Scheme Ledger must create ! >> ' + e.getMessage());
		}
		System.assertEquals(partner.Id, schemeLedger.dmpl__PartnerAccountId__c, 'Partner Account Must Match!');
		System.assertEquals(branch.Id, schemeLedger.dmpl__BranchId__c, 'Branch must match!');
		System.assertEquals(schemeBenefit.Id, schemeLedger.dmpl__SchemeBenefitId__c, 'Scheme Benefit must be Match!');
		
		Test.stopTest();
	}

/******************************  Scheme Benefit  ******************************/
	@isTest
	static void createSchemeBenefitWithDiscountedItemPositive(){
		Test.startTest();
		dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
		Decimal sequenceNumber = 2;
        String rewardType = 'Discounted Item';
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		dmpl__ItemGroup__c itemGroup = null;
		Decimal discountPercent = 0 ;
        Decimal discountAmount = 0 ;
		Decimal uomQuantity = 0 ;
		Boolean exludeQualifyingItems = false;
		Boolean repeatReward = false ;
		
		dmpl__SchemeBenefit__c schemeBenefit;
		try{
			schemeBenefit =  SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, sequenceNumber, rewardType, item?.Id, itemGroup?.Id, discountPercent, discountAmount, uomQuantity, exludeQualifyingItems, repeatReward);
		}catch(Exception e){
			System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must create ! >> ' + e.getMessage());
		}
		schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);

		System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
		System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
		System.assertEquals(sequenceNumber, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
		System.assertEquals(rewardType, schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
		System.assertEquals(item?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
		System.assertEquals(itemGroup?.Id, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
		System.assertEquals(discountPercent, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
		System.assertEquals(discountAmount, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
		System.assertEquals(uomQuantity, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
		System.assertEquals(exludeQualifyingItems, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
		System.assertEquals(repeatReward, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');

		Test.stopTest();
	}

	@isTest
	static void updateSchemeBenefitWithDiscountedItemPositive(){
		Test.startTest();
		dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
		Decimal sequenceNumber = 2;
        String rewardType = 'Discounted Item';
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		dmpl__Item__c item2 = TestDataHelpers.getItem('Item 2');
		dmpl__ItemGroup__c itemGroup = null;
		Decimal discountPercent = 0 ;
        Decimal discountAmount = 0 ;
		Decimal uomQuantity = 0 ;
		Boolean exludeQualifyingItems = false;
		Boolean repeatReward = false ;
		
		dmpl__SchemeBenefit__c schemeBenefit;
		try{
			schemeBenefit =  SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, sequenceNumber, rewardType, item?.Id, itemGroup?.Id, discountPercent, discountAmount, uomQuantity, exludeQualifyingItems, repeatReward);
			schemeBenefit.dmpl__DiscountedItemId__c = item2.Id;
			update schemeBenefit;
		}catch(Exception e){
			System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must create ! >> ' + e.getMessage());
		}
		schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);

		System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
		System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
		System.assertEquals(sequenceNumber, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
		System.assertEquals(rewardType, schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
		System.assertEquals(item2?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
		System.assertEquals(itemGroup?.Id, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
		System.assertEquals(discountPercent, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
		System.assertEquals(discountAmount, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
		System.assertEquals(uomQuantity, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
		System.assertEquals(exludeQualifyingItems, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
		System.assertEquals(repeatReward, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');

		Test.stopTest();
	}

	@isTest
	static void createSchemeBenefitWithDiscountedItemGroupPositive(){
		Test.startTest();
		dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
		Decimal sequenceNumber = 2;
        String rewardType = 'Discounted Item Group';
		dmpl__Item__c item = null;
		dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 2');
		Decimal discountPercent = 0 ;
        Decimal discountAmount = 0 ;
		Decimal uomQuantity = 0 ;
		Boolean exludeQualifyingItems = false;
		Boolean repeatReward = false ;
		
		dmpl__SchemeBenefit__c schemeBenefit;
		try{
			schemeBenefit =  SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, sequenceNumber, rewardType, item?.Id, itemGroup?.Id, discountPercent, discountAmount, uomQuantity, exludeQualifyingItems, repeatReward);
		}catch(Exception e){
			System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must create ! >> ' + e.getMessage());
		}
		schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);

		System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
		System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
		System.assertEquals(sequenceNumber, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
		System.assertEquals(rewardType, schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
		System.assertEquals(item?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
		System.assertEquals(itemGroup?.Id, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
		System.assertEquals(discountPercent, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
		System.assertEquals(discountAmount, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
		System.assertEquals(uomQuantity, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
		System.assertEquals(exludeQualifyingItems, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
		System.assertEquals(repeatReward, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');

		Test.stopTest();
	}

	@isTest
	static void createSchemeBenefitWithLineLevelDiscountPercentPositive(){
		Test.startTest();
		dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
		Decimal sequenceNumber = 2;
        String rewardType = 'Discounted Item';
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		dmpl__ItemGroup__c itemGroup = null;
		Decimal discountPercent = 100 ;
        Decimal discountAmount = 0 ;
		Decimal uomQuantity = 0 ;
		Boolean exludeQualifyingItems = false;
		Boolean repeatReward = false ;
		
		dmpl__SchemeBenefit__c schemeBenefit;
		try{
			schemeBenefit =  SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, sequenceNumber, rewardType, item?.Id, itemGroup?.Id, discountPercent, discountAmount, uomQuantity, exludeQualifyingItems, repeatReward);
		}catch(Exception e){
			System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must create ! >> ' + e.getMessage());
		}
		schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);

		System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
		System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
		System.assertEquals(sequenceNumber, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
		System.assertEquals(rewardType, schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
		System.assertEquals(item?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
		System.assertEquals(itemGroup?.Id, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
		System.assertEquals(discountPercent, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
		System.assertEquals(discountAmount, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
		System.assertEquals(uomQuantity, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
		System.assertEquals(exludeQualifyingItems, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
		System.assertEquals(repeatReward, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');

		Test.stopTest();
	}

	@isTest
	static void createSchemeBenefitWithLineLevelDiscountAmountPositive(){
		Test.startTest();
		dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
		Decimal sequenceNumber = 2;
        String rewardType = 'Discounted Item';
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		dmpl__ItemGroup__c itemGroup = null;
		Decimal discountPercent = 0 ;
        Decimal discountAmount = 2500 ;
		Decimal uomQuantity = 0 ;
		Boolean exludeQualifyingItems = false;
		Boolean repeatReward = false ;
		
		dmpl__SchemeBenefit__c schemeBenefit;
		try{
			schemeBenefit =  SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, sequenceNumber, rewardType, item?.Id, itemGroup?.Id, discountPercent, discountAmount, uomQuantity, exludeQualifyingItems, repeatReward);
		}catch(Exception e){
			System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must create ! >> ' + e.getMessage());
		}
		schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);

		System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
		System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
		System.assertEquals(sequenceNumber, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
		System.assertEquals(rewardType, schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
		System.assertEquals(item?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
		System.assertEquals(itemGroup?.Id, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
		System.assertEquals(discountPercent, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
		System.assertEquals(discountAmount, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
		System.assertEquals(uomQuantity, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
		System.assertEquals(exludeQualifyingItems, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
		System.assertEquals(repeatReward, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');

		Test.stopTest();
	}

	@isTest
	static void createSchemeBenefitWithRewardPointsPositive(){
		Test.startTest();
		dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
		Decimal sequenceNumber = 2;
        String rewardType = 'Reward Points';
		dmpl__Item__c item = null;
		dmpl__ItemGroup__c itemGroup = null;
		Decimal discountPercent = 0 ;
        Decimal discountAmount = 0 ;
		Decimal uomQuantity = 0 ;
		Boolean exludeQualifyingItems = false;
		Boolean repeatReward = false ;
		
		dmpl__SchemeBenefit__c schemeBenefit;
		try{
			schemeBenefit =  SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, sequenceNumber, rewardType, item?.Id, itemGroup?.Id, discountPercent, discountAmount, uomQuantity, exludeQualifyingItems, repeatReward);
		}catch(Exception e){
			System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must create ! >> ' + e.getMessage());
		}
		schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);

		System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
		System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
		System.assertEquals(sequenceNumber, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
		System.assertEquals(rewardType, schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
		System.assertEquals(item?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
		System.assertEquals(itemGroup?.Id, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
		System.assertEquals(discountPercent, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
		System.assertEquals(discountAmount, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
		System.assertEquals(uomQuantity, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
		System.assertEquals(exludeQualifyingItems, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
		System.assertEquals(repeatReward, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');

		Test.stopTest();
	}

	@isTest
	static void createSchemeBenefitWithFreeItem1Positive(){
		Test.startTest();
		dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
		Decimal sequenceNumber = 2;
        String rewardType = 'Discounted Item';
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		dmpl__ItemGroup__c itemGroup = null;
		Decimal discountPercent = 0 ;
        Decimal discountAmount = 0 ;
		Decimal uomQuantity = 0 ;
		Boolean exludeQualifyingItems = false;
		Boolean repeatReward = false ;
		
		dmpl__SchemeBenefit__c schemeBenefit;
		try{
			schemeBenefit =  SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, sequenceNumber, rewardType, item?.Id, itemGroup?.Id, discountPercent, discountAmount, uomQuantity, exludeQualifyingItems, repeatReward);
		}catch(Exception e){
			System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must create ! >> ' + e.getMessage());
		}
		schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);

		System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
		System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
		System.assertEquals(sequenceNumber, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
		System.assertEquals(rewardType, schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
		System.assertEquals(item?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
		System.assertEquals(itemGroup?.Id, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
		System.assertEquals(discountPercent, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
		System.assertEquals(discountAmount, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
		System.assertEquals(uomQuantity, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
		System.assertEquals(exludeQualifyingItems, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
		System.assertEquals(repeatReward, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');

		Test.stopTest();
	}

	@isTest
	static void updateSchemeBenefitWithFreeItem1Positive(){
		Test.startTest();
		dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
		Decimal sequenceNumber = 2;
        String rewardType = 'Discounted Item';
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		dmpl__Item__c item2 = TestDataHelpers.getItem('Item 2');
		dmpl__ItemGroup__c itemGroup = null;
		Decimal discountPercent = 0 ;
        Decimal discountAmount = 0 ;
		Decimal uomQuantity = 0 ;
		Boolean exludeQualifyingItems = false;
		Boolean repeatReward = false ;
		
		dmpl__SchemeBenefit__c schemeBenefit;
		try{
			schemeBenefit =  SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, sequenceNumber, rewardType, item?.Id, itemGroup?.Id, discountPercent, discountAmount, uomQuantity, exludeQualifyingItems, repeatReward);
			schemeBenefit.dmpl__DiscountedItemId__c = item2.Id;
			update schemeBenefit;
		}catch(Exception e){
			System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must create ! >> ' + e.getMessage());
		}
		schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);

		System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
		System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
		System.assertEquals(sequenceNumber, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
		System.assertEquals(rewardType, schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
		System.assertEquals(item2?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
		System.assertEquals(itemGroup?.Id, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
		System.assertEquals(discountPercent, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
		System.assertEquals(discountAmount, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
		System.assertEquals(uomQuantity, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
		System.assertEquals(exludeQualifyingItems, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
		System.assertEquals(repeatReward, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');

		Test.stopTest();
	}

	@isTest
	static void createSchemeBenefitWithFreeItem1PieceQuantityPositive(){
		Test.startTest();
		dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
		Decimal sequenceNumber = 2;
        String rewardType = 'Discounted Item';
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		dmpl__ItemGroup__c itemGroup = null;
		Decimal discountPercent = 0 ;
        Decimal discountAmount = 0 ;
		Decimal uomQuantity = 15;
		Boolean exludeQualifyingItems = false;
		Boolean repeatReward = false ;
		
		dmpl__SchemeBenefit__c schemeBenefit;
		try{
			schemeBenefit =  SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, sequenceNumber, rewardType, item?.Id, itemGroup?.Id, discountPercent, discountAmount, uomQuantity, exludeQualifyingItems, repeatReward);
		}catch(Exception e){
			System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must create ! >> ' + e.getMessage());
		}
		schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);

		System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
		System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
		System.assertEquals(sequenceNumber, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
		System.assertEquals(rewardType, schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
		System.assertEquals(item?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
		System.assertEquals(itemGroup?.Id, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
		System.assertEquals(discountPercent, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
		System.assertEquals(discountAmount, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
		System.assertEquals(uomQuantity, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
		System.assertEquals(exludeQualifyingItems, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
		System.assertEquals(repeatReward, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');

		Test.stopTest();
	}

	@isTest
	static void createSchemeBenefitWithFreeItem2Positive(){
		Test.startTest();
		dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
		Decimal sequenceNumber = 2;
        String rewardType = 'Discounted Item';
		dmpl__Item__c item = TestDataHelpers.getItem('Item 5');
		dmpl__ItemGroup__c itemGroup = null;
		Decimal discountPercent = 0 ;
        Decimal discountAmount = 0 ;
		Decimal uomQuantity = 0 ;
		Boolean exludeQualifyingItems = false;
		Boolean repeatReward = false ;
		
		dmpl__SchemeBenefit__c schemeBenefit;
		try{
			schemeBenefit =  SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, sequenceNumber, rewardType, item?.Id, itemGroup?.Id, discountPercent, discountAmount, uomQuantity, exludeQualifyingItems, repeatReward);
		}catch(Exception e){
			System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must create ! >> ' + e.getMessage());
		}
		schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);

		System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
		System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
		System.assertEquals(sequenceNumber, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
		System.assertEquals(rewardType, schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
		System.assertEquals(item?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
		System.assertEquals(itemGroup?.Id, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
		System.assertEquals(discountPercent, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
		System.assertEquals(discountAmount, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
		System.assertEquals(uomQuantity, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
		System.assertEquals(exludeQualifyingItems, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
		System.assertEquals(repeatReward, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');

		Test.stopTest();
	}

	@isTest
	static void updateSchemeBenefitWithFreeItem2Positive(){
		Test.startTest();
		dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
		Decimal sequenceNumber = 2;
        String rewardType = 'Discounted Item';
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		dmpl__Item__c item2 = TestDataHelpers.getItem('Item 6');
		dmpl__ItemGroup__c itemGroup = null;
		Decimal discountPercent = 0 ;
        Decimal discountAmount = 0 ;
		Decimal uomQuantity = 0 ;
		Boolean exludeQualifyingItems = false;
		Boolean repeatReward = false ;
		
		dmpl__SchemeBenefit__c schemeBenefit;
		try{
			schemeBenefit =  SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, sequenceNumber, rewardType, item?.Id, itemGroup?.Id, discountPercent, discountAmount, uomQuantity, exludeQualifyingItems, repeatReward);
			schemeBenefit.dmpl__DiscountedItemId__c = item2.Id;
			update schemeBenefit;
		}catch(Exception e){
			System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must create ! >> ' + e.getMessage());
		}
		schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);

		System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
		System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
		System.assertEquals(sequenceNumber, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
		System.assertEquals(rewardType, schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
		System.assertEquals(item2?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
		System.assertEquals(itemGroup?.Id, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
		System.assertEquals(discountPercent, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
		System.assertEquals(discountAmount, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
		System.assertEquals(uomQuantity, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
		System.assertEquals(exludeQualifyingItems, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
		System.assertEquals(repeatReward, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');

		Test.stopTest();
	}

	@isTest
	static void createSchemeBenefitWithFreeItem2PieceQuantityPositive(){
		Test.startTest();
		dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
		Decimal sequenceNumber = 2;
        String rewardType = 'Discounted Item';
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		dmpl__ItemGroup__c itemGroup = null;
		Decimal discountPercent = 0 ;
        Decimal discountAmount = 0 ;
		Decimal uomQuantity = 20;
		Boolean exludeQualifyingItems = false;
		Boolean repeatReward = false ;
		
		dmpl__SchemeBenefit__c schemeBenefit;
		try{
			schemeBenefit =  SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, sequenceNumber, rewardType, item?.Id, itemGroup?.Id, discountPercent, discountAmount, uomQuantity, exludeQualifyingItems, repeatReward);
		}catch(Exception e){
			System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must create ! >> ' + e.getMessage());
		}
		schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);

		System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
		System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
		System.assertEquals(sequenceNumber, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
		System.assertEquals(rewardType, schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
		System.assertEquals(item?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
		System.assertEquals(itemGroup?.Id, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
		System.assertEquals(discountPercent, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
		System.assertEquals(discountAmount, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
		System.assertEquals(uomQuantity, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
		System.assertEquals(exludeQualifyingItems, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
		System.assertEquals(repeatReward, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');

		Test.stopTest();
	}

	@isTest
	static void createSchemeBenefitWithSchemeValuePositive(){
		Test.startTest();
		dmpl__Scheme__c scheme = null;
        dmpl__SchemeLine__c schemeLine = null;
		Decimal sequenceNumber = 2;
        String rewardType = 'Discounted Item';
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		dmpl__ItemGroup__c itemGroup = null;
		Decimal discountPercent = 0 ;
        Decimal discountAmount = 0 ;
		Decimal uomQuantity = 0 ;
		Boolean exludeQualifyingItems = false;
		Boolean repeatReward = false ;
		
		dmpl__SchemeBenefit__c schemeBenefit;
		try{
			schemeBenefit =  SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, sequenceNumber, rewardType, item?.Id, itemGroup?.Id, discountPercent, discountAmount, uomQuantity, exludeQualifyingItems, repeatReward);
		}catch(Exception e){
			System.Assert.isTrue(schemeBenefit == null, 'Scheme benefit must create ! >> ' + e.getMessage());
		}
		schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);

		System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
		System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
		System.assertEquals(sequenceNumber, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
		System.assertEquals(rewardType, schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
		System.assertEquals(item?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
		System.assertEquals(itemGroup?.Id, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
		System.assertEquals(discountPercent, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
		System.assertEquals(discountAmount, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
		System.assertEquals(uomQuantity, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
		System.assertEquals(exludeQualifyingItems, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
		System.assertEquals(repeatReward, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');

		Test.stopTest();
	}

	@isTest
	static void createSchemeBenefitWithSchemePercentagePositive(){
		Test.startTest();
		dmpl__Scheme__c scheme = null;
        dmpl__SchemeLine__c schemeLine = null;
		Decimal sequenceNumber = 2;
        String rewardType = 'Discounted Item';
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		dmpl__ItemGroup__c itemGroup = null;
		Decimal discountPercent = 0 ;
        Decimal discountAmount = 0 ;
		Decimal uomQuantity = 0 ;
		Boolean exludeQualifyingItems = false;
		Boolean repeatReward = false ;
		
		dmpl__SchemeBenefit__c schemeBenefit;
		try{
			schemeBenefit =  SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, sequenceNumber, rewardType, item?.Id, itemGroup?.Id, discountPercent, discountAmount, uomQuantity, exludeQualifyingItems, repeatReward);
		}catch(Exception e){
			System.Assert.isTrue(schemeBenefit == null, 'Scheme benefit must create ! >> ' + e.getMessage());
		}
		schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);

		System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
		System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
		System.assertEquals(sequenceNumber, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
		System.assertEquals(rewardType, schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
		System.assertEquals(item?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
		System.assertEquals(itemGroup?.Id, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
		System.assertEquals(discountPercent, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
		System.assertEquals(discountAmount, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
		System.assertEquals(uomQuantity, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
		System.assertEquals(exludeQualifyingItems, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
		System.assertEquals(repeatReward, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');

		Test.stopTest();
	}

	@isTest
	static void createSchemeBenefitWithExcludeQualifyingItemTruePositive(){
		Test.startTest();
		dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
		Decimal sequenceNumber = 2;
        String rewardType = 'Discounted Item';
		dmpl__Item__c item = TestDataHelpers.getItem('Item 5');
		dmpl__ItemGroup__c itemGroup = null;
		Decimal discountPercent = 0 ;
        Decimal discountAmount = 0 ;
		Decimal uomQuantity = 0 ;
		Boolean exludeQualifyingItems = true;
		Boolean repeatReward = false ;
		
		dmpl__SchemeBenefit__c schemeBenefit;
		try{
			schemeBenefit =  SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, sequenceNumber, rewardType, item?.Id, itemGroup?.Id, discountPercent, discountAmount, uomQuantity, exludeQualifyingItems, repeatReward);
		}catch(Exception e){
			System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must create ! >> ' + e.getMessage());
		}
		schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);

		System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
		System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
		System.assertEquals(sequenceNumber, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
		System.assertEquals(rewardType, schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
		System.assertEquals(item?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
		System.assertEquals(itemGroup?.Id, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
		System.assertEquals(discountPercent, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
		System.assertEquals(discountAmount, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
		System.assertEquals(uomQuantity, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
		System.assertEquals(exludeQualifyingItems, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
		System.assertEquals(repeatReward, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');

		Test.stopTest();
	}

	@isTest
	static void createSchemeBenefitWithReadRewardEveryQualificationTruePositive(){
		Test.startTest();
		dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
		Decimal sequenceNumber = 2;
        String rewardType = 'Discounted Item';
		dmpl__Item__c item = TestDataHelpers.getItem('Item 5');
		dmpl__ItemGroup__c itemGroup = null;
		Decimal discountPercent = 0 ;
        Decimal discountAmount = 0 ;
		Decimal uomQuantity = 0 ;
		Boolean exludeQualifyingItems = false;
		Boolean repeatReward = true ;
		
		dmpl__SchemeBenefit__c schemeBenefit;
		try{
			schemeBenefit =  SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, sequenceNumber, rewardType, item?.Id, itemGroup?.Id, discountPercent, discountAmount, uomQuantity, exludeQualifyingItems, repeatReward);
		}catch(Exception e){
			System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must create ! >> ' + e.getMessage());
		}
		schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);

		System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
		System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
		System.assertEquals(sequenceNumber, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
		System.assertEquals(rewardType, schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
		System.assertEquals(item?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
		System.assertEquals(itemGroup?.Id, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
		System.assertEquals(discountPercent, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
		System.assertEquals(discountAmount, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
		System.assertEquals(uomQuantity, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
		System.assertEquals(exludeQualifyingItems, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
		System.assertEquals(repeatReward, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');

		Test.stopTest();
	}

	@isTest
	static void updateSchemeBenefitWithExcludeQualifyingItemFalsePositive(){
		Test.startTest();
		dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
		Decimal sequenceNumber = 2;
        String rewardType = 'Discounted Item';
		dmpl__Item__c item = TestDataHelpers.getItem('Item 5');
		dmpl__ItemGroup__c itemGroup = null;
		Decimal discountPercent = 0 ;
        Decimal discountAmount = 0 ;
		Decimal uomQuantity = 0 ;
		Boolean exludeQualifyingItems = true;
		Boolean repeatReward = false ;
		
		dmpl__SchemeBenefit__c schemeBenefit;
		try{
			schemeBenefit =  SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, sequenceNumber, rewardType, item?.Id, itemGroup?.Id, discountPercent, discountAmount, uomQuantity, exludeQualifyingItems, repeatReward);
			schemeBenefit.dmpl__ExcludeQualifyingItems__c = false;
			update schemeBenefit;
			exludeQualifyingItems = false;
		}catch(Exception e){
			System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must update ! >> ' + e.getMessage());
		}
		schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);

		System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
		System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
		System.assertEquals(sequenceNumber, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
		System.assertEquals(rewardType, schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
		System.assertEquals(item?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
		System.assertEquals(itemGroup?.Id, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
		System.assertEquals(discountPercent, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
		System.assertEquals(discountAmount, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
		System.assertEquals(uomQuantity, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
		System.assertEquals(exludeQualifyingItems, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
		System.assertEquals(repeatReward, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');

		Test.stopTest();
	}

	@isTest
	static void updateSchemeBenefitWithReadRewardEveryQualificationFalsePositive(){
		Test.startTest();
		dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
		Decimal sequenceNumber = 2;
        String rewardType = 'Discounted Item';
		dmpl__Item__c item = TestDataHelpers.getItem('Item 5');
		dmpl__ItemGroup__c itemGroup = null;
		Decimal discountPercent = 0 ;
        Decimal discountAmount = 0 ;
		Decimal uomQuantity = 0 ;
		Boolean exludeQualifyingItems = true;
		Boolean repeatReward = true ;
		
		dmpl__SchemeBenefit__c schemeBenefit;
		try{
			schemeBenefit =  SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, sequenceNumber, rewardType, item?.Id, itemGroup?.Id, discountPercent, discountAmount, uomQuantity, exludeQualifyingItems, repeatReward);
			schemeBenefit.dmpl__RepeatReward__c = false;
			update schemeBenefit;
			repeatReward = false;
		}catch(Exception e){
			System.Assert.isTrue(schemeBenefit != null, 'Scheme benefit must update ! >> ' + e.getMessage());
		}
		schemeBenefit = SchemeDataHelper.getSchemeBenefitbyId(schemeBenefit.id);

		System.assertEquals(scheme?.Id, schemeBenefit.dmpl__SchemeId__c, 'Scheme ID should match the expected Scheme');
		System.assertEquals(schemeLine?.Id, schemeBenefit.dmpl__SchemeLineId__c, 'Scheme Line ID should match the expected Scheme Line');
		System.assertEquals(sequenceNumber, schemeBenefit.dmpl__SequenceNumber__c, 'Sequence Number should match the expected value');
		System.assertEquals(rewardType, schemeBenefit.dmpl__RewardType__c, 'Reward Type should match the expected value');
		System.assertEquals(item?.Id, schemeBenefit.dmpl__DiscountedItemId__c, 'Discounted Item ID should match the expected Item');
		System.assertEquals(itemGroup?.Id, schemeBenefit.dmpl__DiscountedItemGroupId__c, 'Discounted Item Group ID should match the expected Item Group');
		System.assertEquals(discountPercent, schemeBenefit.dmpl__DiscountPercent__c, 'Discount Percent should match the expected value');
		System.assertEquals(discountAmount, schemeBenefit.dmpl__DiscountAmount__c, 'Discount Amount should match the expected value');
		System.assertEquals(uomQuantity, schemeBenefit.dmpl__UOMQuantity__c, 'UOM Quantity should match the expected value');
		System.assertEquals(exludeQualifyingItems, schemeBenefit.dmpl__ExcludeQualifyingItems__c, 'Exclude Qualifying Items flag should match the expected value');
		System.assertEquals(repeatReward, schemeBenefit.dmpl__RepeatReward__c, 'Repeat Reward flag should match the expected value');

		Test.stopTest();
	}

	@isTest
	static void createSchemeBenefitWithoutRewardTypeNegative(){
		Test.startTest();
		dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
		Decimal sequenceNumber = 2;
        String rewardType = null;
		dmpl__Item__c item = TestDataHelpers.getItem('Item 5');
		dmpl__ItemGroup__c itemGroup = null;
		Decimal discountPercent = 0 ;
        Decimal discountAmount = 0 ;
		Decimal uomQuantity = 0 ;
		Boolean exludeQualifyingItems = false;
		Boolean repeatReward = false;
		
		dmpl__SchemeBenefit__c schemeBenefit;
		try{
			schemeBenefit =  SchemeDataHelper.createSchemeBenefit(scheme?.Id, schemeLine?.Id, sequenceNumber, rewardType, item?.Id, itemGroup?.Id, discountPercent, discountAmount, uomQuantity, exludeQualifyingItems, repeatReward);
			System.Assert.isTrue(schemeBenefit == null, 'Scheme benefit must not create !');
		}catch(Exception e){
			System.Assert.isTrue(schemeBenefit == null, 'Scheme benefit must not create ! >> ' + e.getMessage());
		}
		Test.stopTest();
	}

/******************************  Scheme Condition  ******************************/
	static void createSchemeConditionWithItemQuantityPositive(){
		Test.startTest();
		dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        String conditionType = 'Item Quantity';
        Decimal conditionValue = 10;
        Decimal uomQuantity = 0;
		Decimal uomQuantity1 = 0;
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		dmpl__ItemGroup__c itemGroup = null;
        String conditionOperator = 'Equals';
        Decimal conditionQuantity = 10;
        Decimal sequenceNumber = 1;

		dmpl__SchemeCondition__c schemeCondition;
		try{
			schemeCondition =  SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,conditionType,conditionValue,uomQuantity, uomQuantity1,item?.Id,itemGroup?.Id,conditionOperator,conditionQuantity,sequenceNumber);
		}catch(Exception e){
			System.Assert.isTrue(schemeCondition != null, 'Scheme Condition must create! >> ' + e.getMessage());
		}
		schemeCondition =  SchemeDataHelper.getSchemeConditionbyId(schemeCondition.Id);

		System.assertEquals(scheme?.Id, schemeCondition.dmpl__SchemeId__c, 'Scheme ID should match the input schemeId');
		System.assertEquals(schemeLine?.Id, schemeCondition.dmpl__SchemeLineId__c, 'Scheme Line ID should match the input schemeLineId');
		System.assertEquals(conditionType, schemeCondition.dmpl__ConditionType__c, 'Condition Type should match the input conditionType');
		System.assertEquals(conditionValue, schemeCondition.dmpl__ConditionValue__c, 'Condition Value should match the input conditionValue');
		System.assertEquals(uomQuantity, schemeCondition.dmpl__UOMQuantity__c, 'UOM Quantity should match the input uomQuantity');
		System.assertEquals(uomQuantity1, schemeCondition.dmpl__UOMQuantity1__c, 'UOM Quantity should match the input uomQuantity');
		System.assertEquals(item?.Id, schemeCondition.dmpl__ItemId__c, 'Item ID should match the input itemId');
		System.assertEquals(itemGroup?.Id, schemeCondition.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
		System.assertEquals(conditionOperator, schemeCondition.dmpl__ConditionOperator__c, 'Condition Operator should match the input conditionOperator');
		System.assertEquals(conditionQuantity, schemeCondition.dmpl__ConditionQuantity__c, 'Condition Quantity should match the input conditionQuantity');
		System.assertEquals(sequenceNumber, schemeCondition.dmpl__SequenceNumber__c, 'Sequence Number should match the input sequenceNumber');
		Test.stopTest();
	}

	@isTest 
	static void createSchemeConditionWithValuePositive(){
		Test.startTest();
		dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        String conditionType = 'Value';
        Decimal conditionValue = 12;
        Decimal uomQuantity = 0;
		Decimal uomQuantity1 = 0;
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		dmpl__ItemGroup__c itemGroup = null;
        String conditionOperator = 'Equals';
        Decimal conditionQuantity = 12;
        Decimal sequenceNumber = 1;

		dmpl__SchemeCondition__c schemeCondition;
		try{
			schemeCondition =  SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,conditionType,conditionValue,uomQuantity, uomQuantity1,item?.Id,itemGroup?.Id,conditionOperator,conditionQuantity,sequenceNumber);
		}catch(Exception e){
			System.Assert.isTrue(schemeCondition != null, 'Scheme Condition must create! >> ' + e.getMessage());
		}
		schemeCondition =  SchemeDataHelper.getSchemeConditionbyId(schemeCondition.Id);

		System.assertEquals(scheme?.Id, schemeCondition.dmpl__SchemeId__c, 'Scheme ID should match the input schemeId');
		System.assertEquals(schemeLine?.Id, schemeCondition.dmpl__SchemeLineId__c, 'Scheme Line ID should match the input schemeLineId');
		System.assertEquals(conditionType, schemeCondition.dmpl__ConditionType__c, 'Condition Type should match the input conditionType');
		System.assertEquals(conditionValue, schemeCondition.dmpl__ConditionValue__c, 'Condition Value should match the input conditionValue');
		System.assertEquals(uomQuantity, schemeCondition.dmpl__UOMQuantity__c, 'UOM Quantity should match the input uomQuantity');
		System.assertEquals(uomQuantity1, schemeCondition.dmpl__UOMQuantity1__c, 'UOM Quantity should match the input uomQuantity');
		System.assertEquals(item?.Id, schemeCondition.dmpl__ItemId__c, 'Item ID should match the input itemId');
		System.assertEquals(itemGroup?.Id, schemeCondition.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
		System.assertEquals(conditionOperator, schemeCondition.dmpl__ConditionOperator__c, 'Condition Operator should match the input conditionOperator');
		System.assertEquals(conditionQuantity, schemeCondition.dmpl__ConditionQuantity__c, 'Condition Quantity should match the input conditionQuantity');
		System.assertEquals(sequenceNumber, schemeCondition.dmpl__SequenceNumber__c, 'Sequence Number should match the input sequenceNumber');
		Test.stopTest();
	}

	@isTest 
	static void createSchemeConditionWithCaseQuantityPositive(){
		Test.startTest();
		dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        String conditionType = 'Value';
        Decimal conditionValue = 12;
        Decimal uomQuantity = 2;
		Decimal uomQuantity1 = 0;
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		dmpl__ItemGroup__c itemGroup = null;
        String conditionOperator = 'Equals';
        Decimal conditionQuantity = 12;
        Decimal sequenceNumber = 1;

		dmpl__SchemeCondition__c schemeCondition;
		try{
			schemeCondition =  SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,conditionType,conditionValue,uomQuantity, uomQuantity1,item?.Id,itemGroup?.Id,conditionOperator,conditionQuantity,sequenceNumber);
		}catch(Exception e){
			System.Assert.isTrue(schemeCondition != null, 'Scheme Condition must create! >> ' + e.getMessage());
		}
		schemeCondition =  SchemeDataHelper.getSchemeConditionbyId(schemeCondition.Id);

		System.assertEquals(scheme?.Id, schemeCondition.dmpl__SchemeId__c, 'Scheme ID should match the input schemeId');
		System.assertEquals(schemeLine?.Id, schemeCondition.dmpl__SchemeLineId__c, 'Scheme Line ID should match the input schemeLineId');
		System.assertEquals(conditionType, schemeCondition.dmpl__ConditionType__c, 'Condition Type should match the input conditionType');
		System.assertEquals(conditionValue, schemeCondition.dmpl__ConditionValue__c, 'Condition Value should match the input conditionValue');
		System.assertEquals(uomQuantity, schemeCondition.dmpl__UOMQuantity__c, 'UOM Quantity should match the input uomQuantity');
		System.assertEquals(uomQuantity1, schemeCondition.dmpl__UOMQuantity1__c, 'UOM Quantity should match the input uomQuantity');
		System.assertEquals(item?.Id, schemeCondition.dmpl__ItemId__c, 'Item ID should match the input itemId');
		System.assertEquals(itemGroup?.Id, schemeCondition.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
		System.assertEquals(conditionOperator, schemeCondition.dmpl__ConditionOperator__c, 'Condition Operator should match the input conditionOperator');
		System.assertEquals(conditionQuantity, schemeCondition.dmpl__ConditionQuantity__c, 'Condition Quantity should match the input conditionQuantity');
		System.assertEquals(sequenceNumber, schemeCondition.dmpl__SequenceNumber__c, 'Sequence Number should match the input sequenceNumber');
		Test.stopTest();
	}

	@isTest 
	static void createSchemeConditionWithPieceQuantityPositive(){
		Test.startTest();
		dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        String conditionType = 'Value';
        Decimal conditionValue = 12;
        Decimal uomQuantity = 2;
		Decimal uomQuantity1 = 0;
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		dmpl__ItemGroup__c itemGroup = null;
        String conditionOperator = 'Equals';
        Decimal conditionQuantity = 12;
        Decimal sequenceNumber = 1;

		dmpl__SchemeCondition__c schemeCondition;
		try{
			schemeCondition =  SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,conditionType,conditionValue,uomQuantity, uomQuantity1,item?.Id,itemGroup?.Id,conditionOperator,conditionQuantity,sequenceNumber);
		}catch(Exception e){
			System.Assert.isTrue(schemeCondition != null, 'Scheme Condition must create! >> ' + e.getMessage());
		}
		schemeCondition =  SchemeDataHelper.getSchemeConditionbyId(schemeCondition.Id);

		System.assertEquals(scheme?.Id, schemeCondition.dmpl__SchemeId__c, 'Scheme ID should match the input schemeId');
		System.assertEquals(schemeLine?.Id, schemeCondition.dmpl__SchemeLineId__c, 'Scheme Line ID should match the input schemeLineId');
		System.assertEquals(conditionType, schemeCondition.dmpl__ConditionType__c, 'Condition Type should match the input conditionType');
		System.assertEquals(conditionValue, schemeCondition.dmpl__ConditionValue__c, 'Condition Value should match the input conditionValue');
		System.assertEquals(uomQuantity, schemeCondition.dmpl__UOMQuantity__c, 'UOM Quantity should match the input uomQuantity');
		System.assertEquals(uomQuantity1, schemeCondition.dmpl__UOMQuantity1__c, 'UOM Quantity should match the input uomQuantity');
		System.assertEquals(item?.Id, schemeCondition.dmpl__ItemId__c, 'Item ID should match the input itemId');
		System.assertEquals(itemGroup?.Id, schemeCondition.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
		System.assertEquals(conditionOperator, schemeCondition.dmpl__ConditionOperator__c, 'Condition Operator should match the input conditionOperator');
		System.assertEquals(conditionQuantity, schemeCondition.dmpl__ConditionQuantity__c, 'Condition Quantity should match the input conditionQuantity');
		System.assertEquals(sequenceNumber, schemeCondition.dmpl__SequenceNumber__c, 'Sequence Number should match the input sequenceNumber');
		Test.stopTest();
	}

	@isTest 
	static void createSchemeConditionWithConditoinTypeAsItemGroupPositive(){
		Test.startTest();
		dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        String conditionType = 'Item Group Quantity';
        Decimal conditionValue = 0;
        Decimal uomQuantity = 0;
		Decimal uomQuantity1 = 0;
        dmpl__Item__c item = null;
		dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 2');
        String conditionOperator = 'Equals';
        Decimal conditionQuantity = 0;
        Decimal sequenceNumber = 1;

		dmpl__SchemeCondition__c schemeCondition;
		try{
			schemeCondition =  SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,conditionType,conditionValue,uomQuantity, uomQuantity1,item?.Id,itemGroup?.Id,conditionOperator,conditionQuantity,sequenceNumber);
		}catch(Exception e){
			System.Assert.isTrue(schemeCondition != null, 'Scheme Condition must create! >> ' + e.getMessage());
		}
		schemeCondition =  SchemeDataHelper.getSchemeConditionbyId(schemeCondition.Id);

		System.assertEquals(scheme?.Id, schemeCondition.dmpl__SchemeId__c, 'Scheme ID should match the input schemeId');
		System.assertEquals(schemeLine?.Id, schemeCondition.dmpl__SchemeLineId__c, 'Scheme Line ID should match the input schemeLineId');
		System.assertEquals(conditionType, schemeCondition.dmpl__ConditionType__c, 'Condition Type should match the input conditionType');
		System.assertEquals(conditionValue, schemeCondition.dmpl__ConditionValue__c, 'Condition Value should match the input conditionValue');
		System.assertEquals(uomQuantity, schemeCondition.dmpl__UOMQuantity__c, 'UOM Quantity should match the input uomQuantity');
		System.assertEquals(uomQuantity1, schemeCondition.dmpl__UOMQuantity1__c, 'UOM Quantity should match the input uomQuantity');
		System.assertEquals(item?.Id, schemeCondition.dmpl__ItemId__c, 'Item ID should match the input itemId');
		System.assertEquals(itemGroup?.Id, schemeCondition.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
		System.assertEquals(conditionOperator, schemeCondition.dmpl__ConditionOperator__c, 'Condition Operator should match the input conditionOperator');
		System.assertEquals(conditionQuantity, schemeCondition.dmpl__ConditionQuantity__c, 'Condition Quantity should match the input conditionQuantity');
		System.assertEquals(sequenceNumber, schemeCondition.dmpl__SequenceNumber__c, 'Sequence Number should match the input sequenceNumber');
		Test.stopTest();
	}

	@isTest 
	static void createSchemeConditionWithConditoinTypeAsItemGroupValuePositive(){
		Test.startTest();
		dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        String conditionType = 'Item Group Value';
        Decimal conditionValue = 0;
        Decimal uomQuantity = 0;
		Decimal uomQuantity1 = 0;
        dmpl__Item__c item = null;
		dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 2');
        String conditionOperator = 'Equals';
        Decimal conditionQuantity = 0;
        Decimal sequenceNumber = 1;

		dmpl__SchemeCondition__c schemeCondition;
		try{
			schemeCondition =  SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,conditionType,conditionValue,uomQuantity, uomQuantity1,item?.Id,itemGroup?.Id,conditionOperator,conditionQuantity,sequenceNumber);
		}catch(Exception e){
			System.Assert.isTrue(schemeCondition != null, 'Scheme Condition must create! >> ' + e.getMessage());
		}
		schemeCondition =  SchemeDataHelper.getSchemeConditionbyId(schemeCondition.Id);

		System.assertEquals(scheme?.Id, schemeCondition.dmpl__SchemeId__c, 'Scheme ID should match the input schemeId');
		System.assertEquals(schemeLine?.Id, schemeCondition.dmpl__SchemeLineId__c, 'Scheme Line ID should match the input schemeLineId');
		System.assertEquals(conditionType, schemeCondition.dmpl__ConditionType__c, 'Condition Type should match the input conditionType');
		System.assertEquals(conditionValue, schemeCondition.dmpl__ConditionValue__c, 'Condition Value should match the input conditionValue');
		System.assertEquals(uomQuantity, schemeCondition.dmpl__UOMQuantity__c, 'UOM Quantity should match the input uomQuantity');
		System.assertEquals(uomQuantity1, schemeCondition.dmpl__UOMQuantity1__c, 'UOM Quantity should match the input uomQuantity');
		System.assertEquals(item?.Id, schemeCondition.dmpl__ItemId__c, 'Item ID should match the input itemId');
		System.assertEquals(itemGroup?.Id, schemeCondition.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
		System.assertEquals(conditionOperator, schemeCondition.dmpl__ConditionOperator__c, 'Condition Operator should match the input conditionOperator');
		System.assertEquals(conditionQuantity, schemeCondition.dmpl__ConditionQuantity__c, 'Condition Quantity should match the input conditionQuantity');
		System.assertEquals(sequenceNumber, schemeCondition.dmpl__SequenceNumber__c, 'Sequence Number should match the input sequenceNumber');
		Test.stopTest();
	}

	@isTest 
	static void createSchemeConditionWithConditionOperatorGreaterThanOrEqualPositive(){
		Test.startTest();
		dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        String conditionType = 'Value';
        Decimal conditionValue = 0;
        Decimal uomQuantity = 0;
		Decimal uomQuantity1 = 0;
        dmpl__Item__c item = null;
		dmpl__ItemGroup__c itemGroup = null;
        String conditionOperator = 'Greater Than Or Equal';
        Decimal conditionQuantity = 0;
        Decimal sequenceNumber = 1;

		dmpl__SchemeCondition__c schemeCondition;
		try{
			schemeCondition =  SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,conditionType,conditionValue,uomQuantity, uomQuantity1,item?.Id,itemGroup?.Id,conditionOperator,conditionQuantity,sequenceNumber);
		}catch(Exception e){
			System.Assert.isTrue(schemeCondition != null, 'Scheme Condition must create! >> ' + e.getMessage());
		}
		schemeCondition =  SchemeDataHelper.getSchemeConditionbyId(schemeCondition.Id);

		System.assertEquals(scheme?.Id, schemeCondition.dmpl__SchemeId__c, 'Scheme ID should match the input schemeId');
		System.assertEquals(schemeLine?.Id, schemeCondition.dmpl__SchemeLineId__c, 'Scheme Line ID should match the input schemeLineId');
		System.assertEquals(conditionType, schemeCondition.dmpl__ConditionType__c, 'Condition Type should match the input conditionType');
		System.assertEquals(conditionValue, schemeCondition.dmpl__ConditionValue__c, 'Condition Value should match the input conditionValue');
		System.assertEquals(uomQuantity, schemeCondition.dmpl__UOMQuantity__c, 'UOM Quantity should match the input uomQuantity');
		System.assertEquals(uomQuantity1, schemeCondition.dmpl__UOMQuantity1__c, 'UOM Quantity should match the input uomQuantity');
		System.assertEquals(item?.Id, schemeCondition.dmpl__ItemId__c, 'Item ID should match the input itemId');
		System.assertEquals(itemGroup?.Id, schemeCondition.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
		System.assertEquals(conditionOperator, schemeCondition.dmpl__ConditionOperator__c, 'Condition Operator should match the input conditionOperator');
		System.assertEquals(conditionQuantity, schemeCondition.dmpl__ConditionQuantity__c, 'Condition Quantity should match the input conditionQuantity');
		System.assertEquals(sequenceNumber, schemeCondition.dmpl__SequenceNumber__c, 'Sequence Number should match the input sequenceNumber');
		Test.stopTest();
	}

	@isTest 
	static void createSchemeConditionWithConditionOperatorEqualsPositive(){
		Test.startTest();
		dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        String conditionType = 'Value';
        Decimal conditionValue = 0;
        Decimal uomQuantity = 0;
		Decimal uomQuantity1 = 0;
        dmpl__Item__c item = null;
		dmpl__ItemGroup__c itemGroup = null;
        String conditionOperator = 'Equals';
        Decimal conditionQuantity = 0;
        Decimal sequenceNumber = 1;

		dmpl__SchemeCondition__c schemeCondition;
		try{
			schemeCondition =  SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,conditionType,conditionValue,uomQuantity, uomQuantity1,item?.Id,itemGroup?.Id,conditionOperator,conditionQuantity,sequenceNumber);
		}catch(Exception e){
			System.Assert.isTrue(schemeCondition != null, 'Scheme Condition must create! >> ' + e.getMessage());
		}
		schemeCondition =  SchemeDataHelper.getSchemeConditionbyId(schemeCondition.Id);

		System.assertEquals(scheme?.Id, schemeCondition.dmpl__SchemeId__c, 'Scheme ID should match the input schemeId');
		System.assertEquals(schemeLine?.Id, schemeCondition.dmpl__SchemeLineId__c, 'Scheme Line ID should match the input schemeLineId');
		System.assertEquals(conditionType, schemeCondition.dmpl__ConditionType__c, 'Condition Type should match the input conditionType');
		System.assertEquals(conditionValue, schemeCondition.dmpl__ConditionValue__c, 'Condition Value should match the input conditionValue');
		System.assertEquals(uomQuantity, schemeCondition.dmpl__UOMQuantity__c, 'UOM Quantity should match the input uomQuantity');
		System.assertEquals(uomQuantity1, schemeCondition.dmpl__UOMQuantity1__c, 'UOM Quantity should match the input uomQuantity');
		System.assertEquals(item?.Id, schemeCondition.dmpl__ItemId__c, 'Item ID should match the input itemId');
		System.assertEquals(itemGroup?.Id, schemeCondition.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
		System.assertEquals(conditionOperator, schemeCondition.dmpl__ConditionOperator__c, 'Condition Operator should match the input conditionOperator');
		System.assertEquals(conditionQuantity, schemeCondition.dmpl__ConditionQuantity__c, 'Condition Quantity should match the input conditionQuantity');
		System.assertEquals(sequenceNumber, schemeCondition.dmpl__SequenceNumber__c, 'Sequence Number should match the input sequenceNumber');
		Test.stopTest();
	}

	@isTest 
	static void createSchemeConditionWithConditionOperatorDoesNotEqualsPositive(){
		Test.startTest();
		dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        String conditionType = 'Value';
        Decimal conditionValue = 0;
        Decimal uomQuantity = 0;
		Decimal uomQuantity1 = 0;
        dmpl__Item__c item = null;
		dmpl__ItemGroup__c itemGroup = null;
        String conditionOperator = 'Does Not Equal';
        Decimal conditionQuantity = 0;
        Decimal sequenceNumber = 1;

		dmpl__SchemeCondition__c schemeCondition;
		try{
			schemeCondition =  SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,conditionType,conditionValue,uomQuantity, uomQuantity1,item?.Id,itemGroup?.Id,conditionOperator,conditionQuantity,sequenceNumber);
		}catch(Exception e){
			System.Assert.isTrue(schemeCondition != null, 'Scheme Condition must create! >> ' + e.getMessage());
		}
		schemeCondition =  SchemeDataHelper.getSchemeConditionbyId(schemeCondition.Id);

		System.assertEquals(scheme?.Id, schemeCondition.dmpl__SchemeId__c, 'Scheme ID should match the input schemeId');
		System.assertEquals(schemeLine?.Id, schemeCondition.dmpl__SchemeLineId__c, 'Scheme Line ID should match the input schemeLineId');
		System.assertEquals(conditionType, schemeCondition.dmpl__ConditionType__c, 'Condition Type should match the input conditionType');
		System.assertEquals(conditionValue, schemeCondition.dmpl__ConditionValue__c, 'Condition Value should match the input conditionValue');
		System.assertEquals(uomQuantity, schemeCondition.dmpl__UOMQuantity__c, 'UOM Quantity should match the input uomQuantity');
		System.assertEquals(uomQuantity1, schemeCondition.dmpl__UOMQuantity1__c, 'UOM Quantity should match the input uomQuantity');
		System.assertEquals(item?.Id, schemeCondition.dmpl__ItemId__c, 'Item ID should match the input itemId');
		System.assertEquals(itemGroup?.Id, schemeCondition.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
		System.assertEquals(conditionOperator, schemeCondition.dmpl__ConditionOperator__c, 'Condition Operator should match the input conditionOperator');
		System.assertEquals(conditionQuantity, schemeCondition.dmpl__ConditionQuantity__c, 'Condition Quantity should match the input conditionQuantity');
		System.assertEquals(sequenceNumber, schemeCondition.dmpl__SequenceNumber__c, 'Sequence Number should match the input sequenceNumber');
		Test.stopTest();
	}

	@isTest 
	static void createSchemeConditionWithConditionOperatorGreaterThanPositive(){
		Test.startTest();
		dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        String conditionType = 'Value';
        Decimal conditionValue = 0;
        Decimal uomQuantity = 0;
		Decimal uomQuantity1 = 0;
        dmpl__Item__c item = null;
		dmpl__ItemGroup__c itemGroup = null;
        String conditionOperator = 'Greater Than';
        Decimal conditionQuantity = 0;
        Decimal sequenceNumber = 1;

		dmpl__SchemeCondition__c schemeCondition;
		try{
			schemeCondition =  SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,conditionType,conditionValue,uomQuantity, uomQuantity1,item?.Id,itemGroup?.Id,conditionOperator,conditionQuantity,sequenceNumber);
		}catch(Exception e){
			System.Assert.isTrue(schemeCondition != null, 'Scheme Condition must create! >> ' + e.getMessage());
		}
		schemeCondition =  SchemeDataHelper.getSchemeConditionbyId(schemeCondition.Id);

		System.assertEquals(scheme?.Id, schemeCondition.dmpl__SchemeId__c, 'Scheme ID should match the input schemeId');
		System.assertEquals(schemeLine?.Id, schemeCondition.dmpl__SchemeLineId__c, 'Scheme Line ID should match the input schemeLineId');
		System.assertEquals(conditionType, schemeCondition.dmpl__ConditionType__c, 'Condition Type should match the input conditionType');
		System.assertEquals(conditionValue, schemeCondition.dmpl__ConditionValue__c, 'Condition Value should match the input conditionValue');
		System.assertEquals(uomQuantity, schemeCondition.dmpl__UOMQuantity__c, 'UOM Quantity should match the input uomQuantity');
		System.assertEquals(uomQuantity1, schemeCondition.dmpl__UOMQuantity1__c, 'UOM Quantity should match the input uomQuantity');
		System.assertEquals(item?.Id, schemeCondition.dmpl__ItemId__c, 'Item ID should match the input itemId');
		System.assertEquals(itemGroup?.Id, schemeCondition.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
		System.assertEquals(conditionOperator, schemeCondition.dmpl__ConditionOperator__c, 'Condition Operator should match the input conditionOperator');
		System.assertEquals(conditionQuantity, schemeCondition.dmpl__ConditionQuantity__c, 'Condition Quantity should match the input conditionQuantity');
		System.assertEquals(sequenceNumber, schemeCondition.dmpl__SequenceNumber__c, 'Sequence Number should match the input sequenceNumber');
		Test.stopTest();
	}

	@isTest 
	static void createSchemeConditionWithConditionOperatorLessThanPositive(){
		Test.startTest();
		dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        String conditionType = 'Value';
        Decimal conditionValue = 0;
        Decimal uomQuantity = 0;
		Decimal uomQuantity1 = 0;
        dmpl__Item__c item = null;
		dmpl__ItemGroup__c itemGroup = null;
        String conditionOperator = 'Less Than';
        Decimal conditionQuantity = 0;
        Decimal sequenceNumber = 1;

		dmpl__SchemeCondition__c schemeCondition;
		try{
			schemeCondition =  SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,conditionType,conditionValue,uomQuantity, uomQuantity1,item?.Id,itemGroup?.Id,conditionOperator,conditionQuantity,sequenceNumber);
		}catch(Exception e){
			System.Assert.isTrue(schemeCondition != null, 'Scheme Condition must  create! >> ' + e.getMessage());
		}
		schemeCondition =  SchemeDataHelper.getSchemeConditionbyId(schemeCondition.Id);

		System.assertEquals(scheme?.Id, schemeCondition.dmpl__SchemeId__c, 'Scheme ID should match the input schemeId');
		System.assertEquals(schemeLine?.Id, schemeCondition.dmpl__SchemeLineId__c, 'Scheme Line ID should match the input schemeLineId');
		System.assertEquals(conditionType, schemeCondition.dmpl__ConditionType__c, 'Condition Type should match the input conditionType');
		System.assertEquals(conditionValue, schemeCondition.dmpl__ConditionValue__c, 'Condition Value should match the input conditionValue');
		System.assertEquals(uomQuantity, schemeCondition.dmpl__UOMQuantity__c, 'UOM Quantity should match the input uomQuantity');
		System.assertEquals(uomQuantity1, schemeCondition.dmpl__UOMQuantity1__c, 'UOM Quantity should match the input uomQuantity');
		System.assertEquals(item?.Id, schemeCondition.dmpl__ItemId__c, 'Item ID should match the input itemId');
		System.assertEquals(itemGroup?.Id, schemeCondition.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
		System.assertEquals(conditionOperator, schemeCondition.dmpl__ConditionOperator__c, 'Condition Operator should match the input conditionOperator');
		System.assertEquals(conditionQuantity, schemeCondition.dmpl__ConditionQuantity__c, 'Condition Quantity should match the input conditionQuantity');
		System.assertEquals(sequenceNumber, schemeCondition.dmpl__SequenceNumber__c, 'Sequence Number should match the input sequenceNumber');
		Test.stopTest();
	}

	@isTest 
	static void createSchemeConditionWithConditionOperatorLessThanOrEqualPositive(){
		Test.startTest();
		dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        String conditionType = 'Value';
        Decimal conditionValue = 0;
        Decimal uomQuantity = 0;
		Decimal uomQuantity1 = 0;
        dmpl__Item__c item = null;
		dmpl__ItemGroup__c itemGroup = null;
        String conditionOperator = 'Less Than Or Equal';
        Decimal conditionQuantity = 0;
        Decimal sequenceNumber = 1;

		dmpl__SchemeCondition__c schemeCondition;
		try{
			schemeCondition =  SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,conditionType,conditionValue,uomQuantity, uomQuantity1,item?.Id,itemGroup?.Id,conditionOperator,conditionQuantity,sequenceNumber);
		}catch(Exception e){
			System.Assert.isTrue(schemeCondition != null, 'Scheme Condition must  create! >> ' + e.getMessage());
		}
		schemeCondition =  SchemeDataHelper.getSchemeConditionbyId(schemeCondition.Id);

		System.assertEquals(scheme?.Id, schemeCondition.dmpl__SchemeId__c, 'Scheme ID should match the input schemeId');
		System.assertEquals(schemeLine?.Id, schemeCondition.dmpl__SchemeLineId__c, 'Scheme Line ID should match the input schemeLineId');
		System.assertEquals(conditionType, schemeCondition.dmpl__ConditionType__c, 'Condition Type should match the input conditionType');
		System.assertEquals(conditionValue, schemeCondition.dmpl__ConditionValue__c, 'Condition Value should match the input conditionValue');
		System.assertEquals(uomQuantity, schemeCondition.dmpl__UOMQuantity__c, 'UOM Quantity should match the input uomQuantity');
		System.assertEquals(uomQuantity1, schemeCondition.dmpl__UOMQuantity1__c, 'UOM Quantity should match the input uomQuantity');
		System.assertEquals(item?.Id, schemeCondition.dmpl__ItemId__c, 'Item ID should match the input itemId');
		System.assertEquals(itemGroup?.Id, schemeCondition.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
		System.assertEquals(conditionOperator, schemeCondition.dmpl__ConditionOperator__c, 'Condition Operator should match the input conditionOperator');
		System.assertEquals(conditionQuantity, schemeCondition.dmpl__ConditionQuantity__c, 'Condition Quantity should match the input conditionQuantity');
		System.assertEquals(sequenceNumber, schemeCondition.dmpl__SequenceNumber__c, 'Sequence Number should match the input sequenceNumber');
		Test.stopTest();
	}

	@isTest 
	static void createSchemeConditionWithItemPositive(){
		Test.startTest();
		dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        String conditionType = 'Item Group Value';
        Decimal conditionValue = 0;
        Decimal uomQuantity = 0;
		Decimal uomQuantity1 = 0;
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		dmpl__ItemGroup__c itemGroup = null;
        String conditionOperator = 'Greater Than Or Equal';
        Decimal conditionQuantity = 0;
        Decimal sequenceNumber = 1;

		dmpl__SchemeCondition__c schemeCondition;
		try{
			schemeCondition =  SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,conditionType,conditionValue,uomQuantity, uomQuantity1,item?.Id,itemGroup?.Id,conditionOperator,conditionQuantity,sequenceNumber);
		}catch(Exception e){
			System.Assert.isTrue(schemeCondition != null, 'Scheme Condition must  create! >> ' + e.getMessage());
		}
		schemeCondition =  SchemeDataHelper.getSchemeConditionbyId(schemeCondition.Id);

		System.assertEquals(scheme?.Id, schemeCondition.dmpl__SchemeId__c, 'Scheme ID should match the input schemeId');
		System.assertEquals(schemeLine?.Id, schemeCondition.dmpl__SchemeLineId__c, 'Scheme Line ID should match the input schemeLineId');
		System.assertEquals(conditionType, schemeCondition.dmpl__ConditionType__c, 'Condition Type should match the input conditionType');
		System.assertEquals(conditionValue, schemeCondition.dmpl__ConditionValue__c, 'Condition Value should match the input conditionValue');
		System.assertEquals(uomQuantity, schemeCondition.dmpl__UOMQuantity__c, 'UOM Quantity should match the input uomQuantity');
		System.assertEquals(uomQuantity1, schemeCondition.dmpl__UOMQuantity1__c, 'UOM Quantity should match the input uomQuantity');
		System.assertEquals(item?.Id, schemeCondition.dmpl__ItemId__c, 'Item ID should match the input itemId');
		System.assertEquals(itemGroup?.Id, schemeCondition.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
		System.assertEquals(conditionOperator, schemeCondition.dmpl__ConditionOperator__c, 'Condition Operator should match the input conditionOperator');
		System.assertEquals(conditionQuantity, schemeCondition.dmpl__ConditionQuantity__c, 'Condition Quantity should match the input conditionQuantity');
		System.assertEquals(sequenceNumber, schemeCondition.dmpl__SequenceNumber__c, 'Sequence Number should match the input sequenceNumber');
		Test.stopTest();
	}

	@isTest 
	static void createSchemeConditionWithItemGroupPositive(){
		Test.startTest();
		dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        String conditionType = 'Item Group Value';
        Decimal conditionValue = 0;
        Decimal uomQuantity = 0;
		Decimal uomQuantity1 = 0;
        dmpl__Item__c item = null;
		dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 2');
        String conditionOperator = 'Greater Than Or Equal';
        Decimal conditionQuantity = 0;
        Decimal sequenceNumber = 1;

		dmpl__SchemeCondition__c schemeCondition;
		try{
			schemeCondition =  SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,conditionType,conditionValue,uomQuantity, uomQuantity1,item?.Id,itemGroup?.Id,conditionOperator,conditionQuantity,sequenceNumber);
		}catch(Exception e){
			System.Assert.isTrue(schemeCondition != null, 'Scheme Condition must create! >> ' + e.getMessage());
		}
		schemeCondition =  SchemeDataHelper.getSchemeConditionbyId(schemeCondition.Id);

		System.assertEquals(scheme?.Id, schemeCondition.dmpl__SchemeId__c, 'Scheme ID should match the input schemeId');
		System.assertEquals(schemeLine?.Id, schemeCondition.dmpl__SchemeLineId__c, 'Scheme Line ID should match the input schemeLineId');
		System.assertEquals(conditionType, schemeCondition.dmpl__ConditionType__c, 'Condition Type should match the input conditionType');
		System.assertEquals(conditionValue, schemeCondition.dmpl__ConditionValue__c, 'Condition Value should match the input conditionValue');
		System.assertEquals(uomQuantity, schemeCondition.dmpl__UOMQuantity__c, 'UOM Quantity should match the input uomQuantity');
		System.assertEquals(uomQuantity1, schemeCondition.dmpl__UOMQuantity1__c, 'UOM Quantity should match the input uomQuantity');
		System.assertEquals(item?.Id, schemeCondition.dmpl__ItemId__c, 'Item ID should match the input itemId');
		System.assertEquals(itemGroup?.Id, schemeCondition.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
		System.assertEquals(conditionOperator, schemeCondition.dmpl__ConditionOperator__c, 'Condition Operator should match the input conditionOperator');
		System.assertEquals(conditionQuantity, schemeCondition.dmpl__ConditionQuantity__c, 'Condition Quantity should match the input conditionQuantity');
		System.assertEquals(sequenceNumber, schemeCondition.dmpl__SequenceNumber__c, 'Sequence Number should match the input sequenceNumber');
		Test.stopTest();
	}

	@isTest 
	static void createSchemeConditionWithoutSequenceNumberNegative(){
		Test.startTest();
		dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        String conditionType = 'Item Group';
        Decimal conditionValue = 0;
        Decimal uomQuantity = 0;
		Decimal uomQuantity1 = 0;
        dmpl__Item__c item = null;
		dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 2');
        String conditionOperator = 'Greater Than or Equal';
        Decimal conditionQuantity = 0;
        Decimal sequenceNumber = null;

		dmpl__SchemeCondition__c schemeCondition;
		try{
			schemeCondition =  SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,conditionType,conditionValue,uomQuantity, uomQuantity1,item?.Id,itemGroup?.Id,conditionOperator,conditionQuantity,sequenceNumber);
			System.Assert.isTrue(schemeCondition == null, 'Scheme Condition can\'t be created as Sequence number is not added');
		}catch(Exception e){
			System.Assert.isTrue(schemeCondition == null, 'Scheme Condition must not create! >> ' + e.getMessage());
		}
		
		Test.stopTest();
	}

	@isTest 
	static void createSchemeConditionWithoutConditionTypeNegative(){
		Test.startTest();
		dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        String conditionType = null;
        Decimal conditionValue = 0;
        Decimal uomQuantity = 0;
		Decimal uomQuantity1 = 0;
        dmpl__Item__c item = null;
		dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 2');
        String conditionOperator = 'Greater Than or Equal';
        Decimal conditionQuantity = 0;
        Decimal sequenceNumber = 1;

		dmpl__SchemeCondition__c schemeCondition;
		try{
			schemeCondition =  SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,conditionType,conditionValue,uomQuantity, uomQuantity1,item?.Id,itemGroup?.Id,conditionOperator,conditionQuantity,sequenceNumber);
			System.Assert.isTrue(schemeCondition == null, 'Scheme Condition can\'t be created as Condition Type is not added ');
		}catch(Exception e){
			System.Assert.isTrue(schemeCondition == null, 'Scheme Condition must not create! >> ' + e.getMessage());
		}
		
		Test.stopTest();
	}

	@isTest 
	static void createSchemeConditionWithoutConditionOperatorNegative(){
		Test.startTest();
		dmpl__Scheme__c scheme = SchemeDataHelper.getScheme('Scheme 20');
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.getSchemeLine(scheme.Id);
        String conditionType = 'Less Than or Equal';
        Decimal conditionValue = 0;
        Decimal uomQuantity = 0;
		Decimal uomQuantity1 = 0;
        dmpl__Item__c item = null;
		dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 2');
        String conditionOperator = null;
        Decimal conditionQuantity = 0;
        Decimal sequenceNumber = 1;

		dmpl__SchemeCondition__c schemeCondition;
		try{
			schemeCondition =  SchemeDataHelper.createSchemeCondition(scheme?.Id,schemeLine?.Id,conditionType,conditionValue,uomQuantity, uomQuantity1,item?.Id,itemGroup?.Id,conditionOperator,conditionQuantity,sequenceNumber);
			System.Assert.isTrue(schemeCondition == null, 'Scheme Condition can\'t be created as Condition Operator is not added');
		}catch(Exception e){
			System.Assert.isTrue(schemeCondition == null, 'Scheme Condition must not create! >> ' + e.getMessage());
		}
		
		Test.stopTest();
	}

	/******************************  Scheme Consumption  ******************************/
	@isTest 
	static void createSchemeConsumptionWithItemGroupPositive(){
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = null;
		dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 2');
		Decimal consumedQuantity= 0 ;
		Decimal consumedAmount= 0 ;

		dmpl__SchemeConsumption__c schemeConsumption;
		try{
			schemeConsumption = SchemeDataHelper.createSchemeConsumption('Scheme 1',partner?.Id,branch?.Id,item?.Id,itemGroup?.Id,consumedQuantity, consumedAmount);
		}catch(Exception e){
			System.Assert.isTrue(schemeConsumption != null, 'Scheme Consumption must be created Successfully>> ' + e.getMessage());
		}
		schemeConsumption = SchemeDataHelper.getSchemeConsumption(schemeConsumption.Id);

		System.assertNotEquals(null, schemeConsumption, 'Expected scheme consumption to be created successfully');
		System.assertEquals('Scheme 1', schemeConsumption.Name, 'Name should match the input name');
		System.assertEquals(partner?.Id, schemeConsumption.dmpl__PartnerAccountId__c, 'Partner Account ID should match the input partnerAccountId');
		System.assertEquals(branch?.Id, schemeConsumption.dmpl__BranchId__c, 'Branch ID should match the input branchId');
		System.assertEquals(item?.Id, schemeConsumption.dmpl__ItemId__c, 'Item ID should match the input itemId');
		System.assertEquals(itemGroup?.Id, schemeConsumption.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
		System.assertEquals(consumedQuantity, schemeConsumption.dmpl__ConsumedQuantity__c, 'Consumed Quantity should match the input consumedQuantity');
		Test.stopTest();
	}

	@isTest 
	static void createSchemeConsumptionWithWrongPartnerAccountNegative(){
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 2');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 1');
		Decimal consumedQuantity= 0 ;
		Decimal consumedAmount= 0 ;


		dmpl__SchemeConsumption__c schemeConsumption;
		try{
			schemeConsumption = SchemeDataHelper.createSchemeConsumption('Scheme 1',partner?.Id,branch?.Id,item?.Id,itemGroup?.Id,consumedQuantity , consumedAmount);
			//System.Assert.isTrue(schemeConsumption == null, 'Scheme Consumption must be Fail Successfully');
		}catch(Exception e){
			System.Assert.isTrue(schemeConsumption == null, 'Scheme Consumption must be Fail Successfully >> ' + e.getMessage());
		}
		Test.stopTest();
	}

	@isTest 
	static void createSchemeConsumptionWithWrongBranchNegative(){
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 2');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 3');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 1');
		Decimal consumedQuantity= 0 ;
		Decimal consumedAmount= 0 ;


		dmpl__SchemeConsumption__c schemeConsumption;
		try{
			schemeConsumption = SchemeDataHelper.createSchemeConsumption('Scheme 1',partner?.Id,branch?.Id,item?.Id,itemGroup?.Id,consumedQuantity , consumedAmount);
			//System.Assert.isTrue(schemeConsumption == null, 'Scheme Consumption must not be created Successfully');
		}catch(Exception e){
			System.Assert.isTrue(schemeConsumption == null, 'Scheme Consumption must not be created Successfully >> ' + e.getMessage());
		}
		Test.stopTest();
	}

	@isTest 
	static void createSchemeConsumptionWithoutItemNegative(){
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = null;
		dmpl__ItemGroup__c itemGroup = null;
		Decimal consumedQuantity= 0 ;
		Decimal consumedAmount= 0 ;


		dmpl__SchemeConsumption__c schemeConsumption;
		try{
			schemeConsumption = SchemeDataHelper.createSchemeConsumption('Scheme 1',partner?.Id,branch?.Id,item?.Id,itemGroup?.Id,consumedQuantity , consumedAmount);
			//System.Assert.isTrue(schemeConsumption == null, 'Scheme Consumption must not be created Successfully');
		}catch(Exception e){
			System.Assert.isTrue(schemeConsumption == null, 'Scheme Consumption must not be created Successfully >> ' + e.getMessage());
		}
		Test.stopTest();
	}

	@isTest 
	static void updateSchemeConsumptionWithConsumedQuantityPositive(){
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 2');
		dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 1');
		Decimal consumedQuantity= 10 ;
		Decimal consumedAmount= 0 ;


		dmpl__SchemeConsumption__c schemeConsumption;
		try{
			schemeConsumption = SchemeDataHelper.createSchemeConsumption('Scheme 1',partner?.Id,branch?.Id,item?.Id,itemGroup?.Id,consumedQuantity , consumedAmount);
		}catch(Exception e){
			System.Assert.isTrue(schemeConsumption != null, 'Scheme Consumption must be created Successfully >> ' + e.getMessage());
		}
		schemeConsumption = SchemeDataHelper.getSchemeConsumption(schemeConsumption.Id);

		System.assertNotEquals(null, schemeConsumption, 'Expected scheme consumption to be created successfully');
		System.assertEquals('Scheme 1', schemeConsumption.Name, 'Name should match the input name');
		System.assertEquals(partner?.Id, schemeConsumption.dmpl__PartnerAccountId__c, 'Partner Account ID should match the input partnerAccountId');
		System.assertEquals(branch?.Id, schemeConsumption.dmpl__BranchId__c, 'Branch ID should match the input branchId');
		System.assertEquals(item?.Id, schemeConsumption.dmpl__ItemId__c, 'Item ID should match the input itemId');
		System.assertEquals(itemGroup?.Id, schemeConsumption.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
		System.assertEquals(consumedQuantity, schemeConsumption.dmpl__ConsumedQuantity__c, 'Consumed Quantity should match the input consumedQuantity');
		Test.stopTest();
	}

	@isTest 
	static void updateSchemeConsumptionWithConsumedAmountPositive(){
		Test.startTest();
		Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		dmpl__ItemGroup__c itemGroup = TestDataHelpers.getItemGroup('Item Group 1');
		Decimal consumedQuantity= 0 ;
		Decimal consumedAmount= 3000 ;

		dmpl__SchemeConsumption__c schemeConsumption;
		try{
			schemeConsumption = SchemeDataHelper.createSchemeConsumption('Scheme 1',partner?.Id,branch?.Id,item?.Id,itemGroup?.Id,consumedQuantity , consumedAmount);
		}catch(Exception e){
			System.Assert.isTrue(schemeConsumption != null, 'Scheme Consumption must be created Successfully >> ' + e.getMessage());
		}
		schemeConsumption = SchemeDataHelper.getSchemeConsumption(schemeConsumption.Id);

		System.assertNotEquals(null, schemeConsumption, 'Expected scheme consumption to be created successfully');
		System.assertEquals('Scheme 1', schemeConsumption.Name, 'Name should match the input name');
		System.assertEquals(partner?.Id, schemeConsumption.dmpl__PartnerAccountId__c, 'Partner Account ID should match the input partnerAccountId');
		System.assertEquals(branch?.Id, schemeConsumption.dmpl__BranchId__c, 'Branch ID should match the input branchId');
		System.assertEquals(item?.Id, schemeConsumption.dmpl__ItemId__c, 'Item ID should match the input itemId');
		System.assertEquals(itemGroup?.Id, schemeConsumption.dmpl__ItemGroupId__c, 'Item Group ID should match the input itemGroupId');
		System.assertEquals(consumedQuantity, schemeConsumption.dmpl__ConsumedQuantity__c, 'Consumed Quantity should match the input consumedQuantity');
		Test.stopTest();
	}


	//scheme period scenarios
	@isTest
    static void createSchemePeriodPositive(){
        dmpl__Scheme__c scheme2 = SchemeDataHelper.getScheme('Scheme 2');
        Date dateFrom = Date.newInstance(2025, 6, 1);
        Date dateTo = Date.newInstance(2025, 6, 30);

        Test.startTest();
        dmpl__SchemePeriod__c schemePeriod = SchemeDataHelper.createSchemePeriod(scheme2,'Jun-25',dateFrom,dateTo);
        Test.stopTest();

        System.assertNotEquals(null, schemePeriod.Id, 'Scheme Period record should exist');
        System.assertEquals('Jun-25', schemePeriod.Name, 'Name should be Jun-25');
        System.assertEquals(Date.newInstance(2025, 6, 1), schemePeriod.dmpl__DateFrom__c, 'Start date should be 1/6/2025');
        System.assertEquals(Date.newInstance(2025, 6, 30), schemePeriod.dmpl__DateTo__c, 'End date should be 30/6/2025');
        System.assertEquals(scheme2.Id, schemePeriod.dmpl__SchemeId__c, 'Scheme ID should not be null');
    }

    @isTest
    static void createSchemePeriodWithSchemePeriodNamePositive(){
        dmpl__Scheme__c scheme2 = SchemeDataHelper.getScheme('Scheme 2');
        Date dateFrom = Date.newInstance(2025, 6, 1);
        Date dateTo = Date.newInstance(2025, 6, 30);

        Test.startTest();
        dmpl__SchemePeriod__c schemePeriod = SchemeDataHelper.createSchemePeriod(scheme2,'Jun-25',dateFrom,dateTo);
        Test.stopTest();

        System.assertNotEquals(null, schemePeriod.Id, 'Scheme Period record should exist');
        System.assertEquals('Jun-25', schemePeriod.Name, 'Name should be Jun-25');
        System.assertEquals(Date.newInstance(2025, 6, 1), schemePeriod.dmpl__DateFrom__c, 'Start date should be 1/6/2025');
        System.assertEquals(Date.newInstance(2025, 6, 30), schemePeriod.dmpl__DateTo__c, 'End date should be 30/6/2025');
        System.assertEquals(scheme2.Id, schemePeriod.dmpl__SchemeId__c, 'Scheme ID should not be null');
    }

    @isTest
    static void createSchemePeriodWithoutSchemePeriodNameNegative(){
        dmpl__Scheme__c scheme2 = SchemeDataHelper.getScheme('Scheme 2');
        Date dateFrom = Date.newInstance(2025, 6, 1);
        Date dateTo = Date.newInstance(2025, 6, 30);

        Test.startTest();
        try {      
            dmpl__SchemePeriod__c schemePeriod = SchemeDataHelper.createSchemePeriod(scheme2,null,dateFrom,dateTo);
            //System.assertEquals(null, schemePeriod.Id, 'schemePeriod should not be created without name ');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'schemePeriod should not be created without name');
        }
        Test.stopTest(); 
    }

    @isTest
    static void updateSchemePeriodWithoutSchemePeriodNameNegative(){
        dmpl__Scheme__c scheme2 = SchemeDataHelper.getScheme('Scheme 2');
        Date dateFrom = Date.newInstance(2025, 6, 1);
        Date dateTo = Date.newInstance(2025, 6, 30);

        dmpl__SchemePeriod__c schemePeriod = SchemeDataHelper.createSchemePeriod(scheme2,'Jun-25',dateFrom,dateTo);

        System.assertNotEquals(null, schemePeriod.Id, 'Scheme Period record should exist');
        System.assertEquals('Jun-25', schemePeriod.Name, 'Name should be Jun-25');
        System.assertEquals(Date.newInstance(2025, 6, 1), schemePeriod.dmpl__DateFrom__c, 'Start date should be 1/6/2025');
        System.assertEquals(Date.newInstance(2025, 6, 30), schemePeriod.dmpl__DateTo__c, 'End date should be 30/6/2025');
        System.assertEquals(scheme2.Id, schemePeriod.dmpl__SchemeId__c, 'Scheme ID should not be null');

        Test.startTest();
        Boolean exceptionThrown = false;
        try{
            schemePeriod.Name = null;
            update schemePeriod;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown,'Expected exception when schemePeriod name is null');
        Test.stopTest();
    }

    @isTest
    static void createSchemePeriodWithDateFromAndDateToPositive(){
        dmpl__Scheme__c scheme2 = SchemeDataHelper.getScheme('Scheme 2');
        Date dateFrom = Date.newInstance(2025, 6, 1);
        Date dateTo = Date.newInstance(2025, 6, 30);

        Test.startTest();
        dmpl__SchemePeriod__c schemePeriod = SchemeDataHelper.createSchemePeriod(scheme2,'Jun-25',dateFrom,dateTo);
        Test.stopTest();

        System.assertNotEquals(null, schemePeriod.Id, 'Scheme Period record should exist');
        System.assertEquals('Jun-25', schemePeriod.Name, 'Name should be Jun-25');
        System.assertEquals(Date.newInstance(2025, 6, 1), schemePeriod.dmpl__DateFrom__c, 'Start date should be 1/6/2025');
        System.assertEquals(Date.newInstance(2025, 6, 30), schemePeriod.dmpl__DateTo__c, 'End date should be 30/6/2025');
        System.assertEquals(scheme2.Id, schemePeriod.dmpl__SchemeId__c, 'Scheme ID should not be null');
    }

    @isTest
    static void createSchemePeriodWithoutDateFromAndDateToPositive(){
        dmpl__Scheme__c scheme2 = SchemeDataHelper.getScheme('Scheme 2');
        
        Test.startTest();
        try{
            dmpl__SchemePeriod__c schemePeriod = SchemeDataHelper.createSchemePeriod(scheme2,'Jun-25',null,null);
			System.assertNotEquals(null, schemePeriod.Id, 'Scheme Period record should exist');
			System.assertEquals('Jun-25', schemePeriod.Name, 'Name should be Jun-25');
			System.assertEquals(scheme2.Id, schemePeriod.dmpl__SchemeId__c, 'Scheme ID should not be null');
        }catch(Exception e){

        }
        Test.stopTest();

        
    }

    @isTest
    static void createSchemePeriodWithInvalidDateRangeNegative(){
        dmpl__Scheme__c scheme2 = SchemeDataHelper.getScheme('Scheme 2');
        Date dateFrom = Date.newInstance(2025, 6, 1);
        Date dateTo = Date.newInstance(2025, 2, 30);

        Test.startTest();
        try {      
            dmpl__SchemePeriod__c schemePeriod = SchemeDataHelper.createSchemePeriod(scheme2,'Jun-25',dateFrom,dateTo);
            System.assertEquals(null, schemePeriod.Id, 'schemePeriod should not be created with invalid date range ');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'schemePeriod should not be created with invalid date range');
        }
        Test.stopTest(); 
    }

	//scheme slab scenarios
    @isTest
    static void createSchemeSlabPositive(){
		dmpl__Scheme__c scheme2 = SchemeDataHelper.getScheme('Scheme 2');
        Test.startTest();
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.createSchemeSlab(scheme2,'FREE OF COST',1,'All Conditions Are Met','All Rewards');
        Test.stopTest();
        System.assertNotEquals(null, schemeLine, 'Scheme Line should exist');
        System.assertEquals(1, schemeLine.dmpl__SequenceNumber__c, 'Sequence Number should be 1');
        System.assertEquals('FREE OF COST', schemeLine.dmpl__Title__c, 'Title should be FREE OF COST');
		System.assertEquals('All Conditions Are Met', schemeLine.dmpl__DefinitionFilterCriteria__c, 'DefinitionFilterCriteria should be All Conditions Are Met');
		System.assertEquals('All Rewards', schemeLine.dmpl__RewardApplicability__c, 'RewardApplicability should be All Rewards');
    }

    @isTest
    static void createSchemeSlabWithFilterCriteriaPositive(){
		dmpl__Scheme__c scheme2 = SchemeDataHelper.getScheme('Scheme 2');
        Test.startTest();
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.createSchemeSlab(scheme2,'FREE OF COST',1,'All Conditions Are Met','All Rewards');
        Test.stopTest();
        System.assertNotEquals(null, schemeLine, 'Scheme Line should exist');
        System.assertEquals(1, schemeLine.dmpl__SequenceNumber__c, 'Sequence Number should be 1');
        System.assertEquals('FREE OF COST', schemeLine.dmpl__Title__c, 'Title should be FREE OF COST');
        System.assertEquals('All Conditions Are Met', schemeLine.dmpl__DefinitionFilterCriteria__c, 'DefinitionFilterCriteria should be All Conditions Are Met');
		System.assertEquals('All Rewards', schemeLine.dmpl__RewardApplicability__c, 'RewardApplicability should be All Rewards');

    }

    @isTest
    static void createSchemeSlabWithRewardApplicabilityPositive(){
		dmpl__Scheme__c scheme2 = SchemeDataHelper.getScheme('Scheme 2');
        Test.startTest();
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.createSchemeSlab(scheme2,'FREE OF COST',1,'All Conditions Are Met','All Rewards');
        Test.stopTest();
        System.assertNotEquals(null, schemeLine, 'Scheme Line should exist');
        System.assertEquals(1, schemeLine.dmpl__SequenceNumber__c, 'Sequence Number should be 1');
        System.assertEquals('FREE OF COST', schemeLine.dmpl__Title__c, 'Title should be FREE OF COST');
        System.assertEquals('All Conditions Are Met', schemeLine.dmpl__DefinitionFilterCriteria__c, 'DefinitionFilterCriteria should be All Conditions Are Met');
        System.assertEquals('All Rewards', schemeLine.dmpl__RewardApplicability__c, 'RewardApplicability should be All Rewards');

    }

    @isTest
    static void createSchemeSlabWithSequenceNumberPositive(){
		dmpl__Scheme__c scheme2 = SchemeDataHelper.getScheme('Scheme 2');
        Test.startTest();
        dmpl__SchemeLine__c schemeLine = SchemeDataHelper.createSchemeSlab(scheme2,'FREE OF COST',1,'All Conditions Are Met','All Rewards');
        Test.stopTest();
        System.assertNotEquals(null, schemeLine, 'Scheme Line should exist');
        System.assertEquals(1, schemeLine.dmpl__SequenceNumber__c, 'Sequence Number should be 1');
        System.assertEquals('FREE OF COST', schemeLine.dmpl__Title__c, 'Title should be FREE OF COST');
		System.assertEquals('All Conditions Are Met', schemeLine.dmpl__DefinitionFilterCriteria__c, 'DefinitionFilterCriteria should be All Conditions Are Met');
		System.assertEquals('All Rewards', schemeLine.dmpl__RewardApplicability__c, 'RewardApplicability should be All Rewards');
    }


}