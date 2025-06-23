public with sharing class FieldsetInfo {
    
    @AuraEnabled
    public String apiName;
    
    @AuraEnabled
    public String label;
    
    @AuraEnabled
    public String namespaceName;

    public FieldsetInfo(
        string apiName,
        string label){
        this.apiName = apiName;
        this.label = label;
    }

    public FieldsetInfo(
        string apiName,
        string label,
        string namespaceName){
        this.apiName = apiName;
        this.label = label;
        this.namespaceName = namespaceName;
    }
}