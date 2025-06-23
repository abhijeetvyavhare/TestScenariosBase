public with sharing class SaleOrderController implements Callable {
    
    public SaleOrderController() {

    }

    public Object call(String action, Map<String, Object> args) {
        switch on action {
            when 'headlessAction' {
                SaleOrderLineHelper.performReprice((Id)args.get('recordId'));
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