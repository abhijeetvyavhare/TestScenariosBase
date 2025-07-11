import { LightningElement, track, api, wire } from "lwc";
import { NavigationMixin } from 'lightning/navigation';
import { notifyRecordUpdateAvailable } from 'lightning/uiRecordApi';
import { RefreshEvent } from 'lightning/refresh';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import { getRecord } from "lightning/uiRecordApi";
import { reduceErrors } from 'c/utils';
import {publish, MessageContext} from 'lightning/messageService';
import FORCEREFRESHMC from '@salesforce/messageChannel/ForceReset__c';
import getOpenPayments from '@salesforce/apex/PaymentAdjustmentController.getOpenPayments';
import postAdjustments from '@salesforce/apex/PaymentAdjustmentController.postAdjustments';
import extractColumns from '@salesforce/apex/PaymentAdjustmentController.extractColumns';

const FIELD_BRANCHID = 'dmpl__BranchId__c';
const FIELD_PARTNER_ACCOUNTID = 'dmpl__PartnerAccountId__c';
const FIELD_ACCOUNTID = 'dmpl__AccountId__c';
const FIELD_SUPPLIERID = 'dmpl__SupplierAccountId__c';
const DELAY = 500;


export default class AdjustmentPanel extends NavigationMixin(LightningElement) {
  @api title = 'Adjustments';
  @api recordId;

  @api
  get objectApiName() {
      return this._objectApiName;
  }
  set objectApiName(value) {
    console.log(value + ' object api name')
      this._objectApiName = value;
      this.setAttribute('objectApiName', this._objectApiName);
      this.recordFields= [this.objectApiName.concat('.', FIELD_PARTNER_ACCOUNTID),
        this.objectApiName.concat('.', FIELD_BRANCHID),
        this.objectApiName.concat('.', this.getAccountFieldName),
        this.objectApiName.concat('.', this.getOpenAmountFieldName)
    ].concat(this._objectApiName == 'dmpl__Payment__c' ? [this.objectApiName.concat('.', 'dmpl__PaymentType__c')] : []);
  }

  isColumnsInitialized = false;
  _objectApiName;
  recordFields;
  openAmount =0;
  adjustedAmount=0;
  documentAmount=0;
  adjustmentData = [];
  getPartnerAccountId;
  getBranchId;
  getAccountId
  adjustmentColumns =[
    { label: 'Document', fieldName: 'Name', hideDefaultActions: true },
    { label: 'Date', fieldName: 'documentDate', hideDefaultActions: true },
    { label: 'Document Amount', fieldName: 'totalAmount', hideDefaultActions: true, type: 'currency' },
    { label: 'Open Amount', fieldName: 'openAmount', hideDefaultActions: true, type: 'currency' }
    ];
  dynamicFields = []
  
  @wire(extractColumns)
  function({ error, data }) {
      if (data) {
        data.forEach(f=>{
          console.log(this.adjustmentColumns + ' 101');
          let tmp = {label : f[1].toString(), fieldName : f[0].toString(), type : f[2].toString(),hideDefaultActions: true};
          this.adjustmentColumns = this.adjustmentColumns.concat([tmp]);
          this.dynamicFields.push(f[0].toString());
          console.log(JSON.stringify(this.adjustmentColumns) + ' 11');
        })
      
       
      } else {
      }
    if (!this.isColumnsInitialized) {
      setTimeout(() => {
        this.adjustmentColumns = this.adjustmentColumns.concat([
          {
            label: 'Adjust?',
            fieldName: 'isSelected',
            type: 'toggleButton',
            initialWidth: 75,
            hideLabel: true,
            hideDefaultActions: true,
            typeAttributes: { rowId: { fieldName: 'Id' } }
          }
        ]);
        this.adjustmentColumns = this.adjustmentColumns.concat([
          {
            label: 'Amount',
            fieldName: 'amountToAdjust',
            type: 'currency',
            hideDefaultActions: true,
            editable: true,
            cellAttributes: { class: 'slds-theme_shade' }
          }
        ]);
      }, 1000);
        this.isColumnsInitialized = true;
    }

      
  }

  @wire(MessageContext)
  messageContext;

  @wire(getRecord, { 
    recordId: '$recordId',  
    fields: '$recordFields'})
  wiredRecord({ error, data }) {
      if (data) {
        console.log(JSON.stringify(data) + ' records')
          if(this.objectApiName == 'dmpl__Payment__c'){
            this.dmpl__PaymentType__c = data.fields.dmpl__PaymentType__c?.value;
          }
          this.getPartnerAccountId = data.fields.dmpl__PartnerAccountId__c.value;
          this.getBranchId = data.fields.dmpl__BranchId__c.value;
          this.getAccountId = data.fields[this.getAccountFieldName].value;
          this.loadOpenDocuments();
          this.documentAmount = data.fields[this.getOpenAmountFieldName].value;
          this.summariseAdjustedAmount();
      }
  }

  get getAccountFieldName(){
    if(this.objectApiName == 'dmpl__PurchaseOrder__c' || this.objectApiName == 'dmpl__Bill__c'){
      return FIELD_SUPPLIERID;
    }else {
      return FIELD_ACCOUNTID;
    }
  }
  
  get getOpenAmountFieldName(){
    if(this.objectApiName == 'dmpl__Payment__c'){
      return 'dmpl__OpenAmount2__c';
    }else {
      return 'dmpl__OpenAmount__c';
    }
  }

  get getPaymentType(){
    if(this.objectApiName == 'dmpl__Payment__c'){
        return this.dmpl__PaymentType__c;
    }else{
        return this.objectApiName == 'dmpl__SaleOrder__c' 
        ||  this.objectApiName == 'dmpl__SaleInvoice__c' 
        ||  this.objectApiName == 'dmpl__RepairOrder__c' 
        ||  this.objectApiName == 'dmpl__DebitNote__c' ? 'PaymentGiven' : 'PaymentTaken';  
    }
  }

  handleSave(event){
    this.isLoading = false;
    var selectedRecords = this.adjustmentData.filter(v => v.isSelected && v.amountToAdjust >0).map(v => {
        return {
            documenApiName : this.objectApiName,
            documentId: this.recordId,
            adjustedDocumentApiName : v.documentApiName,
            adjustedDocumentId: v.documentId,
            adjustedAmount: v.amountToAdjust
        }
    });

    if(selectedRecords.length >0){
        postAdjustments({ 
            documents: selectedRecords
        }).then(response => {
            this.showMessage('Successfully saved adjustments!');
        }).catch(error => {
            this.showError(error);
        })
        notifyRecordUpdateAvailable([{ "recordId": this.recordId }]);
        this.refreshStdComponents();
        publish(this.messageContext, FORCEREFRESHMC, {});
    }
    this.handleClose();
  }
  
  refreshStdComponents(){
      try{
          eval("$A.get('e.force:refreshView').fire();");
      }catch(e){
          this.dispatchEvent(new RefreshEvent());
      }
  }

  handleError(error){
    this.isLoading = false;
    this.showError(error);
  }

  handleSearch(event) {
    console.log(event + ' handle search')
      window.clearTimeout(this.delayTimeout);
      const searchKey = event.target.value;
      this.delayTimeout = setTimeout(() => {
          this.searchKey = searchKey;
          this.loadOpenDocuments();
      }, DELAY);
  }

  loadOpenDocuments(){
    getOpenPayments({ 
        paymentType: this.getPaymentType,
        partnerAccountId: this.getPartnerAccountId,
        branchId: this.getBranchId, 
        accountId: this.getAccountId,
        searchKey: this.searchKey,
        onlyPayments: this.objectApiName != 'dmpl__Payment__c'
      }).then(response => {
          let adjustmens = [];
          console.log(JSON.stringify(response) + 'open payment documents')
          if(response){
            for(let key in response){
                if(response[key]){
                  adjustmens = adjustmens.concat(Array.from(response[key]).map(r=>{
                      let newRow = Object.assign({}, r);
                      newRow.documentDate = r.dmpl__DocumentDate__c ? r.dmpl__DocumentDate__c : r.dmpl__PaymentDate__c;
                      newRow.AdjustedAmount = r.dmpl__AdjustedAmount__c ? r.dmpl__AdjustedAmount__c : r.dmpl__AdvanceAmount__c ? r.dmpl__AdvanceAmount__c : r.dmpl__AdjustedAdvanceAmount__c;
                      newRow.totalAmount = r.dmpl__TotalAmount__c ? r.dmpl__TotalAmount__c : r.dmpl__TotalOrderAmount__c ? r.dmpl__TotalOrderAmount__c : r.dmpl__Amount__c;
                      newRow.newAccountId = r.dmpl__AccountId__c ? r.dmpl__AccountId__c : r.dmpl__SupplierAccountId__c;
                      newRow.amountToAdjust = undefined;
                      newRow.documentApiName = key;
                      newRow.openAmount = r.hasOwnProperty('dmpl__OpenAmount2__c') ? r.dmpl__OpenAmount2__c : r.hasOwnProperty('dmpl__OpenAmount__c') ? r.dmpl__OpenAmount__c : r.dmpl__OpenAdvanceAmount__c;
                      newRow.documentId = r.Id;
                      newRow.isSelected = this.invokedFromObjectId == r.Id;
                      this.dynamicFields.forEach(f=>{
                        newRow[f] = r[f]
                      });
                      return newRow;
                  }));
                }
            };
            console.log(adjustmens + ' ghhj');
          }
          this.adjustmentData = adjustmens;
      }).catch(error => {
          this.showError(error);
      })
  }

  handleCellChange(event) {
    event.detail.draftValues.forEach((row) => {
        let sourceRow = this.adjustmentData.find(v => v.Id == row.Id);
        if (sourceRow) {
            if (row.amountToAdjust > sourceRow.openAmount) {
                row.amountToAdjust = sourceRow.openAmount;
                this.showWarning('Amount to Adjust can not be in excess of Document Amount!');
            }
            if(row.amountToAdjust > this.openAmount){
              sourceRow.amountToAdjust = this.openAmount;
              this.showWarning('Amount to Adjust can not be in excess of Open Amount!');
            }else{
              sourceRow.amountToAdjust = parseFloat(row.amountToAdjust);
            }
            sourceRow.isSelected = row.amountToAdjust > 0;
        }
    });
    this.draftValues = [];
    event.detail.draftValues = [];
    this.adjustmentData = this.adjustmentData.slice();
    this.summariseAdjustedAmount();
}

  handleSelectedRec(event) {
      let row = this.adjustmentData.find(v => v.Id == event?.detail?.value?.rowId);
      if (row && event?.detail?.value?.state == true) {
          if(this.openAmount <=0){
            this.showWarning('All available Document Amount has been adjusted!');
            row.amountToAdjust = 0;
          }else if(row.openAmount> this.openAmount){
            row.amountToAdjust = this.openAmount;  
          }else{
            row.amountToAdjust = row.openAmount;
          }
          row.isSelected = true;
      } else {
          row.isSelected = false;
          row.amountToAdjust = undefined;
      }
      this.adjustmentData = this.adjustmentData.slice();
      this.summariseAdjustedAmount();
  }

  summariseAdjustedAmount(){
    this.adjustedAmount = this.adjustmentData.filter(v=>v.isSelected).map(v=>v.amountToAdjust).reduce((a, b) => a + b, 0);
    this.openAmount = this.documentAmount - this.adjustedAmount;
  }

  handleClose(){
    this.dispatchEvent(new CloseActionScreenEvent());
    const detail = {
        Id: this.recordId
    };
    this.dispatchEvent(new CustomEvent('closeclicked', { "detail": detail }));
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