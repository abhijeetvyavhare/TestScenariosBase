public with sharing class ProductConfiguratorController {
    
    @AuraEnabled(cacheable = true)
    public static List<SObject> getConfigurableItems(String objectApiName, Id recordId)
    {
        switch on objectApiName {
            when  'dmpl__SaleOrder__c'{
                return querySaleOrderLines(recordId);
            }
            when  'dmpl__ServiceRequest__c'{
                return queryServiceRequestLines(recordId);
            }
            when  'dmpl__PurchaseOrder__c'{
                return queryPurchaseOrderLines(recordId);
            }
            when  'dmpl__SaleInvoice__c'{
                return querySaleInvoiceLines(recordId);
            }
            when 'dmpl__Quote__c'{
                return queryQuoteLines(recordId);
            }
            when else {
                return null;
            }
        }
    }

    @AuraEnabled(cacheable = true)
    public static List<PackageComponentLine> getPackageConfiguration(String objectApiName, Id recordId){
        switch on objectApiName {
            when  'dmpl__SaleOrder__c'{
                return PackageHelper.getSaleOrderPackageConfiguration(recordId);
            }
            when  'dmpl__ServiceRequest__c'{
                return PackageHelper.getServiceRequestPackageConfiguration(recordId);
            }
            when  'dmpl__PurchaseOrder__c'{
                return PackageHelper.getPurchaseOrderPackageConfiguration(recordId);
            }
            when  'dmpl__SaleInvoice__c'{
                return PackageHelper.getSaleInvoicePackageConfiguration(recordId);
            }
            when  'dmpl__Quote__c'{
                return PackageHelper.getQuotePackageConfiguration(recordId);
            }
            when else {
                return null;
            }
        }
    }

    @AuraEnabled(cacheable = true)
    public static List<PackageComponentLine> getItemPackageConfiguration(
        Id itemId, 
        Id SKUId, 
        Id partnerAccountId, 
        Id accountId, 
        Id branchId){
        return  PackageHelper.getPackageConfiguration(itemId, SKUId, partnerAccountId, accountId, branchId);
    }

    @AuraEnabled
    public static void applyPackageConfiguration(
        String objectApiName,    
        Id recordId, 
        List<PackageConfigLine> componentSettings){
            switch on objectApiName {
                when  'dmpl__SaleOrder__c'{
                    PackageHelper.applySaleOrderPackageConfiguration(recordId, componentSettings);
                }
                when  'dmpl__ServiceRequest__c'{
                    PackageHelper.applyServiceRequestPackageConfiguration(recordId, componentSettings);
                }
                when  'dmpl__PurchaseOrder__c'{
                    PackageHelper.applyPurchaseOrderPackageConfiguration(recordId, componentSettings);
                }
                when  'dmpl__SaleInvoice__c'{
                    PackageHelper.applySaleInvoicePackageConfiguration(recordId, componentSettings);
                }
                when  'dmpl__Quote__c'{
                    //System.debug('componentSettings '+componentSettings);
                    PackageHelper.applyQuotePackageConfiguration(recordId, componentSettings);
                }
                when else {
                    return;
                }
            }
    }
    
    private static List<dmpl__ServiceRequestLine__c> queryServiceRequestLines(Id recordId){
        SecurityHelper.ensureCanReadFields(new List<String>{
            'dmpl__ItemId__c',
            'dmpl__SKUId__c'
        },'dmpl__ServiceRequestLine__c');
        return [SELECT 
                    Id, 
                    Name, 
                    dmpl__ItemId__c, 
                    dmpl__ItemId__r.Name,
                    dmpl__SKUId__c,
                    dmpl__SKUId__r.Name
                FROM 
                    dmpl__ServiceRequestLine__c 
                WHERE
                    dmpl__ServiceRequestId__c =:recordId
                    AND dmpl__ItemId__r.dmpl__IsPackage__c = true];
    }

    private static List<dmpl__SaleOrderLine__c> querySaleOrderLines(Id recordId){
        SecurityHelper.ensureCanReadFields(new List<String>{
            'dmpl__ItemId__c',
            'dmpl__SKUId__c'
        },'dmpl__SaleOrderLine__c');
        return [SELECT 
                    Id, 
                    Name, 
                    dmpl__ItemId__c, 
                    dmpl__ItemId__r.Name,
                    dmpl__SKUId__c,
                    dmpl__SKUId__r.Name
                FROM 
                    dmpl__SaleOrderLine__c 
                WHERE
                    dmpl__SaleOrderId__c =:recordId
                    AND dmpl__ItemId__r.dmpl__IsPackage__c = true];
    }

    private static List<dmpl__PurchaseOrderLine__c> queryPurchaseOrderLines(Id recordId){
        SecurityHelper.ensureCanReadFields(new List<String>{
            'dmpl__ItemId__c',
            'dmpl__SKUId__c'
        },'dmpl__PurchaseOrderLine__c');
        return [SELECT 
                    Id, 
                    Name, 
                    dmpl__ItemId__c, 
                    dmpl__ItemId__r.Name,
                    dmpl__SKUId__c,
                    dmpl__SKUId__r.Name
                FROM 
                    dmpl__PurchaseOrderLine__c 
                WHERE
                    dmpl__PurchaseOrderId__c =:recordId
                    AND dmpl__ItemId__r.dmpl__IsPackage__c = true];
    }

    private static List<dmpl__SaleInvoiceLine__c> querySaleInvoiceLines(Id recordId){
        SecurityHelper.ensureCanReadFields(new List<String>{
            'dmpl__ItemId__c',
            'dmpl__SKUId__c'
        },'dmpl__SaleInvoiceLine__c');
        return [SELECT 
                    Id, 
                    Name, 
                    dmpl__ItemId__c, 
                    dmpl__ItemId__r.Name,
                    dmpl__SKUId__c,
                    dmpl__SKUId__r.Name
                FROM 
                    dmpl__SaleInvoiceLine__c 
                WHERE
                    dmpl__SaleInvoiceId__c =:recordId
                    AND dmpl__ItemId__r.dmpl__IsPackage__c = true];
    }

    private static List<dmpl__QuoteLine__c> queryQuoteLines(Id recordId){
        SecurityHelper.ensureCanReadFields(new List<String>{
            'dmpl__ItemId__c',
            'dmpl__SKUId__c'
        },'dmpl__QuoteLine__c');
        return [SELECT 
                Id, 
                Name, 
                dmpl__ItemId__c, 
                dmpl__ItemId__r.Name,
                dmpl__SKUId__c,
                dmpl__SKUId__r.Name
            FROM 
                dmpl__QuoteLine__c 
            WHERE
                dmpl__QuoteId__c =:recordId
                AND dmpl__ItemId__r.dmpl__IsPackage__c = true];
    }
}