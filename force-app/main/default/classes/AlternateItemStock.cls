/**
 * @description       : Class to represent Alternate Item Stock information
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-14-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class AlternateItemStock {
    @AuraEnabled public String AlternateType { get; set; }
    @AuraEnabled public String AlternateItemId { get; set; }
    @AuraEnabled public String AlternateItemName { get; set; }
    @AuraEnabled public String ItemId { get; set; }
    @AuraEnabled public String QuantityAvailable { get; set; }
    @AuraEnabled public String QuantityInHand { get; set; }
        
    // Default constructor (initializes empty values)
    public AlternateItemStock() {
        this.AlternateType = '';
        this.AlternateItemId = '';
        this.AlternateItemName = '';
        this.ItemId = '';
        this.QuantityAvailable = '';
        this.QuantityInHand = '';
    }
    
    // Parameterized constructor (for easier instantiation with actual data)
    public AlternateItemStock(String alternateType, String alternateItemId, String alternateItemName, String itemId, String quantityAvailable, String quantityInHand) {
        this.AlternateType = alternateType;
        this.AlternateItemId = alternateItemId;
        this.AlternateItemName = alternateItemName;
        this.ItemId = itemId;
        this.QuantityAvailable = quantityAvailable;
        this.QuantityInHand = quantityInHand;
    }
}