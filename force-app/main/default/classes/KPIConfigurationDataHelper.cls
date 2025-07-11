public with sharing class KPIConfigurationDataHelper {
    public static dmpl__KPIConfiguration__c createKPIConfiguration(
        String name,
        String memberType,
        String dateFieldName
    ) {
        return (dmpl__KPIConfiguration__c) TestFactory.createSObject(
            new dmpl__KPIConfiguration__c(
                Name = name,
                dmpl__MemberType__c = memberType,
                dmpl__DateFieldName__c = dateFieldName,
                dmpl__IsActive__c = true
            ),
            'KPIConfigurationDefaults',
            true
        );
    }

    public static dmpl__KPIConfiguration__c createKPIConfiguration(
        String kpiName,
        String memberType,
        String dateFieldName,
        boolean isActive
    ) {
        return (dmpl__KPIConfiguration__c) TestFactory.createSObject(
            new dmpl__KPIConfiguration__c(
                Name = kpiName != null ? kpiName : null,
                dmpl__MemberType__c = memberType != null ? memberType : null,
                dmpl__DateFieldName__c = dateFieldName != null ? dateFieldName : null,
                dmpl__IsActive__c = isActive != null ? isActive : null
            ),
            // 'KPIConfigurationDefaults',
            true
        );
    }

    public static dmpl__KPIConfiguration__c getKPIConfiguration() {
        return [
            SELECT Id, Name, dmpl__MemberType__c, dmpl__DateFieldName__c, dmpl__IsActive__c
            FROM dmpl__KPIConfiguration__c
            WHERE Name = 'Test KPI Config'
            LIMIT 1
        ];
    }

    public static dmpl__KPIConfiguration__c getKPIConfiguration(Id configId) {
        return [
            SELECT Id, Name, dmpl__MemberType__c, dmpl__DateFieldName__c, dmpl__IsActive__c
            FROM dmpl__KPIConfiguration__c
            WHERE Id = :configId
            LIMIT 1
        ];
    }

    public static dmpl__KPIConfiguration__c updateKPIConfiguration(dmpl__KPIConfiguration__c config, String newName) {
        config.Name = newName;
        update config;
        return getKPIConfiguration(config.Id);
    }

    public static Integer deleteKPIConfiguration(dmpl__KPIConfiguration__c config) {
        Id configId = config.Id;
        delete config;
        return [
            SELECT COUNT() FROM dmpl__KPIConfiguration__c WHERE Id = :configId
        ];
    }
}