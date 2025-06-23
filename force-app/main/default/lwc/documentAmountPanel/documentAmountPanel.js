import { LightningElement, api, wire, track } from 'lwc';
import { getRecord } from "lightning/uiRecordApi";
import { NavigationMixin } from 'lightning/navigation';
import { refreshApex } from '@salesforce/apex';
import {subscribe, unsubscribe, MessageContext} from 'lightning/messageService';
import FORM_FACTOR from '@salesforce/client/formFactor';
import { reduceErrors } from 'c/utils';
import FORCEREFRESHMC from '@salesforce/messageChannel/ForceReset__c';
import getDocumentAmounts from '@salesforce/apex/DocumentAmountPanelController.getDocumentAmounts';
import totalAmountLabel from '@salesforce/label/c.DocumentAmountPanel_PaymentTotalLabel';
import outstandingLabel from '@salesforce/label/c.DocumentAmountPanel_OutstandingLabel';
import roundOffLabel from '@salesforce/label/c.DocumentAmountPanel_RoundOffLabel';
import noPaymentsDoneMessage from '@salesforce/label/c.DocumentAmountPanel_NoPaymentsDoneMessage';

const OBJECT_PAYMENT = 'dmpl__Payment__c'; 
const OBJECT_FINANCECASE = 'dmpl__FinanceCase__c';
const OBJECT_SALEORDER = 'dmpl__SaleOrder__c'; 
const OBJECT_SALEINVOICE = 'dmpl__SaleInvoice__c'; 
const FIELD_PARTNERACCOUNTID = 'dmpl__PartnerAccountId__c';
const FIELD_BRANCHID = 'dmpl__BranchId__c';
const FIELD_ACCOUNTID = 'dmpl__AccountId__c';
const FIELD_SALEORDERID = 'dmpl__SaleOrderId__c';
const FIELD_SALEINVOICEID = 'dmpl__SaleInvoiceId__c';
const FIELD_PAYMENTTYPE = 'dmpl__PaymentType__c';

export default class DocumentAmountPanel extends NavigationMixin(LightningElement) {
    @api recordId;
    @api objectApiName;
    @api objectApiFieldName;

    @api title;
    @api showNewPaymentAction;
    @api showNewFinanceCaseAction;
    @api documentAmountHeading;
    @api showLineSubtotalRow;
    @api lineSubtotalTitle
    @api lineSubtotalFieldName;    
    @api headerAccountFieldName;    
    @api showDocumentTotalRow;
    @api documentTotalTitle
    @api documentTotalFieldName;
    @api showOutstandingAmountRow;
    @api outstandingAmountFieldName;
    @api paymentTotalFieldName;
    @api showTaxes;
    @api showDiscounts;
    @api showRoundOff;
    @api roundOffFieldName;
    @api paymentAmountHeading;
    @api showPaymentLines;
    @api showFinanceCaseLines;
    @api discountAmountTitle;
    @api schemeDiscountAmountTitle;
    @api discountAmountFieldName;
    @api schemeDiscountAmountFieldName;
    @api paymentButtonType = 'PaymentTaken';
    @track isRendered;
    @track recordFields;
    
    customLabel = {
        totalAmountLabel,
        noPaymentsDoneMessage,
        outstandingLabel,
        roundOffLabel
    }
    financePageUrl;
    paymentPageUrl;
    amountComponents;


    @wire(getRecord, { 
        recordId: '$recordId',  
        fields: '$recordFields'})
    getRecordDetails;

    @wire(getDocumentAmounts, { 
        objectApiName: '$objectApiName', 
        recordId: '$recordId', 
        components : '$amountComponents' })
    getDocumentAmounts;

    @wire(MessageContext)
    messageContext;

    get isLoaded(){
        return this.isRendered ||
        (this.getDocumentAmounts.data || this.getDocumentAmounts.error)
        && (this.getRecordDetails.data || this.getRecordDetails.error);
    }

    get getLineSubTotal() {
        if(this.getRecordDetails.data && this.getRecordDetails.data.fields[this.lineSubtotalFieldName])
            return this.getRecordDetails.data.fields[this.lineSubtotalFieldName].displayValue;
    }

    get getDocumentTaxes() {
        if(this.getDocumentAmounts.data && this.getDocumentAmounts.data.documentTaxes)
            return this.getDocumentAmounts.data.documentTaxes
                .filter(f => f.TaxGroupType == 'Document Level')
                .map(v=>{
                    let newV = Object.assign({}, v)
                    newV['sign'] = v.TaxAmount < 0 ? '-' : "+";
                    newV.TaxAmount = Math.abs(v.TaxAmount);
                    return newV;
                });
    }
    
    get getDocumentLineTaxes() {
        if(this.getDocumentAmounts.data && this.getDocumentAmounts.data.documentTaxes)
            return this.getDocumentAmounts.data.documentTaxes
                .filter(f=>f.TaxGroupType != 'Document Level')
                .map(v=>{
                    let newV = Object.assign({}, v)
                    newV['sign'] = v.TaxAmount < 0 ? '-' : "+";
                    newV.TaxAmount = Math.abs(v.TaxAmount);
                    return newV;
                });
    }

    get getDocumentPayments(){
        if(this.getDocumentAmounts?.data?.documentPayments)
            return this.insertPaymentLink(this.getDocumentAmounts.data.documentPayments);
    }

    get getDocumentAdjustments(){
        if(this.getDocumentAmounts.data){
            let adjustments = this.getDocumentAmounts.data.documentAdjustments;
            let payments = this.getDocumentAmounts?.data?.documentPayments;
            if(payments){
                adjustments = adjustments.filter(v=> payments.find(y => y.Id == v.dmpl__PaymentId__c) == undefined);
            }
            adjustments = adjustments.filter(v=> 
                !((v.dmpl__SaleInvoiceId__c && v.dmpl__SaleOrderId__c == this.recordId)
                || (v.dmpl__BillId__c && v.dmpl__PurchaseOrderId__c == this.recordId)));
            return this.insertAdjustmentLink(adjustments.map(a=>{
                let document = Object.assign({}, a);
                if(a.dmpl__BillId__c && a.dmpl__BillId__c != this.recordId){
                    document.documentName = a.dmpl__BillId__r?.Name;
                    document.documentType = 'Bill';
                    document.documentId = a.dmpl__BillId__c;
                }else if(a.dmpl__CreditNoteId__c && a.dmpl__CreditNoteId__c != this.recordId){ 
                    document.documentName = a.dmpl__CreditNoteId__r?.Name;
                    document.documentType = 'Credit Note';
                    document.documentId = a.dmpl__CreditNoteId__c;
                }else if(a.dmpl__DebitNoteId__c && a.dmpl__DebitNoteId__c != this.recordId){
                    document.documentName = a.dmpl__DebitNoteId__r?.Name;
                    document.documentType = 'Debit Note';
                    document.documentId = a.dmpl__DebitNoteId__c;
                }else if(a.dmpl__PaymentId__c && a.dmpl__PaymentId__c != this.recordId){
                    document.documentName = a.dmpl__PaymentId__r?.Name;
                    document.documentType = 'Payment';
                    document.documentId = a.dmpl__PaymentId__c;
                }else if(a.dmpl__PurchaseOrderId__c && a.dmpl__PurchaseOrderId__c != this.recordId){
                    document.documentName = a.dmpl__PurchaseOrderId__r?.Name;
                    document.documentType = 'Purchase Order';
                    document.documentId = a.dmpl__PurchaseOrderId__c;
                }else if(a.dmpl__RepairOrderId__c && a.dmpl__RepairOrderId__c != this.recordId){
                    document.documentName = a.dmpl__RepairOrderId__r?.Name;
                    document.documentType = 'Repair Order';
                    document.documentId = a.dmpl__RepairOrderId__c;
                }else if(a.dmpl__SaleInvoiceId__c && a.dmpl__SaleInvoiceId__c != this.recordId){
                    document.documentName = a.dmpl__SaleInvoiceId__r?.Name;
                    document.documentType = 'Invoice';
                    document.documentId = a.dmpl__SaleInvoiceId__c;
                }else if(a.dmpl__SaleOrderId__c && a.dmpl__SaleOrderId__c != this.recordId){
                    document.documentName = a.dmpl__SaleOrderId__r?.Name;
                    document.documentType = 'Sale Order';
                    document.documentId = a.dmpl__SaleOrderId__c;
                } else {
                    document.documentName = a.Name;
                    document.documentType = 'Adjustment';
                    document.documentId = a.Id;
                }
                return document;
            }));
        }
    }

    get getDocumentFinanceCases(){
        if(this.getDocumentAmounts.data?.documentFinanceCases)
            return this.insertFinanceCaseLink(this.getDocumentAmounts.data.documentFinanceCases);
    }

    get getShowNoDataIllustration(){
        return this.getPaymentSectionVisibility && (!this.getPaymentsDataExists);
    }

    get getPaymentsDataExists(){
        return this.getPaymentSectionVisibility && (this.getDocumentAmounts.data?.documentFinanceCases && this.getDocumentAmounts.data?.documentFinanceCases.length > 0
            || this.getDocumentAmounts.data?.documentPayments && this.getDocumentAmounts.data?.documentPayments.length > 0);
    }
    
    get getDocumentTotal() {
        if(this.getRecordDetails.data && this.getRecordDetails.data.fields[this.documentTotalFieldName]){
            if(this.documentAmount != this.getRecordDetails.data.fields[this.documentTotalFieldName].value){
                this.documentAmount = this.getRecordDetails.data.fields[this.documentTotalFieldName].value;
                this.handleForceRefresh({});
            }
            return this.getRecordDetails.data.fields[this.documentTotalFieldName].displayValue;
        }
    }

    get getPaymentTotal() {
        if(this.getRecordDetails.data && this.getRecordDetails.data.fields[this.paymentTotalFieldName])
            return this.getRecordDetails.data.fields[this.paymentTotalFieldName].displayValue;
    }
    
    get getOutstandingAmount() {
        if(this.getRecordDetails.data && this.getRecordDetails.data.fields[this.outstandingAmountFieldName])
            return this.getRecordDetails.data.fields[this.outstandingAmountFieldName].displayValue;
    }

    get getDiscountAmount() {
        if(this.getRecordDetails.data && this.getRecordDetails.data.fields[this.discountAmountFieldName])
            return this.getRecordDetails.data.fields[this.discountAmountFieldName].value;
    }

    get getRoundOffAmount(){
        if(this.getRecordDetails.data && this.getRecordDetails.data.fields[this.roundOffFieldName])
            return this.getRecordDetails.data.fields[this.roundOffFieldName].value;
    }

    get getSchemeDiscountAmount() {
        if(this.getRecordDetails.data && this.getRecordDetails.data.fields[this.schemeDiscountAmountFieldName])
            return this.getRecordDetails.data.fields[this.schemeDiscountAmountFieldName].value;
    }

    get getPartnerAccountId() {
        if(this.getRecordDetails.data && this.getRecordDetails.data.fields[FIELD_PARTNERACCOUNTID])
            return this.getRecordDetails.data.fields[FIELD_PARTNERACCOUNTID].value;
    }

    get getBranchId() {
        if(this.getRecordDetails.data && this.getRecordDetails.data.fields[FIELD_BRANCHID])
            return this.getRecordDetails.data.fields[FIELD_BRANCHID].value;
    }

    get getAccountId() {
        if(this.getRecordDetails.data && this.getRecordDetails.data.fields[this.headerAccountFieldName])
            return this.getRecordDetails.data.fields[this.headerAccountFieldName].value;
    }

    get getHostObjectFieldName() {
        return this.objectApiFieldName;
    }
    
    get getDocumentSectionVisibility() {
        return this.showDocumentTotalRow || this.showLineSubtotalRow || this.showTaxes;
    }

    get getPaymentSectionVisibility() {
        return (this.showPaymentLines || this.showFinanceCaseLines) && (this.getDocumentAmounts.data?.documentFinanceCases && this.getDocumentAmounts.data?.documentFinanceCases.length > 0
            || this.getDocumentAmounts.data?.documentPayments && this.getDocumentAmounts.data?.documentPayments.length > 0
            || this.getDocumentAmounts.data?.documentAdjustments && this.getDocumentAmounts.data?.documentAdjustments.length > 0);
    }

    get getOutstandingSectionVisibility() {
        return this.showOutstandingAmountRowRed || this.showOutstandingAmountRowGreen;
    }

    get showOutstandingAmountRowRed() {
        return this.showOutstandingAmountRow 
        && this.getRecordDetails.data 
        && this.getRecordDetails.data.fields[this.outstandingAmountFieldName]
        && (this.getRecordDetails.data.fields[this.outstandingAmountFieldName].value >0);
    }
    
    get showOutstandingAmountRowGreen() {
        return this.showOutstandingAmountRow 
            && this.getRecordDetails.data 
            && this.getRecordDetails.data.fields[this.outstandingAmountFieldName]
            && (this.getRecordDetails.data.fields[this.outstandingAmountFieldName].value <=0);
    }
    
    get isMobileView(){
        return FORM_FACTOR == 'Small';
    } 

    connectedCallback(){
        if(this.objectApiName == undefined){
            this.objectApiName = '';
        }
        let fields= [this.objectApiName.concat('.', FIELD_PARTNERACCOUNTID),
            this.objectApiName.concat('.', FIELD_BRANCHID)
        ];   
        if(this.headerAccountFieldName){
            fields.push(this.objectApiName.concat('.', this.headerAccountFieldName));
        }
        if(this.showLineSubtotalRow && this.lineSubtotalFieldName){
            fields.push(this.objectApiName.concat('.', this.lineSubtotalFieldName));
        }
        if(this.showDocumentTotalRow && this.documentTotalFieldName){
            fields.push(this.objectApiName.concat('.', this.documentTotalFieldName));
        }
        if(this.showOutstandingAmountRow && this.outstandingAmountFieldName){
            fields.push(this.objectApiName.concat('.', this.outstandingAmountFieldName));
        }
        if((this.showPaymentLines || this.showFinanceCaseLines) && this.paymentTotalFieldName){
            fields.push(this.objectApiName.concat('.', this.paymentTotalFieldName));
        }
        if(this.showDiscounts  && this.discountAmountFieldName){
            fields.push(this.objectApiName.concat('.', this.discountAmountFieldName));
        }
        if(this.showDiscounts  && this.schemeDiscountAmountFieldName){
            fields.push(this.objectApiName.concat('.', this.schemeDiscountAmountFieldName));
        }
        if(this.showRoundOff  && this.roundOffFieldName){
            fields.push(this.objectApiName.concat('.', this.roundOffFieldName));
        }
        this.recordFields = fields;

        let components =[];
        if(this.showPaymentLines){
            components.push('DocumentPayments');
            components.push('DocumentAdjustments');
        }
        if(this.showFinanceCaseLines){
            components.push('DocumentFinanceCases');
        }
        if(this.showTaxes){
            components.push('DocumentTaxes');
        }
        this.amountComponents = components;

        this.subscription = subscribe(
            this.messageContext,
            FORCEREFRESHMC,
            (message) => {
                this.handleForceRefresh(message);
            }
        );
        this.generatePageReference();
    }

    disconnectedCallback() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }

    renderedCallback(){
        this.hasError = (!this.getRecordDetails.data)
            || this.getDocumentAmounts.data;
        if(this.hasError){
            this.error = reduceErrors(this.getRecordDetails.error) + reduceErrors(this.getDocumentAmounts.error);
        }
        this.isRendered = true;
    }
    
    handleForceRefresh(message) {
        refreshApex(this.getDocumentAmounts);
    }
    
    handleHeaderTaxClick(event){
        event.preventDefault();
        event.stopPropagation();
        this[NavigationMixin.Navigate]({
            type : 'standard__webPage',
            attributes: {
                url: '/lightning/action/quick/'
                    + this.objectApiName
                    +'.dmpl__DMSUpdateHeaderTax?objectApiName&context=RECORD_DETAIL&recordId='
                    + this.recordId 
                    + '&backgroundContext=%2Flightning%2Fr%2F'
                    + this.objectApiName 
                    +'%2F'+ this.recordId+'%2Fview'
            },
        });
    }
    
    handleDiscountAmountClick(event){
        event.preventDefault();
        event.stopPropagation();
        this[NavigationMixin.Navigate]({
            type : 'standard__webPage',
            attributes: {
                url: '/lightning/action/quick/'
                    + this.objectApiName
                    +'.dmpl__DMSUpdateHeaderDiscount?objectApiName&context=RECORD_DETAIL&recordId='
                    + this.recordId 
                    + '&backgroundContext=%2Flightning%2Fr%2F'
                    + this.objectApiName 
                    +'%2F'+ this.recordId+'%2Fview'
            },
        });
    }

    handleNewPaymentClick(evt) {
        evt.preventDefault();
        evt.stopPropagation();
        let paymentPageRef = {
            type: 'standard__objectPage',
            attributes: {
                objectApiName: OBJECT_PAYMENT,
                actionName: 'new'
            },
            state: {
                defaultFieldValues : this.isMobileView 
                    ? undefined
                    : `${this.getHostObjectFieldName}=${this.recordId},${FIELD_PARTNERACCOUNTID}=${this.getPartnerAccountId},${FIELD_BRANCHID}=${this.getBranchId},${FIELD_ACCOUNTID}=${this.getAccountId},${FIELD_PAYMENTTYPE}=${this.paymentButtonType}`
            }
        };
        this[NavigationMixin.Navigate](paymentPageRef);
    }

    handleNewFinanceCaseClick(evt) {
        evt.preventDefault();
        evt.stopPropagation();
        let paymentPageRef = {
            type: 'standard__objectPage',
            attributes: {
                objectApiName: OBJECT_FINANCECASE,
                actionName: 'new'
            },
            state: {
                defaultFieldValues : `${this.getHostObjectFieldName}=${this.recordId},${FIELD_PARTNERACCOUNTID}=${this.getPartnerAccountId},${FIELD_BRANCHID}=${this.getBranchId},${FIELD_ACCOUNTID}=${this.getAccountId}`
            }
        };
        this[NavigationMixin.Navigate](paymentPageRef);
    }
    
    handleNewPaymentAdjustmentClick(evt){
        this[NavigationMixin.Navigate]({
            type : 'standard__webPage',
            attributes: {
                url: '/lightning/action/quick/'
                    + this.objectApiName
                    +'.dmpl__DMSPaymentAdjustments?objectApiName&context=RECORD_DETAIL&recordId='
                    + this.recordId 
                    + '&backgroundContext=%2Flightning%2Fr%2F'
                    + this.objectApiName 
                    +'%2F'+ this.recordId+'%2Fview'
            },
        });
    }

    insertPaymentLink(data){
        data = JSON.parse(JSON.stringify(data));
        if(!this.paymentPageUrl){
            this.generatePageReference()
        }
        return data.slice().map(draft => {
            let payment = Object.assign({}, draft)
            payment.recordLink = this.paymentPageUrl?.replace('recordId', draft.Id);
            return payment;          
        });
    }

    insertAdjustmentLink(data){
        data = JSON.parse(JSON.stringify(data));
        if(!this.adjustmentPageUrl){
            this.generatePageReference()
        }
        return data.slice().map(draft => {
            let adjustment = Object.assign({}, draft)
            adjustment.recordLink = this.adjustmentPageUrl?.replace('recordId', draft.documentId);
            return adjustment;          
        });
    }

    insertFinanceCaseLink(data){
        if(!this.financePageUrl){
            this.generatePageReference()
        }
        data = JSON.parse(JSON.stringify(data));
        return data.slice().map(draft => {
            let fc = Object.assign({}, draft)
            fc.FinancerName = draft.dmpl__FinanceProviderId__r?draft.dmpl__FinanceProviderId__r.Name:undefined;
            fc.recordLink = this.financePageUrl?.replace('recordId', draft.Id);
            return fc;
        });
    }

    generatePageReference(){
        let paymentPageRef = {
            type: 'standard__recordPage',
            attributes: {
                recordId: 'recordId',
                objectApiName: OBJECT_PAYMENT,
                actionName: 'view'
            }
        };
        this[NavigationMixin.GenerateUrl](paymentPageRef)
            .then((url) =>  {this.paymentPageUrl = url}); 

        let fcPageRef = {
            type: 'standard__recordPage',
            attributes: {
                recordId: 'recordId',
                objectApiName: OBJECT_FINANCECASE,
                actionName: 'view'
            }
        };
        this[NavigationMixin.GenerateUrl](fcPageRef)
            .then((url) =>  {this.financePageUrl = url});    

        let adjustmentPageUrl = {
            type: 'standard__recordPage',
            attributes: {
                recordId: 'recordId',
                objectApiName: 'dmpl__PaymentAdjustment__c',
                actionName: 'view'
            }
        };
        this[NavigationMixin.GenerateUrl](adjustmentPageUrl)
            .then((url) =>  {this.adjustmentPageUrl = url});    
    }
}