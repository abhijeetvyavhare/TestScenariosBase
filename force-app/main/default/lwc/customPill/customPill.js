import { LightningElement, api } from 'lwc';

export default class CustomPill extends LightningElement {
    @api label;
    @api Id;
    @api conditionName;
    @api conditionType;
    @api conditionOperator;
    @api objectName;
    @api conditionValue;

    showTooltip = false;

    handleMouseOver() {
        this.showTooltip = true;
    }

    handleMouseOut() {
        this.showTooltip = false;
    }

    handleRemove(event) {
        const payload = {
            id: this.Id,
            name: this.conditionName
        };
        this.dispatchEvent(new CustomEvent('remove', {
            detail: payload
        }));
    }
}