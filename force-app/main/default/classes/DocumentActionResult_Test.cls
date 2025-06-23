@isTest
public class DocumentActionResult_Test {
    
    @isTest
    static void testDocumentActionResult() {
        // Arrange
        String expectedStatus = 'Success';
        String expectedMessage = 'Document processed successfully';

        // Act
        DocumentActionResult result = new DocumentActionResult(expectedStatus, expectedMessage);

        // Assert
        System.assertEquals(expectedStatus, result.status, 'Status should match');
        System.assertEquals(expectedMessage, result.message, 'Message should match');
    }
    
    @isTest
    static void testDocumentActionResultWithErrorMessage() {
        // Arrange
        String expectedError = 'An error occurred';

        // Act
        DocumentActionResult result = new DocumentActionResult(expectedError);

        // Assert
        System.assertEquals('error', result.status, 'Status should be "error"');
        System.assertEquals(expectedError, result.error, 'Error message should match');
    }
    
  /*  @isTest
    static void testDocumentActionResultWithDatabaseError() {
        // Arrange
        String expectedErrorMessage = 'An error occurred';
        Database.Error dbError = new Database.Error(1, expectedErrorMessage);

        // Act
        DocumentActionResult result = new DocumentActionResult(dbError);

        // Assert
        System.assertEquals('error', result.status, 'Status should be "error"');
        System.assertEquals(expectedErrorMessage, result.error, 'Error message should match');
    } */
    
    @TestVisible
    private static String testMessage;

    @TestVisible
    private static String testStatus;

    @TestVisible
    private static String testError;

    @isTest
    static void testAuraEnabledProperties() {
        // Create an instance of DocumentActionResult
        DocumentActionResult result = new DocumentActionResult('success', 'Action performed successfully!');
        
        // Set the AuraEnabled properties for testing
        testMessage = result.message;
        testStatus = result.status;
        testError = result.error;

        // Assert the values
        System.assertEquals('Action performed successfully!', testMessage, 'Message should match');
        System.assertEquals('success', testStatus, 'Status should be "success"');
      //  System.assertBlank(testError, 'Error should be blank');
    }
    
 /*   @isTest
    static void testDocumentActionResultWithDatabaseError() {
        // Arrange
        String expectedErrorMessage = 'An error occurred';
        Database.Error dbError = new Database.Error(1, expectedErrorMessage);

        // Act
        DocumentActionResult result = new DocumentActionResult(dbError);

        // Assert
        System.assertEquals('error', result.status, 'Status should be "error"');
        System.assertEquals(expectedErrorMessage, result.error, 'Error message should match');
    //    System.assertBlank(result.message, 'Message should be blank');
    } */
    
    @isTest
    static void testSuccessResult() {
        // Act
        DocumentActionResult result = DocumentActionResult.SuccessResult();

        // Assert
        System.assertEquals('success', result.status, 'Status should be "success"');
        System.assertEquals('Action performed successfully!', result.message, 'Message should match');
     //   System.assertBlank(result.error, 'Error should be blank');
    }
    
    @isTest
    static void testFailedResult() {
        // Arrange
        String expectedError = 'Custom error';

        // Act
        DocumentActionResult result = DocumentActionResult.FailedResult(expectedError);

        // Assert
        System.assertEquals('error', result.status, 'Status should be "error"');
        System.assertEquals(expectedError, result.error, 'Error message should match');
    //    System.assertBlank(result.message, 'Message should be blank');
    
        List<Database.Error> errors = new List<Database.Error>();
        new DocumentActionResult(errors);
        dmpl__ErrorLogEvent__e log = new dmpl__ErrorLogEvent__e();
        Database.SaveResult result1 = EventBus.publish(log);
        DocumentActionResult.InitFrom(result1);
        DocumentActionResult.InitFrom(new List<Database.SaveResult>{result1});
        
    }
    
    
}