/* eslint-disable @lwc/lwc/no-async-operation */
/* eslint-disable @lwc/lwc/no-inner-html */
import { LightningElement, wire, api, track } from "lwc";
import { getRecord, updateRecord, getFieldValue } from "lightning/uiRecordApi";
import { getRelatedListInfo, getRelatedListRecords } from "lightning/uiRelatedListApi";
import { NavigationMixin } from "lightning/navigation";
import { encodeDefaultFieldValues } from "lightning/pageReferenceUtils";
import { refreshGraphQL } from "lightning/uiGraphQLApi";
import { notifyRecordUpdateAvailable } from "lightning/uiRecordApi";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import { reduceErrors } from 'c/utils';
import { subscribe, unsubscribe, publish, MessageContext } from 'lightning/messageService';
import FORCEREFRESHMC from '@salesforce/messageChannel/ForceReset__c';
import updateRelatedRecords from "@salesforce/apex/RelatedListController.updateRelatedRecords";
import uploadFile from '@salesforce/apex/RelatedListController.uploadFile'

export default class DmplRelatedList extends NavigationMixin(LightningElement) {
    @api recordId;
    @api objectApiName;
    relatedData;
    wiredRelatedDataResult;
    relatedListColumns; // API response columns
    dataTable;
    dataTableColumns; // Datatable columns
    dataTableColumnsMap;
    relatedListFields;
    lookupField;

    pageToken;
    currentPageToken;
    nextPageToken;

    @api iconName;
    @api pRelatedListTitle;
    relatedListTitle;
    @api pActionList;
    actionList;
    @api pRelatedListName;
    relatedListName;
    @api pRelatedObjectApiName;
    relatedObjectApiName;
    @api pRelatedFields;
    relatedFields;
    @api pEditableRelatedFields;
    editableRelatedFields;
    @api pUploadFields;
    uploadFields;
    @api pDefaultSortedBy;
    sortedBy;
    @api pDefaultSortDirection;
    sortDirection;
    @api pFilterText = '{ CreatedBy: { Name: { ne: "System Batch Job" } } }';
    filterText;
    @api pPageSize;
    pageSize;
    @api showNewButton;
    @track draftValues = [];
    @track _actionList = [];

    showLoading1 = true;
    showLoading2 = false;
    wrapText = false;
    styleAdded = false;
    forceRefresh = false;
    showClipWrapButton = false;
    unsupportedListview = false;

    maxCellheight = 150; // in (px)
    maxTableHeight = 60; // in (vh)
    cellScrollbarWidth = 9; // in (px)
    privateChildren = {}; 
    actionVisible = {};

    @track isComponentLoaded = false; // Add this line to track whether the component is loaded or not
    @track isPanelVisible = true; // Add this line to track panel visibility

    connectedCallback() {
        this.relatedListTitle = this.pRelatedListTitle;
        this.relatedListName = this.pRelatedListName;
        this.parentObjectApiName = this.pParentObjectApiName;
        this.relatedObjectApiName = this.pRelatedObjectApiName; 
        this.relatedFields = this.pRelatedFields.split(",").map((x) => this.pRelatedObjectApiName + '.' + x.trim()); 
        this.editableRelatedFields = this.pEditableRelatedFields?.split(",").map((x) => x.trim()); 
        this.uploadFields = this.pUploadFields?.split(",").map((x) => x.trim()); 
        this.actionList = this.pActionList?.split(",").map((x) => x.trim()); 
        this.sortedBy = this.pDefaultSortedBy; 
        this.sortDirection = this.pDefaultSortDirection; 
        this.filterText = this.pFilterText;
        this.pageSize = this.pPageSize;
        this.subscription = subscribe(
            this.messageContext,
            FORCEREFRESHMC,
            (message) => {
                this.refreshData();
            }
        );
        this._actionList = this.getActionList;
    }

    disconnectedCallback() {
        unsubscribe(this.subscription);
        this.subscription = null;
        window.removeEventListener('click', () => { });
    }

    renderedCallback() {
        if (!this.isComponentLoaded) {
            window.addEventListener('click', (evt) => {
                this.handleClickOnWindow(evt);
            });
            this.isComponentLoaded = true;
        }
    }
    
    handleRegisterItem(event) {
        console.log('handleRegisterItem:::',event.detail);
        event.stopPropagation(); 
        const item = event.detail;
        if (!this.privateChildren.hasOwnProperty(item.name))
            this.privateChildren[item.name] = {};
        this.privateChildren[item.name][item.guid] = item;
    }

    @wire(getRecord, { recordId: "$recordId", fields: "$getRecordFieldNames" })
    wiredobjectRecord({ error, data }) {
        if(data){
            this.objectRecord = data;
            this.getActionList.forEach(v=>{
                if(v.visibleFieldName){
                    this.actionVisible[v.value] = !getFieldValue(data, `${this.objectApiName}.${v.visibleFieldName}`);
                }
            });
            this._actionList = this.getActionList;
        }
    }

    @wire(MessageContext)
    messageContext;

    get recordTypeId() {
        return getFieldValue(this.objectRecord, this.recordTypeIdFieldName);
    }

    get recordTypeIdFieldName() {
        return `${this.objectApiName}.RecordTypeId`;
    }

    get showPanel() {
        return this.isPanelVisible ? 'slds-show' : 'slds-hide';
    }

    get showLoading() {
        return this.showLoading1 || this.showLoading2;
    }
    
    get getRecordFieldNames(){
        return this.getActionList.filter(v => v.visibleFieldName).map(v => `${this.objectApiName}.${v.visibleFieldName}`); //[this.recordTypeIdFieldName].concat(
    }

    get sortBy() {
        let x = this.relatedObjectApiName + ".";
        let z = this.dataTableColumnsMap ? this.dataTableColumnsMap[this.sortedBy] : null;
        x = z && z.type === "url" ? x + z.typeAttributes.label.fieldName : x + this.sortedBy;
        let y = this.sortDirection === "asc" ? x : "-" + x;
        return [y];
    }

    get sortedByFieldLabel() {
        let z = this.dataTableColumnsMap ? this.dataTableColumnsMap[this.sortedBy] : null;
        return z ? z.label : "";
    }

    get getActionList() {
        if (!this.actionList) {
            return [];
        }
        return this.actionList.map(v=>{
            const parts = v.split('|');
            let atn = {
                label: parts[0],
                value: parts.length > 1 ? parts[1] : parts[0],
                visibleFieldName: parts.length > 2 ? parts[2] : null,
            }
            if(atn.visibleFieldName){
                atn.hidden = this.actionVisible.hasOwnProperty(atn.value) ? this.actionVisible[atn.value] : true 
            }
            return atn;
        });
    }

    get getRecordFieldNames(){
        return this.getActionList.filter(v => v.visibleFieldName).map(v => `${this.objectApiName}.${v.visibleFieldName}`); //[this.recordTypeIdFieldName].concat(
    }

    get sortBy() {
        let x = this.relatedObjectApiName + ".";
        let z = this.dataTableColumnsMap ? this.dataTableColumnsMap[this.sortedBy] : null;
        x = z && z.type === "url" ? x + z.typeAttributes.label.fieldName : x + this.sortedBy;
        let y = this.sortDirection === "asc" ? x : "-" + x;
        return [y];
    }

    get sortedByFieldLabel() {
        let z = this.dataTableColumnsMap ? this.dataTableColumnsMap[this.sortedBy] : null;
        return z ? z.label : "";
    }

    get getActionList() {
        if (!this.actionList) {
            return [];
        }
        return this.actionList.map(v=>{
            const parts = v.split('|');
            let atn = {
                label: parts[0],
                value: parts.length > 1 ? parts[1] : parts[0],
                visibleFieldName: parts.length > 2 ? parts[2] : null,
            }
            if(atn.visibleFieldName){
                atn.hidden = this.actionVisible.hasOwnProperty(atn.value) ? this.actionVisible[atn.value] : true 
            }
            return atn;
        });
    }

    @wire(getRelatedListInfo, {
        parentObjectApiName: "$objectApiName",
        relatedListId: "$relatedListName",
        optionalFields: "$relatedFields",
        restrictColumnsToLayout: false
    })
    wiredListInfo({ error, data }) {
        if (data) {
            this.relatedListColumns = data.displayColumns;
            this.lookupField = data.fieldApiName;
            console.log(JSON.stringify(data, null, 2) + ' column data');
            // to sort the columns based on the order of fields in the pRelatedFields (when restrictColumnsToLayout is false, the order of fields in the relatedListColumns is not guaranteed to be the same as the order of fields in the pRelatedFields. Hence the sorting is necessary)
            let columnMap = {};
            this.relatedListColumns.forEach((col) => {
                columnMap[col.fieldApiName] = col;
            });
            let columns = [];
            let listOfFields = this.pRelatedFields.split(",").map((field) => field.trim());
            listOfFields.forEach((field) => {
                if (columnMap[field]) columns.push(columnMap[field]);
            });

            // preparing the columns for the datatable
            this.dataTableColumns = columns.map((col) => this.prepareDatatableColumn(col));
            this.dataTableColumnsMap = {};
            this.dataTableColumns.forEach((col) => {
                this.dataTableColumnsMap[col.fieldName] = col;
            });
            this.fieldApiNames = this.relatedListColumns.map((col) => col.fieldApiName);
            this.relatedListFields = this.fieldApiNames.map((col) => this.relatedObjectApiName + "." + col);
        } else if (error) {
            console.error(JSON.stringify(error, null, 2));
            this.showLoading1 = false;
            this.unsupportedListview = true;
        }
    }

    togglePanelVisibility() {
        this.isPanelVisible = !this.isPanelVisible;
    }

    prepareDatatableColumn(col) {
        let x = {
            label: col.label,
            fieldName: col.fieldApiName,
            sortable: col.sortable,
            type: col.dataType,
            editable: this.editableRelatedFields?.find(f=>f == col.fieldApiName)!=undefined,
            minColumnWidth : 120
        };

        if (col.dataType === "boolean") {
            x.type = 'toggleButton';
            x.hideDefaultActions = true;
            x.hideLabel = true;
            x.editable = false;
            x.typeAttributes = 
            { 
                value: { fieldName: col.fieldApiName },
                rowId: { fieldName: 'Id' },
                fieldApiName : col.fieldApiName
            };
            x.cellAttributes  = {
                class: { fieldName: col.fieldApiName + '_Class' }
            };
            x.initialWidth = 150;
            if(window.innerWidth < 768){
                x.initialWidth = 175
            }
            x.initialWidth = 175;
            x.minColumnWidth = 75; 
        } else if (this.isLookupCol(col)){
            x.type = 'lookup';
            x.typeAttributes = {
                label: col.label,
                value: { fieldName: col.fieldApiName },
                relatedRecord: { fieldName: 'Id' },
                valueFieldName : col.fieldApiName
            };
            if(window.innerWidth < 768){
                x.initialWidth = 220;
            }
            x.minColumnWidth = 100;
        }else if (this.isUrlCol(col)) {
            x.type = "url";
            x.typeAttributes = {
                label: { fieldName: x.fieldName }
            };
            x.fieldName = col.lookupId + "_URL";
            if(window.innerWidth < 768){
                x.initialWidth = 175;
                x.minColumnWidth = 100;
            }
        }else if (this.isPicklistCol(col)){
            x.type = 'picklist';
            x.typeAttributes = {
                value: { fieldName: col.fieldApiName },
                name: col.label,
                options: col.picklistValues,
                relatedRecord: { fieldName: 'Id' },
                placeholder: 'Choose ' + col.label,
                variant: 'label-hidden',
                valueFieldName : col.fieldApiName
            };
            if(window.innerWidth < 768){
                x.initialWidth = 175;
                x.minColumnWidth = 100;
            }
            x.cellAttributes  = {
                class: { fieldName: col.fieldApiName + '_Class' }
            };
        }else if (this.isUploadCol(col)){
            x.label = col.label;
            x.type =  'fileUpload'
            x.initialWidth = 60;
            x.typeAttributes = {
                value: { fieldName: col.fieldApiName },
                relatedRecord: { fieldName: 'Id' },
                acceptedFormats : '.jpg,.jpeg,.pdf,.png',
                valueFieldName : col.fieldApiName
            }
            if(window.innerWidth < 768){
                x.initialWidth = 175;
            }
        }else if (this.isImageCol(col)){
            x.label = 'ICON';
            x.type = 'image';
            x.typeAttributes = {
                width  : 50,
                height : 50
            }
            if(window.innerWidth < 768){
                x.initialWidth = 175;
            }
        }else if(col.dataType == "double"
            || col.dataType == "datetime"
            || col.dataType == "text" 
            || col.dataType == "textarea"
            || col.dataType == "currency"
            || col.dataType == "percent"
            || col.dataType == "date"
            || col.dataType == "time"
            || col.dataType == "url"
            || col.dataType == "email"
            || col.dataType == "phone"
            || col.dataType == "multipicklist"
        ){
            if(window.innerWidth < 768){
                x.initialWidth = 175
            }
        }
        else if(col.dataType === 'reference' && lookupId == null){
            x.initialWidth = 220
        }else if(col.dataType == "string"){
            x.initialWidth = 270
        }
        
        return x;
    }

    isUrlCol(col) {
        return (col.dataType === "string" || col.dataType === "reference") && col.lookupId !== null;
    }

    isNameCol(col) {
        return col.dataType === "string" && col.lookupId === "Id";
    }

    isImageCol(col) {
        return col.dataType === "string" && col.lookupId === "Id";
    }

    isUploadCol(col) {
        return col.dataType === "string" && this.uploadFields?.find(f=>f == col.fieldApiName)!=undefined;
    }
    
    isPicklistCol(col) {
        return col.dataType === "picklist";
    }

    isLookupCol(col) {
        return col.dataType === "reference" && col.lookupId !== null;
    }

    handleSort(event) {
        this.showLoading1 = true;
        this.moveScrollbarToTop();
        this.forceRefresh = true;
        this.sortedBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.pageToken = null;
    }

    prepareRelatedObject(record) {
        let note = {};
        function getLookupObjectName(column) {
            return column.fieldApiName.split(".")[0];
        }
        try {
            this.relatedListColumns.forEach(
                function (col) {
                    let field = col.fieldApiName;
                    if (this.isUrlCol(col)) {
                        note[field] = field in record.fields ? record.fields[field]?.value : record.fields[getLookupObjectName(col)]?.displayValue;
                        if(getLookupObjectName(col) && record.fields[getLookupObjectName(col)]?.value){
                            note[col.lookupId + "_URL"] = "/" + record.fields[getLookupObjectName(col)]?.value?.id;
                        }
                    } else {
                        let v = record.fields[field]?.displayValue ? record.fields[field]?.displayValue : record.fields[field]?.value;
                        note[field] = v;
                    }
                }.bind(this)
            );
        } catch (error) {
            console.error(error);
        }
        
        note.Id = record.id;
        note.Id_URL = "/" + record.id;
        return note;
    }

    @wire(getRelatedListRecords, {
        parentRecordId: "$recordId",
        relatedListId: "$relatedListName",
        fields: "$relatedListFields",
        sortBy: "$sortBy",
        pageSize: "$pageSize", // max pageSize = 249; default = 50
        pageToken: "$pageToken",
        where: "$filterText"
    })
    wiredRelatedList(result) {
        if (!this.relatedListFields) {
            return;
        }
        this.wiredRelatedDataResult = result;
        const { error, data } = result;
        if (data) {
            let x = [];
            data.records.forEach((record) => {
                x.push(this.prepareRelatedObject(record));
            });
            if (this.currentPageToken && this.currentPageToken === data.previousPageToken) {
                let z = JSON.parse(JSON.stringify(this.relatedData));
                Array.prototype.push.apply(z, x);
                this.relatedData = z;
            } else {
                this.relatedData = x;
            }
            this.lastSavedRelatedData = JSON.parse(JSON.stringify(this.relatedData));
            this.currentPageToken = data.currentPageToken;
            this.nextPageToken = data.nextPageToken;
            if (this.forceRefresh) this.refreshData();
            if (this.dataTable) this.dataTable.isLoading = false;
            this.showLoading1 = false;
        } else if (error) {
            console.error(JSON.stringify(error));
            this.relatedData = [];
            this.showLoading1 = false;
        }
    }

    get recordCount() {
        return this.relatedData ? this.relatedData.length : 0;
    }

    get hasRelatedData() {
        return this.recordCount !== 0;
    }

    get showEmptyMessage() {
        return !this.showLoading && !this.hasRelatedData;
    }

    get showListMeta() {
        return this.recordCount > 1;
    }

    get recordCountMeta() {
        return this.nextPageToken ? this.recordCount + "+" : this.recordCount;
    }

    get relatedListTitleWithCount() {
        return this.relatedListTitle + " (" + this.recordCountMeta + ")";
    }
       
    handleClipWrap() {
        if (this.dataTableColumns) {
            let x = JSON.parse(JSON.stringify(this.dataTableColumns));
            this.wrapText = !this.wrapText;
            x.forEach((col) => {
                col.wrapText = this.wrapText;
            });
            this.dataTableColumns = x;
        }
    }

    handleRefreshList() {
        this.moveScrollbarToTop();
        this.showLoading2 = true;
        if (this.pageToken) {
            this.pageToken = null;
            this.currentPageToken = null;
            this.forceRefresh = true;
        } else {
            this.refreshData(this.wiredRelatedDataResult);
        }
    }

    moveScrollbarToTop() {
        try {
            this.template.querySelector("c-dmpl-datatable").customScrollToTop();
        } catch (error) {
            console.error(error);
        }
    }
    
    setClasses(id, fieldName, fieldValue) {
        this.relatedData = JSON.parse(JSON.stringify(this.relatedData));
        this.relatedData.forEach((detail) => {
            if (detail.Id === id) {
                detail[fieldName] = fieldValue;
            }
        });
    }
    
    resetPopups(markup, context) {
        let elementMarkup = this.privateChildren[markup];
        if (elementMarkup) {
            Object.values(elementMarkup).forEach((element) => {
                element.callbacks.reset(context);
            });
        }
    }

    handleCancel(event) {
        event.preventDefault();
        this.relatedData = JSON.parse(JSON.stringify(this.lastSavedRelatedData));
        this.handleClickOnWindow('reset');
        this.draftValues = [];
    }

    handleActionClick(event){
        let actionName = event.target.dataset.recordId;
        let x = {};
        x[this.lookupField] = this.recordId;
        const defaultValues = encodeDefaultFieldValues(x);
        try {
            this[NavigationMixin.Navigate]({
                type : 'standard__webPage',
                attributes: {
                    url: '/lightning/action/quick/'
                        + this.objectApiName
                        +'.'+  actionName + '?objectApiName&context=RECORD_DETAIL&recordId='
                        + this.recordId 
                        + '&backgroundContext=%2Flightning%2Fr%2F'
                        + this.objectApiName 
                        +'%2F'+ this.recordId+'%2Fview'
                },
            });
        } catch (error) {
            console.error(error);
        }
    }

    async handleUploadFinished(event) {
        event.stopPropagation();
        try {
            this.showLoading2 = true;
            let relatedRecord = event.detail.data.relatedRecord;
            const file = event.detail.data.files[0];
            var reader = new FileReader()
            reader.onload = () => {
                const {base64, filename, recordId} = {
                    'filename': file.name,
                    'base64': reader.result.split(',')[1],
                    'recordId': relatedRecord
                }
                uploadFile({ base64, filename, recordId }).then(result=>{
                    this.showSuccess('Success', `${filename} uploaded successfully!!`);
                    const valueFieldName = event.detail.data.valueFieldName;
                    this.updateFieldValue(relatedRecord, valueFieldName, result);        
                    this.showLoading2 = false;
                }).catch(error =>{
                    this.showLoading2 = false;
                    this.showError(error);
                });
            }
            reader.readAsDataURL(file)
        } catch (error) {
            this.showError(error);
        }
    }
    
    handleValueChange(event){
        event.stopPropagation();
        let dataRecieved = event.detail.data;
        let updatedItem = {
            Id: dataRecieved.relatedRecord
        };
        if(dataRecieved.valueFieldName){
            updatedItem[dataRecieved.valueFieldName] = dataRecieved.value;
        }
        this.setClasses(dataRecieved.relatedRecord, dataRecieved.fieldApiName + '_Class','slds-cell-edit slds-is-edited');
        this.updateDraftValues(updatedItem);
        this.updateDataValues(updatedItem);
    }
   
    handleToggle(event){
        event.stopPropagation();
        let dataRecieved = event.detail.value;
        let updatedItem = {
            Id: dataRecieved.rowId
        };
        if(dataRecieved.fieldApiName){
            updatedItem[dataRecieved.fieldApiName] = dataRecieved.state;
        }
        this.setClasses(dataRecieved.rowId, dataRecieved.fieldApiName + '_Class','slds-cell-edit slds-is-edited');
        this.updateDraftValues(updatedItem);
        this.updateDataValues(updatedItem);
    }

    handleEdit(event) {
        console.log('handleEdit dataRecieved:::',event.detail.data);
        event.preventDefault();
        let dataRecieved = event.detail.data;
        this.handleClickOnWindow(dataRecieved.relatedRecord);
        if (dataRecieved.valueFieldName) {
            this.setClasses(dataRecieved.relatedRecord, dataRecieved.fieldApiName + '_Class','slds-cell-edit');
        } else {
            this.setClasses(dataRecieved.relatedRecord, '', '');
        }
    }

    handleCellChange(event) {
        event.preventDefault();
        this.updateDraftValues(event.detail.draftValues[0]);
    }
    
    handleClickOnWindow(context) {
        this.resetPopups('c-datatable-picklist', context);
        this.resetPopups('c-datatable-fileupload', context);
    }

    updateDraftValues(updateItem) {   
        let draftValueChanged = false;
        let copyDraftValues = JSON.parse(JSON.stringify(this.draftValues));
        copyDraftValues.forEach((item) => {
            if (item.Id === updateItem.Id) {
                for (let field in updateItem) {
                    item[field] = updateItem[field];
                }
                draftValueChanged = true;
            }
        });
        if (draftValueChanged) {
            this.draftValues = [...copyDraftValues];
        } else {
            this.draftValues = [...copyDraftValues, updateItem];
        }
    }

    updateDataValues(updateItem) {    
        let copyData = JSON.parse(JSON.stringify(this.relatedData));
        copyData.forEach((item) => {
            if (item.Id === updateItem.Id) {
                for (let field in updateItem) {
                    item[field] = updateItem[field];
                }
            }
        });
        this.relatedData = [...copyData];
    }
    
    updateFieldValue(recordId, fieldName, fieldValue){
        const fields = {};
        fields['Id'] = recordId;
        fields[fieldName] = fieldValue;
        const recordInput = { fields };
        updateRecord(recordInput).then(async() => {
            notifyRecordUpdateAvailable([{recordId: recordId}]);
            await refreshApex(this.wiredRelatedDataResult);
        }).catch(error => {
            this.showError(error);
        });
    }

    async refreshData() {
        this.showLoading2 = true;
        this.forceRefresh = false;
        await refreshGraphQL(this.wiredRelatedDataResult);
        this.showLoading2 = false;
    }

    handleLoadMore(event) {
        event.preventDefault();
        if (this.nextPageToken) {
            this.dataTable = event.target;
            event.target.isLoading = true;
            this.loadMoreData();
            // event.target.isLoading = false;
        } else {
            event.target.enableInfiniteLoading = false;
        }
    }

    loadMoreData() {
        // comment the below line when infinite loading is enabled
        // this.showLoading1 = true;

        this.pageToken = this.nextPageToken;
    }

    navigateToNewRecordPage() {
        let x = {};
        x[this.lookupField] = this.recordId;
        const defaultValues = encodeDefaultFieldValues(x);
        try {
            this[NavigationMixin.Navigate]({
                type: "standard__objectPage",
                attributes: {
                    objectApiName: this.relatedObjectApiName,
                    actionName: "new"
                },
                state: {
                    nooverride: "1",
                    navigationLocation: "RELATED_LIST",
                    defaultFieldValues: defaultValues
                }
            });
        } catch (error) {
            console.error(error);
        }
    }

    handlePreview(event){
        this[NavigationMixin.Navigate]({ 
            type:'standard__namedPage',
            attributes:{ 
                pageName:'filePreview'
            },
            state:{ 
                selectedRecordId: event.detail.data.value
            }
        })
    }

    async handleSave(event) {
        const updatedFields = event.detail.draftValues;
    
        // Prepare the record IDs for notifyRecordUpdateAvailable()
        const notifyChangeIds = updatedFields.map(row => { return { "recordId": row.Id } });
    
        try {
            // Pass edited fields to the updateContacts Apex controller
            const result = await updateRelatedRecords({sObjectName: this.relatedObjectApiName,  data: updatedFields});
            console.log(JSON.stringify("Apex update result: "+ result));
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Records updated!',
                    variant: 'success'
                })
            );
    
            // Refresh LDS cache and wires
            notifyRecordUpdateAvailable(notifyChangeIds);
    
            // Display fresh data in the datatable
            await refreshApex(this.wiredRelatedDataResult);
            const filters = {
                recordApiName: this.objectApiName,
                recordApiId: this.recordId,
                state: '',
            };
            publish(this.messageContext, FORCEREFRESHMC, filters);
            // Clear all draft values in the datatable
            this.draftValues = [];
       } catch(error) {
               this.dispatchEvent(
                   new ShowToastEvent({
                       title: 'Error updating or refreshing records',
                       message: reduceErrors(error),
                       variant: 'error'
                   })
             );
        };
    }
    
    showSuccess(message, title){
        this.dispatchEvent(
            new ShowToastEvent({
                title: title ? title : 'Success',
                message: message ? message : 'Data updated',
                variant: 'success'
            })
        );
    }

    showError(error){
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error updating record',
                message: error?.body?.message,
                variant: 'error'
            })
        );
    }
}