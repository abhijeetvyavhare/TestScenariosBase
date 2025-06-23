@namespaceAccessible
public without sharing class ValidationHelper {
 
    private static String FIELDNAME_ISACTIVE = 'dmpl__IsActive__c';

    @namespaceAccessible
    public static void validatePartnerAndBranch(
        String partnerAccountFieldName, 
        String branchFieldName, 
        List<SObject> newEntries){
        List<Account> accounts = AccountHelper.getCachedDealerAccounts(
            DocumentHelper.extractIds(
                newEntries, 
                partnerAccountFieldName));
        for(SObject entry : newEntries){
            Account account = (Account)DocumentHelper.getObject(
                accounts, 
                (String)entry.get(partnerAccountFieldName));
            if(account==null){
                entry.addError(
                    System.Label.Validation_InvalidPartnerAccount);
            }else if(!account.dmpl__IsActive__c){
                entry.addError(
                    System.Label.Validation_InactivePartnerAccount);
            }else{
                dmpl__Branch__c branch= (dmpl__Branch__c)DocumentHelper.getObject(
                    account.dmpl__Branches__r, 
                    (String)entry.get(branchFieldName));
                if(branch == null){
                    entry.addError(
                        System.Label.Validation_InvalidBranch);
                }else if(!branch.dmpl__IsActive__c){
                    entry.addError(
                        System.Label.Validation_InactiveBranch);
                }
            }
        }
    }

    @namespaceAccessible
    public static void validateItemOrItemGroup(
        String itemFieldName, 
        String itemGroupFieldName, 
        List<SObject> newEntries){
        for(SObject entry : newEntries){
            if(entry.get(itemFieldName)!=null 
                && entry.get(itemGroupFieldName)!=null){
                entry.addError(
                    System.Label.Validation_EitherItemOrItemGroup);
            }
        }
    }

    @namespaceAccessible
    public static void validateAccountOrAccountGroup(
        String accountFieldName, 
        String accountGroupFieldName, 
        List<SObject> newEntries){
        for(SObject entry : newEntries){
            if(entry.get(accountFieldName)!=null 
                && entry.get(accountGroupFieldName)!=null){
                entry.addError(
                    System.Label.Validation_EitherAccountOrAccountGroup);
            }
        }
    }

    @namespaceAccessible
    public static void validateValidPercent(
        String percentFieldName, 
        List<SObject> newEntries){
        for(SObject entry : newEntries){
            if(entry.get(percentFieldName) !=null 
                && (
                    ((Decimal)entry.get(percentFieldName)) < 0
                    || ((Decimal)entry.get(percentFieldName)) > 100
                    )){
                entry.addError(String.format(
                    String.valueOf(System.Label.Validation_ValidPercentExpected), 
                    new String[]
                    {
                        percentFieldName
                    }));
            }
        }
    }

    @namespaceAccessible
    public static void validateValidPercent(
        List<String> percentFieldNames, 
        List<SObject> newEntries){
        for(SObject entry : newEntries){
            for(String percentFieldName : percentFieldNames){
                if(entry.get(percentFieldName) !=null 
                    && (((Decimal)entry.get(percentFieldName)) < 0
                        || ((Decimal)entry.get(percentFieldName)) > 100)){
                entry.addError(String.format(
                    String.valueOf(System.Label.Validation_ValidPercentExpected), 
                    new String[]
                    {
                        percentFieldName
                    }));
                }
            }
        }
    }

    @namespaceAccessible
    public static void validatePostiveNumber(
        String numberFieldName, 
        List<SObject> newEntries){
        for(SObject entry : newEntries){
            if(entry.get(numberFieldName) !=null 
                && ((Integer)entry.get(numberFieldName)) <= 0){
                entry.addError(String.format(
                    String.valueOf(System.Label.Validation_PostiveNumberExpected), 
                    new String[]
                    {
                        numberFieldName
                    }));
            }
        }
    }

    @namespaceAccessible
    public static void validatePostiveNumber(
        List<String> numberFieldNames, 
        List<SObject> newEntries){
        for(SObject entry : newEntries){
            String rowError = '';
            for(String numberFieldName : numberFieldNames){
                if(entry.get(numberFieldName) !=null 
                    && ((Integer)entry.get(numberFieldName)) <= 0){
                    rowError += String.format(
                        String.valueOf(System.Label.Validation_PostiveNumberExpected), 
                        new String[]
                        {
                            numberFieldName
                        });
                }
            }
            if(String.isNotBlank(rowError)){
                entry.addError(rowError);
            }
        }
    }

    @namespaceAccessible
    public static void validatePostiveOrZeroNumber(
        String numberFieldName, 
        List<SObject> newEntries){
        for(SObject entry : newEntries){
            if(entry.get(numberFieldName) !=null 
                && ((Integer)entry.get(numberFieldName)) < 0){
                entry.addError(String.format(
                    String.valueOf(System.Label.Validation_PostiveNumberExpected), 
                    new String[]
                    {
                        numberFieldName
                    }));
            }
        }
    }

    @namespaceAccessible
    public static void validatePostiveOrZeroNumber(
        List<String> numberFieldNames, 
        List<SObject> newEntries){
        for(SObject entry : newEntries){
            String rowError = '';
            for(String numberFieldName : numberFieldNames){
                if(entry.get(numberFieldName) !=null 
                    && ((Integer)entry.get(numberFieldName)) < 0){
                        rowError += String.format(
                        String.valueOf(System.Label.Validation_PostiveNumberExpected), 
                        new String[]
                        {
                            numberFieldName
                        });
                }
            }
            if(String.isNotBlank(rowError)){
                entry.addError(rowError);
            }
        }
    }


    @namespaceAccessible
    public static void validateNonZeroNumber(
        String numberFieldName, 
        List<SObject> newEntries){
        for(SObject entry : newEntries){
            if(entry.get(numberFieldName) !=null 
                && ((Integer)entry.get(numberFieldName)) == 0){
                entry.addError(String.format(
                    String.valueOf(System.Label.Validation_PostiveNumberExpected), 
                    new String[]
                    {
                        numberFieldName
                    }));
            }
        }
    }

    @namespaceAccessible
    public static void validateNonZeroNumber(
        List<String> numberFieldNames, 
        List<SObject> newEntries){
        for(SObject entry : newEntries){
            String rowError = '';
            for(String numberFieldName : numberFieldNames){
                if(entry.get(numberFieldName) !=null 
                    && ((Integer)entry.get(numberFieldName)) == 0){
                        rowError += String.format(
                        String.valueOf(System.Label.Validation_PostiveNumberExpected), 
                        new String[]
                        {
                            numberFieldName
                        });
                }
            }
            if(String.isNotBlank(rowError)){
                entry.addError(rowError);
            }
        }
    }

    @namespaceAccessible
    public static void validatePostiveDecimal(
        String decimalFieldName, 
        List<SObject> newEntries){
        for(SObject entry : newEntries){
            if(entry.get(decimalFieldName) !=null 
                && ((Decimal)entry.get(decimalFieldName)) <= 0){
                entry.addError(String.format(
                    String.valueOf(
                    System.Label.Validation_PostiveDecimalExpected), 
                    new String[]
                    {
                        decimalFieldName
                    }));
            }
        }
    }

    @namespaceAccessible
    public static void validatePostiveDecimal(
        List<String> decimalFieldNames, 
        List<SObject> newEntries){
        for(SObject entry : newEntries){
            String rowError = '';
            for(String decimalFieldName : decimalFieldNames){
                if(entry.get(decimalFieldName) !=null 
                    && ((Decimal)entry.get(decimalFieldName)) <= 0){
                        rowError += String.format(
                            String.valueOf(
                            System.Label.Validation_PostiveDecimalExpected), 
                            new String[]
                            {
                                decimalFieldName
                            });
                }
            }
            if(String.isNotBlank(rowError)){
                entry.addError(rowError);
            }
        }
    }

    @namespaceAccessible
    public static void validatePostiveOrZeroDecimal(
        String decimalFieldName, 
        List<SObject> newEntries){
        for(SObject entry : newEntries){
            if(entry.get(decimalFieldName) !=null 
                && ((Decimal)entry.get(decimalFieldName)) < 0){
                entry.addError(String.format(
                    String.valueOf(
                    System.Label.Validation_PostiveDecimalExpected), 
                    new String[]
                    {
                        decimalFieldName
                    }));
            }
        }
    }

    @namespaceAccessible
    public static void validatePostiveOrZeroDecimal(
        List<String> decimalFieldNames, 
        List<SObject> newEntries){
        for(SObject entry : newEntries){
            String rowError = '';
            for(String decimalFieldName : decimalFieldNames){
                if(entry.get(decimalFieldName) !=null 
                    && ((Decimal)entry.get(decimalFieldName)) < 0){
                        rowError += String.format(
                        String.valueOf(
                        System.Label.Validation_PostiveDecimalExpected), 
                        new String[]
                        {
                            decimalFieldName
                        });
                }
            }
            if(String.isNotBlank(rowError)){
                entry.addError(rowError);
            }
        }
    }

    @namespaceAccessible
    public static void validateNonZeroDecimal(
        String decimalFieldName, 
        List<SObject> newEntries){
        for(SObject entry : newEntries){
            if(entry.get(decimalFieldName) !=null 
                && ((Decimal)entry.get(decimalFieldName)) == 0){
                entry.addError(String.format(
                    String.valueOf(
                    System.Label.Validation_PostiveDecimalExpected), 
                    new String[]
                    {
                        decimalFieldName
                    }));
            }
        }
    }

    @namespaceAccessible
    public static void validateNonZeroDecimal(
        List<String> decimalFieldNames, 
        List<SObject> newEntries){
        for(SObject entry : newEntries){
            String rowError = '';
            for(String decimalFieldName : decimalFieldNames){
                if(entry.get(decimalFieldName) !=null 
                    && ((Decimal)entry.get(decimalFieldName)) == 0){
                        rowError += String.format(
                        String.valueOf(
                        System.Label.Validation_PostiveDecimalExpected), 
                        new String[]
                        {
                            decimalFieldName
                        });
                }
            }
            if(String.isNotBlank(rowError)){
                entry.addError(rowError);
            }
        }
    }

    @namespaceAccessible
    public static void validateIncrementalNumbers(
        String firstNumberFieldName, 
        String secondNumberFieldName, 
        List<SObject> newEntries){
        for(SObject entry : newEntries){
            if(entry.get(firstNumberFieldName) !=null 
                && entry.get(secondNumberFieldName) !=null 
                && ((Integer)entry.get(firstNumberFieldName)) > ((Integer)entry.get(secondNumberFieldName))){
                entry.addError(String.format(
                    String.valueOf(
                    System.Label.Validation_IncrementalNumbersExpected), 
                    new String[]
                    {
                        secondNumberFieldName,
                        firstNumberFieldName
                    }));
            }
        }
    }
    
    @namespaceAccessible
    public static void validateIncrementalDecimals(
        String firstDecimalFieldName, 
        String secondDecimalFieldName, 
        List<SObject> newEntries){
        for(SObject entry : newEntries){
            if(entry.get(firstDecimalFieldName) !=null 
                && entry.get(secondDecimalFieldName) !=null 
                && ((Decimal)entry.get(firstDecimalFieldName)) > ((Decimal)entry.get(secondDecimalFieldName))){
                entry.addError(String.format(
                    String.valueOf(
                    System.Label.Validation_IncrementalDecimalExpected), 
                    new String[]
                    {
                        secondDecimalFieldName,
                        firstDecimalFieldName
                    }));
            }
        }
    }   

    @namespaceAccessible
    public static void validateIncrementalDates(
        String firstDateFieldName, 
        String secondDateFieldName, 
        List<SObject> newEntries){
        for(SObject entry : newEntries){
            if(entry.get(firstDateFieldName) !=null 
                && entry.get(secondDateFieldName) !=null 
                && ((Date)(entry.get(firstDateFieldName)) > ((Date)(entry.get(secondDateFieldName))))){
                entry.addError(String.format(
                    String.valueOf(
                    System.Label.Validation_IncrementalDatesExpected), 
                    new String[]
                    {
                        secondDateFieldName,
                        firstDateFieldName
                    }));
            }
        }
    }
    
    @namespaceAccessible
    public static void validateResource(
        String resourceFieldAPI, 
        List<SObject> newEntries){
            (new ResourceService()).validateResource(
                resourceFieldAPI, 
                newEntries);
    }
}