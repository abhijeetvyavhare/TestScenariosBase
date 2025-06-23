@isTest
public class ResourceGroupControllerTest {
    
    @isTest
    static void testHeadlessAction() {
        
        dmpl__Resource__c testRecord = new dmpl__Resource__c(Name = 'Test Record');
        insert testRecord;

        ResourceGroupController controller = new ResourceGroupController();

        Map<String, Object> args = new Map<String, Object>{
            'recordId' => testRecord.Id
        };

        Test.startTest();
        Object result = controller.call('headlessAction', args);
        Test.stopTest();

    }

    @isTest
    static void testMethodNotImplemented() {
        
        ResourceGroupController controller = new ResourceGroupController();

        Map<String, Object> args = new Map<String, Object>();

        Test.startTest();
        try {
            controller.call('unsupportedAction', args);
            System.assert(false, 'An exception should have been thrown for unsupported action');
        } catch (CalloutException e) {
            System.assertEquals('Method not implemented', e.getMessage(), 'Exception message should match');
        }
        Test.stopTest();
    }
}