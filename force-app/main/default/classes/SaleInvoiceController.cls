public with sharing class SaleInvoiceController implements Callable {
    
    public SaleInvoiceController() {

    }

    public Object call(String action, Map<String, Object> args) {
        switch on action {
            when 'headlessAction' {
                SaleInvoiceLineHelper.performReprice((Id)args.get('recordId'));
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