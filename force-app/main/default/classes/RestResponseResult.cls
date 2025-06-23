global with sharing class RestResponseResult extends JobResponseResult{
    public RestResponseResult(
        String pHeaders,
        String pBody,
        Integer pStatusCode,
        String pStatus,
        String pParsedRequest){
        super(
            pStatusCode == 200 || pStatusCode == 201,
            pParsedRequest);
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

}