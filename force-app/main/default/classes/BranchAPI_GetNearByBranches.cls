@RestResource(urlMapping='/Branch/GetNearbyBranches/*')
global with sharing class BranchAPI_GetNearByBranches 
{
    private static final string FIELD_POSTALCODE = 'postalCode';
    private static final string FIELD_CITYNAME = 'cityName';
    private static final string FIELD_RADIUS = 'radius';

    @HttpGet
    global static List<dmpl__Branch__c> getNearbyBranches()
    {
        try 
        {
            RestRequest req = RestContext.request;
            String postalCode = req.params.containsKey(FIELD_POSTALCODE) ? String.valueOf(req.params.get(FIELD_POSTALCODE)) : '';
            String cityName = req.params.containsKey(FIELD_CITYNAME) ? String.valueOf(req.params.get(FIELD_CITYNAME)) : '';
            Integer radius = req.params.containsKey(FIELD_RADIUS) ? Integer.valueOf(req.params.get(FIELD_RADIUS)) : 0;
            return BranchHelper.getNearbyBranches(postalCode, cityName, radius);
        } 
        catch (Exception error) 
        {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }
}