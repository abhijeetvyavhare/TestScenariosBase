public with sharing class ServiceCampaignController implements Callable {
   
    public Object call(String action, Map<String, Object> args) {
        switch on action {
            when 'headlessAction' {
                return ServiceCampaignHelper.processMembers((Id)args.get('recordId'));
            } when 'headlessAction2' {
                return ServiceCampaignHelper.processLeads((Id)args.get('recordId'));
            } when 'headlessAction3' {
                return ServiceCampaignHelper.processServiceRequests((Id)args.get('recordId'));
            } when 'headlessAction4' {
                return ServiceCampaignHelper.processAssets((Id)args.get('recordId'));
            }
            when else {
                throw new CalloutException('Method not implemented');
            }
        }
    }
}