import { LightningElement, api, wire } from 'lwc';
import getVisitPlan from '@salesforce/apex/VisitPlanController.getVisitPlan';
import getFieldsByFieldSetName from '@salesforce/apex/MetadataController.getFieldsByFieldSetName';
import { refreshApex } from '@salesforce/apex';
import {subscribe, unsubscribe, MessageContext} from 'lightning/messageService';
import FORCEREFRESHMC from '@salesforce/messageChannel/ForceReset__c';

const VISITOBJECT = 'dmpl__Visit__c';

export default class VisitPlanMapPanel extends LightningElement {
    @api recordId;
    @api title;
    @api noDataMessage;
    @api errors;
    @api recordFieldsetName;
    @api showTimelinePanel;
    @api showHeader;

    visitName;
    visitId;
    partnerAccountId;
    accountId;
    markers;
    selectedMarker;
    mapOptions = {
        'disableDefaultUI': true,
        'draggable': false
      };


    @wire(MessageContext)
    messageContext;

    @wire(getVisitPlan, {
        recordId: '$recordId'
    })wiredRecord(wiredRecordValue)
    {
        this.wiredRecordValue = wiredRecordValue;
        const { data, error } = wiredRecordValue;
        if (data && data.length>0) {
            this.errors = undefined;
            const visitPlan = data[0];
            this.markers = visitPlan?.dmpl__Visits__r?.map(row => {
                return {
                        value: row.Id,
                        location: this.getLocation(row),
                        partnerAccountId: visitPlan.dmpl__PartnerAccountId__c,
                        accountId: row.dmpl__AccountId__c,
                        title: `${row.dmpl__AccountId__r?row.dmpl__AccountId__r?.Name:row.Name}`,
                        description: this.getLocationDetails(row),
                        mapIcon: {
                            path: "M10.453 14.016l6.563-6.609-1.406-1.406-5.156 5.203-2.063-2.109-1.406 1.406zM12 2.016q2.906 0 4.945 2.039t2.039 4.945q0 1.453-0.727 3.328t-1.758 3.516-2.039 3.070-1.711 2.273l-0.75 0.797q-0.281-0.328-0.75-0.867t-1.688-2.156-2.133-3.141-1.664-3.445-0.75-3.375q0-2.906 2.039-4.945t4.945-2.039z",
                            fillColor: "purple",
                            fillOpacity: 0.6,
                            strokeWeight: 0,
                            rotation: 0,
                            scale: 2,
                        }
                }
            });

            if(this.markers?.length>0){
                this.selectedMarker = this.markers.find(m=> m.value == this.visitId)?.value;
            }
            this.handleMarkerSelect(null);
        } else if (error) {
            this.errors = error;
            this.markers = undefined;
        }
    }
    
    @wire(getFieldsByFieldSetName, { objectApiName: VISITOBJECT, fieldSetName: '$recordFieldsetName' })
    fieldsetFields;
    
    get getFieldsetFields(){
        if(this.fieldsetFields && this.fieldsetFields.data){
            return this.fieldsetFields.data;
        }    
    }

    get mapElements() {
        return this.template.querySelectorAll('lightning-map');
    }
    
    get getSelectedTitle(){
        return `${this.title} - ${this.visitName}`;
    }
    
    connectedCallback(){
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
        refreshApex(this.wiredRecordValue);
    }

    getLocation(visitRow){
        const loc = {};
        if(visitRow.dmpl__AssignedLocation__c 
            && visitRow.dmpl__AssignedLocation__c.latitude
            && visitRow.dmpl__AssignedLocation__c.longitude){
                loc.Latitude=  visitRow.dmpl__AssignedLocation__c.latitude;
                loc.Longitude= visitRow.dmpl__AssignedLocation__c.longitude;    
        }
        loc.City= visitRow.dmpl__AddressId__r?.dmpl__City__c;
        loc.Country= visitRow.dmpl__AddressId__r?.dmpl__Country__c;
        loc.PostalCode= visitRow.dmpl__AddressId__r?.dmpl__PostalCode__c;
        loc.State= visitRow.dmpl__AddressId__r?.dmpl__State__c;
        loc.Street= visitRow.dmpl__AddressId__r?.dmpl__Street__c;
        return loc;
    }

    getAssignedLocation(visitRow){
        const loc = {};
        if(visitRow.dmpl__AssignedLocation__c 
            && visitRow.dmpl__AssignedLocation__c.latitude
            && visitRow.dmpl__AssignedLocation__c.longitude){
                loc.Latitude=  visitRow.dmpl__AssignedLocation__c.latitude;
                loc.Longitude= visitRow.dmpl__AssignedLocation__c.longitude;    
        }
        loc.City= visitRow.dmpl__AddressId__r?.dmpl__City__c;
        loc.Country= visitRow.dmpl__AddressId__r?.dmpl__Country__c;
        loc.PostalCode= visitRow.dmpl__AddressId__r?.dmpl__PostalCode__c;
        loc.State= visitRow.dmpl__AddressId__r?.dmpl__State__c;
        loc.Street= visitRow.dmpl__AddressId__r?.dmpl__Street__c;
        return loc;
    }

    getLocationDetails(visitRow){
        const fields = this.getFieldsetFields;
        var visitLocation = '';
        fields?.forEach(l=>{
            if(visitRow[l.apiName]){
                visitLocation += `${[l.label]}: ${visitRow[l.apiName]}<br>` 
            }
        });
        return visitLocation;
    }

    setVisitIdField(value){
        this.visitId = value;
        this.selectedMarker = this.markers.find(m=> m.value == this.visitId)?.value;
        this.visitName = this.markers.find(m=> m.value == this.visitId)?.title;
        this.partnerAccountId = this.markers.find(m=> m.value == this.visitId)?.partnerAccountId;
        this.accountId = this.markers.find(m=> m.value == this.visitId)?.accountId;
    }

    handleMarkerSelect(event){
        if(this.mapElements.length>0){
            const selectedVisitId = this.mapElements[0].selectedMarkerValue;
            if(selectedVisitId == this.visitId){
                return
            }
            this.setVisitIdField(selectedVisitId);    
        }
    }
}