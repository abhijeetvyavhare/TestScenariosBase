public without sharing class AccountBalanceHelper {
     
    public static void postGeneralLedgerRecords(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__GeneralLedger__c> oldEntries, 
        List<dmpl__GeneralLedger__c> newEntries)
    {
        List<dmpl__AccountBalance__c> accountBalances = getLedgerRelatedBalnces(
            newEntries, 
            oldEntries);
        Map<ID, dmpl__AccountBalance__c> updatedAccountBalances = new Map<ID, dmpl__AccountBalance__c>();
        List<dmpl__AccountBalance__c> insertedAccountBalances = new List<dmpl__AccountBalance__c>();
        //
        if(isDelete || isUpdate ){
            for(dmpl__GeneralLedger__c ledgerEntry : oldEntries){
                if((!ledgerEntry.dmpl__IsAccountBalancePosted__c)
                    || (isUpdate && !areKeyFieldsModified(newEntries, ledgerEntry)))
                    continue;
                //
                dmpl__AccountBalance__c accountBalance = getAccountBalance(ledgerEntry, accountBalances);
                if(accountBalance == null){
                    throwDmplException('Missing account balance.');
                }else if(undoGeneralLedgerEntry(ledgerEntry, accountBalance)){
                    if(!updatedAccountBalances.ContainsKey(accountBalance.Id)){
                        updatedAccountBalances.Put(accountBalance.Id, accountBalance);
                    }
                }
            }
        }
        //
        if(isInsert || isUpdate ){
            for(dmpl__GeneralLedger__c ledgerEntry : newEntries){
                if(isUpdate && !areKeyFieldsModified(oldEntries, ledgerEntry)){
                    continue;
                }
                //
                dmpl__AccountBalance__c accountBalance = getAccountBalance(ledgerEntry, accountBalances);
                if(accountBalance == null){
                    accountBalance= createAccountBalance(ledgerEntry);
                    accountBalances.Add(accountBalance);
                }
                //
                if(doGeneralLedgerEntry(ledgerEntry, accountBalance)){
                    if(!updatedAccountBalances.ContainsKey(accountBalance.Id)
                        && !insertedAccountBalances.Contains(accountBalance)){
                            if(accountBalance.Id == null){
                                insertedAccountBalances.Add(accountBalance);
                            }else{
                                updatedAccountBalances.Put(accountBalance.Id, accountBalance);
                            }
                        }
                    ledgerEntry.dmpl__IsAccountBalancePosted__c = true;
                }
            }
        }
        
        try {
            TriggerHandler.skipValidations = true;
            update updatedAccountBalances.Values();
            insert insertedAccountBalances;    
        } finally {
            TriggerHandler.skipValidations = false;
        }
    }

    @testvisible
    private static Boolean areKeyFieldsModified(List<dmpl__GeneralLedger__c> oldEntries, dmpl__GeneralLedger__c newEntry){
        dmpl__GeneralLedger__c oldEntry = getOldEntry(oldEntries, newEntry);
        return (oldEntry.dmpl__AccountId__c != newEntry.dmpl__AccountId__c 
            ||oldEntry.dmpl__Amount__c != newEntry.dmpl__Amount__c 
            ||oldEntry.dmpl__GLAccountId__c != newEntry.dmpl__GLAccountId__c 
            ||oldEntry.dmpl__PartnerAccountId__c != newEntry.dmpl__PartnerAccountId__c 
            ||oldEntry.dmpl__TransactionType__c != newEntry.dmpl__TransactionType__c);
    }

    private static dmpl__GeneralLedger__c getOldEntry(List<dmpl__GeneralLedger__c> oldEntries, dmpl__GeneralLedger__c newEntry){
        for(dmpl__GeneralLedger__c oldEntry : oldEntries){
            if(oldEntry.Id == newEntry.Id){
                return oldEntry;
            }
        }
        //
        return null;
    }

    private static Boolean doGeneralLedgerEntry(dmpl__GeneralLedger__c ledgerEntry, dmpl__AccountBalance__c balanceEntry){
        balanceEntry.dmpl__Amount__c = (balanceEntry.dmpl__Amount__c == null ? 
            0 : balanceEntry.dmpl__Amount__c) 
            + (ledgerEntry.dmpl__Amount__c == null ? 
            0 : ledgerEntry.dmpl__Amount__c);
        return true;
    }

    @testvisible
    private static Boolean undoGeneralLedgerEntry(dmpl__GeneralLedger__c ledgerEntry, dmpl__AccountBalance__c balanceEntry)
    {
        balanceEntry.dmpl__Amount__c = (balanceEntry.dmpl__Amount__c == null ? 
            0 : balanceEntry.dmpl__Amount__c) 
            - (ledgerEntry.dmpl__Amount__c == null ? 
            0 : ledgerEntry.dmpl__Amount__c);
        return true;
    }

    private static dmpl__AccountBalance__c getAccountBalance(
        dmpl__GeneralLedger__c ledgerEntry, 
        List<dmpl__AccountBalance__c> loadedAccountBalances){
        for(dmpl__AccountBalance__c accountBalance : loadedAccountBalances){
            if(accountBalance.dmpl__PartnerAccountId__c == ledgerEntry.dmpl__PartnerAccountId__c 
                && accountBalance.dmpl__GLAccountId__c == ledgerEntry.dmpl__GLAccountId__c
                && accountBalance.dmpl__AccountId__c == ledgerEntry.dmpl__AccountId__c){
                    return accountBalance;
                }
        }
        return null;
    }

    private static dmpl__AccountBalance__c createAccountBalance(dmpl__GeneralLedger__c itemLedger)
    {
        dmpl__AccountBalance__c accountBalance = new dmpl__AccountBalance__c();
        accountBalance.dmpl__PartnerAccountId__c = itemLedger.dmpl__PartnerAccountId__c;
        accountBalance.dmpl__GLAccountId__c = itemLedger.dmpl__GLAccountId__c;
        accountBalance.dmpl__AccountId__c = itemLedger.dmpl__AccountId__c;
        return accountBalance;
    }

    private static List<dmpl__AccountBalance__c> getLedgerRelatedBalnces(
        List<dmpl__GeneralLedger__c> newLedgerEntries, 
        List<dmpl__GeneralLedger__c> oldLedgerEntries){
        List<Id> accountIds = new List<Id>();
        List<Id> partnerAccountIds = new List<Id>();
        List<Id> glAccountIds = new List<Id>();
        if(newLedgerEntries !=null){
            accountIds = CollectionHelper.extractIds(newLedgerEntries, 'dmpl__AccountId__c');
            glAccountIds = CollectionHelper.extractIds(newLedgerEntries, 'dmpl__GLAccountId__c');
        }
        if(oldLedgerEntries !=null){
            accountIds.addAll(CollectionHelper.extractIds(oldLedgerEntries, 'dmpl__AccountId__c'));
            glAccountIds.addAll(CollectionHelper.extractIds(oldLedgerEntries, 'dmpl__GLAccountId__c'));
        }
            
        return [
            SELECT Id, 
                dmpl__GLAccountId__c,
                dmpl__AccountId__c,
                dmpl__PartnerAccountId__c,
                dmpl__Amount__c
            FROM 
                dmpl__AccountBalance__c 
            WHERE 
                dmpl__GLAccountId__c IN :glAccountIds  
                AND (dmpl__AccountId__c IN :accountIds
                OR dmpl__AccountId__c = null)];
    }

    private static void throwDmplException(String message){
        throw new DMPLException(message);
    }
}