@isTest
public with sharing class PaymentAdjustmentTestDataHelpers {
 
    public static dmpl__SaleOrder__c createSaleOrder(Account customerAccount, Account partnerAccount, dmpl__Branch__c branch) {
        dmpl__ContactAddress__c contactAddress = [Select Id, Name, dmpl__AccountId__c From dmpl__ContactAddress__c LIMIT 1];
       
        return (dmpl__SaleOrder__c)TestFactory.createSObject(
            new dmpl__SaleOrder__c(
                dmpl__AccountId__c = customerAccount.Id,
                dmpl__PartnerAccountId__c = partnerAccount.Id,
                dmpl__BranchId__c = branch.Id,
                dmpl__DocumentDate__c = Date.today(),
                dmpl__Status__c = 'Draft',
                dmpl__BillingAddressId__c = contactAddress.Id,
                dmpl__ShippingAddressId__c = contactAddress.Id,
                dmpl__RequiredDate__c = Date.today(),
                dmpl__BookingAmount__c = 2000,
                dmpl__AmountPaid__c = 0,
                dmpl__PromisedDate__c = Date.today(),
                dmpl__PerformReleaseFulfilment__c = false,
                dmpl__PerformReleaseInvoice__c = false,
                dmpl__PerformReleaseDelivery__c = false
            ),
            'SaleOrderDefaults',
            true
        );
    }
 
    public static dmpl__SaleOrderLine__c createSaleOrderLines(dmpl__SaleOrder__c saleOrder) {
        dmpl__Item__c item = TestDataHelpers.createItem();
       
        List<dmpl__SaleOrderLine__c> lines = new List<dmpl__SaleOrderLine__c>{
            (dmpl__SaleOrderLine__c)TestFactory.createSObject(
                new dmpl__SaleOrderLine__c(
                    dmpl__SaleOrderId__c = saleOrder.Id,
                    dmpl__ItemId__c = item.Id,
                    dmpl__Quantity__c = 1,
                    dmpl__UnitPrice__c = 1000
                ),
                'SaleOrderLineDefaults',
                true
            )
        };
        return lines[0];
    }
 
    public static dmpl__DiscountGroup__c createDiscountGroup(Account partnerAccount, dmpl__Branch__c branch) {
        return (dmpl__DiscountGroup__c)TestFactory.createSObject(
            new dmpl__DiscountGroup__c(
                Name = 'Test - Discount - Group',
                dmpl__DiscountType__c = 'Sale Price',
                dmpl__IsDefault__c = true,
                dmpl__IsActive__c = true,
                dmpl__PartnerAccountId__c = partnerAccount.Id,
                dmpl__BranchId__c = branch.Id
            ),
            true
        );
    }
 
    public static dmpl__SaleInvoice__c createSaleInvoice(Account customerAccount, dmpl__Branch__c branch, dmpl__SaleOrder__c saleOrder, dmpl__PriceList__c priceList) {
        dmpl__DiscountGroup__c discountGroup = createDiscountGroup(
            [SELECT Id FROM Account WHERE Id = :branch.dmpl__PartnerAccountId__c LIMIT 1],
            branch
        );
       
        return (dmpl__SaleInvoice__c)TestFactory.createSObject(
            new dmpl__SaleInvoice__c(
                dmpl__AccountId__c = customerAccount.Id,
                dmpl__BranchId__c = branch.Id,
                dmpl__SaleOrderId__c = saleOrder.Id,
                dmpl__PriceListId__c = priceList.Id,
                dmpl__DiscountGroupId__c = discountGroup.Id,
                dmpl__DocumentDate__c = Date.today(),
                dmpl__TCSEligibleAmount__c = 2000,
                dmpl__FinanceAmount__c = 2000,
                dmpl__AmountPaid__c = 0,
                dmpl__Status__c = 'Draft',
                dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c
            ),
            'SaleInvoiceDefaults',
            true
        );
    }
 
    public static dmpl__Payment__c createPayment(Account customerAccount, Account partnerAccount, dmpl__Branch__c branch) {
        return (dmpl__Payment__c)TestFactory.createSObject(
            new dmpl__Payment__c(
                dmpl__AccountId__c = customerAccount.Id,
                dmpl__PartnerAccountId__c = partnerAccount.Id,
                dmpl__BranchId__c = branch.Id,
                dmpl__PaymentDate__c = Date.today(),
                dmpl__Amount__c = 1000,
                dmpl__PaymentMode__c = 'Cash',
                dmpl__PaymentType__c = 'PaymentTaken'
            ),
            'PaymentDefaults',
            true
        );
    }
 
    public static dmpl__PaymentAdjustment__c createPaymentAdjustment(dmpl__Payment__c payment, dmpl__SaleInvoice__c saleInvoice, Decimal adjustmentAmount) {
        saleInvoice = [SELECT Id, dmpl__OpenAmount__c FROM dmpl__SaleInvoice__c WHERE Id = :saleInvoice.Id];
 
        return (dmpl__PaymentAdjustment__c)TestFactory.createSObject(
            new dmpl__PaymentAdjustment__c(
                dmpl__PaymentId__c = payment.Id,
                dmpl__SaleInvoiceId__c = saleInvoice.Id,
                dmpl__AdjustmentAmount__c = adjustmentAmount
            ),
            'PaymentAdjustmentDefaults',
            true
        );
    }
 
    public static dmpl__PaymentAdjustment__c createPaymentAdjustment(dmpl__Payment__c payment, dmpl__SaleInvoice__c saleInvoice) {
        saleInvoice = [SELECT Id, dmpl__OpenAmount__c FROM dmpl__SaleInvoice__c WHERE Id = :saleInvoice.Id];
        Decimal safeAmount = Math.min(saleInvoice.dmpl__OpenAmount__c * 0.3, 500);
        return createPaymentAdjustment(payment, saleInvoice, safeAmount);
    }
 
    public static dmpl__PaymentAdjustment__c updatePaymentAdjustment(dmpl__PaymentAdjustment__c adjustment, Decimal amount) {
        dmpl__Payment__c payment = [SELECT Id, dmpl__OpenAmount2__c FROM dmpl__Payment__c WHERE Id = :adjustment.dmpl__PaymentId__c];
       
        if (amount > payment.dmpl__OpenAmount2__c) {
            throw new TestDataException('Adjustment amount cannot be greater than payment open amount');
        }
 
        adjustment.dmpl__AdjustmentAmount__c = amount;
        update adjustment;
        return adjustment;
    }
 
    public static void deletePaymentAdjustment(dmpl__PaymentAdjustment__c adjustment) {
        delete adjustment;
    }
 
    public static dmpl__PaymentAdjustment__c getPaymentAdjustment() {
        return [
            SELECT Id, Name, dmpl__PaymentId__c, dmpl__SaleInvoiceId__c,
                   dmpl__AdjustmentAmount__c, dmpl__DocumentAmount__c
            FROM dmpl__PaymentAdjustment__c
            LIMIT 1
        ];
    }
 
    public static dmpl__PaymentAdjustment__c getPaymentAdjustmentsByPayment(Id paymentId) {
        return [
            SELECT Id, Name, dmpl__PaymentId__c, dmpl__SaleInvoiceId__c,
                   dmpl__AdjustmentAmount__c, dmpl__DocumentAmount__c
            FROM dmpl__PaymentAdjustment__c
            WHERE dmpl__PaymentId__c = :paymentId
        ];
    }
 
    public static dmpl__Payment__c getPayment() {
        return [
            SELECT Id, Name, dmpl__AccountId__c, dmpl__PartnerAccountId__c,
                   dmpl__BranchId__c, dmpl__Amount__c
            FROM dmpl__Payment__c
            LIMIT 1
        ];
    }
 
    public static dmpl__SaleInvoice__c getSaleInvoice() {
        return [
            SELECT Id, Name, dmpl__AccountId__c, dmpl__BranchId__c,
                   dmpl__PartnerAccountId__c, dmpl__TotalAmount__c,
                   dmpl__OpenAmount__c, dmpl__TCSEligibleAmount__c,
                   dmpl__FinanceAmount__c, dmpl__AmountPaid__c
            FROM dmpl__SaleInvoice__c
            LIMIT 1
        ];
    }
 
    public static dmpl__DebitNote__c createDebitNote(Account customerAccount, Account partnerAccount, dmpl__Branch__c branch) {
        return (dmpl__DebitNote__c)TestFactory.createSObject(
            new dmpl__DebitNote__c(
                dmpl__AccountId__c = customerAccount.Id,
                dmpl__PartnerAccountId__c = partnerAccount.Id,
                dmpl__BranchId__c = branch.Id,
                dmpl__DocumentDate__c = Date.today(),
                dmpl__Notes__c = 'Test Debit Note',
                dmpl__Currency__c = 'INR'
            ),
            'DebitNoteDefaults',
            true
        );
    }
 
    public static dmpl__PaymentAdjustment__c createPaymentAdjustment(dmpl__Payment__c payment, dmpl__DebitNote__c debitNote, Decimal adjustmentAmount) {
        debitNote = [SELECT Id, dmpl__OpenAmount__c FROM dmpl__DebitNote__c WHERE Id = :debitNote.Id];
       
        if (adjustmentAmount > debitNote.dmpl__OpenAmount__c) {
            throw new TestDataException('Adjustment amount cannot be greater than open amount');
        }
 
        return (dmpl__PaymentAdjustment__c)TestFactory.createSObject(
            new dmpl__PaymentAdjustment__c(
                dmpl__PaymentId__c = payment.Id,
                dmpl__DebitNoteId__c = debitNote.Id,
                dmpl__AdjustmentAmount__c = adjustmentAmount
            ),
            'PaymentAdjustmentDefaults',
            true
        );
    }
 
    public class TestDataException extends Exception {}
}