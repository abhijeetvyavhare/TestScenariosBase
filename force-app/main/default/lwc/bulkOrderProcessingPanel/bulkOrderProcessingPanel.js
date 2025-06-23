import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getFieldsByFieldSetName from '@salesforce/apex/MetadataController.getFieldsByFieldSetName';
import getUserDefaults from '@salesforce/apex/BulkOrderProcessingController.getUserDefaults';
import getRelatedRecords from '@salesforce/apex/BulkOrderProcessingController.getLineRelatedRecords';
import getRelatedRecordsCount from '@salesforce/apex/BulkOrderProcessingController.getRelatedRecordsCount';
import bulkOrderLine from '@salesforce/apex/BulkOrderProcessingController.bulkOrderLine';
import processBulkOrderLines from '@salesforce/apex/BulkOrderProcessingController.processBulkOrderLines';
import fetchVisitRoute from '@salesforce/apex/BulkOrderProcessingController.fetchVisitRoute';
import fetchSalesPerson from '@salesforce/apex/BulkOrderProcessingController.fetchSalesPerson';
import queryRouteAccountsCustom from '@salesforce/apex/BulkOrderProcessingController.queryRouteAccountsCustom';
import getItemStocks from '@salesforce/apex/BulkOrderProcessingController.getItemStocks';

const FIELD_BRANCHID = 'dmpl__BranchId__c';
const FIELD_PARTNER_ACCOUNTID = 'dmpl__PartnerAccountId__c';
const DELAY = 100; //Milliseconds

export default class bulkOrderProcessingPanel extends LightningElement {
    @api currentPartnerAccount;
    @api currentBranch ="";
    @api currentSalesPerson;
    @track VisitRouteStopAccountIds=[];
    selectedRouteId=[];
    @track selectAccountIds = [];
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
    @track excludeColumns = ['quantityAvailable', 'quantityInHand','error'];
    @track hideColumns = ['dmpl__PendingInvoiceQuantity__c','quantityInHand'];
    @track sortBy;
    @track sortDirection;
    @track doNotShow = false;
    @track doNotShowPartialOrder = false;
    @track bulkOrderLines = [];
    jobQueueId ='';
    currentStatus = '';
    selectedRecordIdsSalesPerson = [];
    selectedRecordIds = [];
    selectedPartnerAccountId;
    selectedBranchId;
    isLoaded = true;

    get enableButtons(){
        return !this.isLoaded;
    }

    @wire(getFieldsByFieldSetName, { objectApiName: '$objectApiName', fieldSetName: '$filterFieldSetName' })
    fieldsetFields;

    @wire(getUserDefaults, {})
    userDefaults;

    @wire(getFieldsByFieldSetName, { objectApiName: '$relatedObjectApiName', fieldSetName: '$relatedObjectFieldSetName' })
    handleRelatedFieldset({ error, data }) {
        if (data) {
            data.forEach(fieldSet => {
                this.relatedObjectColumns.push({ label: fieldSet.label, fieldName: fieldSet.apiName, sortable: "true", type: 'text',initialWidth : 100, editable: this.editableFields ? this.editableFields.split(',').includes(fieldSet.apiName) : false, hideLabel: !this.hideColumns.includes(fieldSet.apiName) });
            })
            this.relatedObjectColumns.push({ label: 'Available Quantity', fieldName: 'quantityAvailable', sortable: "true", type: 'text',initialWidth : 100 })
            this.relatedObjectColumns.push({ label: 'Quantity In Hand', fieldName: 'quantityInHand', sortable: "true", type: 'text' })
            this.relatedObjectColumns.push({ label: 'Batch Name', fieldName: 'dmpl__ItemLotId__r.Name', sortable: "true", type: 'text',initialWidth : 100 })
            this.relatedObjectColumns.push({ label: 'Error', fieldName: 'error', sortable: "true", type: 'text', initialWidth : 300 })
            this.columns = this.relatedObjectColumns.filter(x => !this.hideColumns.includes(x.fieldName));
        }
    }

    handleLoad() {
        this.populateHardCodedDefaultValues(true);
    }

    populateHardCodedDefaultValues(fireChange) {
        if (this.userDefaults && this.userDefaults.data.length > 0) {
            if (this.userDefaults?.data[0].dmpl__DefaultBranchId__c) {
                this.currentBranch = this.userDefaults?.data[0].dmpl__DefaultBranchId__c;
                console.log("branch",this.currentBranch);
                this.setDefaultValue(FIELD_BRANCHID, this.userDefaults?.data[0].dmpl__DefaultBranchId__c, fireChange);
            }
            if (this.userDefaults?.data[0].dmpl__DefaultPartnerAccountId__c) {
                this.currentPartnerAccount = this.userDefaults?.data[0].dmpl__DefaultPartnerAccountId__c;
                console.log("partner account",this.currentPartnerAccount);
                this.setDefaultValue(FIELD_PARTNER_ACCOUNTID, this.userDefaults?.data[0].dmpl__DefaultPartnerAccountId__c, fireChange);
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
        this.currentStatus = 'Fetching Records';
        let filters = await this.getFilters();
        let headerFilters = await this.getHeaderFilters();
        setTimeout(() => {

            getRelatedRecordsCount({
                whereClause: JSON.stringify(filters),
                relatedObjectApiName: this.relatedObjectApiName,
                queryFields: this.relatedObjectColumns.filter(x => !this.excludeColumns.includes(x.fieldName)).map(x => x.fieldName)
            }).then(result => {
                if (result > 1000) {
                    this.showError('Total count of records is more than ' + 1000 + ', Kindly apply filters and try again');
                    return;
                }
                else {
                    getRelatedRecords({
                        whereClause: JSON.stringify(filters), 
                        orderByClause: this.defaultOrderByClause, 
                        doNotShowPartialOrder: this.doNotShowPartialOrder,
                        lineWhereClause: JSON.stringify(filters),
                        relatedObjectApiName: this.relatedObjectApiName,
                        queryFields: this.relatedObjectColumns.filter(x => !this.excludeColumns.includes(x.fieldName)).map(x => x.fieldName),
                        selectedRecordIdsSalesPerson: this.selectedRecordIdsSalesPerson,
                        selectedRecordIds: this.selectedRecordIds,
                        VisitRouteStopAccountIds: this.VisitRouteStopAccountIds
                    }).then(mappedResult => {
                        let result = mappedResult?.SaleOrderLines;
                        this.bulkOrderLines = mappedResult?.BulkOrderLines;
                        let itemLots = mappedResult?.ItemLots;
                        this.relatedRecords = [];
                        let itemIds = result.map(x => x.dmpl__ItemId__c);
                        let branchIds = this.userDefaults.data[0].dmpl__DefaultBranchId__c;
                        console.log(branchIds);
                        getItemStocks({ itemIds: itemIds, branchIds: branchIds })
                            .then((stocks) => {
                                console.log(stocks);
                                result.forEach((record) => {
                                    let newRecord = Object.assign({}, JSON.parse(JSON.stringify(record)));
                                   console.log('record '+ JSON.stringify(record));
                                    this.columns.forEach(column => {
                                        if (column.fieldName.includes('.')) {
                                            let fields = column.fieldName.split('.');
                                            newRecord[column.fieldName] = record[fields[0]] ? record[fields[0]][fields[1]] : null;
                                        } else if (column.fieldName == 'quantityAvailable') {
                                            newRecord['quantityAvailable'] = this.getQuantityAvailable(stocks, record['dmpl__ItemId__c'], record['dmpl__ItemLotTypeId__c'], this.userDefaults.data[0].dmpl__DefaultBranchId__c);
                                            newRecord['quantityInHand'] = this.getQuantityInHand(stocks, record['dmpl__ItemId__c'], record['dmpl__ItemLotTypeId__c'], this.userDefaults.data[0].dmpl__DefaultBranchId__c);
                                        }
                                    })
                                    newRecord['dmpl__Quantity__c'] = newRecord['dmpl__PendingInvoiceQuantity__c'];
                                    newRecord['BulkOrderLineId__c'] = this.bulkOrderLines.find(x => x.dmpl__SaleOrderLineId__c == newRecord.Id).Id;
                                    this.jobQueueId = this.bulkOrderLines.find(x => x.dmpl__SaleOrderLineId__c == newRecord.Id).dmpl__JobQueueId__c;
                                    console.log('this.jobQueueId',this.jobQueueId);
                                    if(newRecord['dmpl__ItemLotId__c'])
                                    {
                                        let currentItemLot = itemLots.find(x=>x.Id === newRecord['dmpl__ItemLotId__c']);
                                        newRecord['dmpl__ItemLotId__r'] = currentItemLot;
                                        newRecord['dmpl__ItemLotId__r.Name'] = currentItemLot?.Name;
                                        newRecord['dmpl__ItemLotId__r.dmpl__QuantityAvailable__c'] = currentItemLot?.dmpl__QuantityAvailable__c;
                                    }
                                    console.log('newRecord1 '+ JSON.stringify(newRecord));
                                    if (newRecord['quantityAvailable'] > 0) {
                                        this.relatedRecords.push(newRecord);
                                    }
                                    else if (this.doNotShow == false)
                                        this.relatedRecords.push(newRecord);

                                })

                                setTimeout(() => {
                                    this.isLoaded = true;
                                    this.currentStatus = '';
                                    console.log(JSON.parse(JSON.stringify(this.relatedRecords)));
                                }, 3000);
                            }).catch((error) => {
                                console.log('Error ', error);
                                setTimeout(() => {
                                    this.isLoaded = true;
                                    this.currentStatus = '';
                                }, 1000);
                            });
                    }).catch(error => {
                        this.currentStatus = '';
                        console.log(' Error ', error);
                    })
                }
            })

        }, 1000);
    }

    getQuantityAvailable(stocks, itemId, skuId, branchId) {
        console.log(branchId);
        let quantityAvailable = 0;
        stocks.forEach(stock => {
            if (stock['ItemId'] === itemId && stock['BranchId'] == branchId && (stock['LotTypeId'] === skuId || skuId == null)) {
                console.log(stock['QuantityAvailable'] );
                quantityAvailable = stock['QuantityAvailable'];
            }
        })
        console.log(quantityAvailable);
        return quantityAvailable;
    }

    getQuantityInHand(stocks, itemId, skuId, branchId) {
        let quantityInHand = 0;
        stocks.forEach(stock => {
            if (stock['ItemId'] === itemId && stock['BranchId'] == branchId && (stock['LotTypeId'] === skuId || skuId == null)) {
                quantityInHand = stock['QuantityInHand'];
            }
        })
        return quantityInHand;
    }

    handleDoNotShow(event) {
        this.doNotShow = event.detail.checked;
    }

    handleDoNotShowPartial(event) {
        this.doNotShowPartialOrder = event.detail.checked;
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

    async getHeaderFilters() {
        let filters = [];
        let allFields = this.template.querySelectorAll('lightning-input-field');
        allFields.forEach((field) => {
            if (field.value) {
                filters.push(field.fieldName + ' = \'' + field.value + '\'');
            }
        })

        let fromDate = this.template.querySelectorAll(".from-date")[0]?.value;
        let toDate = this.template.querySelectorAll(".to-date")[0]?.value;
        if (fromDate)
            filters.push('dmpl__DocumentDate__c >= ' + fromDate);
        if (toDate)
            filters.push('dmpl__DocumentDate__c <= ' + toDate);

        return filters.join(' AND ');
    }

    async validateSelectedLines() {
        this.currentStatus = 'Validating Selected Records!';
        this.isLoaded = false;
        setTimeout(() => {
            let selectedRecords = this.template.querySelector('lightning-datatable').getSelectedRows();
            let tableDraftValues = this.template.querySelector('lightning-datatable').draftValues;
            let summaryDetails = [];
            let errorItems = [];
            let counter = 0;
            let isValid = false;
            if (selectedRecords.length > 0) {
                try {
                    selectedRecords.forEach(currentItem => {
                        console.log('counter ' + counter);
                        this.currentStatus = 'Validating Selected Records No. '+counter;
                        counter++;
                        let changedQuantity = 0;
                        let draftValues = tableDraftValues.find(v => v.Id == currentItem.Id);
                        if (summaryDetails.filter(x => x.ItemId == currentItem.dmpl__ItemId__c).length == 0) {
                            summaryDetails.push({ ItemId: currentItem.dmpl__ItemId__c, ItemName: currentItem.dmpl__ItemId__r.Name, QuantityAvailable: currentItem.quantityAvailable, SelectedQuantity: 0 });
                        }
                        if (draftValues) {
                            changedQuantity = draftValues.dmpl__Quantity__c;
                            summaryDetails.find(x => x.ItemId == currentItem.dmpl__ItemId__c).SelectedQuantity = parseInt(summaryDetails.find(x => x.ItemId == currentItem.dmpl__ItemId__c).SelectedQuantity) + parseInt(changedQuantity);
                        }
                        else {
                            changedQuantity = currentItem.dmpl__Quantity__c;
                            summaryDetails.find(x => x.ItemId == currentItem.dmpl__ItemId__c).SelectedQuantity = parseInt(summaryDetails.find(x => x.ItemId == currentItem.dmpl__ItemId__c).SelectedQuantity) + parseInt(changedQuantity);
                        }
                    });
                    summaryDetails.forEach(currentItem => {
                        console.log('currentItem.QuantityAvailable ' + currentItem.QuantityAvailable);
                        console.log('currentItem.SelectedQuantity ' + currentItem.SelectedQuantity);
                        if (currentItem.QuantityAvailable < currentItem.SelectedQuantity)
                        {
                            errorItems.push(currentItem.ItemName + '( Available :' + currentItem.QuantityAvailable + ' & Selected : ' + currentItem.SelectedQuantity + ' )');
                            this.filter(x=>x.dmpl__ItemId__c === currentItem.ItemId).forEach((record)=>{
                                record['error'] = 'Order Quanity '+currentItem.SelectedQuantity +' And Available Quantity '+currentItem.QuantityAvailable +' for Item '+currentItem.ItemName +' )';
                            }) 
                        }
                    })
                    if (errorItems.length > 0) {
                        throw 'You cannot select Quantity more than available quantity for Items.';// : \n' + errorItems.join(',\n');
                    }
                    else {
                        console.log('Is Valid');
                        isValid = true;
                    }
                    if (isValid) {
                        this.currentStatus = 'Submitting Order Lines For Invoicing!';
                        console.log('Proceed with processing!');
                        console.log('rrrrrrrr ',JSON.stringify(selectedRecords))
                        this.submitForInvoicing(selectedRecords);
                    }
                } catch (error) {
                    this.isLoaded = true;
                    console.log('error ', error);
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error',
                            message: JSON.stringify(error),
                            variant: 'error',
                            mode: 'sticky'
                        }),
                    );
                } finally {
                    errorItems = [];
                    summaryDetails = [];
                    modifiedSaleOrderLines = [];
                    this.template.querySelector('lightning-datatable').draftValues = [];
                    isValid = false;
                }
            }
            else {
                this.isLoaded = true;
            } 
        }, 2000);
    }

    async submitForInvoicing(selectedRecords) {
        let totalRows = selectedRecords.length;
        try {
            this.isLoaded = false;
            if (totalRows == 0) {
                return;
            }
            let pageNumber = 1;
            let pageSize = 200;//parseInt(batchSize) > 0 ? parseInt(batchSize) : 100;
            let totalPages = Math.ceil(totalRows / pageSize);
            let offset = 0;

            while (pageNumber <= totalPages) {
                let dataToUpload = selectedRecords.slice(offset, offset + pageSize).map(v => {
                    let record = {};
                    console.log('selectedRecords********'+JSON.stringify(selectedRecords));
                    console.log('relatedRecords********'+JSON.stringify(this.relatedRecords));
                    record['Id'] = this.relatedRecords.find(x => x.Id == v.Id).BulkOrderLineId__c;
                    console.log('ididididid'+this.relatedRecords.find(x => x.Id == v.Id).BulkOrderLineId__c);
                    record['Status__c'] = 'Pending'
                    return record;
                })
                let saveResults = await bulkOrderLine({
                    jsonString: JSON.stringify(dataToUpload)
                });

                console.log('Saved 200 Records ' + saveResults);
                pageNumber += 1;
                offset = (pageNumber - 1) * pageSize;
            }
            let saleOrderBatches = await processBulkOrderLines( {jobQueueId:this.jobQueueId});
        } catch (error) {
            console.log('error---- ', error);
            this.showError(error);
        } finally {
            this.isLoaded = true;
            this.currentStatus= '';
            this.showMessage(totalRows + ' order lines submitted for invoicing!');
            this.template.querySelector('lightning-datatable').draftValues = [];
            this.relatedRecords = [];
        }
    }

    async handleCellChange(event) {
        try {
            this.currentStatus = 'Syncing Modified Quantities!';
            this.isLoaded = false;
            let totalRows = event.detail.draftValues.length;
            if (totalRows == 0) {
                return;
            }
            let pageNumber = 1;
            let pageSize = 200;
            let totalPages = Math.ceil(totalRows / pageSize);
            let offset = 0;
            while (pageNumber <= totalPages) {
                let dataToUpload = event.detail.draftValues.slice(offset, offset + pageSize).map(v => {
                    let record = {};
                    record['Id'] = this.relatedRecords.find(x => x.Id == v.Id).BulkOrderLineId__c;
                    record['Quantity__c'] = v.dmpl__Quantity__c;
                    return record;
                })
                let saveResults = await bulkOrderLine({
                    jsonString: JSON.stringify(dataToUpload)
                });

                console.log('Saved 200 Records ' + saveResults);
                pageNumber += 1;
                offset = (pageNumber - 1) * pageSize;
            }
        } catch (error) {
            console.log('error*********** ', error);
            this.showError(error);
        } finally {
            this.isLoaded = true;
            this.currentStatus = '';
        }
    }

    doSorting(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortBy, this.sortDirection);
    }

    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.relatedRecords));
        let keyValue = (a) => {
            return a[fieldname];
        };
        let isReverse = direction === 'asc' ? 1 : -1;
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; 
            y = keyValue(y) ? keyValue(y) : '';
            return isReverse * ((x > y) - (y > x));
        });
        this.relatedRecords = parseData;
    }

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
                variant: 'error'
            }),
        );
    }
     //For Salesperson and VisitRoute Combobox
    
    //Visit Route Custom
    searchKey;
    //@api iconName = "standard:account";
    hasRecords = false;
    searchOutput = [];
    selectedRecords = [];
    
    delayTimeout;
    

    @wire(fetchVisitRoute, { searchKey: '$searchKey', currentPartnerAccount: '$currentPartnerAccount', currentBranch: '$currentBranch', selectedRecordIdsSalesPerson:'$selectedRecordIdsSalesPerson'})
    searchResult({data,error}){
        if(data){
            console.log(data.length+'datalen visitR');
            this.hasRecords = data.length > 0 ? true : false;
            this.searchOutput = data;
        }
        else if(error){
            console.log(error);
        }
    }
    changeHandler(event){
        clearTimeout(this.delayTimeout);
        let value = event.target.value;
        console.log('value'+value);
        this.delayTimeout = setTimeout(()=>{
            this.searchKey = value;
    
        },DELAY);
        

    }
    clickHandler(event){
        
        let recId = event.target.getAttribute("data-recid");
        if(this.validateDuplicate(recId)){
            let selectedRecord =  this.searchOutput.find(currItem => currItem.Id === recId);
            let pill = {
               // type: 'icon',
                label: selectedRecord.Name.substring(0, 10),
                name:recId,
                iconName: this.iconName,
                alternativeText: selectedRecord.Name,
            };
           
            this.selectedRecords = [...this.selectedRecords,pill];
            console.log('selectedRecords' + this.selectedRecords);
            
            this.selectedRecordIds = this.selectedRecords.map(pill => pill.name);
            console.log('selectedRecordIds'+this.selectedRecordIds);
        
            this.selectedRouteId = [...this.selectedRecordIds];
            console.log("Selected current Route" +this.selectedRouteId);
            // if(event.target.value==null){
            //     this.selectedRouteId =null;
            //     this.selectedRecordIds =[];
            // }
            if (this.selectedRecordIds.length !== 0) {
                queryRouteAccountsCustom({ routeIds: this.selectedRecordIds })
                    .then((result) => {
                        this.VisitRouteStopAccountIds=[...result];
                    })
                    .catch((error) => {
                        console.log('error ', error);
                    });
            } else {
                this.selectAccountIds = [];
                this.selectedRouteId = null;
            }
         //   console.log(this.selectedRecords.map(pill => pill.name) + " selectedRecord array");
            

        }
        
    }
    
    handleItemRemove(event){
        const index = event.detail.index;
        this.selectedRecords.splice(index,1);
        this.selectedRecordIds.splice(index,1);
        
        
        this.selectedRouteId.splice(index,1);
    }
    get showPillContainer(){
        return this.selectedRecords.length > 0 ? true:false;
    }
    validateDuplicate(selectedRecord){
        let isValid =true;
        let isRecordAlreadySelected = this.selectedRecords.find(currItem => currItem.name === selectedRecord);
        

        if(isRecordAlreadySelected){
            isValid = false;
            this.dispatchEvent(new ShowToastEvent({
                title: "Error",
                message: `${isRecordAlreadySelected.alternativeText} is already selected.`,
                variant: "error"
            }));
        }
        else{
            isValid = true;
        }
        return isValid;
    }
    

    //Salesperson Custom
    searchKeySalesPerson;
    hasRecordsSalesPerson = false;
    searchOutputSalesPerson = [];
    selectedRecordsSalesPerson = [];
    
    delayTimeoutSalesPerson;

    @wire(fetchSalesPerson, { searchKeySalesPerson: '$searchKeySalesPerson', currentPartnerAccount: '$currentPartnerAccount', currentBranch: '$currentBranch'})
    searchResultSalesPerson({data,error}){
        if(data){
            console.log(data.length+'datalen');
            this.hasRecordsSalesPerson = data.length > 0 ? true : false;
            this.searchOutputSalesPerson = data;
        }
        else if(error){
            console.log(error);
        }
    }
    changeHandlerSalesPerson(event){
        clearTimeout(this.delayTimeoutSalesPerson);
        let value = event.target.value;
        console.log('value SP'+value);
        this.delayTimeoutSalesPerson = setTimeout(()=>{
            this.searchKeySalesPerson = value;
        },DELAY);
        

    }
    clickHandlerSalesPerson(event){
        
        let recId = event.target.getAttribute("data-recid");
        if(this.validateDuplicateSalesPerson(recId)){
            let selectedRecordSalesPerson =  this.searchOutputSalesPerson.find(currItem => currItem.Id === recId);
            let pill = {
               // type: 'icon',
                label: selectedRecordSalesPerson.Name.substring(0, 10),
                name:recId,
                iconName: this.iconName,
                alternativeText: selectedRecordSalesPerson.Name,
            };
            this.selectedRecordsSalesPerson = [...this.selectedRecordsSalesPerson,pill];

            this.selectedRecordIdsSalesPerson = this.selectedRecordsSalesPerson.map(pill => pill.name);
            console.log('selectedSalespersonRecId '+this.selectedRecordIdsSalesPerson);
            this.currentSalesPerson = this.selectedRecordIdsSalesPerson;

        }
        
    }
    
    handleItemRemoveSalesPerson(event){
        const index = event.detail.index;
        this.selectedRecordsSalesPerson.splice(index,1);
        this.selectedRecordIdsSalesPerson.splice(index,1);
        
    }
    get showPillContainerSalesPerson(){
        return this.selectedRecordsSalesPerson.length > 0 ? true:false;
    }
    validateDuplicateSalesPerson(selectedRecordSalesPerson){
        let isValid =true;
        let isRecordAlreadySelected = this.selectedRecordsSalesPerson.find(currItem => currItem.name === selectedRecordSalesPerson);
        

        if(isRecordAlreadySelected){
            isValid = false;
            this.dispatchEvent(new ShowToastEvent({
                title: "Error",
                message: `${isRecordAlreadySelected.alternativeText} is already selected.`,
                variant: "error"
            }));
        }
        else{
            isValid = true;
        }
        return isValid;
    }
    
}