global with sharing class DocumentActionResult {

    public DocumentActionResult(
        String status,
        String message){
        this.status = status;
        this.message = message;
    }
    
    public DocumentActionResult(String error){
        this.status = 'error';
        this.error = error;
    }

    public DocumentActionResult(Database.Error error){
        this.status = 'error';
        this.error = error.getMessage();
    }

    public DocumentActionResult(List<Database.Error> errors){
        this.status = 'error';
        this.error = '';
        for(Database.Error error : errors){
            this.error += error.getMessage();
        }
    }
    
    public static DocumentActionResult SuccessResult(){
        return new DocumentActionResult('success', 'Action performed successfully!');
    }
    
    public static DocumentActionResult FailedResult(string error){
        return new DocumentActionResult(error);
    }

    public static DocumentActionResult InitFrom(Database.SaveResult result){
        if(result == null){
            return new DocumentActionResult('No result returned!');
        }
        if(result.isSuccess()){
            return SuccessResult();
        } else {
            return new DocumentActionResult(result.errors);
        }
    }

    public static DocumentActionResult InitFrom(List<Database.SaveResult> results){
        if(results == null){
            return new DocumentActionResult('No result returned!');
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
            return new DocumentActionResult(errors);
        }
    }

    @AuraEnabled
    global String message { get; set; }

    @AuraEnabled
    global String status { get; set; }

    @AuraEnabled
    global String error { get; set; }

}