import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getFieldsByFieldSetName from '@salesforce/apex/MetadataController.getFieldsByFieldSetName';
import getUserDefaults from '@salesforce/apex/RecordFormController.getUserDefaults';
import getRelatedRecords from '@salesforce/apex/BulkOrderProcessingController.getRelatedRecords';
import getRelatedRecordsCount from '@salesforce/apex/BulkOrderProcessingController.getRelatedRecordsCount';
import createBulkInvoices from '@salesforce/apex/BulkOrderProcessingController.createBulkInvoices';
import createBulkFulfilments from '@salesforce/apex/BulkOrderProcessingController.createBulkFulfilments';
import getItemStocks from '@salesforce/apex/ItemController.getItemStocks';
import bulkOrderProcessingRecordLimit from '@salesforce/label/c.Configuration_BulkOrderProcessingRecordLimit';

const FIELD_BRANCHID = 'dmpl__BranchId__c';
const FIELD_PARTNER_ACCOUNTID = 'dmpl__PartnerAccountId__c';

export default class BulkOrderProcessingCmp extends LightningElement {
    @api objectApiName;
    @api filterFieldSetName;

    @api relatedObjectApiName;
    @api relatedObjectFieldSetName;

    @api resultLabel;
    @api parentLookupField;
    @api defaultWhereClause;
    @api defaultOrderByClause;
    @api editableFields;

    @track relatedObjectColumns = [];
    @track columns;
    @track relatedRecords = [];
    @track excludeColumns = ['quantityAvailable', 'quantityInHand'];
    @track hideColumns = ['dmpl__PendingInvoiceQuantity__c'];

    selectedPartnerAccountId;
    selectedBranchId;
    isLoaded = true;

    @wire(getFieldsByFieldSetName, { objectApiName: '$objectApiName', fieldSetName: '$filterFieldSetName' })
    fieldsetFields;

    @wire(getUserDefaults, {})
    userDefaults;

    @wire(getFieldsByFieldSetName, { objectApiName: '$relatedObjectApiName', fieldSetName: '$relatedObjectFieldSetName' })
    handleRelatedFieldset({ error, data }) {
        if (data) {
            data.forEach(fieldSet => {
                this.relatedObjectColumns.push({ label: fieldSet.label, fieldName: fieldSet.apiName, type: 'text', editable: this.editableFields ? this.editableFields.split(',').includes(fieldSet.apiName) : false, hideLabel: !this.hideColumns.includes(fieldSet.apiName)});
            })

            this.relatedObjectColumns.push({ label: 'Quantity Available', fieldName: 'quantityAvailable', type: 'text' })
            this.relatedObjectColumns.push({ label: 'Quantity In Hand', fieldName: 'quantityInHand', type: 'text' })
            this.columns = this.relatedObjectColumns.filter(x=> !this.hideColumns.includes(x.fieldName));
        }
    }

    handleLoad() {
        this.populateHardCodedDefaultValues(true);
    }

    populateHardCodedDefaultValues(fireChange) {
        if (this.userDefaults && this.userDefaults.data) {
            if (this.userDefaults?.data?.dmpl__DefaultBranchId__c) {
                this.setDefaultValue(FIELD_BRANCHID, this.userDefaults.data.dmpl__DefaultBranchId__c, fireChange);
            }
            if (this.userDefaults?.data?.dmpl__DefaultPartnerAccountId__c) {
                this.setDefaultValue(FIELD_PARTNER_ACCOUNTID, this.userDefaults.data.dmpl__DefaultPartnerAccountId__c, fireChange);
            }
        }
    }

    setDefaultValue(name, value) {
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        if (inputFields) {
            inputFields.forEach(field => {
                if (field.fieldName == name
                    && field.value != value) {
                    field.value = value == "true" ? true : value == "false" ? false : value;
                    return;
                }
            });
        }
    }

    getValue(name) {
        let value = undefined;
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        if (inputFields) {
            inputFields.forEach(field => {
                if (field.fieldName == name) {
                    value = field.value
                }
            });
        }
        return value;
    }

    async fetchData() {
        if (!this.getValue(FIELD_PARTNER_ACCOUNTID)) {
            this.showError('Please select Partner Account');
            return;
        }
        if (!this.getValue(FIELD_BRANCHID)) {
            this.showError('Please select Branch');
            return;
        }
        this.isLoaded = false;
        let filters = await this.getFilters();
        setTimeout(() => {

            getRelatedRecordsCount({ whereClause: JSON.stringify(filters), relatedObjectApiName: this.relatedObjectApiName, queryFields: this.relatedObjectColumns.filter(x => !this.excludeColumns.includes(x.fieldName)).map(x => x.fieldName) }).then(result => {
                console.log('result ', result);
                if (result > bulkOrderProcessingRecordLimit) {
                    this.showError('Total count of records is more than ' + bulkOrderProcessingRecordLimit + ', Kindly apply filters and try again');
                    this.isLoaded = true;
                    return;
                }
                else {
                    getRelatedRecords({ whereClause: JSON.stringify(filters) + ' ' + this.defaultOrderByClause, relatedObjectApiName: this.relatedObjectApiName, queryFields: this.relatedObjectColumns.filter(x => !this.excludeColumns.includes(x.fieldName)).map(x => x.fieldName) }).then(result => {
                        this.relatedRecords = [];
                        let itemIds = result.map(x => x.dmpl__ItemId__c);
                        let branchIds = this.userDefaults.data.dmpl__DefaultBranchId__c;
                        getItemStocks({ itemIds: itemIds, branchIds: branchIds }).then((stocks) => {
                            result.forEach((record) => {
                                let newRecord = Object.assign({}, JSON.parse(JSON.stringify(record)));
                                this.columns.forEach(column => {
                                    if (column.fieldName.includes('.')) {
                                        let fields = column.fieldName.split('.');
                                        newRecord[column.fieldName] = record[fields[0]] ? record[fields[0]][fields[1]] : null;
                                    } else if (column.fieldName == 'quantityAvailable') {
                                        newRecord['quantityAvailable'] = this.getQuantityAvailable(stocks, record['dmpl__ItemId__c'], record['dmpl__SKUId__c'], this.userDefaults.data.dmpl__DefaultBranchId__c);
                                        newRecord['quantityInHand'] = this.getQuantityInHand(stocks, record['dmpl__ItemId__c'], record['dmpl__SKUId__c'], this.userDefaults.data.dmpl__DefaultBranchId__c);
                                    }
                                })
                                newRecord['dmpl__Quantity__c'] = newRecord['dmpl__PendingInvoiceQuantity__c'];

                                this.relatedRecords.push(newRecord);
                            })
                        }).catch((error) => {
                            console.log('Error ', error);
                        });
                        this.isLoaded = true;
                    }).catch(error => {
                        console.log(' Error ', error);
                    })
                }
            })

        }, 200);
    }

    getQuantityAvailable(stocks, itemId, skuId, branchId) {
        let quantityAvailable = 0;
        stocks.forEach(stock => {
            if (stock['ItemId'] === itemId && ((skuId != undefined && skuId != '' && stock['SKUId'] == skuId) || skuId == undefined) && stock['BranchId'] == branchId) {
                quantityAvailable = stock['QuantityAvailable'];
            }
        })
        return quantityAvailable;
    }

    getQuantityInHand(stocks, itemId, skuId, branchId) {
        let quantityInHand = 0;
        stocks.forEach(stock => {
            if (stock['ItemId'] === itemId && ((skuId != undefined && skuId != '' && stock['SKUId'] == skuId) || skuId == undefined) && stock['BranchId'] == branchId) {
                quantityInHand = stock['QuantityInHand'];
            }
        })
        return quantityInHand;
    }

    get getData() {
        return this.relatedRecords && this.relatedRecords.length > 0 ? JSON.parse(JSON.stringify(this.relatedRecords)) : [];
    }

    get isDataFound() {
        return this.relatedRecords.length > 0;
    }

    get totalRecordsCount() {
        return this.relatedRecords.length;
    }

    async getFilters() {
        let filters = [];
        let allFields = this.template.querySelectorAll('lightning-input-field');
        allFields.forEach((field) => {
            if (field.value) {
                filters.push(this.parentLookupField + '.' + field.fieldName + ' = \'' + field.value + '\'');
            }
        })

        let fromDate = this.template.querySelectorAll(".from-date")[0]?.value;
        let toDate = this.template.querySelectorAll(".to-date")[0]?.value;
        if (fromDate)
            filters.push(this.parentLookupField + '.' + 'dmpl__DocumentDate__c >= ' + fromDate);
        if (toDate)
            filters.push(this.parentLookupField + '.' + 'dmpl__DocumentDate__c <= ' + toDate);
        if (this.defaultWhereClause && this.defaultWhereClause != '')
            filters.push(this.defaultWhereClause);
        return filters.join(' AND ');
    }

    handleCreateInvoices() {
        this.isLoaded = false;
        let selectedRecords = this.template.querySelector('lightning-datatable').getSelectedRows();
        let draftValues = this.template.querySelector('lightning-datatable').draftValues;
        console.log('draftValues '+ JSON.parse(JSON.stringify(draftValues)));
        createBulkInvoices({ saleOrderLineIds: selectedRecords.map(x => x.Id), saleOrderLineDraftValues : JSON.parse(JSON.stringify(draftValues)), editableFields : this.editableFields ? this.editableFields.split(',') : [] }).then(result => {
            if (result.length > 0) {
                this.showMessage(result.length + ' New Invoices are created!');
                this.template.querySelector('lightning-datatable').draftValues = null;
            }
            this.isLoaded = true;
            this.fetchData();
        }).catch(error => {
            this.showError('Something went wrong while processing sale order lines!' + '\n' + error?.body?.message);
            console.log(' error ', error);
            this.isLoaded = true;
        })
    }

    // handleCreateFulfillments(){
    //     let selectedRecords = this.template.querySelector('lightning-datatable').getSelectedRows();
    //     createBulkFulfilments({objectAPIName : this.relatedObjectApiName, recordIds : selectedRecords.map(x=>x.Id)}).then(result => {
    //         console.log('Bulk Fulfillments', result);
    //     }).catch(error => {
    //         console.log(' error ', error);
    //     })
    // }

    showMessage(message) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: message,
                variant: 'success',
            }),
        );
    }

    showError(message) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error',
                message: message,
                variant: 'error',
            }),
        );
    }
}