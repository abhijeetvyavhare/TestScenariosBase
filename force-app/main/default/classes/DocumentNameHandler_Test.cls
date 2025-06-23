@isTest
public with sharing class DocumentNameHandler_Test {
    @TestSetup
    static void createRequiredData(){
        dmpl__DocumentNameSetting__c docNameSetting = DocumentNameSettingDataHelper.createDocumentNameSetting();
    }

    @isTest
    static void testInsertDocumentNameSetting(){
        dmpl__DocumentNameSetting__c docNameSetting = DocumentNameSettingDataHelper.getDocumentNameSetting();
        System.assert(docNameSetting.Id != null, 'Document Name Setting should be inserted.');
    }

    @isTest
    static void testUpdateDocumentNameSetting(){
        dmpl__DocumentNameSetting__c docNameSetting = DocumentNameSettingDataHelper.getDocumentNameSetting();
        docNameSetting.dmpl__ObjectApiName__c = 'dmpl__SaleOrder__c';
        docNameSetting.dmpl__LastNumberUsed__c = 15;
        docNameSetting.dmpl__DocumentSeries__c = 'Series B';
        update docNameSetting;

        dmpl__DocumentNameSetting__c updatedDocSetting = DocumentNameSettingDataHelper.getDocumentNameSetting();
        System.assertEquals('dmpl__SaleOrder__c',updatedDocSetting.dmpl__ObjectApiName__c, 'Object API Name should be updated');
        System.assertEquals(15, updatedDocSetting.dmpl__LastNumberUsed__c, 'Last Number Used should be updated');
        System.assertEquals('Series B', updatedDocSetting.dmpl__DocumentSeries__c, 'Document Series should be updated');
    }
    
    @isTest
    static void testDeleteDocumentNameSetting(){
        dmpl__DocumentNameSetting__c docNameSetting = DocumentNameSettingDataHelper.getDocumentNameSetting();
        delete docNameSetting;
        dmpl__DocumentNameSetting__c updatedDocSetting = DocumentNameSettingDataHelper.getDocumentNameSetting();
        System.assert(updatedDocSetting == null, 'Document Name Setting should be deleted.');
    }
}