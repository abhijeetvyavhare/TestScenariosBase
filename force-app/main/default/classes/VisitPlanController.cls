public with sharing class VisitPlanController implements Callable {
    
    public Object call(String action, Map<String, Object> args) {
        switch on action {
            when 'headlessAction' {
                return VisitPlanHelper.optimiseRoute((Id)args.get('recordId'));
            }
            when 'headlessAction2' {
                return VisitPlanHelper.clearRoutes((Id)args.get('recordId'));
            }
            when else {
                throw new CalloutException('Method not implemented');
            }
        }
    } 
    
    @AuraEnabled(cacheable = true)
    public static List<dmpl__VisitPlan__c> getVisitPlan(Id recordId)
    {
        try {
            return VisitPlanHelper.getVisitPlan(recordId);
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    @AuraEnabled(cacheable = true)
    public static List<dmpl__VisitTask__c> getVisitTasks(Id recordId)
    {
        try {
            return VisitHelper.getVisitTasks(recordId);
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }
    
    @AuraEnabled
    public static Boolean postQueuedValues(List<Object> data)
    {
        String fieldApi = '';
        try 
        {
            
            List<SObject> recordsToUpdate = new List<SObject>();
            for(Object record : data){
                Map<Object,Object> fields = (Map<Object,Object>) record;
                Id recordId = (Id)fields.get('Id');
                Schema.SobjectType sObjectType = recordId.getSobjectType();
                SObject aObject = sObjectType.newSObject(recordId);
                aObject.Id = recordId;
                for(Object key : fields.keySet()){
                    fieldApi = (string)key;
                    if(key == 'dmpl__Date__c'){
                        aObject.put((String)key, Date.valueOf((String)fields.get(key)));
                    }else if(key == 'dmpl__DateTimeValue__c'){
                        aObject.put((String)key, (DateTime)Json.deserialize('"'+(String)fields.get(key)+'"', DateTime.class));
                    }else if(key == 'dmpl__TimeValue__c'){             
                        String timeValue = (String)fields.get(key);               
                        if(!String.isBlank(timeValue)){
                            List<String> timeValues =  timeValue.split(':'); 
                            if(timeValues.size() >= 2){
                                aObject.put((String)key, Time.newInstance(
                                    Integer.valueOf(timeValues[0]),
                                    Integer.valueOf(timeValues[1]),
                                    0,
                                    0));
                            }
                        }
                    }else if(key == 'dmpl__DecimalValue__c' || key == 'dmpl__CurrencyValue__c'){
                        aObject.put((String)key, Decimal.valueOf((String)fields.get(key)));
                    }else if(key == 'dmpl__NumericValue__c'){
                        aObject.put((String)key, Decimal.valueOf((String)fields.get(key)));
                    }else if (key == 'dmpl__DateTimeValue__c') {
                        String dateTimeString = (String) fields.get(key);
                        if (!String.isBlank(dateTimeString)) {
                            try {
                                DateTime dateTimeValue = (DateTime) JSON.deserialize('"' + dateTimeString + '"', DateTime.class);
                                aObject.put((String) key, dateTimeValue);
                            } catch (Exception e) {
                                System.debug('Error deserializing DateTime: ' + e.getMessage());
                            }
                        }
                    }else if(key == 'dmpl__TimeValue__c'){             
                        String timeValue = (String)fields.get(key);               
                        if(!String.isBlank(timeValue)){
                            List<String> timeValues =  timeValue.split(':'); 
                            if(timeValues.size() >= 2){
                                aObject.put((String)key, Time.newInstance(
                                    Integer.valueOf(timeValues[0]),
                                    Integer.valueOf(timeValues[1]),
                                    0,
                                    0));
                            }
                        }
                            }else{
                        aObject.put((String)key, fields.get(key));
                                                }
                                    }                    
                recordsToUpdate.add(aObject);
            }
            update recordsToUpdate;
            return true;
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw new AuraException(fieldApi + ' : '+ error.getMessage());
        }
    }


    @AuraEnabled
    public static String uploadFile(
        Id recordId, 
        String base64, 
        String filename) {
            ContentVersion cv = createContentVersion(base64, filename);
            ContentDocumentLink cdl = createContentLink(cv.Id, recordId);
            if (cv == null || cdl == null) {
                return null; }
            return cdl.Id;
    }
   
    @testvisible
    private static ContentVersion createContentVersion(
        String base64, 
        String filename) {
        ContentVersion cv = new ContentVersion();
        cv.VersionData = EncodingUtil.base64Decode(base64);
        cv.Title = filename;
        cv.PathOnClient = filename;
        try {
            insert cv;
            return cv;
        } catch(DMLException e) {
            // ExceptionLogHelper.logException(e);
            throw e;
        }
    }

    @testvisible
    private static ContentDocumentLink createContentLink(String contentVersionId, String recordId) {
        if (contentVersionId == null 
            || recordId == null) { 
                return null; 
        }
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT 
                ContentDocumentId 
            FROM ContentVersion 
            WHERE Id =: contentVersionId].ContentDocumentId;
        cdl.LinkedEntityId = recordId;
        cdl.ShareType = 'V';
        try {
            insert cdl;
            return cdl;
        } catch(DMLException e) {
            // ExceptionLogHelper.logException(e);
            throw e;
        }
    }
}