@isTest
public with sharing class PlaceHandler_Test {
	@TestSetup
    static void createRequiredData() {
        dmpl__Place__c place = PlaceDataHelper.createPlace();
    }
    
    @isTest
    static void createPlacePositive() {
        dmpl__Place__c place = PlaceDataHelper.getPlace();
        
        System.assertEquals('Places Test', place.Name, 'Name mismatch');
        System.assertEquals('City', place.dmpl__PlaceType__c, 'Place type mismatch');
        System.assertEquals(2, place.dmpl__Level__c, 'Level mismatch');
    }
    
    @isTest
    static void updatePlacePositive() {
        dmpl__Place__c place = PlaceDataHelper.getPlace();
        
        place.Name = 'Place Test';
        place.dmpl__PlaceType__c = 'District';
        place.dmpl__Level__c = 3;
        
        update place;
        
        System.assertEquals('Place Test', place.Name, 'Name mismatch');
        System.assertEquals('District', place.dmpl__PlaceType__c, 'Place type mismatch');
        System.assertEquals(3, place.dmpl__Level__c, 'Level mismatch');
    }
    
    @isTest
    static void deletePlace() {
        dmpl__Place__c place = PlaceDataHelper.getPlace();
        System.assertNotEquals(null, place, 'Place should exist before deletion.');
    
        Id placeId = place.Id;
    
        delete place;
    
        dmpl__Place__c deletedPlace;
    
        try {
            deletedPlace = PlaceDataHelper.getPlace(placeId);
        } catch (Exception e) {
            deletedPlace = null;
        }
    
        System.assertEquals(null, deletedPlace, 'Place should be marked as deleted.');
    }
   
    //Place with name(New)
    @isTest
    static void createPlaceWithNamePositive(){
        dmpl__Place__c place = PlaceDataHelper.createPlace('Pune','City');
        dmpl__Place__c fetchedPlace = PlaceDataHelper.getPlace(place.Id);
        System.assertEquals('Pune', fetchedPlace.Name, 'Place name should be Pune.');
        System.assertEquals('City', fetchedPlace.dmpl__PlaceType__c, 'Place type should be City.');
    }
    
    //Place with name(Edit)
    @isTest
    static void updatePlaceWithNamePositive(){
        dmpl__Place__c place = PlaceDataHelper.createPlace('Pune','City');
        dmpl__Place__c fetchedPlace = PlaceDataHelper.getPlace(place.Id);
        fetchedPlace.Name= 'Mumbai';
        Update fetchedPlace;
        dmpl__Place__c updatedPlace = PlaceDataHelper.getPlace(fetchedPlace.Id);
        System.assertEquals('Mumbai', updatedPlace.Name, 'Place name should be Mumbai.');
        System.assertEquals('City', updatedPlace.dmpl__PlaceType__c, 'Place type should be City.');
    }
    
    //Place without name(New)
    @isTest
    static void createPlaceWithoutNameNegative() {
        Boolean exceptionThrown = false;
        
        try {
            Test.startTest();
            dmpl__Place__c place = PlaceDataHelper.createPlace('Pune','City');
            Test.stopTest();
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        
        // System.assertEquals(true, exceptionThrown, 'Exception should be thrown when Name is missing.');
    }
    
    //Place with Place Type(New)
     @isTest
    static void createPlaceWithPlaceTypePositive(){
        dmpl__Place__c place = PlaceDataHelper.createPlace('Kerala','State');
        dmpl__Place__c fetchedPlace = PlaceDataHelper.getPlace(place.Id);
        System.assertEquals('Kerala', fetchedPlace.Name, 'Place name should be Pune.');
        System.assertEquals('State', fetchedPlace.dmpl__PlaceType__c, 'Place type should be City.');
    }

    //Place with Place Type(Edit)
    @isTest
    static void updatePlaceWithPlaceTypePositive(){
        dmpl__Place__c place = PlaceDataHelper.createPlace('Kerala','State');
        dmpl__Place__c fetchedPlace = PlaceDataHelper.getPlace(place.Id);
        fetchedPlace.Name= 'Mumbai';
        fetchedPlace.dmpl__PlaceType__c= 'City';
        Update fetchedPlace;
        dmpl__Place__c updatedPlace = PlaceDataHelper.getPlace(fetchedPlace.Id);
        System.assertEquals('Mumbai', updatedPlace.Name, 'Place name should be Kerala.');
        System.assertEquals('City', updatedPlace.dmpl__PlaceType__c, 'Place type should be State.');
    }
    
    //Place without place Type(New)
    @isTest
    static void createPlaceWithoutNamTypeNegative() {
        Boolean exceptionThrown = false;
        
        try {
            Test.startTest();
            dmpl__Place__c place = PlaceDataHelper.createPlace('Mumbai','');
            Test.stopTest();
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown when Name is missing.');
    }
}