public with sharing class DynamicCallableController {
    public DynamicCallableController() {

    }

    @AuraEnabled(cacheable = false)
    public static Object callDynamicAction(
        String actionName,
        String controllerName, 
        Map<String, Object> param1){
    try
        {
            if(String.isBlank(actionName)){
                actionName = 'action';
            }
            System.Type typeName = Type.forName(controllerName);
            if(typeName == null){
                throw new CalloutException(
                    'Type not found!. Please ensure that the controller class named \"' 
                    + controllerName 
                    + '\" exists and is accessable.');
            }
            
            Object dynamicObject =  typeName.newInstance();
            if(dynamicObject == null){
                throw new CalloutException(
                    'Failed to create Dynamic Controller!. Please ensure that the controller class named \"' 
                    + controllerName 
                    + '\" is creatable.');
            }

            Callable callable =  (Callable)dynamicObject;
            if(callable == null){
                throw new CalloutException(
                    'Callable Type Cast Failed!. Please ensure that the controller class named \"' 
                    + controllerName 
                    + '\" implements Callable Interface.');
            }

            return callable.call(
                    actionName,
                    param1);
        }
        catch(Exception e)
        {
            throw new DMPLException(e.getMessage());
        }
    }
}