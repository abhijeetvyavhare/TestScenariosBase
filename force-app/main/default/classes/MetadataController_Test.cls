@isTest
private class MetadataController_Test {
    
    @isTest
    static void testGetFieldSetList() {
        try {
            dmpl__Item__c testObject = new dmpl__Item__c(Name = 'Test Object');
            insert testObject;
            
            Test.startTest();
            List<FieldsetInfo> fieldSetList = MetadataController.getFieldSetList('dmpl__Item__c');
            Test.stopTest();
            System.assertNotEquals(null, fieldSetList, 'Field set list should not be null');
            System.assertNotEquals(0, fieldSetList.size(), 'Field set list should not be empty');
        } catch (Exception e) {
            System.assert(false, 'An exception occurred: ' + e.getMessage());
        }
    }
    
    @isTest
    static void testGetFieldsByFieldSetName() {
        try {
            dmpl__Item__c testObject = new dmpl__Item__c(Name = 'Test Object');
            insert testObject;
            
            Test.startTest();
            List<FieldsetFieldInfo> fieldList = MetadataController.getFieldsByFieldSetName('dmpl__Item__c', 'dmpl__DMSImportFieldset');
            Test.stopTest();   
            System.assertNotEquals(null, fieldList, 'Field list should not be null');
            System.assertNotEquals(0, fieldList.size(), 'Field list should not be empty');
        } catch (Exception e) {
            System.assert(false, 'An exception occurred: ' + e.getMessage());
        }
    }
}