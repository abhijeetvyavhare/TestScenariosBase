/****/
public with sharing class AttendanceManagementController {
    /*@AuraEnabled(cacheable=true)
    public static List<dmpl__Resource__c> getResourceDetails(
        string state,
        string city,
        List<Id> branchId,
        string startDate,
        string endDate
    ) {
        List<dmpl__Resource__c> returnedLines = new List<dmpl__Resource__c>();
        try {
            if ((state == null) && (city == null) && branchId.size() == 0)
                return returnedLines;
            List<String> queryFields = new List<String>();
            queryFields.add('Name');
            queryFields.add('dmpl__DefaultBranchId__r.Name');
            string whereClause = 'WHERE';
            string branch = '';
            if (branchId.size() != 0)
                branch = branchId[0];
            if (branchId.size() != 0) {
                whereClause =
                    whereClause + ' dmpl__DefaultBranchId__c =: branch';
            }
            if (state != null && state != '') {
                if (whereClause != 'WHERE')
                    whereClause += ' AND ';
                whereClause =
                    whereClause +
                    ' dmpl__DefaultBranchId__r.dmpl__AddressId__r.dmpl__State__c =: state';
            }
            if (city != null && city != '') {
                if (whereClause != 'WHERE')
                    whereClause += ' AND ';
                whereClause =
                    whereClause +
                    ' dmpl__DefaultBranchId__r.dmpl__AddressId__r.dmpl__City__c =: city';
            }
            if (whereClause == 'WHERE') {
                whereClause = '';
            }
            String subQuery =
                'SELECT dmpl__AvailabilityType__c,dmpl__Date__c,dmpl__ResourceId__c from dmpl__ResourceAvailabilities__r WHERE dmpl__Date__c >= ' +
                startDate +
                ' AND dmpl__Date__c <= ' +
                endDate;
            String queryFieldsString = String.join(queryFields, ',');
            String query =
                'SELECT Id,' +
                queryFieldsString +
                ',(' +
                subQuery +
                ')' +
                ' FROM ' +
                'dmpl__Resource__c ' +
                whereClause;
            returnedLines = Database.query(query);
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
        return returnedLines;
    }*/

    @AuraEnabled(cacheable=true)
    public static List<dmpl__Resource__c> getResourceDetailsByResource(
        Id resourceId,
        String month,
        String year
    ) {
        List<dmpl__Resource__c> returnedLines = new List<dmpl__Resource__c>();
        try {
            List<String> queryFields = new List<String>();
            queryFields.add('Name');
            string whereClause = 'WHERE Id =: resourceId';
            string resource = resourceId;
            String subQuery =
                'SELECT dmpl__AvailabilityType__c,dmpl__Date__c,dmpl__ResourceId__c from dmpl__ResourceAvailabilities__r WHERE CALENDAR_MONTH(dmpl__Date__c) = ' +
                month +
                ' AND CALENDAR_YEAR(dmpl__Date__c) = ' +
                year;
            String queryFieldsString = String.join(queryFields, ',');
            String query =
                'SELECT Id,' +
                queryFieldsString +
                ',(' +
                subQuery +
                ')' +
                ' FROM ' +
                'dmpl__Resource__c ' +
                whereClause;
            returnedLines = Database.query(query);
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
        return returnedLines;
    }
    
}