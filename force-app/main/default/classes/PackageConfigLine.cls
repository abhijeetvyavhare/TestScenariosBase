public with sharing class PackageConfigLine {

    @AuraEnabled
    public Id Id { get; set; }

    @AuraEnabled
    public Boolean isSelected { get; set; }

    @AuraEnabled
    public Decimal quantity { get; set; }

}