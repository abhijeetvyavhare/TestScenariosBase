@isTest
private class PaymentHandler_Test {
    
    @TestSetup
    static void createRequiredData() {

        Account customerAccount = TestDataHelpers.createCustomerAccount();
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);  
        dmpl__SaleOrder__c saleOrder = SaleOrderTestDataHelpers.createSaleOrder(customerAccount, branch);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList(partnerAccount, branch);
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceTestDataHelpers.createSaleInvoice(customerAccount,branch,saleOrder,priceList);
        dmpl__Payment__c payment = PaymentTestDataHelpers.createPayment(customerAccount,partnerAccount,branch,saleInvoice,100.00);
    }

    @isTest
    static void createPaymentPositive() {

        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceTestDataHelpers.getSaleInvoice();
        Account customerAccount = TestDataHelpers.getCustomerAccount();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();

       dmpl__Payment__c payment = PaymentTestDataHelpers.getPayment();


        System.assertNotEquals(null, payment.Id, 'Payment should be created');
        System.assertEquals(saleInvoice.Id, payment.dmpl__SaleInvoiceId__c, 'Sale Invoice should be linked');
        System.assertEquals(100.00, payment.dmpl__Amount__c, 'Amount should be 100.00');
        System.assertEquals(partnerAccount.Id, payment.dmpl__PartnerAccountId__c, 'Partner Account should be linked');
    }

    @isTest
    static void updatePaymentPositive() {

        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceTestDataHelpers.getSaleInvoice();
        Account customerAccount = TestDataHelpers.getCustomerAccount();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__Payment__c existingPayment = PaymentTestDataHelpers.getPayment();

        Test.startTest();

        dmpl__Payment__c updatedPayment = PaymentTestDataHelpers.updatePayment(
            customerAccount,
            partnerAccount,
            branch,
            saleInvoice,
            200.00,
            existingPayment
        );
        Test.stopTest();


        System.assertEquals(existingPayment.Id, updatedPayment.Id, 'Should update existing record');
        System.assertEquals(saleInvoice.Id, updatedPayment.dmpl__SaleInvoiceId__c, 'Sale Invoice should remain linked');
        System.assertEquals(200.00, updatedPayment.dmpl__Amount__c, 'Amount should be updated to 200.00');
        System.assertEquals(partnerAccount.Id, updatedPayment.dmpl__PartnerAccountId__c, 'Partner Account should remain linked');
    }

    @isTest
    static void deletePaymentPositive() {

        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceTestDataHelpers.getSaleInvoice();
        dmpl__Payment__c existingPayment = PaymentTestDataHelpers.getPayment();

        Test.startTest();

        delete existingPayment;
        Test.stopTest();

        List<dmpl__Payment__c> remainingPayments = PaymentTestDataHelpers.getPaymentsBySaleInvoice(saleInvoice.Id);
        System.assertEquals(0, remainingPayments.size(), 'Should have no payments remaining');
    }
}