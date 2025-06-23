public  class VisitRouteService  extends MetadataService{
    public VisitRouteService() {
        super('dmpl__VisitRoute__c');
    }
    public static void syncDayNumbers(List<dmpl__VisitRoute__c> visitRoutes){
        for(dmpl__VisitRoute__c record : visitRoutes){
            if(record.dmpl__DayNumbers__c==null 
               || record.dmpl__DayNumbers__c.length()==0){
                    if(record.dmpl__MondayAvailable__c==true){
                        record.dmpl__DayNumbers__c+='1,';
                    }
                    if(record.dmpl__TuesdayAvailable__c==true){
                        record.dmpl__DayNumbers__c+='2,';
                    }
                    if(record.dmpl__WednesdayAvailable__c==true){
                        record.dmpl__DayNumbers__c+='3,';
                    }
                    if(record.dmpl__ThursdayAvailable__c==true){
                        record.dmpl__DayNumbers__c+='4,';
                    }
                    if(record.dmpl__FridayAvailable__c==true){
                        record.dmpl__DayNumbers__c+='5,';
                    }
                    if(record.dmpl__SaturdayAvailable__c==true){
                        record.dmpl__DayNumbers__c+='6,';
                    }
                    if(record.dmpl__SundayAvailable__c==true){
                        record.dmpl__DayNumbers__c+='7,';
                    }
                    if(record.dmpl__DayNumbers__c!=null){
                        record.dmpl__DayNumbers__c=record.dmpl__DayNumbers__c.removeEnd(',');
                        record.dmpl__DayNumbers__c=record.dmpl__DayNumbers__c.removeStart('null');
                    }
                }
            else{
                if(record.dmpl__DayNumbers__c.contains('1')){
                    record.dmpl__MondayAvailable__c=true;
                }
                if(record.dmpl__DayNumbers__c.contains('2')){
                    record.dmpl__TuesdayAvailable__c=true;
                }
                if(record.dmpl__DayNumbers__c.contains('3')){
                    record.dmpl__WednesdayAvailable__c=true;
                }
                if(record.dmpl__DayNumbers__c.contains('4')){
                    record.dmpl__ThursdayAvailable__c=true;
                }
                if(record.dmpl__DayNumbers__c.contains('5')){
                    record.dmpl__FridayAvailable__c=true;
                }
                if(record.dmpl__DayNumbers__c.contains('6')){
                    record.dmpl__SaturdayAvailable__c=true;
                }
                if(record.dmpl__DayNumbers__c.contains('7')){
                    record.dmpl__SundayAvailable__c=true;
                }
            }
        }
    }
    public static void syncUpdateDayNumbers(
        List<dmpl__VisitRoute__c> newEntries,
        List<dmpl__VisitRoute__c> oldEntries){
            Map<Id,dmpl__VisitRoute__c> oldObjectMap=new Map<Id,dmpl__VisitRoute__c>(oldEntries);
            for(dmpl__VisitRoute__c record : newEntries){
               dmpl__VisitRoute__c oldRecord=oldObjectMap.get(record.Id);
                if(record.dmpl__DayNumbers__c != oldRecord.dmpl__DayNumbers__c){
                    updateDayNumbers(record);
                }
                else {
                    updateDayNumbers2(record);
                }               
            }
    }

    private static void updateDayNumbers(dmpl__VisitRoute__c record){
        // String to PickList
        if(record.dmpl__DayNumbers__c.contains('1')){
            record.dmpl__MondayAvailable__c=true;
        }
        else{
            record.dmpl__MondayAvailable__c=false;
        }
        if(record.dmpl__DayNumbers__c.contains('2')){
            record.dmpl__TuesdayAvailable__c=true;
        }
        else{
            record.dmpl__TuesdayAvailable__c=false;
        }
        if(record.dmpl__DayNumbers__c.contains('3')){
            record.dmpl__WednesdayAvailable__c=true;
        }
        else{
            record.dmpl__WednesdayAvailable__c=false;
        }
        if(record.dmpl__DayNumbers__c.contains('4')){
            record.dmpl__ThursdayAvailable__c=true;
        }
        else{
            record.dmpl__ThursdayAvailable__c=false;
        }
        if(record.dmpl__DayNumbers__c.contains('5')){
            record.dmpl__FridayAvailable__c=true;
        }
        else{
            record.dmpl__FridayAvailable__c=false;
        }
        if(record.dmpl__DayNumbers__c.contains('6')){
            record.dmpl__SaturdayAvailable__c=true;
        }
        else{
            record.dmpl__SaturdayAvailable__c=false;
        }
        if(record.dmpl__DayNumbers__c.contains('7')){
            record.dmpl__SundayAvailable__c=true;
        }
        else{
            record.dmpl__SundayAvailable__c=false;
        }
    } 
    
    @testVisible
    private static void updateDayNumbers2(dmpl__VisitRoute__c record){
        //PickList to string
        record.dmpl__DayNumbers__c+=',';
        if(record.dmpl__MondayAvailable__c==true && record.dmpl__DayNumbers__c.containsNone('1')){
            record.dmpl__DayNumbers__c+='1,';
        }
        else if(record.dmpl__MondayAvailable__c==false && record.dmpl__DayNumbers__c.contains('1')){
            record.dmpl__DayNumbers__c=record.dmpl__DayNumbers__c.remove('1,');
        }
        if(record.dmpl__TuesdayAvailable__c==true && record.dmpl__DayNumbers__c.containsNone('2')){
            record.dmpl__DayNumbers__c+='2,';
        }
        else if(record.dmpl__TuesdayAvailable__c==false && record.dmpl__DayNumbers__c.contains('2')){
            record.dmpl__DayNumbers__c=record.dmpl__DayNumbers__c.remove('2,');
        }
        if(record.dmpl__WednesdayAvailable__c==true && record.dmpl__DayNumbers__c.containsNone('3')){
            record.dmpl__DayNumbers__c+='3,';
        }
        else if(record.dmpl__WednesdayAvailable__c==false && record.dmpl__DayNumbers__c.contains('3')){
            record.dmpl__DayNumbers__c=record.dmpl__DayNumbers__c.remove('3,');
        }
        if(record.dmpl__ThursdayAvailable__c==true && record.dmpl__DayNumbers__c.containsNone('4')){
            record.dmpl__DayNumbers__c+='4,';
        }
        else if(record.dmpl__ThursdayAvailable__c==false && record.dmpl__DayNumbers__c.contains('4')){
            record.dmpl__DayNumbers__c=record.dmpl__DayNumbers__c.remove('4,');
        }
        if(record.dmpl__FridayAvailable__c==true && record.dmpl__DayNumbers__c.containsNone('5')){
            record.dmpl__DayNumbers__c+='5,';
        }
        else if(record.dmpl__FridayAvailable__c==false && record.dmpl__DayNumbers__c.contains('5')){
            record.dmpl__DayNumbers__c=record.dmpl__DayNumbers__c.remove('5,');
        }
        if(record.dmpl__SaturdayAvailable__c==true && record.dmpl__DayNumbers__c.containsNone('6')){
            record.dmpl__DayNumbers__c+='6,';
        }
        else if(record.dmpl__SaturdayAvailable__c==false && record.dmpl__DayNumbers__c.contains('6')){
            record.dmpl__DayNumbers__c=record.dmpl__DayNumbers__c.remove('6,');
        }
        if(record.dmpl__SundayAvailable__c==true && record.dmpl__DayNumbers__c.containsNone('7')){
            record.dmpl__DayNumbers__c+='7,';
        }
        else if(record.dmpl__SundayAvailable__c==false && record.dmpl__DayNumbers__c.contains('7')){
            record.dmpl__DayNumbers__c=record.dmpl__DayNumbers__c.remove('7,');
        }
        record.dmpl__DayNumbers__c=record.dmpl__DayNumbers__c.removeEnd(',');

    }

}