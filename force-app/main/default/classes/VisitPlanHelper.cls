@namespaceAccessible
public with sharing class VisitPlanHelper {

    private static final string OBJECT_VISITPLAN = 'dmpl__VisitPlan__c';
    private static final string OBJECT_VISIT = 'dmpl__Visit__c';
    private static final string OBJECT_VISITROUTE= 'dmpl__VisitRoute__c';
    private static final string OBJECT_VISITROUTESTOP= 'dmpl__VisitRouteStop__c';
    private static final string FIELD_VISITROUTEID = 'dmpl__VisitRouteId__c';
    private static Map<Id, dmpl__VisitRoute__c> visitRoutes;

    public static void validateData(
        Boolean isInsert, 
        Boolean isUpdate, 
        Boolean isDelete, 
        List<dmpl__VisitPlan__c> newEntries, 
        List<dmpl__VisitPlan__c> oldEntries)
    {
        try {
            if(isInsert){
                FieldMappingHelper.copyFieldMappingData(
                    newEntries);
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }
    
    public static void postData(
        Boolean isInsert, 
        Boolean isUpdate, 
        Boolean isDelete, 
        List<dmpl__VisitPlan__c> newEntries, 
        List<dmpl__VisitPlan__c> oldEntries)
    {
        if(isInsert){
            populateVisitRouteDefaults(
                DocumentHelper.getObjectsWithNotNull(
                    newEntries, 
                    FIELD_VISITROUTEID));
        }
        if(isUpdate){
            populateVisitRouteDefaults(
                DocumentHelper.getModifiedNewObjects(
                    FIELD_VISITROUTEID, 
                    oldEntries, 
                    newEntries));
        }
    }

    public static void afterPostData(
        Boolean isInsert, 
        Boolean isUpdate, 
        Boolean isDelete, 
        List<dmpl__VisitPlan__c> newEntries, 
        List<dmpl__VisitPlan__c> oldEntries){
        if(isInsert){
            createVisitsFromVisitRouteStops(
                DocumentHelper.getObjectsWithNotNull(
                    newEntries, 
                    FIELD_VISITROUTEID));
            createVisitsFromAccountGroups(
                DocumentHelper.getObjectsWithNotNull(
                    newEntries, 
                    'dmpl__AccountGroupId__c'));
            createVisitsFromDO(
                newEntries);
            // populateVisitAccountGroup(
            //     DocumentHelper.getObjectsWithNotNull(
            //         newEntries, 
            //         'dmpl__PinCode__c'));
            // populateVisitAccountGroup(
            //     DocumentHelper.getObjectsWithNotNull(
            //         newEntries, 
            //         'dmpl__City__c'));
            // populateVisitAccountGroup(
            //     DocumentHelper.getObjectsWithNotNull(
            //         newEntries, 
            //         'dmpl__State__c'));
            // populateVisitAccountGroup(
            //     DocumentHelper.getObjectsWithNotNull(
            //         newEntries, 
            //         'dmpl__PendingDeliveryCheckouts__c'));
            // populateVisitAccountGroup(
            //     DocumentHelper.getObjectsWithNotNull(
            //         newEntries, 
            //         'dmpl__PendingDeliveryOrders__c'));
        }
        if (isUpdate){
            createVisitsFromVisitRouteStops(
                DocumentHelper.getModifiedNewObjects(
                    FIELD_VISITROUTEID, 
                    oldEntries, 
                    newEntries));
            createVisitsFromAccountGroups(
                DocumentHelper.getModifiedNewObjects(
                    'dmpl__AccountGroupId__c', 
                    oldEntries, 
                    newEntries));
            createVisitsFromDO(
                DocumentHelper.getModifiedNewObjects(
                    new List<String>{
                        'dmpl__VisitPurpose__c', 
                        'dmpl__PlanStartDate__c',
                        'dmpl__PlanEndDate__c'
                    },
                    oldEntries, 
                    newEntries));
        }
    }

    public static HeadlessActionResult optimiseRoute(
        Id planId){
            // List<dmpl__Visit__c> existingVisits = queryVisits(
            //     new List<Id>{ planId });


        return new HeadlessActionResult(true, 'Routing Optimised.');
    }

    public static HeadlessActionResult clearRoutes(
        Id planId){
        List<dmpl__Visit__c> existingVisits = queryVisits(
            new List<Id>{ planId });
       
        if(existingVisits.size() > 0){
            DELETE existingVisits;
        }
        return new HeadlessActionResult(true, 'Routes Cleared.');
    }

    private static void insertVisits(List<dmpl__Visit__c> insertVisits){
        if(insertVisits?.size() == 0){
            return;
        }
        try
        {
            SecurityHelper.ensureCanCreateObject(OBJECT_VISIT);
            SecurityHelper.ensureCanWriteFields(new String[]{
                'dmpl__AccountId__c'
                ,'dmpl__GeofencingTolerance__c'
                ,'dmpl__StartTime__c'
                ,'dmpl__EndTime__c'
                ,'dmpl__SequenceNumber__c'
                ,'dmpl__VisitPurpose__c'
                ,'dmpl__VisitRouteStopId__c'
                ,'dmpl__VisitTaskTemplateId__c'
            }, OBJECT_VISIT);
            INSERT insertVisits;
        }
        catch(Exception error)
        {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    private static void createVisitsFromVisitRouteStops(
        List<dmpl__VisitPlan__c> modifiedEntries){
        List<dmpl__Visit__c> insertVisits = new List<dmpl__Visit__c>();
        for(dmpl__VisitPlan__c lineEntry : modifiedEntries){
            dmpl__VisitRoute__c currentVisitRoute = visitRoutes.get(
                lineEntry.dmpl__VisitRouteId__c);
            if(currentVisitRoute != null 
                && currentVisitRoute.dmpl__VisitRouteStops__r.size() > 0){
                for(dmpl__VisitRouteStop__c visitRouteStop : currentVisitRoute.dmpl__VisitRouteStops__r){
                    insertVisits.add(
                        new dmpl__Visit__c(
                            dmpl__AccountId__c = visitRouteStop.dmpl__AccountId__c,
                            dmpl__GeofencingTolerance__c = visitRouteStop.dmpl__AllowedGeofencingTolerance__c,
                            dmpl__PlannedDate__c = lineEntry.dmpl__PlanStartDate__c?.date(),
                            dmpl__PlannedStartTime__c = visitRouteStop.dmpl__StartTime__c,
                            dmpl__PlannedEndTime__c = visitRouteStop.dmpl__EndTime__c,
                            dmpl__SequenceNumber__c = visitRouteStop.dmpl__SequenceNumber__c,
                            dmpl__VisitPlanId__c = lineEntry.Id,
                            dmpl__VisitPurpose__c = visitRouteStop.dmpl__VisitPurpose__c,
                            dmpl__VisitRouteStopId__c = visitRouteStop.Id,
                            dmpl__VisitTaskTemplateId__c = lineEntry.dmpl__VisitTaskTemplateId__c,
                            dmpl__AssignedLocation__latitude__s = visitRouteStop.dmpl__AccountLocation__latitude__s,
                            dmpl__AssignedLocation__longitude__s = visitRouteStop.dmpl__AccountLocation__longitude__s
                        )
                    );
                }
            }
        }
        insertVisits(insertVisits);
    }

    private static void createVisitsFromAccountGroups(
        List<dmpl__VisitPlan__c> modifiedEntries){
        List<dmpl__Visit__c> insertVisits = new List<dmpl__Visit__c>();
        List<dmpl__AccountGroupMember__c> agMemebers = queryAccountGroupMembers(
                DocumentHelper.extractIds(
                    modifiedEntries, 
                    'dmpl__AccountGroupId__c'));
        for(dmpl__VisitPlan__c lineEntry : modifiedEntries){
            for(dmpl__AccountGroupMember__c member : agMemebers){
                if(member.dmpl__AccountGroupId__c == lineEntry.dmpl__AccountGroupId__c){
                    insertVisits.add(
                        new dmpl__Visit__c(
                            dmpl__AccountId__c = member.dmpl__AccountId__c,
                            dmpl__VisitPlanId__c = lineEntry.Id,
                            dmpl__AssignedLocation__latitude__s = member.dmpl__AccountId__r?.dmpl__AccountLocation__latitude__s,
                            dmpl__AssignedLocation__longitude__s = member.dmpl__AccountId__r?.dmpl__AccountLocation__longitude__s,
                            dmpl__VisitTaskTemplateId__c = lineEntry.dmpl__VisitTaskTemplateId__c
                        )
                    );
                }
            }
        }
        insertVisits(insertVisits);
    }

    private static void createVisitsFromDO(
        List<dmpl__VisitPlan__c> modifiedEntries){
        List<dmpl__Visit__c> insertVisits = new List<dmpl__Visit__c>();
        for(dmpl__VisitPlan__c lineEntry : modifiedEntries){
            if(lineEntry.dmpl__VisitPurpose__c != 'Order Delivery'){
                continue;
            }
            List<dmpl__DeliveryOrder__c> orders = queryPendingDeliveryOrders(lineEntry);
            for(dmpl__DeliveryOrder__c order : orders){
                insertVisits.add(
                    new dmpl__Visit__c(
                        dmpl__AccountId__c = order.dmpl__AccountId__c,
                        dmpl__AssignedLocation__longitude__s = order.dmpl__DeliveryLocation__c == null ? 
                                order.dmpl__AccountId__r?.dmpl__AccountLocation__longitude__s : 
                                order.dmpl__DeliveryLocation__longitude__s,
                        dmpl__AssignedLocation__latitude__s = order.dmpl__DeliveryLocation__c == null ? 
                                order.dmpl__AccountId__r?.dmpl__AccountLocation__latitude__s : 
                                order.dmpl__DeliveryLocation__latitude__s,
                        dmpl__VisitPlanId__c = lineEntry.Id,
                        dmpl__VisitTaskTemplateId__c = lineEntry.dmpl__VisitTaskTemplateId__c,
                        dmpl__DeliveryOrderId__c = order.Id,
                        dmpl__VisitCity__c = order.dmpl__DeliveryCity__c,
                        dmpl__VisitCountry__c = order.dmpl__DeliveryCountry__c,
                        dmpl__VisitPostalCode__c = order.dmpl__DeliveryPostalCode__c,
                        dmpl__VisitRegion__c = order.dmpl__DeliveryRegion__c,
                        dmpl__VisitState__c = order.dmpl__DeliveryState__c,
                        dmpl__VisitStreet__c = order.dmpl__DeliveryStreet__c
                    )
                );
            }
        }

        insertVisits(insertVisits);
    }

    private static void populateVisitRouteDefaults(
        List<dmpl__VisitPlan__c> modifiedEntries){
        visitRoutes = new Map<Id, dmpl__VisitRoute__c>(
            queryVisitRoutes(
                DocumentHelper.extractIds(
                    modifiedEntries, 
                    FIELD_VISITROUTEID)));
        for(dmpl__VisitPlan__c lineEntry : modifiedEntries){
            dmpl__VisitRoute__c currentVisitRoute = visitRoutes.get(
                lineEntry.dmpl__VisitRouteId__c);
            if(currentVisitRoute != null){
                lineEntry.dmpl__PartnerAccountId__c = currentVisitRoute.dmpl__PartnerAccountId__c;
                lineEntry.dmpl__VisitPurpose__c = currentVisitRoute.dmpl__VisitPurpose__c;
                lineEntry.dmpl__VisitTaskTemplateId__c = currentVisitRoute.dmpl__VisitTaskTemplateId__c;
            }
        }
    }
   
    public static  List<dmpl__VisitPlan__c> createVisitPlanFromFieldSales(List<dmpl__FieldSales__c> lineEntries, List<dmpl__FieldSalesInvoice__c> fieldSaleInvoice) {
        List<dmpl__VisitPlan__c> insertEntries = new List<dmpl__VisitPlan__c>();
        
        for (dmpl__FieldSales__c lineEntry : lineEntries) {
            insertEntries.add(
                new dmpl__VisitPlan__c(
                    Name = String.valueOf(Date.today()),
                    dmpl__PlanStartDate__c = Date.today(),
                    dmpl__VisitPurpose__c = 'Order Delivery',
                    dmpl__AssignedResourceId__c = lineEntry.dmpl__ResourceId__c,
                    dmpl__PartnerAccountId__c = lineEntry.dmpl__PartnerAccountId__c,
                    dmpl__BranchId__c = lineEntry.dmpl__BranchId__c,
                    dmpl__VisitTaskTemplateId__c = lineEntry.dmpl__VisitTaskTemplateId__c,
                    dmpl__VisitRouteGroupId__c = lineEntry.dmpl__VisitRouteGroupId__c
                )
            );
        }
        
        if (!insertEntries.isEmpty()) {
            Insert insertEntries;
        }
        createRelatedVisits(insertEntries, fieldSaleInvoice);
        return insertEntries;
    }
    private static void createRelatedVisits(List<dmpl__VisitPlan__c> visitPlans, List<dmpl__FieldSalesInvoice__c> fieldSaleInvoice) {
        Map<Id,fieldSalesInvoice__c> fieldSaleInvoiceMap = new Map<Id,fieldSalesInvoice__c>();
        List<dmpl__Visit__c> insertEntries = new List<dmpl__Visit__c>();
        for(dmpl__FieldSalesInvoice__c fSInvoice : fieldSaleInvoice) {
            fieldSaleInvoiceMap.put(fSInvoice.dmpl__AccountId__c,fSInvoice);
           }
        for(Id partnerAccountId : fieldSaleInvoiceMap.keySet()) {
            for(dmpl__VisitPlan__c visitPlan : visitPlans) {
                
                    insertEntries.add(new dmpl__Visit__c(
                        dmpl__AccountId__c = partnerAccountId,
                        dmpl__VisitPlanId__c = visitPlan.Id,
                        dmpl__PlannedDate__c = Date.today(),
                        dmpl__VisitPurpose__c = 'Order Delivery',
                        dmpl__BranchId__c = visitPlan.dmpl__BranchId__c,
                        dmpl__VisitStatus__c = 'Planned',
                        dmpl__PartnerAccountId__c = visitPlan.dmpl__PartnerAccountId__c,
                        dmpl__VisitTaskTemplateId__c = visitPlan.dmpl__VisitTaskTemplateId__c
                    ));
            
                    
    }
  }
  if(!insertEntries.isEmpty()) {
    Insert insertEntries;
    }
}


    
    @TestVisible
    private static List<dmpl__Visit__c> queryVisits(List<Id> visitPlanIds){
        SecurityHelper.ensureCanReadFields(new String[]{
            'Name'
            }, OBJECT_VISIT);
        return [
            SELECT
            Id, Name
            FROM dmpl__Visit__c
            WHERE dmpl__VisitPlanId__c IN : visitPlanIds
        ];
    }

    private static List<dmpl__VisitRoute__c> queryVisitRoutes(List<Id> visitRouteIds){
            SecurityHelper.ensureCanReadFields(new String[]{
            'Name',
            'dmpl__AccountGroupId__c',
            'dmpl__IsActive__c',
            'dmpl__PartnerAccountGroupId__c',
            'dmpl__PartnerAccountId__c',
            'dmpl__Remarks__c',
            'dmpl__RoutingPriority__c',
            'dmpl__VisitPurpose__c',
            'dmpl__VisitTaskTemplateId__c'
            }, OBJECT_VISITROUTE);
            SecurityHelper.ensureCanReadFields(new String[]{
                'dmpl__AccountId__c',
                'dmpl__AccountLocation__c',
                'dmpl__AccountLocation__Latitude__s',
                'dmpl__AccountLocation__Longitude__s',
                'dmpl__AllowedGeofencingTolerance__c',
                'dmpl__Duration__c',
                'dmpl__EndTime__c',
                'dmpl__Remarks__c',
                'dmpl__SequenceNumber__c',
                'dmpl__StartTime__c',
                'dmpl__VisitPurpose__c',
                'dmpl__VisitRouteId__c',
                'dmpl__VisitTaskTemplateId__c'
                }, OBJECT_VISITROUTESTOP);
            return [SELECT
            dmpl__AccountGroupId__c,
            dmpl__IsActive__c,
            dmpl__PartnerAccountGroupId__c,
            dmpl__PartnerAccountId__c,
            dmpl__Remarks__c,
            dmpl__RoutingPriority__c,
            dmpl__VisitPurpose__c,
            dmpl__VisitTaskTemplateId__c,
            Id,
            Name,
            (
                SELECT
                    dmpl__AccountId__c,
                    dmpl__AccountLocation__c,
                    dmpl__AccountLocation__Latitude__s,
                    dmpl__AccountLocation__Longitude__s,
                    dmpl__AllowedGeofencingTolerance__c,
                    dmpl__Duration__c,
                    dmpl__EndTime__c,
                    dmpl__Remarks__c,
                    dmpl__SequenceNumber__c,
                    dmpl__StartTime__c,
                    dmpl__VisitPurpose__c,
                    dmpl__VisitRouteId__c,
                    dmpl__VisitTaskTemplateId__c,
                    Id,
                    Name
                FROM
                    dmpl__VisitRouteStops__r
            )
        FROM
            dmpl__VisitRoute__c
        WHERE
            ID IN : visitRouteIds];
    }

    @namespaceAccessible
    public static List<dmpl__VisitPlan__c> getVisitPlan(Id recordId){
        SecurityHelper.ensureCanReadFields(new String[]{
            'Name'
        }, OBJECT_VISITPLAN);
        return [SELECT Id,
            Name,
            dmpl__AcceptanceStatus__c,
            dmpl__PartnerAccountId__c,
            (
                SELECT Id,
                    Name,
                    dmpl__GeofencingVariance__c,
                    dmpl__SequenceNumber__c,
                    dmpl__AssignedLocation__c,
                    dmpl__GeofencingTolerance__c,
                    dmpl__AccountId__c,
                    dmpl__AccountId__r.Name,
                    dmpl__PlannedDate__c,
                    dmpl__PlannedStartTime__c,
                    dmpl__PlannedEndTime__c,
                    dmpl__PlannedDuration__c,
                    dmpl__DocumentDate__c,
                    dmpl__StartTime__c,
                    dmpl__EndTime__c,
                    dmpl__VisitDuration__c,
                    dmpl__VisitLocation__c,
                    dmpl__VisitStatus__c,
                    dmpl__VisitTimeDeviation__c
                FROM 
                    dmpl__Visits__r
                ORDER BY 
                    dmpl__SequenceNumber__c
            )
        FROM 
            dmpl__VisitPlan__c
        WHERE Id =: recordId];
    }

    private static List<dmpl__AccountGroupMember__c> queryAccountGroupMembers(List<Id> agIds){
        return [SELECT 
            Id,
            dmpl__AccountId__c,
            dmpl__AccountId__r.dmpl__AccountLocation__c,
            dmpl__AccountId__r.dmpl__AccountLocation__Latitude__s,
            dmpl__AccountId__r.dmpl__AccountLocation__Longitude__s,
            dmpl__AccountGroupId__c
            FROM dmpl__AccountGroupMember__c
            WHERE dmpl__AccountGroupId__c IN :agIds 
            ];
    }

   	@TestVisible
    private static List<dmpl__DeliveryOrder__c> queryPendingDeliveryOrders(dmpl__VisitPlan__c plan){
        return [SELECT 
                Id,
                dmpl__ScheduledDeliveryDateTime__c,
                dmpl__AccountId__c,
                dmpl__DeliveryCity__c,
                dmpl__DeliveryCountry__c,
                dmpl__DeliveryDate__c,
                dmpl__DeliveryState__c,
                dmpl__DeliveryStreet__c,
                dmpl__DeliveryPostalCode__c,
                dmpl__AccountId__r.dmpl__AccountLocation__Latitude__s,
                dmpl__AccountId__r.dmpl__AccountLocation__Longitude__s,
                dmpl__DeliveryLocation__c,
                dmpl__DeliveryRegion__c,
                dmpl__DeliveryLocation__Latitude__s,
                dmpl__DeliveryLocation__Longitude__s
            FROM 
                dmpl__DeliveryOrder__c
            WHERE
                (
                    (dmpl__ScheduledDeliveryDateTime__c = null) 
                    OR ( dmpl__ScheduledDeliveryDateTime__c >= :plan.dmpl__PlanStartDate__c
                    AND dmpl__ScheduledDeliveryDateTime__c <= :plan.dmpl__PlanEndDate__c))
                AND dmpl__PartnerAccountId__c = :plan.dmpl__PartnerAccountId__c
                AND dmpl__BranchId__c =:plan.dmpl__BranchId__c
                AND dmpl__VisitId__c = null
                AND dmpl__IsDelivered__c != true
            ];
    }
}