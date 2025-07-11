import { LightningElement, track, api, wire } from "lwc";
import { NavigationMixin } from 'lightning/navigation';
import { notifyRecordUpdateAvailable } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import { CurrentPageReference } from 'lightning/navigation';
import { reduceErrors } from 'c/utils';
import { publish, MessageContext } from 'lightning/messageService';
import getUserDefaults from '@salesforce/apex/RecordFormController.getUserDefaults';
import getOpenDocuments from '@salesforce/apex/PaymentAdjustmentController.getOpenDocuments';
import postAdjustments from '@salesforce/apex/PaymentAdjustmentController.postAdjustments';
import getFieldsetInfo from '@salesforce/apex/PaymentAdjustmentController.getFieldsetInfo';
import FORCEREFRESHMC from '@salesforce/messageChannel/ForceReset__c';

const FIELD_BRANCHID = 'dmpl__BranchId__c';
const FIELD_PARTNER_ACCOUNTID = 'dmpl__PartnerAccountId__c';
const FIELD_ACCOUNTID = 'dmpl__AccountId__c';
const FIELD_RESOURCEID = 'dmpl__ResourceId__c';
const FIELD_SALEEXECUTIVEID = 'dmpl__SalesExecutiveId__c';
const DELAY = 500;

export default class PaymentForm extends NavigationMixin(LightningElement) {
  @api title = 'Payment';
  @api objectApiName;
  @api recordId;

  @track isHiddenTab1 = false;
  @track isHiddenTab2 = true;
  @track isLoading;
  @track requiredFields = {};
  @track fieldsetFields = [];
  openAmount =0;
  adjustedAmount=0;
  documentAmount=0;
  adjustmentData = [];
  selectedPaymentOption;
  privateDefaultFieldValues;
  invokedFromObjectId;
  currentPageReference = null;
  urlStateParameters = null;
  adjustmentColumns =[
    { label: 'Document', fieldName: 'documentUrl', hideDefaultActions: true, type: "url", typeAttributes: {
      label: { fieldName: 'Name' }}
    },
    { label: 'Date', fieldName: 'documentDate', hideDefaultActions: true },
    { label: 'Document Amount', fieldName: 'totalAmount', hideDefaultActions: true, type: 'currency' },
    { label: 'Open Amount', fieldName: 'openAmount', hideDefaultActions: true, type: 'currency' },
    { label: 'Adjust?', fieldName: 'isSelected', type: 'toggleButton', initialWidth: 75, hideLabel: true, hideDefaultActions: true, typeAttributes: { rowId: { fieldName: 'Id' } } },
    { label: 'Amount', fieldName: 'amountToAdjust', type: 'currency', hideDefaultActions: true, editable: true, cellAttributes: { class: 'slds-theme_shade' } }
  ];
  

  get elementClassTab1() {
    return this.isHiddenTab1 ? 'slds-tabs_default__content slds-hide' : '';
  }
  get elementClassTab2() {
    return this.isHiddenTab2 ? 'slds-tabs_default__content slds-hide' : '';
  }

  toggleVisibilityTab1() {
    this.isHiddenTab1 = false;
    this.isHiddenTab2 = true;
  }

  toggleVisibilityTab2() {
    this.isHiddenTab1 = true;
    this.isHiddenTab2 = false;
  }

  @api
  get defaultFieldValues() {
      return this.privateDefaultFieldValues;
  }
  set defaultFieldValues(value) {
      this.privateDefaultFieldValues = value;
      this.setAttribute('defaultFieldValues', this.privateDefaultFieldValues);
      this.populateDefaultValues();
  }

  @wire(CurrentPageReference)
  getStateParameters(currentPageReference) {
      if (currentPageReference && !this.recordId) {
          if(currentPageReference.state?.defaultFieldValues){
            this.urlStateParameters = currentPageReference.state?.defaultFieldValues;
          }
      }
  }

  @wire(getFieldsetInfo)
  requiredFieldsValidation({ error, data }){
      if(data){
        data.forEach(item=>{
          console.log(item.required + ' hello',JSON.stringify(item))
          this.fieldsetFields.push(item);
          this.setFieldIsRequired(item.apiName,item.required)
        })
      }else{
         console.log(error);
      }
  }

  @wire(getUserDefaults, {})
  userDefaults;

  @wire(MessageContext)
  messageContext;
  
  get isCashSelected(){ 
    return this.selectedPaymentOption == 'Cash'
  }

  get isChequeSelected(){ 
    return this.selectedPaymentOption == 'Cheque'
  }

  get isETSelected(){ 
    return this.selectedPaymentOption == 'Electronic Transfer'
  }

  get isCardSelected(){ 
    return this.selectedPaymentOption == 'Card'
  }

  get isOnlineSelected(){ 
    return this.selectedPaymentOption == 'Online'
  }

  setFieldValue(name, value) {
    const inputFields = Array.from(this.template.querySelectorAll(
        'lightning-input-field'
    ));
    let field = inputFields && inputFields.find(v=>v.fieldName == name);
    if(field && field.value != value){
        field.value = value;
    }
  }

  setFieldIsRequired(name , isRequired){
    const inputFields = Array.from(this.template.querySelectorAll(
      'lightning-input-field'
    ));
    let field = inputFields && inputFields.find(v=>v.fieldName == name);
    if(field && isRequired && field.required != isRequired){
      field.required = isRequired
    }
  }

  getFieldValue(name) {
    const inputFields = Array.from(this.template.querySelectorAll(
        'lightning-input-field'
    ));
    return inputFields && inputFields.find(f => f.fieldName == name)?.value;
  }

  connectedCallback(){
    this.isLoading = false;
    this.selectedPaymentOption = 'Cash';
  }

  populateDefaultValues() {
    if (!this.privateDefaultFieldValues) {
        return;
    }
    this.privateDefaultFieldValues.split(',').forEach(p => {
        if (p) {
            const nvPair = p.split("|");
            if (nvPair.length == 2) {
                this.setFieldValue(nvPair[0], nvPair[1]);
            }
        }
    });
  }

  populateUrlValues(urlValues) {
    if (!urlValues) {
        return;
    }
    urlValues.split(',').forEach(p => {
        if (p) {
            const nvPair = p.split("=");
            if (nvPair.length == 2) {
                this.setFieldValue(nvPair[0], nvPair[1]=='undefined'?null:nvPair[1]);
            }
        }
    });
  }

  setAdjustmentStatus(){
    this.invokedFromObjectId = this.getFieldValue('dmpl__SaleOrderId__c')?
      this.getFieldValue('dmpl__SaleOrderId__c') : this.getFieldValue('dmpl__SaleInvoiceId__c') ?
      this.getFieldValue('dmpl__SaleInvoiceId__c') : this.getFieldValue('dmpl__PrchaseOrderId__c') ?
      this.getFieldValue('dmpl__PrchaseOrderId__c') : this.getFieldValue('dmpl__BillId__c') ?
      this.getFieldValue('dmpl__BillId__c') : this.getFieldValue('dmpl__RepairOrderId__c') ?
      this.getFieldValue('dmpl__RepairOrderId__c') : this.getFieldValue('dmpl__CreditNoteId__c') ?
      this.getFieldValue('dmpl__CreditNoteId__c') : this.getFieldValue('dmpl__DebitNoteId__c') ?
      this.getFieldValue('dmpl__DebitNoteId__c') : undefined;
  }

  populateHardCodedDefaultValues() {
    if (this.userDefaults && this.userDefaults.data) {
        if (this.userDefaults.data.dmpl__DefaultBranchId__c && !this.getFieldValue(FIELD_BRANCHID)) {
            this.setFieldValue(FIELD_BRANCHID, this.userDefaults.data.dmpl__DefaultBranchId__c);
        }
        if (this.userDefaults.data.dmpl__DefaultPartnerAccountId__c && !this.getFieldValue(FIELD_PARTNER_ACCOUNTID)) {
            this.setFieldValue(FIELD_PARTNER_ACCOUNTID, this.userDefaults.data.dmpl__DefaultPartnerAccountId__c);
        }
        if (this.userDefaults.data.Id) {
            this.setFieldValue(FIELD_RESOURCEID, this.userDefaults.data.Id);
        }
        if (this.userDefaults.data.Id) {
            this.setFieldValue(FIELD_SALEEXECUTIVEID, this.userDefaults.data.Id);
        }
    }
  }

  handleSuccess(event){
    this.recordId = event.detail ? event.detail.id : undefined;
    var selectedRecords = this.adjustmentData.filter(v => v.isSelected && v.amountToAdjust >0).map(v => {
        return {
            documenApiName : 'dmpl__Payment__c',
            documentId: this.recordId,
            adjustedDocumentApiName : v.documentApiName,
            adjustedDocumentId: v.documentId,
            adjustedAmount: v.amountToAdjust
        }
    });

    postAdjustments({ 
        documents: selectedRecords
    }).then(response => {
    }).catch(error => {
        this.showError('Failed to save the Adjustment Information. ' + error);
    })

    let documentName = this.getFieldValue('Name');
    var messsage = this.recordId 
      ? `Document ${documentName ? documentName : ''} created successfully.` 
      : 'Record created successfully.';
    this.showMessage(messsage);
    if(this.invokedFromObjectId){
      notifyRecordUpdateAvailable([{ "recordId": this.invokedFromObjectId }]);
    }
    this.isLoading = false;
    this.handleClose();
  }

  fireForceRefreshEvent() {
    const filters = {
        recordApiName: this.objectApiName,
        recordApiId: this.recordId,
        state: '',
    };
    publish(this.messageContext, FORCEREFRESHMC, filters);
  }

  handleLoad(){
    this.isLoading = false;
    if(!this.recordId){
      if(!this.getFieldValue('dmpl__PaymentType__c')){
        this.setFieldValue('dmpl__PaymentType__c', 'PaymentTaken');
      }
      this.selectedPaymentOption = this.getFieldValue('dmpl__PaymentMode__c');
      this.populateHardCodedDefaultValues(true);  
      if(this.urlStateParameters){
        this.populateUrlValues(this.urlStateParameters);
        this.setAdjustmentStatus();
      }
    }
    this.handleAccountChange();
  }

  handleError(error){
    this.isLoading = false;
    this.showError(error);
  }

  handleAmountChange(){
      let oldAmount = this.documentAmount ? this.documentAmount : 0;
      this.documentAmount = this.getFieldValue('dmpl__Amount__c');
      let availableAmount = this.documentAmount - oldAmount;
      if(Math.abs(availableAmount) <= Math.abs(this.openAmount)){
          availableAmount = 0;
      }else if(this.openAmount > 0){
          availableAmount += this.openAmount;
      }
      this.adjustmentData = this.adjustmentData.map(v => {
        if(v.isSelected){
          if(!v.amountToAdjust){
            v.amountToAdjust = 0;
          }
          if(availableAmount < 0){
                if(v.amountToAdjust >= Math.abs(availableAmount)){
                    v.amountToAdjust += availableAmount;
                    availableAmount = 0;
                }else{
                    availableAmount += v.amountToAdjust;
                    v.amountToAdjust = 0;
                }
          }else{
              if(v.openAmount - v.amountToAdjust >= availableAmount){
                  v.amountToAdjust += availableAmount;
                  availableAmount = 0;
              }else{
                  let adjustableAmont = v.openAmount - v.amountToAdjust;
                  v.amountToAdjust += adjustableAmont;
                  availableAmount -= adjustableAmont;
              }
          }   
        }
        return v;
      }).slice();
      this.summariseAdjustedAmount();
  }

  handleAccountChange(){
    if(this.lastPaymentType == this.getFieldValue('dmpl__PaymentType__c') 
      && ((!this.getFieldValue('dmpl__PartnerAccountId__c')) || this.lastPartnerAccountId == this.getFieldValue('dmpl__PartnerAccountId__c'))
      && ((!this.getFieldValue('dmpl__BranchId__c')) || this.lastBranchId == this.getFieldValue('dmpl__BranchId__c'))
      && ((!this.getFieldValue('dmpl__AccountId__c')) || this.lastAccountId == this.getFieldValue('dmpl__AccountId__c'))
      && this.searchKey == this.lastSearchKey){
        return;
      }
    getOpenDocuments({ 
        paymentType: this.getFieldValue('dmpl__PaymentType__c'),
        partnerAccountId: this.getFieldValue('dmpl__PartnerAccountId__c'),
        branchId: this.getFieldValue('dmpl__BranchId__c'), 
        accountId: this.getFieldValue('dmpl__AccountId__c'),
        searchKey: this.searchKey
      }).then(response => {
          let adjustmens = [];
          if(response){
            for(let key in response){
                if(key != this.objectApiName && response[key]){
                  adjustmens = adjustmens.concat(Array.from(response[key]).map(r=>{
                      let newRow = Object.assign({}, r);
                      newRow.documentDate = r.dmpl__DocumentDate__c ? 
                        r.dmpl__DocumentDate__c : r.dmpl__PaymentDate__c;
                      newRow.AdjustedAmount = r.dmpl__AdjustedAmount__c ? r.dmpl__AdjustedAmount__c : r.dmpl__AdvanceAmount__c;
                      newRow.totalAmount = r.dmpl__TotalAmount__c ? 
                        r.dmpl__TotalAmount__c : r.dmpl__TotalOrderAmount__c ? 
                        r.dmpl__TotalOrderAmount__c : r.dmpl__Amount__c;
                      newRow.newAccountId = r.dmpl__AccountId__c ? r.dmpl__AccountId__c : r.dmpl__SupplierAccountId__c;
                      newRow.amountToAdjust = undefined;
                      newRow.documentApiName = key;
                      newRow.documentId = r.Id;
                      newRow.documentUrl = '/' + r.Id;
                      newRow.openAmount = r.dmpl__OpenAmount2__c ? r.dmpl__OpenAmount2__c : r.dmpl__OpenAmount__c;
                      newRow.isSelected = this.invokedFromObjectId == r.Id; 
                      return newRow;
                  }));
                }
            };
          }
          this.adjustmentData = adjustmens;
          this.lastPaymentType = this.getFieldValue('dmpl__PaymentType__c');
          this.lastPartnerAccountId = this.getFieldValue('dmpl__PartnerAccountId__c');
          this.lastBranchId = this.getFieldValue('dmpl__BranchId__c');
          this.lastAccountId = this.getFieldValue('dmpl__AccountId__c');
          this.lastSearchKey = this.searchKey;
      }).catch(error => {
          this.showError(error);
      })
  }

  handleCellChange(event) {
    event.detail.draftValues.forEach((row) => {
        let sourceRow = this.adjustmentData.find(v => v.Id == row.Id);
        if (sourceRow) {
            if (row.amountToAdjust > sourceRow.openAmount) {
                row.amountToAdjust = sourceRow.openAmount
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

  handleSearch(event) {
      window.clearTimeout(this.delayTimeout);
      const searchKey = event.target.value;
      this.delayTimeout = setTimeout(() => {
          this.searchKey = searchKey;
          this.handleAccountChange();
      }, DELAY);
  }

  summariseAdjustedAmount(){
    this.adjustedAmount = this.adjustmentData.filter(v=>v.isSelected).map(v=>v.amountToAdjust).reduce((a, b) => a + b, 0);
    this.openAmount = this.documentAmount - this.adjustedAmount;
  }

  handleClose(){
    this.dispatchEvent(new CloseActionScreenEvent());
    const detail = {
        Id: this.invokedFromObjectId ? this.invokedFromObjectId : this.recordId
    };
    this.dispatchEvent(new CustomEvent('closeclicked', { "detail": detail }));
  }

  // async handleSave(){
  //   this.missingFieldValidation()
  //   .then((isValid)=>{
  //     console.log(isValid + ' ')
  //     if (!isValid) {
  //       return this.showError('Missing required field');
  //     }else {
  //       console.log('submit')
  //       this.isLoading = true;
  //       this.template.querySelector('lightning-record-edit-form').submit();
  //     }
  //   }) 
  // }

  // missingFieldValidation() {
  //   const fields = Array.from(this.template.querySelectorAll('lightning-input-field'));
  //   console.log(fields + ' fffff');
  //   fields.forEach(f=>{
  //     console.log(f.required + ' ' + f.value + ' req val');
  //     if(f.required && f.value == null){
  //       return false;
  //     }
  //   })
  //   return true; 
  // }

  async handleSave() {
    try {
      const isValid = await this.missingFieldValidation();
      console.log(isValid + ' ');
  
      if (!isValid) {
        this.showError('Missing required field');
      } else {
        console.log('submit');
        this.isLoading = true;
        this.template.querySelector('lightning-record-edit-form').submit();
      }
    } catch (error) {
      console.error('Error in handleSave:', error);
    }
  }
  
  missingFieldValidation() {
    return new Promise((resolve) => {
      const fields = Array.from(this.template.querySelectorAll('lightning-input-field'));
      console.log(fields + ' fffff');
  
      let isValid = true;
      fields.forEach(field => {
        console.log(field.required + ' ' + field.value + ' ' + field.fieldName+' req val');
        if (field.required && (field.value === null)) {
          isValid = false;
        }
      });
  
      resolve(isValid);
    });
  }

  handlePaymentMethodChange(event){
    this.selectedPaymentOption = event.detail.name;
    this.setFieldValue('dmpl__PaymentMode__c', event.detail.name);
  }
  
  handlePaymentTypeChange(){
    this.handleAccountChange();
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