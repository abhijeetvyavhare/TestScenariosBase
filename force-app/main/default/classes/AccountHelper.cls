@namespaceAccessible
public with sharing class AccountHelper extends TriggerHandler {
    private static final string OBJECT_ACCOUNT = 'Account';
    private static final string OBJECT_BRANCH = 'dmpl__Branch__c';
    private static final string FIELD_ACCOUNT_STATUS = 'dmpl__Status__c';
    private static final string FIELD_ACCOUNT_ACCOUNTCONTACTID = 'dmpl__AccountContactId__c';
    private static final List<String> LIST_NON_EDITABLE_FIELDS = new List<String>{};
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{
        FIELD_ACCOUNT_ACCOUNTCONTACTID
    };
    private static final List<String> LIST_FIELDS_LOCKEDIFTRANSACTED = new List<String>{
        FIELD_ACCOUNT_ACCOUNTCONTACTID
    };

    private static Boolean skipPosting = false; 

    private List<Account> triggerNew;
    private List<Account> triggerOld;
    private Map<Id, Account> triggerMapNew;
    private Map<Id, Account> triggerMapOld;

    public AccountHelper() {
        this.triggerOld = (List<Account>) Trigger.old;
        this.triggerNew = (List<Account>) Trigger.new;
        this.triggerMapNew = (Map<Id, Account>) Trigger.newMap;
        this.triggerMapOld = (Map<Id, Account>) Trigger.oldMap;
    }

    public override void beforeInsert() {
        if(!this.IsValidationSkipped()){
            StatusHelper.validateStatusNew(
                OBJECT_ACCOUNT, 
                FIELD_ACCOUNT_STATUS, 
                this.triggerNew);
            DocumentHelper.validateChangeInSystemFields(
                LIST_FIELDS_SYSTEM, 
                this.triggerNew);
        }
        if(!skipPosting){
            ContactHelper.createAccountContacts(
                this.triggerNew);
            setPartnerOwnerAccount(
                this.triggerNew);
        }
    }

    public override void beforeUpdate(){
        if(!this.IsValidationSkipped()){
            DocumentStatusDFSHelper dfsHelper = new DocumentStatusDFSHelper();
            StatusHelper.validateStatusEdit(
                OBJECT_ACCOUNT, 
                FIELD_ACCOUNT_STATUS, 
                this.triggerOld, 
                this.triggerNew);
            DocumentHelper.validateChangeInSystemFields(
                LIST_FIELDS_SYSTEM, 
                this.triggerOld, 
                this.triggerNew);
            dfsHelper.DocumentStatusRestrictEdits_Edit(
                OBJECT_ACCOUNT, 
                FIELD_ACCOUNT_STATUS, 
                this.triggerOld, 
                this.triggerNew);
            dfsHelper.DocumentStatusRestrictFieldsEdits(
                OBJECT_ACCOUNT, 
                FIELD_ACCOUNT_STATUS, 
                this.triggerOld, 
                this.triggerNew);
        }
        if(!AccountHelper.skipPosting){
            ContactHelper.updateAccountContacts(
                this.triggerOld, 
                this.triggerNew);
            OrgCacheHelper.removeSObjects(
                this.triggerNew);
        }
    }

    public override void beforeDelete(){
        if(!this.IsValidationSkipped()){
            DocumentStatusDFSHelper dfsHelper = new DocumentStatusDFSHelper();
            dfsHelper.DocumentStatusRestrictEdits_Delete(
                OBJECT_ACCOUNT, 
                FIELD_ACCOUNT_STATUS, 
                this.triggerOld);
        }
    }

    public override void afterInsert(){
        ContactHelper.updateAccountIds(
            this.triggerNew);
    }

    @namespaceAccessible
    public static Account getCachedDealerAccount(
        Id accountId){
        if (!OrgCacheHelper.isPlatformCacheEnabled(
            OBJECT_ACCOUNT)){
                if(!Test.isRunningTest()){
                    return (Account)CollectionHelper.getFirstIfExists(
                			queryDealerAccounts(
                    			new List<Id>{ 
                        		accountId }));
                }
        }
        Account account = (Account)OrgCacheHelper.getSObject(
            OBJECT_ACCOUNT, 
            accountId);
        if(account == null){
            account = (Account)CollectionHelper.getFirstIfExists(
                queryDealerAccounts(
                    new List<Id>{ 
                        accountId }));
            if(account!=null){
                OrgCacheHelper.setSObject(
                    account);
            }
        }

        return account;
    }

    @namespaceAccessible
    public static List<Account> getCachedDealerAccounts(
        List<Id> accountIds){
        if (!OrgCacheHelper.isPlatformCacheEnabled(OBJECT_ACCOUNT)){
            if(!Test.isRunningTest()){
                return queryDealerAccounts(
                	accountIds);
            }
        }
        List<Account> accounts = new List<Account>();
        List<Id> missingAccountIds = new List<Id>();
        for(Id accountId : accountIds){
            Account account = (Account)OrgCacheHelper.getSObject(
                OBJECT_ACCOUNT, 
                accountId);
            if(account == null){
                missingAccountIds.add(accountId);
            }else{
                accounts.add(account);
            }
        }
        if(missingAccountIds.size()>0){
            List<Account> missingAccounts = queryDealerAccounts(
                missingAccountIds);
            OrgCacheHelper.setSObjects(missingAccounts);
            accounts.addAll(missingAccounts);
        }

        return accounts;
    }
    
    @namespaceAccessible
    public static List<Account> getCachedAccounts(
        List<Id> accountIds){
        if (!SessionCacheHelper.isPlatformCacheEnabled(
            OBJECT_ACCOUNT)){
            if(!Test.isRunningTest()){
                return queryAccounts(accountIds);
            }
        }
        List<Account> accounts = new List<Account>();
        List<Id> missingAccountIds = new List<Id>();
        for(Id accountId : accountIds){
            Account account = (Account)SessionCacheHelper.getSObject(
                OBJECT_ACCOUNT, 
                accountId);
            if(account == null){
                missingAccountIds.add(
                    accountId);
            }else{
                accounts.add(
                    account);
            }
        }
        if(missingAccountIds.size()>0){
            List<Account> missingAccounts = queryAccounts(
                missingAccountIds);
            SessionCacheHelper.setSObjects(
                missingAccounts);
            accounts.addAll(
                missingAccounts);
        }
        return accounts;
    }
    
    public static void setDefaultAddress(SObject record, Account account){
        if(account == null || record == null){
            return;
        }
        if(record.get('dmpl__AccountName__c') == null ){
            record.put('dmpl__AccountName__c', account.Name);
        }
        if(record.get('dmpl__BillingAddressId__c') == null){
            for(dmpl__ContactAddress__c address : account.dmpl__ContactAddress__r){
                if(address.dmpl__IsDefault__c == true 
                    && (address.dmpl__AddressType__c == 'Billing Address' 
                        || address.dmpl__AddressType__c == 'Both')){
                            record.put('dmpl__BillingAddressId__c', address.Id);
                            break;                 
                        }
            }
        }

        if(record.get('dmpl__BillingAddressId__c')!=null){
            dmpl__ContactAddress__c address = (dmpl__ContactAddress__c)CollectionHelper.getObject(
                account.dmpl__ContactAddress__r, 
                (Id)record.get('dmpl__BillingAddressId__c'));
            if(address!=null){
                if(record.get('dmpl__BillingCity__c') == null
                    && record.get('dmpl__BillingCityPlaceId__c') == null
                    && record.get('dmpl__BillingCountry__c') == null
                    && record.get('dmpl__BillingPostalCode__c') == null
                    && record.get('dmpl__BillingRegion__c') == null
                    && record.get('dmpl__BillingState__c') == null
                    && record.get('dmpl__BillingStreet__c') == null){
                    record.put('dmpl__BillingCity__c', address.dmpl__City__c);
                    record.put('dmpl__BillingCityPlaceId__c', address.dmpl__CityPlaceId__c);
                    record.put('dmpl__BillingCountry__c', address.dmpl__Country__c);
                    record.put('dmpl__BillingPostalCode__c', address.dmpl__PostalCode__c);
                    record.put('dmpl__BillingRegion__c', address.dmpl__Region__c);
                    record.put('dmpl__BillingState__c', address.dmpl__State__c);
                    record.put('dmpl__BillingStreet__c', address.dmpl__Street__c);    
                    record.put('dmpl__BillingAddress__c', formatRecordBillingAddress(record));
                }else{
                    record.put('dmpl__BillingAddress__c', formatAddress(address));
                }
            }
        }else if(account.dmpl__BillingCity__c!=null 
            || account.dmpl__BillingCityPlaceId__c!=null
            || account.dmpl__BillingCountry__c!=null
            || account.dmpl__BillingPostalCode__c!=null
            || account.dmpl__BillingRegion__c!=null
            || account.dmpl__BillingState__c!=null
            || account.dmpl__BillingStreet__c!=null){
                if(record.get('dmpl__BillingCity__c') == null
                    && record.get('dmpl__BillingCityPlaceId__c') == null
                    && record.get('dmpl__BillingCountry__c') == null
                    && record.get('dmpl__BillingPostalCode__c') == null
                    && record.get('dmpl__BillingRegion__c') == null
                    && record.get('dmpl__BillingState__c') == null
                    && record.get('dmpl__BillingStreet__c') == null){
                    record.put('dmpl__BillingCity__c', account.dmpl__BillingCity__c);
                    record.put('dmpl__BillingCityPlaceId__c', account.dmpl__BillingCityPlaceId__c);
                    record.put('dmpl__BillingCountry__c', account.dmpl__BillingCountry__c);
                    record.put('dmpl__BillingPostalCode__c', account.dmpl__BillingPostalCode__c);
                    record.put('dmpl__BillingRegion__c', account.dmpl__BillingRegion__c);
                    record.put('dmpl__BillingState__c', account.dmpl__BillingState__c);
                    record.put('dmpl__BillingStreet__c', account.dmpl__BillingStreet__c);
                    record.put('dmpl__BillingAddress__c', formatRecordBillingAddress(record));
                }else{
                    record.put('dmpl__BillingAddress__c', formatRecordBillingAddress(record));
                }
        }else if(account.BillingAddress!=null){
            record.put('dmpl__BillingAddress__c', formatAddress(account.BillingAddress));
        }

        if(record.get('dmpl__ShippingAddressId__c') == null){
            for(dmpl__ContactAddress__c address : account.dmpl__ContactAddress__r){
                if(address.dmpl__IsDefault__c == true 
                    && (address.dmpl__AddressType__c == 'Shipping Address' 
                        || address.dmpl__AddressType__c == 'Both')){
                            record.put('dmpl__ShippingAddressId__c', address.Id);
                            break;                 
                        }
            }
        }

        if(record.get('dmpl__ShippingAddressId__c')!=null){
            dmpl__ContactAddress__c address = (dmpl__ContactAddress__c)CollectionHelper.getObject(
                account.dmpl__ContactAddress__r, 
                (Id)record.get('dmpl__ShippingAddressId__c'));
            if(address!=null){
                if(record.get('dmpl__ShippingCity__c') == null
                    && record.get('dmpl__ShippingCityPlaceId__c') == null
                    && record.get('dmpl__ShippingCountry__c') == null
                    && record.get('dmpl__ShippingPostalCode__c') == null
                    && record.get('dmpl__ShippingRegion__c') == null
                    && record.get('dmpl__ShippingState__c') == null
                    && record.get('dmpl__ShippingStreet__c') == null){
                        record.put('dmpl__ShippingCity__c', address.dmpl__City__c);
                        record.put('dmpl__ShippingCityPlaceId__c', address.dmpl__CityPlaceId__c);
                        record.put('dmpl__ShippingCountry__c', address.dmpl__Country__c);
                        record.put('dmpl__ShippingPostalCode__c', address.dmpl__PostalCode__c);
                        record.put('dmpl__ShippingRegion__c', address.dmpl__Region__c);
                        record.put('dmpl__ShippingState__c', address.dmpl__State__c);
                        record.put('dmpl__ShippingStreet__c', address.dmpl__Street__c);
                        record.put('dmpl__ShippingAddress__c', formatRecordShippingAddress(record));
                }else{
                    record.put('dmpl__ShippingAddress__c', formatAddress(address));
                }
            }
        }else if(account.dmpl__ShippingCity__c!=null 
            || account.dmpl__ShippingCityPlaceId__c!=null
            || account.dmpl__ShippingCountry__c!=null
            || account.dmpl__ShippingPostalCode__c!=null
            || account.dmpl__ShippingRegion__c!=null
            || account.dmpl__ShippingState__c!=null
            || account.dmpl__ShippingStreet__c!=null){
                if(record.get('dmpl__ShippingCity__c') == null
                    && record.get('dmpl__ShippingCityPlaceId__c') == null
                    && record.get('dmpl__ShippingCountry__c') == null
                    && record.get('dmpl__ShippingPostalCode__c') == null
                    && record.get('dmpl__ShippingRegion__c') == null
                    && record.get('dmpl__ShippingState__c') == null
                    && record.get('dmpl__ShippingStreet__c') == null){
                        record.put('dmpl__ShippingCity__c', account.dmpl__ShippingCity__c);
                        record.put('dmpl__ShippingCityPlaceId__c', account.dmpl__ShippingCityPlaceId__c);
                        record.put('dmpl__ShippingCountry__c', account.dmpl__ShippingCountry__c);
                        record.put('dmpl__ShippingPostalCode__c',account.dmpl__ShippingPostalCode__c);
                        record.put('dmpl__ShippingRegion__c', account.dmpl__ShippingRegion__c);
                        record.put('dmpl__ShippingState__c', account.dmpl__ShippingState__c);
                        record.put('dmpl__ShippingStreet__c', account.dmpl__ShippingStreet__c);
                        record.put('dmpl__ShippingAddress__c', formatRecordShippingAddress(record));
                }else{
                    record.put('dmpl__ShippingAddress__c', formatRecordShippingAddress(record));
                }
        }else if(account.ShippingAddress!=null){
            record.put('dmpl__ShippingAddress__c', formatAddress(account.ShippingAddress));
        }
    }
    @namespaceAccessible
    public static String formatAddress(
        Address address){
        if(address == null){
            return null;
        }
        List<String> lines = new List<String>();
        if(!String.isBlank(
            address.getStreet())){
            lines.add(
                address.getStreet());
        }

        List<String> components = new List<String>();
        if(!String.isBlank(
            address.getCity())){
            components.add(
                address.getCity());
        }
        if(!String.isBlank(
            address.getState())){
            components.add(
                address.getState());
        }
        if(!String.isBlank(
            address.getCountry())){
            components.add(
                address.getCountry());
        }
        if(!String.isBlank(
            address.getPostalCode())){
            components.add(
                address.getPostalCode());
        }
        if(components.size()>0){
            lines.add(
                String.join(
                    components, 
                    ', '));
        }
        if(lines.size()>0){
            return (String.join(
                lines, 
                '\n'));
        }
        return null;
    }

    @namespaceAccessible
    public static String formatAddress(
        dmpl__ContactAddress__c contactAddress){
        if(contactAddress == null){
            return null;
        }
        List<String> lines = new List<String>();
        if(!String.isBlank(contactAddress.dmpl__Street__c)){
            lines.add(contactAddress.dmpl__Street__c);
        }

        List<String> components = new List<String>();
        if(!String.isBlank(
            contactAddress.dmpl__Region__c)){
            components.add(
                contactAddress.dmpl__Region__c);
        }
        if(!String.isBlank(
            contactAddress.dmpl__City__c)){
            components.add(
                contactAddress.dmpl__City__c);
        }
        if(!String.isBlank(
            contactAddress.dmpl__State__c)){
            components.add(
                contactAddress.dmpl__State__c);
        }
        if(!String.isBlank(
            contactAddress.dmpl__Country__c)){
            components.add(
                contactAddress.dmpl__Country__c);
        }
        if(!String.isBlank(
            contactAddress.dmpl__PostalCode__c)){
            components.add(
                contactAddress.dmpl__PostalCode__c);
        }
        if(components.size()>0){
            lines.add(String.join(
                components, 
                ', '));
        }
        if(lines.size()>0){
            return (String.join(
                lines, 
                '\n'));
        }
        return null;
    }

    @namespaceAccessible
    public static String formatBillingAddress(
        Account account){
        if(account == null){
            return null;
        }
        List<String> lines = new List<String>();
        if(!String.isBlank(
            account.dmpl__BillingStreet__c)){
            lines.add(
                account.dmpl__BillingStreet__c);
        }

        List<String> components = new List<String>();
        if(!String.isBlank(
            account.dmpl__BillingRegion__c)){
            components.add(
                account.dmpl__BillingRegion__c);
        }
        if(!String.isBlank(
            account.dmpl__BillingCity__c)){
            components.add(
                account.dmpl__BillingCity__c);
        }
        if(!String.isBlank(
            account.dmpl__BillingState__c)){
            components.add(
                account.dmpl__BillingState__c);
        }
        if(!String.isBlank(
            account.dmpl__BillingCountry__c)){
            components.add(
                account.dmpl__BillingCountry__c);
        }
        if(!String.isBlank(
            account.dmpl__BillingPostalCode__c)){
            components.add(
                account.dmpl__BillingPostalCode__c);
        }
        if(components.size()>0){
            lines.add(String.join(components, ', '));
        }
        if(lines.size()>0){
            return (String.join(
                lines, 
                '\n'));
        }
        return null;
    }

    public static String formatRecordBillingAddress(
        SObject record){
        if(record == null){
            return null;
        }
        List<String> lines = new List<String>();
        if(!String.isBlank(
            (String)record.get('dmpl__BillingStreet__c'))){
            lines.add(
                (String)record.get('dmpl__BillingStreet__c'));
        }

        List<String> components = new List<String>();
        if(!String.isBlank(
            (String)record.get('dmpl__BillingRegion__c'))){
            components.add(
                (String)record.get('dmpl__BillingRegion__c'));
        }
        if(!String.isBlank(
            (String)record.get('dmpl__BillingCity__c'))){
            components.add(
                (String)record.get('dmpl__BillingCity__c'));
        }
        if(!String.isBlank(
            (String)record.get('dmpl__BillingState__c'))){
            components.add(
                (String)record.get('dmpl__BillingState__c'));
        }
        if(!String.isBlank(
            (String)record.get('dmpl__BillingCountry__c'))){
            components.add(
                (String)record.get('dmpl__BillingCountry__c'));
        }
        if(!String.isBlank(
            (String)record.get('dmpl__BillingPostalCode__c'))){
            components.add(
                (String)record.get('dmpl__BillingPostalCode__c'));
        }
        if(components.size()>0){
            lines.add(String.join(components, ', '));
        }
        if(lines.size()>0){
            return (String.join(
                lines, 
                '\n'));
        }
        return null;
    }

    @namespaceAccessible
    public static String formatShippingAddress(
        Account account){
        if(account == null){
            return null;
        }
        List<String> lines = new List<String>();
        if(!String.isBlank(
            account.dmpl__ShippingStreet__c)){
            lines.add(
                account.dmpl__ShippingStreet__c);
        }

        List<String> components = new List<String>();
        if(!String.isBlank(
            account.dmpl__ShippingRegion__c)){
            components.add(
                account.dmpl__ShippingRegion__c);
        }
        if(!String.isBlank(
            account.dmpl__ShippingCity__c)){
            components.add(
                account.dmpl__ShippingCity__c);
        }
        if(!String.isBlank(
            account.dmpl__ShippingState__c)){
            components.add(
                account.dmpl__ShippingState__c);
        }
        if(!String.isBlank(
            account.dmpl__ShippingCountry__c)){
            components.add(
                account.dmpl__ShippingCountry__c);
        }
        if(!String.isBlank(
            account.dmpl__ShippingPostalCode__c)){
            components.add(
                account.dmpl__ShippingPostalCode__c);
        }
        if(components.size()>0){
            lines.add(String.join(
                components, 
                ', '));
        }
        if(lines.size()>0){
            return (String.join(
                lines, 
                '\n'));
        }
        return null;
    }

    public static String formatRecordShippingAddress(
        SObject record){
        if(record == null){
            return null;
        }
        List<String> lines = new List<String>();
        if(!String.isBlank(
            (String)record.get('dmpl__ShippingStreet__c'))){
            lines.add(
                (String)record.get('dmpl__ShippingStreet__c'));
        }

        List<String> components = new List<String>();
        if(!String.isBlank(
            (String)record.get('dmpl__ShippingRegion__c'))){
            components.add(
                (String)record.get('dmpl__ShippingRegion__c'));
        }
        if(!String.isBlank(
            (String)record.get('dmpl__ShippingCity__c'))){
            components.add(
                (String)record.get('dmpl__ShippingCity__c'));
        }
        if(!String.isBlank(
            (String)record.get('dmpl__ShippingState__c'))){
            components.add(
                (String)record.get('dmpl__ShippingState__c'));
        }
        if(!String.isBlank(
            (String)record.get('dmpl__ShippingCountry__c'))){
            components.add(
                (String)record.get('dmpl__ShippingCountry__c'));
        }
        if(!String.isBlank(
            (String)record.get('dmpl__ShippingPostalCode__c'))){
            components.add(
                (String)record.get('dmpl__ShippingPostalCode__c'));
        }
        if(components.size()>0){
            lines.add(String.join(
                components, 
                ', '));
        }
        if(lines.size()>0){
            return (String.join(
                lines, 
                '\n'));
        }
        return null;
    }

    public static void updateAccountContactNames(
        List<Contact> newEntries){
        SecurityHelper.ensureCanReadFields(new List<String>{
            'dmpl__AccountContactId__c'
        },'Account');
        List<Account> relatedAccounts = [
            SELECT 
                Id, 
                Name, 
                dmpl__AccountContactId__c 
            FROM 
                Account 
            WHERE 
                Id IN : DocumentHelper.extractIds(
                    newEntries, 
                    'AccountId')];
        for(Contact contact : newEntries){
            for(Account account : relatedAccounts){
                if(account.Id == contact.AccountId){
                    account.dmpl__FirstName__c = contact.FirstName;
                    account.dmpl__LastName__c = contact.LastName;
                }
            }
        }

        if(relatedAccounts.size()>0){
            SecurityHelper.ensureCanWriteObject('Account');
            SecurityHelper.ensureCanWriteFields(new List<String>{
                'dmpl__AccountContactId__c'
            },'Account');
            try {
                (new AccountHelper()).setSkipValidation();
                AccountHelper.skipPosting = true;
                update relatedAccounts;
            } finally {
                (new AccountHelper()).clearSkipValidation();
                AccountHelper.skipPosting = false;
            }
        }
    }

     @TestVisible
     private static void setPartnerOwnerAccount(
        List<Account> newEntries){
         List<dmpl__Resource__c> resources = queryUserResource(
            UserInfo.getUserId());
         if(resources.size() == 0)
            return;
            
         for(Account account : newEntries)
            account.dmpl__PartnerOwnerAccountId__c = resources[0].dmpl__DefaultPartnerAccountId__c;
     }

  @TestVisible
  private static List<Account> queryAccounts(
    List<Id> accountIds){
        SecurityHelper.ensureCanReadFields(new String[]{
            'dmpl__CustomerDiscountAccountGroupId__c', 
            'dmpl__PartnerDiscountAccountGroupId__c',
            'dmpl__PartnerTaxAccountGroupId__c',
            'dmpl__CustomerPriceAccountGroupId__c',
            'dmpl__PartnerPriceAccountGroupId__c',
            'dmpl__CustomerSchemeAccountGroupId__c',
            'dmpl__PartnerSchemeAccountGroupId__c',
            'dmpl__IsCustomerAccount__c',
            'dmpl__IsPartnerAccount__c',
            'dmpl__IsSupplierAccount__c',
            'dmpl__IsTaxExempted__c',
            'dmpl__IsActive__c',
            'dmpl__Status__c',
            'dmpl__FirstName__c',
            'dmpl__LastName__c',
            'dmpl__Salutation__c',
            'dmpl__Email__c',
            'dmpl__BillingCity__c',
            'dmpl__BillingCountry__c',
            'dmpl__BillingPostalCode__c',
            'dmpl__BillingRegion__c',
            'dmpl__BillingState__c',
            'dmpl__BillingStreet__c',
            'dmpl__ShippingCity__c',
            'dmpl__ShippingCountry__c',
            'dmpl__ShippingPostalCode__c',
            'dmpl__ShippingRegion__c',
            'dmpl__ShippingState__c',
            'dmpl__ShippingStreet__c',
            'Name',
            'AccountNumber',
            'BillingAddress',
            'Phone',
            'ShippingAddress',
            'Type',
            'ParentId'
        }, OBJECT_ACCOUNT);
        SecurityHelper.ensureCanReadFields(new String[]{
            'dmpl__AddressType__c',
            'dmpl__City__c',
            'dmpl__Country__c',
            'dmpl__Location__c',
            'dmpl__PostalCode__c',
            'dmpl__Region__c',
            'dmpl__State__c',
            'dmpl__Street__c',
            'dmpl__IsDefault__c'
        }, 'dmpl__ContactAddress__c');
        return [SELECT Id, 
            Name, 
            dmpl__CustomerDiscountAccountGroupId__c, 
            dmpl__PartnerDiscountAccountGroupId__c,
            dmpl__PartnerTaxAccountGroupId__c,
            dmpl__CustomerPriceAccountGroupId__c,
            dmpl__PartnerPriceAccountGroupId__c,
            dmpl__CustomerSchemeAccountGroupId__c,
            dmpl__PartnerSchemeAccountGroupId__c,
            dmpl__IsCustomerAccount__c,
            dmpl__IsPartnerAccount__c,
            dmpl__IsSupplierAccount__c,
            dmpl__IsTaxExempted__c,
            dmpl__IsActive__c,
            dmpl__Status__c,
            dmpl__FirstName__c,
            dmpl__LastName__c,
            dmpl__Salutation__c,
            dmpl__Email__c,
            dmpl__BillingCity__c,
            dmpl__BillingCityPlaceId__c,
            dmpl__BillingCountry__c,
            dmpl__BillingPostalCode__c,
            dmpl__BillingRegion__c,
            dmpl__BillingState__c,
            dmpl__BillingStreet__c,
            dmpl__ShippingCity__c,
            dmpl__ShippingCityPlaceId__c,
            dmpl__ShippingCountry__c,
            dmpl__ShippingPostalCode__c,
            dmpl__ShippingRegion__c,
            dmpl__ShippingState__c,
            dmpl__ShippingStreet__c,
            AccountNumber,
            BillingAddress,
            ShippingAddress,
            Phone,
            Type,
            ParentId,
            (SELECT Id,
                dmpl__AddressType__c,
                dmpl__City__c,
                dmpl__CityPlaceId__c,
                dmpl__Country__c,
                dmpl__Location__c,
                dmpl__PostalCode__c,
                dmpl__Region__c,
                dmpl__State__c,
                dmpl__Street__c,
                dmpl__IsDefault__c
            FROM dmpl__ContactAddress__r)
        FROM Account
        WHERE Id IN:accountIds];
    }

    private static List<Account> queryDealerAccounts(
        List<Id> accountIds){
        SecurityHelper.ensureCanReadFields(new String[]{
            'dmpl__CustomerDiscountAccountGroupId__c', 
            'dmpl__PartnerDiscountAccountGroupId__c',
            'dmpl__PartnerTaxAccountGroupId__c',
            'dmpl__CustomerPriceAccountGroupId__c',
            'dmpl__PartnerPriceAccountGroupId__c',
            'dmpl__CustomerSchemeAccountGroupId__c',
            'dmpl__PartnerSchemeAccountGroupId__c',
            'dmpl__IsCustomerAccount__c',
            'dmpl__IsPartnerAccount__c',
            'dmpl__IsSupplierAccount__c',
            'dmpl__IsTaxExempted__c',
            'dmpl__PartnerItemComponentAccountGroupId__c',
            'dmpl__IsActive__c'
        }, OBJECT_ACCOUNT);
        SecurityHelper.ensureCanReadFields(new String[]{
            'dmpl__AllowInventory__c',
            'dmpl__AllowPurchase__c',
            'dmpl__AllowSales__c',
            'dmpl__AllowService__c',
            'dmpl__BranchType__c',
            'dmpl__BusinessHoursId__c',
            'dmpl__InventoryValuationMethod__c',
            'dmpl__IsHomeDeliveryAvailable__c',
            'dmpl__IsPickupDropAvailable__c',
            'dmpl__MarketingName__c',
            'dmpl__IsActive__c'
        }, OBJECT_BRANCH);

        return [SELECT Id, 
            Name, 
            dmpl__CustomerDiscountAccountGroupId__c, 
            dmpl__PartnerDiscountAccountGroupId__c,
            dmpl__PartnerTaxAccountGroupId__c,
            dmpl__CustomerPriceAccountGroupId__c,
            dmpl__PartnerPriceAccountGroupId__c,
            dmpl__CustomerSchemeAccountGroupId__c,
            dmpl__PartnerSchemeAccountGroupId__c,
            dmpl__IsCustomerAccount__c,
            dmpl__IsPartnerAccount__c,
            dmpl__IsSupplierAccount__c,
            dmpl__IsTaxExempted__c,
            dmpl__PartnerItemComponentAccountGroupId__c,
            dmpl__IsActive__c,
            (SELECT Id,
                dmpl__AllowInventory__c,
                dmpl__AllowPurchase__c,
                dmpl__AllowSales__c,
                dmpl__AllowService__c,
                dmpl__BranchType__c,
                dmpl__BusinessHoursId__c,
                dmpl__InventoryValuationMethod__c,
                dmpl__IsActive__c,
                dmpl__IsHomeDeliveryAvailable__c,
                dmpl__IsPickupDropAvailable__c,
                dmpl__MarketingName__c
            FROM dmpl__Branches__r)
        FROM Account
        WHERE Id IN:accountIds];
    }

    @TestVisible 
    private static List<dmpl__Resource__c> queryUserResource(Id userId){
        SecurityHelper.ensureCanReadFields(new List<String>{
            'dmpl__UserId__c',
            'dmpl__DefaultPartnerAccountId__c'
        },'dmpl__Resource__c');
        return [
            SELECT 
                Id,
                dmpl__UserId__c,
                dmpl__DefaultPartnerAccountId__c
            FROM dmpl__Resource__c
            WHERE 
            dmpl__IsActive__c = true
            AND dmpl__UserId__c =: userId
        ];
     }
}