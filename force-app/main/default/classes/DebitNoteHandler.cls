public with sharing class DebitNoteHandler  extends TriggerHandler {
    
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{
        'dmpl__IsGLPosted__c',
        'dmpl__GeneralLedgerId__c'
    };
    private static final List<String> LIST_FIELDS_LOCKIFTRANSACTED = new List<String>{};

    private List<dmpl__DebitNote__c> triggerNew;
    private List<dmpl__DebitNote__c> triggerOld;
    private Map<Id, dmpl__DebitNote__c> triggerMapNew;
    private Map<Id, dmpl__DebitNote__c> triggerMapOld;

    public DebitNoteHandler() {
        this.triggerOld = (List<dmpl__DebitNote__c>) Trigger.old;
        this.triggerNew = (List<dmpl__DebitNote__c>) Trigger.new;
        this.triggerMapNew = (Map<Id, dmpl__DebitNote__c>) Trigger.newMap;
        this.triggerMapOld = (Map<Id, dmpl__DebitNote__c>) Trigger.oldMap;
    }

    public override void beforeInsert(){
        if(!IsValidationSkipped()){
            DocumentHelper.validateChangeInSystemFields(
                LIST_FIELDS_SYSTEM, triggerNew);
        }
        postGL(true,false,false);
    }

    public override void beforeupdate(){
        if(!IsValidationSkipped()){
            DocumentHelper.validateChangeInSystemFields(
                LIST_FIELDS_SYSTEM, triggerOld, triggerNew);
        }
        postGL(false,false,true);
    }

    public override void beforeDelete(){
        postGL(false,true,false);
    }

    private void postGL(
        Boolean isInsert,
        Boolean isDelete,
        Boolean isUpdate){
        List<dmpl__DebitNote__c> modifiedObjects = DocumentHelper.getPostedObjects(
            'dmpl__IsGLPostingApproved__c', 
            triggerOld, 
            triggerNew);
        if(modifiedObjects.Size() > 0){
            GeneralLedgerHelper.createLedger(
                GeneralLedgerTypeEnums.DebitNote, 
                isInsert, 
                isDelete, 
                isUpdate, 
                triggerOld, 
                modifiedObjects);
        }
    }
}