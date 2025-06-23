public with sharing class ServiceRequestController implements Callable {
    
    public ServiceRequestController() {

    }

    public Object call(String action, Map<String, Object> args) {
        switch on action {
            when 'headlessAction' {
                ServiceRequestLineHelper.performReprice((Id)args.get('recordId'));
                return new HeadlessActionResult(
                    true,
                    'Reprice successful.');
            }
            when else {
                throw new CalloutException('Method not implemented');
            }
        }
    } 
}