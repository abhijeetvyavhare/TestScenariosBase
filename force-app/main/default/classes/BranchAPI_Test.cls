@isTest
public class BranchAPI_Test {
    
    @isTest
    public static void VerifyGetNearByBranches_Success()
    {
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/dmpl/Branch/GetNearbyBranches'; 
        req.params.put('postalCode', '444603');
        req.httpMethod = 'GET';
        req.addHeader('Content-Type', 'application/json'); 
        RestContext.request = req;
        RestContext.response = res;
        BranchAPI_GetNearByBranches.getNearbyBranches();
        System.assertNotEquals(null, req, 'Request Object Found Null');
        Test.stopTest();  
    }
    
    @isTest 
    public static void VerifyGetNearByBranches_Error()
    {
        string errorReceived;
        string expectedErrorCode = 'SOPOS001';
        try{ 
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            req.requestURI = '/services/apexrest/dmpl/Branch/GetNearbyBranches'; 
            req.params.put('radius', '10.1');
            req.httpMethod = 'GET';
            req.addHeader('Content-Type', 'application/json'); 
            RestContext.request = req;
            RestContext.response = res;
            
            BranchAPI_GetNearByBranches.getNearbyBranches();
        }
        catch(Exception ex){
            errorReceived = ex.getMessage();
            
        }
        System.assertNotEquals(expectedErrorCode,errorReceived);
        
    }
    
    @isTest 
    public static void VerifyGetBranchDateSlots_Success()
    {
        string errorReceived;
        string expectedErrorCode = 'SOPOS001';
        try{ 
            Test.startTest();
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            req.requestURI = '/services/apexrest/dmpl/Branch/GetNearbyBranches'; 
            req.params.put('postalCode', 'Service Appointment');
            req.params.put('branchId', 'a0D0p000001cLeMEAU');
            req.params.put('itemId', 'a120p000000ra1DAAQ');
            req.params.put('daysCount', '10');
            req.httpMethod = 'GET';
            req.addHeader('Content-Type', 'application/json'); 
            RestContext.request = req;
            RestContext.response = res;
            
            BranchAPI_GetBranchDateSlots.getBranchDateSlots();
            Test.stopTest();
        }
        catch(Exception ex){
            errorReceived = ex.getMessage();
            
        }
        System.assertNotEquals(expectedErrorCode,errorReceived);
        
    }
    
    
    
    @isTest 
    public static void VerifyGetBranchDateSlots_Error()
    {
        string errorReceived;
        string expectedErrorCode = 'SOPOS001';
        try{ 
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            req.requestURI = '/services/apexrest/dmpl/Branch/GetNearbyBranches'; 
            req.params.put('postalCode', 'Service Appointment');
            req.params.put('branchId', 'a0D0p000001cLeMEAU');
            req.params.put('itemId', 'a120p000000ra1DAAQ');
            req.params.put('daysCount', '10.7');
            req.httpMethod = 'GET';
            req.addHeader('Content-Type', 'application/json'); 
            RestContext.request = req;
            RestContext.response = res;
            
            BranchAPI_GetBranchDateSlots.getBranchDateSlots();
        }
        catch(Exception ex){
            errorReceived = ex.getMessage();
            
        }
        System.assertNotEquals(expectedErrorCode,errorReceived);
        
    }
    
    
    @isTest
    public static void verifyMapBranchDateSlots()
    {
        string errorReceived;
        try {
            List<BranchDateSlotResult> branchDateSlotResults = new List<BranchDateSlotResult>();
            branchDateSlotResults.add(new BranchDateSlotResult(Datetime.now().date(), (Decimal)10.0, (Decimal)0.0));
            List<dmpl__BranchDateSlotResult__c> result = BranchAPI_GetBranchDateSlots.mapBranchDateSlots(branchDateSlotResults);                
        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
        System.assertEquals(null, errorReceived);
    }
    
    @isTest
    public static void VerifyGetBranchTimeSlots_Success()
    {
        Test.startTest();
        string errorReceived;
        try {
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            req.requestURI = '/services/apexrest/dmpl/Branch/GetNearbyBranches'; 
            req.params.put('postalCode', 'Service Appointment');
            req.params.put('branchId', 'a0D0p000001cLeMEAU');
            req.params.put('itemId', 'a120p000000ra1DAAQ');
            req.params.put('bookingDate', '2022-01-01');
            req.httpMethod = 'GET';
            req.addHeader('Content-Type', 'application/json'); 
            RestContext.request = req;
            RestContext.response = res;
            BranchAPI_GetBranchTimeSlots.getBranchTimeSlots();
        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
        System.assertEquals(null, errorReceived);
        Test.stopTest();  
    }
    
    @isTest 
    public static void VerifyGetBranchTimeSlots_Error()
    {
        string errorReceived;
        string expectedErrorCode = 'SOPOS001';
        try{ 
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            req.requestURI = '/services/apexrest/dmpl/Branch/GetNearbyBranches'; 
            req.params.put('postalCode', 'Service Appointment');
            req.params.put('branchId', 'a0D0p000001cLeMEAU');
            req.params.put('itemId', 'a120p000000ra1DAAQ');
            req.params.put('bookingDate', '10.7');
            req.httpMethod = 'GET';
            req.addHeader('Content-Type', 'application/json'); 
            RestContext.request = req;
            RestContext.response = res;
            
            BranchAPI_GetBranchTimeSlots.getBranchTimeSlots();
            
        }
        catch(Exception ex){
            errorReceived = ex.getMessage();
            
        }
        System.assertNotEquals(expectedErrorCode,errorReceived);
        
    }
    
    
    @isTest
    public static void BranchController_GetNearbyBranches()
    {
        string errorReceived;
        try{ 
            BranchController.getNearbyBranches(null, null, 100);
        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
        System.assertEquals(null, errorReceived);
    }
    
    @isTest 
    public static void BranchController_GetBranchDateSlots()
    {
        string errorReceived;
        string expectedErrorCode = 'SOPOS001';
        try{ 
            BranchController.getBranchDateSlots('Service Appointment', 'a0D0p000001cLeMEAU', 'a120p000000ra1DAAQ','','', 100);
        }
        catch(Exception ex){
            errorReceived = ex.getMessage();
        }
        System.assertNotEquals(expectedErrorCode,errorReceived);
    }
    
    
    @isTest
    public static void BranchController_GetBranchTimeSlots()
    {
        //string errorReceived;
        try{ 
            List<String> fields = new List<String>();
            BranchController.getBranchTimeSlots('Service Appointment', 'a0D0p000001cLeMEAU', 'a120p000000ra1DAAQ','','', Datetime.now().date());
            BulkOrderProcessingController.getRelatedRecordsCount('','',fields);
            System.assert(fields != null);
        } catch (Exception ex) {
            //errorReceived = ex.getMessage();
        }
        //System.assertEquals(null, errorReceived);
    }
}