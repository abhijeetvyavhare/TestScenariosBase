public with sharing class RepairOrderTimeSheetHelper {

    public static void postData(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__RepairOrderTimeSheet__c> oldEntries, List<dmpl__RepairOrderTimeSheet__c> newEntries)
    {
        if(isInsert || isUpdate)
            postTimeSheetRecords(isInsert, isDelete, isUpdate, oldEntries, newEntries);
    }

    public static void afterPostData(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__RepairOrderTimeSheet__c> oldEntries, List<dmpl__RepairOrderTimeSheet__c> newEntries)
    {
    	if(isUpdate)
        	updateRepairOrderLines(newEntries);
    }

    private static void postTimeSheetRecords(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__RepairOrderTimeSheet__c> oldEntries, List<dmpl__RepairOrderTimeSheet__c> newEntries)
    {
        setTimeSheetValues(isInsert, isUpdate, newEntries);
    }

    private static void setTimeSheetValues(Boolean isInsert, Boolean isUpdate, List<dmpl__RepairOrderTimeSheet__c> newEntries)
    {
        for(dmpl__RepairOrderTimeSheet__c lineEntry : newEntries)
        {
            if(isInsert)
            {
                lineEntry.dmpl__WorkStartDate__c = (lineEntry.dmpl__WorkStartDate__c == null && lineEntry.dmpl__WorkStarted__c) ? system.now() : lineEntry.dmpl__WorkStartDate__c;
                lineEntry.dmpl__WorkEndDate__c = (lineEntry.dmpl__WorkEndDate__c == null && lineEntry.dmpl__WorkEnded__c) ? system.now() : lineEntry.dmpl__WorkEndDate__c;
                if((lineEntry.dmpl__WorkStarted__c && lineEntry.dmpl__WorkEnded__c))
                    lineEntry.dmpl__RepairStatus__c = 'Completed';
                if(lineEntry.dmpl__WorkStarted__c && !lineEntry.dmpl__WorkPaused__c && !lineEntry.dmpl__WorkEnded__c)
                    lineEntry.dmpl__RepairStatus__c = 'Started';
                if(lineEntry.dmpl__WorkStarted__c && lineEntry.dmpl__WorkPaused__c && !lineEntry.dmpl__WorkEnded__c)
                    lineEntry.dmpl__RepairStatus__c = 'Paused';
            }
            else if(isUpdate)
            {
                if(lineEntry.dmpl__RepairStatus__c == 'Started')
                {
                    lineEntry.dmpl__WorkStarted__c = true;
                    lineEntry.dmpl__WorkStartDate__c = lineEntry.dmpl__WorkStartDate__c == null ? system.now() : lineEntry.dmpl__WorkStartDate__c; 
                }
                if(lineEntry.dmpl__RepairStatus__c == 'Completed')
                {
                    lineEntry.dmpl__WorkEnded__c = true;
                    lineEntry.dmpl__WorkEndDate__c = lineEntry.dmpl__WorkEndDate__c == null ? system.now() : lineEntry.dmpl__WorkEndDate__c; 
                }
                if(lineEntry.dmpl__RepairStatus__c == 'Paused')
                {
                    lineEntry.dmpl__WorkPaused__c = true;
                    lineEntry.dmpl__WorkEndDate__c = lineEntry.dmpl__WorkEndDate__c == null ? system.now() : lineEntry.dmpl__WorkEndDate__c; 
                }
            }
        }
    }
    
    @AuraEnabled
    public static void createTimeSheet(String repairOrderLineIds, String newRepairOrderTimeSheetId)
    {
        try{
            List<dmpl__RepairOrderTimeSheetLine__c> newTimeSheetLines = new List<dmpl__RepairOrderTimeSheetLine__c>();
            List<Id> lineIds = (List<Id>)repairOrderLineIds.split(',');
            Map<ID, dmpl__RepairOrderLine__c> repairOrderLines = queryRepairOrderLines(lineIds);
            dmpl__RepairOrderTimeSheet__c repairOrderTimeSheet = queryRepairOrderTimeSheet(newRepairOrderTimeSheetId);
            
            for(dmpl__RepairOrderLine__c orderLine : repairOrderLines.values())
        	{
                orderLine.dmpl__WorkStartedBy__c = repairOrderTimeSheet.dmpl__WorkStartDate__c;
                orderLine.dmpl__WorkEndedAt__c = repairOrderTimeSheet.dmpl__WorkEndDate__c;
                orderLine.dmpl__TechnicianId__c = repairOrderTimeSheet.dmpl__TechnicianId__c;
                orderLine.dmpl__WorkStatus__c = repairOrderTimeSheet.dmpl__RepairStatus__c;
                newTimeSheetLines.Add(new dmpl__RepairOrderTimeSheetLine__c(dmpl__RepairOrderTimeSheetId__c = repairOrderTimeSheet.Id,  dmpl__RepairOrderLineId__c = orderLine.Id));
        	}      
                   
        	if(newTimeSheetLines.size() > 0)
            	insert newTimeSheetLines;
            if(repairOrderLines.values().size() > 0)
            	update repairOrderLines.values();            
        } catch (Exception e) {
        	throw new DMPLException(e.getMessage());
    	}
    }

	@testVisible    
    private static dmpl__RepairOrderTimeSheet__c queryRepairOrderTimeSheet(Id recordId)
    {
        SecurityHelper.ensureCanReadFields(new String[]{
            'dmpl__ActualDurationHours__c',
            'dmpl__RepairOrderId__c',
            'dmpl__RepairOrderLine__c',
            'dmpl__RepairPauseReason__c',
            'dmpl__RepairStatus__c',
            'dmpl__StandardDurationHours__c',
            'dmpl__TechnicianId__c',
            'dmpl__WorkEndDate__c',
            'dmpl__WorkEnded__c',
            'dmpl__WorkPaused__c',
            'dmpl__WorkPauseDate__c',
            'dmpl__WorkRemarks__c',
            'dmpl__WorkStartDate__c',
            'dmpl__WorkStarted__c'
    },
    'dmpl__RepairOrderTimeSheet__c');

        return [SELECT
            CreatedById,
            CreatedDate,
            dmpl__ActualDurationHours__c,
            dmpl__ExternalId__c,
            dmpl__RepairOrderId__c,
            dmpl__RepairOrderLine__c,
            dmpl__RepairPauseReason__c,
            dmpl__RepairStatus__c,
            dmpl__StandardDurationHours__c,
            dmpl__TechnicianId__c,
            dmpl__WorkEndDate__c,
            dmpl__WorkEnded__c,
            dmpl__WorkPaused__c,
            dmpl__WorkPauseDate__c,
            dmpl__WorkRemarks__c,
            dmpl__WorkStartDate__c,
            dmpl__WorkStarted__c,
            Id,
            IsDeleted,
            LastModifiedById,
            LastModifiedDate,
            Name,
            SystemModstamp
        FROM
            dmpl__RepairOrderTimeSheet__c WHERE Id = : recordId LIMIT 1];
    }

    private static void updateRepairOrderLines(List<dmpl__RepairOrderTimeSheet__c> newEntries)
    {
        List<dmpl__RepairOrderTimeSheetLine__c> repairOrderTimeSheetLines = queryRepairOrderTimeSheetLines(DocumentHelper.extractIds(newEntries));
        Map<ID, dmpl__RepairOrderLine__c> repairOrderLines = queryRepairOrderLines(DocumentHelper.extractIds(repairOrderTimeSheetLines, 'dmpl__RepairOrderLineId__c'));
        
        for(dmpl__RepairOrderTimeSheet__c lineEntry : newEntries)
        {
            for(dmpl__RepairOrderTimeSheetLine__c repairOrderTimeSheetLine : repairOrderTimeSheetLines)
            {
                if(repairOrderTimeSheetLine.dmpl__RepairOrderTimeSheetId__c == lineEntry.Id)
                {
                    for(dmpl__RepairOrderLine__c repairOrderLine : repairOrderLines.values())
                    {
                        if(repairOrderTimeSheetLine.dmpl__RepairOrderLineId__c == repairOrderLine.Id)
                        {
                            repairOrderLine.dmpl__WorkStartedBy__c = lineEntry.dmpl__WorkStartDate__c;
                   			repairOrderLine.dmpl__WorkEndedAt__c = lineEntry.dmpl__WorkEndDate__c; 
                			repairOrderLine.dmpl__TechnicianId__c = lineEntry.dmpl__TechnicianId__c;
                			repairOrderLine.dmpl__WorkStatus__c = lineEntry.dmpl__RepairStatus__c;
                        }
                    }
                }
            }
        }
        
        if(repairOrderLines.size() > 0)
            SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__WorkStartedBy__c','dmpl__WorkEndedAt__c','dmpl__TechnicianId__c','dmpl__WorkStatus__c'}, 'dmpl__RepairOrderLine__c');
        	update repairOrderLines.values();
    }
    
    private static List<dmpl__RepairOrderTimeSheetLine__c> queryRepairOrderTimeSheetLines(List<Id> repairOrderTimeSheetIds)
    {
        SecurityHelper.ensureCanReadFields(new String[]{
            'dmpl__RepairOrderLineId__c',
            'dmpl__RepairOrderTimeSheetId__c'
    },
    'dmpl__RepairOrderTimeSheetLine__c');
        return [SELECT Id, Name, dmpl__RepairOrderLineId__c, dmpl__RepairOrderTimeSheetId__c FROM dmpl__RepairOrderTimeSheetLine__c WHERE dmpl__RepairOrderTimeSheetId__c IN : repairOrderTimeSheetIds];
    }

    private static Map<ID, dmpl__RepairOrderLine__c> queryRepairOrderLines(List<ID> workOrderLineIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__TechnicianId__c',
            'dmpl__WorkStartedBy__c',
            'dmpl__ItemId__c',
            'dmpl__WorkEndedAt__c',
            'dmpl__WorkStatus__c'
        }, 'dmpl__RepairOrderLine__c');
        return new Map<ID, dmpl__RepairOrderLine__c>(
            [SELECT
            ID,
            Name, 
            dmpl__TechnicianId__c,
            dmpl__WorkStartedBy__c,
            dmpl__ItemId__c,
            dmpl__WorkEndedAt__c,
            dmpl__WorkStatus__c
            FROM dmpl__RepairOrderLine__c
            WHERE ID IN : workOrderLineIds]
        );
    }
    
    @AuraEnabled
    public static List<dmpl__RepairOrderTimeSheet__c> queryRepairOrderTimeSheets(Id recordId)
    {
        SecurityHelper.ensureCanReadFields(new String[]{
            'dmpl__ActualDurationHours__c',
            'dmpl__RepairOrderId__c',
            'dmpl__RepairOrderLine__c',
            'dmpl__RepairPauseReason__c',
            'dmpl__RepairStatus__c',
            'dmpl__StandardDurationHours__c',
            'dmpl__TechnicianId__c',
            'dmpl__WorkEndDate__c',
            'dmpl__WorkEnded__c',
            'dmpl__WorkPaused__c',
            'dmpl__WorkPauseDate__c',
            'dmpl__WorkRemarks__c',
            'dmpl__WorkStartDate__c',
            'dmpl__WorkStarted__c'
    },
    'dmpl__RepairOrderTimeSheet__c');

    SecurityHelper.ensureCanReadFields(new String[]{
        'dmpl__ActionTaken__c',
        'dmpl__ActualDurationHours__c',
        'dmpl__AllocatedQuantity__c',
        'dmpl__AlternateItemId__c',
        'dmpl__Amount__c',
        'dmpl__CancelledQuantity__c',
        'dmpl__ClaimableQuantity__c',
        'dmpl__ComplaintCodeId__c',
        'dmpl__ComplaintFaultCodeId__c',
        'dmpl__Discount__c',
        'dmpl__DiscountAmount__c',
        'dmpl__ExternalId__c',
        'dmpl__HealthCheckRecommendationId__c',
        'dmpl__IncludedInPackage__c',
        'dmpl__InvoiceGroup__c',
        'dmpl__IsClaimed__c',
        'dmpl__IsInvoiced__c',
        'dmpl__IsPackageService__c',
        'dmpl__ItemId__c',
        'dmpl__ItemServiceContractId__c',
        'dmpl__MaintenanceSubType__c',
        'dmpl__MaintenanceType__c',
        'dmpl__OriginalItemId__c',
        'dmpl__PackageClassification__c',
        'dmpl__PostingType__c',
        'dmpl__PriceListRuleId__c',
        'dmpl__PurchaseOrderLineId__c',
        'dmpl__Quantity__c',
        'dmpl__RecommendationAmount__c',
        'dmpl__RecommendationType__c',
        'dmpl__RepairOrderId__c',
        'dmpl__SchemeDiscount__c',
        'dmpl__SchemeDiscountAmount__c',
        'dmpl__SchemeLineId__c',
        'dmpl__ServiceContractItemId__c',
        'dmpl__ServiceRecommendationId__c',
        'dmpl__SKUId__c',
        'dmpl__StandardDurationHours__c',
        'dmpl__StorageLocationId__c',
        'dmpl__TaxGroupId__c',
        'dmpl__TechnicianId__c',
        'dmpl__TimeLost__c',
        'dmpl__TimeSheetId__c',
        'dmpl__UnitPrice__c',
        'dmpl__UnitPrice2__c',
        'dmpl__WorkEndedAt__c',
        'dmpl__WorkStartedBy__c',
        'dmpl__WorkStatus__c'
},
'dmpl__RepairOrderLine__c');


        return [SELECT

    		dmpl__ActualDurationHours__c,
            dmpl__RepairOrderId__c,
            dmpl__RepairOrderLine__c,
            dmpl__RepairPauseReason__c,
            dmpl__RepairStatus__c,
            dmpl__StandardDurationHours__c,
            dmpl__TechnicianId__c,
            dmpl__TechnicianId__r.Name,
            dmpl__WorkEndDate__c,
            dmpl__WorkPaused__c,
            dmpl__WorkPauseDate__c,
            dmpl__WorkRemarks__c,
            dmpl__WorkStartDate__c,
            dmpl__WorkStarted__c,
            Id,
		    Name,
	    (
    	    SELECT
            dmpl__ActionTaken__c,
            dmpl__ActualDurationHours__c,
            dmpl__AllocatedQuantity__c,
            dmpl__AlternateItemId__c,
            dmpl__Amount__c,
            dmpl__CancelledQuantity__c,
            dmpl__ClaimableQuantity__c,
            dmpl__ComplaintCodeId__c,
            dmpl__ComplaintFaultCodeId__c,
            dmpl__Discount__c,
            dmpl__DiscountAmount__c,
            dmpl__ExternalId__c,
            dmpl__HealthCheckRecommendationId__c,
            dmpl__IncludedInPackage__c,
            dmpl__InvoiceGroup__c,
            dmpl__IsClaimed__c,
            dmpl__IsInvoiced__c,
            dmpl__IsPackageService__c,
            dmpl__ItemId__c,
            dmpl__ItemServiceContractId__c,
            dmpl__MaintenanceSubType__c,
            dmpl__MaintenanceType__c,
            dmpl__OriginalItemId__c,
            dmpl__PackageClassification__c,
            dmpl__PostingType__c,
            dmpl__PriceListRuleId__c,
            dmpl__PurchaseOrderLineId__c,
            dmpl__Quantity__c,
            dmpl__RecommendationAmount__c,
            dmpl__RecommendationType__c,
            dmpl__RepairOrderId__c,
            dmpl__SchemeDiscount__c,
            dmpl__SchemeDiscountAmount__c,
            dmpl__SchemeLineId__c,
            dmpl__ServiceContractItemId__c,
            dmpl__ServiceRecommendationId__c,
            dmpl__SKUId__c,
            dmpl__StandardDurationHours__c,
            dmpl__StorageLocationId__c,
            dmpl__TaxGroupId__c,
            dmpl__TechnicianId__c,
            dmpl__TimeLost__c,
            dmpl__TimeSheetId__c,
            dmpl__UnitPrice__c,
            dmpl__UnitPrice2__c,
            dmpl__WorkEndedAt__c,
            dmpl__WorkStartedBy__c,
            dmpl__WorkStatus__c,
            Id,
	        Name
		FROM
            dmpl__Repair_Order_Lines__r
    	),
    	(
        	SELECT          
            dmpl__ActualDurationHours__c,
            dmpl__ExternalId__c,
            dmpl__Item__c,
            dmpl__RepairOrderLineId__c,
            dmpl__RepairOrderTimeSheetId__c,
            dmpl__StandardDurationHours__c,
            Id,         
            Name
        FROM
            dmpl__Time_Sheet_Line__r
    	)
		FROM
    	dmpl__RepairOrderTimeSheet__c WHERE dmpl__RepairOrderId__c = : recordId OR Id = : recordId];
    }
    
    @AuraEnabled
    public static List<dmpl__RepairOrderLine__c> queryPendingRepairOrderLines(Id recordId)
    {
        SecurityHelper.ensureCanReadFields(new String[]{
            'dmpl__ItemId__c',
            'dmpl__RepairOrderId__c',
            'dmpl__SKUId__c'
    },
    'dmpl__RepairOrderLine__c');
    
        return [SELECT Id, Name,  dmpl__ItemId__c, dmpl__ItemId__r.Name FROM dmpl__RepairOrderLine__c WHERE (dmpl__WorkStatus__c = 'Paused' OR dmpl__WorkStatus__c = null OR dmpl__TechnicianId__c = null) AND dmpl__ItemId__r.dmpl__ItemType__c = 'Work Item' AND dmpl__RepairOrderId__c = : recordId];
    }

    

}