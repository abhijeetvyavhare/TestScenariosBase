public with sharing class BranchTimeSlotBookingHelper {
    private static Boolean skipValidations = false;
    private static final string OBJECT_BRANCHTS = 'dmpl__BranchTimeSlotBooking__c';
    private static final string OBJECT_PRODUCTDEMO = 'dmpl__ProductDemo__c';
    private static final string FIELD_PRODUCTDEMO_DEMODATE ='dmpl__DemoDate__c';
    private static final string FIELD_PRODUCTDEMO_DEMOTIME ='dmpl__DemoTime__c';
    private static final string FIELD_PRODUCTDEMO_SLOTID ='dmpl__DemoSlotId__c';
    private static final string FIELD_PRODUCTDEMO_TIMESLOTBOOKINGID ='dmpl__DemoTimeSlotBookingId__c';

    private static final string OBJECT_SERVICEREQUEST = 'dmpl__ServiceRequest__c';
    private static final string FIELD_SERVICEREQUEST_SLOTID ='dmpl__AppointmentTimeSlotId__c';
    private static final string FIELD_SERVICEREQUEST_APPOINTMENTDATE = 'dmpl__AppointmentDate__c';
    private static final string FIELD_SERVICEREQUEST_TIMESLOTBOOKINGID = 'dmpl__ServiceRequestTimeSlotBookingId__c';

    private static final List<String> LIST_NON_EDITABLE_FIELDS = new List<String>{};
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{};

    public static void validateData(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__BranchTimeSlotBooking__c> oldEntries, List<dmpl__BranchTimeSlotBooking__c> newEntries)
    { 
        try{     
            if(isInsert){
                FieldMappingHelper.copyFieldMappingData(
                    newEntries);
            }
            if(skipValidations){
                return;
            }
            if(isInsert){
            }else if(isUpdate){
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, oldEntries, newEntries);
            }else if(isDelete){
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void reserveDemoTimeSlots(List<dmpl__ProductDemo__c> demoEntries){
        List<dmpl__BranchTimeSlot__c> slots = queryAssosciatedTimeSlots(
            DocumentHelper.extractIds(
                demoEntries, 
                FIELD_PRODUCTDEMO_SLOTID),
                DocumentHelper.extractUniqueDateValues(
                    demoEntries, 
                    FIELD_PRODUCTDEMO_DEMODATE));

        SecurityHelper.ensureCanWriteFields(new string[]
        {
            'dmpl__DemoTime__c',
            'dmpl__DemoDateTime__c'
        }, 
            OBJECT_PRODUCTDEMO);

        Map<Id, dmpl__Item__c> items = new Map<Id, dmpl__Item__c>(
            ItemHelper.getCachedItems(
                CollectionHelper.extractIds(
                    demoEntries, 
                    'dmpl__ItemId__c')));        
        List<dmpl__BranchTimeSlotBooking__c> updatedBooking = new List<dmpl__BranchTimeSlotBooking__c>();
        List<dmpl__BranchTimeSlotBooking__c> insertedBooking = new List<dmpl__BranchTimeSlotBooking__c>();
        for(dmpl__ProductDemo__c demoEntry : demoEntries){
            if(demoEntry.dmpl__DemoSlotId__c!=null){ 
                if(demoEntry.dmpl__IsConfirmed__c && !demoEntry.dmpl__IsCancelled__c){
                    dmpl__BranchTimeSlot__c slot = (dmpl__BranchTimeSlot__c)DocumentHelper.getObject(slots, demoEntry.dmpl__DemoSlotId__c);
                    dmpl__Item__c item = demoEntry.dmpl__ItemId__c ==null?null:items.get(demoEntry.dmpl__ItemId__c);
                    if(slot.dmpl__BranchId__c!= demoEntry.dmpl__BranchId__c){
                        demoEntry.addError(System.Label.IntegrityFailed_InvalidBranch);
                    }else if(!slot.dmpl__IsActive__c){
                        demoEntry.addError(System.Label.ProductDemo_InactiveSlot);
                    }else if(slot.dmpl__ApplicableToItem__c!=null
                        && slot.dmpl__ApplicableToItem__c!=demoEntry.dmpl__ItemId__c
                        && item?.dmpl__ProductDemoItemGroup__c != slot.dmpl__ApplicableToItemGroup__c){
                        demoEntry.addError(System.Label.ProductDemo_InvalidItem);
                    }else if(slot.dmpl__ServiceType__c!=null
                        && slot.dmpl__ServiceType__c!=demoEntry.dmpl__ServiceType__c){
                        demoEntry.addError(System.Label.ProductDemo_InvalidServiceType);
                    }else if(slot.dmpl__ServiceJobType__c!=null
                        && slot.dmpl__ServiceJobType__c!=demoEntry.dmpl__ServiceJobType__c){
                        demoEntry.addError(System.Label.ProductDemo_InvalidServiceJobType);
                    }else{
                        demoEntry.dmpl__DemoTime__c = slot.dmpl__StartTime__c;
                        dmpl__BranchTimeSlotBooking__c booking =  getSlotBooking(slot, demoEntry.dmpl__DemoDate__c);
                        if(booking != null){
                            booking.dmpl__CapacityUtilized__c += 1;
                            updatedBooking.add(booking);
                        }else{
                            booking = createNewSlotBooking(slot, demoEntry.dmpl__DemoDate__c);
                            booking.dmpl__CapacityUtilized__c = 1;
                            insertedBooking.add(booking);
                        }
                        demoEntry.dmpl__DemoTimeSlotBookingId__c = booking.Id;
                        demoEntry.dmpl__DemoTimeSlotBookingId__r = booking;
                    }
                }else {
                    demoEntry.dmpl__DemoTimeSlotBookingId__c =null;
                    demoEntry.dmpl__IsConfirmed__c =false;
                }
            }
            if(demoEntry.dmpl__DemoDate__c!=null && demoEntry.dmpl__DemoTime__c!=null){
                demoEntry.dmpl__DemoDateTime__c = Datetime.newInstance(demoEntry.dmpl__DemoDate__c,demoEntry.dmpl__DemoTime__c);
            }
        }

        if(updatedBooking.size()>0){
            SecurityHelper.ensureCanWriteFields(new string[]{
                'dmpl__BookingDate__c',
                'dmpl__CapacityUtilized__c'
            }, 'dmpl__BranchTimeSlotBooking__c');
            update updatedBooking;
        }

        if(insertedBooking.size()>0){
            SecurityHelper.ensureCanCreateFields(new string[]{
                'dmpl__BookingDate__c',
                'dmpl__CapacityUtilized__c'
            }, 'dmpl__BranchTimeSlotBooking__c');
            insert  insertedBooking;
            for(dmpl__ProductDemo__c demoEntry : demoEntries){
                for (dmpl__BranchTimeSlotBooking__c booking : insertedBooking) {
                    if(demoEntry.dmpl__DemoTimeSlotBookingId__r == booking){
                        demoEntry.dmpl__DemoTimeSlotBookingId__c = booking.Id;
                        break;
                    }
                }    
            }
        }
    }

    public static void releaseDemoTimeSlots(List<dmpl__ProductDemo__c> demoEntries){
        List<dmpl__BranchTimeSlotBooking__c> bookings = queryAssosciatedTimeSlotBookings(DocumentHelper.extractIds(demoEntries, FIELD_PRODUCTDEMO_TIMESLOTBOOKINGID));
        SecurityHelper.ensureCanWriteFields(new string[]{
            'dmpl__BookingDate__c',
            'dmpl__CapacityUtilized__c'
        }, 'dmpl__BranchTimeSlotBooking__c');
        List<dmpl__BranchTimeSlotBooking__c> updatedBooking = new List<dmpl__BranchTimeSlotBooking__c>();
        for(dmpl__ProductDemo__c demoEntry : demoEntries){
            if(demoEntry.dmpl__DemoTimeSlotBookingId__c!=null){
                    dmpl__BranchTimeSlotBooking__c booking =  (dmpl__BranchTimeSlotBooking__c)DocumentHelper.getObject(bookings, demoEntry.dmpl__DemoTimeSlotBookingId__c);
                    if(booking != null){
                        booking.dmpl__CapacityUtilized__c -= 1;
                        updatedBooking.add(booking);
                    }
            }
        }

        if(updatedBooking.size()>0){
            SecurityHelper.ensureCanWriteFields(new string[]{
                'dmpl__BookingDate__c',
                'dmpl__CapacityUtilized__c'
            }, 'dmpl__BranchTimeSlotBooking__c');
            update updatedBooking;
        }
    }

    @TestVisible private static dmpl__BranchTimeSlotBooking__c createNewSlotBooking(dmpl__BranchTimeSlot__c slot, Date demoDate){
        return new dmpl__BranchTimeSlotBooking__c(
            dmpl__BookingDate__c = demoDate,
            dmpl__BranchTimeSlotId__c = slot.Id,
            dmpl__Capacity__c = getDailyCapcity(demoDate, slot),
            dmpl__CapacityUtilized__c =0
        );
    }

    private static Decimal getDailyCapcity(Date bookingDate, dmpl__BranchTimeSlot__c slot){
        Integer dayOfWeek = Math.mod(Date.newInstance(1900, 1, 1).daysBetween(bookingDate), 7);
        if(dayOfWeek == 0 && slot.dmpl__MondayCapacity__c!=null){
            return slot.dmpl__MondayCapacity__c;
        } else if(dayOfWeek == 1 && slot.dmpl__TuesdayCapacity__c!=null){
            return  slot.dmpl__TuesdayCapacity__c;
        } else if(dayOfWeek == 2 && slot.dmpl__WednesdayCapacity__c!=null){
            return  slot.dmpl__WednesdayCapacity__c;
        } else if(dayOfWeek == 3 && slot.dmpl__ThursdayCapacity__c!=null){
            return  slot.dmpl__ThursdayCapacity__c;
        } else if(dayOfWeek == 4 && slot.dmpl__FridayCapacity__c!=null){
            return  slot.dmpl__FridayCapacity__c;
        } else if(dayOfWeek == 5 && slot.dmpl__SaturdayCapacity__c!=null){
            return  slot.dmpl__SaturdayCapacity__c;
        } else if(dayOfWeek == 6 && slot.dmpl__SundayCapacity__c!=null){
            return  slot.dmpl__SundayCapacity__c;
        } else {
            return  slot.dmpl__MaximumCapacity__c;
        }
    }

    private static dmpl__BranchTimeSlotBooking__c getSlotBooking(dmpl__BranchTimeSlot__c slot, Date bookingDate){
        for(dmpl__BranchTimeSlotBooking__c booking : slot.dmpl__BranchTimeSlotBookings__r){
            if(booking.dmpl__BookingDate__c == bookingDate){
                return booking; 
            }
        }
        return null;
    }

    private static List<dmpl__BranchTimeSlot__c> queryAssosciatedTimeSlots(List<Id> slotIds, List<Date> slotDates){
        SecurityHelper.ensureCanReadFields(new String[]{
            'dmpl__StartTime__c',
            'dmpl__EndTime__c',
            'dmpl__MaximumCapacity__c',
            'dmpl__IsActive__c',
            'dmpl__ApplicableToItem__c',
            'dmpl__ApplicableToItemGroup__c',
            'dmpl__ServiceType__C',
            'dmpl__ServiceJobType__C',
            'dmpl__TransactionType__c',
            'dmpl__FridayCapacity__c',
            'dmpl__MondayCapacity__c',
            'dmpl__SaturdayCapacity__c',
            'dmpl__SundayCapacity__c',
            'dmpl__ThursdayCapacity__c',
            'dmpl__TuesdayCapacity__c',
            'dmpl__WednesdayCapacity__c'
        },
        'dmpl__BranchTimeSlot__c');
        SecurityHelper.ensureCanReadFields(new String[]{
            'dmpl__BookingDate__c',
            'dmpl__Capacity__c',
            'dmpl__CapacityUtilized__c'},
        'dmpl__BranchTimeSlotBooking__c');
        return [SELECT Id, 
                dmpl__BranchId__c,
                dmpl__StartTime__c, 
                dmpl__EndTime__c,
                dmpl__MaximumCapacity__c,
                dmpl__IsActive__c,
                dmpl__ApplicableToItem__c,
                dmpl__ApplicableToItemGroup__c,
                dmpl__TransactionType__c,
                dmpl__ServiceType__C,
                dmpl__ServiceJobType__C,
                dmpl__FridayCapacity__c,
                dmpl__MondayCapacity__c,
                dmpl__SaturdayCapacity__c,
                dmpl__SundayCapacity__c,
                dmpl__ThursdayCapacity__c,
                dmpl__TuesdayCapacity__c,
                dmpl__WednesdayCapacity__c,
                    (SELECT Id,
                    dmpl__BookingDate__c,
                    dmpl__Capacity__c,
                    dmpl__CapacityUtilized__c
                    FROM dmpl__BranchTimeSlotBookings__r
                    WHERE dmpl__BookingDate__c IN:slotDates) 
                FROM dmpl__BranchTimeSlot__c 
                WHERE Id IN:slotIds];
    }

    private static List<dmpl__BranchTimeSlotBooking__c> queryAssosciatedTimeSlotBookings(List<Id> tineSlotIds){
        SecurityHelper.ensureCanReadFields(new String[]{'dmpl__BookingDate__c', 'dmpl__Capacity__c', 'dmpl__CapacityUtilized__c'}, 'dmpl__BranchTimeSlotBooking__c');
        return [SELECT Id,
                dmpl__BookingDate__c,
                dmpl__Capacity__c,
                dmpl__CapacityUtilized__c
                FROM dmpl__BranchTimeSlotBooking__c
                WHERE Id IN:tineSlotIds];
    }
}