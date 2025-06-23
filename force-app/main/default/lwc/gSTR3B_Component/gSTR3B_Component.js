import { LightningElement, api, track, wire } from 'lwc';
import { getRecord } from "lightning/uiRecordApi";
import { NavigationMixin } from 'lightning/navigation';
import getSaleOrderTax from '@salesforce/apex/PaymentHelper.getSaleOrderTax';

export default class GSTR3B extends NavigationMixin(LightningElement) {
  @api strTitle;
  @api objectName;
  @api recordId;
  @api financeFieldLookupAPI;
  @api type;
  @track taxSaleOrder = [];
  @track sumTaxableValue = 0;
  @track sumIntegretedTax = 0;
  @track sumCentralTax = 0;
  @track sumStateTax = 0;
  @track sumCess = 0;
  @wire(getRecord, { recordId: '$recordId', fields: ['Name'], layoutTypes: ['Full'], modes: ['View'] })
  handleReceivedRecordInfo({ error, data }) {
    if (data) {
      getSaleOrderTax({ recordId: this.recordId, type: this.type }).then(response => {
        response.forEach(element => {
          this.sumTaxableValue = + (this.sumTaxableValue ?? 0) + (element.dmpl__TaxableValue__c ?? 0);
          this.sumIntegretedTax = +(this.sumIntegretedTax ?? 0) + (element.dmpl__IntegratedTax__c ?? 0);
          this.sumCentralTax = +(this.sumCentralTax ?? 0) + (element.dmpl__CentralTax__c ?? 0);
          this.sumStateTax = +(this.sumStateTax ?? 0) + (element.dmpl__StateUTTax__c ?? 0);
          this.sumCess = +(this.sumCess ?? 0) + (element.dmpl__Cess__c ?? 0);
          // this.taxSaleOrder.push(element);
        });
        if (this.showRegion3_3) {
          let internalResult = [];
          let distinctGroupNames = [];
          response.forEach((element) => {
            if (!distinctGroupNames.includes(element.dmpl__GST3BTableDetails__c))
              distinctGroupNames.push(element.dmpl__GST3BTableDetails__c);
          })

          distinctGroupNames.forEach((groupName) => {
            let groupWiseRecords = { GroupName: groupName, RelatedRecords: [] };
            response.forEach((element) => {
              if (element.dmpl__GST3BTableDetails__c === groupName)
                groupWiseRecords.RelatedRecords.push(element);
            })
            internalResult.push(groupWiseRecords);
          })

          this.taxSaleOrder = [...internalResult];
          console.log('DATA ', internalResult);
        } else {
          this.taxSaleOrder = [...response];
          // response.forEach(element => {
          //   this.sumTaxableValue = +this.sumTaxableValue + element.dmpl__TaxableValue__c;
          //   this.sumIntegretedTax = +this.sumIntegretedTax + element.dmpl__IntegratedTax__c;
          //   this.sumCentralTax = +this.sumCentralTax + element.dmpl__CentralTax__c;
          //   this.sumStateTax = +this.sumStateTax + element.dmpl__StateUTTax__c;
          //   this.sumCess = +this.sumCess + element.dmpl__Cess__c;
          //   this.taxSaleOrder.push(element);
          // });
        }


      }).catch(error => {
        console.log("failed to load the sale invoices -> ", error);
      })


    }
    else if (error) {
      console.log(error);
    }
  };

  get showRegion3_1() {
    return this.type == "3.1"
  }

  get showRegion3_2() {
    return this.type == "3.2"
  }

  get showRegion3_3() {
    return this.type == "4"
  }

  get viewAllLink() {
    return '/lightning/r/dmpl__GSTR3B__c/' + this.recordId + '/related/dmpl__GSTR3BSummary__r/view';
  }
}