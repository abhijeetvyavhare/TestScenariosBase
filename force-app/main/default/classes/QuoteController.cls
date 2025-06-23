public with sharing class QuoteController implements Callable {
    
    public QuoteController() {

    }

    public Object call(String action, Map<String, Object> args) {
        switch on action {
            when 'headlessAction' {
                ServiceEstimateLineHelper.performReprice((Id)args.get('recordId'));
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