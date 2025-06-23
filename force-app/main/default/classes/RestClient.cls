/**
 * @description This class provides an intelligent abstraction for
 * making REST callouts to external endpoints. It utilizes NamedCredentials
 * for security. This class is designated as Virtual so that
 * API Service classes can extend it, and make use of it's methods easily.
 */
@namespaceAccessible
public virtual class RestClient {
    /**
     * These two properties are not public - which means that in
     * order to manipulate them during a Unit test, we have to
     * mark them @testVisible
     */

    /**
     * @description The default headers to use, when none are specified
     */
    @testVisible
    private static Map<String, String> defaultHeaders = new Map<String, String>{
        'Content-Type' => 'application/json',
        'Accept' => 'application/json'
    };

    /**
     * @description The name of the Named Credential to use
     */
    @testVisible
    @namespaceAccessible
    protected String namedCredentialName { get; set; }

    /**
     * @description The Id of provider being used
     */
    @testVisible
    @namespaceAccessible
    protected Id providerId { get; set; }
    
    /**
     * @description The Id of request being used
     */
    @testVisible
    @namespaceAccessible
    protected Id requestId { get; set; }

    @testVisible
    @namespaceAccessible
    protected String logLevel { get; set; }

    @testVisible
    @namespaceAccessible
    protected Id queueId { get; set; }

    /**
     * @description This ENUM lists possible HTTP Verbs. Note: 'Delete' is an Apex Keyword (DML)
     * and as a result, the ENUM value 'DEL' is used for delete.
     */
    @namespaceAccessible
    public enum HttpVerb {
        GET,
        POST,
        PATCH,
        PUT,
        HEAD,
        DEL
    }

    /**
     * @description Constructor that sets Named Credential
     * @param  namedCredential name of the Named Credential to use
     */
    @namespaceAccessible
    public RestClient(String namedCredential) {
        this.namedCredentialName = namedCredential;
    }

    /**
     * @description This constructor isn't intended for use, which is why it's
     * access modifier is 'Protected'. However, any child class extending
     * this class will either have to implement constructors matching the one
     * above, or this constructor must exist. In order to make this abstraction
     * as useful as possible, we've elected to leave this constructor here,
     * but unavailable to anything but inner classes and classes that
     * extend this one.
     */
    @SuppressWarnings('PMD.EmptyStatementBlock') 
    @namespaceAccessible
    protected RestClient() {
    }

    /**
     * @description Omnibus callout method. This is the primary method for
     * making a REST callout. Most of the other methods in this class serve
     * as convient, syntactic sugar on this method.
     * @param   method Enum HTTP verb to use. i.e. GET
     * @param   path patch component of the callout url i.e. `/services/data/v39.0/SObjects`
     * @param   query Query portion of the URL i.e. `?q=SELECT Id FROM Account`
     * @param   body JSON string representing the body of the callout in post/patch situations
     * @param   headers A map<String,String> of headers to use while making this callout
     * @return HttpResponse  HttpResponse Obj
     */
    @testVisible
    @SuppressWarnings('PMD.ExcessiveParameterList')
    @namespaceAccessible
    protected HttpResponse makeApiCall(
        HttpVerb method,
        String path,
        String query,
        String body,
        Map<String, String> headers,
        Integer timeoutInMilliseconds 
    ) {
        String encodedQuery = String.isBlank(query)?'':EncodingUtil.urlEncode(query, 'UTF-8');
        if (method == HttpVerb.PATCH) {
            method = HttpVerb.POST;
            encodedQuery += '?_HttpMethod=PATCH';
        }
        HttpRequest apiRequest = new HttpRequest();
        apiRequest.setTimeout(timeoutInMilliseconds);
        if (method == HttpVerb.DEL) {
            apiRequest.setMethod('DELETE');
        } else {
            apiRequest.setMethod(String.valueOf(method));
        }
        Map<String, String> functionalHeaders = (headers != null)
            ? headers
            : RestClient.defaultHeaders;
        for (String header : functionalHeaders.keySet()) {
            apiRequest.setHeader(header, functionalHeaders.get(header));
        }
        if (
            String.isNotBlank(body) &&
            (method == HttpVerb.POST ||
            method == HttpVerb.PUT ||
            method == HttpVerb.PATCH)
        ) {
            apiRequest.setBody(body);
        }
        if(this.namedCredentialName!=null){
            apiRequest.setEndpoint(
                'callout:' +
                this.namedCredentialName +
                path +
                encodedQuery
            );
        }else {
            apiRequest.setEndpoint(
                path +
                encodedQuery 
            );    
        }
        Http http = new Http();
        HttpResponse toReturn = null;
        try{
            toReturn = http.send(apiRequest);
        }finally{
            InterfaceLogHelper.logRequest(
                this.providerId, 
                this.requestId,
                this.queueId, 
                apiRequest, 
                toReturn,
                logLevel,
                headers);
        }
        return toReturn;
    }

    /**
     * @description  Makes an HTTP Callout to an api resource.
     * Convienence method that assumes the Default Headers.
     * @param method HTTPVerb to use. See the enum above.
     * @param path   Http path component of the URL. ie: `/path/to/resource`
     * @param query  Query component of the URL ie: after `?foo=bar`
     * @param body   Body to send with this call.
     * @return      `HttpResponse`
     */
    @testVisible
    @SuppressWarnings('PMD.ExcessiveParameterList')
    @namespaceAccessible
    protected HttpResponse makeApiCall(
        HttpVerb method,
        String path,
        String query,
        String body,
        Integer timeoutInMilliseconds
    ) {
        return this.makeApiCall(
            method,
            path,
            query,
            body,
            RestClient.defaultHeaders,
            timeoutInMilliseconds
        );
    }

    /**
     * @description  convenience version of makeApiCall without body param.
     * Invokes omnibus version above, with blank body param and default headers.
     * @param method HTTPVerb to use. See the enum above.
     * @param path   Http path component of the URL. ie: `/path/to/resource`
     * @param query  Query component of the URL ie: after `?foo=bar`
     * @return      `HTTPResponse`
     */
    @testVisible
    @namespaceAccessible
    protected HttpResponse makeApiCall(
        HttpVerb method,
        String path,
        String query,
        Integer timeoutInMilliseconds
    ) {
        return this.makeApiCall(
            method,
            path,
            query,
            '',
            RestClient.defaultHeaders,
            timeoutInMilliseconds
        );
    }

    /**
     * @description  convenience version of makeApiCall without body or query
     * params.
     * Invokes omnibus version above, with blank body and query params
     * @param method HTTPVerb to use. See the enum above.
     * @param path   Http path component of the URL. ie: `/path/to/resource`
     * @return      `HTTPResponse`
     */
    @testVisible
    @namespaceAccessible
    protected HttpResponse makeApiCall(HttpVerb method, String path, Integer timeoutInMilliseconds) {
        return this.makeApiCall(
            method,
            path,
            '',
            '',
            RestClient.defaultHeaders,
            timeoutInMilliseconds
        );
    }

    /**
     * @description convenience method for a GET Call that only requires a path
     * @param path   Http path component of the URL. ie: `/path/to/resource`
     * @return     `HTTPResponse`
     */
    @testVisible
    @namespaceAccessible
    protected HttpResponse get(String path, Integer timeoutInMilliseconds) {
        return this.makeApiCall(HttpVerb.GET, path, timeoutInMilliseconds);
    }

    /**
     * @description convenience method for a GET Call that only requires a path
     * and query
     * @param path   Http path component of the URL. ie: `/path/to/resource`
     * @param query  Query component of the URL ie: after `?foo=bar`
     * @return     `HTTPResponse`
     */
    @testVisible
    @namespaceAccessible
    protected HttpResponse get(String path, String query, Integer timeoutInMilliseconds) {
        return this.makeApiCall(HttpVerb.GET, path, query, timeoutInMilliseconds);
    }

    /**
     * @description convenience method for deleteing a resource based only on
     * path
     * @param path   Http path component of the URL. ie: `/path/to/resource`
     * @return     `HTTPResponse`
     */
    @testVisible
    @namespaceAccessible
    protected HttpResponse del(String path, Integer timeoutInMilliseconds) {
        return this.makeApiCall(HttpVerb.DEL, path, timeoutInMilliseconds);
    }

    /**
     * @description convenience method for a Delete Call that only requires a
     * path and query
     * @param path   Http path component of the URL. ie: `/path/to/resource`
     * @param query  Query component of the URL ie: after `?foo=bar`
     * @return     `HTTPResponse`
     */
    @testVisible
    @namespaceAccessible
    protected HttpResponse del(String path, String query, Integer timeoutInMilliseconds) {
        return this.makeApiCall(HttpVerb.DEL, path, query, timeoutInMilliseconds);
    }

    /**
     * @description convenience method for a POST Call that only requires a path
     * and body
     * @param path   Http path component of the URL. ie: `/path/to/resource`
     * @param body   JSON string to post
     * @return     `HTTPResponse`
     */
    @testVisible
    @namespaceAccessible
    protected HttpResponse post(String path, String body, Integer timeoutInMilliseconds) {
        return this.makeApiCall(HttpVerb.POST, path, '', body, timeoutInMilliseconds);
    }

    /**
     * @description convenience method for a POST Call that only requires a
     * path, query and body
     * @param path   Http path component of the URL. ie: `/path/to/resource`
     * @param query  Query component of the URL ie: after `?foo=bar`
     * @param body   JSON string to post
     * @return     `HTTPResponse`
     */
    @testVisible
    @namespaceAccessible
    protected HttpResponse post(String path, String query, String body, Integer timeoutInMilliseconds) {
        return this.makeApiCall(HttpVerb.POST, path, query, body, timeoutInMilliseconds);
    }

    /**
     * @description convenience method for a PUT Call that only requires a path
     * and body
     * @param path   Http path component of the URL. ie: `/path/to/resource`
     * @param body   JSON string to post
     * @return     `HTTPResponse`
     */
    @testVisible
    @namespaceAccessible
    protected HttpResponse put(String path, String body, Integer timeoutInMilliseconds) {
        return this.makeApiCall(HttpVerb.PUT, path, '', body, timeoutInMilliseconds);
    }

    /**
     * @description convenience method for a PUT Call that only requires a path,
     * query and body
     * @param path   Http path component of the URL. ie: `/path/to/resource`
     * @param query  Query component of the URL ie: after `?foo=bar`
     * @param body   JSON string to post
     * @return     `HTTPResponse`
     */
    @testVisible
    @namespaceAccessible
    protected HttpResponse put(String path, String query, String body, Integer timeoutInMilliseconds) {
        return this.makeApiCall(HttpVerb.PUT, path, query, body, timeoutInMilliseconds);
    }

    /**
     * @description convenience method for a PATCH Call that only requires a
     * path, query and body
     * @param path   Http path component of the URL. ie: `/path/to/resource`
     * @param body   JSON string to post
     * @return     `HTTPResponse`
     */
    @testVisible
    protected HttpResponse patch(String path, String body, Integer timeoutInMilliseconds) {
        return this.makeApiCall(HttpVerb.PATCH, path, '', body, timeoutInMilliseconds);
    }

    /**
     * @description convenience method for a PATCH Call that only requires a
     * path, query and body
     * @param path   Http path component of the URL. ie: `/path/to/resource`
     * @param query  Query component of the URL ie: after `?foo=bar`
     * @param body   JSON string to post
     * @return     `HTTPResponse`
     */
    @testVisible
    @namespaceAccessible
    protected HttpResponse patch(String path, String query, String body, Integer timeoutInMilliseconds) {
        return this.makeApiCall(HttpVerb.PATCH, path, query, body, timeoutInMilliseconds);
    }

    /**
     * @description           A static wrapper for the main makeApiCall method
     * @param namedCredential The named credential to use
     * @param method          HTTPVerb enum value. See Enum above
     * @param path           Http path component of the URL. ie: `/path/to/resource`
     * @param query           Query component of the URL ie: after `?foo=bar`
     * @param body            JSON string to post
     * @param headers         Map<String,String> representing outgoing Request
     * headers
     * @return               `HTTPResponse`
     * @example
     * System.Debug(RestClient.makeApiCall('MockBin',
     *                                      RestClient.HttpVerb.GET,
     *                                      'GUID',
     *                                      '',
     *                                      '',
     *                                      new Map<String,String>()));
     */
    @SuppressWarnings('PMD.ExcessiveParameterList')
    @namespaceAccessible
    public static HttpResponse makeApiCall(
        String namedCredential,
        HttpVerb method,
        String path,
        String query,
        String body,
        Map<String, String> headers,
        Integer timeoutInMilliseconds
    ) {
        return new RestClient(namedCredential)
            .makeApiCall(method, path, query, body, headers, timeoutInMilliseconds);
    }

    /**
     * @description           A static wrapper for the main makeApiCall method
     * that assumes default headers.
     * @param namedCredential The named credential to use
     * @param method          HTTPVerb enum value. See Enum above
     * @param path           Http path component of the URL. ie: `/path/to/resource`
     * @param query           Query component of the URL ie: after `?foo=bar`
     * @return               `HTTPResponse`
     * @example
     * System.Debug(RestClient.makeApiCall('MockBin',
     *                                      RestClient.HttpVerb.GET,
     *                                      'GUID',
     *                                      ''));
     */
    @SuppressWarnings('PMD.ExcessiveParameterList')
    @namespaceAccessible
    public static HttpResponse makeApiCall(
        String namedCredential,
        HttpVerb method,
        String path,
        String query,
        Integer timeoutInMilliseconds
    ) {
        return new RestClient(namedCredential)
            .makeApiCall(method, path, query, '', RestClient.defaultHeaders, timeoutInMilliseconds);
    }

    /**
     * @description           A static wrapper for the main makeApiCall method
     * where you only need the path
     * @param namedCredential The named credential to use
     * @param method          HTTPVerb enum value. See Enum above
     * @param path           Http path component of the URL. ie: `/path/to/resource`
     * @return               `HTTPResponse`
     * @example
     * System.Debug(RestClient.makeApiCall('MockBin',
     *                                      RestClient.HttpVerb.GET,
     *                                      'GUID'));
     */
    @namespaceAccessible
    public static HttpResponse makeApiCall(
        String namedCredential,
        HttpVerb method,
        String path,
        Integer timeoutInMilliseconds
    ) {
        return new RestClient(namedCredential)
            .makeApiCall(method, path, '', '', RestClient.defaultHeaders, timeoutInMilliseconds);
    }
}