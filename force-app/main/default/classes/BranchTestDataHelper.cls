public with sharing class BranchTestDataHelper {
    public static dmpl__BranchDateSlotResult__c createBranchDateSlotResult(){
        return (dmpl__BranchDateSlotResult__c) TestFactory.createSObject(
            new dmpl__BranchDateSlotResult__c(
                dmpl__BookingDate__c = Date.today(),
                Name = 'Demo1',
                dmpl__Capacity__c = 12,
                dmpl__CapacityUtilized__c = 6            
            ),
            'BranchDateSlotResultDefaults',
            true
        );
    }

    public static dmpl__BranchDateSlotResult__c createBranchDateSlotResult(String name){
        return (dmpl__BranchDateSlotResult__c) TestFactory.createSObject(
            new dmpl__BranchDateSlotResult__c(
                dmpl__BookingDate__c = Date.today(),
                Name = name,
                dmpl__Capacity__c = 12,
                dmpl__CapacityUtilized__c = 6            
            ),
            'BranchDateSlotResultDefaults',
            true
        );
    }
    public static dmpl__BranchDateSlotResult__c getBranchDateSlotResult() {
        return [SELECT 
                Id, 
                Name,
                dmpl__BookingDate__c,
                dmpl__Capacity__c,
                dmpl__CapacityUtilized__c
                FROM dmpl__BranchDateSlotResult__c 
                LIMIT 1   
        ];
    }
    public static dmpl__BranchDateSlotResult__c getBranchDateSlotResult(Id branchDateSlotResultId) {
        return [SELECT 
                Id, 
                Name,
                dmpl__BookingDate__c,
                dmpl__Capacity__c,
                dmpl__CapacityUtilized__c
                FROM dmpl__BranchDateSlotResult__c 
                WHERE Id=:branchDateSlotResultId
                LIMIT 1   
        ];
    }

    public static dmpl__BranchPostalCode__c getBranchPostalCode(Id branchPostalCodeId){
        return [SELECT 
                Id,
                Name,
                dmpl__BranchId__c,
                dmpl__PartnerAccountId__c,
                dmpl__PostalCodeId__c,
                dmpl__CoverageType__c
                FROM dmpl__BranchPostalCode__c 
                WHERE Id = :branchPostalCodeId
                LIMIT 1  
        ];
    }
    public static dmpl__BranchPostalCode__c getBranchPostalCode(){
        return [SELECT 
                Id,
                Name,
                dmpl__BranchId__c,
                dmpl__PartnerAccountId__c,
                dmpl__PostalCodeId__c,
                dmpl__CoverageType__c
                FROM dmpl__BranchPostalCode__c 
                LIMIT 1  
        ];
    }

    public static dmpl__BranchTimeSlotBooking__c getBranchTimeSlotBooking(){
        return [
            SELECT
            Id,
            Name,
            dmpl__CapacityUtilized__c,
            dmpl__Capacity__c,
            dmpl__BranchTimeSlotId__c,
            dmpl__BookingDate__c
            FROM dmpl__BranchTimeSlotBooking__c 
            LIMIT 1  

        ];
    }

    public static dmpl__BranchTimeSlotBooking__c getBranchTimeSlotBooking(Id branchTimeSlotBookingId){
        return [
            SELECT
            Id,
            Name,
            dmpl__CapacityUtilized__c,
            dmpl__Capacity__c,
            dmpl__BranchTimeSlotId__c,
            dmpl__BookingDate__c
            FROM dmpl__BranchTimeSlotBooking__c 
            WHERE Id =:branchTimeSlotBookingId
            LIMIT 1  

        ];
    }

    public static dmpl__BranchTimeSlot__c getbranchTimeSlot(Id branchTimeSlotId){
        return [
            SELECT
            Id,
            Name,
            dmpl__BranchId__c,
            dmpl__TransactionType__c,
            dmpl__IsActive__c,
            dmpl__ApplicableToItem__c,
            dmpl__MaximumCapacity__c,
            dmpl__MondayCapacity__c,
            dmpl__StartTime__c,
            dmpl__EndTime__c,
            dmpl__TuesdayCapacity__c,
            dmpl__WednesdayCapacity__c,
            dmpl__ThursdayCapacity__c,
            dmpl__FridayCapacity__c,
            dmpl__SaturdayCapacity__c,
            dmpl__SundayCapacity__c
            FROM dmpl__BranchTimeSlot__c
            WHERE Id = : branchTimeSlotId
            LIMIT 1
        ];
    }
    public static dmpl__BranchTimeSlot__c getbranchTimeSlot(){
        return [
            SELECT
            Id,
            Name,
            dmpl__BranchId__c,
            dmpl__TransactionType__c,
            dmpl__IsActive__c,
            dmpl__ApplicableToItem__c,
            dmpl__MaximumCapacity__c,
            dmpl__MondayCapacity__c,
            dmpl__TuesdayCapacity__c,
            dmpl__WednesdayCapacity__c,
            dmpl__ThursdayCapacity__c,
            dmpl__FridayCapacity__c,
            dmpl__SaturdayCapacity__c,
            dmpl__SundayCapacity__c
            FROM dmpl__BranchTimeSlot__c
            LIMIT 1
        ];
    }

    public static dmpl__PostalCode__c getPostalCode(Id PostalCodeId) {
        return [SELECT 
                Id, 
                Name
                FROM dmpl__PostalCode__c
                WHERE  Id =:PostalCodeId
                LIMIT 1   
        ];
    }

     public static dmpl__PostalCode__c getPostalCode() {
        return [SELECT 
                Id, 
                Name
                FROM dmpl__PostalCode__c
                LIMIT 1   
        ];
    }
    

    public static dmpl__Place__c createParentPlace(){
        return (dmpl__Place__c)TestFactory.createSObject(
            new dmpl__Place__c(
                dmpl__Level__c = 22,
                Name = 'Parent Place',
                dmpl__PlaceType__c='City'
            ),
            'ParentPlaceDefaults',
            true
        );
    }

    public static dmpl__Place__c createPlace(dmpl__Place__c parentPlace){
        return (dmpl__Place__c)TestFactory.createSObject(
            new dmpl__Place__c(
                dmpl__Level__c = 22,
                Name = 'Parent Place',
                dmpl__PlaceType__c='City',
                dmpl__ParentPlaceId__c = parentPlace.Id

            ),
            'PlaceDefaults',            
            true
        );
    }

    public static dmpl__PostalCode__c createPostalCode(dmpl__Place__c place) {
        return (dmpl__PostalCode__c) TestFactory.createSObject(
            new dmpl__PostalCode__c(
                dmpl__City__c = 'Mumbai',
                dmpl__CityPlaceId__c = place.Id,
                dmpl__Country__c = 'India',
                Name = 'newPostalCode',
                dmpl__Region__c = 'West',
                dmpl__State__c = 'Maharashtra'
            ),
            'PostalCodeDefaults',


            true
        );
    }


    public static dmpl__PostalCode__c createPostalCode(String Name) {
        return (dmpl__PostalCode__c) TestFactory.createSObject(
            new dmpl__PostalCode__c(
                dmpl__City__c = 'Mumbai',
                Name = Name,
                dmpl__Country__c = 'India',
                dmpl__Region__c = 'West',
                dmpl__State__c = 'Maharashtra'
            ),
            true
        );
    }

    public static dmpl__BranchPostalCode__c createBranchPostalCode(Account partnerAccount,
        dmpl__Branch__c branch, dmpl__PostalCode__c postalCode){
        return (dmpl__BranchPostalCode__c) TestFactory.createSObject(
            new dmpl__BranchPostalCode__c(
                dmpl__BranchId__c = branch.Id,
                dmpl__PartnerAccountId__c = partnerAccount.Id,
                dmpl__PostalCodeId__c = postalCode.Id,
                dmpl__CoverageType__c = 'Sale'
                
            ),
            'BranchPostalCodeDefaults',
            true
        );
    }

    public static dmpl__BranchPostalCode__c createBranchPostalCode(
        Account partnerAccount,
        dmpl__Branch__c branch, 
        dmpl__PostalCode__c postalCode,
        String CoverageType){
        return (dmpl__BranchPostalCode__c) TestFactory.createSObject(
            new dmpl__BranchPostalCode__c(
                dmpl__PartnerAccountId__c = partnerAccount != null ? partnerAccount.Id : null,
                dmpl__BranchId__c = branch != null ? branch.Id : null,
                dmpl__PostalCodeId__c = postalCode?.Id,
                dmpl__CoverageType__c = CoverageType
            ),
            true
        );
    }

    public static dmpl__BranchTimeSlot__c createBranchTimeSlot(dmpl__Item__c item , dmpl__Branch__c branch){
        return(dmpl__BranchTimeSlot__c)TestFactory.createSObject(
            new dmpl__BranchTimeSlot__c(
                dmpl__BranchId__c = branch.Id,
                dmpl__TransactionType__c = 'Delivery',
                Name = 'Test - branchTimeSlot',
                dmpl__IsActive__c = True,
                dmpl__ApplicableToItem__c= item.Id,
                dmpl__MaximumCapacity__c = 12,                                                    
                dmpl__MondayCapacity__c = 12,
                dmpl__TuesdayCapacity__c = 12,
                dmpl__WednesdayCapacity__c = 12,
                dmpl__ThursdayCapacity__c = 12,
                dmpl__FridayCapacity__c = 12,
                dmpl__SaturdayCapacity__c = 12,
                dmpl__SundayCapacity__c = 12
            ),
            'BranchTimeSlotDefaults',
            true
        );
    }

    public static dmpl__BranchTimeSlotBooking__c createBranchTimeSlotBooking(dmpl__BranchTimeSlot__c branchTimeSlot){
        return(dmpl__BranchTimeSlotBooking__c)TestFactory.createSObject(
            new dmpl__BranchTimeSlotBooking__c(
                dmpl__BranchTimeSlotId__c = branchTimeSlot.Id,
                dmpl__BookingDate__c = date.today(),
                dmpl__Capacity__c = 10,
                dmpl__CapacityUtilized__c = 5
            ),
            'BranchTimeSlotBookingDefaults',
            true
        );
    }

     public static dmpl__BranchTimeSlotBooking__c createBranchTimeSlotBooking(
        Id branchTimeSlotId,
        String name,
        Integer Capacity
        ){
        return(dmpl__BranchTimeSlotBooking__c)TestFactory.createSObject(
            new dmpl__BranchTimeSlotBooking__c(
                dmpl__BranchTimeSlotId__c = branchTimeSlotId,
                dmpl__BookingDate__c = date.today(),
                dmpl__Capacity__c = Capacity,
                dmpl__CapacityUtilized__c = 5

            ),
            'BranchTimeSlotBookingDefaults',
            true
        );
    }

    public static dmpl__ItemGroup__c createItemGroup(){
        return (dmpl__ItemGroup__c)TestFactory.createSObject(
            new dmpl__ItemGroup__c(
                Name = 'Item Group Test',
                dmpl__ItemGroupType__c = 'Scheme'
            ),
            'ItemGroupDefaults',
            true
        );
    }

     public static dmpl__BranchTimeSlot__c createBranchTimeSlot(dmpl__Branch__c branch,String name,Time  startTime,Time  endTime,Decimal maximumCapacity){
        return(dmpl__BranchTimeSlot__c)TestFactory.createSObject(
            new dmpl__BranchTimeSlot__c(
                dmpl__BranchId__c = branch != null ? branch.Id: null,
                dmpl__TransactionType__c = 'Delivery',
                Name = name,
                dmpl__IsActive__c = True,
                dmpl__MaximumCapacity__c = MaximumCapacity,                                                    
                dmpl__StartTime__c = startTime,
                dmpl__EndTime__c = endTime,                                                    
                dmpl__MondayCapacity__c = 12,
                dmpl__TuesdayCapacity__c = 12,
                dmpl__WednesdayCapacity__c = 12,
                dmpl__ThursdayCapacity__c = 12,
                dmpl__FridayCapacity__c = 12,
                dmpl__SaturdayCapacity__c = 12,
                dmpl__SundayCapacity__c = 12
            ),
            'BranchTimeSlotDefaults',
            true
        );
    }

}