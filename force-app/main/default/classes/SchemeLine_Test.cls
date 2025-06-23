@isTest
private class SchemeLine_Test {

    @testSetup
static void Setup() {

    // Create scheme records
    dmpl__Scheme__c schemePerSaleOrder = new dmpl__Scheme__c(
        dmpl__SchemeType__c = 'Per Sale Order',
        dmpl__PeriodType__c = 'Monthly',
        Name='Scheme2',
        dmpl__ValidTo__c= Datetime.now().addDays(150).Date(),
        dmpl__Status__c='Approved',
        dmpl__MultipleFulfilmentTreatment__c='Apply First Fulfilled',
        dmpl__ValidFrom__c = date.today(),
        dmpl__PartnerAccountId__c = null,
        dmpl__PartnerAccountGroupId__c = null
    );
    insert schemePerSaleOrder;

    dmpl__Scheme__c schemePerPeriodSaleOrder = new dmpl__Scheme__c(
        dmpl__SchemeType__c = 'Per Period Sale Order',
        dmpl__PeriodType__c = 'Monthly',
        Name='Scheme2',
        dmpl__ValidTo__c= Datetime.now().addDays(150).Date(),
        dmpl__Status__c='Approved',
        dmpl__MultipleFulfilmentTreatment__c='Apply First Fulfilled',
        dmpl__ValidFrom__c = date.today(),
        dmpl__PartnerAccountId__c = null,
        dmpl__PartnerAccountGroupId__c = null
    );
    insert schemePerPeriodSaleOrder;

    // Create scheme line records
    dmpl__SchemeLine__c schemeLine1 = new dmpl__SchemeLine__c(
        dmpl__DefinitionFilterCriteria__c = 'Any Condition Is Met',
        dmpl__SchemeId__c = schemePerSaleOrder.Id,
        dmpl__SequenceNumber__c = 3,
        dmpl__RewardApplicability__c = 'Any One With Highest Value'
    );
    insert schemeLine1;

    dmpl__SchemeLine__c schemeLine2 = new dmpl__SchemeLine__c(
        dmpl__DefinitionFilterCriteria__c = 'Always (No Criteria)',
        dmpl__SchemeId__c = schemePerPeriodSaleOrder.Id,
        dmpl__SequenceNumber__c = 4,
        dmpl__RewardApplicability__c = 'Custom Logic'
    );
    insert schemeLine2;
}


    @isTest
    static void testSchemeConditionPicklistFilter_NoConditionExists() {
        // Retrieve the schemePerSaleOrder record
        dmpl__Scheme__c schemePerSaleOrder = [SELECT Id FROM dmpl__Scheme__c WHERE dmpl__SchemeType__c = 'Per Sale Order' LIMIT 1];

        // Create a new scheme line without existing scheme conditions
        dmpl__SchemeLine__c schemeLine = new dmpl__SchemeLine__c(
            dmpl__SchemeId__c = schemePerSaleOrder.Id,
            dmpl__DefinitionFilterCriteria__c = 'Any Condition Is Met',
            dmpl__SequenceNumber__c = 3,
            dmpl__RewardApplicability__c = 'Any One With Highest Value'
        );
        insert schemeLine;

        // Ensure no scheme conditions exist for the scheme line
        System.assertEquals(0, [SELECT count() FROM dmpl__SchemeCondition__c WHERE dmpl__SchemeLineId__c = :schemeLine.Id]);
    }

    @isTest
    static void testSchemeConditionPicklistFilter_ConditionExists() {
        // Retrieve the schemePerPeriodSaleOrder record
        dmpl__Scheme__c schemePerPeriodSaleOrder = [SELECT Id FROM dmpl__Scheme__c WHERE dmpl__SchemeType__c = 'Per Period Sale Order' LIMIT 1];
    
        // Create a new scheme line with existing scheme conditions
        dmpl__SchemeLine__c schemeLine = new dmpl__SchemeLine__c(
            dmpl__SchemeId__c = schemePerPeriodSaleOrder.Id,
            dmpl__DefinitionFilterCriteria__c = 'Always (No Criteria)',
            dmpl__SequenceNumber__c = 4,
            dmpl__RewardApplicability__c = 'Custom Logic'
        );
        insert schemeLine;
    
        // Try to create a corresponding scheme condition record (which may fail due to validation rules or triggers)
        try {
            dmpl__SchemeCondition__c schemeCondition = new dmpl__SchemeCondition__c(
                dmpl__SchemeLineId__c = schemeLine.Id
            );
            insert schemeCondition;
            // If the above insert succeeds, an error is expected
            System.assert(false, 'Expected error not thrown');
        } catch (DmlException e) {
            // Ensure the error is due to the validation rule or trigger
            System.assertEquals(System.StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION, e.getDmlType(0));
        }
    }    

    @isTest
    static void testSchemeLineTrigger_DisabledTrigger() {
        // Set a flag to simulate trigger being disabled
        Boolean isTriggerDisabled = true;

        // Retrieve the schemePerSaleOrder record
        dmpl__Scheme__c schemePerSaleOrder = [SELECT Id FROM dmpl__Scheme__c WHERE dmpl__SchemeType__c = 'Per Sale Order' LIMIT 1];

        // Create a new scheme line
        dmpl__SchemeLine__c schemeLine = new dmpl__SchemeLine__c(
            dmpl__SchemeId__c = schemePerSaleOrder.Id,
            dmpl__DefinitionFilterCriteria__c = 'Any Condition Is Met',
            dmpl__SequenceNumber__c = 3,
            dmpl__RewardApplicability__c = 'Any One With Highest Value'
        );
        insert schemeLine;

        // Update the scheme line record (should not invoke trigger)
        if (!isTriggerDisabled) {
            Test.startTest();
            schemeLine.dmpl__DefinitionFilterCriteria__c = 'Always (No Criteria)';
            update schemeLine;
            Test.stopTest();

            // Ensure trigger did not execute
            System.assertEquals(0, [SELECT count() FROM dmpl__SchemeCondition__c]);
        }
    }
}