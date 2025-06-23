@isTest
public class VisitRouteService_Test {
 
    @isTest
    static void testSyncDayNumbers() {
        dmpl__VisitRoute__c visitRoute = new dmpl__VisitRoute__c(
            dmpl__MondayAvailable__c = true,
            dmpl__TuesdayAvailable__c = false,
            dmpl__WednesdayAvailable__c = true,
            dmpl__ThursdayAvailable__c = false,
            dmpl__FridayAvailable__c = true,
            dmpl__SaturdayAvailable__c = false,
            dmpl__SundayAvailable__c = true
        );
        insert visitRoute;
 
        List<dmpl__VisitRoute__c> visitRoutes = [
            SELECT Id, dmpl__DayNumbers__c, dmpl__MondayAvailable__c, dmpl__TuesdayAvailable__c, dmpl__WednesdayAvailable__c, 
                   dmpl__ThursdayAvailable__c, dmpl__FridayAvailable__c, dmpl__SaturdayAvailable__c, dmpl__SundayAvailable__c 
            FROM dmpl__VisitRoute__c
        ];
        VisitRouteService.syncDayNumbers(visitRoutes);
 
        dmpl__VisitRoute__c updatedVisitRoute = visitRoutes[0];
       
        updatedVisitRoute.dmpl__DayNumbers__c = '2,4,6';
        update updatedVisitRoute;
 
        visitRoutes = [
            SELECT Id, dmpl__DayNumbers__c, dmpl__MondayAvailable__c, dmpl__TuesdayAvailable__c, dmpl__WednesdayAvailable__c, 
                   dmpl__ThursdayAvailable__c, dmpl__FridayAvailable__c, dmpl__SaturdayAvailable__c, dmpl__SundayAvailable__c 
            FROM dmpl__VisitRoute__c
        ];
        VisitRouteService.syncDayNumbers(visitRoutes);
 
        updatedVisitRoute = visitRoutes[0];
        
    }
 
    @isTest
    static void testSyncUpdateDayNumbers() {
        dmpl__VisitRoute__c oldVisitRoute = new dmpl__VisitRoute__c(
            dmpl__MondayAvailable__c = true,
            dmpl__TuesdayAvailable__c = true,
            dmpl__WednesdayAvailable__c = false,
            dmpl__ThursdayAvailable__c = true,
            dmpl__FridayAvailable__c = false,
            dmpl__SaturdayAvailable__c = true,
            dmpl__SundayAvailable__c = false,
            dmpl__DayNumbers__c = '1,2,4,6'
        );
        insert oldVisitRoute;
 
        dmpl__VisitRoute__c newVisitRoute = new dmpl__VisitRoute__c(
            Id = oldVisitRoute.Id,
            dmpl__MondayAvailable__c = false,
            dmpl__TuesdayAvailable__c = true,
            dmpl__WednesdayAvailable__c = true,
            dmpl__ThursdayAvailable__c = false,
            dmpl__FridayAvailable__c = true,
            dmpl__SaturdayAvailable__c = false,
            dmpl__SundayAvailable__c = true,
            dmpl__DayNumbers__c = '2,3,5,7'
        );
        update newVisitRoute;
 
        List<dmpl__VisitRoute__c> newEntries = [
            SELECT Id, dmpl__DayNumbers__c, dmpl__MondayAvailable__c, dmpl__TuesdayAvailable__c, dmpl__WednesdayAvailable__c, 
                   dmpl__ThursdayAvailable__c, dmpl__FridayAvailable__c, dmpl__SaturdayAvailable__c, dmpl__SundayAvailable__c 
            FROM dmpl__VisitRoute__c
        ];
        List<dmpl__VisitRoute__c> oldEntries = new List<dmpl__VisitRoute__c>{oldVisitRoute};
 
        VisitRouteService.syncUpdateDayNumbers(newEntries, oldEntries);
 
        dmpl__VisitRoute__c updatedVisitRoute = newEntries[0];
       
    }
 
    @isTest
    static void testUpdateDayNumbersPrivateMethods() {
        dmpl__VisitRoute__c visitRoute = new dmpl__VisitRoute__c(
            dmpl__DayNumbers__c = '1,4,7',
            dmpl__MondayAvailable__c = true,
            dmpl__ThursdayAvailable__c = true,
            dmpl__SundayAvailable__c = true
        );
 
        Test.startTest();
        VisitRouteService.updateDayNumbers2(visitRoute);
        Test.stopTest();
 
    }
}