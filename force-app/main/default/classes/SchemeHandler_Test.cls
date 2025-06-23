@isTest
public with sharing class SchemeHandler_Test {
    @TestSetup
    static void createRequiredData() {
        
    }
    
    @isTest
    Static void createSchemeWithRequiredFieldsPositive()
    {
        dmpl__Scheme__c scheme1 = SchemeTestDataHelper.createScheme(
            'Scheme 1',
        '',
        '',
        'Per Sale Order',
        'Weekly',
        Date.today(),
        Date.today().addMonths(1),
        0,
        '',
        0,
        false,
        (Id)null,
        (Id)null,
        (Id)null,
        (Id)null,
        (Id)null
            );
        
        dmpl__Scheme__c scheme = SchemeTestDataHelper.getScheme(scheme1.Name);
        System.assertNotEquals(null, scheme, 'Scheme record should not be null');
        System.assertEquals(scheme1.Name, scheme.Name, 'Scheme Name should be "Scheme 1"');
        System.assertEquals(scheme1.dmpl__SchemeType__c, scheme.dmpl__SchemeType__c, 'Scheme Type should be "Per Sale Order"');
        System.assertEquals( scheme1.dmpl__PeriodType__c, scheme.dmpl__PeriodType__c, 'Period Type should be "Weekly"');
        System.assertEquals(Date.today(), scheme.dmpl__ValidFrom__c, 'Valid From should be 20-06-2025');
        System.assertEquals(Date.today().addMonths(1), scheme.dmpl__ValidTo__c, 'Valid To should be 20-07-2025');
    }
    
    @isTest
    Static void updateSchemeNamePositive()
    {
        dmpl__Scheme__c scheme1 = SchemeTestDataHelper.createScheme(
            'Scheme 1',
        '',
        '',
        'Per Sale Order',
        'Weekly',
        Date.Today(),
        Date.Today().addMonths(1),
        0,
        '',
        0,
        false,
        (Id)null,
        (Id)null,
        (Id)null,
        (Id)null,
        (Id)null
            );
        
        dmpl__Scheme__c scheme = SchemeTestDataHelper.getScheme(scheme1.Name);
        scheme.Name = 'Scheme 15';
        Update scheme;
        
        dmpl__Scheme__c updatedScheme = SchemeTestDataHelper.getScheme(scheme.Name);
        
        System.assertNotEquals(null, scheme, 'Scheme record should not be null');
        System.assertEquals(updatedScheme.Name, scheme.Name, 'Scheme Name should be "Scheme 1"');
        System.assertEquals(updatedScheme.dmpl__SchemeType__c, scheme.dmpl__SchemeType__c, 'Scheme Type should be "Per Sale Order"');
        System.assertEquals(updatedScheme.dmpl__PeriodType__c, scheme.dmpl__PeriodType__c, 'Period Type should be "Weekly"');
        System.assertEquals(Date.today(), scheme.dmpl__ValidFrom__c, 'Valid From should be 20-06-2025');
        System.assertEquals(Date.today().addMonths(1), scheme.dmpl__ValidTo__c, 'Valid To should be 20-07-2025');
    }
    
    @isTest
    static void createSchemeWithoutNameNegative() {
        Test.startTest();
        Boolean exceptionThrown = false;
        
        try {
            dmpl__Scheme__c scheme1 = SchemeTestDataHelper.createScheme(
                '', // Missing name
            '',
            '',
            'Per Sale Order',
            'Weekly',
            Date.today(),
            Date.today().addMonths(1),
            0,
            '',
            0,
            false,
            (Id)null,
            (Id)null,
            (Id)null,
            (Id)null,
            (Id)null
                );
            
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        dmpl__Scheme__c scheme = SchemeTestDataHelper.getScheme();
        
        Test.stopTest();
        System.assertEquals(null, scheme, 'Scheme record should not be created');
        System.assertEquals(true, exceptionThrown, 'DmlException should be thrown due to missing Name field');
    }
    
    @isTest
    Static void updateSchemeTypePositive()
    {
        dmpl__Scheme__c scheme1 = SchemeTestDataHelper.createScheme(
            'Scheme 15',
        '',
        '',
        'Per Sale Order',
        'Weekly',
        Date.Today(),
        Date.Today().addMonths(1),
        0,
        '',
        0,
        false,
        (Id)null,
        (Id)null,
        (Id)null,
        (Id)null,
        (Id)null
            );
        
        dmpl__Scheme__c scheme = SchemeTestDataHelper.getScheme(scheme1.Name);
        scheme.dmpl__SchemeType__c = 'Per Sale Invoice';
        Update scheme;
        
        dmpl__Scheme__c updatedScheme = SchemeTestDataHelper.getScheme(scheme.Name);
        
        System.assertNotEquals(null, scheme, 'Scheme record should not be null');
        System.assertEquals(updatedScheme.Name, scheme.Name, 'Scheme Name should be "Scheme 1"');
        System.assertEquals(updatedScheme.dmpl__SchemeType__c, scheme.dmpl__SchemeType__c, 'Scheme Type should be "Per Sale Order"');
        System.assertEquals(updatedScheme.dmpl__PeriodType__c, scheme.dmpl__PeriodType__c, 'Period Type should be "Weekly"');
        System.assertEquals(Date.today(), scheme.dmpl__ValidFrom__c, 'Valid From should be 20-06-2025');
        System.assertEquals(Date.today().addMonths(1), scheme.dmpl__ValidTo__c, 'Valid To should be 20-07-2025');
    }
    
    @isTest
    Static void updatePeriodTypePositive()
    {
        dmpl__Scheme__c scheme1 = SchemeTestDataHelper.createScheme(
            'Scheme 15',
        '',
        '',
        'Per Sale Order',
        'Weekly',
        Date.Today(),
        Date.Today().addMonths(1),
        0,
        '',
        0,
        false,
        (Id)null,
        (Id)null,
        (Id)null,
        (Id)null,
        (Id)null
            );
        
        dmpl__Scheme__c scheme = SchemeTestDataHelper.getScheme(scheme1.Name);
        scheme.dmpl__PeriodType__c = 'Monthly';
        Update scheme;
        
        dmpl__Scheme__c updatedScheme = SchemeTestDataHelper.getScheme(scheme.Name);
        
        System.assertNotEquals(null, scheme, 'Scheme record should not be null');
        System.assertEquals(updatedScheme.Name, scheme.Name, 'Scheme Name should be "Scheme 1"');
        System.assertEquals(updatedScheme.dmpl__SchemeType__c, scheme.dmpl__SchemeType__c, 'Scheme Type should be "Per Sale Order"');
        System.assertEquals(updatedScheme.dmpl__PeriodType__c, scheme.dmpl__PeriodType__c, 'Period Type should be "Weekly"');
        System.assertEquals(updatedScheme.dmpl__ValidFrom__c, scheme.dmpl__ValidFrom__c, 'Valid From should be 20-06-2025');
        System.assertEquals(updatedScheme.dmpl__ValidTo__c, scheme.dmpl__ValidTo__c, 'Valid To should be 20-07-2025');
    }
    
    
    @isTest
    static void createSchemeWithoutPeriodTypeNegative() {
        Test.startTest();
        Boolean exceptionThrown = false;
        
        try {
            dmpl__Scheme__c scheme1 = SchemeTestDataHelper.createScheme(
                'Scheme 15', 
            '',
            '',
            'Per Sale Order',
            '',
            Date.today(),
            Date.today().addMonths(1),
            0,
            '',
            0,
            false,
            (Id)null,
            (Id)null,
            (Id)null,
            (Id)null,
            (Id)null
                );
            
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'DmlException should be thrown due to Period type field');
    }
    
    
    @isTest
    Static void updateSchemeCreationWithValidFromPositive()
    {
        dmpl__Scheme__c scheme1 = SchemeTestDataHelper.createScheme(
            'Scheme 15',
        '',
        '',
        'Per Sale Order',
        'Weekly',
        Date.Today(),
        Date.Today().addMonths(1),
        0,
        '',
        0,
        false,
        (Id)null,
        (Id)null,
        (Id)null,
        (Id)null,
        (Id)null
            );
        
        dmpl__Scheme__c scheme = SchemeTestDataHelper.getScheme(scheme1.Name);
        scheme.dmpl__ValidFrom__c =Date.Today().addDays(2) ;
        Update scheme;
        
        dmpl__Scheme__c updatedScheme = SchemeTestDataHelper.getScheme(scheme.Name);
        
        System.assertNotEquals(null, scheme, 'Scheme record should not be null');
        System.assertEquals(updatedScheme.Name, scheme.Name, 'Scheme Name should be "Scheme 1"');
        System.assertEquals(updatedScheme.dmpl__SchemeType__c, scheme.dmpl__SchemeType__c, 'Scheme Type should be "Per Sale Order"');
        System.assertEquals(updatedScheme.dmpl__PeriodType__c, scheme.dmpl__PeriodType__c, 'Period Type should be "Weekly"');
        System.assertEquals(updatedScheme.dmpl__ValidFrom__c, scheme.dmpl__ValidFrom__c, 'Valid From should be 20-06-2025');
        System.assertEquals(updatedScheme.dmpl__ValidTo__c, scheme.dmpl__ValidTo__c, 'Valid To should be 20-07-2025');
    }
    
    @isTest
    Static void updateSchemeCreationWithValidToPositive()
    {
        dmpl__Scheme__c scheme1 = SchemeTestDataHelper.createScheme(
            'Scheme 15',
        '',
        '',
        'Per Sale Order',
        'Weekly',
        Date.Today(),
        Date.Today().addMonths(1),
        0,
        '',
        0,
        false,
        (Id)null,
        (Id)null,
        (Id)null,
        (Id)null,
        (Id)null
            );
        
        dmpl__Scheme__c scheme = SchemeTestDataHelper.getScheme(scheme1.Name);
        scheme.dmpl__ValidTo__c = scheme.dmpl__ValidTo__c+2;
        Update scheme;
        
        dmpl__Scheme__c updatedScheme = SchemeTestDataHelper.getScheme(scheme.Name);
        
        System.assertNotEquals(null, scheme, 'Scheme record should not be null');
        System.assertEquals(updatedScheme.Name, scheme.Name, 'Scheme Name should be "Scheme 1"');
        System.assertEquals(updatedScheme.dmpl__SchemeType__c, scheme.dmpl__SchemeType__c, 'Scheme Type should be "Per Sale Order"');
        System.assertEquals(updatedScheme.dmpl__PeriodType__c, scheme.dmpl__PeriodType__c, 'Period Type should be "Weekly"');
        System.assertEquals(updatedScheme.dmpl__ValidFrom__c, scheme.dmpl__ValidFrom__c, 'Valid From should be 20-06-2025');
        System.assertEquals(updatedScheme.dmpl__ValidTo__c, scheme.dmpl__ValidTo__c, 'Valid To should be 20-07-2025');
    }

      @isTest
    static void createSchemeWithoutValidFromNegative() {
        Test.startTest();
        Boolean exceptionThrown = false;
        
        try {
            dmpl__Scheme__c scheme1 = SchemeTestDataHelper.createScheme(
                'Scheme 15',
            '',
            '',
            'Per Sale Order',
            'Weekly',
             null,
            Date.today().addMonths(1),
            0,
            '',
            0,
            false,
            (Id)null,
            (Id)null,
            (Id)null,
            (Id)null,
            (Id)null
                );
            
        } catch (DmlException e) {
            exceptionThrown = true;
            // System.assert(e.getMessage().contains('REQUIRED_FIELD_MISSING'), 'Expected REQUIRED_FIELD_MISSING error');
        }
        
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'DmlException should be thrown due to missing Valid from field');
    }

      @isTest
    static void createSchemeWithoutValidToNegative() {
        Test.startTest();
        Boolean exceptionThrown = false;
        
        try {
            dmpl__Scheme__c scheme1 = SchemeTestDataHelper.createScheme(
                'Scheme 15',
            '',
            '',
            'Per Sale Order',
            'Weekly',
            Date.today(),
            null,
            0,
            '',
            0,
            false,
            (Id)null,
            (Id)null,
            (Id)null,
            (Id)null,
            (Id)null
                );
            
        } catch (DmlException e) {
            exceptionThrown = true;
            // System.assert(e.getMessage().contains('REQUIRED_FIELD_MISSING'), 'Expected REQUIRED_FIELD_MISSING error');
        }
        
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'DmlException should be thrown due to missing Valid to field');
    }
    
       @isTest
    static void createSchemeWithoutSchemeTypeNegative() {
        Test.startTest();
        Boolean exceptionThrown = false;
        
        try {
            dmpl__Scheme__c scheme1 = SchemeTestDataHelper.createScheme(
                'Scheme 15',
            '',
            '',
            '',
            'Weekly',
            Date.today(),
            null,
            0,
            '',
            0,
            false,
            (Id)null,
            (Id)null,
            (Id)null,
            (Id)null,
            (Id)null
                );
            
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'DmlException should be thrown due to missing scheme type field');
    }
    
}
