import { api, LightningElement } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import DMPLDataTableResource from '@salesforce/resourceUrl/DMPLDataTable';
export default class DmplPicklist extends LightningElement {
    @api label;
    @api placeholder;
    @api options;
    @api value;
    @api relatedRecord;
    @api variant;
    @api name;
    @api valueFieldName;
    showPicklist = false;
    picklistValueChanged = false;

    renderedCallback() {
        Promise.all([
            loadStyle(this, DMPLDataTableResource),
        ]).then(() => { });
        if (!this.guid) {
            this.guid = this.template.querySelector('.picklistBlock').getAttribute('id');
            this.dispatchEvent(
                new CustomEvent('itemregister', {
                    bubbles: true,
                    composed: true,
                    detail: {
                        callbacks: {
                            reset: this.reset,
                        },
                        template: this.template,
                        guid: this.guid,
                        name: 'c-datatable-picklist'
                    }
                })
            );
        }
    }

    dispatchCustomEvent(eventName, relatedRecord, value, label, name) {
        this.dispatchEvent(new CustomEvent(eventName, {
            composed: true,
            bubbles: true,
            cancelable: true,
            detail: {
                data: { relatedRecord: relatedRecord, value: value, label: label, name: name,  valueFieldName: this.valueFieldName}
            }
        }));
    }

    handleChange(event) {
        event.preventDefault();
        this.picklistValueChanged = true;
        this.value = event.detail.value;
        this.showPicklist = false;
        this.dispatchCustomEvent('valuechange', this.relatedRecord, this.value, this.label, this.name);
    }
   
    handleClick(event) {
        event.preventDefault();
        event.stopPropagation();
        this.showPicklist = true;
        this.dispatchCustomEvent('edit', this.relatedRecord, this.value, this.label, this.name);
    }
    
    handleBlur(event) {
        event.preventDefault();
        this.showPicklist = false;
        if (!this.picklistValueChanged)
            this.dispatchCustomEvent('customtblur', this.relatedRecord, this.value, this.label, this.name);
    }

 

    reset = (relatedRecord) => {
        if (this.relatedRecord !== relatedRecord) {
            this.showPicklist = false;
        }
    }
}