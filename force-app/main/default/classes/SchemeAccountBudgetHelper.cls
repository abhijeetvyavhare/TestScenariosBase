public class SchemeAccountBudgetHelper {

    public static void createAccountBudgetFromSchemeLedger(List<dmpl__SchemeLedger__c> schemeLedgers){
        List<dmpl__SchemeAccountBudget__c> accountBudgetsToUpdate = new List<dmpl__SchemeAccountBudget__c>();
        List<Id> schemeIds = DocumentHelper.extractIds(schemeLedgers, 'dmpl__SchemeId__c');
        List<Id> partnerAccountIds = DocumentHelper.extractIds(schemeLedgers, 'dmpl__PartnerAccountId__c');
        List<dmpl__AccountGroupMember__c> accountGroupMembers = querySchemeAccountGroupMembers(partnerAccountIds);
        List<Id> accountGroupIds = DocumentHelper.extractIds(accountGroupMembers, 'dmpl__AccountGroupId__c');
        List<dmpl__SchemeAccountBudget__c> schemeAccountBudgets = querySchemeAccountBudgets(partnerAccountIds, schemeIds, accountGroupIds);
        List<Id> saleInvoiceLineIds = new List<Id>();

        for(dmpl__SchemeLedger__c ledger : schemeLedgers)
        {
            List<dmpl__SchemeAccountBudget__c> schemeBudgets = CollectionHelper.getObjects(schemeAccountBudgets, 'dmpl__SchemeId__c', ledger.dmpl__SchemeId__c);

            dmpl__SchemeAccountBudget__c budget = (dmpl__SchemeAccountBudget__c) CollectionHelper.getObject(schemeBudgets,'dmpl__PartnerAccountId__c', ledger.dmpl__PartnerAccountId__c);
            if(budget != null)
            {
                if(accountBudgetsToUpdate.contains(budget))
                    budget = (dmpl__SchemeAccountBudget__c)CollectionHelper.getObject(accountBudgetsToUpdate, budget.Id);

                budget.dmpl__UtilizedAmount__c =  (budget.dmpl__UtilizedAmount__c == null ? 0 : budget.dmpl__UtilizedAmount__c) + (ledger.dmpl__Discount__c > 0 ? ledger.dmpl__NetSchemeDiscount__c : ledger.dmpl__DiscountAmount__c); 
                if(budget.dmpl__UtilizedAmount__c > budget.dmpl__BudgetAmount__c)
                {
                    ledger.dmpl__DiscountAmount__c = 0;
                    ledger.dmpl__SchemeLineId__c = null;
                    ledger.dmpl__SchemeId__c = null;
                    if(ledger.dmpl__SaleInvoiceLineId__c != null)
                        saleInvoiceLineIds.add(ledger.dmpl__SaleInvoiceLineId__c);
                    continue;
                //     ledger.addError('Scheme can not be applied as budget is not available.');
                }
                if(!accountBudgetsToUpdate.contains(budget))
                    accountBudgetsToUpdate.add(budget);
            }

            List<dmpl__AccountGroupMember__c> filteredAccountMembers = CollectionHelper.getObjects(accountGroupMembers, 'dmpl__AccountId__c', ledger.dmpl__PartnerAccountId__c);
            for(dmpl__AccountGroupMember__c groupmember : filteredAccountMembers)
            {
                budget = (dmpl__SchemeAccountBudget__c)CollectionHelper.getObject(schemeBudgets,'dmpl__PartnerAccountGroupId__c', groupmember.dmpl__AccountGroupId__c);
                if(budget != null)
                {
                    if(accountBudgetsToUpdate.contains(budget))
                        budget = (dmpl__SchemeAccountBudget__c)CollectionHelper.getObject(accountBudgetsToUpdate, budget.Id);

                        budget.dmpl__UtilizedAmount__c =  (budget.dmpl__UtilizedAmount__c == null ? 0 : budget.dmpl__UtilizedAmount__c) + (ledger.dmpl__Discount__c > 0 ? ledger.dmpl__NetSchemeDiscount__c : ledger.dmpl__DiscountAmount__c); 

                        if(budget.dmpl__UtilizedAmount__c > budget.dmpl__BudgetAmount__c)
                        {
                            ledger.dmpl__DiscountAmount__c = 0;
                            ledger.dmpl__SchemeLineId__c = null;
                            ledger.dmpl__SchemeId__c = null;
                            if(ledger.dmpl__SaleInvoiceLineId__c != null)
                                saleInvoiceLineIds.add(ledger.dmpl__SaleInvoiceLineId__c);
                            continue;
                        //     ledger.addError('Scheme can not be applied as budget is not available.');
                        }
                    if(!accountBudgetsToUpdate.contains(budget))
                        accountBudgetsToUpdate.add(budget);
                }
            }
        }
        if(saleInvoiceLineIds.size() > 0)
        {
            List<dmpl__SaleInvoiceLine__c> lines =  [Select Id,dmpl__SchemeDiscount__c,dmpl__SchemeDiscountAmount__c,dmpl__SchemeLineId__c From dmpl__SaleInvoiceLine__c Where Id In: saleInvoiceLineIds];
            for(dmpl__SaleInvoiceLine__c line : lines)
            {
                line.dmpl__SchemeDiscount__c = 0;
                line.dmpl__SchemeDiscountAmount__c = 0;
                line.dmpl__SchemeLineId__c = null;
            }
            if(lines.size() > 0)
                update lines;
        }
        if(accountBudgetsToUpdate.size() > 0)
            update accountBudgetsToUpdate;
    }

    public static void createAccountBudgetFromSchemeLedger(List<dmpl__SchemeLedger__c> schemeLedgers, List<dmpl__SchemeLedger__c> oldEntries){
        List<dmpl__SchemeAccountBudget__c> accountBudgetsToUpdate = new List<dmpl__SchemeAccountBudget__c>();
        List<Id> schemeIds = DocumentHelper.extractIds(schemeLedgers, 'dmpl__SchemeId__c');
        List<Id> partnerAccountIds = DocumentHelper.extractIds(schemeLedgers, 'dmpl__PartnerAccountId__c');
        List<dmpl__AccountGroupMember__c> accountGroupMembers = querySchemeAccountGroupMembers(partnerAccountIds);
        List<Id> accountGroupIds = DocumentHelper.extractIds(accountGroupMembers, 'dmpl__AccountGroupId__c');
        List<dmpl__SchemeAccountBudget__c> schemeAccountBudgets = querySchemeAccountBudgets(partnerAccountIds, schemeIds, accountGroupIds);

        List<Id> saleInvoiceLineIds = new List<Id>();
        for(dmpl__SchemeLedger__c ledger : schemeLedgers)
        {
            List<dmpl__SchemeAccountBudget__c> schemeBudgets = CollectionHelper.getObjects(schemeAccountBudgets, 'dmpl__SchemeId__c', ledger.dmpl__SchemeId__c);
            dmpl__SchemeAccountBudget__c budget = (dmpl__SchemeAccountBudget__c) CollectionHelper.getObject(schemeBudgets,'dmpl__PartnerAccountId__c', ledger.dmpl__PartnerAccountId__c);
            Decimal discountAmount = 0;
            dmpl__SchemeLedger__c  oldEntry = (dmpl__SchemeLedger__c)DocumentHelper.getObjectByFilter(oldEntries, 'Id', ledger.Id);

            if(oldEntry.dmpl__DiscountAmount__c != ledger.dmpl__DiscountAmount__c)
                discountAmount = (ledger.dmpl__DiscountAmount__c > 0 ? ledger.dmpl__DiscountAmount__c : 0) 
                                    - (oldEntry.dmpl__DiscountAmount__c > 0 ? oldEntry.dmpl__DiscountAmount__c : 0);

            if(oldEntry.dmpl__Discount__c != ledger.dmpl__Discount__c)
                discountAmount = discountAmount + (
                    (ledger.dmpl__Discount__c > 0 ? ledger.dmpl__NetSchemeDiscount__c  : 0) 
                        - (oldEntry.dmpl__Discount__c > 0 ? ledger.dmpl__NetSchemeDiscount__c  : 0)
                        );

            if(oldEntry.dmpl__LineAmount__c != ledger.dmpl__LineAmount__c)
                discountAmount = discountAmount + (ledger.dmpl__NetSchemeDiscount__c  - ledger.dmpl__NetSchemeDiscount__c );
                
            if(budget != null)
            {
                
                if(accountBudgetsToUpdate.contains(budget))
                    budget = (dmpl__SchemeAccountBudget__c)CollectionHelper.getObject(accountBudgetsToUpdate, budget.Id);

                budget.dmpl__UtilizedAmount__c =  (budget.dmpl__UtilizedAmount__c == null ? 0 : budget.dmpl__UtilizedAmount__c) + discountAmount;
                if(budget.dmpl__UtilizedAmount__c > budget.dmpl__BudgetAmount__c){
                    ledger.dmpl__DiscountAmount__c = 0;
                    ledger.dmpl__SchemeLineId__c = NULL;
                    ledger.dmpl__SchemeId__c = NULL;
                    if(ledger.dmpl__SaleInvoiceLineId__c != null)
                        saleInvoiceLineIds.add(ledger.dmpl__SaleInvoiceLineId__c);
                    continue;
                }
                //     ledger.addError('Scheme can not be applied as budget is not available.');
                if(!accountBudgetsToUpdate.contains(budget))
                    accountBudgetsToUpdate.add(budget);
            }

            List<dmpl__AccountGroupMember__c> filteredAccountMembers = CollectionHelper.getObjects(accountGroupMembers, 'dmpl__AccountId__c', ledger.dmpl__PartnerAccountId__c);
            for(dmpl__AccountGroupMember__c groupmember : filteredAccountMembers)
            {
                budget = (dmpl__SchemeAccountBudget__c)CollectionHelper.getObject(schemeBudgets,'dmpl__PartnerAccountGroupId__c', groupmember.dmpl__AccountGroupId__c);
                if(budget != null)
                {
                    if(accountBudgetsToUpdate.contains(budget))
                        budget = (dmpl__SchemeAccountBudget__c)CollectionHelper.getObject(accountBudgetsToUpdate, budget.Id);

                    budget.dmpl__UtilizedAmount__c =  (budget.dmpl__UtilizedAmount__c == null ? 0 : budget.dmpl__UtilizedAmount__c) + discountAmount; 
                    if(budget.dmpl__UtilizedAmount__c > budget.dmpl__BudgetAmount__c)
                    {
                        ledger.dmpl__DiscountAmount__c = 0;
                        ledger.dmpl__SchemeLineId__c = NULL;
                        ledger.dmpl__SchemeId__c = NULL;
                        if(ledger.dmpl__SaleInvoiceLineId__c != null)
                            saleInvoiceLineIds.add(ledger.dmpl__SaleInvoiceLineId__c);
                        continue;
                    }
                    //     ledger.addError('Scheme can not be applied as budget is not available.');
                    if(!accountBudgetsToUpdate.contains(budget))
                        accountBudgetsToUpdate.add(budget);
                }
            }
        }

        if(saleInvoiceLineIds.size() > 0)
        {
            List<dmpl__SaleInvoiceLine__c> lines =  [Select Id,dmpl__SchemeDiscount__c,dmpl__SchemeDiscountAmount__c,dmpl__SchemeLineId__c From dmpl__SaleInvoiceLine__c Where Id In: saleInvoiceLineIds];
            for(dmpl__SaleInvoiceLine__c line : lines)
            {
                line.dmpl__SchemeDiscount__c = 0;
                line.dmpl__SchemeDiscountAmount__c = 0;
                line.dmpl__SchemeLineId__c = null;
            }
            if(lines.size() > 0)
                update lines;
        }
        if(accountBudgetsToUpdate.size() > 0)
            update accountBudgetsToUpdate;
    }



    public static void removeAccountBudgetFromSchemeLedger(List<dmpl__SchemeLedger__c> schemeLedgers){
        List<dmpl__SchemeAccountBudget__c> accountBudgetsToUpdate = new List<dmpl__SchemeAccountBudget__c>();
        List<Id> schemeIds = DocumentHelper.extractIds(schemeLedgers, 'dmpl__SchemeId__c');
        List<Id> partnerAccountIds = DocumentHelper.extractIds(schemeLedgers, 'dmpl__PartnerAccountId__c');
        List<dmpl__AccountGroupMember__c> accountGroupMembers = querySchemeAccountGroupMembers(partnerAccountIds);
        List<Id> accountGroupIds = DocumentHelper.extractIds(accountGroupMembers, 'dmpl__AccountGroupId__c');
        List<dmpl__SchemeAccountBudget__c> schemeAccountBudgets = querySchemeAccountBudgets(partnerAccountIds, schemeIds, accountGroupIds);

        for(dmpl__SchemeLedger__c ledger : schemeLedgers)
        {
            List<dmpl__SchemeAccountBudget__c> schemeBudgets = CollectionHelper.getObjects(schemeAccountBudgets, 'dmpl__SchemeId__c', ledger.dmpl__SchemeId__c);

            dmpl__SchemeAccountBudget__c budget = (dmpl__SchemeAccountBudget__c) CollectionHelper.getObject(schemeBudgets,'dmpl__PartnerAccountId__c', ledger.dmpl__PartnerAccountId__c);
            if(budget != null)
            {
                if(accountBudgetsToUpdate.contains(budget))
                    budget = (dmpl__SchemeAccountBudget__c)CollectionHelper.getObject(accountBudgetsToUpdate, budget.Id);

                budget.dmpl__UtilizedAmount__c =  (budget.dmpl__UtilizedAmount__c == null ? 0 : budget.dmpl__UtilizedAmount__c) - (ledger.dmpl__Discount__c > 0 ? (ledger.dmpl__Discount__c * ledger.dmpl__LineAmount__c/ 100) : ledger.dmpl__DiscountAmount__c); 
               // budget.dmpl__UtilizedAmount__c =  (budget.dmpl__UtilizedAmount__c == null ? 0 : budget.dmpl__UtilizedAmount__c) - (ledger.dmpl__Discount__c > 0 ? ledger.dmpl__NetSchemeDiscount__c : ledger.dmpl__DiscountAmount__c); 
                if(!accountBudgetsToUpdate.contains(budget))
                    accountBudgetsToUpdate.add(budget);
            }

            List<dmpl__AccountGroupMember__c> filteredAccountMembers = CollectionHelper.getObjects(accountGroupMembers, 'dmpl__AccountId__c', ledger.dmpl__PartnerAccountId__c);
            for(dmpl__AccountGroupMember__c groupmember : filteredAccountMembers)
            {
                budget = (dmpl__SchemeAccountBudget__c)CollectionHelper.getObject(schemeBudgets,'dmpl__PartnerAccountGroupId__c', groupmember.dmpl__AccountGroupId__c);
                if(budget != null)
                {
                    if(accountBudgetsToUpdate.contains(budget))
                        budget = (dmpl__SchemeAccountBudget__c)CollectionHelper.getObject(accountBudgetsToUpdate, budget.Id);

                        // budget.dmpl__UtilizedAmount__c =  (budget.dmpl__UtilizedAmount__c == null ? 0 : budget.dmpl__UtilizedAmount__c) - (ledger.dmpl__Discount__c > 0 ? (ledger.dmpl__Discount__c * ledger.dmpl__LineAmount__c/ 100) : ledger.dmpl__DiscountAmount__c); 
                        budget.dmpl__UtilizedAmount__c =  (budget.dmpl__UtilizedAmount__c == null ? 0 : budget.dmpl__UtilizedAmount__c) - (ledger.dmpl__Discount__c > 0 ? ledger.dmpl__NetSchemeDiscount__c : ledger.dmpl__DiscountAmount__c); 
                    if(!accountBudgetsToUpdate.contains(budget))
                        accountBudgetsToUpdate.add(budget);
                }
            }
        }

        if(accountBudgetsToUpdate.size() > 0)
            update accountBudgetsToUpdate;
    }


    private static List<dmpl__AccountGroupMember__c> querySchemeAccountGroupMembers(
        List<ID> partnerAccountIds)
    {
        SecurityHelper.ensureCanReadFields(new List<String>
        {
            'dmpl__AccountGroupType__c'
        },'dmpl__AccountGroup__c');

        SecurityHelper.ensureCanReadFields(new List<String>
        {
            'dmpl__AccountId__c',
            'dmpl__AccountGroupId__c'
        },'dmpl__AccountGroupMember__c');

        return [ SELECT ID, 
            dmpl__AccountId__c,
            dmpl__AccountGroupId__c
        FROM dmpl__AccountGroupMember__c
        WHERE dmpl__AccountId__c IN : partnerAccountIds
        AND dmpl__AccountGroupId__r.dmpl__AccountGroupType__c = 'Scheme'];
    }    

    private static List<dmpl__SchemeAccountBudget__c> querySchemeAccountBudgets(
        List<ID> partnerAccountIds, List<ID> schemeIds, List<ID> partnerAccountGroupIds)
    {
        SecurityHelper.ensureCanReadFields(new List<String>
        {
            'dmpl__BudgetAmount__c',
            'dmpl__PartnerAccountId__c',
            'dmpl__PartnerAccountGroupId__c',
            'dmpl__SchemeId__c',
            'dmpl__UtilizedAmount__c'
        },'dmpl__SchemeAccountBudget__c');

        return [SELECT ID, 
            dmpl__BudgetAmount__c,
            dmpl__PartnerAccountId__c,
            dmpl__PartnerAccountGroupId__c,
            dmpl__SchemeId__c,
            dmpl__UtilizedAmount__c
        FROM dmpl__SchemeAccountBudget__c
        WHERE dmpl__SchemeId__c IN : schemeIds
        AND (dmpl__PartnerAccountId__c IN : partnerAccountIds
        OR dmpl__PartnerAccountGroupId__c IN : partnerAccountGroupIds)];
    }    
    
}