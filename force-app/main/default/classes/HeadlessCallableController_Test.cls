@isTest
public class HeadlessCallableController_Test {

   
    @isTest
    static void testCallHeadlessAction() {
        // Account data and also add all required fields here only before insert
       
        //Account acc = [SELECT Id, Name FROM Account LIMIT 1];
                             

        try{      
		 HeadlessCallableController.callHeadlessAction(null, 'dmpl__AccountGroup__c','a000l00000JV7zaAAD');

        }
        catch(Exception ex){}
       HeadlessCallableController result = new HeadlessCallableController();
        
    }



}