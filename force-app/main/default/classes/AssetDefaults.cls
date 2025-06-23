@isTest
public with sharing class AssetDefaults  implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
                    'Name'=>'Asset1',
                    'dmpl__AverageUsage__c'=> 500,
                    'dmpl__AverageUsageHours__c'=>4,
                    'dmpl__BatchNo__c'=>'001',
                    'IsCompetitorProduct'=>false,
                    'dmpl__ComponentNumber__c'=>'0000001',
                    'ConsequenceOfFailure'=>'Minor',
                    'dmpl__CurrentUsageReading__c'=>60.00,
                    'dmpl__CurrentUsageReadingHours__c'=>10,
                    'Description'=>'',
                    'DigitalAssetStatus'=>'Off',
                    'InstallDate'=>null,
                    'IsInternal'=>true,
                    'dmpl__IsPDIDone__c'=>true,
                    'dmpl__LastServiceDate__c'=>null,
                    'dmpl__LastUsageReading__c'=>50.00,
                    'dmpl__LastUsageReadingHours__c'=>10,
                    'dmpl__LotNumber__c'=>'LOT-001',
                    'ManufactureDate'=>null,
                    'Price'=>25000,
                    'dmpl__UsageHoursResetAt__c'=>10,
                    'dmpl__UsageReadingResetAt__c'=>1100
        };
    }
}