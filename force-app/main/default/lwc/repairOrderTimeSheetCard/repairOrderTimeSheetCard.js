import { LightningElement, api, wire, track } from 'lwc';
import queryRepairOrderTimeSheets from '@salesforce/apex/RepairOrderTimeSheetHelper.queryRepairOrderTimeSheets';

const relatedStatus = new Array(2)
relatedStatus['Start Work'] = 'Started';
relatedStatus['End Work'] = 'Completed';

export default class RepairOrderTimeSheetCard extends LightningElement {
    @api objectName;
    @api recordId;
    @api strRelatedObjectFields;
    @api strRelatedObject;
    @api strRelatedForeignKey;
    @api technicianWiseTimeSheet;
    @track technicianGroupWiseData = [];
    @api linesCount = 0;
    @api isVisible;
    @api isCommunityPage;
    @api isDataPresent = false;
    @api showNewDialog;

    connectedCallback() {
        this.isVisible = true;
        this.processInfo();
    }

    get getViewAllLink() {
        if (this.isCommunityPage)
            return '/s/repairorder/related/' + this.recordId + '/dmpl__Repair_Order_Time_Sheet__r';
        else
            return '/lightning/r/dmpl__RepairOrderTimeSheet__c/' + this.recordId + '/related/dmpl__Repair_Order_Time_Sheet__r/view';
    }

    processInfo() {
        this.isDataPresent = false;
        queryRepairOrderTimeSheets({ recordId: this.recordId }).then((result) => {
            if (result && result) {
                this.technicianGroupWiseData = [];
                let distinctTechnicians = [];
                result.forEach(element => {
                    if (element.dmpl__TechnicianId__c && !distinctTechnicians.includes(element.dmpl__TechnicianId__c))
                        distinctTechnicians.push(element.dmpl__TechnicianId__c);
                });
                this.linesCount = distinctTechnicians.length;
                distinctTechnicians.forEach((technician) => {
                    let technicianWiseData = { Technician: technician, navigationLink: '/' + technician, Name: '', RelatedRecords: [] };
                    result.forEach((record) => {
                        if (record.dmpl__TechnicianId__c === technician) {
                            technicianWiseData.Name = record.dmpl__TechnicianId__r.Name;
                            let label = record.dmpl__RepairStatus__c ? (record.dmpl__RepairStatus__c === "Started" ? "End Work" : (record.dmpl__RepairStatus__c === "Paused" ? "Start Work" : "")) : "Start Work";
                            let buttonVariant = label === "Start Work" ? "success" : (label === "End Work" ? "destructive" : "");
                            let childRecords = [];
                            let childWorkItems = [];
                            if (record.dmpl__Time_Sheet_Line__r) {
                                record.dmpl__Time_Sheet_Line__r.forEach((childRecord) => {
                                    childRecords.push({ ItemName: childRecord.dmpl__Item__c })
                                    childWorkItems.push(childRecord.dmpl__Item__c);
                                })
                            }
                            technicianWiseData.RelatedRecords.push({ Id: record.Id, record: record, documentNavigationLink: '/' + record.Id, buttonVariant: buttonVariant, disableButton: record.dmpl__RepairStatus__c === "Completed", buttonLabel: label, ChildRecords: childRecords, WorkItems: childWorkItems.join(' \n'), WorkItemsList: childWorkItems });
                        }
                    })
                    this.technicianGroupWiseData.push(technicianWiseData);
                })
                this.linesCount = this.technicianGroupWiseData.length;
                this.isDataPresent = this.technicianGroupWiseData.length > 0;
            }
        }).catch((error) => {
            console.log('Error :', error);
        })
    }

    handleVisibleClick() {
        this.isVisible = !this.isVisible;
    }

    handleEditTimeSheet(event) {
        const inputFields = this.template.querySelector("c-repair-order-time-sheet-modal");
        if (inputFields) {
            inputFields.editTimeSheet(event.target.id.split('-')[0]);
            inputFields.show();
        }
    }

    handleRefresh() {
        this.processInfo();
    }

    handleNewTimeSheet(event) {
        const inputFields = this.template.querySelector("c-repair-order-time-sheet-modal");
        if (inputFields) {
            inputFields.createTimesheet(this.recordId);
            inputFields.show();
        }
    }

}