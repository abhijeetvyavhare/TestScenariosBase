@isTest
public class PlaceDataHelper {
    public static dmpl__Place__c createPlace() {
        return (dmpl__Place__c) TestFactory.createSObject(
        	new dmpl__Place__c(),
            'PlaceDefaults',
            true
        );
        }
        public static dmpl__Place__c createPlace(String name, String placeType) {
            return (dmpl__Place__c) TestFactory.createSObject(
                new dmpl__Place__c(
                    Name = name,
                    dmpl__PlaceType__c = placeType
                ),
                true
            );
        }
    
    public static dmpl__Place__c getPlace() {
        return [
            SELECT Id, Name, dmpl__PlaceType__c, dmpl__Level__c
            FROM dmpl__Place__c
            LIMIT 1
        ];
    }
    
    public static dmpl__Place__c getPlace(Id id) {
        return [
            SELECT Id, Name, dmpl__PlaceType__c, dmpl__Level__c
            FROM dmpl__Place__c
            WHERE Id = : id
            LIMIT 1
        ];
    }
}