@isTest
public class SchemeReapirOrder_Test {
    
    // @testSetup
    // public static void Setup()
    // {
    //         CreateAccountGroup();
    //         CreateAccount();
    //         CreateBranch();
    //         CreateItemGroup(); 
    //         CreateItems();
    //         CreateSKu();
    //         CreateResource();
    //         CreateTaxGroup();
    //         CreateAsset();
    //         CreateScheme();
    //         CreateSchemeLine();
    //         CreateSchemeCondition();
    //         CreateSchemeBenefits();
    //         CreateRepairOrder();              
    //         CreateRepairOrderLine();
    //     }
        
    
    
    // @isTest
    // Static void getTotalQuantity()
    // {
    //     test.startTest();
    //     List<AggregateResult> agg = [SELECT
    //                                  ItemId__c,
    //                                  SKUId__c,
    //                                  ItemId__r.SchemeItemGroupId__c,
    //                                  SUM(Quantity__c) TotalQuantity,
    //                                  SUM(Amount__c) TotalAmount
    //                                  FROM
    //                                  dmpl__RepairOrderLine__c
    //                                  GROUP BY
    //                                  ItemId__c,
    //                                  SKUId__c,
    //                                  ItemId__r.SchemeItemGroupId__c
    //                                 ];
        
    //     SchemeHelperRepairOrder.getTotalQuantity(agg);
    //     test.stopTest();
    //     System.assert(agg != null, 'Test agg are found');
    // }
    
    // @isTest
    // Static void evaluatePerOrderCondition()
    // {
    //     test.startTest();
    //     dmpl__SchemeCondition__c condition = [Select dmpl__AccountId__c, dmpl__SchemeId__c,dmpl__ItemId__c,dmpl__ItemGroupId__c,dmpl__AccountGroupId__c,dmpl__ItemSKUId__c,dmpl__ConditionType__c,dmpl__ConditionQuantity__c,dmpl__ConditionValue__c,dmpl__SequenceNumber__c,dmpl__SchemeLineId__c,dmpl__ConditionOperator__c
    //                                           from dmpl__SchemeCondition__c Where dmpl__ConditionType__c='Quantity' LIMIT 1];
        
    //     List<AggregateResult> agg = [SELECT
    //                                  dmpl__ItemId__c,
    //                                  dmpl__SKUId__c,
    //                                  dmpl__ItemId__r.SchemeItemGroupId__c,
    //                                  SUM(Quantity__c) TotalQuantity,
    //                                  SUM(Amount__c) TotalAmount
    //                                  FROM
    //                                  dmpl__RepairOrderLine__c
    //                                  GROUP BY
    //                                  dmpl__ItemId__c,
    //                                  dmpl__SKUId__c,
    //                                  dmpl__ItemId__r.SchemeItemGroupId__c
    //                                 ];
        
    //     SchemeHelperRepairOrder.evaluatePerOrderCondition(condition,agg);
    //     test.stopTest();
    //     System.assert(condition != null, 'Test condition are found');
    // }
    
    // @isTest
    // Static void evaluatePerOrderConditionAsValue()
    // {
    //     test.startTest();
    //     dmpl__SchemeCondition__c condition = [Select dmpl__AccountId__c, dmpl__SchemeId__c,dmpl__ItemId__c,dmpl__ItemGroupId__c,dmpl__AccountGroupId__c,dmpl__ItemSKUId__c,dmpl__ConditionType__c,dmpl__ConditionQuantity__c,dmpl__ConditionValue__c,dmpl__SequenceNumber__c,dmpl__SchemeLineId__c,dmpl__ConditionOperator__c
    //                                           from dmpl__SchemeCondition__c Where dmpl__ConditionType__c='Value' LIMIT 1];
        
    //     List<AggregateResult> agg = [SELECT
    //                                  dmpl__ItemId__c,
    //                                  dmpl__SKUId__c,
    //                                  dmpl__ItemId__r.SchemeItemGroupId__c,
    //                                  SUM(Quantity__c) TotalQuantity,
    //                                  SUM(Amount__c) TotalAmount
    //                                  FROM
    //                                  dmpl__RepairOrderLine__c
    //                                  GROUP BY
    //                                  dmpl__ItemId__c,
    //                                  dmpl__SKUId__c,
    //                                  dmpl__ItemId__r.SchemeItemGroupId__c
    //                                 ];
        
    //     SchemeHelperRepairOrder.evaluatePerOrderCondition(condition,agg);
    //     test.stopTest();
    //     System.assert(condition != null, 'Test condition are found');
    // }    
    
    // @isTest
    // public static void VerifyScheme()
    // {
    //     test.startTest();
        
    //     List<dmpl__SchemeLine__c> line2 = [SELECT Id, Name,dmpl__SchemeId__c FROM dmpl__SchemeLine__c];
    //     SchemeHelper.getSchemeLines(line2[0].dmpl__SchemeId__c);   
    //     System.assert(line2.size() != null, 'Purchase order line data');
    //     test.stopTest();
    // }
    
    // @isTest
    // public static void getMinimumBenefit()
    // {
    //     try{
    //     test.startTest();
    //     dmpl__RepairOrderLine__c line = [SELECT Id, Name FROM dmpl__RepairOrderLine__c Limit 1 ];
        
    //     dmpl__SchemeLine__c line2 = [SELECT Id, Name,dmpl__SchemeId__c FROM dmpl__SchemeLine__c where  dmpl__RewardApplicability__c = 'Any One With Lowest Value' Limit 1];
    //     SchemeHelperRepairOrder.getMinimumBenefit(line2,line);   
    //     System.assert(line!=NULL,'Purchase order line data');
    //     test.stopTest();
    //     }
    //     catch(exception e){}
    // }
    
    // @isTest
    // public static void resetOrderDiscountPercent()
    // {
    //     try{
    //     test.startTest();
    //     dmpl__RepairOrderLine__c line = [SELECT Id, Name FROM dmpl__RepairOrderLine__c Limit 1 ];
    //     SchemeHelperRepairOrder.resetOrderDiscountPercent(line);   
    //     System.assert(line!=NULL,'Repair order line data');
    //     test.stopTest();
    //     }
    //     catch(exception e){}
    // }
    
    // @isTest    
    // public static void evaluatePerCondition()
    // {
    //     test.startTest();
    //     dmpl__RepairOrderLine__c line = [SELECT Id, Name,RepairOrderId__c FROM dmpl__RepairOrderLine__c LIMIT 1 ];
    //     List<AggregateResult> result=getOrderSummary(line);
    //     dmpl__SchemeCondition__c condition = [Select dmpl__AccountId__c, dmpl__SchemeId__c,dmpl__ItemId__c,dmpl__ItemGroupId__c,dmpl__AccountGroupId__c,dmpl__ItemSKUId__c,dmpl__ConditionType__c,dmpl__ConditionQuantity__c,dmpl__ConditionValue__c,dmpl__SequenceNumber__c,dmpl__SchemeLineId__c,dmpl__ConditionOperator__c
    //                                           from dmpl__SchemeCondition__c Where dmpl__ConditionType__c='Quantity' LIMIT 1];
    //     SchemeHelperRepairOrder.evaluatePerOrderCondition(condition,result);   
    //     System.assert(line != null, 'Purchase order line data');
    //     test.stopTest();
    // }
  
    // @isTest
    // Static void getTotalItemQuantity()
    // { 
    //     test.startTest();
    //     dmpl__Item__c item = [Select Id,Name from dmpl__Item__c LIMIT 1];
        
    //     List<AggregateResult> agg = [SELECT
    //                                  dmpl__ItemId__c ItemId__c,
    //                                  dmpl__SKUId__c SKUId__c,
    //                                  dmpl__ItemId__r.SchemeItemGroupId__c ItemGroupId__c,
    //                                  SUM(dmpl__Quantity__c) TotalQuantity,
    //                                  SUM(dmpl__Amount__c) TotalAmount
    //                                  FROM
    //                                  dmpl__RepairOrderLine__c
    //                                  GROUP BY
    //                                  dmpl__ItemId__c,
    //                                  dmpl__SKUId__c,
    //                                  dmpl__ItemId__r.SchemeItemGroupId__c
    //                                 ];
        
    //     SchemeHelperRepairOrder.getTotalItemQuantity(agg,item.Id);
    //     test.stopTest();
    //     System.assert(item != null, 'Test item are found');
    // }
    
    // @isTest
    // Static void getTotalItemSKUQuantity()
    // { 
    //     test.startTest();
    //     dmpl__SKU__c sku = [Select Id,Name from dmpl__SKU__c LIMIT 1];
        
    //     List<AggregateResult> agg = [SELECT
    //                                  dmpl__ItemId__c ItemId__c,
    //                                  dmpl__SKUId__c SKUId__c,
    //                                  dmpl__ItemId__r.SchemeItemGroupId__c ItemGroupId__c,
    //                                  SUM(dmpl__Quantity__c) TotalQuantity,
    //                                  SUM(dmpl__Amount__c) TotalAmount
    //                                  FROM
    //                                  dmpl__RepairOrderLine__c
    //                                  GROUP BY
    //                                  dmpl__ItemId__c,
    //                                  dmpl__SKUId__c,
    //                                  dmpl__ItemId__r.SchemeItemGroupId__c
    //                                 ];
        
    //     SchemeHelperRepairOrder.getTotalItemSKUQuantity(agg,sku.Id);
    //     test.stopTest();
    //     System.assert(sku != null, 'Test sku are found');
    // }
    
    // @isTest
    // Static void getTotalItemGroupQuantity()
    // {
    //     test.startTest();
    //     dmpl__ItemGroup__c item = [Select Id,Name from dmpl__ItemGroup__c LIMIT 1];
        
    //     List<AggregateResult> agg = [SELECT
    //                                  dmpl__ItemId__c,
    //                                  dmpl__SKUId__c,
    //                                  dmpl__ItemId__r.dmpl__SchemeItemGroupId__c,
    //                                  SUM(Quantity__c) TotalQuantity,
    //                                  SUM(Amount__c) TotalAmount
    //                                  FROM
    //                                  dmpl__RepairOrderLine__c
    //                                  GROUP BY
    //                                  dmpl__ItemId__c,
    //                                  dmpl__SKUId__c,
    //                                  dmpl__ItemId__r.dmpl__SchemeItemGroupId__c
    //                                 ];
        
    //     SchemeHelperRepairOrder.getTotalItemGroupQuantity(agg,item.Id);
    //     test.stopTest();
    //     System.assert(item != null, 'Test item group are found');
    // }
    
    // @isTest
    // Static void getTotalValue()
    // {
    //     test.startTest();
    //     dmpl__Item__c item = [Select Id,Name,dmpl__AllowService__c From dmpl__Item__c WHERE dmpl__AllowService__c = false LIMIT 1];
    //     List<AggregateResult> agg = [SELECT
    //                                  dmpl__ItemId__c,
    //                                  dmpl__SKUId__c,
    //                                  dmpl__ItemId__r.dmpl__SchemeItemGroupId__c,
    //                                  SUM(Quantity__c) TotalQuantity,
    //                                  SUM(Amount__c) TotalAmount
    //                                  FROM
    //                                  dmpl__RepairOrderLine__c
    //                                  GROUP BY
    //                                  dmpl__ItemId__c,
    //                                  dmpl__SKUId__c,
    //                                  dmpl__ItemId__r.dmpl__SchemeItemGroupId__c
    //                                 ];
        
    //     SchemeHelperRepairOrder.getTotalValue(agg,item.dmpl__AllowService__c);
    //     test.stopTest();
    //     System.assert(item != null, 'Test item group are found');
    // }
    
    // @isTest
    // Static void getTotalItemGroupValue()
    // {
    //     try{
    //     test.startTest();
    //     dmpl__Item__c item = [Select Id,Name,dmpl__SchemeItemGroupId__c,dmpl__AllowService__c From dmpl__Item__c WHERE dmpl__AllowService__c = false LIMIT 1];
    //     List<AggregateResult> agg = [SELECT
    //                                  dmpl__ItemId__c,
    //                                  dmpl__SKUId__c,
    //                                  dmpl__ItemId__r.dmpl__SchemeItemGroupId__c,
    //                                  SUM(Quantity__c) TotalQuantity,
    //                                  SUM(Amount__c) TotalAmount
    //                                  FROM
    //                                  dmpl__RepairOrderLine__c
    //                                  GROUP BY
    //                                  dmpl__ItemId__c,
    //                                  dmpl__SKUId__c,
    //                                  dmpl__ItemId__r.dmpl__SchemeItemGroupId__c
    //                                 ];
        
    //     SchemeHelperRepairOrder.getTotalItemGroupValue(agg,item.dmpl__SchemeItemGroupId__c,item.dmpl__AllowService__c);
    //     test.stopTest();
    //     System.assert(item != null, 'Test item group are found');
    //     }
    //     catch(exception e){}
    // }
    
    // @isTest
    // Static void evaluatePerOrderConditionAsItemValue()
    // {
    //     test.startTest();
    //     dmpl__SchemeCondition__c condition = [Select dmpl__AccountId__c, dmpl__SchemeId__c,dmpl__ItemId__c,dmpl__ItemGroupId__c,dmpl__AccountGroupId__c,dmpl__ItemSKUId__c,dmpl__ConditionType__c,dmpl__ConditionQuantity__c,dmpl__ConditionValue__c,dmpl__SequenceNumber__c,dmpl__SchemeLineId__c,dmpl__ConditionOperator__c
    //                                           from dmpl__SchemeCondition__c Where dmpl__ConditionType__c='Item Value' LIMIT 1];
        
    //     List<AggregateResult> agg = [SELECT
    //                                  dmpl__ItemId__c,
    //                                  dmpl__SKUId__c,
    //                                  dmpl__ItemId__r.SchemeItemGroupId__c,
    //                                  SUM(Quantity__c) TotalQuantity,
    //                                  SUM(Amount__c) TotalAmount
    //                                  FROM
    //                                  dmpl__RepairOrderLine__c
    //                                  GROUP BY
    //                                  dmpl__ItemId__c,
    //                                  dmpl__SKUId__c,
    //                                  dmpl__ItemId__r.SchemeItemGroupId__c
    //                                 ];
        
    //     SchemeHelperRepairOrder.evaluatePerOrderCondition(condition,agg);
    //     test.stopTest();
    //     System.assert(condition != null, 'Test condition are found');
    // }
   
    // @isTest
    // Static void applyDiscount()
    // {
    //     Try{
    //     test.startTest();
    //     dmpl__SchemeBenefit__c benefit = [Select Id,Name,dmpl__DiscountedItemId__c,dmpl__DiscountAmount__c,SchemeLineId__c,dmpl__DiscountedItemQuantity__c FROM dmpl__SchemeBenefit__c LIMIT 1];
    //     dmpl__RepairOrderLine__c purchase = [Select Id, Name,SchemeDiscountAmount__c,SchemeDiscount__c,SchemeLineId__c FROM dmpl__RepairOrderLine__c LIMIT 1];
    //     SchemeHelperRepairOrder.applyOrderDiscountAmount(benefit,purchase);
    //     System.assert(benefit != null, 'Test benefit are found');
    //     test.stopTest();
    //     }
    //     catch(Exception e){}
    // }
   
    // @isTest
    // Static void applyPerPeriodSchemeLine()
    // {
    //     test.startTest();
    //     dmpl__SchemeLine__c line = [Select Id,Name,dmpl__SchemeId__c FROM dmpl__SchemeLine__c LIMIT 1];
    //     dmpl__RepairOrderLine__c purchase = [Select Id, Name,dmpl__SchemeDiscountAmount__c,dmpl__SchemeDiscount__c,dmpl__SchemeLineId__c FROM dmpl__RepairOrderLine__c LIMIT 1];
    //     SchemeHelperRepairOrder.applyPerPeriodSchemeLine(line,purchase);
    //     test.stopTest();
    //     System.assert(line != null, 'Test scheme line are found');
    // }
    
    // @isTest
    // Static void getTotalItemSKUValue()
    // { 
    //     test.startTest();
    //     dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c LIMIT 1];
    //     List<AggregateResult> agg = [SELECT
    //                                  ItemId__c,
    //                                  SKUId__c,
    //                                  ItemId__r.SchemeItemGroupId__c,
    //                                  SUM(Quantity__c) TotalQuantity,
    //                                  SUM(Amount__c) TotalAmount
    //                                  FROM
    //                                  dmpl__RepairOrderLine__c
    //                                  GROUP BY
    //                                  ItemId__c,
    //                                  SKUId__c,
    //                                  ItemId__r.SchemeItemGroupId__c
    //                                 ];
    //     SchemeHelperRepairOrder.getTotalItemSKUValue(agg,sku.Id);
    //     test.stopTest();
    //     System.assert(sku != null, 'Test sku are found');
    // }
   
    // private static void CreateAccountGroup()
    // {
    //     dmpl__AccountGroup__c accountGroup= new dmpl__AccountGroup__c (Name= 'Test-AccountGroup', 
    //                                                                    dmpl__AccountGroupType__c='Scheme');
    //     insert accountGroup;
    // }
    
    // private static void CreateAccount()
    // {
    //     List<Account> account = new List<Account>();
    //     dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c LIMIT 1];
    //     account.add(new Account(Name = 'Test - Account', 
    //                             dmpl__LastName__c = 'Sale Order',
    //                             Fax = '09876',
    //                             Phone = '1234567891',
    //                             Website = 'www.Dealermatix.com',
    //                             Type = 'Prospect',
    //                             NumberOfEmployees = 2,
    //                             Industry = 'Education',
    //                             AnnualRevenue = 1000,
    //                             Description = 'Accounts added',
    //                             dmpl__IsPartnerAccount__c = false,
    //                             dmpl__IsActive__c = True,
    //                             dmpl__IsTaxExempted__c = True,
    //                             dmpl__IsSupplierAccount__c = false,
    //                             dmpl__IsCustomerAccount__c = False,
    //                             dmpl__PartnerTaxAccountGroupId__c = accountGroup.Id,
    //                             dmpl__CustomerPriceAccountGroupId__c = accountGroup.Id,
    //                             dmpl__CustomerDiscountAccountGroupId__c = accountGroup.Id,
    //                             dmpl__PartnerSchemeAccountGroupId__c = accountGroup.Id,                                
    //                             dmpl__PartnerPriceAccountGroupId__c = accountGroup.Id,
    //                             dmpl__PartnerDiscountAccountGroupId__c = accountGroup.Id,
    //                             dmpl__CustomerSchemeAccountGroupId__c = accountGroup.Id
    //                            ));
    //     insert account;
        
    //     Account partneraccount = new Account(Name = 'Partner-Test-Account',
    //                                          dmpl__LastName__c = 'Sale Order',
    //                                          dmpl__IsPartnerAccount__c = True, 
    //                                          dmpl__IsActive__c = true);
    //     insert partneraccount;
        
    //     Account customerAccount = new Account(Name = 'Customer-Test-Account',
    //                                           dmpl__LastName__c = 'Sale Order',
    //                                           dmpl__IsCustomerAccount__c = True,
    //                                           dmpl__IsPartnerAccount__c = True,
    //                                           dmpl__IsActive__c = true);
    //     insert customerAccount;
        
    //     Account supplierAccount = new Account(Name = 'Supplier-Test-Account',
    //                                           dmpl__LastName__c = 'Sale Order',
    //                                           dmpl__IsSupplierAccount__c = True,
    //                                           dmpl__IsActive__c = true);
    //     insert supplierAccount;
    // }
    
    // private static void CreateBranch()
    // {
    //     List<dmpl__Branch__c> branch = new List<dmpl__Branch__c>();
    //     Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
    //     branch.Add(new dmpl__Branch__c(dmpl__PartnerAccountId__c =partnerAccount.Id,
    //                                    Name = 'Test-Branch',
    //                                    dmpl__IsActive__c = true,
    //                                    dmpl__MarketingName__c = 'Hero Electric',
    //                                    dmpl__Website__c = 'www.dealermatix.com',
    //                                    dmpl__Email__c = 'Dealer@Outlook.com',
    //                                    dmpl__MobileNumber__c = 99,
    //                                    dmpl__Phone__c = '8888888888',
    //                                    dmpl__AllowSales__c = true,
    //                                    dmpl__AllowService__c = true,
    //                                    dmpl__AllowPurchase__c = true,
    //                                    dmpl__AllowInventory__c = true,
    //                                    dmpl__IsHomeDeliveryAvailable__c = true,
    //                                    dmpl__IsPickupDropAvailable__c = true,
    //                                    dmpl__SalesPhone__c = '7777777777',
    //                                    dmpl__ServiceEmail__c = 'Customer@Outlook.com'));
        
    //     Account partnerAccount1 = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
    //     branch.Add(new dmpl__Branch__c(dmpl__PartnerAccountId__c =partnerAccount.Id,
    //                                    Name = 'Test-Branch1',
    //                                    dmpl__IsActive__c = true,
    //                                    dmpl__MarketingName__c = 'Hero Electric',
    //                                    dmpl__Website__c = 'www.dealermatix.com',
    //                                    dmpl__Email__c = 'Dealer@Outlook.com',
    //                                    dmpl__MobileNumber__c = 99,
    //                                    dmpl__Phone__c = '1888888888',
    //                                    dmpl__AllowSales__c = true,
    //                                    dmpl__AllowService__c = true,
    //                                    dmpl__AllowPurchase__c = true,
    //                                    dmpl__AllowInventory__c = true,
    //                                    dmpl__IsHomeDeliveryAvailable__c = true,
    //                                    dmpl__IsPickupDropAvailable__c = true,
    //                                    dmpl__SalesPhone__c = '7177777777',
    //                                    dmpl__ServiceEmail__c = 'Customer1@Outlook.com'));
    //     insert branch;
    // }
    
    // private static void CreateItemGroup()
    // {
    //     List<dmpl__ItemGroup__c> itemGroup = new List<dmpl__ItemGroup__c> ();
    //     itemGroup.Add(new dmpl__ItemGroup__c(Name = 'Item Group Test',
    //                                          dmpl__ItemGroupType__c = 'Scheme'
    //                                         ));
    //     insert itemGroup;
    // }
    
    // private static void CreateItems()
    // {
    //     List<dmpl__Item__c> productItem = new List<dmpl__Item__c>();
    //     dmpl__ItemGroup__c itemGroup =[Select Id, Name from dmpl__ItemGroup__c Limit 1];
    //     productItem.Add(new dmpl__Item__c(Name = 'Test-Item',
    //                                       dmpl__ItemCode__c = 'DMPL',
    //                                       dmpl__ItemType__c = 'Product',
    //                                       dmpl__ItemSubType__c = '',
    //                                       dmpl__SchemeItemGroupId__c=itemGroup.Id,
    //                                       dmpl__Description__c = '',
    //                                       dmpl__ItemFamily__c = 'Sample',
    //                                       dmpl__ItemSegment__c = 'Sample',
    //                                       dmpl__Make__c = 'Sample',
    //                                       dmpl__Model__c = 'Sample',
    //                                       dmpl__TrackInventory__c = true,
    //                                       dmpl__TrackLots__c = true,
    //                                       dmpl__IsSKURequired__c = true,
    //                                       dmpl__RequireInspectionOnReceipt__c = true,
    //                                       dmpl__RequireInspectionOnDelivery__c = true,
    //                                       dmpl__AllowService__c = true,
    //                                       dmpl__TrackAsset__c = true,                               
    //                                       dmpl__IsActive__c = true,
    //                                       dmpl__IsRegistrationRequired__c = true,
    //                                       dmpl__GTIN__c = 'BR123',
    //                                       dmpl__RFID__c = 'O1234fgh',
    //                                       dmpl__IsPackage__c = true
    //                                      ));
    //     insert productItem;
        
    //     List<dmpl__Item__c> chargeItem = new List<dmpl__Item__c>();
    //     chargeItem.Add(new dmpl__Item__c(Name = 'Test-Item',
    //                                      dmpl__ItemCode__c = 'DMPL',
    //                                      dmpl__ItemType__c = 'Charge Item',
    //                                      dmpl__ItemSubType__c = '',
    //                                      dmpl__Description__c = '',
    //                                      dmpl__ItemFamily__c = 'Sample',
    //                                      dmpl__ItemSegment__c = 'Sample',
    //                                      dmpl__Make__c = 'Sample',
    //                                      dmpl__Model__c = 'Sample',                       
    //                                      dmpl__IsActive__c = true,
    //                                      dmpl__OnlySoldInPackage__c=True
    //                                     ));
    //     insert chargeItem;
        
    //     List<dmpl__Item__c> subsItem = new List<dmpl__Item__c>();
    //     subsItem.Add(new dmpl__Item__c(Name = 'Test-Item',
    //                                    dmpl__ItemCode__c = 'DMPL',
    //                                    dmpl__ItemType__c = 'Subscription',
    //                                    dmpl__ItemSubType__c = '',
    //                                    dmpl__Description__c = '',
    //                                    dmpl__ItemFamily__c = 'Sample',
    //                                    dmpl__ItemSegment__c = 'Sample',
    //                                    dmpl__Make__c = 'Sample',
    //                                    dmpl__Model__c = 'Sample',                       
    //                                    dmpl__IsPackage__c = true
    //                                   ));
    //     insert subsItem;
    // }
    
    // private static void CreateSKu()
    // {
    //     List<dmpl__SKU__c> sku = new List<dmpl__SKU__c>();
    //     dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
    //     sku.add(new dmpl__SKU__c(Name = 'Test - SKU',
    //                              dmpl__SKUCode__c = 'Test - SKU - Code',
    //                              dmpl__UnitOfMeasureOfConversion__c = 10,
    //                              dmpl__ProductColor__c = 'Sample',
    //                              dmpl__IsDefault__c = false,
    //                              dmpl__QuantityUnitOfMeasure__c ='Sample',
    //                              dmpl__ItemId__c = item.Id));
    //     insert sku;
    // }
    
    // private static void CreateResource()
    // {
    //     List<dmpl__Resource__c> resource = new List<dmpl__Resource__c>();
    //     Account partnerAccount = [Select Id,Name From Account LIMIT 1];
    //     dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
    //     resource.add(new dmpl__Resource__c(Name = 'Test - Resource',
    //                                        dmpl__ResourceType__c = 'Technician',
    //                                        dmpl__IsActive__c = true,
    //                                        dmpl__Phone__c = '9999999999',
    //                                        dmpl__DefaultPartnerAccountId__c = partnerAccount.Id,
    //                                        dmpl__DefaultBranchId__c = branch.Id
    //                                       ));
    //     insert resource;
    // }
    
    // private static void CreateTaxGroup()
    // {
    //     List<dmpl__TaxGroup__c> taxGroup = new List<dmpl__TaxGroup__c>();
    //     Account account=[Select Id,Name from Account Where Name='Partner-Test-Account'];
    //     dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Limit 1];
    //     dmpl__AccountGroup__c AccountGrp = [Select Id, Name FROM dmpl__AccountGroup__c LIMIT 1];
    //     taxGroup.Add(new dmpl__TaxGroup__c(Name = 'Test - Tax Group',
    //                                        dmpl__PartnerAccountId__c = account.Id,
    //                                        dmpl__BranchId__c = branch.Id,
    //                                        dmpl__PartnerAccountGroupId__c = AccountGrp.Id,
    //                                        dmpl__Description__c = 'Test-Description',
    //                                        dmpl__IsActive__c = true));
    //     insert taxGroup;
    // }
    
    
    // private static void CreateScheme()
    // {
    //     List<dmpl__Scheme__c> scheme = new List<dmpl__Scheme__c>();
    //     dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch'];
    //     Account customerAccount = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
    //     dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c LIMIT 1];
    //     scheme.Add(new dmpl__Scheme__c(dmpl__PeriodType__c = 'Quarterly',
    //                                    Name='Scheme1',
    //                                    dmpl__ValidTo__c= Datetime.now().addDays(365).Date(),
    //                                    dmpl__Status__c='Approved',
    //                                    dmpl__MultipleFulfilmentTreatment__c='Apply All Fulfilled',
    //                                    dmpl__SchemeType__c='Sales Per Order',
    //                                    dmpl__BranchId__c = branch.Id,
    //                                    dmpl__ValidFrom__c = date.today(),
    //                                    dmpl__PartnerAccountId__c = null,
    //                                    dmpl__PartnerAccountGroupId__c = null));
    //     insert scheme;
        
    //     List<dmpl__Scheme__c> scheme1 = new List<dmpl__Scheme__c>();
    //     scheme1.Add(new dmpl__Scheme__c(dmpl__PeriodType__c = 'Quarterly',
    //                                     Name='Scheme2',
    //                                     dmpl__ValidTo__c= Datetime.now().addDays(150).Date(),
    //                                     dmpl__Status__c='Approved',
    //                                     dmpl__MultipleFulfilmentTreatment__c='Apply First Fulfilled',
    //                                     dmpl__SchemeType__c='Procurement Per Period',
    //                                     dmpl__BranchId__c = branch.Id,
    //                                     dmpl__ValidFrom__c = date.today(),
    //                                     dmpl__PartnerAccountId__c = null,
    //                                     dmpl__PartnerAccountGroupId__c = null));
    //     insert scheme1;
    // }
    
    // private static void CreateSchemeLine()
    // {
    //     List<dmpl__SchemeLine__c> schemeLine = new List<dmpl__SchemeLine__c>();
    //     dmpl__Scheme__c scheme =[Select Id, Name,dmpl__SchemeType__c,dmpl__MultipleFulfilmentTreatment__c,dmpl__PeriodType__c from dmpl__Scheme__c where dmpl__SchemeType__c = 'Sales Per Order' Limit 1];
    //     schemeLine.Add(new dmpl__SchemeLine__c(dmpl__DefinitionFilterCriteria__c = 'All Conditions Are Met',
    //                                            dmpl__SchemeId__c = scheme.Id,
    //                                            dmpl__SequenceNumber__c = 1,
    //                                            dmpl__RewardApplicability__c = 'All Rewards'));
    //     insert schemeLine;
        
    //     List<dmpl__SchemeLine__c> schemeLine1 = new List<dmpl__SchemeLine__c>();
    //     dmpl__Scheme__c scheme1 =[Select Id, Name from dmpl__Scheme__c where dmpl__SchemeType__c = 'Procurement Per Period' Limit 1];
    //     schemeLine1.Add(new dmpl__SchemeLine__c(dmpl__DefinitionFilterCriteria__c = 'Always (No Criteria)',
    //                                             dmpl__SchemeId__c = scheme1.Id,
    //                                             dmpl__SequenceNumber__c = 2,
    //                                             dmpl__RewardApplicability__c = 'Any One With Lowest Value'));
    //     insert schemeLine1;
    // } 
    
    // private static void CreateSchemeCondition()
    // {
    //     List<dmpl__SchemeCondition__c> schemeCondition = new List<dmpl__SchemeCondition__c>();
    //     dmpl__Scheme__c scheme =[Select Id, Name from dmpl__Scheme__c Limit 1];
    //     dmpl__SchemeLine__c schemeLine =[Select Id, Name from dmpl__SchemeLine__c Limit 1];
    //     Account customerAccount = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
    //     dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c LIMIT 1];
    //     dmpl__Item__c item = [Select Id,Name From dmpl__Item__c where dmpl__ItemType__c='Product'  LIMIT 1];
    //     dmpl__ItemGroup__c itemGroup =[Select Id, Name from dmpl__ItemGroup__c Limit 1];
    //     dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
    //     schemeCondition.Add(new dmpl__SchemeCondition__c(dmpl__AccountId__c =customerAccount.Id,
    //                                                      dmpl__SchemeId__c = scheme.Id,
    //                                                      dmpl__ItemId__c=item.Id,
    //                                                      dmpl__ItemGroupId__c=itemGroup.Id,         
    //                                                      dmpl__AccountGroupId__c =accountGroup.Id,
    //                                                      dmpl__ItemSKUId__c=sku.Id,         
    //                                                      dmpl__ConditionType__c='Quantity',
    //                                                      dmpl__ConditionQuantity__c =5,
    //                                                      dmpl__ConditionValue__c = 100,
    //                                                      dmpl__SequenceNumber__c = 1,
    //                                                      dmpl__SchemeLineId__c=schemeLine.Id,        
    //                                                      dmpl__ConditionOperator__c = 'Greater Than'));
    //     insert schemeCondition;
        
    //     List<dmpl__SchemeCondition__c> schemeCondition2 = new List<dmpl__SchemeCondition__c>();
    //     dmpl__Scheme__c scheme1 =[Select Id, Name from dmpl__Scheme__c  where  dmpl__SchemeType__c = 'Procurement Per Period' LIMIT 1];
    //     dmpl__SchemeLine__c schemeLine1 =[Select Id, Name from dmpl__SchemeLine__c where dmpl__DefinitionFilterCriteria__c = 'Always (No Criteria)' Limit 1];
    //     schemeCondition2.Add(new dmpl__SchemeCondition__c(dmpl__AccountId__c =customerAccount.Id,
    //                                                       dmpl__SchemeId__c = scheme1.Id,
    //                                                       dmpl__ConditionType__c='Value',
    //                                                       dmpl__ConditionValue__c = 100,
    //                                                       dmpl__SequenceNumber__c = 2,
    //                                                       dmpl__SchemeLineId__c=schemeLine1.Id,        
    //                                                       dmpl__ConditionOperator__c = 'Less Than'));
    //     insert schemeCondition2;
        
    //     List<dmpl__SchemeCondition__c> schemeCondition3 = new List<dmpl__SchemeCondition__c>();
    //     schemeCondition3.Add(new dmpl__SchemeCondition__c(dmpl__AccountId__c =customerAccount.Id,
    //                                                       dmpl__SchemeId__c = scheme.Id,
    //                                                       dmpl__ItemId__c=item.Id,
    //                                                       dmpl__ConditionType__c='Item Value',
    //                                                       dmpl__ConditionValue__c = 100,
    //                                                       dmpl__SequenceNumber__c = 3,
    //                                                       dmpl__SchemeLineId__c=schemeLine.Id,        
    //                                                       dmpl__ConditionOperator__c = 'Equals'));
    //     insert schemeCondition3;
    // }
    
    // private static void CreateSchemeBenefits()
    // {
    //     List<dmpl__SchemeBenefit__c> schemeBenefit = new List<dmpl__SchemeBenefit__c>();
    //     dmpl__Scheme__c scheme =[Select Id, Name from dmpl__Scheme__c Limit 1];
    //     dmpl__SchemeLine__c schemeLine =[Select Id, Name from dmpl__SchemeLine__c Limit 1];
    //     dmpl__Item__c item = [Select Id,Name From dmpl__Item__c where dmpl__ItemType__c='Product'  LIMIT 1];
    //     dmpl__ItemGroup__c itemGroup =[Select Id, Name from dmpl__ItemGroup__c Limit 1];
    //     dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
    //     Account customerAccount = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
    //     schemeBenefit.Add(new dmpl__SchemeBenefit__c(dmpl__SchemeId__c = scheme.Id, 
    //                                                  dmpl__DiscountPercent__c=5,
    //                                                  dmpl__RewardType__c='Line Level Discount Amount',
    //                                                  dmpl__SequenceNumber__c = 1,
    //                                                  dmpl__SchemeLineId__c=schemeLine.Id       
    //                                                 ));
    //     insert schemeBenefit;
        
    //     List<dmpl__SchemeBenefit__c> schemeBenefit1 = new List<dmpl__SchemeBenefit__c>();
    //     dmpl__Scheme__c scheme1 =[Select Id, Name,dmpl__SchemeType__c,dmpl__MultipleFulfilmentTreatment__c,dmpl__PeriodType__c from dmpl__Scheme__c where  dmpl__SchemeType__c='Procurement Per Period' Limit 1];
    //     dmpl__SchemeLine__c schemeLine1 =[Select Id, Name from dmpl__SchemeLine__c where dmpl__DefinitionFilterCriteria__c = 'Always (No Criteria)' Limit 1];
    //     schemeBenefit1.Add(new dmpl__SchemeBenefit__c(dmpl__SchemeId__c = scheme1.Id, 
    //                                                   dmpl__DiscountAmount__c=100,
    //                                                   dmpl__RewardType__c='Line Level Discount Percent',
    //                                                   dmpl__SequenceNumber__c = 2,
    //                                                   dmpl__SchemeLineId__c=schemeLine1.Id       
    //                                                  ));
    //     insert schemeBenefit1;
        
    // }    
    
    // private static void CreateRepairOrder()
    // {
    //     List<dmpl__RepairOrder__c> repairOrder = new List<dmpl__RepairOrder__c> ();
    //     dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
    //     dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c limit 1];
    //     dmpl__Resource__c resource = [select Id,Name FROM dmpl__Resource__c LIMIT 1];
    //     dmpl__Scheme__c scheme = [Select Id,Name,dmpl__ValidFrom__c From dmpl__Scheme__c LIMIT 1];
    //     Asset asset = [Select Id,Name From Asset LIMIT 1];
    //     Account customerAccount = [Select id,Name From Account Where Name = 'Customer-Test-Account' LIMIT 1];
    //     repairOrder.Add(new dmpl__RepairOrder__c (dmpl__BranchId__c = branch.Id,
    //                                                 dmpl__AccountId__c = customerAccount.Id,
    //                                                 dmpl__DocumentDate__c=date.today(),
    //                                                 dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
    //                                                 dmpl__UsageReading__c = 8,
    //                                                 dmpl__AssetId__c = asset.Id,
    //                                                 dmpl__ServiceAdvisorId__c = resource.Id
    //     ));
    //     insert repairOrder;
    // }
    
    // private static void CreateRepairOrderLine()
    // {
    //     List<dmpl__RepairOrderLine__c> repairOrderLine = new List<dmpl__RepairOrderLine__c>();
    //     dmpl__RepairOrder__c repairOrder = [Select Id,Name FROM dmpl__RepairOrder__c ];
    //     dmpl__Item__c item = [Select Id,Name FROM dmpl__Item__c LIMIT 1];
    //     dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c LIMIT 1];
    //     dmpl__Resource__c resource = [select Id,Name FROM dmpl__Resource__c WHERE dmpl__ResourceType__c = 'Technician' LIMIT 1];
    //     dmpl__SchemeLine__c schemeLine =[Select Id, Name from dmpl__SchemeLine__c WHERE dmpl__SchemeId__r.dmpl__SchemeType__c='Procurement Per Period'Limit 1];
    //     dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
    //     repairOrderLine.add(new dmpl__RepairOrderLine__c(dmpl__ItemId__c = item.Id,
    //                                                      dmpl__Quantity__c = 5,
    //                                                      dmpl__CancelledQuantity__c=3,
    //                                                      dmpl__SKUId__c=sku.Id,
    //                                                      dmpl__UnitPrice__c = 10,
    //                                                      dmpl__SchemeLineId__c=schemeLine.Id,
    //                                                      dmpl__PackageClassification__c = 'Optional Item',
    //                                                      dmpl__ActionTaken__c = 'Replace',
    //                                                      dmpl__TechnicianId__c = resource.Id,
    //                                                      dmpl__WorkStartedBy__c = date.today(),
    //                                                      dmpl__WorkEndedAt__c = date.today(),
    //                                                      dmpl__WorkStatus__c = 'Started',
    //                                                      dmpl__StandardDurationHours__c = 10,
    //                                                      dmpl__ActualDurationHours__c = 10,
    //                                                      dmpl__TaxGroupId__c = taxGroup.Id,
    //                                                      dmpl__RepairOrderId__c = repairOrder.Id
    //                                                     ));
    //     insert repairOrderLine;
        
    //     List<dmpl__RepairOrderLine__c> repairOrderLine1 = new List<dmpl__RepairOrderLine__c>();
    //     dmpl__SchemeLine__c schemeLine1 =[Select Id, Name from dmpl__SchemeLine__c where dmpl__SchemeId__r.dmpl__SchemeType__c='Procurement Per Period' LIMIT 1];
    //     repairOrderLine1.add(new dmpl__RepairOrderLine__c(dmpl__ItemId__c = item.Id,
    //                                                       dmpl__Quantity__c = 5,
    //                                                       dmpl__CancelledQuantity__c=3,
    //                                                       dmpl__SKUId__c=sku.Id,
    //                                                       dmpl__UnitPrice__c = 10,
    //                                                       dmpl__SchemeLineId__c=schemeLine1.Id,
    //                                                       dmpl__PackageClassification__c = 'Optional Item',
    //                                                       dmpl__ActionTaken__c = 'Replace',
    //                                                       dmpl__TechnicianId__c = resource.Id,
    //                                                       dmpl__WorkStartedBy__c = date.today(),
    //                                                       dmpl__WorkEndedAt__c = date.today(),
    //                                                       dmpl__WorkStatus__c = 'Started',
    //                                                       dmpl__StandardDurationHours__c = 10,
    //                                                       dmpl__ActualDurationHours__c = 10,
    //                                                       dmpl__TaxGroupId__c = taxGroup.Id,
    //                                                       dmpl__RepairOrderId__c = repairOrder.Id
    //                                                      ));
    //     insert repairOrderLine1;
    // }
    
    
    // private static void CreateAsset()
    // {
    //     List<Asset> asset = new List<Asset>();
    //     Account account = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
    //     dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
    //     dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
    //     dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c LIMIT 1];
    //     asset.add(new Asset(Name = 'Test-Asset',
    //                         AccountId = account.Id,
    //                         dmpl__LastServiceBranchId__c = branch.Id,
    //                         dmpl__ItemId__c = item.Id,
    //                         dmpl__SKUId__c = sku.Id,
    //                         dmpl__IsPDIDone__c=true,
    //                         dmpl__RegistrationNumber__c = 'Axb371',
    //                         dmpl__SaleDate__c = date.today()
    //                        ));
    //     insert asset;
    // }
    
    // private static List<AggregateResult> getOrderSummary(dmpl__RepairOrderLine__c orderLine)
    // {
    //     return 
    //     [
    //         SELECT
    //             ItemId__c,
    //             SKUId__c,
    //             ItemId__r.SchemeItemGroupId__c,
    //             SUM(Quantity__c) TotalQuantity,
    //             SUM(Amount__c) TotalAmount
    //         FROM
    //             dmpl__RepairOrderLine__c
    //         WHERE
    //         RepairOrderId__c =: orderLine.RepairOrderId__c
    //         GROUP BY
    //             ItemId__c,
    //             SKUId__c,
    //             ItemId__r.SchemeItemGroupId__c
    //     ];
    // }
    
}