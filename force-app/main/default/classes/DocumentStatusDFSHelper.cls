@namespaceAccessible
public with sharing class DocumentStatusDFSHelper extends DomainFeatureSettingHelper{
  
    private static final string FEATURE_Document_Status_Restrict_Edits = 'Document Status : Restrict Edits';
    private static final string FEATURE_Document_Status_Restrict_Edits_Field_List='Document Status : Restrict Edits Field List';
    private static final string FEATURE_Document_Status_Allow_Jumps= 'Document Status : Allow Jumps';
    private static final string FEATURE_Document_Status_Allow_Jump_Start= 'Document Status : Allow Jump Start';
    private static final string FEATURE_Document_Status_Related_Object_Edit = 'Document Status : Related Object Edit';
    private static final string FEATURE_Document_Status_Set_Flags = 'Document Status : Set Flag';
    private static final string FEATURE_Document_Status_ReSet_Flags = 'Document Status : ReSet Flag';
  
    @namespaceAccessible
    public void DocumentStatusSetFlag(string objectApiName, string statusFieldApiName, List<SObject> oldEntries, List<SObject> newEntries){
        List<dmpl__DomainSetting__mdt> featureSettings = getDomainSetting(FEATURE_Document_Status_Set_Flags, objectApiName);
        List<dmpl__DomainSetting__mdt> applicableFs = new List<dmpl__DomainSetting__mdt>();
        if(hasBranchDomainSetting(featureSettings, applicableFs) 
            || hasPartnerDomainSetting(featureSettings, applicableFs) 
            || hasGlobalDomainSetting(featureSettings, applicableFs)){
                Map<Id, SObject> oldObjectsMap = new Map<Id, SObject>(oldEntries);
                for(SObject newEntry : newEntries){
                    SObject oldEntry = oldObjectsMap.get(newEntry.Id);
                    for(dmpl__DomainSetting__mdt fs : applicableFs){
                        if(fs.dmpl__Status__c!=null 
                            && oldEntry.get(statusFieldApiName) != newEntry.get(statusFieldApiName) 
                            && fs.dmpl__Status__c.contains((String)newEntry.get(statusFieldApiName)) && fs.dmpl__FieldNameId__r!=null){
                                Schema.DescribeFieldResult field = Schema.getGlobalDescribe().get(objectApiName)?.getDescribe().fields.getMap().get(fs.dmpl__FieldNameId__r.QualifiedApiName)?.getDescribe();
                            if(field!=null && field.getType() == Schema.DisplayType.Boolean){
                                newEntry.put(fs.dmpl__FieldNameId__r.QualifiedApiName, true);
                            }
                        }
                    }
                }
            }
    }
    
    @namespaceAccessible
    public void DocumentStatusSetFlag(string objectApiName, string statusFieldApiName, List<SObject> newEntries){
        List<dmpl__DomainSetting__mdt> featureSettings = getDomainSetting(FEATURE_Document_Status_Set_Flags, objectApiName);
        List<dmpl__DomainSetting__mdt> applicableFs = new List<dmpl__DomainSetting__mdt>();
        if(hasBranchDomainSetting(featureSettings, applicableFs) 
            || hasPartnerDomainSetting(featureSettings, applicableFs) 
            || hasGlobalDomainSetting(featureSettings, applicableFs)){
                for(SObject newEntry : newEntries){
                    for(dmpl__DomainSetting__mdt fs : applicableFs){
                        if(fs.dmpl__Status__c!=null 
                            && fs.dmpl__Status__c.contains((String)newEntry.get(statusFieldApiName)) && fs.dmpl__FieldNameId__r!=null){
                                Schema.DescribeFieldResult field = Schema.getGlobalDescribe().get(objectApiName)?.getDescribe().fields.getMap().get(fs.dmpl__FieldNameId__r.QualifiedApiName)?.getDescribe();
                            if(field!=null && field.getType() == Schema.DisplayType.Boolean){
                                newEntry.put(fs.dmpl__FieldNameId__r.QualifiedApiName, true);
                            }
                        }
                    }
                }
            }
    }

    @namespaceAccessible
    public void DocumentStatusReSetFlag(string objectApiName, string statusFieldApiName, List<SObject> oldEntries, List<SObject> newEntries){
        List<dmpl__DomainSetting__mdt> featureSettings = getDomainSetting(FEATURE_Document_Status_ReSet_Flags, objectApiName);
        List<dmpl__DomainSetting__mdt> applicableFs = new List<dmpl__DomainSetting__mdt>();
        if(hasBranchDomainSetting(featureSettings, applicableFs) 
            || hasPartnerDomainSetting(featureSettings, applicableFs) 
            || hasGlobalDomainSetting(featureSettings, applicableFs)){
                Map<Id, SObject> oldObjectsMap = new Map<Id, SObject>(oldEntries);
                for(SObject newEntry : newEntries){
                    SObject oldEntry = oldObjectsMap.get(newEntry.Id);
                    for(dmpl__DomainSetting__mdt fs : applicableFs){
                        if(fs.dmpl__Status__c!=null 
                            && oldEntry.get(statusFieldApiName) != newEntry.get(statusFieldApiName) 
                            && fs.dmpl__Status__c.contains((String)newEntry.get(statusFieldApiName)) && fs.dmpl__FieldNameId__r!=null){
                                Schema.DescribeFieldResult field = Schema.getGlobalDescribe().get(objectApiName)?.getDescribe().fields.getMap().get(fs.dmpl__FieldNameId__r.QualifiedApiName)?.getDescribe();
                            if(field!=null && field.getType() == Schema.DisplayType.Boolean){
                                newEntry.put(fs.dmpl__FieldNameId__r.QualifiedApiName, false);
                            }
                        }
                    }
                }
            }
    }

    @namespaceAccessible
    public void DocumentStatusReSetFlag(string objectApiName, string statusFieldApiName, List<SObject> newEntries){
        List<dmpl__DomainSetting__mdt> featureSettings = getDomainSetting(FEATURE_Document_Status_ReSet_Flags, objectApiName);
        List<dmpl__DomainSetting__mdt> applicableFs = new List<dmpl__DomainSetting__mdt>();
        if(hasBranchDomainSetting(featureSettings, applicableFs) 
            || hasPartnerDomainSetting(featureSettings, applicableFs) 
            || hasGlobalDomainSetting(featureSettings, applicableFs)){
                for(SObject newEntry : newEntries){
                    for(dmpl__DomainSetting__mdt fs : applicableFs){
                        if(fs.dmpl__Status__c!=null 
                            && fs.dmpl__Status__c.contains((String)newEntry.get(statusFieldApiName)) && fs.dmpl__FieldNameId__r!=null){
                                Schema.DescribeFieldResult field = Schema.getGlobalDescribe().get(objectApiName)?.getDescribe().fields.getMap().get(fs.dmpl__FieldNameId__r.QualifiedApiName)?.getDescribe();
                            if(field!=null && field.getType() == Schema.DisplayType.Boolean){
                                newEntry.put(fs.dmpl__FieldNameId__r.QualifiedApiName, false);
                            }
                        }
                    }
                }
            }
    }

    @namespaceAccessible
    public void DocumentStatusRestrictEdits_Edit(string objectApiName, string statusFieldApiName, List<SObject> oldEntries, List<SObject> newEntries){
        List<dmpl__DomainSetting__mdt> featureSettings = getDomainSetting(FEATURE_Document_Status_Restrict_Edits, objectApiName);
        DomainFeatureSetting fs = new DomainFeatureSetting();
        if(hasBranchDomainSetting(featureSettings, fs) 
            || hasPartnerDomainSetting(featureSettings, fs) 
            || hasGlobalDomainSetting(featureSettings, fs)){
                Map<Id, SObject> oldObjectsMap = new Map<Id, SObject>(oldEntries);
                for(SObject newEntry : newEntries){
                    SObject oldEntry = oldObjectsMap.get(newEntry.Id);
                    if(fs.FeatureSetting.dmpl__Status__c!=null && fs.FeatureSetting.dmpl__Status__c.contains((String)oldEntry.get(statusFieldApiName))){
                        newEntry.addError(String.format(
                            String.valueOf(System.Label.DomainValidation_StatusNotEditable), 
                            new String[]{(String)newEntry.get(statusFieldApiName)})); 
                    }
                }
            }
    }

    @namespaceAccessible
    public void DocumentStatusRestrictEdits_Delete(string objectApiName, string statusFieldApiName, List<SObject> oldEntries){
        List<dmpl__DomainSetting__mdt> featureSettings = getDomainSetting(FEATURE_Document_Status_Restrict_Edits, objectApiName);
        DomainFeatureSetting fs = new DomainFeatureSetting();
        if(hasBranchDomainSetting(featureSettings, fs) 
            || hasPartnerDomainSetting(featureSettings, fs) 
            || hasGlobalDomainSetting(featureSettings, fs)){
                for(SObject oldEntry : oldEntries){
                    if(fs.FeatureSetting.dmpl__Status__c!=null && fs.FeatureSetting.dmpl__Status__c.contains((String)oldEntry.get(statusFieldApiName))){
                        oldEntry.addError(String.format(
                            String.valueOf(System.Label.DomainValidation_StatusNotEditable), 
                            new String[]{(String)oldEntry.get(statusFieldApiName)})); 
                    }
                }
            }
    }

    @namespaceAccessible
    public void DocumentStatusRelatedObjectRestrictEdits_New(string objectApiName,string relatedObjectApiName, string statusFieldApiName, List<SObject> newEntries){
        List<dmpl__DomainSetting__mdt> featureSettings = getDomainSetting(FEATURE_Document_Status_Related_Object_Edit, objectApiName, relatedObjectApiName);
        DomainFeatureSetting fs = new DomainFeatureSetting();
        if(hasBranchDomainSetting(featureSettings, fs) 
            || hasPartnerDomainSetting(featureSettings, fs) 
            || hasGlobalDomainSetting(featureSettings, fs)){
                for(SObject newEntry : newEntries){
                    if(fs.FeatureSetting.dmpl__Status__c!=null && fs.FeatureSetting.dmpl__Status__c.contains((String)newEntry.get(statusFieldApiName))){
                        newEntry.addError(String.format(
                            String.valueOf(System.Label.DomainValidation_StatusNotEditable), 
                            new String[]{(String)newEntry.get(statusFieldApiName)})); 
                    }
                }
            }
    }

    @namespaceAccessible
    public void DocumentStatusRelatedObjectRestrictEdits_Edit(string objectApiName,string relatedObjectApiName, string statusFieldApiName, List<SObject> oldEntries, List<SObject> newEntries){
        List<dmpl__DomainSetting__mdt> featureSettings = getDomainSetting(FEATURE_Document_Status_Related_Object_Edit, objectApiName, relatedObjectApiName);
        DomainFeatureSetting fs = new DomainFeatureSetting();
        if(hasBranchDomainSetting(featureSettings, fs) 
            || hasPartnerDomainSetting(featureSettings, fs) 
            || hasGlobalDomainSetting(featureSettings, fs)){
                Map<Id, SObject> oldObjectsMap = new Map<Id, SObject>(oldEntries);
                for(SObject newEntry : newEntries){
                    SObject oldEntry = oldObjectsMap.get(newEntry.Id);
                    if(fs.FeatureSetting.dmpl__Status__c!=null && fs.FeatureSetting.dmpl__Status__c.contains((String)oldEntry.get(statusFieldApiName))){
                        newEntry.addError(String.format(
                            String.valueOf(System.Label.DomainValidation_StatusNotEditable), 
                            new String[]{(String)newEntry.get(statusFieldApiName)})); 
                    }
                }
            }
    }

    @namespaceAccessible
    public void DocumentStatusRelatedObjectRestrictEdits_Delete(string objectApiName,string relatedObjectApiName, string statusFieldApiName, List<SObject> oldEntries){
        List<dmpl__DomainSetting__mdt> featureSettings = getDomainSetting(FEATURE_Document_Status_Related_Object_Edit, objectApiName, relatedObjectApiName);
        DomainFeatureSetting fs = new DomainFeatureSetting();
        if(hasBranchDomainSetting(featureSettings, fs) 
            || hasPartnerDomainSetting(featureSettings, fs) 
            || hasGlobalDomainSetting(featureSettings, fs)){
                for(SObject oldEntry : oldEntries){
                    if(fs.FeatureSetting.dmpl__Status__c!=null && fs.FeatureSetting.dmpl__Status__c.contains((String)oldEntry.get(statusFieldApiName))){
                        oldEntry.addError(String.format(
                            String.valueOf(System.Label.DomainValidation_StatusNotEditable), 
                            new String[]{(String)oldEntry.get(statusFieldApiName)})); 
                    }
                }
            }
    }

    @namespaceAccessible
    public void DocumentStatusRestrictFieldsEdits(string objectApiName, string statusFieldApiName, List<SObject> oldEntries, List<SObject> newEntries){
        List<dmpl__DomainSetting__mdt> featureSettings = getDomainSetting(FEATURE_Document_Status_Restrict_Edits_Field_List, objectApiName);
        List<dmpl__DomainSetting__mdt> fieldList = new List<dmpl__DomainSetting__mdt>();
        DomainFeatureSetting fs = new DomainFeatureSetting();
        if(hasBranchDomainSetting(featureSettings, fieldList) 
            || hasPartnerDomainSetting(featureSettings, fieldList) 
            || hasGlobalDomainSetting(featureSettings, fieldList)){
                Schema.DescribeSObjectResult sObjectInfo = Schema.getGlobalDescribe().get(objectApiName).getDescribe();   
                Map<String, Schema.SObjectField> sObjectFields = sObjectInfo.fields.getMap();
                Map<Id, SObject> oldObjectsMap = new Map<Id, SObject>(oldEntries);
                for(SObject newEntry : newEntries){
                    SObject oldEntry = oldObjectsMap.get(newEntry.Id);
                    for(String fieldName : sObjectFields.keySet()){
                        for(dmpl__DomainSetting__mdt dsf : fieldList){
                            if(dsf.dmpl__Status__c !=null 
                                && dsf.dmpl__Status__c.contains((String)oldEntry.get(statusFieldApiName))
                                && dsf.dmpl__FieldNameId__r !=null 
                                && dsf.dmpl__FieldNameId__r.QualifiedApiName == fieldName 
                                && oldEntry.get(fieldName) != newEntry.get(fieldName)){
                                newEntry.addError(String.format(
                                    String.valueOf(System.Label.DomainValidation_StatusFieldListNotEditable), 
                                    new String[]{fieldName, (String)newEntry.get(statusFieldApiName)}));            
                            }
                        }
                    }
                }
            }
    }

    @namespaceAccessible
    public Boolean DocumentStatusJumpStartAllowd(string objectApiName, string statusFieldApiName){
        List<dmpl__DomainSetting__mdt> featureSettings = getDomainSetting(FEATURE_Document_Status_Allow_Jump_Start, objectApiName);
        DomainFeatureSetting fs = new DomainFeatureSetting();
        return (hasBranchDomainSetting(featureSettings, fs) 
            || hasPartnerDomainSetting(featureSettings, fs) 
            || hasGlobalDomainSetting(featureSettings, fs));
    }

    @namespaceAccessible
    public Boolean DocumentStatusJumpsAllowd(string objectApiName, string statusFieldApiName){
        List<dmpl__DomainSetting__mdt> featureSettings = getDomainSetting(FEATURE_Document_Status_Allow_Jumps, objectApiName);
        DomainFeatureSetting fs = new DomainFeatureSetting();
        return (hasBranchDomainSetting(featureSettings, fs) 
            || hasPartnerDomainSetting(featureSettings, fs) 
            || hasGlobalDomainSetting(featureSettings, fs));
    }
}