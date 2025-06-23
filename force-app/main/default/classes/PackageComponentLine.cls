public with sharing class PackageComponentLine {
    public PackageComponentLine(dmpl__ItemComponent__c itemComponent) {
        this.Id = itemComponent.Id;
        this.ItemId = itemComponent.dmpl__ItemId__c;
        this.ApplicableFor = itemComponent.dmpl__ApplicableFor__c;
        this.ComponentItemId = itemComponent.dmpl__ComponentItemId__c;
        this.ComponentItemCode = itemComponent.dmpl__ComponentItemId__r?.dmpl__ItemCode__c;
        this.ComponentItemDescription = itemComponent.dmpl__ComponentItemId__r?.dmpl__Description__c;
        this.ComponentItemName = itemComponent.dmpl__ComponentItemId__r?.Name;
        this.ComponentSKUId = itemComponent.dmpl__ComponentSKUId__c;
        this.ComponentSKUName = itemComponent.dmpl__ComponentSKUId__r?.Name;
        this.FeatureId = itemComponent.dmpl__FeatureId__c;
        this.FeatureName = itemComponent.dmpl__FeatureId__r?.Name;
        this.FeatureFeatureGroup = itemComponent.dmpl__FeatureId__r?.dmpl__FeatureGroup__c;
        this.FeatureMaxComponentCount = itemComponent.dmpl__FeatureId__r?.dmpl__MaxComponentCount__c;
        this.FeatureMinComponentCount = itemComponent.dmpl__FeatureId__r?.dmpl__MinComponentCount__c;
        this.FeatureShowinCatalog = itemComponent.dmpl__FeatureId__r?.dmpl__ShowinCatalog__c;
        this.FeatureSortOrder = itemComponent.dmpl__FeatureId__r?.dmpl__SortOrder__c;
        this.IsBundled = itemComponent.dmpl__IsBundled__c;
        this.IsMandatory = itemComponent.dmpl__IsMandatory__c;
        this.IsQuantityEditable = itemComponent.dmpl__IsQuantityEditable__c;
        this.IsSelected = itemComponent.dmpl__IsSelected__c;
        this.SKUId = itemComponent.dmpl__SKUId__c;
        this.MaxQuantity = itemComponent.dmpl__MaxQuantity__c;
        this.MinQuantity = itemComponent.dmpl__MinQuantity__c;
        this.PackageType = itemComponent.dmpl__PackageType__c;
        this.Quantity = itemComponent.dmpl__Quantity__c;
        this.SortOrder = itemComponent.dmpl__SortOrder__c;
        this.PartnerAccountId = itemComponent.dmpl__PartnerAccountId__c;
        this.PartnerAccountGroupId = itemComponent.dmpl__PartnerAccountGroupId__c;
    }

    @AuraEnabled
    public Id Id { get; set; }

    @AuraEnabled
    public Id ItemId { get; set; }

    @AuraEnabled
    public String ApplicableFor { get; set; }
    
    @AuraEnabled
    public Id ComponentItemId { get; set; }
    
    @AuraEnabled
    public String ComponentItemCode { get; set; }
    
    @AuraEnabled
    public String ComponentItemDescription { get; set; }
    
    @AuraEnabled
    public String ComponentItemName { get; set; }
    
    @AuraEnabled
    public Id ComponentSKUId { get; set; }
    
    @AuraEnabled
    public String ComponentSKUName { get; set; }
    
    @AuraEnabled
    public Id FeatureId { get; set; }

    @AuraEnabled
    public String FeatureName { get; set; }
    
    @AuraEnabled
    public String FeatureFeatureGroup { get; set; }
    
    @AuraEnabled
    public Decimal FeatureMaxComponentCount { get; set; }
    
    @AuraEnabled
    public Decimal FeatureMinComponentCount { get; set; }
    
    @AuraEnabled
    public Boolean FeatureShowinCatalog { get; set; }
    
    @AuraEnabled
    public Decimal FeatureSortOrder { get; set; }
    
    @AuraEnabled
    public Boolean IsBundled { get; set; }
    
    @AuraEnabled
    public Boolean IsMandatory { get; set; }
    
    @AuraEnabled
    public Boolean IsQuantityEditable { get; set; }
    
    @AuraEnabled
    public Boolean IsSelected { get; set; }
    
    @AuraEnabled
    public Id SKUId { get; set; }
    
    @AuraEnabled
    public Decimal MaxQuantity { get; set; }
    
    @AuraEnabled
    public Decimal MinQuantity { get; set; }
    
    @AuraEnabled
    public String PackageType { get; set; }
    
    @AuraEnabled
    public Decimal Quantity { get; set; }
    
    @AuraEnabled
    public Decimal SortOrder { get; set; }
    
    @AuraEnabled
    public Id PartnerAccountId { get; set; }
    
    @AuraEnabled
    public Id PartnerAccountGroupId { get; set; }

    @AuraEnabled
    public Decimal StockInHand { get; set; }

    @AuraEnabled
    public Decimal StockAvailable { get; set; }

    @AuraEnabled
    public Decimal UnitPrice { get; set; }
}