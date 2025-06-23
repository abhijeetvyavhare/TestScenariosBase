@isTest
public class RepairOrderTimeSheetDefaults implements TestFactory.FieldDefaults {
    
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__WorkEnded__c' => false,
            'dmpl__WorkPaused__c' => false,
            'dmpl__WorkStarted__c' => false
        };
    }
}