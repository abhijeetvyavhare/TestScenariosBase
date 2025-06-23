@isTest
public with sharing class KPIDataDetailDataHelper {
    public static dmpl__KPIDataDetail__c createKPIDataDetail(
        dmpl__KPIData__c kpiData,
        String billNo,
        Decimal kpiValue,
        Decimal kpiValue2,
        Decimal rewardValue,
        String saleDoc,
        String sourceRecordId
    ) {
        return (dmpl__KPIDataDetail__c) TestFactory.createSObject(
            new dmpl__KPIDataDetail__c(
                Name = 'Test-KPI-Data-Detail',
                dmpl__KPIDataId__c = kpiData != null ? kpiData.Id : null,
                dmpl__BillNo__c = billNo,
                dmpl__KPIValue__c = kpiValue,
                dmpl__KPIValue2__c = kpiValue2,
                dmpl__RewardValue__c = rewardValue,
                dmpl__SaleDoc__c = saleDoc,
                dmpl__SourceRecordId__c = sourceRecordId
            ),
            'KPIDataDetailDefaults',
            true
        );
    }

    public static dmpl__KPIDataDetail__c getKPIDataDetail() {
        return [
            SELECT Id, Name, dmpl__KPIDataId__c, dmpl__BillNo__c, dmpl__KPIValue__c, dmpl__KPIValue2__c, dmpl__RewardValue__c, dmpl__SaleDoc__c, dmpl__SourceRecordId__c
            FROM dmpl__KPIDataDetail__c
            WHERE Name = 'Test-KPI-Data-Detail'
            LIMIT 1
        ];
    }

    public static dmpl__KPIDataDetail__c getKPIDataDetail(Id detailId) {
        return [
            SELECT Id, Name, dmpl__KPIDataId__c, dmpl__BillNo__c, dmpl__KPIValue__c, dmpl__KPIValue2__c, dmpl__RewardValue__c, dmpl__SaleDoc__c, dmpl__SourceRecordId__c
            FROM dmpl__KPIDataDetail__c
            WHERE Id = :detailId
            LIMIT 1
        ];
    }

    public static dmpl__KPIDataDetail__c updateKPIDataDetail(dmpl__KPIDataDetail__c detail, Decimal newKPIValue) {
        detail.dmpl__KPIValue__c = newKPIValue;
        update detail;
        return getKPIDataDetail(detail.Id);
    }

    public static Integer deleteKPIDataDetail(dmpl__KPIDataDetail__c detail) {
        Id detailId = detail.Id;
        delete detail;
        Integer count = 0;
        try {
            count = [SELECT COUNT() FROM dmpl__KPIDataDetail__c WHERE Id = :detailId];
        } catch (Exception e) {
            count = 0;
        }
        return count;
    }
}