import { LightningElement, api, wire, track } from 'lwc';
import getHealthCheckTemplates from '@salesforce/apex/HealthCheckController.getHealthCheckTemplates';
import getChecklistLines from '@salesforce/apex/HealthCheckController.getChecklistLines';
import { notifyRecordUpdateAvailable } from 'lightning/uiRecordApi';
import { getRecord } from "lightning/uiRecordApi";
import { RefreshEvent } from 'lightning/refresh';
import { createRecord, updateRecord } from "lightning/uiRecordApi";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

export default class HealthCheckPanel extends NavigationMixin(LightningElement)
{
    @api title;
    @api recordId;

    @api currentItemId;
    @api partnerAccountId;
    @api branchId;
    @track isMasterDataLoaded = false;
    @track isTransactedDataLoaded = false;
    @track healthCheckTemplate = [];
    @track defaultFieldsArray = ['dmpl__ServiceRequest__c.Id', 'dmpl__ServiceRequest__c.dmpl__PartnerAccountId__c', 'dmpl__ServiceRequest__c.dmpl__BranchId__c', 'dmpl__ServiceRequest__c.dmpl__AssetId__c', 'dmpl__ServiceRequest__c.dmpl__AssetId__r.dmpl__ItemId__c'];

    @wire(getRecord, {
        recordId: "$recordId",
        fields: "$defaultFieldsArray"
    })
    handle({ data, error }) {
        if (data) {
            this.healthCheckTemplate = [];
            if (data && data.fields && data.fields.dmpl__AssetId__c && data.fields.dmpl__AssetId__r.value && data.fields.dmpl__AssetId__r.value.fields.dmpl__ItemId__c.value) {
                this.currentItemId = data.fields.dmpl__AssetId__r.value.fields.dmpl__ItemId__c.value;
                this.partnerAccountId = data.fields.dmpl__PartnerAccountId__c.value;
                this.branchId = data.fields.dmpl__BranchId__c.value;
                getHealthCheckTemplates({ itemId: this.currentItemId }).then((healthCheckTemplateResult) => {
                    if (healthCheckTemplateResult) {
                        let groupBy = [];
                        healthCheckTemplateResult.forEach((healthCheckResult) => {
                            healthCheckResult.dmpl__CheckList_Template_Lines__r.forEach((checklistTemplateLine) => {
                                if (!groupBy.includes(checklistTemplateLine.dmpl__GroupBy__c))
                                    groupBy.push(checklistTemplateLine.dmpl__GroupBy__c);
                            })
                        })
                        groupBy.forEach((groupByName) => {
                            healthCheckTemplateResult.forEach((healthCheckResult) => {
                                let records = [];
                                healthCheckResult.dmpl__CheckList_Template_Lines__r.forEach((checklistTemplateLine) => {
                                    if (checklistTemplateLine.dmpl__GroupBy__c === groupByName) {
                                        let newRecord = JSON.parse(JSON.stringify(checklistTemplateLine));
                                        newRecord['existingRecordId'] = '';
                                        newRecord['disableBoolean'] = checklistTemplateLine.dmpl__DataType__c != 'Boolean';
                                        newRecord['disableNumeric'] = checklistTemplateLine.dmpl__DataType__c != 'Numeric';
                                        newRecord['disableText'] = checklistTemplateLine.dmpl__DataType__c != 'Text';
                                        newRecord['disableRAG'] = checklistTemplateLine.dmpl__DataType__c != 'RAG';
                                        newRecord['IsRed'] = false;
                                        newRecord['IsAmber'] = false;
                                        newRecord['IsGreen'] = false;
                                        newRecord['RAGValue'] = '';
                                        newRecord['NumericValue'] = '';
                                        newRecord['TextValue'] = '';
                                        // newRecord['Remarks'] = '';
                                        if (checklistTemplateLine.dmpl__DataType__c == 'Numeric' || checklistTemplateLine.dmpl__DataType__c == 'Text' || checklistTemplateLine.dmpl__DataType__c == 'RAG')
                                            records.push(newRecord);
                                    }
                                })
                                this.healthCheckTemplate.push({ GroupBy: groupByName, Records: records });
                            })
                        })
                        this.isMasterDataLoaded = true;
                        this.getTransactedData();
                    }
                }).catch((error) => {
                    console.log(' error ', error);
                })
            }
        }
        if (error) {
            console.log('Record error ', error);
        }
    }

    getTransactedData() {
        getChecklistLines({ parentRecordId: this.recordId }).then((checklistLines) => {
            checklistLines.forEach((transactedRecord) => {
                this.healthCheckTemplate.forEach((healthCheck) => {
                    healthCheck.Records.forEach((internalRecord) => {
                        if (internalRecord.dmpl__ChecklistTemplateId__c == transactedRecord.dmpl__ChecklistTemplateId__c && internalRecord.Id == transactedRecord.dmpl__CheckListTemplateLineId__c) {
                            internalRecord.existingRecordId = transactedRecord.Id;
                            internalRecord.IsRed = transactedRecord.dmpl__RAGValue__c == 'Red';
                            internalRecord.IsAmber = transactedRecord.dmpl__RAGValue__c == 'Amber';
                            internalRecord.IsGreen = transactedRecord.dmpl__RAGValue__c == 'Green';
                            internalRecord.RAGValue = transactedRecord.dmpl__RAGValue__c;
                            internalRecord.NumericValue = transactedRecord.dmpl__NumericValue__c;
                            internalRecord.TextValue = transactedRecord.dmpl__TextValue__c ? transactedRecord.dmpl__TextValue__c : '';
                            internalRecord.Remarks = transactedRecord.dmpl__Remarks__c ? transactedRecord.dmpl__Remarks__c : '';
                        }
                    })
                })
            })
            this.isTransactedDataLoaded = true;
        }).catch((error) => {
            console.log('error ', error);
        });
    }

    handleRedClick(event) {
        this.healthCheckTemplate.forEach((healthCheck) => {
            healthCheck.Records.forEach((internalRecord) => {
                if (internalRecord.Id === event.target.value) {
                    internalRecord.IsRed = true;
                    internalRecord.IsAmber = false;
                    internalRecord.IsGreen = false;
                    internalRecord.RAGValue = 'Red';
                }
            })
        })
    }

    handleAmberClick(event) {
        this.healthCheckTemplate.forEach((healthCheck) => {
            healthCheck.Records.forEach((internalRecord) => {
                if (internalRecord.Id === event.target.value) {
                    internalRecord.IsRed = false;
                    internalRecord.IsAmber = true;
                    internalRecord.IsGreen = false;
                    internalRecord.RAGValue = 'Amber';
                }
            })
        })
    }

    handleGreenClick(event) {
        this.healthCheckTemplate.forEach((healthCheck) => {
            healthCheck.Records.forEach((internalRecord) => {
                if (internalRecord.Id === event.target.value) {
                    internalRecord.IsRed = false;
                    internalRecord.IsAmber = false;
                    internalRecord.IsGreen = true;
                    internalRecord.RAGValue = 'Green';
                }
            })
        })
    }

    handleNumericValue(event) {
        let Id = event.target.id.split('-')[0];
        this.healthCheckTemplate.forEach((healthCheck) => {
            healthCheck.Records.forEach((internalRecord) => {
                if (internalRecord.Id === Id) {
                    internalRecord['NumericValue'] = event.target.value;
                }
            })
        })
    }

    handleTextValue(event) {
        let Id = event.target.id.split('-')[0];
        this.healthCheckTemplate.forEach((healthCheck) => {
            healthCheck.Records.forEach((internalRecord) => {
                if (internalRecord.Id === Id) {
                    internalRecord['TextValue'] = event.target.value;
                }
            })
        })
    }

    handleSave() {
        let itemsToInsert = [];
        let itemsToUpdate = [];

        this.healthCheckTemplate.forEach((healthCheck) => {
            healthCheck.Records.forEach((internalRecord) => {
                if (internalRecord['existingRecordId'] == '' && ((internalRecord.dmpl__DataType__c == 'RAG' && internalRecord.RAGValue != '') || (internalRecord.dmpl__DataType__c == 'Numeric' && internalRecord.NumericValue != '') || (internalRecord.dmpl__DataType__c == 'Text' && internalRecord.TextValue != ''))) {
                    itemsToInsert.push(internalRecord);
                } else if (internalRecord['existingRecordId'] != '' && ((internalRecord.dmpl__DataType__c == 'RAG' && internalRecord.RAGValue != '') || (internalRecord.dmpl__DataType__c == 'Numeric' && internalRecord.NumericValue != '') || (internalRecord.dmpl__DataType__c == 'Text' && internalRecord.TextValue != ''))) {
                    itemsToUpdate.push(internalRecord);
                }
            })
        });

        itemsToInsert.forEach((itemToInsert) => {
            let fields = {}
            fields["dmpl__ServiceRequestId__c"] = this.recordId;
            fields["Name"] = itemToInsert.Name;
            fields["dmpl__PartnerAccountId__c"] = this.partnerAccountId;
            fields["dmpl__BranchId__c"] = this.branchId;
            fields["dmpl__ChecklistTemplateId__c"] = itemToInsert.dmpl__ChecklistTemplateId__c;
            fields["dmpl__CheckListTemplateLineId__c"] = itemToInsert.Id;
            fields["dmpl__DataType__c"] = itemToInsert.dmpl__DataType__c;
            fields["dmpl__NumericValue__c"] = itemToInsert.NumericValue;
            fields["dmpl__RAGValue__c"] = itemToInsert.RAGValue;
            fields["dmpl__Remarks__c"] = itemToInsert.Remarks ? itemToInsert.Remarks : '';
            fields["dmpl__TextValue__c"] = itemToInsert.TextValue ? itemToInsert.TextValue : '';

            const recordInput = { apiName: 'dmpl__CheckListLines__c', fields };
            createRecord(recordInput)
                .then((result) => {
                    itemToInsert.existingRecordId = result.id;
                    this.getTransactedData();
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Health Check Inserted Successfully.',
                            variant: 'success'
                        })
                    );
                    this.refreshStdComponents();
                })
                .catch(error => {
                    console.log('Error :', error);
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Something went wrong',
                            message: error.body.message,
                            variant: 'error'
                        })
                    );
                });
        })

        itemsToUpdate.forEach((itemToUpdate) => {
            let fields = {}
            fields['Id'] = itemToUpdate.existingRecordId;
            fields["dmpl__ServiceRequestId__c"] = this.recordId;
            fields["Name"] = itemToUpdate.Name;
            fields["dmpl__PartnerAccountId__c"] = this.partnerAccountId;
            fields["dmpl__BranchId__c"] = this.branchId;
            fields["dmpl__ChecklistTemplateId__c"] = itemToUpdate.dmpl__ChecklistTemplateId__c;
            fields["dmpl__CheckListTemplateLineId__c"] = itemToUpdate.Id;
            fields["dmpl__DataType__c"] = itemToUpdate.dmpl__DataType__c;
            fields["dmpl__NumericValue__c"] = itemToUpdate.NumericValue;
            fields["dmpl__RAGValue__c"] = itemToUpdate.RAGValue;
            fields["dmpl__Remarks__c"] = itemToUpdate.Remarks ? itemToUpdate.Remarks : '';
            fields["dmpl__TextValue__c"] = itemToUpdate.TextValue ? itemToUpdate.TextValue : '';
            const recordInput = { fields };
            updateRecord(recordInput)
                .then((result) => {
                    this.getTransactedData();
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Health Check Updated Successfully.',
                            variant: 'success'
                        })
                    );
                    this.refreshStdComponents();
                }).catch((error) => {
                    console.log('Update Error ', error);
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Something went wrong',
                            message: error.body.message,
                            variant: 'error'
                        })
                    );
                })
        })
    }

    refreshStdComponents(){
        try{
            eval("$A.get('e.force:refreshView').fire();");
        }catch(e){
            this.dispatchEvent(new RefreshEvent());
        }
    }

    handleCancel() {
        this.isTransactedDataLoaded = false;
        this.getTransactedData();
    }

    get renderHealthCheckTemplates() {
        return this.isMasterDataLoaded && this.isTransactedDataLoaded;// this.healthCheckTemplate.length > 0;
    }
}