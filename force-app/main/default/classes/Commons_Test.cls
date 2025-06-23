@isTest
public class Commons_Test {
	@TestSetup
    public static void makeData(){
        CreateScheme();
    }
    
    private static void CreateScheme()
    {
        Account partneraccount = new Account(Name = 'Partner-Test-Account',
                                             dmpl__LastName__c = 'Sale Order',
                                             dmpl__IsPartnerAccount__c = True, 
                                             dmpl__IsActive__c = true);
        insert partneraccount;
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__LastName__c = 'Sale Order',
                                              dmpl__IsCustomerAccount__c = True,
                                              dmpl__IsPartnerAccount__c = True,
                                              dmpl__IsActive__c = true);
        insert customerAccount;
        
        List<dmpl__Branch__c> branch = new List<dmpl__Branch__c>();
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

        List<dmpl__ItemGroup__c> itemGroup = new List<dmpl__ItemGroup__c> ();
        itemGroup.Add(new dmpl__ItemGroup__c(Name = 'Item Group Test',
                                             dmpl__ItemGroupType__c = 'Scheme'
                                            ));
        insert itemGroup;
    
        List<dmpl__Item__c> productItem = new List<dmpl__Item__c>();
        productItem.Add(new dmpl__Item__c(Name = 'Test-Item',
                                          dmpl__ItemCode__c = 'DMPL',
                                          dmpl__ItemType__c = 'Product',
                                          dmpl__ItemSubType__c = '',
                                          dmpl__SchemeItemGroupId__c=itemGroup[0].Id,
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
        insert productItem;
        
        List<dmpl__SKU__c> sku = new List<dmpl__SKU__c>();
        dmpl__Item__c item = productItem[0];
        sku.add(new dmpl__SKU__c(Name = 'Test - SKU',
                                 dmpl__SKUCode__c = 'Test - SKU - Code',
                                 dmpl__UnitOfMeasureOfConversion__c = 10,
                                 dmpl__ProductColor__c = 'Sample',
                                 dmpl__IsDefault__c = false,
                                 dmpl__QuantityUnitOfMeasure__c ='Sample',
                                 dmpl__ItemId__c = item.Id));
        insert sku;

        List<dmpl__Scheme__c> scheme = new List<dmpl__Scheme__c>();
        scheme.Add(new dmpl__Scheme__c(dmpl__PeriodType__c = 'Per Order',
                                       Name='Scheme1',
                                       dmpl__ValidTo__c= Datetime.now().addDays(365).Date(),
                                       dmpl__Status__c='Approved',
                                       dmpl__MultipleFulfilmentTreatment__c='Apply Last Fulfilled',
                                       dmpl__SchemeType__c='Per Sale Invoice',
                                       dmpl__BranchId__c = branch[0].Id,
                                       dmpl__ValidFrom__c = date.today()-(2),
                                       dmpl__PartnerAccountId__c = null,
                                       dmpl__PartnerAccountGroupId__c = null,
                                       dmpl__Application__c = 'Auto Apply'));
        insert scheme;
    
        List<dmpl__SchemeLine__c> schemeLine = new List<dmpl__SchemeLine__c>();
        schemeLine.Add(new dmpl__SchemeLine__c(dmpl__DefinitionFilterCriteria__c = 'Any Condition Is Met',
                                               dmpl__SchemeId__c = scheme[0].Id,
                                               dmpl__SequenceNumber__c = 1,
                                               dmpl__RewardApplicability__c = 'All Rewards'));
        
        insert schemeLine;
        
        List<dmpl__SchemeLine__c> schemeLine1 = new List<dmpl__SchemeLine__c>();
        schemeLine1.Add(new dmpl__SchemeLine__c(dmpl__DefinitionFilterCriteria__c = 'Any Condition Is Met',
                                               dmpl__SchemeId__c = scheme[0].Id,
                                               dmpl__SequenceNumber__c = 1,
                                               dmpl__RewardApplicability__c = 'Any One With Lowest Value'));
        
        insert schemeLine1;
        
        List<dmpl__SchemeLine__c> schemeLine2 = new List<dmpl__SchemeLine__c>();
        schemeLine2.Add(new dmpl__SchemeLine__c(dmpl__DefinitionFilterCriteria__c = 'Any Condition Is Met',
                                               dmpl__SchemeId__c = scheme[0].Id,
                                               dmpl__SequenceNumber__c = 1,
                                               dmpl__RewardApplicability__c = 'Any One With Highest Value'));
        
        insert schemeLine2;
    
    
        List<dmpl__SchemeCondition__c> schemeCondition = new List<dmpl__SchemeCondition__c>();
        schemeCondition.Add(new dmpl__SchemeCondition__c(dmpl__AccountId__c =customerAccount.Id,
                                                         dmpl__SchemeId__c = scheme[0].Id,
                                                         dmpl__ItemId__c=item.Id,
                                                         dmpl__ItemGroupId__c=itemGroup[0].Id,         
                                                         dmpl__ItemSKUId__c=sku[0].Id,         
                                                         dmpl__ConditionType__c='Quantity',
                                                         dmpl__ConditionQuantity__c =1,
                                                         dmpl__ConditionValue__c = 100,
                                                         dmpl__SequenceNumber__c = 1,
                                                         dmpl__SchemeLineId__c= schemeLine[0].Id,
                                                         dmpl__ConditionOperator__c = 'Greater Than'));
        insert schemeCondition;
        
        List<dmpl__SchemeCondition__c> schemeCondition1 = new List<dmpl__SchemeCondition__c>();
        schemeCondition1.Add(new dmpl__SchemeCondition__c(dmpl__AccountId__c =customerAccount.Id,
                                                          dmpl__SchemeId__c = scheme[0].Id,
                                                          dmpl__ItemId__c=item.Id,
                                                          dmpl__ItemGroupId__c=itemGroup[0].Id,         
                                                          dmpl__ItemSKUId__c=sku[0].Id,         
                                                          dmpl__ConditionType__c='Value',
                                                          dmpl__ConditionValue__c = 100,
                                                          dmpl__SequenceNumber__c = 2,
                                                          //dmpl__SchemeLineId__c=schemeLine1.Id,
                                                          dmpl__ConditionOperator__c = 'Greater Than'));
        //insert schemeCondition1;
        
        List<dmpl__SchemeCondition__c> schemeCondition3 = new List<dmpl__SchemeCondition__c>();
        schemeCondition3.Add(new dmpl__SchemeCondition__c(dmpl__AccountId__c =customerAccount.Id,
                                                          dmpl__SchemeId__c = scheme[0].Id,
                                                          dmpl__ItemId__c=item.Id,
                                                          dmpl__ItemGroupId__c=itemGroup[0].Id, 
                                                          dmpl__ConditionType__c='Item Group Value',
                                                          dmpl__ConditionValue__c = 100,
                                                          dmpl__SequenceNumber__c = 3,
                                                          dmpl__SchemeLineId__c=schemeLine[0].Id,        
                                                          dmpl__ConditionOperator__c = 'Greater Than'));

        schemeCondition3.Add(new dmpl__SchemeCondition__c(dmpl__AccountId__c =customerAccount.Id,
        dmpl__SchemeId__c = scheme[0].Id,
        dmpl__ItemId__c=item.Id,
        dmpl__ItemGroupId__c=itemGroup[0].Id, 
        dmpl__ConditionType__c='Quantity',
        dmpl__ConditionValue__c = 100,
        dmpl__SequenceNumber__c = 3,
        dmpl__SchemeLineId__c=schemeLine[0].Id,        
        dmpl__ConditionOperator__c = 'Equals'));
        schemeCondition3.Add(new dmpl__SchemeCondition__c(dmpl__AccountId__c =customerAccount.Id,
        dmpl__SchemeId__c = scheme[0].Id,
        dmpl__ItemId__c=item.Id,
        dmpl__ItemGroupId__c=itemGroup[0].Id, 
        dmpl__ConditionType__c='Value',
        dmpl__ConditionValue__c = 100,
        dmpl__SequenceNumber__c = 3,
        dmpl__SchemeLineId__c=schemeLine[0].Id,        
        dmpl__ConditionOperator__c = 'Equals'));
        schemeCondition3.Add(new dmpl__SchemeCondition__c(dmpl__AccountId__c =customerAccount.Id,
        dmpl__SchemeId__c = scheme[0].Id,
        dmpl__ItemId__c=item.Id,
        dmpl__ItemGroupId__c=itemGroup[0].Id, 
        dmpl__ConditionType__c='Value With Tax',
        dmpl__ConditionValue__c = 100,
        dmpl__SequenceNumber__c = 3,
        dmpl__SchemeLineId__c=schemeLine[0].Id,        
        dmpl__ConditionOperator__c = 'Equals'));
        schemeCondition3.Add(new dmpl__SchemeCondition__c(dmpl__AccountId__c =customerAccount.Id,
        dmpl__SchemeId__c = scheme[0].Id,
        dmpl__ItemId__c=item.Id,
        dmpl__ItemGroupId__c=itemGroup[0].Id, 
        dmpl__ConditionType__c='Item Quantity',
        dmpl__ConditionValue__c = 100,
        dmpl__SequenceNumber__c = 3,
        dmpl__SchemeLineId__c=schemeLine[0].Id,        
        dmpl__ConditionOperator__c = 'Equals'));
        schemeCondition3.Add(new dmpl__SchemeCondition__c(dmpl__AccountId__c =customerAccount.Id,
        dmpl__SchemeId__c = scheme[0].Id,
        dmpl__ItemId__c=item.Id,
        dmpl__ItemGroupId__c=itemGroup[0].Id, 
        dmpl__ConditionType__c='Item Value',
        dmpl__ConditionValue__c = 100,
        dmpl__SequenceNumber__c = 3,
        dmpl__SchemeLineId__c=schemeLine[0].Id,        
        dmpl__ConditionOperator__c = 'Less Than Or Equal'));
        schemeCondition3.Add(new dmpl__SchemeCondition__c(dmpl__AccountId__c =customerAccount.Id,
        dmpl__SchemeId__c = scheme[0].Id,
        dmpl__ItemId__c=item.Id,
        dmpl__ItemGroupId__c=itemGroup[0].Id, 
        dmpl__ConditionType__c='Item Value With Tax',
        dmpl__ConditionValue__c = 100,
        dmpl__SequenceNumber__c = 3,
        dmpl__SchemeLineId__c=schemeLine[0].Id,        
        dmpl__ConditionOperator__c = 'Does Not Equal'));
        schemeCondition3.Add(new dmpl__SchemeCondition__c(dmpl__AccountId__c =customerAccount.Id,
        dmpl__SchemeId__c = scheme[0].Id,
        dmpl__ItemId__c=item.Id,
        dmpl__ItemGroupId__c=itemGroup[0].Id, 
        dmpl__ConditionType__c='Item Group Quantity',
        dmpl__ConditionValue__c = 100,
        dmpl__SequenceNumber__c = 3,
        dmpl__SchemeLineId__c=schemeLine[0].Id,        
        dmpl__ConditionOperator__c = 'Greater Than'));
        schemeCondition3.Add(new dmpl__SchemeCondition__c(dmpl__AccountId__c =customerAccount.Id,
        dmpl__SchemeId__c = scheme[0].Id,
        dmpl__ItemId__c=item.Id,
        dmpl__ItemGroupId__c=itemGroup[0].Id, 
        dmpl__ConditionType__c='Item Group Value',
        dmpl__ConditionValue__c = 100,
        dmpl__SequenceNumber__c = 3,
        dmpl__SchemeLineId__c=schemeLine[0].Id,        
        dmpl__ConditionOperator__c = 'Greater Than Or Equal'));
        schemeCondition3.Add(new dmpl__SchemeCondition__c(dmpl__AccountId__c =customerAccount.Id,
        dmpl__SchemeId__c = scheme[0].Id,
        dmpl__ItemId__c=item.Id,
        dmpl__ItemGroupId__c=itemGroup[0].Id, 
        dmpl__ConditionType__c='Item Group Value With Tax',
        dmpl__ConditionValue__c = 100,
        dmpl__SequenceNumber__c = 3,
        dmpl__SchemeLineId__c=schemeLine[0].Id,        
        dmpl__ConditionOperator__c = 'Less Than'));

        insert schemeCondition3;
    
        List<dmpl__SchemeBenefit__c> schemeBenefit = new List<dmpl__SchemeBenefit__c>();
        schemeBenefit.Add(new dmpl__SchemeBenefit__c(dmpl__SchemeId__c = scheme[0].Id, 
                                                    DiscountPercent__c=5,
                                                     DiscountAmount__c=100,
                                                     dmpl__RewardType__c='Reward Points',
                                                     dmpl__SequenceNumber__c = 1,
                                                     dmpl__RepeatReward__c =  true,
                                                     dmpl__SchemeLineId__c=schemeLine[0].Id       
                                                    ));
        insert schemeBenefit;
        
        List<dmpl__SchemeBenefit__c> schemeBenefit1 = new List<dmpl__SchemeBenefit__c>();
        dmpl__SchemeLine__c schemeLine3 =[Select Id, Name from dmpl__SchemeLine__c  Limit 1];
        schemeBenefit1.Add(new dmpl__SchemeBenefit__c(dmpl__SchemeId__c = scheme[0].Id, 
                                                      DiscountAmount__c=500,
                                                      DiscountPercent__c=4,
                                                      dmpl__RewardType__c='Line Level Discount Amount',
                                                      dmpl__SequenceNumber__c = 2,
                                                      dmpl__RepeatReward__c =  true,
                                                      dmpl__SchemeLineId__c=schemeLine3.Id       
                                                     ));
        insert schemeBenefit1;
        
        List<dmpl__SchemeBenefit__c> schemeBenefit3 = new List<dmpl__SchemeBenefit__c>();
        schemeBenefit3.Add(new dmpl__SchemeBenefit__c(dmpl__SchemeId__c = scheme[0].Id, 
                                                      DiscountAmount__c=500,
                                                      DiscountPercent__c=4,
                                                      dmpl__DiscountedItemId__c = item.Id,
                                                      dmpl__RewardType__c='Discounted Item',
                                                      dmpl__SequenceNumber__c = 2,
                                                      dmpl__RepeatReward__c =  true,
                                                      dmpl__SchemeLineId__c=schemeLine3.Id       
                                                     ));
        insert schemeBenefit3;
        
        List<dmpl__SchemeBenefit__c> schemeBenefit4 = new List<dmpl__SchemeBenefit__c>();
        schemeBenefit4.Add(new dmpl__SchemeBenefit__c(dmpl__SchemeId__c = scheme[0].Id, 
                                                      DiscountAmount__c=500,
                                                      DiscountPercent__c=4,
                                                      dmpl__DiscountedItemGroupId__c = itemGroup[0].Id,
                                                      dmpl__RewardType__c='Discounted Item Group',
                                                      dmpl__SequenceNumber__c = 2,
                                                      dmpl__RepeatReward__c =  true,
                                                      dmpl__SchemeLineId__c=schemeLine3.Id       
                                                     ));
        insert schemeBenefit4;
    }    
    @isTest
    private static void CreateSaleReturn1()
    {
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c where dmpl__ItemType__c='Product'  LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch'];
        dmpl__SaleInvoice__c saleInvoice = new dmpl__SaleInvoice__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                 dmpl__BranchId__c = branch.Id,
                                                 dmpl__DocumentDate__c = date.today(),
                                                 dmpl__AccountId__c = branch.dmpl__PartnerAccountId__c,
                                                 //dmpl__SalesExecutiveId__c = resource.Id,
                                                 dmpl__PerformGLPosting__c = true,
                                                 dmpl__Status__c = 'Draft'
                                                );
        insert saleInvoice;
        List<dmpl__SaleReturn__c> saleReturn = new List<dmpl__SaleReturn__c>();
        dmpl__SchemeLine__c schemeLine3 =[Select Id, Name from dmpl__SchemeLine__c  Limit 1];
        saleReturn.Add(new dmpl__SaleReturn__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                                 dmpl__BranchId__c = branch.Id,
                                                                 dmpl__SaleInvoiceId__c = saleInvoice.Id,
                                                                dmpl__AccountId__c = branch.dmpl__PartnerAccountId__c,
                                                                dmpl__DocumentDate__c = date.today()));
        insert saleReturn;
        dmpl__SaleReturnLine__c line = new dmpl__SaleReturnLine__c(
        	dmpl__SaleReturnId__c = saleReturn[0].Id,
            dmpl__ChassisNumber__c = 'qwerty'
        );
        insert line;
        line.dmpl__ChassisNumber__c = 'qwerty1';
        update line;
        delete line;
        SchemeReturnEngine obj = new SchemeReturnEngine(saleReturn[0],true);
        obj.getAppliedSchemeLines(new List<Id>());
        //obj.queryAppliedSchemeLines('');
        //obj.doesItemGroupContains('','','','');
        obj.getIgnoredSchemeLines(new Map<Id,Integer>(),new List<SchemeLine__c>());
        //obj.updateLines();
    }
    
    @isTest
    public static void JobTypeHelperTest(){
        Account acc1 = new Account(Name = 'TestAccount1');
        insert acc1;
        /*JobTypeHelper.perfromCustomProcessorAction(
            'Resource Availability Processor',
            '',
            acc1.Id,
            '');*/
    }
    
    @isTest
    public static void DebitNoteLineHandlerTest(){
        
        dmpl__DebitNote__c debitNote= new dmpl__DebitNote__c ( 
            dmpl__DocumentDate__c=date.today());
        insert debitNote;
		dmpl__DebitNoteLines__c lines = new dmpl__DebitNoteLines__c(dmpl__Amount__c = 10,dmpl__DebitNoteId__c = debitNote.Id);
        insert lines;
        lines.dmpl__Amount__c = 0;
        update lines;
        delete lines;
    }
    @isTest
    public static void CreditNoteLineTest(){
        dmpl__CreditNote__c creditNote= new dmpl__CreditNote__c ( 
            dmpl__DocumentDate__c=date.today());
        insert creditNote;
        dmpl__CreditNoteLine__c line = new dmpl__CreditNoteLine__c(dmpl__Amount__c = 10, dmpl__creditNoteId__c = creditNote.Id);
        insert line;
        line.dmpl__Amount__c= 0;
        update line;
        delete line;
    }
    @isTest
    public static void AttendanceManagementControllerTest(){
        dmpl__Resource__c res = new dmpl__Resource__c(Name= 'r1');
        insert res;
		AttendanceManagementController.getResourceDetailsByResource(res.Id,'1','1');
    }
    
    @isTest
    public static void DocumentSelectorProcessorTest(){
        Account acc = new Account(Name='test');
        insert acc;
        DocumentSelectorProcessor dsp = new DocumentSelectorProcessor(acc.Id,acc.Id,acc.Id,'Select Id FROM dmpl__JobQueueRecord__c');
        Database.executeBatch(dsp,1);
    }
}