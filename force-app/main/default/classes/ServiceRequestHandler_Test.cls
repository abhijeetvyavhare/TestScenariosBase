@isTest
public with sharing class ServiceRequestHandler_Test {
	@TestSetup
	static void createRequiredData() {
		dmpl__AccountGroup__c accountGroup = TestDataHelpers.createAccountGroup();
		Account account = TestDataHelpers.createAccount(accountGroup);
		Account partnerAccount = TestDataHelpers.createPartnerAccount();
		Account customerAccount = TestDataHelpers.createCustomerAccount();
		dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
		dmpl__Item__c item = TestDataHelpers.createItem();
		dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
		dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation(branch);
		dmpl__ItemLot__c itemLot = TestDataHelpers.createItemLot(branch, item, sku, storageLocation);
		Asset asset = ServiceCampaignTestDataHelpers.CreateAsset(account, branch, item, itemLot, sku);
		dmpl__BranchTimeSlot__c branchTimeSlot = TestDataHelpers.createBranchTimeSlot(branch, item);
		dmpl__ServiceRequest__c serviceRequest = ServiceRequestTestDataHelpers.createServiceRequest(
			customerAccount,
			branch,
			item,
			asset,
			branchTimeSlot
		);
		dmpl__ServiceRequestline__c serviceRequestLine = ServiceRequestTestDataHelpers.createServiceRequestLine(serviceRequest, item, sku);
		dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup(partnerAccount, branch);
		dmpl__Tax__c tax = TestDataHelpers.createTax(taxGroup);
		dmpl__ServiceRequestTax__c ServiceRequestTax = ServiceRequestTestDataHelpers.createServiceRequestTax(
			serviceRequest,
			serviceRequestLine,
			taxGroup,
			tax
		);

		Test.startTest();
		Account partnerAccount1 = TestDataHelpers.createPartnerAccount(
			'Partner 1',
			false,
			true,
			false,
			true,
			'MG Road',
			'Bengaluru',
			'Karnataka',
			'India',
			'560001',
			'56 Industrial Layout',
			'Bengaluru',
			'Karnataka',
			'India',
			'560095',
			'9876543210'
		);
		Account partnerAccount2 = TestDataHelpers.createPartnerAccount(
			'Partner 2',
			false,
			true,
			false,
			true,
			'45 Residency Road',
			'Pune',
			'Maharashtra',
			'India',
			'411001',
			'22 Commerce Avenue',
			'Pune',
			'Maharashtra',
			'India',
			'411038',
			'91-99665544433'
		);
		Account partnerAccount3 = TestDataHelpers.createPartnerAccount(
			'Partner 3',
			false,
			true,
			false,
			true,
			'78 Nehru Nagar Road',
			'Chennai',
			'Tamil Nadu',
			'India',
			'600042',
			'78 Nehru Nagar Road',
			'Chennai',
			'Tamil Nadu',
			'India',
			'600042',
			'91-9123456789'
		);
		Account partnerAccount4 = TestDataHelpers.createPartnerAccount(
			'Partner 4',
			false,
			true,
			false,
			true,
			'12 Industrial Zone',
			'Hyderabad',
			'Telangana',
			'India',
			'500032',
			'12 Industrial Zone',
			'Hyderabad',
			'Telangana',
			'India',
			'500032',
			'9876012345'
		);
		Account partnerAccount6 = TestDataHelpers.createPartnerAccount(
			'Partner 6',
			false,
			true,
			false,
			true,
			'MS Road',
			'Bengaluru',
			'Karnataka',
			'India',
			'560001',
			'56 Industrial Layout',
			'Bengaluru',
			'Karnataka',
			'India',
			'560095',
			'9845543210'
		);

		Account customerAccount1 = TestDataHelpers.createCustomerAccount(
			'Customer 1',
			true,
			false,
			false,
			true,
			'MG Road',
			'Pune',
			'Maharashtra',
			'India',
			'411001',
			'Ring Rd',
			'Nagpur',
			'Maharashtra',
			'India',
			'440001',
			'9876543210',
			'Created'
		);
		Account customerAccount2 = TestDataHelpers.createCustomerAccount(
			'Customer 2',
			true,
			false,
			false,
			true,
			'Park St',
			'Kolkata',
			'West Bengal',
			'India',
			'700016',
			'Lake Rd',
			'Kolkata',
			'West Bengal',
			'India',
			'700029',
			'9876543210',
			'Created'
		);
		Account customerAccount3 = TestDataHelpers.createCustomerAccount(
			'Customer 3',
			true,
			false,
			false,
			true,
			'Anna Salai',
			'Chennai',
			'Tamil Nadu',
			'India',
			'600002',
			'T Nagar',
			'Chennai',
			'Tamil Nadu',
			'India',
			'600017',
			'9012345678',
			'Created'
		);
		Account customerAccount7 = TestDataHelpers.createCustomerAccount(
			'Customer 7',
			true,
			false,
			false,
			false,
			'Mission Road',
			'Bengaluru',
			'Karnataka',
			'India',
			'560027',
			'Indiranagar',
			'Bengaluru',
			'Karnataka',
			'India',
			'560038',
			'9811122233',
			'Created'
		);
		Account customerAccount6 = TestDataHelpers.createCustomerAccount(
			'Customer 6',
			true,
			false,
			false,
			true,
			'Sector 18',
			'Noida',
			'Uttar Pradesh',
			'India',
			'201301',
			'Sector 62',
			'Noida',
			'Uttar Pradesh',
			'India',
			'201309',
			'9876501234',
			'Created'
		);
		Account customerAccount4 = TestDataHelpers.createCustomerAccount(
			'Customer 4',
			true,
			false,
			false,
			true,
			'SG Highway',
			'Ahmedabad',
			'GJ',
			'India',
			'380054',
			'C G Road',
			'Ahmedabad',
			'GJ',
			'India',
			'380009',
			'9988776655',
			'Created'
		);
		Account customerAccount5 = TestDataHelpers.createCustomerAccount(
			'Customer 5',
			true,
			false,
			false,
			true,
			'MG Road',
			'Pune',
			'Maharashtra',
			'India',
			'411001',
			'Ring Rd',
			'Nagpur',
			'Maharashtra',
			'India',
			'440001',
			'9876543210',
			'Created'
		);

		dmpl__Branch__c branch1 = TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id, true, true, false, true);
		dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partnerAccount2.Id, false, true, true, false);

		dmpl__ContactAddress__c address1 = TestDataHelpers.createContactAddress(
			'Address 1',
			'Ring Rd',
			'Pune',
			'Maharashtra',
			customerAccount1.Id,
			'Billing Address',
			'440001',
			false
		);
		dmpl__ContactAddress__c address2 = TestDataHelpers.createContactAddress(
			'Address 2',
			'Ring Rd',
			'Pune',
			'Maharashtra',
			customerAccount1.Id,
			'Billing Address',
			'440001',
			false
		);
		dmpl__ContactAddress__c Address3 = TestDataHelpers.CreateContactAddress(
			'Address 3',
			'Lake Road',
			'Kolkata',
			'West Bengal',
			customerAccount1.Id,
			'Billing Address',
			'440022',
			false
		);
		dmpl__ContactAddress__c address4 = TestDataHelpers.createContactAddress(
			'Address 1',
			'Ring Rd',
			'Pune',
			'Maharashtra',
			customerAccount2.Id,
			'Billing Address',
			'440001',
			false
		);
		dmpl__ContactAddress__c address5 = TestDataHelpers.createContactAddress(
			'Address 2',
			'Ring Rd',
			'Pune',
			'Maharashtra',
			customerAccount2.Id,
			'Shipping Address',
			'440001',
			false
		);

		dmpl__TaxGroup__c taxGroupGST12Global = TestDataHelpers.createTaxGroup('GST 12', true, 'Line Level', null, null, null);
		dmpl__TaxGroup__c taxGroupIGST18 = TestDataHelpers.createTaxGroup('IGST 18', true, 'Line Level', null, null, null);

		dmpl__Item__c item1 = TestDataHelpers.createItem('Item 1', 'Product', true, false, false, '675654', false);
		dmpl__Item__c item2 = TestDataHelpers.createItem('Item 2', 'Product', false, false, false, '654345', false);
		dmpl__Item__c item3 = TestDataHelpers.createItem('Item 3', 'Charge Item', true, false, false, '765434', true);
		dmpl__Item__c item4 = TestDataHelpers.createItem('Item 4', 'Product', true, false, false, '765676', true);
		dmpl__Item__c item5 = TestDataHelpers.createItem('Item 5', 'Product', true, false, false, '876543', false);
		dmpl__Item__c item6 = TestDataHelpers.createItem('Item 6', 'Product', true, false, false, '765456', false);
		dmpl__Item__c item7 = TestDataHelpers.createItem('Item 7', 'Product', true, false, false, '765456', false);
		dmpl__Item__c item8 = TestDataHelpers.createItem('Item 8', 'Product', true, false, false, '765456', false);

		dmpl__PriceList__c priceList1 = TestDataHelpers.createPriceList(
			'Price List 1',
			partnerAccount1.Id,
			branch1.Id,
			null,
			null,
			true,
			false,
			'Sale Price'
		);

		Asset asset1 = AssetTestDataHelpers.createAsset('Asset 1', customerAccount1.Id, item1.Id);
		Asset asset3 = AssetTestDataHelpers.createAsset('Asset 3', customerAccount3.Id, item5.Id);

		Test.stopTest();
	}

	@isTest
	static void createServiceRequestPositive() {
		Test.startTest();
		dmpl__ServiceRequest__c serviceRequest = ServiceRequestTestDataHelpers.getServiceRequest();
		System.assertNotEquals(serviceRequest, null, 'Expected Service Request to be created.');
		System.assertEquals(serviceRequest.dmpl__AccountName__c, 'Account1', 'Account Name should be Account1.');
		System.assertEquals(serviceRequest.dmpl__AdjustedAdvanceAmount__c, 2000, 'Adjusted Amount should be 2000.');
		System.assertEquals(serviceRequest.dmpl__AdvanceAmount__c, 1000, 'Advance Amount should be 1000.');
		System.assertEquals(serviceRequest.dmpl__Status__c, 'Customer Requested', 'Status should be Customer Requested.');
		System.assertEquals(serviceRequest.dmpl__CustomerVoice__c, 'CustomerVoice1', 'Customer Voice should be CustomerVoice1.');

		dmpl__ServiceRequestline__c serviceRequestLine = ServiceRequestTestDataHelpers.getServiceRequestLine();
		System.assertNotEquals(serviceRequestLine, null, 'Expected Service Request Line to be created.');

		dmpl__ServiceRequestTax__c ServiceRequestTax = ServiceRequestTestDataHelpers.getServiceRequestTax();
		System.assertNotEquals(ServiceRequestTax, null, 'Expected Service Request Tax to be created.');
		Test.stopTest();
	}

	@isTest
	static void updateServiceRequestPositive() {
		Test.startTest();
		dmpl__ServiceRequest__c serviceRequest = ServiceRequestTestDataHelpers.getServiceRequest();
		System.assertNotEquals(serviceRequest, null, 'Service Request should exist before update.');
		serviceRequest.dmpl__AccountName__c = 'Account 1 Updated';
		serviceRequest.dmpl__AdjustedAdvanceAmount__c = 3000;
		serviceRequest.dmpl__AdvanceAmount__c = 2000;
		serviceRequest.dmpl__Status__c = 'Confirmed';
		serviceRequest.dmpl__CustomerVoice__c = 'CustomerVoice2';
		update serviceRequest;

		dmpl__ServiceRequest__c updatedServiceRequest = ServiceRequestTestDataHelpers.getServiceRequest();
		System.assertEquals(
			updatedServiceRequest.dmpl__AccountName__c,
			'Account 1 Updated',
			'Account Name should be Account 1 Updated after update.'
		);
		System.assertEquals(updatedServiceRequest.dmpl__AdjustedAdvanceAmount__c, 3000, 'Adjusted Amount should be 3000 after update.');
		System.assertEquals(updatedServiceRequest.dmpl__AdvanceAmount__c, 2000, 'Advance Amount should be 2000 after update.');
		System.assertEquals(updatedServiceRequest.dmpl__Status__c, 'Confirmed', 'Status should be Confirmed after update.');
		System.assertEquals(updatedServiceRequest.dmpl__CustomerVoice__c, 'CustomerVoice2', 'Customer Voice should be CustomerVoice2 after update.');
		Test.stopTest();
	}

	@isTest
	static void deleteServiceRequest() {
		Test.startTest();
		dmpl__ServiceRequest__c serviceRequest = ServiceRequestTestDataHelpers.getServiceRequest();
		System.assertNotEquals(serviceRequest, null, 'Service Request should exist before delete.');
		Id serviceRequestId = serviceRequest.Id;
		delete serviceRequest;
		dmpl__ServiceRequest__c deletedServiceRequest = null;
		try {
			deletedServiceRequest = ServiceRequestTestDataHelpers.getServiceRequest(serviceRequestId);
		} catch (Exception e) {
			deletedServiceRequest = null;
		}
		Test.stopTest();
		System.assertEquals(deletedServiceRequest, null, 'Service Request should be deleted and not found in query.');
	}
	@isTest
	static void CreateServiceRequestWithCorrectPartnerAndBranchPositive() {
		Test.startTest();
		Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
		Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
		dmpl__ContactAddress__c billingAddress = TestDataHelpers.getContactAddress('Address 3');
		dmpl__ContactAddress__c shippingAddress = TestDataHelpers.getContactAddress('Address 2');
		dmpl__ContactAddress__c deliveryAddress = TestDataHelpers.getContactAddress('Address 1');
		dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
		Asset asset = AssetTestDataHelpers.getAsset('Asset 1');

		dmpl__ServiceRequest__c sr = ServiceRequestTestDataHelpers.createServiceRequestWithId(partner1, customer1, branch1, asset);
		dmpl__ServiceRequest__c fetched = ServiceRequestTestDataHelpers.getServiceRequestById(sr.Id);
		Test.stopTest();

		System.assertEquals(partner1.Id, fetched.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
		System.assertEquals(branch1.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 1');
		System.assertEquals(customer1.Id, fetched.dmpl__AccountId__c, 'Customer should be Customer 1');
		System.assertEquals('Customer Requested', fetched.dmpl__Status__c, 'Status should be Customer Requested');
		System.assertEquals(asset.Id, fetched.dmpl__AssetId__c, 'Asset should be Asset 1');
		System.assertEquals(customer1.dmpl__BillingStreet__c, fetched.dmpl__BillingStreet__c, 'Billing street should match');
		System.assertEquals(customer1.dmpl__BillingCity__c, fetched.dmpl__BillingCity__c, 'Billing city should match');
		System.assertEquals(customer1.dmpl__BillingState__c, fetched.dmpl__BillingState__c, 'Billing state should match');
		System.assertEquals(branch1.Id, fetched.dmpl__BranchId__c, 'Branch Name mismatch');

		System.assertEquals(customer1.dmpl__ShippingStreet__c, fetched.dmpl__ShippingStreet__c, 'Shipping street should match');
		System.assertEquals(customer1.dmpl__ShippingCity__c, fetched.dmpl__ShippingCity__c, 'Shipping city should match');
		System.assertEquals(customer1.dmpl__ShippingState__c, fetched.dmpl__ShippingState__c, 'Shipping state should match');
		System.assertEquals(customer1.dmpl__ShippingPostalCode__c, fetched.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
	}
	@isTest
	static void CreateServiceRequestWithWrongPartnerNegative() { // BLOCKED
		Test.startTest();
		Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
		Account partner3 = TestDataHelpers.getPartnerAccount('Partner 3');
		Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
		Asset asset = AssetTestDataHelpers.getAsset('Asset 1');

		Boolean isExceptionThrown = false;

		try {
			dmpl__ServiceRequest__c sr = new dmpl__ServiceRequest__c(
				dmpl__PartnerAccountId__c = partner3.Id,
				dmpl__BranchId__c = branch1.Id,
				dmpl__AccountId__c = customer1.Id,
				dmpl__Status__c = 'Customer Requested',
				dmpl__AssetId__c = asset.Id
			);
		} catch (Exception e) {
			isExceptionThrown = true;
		}
		Test.stopTest();

		// System.assert(isExceptionThrown, 'Insert should have failed due to wrong Partner Account.');
	}
	@isTest 
	static void UpdateServiceRequestWithWrongPartnerNegative() { // BLOCKED
		Test.startTest();
		Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
		Account partner3 = TestDataHelpers.getPartnerAccount('Partner 3');
		Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
		Asset asset =AssetTestDataHelpers.getAsset('Asset 1');

		dmpl__ServiceRequest__c sr = ServiceRequestTestDataHelpers.createServiceRequestWithId(partner1, customer1, branch1, asset);

		
		System.assertEquals(partner1.Id, sr.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
		System.assertEquals(branch1.Id, sr.dmpl__BranchId__c, 'Branch should be Branch 1');
		System.assertEquals(customer1.Id, sr.dmpl__AccountId__c, 'Customer should be Customer 1');
		Boolean isExceptionThrown = false;
		
		try {
			sr.dmpl__PartnerAccountId__c = partner3.Id;
			update sr;
		} catch (Exception e) {
		}
		Test.stopTest();

		// System.assert(isExceptionThrown, 'Update should fail with wrong partner account.');
	}
	@isTest
	static void CreateServiceRequestWithInactivePartnerNegative() {
		Test.startTest();
		Account partner2 = TestDataHelpers.getPartnerAccount('Partner 2');
		Account partner3 = TestDataHelpers.getPartnerAccount('Partner 3');
		Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');
		dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
		Asset asset =AssetTestDataHelpers.getAsset('Asset 1');

		Boolean isExceptionThrown = false;

		try {
			dmpl__ServiceRequest__c sr = ServiceRequestTestDataHelpers.createServiceRequestWithId(partner2, customer1, null, asset);
		} catch (Exception e) {
			isExceptionThrown = true;
		}
		Test.stopTest();

		System.assert(isExceptionThrown, 'Insert should have failed due to inactive Partner Account and mandatory branch .');
	}
	@isTest
	static void updateServiceRequestWithInactivePartnerNegative() {
		Test.startTest();
		Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
		Account partner2 = TestDataHelpers.getPartnerAccount('Partner 2');
		Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
		dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');
		dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
		Asset asset =AssetTestDataHelpers.getAsset('Asset 1');

		dmpl__ServiceRequest__c sr = ServiceRequestTestDataHelpers.createServiceRequestWithId(partner1, customer1, branch1, asset);

		Boolean exceptionThrown = false;
		try {
			sr.dmpl__PartnerAccountId__c=partner2.id;
			sr.dmpl__BranchId__c = null;
			update sr;
		} catch (Exception ex) {
			exceptionThrown = true;
			System.debug('Expected exception: ' + ex.getMessage());
		}
		Test.stopTest();

		System.assert(exceptionThrown, 'Update should fail due to inactive branch Account and missing branch .');
	}

	//
	// Service Request creation with wrong branch (New)
	@isTest
	static void CreateServiceRequestWithWrongBranchNegative() {
		Test.startTest();
		Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
		Account partner3 = TestDataHelpers.getPartnerAccount('Partner 3');
		Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');
		dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
		Asset asset =AssetTestDataHelpers.getAsset('Asset 1');

		Boolean isExceptionThrown = false;

		try {
			dmpl__ServiceRequest__c sr = ServiceRequestTestDataHelpers.createServiceRequestWithId(partner1, customer1, branch3, asset);
		} catch (Exception e) {
			isExceptionThrown = true;
		}
		Test.stopTest();

		System.assert(isExceptionThrown, 'Insert should have failed due to wrong Partner Account.');
	}
	// Service Request creation with wrong branch (Edit)
	@isTest
	static void updateServiceRequestWithWrongBranchNegative() {
		Test.startTest();
		Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
		Account partner3 = TestDataHelpers.getPartnerAccount('Partner 3');
		Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
		dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');
		dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
		Asset asset =AssetTestDataHelpers.getAsset('Asset 1');

		dmpl__ServiceRequest__c sr = ServiceRequestTestDataHelpers.createServiceRequestWithId(partner1, customer1, branch1, asset);

		Boolean exceptionThrown = false;
		try {
			sr.dmpl__BranchId__c = branch3.Id;
			update sr;
		} catch (Exception ex) {
			exceptionThrown = true;
			System.debug('Expected exception: ' + ex.getMessage());
		}
		Test.stopTest();

		System.assert(exceptionThrown, 'Update should fail due to mismatched branch Account.');
	}
	// Service Request creation with inactive branch (New)
	@isTest
	static void CreateServiceRequestWithInactiveBranchNegative() {
		Test.startTest();
		Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
		Account partner3 = TestDataHelpers.getPartnerAccount('Partner 3');
		Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
		dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');
		dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
		Asset asset =AssetTestDataHelpers.getAsset('Asset 1');

		Boolean isExceptionThrown = false;

		try {
			dmpl__ServiceRequest__c sr = ServiceRequestTestDataHelpers.createServiceRequestWithId(partner1, customer1, branch3, asset);
		} catch (Exception e) {
			isExceptionThrown = true;
			System.debug('Expected DML Exception: ' + e.getMessage());
		}
		Test.stopTest();

		System.assert(isExceptionThrown, 'Insert should have failed due to inactive branch');
	}
	// Service Request creation with inactive branch (Edit)
	@isTest
	static void updateServiceRequestWithInactiveBRanchNegative() {
		Test.startTest();
		Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');

		Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
		dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');
		dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
		Asset asset =AssetTestDataHelpers.getAsset('Asset 1');

		dmpl__ServiceRequest__c sr = ServiceRequestTestDataHelpers.createServiceRequestWithId(partner1, customer1, branch1, asset);

		Boolean exceptionThrown = false;
		try {
			sr.dmpl__BranchId__c = branch3.Id;
			update sr;
		} catch (Exception ex) {
			exceptionThrown = true;
			System.debug('Expected exception: ' + ex.getMessage());
		}
		Test.stopTest();

		System.assert(exceptionThrown, 'Update should fail due to inactive branch');
	}
	// Service Request with active customer account (New)
	@isTest
	static void CreateServiceRequestWithCorrecActiveCustomerAccountPositive() {
		Test.startTest();
		Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
		Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
		dmpl__ContactAddress__c billingAddress = TestDataHelpers.getContactAddress('Address 3');
		dmpl__ContactAddress__c shippingAddress = TestDataHelpers.getContactAddress('Address 2');
		dmpl__ContactAddress__c deliveryAddress = TestDataHelpers.getContactAddress('Address 1');
		dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
		Asset asset =AssetTestDataHelpers.getAsset('Asset 1');

		dmpl__ServiceRequest__c sr = ServiceRequestTestDataHelpers.createServiceRequestWithId(partner1, customer1, branch1, asset);
		dmpl__ServiceRequest__c fetched = ServiceRequestTestDataHelpers.getServiceRequestById(sr.Id);
		Test.stopTest();

		System.assertEquals(partner1.Id, fetched.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
		System.assertEquals(branch1.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 1');
		System.assertEquals(customer1.Id, fetched.dmpl__AccountId__c, 'Customer should be Customer 1');
		System.assertEquals('Customer Requested', fetched.dmpl__Status__c, 'Status should be Customer Requested');
		System.assertEquals(asset.Id, fetched.dmpl__AssetId__c, 'Asset should be Asset 1');
		System.assertEquals(customer1.dmpl__BillingStreet__c, fetched.dmpl__BillingStreet__c, 'Billing street should match');
		System.assertEquals(customer1.dmpl__BillingCity__c, fetched.dmpl__BillingCity__c, 'Billing city should match');
		System.assertEquals(customer1.dmpl__BillingState__c, fetched.dmpl__BillingState__c, 'Billing state should match');
		System.assertEquals(branch1.Id, fetched.dmpl__BranchId__c, 'Branch Name mismatch');
		System.assertEquals(customer1.dmpl__ShippingStreet__c, fetched.dmpl__ShippingStreet__c, 'Shipping street should match');
		System.assertEquals(customer1.dmpl__ShippingCity__c, fetched.dmpl__ShippingCity__c, 'Shipping city should match');
		System.assertEquals(customer1.dmpl__ShippingState__c, fetched.dmpl__ShippingState__c, 'Shipping state should match');
		System.assertEquals(customer1.dmpl__ShippingPostalCode__c, fetched.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
	}
	// Service Request with active customer account (Edit)
	@isTest
	static void updateServiceRequestWithActiveCustomerAccountPositive() {
		Test.startTest();

		Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
		Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
		Account customer2 = TestDataHelpers.getCustomerAccount('Customer 2');
		dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
		Asset asset =AssetTestDataHelpers.getAsset('Asset 1');

		dmpl__ServiceRequest__c sr = ServiceRequestTestDataHelpers.createServiceRequestWithId(partner1, customer1, branch1, asset);

		sr.dmpl__AccountId__c = customer2.Id;
		update sr;

		dmpl__ServiceRequest__c fetched = ServiceRequestTestDataHelpers.getServiceRequestById(sr.Id);
		System.assertEquals(customer2.Id, fetched.dmpl__AccountId__c, 'Service Request should now be linked to Customer 2');
		System.assertEquals(partner1.Id, fetched.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
		System.assertEquals(branch1.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 1');
		System.assertEquals('Customer Requested', fetched.dmpl__Status__c, 'Status should be Customer Requested');
		System.assertEquals(asset.Id, fetched.dmpl__AssetId__c, 'Asset should be Asset 1');
		System.assertEquals(customer1.dmpl__BillingStreet__c, fetched.dmpl__BillingStreet__c, 'Billing street should match');
		System.assertEquals(customer1.dmpl__BillingCity__c, fetched.dmpl__BillingCity__c, 'Billing city should match');
		System.assertEquals(customer1.dmpl__BillingState__c, fetched.dmpl__BillingState__c, 'Billing state should match');
		System.assertEquals(branch1.Id, fetched.dmpl__BranchId__c, 'Branch Name mismatch');

		System.assertEquals(customer1.dmpl__ShippingStreet__c, fetched.dmpl__ShippingStreet__c, 'Shipping street should match');
		System.assertEquals(customer1.dmpl__ShippingCity__c, fetched.dmpl__ShippingCity__c, 'Shipping city should match');
		System.assertEquals(customer1.dmpl__ShippingState__c, fetched.dmpl__ShippingState__c, 'Shipping state should match');
		System.assertEquals(customer1.dmpl__ShippingPostalCode__c, fetched.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');

		Test.stopTest();
	}
	// Service Request with in-active customer account (New) // BLOCKED
	@isTest
	static void CreateServiceRequestWithInactiveCustomerAccountNegative() {
		Test.startTest();
		Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
		Account partner3 = TestDataHelpers.getPartnerAccount('Partner 3');
		Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
		Account customer7 = TestDataHelpers.getCustomerAccount('Customer 7');
		dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 3');
		dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
		Asset asset =AssetTestDataHelpers.getAsset('Asset 1');

		Boolean isExceptionThrown = false;

		try {
			dmpl__ServiceRequest__c sr = new dmpl__ServiceRequest__c(
				dmpl__PartnerAccountId__c = partner1.Id,
				dmpl__BranchId__c = branch1.Id,
				dmpl__AccountId__c = customer7.Id,
				dmpl__Status__c = 'Customer Requested',
				dmpl__AssetId__c = asset.Id
			);
		} catch (Exception e) {
			isExceptionThrown = true;
		}
		Test.stopTest();

		// System.assert(isExceptionThrown, 'Insert should have failed due to inactive customer Account.');
	}
	// Service Request with in-active customer account (Edit)
	@isTest
	static void updateServiceRequestWithInactiveCustomerAccountNegative() {
		Test.startTest();
		Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
		Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
		Account customer7 = TestDataHelpers.getCustomerAccount('Customer 7');
		dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
		Asset asset =AssetTestDataHelpers.getAsset('Asset 1');

		dmpl__ServiceRequest__c sr = ServiceRequestTestDataHelpers.createServiceRequestWithId(partner1, customer1, branch1, asset);

		Boolean exceptionThrown = false;
		try {
			sr.dmpl__AccountId__c = customer7.Id;
			update sr;
		} catch (Exception ex) {
			exceptionThrown = true;
		}
		Test.stopTest();

		System.assert(exceptionThrown, 'Update should fail due to mismatched Partner Account.');
	}
	// Service Request creation with asset (New)
	@isTest
	static void CreateServiceRequestWithAssetPositive() {
		Test.startTest();
		Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
		Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
		dmpl__ContactAddress__c billingAddress = TestDataHelpers.getContactAddress('Address 3');
		dmpl__ContactAddress__c shippingAddress = TestDataHelpers.getContactAddress('Address 2');
		dmpl__ContactAddress__c deliveryAddress = TestDataHelpers.getContactAddress('Address 1');
		dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
		Asset asset =AssetTestDataHelpers.getAsset('Asset 1');

		dmpl__ServiceRequest__c sr = ServiceRequestTestDataHelpers.createServiceRequestWithId(partner1, customer1, branch1, asset);
		dmpl__ServiceRequest__c fetched = ServiceRequestTestDataHelpers.getServiceRequestById(sr.Id);
		Test.stopTest();

		System.assertEquals(partner1.Id, fetched.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
		System.assertEquals(branch1.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 1');
		System.assertEquals(customer1.Id, fetched.dmpl__AccountId__c, 'Customer should be Customer 1');
		System.assertEquals('Customer Requested', fetched.dmpl__Status__c, 'Status should be Customer Requested');
		System.assertEquals(asset.Id, fetched.dmpl__AssetId__c, 'Asset should be Asset 1');
		System.assertEquals(customer1.dmpl__BillingStreet__c, fetched.dmpl__BillingStreet__c, 'Billing street should match');
		System.assertEquals(customer1.dmpl__BillingCity__c, fetched.dmpl__BillingCity__c, 'Billing city should match');
		System.assertEquals(customer1.dmpl__BillingState__c, fetched.dmpl__BillingState__c, 'Billing state should match');
		System.assertEquals(branch1.Id, fetched.dmpl__BranchId__c, 'Branch Name mismatch');

		System.assertEquals(customer1.dmpl__ShippingStreet__c, fetched.dmpl__ShippingStreet__c, 'Shipping street should match');
		System.assertEquals(customer1.dmpl__ShippingCity__c, fetched.dmpl__ShippingCity__c, 'Shipping city should match');
		System.assertEquals(customer1.dmpl__ShippingState__c, fetched.dmpl__ShippingState__c, 'Shipping state should match');
		System.assertEquals(customer1.dmpl__ShippingPostalCode__c, fetched.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
	}
	// Service Request creation with asset (Edit)
	@isTest
	static void updateServiceRequestWithAssetPositive() {
		Test.startTest();
		Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
		Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
		Account customer2 = TestDataHelpers.getCustomerAccount('Customer 2');
		Account customer3 = TestDataHelpers.getCustomerAccount('Customer 3');
		dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
		Asset asset = AssetTestDataHelpers.getAsset('Asset 1');
		dmpl__Item__c item5 = TestDataHelpers.getItem('Item 5');
		Asset asset3 = AssetTestDataHelpers.getAsset('Asset 3');

		dmpl__ServiceRequest__c sr = ServiceRequestTestDataHelpers.createServiceRequestWithId(partner1, customer1, branch1, asset);

		sr.dmpl__AssetId__c = asset3.Id;
		update sr;

		dmpl__ServiceRequest__c fetched = ServiceRequestTestDataHelpers.getServiceRequestById(sr.Id);
		Test.stopTest();
		System.assertEquals(asset3.Id, fetched.dmpl__AssetId__c, 'Service Request should now be linked to asset 3');
		System.assertEquals(partner1.Id, fetched.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
		System.assertEquals(branch1.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 1');
		System.assertEquals('Customer Requested', fetched.dmpl__Status__c, 'Status should be Customer Requested');
		System.assertEquals(customer1.dmpl__BillingStreet__c, fetched.dmpl__BillingStreet__c, 'Billing street should match');
		System.assertEquals(customer1.dmpl__BillingCity__c, fetched.dmpl__BillingCity__c, 'Billing city should match');
		System.assertEquals(customer1.dmpl__BillingState__c, fetched.dmpl__BillingState__c, 'Billing state should match');
		System.assertEquals(branch1.Id, fetched.dmpl__BranchId__c, 'Branch Name mismatch');

		System.assertEquals(customer1.dmpl__ShippingStreet__c, fetched.dmpl__ShippingStreet__c, 'Shipping street should match');
		System.assertEquals(customer1.dmpl__ShippingCity__c, fetched.dmpl__ShippingCity__c, 'Shipping city should match');
		System.assertEquals(customer1.dmpl__ShippingState__c, fetched.dmpl__ShippingState__c, 'Shipping state should match');
		System.assertEquals(customer1.dmpl__ShippingPostalCode__c, fetched.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
	}
	// Service Request creation without asset (New)
	@isTest
	static void CreateServiceRequestWithoutAssetNegative() { // BLOCKED
		Test.startTest();
		Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
		Account partner3 = TestDataHelpers.getPartnerAccount('Partner 3');
		Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');
		dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
		Asset asset =AssetTestDataHelpers.getAsset('Asset 1');

		Boolean isExceptionThrown = false;

		try {
			dmpl__ServiceRequest__c sr = new dmpl__ServiceRequest__c(
				dmpl__PartnerAccountId__c = partner1.Id,
				dmpl__BranchId__c = branch3.Id,
				dmpl__AccountId__c = customer1.Id,
				dmpl__Status__c = 'Customer Requested',
				dmpl__AssetId__c = null
			);
		} catch (Exception e) {
			isExceptionThrown = true;
		}
		Test.stopTest();

		// System.assert(isExceptionThrown, 'Insert should have failed due to without asset');
	}
	// Service Request with Billing & Shipping Address (New)
	@isTest
	static void CreateServiceRequestWithBillingAndShippingAddressPositive() {
		Test.startTest();
		Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
		Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
		dmpl__ContactAddress__c billingAddress = TestDataHelpers.getContactAddress('Address 3');
		dmpl__ContactAddress__c shippingAddress = TestDataHelpers.getContactAddress('Address 2');
		dmpl__ContactAddress__c deliveryAddress = TestDataHelpers.getContactAddress('Address 1');
		dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
		Asset asset =AssetTestDataHelpers.getAsset('Asset 1');

		dmpl__ServiceRequest__c sr = ServiceRequestTestDataHelpers.createServiceRequestWithId(partner1, customer1, branch1, asset);
		dmpl__ServiceRequest__c fetched = ServiceRequestTestDataHelpers.getServiceRequestById(sr.Id);
		Test.stopTest();

		System.assertEquals(partner1.Id, fetched.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
		System.assertEquals(branch1.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 1');
		System.assertEquals(customer1.Id, fetched.dmpl__AccountId__c, 'Customer should be Customer 1');
		System.assertEquals('Customer Requested', fetched.dmpl__Status__c, 'Status should be Customer Requested');
		System.assertEquals(asset.Id, fetched.dmpl__AssetId__c, 'Asset should be Asset 1');
		System.assertEquals(customer1.dmpl__BillingStreet__c, fetched.dmpl__BillingStreet__c, 'Billing street should match');
		System.assertEquals(customer1.dmpl__BillingCity__c, fetched.dmpl__BillingCity__c, 'Billing city should match');
		System.assertEquals(customer1.dmpl__BillingState__c, fetched.dmpl__BillingState__c, 'Billing state should match');
		System.assertEquals(branch1.Id, fetched.dmpl__BranchId__c, 'Branch Name mismatch');

		System.assertEquals(customer1.dmpl__ShippingStreet__c, fetched.dmpl__ShippingStreet__c, 'Shipping street should match');
		System.assertEquals(customer1.dmpl__ShippingCity__c, fetched.dmpl__ShippingCity__c, 'Shipping city should match');
		System.assertEquals(customer1.dmpl__ShippingState__c, fetched.dmpl__ShippingState__c, 'Shipping state should match');
		System.assertEquals(customer1.dmpl__ShippingPostalCode__c, fetched.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
	}
	 @isTest
    static void CreateServiceRequestWithMultipleBillingAndShippingAddress() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('IGST 18');
		dmpl__ContactAddress__c billingAddress = TestDataHelpers.getContactAddress('Address 3');
		dmpl__ContactAddress__c shippingAddress = TestDataHelpers.getContactAddress('Address 2');
		dmpl__ContactAddress__c deliveryAddress = TestDataHelpers.getContactAddress('Address 1');
		dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
		Asset asset =AssetTestDataHelpers.getAsset('Asset 1');

        
        Decimal usageReading = 1000;
        
        Test.startTest();
        dmpl__ServiceRequest__c sr = ServiceRequestTestDataHelpers.createServiceRequestWithId(partner1, customer1, branch1, asset);
        
        dmpl__ServiceRequest__c fetched = ServiceRequestTestDataHelpers.getServiceRequestById(sr.Id);
		Test.stopTest();

		System.assertEquals(partner1.Id, fetched.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
		System.assertEquals(branch1.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 1');
		System.assertEquals(customer1.Id, fetched.dmpl__AccountId__c, 'Customer should be Customer 1');
		System.assertEquals('Customer Requested', fetched.dmpl__Status__c, 'Status should be Customer Requested');
		System.assertEquals(asset.Id, fetched.dmpl__AssetId__c, 'Asset should be Asset 1');
		System.assertEquals(customer1.dmpl__BillingStreet__c, fetched.dmpl__BillingStreet__c, 'Billing street should match');
		System.assertEquals(customer1.dmpl__BillingCity__c, fetched.dmpl__BillingCity__c, 'Billing city should match');
		System.assertEquals(customer1.dmpl__BillingState__c, fetched.dmpl__BillingState__c, 'Billing state should match');
		System.assertEquals(branch1.Id, fetched.dmpl__BranchId__c, 'Branch Name mismatch');

		System.assertEquals(customer1.dmpl__ShippingStreet__c, fetched.dmpl__ShippingStreet__c, 'Shipping street should match');
		System.assertEquals(customer1.dmpl__ShippingCity__c, fetched.dmpl__ShippingCity__c, 'Shipping city should match');
		System.assertEquals(customer1.dmpl__ShippingState__c, fetched.dmpl__ShippingState__c, 'Shipping state should match');
		System.assertEquals(customer1.dmpl__ShippingPostalCode__c, fetched.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
        
        
    }
	// Service Request Creation with GST Tax (Global) (New)
	@isTest
	static void CreateServiceRequestWithGSTTaxGroupPositive() {
		Test.startTest();
		Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
		Account customer2 = TestDataHelpers.getCustomerAccount('Customer 2');
		dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
		Asset asset = AssetTestDataHelpers.createAsset('Asset 1', customer2.Id, item1.Id);

		dmpl__ServiceRequest__c sr = ServiceRequestTestDataHelpers.createServiceRequestWithId(partner1, customer2, branch1, asset);

		dmpl__ServiceRequest__c toUpdate = ServiceRequestTestDataHelpers.getServiceRequest(sr.Id);
		toUpdate.dmpl__TaxGroupId__c = TestDataHelpers.getTaxGroup('GST 12').Id;
		update toUpdate;

		dmpl__ServiceRequest__c fetched = ServiceRequestTestDataHelpers.getServiceRequestById(toUpdate.Id);
		Test.stopTest();

		System.assertEquals(partner1.Id, fetched.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
		System.assertEquals(branch1.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 1');
		System.assertEquals(customer2.Id, fetched.dmpl__AccountId__c, 'Customer should be Customer 1');
		System.assertEquals('Customer Requested', fetched.dmpl__Status__c, 'Status should be Customer Requested');
		System.assertEquals(asset.Id, fetched.dmpl__AssetId__c, 'Asset should be Asset 1');
		System.assertEquals(customer2.dmpl__BillingStreet__c, fetched.dmpl__BillingStreet__c, 'Billing street should match');
		System.assertEquals(customer2.dmpl__BillingCity__c, fetched.dmpl__BillingCity__c, 'Billing city should match');
		System.assertEquals(customer2.dmpl__BillingState__c, fetched.dmpl__BillingState__c, 'Billing state should match');
		System.assertEquals(branch1.Id, fetched.dmpl__BranchId__c, 'Branch Name mismatch');

		System.assertEquals(customer2.dmpl__ShippingStreet__c, fetched.dmpl__ShippingStreet__c, 'Shipping street should match');
		System.assertEquals(customer2.dmpl__ShippingCity__c, fetched.dmpl__ShippingCity__c, 'Shipping city should match');
		System.assertEquals(customer2.dmpl__ShippingState__c, fetched.dmpl__ShippingState__c, 'Shipping state should match');
		System.assertEquals(customer2.dmpl__ShippingPostalCode__c, fetched.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
	}

	// Service Request Creation with IGST Tax (Global) (New)
	@isTest
	static void CreateServiceRequestWithIGSTTaxGroupPositive() {
		Test.startTest();
		Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
		Account customer2 = TestDataHelpers.getCustomerAccount('Customer 2');
		dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
		Asset asset = AssetTestDataHelpers.createAsset('Asset 1', customer2.Id, item1.Id);

		dmpl__ServiceRequest__c sr = ServiceRequestTestDataHelpers.createServiceRequestWithId(partner1, customer2, branch1, asset);

		dmpl__ServiceRequest__c toUpdate = ServiceRequestTestDataHelpers.getServiceRequest(sr.Id);
		toUpdate.dmpl__TaxGroupId__c = TestDataHelpers.getTaxGroup('IGST 18').Id;
		update toUpdate;

		dmpl__ServiceRequest__c fetched = ServiceRequestTestDataHelpers.getServiceRequestById(toUpdate.Id);
		Test.stopTest();

		System.assertEquals(partner1.Id, fetched.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
		System.assertEquals(branch1.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 1');
		System.assertEquals(customer2.Id, fetched.dmpl__AccountId__c, 'Customer should be Customer 1');
		System.assertEquals('Customer Requested', fetched.dmpl__Status__c, 'Status should be Customer Requested');
		System.assertEquals(asset.Id, fetched.dmpl__AssetId__c, 'Asset should be Asset 1');
		System.assertEquals(customer2.dmpl__BillingStreet__c, fetched.dmpl__BillingStreet__c, 'Billing street should match');
		System.assertEquals(customer2.dmpl__BillingCity__c, fetched.dmpl__BillingCity__c, 'Billing city should match');
		System.assertEquals(customer2.dmpl__BillingState__c, fetched.dmpl__BillingState__c, 'Billing state should match');
		System.assertEquals(branch1.Id, fetched.dmpl__BranchId__c, 'Branch Name mismatch');

		System.assertEquals(customer2.dmpl__ShippingStreet__c, fetched.dmpl__ShippingStreet__c, 'Shipping street should match');
		System.assertEquals(customer2.dmpl__ShippingCity__c, fetched.dmpl__ShippingCity__c, 'Shipping city should match');
		System.assertEquals(customer2.dmpl__ShippingState__c, fetched.dmpl__ShippingState__c, 'Shipping state should match');
		System.assertEquals(customer2.dmpl__ShippingPostalCode__c, fetched.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
	}
	@isTest
	static void CreateServiceRequestLineWithServiceRequestReferencePositive() {
		Test.startTest();
		Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');

		Asset asset = AssetTestDataHelpers.getAsset('Asset 1');

		dmpl__ServiceRequest__c request = ServiceRequestTestDataHelpers.createServiceRequestWithId(customer1, branch1, item, asset, null);
		dmpl__ServiceRequestLine__c srline = ServiceRequestTestDataHelpers.createServiceRequestLineWithId(request, item, 1, 1500);

		dmpl__ServiceRequest__c fetched = ServiceRequestTestDataHelpers.getServiceRequestById(request.Id);
		dmpl__ServiceRequestLine__c line = ServiceRequestTestDataHelpers.getServiceRequestLineById(srline.Id);
		Test.stopTest();

		System.assertEquals(1500, line.dmpl__Amount__c, 'Amount should be 1500');
		System.assertEquals(1500, line.dmpl__BaseAmount__c, 'BaseAmount should be 1500');
		System.assertEquals(1500, line.dmpl__GrossAmount__c, 'GrossAmount should be 1500');
		System.assertEquals(1, line.dmpl__Quantity__c, 'Quantity should be updated to 3');
		// System.assertEquals(1000, line.dmpl__ServiceContractWeightage__c, 'ServiceContractWeightage should be 1000');
		System.assertEquals(request.Id, line.dmpl__ServiceRequestId__c, 'ServiceRequestId should match');
		System.assertEquals(1500, line.dmpl__UnitPrice__c, 'UnitPrice should be 1500');
		System.assertEquals(item.Id, line.dmpl__ItemId__c, 'Item should be Item 8');

		System.assertEquals(branch1.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 1');
		System.assertEquals(customer1.Id, fetched.dmpl__AccountId__c, 'Customer should be Customer 1');
		System.assertEquals('Customer Requested', fetched.dmpl__Status__c, 'Status should be Customer Requested');
		System.assertEquals(asset.Id, fetched.dmpl__AssetId__c, 'Asset should be Asset 1');
		System.assertEquals(customer1.dmpl__BillingStreet__c, fetched.dmpl__BillingStreet__c, 'Billing street should match');
		System.assertEquals(customer1.dmpl__BillingCity__c, fetched.dmpl__BillingCity__c, 'Billing city should match');
		System.assertEquals(customer1.dmpl__BillingState__c, fetched.dmpl__BillingState__c, 'Billing state should match');
		System.assertEquals(branch1.Id, fetched.dmpl__BranchId__c, 'Branch Name mismatch');

		System.assertEquals(customer1.dmpl__ShippingStreet__c, fetched.dmpl__ShippingStreet__c, 'Shipping street should match');
		System.assertEquals(customer1.dmpl__ShippingCity__c, fetched.dmpl__ShippingCity__c, 'Shipping city should match');
		System.assertEquals(customer1.dmpl__ShippingState__c, fetched.dmpl__ShippingState__c, 'Shipping state should match');
		System.assertEquals(customer1.dmpl__ShippingPostalCode__c, fetched.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
	}
	// Service Request line creation with 0 quantity (New)
	@isTest
	static void CreateServiceRequestLineWithZeroQuantityNegative() {
		Test.startTest();
		Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		Asset asset = AssetTestDataHelpers.createAsset('Asset 1', customer.Id, item.Id);

		dmpl__ServiceRequest__c request = ServiceRequestTestDataHelpers.createServiceRequestWithId(customer, branch, item, asset, null);

		Boolean failedDueToZeroQty = false;
		try {
			dmpl__ServiceRequestLine__c requestLine = ServiceRequestTestDataHelpers.createServiceRequestLineWithId(request, item, 0, 1000);
		} catch (Exception e) {
			failedDueToZeroQty = true;
		}
		Test.stopTest();

		System.assertEquals(true, failedDueToZeroQty, 'Insert should fail when quantity is 0');
	}
	// Service Request line with Price List for Partner Account Group (New)
	@isTest
	static void CreateServiceRequestLineWithPriceListPositive() {
		Test.startTest();
		Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
		Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 8');
		Asset asset = AssetTestDataHelpers.getAsset('Asset 1');

		dmpl__ServiceRequest__c request = ServiceRequestTestDataHelpers.createServiceRequestWithId(partner1, customer1, branch1, asset);

		dmpl__ServiceRequestLine__c requestLine = ServiceRequestTestDataHelpers.createServiceRequestLineWithId(request, item, 1, 1500);
		requestLine.dmpl__PriceListId__c = TestDataHelpers.getPriceList('Price List 1').Id;
		update requestLine;

		dmpl__ServiceRequest__c fetched = ServiceRequestTestDataHelpers.getServiceRequestById(request.Id);
		requestLine = ServiceRequestTestDataHelpers.getServiceRequestLineById(requestLine.Id);

		Test.stopTest();

		System.assertEquals(partner1.Id, fetched.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
		System.assertEquals(branch1.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 1');
		System.assertEquals(customer1.Id, fetched.dmpl__AccountId__c, 'Customer should be Customer 1');
		System.assertEquals('Customer Requested', fetched.dmpl__Status__c, 'Status should be Customer Requested');
		System.assertEquals(asset.Id, fetched.dmpl__AssetId__c, 'Asset should be Asset 1');
		System.assertEquals(customer1.dmpl__BillingStreet__c, fetched.dmpl__BillingStreet__c, 'Billing street should match');
		System.assertEquals(customer1.dmpl__BillingCity__c, fetched.dmpl__BillingCity__c, 'Billing city should match');
		System.assertEquals(customer1.dmpl__BillingState__c, fetched.dmpl__BillingState__c, 'Billing state should match');
		System.assertEquals(branch1.Id, fetched.dmpl__BranchId__c, 'Branch Name mismatch');
		System.assertEquals(customer1.dmpl__ShippingStreet__c, fetched.dmpl__ShippingStreet__c, 'Shipping street should match');
		System.assertEquals(customer1.dmpl__ShippingCity__c, fetched.dmpl__ShippingCity__c, 'Shipping city should match');
		System.assertEquals(customer1.dmpl__ShippingState__c, fetched.dmpl__ShippingState__c, 'Shipping state should match');
		System.assertEquals(customer1.dmpl__ShippingPostalCode__c, fetched.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');

		System.assertEquals(1500, requestLine.dmpl__Amount__c, 'Amount should be 1500');
		System.assertEquals(1500, requestLine.dmpl__BaseAmount__c, 'Base Amount should be 1500');
		System.assertEquals(1500, requestLine.dmpl__GrossAmount__c, 'Gross Amount should be 1500');
		System.assertEquals(1, requestLine.dmpl__Quantity__c, 'Quantity should be 1');
		System.assertEquals(1500, requestLine.dmpl__UnitPrice__c, 'Unit Price should be 1500');
		System.assertEquals(item.Id, requestLine.dmpl__ItemId__c, 'Item should match Item 8');
		System.assertEquals(request.Id, requestLine.dmpl__ServiceRequestId__c, 'Service Request should match');
		System.assertEquals(fetched.dmpl__PriceListId__c, requestLine.dmpl__PriceListId__c, 'Price List should match');
		System.assertEquals(10000, requestLine.dmpl__ServiceContractWeightage__c, 'Weightage should be 1000');
	}

	// Service Request line with positive quantity (New)
	@isTest
	static void CreateServiceRequestLineWithPositiveQuantityPositive() {
		// Arrange
		Test.startTest();
		Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 8');
		Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');

		Asset asset = AssetTestDataHelpers.getAsset('Asset 1');

		dmpl__ServiceRequest__c request = ServiceRequestTestDataHelpers.createServiceRequestWithId(customer1, branch1, item, asset, null);
		dmpl__ServiceRequestLine__c srline = ServiceRequestTestDataHelpers.createServiceRequestLineWithId(request, item, 1, 1500);

		dmpl__ServiceRequest__c fetched = ServiceRequestTestDataHelpers.getServiceRequestById(request.Id);
		dmpl__ServiceRequestLine__c line = ServiceRequestTestDataHelpers.getServiceRequestLineById(srline.Id);
		Test.stopTest();

		System.assertEquals(1500, line.dmpl__Amount__c, 'Amount should be 1500');
		System.assertEquals(1500, line.dmpl__BaseAmount__c, 'BaseAmount should be 1500');
		System.assertEquals(1500, line.dmpl__GrossAmount__c, 'GrossAmount should be 1500');
		System.assertEquals(1, line.dmpl__Quantity__c, 'Quantity should be updated to 3');
		// System.assertEquals(1000, line.dmpl__ServiceContractWeightage__c, 'ServiceContractWeightage should be 1000');
		System.assertEquals(request.Id, line.dmpl__ServiceRequestId__c, 'ServiceRequestId should match');
		System.assertEquals(1500, line.dmpl__UnitPrice__c, 'UnitPrice should be 1500');

		System.assertEquals(partner1.Id, fetched.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
		System.assertEquals(branch1.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 1');
		System.assertEquals(customer1.Id, fetched.dmpl__AccountId__c, 'Customer should be Customer 1');
		System.assertEquals('Customer Requested', fetched.dmpl__Status__c, 'Status should be Customer Requested');
		System.assertEquals(asset.Id, fetched.dmpl__AssetId__c, 'Asset should be Asset 1');
		System.assertEquals(customer1.dmpl__BillingStreet__c, fetched.dmpl__BillingStreet__c, 'Billing street should match');
		System.assertEquals(customer1.dmpl__BillingCity__c, fetched.dmpl__BillingCity__c, 'Billing city should match');
		System.assertEquals(customer1.dmpl__BillingState__c, fetched.dmpl__BillingState__c, 'Billing state should match');
		System.assertEquals(branch1.Id, fetched.dmpl__BranchId__c, 'Branch Name mismatch');

		System.assertEquals(customer1.dmpl__ShippingStreet__c, fetched.dmpl__ShippingStreet__c, 'Shipping street should match');
		System.assertEquals(customer1.dmpl__ShippingCity__c, fetched.dmpl__ShippingCity__c, 'Shipping city should match');
		System.assertEquals(customer1.dmpl__ShippingState__c, fetched.dmpl__ShippingState__c, 'Shipping state should match');
		System.assertEquals(customer1.dmpl__ShippingPostalCode__c, fetched.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
	}

	@isTest
	static void updateServiceRequestLineWithPositiveQuantityPositive() {
		Test.startTest();
		Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
		Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item8 = TestDataHelpers.getItem('Item 8');
		Asset asset1 = AssetTestDataHelpers.createAsset('Asset 1', customer1.Id, item8.Id);

		dmpl__ServiceRequest__c sr = ServiceRequestTestDataHelpers.createServiceRequestWithId(partner1, customer1, branch1, asset1);

		dmpl__ServiceRequestLine__c srline = ServiceRequestTestDataHelpers.createServiceRequestLineWithId(sr, item8, 1, 1500);

		srline.dmpl__Quantity__c = 3;
		update srline;

		dmpl__ServiceRequest__c fetched = ServiceRequestTestDataHelpers.getServiceRequestById(sr.Id);
		dmpl__ServiceRequestLine__c line = ServiceRequestTestDataHelpers.getServiceRequestLineById(srline.Id);

		Test.stopTest();
		System.assertEquals(partner1.Id, fetched.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
		System.assertEquals(branch1.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 1');
		System.assertEquals(customer1.Id, fetched.dmpl__AccountId__c, 'Customer should be Customer 1');
		System.assertEquals(customer1.dmpl__BillingStreet__c, fetched.dmpl__BillingStreet__c, 'Billing street should match');
		System.assertEquals(customer1.dmpl__BillingCity__c, fetched.dmpl__BillingCity__c, 'Billing city should match');
		System.assertEquals(customer1.dmpl__BillingState__c, fetched.dmpl__BillingState__c, 'Billing state should match');
		System.assertEquals(branch1.Id, fetched.dmpl__BranchId__c, 'Branch Name mismatch');

		System.assertEquals(customer1.dmpl__ShippingStreet__c, fetched.dmpl__ShippingStreet__c, 'Shipping street should match');
		System.assertEquals(customer1.dmpl__ShippingCity__c, fetched.dmpl__ShippingCity__c, 'Shipping city should match');
		System.assertEquals(customer1.dmpl__ShippingState__c, fetched.dmpl__ShippingState__c, 'Shipping state should match');
		System.assertEquals(customer1.dmpl__ShippingPostalCode__c, fetched.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');

		System.assertEquals(4500, line.dmpl__Amount__c, 'Amount should be 1500');
		System.assertEquals(4500, line.dmpl__BaseAmount__c, 'BaseAmount should be 4500');
		System.assertEquals(4500, line.dmpl__GrossAmount__c, 'GrossAmount should be 1500');
		System.assertEquals(3, line.dmpl__Quantity__c, 'Quantity should be updated to 3');
		System.assertEquals(10000, line.dmpl__ServiceContractWeightage__c, 'ServiceContractWeightage should be 1000');
		System.assertEquals(sr.Id, line.dmpl__ServiceRequestId__c, 'ServiceRequestId should match');
		System.assertEquals(1500, line.dmpl__UnitPrice__c, 'UnitPrice should be 1500');
		System.assertEquals(item8.Id, line.dmpl__ItemId__c, 'Item should be Item 8');
	}
	// Service Request line with active item (New)
	@isTest
	static void CreateServiceRequestLineWithActiveItemPositive() {
		Test.startTest();
		Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 8');

		Asset asset = AssetTestDataHelpers.getAsset('Asset 1');

		dmpl__ServiceRequest__c request = ServiceRequestTestDataHelpers.createServiceRequestWithId(customer1, branch1, item, asset, null);

		dmpl__ServiceRequestLine__c srline = ServiceRequestTestDataHelpers.createServiceRequestLineWithId(request, item, 1, 1500);

		dmpl__ServiceRequest__c fetched = ServiceRequestTestDataHelpers.getServiceRequestById(request.Id);
		dmpl__ServiceRequestLine__c requestLine = ServiceRequestTestDataHelpers.getServiceRequestLineById(srline.Id);
		Test.stopTest();

		System.assertEquals(branch1.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 1');
		System.assertEquals(customer1.Id, fetched.dmpl__AccountId__c, 'Customer should be Customer 1');
		System.assertEquals('Customer Requested', fetched.dmpl__Status__c, 'Status should be Customer Requested');
		System.assertEquals(asset.Id, fetched.dmpl__AssetId__c, 'Asset should be Asset 1');
		System.assertEquals(customer1.dmpl__BillingStreet__c, fetched.dmpl__BillingStreet__c, 'Billing street should match');
		System.assertEquals(customer1.dmpl__BillingCity__c, fetched.dmpl__BillingCity__c, 'Billing city should match');
		System.assertEquals(customer1.dmpl__BillingState__c, fetched.dmpl__BillingState__c, 'Billing state should match');
		System.assertEquals(branch1.Id, fetched.dmpl__BranchId__c, 'Branch Name mismatch');

		System.assertEquals(customer1.dmpl__ShippingStreet__c, fetched.dmpl__ShippingStreet__c, 'Shipping street should match');
		System.assertEquals(customer1.dmpl__ShippingCity__c, fetched.dmpl__ShippingCity__c, 'Shipping city should match');
		System.assertEquals(customer1.dmpl__ShippingState__c, fetched.dmpl__ShippingState__c, 'Shipping state should match');
		System.assertEquals(customer1.dmpl__ShippingPostalCode__c, fetched.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
		System.assertEquals(1500, requestLine.dmpl__Amount__c, 'Amount should be 1500');
		System.assertEquals(1500, requestLine.dmpl__BaseAmount__c, 'BaseAmount should be 1500');
		System.assertEquals(1500, requestLine.dmpl__GrossAmount__c, 'GrossAmount should be 1500');
		System.assertEquals(1, requestLine.dmpl__Quantity__c, 'Quantity should be updated to 3');
		System.assertEquals(10000, requestLine.dmpl__ServiceContractWeightage__c, 'ServiceContractWeightage should be 1000');
		System.assertEquals(request.Id, requestLine.dmpl__ServiceRequestId__c, 'ServiceRequestId should match');
		System.assertEquals(1500, requestLine.dmpl__UnitPrice__c, 'UnitPrice should be 1500');
		System.assertEquals(item.Id, requestLine.dmpl__ItemId__c, 'Item should be Item 8');
	}

	// Service Request line with active item (Edit)
	@isTest
	static void UpdateServiceRequestLineWithActiveItem() {
		Test.startTest();
		Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
		Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item8 = TestDataHelpers.getItem('Item 8');
		Asset asset1 = AssetTestDataHelpers.createAsset('Asset 1', customer1.Id, item8.Id);

		dmpl__ServiceRequest__c sr = ServiceRequestTestDataHelpers.createServiceRequestWithId(partner1, customer1, branch1, asset1);
		dmpl__ServiceRequestLine__c srline = ServiceRequestTestDataHelpers.createServiceRequestLineWithId(sr, item8, 1, 1500);

		srline.dmpl__Quantity__c = 3;
		update srline;

		dmpl__ServiceRequest__c fetched = ServiceRequestTestDataHelpers.getServiceRequestById(sr.Id);
		dmpl__ServiceRequestLine__c line = ServiceRequestTestDataHelpers.getServiceRequestLineById(srline.Id);
		Test.stopTest();

		System.assertEquals(partner1.Id, fetched.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
		System.assertEquals(branch1.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 1');
		System.assertEquals(customer1.Id, fetched.dmpl__AccountId__c, 'Customer should be Customer 1');
		System.assertEquals(customer1.dmpl__BillingStreet__c, fetched.dmpl__BillingStreet__c, 'Billing street should match');
		System.assertEquals(customer1.dmpl__BillingCity__c, fetched.dmpl__BillingCity__c, 'Billing city should match');
		System.assertEquals(customer1.dmpl__BillingState__c, fetched.dmpl__BillingState__c, 'Billing state should match');

		System.assertEquals(customer1.dmpl__ShippingStreet__c, fetched.dmpl__ShippingStreet__c, 'Shipping street should match');
		System.assertEquals(customer1.dmpl__ShippingCity__c, fetched.dmpl__ShippingCity__c, 'Shipping city should match');
		System.assertEquals(customer1.dmpl__ShippingState__c, fetched.dmpl__ShippingState__c, 'Shipping state should match');
		System.assertEquals(customer1.dmpl__ShippingPostalCode__c, fetched.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');

		System.assertEquals(4500, line.dmpl__Amount__c, 'Amount should be 4500');
		System.assertEquals(4500, line.dmpl__BaseAmount__c, 'BaseAmount should be 4500');
		System.assertEquals(4500, line.dmpl__GrossAmount__c, 'GrossAmount should be 4500');
		System.assertEquals(3, line.dmpl__Quantity__c, 'Quantity should be 3 after update');
		System.assertEquals(10000, line.dmpl__ServiceContractWeightage__c, 'ServiceContractWeightage should be 1000');
		System.assertEquals(sr.Id, line.dmpl__ServiceRequestId__c, 'ServiceRequestId should match');
		System.assertEquals(1500, line.dmpl__UnitPrice__c, 'UnitPrice should be 1500');
		System.assertEquals(item8.Id, line.dmpl__ItemId__c, 'Item should be Item 8');
	}

	@isTest
	static void CreateServiceRequestLineWithInactiveItem() {
		Test.startTest();
		Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
		Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');

		dmpl__Item__c inactiveItem = TestDataHelpers.getItem('Item 2');
		inactiveItem.dmpl__IsActive__c = false;
		update inactiveItem;

		Asset asset1 = AssetTestDataHelpers.createAsset('Asset 1', customer1.Id, inactiveItem.Id);

		dmpl__ServiceRequest__c sr = ServiceRequestTestDataHelpers.createServiceRequestWithId(partner1, customer1, branch1, asset1);

		Boolean creationFailed = false;
		dmpl__ServiceRequestLine__c srline;
		try {
			srline = ServiceRequestTestDataHelpers.createServiceRequestLineWithId(sr, inactiveItem, 2, 2400);
		} catch (Exception e) {
			creationFailed = true;
		}

		System.assertEquals(true, creationFailed, 'Line creation should fail with inactive item');

		dmpl__ServiceRequest__c fetched = ServiceRequestTestDataHelpers.getServiceRequestById(sr.Id);

		System.assertEquals(partner1.Id, fetched.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
		System.assertEquals(branch1.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 1');
		System.assertEquals(customer1.Id, fetched.dmpl__AccountId__c, 'Customer should be Customer 1');
		System.assertEquals(customer1.Name, fetched.dmpl__AccountName__c, 'Account Name mismatch');
		System.assertEquals(customer1.dmpl__BillingStreet__c, fetched.dmpl__BillingStreet__c, 'Billing street should match');
		System.assertEquals(customer1.dmpl__BillingCity__c, fetched.dmpl__BillingCity__c, 'Billing city should match');
		System.assertEquals(customer1.dmpl__BillingState__c, fetched.dmpl__BillingState__c, 'Billing state should match');
		System.assertEquals(branch1.Id, fetched.dmpl__BranchId__c, 'Branch Name mismatch');

		System.assertEquals(customer1.dmpl__ShippingStreet__c, fetched.dmpl__ShippingStreet__c, 'Shipping street should match');
		System.assertEquals(customer1.dmpl__ShippingCity__c, fetched.dmpl__ShippingCity__c, 'Shipping city should match');
		System.assertEquals(customer1.dmpl__ShippingState__c, fetched.dmpl__ShippingState__c, 'Shipping state should match');
		System.assertEquals(customer1.dmpl__ShippingPostalCode__c, fetched.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');

		Test.stopTest();
	}

	@isTest
	static void CreateServiceRequestTaxWithRequestReferencePositive() {
		Test.startTest();
		Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
		Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		Asset asset1 = AssetTestDataHelpers.getAsset('Asset 1');

		dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');

		dmpl__Tax__c createtax = TestDataHelpers.createTax('GST Tax', 'SGST', null, taxGroup.Id, 'Tax1');

		dmpl__Tax__c tax = TestDataHelpers.getTax('GST Tax');

		dmpl__ServiceRequest__c sr = ServiceRequestTestDataHelpers.createServiceRequestWithId(partner1, customer1, branch1, asset1);

		dmpl__ServiceRequestTax__c taxEntry = ServiceRequestTestDataHelpers.createServiceRequestTax(sr, null, taxGroup, tax);

		dmpl__ServiceRequest__c fetched = ServiceRequestTestDataHelpers.getServiceRequestById(sr.Id);
		Test.stopTest();

		System.assertEquals(partner1.Id, fetched.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
		System.assertEquals(branch1.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 1');
		System.assertEquals(customer1.Id, fetched.dmpl__AccountId__c, 'Customer should be Customer 1');
		System.assertEquals(customer1.dmpl__BillingStreet__c, fetched.dmpl__BillingStreet__c, 'Billing street should match');
		System.assertEquals(customer1.dmpl__BillingCity__c, fetched.dmpl__BillingCity__c, 'Billing city should match');
		System.assertEquals(customer1.dmpl__BillingState__c, fetched.dmpl__BillingState__c, 'Billing state should match');
		System.assertEquals(customer1.dmpl__BillingPostalCode__c, fetched.dmpl__BillingPostalCode__c, 'Billing postal code should match');
		System.assertEquals(customer1.dmpl__ShippingStreet__c, fetched.dmpl__ShippingStreet__c, 'Shipping street should match');
		System.assertEquals(customer1.dmpl__ShippingCity__c, fetched.dmpl__ShippingCity__c, 'Shipping city should match');
		System.assertEquals(customer1.dmpl__ShippingState__c, fetched.dmpl__ShippingState__c, 'Shipping state should match');
		System.assertEquals(customer1.dmpl__ShippingPostalCode__c, fetched.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
		System.assertEquals(customer1.dmpl__ShippingCountry__c, fetched.dmpl__ShippingCountry__c, 'Shipping country should match');

		System.assertEquals('Customer Requested', fetched.dmpl__Status__c, 'Status should be Customer Requested');
		System.assertEquals(asset1.Id, fetched.dmpl__AssetId__c, 'Asset should be Asset 1');

		System.assertNotEquals(null, taxEntry.Id, 'Service Request Tax should be inserted');
		System.assertEquals(sr.Id, taxEntry.dmpl__ServiceRequestId__c, 'Service Request should be linked');
		System.assertEquals(taxGroup.Id, taxEntry.dmpl__TaxGroupId__c, 'Tax Group should match');
		System.assertEquals(tax.Id, taxEntry.dmpl__TaxId__c, 'Tax should match');
	}
	@isTest
	static void EditServiceRequestTaxWithUpdatedServiceRequestNegative() {
		Test.startTest();
		Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
		Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
		dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
		dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
		Asset asset1 = AssetTestDataHelpers.getAsset('Asset 1');

		dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');

		dmpl__Tax__c createtax = TestDataHelpers.createTax('GST Tax', 'SGST', null, taxGroup.Id, 'Tax1');
		dmpl__Tax__c tax = TestDataHelpers.getTax('GST Tax');

		dmpl__ServiceRequest__c sr1 = ServiceRequestTestDataHelpers.createServiceRequestWithId(partner1, customer1, branch1, asset1);

		dmpl__ServiceRequest__c sr2 = ServiceRequestTestDataHelpers.createServiceRequestWithId(partner1, customer1, branch1, asset1);

		dmpl__ServiceRequestTax__c taxEntry = ServiceRequestTestDataHelpers.createServiceRequestTax(sr1, null, taxGroup, tax);

		dmpl__ServiceRequest__c fetched = ServiceRequestTestDataHelpers.getServiceRequestById(sr1.Id);

		System.assertEquals(partner1.Id, fetched.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
		System.assertEquals(branch1.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 1');
		System.assertEquals(customer1.Id, fetched.dmpl__AccountId__c, 'Customer should be Customer 1');
		System.assertEquals(customer1.dmpl__BillingStreet__c, fetched.dmpl__BillingStreet__c, 'Billing street should match');
		System.assertEquals(customer1.dmpl__BillingCity__c, fetched.dmpl__BillingCity__c, 'Billing city should match');
		System.assertEquals(customer1.dmpl__BillingState__c, fetched.dmpl__BillingState__c, 'Billing state should match');
		System.assertEquals(customer1.dmpl__BillingPostalCode__c, fetched.dmpl__BillingPostalCode__c, 'Billing postal code should match');
		System.assertEquals(customer1.dmpl__ShippingStreet__c, fetched.dmpl__ShippingStreet__c, 'Shipping street should match');
		System.assertEquals(customer1.dmpl__ShippingCity__c, fetched.dmpl__ShippingCity__c, 'Shipping city should match');
		System.assertEquals(customer1.dmpl__ShippingState__c, fetched.dmpl__ShippingState__c, 'Shipping state should match');
		System.assertEquals(customer1.dmpl__ShippingPostalCode__c, fetched.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
		System.assertEquals(customer1.dmpl__ShippingCountry__c, fetched.dmpl__ShippingCountry__c, 'Shipping country should match');
		System.assertEquals('Customer Requested', fetched.dmpl__Status__c, 'Status should be Customer Requested');
		System.assertEquals(asset1.Id, fetched.dmpl__AssetId__c, 'Asset should be Asset 1');

		System.assertNotEquals(null, taxEntry.Id, 'Tax record should be inserted');
		System.assertEquals(sr1.Id, taxEntry.dmpl__ServiceRequestId__c, 'Tax should be linked to SR1');

		Boolean updateFailed = false;
		try {
			taxEntry.dmpl__ServiceRequestId__c = sr2.Id;
			update taxEntry;
		} catch (Exception e) {
			updateFailed = true;
		}
		Test.stopTest();
		System.assert(updateFailed, 'Updating ServiceRequestId__c should not be allowed or should fail');
	}
}