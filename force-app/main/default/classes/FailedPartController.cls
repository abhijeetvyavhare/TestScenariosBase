public with sharing class FailedPartController {

    @AuraEnabled(cacheable=true)
    public static List<SObject> getJobCard(string relatedObjectApiName,string treatment, Id branchId){
        List<SObject> returnedLines=new List<SObject>();
        try {
            List<String> queryFields=new List<String>();
            queryFields.add('dmpl__Quantity__c');
            queryFields.add('dmpl__RepairOrderId__c');
            queryFields.add('dmpl__FailedItemTreatment__c');
            queryFields.add('dmpl__FailedItemDeliveredQuantity__c');
            queryFields.add('dmpl__ItemId__r.dmpl__FailedItemId__c');
            queryFields.add('dmpl__ItemId__r.Name');
            queryFields.add('dmpl__RepairOrderId__r.dmpl__BranchId__c');
            queryFields.add('dmpl__RepairOrderId__r.Name');
            string whereClause = '';
            string branch = branchId;
            whereClause = whereClause + ' WHERE dmpl__FailedItemTreatment__c=: treatment AND dmpl__RepairOrderId__r.dmpl__BranchId__c=: branchId';
            System.debug('where clause '+whereClause);
            String queryFieldsString = String.join(queryFields,',');
            String query = 'SELECT Id,'+queryFieldsString+' FROM '+relatedObjectApiName + whereClause;
            System.debug('query '+query);
            List<SObject> records=Database.query(query);
            for(SObject record : records){
                Integer failedQuantity=0;
                if(record.get('dmpl__FailedItemDeliveredQuantity__c')!=null){
                    failedQuantity=Integer.valueOf(record.get('dmpl__FailedItemDeliveredQuantity__c'));
                }
                if(Integer.valueOf(record.get('dmpl__Quantity__c')) > failedQuantity){
                    returnedLines.add(record);
                }

            }
            System.debug(returnedLines);
            System.debug(returnedLines.size());
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
        return returnedLines;
    }

    @AuraEnabled
    public static string updateDestination(List<dmpl__RepairOrderLine__c> repairOrderLines){
        String successMessage='Destination has been successfully updated';
        String errorMessage='Destination update failed';
        Boolean isUpdated=false;
        if(repairOrderLines.size()>0){
            try{
                update repairOrderLines;
                isUpdated=true;
            }catch(Exception e){
                System.debug('Error in updating destination' + e.getMessage());
                throw new AuraHandledException(e.getMessage());
            }
        }
        else{
            return errorMessage;
        }
        if(isUpdated){
            return successMessage;
        }else{
            return errorMessage;
        }
    }

    @AuraEnabled
    public static List<Id> createDeliveryOrderFromJobCard(String[] repairOrderLineIds,Id branchId,string treatment){
        System.debug(repairOrderLineIds);
        List<Id> deliveryOrderIds=new List<Id>();
        List<Id> repairOrderLineId = new List<Id>();
        for(String str :repairOrderLineIds){
            repairOrderLineId.add(Id.valueOf(str));
        }
        System.debug(repairOrderLineId);
        dmpl__Branch__c branch=[SELECT Id, dmpl__PartnerAccountId__c FROM dmpl__Branch__c WHERE Id=: branchId];
        List<dmpl__RepairOrderLine__c> repairOrderLines =[SELECT Id,
            Name,
            dmpl__Quantity__c,
            dmpl__RepairOrderId__c,
            dmpl__FailedItemTreatment__c,
            dmpl__RepairOrderId__r.dmpl__AccountId__c,
            dmpl__RepairOrderId__r.dmpl__BranchId__c,
            dmpl__FailedItemDeliveredQuantity__c,
            dmpl__ItemId__r.dmpl__FailedItemId__c,
            dmpl__ItemId__r.dmpl__ClaimToAccountId__c
            FROM dmpl__RepairOrderLine__c
            WHERE Id IN :repairOrderLineId
            ];
        Map<Id,list<dmpl__RepairOrderLine__c>> AccountToRepairOrderLines=new Map<Id,list<dmpl__RepairOrderLine__c>>();
        Map<Id,Id> AccountToDO = new Map<Id,Id>();
        List<dmpl__DeliveryOrder__c>  deliveryOrdersToInsert = new List<dmpl__DeliveryOrder__c>(); 
        for(dmpl__RepairOrderLine__c record : repairOrderLines){
            if(!AccountToRepairOrderLines.containsKey(record.dmpl__ItemId__r.dmpl__ClaimToAccountId__c)){
                AccountToRepairOrderLines.put(record.dmpl__ItemId__r.dmpl__ClaimToAccountId__c,new List<dmpl__RepairOrderLine__c>{record});
            }else{
                AccountToRepairOrderLines.get(record.dmpl__ItemId__r.dmpl__ClaimToAccountId__c).add(record);
            }
        }
        List<dmpl__DeliveryOrder__c> deliveryOrders = new List<dmpl__DeliveryOrder__c>();
        for(Id recordId:AccountToRepairOrderLines.keyset()){
            dmpl__DeliveryOrder__c deliveryOrder=new dmpl__DeliveryOrder__c();
            deliveryOrder.dmpl__AccountId__c = recordId;           
            deliveryOrder.dmpl__BranchId__c = branchId;           
            deliveryOrder.dmpl__FailedItemTreatment__c = treatment;
            deliveryOrder.dmpl__PartnerAccountId__c= branch.dmpl__PartnerAccountId__c;
            deliveryOrdersToInsert.add(deliveryOrder);           
        }
        if(!deliveryOrdersToInsert.IsEmpty()){
            insert deliveryOrdersToInsert;
        }

        List<dmpl__DeliveryOrderLine__c> deliveryOrderLineToInsert=new List<dmpl__DeliveryOrderLine__c>();
        List<dmpl__RepairOrderLine__c> repairOrderLineToUpdate=new List<dmpl__RepairOrderLine__c>();

        for(dmpl__DeliveryOrder__c record : deliveryOrdersToInsert){
            Id supplierId=record.dmpl__AccountId__c;
            for(dmpl__RepairOrderLine__c line: AccountToRepairOrderLines.get(supplierId)){
                deliveryOrderLineToInsert.add(new dmpl__DeliveryOrderLine__c(
                    dmpl__DeliveryId__c=record.Id,
                    dmpl__Quantity__c=line.dmpl__Quantity__c,
                    dmpl__originalItemId__c=line.dmpl__ItemId__c,
                    dmpl__ItemId__c=line.dmpl__ItemId__r.dmpl__FailedItemId__c
                ));
                line.dmpl__FailedItemDeliveredQuantity__c=line.dmpl__Quantity__c;
                repairOrderLineToUpdate.add(line);
            }
        }
        if(!deliveryOrderLineToInsert.isEmpty() || deliveryOrderLineToInsert!=null){
            try{
                insert deliveryOrderLineToInsert;
            }catch(Exception e){
                System.debug('Error in inserting delivery order lines' + e.getMessage());
                throw new AuraHandledException(e.getMessage());
            }
        }
        if(!repairOrderLineToUpdate.isEmpty() || repairOrderLineToUpdate!=null){
            try{
                update repairOrderLineToUpdate;
            }catch(Exception e){
                System.debug('Error in updating destination repair order lines' + e.getMessage());
                throw new AuraHandledException(e.getMessage());
            }
        }
        deliveryOrderIds=DocumentHelper.extractIds(deliveryOrdersToInsert);
        return deliveryOrderIds;
    }
}