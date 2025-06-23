@isTest
private class SendMessageResult_Test {
    
    // Test method to verify if result and error are correctly set
    @isTest
    static void testSendMessageResult() {
        // Test data
        Boolean expectedResult = true;
        String expectedError = 'No errors';

        // Create a SendMessageResult instance
        SendMessageResult result = new SendMessageResult(expectedResult, expectedError);

        // Verify that result and error are correctly set
        System.assertEquals(expectedResult, result.result, 'Result should match');
        System.assertEquals(expectedError, result.error, 'Error should match');
    }
}