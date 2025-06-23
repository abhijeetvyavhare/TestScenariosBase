global with sharing class FileResponseResult extends JobResponseResult{
    public FileResponseResult(
        Boolean pIsSuccessful,
        String pParsedRequest,
        Object pFileContent)
    {
        super(pIsSuccessful, pParsedRequest);
        fileContent = pFileContent;
    }

    @AuraEnabled
    global Object fileContent { get; set; }

    @AuraEnabled
    global String fileName { get; set; }

    @AuraEnabled
    global String fileTitle { get; set; }
    
}