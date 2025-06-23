@namespaceAccessible
public with sharing class BranchDateSlotResult {

    @namespaceAccessible
    public BranchDateSlotResult(Date bookingDate, Decimal capacity, Decimal capacityUtilized){
        this.bookingDate = bookingDate;
        this.capacity = capacity;
        this.capacityUtilized = capacityUtilized;
    }

    @AuraEnabled
    public Date bookingDate { get; set; }

    @AuraEnabled
    public Decimal capacity { get; set; }

    @AuraEnabled
    public Decimal capacityUtilized { get; set; }
}