public  class VisitRouteHandler extends TriggerHandler {

    private static final List<String> DAY_FIELDS = new List<String>{
        'dmpl__DayNumbers__c',
        'dmpl__MondayAvailable__c',
        'dmpl__TuesdayAvailable__c',
        'dmpl__WednesdayAvailable__c',
        'dmpl__ThursdayAvailable__c',
        'dmpl__FridayAvailable__c',
        'dmpl__SaturdayAvailable__c',
        'dmpl__SundayAvailable__c'    
    };

    private List<dmpl__VisitRoute__c> triggerNew;
    private List<dmpl__VisitRoute__c> triggerOld;
    private Map<Id, dmpl__VisitRoute__c> triggerMapNew;
    private Map<Id, dmpl__VisitRoute__c> triggerMapOld;

    public VisitRouteHandler() {
        this.triggerOld = (List<dmpl__VisitRoute__c>) Trigger.old;
        this.triggerNew = (List<dmpl__VisitRoute__c>) Trigger.new;
        this.triggerMapNew = (Map<Id, dmpl__VisitRoute__c>) Trigger.newMap;
        this.triggerMapOld = (Map<Id, dmpl__VisitRoute__c>) Trigger.oldMap;
    }
    
    public override void beforeInsert(){
        VisitRouteService.syncDayNumbers(triggerNew);
    }
    public override void beforeUpdate(){
        List<dmpl__VisitRoute__c> modifiedObjects=DocumentHelper.getModifiedNewObjects(
            DAY_FIELDS,
            triggerOld,
            triggerNew);
        VisitRouteService.syncUpdateDayNumbers(modifiedObjects,triggerOld);
    }

}