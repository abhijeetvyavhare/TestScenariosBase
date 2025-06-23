@isTest
public class FieldsetDynamicPickList_Test {
    
     @isTest
    static void TestDynamicPicklistDefaultValue()
    {
        VisualEditor.DesignTimePageContext context = new VisualEditor.DesignTimePageContext();
        context.entityName = 'dmpl__SaleOrderLine__c';
        
        FieldsetDynamicPickList picklist = new FieldsetDynamicPickList(context);
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
        
        FieldsetDynamicPickList picklist = new FieldsetDynamicPickList(context);
        Test.startTest();
    	VisualEditor.DynamicPickListRows picklistValue = picklist.getValues();
    	Test.stopTest();
        System.assert(picklistValue.size() > 0, 'No parent picklist values found for Contact');
    }

}