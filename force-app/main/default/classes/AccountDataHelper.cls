@isTest
public with sharing class AccountDataHelper {
    public static Account createPartnerAccount(
        String accountName
    ) {
        return (Account) TestFactory.createSObject(
            new Account(name = accountName),
            'PartnerAccountDefaults',
            true
        );
    }          

    public static Account createSupplierAccount(
        String accountName
    ) {
        return (Account) TestFactory.createSObject(
            new Account(name = accountName),
            'SupplierAccountDefaults',
            true
        );
    }

    public static Account createCustomerAccount(
        String accountName
    ) {
        return (Account) TestFactory.createSObject(
            new Account(name = accountName),
            'CustomerAccountDefaults',
            true
        );
    }

    public static dmpl__GLAccount__c createGLAccount(String name) {
    return (dmpl__GLAccount__c) TestFactory.createSObject(
        new dmpl__GLAccount__c(Name = name),
        'GLAccountDefaults',
        true
    );
   }

    public static List<Account> getAccounts(){
        List<Account> results = [
            SELECT Id, Name, Type
            FROM Account
        ];
        return results.isEmpty() ? null : results;
    }

    public static Account getAccountByName(String accountName){
        List<Account> results = [
            SELECT Id, Name, Type
            FROM Account
            WHERE Name = :accountName
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }

    public static Account getAccountById(id accountId){
        List<Account> results = [
            SELECT Id, Name, Type
            FROM Account
            WHERE Id = :accountId
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }

    public static dmpl__AccountGroup__c createAccountGroup(String accountGroupName) {
        return (dmpl__AccountGroup__c) TestFactory.createSObject(
            new dmpl__AccountGroup__c(
                Name = accountGroupName,
                dmpl__AccountGroupType__c = 'Scheme',
                dmpl__DynamicMemberType__c = 'Report Data',
                dmpl__ReportId__c = 'flow_screen_prebuilt_report',
                dmpl__RuleSuccessCriteria__c = 'Custom Logic Is Met',
                dmpl__RuleSuccessCustomLogic__c = 'Test'
            ),
            'AccountGroupDefaults',
            true
        );
    }

    public static dmpl__AccountGroup__c createAccountGroupWithDefaults() {
        return createAccountGroup('DefaultAccountGroup');
    }

    public static List<dmpl__AccountGroup__c> getAccountGroups() {
        List<dmpl__AccountGroup__c> results = [
            SELECT Id, Name, dmpl__AccountGroupType__c, dmpl__DynamicMemberType__c
            FROM dmpl__AccountGroup__c
        ];
        return results.isEmpty() ? null : results;
    }

    public static dmpl__AccountGroup__c getAccountGroupByName(String accountGroupName) {
        List<dmpl__AccountGroup__c> results = [
            SELECT Id, Name, dmpl__AccountGroupType__c, dmpl__DynamicMemberType__c
            FROM dmpl__AccountGroup__c
            WHERE Name = :accountGroupName
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }

    public static dmpl__AccountGroup__c getAccountGroupById(Id accountGroupId) {
        List<dmpl__AccountGroup__c> results = [
            SELECT Id, Name, dmpl__AccountGroupType__c, dmpl__DynamicMemberType__c
            FROM dmpl__AccountGroup__c
            WHERE Id = :accountGroupId
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }

    public static dmpl__AccountGroupRule__c createAccountGroupRule(
        Integer sequenceNumber,
        Id accountGroupId
    ){
        return (dmpl__AccountGroupRule__c) TestFactory.createSObject(
            new dmpl__AccountGroupRule__c(
                dmpl__SequenceNumber__c = sequenceNumber,
                dmpl__AccountGroupId__c = accountGroupId
            ),
            'AccountGroupRuleDefaults',
            true
        );
    }

    public static dmpl__AccountGroupRule__c createAccountGroupRuleWithDefaults(
        Id accountGroupId
    ){
        return createAccountGroupRule(1, accountGroupId);
    }

    public static List<dmpl__AccountGroupRule__c> getAccountGroupRules() {
        List<dmpl__AccountGroupRule__c> results = [
            SELECT Id, Name, dmpl__FieldName__c, dmpl__FieldValue__c, dmpl__Operation__c, dmpl__SequenceNumber__c
            FROM dmpl__AccountGroupRule__c
        ];
        return results.isEmpty() ? null : results;
    }

    public static dmpl__AccountGroupRule__c getAccountGroupRuleBySequenceNumber(
        Integer sequenceNumber
    ) {
        List<dmpl__AccountGroupRule__c> results = [
            SELECT Id, Name, dmpl__FieldName__c, dmpl__FieldValue__c, dmpl__Operation__c, dmpl__SequenceNumber__c
            FROM dmpl__AccountGroupRule__c
            WHERE dmpl__SequenceNumber__c = :sequenceNumber
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }

    public static dmpl__AccountGroupRule__c getAccountGroupRuleById(Id ruleId) {
        List<dmpl__AccountGroupRule__c> results = [
            SELECT Id, Name, dmpl__FieldName__c, dmpl__FieldValue__c, dmpl__Operation__c, dmpl__SequenceNumber__c
            FROM dmpl__AccountGroupRule__c
            WHERE Id = :ruleId
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }

    public static dmpl__AccountGroupMember__c createAccountGroupMember(
        Id accountGroupId,
        String batchInstanceId
    ) {
        return (dmpl__AccountGroupMember__c) TestFactory.createSObject(
            new dmpl__AccountGroupMember__c(
                dmpl__AccountGroupId__c = accountGroupId,
                dmpl__BatchInstanceId__c = batchInstanceId
            ),
            'AccountGroupMemberDefaults',
            true
        );
    }

    public static dmpl__AccountGroupMember__c createAccountGroupMemberWithDefaults(
        Id accountGroupId
    ) {
        return createAccountGroupMember(accountGroupId, 'TestBatchInstanceId');
    }

    public static List<dmpl__AccountGroupMember__c> getAccountGroupMembers() {
        List<dmpl__AccountGroupMember__c> results = [
            SELECT Id, dmpl__AccountGroupId__c, dmpl__BatchInstanceId__c
            FROM dmpl__AccountGroupMember__c
        ];
        return results.isEmpty() ? null : results;
    }

    public static dmpl__AccountGroupMember__c getAccountGroupMemberByBatchInstanceId(
        String batchInstanceId
    ) {
        List<dmpl__AccountGroupMember__c> results = [
            SELECT Id, dmpl__AccountGroupId__c, dmpl__BatchInstanceId__c
            FROM dmpl__AccountGroupMember__c
            WHERE dmpl__BatchInstanceId__c = :batchInstanceId
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }

    public static dmpl__AccountGroupMember__c getAccountGroupMemberById(Id memberId) {
        List<dmpl__AccountGroupMember__c> results = [
            SELECT Id, dmpl__AccountGroupId__c, dmpl__BatchInstanceId__c
            FROM dmpl__AccountGroupMember__c
            WHERE Id = :memberId
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }

    public static dmpl__AccountLocations__c createAccountLocation(
        String locationName
    ){
        return (dmpl__AccountLocations__c) TestFactory.createSObject(
            new dmpl__AccountLocations__c(
                Name = locationName
            ),
            'AccountLocationsDefaults',
            true
        );
    }

    public static dmpl__AccountLocations__c createAccountLocationWithDefaults()
    {
        return createAccountLocation('Default Location Name');
    }

    public static List<dmpl__AccountLocations__c> getAccountLocations() {
        List<dmpl__AccountLocations__c> results = [
            SELECT Id, Name, dmpl__LocationType__c, dmpl__isActive__c
            FROM dmpl__AccountLocations__c
        ];
        return results.isEmpty() ? null : results;
    }

    public static dmpl__AccountLocations__c getAccountLocationByName(
        String locationName
    ) {
        List<dmpl__AccountLocations__c> results = [
            SELECT Id, Name, dmpl__LocationType__c, dmpl__isActive__c
            FROM dmpl__AccountLocations__c
            WHERE Name = :locationName
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }

    public static dmpl__AccountLocations__c getAccountLocationById(Id locationId) {
        List<dmpl__AccountLocations__c> results = [
            SELECT Id, Name, dmpl__LocationType__c, dmpl__isActive__c
            FROM dmpl__AccountLocations__c
            WHERE Id = :locationId
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }

    public static dmpl__AccountRewardLedger__c createAccountRewardLedger(
        Id accountId,
        Integer rewardPoints
    ) {
        return (dmpl__AccountRewardLedger__c) TestFactory.createSObject(
            new dmpl__AccountRewardLedger__c(
                dmpl__AccountId__c = accountId,
                dmpl__RewardPoints__c = rewardPoints
            ),
            'AccountRewardLedgerDefaults',
            true
        );
    }

    public static dmpl__AccountRewardLedger__c createAccountRewardLedgerWithDefaults(
        Id accountId
    ) {
        return createAccountRewardLedger(accountId, 100);
    }

    public static List<dmpl__AccountRewardLedger__c> getAccountRewardLedgers() {
        List<dmpl__AccountRewardLedger__c> results = [
            SELECT Id, Name, dmpl__AccountId__c, dmpl__RewardPoints__c
            FROM dmpl__AccountRewardLedger__c
        ];
        return results.isEmpty() ? null : results;
    }

    public static dmpl__AccountRewardLedger__c getAccountRewardLedgerById(Id ledgerId) {
        List<dmpl__AccountRewardLedger__c> results = [
            SELECT Id, Name, dmpl__AccountId__c, dmpl__RewardPoints__c
            FROM dmpl__AccountRewardLedger__c
            WHERE Id = :ledgerId
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }

    public static dmpl__AccountRewardLedger__c getAccountRewardLedgerByRewardPoints(
        Integer rewardPoints
    ) {
        List<dmpl__AccountRewardLedger__c> results = [
            SELECT Id, Name, dmpl__AccountId__c, dmpl__RewardPoints__c
            FROM dmpl__AccountRewardLedger__c
            WHERE dmpl__RewardPoints__c = :rewardPoints
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }

    public static dmpl__AccountStock__c createAccountStock(
        Decimal quantity
    ){
        return (dmpl__AccountStock__c) TestFactory.createSObject(
            new dmpl__AccountStock__c(
                dmpl__Quantity__c = quantity
            ),
            'AccountStockDefaults',
            true
        );
    }

    public static dmpl__AccountStock__c createAccountStockWithDefaults() {
        return createAccountStock(1000);
    }

    public static List<dmpl__AccountStock__c> getAccountStocks() {
        List<dmpl__AccountStock__c> results = [
            SELECT Id, dmpl__Quantity__c
            FROM dmpl__AccountStock__c
        ];
        return results.isEmpty() ? null : results;
    }

    public static dmpl__AccountStock__c getAccountStockById(Id stockId) {
        List<dmpl__AccountStock__c> results = [
            SELECT Id, dmpl__Quantity__c
            FROM dmpl__AccountStock__c
            WHERE Id = :stockId
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }

    public static dmpl__AccountStock__c getAccountStockByQuantity(Decimal quantity) {
        List<dmpl__AccountStock__c> results = [
            SELECT Id, dmpl__Quantity__c
            FROM dmpl__AccountStock__c
            WHERE dmpl__Quantity__c = :quantity
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }

    public static dmpl__AccountUser__c createAccountUser(
        Id partnerAccountId,
        Date dateEffectiveFrom,
        Date dateEffectiveTill
    ) {
        return (dmpl__AccountUser__c) TestFactory.createSObject(
            new dmpl__AccountUser__c(
                dmpl__PartnerAccountId__c = partnerAccountId,
                dmpl__DateEffectiveFrom__c = dateEffectiveFrom,
                dmpl__DateEffectiveTill__c = dateEffectiveTill
            ),
            'AccountUserDefaults',
            true
        );
    }

    public static dmpl__AccountUser__c createAccountUserWithDefaults(Id partnerAccountId) {
        Date startDate = Date.newInstance(2025, 5, 1);
        Date endDate = Date.newInstance(2025, 5, 31);
        return createAccountUser(partnerAccountId, startDate, endDate);
    }

    public static List<dmpl__AccountUser__c> getAccountUsers() {
        List<dmpl__AccountUser__c> results = [
            SELECT Id, dmpl__PartnerAccountId__c, dmpl__DateEffectiveFrom__c, dmpl__DateEffectiveTill__c
            FROM dmpl__AccountUser__c
        ];
        return results.isEmpty() ? null : results;
    }

    public static dmpl__AccountUser__c getAccountUserById(Id userId) {
        List<dmpl__AccountUser__c> results = [
            SELECT Id, dmpl__PartnerAccountId__c, dmpl__DateEffectiveFrom__c, dmpl__DateEffectiveTill__c
            FROM dmpl__AccountUser__c
            WHERE Id = :userId
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }

    public static dmpl__AccountUser__c getAccountUserByEffectiveFromDate(
        Date effectiveFrom
    ) {
        List<dmpl__AccountUser__c> results = [
            SELECT Id, dmpl__PartnerAccountId__c, dmpl__DateEffectiveFrom__c, dmpl__DateEffectiveTill__c
            FROM dmpl__AccountUser__c
            WHERE dmpl__DateEffectiveFrom__c = :effectiveFrom
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }

    public static dmpl__AccountBalance__c createAccountBalance(
        Id GLAccountId,
        Decimal balanceAmount
    ) {
        return (dmpl__AccountBalance__c) TestFactory.createSObject(
            new dmpl__AccountBalance__c(
                dmpl__GLAccountId__c = GLAccountId,
                dmpl__Amount__c = balanceAmount
            ),
            'AccountBalanceDefaults',
            true
        );
    }

    public static dmpl__AccountBalance__c createAccountBalanceWithDefaults(
        Id GLAccountId
    ) {
        return createAccountBalance(GLAccountId, 1000);
    }

    public static List<dmpl__AccountBalance__c> getAccountBalances() {
        List<dmpl__AccountBalance__c> results = [
            SELECT Id, dmpl__GLAccountId__c, dmpl__Amount__c
            FROM dmpl__AccountBalance__c
        ];
        return results.isEmpty() ? null : results;
    }

    public static dmpl__AccountBalance__c getAccountBalanceById(Id balanceId) {
        List<dmpl__AccountBalance__c> results = [
            SELECT Id, dmpl__GLAccountId__c, dmpl__Amount__c
            FROM dmpl__AccountBalance__c
            WHERE Id = :balanceId
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }
    
    public static dmpl__AccountBalance__c getAccountBalanceByAmount(Decimal amount) {
        List<dmpl__AccountBalance__c> results = [
            SELECT Id, dmpl__GLAccountId__c, dmpl__Amount__c
            FROM dmpl__AccountBalance__c
            WHERE dmpl__Amount__c = :amount
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }
}