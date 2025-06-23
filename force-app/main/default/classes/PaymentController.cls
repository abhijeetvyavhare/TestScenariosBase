public with sharing class PaymentController {    

    //depreciated
    @AuraEnabled(cacheable = false)
    public static List<dmpl__SaleInvoice__c> getDocument(string accountId, string branchId, string customerId)
    {
        try
        {
            if(accountId == null || branchId == null || customerId == null)
                return new List<dmpl__SaleInvoice__c>();
            string query = 'SELECT Id,             Name,            dmpl__DocumentDate__c,            dmpl__OutstandingAmount__c,            dmpl__TotalAmount__c,          dmpl__AmountPaid__c            FROM dmpl__SaleInvoice__c ';
            string whereClause = 'WHERE (dmpl__OutstandingAmount__c = null OR dmpl__OutstandingAmount__c > 0) ';
            if(accountId != null)
                whereClause = whereClause + ' AND dmpl__PartnerAccountId__c = \''+accountId+'\'';
            if(branchId != null)
                whereClause = whereClause + ' AND dmpl__BranchId__c = \''+branchId+'\'';
            if(customerId != null)
                whereClause = whereClause + ' AND dmpl__AccountId__c = \''+customerId+'\'';
            
            System.debug(query + whereClause );
            System.debug(Database.query(query + whereClause));
            return Database.query(query + whereClause);
        }
        catch(Exception e)
        {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    //depreciated
    @AuraEnabled(cacheable = true)
    public static List<sObject>  getEmail(string accountId)
    {
        try
        {
            List<sObject>  records = Database.query('SELECT Id, Email,AccountId FROM Contact WHERE AccountId=\'' + accountId + '\' ');
        	return records;
        }
        catch(Exception e)
        {
            throw new AuraHandledException(e.getMessage());
        }
    }
}