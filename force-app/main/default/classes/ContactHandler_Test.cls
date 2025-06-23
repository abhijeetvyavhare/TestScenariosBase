@isTest
private class ContactHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Contact contact = ContactDataHelper.createContact('9877583210', '9886556289', 'SetupContactLastName');
        dmpl__ContactAddress__c contactAddress = ContactDataHelper.createContactAddress('SetupContactAddress');
    }

    @isTest
    static void createContactPositive() {
        Contact contact = ContactDataHelper.getContactByPhone('9877583210');
        System.assertNotEquals(contact, null, 'Expected contact to be created.');
    }

    @isTest
    static void updateContactPositive() {
        Contact contact = ContactDataHelper.getContactByPhone('9877583210');
        contact.LastName = 'UpdatedLastName';
        test.startTest();
        update contact;
        test.stopTest();
        Contact updatedContact = ContactDataHelper.getContactById(contact.Id);
        System.assertEquals(String.valueOf(contact.LastName), 'UpdatedLastName', 'Expected the contact to be updated.');
    }

    @isTest
    static void deleteContactPositive() {
        Contact contact = ContactDataHelper.getContactByPhone('9877583210');
        test.startTest();
        delete contact;
        test.stopTest();
        Contact deletedContact = ContactDataHelper.getContactById(contact.Id);
        System.assertEquals(deletedContact, null, 'Expected the contact to be deleted.');
    }

    @isTest
    static void createContactAddressPositive() {
        dmpl__ContactAddress__c contactAddress = ContactDataHelper.getContactAddressByName('SetupContactAddress');
        System.assertNotEquals(contactAddress, null, 'Expected contact address to be created.');
    }

    @isTest
    static void updateContactAddressPositive() {
        dmpl__ContactAddress__c contactAddress = ContactDataHelper.getContactAddressByName('SetupContactAddress');
        contactAddress.dmpl__City__c = 'Mumbai';
        test.startTest();
        update contactAddress;
        test.stopTest();
        dmpl__ContactAddress__c updatedContactAddress = ContactDataHelper.getContactAddressById(contactAddress.Id);
        System.assertEquals(String.valueOf(updatedContactAddress.dmpl__City__c), 'Mumbai', 'Expected the contact address to be updated.');
    }

    @isTest
    static void deleteContactAddressPositive() {
        dmpl__ContactAddress__c contactAddress = ContactDataHelper.getContactAddressByName('SetupContactAddress');
        test.startTest();
        delete contactAddress;
        test.stopTest();
        dmpl__ContactAddress__c deletedContactAddress = ContactDataHelper.getContactAddressById(contactAddress.Id);
        System.assertEquals(deletedContactAddress, null, 'Expected the contact address to be deleted.');
    }
}