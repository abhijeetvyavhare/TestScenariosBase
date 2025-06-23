@isTest
public class ContactAddressDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__AccountId__c'=>null,
            'dmpl__AddressType__c'=>'Billing Address',
            'dmpl__CityPlaceId__c'=>null,
            'dmpl__City__c'=>'Pune',
            'dmpl__ContactId__c'=>null,
            'dmpl__Country__c'=>'India',
            'dmpl__IsDefault__c'=>true,
            'Name'=>'ContactAddress1',
            'dmpl__PostalCode__c'=>'91',
            'dmpl__Region__c'=>'none',
            'dmpl__State__c'=>'Punjab',
            'dmpl__Street__c'=>'none'
        };
    }
}