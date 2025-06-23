global virtual with sharing class JobResponseResult {
    public JobResponseResult(
        Boolean pIsSuccessful,
        String pParsedRequest){
        isSuccessful = pIsSuccessful;
        parsedRequest = pParsedRequest;
    }
    
    public JobResponseResult(
        Boolean pIsSuccessful,
        String pParsedRequest,
        String pMesage){
        isSuccessful = pIsSuccessful;
        parsedRequest = pParsedRequest;
        message = pMesage;
    }

    public JobResponseResult(
        Boolean pIsSuccessful){
        this.isSuccessful = pIsSuccessful;
    }

    @AuraEnabled
    global Boolean isSuccessful { get; set; }

    @AuraEnabled
    global String parsedRequest { get; set; }

    @AuraEnabled
    global String message { get; set; }

    @AuraEnabled
    global Boolean hasIncrementalData { get; set; }
}