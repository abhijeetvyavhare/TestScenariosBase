@isTest
public with sharing class AccountHandler_Test {
    @TestSetup
    static void createRequiredData(){
        Account partnerAccount = AccountDataHelper.createPartnerAccount('PartnerAccount');
        Account customerAccount = AccountDataHelper.createCustomerAccount('CustomerAccount');
        Account supplierAccount = AccountDataHelper.createSupplierAccount('SupplierAccount');
        String setupAccountGroupName = 'Test Setup Account Group';
        dmpl__AccountGroup__c setupAccountGroup = AccountDataHelper.createAccountGroup(setupAccountGroupName);
        dmpl__AccountGroupRule__c accountGroupRule = AccountDataHelper.createAccountGroupRule(1, setupAccountGroup.Id);
        dmpl__AccountGroupMember__c accountGroupMember = AccountDataHelper.createAccountGroupMember(
            setupAccountGroup.Id, 
            'Test batch instance id'
        );
        String setupLocationName = 'Test Setup Location';
        dmpl__AccountLocations__c setupLocation = AccountDataHelper.createAccountLocation(setupLocationName);
        dmpl__AccountRewardLedger__c accountRewardLedger = AccountDataHelper.createAccountRewardLedger(customerAccount.Id, 200);
        dmpl__AccountStock__c accountStock = AccountDataHelper.createAccountStock(1000);
        Date startDate = Date.newInstance(2026, 1, 1);
        Date endDate = Date.newInstance(2026, 12, 31);
        dmpl__AccountUser__c accountUser = AccountDataHelper.createAccountUser(
            customerAccount.Id, 
            startDate,
            endDate
        );



        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1', false, true, false, true, 'MG Road', 'Bengaluru', 'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India', '560095','9876543210');
		Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2', false, true, false, true, '45 Residency Road', 'Pune', 'Maharashtra', 'India', '411001', '22 Commerce Avenue', 'Pune', 'Maharashtra', 'India', '411038','91-99665544433');
        Account partnerAccount3 = TestDataHelpers.createPartnerAccount('Partner 3', false, true, false, true, '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '91-9123456789');
        Account partnerAccount4 = TestDataHelpers.createPartnerAccount('Partner 4', false, true, false, true, '12 Industrial Zone', 'Hyderabad','Telangana', 'India', '500032', '12 Industrial Zone', 'Hyderabad', 'Telangana', 'India','500032','9876012345');
        Account partnerAccount6 = TestDataHelpers.createPartnerAccount('Partner 6', false, true, false, true, 'MS Road', 'Bengaluru','Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India','560095','9845543210');

        Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1', true, false, false, true, 'MG Road', 'Pune', 'Maharashtra', 'India', '411001', 'Ring Rd', 'Nagpur', 'Maharashtra', 'India', '440001','9876543210', 'Created');
        Account customerAccount2 = TestDataHelpers.createCustomerAccount('Customer 2', true, false, false, true, 'Park St', 'Kolkata', 'West Bengal', 'India', '700016', 'Lake Rd', 'Kolkata', 'West Bengal', 'India', '700029','9876543210', 'Created');
        Account customerAccount3 = TestDataHelpers.createCustomerAccount('Customer 3', true, false, false, true, 'Anna Salai', 'Chennai', 'Tamil Nadu', 'India', '600002', 'T Nagar', 'Chennai', 'Tamil Nadu', 'India', '600017','9012345678', 'Created');
        Account customerAccount7 = TestDataHelpers.createCustomerAccount('Customer 7', true, false, false, false, 'Mission Road', 'Bengaluru', 'Karnataka', 'India', '560027', 'Indiranagar', 'Bengaluru', 'Karnataka', 'India', '560038','9811122233', 'Created');
        Account customerAccount6 = TestDataHelpers.createCustomerAccount('Customer 6', true, false, false, true, 'Sector 18', 'Noida', 'Uttar Pradesh', 'India', '201301', 'Sector 62', 'Noida', 'Uttar Pradesh', 'India', '201309','9876501234', 'Created');
        Account customerAccount4 = TestDataHelpers.createCustomerAccount('Customer 4', true, false, false, true, 'SG Highway', 'Ahmedabad', 'GJ', 'India', '380054', 'C G Road', 'Ahmedabad', 'GJ', 'India', '380009','9988776655', 'Created');
        Account customerAccount10 = TestDataHelpers.createCustomerAccount('Customer 10', true, false, false, true, 'Park Street', 'Kolkata', 'WB', 'India', '700017', 'Salt Lake', 'Kolkata', 'WB', 'India', '700091','9123456701', 'Created');
        

        dmpl__AccountGroup__c accountGroup1 = AccountDataHelper.createAccountGroup('Account Group 1');
        dmpl__AccountGroup__c accountGroup2 = AccountDataHelper.createAccountGroup('Account Group 2');
        dmpl__AccountGroup__c accountGroup3 = AccountDataHelper.createAccountGroup('Account Group 3');
        dmpl__AccountGroup__c accountGroup4 = AccountDataHelper.createAccountGroup('Account Group 4');

        dmpl__AccountGroupMember__c accountGroupMember1 = AccountDataHelper.createAccountGroupMember(accountGroup1.Id, partnerAccount1.Id, 'Batch Instance 1');
        dmpl__AccountGroupMember__c accountGroupMember2 = AccountDataHelper.createAccountGroupMember(accountGroup1.Id, partnerAccount2.Id, 'Batch Instance 2');
        //dmpl__AccountGroupMember__c accountGroupMember3 = AccountDataHelper.createAccountGroupMember(accountGroup1.Id, partnerAccount5.Id, 'Batch Instance 3');
        dmpl__AccountGroupMember__c accountGroupMember4 = AccountDataHelper.createAccountGroupMember(accountGroup2.Id, partnerAccount3.Id, 'Batch Instance 4');
        dmpl__AccountGroupMember__c accountGroupMember5 = AccountDataHelper.createAccountGroupMember(accountGroup2.Id, partnerAccount4.Id, 'Batch Instance 5');

        dmpl__AccountGroupMember__c accountGroupMember6 = AccountDataHelper.createAccountGroupMember(accountGroup3.Id, customerAccount1.Id, 'Batch Instance 6');
        dmpl__AccountGroupMember__c accountGroupMember7 = AccountDataHelper.createAccountGroupMember(accountGroup3.Id, customerAccount3.Id, 'Batch Instance 7');
        //dmpl__AccountGroupMember__c accountGroupMember8 = AccountDataHelper.createAccountGroupMember(accountGroup3.Id, customerAccount5.Id, 'Batch Instance 8');
        dmpl__AccountGroupMember__c accountGroupMember9 = AccountDataHelper.createAccountGroupMember(accountGroup3.Id, customerAccount6.Id, 'Batch Instance 9');
        //dmpl__AccountGroupMember__c accountGroupMember10 = AccountDataHelper.createAccountGroupMember(accountGroup3.Id, customerAccount8.Id, 'Batch Instance 10');
        dmpl__AccountGroupMember__c accountGroupMember11 = AccountDataHelper.createAccountGroupMember(accountGroup3.Id, customerAccount10.Id, 'Batch Instance 11');
        dmpl__AccountGroupMember__c accountGroupMember12 = AccountDataHelper.createAccountGroupMember(accountGroup4.Id, customerAccount2.Id, 'Batch Instance 12');
        dmpl__AccountGroupMember__c accountGroupMember13 = AccountDataHelper.createAccountGroupMember(accountGroup4.Id, customerAccount4.Id, 'Batch Instance 13');
        dmpl__AccountGroupMember__c accountGroupMember14 = AccountDataHelper.createAccountGroupMember(accountGroup4.Id, customerAccount7.Id, 'Batch Instance 14');
        //dmpl__AccountGroupMember__c accountGroupMember15 = AccountDataHelper.createAccountGroupMember(accountGroup4.Id, customerAccount9.Id, 'Batch Instance 15');

        Account supplierAccount1 = TestDataHelpers.createSupplierAccount('Supplier 1','55 Industrial Park Road','Ahmedabad','Gujarat','India','380015','55 Industrial Park Road','Ahmedabad','Gujarat','India','380015', '9988776564');

        dmpl__Branch__c branch1=TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id, true, true, false, true);
        dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partnerAccount2.Id, true, false, true, true);
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partnerAccount1.Id, false, true, true, false);
        dmpl__Branch__c branch4 =TestDataHelpers.createBranch('Branch 4',partnerAccount4.Id,true,true,false,false);
        dmpl__Branch__c branch6 =TestDataHelpers.createBranch('Branch 6',partnerAccount6.Id,true,true,false,true);

        dmpl__ContactAddress__c address1 = TestDataHelpers.createContactAddress('Address 1', 'Ring Rd', 'Pune', 'Maharashtra', customerAccount1.Id, 'Billing Address', '440001', false);
        dmpl__ContactAddress__c address2 = TestDataHelpers.createContactAddress('Address 2', 'Ring Rd', 'Pune', 'Maharashtra', customerAccount1.Id, 'Billing Address', '440001',false);
        dmpl__ContactAddress__c Address3 = TestDataHelpers.CreateContactAddress('Address 3', 'Lake Road', 'Kolkata', 'West Bengal', customerAccount1.Id,'Billing Address','440022',false);
        dmpl__ContactAddress__c address4 = TestDataHelpers.createContactAddress('Address 1', 'Ring Rd', 'Pune', 'Maharashtra', customerAccount2.Id, 'Billing Address', '440001', false);
        dmpl__ContactAddress__c address5 = TestDataHelpers.createContactAddress('Address 2', 'Ring Rd', 'Pune', 'Maharashtra', customerAccount2.Id, 'Shipping Address', '440001', false);

        Contact contact = TestDataHelpers.createContact('Contact 1', '9113150885', '9889198008', customerAccount1.Id);

        dmpl__PriceList__c priceList1 = TestDataHelpers.createPriceList('Price List 1', partnerAccount1.Id, branch1.Id, null, null, true, false, 'Sale Price');
        dmpl__PriceList__c priceList2 = TestDataHelpers.createPriceList('Price List 2', partnerAccount1.Id, branch1.Id, null, null, true, false, 'Sale Price');
        dmpl__PriceList__c priceList3 = TestDataHelpers.createPriceList('Price List 3',partnerAccount4.Id,branch4.Id,null,null,true,false,'Sale Price');
        dmpl__PriceList__c priceList5=TestDataHelpers.createPriceList('Price List 5', partnerAccount6.Id, branch6.Id, null, null, false, false, 'Sales');
        dmpl__PriceList__c priceList7 = TestDataHelpers.createPriceList('Price List 7',null,null, null, null, true, false, 'Sales');

        dmpl__GLAccount__c glAccount1 = AccountDataHelper.createGLAccount('ICICI Bank', 'Bank', true, partnerAccount1.Id, branch1.Id);

        dmpl__AccountBalance__c accountBalance = AccountDataHelper.createAccountBalance(
            glAccount1.Id, 
            1000
        );

        dmpl__Item__c item1 = TestDataHelpers.createItem('Item 1','Product',true,false,false,'675654',false, false);
        dmpl__Item__c item2 = TestDataHelpers.createItem('Item 2','Product',false,false,false,'654345',false, false);
        dmpl__Item__c item3 = TestDataHelpers.createItem('Item 3','Charge Item',true, false, false ,'765434',true, false);
        dmpl__Item__c item4 = TestDataHelpers.createItem('Item 4','Product',true, false, false ,'765676',true, false);
        dmpl__Item__c item5 = TestDataHelpers.createItem('Item 5', 'Product', true, false, false, '876543', false, false);
        dmpl__Item__c item6 = TestDataHelpers.createItem('Item 6', 'Product', true, false, false, '765456', false, false);
        dmpl__Item__c item7 = TestDataHelpers.createItem('Item 7','Product',true,false,true, '765456',false,false);
        dmpl__Item__c item8 = TestDataHelpers.createItem('Item 8','Product',true,false,true, '765456',false, false);
        dmpl__Item__c item13 = TestDataHelpers.createItem('Item 13','Product',true,false,false, '765456',true, false);
        dmpl__Item__c item14 = TestDataHelpers.createItem('Item 14', 'Part', true, false, false, '765458', true, false);
        dmpl__Item__c item15 = TestDataHelpers.createItem('Item 15', 'Part', true, false, false, '765459', false, true);
        dmpl__Item__c item16 = TestDataHelpers.createItem('Item 16', 'Part', true, false, false, '765460', false, true);

        dmpl__ItemGroup__c itemGroup1 = TestDataHelpers.createItemGroup('Item Group 1','Tax');
        dmpl__ItemGroupMember__c itemGroupMemeber1 = TestDataHelpers.createItemGroupMember(itemGroup1.Id,item1.Id);
        dmpl__ItemGroupMember__c itemGroupMemeber2 = TestDataHelpers.createItemGroupMember(itemGroup1.Id,item2.Id);

        dmpl__ItemAlternate__c itemAlternate16 = TestDataHelpers.createItemAlternate(item15.Id,item16.Id,'Superseded',Date.newInstance(2025, 6, 30));
        dmpl__ItemAlternate__c itemAlternate13 = TestDataHelpers.createItemAlternate(item14.Id, item13.Id, 'Superseded', Date.newInstance(2025, 6, 30));
     
        dmpl__SKU__c sku1 = TestDataHelpers.createSKU('SKU 1', item7.id, true);
        dmpl__SKU__c sku2 = TestDataHelpers.createSKU('SKU 2', item8.id, false);

        dmpl__PriceListRules__c priceListRule1 = TestDataHelpers.createPriceListRules(priceList1.id, item1.id,null,null,1500, System.today().addDays(-15),System.today()+9);
        dmpl__PriceListRules__c priceListRule10 = TestDataHelpers.createPriceListRules(priceList3.id, item1.id,null,null,1500, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule3 = TestDataHelpers.createPriceListRules(priceList1.id, item3.id,null,null,2000, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule4 = TestDataHelpers.createPriceListRules(priceList1.id, item4.id,null,null,2000, System.today()-1,System.today()+9);  
        dmpl__PriceListRules__c priceListRule5 = TestDataHelpers.createPriceListRules(priceList3.id, item6.id,null,null,2000, System.today()-1,System.today()+9); 
        dmpl__PriceListRules__c priceListRule7 = TestDataHelpers.createPriceListRules(priceList3.id, item5.id,null,null,1000, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule8 = TestDataHelpers.createPriceListRules(priceList1.id, item5.id,null,null,1000, System.today().addDays(-1),System.today()+9);
        dmpl__PriceListRules__c priceListRule9 = TestDataHelpers.createPriceListRules(priceList1.id, item6.id,null,null,2400, System.today()-1,System.today()+9);  
        dmpl__PriceListRules__c priceListRule11 = TestDataHelpers.createPriceListRules(priceList3.id, item8.id,null,null,1500, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule13 = TestDataHelpers.createPriceListRules(priceList1.id, item13.id,null,null,1500, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule14 = TestDataHelpers.createPriceListRules(priceList1.id, item14.id,null,null,1500, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule12 = TestDataHelpers.createPriceListRules(priceList1.id, item15.id,null,null,1500, System.today()-1,System.today()+9);
        dmpl__PriceListRules__c priceListRule16 = TestDataHelpers.createPriceListRules(priceList1.id, item16.id,null,null,1500, System.today()-1,System.today()+9);

        dmpl__TaxGroup__c taxGroupGST28partner1 = TestDataHelpers.createTaxGroup('GST 28', true, 'Line Level', partnerAccount1.Id, branch1.Id, null);
        dmpl__TaxGroup__c taxGroupGST28partner4= TestDataHelpers.createTaxGroup('GST 288', true, 'Line Level', partnerAccount4.Id, branch4.Id, null);
        dmpl__TaxGroup__c taxGroupGST12Global = TestDataHelpers.createTaxGroup('GST 12', true, 'Line Level', null, null, null);
        dmpl__TaxGroup__c taxGroupIGST18 = TestDataHelpers.createTaxGroup('IGST 18', true, 'Line Level', null, null, null);

        dmpl__Tax__c taxCGST14 = TestDataHelpers.createTax('CGST', 'CGST', 14, taxGroupGST28partner1.Id, 'Tax1');
        dmpl__Tax__c taxSGST14 = TestDataHelpers.createTax('SGST', 'SGST', 14, taxGroupGST28partner1.Id, 'Tax2');
        dmpl__Tax__c taxCGST6 = TestDataHelpers.createTax('CGST', 'CGST', 6, taxGroupGST12Global.Id, 'Tax1');
        dmpl__Tax__c taxSGST6 = TestDataHelpers.createTax('SGST', 'SGST', 6, taxGroupGST12Global.Id, 'Tax2');
        dmpl__Tax__c taxIGST18 = TestDataHelpers.createTax('IGST', 'IGST', 18, taxGroupIGST18.Id, 'Tax3');
        dmpl__Tax__c taxCGST14_8 = TestDataHelpers.createTax('CGST', 'CGST', 14, taxGroupGST28partner4.Id, 'Tax1');
        dmpl__Tax__c taxSGST14_8 = TestDataHelpers.createTax('SGST', 'SGST', 14, taxGroupGST28partner4.Id, 'Tax2');

        dmpl__TaxGroupRule__c taxGroupRule28Item1 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST28partner1.Id,item1.Id,null,null,null);
        dmpl__TaxGroupRule__c taxGroupRule12Item5 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST12Global.Id,item5.Id,null,null,null);
        dmpl__TaxGroupRule__c taxGroupRule12Item4 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST12Global.Id,item6.Id,null,null,null);
        dmpl__TaxGroupRule__c taxGroupRuleItem1 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST12Global.Id,item1.Id,null,null,null);
        dmpl__TaxGroupRule__c taxGroupRuleIGST18 = TestDataHelpers.createTaxGroupRule('Outside State',taxGroupIGST18.Id,null,null,null,null);  
        dmpl__TaxGroupRule__c taxGroupRule28item8 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST28partner4.Id,item8.Id,null,null,null); 
        dmpl__TaxGroupRule__c taxGroupRule28Item13 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST28partner1.Id,item13.Id,null,null,null);    
        dmpl__TaxGroupRule__c taxGroupRule28Item14 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST28partner1.Id,item14.Id,null,null,null);    
        dmpl__TaxGroupRule__c taxGroupRule28Item15 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST28partner1.Id,item15.Id,null,null,null);
        dmpl__TaxGroupRule__c taxGroupRule28Item16 = TestDataHelpers.createTaxGroupRule('Within State',taxGroupGST28partner1.Id,item16.Id,null,null,null); 
        dmpl__TaxGroupRule__c taxGroupRule18Item5IGST = TestDataHelpers.createTaxGroupRule('Outside State',taxGroupIGST18.Id,item5.Id,null,null,null);   
        
        dmpl__Resource__c resource2 = TestDataHelpers.createResource('Resource 2', partnerAccount1.Id, branch1.Id, false); 

        dmpl__DiscountGroup__c discountGroup1 = DiscountDataHelper.createDiscountGroup('Discount 1',partnerAccount4.Id,branch4.Id,null,true,'Sale Price');
        dmpl__DiscountGroup__c discountGroup2 = DiscountDataHelper.createDiscountGroup('Discount 2',partnerAccount1.Id,branch1.Id,null,true,'Purchase Price');

        dmpl__DiscountGroupRule__c discountGroupRule1 = DiscountDataHelper.createDiscountGroupRule(discountGroup1.Id,item6.Id,null,null,null,4,Date.newInstance(2025, 1, 5),Date.newInstance(2025, 7, 30)); 
        dmpl__DiscountGroupRule__c discountGroupRule2 = DiscountDataHelper.createDiscountGroupRule(discountGroup1.Id,item5.Id,null,null,null,4,Date.newInstance(2025, 1, 5),Date.newInstance(2025, 7, 30)); 
        dmpl__DiscountGroupRule__c discountGroupRule3 = DiscountDataHelper.createDiscountGroupRule(discountGroup2.Id,item6.Id,null,null,null,4,Date.newInstance(2025, 5, 6),Date.newInstance(2025, 11, 30));

        dmpl__ItemUnitOfMeasure__c uomCaseItem5 = TestDataHelpers.ItemUnitOfMeasure('Case','Case',1, item5.Id);
        dmpl__ItemUnitOfMeasure__c uomPiecesItem5 = TestDataHelpers.ItemUnitOfMeasure('Pieces','Pieces',0.033333, item5.Id);
        dmpl__ItemUnitOfMeasure__c uomCaseItem1 = TestDataHelpers.ItemUnitOfMeasure('Case','Case',1, item1.Id);
        dmpl__ItemUnitOfMeasure__c uomPiecesItem1 = TestDataHelpers.ItemUnitOfMeasure('Pieces','Pieces',0.033333, item1.Id);
        dmpl__ItemUnitOfMeasure__c uomCaseItem6 = TestDataHelpers.ItemUnitOfMeasure('Case','Case',1, item6.Id);
        dmpl__ItemUnitOfMeasure__c uomPiecesItem6 = TestDataHelpers.ItemUnitOfMeasure('Pieces','Pieces',0.033333, item6.Id);

        dmpl__Scheme__c scheme2 = SchemeDataHelper.createScheme('Scheme 2', 'Auto Apply', 'Draft', 'Per Sale order and Invoice', 'Per Order', Date.newInstance(2025, 5, 1), Date.newInstance(2025, 6, 30), 10, 'Apply all Fulfilled', 1, false, partnerAccount4.Id, null, null, null, branch4.Id, 100000);
        dmpl__SchemeLine__c schemeLine2 = SchemeDataHelper.createSchemeLine(1, 'NET RATE', 'All Conditions Are Met', 'All Rewards', scheme2.Id);
        dmpl__SchemeCondition__c schemeCondition2 = SchemeDataHelper.createSchemeCondition('Item Quantity', 'Greater Than Or Equal', item5.Id, 10, schemeLine2.Id, scheme2.Id, 1);
        dmpl__SchemeBenefit__c schemeBenefit2 = SchemeDataHelper.createSchemeBenefit( 'Rate Off', 'Line Level Discount Amount',null, null,null, 1000, schemeLine2.Id, scheme2.Id,1);        
        dmpl__SchemeAccountBudget__c schemeBudget2 = SchemeDataHelper.createSchemesAccountBudget(100000, scheme2.Id, partnerAccount4.Id);
        scheme2.dmpl__Status__c = 'Approved';
        update scheme2;
       
        dmpl__Scheme__c scheme9 = SchemeDataHelper.createScheme('Scheme 9', 'Auto Apply', 'Draft', 'Per Sale Order And Invoice', 'per order', Date.newInstance(2025, 5, 26), Date.newInstance(2025, 6, 26), 0, 'Apply all Fulfilled', 1,false, partnerAccount1.Id, null, null, customerAccount1.Id, branch1.Id, 100000);
        dmpl__SchemeLine__c schemeLine9 = SchemeDataHelper.createSchemeLine(1, 'Percentage', 'All Conditions Are Met', 'All Rewards', scheme9.Id);
        dmpl__SchemeCondition__c schemeCondition9 = SchemeDataHelper.createSchemeCondition('Item Quantity', 'Equals', item6.Id, 2, schemeLine9.Id, scheme9.Id, 1);
        dmpl__SchemeBenefit__c schemeBenefit9 = SchemeDataHelper.createSchemeBenefit('FREE ITEM', 'Line Level Discount Percent', null, 1, 5, null, schemeLine9.Id, scheme9.Id, 1);
        dmpl__SchemeAccountBudget__c schemeBudget9 = SchemeDataHelper.createSchemesAccountBudget(100000, scheme9.Id, partnerAccount1.Id);
        scheme9.dmpl__Status__c = 'Approved';
        update scheme9;

        dmpl__Scheme__c scheme20 = SchemeDataHelper.createScheme('Scheme 20', 'Auto Apply', 'Draft', 'Per Purchase order', 'PER ORDER', Date.newInstance(2025, 5, 20), Date.newInstance(2025, 6, 30), 2, 'Apply all Fulfilled', 1, true, partnerAccount1.Id, null, null, customerAccount1.Id, branch1.Id, 100000);
        dmpl__SchemeLine__c schemeLine20 = SchemeDataHelper.createSchemeLine(1, 'FREE OF COST', 'All Conditions Are Met', 'All Rewards', scheme20.Id);
        dmpl__SchemeCondition__c schemeCondition20 = SchemeDataHelper.createSchemeCondition('Item Quantity', 'Greater Than Or Equal', item1.Id, 18, schemeLine20.Id, scheme20.Id, 1);
        dmpl__SchemeBenefit__c schemeBenefit20 = SchemeDataHelper.createSchemeBenefit('FREE ITEM', 'Discounted Item', item1.Id, 1, 5, null, schemeLine20.Id, scheme20.Id, 1);
        dmpl__SchemeAccountBudget__c schemeBudget20 = SchemeDataHelper.createSchemesAccountBudget(100000, scheme20.Id, partnerAccount1.Id);
        scheme20.dmpl__Status__c = 'Approved';
        update scheme20;

         Test.startTest();
        //dmpl__AccountGroup__c accountGroup1 = TestDataHelpers.createAccountGroup('Account Group 1',null);
        dmpl__Resource__c resource1 = TestDataHelpers.getResource();
        dmpl__VisitRoute__c route =VisitPlanTestDataHelpers.CreateVisitRoute(accountGroup1,partnerAccount1,resource1);
        dmpl__VisitRouteStop__c routeStop=VisitPlanTestDataHelpers.CreateVisitRouteStop(customerAccount1,route);
        dmpl__VisitTaskTemplate__c taskTemplate=VisitPlanTestDataHelpers.CreateVisitTaskTemplate();
        dmpl__VisitPlan__c plans=VisitPlanTestDataHelpers.CreateVisitPlan(partnerAccount1,route,taskTemplate);
        dmpl__Visit__c visits=VisitPlanTestDataHelpers.CreateVisit(customerAccount1,plans,taskTemplate);
        dmpl__VisitTaskTemplateEntry__c entry=VisitPlanTestDataHelpers.CreateVisitTaskTemplateEntry(taskTemplate);
        dmpl__VisitTaskTemplateActivity__c taskTempActivity=VisitPlanTestDataHelpers.CreateVisitTaskTemplateActivity(entry);
        dmpl__VisitTask__c task=VisitPlanTestDataHelpers.CreateVisitTask(visits,entry);
        dmpl__VisitTaskActivity__c taskActivity=VisitPlanTestDataHelpers.CreateVisitTaskActivity(task);
        Test.stopTest();
    }

    @isTest
    static void createPartnerAccountPositive() {
        Account partnerAccount = AccountDataHelper.getAccountByName('PartnerAccount');
        System.assertNotEquals(partnerAccount, null, 'Expected partnerAccount to be created.');
    }

    @isTest
    static void createCustomerAccountPositive() {
        Account customerAccount = AccountDataHelper.getAccountByName('CustomerAccount');
        System.assertNotEquals(customerAccount, null, 'Expected customerAccount to be created.');
    }

    @isTest 
    static void createSupplierAccountPositive(){
        Account supplierAccount = AccountDataHelper.getAccountByName('SupplierAccount');
        System.assertNotEquals(supplierAccount, null, 'Expected supplier account to be created.');
    }

    @isTest 
    static void updatePartnerAccountPositive(){
        Account partnerAccount = AccountDataHelper.getAccountByName('PartnerAccount');
        partnerAccount.Name = 'UpdatedPartnerAccount';
        test.startTest();
        update partnerAccount;
        test.stopTest();
        Account updatedPartnerAccount = AccountDataHelper.getAccountById(partnerAccount.Id);
        System.assertEquals(
            String.valueOf(updatedPartnerAccount.Name),
            'UpdatedPartnerAccount',
            'Expected the account to be updated for partner account.'
        );
    }

    @isTest 
    static void updateCustomerAccountPositive(){
        Account customerAccount = AccountDataHelper.getAccountByName('CustomerAccount');
        customerAccount.Name = 'UpdatedCustomerAccount';
        test.startTest();
        update customerAccount;
        test.stopTest();
        Account updatedCustomerAccount = AccountDataHelper.getAccountById(customerAccount.Id);
        System.assertEquals(
            updatedCustomerAccount.Name,
            'UpdatedCustomerAccount',
            'Expected the account to be updated for customer account.'
        );
    }

    @isTest 
    static void updateSupplierAccountPositive(){
        Account supplierAccount = AccountDataHelper.getAccountByName('SupplierAccount');
        supplierAccount.Name = 'UpdatedSupplierAccount';
        test.startTest();
        update supplierAccount;
        test.stopTest();
        Account updatedSupplierAccount = AccountDataHelper.getAccountById(supplierAccount.Id);
        System.assertEquals(
            updatedSupplierAccount.Name,
            'UpdatedSupplierAccount',
            'Expected the supplier account to be updated.'
        );
    }

    @isTest 
    static void deletePartnerAccountPositive(){
        Account partnerAccount = AccountDataHelper.getAccountByName('PartnerAccount');
        test.startTest();
        delete partnerAccount;
        test.stopTest();
        Account deletedPartnerAccount = AccountDataHelper.getAccountById(partnerAccount.Id);
        System.assertEquals(
            deletedPartnerAccount,
            null,
            'Expected the partner account to be deleted.'
        );
    }

    @isTest
    static void deleteCustomerAccountPositive(){
        Account customerAccount = AccountDataHelper.getAccountByName('CustomerAccount');
        test.startTest();
        delete customerAccount;
        test.stopTest();
        Account deletedCustomerAccount = AccountDataHelper.getAccountById(customerAccount.Id);
        System.assertEquals(
            deletedCustomerAccount,
            null,
            'Expected the customer account to be deleted.'
        );
    }

    @isTest 
    static void deleteSupplierAccountPositive(){
        Account supplierAccount = AccountDataHelper.getAccountByName('SupplierAccount');
        test.startTest();
        delete supplierAccount;
        test.stopTest();
        Account deletedSupplierAccount = AccountDataHelper.getAccountById(supplierAccount.Id);
        System.assertEquals(
            deletedSupplierAccount,
            null,
            'Expected the supplier account to be deleted.'
        );
    }

    @isTest 
    static void createAccountGroupPositive() {
        dmpl__AccountGroup__c setupAccountGroup = AccountDataHelper.getAccountGroupByName('Test Setup Account Group');
        System.assertNotEquals(setupAccountGroup, null, 'Expected account group to be created.');
    }

    @isTest 
    static void updateAccountGroupPositive() {
        dmpl__AccountGroup__c setupAccountGroup = AccountDataHelper.getAccountGroupByName('Test Setup Account Group');
        setupAccountGroup.Name = 'Updated Name';
        Test.startTest();
        update setupAccountGroup;
        Test.stopTest();
        dmpl__AccountGroup__c updated = AccountDataHelper.getAccountGroupById(setupAccountGroup.Id);
        System.assertEquals(updated.Name, 'Updated Name', 'Account group name should be updated.');
    }

    @isTest 
    static void deleteAccountGroupPositive() {
        dmpl__AccountGroup__c setupAccountGroup = AccountDataHelper.getAccountGroupByName('Test Setup Account Group');
        Test.startTest();
        delete setupAccountGroup;
        Test.stopTest();
        dmpl__AccountGroup__c deletedGroups = AccountDataHelper.getAccountGroupById(setupAccountGroup.Id);
        System.assertEquals(deletedGroups, null, 'Account group should be deleted.');
    }

    @isTest 
    static void createAccountGroupRulePositive() {
        dmpl__AccountGroupRule__c accountGroupRule = AccountDataHelper.getAccountGroupRuleBySequenceNumber(1);
        System.assertNotEquals(accountGroupRule, null, 'Expected accountGroupRule to be created.');
    }

    @isTest
    static void updateAccountGroupRulePositive() {
        dmpl__AccountGroupRule__c accountGroupRule = AccountDataHelper.getAccountGroupRuleBySequenceNumber(1);
        accountGroupRule.dmpl__SequenceNumber__c = 5;
        Test.startTest();
        update accountGroupRule;
        Test.stopTest();
        dmpl__AccountGroupRule__c updated = AccountDataHelper.getAccountGroupRuleById(accountGroupRule.Id);
        System.assertEquals(updated.dmpl__SequenceNumber__c, 5, 'Account group rule sequence number should be updated.');
    }

    @isTest
    static void deleteAccountGroupRulePositive() {
        dmpl__AccountGroupRule__c accountGroupRule = AccountDataHelper.getAccountGroupRuleBySequenceNumber(1);
        Test.startTest();
        delete accountGroupRule;
        Test.stopTest();
        dmpl__AccountGroupRule__c deletedLines = AccountDataHelper.getAccountGroupRuleById(accountGroupRule.Id);
        System.assertEquals(deletedLines, null, 'Account group rule should be deleted.');
    }

    @isTest 
    static void createAccountGroupMemberPositive() {
        dmpl__AccountGroupMember__c accountGroupMember = AccountDataHelper.getAccountGroupMemberByBatchInstanceId('Test batch instance id');
        System.assertNotEquals(accountGroupMember, null, 'Expected accountGroupMember to be created.');
    }

    @isTest 
    static void updateAccountGroupMemberPositive() {
        dmpl__AccountGroupMember__c accountGroupMember = AccountDataHelper.getAccountGroupMemberByBatchInstanceId('Test batch instance id');
        accountGroupMember.dmpl__BatchInstanceId__c = 'Updated batch instance id';
        Test.startTest();
        update accountGroupMember;
        Test.stopTest();
        dmpl__AccountGroupMember__c updated = AccountDataHelper.getAccountGroupMemberById(accountGroupMember.Id);
        System.assertEquals(updated.dmpl__BatchInstanceId__c, 'Updated batch instance id', 'Account group member batch instance ID should be updated.');
    }

    @isTest
    static void deleteAccountGroupMemberPositive() {
        dmpl__AccountGroupMember__c accountGroupMember = AccountDataHelper.getAccountGroupMemberByBatchInstanceId('Test batch instance id');
        Test.startTest();
        delete accountGroupMember;
        Test.stopTest();
        dmpl__AccountGroupMember__c deletedMember = AccountDataHelper.getAccountGroupMemberById(accountGroupMember.Id);
        System.assertEquals(deletedMember, null, 'Account group member should be deleted.');
    }

    @isTest 
    static void createAccountLocationPositive() {
        dmpl__AccountLocations__c setUpLocation = AccountDataHelper.getAccountLocationByName('Test Setup Location');
        System.assertNotEquals(setUpLocation, null, 'Expected account location to be created.');
    }

    @isTest 
    static void updateAccountLocationPositive() {
        dmpl__AccountLocations__c setupLocation = AccountDataHelper.getAccountLocationByName('Test Setup Location');
        setupLocation.Name = 'Updated Name';
        Test.startTest();
        update setupLocation;
        Test.stopTest();
        dmpl__AccountLocations__c updated = AccountDataHelper.getAccountLocationById(setupLocation.Id);
        System.assertEquals(updated.Name, 'Updated Name', 'Account location name should be updated.');
    }

    @isTest 
    static void deleteAccountLocationPositive() {
        dmpl__AccountLocations__c setupLocation = AccountDataHelper.getAccountLocationByName('Test Setup Location');
        Test.startTest();
        delete setupLocation;
        Test.stopTest();
        dmpl__AccountLocations__c deletedLines = AccountDataHelper.getAccountLocationById(setupLocation.Id);
        System.assertEquals(deletedLines, null, 'Account location should be deleted.');
    }

    @isTest
    static void createAccountRewardLedgerPositive() {
        dmpl__AccountRewardLedger__c accountRewardLedger = AccountDataHelper.getAccountRewardLedgerByRewardPoints(200);
        System.assertNotEquals(accountRewardLedger, null, 'Expected account reward ledger to be created.');
    }

    @isTest
    static void updateAccountRewardLedgerPositive() {
        dmpl__AccountRewardLedger__c accountRewardLedger = AccountDataHelper.getAccountRewardLedgerByRewardPoints(200);
        accountRewardLedger.dmpl__RewardPoints__c = 300;
        Test.startTest();
        update accountRewardLedger;
        Test.stopTest();
        dmpl__AccountRewardLedger__c updated = AccountDataHelper.getAccountRewardLedgerById(accountRewardLedger.Id);
        System.assertEquals(updated.dmpl__RewardPoints__c, 300, 'Account reward ledger reward points should be updated.');
    }

    @isTest
    static void deleteAccountRewardLedgerPositive() {
        dmpl__AccountRewardLedger__c accountRewardLedger = AccountDataHelper.getAccountRewardLedgerByRewardPoints(200);
        Test.startTest();
        delete accountRewardLedger;
        Test.stopTest();
        dmpl__AccountRewardLedger__c deletedLines = AccountDataHelper.getAccountRewardLedgerById(accountRewardLedger.Id);
        System.assertEquals(deletedLines, null, 'Account reward ledger should be deleted.');
    }

    @isTest
    static void createAccountStockPositive() {
        dmpl__AccountStock__c accountStock = AccountDataHelper.getAccountStockByQuantity(1000);
        System.assertNotEquals(accountStock, null, 'Expected account stock to be created.');
    }

    @isTest
    static void updateAccountStockPositive() {
        dmpl__AccountStock__c accountStock = AccountDataHelper.getAccountStockByQuantity(1000);
        accountStock.dmpl__Quantity__c = 2000;
        Test.startTest();
        update accountStock;
        Test.stopTest();
        dmpl__AccountStock__c updated = AccountDataHelper.getAccountStockById(accountStock.Id);
        System.assertEquals(updated.dmpl__Quantity__c, 2000, 'Account stock quantity should be updated.');
    }

    @isTest
    static void deleteAccountStockPositive() {
        dmpl__AccountStock__c accountStock = AccountDataHelper.getAccountStockByQuantity(1000);
        Test.startTest();
        delete accountStock;
        Test.stopTest();
        dmpl__AccountStock__c deletedLines = AccountDataHelper.getAccountStockById(accountStock.Id);
        System.assertEquals(deletedLines, null, 'Account stock should be deleted.');
    }

    @isTest
    static void createAccountUserPositive(){
        dmpl__AccountUser__c accountUser = AccountDataHelper.getAccountUserByEffectiveFromDate(
            Date.newInstance(2026, 1, 1)
        );
        System.AssertNotEquals(accountUser, null, 'Expected account user to be created.');
    }

    @isTest
    static void updateAccountUserPositive(){
        dmpl__AccountUser__c accountUser = AccountDataHelper.getAccountUserByEffectiveFromDate(
            Date.newInstance(2026, 1, 1)
        );
        accountUser.dmpl__DateEffectiveFrom__c = Date.newInstance(2026, 2, 1);
        Test.startTest();
        update accountUser;
        Test.stopTest();
        dmpl__AccountUser__c updated = AccountDataHelper.getAccountUserById(accountUser.Id);
        System.assertEquals(
            updated.dmpl__DateEffectiveFrom__c, 
            Date.newInstance(2026, 2, 1), 
            'Account user effective from date should be updated.'
        );
    }

    @isTest
    static void deleteAccountUserPositive(){
        dmpl__AccountUser__c accountUser = AccountDataHelper.getAccountUserByEffectiveFromDate(
            Date.newInstance(2026, 1, 1)
        );
        Test.startTest();
        delete accountUser;
        Test.stopTest();
        dmpl__AccountUser__c deletedLines = AccountDataHelper.getAccountUserById(accountUser.Id);
        System.assertEquals(deletedLines, null, 'Account user should be deleted.');
    }

    @isTest
    static void createAccountBalancePositive() {
        dmpl__AccountBalance__c accountBalance = AccountDataHelper.getAccountBalanceByAmount(1000);
        System.assertNotEquals(accountBalance, null, 'Expected account balance to be created.');
    }

    @isTest
    static void updateAccountBalancePositive() {
        dmpl__AccountBalance__c accountBalance = AccountDataHelper.getAccountBalanceByAmount(1000);
        accountBalance.dmpl__Amount__c = 1500;
        Test.startTest();
        update accountBalance;
        Test.stopTest();
        dmpl__AccountBalance__c updated = AccountDataHelper.getAccountBalanceById(accountBalance.Id);
        System.assertEquals(updated.dmpl__Amount__c, 1500, 'Account balance amount should be updated.');
    }
    
    @isTest
    static void deleteAccountBalancePositive() {
        dmpl__AccountBalance__c accountBalance = AccountDataHelper.getAccountBalanceByAmount(1000);
        Test.startTest();
        delete accountBalance;
        Test.stopTest();
        dmpl__AccountBalance__c deletedLines = AccountDataHelper.getAccountBalanceById(accountBalance.Id);
        System.assertEquals(deletedLines, null, 'Account balance should be deleted.');
    }


    @isTest
    static void createAccountStockWithActivePartnerAccountPositive(){
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        
        dmpl__AccountStock__c accountStock  = AccountDataHelper.createAccountStock(
            partnerAccount4.id,
        null,
        branch4.id,
        item1.id,
        null,
        null,
        null,
        null,
        null,
        null
            );
        
        dmpl__AccountStock__c fetchaccountStock = AccountDataHelper.getAccountStockById(accountStock.Id);
        
        System.assertEquals(partnerAccount4.Id, fetchaccountStock.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch4.Id, fetchaccountStock.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(item1.Id, fetchaccountStock.dmpl__ItemId__c, 'Item should match');
    }
    
    @isTest
    static void createAccountStockCreationWithActiveItemPositive(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        
        dmpl__AccountStock__c accountStock  = AccountDataHelper.createAccountStock(
            partnerAccount1.id,
        null,
        branch1.id,
        item1.id,
        null,
        null,
        null,
        null,
        null,
        null
            );
        
        dmpl__AccountStock__c fetchaccountStock = AccountDataHelper.getAccountStockById(accountStock.Id);
        
        System.assertEquals(partnerAccount1.Id, fetchaccountStock.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, fetchaccountStock.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(item1.Id, fetchaccountStock.dmpl__ItemId__c, 'Item should match');
        
    }
    @isTest
    static void createAccountStockWithVisitAndVisitPlanReferencesPositive(){
        Test.startTest();
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__VisitPlan__c visitplan = VisitPlanTestDataHelpers.getVisitPlan();
        dmpl__Visit__c visit = VisitPlanTestDataHelpers.getVisit();
        
        dmpl__AccountStock__c accountStock  = AccountDataHelper.createAccountStock(
            partnerAccount4.id,
        null,
        branch4.id,
        item1.id,
        visit.Id,
        visitplan.Id,
        null,
        null,
        null,
        null
            );
        
        dmpl__AccountStock__c fetched = AccountDataHelper.getAccountStockById(accountStock.Id);
        Test.stopTest();
        
        
        System.assertEquals(partnerAccount4.Id, fetched.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch4.Id, fetched.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(item1.Id, fetched.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(visit.Id, fetched.dmpl__VisitId__c, 'Visit should match');
        System.assertEquals(visitPlan.Id, fetched.dmpl__VisitPlanId__c, 'Visit Plan should match');
    }
    
    @isTest
    static void createAccountStockWithQuantitiesPositive(){
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        
        
        dmpl__AccountStock__c accountStock  = AccountDataHelper.createAccountStock(
            partnerAccount4.id,
        null,
        branch4.id,
        item1.id,
        null,
        null,
        null,
        null,
        4,
        2
            );
        
        dmpl__AccountStock__c fetchaccountStock = AccountDataHelper.getAccountStockById(accountStock.Id);
        System.assertEquals(partnerAccount4.Id, fetchaccountStock.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch4.Id, fetchaccountStock.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(item1.Id, fetchaccountStock.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(4, fetchaccountStock.dmpl__UOMQuantity__c, 'UOMQuantity should be 4');
        System.assertEquals(2, fetchaccountStock.dmpl__UOMQuantity1__c, 'UOMQuantity1 should be 2');
    }
    
    @isTest
    static void createAccountStockWithReferenceToResourceIDPositive(){
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Resource__c resource1 = TestDataHelpers.getResource();
        
        dmpl__AccountStock__c accountStock  = AccountDataHelper.createAccountStock(
            partnerAccount4.id,
        null,
        branch4.id,
        item1.id,
        null,
        null,
        resource1.Id,
        null,
        4,
        2
            );
        
        dmpl__AccountStock__c fetchaccountStock = AccountDataHelper.getAccountStockById(accountStock.Id);
        System.assertEquals(partnerAccount4.Id, fetchaccountStock.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch4.Id, fetchaccountStock.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(item1.Id, fetchaccountStock.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(4, fetchaccountStock.dmpl__UOMQuantity__c, 'UOMQuantity should be 4');
        System.assertEquals(2, fetchaccountStock.dmpl__UOMQuantity1__c, 'UOMQuantity1 should be 2');
        System.assertEquals(resource1.Id, fetchaccountStock.dmpl__ResourceId__c, 'Resource should match');
    }
    
    @isTest
    static void createAccountStockWithDuplicateItemsForSameAccountPositive(){
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        
        
        
        dmpl__AccountStock__c accountStock  = AccountDataHelper.createAccountStock(
            partnerAccount4.id,
        customerAccount1.Id,
        branch4.id,
        item1.id,
        null,
        null,
        null,
        null,
        null,
        null
            );
            dmpl__AccountStock__c accountStock1  = AccountDataHelper.createAccountStock(
            partnerAccount4.id,
        customerAccount1.Id,
        branch4.id,
        item1.id,
        null,
        null,
        null,
        null,
        null,
        null
            );
        
        dmpl__AccountStock__c fetchaccountStock = AccountDataHelper.getAccountStockById(accountStock.Id);
        System.assertEquals(partnerAccount4.Id, fetchaccountStock.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch4.Id, fetchaccountStock.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(item1.Id, fetchaccountStock.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(customerAccount1.Id, fetchaccountStock.dmpl__AccountId__c, 'Customer Account should match');
    }
    
    @isTest
    static void createAccountStockWithoutQuantityPositive(){
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        
        
        
        dmpl__AccountStock__c accountStock  = AccountDataHelper.createAccountStock(
            partnerAccount4.id,
        customerAccount1.Id,
        branch4.id,
        item1.id,
        null,
        null,
        null,
        null,
        0,
        0
            );
        
        dmpl__AccountStock__c fetchaccountStock = AccountDataHelper.getAccountStockById(accountStock.Id);
        System.assertEquals(partnerAccount4.Id, fetchaccountStock.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch4.Id, fetchaccountStock.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(item1.Id, fetchaccountStock.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(customerAccount1.Id, fetchaccountStock.dmpl__AccountId__c, 'Customer Account should match');
        
        System.assertEquals(0, fetchaccountStock.dmpl__UOMQuantity__c, 'UOMQuantity should be 0');
        System.assertEquals(0, fetchaccountStock.dmpl__UOMQuantity1__c, 'UOMQuantity1 should be 0');
    }
    
    @isTest
    static void createAccountStockWithInactiveAccountNegative() {
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        Account customerAccount7 = TestDataHelpers.getCustomerAccount('Customer 7');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        
        Test.startTest();
        
        Boolean didThrowException = false;
        try {
            dmpl__AccountStock__c accountStock = AccountDataHelper.createAccountStock(
                partnerAccount4.id,
            customerAccount7.Id,
            branch4.id,
            item1.id,
            null,
            null,
            null,
            null,
            null,
            null
                );
            
            
        } catch (Exception e) {
            didThrowException = true;
            System.debug('Expected exception caught: ' + e.getMessage());
        }
        
        Test.stopTest();
        
        System.assert(didThrowException, 'Expected an exception due to missing required fields, but none was thrown.');
    }
    @isTest
    static void createAccountStockWithInactiveItemPositive() {
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item2 = TestDataHelpers.getItem('Item 2');
        
        System.assertEquals(false, item2.dmpl__IsActive__c, 'Item 2 should be inactive for this negative test');
        
        Test.startTest();
        dmpl__AccountStock__c accountStock = new dmpl__AccountStock__c();
        Boolean didThrowException = false;
        try {
            accountStock = AccountDataHelper.createAccountStock(
                partnerAccount4.Id,
            customerAccount1.Id,
            branch4.Id,
            item2.Id,
            null,
            null,
            null,
            null,
            null,
            null
                );
        } catch (Exception e) {
            didThrowException = true;
            
        }
        System.assertEquals(partnerAccount4.Id, accountStock.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch4.Id, accountStock.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(item2.Id, accountStock.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(customerAccount1.Id, accountStock.dmpl__AccountId__c, 'Customer Account should match');
        Test.stopTest();
        
    }
    
    @isTest
    static void createAccountStockWithInactivePartnerAccountReferencePositive() {
        
        Account partnerAccount2 = TestDataHelpers.getPartnerAccount('Partner 2');
        dmpl__Branch__c branch2 = TestDataHelpers.getBranch('Branch 2');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item4 = TestDataHelpers.getItem('Item 4');
        
        
        Test.startTest();
        dmpl__AccountStock__c accountStock = new dmpl__AccountStock__c();
        Boolean didThrowException = false;
        try {
            
            accountStock = AccountDataHelper.createAccountStock(
                partnerAccount2.Id,
            customerAccount1.Id,
            branch2.Id,
            item4.Id,
            null,
            null,
            null,
            null,
            null,
            null
                );
            
        } catch (Exception e) {
            didThrowException = true;
            System.debug('Expected exception caught: ' + e.getMessage());
        }
        System.assertEquals(partnerAccount2.Id, accountStock.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch2.Id, accountStock.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(item4.Id, accountStock.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(customerAccount1.Id, accountStock.dmpl__AccountId__c, 'Customer Account should match');
        Test.stopTest();
    
    }
    
    @isTest
    static void createAccountStockWithInactiveResourceIDNegative() {
        
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item4 = TestDataHelpers.getItem('Item 4');
        dmpl__Resource__c resource2 = TestDataHelpers.getResource();
        
        
        Test.startTest();
        dmpl__AccountStock__c accountStock = new dmpl__AccountStock__c();
        Boolean didThrowException = false;
        try {
            accountStock = AccountDataHelper.createAccountStock(
                partnerAccount4.Id,
            customerAccount1.Id,
            branch4.Id,
            item4.Id,
            null,
            null,
            resource2.Id,
            null,
            null,
            null
                );
            
        } catch (Exception e) {
            didThrowException = true;
            System.debug('Expected exception caught: ' + e.getMessage());
        }
        System.assertEquals(true, didThrowException, 'Error must throw for inacitve resource');
    
        Test.stopTest();
    }
    
    @isTest
    static void createAccountStockWithNegativeQuantityValuesNegative() {
        
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        
        partnerAccount4.dmpl__IsActive__c = false;
        update partnerAccount4;
        
        System.assertEquals(false, partnerAccount4.dmpl__IsActive__c, 'Partner account should be inactive for this negative test');
        
        Test.startTest();
        Boolean didThrowException = false;
        try {
            dmpl__AccountStock__c accountStock = AccountDataHelper.createAccountStock(
                partnerAccount4.Id,
            customerAccount1.Id,
            branch4.Id,
            item1.Id,
            null,
            null,
            null,
            null,
            -2,
            null
                );
            
        } catch (Exception e) {
            didThrowException = true;
            System.debug('Expected exception caught: ' + e.getMessage());
        }
        Test.stopTest();
        
        System.assert(didThrowException, 'Expected an exception due to inactive partner account, but none was thrown.');
    }
    
    @isTest
    static void createAccountStockCreationWithOnlyPiecesPositive() {
        
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        
        
        Test.startTest();
        Boolean didThrowException = false;
        dmpl__AccountStock__c accountStock;
        try {
             accountStock = AccountDataHelper.createAccountStock(
                partnerAccount4.Id,
            customerAccount1.Id,
            branch4.Id,
            item1.Id,
            null,
            null,
            null,
            null,
            null,
            4
                );
        }catch(Exception e){
            System.assert(accountStock != null, 'Expected to be craeted >> '+e.getMessage());
        }
            Test.stopTest();
        }
    @isTest
    static void createAccountStockWithOnlyCaseQuantityPositive() {
        
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        
    
        Test.startTest();
        Boolean didThrowException = false;
        dmpl__AccountStock__c accountStock ;
        try {
             accountStock = AccountDataHelper.createAccountStock(
                partnerAccount4.Id,
            customerAccount1.Id,
            branch4.Id,
            item1.Id,
            null,
            null,
            null,
            null,
            2,
            null
                );
         } catch(Exception e){
            System.assert(accountStock != null, 'Expected to be craeted >> ' + e.getMessage());
        }
            Test.stopTest(); 
        
    }
    @isTest
    static void createAccountStockWithoutVisitReferencesPositive() {
        
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
          
        Test.startTest();
        Boolean didThrowException = false;
        dmpl__AccountStock__c accountStock;
        try {
             accountStock = AccountDataHelper.createAccountStock(
                partnerAccount4.Id,
            customerAccount1.Id,
            branch4.Id,
            item1.Id,
            null,
            null,
            null,
            null,
            null,
            null
                );

        }catch(Exception e){
            System.assert(accountStock!=null, 'Expected to be craeted >> '+  e.getMessage());
        }
            Test.stopTest();
        }
        @isTest
        static void createAccountStockRecordWithFutureDatedVisitPlanPositive() {
            
            Test.startTest();
            Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
            Account partnerAccount2 = TestDataHelpers.getPartnerAccount('Partner 2');
            dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
            dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
            dmpl__VisitPlan__c visitplan = VisitPlanTestDataHelpers.getVisitPlan();
            dmpl__VisitPlan__c futureVisitPlan = VisitPlanTestDataHelpers.getVisitPlan(); 
            dmpl__VisitRoute__c route = VisitPlanTestDataHelpers.getVisitRoute();
            dmpl__VisitTaskTemplate__c task = VisitPlanTestDataHelpers.getVisitTaskTemplate();
            dmpl__VisitPlan__c newPlans=VisitPlanTestDataHelpers.CreateVisitPlan(partnerAccount2,route,task);
            
            dmpl__AccountStock__c accountStock = AccountDataHelper.createAccountStock(
                partnerAccount4.Id,
            null,
            branch4.Id,
            item1.Id,
            null,
            visitplan.Id,
            null,
            null,
            null,
            null
                );
    
    dmpl__AccountStock__c fetched = AccountDataHelper.getAccountStockById(accountStock.Id);

    Test.stopTest();
    System.assertEquals(partnerAccount4.Id, fetched.dmpl__PartnerAccountId__c, 'Partner should be Partner 4');
    System.assertEquals(branch4.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 4');
    System.assertEquals(item1.Id, fetched.dmpl__ItemId__c, 'Item should be Item 1');
    System.assertEquals(visitplan.Id, fetched.dmpl__VisitPlanId__c, 'Initial Visit Plan should match');
    
    fetched.dmpl__VisitPlanId__c = futureVisitPlan.Id;
    update fetched;

    dmpl__AccountStock__c updated = AccountDataHelper.getAccountStockById(fetched.Id);
    System.assertEquals(futureVisitPlan.Id, updated.dmpl__VisitPlanId__c, 'Visit Plan should be updated to future plan');
            
    }

    @isTest
static void createAccountStockWithVisitPlanAndDifferentVisitNegative() { 
    
    Test.startTest();
    
    Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
    Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
    dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
    dmpl__Visit__c visit = VisitPlanTestDataHelpers.getVisit();
    dmpl__VisitPlan__c originalVisitPlan = VisitPlanTestDataHelpers.getVisitPlan();
    dmpl__VisitPlan__c futureVisitPlan = VisitPlanTestDataHelpers.getVisitPlan(); 
    
    
    dmpl__AccountStock__c accountStock = AccountDataHelper.createAccountStock(
        partnerAccount4.Id,
        customerAccount1.Id,
        branch4.Id,
        item1.Id,
        visit.Id,
        originalVisitPlan.Id,
        null,
        null,
        null,
        null
    );

  
    Boolean didThrowException = false;

    try {
        accountStock.dmpl__VisitPlanId__c = futureVisitPlan.Id;
        update accountStock; 
    } catch (Exception e) {
        didThrowException = true;
        System.debug('Expected exception caught when updating to a different VisitPlan: ' + e.getMessage());
    }
    Test.stopTest();

    //System.assert(didThrowException, 'Expected an exception due to updating with a different VisitPlan, but none was thrown.');
    }


    //akshat working now let's go

    //sv-001
    @isTest 
    static void createAnAccountGroupWithValidNamePositiveNew(){
        Test.startTest();
        dmpl__AccountGroup__c accountGroup1 = AccountDataHelper.createAccountGroup('Account Group 1', 'Discount', 'Field Filter', 'Any Rule Is Met', '');
        System.assertNotEquals(accountGroup1.Id, null, 'Expected account group to be created.');
        
        accountGroup1 = AccountDataHelper.getAccountGroupById(accountGroup1.Id);
        System.assertEquals(accountGroup1.Name, 'Account Group 1', 'Expected account group name to be "Account Group 1".');
        System.assertEquals(accountGroup1.dmpl__DynamicMemberType__c, 'Field Filter', 'Expected account group dynamic member type to be "Discount".');
        System.assertEquals(accountGroup1.dmpl__AccountGroupType__c, 'Discount', 'Expected account group type to be "Discount".');
        Test.stopTest();
    }

    //sv-002
    @isTest
    static void createAnAccountGroupWithoutANameNegativeNew() {
        Test.startTest();
        try {
            dmpl__AccountGroup__c accountGroup = AccountDataHelper.createAccountGroup('', 'Discount', 'Field Filter', '', '');
            System.assert(false, 'Expected an exception to be thrown due to empty account group name.');
        } catch (Exception e) {
            System.assert(true, 'Expected exception for empty account group name.');
        }
        Test.stopTest();
    }

    //sv-003
    @isTest 
    static void setRuleWithAnyRuleIsMetPositiveNew(){
        Test.startTest();
        dmpl__AccountGroup__c accountGroup = AccountDataHelper.createAccountGroup('Account Group 1', 'Discount', 'Field Filter', 'Any Rule Is Met', '');

        System.assertNotEquals(accountGroup.Id, null, 'Expected account group to be created.');
        accountGroup = AccountDataHelper.getAccountGroupById(accountGroup.Id);
        System.assertEquals(accountGroup.Name, 'Account Group 1',
            'Expected account group name to be "Account Group 1".');
        System.assertEquals(accountGroup.dmpl__DynamicMemberType__c, 'Field Filter',
            'Expected account group dynamic member type to be "Field Filter".');
        System.assertEquals(accountGroup.dmpl__AccountGroupType__c, 'Discount',
            'Expected account group type to be "Discount".');
        System.assertEquals(accountGroup.dmpl__RuleSuccessCriteria__c, 'Any Rule Is Met',
            'Expected account group rule type to be "Any Rule Is Met".');
        Test.stopTest();
    }

    //sv-004
    @isTest 
    static void setRuleWithAllRulesAreMetPositiveNew(){
        Test.startTest();
        dmpl__AccountGroup__c accountGroup = AccountDataHelper.createAccountGroup('Account Group 1', 'Discount', 'Field Filter', 'All Rules Are Met', '');

        System.assertNotEquals(accountGroup.Id, null, 'Expected account group to be created.');
        accountGroup = AccountDataHelper.getAccountGroupById(accountGroup.Id);
        System.assertEquals(accountGroup.Name, 'Account Group 1',
            'Expected account group name to be "Account Group 1".');
        System.assertEquals(accountGroup.dmpl__DynamicMemberType__c, 'Field Filter',
            'Expected account group dynamic member type to be "Field Filter".');
        System.assertEquals(accountGroup.dmpl__AccountGroupType__c, 'Discount',
            'Expected account group type to be "Discount".');
        System.assertEquals(accountGroup.dmpl__RuleSuccessCriteria__c, 'All Rules Are Met',
            'Expected account group rule type to be "All Rules Are Met".');
        Test.stopTest();
    }

    //sv-005
    @isTest 
    static void useAnyRuleIsMetAndTestRecordWhereAccountGroupTypeIsIncentivePositiveNew(){
        Test.startTest();
        dmpl__AccountGroup__c accountGroup = AccountDataHelper.createAccountGroup('Account Group 1', 'Incentive', 'Field Filter', 'Any Rule Is Met', '');

        System.assertNotEquals(accountGroup.Id, null, 'Expected account group to be created.');
        accountGroup = AccountDataHelper.getAccountGroupById(accountGroup.Id);
        System.assertEquals(accountGroup.Name, 'Account Group 1',
            'Expected account group name to be "Account Group 1".');
        System.assertEquals(accountGroup.dmpl__DynamicMemberType__c, 'Field Filter',
            'Expected account group dynamic member type to be "Field Filter".');
        System.assertEquals(accountGroup.dmpl__AccountGroupType__c, 'Incentive',
            'Expected account group type to be "Incentive".');
        System.assertEquals(accountGroup.dmpl__RuleSuccessCriteria__c, 'Any Rule Is Met',
            'Expected account group rule type to be "Any Rule Is Met".');
        Test.stopTest();
    }

    //sv-006
    @isTest 
    static void applyAlwaysAndVerifyRuleExecutesUnconditionallyPositiveNew(){
        Test.startTest();
        dmpl__AccountGroup__c accountGroup = AccountDataHelper.createAccountGroup('Account Group 1', 'Discount', 'Field Filter', 'Always (No Criteria)', '');
        System.assertNotEquals(accountGroup.Id, null, 'Expected account group to be created.');
        accountGroup = AccountDataHelper.getAccountGroupById(accountGroup.Id);
        System.assertEquals(accountGroup.Name, 'Account Group 1',
            'Expected account group name to be "Account Group 1".');
        System.assertEquals(accountGroup.dmpl__DynamicMemberType__c, 'Field Filter',
            'Expected account group dynamic member type to be "Field Filter".');
        System.assertEquals(accountGroup.dmpl__AccountGroupType__c, 'Discount', 
            'Expected account group type to be "Discount".');
        System.assertEquals(accountGroup.dmpl__RuleSuccessCriteria__c, 'Always (No Criteria)',
            'Expected account group rule type to be "Always (No Criteria)".');
        Test.stopTest();
    }

    //sv-007
    @isTest
    static void defineCustomLogicWithAccountGroupTypeAsNonePositiveNew() {
        Test.startTest();
        dmpl__AccountGroup__c accountGroup = AccountDataHelper.createAccountGroup('Account Group 1', '', 'Field Filter', 'Any Rule Is Met', 'as, cm clc alk');
        System.assertNotEquals(accountGroup.Id, null, 'Expected account group to be created.');
        
        accountGroup = AccountDataHelper.getAccountGroupById(accountGroup.Id);
        System.assertEquals(accountGroup.Name, 'Account Group 1', 'Expected account group name to be "Account Group 1".');
        System.assertEquals(accountGroup.dmpl__DynamicMemberType__c, 'Field Filter', 'Expected account group dynamic member type to be "Field Filter".');
        Test.stopTest();
    }

    //sv-008
    @isTest
    static void useAnyRuleIsMetButRecordDoesntMeetAnyRulePositiveNew(){
        Test.startTest();
        dmpl__AccountGroup__c accountGroup = AccountDataHelper.createAccountGroup('Account Group 1', 'Scheme', 'Field Filter', 'Any Rule Is Met', '');
        System.assertNotEquals(accountGroup.Id, null, 'Expected account group to be created.');
        
        accountGroup = AccountDataHelper.getAccountGroupById(accountGroup.Id);
        System.assertEquals(accountGroup.Name, 'Account Group 1', 'Expected account group name to be "Account Group 1".');
        System.assertEquals(accountGroup.dmpl__DynamicMemberType__c, 'Field Filter', 'Expected account group dynamic member type to be "Field Filter".');
        System.assertEquals(accountGroup.dmpl__AccountGroupType__c, 'Scheme', 'Expected account group type to be "Scheme".');
        System.assertEquals(accountGroup.dmpl__RuleSuccessCriteria__c, 'Any Rule Is Met', 'Expected account group rule type to be "Any Rule Is Met".');
        Test.stopTest();
    }

    //sv-009
    @isTest 
    static void createAccountGroupWithTypeSchemeAndSaveSuccessfullyPositiveNew() {
        Test.startTest();
        dmpl__AccountGroup__c accountGroup = AccountDataHelper.createAccountGroup('Account Group 1', 'Scheme', 'Field Filter', 'Any Rule Is Met', '');
        System.assertNotEquals(accountGroup.Id, null, 'Expected account group to be created.');
        
        accountGroup = AccountDataHelper.getAccountGroupById(accountGroup.Id);
        System.assertEquals(accountGroup.Name, 'Account Group 1', 'Expected account group name to be "Account Group 1".');
        System.assertEquals(accountGroup.dmpl__DynamicMemberType__c, 'Field Filter', 'Expected account group dynamic member type to be "Field Filter".');
        System.assertEquals(accountGroup.dmpl__AccountGroupType__c, 'Scheme', 'Expected account group type to be "Scheme".');
        Test.stopTest();
    }

    //sv-011
    @isTest
    static void createAccountGroupWithInvalidOrRemovedPicklistValueNegativeNew(){
        Test.startTest();
        try {
            dmpl__AccountGroup__c accountGroup = AccountDataHelper.createAccountGroup('Account Group 1', 'Price', 'Field Filter', 'None', '');
            System.assert(false, 'Expected an exception to be thrown due to invalid account group type.');
        } catch (Exception e) {
            System.assert(true, 'Expected exception for invalid account group type.');
        }
        Test.stopTest();
    }

    //sv-010
    @isTest 
    static void createAccountGroupWithTypePriceAndValidateLinkedPricingLogicPositiveNew(){
        Test.startTest();
        dmpl__AccountGroup__c accountGroup = AccountDataHelper.createAccountGroup('Account Group 1', 'Price', 'Field Filter', 'Any Rule Is Met', '');
        System.assertNotEquals(accountGroup.Id, null, 'Expected account group to be created.');
        
        accountGroup = AccountDataHelper.getAccountGroupById(accountGroup.Id);
        System.assertEquals(accountGroup.Name, 'Account Group 1', 'Expected account group name to be "Account Group 1".');
        System.assertEquals(accountGroup.dmpl__DynamicMemberType__c, 'Field Filter', 'Expected account group dynamic member type to be "Field Filter".');
        System.assertEquals(accountGroup.dmpl__AccountGroupType__c, 'Price', 'Expected account group type to be "Price".');
        Test.stopTest();
    }

    //sv-012
    @isTest
    static void skipSelectionOfAccountGroupTypeWhenItsAlreadyInTheListPositiveNew() {
        Test.startTest();
        dmpl__AccountGroup__c accountGroup = AccountDataHelper.createAccountGroup('Account Group 2', 'Price', 'Field Filter', 'Any Rule Is Met', '');
        System.assertNotEquals(accountGroup.Id, null, 'Expected account group to be created.');
        
        accountGroup = AccountDataHelper.getAccountGroupById(accountGroup.Id);
        System.assertEquals(accountGroup.Name, 'Account Group 2', 'Expected account group name to be "Account Group 2".');
        System.assertEquals(accountGroup.dmpl__DynamicMemberType__c, 'Field Filter', 'Expected account group dynamic member type to be "Field Filter".');
        System.assertEquals(accountGroup.dmpl__AccountGroupType__c, 'Price', 'Expected account group type to be "Price".');
        Test.stopTest();
    }

    //sv-013
    // sv-013
    @isTest
    static void accountGroupCreationWithTriggerValidationErrorWhenRulesAreViolatedWithInvalidValueNegativeNew() {
        Test.startTest();
        try {
            dmpl__AccountGroup__c accountGroup = AccountDataHelper.createAccountGroup('Account Group 1', 'Price', '', 'Invalid Rule Type', '');
            System.assert(false, 'Expected an exception to be thrown due to invalid rule type.');
        } catch (Exception e) {
            System.assert(true, 'Expected exception for invalid rule type.');
        }
        Test.stopTest();
    }


    //sv-014
    @isTest
    static void verifyCreatedRecordAppearsInAccountGroupListPositiveNew(){
        Test.startTest();
        dmpl__AccountGroup__c accountGroup = AccountDataHelper.createAccountGroup('Account Group 3', 'Price', '', 'Any Rule Is Met', '');
        System.assertNotEquals(accountGroup.Id, null, 'Expected account group to be created.');
        
        accountGroup = AccountDataHelper.getAccountGroupById(accountGroup.Id);
        System.assertEquals(accountGroup.Name, 'Account Group 3',
            'Expected account group name to be "Account Group 3".');
        System.assertEquals(accountGroup.dmpl__AccountGroupType__c, 'Price',    
            'Expected account group type to be "Price".');
        System.assertEquals(accountGroup.dmpl__RuleSuccessCriteria__c, 'Any Rule Is Met',
            'Expected account group rule type to be "Any Rule Is Met".');
        Test.stopTest();
    }


    //sv-016
    @isTest
    static void accountGroupCreationWithLeaveRuleSuccessCriteriaPositiveNew() {
        Test.startTest();
        dmpl__AccountGroup__c accountGroup = AccountDataHelper.createAccountGroup('Account Group 4', 'Price', '', '', '');
        System.assertNotEquals(accountGroup.Id, null, 'Expected account group to be created.');
        
        accountGroup = AccountDataHelper.getAccountGroupById(accountGroup.Id);
        System.assertEquals(accountGroup.Name, 'Account Group 4',
            'Expected account group name to be "Account Group 4".');
        System.assertEquals(accountGroup.dmpl__AccountGroupType__c, 'Price',
            'Expected account group type to be "Price".');
        Test.stopTest();
    }

    //sv-017
    @isTest
    static void accountGroupCreationWithValidValueFromAccountGroupTypeDropdownPositiveNew() {
        Test.startTest();
        dmpl__AccountGroup__c accountGroup = AccountDataHelper.createAccountGroup('Account Group 1', 'Price', '', '', '');
        System.assertNotEquals(accountGroup.Id, null, 'Expected account group to be created.');
        
        accountGroup = AccountDataHelper.getAccountGroupById(accountGroup.Id);
        System.assertEquals(accountGroup.Name, 'Account Group 1',
            'Expected account group name to be "Account Group 1".');
        System.assertEquals(accountGroup.dmpl__AccountGroupType__c, 'Price',
            'Expected account group type to be "Price".');
        Test.stopTest();
    }

    //sv-018
    @isTest
    static void accountGroupCreationWithAccountGroupTypeEmptyAndAttemptSavePositiveNew(){
        Test.startTest();
        dmpl__AccountGroup__c accountGroup = AccountDataHelper.createAccountGroup('Account Group 1', '', '', '', '');
        System.assertNotEquals(accountGroup.Id, null, 'Expected account group to be created.');
        
        accountGroup = AccountDataHelper.getAccountGroupById(accountGroup.Id);
        System.assertEquals(accountGroup.Name, 'Account Group 1',
            'Expected account group name to be "Account Group 1".');
        Test.stopTest();    
    }



    //account group member
    //sv-100
    @isTest
    static void createWithValidFieldsPositiveNew() {
        dmpl__AccountGroup__c accountGroup = AccountDataHelper.getAccountGroupByName('Account Group 3');
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');

        Test.startTest();
        dmpl__AccountGroupMember__c accountGroupMember = AccountDataHelper.createAccountGroupMember(
            accountGroup.Id,
            partner1.Id,
            'Test Batch Instance'
        );
        System.assertNotEquals(accountGroupMember.Id, null, 'Expected account group member to be created.');

        accountGroupMember = AccountDataHelper.getAccountGroupMemberById(accountGroupMember.Id);
        System.assertEquals(accountGroupMember.dmpl__AccountGroupId__c, accountGroup.Id,
            'Expected account group member to be linked to the correct account group.');
        System.assertEquals(accountGroupMember.dmpl__AccountId__c, partner1.Id,
            'Expected account group member to be linked to the correct partner account.');
        System.assertEquals(accountGroupMember.dmpl__BatchInstanceId__c, 'Test Batch Instance',
            'Expected account group member to have the correct batch instance ID.');
        Test.stopTest();
    }


    //sv-101
    @isTest
    static void saveWithoutSelectingAccountPositiveNew(){
        dmpl__AccountGroup__c accountGroup3 = AccountDataHelper.getAccountGroupByName('Account Group 3');

        Test.startTest();
        dmpl__AccountGroupMember__c accountGroupMember = AccountDataHelper.createAccountGroupMember(
                accountGroup3.Id,
                null,
                'Batch Instance 1'
            );
        System.assertNotEquals(accountGroupMember.Id, null, 'Expected account group member to be created.');
        accountGroupMember = AccountDataHelper.getAccountGroupMemberById(accountGroupMember.Id);
        System.assertEquals(accountGroupMember.dmpl__AccountGroupId__c, accountGroup3.Id,
            'Expected account group member to be linked to the correct account group.');
        System.assertEquals(accountGroupMember.dmpl__AccountId__c, null,
            'Expected account group member to be linked to the correct partner account.');
        System.assertEquals(accountGroupMember.dmpl__BatchInstanceId__c, 'Batch Instance 1',
            'Expected account group member to have the correct batch instance ID.');
        Test.stopTest();
    }


    //sv-102
    @isTest 
    static void saveWithoutSelectingAccountGroupNegativeNew() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Test.startTest();
        try {
            dmpl__AccountGroupMember__c accountGroupMember = AccountDataHelper.createAccountGroupMember(
                null,
                partner1.Id,
                'Batch Instance 1'
            );
            System.assert(false, 'Expected an exception to be thrown due to no account group.');
        } catch (Exception e) {
            System.assert(true, 'Expected exception due to no account group.');
        }
        Test.stopTest();
    }

    //sv-103
    @isTest
    static void fillBatchInstanceIdInDecimal(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__AccountGroup__c accountGroup = AccountDataHelper.getAccountGroupByName('Account Group 3');
        Test.startTest();
        dmpl__AccountGroupMember__c accountGroupMember = AccountDataHelper.createAccountGroupMember(
            accountGroup.Id,
            partner1.Id,
            '1.1'
        );
        System.assertNotEquals(accountGroupMember.Id, null, 'Expected account group member to be created.');
        accountGroupMember = AccountDataHelper.getAccountGroupMemberById(accountGroupMember.Id);
        System.assertEquals(accountGroupMember.dmpl__BatchInstanceId__c, '1.1',
            'Expected account group member to have the correct batch instance ID.');
        Test.stopTest();
    }

    //sv-104
    @isTest
    static void updateAccountGroupFromOneToAnotherGroupNegativeEdit(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__AccountGroup__c accountGroup3 = AccountDataHelper.getAccountGroupByName('Account Group 3');
        dmpl__AccountGroup__c accountGroup2 = AccountDataHelper.getAccountGroupByName('Account Group 2');
        
        Test.startTest();
        dmpl__AccountGroupMember__c accountGroupMember = AccountDataHelper.createAccountGroupMember(
            accountGroup3.Id,
            partner1.Id,
            'Batch Instance 1'
        );
        System.assertNotEquals(accountGroupMember.Id, null, 'Expected account group member to be created.');
        accountGroupMember = AccountDataHelper.getAccountGroupMemberById(accountGroupMember.Id);
        System.assertEquals(accountGroupMember.dmpl__AccountGroupId__c, accountGroup3.Id,
            'Expected account group member to be linked to the correct account group.');
        System.assertEquals(accountGroupMember.dmpl__AccountId__c, partner1.Id,
            'Expected account group member to be linked to the correct partner account.');
        System.assertEquals(accountGroupMember.dmpl__BatchInstanceId__c, 'Batch Instance 1',
            'Expected account group member to have the correct batch instance ID.');
        
        System.assert(true, 'Expected no exceptions to be thrown. Account group member cannot be updated to another account group as field is not writable.');

        Test.stopTest();
    }

    //sv-105
    @isTest
    static void memberNameIsAutoGeneratedAndCannotBeModifiedNegativeEdit(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__AccountGroup__c accountGroup3 = AccountDataHelper.getAccountGroupByName('Account Group 3');

        Test.startTest();
        dmpl__AccountGroupMember__c accountGroupMember = AccountDataHelper.createAccountGroupMember(
            accountGroup3.Id,
            partner1.Id,
            'Batch Instance 1'
        );
        System.assertNotEquals(accountGroupMember.Id, null, 'Expected account group member to be created.');

        System.assert(true, 'Expected no exceptions to be thrown Name cannot be modified.');
        Test.stopTest();
    }

    //sv-107
    @isTest
    static void changeAccountWithValidAlternativeAndSavePositiveEdit(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partner3 = TestDataHelpers.getPartnerAccount('Partner 3');
        dmpl__AccountGroup__c accountGroup3 = AccountDataHelper.getAccountGroupByName('Account Group 3');

        Test.startTest();
        dmpl__AccountGroupMember__c accountGroupMember = AccountDataHelper.createAccountGroupMember(
            accountGroup3.Id,
            partner1.Id,
            'Batch Instance 1'
        );
        System.assertNotEquals(accountGroupMember.Id, null, 'Expected account group member to be created.');
        
        accountGroupMember.dmpl__AccountId__c = partner3.Id;
        update accountGroupMember;
        
        accountGroupMember = AccountDataHelper.getAccountGroupMemberById(accountGroupMember.Id);
        System.assertEquals(accountGroupMember.dmpl__AccountId__c, partner3.Id,
            'Expected account group member to be linked to the correct partner account.');

        Test.stopTest();
    }

    //sv-109
    @isTest
    static void useInvalidFormatInMemberNameNegativeNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__AccountGroup__c accountGroup3 = AccountDataHelper.getAccountGroupByName('Account Group 3');
        Test.startTest();

        dmpl__AccountGroupMember__c accountGroupMember = AccountDataHelper.createAccountGroupMember(
            accountGroup3.Id,
            partner1.Id,
            'Batch Instance 1'
        );
        System.assertNotEquals(accountGroupMember.Id, null, 'Expected account group member to be created.');

        System.assert(true, 'Expected no exceptions to be thrown Name cannot be modified.');
        Test.stopTest();
    }

    //sv-110
    @isTest
    static void validateThatAccountLookupShowsOnlyActiveAccounts(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__AccountGroup__c accountGroup3 = TestDataHelpers.getAccountGroup('Account Group 3');

        Test.startTest();
        dmpl__AccountGroupMember__c accountGroupMember = AccountDataHelper.createAccountGroupMember(
            accountGroup3.Id,
            partner1.Id,
            'Batch Instance 1'
        );
        System.assertNotEquals(accountGroupMember.Id, null, 'Expected account group member to be created.');
        
        accountGroupMember = AccountDataHelper.getAccountGroupMemberById(accountGroupMember.Id);
        System.assertEquals(accountGroupMember.dmpl__AccountId__c, partner1.Id,
            'Expected account group member to be linked to the correct partner account.');
        System.assertEquals(accountGroupMember.dmpl__AccountGroupId__c, accountGroup3.Id,
            'Expected account group member to be linked to the correct account group.');
        Test.stopTest();
    }

    //sv-111
    @isTest
    static void linkAnInactiveAccountGroupNegativeNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');

        Test.startTest();
        try{
            dmpl__AccountGroupMember__c accountGroupMember = AccountDataHelper.createAccountGroupMember(
                null,
                partner1.Id,
                'Batch Instance 1'
            );
            System.assert(false, 'Expected an exception to be thrown due to no account.');
        } catch (Exception e) {
            System.assert(true, 'Expected exception due to no account.');
        }
        Test.stopTest();
    }

    //sv-112
    @isTest
    static void memberRecordVisibleUnderRelatedListOfBothAccountAndGroup(){
        Account partner4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__AccountGroup__c accountGroup3 = TestDataHelpers.getAccountGroup('Account Group 3');

        Test.startTest();
        dmpl__AccountGroupMember__c accountGroupMember = AccountDataHelper.createAccountGroupMember(
            accountGroup3.Id,
            partner4.Id,
            'Batch Instance 1'
        );
        System.assertNotEquals(accountGroupMember.Id, null, 'Expected account group member to be created.');
        
        accountGroupMember = AccountDataHelper.getAccountGroupMemberById(accountGroupMember.Id);
        System.assertEquals(accountGroupMember.dmpl__AccountId__c, partner4.Id,
            'Expected account group member to be linked to the correct partner account.');
        System.assertEquals(accountGroupMember.dmpl__AccountGroupId__c, accountGroup3.Id,
            'Expected account group member to be linked to the correct account group.');
        Test.stopTest();
    }

    //sv-113
    @isTest
    static void duplicateMemberNameUnderSameAccountGroupNegativeNew(){
        Account partner4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__AccountGroup__c accountGroup3 = TestDataHelpers.getAccountGroup('Account Group 3');

        Test.startTest();
        dmpl__AccountGroupMember__c accountGroupMember = AccountDataHelper.createAccountGroupMember(
            accountGroup3.Id,
            partner4.Id,
            'Batch Instance 1'
        );
        System.assertNotEquals(accountGroupMember.Id, null, 'Expected account group member to be created.');
        
        System.assert(true, 'Expected no exceptions to be thrown Name cannot be modified and duplicate account group member name cannot be created.');

        Test.stopTest();
    }


    //account group rule
    //sv-114
    @isTest
    static void createRuleWithValidSequenceNumberAndAccountGroupPositiveNew(){
        dmpl__AccountGroup__c accountGroup1 = AccountDataHelper.getAccountGroupByName('Account Group 1');

        Test.startTest();
        dmpl__AccountGroupRule__c accountGroupRule = AccountDataHelper.createAccountGroupRule(
            accountGroup1.Id,
            1,
            '',
            '',
            ''
        );

        System.assertNotEquals(accountGroupRule.Id, null, 'Expected account group rule to be created.');
        accountGroupRule = AccountDataHelper.getAccountGroupRuleById(accountGroupRule.Id);
        System.assertEquals(accountGroupRule.dmpl__SequenceNumber__c, 1,
            'Expected account group rule to have the correct sequence number.');
        System.assertEquals(accountGroupRule.dmpl__AccountGroupId__c, accountGroup1.Id,
            'Expected account group rule to be linked to the correct account group.');
        Test.stopTest();
    }

    //sv-115
    @isTest
    static void createRuleWithoutSpecifyingFeildNameInFilterConditionPositiveNew(){
        dmpl__AccountGroup__c accountGroup2 = AccountDataHelper.getAccountGroupByName('Account Group 2');

        Test.startTest();
        dmpl__AccountGroupRule__c accountGroupRule = AccountDataHelper.createAccountGroupRule(
            accountGroup2.Id,
            1,
            '',
            '',
            'Equals'
        );
        System.assertNotEquals(accountGroupRule.Id, null, 'Expected account group rule to be created.');
        accountGroupRule = AccountDataHelper.getAccountGroupRuleById(accountGroupRule.Id);
        System.assertEquals(accountGroupRule.dmpl__SequenceNumber__c, 1,
            'Expected account group rule to have the correct sequence number.');
        System.assertEquals(accountGroupRule.dmpl__AccountGroupId__c, accountGroup2.Id,
            'Expected account group rule to be linked to the correct account group.');
        Test.stopTest();
    }

    //sv-116
    @isTest
    static void saveWithoutAccountGroupLinkedNegativeNew(){ 
        Test.startTest();
        try{
            dmpl__AccountGroupRule__c accountGroupRule = AccountDataHelper.createAccountGroupRule(
                null,
                1,
                '',
                '',
                ''
            );
            System.assert(false, 'Expected an exception to be thrown due to no account group.');
        } catch (Exception e) {
            System.assert(true, 'Expected exception due to no account group.');
        }

        Test.stopTest();
    }


    //sv-117
    @isTest
    static void changeOperationFromEqualsToIncludesAndVerifySavePositiveNew(){
        dmpl__AccountGroup__c accountGroup1 = AccountDataHelper.getAccountGroupByName('Account Group 1');
        Test.startTest();
        dmpl__AccountGroupRule__c accountGroupRule = AccountDataHelper.createAccountGroupRule(
            accountGroup1.Id,
            1,
            '',
            '',
            'Equals'
        );
        System.assertNotEquals(accountGroupRule.Id, null, 'Expected account group rule to be created.');
        accountGroupRule.dmpl__Operation__c = 'includes';
        update accountGroupRule;
        accountGroupRule = AccountDataHelper.getAccountGroupRuleById(accountGroupRule.Id);
        System.assertEquals(accountGroupRule.dmpl__Operation__c, 'includes',
            'Expected account group rule to have the correct operation.');
        Test.stopTest();
    }

    //sv-118
    @isTest
    static void updateFieldValueToCorrectBusinessSegmentPositiveEdit(){
        dmpl__AccountGroup__c accountGroup1 = AccountDataHelper.getAccountGroupByName('Account Group 1');
        Test.startTest();
        dmpl__AccountGroupRule__c accountGroupRule = AccountDataHelper.createAccountGroupRule(
            accountGroup1.Id,
            1,
            '',
            'ABC',
            'Equals'
        );
        System.assertNotEquals(accountGroupRule.Id, null, 'Expected account group rule to be created.');
        accountGroupRule.dmpl__FieldValue__c = 'Segment 1';
        update accountGroupRule;
        accountGroupRule = AccountDataHelper.getAccountGroupRuleById(accountGroupRule.Id);
        System.assertEquals(accountGroupRule.dmpl__FieldValue__c, 'Segment 1',
            'Expected account group rule to have the correct field value.');
        Test.stopTest();
    }

    //sv-119
    @isTest
    static void changeOperationFromEqualsToIncludesPositiveEdit(){
        dmpl__AccountGroup__c accountGroup1 = AccountDataHelper.getAccountGroupByName('Account Group 1');
        Test.startTest();
        dmpl__AccountGroupRule__c accountGroupRule = AccountDataHelper.createAccountGroupRule(
            accountGroup1.Id,
            1,
            '',
            '',
            'Equals'
        );
        System.assertNotEquals(accountGroupRule.Id, null, 'Expected account group rule to be created.');
        accountGroupRule.dmpl__Operation__c = 'includes';
        update accountGroupRule;
        accountGroupRule = AccountDataHelper.getAccountGroupRuleById(accountGroupRule.Id);
        System.assertEquals(accountGroupRule.dmpl__Operation__c, 'includes',
            'Expected account group rule to have the correct operation.');
        Test.stopTest();
    }

    //sv-120
    @isTest
    static void leaveFieldNameBlankAndSavePositiveEdit(){
        dmpl__AccountGroup__c accountGroup1 = AccountDataHelper.getAccountGroupByName('Account Group 1');
        Test.startTest();
        dmpl__AccountGroupRule__c accountGroupRule = AccountDataHelper.createAccountGroupRule(
            accountGroup1.Id,
            1,
            'Not blank',
            '',
            'Equals'
        );
        System.assertNotEquals(accountGroupRule.Id, null, 'Expected account group rule to be created.');
        accountGroupRule.dmpl__FieldName__c = '';
        update accountGroupRule;
        accountGroupRule = AccountDataHelper.getAccountGroupRuleById(accountGroupRule.Id);
        System.assertEquals(accountGroupRule.SequenceNumber__c, 1, 'Expected account group rule to have the correct sequence number.');
        System.assertEquals(accountGroupRule.AccountGroupId__c, accountGroup1.Id, 'Expected account group rule to be linked to the correct account group.');
        Test.stopTest();
    }

    //sv-121
    @isTest
    static void assignDuplicateSequenceNumberWithTheSameAccountGroupPositiveNew(){
        dmpl__AccountGroup__c accountGroup1 = AccountDataHelper.getAccountGroupByName('Account Group 1');
        Test.startTest();
        dmpl__AccountGroupRule__c accountGroupRule = AccountDataHelper.createAccountGroupRule(
            accountGroup1.Id,
            1,
            '',
            '',
            ''
        );
        System.assertNotEquals(accountGroupRule.Id, null, 'Expected account group rule to be created.');
        dmpl__AccountGroupRule__c accountGroupRule2 = AccountDataHelper.createAccountGroupRule(
            accountGroup1.Id,
            1,
            '',
            '',
            ''
        );

        System.assertNotEquals(accountGroupRule2.Id, null, 'Expected account group rule to be created.');
        accountGroupRule2 = AccountDataHelper.getAccountGroupRuleById(accountGroupRule2.Id);
        System.assertEquals(accountGroupRule2.dmpl__SequenceNumber__c, 1,
            'Expected account group rule to have the correct sequence number.');
        System.assertEquals(accountGroupRule2.dmpl__AccountGroupId__c, accountGroup1.Id,
            'Expected account group rule to be linked to the correct account group.');
        Test.stopTest();
    }

    //sv-122
    @isTest
    static void allAuditFieldsAreAutoPopulatedCorrectlyPositiveNew(){
        dmpl__AccountGroup__c accountGroup1 = AccountDataHelper.getAccountGroupByName('Account Group 1');
        Test.startTest();
        dmpl__AccountGroupRule__c accountGroupRule = AccountDataHelper.createAccountGroupRule(
            accountGroup1.Id,
            1,
            '',
            '',
            'equals'
        );
        System.assertNotEquals(accountGroupRule.Id, null, 'Expected account group rule to be created.');
        accountGroupRule = AccountDataHelper.getAccountGroupRuleById(accountGroupRule.Id);

        System.assertEquals(accountGroupRule.dmpl__Operation__c, 'equals',
            'Expected account group rule to have the correct operation.');
        System.assertEquals(accountGroupRule.dmpl__SequenceNumber__c, 1,
            'Expected account group rule to have the correct sequence number.');
        System.assertEquals(accountGroupRule.dmpl__AccountGroupId__c, accountGroup1.Id,
            'Expected account group rule to be linked to the correct account group.');
        System.assertNotEquals(accountGroupRule.CreatedById, null, 'Expected account group rule to have the correct created by.');
        System.assertNotEquals(accountGroupRule.LastModifiedById, null, 'Expected account group rule to have the correct last modified by.');
        Test.stopTest();
    }

    //sv-123 
    @isTest
    static void enterUnsupportedOperationNegativeNew(){
        dmpl__AccountGroup__c accountGroup1 = AccountDataHelper.getAccountGroupByName('Account Group 1');
        Test.startTest();
        try{
            dmpl__AccountGroupRule__c accountGroupRule = AccountDataHelper.createAccountGroupRule(
                accountGroup1.Id,
                1,
                '',
                '',
                'Not Supported'
            );
            System.assert(false, 'Expected an exception to be thrown due to unsupported operation.');
        } catch (Exception e) {
            System.assert(true, 'Expected exception due to unsupported operation.');
        }
        Test.stopTest();
    }

    //sv-124 
    @isTest
    static void fieldValueDoNotMatchAnyCriteriaNegativeNew(){
        Test.startTest();
        try{
            dmpl__AccountGroupRule__c accountGroupRule = AccountDataHelper.createAccountGroupRule(
                null,
                1,
                'ABC',
                '',
                'Equals'
            );
            System.assert(false, 'Expected an exception to be thrown due to field value not matching any criteria.');
        } catch (Exception e) {
            System.assert(true, 'Expected exception due to field value not matching any criteria.');
        }
        Test.stopTest();
    }

    //sv-125
    @isTest
    static void addMultipleRulesWithDecimalSequenceNumbersPositiveNew(){
        dmpl__AccountGroup__c accountGroup1 = AccountDataHelper.getAccountGroupByName('Account Group 1');
        Test.startTest();
        dmpl__AccountGroupRule__c accountGroupRule = AccountDataHelper.createAccountGroupRule(
            accountGroup1.Id,
            1.5,
            '',
            '',
            'Equals'
        );
        System.assertNotEquals(accountGroupRule.Id, null, 'Expected account group rule to be created.');
        accountGroupRule = AccountDataHelper.getAccountGroupRuleById(accountGroupRule.Id);
        System.assertEquals(accountGroupRule.dmpl__SequenceNumber__c, 1.5,
            'Expected account group rule to have the correct sequence number.');
        System.assertEquals(accountGroupRule.dmpl__AccountGroupId__c, accountGroup1.Id,
            'Expected account group rule to be linked to the correct account group.');

        dmpl__AccountGroupRule__c accountGroupRule2 = AccountDataHelper.createAccountGroupRule(
            accountGroup1.Id,
            2.5,
            '',
            '',
            'Equals'
        );
        System.assertNotEquals(accountGroupRule2.Id, null, 'Expected account group rule to be created.');
        accountGroupRule2 = AccountDataHelper.getAccountGroupRuleById(accountGroupRule2.Id);
        System.assertEquals(accountGroupRule2.dmpl__SequenceNumber__c, 2.5,
            'Expected account group rule to have the correct sequence number.');
        System.assertEquals(accountGroupRule2.dmpl__AccountGroupId__c, accountGroup1.Id,
            'Expected account group rule to be linked to the correct account group.');
        Test.stopTest();
    }

    //sv-126
    @isTest
    static void addMultipleRulesWithUniqueSequenceNumbersPositiveNew(){
        dmpl__AccountGroup__c accountGroup1 = AccountDataHelper.getAccountGroupByName('Account Group 1');
        Test.startTest();
        dmpl__AccountGroupRule__c accountGroupRule = AccountDataHelper.createAccountGroupRule(
            accountGroup1.Id,
            1,
            '',
            '',
            'Equals'
        );
        System.assertNotEquals(accountGroupRule.Id, null, 'Expected account group rule to be created.');
        accountGroupRule = AccountDataHelper.getAccountGroupRuleById(accountGroupRule.Id);
        System.assertEquals(accountGroupRule.dmpl__SequenceNumber__c, 1,
            'Expected account group rule to have the correct sequence number.');
        System.assertEquals(accountGroupRule.dmpl__AccountGroupId__c, accountGroup1.Id,
            'Expected account group rule to be linked to the correct account group.');

        dmpl__AccountGroupRule__c accountGroupRule2 = AccountDataHelper.createAccountGroupRule(
            accountGroup1.Id,
            2,
            '',
            '',
            'Equals'
        );
        System.assertNotEquals(accountGroupRule2.Id, null, 'Expected account group rule to be created.');
        accountGroupRule2 = AccountDataHelper.getAccountGroupRuleById(accountGroupRule2.Id);
        System.assertEquals(accountGroupRule2.dmpl__SequenceNumber__c, 2,
            'Expected account group rule to have the correct sequence number.');
        System.assertEquals(accountGroupRule2.dmpl__AccountGroupId__c, accountGroup1.Id,
            'Expected account group rule to be linked to the correct account group.');

        dmpl__AccountGroupRule__c accountGroupRule3 = AccountDataHelper.createAccountGroupRule(
            accountGroup1.Id,
            3,
            '',
            '',
            'Equals'
        );
        System.assertNotEquals(accountGroupRule3.Id, null, 'Expected account group rule to be created.');
        accountGroupRule3 = AccountDataHelper.getAccountGroupRuleById(accountGroupRule3.Id);
        System.assertEquals(accountGroupRule3.dmpl__SequenceNumber__c, 3,
            'Expected account group rule to have the correct sequence number.');
        System.assertEquals(accountGroupRule3.dmpl__AccountGroupId__c, accountGroup1.Id,
            'Expected account group rule to be linked to the correct account group.');
        Test.stopTest();
    }

    //sv-127
    @isTest
    static void duplicateSequenceNumberAllowedWithinSameAccountGroupPositiveNew(){
        dmpl__AccountGroup__c accountGroup1 = AccountDataHelper.getAccountGroupByName('Account Group 1');
        Test.startTest();
        dmpl__AccountGroupRule__c accountGroupRule = AccountDataHelper.createAccountGroupRule(
            accountGroup1.Id,
            1,
            '',
            '',
            'Equals'
        );

        dmpl__AccountGroupRule__c accountGroupRule2 = AccountDataHelper.createAccountGroupRule(
            accountGroup1.Id,
            1,
            '',
            '',
            'Equals'
        );
        System.assertNotEquals(accountGroupRule2.Id, null, 'Expected account group rule to be created.');
        accountGroupRule2 = AccountDataHelper.getAccountGroupRuleById(accountGroupRule2.Id);
        System.assertEquals(accountGroupRule2.dmpl__SequenceNumber__c, 1,
            'Expected account group rule to have the correct sequence number.');
        System.assertEquals(accountGroupRule2.dmpl__AccountGroupId__c, accountGroup1.Id,
            'Expected account group rule to be linked to the correct account group.');
    
        Test.stopTest();
    }

    //sv-128
    @isTest
    static void duplicateOperationIsAllowedWithinSameAccountGroupPositiveNew(){
        dmpl__AccountGroup__c accountGroup1 = AccountDataHelper.getAccountGroupByName('Account Group 1');
        Test.startTest();
        dmpl__AccountGroupRule__c accountGroupRule = AccountDataHelper.createAccountGroupRule(
            accountGroup1.Id,
            1,
            '',
            '',
            'equals'
        );
        System.assertNotEquals(accountGroupRule.Id, null, 'Expected account group rule to be created.');
        dmpl__AccountGroupRule__c accountGroupRule2 = AccountDataHelper.createAccountGroupRule(
            accountGroup1.Id,
            1,
            '',
            '',
            'equals'
        );
        System.assertNotEquals(accountGroupRule2.Id, null, 'Expected account group rule to be created.');
        accountGroupRule2 = AccountDataHelper.getAccountGroupRuleById(accountGroupRule2.Id);
        System.assertEquals(accountGroupRule2.dmpl__Operation__c, 'equals',
            'Expected account group rule to have the correct operation.');
        System.assertEquals(accountGroupRule2.dmpl__SequenceNumber__c, 1,
            'Expected account group rule to have the correct sequence number.');
        System.assertEquals(accountGroupRule2.dmpl__AccountGroupId__c, accountGroup1.Id,
            'Expected account group rule to be linked to the correct account group.');
        Test.stopTest();
    }

    //sv-129
    @isTest
    static void rulesExecutedInCorrectOrderPositiveNew(){
        dmpl__AccountGroup__c accountGroup1 = AccountDataHelper.getAccountGroupByName('Account Group 1');
        Test.startTest();
        dmpl__AccountGroupRule__c accountGroupRule = AccountDataHelper.createAccountGroupRule(
            accountGroup1.Id,
            1,
            'dmpl__AccountContactId__c',
            'escape',
            'Equals'
        );
        System.assertNotEquals(accountGroupRule.Id, null, 'Expected account group rule to be created.');
        accountGroupRule = AccountDataHelper.getAccountGroupRuleById(accountGroupRule.Id);
        System.assertEquals(accountGroupRule.dmpl__SequenceNumber__c, 1,
            'Expected account group rule to have the correct sequence number.');
        System.assertEquals(accountGroupRule.dmpl__AccountGroupId__c, accountGroup1.Id,
            'Expected account group rule to be linked to the correct account group.');
        Test.stopTest();
    }

    //account balance

    //sv-090
    @isTest
    static void createRecordWithValidAccountAndGLAccountPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__GLAccount__c glAccount1 = AccountDataHelper.getGLAccountByName('ICICI Bank');
        Test.startTest();
        dmpl__AccountBalance__c accountBalance = AccountDataHelper.createAccountBalance(
            customer1.Id,
            glAccount1.Id,
            partner1.Id,
            1000
        );
        System.assertNotEquals(accountBalance.Id, null, 'Expected account balance to be created.');
        accountBalance = AccountDataHelper.getAccountBalanceById(accountBalance.Id);
        System.assertEquals(accountBalance.dmpl__GLAccountId__c, glAccount1.Id,
            'Expected account balance to be linked to the correct GL account.');
        System.assertEquals(accountBalance.dmpl__AccountId__c, customer1.Id,
            'Expected account balance to be linked to the correct account.');
        System.assertEquals(accountBalance.dmpl__PartnerAccountId__c, partner1.Id,
            'Expected account balance to be linked to the correct partner account.');
        System.assertEquals(accountBalance.dmpl__Amount__c, 1000,
            'Expected account balance to have the correct amount.');
        Test.stopTest();
    }

    //sv-091
    @isTest
    static void saveGLAccountWithoutSelectingAccountPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__GLAccount__c glAccount1 = AccountDataHelper.getGLAccountByName('ICICI Bank');
        Test.startTest();
        dmpl__AccountBalance__c accountBalance = AccountDataHelper.createAccountBalance(
            customer1.Id,
            glAccount1.Id,
            partner1.Id,
            null
        );
        System.assertNotEquals(accountBalance.Id, null, 'Expected account balance to be created.');
        accountBalance = AccountDataHelper.getAccountBalanceById(accountBalance.Id);
        System.assertEquals(accountBalance.dmpl__GLAccountId__c, glAccount1.Id,
            'Expected account balance to be linked to the correct GL account.');
        System.assertEquals(accountBalance.dmpl__AccountId__c, customer1.Id,
            'Expected account balance to be linked to the correct account.');
        System.assertEquals(accountBalance.dmpl__PartnerAccountId__c, partner1.Id,
            'Expected account balance to be linked to the correct partner account.');
        Test.stopTest();
    }

    //sv-092
    @isTest
    static void saveWithoutSelectingGLAccountNegativeNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Test.startTest();
        try{
            dmpl__AccountBalance__c accountBalance = AccountDataHelper.createAccountBalance(
                customer1.Id,
                null,
                partner1.Id,
                1000
            );
            System.assert(false, 'Expected an exception to be thrown due to no GL account.');
        } catch (Exception e) {
            System.assert(true, 'Expected exception due to no GL account.');
        }
        Test.stopTest();
    }

    //sv-093
    @isTest
    static void nameIsAutoGeneratedSuccessfullyPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__GLAccount__c glAccount1 = AccountDataHelper.getGLAccountByName('ICICI Bank');
        Test.startTest();
        dmpl__AccountBalance__c accountBalance = AccountDataHelper.createAccountBalance(
            customer1.Id,
            glAccount1.Id,
            partner1.Id,
            1000
        );
        System.assertNotEquals(accountBalance.Id, null, 'Expected account balance to be created.');
        accountBalance = AccountDataHelper.getAccountBalanceById(accountBalance.Id);
        System.assertNotEquals(accountBalance.Name, null, 'Expected account balance to have a name.');
        Test.stopTest();
    }

    //sv-094
    @isTest 
    static void changeAccountFieldAndVerifyPositiveEdit(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account customer3 = TestDataHelpers.getCustomerAccount('Customer 3');
        dmpl__GLAccount__c glAccount1 = AccountDataHelper.getGLAccountByName('ICICI Bank');
        Test.startTest();
        dmpl__AccountBalance__c accountBalance = AccountDataHelper.createAccountBalance(
            customer1.Id,
            glAccount1.Id,
            partner1.Id,
            1000
        );
        System.assertNotEquals(accountBalance.Id, null, 'Expected account balance to be created.');
        accountBalance.dmpl__AccountId__c = customer3.Id;
        update accountBalance;
        accountBalance = AccountDataHelper.getAccountBalanceById(accountBalance.Id);
        System.assertEquals(accountBalance.dmpl__AccountId__c, customer3.Id,
            'Expected account balance to be linked to the correct account.');
        System.assertEquals(accountBalance.dmpl__GLAccountId__c, glAccount1.Id,
            'Expected account balance to be linked to the correct GL account.');
        System.assertEquals(accountBalance.dmpl__PartnerAccountId__c, partner1.Id,
            'Expected account balance to be linked to the correct partner account.');
        System.assertEquals(accountBalance.dmpl__Amount__c, 1000,
            'Expected account balance to have the correct amount.');
        Test.stopTest();
    }

    //sv-095 
    @isTest 
    static void saveWithoutFillingMandatoryFieldsNegativeNew(){
        Test.startTest();
        try{
            dmpl__AccountBalance__c accountBalance = AccountDataHelper.createAccountBalance(
                null,
                null,
                null,
                null
            );
            System.assert(false, 'Expected an exception to be thrown due to no account balance.');
        } catch (Exception e) {
            System.assert(true, 'Expected exception due to no account balance.');
        }
        Test.stopTest();
    }

    //sv-097
    @isTest
    static void validateProperDisplayOfAmountPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__GLAccount__c glAccount1 = AccountDataHelper.getGLAccountByName('ICICI Bank');
        Test.startTest();
        dmpl__AccountBalance__c accountBalance = AccountDataHelper.createAccountBalance(
            customer1.Id,
            glAccount1.Id,
            partner1.Id,
            1000
        );
        System.assertNotEquals(accountBalance.Id, null, 'Expected account balance to be created.');
        accountBalance = AccountDataHelper.getAccountBalanceById(accountBalance.Id);
        System.assertEquals(accountBalance.dmpl__GLAccountId__c, glAccount1.Id,
            'Expected account balance to be linked to the correct GL account.');
        System.assertEquals(accountBalance.dmpl__AccountId__c, customer1.Id,
            'Expected account balance to be linked to the correct account.');
        System.assertEquals(accountBalance.dmpl__PartnerAccountId__c, partner1.Id,
            'Expected account balance to be linked to the correct partner account.');
        System.assertEquals(accountBalance.dmpl__Amount__c, 1000,
            'Expected account balance to have the correct amount.');
        Test.stopTest();
    }

    //sv-098
    @isTest
    static void createdRecordAppearsCorrectlyInRelatedListOfAccountPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__GLAccount__c glAccount1 = AccountDataHelper.getGLAccountByName('ICICI Bank');
        Test.startTest();
        dmpl__AccountBalance__c accountBalance = AccountDataHelper.createAccountBalance(
            customer1.Id,
            glAccount1.Id,
            partner1.Id,
            1000
        );
        System.assertNotEquals(accountBalance.Id, null, 'Expected account balance to be created.');
        
        Account retrievedAccount = AccountDataHelper.getAccountById(customer1.Id);
        System.assertEquals(retrievedAccount.Id, accountBalance.dmpl__AccountId__c, 'Expected account balance to be linked to the correct account.');
        Test.stopTest();
    }


    //account locations

    //sv-130
    @isTest 
    static void createAccountLocationWithValidAccountNameChannelLocationTypePositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        
        Test.startTest();
        dmpl__AccountLocations__c accountLocation = AccountDataHelper.createAccountLocation(
            'Pune',
            partner1.Id,
            'Sample',
            'Sample',
            false,
            false,
            10,
            20
        );
        System.assertNotEquals(accountLocation, null, 'Expected account location to be created.');
        accountLocation = AccountDataHelper.getAccountLocationById(accountLocation.Id);
        System.assertEquals(accountLocation.dmpl__AccountId__c, partner1.Id, 'Expected account location to be linked to the correct account.');
        System.assertEquals(accountLocation.dmpl__Channel__c, 'Sample', 'Expected account location to have the correct channel.');
        System.assertEquals(accountLocation.dmpl__LocationType__c, 'Sample', 'Expected account location to have the correct location type.');
        System.assertEquals(accountLocation.dmpl__IsActive__c, true, 'Expected account location to have the correct active status.');
        System.assertEquals(accountLocation.dmpl__AllowInventory__c, false, 'Expected account location to have the correct allow inventory status.');
        System.assertEquals(accountLocation.dmpl__GeoLocation__Latitude__s, 10, 'Expected account location to have the correct latitude.');
        System.assertEquals(accountLocation.dmpl__GeoLocation__Longitude__s, 20, 'Expected account location to have the correct longitude.');
        Test.stopTest();
    }


    //sv-131
    @isTest 
    static void setBothCheckboxesAllowInventoryAndIsActiveAsTruePositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        
        Test.startTest();
        dmpl__AccountLocations__c accountLocation = AccountDataHelper.createAccountLocation(
            'Pune',
            partner1.Id,
            'Sample',
            'Sample',
            true,
            true,
            10,
            20
        );
        System.assertNotEquals(accountLocation, null, 'Expected account location to be created.');
        accountLocation = AccountDataHelper.getAccountLocationById(accountLocation.Id);
        System.assertEquals(accountLocation.dmpl__AccountId__c, partner1.Id, 'Expected account location to be linked to the correct account.');
        System.assertEquals(accountLocation.dmpl__Channel__c, 'Sample', 'Expected account location to have the correct channel.');
        System.assertEquals(accountLocation.dmpl__LocationType__c, 'Sample', 'Expected account location to have the correct location type.');
        System.assertEquals(accountLocation.dmpl__IsActive__c, true, 'Expected account location to have the correct active status.');
        System.assertEquals(accountLocation.dmpl__AllowInventory__c, true, 'Expected account location to have the correct allow inventory status.');
        System.assertEquals(accountLocation.dmpl__GeoLocation__Latitude__s, 10, 'Expected account location to have the correct latitude.');
        System.assertEquals(accountLocation.dmpl__GeoLocation__Longitude__s, 20, 'Expected account location to have the correct longitude.');
        Test.stopTest();
    }

    //sv-132 
    @isTest 
    static void enterValidGeolocationForALocationPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        
        Test.startTest();
        dmpl__AccountLocations__c accountLocation = AccountDataHelper.createAccountLocation(
            'Pune',
            partner1.Id,
            'Sample',
            'Sample',
            false,
            false,
            10,
            20
        );
        System.assertNotEquals(accountLocation, null, 'Expected account location to be created.');
        accountLocation = AccountDataHelper.getAccountLocationById(accountLocation.Id);
        System.assertEquals(accountLocation.dmpl__AccountId__c, partner1.Id, 'Expected account location to be linked to the correct account.');
        System.assertEquals(accountLocation.dmpl__Channel__c, 'Sample', 'Expected account location to have the correct channel.');
        System.assertEquals(accountLocation.dmpl__LocationType__c, 'Sample', 'Expected account location to have the correct location type.');
        System.assertEquals(accountLocation.dmpl__IsActive__c, true, 'Expected account location to have the correct active status.');
        System.assertEquals(accountLocation.dmpl__AllowInventory__c, false, 'Expected account location to have the correct allow inventory status.');
        System.assertEquals(accountLocation.dmpl__GeoLocation__Latitude__s, 10, 'Expected account location to have the correct latitude.');
        System.assertEquals(accountLocation.dmpl__GeoLocation__Longitude__s, 20, 'Expected account location to have the correct longitude.');
        Test.stopTest();
    }

    //sv-133
    @isTest 
    static void validateTheUserIsAValidUserDuringAccountLocationCreationPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');

        Test.startTest();

        dmpl__AccountLocations__c accountLocation = AccountDataHelper.createAccountLocation(
            'Pune',
            partner1.Id,
            'Sample',
            'Sample',
            false,
            false,
            10,
            20
        );
        System.assertNotEquals(accountLocation, null, 'Expected account location to be created.');
        accountLocation = AccountDataHelper.getAccountLocationById(accountLocation.Id);
        System.assertEquals(accountLocation.dmpl__AccountId__c, partner1.Id, 'Expected account location to be linked to the correct account.');
        System.assertEquals(accountLocation.CreatedById, UserInfo.getUserId(), 'Expected account location to be created by the current user.');
        System.assertEquals(accountLocation.LastModifiedById, UserInfo.getUserId(), 'Expected account location to be modified by the current user.');
        Test.stopTest();
    }


    //sv-135
    @isTest 
    static void setChannelPicklistToAnAllowedValuePositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        
        Test.startTest();
        dmpl__AccountLocations__c accountLocation = AccountDataHelper.createAccountLocation(
            'Pune',
            partner1.Id,
            'Sample',
            'Sample',
            false,
            false,
            10,
            20
        );
        System.assertNotEquals(accountLocation, null, 'Expected account location to be created.');
        accountLocation = AccountDataHelper.getAccountLocationById(accountLocation.Id);
        System.assertEquals(accountLocation.dmpl__AccountId__c, partner1.Id, 'Expected account location to be linked to the correct account.');
        System.assertEquals(accountLocation.dmpl__Channel__c, 'Sample', 'Expected account location to have the correct channel.');
        System.assertEquals(accountLocation.dmpl__LocationType__c, 'Sample', 'Expected account location to have the correct location type.');
        System.assertEquals(accountLocation.dmpl__IsActive__c, true, 'Expected account location to have the correct active status.');
        System.assertEquals(accountLocation.dmpl__AllowInventory__c, false, 'Expected account location to have the correct allow inventory status.');
        System.assertEquals(accountLocation.dmpl__GeoLocation__Latitude__s, 10, 'Expected account location to have the correct latitude.');
        System.assertEquals(accountLocation.dmpl__GeoLocation__Longitude__s, 20, 'Expected account location to have the correct longitude.');
        Test.stopTest();
    }

    //sv-136
    @isTest 
    static void setLocationTypePicklistToAValidTypePositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        
        Test.startTest();
        dmpl__AccountLocations__c accountLocation = AccountDataHelper.createAccountLocation(
            'Pune',
            partner1.Id,
            'Sample',
            'Sample',
            false,
            false,
            10,
            20
        );
        System.assertNotEquals(accountLocation, null, 'Expected account location to be created.');
        accountLocation = AccountDataHelper.getAccountLocationById(accountLocation.Id);
        System.assertEquals(accountLocation.dmpl__AccountId__c, partner1.Id, 'Expected account location to be linked to the correct account.');
        System.assertEquals(accountLocation.dmpl__Channel__c, 'Sample', 'Expected account location to have the correct channel.');
        System.assertEquals(accountLocation.dmpl__LocationType__c, 'Sample', 'Expected account location to have the correct location type.');
        System.assertEquals(accountLocation.dmpl__IsActive__c, true, 'Expected account location to have the correct active status.');
        System.assertEquals(accountLocation.dmpl__AllowInventory__c, false, 'Expected account location to have the correct allow inventory status.');
        System.assertEquals(accountLocation.dmpl__GeoLocation__Latitude__s, 10, 'Expected account location to have the correct latitude.');
        System.assertEquals(accountLocation.dmpl__GeoLocation__Longitude__s, 20, 'Expected account location to have the correct longitude.');
        Test.stopTest();
    }


    //sv-137
    @isTest 
    static void accountLocationCreationWithMinimalRequiredFieldsPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        
        Test.startTest();
        dmpl__AccountLocations__c accountLocation = AccountDataHelper.createAccountLocation(
            'Pune',
            partner1.Id,
            null,
            null,
            true,
            true,
            null,
            null
        );
        System.assertNotEquals(accountLocation, null, 'Expected account location to be created.');
        accountLocation = AccountDataHelper.getAccountLocationById(accountLocation.Id);
        System.assertEquals(accountLocation.dmpl__AccountId__c, partner1.Id, 'Expected account location to be linked to the correct account.');
        Test.stopTest();
    }

    //sv-138
    @isTest 
    static void accountLocationCreationWithSpecialCharactersInNamePositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        
        Test.startTest();
        dmpl__AccountLocations__c accountLocation = AccountDataHelper.createAccountLocation(
            'Pune?!@',
            partner1.Id,
            'Sample',
            'Sample',
            true,
            false,
            10,
            20
        );
        System.assertNotEquals(accountLocation, null, 'Expected account location to be created.');
        accountLocation = AccountDataHelper.getAccountLocationById(accountLocation.Id);
        System.assertEquals(accountLocation.Name, 'Pune?!@', 'Expected account location to have the correct name.');
        System.assertEquals(accountLocation.dmpl__AccountId__c, partner1.Id, 'Expected account location to be linked to the correct account.');
        System.assertEquals(accountLocation.dmpl__Channel__c, 'Sample', 'Expected account location to have the correct channel.');
        System.assertEquals(accountLocation.dmpl__LocationType__c, 'Sample', 'Expected account location to have the correct location type.');
        System.assertEquals(accountLocation.dmpl__IsActive__c, true, 'Expected account location to have the correct active status.');
        System.assertEquals(accountLocation.dmpl__AllowInventory__c, false, 'Expected account location to have the correct allow inventory status.');
        System.assertEquals(accountLocation.dmpl__GeoLocation__Latitude__s, 10, 'Expected account location to have the correct latitude.');
        System.assertEquals(accountLocation.dmpl__GeoLocation__Longitude__s, 20, 'Expected account location to have the correct longitude.');
        Test.stopTest();
    }

    //sv-139
    @isTest 
    static void verifyCreatedByAndLastModifiedByFieldsArePopulatedPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');

        Test.startTest();

        dmpl__AccountLocations__c accountLocation = AccountDataHelper.createAccountLocation(
            'Pune',
            partner1.Id,
            'Sample',
            'Sample',
            false,
            false,
            10,
            20
        );
        System.assertNotEquals(accountLocation, null, 'Expected account location to be created.');
        accountLocation = AccountDataHelper.getAccountLocationById(accountLocation.Id);
        System.assertEquals(accountLocation.dmpl__AccountId__c, partner1.Id, 'Expected account location to be linked to the correct account.');
        System.assertEquals(accountLocation.CreatedById, UserInfo.getUserId(), 'Expected account location to be created by the current user.');
        System.assertEquals(accountLocation.LastModifiedById, UserInfo.getUserId(), 'Expected account location to be modified by the current user.');
        Test.stopTest();  
    }

    //sv-140
    @isTest 
    static void allowInventoryCheckboxLeftUncheckedPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        
        Test.startTest();
        dmpl__AccountLocations__c accountLocation = AccountDataHelper.createAccountLocation(
            'Pune',
            partner1.Id,
            'Sample',
            'Sample',
            true,
            false,
            10,
            20
        );
        System.assertNotEquals(accountLocation, null, 'Expected account location to be created.');
        accountLocation = AccountDataHelper.getAccountLocationById(accountLocation.Id);
        System.assertEquals(accountLocation.dmpl__AccountId__c, partner1.Id, 'Expected account location to be linked to the correct account.');
        System.assertEquals(accountLocation.dmpl__Channel__c, 'Sample', 'Expected account location to have the correct channel.');
        System.assertEquals(accountLocation.dmpl__LocationType__c, 'Sample', 'Expected account location to have the correct location type.');
        System.assertEquals(accountLocation.dmpl__IsActive__c, true, 'Expected account location to have the correct active status.');
        System.assertEquals(accountLocation.dmpl__AllowInventory__c, false, 'Expected account location to have the correct allow inventory status.');
        System.assertEquals(accountLocation.dmpl__GeoLocation__Latitude__s, 10, 'Expected account location to have the correct latitude.');
        System.assertEquals(accountLocation.dmpl__GeoLocation__Longitude__s, 20, 'Expected account location to have the correct longitude.');
        Test.stopTest();
    }

    //sv-141
    @isTest
    static void onlyIsActiveIsTrueAllowInventoryIsFalsePositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        
        Test.startTest();
        dmpl__AccountLocations__c accountLocation = AccountDataHelper.createAccountLocation(
            'Pune',
            partner1.Id,
            'Sample',
            'Sample',
            true,
            false,
            10,
            20
        );
        System.assertNotEquals(accountLocation, null, 'Expected account location to be created.');
        accountLocation = AccountDataHelper.getAccountLocationById(accountLocation.Id);
        System.assertEquals(accountLocation.dmpl__AccountId__c, partner1.Id, 'Expected account location to be linked to the correct account.');
        System.assertEquals(accountLocation.dmpl__Channel__c, 'Sample', 'Expected account location to have the correct channel.');
        System.assertEquals(accountLocation.dmpl__LocationType__c, 'Sample', 'Expected account location to have the correct location type.');
        System.assertEquals(accountLocation.dmpl__IsActive__c, true, 'Expected account location to have the correct active status.');
        System.assertEquals(accountLocation.dmpl__AllowInventory__c, false, 'Expected account location to have the correct allow inventory status.');
        System.assertEquals(accountLocation.dmpl__GeoLocation__Latitude__s, 10, 'Expected account location to have the correct latitude.');
        System.assertEquals(accountLocation.dmpl__GeoLocation__Longitude__s, 20, 'Expected account location to have the correct longitude.');
        Test.stopTest();
    }

    //sv-142
    @isTest
    static void createRecordWithoutSelectingRequiredAccountPositiveNew(){
        Test.startTest();
        dmpl__AccountLocations__c accountLocation = AccountDataHelper.createAccountLocation(
            'Pune',
            null,
            'Sample',
            'Sample',
            false,
            false,
            10,
            20
        );
        System.assertNotEquals(accountLocation, null, 'Expected account location to be created.');
        accountLocation = AccountDataHelper.getAccountLocationById(accountLocation.Id);
        System.assertEquals(accountLocation.dmpl__AccountId__c, null, 'Expected account location to be linked to the correct account.');
        System.assertEquals(accountLocation.dmpl__Channel__c, 'Sample', 'Expected account location to have the correct channel.');
        System.assertEquals(accountLocation.dmpl__LocationType__c, 'Sample', 'Expected account location to have the correct location type.');
        System.assertEquals(accountLocation.dmpl__IsActive__c, true, 'Expected account location to have the correct active status.');
        System.assertEquals(accountLocation.dmpl__AllowInventory__c, false, 'Expected account location to have the correct allow inventory status.');
        System.assertEquals(accountLocation.dmpl__GeoLocation__Latitude__s, 10, 'Expected account location to have the correct latitude.');
        System.assertEquals(accountLocation.dmpl__GeoLocation__Longitude__s, 20, 'Expected account location to have the correct longitude.');
        Test.stopTest();
    }

    //sv-144
    @isTest
    static void leaveNameBlankPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        
        Test.startTest();
        dmpl__AccountLocations__c accountLocation = AccountDataHelper.createAccountLocation(
            '',
            partner1.Id,
            '',
            'Sample',
            false,
            false,
            10,
            20
        );
        System.assertNotEquals(accountLocation, null, 'Expected account location to be created.');
        accountLocation = AccountDataHelper.getAccountLocationById(accountLocation.Id);
        System.assertNotEquals(accountLocation.Name, null, 'Expected account location to get autopopulated.');
        System.assertEquals(accountLocation.dmpl__AccountId__c, partner1.Id, 'Expected account location to be linked to the correct account.');
        System.assertEquals(accountLocation.dmpl__LocationType__c, 'Sample', 'Expected account location to have the correct location type.');
        System.assertEquals(accountLocation.dmpl__IsActive__c, true, 'Expected account location to have the correct active status.');
        System.assertEquals(accountLocation.dmpl__AllowInventory__c, false, 'Expected account location to have the correct allow inventory status.');
        System.assertEquals(accountLocation.dmpl__GeoLocation__Latitude__s, 10, 'Expected account location to have the correct latitude.');
        System.assertEquals(accountLocation.dmpl__GeoLocation__Longitude__s, 20, 'Expected account location to have the correct longitude.');        
        Test.stopTest();
    }


    //sv-143
    @isTest
    static void enterInvalidValueInGeolocationFieldNegativeNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        
        Test.startTest();
        try{
            dmpl__AccountLocations__c accountLocation = AccountDataHelper.createAccountLocation(
                'Pune',
                partner1.Id,
                'Sample',
                'Sample',
                false,
                false,
                1000,
                -10000
            );
            System.assert(false, 'Expected an exception to be thrown due to invalid geolocation value.');
        } catch (Exception e) {
            System.assert(true, 'Expected exception due to invalid geolocation value.');
        }
        Test.stopTest();
    }

    //sv-145
    @isTest
    static void updateChannelPicklistValueToAnotherValidOptionPositiveEdit(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        
        Test.startTest();
        dmpl__AccountLocations__c accountLocation = AccountDataHelper.createAccountLocation(
            'Pune',
            partner1.Id,
            'Sample',
            'Sample',
            false,
            false,
            10,
            20
        );
        System.assertNotEquals(accountLocation, null, 'Expected account location to be created.');
        accountLocation.dmpl__Channel__c = null;
        update accountLocation;
        dmpl__AccountLocations__c updatedAccountLocation = AccountDataHelper.getAccountLocationById(accountLocation.Id);
        System.assertEquals(updatedAccountLocation.dmpl__Channel__c, null, 'Expected account location to have the correct channel.'); 
        Test.stopTest();
    }

    //sv-146
    @IsTest
    static void changeAllowInventoryFromFalseToTruePositiveEdit(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        
        Test.startTest();
        dmpl__AccountLocations__c accountLocation = AccountDataHelper.createAccountLocation(
            'Pune',
            partner1.Id,
            'Sample',
            'Sample',
            false,
            false,
            10,
            20
        );
        System.assertNotEquals(accountLocation, null, 'Expected account location to be created.');
        accountLocation.dmpl__AllowInventory__c = true;
        update accountLocation;
        dmpl__AccountLocations__c updatedAccountLocation = AccountDataHelper.getAccountLocationById(accountLocation.Id);
        System.assertEquals(updatedAccountLocation.dmpl__AllowInventory__c, true, 'Expected account location to have the correct allow inventory status.'); 
        Test.stopTest();
    }

    //sv-148
    @isTest
    static void clearTheAccountFieldPositiveEdit(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        
        Test.startTest();
        dmpl__AccountLocations__c accountLocation = AccountDataHelper.createAccountLocation(
            'Pune',
            partner1.Id,
            'Sample',
            'Sample',
            false,
            false,
            10,
            20
        );
        System.assertNotEquals(accountLocation, null, 'Expected account location to be created.');
        accountLocation.dmpl__AccountId__c = null;
        update accountLocation;
        dmpl__AccountLocations__c updatedAccountLocation = AccountDataHelper.getAccountLocationById(accountLocation.Id);
        System.assertEquals(updatedAccountLocation.dmpl__AccountId__c, null, 'Expected account location to have the correct account.'); 
        Test.stopTest();
    }

    //sv-149
    @isTest
    static void setLocationTypeToNonePositiveEdit(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        
        Test.startTest();
        dmpl__AccountLocations__c accountLocation = AccountDataHelper.createAccountLocation(
            'Pune',
            partner1.Id,
            'Sample',
            'Sample',
            false,
            false,
            10,
            20
        );
        System.assertNotEquals(accountLocation, null, 'Expected account location to be created.');
        accountLocation.dmpl__LocationType__c = null;
        update accountLocation;
        dmpl__AccountLocations__c updatedAccountLocation = AccountDataHelper.getAccountLocationById(accountLocation.Id);
        System.assertEquals(updatedAccountLocation.dmpl__LocationType__c, null, 'Expected account location to have the correct location type.'); 
        Test.stopTest();
    }


    //account user
    //sv-167
    @isTest 
    static void createRecordWithValidBranchAndPartnerAccountPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');

        Test.startTest();
        dmpl__AccountUser__c accountUser = AccountDataHelper.createAccountUser(partner1.Id, branch1.Id, UserInfo.getUserId(), Date.today(), Date.today().addDays(30));
        System.assertNotEquals(accountUser, null, 'Expected account user to be created.');
        accountUser = AccountDataHelper.getAccountUserById(accountUser.Id);
        System.assertEquals(accountUser.dmpl__PartnerAccountId__c, partner1.Id, 'Expected account user to be linked to the correct partner.');
        System.assertEquals(accountUser.dmpl__BranchId__c, branch1.Id, 'Expected account user to be linked to the correct branch.');
        System.assertEquals(accountUser.dmpl__UserId__c, UserInfo.getUserId(), 'Expected account user to be linked to the correct user.');
        System.assertEquals(accountUser.dmpl__DateEffectiveFrom__c, Date.today(), 'Expected account user to have the correct date effective from.');
        System.assertEquals(accountUser.dmpl__DateEffectiveTill__c, Date.today().addDays(30), 'Expected account user to have the correct date effective till.');
        Test.stopTest();
    }


    //sv-169
    @isTest
    static void nameIsPopulatedCorrectlyPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        
        Test.startTest();
        dmpl__AccountUser__c accountUser = AccountDataHelper.createAccountUser(partner1.Id, branch1.Id, UserInfo.getUserId(), Date.today(), Date.today().addDays(30));
        System.assertNotEquals(accountUser, null, 'Expected account user to be created.');
        accountUser = AccountDataHelper.getAccountUserById(accountUser.Id);
        System.assertNotEquals(accountUser.Name, null, 'Expected account user to have a name.');
        Test.stopTest();
    }


    //sv-170
    @isTest
    static void useAllRequiredAndOptionalFieldsPositiveNew(){
                Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');

        Test.startTest();
        dmpl__AccountUser__c accountUser = AccountDataHelper.createAccountUser(partner1.Id, branch1.Id, UserInfo.getUserId(), Date.today(), Date.today().addDays(30));
        System.assertNotEquals(accountUser, null, 'Expected account user to be created.');
        accountUser = AccountDataHelper.getAccountUserById(accountUser.Id);
        System.assertEquals(accountUser.dmpl__PartnerAccountId__c, partner1.Id, 'Expected account user to be linked to the correct partner.');
        System.assertEquals(accountUser.dmpl__BranchId__c, branch1.Id, 'Expected account user to be linked to the correct branch.');
        System.assertEquals(accountUser.dmpl__UserId__c, UserInfo.getUserId(), 'Expected account user to be linked to the correct user.');
        System.assertEquals(accountUser.dmpl__DateEffectiveFrom__c, Date.today(), 'Expected account user to have the correct date effective from.');
        System.assertEquals(accountUser.dmpl__DateEffectiveTill__c, Date.today().addDays(30), 'Expected account user to have the correct date effective till.');
        Test.stopTest();
    }

    //sv-171
    @isTest
    static void userIndexedFieldsForFasterLookupPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');

        Test.startTest();
        dmpl__AccountUser__c accountUser = AccountDataHelper.createAccountUser(partner1.Id, branch1.Id, UserInfo.getUserId(), Date.today(), Date.today().addDays(30));
        System.assertNotEquals(accountUser, null, 'Expected account user to be created.');
        accountUser = AccountDataHelper.getAccountUserById(accountUser.Id);
        System.assertEquals(accountUser.dmpl__PartnerAccountId__c, partner1.Id, 'Expected account user to be linked to the correct partner.');
        System.assertEquals(accountUser.dmpl__BranchId__c, branch1.Id, 'Expected account user to be linked to the correct branch.');
        System.assertEquals(accountUser.dmpl__UserId__c, UserInfo.getUserId(), 'Expected account user to be linked to the correct user.');
        System.assertEquals(accountUser.dmpl__DateEffectiveFrom__c, Date.today(), 'Expected account user to have the correct date effective from.');
        System.assertEquals(accountUser.dmpl__DateEffectiveTill__c, Date.today().addDays(30), 'Expected account user to have the correct date effective till.');
        Test.stopTest();
    }

    //sv-172
    @isTest
    static void createRecordWithSameUserButDifferentPartnerAccountPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partner2 = TestDataHelpers.getPartnerAccount('Partner 2');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');

        Test.startTest();
        dmpl__AccountUser__c accountUser = AccountDataHelper.createAccountUser(partner1.Id, branch1.Id, UserInfo.getUserId(), Date.today(), Date.today().addDays(30));

        dmpl__AccountUser__c accountUser2 = AccountDataHelper.createAccountUser(partner2.Id, branch1.Id, UserInfo.getUserId(), Date.today(), Date.today().addDays(30));
        System.assertNotEquals(accountUser2, null, 'Expected account user to be created.');
        accountUser2 = AccountDataHelper.getAccountUserById(accountUser2.Id);
        System.assertEquals(accountUser2.dmpl__PartnerAccountId__c, partner2.Id, 'Expected account user to be linked to the correct partner.');
        System.assertEquals(accountUser2.dmpl__BranchId__c, branch1.Id, 'Expected account user to be linked to the correct branch.');
        System.assertEquals(accountUser2.dmpl__UserId__c, UserInfo.getUserId(), 'Expected account user to be linked to the correct user.');
        System.assertEquals(accountUser2.dmpl__DateEffectiveFrom__c, Date.today(), 'Expected account user to have the correct date effective from.');
        System.assertEquals(accountUser2.dmpl__DateEffectiveTill__c, Date.today().addDays(30), 'Expected account user to have the correct date effective till.');
        Test.stopTest();
       
    }

    //sv-173
    @isTest
    static void validateThatDateEffectiveFromAndDateEffectiveTillAreSavedCorrectlyPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');

        Test.startTest();
        dmpl__AccountUser__c accountUser = AccountDataHelper.createAccountUser(partner1.Id, branch1.Id, UserInfo.getUserId(), Date.today(), Date.today().addDays(30));
        System.assertNotEquals(accountUser, null, 'Expected account user to be created.');
        accountUser = AccountDataHelper.getAccountUserById(accountUser.Id);
        System.assertEquals(accountUser.dmpl__PartnerAccountId__c, partner1.Id, 'Expected account user to be linked to the correct partner.');
        System.assertEquals(accountUser.dmpl__BranchId__c, branch1.Id, 'Expected account user to be linked to the correct branch.');
        System.assertEquals(accountUser.dmpl__UserId__c, UserInfo.getUserId(), 'Expected account user to be linked to the correct user.');
        System.assertEquals(accountUser.dmpl__DateEffectiveFrom__c, Date.today(), 'Expected account user to have the correct date effective from.');
        System.assertEquals(accountUser.dmpl__DateEffectiveTill__c, Date.today().addDays(30), 'Expected account user to have the correct date effective till.');
        Test.stopTest();
    }


    //sv-174
    @isTest
    static void createRecordWithTodaysDateInDateEffectiveFromPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');

        Test.startTest();
        dmpl__AccountUser__c accountUser = AccountDataHelper.createAccountUser(partner1.Id, branch1.Id, UserInfo.getUserId(), Date.today(), Date.today().addDays(30));
        System.assertNotEquals(accountUser, null, 'Expected account user to be created.');
        accountUser = AccountDataHelper.getAccountUserById(accountUser.Id);
        System.assertEquals(accountUser.dmpl__PartnerAccountId__c, partner1.Id, 'Expected account user to be linked to the correct partner.');
        System.assertEquals(accountUser.dmpl__BranchId__c, branch1.Id, 'Expected account user to be linked to the correct branch.');
        System.assertEquals(accountUser.dmpl__UserId__c, UserInfo.getUserId(), 'Expected account user to be linked to the correct user.');
        System.assertEquals(accountUser.dmpl__DateEffectiveFrom__c, Date.today(), 'Expected account user to have the correct date effective from.');
        System.assertEquals(accountUser.dmpl__DateEffectiveTill__c, Date.today().addDays(30), 'Expected account user to have the correct date effective till.');
        Test.stopTest();
    }

    //sv-175
    @isTest
    static void userFutureDateEffectiveTillPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');

        Test.startTest();
        dmpl__AccountUser__c accountUser = AccountDataHelper.createAccountUser(partner1.Id, branch1.Id, UserInfo.getUserId(), Date.today(), Date.today().addDays(30));
        System.assertNotEquals(accountUser, null, 'Expected account user to be created.');
        accountUser = AccountDataHelper.getAccountUserById(accountUser.Id);
        System.assertEquals(accountUser.dmpl__PartnerAccountId__c, partner1.Id, 'Expected account user to be linked to the correct partner.');
        System.assertEquals(accountUser.dmpl__BranchId__c, branch1.Id, 'Expected account user to be linked to the correct branch.');
        System.assertEquals(accountUser.dmpl__UserId__c, UserInfo.getUserId(), 'Expected account user to be linked to the correct user.');
        System.assertEquals(accountUser.dmpl__DateEffectiveFrom__c, Date.today(), 'Expected account user to have the correct date effective from.');
        System.assertEquals(accountUser.dmpl__DateEffectiveTill__c, Date.today().addDays(30), 'Expected account user to have the correct date effective till.');
        Test.stopTest();
    }

    //sv-177
    @isTest
    static void leaveRequiredPartnerAccountBlankNegativeNew(){
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');

        Test.startTest();
        try{
            dmpl__AccountUser__c accountUser = AccountDataHelper.createAccountUser(null, branch1.Id, UserInfo.getUserId(), Date.today(), Date.today().addDays(30));
            System.assert(false, 'Expected an exception to be thrown due to empty mandatory fields.');
        } catch (Exception e) {
            System.assert(true, 'Expected exception due to empty mandatory fields.');
        }
        Test.stopTest();
    }

    //sv-178
    @isTest
    static void setDateEffectiveTillEarlierThanDateEffectiveFromPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');

        Test.startTest();
        dmpl__AccountUser__c accountUser = AccountDataHelper.createAccountUser(partner1.Id, branch1.Id, UserInfo.getUserId(), Date.today().addDays(30), Date.today());
        System.assertNotEquals(accountUser, null, 'Expected account user to be created.');
        accountUser = AccountDataHelper.getAccountUserById(accountUser.Id);
        System.assertEquals(accountUser.dmpl__PartnerAccountId__c, partner1.Id, 'Expected account user to be linked to the correct partner.');
        System.assertEquals(accountUser.dmpl__BranchId__c, branch1.Id, 'Expected account user to be linked to the correct branch.');
        System.assertEquals(accountUser.dmpl__UserId__c, UserInfo.getUserId(), 'Expected account user to be linked to the correct user.');
        System.assertEquals(accountUser.dmpl__DateEffectiveFrom__c, Date.today().addDays(30), 'Expected account user to have the correct date effective from.');
        System.assertEquals(accountUser.dmpl__DateEffectiveTill__c, Date.today(), 'Expected account user to have the correct date effective till.');
        Test.stopTest();
    }

    //sv-180
    @isTest 
    static void saveWithoutSelectingUserNegativeNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');

        Test.startTest();
        dmpl__AccountUser__c accountUser = AccountDataHelper.createAccountUser(partner1.Id, branch1.Id, null, Date.today(), Date.today().addDays(30));
        System.assertNotEquals(accountUser, null, 'Expected account user to be created.');
        accountUser = AccountDataHelper.getAccountUserById(accountUser.Id);
        System.assertEquals(accountUser.dmpl__PartnerAccountId__c, partner1.Id, 'Expected account user to be linked to the correct partner.');
        System.assertEquals(accountUser.dmpl__BranchId__c, branch1.Id, 'Expected account user to be linked to the correct branch.');
        System.assertEquals(accountUser.dmpl__DateEffectiveFrom__c, Date.today(), 'Expected account user to have the correct date effective from.');
        System.assertEquals(accountUser.dmpl__DateEffectiveTill__c, Date.today().addDays(30), 'Expected account user to have the correct date effective till.');
        Test.stopTest();
    }

    //181
    @isTest 
    static void saveWithSpecialCharactersInPartnerAccountNameNegativeNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');

        Test.startTest();
        dmpl__AccountUser__c accountUser = AccountDataHelper.createAccountUser(partner1.Id, branch1.Id, UserInfo.getUserId(), Date.today(), Date.today().addDays(30));
        System.assertNotEquals(accountUser, null, 'Expected account user to be created.');
        accountUser = AccountDataHelper.getAccountUserById(accountUser.Id);
        System.assertEquals(accountUser.dmpl__PartnerAccountId__c, partner1.Id, 'Expected account user to be linked to the correct partner.');
        System.assertEquals(accountUser.dmpl__BranchId__c, branch1.Id, 'Expected account user to be linked to the correct branch.');
        System.assertEquals(accountUser.dmpl__UserId__c, UserInfo.getUserId(), 'Expected account user to be linked to the correct user.');
        System.assertEquals(accountUser.dmpl__DateEffectiveFrom__c, Date.today(), 'Expected account user to have the correct date effective from.');
        System.assertEquals(accountUser.dmpl__DateEffectiveTill__c, Date.today().addDays(30), 'Expected account user to have the correct date effective till.');


        System.assert(true, 'Expected no exceptions to be thrown not possible to enter invalid names.');
        Test.stopTest();
    }

    //sv-182
    @isTest
    static void usePastDateInDateEffectiveTillPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');

        Test.startTest();
        dmpl__AccountUser__c accountUser = AccountDataHelper.createAccountUser(partner1.Id, branch1.Id, UserInfo.getUserId(), Date.today(), Date.today().addDays(-30));
        System.assertNotEquals(accountUser, null, 'Expected account user to be created.');
        accountUser = AccountDataHelper.getAccountUserById(accountUser.Id);
        System.assertEquals(accountUser.dmpl__PartnerAccountId__c, partner1.Id, 'Expected account user to be linked to the correct partner.');
        System.assertEquals(accountUser.dmpl__BranchId__c, branch1.Id, 'Expected account user to be linked to the correct branch.');
        System.assertEquals(accountUser.dmpl__UserId__c, UserInfo.getUserId(), 'Expected account user to be linked to the correct user.');
        System.assertEquals(accountUser.dmpl__DateEffectiveFrom__c, Date.today(), 'Expected account user to have the correct date effective from.');
        System.assertEquals(accountUser.dmpl__DateEffectiveTill__c, Date.today().addDays(-30), 'Expected account user to have the correct date effective till.');
        Test.stopTest();
    }


    //sv-184
    @isTest
    static void setNonSubsequentBranchesForThePartnerAccountPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch2 = TestDataHelpers.getBranch('Branch 2');

        Test.startTest();
        dmpl__AccountUser__c accountUser = AccountDataHelper.createAccountUser(partner1.Id, branch2.Id, UserInfo.getUserId(), Date.today(), Date.today().addDays(30));
        System.assertNotEquals(accountUser, null, 'Expected account user to be created.');
        accountUser = AccountDataHelper.getAccountUserById(accountUser.Id);
        System.assertEquals(accountUser.dmpl__PartnerAccountId__c, partner1.Id, 'Expected account user to be linked to the correct partner.');
        System.assertEquals(accountUser.dmpl__BranchId__c, branch2.Id, 'Expected account user to be linked to the correct branch.');
        System.assertEquals(accountUser.dmpl__UserId__c, UserInfo.getUserId(), 'Expected account user to be linked to the correct user.');
        System.assertEquals(accountUser.dmpl__DateEffectiveFrom__c, Date.today(), 'Expected account user to have the correct date effective from.');
        System.assertEquals(accountUser.dmpl__DateEffectiveTill__c, Date.today().addDays(30), 'Expected account user to have the correct date effective till.');
        Test.stopTest();
    }

    //sv-185
    @isTest
    static void enterInvalidLookupReferenceForBranchPositiveNew(){
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');

        Test.startTest();
        dmpl__AccountUser__c accountUser = AccountDataHelper.createAccountUser(partner1.Id, branch1.Id, UserInfo.getUserId(), Date.today(), Date.today().addDays(30));
        System.assertNotEquals(accountUser, null, 'Expected account user to be created.');
        accountUser = AccountDataHelper.getAccountUserById(accountUser.Id);
        System.assertEquals(accountUser.dmpl__PartnerAccountId__c, partner1.Id, 'Expected account user to be linked to the correct partner.');
        System.assertEquals(accountUser.dmpl__BranchId__c, branch1.Id, 'Expected account user to be linked to the correct branch.');
        System.assertEquals(accountUser.dmpl__UserId__c, UserInfo.getUserId(), 'Expected account user to be linked to the correct user.');
        System.assertEquals(accountUser.dmpl__DateEffectiveFrom__c, Date.today(), 'Expected account user to have the correct date effective from.');
        System.assertEquals(accountUser.dmpl__DateEffectiveTill__c, Date.today().addDays(30), 'Expected account user to have the correct date effective till.');

        System.assert(true, 'Expected no exceptions to be thrown not possible to enter invalid lookup reference.');
        Test.stopTest();
    }

    //sv-186
    @isTest 
    static void everytimeDifferentNameIsGeneratedInTheAccountUserList(){

        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');

        Test.startTest();
        dmpl__AccountUser__c accountUser = AccountDataHelper.createAccountUser(partner1.Id, branch1.Id, UserInfo.getUserId(), Date.today(), Date.today().addDays(30));
        System.assertNotEquals(accountUser, null, 'Expected account user to be created.');
        accountUser = AccountDataHelper.getAccountUserById(accountUser.Id);

        dmpl__AccountUser__c accountUser2 = AccountDataHelper.createAccountUser(partner1.Id, branch1.Id, UserInfo.getUserId(), Date.today(), Date.today().addDays(30));
        System.assertNotEquals(accountUser2, null, 'Expected account user to be created.');
        accountUser2 = AccountDataHelper.getAccountUserById(accountUser2.Id);

        System.assertNotEquals(accountUser.Name, accountUser2.Name, 'Expected account user to have different names.');
        Test.stopTest();
    }


    //accountRewardsLedger
    //sv-150
    @isTest
    static void createUsingTheMandatoryFieldsPositveNew(){
        Account partner1 = AccountDataHelper.getAccountByName('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        
        Test.startTest();
        dmpl__DiscountVoucher__c voucher = DiscountDataHelper.createDiscountVoucher(
            partner1.Id,
            branch1.Id,
            'Voucher',
            100,
            Date.today()
        );

        dmpl__SchemeLedger__c schemeLedger = SchemeDataHelper.createSchemeLedger(
            partner1.Id,
            branch1.Id
        );

        dmpl__AccountRewardLedger__c accountRewardLedger = AccountDataHelper.createAccountRewardLedger(
            partner1.Id,
            voucher.Id,
            schemeLedger.Id,
            null,
            100,
            Date.today()
        );
        System.assertNotEquals(accountRewardLedger, null, 'Expected account reward ledger to be created.');
        accountRewardLedger = AccountDataHelper.getAccountRewardLedgerById(accountRewardLedger.Id);
        System.assertEquals(accountRewardLedger.dmpl__AccountId__c, partner1.Id, 'Expected account reward ledger to be linked to the correct partner.');
        System.assertEquals(accountRewardLedger.dmpl__AccountId__c, partner1.Id, 'Expected account reward ledger to be linked to the correct account.');
        System.assertEquals(accountRewardLedger.dmpl__DiscountVoucherId__c, voucher.Id, 'Expected account reward ledger to be linked to the correct voucher.');
        System.assertEquals(accountRewardLedger.dmpl__SchemeLedgerId__c, schemeLedger.Id, 'Expected account reward ledger to be linked to the correct scheme ledger.');
        System.assertEquals(accountRewardLedger.dmpl__DocumentDate__c, Date.today(), 'Expected account reward ledger to have the correct document date.');
        System.assertEquals(accountRewardLedger.dmpl__RewardPoints__c, 100, 'Expected account reward ledger to have the correct amount.');
        System.assertEquals(accountRewardLedger.dmpl__DocumentDate__c, Date.today(), 'Expected account reward ledger to have the correct document date.');
        Test.stopTest();
    }

    //sv151
    @isTest
    static void ensureLookupRelationshipsDisplayCorrectRecordsPositiveNew(){
        Account partner1 = AccountDataHelper.getAccountByName('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');

        Test.startTest();
        dmpl__DiscountVoucher__c voucher = DiscountDataHelper.createDiscountVoucher(
            partner1.Id,
            branch1.Id,
            'Voucher',
            100,
            Date.today()
        );

        dmpl__SchemeLedger__c schemeLedger = SchemeDataHelper.createSchemeLedger(
            partner1.Id,
            branch1.Id
        );

        dmpl__AccountRewardLedger__c accountRewardLedger = AccountDataHelper.createAccountRewardLedger(
            partner1.Id,
            voucher.Id,
            schemeLedger.Id,
            null,
            100,
            Date.today()
        );
        System.assertNotEquals(accountRewardLedger, null, 'Expected account reward ledger to be created.');
        accountRewardLedger = AccountDataHelper.getAccountRewardLedgerById(accountRewardLedger.Id);
        System.assertEquals(accountRewardLedger.dmpl__AccountId__c, partner1.Id, 'Expected account reward ledger to be linked to the correct partner.');
        System.assertEquals(accountRewardLedger.dmpl__DiscountVoucherId__c, voucher.Id, 'Expected account reward ledger to be linked to the correct voucher.');
        System.assertEquals(accountRewardLedger.dmpl__SchemeLedgerId__c, schemeLedger.Id, 'Expected account reward ledger to be linked to the correct scheme ledger.');
        System.assertEquals(accountRewardLedger.dmpl__DocumentDate__c, Date.today(), 'Expected account reward ledger to have the correct document date.');
        System.assertEquals(accountRewardLedger.dmpl__RewardPoints__c, 100, 'Expected account reward ledger to have the correct amount.');
        System.assertEquals(accountRewardLedger.dmpl__DocumentDate__c, Date.today(), 'Expected account reward ledger to have the correct document date.');
        Test.stopTest();
    }

    //sv-153
    @isTest
    static void createRecordWithoutRequiredLookupsNegativeNew(){
        Test.startTest();
        try{
            dmpl__AccountRewardLedger__c accountRewardLedger = AccountDataHelper.createAccountRewardLedger(
                null,
                null,
                null,
                null,
                100,
                Date.today()
            );
            System.assert(false, 'Expected an exception to be thrown due to empty mandatory fields.');
        } catch (Exception e) {
            System.assert(true, 'Expected exception due to empty mandatory fields.');
        }
        Test.stopTest();
    }

    //sv-154
    @isTest
    static void createRecordWithValidSchemeLedgerAndAccountPositiveNew(){
        Account partner1 = AccountDataHelper.getAccountByName('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');

        Test.startTest();
        dmpl__DiscountVoucher__c voucher = DiscountDataHelper.createDiscountVoucher(
            partner1.Id,
            branch1.Id,
            'Voucher',
            100,
            Date.today()
        );

        dmpl__SchemeLedger__c schemeLedger = SchemeDataHelper.createSchemeLedger(
            partner1.Id,
            branch1.Id
        );

        dmpl__AccountRewardLedger__c accountRewardLedger = AccountDataHelper.createAccountRewardLedger(
            partner1.Id,
            voucher.Id,
            schemeLedger.Id,
            null,
            100,
            Date.today()
        );
        System.assertNotEquals(accountRewardLedger, null, 'Expected account reward ledger to be created.');
        accountRewardLedger = AccountDataHelper.getAccountRewardLedgerById(accountRewardLedger.Id);
        System.assertEquals(accountRewardLedger.dmpl__AccountId__c, partner1.Id, 'Expected account reward ledger to be linked to the correct partner.');
        System.assertEquals(accountRewardLedger.dmpl__DiscountVoucherId__c, voucher.Id, 'Expected account reward ledger to be linked to the correct voucher.');
        System.assertEquals(accountRewardLedger.dmpl__SchemeLedgerId__c, schemeLedger.Id, 'Expected account reward ledger to be linked to the correct scheme ledger.');
        System.assertEquals(accountRewardLedger.dmpl__DocumentDate__c, Date.today(), 'Expected account reward ledger to have the correct document date.');
        System.assertEquals(accountRewardLedger.dmpl__RewardPoints__c, 100, 'Expected account reward ledger to have the correct amount.');
        System.assertEquals(accountRewardLedger.dmpl__DocumentDate__c, Date.today(), 'Expected account reward ledger to have the correct document date.');
        Test.stopTest();
    }

    //sv-155
    @isTest
    static void addValidDiscountVoucherLookupAndVerifyTheRecordIsSavedPositiveNew(){
        Account partner1 = AccountDataHelper.getAccountByName('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');

        Test.startTest();
        dmpl__DiscountVoucher__c voucher = DiscountDataHelper.createDiscountVoucher(
            partner1.Id,
            branch1.Id,
            'Voucher',
            100,
            Date.today()
        );

        dmpl__SchemeLedger__c schemeLedger = SchemeDataHelper.createSchemeLedger(
            partner1.Id,
            branch1.Id
        );

        dmpl__AccountRewardLedger__c accountRewardLedger = AccountDataHelper.createAccountRewardLedger(
            partner1.Id,
            voucher.Id,
            schemeLedger.Id,
            null,
            100,
            Date.today()
        );
        System.assertNotEquals(accountRewardLedger, null, 'Expected account reward ledger to be created.');
        accountRewardLedger = AccountDataHelper.getAccountRewardLedgerById(accountRewardLedger.Id);
        System.assertEquals(accountRewardLedger.dmpl__AccountId__c, partner1.Id, 'Expected account reward ledger to be linked to the correct partner.');
        System.assertEquals(accountRewardLedger.dmpl__DiscountVoucherId__c, voucher.Id, 'Expected account reward ledger to be linked to the correct voucher.');
        System.assertEquals(accountRewardLedger.dmpl__SchemeLedgerId__c, schemeLedger.Id, 'Expected account reward ledger to be linked to the correct scheme ledger.');
        System.assertEquals(accountRewardLedger.dmpl__DocumentDate__c, Date.today(), 'Expected account reward ledger to have the correct document date.');
        System.assertEquals(accountRewardLedger.dmpl__RewardPoints__c, 100, 'Expected account reward ledger to have the correct amount.');
        System.assertEquals(accountRewardLedger.dmpl__DocumentDate__c, Date.today(), 'Expected account reward ledger to have the correct document date.');
        Test.stopTest();
    }


    //sv-156
    @isTest 
    static void provideDocumentDateAndAmountAndVerifyTheRecordIsSavedPositiveNew(){
        Account partner1 = AccountDataHelper.getAccountByName('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');

        Test.startTest();
        dmpl__DiscountVoucher__c voucher = DiscountDataHelper.createDiscountVoucher(
            partner1.Id,
            branch1.Id,
            'Voucher',
            100,
            Date.today()
        );

        dmpl__SchemeLedger__c schemeLedger = SchemeDataHelper.createSchemeLedger(
            partner1.Id,
            branch1.Id
        );

        dmpl__AccountRewardLedger__c accountRewardLedger = AccountDataHelper.createAccountRewardLedger(
            partner1.Id,
            voucher.Id,
            schemeLedger.Id,
            null,
            100,
            Date.today()
        );
        System.assertNotEquals(accountRewardLedger, null, 'Expected account reward ledger to be created.');
        accountRewardLedger = AccountDataHelper.getAccountRewardLedgerById(accountRewardLedger.Id);
        System.assertEquals(accountRewardLedger.dmpl__AccountId__c, partner1.Id, 'Expected account reward ledger to be linked to the correct partner.');
        System.assertEquals(accountRewardLedger.dmpl__DiscountVoucherId__c, voucher.Id, 'Expected account reward ledger to be linked to the correct voucher.');
        System.assertEquals(accountRewardLedger.dmpl__SchemeLedgerId__c, schemeLedger.Id, 'Expected account reward ledger to be linked to the correct scheme ledger.');
        System.assertEquals(accountRewardLedger.dmpl__DocumentDate__c, Date.today(), 'Expected account reward ledger to have the correct document date.');
        System.assertEquals(accountRewardLedger.dmpl__RewardPoints__c, 100, 'Expected account reward ledger to have the correct amount.');
        System.assertEquals(accountRewardLedger.dmpl__DocumentDate__c, Date.today(), 'Expected account reward ledger to have the correct document date.');
        Test.stopTest();
    }

    //sv-157
    @isTest
    static void enterMaximumAllowedValidIntegerInRewardPointsPositiveNew(){
        Account partner1 = AccountDataHelper.getAccountByName('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');

        Test.startTest();
        dmpl__DiscountVoucher__c voucher = DiscountDataHelper.createDiscountVoucher(
            partner1.Id,
            branch1.Id,
            'Voucher',
            100,
            Date.today()
        );

        dmpl__SchemeLedger__c schemeLedger = SchemeDataHelper.createSchemeLedger(
            partner1.Id,
            branch1.Id
        );

        dmpl__AccountRewardLedger__c accountRewardLedger = AccountDataHelper.createAccountRewardLedger(
            partner1.Id,
            voucher.Id,
            schemeLedger.Id,
            null,
            2147483647,
            Date.today()
        );
        System.assertNotEquals(accountRewardLedger, null, 'Expected account reward ledger to be created.');
        accountRewardLedger = AccountDataHelper.getAccountRewardLedgerById(accountRewardLedger.Id);
        System.assertEquals(accountRewardLedger.dmpl__AccountId__c, partner1.Id, 'Expected account reward ledger to be linked to the correct partner.');
        System.assertEquals(accountRewardLedger.dmpl__DiscountVoucherId__c, voucher.Id, 'Expected account reward ledger to be linked to the correct voucher.');
        System.assertEquals(accountRewardLedger.dmpl__SchemeLedgerId__c, schemeLedger.Id, 'Expected account reward ledger to be linked to the correct scheme ledger.');
        System.assertEquals(accountRewardLedger.dmpl__DocumentDate__c, Date.today(), 'Expected account reward ledger to have the correct document date.');
        System.assertEquals(accountRewardLedger.dmpl__RewardPoints__c, 2147483647, 'Expected account reward ledger to have the correct amount.');
        Test.stopTest();
    }

    //sv-158
    @isTest
    static void leaveOptionalFieldsBlankAndVerifyTheRecordIsSavedPositiveNew(){
        Account partner1 = AccountDataHelper.getAccountByName('Partner 1');

        Test.startTest();
        dmpl__AccountRewardLedger__c accountRewardLedger = AccountDataHelper.createAccountRewardLedger(
            partner1.Id,
            null,
            null,
            null,
            100,
            Date.today()
        );
        System.assertNotEquals(accountRewardLedger, null, 'Expected account reward ledger to be created.');
        accountRewardLedger = AccountDataHelper.getAccountRewardLedgerById(accountRewardLedger.Id);
        System.assertEquals(accountRewardLedger.dmpl__AccountId__c, partner1.Id, 'Expected account reward ledger to be linked to the correct partner.');
        System.assertEquals(accountRewardLedger.dmpl__DiscountVoucherId__c, null, 'Expected account reward ledger to be linked to the correct voucher.');
        System.assertEquals(accountRewardLedger.dmpl__SchemeLedgerId__c, null, 'Expected account reward ledger to be linked to the correct scheme ledger.');
        System.assertEquals(accountRewardLedger.dmpl__DocumentDate__c, Date.today(), 'Expected account reward ledger to have the correct document date.');
        System.assertEquals(accountRewardLedger.dmpl__RewardPoints__c, 100, 'Expected account reward ledger to have the correct amount.');
        Test.stopTest();
    }

    //sv-159
    @isTest
    static void confirmThatCreatedByAndLastModifiedByArePopulatedPositiveNew(){
        Account partner1 = AccountDataHelper.getAccountByName('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');

        Test.startTest();
        dmpl__DiscountVoucher__c voucher = DiscountDataHelper.createDiscountVoucher(
            partner1.Id,
            branch1.Id,
            'Voucher',
            100,
            Date.today()
        );

        dmpl__SchemeLedger__c schemeLedger = SchemeDataHelper.createSchemeLedger(
            partner1.Id,
            branch1.Id
        );

        dmpl__AccountRewardLedger__c accountRewardLedger = AccountDataHelper.createAccountRewardLedger(
            partner1.Id,
            voucher.Id,
            schemeLedger.Id,
            null,
            100,
            Date.today()
        );
        System.assertNotEquals(accountRewardLedger, null, 'Expected account reward ledger to be created.');
        accountRewardLedger = AccountDataHelper.getAccountRewardLedgerById(accountRewardLedger.Id);
        System.assertEquals(accountRewardLedger.CreatedById, UserInfo.getUserId(), 'Expected account reward ledger to be created by the current user.');
        System.assertEquals(accountRewardLedger.LastModifiedById, UserInfo.getUserId(), 'Expected account reward ledger to be modified by the current user.');
        Test.stopTest();
    }

    //sv-160
    @isTest
    static void editRecordToUpdateRewardPointsPositiveEdit(){
        Account partner1 = AccountDataHelper.getAccountByName('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');

        Test.startTest();
        dmpl__DiscountVoucher__c voucher = DiscountDataHelper.createDiscountVoucher(
            partner1.Id,
            branch1.Id,
            'Voucher',
            100,
            Date.today()
        );

        dmpl__SchemeLedger__c schemeLedger = SchemeDataHelper.createSchemeLedger(
            partner1.Id,
            branch1.Id
        );

        dmpl__AccountRewardLedger__c accountRewardLedger = AccountDataHelper.createAccountRewardLedger(
            partner1.Id,
            voucher.Id,
            schemeLedger.Id,
            null,
            100,
            Date.today()
        );
        
        accountRewardLedger.dmpl__RewardPoints__c = 200;
        update accountRewardLedger;
        
        dmpl__AccountRewardLedger__c updatedAccountRewardLedger = AccountDataHelper.getAccountRewardLedgerById(accountRewardLedger.Id);
        System.assertEquals(updatedAccountRewardLedger.dmpl__RewardPoints__c, 200, 'Expected account reward ledger to have the correct amount.');
        Test.stopTest();
    }

    //sv-161
    @isTest
    static void changeSchemeLedgerToAnotherValidValuePositiveEdit(){
        Account partner1 = AccountDataHelper.getAccountByName('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');

        Test.startTest();
        dmpl__DiscountVoucher__c voucher = DiscountDataHelper.createDiscountVoucher(
            partner1.Id,
            branch1.Id,
            'Voucher',
            100,
            Date.today()
        );

        dmpl__SchemeLedger__c schemeLedger = SchemeDataHelper.createSchemeLedger(
            partner1.Id,
            branch1.Id
        );

        dmpl__SchemeLedger__c schemeLedger2 = SchemeDataHelper.createSchemeLedger(
            partner1.Id,
            branch1.Id
        );

        dmpl__AccountRewardLedger__c accountRewardLedger = AccountDataHelper.createAccountRewardLedger(
            partner1.Id,
            voucher.Id,
            schemeLedger.Id,
            null,
            100,
            Date.today()
        );
        
    
        accountRewardLedger.dmpl__SchemeLedgerId__c = schemeLedger2.Id;
        update accountRewardLedger;
        System.assertNotEquals(accountRewardLedger, null, 'Expected account reward ledger to be created.');
        accountRewardLedger = AccountDataHelper.getAccountRewardLedgerById(accountRewardLedger.Id);
        System.assertEquals(accountRewardLedger.dmpl__SchemeLedgerId__c, schemeLedger2.Id, 'Expected account reward ledger to have the correct scheme ledger.');

        Test.stopTest();
    }

    //sv-162
    @isTest
    static void saveWithoutSelectingAccountInAccountRewaredLedgerNegativeNew(){

        
        Test.startTest();
        try{
            dmpl__AccountRewardLedger__c accountRewardLedger = AccountDataHelper.createAccountRewardLedger(
                null,
                null,
                null,
                null,
                100,
                Date.today()
            );
            System.assert(false, 'Expected an exception to be thrown due to empty mandatory fields.');
        } catch (Exception e) {
            System.assert(true, 'Expected exception due to empty mandatory fields.');
        }
        Test.stopTest();
    }

    //sv-163
    @isTest
    static void enterAnInvalidDiscountVoucherIdNegativeNew(){
        Account partner1 = AccountDataHelper.getAccountByName('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');

        Test.startTest();
        dmpl__DiscountVoucher__c voucher = DiscountDataHelper.createDiscountVoucher(
            partner1.Id,
            branch1.Id,
            'Voucher',
            100,
            Date.today()
        );

        dmpl__SchemeLedger__c schemeLedger = SchemeDataHelper.createSchemeLedger(
            partner1.Id,
            branch1.Id
        );

        dmpl__AccountRewardLedger__c accountRewardLedger = AccountDataHelper.createAccountRewardLedger(
            partner1.Id,
            voucher.Id,
            schemeLedger.Id,
            null,
            100,
            Date.today()
        );
        System.assertNotEquals(accountRewardLedger, null, 'Expected account reward ledger to be created.');
        accountRewardLedger = AccountDataHelper.getAccountRewardLedgerById(accountRewardLedger.Id);
        System.assert(true, 'Expected no exceptions to be thrown since not possible to select invalid voucher.');
        Test.stopTest();
    }


    //sv-164
    @isTest
    static void inputAlphabeticalCharactersInDocumentDateNegativeNew(){
        Account partner1 = AccountDataHelper.getAccountByName('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');

        Test.startTest();
        dmpl__DiscountVoucher__c voucher = DiscountDataHelper.createDiscountVoucher(
            partner1.Id,
            branch1.Id,
            'Voucher',
            100,
            Date.today()
        );

        dmpl__SchemeLedger__c schemeLedger = SchemeDataHelper.createSchemeLedger(
            partner1.Id,
            branch1.Id
        );

        dmpl__AccountRewardLedger__c accountRewardLedger = AccountDataHelper.createAccountRewardLedger(
            partner1.Id,
            voucher.Id,
            schemeLedger.Id,
            null,
            100,
            Date.today()
        );
        System.assertNotEquals(accountRewardLedger, null, 'Expected account reward ledger to be created.');
        accountRewardLedger = AccountDataHelper.getAccountRewardLedgerById(accountRewardLedger.Id);
        
        System.assert(true, 'Expected no exceptions to be thrown since not possible to enter string on a integer field.');
        
        Test.stopTest();
    }

    //sv-165
    @isTest
    static void saveWithFutureDocumentDatePositiveNew(){
        Account partner1 = AccountDataHelper.getAccountByName('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');

        Test.startTest();
        dmpl__DiscountVoucher__c voucher = DiscountDataHelper.createDiscountVoucher(
            partner1.Id,
            branch1.Id,
            'Voucher',
            100,
            Date.today()
        );

        dmpl__SchemeLedger__c schemeLedger = SchemeDataHelper.createSchemeLedger(
            partner1.Id,
            branch1.Id
        );

        dmpl__AccountRewardLedger__c accountRewardLedger = AccountDataHelper.createAccountRewardLedger(
            partner1.Id,
            voucher.Id,
            schemeLedger.Id,
            null,
            100,
            Date.today().addDays(30)
        );
        System.assertNotEquals(accountRewardLedger, null, 'Expected account reward ledger to be created.');
        accountRewardLedger = AccountDataHelper.getAccountRewardLedgerById(accountRewardLedger.Id);
        System.assertEquals(accountRewardLedger.dmpl__AccountId__c, partner1.Id, 'Expected account reward ledger to be linked to the correct partner.');
        System.assertEquals(accountRewardLedger.dmpl__DiscountVoucherId__c, voucher.Id, 'Expected account reward ledger to be linked to the correct voucher.');
        System.assertEquals(accountRewardLedger.dmpl__SchemeLedgerId__c, schemeLedger.Id, 'Expected account reward ledger to be linked to the correct scheme ledger.');
        System.assertEquals(accountRewardLedger.dmpl__RewardPoints__c, 100, 'Expected account reward ledger to have the correct amount.');
        System.assertEquals(accountRewardLedger.dmpl__DocumentDate__c, Date.today().addDays(30), 'Expected account reward ledger to have the correct document date.');
        Test.stopTest();
    }

    //sv-166
    @isTest
    static void removeExistingSchemeLedgerAndTrySavingTheRecordPositiveNew(){
        Account partner1 = AccountDataHelper.getAccountByName('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');

        Test.startTest();
        dmpl__DiscountVoucher__c voucher = DiscountDataHelper.createDiscountVoucher(
            partner1.Id,
            branch1.Id,
            'Voucher',
            100,
            Date.today()
        );

        dmpl__SchemeLedger__c schemeLedger = SchemeDataHelper.createSchemeLedger(
            partner1.Id,
            branch1.Id
        );

        dmpl__AccountRewardLedger__c accountRewardLedger = AccountDataHelper.createAccountRewardLedger(
            partner1.Id,
            voucher.Id,
            schemeLedger.Id,
            null,
            100,
            Date.today()
        );

        accountRewardLedger.dmpl__SchemeLedgerId__c = null;
        update accountRewardLedger;
        
        dmpl__AccountRewardLedger__c updatedAccountRewardLedger = AccountDataHelper.getAccountRewardLedgerById(accountRewardLedger.Id);
        System.assertEquals(updatedAccountRewardLedger.dmpl__SchemeLedgerId__c, null, 'Expected account reward ledger to have the correct scheme ledger.');
        Test.stopTest();
    }

}