global with sharing class HeadlessActionResult {
    global HeadlessActionResult(Boolean pResult, String pMessage) {
        this.result = pResult;
        this.message = pMessage;
    }

    @AuraEnabled
    global Boolean result { get; set; }

    @AuraEnabled
    global String message { get; set; }

}