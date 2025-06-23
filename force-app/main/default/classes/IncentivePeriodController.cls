public with sharing class IncentivePeriodController implements Callable {
    public Object call(String action, Map<String, Object> args) {
        switch on action {
            when 'headlessAction' {
                IncentiveProcessor.perfromAction(
                    (Id)args.get('recordId'));
                return new HeadlessActionResult(
                    true,
                    'Submitted successful.');
            }
            when else {
                throw new CalloutException('Method not implemented');
            }
        }
    } 
}