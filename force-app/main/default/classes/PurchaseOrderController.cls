public with sharing class PurchaseOrderController implements Callable {
    
    public PurchaseOrderController() {

    }

    public Object call(String action, Map<String, Object> args) {
        switch on action {
            when 'headlessAction' {
                PurchaseOrderLineHelper.performReprice((Id)args.get('recordId'));
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