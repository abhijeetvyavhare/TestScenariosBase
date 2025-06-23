@isTest
public class RestClient_Test {

    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{"status":"success","message":"Mock response"}');
            return res;
        }
    }

    private static void setMockCallout() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
    }

    @isTest
    static void testGetCallout() {
        setMockCallout();
        
        RestClient client = new RestClient('Credential');
        HttpResponse res = client.get('/path', 5000);
    }

    @isTest
    static void testPostCallout() {
        setMockCallout();
        
        RestClient client = new RestClient('Credential');
        String body = '{"key":"value"}';
        HttpResponse res = client.post('/path', body, 5000);
    }

    @isTest
    static void testPutCallout() {
        setMockCallout();
        
        RestClient client = new RestClient('Credential');
        String body = '{"key":"value"}';
        HttpResponse res = client.put('/path', body, 5000);
    }

    @isTest
    static void testDeleteCallout() {
        setMockCallout();
        
        RestClient client = new RestClient('Credential');
        HttpResponse res = client.del('/path', 5000);
    }

    @isTest
    static void testApiCallWithCustomHeaders() {
        setMockCallout();
        
        RestClient client = new RestClient('Credential');
        Map<String, String> headers = new Map<String, String>{ 'Custom-Header' => 'HeaderValue' };
        HttpResponse res = client.makeApiCall(RestClient.HttpVerb.GET, '/path', '', '', headers, 5000);
    }

    @isTest
    static void testPatchCallout() {
        setMockCallout();
        
        RestClient client = new RestClient('Credential');
        String body = '{"key":"value"}';
        HttpResponse res = client.patch('/path', body, 5000);
    }

    @isTest
    static void testApiCallWithQuery() {
        setMockCallout();
        
        RestClient client = new RestClient('Credential');
        String query = 'foo=bar';
        HttpResponse res = client.get('/path', query, 5000);
    }

    @isTest
    static void testConstructor() {
        RestClient client = new RestClient('Credential');
    }

    @isTest
    static void testStaticMakeApiCall() {
        setMockCallout();
        
        HttpResponse res = RestClient.makeApiCall(
            'Credential', 
            RestClient.HttpVerb.GET, 
            '/path', 
            '', 
            '', 
            new Map<String, String>(), 
            5000
        );
    }
}