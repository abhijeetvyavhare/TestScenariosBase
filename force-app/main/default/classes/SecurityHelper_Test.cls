@isTest
public with sharing class SecurityHelper_Test {
    
    @isTest
    static void verifyEnsureFunctions()
    {
        try {
            SecurityHelper.ensureCanReadField('dmpl__PartnerAccountId__c', 'dmpl__SaleOrder__c');
        } catch (Exception error) {
            
        }
        
        try {
            SecurityHelper.ensureCanCreateField('dmpl__PartnerAccountId__c', 'dmpl__SaleOrder__c');
        } catch (Exception error) {
            
        }

        try {
            SecurityHelper.ensureCanWriteField('Id', 'dmpl__SaleOrder__c');
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
        }

        try {
            SecurityHelper.ensureCanReadFields(new List<String>{'dmpl__PartnerAccountId__c', 'dmpl__BranchId__c'}, 'dmpl__SaleOrder__c');
        } catch (Exception error) {
            
        }

        try {
            SecurityHelper.ensureCanWriteFields(new List<String>{'dmpl__PartnerAccountId__c', 'dmpl__BranchId__c', 'Id'}, 'dmpl__SaleOrder__c');
        } catch (Exception error) {
            
        }
        
        try {
            SecurityHelper.ensureCanReadObject('dmpl__SaleOrder__c');
        } catch (Exception error) {
            
        }

        try {
            SecurityHelper.ensureCanWriteObject('dmpl__SaleOrder__c');
        } catch (Exception error) {
            
        }

        try {
            SecurityHelper.ensureCanCreateObject('dmpl__SaleOrder__c');
        } catch (Exception error) {
            
        }

        try {
            SecurityHelper.ensureCanCreateObject('User');
        } catch (Exception error) {
            
        }

        try {
            SecurityHelper.ensureCanDeleteObject('dmpl__SaleOrder__c');
        } catch (Exception error) {
            
        }
        
        try {
            SecurityHelper.ensureCanDeleteObject('User');
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
        }
        
        boolean canCreate = SecurityHelper.canCreateObject('dmpl__SaleOrder__c');
        System.assertEquals(true, canCreate);
    }
}