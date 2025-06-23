import { api, LightningElement } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import DMPLDataTableResource from '@salesforce/resourceUrl/DMPLDataTable';

export default class DmplFileUpload extends LightningElement {
    @api acceptedFormats;
    @api recordId;
    @api value;
    @api valueFieldName;
    showFileUpload = false;

    renderedCallback() {
        Promise.all([
            loadStyle(this, DMPLDataTableResource),
        ]).then(() => { });
        if (!this.guid) {
            this.guid = this.template.querySelector('.fileUploadBlock')?.getAttribute('id');
            if(this.guid){
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
                            name: 'c-datatable-fileupload'
                        }
                    })
                );
            }
        }
    }

    handleUploadFinished(event) {
        const uploadedFiles = event.detail.files;
        const eventFile = new CustomEvent('fileuploaded', {
            bubbles : true,
            composed : true,
            cancellable : true,
            detail: { 
                data : {
                    relatedRecord: this.recordId,
                    files : uploadedFiles,
                    valueFieldName: this.valueFieldName
                }
            }
        });
        this.dispatchEvent(eventFile);
    }
    
    handleClick(event) {
        //event.preventDefault();
        //event.stopPropagation();
    }

    handlePreview(event) {
        event.preventDefault();
        event.stopPropagation();
        this.dispatchCustomEvent('preview', this.recordId, this.value);
    }

    handleEditClick(event) {
        event.preventDefault();
        event.stopPropagation();
        this.showFileUpload = true;
        this.dispatchCustomEvent('edit', this.recordId, this.value);
    }

    dispatchCustomEvent(eventName, relatedRecord, value, label, name) {
        this.dispatchEvent(new CustomEvent(eventName, {
            composed: true,
            bubbles: true,
            cancelable: true,
            detail: {
                data: { relatedRecord: relatedRecord, value: value, label: label, name: name }
            }
        }));
    }

    handleChange(event) {
        event.preventDefault();
        this.picklistValueChanged = true;
        this.value = event.detail.value;
        this.showFileUpload = false;
        this.dispatchCustomEvent('valuechange', this.recordId, this.value);
    }
    
    handleBlur(event) {
        event.preventDefault();
        this.showFileUpload = false;
        if (!this.picklistValueChanged)
            this.dispatchCustomEvent('customtblur', this.recordId, this.value);
    }

    reset = (relatedRecord) => {
        if (this.recordId !== relatedRecord && relatedRecord.detail != '1') {
            this.showFileUpload = false;
        }
    }
}