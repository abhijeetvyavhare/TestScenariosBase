public with sharing class QuickAddPanelController {
    @AuraEnabled(cacheable = true)
    public static List<FieldsetFieldInfo> getFieldsByFieldSetName(String objectApiName, String fieldSetName)
    {
        String fsName = fieldSetName.toLowerCase();
        List<FieldsetFieldInfo> fsFields = new List<FieldsetFieldInfo>();
        System.Type objectType = Type.forName(objectApiName);
        if(objectType==null){
            return fsFields;
        }
        Map<String, Schema.FieldSet> fsMap = ((SObject)objectType.newInstance()).getSObjectType().getDescribe().FieldSets.getMap();
        if(fsMap == null || !fsMap.containsKey(fsName)){
            return fsFields;
        }
        for(Schema.FieldSetMember memberField: fsMap.get(fsName).getFields()){
            FieldsetFieldInfo fsField = new FieldsetFieldInfo(memberField);
            fsFields.add(fsField);
        }
        return fsFields;
    }

    @AuraEnabled(cacheable = true)
    public static List<AggregateResult> getItemStock(Id itemId, Id partnerId, Id branchId)
    {
        return ItemController.getItemStock(itemId, partnerId, branchId);
    }

    @AuraEnabled(cacheable = true)
    public static List<AggregateResult> getItemAlternateStock(Id itemId, Id partnerId, Id branchId)
    {
        return ItemController.getItemAlternateStock(itemId, partnerId, branchId);
    }

    @AuraEnabled(cacheable = true)
    public static Map<Id,String> getAlternateItemTypes(Id itemId)
    {
        return ItemController.getAlternateItemTypes(itemId);
    }

    @AuraEnabled(cacheable = true)
    public static List<AggregateResult> getItemSKUStock(Id itemId, Id partnerId, Id branchId)
    {
        return ItemController.getItemSKUStock(itemId, partnerId, branchId);
    }

    @AuraEnabled(cacheable = true)
    public static List<AggregateResult> getItemSKUBranchStock(Id itemId, Id SKUId, Id partnerId)
    {
        return ItemController.getItemSKUBranchStock(itemId, SKUId, partnerId);
    }

    @AuraEnabled(cacheable = true)
    public static List<AggregateResult> getItemLotTypeStock(Id itemId, Id itemLotTypeId, Id branchId)
    {
        return ItemController.getItemLotTypeStock(itemId, itemLotTypeId, branchId);
    }

    @AuraEnabled(cacheable = true)
    public static List<AggregateResult> getItemLotTypesStock(Id itemId, Id branchId)
    {
        return ItemController.getItemLotTypesStock(itemId, branchId);
    }
    
    @AuraEnabled(cacheable = true)
    public static Id getTaxGroup(Id itemId, Id SKUId, Id partnerId, Id branchId, Date pricingDate, String taxSupplyType){
        return TaxGroupHelper.getApplicableTaxGroup(partnerId, branchId, itemId, SKUId, pricingDate, taxSupplyType);
    }

    @AuraEnabled(cacheable = true)
    public static Double getItemPrice(Id itemId, Id SKUId, Id priceListId, Date pricingDate){
        Double price = PriceListHelper.getApplicablePrice(priceListId, itemId, SKUId, pricingDate);
        return price;
    }

    @AuraEnabled(cacheable = true)
    public static Double getItemDiscount(Id itemId, Id SKUId, Id discountGroupId, Date documentDate){
        return DiscountGroupHelper.getApplicableDiscount(discountGroupId, itemId, SKUId, documentDate);
    }
}