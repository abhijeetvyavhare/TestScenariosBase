public with sharing class GeneralLedgerHelper {

    private static GeneralLedgerService gls;
    private static Map<Id, Account> partnerAccounts;
    public static void createLedger(
        GeneralLedgerTypeEnums ledgerType, 
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<sObject> oldEntries, 
        List<sObject> newEntries)
    {
        gls = new GeneralLedgerService();
        partnerAccounts = gls.queryPartnerAccounts(CollectionHelper.extractIds(
            isDelete ? oldEntries : newEntries,
            'dmpl__PartnerAccountId__c'));
        List<Id> ledgerIds = CollectionHelper.extractIds(newEntries, getLedgerFieldName(ledgerType));
        ledgerIds.addAll(
            CollectionHelper.extractIds(oldEntries, getLedgerFieldName(ledgerType)));
        Map<Id, dmpl__GeneralLedger__c> accountLedgers = gls.queryLedgerRecords(ledgerIds);
        if(isUpdate){
            updateLedger(
                ledgerType, 
                oldEntries, 
                newEntries,
                accountLedgers);
        }else if(isDelete){
            deleteLedger(
                ledgerType, 
                oldEntries,
                accountLedgers);
        }

        if(isInsert || isUpdate){
            insertLedger(
                isUpdate,
                ledgerType, 
                oldEntries, 
                newEntries);
        }
    }

    private static void insertLedger(
        Boolean isUpdate,
        GeneralLedgerTypeEnums ledgerType, 
        List<sObject> oldEntries, 
        List<sObject> newEntries){
            setDefaultGLAccounts(
                ledgerType,
                newEntries);
            Map<SObject, dmpl__GeneralLedger__c> insertedAccountLedgers = new Map<SObject, dmpl__GeneralLedger__c>();
            for(sObject lineEntry : newEntries){
                if(!isGLPostingEnabled(lineEntry)){
                    continue;
                }else if(lineEntry.get(getGLAccountFieldName(ledgerType)) == null){
                    lineEntry.addError(System.Label.IntegrityFailed_MissingGLAccount);
                } else if(!isApproved(lineEntry)){
                    lineEntry.put(getGLPostedFieldName(ledgerType), false);
                    continue;
                } else if (isUpdate && IsPosted(
                    ledgerType, 
                    getCorrespondingLineEntry(
                        oldEntries, 
                        lineEntry))){
                    continue;
                } else {
                    dmpl__GeneralLedger__c accountLedger= createAccountLedger(
                        ledgerType, 
                        lineEntry,
                        null);
                    if(accountLedger!=null){
                        insertedAccountLedgers.put(
                            lineEntry,
                            accountLedger);
                    }
                }
            }
            //
            try {
                TriggerHandler.skipValidations = true;
                if(insertedAccountLedgers.values().size()>0){
                    insert insertedAccountLedgers.values();
                }
            } finally{
                TriggerHandler.skipValidations = false;
            }
            //
            for(sObject lineEntry : newEntries){
                dmpl__GeneralLedger__c accountLedger = insertedAccountLedgers.get(lineEntry);
                if(accountLedger!=null){
                    lineEntry.put(
                        isRelatedEntry(ledgerType) ? GeneralLedgerService.FIELD_OBJECT_RELEATEDGENERALLEDGERID : 
                            GeneralLedgerService.FIELD_OBJECT_GENERALLEDGERID, 
                        accountLedger.Id);
                }
            }
    }

    private static void updateLedger(
        GeneralLedgerTypeEnums ledgerType, 
        List<sObject> oldEntries, 
        List<sObject> newEntries,
        Map<Id, dmpl__GeneralLedger__c> accountLedgers){
            List<dmpl__GeneralLedger__c> updatedAccountLedgers = new List<dmpl__GeneralLedger__c>();    
            List<dmpl__GeneralLedger__c> deletedAccountLedgers = new List<dmpl__GeneralLedger__c>();
            for(sObject lineEntry : oldEntries){
                if(!isGLPostingEnabled(lineEntry)){
                    continue;
                } else if(!isPosted(
                    ledgerType, 
                    lineEntry)){
                    continue;
                }
                //                
                dmpl__GeneralLedger__c accountLedger = accountLedgers.Get(
                    (ID)lineEntry.Get(getLedgerFieldName(ledgerType)));
                sObject newLineEntry = getCorrespondingLineEntry(
                    newEntries, 
                    lineEntry);
                if(newLineEntry == null){
                    lineEntry.addError(
                        System.Label.IntegrityFailed_MssingNewLine);
                }

                if(!isApproved(newLineEntry)){
                    if(accountLedger!=null){
                        deletedAccountLedgers.Add(accountLedger);
                    }
                }else {
                    if(lineEntry.get(getGLAccountFieldName(ledgerType)) == null){
                        lineEntry.addError(System.Label.IntegrityFailed_MissingGLAccount);
                    }
                    accountLedger = createAccountLedger(
                        ledgerType, 
                        newLineEntry, 
                        accountLedger);
                    if(accountLedger !=null){
                        updatedAccountLedgers.add(accountLedger);
                    }
                }
            }
            try {
                TriggerHandler.skipValidations = true;
                if(deletedAccountLedgers.size()>0){
                    delete deletedAccountLedgers;
                }
                if(updatedAccountLedgers.size()>0){
                    update updatedAccountLedgers;
                }
            } finally{
                TriggerHandler.skipValidations = false;
            }
        }

    private static void deleteLedger(
        GeneralLedgerTypeEnums ledgerType, 
        List<sObject> oldEntries,
        Map<Id, dmpl__GeneralLedger__c> accountLedgers){

        List<dmpl__GeneralLedger__c> deletedAccountLedgers = new List<dmpl__GeneralLedger__c>();
        for(sObject lineEntry : oldEntries){
            if(!isGLPostingEnabled(lineEntry)){
                continue;
            } else if(!isPosted(
                ledgerType, 
                lineEntry)){
                continue;
            }
            dmpl__GeneralLedger__c accountLedger = accountLedgers.Get(
                (ID)lineEntry.Get(getLedgerFieldName(ledgerType)));
            deletedAccountLedgers.add(accountLedger);   
        }   
        try {
            TriggerHandler.skipValidations = true;
            if(deletedAccountLedgers.size()>0){
                delete deletedAccountLedgers;
            }
        } finally{
            TriggerHandler.skipValidations = false;
        }     
    }

    private static dmpl__GeneralLedger__c createAccountLedger(
        GeneralLedgerTypeEnums ledgerType, 
        sObject sourceEntry, 
        dmpl__GeneralLedger__c oldaccountLedger){
        //
        DescribeSObjectResult describeResult = sourceEntry.getSObjectType().getDescribe();
        List<String> fieldNames = new List<String>(describeResult.fields.getMap().keySet());
        dmpl__GeneralLedger__c accountLedger = oldaccountLedger;
        string partAccountFieldName = getPartyAccountFieldName(ledgerType);
        if(accountLedger == null){
            accountLedger = new dmpl__GeneralLedger__c();
            accountLedger.dmpl__DocumentDate__c = Date.today();
        }
        accountLedger.dmpl__TransactionType__c = ledgerType.Name();
        accountLedger.dmpl__SourceDocumentName__c = (string)sourceEntry.Get('Name');
        accountLedger.dmpl__PartnerAccountId__c = (Id)sourceEntry.Get('dmpl__PartnerAccountId__c');
        accountLedger.dmpl__BranchId__c = (Id)sourceEntry.Get('dmpl__BranchId__c');
        accountLedger.dmpl__GLAccountId__c = (ID)sourceEntry.Get(getGLAccountFieldName(ledgerType));
        accountLedger.dmpl__Amount__c = ((Double)sourceEntry.Get(getGLAmountFieldName(ledgerType)));
        if(!String.isBlank(partAccountFieldName)){ 
            accountLedger.dmpl__AccountId__c = (ID)sourceEntry.Get(partAccountFieldName);
        }
        if(accountLedger.dmpl__AccountId__c == null 
            && isPartyAccountRequired(ledgerType, sourceEntry)){
            sourceEntry.addError('Party Account is mandatory for this document.');
        }
        sourceEntry.put(getGLPostedFieldName(ledgerType), true);
        return accountLedger;
    }

    private static Boolean isApproved(sObject lineEntry){
         return lineEntry.Get('dmpl__IsGLPostingApproved__c') == null ? 
            false : 
            (Boolean)lineEntry.Get('dmpl__IsGLPostingApproved__c');
    }

    private static Boolean isPosted(
        GeneralLedgerTypeEnums ledgerType, 
        sObject lineEntry){
        if(isRelatedEntry(ledgerType)){
            return lineEntry.Get('dmpl__IsRelatedGLPosted__c') == null ?
            false :
            (Boolean)lineEntry.Get('dmpl__IsRelatedGLPosted__c');
        } else {
            return lineEntry.Get('dmpl__IsGLPosted__c') == null ?
                false :
                (Boolean)lineEntry.Get('dmpl__IsGLPosted__c');
        }
    }
    
    private static Boolean isGLPostingEnabled(sObject lineEntry){
        Account partnerAccount = partnerAccounts.get((Id)lineEntry.get('dmpl__PartnerAccountId__c'));
        return partnerAccount !=null && partnerAccount.dmpl__IsGLPostingEnabled__c == true;
    }

    private static Boolean isRelatedEntry(GeneralLedgerTypeEnums ledgerType){
        return ledgerType ==  GeneralLedgerTypeEnums.PaymentTakenRelated
            || ledgerType ==  GeneralLedgerTypeEnums.PaymentGivenRelated
            || ledgerType ==  GeneralLedgerTypeEnums.InventoryRelated
            || ledgerType ==  GeneralLedgerTypeEnums.JournalRelated;
    }

    private static Boolean isLineEntry(GeneralLedgerTypeEnums ledgerType){
        return ledgerType ==  GeneralLedgerTypeEnums.InvoiceLine
            || ledgerType ==  GeneralLedgerTypeEnums.BillLine
            || ledgerType ==  GeneralLedgerTypeEnums.CreditNoteLine
            || ledgerType ==  GeneralLedgerTypeEnums.JournalLine
            || ledgerType ==  GeneralLedgerTypeEnums.DebitNoteLine;
    }

    private static Boolean isTaxEntry(GeneralLedgerTypeEnums ledgerType){
        return ledgerType ==  GeneralLedgerTypeEnums.InvoiceTax
            || ledgerType ==  GeneralLedgerTypeEnums.BillTax
            || ledgerType ==  GeneralLedgerTypeEnums.CreditNoteTax
            || ledgerType ==  GeneralLedgerTypeEnums.DebitNoteTax;
    }

    private static String getGLAccountFieldName(GeneralLedgerTypeEnums ledgerType){
        if(isRelatedEntry(ledgerType))  {
            return 'dmpl__RelatedGLAccountId__c';
        } else {
            return 'dmpl__GLAccountId__c';
        }
    }

    private static String getGLPostedFieldName(GeneralLedgerTypeEnums ledgerType){
        if(isRelatedEntry(ledgerType))  {
            return 'dmpl__IsRelatedGLPosted__c';
        } else {
            return 'dmpl__IsGLPosted__c';
        }
    }

    private static String getLedgerFieldName(GeneralLedgerTypeEnums ledgerType){
        if(isRelatedEntry(ledgerType))  {
            return 'dmpl__RelatedGeneralLedgerId__c';
        } else {
            return 'dmpl__GeneralLedgerId__c';
        }
    }

    private static String getGLAmountFieldName(GeneralLedgerTypeEnums ledgerType){
        if(isRelatedEntry(ledgerType))  {
            return 'dmpl__RelatedGLAmount__c';
        } else {
            return 'dmpl__GLAmount__c';
        }
    }

    private static string getPartyAccountFieldName(
        GeneralLedgerTypeEnums ledgerType){
        if(ledgerType == GeneralLedgerTypeEnums.Bill){
            return 'dmpl__SupplierAccountId__c';
        } else if(ledgerType == GeneralLedgerTypeEnums.PaymentTakenRelated
            || ledgerType == GeneralLedgerTypeEnums.PaymentGivenRelated
            || ledgerType == GeneralLedgerTypeEnums.Invoice
            || ledgerType == GeneralLedgerTypeEnums.CreditNote
            || ledgerType == GeneralLedgerTypeEnums.DebitNote){
                return 'dmpl__AccountId__c';
        }
        return null;
    }

    private static Boolean isPartyAccountRequired(
        GeneralLedgerTypeEnums ledgerType,
        sObject newLineEntry){
        GLAccountTypeEnums glAccountType = getSystemCodeForLedgerType(
            ledgerType,
            newLineEntry);
        return glAccountType == GLAccountTypeEnums.AccountReceivable || 
            glAccountType == GLAccountTypeEnums.AccountPayable;
    }

    private static sObject getCorrespondingLineEntry(List<sObject> newEntries, sObject oldEntry){
        for(sObject newEntry: newEntries){
            if(newEntry.Id == oldEntry.Id){
                return newEntry;
            }
        }
        return null;
    }

    private static void setDefaultGLAccounts(
        GeneralLedgerTypeEnums ledgerType, 
        List<sObject> newEntries){
        List<dmpl__GLAccount__c> glAccounts = gls.queryGLAccounts(
            CollectionHelper.extractIds(
                newEntries,
                'dmpl__PartnerAccountId__c'));
        for(sObject entry : newEntries) { 
            if(entry.get(getGLAccountFieldName(ledgerType)) != null){
                continue;
            }
            Id glAccountId = getDefaultLedgerAccount(
                ledgerType,
                entry,
                glAccounts);
            entry.put(getGLAccountFieldName(ledgerType), glAccountId);
        }
    }

    private static Id getDefaultLedgerAccount(
        GeneralLedgerTypeEnums ledgerType, 
        sObject newLineEntry,
        List<dmpl__GLAccount__c> glAccounts){
            GLAccountTypeEnums glAccountType = getSystemCodeForLedgerType(
            ledgerType,
            newLineEntry);
        for(dmpl__GLAccount__c glAccount : glAccounts){
            if(glAccount.dmpl__AccountType__c.replace(' ', '') == glAccountType.name()
                && ((Id)newLineEntry.get('dmpl__BranchId__c') == glAccount.dmpl__BranchId__c
                    || glAccount.dmpl__BranchId__c == null)){
                return glAccount.Id;
            }
        }
        return null;
    }

    private static GLAccountTypeEnums getSystemCodeForLedgerType(
        GeneralLedgerTypeEnums ledgerType,
        sObject newLineEntry){
        switch on ledgerType {
            when PaymentTaken{
                if(newLineEntry.get('dmpl__PaymentMode__c') == 'Cheque'){
                    return GLAccountTypeEnums.Bank;
                }else if(newLineEntry.get('dmpl__PaymentMode__c') == null 
                    || newLineEntry.get('dmpl__PaymentMode__c') == 'Cash'){
                    return GLAccountTypeEnums.Cash;
                }else if(newLineEntry.get('dmpl__PaymentMode__c') == 'Electronic Transfer'){
                    return GLAccountTypeEnums.Bank;
                }else if(newLineEntry.get('dmpl__PaymentMode__c') == 'Card'){
                    return GLAccountTypeEnums.Bank;
                }
            }
            when PaymentTakenRelated{
                return GLAccountTypeEnums.AccountReceivable;
            }
            when PaymentGiven{
                if(newLineEntry.get('dmpl__PaymentMode__c') == 'Cheque'){
                    return GLAccountTypeEnums.Bank;
                }else if(newLineEntry.get('dmpl__PaymentMode__c') == null 
                    || newLineEntry.get('dmpl__PaymentMode__c') == 'Cash'){
                    return GLAccountTypeEnums.Cash;
                }else if(newLineEntry.get('dmpl__PaymentMode__c') == 'Electronic Transfer'){
                    return GLAccountTypeEnums.Bank;
                }else if(newLineEntry.get('dmpl__PaymentMode__c') == 'Card'){
                    return GLAccountTypeEnums.CreditCard;
                }
            }
            when PaymentGivenRelated{
                return GLAccountTypeEnums.AccountPayable;
            }
            when Invoice {
                if(newLineEntry.get('dmpl__GLPostingType__c') == null 
                    || newLineEntry.get('dmpl__GLPostingType__c') == 'Credit'){
                    return GLAccountTypeEnums.AccountReceivable;
                }else if(newLineEntry.get('dmpl__GLPostingType__c') == 'Cash'){
                    return GLAccountTypeEnums.Cash;
                }else if(newLineEntry.get('dmpl__GLPostingType__c') == 'Bank'){
                    return GLAccountTypeEnums.Bank;
                }else if(newLineEntry.get('dmpl__GLPostingType__c') == 'Credit Card	'){
                    return GLAccountTypeEnums.CreditCard;
                }
            }
            when InvoiceLine {
                return GLAccountTypeEnums.Income;
            }
            when InvoiceTax {
                return GLAccountTypeEnums.TaxPayable;
            }
            when Inventory{
                return GLAccountTypeEnums.InventoryAsset;
            }
            when InventoryRelated{
                return GLAccountTypeEnums.CostOfGoodsSold;
            }
            when Bill{
                if(newLineEntry.get('dmpl__GLPostingType__c') == 'Credit'
                    || newLineEntry.get('dmpl__GLPostingType__c') == null){
                    return GLAccountTypeEnums.AccountPayable;
                }else if(newLineEntry.get('dmpl__GLPostingType__c') == 'Cash'){
                    return GLAccountTypeEnums.Cash;
                }else if(newLineEntry.get('dmpl__GLPostingType__c') == 'Bank'){
                    return GLAccountTypeEnums.Bank;
                }else if(newLineEntry.get('dmpl__GLPostingType__c') == 'Credit Card	'){
                    return GLAccountTypeEnums.CreditCard;
                }
            }
            when BillLine{
                if(newLineEntry.get('dmpl__GLPostingType__c') == 'Inventory'){
                    return GLAccountTypeEnums.InventoryAsset;
                }else if(newLineEntry.get('dmpl__GLPostingType__c') == null 
                    || newLineEntry.get('dmpl__GLPostingType__c') == 'Expense'){
                    return GLAccountTypeEnums.Expense;
                }
            }
            when BillTax{
                return GLAccountTypeEnums.TaxCredit;
            }
            when CreditNote{
                return GLAccountTypeEnums.AccountReceivable;
            }
            when CreditNoteLine{
                return GLAccountTypeEnums.Income;
            }
            when CreditNoteTax {
                return GLAccountTypeEnums.TaxCredit;
            }
            when DebitNote{
                return GLAccountTypeEnums.AccountPayable;
            }
            when DebitNoteLine{
                return GLAccountTypeEnums.Expense;
            }
            when DebitNoteTax{
                return GLAccountTypeEnums.TaxPayable;
            }
            when Journal{
                return GLAccountTypeEnums.None;
            }
         }
         return GLAccountTypeEnums.None;
    }
}


// private static Integer getGLAccountSign(
//         GeneralLedgerTypeEnums ledgerType){
//         switch on ledgerType {
//             when PaymentTaken{
//                 return -1;
//             }
//             when PaymentTakenRelated{
//                 return 1;
//             }
//             when PaymentGiven{
//                 return 1;
//             }
//             when PaymentGivenRelated{
//                 return -1;
//             }
//             when Invoice {
//                 return 1;
//             }
//             when InvoiceLine {
//                 return -1;
//             }
//             when InvoiceTax {
//                 return -1;
//             }
//             when Inventory{
//                 return -1;
//             }
//             when InventoryRelated{
//                 return 1;
//             }
//             when Bill{
//                 return -1;
//             }
//             when BillLine{
//                 return 1;
//             }
//             when BillTax{
//                 return 1;
//             }
//             when CreditNote{
//                 return -1;
//             }
//             when CreditNoteLine{
//                 return 1;
//             }
//             when CreditNoteTax {
//                 return 1;
//             }
//             when DebitNote{
//                 return 1;
//             }
//             when DebitNoteLine{
//                 return -1;
//             }
//             when DebitNoteTax{
//                 return -1;
//             }
//          }
//          return 1;
//     }