@isTest
private class PaymentAdjustmentHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account customerAccount = TestDataHelpers.createCustomerAccount();
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);  
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList(partnerAccount, branch);
        dmpl__ContactAddress__c contactAddress = TestDataHelpers.createContactAddress(customerAccount);
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation(branch);
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__ItemLot__c itemLot = TestDataHelpers.createItemLot(branch, item, sku, storageLocation);
        dmpl__SaleOrder__c saleOrder = PaymentAdjustmentTestDataHelpers.createSaleOrder(customerAccount, partnerAccount, branch);
        dmpl__SaleInvoice__c saleInvoice = PaymentAdjustmentTestDataHelpers.createSaleInvoice(customerAccount, branch, saleOrder, priceList);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup(partnerAccount, branch);
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceList, item);
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceTestDataHelpers.createSaleInvoiceLine(saleInvoice, item, sku, itemLot, taxGroup, priceListRule);
        dmpl__Payment__c payment = PaymentAdjustmentTestDataHelpers.createPayment(customerAccount, partnerAccount, branch);
        dmpl__PaymentAdjustment__c adjustment = PaymentAdjustmentTestDataHelpers.createPaymentAdjustment(payment, saleInvoice, 100);
    }
   
    @isTest
    static void createPaymentAdjustmentPositive() {
        dmpl__Payment__c payment = PaymentAdjustmentTestDataHelpers.getPayment();
        dmpl__SaleInvoice__c saleInvoice = PaymentAdjustmentTestDataHelpers.getSaleInvoice();
       
        dmpl__PaymentAdjustment__c adjustment = PaymentAdjustmentTestDataHelpers.getPaymentAdjustmentsByPayment(payment.Id);
       
        System.assertNotEquals(null, adjustment.Id, 'Payment Adjustment should have been created with a valid Id');
        System.assertEquals(payment.Id, adjustment.dmpl__PaymentId__c, 'Payment Adjustment should be linked to the correct Payment');
        System.assertEquals(saleInvoice.Id, adjustment.dmpl__SaleInvoiceId__c, 'Payment Adjustment should be linked to the correct Sale Invoice');
    }
   
    @isTest
    static void updatePaymentAdjustmentPositive() {
        dmpl__Payment__c payment = PaymentAdjustmentTestDataHelpers.getPayment();
        dmpl__SaleInvoice__c saleInvoice = PaymentAdjustmentTestDataHelpers.getSaleInvoice();
        dmpl__PaymentAdjustment__c adjustment = PaymentAdjustmentTestDataHelpers.getPaymentAdjustmentsByPayment(payment.Id);
       
        Decimal openAmount = saleInvoice.dmpl__OpenAmount__c;
        Decimal updateAmount = openAmount >= 100 ? 100 : openAmount;
       
        Test.startTest();
        dmpl__PaymentAdjustment__c updatedAdjustment = PaymentAdjustmentTestDataHelpers.updatePaymentAdjustment(adjustment, updateAmount);
        Test.stopTest();
       
        System.assertEquals(updateAmount, updatedAdjustment.dmpl__AdjustmentAmount__c, 'Payment Adjustment amount should be updated correctly');
    }
   
    @isTest
    static void deletePaymentAdjustmentPositive() {
        Test.startTest();
        dmpl__Payment__c payment = PaymentAdjustmentTestDataHelpers.getPayment();
        dmpl__SaleInvoice__c saleInvoice = PaymentAdjustmentTestDataHelpers.getSaleInvoice();
        dmpl__PaymentAdjustment__c adjustment = PaymentAdjustmentTestDataHelpers.getPaymentAdjustmentsByPayment(payment.Id);
        PaymentAdjustmentTestDataHelpers.deletePaymentAdjustment(adjustment);
        dmpl__Payment__c existingPayment = PaymentAdjustmentTestDataHelpers.getPayment();
        dmpl__SaleInvoice__c existingInvoice = PaymentAdjustmentTestDataHelpers.getSaleInvoice();
        Test.stopTest();
        System.assertNotEquals(null, existingPayment, 'Payment should still exist after adjustment deletion');
        System.assertNotEquals(null, existingInvoice, 'Sale Invoice should still exist after adjustment deletion');
    }
}