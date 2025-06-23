import { api, LightningElement } from 'lwc';
export default class DmplDataTableLookup extends LightningElement {
    @api label;
    @api relatedRecord;
    @api valueFieldName;
    @api value;
    showPicklist = false;
    lookupFieldApiName;

    renderedCallback() {
        if (!this.lookupFieldApiName) {
            this.lookupFieldApiName = this.valueFieldName ? this.valueFieldName.split('.')[0].replace('__r','__c') : undefined;
        }
    }
   
    handleClick(event) {
        event.preventDefault();
        event.stopPropagation();
        this.showPicklist = true;
        this.dispatchCustomEvent('edit', this.relatedRecord, this.value, this.label, this.name);
    }
    
    handleSave(event) {
        this.template.querySelector('lightning-record-edit-form').submit(event.detail.fields);
    }
    
    handleSuccess(event){
        this.showPicklist = false;
    }

    handleClose(event){
        this.showPicklist = false;
    }
}