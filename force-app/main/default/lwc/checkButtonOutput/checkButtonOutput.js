import { LightningElement, api } from 'lwc';

export default class CheckButtonOutput extends LightningElement {
    @api checked = false;
    @api buttonDisabled = false;
    @api rowId;

    handleToggle(e) {
        const event = CustomEvent('selectedrec', {
            composed: true,
            bubbles: true,
            cancelable: true,
            detail: {
                value: { rowId: this.rowId, state: e.target.checked }
            },
        });
        this.dispatchEvent(event);
        e.target.checked = false;
    }

    get getInactiveMsg(){
        return this.buttonDisabled?'Disabled':'Not Selected';
    }
}