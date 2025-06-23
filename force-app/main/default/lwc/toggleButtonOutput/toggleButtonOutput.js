import { LightningElement, api } from 'lwc';

export default class ToggleButtonOutput extends LightningElement {
    @api checked = false;
    @api buttonDisabled = false;
    @api rowId;
    @api fieldApiName;

    handleToggle(e) {
        const event = CustomEvent('selectedrec', {
            composed: true,
            bubbles: true,
            cancelable: true,
            detail: {
                value: { rowId: this.rowId, fieldApiName : this.fieldApiName, state: e.target.checked },
                data: { relatedRecord: this.relatedRecord, value: e.target.checked, label: this.label, fieldApiName: this.fieldApiName}
            }
        });
        this.dispatchEvent(event);
    }

    get getInactiveMsg(){
        return this.buttonDisabled?'Disabled':'Not Selected';
    }
}