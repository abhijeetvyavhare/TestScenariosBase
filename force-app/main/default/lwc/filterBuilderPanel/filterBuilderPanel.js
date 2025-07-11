import { LightningElement, api, wire, track  } from 'lwc';
import { getRelatedListRecords } from 'lightning/uiRelatedListApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { refreshApex } from '@salesforce/apex';
import {subscribe, unsubscribe, MessageContext} from 'lightning/messageService';
import FORCEREFRESHMC from '@salesforce/messageChannel/ForceReset__c';
import { notifyRecordUpdateAvailable } from 'lightning/uiRecordApi';
import { getRecord } from 'lightning/uiRecordApi';

export default class FilterBuilderPanel extends LightningElement {
    @api recordId;
    @api objectApiName;

    @api relatedListId;
    @api parentFieldName;
    @api title;
    @api sourceObjectApiName;
    @api dynamicSourceObjectFieldName;
    @api allowDateTimeLitrals;
    
    @track records = [];
    isPanelVisible;
    recordFields = [];

    @wire(MessageContext)
    messageContext;

    @wire(getObjectInfo, { objectApiName: '$objectApiName' })
    wiredObjectInfo(value) {
        const { data, error } = value;
        if (data) {
            this.objectInfo = data;
        } else if (error) {
            this.errors = JSON.parse(JSON.stringify(error));
        }
    }

    @wire(getRelatedListRecords, 
        { 
            parentRecordId: '$recordId',
            relatedListId: '$relatedListId' 
        })
    wiredRelatedListRecord(value) {
        this.relatedListRecords = value;
        const { data, error } = value;
        if (data) {
            let data1 = JSON.parse(JSON.stringify(data));
            this.errors = undefined;
            this.records =  data1.records;
        } else if (error) {
            this.errors = JSON.parse(JSON.stringify(error));
            this.records = undefined;
        }
    }

    @wire(getRecord, { recordId: '$recordId', fields: '$recordFields' })
    wiredRecord({ error, data }) {
        if(!data){
            return;
        }
        if (data.fields.dmpl__DynamicMemberObject__c?.value) {
            this.sourceObjectApiName = data.fields.dmpl__DynamicMemberObject__c?.value;
        } else if (this.dynamicSourceObjectFieldName && data.fields[this.dynamicSourceObjectFieldName]){
            this.sourceObjectApiName = data.fields[this.dynamicSourceObjectFieldName]?.value;
        }
    }

    get childObjectApiName() {
        return this.objectInfo?.childRelationships?.find(rls => rls.relationshipName == this.relatedListId)?.childObjectApiName;
    }

    get getIsPanelCollapsed() {
        return !this.isPanelVisible;
    }    

    get getRelatedListRecords() {
        return this.records;
    }

    connectedCallback() {
        this.subscription = subscribe(
            this.messageContext,
            FORCEREFRESHMC,
            (message) => {
                this.handleForceRefresh(message);
            }
        );
        this.recordFields = [];
        if (this.dynamicSourceObjectFieldName){
            this.recordFields.push(this.objectApiName.concat('.', this.dynamicSourceObjectFieldName));
        }else {
            this.recordFields.push(this.objectApiName.concat('.', 'dmpl__DynamicMemberObject__c'));;
        }
    }

    disconnectedCallback() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }

    handleForceRefresh(message) {
        if(message && message.cancel){
            this.records = this.records.filter(v=>(!v.uid) || v.uid!= message.uid).slice();
        }else if(message && message.delete){
            this.records = this.records.filter(v=> v.id!= message.uid).slice();
        }
        notifyRecordUpdateAvailable([{ "recordId": this.recordId }]);
        refreshApex(this.relatedListRecords);
    }

    handleAddCondition(e){
        this.records.push(this.createRecord());
    }

    createRecord(){
        return {
            'Id' : undefined,
            'Name' : undefined,
            'parentId' : this.recordId,
            'uid' : new Date().valueOf(),
            'sequenceNumber' : this.records.length + 1
        };
    }

    handlePanelVisibility(event) {
        event.preventDefault();
        event.stopPropagation();
        this.isPanelVisible = !this.isPanelVisible;
    }
}