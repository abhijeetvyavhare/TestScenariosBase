import { LightningElement, api, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import {subscribe, unsubscribe, MessageContext} from 'lightning/messageService';
import FORM_FACTOR from '@salesforce/client/formFactor';
import getVisitPlan from '@salesforce/apex/VisitPlanController.getVisitPlan';
import getFieldsByFieldSetName from '@salesforce/apex/MetadataController.getFieldsByFieldSetName';
import FORCEREFRESHMC from '@salesforce/messageChannel/ForceReset__c';

const VISITOBJECT = 'dmpl__Visit__c';

export default class VisitPlanTimelinePanel extends NavigationMixin(LightningElement) {
    @api recordId;
    @api title;
    @api noDataMessage;
    @api errors;
    @api recordFieldsetName;
    @api remarksFieldName;
    @api actionName;
    @api defaultIsCollapsed;

    defultRecordTypeId;
    acceptanceStatusList;
    isPlanAccepted = true;

    @track visits;
    
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
            console.log('visitPlan?.dmpl__Visits__r ', JSON.parse(JSON.stringify( visitPlan?.dmpl__Visits__r)));
            this.visits = visitPlan?.dmpl__Visits__r.map(row => {
                return {
                        value: row.Id,
                        navigationLink: '/'+row.Id,
                        title: `${row.dmpl__AccountId__r?row.dmpl__AccountId__r?.Name:row.Name}`,
                        plannedStartTime : this.convertToTime(row.dmpl__PlannedStartTime__c?row.dmpl__PlannedStartTime__c:0),
                        startTime : this.convertToTime(row.dmpl__StartTime__c?row.dmpl__StartTime__c:0),
                        endTime : this.convertToTime(row.dmpl__EndTime__c?row.dmpl__EndTime__c:0),
                        visitDuration : row.dmpl__VisitDuration__c?row.dmpl__VisitDuration__c:0,
                        plannedDuration : row.dmpl__PlannedDuration__c?row.dmpl__PlannedDuration__c:0,
                        visitStatus : row.dmpl__VisitStatus__c,
                        visitDate : row.dmpl__DocumentDate__c,
                        status : row.dmpl__Status__c,
                        isCompleted : row.dmpl__Status__c == 'Completed',
                        sequenceNumber : row.dmpl__SequenceNumber__c,
                        isCollapsed: this.defaultIsCollapsed
                }
            });
            this.visitPlan = visitPlan;
            this.isPlanAccepted = this.visitPlan && this.visitPlan.dmpl__AcceptanceStatus__c;
        } else if (error) {
            this.errors = error;
            this.visits = undefined;
        }
    }
    
    @wire(getFieldsByFieldSetName, { objectApiName: VISITOBJECT, fieldSetName: '$recordFieldsetName' })
    fieldsetFields;
    
    @wire(getObjectInfo, { objectApiName: 'dmpl__VisitPlan__c' })
    visitPlanObjectInfo({ error, data }){
        if(data){
            this.defultRecordTypeId =  data.defaultRecordTypeId;
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$defultRecordTypeId', fieldApiName: 'dmpl__VisitPlan__c.dmpl__AcceptanceStatus__c' })
    wiredValues({ error, data }) {
        if (data) {
            this.acceptanceStatusList = data.values;
        }
    }
    
    get getFieldsetFields(){
        if(this.fieldsetFields && this.fieldsetFields.data){
            return this.fieldsetFields.data;
        }    
    }
    
    get isMobileView(){
        return FORM_FACTOR == 'Small';
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

    convertToTime(milliseconds){
        let ms = Number(milliseconds) % 1000;
        milliseconds = (milliseconds - ms) / 1000;
        let secs = milliseconds % 60;
        milliseconds = (milliseconds - secs) / 60;
        let mins = milliseconds % 60;
        let hrs = (milliseconds - mins) / 60;
        hrs = hrs < 10 ? '0' + hrs : hrs;
        mins = mins < 10 ? '0' + mins : mins;
        console.log(hrs + '  ' + mins);
        return (hrs > 12 ? (hrs - 12) : hrs )+':' + mins + ' ' + (hrs > 12 ? 'PM' : 'AM');
    }

    handleAcceptanceClick(event){
        let value = event.target?.name;
        this.updateFieldValue('dmpl__AcceptanceStatus__c', value);
    }

    handleVisibility(event){
        let currentMarker = this.visits.find(x=>x.value === event.target.dataset.recordid);
        if(currentMarker)
            currentMarker.isCollapsed = !currentMarker.isCollapsed
    }

    handleActionClick(event){
        event.preventDefault();
        let recordId = event.target.value;
        if(!recordId){
            recordId = event.currentTarget.dataset.id;
        }
        let viewPageRef = {
            type: 'standard__recordPage',
            attributes: {
                objectApiName: 'dmpl__Visit__c',
                recordId : recordId,
                actionName: 'view'
            }
        };
        this[NavigationMixin.Navigate](viewPageRef);
    }

    updateFieldValue(fieldName, fieldValue){
        const fields = {};
        fields['Id'] = this.recordId;
        fields[fieldName] = fieldValue;
        const recordInput = { fields };
        updateRecord(recordInput)
        .then(() => {
            refreshApex(this.wiredRecordValue);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Data updated',
                    variant: 'success'
                })
            );
        })
        .catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error updating record',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        });
    }
}