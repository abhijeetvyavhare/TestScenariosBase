// FilterController.cls
public with sharing class FilterController {
    
    @AuraEnabled(cacheable=false)
    public static List<SObject> getFilteredRecords(String filterCriteria) {
        try {
            // Parse the filter criteria
            Map<String, Object> criteria = (Map<String, Object>) JSON.deserializeUntyped(filterCriteria);
            
            String sObjectApiName = (String) criteria.get('sObjectApiName');
            String fieldApiName = (String) criteria.get('fieldApiName');
            String operator = (String) criteria.get('operator');
            String value = (String) criteria.get('value');
            
            // Validate inputs
            if (String.isBlank(sObjectApiName) || String.isBlank(fieldApiName) || String.isBlank(operator)) {
                throw new AuraHandledException('Missing required filter criteria');
            }
            
            // Build the SOQL query
            String soqlQuery = buildSOQLQuery(sObjectApiName, fieldApiName, operator, value);
            
            // Execute the query
            List<SObject> results = Database.query(soqlQuery);
            
            return results;
            
        } catch (Exception e) {
            System.debug('Error in getFilteredRecords: ' + e.getMessage());
            throw new AuraHandledException('Error executing filter: ' + e.getMessage());
        }
    }
    
    private static String buildSOQLQuery(String sObjectApiName, String fieldApiName, String operator, String value) {
        // Get object describe to build proper field list
        Schema.SObjectType sObjectType = Schema.getGlobalDescribe().get(sObjectApiName);
        Schema.DescribeSObjectResult sObjectDescribe = sObjectType.getDescribe();
        
        // Build field list (limit to first 10 fields for performance)
        List<String> fieldList = new List<String>();
        Integer fieldCount = 0;
        
        for (Schema.SObjectField field : sObjectDescribe.fields.getMap().values()) {
            if (fieldCount >= 10) break;
            
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
            if (fieldDescribe.isAccessible()) {
                fieldList.add(fieldDescribe.getName());
                fieldCount++;
            }
        }
        
        // Always include Id and Name if available
        if (!fieldList.contains('Id')) {
            fieldList.add(0, 'Id');
        }
        if (sObjectDescribe.fields.getMap().containsKey('Name') && !fieldList.contains('Name')) {
            fieldList.add(1, 'Name');
        }
        
        // Build WHERE clause
        String whereClause = buildWhereClause(fieldApiName, operator, value, sObjectDescribe);
        
        // Construct the full query
        String soqlQuery = 'SELECT ' + String.join(fieldList, ', ') + 
                          ' FROM ' + sObjectApiName + 
                          ' WHERE ' + whereClause + 
                          ' LIMIT 200';
        
        System.debug('Generated SOQL: ' + soqlQuery);
        return soqlQuery;
    }
    
    private static String buildWhereClause(String fieldApiName, String operator, String value, Schema.DescribeSObjectResult sObjectDescribe) {
        // Get field type for proper formatting
        Schema.SObjectField field = sObjectDescribe.fields.getMap().get(fieldApiName);
        Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
        Schema.DisplayType fieldType = fieldDescribe.getType();
        
        String whereClause = '';
        
        switch on operator {
            when '=' {
                whereClause = fieldApiName + ' = ' + formatValue(value, fieldType);
            }
            when '!=' {
                whereClause = fieldApiName + ' != ' + formatValue(value, fieldType);
            }
            when 'LIKE' {
                whereClause = fieldApiName + ' LIKE \'%' + String.escapeSingleQuotes(value) + '%\'';
            }
            when 'NOT LIKE' {
                whereClause = 'NOT ' + fieldApiName + ' LIKE \'%' + String.escapeSingleQuotes(value) + '%\'';
            }
            when '>' {
                whereClause = fieldApiName + ' > ' + formatValue(value, fieldType);
            }
            when '>=' {
                whereClause = fieldApiName + ' >= ' + formatValue(value, fieldType);
            }
            when '<' {
                whereClause = fieldApiName + ' < ' + formatValue(value, fieldType);
            }
            when '<=' {
                whereClause = fieldApiName + ' <= ' + formatValue(value, fieldType);
            }
            when 'STARTS_WITH' {
                whereClause = fieldApiName + ' LIKE \'' + String.escapeSingleQuotes(value) + '%\'';
            }
            when 'ENDS_WITH' {
                whereClause = fieldApiName + ' LIKE \'%' + String.escapeSingleQuotes(value) + '\'';
            }
            when 'IS NULL' {
                whereClause = fieldApiName + ' = NULL';
            }
            when 'IS NOT NULL' {
                whereClause = fieldApiName + ' != NULL';
            }
            when else {
                throw new AuraHandledException('Unsupported operator: ' + operator);
            }
        }
        
        return whereClause;
    }
    
    private static String formatValue(String value, Schema.DisplayType fieldType) {
        if (String.isBlank(value)) {
            return 'NULL';
        }
        
        switch on fieldType {
            when STRING, TEXTAREA, PICKLIST, MULTIPICKLIST, EMAIL, PHONE, URL, ID, REFERENCE {
                return '\'' + String.escapeSingleQuotes(value) + '\'';
            }
            when INTEGER, LONG, DOUBLE, CURRENCY, PERCENT {
                return value;
            }
            when BOOLEAN {
                return value.toLowerCase();
            }
            when DATE {
                try {
                    Date.valueOf(value);
                    return value;
                } catch (Exception e) {
                    throw new AuraHandledException('Invalid date format. Please use YYYY-MM-DD format.');
                }
            }
            when DATETIME {
                try {
                    // Try to parse as datetime
                    return value;
                } catch (Exception e) {
                    throw new AuraHandledException('Invalid datetime format. Please use YYYY-MM-DD HH:MM:SS format.');
                }
            }
            when else {
                return '\'' + String.escapeSingleQuotes(value) + '\'';
            }
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getSObjectFields(String sObjectApiName) {
        try {
            List<Map<String, String>> fieldOptions = new List<Map<String, String>>();
            
            Schema.SObjectType sObjectType = Schema.getGlobalDescribe().get(sObjectApiName);
            Schema.DescribeSObjectResult sObjectDescribe = sObjectType.getDescribe();
            
            for (Schema.SObjectField field : sObjectDescribe.fields.getMap().values()) {
                Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
                
                if (fieldDescribe.isAccessible()) {
                    Map<String, String> fieldOption = new Map<String, String>();
                    fieldOption.put('label', fieldDescribe.getLabel());
                    fieldOption.put('value', fieldDescribe.getName());
                    fieldOption.put('dataType', fieldDescribe.getType().name());
                    fieldOptions.add(fieldOption);
                }
            }
            
            return fieldOptions;
            
        } catch (Exception e) {
            throw new AuraHandledException('Error getting fields: ' + e.getMessage());
        }
    }
}