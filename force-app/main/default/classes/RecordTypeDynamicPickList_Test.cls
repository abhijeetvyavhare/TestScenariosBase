@isTest
public class RecordTypeDynamicPickList_Test {
    
    @isTest
    static void TestDynamicPicklistDefaultValue()
    {
        VisualEditor.DesignTimePageContext context = new VisualEditor.DesignTimePageContext();
        context.entityName = 'dmpl__SaleOrderLine__c';
        
        RecordTypeDynamicPickList picklist = new RecordTypeDynamicPickList(context);
        Test.startTest();
    	VisualEditor.DataRow defaultValue = picklist.getDefaultValue();
    	Test.stopTest();
        System.assertEquals(null,defaultValue,'Timeline Parent Picklist default value incorrect');
    }
    
    @isTest
    static void TestDynamicPicklistValue()
    {
        VisualEditor.DesignTimePageContext context = new VisualEditor.DesignTimePageContext();
        context.entityName = 'dmpl__SaleOrderLine__c';
        
        RecordTypeDynamicPickList picklist = new RecordTypeDynamicPickList(context);
        Test.startTest();
    	VisualEditor.DynamicPickListRows picklistValue = picklist.getValues();
    	Test.stopTest();
        System.assert(picklistValue.size() > 0, 'No parent picklist values found for Contact');
    }
    
}