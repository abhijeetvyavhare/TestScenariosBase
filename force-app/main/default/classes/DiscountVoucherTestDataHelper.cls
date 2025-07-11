@isTest
public with sharing class DiscountVoucherTestDataHelper {

    public static dmpl__DiscountVoucher__c createDiscountVoucher(
        Account acct, 
        dmpl__Branch__c branch, 
        Account partnerAcct
    ) {
        return (dmpl__DiscountVoucher__c) TestFactory.createSObject(
            new dmpl__DiscountVoucher__c(
                dmpl__AccountId__c = acct != null ? acct.Id : null,
                dmpl__Amount__c = 100.00,
                dmpl__BranchId__c = branch != null ? branch.Id : null,
                dmpl__CreditNoteId__c = null,
                dmpl__DiscountVoucherType__c = 'Voucher', 
                dmpl__DocumentDate__c = Date.today(),
                dmpl__GiftType__c = 'None',
                dmpl__PartnerAccountId__c = partnerAcct != null ? partnerAcct.Id : null,
                dmpl__RedeemedPoints__c = 100,
                dmpl__VoucherType__c = 'None'
            ),
            'DiscountVoucherDefaults',
            true
        );
    }

    public static dmpl__DiscountVoucher__c getDiscountVoucher() {
        return [
            SELECT 
                Id, 
                dmpl__AccountId__c, 
                dmpl__Amount__c, 
                dmpl__BranchId__c,
                dmpl__CreditNoteId__c, 
                Name, 
                dmpl__DiscountVoucherType__c,
                dmpl__DocumentDate__c, 
                dmpl__GiftType__c, 
                dmpl__PartnerAccountId__c,
                dmpl__RedeemedPoints__c, 
                dmpl__VoucherType__c
            FROM dmpl__DiscountVoucher__c
            LIMIT 1
        ];
    }

    public static dmpl__DiscountVoucher__c createDiscountVoucherById(
        Account partnerAccount,
        Account customerAccount,
        dmpl__Branch__c branch
    ){
        return (dmpl__DiscountVoucher__c)TestFactory.createSObject(
            new dmpl__DiscountVoucher__c(
                dmpl__PartnerAccountId__c =partnerAccount.Id,
                dmpl__AccountId__c=customerAccount.Id,
                dmpl__BranchId__c = branch != null ? branch.Id : null
                ),
            true
        );
    }
    public static dmpl__DiscountVoucher__c getDiscountVoucherById(Id id){
        return [
            SELECT 
                Id,
                Name,
                dmpl__PartnerAccountId__c,
                dmpl__AccountId__c,
                dmpl__BranchId__c
            FROM dmpl__DiscountVoucher__c
            WHERE Id = :id 
            LIMIT 1
        ];
    }
}