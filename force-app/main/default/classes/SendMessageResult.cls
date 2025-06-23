public with sharing class SendMessageResult {

    public SendMessageResult(){

    }
    
    public SendMessageResult(
        Boolean result, 
        String error){
            this.result = result;
            this.error = error;
    }
    public Boolean result {get; set;}
    public String error {get; set;}
}