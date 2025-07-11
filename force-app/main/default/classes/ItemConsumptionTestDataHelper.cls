public class ItemConsumptionTestDataHelper {
    
    public static dmpl__ItemConsumptionRate__c getItemConsumptionRate(String rateName, dmpl__ItemConsumptionSchedule__c schedule) {
        dmpl__ItemConsumptionRate__c rate = new dmpl__ItemConsumptionRate__c();
        rate.Name = rateName;
        rate.dmpl__ItemConsumptionSchedule__c = schedule.Id;
        return rate;
    }

    public static dmpl__ItemConsumptionSchedule__c getItemConsumptionSchedule(String name) {
        dmpl__ItemConsumptionSchedule__c sched = new dmpl__ItemConsumptionSchedule__c();
        sched.Name = name;
        return sched;
    }
}