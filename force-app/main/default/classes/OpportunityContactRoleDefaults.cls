@isTest
public with sharing class OpportunityContactRoleDefaults  implements TestFactory.FieldDefaults{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'IsPrimary'=>true,
            'Role'=>'Business User'
        };
    }
}