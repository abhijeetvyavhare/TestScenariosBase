@isTest
public class InterfaceServiceProviderHelper_Test {
    
    @testSetup
    public static void Setup()
    {
        test.startTest();
        CreateAccountGroup();
        CreateAccount(); 
        CreateContactAddress();
        CreateBranch();
        CreateItems();
        CreateSKU();
        CreateItemLot();
        CreateItemFeatures();
        CreateItemComponent();
        CreateItemAlternate();
        CreateResource();
        CreatePriceList();
        CreateDiscountGroup();
        CreateTaxGroup();
        CreateTax();
        CreateInterfaceServiceProvider();
        CreateInterfaceServiceProviderRequest();
        CreateInterfaceQueue();
        test.stopTest();
    }
    
   @isTest
    public static void getFieldsByFieldSetName()
    {
        Try{
            Test.startTest();
            dmpl__InterfaceServiceProvider__c add =[select Id, Name,dmpl__ProviderType__c,(Select Id,dmpl__CustomFunction__c,dmpl__Function__c from InterfaceServiceProviderRequests__r)
                                                    from dmpl__InterfaceServiceProvider__c];
            MetadataHelper.getFieldsByFieldSetName('','');
            Test.stopTest();
            System.assert(add != null, 'Get Interface Service Provider data');
        }
        Catch(Exception e){}
    }
    
   
    @isTest
    public static void perfromAction()
    {
        Try{
            Test.startTest();
            dmpl__InterfaceServiceProvider__c add =[select Id, Name,dmpl__ProviderType__c,(Select Id,dmpl__CustomFunction__c,dmpl__Function__c from InterfaceServiceProviderRequests__r)
                                                    from dmpl__InterfaceServiceProvider__c];
            InterfaceServiceProviderController.testAction(add.Id,add.Id,add.Id,'','','');
            Test.stopTest();
            System.assert(add != null, 'Get Interface Service Provider data');
        }
        Catch(Exception e){}
    }
    
    @isTest
    public static void executeRequest()
    {
        try{
            Test.startTest();
            dmpl__InterfaceServiceProvider__c add =[select Id, Name,dmpl__ProviderType__c,(Select Id,dmpl__CustomFunction__c,dmpl__Function__c from InterfaceServiceProviderRequests__r)
                                                    from dmpl__InterfaceServiceProvider__c];
            InterfaceServiceProvider.perfromAction(add.Id,add.Id,add.Id);
            Test.stopTest();
            System.assert(add != null, 'Get Interface Service Provider data');
        }
        Catch(Exception e){}
    }
    
    @isTest
    public static void getRequest()
    {
        Test.startTest();
        dmpl__InterfaceServiceProvider__c add =[select Id, Name,(Select Id,dmpl__CustomFunction__c,dmpl__Function__c from InterfaceServiceProviderRequests__r)
                                                from dmpl__InterfaceServiceProvider__c];
        InterfaceServiceProviderHelper.getRequest(add,'dmpl__Function__c');
        System.assert(add != null, 'Get Interface Service Provider data');
        Test.stopTest();
    }
    
    @isTest
    public static void getProvider()
    {
        Test.startTest();
        string errorReceived;
        string expectedErrorCode = 'SOPOS001';
        try{
            dmpl__InterfaceServiceProvider__c add =[select Id, Name,dmpl__BranchId__c,dmpl__PartnerAccountId__c,dmpl__ProviderType__c,(Select Id,dmpl__CustomFunction__c,dmpl__Function__c from InterfaceServiceProviderRequests__r)
                                                    from dmpl__InterfaceServiceProvider__c];
            InterfaceServiceProviderHelper.getProvider('dmpl__ProviderType__c',add.dmpl__PartnerAccountId__c,add.dmpl__BranchId__c);
        }
        catch(Exception ex){
            errorReceived = ex.getMessage();
            
        }
        System.assertNotEquals(expectedErrorCode,errorReceived);
        Test.stopTest();
    }
    
    @isTest
    public static void getProvidernew()
    {
        Test.startTest();
        dmpl__InterfaceServiceProvider__c add =[select Id, Name,dmpl__BranchId__c,dmpl__PartnerAccountId__c,dmpl__ProviderType__c,(Select Id,dmpl__CustomFunction__c,dmpl__Function__c from InterfaceServiceProviderRequests__r)
                                                from dmpl__InterfaceServiceProvider__c];
        InterfaceServiceProviderHelper.getProvider(add.Id);
        System.assert(add != null, 'Get Interface Service Provider data');
        Test.stopTest();
    }
    
    @isTest
    public static void DynamicTextParser()
    {
        Test.startTest();
        dmpl__InterfaceServiceProvider__c add =[select Id, Name,dmpl__BranchId__c,dmpl__PartnerAccountId__c,dmpl__ProviderType__c,(Select Id,dmpl__CustomFunction__c,dmpl__Function__c from InterfaceServiceProviderRequests__r)
                                                from dmpl__InterfaceServiceProvider__c];
        DynamicTextParser.parse('',add);
        System.assert(add != null, 'Get Interface Service Provider data');
        Test.stopTest();
    }
    
    @isTest
    public static void evalValue()
    {
        Test.startTest();
        dmpl__InterfaceServiceProvider__c add =[select Id, Name,dmpl__BranchId__c,dmpl__PartnerAccountId__c,dmpl__ProviderType__c,(Select Id,dmpl__CustomFunction__c,dmpl__Function__c from InterfaceServiceProviderRequests__r)
                                                from dmpl__InterfaceServiceProvider__c];
        DynamicTextParser.evalValue('',add);
        System.assert(add != null, 'Get Interface Service Provider data');
        Test.stopTest();
    }
    
    @isTest
    public static void populateFields()
    {
        Test.startTest();
        dmpl__InterfaceServiceProvider__c add =[select Id, Name,dmpl__BranchId__c,dmpl__PartnerAccountId__c,dmpl__ProviderType__c,(Select Id,dmpl__CustomFunction__c,dmpl__Function__c from InterfaceServiceProviderRequests__r)
                                                from dmpl__InterfaceServiceProvider__c];
        DynamicTextParser.populateFields('',add);
        System.assert(add != null, 'Get Interface Service Provider data');
        Test.stopTest();
    }
    
    @isTest
    public static void populateCollections()
    {   
        String payload = '{"MessageIdentifier": "2-b6788df0-c93f-11ed-9e0a-028c02b44b96","ReturnCode": "500","ReturnCodeDescription": "Server Error","Status": "ERROR","Message": "Timestamp format must be yyyy-mm-dd hh:mm:ss[.fffffffff]","EHFFlag": "Y"}';
        String Payload1 = '{"customerNumber": {!dmpl__PartnerAccountId__r.ValidAccountNumber__c},"orderType": "D0M Auto Dealer Sale","orderTypeId": 1364,"customerPONumber": "{!Name}","origSystemDocumentReference": "{!Id}","priceListId": {!dmpl__PriceListId__r.ListHeaderId__c},"billToCustomer": [{"siteUseId": {!dmpl__BranchId__r.GIEABillToSiteUseId__c}}],"shipToCustomer": [{"siteUseId": {!dmpl__BranchId__r.GIEAShipToSiteUseId__c}}],"lines": [{!!dmpl__PurchaseOrderLines__r}{"origSystemDocumentLineReference": "{!Id}","itemNumber": "{!dmpl__ItemId__r.GIEAItemNumber__c}","orderedQuantity": {!dmpl__Quantity__c},"requestedDate": "{!RequestedDate__c}","returnReasonCode": "","returnContext": "","returnAttribute1": "","returnAttribute2": ""}{!!dmpl__PurchaseOrderLines__r}]}';
        Test.startTest(); 
        dmpl__InterfaceServiceProvider__c add =[select Id, Name,dmpl__BranchId__c,dmpl__PartnerAccountId__c,dmpl__ProviderType__c,(Select Id,dmpl__CustomFunction__c,dmpl__Function__c from InterfaceServiceProviderRequests__r)
                                                from dmpl__InterfaceServiceProvider__c];
        DynamicTextParser.populateCollections(Payload1,add);
        System.assert(add != null, 'Get Interface Service Provider data');
        Test.stopTest();
    }
    
    @isTest
    public static void logRequest()
    {
        Test.startTest();
        List  <dmpl__InterfaceLogEvent__e> event1 = new List<dmpl__InterfaceLogEvent__e>();
        dmpl__InterfaceServiceProviderRequest__c add =[select Id,dmpl__CustomFunction__c,dmpl__Function__c 
                                                       from dmpl__InterfaceServiceProviderRequest__c];
        InterfaceLogHelper.saveInterfaceLogs(event1
                                            );
        System.assert(add != null, 'Get Interface Service Provider data');
        Test.stopTest();
        
    }
    
    @isTest
    public static void parseResult()
    {
        Test.startTest();
        String payload = '{"MessageIdentifier": "2-b6788df0-c93f-11ed-9e0a-028c02b44b96","ReturnCode": "500","ReturnCodeDescription": "Server Error","Status": "ERROR","Message": "Timestamp format must be yyyy-mm-dd hh:mm:ss[.fffffffff]","EHFFlag": "Y"}';
        List <dmpl__InterfaceServiceProviderRequest__c> add1 =[select Id,dmpl__CustomFunction__c,dmpl__Function__c from dmpl__InterfaceServiceProviderRequest__c];
        
        dmpl__InterfaceServiceProvider__c add =[select Id, Name,dmpl__BranchId__c,dmpl__PartnerAccountId__c,dmpl__ProviderType__c,(Select Id,dmpl__CustomFunction__c,dmpl__Function__c from InterfaceServiceProviderRequests__r)
                                                from dmpl__InterfaceServiceProvider__c];
        //DynamicTextParser.parseResult('{    "data": {        "TranDtls": {            "TaxSch": "GST",            "SupTyp": "B2B",            "RegRev": "N",            "IgstOnIntra": "N"        },        "DocDtls": {            "Typ": "INV",            "No": "INV22060000",            "Dt": "01/04/2022"        },        "SellerDtls": {            "Gstin": "29AALFD7157J000",            "LglNm": "Dealer 1",            "TrdNm": "Dealer 1",            "Addr1": "",            "Addr2": "",            "Loc": "",            "Pin": ,            "Stcd": "29",            "Ph": "9886038319",            "Em": "ajanardan@deloitte.com"        },        "BuyerDtls": {            "Gstin": "03AAAFJ5993M1Z0",            "LglNm": "Customer 1",            "TrdNm": "Customer 1",            "Pos": "03",            "Addr1": "",            "Addr2": "",            "Loc": "",            "Pin": ,            "Stcd": "03",            "Ph": "9986632676",            "Em": "adiprakash@deloitte.com"        },        "DispDtls": {            "Nm": "Vaps Technosoft",            "Addr1": "N0 44 MIG",            "Addr2": "2nd stage, 1st cross",            "Loc": "Bangalore",            "Pin": 560100,            "Stcd": "29"        },        "ItemList": [            {                "SlNo": "",                "PrdDesc": "MODEL X",                "IsServc": "Y",                "HsnCd": "998365",                "BchDtls": {                    "Nm": "ASH-1208-01",                    "ExpDt": "12/08/2022",                    "WrDt": "12/08/2021"                },                "Barcde": "abc11210152",                "Qty": 1.00,                "FreeQty": 1.00,                "Unit": "BAG",                "UnitPrice": 500000.00,                "TotAmt": 500000.00,                "Discount": 0,                "PreTaxVal": 1,                "AssAmt": 9978.84,                "GstRt": 12,                "IgstAmt": 1197.46,                "CgstAmt": 0,                "SgstAmt": 0,                "TotItemVal": 11176.3,                "OrdLineRef": "3256",                "OrgCntry": "IN",                "PrdSlNo": "12345",                "AttribDtls": [                    {                        "Nm": "Rice",                        "Val": "10000"                    },                    {                        "Nm": "Sugar",                        "Val": "5000"                    },                    {                        "Nm": "Salt",                        "Val": "4000"                    }                ]            }        ],        "ValDtls": {            "AssVal": 19957.68,            "CgstVal": 0,            "SgstVal": 0,            "IgstVal": 2394.92,            "TotInvVal": 22352.60        },        "PayDtls": {            "Nm": "ABCDE",            "AccDet": "5697389713210",            "Mode": "Cash",            "FinInsBr": "SBIN11000",            "PayTerm": "100",            "PayInstr": "Gift",            "CrTrn": "test",            "DirDr": "test",            "CrDay": 100,            "PaidAmt": 10000,            "PaymtDue": 5000        },        "RefDtls": {            "InvRm": "TEST",            "DocPerdDtls": {                "InvStDt": "01/04/2022",                "InvEndDt": "01/04/2022"            },            "PrecDocDtls": [                {                    "InvNo": "DOC/002",                    "InvDt": "01/04/2022",                    "OthRefNo": "123456"                },                {                    "InvNo": "DOC/003",                    "InvDt": "01/04/2022",                    "OthRefNo": "123456"                },                {                    "InvNo": "DOC/004",                    "InvDt": "01/04/2022",                    "OthRefNo": "123456"                },                {                    "InvNo": "DOC/005",                    "InvDt": "01/04/2022",                    "OthRefNo": "123456"                }            ],            "ContrDtls": [                {                    "RecAdvRefr": "Doc/003",                    "RecAdvDt": "01/04/2022",                    "TendRefr": "Abc001",                    "ContrRefr": "Co123",                    "ExtRefr": "Yo456",                    "ProjRefr": "Doc-456",                    "PORefr": "Doc-789",                    "PORefDt": "01/04/2022"                },                {                    "RecAdvRefr": "Doc/001",                    "RecAdvDt": "01/04/2022",                    "TendRefr": "Abc001",                    "ContrRefr": "Co123",                    "ExtRefr": "Yo456",                    "ProjRefr": "Doc-456",                    "PORefr": "Doc-789",                    "PORefDt": "01/04/2022"                }            ]        },        "AddlDocDtls": [            {                "Url": "https: //einv-apisandbox.nic.in",                "Docs": "Test Doc",                "Info": "Document Test"            },            {                "Url": "https: //einv-apisandbox.nic.in/abc",                "Docs": "Test Doc1",                "Info": "Document Test1"            }        ],        "ExpDtls": {            "ShipBNo": "A-248",            "ShipBDt": "01/04/2022",            "Port": "INBLR4",            "RefClm": "N",            "ForCur": "INR",            "CntCode": "IN",            "ExpDuty": 0        },        "EwbDtls": {            "TransId": "12AWGPV7107B1Z1",            "TransName": "XYZ EXPORTS",            "TransMode": "1",            "Distance": 2179,            "TransDocNo": "DOC01",            "TransDocDt": "01/04/2022",            "VehNo": "ka123456",            "VehType": "R"        },        "subSupplyDesc": "Others",        "subSupplyType": "3",        "EwbRequired": true,        "EInvoiceRequired": true    }}','','','',add,add1);
        DynamicTextParser.parseResult(payload,'messageText','Successfully inserted Salesorder Header to GIEA','{!dmpl__ExternalId__c}:origSystemDocumentReference {!GIEAStatus__c}:status',add1[0],add1);
        System.assert(add != null, 'Get Interface Service Provider data');
        Test.stopTest();
    }
    
    @isTest
    public static void convert()
    {
        Try{
            Schema.DisplayType dt = Schema.DisplayType.TEXTAREA;
            dmpl__InterfaceServiceProvider__c add =[select Id, Name,dmpl__BranchId__c,dmpl__PartnerAccountId__c,dmpl__ProviderType__c,(Select Id,dmpl__CustomFunction__c,dmpl__Function__c from InterfaceServiceProviderRequests__r)
                                                    from dmpl__InterfaceServiceProvider__c];
            DynamicTextParser.convert(dt,add);
            System.assert(add != null, 'Get Interface Service Provider data');
        }
        Catch(Exception e){}
    }
   
    @isTest
    public static void convert1()
    {
        Try{
            Schema.DisplayType dt = Schema.DisplayType.BOOLEAN;
            dmpl__InterfaceServiceProvider__c add =[select Id, Name,dmpl__BranchId__c,dmpl__PartnerAccountId__c,dmpl__ProviderType__c,(Select Id,dmpl__CustomFunction__c,dmpl__Function__c from InterfaceServiceProviderRequests__r)
                                                    from dmpl__InterfaceServiceProvider__c];
            DynamicTextParser.convert(dt,add);
            System.assert(add != null, 'Get Interface Service Provider data');
        }
        Catch(Exception e){}
    }
    
    @isTest
    public static void convert2()
    {
        Try{
            Schema.DisplayType dt = Schema.DisplayType.DATETIME;
            dmpl__InterfaceServiceProvider__c add =[select Id, Name,dmpl__BranchId__c,dmpl__PartnerAccountId__c,dmpl__ProviderType__c,(Select Id,dmpl__CustomFunction__c,dmpl__Function__c from InterfaceServiceProviderRequests__r)
                                                    from dmpl__InterfaceServiceProvider__c];
            DynamicTextParser.convert(dt,add);
            System.assert(add != null, 'Get Interface Service Provider data');
        }
        Catch(Exception e){}
    }
    
    @isTest
    public static void convert3()
    {
        Try{
            Schema.DisplayType dt = Schema.DisplayType.INTEGER;
            dmpl__InterfaceServiceProvider__c add =[select Id, Name,dmpl__BranchId__c,dmpl__PartnerAccountId__c,dmpl__ProviderType__c,(Select Id,dmpl__CustomFunction__c,dmpl__Function__c from InterfaceServiceProviderRequests__r)
                                                    from dmpl__InterfaceServiceProvider__c];
            DynamicTextParser.convert(dt,add);
            System.assert(add != null, 'Get Interface Service Provider data');
        }
        Catch(Exception e){}
    }
    
    @isTest
    public static void convert4()
    {
        Try{
            Schema.DisplayType dt = Schema.DisplayType.LONG;
            dmpl__InterfaceServiceProvider__c add =[select Id, Name,dmpl__BranchId__c,dmpl__PartnerAccountId__c,dmpl__ProviderType__c,(Select Id,dmpl__CustomFunction__c,dmpl__Function__c from InterfaceServiceProviderRequests__r)
                                                    from dmpl__InterfaceServiceProvider__c];
            DynamicTextParser.convert(dt,add);
            System.assert(add != null, 'Get Interface Service Provider data');
            
        }
        Catch(Exception e){}
    }
    
    @isTest
    public static void convert5()
    {
        Try{
            Schema.DisplayType dt = Schema.DisplayType.CURRENCY;
            dmpl__InterfaceServiceProvider__c add =[select Id, Name,dmpl__BranchId__c,dmpl__PartnerAccountId__c,dmpl__ProviderType__c,(Select Id,dmpl__CustomFunction__c,dmpl__Function__c from InterfaceServiceProviderRequests__r)
                                                    from dmpl__InterfaceServiceProvider__c];
            DynamicTextParser.convert(dt,add);
            System.assert(add != null, 'Get Interface Service Provider data');
        }
        Catch(Exception e){}
    }
   
    @isTest
    public static void convert6()
    {
        Try{
            Schema.DisplayType dt = Schema.DisplayType.DOUBLE;
            dmpl__InterfaceServiceProvider__c add =[select Id, Name,dmpl__BranchId__c,dmpl__PartnerAccountId__c,dmpl__ProviderType__c,(Select Id,dmpl__CustomFunction__c,dmpl__Function__c from InterfaceServiceProviderRequests__r)
                                                    from dmpl__InterfaceServiceProvider__c];
            DynamicTextParser.convert(dt,add);
            System.assert(add != null, 'Get Interface Service Provider data');
        }
        Catch(Exception e){}
    }
    
    @isTest
    public static void setValue()
    {
        Test.startTest();
        List <dmpl__InterfaceServiceProviderRequest__c> add1 =[select Id,dmpl__CustomFunction__c,dmpl__Function__c from dmpl__InterfaceServiceProviderRequest__c];
        dmpl__InterfaceServiceProvider__c add =[select Id, Name,dmpl__BranchId__c,dmpl__PartnerAccountId__c,dmpl__ProviderType__c,(Select Id,dmpl__CustomFunction__c,dmpl__Function__c from InterfaceServiceProviderRequests__r)
                                                from dmpl__InterfaceServiceProvider__c];
        DynamicTextParser.setValue('',add,add1,add);
        System.assert(add != null, 'Get Interface Service Provider data');
        Test.stopTest();
    }
    
    @isTest
    public static void setObjectValue()
    {
        Test.startTest();
        List <dmpl__InterfaceServiceProviderRequest__c> add1 =[select Id,dmpl__CustomFunction__c,dmpl__Function__c from dmpl__InterfaceServiceProviderRequest__c];
        dmpl__InterfaceServiceProvider__c add =[select Id, Name,dmpl__BranchId__c,dmpl__PartnerAccountId__c,dmpl__ProviderType__c,(Select Id,dmpl__CustomFunction__c,dmpl__Function__c from InterfaceServiceProviderRequests__r)
                                                from dmpl__InterfaceServiceProvider__c];
        DynamicTextParser.setObjectValue(add,add1,'',add);
        System.assert(add != null, 'Get Interface Service Provider data');
        Test.stopTest();
    }
    
    @isTest
    public static void evalKeyValue()
    {
        Test.startTest();
        List <dmpl__InterfaceServiceProviderRequest__c> add1 =[select Id,dmpl__CustomFunction__c,dmpl__Function__c from dmpl__InterfaceServiceProviderRequest__c];
        dmpl__InterfaceServiceProvider__c add =[select Id, Name,dmpl__BranchId__c,dmpl__PartnerAccountId__c,dmpl__ProviderType__c,(Select Id,dmpl__CustomFunction__c,dmpl__Function__c from InterfaceServiceProviderRequests__r)
                                                from dmpl__InterfaceServiceProvider__c];
        Map<String,Object> map1 = new Map<String,Object>();
        map1.put('Close-Filled',add);
        DynamicTextParser.evalKeyValue('Dynamic-Text',map1);
        System.assert(add != null, 'Get Interface Service Provider data');
        Test.stopTest();
    }
    
    @isTest
    public static void parseResponseSchema()
    {
        Test.startTest();
        List <dmpl__InterfaceServiceProviderRequest__c> add1 =[select Id,dmpl__CustomFunction__c,dmpl__Function__c from dmpl__InterfaceServiceProviderRequest__c];
        dmpl__InterfaceServiceProvider__c add =[select Id, Name,dmpl__BranchId__c,dmpl__PartnerAccountId__c,dmpl__ProviderType__c,(Select Id,dmpl__CustomFunction__c,dmpl__Function__c from InterfaceServiceProviderRequests__r)
                                                from dmpl__InterfaceServiceProvider__c];
        Map<String,Object> map1 = new Map<String,Object>();
        map1.put('Close-Filled',add);
        
        DynamicTextParser.parseResponseSchema('Close-Filled',map1,add,add1);
        System.assert(add != null, 'Get Interface Service Provider data');
        Test.stopTest();
    }
    
    @isTest
    public static void updateInterfaceServiceProvider()
    {
        test.startTest();
        dmpl__InterfaceServiceProvider__c pro = [Select Id,Name,dmpl__ProviderType__c From dmpl__InterfaceServiceProvider__c limit 1];
        if(pro != null)
            pro.dmpl__ProviderType__c = 'File Storage';
        update pro;
        System.assert(pro != null, 'Interface service Provider Updated');
        test.stopTest();
    }
    
    private static void CreateItemLot()
    {
        List<dmpl__ItemLot__c> itemLot = new List<dmpl__ItemLot__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__SKU__c sku = [Select Id ,Name From dmpl__SKU__c LIMIT 1 ];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        itemLot.Add(new dmpl__ItemLot__c(dmpl__BranchId__c = branch.Id,
                                         dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                         dmpl__ItemId__c = item.Id,
                                         dmpl__SKUId__c =sku.Id,
                                         dmpl__BatchNo__c = 'AAA',
                                         dmpl__SerialNumber__c='BBB',
                                         dmpl__SupplierInvoiceNumber__c='CCC',
                                         dmpl__DateOfReceipt__c= date.today(),
                                         dmpl__DateOfMfg__c=date.today(),
                                         dmpl__TotalCost__c=10.2,
                                         dmpl__DateOfSupplierInvoice__c=date.today(),
                                         dmpl__Cost__c=38.3
                                        ));
        insert itemLot;       
    }
    
    @isTest
    public static void createFileClient()
    {
        test.startTest();
        dmpl__InterfaceServiceProvider__c pro = [Select Id,Name From dmpl__InterfaceServiceProvider__c LIMIT 1];
        Id providerId = pro.Id;
        System.assertEquals(providerId, pro.Id);
        test.stopTest();
    }
     @isTest
    public static void getQueueStatusTest()
    {
        test.startTest();
        dmpl__InterfaceQueue__c interfaceQueue=[select id from dmpl__InterfaceQueue__c limit 1];
        InterfaceServiceProviderController.getQueueStatus(interfaceQueue.id);
        InterfaceServiceProviderController.getQueueStatus(null);

        test.stopTest();
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
                                dmpl__LastName__c = 'Sale Invoice',
                                Fax = '09876',
                                Phone = '1234567891',
                                Website = 'www.Dealermatix.com',
                                Type = 'Prospect',
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
        
        Account partneraccount = new Account(Name = 'Partner-Test-Account',
                                             dmpl__LastName__c = 'Sale Invoice',
                                             dmpl__IsPartnerAccount__c = True, 
                                             dmpl__IsActive__c = true);
        insert partneraccount;
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__LastName__c = 'Sale Invoice',
                                              dmpl__IsCustomerAccount__c = True,
                                              dmpl__IsActive__c = true);
        insert customerAccount;
    }    
    
    private static void CreateBranch()
    {
        List<dmpl__Branch__c> branch = new List<dmpl__Branch__c>();
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        branch.Add(new dmpl__Branch__c(dmpl__PartnerAccountId__c =partnerAccount.Id,
                                       Name = 'Test-Branch',
                                       dmpl__IsActive__c = true,
                                       dmpl__MarketingName__c = 'Hero Electric',
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
                                       dmpl__ServiceEmail__c = 'Customer@Outlook.com',
                                       dmpl__Website__c = 'www.Dealer.com'));
        insert branch;
    }
    
    private static void CreateItems()
    {
        List<dmpl__Item__c> item = new List<dmpl__Item__c>();
        item.Add(new dmpl__Item__c(Name = 'Test-Item',
                                   dmpl__ItemCode__c = 'DMPL',
                                   dmpl__ItemType__c = 'Product',
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
                                   dmpl__RFID__c = 'O1234fgh'
                                  ));
        
    insert item;
    }
    
    private static void CreateSKU()
    {
        List<dmpl__SKU__c> sku = new List<dmpl__SKU__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        sku.add(new dmpl__SKU__c(Name = 'Test - SKU',
                                 dmpl__SKUCode__c = 'Test - SKU - Code',
                                 dmpl__UnitOfMeasureOfConversion__c = 10,
                                 dmpl__ProductColor__c = 'Sample',
                                 dmpl__IsDefault__c = false,
                                 dmpl__QuantityUnitOfMeasure__c ='Sample',
                                 dmpl__ItemId__c = item.Id));
        insert sku;
    }
    
    private static void CreateResource()
    {
        List<dmpl__Resource__c> resource = new List<dmpl__Resource__c>();
        Account partnerAccount = [Select Id,Name From Account LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        resource.add(new dmpl__Resource__c(Name = 'Test - Resource',
                                           dmpl__ResourceType__c = 'Sample',
                                           dmpl__IsActive__c = true,
                                           dmpl__Phone__c = '9999999999',
                                           dmpl__DefaultPartnerAccountId__c = partnerAccount.Id,
                                           dmpl__DefaultBranchId__c = branch.Id
                                          ));
        insert resource;
    }
    
    private static void CreateTaxGroup()
    {
        List<dmpl__TaxGroup__c> taxGroup = new List<dmpl__TaxGroup__c>();
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account'];
        dmpl__AccountGroup__c AccountGroup = [Select Id,Name FROM dmpl__AccountGroup__c LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        taxGroup.Add(new dmpl__TaxGroup__c(Name = 'Test - Tax Group',
                                           dmpl__PartnerAccountId__c = account.Id,
                                           dmpl__BranchId__c = branch.Id,
                                           dmpl__PartnerAccountGroupId__c= AccountGroup.Id,
                                           dmpl__IsActive__c=True,
                                           dmpl__Description__c='Text'
                                          ));
        insert taxGroup;
    }
    
    private static void CreateTax()
    {
        List<dmpl__Tax__c> tax = new List<dmpl__Tax__c>();
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c];
        tax.Add(new dmpl__Tax__c(Name = 'Test - Tax',
                                 dmpl__TaxGroupId__c = taxGroup.Id,
                                 dmpl__Type__c = 'Cess',
                                 dmpl__Rate__c = 10,
                                 dmpl__PostingFieldName__c = 'Tax1'
                                ));        
        insert tax;
    }
    
    private static void CreateDiscountGroup()
    {
        List<dmpl__DiscountGroup__c> DiscountGroup = new List<dmpl__DiscountGroup__c>();
        Account account = [Select Id, Name FROM Account LIMIT 1];
        DiscountGroup.add(new dmpl__DiscountGroup__c(dmpl__DiscountType__c = 'Sale Price',
                                                     Name = 'Discount Group' ));
        insert DiscountGroup;
    }
    
    private static void CreateSaleOrder()
    {
        List<dmpl__SaleOrder__c> saleOrder = new List<dmpl__SaleOrder__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        dmpl__ContactAddress__c contactAddress = [Select Id,Name,dmpl__AccountId__c From dmpl__ContactAddress__c LIMIT 1];
        dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        saleOrder.Add(new dmpl__SaleOrder__c(dmpl__AccountId__c = contactAddress.dmpl__AccountId__c,
                                             dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                             dmpl__BranchId__c = branch.Id,
                                             dmpl__DocumentDate__c = Date.today(),
                                             dmpl__Status__c = 'Draft',
                                             dmpl__BillingAddressId__c = contactAddress.Id,
                                             dmpl__ShippingAddressId__c = contactAddress.Id,
                                             dmpl__RequiredDate__c = Date.today(),
                                             dmpl__SalesExecutiveId__c = resource.Id,
                                             dmpl__BookingAmount__c = 100,
                                             dmpl__PromisedDate__c = Date.today(),
                                             dmpl__PerformReleaseFulfilment__c = false,
                                             dmpl__PerformReleaseInvoice__c = false,
                                             dmpl__PerformReleaseDelivery__c = false
                                            ));
        insert saleOrder;
        List<dmpl__SaleOrderLine__c> saleOrderLine = new List<dmpl__SaleOrderLine__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c SKU = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__TaxGroup__c TaxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        saleOrderLine.Add(new dmpl__SaleOrderLine__c(dmpl__SaleOrderId__c = saleOrder[0].Id,
                                                     dmpl__ItemId__c = item.Id,
                                                     dmpl__SKUId__c=SKU.Id,
                                                     dmpl__Quantity__c = 1,
                                                     dmpl__TaxGroupId__c=TaxGroup.Id,
                                                     dmpl__UnitPrice__c=1,
                                                     dmpl__Discount__c=1
                                                    ));
        insert saleOrderLine;
    }
    
    
    private static void CreateItemAlternate()
    {
        List<dmpl__ItemAlternate__c> itemAlternate = new List<dmpl__ItemAlternate__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        itemAlternate.add(new dmpl__ItemAlternate__c(dmpl__ItemId__c = item.Id,
            dmpl__AlternateType__c='Optional/ Interchangeable'
            
        ));
        insert itemAlternate;
    }
    
    private static void CreateItemFeatures()
    {
        List<dmpl__ItemFeature__c> itemFeature = new List<dmpl__ItemFeature__c>();
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        itemFeature.add(new dmpl__ItemFeature__c(Name = 'Item-Feature',
                                                 dmpl__ItemId__c = item.Id,
                                                 dmpl__PartnerAccountId__c = partnerAccount.Id,
                                                 dmpl__ShowinCatalog__c = false                                                 
                                                ));
        insert itemFeature;
    }
    
    private static void CreateItemComponent()
    {
        List<dmpl__ItemComponent__c> itemComponent = new List<dmpl__ItemComponent__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__ItemFeature__c itemFeature = [Select Id,Name From dmpl__ItemFeature__c LIMIT 1];
        itemComponent.add(new dmpl__ItemComponent__c(dmpl__ItemId__c = item.Id,
                                                     dmpl__SKUId__c = sku.Id,
                                                     dmpl__PackageType__c='Multiple Of Package',
                                                     dmpl__ComponentItemId__c=item.Id,
                                                     dmpl__Quantity__c=2,
                                                     dmpl__FeatureId__c = itemFeature.Id,
                                                     dmpl__SortOrder__c = 100));
        insert itemComponent;
    }
    
    private static void CreateInterfaceServiceProvider()
    {
        List<dmpl__InterfaceServiceProvider__c> interfaceService = new List<dmpl__InterfaceServiceProvider__c>();
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        interfaceService.add(new dmpl__InterfaceServiceProvider__c(dmpl__PartnerAccountId__c = partnerAccount.Id,
                                                                   Name = 'Test1',
                                                                   dmpl__BranchId__c = Branch.Id,
                                                                   dmpl__NamedCredentials__c='tesrt',
                                                                   dmpl__Logging__c='Callout',
                                                                   dmpl__CustomCredentialsUrl__c='www.rk.com',
                                                                   dmpl__ProviderType__c='REST Client'
                                                                  ));
        insert interfaceService;
    }
    
    private static void CreateInterfaceServiceProviderRequest()
    {
        List<dmpl__InterfaceServiceProviderRequest__c> interfaceServiceRequest = new List<dmpl__InterfaceServiceProviderRequest__c>();
        dmpl__InterfaceServiceProvider__c interfaceService = [Select Id,Name From dmpl__InterfaceServiceProvider__c LIMIT 1];
        interfaceServiceRequest.add(new dmpl__InterfaceServiceProviderRequest__c(
            dmpl__CustomFunction__c='TEXT1',
            dmpl__EndPoint__c='TEXT2',
            dmpl__Function__c='Custom Function',
            dmpl__HttpHeaders__c='tEST3',
            dmpl__IsAsynchronous__c=FALSE,
            dmpl__PayloadSchema__c='GFGFDHBDFJBD',
            dmpl__ResponseSchema__c='DBHDFBDBJSB',
            dmpl__StatusEndPoint__c='CHCVCVMCVNMCV',
            dmpl__StatusPayloadSchema__c='BCHCVHBVCJCBBCJBCJBC',
            dmpl__StatusResponseSchema__c='BB CB D C',
            dmpl__InterfaceServiceProviderId__c=interfaceService.Id,
            dmpl__HttpVerb__c='GET',
            dmpl__HttpQuery__c='vdhdvhd'
        ));
        insert interfaceServiceRequest;
    }
    
    private static void CreateInterfaceQueue()
    {
        List<dmpl__InterfaceQueue__c> interfaceQueue =new List<dmpl__InterfaceQueue__c>();
        dmpl__InterfaceServiceProvider__c interfaceService = [Select Id,Name From dmpl__InterfaceServiceProvider__c LIMIT 1];
        dmpl__InterfaceServiceProviderRequest__c request = [Select Id,Name From dmpl__InterfaceServiceProviderRequest__c LIMIT 1]; 
        interfaceQueue.Add(new dmpl__InterfaceQueue__c(
            dmpl__InterfaceProviderId__c =interfaceService.Id,
            dmpl__InterfaceRequestId__c = request.Id));
        insert interfaceQueue;
    }  
    
    private static void CreateContactAddress()
    {
        List<dmpl__ContactAddress__c> contactAddress = new List<dmpl__ContactAddress__c>();
        Account account = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        contactAddress.add(new dmpl__ContactAddress__c(dmpl__AccountId__c = account.Id,
                                                       Name = 'Test - Contact - Address',
                                                       dmpl__AddressType__c = 'Both'                                                      
                                                      ));
        insert contactAddress;
    }
    
    private static void CreatePriceList()
    {
        List<dmpl__PriceList__c> priceList =new List<dmpl__PriceList__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account'];
        
        priceList.Add(new dmpl__PriceList__c(Name='Test-Price - List',
                                             dmpl__PartnerAccountId__c=account.Id,
                                             dmpl__BranchId__c = branch.Id));
        insert priceList;
    }  
    
}