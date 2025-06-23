@isTest
private class DynamicCallableController_Test {
  @isTest
    static void testCallDynamicAction() {
        String actionName = 'updateField';
        String controllerName = 'ServiceJourneyController';
        Map<String, Object> params = new Map<String, Object>{
            'uid' => 'ACTIVITY_SEARCH_VIN',
            'fieldValue' => 'Test' 
        };

        Test.startTest();
        try {
            Object result = DynamicCallableController.callDynamicAction(actionName, controllerName, params);
            System.assertNotEquals(null, result);
            System.assert(((Map<String, Object>)result).containsKey('ACTIVITY_ASSET_DETAIL'));
        } catch (Exception e) {
            System.assert(false, 'An unexpected exception occurred: ' + e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void testCallDynamicAction_TypeNotFound() {
        String actionName = 'testAction';
        String controllerName = 'NonExistentClass';
        Map<String, Object> param1 = new Map<String, Object>{'param1Key' => 'param1Value'};
        
        Test.startTest();
        
        try {
            DynamicCallableController.callDynamicAction(actionName, controllerName, param1);
            System.assert(false, 'Expected exception was not thrown');
        } catch (Exception e) {
            // Add assertions here for the expected exception
            System.assert(e.getMessage().contains('Type not found!'), 'Exception message should indicate type not found');
        }
        
        Test.stopTest();
    }
}