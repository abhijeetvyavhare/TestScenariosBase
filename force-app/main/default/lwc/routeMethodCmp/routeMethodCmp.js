import { LightningElement, api, wire, track } from 'lwc';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import ROUTEMETHOD_FIELD from '@salesforce/schema/VisitPlan__c.RouteMethod__c';
import getFieldsByFieldSetName from '@salesforce/apex/MetadataController.getFieldsByFieldSetName';
import { CloseActionScreenEvent } from 'lightning/actions';
import { getRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class RouteMethodCmp extends LightningElement {
    @api title;
    @api recordId;
    @api objectApiName;

    @track value = '';
    @track options = [];

    pincode_Fieldset = 'dmpl__ConfigureRoute_Pincode_Fieldset';
    accountGroup_Fieldset = 'dmpl__ConfigureRoute_AccountGroup_Fieldset';
    pendingDeliveries_Fieldset = 'dmpl__ConfigureRoute_PendingDeliveries_Fieldse';
    @track visitPlanFields = ['dmpl__VisitPlan__c.dmpl__RouteMethod__c'];

    currentFieldsetDetails;

    mapMarkers = [
        {
            location: {
                Street: '1 Market St',
                City: 'San Francisco',
                Country: 'USA',
            },
            title: 'The Landmark Building',
            description:
                'Historic <b>11-story</b> building completed in <i>1916</i>',
        },
    ];

    @wire(getRecord, {recordId : '$recordId', fields: '$visitPlanFields'})
    handleRecord({error, data}){
        if(data){
            this.value = data?.fields?.dmpl__RouteMethod__c?.value;
        }
        else {
            console.log('getRecordError', error);
        }
    }

    @wire(getPicklistValues, { recordTypeId: '012000000000000AAA', fieldApiName: ROUTEMETHOD_FIELD })
    handleRouteMethodValues({ error, data }) {
        if (data) {
            this.options = data.values.map(x => { return { label: x.label, value: x.value } });
            if (this.options.length > 0 && !this.value)
                this.value = this.options[0].value;
        }
        if (error) {
            console.log('getPicklistValuesError', error);
        }
    }

    @wire(getFieldsByFieldSetName, { objectApiName: '$objectApiName', fieldSetName: '$pincode_Fieldset' })
    pincodeFields;

    @wire(getFieldsByFieldSetName, { objectApiName: '$objectApiName', fieldSetName: '$accountGroup_Fieldset' })
    accountGroupFields;

    @wire(getFieldsByFieldSetName, { objectApiName: '$objectApiName', fieldSetName: '$pendingDeliveries_Fieldset' })
    pendingDeliveriesFields;

    get showMapSection() {
        return this.value === 'By Map Selection';
    }

    get showRecordEditForm(){
        return this.value === 'By Pincode' || this.value === 'By Account Group' || this.value === 'By Pending Deliveries';
    }

    get getFieldDetails(){
        if(this.value === 'By Pincode')
            return this.pincodeFields;
        else if(this.value === 'By Account Group')
            return this.accountGroupFields;
        else if(this.value === 'By Pending Deliveries')
            return this.pendingDeliveriesFields;
        else 
            return null;
    }

    get currentRouteMethod(){
        
    }

    connectedCallback() {
        
    }

    handleRouteMethodChange(event) {
        this.value = event.detail.value;
    }

    handleSubmit(event){
        if(this.showRecordEditForm)
            this.handleRecordFormSubmit(event);
    }

    handleRecordFormSubmit(event){
        this.template.querySelector('lightning-record-edit-form').submit();
    }

    closeQuickAction() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    handleSuccess(event){
        this.showToast('success', 'Successful', 'Record has been saved.');
    }

    handleError(event){
        console.log('error ', event);
        this.showToast('error', 'Error', 'Something went wrong while submitting the record!');
    }

    showToast(type, title, message){
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: type
            })
        );

        if(type === 'success')
            this.closeQuickAction();
    }
}