import { LightningElement,api,track,wire } from 'lwc';
import { getRecord } from "lightning/uiRecordApi";
import { NavigationMixin } from 'lightning/navigation';
import getGSTR1_Summary_Detail from '@salesforce/apex/PaymentHelper.getGSTR1_Summary_Detail';

export default class GSTR1_component extends NavigationMixin(LightningElement) {
    @api strTitle;
    @api objectName;
    @api recordId;
    @api financeFieldLookupAPI;
    @api type;
    @track GSTR1_Summary_Detail=[];
    // @track sumTaxableValue=0;
    // @track sumIntegretedTax=0;
    // @track sumCentralTax=0;
    // @track sumStateTax=0;
    // @track sumCess=0;

    // @track renderColumns = [];
    // @track renderData = [];
    // typeThreeColumns = [{ columnName : 'Col1', class : ''}];

    // connectedCallback()
    // {
    //   if(this.type === "3.1")
    //   {
    //     this.renderColumns = [...typeThreeColumns];
    //   }
    // }
    @wire(getRecord, { recordId: '$recordId', fields: ['Name'], layoutTypes: ['Full'], modes: ['View'] })
    handleReceivedRecordInfo({ error, data }) {
        if (data) {
            getGSTR1_Summary_Detail({recordId:this.recordId , type:this.type}).then(response => {
                console.log("received sale invoices for ->>"+ response);
                response.forEach(element => {
                //   this.sumTaxableValue = +this.sumTaxableValue +element.dmpl__TaxableValue__c;

                  this.GSTR1_Summary_Detail.push(element);
                });
                // this.renderData.push({ col1 : })
              }).catch(error => {
                console.log("failed to load the sale invoices -> ", error);
              })
        

        }
        else if (error) {
            console.log(error);
        }
    };
    get getViewAllLink() {
        if (this.isCommunityPage)
            return '/dealer/s/relatedlist/' + this.recordId + '/dmpl__GSTR1Summary__r';
        else
            return '/lightning/r/dmpl__TimeSheet__c/' + this.recordId + '/related/dmpl__GSTR1Summary__r/view';
    }

    get showOtherDetails() {
      return this.type == "Other Details (Summary Level)"
    }

    get showAmendmentsDetails() {
        return this.type == "Amendment Details"
      }

    get showInvoiceLevelDetails() {
      return this.type == "Invoice Level Details"
    }




}