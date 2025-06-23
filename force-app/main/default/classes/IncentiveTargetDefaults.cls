@isTest
public class IncentiveTargetDefaults implements TestFactory.FieldDefaults{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{
            'dmpl__AccountId__c'=>null, 
            'dmpl__AccountGroupId__c'=>null,
            'dmpl__CustomKPIFieldName__c'=>'none',
            'dmpl__ExternalId__c'=>'none',
            'dmpl__FinancerId__c'=>null,
            'dmpl__FinancerSchemeId__c'=>null,
            'dmpl__IgnoreSplitting__c'=>true,
            'dmpl__IncentiveLineId__c'=>null,
            'dmpl__IncentivePeriodId__c'=>null,
            'dmpl__IncentivePlanId__c'=>null,
            'dmpl__IncentiveResourceId__c'=>null,
            'dmpl__IncentiveTargetType__c'=>'No Of Bookings',
            'dmpl__InsuranceSchemeId__c'=>null,
            'dmpl__InsurerId__c'=>null,
            'dmpl__ItemId__c'=>null,
            'dmpl__ItemGroupId__c'=>null,
            'dmpl__ItemLotTypeId__c'=>null,   
            'dmpl__SequenceNumber__c'=>123,
            'dmpl__ServiceContractId__c'=>null,
            'dmpl__SKUId__c'=>null,
            'dmpl__TargetType__c'=>'No of Leads',
            'dmpl__Value__c'=>100
        };
    }
}