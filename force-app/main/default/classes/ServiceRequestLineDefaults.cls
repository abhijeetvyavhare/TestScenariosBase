@isTest
public with sharing class ServiceRequestLineDefaults  implements TestFactory.FieldDefaults{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__ApplyPostTaxDiscount__c'=>true,
            'dmpl__Discount2__c'=>10,
            'dmpl__DiscountAmount2__c'=>2000,
            'dmpl__ContractDiscount__c'=>10,
            'dmpl__ContractDiscountAmount__c'=>200,
            'dmpl__DurationInHours__c'=>1,
            'dmpl__IsCancelled__c'=>true,
            'dmpl__IsConfirmed__c'=>true,
            'dmpl__IsPackageComponent__c'=>true,
            'dmpl__IsPackageService__c'=>true,
            'dmpl__IsPriceBundled__c'=>true,
            'dmpl__IsServiceCampaignMandatory__c'=>true,
            'dmpl__PackageClassification__c'=>'Optional Item',
            'dmpl__Quantity__c'=>100,
            'dmpl__ServiceContractWeightage2__c'=>10,
            'dmpl__ServiceContractWeightage3__c'=>10,
            'dmpl__TaxAmount__c'=>100,
            'dmpl__UnitPrice2__c'=>100,
            'dmpl__UnitPrice__c'=>100
        };
    }
}