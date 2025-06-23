@isTest
public class ContactDefaults implements TestFactory.FieldDefaults{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'AccountId'=>null,
            'AssistantName'=>'Assistant1',
            'AssistantPhone'=>'1-800-NO-SOFTWARE',
            'Jigsaw'=>'none',
            'Department'=>'it',
            'Description'=>'none',
            'DoNotCall'=>false,
            'Email'=>'info@salesforce.com',
            'HasOptedOutOfEmail'=>false,
            'Fax'=>'none',
            'HasOptedOutOfFax'=>false,
            'FirstNameLocal'=>'ravi',
            'HomePhone'=>'1-800-NO-SOFTWARE',
            'IndividualId'=>null,
            'LastNameLocal'=>'raj',
            'LeadSource'=>'Web',
            'MobilePhone'=>'1234567890',
            'Salutation'=>'none',
            'FirstName'=>'rabi',
            'LastName'=>'raj',
            'OtherPhone'=>'1234567890',
            'Phone'=>'1234567890',
            'ReportsToId'=>null,
            'Title'=>'none'
        };
    }
}