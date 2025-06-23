public with sharing class ItemGroupController implements Callable {
    public ItemGroupController() {

    }

    public Object call(String action, Map<String, Object> args) {
        switch on action {
            when 'headlessAction' {
                return ItemGroupHelper.processMembers((Id)args.get('recordId'));
            }
            when else {
                throw new CalloutException('Method not implemented');
            }
        }
    } 
}