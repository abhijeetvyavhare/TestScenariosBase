public with sharing class VisitRouteSearchController {

    @AuraEnabled(cacheable=true)
    public static String getFieldSalesType(Id recordId) {
        try {
            return [SELECT Id, dmpl__PartnerAccountId__c, dmpl__Type__c 
                    FROM dmpl__FieldSales__c 
                    WHERE Id = :recordId]
                    .dmpl__Type__c;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<dmpl__VisitRoute__c> getAllRelatedVisitRoutes(String ObjectName, Id recordId) {
        List<dmpl__VisitRoute__c> route = new List<dmpl__VisitRoute__c>();

        if (ObjectName == 'dmpl__FieldSales__c') {
            List<dmpl__FieldSales__c> fieldSales = [
                SELECT Id, dmpl__VisitRouteGroupId__c 
                FROM dmpl__FieldSales__c 
                WHERE Id = :recordId 
                LIMIT 1
            ];
            if (!fieldSales.isEmpty()) {
                route = getRoutes(fieldSales[0].dmpl__VisitRouteGroupId__c);
            }
        }

        if (ObjectName == 'dmpl__VisitPlan__c') {
            List<dmpl__VisitPlan__c> visitPlanRecord = [
                SELECT Id, dmpl__VisitRouteGroupId__c 
                FROM dmpl__VisitPlan__c 
                WHERE Id = :recordId 
                LIMIT 1
            ];
            if (!visitPlanRecord.isEmpty()) {
                route = getRoutes(visitPlanRecord[0].dmpl__VisitRouteGroupId__c);
            }
        }

        return route;
    }

    @AuraEnabled
    public static void createVisit(
        List<Id> accountIds,
        Id planId, 
        List<Id> routeStopIds
    ) {
        List<dmpl__Visit__c> visitRecords = new List<dmpl__Visit__c>();

        List<dmpl__VisitPlan__c> plan = [SELECT Id, dmpl__PartnerAccountId__c, 
                                         dmpl__BranchId__c, dmpl__VisitPurpose__c 
                                         FROM dmpl__VisitPlan__c  
                                         WHERE Id = :planId 
                                         LIMIT 1];

        List<dmpl__VisitRouteStop__c> routeStops = [
            SELECT Id, Name, dmpl__AccountId__c, dmpl__VisitRouteId__c 
            FROM dmpl__VisitRouteStop__c
            WHERE dmpl__VisitRouteId__c IN :routeStopIds
        ];

        for (Id accountId : accountIds) {
            for (dmpl__VisitRouteStop__c routeStop : routeStops) {
                if (routeStop.dmpl__AccountId__c == accountId) {
                    dmpl__Visit__c visit = new dmpl__Visit__c();
                    visit.dmpl__AccountId__c = accountId;
                    visit.dmpl__VisitPlanId__c = planId;
                    visit.dmpl__BranchId__c = plan[0].dmpl__BranchId__c;
                    visit.dmpl__PartnerAccountId__c = plan[0].dmpl__PartnerAccountId__c;
                    visit.dmpl__VisitPurpose__c = plan[0].dmpl__VisitPurpose__c;
                    visitRecords.add(visit);
                }
            }
        }

        if (visitRecords.size() > 0) {
            insert visitRecords;
        }
    }

    @AuraEnabled
    public static void createFieldSalesInvoice(
        List<Id> accountIds,
        Id fieldSalesId,
        List<Id> routeIds,
        List<String> invoiceNumber
    ) {
        system.debug(accountIds);
        system.debug(fieldSalesId);
        List<dmpl__SaleInvoice__c> invoices = new List<dmpl__SaleInvoice__c>();
        List<dmpl__FieldSalesInvoice__c> fieldSaleInvoices = new List<dmpl__FieldSalesInvoice__c>();
        List<Id> itemIds = new List<Id>();

        List<dmpl__FieldSales__c> fieldSales = [
            SELECT Id, dmpl__PartnerAccountId__c, dmpl__BranchId__c, dmpl__Type__c 
            FROM dmpl__FieldSales__c 
            WHERE Id = :fieldSalesId
            LIMIT 1
        ];

        if (!fieldSales.isEmpty() && (fieldSales[0].dmpl__Type__c == 'Van Delivery' || fieldSales[0].dmpl__Type__c == 'Pre-Bill')) {
            invoices = queryInvoice(accountIds,invoiceNumber);

            for (dmpl__SaleInvoice__c invoice : invoices) {
                dmpl__FieldSalesInvoice__c fieldSalesInvoice = new dmpl__FieldSalesInvoice__c();
                fieldSalesInvoice.dmpl__FieldSalesId__c = fieldSalesId;
                fieldSalesInvoice.dmpl__InvoiceId__c = invoice.Id;
                fieldSalesInvoice.dmpl__AccountId__c = invoice.dmpl__AccountId__c;
                fieldSalesInvoice.dmpl__InvoiceAmount__c = invoice.dmpl__TotalAmount__c;
                fieldSaleInvoices.add(fieldSalesInvoice);
            }

            if (!fieldSaleInvoices.isEmpty()) {
                insert fieldSaleInvoices;
            }

            List<Id> invoiceIds = DocumentHelper.extractIds(fieldSaleInvoices, 'dmpl__InvoiceId__c');
            List<AggregateResult> invoiceLines = [
                SELECT dmpl__ItemId__c,dmpl__ItemLotId__c,dmpl__SKUId__c, SUM(dmpl__Quantity__c) quantity, 
                       SUM(dmpl__GrossAmount__c) amount
                FROM dmpl__SaleInvoiceLine__c
                WHERE dmpl__SaleInvoiceId__c IN :invoiceIds
                GROUP BY dmpl__ItemId__c,dmpl__ItemLotId__c,dmpl__SKUId__c
            ];

            for (AggregateResult invoiceLine : invoiceLines) {
                Id itemId = (Id) invoiceLine.get('dmpl__ItemId__c');
                if (itemId != null) itemIds.add(itemId);
            }

            List<dmpl__FieldSalesLine__c> fieldSalesInvoiceLines = new List<dmpl__FieldSalesLine__c>();
            List<dmpl__FieldSalesLine__c> existingFieldSalesInvoiceLines =[
                SELECT Id, dmpl__ItemId__c, dmpl__ItemLotId__c, dmpl__Quantity__c
                FROM dmpl__FieldSalesLine__c where dmpl__FieldSalesId__c =:fieldSalesId];
            Map<String, dmpl__FieldSalesLine__c> existingLinesMap = new Map<String, dmpl__FieldSalesLine__c>();

            for(dmpl__FieldSalesLine__c fsl :existingFieldSalesInvoiceLines){
                existingLinesMap.put((String)fsl.dmpl__ItemId__c + (string)fsl.dmpl__ItemLotId__c, fsl);
            }
            

            for (AggregateResult entry : invoiceLines){
                String matchedItems = (String) entry.get('dmpl__ItemId__c') + (String) entry.get('dmpl__ItemLotId__c');
                if(!existingLinesMap.containsKey(matchedItems)){
                fieldSalesInvoiceLines.add(new dmpl__FieldSalesLine__c(
                    dmpl__FieldSalesId__c = fieldSalesId,
                    dmpl__ItemId__c = (Id) entry.get('dmpl__ItemId__c'),
                    dmpl__Quantity__c = (Decimal) entry.get('quantity'),
                    dmpl__ItemLotId__c = (Id) entry.get('dmpl__ItemLotId__c'),
                    dmpl__SKUId__c = (Id) entry.get('dmpl__SKUId__c'),
                    dmpl__Amount__c = (Decimal) entry.get('amount')
                ));
            }
            else
            {
                dmpl__FieldSalesLine__c fsl = existingLinesMap.get(matchedItems);
                fsl.dmpl__Quantity__c = (Decimal) entry.get('quantity');
                fieldSalesInvoiceLines.add(fsl);
            }

            if (fieldSalesInvoiceLines.size() > 0) {
                Upsert fieldSalesInvoiceLines;
            }
        }
    }
}

    @AuraEnabled(cacheable=true)
public static List<invoiceWrapper> getAccounts(
    String recordId,
    String objectName,
    List<Id> visitRouteIds,
    String postalCode, 
    String city, 
    String state,
    String accountGroup,
    Date fromDate,
    Date toDate
) {
    List<invoiceWrapper> outlets = new List<invoiceWrapper>();
    Set<Id> routeSpecificAccountIds = new Set<Id>();
    Set<Id> memberSpecificAccountIds = new Set<Id>();

    if (!visitRouteIds.isEmpty()) {
        List<dmpl__VisitRoute__c> visitRoutes = getVisitRouteData(visitRouteIds);
        List<dmpl__AccountGroupMember__c> accountMember = getAccountGroupMembers(accountGroup); // queried the account member ids
        for (dmpl__VisitRoute__c route : visitRoutes) {
            for (dmpl__VisitRouteStop__c stop : route.dmpl__VisitRouteStops__r) {
                if (stop.dmpl__AccountId__c != null) {
                    routeSpecificAccountIds.add(stop.dmpl__AccountId__c);
                }
            }
        }

        System.debug('routeSpecificAccountIds '+routeSpecificAccountIds);


        // added the member ids to the set
        for(dmpl__AccountGroupMember__c agm :accountMember){
            if(agm.dmpl__AccountId__c != null){
                memberSpecificAccountIds.add(agm.dmpl__AccountId__c);
            }
        }

        System.debug('memberSpecificAccountIds '+memberSpecificAccountIds);

    }


    //  called the overloading fn added the memeberIDs
    List<dmpl__SaleInvoice__c> invoices = getSaleInvoices(
        memberSpecificAccountIds,
        routeSpecificAccountIds, 
        visitRouteIds, 
        postalCode, 
        city, 
        state,
        fromDate,
        toDate

    );

    for (dmpl__SaleInvoice__c invoice : invoices) {
        invoiceWrapper outlet = new invoiceWrapper();
        outlet.Id = invoice.dmpl__AccountId__c;
        outlet.Name = invoice.dmpl__AccountId__r.Name;
        outlet.BillingCity = invoice.dmpl__AccountId__r.dmpl__BillingCity__c;
        outlet.BillingState = invoice.dmpl__AccountId__r.dmpl__BillingState__c;
        outlet.BillingPincode = invoice.dmpl__AccountId__r.dmpl__BillingPostalCode__c;
        outlet.InvoiceNumber = invoice.Name;
        outlet.InvoiceAmount = invoice.dmpl__TotalAmount__c;
        outlet.InvoiceDate = invoice.dmpl__DocumentDate__c;
        outlet.InvoiceStatus = invoice.dmpl__Status__c;
        outlets.add(outlet);
    }

    return outlets;
}
     @TestVisible
    private static List<invoiceWrapper> getOutletsForVisitPlan(
        String recordId,
        Set<Id> routeSpecificAccountIds,
        List<Id> routeIds,
        String postalCode, 
        String city, 
        String state,
        Date fromDate,
        Date toDate
    ) {
        List<invoiceWrapper> outlets = new List<invoiceWrapper>();
        Set<Id> accountIds = new Set<Id>(routeSpecificAccountIds);

            List<dmpl__SaleInvoice__c> invoices = getSaleInvoices(
                routeSpecificAccountIds, 
                routeIds, 
                postalCode, 
                city, 
                state,
                fromDate,
                toDate
            );

            for (dmpl__SaleInvoice__c invoice : invoices) {
                invoiceWrapper outlet = new invoiceWrapper();
                outlet.Id = invoice.dmpl__AccountId__c;
                outlet.Name = invoice.dmpl__AccountId__r.Name;
                outlet.BillingCity = invoice.dmpl__AccountId__r.dmpl__BillingCity__c;
                outlet.BillingState = invoice.dmpl__AccountId__r.dmpl__BillingState__c;
                outlet.BillingPincode = invoice.dmpl__AccountId__r.dmpl__BillingPostalCode__c;
                outlet.InvoiceNumber = invoice.Name;
                outlet.InvoiceAmount = invoice.dmpl__TotalAmount__c;
                outlet.InvoiceDate = invoice.dmpl__DocumentDate__c;
                outlet.InvoiceStatus = invoice.dmpl__Status__c;
                outlets.add(outlet);
            }

        return outlets;
    }
    @TestVisible
    private static List<invoiceWrapper> getOutletsForFieldSales(
        String recordId,
        Set<Id> routeSpecificAccountIds,
        List<Id> routeIds,
        String postalCode, 
        String city, 
        String state,
        String accountGroup,
        Date fromDate,
        Date toDate
    ) {
        List<invoiceWrapper> outlets = new List<invoiceWrapper>();
        
        List<dmpl__FieldSales__c> fieldSalesRecords = getFieldSalesDocuments(recordId);

        if (!fieldSalesRecords.isEmpty() && (fieldSalesRecords[0].dmpl__Type__c == 'Van Delivery' || fieldSalesRecords[0].dmpl__Type__c == 'Pre-Bill')) {
            List<dmpl__SaleInvoice__c> invoices = getSaleInvoices(
                routeSpecificAccountIds, 
                routeIds, 
                postalCode, 
                city, 
                state,
                fromDate,
                toDate
            );

            for (dmpl__SaleInvoice__c invoice : invoices) {
                invoiceWrapper outlet = new invoiceWrapper();
                outlet.Id = invoice.dmpl__AccountId__c;
                outlet.Name = invoice.dmpl__AccountId__r.Name;
                outlet.BillingCity = invoice.dmpl__AccountId__r.dmpl__BillingCity__c;
                outlet.BillingState = invoice.dmpl__AccountId__r.dmpl__BillingState__c;
                outlet.BillingPincode = invoice.dmpl__AccountId__r.dmpl__BillingPostalCode__c;
                outlet.InvoiceNumber = invoice.Name;
                outlet.InvoiceAmount = invoice.dmpl__TotalAmount__c;
                outlet.InvoiceDate = invoice.dmpl__DocumentDate__c;
                outlet.InvoiceStatus = invoice.dmpl__Status__c;
                outlets.add(outlet);
            }
        }

        return outlets;
    }

    private static List<dmpl__VisitRoute__c> getRoutes(Id routeId) {
        Id currentUserPartnerAccountId = [ 
            SELECT dmpl__DefaultPartnerAccountId__c 
            FROM dmpl__Resource__c 
            WHERE dmpl__UserId__c = :UserInfo.getUserId()
            AND dmpl__IsActive__c = true
            LIMIT 1
        ].dmpl__DefaultPartnerAccountId__c;
    
        return [
            SELECT Id, Name, dmpl__PartnerAccountId__c, 
                   dmpl__EffectiveFrom__c, dmpl__EffectiveTo__c 
            FROM dmpl__VisitRoute__c 
            WHERE dmpl__VisitRouteGroupId__c = :routeId
            AND dmpl__IsActive__c = TRUE
            AND (dmpl__PartnerAccountId__c = :currentUserPartnerAccountId OR dmpl__PartnerAccountId__c = NULL)
        ];
    }

    private static List<dmpl__SaleInvoice__c> queryInvoice(List<Id> accountIds,List<String> invoiceNumber) {
        return [
            SELECT Id,dmpl__AccountId__c,dmpl__TotalAmount__c,dmpl__DocumentDate__c,dmpl__Status__c 
            FROM dmpl__SaleInvoice__c 
            WHERE dmpl__AccountId__c IN :accountIds 
            AND Name IN:invoiceNumber
            AND dmpl__FieldSalesId__c = null
        ];
    }
    @TestVisible
    private static List<dmpl__FieldSales__c> getFieldSalesDocuments(
        Id recordId
    ){
        return [SELECT Id, dmpl__PartnerAccountId__c, dmpl__Type__c 
        FROM dmpl__FieldSales__c 
        WHERE Id = :recordId];
    }
     @TestVisible
    private static List<dmpl__VisitPlan__c> getVisitPlanDocuments(
        Id recordId
    ){
        return [SELECT 
                dmpl__PartnerAccountId__c 
            FROM dmpl__VisitPlan__c 
            WHERE Id =:recordId];
    }

   private static List<dmpl__VisitRoute__c> getVisitRouteData(List<Id> routeIds) {
    return [SELECT Id,
                   Name,
                   (SELECT Id,
                           Name,
                           dmpl__AccountId__c
                    FROM dmpl__VisitRouteStops__r)
            FROM dmpl__VisitRoute__c 
            WHERE Id IN :routeIds];
}
    @TestVisible
    private static List<Account> queryAccounts(
        List<Id> accountIds,
        String postalCode, 
        String city, 
        String state
    ){
        string query = 'SELECT Id, '
        +'Name, '
        +'dmpl__BillingPostalCode__c, '
        +'dmpl__BillingCity__c, '
        +'dmpl__BillingState__c '
        +'FROM Account ';

        string whereClause = '';
        if(accountIds.size() > 0){
            whereClause += ' WHERE Id IN :accountIds ';
        }
        if(postalCode != null && postalCode != ''){
            if(whereClause != null && whereClause != ''){
                whereClause += ' AND dmpl__BillingPostalCode__c = :postalCode ';
            }else{
                whereClause += ' WHERE dmpl__BillingPostalCode__c = :postalCode ';
            }
        }
        if(city != null && city != ''){
            if(whereClause != null && whereClause != ''){
                whereClause += ' AND dmpl__BillingCity__c = :city ';
            }else{
                whereClause += ' WHERE dmpl__BillingCity__c = :city ';
            }
        }
        if(state != null && state != ''){
            if(whereClause != null && whereClause != ''){
                whereClause += ' AND dmpl__BillingState__c = :state ';
            }else{
                whereClause +=  ' WHERE dmpl__BillingState__c = :state ';
            }
        }
        query += whereClause;
        system.debug('acc query '+query);
        return Database.query(query);
    }
    @TestVisible
    private static List<dmpl__SaleInvoice__c> getSaleInvoices(
        Set<Id> accountIds,
        List<Id> routeIds,
        String postalCode, 
        String city, 
        String state,
        Date fromDate,
        Date toDate
    ){
        string query = 'SELECT Id, '
        +'Name, '
        +'dmpl__TotalAmount__c, '
        +'dmpl__AccountId__c, '
        +'dmpl__AccountId__r.dmpl__BillingCity__c, '
        +'dmpl__AccountId__r.dmpl__BillingPostalCode__c, '
        +'dmpl__FieldSalesId__c, '
        +'dmpl__DocumentDate__c, '
        +'dmpl__Status__c, '
        +'dmpl__AccountId__r.Name '
        +'FROM dmpl__SaleInvoice__c ';

        String whereClause = ' WHERE dmpl__FieldSalesId__c = NULL ';
        if(accountIds.size() > 0){
             whereClause += ' AND dmpl__AccountId__c IN :accountIds ';
        }
        if(postalCode != null && postalCode != ''){
            whereClause += ' AND dmpl__AccountId__r.dmpl__BillingPostalCode__c = :postalCode ';
        }
        if(city != null && city != ''){
            whereClause += ' AND dmpl__AccountId__r.dmpl__BillingCity__c = :city ';
        }
        if(state != null && state != ''){
            whereClause += ' AND dmpl__AccountId__r.dmpl__BillingState__c = :state ';
        }
        if (fromDate != null && toDate != null) {
            whereClause += ' AND dmpl__DocumentDate__c >= :fromDate AND dmpl__DocumentDate__c <= :toDate ';
        } 
        if (fromDate != null && toDate == null) {
            whereClause += ' AND dmpl__DocumentDate__c >= :fromDate ';
        } 
        if (toDate != null && fromDate == null) {
            whereClause += ' AND dmpl__DocumentDate__c <= :toDate ';
        }

        query += whereClause;
        system.debug('inv query '+query);
        return Database.query(query);        
    }

    // new fn created the overloading fn 
    private static List<dmpl__SaleInvoice__c> getSaleInvoices(
        Set<Id> memberIds,
        Set<Id> accountIds,
        List<Id> routeIds,
        String postalCode, 
        String city, 
        String state,
        Date fromDate,
        Date toDate
    ){
        string query = 'SELECT Id, '
        +'Name, '
        +'dmpl__TotalAmount__c, '
        +'dmpl__AccountId__c, '
        +'dmpl__FieldSalesId__c, '
        +'dmpl__DocumentDate__c, '
        +'dmpl__Status__c, '
        +'dmpl__AccountId__r.dmpl__BillingCity__c, '
        +'dmpl__AccountId__r.dmpl__BillingPostalCode__c, '
        +'dmpl__AccountId__r.dmpl__BillingState__c, '
        +'dmpl__AccountId__r.Name '
        +'FROM dmpl__SaleInvoice__c ';

        String whereClause = ' WHERE dmpl__FieldSalesId__c = NULL ';
        if(accountIds.size() > 0){
             whereClause += ' AND dmpl__AccountId__c IN :accountIds ';
        }
        if(memberIds.size() > 0){
             whereClause += ' AND dmpl__AccountId__c IN :memberIds ';
        }
        if(postalCode != null && postalCode != ''){
            whereClause += ' AND dmpl__AccountId__r.dmpl__BillingPostalCode__c = :postalCode ';
        }
        if(city != null && city != ''){
            whereClause += ' AND dmpl__AccountId__r.dmpl__BillingCity__c = :city ';
        }
        if(state != null && state != ''){
            whereClause += ' AND dmpl__AccountId__r.dmpl__BillingState__c = :state ';
        }
        if (fromDate != null && toDate != null) {
            whereClause += ' AND dmpl__DocumentDate__c >= :fromDate AND dmpl__DocumentDate__c <= :toDate ';
        }
        if (fromDate != null && toDate == null) {
            whereClause += ' AND dmpl__DocumentDate__c >= :fromDate ';
        }
        if (toDate != null && fromDate == null) {
            whereClause += ' AND dmpl__DocumentDate__c <= :toDate ';
        }

        query += whereClause;
        system.debug('inv query '+query);
        return Database.query(query);        
    }

    private static List<dmpl__AccountGroupMember__c> getAccountGroupMembers(String accountGroup) {

        Id groupId  = (Id) accountGroup;
        return [
                SELECT  
                Id,         
                Name,
                dmpl__AccountId__c,
                dmpl__AccountGroupId__c
                FROM 
                dmpl__AccountGroupMember__c 
                WHERE dmpl__AccountGroupId__c = :groupId
        ];
    }

    public with sharing class invoiceWrapper {
        @AuraEnabled public String Id{ get; set; }
        @AuraEnabled public String invoiceId{ get; set; }
        @AuraEnabled public String Name{ get; set; }
        @AuraEnabled public String invoiceName{ get; set; }
        @AuraEnabled public String latitude{ get; set; }
        @AuraEnabled public String longitude{ get; set; }
        @AuraEnabled public String BillingCity{ get; set; }
        @AuraEnabled public String BillingPincode{ get; set; }
        @AuraEnabled public String BillingState{ get; set; }
        @AuraEnabled public String InvoiceNumber{ get; set; }
        @AuraEnabled public Decimal InvoiceAmount{ get; set; }
        @AuraEnabled public Date InvoiceDate{ get; set; }
        @AuraEnabled public String InvoiceStatus{ get; set; }
     
            public invoiceWrapper() {
                this.Id = '';
                this.Name = '';
                this.invoiceName = '';
                this.invoiceId = '';
                this.latitude = '';
                this.longitude = '';
                this.BillingCity ='';
                this.BillingPincode ='';
                this.BillingState ='';
                this.InvoiceAmount=0;
                this.InvoiceNumber='';
                this.InvoiceDate= null;
                this.InvoiceStatus='';
            }
}
}