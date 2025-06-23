public with sharing class  DocumentAmountTaxResult {
    @AuraEnabled
    public String TaxName {get; set;}
    
    @AuraEnabled
    public Object TaxAmount {get; set;}
    
    @AuraEnabled
    public String TaxGroupType {get; set;}

    public DocumentAmountTaxResult(
        String TaxGroupType, 
        String taxName, 
        Object taxAmount) {
            this.TaxGroupType = TaxGroupType;
            this.TaxName = taxName;
            this.TaxAmount = taxAmount;
    }

    public DocumentAmountTaxResult(AggregateResult ar) {
        //this.TaxGroupType = (String)ar.get('TaxGroupType');
        this.TaxName = (String)ar.get('TaxName');
        this.TaxAmount = ar.get('TaxAmount');
    }
}