@isTest
public class ContactPointAddressDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'ActiveFromDate'=>'2024-01-01',
            'ActiveToDate'=>'2024-01-01',
            'Address'=> 'Salesforce Tower, 415 Mission Street, 3rd Floor',
            'AddressType'=>'Billing',
            'BestTimeToContactEndTime'=>'09:30:00',
            'BestTimeToContactStartTime'=>'09:30:00',
            'BestTimeToContactTimezone'=>'none',
            'ContactPointPhoneId'=>null,
            'IsDefault'=>true,
            'IsPrimary'=>true,
            'IsThirdPartyAddress'=> 'Salesforce Tower, 415 Mission Street, 3rd Floor',
            'Name'=>'ContactPointAddress1',
            'ParentId'=>null,
            'PreferenceRank'=>'1234',
            'UsageType'=>'Home'
        };
    }
}