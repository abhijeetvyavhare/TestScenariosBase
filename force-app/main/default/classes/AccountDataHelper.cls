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

    public static dmpl__GLAccount__c createGLAccount(
        String glAccountName,
        String glAccountType,
        Boolean isActive,
        Id partnerAccountId,
        Id branchId
    ){
        return (dmpl__GLAccount__c) TestFactory.createSObject(
            new dmpl__GLAccount__c(
                Name = glAccountName,
                dmpl__AccountType__c = glAccountType,
                dmpl__IsActive__c = isActive,
                dmpl__PartnerAccountId__c = partnerAccountId,
                dmpl__BranchId__c = branchId
            ),
            'GLAccountDefaults',
            true
        );
    }

        public static dmpl__AccountGroupMember__c createAccountGroupMember(
        Id accountGroupId,
        Id accountId,
        String batchInstanceId
    ) {
        return (dmpl__AccountGroupMember__c) TestFactory.createSObject(
            new dmpl__AccountGroupMember__c(
                dmpl__AccountGroupId__c = accountGroupId,
                dmpl__AccountId__c = accountId,
                dmpl__BatchInstanceId__c = batchInstanceId
            ),
            'AccountGroupMemberDefaults',
            true
        );
    }

    
    public static dmpl__GLAccount__c getGLAccountByName(String glAccountName) {
        List<dmpl__GLAccount__c> results = [
            SELECT Id, Name, dmpl__AccountType__c, dmpl__IsActive__c, dmpl__PartnerAccountId__c, dmpl__BranchId__c
            FROM dmpl__GLAccount__c
            WHERE Name = :glAccountName
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
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

    public static dmpl__AccountGroup__c createAccountGroup(
        String accountGroupName,
        String accountGroupType,
        String dynamicMemberType,
        String ruleSuccessCriteria,
        String ruleSuccessCustomLogic
    ){
        return (dmpl__AccountGroup__c) TestFactory.createSObject(
            new dmpl__AccountGroup__c(
                Name = accountGroupName,
                dmpl__AccountGroupType__c = accountGroupType,
                dmpl__DynamicMemberType__c = dynamicMemberType,
                dmpl__RuleSuccessCriteria__c = ruleSuccessCriteria,
                dmpl__RuleSuccessCustomLogic__c = ruleSuccessCustomLogic
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
            SELECT Id, Name, dmpl__AccountGroupType__c, dmpl__DynamicMemberType__c,
                dmpl__RuleSuccessCriteria__c, dmpl__RuleSuccessCustomLogic__c
            FROM dmpl__AccountGroup__c
        ];
        return results.isEmpty() ? null : results;
    }

    public static dmpl__AccountGroup__c getAccountGroupByName(String accountGroupName) {
        List<dmpl__AccountGroup__c> results = [
            SELECT Id, Name, dmpl__AccountGroupType__c, dmpl__DynamicMemberType__c,
                dmpl__RuleSuccessCriteria__c, dmpl__RuleSuccessCustomLogic__c
            FROM dmpl__AccountGroup__c
            WHERE Name = :accountGroupName
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }

    public static dmpl__AccountGroup__c getAccountGroupById(Id accountGroupId) {
        List<dmpl__AccountGroup__c> results = [
            SELECT Id, Name, dmpl__AccountGroupType__c, dmpl__DynamicMemberType__c,
                dmpl__RuleSuccessCriteria__c, dmpl__RuleSuccessCustomLogic__c
            FROM dmpl__AccountGroup__c
            WHERE Id = :accountGroupId
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }

    public static dmpl__AccountGroupRule__c createAccountGroupRule(
        Decimal sequenceNumber,
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

    public static dmpl__AccountGroupRule__c createAccountGroupRule(
        Id accountGroupId,
        Decimal sequenceNumber,
        String fieldName,
        String fieldValue,
        String operation
    ){
        return (dmpl__AccountGroupRule__c) TestFactory.createSObject(
            new dmpl__AccountGroupRule__c(
                dmpl__SequenceNumber__c = sequenceNumber,
                dmpl__AccountGroupId__c = accountGroupId,
                dmpl__FieldName__c = fieldName,
                dmpl__FieldValue__c = fieldValue,
                dmpl__Operation__c = operation
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
            SELECT Id, Name, dmpl__FieldName__c, dmpl__FieldValue__c, dmpl__Operation__c, dmpl__SequenceNumber__c, dmpl__AccountGroupId__c
            FROM dmpl__AccountGroupRule__c
        ];
        return results.isEmpty() ? null : results;
    }

    public static dmpl__AccountGroupRule__c getAccountGroupRuleBySequenceNumber(
        Integer sequenceNumber
    ) {
        List<dmpl__AccountGroupRule__c> results = [
            SELECT Id, Name, dmpl__FieldName__c, dmpl__FieldValue__c, dmpl__Operation__c, dmpl__SequenceNumber__c, dmpl__AccountGroupId__c
            FROM dmpl__AccountGroupRule__c
            WHERE dmpl__SequenceNumber__c = :sequenceNumber
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }

    public static dmpl__AccountGroupRule__c getAccountGroupRuleById(Id ruleId) {
        List<dmpl__AccountGroupRule__c> results = [
            SELECT Id, Name, dmpl__FieldName__c, dmpl__FieldValue__c, dmpl__Operation__c, dmpl__SequenceNumber__c, dmpl__AccountGroupId__c,
                    CreatedById, LastModifiedById
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
            SELECT Id, dmpl__AccountGroupId__c, dmpl__BatchInstanceId__c, dmpl__AccountId__c
            FROM dmpl__AccountGroupMember__c
        ];
        return results.isEmpty() ? null : results;
    }

    public static dmpl__AccountGroupMember__c getAccountGroupMemberByBatchInstanceId(
        String batchInstanceId
    ) {
        List<dmpl__AccountGroupMember__c> results = [
            SELECT Id, dmpl__AccountGroupId__c, dmpl__BatchInstanceId__c, dmpl__AccountId__c
            FROM dmpl__AccountGroupMember__c
            WHERE dmpl__BatchInstanceId__c = :batchInstanceId
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }

    public static dmpl__AccountGroupMember__c getAccountGroupMemberById(Id memberId) {
        List<dmpl__AccountGroupMember__c> results = [
            SELECT Id, dmpl__AccountGroupId__c, dmpl__BatchInstanceId__c, dmpl__AccountId__c
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

    public static dmpl__AccountLocations__c createAccountLocation(
        String locationName,
        Id accountId,
        String channel,
        String locationType,
        Boolean isActive,
        Boolean allowInventory,
        Decimal latitude,
        Decimal longitude
    ) {
        return (dmpl__AccountLocations__c) TestFactory.createSObject(
            new dmpl__AccountLocations__c(
                Name = locationName,
                dmpl__AccountId__c = accountId,
                dmpl__Channel__c = channel,
                dmpl__LocationType__c = locationType,
                dmpl__IsActive__c = isActive,
                dmpl__AllowInventory__c = allowInventory,
                dmpl__GeoLocation__Latitude__s = latitude,
                dmpl__GeoLocation__Longitude__s = longitude
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
            SELECT Id,
                Name,
                dmpl__AccountId__c,
                dmpl__Channel__c,
                dmpl__LocationType__c,
                dmpl__IsActive__c,
                dmpl__AllowInventory__c,
                dmpl__GeoLocation__Latitude__s,
                dmpl__GeoLocation__Longitude__s,
                LastModifiedById,
                CreatedById
            FROM dmpl__AccountLocations__c
        ];
        return results.isEmpty() ? null : results;
    }

    public static dmpl__AccountLocations__c getAccountLocationByName(String locationName) {
        List<dmpl__AccountLocations__c> results = [
            SELECT Id,
                Name,
                dmpl__AccountId__c,
                dmpl__Channel__c,
                dmpl__LocationType__c,
                dmpl__IsActive__c,
                dmpl__AllowInventory__c,
                dmpl__GeoLocation__Latitude__s,
                dmpl__GeoLocation__Longitude__s,
                LastModifiedById,
                CreatedById
            FROM dmpl__AccountLocations__c
            WHERE Name = :locationName
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }

    public static dmpl__AccountLocations__c getAccountLocationById(Id locationId) {
        List<dmpl__AccountLocations__c> results = [
            SELECT Id,
                Name,
                dmpl__AccountId__c,
                dmpl__Channel__c,
                dmpl__LocationType__c,
                dmpl__IsActive__c,
                dmpl__AllowInventory__c,
                dmpl__GeoLocation__Latitude__s,
                dmpl__GeoLocation__Longitude__s,
                LastModifiedById,
                CreatedById
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

    public static dmpl__AccountRewardLedger__c createAccountRewardLedger(
        Id accountId,
        Id discountVoucherId,
        Id schemeLedgerId,
        Id incentiveCompensationLine,
        Integer rewardPoints,
        Date documentDate
    ) {
        return (dmpl__AccountRewardLedger__c) TestFactory.createSObject(
            new dmpl__AccountRewardLedger__c(
                dmpl__AccountId__c = accountId,
                dmpl__DiscountVoucherId__c = discountVoucherId,
                dmpl__SchemeLedgerId__c = schemeLedgerId,
                dmpl__IncentiveCompensationLineId__c = incentiveCompensationLine,
                dmpl__RewardPoints__c = rewardPoints,
                dmpl__DocumentDate__c = documentDate
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
            SELECT Id, Name, CreatedById, LastModifiedById,
                dmpl__AccountId__c, dmpl__DiscountVoucherId__c, dmpl__SchemeLedgerId__c,
                dmpl__IncentiveCompensationLineId__c, dmpl__RewardPoints__c, dmpl__DocumentDate__c
            FROM dmpl__AccountRewardLedger__c
        ];
        return results.isEmpty() ? null : results;
    }

    public static dmpl__AccountRewardLedger__c getAccountRewardLedgerById(Id ledgerId) {
        List<dmpl__AccountRewardLedger__c> results = [
            SELECT Id, Name, CreatedById, LastModifiedById,
                dmpl__AccountId__c, dmpl__DiscountVoucherId__c, dmpl__SchemeLedgerId__c,
                dmpl__IncentiveCompensationLineId__c, dmpl__RewardPoints__c, dmpl__DocumentDate__c
            FROM dmpl__AccountRewardLedger__c
            WHERE Id = :ledgerId
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }

    public static dmpl__AccountRewardLedger__c getAccountRewardLedgerByRewardPoints(Integer rewardPoints) {
        List<dmpl__AccountRewardLedger__c> results = [
            SELECT Id, Name, CreatedById, LastModifiedById,
                dmpl__AccountId__c, dmpl__DiscountVoucherId__c, dmpl__SchemeLedgerId__c,
                dmpl__IncentiveCompensationLineId__c, dmpl__RewardPoints__c, dmpl__DocumentDate__c
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
    
    public static dmpl__AccountStock__c createAccountStock(
        Id partnerAccountId,
        Id customerAccountId,
    Id branchId,
    Id ItemId,
    Id VisitId,
    Id visitPlanId,
    Id resourceId,
    Decimal quantity,
    Decimal UOMquantity,
    Decimal UOMquantity1
    
    
    ){
        return (dmpl__AccountStock__c) TestFactory.createSObject(
            new dmpl__AccountStock__c(
            dmpl__Quantity__c = quantity,
        dmpl__PartnerAccountId__c = partnerAccountId,
        dmpl__BranchId__c = branchId,
        dmpl__ItemId__c = itemId,
        dmpl__VisitId__c = visitId,
        dmpl__VisitPlanId__c = visitPlanId,
        dmpl__UOMQuantity__c = UOMquantity,
        dmpl__UOMQuantity1__c = UOMquantity1,
        dmpl__ResourceId__c = resourceId,
        dmpl__AccountId__c = customerAccountId
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
            SELECT Id, dmpl__Quantity__c,
                    dmpl__PartnerAccountId__c ,
                dmpl__BranchId__c ,
                dmpl__ItemId__c,
                dmpl__VisitId__c ,
                dmpl__VisitPlanId__c ,
                dmpl__UOMQuantity__c ,
                dmpl__UOMQuantity1__c,
                dmpl__ResourceId__c ,
                dmpl__AccountId__c
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

    public static dmpl__AccountUser__c createAccountUser(
        Id partnerAccountId,
        Id branchId,
        Id userId,
        Date dateEffectiveFrom,
        Date dateEffectiveTill
    ) {
        return (dmpl__AccountUser__c) TestFactory.createSObject(
            new dmpl__AccountUser__c(
                dmpl__PartnerAccountId__c = partnerAccountId,
                dmpl__BranchId__c = branchId,
                dmpl__UserId__c = userId,
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
            SELECT Id,
                Name,
                dmpl__PartnerAccountId__c,
                dmpl__BranchId__c,
                dmpl__UserId__c,
                dmpl__DateEffectiveFrom__c,
                dmpl__DateEffectiveTill__c
            FROM dmpl__AccountUser__c
        ];
        return results.isEmpty() ? null : results;
    }

    public static dmpl__AccountUser__c getAccountUserById(Id userId) {
        List<dmpl__AccountUser__c> results = [
            SELECT Id,
                Name,
                dmpl__PartnerAccountId__c,
                dmpl__BranchId__c,
                dmpl__UserId__c,
                dmpl__DateEffectiveFrom__c,
                dmpl__DateEffectiveTill__c
            FROM dmpl__AccountUser__c
            WHERE Id = :userId
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }

    public static dmpl__AccountUser__c getAccountUserByEffectiveFromDate(Date effectiveFrom) {
        List<dmpl__AccountUser__c> results = [
            SELECT Id,
                Name,
                dmpl__PartnerAccountId__c,
                dmpl__BranchId__c,
                dmpl__UserId__c,
                dmpl__DateEffectiveFrom__c,
                dmpl__DateEffectiveTill__c
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

    public static dmpl__AccountBalance__c createAccountBalance(
        Id AccountId,
        Id GLAccountId,
        Id partnerAccountId,
        Decimal amount
    ){
        return (dmpl__AccountBalance__c) TestFactory.createSObject(
            new dmpl__AccountBalance__c(
                dmpl__GLAccountId__c = GLAccountId,
                dmpl__AccountId__c = AccountId,
                dmpl__PartnerAccountId__c = partnerAccountId,
                dmpl__Amount__c = amount
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
            SELECT Id, dmpl__GLAccountId__c, dmpl__Amount__c,
                dmpl__AccountId__c, dmpl__PartnerAccountId__c,
                Name
            FROM dmpl__AccountBalance__c
        ];
        return results.isEmpty() ? null : results;
    }

    public static dmpl__AccountBalance__c getAccountBalanceById(Id balanceId) {
        List<dmpl__AccountBalance__c> results = [
            SELECT Id, dmpl__GLAccountId__c, dmpl__Amount__c,
                dmpl__AccountId__c, dmpl__PartnerAccountId__c,
                Name

            FROM dmpl__AccountBalance__c
            WHERE Id = :balanceId
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }
    
    public static dmpl__AccountBalance__c getAccountBalanceByAmount(Decimal amount) {
        List<dmpl__AccountBalance__c> results = [
            SELECT Id, dmpl__GLAccountId__c, dmpl__Amount__c,
                dmpl__AccountId__c, dmpl__PartnerAccountId__c, 
                Name
            FROM dmpl__AccountBalance__c
            WHERE dmpl__Amount__c = :amount
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }

    public static dmpl__GLAccount__c getGLAccountById(Id glAccountId) {
        List<dmpl__GLAccount__c> results = [
            SELECT Id, Name, dmpl__AccountType__c, dmpl__IsActive__c, dmpl__PartnerAccountId__c, dmpl__BranchId__c
            FROM dmpl__GLAccount__c
            WHERE Id = :glAccountId
            LIMIT 1
        ];
        return results.isEmpty() ? null : results[0];
    }

       

}