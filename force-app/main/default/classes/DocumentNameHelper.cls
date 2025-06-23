public with sharing class DocumentNameHelper {

    private static Period lastFiscalPeriod;
    private static date lastDocumentDate;
    public static void generateDocumentName(List<SObject> newEntries){
        dmpl__DMSDocumentNameSetting__mdt nameSetting = getDocumentNameSetting(newEntries);
        Schema.SObjectField documentDateFD = null;
        Schema.SObjectField documentDateCFD = null;
        Schema.SObjectField createdDateCFD = null;
        if(nameSetting!=null){
            for(sObject sourceObject : newEntries){
                Date documentDate = Date.today();
                if(documentDateFD == null){
                    documentDateFD = MetadataHelper.getField(sourceObject.getSObjectType(), 'dmpl__DocumentDate__c');
                }
                if(documentDateFD !=null && sourceObject.isSet('dmpl__DocumentDate__c')){
                    documentDate = (Date)sourceObject.get('dmpl__DocumentDate__c');
                } else {
                    if(documentDateCFD == null){
                        documentDateCFD = MetadataHelper.getField(sourceObject.getSObjectType(), 'DocumentDate__c');
                    }
                    if(documentDateFD !=null && sourceObject.isSet('DocumentDate__c')){
                        documentDate = (Date)sourceObject.get('DocumentDate__c');
                    } else {
                        if(createdDateCFD == null){
                            createdDateCFD = MetadataHelper.getField(sourceObject.getSObjectType(), 'CreatedDate');
                        }
                        if(createdDateCFD !=null && sourceObject.isSet('CreatedDate')){
                            documentDate = ((Datetime)sourceObject.get('CreatedDate')).date();
                        }
                    }
                }
                
                if(nameSetting.dmpl__SourceDateFieldName__r.QualifiedApiName !=null
                    && sourceObject.get(nameSetting.dmpl__SourceDateFieldName__r.QualifiedApiName)!=null){
                    Date sourceDate = (Date)sourceObject.get(nameSetting.dmpl__SourceDateFieldName__r.QualifiedApiName);
                    documentDate = Date.newInstance(sourceDate.year(), sourceDate.month(), sourceDate.day());
                }

                String documentName = sourceObject.get(nameSetting.dmpl__SourceSeriesFieldId__r.QualifiedApiName)
                     + nameSetting.dmpl__ConcatenationCharacter__c
                     + formatDatePart(documentDate, nameSetting.dmpl__DateFormat__c);
                documentName = documentName +
                     + nameSetting.dmpl__ConcatenationCharacter__c
                     + formatAutoNumberPart(documentName, nameSetting);
                sourceObject.put(nameSetting.dmpl__DestinationFieldNameId__r.QualifiedApiName, documentName);
            }
        }
    }

    @testVisible
    private static String formatDatePart(Date sourceDateTime, String sourceFormat){
        String nameFormat = sourceFormat;
        nameFormat = nameFormat.replace('{DD}', getParsedDateFormat('{DD}', sourceDateTime));
        nameFormat = nameFormat.replace('{MM}', getParsedDateFormat('{MM}', sourceDateTime));
        nameFormat = nameFormat.replace('{YY}', getParsedDateFormat('{YY}', sourceDateTime));
        nameFormat = nameFormat.replace('{YYYY}', getParsedDateFormat('{YYYY}', sourceDateTime));
        nameFormat = nameFormat.replace('{FY}', getParsedDateFormat('{FY}', sourceDateTime));
        nameFormat = nameFormat.replace('{FYYY}', getParsedDateFormat('{FYYY}', sourceDateTime));
        nameFormat = nameFormat.replace('{YYYYFY}', getParsedDateFormat('{YYYYFY}', sourceDateTime));
        return nameFormat;
    }

    @testVisible
    private static String formatAutoNumberPart(String doucmentName, dmpl__DMSDocumentNameSetting__mdt nameSetting){
        
        Integer nextNumber = 1;
        dmpl__DocumentNameSetting__c documentSetting;
        List<dmpl__DocumentNameSetting__c> documentSettings = [
            SELECT 
                dmpl__LastNumberUsed__c 
            FROM 
                dmpl__DocumentNameSetting__c 
            WHERE
             dmpl__DocumentSeries__c =:doucmentName
             AND dmpl__ObjectApiName__c =:nameSetting.dmpl__ObjectNameId__r.QualifiedApiName 
            LIMIT 1 FOR UPDATE];
        if(documentSettings == null || documentSettings.size() == 0){
            documentSetting = new dmpl__DocumentNameSetting__c(
                dmpl__DocumentSeries__c = doucmentName,
                dmpl__LastNumberUsed__c = nextNumber,
                dmpl__ObjectApiName__c = nameSetting.dmpl__ObjectNameId__r.QualifiedApiName
            );
        } else {
            documentSetting = documentSettings[0];
            nextNumber = (Integer)documentSetting.dmpl__LastNumberUsed__c +1;
            documentSetting.dmpl__LastNumberUsed__c = nextNumber;
        }
        upsert documentSetting;
        return String.valueOf(nextNumber).leftPad((Integer)nameSetting.dmpl__AutoNumberLength__c, '0');
    }

    private static dmpl__DMSDocumentNameSetting__mdt getDocumentNameSetting(List<SObject> newEntries){
        String sObjectApiName;
        if(newEntries!=null && newEntries.size()>0){
            sObjectApiName = newEntries[0].getSObjectType().getDescribe().name;
        }
        List<dmpl__DMSDocumentNameSetting__mdt> nameSettings = [SELECT
            DeveloperName,
            dmpl__ObjectNameId__r.QualifiedApiName,
            dmpl__SourceSeriesFieldId__r.QualifiedApiName,
            dmpl__DestinationFieldNameId__r.QualifiedApiName,
            dmpl__SourceDateFieldName__r.QualifiedApiName,
            dmpl__AutoNumberLength__c,
            dmpl__ConcatenationCharacter__c,
            dmpl__DateFormat__c
        FROM 
            dmpl__DMSDocumentNameSetting__mdt
        WHERE 
            dmpl__ObjectNameId__r.QualifiedApiName =:sObjectApiName
        LIMIT 1];

        if(nameSettings!=null && nameSettings.size()>0){
            return nameSettings[0];
        }
        return null;
    }

    private static Period getFiscalYear(Date documentDate)
    {
        List<Period> fiscalPeriods = new List<Period>();
        fiscalPeriods = [SELECT Type, StartDate, EndDate, FiscalYearSettings.Name, FiscalYearSettings.IsStandardYear, FullyQualifiedLabel FROM Period WHERE Type = 'Year' AND StartDate <= : documentDate AND EndDate >= : documentDate ORDER BY StartDate];
        return fiscalPeriods.size() > 0 ? fiscalPeriods[0] : null;
    }

    public static Period getCachedFiscalYear(
        Date documentDate){
        if(lastFiscalPeriod!=null && lastDocumentDate == documentDate){
            return lastFiscalPeriod;
        }
        //
        lastDocumentDate = documentDate;
        //
        if (!OrgCacheHelper.isPlatformCacheEnabled('Period')){
            lastFiscalPeriod = getFiscalYear(
                documentDate);
        }else {
            String key = 'Period' + documentDate.year() + '' + documentDate.month() + '' + documentDate.day();  
            lastFiscalPeriod = (Period)OrgCacheHelper.getObject(key);
            if(lastFiscalPeriod == null){
                lastFiscalPeriod = getFiscalYear(
                    documentDate);
                OrgCacheHelper.setObject(key, lastFiscalPeriod);
            }
        }
        return lastFiscalPeriod;
    }

    private static String getParsedDateFormat(string format, Date sourceDate)
    {
        Datetime sourceDateTime = Datetime.newInstance(sourceDate.year(), sourceDate.month(), sourceDate.day());
        Period fiscalPeriod;
        string result = '';
        if(format == '{DD}'){
            result = sourceDateTime.format('dd');
        } else if(format == '{MM}'){
            result = sourceDateTime.format('MM');
        } else if(format == '{YY}'){
            result = sourceDateTime.format('yy');
        } else if(format == '{YYYY}'){
            result = sourceDateTime.format('yyyy');
        } else if(format == '{FY}'){
            fiscalPeriod = getCachedFiscalYear(sourceDate);
            result = fiscalPeriod != null ? 
                fiscalPeriod.FiscalYearSettings.Name.substring(2) : 
                sourceDateTime.format('yy');
        } else if(format == '{FYYY}'){
            fiscalPeriod = getCachedFiscalYear(sourceDate);
            result = fiscalPeriod != null ? 
                fiscalPeriod.FiscalYearSettings.Name : 
                sourceDateTime.format('yyyy');
        } else if(format == '{YYYYFY}'){
            fiscalPeriod = getCachedFiscalYear(sourceDate);
            if(fiscalPeriod != null){
                String startYear = String.valueof(fiscalPeriod.StartDate).substring(0,4);
                String endyear  = String.valueof(fiscalPeriod.EndDate).substring(0,4);
                result = startYear == endyear ? endyear : (startYear + endyear.substring(2,4));
            } else {
                result = sourceDateTime.format('yyyy');
            }
        }
        return result;
    }
}