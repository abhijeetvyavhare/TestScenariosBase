import { LightningElement, api, wire, track } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import {
    subscribe,
    unsubscribe,
    MessageContext
} from 'lightning/messageService';
import FORCEREFRESHMC from '@salesforce/messageChannel/ForceReset__c';
import getBranchDateSlots from '@salesforce/apex/BranchController.getBranchDateSlots';
import getBranchTimeSlots from '@salesforce/apex/BranchController.getBranchTimeSlots';
import getFieldsByFieldSetName from '@salesforce/apex/MetadataController.getFieldsByFieldSetName';

const DELAY = 100;
const GREEN_THRESHOLD = 75;
const PRODUCTDEMOOBJECT = 'dmpl__ProductDemo__c';

export default class TimeSlotPanel extends LightningElement {
    @api title;
    @api availableLabel;
    @api noDataMessage;
    @api noDataMessageSlot;
    @api daysCount;
    @api errors;
    @api transactionType;
    @api siteTransactionType;
    @api privateBranchId;
    @api itemId='';
    @api serviceType='';
    @api serviceJobType='';
    @api bookingDate;
    @api isOnsiteSelected = false;
    @api recordFieldsetName;
    @api objectApiName;
    selectedTimeSlotId;
    dateSlotsValue;
    dateSlots;
    timeSlotsValue;
    timeSlots;
    showFilterPanel=true;
    @api
    get branchId() {
        return this.privateBranchId;
    }
    set branchId(value) {
        if(this.privateBranchId !=value){
            this.dateSlots = undefined;
            this.timeSlots = undefined;
            this.privateBranchId = value;
            this.setAttribute('branchId', this.privateBranchId);
        }else {
            this.privateBranchId = value;
            this.setAttribute('branchId', this.privateBranchId);
        }
    }

    @wire(getBranchDateSlots, {
        transactionType: '$getTransactionType',
        branchId: '$branchId', 
        itemId: '$itemId',
        serviceType: '$serviceType',
        serviceJobType: '$serviceJobType',
        daysCount: '$daysCount'
    })wiredDateSlots(value)
    {
        this.dateSlotsValue = value;
        const { data, error } = value;
        if (data) {
            this.errors = undefined;
            this.dateSlots = data.map((r)=> { 
                return {
                    'bookingDate': r.bookingDate, 
                    'available': this.getAvailableDateSlots(r), 
                    'percentage': this.getDateSlotsPercentUtilized(r)
                }});
        } else if (error) {
            this.errors = error;
            this.dateSlots = undefined;
        }
    }

    @wire(getBranchTimeSlots, {
        transactionType: '$getTransactionType',
        branchId: '$branchId', 
        itemId: '$itemId',
        serviceType: '$serviceType',
        serviceJobType: '$serviceJobType',
        bookingDate: '$bookingDate',
    })wiredTimeSlots(value)
    {
        this.timeSlotsValue = value;
        const { data, error } = value;
        if (data) {
            this.errors = undefined;
            this.timeSlots = data.map((r)=> { 
                return {
                    'id': r.Id, 
                    'displayName': r.dmpl__DisplayName__c, 
                    'available': this.getAvailableTimeSlots(r), 
                    'percentage': this.getTimeSlotsPercentUtilized(r)
                }});
        } else if (error) {
            this.errors = error;
            this.timeSlots = undefined;
        }
    }
    
    @wire(getFieldsByFieldSetName, { objectApiName: PRODUCTDEMOOBJECT, fieldSetName: '$recordFieldsetName' })
    fieldsetFields;
    
    @wire(MessageContext)
    messageContext;

    get getTransactionType(){
        if(this.isOnsiteSelected){
            return this.siteTransactionType;
        }else {
            return this.transactionType;
        }
    }

    get getFieldsetFields(){
        if(this.fieldsetFields && this.fieldsetFields.data){
            return this.fieldsetFields.data;
        }    
    }
    
    @api
    get defaultFieldValues() {
        return this.privateDefaultFieldValues;
    }
    set defaultFieldValues(value) {
        this.privateDefaultFieldValues = value;
        this.setAttribute('defaultFieldValues', this.privateDefaultFieldValues);
        this.populateDefaultValues();
    }

    get radioButtonElements() {
        return this.template.querySelectorAll('input');
    }
    
    get daysOptions() {
        return [
            { label: '5 Days', value: 5 },
            { label: '10 Days', value: 10 },
            { label: '15 Days', value: 15 }
        ];
    }

    getAvailableDateSlots(r){
        return r.capacity - r.capacityUtilized;
    }
    
    getDateSlotsPercentUtilized(r){
        return (r.capacityUtilized/r.capacity)*100;
    }

    getAvailableTimeSlots(r){
        if(r.dmpl__BranchTimeSlotBookings__r && r.dmpl__BranchTimeSlotBookings__r.length>0){
            return r.dmpl__BranchTimeSlotBookings__r[0].dmpl__Capacity__c - r.dmpl__BranchTimeSlotBookings__r[0].dmpl__CapacityUtilized__c;
        }else {
            return r.dmpl__MaximumCapacity__c;
        }
    }

    getTimeSlotsPercentUtilized(r){
        if(r.dmpl__BranchTimeSlotBookings__r 
            && r.dmpl__BranchTimeSlotBookings__r.length>0 
            && r.dmpl__BranchTimeSlotBookings__r[0].dmpl__Capacity__c>0){
            return (r.dmpl__BranchTimeSlotBookings__r[0].dmpl__CapacityUtilized__c/r.dmpl__BranchTimeSlotBookings__r[0].dmpl__Capacity__c)*100;
        }else {
            return 0;
        }
    }

    get getDateSlotAvailable(){
        return this.dateSlots && this.dateSlots.length>0 && this.branchId;
    }

    get getTimeSlotAvailable(){
        return this.timeSlots && this.timeSlots.length>0 && this.branchId && this.bookingDate;
    }
    
    connectedCallback() {
        this.subscription = subscribe(
            this.messageContext,
            FORCEREFRESHMC,
            (message) => {
                this.handleForceRefresh(message);
            }
        );
    }
    
    disconnectedCallback() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }

    handleForceRefresh(message) {
        refreshApex(this.dateSlotsValue);
        refreshApex(this.timeSlotsValue);
        console.debug(message.recordApiName);
    }

    populateDefaultValues(fireChange){
        if(!this.privateDefaultFieldValues){
            return;
        }
        this.privateDefaultFieldValues.split(',').forEach(p=>
        {
            if(p){
                const nvPair = p.split("|");
                if(nvPair.length ==2){
                    this.setDefaultValue(nvPair[0], nvPair[1], fireChange);
                }    
            }
        }
        );
    }

    setDefaultValue(name, value, fireChange){
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        console.debug(inputFields.length);
        if (inputFields) {
            inputFields.forEach(field => {
                if (field.fieldName == name
                    && field.value != value) {
                    field.value = value;
                    this.setFieldValue(name,value);
                    if(fireChange){
                        this.fireFilterChangeEvent(name, value);
                    }
                    return;
                }
            });
        }
    }

    setFieldValue(name, value){
        if(name == 'dmpl__ItemId__c'){
            this.itemId = value;
        } else if(name == 'dmpl__ServiceType__c'){
            this.serviceType = value;
        } else if(name == 'dmpl__ServiceJobType__c'){
            this.serviceJobType = value;
        } else if(name == 'dmpl__BranchId__c'){
            this.branchId = value;
        } else if(name == 'dmpl__BranchId__c'){
            this.branchId = value;
        } else if(name == 'dmpl__IsDemoOnsite__c'){
            this.isOnsiteSelected = value == "true"?true:value=="false"?false:value;
        } else if(name == 'dmpl__DemoDate__c' || name == 'dmpl__AppointmentDate__c'){
            this.bookingDate = value;
            const rb = Array.from(this.radioButtonElements).find((radioButton) => radioButton.name=='dateSlot' && radioButton.value == value);
            if(rb) rb.checked = true;
        } else if(name == 'dmpl__DemoSlotId__c'|| name == 'dmpl__AppointmentTimeSlotId__c'){
            this.selectedTimeSlotId = value;
            const rb = Array.from(this.radioButtonElements).find((radioButton) => radioButton.name=='timeSlot' && radioButton.value == value);
            if(rb) rb.checked = true;
        } 
    }

    fireDateChangeEvent() {
        const filters = {
            selectedDate: this.bookingDate
        };
        this.dispatchEvent(new CustomEvent('dateslotchanged', { "detail":filters }));
    }

    fireTimeSlotChangeEvent() {
        const filters = {
            recordId: this.selectedTimeSlotId
        };
        this.dispatchEvent(new CustomEvent('timeslotchanged', { "detail":filters }));
    }
    
    fireFilterChangeEvent(name, value) {
        const filters = {
            name: name,
            value: value
        };
        this.dispatchEvent(new CustomEvent('filterchanged', { "detail":filters }));
    }

    handleDaysCountChange(event){
        this.daysCount = parseInt(event.detail.value);
    }
    
    handleIsOnsiteChange(event){
        this.isOnsiteSelected = event.target.checked;
        this.fireFilterChangeEvent('dmpl__IsDemoOnsite__c', this.isOnsiteSelected);
        this.fireFilterChangeEvent('dmpl__IsFieldService__c', this.isOnsiteSelected);
    }

    handleDaySlotChange(event) {
        this.bookingDate = Array.from(this.radioButtonElements)
        .find((radioButton) => radioButton.checked)?.value;
        this.fireDateChangeEvent();
    }
    
    handleTimeSlotChange(event) {
        this.selectedTimeSlotId = Array.from(this.radioButtonElements)
        .find((radioButton) => radioButton.name=='timeSlot' && radioButton.checked)?.value;
        this.fireTimeSlotChangeEvent();
    }

    handleLoad(){
        this.populateDefaultValues(true);
    }

    handleError(event){
        console.log(event.detail);
    }
    
    handleReset() {
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        const fsField = this.getFieldsetFields && this.getFieldsetFields.length >0 ? this.getFieldsetFields[0]:undefined;
        if (inputFields) {
            inputFields.forEach(field => {
                field.reset();
            });
        }
    }

    handleFieldChange(event){
        if((!event.target) || (!event.target.id))
            return;
        const target = event.target.id.slice(0, event.target.id.lastIndexOf('-'));
        var value = '';
        if(event.detail.value){
            if(Array.isArray(event.detail.value) && Array.from(event.detail.value).length>0){
                value = event.detail.value[0];
            }else if(!(typeof event.detail.value === 'object')){
                value = event.detail.value;
            }
        }else if ('checked' in event.detail){
            value = event.detail.checked;
        }
        this.setFieldValue(target,value);
        this.fireFilterChangeEvent(target, value);
    }
}