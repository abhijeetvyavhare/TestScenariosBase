public class DmplRepairOrderDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'OwnerId' => UserInfo.getUserId(),
                        'dmpl__PartnerAccountId__c' => TestDataHelpers.getPartnerAccount().Id ,
                        'dmpl__BranchId__c' => TestDataHelpers.getBranch().Id

        };
    }
}