public with sharing class AssetServiceContractHelper {
    
    private static Boolean skipValidations = false; 
    private static final string OBJECT_ASSET_SERVICECONTRACT = 'dmpl__AssetServiceContract__c';
    private static final string OBJECT_ASSET_SERVICECONTRACT_LINE = 'dmpl__AssetServiceContractLine__c';
    private static final string FIELD_SALEINVOICELINELINE_SALEINVOICEID = 'dmpl__SaleInvoiceId__c';
    private static final string FIELD_SALEINVOICELINELINE_ORIGINALASSETID = 'dmpl__OriginalAssetId__c';
    private static final string FIELD_SALEINVOICELINELINE_ITEMID = 'dmpl__ItemId__c';

    private static final List<String> LIST_NON_EDITABLE_FIELDS = new List<String>{};
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{};
    private static final List<String> LIST_FIELDS_LOCKEDIFTRANSACTED = new List<String>{};

    public static void validateHeaderItemServiceContract(List<SObject> documents){
        List<dmpl__AssetServiceContract__c> assetContracts = queryAssetServiceContracts(
            CollectionHelper.extractIds(
                documents, 
                'dmpl__AssetId__c'));
        List<dmpl__ItemServiceContract__c> itemContracts = queryItemServiceContracts(
            CollectionHelper.extractIds(
                documents, 
                'dmpl__ItemServiceContractId__c'),
            (List<String>)CollectionHelper.extractStrings(
                documents, 
                'dmpl__ServiceType__c')
        );
        for(SObject document : documents){
            if(document.get('dmpl__ItemServiceContractId__c') == null){
                continue;
            }
            dmpl__ItemServiceContract__c itemContract = (dmpl__ItemServiceContract__c)CollectionHelper.getObject(
                itemContracts, 
                (Id)document.get('dmpl__ItemServiceContractId__c'));
            dmpl__AssetServiceContract__c assetContract = null;
            
            if(document.get('dmpl__AssetServiceContractId__c') != null){
                assetContract = (dmpl__AssetServiceContract__c)CollectionHelper.getObject(
                    assetContracts, 
                    (Id)document.get('dmpl__AssetServiceContractId__c'));
                if(assetContract ==null || assetContract.dmpl__ItemServiceContractId__c != document.get('dmpl__ItemServiceContractId__c')){
                    document.put('dmpl__AssetServiceContractId__c', null);
                }
            }

            if(document.get('dmpl__AssetServiceContractId__c') == null){
                List<dmpl__AssetServiceContract__c> documentAssetContracts = (List<dmpl__AssetServiceContract__c>)DocumentHelper.getObjectsByFilter(
                    assetContracts, 
                    'dmpl__AssetId__c',
                    (Id)document.get('dmpl__AssetId__c'));
                if(documentAssetContracts.size()>0){
                    for(dmpl__AssetServiceContract__c documentAssetContract : documentAssetContracts){
                        if(documentAssetContract.dmpl__ItemServiceContractId__c == document.get('dmpl__ItemServiceContractId__c')
                             && (documentAssetContract.dmpl__IsUtilized__c == null 
                                || documentAssetContract.dmpl__IsUtilized__c == false) 
                                && (
                                    documentAssetContract.dmpl__ValidTillDate__c == null
                                    || (
                                        document.get('dmpl__FailureDate__c') != null
                                        ? (Date)document.get('dmpl__FailureDate__c') <= ((Date)documentAssetContract.dmpl__ValidTillDate__c).addDays(
                                            documentAssetContract.dmpl__GraceUsageDays__c == null ? 0 : (Integer)documentAssetContract.dmpl__GraceUsageDays__c
                                          )
                                        : (Date)document.get('dmpl__DocumentDate__c') <= ((Date)documentAssetContract.dmpl__ValidTillDate__c).addDays(
                                            documentAssetContract.dmpl__GraceUsageDays__c == null ? 0 : (Integer)documentAssetContract.dmpl__GraceUsageDays__c
                                          )
                                    )
                                )
                            && (documentAssetContract.dmpl__ValidTillHours__c == null || document.get('dmpl__UsageReadingHours__c') == null
                                || (Decimal)document.get('dmpl__UsageReadingHours__c') < documentAssetContract.dmpl__ValidTillHours__c 
                                    + (documentAssetContract.dmpl__GraceUsageHours__c == null ? 0 :  documentAssetContract.dmpl__GraceUsageHours__c))
                            && (documentAssetContract.dmpl__ValidTillUsageReading__c ==null || document.get('dmpl__UsageReading__c') == null
                                || (Decimal)document.get('dmpl__UsageReading__c') < documentAssetContract.dmpl__ValidTillUsageReading__c 
                                    + (documentAssetContract.dmpl__GraceUsageReading__c == null ? 0 : documentAssetContract.dmpl__GraceUsageReading__c))
                        ){
                            document.put('dmpl__AssetServiceContractId__c', documentAssetContract.Id);
                            assetContract = (dmpl__AssetServiceContract__c)CollectionHelper.getObject(
                                assetContracts, 
                                (Id)document.get('dmpl__AssetServiceContractId__c'));
                            break;
                        }
                    }
                }
            }
            
            if(orgSettingHelper.IsServiceContractValidationsDisabled()){
                continue;
            }

            if(itemContract==null){
                document.addError('Missing Contract. Please check if the Service Contract exists and try again.');
            }else {
                if(itemContract.dmpl__ActiveServiceContractRequired__c == true && assetContract == null ){
                    document.addError('No Active Asset Service Contract. This Service Contract requires an active Asset Service Contract!');
                }
                if(itemContract.dmpl__IsScopeRestricted__c == true && assetContract == null ){
                    document.addError('No Active Asset Service Contract. A Restricted Scope Contract requires an active Asset Service Contract!');
                }
                if(itemContract.dmpl__SingleUseContract__c && assetContract != null && assetContract.dmpl__IsUtilized__c){
                    document.addError('This is a Single Use contract and has already been utilised!');
                }
                if(itemContract.dmpl__ActiveServiceContractRequired__c && assetContract!=null){
                    // if(assetContract.dmpl__DueDate__c !=null && (Date)document.get('dmpl__DocumentDate__c') < assetContract.dmpl__DueDate__c){
                    //     document.addError('The Due Date for this contract has not yet been reached!');
                    // }
                    // if(assetContract.dmpl__DueInHours__c !=null && (Decimal)document.get('dmpl__UsageReadingHours__c') < assetContract.dmpl__DueInHours__c){
                    //     document.addError('The Usage Hours for this contract has not yet been reached!');
                    // }
                    // if(assetContract.dmpl__DueOnUsageReading__c !=null && (Decimal)document.get('dmpl__UsageReading__c') < assetContract.dmpl__DueOnUsageReading__c){
                    //     document.addError('The Usage Reading for this contract has not yet been reached!');
                    // }
                    
                    if(assetContract.dmpl__ValidTillDate__c !=null 
                        && (Date)document.get('dmpl__DocumentDate__c') > ((Date)assetContract.dmpl__ValidTillDate__c).addDays(
                            assetContract.dmpl__GraceUsageDays__c == null ? 0 :  (Integer)assetContract.dmpl__GraceUsageDays__c)){
                        document.addError('The validity of this contract has lapsed!');
                    }
                    if(assetContract.dmpl__ValidTillHours__c !=null && document.get('dmpl__UsageReadingHours__c')!=null
                        && (Decimal)document.get('dmpl__UsageReadingHours__c') > assetContract.dmpl__ValidTillHours__c 
                            + (assetContract.dmpl__GraceUsageHours__c == null ? 0 :  assetContract.dmpl__GraceUsageHours__c)){
                        document.addError('The Usage Hours for this contract has lapsed!');
                    }
                    if(assetContract.dmpl__ValidTillUsageReading__c !=null && document.get('dmpl__UsageReading__c')!=null
                        && (Decimal)document.get('dmpl__UsageReading__c') > assetContract.dmpl__ValidTillUsageReading__c 
                            + (assetContract.dmpl__GraceUsageReading__c == null ? 0 : assetContract.dmpl__GraceUsageReading__c)){
                        document.addError('The Usage Reading for this contract has lapsed!');
                    }
                }
            }
        }
    }

    public static void validateLineItemServiceContract(
        List<SObject> lines,
        String documentApiName,
        String recordIdFieldName){

        List<Id> documentIds = CollectionHelper.extractIds(
            lines, 
            recordIdFieldName);
        List<Id> itscIds = CollectionHelper.extractIds(
            lines, 
            'dmpl__ItemServiceContractId__c');
        List<SObject> documents = Database.query(
            'SELECT Id, Name, dmpl__AssetId__c, dmpl__ItemServiceContractId__c, dmpl__AssetServiceContractId__c, dmpl__DocumentDate__c,dmpl__FailureDate__c,dmpl__UsageReadingHours__c,dmpl__UsageReading__c, dmpl__ServiceType__c FROM ' 
            + documentApiName 
            + ' WHERE Id IN : documentIds');
        itscIds.addAll(CollectionHelper.extractIds(
            documents, 
            'dmpl__ItemServiceContractId__c'));

        List<dmpl__AssetServiceContract__c> assetContracts = queryAssetServiceContracts(
            CollectionHelper.extractIds(
                documents, 
                'dmpl__AssetId__c'));
        itscIds.addAll(
            CollectionHelper.extractIds(
                assetContracts, 
                'dmpl__ItemServiceContractId__c'));
        List<dmpl__ItemServiceContract__c> itemContracts = queryItemServiceContracts(
            itscIds,
            (List<String>)CollectionHelper.extractStrings(documents, 'dmpl__ServiceType__c'));
        for(SObject line : lines){
            SObject document = CollectionHelper.getObject(documents, (Id)line.get(recordIdFieldName));
            if(document == null){
                continue;
            }
            
            if(line.get('dmpl__ItemServiceContractId__c') == null){
                line.put(
                        'dmpl__PostingType__c', 
                        'Generate Invoices');
                line.put(
                    'dmpl__AssetServiceContractId__c', 
                    null);
                continue;
            }
            dmpl__ItemServiceContract__c itemContract = (dmpl__ItemServiceContract__c)CollectionHelper.getObject(
                itemContracts, 
                (Id)line.get('dmpl__ItemServiceContractId__c'));

            dmpl__AssetServiceContract__c assetContract = null;
            if(line.get('dmpl__AssetServiceContractId__c') != null){
                assetContract = (dmpl__AssetServiceContract__c)CollectionHelper.getObject(assetContracts, (Id)line.get('dmpl__AssetServiceContractId__c'));
                if(assetContract ==null || assetContract.dmpl__ItemServiceContractId__c != line.get('dmpl__ItemServiceContractId__c')){
                    line.put('dmpl__AssetServiceContractId__c', null);
                }   
            }

                    if(line.get('dmpl__AssetServiceContractId__c') == null){
                        List<dmpl__AssetServiceContract__c> lineAssetContracts = (List<dmpl__AssetServiceContract__c>)DocumentHelper.getObjectsByFilter(
                            assetContracts, 
                            'dmpl__AssetId__c',
                            (Id)document.get('dmpl__AssetId__c'));
            
                        if(lineAssetContracts.size()>0){
                            for(dmpl__AssetServiceContract__c lineAssetContract : lineAssetContracts){
                                if (lineAssetContract.dmpl__ItemServiceContractId__c == line.get('dmpl__ItemServiceContractId__c') &&
            (lineAssetContract.dmpl__IsUtilized__c == null || lineAssetContract.dmpl__IsUtilized__c == false) &&
            (
                (lineAssetContract.dmpl__ValidTillDate__c == null ||
                (
                    document.get('dmpl__FailureDate__c') != null ?
                    (Date)document.get('dmpl__FailureDate__c') <= ((Date)lineAssetContract.dmpl__ValidTillDate__c).addDays(
                        lineAssetContract.dmpl__GraceUsageDays__c == null ? 0 : (Integer)lineAssetContract.dmpl__GraceUsageDays__c
                    ) :
                    (Date)document.get('dmpl__DocumentDate__c') <= ((Date)lineAssetContract.dmpl__ValidTillDate__c).addDays(
                        lineAssetContract.dmpl__GraceUsageDays__c == null ? 0 : (Integer)lineAssetContract.dmpl__GraceUsageDays__c
                    )
                )
                )
            ) &&
            (
                lineAssetContract.dmpl__ValidTillHours__c == null || document.get('dmpl__UsageReadingHours__c') == null ||
                (
                    Decimal)document.get('dmpl__UsageReadingHours__c') < lineAssetContract.dmpl__ValidTillHours__c +
                    (lineAssetContract.dmpl__GraceUsageHours__c == null ? 0 : lineAssetContract.dmpl__GraceUsageHours__c
                )
            ) &&
            (
                lineAssetContract.dmpl__ValidTillUsageReading__c == null || document.get('dmpl__UsageReading__c') == null ||
                (
                    (Decimal)document.get('dmpl__UsageReading__c') < lineAssetContract.dmpl__ValidTillUsageReading__c +
                    (lineAssetContract.dmpl__GraceUsageReading__c == null ? 0 : lineAssetContract.dmpl__GraceUsageReading__c)
                )
            )
            ) {
                            line.put('dmpl__AssetServiceContractId__c', lineAssetContract.Id);
                            assetContract = (dmpl__AssetServiceContract__c)CollectionHelper.getObject(
                                assetContracts, 
                                (Id)line.get('dmpl__AssetServiceContractId__c'));
                            break;
                        }
                    }
                }
            }
            
            if(assetContract!=null
                && String.isBlank((String)line.get('dmpl__PostingType__c'))){
                    line.put('dmpl__PostingType__c', assetContract.dmpl__PostingType__c);    
            }

            if(itemContract !=null 
                && String.isBlank((String)line.get('dmpl__PostingType__c'))){
                line.put('dmpl__PostingType__c', itemContract.dmpl__ContractPostingTreatment__c);
            }

            if(orgSettingHelper.IsServiceContractValidationsDisabled()){
                continue;
            }
            
            if(itemContract==null){
                line.addError('Missing Contract. Please check if the Service Contract exists and try again.');
            }else {
                if(itemContract.dmpl__ActiveServiceContractRequired__c == true && assetContract == null ){
                    line.addError('No Active Asset Service Contract. This Service Contract requires an active Asset Service Contract!');
                }
                if(itemContract.dmpl__IsScopeRestricted__c == true && assetContract == null ){
                    line.addError('No Active Asset Service Contract. A Restricted Scope Contract requires an active Asset Service Contract!');
                }
                if(itemContract.dmpl__SingleUseContract__c && assetContract == null){
                    line.addError('No Active Asset Service Contract. Single Use Contract requires an active Asset Service Contract for the Asset!');
                }
                if(itemContract.dmpl__SingleUseContract__c && assetContract != null && assetContract.dmpl__IsUtilized__c){
                    line.addError('This is a Single Use contract and has already been utilised!');
                }
                if(itemContract.dmpl__ActiveServiceContractRequired__c && assetContract!=null){
                    // if(assetContract.dmpl__DueDate__c !=null && (Date)document.get('dmpl__DocumentDate__c')< assetContract.dmpl__DueDate__c){
                    //     line.addError('The Due Date for this contract has not yet been reached!');
                    // }
                    // if(assetContract.dmpl__DueInHours__c !=null && (Decimal)document.get('dmpl__UsageReadingHours__c') < assetContract.dmpl__DueInHours__c){
                    //     line.addError('The Usage Hours for this contract has not yet been reached!');
                    // }
                    // if(assetContract.dmpl__DueOnUsageReading__c !=null && (Decimal)document.get('dmpl__UsageReading__c') < assetContract.dmpl__DueOnUsageReading__c){
                    //     line.addError('The Usage Reading for this contract has not yet been reached!');
                    // }
                    
                    if(assetContract.dmpl__ValidTillDate__c !=null 
                        && (Date)document.get('dmpl__DocumentDate__c') > ((Date)assetContract.dmpl__ValidTillDate__c).addDays(
                            assetContract.dmpl__GraceUsageDays__c == null ? 0 :  (Integer)assetContract.dmpl__GraceUsageDays__c)){
                        line.addError('The validity of this contract has lapsed!');
                    }
                    if(assetContract.dmpl__ValidTillHours__c !=null && document.get('dmpl__UsageReadingHours__c') !=null
                        && (Decimal)document.get('dmpl__UsageReadingHours__c') > assetContract.dmpl__ValidTillHours__c 
                            + (assetContract.dmpl__GraceUsageHours__c == null ? 0 :  assetContract.dmpl__GraceUsageHours__c)){
                        line.addError('The Usage Hours for this contract has lapsed!');
                    }
                    if(assetContract.dmpl__ValidTillUsageReading__c !=null && document.get('dmpl__UsageReading__c') !=null
                        && (Decimal)document.get('dmpl__UsageReading__c') > assetContract.dmpl__ValidTillUsageReading__c 
                            + (assetContract.dmpl__GraceUsageReading__c == null ? 0 : assetContract.dmpl__GraceUsageReading__c)){
                        line.addError('The Usage Reading for this contract has lapsed!');
                    }
                }
                System.debug(JSON.serializePretty(assetContract));
                if(itemContract.dmpl__IsScopeRestricted__c == true && assetContract != null && line.get('dmpl__ItemId__c') !=null){
                    dmpl__AssetServiceContractLine__c contractLine = (dmpl__AssetServiceContractLine__c)CollectionHelper.getObject(
                        assetContract.dmpl__AssetServiceContractLines__r,
                        'dmpl__ComponentItemId__c',
                        (Id)line.get('dmpl__ItemId__c'));
                    if(contractLine == null){
                        line.addError('The Item is not in scope of active Service Contract!');
                    }else if(((Decimal)line.get('dmpl__Quantity__c')) > contractLine.dmpl__PendingQuantity__c){
                        line.addError('The quantity of the Item exceeds the quantity allowed under this Service Contract!');
                    }
                }
            }
        }
    }

    public static void createAssetServiceContracts(List<dmpl__SaleInvoice__c> invoices, List<dmpl__SaleInvoiceLine__c> invoiceLines){
        Map<Id, dmpl__Item__c> items = new Map<Id, dmpl__Item__c>(
            ItemHelper.getCachedItems(
                DocumentHelper.extractIds(invoiceLines, 'dmpl__ItemId__c')));
        List<dmpl__ItemServiceContract__c> itemServiceContracts = queryApplicableItemServiceContracts(
            new List<Id>(items.keySet()), 
            getMinDocumentDate(invoices));


        Map<dmpl__AssetServiceContract__c, List<dmpl__AssetServiceContractLine__c>> serviceContractsToCreate = new Map<dmpl__AssetServiceContract__c, List<dmpl__AssetServiceContractLine__c>>();
        for(dmpl__SaleInvoice__c invoice : invoices){
            for(dmpl__SaleInvoiceLine__c invoiceLine : (List<dmpl__SaleInvoiceLine__c>)DocumentHelper.getObjects(
                    invoiceLines, 
                    FIELD_SALEINVOICELINELINE_SALEINVOICEID, 
                    invoice.Id)){
                dmpl__Item__c item = items.get(invoiceLine.dmpl__ItemId__c);
                if(item == null){
                    throw new DMPLException(
                        String.format(
                            String.valueOf(System.Label.Generic_MissingObject), 
                            new String[]{dmpl__Item__c.class.getName()}));
                }
                if(item.dmpl__ItemType__c == ItemHelper.ITEM_TYPE_SERVICECONTRACT){
                    Id assetId = invoiceLine.dmpl__AssetId__c;
                    Id parentItemId = null;
                    if(assetId == null && invoiceLine.dmpl__PackageSaleInvoiceLineId__c!=null){
                        dmpl__SaleInvoiceLine__c parentLine = (dmpl__SaleInvoiceLine__c)CollectionHelper.getObject(invoiceLines, invoiceLine.dmpl__PackageSaleInvoiceLineId__c);
                        if(parentLine!=null){
                            assetId = parentLine.dmpl__AssetId__c;
                            parentItemId = parentLine.dmpl__ItemId__c;
                        }
                    }
                    for(dmpl__ItemServiceContract__c sc : itemServiceContracts){
                        if(sc.dmpl__ItemId__c == invoiceLine.dmpl__ItemId__c 
                            && (sc.dmpl__SKUId__c == invoiceLine.dmpl__SKUId__c || sc.dmpl__SKUId__c == null)
                            && (sc.dmpl__DateEffectiveFrom__c <= invoice.dmpl__DocumentDate__c || sc.dmpl__DateEffectiveFrom__c == null)
                            && (sc.dmpl__DateEffectiveTill__c >= invoice.dmpl__DocumentDate__c || sc.dmpl__DateEffectiveTill__c == null))

                            serviceContractsToCreate.putAll(
                                newAssetServiceContract(invoice, invoiceLine, item, parentItemId, assetId, sc));
                    }
                }
            }
        }
        
        createAssetServiceContracts(serviceContractsToCreate);
    }

    public static void checkAndUpdateOriginalAssetContract(List<dmpl__SaleInvoiceLine__c> invoiceLines){
        List<dmpl__SaleInvoiceLine__c> linesWithOriginalAssets = DocumentHelper.getObjectsWithNotNull(invoiceLines, FIELD_SALEINVOICELINELINE_ORIGINALASSETID);
        if(linesWithOriginalAssets.size() == 0){
            if(!Test.isRunningTest()){
                return;
            }
        }

        List<dmpl__AssetServiceContract__c> assetServiceContractsToUpdate = new List<dmpl__AssetServiceContract__c>();
        List<dmpl__AssetServiceContract__c> originalAssetServiceContracts = queryOriginalAssetServiceContracts(
            DocumentHelper.extractIds(linesWithOriginalAssets, FIELD_SALEINVOICELINELINE_ORIGINALASSETID), 
            DocumentHelper.extractIds(linesWithOriginalAssets, FIELD_SALEINVOICELINELINE_ITEMID));

        for(dmpl__SaleInvoiceLine__c invoiceLine : linesWithOriginalAssets){
            for(dmpl__AssetServiceContract__c assetServiceContract : originalAssetServiceContracts){
                if(invoiceLine.dmpl__OriginalAssetId__c == assetServiceContract.dmpl__AssetId__c 
                    && invoiceLine.dmpl__ItemId__c == assetServiceContract.dmpl__ItemId__c){
                    assetServiceContract.dmpl__AssetId__c = invoiceLine.dmpl__OriginalAssetId__c;
                    assetServiceContractsToUpdate.add(assetServiceContract);
                }
            }
        }
        if(assetServiceContractsToUpdate.size() > 0){
            SecurityHelper.ensureCanWriteFields(new string[]{
                'dmpl__AssetId__c'
            }, 'dmpl__AssetServiceContract__c');
            update assetServiceContractsToUpdate;
        }
    }

    @TestVisible
    private static Map<dmpl__AssetServiceContract__c, List<dmpl__AssetServiceContractLine__c>> newAssetServiceContract(
        dmpl__SaleInvoice__c invoice, 
        dmpl__SaleInvoiceLine__c invoiceLine, 
        dmpl__Item__c item,
        Id parentItemId,
        Id assetId,
        dmpl__ItemServiceContract__c itemServiceContract){
        dmpl__AssetServiceContract__c assetSC =  new dmpl__AssetServiceContract__c(
            dmpl__ActivatedDate__c = invoice.dmpl__DocumentDate__c,
            dmpl__AssetId__c = assetId,
            dmpl__GraceUsageDays__c = itemServiceContract.dmpl__GraceUsageDays__c,
            dmpl__GraceUsageHours__c= itemServiceContract.dmpl__GraceUsageHours__c,
            dmpl__GraceUsageReading__c= itemServiceContract.dmpl__GraceUsageReading__c,
            dmpl__IsUtilized__c = false,
            dmpl__ItemId__c = parentItemId,
            dmpl__ServiceContractItemId__c = itemServiceContract.dmpl__ItemId__c,
            dmpl__ItemServiceContractId__c = itemServiceContract.Id
        );
        if(itemServiceContract.dmpl__FromDays__c !=null){
            assetSC.dmpl__DueDate__c = invoice.dmpl__DocumentDate__c.addDays(Integer.valueOf(itemServiceContract.dmpl__FromDays__c));
        }

        if(itemServiceContract.dmpl__ToDays__c !=null){
            //replace with value below. Delete the active till date field and use valid till date 
            assetSC.dmpl__ValidTillDate__c = invoice.dmpl__DocumentDate__c.addDays(Integer.valueOf(itemServiceContract.dmpl__ToDays__c));
            // assetSC.dmpl__ValidTillDate__c = itemServiceContract.dmpl__ToDays__c;
        }

        if(itemServiceContract.dmpl__MinimumUsageHours__c !=null){
            assetSC.dmpl__DueInHours__c = itemServiceContract.dmpl__MinimumUsageHours__c;
        }

        if(itemServiceContract.dmpl__MaximumUsageHours__c !=null){
            assetSC.dmpl__ValidTillHours__c = itemServiceContract.dmpl__MaximumUsageHours__c;
        }

        if(itemServiceContract.dmpl__MinimumUsageReading__c !=null){
            assetSC.dmpl__DueOnUsageReading__c = itemServiceContract.dmpl__MinimumUsageReading__c;
        }

        if(itemServiceContract.dmpl__MaximumUsageReading__c !=null){
            assetSC.dmpl__ValidTillUsageReading__c = itemServiceContract.dmpl__MaximumUsageReading__c;
        }

        List<dmpl__AssetServiceContractLine__c> assetContractLines = new List<dmpl__AssetServiceContractLine__c>();
        if(!itemServiceContract.dmpl__RestrictAssetContractLinesGeneration__c)
        {
            for(dmpl__ItemServiceContractLine__c line : itemServiceContract.dmpl__ItemServiceContractLines__r){
                assetContractLines.add(new dmpl__AssetServiceContractLine__c(
                    dmpl__ComponentItemId__c = line.dmpl__ComponentItemId__c,
                    dmpl__Quantity__c = line.dmpl__Quantity__c,
                    dmpl__AssetServiceContractId__r = assetSC
                ));
            }
        }

        Map<dmpl__AssetServiceContract__c, List<dmpl__AssetServiceContractLine__c>> returnValue = new Map<dmpl__AssetServiceContract__c, List<dmpl__AssetServiceContractLine__c>>();
        returnValue.put(assetSC, assetContractLines);
        return returnValue;
    }

    private static void createAssetServiceContracts(Map<dmpl__AssetServiceContract__c, List<dmpl__AssetServiceContractLine__c>> assetServiceContracts){
        SecurityHelper.ensureCanCreateObject(OBJECT_ASSET_SERVICECONTRACT);
        SecurityHelper.ensureCanCreateFields(new List<String>
        {
            'dmpl__ActivatedDate__c',
            'dmpl__AssetId__c',
            'dmpl__Description__c',
            'dmpl__DueDate__c',
            'dmpl__DueInHours__c',
            'dmpl__DueOnUsageReading__c',
            'dmpl__GraceUsageDays__c',
            'dmpl__GraceUsageHours__c',
            'dmpl__GraceUsageReading__c',
            'dmpl__IsUtilized__c',
            'dmpl__ItemId__c',
            'dmpl__ServiceContractItemId__c',
            'dmpl__ItemServiceContractId__c',
            'dmpl__ValidTillDate__c',
            'dmpl__ValidTillHours__c',
            'dmpl__ValidTillUsageReading__c'
        }, OBJECT_ASSET_SERVICECONTRACT);

        SecurityHelper.ensureCanCreateObject(OBJECT_ASSET_SERVICECONTRACT_LINE);
        SecurityHelper.ensureCanCreateFields(new List<String>
        {
            'dmpl__ComponentItemId__c',
            'dmpl__Quantity__c'
        }, OBJECT_ASSET_SERVICECONTRACT_LINE);

        try {
            skipValidations = true;
            
            insert new List<dmpl__AssetServiceContract__c>(assetServiceContracts.keySet());

            List<dmpl__AssetServiceContractLine__c> assetServiceContractLines = new List<dmpl__AssetServiceContractLine__c>();
            for(List<dmpl__AssetServiceContractLine__c> lines : assetServiceContracts.values()){
                if(lines.size() > 0)
                {
                    for(dmpl__AssetServiceContractLine__c line :  lines){
                        line.dmpl__AssetServiceContractId__c = line.dmpl__AssetServiceContractId__r.Id;
                        assetServiceContractLines.add(line);    
                    }
                }
            }
            insert assetServiceContractLines;

        } finally {
            skipValidations = false;
        }
    }

    private static List<dmpl__ItemServiceContract__c> queryApplicableItemServiceContracts(List<Id> itemIds, Date documentDate){
        SecurityHelper.ensureCanReadFields(new String[]{
            'dmpl__DateEffectiveFrom__c',
            'dmpl__DateEffectiveTill__c',
            'dmpl__ExternalId__c',
            'dmpl__FromDays__c',
            'dmpl__GraceUsageDays__c',
            'dmpl__GraceUsageHours__c',
            'dmpl__GraceUsageReading__c',
            'dmpl__ItemId__c',
            'dmpl__SKUId__c',
            'dmpl__MaximumUsageHours__c',
            'dmpl__MaximumUsageReading__c',
            'dmpl__MinimumUsageHours__c',
            'dmpl__MinimumUsageReading__c',
            'dmpl__ToDays__c',
            'dmpl__RestrictAssetContractLinesGeneration__c'
        }, 'dmpl__ItemServiceContract__c');
        return [SELECT
                Id, 
                dmpl__DateEffectiveFrom__c,
                dmpl__DateEffectiveTill__c,
                dmpl__ExternalId__c,
                dmpl__FromDays__c,
                dmpl__GraceUsageDays__c,
                dmpl__GraceUsageHours__c,
                dmpl__GraceUsageReading__c,
                dmpl__ItemId__c,
                dmpl__SKUId__c,
                dmpl__MaximumUsageHours__c,
                dmpl__MaximumUsageReading__c,
                dmpl__MinimumUsageHours__c,
                dmpl__MinimumUsageReading__c,
                dmpl__ToDays__c,
                dmpl__RestrictAssetContractLinesGeneration__c,
                (
                    SELECT
                        Id,
                        dmpl__ComponentItemId__c,
                        dmpl__Quantity__c
                    FROM dmpl__ItemServiceContractLines__r
                )
            FROM dmpl__ItemServiceContract__c
            WHERE dmpl__ItemId__c IN :itemIds
            AND (dmpl__DateEffectiveFrom__c<= :documentDate OR dmpl__DateEffectiveFrom__c = null)
            AND (dmpl__DateEffectiveTill__c >= :documentDate OR dmpl__DateEffectiveTill__c = null)
            ORDER BY dmpl__ItemId__c, dmpl__SKUId__c, dmpl__DateEffectiveFrom__c DESC];
    }

    @TestVisible
    private static List<dmpl__AssetServiceContract__c> queryOriginalAssetServiceContracts(List<Id> assetIds, List<Id> itemIds){
        SecurityHelper.ensureCanReadFields(new String[]{
            'dmpl__AssetId__c',
            'dmpl__ItemId__c'
        }, 'dmpl__ItemServiceContract__c');
        return [SELECT
                Id, 
                dmpl__AssetId__c,
                dmpl__ItemId__c
            FROM dmpl__AssetServiceContract__c
            WHERE dmpl__AssetId__c IN :assetIds
            AND dmpl__ItemId__c IN :itemIds];
    }

    private static date getMinDocumentDate(List<dmpl__SaleInvoice__c> documents){
        List<Date> documentDates = new List<Date>();
        for(dmpl__SaleInvoice__c document : documents){
            documentDates.add((Date)document.dmpl__DocumentDate__c);
        }
        if(documentDates.size()>0){
            documentDates.sort();
            return documentDates[0]; 
        }
        return null;
    }

    private static List<dmpl__AssetServiceContract__c> queryAssetServiceContracts(List<Id> assetIds){
        return [
            SELECT
                Id,
                dmpl__AssetId__c,
                dmpl__ActivatedDate__c,
                dmpl__BillingAccountId__c,
                dmpl__ContractPostingTreatment__c,
                dmpl__DueDate__c,
                dmpl__DueInHours__c,
                dmpl__DueOnUsageReading__c,
                dmpl__GraceUsageDays__c,
                dmpl__GraceUsageHours__c,
                dmpl__GraceUsageReading__c,
                dmpl__IsUtilized__c,
                dmpl__PopulateContractLines__c,
                dmpl__SingleUseContract__c,
                dmpl__ValidTillDate__c,
                dmpl__ValidTillHours__c,
                dmpl__ValidTillUsageReading__c,
                dmpl__ItemServiceContractId__c,
                dmpl__PostingType__c,
                dmpl__ServiceType__c,
                (SELECT 
                    dmpl__ComponentItemId__c,
                    dmpl__PendingQuantity__c,
                    dmpl__Quantity__c,
                    dmpl__UtilizedQuantity__c
                FROM
                    dmpl__AssetServiceContractLines__r
                )
            FROM 
                dmpl__AssetServiceContract__c
            WHERE 
                dmpl__AssetId__c IN : assetIds];
    }

    private static List<dmpl__ItemServiceContract__c> queryItemServiceContracts(
        List<Id> itemServiceContractIds,
        List<String> serviceTypes){
        return [
            SELECT
                Id,
                dmpl__BillingAccountId__c,
                dmpl__ContractPostingTreatment__c,
                dmpl__MaximumUsageHours__c,
                dmpl__MaximumUsageReading__c,
                dmpl__MinimumUsageHours__c,
                dmpl__MinimumUsageReading__c,
                dmpl__GraceUsageDays__c,
                dmpl__GraceUsageHours__c,
                dmpl__GraceUsageReading__c,
                dmpl__FromDays__c,
                dmpl__ToDays__c,
                dmpl__PopulateContractLines__c,
                dmpl__SingleUseContract__c,
                dmpl__ActiveServiceContractRequired__c,
                dmpl__IsScopeRestricted__c,
                dmpl__ServiceType__c
            FROM 
                dmpl__ItemServiceContract__c
            WHERE 
                Id IN : itemServiceContractIds
                OR dmpl__ServiceType__c IN :serviceTypes];
    }
}