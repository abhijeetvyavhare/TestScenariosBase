public with sharing class SKUDataHelper {
    public static dmpl__SKU__c createSKU(
        String name,
        Id itemId,
        String productColor,
        Boolean isDefault,
        String quantityUnitOfMeasure
    ) {
        return (dmpl__SKU__c) TestFactory.createSObject(
            new dmpl__SKU__c(
                Name = name,
                dmpl__ItemId__c = itemId,
                dmpl__ProductColor__c = productColor,
                dmpl__IsDefault__c = isDefault,
                dmpl__QuantityUnitOfMeasure__c = quantityUnitOfMeasure
            ),
            true
        );
    }

    public static dmpl__SKU__c getSKU(Id skuId) {
        return [
            SELECT Id,
                    Name,
                    dmpl__ItemId__c,
                    dmpl__ProductColor__c,
                    dmpl__IsDefault__c,
                    dmpl__QuantityUnitOfMeasure__c
            FROM dmpl__SKU__c
            WHERE Id = :skuId
            LIMIT 1
        ];
    }
}