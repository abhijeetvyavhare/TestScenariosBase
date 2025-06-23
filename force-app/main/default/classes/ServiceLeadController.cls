public with sharing class ServiceLeadController {
    @AuraEnabled(cacheable = false)
    public static dmpl__ServiceLead__c convertLead(
        Object data){
            return ServiceLeadHelper.convertLead(
                data
            );
        }
    
    @AuraEnabled(cacheable = true)
    public static String getLeadConvertStatus(){
        return OrgSettingHelper.getLeadConvertStatus();
    }
}