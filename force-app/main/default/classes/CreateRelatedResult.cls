global with sharing class CreateRelatedResult {
 
    global CreateRelatedResult(
        String pDocumentName,
        Id dDocmentId,
        String pDocumentLabel){
        documentName = pDocumentName;
        documentId = dDocmentId;
        documentLabel = pDocumentLabel;
        status = 'success';
    }
    
    global CreateRelatedResult(String pError){
        status = 'error';
        error = pError;
    }
 
    global CreateRelatedResult(
        String status,
        String message){
        this.status = status;
        this.message = message;
    }
    
    global CreateRelatedResult(
        Id queueId){
        this.status = 'queued';
        this.queueId = queueId;
    }
 
    global CreateRelatedResult(Database.Error error){
        this.status = 'error';
        this.error = error.getMessage();
    }
 
    global CreateRelatedResult(List<Database.Error> errors){
        this.status = 'error';
        this.error = '';
        for(Database.Error error : errors){
            this.error += error.getMessage();
        }
    }
    
    global static CreateRelatedResult SuccessResult(){
        return new CreateRelatedResult('success', 'Action performed successfully!');
    }
    
    global static CreateRelatedResult FailedResult(string error){
        return new CreateRelatedResult(error);
    }
 
    global static CreateRelatedResult InitFrom(Map<Id, SObject> documents){
        if(documents!=null && documents.size()>0){
            SObject document = documents.values()[0];
            CreateRelatedResult result = new CreateRelatedResult(
                (String)document.get('Name'),
                document.Id,
                document.getSObjectType().getDescribe().getLabel()
            );
            Map<String,SObject> resultTyped = new Map<String,SObject>();
            for(Id docId : documents.keySet()){
                resultTyped.put(docId, documents.get(docId));
            }
            result.resultDocuments = resultTyped;
            return result;
        }
        return new CreateRelatedResult('No Document exists to perform this action!');
    }
 
    global static CreateRelatedResult InitFrom(Map<String, SObject> documents){
        if(documents!=null && documents.size()>0){
            SObject document = documents.values()[0];
            CreateRelatedResult result = new CreateRelatedResult(
                (String)document.get('Name'),
                document.Id,
                document.getSObjectType().getDescribe().getLabel()
            );
            result.resultDocuments = documents;
            return result;
        }
        return new CreateRelatedResult('No Document exists to perform this action!');
    }
 
    global static CreateRelatedResult InitFrom(Database.SaveResult result){
        if(result == null){
            return new CreateRelatedResult('No Document exists to perform this action!');
        }
        if(result.isSuccess()){
            return SuccessResult();
        } else {
            return new CreateRelatedResult(result.errors);
        }
    }
 
    global static CreateRelatedResult InitFrom(List<Database.SaveResult> results){
        if(results == null){
            return new CreateRelatedResult('No Document exists to perform this action!');
        }
        List<Database.Error> errors = new List<Database.Error>();
        for(Database.SaveResult result : results){
            if(!result.isSuccess()){
                errors.addAll(result.getErrors());
            }
        }
        if(errors.size() == 0){
            return SuccessResult();
        } else {
            return new CreateRelatedResult(errors);
        }
    }

    @AuraEnabled
    global String message { get; set; }

    @AuraEnabled
    global String documentName { get; set; }

    @AuraEnabled
    global Id documentId { get; set; }

    @AuraEnabled
    global String documentLabel { get; set; }

    @AuraEnabled
    global String status { get; set; }

    @AuraEnabled
    global String error { get; set; }

    @AuraEnabled
    global Id queueId { get; set; }

    public Map<String, SObject> resultDocuments { get; set; }

}