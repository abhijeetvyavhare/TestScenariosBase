import { LightningElement, api, wire, track } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { getRecord } from "lightning/uiRecordApi";
import { getRelatedListRecords } from 'lightning/uiRelatedListApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { reduceErrors } from 'c/utils';
import { RefreshEvent } from 'lightning/refresh';
import { notifyRecordUpdateAvailable } from 'lightning/uiRecordApi';
import getBranches from '@salesforce/apex/BranchController.getBranches';
import getAllBranches from '@salesforce/apex/BranchController.getAllBranches';
import getStock from '@salesforce/apex/BranchController.getStock';
import createFulfilmentOrder from '@salesforce/apex/StockPanelController.createFulfilmentOrder';

const FIELD_BRANCHID = 'dmpl__BranchId__c';
const FIELD_PARTNER_ACCOUNTID = 'dmpl__PartnerAccountId__c';

export default class StockPanel extends LightningElement {
    @api title='View Stock';
    @api recordId;
    @api
    set objectApiName(value) {
        this._objectApiName = value;
        this.setObjectApiDefaults();
    }
    get objectApiName(){
        return this._objectApiName;
    }

    _objectApiName;
    partnerAccountId;
    branchId;
    locationList;
    dataColumns;
    relationListOptions = [];
    selectedRelationName;
    childObjectApiName;
    selectedBranchId;
    selectedItems=[];
    locationOptions=[
        { label: 'My Branch', value: 'mybranch' },
        { label: 'My Dealership', value: 'mydealership' },
        { label: 'All Dealers', value: 'alldealers' },
    ];
    locationValueSelected = 'mybranch';
    recordFields=[];
    fixedColumns =[
        { type: 'text', label: 'Location', fieldName: 'location', initialWidth: 150, minWidth: 100}];
    
    @wire(getRecord, { 
        recordId: '$recordId',  
        fields: '$recordFields'})
    wiredRecord({ error, data }) {
        if (data) {
            this.partnerAccountId = data.fields.dmpl__PartnerAccountId__c.value;
            this.branchId = data.fields.dmpl__BranchId__c.value;
            this.dataColumns = this.fixedColumns.slice();
            this.setLocationList();
            this.setStock();
        }
        else if(error){
            console.log(error);
        }
    }
    
    @wire(getRelatedListRecords, {
        parentRecordId: '$recordId',
        relatedListId: '$selectedRelationName',
        pageSize: 30,
        fields: '$getRelationFields'
    })listInfo({ error, data }) {
        if (data) {
            this.recordData = JSON.parse(JSON.stringify(data));
            this.selectedItems = data.records.map(v=>
                v.fields.dmpl__ItemId__c?.value);
            this.setStock();
            this.setColumns();
        } else if (error) {
            this.error = JSON.parse(JSON.stringify(error)); 
        }
    }

    @wire(getObjectInfo, { objectApiName: '$objectApiName' })
    sourceObjectInfo({ error, data }) {
        if (data) {
            this.relationListOptions = data.childRelationships?.map(r=>{
                return { 
                    label: r.relationshipName, 
                    value: r.relationshipName, 
                    childObjectApiName : r.childObjectApiName,
                    childFieldName : r.fieldName, }
            })
        }
        if (error) {
            console.log('Field Error', error);
        }
    }

    @wire(getBranches, { partnerAccountId: '$partnerAccountId'})
    myBranches;
    
    @wire(getAllBranches) 
    allBranches;

    get getStockTransferVisible(){
        return false;
        // return this.locationValueSelected == 'mydealership'
        //     && (this.objectApiName == 'dmpl__SaleOrder__c'
        //         || this.objectApiName == 'dmpl__PurchaseRequisition__c');
    }

    get getFulfilmentVisible(){
        return false;
        // return this.locationValueSelected == 'mybranch' 
        //     && (!this.selectedOutOfStock)
        //     && this.objectApiName == 'dmpl__SaleOrder__c';
    }
    
    get getPOVisible(){
        return false;
        // return this.locationValueSelected == 'alldealers'
        //     && (this.objectApiName == 'dmpl__SaleOrder__c'
        //         || this.objectApiName == 'dmpl__PurchaseRequisition__c');
    }
    
    get getRelationListHidden(){
        return this.selectedRelationName;
    }

    get isBranchNull(){
        return !this.selectedBranchId;
    }

    get getRelationFields(){
        this.childObjectApiName = this.relationListOptions?.find(v=>
            v.value == this.selectedRelationName)?.childObjectApiName;
        if(!this.childObjectApiName){
            return [];
        }
        return [this.childObjectApiName + '.dmpl__ItemId__c',
            this.childObjectApiName + '.dmpl__ItemId__r.Name',
            this.childObjectApiName + '.dmpl__Quantity__c'];
    }

    setObjectApiDefaults(){
        this.recordFields.push(this.objectApiName.concat('.', FIELD_PARTNER_ACCOUNTID));
        this.recordFields.push(this.objectApiName.concat('.', FIELD_BRANCHID));
        this.recordFields = this.recordFields.slice();

        this.selectedRelationName = this.objectApiName == 'dmpl__SaleOrder__c' 
            ? 'dmpl__SaleOrderLines__r' : this.objectApiName == 'dmpl__PurchaseRequisition__c' 
            ? 'dmpl__PurchaseRequisitionLines__r' : this.objectApiName == 'dmpl__PurchaseOrder__c'
            ? 'dmpl__PurchaseOrderLines__r' : this.objectApiName == 'dmpl__ServiceRequest__c'
            ? 'dmpl__ServiceAppointmentLines__r' : this.objectApiName == 'dmpl__SaleInvoice__c'
            ? 'dmpl__SaleInvoiceLines__r' : this.objectApiName == 'dmpl__DeliveryOrder__c'
            ? 'dmpl__DeliveryOrderLines__r' : this.objectApiName == 'dmpl__RepairOrder__c'
            ? 'dmpl__RepairOrderLines__r' : this.objectApiName == 'dmpl__InventoryFulfillment__c'
            ? 'dmpl__FulfillmentOrderLines__r' : undefined;
    }

    setColumns(){
        if(!this.recordData){
            return;
        }
        let columns = this.recordData.records.map(v=> {
            return { 
                type: 'text', 
                label: v.fields.dmpl__ItemId__r?.displayValue, 
                fieldName: v.fields.dmpl__ItemId__c?.value,
                hideDefaultActions: true,
                initialWidth: 100,
                minWidth: 100
            }
        });

        if(this.selectedOutOfStock){
            columns = columns.filter(v=> this.isOutOfStock(v));
        }
        
        if(this.filteredItems && this.filteredItems.length>0){
            columns = columns.filter(v=> 
                this.filteredItems.includes(v.fieldName));
        }

        if(this.locationValueSelected == 'mydealership'
            || this.locationValueSelected == 'alldealers'){
                // columns = [{ 
                //     label: 'Release?', 
                //     fieldName: 'isSelected', 
                //     type: 'toggleButton', 
                //     initialWidth: 75, 
                //     hideLabel: true, 
                //     hideDefaultActions: true, 
                //     typeAttributes: { rowId: { fieldName: 'id' } } }].concat(columns);
        }

        if(this.filteredItems && this.filteredItems.length>0){
            this.dataColumns = this.fixedColumns.concat(
                columns.filter(v=>
                    this.filteredItems.includes(v.fieldName)));
        }else{
            this.dataColumns = this.fixedColumns.concat(columns);
        }
    }

    isOutOfStock(column){
        if(!this.recordData){
            return true;
        }
        let quantity = this.recordData.records.find(r=>
            r.fields.dmpl__ItemId__c?.value == column.fieldName)?.fields.dmpl__Quantity__c?.value;
        return (!quantity) ||
            this.locationList.find(v=>
                v.branchId == this.branchId 
                && (!v[column.fieldName]
                    || v[column.fieldName] < quantity));
    }

    setStock(){
        if(!this.locationList){
            return;
        }
        getStock({
            itemIds: this.selectedItems,
            branchIds: this.selectedBranchIds
        }).then(result => {
            if(result && result.length>0){
                this.locationList = this.locationList.filter(v=> result.find(s=> s.dmpl__BranchId__c == v.id));
            }
            this.locationList = this.locationList.map(v=>{
                let r = Object.assign({}, v);
                for(var s of result.filter(s=> s.dmpl__BranchId__c == v.id)){
                    if(s.dmpl__ItemId__r?.Name){
                        r[s.dmpl__ItemId__c] = s.dmpl__QuantityAvailable__c + ' (' + s.dmpl__QuantityInHand__c + ')';
                        r[s.dmpl__ItemId__c + 'd'] = s.dmpl__QuantityAvailable__c;
                    }
                };
                return r;
            }).slice();
        }).catch(error => {
            this.showError(error);
        });
    }

    setLocationList(){
        if(!this.locationValueSelected){
            return;
        }
        let locations = [];
        if(this.locationValueSelected == 'mybranch'){
            locations.push({ 
                id : this.branchId,
                branchId: this.branchId,
                location: 'My Branch' });
        }
        if(this.locationValueSelected == 'mydealership'){
            if (this.myBranches?.data) {
                let data = this.myBranches.data.filter(v=>v.Id != this.branchId);
                locations = locations.concat(data.map(v=>{
                    return {
                        id : v.Id,
                        branchId: v.Id, 
                        partnerAccountId: v.dmpl__PartnerAccountId__c,
                        location: v.Name
                    }
                }));
            }
        }
        if(this.locationValueSelected == 'alldealers'){
            if (this.allBranches?.data) {
                let data = this.allBranches.data.filter(v=>v.dmpl__PartnerAccountId__c != this.partnerAccountId);
                locations = locations.concat(data.map(v=>{
                    return {
                        id : v.Id,
                        branchId: v.Id, 
                        partnerAccountId: v.dmpl__PartnerAccountId__c,
                        location: v.Name
                    }
                }));
            }
        }
        this.locationList = locations.slice();
        this.selectedBranchIds = locations.map(v=> v.branchId);
    }

    handleSelectedRec(event) {
        let locationList = this.locationList.slice();
        let row = locationList.find(v => v.id == event?.detail?.value?.rowId);
        if (row && event?.detail?.value?.state == true) {
            row.isSelected = true;
            this.selectedBranchId = row.branchId;
            this.partnerAccountId = row.partnerAccountId;
        } else {
            this.selectedBranchId = undefined;
            this.partnerAccountId = undefined;
            row.isSelected = false;
        }
        
        locationList.filter(v=>v.id != row.id).forEach(v=>{
            v.isSelected = false;
        });
        this.locationList = locationList;
    }

    handleLocationOptionChange(event){
        this.locationValueSelected = event.detail.value;
        this.setColumns();
        this.setLocationList();
        this.setStock();
    }
    
    handleRelationNameChange(event){
        this.selectedRelationName = event.detail.value;
    }

    handleDialogClose(event){
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    handleCreateTR(event){

    }

    handleCreatePO(event){

    }

    async handleCreateFF(event){
        try {
            this.handleSaveResult(await createFulfilmentOrder({
                objectApiName: this.objectApiName,
                hostId: this.recordId
            }));
        } catch (error) {
            this.showError(error);
        }
    }
    
    handleSaveResult(result){
        if (result?.status == 'success') {
            this.createRelatedResult = result;
            this.createRelatedResult.heading = `${this.createRelatedResult.documentLabel} created!`
            this.createRelatedResult.subHeading = `${this.createRelatedResult.documentLabel} created successfully. Click here to navigate to the created document.`
            var messsage = `${this.createRelatedResult.documentLabel} created successfully.`;
            notifyRecordUpdateAvailable([{ "recordId": this.recordId }, { "recordId": result.documentId }]);
            this.refreshStdComponents();
            this.dispatchEvent(new CustomEvent('recordsaved', { "detail": this.createRelatedResult }));
            this.showMessage(messsage);
            this.handleDialogClose();
        } else {
            this.showError(result?.error);
        }
    }

    refreshStdComponents(){
        try{
            eval("$A.get('e.force:refreshView').fire();");
        }catch(e){
            this.dispatchEvent(new RefreshEvent());
        }
    }

    async handleSearch(event){
        this.filteredItems = undefined;
        let keyWord = event.target.value;
        if(keyWord){
            keyWord = keyWord.toUpperCase();
            this.filteredItems = this.recordData.records.filter(v=> v.fields.dmpl__ItemId__r?.displayValue.toUpperCase().includes(keyWord)).map(v=> {
                return v.fields.dmpl__ItemId__c?.value
            });
        }
        this.setColumns();
    }

    handleOutOfStockChange(event){
        this.selectedOutOfStock = event.detail.checked; 
        this.setColumns();
    }

    showError(error) {
        console.log('error ', error);
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error',
                message: reduceErrors(error),
                variant: 'error',
                mode: 'sticky'
            })
        );
    }

    showWarning(message) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Warning!',
                message: message,
                variant: 'warning'
            }),
        );
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
}