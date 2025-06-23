public with sharing class PaymentAdjustmentTestDataHelper {

    public static dmpl__PaymentAdjustment__c createPaymentAdjustment(
        dmpl__Branch__c branch
    ) {
        return (dmpl__PaymentAdjustment__c) TestFactory.createSObject(
            new dmpl__PaymentAdjustment__c(
                
                dmpl__BranchId__c = branch.Id
            ),
            'PaymentAdjustmentDefaults',
            true
        );
    }
}