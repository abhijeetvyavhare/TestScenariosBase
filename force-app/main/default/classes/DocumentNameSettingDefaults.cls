@isTest
public class DocumentNameSettingDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{
            'dmpl__LastNumberUsed__c' => 20,
            'dmpl__ObjectApiName__c' => 'Account',
            'dmpl__DocumentSeries__c' => 'Series A'
        };
    }
    
}