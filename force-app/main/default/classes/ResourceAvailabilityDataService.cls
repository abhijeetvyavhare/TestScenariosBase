public class ResourceAvailabilityDataService extends MetadataService {
    
    public static final String OBJECT_RESOURCEAVAILABILITYDATA = 'dmpl__ResourceAvailabilityData__c';

	public ResourceAvailabilityDataService(){
        super(OBJECT_RESOURCEAVAILABILITYDATA);
    }
    
    public static void processResourceAvailabilityData(
    	List<dmpl__ResourceAvailabilityData__c> newEntriesWithNullReference
    ){
        try{
            Map<String,dmpl__ResourceAvailability__c> resourceAvailabilityMap =createResourceAvailability(
                newEntriesWithNullReference);
            for(dmpl__ResourceAvailabilityData__c record : newEntriesWithNullReference){
                if(record.dmpl__ResourceId__c == null || record.dmpl__AttendenceTime__c == null){
                    continue;
                }
                String key=record.dmpl__ResourceId__c +'&'+ String.valueOf(record.dmpl__AttendenceTime__c.Date());
                record.dmpl__ResourceAvailabilityId__c=resourceAvailabilityMap.get(key).id;
            }        
        }catch(Exception e){
			ExceptionLogHelper.logException(e);
            system.debug(e.getMessage());
        }
    }

    private static Map<String,dmpl__ResourceAvailability__c> createResourceAvailability(
        List<dmpl__ResourceAvailabilityData__c> newEntriesWithNullReference){
            Map<String,dmpl__ResourceAvailability__c> resourceAvailabilityMap =getExistingResourceAvailability(
                newEntriesWithNullReference);
            Set<String> visitedSet=new Set<String>();
            List<dmpl__ResourceAvailability__c> toBeInsertedHeaders=new List<dmpl__ResourceAvailability__c>();
            for(dmpl__ResourceAvailabilityData__c record : newEntriesWithNullReference){
                String key=record.dmpl__ResourceId__c +'&'+ String.valueOf(record.dmpl__AttendenceTime__c.Date());
                if(visitedSet.contains(key) || resourceAvailabilityMap.containsKey(key)){
                    continue;
                }
                dmpl__ResourceAvailability__c newRecord = new dmpl__ResourceAvailability__c();
                newRecord.dmpl__Date__c = record.dmpl__AttendenceTime__c.Date();
                newRecord.dmpl__AvailabilityType__c = 'Present';
                newRecord.dmpl__ResourceId__c=record.dmpl__ResourceId__c;
                toBeInsertedHeaders.add(newRecord);
                visitedSet.add(key);
            }
            try{
                if(toBeInsertedHeaders.size()>0){
                    insert toBeInsertedHeaders;
                }
            }catch(Exception e){
                ExceptionLogHelper.logException(e);
                system.debug(e.getMessage());
            }
            for(dmpl__ResourceAvailability__c record:toBeInsertedHeaders){
                String key=record.dmpl__ResourceId__c +'&'+ String.valueOf(record.dmpl__Date__c);
                resourceAvailabilityMap.put(key,record);
            }
            return resourceAvailabilityMap;
       }

    public static Map<String,dmpl__ResourceAvailability__c> getExistingResourceAvailability(
        List<dmpl__ResourceAvailabilityData__c> newEntriesWithNullReference){
        Map<String,dmpl__ResourceAvailability__c> resourceAvailabilityMap=new Map<String,dmpl__ResourceAvailability__c>();
        List<Id> resourceIds = DocumentHelper.extractIds(
            newEntriesWithNullReference, 
            'dmpl__ResourceId__c');
        List<Date> dates=getDates(newEntriesWithNullReference);
        List<dmpl__ResourceAvailability__c> existingHeaders=getExistingHeaders(
            resourceIds,
            dates);
        for(dmpl__ResourceAvailability__c record : existingHeaders){
            String key=record.dmpl__ResourceId__c +'&'+ String.valueOf(record.dmpl__Date__c);               
            resourceAvailabilityMap.put(key,record);               
        }
        return resourceAvailabilityMap;
    }
    
    public static List<Date> getDates(List<dmpl__ResourceAvailabilityData__c> newEntriesWithNullReference){
        List<Date> dates=new List<Date>();
        for(dmpl__ResourceAvailabilityData__c record : newEntriesWithNullReference){
            if(record.dmpl__AttendenceTime__c != null){
                dates.add(record.dmpl__AttendenceTime__c.Date());
            }
        }
        return dates;
    }

    public static void calculatePenaltyHours(
        List<dmpl__ResourceAvailabilityData__c> availabilityData) {
        List<Id> resourceAvailabilityIds = DocumentHelper.extractIds(
            availabilityData, 
            'dmpl__ResourceAvailabilityId__c');
        Map<Id, dmpl__ResourceAvailability__c> availabilityMap = new Map<Id, dmpl__ResourceAvailability__c>(
            [SELECT 
                Id, 
                Name, 
                dmpl__PenaltyHours__c 
                FROM 
                dmpl__ResourceAvailability__c 
                WHERE Id IN :resourceAvailabilityIds]
        );
    
        Map<Id, dmpl__ResourceAvailabilityData__c> checkOutMap = new Map<Id, dmpl__ResourceAvailabilityData__c>();
        for (dmpl__ResourceAvailabilityData__c record : [
            SELECT 
                Id, 
                dmpl__ResourceAvailabilityId__c, 
                dmpl__Type__c, 
                dmpl__AttendenceTime__c
            FROM dmpl__ResourceAvailabilityData__c
            WHERE dmpl__ResourceAvailabilityId__c IN :resourceAvailabilityIds 
            AND dmpl__Type__c = 'Check-Out'
            ORDER BY CreatedDate DESC
        ]) {
            checkOutMap.put(record.dmpl__ResourceAvailabilityId__c, record);
        }
    
        for (dmpl__ResourceAvailabilityData__c data : availabilityData) {
            if (data.dmpl__Type__c == 'Check-In' && checkOutMap.containsKey(data.dmpl__ResourceAvailabilityId__c)) {
                dmpl__ResourceAvailabilityData__c checkOutData = checkOutMap.get(data.dmpl__ResourceAvailabilityId__c); 
                if (data.dmpl__AttendenceTime__c != null && checkOutData.dmpl__AttendenceTime__c != null) {
                    Long timeDifferenceMillis = data.dmpl__AttendenceTime__c.getTime() - checkOutData.dmpl__AttendenceTime__c.getTime();
                    Decimal gapInHours = Decimal.valueOf(timeDifferenceMillis) / (60 * 60 * 1000);
                    dmpl__ResourceAvailability__c availability = availabilityMap.get(data.dmpl__ResourceAvailabilityId__c);
                    if (availability != null) {
                        availability.dmpl__PenaltyHours__c = (availability.dmpl__PenaltyHours__c != null)
                            ? availability.dmpl__PenaltyHours__c + gapInHours
                            : gapInHours;
                    }
                }
            }
        }
        if (!availabilityMap.isEmpty()) {
            update availabilityMap.values();
        }
    }
    

    public static List<dmpl__ResourceAvailability__c> getExistingHeaders(
        List<Id> resourceIds,
        List<Date> dates){
            return [
                Select 
                    Id,
                    dmpl__Date__c,
                    dmpl__AvailabilityType__c,
                    dmpl__ResourceId__c
                from 
                    dmpl__ResourceAvailability__c
                where 
                    dmpl__Date__c in:dates
                    and dmpl__ResourceId__c in:resourceIds];
        }
}