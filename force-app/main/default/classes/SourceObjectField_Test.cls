@isTest
private class SourceObjectField_Test {
    
    @isTest
    static void testGettersAndSetters() {
        SourceObjectField field = new SourceObjectField();
        
        field.fieldName = 'Test Field';
        field.fieldValue = 'Test Value';        
        
        System.assertEquals('Test Field', field.fieldName, 'Field name should match');
        System.assertEquals('Test Value', field.fieldValue, 'Field value should match');
        
    }
}