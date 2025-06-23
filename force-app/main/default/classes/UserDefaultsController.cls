public with sharing class UserDefaultsController {
    
    @AuraEnabled(cacheable = true)
    public static Period getUserOrgDefaultFiscalPeriod(){
        return getUserOrgDefaultFiscalPeriodForDate(date.today());
    }

    @TestVisible
    @AuraEnabled(cacheable = true)
    public static Period getUserOrgDefaultFiscalPeriodForDate(Date documentDate){
        try {
            List<Period> fiscalPeriods = new List<Period>();
            fiscalPeriods = [SELECT 
                Type, 
                StartDate, 
                EndDate, 
                FiscalYearSettings.Name, 
                FiscalYearSettings.IsStandardYear, 
                FullyQualifiedLabel FROM Period 
            WHERE 
                Type = 'Year' 
                AND StartDate <= : documentDate 
                AND EndDate >= : documentDate 
                ORDER BY StartDate];
            return fiscalPeriods.size() > 0 ? fiscalPeriods[0] : null;
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }
}