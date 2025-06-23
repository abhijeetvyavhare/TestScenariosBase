@isTest
public class IncentivePlanDefaults implements TestFactory.FieldDefaults{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__AccountGroupId__c'=>null,
            'dmpl__BranchId__c'=>null,
            'dmpl__BusinessHoursId__c'=>null,
            'dmpl__CompensationEligibility__c'=>'AnyOneMax',
            'dmpl__CompensationEligibilityFormula__c'=>'none',
            'dmpl__ExternalId__c'=>'none',
            'dmpl__MemberResourceType__c'=>'Salesperson',
            'dmpl__MemberType__c'=>'Resource',
            'Name'=>'IncentivePlan1',
            'dmpl__PartnerAccountId__c'=>null,
            'dmpl__PartnerAccountGroupId__c'=>null,
            'dmpl__PeriodEndDate__c'=>Date.today().addDays(30),
            'dmpl__PeriodStartDate__c'=>Date.today(),
            'dmpl__PeriodType__c'=>'Yearly',
            'dmpl__ResourceType__c'=>'Sales Person',
            'dmpl__Role__c'=>'Area Sales Manager',
            'dmpl__Status__c'=>'Draft',
            'dmpl__SupplierAccountId__c'=>null,
            'dmpl__ValidFrom__c'=>Date.today(),
            'dmpl__ValidTo__c'=>Date.today().addDays(365)
        };
    }
    
}