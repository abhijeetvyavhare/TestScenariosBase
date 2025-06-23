@isTest
public class QuoteLineDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__ApplyPostTaxDiscount__c'=>true,
            'dmpl__Discount2__c'=>10,
            'dmpl__DiscountAmount2__c'=>1999,
            'dmpl__ContractDiscount__c'=>5,
            'dmpl__ContractDiscountAmount__c'=>499,
            'dmpl__Discount__c'=>8,
            'dmpl__DiscountAmount__c'=>1699,
            'dmpl__DurationInHours__c'=>5,
            'dmpl__IncludeinPackage__c'=>false,
            'dmpl__IsApproved__c'=>true,
            'dmpl__IsDeclined__c'=>false,
            'dmpl__IsPackageService__c'=>false,
            'dmpl__IsPriceBundled__c'=>false,
            'dmpl__PackageClassification__c'=>'Mandatory Item',
            'dmpl__PostingType__c'=>'Post To Expenses',
            'dmpl__PriceAsOnDate__c'=>null,
            'dmpl__Quantity__c'=>1,
            'dmpl__RecommendationType__c'=>'Sample',
            'dmpl__SchemeDiscount__c'=>5,
            'dmpl__SchemeDiscountAmount__c'=>499,
            'dmpl__ServiceContractWeightage2__c'=>6,
            'dmpl__ServiceContractWeightage3__c'=>8,
            'dmpl__TaxAmount__c'=>220,
            'dmpl__UnitPrice2__c'=>750,
            'dmpl__UnitPrice__c'=>700
        };   
    }
}