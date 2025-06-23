public with sharing class InventoryCycleCountController implements Callable {
    public InventoryCycleCountController() {

    }

    public Object call(String action, Map<String, Object> args) {
        switch on action {
            when 'headlessAction' {
                return InterfaceQueueService.queueJobType(
                    InterfaceQueueService.JOBTYPE_TYPE_CYCLECOUNT_MP,
                    (Id)args.get('recordId'));
            }
            when else {
                throw new CalloutException('Method not implemented');
            }
        }
    } 
}