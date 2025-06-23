({
    closeAction : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
        var recordId = component.get("v.recordId");
        if(!recordId){
            recordId = event.getParam('Id');
        }
        if(recordId){
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": recordId
            });
            navEvt.fire();
        }else {
            var homeEvt = $A.get("e.force:navigateToObjectHome");
            homeEvt.setParams({
                "scope": component.get("v.sObjectName")
            });
            homeEvt.fire();    
        }
    }
})