@namespaceAccessible
public with sharing class ContactHelper {
    private static Boolean skipValidations = false;
    private static Boolean skipPosting = false;
    private static final string OBJECT_CONTACT = 'Contact';
    private static final string ACCOUNTSOURCE_DIRECT = 'Direct';
    private static final string ACCOUNTSOURCE_LEAD = 'Lead';
    private static final string PERSONACCOUNT_RECORDTYPE_NAME = 'PersonAccount';
    
    private static final List<String> LIST_NON_EDITABLE_FIELDS = new List<String>{};
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{};

    public static void validateData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<Contact> oldEntries, 
        List<Contact> newEntries){ 
        try{     
            if(isInsert){
                FieldMappingHelper.copyFieldMappingData(
                    newEntries);
            }
            if(skipValidations){
                return;
            }
            DocumentStatusDFSHelper dfsHelper = new DocumentStatusDFSHelper();
            if(isInsert){
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, newEntries);
            }else if(isUpdate){
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, oldEntries, newEntries);
            }else if(isDelete){
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }
    
    public static void postData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<Contact> oldEntries, 
        List<Contact> newEntries){
        if(skipPosting){
            return;
        }
    }

    public static void afterPostData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<Contact> oldEntries, 
        List<Contact> newEntries){
        if(skipPosting){
            return;
        }
        if(isUpdate){
            if(isPersonAccount()){
                return;
            }
            List<Contact> modifiedObjects = DocumentHelper.getModifiedNewObjects(
                new String[]{
                    'FirstName',
                    'LastName'
                }, 
                oldEntries, 
                newEntries);
            if(modifiedObjects.size()>0){
                AccountHelper.updateAccountContactNames(modifiedObjects);
            }            
        }
    }

    @namespaceAccessible
    public static void createAccountContacts(List<Account> newEntries){
        if(isPersonAccount()){
            return;
        }
        List<Contact> newContacts = new List<Contact>();
        for(Account account : newEntries){
            if(account.dmpl__IsCustomerAccount__c
            && account.dmpl__CreateAccountContact__c){
                Contact contact = createNewContact(account);
                newContacts.add(contact);
            }
        }

        if(newContacts.size()>0){
            // SecurityHelper.ensureCanCreateObject('Contact');
            // SecurityHelper.ensureCanWriteFields(new List<String>{
            //     'FirstName',
            //     'LastName',
            //     'Email',
            //     'MobilePhone'
            // },'Contact');
            insert newContacts;
            for(Contact contact : newContacts){
                Account account = (Account)CollectionHelper.getObject(newEntries, contact.AccountId);
                if(account!=null){
                    account.dmpl__AccountContactId__c = contact.Id;
                }
            }
        }
    }

    public static void updateAccountIds(List<Account> newEntries){
        List<Contact> existingContacts = queryExistingContacts(
            CollectionHelper.extractIds(
                newEntries, 
                'dmpl__AccountContactId__c'));
        for(Account account : newEntries){
            Contact contact = (Contact)CollectionHelper.getObject(
                existingContacts, 
                account.dmpl__AccountContactId__c);
            if(contact!=null){
                contact.AccountId = account.Id;
            }
        }
        if(existingContacts.size()>0){
            update existingContacts;
        }
    }

    @namespaceAccessible
    public static void updateAccountContacts(List<Account> oldEntries, List<Account> newEntries){
        if(isPersonAccount()){
            return;
        }
        List<Account> modifiedAccounts = DocumentHelper.getModifiedNewObjects(new List<String>{
            'dmpl__IsCustomerAccount__c',
            'dmpl__Salutation__c',
            'dmpl__FirstName__c',
            'dmpl__LastName__c',
            'dmpl__Email__c',
            'Phone',
            'dmpl__CreateAccountContact__c'
        }, oldEntries, newEntries);
       
        List<Contact> newContacts = new List<Contact>();
        List<Contact> updatedContacts = new List<Contact>();
        List<Contact> existingContacts = queryExistingContacts(
            CollectionHelper.extractIds(
                oldEntries, 
                'dmpl__AccountContactId__c'));
        for(Account account : newEntries){
            if(!account.dmpl__CreateAccountContact__c){
                continue;
            }
            Account oldAccount = (Account)CollectionHelper.getObject(
                oldEntries, 
                account.Id);
            Contact oldContact = (Contact)CollectionHelper.getObject(
                existingContacts,
                oldAccount.dmpl__AccountContactId__c);
            if(oldContact ==null 
                && account.dmpl__IsCustomerAccount__c){
                oldContact = createNewContact(account);
                newContacts.add(oldContact);
                account.dmpl__AccountContactId__r = oldContact;
            }else if(oldContact!=null){
                copyOldContact(oldContact, account);
                updatedContacts.add(oldContact);
            }
        }

        if(newContacts.size()>0){
            SecurityHelper.ensureCanCreateObject('Contact');
            SecurityHelper.ensureCanCreateFields(new List<String>{
                'Salutation',
                'FirstName',
                'LastName',
                'Email',
                'MobilePhone'
            },'Contact');
            try {
                skipValidations = true;
                skipPosting = true;
                insert newContacts;
            } finally {
                skipValidations = false;
                skipPosting = false;
            }

            for(Contact contact : newContacts){
                for(Account account : modifiedAccounts){
                    if(account.dmpl__AccountContactId__r == contact){
                        account.dmpl__AccountContactId__c = contact.Id;
                        break;
                    }
                }
            }
        }

        if(updatedContacts.size()>0){
            SecurityHelper.ensureCanWriteObject('Contact');
            SecurityHelper.ensureCanWriteFields(new List<String>{
                'Salutation',
                'FirstName',
                'LastName',
                'Email',
                'MobilePhone'
            },'Contact');
            try {
                skipValidations = true;
                skipPosting = true;
                update updatedContacts;
            } finally {
                skipValidations = false;
                skipPosting = false;
            }
        }
    }

    @TestVisible
    private static Contact createNewContact(Account account){
        if(account.dmpl__LastName__c == null){
            account.addError(System.Label.Validation_LastNameMandatoryForPersonAccount);
        }
        return new Contact(
            Salutation = account.dmpl__Salutation__c,
            FirstName = account.dmpl__FirstName__c,
            LastName = account.dmpl__LastName__c,
            Email = account.dmpl__Email__c,
            MobilePhone = account.Phone,
            AccountId = account.Id
        );
    }

    @TestVisible
    private static void copyOldContact(Contact contact, Account account){
        if(account.dmpl__LastName__c == null){
            account.addError(System.Label.Validation_LastNameMandatoryForPersonAccount);
        }
         contact.Salutation = account.dmpl__Salutation__c;
         contact.FirstName = account.dmpl__FirstName__c;
         contact.LastName = account.dmpl__LastName__c;
         contact.Email = account.dmpl__Email__c;
         contact.MobilePhone = account.Phone;
    }


  @TestVisible  
  private static List<Contact> queryExistingContacts(List<Id> contactIds){
        SecurityHelper.ensureCanReadFields(new List<String>{
            'Salutation',
            'FirstName',
            'LastName',
            'Email',
            'MobilePhone'
        },'Contact');
        return [SELECT Id,
            FirstName,
            LastName,
            Email,
            MobilePhone
        FROM Contact
        WHERE Id In:contactIds];
    }

    private static Boolean isPersonAccount(){
        return Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()?.get(PERSONACCOUNT_RECORDTYPE_NAME)?.getRecordTypeId() != null;
    }
}