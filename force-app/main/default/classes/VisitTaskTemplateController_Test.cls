@isTest
private class VisitTaskTemplateController_Test {

    @isTest
    static void testVisitTaskTemplateEntriesWithValidRecordId() {
        dmpl__VisitTaskTemplate__c visitTaskTemplate = new dmpl__VisitTaskTemplate__c(
            Name = 'Test Visit Task Template',
            dmpl__Description__c = 'Visit Task Template1',
            dmpl__Duration__c = 10
        );
        insert visitTaskTemplate;

        dmpl__VisitTaskTemplateEntry__c templateEntry = new dmpl__VisitTaskTemplateEntry__c(
            Name = 'Test Template Entry',
            dmpl__SequenceNumber__c = 1,
            dmpl__VisitTaskTemplateId__c = visitTaskTemplate.Id,
            dmpl__TaskType__c = 'Perform Visit Activities'
        );
        insert templateEntry;

        Test.startTest();
        List<dmpl__VisitTaskTemplateEntry__c> entries = VisitTaskTemplateController.VisitTaskTemplateEntries(visitTaskTemplate.Id);
        Test.stopTest();

        System.assertNotEquals(0, entries.size(), 'Expected non-zero entries');
    }
    
    @isTest
    static void testVisitTaskTemplateEntriesWithInvalidRecordId() {
    String invalidRecordId = 'a';
    
    Test.startTest();
   
    try{
        List<dmpl__VisitTaskTemplateEntry__c> entries = VisitTaskTemplateController.VisitTaskTemplateEntries(invalidRecordId);
    }catch(Exception e){
        System.assertEquals('System.StringException', e.getTypeName(), 'Expected StringException');
    }
        Test.stopTest();
    }

}