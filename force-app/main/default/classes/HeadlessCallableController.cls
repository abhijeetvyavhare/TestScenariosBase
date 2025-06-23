public with sharing class HeadlessCallableController {
    public HeadlessCallableController() {

    }

    @AuraEnabled(cacheable = false)
    public static HeadlessActionResult callHeadlessAction(
        String actionName,
        String objectApiName, 
        Id recordId){
    try
        {
            if(String.isBlank(actionName)){
                actionName = 'headlessAction';
            }
            String className = objectApiName
                .remove('dmpl')
                .removeEnd('_c')
                .remove('_') 
                + 'Controller';
            System.Type typeName = Type.forName(className);
            if(typeName == null){
                throw new CalloutException(
                    'Type not found!. Please ensure that the controller class named \"' 
                    + className 
                    + '\" exists and is accessable.');
            }
            
            Object dynamicObject =  typeName.newInstance();
            if(dynamicObject == null){
                throw new CalloutException(
                    'Failed to create Dynamic Controller!. Please ensure that the controller class named \"' 
                    + className 
                    + '\" is creatable.');
            }

            Callable callable =  (Callable)dynamicObject;
            if(callable == null){
                throw new CalloutException(
                    'Callable Type Cast Failed!. Please ensure that the controller class named \"' 
                    + className 
                    + '\" implements Callable Interface.');
            }

            return (HeadlessActionResult)callable.call(
                    actionName,
                    new Map<String, Object> {
                        'recordId' => recordId
                    });
        }
        catch(Exception e)
        {
            throw new DMPLException(e.getMessage());
        }
    }
}