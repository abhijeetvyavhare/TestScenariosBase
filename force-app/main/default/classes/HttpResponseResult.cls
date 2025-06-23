//Deprecated ONLY INCLUDED FOR PACKAGING
global with sharing class HttpResponseResult{
    public HttpResponseResult(
        String pHeaders,
        String pBody,
        Integer pStatusCode,
        String pStatus,
        String pParsedRequest){
        parsedRequest = pParsedRequest;
        headers = pHeaders;
        body = pBody;
        statusCode = pStatusCode;
        status = pStatus;
    }

    @AuraEnabled
    global String headers { get; set; }

    @AuraEnabled
    global String body { get; set; }

    @AuraEnabled
    global Integer statusCode { get; set; }

    @AuraEnabled
    global String status { get; set; }

    @AuraEnabled
    global Boolean isSuccessful { get; set; }

    @AuraEnabled
    global String parsedRequest { get; set; }

    @AuraEnabled
    global Boolean hasIncrementalData { get; set; }
}