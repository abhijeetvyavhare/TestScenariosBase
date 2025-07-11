import { LightningElement, api } from 'lwc';

export default class DmplVisualPicker extends LightningElement {
    @api heading;
    @api pickerSize='small';
    @api pickerStyle='icon';
    @api isVertical = false;
    @api sourceData;
 
    get getWidgetStyle(){
        return this.isVertical ? 'slds-form-element dmpl-visual-picker'
            :'slds-form-element slds-align_absolute-center dmpl-visual-picker'
    }

    get getPickerSize() {
        return this.isVertical ? 'slds-visual-picker slds-visual-picker_vertical slds-visual-picker_medium dmpl-width-100' :
            this.pickerSize == 'small'? "slds-visual-picker slds-visual-picker_small":
            this.pickerSize == 'medium' ? "slds-visual-picker slds-visual-picker_medium":
            this.pickerSize == 'large' ? "slds-visual-picker slds-visual-picker_large":
            "slds-visual-picker slds-visual-picker_small"
    }

    get getPickerStyle(){
        return this.isIcon ? "slds-visual-picker__figure slds-visual-picker__icon slds-align_absolute-center":
            "slds-visual-picker__figure slds-visual-picker__text slds-align_absolute-center dmpl-justify_left dmpl-width-100";
    }

    get getTitleStyle(){
        return this.isVertical ? 'slds-text-heading_medium slds-m-bottom_x-small' : 'slds-text-heading_large';
    }

    get hasBody(){
        return (!this.isVertical);
    }

    get isIcon(){
        return this.pickerStyle == 'icon' && (!this.isVertical);
    }

    handleValuePicked() {
        let value = Array.from(this.template.querySelectorAll('input'))
            .find((radioButton) => radioButton.checked)?.value;
        this.fireValueChangeEvent(value);
    }

    fireValueChangeEvent(value) {
        const details = {
            value: value
        };
        this.dispatchEvent(new CustomEvent('valuechanged', { "detail":details }));
    }
}