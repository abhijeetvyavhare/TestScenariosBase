@isTest
public with sharing class ItemServiceContractDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__ActiveServiceContractRequired__c' => true,
            'dmpl__BillToPartnerAccount__c' => true,
            'dmpl__IsScopeRestricted__c' => false,
            'dmpl__PopulateContractLines__c' => true,
            'dmpl__RestrictAssetContractLinesGeneration__c' => false,
            'dmpl__SingleUseContract__c' => true
        };
    }
}