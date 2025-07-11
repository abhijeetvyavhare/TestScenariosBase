import { LightningElement, api, wire, track } from 'lwc';
import queryRepairOrderTimeSheets from '@salesforce/apex/RepairOrderTimeSheetHelper.queryRepairOrderTimeSheets';
import queryPendingRepairOrderLines from '@salesforce/apex/RepairOrderTimeSheetHelper.queryPendingRepairOrderLines';
import createTimeSheet from '@salesforce/apex/RepairOrderTimeSheetHelper.createTimeSheet';
import { RefreshEvent } from 'lightning/refresh';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const columns = [
    { label: 'Repair Order Line', fieldName: 'Name' },
    { label: 'Item Name', fieldName: 'dmpl__Item__c' }
];

export default class RepairOrderTimeSheetModal extends LightningElement {
    @api title;
    @api recordId;
    @api currentTimeSheetId;
    @track workOrderLines = [];
    @track selectRecordIds = '';
    @track timeSheetName;
    @track allowRowSelection = false;

    status;
    showModal = false;
    columns = columns;
    showPauseFields = false;
    showPauseState = false;
    showEndState = false;
    showPauseAndEndState = false;
    technicianId;
    workStarted;
    workPaused;
    workEnded;
    workPausedAt;
    workCompletedBy;

    get hasWorkOrderLines(){
        return this.currentTimeSheetId || this.workOrderLines && this.workOrderLines.length > 0;
    }

    connectedCallback() {
    }

    @api show() {
        this.showModal = true;
    }

    @api createTimesheet(repairOrderId) {
        this.timeSheetName = 'New Repair Order Time Sheet';
        this.currentTimeSheetId = null;
        this.showPauseAndEndState = false;
        this.showPauseState = false;
        this.showEndState = false;
        this.workStarted = false;
        this.workPaused = false;
        this.workEnded = false;
        this.recordId = repairOrderId;
        this.workOrderLines = [];
        this.allowRowSelection = true;
        queryPendingRepairOrderLines({ recordId: repairOrderId }).then((result) => {
            this.workOrderLines = [...result];
        }).catch((error) => {
            console.log('error ', error);
        })
    }

    @api editTimeSheet(timesheetId) {
        this.currentTimeSheetId = timesheetId;
        this.showPauseAndEndState = false;
        this.showPauseState = false;
        this.showEndState = false;
        this.workOrderLines = [];
        this.allowRowSelection = false;
        queryRepairOrderTimeSheets({ recordId: timesheetId }).then((result) => {
            if (result[0]['dmpl__Time_Sheet_Line__r'] && result[0]['dmpl__Time_Sheet_Line__r'].length > 0)
                this.workOrderLines = [...result[0]['dmpl__Time_Sheet_Line__r']];
            this.timeSheetName = result[0]['Name'];
            this.workStarted = result[0]['dmpl__WorkStarted__c'];
            this.workPaused = result[0]['dmpl__WorkPaused__c'];
            this.workEnded = result[0]['dmpl__WorkEnded__c'];
            this.technicianId = result[0]['dmpl__TechnicianId__c'];
            if (this.workEnded)
                this.showEndState = true;
            else if (this.workPaused)
                this.showPauseState = true;
            else
                this.showPauseAndEndState = true;
        }).catch((error) => {
            console.log('error : ', error);
        })
    }

    @api hide() {
        this.showModal = false;
    }

    handleSuccess(event) {
        if (this.allowRowSelection && this.selectRecordIds != '') {
            let newRecordId = event.detail.id;
            createTimeSheet({ repairOrderLineIds: this.selectRecordIds, newRepairOrderTimeSheetId: newRecordId }).then((createTimeSheetResult) => {
                this.dispatchEvent(new CustomEvent('refresh'));
                this.selectRecordIds = '';
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: "Success!",
                        message: "Created Time Sheet.",
                        variant: "success"
                    })
                );
            }).catch((createTimeSheetError) => {
                this.dispatchEvent(new CustomEvent('refresh'));
                console.log('error ', createTimeSheetError);
            })
        }
        else {
            // this.dispatchEvent(new CustomEvent('refresh'));
            this.dispatchEvent(
                new ShowToastEvent({
                    title: "Success!",
                    message: "Updated Time Sheet.",
                    variant: "success"
                })
            );
        }
        this.refreshStdComponents();
        this.cancel();
    }

    handleError(error) {
        console.log('error ', JSON.parse(JSON.stringify(error)));
    }

    refreshStdComponents(){
        try{
            eval("$A.get('e.force:refreshView').fire();");
        }catch(e){
            this.dispatchEvent(new RefreshEvent());
        }
    }

    updateSelectedRecords() {
        this.selectRecordIds = '';
        let timeSheetLines = this.template.querySelector('lightning-datatable').getSelectedRows();
        timeSheetLines.forEach((record) => {
            if (this.selectRecordIds == '')
                this.selectRecordIds = record.Id;
            else
                this.selectRecordIds = this.selectRecordIds + ',' + record.Id;
        });
    }

    get canBeSaved() {
        return !((this.allowRowSelection && this.selectRecordIds != '') || !this.allowRowSelection);
    }

    cancel() {
        this.currentTimeSheetId = null;
        this.hide();
    }

    handleCheckBox(event) {
        let fieldName = event.target.id.split('-')[0];
        let actualValue = event.target.checked;
        if (fieldName === 'dmpl__WorkStarted__c') {
            if (actualValue) {
                this.status = 'Started';
                this.setFieldValue('dmpl__WorkStarted__c', true);
                this.setFieldValue('dmpl__WorkStartDate__c', new Date().toISOString());
            }
        }
        else if (fieldName === 'dmpl__WorkEnded__c') {
            if (actualValue) {
                this.status = 'Completed';
                this.setFieldValue('dmpl__WorkPaused__c', false);
                this.setFieldValue('dmpl__WorkEndDate__c', new Date().toISOString());
            }
        }
        else if (fieldName === 'dmpl__WorkPaused__c') {
            if (actualValue) {
                this.status = 'Paused';
                this.setFieldValue('dmpl__WorkEnded__c', false);
                this.setFieldValue('dmpl__WorkPauseDate__c', new Date().toISOString());
                this.setFieldValue('dmpl__WorkEndDate__c', new Date().toISOString());
            }
        }
    }

    setFieldValue(fieldName, fieldValue) {
        const inputFields = this.template.querySelectorAll("lightning-input-field");
        if (inputFields) {
            inputFields.forEach((field) => {
                if (field.fieldName == fieldName) {
                    field.value = fieldValue;
                }
            });
        }
    }

    getFieldValue(fieldName) {
        const inputFields = this.template.querySelectorAll("lightning-input-field");
        if (inputFields) {
            inputFields.forEach((field) => {
                if (field.fieldName == fieldName) {
                    return field.value;
                }
            });
        }
        return null;
    }
}