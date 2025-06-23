public with sharing class GLAccountTestDataHelpers {
    public static dmpl__GLAccount__c createGLAccount(){
        return (dmpl__GLAccount__c)TestFactory.createSObject(
            new dmpl__GLAccount__c(),
            'GLAccountDefaults',
            true
        );
    }
}