public with sharing class StockPanelController {
    public StockPanelController() {

    }

    @AuraEnabled
    public static CreateRelatedResult createPurchaseOrder(
        string objectApiName,
        Id hostId,
        Id branchId,
        Id partnerAccountId){
            return null;
        }

    @AuraEnabled
    public static CreateRelatedResult createStockTransfer(
        string objectApiName,
        Id hostId,
        Id branchId){
            if(objectApiName == 'dmpl__SaleOrder__c'){
                throw new DMPLException('Not supported.');
                // return StockTransfer.createInStockFulfillmentFromSaleOrder(
                //     hostId,
                //     branchId);
            }else{
                throw new DMPLException('Not supported.');
            }
        }

    @AuraEnabled
    public static CreateRelatedResult createFulfilmentOrder(
        string objectApiName,
        Id hostId){
            if(objectApiName == 'dmpl__SaleOrder__c'){
                throw new DMPLException('Not supported.');
                //return FulfillmentHelper.createInStockFulfillmentFromSaleOrder(hostId);
            }else{
                throw new DMPLException('Not supported.');
            }
        }
}