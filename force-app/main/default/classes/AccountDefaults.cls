@isTest
public with sharing class AccountDefaults implements TestFactory.FieldDefaults{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'Name' => 'Customer1',
            'Type' => 'Technology Partner',
            'Website' => 'http://www.salewsforce.com',
            'Phone' => '1-800-NO-SOFTWARE',
            'dmpl__Status__c' => 'Created',
            'dmpl__ShippingStreet__c' => 'Salesforce Tower, 415 Mission Street, 3rd Floor',
            'dmpl__ShippingState__c' => 'None',
            'dmpl__ShippingRegion__c'	=> 'San Francisco',
            'dmpl__ShippingPostalCode__c'	=> '94105',
            'dmpl__ShippingCountry__c' => 'None',
            'dmpl__ShippingCity__c' => 'None',
            'dmpl__Salutation__c' => 'Mr.',
            'dmpl__LastName__c' => ' Benioff',
			'dmpl__FirstName__c' => 'Marc Russell',
            'dmpl__IsSupplierAccount__c' => false,
            'dmpl__IsPartnerAccount__c' => false,
            'dmpl__IsCustomerAccount__c' => true,
            'dmpl__IsActive__c' => true,
            'dmpl__Email__c' => 'info@salesforce.com',
            'dmpl__CustomerSchemeAccountGroupId__c' => null,
            'dmpl__CustomerPriceAccountGroupId__c' => null,
            'dmpl__CustomerDiscountAccountGroupId__c' => null,
            'dmpl__PartnerTaxAccountGroupId__c' => null,
            'dmpl__PartnerSchemeAccountGroupId__c' => null,
            'dmpl__PartnerPriceAccountGroupId__c' => null,
            'dmpl__PartnerOwnerAccountId__c' => null,
            'dmpl__PartnerItemComponentAccountGroupId__c' => null,
            'dmpl__PartnerDiscountAccountGroupId__c' => null,
            'dmpl__BillingStreet__c' => 'Salesforce Tower, 415 Mission Street, 3rd Floor',
            'dmpl__BillingState__c' => 'None',
            'dmpl__BillingRegion__c' => 'San Francisco',
            'dmpl__BillingPostalCode__c' => '94105',
            'dmpl__BillingCountry__c' => 'None',
            'dmpl__BillingCity__c' => 'None',
            'dmpl__AccountSource__c' => 'Direct'
        };
    }
}