public with sharing class OrgSettingHelper {
    
    public static final string ROUNDOFFTYPE_ROUND = 'Round';
    public static final string ROUNDOFFTYPE_CEIL = 'Ceil';
    public static final string ROUNDOFFTYPE_FLOOR = 'Floor';
    public static dmpl__DMSOrgSetting__mdt orgSetting; 
    
    public static dmpl__DMSOrgSetting__mdt OrgSetting() {
        if(orgSetting == null){
            orgSetting = [SELECT 
                dmpl__CopyTaxesInSalesReturn__c,
                dmpl__CopyTaxesInPurchaseReturn__c,
                dmpl__SaleReturnTaxesValidity__c,
                dmpl__PurchaseReturnTaxesValidity__c,
                dmpl__ItemLotOrderByFields__c,
                dmpl__EnableAEPostingInSaleInvoice__c,
                dmpl__EnableAEPostingInPurchaseInvoice__c,
                dmpl__ConvertLeadStatus__c,
                dmpl__SchemeAdjustmentItemId__c,
                dmpl__DisableTriggers__c,
                dmpl__DisableMessaging__c,
                dmpl__AuthoriseUser__c,
                dmpl__AuthoriseResource__c,
                dmpl__EnableRoundOff__c,
                dmpl__RoundOffDigits__c,
                dmpl__RoundOffType__c,
                dmpl__EnableMOQQuantityValidation__c,
                dmpl__ShowOrdersInPaymentAdjustment__c,
                dmpl__ShowInvoicesInPayment__c,
                dmpl__DisableServiceContractValidations__c,
                dmpl__PaymentAdjustmentPanelFields__c,
                dmpl__PaymentFieldsetName__c,
                dmpl__LocationTolerance__c,
                dmpl__HalfShiftTolerance__c,
                dmpl__ApplySchemeAsync__c,
                dmpl__ShowInvoicesInPaymentAdjustment__c,
                dmpl__DisableTaxPosting__c
            FROM dmpl__DMSOrgSetting__mdt
            LIMIT 1];
        }
        return orgSetting;
    }

    public static Boolean enableRoundOff(){
        return OrgSetting()?.dmpl__EnableRoundOff__c;
    }

    public static Integer roundOffDigits(){
        return (Integer)OrgSetting()?.dmpl__RoundOffDigits__c;
    }
    
    public static String roundOffType(){
        return OrgSetting()?.dmpl__RoundOffType__c;
    }

    public static String getSchemeAdjustmentItemId(){
        return OrgSetting()?.dmpl__SchemeAdjustmentItemId__c;
    }
    
    public static String getLeadConvertStatus(){
        return OrgSetting()?.dmpl__ConvertLeadStatus__c;
    }

    public static Boolean IsTriggerDisabled(){
        return OrgSetting()?.dmpl__DisableTriggers__c;
    }

    public static Boolean IsServiceContractValidationsDisabled(){
        return OrgSetting()?.dmpl__DisableServiceContractValidations__c;
    }
    
    public static Boolean IsMessagingDisabled(){
        return OrgSetting()?.dmpl__DisableMessaging__c;
    }

    public static Boolean authoriseUser(){
        return OrgSetting()?.dmpl__AuthoriseUser__c;
    }

    public static Boolean authoriseResource(){
        return OrgSetting()?.dmpl__AuthoriseResource__c;
    }

    public static Boolean disableTaxPosting(){
        return OrgSetting()?.dmpl__DisableTaxPosting__c;
    }
}