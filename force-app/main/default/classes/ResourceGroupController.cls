public with sharing class ResourceGroupController implements Callable {
    public ResourceGroupController() {

    }

    public Object call(String action, Map<String, Object> args) {
        switch on action {
            when 'headlessAction' {
                return ResourceGroupHelper.processMembers((Id)args.get('recordId'));
            }
            when else {
                throw new CalloutException('Method not implemented');
            }
        }
    } 
}