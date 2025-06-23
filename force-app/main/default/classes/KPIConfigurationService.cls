public with sharing class KPIConfigurationService extends MetadataService{

    public static final String OBJECT_KPICONFIG = 'dmpl__KPIConfiguration__c';

    public static final String FIELD_KPICONFIG_ISACTIVE = 'dmpl__IsActive__C';
    
    public static final String FIELD_KPICONFIG_TRIGGEREVENT = 'dmpl__TriggerEvent__c';
    public static final String FIELD_KPICONFIG_TRIGGEREVENT_SCHEDULED = 'Scheduled';
    public static final String FIELD_KPICONFIG_PROVIDERTYPE_AFTERINSERT = '';
    public static final String FIELD_KPICONFIG_PROVIDERTYPE_IP = 'Interface Provider';
    public static final String FIELD_KPICONFIG_PROVIDERTYPE_EMAIL = 'SFDC EMail';
    public static final String FIELD_KPICONFIG_PROVIDERTYPE_NOTIFICATION = 'SFDC Notification';
    public static final String FIELD_KPICONFIG_PROVIDERTYPE_PUSHNOTIFICATION = 'Push Notification';
    
    public KPIConfigurationService(){
        super(OBJECT_KPICONFIG);
    }

    public List<dmpl__KPIData__c> createKPIData(
        dmpl__KPIConfiguration__c config, 
        List<dmpl__IncentiveTarget__c> applicableTargets,
        List<dmpl__IncentivePeriod__c> periods,
        List<SOBject> sObjects){
        List<dmpl__KPIData__c> kpiDatas = queryKPIDatas(
            config, 
            periods,
            sObjects);
        List<dmpl__KPIData__c> updatedData = new List<dmpl__KPIData__c>();
        List<dmpl__KPIDataDetail__c> updatedDataDetails = new List<dmpl__KPIDataDetail__c>();
        if(sObjects ==null || sObjects.size() == 0){
            return updatedData;
        }
        for(SObject aObject : sObjects){
            try {
                Id branchId = (Id)getNestedValue(aObject, config.dmpl__BranchFieldName__c);
                Id resourceId = (Id)getNestedValue(aObject, config.dmpl__ResourceFieldName__c);
                Id partnerAccountId = (Id)getNestedValue(aObject, config.dmpl__PartnerFieldName__c);
                Id accountId = (Id)getNestedValue(aObject, config.dmpl__AccountFieldName__c);
                Date documentDate = (Date)getNestedValue(aObject, config.dmpl__DateFieldName__c);
                Decimal rewardValue = (Decimal) getNestedValue(aObject, config.dmpl__RewardFieldName__c);
                Decimal kpiValue = (Decimal) getNestedValue(aObject, config.dmpl__ValueFieldName__c);
                Decimal kpiValue2 = (Decimal) getNestedValue(aObject, config.dmpl__ValueFieldName2__c);
                rewardValue = rewardValue == null ? 0 : rewardValue;
                kpiValue = kpiValue == null ? 0 : kpiValue;
                if(documentDate == null
                    || (config.dmpl__MemberType__c == 'Resource' 
                        && resourceId == null)
                    || (config.dmpl__MemberType__c == 'Partner'
                        && partnerAccountId == null)
                    || (config.dmpl__MemberType__c == 'Branch' && 
                        branchId == null)
                    || config.dmpl__MemberType__c == 'Account' && 
                        accountId == null){
                    continue;
                }
                List<Id> planIds = CollectionHelper.extractIds(applicableTargets, 'dmpl__IncentivePlanId__c');
                for(Id planId : planIds){
                    for(dmpl__IncentivePeriod__C targetPeriod : periods){
                        if(targetPeriod.dmpl__IncentivePlanId__c != planId){
                            continue;
                        }
                        if(documentDate < targetPeriod.dmpl__DateFrom__c 
                            || documentDate > targetPeriod.dmpl__DateTo__c){
                            continue;
                        }
                        dmpl__KPIData__c data = getObjectsByFilter(
                            config,
                            kpiDatas,
                            targetPeriod.dmpl__IncentivePlanId__c,
                            targetPeriod.Id,
                            resourceId,
                            partnerAccountId,
                            branchId,
                            accountId);
                        if(data == null){
                            data = new dmpl__KPIData__c(
                                dmpl__KPIConfigurationId__c = config.Id,
                                dmpl__IncentivePeriodId__c = targetPeriod.Id,
                                dmpl__IncentivePlanId__c = targetPeriod.dmpl__IncentivePlanId__c,
                                dmpl__RewardValue__c = 0,
                                dmpl__KPIValue__c = 0);
                            if(config.dmpl__MemberType__c == 'Resource'){
                                data.dmpl__ResourceId__c = resourceId;
                            }else if(config.dmpl__MemberType__c == 'Partner'){
                                data.dmpl__PartnerAccountId__c = partnerAccountId;
                            }else if(config.dmpl__MemberType__c == 'Branch'){
                                data.dmpl__BranchId__c = branchId;
                            }else if(config.dmpl__MemberType__c == 'Account'){
                                data.dmpl__AccountId__c = accountId;
                            }   
                        }
                        dmpl__KPIDataDetail__c dataDetail = null;
                        if(data.Id != null){
                            dataDetail = (dmpl__KPIDataDetail__c)CollectionHelper.findObjectByFilter(
                                data.dmpl__KPIDataDetails__r, 
                                'dmpl__SourceRecordId__c',
                                aObject.Id);
                        }
                        if(dataDetail == null){
                            dataDetail = new dmpl__KPIDataDetail__c(
                                dmpl__KPIDataId__c = data.Id,
                                dmpl__SourceRecordId__c = aObject.Id
                            );
                        }

                        dataDetail.dmpl__KPIValue__c = kpiValue;
                        dataDetail.dmpl__KPIValue2__c = kpiValue2;
                        dataDetail.dmpl__RewardValue__c = rewardValue;      
                        updatedData.add(data);
                        updatedDataDetails.add(dataDetail);
                        if(dataDetail.dmpl__KPIDataId__c == null){
                            dataDetail.dmpl__KPIDataId__r = data;
                        }
                    }
                }
                //
                upsert updatedData;
                //
                for (dmpl__KPIDataDetail__c value : updatedDataDetails) {
                    if(value.dmpl__KPIDataId__c == null){
                        value.dmpl__KPIDataId__c = value.dmpl__KPIDataId__r.Id;
                    }
                }
                upsert updatedDataDetails;
            } catch (Exception ex) {
                 ExceptionLogHelper.logException(ex);
            }
        }
        return updatedData;
    }
    
    @TestVisible
    private dmpl__KPIData__c getObjectsByFilter(
        dmpl__KPIConfiguration__c config, 
        List<dmpl__KPIData__c> kpiDatas,
        Id incentivePlanId,
        Id incentivePeriodId,
        Id resourceId,
        Id partnerAccountId,
        Id branchId,
        Id accountId){
            if(config.dmpl__MemberType__c == 'Resource'){
                for(dmpl__KPIData__c data : kpiDatas){
                    if(data.dmpl__IncentivePlanId__c == incentivePlanId
                        && data.dmpl__IncentivePeriodId__c == incentivePeriodId
                        && data.dmpl__ResourceId__c == resourceId){
                        return data;
                    }
                }
            }else if(config.dmpl__MemberType__c == 'Partner'){
                for(dmpl__KPIData__c data : kpiDatas){
                    if(data.dmpl__IncentivePlanId__c == incentivePlanId
                        && data.dmpl__IncentivePeriodId__c == incentivePeriodId
                        && data.dmpl__PartnerAccountId__c == partnerAccountId){
                        return data;
                    }
                }
            }
            else if(config.dmpl__MemberType__c == 'Branch'){
                for(dmpl__KPIData__c data : kpiDatas){
                    if(data.dmpl__IncentivePlanId__c == incentivePlanId
                        && data.dmpl__IncentivePeriodId__c == incentivePeriodId
                        && data.dmpl__BranchId__c == branchId){
                        return data;
                    }
                }
            }
            else if(config.dmpl__MemberType__c == 'Account'){
                for(dmpl__KPIData__c data : kpiDatas){
                    if(data.dmpl__IncentivePlanId__c == incentivePlanId
                        && data.dmpl__IncentivePeriodId__c == incentivePeriodId
                        && data.dmpl__AccountId__c == accountId){
                        return data;
                    }
                }
            }
        return null;
    }

    private object getNestedValue(SObject aObject, String fieldName){
        if(aObject == null || string.isBlank(fieldName)){
            return null;
        }
        try {
            if(!fieldName.contains('.')){
                return aObject.get(fieldName);
            }
            List<String> parts =  fieldName.split('\\.');
            SObject currentObject = aObject;
            for(String part : parts){
                if (part.endsWith('__c')) {
                    return currentObject.get(part);
                }
                currentObject = currentObject.getSObject(part);
                if(currentObject == null){
                    return null;
                }
            }
            return null;
        } catch (Exception ex) {
            return null;   
        }
    }

    public List<dmpl__KPIData__c> queryKPIDatas(
        dmpl__KPIConfiguration__c config,
        List<dmpl__IncentivePeriod__c> periods,
        List<SOBject> sObjects){

        List<String> selectFields = new List<String>{ 
            'Id',
            'dmpl__IncentivePlanId__c',
            'dmpl__IncentivePeriodId__c',
            'dmpl__KPIConfigurationId__c',
            'dmpl__SourceRecordId__c',
            'dmpl__BranchId__c',
            'dmpl__ResourceId__c',
            'dmpl__PartnerAccountId__c',
            'dmpl__AccountId__c',
            'dmpl__RewardValue__c',
            'dmpl__KPIValue__c'
        };
        String childRecordsQuery = ', (SELECT dmpl__KPIDataId__c, dmpl__KPIValue__c, dmpl__RewardValue__c, dmpl__SourceRecordId__c FROM dmpl__KPIDataDetails__r WHERE dmpl__SourceRecordId__c IN :kpiDataIds)';
        List<Id> periodIds = CollectionHelper.extractIds(periods);
        List<Id> kpiDataIds = CollectionHelper.extractIds(sObjects);
        String dbQuery = 'SELECT ' 
            + String.join(selectFields, ',') 
            + childRecordsQuery
            + ' FROM dmpl__KPIData__c WHERE dmpl__KPIConfigurationId__c = \'' 
                + config.Id + '\' AND dmpl__IncentivePeriodId__c IN :periodIds';
        if(config.dmpl__MemberType__c == 'Resource'){
            List<Id> resourceIds = CollectionHelper.extractCompoundIds(sObjects, config.dmpl__ResourceFieldName__c);
            dbQuery += ' AND dmpl__ResourceId__c IN :resourceIds';
        }else if(config.dmpl__MemberType__c == 'Partner'){
            List<Id> partnerIds = CollectionHelper.extractCompoundIds(sObjects, config.dmpl__PartnerFieldName__c);
            dbQuery += ' AND dmpl__PartnerAccountId__c IN :partnerIds';
        }else if(config.dmpl__MemberType__c == 'Branch'){
            List<Id> branchIds = CollectionHelper.extractCompoundIds(sObjects, config.dmpl__BranchFieldName__c);
            dbQuery += ' AND dmpl__BranchId__c IN :branchIds';
        }else if(config.dmpl__MemberType__c == 'Account'){
            List<Id> accountIds = CollectionHelper.extractCompoundIds(sObjects, config.dmpl__AccountFieldName__c);
            dbQuery += ' AND dmpl__AccountId__c IN :accountIds';
        }
        System.debug(' KPI: ' + dbQuery);
        return Database.query(dbQuery);
    }

    public List<dmpl__KPIConfiguration__c> getKPIConfigs(){
        List<dmpl__KPIConfiguration__c> configs = null;
        // if (OrgCacheHelper.isPlatformCacheEnabled()){
        //     configs = (List<dmpl__MessageConfiguration__c>)OrgCacheHelper.getObject(
        //         OrgCacheHelper.generateKey(
        //             OBJECT_KPICONFIG,
        //             'Mcfgs'));
        // }
        if(configs == null){
            configs = [SELECT 
                Id,
                dmpl__AccountFieldName__c,
                dmpl__AccountGroupId__c,
                dmpl__BranchFieldName__c,
                dmpl__IncludeChildResources__c,
                dmpl__FirstNRecords__c,
                dmpl__IncludeLastNRecords__c,
                dmpl__IsActive__c,
                dmpl__IsGroup__c,
                dmpl__ItemFieldName__c,
                dmpl__ItemGroupId__c,
                Name,
                dmpl__JobQueueId__c,
                dmpl__KPIConfigurationId__c,
                dmpl__PartnerFieldName__c,
                dmpl__PartnerAccountGroupId__c,
                dmpl__ResourceFieldName__c,
                dmpl__RewardFieldName__c,
                dmpl__RewardFunction__c,
                dmpl__TriggerEvent__c,
                dmpl__TriggerObjectName__c,
                dmpl__ValueFieldName__c,
                dmpl__ValueFieldName2__c,
                dmpl__ValueFunction__c,
                dmpl__DateFieldName__c,
                dmpl__RuleSuccessCriteria__c,
                dmpl__RuleSuccessCustomLogic__c,
                dmpl__MemberType__c,
                dmpl__LastExecutedSystemModstamp__c,
                (
                    SELECT 
                        dmpl__FieldName__c,
                        dmpl__FieldValue__c,
                        dmpl__Operation__c,
                        dmpl__Sequence_Number__c
                    FROM dmpl__KPI_Rules__r
                    ORDER BY dmpl__Sequence_Number__c
                )
            FROM
                dmpl__KPIConfiguration__c];
            OrgCacheHelper.setObject(
                OrgCacheHelper.generateKey(
                    OBJECT_KPICONFIG,
                        'Mcfgs'),
                    configs);
        }
        return configs;
    }

    public List<dmpl__KPIConfiguration__c> getKPIConfigs(string sObjectApiName){
        if (OrgCacheHelper.isPlatformCacheEnabled()){
            if(!Test.isRunningTest()){
                return queryKPIConfigs(sObjectApiName);
            }
        }
        List<dmpl__KPIConfiguration__c> configs = (List<dmpl__KPIConfiguration__c>)OrgCacheHelper.getObject(
            OrgCacheHelper.generateKey(
                sObjectApiName,
                'Mcfg'));
        if(configs == null){
            configs = queryKPIConfigs(sObjectApiName);
            if(configs!=null){
                OrgCacheHelper.setObject(
                    OrgCacheHelper.generateKey(
                        sObjectApiName,
                        'Mcfg'),
                    configs);
            }
        }
        return configs;
    }

    public List<dmpl__IncentivePeriod__c> getIncentivePeriods(List<Id> planIds){
        return [SELECT 
                Id,
                dmpl__IncentivePlanId__c,
                dmpl__DateTo__c,
                dmpl__DateFrom__c
            FROM dmpl__IncentivePeriod__c
            WHERE dmpl__IncentivePlanId__c IN: planIds
            AND dmpl__SimulationType__c = null];
    }
    
    public List<dmpl__IncentiveTarget__c> getIncentiveTargets(List<Id> kpiIds){
        return [
            SELECT 
                Id,
                dmpl__IncentivePlanId__c,
                dmpl__KPIConfigurationId__c
            FROM dmpl__IncentiveTarget__c 
            WHERE dmpl__KPIConfigurationId__c IN: kpiIds];
    }

    private List<dmpl__KPIConfiguration__c> queryKPIConfigs(string sObjectApiName){
        return [SELECT
                Id,
                dmpl__AccountFieldName__c,
                dmpl__AccountGroupId__c,
                dmpl__BranchFieldName__c,
                dmpl__IncludeChildResources__c,
                dmpl__FirstNRecords__c,
                dmpl__IncludeLastNRecords__c,
                dmpl__IsActive__c,
                dmpl__IsGroup__c,
                dmpl__ItemFieldName__c,
                dmpl__ItemGroupId__c,
                Name,
                dmpl__KPIConfigurationId__c,
                dmpl__PartnerFieldName__c,
                dmpl__PartnerAccountGroupId__c,
                dmpl__ResourceFieldName__c,
                dmpl__RewardFieldName__c,
                dmpl__RewardFunction__c,
                dmpl__TriggerEvent__c,
                dmpl__TriggerObjectName__c,
                dmpl__ValueFieldName__c,
                dmpl__ValueFieldName2__c,
                dmpl__ValueFunction__c,
                dmpl__DateFieldName__c,
                dmpl__RuleSuccessCriteria__c,
                dmpl__RuleSuccessCustomLogic__c,
                dmpl__MemberType__c,
                dmpl__LastExecutedSystemModstamp__c,
                (
                    SELECT 
                        dmpl__FieldName__c,
                        dmpl__FieldValue__c,
                        dmpl__Operation__c,
                        dmpl__Sequence_Number__c
                    FROM dmpl__KPI_Rules__r
                    ORDER BY dmpl__Sequence_Number__c
                )
            FROM
                dmpl__KPIConfiguration__c
            WHERE
                dmpl__TriggerObjectName__c =: sObjectApiName];
    }
}