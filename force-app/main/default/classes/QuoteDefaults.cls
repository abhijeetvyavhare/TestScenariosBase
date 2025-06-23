@isTest
public class QuoteDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__ServiceType__c'=>'Paid Repairs',
            'dmpl__ShippingAddress__c'=>'TDI Sector 117',
            'dmpl__ShippingCountry__c'=>'India',
            'dmpl__ShippingPostalCode__c'=>'160055',
            'dmpl__ShippingState__c'=>'Punjab',
            'dmpl__ShippingStreet__c'=>'Victoria Lane1',
            'dmpl__Status__c'=>'Draft',
            'dmpl__TaxSupplyType__c'=>'Within State',
            'dmpl__TCSEligibleAmount__c'=>999,
            'dmpl__UsageReading__c'=>999,
            'dmpl__UsageReadingHours__c'=>10
    };
    }
}