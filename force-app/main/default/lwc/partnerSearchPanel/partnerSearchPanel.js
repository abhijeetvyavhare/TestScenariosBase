import { LightningElement, api, wire } from 'lwc';
import getNearbyBranches from '@salesforce/apex/BranchController.getNearbyBranches';
import getFieldsByFieldSetName from '@salesforce/apex/MetadataController.getFieldsByFieldSetName';

const DELAY = 500;
const BRANCHOBJECT = 'dmpl__Branch__c';

export default class PartnerSearchPanel extends LightningElement {
    @api title;
    @api noDataMessage;
    @api errors;
    @api showFilterPanel;
    @api recordFieldsetName;
    @api _branchId;
    @api branchId;

    branchName;
    selectedMarker;
    postalCode='';
    cityName='';
    radius=0;
    markers;
    isPanelCollapsed = false;
    partnerAccountId;
    mapOptions = {
        'disableDefaultUI': true,
        'draggable': true
      };
    privateDefaultFieldValues;

    @api
    get defaultFieldValues() {
        return this.privateDefaultFieldValues;
    }
    set defaultFieldValues(value) {
        this.privateDefaultFieldValues = value;
        this.setAttribute('defaultFieldValues', this.privateDefaultFieldValues);
        this.populateDefaultValues();
    }

    @wire(getNearbyBranches, {
        postalCode: '$postalCode', 
        cityName: '$cityName', 
        radius: '$radius' 
    })wiredRecord({ error, data })
    {
        if (data) {
            this.errors = undefined;
            this.markers = data.map(row => {
                return {
                        value: row.Id,
                        location: this.getLocation(row),
                        partnerAccountId: row.dmpl__PartnerAccountId__c,
                        title: `${row.dmpl__MarketingName__c?row.dmpl__MarketingName__c.value:row.Name}`,
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
            if(this.markers.length>0){
                this.selectedMarker = this.markers.find(m=> m.value == this.branchId)?.value;
            }
            this.handleMarkerSelect(null);
        } else if (error) {
            this.errors = error;
            this.markers = undefined;
        }
    }
    
    @wire(getFieldsByFieldSetName, { objectApiName: BRANCHOBJECT, fieldSetName: '$recordFieldsetName' })
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
        return `${this.title} - ${this.branchName}`;
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
        if(name == 'dmpl__BranchId__c'){
            this.setBranchIdField(value);
        }
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        if (inputFields) {
            inputFields.forEach(field => {
                if (field.fieldName == name &&
                    field.value != value) {
                    field.value = value;
                    if(fireChange){
                        this.fireFilterChangeEvent(name, value);
                    }
                    return;
                }
            });
        }
    }

    setBranchIdField(value){
        this.branchId = value;
        this.selectedMarker = this.markers.find(m=> m.value == this.branchId)?.value;
        this.branchName = this.markers.find(m=> m.value == this.branchId)?.title;
        this.partnerAccountId = this.markers.find(m=> m.value == this.branchId)?.partnerAccountId;
        this.fireBranchChangeEvent();
    }

    handleMarkerSelect(event){
        if(this.mapElements.length>0){
            const selectedBranchId = this.mapElements[0].selectedMarkerValue;
            if(selectedBranchId == this.branchId){
                return
            }
            this.setBranchIdField(selectedBranchId);    
        }
    }

    handlePostalCodeChange(event) {
        this.fireFilterChangeEvent('postalCode', event.detail.value);
    }

    handleCityNameChange(event) {
        this.fireFilterChangeEvent('cityName', event.detail.value);
    }

    fireFilterChangeEvent(name, value) {
        window.clearTimeout(this.delayTimeout);
        this.delayTimeout = setTimeout(() => {
            const filters = {
                name: name,
                value: value
            };
            if(name=='postalCode'){
                this.postalCode = value;
            }else if(name=='cityName'){
                this.cityName = value;
            }
            this.dispatchEvent(new CustomEvent('filterchanged', { "detail":filters }));
        }, DELAY);
    }
    
    fireBranchChangeEvent() {
        const filters = {
            recordId: this.branchId,
            name: this.branchName,
            partnerAccountId: this.partnerAccountId
        };
        this.dispatchEvent(new CustomEvent('branchselected', { "detail":filters }));
    }

    handlePanelVisibility(event){
        event.preventDefault();
        event.stopPropagation();
        this.isPanelCollapsed = !this.isPanelCollapsed;
    }
    
    getLocation(branchRow){
        const loc = {};
        if(branchRow.dmpl__GeoLocation__c 
            && branchRow.dmpl__GeoLocation__c.latitude
            && branchRow.dmpl__GeoLocation__c.longitude){
                loc.Latitude=  branchRow.dmpl__GeoLocation__c.latitude;
                loc.Longitude= branchRow.dmpl__GeoLocation__c.longitude;    
        }
        loc.City= branchRow.dmpl__AddressId__r?.dmpl__City__c;
        loc.Country= branchRow.dmpl__AddressId__r?.dmpl__Country__c;
        loc.PostalCode= branchRow.dmpl__AddressId__r?.dmpl__PostalCode__c;
        loc.State= branchRow.dmpl__AddressId__r?.dmpl__State__c;
        loc.Street= branchRow.dmpl__AddressId__r?.dmpl__Street__c;
        return loc;
    }

    getLocationDetails(branchRow){
        const fields = this.getFieldsetFields;
        var branchLocation = '';
        fields?.forEach(l=>{
            if(branchRow[l.apiName]){
                branchLocation += `${[l.label]}: ${branchRow[l.apiName]}<br>` 
            }
        });
        return branchLocation;
    }
}