public with sharing class AccountGroupController implements Callable {
    public AccountGroupController() {

    }

    public Object call(String action, Map<String, Object> args) {
        switch on action {
            when 'headlessAction' {
                return AccountGroupHelper.processMembers((Id)args.get('recordId'));
            }
            when else {
                throw new CalloutException('Method not implemented');
            }
        }
    } 
}