public with sharing class KPIDataHelper {
    public static dmpl__KPIData__c createKPIData(
        dmpl__KPIConfiguration__c kpiConfig,
        Account account,
        dmpl__Branch__c branch,
        Account partnerAccount,
        dmpl__Resource__c resource
    ) {
        return (dmpl__KPIData__c) TestFactory.createSObject(
            new dmpl__KPIData__c(
                Name = 'Test-KPI-Data',
                dmpl__KPIConfigurationId__c = kpiConfig != null ? kpiConfig.Id : null,
                dmpl__AccountId__c = account != null ? account.Id : null,
                dmpl__BranchId__c = branch != null ? branch.Id : null,
                dmpl__PartnerAccountId__c = partnerAccount != null ? partnerAccount.Id : null,
                dmpl__ResourceId__c = resource != null ? resource.Id : null,
                dmpl__KPIValue__c = 100,
                dmpl__RewardValue__c = 50
            ),
            'KPIDataDefaults',
            true
        );
    }
    
    public static dmpl__KPIData__c getKPIData() {
        return [ 
            SELECT 
                Id, 
                Name, 
                dmpl__KPIConfigurationId__c, 
                dmpl__AccountId__c, 
                dmpl__BranchId__c, 
                dmpl__PartnerAccountId__c, 
                dmpl__ResourceId__c, 
                dmpl__KPIValue__c, 
                dmpl__RewardValue__c
            FROM dmpl__KPIData__c
            WHERE Name = 'Test-KPI-Data'
            LIMIT 1
        ];
    }
    
    public static dmpl__KPIData__c getKPIData(Id kpiDataId) {
        return [
            SELECT 
                Id, 
                Name,
                dmpl__KPIConfigurationId__c, 
                dmpl__AccountId__c, 
                dmpl__BranchId__c, 
                dmpl__PartnerAccountId__c, 
                dmpl__ResourceId__c, 
                dmpl__KPIValue__c, 
                dmpl__RewardValue__c
            FROM dmpl__KPIData__c
            WHERE Id = :kpiDataId
            LIMIT 1
        ];
    }
    
    public static dmpl__KPIData__c updateKPIData(dmpl__KPIData__c kpiData, Decimal newKPIValue) {
        kpiData.dmpl__KPIValue__c = newKPIValue;
        update kpiData;
        return getKPIData(kpiData.Id);
    }
    
    public static Integer deleteKPIData(dmpl__KPIData__c kpiData) {
        Id kpiDataId = kpiData.Id;
        delete kpiData;
        Integer count = 0;
        try {
            count = [SELECT COUNT() FROM dmpl__KPIData__c WHERE Id = :kpiDataId];
        } catch (Exception e) {
            count = 0;
        }
        return count;
    }

    public static dmpl__KPIConfiguration__c  createKPIConfiguration(
        String name, 
        String memberType, 
        String dateFieldName
    ) {
        return (dmpl__KPIConfiguration__c) TestFactory.createSObject(
            new dmpl__KPIConfiguration__c(
                Name = name, 
                dmpl__MemberType__c = memberType, 
                dmpl__DateFieldName__c = dateFieldName
            ),
            'KPIConfigurationDefaults',
            true
        );
    }
}