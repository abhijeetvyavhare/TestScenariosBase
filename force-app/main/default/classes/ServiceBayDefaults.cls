public with sharing class ServiceBayDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{
            'Name'=>'Test - ServiceBay'
        };
    }
}