public with sharing class ImportResult {

    @AuraEnabled
    public String objectApiName {get; set;}

    @AuraEnabled
    public Id objectId {get; set;}

    @AuraEnabled
    public String name {get; set;}

    @AuraEnabled
    public String error {get; set;}
    
    @AuraEnabled
    public Boolean isSuccess {get; set;}

    public void setErrors(List<Database.Error> errors){
        if(this.error == null){
            this.error = '';
        }
        
        if(errors.size() > 0){
            for(Database.Error errorItem : errors){
                this.error += errorItem.getMessage() + '\n';
            }
        }
    }

    public void addError(String error){
        if(this.error == null){
            this.error = '';
        }
        this.error += error + '\n';
    }
}