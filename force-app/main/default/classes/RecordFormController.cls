public with sharing class RecordFormController {
    @AuraEnabled(cacheable = true)
    public static dmpl__Resource__c getUserDefaults(){
        try {
            Id userId = UserInfo.getUserId();
            SecurityHelper.ensureCanReadFields(new List<String>{
                'dmpl__DefaultBranchId__c',
                'dmpl__DefaultPartnerAccountId__c',
                'dmpl__Phone__c',
                'dmpl__ResourceType__c'
            },'dmpl__Resource__c');
            List<dmpl__Resource__c> resources = [SELECT 
                    Id,
                    dmpl__DefaultBranchId__c,
                    dmpl__DefaultPartnerAccountId__c,
                    dmpl__Phone__c,
                    dmpl__ResourceType__c
                FROM
                    dmpl__Resource__c
                WHERE 
                    dmpl__UserId__c =:userId
                    AND dmpl__IsActive__c = True
                LIMIT 1
            ];
            if(resources.size()>0){
                return resources[0];
            }else {
                return null;
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    @AuraEnabled(cacheable = true)
    public static dmpl__PostalCode__c getPostalCodeDefaults(String postalCode){
        try {
            String safePostalCode = String.escapeSingleQuotes(postalCode);
            SecurityHelper.ensureCanReadFields(new List<String>{
                'dmpl__City__c',
                'dmpl__CityPlaceId__c',
                'dmpl__Country__c',
                'dmpl__Region__c',
                'dmpl__State__c'
                },'dmpl__PostalCode__c');
            List<dmpl__PostalCode__c> postalCodes = [SELECT 
                    Name,
                    dmpl__City__c,
                    dmpl__CityPlaceId__c,
                    dmpl__Country__c,
                    dmpl__Region__c,
                    dmpl__State__c
                FROM
                    dmpl__PostalCode__c
                WHERE 
                    Name =:safePostalCode
                LIMIT 1
            ];
            if(postalCodes.size()>0){
                return postalCodes[0];
            }
            return null;
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }
    
    @AuraEnabled(cacheable = true)
    public static Asset getAssetDefaults(Id assetId){
        try {
            SecurityHelper.ensureCanReadFields(new List<String>{
                    'Name',
                    'AccountId',
                    'dmpl__ItemId__c',
                    'dmpl__ItemLotId__c',
                    'dmpl__SKUId__c',
                    'dmpl__LastServiceBranchId__c',
                    'dmpl__LastServicePartnerId__c'
            },'Asset');
            List<Asset> assetDefaults = [SELECT 
                Name,
                AccountId,
                dmpl__ItemId__c,
                dmpl__ItemLotId__c,
                dmpl__SKUId__c,
                dmpl__LastServiceBranchId__c,
                dmpl__LastServicePartnerId__c
                FROM
                    Asset
                WHERE 
                    Id =:assetId
                LIMIT 1
            ];
            if(assetDefaults.size()>0){
                return assetDefaults[0];
            }
            return null;
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    @AuraEnabled(cacheable = true)
    public static Account getAccountDefaults(Id accountId){
        try {
            // SecurityHelper.ensureCanReadFields(new List<String>{
            //         'Name',
            //         'dmpl__BillingCity__c',
            //         'dmpl__BillingCityPlaceId__c',
            //         'dmpl__BillingCountry__c',
            //         'dmpl__BillingPostalCode__c',
            //         'dmpl__BillingRegion__c',
            //         'dmpl__BillingState__c',
            //         'dmpl__BillingStreet__c',
            //         'dmpl__ShippingCity__c',
            //         'dmpl__ShippingCityPlaceId__c',
            //         'dmpl__ShippingCountry__c',
            //         'dmpl__ShippingPostalCode__c',
            //         'dmpl__ShippingRegion__c',
            //         'dmpl__ShippingState__c',
            //         'dmpl__ShippingStreet__c'
            // },'Account');
            List<Account> accountDefaults = [SELECT 
                    Name,
                    dmpl__BillingCity__c,
                    dmpl__BillingCityPlaceId__c,
                    dmpl__BillingCountry__c,
                    dmpl__BillingPostalCode__c,
                    dmpl__BillingRegion__c,
                    dmpl__BillingState__c,
                    dmpl__BillingStreet__c,
                    dmpl__ShippingCity__c,
                    dmpl__ShippingCityPlaceId__c,
                    dmpl__ShippingCountry__c,
                    dmpl__ShippingPostalCode__c,
                    dmpl__ShippingRegion__c,
                    dmpl__ShippingState__c,
                    dmpl__ShippingStreet__c,
                    (SELECT 
                        Id,
                        Name,
                        dmpl__ContactId__c,
                        dmpl__AddressType__c,
                        dmpl__City__c,
                        dmpl__CityPlaceId__c,
                        dmpl__Country__c,
                        dmpl__PostalCode__c,
                        dmpl__Region__c,
                        dmpl__State__c,
                        dmpl__Street__c,
                        dmpl__IsDefault__c
                    FROM
                        dmpl__ContactAddress__r),
                    (SELECT 
                        Id,
                        Title,
                        Phone,
                        MobilePhone,
                        Name,
                        Email
                    FROM
                        Contacts)
                FROM
                    Account
                WHERE 
                    Id =:accountId
                LIMIT 1
            ];
            if(accountDefaults.size()>0){
                return accountDefaults[0];
            }
            return null;
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    @AuraEnabled(cacheable = true)
    public static dmpl__ContactAddress__c getAccountAddressDefaults(Id addressId){
        try {
            SecurityHelper.ensureCanReadFields(new List<String>{
                    'dmpl__City__c',
                    'dmpl__CityPlaceId__c',
                    'dmpl__Country__c',
                    'dmpl__PostalCode__c',
                    'dmpl__Region__c',
                    'dmpl__State__c',
                    'dmpl__Street__c'
        },'dmpl__ContactAddress__c');
            List<dmpl__ContactAddress__c> accountDefaults = [SELECT 
                    Name,
                    dmpl__AccountId__c,
                    dmpl__City__c,
                    dmpl__CityPlaceId__c,
                    dmpl__Country__c,
                    dmpl__PostalCode__c,
                    dmpl__Region__c,
                    dmpl__State__c,
                    dmpl__Street__c
                FROM
                    dmpl__ContactAddress__c
                WHERE 
                    Id =:addressId
                LIMIT 1
            ];
            if(accountDefaults.size()>0){
                return accountDefaults[0];
            }
            return null;
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    @AuraEnabled(cacheable = true)
    public static List<dmpl__DMSFieldMapping__mdt> getAllFieldMappings(
        String destinationObjectApiName
    ){
        try {
            return FieldMappingHelper.getAllFieldMappings(
                destinationObjectApiName);
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    @AuraEnabled(cacheable = true)
    public static List<SObject> getFieldMappingsData(
        String sourceObjectApiName,
        String destinationObjectApiName,
        Id objectId
    ){
        try {
            List<dmpl__DMSFieldMapping__mdt> mappings =  FieldMappingHelper.getFieldMappings(
                sourceObjectApiName,
                destinationObjectApiName
            );
            return FieldMappingHelper.queryObjects(
                sourceObjectApiName,
                mappings,
                new List<Id>{ objectId});
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }
}