public with sharing class RoundOffHelper {

    public static void setRoundOff(
        List<SObject> newEntries,
        String lineSubTotalFieldName,
        String totalTaxAmountFieldName){
        if(OrgSettingHelper.enableRoundOff()){
            for(SObject order : newEntries){
                if(MetadataHelper.getField(order.getSObjectType(), 'SkipRoundOff__c')!=null
                    && (Boolean)order.get('SkipRoundOff__c')){
                        order.put(
                            'dmpl__RoundOff__c',
                            0);
                }else {
                    Decimal totalAmount = (order.get(lineSubTotalFieldName) != null ?
                    (Decimal)order.get(lineSubTotalFieldName) : 0)
                     + (order.get(totalTaxAmountFieldName) !=null ? 
                     (Decimal)order.get(totalTaxAmountFieldName) : 0);
                    if(OrgSettingHelper.roundOffType() == OrgSettingHelper.ROUNDOFFTYPE_ROUND){
                        order.put(
                            'dmpl__RoundOff__c', 
                            totalAmount.setScale(OrgSettingHelper.roundOffDigits()) - totalAmount);
                    }else if(OrgSettingHelper.roundOffType() == OrgSettingHelper.ROUNDOFFTYPE_CEIL){
                        order.put(
                            'dmpl__RoundOff__c', 
                            totalAmount.setScale(OrgSettingHelper.roundOffDigits(), RoundingMode.CEILING) - totalAmount);
                    } else if(OrgSettingHelper.roundOffType() == OrgSettingHelper.ROUNDOFFTYPE_FLOOR){
                        order.put(
                            'dmpl__RoundOff__c', 
                            totalAmount.setScale(OrgSettingHelper.roundOffDigits(), RoundingMode.FLOOR) - totalAmount);
                    }    
                }           
            }    
        }        
    }
}