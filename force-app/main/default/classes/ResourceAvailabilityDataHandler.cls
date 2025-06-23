public class ResourceAvailabilityDataHandler extends TriggerHandler {
    
    private List<dmpl__ResourceAvailabilityData__c> triggerNew;
    private List<dmpl__ResourceAvailabilityData__c> triggerOld;
    private Map<Id, dmpl__ResourceAvailabilityData__c> triggerMapNew;
    private Map<Id, dmpl__ResourceAvailabilityData__c> triggerMapOld;
    
	public ResourceAvailabilityDataHandler() {
        this.triggerOld = (List<dmpl__ResourceAvailabilityData__c>) Trigger.old;
        this.triggerNew = (List<dmpl__ResourceAvailabilityData__c>) Trigger.new;
        this.triggerMapNew = (Map<Id, dmpl__ResourceAvailabilityData__c>) Trigger.newMap;
        this.triggerMapOld = (Map<Id, dmpl__ResourceAvailabilityData__c>) Trigger.oldMap;
    }
    
    public override void beforeInsert(){
        List<dmpl__ResourceAvailabilityData__c> filterObjects = DocumentHelper.getObjectsWithNull(
        	triggerNew,
            'dmpl__ResourceAvailabilityId__c'
        );
        if(filterObjects.size() > 0){
			ResourceAvailabilityDataService.processResourceAvailabilityData(
        		filterObjects);
        }
    }
    public override void afterInsert(){
        ResourceAvailabilityDataService.calculatePenaltyHours(
            triggerNew);
    }
}