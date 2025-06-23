public with sharing class FieldsetFieldInfo {
    @AuraEnabled
    public Boolean dbRequired;
    
    @AuraEnabled
    public String apiName;
    
    @AuraEnabled
    public String label;
    
    @AuraEnabled
    public Boolean required;
    
    @AuraEnabled
    public String type;
    
    @AuraEnabled
    public Boolean isHidden;

    public FieldsetFieldInfo(string apiName){
        this.apiName = apiName;
    }

    public FieldsetFieldInfo(Schema.FieldSetMember fieldSetMember)
    {
        this.dbRequired = fieldSetMember.dbRequired;
        this.apiName = fieldSetMember.fieldPath;
        this.label = fieldSetMember.label;
        this.required = fieldSetMember.required || fieldSetMember.dbRequired;
        this.type = String.valueOf(fieldSetMember.getType());
    }
}